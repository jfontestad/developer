import { createElement } from 'lwc';
import DatasetTileList from 'c/datasetTileList';
import { fireEvent } from 'c/pubsub';
import {
    registerTestWireAdapter,
    registerApexTestWireAdapter
} from '@salesforce/sfdx-lwc-jest';
import getDatasets from '@salesforce/apex/DataMarketplaceController.getDatasets';
import { CurrentPageReference } from 'lightning/navigation';

// Mock out the pubsub lib and use these mocks to verify how functions were called
jest.mock('c/pubsub', () => {
    return {
        fireEvent: jest.fn(),
        registerListener: jest.fn(),
        unregisterAllListeners: jest.fn()
    };
});

// Realistic data with multiple records
const mockGetDatasets = require('./data/getDatasets.json');
// An empty list of records to verify the component does something reasonable
// when there is no data to display
const mockGetDatasetsNoRecords = require('./data/getDatasetsNoRecords.json');

// Register the Apex wire adapter. Some tests verify that provisioned values trigger desired behavior.
const getDatasetsAdapter = registerApexTestWireAdapter(getDatasets);

// Register as a standard wire adapter because the component under test requires this adapter.
// We don't exercise this wire adapter in the tests.
registerTestWireAdapter(CurrentPageReference);

describe('c-dataset-tile-list', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    describe('getDatasets @wire emits records', () => {
        it('renders paginator with correct item counts', () => {
            const element = createElement('c-dataset-tile-list', {
                is: DatasetTileList
            });
            document.body.appendChild(element);
            getDatasetsAdapter.emit(mockGetDatasets);

            // Return a promise to wait for any asynchronous DOM updates.
            return Promise.resolve().then(() => {
                const paginator = element.shadowRoot.querySelector(
                    'c-paginator'
                );
                expect(paginator).not.toBeNull();

                // paginator text will look something like: "12 items • page 1 of 2"
                const totalPages = Math.ceil(
                    mockGetDatasets.totalItemCount / mockGetDatasets.pageSize
                );
                const regex = new RegExp(
                    `${mockGetDatasets.totalItemCount} items(.*)page ${mockGetDatasets.pageNumber} of ${totalPages}`
                );
                expect(paginator.shadowRoot.textContent).toMatch(regex);
            });
        });

        it('increments/decrements page number when "next" and "previous" events fired', () => {
            const totalPages = Math.ceil(
                mockGetDatasets.totalItemCount / mockGetDatasets.pageSize
            );
            const element = createElement('c-dataset-tile-list', {
                is: DatasetTileList
            });
            document.body.appendChild(element);
            getDatasetsAdapter.emit(mockGetDatasets);

            return Promise.resolve()
                .then(() => {
                    const paginator = element.shadowRoot.querySelector(
                        'c-paginator'
                    );
                    paginator.dispatchEvent(new CustomEvent('next'));
                })
                .then(() => {
                    // DOM is updated after event is fired so need to wait
                    // another microtask for the rerender
                    const paginator = element.shadowRoot.querySelector(
                        'c-paginator'
                    );
                    const currentPage =
                        parseInt(mockGetDatasets.pageNumber, 10) + 1;
                    const regex = new RegExp(
                        `page ${currentPage} of ${totalPages}$`
                    );
                    expect(paginator.shadowRoot.textContent).toMatch(regex);

                    paginator.dispatchEvent(new CustomEvent('previous'));
                })
                .then(() => {
                    const paginator = element.shadowRoot.querySelector(
                        'c-paginator'
                    );
                    // we're back to the original page number now
                    const regex = new RegExp(
                        `page ${mockGetDatasets.pageNumber} of ${totalPages}$`
                    );
                    expect(paginator.shadowRoot.textContent).toMatch(regex);
                });
        });

        it('updates getDatasets @wire with new pageNumber', () => {
            const element = createElement('c-dataset-tile-list', {
                is: DatasetTileList
            });
            document.body.appendChild(element);
            getDatasetsAdapter.emit(mockGetDatasets);

            // Return a promise to wait for any asynchronous DOM updates.
            return Promise.resolve()
                .then(() => {
                    const paginator = element.shadowRoot.querySelector(
                        'c-paginator'
                    );
                    paginator.dispatchEvent(new CustomEvent('next'));
                })
                .then(() => {
                    const { pageNumber } = getDatasetsAdapter.getLastConfig();
                    // we've fired a single 'next' event so increment the original pageNumber
                    expect(pageNumber).toBe(mockGetDatasets.pageNumber + 1);
                });
        });

        it('displays one c-dataset-tile per record', () => {
            const recordCount = mockGetDatasets.records.length;
            const element = createElement('c-dataset-tile-list', {
                is: DatasetTileList
            });
            document.body.appendChild(element);
            getDatasetsAdapter.emit(mockGetDatasets);

            return Promise.resolve().then(() => {
                const datasetTiles = element.shadowRoot.querySelectorAll(
                    'c-dataset-tile'
                );
                expect(datasetTiles).toHaveLength(recordCount);
            });
        });

        it('fires datasetSelected event when c-dataset-tile selected', () => {
            const element = createElement('c-dataset-tile-list', {
                is: DatasetTileList
            });
            document.body.appendChild(element);
            getDatasetsAdapter.emit(mockGetDatasets);

            return Promise.resolve().then(() => {
                const datasetTile = element.shadowRoot.querySelector(
                    'c-dataset-tile'
                );
                datasetTile.dispatchEvent(new CustomEvent('selected'));
                expect(fireEvent).toHaveBeenCalledWith(
                    undefined,
                    'datasetSelected',
                    null
                );
            });
        });
    });

    describe('getDatasets @wire emits empty list of records', () => {
        it('does not render paginator', () => {
            const element = createElement('c-dataset-tile-list', {
                is: DatasetTileList
            });
            document.body.appendChild(element);
            getDatasetsAdapter.emit(mockGetDatasetsNoRecords);

            return Promise.resolve().then(() => {
                const paginator = element.shadowRoot.querySelector(
                    'c-paginator'
                );
                expect(paginator).toBeNull();
            });
        });

        it('renders placeholder with no datasets message', () => {
            const expected =
                'There are no datasets matching your current selection';
            const element = createElement('c-dataset-tile-list', {
                is: DatasetTileList
            });
            document.body.appendChild(element);
            getDatasetsAdapter.emit(mockGetDatasetsNoRecords);

            return Promise.resolve().then(() => {
                const placeholder = element.shadowRoot.querySelector(
                    'c-placeholder'
                );
                expect(placeholder.shadowRoot.textContent).toBe(expected);
            });
        });
    });

    describe('getDatasets @wire error', () => {
        it('shows error message element with error details populated', () => {
            // This is the default error message that gets emitted from apex
            // adapters. See @salesforce/wire-service-jest-util for the source.
            const defaultError = 'An internal server error has occurred';
            const element = createElement('c-dataset-tile-list', {
                is: DatasetTileList
            });
            document.body.appendChild(element);
            getDatasetsAdapter.error();
            return Promise.resolve()
                .then(() => {
                    const inlineMessage = element.shadowRoot.querySelector(
                        'c-inline-message'
                    );
                    // check the "Show Details" checkbox to render additional error messages
                    const lightningInput = inlineMessage.shadowRoot.querySelector(
                        'lightning-input'
                    );
                    lightningInput.checked = true;
                    lightningInput.dispatchEvent(new CustomEvent('change'));
                })
                .then(() => {
                    const inlineMessage = element.shadowRoot.querySelector(
                        'c-inline-message'
                    );
                    const text = inlineMessage.shadowRoot.textContent;
                    expect(text).toContain(defaultError);
                });
        });
    });

    describe('with search bar visible', () => {
        it('updates getDatasets @wire with searchKey as filter when search bar changes', () => {
            const input = 'foo';
            const expected = { searchKey: input };
            const element = createElement('c-dataset-tile-list', {
                is: DatasetTileList
            });
            element.searchBarIsVisible = true;
            document.body.appendChild(element);
            getDatasetsAdapter.emit(mockGetDatasets);

            return Promise.resolve()
                .then(() => {
                    const searchBar = element.shadowRoot.querySelector(
                        '.search-bar'
                    );
                    searchBar.value = input;
                    searchBar.dispatchEvent(new CustomEvent('change'));
                })
                .then(() => {
                    const { filters } = getDatasetsAdapter.getLastConfig();
                    expect(filters).toEqual(expected);
                });
        });
    });
});
