import {
    LightningElement,
    track,
    wire,
    api
} from 'lwc';
import getAssetslist from '@salesforce/apex/FSL_CSSP_equipmentController.getAssetslist';
import getAssetsRecord from '@salesforce/apex/FSL_CSSP_equipmentController.getAssetsRecord';
import saveAssetRecord from '@salesforce/apex/FSL_CSSP_equipmentController.saveAssetRecord';
import equipmentDetailsLabel from '@salesforce/label/c.FSL_Equipment_Details';
import scheduleEquipmentListedLabel from '@salesforce/label/c.FSL_Schedule_Equipment_Listed';
import scheduleEquipmentNotListedLabel from '@salesforce/label/c.FSL_Schedule_Equipment_Not_Listed';
import listOfEquipmentsLabel from '@salesforce/label/c.FSL_List_of_Equipments';
import serialNoLabel from '@salesforce/label/c.FSL_Serial_Number_ESN_PSN';
//import proceedLabel from '@salesforce/label/c.FSL_Proceed';
import backLabel from '@salesforce/label/c.FSL_Back';
import cancelLabel from '@salesforce/label/c.FSL_Close_Chevron_Cancel';
import unitLabel from '@salesforce/label/c.css_unit';
import unitNoLabel from '@salesforce/label/c.CSS_Unit_Num';
import makeLabel from '@salesforce/label/c.CSS_Make';
import modelLabel from '@salesforce/label/c.CSS_Model';
import registrationNoLabel from '@salesforce/label/c.FSL_CSSP_License_Number';
import licensePlateNoLabel from '@salesforce/label/c.FSL_License_Plate_Number';
import proceedLabel from '@salesforce/label/c.FSL_Proceed';// Added for Story#CT4-752
import equipmentErrorMessage from '@salesforce/label/c.FSL_CSSP_Equipment_Error_Message';// Added for Story#CT4-752
import confirmationLabel from '@salesforce/label/c.FSL_CSSP_Confirmation';// Added for Story#CT4-752
import cancelMessageLabel from '@salesforce/label/c.FSL_CSSP_Cancel_Message';// Added for Story#CT4-752
import yesLabel from '@salesforce/label/c.css_Yes';// Added for Story#CT4-752
import noLabel from '@salesforce/label/c.CSS_No';// Added for Story#CT4-752
import clicktoProceedLabel from '@salesforce/label/c.FSL_CSSP_Click_to_Proceed';// Added for Story#CT4-752
import newequipmentLabel from '@salesforce/label/c.FSL_CSSP_New_equipment_details';// Added for Story#CT4-752
import displayingLabel from '@salesforce/label/c.FSL_Displaying';// Added for Story#CT4-752
import recordLabel from '@salesforce/label/c.FSL_records';// Added for Story#CT4-752
import pageLabel from '@salesforce/label/c.FSL_Page';// Added for Story#CT4-752
import ofLabel from '@salesforce/label/c.FSL_Of';// Added for Story#CT4-752
import toLabel from '@salesforce/label/c.FSL_Too';// Added for Story#CT4-752
import firstPageLabel from '@salesforce/label/c.FSL_First_Page';// Added for Story#CT4-752
import nextPageLabel from '@salesforce/label/c.FSL_Next';// Added for Story#CT4-752
import lastPageLabel from '@salesforce/label/c.FSL_Last_Page';// Added for Story#CT4-752
import previousPageLabel from '@salesforce/label/c.FSL_Previous';// Added for Story#CT4-752


//import TruckImage from '@salesforce/resourceUrl/csp_TruckImage';
const radioOpt_label1 = 'Schedule Equipment Listed'//scheduleEquipmentListedLabel;
const radioOpt_label2 = 'Schedule Equipment Not Listed'//scheduleEquipmentNotListedLabel;

