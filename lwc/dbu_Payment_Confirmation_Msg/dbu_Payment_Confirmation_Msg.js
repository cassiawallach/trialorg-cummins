import { LightningElement,track } from 'lwc';

import CreateOrder from '@salesforce/apex/dbu_CallccapitoCreateOrder.CreateOrder';
import communityName from '@salesforce/label/c.dbu_communityName';
import fetchCartId from '@salesforce/apex/dbu_CartCtrl.fetchCartId';
import getSalesId from '@salesforce/apex/dbu_paypalPayment.getSalesId';
import isGuest from '@salesforce/user/isGuest';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from'@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from'@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import storeCanada from'@salesforce/label/c.dbu_home_store_Canada_CA';//custom label refres to'CA'
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA';
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada';
import { perfixCurrencyISOCode,createCookiesData } from 'c/serviceComponent';



import dbu_PaymentConfirmationMsg_PaymentSuccess from '@salesforce/label/c.dbu_PaymentConfirmationMsg_PaymentSuccess';
import dbu_PaymentConfirmationMsg_OrderConfirmationPageRedirect from '@salesforce/label/c.dbu_PaymentConfirmationMsg_OrderConfirmationPageRedirect';
import dbu_PaymentConfirmationMsg_PaymentFailure from '@salesforce/label/c.dbu_PaymentConfirmationMsg_PaymentFailure';
import dbu_PaymentConfirmationMsg_PaymentpageRedirect from '@salesforce/label/c.dbu_PaymentConfirmationMsg_PaymentpageRedirect';
import createCybersourceURLLog from '@salesforce/apex/dbu_CartCtrl.createCybersourceURLLog';//@Support
import dbu_capture_cybersource_URL from '@salesforce/label/c.dbu_capture_cybersource_URL';//@Support - YES or NO




export default class Dbu_Payment_Confirmation_Msg extends LightningElement {

    @track cartId;
    @track error;
    @track isGuestUser = isGuest;
    @track orderId;
    @track isLoading;
    @track tpData;
    @track showSuccess = true;
    @track countryCurrencyCode;
    @track locationData;

    @track dbu_PaymentConfirmationMsg_PaymentSuccess = dbu_PaymentConfirmationMsg_PaymentSuccess;
    @track dbu_PaymentConfirmationMsg_OrderConfirmationPageRedirect = dbu_PaymentConfirmationMsg_OrderConfirmationPageRedirect;
    @track dbu_PaymentConfirmationMsg_PaymentFailure = dbu_PaymentConfirmationMsg_PaymentFailure;
    @track dbu_PaymentConfirmationMsg_PaymentpageRedirect = dbu_PaymentConfirmationMsg_PaymentpageRedirect;

    //Added by Malhar for getting the storelocation  value - 7/12/2020
    @track currentStorelocation;
    @track footerbannercookiestatus;

