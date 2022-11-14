import { LightningElement, api,track } from 'lwc';
import callReturnOrderAPI from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.callReturnOrderAPI';
//import callReturnOrderItemAPI from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.callReturnOrderItemAPI';
import checkingGenuineProduct from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.checkingGenuineProduct';
import communityName from'@salesforce/label/c.dbu_communityName';

import dbu_orderConfirmation_product from '@salesforce/label/c.dbu_orderConfirmation_product';
import dbu_orderConfirmation_quantity from '@salesforce/label/c.dbu_orderConfirmation_quantity';
import dbu_orderConfirmation_unitPrice from '@salesforce/label/c.dbu_orderConfirmation_unitPrice';
import dbu_orderConfirmation_Status from '@salesforce/label/c.dbu_orderConfirmation_Status';
import dbu_orderConfirmation_AvailabiltyMsgCoreCharge from '@salesforce/label/c.dbu_orderConfirmation_AvailabiltyMsgCoreCharge';
import dbu_orderConfirmation_Submit from '@salesforce/label/c.dbu_orderConfirmation_Submit';
import dbu_orderConfirmation_ProductCannotReturn from '@salesforce/label/c.dbu_orderConfirmation_ProductCannotReturn';
import dbu_orderConfirmation_ReturnRequestSubmitted from '@salesforce/label/c.dbu_orderConfirmation_ReturnRequestSubmitted';
import dbu_orderConfirmation_Productsordered from '@salesforce/label/c.dbu_orderConfirmation_Productsordered';

import {
    NavigationMixin
} from 'lightning/navigation';
import clearanceIcon from '@salesforce/resourceUrl/dbu_icons';
export default class Dbu_orderItemDetails extends NavigationMixin(LightningElement) {
    @api itemdetails;
    @api cartdetails;
    @track isOpenModelForReturnParts = false; 
    @track isOpenModelForReturnPartsSuccess = false; 
    @track orderItemId;
    @track returnReason;
    @track shippingMethodVal;
    //@track itemDetailsData = [];
    @track orderStatusCheck;
    @track sendLocBackToChangeLocTile;

    @track dbu_orderConfirmation_product = dbu_orderConfirmation_product;
    @track dbu_orderConfirmation_quantity = dbu_orderConfirmation_quantity;
    @track dbu_orderConfirmation_unitPrice = dbu_orderConfirmation_unitPrice;
    @track dbu_orderConfirmation_Status = dbu_orderConfirmation_Status;
    @track dbu_orderConfirmation_AvailabiltyMsgCoreCharge = dbu_orderConfirmation_AvailabiltyMsgCoreCharge;
    @track dbu_orderConfirmation_Submit = dbu_orderConfirmation_Submit;
    @track dbu_orderConfirmation_ProductCannotReturn = dbu_orderConfirmation_ProductCannotReturn;
    @track dbu_orderConfirmation_ReturnRequestSubmitted = dbu_orderConfirmation_ReturnRequestSubmitted;
    @track dbu_orderConfirmation_Productsordered = dbu_orderConfirmation_Productsordered;
    @track clearanceImg = clearanceIcon+'/dbu_icons/dbu_saletag.svg';
    connectedCallback(){
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        console.log('StoreName--==='+url.searchParams.get("store"));
       // this.sendLocBackToChangeLocTile = url.searchParams.get("store");
       this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
      //  console.log(' itemdetails ll ', this.itemdetails[0].orderStatus);
        //this.orderStatusCheck = this.itemdetails[0].orderStatus
        
       // this.checkorderStatus();
        console.log('this.itemdetails ' , JSON.parse(JSON.stringify(this.itemdetails)));
   }  
   
  /* @track isOrderStatusSuccess;
    checkorderStatus(){
        
        if(this.orderStatusCheck == 'Delivered'){
            this.isOrderStatusSuccess = true;
        }else if(this.orderStatusCheck == 'Picked up'){
            this.isOrderStatusSuccess = true;
        }else{
            this.isOrderStatusSuccess = false;
        }
        console.log('this.orderStatusCheck ' , this.orderStatusCheck);
        console.log('this.isOrderStatusSuccess ', this.isOrderStatusSuccess);
    }*/
    
    onOrderCancel(event){
        //console.log('123onOrderCancel this.orderId=======>'+event.detail.value);
        console.log('onOrderCancel this.orderItemId=======>',this.orderItemId);

        //console.log('onProductDelete cartIdCookie=============>'+this.cartId)
        callReturnOrderItemAPI({
            orderid : '',
            
            orderItemId : this.orderItemId
        })
        .then(result => {
            // // Clear the user enter values
            window.console.log('In onOrderCancel result ===> ' + result);
            // //this.createCookie('In onProductDelete cartId', result[0].cartId, 1);
            // pubsub.fire('fetchcartevt', result );
            // window.console.log('After fire eventresult ===> ' + result);
            // this.isQtyLoading = false;
            this.closeModelForReturnParts() ;
            this.openModelForReturnPartsSuccess();
        })
        .catch(error => {
            this.error = error.message;
        });
    }

