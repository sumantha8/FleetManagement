import { LightningElement, track, api, wire } from 'lwc';
import YEAR_FIELD from '@salesforce/schema/Fleet__c.Year__c';
import CAPACITY_FIELD from '@salesforce/schema/Fleet__c.Maximum_Capacity__c';
import ODOMETER_FIELD from '@salesforce/schema/Fleet__c.Odometer_Reading__c';
import RESALE_FIELD from '@salesforce/schema/Fleet__c.Resale_Value__c';
import BUSID_FIELD from '@salesforce/schema/Fleet__c.Bus_ID__c';
import { getRecord } from 'lightning/uiRecordApi';

export default class FleetRecDetail extends LightningElement {
    odometer = ODOMETER_FIELD;
    year = YEAR_FIELD;
    maxCapacity = CAPACITY_FIELD;
    resaleValue = RESALE_FIELD;
    selectedFields = [YEAR_FIELD, CAPACITY_FIELD, RESALE_FIELD, ODOMETER_FIELD];
    viewSection = [BUSID_FIELD, RESALE_FIELD];
    @api recordId;
    @track showDetails = true;

    connectedCallback(){
    }
}