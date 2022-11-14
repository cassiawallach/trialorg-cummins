import {
  LightningElement,
  wire,
  track,
  api
} from 'lwc';
import fetchLstOrderDetails from '@salesforce/apex/dbu_OrderCtrl.fetchLstOrderDetails';
import callReturnOrderAPI from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.callReturnOrderAPI';
//import getAddress from '@salesforce/apex/dbu_OrderCtrl.getAddress';
//import getShippingAddress from '@salesforce/apex/dbu_OrderCtrl.getShippingAddress';
//import getProduct from '@salesforce/apex/dbu_OrderCtrl.getProduct';
import communityName from '@salesforce/label/c.dbu_communityName';
import getLoggedInUserInfo from '@salesforce/apex/dbu_LoggedInUserinfo.getLoggedInUserInfo';
import signInURL from '@salesforce/label/c.dbu_login_URL';
import signOutURL from '@salesforce/label/c.dbu_logout_URL';
import registrationURL from '@salesforce/label/c.dbu_registration_URL';
import isGuest from '@salesforce/user/isGuest';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A';
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA';
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada';
//---Importing service component for CurrencyCode prefix--
import { perfixCurrencyISOCode ,validateCookiesData} from 'c/serviceComponent';
//labels starts here//
import dbu_DefaultProductImage from "@salesforce/label/c.dbu_DefaultProductImage";
import dbu_order_confirmation_page_title from "@salesforce/label/c.dbu_order_confirmation_page_title";
import dbu_order_confirmation_page_Thank_you_for_your_order from "@salesforce/label/c.dbu_order_confirmation_page_Thank_you_for_your_order";
import dbu_order_confirmation_page_email_confirmation_msg from "@salesforce/label/c.dbu_order_confirmation_page_email_confirmation_msg";
import dbu_order_confirmation_page_Order_Status from "@salesforce/label/c.dbu_order_confirmation_page_Order_Status";
import dbu_order_confirmation_status_msg from "@salesforce/label/c.dbu_order_confirmation_status_msg";
import dbu_orderConfirmation_print from "@salesforce/label/c.dbu_orderConfirmation_print";
import dbu_order_confirmation_page_accountCreation from "@salesforce/label/c.dbu_order_confirmation_page_accountCreation";
import dbu_order_confirmation_page_manageSettings from "@salesforce/label/c.dbu_order_confirmation_page_manageSettings";
//labels ends here//
import getProductCategoryInCart from '@salesforce/apex/dbu_ProductsCategoriesAndBrands.getProductCategoryInCart';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

export default class Dbu_orderReceipt extends LightningElement {

  @track SignInURL = signInURL;
  @track SignOutURL = signOutURL;
  @track RegistrationURL = registrationURL;
  @track isGuestUser = isGuest;
  @track cartDetails;
  @track orderDetails;
  @track addressDetails;
  @track shippingaddressDetails;
  @track productDetails;
  @track isLoading = true;
  @track IsCustomerLoggedIn;
  @track myAccountURL;
  @track orderId;
  @track openmodel = false;
  @track loggedInUser;
  @track error;
  @track notloggedin= false;
  @track ordersummary;
  @track storeLocationText = 'en-US';
 // @track countryCurrencyCode;
  @api pickup = false;
  @api shipping = false;
  @track relatedProductMap=new Map();
  @track locationData;
  @track orderpagecartId;
//   @track currencyUSD = {
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
  //@track  orderrecordarray = [];
  label = {
    dbu_DefaultProductImage,
    dbu_order_confirmation_page_title,
    dbu_order_confirmation_page_Thank_you_for_your_order,
    dbu_order_confirmation_page_email_confirmation_msg,
    dbu_order_confirmation_page_Order_Status,
    dbu_order_confirmation_status_msg,
    dbu_orderConfirmation_print,
    dbu_order_confirmation_page_accountCreation,
    dbu_order_confirmation_page_manageSettings
};


  get ScreenLoaded() {
      return this.isLoading;
  }

  handleclick(event) {
    invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Go to Track Order - order receipt page'); 
      window.location.href = this.trackOrderURL;
  }
  handleclickAuth(event) {
    invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Go to My Orders - order receipt page'); 
    window.location.href = this.ordersURL;
}
  
