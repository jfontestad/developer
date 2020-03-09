import { createElement } from 'lwc';
import DatasetTile from 'c/datasetTile';

describe('c-dataset-tile', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('dragging sets dataset as dataTransfer data', () => {
        const element = createElement('c-dataset-tile', {
            is: DatasetTile
        });
        // Emulate a DragEvent, jsdom does not implement this class yet
        const dragstartEvent = new CustomEvent('dragstart');
        dragstartEvent.dataTransfer = {
            setData: jest.fn()
        };
        const dataset = {
            Id: 1,
            Picture_URL__c: 'https://salesforce.com',
            Name: 'Foo'//,
           // MSRP__c: 1000
        };
        element.dataset = dataset;
        document.body.appendChild(element);

        const div = element.shadowRoot.querySelector('div');
        div.dispatchEvent(dragstartEvent);

        expect(dragstartEvent.dataTransfer.setData).toHaveBeenCalledWith(
            'dataset',
            JSON.stringify(dataset)
        );
    });

    it('clicking fires selected event', () => {
        const listener = jest.fn();
        const element = createElement('c-dataset-tile', {
            is: DatasetTile
        });
        element.addEventListener('selected', listener);
        element.dataset = {
            Id: 1,
            Picture_URL__c: 'https://salesforce.com',
            Name: 'Foo'//,
           // MSRP__c: 1000
        };
        document.body.appendChild(element);

        const anchor = element.shadowRoot.querySelector('a');
        anchor.click();

        expect(listener).toHaveBeenCalled();
    });
});
