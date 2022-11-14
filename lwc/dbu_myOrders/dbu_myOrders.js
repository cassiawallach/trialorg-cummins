import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
import fetchOrders from '@salesforce/apex/dbu_myOrders.fetchOrders';
import fetchOrderDetail from '@salesforce/apex/dbu_myOrders.fetchOrderDetail';
import fetchOrderItemsBasedonInput from '@salesforce/apex/dbu_myOrders.fetchOrderItemsBasedonInput';
import searchicon from '@salesforce/resourceUrl/HeaderSearchIcon';
import pubsub from 'c/pubsub';
import orderFilter from '@salesforce/apex/dbu_myOrders.orderFilter';
import callReturnOrderAPI from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.callReturnOrderAPI';
import communityName from '@salesforce/label/c.dbu_communityName';
import OrderStatusDelivered from '@salesforce/label/c.dbu_OrderStatusDelivered';
import OrderStatusPickedUp from '@salesforce/label/c.Dbu_OrderStatusPickedUp';
import OderReturnExceptionMsg from '@salesforce/label/c.dbu_OderReturnExceptionMsg';
import checkingGenuineProduct from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.checkingGenuineProduct';
import Checkcreateengine from '@salesforce/apex/dbu_ProductCtrl.Checkcreateengine';

import dbu_myOrders_OrderNumber from '@salesforce/label/c.dbu_myOrders_OrderNumber';
import dbu_myOrders_Order_Date from '@salesforce/label/c.dbu_myOrders_Order_Date';
import dbu_myOrders_Amount from '@salesforce/label/c.dbu_myOrders_Amount';
import dbu_myOrders_Status from '@salesforce/label/c.dbu_myOrders_Status';
import dbu_myOrders_BacktoOrders from '@salesforce/label/c.dbu_myOrders_BacktoOrders';
import dbu_myOrders_ReturnOrder from '@salesforce/label/c.dbu_myOrders_ReturnOrder';
import dbu_myOrders_ViewInvoice from '@salesforce/label/c.dbu_myOrders_ViewInvoice';
import dbu_myOrders_Print from '@salesforce/label/c.dbu_myOrders_Print';
import dbu_myOrders_Close from '@salesforce/label/c.dbu_myOrders_Close';
import dbu_US_Return_Order from '@salesforce/label/c.dbu_US_Return_Order';//Ramesh
import dbu_CAD_Return_Order from '@salesforce/label/c.dbu_CAD_Return_Order';//Ramesh
import dbu_myOrders_RequestMessage from '@salesforce/label/c.dbu_myOrders_RequestMessage';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent'; 
import {
    NavigationMixin
} from 'lightning/navigation';
//import getOrderList from '@salesforce/apex/dbu_trackOrder.getOrderList';
import dbu_DefaultProductImage from "@salesforce/label/c.dbu_DefaultProductImage";
//---Importing service component for CurrencyCode prefix--
import {perfixCurrencyISOCode} from 'c/serviceComponent';

export default class Dbu_myOrders extends NavigationMixin(LightningElement) {
    iconsearch = searchicon + '#searchIcon';

    @track dbu_myOrders_OrderNumber = dbu_myOrders_OrderNumber;
    @track dbu_myOrders_Order_Date = dbu_myOrders_Order_Date;
    @track dbu_myOrders_Amount = dbu_myOrders_Amount;
    @track dbu_myOrders_Status = dbu_myOrders_Status;
    @track dbu_myOrders_BacktoOrders = dbu_myOrders_BacktoOrders;
    @track dbu_myOrders_ReturnOrder = dbu_myOrders_ReturnOrder;
    @track dbu_myOrders_Print = dbu_myOrders_Print;
    @track dbu_myOrders_ViewInvoice = dbu_myOrders_ViewInvoice;
    @track dbu_myOrders_Close = dbu_myOrders_Close;
    @track dbu_US_Return_Order = dbu_US_Return_Order;//Ramesh
    @track dbu_CAD_Return_Order = dbu_CAD_Return_Order;//Ramesh
    @track dbu_myOrders_RequestMessage = dbu_myOrders_RequestMessage;


    @track getOrders;
    inputValue = '';
    @track orderId = '';
    @track detailView = false;
    @track cartDetails;
    @track orderDetails;
    @track myOrders;
    @track addressDetails;
    @track shippingaddressDetails;
    @track productDetails;
    @track isLoading = true;
    @track orderSelectedDetails;
    @track orderdataBasedonInput;
    @track orderTimeInterval = '999';
    @track orderStatus = 'allorderstatus';
    @track orderSearchText;
    @track orderStatusCheck;
    @track createngine = false;
  //  @track isReturnInitiated = false;
   // @track isOrderItemSubmitted = false;
    @track ordersummary;
    @track storeLocationText = 'en-US';
    @track currencyValue = 'USD';
    @track selectedAmt;
    @track selectedDate;
    @track myorderDetails;
    @api pickup = false;
    @api shipping = false;
    @api lstOrder;
    @track relatedProductMap=new Map();
    @track isInvoicecrd;
    @track sendLocBackToChangeLocTile;
    @track showTable = true;

    // @track currencyUSD = {
    //     minimumFractionDigits: 2,
    //     maximumFractionDigits: 2,
    //     style: 'currency',
    //     currency: 'USD'
    // };
    // @track currencyCAD = {
    //     minimumFractionDigits: 2,
    //     maximumFractionDigits: 2,
    //     style: 'currency',
    //     currency: 'CAD'
    // };
    @track currencyCode;

