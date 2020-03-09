/* eslint-disable no-console */
import { LightningElement, api, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
/** getProducts() method in ProductController Apex class */
import getDatasets from '@salesforce/apex/DataMarketplaceController.getDatasets';


/** Pub-sub mechanism for sibling component communication. */
import { registerListener, unregisterAllListeners, fireEvent } from 'c/pubsub';

/**
 * Container component that loads and displays a list of Product__c records.
 */
export default class DatasetTileList extends LightningElement {
    /**
     * Whether to display the search bar.
     * TODO - normalize value because it may come as a boolean, string or otherwise.
     */
    @api searchBarIsVisible = false;

    /**
     * Whether the product tiles are draggable.
     * TODO - normalize value because it may come as a boolean, string or otherwise.
     */
    @api tilesAreDraggable = false;

    /** Current page in the product list. */
    @track pageNumber = 1;

    /** The number of items on a page. */
    @track pageSize;

    /** The total number of items matching the selection. */
    @track totalItemCount = 0;

    /** JSON.stringified version of filters to pass to apex */
    @track filters = {};

    @wire(CurrentPageReference) pageRef;

    /**
     * Load the list of available products.
     */
    @wire(getDatasets, { filters: '$filters', pageNumber: '$pageNumber' })
    datasets;

    connectedCallback() {
        registerListener('filterChange', this.handleFilterChange, this);
    }

    handleDatasetSelected(event) {
        fireEvent(this.pageRef, 'datasetSelected', event.detail);
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    handleSearchKeyChange(event) {
        this.filters = {
            searchKey: event.target.value.toLowerCase()
        };
        this.pageNumber = 1;
    }

    handleFilterChange(filters) {
        console.log('Filters are:\n' + JSON.stringify(filters));
        this.filters = { ...filters };
        console.log('this.filters are:\n' + JSON.stringify(this.filters));
        this.pageNumber = 1;
    }

    handlePreviousPage() {
        this.pageNumber = this.pageNumber - 1;
    }

    handleNextPage() {
        this.pageNumber = this.pageNumber + 1;
    }
}