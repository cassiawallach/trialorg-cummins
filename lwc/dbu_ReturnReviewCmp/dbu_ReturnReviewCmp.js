import {
    LightningElement,
    wire,
    track
} from 'lwc';
import {
    NavigationMixin
} from 'lightning/navigation';
import returnOrderItemDetails from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.returnOrderItemDetails';
import callReturnOrderAPI from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.callReturnOrderAPI';
import getShipTo from '@salesforce/apex/dbu_GeolocationController.getShipTo';
import communityName from '@salesforce/label/c.dbu_communityName';
//---Importing service component for CurrencyCode prefix--
import {perfixCurrencyISOCode,validateCookiesData} from 'c/serviceComponent';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
//-------------Importing Custom Labels----------------
import dbu_CoreCharge_Availability_Msg from "@salesforce/label/c.dbu_CoreCharge_Availability_Msg";
import dbu_Return_PageHeader from "@salesforce/label/c.dbu_Return_PageHeader";
import dbu_Return_PageSubHeader from "@salesforce/label/c.dbu_Return_PageSubHeader";
import dbu_Return_Product from "@salesforce/label/c.dbu_Return_Product";
import dbu_Return_Quantity from "@salesforce/label/c.dbu_Return_Quantity";
import dbu_Return_Reason_for_Return from "@salesforce/label/c.dbu_Return_Reason_for_Return";
import dbu_Return_Price from "@salesforce/label/c.dbu_Return_Price";
import dbu_Return_HandlingFee10 from "@salesforce/label/c.dbu_Return_HandlingFee10";
import dbu_Return_ProductNotReturnable from "@salesforce/label/c.dbu_Return_ProductNotReturnable";
import dbu_Return_HandlingFee15 from "@salesforce/label/c.dbu_Return_HandlingFee15";
import dbu_Return_NoRemainingQty from "@salesforce/label/c.dbu_Return_NoRemainingQty";
import dbu_Return_ContactCS from "@salesforce/label/c.dbu_Return_ContactCS";
import dbu_Return_Core_Refund from "@salesforce/label/c.dbu_Return_Core_Refund";
import dbu_Return_EstTax from "@salesforce/label/c.dbu_Return_EstTax";
import dbu_Return_EstAmt from "@salesforce/label/c.dbu_Return_EstAmt";
import dbu_Return_AddInfo from "@salesforce/label/c.dbu_Return_AddInfo";
import dbu_Return_BtnLabel_Proceed from "@salesforce/label/c.dbu_Return_BtnLabel_Proceed";
import dbu_Return_BtnLabel_ProceedToReturn from "@salesforce/label/c.dbu_Return_BtnLabel_ProceedToReturn";
import dbu_Return_Part_no_longer_wanted from "@salesforce/label/c.dbu_Return_Part_no_longer_wanted";
import dbu_Return_Ordered_the_wrong_part from "@salesforce/label/c.dbu_Return_Ordered_the_wrong_part";
import dbu_Return_Damaged_in_shipping from "@salesforce/label/c.dbu_Return_Damaged_in_shipping";
import dbu_Return_Incorrect_part_was_received from "@salesforce/label/c.dbu_Return_Incorrect_part_was_received";
import dbu_Return_Toast_ReasonForReturn from "@salesforce/label/c.dbu_Return_Toast_ReasonForReturn";
import dbu_Return_ReturnReview_PageHeader from "@salesforce/label/c.dbu_Return_ReturnReview_PageHeader";
import dbu_Return_Drop_off_at_Store from "@salesforce/label/c.dbu_Return_Drop_off_at_Store";
import dbu_Return_Items_to_be_returned from "@salesforce/label/c.dbu_Return_Items_to_be_returned";
import dbu_Return_BtnLabel_InitiateReturn from "@salesforce/label/c.dbu_Return_BtnLabel_InitiateReturn";
import dbu_Return_BtnLabel_Back from "@salesforce/label/c.dbu_Return_BtnLabel_Back";
import dbu_DefaultProductImage from "@salesforce/label/c.dbu_DefaultProductImage";
import dbu_Return_Damaged_in_shipping_FR from "@salesforce/label/c.dbu_DamagedInShipping_Pdf_FR";
import dbu_Return_Incorrect_part_was_received_FR from "@salesforce/label/c.dbu_IncorrectPartWasReceived_Pdf_FR";
import dbu_return_order_error from "@salesforce/label/c.dbu_return_order_error";
import isGuest from '@salesforce/user/isGuest';
import getProductWeight from '@salesforce/apex/dbu_CallCCOrderApi.getProductWeight';//CECI-657

