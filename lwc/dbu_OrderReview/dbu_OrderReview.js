import { LightningElement,track,wire } from 'lwc';
import fetchOrderDetails from '@salesforce/apex/dbu_ReviewOrder.fetchOrderDetails';
import fetchPickUpData from '@salesforce/apex/dbu_ReviewOrder.fetchPickUpData';
import fetchLstCartItemsByCartId from '@salesforce/apex/dbu_CartCtrl.fetchLstCartItemsByCartId';
import communityName from '@salesforce/label/c.dbu_communityName';
import getShippingAmount from '@salesforce/apex/dbu_ccApiRelatedProduct.getShippingAmount';
import isGuest from '@salesforce/user/isGuest';
import fetchCartId from '@salesforce/apex/dbu_CartCtrl.fetchCartId';
import coreChargeAvailabilityMsg from '@salesforce/label/c.dbu_CoreCharge_Availability_Msg';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';//custom label refres to'CA'
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA';
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada';
import taxFailMsg from '@salesforce/label/c.dbu_Vertex_Tax_Call_Failure_Msg';//INC2628005 CTS CHANGES

import {
    NavigationMixin
} from 'lightning/navigation';
import pubsub from 'c/pubsub';
import dbu_reviewPage_reviewOrder from "@salesforce/label/c.dbu_reviewPage_reviewOrder";
import dbu_reviewPage_shippingAddress from "@salesforce/label/c.dbu_reviewPage_shippingAddress";
import dbu_checkoutPage_pickupFromStore from "@salesforce/label/c.dbu_checkoutPage_pickupFromStore";
import dbu_reviewPage_billingAddress from "@salesforce/label/c.dbu_reviewPage_billingAddress";
import dbu_reviewPage_change from "@salesforce/label/c.dbu_reviewPage_change";
import dbu_reviewPage_product from "@salesforce/label/c.dbu_reviewPage_product";
import dbu_reviewPage_quantity from "@salesforce/label/c.dbu_reviewPage_quantity";
import dbu_reviewPage_unitPrice from "@salesforce/label/c.dbu_reviewPage_unitPrice";
import dbu_reviewPage_subTotal from "@salesforce/label/c.dbu_reviewPage_subTotal";
import dbu_reviewPage_items from "@salesforce/label/c.dbu_reviewPage_items";
import dbu_reviewPage_CartEmpty_Message from "@salesforce/label/c.dbu_reviewPage_CartEmpty_Message";
import dbu_reviewPage_orderSummary from "@salesforce/label/c.dbu_reviewPage_orderSummary";
import dbu_reviewPage_Discount from "@salesforce/label/c.dbu_reviewPage_Discount";
import dbu_reviewPage_Tax from "@salesforce/label/c.dbu_reviewPage_Tax";
import dbu_reviewPage_shippingCost from "@salesforce/label/c.dbu_reviewPage_shippingCost";
import dbu_reviewPage_total from "@salesforce/label/c.dbu_reviewPage_total";
import dbu_reviewPage_Return_to_Shipping from "@salesforce/label/c.dbu_reviewPage_Return_to_Shipping";
import dbu_reviewPage_Proceed_to_Payment from "@salesforce/label/c.dbu_reviewPage_Proceed_to_Payment";
import dbu_reviewOrder_Subtotal from "@salesforce/label/c.dbu_reviewOrder_Subtotal";
import { perfixCurrencyISOCode } from 'c/serviceComponent';
import calculateTax from '@salesforce/apex/dbu_CartCtrl.calculateTax';
import updateCartAndCartItem from '@salesforce/apex/dbu_CartCtrl.updateCartAndCartItem';
import getStatesData from '@salesforce/apex/dbu_CustomsettingCntrl.getStatesData';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';


