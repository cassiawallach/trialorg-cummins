import { LightningElement, api,track } from 'lwc';
import myResource from '@salesforce/resourceUrl/cloudMVP';
import { NavigationMixin } from 'lightning/navigation';
import pubsub from 'c/pubsub' ; 
import communityName from '@salesforce/label/c.dbu_communityName';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A';
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA';
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada';
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';
import originalPrice from '@salesforce/label/c.dbu_originalPrice';
import currentPrice from '@salesforce/label/c.dbu_currentPrice';
import price_not_available from '@salesforce/label/c.dbu_PriceNotAvailable';
import { perfixCurrencyISOCode } from 'c/serviceComponent';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
export default class dbu_listProductDetails extends NavigationMixin(LightningElement) {
    @api product ;
    @api galistname;
    //imageUrl = myResource;
    @track productRating=0;
    @track flag = false;
    //@track originalPrice = originalPrice; //'$0.00';
    @track originalPrice ;
    //@track currentPrice = currentPrice; //'$0.00';
    @track currentPrice;
    @track countryCurrencyCode;
    /*Variables Added by Malhar for store toggling */
    @track currentLocation;
    //@track currentLanguage = 'US';
    @track currentLanguage = storeUSA;
    @track priceNotAvailable = price_not_available;

    connectedCallback(){

        /*Added by Malhar for retriving store location begin - 19/11/2020 */
        
        let queryString = window.location.search;
        let urlParams = new URLSearchParams(queryString);
       // this.currentLocation = urlParams.get('store');
       this.currentLocation = window.sessionStorage.getItem('setCountryCode');
        console.log('connected callback list prod details curr locatn before > ' + JSON.stringify(this.currentLocation));
        console.log('connected callback list prod details lang before > ' + JSON.stringify(this.currentLanguage));
        if(this.currentLocation == null ||  this.currentLocation === storeUSA){
            //this.currentLocation = 'US'; 
            this.currentLocation = storeUSA; 
            this.countryCurrencyCode = currencyCodeUSA;   
        }else if(this.currentLocation == storeCA){
            // this.currentLocation = 'CA';
            // this.currentLanguage = 'EN';
            this.currentLocation = storeCanada;
            this.currentLanguage = storeCA;

            this.countryCurrencyCode = currencyCodeCanada;
        }else if(this.currentLocation == storeCAF){
            // this.currentLocation = 'CA';
            // this.currentLanguage = 'FR';
            this.currentLocation = storeCanada;
            this.currentLanguage = storeCAF;
            this.countryCurrencyCode = currencyCodeCanada;
        }
        console.log('connected callback list prod details after > ' + JSON.stringify(this.currentLocation));
        console.log('connected callback list prod details curr lang after > ' + JSON.stringify(this.currentLanguage));

        /*Added by Malhar for retriving store location ends - 29/11/2020 */

        this.checkOriginalPrice();
        console.log('Hi');
        //console.log('product>>>15 '+ product);
    }
    checkOriginalPrice(){
        
        if(this.product.price == null || this.product.price == undefined){
            this.price = this.priceNotAvailable;
        }else{
            let currentP = this.product.price;
            this.price = perfixCurrencyISOCode(this.countryCurrencyCode, currentP);
        }
                    
        if(this.product.originalPrice == null || this.product.originalPrice == undefined || this.product.price == this.product.originalPrice){
            this.flag = false;
        }else{
            this.flag = true;
            let originalP = this.product.originalPrice;
            
           this.originalPrice = perfixCurrencyISOCode(this.countryCurrencyCode, originalP);
        }
    }

    // get productURL(){
    //     let productName = this.product.Name.toLowerCase();
    //     let urlString = window.location.origin;
    //     //Malhar modified the below URL to hold the store parameter - 29/11/2020
    //     //return urlString+communityName+'product?pId='+this.product.id + '&store=' + this.currentLanguage;

    //     // name parameter added by Ranadip - 22/12/2020
    //     return urlString+communityName+'product?name='+productName+'&pId='+this.product.id + '&store=' + this.currentLanguage;
    // }

   
    handleClick() {
        console.log('product name from List ',this.product.Name);
        console.log('product Id from list ',this.product.id);
        console.log('product currentLanguage from list ',this.currentLanguage);

        let productName = this.product.Name.toLowerCase();
        if(productName.includes('/')){
            productName = productName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
          }
        let urlString = window.location.origin;

        let productFeedForGoogleAnalytics = {
            ProductID : productName,
            productName : productName,
            ProductInventoryStatus : 1,
            ProductPrice : this.price,
            listname : this.galistname,            
            ProductCategory : '',
            ProductBrand : ''
          }; 
          window.localStorage.setItem('CurrentGAlistname', this.galistname );
    console.log('productFeedForGoogleAnalytics > ' + productFeedForGoogleAnalytics);
    invokeGoogleAnalyticsService('ON PRODUCT CLICK EVENT' , productFeedForGoogleAnalytics);

        //let urls = urlString+communityName+'product?name='+productName+'&pId='+this.product.id + '&store=' + this.currentLanguage;
        let urls =  urlString + communityName +'product/'+this.product.id +'/'+ productName;
        window.location.href = urls;
        
       /* this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            "attributes": {
                "url": urls
            }
            
        },
            true // Replaces the current page in your browser history with the URL
        );*/
        console.log('Going to fire pubsub event' + this.product.id);
        //pubsub.fire('loadprodbyidevt', this.product.Id );

    }
    
}