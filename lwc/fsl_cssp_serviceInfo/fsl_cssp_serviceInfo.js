import {
  LightningElement,
  wire,
  track
} from 'lwc';
import getAssetsRecord from '@salesforce/apex/FSL_CSSP_equipmentController.getAssetsRecord';
import saveCaseRecord from '@salesforce/apex/FSL_CSSP_equipmentController.saveCase';
import AirCondtion from '@salesforce/resourceUrl/cssp_Aircondtion';
import BatteryIcon from '@salesforce/resourceUrl/cssp_Battery';
import BrakeIcon from '@salesforce/resourceUrl/cssp_brake';
import FuelGas from '@salesforce/resourceUrl/cssp_Fuelgas';
import TireIcon from '@salesforce/resourceUrl/cssp_Tire';
import FileUploadText from '@salesforce/label/c.File_Upload_Text';
import selectedEquipmentLabel from '@salesforce/label/c.FSL_Selected_Equipment';
import serviceInformationLabel from '@salesforce/label/c.FSL_Immediate_Assessment_Date';
//import proceedLabel from '@salesforce/label/c.FSL_Proceed';
import backLabel from '@salesforce/label/c.FSL_Back';
import cancelLabel from '@salesforce/label/c.FSL_Close_Chevron_Cancel';
import unitLabel from '@salesforce/label/c.css_unit';
import makeLabel from '@salesforce/label/c.FSL_Make';
import modelLabel from '@salesforce/label/c.CSS_Model';
import registrationNoLabel from '@salesforce/label/c.FSL_CSSP_License_Number';
import serialNoLabel from '@salesforce/label/c.FSL_Serial_Number_ESN_PSN';
import equipmentDateTimeLabel from '@salesforce/label/c.FSL_CSSP_Equipment_Arrival_Date_and_Time';// Added for Story#CT4-752
import dateTimeHelpTextLabel from '@salesforce/label/c.FSL_CSSP_DateTimeHelpText';// Added for Story#CT4-752
import productMileageOptionalLabel from '@salesforce/label/c.FSL_CSSP_Product_Mileage_Optional';// Added for Story#CT4-752
import productMileagePlaceolderLabel from '@salesforce/label/c.FSL_CSSP_Product_Mileage_Placeholder';// Added for Story#CT4-752
import mileageMeasureLabel from '@salesforce/label/c.FSL_CSSP_Mileage_Measure_optional';// Added for Story#CT4-752
import generalSymptomsLabel from '@salesforce/label/c.FSL_CSSP_General_Symptoms';// Added for Story#CT4-752
import generalSymptomsHelpTextLabel from '@salesforce/label/c.FSL_CSSP_General_Symptoms_Help_Text';// Added for Story#CT4-752
import generalSymptomsPlaceHolderLabel from '@salesforce/label/c.FSL_CSSP_General_Symptoms_PlaceHolder';// Added for Story#CT4-752
import proceedLabel from '@salesforce/label/c.FSL_Proceed';// Added for Story#CT4-752
import milesLabel from '@salesforce/label/c.FSL_Mileage_Miles';// Added for Story#CT4-752
import kilometersLabel from '@salesforce/label/c.FSL_CSSP_Kilometers';// Added for Story#CT4-752
import houresLabel from '@salesforce/label/c.css_hours';// Added for Story#CT4-752
import generalSymtomsErrorLabel from '@salesforce/label/c.FSL_CSSP_General_Symptoms_Error';// Added for Story#CT4-752
import generalSymtomsCharactersLimitLabel from '@salesforce/label/c.FSL_CSSP_General_Symptoms_Characters_Limit';// Added for Story#CT4-752
import confirmationLabel from '@salesforce/label/c.FSL_CSSP_Confirmation';// Added for Story#CT4-752
import cancelMessageLabel from '@salesforce/label/c.FSL_CSSP_Cancel_Message';// Added for Story#CT4-752
import yesLabel from '@salesforce/label/c.css_Yes';// Added for Story#CT4-752
import noLabel from '@salesforce/label/c.CSS_No';// Added for Story#CT4-752
import {
  ShowToastEvent
} from 'lightning/platformShowToastEvent';
import {
  NavigationMixin
} from 'lightning/navigation';
import Id from "@salesforce/user/Id";
import getUserDetails from "@salesforce/apex/FSL_CSSP_equipmentController.currentuser";
const MAX_FILE_SIZE = 100000000; //10mb