export default class Dbu_OrderReview extends NavigationMixin(LightningElement) {
    @track addressData;
    @track cartId;//
    @track cartDetails;
    @track isLoading = true
    @track shipAmount = 0.00;
    @track showShippingData = false;
    @track statePicklistValues = '';
    @track statePicklistValuArray = [];
    @track arrayValues = '';
    @track isguestuser = isGuest;
    @track cartDiscountAmount = '0.00';
    @track cartOriginalAmount = '0.00';
    @track cartSubtotalAmount = '0.00';
    @track cartTotalAmount = '0.00';
    @track cartTaxAmount = '0.00';
    @track cartShipAmount = '$0.00';
    @track storeLocationText = 'en-US';
    @track sendLocBackToChangeLocTile;
    @track pickUpAddressData;
    @track hideShippingAddress = false;
    @track coreChargeAvailabilityMsg = coreChargeAvailabilityMsg;
    @track countryCurrencyCode;
    @track statesMtData;
    @track pickUpStoreState;
    @track pickUpStateCode;
    @track isPickup = true;
    //Added by Malhar for getting the footer footerBanner cookie value - 7/12/2020
    @track footerbannercookiestatus;  
    @track pickUpCountry;  

     //Added by Malhar for getting the storelocation  value - 7/12/2020
    @track currentStorelocation;   
    
    label = {
        dbu_reviewPage_reviewOrder,
        dbu_reviewPage_shippingAddress,
        dbu_checkoutPage_pickupFromStore,
        dbu_reviewPage_billingAddress,
        dbu_reviewPage_change,
        dbu_reviewPage_items,
        dbu_reviewPage_product,
        dbu_reviewPage_quantity,
        dbu_reviewPage_unitPrice,
        dbu_reviewPage_subTotal,
        dbu_reviewPage_CartEmpty_Message,
        dbu_reviewPage_orderSummary,
        dbu_reviewPage_Discount,
        dbu_reviewPage_Tax,
        dbu_reviewPage_shippingCost,
        dbu_reviewPage_total,
        dbu_reviewPage_Return_to_Shipping,
        dbu_reviewPage_Proceed_to_Payment,
        dbu_reviewOrder_Subtotal,
        taxFailMsg //INC2628005 CTS CHANGES
    };

