import { LightningElement,api,track } from 'lwc';
import dbu_ShippingOnChkHeader from '@salesforce/label/c.dbu_ShippingOnChkHeader';
import dbu_ReviewOrderOnChkHeader from '@salesforce/label/c.dbu_ReviewOrderOnChkHeader';
import dbu_PaymentOnChkHeader from '@salesforce/label/c.dbu_PaymentOnChkHeader';
import dbu_OrderReceiptOnChkHeader from '@salesforce/label/c.dbu_OrderReceiptOnChkHeader';
import dbu_ShippingOnChkHeaderStep from '@salesforce/label/c.dbu_ShippingOnChkHeaderStep';
import dbu_activeOnReturn from '@salesforce/label/c.dbu_activeOnReturn';
import dbu_ReviewOnChkStep from '@salesforce/label/c.dbu_ReviewOnChkStep';
import dbu_completedOnReturn from '@salesforce/label/c.dbu_completedOnReturn';
import dbu_PaymentSuccessOnHeader from '@salesforce/label/c.dbu_PaymentSuccessOnHeader';
import dbu_OrderStatusOnHeader from '@salesforce/label/c.dbu_OrderStatusOnHeader';

export default class Dbu_headerCheckoutSteps extends LightningElement {
    @api step;
    @track _shippingClassName;
    @track _paymentClassName;
    @track _reviewClassName;
    @track _orderClassName;
    @track shipping = dbu_ShippingOnChkHeader;
    @track reviewOrder = dbu_ReviewOrderOnChkHeader;
    @track payment = dbu_PaymentOnChkHeader;
    @track header = dbu_OrderReceiptOnChkHeader;
    @track stepShipping = dbu_ShippingOnChkHeaderStep;
    @track stepActive = dbu_activeOnReturn;
    @track stepReview = dbu_ReviewOnChkStep; 
    @track stepCompleted = dbu_completedOnReturn;
    @track stepPaymentSuccess = dbu_PaymentSuccessOnHeader;
    @track StepOrder = dbu_OrderStatusOnHeader;

    get shippingClassName()
    {
        console.log('this.step=>'+this.step);
        if(this.step == this.stepShipping)
        {
            this._shippingClassName = this.stepActive;
            this._reviewClassName = '';
            this._paymentClassName = '';
            this._orderClassName = '';
        }
        if(this.step == this.stepReview)
        {
            this._shippingClassName = this.stepCompleted;
            this._reviewClassName = this.stepActive;
            this._paymentClassName = '';
            this._orderClassName = '';
        }
        if(this.step == this.payment)
        {
            this._shippingClassName = this.stepCompleted;
            this._reviewClassName = this.stepCompleted;
            this._paymentClassName = this.stepActive;
            this._orderClassName = '';
        }
        if(this.step == this.stepPaymentSuccess)
        {
            this._shippingClassName = this.stepCompleted;
            this._reviewClassName = this.stepCompleted;
            this._paymentClassName = this.stepCompleted;
            this._orderClassName = '';
        }
        if(this.step == this.StepOrder)
        {
            this._paymentClassName = this.stepCompleted;
            this._shippingClassName = this.stepCompleted;
            this._reviewClassName = this.stepCompleted;
            this._orderClassName = this.stepCompleted;
        }

        return this._shippingClassName ;
    }
    
}