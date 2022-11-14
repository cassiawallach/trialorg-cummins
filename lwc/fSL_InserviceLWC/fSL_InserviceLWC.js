import { LightningElement, wire, track, api } from 'lwc';
import url_prefix from '@salesforce/label/c.FSL_CSSP_WorkorderURL_Prefix';
import serviceRequest from '@salesforce/label/c.FSL_Service_Request';
import eventType from '@salesforce/label/c.FSL_Event_Type';
import serviceOrder from '@salesforce/label/c.Comm_Work_Order';
import unitNo from '@salesforce/label/c.FSL_Unit_No';
import make from '@salesforce/label/c.FSL_Make';
import model from '@salesforce/label/c.CSS_Model';
import registrationNoLabel from '@salesforce/label/c.FSL_CSSP_License_Number';
import serialNo from '@salesforce/label/c.FSL_Serial_Number_ESN_PSN';
import status from '@salesforce/label/c.CSS_Status';
import subStatus from '@salesforce/label/c.FSl_Sub_Status';
import orderCreatedDate from '@salesforce/label/c.FSL_Order_Created_Date';
import serviceLocation from '@salesforce/label/c.FSL_CSSP_Service_Location';
import inServiceWorkNotStarted from '@salesforce/label/c.FSL_In_Service_Work_Not_Started';
import inServiceWorkInProgress from '@salesforce/label/c.FSL_In_Service_Work_in_Progress';
import inServiceLabel from '@salesforce/label/c.FSL_In_Service';
import workNotStartedLabel from '@salesforce/label/c.FSL_Work_Not_Started';
import workInProgressLabel from '@salesforce/label/c.FSL_Work_In_Progress';
import displayingLabel from '@salesforce/label/c.FSL_Displaying';// Added for Story#CT4-749
import recordLabel from '@salesforce/label/c.FSL_records';// Added for Story#CT4-749
import pageLabel from '@salesforce/label/c.FSL_Page';// Added for Story#CT4-749
import ofLabel from '@salesforce/label/c.FSL_Of';// Added for Story#CT4-749
import toLabel from '@salesforce/label/c.FSL_Too';// Added for Story#CT4-749
import firstPageLabel from '@salesforce/label/c.FSL_First_Page';// Added for Story#CT4-749
import nextPageLabel from '@salesforce/label/c.FSL_Next';// Added for Story#CT4-749
import lastPageLabel from '@salesforce/label/c.FSL_Last_Page';// Added for Story#CT4-749
import previousPageLabel from '@salesforce/label/c.FSL_Previous';// Added for Story#CT4-749 

// importing apex class methods
import getWorkOrders from '@salesforce/apex/FSL_InServiceLWCController.getWorkOrders';

// datatable columns with row actions
/*export default class FSL_InserviceLWC extends LightningElement {
    // Added below Pagination Varaibles for Story# CT4-743 - Start
    @track page = 1;
    @track items = [];
    @track startingRecord = 1;
    @track endingRecord = 0;
    @track pageSize = 20;
    @track totalRecountCount = 0;
    @track totalPage = 0;
    @track showPagination;*/