    connectedCallback() {


        /*added by mounika t to navigation through nav mixin */
        let locationURL = window.location.href;
        var url = new URL(locationURL);
        //this.sendLocBackToChangeLocTile = url.searchParams.get("store");
        this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');

        //pubsub.fire('sendLocToStore', this.sendLocBackToChangeLocTile);
        /*added by mounika t to navigation through nav mixin */

        /*Added By Malhar to get store country from this.sendLocBackToChangeLocTile 1/12/2020 */
        if(this.sendLocBackToChangeLocTile == storeUSA){
            this.currentStorelocation = storeUSA;
            this.countryCurrencyCode = currencyCodeUSA;
        }else if(this.sendLocBackToChangeLocTile == storeCA || this.sendLocBackToChangeLocTile == storeCAF){
            this.currentStorelocation = storeCanada; 
            this.countryCurrencyCode = currencyCodeCanada;
        }

        console.log('this.currentStorelocation cart page connected callback > ' + this.currentStorelocation);
        /*Added By Malhar to get store country from this.sendLocBackToChangeLocTile 1/12/2020 */          


        /**27 Oct 2020: New Logic to Handle cartId in case of loggeduser && GuestUser*/
        if (this.isguestuser) {
            /*Modification by MALHAR - end - store toggling - 1/12/2020 */     
            this.getfooterbannerCookie('footerBanner');
            console.log('this.footerbannercookiestatus USC connected call > ' + this.footerbannercookiestatus);            

            if(this.footerbannercookiestatus){
                console.log('---------------------');
                if(this.currentStorelocation == storeUSA){
                    this.getCookie('cartId');
                    console.log('this.cartId US orderreview >>>>>> ' + this.cartId);                                                                                                
                }    
                else if(this.currentStorelocation == storeCanada){                  
                    this.getCookie('cartIdCA');
                    console.log('this.cartId CA orderreview >>>>>> ' + this.cartId);
                }
            }else if(typeof this.footerbannercookiestatus === "undefined"){                
                if(this.currentStorelocation == storeUSA){
                    //this.getCookie('cartId');
                    this.cartId = window.sessionStorage.getItem('cartId');
                    console.log('session storage CartId in case of Guest User for US store in connectd call metd of orderreview page===>', this.cartId);
                }    
                else if(this.currentStorelocation == storeCanada){
                    //this.getCookie('cartIdCA');
                    this.cartId = window.sessionStorage.getItem('cartIdCA');
                    console.log('session storage CartId in case of Guest User for CA store in connectd call metd of orderreview page===>', this.cartId);
                }                                
            } 

            console.log('CartId in case of Guest User USC PAGE ===>', this.cartId);
            this.getStatesDataFn();
            console.log('After calling getStatesData imperatively in Guest');
            this.callVertexAndFetchCartDetail();
        } else {
            fetchCartId({
                storeCountry : this.currentStorelocation
            })
                .then(result => {
                    console.log('CartId in case of loggedIn User fetchCartId in dbu_UserAndShippingInfo===>', result);
                    this.cartId = result;
                    console.log('this.CartId in case of loggedIn User USC PAGE ===>', this.cartId);
                    this.getStatesDataFn();
                    console.log('After calling getStatesData imperatively in loggedIn user');
                    this.callVertexAndFetchCartDetail();
                    this.error = undefined;
                })
                .catch(error => {
                    this.error = error.message;
                });
        }
        /*Modification by MALHAR - end - store toggling - 1/12/2020 */        
        /**Ended here */
        /*Shriram Code here for cart calculation Neet to use promise to do sync call*/
        // calculateTax({
        //     cartId: this.cartId
        // })
        //     .then(result11 => {
        //         console.log('tax calculation api call=>' + JSON.stringify(result11));

        //         updateCartAndCartItem({
        //             cartAndCartItem: JSON.stringify(result11)
        //         })
        //             .then(result111 => {
        //                 console.log('tax calculation updated in cart=>');
        //             })
        //             .catch(error1 => {
        //                 this.error = error1.message;
        //                 console.log('updateCartAndCartItem error.message'+error.message);
        //             });

        //     })
        //     .catch(error => {
        //         this.error = error.message;
        //         console.log('calculateTax error.message'+error.message);
        //     });
        ///////////////////////////////////
        
        /**Ended here */
        //this.handlegetShippingAmount();
    }

    /* to get states from custom metadata*/
    // @wire(getStatesData)
    // wiredgetStatesData({
    //     error,
    //     data
    // }) {
    //     if (data) {
    //         console.log('data from get states method>>' + JSON.stringify(data));
    //         this.statesMtData = data;
    //         if (this.statesMtData != '') {
    //             console.log('11111111111111111');
    //             this.handlefetchPickUpData();
    //         }
    //         this.error = undefined;
    //     } else if (error) {
    //         console.log('error>>>' + JSON.stringify(error));
    //         this.error = error;
    //         this.statePicklistValuesCA = undefined;
    //     }
    // }

    getStatesDataFn(){
        getStatesData()
            .then(data => {
                if (data) {
                            console.log('data from get states method>>' + JSON.stringify(data));
                            this.statesMtData = data;
                            if (this.statesMtData != '') {
                                console.log('11111111111111111');
                                this.handlefetchPickUpData();
                            }
                            this.error = undefined;
                        } else if (error) {
                            console.log('error>>>' + JSON.stringify(error));
                            this.error = error;
                            this.statePicklistValuesCA = undefined;
                        }
            })
            .catch(error => {
                this.isLoading = false;
                this.pickUpAddressData = undefined;
            });
    }