    get ScreenLoaded() {
        return this.isLoading;
    }

    label = {
        OderReturnExceptionMsg,
        dbu_DefaultProductImage
    };

    connectedCallback() {
       // document.title = 'Testing Title';
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');

        this.register();

        //let urlString = window.location.origin;

        //this.goToViewInvoiceURL = urlString+communityName+'invoice?orderid=a2V19000001ANhCEAW';
        // this.goToViewInvoiceURL = urlString+communityName+'invoice?orderid ='+ this.orderId;
    }

    get InvoiceURL() {

        let urlString = window.location.origin;
        //return urlString+communityName+'product?pId='+this.product.Id;
        return urlString + communityName + 'invoice?orderid=' + this.orderId;
    }
    get SelectedItemsURL() {

        let urlString = window.location.origin;
        //return urlString+communityName+'product?pId='+this.product.Id;
        return urlString + communityName + 'OderItems?orderid=' + this.orderId;
    }

    register() {
        window.console.log('event registered ');
        pubsub.register('searchorederevt', this.handleOrderEvent.bind(this));

    }
    handleOrderEvent(event) {
        if(event.length > 0){
            this.showTable = true;
            this.showError = false;
        console.log('event Handled>>>>>>>>>>>', event);
        this.myOrders = event;
        //this.myorderDetails = event;
       
        let orderdetail = [];
        for (let i = 0; i < event.length; i++) {
           // debugger;
           let currencyISOCode =  event[i].orderRecord.ccrz__CurrencyISOCode__c;
           console.log('Event ISO CODE ==='+currencyISOCode);
            let orderdata = {};
            console.log(event[i]);
            let Amt = event[i].orderRecord.ccrz__TotalAmount__c;
            console.log('==Amt=='+Amt);
            orderdata['orignalAmount'] = event[i].orderRecord.ccrz__TotalAmount__c;
            console.log('Total===='+event[i].orderRecord.ccrz__TotalAmount__c);
            if (Amt != null && Amt != undefined) {
                orderdata['selectedAmt'] = perfixCurrencyISOCode(currencyISOCode,Amt);
                // orderdata['selectedAmt'] = Amt.toLocaleString(this.storeLocationText, {
                //     style: 'currency',
                //     currency: this.currencyValue,
                //     minimumFractionDigits: 2,
                //     maximumFractionDigits: 2
                // });
               // orderdata['selectedAmt'] = perfixCurrencyISOCode(this.currencyCode,Amt);
                /*this.selectedAmt = Amt.toLocaleString(this.storeLocationText, {
                        style: 'currency',
                        currency: this.currencyValue,
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2
                    });
                }*/
                //console.log('Ids==========' + event[i].Id);
                //console.log('sfId==========' + event[i].sfid);
                orderdata['status'] = event[i].orderRecord.ccrz__OrderStatus__c;
                orderdata['Name'] = event[i].orderRecord.Name;
                orderdata['Id'] = event[i].orderRecord.Id;

                // let dateVal = event[i].ccrz__OrderDate__c;
                // let date = new Date(dateVal);
                // let dtOptions = {
                //     year: 'numeric',
                //     month: 'long',
                //     day: '2-digit'
                // };
                orderdata['selectedDate'] = event[i].orderDate;
             //   console.log('dateval++++++' + date.toLocaleString('en-US', dtOptions));
                // console.log('selecteddate*******', this.selectedDate);  
                orderdetail.push(orderdata);
            }
        }
            this.myorderDetails = orderdetail;
            console.log('orderdetail*******', orderdetail);
            this.clearSorting();
         }else{
             console.log('In ELSE block');
             this.showError = true;
             this.displayError = 'No Record Found';
             this.showTable = false;
            // this.myorderDetails = [];
             
         }
    }



    //@track  orderrecordarray = [];



    get orderStatusOption() {
        return [{
                label: 'All order status',
                value: 'allorderstatus'
            },
            {
                label: 'Order Submitted',
                value: 'Order Submitted'
            },
           
        
           
         
          
            {
                label: 'Available for Pickup',
                value: 'Available for Pickup'
            },
            
              {
                label: 'Shipped',
                value: 'Shipped'
            },
            {
                label: 'Delivered',
                value: 'Delivered'
            }
           

        ];
    }
    get sortDays() {
        return [
            {
                label: 'All',
                value: '999'
            },
            {
                label: 'Last 3 month',
                value: '3'
            },
            {
                label: 'Last 6 months',
                value: '6'
            },

            {
                label: 'Last 1 Year',
                value: '12'
            }
        ];
    }
    @track showError = false;
    @track displayError;
    onOrderSearch(event) {
        if(this.inputValue === undefined || this.inputValue === ''){
            this.showError = true;
            this.displayError = 'Please give some input to search...';
            return;
        }
        this.isLoading = true;
        this.showError = false;
       // this.orderSearchText = event.target.value;
      //  console.log('onProductDelete event.target.dataset.id=======>' + event);
      //  console.log('orderSearchText event.target.value=======>' + event.target.value);
        orderFilter({
                //cartItemId : event.target.dataset.id,
                //cartId : this.cartId
                orderSearchText: this.inputValue,
                orderStatus: this.orderStatus,
                orderTimeInterval: this.orderTimeInterval


            })
            .then(result => {
                console.log('result===='+result.length);
               
                // Clear the user enter values
                window.console.log('In onProductDelete before fire eventresult ===> ' + Object.keys(result));
                //this.createCookie('In onProductDelete cartId', result[0].cartId, 1);
                pubsub.fire('searchorederevt', result);
                window.console.log('After fire eventresult ===> ' + result);
               
                this.isLoading = false;

            })
            .catch(error => {
                console.log('IN CATCH BLOCK');
                this.error = error.message;
            });
    }
    //method to filter order status