  // openmodal() {
  //     this.openmodel = true
  // }
  // closeModal() {
  //     this.openmodel = false
  // }


  connectedCallback() {
    window.location.hash="no-back-button";
    console.log('custom msg from Order Recipt');
      let urlString = window.location.origin;
      
      console.log('trackOrderURL>>>>>>' + this.trackOrderURL);

      let locationURL = window.location.href;
      console.log('locationURL' + locationURL);
      var url = new URL(locationURL);
      if (url.searchParams.get("store") != undefined) {
          this.locationData = window.sessionStorage.getItem('setCountryCode');
      }

      if (url.searchParams.get("cartId") != undefined) {
        this.orderpagecartId = url.searchParams.get("cartId");
      }

      this.trackOrderURL = urlString + communityName + 'track-order?store='+this.locationData;
      this.ordersURL = urlString + communityName + 'my-account?orders=true'+this.locationData;

      
      //console.log('cartIdName ' ,cartIdName);
      
     /* if(this.locationData == storeUSA){
        this.countryCurrencyCode = currencyCodeUSA;
      }else if(this.locationData == storeCA || this.locationData == storeCAF){
            this.countryCurrencyCode = currencyCodeCanada;
      }*/

  }

  handleRegistrationURLclick(){
    invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Registration URL click - order receipt page'); 
  }

  get openregistrationpage(){
      return this.RegistrationURL;
  }

