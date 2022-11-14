import { LightningElement,wire,track} from 'lwc';
import returnOrderItemDetails from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.returnOrderItemDetails';
import getUserInfo from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.getUserInfo';
import communityName from'@salesforce/label/c.dbu_communityName';
import {
    NavigationMixin
} from 'lightning/navigation';
//---Importing service component for CurrencyCode prefix--
import {perfixCurrencyISOCode,validateCookiesData} from 'c/serviceComponent';

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
import dbu_Return_Items_to_be_returned from "@salesforce/label/c.dbu_Return_Items_to_be_returned";
import dbu_Return_ReturnInitiated_PageHeader from "@salesforce/label/c.dbu_Return_ReturnInitiated_PageHeader";
import dbu_Return_ReturnCreatedHeader  from "@salesforce/label/c.dbu_Return_ReturnCreatedHeader";
import dbu_Return_ReturnCreatedMsg from "@salesforce/label/c.dbu_Return_ReturnCreatedMsg";
import dbu_Return_Return_Status from "@salesforce/label/c.dbu_Return_Return_Status";
import dbu_Return_BtnLabel_Go_To_My_Orders from "@salesforce/label/c.dbu_Return_BtnLabel_Go_To_My_Orders";
import dbu_DefaultProductImage from "@salesforce/label/c.dbu_DefaultProductImage";
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import isGuest from '@salesforce/user/isGuest';
export default class Dbu_ReturnInitiatedCmp extends NavigationMixin(LightningElement) {

    @track lstOrder = [];
    @track orderItemList;
    @track error;   //
    @track wrapperData;
    @track orderId;
    @track additionalInformation = '';
    @track isAddInfo = false;
    @track isLoading = true;
    @track estimatedRefundAmount = 0.00;
    @track ScreenLoaded = false;
    @track isGuestUser = false;
    @track sendLocBackToChangeLocTile;
    @track refundedTax;
    @track currencyCode;
    @track isGuestU = isGuest;

