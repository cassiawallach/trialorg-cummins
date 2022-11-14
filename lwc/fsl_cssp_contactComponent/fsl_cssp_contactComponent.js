import {
  LightningElement,
  track,
  wire
} from 'lwc';
import updateserviceReqContact from '@salesforce/apex/fsl_cssp_contactController.updateContact';
import saveCaseRecord1 from '@salesforce/apex/FSL_CSSP_equipmentController.saveCase';
import updateContactpho from '@salesforce/apex/fsl_cssp_contactController.updateContactPhone';
import getAssetsRecord from '@salesforce/apex/FSL_CSSP_equipmentController.getAssetsRecord';
import getContactId from '@salesforce/apex/FSL_CSSP_equipmentController.getContactId';
import selectedEquipmentLabel from '@salesforce/label/c.FSL_Selected_Equipment';
import requestorInformationLabel from '@salesforce/label/c.FSL_Requestor_Information';
import submitLabel from '@salesforce/label/c.CSS_Submit';
import backLabel from '@salesforce/label/c.FSL_Back';
import cancelLabel from '@salesforce/label/c.FSL_Close_Chevron_Cancel';
import unitLabel from '@salesforce/label/c.css_unit';
import makeLabel from '@salesforce/label/c.FSL_Make';
import modelLabel from '@salesforce/label/c.CSS_Model';
import registrationLabel from '@salesforce/label/c.FSL_Registration';
import serialNoLabel from '@salesforce/label/c.FSL_Serial_Number_ESN_PSN';
import serviceRequestLabel from '@salesforce/label/c.FSL_Service_Request';
import hasCreatedLabel from '@salesforce/label/c.FSL_has_been_created_successfully';
import detailsLabel from '@salesforce/label/c.CSS_Details';
import fileuploadcomments from '@salesforce/label/c.FSL_FileUpload';
import businessNameLabel from '@salesforce/label/c.FSL_CSSP_Business_Name';// Added for Story#CT4-752
import businessAddressLabel from '@salesforce/label/c.FSL_CSSP_Business_Address';// Added for Story#CT4-752
import selectedLocationLabel from '@salesforce/label/c.FSL_CSSP_Selected_Location';// Added for Story#CT4-752
import issueDescriptionLabel from '@salesforce/label/c.FSL_CSSP_Issue_Description';// Added for Story#CT4-752
import submitedOnLabel from '@salesforce/label/c.FSL_CSSP_Submitted_On';// Added for Story#CT4-752
import homeScreenLabel from '@salesforce/label/c.FSL_CSSP_Go_To_Home_Screen';// Added for Story#CT4-752
import confirmationLabel from '@salesforce/label/c.FSL_CSSP_Confirmation';// Added for Story#CT4-752
import cancelMessageLabel from '@salesforce/label/c.FSL_CSSP_Cancel_Message';// Added for Story#CT4-752
import yesLabel from '@salesforce/label/c.css_Yes';// Added for Story#CT4-752
import noLabel from '@salesforce/label/c.CSS_No';// Added for Story#CT4-752
import MobilePhone from '@salesforce/label/c.MobilePhone';
import Email from '@salesforce/label/c.Email';
import FirstName from '@salesforce/label/c.FirstName';
import LastName from '@salesforce/label/c.LastName';
//import TruckImage from '@salesforce/resourceUrl/csp_TruckImage';
//import { CurrentPageReference } from 'lightning/navigation';
//import { fireEvent } from 'c/pubsub';

export default class Fsl_cssp_contactComponent extends LightningElement {

