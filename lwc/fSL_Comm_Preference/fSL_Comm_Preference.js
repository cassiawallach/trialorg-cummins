import { LightningElement, track, wire } from 'lwc';
import Id from "@salesforce/user/Id";
import getUserDetails from "@salesforce/apex/FSL_CSSP_equipmentController.currentuser";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { publish, MessageContext } from 'lightning/messageService';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import EMAIL_FREQUENCY from '@salesforce/schema/Contact.Email_Notification_Frequency__c';
import TEXT_FREQUENCY from '@salesforce/schema/Contact.Text_SMS_Notification_Frequency__c';
import COMM_TRIGGER from '@salesforce/schema/Contact.FSL_Comm_Triggers__c';
import CONTACT_ID_FIELD from '@salesforce/schema/Contact.Id';
import { updateRecord } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import FSL_CSSP_CommunicationTrigger from '@salesforce/label/c.FSL_CSSP_CommunicationTrigger';
import FSL_CSSP_CommunicationPrefer from '@salesforce/label/c.FSL_CSSP_CommunicationPrefer';
import FSL_CSSP_Save from '@salesforce/label/c.FSL_CSSP_Save';
import FSL_CSSP_TextNotificationFrequency from '@salesforce/label/c.FSL_CSSP_TextNotificationFrequency';
import FSL_CSSP_EmailNotificationFrequency from '@salesforce/label/c.FSL_CSSP_EmailNotificationFrequency';
import FSL_CSSP_HelpText_CommPref from '@salesforce/label/c.FSL_CSSP_HelpText_CommPref';

export default class FSL_Comm_Preference extends LightningElement {
   // message = FSL_CSSP_HelpText_Account_Detail;
   label = {
    FSL_CSSP_CommunicationTrigger,
    FSL_CSSP_CommunicationPrefer,
    FSL_CSSP_Save,
    FSL_CSSP_EmailNotificationFrequency,
    FSL_CSSP_TextNotificationFrequency,
    FSL_CSSP_HelpText_CommPref
};
    activeSections = ['communicationTriggers', 'communicationPreferences'];
    
    @track recordId;
    userId = Id;
    @track accountERP;

    @wire(getUserDetails, {
        loggedInUserId: "$userId"
    })

    wiredUser({ error, data }) {
        if (data) {
            let userData = data;
            let contactsID = userData[0].ContactId;
            let accERP = userData[0].Account.FSL_Source_ERP__c;
            this.accountERP = accERP;
            this.recordId = contactsID;
           // alert(this.accountERP);
            this.error = error;
        }
    }

    updateCase() {

        const ValidInvoice = this.template.querySelector("[data-id='Commtriggerid​']").value;
        const selectedinvc =  ValidInvoice.split(';');   
     //if((selectedinvc.includes('Invoice Ready')) && ((this.accountERP=='MOVEX')||(this.accountERP=='MOVEX-UK'))){
     if((selectedinvc.includes('Invoice Ready')) && (this.accountERP!='BMS')){
        this.dispatchEvent(
           new ShowToastEvent({
               title: 'Something is wrong',
               message: 'The invoice ready trigger is not yet available for your region. Please de-select this from the chosen.',
               variant: 'error'
           })
        );
   }
    else{

        //alert(selectedinvc);
        const fields = {};
        fields[CONTACT_ID_FIELD.fieldApiName] = this.recordId;
        console.log('CONTACT_ID_FIELD==>' + this.recordId);
        fields[EMAIL_FREQUENCY.fieldApiName] = this.template.querySelector("[data-field='EmailNotificationFrequency']").value;
        console.log('EMAIL_FREQUENCY==>' + this.template.querySelector("[data-field='EmailNotificationFrequency']").value);
        fields[TEXT_FREQUENCY.fieldApiName] = this.template.querySelector("[data-field='TextSMSNotificationFrequency​']").value;
        console.log('TEXT_FREQUENCY==>' + this.template.querySelector("[data-field='TextSMSNotificationFrequency​']").value);
        fields[COMM_TRIGGER.fieldApiName] = this.template.querySelector("[data-id='Commtriggerid​']").value;
        console.log('COMM_TRIGGER==>' + this.template.querySelector("[data-id='Commtriggerid​']").value);
        const recordInput = { fields };
        console.log('fields==>' +fields)
        updateRecord(recordInput)

            .then(() => {

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Contact Updated',
                        variant: 'success'
                    })
                );             
            })
              .catch(error => {

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Updating Record',
                        message: error.body.output.errors[0].errorCode + '-'+ error.body.output.errors[0].message,
                        variant: 'error'
                    })
                );
            });
            
    }
}
passwordHintClass = "slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground slds-hide"
togglePasswordHint() {
    this.passwordHintClass = this.passwordHintClass == 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground slds-hide' ? "slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-rise-from-ground" : "slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground slds-hide"
}

passwordHintClass1 = "slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground slds-hide"
togglePasswordHint1() {
    this.passwordHintClass1 = this.passwordHintClass1 == 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground slds-hide' ? "slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-rise-from-ground" : "slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground slds-hide"
}

}