    //----- Custom Labels----
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
        dbu_Return_ReturnInitiated_PageHeader,
        dbu_Return_ReturnCreatedHeader,
        dbu_Return_ReturnCreatedMsg,
        dbu_Return_Return_Status,
        dbu_Return_Items_to_be_returned,
        dbu_Return_BtnLabel_Go_To_My_Orders,
        dbu_DefaultProductImage
    };
    //-----------------------


    connectedCallback() {
       
       window.location.hash="no-back-button";
        this.ScreenLoaded = true;
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
      //  this.sendLocBackToChangeLocTile = url.searchParams.get("store");
      this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
      // Security changes, Added by Ranadip	
      let urlParameters = new URL(window.location.href).searchParams;	
      let orderId = urlParameters.get('orderid');	
          
     if(this.isGuestU && validateCookiesData(orderId)){	
          return;	
      }//end here
        this.getUserDetail();
        this.getReturnOrderItems();
    }
   
    getUserDetail(){
        getUserInfo({
        })
        .then(data => {
            if(data === 'Guest'){
                this.isGuestUser = true;
            }
        })
        .catch(error => {
            if (error) {
                this.errorMsg = error.body.message;
            }
        })
    }

    getReturnOrderItems() {
        returnOrderItemDetails({
                urlParam: window.location.href
            })
            .then(data => {
        if (data) {
            console.log('data' + JSON.stringify(data));
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
            for (let i = 0; i < this.lstOrder[0].EOrderItemsS.length; i++) 
            {
                if (this.lstOrder[0].EOrderItemsS[i].reasonForReturn == null || this.lstOrder[0].EOrderItemsS[i].reasonForReturn == '') 
                {
                    originalOrderedQuantityMap.set(this.lstOrder[0].EOrderItemsS[i].prodId, this.lstOrder[0].EOrderItemsS[i].quantity)
                }
            }




            //------- Iterating on Order line item list
            for (let i = 0; i < this.lstOrder[0].EOrderItemsS.length; i++) {
                let orderItemObj = {};
                if (this.lstOrder[0].EOrderItemsS[i].orderItemStatus === 'Return Initiated' && this.lstOrder[0].EOrderItemsS[i].selectedReturnItems === true) 
                {
                    originalOrderedQuantity = originalOrderedQuantityMap.get(this.lstOrder[0].EOrderItemsS[i].prodId);
                    orderItemObj['sfid'] = this.lstOrder[0].EOrderItemsS[i].sfid;
                    orderItemObj['quantity'] = this.lstOrder[0].EOrderItemsS[i].quantity;
                    orderItemObj['reasonForReturn'] = this.lstOrder[0].EOrderItemsS[i].reasonForReturn;
                    let amountInFormat = this.lstOrder[0].EOrderItemsS[i].subAmount / this.lstOrder[0].EOrderItemsS[i].quantity;
                    orderItemObj['price'] = perfixCurrencyISOCode(this.currencyCode,amountInFormat);
                    orderItemObj['orderItemStatus'] = this.lstOrder[0].EOrderItemsS[i].orderItemStatus;
                    if (productMap.has(this.lstOrder[0].EOrderItemsS[i].prodId)) {
                        orderItemObj['sfdcName'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).sfdcName;
                        if(productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).EProductMediasS[0] !== undefined){
                            orderItemObj['URI'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).EProductMediasS[0].URI;
                        }else{
                            orderItemObj['URI'] = dbu_DefaultProductImage;
                        }
                        
                        orderItemObj['id'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).sfid;
                        orderItemObj['sku'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).SKU;
                         hasCoreCharge = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).hasCoreCharge;
                        let hasCoreChild = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).dbuHasCoreChild;
                        if(hasCoreCharge === true && hasCoreChild === true && this.orderDaysCompleted >= 45 && this.orderDaysCompleted <= 90 ){
                            orderItemObj['isCoreHandlingFee'] = true;
                            orderItemObj['coreReturn'] = true;
                        }else if(hasCoreCharge === true && hasCoreChild === true && this.orderDaysCompleted < 45 ){
                            orderItemObj['coreReturn'] = true;
                        }
                    }
                    //------Display 15% handling fee message and Calculate total estimated refund amount including vertax tax
                     if(hasCoreCharge === true && this.orderDaysCompleted > 45 && this.orderDaysCompleted <= 90){
                        if (this.lstOrder[0].EOrderItemsS[i].vertexTax != undefined && this.lstOrder[0].EOrderItemsS[i].vertexTax != null) {
                            //perItemTax = this.lstOrder[0].EOrderItemsS[i].vertexTax / this.lstOrder[0].EOrderItemsS[i].originalQuantity;
                            perItemTax = this.lstOrder[0].EOrderItemsS[i].vertexTax / originalOrderedQuantity;
                            totalVertaxTax = this.lstOrder[0].EOrderItemsS[i].quantity * perItemTax;
                            totalAmountWithTax = this.lstOrder[0].EOrderItemsS[i].subAmount ;
                            let handlingFee = (totalAmountWithTax / 100) * 10;
                            finalAmount = finalAmount + (totalAmountWithTax - handlingFee) + totalVertaxTax;
                            returnTax = returnTax + totalVertaxTax;
                        }else{
                            totalAmountWithTax = this.lstOrder[0].EOrderItemsS[i].subAmount;
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
                            totalAmountWithTax = this.lstOrder[0].EOrderItemsS[i].subAmount ;
        
                        } else {
                            totalAmountWithTax = this.lstOrder[0].EOrderItemsS[i].subAmount;
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
                            //perItemTax = this.lstOrder[0].EOrderItemsS[i].vertexTax / this.lstOrder[0].EOrderItemsS[i].originalQuantity;
                            perItemTax = this.lstOrder[0].EOrderItemsS[i].vertexTax / originalOrderedQuantity;
                            totalVertaxTax = this.lstOrder[0].EOrderItemsS[i].quantity * perItemTax;
                            returnTax = returnTax + totalVertaxTax;
                             totalAmountWithTax = this.lstOrder[0].EOrderItemsS[i].subAmount   + totalVertaxTax;
                        } else {
                            totalAmountWithTax = this.lstOrder[0].EOrderItemsS[i].subAmount;
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
                console.log('this.orderItemList > ' + JSON.stringify(this.orderItemList));
                 this.ScreenLoaded = false;
                 if(window.localStorage.getItem('googleanalyticsreturnreview') == 'true'){
                    window.localStorage.setItem('googleanalyticsreturnreview', false);
                    invokeGoogleAnalyticsService('REFUND ORDER DETAILS', {orderdata : data, refundamt : this.estimatedRefundAmount, orderitemdata : this.orderItemList});          
                  }                 
           
        } else if (error) {
            console.log('fetchProductById Error>>>'+ JSON.stringify(error));
        }
    })
    .catch(error => {
        if (error) {
            this.errorMsg = error.body.message;
        }
    })
    }


    handlegotomyorders(){
        if (this.isGuestUser === true) {
          invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname : 'Naviate to the track order page from refund confirmation page'});      
        }else{
          invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname : 'Naviate to the my account page from refund confirmation page'});
        }
      }

    get goToMyOrders(){
        let urlString = window.location.origin;
        if(this.isGuestUser === true){
            return urlString+communityName+'track-order' + '?store=' + this.sendLocBackToChangeLocTile; // Need to check COmmunity page name in Custom Label
        }else{
            return urlString+communityName+'my-account' + '?orders=true&store=' + this.sendLocBackToChangeLocTile;
        }
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
        invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Naviate to the ' + prodName + ' product page');
        console.log('ProdName==='+prodName);
         let urlString = window.location.origin;
         let redirectURL =  urlString + communityName +'product/'+prodId +'/'+ prodName+'/?store='+this.sendLocBackToChangeLocTile;
        // let redirectURL = urlString + communityName + 'product?name=' + prodName + '&pId=' + prodId + '&store=' + this.sendLocBackToChangeLocTile;
         console.log('redirectURL===='+redirectURL);
         window.location.href = redirectURL;
         /*
         this[NavigationMixin.Navigate]({
             "type": "standard__webPage",
             "attributes": {
                 "url": redirectURL
             }
         });*/
    }


}