    onOrderFilterStatus(event) {
        console.log('===ChangeValue=='+event.target.value);
        this.myorderDetails = [];
        this.isLoading = true;
        this.orderStatus = event.target.value;
        console.log('onProductDelete event.target.dataset.id=======>' + event);
        console.log(event.target.value);
        console.log(this.inputValue);
        console.log(this.orderTimeInterval);
        orderFilter({
                //cartItemId : event.target.dataset.id,
                //cartId : this.cartId
                orderSearchText: this.inputValue,
                orderStatus: event.target.value,
                orderTimeInterval: this.orderTimeInterval


            })
            .then(result => {
                // Clear the user enter values
                window.console.log('In onProductDelete before fire eventresult ===> ' + result);
                //this.createCookie('In onProductDelete cartId', result[0].cartId, 1);
                pubsub.fire('searchorederevt', result);
                window.console.log('After fire eventresult ===> ' + result);
                this.isLoading = false;

            })
            .catch(error => {
                this.error = error.message;
            });
    }

    //method to filter by Time

    onOrderFilterTime(event) {
        this.myorderDetails = [];
        this.isLoading = true;
        console.log('orderfilter event=======>' + event);
        this.orderTimeInterval = event.target.value;
        console.log('orderfiltertime event.target.value=======>' + event.target.value);

        orderFilter({
                //cartItemId : event.target.dataset.id,
                //cartId : this.cartId
                orderSearchText: this.inputValue,
                orderStatus: this.orderStatus,
                orderTimeInterval: event.target.value


            })
            .then(result => {
                // Clear the user enter values
                window.console.log('In onProductDelete before fire eventresult ===> ' + result);
                //this.createCookie('In onProductDelete cartId', result[0].cartId, 1);
                pubsub.fire('searchorederevt', result);
                window.console.log('After fire eventresult ===> ' + result);
                this.isLoading = false;

            })
            .catch(error => {
                this.error = error.message;
            });
    }


@track totalOrderQty = 0;

