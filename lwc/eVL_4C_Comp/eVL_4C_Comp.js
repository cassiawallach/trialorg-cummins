import { LightningElement, api , wire ,track } from 'lwc';
import test from '@salesforce/apex/eVL_4C_Comp.getFieldSet';
import fieldsetValue from '@salesforce/apex/eVL_4C_Comp.getFieldSetMember';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi'; //CT1-92
import STATUS_FIELD from '@salesforce/schema/WorkOrder.Status'; //CT1-92
import saveRecordsTitle from '@salesforce/label/c.EVL_Save_Records';
import waitMessage from '@salesforce/label/c.EVL_Please_Wait';


export default class EVL_4C_Comp extends LightningElement 
{//comment

    @api objectApiName;
    @api recordId;
    @api fields;
    @track allFields;
    @api name;
    @track booltf = false;
    @api fieldss = [];
    Status;

    //NIN-44
    label = {
        saveRecordsTitle,
        waitMessage
      };
    
    //CT1-92
    @wire(getRecord, { recordId: '$recordId', fields: [STATUS_FIELD] })
    wiredRecord({ error, data }) {
        if (data) {
            this.Status = getFieldValue(data, STATUS_FIELD);
            
        } else if (error) {
            console.log(error);
        }
    }
    @wire(test, {objectApiName: '$objectApiName'})
    fieldsets({ error, data }) 
    {
        if(data)
        {
           /* eslint-disable no-console */ 
          //  console.log(data[0]);
            this.fields = data[0]; // store the FieldSet name that we get from apex class
        }
        if(error)
        {
            console.log(error);
        }
    }
    
    @wire(fieldsetValue,{objectName: '$objectApiName', fieldSetName :'$fields'})
    fieldsetVal({data, error})
    {
        if(data)
        {
          
            this.allFields = data;
            data = JSON.parse(data);
            for(var i=0;i<data.length;i++)
            {
                this.fieldss.push(data[i].fieldAPIName);
            }
            
            this.booltf = true;
        }
        
        if(error)
        {
            console.log(error);
        }
    }

    handleSubmit()
    {
       
        if(this.Status === 'Closed' || this.Status === 'Canceled' ) //CT1-92
       {   
         console.log(this.Status +'testttttttttttttttttttttt');    
       }
       else{ 
         const event = new ShowToastEvent(
            {
                //NIN-44
                title: saveRecordsTitle,
                message: waitMessage,
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        }
    }
        
}