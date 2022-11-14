import {
    LightningElement,
    track,
    wire
} from 'lwc';

import fetchLstCartItemsByCartId from '@salesforce/apex/dbu_CartCtrl.fetchLstCartItemsByCartId';
import fetchOrderDetails from '@salesforce/apex/dbu_ReviewOrder.fetchOrderDetails';
import getCybersourceHostedFormData from '@salesforce/apex/dbu_CyberSourcePayment_Callout.getCybersourceHostedFormData';
import callPaypalPayment from '@salesforce/apex/dbu_paypalPayment.getPaypalPayment';
import fetchPickUpData from '@salesforce/apex/dbu_ReviewOrder.fetchPickUpData';
import CreateOrder from '@salesforce/apex/dbu_CallccapitoCreateOrder.CreateOrder';
import communityName from '@salesforce/label/c.dbu_communityName';
import debitCardMsg from '@salesforce/label/c.dbu_CyberSourec_Debitcard_msg';
import fetchCartId from '@salesforce/apex/dbu_CartCtrl.fetchCartId';
import isGuest from '@salesforce/user/isGuest';
import getShippingAmount from '@salesforce/apex/dbu_ccApiRelatedProduct.getShippingAmount';
import { perfixCurrencyISOCode } from "c/serviceComponent"

//Mounika T changes for Pricing 
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';//custom label refres to'CA'
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA';
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada';

//labels starts here//
import dbu_payment_page_title from '@salesforce/label/c.dbu_payment_page_title';
import dbu_payment_page_Shipping_Address from '@salesforce/label/c.dbu_payment_page_Shipping_Address';
import dbu_payment_page_Pick_Up_From_Store from '@salesforce/label/c.dbu_payment_page_Pick_Up_From_Store';
import dbu_payment_page_Billing_Address from '@salesforce/label/c.dbu_payment_page_Billing_Address';
import dbu_payment_page_Order_Summary from '@salesforce/label/c.dbu_payment_page_Order_Summary';
import dbu_payment_page_Items from '@salesforce/label/c.dbu_payment_page_Items';
import dbu_payment_page_Discount from '@salesforce/label/c.dbu_payment_page_Discount';
import dbu_payment_page_Subtotal from '@salesforce/label/c.dbu_payment_page_Subtotal';
import dbu_payment_page_Tax from '@salesforce/label/c.dbu_payment_page_Tax';
import dbu_payment_page_Shipping_Cost from '@salesforce/label/c.dbu_payment_page_Shipping_Cost';
import dbu_payment_page_Total from '@salesforce/label/c.dbu_payment_page_Total';
import dbu_payment_page_Pay_by from '@salesforce/label/c.dbu_payment_page_Pay_by';
import dbu_payment_page_Return_to_Order_Review from '@salesforce/label/c.dbu_payment_page_Return_to_Order_Review';
import dbu_Coupon_Success from '@salesforce/label/c.dbu_Coupon_Success';


//labels ends here//

//========Promotion Changes====
import applyText from '@salesforce/label/c.dbu_shopCart_apply';
import dbu_Coupon_Msg_FillValue from '@salesforce/label/c.dbu_Coupon_Msg_FillValue';
import updateCartwithCouponDetails from '@salesforce/apex/dbu_CouponServiceHandler.updateCartwithCouponDetails';
import fetchLstCartItemsByCartIdAfterCoupon from '@salesforce/apex/dbu_CouponCtrl.fetchLstCartItemsByCartIdAfterCoupon';
import removeText from '@salesforce/label/c.dbu_shopCart_remove';
import removeAppliedCoupon from '@salesforce/apex/dbu_CouponServiceHandler.removeAppliedCoupon';
//import removeAppliedGiftCard from '@salesforce/apex/dbu_CouponServiceHandler.removeAppliedGiftCard';
import calculateTax from '@salesforce/apex/dbu_CartCtrl.calculateTax';
import updateCartAndCartItem from '@salesforce/apex/dbu_CartCtrl.updateCartAndCartItem';




import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

export default class Dbu_paymentDetails extends LightningElement {

