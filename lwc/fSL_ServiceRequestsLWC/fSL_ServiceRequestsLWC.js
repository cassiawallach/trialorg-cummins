import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
import url_prefix from '@salesforce/label/c.FSL_CSSP_WorkorderURL_Prefix';
import serviceRequest from '@salesforce/label/c.FSL_Service_Request';
import unitNo from '@salesforce/label/c.FSL_Unit_No';
import make from '@salesforce/label/c.FSL_Make';
import model from '@salesforce/label/c.CSS_Model';
import registrationNoLabel from '@salesforce/label/c.FSL_CSSP_License_Number';
import serialNo from '@salesforce/label/c.FSL_Serial_Number_ESN_PSN';
import status from '@salesforce/label/c.CSS_Status';
import srCreatedDate from '@salesforce/label/c.FSL_Service_Request_Created_Date';
import serviceLocation from '@salesforce/label/c.FSL_CSSP_Service_Location';
import serviceRequests from '@salesforce/label/c.FSL_Service_Requests';
import submittedLabel from '@salesforce/label/c.CSS_Submitted';
import rejectedLabel from '@salesforce/label/c.Css_paccar_rejected';
import displayingLabel from '@salesforce/label/c.FSL_Displaying';// Added for Story#CT4-749
import recordLabel from '@salesforce/label/c.FSL_records';// Added for Story#CT4-749
import pageLabel from '@salesforce/label/c.FSL_Page';// Added for Story#CT4-749
import ofLabel from '@salesforce/label/c.FSL_Of';// Added for Story#CT4-749
import toLabel from '@salesforce/label/c.FSL_Too';// Added for Story#CT4-749
import firstPageLabel from '@salesforce/label/c.FSL_First_Page';// Added for Story#CT4-749
import nextPageLabel from '@salesforce/label/c.FSL_Next';// Added for Story#CT4-749
import lastPageLabel from '@salesforce/label/c.FSL_Last_Page';// Added for Story#CT4-749
import previousPageLabel from '@salesforce/label/c.FSL_Previous';// Added for Story#CT4-749
import newServiceRequest from '@salesforce/label/c.FSL_Immediate_Assessment_Request';// Added for Story#CT4-749
// importing apex class methods
import getServiceRequests from '@salesforce/apex/FSL_ServiceRequestsLWCController.getServiceRequests';

// datatable columns with row actions
const columns = [{
        label: serviceRequest,
        fieldName: 'nameUrl',
        type: 'url',
        sortable: "true",
        typeAttributes: {
            label: {
                fieldName: 'CaseNumber'
            },
            target: '_blank'
        }

    }, {
        label: serviceLocation,
        fieldName: 'Service_location__c',
        type: 'Picklist',
        sortable: "true"
    },
    /**{

           label: 'Service Order',
           fieldName: '',
           type: 'url',
           sortable: "true",

       }, */
    {
        label: unitNo,
        fieldName: 'CaseUnitNumber',
        type: 'text',
        sortable: "true"
    }, {
        label: make,
        fieldName: 'Make__c',
        type: 'text',
        sortable: "true"
    }, {
        label: model,
        fieldName: 'Model__c',
        sortable: "true"
    }, {
        label: registrationNoLabel,
        fieldName: 'Registration',
        sortable: "true"
    },
    {
        label: serialNo,
        fieldName: 'AssetName',
        sortable: "true"
    }, {
        label: status,
        fieldName: 'Status',
        type: 'Picklist',
        sortable: "true"
    }, {
        label: srCreatedDate,
        fieldName: 'CreatedDate',
        sortable: "true",
        type: 'date',
        typeAttributes: {
            month: "numeric",
            day: "numeric",
            year: "numeric"
        }
    },
    /** {
            label: 'Service Territory',
            fieldName: 'Service_Territory__c',
            type: 'String',
            sortable: "true"
        },*/
];

export default class DataTableWithSortingInLWC extends LightningElement {
    // stary Pagination Varaibles
    @track page = 1; //this will initialize 1st page
    @track items = []; //it contains all the records.
    // @track data = []; //data to be displayed in the table
    // @track columns; //holds column info.
    @track startingRecord = 1; //start record position per page
    @track endingRecord = 0; //end record position per page
    @track pageSize = 20; //default value we are assigning
    @track totalRecountCount = 0; //total record count received from all retrieved records
    @track totalPage = 0; //total number of page is needed to display all records
    @track showPagination;
    pagelinks = [];
    // end pagination Varaibles
    // reactive variable
    @track data;
    @track columns = columns;
    @track sortBy;
    @track sortDirection;
    @track ResultSize;
    @track NewServiceRequests;
    @track RejectedServiceRequests;
    @track toatalData;
    @track WorkTableTitle;
    @track NewButtonLabel;
    @track RejectedButtonLabel;
    @track buttonStyle1 = 'slds-button slds-m-left_x-small styleBtn';
    @track buttonStyle2 = 'slds-button slds-m-left_x-small styleBtn';
    buttonStyle3 = 'slds-button newSrvcReqStyleBtn';
    @track dataSize;
    