    onOrderCancel1(event){
        console.log('onOrderCancel1 event.target.dataset.id=======>'+event.target.dataset.id);
        
    }

    get orderReaturnReason() {
        return [{
                label: 'Part no longer wanted',
                value: 'Part no longer wanted'
            } ,
            {
                label: 'Ordered the wrong part',
                value: 'Ordered the wrong part'
            },
            {
                label: 'Damaged in shipping',
                value: 'Damaged in shipping'
            }, 
            {
                label: 'Incorrect part was received',
                value: 'Incorrect part was received'
            }  
        ];
    }

    get shippingMethod() {     
        return [{
                label: 'Ship To',
                value: 'SHIP'
            } ,
            {
                label: 'Drop off',
                value: 'DROP'
            } 
        ];
    }

    @track flag = true;
    openModelForReturnParts(event) {
        // to open modal set isModalOpen tarck value as true
        this.orderItemId = event.target.dataset.id;
        //console.log(' itemdetails ll ', this.itemdetails[0].orderItemStatus);
        checkingGenuineProduct({
            orderid : null,
            orderItemId : this.orderItemId
        })
        .then(result => {
            window.console.log('checkingGenuineProduct ' + result);
            if(result == 'Not a Genuine Product'){
               this.flag = false;
            }else if(result == 'Genuine Product'){
                this.isOpenModelForReturnParts = true;
            }
        })
        .catch(error => {
            this.error = error.message;
        });
 
       // this.isOpenModelForReturnParts = true;
       // this.orderItemId = event.target.dataset.id;
        console.log('onOrderCancel event.orderItemId=======>event.target.dataset.id',event.target.dataset.id);
        console.log('this.isOpenModelForReturnParts', this.isOpenModelForReturnParts);
    }

  closeModelForReturnParts() {
      // to close modal set isModalOpen tarck value as false
      this.isOpenModelForReturnParts = false;
      this.flag = true;
      console.log('this.isOpenModelForReturnParts', this.isOpenModelForReturnParts);
  }
    onShippingMethodSelect(event) {
        this.shippingMethodVal = event.detail.value;
        console.log('shippingMethod event.orderItemId=======>event.target.dataset.id',event.detail.value);
        console.log('shippingMethod =======>event.target.dataset.id',event.detail.value);
        console.log('this.shippingMethod', this.shippingMethodVal);
    }

    onReturnPartsReasonChange(event) {
        console.log('Hello123');
        this.returnReason = event.target.value;
        console.log('this.returnReason', this.returnReason);
    }

    openModelForReturnPartsSuccess(event) {
        // to open modal set isModalOpen tarck value as true
        this.isOpenModelForReturnPartsSuccess = true;
        //this.orderItemId = event.target.dataset.id;
        //console.log('isOpenModelForReturnPartsSuccess event.orderItemId=======>event.target.dataset.id',event.target.dataset.id);
        console.log('this.isOpenModelForReturnPartsSuccess', this.isOpenModelForReturnPartsSuccess);
    }

  closeModelForReturnPartsSuccess() {
      // to close modal set isModalOpen tarck value as false
      this.isOpenModelForReturnPartsSuccess = false;
      console.log('this.isOpenModelForReturnPartsSuccess', this.isOpenModelForReturnPartsSuccess);
  }

  goToProductDetailPage(event){
    let prodName = event.target.getAttribute('data-name');
    let prodId =   event.target.getAttribute('data-id');
    //Replacing comma and whitespace from hyphen in Product Name
    if(prodName.includes(",")){
        prodName =  prodName.replace(/,/g, '-').toLowerCase();
    }
    if(prodName.includes(" ")){
        prodName =  prodName.replace(/\s+/g, '-').toLowerCase();
    }
   
    if(prodName.includes('/')){
        prodName = prodName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
      }

    
    console.log('ProdName==='+prodName);
     let urlString = window.location.origin;
			 let redirectURL =  urlString + communityName +'product/'+prodId +'/'+ prodName+'/?store='+this.sendLocBackToChangeLocTile;
    // let redirectURL = urlString + communityName + 'product?name=' + prodName + '&pId=' + prodId + '&store=' + this.sendLocBackToChangeLocTile;
     console.log('redirectURL===='+redirectURL);
     this[NavigationMixin.Navigate]({
         "type": "standard__webPage",
         "attributes": {
             "url": redirectURL
         }
     });
}

}