export default class Fsl_cssp_serviceInfo extends LightningElement {
  label = {
    FileUploadText,
    selectedEquipmentLabel,
    equipmentDateTimeLabel,// Added for Story#CT4-752
    dateTimeHelpTextLabel,// Added for Story#CT4-752
    productMileageOptionalLabel,// Added for Story#CT4-752
    productMileagePlaceolderLabel,// Added for Story#CT4-752
    mileageMeasureLabel,// Added for Story#CT4-752
    generalSymptomsLabel,// Added for Story#CT4-752
    generalSymptomsHelpTextLabel,// Added for Story#CT4-752
    generalSymptomsPlaceHolderLabel,// Added for Story#CT4-752
    proceedLabel,// Added for Story#CT4-752
    yesLabel,// Added for Story#CT4-752
    noLabel,// Added for Story#CT4-752
    serviceInformationLabel,
    backLabel,
    cancelLabel,
    unitLabel,
    makeLabel,
    modelLabel,
    registrationNoLabel,
    serialNoLabel
  };
  //getting contactId
  userId = Id;
  //  @track user;
  @track error;
  @track ConId;
  @track accountId;

  @track visible = false; //used to hide/show dialog
  @track confirmLabel; //confirm button label
  @track cancelLabel; //cancel button label
  @track messagevalue;
  @track titlemessage;
  retrievedCaseId;


  @wire(getUserDetails, {
    loggedInUserId: "$userId"
  })

  wiredUser({
    error,
    data
  }) {
    if (data) {
      let userData = data;
      // this.fname = this.user[0].FirstName;

      let contactsID = userData[0].ContactId;
      this.ConId = contactsID;
      let accID = userData[0].AccountId;
      this.accountId = accID;
      sessionStorage.setItem('accountId', this.accountId);


      //let ContactAddress = this.user[0].Contact.MailingStreet;
      // alert('this.ConId >>'+this.ConId);
      sessionStorage.setItem('ContactId', this.ConId);

    } else if (error) {
      this.error = error;
    }
  }
  //
  value = 'Other';
  @track value = 'Miles';
  get recentAddress() {
    return [{
        label: 'Miles',
        value: 'Miles'
      },
      {
        label: 'Kilometers',
        value: 'Kilometers'
      },
      {
        label: 'Hours',
        value: 'Hours'
      }
    ];
  }

  get options() {
    return [{
        label: 'Taillights',
        value: 'Taillights'
      },
      {
        label: 'Windshield',
        value: 'Windshield'
      },
      {
        label: 'Other',
        value: 'Other'
      }

    ];
  }
  get Units() {
    return [{
        //label: 'Miles',
        label: milesLabel,
        value: 'Miles'
      },
      {
        //label: 'Kilometers',
        label: kilometersLabel,
        value: 'Kilometers'
      },
      {
        //label: 'Hours',
        label: houresLabel,
        value: 'Hours'
      }
    ];
  }

  /* Cancel Button Logic*/
  docancel() {

    this.titlemessage = confirmationLabel;
    this.messagevalue = cancelMessageLabel;
    this.visible = true;

  }

  goBack() {
    let serviceTerritoryID = sessionStorage.getItem('serviceTerritoryID');
    let urlString = window.location.origin;
    var finalURL = urlString + "/" + "cssp" + "/s/servicetab?accId=" + serviceTerritoryID;
    window.location.assign(finalURL);
  }

  ConfirmClick() {
    this.visible = false;
    let urlString = window.location.origin;
    var finalURL = urlString + "/" + "cssp" + "/s/new-service-request";
    window.location.assign(finalURL);
    // #CT4_719 Cancel Button Story related changes Start
    sessionStorage.clear();
    // #CT4_719 Cancel Button Story related changes End

  }

  CanceClick() {
    this.visible = false;
  }
  /* Cancel Button Logic end*/




  handleChange(event) {
    this.sfid = event.detail.value;
    //alert('this.value <>' + this.sfid);
  }

  handleredirectToLocation() {
    let urlstring = window.location.origin;
    window.location.href = urlstring + '/cumminsserviceportal' + '/s/location';

  }
  @track userinput;
  @track aircon = AirCondtion;
  @track BatteryIcn = BatteryIcon;
  @track BrakeIcon = BrakeIcon;
  @track fuelGasIcon = FuelGas;
  @track TireIcon = TireIcon;

