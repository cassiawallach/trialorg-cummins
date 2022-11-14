import {api,wire,LightningElement} from 'lwc';
import getRVpFlagDetail from "@salesforce/apex/FSL_TriggerHandler_ViewHistory.getRPVFlag";
import { getRecord } from 'lightning/uiRecordApi';
export default class Fsl_Rpv_Flag extends LightningElement {
    activeSections = ['A'];
    
    @api recordId;

    rvpFlag;
    workOrderObj;

    connectedCallback(){        
        console.log('Work Order No - '+this.recordId);
        this.getRVpFlag();
        //window.setTimeout(function(){ this.getRVpFlag();}, 2000);
        setTimeout(function (){
            console.log('under Delay refresh - '+this.recordId);
            this.getRVpFlag();
        }.bind(this), 3000);
    }
    renderedCallback() {
         this.getRVpFlag();
    }
    getRVpFlag() //get RVpFlag 
    {       
        getRVpFlagDetail({
            woId : this.recordId
        })
        .then(result => {
            if(result)
            {
                console.log('R -> '+result);
                this.rvpFlag = result;
            }
        })
        .catch(error => {            
            console.log('Some error occured,please contact admin');
        });
    }
    
  /* @wire(getRecord, { recordId: '$recordId', fields: [ 'WorkOrder.IsClosed'] })
    getWORecord({ data, error }) {
        console.log('WorkOrder => ', data, error);
        if (data) {
            this.workOrderObj = data;
            //console.log('workOrderObj Loading..');
            this.getRVpFlag();
        } else if (error) {
            console.error('ERROR => ', JSON.stringify(error)); // handle error properly
        }
    } */
}