    handlefetchPickUpData() {
        console.log('dddddddddd');
        fetchPickUpData({ cartId: this.cartId })
            .then(data => {
                console.log('dddddddddd' +data);

                if (data && data.length > 0) {
                    console.log('data in pickup method>>' + JSON.stringify(data));
                    console.log('data in pickup method ccrz__Country__c0000>>' + JSON.stringify(data[0].dbu_Pick_Up_From_Store__r.ccrz__Country__c));
        
                    this.pickUpAddressData = data;
                    if (this.pickUpAddressData[0].dbu_Pick_Up_From_Store__rccrz__State__c !== '') {
                        this.pickUpStoreState = this.pickUpAddressData[0].dbu_Pick_Up_From_Store__r.ccrz__State__c;
                    }
                    if (this.pickUpAddressData[0].ccrz__ShipMethod__c === 'Pick Up' || this.pickUpAddressData[0].ccrz__ShipMethod__c === 'Ramassage') {
                        this.hideShippingAddress = true;
                        this.isPickup = true;
                    } else if (this.pickUpAddressData[0].ccrz__ShipMethod__c === 'Ship To Address' || this.pickUpAddressData[0].ccrz__ShipMethod__c === 'Adresse d\'expédition') {
                        this.hideShippingAddress = false;
                        this.isPickup = false;
                    }
                    if (this.pickUpAddressData[0].dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'United States') {
                        console.log('data in pickup method ccrz__Country__c>>' + JSON.stringify(this.pickUpAddressData[0].dbu_Pick_Up_From_Store__r.ccrz__Country__c));
        
                        this.pickUpCountry = 'U.S.A';
                    } else if (this.pickUpAddressData[0].dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'Canada') {
                        this.pickUpCountry = storeCanada;
                    }
                    if (this.pickUpStoreState != '') {
                        console.log('entering 11111' +this.statesMtData +'<<<<<<' +this.pickUpStoreState);
                        this.statesMtData.forEach(element => {
                            if (element.dbu_State__c == this.pickUpStoreState) {
                                this.pickUpStateCode = element.dbu_State_Code__c;
                            }
                        });
                        console.log('pickUpStateCode' +this.pickUpStateCode);
                    }
        
                } else if (error) {
                    this.error = error;
                    this.pickUpAddressData = undefined;
                }

            })
            .catch(error => {
                this.isLoading = false;
                this.pickUpAddressData = undefined;
            });
    }
	
    /* to get states from custom metadata*/

    // get goToPaymentURL(){
    //    let urlString = window.location.origin;
    //    return urlString+communityName+'payment?cartId='+this.cartId;
    // }

    handleClickGoToPayment(event) {
        this.isLoading = true;
        let urlString = window.location.origin;
        invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Navigate from review page to payment page', eventAction : 'Navigate to payment page'});
        let redirectToPaymentPage = urlString + communityName + 'payment?cartId=' + this.cartId + '&store=' + this.sendLocBackToChangeLocTile;
        console.log('sendLocBackToChangeLocTile n handle method' + this.sendLocBackToChangeLocTile);

                    //use local
                    window.localStorage.setItem('googleanalyticsOrderReview', true);

                    let gacoookieset = window.localStorage.getItem('googleanalyticsOrderReview');
                    console.log('gacoookieset > ' + gacoookieset);
                    
        window.location.href = redirectToPaymentPage;
        /*
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": redirectToPaymentPage
            }
        },
            true
        );*/
    }


    handleClickgoToCheckoutURL(event) {
        this.isLoading = true;
        console.log('sendLocBackToChangeLocTile n handle method' + this.sendLocBackToChangeLocTile +'>>>>>' +this.hideShippingAddress+'this.cartId' +this.cartId);
        invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Navigate from review page to checkout page', eventAction : 'Navigate back to checkout page'});
        let address = this.hideShippingAddress;
        let cartIDValue = this.cartId;

        setTimeout(function () {
            this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
            let urlString = window.location.origin;
            console.log('sendLocBackToChangeLocTile n handle method11' + this.sendLocBackToChangeLocTile +'>>>>>' +address+'this.cartId' +cartIDValue+'communityName' +communityName+'urlString'+urlString);
        window.location.href = urlString + communityName + 'checkout?cartId=' + cartIDValue + '&store=' + this.sendLocBackToChangeLocTile + '&pickupSelected=' + address;
        }, 6000);
    }