  label = {
    Email,
    FirstName,
    LastName,
    MobilePhone,
    yesLabel,
    noLabel,
	fileuploadcomments,
    selectedEquipmentLabel,
    requestorInformationLabel,
    submitLabel,
    backLabel,
    cancelLabel,
    unitLabel,
    makeLabel,
    modelLabel,
    registrationLabel,
    serialNoLabel,
    serviceRequestLabel,
    hasCreatedLabel,
    detailsLabel,
    businessNameLabel,// Added for Story#CT4-752
    businessAddressLabel,// Added for Story#CT4-752
    issueDescriptionLabel,// Added for Story#CT4-752
    submitedOnLabel,// Added for Story#CT4-752
    homeScreenLabel,// Added for Story#CT4-752
    selectedLocationLabel// Added for Story#CT4-752
  };
  //@wire(CurrentPageReference) pageRef;
  @track fname;
  @track emailcon;
  @track lname;
  @track mobphone;
  @track assetrecId;
  @track displayCon = true;
  @track displaySuccMsg = false;
  //@track truckImg = TruckImage;
  @track recordId;
  @track error;
  @track ContactName;
  @track ContactEmail;
  @track ContactPhone;
  @track AccountName;
  @track contId;
  //@track AccountAddress;
  @track AccountBillStreet;
  @track AccountBillCity;
  @track AccountBillState;
  @track AccountBillPCode;
  @track AccountBillCountry;
  @track ContactRecordId;
  @track AccountId;
  @track retrievedCaseId;

  @track visible = false; //used to hide/show dialog
  //@track confirmLabel = ''; //confirm button label
  //@track cancelLabel = ''; //cancel button label
  @track message = '';



  connectedCallback() {
    let basrurl = window.location.search;
    //c/csp_headerStepsconst queryString = window.location.search;
    let urlParams = new URLSearchParams(basrurl);
    this.assetrecId = urlParams.get("AssetId");
    // sessionStorage.setItem('ContactId', contactsID);
    this.recordId = sessionStorage.getItem("ContactId");
  }
  @track assetRecordInfo;
  @track astId;
  @track displayEquipmentTable = false; //Added for Story# CT4-718
  @wire(getAssetsRecord, {
    asstID: '$assetrecId'
  })
  AssetsRecord({
    data,
    error
  }) {
    if (data) {
      console.log('dta' + JSON.stringify(data));
      if (data.length > 0) {//Added for Story# CT4-718
        this.assetRecordInfo = data;
        this.astId = data.Id;
        this.displayEquipmentTable = true;
      }
      // console.log('astId___ ' + this.astId);
    } else if (error) {
      console.log('error' + error);

    }
  }

  @wire(getContactId)
  ContactId({
    error,
    data
  }) {
    if (data) {

      this.ContactRecordId = data.Id;
      this.AccountId = data.Account.Id;
      this.AccountName = data.Account.Name;

      console.log('Response date ---- ' + data);
      console.log('Response JSON ---- ' + JSON.stringify(data));
    } else if (error) {
      console.log('Response data ---- ' + error);
      this.ContactRecordId = '';
      this.AccountId = '';
    }
  }


  handleConInput(event) {
    if (event.target.name == 'fstname') {
      this.fname = event.target.value;
      console.log('this.fname' + this.fname);
    }
    if (event.target.name == 'email') {
      this.emailcon = event.target.value;
      //alert('this.emailcon' + this.emailcon);
    }
    if (event.target.name == 'lstname') {
      this.lname = event.target.value;
      console.log('this.lname' + this.lname);
    }
    if (event.target.name == 'phone') {
      this.mobphone = event.target.value;
      console.log('this.mobphone' + this.mobphone);
    }

  }
  @track caseNmuber;
  @track caseRecord;
  @track caseId;
  saveContact() {
    let caseIdValue = sessionStorage.getItem('CaseId');
    this.caseId = caseIdValue;
    updateserviceReqContact({
        serviceReqId: caseIdValue,
      })
      .then(caseId => {
        if (caseId) {
          console.log('caseId___ ', +JSON.stringify(caseId));
          this.displayCon = false;
          this.displaySuccMsg = true;
          let unit = caseId;
          this.caseNmuber = caseId[0].CaseNumber;
          this.caseRecord = caseId;
            console.log('@@@caseId___ ', +JSON.stringify(caseId));
          sessionStorage.clear();
          let case123 = sessionStorage.getItem('CaseId');
          console.log('caseID--- ' + case123);
        }
      }).catch(error => {
        console.log('error ', error);
        alert('Please fill the below details and click on process button');
      });

  }
  navigateToHome() {
    let urlString = window.location.origin;
    window.location.href = urlString + "/" + "cssp" + "/s";
  }

