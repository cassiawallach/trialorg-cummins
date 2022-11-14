import { LightningElement, wire,track} from 'lwc';
import myResource from '@salesforce/resourceUrl/cloudMVP';
import communityName from '@salesforce/label/c.dbu_communityName';
import fetchRecentLstProducts from '@salesforce/apex/dbu_ProductCtrl.fetchRecentLstProducts';
import {
    NavigationMixin
} from 'lightning/navigation';
//---Importing service component for CurrencyCode prefix--
import {perfixCurrencyISOCode} from 'c/serviceComponent';
import dbu_DefaultProductImage from "@salesforce/label/c.dbu_DefaultProductImage";

import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';//custom label refres to'CA'
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA'; // custom label refres to'USD'
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada'; // custom label refres to'CAD'
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

export default class Dbu_allRecentlyViewedProducts extends NavigationMixin(LightningElement) {
    @track currentLocation;
    @track currentLanguage = storeUSA;
    @track storeLocationText = 'en-US';
    @track currencyValue = currencyCodeUSA;
    @track lstProduct;
    @track listGridClass = "gridView";
    @track productList;
    @track recentlyViewedProductsList=[];
    @track gtmlistname;
    @track pagename = "RecentlyViewed";
    @track coreProductList;
    @track corePrice; 
    @track recentlyProductList;
    /* Sasikanth CECI-958 GTM Events Start*/
    @track brandData;
    @track category;
    @track brandKey;
    @track brandVal;
    @track categoryKey;
    @track categoryVal;
    /* Sasikanth CECI-958 GTM Events End*/
   // @track isOriginalPrice;