    @track debitCardMsg = debitCardMsg;
    @track cartId;
    @track storefrontName = 'CSSNAStore'; //TODO: Need to be changes to CSSNAStore
    @track currentUserId = '00519000003PPskAAG';
    @track cartDetails;
    //label = {postUrl,accessKey,profileId,returnUrl};
    @track theIframe;
    @track isReloaded = false;
    @track formData;
    //@track goToOrderReceiptURL;
    @track orderId;
    @track isLoading = false;
    @track isModalOpen = false;

    @track addressData;
    @track pickUpAddressData;
    @track pickUpAddressDataflag = false;
    @track hideShippingAddress = false;
    @track shipAmount = '0.00';
    @track cartShipAmount = '0.00';
    @track shippingAddressData = false;
    @track cartOriginalAmount = '0.00';
    @track totalCartDiscount = '0.00';
    @track subtotalAmount = '0.00';
    @track taxAmount = '0.00';
    @track totalAmount = '0.00';
    @track storeLocationText = 'en-US';
    //@track currencyValue = 'USD';
    @track showPaypal = true;
    @track loadPayment = true;
    @track errorMsg = '';
    @track showPaymentButtons = false;

    //Added by Mounika T for pricinig
    @track countryCurrencyCode;
    @track currentStorelocation;
    @track footerbannercookiestatus;

