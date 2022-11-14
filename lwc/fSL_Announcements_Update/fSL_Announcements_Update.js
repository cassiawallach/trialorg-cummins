import { LightningElement, track, wire, api } from 'lwc';
import { getSObjectValue } from '@salesforce/apex';

import announcmentText from '@salesforce/label/c.FSL_Announcement';
import AnnouncementText_label from '@salesforce/label/c.FSL_Announcement_Header';
import getAnnouncementDetailsList from '@salesforce/apex/FSL_CL_AnnouncementDetails.getAnnouncements';
import getSingleRecord from '@salesforce/apex/FSL_CL_AnnouncementDetails.getSingleRecord';
import getAllAnnouncements from '@salesforce/apex/FSL_CL_AnnouncementDetails.getAllAnnouncements';
import adminProfile from '@salesforce/apex/FSL_CL_AnnouncementDetails.fetchAdminRole';

import update from '@salesforce/label/c.EVL_Update';
import description from '@salesforce/label/c.FSL_Audit_Description';
import category from '@salesforce/label/c.CSS_Category';
import type from '@salesforce/label/c.CSS_Type';
import edit from '@salesforce/label/c.css_Edit';
import announcement_header from '@salesforce/label/c.FSL_Announcement_Header';
import cancel from '@salesforce/label/c.FSL_Cssp_Cancel';
import save from '@salesforce/label/c.FSL_CSSP_Save';
import dealer from '@salesforce/label/c.FSL_Dealer';
import distributor from '@salesforce/label/c.FSL_Distributor';
import navigation_url from '@salesforce/label/c.FSL_Navigation_URL';
import file_upload from '@salesforce/label/c.FSL_File_Upload';
import updateAnnouncements from '@salesforce/label/c.FSL_UpdateAnnouncementDetails';
import returnToDetails from '@salesforce/label/c.FSL_ReturnToAnnouncements';
import toastTitle from '@salesforce/label/c.FSL_AnnouncementUpdate';
import toastMessage from '@salesforce/label/c.FSL_UpdateToast';

import {refreshApex} from '@salesforce/apex';

import ANNOUNCEMENT_OBJECT from "@salesforce/schema/FSL_Announcements_Data__c";
import ID_FIELD from "@salesforce/schema/FSL_Announcements_Data__c.Id";
import ANNOUNCEMENT_TEXT_FIELD from "@salesforce/schema/FSL_Announcements_Data__c.Description__c"
import NAME_FIELD from "@salesforce/schema/FSL_Announcements_Data__c.Name"
import CATEGORY_FIELD from "@salesforce/schema/FSL_Announcements_Data__c.Category__c"
import TYPE_FIELD from "@salesforce/schema/FSL_Announcements_Data__c.Type__c"
import NAVIGATION_URL_FIELD from "@salesforce/schema/FSL_Announcements_Data__c.Navigation_URL__c"

import { updateRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";

const actions = [
    {label: edit,
    name: "update_announcement"}
];


export default class FSL_Announcements_Update extends LightningElement {
    label = {
        announcmentText,
        AnnouncementText_label,
        announcement_header,
        update,
        description,
        category,
        type,
        edit,
        cancel,
        save,
        dealer,
        distributor,
        navigation_url,
        file_upload,
        updateAnnouncements,
        returnToDetails,
        toastTitle,
        toastMessage
      };


    @api
    recordID;
    announcement_text;

    @track annHeaderText;


    @track columns = [{
        label: announcement_header,
        fieldName: 'Name',
        type: 'text',
        sortable: true
    },
    {
        label: type,
        fieldName: 'Type__c',
        type: 'text',
        sortable: true
    },
    {
        label: category,
        fieldName: 'Category__c',
        type: 'text',
        sortable: true
    },
    {
        label: description,
        fieldName: 'Description__c',
        type: 'text',
        sortable: true
    },
    {
        label: navigation_url,
        fieldName: 'Navigation_URL__c',
        type: 'url',
        sortable: true
    },
    { 
        type: 'action', 
        typeAttributes: 
        { rowActions: actions, 
        menuAlignment: 'right' }
    }]

    @track error;
    @track annList ;
    allAnnouncements;
    @wire(getAllAnnouncements)
    wiredAnnouncements({
        error,
        data
    }) {
        if (data) {
            console.log(data);
            console.log('Required Length');
            console.log(Object.keys(data).length);
            console.log(Object.keys(data));
            this.annList = data;
        } else if (error) {
            this.error = error;
        }
    }

    get options(){
        return [
            {label: dealer, value:"Dealer"},
            {label: distributor, value:"Distributor"}
        ];
    }

    @wire(getAnnouncementDetailsList)
    wiredAnnouncementDetails({ error, data }) {
        if (data != null && data != '' && data != 'undefined') {
            this.annHeaderText = data;
        } else if (error) {
            console.log(error);
            this.error = error;
        }
    }

    @track isModalOpen = false;
    openModal() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    

    //@wire(getSingleRecord) announcements_data;

    @track annId;
    @track annDescription;
    @track annCategory;
    @track annName;
    @track annType;
    @track annNavigation;
    @track annEditableCat;


    handleRowAction(event) {
            this.isModalOpen = true;

            var updateRecord = [];
            var row = event.detail.row;
            this.annId = event.detail.row.Id;
            this.annDescription = event.detail.row.Description__c;
            this.annCategory = event.detail.row.Category__c;
            this.annType = event.detail.row.Type__c;
            this.annNavigation = event.detail.row.Navigation_URL__c;
            this.annName = event.detail.row.Name;
            this.annEditableCat =event.detail.row.EditableCategory__c;


            console.log('row data' + JSON.stringify(row));

    }


    submitDetails() {
        
        
        if(this.annCategory != this.template.querySelector("[data-field='annCategory']").value && this.annEditableCat == "No"){

                const msg = new ShowToastEvent({
                    title: toastTitle,
                    message: "Only the Other Category Name may be changed",
                    variant: "error",
                    mode: "pester"
                });
                
                this.dispatchEvent(msg);
                console.log("Tried changing Category");
            
        }else{
        this.isModalOpen = false;
        //get new announcement information and map to Annoucement object for updating. 
        const fields = {};
            fields[ID_FIELD.fieldApiName] = this.template.querySelector("[data-field='ID_Value']").value;
            console.log(this.template.querySelector("[data-field='ID_Value']").value);
            fields[ANNOUNCEMENT_TEXT_FIELD.fieldApiName] = this.template.querySelector("[data-field='annText']").value;
            console.log(this.template.querySelector("[data-field='annText'").value);
            fields[CATEGORY_FIELD.fieldApiName] = this.template.querySelector("[data-field='annCategory']").value;
            fields[TYPE_FIELD.fieldApiName] = this.template.querySelector("[data-field='annType']").value;
            fields[NAVIGATION_URL_FIELD.fieldApiName] = this.template.querySelector("[data-field='annNavigation']").value;

        const recordInput = {fields};
        console.log(recordInput);

        //push updates to the custom object record
        updateRecord(recordInput)
                .then(() => {
                    
                    if (result) {
                         // Refresh Account Detail Page
                         updateRecord(recordInput);
                         refreshApex(recordInput);
                    }
                    
                })
        
        
        //reload page to refresh announcement data without a manual refresh
        location.reload();
        //eval("$A.get('e.force:refreshView').fire();");
        
        //display success of update to user. 
        const msg = new ShowToastEvent({
            title: toastTitle,
            message: toastMessage,
            variant: "info",
            mode: "pester"
        });
        
        this.dispatchEvent(msg);
        }
        
    }

    @track adminProfile;
    @wire(adminProfile)
    wiredAdminProfile({ error, data }) {
        if (data) {
            console.log(data)
            this.adminProfile = data;
        } else if (error) {
            console.log(error);
            this.error = error;
        }
    }
    navURL;
    returnToDetails() {
        let urlString = window.location.origin;
        //alert(urlString);
        window.location.href = urlString + "/" + "evolution" + "/s/announcements";
        this.navURL = urlString + "/" + "evolution" + "/s/announcements";

    }

    connectedCallback(){
        let urlString = window.location.origin;
        this.navURL = urlString + "/" + "evolution" + "/s/announcements";
    } 

}