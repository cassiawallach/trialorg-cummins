import { LightningElement,wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import viewInvoiceData from '@salesforce/apex/dbu_ViewInvoiceDetails.viewInvoiceData';
import {perfixCurrencyISOCode,validateCookiesData } from 'c/serviceComponent';
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA'; // custom label refres to'USD'
import returnOrderWrongPart from '@salesforce/label/c.dbu_Return_Ordered_the_wrong_part';
import returnPartNoLongerWanted from '@salesforce/label/c.dbu_Return_Part_no_longer_wanted';
import dbu_orderinvoice from '@salesforce/label/c.dbu_orderinvoice';
import dbu_orderConfirm_orderNumber from '@salesforce/label/c.dbu_orderConfirm_orderNumber';
import dbu_myAccount_orderDate from '@salesforce/label/c.dbu_myAccount_orderDate';
import dbu_orderConfirmation_shippingAddress from '@salesforce/label/c.dbu_orderConfirmation_shippingAddress';
import dbu_reviewPage_billingAddress from '@salesforce/label/c.dbu_reviewPage_billingAddress';
import dbu_orderConfirmation_paymentMethod from '@salesforce/label/c.dbu_orderConfirmation_paymentMethod';
import dbu_reviewPage_orderSummary from '@salesforce/label/c.dbu_reviewPage_orderSummary';
import dbu_reviewPage_subTotal from '@salesforce/label/c.dbu_reviewPage_subTotal';
import dbu_shopCart_discount from '@salesforce/label/c.dbu_shopCart_discount';
import dbu_Return_EstTax from '@salesforce/label/c.dbu_Return_EstTax';
import dbu_orderConfirmation_shippingCost from '@salesforce/label/c.dbu_orderConfirmation_shippingCost';
import dbu_orderConfirmation_total from '@salesforce/label/c.dbu_orderConfirmation_total';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A';
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';
import invoiceusa from '@salesforce/label/c.dbu_invoice_usa';
import invoicecanada from '@salesforce/label/c.dbu_invoice_canada';
import pickUpAddress from '@salesforce/label/c.dbu_orderConfirmation_PickUpFromStore';
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada'; //custom label refres to'CAD'
import dbu_GST_Number_Text from '@salesforce/label/c.dbu_GST_Number_Text';
import Dbu_Canada_GST_Number from '@salesforce/label/c.Dbu_Canada_GST_Number';
import Dbu_US_GST_Number from '@salesforce/label/c.Dbu_US_GST_Number';
import signInURL from '@salesforce/label/c.dbu_login_URL';
import isGuest from '@salesforce/user/isGuest';
import dbu_Ship_to_Address_Product from '@salesforce/label/c.dbu_Ship_to_Address_Product_OrderConfirmation';
import dbu_Pick_up_from_Store_Product from '@salesforce/label/c.dbu_Pick_up_from_Store_Product_OrderConfirmation';


export default class Dbu_invoice extends LightningElement {

    @track wrapperData;
    @track isLoading = true;
    @track orderrecordarray = [];
    @track invoiceItemArray;
    @track productOrderedArray = [];
    @track returnOrderedArray = [];
    @track pickupOnlyProductArray = [];
    @track isProductOrdered = false;
    @track isPickupOnly = false;
    @track isReturnOrderd = false;
    @track currencyCode ;
    @track isLoaded = false;
    @track isUSD = false;
    @track isAddressTwoAvailable;
    @track orderinvoice = dbu_orderinvoice;
    @track ordernumber = dbu_orderConfirm_orderNumber;
    @track orderdate = dbu_myAccount_orderDate;
    @track shippingaddress = dbu_orderConfirmation_shippingAddress;
    @track billingaddress = dbu_reviewPage_billingAddress;
    @track paymentmethod = dbu_orderConfirmation_paymentMethod;
    @track ordersummary = dbu_reviewPage_orderSummary;
    @track subtotal = dbu_reviewPage_subTotal;
    @track discount = dbu_shopCart_discount;
    @track esttax = dbu_Return_EstTax;
    @track shippingcost = dbu_orderConfirmation_shippingCost;
    @track total = dbu_orderConfirmation_total;
    @track isPickUpAddress = false;
    @track isShipToAddress = false;
    @track pickUpAddress = pickUpAddress;
    @track mapData = [];
    @track storeLanguage;
    @track storeCountry;
    @track countryCurrencyCode;    

    @track dbu_GST_Number_Text = dbu_GST_Number_Text;
    @track Dbu_Canada_GST_Number = Dbu_Canada_GST_Number;
    @track Dbu_US_GST_Number = Dbu_US_GST_Number;
    @track gstNumberToDisplay;
    @track gstAvailable;
   // @track currencyValue = currencyCodeUSA;
   label = {
    currencyCodeUSA,
    returnOrderWrongPart,
    returnPartNoLongerWanted,
    dbu_Pick_up_from_Store_Product,
    dbu_Ship_to_Address_Product
};

    get ScreenLoaded()
    {
        return this.isLoading;
    }
    
    connectedCallback(){

      this.storeLanguage = window.sessionStorage.getItem('setCountryCode');
      if(this.storeLanguage == storeUSA || 
          this.storeLanguage == undefined ||
          this.storeLanguage == null || this.storeLanguage == ''){
          this.storeCountry = storeUSA;
          this.countryCurrencyCode = currencyCodeUSA;
          this.storeLanguage = storeUSA;   
          console.log('Dbu_US_GST_Number > ' + Dbu_US_GST_Number);  
          console.log('Dbu_US_GST_Number type > ' + typeof Dbu_US_GST_Number);  
          if(Dbu_US_GST_Number != 'null'){
              console.log('inside GST US> ' + Dbu_US_GST_Number);
              this.gstNumberToDisplay = Dbu_US_GST_Number;
              this.gstAvailable = true;
          }
      }else if(this.storeLanguage == storeCA || this.storeLanguage == storeCAF){
          this.storeCountry = storeCanada; 
          this.countryCurrencyCode = currencyCodeCanada;            
          if(Dbu_Canada_GST_Number != 'null'){
              this.gstNumberToDisplay = Dbu_Canada_GST_Number;
              this.gstAvailable = true;
          }            
      }        



  }


    @track orderIdtoPassForTaxBreakUp;
    @track taxAgainstCloneOrderMap;
    @wire(viewInvoiceData,{urlParam: window.location.href})
    wireInvoice({ error, data }) {
        console.log('fetchProductById=>urlParam:window.location.href=>'+window.location.href);        
        if (data) {
          // Scurity changes , added by Ranadip	
      if (this.isGuestUser) {	
        let isTrue = validateCookiesData(data.orderId);	
        console.log('isTrue ', isTrue);	
        if (isTrue) {	
          return;	
        }	
      }	
      // end here
          this.isLoading = false;
          this.isLoaded = true;
          /*****Added by Harish to redirect to login if user dont have order access*******/
          if(!data.isOrderAccesible){
            window.location.href=signInURL;
          }
          else{
          this.wrapperData = data;
          let orderrecord ={};
          
          console.log('wrapperdata'+JSON.stringify(this.wrapperData))
          //Order details
          this.orderIdtoPassForTaxBreakUp = this.wrapperData.orderId;
          console.log('this.orderIdtoPassForTaxBreakUp > ' + this.orderIdtoPassForTaxBreakUp);
          this.taxAgainstCloneOrderMap = this.wrapperData.taxAgainstCloneOrderName;
          this.currencyCode = this.wrapperData.orderCurrency;
          orderrecord['dateinfo'] = this.wrapperData.dateinfo;
          if(this.currencyCode == currencyCodeUSA){
            this.isUSD = true;
          }
          if(this.wrapperData.paymentType == undefined || this.wrapperData.paymentType == null){
            orderrecord['paymentType'] = '';
          }else{
            orderrecord['paymentType'] = this.wrapperData.paymentType;
          }
          orderrecord['name'] = this.wrapperData.name;
          orderrecord['lastName'] = this.wrapperData.lastName;
          orderrecord['orderNumber'] = this.wrapperData.orderNumber;
          orderrecord['emailID'] = this.wrapperData.emailID;
          orderrecord['phone'] = this.wrapperData.phone;
          let orderDate = this.wrapperData.orderDate;
          let date = new Date(orderDate);
                  let dtOption = {
                      year: 'numeric',
                      month: 'long',
                      day: '2-digit'
                  };
          orderrecord['orderDate'] = date.toLocaleString('en-US', dtOption);
          //orderrecord['orderDate'] = this.wrapperData.orderDate;

          //if(this.wrapperData.totalAmount == undefined){
            // orderrecord['totalAmount']  = '$0.00';
         // }else{
             //orderrecord['totalAmount'] = this.wrapperData.totalAmount.toLocaleString('en-US', {
              // minimumFractionDigits: 2,
              // maximumFractionDigits: 2,
              // style: 'currency',
             //  currency: 'USD'
            // });
         // }
         orderrecord['totalAmount'] = perfixCurrencyISOCode(this.currencyCode,this.wrapperData.totalAmount);
          /*if(this.wrapperData.subTotalAmount == undefined){
             orderrecord['subTotalAmount'] = '$0.00';
          }else{
             orderrecord['subTotalAmount'] = this.wrapperData.subTotalAmount.toLocaleString('en-US', {
               minimumFractionDigits: 2,
               maximumFractionDigits: 2,
               style: 'currency',
               currency: 'USD'
             });
          }*/
          orderrecord['subTotalAmount'] = perfixCurrencyISOCode(this.currencyCode,this.wrapperData.subTotalAmount);
          /*if(this.wrapperData.discountAmount == undefined){
             orderrecord['discountAmount'] = '$0.00';
          }else{
             orderrecord['discountAmount'] = this.wrapperData.discountAmount.toLocaleString('en-US', {
               minimumFractionDigits: 2,
               maximumFractionDigits: 2,
               style: 'currency',
               currency: 'USD'
            });
          }*/
          orderrecord['discountAmount'] = perfixCurrencyISOCode(this.currencyCode,this.wrapperData.discountAmount);
          /*if(this.wrapperData.estimatedTax == undefined){
            orderrecord['estimatedTax'] = '$0.00';
          }else{
            orderrecord['estimatedTax'] = this.wrapperData.estimatedTax.toLocaleString('en-US', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
              style: 'currency',
              currency: 'USD'
            });
          }*/
          //-----------------------
          // var taxValues = this.wrapperData.taxMap; 
          // for(var key in taxValues){
          //  let taxAmountWithCurrency =  perfixCurrencyISOCode(this.currencyCode,taxValues[key]);
          //     this.mapData.push({value:taxAmountWithCurrency, key:key}); //Here we are creating the array to show on UI.
          // }
          //--------------------------
          orderrecord['estimatedTax'] = perfixCurrencyISOCode(this.currencyCode,this.wrapperData.estimatedTax);

          if(this.wrapperData.shippingCost == undefined || this.wrapperData.shippingCost == 0.00 || this.wrapperData.shippingCost == 0){
            orderrecord['shippingCost'] = 'FREE';
          }else{
            /*orderrecord['shippingCost'] = this.wrapperData.shippingCost.toLocaleString('en-US', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
              style: 'currency',
              currency: 'USD'
          });*/
          orderrecord['shippingCost'] = perfixCurrencyISOCode(this.currencyCode,this.wrapperData.shippingCost);
          }
          
          
          //Shipping Address
         // orderrecord['shipAddressFirstName'] = this.wrapperData.shipAddress.firstName;
         // orderrecord['shipAddressLastName'] = this.wrapperData.shipAddress.lastName;
         console.log('isPickUpAddress====='+this.wrapperData.isPickUpAddress)
         if(this.wrapperData.isPickUpAddress){
          this.isPickUpAddress = true;
         }
         console.log('shipAddress1==='+this.wrapperData.shipAddress.address1)
          orderrecord['shipAddress1'] = this.wrapperData.shipAddress.address1;
          if(this.wrapperData.shipAddress.address2 == 'NULL' || this.wrapperData.shipAddress.address2 == undefined){
            this.isAddressTwoAvailable = false;
          }else{
            this.isAddressTwoAvailable = true;
            orderrecord['shipAddress2'] = this.wrapperData.shipAddress.address2;
          }
          
          //orderrecord['shipAddress3'] = this.wrapperData.shipAddress.address3;
          orderrecord['shipAddressCity'] = this.wrapperData.shipAddress.city;
          orderrecord['shipAddressState'] = this.wrapperData.shipAddress.state;
          orderrecord['shipAddressPostalCode'] = this.wrapperData.shipAddress.postalCode;
          if(this.wrapperData.shipAddress.country == storeUSA){
            orderrecord['shipAddressCountry'] = invoiceusa;
          }else if(this.wrapperData.shipAddress.country == storeCA){
            orderrecord['shipAddressCountry'] = invoicecanada;
          }else{
            orderrecord['shipAddressCountry'] = this.wrapperData.shipAddress.country;
          }
        
          //=============Pickup from store address inventory Changes ========
        /*  if(this.wrapperData.isPickUpAddress){
            this.isPickUpAddress = true;
         

         orderrecord['pickupAddress1'] = this.wrapperData.storeAddress.address1;
         if(this.wrapperData.storeAddress.address2 == 'NULL' || this.wrapperData.storeAddress.address2 == undefined){
           this.isAddressTwoAvailable = false;
         }else{
           this.isAddressTwoAvailable = true;
           orderrecord['pickupAddress2'] = this.wrapperData.storeAddress.address2;
         }
         
         //orderrecord['shipAddress3'] = this.wrapperData.shipAddress.address3;
         orderrecord['pickupCity'] = this.wrapperData.storeAddress.city;
         orderrecord['pickupState'] = this.wrapperData.storeAddress.state;
         orderrecord['pickupPostalCode'] = this.wrapperData.storeAddress.postalCode;
         if(this.wrapperData.storeAddress.country == storeUSA){
           orderrecord['pickupCountry'] = invoiceusa;
         }else if(this.wrapperData.storeAddress.country == storeCA){
           orderrecord['pickupCountry'] = invoicecanada;
         }else{
           orderrecord['pickupCountry'] = this.wrapperData.storeAddress.country;
         }
        }*/
          //===================================================
          //Billing Address
         // orderrecord['billAddressFirstName'] = this.wrapperData.billAddress.firstName;
         // orderrecord['billAddressLastName'] = this.wrapperData.billAddress.lastName;
          orderrecord['billAddress1'] = this.wrapperData.billAddress.address1;
          if(this.wrapperData.billAddress.address2 == 'NULL' || this.wrapperData.billAddress.address2 == undefined){
            this.isBillAddressTwoAvailable = false;
          }else{
            this.isBillAddressTwoAvailable = true;
            orderrecord['billAddress2'] = this.wrapperData.billAddress.address2;
          }
          
          //orderrecord['billAddress3'] = this.wrapperData.billAddress.address3;
          orderrecord['billAddressCity'] = this.wrapperData.billAddress.city;
          orderrecord['billAddressState'] = this.wrapperData.billAddress.state;         
          orderrecord['billAddressPostalCode'] = this.wrapperData.billAddress.postalCode;

          if(this.wrapperData.billAddress.country == storeUSA){
            orderrecord['billAddressCountry'] = invoiceusa;
          }else if(this.wrapperData.billAddress.country == storeCA){
            orderrecord['billAddressCountry'] = invoicecanada;
          }else{
            orderrecord['billAddressCountry'] = this.wrapperData.billAddress.country;
          }
          
          this.orderrecordarray.push(orderrecord);
          let invoiceItemRecordArray = [];
          for(let i=0;i<this.wrapperData.invoiceDetails.length;i++){
              for(let j = 0 ; j<this.wrapperData.invoiceDetails[i].invoiceLineItem.length; j++){
                  let invoiceItemRecord ={};
                  //---Date in format ---Added by Mukesh Gupta----(02-12-2020)-------
                  let dateVal = this.wrapperData.invoiceDetails[i].invoiceDate;
                  let date = new Date(dateVal);
                  let dtOptions = {
                      year: 'numeric',
                      month: 'long',
                      day: '2-digit'
                  };
                  invoiceItemRecord['invoiceDate'] = date.toLocaleString('en-US', dtOptions);
                  //------------------------------------------------
                //  invoiceItemRecord['invoiceDate'] = this.wrapperData.invoiceDetails[i].invoiceDate;
                  invoiceItemRecord['invoiceNumber'] = this.wrapperData.invoiceDetails[i].invoiceNumber;
                  let quantity;
                  if(this.wrapperData.invoiceDetails[i].invoiceLineItem[j].quantity == undefined){
                    quantity = 0;
                  }else{
                    quantity = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].quantity;
                  }
                  invoiceItemRecord['quantity'] = quantity;
                  invoiceItemRecord['productName'] = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].productName;
                  invoiceItemRecord['proImage'] = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].proImage;
                  invoiceItemRecord['id'] = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].Id;

                   //Added by Mukesh --27-Sep for Inventory Change=====
                   invoiceItemRecord['isShipTo'] = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].isShipTo;

                  //=================================
                  /*if(this.wrapperData.invoiceDetails[i].invoiceLineItem[j].refundAmount == undefined){
                    invoiceItemRecord['refundAmount'] = '$0.00';
                  }else{
                    invoiceItemRecord['refundAmount'] = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].refundAmount.toLocaleString('en-US', {
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2,
                      style: 'currency',
                      currency: 'USD'
                   });
                  }*/
                  invoiceItemRecord['refundAmount'] = perfixCurrencyISOCode(this.currencyCode,this.wrapperData.invoiceDetails[i].invoiceLineItem[j].refundAmount);
                  let unitprice;
                  if(this.wrapperData.invoiceDetails[i].invoiceLineItem[j].unitPrice == undefined){
                    //invoiceItemRecord['unitPrice'] = '$0.0';
                    unitprice = 0.00;
                  }else{
                    /*invoiceItemRecord['unitPrice'] = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].unitPrice.toLocaleString('en-US', {
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2,
                      style: 'currency',
                      currency: 'USD'
                  });*/
                     //invoiceItemRecord['unitPrice'] = perfixCurrencyISOCode(this.currencyCode,this.wrapperData.invoiceDetails[i].invoiceLineItem[j].unitPrice);
                     unitprice = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].unitPrice;
                  }
                  invoiceItemRecord['unitPrice'] = perfixCurrencyISOCode(this.currencyCode,unitprice);
                  let discount;
                  if(this.wrapperData.invoiceDetails[i].invoiceLineItem[j].unitDiscountedPrice == undefined){
                    //invoiceItemRecord['unitDiscountedPrice'] = '$0.00';
                     discount = 0.00;
                  }else{
                    discount = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].unitDiscountedPrice;
                    
                    
                    /*invoiceItemRecord['unitDiscountedPrice'] = discount.toLocaleString('en-US', {
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2,
                      style: 'currency',
                      currency: 'USD'
                  });*/
                  }
                  invoiceItemRecord['unitDiscountedPrice'] = perfixCurrencyISOCode(this.currencyCode,discount);

                  if(this.wrapperData.invoiceDetails[i].invoiceLineItem[j].returnableOrNot == true){
                    invoiceItemRecord['returnableOrNot'] = 'No';
                  }else if(this.wrapperData.invoiceDetails[i].invoiceLineItem[j].returnableOrNot == false){
                    invoiceItemRecord['returnableOrNot'] = 'Yes';
                  }
                  let taxAmount;
                  if(this.wrapperData.invoiceDetails[i].invoiceLineItem[j].taxAmount == undefined){
                    //invoiceItemRecord['taxAmount'] = '$0.00';
                      taxAmount = 0.00;
                  }else{
                   // taxAmount = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].taxAmount/quantity;
                   taxAmount = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].taxAmount;
                    console.log('taxAmount ' + taxAmount);
                    /*invoiceItemRecord['taxAmount'] = taxAmount.toLocaleString('en-US', {
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2,
                      style: 'currency',
                      currency: 'USD'
                  });*/
                  }
                  invoiceItemRecord['taxAmount'] = perfixCurrencyISOCode(this.currencyCode,taxAmount);
                  
                  let total = (unitprice * quantity) + taxAmount;
                  let totalAmnt = total - discount;
                  /*if(totalAmnt == null || totalAmnt == undefined){
                    invoiceItemRecord['totalAmount'] = '$0.00';
                  }else{
                    invoiceItemRecord['totalAmount'] = totalAmnt.toLocaleString('en-US', {
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2,
                      style: 'currency',
                      currency: 'USD'
                  });
                  }*/
                  invoiceItemRecord['totalAmount'] = perfixCurrencyISOCode(this.currencyCode,totalAmnt);
                  
                  let returnReason = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].reasonOfReturn;
                  //if(returnReason == 'Part no longer wanted' || returnReason == 'Ordered the wrong part'){
                  if(returnReason == returnPartNoLongerWanted || returnReason == returnOrderWrongPart){
                    invoiceItemRecord['returnReason'] = true;
                  }else{
                    invoiceItemRecord['returnReason'] = false;
                  }
                  invoiceItemRecord['returnedOrNot'] = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].returnedOrNot;

                  // ---Display msg of core product ----Added by Mukesh Gupta ---02-12-2020------//
                  let hasCoreCharge = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].hasCoreCharge;
                  let hasCoreChargeAmount = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].hasCoreChild;
                  if(hasCoreCharge && hasCoreChargeAmount){
                    invoiceItemRecord['coreCharge'] = true;
                  }

                  // ---Display 10% handling fee for core product-----Added by Mukesh Gupta ---02-12-2020------//
                  let daysSinceOrderDate = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].daysSinceOrderDate;
                  if(daysSinceOrderDate > 45 && hasCoreCharge === true && hasCoreChargeAmount){
                    invoiceItemRecord['coreChargeHandlingFee'] = true;
                  }

                  //---Calculate est tax as per return qty---Added by Mukesh Gupta ---02-12-2020------//
                 let originalQty = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].originalQty;
                 let returnTaxAmount;
                  if(this.wrapperData.invoiceDetails[i].invoiceLineItem[j].taxAmount == undefined){
                    //invoiceItemRecord['returnTaxAmount'] = '$0.00';
                    returnTaxAmount = 0.00;
                  }else{
                   let taxOnPerQty = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].taxAmount/originalQty;
                    returnTaxAmount = taxOnPerQty * this.wrapperData.invoiceDetails[i].invoiceLineItem[j].quantity;
                    /*invoiceItemRecord['returnTaxAmount'] = returnTaxAmount.toLocaleString('en-US', {
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2,
                      style: 'currency',
                      currency: 'USD'
                  });*/
                  }
                  invoiceItemRecord['returnTaxAmount'] = perfixCurrencyISOCode(this.currencyCode,returnTaxAmount);

                  //------------------------------------------------------------------------------
                  let returnDisCountAmnt;
                  if(this.wrapperData.invoiceDetails[i].invoiceLineItem[j].unitDiscountedPrice == undefined){
                    //invoiceItemRecord['returnDisCountAmnt'] = '$0.00';
                    returnDisCountAmnt = 0.00;
                  }else{
                   let discountOnPerQty = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].unitDiscountedPrice/originalQty;
                   returnDisCountAmnt = discountOnPerQty * this.wrapperData.invoiceDetails[i].invoiceLineItem[j].quantity;
                   /* invoiceItemRecord['returnDisCountAmnt'] = returnDisCountAmnt.toLocaleString('en-US', {
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2,
                      style: 'currency',
                      currency: 'USD'
                  });*/
                  }
                  invoiceItemRecord['cloneOrderId'] = this.wrapperData.invoiceDetails[i].invoiceLineItem[j].cloneOrderId;
                  invoiceItemRecord['returnDisCountAmnt'] = perfixCurrencyISOCode(this.currencyCode,returnDisCountAmnt);

                  invoiceItemRecordArray.push(invoiceItemRecord);
              }
              
          }
          this.invoiceItemArray = invoiceItemRecordArray;
          for(let i = 0 ; i< this.invoiceItemArray.length ; i++){
            let productOrderedRecord = {};
            let returnOrderedRecord = {};
            if(this.invoiceItemArray[i].returnedOrNot == false){
                productOrderedRecord = this.invoiceItemArray[i];
                if(this.invoiceItemArray[i].isShipTo === true){     // inventory Change
                  this.productOrderedArray.push(productOrderedRecord); 
                  this.isProductOrdered = true;

                }else{
                  this.pickupOnlyProductArray.push(productOrderedRecord);
                  this.isPickupOnly = true;
                }
            }else{
                returnOrderedRecord = this.invoiceItemArray[i];
                this.returnOrderedArray.push(returnOrderedRecord);
                this.isReturnOrderd = true;
            }           
          }                                    
        
          }
        } else if (error) {
            console.log('fetchProductById Error>>>'+ JSON.stringify(error));
        }
    }

    printPage() {
      window.print();
  }
    downloadInvoice(){
      
      
      
      let testURL = window.location.href;
      let newURL = new URL(testURL).searchParams;
      let orderId = newURL.get('orderid');
      console.log('id ===> '+newURL.get('orderid'));
      let urlString = window.location.origin;
      // let redirectURL =  urlString+communityName+'Reviewreturn?orderid='+ this.orderId;   
       window.open(urlString+'/CSSNAStore/apex/Dbu_Download_Invoice_wrapper?orderId='+orderId);
      /*
      console.log("Sharad Testing start here");
      this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
            url: '/apex/Dbu_Download_Invoice_wrapper'
        }
    }).then(url => {
      
  });
  */
    console.log("Sharad Testing end here");
    /*
      var a = document.body.appendChild(
        document.createElement("a")
     );
    a.download = "newfile.html";
    a.href = "data:text/html," + document.getElementById("content").innerHTML;
    a.click(); //Trigger a click on the element
        */
  }
    
  

}