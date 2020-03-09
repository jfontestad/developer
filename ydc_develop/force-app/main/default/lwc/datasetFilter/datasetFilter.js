/* eslint-disable no-console */
import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import REGIONS_FIELD from '@salesforce/schema/Data_Set__c.Regions__c';
import Frequency_FIELD from '@salesforce/schema/Data_Set__c.Frequency__c'
// import MATERIAL_FIELD from '@salesforce/schema/Product__c.Material__c';

/** Pub-sub mechanism for sibling component communication. */
import { fireEvent } from 'c/pubsub';

/** The delay used when debouncing event handlers before firing the event. */
const DELAY = 350;

/**
 * Displays a filter panel to search for Product__c[].
 */
export default class DatasetFilter extends LightningElement {
    searchKey = '';
    maxPrice = 10000;

    filters = {
        searchKey: '',
        maxPrice: 10000
    };

    @wire(CurrentPageReference) pageRef;

    @wire(getPicklistValues, {
        recordTypeId: '012000000000000AAA',
        fieldApiName: REGIONS_FIELD
    })
    regions;

    @wire(getPicklistValues, {
        recordTypeId: '012000000000000AAA',
        fieldApiName: Frequency_FIELD
    })
    frequencies;

    

    handleSearchKeyChange(event) {
        this.filters.searchKey = event.target.value;
        this.delayedFireFilterChangeEvent();
    }

    handleCheckboxChange(event) {
        if (!this.filters.regions ) {
            this.filters.regions = [];
          
        }
        const value = event.target.dataset.value;
        console.log('value is ' + value);
        console.log(event.target.checked);
        console.log(this.filters.regions);
        if (event.target.checked) {
            this.filters.regions.push(value);
        } else {
            this.filters.regions = this.filters.regions.filter(e => e !== value);
        }
        if (this.filters.regions.length === 0) {
            delete this.filters.regions;
        }
        fireEvent(this.pageRef, 'filterChange', this.filters);
    }

    handleDataTopicCheckboxChange(event) {
        if (!this.filters.frequencies ) {
            this.filters.frequencies = [];
            
        }
        const value = event.target.dataset.value;
        console.log('value is ' + value);
        console.log(event.target.checked);
        if (event.target.checked) {
            this.filters.frequencies.push(value);
        } else {
            this.filters.frequencies = this.filters.frequencies.filter(e => e !== value);
        }
         if(this.filters.frequencies.length === 0) {
             delete this.filters.frequencies;
         console.log(this.filters.frequencies);
         }
        fireEvent(this.pageRef, 'filterChange', this.filters);
    }
    delayedFireFilterChangeEvent() {
        // Debouncing this method: Do not actually fire the event as long as this function is
        // being called within a delay of DELAY. This is to avoid a very large number of Apex
        // method calls in components listening to this event.
        window.clearTimeout(this.delayTimeout);
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            fireEvent(this.pageRef, 'filterChange', this.filters);
        }, DELAY);
    }
}