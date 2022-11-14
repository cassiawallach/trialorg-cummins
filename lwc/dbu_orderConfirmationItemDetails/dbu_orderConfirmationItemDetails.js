import { LightningElement, api,track } from 'lwc';
//import callReturnOrderAPI from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.callReturnOrderAPI';
//import callReturnOrderItemAPI from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.callReturnOrderItemAPI';


import dbu_orderConfirmation_product from '@salesforce/label/c.dbu_orderConfirmation_product';
import coreChargeAvailabilityMsg from '@salesforce/label/c.dbu_CoreCharge_Availability_Msg';
import dbu_orderConfirmation_quantity from '@salesforce/label/c.dbu_orderConfirmation_quantity';
import dbu_orderConfirmation_unitPrice from '@salesforce/label/c.dbu_orderConfirmation_unitPrice';
import dbu_orderConfirmation_subTotal from '@salesforce/label/c.dbu_orderConfirmation_subTotal';
import dbu_orderConfirmation_itemsOrdered from '@salesforce/label/c.dbu_orderConfirmation_itemsOrdered';


export default class Dbu_orderConfirmationItemDetails extends LightningElement {
    @api itemdetails;
    @api cartdetails;
    @track coreChargeAvailabilityMsg = coreChargeAvailabilityMsg;
    @track dbu_orderConfirmation_product = dbu_orderConfirmation_product;
    @track dbu_orderConfirmation_quantity = dbu_orderConfirmation_quantity;
    @track dbu_orderConfirmation_unitPrice = dbu_orderConfirmation_unitPrice;
    @track dbu_orderConfirmation_subTotal = dbu_orderConfirmation_subTotal;
    @track dbu_orderConfirmation_itemsOrdered = dbu_orderConfirmation_itemsOrdered;
   /* onOrderCancel(event){
        console.log('123onOrderCancel this.orderId=======>'+event.detail.value);
        console.log('onOrderCancel event.orderItemId=======>event.target.dataset.id',event.target.dataset.id);
        //console.log('onProductDelete cartIdCookie=============>'+this.cartId)
        callReturnOrderItemAPI({
            orderid : '',
            
            orderItemId : 'a2R19000000gpbTEAQ'
        })
        .then(result => {
            // // Clear the user enter values
            window.console.log('In onOrderCancel result ===> ' + result);
            // //this.createCookie('In onProductDelete cartId', result[0].cartId, 1);
            // pubsub.fire('fetchcartevt', result );
            // window.console.log('After fire eventresult ===> ' + result);
            // this.isQtyLoading = false;
            
        })
        .catch(error => {
            this.error = error.message;
        });
    }

    onOrderCancel1(event){
        console.log('onOrderCancel1 event.target.dataset.id=======>'+event.target.dataset.id);
        
    }*/
}