  connectedCallback() {

    let basrurl = window.location.search;
    //c/csp_headerStepsconst queryString = window.location.search;
    let urlParams = new URLSearchParams(basrurl);
    this.userinput = urlParams.get("AssetId");
    
    sessionStorage.setItem('AssetId', this.userinput);
    //this.recordId = sessionStorage.getItem("ContactId");
    //alert('this.userinput<><>' + this.userinput);

  }

  renderedCallback() {
    let generalSymptoms_session = sessionStorage.getItem("GeneralSymptoms");
    let generalSymptoms_textBox = this.template.querySelector(".GeneralSymptoms");
    generalSymptoms_textBox.value = generalSymptoms_session;
    this.GeneralSymptoms = generalSymptoms_session;
    console.log('GeneralSymptoms:', generalSymptoms_textBox);

    let productMileage_session = sessionStorage.getItem("ProductMileage");
    let productMileage_textBox = this.template.querySelector(".ProductMileage");
    productMileage_textBox.value = productMileage_session;
    this.ProductMileage = productMileage_session;
    console.log('productMileage:', productMileage_textBox);

    let UnitOfMeasure_session = sessionStorage.getItem("UnitOfMeasure");
    let UnitOfMeasure_textBox = this.template.querySelector(".UnitOfMeasure");
    UnitOfMeasure_textBox.value = UnitOfMeasure_session;
    this.UnitOfMeasure = UnitOfMeasure_session;
    console.log('UnitOfMeasure:', UnitOfMeasure_textBox);

    let ServiceDateTime_session = sessionStorage.getItem("ServiceDateTime");
    let ServiceDateTime_textBox = this.template.querySelector(".ServiceDateTime");
    ServiceDateTime_textBox.value = ServiceDateTime_session;
    this.ServiceDateTime = ServiceDateTime_session;
    console.log('ServiceDateTime:', ServiceDateTime_textBox);
  }