  getCookiesData(name){
    console.log('name ',name);
    var cookiesName;
    var name = name + "=";
    var ca = document.cookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
         c = c.substring(1);
        }
        if (c.indexOf(name) == 0) 
        {
            cookiesName = c.substring(name.length, c.length);
        }
    }

    console.log('cookiesName order ',cookiesName);
    return cookiesName;
}


  // @wire(getLoggedInUserInfo)
  // wirefetchuser({
  //     error,
  //     data
  // }) {
  //     if (data) {
  //         this.IsCustomerLoggedIn = data;
  //         // if(this.IsCustomerLoggedIn==null || this.IsCustomerLoggedIn==undefined)
  //         // { 
  //         //     this.notloggedin = true;
  //         // }
          
  //         console.log('test****' +this.IsCustomerLoggedIn);
  //     } else if (error) {

  //         this.error = error;
  //         this.IsCustomerLoggedIn = undefined;

  //     }
  // }
  //---For Country Currency--Added by Mukesh Gupta---
  /*prefixCountryCurrency(item){
    if(item !== null && item !== undefined){
        if(this.currencyCode === 'USD'){
            return item.toLocaleString('en-US', this.currencyUSD);
        }else if(this.currencyCode === 'CAD'){
            return item.toLocaleString('en-US', this.currencyCAD);
        }

    }else{
        if(this.currencyCode === 'USD'){
            return 0.00.toLocaleString('en-US', this.currencyUSD);
        }else if(this.currencyCode === 'CAD'){
            return 0.00.toLocaleString('en-US', this.currencyCAD);
        }
    }
  }*/
  


  @wire(fetchLstOrderDetails, {
      urlParam: window.location.href
  })
  wireOrder({
      error,
      data
  }) {

      console.log('lstorderdetails', data);
      
      if (data) {

        // Seccurity changes , added by Ranadip
      if(this.isGuestUser){
       let isTrue = validateCookiesData(data[0].sfid);
        if (isTrue) {
            return;
          }
        
        }// End here
          this.orderDetails = data;

    
             
         // console.log('inside pickupaddress' +this.orderDetails[0].dbupickupAddress);
          if(this.orderDetails[0].dbupickupAddress){
              this.pickup=true;
          console.log('inside pickup'+this.pickup);
          }
          else{
              this.shipping=true;
              console.log('else shipping not pickup'+this.shipping);
          }
          window.console.log('inside order receipt' + JSON.stringify(data));
          this.currencyCode = data[0].currencyISOCode; 
          console.log('CurrencyISO COde======'+this.currencyCode);
          let i = 0;

          let orderdetail =[];
          for(i=0;i<data.length;i++)
          { 
              let orderdata ={};
              let items = data[0].items;
             /* if(items!=null && items!=undefined){ 
                  orderdata['items']= items.toLocaleString(this.storeLocationText, {
                      style: 'currency',
                      currency: this.countryCurrencyCode,
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2
                  });
              }*/
              orderdata['items']= perfixCurrencyISOCode(this.currencyCode,items);

              let totalDiscount = data[0].totalDiscount;
             /* if(totalDiscount!=null && totalDiscount!=undefined){
                  orderdata['totalDiscount']= totalDiscount.toLocaleString(this.storeLocationText, {
                      style: 'currency',
                      currency: this.countryCurrencyCode,
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2
                  });
               }*/
               orderdata['totalDiscount']= perfixCurrencyISOCode(this.currencyCode,totalDiscount);
              let subtotalAmount = ((Math.round(data[0].subtotalAmount * 100) / 100).toFixed(2))*1;
             /* if(subtotalAmount!=null && subtotalAmount!=undefined){ 
                  orderdata['subtotalAmount']= subtotalAmount.toLocaleString(this.storeLocationText, {
                      style: 'currency',
                      currency: this.countryCurrencyCode,
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2
                  });
              }*/
              orderdata['subtotalAmount']=  perfixCurrencyISOCode(this.currencyCode,subtotalAmount);
              let taxAmount = data[0].taxAmount;
             /* if(taxAmount!=null && taxAmount!=undefined){
                  orderdata['taxAmount']= taxAmount.toLocaleString(this.storeLocationText, {
                      style: 'currency',
                      currency: this.countryCurrencyCode,
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2
                  });
               }*/
               orderdata['taxAmount']= perfixCurrencyISOCode(this.currencyCode,taxAmount);
              let shipAmount = data[0].shipAmount;
            /*  if(shipAmount!=null && shipAmount!=undefined){
                  orderdata['shipAmount']= shipAmount.toLocaleString(this.storeLocationText, {
                      style: 'currency',
                      currency: this.countryCurrencyCode,
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2
                  });
               }*/
               orderdata['shipAmount']= perfixCurrencyISOCode(this.currencyCode,shipAmount);
              let totalAmount = data[0].totalAmount;
             /* if(totalAmount!=null && totalAmount!=undefined){
                  orderdata['totalAmount']= totalAmount.toLocaleString(this.storeLocationText, {
                      style: 'currency',
                      currency: this.countryCurrencyCode,
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2
                  });
               }*/
               orderdata['totalAmount']= perfixCurrencyISOCode(this.currencyCode,totalAmount);

              orderdetail.push(orderdata);
          }

          console.log('orderdetail'+JSON.stringify(orderdetail));
          this.ordersummary = orderdetail;


          let orderrecordarray = [];
          console.log('data[0].productlist.length=>' + data[0].productlist);
          window.console.log('data[0].productlist.length=>' + data[0].productlist.length);
          this.orderId = data[0].sfid;
          console.log('this.orderId=>', this.orderId);

          
         

        /*  for (i = 0; i < data[0].productlist.length; i++) {
              let orderrecord = {};
                 orderrecord['id'] = data[0].productlist[i].sfid;
              orderrecord['sfdcName'] = data[0].productlist[i].sfdcName;
              orderrecord['isCoreProduct'] = data[0].productlist[i].isCoreProduct;
              console.log('isCoreProduct', orderrecord['isCoreProduct']);
              orderrecord['URI'] = data[0].productlist[i].EProductMediasS[0].URI;
              orderrecord['quantity'] = data[0].EOrderItemsS[i].quantity;

              
              let price =  data[0].EOrderItemsS[i].price;
              orderrecord['price'] = price.toLocaleString(this.storeLocationText, {
                  style: 'currency',
                  currency: this.currencyValue,
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
              });
             
             // orderrecord['price'] = data[0].EOrderItemsS[i].price;
             let subAmount =  data[0].EOrderItemsS[i].subAmount;
             orderrecord['subAmount'] = subAmount.toLocaleString(this.storeLocationText, {
              style: 'currency',
              currency: this.currencyValue,
              minimumFractionDigits: 2,
              maximumFractionDigits: 2
          });
              //orderrecord['subAmount'] = data[0].EOrderItemsS[i].subAmount;
              orderrecord['orderItemStatus'] = data[0].EOrderItemsS[i].orderItemStatus;
              orderrecordarray.push(orderrecord);
              window.console.log('i=>' + i);

          }*/
          //-----------Updated Code---------------------------------

          var productMap = new Map();
           //-------- Adding related products in Map
        /*   console.log('data[0].relatedProducts.length=='+data[0].relatedProducts.length);
           for (let i = 0; i < data[0].relatedProducts.length; i++) {
            this.relatedProductMap.set(data[0].relatedProducts[i].ccrz__Product__c, data[0].relatedProducts[i]);
            }*/
          //-------- Adding products in Map
          for (let i = 0; i < data[0].productlist.length; i++) {
              productMap.set(data[0].productlist[i].sfid, data[0].productlist[i]);
          }
          
          for (let i = 0; i < data[0].EOrderItemsS.length; i++) {
              let orderrecord = {};
              orderrecord['quantity'] = data[0].EOrderItemsS[i].quantity;
              let price = data[0].EOrderItemsS[i].price;
             /* orderrecord['price'] = price.toLocaleString(this.storeLocationText, {
                      style: 'currency',
                      currency: this.countryCurrencyCode,
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2
                  });*/
                  price = ((Math.round(price * 100) / 100).toFixed(2)) * 1;
                  orderrecord['price'] = perfixCurrencyISOCode(this.currencyCode,price);
              let subAmount = data[0].EOrderItemsS[i].subAmount;
            /*  orderrecord['subAmount'] = subAmount.toLocaleString(this.storeLocationText, {
                      style: 'currency',
                      currency: this.countryCurrencyCode,
                      minimumFractionDigits: 2,
                      maximumFractionDigits: 2
                  });*/
                  subAmount = ((Math.round(subAmount * 100) / 100).toFixed(2)) * 1;
                  orderrecord['subAmount'] = perfixCurrencyISOCode(this.currencyCode,subAmount);
             // orderrecord['subAmount'] = data[0].EOrderItemsS[i].subAmount;
              orderrecord['orderItemStatus'] = data[0].EOrderItemsS[i].orderItemStatus;
          

              

              if (productMap.has(data[0].EOrderItemsS[i].prodId)) {

                let urlString = window.location.origin;
              let locationURL = window.location.href;
            console.log('locationURL' + locationURL);
            var url = new URL(locationURL);
            if (url.searchParams.get("store") != undefined) {
                this.locationData = window.sessionStorage.getItem('setCountryCode');
            }  

            let prodName = productMap.get(data[0].EOrderItemsS[i].prodId).sfdcName;
            if(prodName.includes('/')){
                prodName = prodName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
              }
            let finalURL =  urlString + communityName +'product/'+data[0].EOrderItemsS[i].prodId +'/'+ prodName;  
            //let finalURL = urlString + communityName + 'product?name=' + productMap.get(data[0].EOrderItemsS[i].prodId).sfdcName+ '&pId='+ data[0].EOrderItemsS[i].prodId+ '&store=' + this.locationData;


            orderrecord['prodURL'] = finalURL;
                  orderrecord['sfdcName'] = productMap.get(data[0].EOrderItemsS[i].prodId).sfdcName;
                  if(productMap.get(data[0].EOrderItemsS[i].prodId).EProductMediasS[0] !== undefined){
                    console.log('INNER IF BLOCK');
                  orderrecord['URI'] = productMap.get(data[0].EOrderItemsS[i].prodId).EProductMediasS[0].URI;
                }else{
                  console.log('INNER ELSE BLOCK');
                  orderrecord['URI'] =  dbu_DefaultProductImage;
                }
                  orderrecord['id'] = productMap.get(data[0].EOrderItemsS[i].prodId).sfid;
                  orderrecord['isCoreProduct'] = productMap.get(data[0].EOrderItemsS[i].prodId).isCoreProduct;
              }
              if (productMap.get(data[0].EOrderItemsS[i].prodId).hasCoreCharge === true && productMap.get(data[0].EOrderItemsS[i].prodId).coreChargeAmount !== undefined) {

                orderrecord['coreCharge'] = true;
            }
              orderrecordarray.push(orderrecord);
          }
           //------Push records in array in sequence if core product exist----------//
         /*  let itemInSequence = [];
           console.log('orderrecordarray.length==='+orderrecordarray.length);
           for(let i=0; i<orderrecordarray.length ;i++){
               console.log('orderrecordarray[i].parentCoreCharge'+orderrecordarray[i].parentCoreCharge);
               if(orderrecordarray[i].parentCoreCharge){
                   let relatedCoreProdId = this.relatedProductMap.get(orderrecordarray[i].id).ccrz__RelatedProduct__c;
                   console.log('relatedCoreProdId=='+relatedCoreProdId);
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
           var itemsArray = [...new Set(itemInSequence)];
           console.log('itemArray=='+itemsArray.length);*/
       //----------------------------------------------------------------------//
          //--------------------------------------------------------
          window.console.log('inside order orderrecord=>' + JSON.stringify(orderrecordarray));

          this.cartDetails = orderrecordarray;

          window.console.log('inside order orderrecord=>' + JSON.stringify(this.orderDetails));

          this.isLoading = false;

          console.log('nackchivan > ' + typeof window.localStorage.getItem('googleanalyticsOrderReview'));
          console.log('zangezur > ' + window.localStorage.getItem('googleanalyticsOrderReview'))
           if( window.localStorage.getItem('googleanalyticsOrderReview') === 'true'){
                console.log('nagorno');
                
                invokeGoogleAnalyticsService('ORDER RECIEPT CHECKOUT', {orderinformation : this.orderDetails, currencycode : this.currencyCode}); 

                getProductCategoryInCart({
                    urlParam : window.location.href
                }).then(resultcat => {                    
                    console.log('resultcat ? ' + JSON.stringify(resultcat));
                    console.log('karabakh');
                    window.localStorage.setItem('googleanalyticsOrderReview', false);
                    console.log('armenia > ' + window.localStorage.getItem('googleanalyticsOrderReview'));
                    
                    if(resultcat.length > 0){
                        invokeGoogleAnalyticsService('ORDER CONFIRMATION', {categoryinfo : resultcat, orderinformation :  this.orderDetails, currencycode : this.currencyCode}); 
                    }else{
                        invokeGoogleAnalyticsService('ORDER CONFIRMATION', {categoryinfo : [], orderinformation :  this.orderDetails, currencycode : this.currencyCode}); 
                    }                        
                }).catch(error => {
                    this.error = error.message;                    
                }); 
                window.localStorage.setItem('googleanalyticsOrderReview', false);
                console.log('armenia > ' + window.localStorage.getItem('googleanalyticsOrderReview'));                                       
           }                    

      } else if (error) {

          this.error = error;
          this.cartDetails = undefined;
          this.orderDetails = undefined;
      }

  }


  printPage() {
      window.print();
      invokeGoogleAnalyticsService('BUTTON CLICK', {EventAction : 'Print button click on order receipt page', eventName : 'Print order receipt'});
  }
  /*
  @wire(getAddress)
  wireAddress({ error, data }) {
     
      if (data) {
          
          window.console.log('data>>>>>>>>>>',(data));
          this.addressDetails = data;  
          
          
      } else if (error) {
          
          this.error = error;
          this.addressDetails = undefined;
      }
      
  }
  @wire(getShippingAddress)
  wireshippingAddress({ error, data }) {
     
      if (data) {
          
          window.console.log('data>>>>>>>>>>',(data));
          this.shippingaddressDetails = data;  
          
          
      } else if (error) {
          
          this.error = error;
          this.shippingaddressDetails = undefined;
      }
      
  }
  @wire(getProduct)
  wireproduct({ error, data }) {
     
      if (data) {
          
          window.console.log('data>>>>>>>>>>',(data));
          this.productDetails = data;  
          
          
      } else if (error) {
          
          this.error = error;
          this.productDetails = undefined;
      }
      
  }*/


  onOrderCancel(event) {
      this.isQtyLoading = true;
      console.log('onOrderCancel this.orderId=======>' + this.orderId);
      //console.log('onProductDelete cartIdCookie=============>'+this.cartId)
      callReturnOrderAPI({
              orderId: this.orderId
          })
          .then(result => {
              // // Clear the user enter values
              window.console.log('In onOrderCancel result ===> ' + result);
              // //this.createCookie('In onProductDelete cartId', result[0].cartId, 1);
              // pubsub.fire('fetchcartevt', result );
              // window.console.log('After fire eventresult ===> ' + result);
              // this.isQtyLoading = false;

          })
          .catch(error => {
              this.error = error.message;
          });
  }
}