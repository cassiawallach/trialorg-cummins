import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getRecord, getObjectInfo, getPicklistValues, getFieldValue, updateRecord } from 'lightning/uiRecordApi';
import getallMetadata from '@salesforce/apex/FSL_Comm_RegionToggles_Controller.getallMetadata';
import getmdata from '@salesforce/apex/FSL_Comm_RegionToggles_Controller.getRegion';
import createUpdateMetadata from '@salesforce/apex/FSL_Comm_RegionToggles_Controller.createUpdateMetadata'; // to save record.
import picklistval from '@salesforce/apex/FSL_Comm_RegionToggles_Controller.getallMetadatapicklist';
import RegionTogglesMetaData from '@salesforce/apex/FSL_Comm_RegionToggles_Controller.getRegionTogglesMetaData';
import USER_PROFILE from '@salesforce/schema/User.ProfileId';
import NAME from '@salesforce/schema/User.Name';
import EMAIL from '@salesforce/schema/User.Email';
import USER_ID from "@salesforce/user/Id";

const columns = [
    { label: 'Account Name', fieldName: 'Name',type: 'text', editable: true  },
    { label: 'ERP Source', fieldName: 'FSL_Source_ERP__c',type: 'text', editable: true  },
    { label: 'Authorize Work Started', fieldName: 'Authorize_Work_Started__c',type: 'boolean', editable: true  },
    { label: 'Equipment Available', fieldName: 'Equipment_Available__c', type: 'boolean', editable: true  },
    { label: 'Invoice Ready', fieldName: 'Invoice_Ready__c', type: 'boolean',editable: true  },
    { label: 'Service Work Completed', fieldName: 'Service_Work_Completed__c', type: 'boolean', editable: true  },
    { label: 'Troubleshooting Started', fieldName: 'Troubleshooting_Started__c', type: 'boolean', editable: true  },
	{ label: 'Service Work Proceeding', fieldName: 'Service_Work_Proceeding__c', type: 'boolean', editable: true  },
    { label: 'Equipment Ready For Pick Up', fieldName: 'Equipment_Ready_For_Pick_Up__c', type: 'boolean', editable: true  }
];

export default class Custmetadata extends LightningElement {