    get ScreenLoaded() {
        return this.isLoading;
    }

    @wire(fetchOrderDetails, { cartId: '$cartId' })
    wireOrderDetails({ error, data }) {
        if (data) {
           // this.isLoading = false;
            console.log('orderData>>>>>>>>>>', JSON.stringify(data));
            this.addressData = data;
            if (data.length > 0) {
                if (this.addressData[0].AddressList.length != 0 && this.addressData.length > 0) {
                    this.showShippingData = true;
                    this.isPickup = false;
                }
            }

            this.error = undefined;
        } else if (error) {
            console.log('error>>>>>>>>>>', error);
           // this.isLoading = false;
            this.error = error;
            this.addressData = undefined;
        }
    }

    

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

      /*handlegetShippingAmount() {
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
    }*/


    navigateToProductPage(event) {
        let prodName = event.target.getAttribute('data-name');
        let prodId =   event.target.getAttribute('data-id');
        if(prodName.includes(",")){
            prodName =  prodName.replace(/,/g, '-').toLowerCase();
        }
        if(prodName.includes(" ")){
            prodName =  prodName.replace(/\s+/g, '-').toLowerCase();
        }

        if(prodName.includes(" ")){
            prodName = prodName.replace(/\s+/g, '-').toLowerCase();
          }        
          window.localStorage.setItem('googleanalyticsOrderReview', false);
          
        if(prodName.includes('/')){
        prodName = prodName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
        }  


          
        let urlString = window.location.origin;
				let redirectURL =  urlString + communityName +'product/'+prodId +'/'+ prodName;
       // let redirectURL = urlString + communityName + 'product?name=' + prodName + '&pId=' + prodId + '&store=' + this.sendLocBackToChangeLocTile;
        window.location.href = redirectURL;
        /*
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": redirectURL
            }
        });*/

    }

