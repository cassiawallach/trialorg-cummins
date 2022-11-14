import { LightningElement,api,track,wire} from 'lwc';
import returnReason from '@salesforce/label/c.dbu_returnReason';
import coreCharge from '@salesforce/label/c.dbu_coreCharge';
import coreChargeHandlingFee from '@salesforce/label/c.dbu_coreChargeHandlingFee';
import product from '@salesforce/label/c.dbu_product';
import quantity from '@salesforce/label/c.dbu_quantity';
import unitPrice from '@salesforce/label/c.dbu_unitPrice';
import discount from '@salesforce/label/c.dbu_discount';
import estTax from '@salesforce/label/c.dbu_estTax';
import refundAmount from '@salesforce/label/c.dbu_refundAmount';
import returnDate from '@salesforce/label/c.dbu_returnDate';

import dbu_ReturnOrderDetails from '@salesforce/label/c.dbu_ReturnOrderDetails';
import dbu_ReturnOrderSummary from '@salesforce/label/c.dbu_ReturnOrderSummary';
import dbu_ProductCost from '@salesforce/label/c.dbu_ProductCost';
import dbu_HandlingFees from '@salesforce/label/c.dbu_HandlingFees';
import dbu_orderConfirm_orderNumber from '@salesforce/label/c.dbu_orderConfirm_orderNumber';
import dbu_myAccount_orderDate from '@salesforce/label/c.dbu_myAccount_orderDate';
import dbu_orderConfirmation_shippingAddress from '@salesforce/label/c.dbu_orderConfirmation_shippingAddress';
import dbu_reviewPage_billingAddress from '@salesforce/label/c.dbu_reviewPage_billingAddress';
import dbu_orderConfirmation_paymentMethod from '@salesforce/label/c.dbu_orderConfirmation_paymentMethod';
import dbu_reviewPage_subTotal from '@salesforce/label/c.dbu_reviewPage_subTotal';
import dbu_GST_Number_Text from '@salesforce/label/c.dbu_GST_Number_Text';
import dbu_orderConfirmation_total from '@salesforce/label/c.dbu_orderConfirmation_total';

import viewReturnInvoiceData from '@salesforce/apex/dbu_ViewReturnInvoiceDetails.viewReturnInvoiceData';

export default class Dbu_invoiceItemRetunDetails extends LightningElement {
   
    @api orderinfo;
    @api gstavailable;
    @api gstnumbertodisplay;
    @track wrapperData;

    label = {
        dbu_ReturnOrderDetails,
        dbu_ReturnOrderSummary,
        dbu_ProductCost,
        dbu_HandlingFees,
        dbu_orderConfirm_orderNumber,
        dbu_myAccount_orderDate,
        dbu_orderConfirmation_shippingAddress,
        dbu_reviewPage_billingAddress,
        dbu_orderConfirmation_paymentMethod,
        dbu_reviewPage_subTotal,
        dbu_GST_Number_Text,
        dbu_orderConfirmation_total,
        returnReason,
        coreCharge,
        coreChargeHandlingFee,
        product,
        quantity,
        unitPrice,
        discount,
        estTax,
        refundAmount,
        returnDate  
    }
    
    @wire(viewReturnInvoiceData,{urlParam: window.location.href})
    wireInvoice({ error, data }) {
         this.wrapperData = data;
        
    }
  
}