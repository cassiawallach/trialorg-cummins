import { LightningElement,wire,track,api } from 'lwc';
import {
    getRecord
} from 'lightning/uiRecordApi';
import ENGINE_FIELD from '@salesforce/schema/WorkOrder.Engine_Serial_Number__c';
import MAKE_FIELD from '@salesforce/schema/WorkOrder.Make__c';
import MODEL_FIELD from '@salesforce/schema/WorkOrder.Model__c';
import MILEAGE_FIELD from '@salesforce/schema/WorkOrder.Mileage_Measure__c';
import CODE_FIELD from '@salesforce/schema/WorkOrder.Application__c';
import DATE_FIELD from '@salesforce/schema/WorkOrder.Warranty_Start_Date__c';
import PRODUCT_MILEAGE from '@salesforce/schema/WorkOrder.Mileage__c';
import BEFORE_IN_SERVICE from '@salesforce/schema/WorkOrder.Before_In_Service__c';
import EVL_Missing_Fields_Note from '@salesforce/label/c.EVL_Missing_Fields_Note';
import EVL_Missing_Fields from '@salesforce/label/c.EVL_Missing_Fields';

export default class Conditioncheck extends LightningElement {
   @track engine = '';
    @track make = '';
    @track model = '';
    @track mileage = '';
    @track code = '';
    @track date = '';
    @track product = '';
    @track bis = false;
    @api recordId;
    @track showcond=false;

    label = {
        EVL_Missing_Fields_Note,
        EVL_Missing_Fields
      };

    @wire(getRecord, {
    recordId: '$recordId',
    fields: [ENGINE_FIELD, MAKE_FIELD, MODEL_FIELD,MILEAGE_FIELD,CODE_FIELD,DATE_FIELD,PRODUCT_MILEAGE,BEFORE_IN_SERVICE]
}) wireworkorder({
    error,
    data
}) {
    if (error) {
        this.error = error;
    } else if (data) {
        console.log('hiiii record id '+this.recordId);
        this.engine = data.fields.Engine_Serial_Number__c.value;
        this.make = data.fields.Make__c.value;
        this.model = data.fields.Model__c.value;
        this.mileage = data.fields.Mileage_Measure__c.value;
        this.code = data.fields.Application__c.value;
        this.date = data.fields.Warranty_Start_Date__c.value;
        this.product = data.fields.Mileage__c.value;
        this.bis = data.fields.Before_In_Service__c.value;
        console.log('---ProductMileage---'+this.product+'--engine--'+this.engine+'--make--'+this.make+'---model--'+this.model+'--mileage--'+this.mileage+'--code--'+this.code+'--bis--'+this.bis+'--date--'+this.date);
        if(this.engine == null || this.make ==null || this.model ==null || this.mileage == null || this.code ==null || this.product == null|| (this.bis == false && this.date ==null)){
            this.showcond = true;
            console.log('hiiii updating');
        }
    }
}
}