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
import originalPrice from '@salesforce/label/c.dbu_originalPrice';
import currentPrice from '@salesforce/label/c.dbu_currentPrice';
import { perfixCurrencyISOCode } from 'c/serviceComponent';


export default class dbu_lstCartProductDetails extends NavigationMixin(LightningElement) {
    @api product ;
    //imageUrl = myResource;
    @track productRating=0;
    @track flag = false;
    @track originalPrice = originalPrice;
    @track currentPrice = currentPrice;
    @track countryCurrencyCode;
    @track locationData;
    connectedCallback(){
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        if (url.searchParams.get("store") != undefined) {
            this.locationData = url.searchParams.get("store");
        }
        console.log('this.locationData=================>'+this.locationData);
        if(this.locationData == storeUSA){
            this.countryCurrencyCode = currencyCodeUSA;
            console.log('this.storeUSA=================>'+this.countryCurrencyCode);
        }else if(this.locationData == storeCA || this.locationData == storeCAF){
            this.countryCurrencyCode = currencyCodeCanada;
            console.log('this.storeUSA=================>'+this.countryCurrencyCode);
        }
        this.checkOriginalPrice();

    }
    checkOriginalPrice(){
        if(this.product.price == null || this.product.price == undefined){

        }else{
            let currentP = this.product.price;
            this.price = perfixCurrencyISOCode(this.countryCurrencyCode ,currentP);
        }
        if(this.product.originalPrice == null || this.product.originalPrice == undefined || this.product.price == this.product.originalPrice){
            this.flag = false;
        }else{
            this.flag = true;
            let originalP = this.product.originalPrice;
            this.originalPrice = perfixCurrencyISOCode(this.countryCurrencyCode ,originalP);

        }
    }

    get productURL(){

        let urlString = window.location.origin;
        let prodName = this.product.Name;
        if(prodName.includes('/')){
            prodName = prodName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
          }
				return urlString + communityName +'product/'+this.product.id +'/'+ prodName;
        //return urlString+communityName+'product?name='+this.product.Name+'&pId='+this.product.id+'&store='+this.locationData;
    }

    
}