    label = {
        dbu_payment_page_title,
        dbu_payment_page_Shipping_Address,
        dbu_payment_page_Pick_Up_From_Store,
        dbu_payment_page_Billing_Address,
        dbu_payment_page_Order_Summary,
        dbu_payment_page_Items,
        dbu_payment_page_Discount,
        dbu_payment_page_Subtotal,
        dbu_payment_page_Tax,
        dbu_payment_page_Shipping_Cost,
        dbu_payment_page_Total,
        dbu_payment_page_Pay_by,
        dbu_payment_page_Return_to_Order_Review,
        dbu_Coupon_Success
    }



    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
        console.log('Test iframe');
        console.log(this);
        let form = this.template.querySelector('form');
        console.log('Form=>' + form);
        try {
            form.submit();
        } catch (e) {
            console.log('form submit error=>' + JSON.stringify(e));

        }
    }

    get ScreenLoaded() {
        return this.isLoading;
    }



    @track showOrderSummary = false;

    callingGAcheckoutpaymentpageevent(){
        invokeGoogleAnalyticsService('NEXT STEP CHECKOUT DETAILS', {stepnumber : 3, optiondata : 'Payment Method Page', dataFeed: this.cartDetails}); /*CECI-958 GTM Events added datafeed*/
    }

    handleButtonClick() {
        this.isLoading = true;
      
       // alert('cartId on button click=='+this.cartId);
        fetchLstCartItemsByCartId({
            cartId: this.cartId,
            cart: ''
        })
            .then(data => {
                // console.log('data.length===='+data.length);
                if (data && data.length > 0) {
                    this.cartDetails = data;
                    let localcartOriginalAmount = this.cartDetails[0].originalCartAmt;
                    // alert('localcartOriginalAmount==='+localcartOriginalAmount);
                    localcartOriginalAmount = ((Math.round(localcartOriginalAmount * 100) / 100).toFixed(2)) * 1;
                    if (this.cartDetails[0].originalCartAmt != null) {
                        this.cartOriginalAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartOriginalAmount);
                    }


                    let localcartDiscountAmount = this.cartDetails[0].totalCartDiscount;
                    // alert('localcartDiscountAmount==='+localcartDiscountAmount);
                    localcartDiscountAmount = ((Math.round(localcartDiscountAmount * 100) / 100).toFixed(2)) * 1;

                    // alert('this.cartDetails[0].totalCartDiscount==='+this.cartDetails[0].totalCartDiscount);
                    if (this.cartDetails[0].totalCartDiscount != null) {
                        console.log('entering the discount loop if part>>>' + localcartDiscountAmount);
                        this.totalCartDiscount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartDiscountAmount);
                    }

                    let localcartSubtotalAmount = this.cartDetails[0].subtotalAmount;
                    //  alert('localcartSubtotalAmount==='+localcartSubtotalAmount);
                    localcartSubtotalAmount = ((Math.round(localcartSubtotalAmount * 100) / 100).toFixed(2)) * 1;

                    if (this.cartDetails[0].subtotalAmount != null) {
                        console.log('this.cartDetails[0].subtotalAmount' + this.cartDetails[0].subtotalAmount);
                        this.subtotalAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartSubtotalAmount);
                    }

                    let localcartTaxAmount = this.cartDetails[0].taxAmount;
                    //  alert('localcartTaxAmount===='+localcartTaxAmount);
                    localcartTaxAmount = ((Math.round(localcartTaxAmount * 100) / 100).toFixed(2)) * 1;
                    console.log('localcartTaxAmount: ' + localcartTaxAmount);
                    if (this.cartDetails[0].taxAmount != null) {
                        this.taxAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartTaxAmount);
                    }

                    let localcartTotalAmount = this.cartDetails[0].totalAmount;
                    //  alert('localcartTotalAmount==='+localcartTotalAmount);
                    localcartTotalAmount = ((Math.round(localcartTotalAmount * 100) / 100).toFixed(2)) * 1;
                    if (this.cartDetails[0].totalAmount != null) {
                        this.totalAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartTotalAmount);
                    }

                    this.error = undefined;
                    window.console.log('Cart data222222>>>>>>>>', this.cartDetails);
                    //============Promotion Changes===============
                    if (this.cartDetails[0].totalCartDiscount != 0) {
                        console.log('this.cartDiscountAmount from handleEvent1111' + this.cartDiscountAmount);
                        this.removeCouponPlaceHolder = true;
                        this.messageReceived = dbu_Coupon_Success;
                        this.showCouponPlaceholder = false;
                        this.showInvalidCouponPlaceolder = false;
                    } else if (this.cartDetails[0].totalCartDiscount === 0 && this.cartDetails[0].cartDetails.dbu_Free_Shipping__c === false) {
                        console.log('INSIDE AFRIKA CORPS');
                        this.removeCouponPlaceHolder = false;
                        this.showCouponPlaceholder = true;
                        this.showInvalidCouponPlaceolder = false;
                    } else if (this.cartDetails[0].totalCartDiscount === 0 && this.cartDetails[0].cartDetails.dbu_Free_Shipping__c === true) {
                        this.removeCouponPlaceHolder = true;
                        this.messageReceived = dbu_Coupon_Success;
                        this.showCouponPlaceholder = false;
                        this.showInvalidCouponPlaceolder = false;

                    }

                    //=============================================
                    // setTimeout(function(){ 
                    //     form.submit();
                    //  }, 2000);
                    this.handlegetShippingAmount();
                    this.handlefetchOrderDetails();
                    this.handlefetchPickUpData();

                    this.isLoading = false;
                    // alert('this.isLoading==='+this.isLoading);
                    this.showOrderSummary = true;
                    // }, 2000);

                }

            })
            .catch(error => {
                // alert('Error Occured');
                this.error = error;
            });
            
    }


    /* */
    @track accessKey;
    @track profileId;
    @track transactionId;
    @track signedFields;
    @track signedData;
    @track unsignedFields;
    @track referenceNumber;
    @track transactionType;
    @track locale;
    @track amount;
    @track currencyCode;
    @track utcDate;
    @track firstName;
    @track lastName;
    @track email;
    @track billingAddressFirstLine;
    @track billingAddressCity;
    @track billingAddressCountryIsoCode;
    @track billingAddressStateCode;
    @track billingAddressPostalCode;
    @track paymentMethod;
    @track ignoreAvs;
    @track returnURL;
    @track cartSFId;
    @track postUrl;
    @track isGuestUser = isGuest;



    connectedCallback() {
        // alert('connected callback');
        //-- Restricting browser back button---
        window.history.forward();

        let testURL = window.location.href;
        let newURL = new URL(testURL).searchParams;
        console.log(newURL.has('store'));
        let storeLocation = storeUSA;


        storeLocation = window.sessionStorage.getItem('setCountryCode');
        /*Added By Malhar to get store country from this.sendLocBackToChangeLocTile 1/12/2020 */
        if (storeLocation == storeUSA) {
            this.currentStorelocation = storeUSA;
            this.countryCurrencyCode = currencyCodeUSA;
        } else if (storeLocation == storeCA || storeLocation == storeCAF) {
            this.currentStorelocation = storeCanada;
            this.countryCurrencyCode = currencyCodeCanada;
        }

        console.log('this.currentStorelocation cart page connected callback > ' + this.currentStorelocation);
        /*Added By Malhar to get store country from this.sendLocBackToChangeLocTile 1/12/2020 */




        if (storeLocation != storeUSA) {
            this.showPaypal = false;
        }



        /**27 Oct 2020: New Logic to Handle cartId in case of loggeduser && GuestUser*/
        if (this.isGuestUser) {

            this.getfooterbannerCookie('footerBanner');
            console.log('this.footerbannercookiestatus cart connected call > ' + this.footerbannercookiestatus);

            if (this.footerbannercookiestatus) {
                if (this.currentStorelocation == storeUSA) {
                    this.getCookie('cartId');
                } else if (this.currentStorelocation == storeCanada) {
                    this.getCookie('cartIdCA');
                }
            } else if (typeof this.footerbannercookiestatus === "undefined") {
                if (this.currentStorelocation == storeUSA) {
                    //this.getCookie('cartId');
                    this.cartId = window.sessionStorage.getItem('cartId');
                    console.log('session storage CartId in case of Guest User for US store in add all sfl to cart metd of cart page===>', this.cartId);
                }
                else if (this.currentStorelocation == storeCanada) {
                    //this.getCookie('cartIdCA');
                    this.cartId = window.sessionStorage.getItem('cartIdCA');
                    console.log('session storage CartId in case of Guest User for CA store in add all sfl to cart metd of cart page===>', this.cartId);
                }
            }

            console.log('CartId in case of Guest User in dbu_PaymentDetails===>', this.cartId);
        //    this.getDataForiFrame();
             this.handleButtonClick();
        } else {
            fetchCartId({
                storeCountry: this.currentStorelocation
            })
                .then(result => {
                    console.log('CartId in case of loggedIn User in dbu_PaymentDetails===>', result);
                    this.cartId = result;
                    this.error = undefined;
                 //   this.getDataForiFrame();
                 this.handleButtonClick();
                })
                .catch(error => {
                    this.error = error.message;
                });
        }



        /**Ended here */
        // alert('connectedCartId============', this.cartId);

    }

    /*Added by Malhar - For user story 1386 - Begins - 15/12/2020 */
    getfooterbannerCookie(name) {
        var name = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                this.footerbannercookiestatus = c.substring(name.length, c.length);
            }
        }
    }


    getDataForiFrame() {
        let testURL = window.location.href;
        let newURL = new URL(testURL).searchParams;
        console.log(newURL.has('store'));
        let storeLocation = storeUSA;

        storeLocation = window.sessionStorage.getItem('setCountryCode');
        console.log('storeLocation: ' + storeLocation);       

        getCybersourceHostedFormData({
            cartId: this.cartId,
            storefrontName: '$storefrontName',
            currentUserId: '$currentUserId',
            storeLocation: storeLocation,
            currentDomain: window.location.origin
        })
            .then(result => {

                if (result) {

                    this.error = undefined;
                    this.hasResults = true;
                    console.log('getCybersourceHostedFormData callback completed in LWC');
                    //console.log('getCybersourceHostedFormData Data=>'+ data);
                    console.log('getCybersourceHostedFormData Data=>' + JSON.stringify(result));
                    
                    this.accessKey = result.accessKey;
                    this.profileId = result.profileId;
                    this.transactionId = result.transactionId;
                    this.signedFields = result.signedFields;
                    this.signedData = result.signedData;
                    this.unsignedFields = result.unsignedFields;
                    this.referenceNumber = result.referenceNumber;
                    this.transactionType = result.transactionType;
                    this.locale = result.locale;
                    this.amount = result.amount;
                    this.currencyCode = result.currencyCode;
                    this.utcDate = result.utcDate;
                    this.firstName = result.firstName;
                    this.lastName = result.lastName;
                    this.email = result.email;
                    this.billingAddressFirstLine = result.billingAddressFirstLine;
                    this.billingAddressCity = result.billingAddressCity;
                    this.billingAddressCountryIsoCode = result.billingAddressCountryIsoCode;
                    this.billingAddressStateCode = result.billingAddressStateCode;
                    this.billingAddressPostalCode = result.billingAddressPostalCode;
                    this.paymentMethod = result.paymentMethod;
                    this.ignoreAvs = result.ignoreAvs;
                    this.returnURL = result.returnURL;
                    this.cartSFId = result.cartSFId;
                    this.postUrl = result.postUrl;

                    let form = this.template.querySelector('form');

                    let iframe = this.template.querySelector('iframe');
                    console.log('form=>' + JSON.stringify(form));
                    console.log('iframe=>' + iframe);
                    //iframe.src = result.postUrl;
                    console.log('iframe src updated');
                    console.log(this);
                    
                    try {
                        if(this.isCreditCardSelected){
                            setTimeout(() => {
                                form.submit();
                             }, 3000);
                        }
                        
                    } catch (e) {
                        console.log('form submit error=>' + JSON.stringify(e));
            
                    }
                    
                    //this.handleSubmit();
                  // this.handleButtonClick();
                }
            })
            .catch(error => {
                if (error) {
                    debugger;
                    console.log('getCybersourceHostedFormData error=>' + JSON.stringify(error));
                    if (error.status == 500 && error.body.message === 'Domain is not availabel for payment') {
                        this.loadPayment = false;
                        this.errorMsg = error.body.message;
                    }

                    this.isLoading = false;
                }
            })
    }

    @track isCreditCardSelected = false;

    handleSubmit(e) {
        this.isCreditCardSelected = true;
        this.getDataForiFrame();
        
        console.log('Test iframe');
        console.log(this);
        invokeGoogleAnalyticsService('BUTTON CLICK', { eventName: 'Pay by credit card', eventAction: 'pay by credit card button click' });
        invokeGoogleAnalyticsService('CHECKOUT OPTION',{currenctStep : 3, option : 'credit card Payment'});
        //invokeGoogleAnalyticsService('NEXT STEP CHECKOUT DETAILS', { stepnumber: 3, optiondata: 'credit card Payment' });
        e.target.classList.add('selected');
        this.template.querySelector('.payment_cc_information').classList.add('loaderadded');
        this.template.querySelector('iframe').classList.add('iFrameOpened');
        let form = this.template.querySelector('form');
        console.log('Form=>' + form);
        // try {
        //     // this.handleButtonClick(form);
        //     setTimeout(() => {
        //        // this.ready = true;
        //         form.submit();
        //     }, 3000);
            
        // } catch (e) {
        //     console.log('form submit error=>' + JSON.stringify(e));

        // }
    }

    returnOrderreview() {
        console.log('here to go');
        invokeGoogleAnalyticsService('BUTTON CLICK', { eventName: 'return to order review page from payment page', eventAction: 'return to order review page button click' });
        let urlString = window.location.origin;
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        // let currentstorelang = url.searchParams.get("store");
        //pubsub.fire('sendLocToStore', this.sendLocBackToChangeLocTile);
        let currentstorelang = window.sessionStorage.getItem('setCountryCode');
        window.location.href = urlString + communityName + 'order-review?cartId=' + this.cartId + '&store=' + currentstorelang;
    }
    handlePaypal() {

        console.log('with paypal');
        invokeGoogleAnalyticsService('BUTTON CLICK', { eventName: 'Pay by PayPal', eventAction: 'pay by PayPal button click' });
        invokeGoogleAnalyticsService('CHECKOUT OPTION',{currenctStep : 3, option : 'PayPal Payment'});
        //invokeGoogleAnalyticsService('NEXT STEP CHECKOUT DETAILS', { stepnumber: 3, optiondata: 'PayPal Payment' });
        console.log(window.location.href);
        console.log(this.cartId);
        let urlString = window.location.origin;
        let testURL = window.location.href;
        let newURL = new URL(testURL).searchParams;
        let store = storeUSA;
        store = window.sessionStorage.getItem('setCountryCode');

        callPaypalPayment({
            cartid: this.cartId,
            url: urlString + communityName + 'payment-confirmation?cartId=' + this.cartId + '&store=' + store,
            cancleUrl: urlString + communityName + 'payment?cartId=' + this.cartId + '&store=' + store

        })
            .then(
                result => {
                    if (result) {
                        console.log(result);
                        window.location.href = result;

                    }
                }
            )
            .catch(error => {
                if (error) {
                    // alert('in error '+error);
                    console.log('error=>' + JSON.stringify(error));

                }
            })
    }



    get goToOrderReceiptURL() {
        let urlString = window.location.origin;
        return urlString + communityName + 'orderconfirmation?orderId=' + this.orderId;
    }

    /**Shriram: 3 Nov 2020 */
    createCookie(name, value, days) {
        var expires;



        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = name + "=" + escape(value) + expires + "; path=/";
    }
    /** */


    getCookie(name) {
        var name = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                this.cartId = c.substring(name.length, c.length);

            }
        }
    }

    //-------------------------

    handlefetchOrderDetails() {
        // alert('handlefetchOrderDetails called');
        fetchOrderDetails({ cartId: this.cartId })
            .then(data => {
                if (data) {

                    console.log('orderData>>>>>>>>>>', JSON.stringify(data));
                    this.addressData = data;
                    console.log('this.addressData length> ' + this.addressData.length);
                    console.log('this.addressData > ' + this.addressData);
                    console.log('hadapases  > ' + this.addressData[0].AddressList.length);
                    if(this.addressData[0].AddressList != null && this.addressData[0].AddressList != undefined ){
                        console.log('OXUS  > ' + this.addressData[0].AddressList.length);
                        if(this.addressData[0].AddressList.length > 0){
                            this.shippingAddressData = true;
                        }                        
                    } 
                    console.log('this.shippingAddressData > ' + this.shippingAddressData);
                    /*if (this.addressData.addressFirstline === null ) {
                        this.shippingAddressData = false;
                        console.log('this.shippingAddressData > ' + this.shippingAddressData);
                    }*/
                    //this.error = undefined;
                    this.isLoading = false;
                }

            })
            .catch(error => {
                this.error = error.message;
                console.log('this.error > ' + this.error);
                this.isLoading = false;
                this.error = error;
                this.addressData = false;
            });
            this.callingGAcheckoutpaymentpageevent();
    }
    
    handlefetchPickUpData() {
        //  alert('handlefetchPickUpData called');
        fetchPickUpData({ cartId: this.cartId })
            .then(data => {
                if (data) {
                    
                    console.log('data in pickup method>>' + JSON.stringify(data));
                    this.pickUpAddressData = data;
                    console.log('amudarya > ' + JSON.stringify(this.pickUpAddressData[0]));
                    console.log('bashkhor > ' + JSON.stringify(this.pickUpAddressData[0].dbu_Pick_Up_From_Store__r));
                    if(this.pickUpAddressData[0].dbu_Pick_Up_From_Store__r != null 
                        && this.pickUpAddressData[0].dbu_Pick_Up_From_Store__r != undefined 
                        && this.pickUpAddressData[0].dbu_Pick_Up_From_Store__r != ''){
                            this.pickUpAddressDataflag = true;
                        }

                    else if(this.pickUpAddressData[0].dbu_Pick_Up_From_Store__r == null || 
                        this.pickUpAddressData[0].dbu_Pick_Up_From_Store__r == undefined || 
                        this.pickUpAddressData[0].dbu_Pick_Up_From_Store__r == ''){
                        
                        this.pickUpAddressDataflag = false;
                       
                    }
                    console.log('this.pickUpAddressData > '+ this.pickUpAddressDataflag);
                    /*
                    if (this.pickUpAddressData[0].ccrz__ShipMethod__c === 'Pick Up' || this.pickUpAddressData[0].ccrz__ShipMethod__c === 'Ramassage') {
                        //this.hideShippingAddress = true;
                    } else if (this.pickUpAddressData[0].ccrz__ShipMethod__c === 'Ship To Address' || this.pickUpAddressData[0].ccrz__ShipMethod__c === 'Adresse d\'expédition') {
                        //this.hideShippingAddress = false;
                    }*/
                }

            })
            .catch(error => {
                this.error = error.message;
                console.log('this.error > ' + this.error);
                this.isLoading = false;
                this.pickUpAddressDataflag = false;
            });
    }

    handlegetShippingAmount() {
        //  alert('handlegetShippingAmount called');
        getShippingAmount({ cartId: this.cartId })
            .then(data => {
                if (data != null) {
                    this.isLoading = false;
                    console.log('shipment>>>>>>>>>>', JSON.stringify(data));
                    this.shipAmount = data;

                    if (this.shipAmount != null) {
                        this.cartShipAmount = perfixCurrencyISOCode(this.countryCurrencyCode, this.shipAmount);
                    }

                    console.log('shipment ', this.cartShipAmount);
                    this.error = undefined;
                }

            })
            .catch(error => {
                console.log('error>>>>>>>>>>', error);
                this.isLoading = false;
                this.error = error;
            });
    }

    // ========Promotion logic starts here Mukesh 17-Sep- 2021 =============
    @track couponData = '';
    @track applyText = applyText;
    @track messageReceived;
    @track removeCouponPlaceHolder = false;
    @track showInvalidCouponPlaceolder = false;
    @track showCouponPlaceholder = true;
    @track removeText = removeText;
    @track showGiftCardPlaceholder = false;
    @track giftCardData = '';
    @track giftCardArray = [];
    @track isGiftCardApplied = false;
    @track isGiftCardAlreadyApplied = false;
    @track isBlank = false;
    @track giftCardAppliedMsg = '';
    @track giftCardErrorMsg;
    @track isDisabled = false;
    @track showSubmitOrder = false;


    handleCouponChange(event) {
        console.log('event>>' + event.target.value);
        this.couponData = event.target.value;
    }

    handleCouponApplied(event) {
        if (this.couponData === '') {
            this.showInvalidCouponPlaceolder = true;
            this.messageReceived = dbu_Coupon_Msg_FillValue;
            return;
        }
        this.isLoading = true;
        console.log('==Cart Id onclick====' + this.cartId);
        console.log('===CouponData=====' + this.couponData);

        updateCartwithCouponDetails({
            cartId: this.cartId,
            couponCode: this.couponData
        }).then(result => {
            console.log('====Coupon isApplied===' + result.isCouponApplied);
            console.log('====Coupon Message===' + result.couponMsg);
            if (result.isCouponApplied) {
                this.handleTaxCalculation();
                this.removeCouponPlaceHolder = true;
                this.showInvalidCouponPlaceolder = false;
                this.messageReceived = result.couponMsg;
                this.showCouponPlaceholder = false;
               // this.getDataForiFrame();
              //  this.fetchUpdatedCartSummary();

            } else {
                this.showInvalidCouponPlaceolder = true;
                this.removeCouponPlaceHolder = false;
                this.messageReceived = result.couponMsg;
                this.isLoading = false;
            }
           // this.isLoading = false;

        })
            .catch(error => {
                this.error = error.message;
                this.isLoading = false;
            });


    }

    handleTaxCalculation(){
        calculateTax({
            cartId: this.cartId
            })
            .then(result11 => {
                console.log('tax calculation after promotion applied =>' + JSON.stringify(result11));
                updateCartAndCartItem({
                    cartAndCartItem: JSON.stringify(result11)
                })
                    .then(result111 => {
                        this.fetchUpdatedCartSummary();
                        this.getDataForiFrame();
                     })
                    .catch(error => {
                        this.error = error.message;
                        console.log('calculateTax error.message'+error.message);
                     });
            })
            .catch(error => {
                this.error = error.message;
                console.log('calculateTax error.message'+error.message);
            });
    }

    handleCouponRemoval() {
        this.isLoading = true;
        console.log('entering the removal methd' + this.cartId);
        removeAppliedCoupon({
            CartIdRmv: this.cartId
        }).then(result => {
            console.log('couponRemoval' + result);

            this.handleTaxCalculation();
          //  this.getDataForiFrame(); // Need to comment this line in SIT,UAT,PROD
           // this.fetchUpdatedCartSummary();
            this.couponData = '';
           // this.isLoading = false;
            this.removeCouponPlaceHolder = false;
            this.showCouponPlaceholder = true;
           // this.isLoading = false;
            this.giftCardArray = [];

        }).catch(error => {
            console.log('error =====> ' + JSON.stringify(error));
            if (error) {
                this.errorMsg = error.body.message;
            }
        })

    }

    fetchUpdatedCartSummary() {
        fetchLstCartItemsByCartIdAfterCoupon({
            cartId: this.cartId

        })
            .then(data => {
                console.log('data.length====' + data.length);
                if (data && data.length > 0) {
                    this.cartDetails = data;
                    let localcartOriginalAmount = this.cartDetails[0].originalCartAmt;
                    localcartOriginalAmount = ((Math.round(localcartOriginalAmount * 100) / 100).toFixed(2)) * 1;
                    if (this.cartDetails[0].originalCartAmt != null) {
                        this.cartOriginalAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartOriginalAmount);
                    }
                    let localcartDiscountAmount = this.cartDetails[0].totalCartDiscount;
                    localcartDiscountAmount = ((Math.round(localcartDiscountAmount * 100) / 100).toFixed(2)) * 1;
                    if (this.cartDetails[0].totalCartDiscount != null) {
                        this.totalCartDiscount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartDiscountAmount);
                    }

                    let localcartSubtotalAmount = this.cartDetails[0].subtotalAmount;
                    localcartSubtotalAmount = ((Math.round(localcartSubtotalAmount * 100) / 100).toFixed(2)) * 1;

                    if (this.cartDetails[0].subtotalAmount != null) {
                        this.subtotalAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartSubtotalAmount);
                    }

                    let localcartTaxAmount = this.cartDetails[0].taxAmount;
                    localcartTaxAmount = ((Math.round(localcartTaxAmount * 100) / 100).toFixed(2)) * 1;
                    if (this.cartDetails[0].taxAmount != null) {
                        this.taxAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartTaxAmount);
                    }

                    let localcartTotalAmount = this.cartDetails[0].totalAmount - this.cartDetails[0].totalGiftCardAmount;
                    console.log('total cart Amt==='+localcartTotalAmount);
                    if(localcartTotalAmount == 0){
                        this.isDisabled = true;
                        this.showSubmitOrder = true;
                    }else{
                        this.isDisabled = false;
                        this.showSubmitOrder = false;
                    }
                    localcartTotalAmount = ((Math.round(localcartTotalAmount * 100) / 100).toFixed(2)) * 1;
                    if (this.cartDetails[0].totalAmount != null) {
                       
                        this.totalAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartTotalAmount);
                    }

                    this.handlegetShippingAmount();
                    this.isLoading = false;
                }

            })
            .catch(error => {
                this.error = error;
            });

    }
  
    //==== Commenting Gift card logic for time being====Mukesh=22-Oct-2021

 /*   handleReedemGiftCard() {
        this.showGiftCardPlaceholder = true;
    }

    handleGiftCard(event) {
        this.giftCardData = event.target.value.trim();
        console.log('giftCardData===' + this.giftCardData);
    }

    handleGiftCardApplied() {
        if (this.giftCardData === '') {
            this.isBlank = true;
            this.giftCardErrorMsg = 'Please Enter Gift Card Code !!';
            return;
        }
        if (this.giftCardArray.length > 0 && this.giftCardArray.includes(this.giftCardData.toUpperCase())) {
            this.isGiftCardAlreadyApplied = true;
            return;
        }
        this.isGiftCardAlreadyApplied = false;


        updateCartwithCouponDetails({
            cartId: this.cartId,
            couponCode: this.giftCardData
        }).then(result => {
            console.log('====Coupon isApplied===' + result.isCouponApplied);
            console.log('====Coupon Message===' + result.couponMsg);
            if (result.isCouponApplied) {
                this.fetchUpdatedCartSummary();
                this.giftCardArray.push(this.giftCardData.toUpperCase());
                console.log('this.giftCardArray====' + this.giftCardArray);
                console.log('this.giftCardArray length====' + this.giftCardArray.length);
                if (this.giftCardArray.length > 0) {
                    this.isGiftCardApplied = true;
                    this.giftCardAppliedMsg = result.couponMsg;
                }
                this.giftCardData = '';
                this.isBlank = false;
            }else{
                this.isBlank = true;
                this.giftCardErrorMsg = result.couponMsg;
                this.giftCardData = '';
               
            }
            this.isLoading = false;

        })
            .catch(error => {
                this.error = error.message;
                this.isLoading = false;
            });
    }

    handleRemoveGiftCard(event) {
        console.log(event.target.dataset.name);
        let giftCardName =  event.target.dataset.name;
        removeAppliedGiftCard({
            CartIdRmv: this.cartId,
            giftCardCode: giftCardName

        }).then(result => {
            if (result) {
                this.fetchUpdatedCartSummary();
                for(let i=0; i<this.giftCardArray.length; i++){
                    if(this.giftCardArray[i] === giftCardName){
                        this.giftCardArray.splice(i, 1);
                    }
                }
            }
        }).catch(error => {
            console.log('error =====> ' + JSON.stringify(error));
            if (error) {
                this.errorMsg = error.body.message;
            }
        })
        this.isGiftCardAlreadyApplied = false;
    }*/

}