export default class Dbu_ReturnReviewCmp extends NavigationMixin(LightningElement) {

    @track lstOrder = [];
    @track orderItemList;
    @track error; //
    @track wrapperData;
    @track mapMarkers = [];
    @track markersTitle = '';
    @track zoomLevel = 4;
    @track orderId;
    @track showMap = false;
    @track additionalInformation = '';
    @track isAddInfo = false;
    @track dropStoreName;
    @track dropCity;
    @track dropStreet;
    @track dropState;
    @track dropPostalCode;
    @track dropCountry;
    @track listOrderItemIds = [];
    @track estimatedRefundAmount = 0.00;
    @track dropLocation;
    @track ScreenLoaded = false;
    @track orderDaysCompleted;
    @track sendLocBackToChangeLocTile;
    @track refundedTax;
    @track currencyCode;
    @track isGuestU = isGuest;


    //--------Custom Labels-----
    label = {
        dbu_CoreCharge_Availability_Msg,
        dbu_Return_PageHeader,
        dbu_Return_PageSubHeader,
        dbu_Return_Product,
        dbu_Return_Quantity,
        dbu_Return_Reason_for_Return,
        dbu_Return_Price,
        dbu_Return_HandlingFee10,
        dbu_Return_ProductNotReturnable,
        dbu_Return_HandlingFee15,
        dbu_Return_NoRemainingQty,
        dbu_Return_ContactCS,
        dbu_Return_Core_Refund,
        dbu_Return_EstTax,
        dbu_Return_EstAmt,
        dbu_Return_AddInfo,
        dbu_Return_BtnLabel_Proceed,
        dbu_Return_BtnLabel_ProceedToReturn,
        dbu_Return_Part_no_longer_wanted,
        dbu_Return_Ordered_the_wrong_part,
        dbu_Return_Damaged_in_shipping,
        dbu_Return_Incorrect_part_was_received,
        dbu_Return_Toast_ReasonForReturn,
        dbu_Return_ReturnReview_PageHeader,
        dbu_Return_Drop_off_at_Store,
        dbu_Return_Items_to_be_returned,
        dbu_Return_BtnLabel_InitiateReturn,
        dbu_Return_BtnLabel_Back,
        dbu_DefaultProductImage,
        dbu_Return_Damaged_in_shipping_FR,
        dbu_Return_Incorrect_part_was_received_FR,
        dbu_return_order_error

    };
    
