import { LightningElement, api, track } from 'lwc';

/**
 * A presentation component to display a Product__c sObject. The provided
 * Product__c data must contain all fields used by this component.
 */
export default class DatasetTile extends LightningElement {
    /** Whether the tile is draggable. */
    @api draggable;

    _dataset;
    /** Product__c to display. */
    @api
    get sfdataset() {
        return this._dataset;
    }
    set sfdataset(value) {
        this._dataset = value;
        this.pictureUrl = value.Picture_URL__c;
        this.name = value.Name;
        //this.msrp = value.MSRP__c;
    }

    /** Product__c field values to display. */
    @track pictureUrl;
    @track name;
   // @track msrp;

    handleClick() {
        const selectedEvent = new CustomEvent('selected', {
            detail: this.sfdataset.Id
        });
        this.dispatchEvent(selectedEvent);
    }

    handleDragStart(event) {
        event.dataTransfer.setData('dataset', JSON.stringify(this.sfdataset));
    }
}