    handleClickOrderNumber(event) {
        console.log('orderId>>>>>>>>>>' + this.orderId); 
        this.isLoading = true;
        var productMap = new Map(); 
        // if search input value is not blank then call apex method, else display error msg 
        // if (this.sVal !== '') {
        // console.log('dataIdfromattribute'+event.target.getAttribute('data-orderid'));
        this.orderId = event.target.getAttribute('data-orderid');
        console.log('orderId>>>>>>>>>>' + this.orderId); 
        fetchOrderDetail({

                //: this.sVal
                //lstOrder:this.lstOrder,
                orderId: this.orderId

                //orderName:this.orderName,
                //email:this.email
            })
            .then(result => {
                this.isLoading = false; 
                this.detailView = true;
                this.lstOrder = result;
                //---Added for country currency change---
                this.currencyCode = this.lstOrder[0].currencyISOCode; 
                console.log('result from order ', JSON.stringify(result));
                console.log('order status ff ', result[0].orderStatus);
                this.isInvoicecrd = this.lstOrder[0].isInvoiceCreated;// added by Ranadip on 30/11/2020
                //added by MV
                if (this.lstOrder[0].dbupickupAddress) {
                    this.pickup = true;
                    console.log('inside pickup' + this.pickup);
                } else {
                    this.shipping = true;
                    console.log('else shipping not pickup' + this.shipping);
                }

                this.orderStatusCheck = result[0].orderStatus;
                

                //window.console.log('inside order orderrecord=>'+JSON.stringify(this.orderDetails));
                console.log('orderId' + this.orderId);
                console.log('firing event from the search');
                console.log(' this.lstOrder' + this.lstOrder[0].addresslist);
                console.log('lstProdData111>>>>>>>>>>>', result)
                console.log('after firing event from the custom search and going for navigation');
                console.log('Prod List===' + this.lstOrder[0].productlist.length);
                for (let i = 0; i < this.lstOrder[0].productlist.length; i++) {
                    productMap.set(this.lstOrder[0].productlist[i].sfid, this.lstOrder[0].productlist[i]);
                }
                //-------- Adding related products in Map
              for (let i = 0; i < this.lstOrder[0].relatedProducts.length; i++) {
                this.relatedProductMap.set(this.lstOrder[0].relatedProducts[i].ccrz__Product__c, this.lstOrder[0].relatedProducts[i]);
                }
                console.log('productMap' + productMap);
                let i = 0;

                let orderdetail = [];
                for (i = 0; i < this.lstOrder.length; i++) {
                    let orderdata = {};
                    let items = this.lstOrder[0].items;
                    orderdata['items'] = perfixCurrencyISOCode(this.currencyCode,items);
                  /*  if (items != null && items != undefined) {
                        orderdata['items'] = items.toLocaleString(this.storeLocationText, {
                            style: 'currency',
                            currency: this.currencyValue,
                            minimumFractionDigits: 2,
                            maximumFractionDigits: 2
                        });
                        if(this.currencyCode === 'CAD'){
                            orderdata['items'] = items.toLocaleString('en-US', this.currencyCAD);
                        }else if(this.currencyCode === 'USD'){
                            orderdata['items'] = items.toLocaleString('en-US', this.currencyUSD);   
                        }
            
                    }else{
                        if(this.currencyCode === 'CAD'){
                            orderdata['items'] = 0.00.toLocaleString('en-US', this.currencyCAD);
                        }else if(this.currencyCode === 'USD'){
                            orderdata['items'] = 0.00.toLocaleString('en-US', this.currencyUSD);   
                        }
                    }*/

                    let totalDiscount = this.lstOrder[0].totalDiscount;
                  /*  if (totalDiscount != null && totalDiscount != undefined) {
                        orderdata['totalDiscount'] = totalDiscount.toLocaleString(this.storeLocationText, {
                            style: 'currency',
                            currency: this.currencyValue,
                            minimumFractionDigits: 2,
                            maximumFractionDigits: 2
                        });
                        if(this.currencyCode === 'CAD'){
                            orderdata['totalDiscount'] = totalDiscount.toLocaleString('en-US', this.currencyCAD);
                        }else if(this.currencyCode === 'USD'){
                            orderdata['totalDiscount'] = totalDiscount.toLocaleString('en-US', this.currencyUSD);   
                        }
                    }else{
                        if(this.currencyCode === 'CAD'){
                            orderdata['totalDiscount'] = 0.00.toLocaleString('en-US', this.currencyCAD);
                        }else if(this.currencyCode === 'USD'){
                            orderdata['totalDiscount'] = 0.00.toLocaleString('en-US', this.currencyUSD);   
                        }
                    }*/
                    orderdata['totalDiscount'] = perfixCurrencyISOCode(this.currencyCode,totalDiscount);
                   // let subtotalAmount = this.lstOrder[0].subtotalAmount;
                   let subtotalAmount = ((Math.round(this.lstOrder[0].subtotalAmount * 100) / 100).toFixed(2))*1;
                    orderdata['subtotalAmount'] = perfixCurrencyISOCode(this.currencyCode,subtotalAmount);
                  /*  if (subtotalAmount != null && subtotalAmount != undefined) {
                       orderdata['subtotalAmount'] = subtotalAmount.toLocaleString(this.storeLocationText, {
                            style: 'currency',
                            currency: this.currencyValue,
                            minimumFractionDigits: 2,
                            maximumFractionDigits: 2
                        });
                        if(this.currencyCode === 'CAD'){
                            orderdata['subtotalAmount'] = subtotalAmount.toLocaleString('en-US', this.currencyCAD);
                        }else if(this.currencyCode === 'USD'){
                            orderdata['subtotalAmount'] = subtotalAmount.toLocaleString('en-US', this.currencyUSD);   
                        }
                    }else{
                        if(this.currencyCode === 'CAD'){
                            orderdata['subtotalAmount'] = 0.00.toLocaleString('en-US', this.currencyCAD);
                        }else if(this.currencyCode === 'USD'){
                            orderdata['subtotalAmount'] = 0.00.toLocaleString('en-US', this.currencyUSD);   
                        }
                    }*/

                    let taxAmount = this.lstOrder[0].taxAmount;
                    orderdata['taxAmount'] = perfixCurrencyISOCode(this.currencyCode,taxAmount);
                  /*  if (taxAmount != null && taxAmount != undefined) {
                        orderdata['taxAmount'] = taxAmount.toLocaleString(this.storeLocationText, {
                            style: 'currency',
                            currency: this.currencyValue,
                            minimumFractionDigits: 2,
                            maximumFractionDigits: 2
                        });
                        if(this.currencyCode === 'CAD'){
                            orderdata['taxAmount'] = taxAmount.toLocaleString('en-US', this.currencyCAD);
                        }else if(this.currencyCode === 'USD'){
                            orderdata['taxAmount'] = taxAmount.toLocaleString('en-US', this.currencyUSD);   
                        }
                    }else{
                        if(this.currencyCode === 'CAD'){
                            orderdata['taxAmount'] = 0.00.toLocaleString('en-US', this.currencyCAD);
                        }else if(this.currencyCode === 'USD'){
                            orderdata['taxAmount'] = 0.00.toLocaleString('en-US', this.currencyUSD);   
                        }
                    }*/

                    let shipAmount = this.lstOrder[0].shipAmount;
                    orderdata['shipAmount'] = perfixCurrencyISOCode(this.currencyCode,shipAmount);
                  /*  if (shipAmount != null && shipAmount != undefined) {
                        orderdata['shipAmount'] = shipAmount.toLocaleString(this.storeLocationText, {
                            style: 'currency',
                            currency: this.currencyValue,
                            minimumFractionDigits: 2,
                            maximumFractionDigits: 2
                        });
                        if(this.currencyCode === 'CAD'){
                            orderdata['shipAmount'] = shipAmount.toLocaleString('en-US', this.currencyCAD);
                        }else if(this.currencyCode === 'USD'){
                            orderdata['shipAmount'] = shipAmount.toLocaleString('en-US', this.currencyUSD);   
                        }
                    }else{
                        if(this.currencyCode === 'CAD'){
                            orderdata['shipAmount'] = 0.00.toLocaleString('en-US', this.currencyCAD);
                        }else if(this.currencyCode === 'USD'){
                            orderdata['shipAmount'] = 0.00.toLocaleString('en-US', this.currencyUSD);   
                        }
                    }*/

                    let totalAmount = this.lstOrder[0].totalAmount;
                    orderdata['totalAmount'] = perfixCurrencyISOCode(this.currencyCode,totalAmount);
                    /*if (totalAmount != null && totalAmount != undefined) {
                       orderdata['totalAmount'] = totalAmount.toLocaleString(this.storeLocationText, {
                            style: 'currency',
                            currency: this.currencyValue,
                            minimumFractionDigits: 2,
                            maximumFractionDigits: 2
                        });
                        if(this.currencyCode === 'CAD'){
                            orderdata['totalAmount'] = totalAmount.toLocaleString('en-US', this.currencyCAD);
                        }else if(this.currencyCode === 'USD'){
                            orderdata['totalAmount'] = totalAmount.toLocaleString('en-US', this.currencyUSD);   
                        }
                    }else{
                        if(this.currencyCode === 'CAD'){
                            orderdata['totalAmount'] = 0.00.toLocaleString('en-US', this.currencyCAD);
                        }else if(this.currencyCode === 'USD'){
                            orderdata['totalAmount'] = 0.00.toLocaleString('en-US', this.currencyUSD);   
                        }
                    }*/


                    orderdetail.push(orderdata);
                }

                console.log('orderdetail' + JSON.stringify(orderdetail));
                this.ordersummary = orderdetail;

                let orderrecordarray = [];
                console.log('data[0].productlist=>' + JSON.stringify(this.lstOrder[0].productlist));
                //  window.console.log('data[0].productlist.length=>'+ result.productlist.length);
                console.log('111@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
                console.log('1st order item ', this.lstOrder[0].EOrderItemsS[1]);

                var countOrderItems = 0;
              //  var countSubmittedOrderItems = 0;
               // var countTotalOrderItems = 0;

                console.log('orderItem List length===' + this.lstOrder[0].EOrderItemsS.length);
                for (let i = 0; i < this.lstOrder[0].EOrderItemsS.length; i++) {
                    let orderrecord = {};
                    orderrecord['orderId'] = this.orderId;
                    orderrecord['orderStatus'] = this.lstOrder[0].orderStatus; // added by Ranadip
                    orderrecord['sfid'] = this.lstOrder[0].EOrderItemsS[i].sfid;
                   // orderrecord['id'] = this.lstOrder[0].EOrderItemsS[i].sfid;
                    orderrecord['quantity'] = this.lstOrder[0].EOrderItemsS[i].quantity;
                    let amountInFormat = this.lstOrder[0].EOrderItemsS[i].price
                  /*  orderrecord['price'] = amountInFormat.toLocaleString('en-US', {
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2,
                        style: 'currency',
                        currency: 'USD'
                    });*/
                    // if(this.currencyCode === 'CAD'){
                    //     orderrecord['price'] = amountInFormat.toLocaleString('en-US', this.currencyCAD);
                    // }else if(this.currencyCode === 'USD'){
                    //     orderrecord['price'] = amountInFormat.toLocaleString('en-US', this.currencyUSD);   
                    // }
                    orderrecord['price'] = perfixCurrencyISOCode(this.currencyCode,amountInFormat);
                    if (productMap.has(this.lstOrder[0].EOrderItemsS[i].prodId)) {
                        orderrecord['sfdcName'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).sfdcName;
                        orderrecord['promotionTag'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).promotionTag;/*Sasikanth CECI-693*/
                        if(productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).EProductMediasS[0] !== undefined){
                        orderrecord['URI'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).EProductMediasS[0].URI;
                        }else{
                            orderrecord['URI'] = dbu_DefaultProductImage;
                        }
                        orderrecord['id'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).sfid;
                    }

                    console.log('product map' + productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).hasCoreCharge);
                   
                    if (productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).hasCoreCharge === true && productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).dbuHasCoreChild === true) {

                        orderrecord['coreCharge'] = true;
                    }


                    // if (this.lstOrder[0].EOrderItemsS[i].orderItemStatus == 'Return Initiated' ) {
                    //     countOrderItems++;
                    // }
                    if (this.lstOrder[0].EOrderItemsS[i].orderItemStatus == 'Shipped' || this.lstOrder[0].EOrderItemsS[i].orderItemStatus == 'Available for Pickup' || this.lstOrder[0].EOrderItemsS[i].orderItemStatus === 'Commande expédiée' || this.lstOrder[0].EOrderItemsS[i].orderItemStatus === 'Prête pour le ramassage') {
                      //  countSubmittedOrderItems++;
                        this.totalOrderQty = this.totalOrderQty + this.lstOrder[0].EOrderItemsS[i].quantity;
                    }

                    orderrecord['orderItemStatus'] = this.lstOrder[0].EOrderItemsS[i].orderItemStatus;

                    // if (this.lstOrder[0].EOrderItemsS[i].sfid !== null || this.lstOrder[0].EOrderItemsS[i].sfid !== undefined) {
                    //     countTotalOrderItems++;
                    // }
                    if ((this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Abandoned' && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== undefined &&
                        this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Rejected' && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Initiated' &&
                        this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Requested' && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Approved' &&
                        this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Refunded') && (this.lstOrder[0].EOrderItemsS[i].dbuIsReturned === false)) {
                        orderrecordarray.push(orderrecord);
                    }
                }

                //------Push records in array in sequence if core product exist----------//
           let itemInSequence = [];
           for(let i=0; i<orderrecordarray.length ;i++){
               if(orderrecordarray[i].parentCoreCharge){
                   let relatedCoreProdId = this.relatedProductMap.get(orderrecordarray[i].id).ccrz__RelatedProduct__c;
                   itemInSequence.push(orderrecordarray[i]);
                       for(let j=0; j<orderrecordarray.length; j++){
                           if(orderrecordarray[j].id === relatedCoreProdId){
                               itemInSequence.push(orderrecordarray[j]);
                           }
                       }
               }else{
                   itemInSequence.push(orderrecordarray[i]);
               }
           }
           //---- Removing duplicates records from itemInSequence array
           let itemsArray = [...new Set(itemInSequence)];
           //this.orderItemList = itemsArray;
           //----------------------------------------------------------------------//

                console.log(' this.totalOrderQty==='+ this.totalOrderQty);
              //  console.log('countOrderItems========' + countOrderItems);
                //console.log('countTotalOrderItems========' + countTotalOrderItems);

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

              //  console.log('countOrderItems ', countOrderItems);
                window.console.log('inside order orderrecord=>' + JSON.stringify(orderrecordarray));
                //this.orderSelectedDetails = data;

                this.cartDetails = itemsArray;
                // this.orderDetails = result;  
                this.orderDetails = this.lstOrder;
                console.log(' this.cartDetails' + JSON.stringify(this.cartDetails));
                console.log(' this.orderDetails' + JSON.stringify(this.orderDetails));
                invokeGoogleAnalyticsService('TRACK ORDER RESULTS', {orderinformation : this.orderDetails});


            })
            .catch(error => {
                this.error = error;
                console.log('error=>>' + this.error);
            });
        Checkcreateengine({
                urlParam: this.orderId
            }).then(result => {
                this.createngine = result;
                console.log('this.createngine' + this.createngine)
            })
            .catch(error => {
                this.error = error;
                console.log('error=>>Addressvalbilling' + JSON.stringify(this.error));
            });
        //} 
        /*else {
             fire toast event if input field is blank
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'Search text missing..',
            });
            this.dispatchEvent(event);
        }*/



    } //added by Ranadip
    @track isOrderStatusSuccess = true;
    checkorderStatus() {

        /*  if(this.orderStatusCheck == OrderStatusDelivered){
               this.isOrderStatusSuccess = true;
           }else if(this.orderStatusCheck == OrderStatusPickedUp){
               this.isOrderStatusSuccess = true;
           }else{
               this.isOrderStatusSuccess = false;
           }*/
        // console.log('=checkorderStatus called==' + this.isReturnInitiated);
        // if (((this.orderStatusCheck == OrderStatusDelivered || this.orderStatusCheck == OrderStatusPickedUp) && this.isReturnInitiated === true) || (this.orderStatusCheck == 'Order Submitted' && this.isOrderItemSubmitted == true)) {
        //     this.isOrderStatusSuccess = true;
        // } else {
        //     this.isOrderStatusSuccess = false;
        // }
           if(this.orderStatusCheck === 'Shipped' || this.orderStatusCheck === 'Available for Pickup' || this.orderStatusCheck === 'Commande expédiée' || this.orderStatusCheck === 'Prête pour le ramassage'){
            this.isOrderStatusSuccess = false;
           }else{
            this.isOrderStatusSuccess = true;
           }
         console.log('this.orderStatusCheck ', this.orderStatusCheck);
        // console.log('this.isOrderStatusSuccess ', this.isOrderStatusSuccess);
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

    @wire(fetchOrders)
    // @wire(fetchLstCartItemsByCartId,{cartId:'' })
    wireOrder({
        error,
        data
    }) {
        console.log('data of the ordere==================>', data);
        if (data) {
            this.myOrders = data;
            console.log('this.orderDetails==================>', this.orderDetails);
            this.isLoading = false;
            console.log('myOrders*******', this.myOrders.length);
            let i = 0;

            let orderdetail = [];
            for (i = 0; i < data.length; i++) {
                let orderdata = {};
                console.log('====='+ Object.keys(data[i]));
                console.log('Amt====='+ data[i].orderRecord.ccrz__TotalAmount__c);
               let Amt =  data[i].orderRecord.ccrz__TotalAmount__c;
                let currencyISOCode =  data[i].orderRecord.ccrz__CurrencyISOCode__c;
                orderdata['orignalAmount'] = data[i].orderRecord.ccrz__TotalAmount__c;
                 if (Amt != null && Amt != undefined) {
                   orderdata['selectedAmt'] = perfixCurrencyISOCode(currencyISOCode,Amt);
                   
                //     console.log('Ids==========' + data[i].Id);
                //     console.log('sfId==========' + data[i].sfid);
                    orderdata['status'] = data[i].orderRecord.ccrz__OrderStatus__c;
                    orderdata['Name'] = data[i].orderRecord.Name;
                     orderdata['Id'] = data[i].orderRecord.Id;

                //     let dateVal = data[i].ccrz__OrderDate__c;
                //     let date = new Date(dateVal);
                //     let dtOptions = {
                //         year: 'numeric',
                //         month: 'long',
                //         day: '2-digit'
                //     };
                     orderdata['selectedDate'] = data[i].orderDate;
                //     console.log('dateval++++++' + date.toLocaleString('en-US', dtOptions));
                    
                 }
                orderdetail.push(orderdata);

            }
            this.myorderDetails = orderdetail;
        } else if (error) {
            this.isLoading = false;
            this.error = error;
            console.log('error ' + this.error)
            //this.productSpecs = undefined;
        }

    }


    handleClickBackToOrder() {
        this.detailView = false;
        console.log('this.orderDetails==================>', this.orderDetails);
    }

    handleSearch(event) {
        this.inputValue = event.target.value.trim();
        console.log('input value', this.inputValue);
    }


    onInputclick() {

        fetchOrderItemsBasedonInput({
                searchval: this.inputValue
            })
            .then(result => {
                this.orderdataBasedonInput = result;
                console.log('result', this.orderdataBasedonInput)
            })
            .catch(error => {
                this.error = error;
                console.log('error=>>' + this.error);
            })

    }

    onOrderCancel(event) {
        //this.isQtyLoading = true;
        //console.log('onOrderCancel this.orderId=======>'+event.detail.value);
        //console.log('onOrderCancel event.orderItemId=======>'+event.target.dataset.id);
        //console.log('onProductDelete cartIdCookie=============>'+this.cartId)
        console.log('this.orderId in the onOrderCancel====>', this.orderId);
        callReturnOrderAPI({
                orderid: this.orderId
                //orderItemId : event.target.dataset.id
            })
            .then(result => {
                // // Clear the user enter values
                window.console.log('In onOrderCancel result ===> ' + result);
                // //this.createCookie('In onProductDelete cartId', result[0].cartId, 1);
                // pubsub.fire('fetchcartevt', result );
                // window.console.log('After fire eventresult ===> ' + result);
                // this.isQtyLoading = false;
                this.isOpenModelForReturnPartsSuccess = true;
                this.isOpenModelForReturnParts = false;
                this.isLoading = false;

            })
            .catch(error => {
                this.error = error.message;
            });
    }

    printPage() {
        window.print();
    }

    /*Code related to Rreturn part by order level */
    @track isOpenModelForReturnParts = false;
    @track isOpenModelForReturnPartsSuccess = false;
    @track returnReason;
    @track shippingMethodVal;

    get orderReaturnReason() {
        return [{
                label: 'Part no longer wanted',
                value: 'Part no longer wanted'
            },
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
            },
            {
                label: 'Drop off',
                value: 'DROP'
            }
        ];
    }
    @track flag = true;
    @track cadReturnOrder = true; //ramesh  CHG0106272 
    @track usReturnOrder  = true; //ramesh  CHG0106272 
    @track isGenuineOrder = false;
    openModelForReturnParts(event) {
        // to open modal set isModalOpen tarck value as true
        this.orderId = event.target.dataset.id;
        checkingGenuineProduct({
                orderid: this.orderId

            })
            .then(result => {
                //ramesh code starts CHG0106272 
                var currencyCodeStore = '';
                if((window.sessionStorage.getItem('setCountryCode') ==='EN') || (window.sessionStorage.getItem('setCountryCode') ==='FR')){
                    var currencyCodeStore = 'CAD';
                }else {
                    var currencyCodeStore = 'USD';
                }
                window.console.log('checkingGenuineProduct ' + result);
                this.isLoading = false;
                if((this.currencyCode != currencyCodeStore) && result == true) {
                    this.isOpenModelForReturnParts = true;
                    if(this.currencyCode == 'CAD'){ 
                        this.cadReturnOrder = false;
                    }else {
                        this.usReturnOrder = false;
                    }//ramesh code ends CHG0106272  
                } else if (result == true) {
                    //this.flag = true;
                    this.isGenuineOrder = true;
                    this.navigateToWebPage();
                    console.log('result  if ', result);
                } else if (result == false) {
                    this.isOpenModelForReturnParts = true;
                    this.flag = false;

                    // this.isGenuineOrder = false;
                    console.log('result  else ', result);
                }
            })
            .catch(error => {
                this.error = error.message;
            });
        // this.isOpenModelForReturnParts = true;
        //this.orderId = event.target.dataset.id;
        console.log('onOrderCancel event.orderItemId=======>event.target.dataset.id', event.target.dataset.id);
        console.log('this.isOpenModelForReturnParts', this.isOpenModelForReturnParts);
    }

    closeModelForReturnParts() {
        // to close modal set isModalOpen tarck value as false
        this.isOpenModelForReturnParts = false;
        this.flag = true;
        this.usReturnOrder = true; //ramesh  CHG0106272 
        this.cadReturnOrder = true; //ramesh  CHG0106272 
        console.log('this.isOpenModelForReturnParts', this.isOpenModelForReturnParts);
    }
    onShippingMethodSelect(event) {
        this.shippingMethodVal = event.detail.value;
        console.log('shippingMethod event.orderItemId=======>event.target.dataset.id', event.detail.value);
        console.log('shippingMethod =======>event.target.dataset.id', event.detail.value);
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

    navigateToWebPage() {
        let urlString = window.location.origin;
        //return urlString+communityName+'product?pId='+this.product.Id;
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

   
    //added by Ranadip on 01/12/2020
    navigateToInvoicePage(){
        let urlString = window.location.origin;
        let urls = urlString + communityName + 'invoice?orderid=' + this.orderId +'&store=' + this.sendLocBackToChangeLocTile;
        window.open(urls);
    }


    clearSorting()
    {
        let lstColoumns = ['OrderNumber','OrderDate','Amount','Status'];
        
        for(let i = 0; i < lstColoumns.length;i++)
        {
            let coloum = this.template.querySelector('[data-id="'+lstColoumns[i]+'"]');
            let removeUpWord = false;
            let removeDownWord = false;
            let removeBlankArrow = false;
            console.log(coloum);
            console.log(coloum.classList);
            for(let j=0; j<coloum.classList.length;j++)
            {
                if(coloum.classList[j] === 'upArrow')
                {
                    removeUpWord = true;
                }

                if(coloum.classList[j] === 'downArrow')
                {
                    removeDownWord = true;
                }

                if(coloum.classList[j] === 'blankArrow')
                {
                    removeBlankArrow = true;
                }

            }

            if(removeUpWord)
            {
                coloum.classList.remove('upArrow');
            }

            if(removeDownWord)
            {
                coloum.classList.remove('downArrow');
            }

            if(removeBlankArrow)
            {
                console.log('we here 01');
                coloum.classList.remove('blankArrow');
                console.log('we here 02');
            }

            coloum.classList.add('blankArrow');
        }

        
    }
    //handleSorting
    handleSorting(event)
    {
        debugger;
        let lstColoumns = ['OrderNumber','OrderDate','Amount','Status'];
        console.log('handle sorting');
        console.log(event.currentTarget.className);
        console.log(event.currentTarget.id);
        let selectedColoum = '';

        if(event.currentTarget.id.includes('OrderNumber'))
            selectedColoum = 'OrderNumber';
        if(event.currentTarget.id.includes('OrderDate'))
            selectedColoum = 'OrderDate';
        if(event.currentTarget.id.includes('Amount'))
            selectedColoum = 'Amount';
        if(event.currentTarget.id.includes('Status'))
            selectedColoum = 'Status';

        let ascendingOrder = true;
        
        console.log(selectedColoum);
        for(let j = 0; j < lstColoumns.length ; j++)
        {
            console.log('in for loop: '+lstColoumns[j]);
            if(lstColoumns[j] === selectedColoum)
            {
                let coloum = this.template.querySelector('[data-id="'+selectedColoum+'"]');
                console.log('coloum');
                console.log(coloum);
                if(coloum)
                {
                    let upwordSelected = false;
                    let downwordSelected = false;
                    let firstClick = false;
                    for(let i =0; i<coloum.classList.length;i++)
                    {
                        console.log(coloum.classList[i]);
                        console.log(coloum.classList[i] === 'upArrow');
                        if(coloum.classList[i] === 'upArrow')
                        {
                            upwordSelected = true;
                            break;
                        }
                        else if(coloum.classList[i] === 'downArrow')
                        {
                            downwordSelected = true;
                            break;
                        }
                        else if(coloum.classList[i] === 'blankArrow')
                        {
                            firstClick = true;
                            break;
                        }
                    }

                    console.log(upwordSelected);
                    console.log(downwordSelected);
                    console.log(firstClick);
                    if(upwordSelected)
                    {
                        coloum.classList.add('downArrow');
                        coloum.classList.remove('upArrow');
                        ascendingOrder = true;
                    }
                    else if(downwordSelected)
                    {
                        ascendingOrder = false;
                        coloum.classList.add('upArrow');
                        coloum.classList.remove('downArrow');
                    }
                    else if(firstClick)
                    {
                        coloum.classList.remove('blankArrow');
                        coloum.classList.add('upArrow');
                        ascendingOrder = false;
                    }
                }
            }
            else
            {
                let coloum = this.template.querySelector('[data-id="'+lstColoumns[j]+'"]');
                let removeUpWord = false;
                let removeDownWord = false;
                let removeBlankArrow = false;
                console.log(coloum);
                console.log(coloum.classList);
                for(let j=0; j<coloum.classList.length;j++)
                {
                    if(coloum.classList[j] === 'upArrow')
                    {
                        removeUpWord = true;
                    }

                    if(coloum.classList[j] === 'downArrow')
                    {
                        removeDownWord = true;
                    }

                    if(coloum.classList[j] === 'blankArrow')
                    {
                        removeBlankArrow = true;
                    }

                }

                if(removeUpWord)
                {
                    coloum.classList.remove('upArrow');
                }

                if(removeDownWord)
                {
                    coloum.classList.remove('downArrow');
                }

                if(removeBlankArrow)
                {
                    console.log('we here 01');
                    coloum.classList.remove('blankArrow');
                    console.log('we here 02');
                }

                coloum.classList.add('blankArrow');
            }
        }

        let sortIetm = '';
        if(selectedColoum === 'OrderNumber')
            sortIetm = 'Name';
        if(selectedColoum === 'OrderDate')
            sortIetm = 'selectedDate';
        if(selectedColoum === 'Amount')
            sortIetm = 'orignalAmount';
        if(selectedColoum === 'Status')
            sortIetm = 'status';
        let orderColoum = '';
        if(ascendingOrder)
            orderColoum = 'asc';
        else
            orderColoum = 'desc';
        console.log('orderColoum: '+orderColoum);
        console.log('sortIetm: '+sortIetm);
         this.myorderDetails = this.myorderDetails.sort(this.dynamicsort(sortIetm,orderColoum));
    }



    dynamicsort(property,order) {
        let sort_order = 1;
        if(order === "desc"){
            sort_order = -1;
        }
        return function (a, b){
            // a should come before b in the sorted order
            let fora = a[property];
            let forb = b[property];
            if(property === 'selectedDate')
            {
                fora = new Date(a[property]);
                forb = new Date(b[property]);
            }

            if(fora < forb){
                    return -1 * sort_order;
            // a should come after b in the sorted order
            }else if(fora > forb){
                    return 1 * sort_order;
            // a and b are the same
            }else{
                    return 0 * sort_order;
            }
        }
    }
}