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


export default class Dbu_orderDetailsView extends LightningElement {
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

    @api orderdetails ;
    @api ordersummary;
    @api pickup;
    @api shipping;
}