    isVertexCallError = true;//INC2628005 - CTS CHANGES
    isVertexCallErrorMsg = false;
    isVertexerror = false;
    callVertexAndFetchCartDetail() {
        console.log('Just calling callVertexAndFetchCartDetail method==' + this.cartId);
        try {
            calculateTax({
                    cartId: this.cartId
                }).then(result11 => {
                    console.log('tax calculation api call=>' + JSON.stringify(result11));
                    //INC2628005 - CTS CHANGES
                    if (result11.taxStatus == 'Error') {
                        this.isVertexCallError = true;
                        this.isVertexCallErrorMsg = true;
                        this.isVertexerror = true;
                    }
                    updateCartAndCartItem({
                            cartAndCartItem: JSON.stringify(result11)
                        }).then(result111 => {
                            console.log('tax calculation updated in cart=>');
                            if (result111 == true && this.isVertexerror === false) {
                                this.isVertexCallError = false;
                                this.isVertexCallErrorMsg = false;
                            } else {
                                this.isVertexCallError = true;
                                this.isVertexCallErrorMsg = true;
                            }
                            /**Going to make imperative call to fetch cart details */
                            fetchLstCartItemsByCartId({
                                    cartId: this.cartId,
                                    cart: ''
                                }).then(data => {
                                    if (data && data.length > 0) {
                                        console.log('Going to make Imperative call CartId============', this.cartId);
                                        console.log(data);
                                        window.console.log('Cart data>>>>>>>>', data);
                                        this.cartDetails = data;
                                        //this.isLoading = false;
                                        //************* code with decimals and currency starts*/

                                        let localcartOriginalAmount = this.cartDetails[0].originalCartAmt;
                                        localcartOriginalAmount = ((Math.round(localcartOriginalAmount * 100) / 100).toFixed(2)) * 1;

                                        let localcartSubtotalAmount = this.cartDetails[0].subtotalAmount;
                                        localcartSubtotalAmount = ((Math.round(localcartSubtotalAmount * 100) / 100).toFixed(2)) * 1;

                                        let localcartTotalAmount = this.cartDetails[0].totalAmount;
                                        localcartTotalAmount = ((Math.round(localcartTotalAmount * 100) / 100).toFixed(2)) * 1;

                                        let localcartDiscountAmount = this.cartDetails[0].totalCartDiscount;
                                        localcartDiscountAmount = ((Math.round(localcartDiscountAmount * 100) / 100).toFixed(2)) * 1;

                                        let localcartTaxAmount = this.cartDetails[0].taxAmount;
                                        localcartTaxAmount = ((Math.round(localcartTaxAmount * 100) / 100).toFixed(2)) * 1;

                                        /*For currency code related*/
                                        let cartdata = JSON.stringify(data);
                                        this.cartDetails = JSON.parse(cartdata);
                                        this.cartDetails.forEach(element => {
                                            element.lstCartItem.forEach(item => {
                                                let currentRetPrice = item.cartItem.ccrz__Price__c;
                                                item['formatedUnitPrice'] = perfixCurrencyISOCode(this.countryCurrencyCode, currentRetPrice);

                                                let localCartSubtotalLineItem = item.cartItem.ccrz__SubAmount__c;
                                                localCartSubtotalLineItem = ((Math.round(localCartSubtotalLineItem * 100) / 100).toFixed(2)) * 1;
                                                item['formatedSubTotal'] = perfixCurrencyISOCode(this.countryCurrencyCode, localCartSubtotalLineItem);
                                            })
                                        });
                                        /*ended here*/
                                        if (this.cartDetails[0].originalCartAmt != null) {
                                            this.cartOriginalAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartOriginalAmount);
                                        }

                                        if (this.cartDetails[0].totalCartDiscount != null) {
                                            console.log('entering the discount loop if part>>>' + localcartDiscountAmount);
                                            this.cartDiscountAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartDiscountAmount);
                                        }

                                        if (this.cartDetails[0].subtotalAmount != null) {
                                            console.log('this.cartDetails[0].subtotalAmount' + this.cartDetails[0].subtotalAmount);
                                            this.cartSubtotalAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartSubtotalAmount);
                                        }
                                        if (this.cartDetails[0].totalAmount != null) {
                                            this.cartTotalAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartTotalAmount);
                                        }
                                        if (this.cartDetails[0].taxAmount != null) {
                                            this.cartTaxAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartTaxAmount);
                                        }
                                        //shippingAmount
                                        console.log('test');
                                        console.log('shipping Amount ', this.cartDetails[0].shippingAmount);
                                        this.cartShipAmount = perfixCurrencyISOCode(this.countryCurrencyCode, this.cartDetails[0].shippingAmount);
                                        //************* code with decimals and currency ends*/
                                        this.error = undefined;
                                        console.log('Cart data222222>>>>>>>>' + JSON.stringify(this.cartDetails));
                                        invokeGoogleAnalyticsService('ORDER REVIEW CHECKOUT', this.cartDetails);
                                        //this.isLoading = false;
                                    } else if (error) {
                                        this.error = error;
                                        this.cartDetails = undefined;
                                    }
                                }).catch(error => {
                                    this.error = error.message;
                                });
                        }).catch(error1 => {
                            this.error = error1.message;
                            console.log('updateCartAndCartItem error.message' + error.message);
                        });
                }).catch(error => {
                    this.error = error.message;
                    console.log('calculateTax error.message' + error.message);
                });
        } catch (error) {
            this.isVertexCallError = true;
            this.isVertexCallErrorMsg = true;
        } finally {
            setTimeout(() => {
                this.isLoading = false;
            }, 4000);
        }
    }
}