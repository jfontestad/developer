import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';

/** Wire adapter to load records, utils to extract values. */
import { getRecord } from 'lightning/uiRecordApi';

/** Pub-sub mechanism for sibling component communication. */
import { registerListener, unregisterAllListeners } from 'c/pubsub';

/** Product__c Schema. */
import PRODUCT_OBJECT from '@salesforce/schema/Data_Set__c';
import NAME_FIELD from '@salesforce/schema/Data_Set__c.Name';
import DESCRIPTION_FIELD from '@salesforce/schema/Data_Set__c.Description__c';
import FREQUENCY_FIELD from '@salesforce/schema/Data_Set__c.Frequency__c';
import REGIONS_FIELD from '@salesforce/schema/Data_Set__c.Regions__c';
import STATUS_FIELD from '@salesforce/schema/Data_Set__c.Status__c';
import PICTURE_URL_FIELD from '@salesforce/schema/Data_Set__c.Picture_URL__c';

/** Record fields to load. */
const fields = [
    NAME_FIELD,
    PICTURE_URL_FIELD,
    DESCRIPTION_FIELD,
    REGIONS_FIELD,
    FREQUENCY_FIELD,
    STATUS_FIELD
    
];

/**
 * Component to display details of a Product__c.
 */
export default class DatasetCard extends NavigationMixin(LightningElement) {
    /** Id of Product__c to display. */
    recordId;

    @wire(CurrentPageReference) pageRef;

    /** Load the Product__c to display. */
    @wire(getRecord, { recordId: '$recordId', fields })
    dataset;

    connectedCallback() {
        registerListener('datasetSelected', this.handleDatasetSelected, this);
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    /**
     * Handler for when a product is selected. When `this.recordId` changes, the @wire
     * above will detect the change and provision new data.
     */
    handleDatasetSelected(datasetId) {
        this.recordId = datasetId;
    }

    handleNavigateToRecord() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: PRODUCT_OBJECT.objectApiName,
                actionName: 'view'
            }
        });
    }

    get noData() {
        return !this.dataset.error && !this.dataset.data;
    }
}