    connectedCallback(){
       
          let queryString = window.location.search;
          console.log('queryString ',queryString);
          let urlParams = new URLSearchParams(queryString);
          console.log('urlParams ',urlParams);
          //this.currentLocation = urlParams.get('store');

          this.currentLocation = window.sessionStorage.getItem('setCountryCode');
          console.log('connected callback curr promotn before> ' + JSON.stringify(this.currentLocation));
          if (this.currentLocation === null || this.currentLocation === storeUSA ) {
              this.currentLocation = storeUSA;
              this.currencyValue = currencyCodeUSA;
          }
          if (this.currentLocation == storeCA) {
              this.currentLocation = storeCanada;
              this.currentLanguage = storeCA;
              this.currencyValue = currencyCodeCanada;
          }
          if (this.currentLocation == storeCAF) {
              this.currentLocation = storeCanada;
              this.currentLanguage = storeCAF;
              this.currencyValue = currencyCodeCanada;
          }
          console.log('connected callback iss after > ' + JSON.stringify(this.currentLocation));
  
        this.getCookiesData('RecentPids');    
    }
    @track productresult;
    getCookiesData(name){
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
        console.log('cookies data ' , cookiesName);
        if(cookiesName == 'yes'){
            var pIds = localStorage.getItem('ProductIdessss');
            console.log('pids in cookies ' , pIds);
            console.log('only data', JSON.stringify(pIds));
            var pIdsString = JSON.stringify(pIds);
            var pIdsInput = pIdsString.replace('"','');
            var pIdsInput1 = pIdsInput.replace(/.$/,"");
            var pIdsListInput= pIdsInput1.split(',');
           
            console.log('cookies data in split ' , pIdsListInput);
            
            fetchRecentLstProducts({
                idList: pIdsListInput,
                storeCountry : this.currentLocation
            })
            .then(result => {
                console.log('from recently view');  
                       let coreChargeList =[];     
                window.console.log('data>>>>>>>>>>' + JSON.stringify(result));
                this.coreProductList = result;
                /* Sasikanth CECI-958 GTM Events Start*/
                this.brandData = result.branddata;
                this.categoryData = result.categorydata;
                this.brandKey = Object.keys(this.brandData);
                this.brandVal = Object.values(this.brandData);
                this.categoryKey = Object.keys(this.categoryData);
                this.categoryVal = Object.values(this.categoryData);
                /* Sasikanth CECI-958 GTM Events End*/
                this.productList = result.productData;
                this.corePrice = result.corePrice;
                // coreChargeList = this.getCoreChargeList(this.productList,this.corePrice);
                // console.log('core ChargeList', JSON.stringify(coreChargeList));
                console.log('core Object',Object.keys(this.corePrice)[0]);
                console.log('core Object Value',Object.values(this.corePrice)[0]);
                this.productresult = result.productData; 
                this.getViewedProduct();
                
            })
            .catch(error => {
                this.error = error.message;
            });
        }else{
            localStorage.removeItem("ProductIdessss");
        }
    }
    getViewedProduct(){
        let orderrecordarray = [];
        let orderrecordlist=[];
        console.log('productList.length====' + this.productList.length);
        console.log('Keys====' + Object.keys(this.productList[0]));
        console.log('productList in getViewedProduct',JSON.parse(JSON.stringify(this.productList)));
        this.recentlyProductList = JSON.parse(JSON.stringify(this.productList));
        console.log('recentlyProductList',this.recentlyProductList);
        /* Sasikanth CECI-958 GTM Events Start*/
        var brandProductMap = new Map(); 
        var categoryProductMap = new Map();
        for(let i= 0; i < this.brandKey.length; i++)
            brandProductMap.set(this.brandKey[i],this.brandVal[i]);
        for (let k = 0; k<this.categoryKey.length; k++) 
            categoryProductMap.set(this.categoryKey[k],this.categoryVal[k]);
            /* Sasikanth CECI-958 GTM Events End*/
        for (let i = 0; i < this.recentlyProductList.length; i++) {
            let orderrecord = {};
            let recentlyviewedProduct={};
            console.log('result[0].Name ', this.recentlyProductList[i].Name);
            console.log('result[0].Id ', this.recentlyProductList[i].Id);
            orderrecord.id = this.recentlyProductList[i].Id;
            orderrecord.Name = this.recentlyProductList[i].Name;
            recentlyviewedProduct.Id = this.recentlyProductList[i].Id;
            recentlyviewedProduct.sfid = this.recentlyProductList[i].Id;
            recentlyviewedProduct.sfdcName = this.recentlyProductList[i].Name;
            recentlyviewedProduct.SKU = this.recentlyProductList[i].ccrz__SKU__c;/* Sasikanth CECI-958 GTM Events*/
            recentlyviewedProduct.brand = brandProductMap.get(this.recentlyProductList[i].Id);/* Sasikanth CECI-958 GTM Events*/
            recentlyviewedProduct.category = categoryProductMap.get(this.recentlyProductList[i].Id);/* Sasikanth CECI-958 GTM Events*/
            console.log('recentlyViewedProduct', recentlyviewedProduct);
            var price;
            
            // recentlyviewedProduct['discountPercentage'] = discountPercentage;
            // console.log('recentlydiscount',recentlyviewedProduct['discountPercentage']);
            // var orPrice = this.productList[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
            if (this.recentlyProductList[i].ccrz__E_ProductMedias__r !== undefined) {
                console.log('result[0].ccrz__URI__c ', this.recentlyProductList[i].ccrz__E_ProductMedias__r[0].ccrz__URI__c);
                orderrecord['image'] = this.recentlyProductList[i].ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                recentlyviewedProduct['imgUrl'] = this.recentlyProductList[i].ccrz__E_ProductMedias__r[0].ccrz__URI__c;
            } else {
                orderrecord['image'] = dbu_DefaultProductImage;
                recentlyviewedProduct['imgUrl'] = dbu_DefaultProductImage;
            }
            if(this.recentlyProductList[i].ccrz__Promotions__r != undefined){
                console.log('Inside promotionTag');
                recentlyviewedProduct["promotionCategory"] = this.recentlyProductList[i].ccrz__Promotions__r[0].ccrz__Category__r.Name;
                recentlyviewedProduct["discountPercentage"] = this.recentlyProductList[i].ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c;
            }
            if(this.recentlyProductList[i].ccrz__E_PriceListItems__r != undefined){
                recentlyviewedProduct["discountPercentage"] = this.recentlyProductList[i].ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c;
            }
            if (this.recentlyProductList[i].ccrz__E_PriceListItems__r !== undefined) {
                console.log('price===' + this.recentlyProductList[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c);
                var price = this.recentlyProductList[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                if(this.recentlyProductList[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c != undefined
                    && this.recentlyProductList[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c != null 
                    && this.recentlyProductList[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c > 0) {
                        var originalprice = this.recentlyProductList[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                    }
                console.log("origPrice 1", originalprice);
                if(this.recentlyProductList[i].dbu_Has_Core_Charge__c){
                    console.log('inside core Charge');
                    let keys = Object.keys(this.corePrice); 
                    for(let b in this.corePrice){
                        if(this.recentlyProductList[i].Id == b){
                            console.log('old Price',price);
                            console.log('old OriginalPrice',originalprice);
                            console.log('adding price');
                            let coreCharge = parseFloat(this.corePrice[b]);
                            console.log('core Charge', coreCharge);
                            console.log(' price',this.recentlyProductList[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c);
                            recentlyviewedProduct['price'] = price + coreCharge;
                            price = recentlyviewedProduct['price'];
                            recentlyviewedProduct['originalPrice'] = originalprice + coreCharge;
                            originalprice = recentlyviewedProduct['originalPrice'];
                            recentlyviewedProduct['discountPercentage'] = Math.round(((originalprice - price)/originalprice)*100);
                            console.log('discountPercentage calculated in allrecentlyViewed',recentlyviewedProduct['discountPercentage']);
                        }
                    }         
                }
                if(originalprice != price && originalprice > price && originalprice != undefined){
                    console.log('in isOriginalPrice');
                    orderrecord['isOriginalPrice'] = true;
                    orderrecord['originalprice'] = perfixCurrencyISOCode(this.currencyValue, originalprice);
                    recentlyviewedProduct['isOriginalPrice'] = true;
                }else{
                    orderrecord['isOriginalPrice'] = false;
                    recentlyviewedProduct['isOriginalPrice'] = false;
                }
                orderrecord['price'] = perfixCurrencyISOCode(this.currencyValue, price);
                recentlyviewedProduct['price'] = orderrecord['price'];
                orderrecord['originalprice'] = perfixCurrencyISOCode(this.currencyValue, originalprice);
                recentlyviewedProduct['originalPrice'] = orderrecord['originalprice'];
            }
            // if(this.recentlyProductList[i].ccrz__E_PriceListItems__r !== undefined){
            //     // var orgPrice = this.recentlyProductList[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
            //     var orgPrice = recentlyviewedProduct['originalPrice'];
            //     if(orgPrice != price && orgPrice > price && orgPrice != undefined){
            //         console.log('in isOriginalPrice');
            //         orderrecord['isOriginalPrice'] = true;
            //         orderrecord['originalprice'] = perfixCurrencyISOCode(this.currencyValue, orgPrice);
            //         recentlyviewedProduct['isOriginalPrice'] = true;
            //     }else{
            //         orderrecord['isOriginalPrice'] = false;
            //         recentlyviewedProduct['isOriginalPrice'] = false;
            //     }
            // }
            console.log('orderrecord ', orderrecord);
            console.log('recentlyviewedRecord',recentlyviewedProduct);
            orderrecordarray.push(orderrecord);
            orderrecordlist.push(recentlyviewedProduct);
        }
        this.lstProduct = orderrecordarray;
        console.log('orderRecordList',orderrecordlist);
        this.recentlyViewedProductsList = orderrecordlist;
        console.log('this.lstProduct ', JSON.stringify(this.lstProduct));
        console.log('recentlyViewedProductsList',JSON.stringify(this.recentlyViewedProductsList));
        window.localStorage.setItem('CurrentGAlistname', 'Recently Viewed Products Results');
        this.gtmlistname= window.localStorage.getItem('CurrentGAlistname');
        console.log("this.gtmlistname",this.gtmlistname);
        this.frameProductImpressiondata(JSON.parse(JSON.stringify(this.recentlyViewedProductsList)),this.currencyValue);

    }
    frameProductImpressiondata(promodata, location){
        console.log('Hpswr');
        if(promodata != null && promodata != undefined && promodata != ''){
            if(promodata.length > 0){
                let impressiondata = [];
                for(let i=0 ; i<promodata.length ; i++){  
                        if(promodata[i].price != undefined ){
                            let itemdata = {
                                "id": promodata[i].SKU, /* Sasikanth CECI-958 GTM Events*/
                                "name": promodata[i].sfdcName,
                                "list": "Recently Viewed Products Results",                    
                                "position": i+1,
                                "price": promodata[i].price.slice(promodata[i].price.indexOf("$")+1, promodata[i].price.length)    /* Sasikanth CECI-958 GTM Events*/              
                            }                        
                            impressiondata.push(itemdata);
                        }else{
                            let itemdata = {
                                "id": promodata.SKU, /* Sasikanth CECI-958 GTM Events*/
                                "name": promodata[i].sfdcName,
                                "list": "Recently Viewed Products Results",                    
                                "position": i+1,                            
                                "price": '0'         /* Sasikanth CECI-958 GTM Events*/      
                            }
                            impressiondata.push(itemdata);
                        }
                    console.log('impressiondata > ' + impressiondata);
                }
                invokeGoogleAnalyticsService('PRODUCT IMPRESSION', {currlocation : location, impressiondetail : impressiondata});                 
            }
        }
    }
    // frameProductImpressiondata(promodata, location){
    //     console.log('Hpswr');
    //     if(promodata != null && promodata != undefined && promodata != ''){
    //         if(promodata.length > 0){
    //             let impressiondata = [];
    //             for(let i=0 ; i<promodata.length ; i++){  
    //                 if(promodata[i].ccrz__E_PriceListItems__r != undefined && promodata[i].ccrz__E_PriceListItems__r != null){
    //                     if(promodata[i].ccrz__E_PriceListItems__r.length > 0 ){
    //                         let pr = 0;                        
    //                         if(promodata[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c != undefined){
    //                             pr = promodata[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
    //                         }                        
    //                         let itemdata = {
    //                             "id": promodata[i].Name,
    //                             "name": promodata[i].Name,
    //                             "list": "Recently Viewed Products Results",                    
    //                             "position": i+1,
    //                             "price": pr                 
    //                         }                        
    //                         impressiondata.push(itemdata);
    //                     }else{
    //                         let itemdata = {
    //                             "id": promodata[i].Name,
    //                             "name": promodata[i].Name,
    //                             "list": "Recently Viewed Products Results",                    
    //                             "position": i+1,                            
    //                             "price": 0                   
    //                         }
    //                         impressiondata.push(itemdata);
    //                     }
    //                 }else{
    //                     let itemdata = {
    //                         "id": promodata[i].Name,
    //                         "name": promodata[i].Name,
    //                         "list": "Recently Viewed Products Results",                    
    //                         "position": i+1,                            
    //                         "price": 0                   
    //                     }
    //                     impressiondata.push(itemdata);
    //                 }              

    //                 console.log('impressiondata > ' + impressiondata);
    //             }
    //             invokeGoogleAnalyticsService('PRODUCT IMPRESSION', {currlocation : location, impressiondetail : impressiondata});                 
    //         }
    //     }

    // }


    showCount = '2';
    get showPerPage() {
        return [
            { label: '2', value: '2' },
            { label: '4', value: '4' },
            { label: '6', value: '6' },
        ];
    }
    listView(event){
        this.listGridClass= "listView";
        this.template.querySelector('.gridViewIcon').classList.remove('selected'); 
        event.currentTarget.classList.add('selected');
    }
    gridView(event){
        this.listGridClass= "gridView";
        this.template.querySelector('.listViewIcon').classList.remove('selected'); 
        event.currentTarget.classList.add('selected');
    }
    handleRecordsPerPage(event){
         let pageSize = event.target.value;
        console.log('  this.pageSize'+  pageSize);
        console.log('this.searchResult.length'+this.productList.length)

       
        let orderrecordarray = [];
        for(let i=0; i < this.productList.length; i++)   
        {
            console.log ('I-- ' , i );
           if(i== pageSize){
                     break;  
           }
           else{
               console.log('inside else ');
            let orderrecord ={};
            orderrecord['id'] = this.productList[i].Id;
            orderrecord['Name'] = this.productList[i].Name;
            //orderrecord['price'] = this.result[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
            let price  = this.productList[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
            // orderrecord['price']= price.toLocaleString(this.storeLocationText, {
            //     style: 'currency',
            //     currency: this.currencyValue,
            //     minimumFractionDigits: 2,
            //     maximumFractionDigits: 2
            // });
            orderrecord['price']= perfixCurrencyISOCode(this.currencyValue , price);
           // orderrecord['originalprice'] = this.result[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
           let productPrice = this.productList[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
            let originalprice  = this.productList[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
            if(originalprice == null || originalprice == undefined || originalprice == productPrice || originalprice < productPrice){
                orderrecord['isOriginalPrice'] = false;
               
            }else{
                // orderrecord['originalprice']= originalprice.toLocaleString(this.storeLocationText, {
                //     style: 'currency',
                //     currency: this.currencyValue,
                //     minimumFractionDigits: 2,
                //     maximumFractionDigits: 2
                // });
                orderrecord['originalprice']= perfixCurrencyISOCode(this.currencyValue , originalprice);
                orderrecord['isOriginalPrice'] = true;
            }
            
            orderrecord['image'] = this.productList[i].ccrz__E_ProductMedias__r[0].ccrz__URI__c;
           // window.console.log('i=>'+i);
            orderrecordarray.push(orderrecord); 
           }          
    }
        console.log('orderrecordarray'+JSON.stringify(orderrecordarray));
         this.lstProduct = orderrecordarray;  
        //console.log('this.numbersortdata  data in sort  '+ this.numbersortdata.length);
    }

    goToProductDetailPage(event){
        let prodName = event.currentTarget.getAttribute('data-name');
        console.log('prodName==='+prodName);
        let prodId =   event.currentTarget.getAttribute('data-id');
        let prodprice = event.currentTarget.getAttribute('data-prodprice');
        console.log('prodId==='+prodId);
        console.log('prodprice==='+prodprice);
        //Replacing comma and whitespace from hyphen in Product Name
        if(prodName.includes(",")){
            prodName =  prodName.replace(/,/g, '-').toLowerCase();
        }
        if(prodName.includes(" ")){
            prodName =  prodName.replace(/\s+/g, '-').toLowerCase();
        }
       
        let productFeedForGoogleAnalytics = {
            ProductID : prodName,
            productName : prodName,
            ProductInventoryStatus : 1,
            ProductPrice : prodprice,
            listname : 'Recently Viewed Products Results',            
            ProductCategory : '',
            ProductBrand : ''
          };
          window.localStorage.setItem('CurrentGAlistname', 'Recently Viewed Products Results');
          this.gtmlistname= window.localStorage.getItem('CurrentGAlistname');
          console.log("this.gtmlistname",this.gtmlistname);
          invokeGoogleAnalyticsService('ON PRODUCT CLICK EVENT' , productFeedForGoogleAnalytics);          
          console.log('ProdName LowerCase==='+prodName);

          if(prodName.includes('/')){
            prodName = prodName.replaceAll('/','-');
          }
         let urlString = window.location.origin;
         //let redirectURL = urlString + communityName + 'product?name=' + prodName + '&pId=' + prodId + '&store=' + this.currentLocation;
				let redirectURL = urlString + communityName +'product/'+ prodId +'/'+ prodName+'/?store='+this.currentLanguage;
         console.log('redirectURL===='+redirectURL);
         window.location.href = redirectURL; 
    }
}