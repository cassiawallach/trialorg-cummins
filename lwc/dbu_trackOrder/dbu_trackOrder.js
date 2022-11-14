import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
import getOrderList from '@salesforce/apex/dbu_trackOrder.getOrderList';
import getLoggedInUserInfo from '@salesforce/apex/dbu_LoggedInUserinfo.getLoggedInUserInfo';
import communityName from '@salesforce/label/c.dbu_communityName';
import signInURL from '@salesforce/label/c.dbu_login_URL';
import checkingGenuineProduct from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.checkingGenuineProduct';
import OrderStatusDelivered from '@salesforce/label/c.dbu_OrderStatusDelivered';
import OrderStatusPickedUp from '@salesforce/label/c.Dbu_OrderStatusPickedUp';
import OderReturnExceptionMsg from '@salesforce/label/c.dbu_OderReturnExceptionMsg';
import {
    NavigationMixin
} from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//---Importing service component for CurrencyCode prefix--
import { perfixCurrencyISOCode,createCookiesData } from 'c/serviceComponent';
//----Importing Custom labels--
import trackOrderViewYourOrder from "@salesforce/label/c.trackOrderViewYourOrder";
import trackOrderSignIn from "@salesforce/label/c.trackOrderSignIn";
import trackOrderOrderNumber from "@salesforce/label/c.trackOrderOrderNumber";
import trackOrderNumberPlaceHolder from "@salesforce/label/c.trackOrderNumberPlaceHolder";
import trackOrderEmailAddress from "@salesforce/label/c.trackOrderEmailAddress";
import trackOrderEmailPlaceHolder from "@salesforce/label/c.trackOrderEmailPlaceHolder";
import trackOrderViewBtnLabel from "@salesforce/label/c.trackOrderViewBtnLabel";
import dbu_DefaultProductImage from "@salesforce/label/c.dbu_DefaultProductImage";
import trackOrderYourOrder from "@salesforce/label/c.trackOrderYourOrder";
import trackOrderReturnOrder from "@salesforce/label/c.trackOrderReturnOrder";
import trackOrderPrint from "@salesforce/label/c.trackOrderPrint";
import trackOrderViewInvoice from "@salesforce/label/c.trackOrderViewInvoice";
import trackOrderClose from "@salesforce/label/c.trackOrderClose";
import dbu_US_Return_Order from '@salesforce/label/c.dbu_US_Return_Order';//Ramesh
import dbu_CAD_Return_Order from '@salesforce/label/c.dbu_CAD_Return_Order';//Ramesh
import trackOrderEmailAndOrderNumberError from "@salesforce/label/c.trackOrderEmailAndOrderNumberError";
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

export default class Dbu_trackOrder extends NavigationMixin(LightningElement) {

    @track orderId;
    @track addressDetails;
    @track cartDetails;
    @track shippingaddressDetails;
    @track lstOrder;
    @track orderName = '';
    @track email = '';
    @track ordrDetails = [];
    @track error;
    @track isLoading = true;
    @track IsCustomerLoggedIn;
    @track SignInURL = signInURL;
    @track ordersummary;
    @track currencyValue = 'USD';
  //  @track isReturnInitiated = false;
  //  @track isOrderItemSubmitted = false;
    sVal = 'orderName';
    @api pickup = false;
    @api shipping = false;
    @track hidedata = false;
    @track relatedProductMap = new Map();
    @track screenLoaded = false;
    @track isInvoicecrd;
    @track sendLocBackToChangeLocTile;
    @track currencyCode;
    @track totalOrderQty =0;
    @track dbu_US_Return_Order = dbu_US_Return_Order;//Ramesh
    @track dbu_CAD_Return_Order = dbu_CAD_Return_Order;//Ramesh

    label = {
        OderReturnExceptionMsg,
        dbu_DefaultProductImage,
        trackOrderViewYourOrder,
        trackOrderSignIn,
        trackOrderOrderNumber,
        trackOrderNumberPlaceHolder,
        trackOrderEmailAddress,
        trackOrderEmailPlaceHolder,
        trackOrderViewBtnLabel,
        trackOrderYourOrder,
        trackOrderReturnOrder,
        trackOrderPrint,
        trackOrderViewInvoice,
        trackOrderClose,
        trackOrderEmailAndOrderNumberError
    };

    connectedCallback() {
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        console.log('==Country===' + url.searchParams.get("store"));
        this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
    }