    connectedCallback() {
         //-- Restricting browser back button---
         window.history.forward();
        /**Getting locationnCode */
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        
        this.locationData =window.sessionStorage.getItem('setCountryCode');
        console.log('this.locationData in Dbu_Payment_Confirmation_Msg>>>>>>' + this.locationData);
        
        /*Added By Malhar to get store country from this.sendLocBackToChangeLocTile 1/12/2020 */
        if(this.locationData == storeUSA){
            this.currentStorelocation = storeUSA;
        }else if(this.locationData == storeCA || this.locationData == storeCAF){
            this.currentStorelocation = storeCanada; 
        }
        console.log('this.currentStorelocation cart page connected callback > ' + this.currentStorelocation);
        /*Added By Malhar to get store country from this.sendLocBackToChangeLocTile 1/12/2020 */          


        /**end here */        
        if(this.isGuestUser) {

            /*Modification by MALHAR - end - store toggling - 1/12/2020 */     
            this.getfooterbannerCookie('footerBanner');
            console.log('this.footerbannercookiestatus payment msg connected call > ' + this.footerbannercookiestatus);             

            if(this.footerbannercookiestatus){
                console.log('******************************');
                if(this.currentStorelocation == storeUSA){
                    //this.getCookie('cartId');
                    
                    let UScartidInSessionStorage = window.sessionStorage.getItem('cartId');
                    console.log('UScartidInSessionStorage >>>>> ' + UScartidInSessionStorage);
                    this.getCookie('cartId');

                    if(UScartidInSessionStorage !== null && (typeof this.cartId == "undefined" || this.cartId.length === 0)){
                        console.log('inside UScartidInSessionStorage');
                        this.cartId = UScartidInSessionStorage;
                        console.log('this.cartId US ***** ' + this.cartId);
                        this.createCookie('cartId', this.cartId, 7);
                        window.sessionStorage.removeItem('cartId');
                    }                     
                    
                    console.log('this.cartId US payment msg >>>>>> ' + this.cartId);                                                                                                
                }    
                else if(this.currentStorelocation == storeCanada){                  
                    //this.getCookie('cartIdCA');
                   
                    let CAcartidInSessionStorage = window.sessionStorage.getItem('cartIdCA');
                    console.log('CAcartidInSessionStorage >>>>> ' + CAcartidInSessionStorage);                    
                    this.getCookie('cartIdCA');

    
                    if(CAcartidInSessionStorage !== null && (typeof this.cartId == "undefined" || this.cartId.length === 0)){
                        console.log('inside CAcartidInSessionStorage');
                        this.cartId = CAcartidInSessionStorage;
                        console.log('this.cartId CA ***** ' + this.cartId);
                        this.createCookie('cartIdCA', this.cartId, 7);
                        window.sessionStorage.removeItem('cartIdCA');
                    }  

                    console.log('this.cartId CA payment msg >>>>>> ' + this.cartId);
                }
            }else if(typeof this.footerbannercookiestatus === "undefined"){                
                if(this.currentStorelocation == storeUSA){
                    //this.getCookie('cartId');
                    this.cartId = window.sessionStorage.getItem('cartId');
                    console.log('session storage CartId in case of Guest User for US store in connectd call metd of payment msg page===>', this.cartId);
                }    
                else if(this.currentStorelocation == storeCanada){
                    //this.getCookie('cartIdCA');
                    this.cartId = window.sessionStorage.getItem('cartIdCA');
                    console.log('session storage CartId in case of Guest User for CA store in connectd call metd of payment msg page===>', this.cartId);
                }                                
            }            

            console.log('CartId in case of Guest User in dbu_PaymentDetails===>', this.cartId);
                        
            this.prepareDataforTransactionPayment();
        }else{
            fetchCartId({
                storeCountry : this.currentStorelocation
            })
                .then(result => {
                    console.log('CartId in case of loggedIn User in dbu_PaymentDetails===>', result);
                    this.cartId = result;
                    this.error = undefined;
                    this.prepareDataforTransactionPayment();
                })
                .catch(error => {
                    this.error = error.message;
                });
        }
        console.log('got cart id: '+this.cartId);
        
        let capture = dbu_capture_cybersource_URL;
        if(capture.toUpperCase() === 'YES') {
            createCybersourceURLLog({cartId:this.cartId,url:window.location.href}).then( () => console.log('Success')).catch(error => console.log(error)); 
        }

        
    }