/*label = {
        displayingLabel,
        recordLabel,
        pageLabel,
        ofLabel,
        toLabel,
        firstPageLabel,
        nextPageLabel,
        lastPageLabel,
        previousPageLabel
};*/
const columns = [
    {
        label: serviceRequest,
        fieldName: 'CaseNumber',
        sortable: "true"
    }, {
        label: eventType,
        fieldName: 'Repair_Location__c',
        type: 'Picklist',
        sortable: "true"
    }, {

        label: serviceOrder,
        fieldName: 'nameUrl',
        type: 'url',
        sortable: "true",
        typeAttributes: {
            label: {
                fieldName: 'WorkOrderNumber'
            },
            target: '_blank'
        }
    }, {
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
    }, 
		{
        label: registrationNoLabel,
        fieldName: 'Registration',
        sortable: "true"
    },{
        label: serialNo,
        fieldName: 'AssetName',
        sortable: "true"
    }, {
        label: status,
        fieldName: 'Status',
        type: 'Picklist',
        sortable: "true"
    }, {
        label: subStatus,
        fieldName: 'FSL_Sub_Status__c',
        type: 'Picklist',
        sortable: "true"
    }, {
        label: orderCreatedDate,
        fieldName: 'CreatedDate',
        sortable: "true",
        type: 'date',
        typeAttributes: {
            month: "numeric",
            day: "numeric",
            year: "numeric"
        }
    }, {
        label: serviceLocation,
        fieldName: 'FSL_Service_Location__c',
        type: 'String',
        sortable: "true"
    },
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
    @track workNotStarted;
    @track WorkInProgress;
    @track toatalData;
    @track workNotStartedButtonLabel;
    @track WorkInProgressButtonLabel;
    @track WorkTableTitle;
    @track buttonStyle1 = 'slds-button slds-m-left_x-small styleBtn';
    @track buttonStyle2 = 'slds-button slds-m-left_x-small styleBtn';
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
        previousPageLabel
};

    // retrieving the data using wire service
    @wire(getWorkOrders)
    contacts(result) {
        if (result.data) {
            this.workNotStarted = result.data.workNotStarted;
            this.WorkInProgress = result.data.workInProgress;
            this.toatalData = result.data.workNotStarted.concat(result.data.workInProgress);
            this.workNotStartedButtonLabel = workNotStartedLabel + ' | ' + result.data.workNotStarted.length;
            this.WorkInProgressButtonLabel = workInProgressLabel + ' | ' + result.data.workInProgress.length;
            const totalResultLength = result.data.workNotStarted.length + result.data.workInProgress.length;
            this.ResultSize = inServiceLabel + ' | ' + totalResultLength;
            const value = this.ResultSize;
            this.error = undefined;
            const valueChangeEvent = new CustomEvent("valuechange", {
                detail: { value }
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
                rowData.WorkOrderNumber = row.WorkOrderNumber;
                rowData.Repair_Location__c = row.Repair_Location__c;
                rowData.Status = row.Status;
                rowData.FSL_Sub_Status__c = row.FSL_Sub_Status__c;
                rowData.Make__c = row.Make__c;
                rowData.Model__c = row.Model__c;
                rowData.AssetId = row.AssetId;
                rowData.Type_of_Repair__c = row.Type_of_Repair__c;
                rowData.Repair_Site_Name__c = row.Repair_Site_Name__c;
                rowData.WorkTypeId = row.WorkTypeId;
                rowData.FSL_Service_Location__c = row.FSL_Service_Location__c;
                rowData.nameUrl = url_prefix + '' + row.Id;
                if (row.Case) {
                    rowData.CaseId = row.CaseId;
                    rowData.CaseNumber = row.Case.CaseNumber;
                    rowData.CaseUnitNumber = row.Case.Unit_Number__c;
										
                }
                /**if(row.Repair_Site_Name__c){
                    rowData.RepairSiteName = row.Repair_Site_Name__r.Name;
                }*/
                if (row.Asset) {
                    rowData.AssetName = row.Asset.Name;
					rowData.Registration = row.Asset.Registration__c;
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
           /* for (let i = 1; i <= this.totalPage; i++) {
                this.pagelinks.push(i);
            }*/
            this.page = 1;
            this.displayRecordPerPage(this.page);
           // this.data = currentData;
            if (this.data.length < 10) {
                this.dataSize = true;
            }
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
    WorkNotStarted(event) {
        this.buttonStyle1 = 'slds-button slds-m-left_x-small styleBtnDark';
        this.buttonStyle2 = 'slds-button slds-m-left_x-small styleBtn';
        this.WorkTableTitle = inServiceWorkNotStarted;
        this.dataSize = undefined;
        if (this.workNotStarted == '') {
            this.dataSize = false;
            this.showPagination = false;
        }

        if (this.workNotStarted) {
            let currentData = [];
            this.workNotStarted.forEach((row) => {
                let rowData = {};

                rowData.Id = row.Id;
                rowData.CreatedDate = row.CreatedDate;
                rowData.WorkOrderNumber = row.WorkOrderNumber;
                rowData.Repair_Location__c = row.Repair_Location__c;
                rowData.Status = row.Status;
                rowData.FSL_Sub_Status__c = row.FSL_Sub_Status__c;
                rowData.Make__c = row.Make__c;
                rowData.Model__c = row.Model__c;
                rowData.AssetId = row.AssetId;
                rowData.Type_of_Repair__c = row.Type_of_Repair__c;
                rowData.Repair_Site_Name__c = row.Repair_Site_Name__c;
                rowData.WorkTypeId = row.WorkTypeId;
                rowData.FSL_Service_Location__c = row.FSL_Service_Location__c;
                rowData.nameUrl = url_prefix + '' + row.Id;
                if (row.Case) {
                    rowData.CaseId = row.CaseId;
                    rowData.CaseNumber = row.Case.CaseNumber;
                    rowData.CaseUnitNumber = row.Case.Unit_Number__c;
                }
                /*if(row.Repair_Site_Name__c){
                    rowData.RepairSiteName = row.Repair_Site_Name__r.Name;
                }*/
                if (row.Asset) {
                    rowData.AssetName = row.Asset.Name;
					rowData.Registration = row.Asset.Registration__c;
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
            //this.data = currentData;
           // this.page = 1;
            this.displayRecordPerPage(this.page);
            if (this.data.length < 10) {
                this.dataSize = true;
            }
        }
        else if (error) {
            window.console.log(error);
        }
        console.log(this.data);
    }
    WorkInProgressButton(event) {
        this.buttonStyle1 = 'slds-button slds-m-left_x-small styleBtn';
        this.buttonStyle2 = 'slds-button slds-m-left_x-small styleBtnDark';
        this.WorkTableTitle = inServiceWorkInProgress;
        this.data = null;
        this.dataSize = undefined;
        if (this.WorkInProgress == '') {
            this.dataSize = false;
            this.showPagination = false;
        }

        if (this.WorkInProgress) {
            let currentData = [];
            this.WorkInProgress.forEach((row) => {
                let rowData = {};

                rowData.Id = row.Id;
                rowData.CreatedDate = row.CreatedDate;
                rowData.WorkOrderNumber = row.WorkOrderNumber;
                rowData.Repair_Location__c = row.Repair_Location__c;
                rowData.Status = row.Status;
                rowData.FSL_Sub_Status__c = row.FSL_Sub_Status__c;
                rowData.Make__c = row.Make__c;
                rowData.Model__c = row.Model__c;
                rowData.AssetId = row.AssetId;
                rowData.Type_of_Repair__c = row.Type_of_Repair__c;
                rowData.Repair_Site_Name__c = row.Repair_Site_Name__c;
                rowData.WorkTypeId = row.WorkTypeId;
                rowData.FSL_Service_Location__c = row.FSL_Service_Location__c;
                rowData.nameUrl = url_prefix + '' + row.Id;
                if (row.Case) {
                    rowData.CaseId = row.CaseId;
                    rowData.CaseNumber = row.Case.CaseNumber;
                    rowData.CaseUnitNumber = row.Case.Unit_Number__c;
                }
                /* if(row.Repair_Site_Name__c){
                     rowData.RepairSiteName = row.Repair_Site_Name__r.Name;
                 }*/
                if (row.Asset) {
                    rowData.AssetName = row.Asset.Name;
					rowData.Registration = row.Asset.Registration__c;
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
           // this.page = 1;
            this.displayRecordPerPage(this.page);
            if (this.data.length < 10) {
                this.dataSize = true;
            }
        }
        else if (error) {
            window.console.log(error);
        }
        console.log(this.data);
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
       // alert('this.endingRecord><>'+this.endingRecord);
       // alert('this.totalRecountCount><>'+this.totalRecountCount);
        this.endingRecord = (this.endingRecord > this.totalRecountCount)
            ? this.totalRecountCount : this.endingRecord;
           // alert(' this.endingRecord222><>'+ this.endingRecord);
        this.data = this.items.slice(this.startingRecord, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;
    }
    /*handlePage(button) {
        this.page = button.target.label;
        // alert('this.page'+this.page);
        this.displayRecordPerPage(this.page);

    }*/
    get disablePrevious() {
        return this.page <= 1
    }
    get disableNext() {
        return this.page >= this.totalPage
    }
    FirstPageHandler() {
        this.page = 1;
        this.displayRecordPerPage(this.page);
    }
    LastPageHandler() {
        this.page = this.totalPage;
        this.displayRecordPerPage(this.page);
    }
}