import { LightningElement,track,wire,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import fetchLstCartItemsByCartId from '@salesforce/apex/dbu_CartCtrl.fetchLstCartItemsByCartId';
import fetchLstOrderDetails from '@salesforce/apex/dbu_OrderCtrl.fetchLstOrderDetails';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';//custom label refres to'CA'
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA';
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada';
import isGuest from '@salesforce/user/isGuest';
import dbu_shipProduct from '@salesforce/label/c.dbu_shipProduct';
import dbu_sQuantity from '@salesforce/label/c.dbu_sQuantity';
import dbu_unitPrice from '@salesforce/label/c.dbu_unitPrice';
import dbu_sSubtotal from '@salesforce/label/c.dbu_sSubtotal';
import { perfixCurrencyISOCode } from 'c/serviceComponent';
import communityName from '@salesforce/label/c.dbu_communityName';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import fetchregisteredUserCartId from '@salesforce/apex/dbu_CartCtrl.fetchCartId';
import dbu_Ship_to_Address_Product from '@salesforce/label/c.dbu_Ship_to_Address_Product';
import dbu_Pick_up_from_Store_Product from '@salesforce/label/c.dbu_Pick_up_from_Store_Product';
import dbu_Ship_to_Address_Product_OrderConfirmation from '@salesforce/label/c.dbu_Ship_to_Address_Product_OrderConfirmation';
import dbu_Pick_up_from_Store_Product_OrderConfirmation from '@salesforce/label/c.dbu_Pick_up_from_Store_Product_OrderConfirmation';
import clearanceIcon from '@salesforce/resourceUrl/dbu_icons';
export default class dbu_shipandPickupProducts extends NavigationMixin(LightningElement) 
{
    @api cartId;
    @track shipProduct;
   
    @track sendLocBackToChangeLocTile;
    @track isguestuser = isGuest;
    @track footerbannercookiestatus;
    @track currentStorelocation;
    @track isLoading = true;
    @track dbu_shipProduct = dbu_shipProduct;
    @track dbu_sQuantity = dbu_sQuantity;
    @track dbu_unitPrice = dbu_unitPrice;
    @track dbu_sSubtotal = dbu_sSubtotal;
    
    @track shipToAddressProducts = [];
    @track PickUpProducts = [];
    @track shipToAddressProductsAvailable = false;
    @track PickUpProductsAvailable = false;
    
    @track ShipToAddressflag = false;
    @track ShipToAddress = false;
    @track shipaddressfirstline;
    @track shipaddresscity;
    @track shipaddressstate;
    @track shipaddresspostalCode;
    @track shipaddresscountry;
    
    
    @track pickUpAddressflag = false;
    @track pickUpAddress = false;
    @track pickUpaddressBranchName;
    @track pickUpaddressfirstline;
    @track pickUpaddresscity;
	@track pickUpaddressstate;
    @track pickUpaddresspostalCode;
    @track pickUpaddresscountry;


    @track onCheckoutPage = false;
    @track onReviewOrderPage = false;
    @track onOrderConfirmationPage = false;

    //@track estimatedDelivery = 'May 14 - May 20';
    //@track estimatedPickUp = 'May 11';
    @track PickUpStoreOpenHrs = '';
    @track productid;
    @track productName;

    @track currentStoreLanguage;
    @track countryCurrencyCode;

    @track CustomerName;
    @track CustomerNameAvailable = false;

    @track baseURL;
    @track homePageUrlWithStore;
    @track clearanceImg = clearanceIcon+'/dbu_icons/dbu_saletag.svg';
    label = {
        dbu_Ship_to_Address_Product,
        dbu_Pick_up_from_Store_Product,
        dbu_Ship_to_Address_Product_OrderConfirmation,
        dbu_Pick_up_from_Store_Product_OrderConfirmation
    }

    get ScreenLoaded() 
    {
        return this.isLoading;
    }

    connectedCallback() 
    { 
        //alert('cartid +++' + this.cartId);
        console.log('inside shipingpickup component');
        if(window.location.pathname === '/CSSNAStore/s/checkout'){
            this.onCheckoutPage = true;
            this.onReviewOrderPage = false;
            this.onOrderConfirmationPage = false;
        }
        else if(window.location.pathname === '/CSSNAStore/s/order-review'){
            this.onCheckoutPage = false;
            this.onReviewOrderPage = true;
            this.onOrderConfirmationPage = false;
        }else if(window.location.pathname === '/CSSNAStore/s/order'){
            this.onCheckoutPage = false;
            this.onReviewOrderPage = false;
            this.onOrderConfirmationPage = true;
        }


        this.currentStoreLanguage = window.sessionStorage.getItem('setCountryCode');

        if(this.currentStoreLanguage == storeUSA || 
            this.currentStoreLanguage == undefined ||
            this.currentStoreLanguage == null || this.currentStoreLanguage == ''){                
            this.currentStorelocation = storeUSA;
            this.countryCurrencyCode = currencyCodeUSA;
            this.currentStoreLanguage = storeUSA;
        }else if(this.currentStoreLanguage == storeCA || this.currentStoreLanguage == storeCAF){
            this.currentStorelocation = storeCanada; 
            this.countryCurrencyCode = currencyCodeCanada;
        }

        this.baseURL = window.location.origin + communityName;
        this.homePageUrlWithStore = this.baseURL + '?store='+ this.currentStoreLanguage;
        console.log('rostov on don > ' + this.isguestuser);
        //prevention mechanism added by Malhar on 1 dec,21 if cartid comes blank or undefined for resitered user
        if(!this.isguestuser){
            console.log('intel inside registro > ' + this.cartId );
            if(this.cartId == null || this.cartId == undefined || this.cartId === 'undefined' || this.cartId == ''){
                fetchregisteredUserCartId({
                    storeCountry : this.currentStorelocation
                }).then(result => {
                        this.cartId = result;
                        console.log('carta magadalena > ' + this.cartId );
                        this.selectAppropriatePage();
                        this.error = undefined;
                }).catch(error => {
                        this.error = error.message;
                });
            }else{
                console.log('carta tijuana > ' + this.cartId );
                this.selectAppropriatePage();
            }
        }
        else if(this.isguestuser){
            console.log('carta guesta Juarez > ' + this.cartId );
            this.selectAppropriatePage();
        }
                   
    }

    selectAppropriatePage(){
        if(window.location.pathname === '/CSSNAStore/s/order-review' || window.location.pathname === '/CSSNAStore/s/checkout'){
            console.log('constantinople > ' + this.cartId );
            this.getshipProducFun(); 
        }else if(window.location.pathname === '/CSSNAStore/s/order'){
            console.log('Antioch> ' + this.cartId );
            this.getOrderReceiptInfoFun();
        }        
    }


    getshipProducFun()
    {
        fetchLstCartItemsByCartId({
            cartId: this.cartId,
            cart: ''
        })
            .then(data => {
                if (data && data.length > 0) {
                    console.log('Going to make Imperative call CartId============', this.cartId);
                    console.log(data);
                    window.console.log('Cart data>>>>>>>>' + JSON.stringify(data));
                    this.cartDetails = data;
                    this.isLoading = false;
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
                    console.log('ABDUL RASHID DOSTUM');
                    this.cartDetails.forEach(element => {

                                            
                        console.log('KAVKAZ > ' + element.cartDetails.dbu_Pick_Up_From_Store__r);
                        
                        if(element.cartDetails.dbu_Pick_Up_From_Store__r){
                            this.pickUpAddress = this.generateShipandPickupAddress(element.cartDetails.dbu_Pick_Up_From_Store__r, 'pick');                            
                            if(this.pickUpAddress){
                                this.pickUpAddressflag = true;

                                if(element.cartDetails.dbu_Pick_Up_From_Store__r.dbu_StartEndTimeOfStore__c != null && 
                                    element.cartDetails.dbu_Pick_Up_From_Store__r.dbu_StartEndTimeOfStore__c != undefined &&
                                    element.cartDetails.dbu_Pick_Up_From_Store__r.dbu_StartEndTimeOfStore__c != ''){
                                        this.PickUpStoreOpenHrs = element.cartDetails.dbu_Pick_Up_From_Store__r.dbu_StartEndTimeOfStore__c;
                                    }

                            }
                            //this.pickUpAddressflag = true;   
                            
                        }

                        if(element.cartDetails.ccrz__ShipTo__r){
                            this.ShipToAddress = this.generateShipandPickupAddress(element.cartDetails.ccrz__ShipTo__r, 'ship');                            
                            if(this.ShipToAddress){
                                this.ShipToAddressflag = true;

                                let userfirstname;
                                let userlastname;

                                if(element.cartDetails.ccrz__ShipTo__r.ccrz__FirstName__c != null && 
                                    element.cartDetails.ccrz__ShipTo__r.ccrz__FirstName__c != undefined && 
                                    element.cartDetails.ccrz__ShipTo__r.ccrz__FirstName__c != ''){
                                        console.log('FIRST NAME  > ' + element.cartDetails.ccrz__ShipTo__r.ccrz__FirstName__c);
                                        userfirstname = element.cartDetails.ccrz__ShipTo__r.ccrz__FirstName__c;
                                }

                                if(element.cartDetails.ccrz__ShipTo__r.ccrz__LastName__c != null && 
                                    element.cartDetails.ccrz__ShipTo__r.ccrz__LastName__c != undefined && 
                                    element.cartDetails.ccrz__ShipTo__r.ccrz__LastName__c != ''){
                                        console.log('FIRST NAME  > ' + element.cartDetails.ccrz__ShipTo__r.ccrz__LastName__c);
                                        userlastname = element.cartDetails.ccrz__ShipTo__r.ccrz__LastName__c;
                                }

                                if(userfirstname != undefined && userlastname != undefined){
                                    this.CustomerNameAvailable = true;
                                    this.CustomerName = userfirstname + ' ' + userlastname;
                                }else if(userfirstname == undefined && userlastname != undefined){
                                    this.CustomerNameAvailable = true;
                                    this.CustomerName = userlastname;
                                }else if(userfirstname != undefined && userlastname == undefined){
                                    this.CustomerNameAvailable = true;
                                    this.CustomerName = userfirstname;
                                }                                

                            }
                        }

                        element.lstCartItem.forEach(item => {
                            console.log('MHMD ATTA NOOR');
                            let currentRetPrice =  item.cartItem.ccrz__Price__c;
                            item['formatedUnitPrice'] = perfixCurrencyISOCode(this.countryCurrencyCode ,currentRetPrice);  
                            console.log('GROMOV  > ' + item.cartItem.Id);
                            item['cartitemrecordId'] = item.cartItem.Id;
                            console.log('item.cartItem.ccrz__SubAmount__c +++ ' +  item.cartItem.ccrz__SubAmount__c);

                            let localCartSubtotalLineItem = item.cartItem.ccrz__SubAmount__c;
                            localCartSubtotalLineItem = ((Math.round(localCartSubtotalLineItem * 100) / 100).toFixed(2)) * 1;
                            item['formatedSubTotal'] = perfixCurrencyISOCode(this.countryCurrencyCode ,localCartSubtotalLineItem);                          
                            console.log('AKMEDSHH MASSOOD > ');
                            console.log('istari item > ' + JSON.stringify(item));
                            if(item.cartItem.dbu_isShipTo__c){
                                if(item.cartItem.dbu_Estimated_Delivery__c != null && item.cartItem.dbu_Estimated_Delivery__c != undefined && item.cartItem.dbu_Estimated_Delivery__c != ''){
                                    item['estimatedDelivery']  = item.cartItem.dbu_Estimated_Delivery__c;
                                }else{
                                    item['estimatedDelivery']  = '';
                                }                                
                                this.shipToAddressProducts.push(item);                                
                            }else{
                                if(item.cartItem.dbu_Estimated_PickUp__c != null && item.cartItem.dbu_Estimated_PickUp__c != undefined && item.cartItem.dbu_Estimated_PickUp__c != ''){
                                    item['estimatedPickUp']  =  item.cartItem.dbu_Estimated_PickUp__c;
                                }else{
                                    item['estimatedPickUp']  = '';
                                }
                                
                                this.PickUpProducts.push(item);
                            }                            

                        })
                    });
                    console.log(' this.shipToAddressProducts > ' +  JSON.stringify(this.shipToAddressProducts));
                    console.log(' this.PickUpProducts > ' +  JSON.stringify(this.PickUpProducts));

                    if(this.shipToAddressProducts.length > 0){
                        console.log(' this.shipToAddressProductsAvailable setting true ');
                        this.shipToAddressProductsAvailable = true;
                    }

                    if(this.PickUpProducts.length > 0){
                        console.log(' this.shipToAddressProductsAvailable setting false ');
                        this.PickUpProductsAvailable = true;                        
                    }                    

                    /*ended here*/
                    if (this.cartDetails[0].originalCartAmt != null) {
                        this.cartOriginalAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,localcartOriginalAmount);
                    }
        
                    if (this.cartDetails[0].totalCartDiscount != null) {
                        console.log('entering the discount loop if part>>>' + localcartDiscountAmount);
                        this.cartDiscountAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,localcartDiscountAmount);
                    }
        
                    if (this.cartDetails[0].subtotalAmount != null) {
                        console.log('this.cartDetails[0].subtotalAmount' + this.cartDetails[0].subtotalAmount);
                        this.cartSubtotalAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,localcartSubtotalAmount);
                    }
                    if (this.cartDetails[0].totalAmount != null) {
                        this.cartTotalAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,localcartTotalAmount);                        
                    }
                    if (this.cartDetails[0].taxAmount != null) {
                        this.cartTaxAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,localcartTaxAmount);
                    }
                    //************* code with decimals and currency ends*/
                    this.error = undefined;
                    console.log('Cart data222222>>>>>>>>'+ JSON.stringify(this.cartDetails));
                    //invokeGoogleAnalyticsService('ORDER REVIEW CHECKOUT', this.cartDetails); 
                    this.isLoading = false;
                } else if (error) {
                    this.error = error;
                    this.cartDetails = undefined;
                }
            })
            .catch(error => {
                this.isLoading = false;
                this.error = error.message;
            });
    }
    
    
    getOrderReceiptInfoFun(){
        
        let orderpageURL = window.location.origin + communityName + 'order?cartId=' + this.cartId + '&store=US';

        fetchLstOrderDetails({
            urlParam : orderpageURL
        }).then(result => {
            console.log('HAIRATON result > ' + JSON.stringify(result));
            if(result != null && result != undefined && result != ''){
                let orderdetails = result[0];
                

                //ship address 
                if(orderdetails.addresslist != null && orderdetails.addresslist != undefined && orderdetails.addresslist != ''){
                    if(orderdetails.addresslist.length > 0){
                        let currentshipaddresslist = orderdetails.addresslist[0];

                        //customer name shipto logic
                        let fullname = '';
                        if(currentshipaddresslist.firstName != null && currentshipaddresslist.firstName != undefined && currentshipaddresslist.firstName != ''){
                            let shipaddressfirstName = currentshipaddresslist.firstName;
                            fullname = shipaddressfirstName;
                        }

                        if(currentshipaddresslist.lastName != null && currentshipaddresslist.lastName != undefined && currentshipaddresslist.lastName != ''){
                            let shipaddresslastName = currentshipaddresslist.lastName;                        
                            if(fullname != ''){
                                fullname = fullname + ' ' + shipaddresslastName;
                            }else{
                                fullname = shipaddresslastName;
                            }                            
                        }                         
                        console.log('fullname > ' + fullname);
                        this.CustomerName = fullname;
                        if(this.CustomerName != ''){
                            this.CustomerNameAvailable = true;
                        }else{
                            this.CustomerNameAvailable = false;
                        }
                        
                        //shipto address logic
                        if(currentshipaddresslist.addressFirstline != null && currentshipaddresslist.addressFirstline != undefined && currentshipaddresslist.addressFirstline != ''){
                            this.shipaddressfirstline = currentshipaddresslist.addressFirstline + ',';
                            this.ShipToAddress = this.shipaddressfirstline;
                        }

                        if(currentshipaddresslist.city != null && currentshipaddresslist.city != undefined && currentshipaddresslist.city != ''){
                            this.shipaddresscity = currentshipaddresslist.city + ',';
                            if(!this.ShipToAddress){
                                this.ShipToAddress = this.shipaddresscity;
                            }else{
                                this.ShipToAddress = this.ShipToAddress + ',' + this.shipaddresscity;
                            }
                            
                        }

                        if(currentshipaddresslist.state != null && currentshipaddresslist.state != undefined && currentshipaddresslist.state != ''){
                            this.shipaddressstate = currentshipaddresslist.state + ',';
                            if(!this.ShipToAddress){
                                this.ShipToAddress = this.shipaddressstate ;
                            }else{
                                this.ShipToAddress = this.ShipToAddress + ',' + this.shipaddressstate ;
                            }
                            
                        } 
                        
                        if(currentshipaddresslist.country != null && currentshipaddresslist.country != undefined && currentshipaddresslist.country != ''){
                            this.shipaddresscountry = currentshipaddresslist.country;
                            if(!this.ShipToAddress){
                                this.ShipToAddress = this.shipaddresscountry;
                            }else{
                                this.ShipToAddress = this.ShipToAddress + ',' + this.shipaddresscountry;
                            }                             
                        }                        

                        if(currentshipaddresslist.postalCode != null && currentshipaddresslist.postalCode != undefined && currentshipaddresslist.postalCode != ''){
                            this.shipaddresscountry = this.shipaddresscountry;
                            this.shipaddresspostalCode = currentshipaddresslist.postalCode + ',';
                            if(!this.ShipToAddress){
                                this.ShipToAddress = this.shipaddresspostalCode;
                            }else{
                                this.ShipToAddress = this.ShipToAddress + ',' + this.shipaddresspostalCode;
                            }                            
                        }


                        
                        if(this.ShipToAddress){
                            this.ShipToAddressflag = true;
                        }
                        
                       
                    }
                }

                //pickaddress
                if(orderdetails.OrderPickUpAddress != null && orderdetails.OrderPickUpAddress != undefined && orderdetails.OrderPickUpAddress != ''){
                    let currentpickaddresslist = orderdetails.OrderPickUpAddress[0];

                    if(currentpickaddresslist.dbu_PickUp_Store_Name__c != null && currentpickaddresslist.dbu_PickUp_Store_Name__c != undefined && currentpickaddresslist.dbu_PickUp_Store_Name__c != ''){
                        this.pickUpaddressBranchName = currentpickaddresslist.dbu_PickUp_Store_Name__c + ',';
                        this.pickUpAddress = this.pickUpaddressBranchName;
                    }

                    if(currentpickaddresslist.ccrz__AddressFirstline__c != null && currentpickaddresslist.ccrz__AddressFirstline__c != undefined && currentpickaddresslist.ccrz__AddressFirstline__c != ''){
                        this.pickUpaddressfirstline = currentpickaddresslist.ccrz__AddressFirstline__c + ',';
                        if(!this.pickUpAddress){
                            this.pickUpAddress = this.pickUpaddressfirstline;
                        }else{
                            this.pickUpAddress = this.pickUpAddress + ',' + this.pickUpaddressfirstline;
                        }
                        
                    } 
                    
                    if(currentpickaddresslist.ccrz__City__c != null && currentpickaddresslist.ccrz__City__c != undefined && currentpickaddresslist.ccrz__City__c != ''){
                        this.pickUpaddresscity = currentpickaddresslist.ccrz__City__c + ',';
                        if(!this.pickUpAddress){
                            this.pickUpAddress = this.pickUpaddresscity;
                        }else{
                            this.pickUpAddress = this.pickUpAddress + ',' + this.pickUpaddresscity;
                        }                        
                    }    
                    
                    if(currentpickaddresslist.ccrz__State__c != null && currentpickaddresslist.ccrz__State__c != undefined && currentpickaddresslist.ccrz__State__c != ''){
                        this.pickUpaddressstate = currentpickaddresslist.ccrz__State__c + ',';
                        if(!this.pickUpAddress){
                            this.pickUpAddress = this.pickUpaddressstate ;
                        }else{
                            this.pickUpAddress = this.pickUpAddress + ',' + this.pickUpaddressstate ;
                        }                        
                    }            
                    
                    if(currentpickaddresslist.ccrz__Country__c != null && currentpickaddresslist.ccrz__Country__c != undefined && currentpickaddresslist.ccrz__Country__c != ''){
                        this.pickUpaddresscountry = currentpickaddresslist.ccrz__Country__c;
                        if(!this.pickUpAddress){
                            this.pickUpAddress = this.pickUpaddresscountry;
                        }else{
                            this.pickUpAddress = this.pickUpAddress + ',' + this.pickUpaddresscountry;
                        }                             
                    }  
                    
                    if(currentpickaddresslist.ccrz__PostalCode__c != null && currentpickaddresslist.ccrz__PostalCode__c != undefined && currentpickaddresslist.ccrz__PostalCode__c != ''){
                        this.pickUpaddresscountry = this.pickUpaddresscountry;
                        this.pickUpaddresspostalCode = currentpickaddresslist.ccrz__PostalCode__c  + ',';
                        if(!this.pickUpAddress){
                            this.pickUpAddress = this.pickUpaddresspostalCode;
                        }else{
                            this.pickUpAddress = this.pickUpaddresspostalCode + ',' + this.pickUpAddress  ;
                        }                            
                    }	                    

                    //this.pickUpAddress = orderdetails.dbupickupAddress;
                }

                if(this.pickUpAddress){
                    this.pickUpAddressflag = true;
                }

                //openhrs
                if(orderdetails.dbuPickUpStoreOpenHrs != null && orderdetails.dbuPickUpStoreOpenHrs != undefined && orderdetails.dbuPickUpStoreOpenHrs != ''){
                    this.PickUpStoreOpenHrs = orderdetails.dbuPickUpStoreOpenHrs;
                }

                //orderitems
                if(orderdetails.EOrderItemsS != null && orderdetails.EOrderItemsS != undefined && orderdetails.EOrderItemsS != ''){
                    if(orderdetails.EOrderItemsS.length > 0){
                        let orderItemDetails = orderdetails.EOrderItemsS;

                        orderItemDetails.forEach(element => {
                            console.log('element each > ' + JSON.stringify(element));

                            let elementProductId = element.prodId;
                            let elementProductName = '';
                            let elementProductURI = '';
                            let elementQuantity = 0;
                            let elementUnitPrice = 0;
                            let elementSubamount = 0;
                            let elementEstimatedDelivery = '';
                            let elementEstimatedPickup = '';
                            let elementdbushipto;
                            let isCore = false;
                            let elementPromotionTag = '';

                            if(orderdetails.productlist != null && orderdetails.productlist != undefined && orderdetails.productlist != ''){
                                if(orderdetails.productlist.length > 0 ){

                                    //iterating productlist for Name & Imageuri
                                    orderdetails.productlist.forEach(productelement => {
                                        if(productelement.sfid === elementProductId){                                            
                                            elementProductName = productelement.sfdcName;
                                            elementPromotionTag = productelement.promotionTag;
                                            if(productelement.EProductMediasS != null && productelement.EProductMediasS != undefined && productelement.EProductMediasS != ''){
                                                if(productelement.EProductMediasS.length > 0 ){
                                                    
                                                    productelement.EProductMediasS.forEach(imageelement => {
                                                        if(imageelement.URI != null && imageelement.URI != undefined && imageelement.URI != ''){
                                                            elementProductURI = imageelement.URI;                                                                                                            
                                                        }
                                                    }); 
                                                }
                                            }
                                            

                                            if(productelement.isCoreProduct != null && productelement.isCoreProduct != undefined && productelement.isCoreProduct != ''){
                                                isCore = productelement.isCoreProduct;
                                            }                                            
                                        }

                                    });

                                }                                
                            }

                            if(element.quantity != null && element.quantity != undefined && element.quantity != '' ){
                                elementQuantity = element.quantity;
                            }
                            
                            if(element.price != null && element.price != undefined && element.price != '' ){
                                elementUnitPrice = perfixCurrencyISOCode(this.countryCurrencyCode ,element.price);
                                
                            }
                            
                            if(element.subAmount != null && element.subAmount != undefined && element.subAmount != '' ){
                                elementSubamount = perfixCurrencyISOCode(this.countryCurrencyCode ,element.subAmount);                                
                            }
                            
                            if(element.estimatedDelivery != null && element.estimatedDelivery != undefined && element.estimatedDelivery != '' ){
                                elementEstimatedDelivery = element.estimatedDelivery;
                            }else{
                                elementEstimatedDelivery = '';
                            }

                            if(element.estimatedPickUp != null && element.estimatedPickUp != undefined && element.estimatedPickUp != '' ){
                                elementEstimatedPickup = element.estimatedPickUp;
                            }else{
                                elementEstimatedPickup = '';
                            }
                                                        
                            elementdbushipto = element.dbuisShipTo;

                            let orderitem = {
                                'productid' : elementProductId,
                                'productName' : elementProductName,
                                'productURI' : elementProductURI,
                                'quantity' : elementQuantity,
                                'price' : elementUnitPrice,
                                'subamount' : elementSubamount,
                                'estimatedDelivery' : elementEstimatedDelivery,
                                'estimatedPickup' : elementEstimatedPickup,
                                'dbushipto' : elementdbushipto,
                                'isCore' : isCore,
                                'promotionTag': elementPromotionTag
                            };                            

                            if(elementdbushipto){
                                //shipto products
                                this.shipToAddressProducts.push(orderitem);
                            }else if(!elementdbushipto){
                                //pickup products
                                this.PickUpProducts.push(orderitem)
                            }

                            console.log('ship list > ' + JSON.stringify(this.shipToAddressProducts));
                            console.log('pick list > ' + JSON.stringify(this.PickUpProducts));
                        });

                    }
                }
                
                

                if(this.shipToAddressProducts.length > 0 ){
                    this.shipToAddressProductsAvailable = true;
                }

                console.log('ship list flag > ' + this.shipToAddressProductsAvailable );


                if(this.PickUpProducts.length > 0 ){
                    this.PickUpProductsAvailable = true; 
                }

                console.log('pick list flag > ' + this.PickUpProductsAvailable );
            }

            this.isLoading = false;
        }).catch(error => {
            this.isLoading = false;
            this.error = error.message;            
        })
    }


    getCookie(name) 
    {
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


    navigateToContinueToShoping(){
        invokeGoogleAnalyticsService('CONTINUE SHOPPING CLICKS', {eventname : 'Go To home page'});
    }
        
    get docontinueshopping(){
        return this.homePageUrlWithStore;
    }


    navigateToProductPage(event) {
        this.productid = event.target.getAttribute('data-id');
        this.productName = event.target.getAttribute('data-name');
        if(this.productName != null){
            invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Naviate to the ' + this.productName + ' product page');
        }        
    }

    get productURL() {
        let urlString = window.location.origin;
        return urlString + communityName + 'product/'+ this.productid+'/'+ this.productName+'/?store='+this.currentStoreLanguage;  
    }


    generateShipandPickupAddress(addresslist, addresType) {
        console.log('Inside generateShipandPickupAddress');
        console.log('addresslist > ' + addresslist);
        let returnAddress = false;

        //dbu_PickUp_Store_Name__c
        if(addresType === 'pick'){
            if (addresslist.dbu_PickUp_Store_Name__c) {
                returnAddress = addresslist.dbu_PickUp_Store_Name__c;
                this.pickUpaddressBranchName = addresslist.dbu_PickUp_Store_Name__c + ',';
            }
        }

        //address line 
        if (addresslist.ccrz__AddressFirstline__c) {
            
            if(addresType === 'ship'){
                returnAddress = addresslist.ccrz__AddressFirstline__c;
                this.shipaddressfirstline = addresslist.ccrz__AddressFirstline__c + ',';
            }else if(addresType === 'pick'){
                this.pickUpaddressfirstline = addresslist.ccrz__AddressFirstline__c + ',';
                if (!returnAddress) {
                    returnAddress = addresslist.ccrz__AddressFirstline__c;
                } else {
                    //branch name present
                    returnAddress = returnAddress + ',' + addresslist.ccrz__AddressFirstline__c;
                }               
            }
        }
        //city
        if (addresslist.ccrz__City__c) {
            if(addresType === 'ship'){
                this.shipaddresscity = addresslist.ccrz__City__c + ',';
            }else if(addresType === 'pick'){
                this.pickUpaddresscity = addresslist.ccrz__City__c+ ',';
            }            
            if (!returnAddress) {
                //addressline not present
                returnAddress = addresslist.ccrz__City__c;
            } else {
                //addressline present
                returnAddress = returnAddress + ',' + addresslist.ccrz__City__c;
            }            
        }
        //state
        if (addresslist.ccrz__State__c) {
            if(addresType === 'ship'){
                this.shipaddressstate = addresslist.ccrz__State__c + ',';
            }else if(addresType === 'pick'){
                this.pickUpaddressstate = addresslist.ccrz__State__c+ ',';
            }              
            if (!returnAddress) {
                returnAddress = addresslist.ccrz__State__c;
            } else {
                returnAddress = returnAddress + ',' + addresslist.ccrz__State__c;
            }
        }
        //country
        if (addresslist.ccrz__Country__c) {
            if(addresType === 'ship'){                
                this.shipaddresscountry = addresslist.ccrz__Country__c;
            }else if(addresType === 'pick'){
                console.log('BASHKORISTAN > ' + addresslist.ccrz__Country__c);
                this.pickUpaddresscountry = addresslist.ccrz__Country__c;
                console.log('TARTAR > ' + this.pickUpaddresscountry );
            }              
            if (!returnAddress) {
                returnAddress = addresslist.ccrz__Country__c;
            } else {
                returnAddress = returnAddress + ',' + addresslist.ccrz__Country__c;
            }
        }
        //postal code  
        if (addresslist.ccrz__PostalCode__c) {
            if(addresType === 'ship'){
                this.shipaddresscountry = this.shipaddresscountry;
                this.shipaddresspostalCode = addresslist.ccrz__PostalCode__c + ',';
            }else if(addresType === 'pick'){
                this.pickUpaddresscountry = this.pickUpaddresscountry;
                this.pickUpaddresspostalCode = addresslist.ccrz__PostalCode__c + ',';
            }             
            if (!returnAddress) {
                returnAddress = addresslist.ccrz__PostalCode__c;
            } else {
                returnAddress = returnAddress + ',' + addresslist.ccrz__PostalCode__c;
            }
        }

        return returnAddress;

    }


}