  @track assetRecordInfo;
  @track astId;
  @track displayEquipmentTable=false;
  @wire(getAssetsRecord, {
    asstID: '$userinput'
  })
  AssetsRecord({
    data,
    error
  }) {

    if (data) {
      console.log('dta' + JSON.stringify(data));
      if(data.length>0){
        this.assetRecordInfo = data;
        this.displayEquipmentTable = true;
        

      }
   
     
     
      // this.astId = assetRecordInfo.Id;
      // console.log('asstId' + astId);
    } else if (error) {
      console.log('error' + error);

    }
  }
  @track sfid;
  @track UnitOfMeasure;
  @track ProductMileage;
  @track GeneralSymptoms;
  @track Equipmentdate;
  @track ServiceDateTime;
  handleImageclick1(event) {
    this.sfid = event.currentTarget.getAttribute("data-sfid");
    sessionStorage.setItem('sfid', this.sfid);
    //alert('this.sfid' + this.sfid);
  }
  //UnitOfMeasure = 'Miles';
  handleImageclick(event) {


    // let inputId = event.target.value;
    //console.log('this.sfid' + this.sfid);
    //alert('InputValue'+this.sfid);
    if (event.target.name == 'ProductMileage') {
      this.ProductMileage = event.target.value;
      sessionStorage.setItem('ProductMileage', this.ProductMileage);
      console.log('this.ProductMileage' + this.ProductMileage);
    }
    if (event.target.name == 'UnitOfMeasure') {
      this.UnitOfMeasure = event.target.value;
      sessionStorage.setItem('UnitOfMeasure', this.UnitOfMeasure);
      //alert('this.UnitOfMeasure' + this.UnitOfMeasure);
    }
    if (event.target.name == 'GeneralSymptoms') {
      this.GeneralSymptoms = event.target.value;
      sessionStorage.setItem('GeneralSymptoms', this.GeneralSymptoms);
      console.log('this.GeneralSymptoms' + this.GeneralSymptoms);
    }
    if (event.target.name == 'ServiceDateTime') {
      this.ServiceDateTime = event.target.value;
      sessionStorage.setItem('ServiceDateTime', this.ServiceDateTime);
      console.log('this.ServiceDateTime' + this.ServiceDateTime);
    }
    if (event.target.name == 'Equipmentdate') {
      this.Equipmentdate = event.target.value;
      sessionStorage.setItem('Equipmentdate', this.Equipmentdate);
      console.log('this.Equipmentdate' + this.Equipmentdate);
    }

  }
  uploadedFiles = [];
  file;
  fileContents;
  fileReader;
  content;
  @track fileName;
  onFileUpload(event) {
    if (event.target.files.length > 0) {

      const uploadedFiles = event.target.files;
      let uploadedFileNames = '';
      for (let i = 0; i < uploadedFiles.length; i++) {
        uploadedFileNames += uploadedFiles[i].name + ', ';
        this.fileName = uploadedFileNames;
        this.file = uploadedFiles[i];
        console.log('uploadedFileNames<>' + uploadedFileNames);
        console.log('this.fileName<>' + this.fileName);
        console.log('this.fileName<>' + this.file);
      }
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Success',
          message: uploadedFiles.length + ' Files uploaded Successfully: ' + uploadedFileNames,
          variant: 'success',
        }),
      );
    }
  }
  saveCase() {

    if (this.fileName != null && this.fileName != 'undefined') {
      this.fileReader = new FileReader();
      // alert('Im in save');

      // alert('Im in if');
      this.fileReader.onloadend = (() => {
        this.fileContents = this.fileReader.result;
        // alert('this.this.fileContents.result'+this.fileContents);       
        let base64 = 'base64,';
        this.content = this.fileContents.indexOf(base64) + base64.length;
        this.fileContents = this.fileContents.substring(this.content);
        this.saveCaseRecord();
      });

      this.fileReader.readAsDataURL(this.file);

    } else {
      // alert('Im in else');
      //this.saveCaseRecord();
    }

  }

  saveCaseRecord() {

    //alert('I am in saverecord');
    let selectedLocation = sessionStorage.getItem('locAddress');
    let serviceTerritoryID = sessionStorage.getItem('serviceTerritoryID');
    // alert(' serviceTerritoryID'+serviceTerritoryID);

    
    //  this.disableButton = true;
      var serviceReq = {
        'sobjectType': 'Case',
        'Service_Type__c': this.sfid,
        'Available_for_Service__c': this.ServiceDateTime,
        'Product_Mileage__c': this.ProductMileage,
        'Product_Mileage_Unit__c': this.UnitOfMeasure,
       'General_Symptoms__c': this.GeneralSymptoms,
        'Description':this.GeneralSymptoms,
        // 'Available_for_Service__c': this.Equipmentdate,
        // 'RecordType':'FSL Reported Problem',
        'AssetId': this.userinput,
        'AccountId': this.accountId,
        'Location__c': selectedLocation,
        'Service_location__c': selectedLocation,
        'Service_Territory__c': serviceTerritoryID,
        'ContactId': this.ConId
      }
    console.log('serviceReq=========' + JSON.stringify(serviceReq));

      saveCaseRecord({
          serviceRequest: serviceReq
          
        })
        .then(caseId => {
          if (caseId) {
            this.retrievedCaseId = caseId;
            console.log('CASEId' + JSON.stringify(caseId));
            sessionStorage.setItem('CaseId', caseId);
            //alert('CASEId' + JSON.stringify(caseId));
            this.handleequipmentInfo1();
          }
        }).catch(error => {
        //  this.disableButton = false;
          console.log('error ', error);
          //alert('Please enter the required fields');
        });
  } 

  /*   handleFileSave(evt) {

      let isSuccess = evt.detail.isAllFilesUploaded;
      if (isSuccess) {
        alert(isSuccess);
        //this.handleequipmentInfo1();
      } else {

      }
    } */

    handleequipmentInfo1() {

      if (this.ServiceDateTime == null || this.ServiceDateTime == 'undefined') {
        alert('Please select the Equipment Arrival Date and Time and click on proceed button');
        return true;
      }
    let urlstring = window.location.origin;
        window.location.href = urlstring + '/cssp' + '/s/contact?' + 'AssetId=' + this.userinput;
        console.log('window.location.href<>' + window.location.href);

   /* if (this.GeneralSymptoms == null || this.GeneralSymptoms == 'undefined') {
      //alert('Please enter General Symptoms');
      alert(generalSymtomsErrorLabel);
      return true;
    } else {

      let gsVal = this.GeneralSymptoms;
      if (gsVal.length < 3) {
        alert(generalSymtomsCharactersLimitLabel);
        return true;
      } else {
        let urlstring = window.location.origin;
        window.location.href = urlstring + '/cssp' + '/s/contact?' + 'AssetId=' + this.userinput;
        console.log('window.location.href<>' + window.location.href);
      }
    }*/


  }
}