  /* sendBack() {
    let urlString = window.location.origin;
    window.location.href = urlString + "/" + "cssp" + "/s/serviceinfo";
  } */

  goBack() {
    let urlString = window.location.origin;
    var finalURL = urlString + "/" + "cssp" + "/s/serviceinfo?AssetId=" + this.assetrecId;
    window.location.assign(finalURL);
  }

  doCancel() {

    this.title = confirmationLabel;
    this.message = cancelMessageLabel;
    this.visible = true;

  }

  confirmClick() {
    this.visible = false;
    let urlString = window.location.origin;
    var finalURL = urlString + "/" + "cssp" + "/s/new-service-request";
    window.location.assign(finalURL);
    // #CT4_719 Cancel Button Story related changes Start
    sessionStorage.clear();
    // #CT4_719 Cancel Button Story related changes End

  }

  canceClick() {
    this.visible = false;
  }


  handleSuccess(event) {
    console.log(JSON.stringify(event.target.recordId));
    this.contId = JSON.stringify(event.target.recordId);
    console.log('recordId__ ' + this.recordId);
    if (this.recordId != null) {
      //alert('this.recordId <>'+event.detail );
      console.log('handleSuccess__ ' + JSON.stringify(event.detail));
      this.saveCaseRecord();

    }

  }

  saveCaseRecord() {
    let selectedLocation = sessionStorage.getItem('locAddress');
    let serviceTerritoryID = sessionStorage.getItem('serviceTerritoryID');
    let sfid = sessionStorage.getItem('sfid');
    let ServiceDateTime = sessionStorage.getItem('ServiceDateTime');
    let ProductMileage = sessionStorage.getItem('ProductMileage');
    let UnitOfMeasure = sessionStorage.getItem('UnitOfMeasure');
    let GeneralSymptoms = sessionStorage.getItem('GeneralSymptoms');
    // let userinput = sessionStorage.getItem('AssetId'); // comment added for story#CT4-718
    let accountId = sessionStorage.getItem('accountId');
    let ConId = sessionStorage.getItem('ConId');

    if (this.assetrecId === 'undefined') { // Added for story# CT4-718 if Asset Id is undefined to make it to null
      this.assetrecId = null;


    }


    this.disableButton = true;
    var serviceReq = {
      'sobjectType': 'Case',
      'Service_Type__c': sfid,
      'Available_for_Service__c': ServiceDateTime,
      'Product_Mileage__c': ProductMileage,
      'Product_Mileage_Unit__c': UnitOfMeasure,
      'Description': GeneralSymptoms,
      'General_Symptoms__c': GeneralSymptoms,
      // 'Available_for_Service__c': this.Equipmentdate,
      // 'RecordType':'FSL Reported Problem',
      //'AssetId': userinput, // comment added for story#CT4-719
      'AssetId': this.assetrecId, // Added for story#CT4-719
      'AccountId': accountId,
      'Location__c': selectedLocation,
      'Service_location__c': selectedLocation,
      'Service_Territory__c': serviceTerritoryID,
      'ContactId': this.ContactRecordId
    }

    console.log('serviceReq=========' + JSON.stringify(serviceReq));

    saveCaseRecord1({
        serviceRequest: serviceReq
      })
      .then(caseId => {
        if (caseId) {
          this.retrievedCaseId = caseId;
          console.log('CASEId' + this.retrievedCaseId);
          sessionStorage.setItem('CaseId', this.retrievedCaseId);
          let caseIdValue = sessionStorage.getItem('CaseId');
          if (caseIdValue != null) {
            this.saveContact();
          }

        }
      }).catch(error => {
        this.disableButton = false;
        console.log('error ', error);
      });
  }

  handleError(event) {
    console.log(JSON.stringify(event.detail));
    var eventName = event.getName();
    var eventDetails = event.getParam("error");
  }
}