export default class Fsl_cssp_equipmentDetails extends LightningElement {
    // Added below Pagination Varaibles for Story# CT4-743 - Start
    @track page = 1;
    @track items = [];
    @track startingRecord = 1;
    @track endingRecord = 0;
    @track pageSize = 20;
    @track totalRecountCount = 0;
    @track totalPage = 0;
    @track showPagination;
    pagelinks = [];
    // END - Pagination Varaibles for Story# CT4-743 - END
    label = {
        clicktoProceedLabel,
        newequipmentLabel,
        equipmentDetailsLabel,
        scheduleEquipmentListedLabel,
        scheduleEquipmentNotListedLabel,
        listOfEquipmentsLabel,
        serialNoLabel,
        backLabel,
        cancelLabel,
        unitLabel,
        unitNoLabel,
        makeLabel,
        modelLabel,
        registrationNoLabel,
        proceedLabel,// Added for Story#CT4-752
        yesLabel,// Added for Story#CT4-752
        noLabel,// Added for Story#CT4-752
        licensePlateNoLabel,
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
    @track serviceData;
    @track make;
    @track model;
    @track assetnumber;
    @track enginegeneratormodel;
    @track unitnumber;
    @track modelyear;
    @track licenseNumber;

    @api visibleDiv = false;
    @track confirmLabel;
    @track cancelLabel;
    @track message;
    @track title;

    parameters = {};
    selectedAccId = '';
    // @track truckImg = TruckImage;
    value = 'Schedule Equipment Listed';
    handleInputChange(event) {
        if (event.target.name == 'assetnumber') {
            this.assetnumber = event.target.value;
            sessionStorage.setItem('assetnumber', this.assetnumber);
            console.log('this.assetnumber' + this.assetnumber);
        }
        if (event.target.name == 'unitnumber') {
            this.unitnumber = event.target.value;
            sessionStorage.setItem('unitnumber', this.unitnumber);
            console.log('this.make' + this.unitnumber);
        }
        if (event.target.name == 'make') {
            this.make = event.target.value;
            sessionStorage.setItem('make', this.make);
            console.log('this.make' + this.make);
        }
        if (event.target.name == 'model') {
            this.model = event.target.value;
            sessionStorage.setItem('model', this.model);
            console.log('this.make' + this.model);
        }

        if (event.target.name == 'enginegeneratormodel') {
            this.enginegeneratormodel = event.target.value;
            sessionStorage.setItem('enginegeneratormodel', this.enginegeneratormodel);
            console.log('this.make' + this.enginegeneratormodel);
        }

        if (event.target.name == 'licenseNumber') {
            this.licenseNumber = event.target.value;
            sessionStorage.setItem('licenseNumber', this.licenseNumber);
            console.log('this.licenseNumber' + this.licenseNumber);
        }

    }
    @track record;
    getAssetInsertRecord() {
        /*  if (this.unitnumber === null || this.unitnumber === '' || this.enginegeneratormodel === null || this.enginegeneratormodel === '' ||
              this.assetnumber === null || this.assetnumber === '' || this.model === null || this.model === '' ||
              this.make === null || this.make === '' || this.licenseNumber === null || this.licenseNumber === '') {
              alert('Please enter the Asset Number or Product Serial Number and click on Proceed');
          } else {
        

              //  if(dataExist == false)
              // {

              // alert(this.assetnumber + ' ' + this.unitnumber + ' ' + this.licenseNumber + ' ' +  this.enginegeneratormodel + ' ' + this.model  + ' ' + this.make);
              saveAssetRecord({
                      make: this.make,
                      model: this.model,
                      assetnumber: this.assetnumber,
                      enginegeneratormodel: this.enginegeneratormodel,
                      unitnumber: this.unitnumber,
                      licenseNumber: this.licenseNumber

                  }).then(result => {
                      this.record1 = result;


                      console.log('this.record<> ' + this.record);
                      console.log('result<><> ' + JSON.stringify(result));
                      this.record = this.record1.Id;
                      //console.log(c);

                      // if()
                      this.handleequipmentInfo1();

                  })
                  .catch(error => {
                      console.log('error<> ' + JSON.stringify(error));
                      alert('Please enter the Asset Number or Product Serial Number and click on Proceed');
                  })

           
          }*/ //Commented code since portal user does not have ability to create a new asset record. as per story#CT4-718
        //Added below code for story#CT4-718
        let urlstring = window.location.origin;
        window.location.href = urlstring + '/cssp' + '/s/serviceinfo?' + 'AssetId=' + this.record;
    }



    showdata = true;
    get options() {
        return [{
            label: scheduleEquipmentListedLabel,
            value: 'Schedule Equipment Listed'
        },
        {
            label: scheduleEquipmentNotListedLabel,
            value: 'Schedule Equipment Not Listed'
        },
        ];
    }

    handleChange(event) {
        this.selectedValue = event.detail.value;
        //  alert('selectedValue '+this.selectedValue);
        sessionStorage.setItem("radioGroup", event.detail.value);
        if (this.selectedValue === 'Schedule Equipment Listed') {
            // alert('selectedValue '+this.selectedValue);
            this.showdata = true;
            this.serviceData = 'hello data';
        } else {
            // this.showdata = false; commented this line as per story# CT4-718
            //alert('I am in else');
            let urlstring = window.location.origin;//Added code for story# CT4-718
            window.location.href = urlstring + '/cssp' + '/s/serviceinfo?' + 'AssetId=' + this.record;//Added code for story# CT4-718
        }
    }

    connectedCallback() {

        this.parameters = this.getQueryParameters();
        //console.log('parameters====='+JSON.stringify(this.parameters.accId));
        this.selectedAccId = this.parameters.accId;

        /*    getAssetslist({ accId: this.selectedAccId })
                .then((result) => {
                    this.allassetsRecords = result;
                    //alert('dATTT'+JSON.stringify(this.allassetsRecords));
                    this.error = undefined;
                })
                .catch((error) => {
                    this.error = error;
                    this.allassetsRecords = undefined;
                }); */
    }


    renderedCallback() {
        /*connectedCallback() {*/

        let radioGroup_session = sessionStorage.getItem("radioGroup");
        let radioGroup_radio = this.template.querySelector(".radioGroup");
        console.log('radioGroup_session' + radioGroup_session);
        console.log('radioGroup_radio' + radioGroup_radio);
        radioGroup_radio.value = radioGroup_session;
        if (radioGroup_session == null || radioGroup_radio.value == null) {//Added code for story# CT4-718
            sessionStorage.setItem("radioGroup", 'Schedule Equipment Listed');
            // value = 'Schedule Equipment Listed';
            console.log('sessionStorage.getItem("radioGroup");' + sessionStorage.getItem("radioGroup"));
        }
        if (radioGroup_session == radioOpt_label1) {
            this.showdata = true;

            // radioGroup_radio[0].checked = true;
        } else if (radioGroup_session == radioOpt_label2) {
            this.showdata = false;

            // radioGroup_radio[1].checked = true;


        }

        if (radioGroup_radio.value == radioOpt_label2) {
            //Commented below code since portal user does not have ability to create a new asset record. as per story# CT4-718
            //this.showdata = false;

            /* let make_session = sessionStorage.getItem("make");
            let make_textBox = this.template.querySelector(".make");
            make_textBox.value = make_session;
            this.make = make_session;
 
            let model_session = sessionStorage.getItem("model");
            let model_textBox = this.template.querySelector(".model");
            model_textBox.value = model_session;
            this.model = model_session;
 
            let assetnumber_session = sessionStorage.getItem("assetnumber");
            let assetnumber_textBox = this.template.querySelector(".assetnumber");
            assetnumber_textBox.value = assetnumber_session;
            this.assetnumber = assetnumber_session;
 
            let enginegeneratormodel_session = sessionStorage.getItem("enginegeneratormodel");
            let enginegeneratormodel_textBox = this.template.querySelector(".enginegeneratormodel");
            enginegeneratormodel_textBox.value = enginegeneratormodel_session;
            this.enginegeneratormodel = enginegeneratormodel_session;
 
            let unitnumber_session = sessionStorage.getItem("unitnumber");
            let unitnumber_textBox = this.template.querySelector(".unitnumber");
            unitnumber_textBox.value = unitnumber_session;
            this.unitnumber = unitnumber_session;
 
            let licenseNumber_session = sessionStorage.getItem("licenseNumber");
            let licenseNumber_textBox = this.template.querySelector(".licenseNumber");
            licenseNumber_textBox.value = licenseNumber_session;
            this.licenseNumber = licenseNumber_session;
*/
        } else if (radioGroup_radio.value == radioOpt_label1) {

            let assetId_session = sessionStorage.getItem("asst.Id");
            let assetId_radio = this.template.querySelector('[data-id="' + assetId_session + '"]');
            assetId_radio.checked = true;
            this.asstIdvalue = assetId_session;


        }





    }

    backTolocationTab() {
        let urlstring = window.location.origin;
        //window.location.href = urlstring + "/" + "cssp" + "/s/" + "location";
        window.location.href = urlstring + "/" + "cssp" + "/s/" + "location?accId=" + this.selectedAccId;
        Console.log('==== this.selectedAccId ======' + this.selectedAccId);
    }
    getQueryParameters() {

        var params = {};
        var search = location.search.substring(1);

        if (search) {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value)
            });
        }

        return params;
    }

    @track allassetsRecords;
    @wire(getAssetslist)
    assetList(result, error) {  // Added below changes for Pagination for Story# CT4-743 - Start
        if (result.data) {
            // this.allassetsRecords = data; //commented the line for pagination Story# CT4-743
            this.items = result.data;
            this.totalRecountCount = this.items.length;
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
            this.allassetsRecords = this.items.slice(0, this.pageSize);
            this.endingRecord = this.pageSize;
            this.showPagination = true;
            this.page = 1;
            this.displayRecordPerPage(this.page);
            let pageNumber = sessionStorage.getItem("pageNo");
            if (pageNumber != null) {
                this.page = pageNumber;
                this.displayRecordPerPage(pageNumber);
            }
            //Pagination related changes for Story# CT4-743 - END

        }

    }



    @track asstIdvalue;
    handleSelect(event) {

        let selectedRecordId = event.target.dataset.id;
        this.asstIdvalue = selectedRecordId;
        sessionStorage.setItem('asst.Id', selectedRecordId);
        console.log('Inside Cancel');
        console.log('Selected Asset Id' + this.asstIdvalue);
    }
    doProcedd() {

        console.log('this.asstIdvalue' + this.asstIdvalue);
        var el = this.template.querySelector("[data-id='asst.Id']");
        console.log(el);

        if (this.asstIdvalue != undefined) {
            this.handleequipmentInfo1();
        } else {
            // alert('Please select the asset and click on Proceed');
            alert(equipmentErrorMessage);
        }


    }
    docancel(event) {
        this.template.querySelector('form').reset();

    }
    /* Cancel Button Logic*/
    docancel1() {

        this.title = confirmationLabel;
        this.message = cancelMessageLabel;
        this.visibleDiv = true;

    }

    ConfirmClick() {
        this.visibleDiv = false;
        let urlString = window.location.origin;
        var finalURL = urlString + "/" + "cssp" + "/s/new-service-request";
        window.location.assign(finalURL);
        // #CT4_719 Cancel Button Story related changes Start
        sessionStorage.clear();
        // #CT4_719 Cancel Button Story related changes End

    }

    CanceClick() {
        this.visibleDiv = false;

    }

    /* Cancel Button Logic End*/

    handleequipmentInfo1() {
        // window.location.origin;
        // window.location.href = urlString + "/" + "cssp" + "/s/" + "servicetab";
        sessionStorage.setItem('pageNo', this.page); //Added for Pagination Story# CT4-743
        if (this.asstIdvalue != null && this.asstIdvalue != '' && this.asstIdvalue != undefined) {

            let urlstring = window.location.origin;
            window.location.href = urlstring + '/cssp' + '/s/serviceinfo?' + 'AssetId=' + this.asstIdvalue;

        }
        /* else if(this.asstIdvalue == null && this.asstIdvalue == '' && this.asstIdvalue == undefined && this.record !=null){
             alert('Please select one Asset record and click on Proceed button');
         }*/
        if (this.record != null && this.record != '' && this.record != undefined) {

            console.log('recordId><> ' + this.record);
            let urlstring = window.location.origin;
            window.location.href = urlstring + '/cssp' + '/s/serviceinfo?' + 'AssetId=' + this.record;

        }

    }
    // get ScreenLoaded() {
    //     return this.isLoading;
    // }

    // Added below Pagination Methods for Story# CT4-743 - Start
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }

    }
    nextHandler() {
        if ((this.page < this.totalPage) && this.page !== this.totalPage) {
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);
        }
    }
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
    displayRecordPerPage(page) {
        this.startingRecord = ((page - 1) * this.pageSize);
        this.endingRecord = (this.pageSize * page);
        this.endingRecord = (this.endingRecord > this.totalRecountCount)
            ? this.totalRecountCount : this.endingRecord;
        this.allassetsRecords = this.items.slice(this.startingRecord, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;

    }
    //Pagination related changes for Story# CT4-743 - END

}