    @wire(getLoggedInUserInfo)
    wirefetchuser({
        error,
        data
    }) {
        if (data) {
            this.IsCustomerLoggedIn = data;
        } else if (error) {
            this.error = error;
            this.IsCustomerLoggedIn = undefined;

        }
    }

    updateSeachKey(event) {
        if (event.target.name == "orderid") {
            this.orderName = event.target.value;
        }
        if (event.target.name == "email") {
            this.email = event.target.value;
        }
    }

    handleReturnOrderBtn(event){
        console.log('function called');
        const returnedQty = event.detail;
       console.log('==totalOrderQty=='+this.totalOrderQty);
       console.log('==returnedQty=='+returnedQty);
        if(this.totalOrderQty === returnedQty){
            this.isOrderStatusSuccess = true;
        }
    }


    @track orderStatusCheck;
    handleClickViewOrder() {
        this.lstOrder = undefined;
        //---Field Validation---Added by Mukesh Gupta --(23-12-2020)--------
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        //----------------------
        if (this.email != '' && this.orderName != '') {
            this.screenLoaded = true;
            invokeGoogleAnalyticsService('TRACK ORDER USER INPUT', {OrderNumber : this.orderName, orderEmail : this.email});
            getOrderList({
                orderName: this.orderName,
                email: this.email
            })
                .then(result => {

                    //---Display toast if Order number or Email is incorrect---Added by Mukesh Gupta --(23-12-2020)--------
                    if (result.length === 0) {
                        this.screenLoaded = false;
                        const evt = new ShowToastEvent({
                            title: 'Error',
                            message: trackOrderEmailAndOrderNumberError,
                            variant: 'error',
                            mode: 'dismissable'
                        });
                        this.dispatchEvent(evt);
                        return;
                    }

                    // Security changes , added by Ranadip

                    let orderSfid = result[0].sfid;
                    createCookiesData(orderSfid);
                    
                    // end here


                    //----------------------------
                    console.log('===Length===' + result.length);
                    
                    this.lstOrder = result;
                    console.log('result from getOrderList',JSON.parse(JSON.stringify(this.lstOrder)));
                    //----Get currencyISOCode -- Added by Mukesh Gupta (18-01-2021)----------------------------------
                    this.currencyCode = this.lstOrder[0].currencyISOCode;
                    this.isInvoicecrd = this.lstOrder[0].isInvoiceCreated;//added by Ranadip on 01/12/20
                    //added by MV
                    if (this.lstOrder[0].dbupickupAddress != null && this.lstOrder[0].dbupickupAddress != undefined) {
                        this.pickup = true;
                    }
                    else {
                        this.shipping = true;
                    }
                    let i = 0;
                    let orderdetail = [];
                    if (this.lstOrder.length != 0 || this.lstOrder.length != undefined) {
                        for (i = 0; i < this.lstOrder.length; i++) {
                            let orderdata = {};
                            let items = this.lstOrder[0].items;
                            orderdata['items'] = perfixCurrencyISOCode(this.currencyCode, items);
                            let totalDiscount = this.lstOrder[0].totalDiscount;
                            orderdata['totalDiscount'] = perfixCurrencyISOCode(this.currencyCode, totalDiscount);
                           // let subtotalAmount = this.lstOrder[0].subtotalAmount;
                           let subtotalAmount = ((Math.round(this.lstOrder[0].subtotalAmount * 100) / 100).toFixed(2))*1;
                            orderdata['subtotalAmount'] = perfixCurrencyISOCode(this.currencyCode, subtotalAmount);
                            let taxAmount = this.lstOrder[0].taxAmount;
                            orderdata['taxAmount'] = perfixCurrencyISOCode(this.currencyCode, taxAmount);
                            let shipAmount = this.lstOrder[0].shipAmount;
                            orderdata['shipAmount'] = perfixCurrencyISOCode(this.currencyCode, shipAmount);
                            let totalAmount = this.lstOrder[0].totalAmount;
                            orderdata['totalAmount'] = perfixCurrencyISOCode(this.currencyCode, totalAmount);

                            orderdetail.push(orderdata);
                        }
                    }
                    console.log('orderdetail' + JSON.stringify(orderdetail));
                    this.ordersummary = orderdetail;
                    let orderrecordarray = [];
                    if (this.lstOrder[0].productlist.length != null || this.lstOrder[0].productlist.length != undefined) {
                        this.orderStatusCheck = this.lstOrder[0].orderStatus;
                        this.orderId = this.lstOrder[0].sfid;
                      //  var countOrderItems = 0;
                      //  var countSubmittedOrderItems = 0;
                      //  var countTotalOrderItems = 0;

                        //-------Code added by Mukesh ----
                        var productMap = new Map();
                        //-------- Adding related products in Map
                        if (this.lstOrder[0].relatedProducts.length) { // added by Ranadip
                            for (let i = 0; i < this.lstOrder[0].relatedProducts.length; i++) {
                                this.relatedProductMap.set(this.lstOrder[0].relatedProducts[i].ccrz__Product__c, this.lstOrder[0].relatedProducts[i]);
                            }
                        }
                        //-------- Adding products in Map

                        for (let i = 0; i < this.lstOrder[0].productlist.length; i++) {
                            productMap.set(this.lstOrder[0].productlist[i].sfid, this.lstOrder[0].productlist[i]);
                        }

                        //------- Iterating on Order line item list
                        for (let i = 0; i < this.lstOrder[0].EOrderItemsS.length; i++) {
                            let orderrecord = {};
                            if (productMap.has(this.lstOrder[0].EOrderItemsS[i].prodId)) {
                                orderrecord['sfdcName'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).sfdcName;
                                if(productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).promotionTag != undefined)
                                    orderrecord['promotionTag'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).promotionTag;
                                if (productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).EProductMediasS[0] !== undefined) {
                                    orderrecord['URI'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).EProductMediasS[0].URI;
                                } else {
                                    orderrecord['URI'] = dbu_DefaultProductImage;
                                }

                                orderrecord['id'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).sfid;
                            }
                            orderrecord['quantity'] = this.lstOrder[0].EOrderItemsS[i].quantity;
                            let price = this.lstOrder[0].EOrderItemsS[i].price;
                            orderrecord['price'] = perfixCurrencyISOCode(this.currencyCode, price);
                            orderrecord['subAmount'] = this.lstOrder[0].EOrderItemsS[i].subAmount;
                            orderrecord['orderItemStatus'] = this.lstOrder[0].EOrderItemsS[i].orderItemStatus;
                            if (productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).hasCoreCharge === true && productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).dbuHasCoreChild === true) {
                                orderrecord['coreCharge'] = true;
                            }
                            // if (this.lstOrder[0].EOrderItemsS[i].orderItemStatus == 'Return Initiated') {
                            //     countOrderItems++;
                            // }
                            if (this.lstOrder[0].EOrderItemsS[i].orderItemStatus == 'Shipped' || this.lstOrder[0].EOrderItemsS[i].orderItemStatus == 'Available for Pickup' || this.lstOrder[0].EOrderItemsS[i].orderItemStatus === 'Commande expédiée' || this.lstOrder[0].EOrderItemsS[i].orderItemStatus === 'Prête pour le ramassage') {
                                this.totalOrderQty = this.totalOrderQty + this.lstOrder[0].EOrderItemsS[i].quantity;
                              //  countSubmittedOrderItems++;
                            }
                            // if (this.lstOrder[0].EOrderItemsS[i].sfid !== null || this.lstOrder[0].EOrderItemsS[i].sfid !== undefined) {
                            //     countTotalOrderItems++;
                            // }
                           
                            if ((this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Abandoned' && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== undefined &&
                                this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Rejected' && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Initiated' &&
                                this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Requested' && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Approved' &&
                                this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Refunded') && (this.lstOrder[0].EOrderItemsS[i].dbuIsReturned === false)) {
                                    console.log('====isReturned==='+this.lstOrder[0].EOrderItemsS[i].dbuIsReturned);
                                orderrecordarray.push(orderrecord);
                            }
                        }

                        //------Push records in array in sequence if core product exist----------//
                        let itemInSequence = [];
                        for (let i = 0; i < orderrecordarray.length; i++) {
                            if (orderrecordarray[i].parentCoreCharge) {
                                let relatedCoreProdId = this.relatedProductMap.get(orderrecordarray[i].id).ccrz__RelatedProduct__c;
                                itemInSequence.push(orderrecordarray[i]);
                                for (let j = 0; j < orderrecordarray.length; j++) {
                                    if (orderrecordarray[j].id === relatedCoreProdId) {
                                        itemInSequence.push(orderrecordarray[j]);
                                    }
                                }
                            } else {
                                itemInSequence.push(orderrecordarray[i]);
                            }
                        }
                        //---- Removing duplicates records from itemInSequence array
                        var itemsArray = [...new Set(itemInSequence)];
                        //----------------------------------------------------------------------//

                        // if (countOrderItems === countTotalOrderItems) {
                        //     this.isReturnInitiated = true;
                        // } else {
                        //     this.isReturnInitiated = false;
                        // }

                        // if (countSubmittedOrderItems === countTotalOrderItems) {
                        //     this.isOrderItemSubmitted = true;
                        // } else {
                        //     this.isOrderItemSubmitted = false;
                        // }

                        if (this.orderStatusCheck !== null || this.orderStatusCheck !== undefined) {
                            this.checkorderStatus();
                        } 
                    }
                    this.cartDetails = itemsArray;
                    this.screenLoaded = false;
                    console.log('this.cartDetails > ' + JSON.stringify(this.cartDetails));
                    console.log('this.lstOrder > ' + JSON.stringify(this.lstOrder));
                    //invokeGoogleAnalyticsService('TRACK ORDER RESULTS', {orderinformation : this.lstOrder, orderhistorydetail : 'Track Order', currencycode : this.currencyCode});

                })
                .catch(error => {
                    this.error = error;
                    console.log('error=>>' + this.error);
                    this.screenLoaded = false;
                })
        }
    }
    printPage() {
        window.print();
    }
    @track flag = true;
    @track cadReturnOrder = true; //ramesh  CHG0106272 
    @track usReturnOrder  = true; //ramesh  CHG0106272 
    @track isGenuineOrder = false;
    openModelForReturnParts(event) {
        // to open modal set isModalOpen tarck value as true
        checkingGenuineProduct({
            orderid: this.orderId
        })
            .then(result => {
                window.console.log('checkingGenuineProduct ' + result);
                //ramesh code start CHG0106272
                var currencyCodeStore = '';
                if((window.sessionStorage.getItem('setCountryCode') ==='EN') || (window.sessionStorage.getItem('setCountryCode') ==='FR')){
                    var currencyCodeStore = 'CAD';
                }else {
                    var currencyCodeStore = 'USD';
                }
                if((this.currencyCode != currencyCodeStore) && result == true) {
                    this.isOpenModelForReturnParts = true;
                    if(this.currencyCode == 'CAD'){ 
                        this.cadReturnOrder = false;
                    }else {
                        this.usReturnOrder = false;
                    }  //ramesh code ends  CHG0106272
                }else if (result == true) {
                    this.isGenuineOrder = true;
                    this.navigateToWebPage();
                } else if (result == false) {
                    this.isOpenModelForReturnParts = true;
                    this.flag = false;
                }
            })
            .catch(error => {
                this.error = error.message;
            });
    }

    navigateToWebPage() {
        let urlString = window.location.origin;
        invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Proceed for refund method select', eventAction : 'Navigate from track order page to select parts return page'});                
        let urls = urlString + communityName + 'returns-parts?orderid=' + this.orderId + '&store=' + this.sendLocBackToChangeLocTile;
        console.log('urls ', urls);
        window.location.href = urls;
        /*
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": urls
            }
        });*/
    }

    @track isOrderStatusSuccess = true;
    checkorderStatus() {
        // if (((this.orderStatusCheck == OrderStatusDelivered || this.orderStatusCheck == OrderStatusPickedUp) && this.isReturnInitiated === true) || (this.orderStatusCheck == 'Order Submitted' && this.isOrderItemSubmitted == true)) {
        //     this.isOrderStatusSuccess = true;
        // } else {
        //     this.isOrderStatusSuccess = false;
        // }
        if(this.orderStatusCheck === 'Shipped' || this.orderStatusCheck === 'Available for Pickup' ||  this.orderStatusCheck === 'Commande expédiée' || this.orderStatusCheck === 'Prête pour le ramassage'){
            this.isOrderStatusSuccess = false;
           }else{
            this.isOrderStatusSuccess = true;
           }
    }

    closeModelForReturnParts() {
        // to close modal set isModalOpen tarck value as false
        this.isOpenModelForReturnParts = false;
        this.flag = true;
        this.usReturnOrder = true; //ramesh  CHG0106272 
        this.cadReturnOrder = true; //ramesh  CHG0106272 
    }
    //added by Ranadip on 01/12/2020
    navigateToInvoicePage() {
        let urlString = window.location.origin;
        let urls = urlString + communityName + 'invoice?orderid=' + this.orderId + '&store=' + this.sendLocBackToChangeLocTile;
        window.open(urls);
    }


    
}