    prepareDataforTransactionPayment()
    {
        let testURL = window.location.href;
        let newURL = new URL(testURL).searchParams;
        console.log(newURL.has('paymentId'));
        if(newURL.has('paymentId'))
        {
            // code to create TP for paypal
            console.log('in paypal');
            let tp = {};
            tp.transactionPaymentId = newURL.get('paymentId');
            tp.token = newURL.get('token');
            tp.paymentType = 'PayPal';
            tp.storefront = 'CSSNAStore';
            tp.accountNumber = newURL.get('PayerID');
            tp.transactionType = 'PayPal';
            
            getSalesId({
                PayerId: tp.accountNumber,
                transactionId: tp.transactionPaymentId
            }).then(result => {
                console.log('result : '+result);
                if(!!result){
                    tp.transactionSubcode = result;
                    this.tpData = JSON.stringify(tp);
                    console.log('tp data: '+this.tpData);
                    this.handleClickOrder();
                } else {
                    this.toShowErrorMsg();
                }
            })
            .catch(error => {
                this.error = error;
                console.log('error=>>get sales id from paypal' + JSON.stringify(this.error));
                this.isLoading = false;
                this.toShowErrorMsg();
            });


            
        }
        else if(newURL.has('transaction_id'))
        {
            // code to create TP for cybersource
            if(newURL.get('decision') == 'ACCEPT')
            {
                let tp = {};
                tp.transactionPaymentId = newURL.get('transaction_id')
                tp.token = newURL.get('request_token');
                tp.paymentType = 'credit card';
                tp.storefront = 'CSSNAStore';
                tp.accountNumber = newURL.get('req_card_number');
                tp.transactionType = newURL.get('card_type_name');
                tp.transactionSubcode = newURL.get('req_reference_number');
                tp.transactionCode = newURL.get('bill_trans_ref_no');//Shriram 7Dec21
                this.tpData = JSON.stringify(tp);
                console.log('tp data: '+this.tpData);
                this.handleClickOrder();
            }
            else
            {
                this.toShowErrorMsg();
            }
        }
        else{
            this.toShowErrorMsg();
        }
        
    }

    toShowErrorMsg()
    {
        this.showSuccess = false;
        setTimeout(() => { console.log("World!"); }, 5000);
        let urlString = window.location.origin;

        /**Getting locationnCode */
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        if (url.searchParams.get("store") != undefined) {
            this.locationData = url.searchParams.get("store");
        }        

        window.location.href = urlString + communityName + 'payment?cartId=' + this.cartId + '&store=' + this.locationData;
    }

    /*Added by Malhar - For user story 1386 - Begins - 1/12/2020 */
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

    handleClickOrder() {
        setTimeout(() => { console.log("World!"); }, 5000);
        this.isLoading = true;
        console.log('insie handel click')
        console.log(this.tpData);
        console.log('insie handel ' + this.cartId)
        CreateOrder({
                cartid: this.cartId,
                tpdata: this.tpData
            }).then(result => {
                this.orderId = result;
                //CHG0085464
                if(result === 'NoData'){
                    console.log('NoData'+result);
                    this.isLoading = false;
                    this.showSuccess = false;
                    var url = new URL(window.location.href);
                    if (!!url.searchParams.get("store")) {
                        this.locationData = url.searchParams.get("store");
                    }        
                    window.location.href = window.location.origin + communityName + 'cart?cartId=' + this.cartId + '&store=' + this.locationData;
                    return false;
                }

                console.log('After creating the Order OrderId==>', result);
                if (this.isGuestUser) {
                    console.log('Making cartId as blank in cookie for Guest user after order creation' + result);
                    if(this.currentStorelocation == storeUSA){
                        this.createCookie('cartId', '', 1);
                        window.sessionStorage.removeItem('cartId');
                    }    
                    else if(this.currentStorelocation == storeCanada){
                        this.createCookie('cartIdCA', '', 1);
                        window.sessionStorage.removeItem('cartIdCA');
                    }
                    //Security changes , Added by Ranadip
                    createCookiesData(this.orderId);
                    //let cartAndOrderIds = this.cartId + this.orderId;
                    //this.createCartCookie('carts', cartAndOrderIds, 1);
                    // end here
                }
                let urlString = window.location.origin;
               window.location.href = urlString + communityName + 'order?cartId=' + this.cartId+'&store='+this.locationData;
            })
            .catch(error => {
                this.error = error;
                console.log('error=>>Addressval' + JSON.stringify(this.error));
                this.isLoading = false;
            });
        console.log('outside settimeout', this.cartId);

    }

    createCartCookie(name, value, days){
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

    getCookie(name) {
        var name = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            console.log('In the getCookie method ===\t', name);
            if (c.indexOf(name) == 0) {
                this.cartId = c.substring(name.length, c.length);
            }
        }
    }

}