import { LightningElement, api, track, wire } from 'lwc';
import serviceLocationLabel from '@salesforce/label/c.FSL_CSSP_Service_Location';
import atACumminsLocLabel from '@salesforce/label/c.FSL_At_a_Cummins_Location';
import fieldServiceAtMyLocLabel from '@salesforce/label/c.FSL_Field_Service_at_My_Location';
import equipmentInformationLabel from '@salesforce/label/c.FSL_CSSP_Equipment_Information';
import serviceInformationLabel from '@salesforce/label/c.FSL_CSSP_Service_Information';
import requestorInformationLabel from '@salesforce/label/c.FSL_CSSP_Requestor_Information';

//import { registerListener, unregisterAllListeners } from 'c/pubsub';
//import { CurrentPageReference } from 'lightning/navigation';


export default class Fsl_cssp_headerSteps extends LightningElement {
  label = {
    serviceLocationLabel,
    atACumminsLocLabel,
    equipmentInformationLabel,
    requestorInformationLabel,
    serviceInformationLabel,
    fieldServiceAtMyLocLabel
  };
  //  @wire(CurrentPageReference) pageRef;
    @api step;
    @track _shippingClassName;
    @track _paymentClassName;
    @track _reviewClassName;
    @track _orderClassName;
    @track shipping = this.label.serviceLocationLabel;
   // @track reviewOrder = 'Equipment Information';
    @track reviewOrder = this.label.equipmentInformationLabel;
    @track payment = this.label.serviceInformationLabel;
    @track header = this.label.requestorInformationLabel;
   // @track payment = 'Service Information';
   // @track header = 'Requestor Information';
    @track bool;
  
    //  @track stepShipping = dbu_ShippingOnChkHeaderStep;
    @track stepActive = 'active';
    //  @track stepReview = dbu_ReviewOnChkStep; 
    @track stepCompleted = 'completed';
    //  @track stepPaymentSuccess = dbu_PaymentSuccessOnHeader;
    //  @track StepOrder = dbu_OrderStatusOnHeader;
  
    get shippingClassName() {
      console.log('this.step=>' + this.step);
      if (this.step == 'Service Location') {
        this._shippingClassName = this.stepActive;
        this._reviewClassName = '';
        this._paymentClassName = '';
        this._orderClassName = '';
      }
      if (this.step == 'Equipment Information') {
        this._shippingClassName = this.stepCompleted;
        this._reviewClassName = this.stepActive;
        this._paymentClassName = '';
        this._orderClassName = '';
      }
      if (this.step == 'Service Information') {
        this._shippingClassName = this.stepCompleted;
        this._reviewClassName = this.stepCompleted;
        this._paymentClassName = this.stepActive;
        this._orderClassName = '';
        
      }
      if (this.step == 'Requestor Information') {
        this._shippingClassName = this.stepCompleted;
        this._reviewClassName = this.stepCompleted;
        this._paymentClassName = this.stepCompleted;
         if (this.bool == '')
          this._orderClassName = this.stepActive;
        else
          this._orderClassName = this.stepCompleted;
  
        //alert('hi')
      }
  
  
      return this._shippingClassName;
    }
    //@track accountId;
   /* connectedCallback() {
      // subscribe to eventdetails event
      registerListener("eventdetails", this.caseDetails, this);
      this.bool = '';
     // alert('hiconnected');
    }
  
    disconnectedCallback() {
      // unsubscribe from eventdetails event
      unregisterAllListeners(this);
    }
  
    caseDetails(accountId) {
     // alert('caseDetails' + accountId);
      this.bool = 'true';
      this.shippingClassName();
    }*/
}