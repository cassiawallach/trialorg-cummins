import { LightningElement, api,track } from 'lwc';
import dbu_orderConfirm_orderNumber from '@salesforce/label/c.dbu_orderConfirm_orderNumber';
import dbu_orderConfirmation_orderDate from '@salesforce/label/c.dbu_orderConfirmation_orderDate';
import dbu_orderConfirmation_shippingAddress from '@salesforce/label/c.dbu_orderConfirmation_shippingAddress';
import dbu_orderConfirmation_billingAddress from '@salesforce/label/c.dbu_orderConfirmation_billingAddress';
import dbu_orderConfirmation_paymentMethod from '@salesforce/label/c.dbu_orderConfirmation_paymentMethod';
import dbu_orderConfirmation_PickUpFromStore from '@salesforce/label/c.dbu_orderConfirmation_PickUpFromStore';
import dbu_orderConfirmation_orderSummary from '@salesforce/label/c.dbu_orderConfirmation_orderSummary';
import dbu_orderConfirmation_Items from '@salesforce/label/c.dbu_orderConfirmation_Items';
import dbu_orderConfirmation_discount from '@salesforce/label/c.dbu_orderConfirmation_discount';
import dbu_orderConfirmation_subTotal from '@salesforce/label/c.dbu_orderConfirmation_subTotal';
import dbu_orderConfirmation_shippingCost from '@salesforce/label/c.dbu_orderConfirmation_shippingCost';
import dbu_orderConfirmation_Tax from '@salesforce/label/c.dbu_orderConfirmation_Tax';
import dbu_orderConfirmation_total from '@salesforce/label/c.dbu_orderConfirmation_total';
import dbu_GST_Number_Text from '@salesforce/label/c.dbu_GST_Number_Text';
import Dbu_Canada_GST_Number from '@salesforce/label/c.Dbu_Canada_GST_Number';
import Dbu_US_GST_Number from '@salesforce/label/c.Dbu_US_GST_Number';

import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada'; //custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French'; //custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';  //custom label refres to'CA'
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA'; //custom label refres to'USD'
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada'; //custom label refres to'CAD'
                         
                                  
export default class Dbu_orderInformation extends LightningElement {
    @track dbu_orderConfirm_orderNumber = dbu_orderConfirm_orderNumber;
    @track dbu_orderConfirmation_orderDate = dbu_orderConfirmation_orderDate;
    @track dbu_orderConfirmation_shippingAddress = dbu_orderConfirmation_shippingAddress;
    @track dbu_orderConfirmation_billingAddress = dbu_orderConfirmation_billingAddress;
    @track dbu_orderConfirmation_paymentMethod = dbu_orderConfirmation_paymentMethod;
    @track dbu_orderConfirmation_PickUpFromStore = dbu_orderConfirmation_PickUpFromStore;
    @track dbu_orderConfirmation_orderSummary = dbu_orderConfirmation_orderSummary;
    @track dbu_orderConfirmation_Items = dbu_orderConfirmation_Items;
    @track dbu_orderConfirmation_discount = dbu_orderConfirmation_discount;
    @track dbu_orderConfirmation_subTotal = dbu_orderConfirmation_subTotal;
    @track dbu_orderConfirmation_shippingCost = dbu_orderConfirmation_shippingCost;
    @track dbu_orderConfirmation_Tax = dbu_orderConfirmation_Tax;
    @track dbu_orderConfirmation_total = dbu_orderConfirmation_total;
    @track dbu_GST_Number_Text = dbu_GST_Number_Text;
    @track Dbu_Canada_GST_Number = Dbu_Canada_GST_Number;
    @track Dbu_US_GST_Number = Dbu_US_GST_Number;

    @api orderdetails ;
    @api ordersummary;
    @api pickup;
    @api shipping;

    @track currentOrderId;
    @track gstNumberToDisplay;
    @track gstAvailable = false;
    @track storeLanguage;
    @track storeCountry;
    @track countryCurrencyCode;
    connectedCallback(){

        this.storeLanguage = window.sessionStorage.getItem('setCountryCode');
        if(this.storeLanguage == storeUSA || 
            this.storeLanguage == undefined ||
            this.storeLanguage == null || this.storeLanguage == ''){
            this.storeCountry = storeUSA;
            this.countryCurrencyCode = currencyCodeUSA;
            this.storeLanguage = storeUSA;   
            console.log('Dbu_US_GST_Number > ' + Dbu_US_GST_Number);  
            console.log('Dbu_US_GST_Number type > ' + typeof Dbu_US_GST_Number);  
            if(Dbu_US_GST_Number != 'null'){
                console.log('inside GST US> ' + Dbu_US_GST_Number);
                this.gstNumberToDisplay = Dbu_US_GST_Number;
                this.gstAvailable = true;
            }
        }else if(this.storeLanguage == storeCA || this.storeLanguage == storeCAF){
            this.storeCountry = storeCanada; 
            this.countryCurrencyCode = currencyCodeCanada;            
            if(Dbu_Canada_GST_Number != 'null'){
                this.gstNumberToDisplay = Dbu_Canada_GST_Number;
                this.gstAvailable = true;
            }            
        }        


        console.log('print order details novi sad > ' + JSON.stringify(this.orderdetails));   
        this.currentOrderId  = this.orderdetails[0].sfid;
        console.log('this.currentOrderId > > ' + this.currentOrderId);
    }
}