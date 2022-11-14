import { LightningElement, api, track } from 'lwc';
import myResource from '@salesforce/resourceUrl/cloudMVP';
import { NavigationMixin } from 'lightning/navigation';
import pubsub from 'c/pubsub';
//import communityName from '@salesforce/label/c.dbu_communityName';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A';
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA';
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada';
import defaultProductImage from '@salesforce/label/c.dbu_DefaultProductImage';
import locationData from '@salesforce/label/c.dbu_locationData';
import price_not_available from '@salesforce/label/c.dbu_PriceNotAvailable';
import { perfixCurrencyISOCode } from 'c/serviceComponent';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import communityName from "@salesforce/label/c.dbu_communityName";
import clearanceIcon from '@salesforce/resourceUrl/dbu_icons';
import dbu_percentOff from '@salesforce/label/c.Dbu_percentOff';
import { getCorePrice } from 'c/serviceComponent';
export default class Dbu_lstProductDetails extends NavigationMixin(LightningElement) {
    @api product;
    @api galistname;
    @api coreprice;
    imageUrl = myResource;
    @track productRating = 0;
    @track flag = false;
    @track originalPrice;
    @track currentPrice;
    @track locationData = locationData;
    @track countryCurrencyCode;
    @track priceNotAvailable = price_not_available;
    @track nullVar = null;
    @track discountPercentage;
    @track clearanceImg = clearanceIcon+'/dbu_icons/dbu_saletag.svg';
    @track promotionCategory;
    label = {
        defaultProductImage,
        dbu_percentOff
    };
    connectedCallback() {
        console.log('product object ', JSON.stringify(this.product));
        //this.imageUrl = myResource + '/images/' + this.product.dbu_Image_Src__c;
        //console.log('this.imageUrl>>>15 ', this.imageUrl);
        console.log('galistname > ' + this.galistname);
        /*added by mounika t to navigation through nav mixin */
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        window.sessionStorage.getItem('setCountryCode');
        console.log('session in lstProdDetails>' +window.sessionStorage.getItem('setCountryCode'));
        if (url.searchParams.get("store") != undefined) {
            this.locationData = url.searchParams.get("store");
        }
        console.log('Id',this.product);
        // console.log('Name',product.Name);
        // console.log('price',product.)
        console.log('this.locationData in connected callback' + this.locationDat);
        /*added by mounika t to navigation through nav mixin */
        //this.productRating = (this.product.ccrz__AverageRating__c).toFixed(1);
        // this.promotionCategory = this.product.promotionCategory;
        this.register();
        this.checkOriginalPrice();
        if(this.locationData == storeUSA){
            this.countryCurrencyCode = currencyCodeUSA;
        }else if(this.locationData == storeCA || this.locationData == storeCAF){
            this.countryCurrencyCode = currencyCodeCanada;
        }
        if (this.product.ccrz__E_PriceListItems__r != undefined) {
            let currentP = this.product.ccrz__E_PriceListItems__r[0].ccrz__Price__c;
            if (this.product.ccrz__E_PriceListItems__r[0].ccrz__Price__c != undefined) {
                this.currentPrice = perfixCurrencyISOCode(this.countryCurrencyCode ,currentP); 
            }
            if (this.flag) {
                let originalP = this.product.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                this.originalPrice = perfixCurrencyISOCode(this.countryCurrencyCode ,originalP);
                if(this.product.ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c > 0 )
                    this.discountPercentage = this.product.ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c;
            }
            if(this.product.ccrz__Promotions__r != undefined){
                console.log('inside promotion')
                this.promotionCategory = this.product.ccrz__Promotions__r[0].ccrz__Category__r.Name;
                console.log('this.promotionCategory',this.promotionCategory);
            }
        }else{
            this.currentPrice = this.priceNotAvailable;
        }
        // if(this.product.discountPercentage > 0){
        //     this.discountPercentage = this.product.discountPercentage;
        //     console.log('this.product.discountPercentage',this.product.discountPercentage)
        // }
        console.log('product in lstProduct Details', JSON.parse(JSON.stringify(this.product)));
    }

    register() {
        console.log('event registered in lst product details');
        pubsub.register('sendDataTolstProdDetailspage', this.handleEventLoc.bind(this));
    }

    handleEventLoc(event) {
        console.log('event in handler>>' + event);
        this.locationData = event;

        console.log('this.locationData in handle event method>>>' + this.locationData);
    }


    checkOriginalPrice() {
        if (this.product.ccrz__E_PriceListItems__r == undefined) {
        }
        else {
            if (this.product.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c == undefined || this.product.ccrz__E_PriceListItems__r[0].ccrz__Price__c == this.product.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c) {
                console.log('Inside If>>>30');
                this.flag = false;
            }
            else {
                console.log('Inside else>>>35');
                this.flag = true;
            }
        }
    }

    // get productURL(){
    //     console.log('locationData in action method>>' +this.locationData);
    //     let urlString = window.location.origin;
    //     return urlString+communityName+'product?pId='+this.product.Id;
    //      //return urlString+communityName+'product?pId='+this.product.Id+'location?country='+this.locationData;
    // }

    handleClick(event) {//Commented by Shriram
        let productName = this.product.Name.toLowerCase();
        let currproductName = event.currentTarget.getAttribute('data-productname');
        let currOriproductPrice = event.currentTarget.getAttribute('data-originalprice');
        let currSetproductPrice = event.currentTarget.getAttribute('data-currentprice');
        let curridproductPrice = event.currentTarget.getAttribute('data-id');
        
        /*
        let productFeedForGoogleAnalytics = {
            ProductID : currproductName,
            productName : currproductName,
            ProductInventoryStatus : '',
            currenctProductPrice : currSetproductPrice,
            originalProductPrice : currOriproductPrice,                        
            ProductCategory : '',
          };*/
          
          let productFeedForGoogleAnalytics = {
            ProductID : this.product.ccrz__SKU__c, /* Sasikanth CECI-958 GTM Events*/
            productName : currproductName,
            ProductInventoryStatus : 1,
            ProductPrice : JSON.stringify(this.product.ccrz__E_PriceListItems__r[0].ccrz__Price__c), /* Sasikanth CECI-958 GTM Events*/
            listname : this.galistname,            
            ProductCategory : this.product.category != undefined ? this.product.category : '',/* Sasikanth CECI-958 GTM Events*/
            ProductBrand : this.product.brand != undefined ? this.product.brand : ''/* Sasikanth CECI-958 GTM Events*/
          };          
                    
          console.log('productFeedForGoogleAnalytics > ' + JSON.stringify(productFeedForGoogleAnalytics));        
          window.localStorage.setItem('CurrentGAlistname', this.galistname);
          invokeGoogleAnalyticsService('ON PRODUCT CLICK EVENT' , productFeedForGoogleAnalytics);


          let urlString = window.location.origin;

          if(productName.includes('/')){
            productName = productName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
          }
          console.log('productName > ' + productName);
          window.location.href =  urlString + communityName +'product/'+this.product.Id +'/'+ productName+'/?store='+this.locationData;
          
          //window.location.href = urlString + communityName + "product?name=+" + productName + "&pId=" + this.product.Id + "&store=" + this.locationData;       
            /*
            this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'dbu_product__c'
            },
            state: {
                'name': productName,
                'pId': this.product.Id, //event.target.dataset.id
                'store': this.locationData
            }
        },
            true // Replaces the current page in your browser history with the URL
        );
        */
        //console.log('Going to fire pubsub event' + this.product.Id);
        //pubsub.fire('loadprodbyidevt', this.product.Id );

    }
}