import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import PRODUCT_OBJECT from '@salesforce/schema/Data_Set__c';

/**
 * A presentation component to display a Product__c sObject. The provided
 * Product__c data must contain all fields used by this component.
 */
export default class DatasetListItem extends NavigationMixin(LightningElement) {
    @api sfdataset;

    /** View Details Handler to navigates to the record page */
    handleViewDetailsClick() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.sfdataset.Id,
                objectApiName: PRODUCT_OBJECT.objectApiName,
                actionName: 'view'
            }
        });
    }
}