    //--------------------------
    connectedCallback() {
        //-- Restricting browser back button---
        window.history.forward();
        this.ScreenLoaded = true;
        let urlParameters = new URL(window.location.href).searchParams;
        this.orderId = urlParameters.get('orderid');
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
       // this.sendLocBackToChangeLocTile = url.searchParams.get("store");
       this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');

       // Security changes, Added by Ranadip
       if(this.isGuestU && validateCookiesData(this.orderId)){
        return;
    }//end here

        //---Calling to get shipTo checkbox value
        getShipTo({
                orderId: this.orderId
            })
            .then(result => {
                if (result === true) {
                    this.showMap = false;
                    this.getReturnOrderItems();
                } else {
                    this.showMap = true;
                    this.getReturnOrderItems();
                }
            })
            .catch(error => {
                if (error) {
                    this.errorMsg = error.body.message;
                }
            })

    }
    noShipmentWeight = false;
    @track oItemtrn = [];//CECI-657
    getReturnOrderItems() {
        returnOrderItemDetails({
                urlParam: window.location.href
            })
            .then(data => {
                if (data) {
                    let hasCoreCharge;
                    let returnTax = 0.00;
                     let perItemTax;
                    let totalVertaxTax = 0.00;
                    var itemListLocal = [];
                    this.lstOrder = data;
                    var productMap = new Map();
                    var originalOrderedQuantityMap = new Map();
                    var originalOrderedQuantity;
                    var finalAmount = 0.00;
                    var totalAmountWithTax;
                    var numberOfDays = this.lstOrder[0].daysSinceOrderDate;
                    this.orderDaysCompleted = numberOfDays;

                     //---Added for country currency change---
                     this.currencyCode = this.lstOrder[0].currencyISOCode; 
                    this.refundedTax = perfixCurrencyISOCode(this.currencyCode,0.00);
                    //-------- Adding products in Map
                    for (let i = 0; i < this.lstOrder[0].productlist.length; i++) {
                        productMap.set(this.lstOrder[0].productlist[i].sfid, this.lstOrder[0].productlist[i]);
                    }
                    //------- Iterating on Order line item list


                    for (let i = 0; i < this.lstOrder[0].EOrderItemsS.length; i++) 
                    {                        
                        if (this.lstOrder[0].EOrderItemsS[i].reasonForReturn == null || this.lstOrder[0].EOrderItemsS[i].reasonForReturn == '') 
                        {
                            originalOrderedQuantityMap.set(this.lstOrder[0].EOrderItemsS[i].prodId, this.lstOrder[0].EOrderItemsS[i].quantity)
                        }
                    }

                    for (let i = 0; i < this.lstOrder[0].EOrderItemsS.length; i++) 
                    {

                        let orderItemObj = {};
                        if (this.lstOrder[0].EOrderItemsS[i].orderItemStatus === undefined) 
                        { 
                            originalOrderedQuantity = originalOrderedQuantityMap.get(this.lstOrder[0].EOrderItemsS[i].prodId);
                            //-----Checking dropOff location
                            this.dropLocation = this.lstOrder[0].EOrderItemsS[i].dropOffLocation;
                            console.log('this.dropLocation====='+this.dropLocation);
                            if(this.dropLocation != undefined && this.dropLocation != null && this.dropLocation != ''){
                                let splitAddress = this.dropLocation.split(',');
                                this.dropStoreName = splitAddress[0];
                                this.dropStreet = splitAddress[1];
                                this.dropCity = splitAddress[2];
                                this.dropState = splitAddress[3];
                                this.dropPostalCode = splitAddress[4];
                                this.dropCountry = splitAddress[5];
                                }
        
                            orderItemObj['sfid'] = this.lstOrder[0].EOrderItemsS[i].sfid;
                            this.oItemtrn.push(this.lstOrder[0].EOrderItemsS[i].prodId);//CECI-657
                            orderItemObj['quantity'] = this.lstOrder[0].EOrderItemsS[i].quantity;
                            orderItemObj['reasonForReturn'] = this.lstOrder[0].EOrderItemsS[i].reasonForReturn;
                            
                            let amountInFormat = this.lstOrder[0].EOrderItemsS[i].subAmount / this.lstOrder[0].EOrderItemsS[i].quantity;
                            orderItemObj['price'] = perfixCurrencyISOCode(this.currencyCode,amountInFormat);
                            if (productMap.has(this.lstOrder[0].EOrderItemsS[i].prodId)) {
                                orderItemObj['sfdcName'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).sfdcName;
                                if(productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).EProductMediasS[0]){
                                    orderItemObj['URI'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).EProductMediasS[0].URI;
                                }else{
                                    orderItemObj['URI'] = dbu_DefaultProductImage;
                                }
                                orderItemObj['id'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).sfid;
                                //-----Display 10% handing fee msg for core charge product
                                 hasCoreCharge = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).hasCoreCharge;
                                let hasCoreChild = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).dbuHasCoreChild;
                                if(hasCoreCharge === true && hasCoreChild === true && this.orderDaysCompleted >= 45 && this.orderDaysCompleted <= 90 ){
                                    orderItemObj['isCoreHandlingFee'] = true;
                                    orderItemObj['coreReturn'] = true;
                                }else if(hasCoreCharge === true && hasCoreChild === true && this.orderDaysCompleted < 45 ){
                                    orderItemObj['coreReturn'] = true;
                                }
                                
                            }

                            console.log('orderItemObj array :::: ', orderItemObj);
                            //------Display 15% handling fee message and Calculate total estimated refund amount including vertax tax

                            if(hasCoreCharge === true && this.orderDaysCompleted > 45 && this.orderDaysCompleted <= 90){
                                if (this.lstOrder[0].EOrderItemsS[i].vertexTax != undefined && this.lstOrder[0].EOrderItemsS[i].vertexTax != null) {
                                   
                                    //perItemTax = this.lstOrder[0].EOrderItemsS[i].vertexTax / this.lstOrder[0].EOrderItemsS[i].originalQuantity;
                                    perItemTax = this.lstOrder[0].EOrderItemsS[i].vertexTax / originalOrderedQuantity;
                                    totalVertaxTax = this.lstOrder[0].EOrderItemsS[i].quantity * perItemTax;
                                    totalAmountWithTax = this.lstOrder[0].EOrderItemsS[i].subAmount; // Promotion changes
                                    let handlingFee = (totalAmountWithTax / 100) * 10;
                                    finalAmount = finalAmount + (totalAmountWithTax - handlingFee) + totalVertaxTax;
                                    returnTax = returnTax + totalVertaxTax;
                                }else{
                                    totalAmountWithTax = this.lstOrder[0].EOrderItemsS[i].subAmount; // Promotion Changes
                                    let handlingFee = (totalAmountWithTax / 100) * 10;
                                    finalAmount = finalAmount + (totalAmountWithTax - handlingFee);
                                }
                            }else{
                            if (this.lstOrder[0].EOrderItemsS[i].reasonForReturn == dbu_Return_Part_no_longer_wanted || this.lstOrder[0].EOrderItemsS[i].reasonForReturn == dbu_Return_Ordered_the_wrong_part) {
                                orderItemObj['isMsg'] = true;
                                if(this.lstOrder[0].EOrderItemsS[i].vertexTax != undefined && this.lstOrder[0].EOrderItemsS[i].vertexTax != null){
                                     //perItemTax = this.lstOrder[0].EOrderItemsS[i].vertexTax / this.lstOrder[0].EOrderItemsS[i].originalQuantity;
                                     perItemTax = this.lstOrder[0].EOrderItemsS[i].vertexTax / originalOrderedQuantity;
                                     totalVertaxTax = this.lstOrder[0].EOrderItemsS[i].quantity * perItemTax;
                                    returnTax = returnTax + totalVertaxTax;
                                    totalAmountWithTax =  this.lstOrder[0].EOrderItemsS[i].subAmount; // Promotion Changes

                                } else {
                                    totalAmountWithTax =  this.lstOrder[0].EOrderItemsS[i].subAmount; // Promotion Changes
                                }
                
                                let handlingFee = (totalAmountWithTax / 100) * 15;
                                finalAmount = finalAmount + (totalAmountWithTax - handlingFee) + totalVertaxTax;

                                let handlingFeeOnOrgPrice = ((this.lstOrder[0].EOrderItemsS[i].subAmount / this.lstOrder[0].EOrderItemsS[i].quantity ) * 15) / 100;
                                let priceAfterHandingFee = (this.lstOrder[0].EOrderItemsS[i].subAmount / this.lstOrder[0].EOrderItemsS[i].quantity ) - handlingFeeOnOrgPrice;
                                orderItemObj['amtAfterHandlingFee'] = perfixCurrencyISOCode(this.currencyCode,priceAfterHandingFee);
                                orderItemObj['isStrikeThrough'] = true;
                                orderItemObj['removeStrikeThrough'] = false;
                
                            } else {
                                orderItemObj['isMsg'] = false;
                                orderItemObj['isStrikeThrough'] = false;
                                orderItemObj['removeStrikeThrough'] = true;
                                if (this.lstOrder[0].EOrderItemsS[i].vertexTax != undefined && this.lstOrder[0].EOrderItemsS[i].vertexTax != null) {
                                    console.log('TAX Amt=='+this.lstOrder[0].EOrderItemsS[i].vertexTax);
                                    console.log('org qty=='+this.lstOrder[0].EOrderItemsS[i].originalQuantity);
                                    //perItemTax = this.lstOrder[0].EOrderItemsS[i].vertexTax / this.lstOrder[0].EOrderItemsS[i].originalQuantity;
                                    perItemTax = this.lstOrder[0].EOrderItemsS[i].vertexTax / originalOrderedQuantity;
                                    totalVertaxTax = this.lstOrder[0].EOrderItemsS[i].quantity * perItemTax;
                                    console.log('totalVertaxTax======'+totalVertaxTax);
                                    returnTax = returnTax + totalVertaxTax;
                                    console.log('returnTax====='+returnTax);
                                     totalAmountWithTax = this.lstOrder[0].EOrderItemsS[i].subAmount  + totalVertaxTax; // Promotion changes
                                } else {
                                    totalAmountWithTax = ( this.lstOrder[0].EOrderItemsS[i].subAmount); // Promotion changes
                                }
                                finalAmount = finalAmount + totalAmountWithTax;
                
                            }
                        }
                            this.refundedTax = perfixCurrencyISOCode(this.currencyCode,returnTax);
                            this.estimatedRefundAmount = perfixCurrencyISOCode(this.currencyCode,finalAmount);
                            //------Display additional information 
                            if (this.lstOrder[0].EOrderItemsS[i].additionalInfo == null || this.lstOrder[0].EOrderItemsS[i].additionalInfo == undefined) {
                                this.isAddInfo = false;
                            } else {
                                this.isAddInfo = true;
                                this.additionalInformation = this.lstOrder[0].EOrderItemsS[i].additionalInfo;
                            }

                            //------Adding records in local List
                            itemListLocal.push(orderItemObj);
                        }
                    }
                    //------Final order Item list
                    this.orderItemList = itemListLocal;

                    //------DropOff map display
                    if(this.dropLocation != undefined && this.dropLocation != null && this.dropLocation != ''){
                     this.mapMarkers = [
                        {
                            location: {
                                City: this.dropCity,
                                Country: this.dropCountry,
                              //  PostalCode: data.PostalCode,
                                State: this.dropState,
                                Street: this.dropStreet
                              
                            },
            
                            icon: 'custom:custom26',
                        }                                    
                    ];
                }
                    //CECI-657
                    if(!!this.oItemtrn){
                        getProductWeight({itemProdRtnIds:this.oItemtrn}).then(res => {
                            for (let i = 0; i < this.orderItemList.length; i++){
                                let stopRtn = (res[this.orderItemList[i]['id']] === false || res[this.orderItemList[i]['id']] == undefined) && window.sessionStorage.getItem(this.orderId + 'rtnAddress') === 'true' ? this.orderItemList[i].reasonForReturn == dbu_Return_Incorrect_part_was_received || this.orderItemList[i].reasonForReturn == dbu_Return_Incorrect_part_was_received_FR || this.orderItemList[i].reasonForReturn == dbu_Return_Damaged_in_shipping || this.orderItemList[i].reasonForReturn == dbu_Return_Damaged_in_shipping_FR : false;   
                                if(stopRtn){
                                    this.noShipmentWeight = true;
                                }
                            }                            
                        }).then(() => {this.ScreenLoaded = false;});
                    } else {
                        this.ScreenLoaded = false;
                    }
                }
            })
            .catch(error => {
                if (error) {
                    this.errorMsg = error.body.message;
                }
            })
    }


    initiateReturn() {
        this.ScreenLoaded = true;
        callReturnOrderAPI({
                orderid: this.orderId,
                orderItemId: this.listOrderItemIds
            })
            .then(result => {
                setTimeout(() => {
                let urlString = window.location.origin;
                let redirectURL = urlString + communityName + 'return-confirm?orderid=' + this.orderId + '&store=' + this.sendLocBackToChangeLocTile;
                invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Proceed to Initiate return', eventAction : 'Navigate from refund review page to refund confirm'});        
                window.localStorage.setItem('googleanalyticsreturnreview', true);
                window.location.href = redirectURL;                
                /*this[NavigationMixin.Navigate]({
                    "type": "standard__webPage",
                    "attributes": {
                        "url": redirectURL
                    }
                });*/
            }, 4000);
            })
            .catch(error => {
                if (error) {
                    this.errorMsg = error.body.message;
                }
            })


    }

    backToReturnMethodPage() {

        let urlString = window.location.origin;
        let redirectURL = urlString + communityName + 'return-method?orderid=' + this.orderId + '&store=' + this.sendLocBackToChangeLocTile;
        window.localStorage.setItem('googleanalyticsreturnreview', false);
        invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Back to refund method page', eventAction : 'Navigate from refund review page to refund method page'});        
        window.location.href = redirectURL;        
        /*this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": redirectURL
            }
        });*/

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
         
         window.localStorage.setItem('googleanalyticsreturnreview', false);
         invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Naviate to the ' + prodName + ' product page');
         window.location.href = redirectURL;

        /* this[NavigationMixin.Navigate]({
             "type": "standard__webPage",
             "attributes": {
                 "url": redirectURL
             }
         });*/
    }

}