    @track cusdata;
    @track value;
    @track boolVisible = false;
    @track clickedButtonLabel = 'Show';
    @track selectederp;
    @track singlerecord;
    @track recordId;
    @track editmode = false;
    @track displaydetails;
    @track AWScheckboxVal = false;
    @track EAcheckboxVal = false;
    @track IRcheckboxVal = false;
    @track SWCcheckboxVal = false;
    @track TScheckboxVal = false;
	@track SWPcheckboxVal = false;
    @track ERPScheckboxVal = false;
    @track clickedButtonLabel = 'Update';
    @track myMap = [];
    @track metadataname;
    @track meatadataLabel;
    @track ffadata = [];
    @track DeveloperName;
    @track Labelvalue;
    @track accountsData;
    @track error;
    @track columns = columns;
    @track user;
    @track name;   
    @track email;
    @track userprofile;
    @track EmailFrequency;
    @track TextFrequency;
    @track selectedEmailFrequency='none';
    @track selectedTextFrequency='none';

    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME, EMAIL, USER_PROFILE]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
           this.error = error ;
           console.log('error:' + error);
        } else if (data) {
            this.name = data.fields.Name.value;
            this.email = data.fields.Email.value;
            this.userprofile = data.fields.ProfileId.value;
            console.log('userdetails:' + this.name +','+ this.email +','+ this.userprofile);
        }
    }
    @wire(RegionTogglesMetaData)
    wiredTogglesMetaData({ error, data }) {
        console.log('==========='+JSON.stringify(data));
        if (data) {
        var EmailFrequencyoptions = [];
        var TextFrequencyoptions = [];
        if (data.Email_Frequency) {
                    data.Email_Frequency.forEach(r => {
                    EmailFrequencyoptions.push({
                            label: r,
                            value: r,
                    });
            });
        }
        if (data.Text_Frequency) {
                    data.Text_Frequency.forEach(r => {
                    TextFrequencyoptions.push({
                            label: r,
                            value: r,
                    });
            });
        }   
            console.log('======EmailFrequencyoptions====='+JSON.stringify(EmailFrequencyoptions));
            console.log('======TextFrequencyoptions====='+JSON.stringify(TextFrequencyoptions));     
            this.EmailFrequency = EmailFrequencyoptions;
            this.TextFrequency = TextFrequencyoptions;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }

    connectedCallback() {
        console.log('inside connected call back');
        this.getallERValues();
    }

    handleClick(event) {
        // if(userProfile != 'System Administrator') {00e61000000sNkcAAE
        if(this.userprofile != '00e61000000sNkcAAE') {
            console.log('You do not have sufficient privilege to update the flags !!');
            this.showToast('Update Failed!', 'No permission to perform the action', 'error');
            return;
        }

        console.log('Inside Button click ' + event.detail.name);
        this.editmode = true;
        const label = event.target.label;
        if (label === 'Save') {
            console.log('===selectedEmailFrequency=== '+this.selectedEmailFrequency);
            console.log('===selectedTextFrequency=== '+this.selectedTextFrequency);

            let checkboxes = this.template.querySelectorAll('[data-id="checkbox"]')
            let i;
            for (i = 0; i < checkboxes.length; i++) {

                this.ffadata.push({ 'name': checkboxes[i].name, 'value': checkboxes[i].checked });
            }
            this.ffadata.push({ 'name': 'Email_Frequency__c', 'value': this.selectedEmailFrequency});
            this.ffadata.push({ 'name': 'Text_Frequency__c', 'value': this.selectedTextFrequency});

            console.log('===== '+this.ffadata);
            console.log(this.ffadata.length);

            createUpdateMetadata({ fullName: this.metadataname, label: this.value, fieldWithValuesMap: this.ffadata }) //
                .then(result => {
                    if (result) {
                        console.log(result);
                        console.log(JSON.stringify(result));
                        this.showToast('Update Successful!', 'Flags updated successfully', 'success');
                    }

                })
                .catch(error => {
                    console.log(error);
                });
        }

    }
    handleEmailFrequencyChange(event) {
        this.selectedEmailFrequency = event.detail.value;
    }
    handleTextFrequencyChange(event) {
        this.selectedTextFrequency = event.detail.value;
    }   
    handleChange(event) {
        console.log('Inside change event ' + event.detail.name);
        console.log('event details ' + event.detail.value);
        this.selectederp = event.detail.value;
        this.value = event.detail.value;
        this.editmode = true;

        getmdata({ developerName: this.value })
            .then(result => {

                var options = [];
                                /* Remove accounts list Madhavi
                                if (result.accounts) {
 this.accountsData= result.accounts;
// console.log('=====this.accountsData=== ' + JSON.stringify(this.accountsData));
} */
                console.log('=====this.mtadata=== ' + JSON.stringify(result.mtadata));
                if (result.mtadata) {
                    console.log('Id value ----> ' + result.mtadata.Id);
                    this.recordId = result.mtadata.Id;
this.metadataname = 'FSL_Communication_RegionToggles__mdt.' + result.mtadata.DeveloperName;
                    this.Labelvalue = result.mtadata.Label;
                    if (result.mtadata.Authorized_Work_Started__c) {
                        this.AWScheckboxVal = result.mtadata.Authorized_Work_Started__c;
                    }
                    else {
                        this.AWScheckboxVal = result.mtadata.Authorized_Work_Started__c;
                    }
                    if (result.mtadata.Equipment_Available__c) {
                        this.EAcheckboxVal = result.mtadata.Equipment_Available__c;
                    }
                    else {
                        this.EAcheckboxVal = result.mtadata.Equipment_Available__c;
                    }
                    if (result.mtadata.Invoice_Ready__c) {
                        this.IRcheckboxVal = result.mtadata.Invoice_Ready__c;
                    }
                    else {
                        this.IRcheckboxVal = result.mtadata.Invoice_Ready__c;
                    }
                    if (result.mtadata.Service_Work_Completed__c) {
                        this.SWCcheckboxVal = result.mtadata.Service_Work_Completed__c;
                    }
                    else {
                        this.SWCcheckboxVal = result.mtadata.Service_Work_Completed__c;
                    }
                    if (result.mtadata.Troubleshooting_Started__c) {
                        this.TScheckboxVal = result.mtadata.Troubleshooting_Started__c;
                    }
                    else {
                        this.TScheckboxVal = result.mtadata.Troubleshooting_Started__c;
                    }
					
					if (result.mtadata.Equipment_Ready_For_Pick_Up__c) {
                        this.ERPScheckboxVal = result.mtadata.Equipment_Ready_For_Pick_Up__c;
                    }
                    else {
                        this.ERPScheckboxVal = result.mtadata.Equipment_Ready_For_Pick_Up__c;
                    }
                    if (result.mtadata.Service_Work_Proceeding__c) {
                        this.SWPcheckboxVal = result.mtadata.Service_Work_Proceeding__c;
                    }
                    else {
                        this.SWPcheckboxVal = result.mtadata.Service_Work_Proceeding__c;
                    }
					
                    if (result.mtadata.Text_Frequency__c !='') {
                        this.selectedTextFrequency = result.mtadata.Text_Frequency__c;
                    }
                    if (result.mtadata.Email_Frequency__c !='') {
                        this.selectedEmailFrequency = result.mtadata.Email_Frequency__c;
                    }

                }
this.singlerecord = result.mtadata;

            })
            .catch(error => {
                console.log(error);
            });

    }

    getallERValues() {
        picklistval()
            .then(result => {
                if (result.length > 0) {
                    var options = [];
                    if (result) {
                        result.forEach(r => {

                            options.push({
                                label: r,
                                value: r,
                            });
                        });
                    }
                    console.log(options);
                    this.cusdata = options;

                }

            })
            .catch(error => {
                console.log(error);
            });
    }
    showToast(title, message, variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}