        label = {
        displayingLabel,
        recordLabel,
        pageLabel,
        ofLabel,
        toLabel,
        firstPageLabel,
        nextPageLabel,
        lastPageLabel,
        previousPageLabel,
        newServiceRequest
};
    //NewServiceRequestButton = this.label.newServiceRequest;


    // retrieving the data using wire service
    @wire(getServiceRequests)
    contacts(result) {
        if (result.data) {

            this.NewServiceRequests = result.data.NewServiceRequests;
            this.RejectedServiceRequests = result.data.RejectedServiceRequests;
            this.toatalData = result.data.NewServiceRequests.concat(result.data.RejectedServiceRequests);
            this.NewButtonLabel = submittedLabel + ' | ' + result.data.NewServiceRequests.length;
            this.RejectedButtonLabel = rejectedLabel + ' | ' + result.data.RejectedServiceRequests.length;
            const totalResultLength = result.data.NewServiceRequests.length + result.data.RejectedServiceRequests.length;
            this.ResultSize = serviceRequests + ' | ' + totalResultLength;
            const value = this.ResultSize;
            this.error = undefined;
            const valueChangeEvent = new CustomEvent("valuechange", {
                detail: {
                    value
                }
            });
            // Fire the custom event
            this.dispatchEvent(valueChangeEvent);
            this.error = undefined;

        } else if (result.error) {
            this.error = result.error;
            this.data = undefined;
        }
        if (this.toatalData == '') {
            this.dataSize = false;
            this.showPagination = false;
        }
        if (this.toatalData) {

            let currentData = [];
            this.toatalData.forEach((row) => {
                let rowData = {};
                rowData.Id = row.Id;
                rowData.CreatedDate = row.CreatedDate;
                rowData.CaseNumber = row.CaseNumber;
                rowData.CaseUnitNumber = row.Unit_Number__c;
                rowData.Status = row.Status;
                rowData.Make__c = row.Make__c;
                rowData.Model__c = row.Model__c;
                rowData.AssetId = row.AssetId;
                rowData.Service_location__c = row.Service_location__c;
                rowData.nameUrl = url_prefix + '' + row.Id;
                if (row.Asset) {
                    rowData.AssetName = row.Asset.Name;
                    rowData.Registration = row.Asset.Registration__c;
                }
                if (row.Service_Territory__r) {
                    rowData.Service_Territory__c = row.Service_Territory__r.Name;
                }
                this.showPagination = true;
                currentData.push(rowData);
            });
            this.items = currentData; //Added for pagination
            this.totalRecountCount = currentData.length; //Added for pagination
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); //Added for pagination
            // this.data = currentData; //commented as per pagination
            this.data = this.items.slice(0, this.pageSize); //Added for pagination
            this.endingRecord = this.pageSize; //Added for pagination
            this.page = 1;
            this.displayRecordPerPage(this.page);
            /* for (let i = 1; i <= this.totalPage; i++) {
                 this.pagelinks.push(i);
             }*/
            if (this.data.length < 10) {
                this.dataSize = true;
            }
            console.log('this.totalRecountCount' + this.totalRecountCount);
            console.log('this.totalPage' + this.totalPage);
            console.log(' this.data' + this.data);
            console.log(' this.endingRecord' + this.endingRecord);
        }

    }
    handleSortdata(event) {
        // field name
        this.sortBy = event.detail.fieldName;

        // sort direction
        this.sortDirection = event.detail.sortDirection;

        // calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }
    NewButton(event) {

        this.buttonStyle1 = 'slds-button slds-m-left_x-small styleBtnDark';
        this.buttonStyle2 = 'slds-button slds-m-left_x-small styleBtn';
        this.WorkTableTitle = serviceRequests + ' - ' + submittedLabel;
        this.dataSize = undefined;

        if (this.NewServiceRequests == '') {
            this.dataSize = false;
            this.showPagination = false;

        }

        if (this.NewServiceRequests) {

            let currentData = [];
            this.NewServiceRequests.forEach((row) => {
                let rowData = {};

                rowData.Id = row.Id;
                rowData.CreatedDate = row.CreatedDate;
                rowData.CaseNumber = row.CaseNumber;
                rowData.CaseUnitNumber = row.Unit_Number__c;
                rowData.Status = row.Status;
                rowData.Make__c = row.Make__c;
                rowData.Model__c = row.Model__c;
                rowData.AssetId = row.AssetId;
                rowData.Service_location__c = row.Service_location__c;
                rowData.nameUrl = url_prefix + '' + row.Id;
                if (row.Asset) {
                    rowData.AssetName = row.Asset.Name;
                    rowData.Registration = row.Asset.Registration__c;
                }
                if (row.Service_Territory__r) {
                    rowData.Service_Territory__c = row.Service_Territory__r.Name;
                }
                this.page = 1;
                this.startingRecord = 1;
                this.endingRecord = 0;
                this.showPagination = true;
                currentData.push(rowData);
            });
            this.items = currentData; //Added for pagination
            this.totalRecountCount = currentData.length; //Added for pagination
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); //Added for pagination
            // this.data = currentData;
            this.data = this.items.slice(0, this.pageSize); //Added for pagination
            this.endingRecord = this.pageSize; //Added for pagination
            // this.page = 1;
            this.displayRecordPerPage(this.page);
            if (this.data.length < 10) {
                this.dataSize = true;

            }
        } else if (error) {
            window.console.log(error);
        }
        console.log(this.data);

    }
    RejectedButton(event) {
        this.buttonStyle1 = 'slds-button slds-m-left_x-small styleBtn';
        this.buttonStyle2 = 'slds-button slds-m-left_x-small styleBtnDark';
        this.WorkTableTitle = serviceRequests + ' - ' + rejectedLabel;
        this.data = null;
        this.dataSize = undefined;
        if (this.RejectedServiceRequests == '') {
            this.dataSize = false;
            this.showPagination = false;

        }

        if (this.RejectedServiceRequests) {
            let currentData = [];
            this.RejectedServiceRequests.forEach((row) => {
                let rowData = {};

                rowData.Id = row.Id;
                rowData.CreatedDate = row.CreatedDate;
                rowData.CaseNumber = row.CaseNumber;
                rowData.CaseUnitNumber = row.Unit_Number__c;
                rowData.Status = row.Status;
                rowData.Make__c = row.Make__c;
                rowData.Model__c = row.Model__c;
                rowData.AssetId = row.AssetId;
                rowData.Service_location__c = row.Service_location__c;
                rowData.nameUrl = url_prefix + '' + row.Id;
                if (row.Asset) {
                    rowData.AssetName = row.Asset.Name;
                    rowData.Registration = row.Asset.Registration__c;
                }
                if (row.Service_Territory__r) {
                    rowData.Service_Territory__c = row.Service_Territory__r.Name;
                }
                currentData.push(rowData);
                this.page = 1;
                this.startingRecord = 1;
                this.endingRecord = 0;
                this.showPagination = true;
            });
            this.items = currentData; //Added for pagination
            this.totalRecountCount = currentData.length; //Added for pagination
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); //Added for pagination
            // this.data = currentData;
            this.data = this.items.slice(0, this.pageSize); //Added for pagination
            this.endingRecord = this.pageSize; //Added for pagination
            //this.data = currentData;
            //this.page = 1;
            this.displayRecordPerPage(this.page);
            if (this.data.length < 10) {
                this.dataSize = true;
            }
        } else if (error) {
            window.console.log(error);
        }
        console.log(this.data);
    }

    NewServiceRequestButton() {
        let urlString = window.location.origin;
        window.location.href = urlString + "/" + "cssp" + "/s/new-service-request";
    }


    sortData(fieldname, direction) {

        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(this.data));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };

        // cheking reverse direction 
        let isReverse = direction === 'asc' ? 1 : -1;

        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';
            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        // set the sorted data to data table data
        this.data = parseData;
    }
    get disablePrevious() {
        return this.page <= 1
    }
    get disableNext() {
        return this.page >= this.totalPage
    }

    //Added for Pagenation
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }

    }
    //clicking on next button this method will be called
    nextHandler() {
        if ((this.page < this.totalPage) && this.page !== this.totalPage) {
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);
        }
    }
    displayRecordPerPage(page) {
        this.startingRecord = ((page - 1) * this.pageSize);
        this.endingRecord = (this.pageSize * page);
        this.endingRecord = (this.endingRecord > this.totalRecountCount) ?
            this.totalRecountCount : this.endingRecord;
        this.data = this.items.slice(this.startingRecord, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;
    }
    /* handlePage(button) {
         this.page = button.target.label;
         // alert('this.page'+this.page);
         this.displayRecordPerPage(this.page);

     }*/
    FirstPageHandler() {
        this.page = 1;
        this.displayRecordPerPage(this.page);
    }
    LastPageHandler() {
        this.page = this.totalPage;
        this.displayRecordPerPage(this.page);
    }
}