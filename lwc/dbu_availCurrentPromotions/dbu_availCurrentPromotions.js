import { LightningElement, wire,track } from 'lwc';
import myResource from '@salesforce/resourceUrl/cloudMVP';
import communityName from '@salesforce/label/c.dbu_communityName';
import getPromotionProducts from '@salesforce/apex/dbu_ProductCtrl.getPromotionProducts';
import dbu_avail_current_promotion_title from '@salesforce/label/c.dbu_avail_current_promotion_title';
import dbu_avail_current_promotion_Show_per_page from '@salesforce/label/c.dbu_avail_current_promotion_Show_per_page';
import { perfixCurrencyISOCode } from 'c/serviceComponent';
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA';
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; 
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';
import price_not_available from '@salesforce/label/c.dbu_PriceNotAvailable';

import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';


export default class Dbu_availCurrentPromotions extends LightningElement {

    leftArrow = myResource+'/images/dbu_LeftArrow.png';
    rightArrow = myResource+'/images/dbu_RightArrow.png';
    @track queue = [];
    @track queueSize ;
    @track productListSize = 0;
    @track lstProduct;
    @track lstSearchProduct;
    @track isShowSearch = false;
    @track selectedStoreLoc = '';
    @track flag =false;
    @track listGridClass = "gridView";
    @track storeLocationText = 'en-US';
    @track currencyValue = 'USD';
    @track currentLocation;
    @track currentLanguage = 'US';
    @track countryCurrencyCode;
    @track priceNotAvailable = price_not_available;
    

    label={
        dbu_avail_current_promotion_title,
        dbu_avail_current_promotion_Show_per_page
    }

    connectedCallback(){
        let queryString = window.location.search;
        let urlParams = new URLSearchParams(queryString);
        //this.currentLocation = urlParams.get('store');
        this.currentLocation = window.sessionStorage.getItem('setCountryCode');

        console.log('connected callback curr promotn before> ' + JSON.stringify(this.currentLocation));
        if (this.currentLocation == null || this.currentLocation == storeUSA) {
            this.currentLocation = storeUSA;
            this.currentLanguage = storeUSA;
            this.countryCurrencyCode = currencyCodeUSA;
        }
        if (this.currentLocation == storeCA) {
            this.currentLocation = storeCanada;
            this.currentLanguage = storeCA;
            this.countryCurrencyCode = currencyCodeCanada;
        }
        if (this.currentLocation == storeCAF) {
            this.currentLocation = storeCanada;
            this.currentLanguage = storeCAF;
            this.countryCurrencyCode = currencyCodeCanada;
        }
        console.log('connected callback iss after > ' + JSON.stringify(this.currentLocation));
    }

   

    @wire(getPromotionProducts,{
        urlParam: '$currentLocation'
     })
    wireProduct({ error, data }) {
        if (data) {
            window.console.log('data>>>>>>>>>>', data);
            this.result = data;
            //window.console.log('this.result >>>>>>>>>>', JSON.stringify(this.result));
            let i = 0;
            let orderrecordarray = [];
            //for(i=0;i<data.length;i++)
            for (i = 0; i < this.result.length; i++) {
                if (i != 2) {
                    let orderrecord = {};
                    orderrecord['id'] = this.result[i].Id;
                    orderrecord['Name'] = this.result[i].Name;
                    //orderrecord['price'] = this.result[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                    let price = this.result[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                    if (price == '' || price == undefined || price == null) {
                        orderrecord['price'] = this.priceNotAvailable;
                    } else {
                        orderrecord['price'] = perfixCurrencyISOCode(this.countryCurrencyCode, price);
                    }

                    let originalprice = this.result[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                    if (originalprice != '' && originalprice != null && originalprice != undefined) {
                        orderrecord['originalprice'] = perfixCurrencyISOCode(this.countryCurrencyCode, originalprice);

                    }
                    orderrecord['image'] = this.result[i].ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                    orderrecordarray.push(orderrecord);
                }
                else {
                    break;
                }
                window.console.log('i=>' + i);

            }
            console.log('orderrecordarray' + JSON.stringify(orderrecordarray));
            this.lstProduct = orderrecordarray;

            this.error = undefined;
            console.log('data>>>>>>>>>>', this.lstProduct);
            this.frameProductImpressiondata(data, this.currentLanguage);
        } else if (error) {
            this.error = error;
            this.lstProduct = undefined;
        }
    }

    frameProductImpressiondata(promodata, location){
        console.log('Hpswr');
        if(promodata != null && promodata != undefined && promodata != ''){
            if(promodata.length > 0){
                let impressiondata = [];
                for(let i=0 ; i<promodata.length ; i++){  
                    if(promodata[i].ccrz__E_PriceListItems__r != undefined && promodata[i].ccrz__E_PriceListItems__r != null){
                        if(promodata[i].ccrz__E_PriceListItems__r.length > 0 ){                                    
                            let pr = 0;                        
                            if(promodata[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c != undefined){
                                pr = promodata[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                            }                        
                            let itemdata = {
                                "id": promodata[i].Name,
                                "name": promodata[i].Name,
                                "list_name": "Current Promotion Results",                    
                                "list_position": i+1,
                                "quantity": 1,
                                "price": pr                 
                            }                        
                            impressiondata.push(itemdata);
                        }else{
                            let itemdata = {
                                "id": promodata[i].Name,
                                "name": promodata[i].Name,
                                "list_name": "Current Promotion Results",                    
                                "list_position": i+1,
                                "quantity": 1,
                                "price": 0                   
                            }
                            impressiondata.push(itemdata);
                        }
                    }else{
                        let itemdata = {
                            "id": promodata[i].Name,
                            "name": promodata[i].Name,
                            "list_name": "Current Promotion Results",                    
                            "list_position": i+1,
                            "quantity": 1,
                            "price": 0                   
                        }
                        impressiondata.push(itemdata);
                    }              

                    console.log('impressiondata > ' + impressiondata);
                }
                invokeGoogleAnalyticsService('PRODUCT IMPRESSION', {currlocation : location, impressiondetail : impressiondata});                 
            }
        }

    }



    handleclick(event){
        this.sfid= event.target.getAttribute('data-sfid');
        //this.sfid= event.target.getAttribute('data-sfid');
    console.log('getattr' +event.target.getAttribute('data-sfid'));
    //console.log('getattr name ' +event.target.getAttribute('data-sfdcname'));
    let pName = event.target.getAttribute('data-productname');
    console.log('pName ', pName);
        let pricing = event.target.getAttribute('data-productprice');
       
        let productFeedForGoogleAnalytics = {
            ProductID : pName,
            productName : pName,
            ProductInventoryStatus : 1,
            ProductPrice : pricing,
            listname : 'Current Promotion Results',            
            ProductCategory : '',
            ProductBrand : ''
          };
          window.localStorage.setItem('CurrentGAlistname','Current Promotion Results')
          console.log('productFeedForGoogleAnalytics > ' + productFeedForGoogleAnalytics);
          if(pName.includes('/')){
            pName = pName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
          }
          invokeGoogleAnalyticsService('ON PRODUCT CLICK EVENT' , productFeedForGoogleAnalytics);          

        let urlString = window.location.origin;
        //window.location.href = urlString+communityName+'product?pId='+this.sfid + '&store=' + this.currentLanguage ;
        window.location.href = urlString+communityName+'product/'+this.sfid+'/'+pName;
        //name='+pName+'&pId='+this.sfid + '&store=' + this.currentLanguage;
    }
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
        this.pageSize = event.target.value;
        console.log('  this.pageSize'+  this.pageSize);
        console.log('this.searchResult.length'+this.result.length)
        //console.log('this.searchResult.length'+JSON.stringify(this.lstProduct[0].ccrz__E_PriceListItems__r[0].ccrz__Price__c))
         let i=0;
        let orderrecordarray = [];
          //for(i=0;i<data.length;i++)
        for(i=0;i<this.result.length;i++)   
        {
           if(i!=this.pageSize){
            let orderrecord ={};
            orderrecord['id'] = this.result[i].Id;
            orderrecord['Name'] = this.result[i].Name;
            //orderrecord['price'] = this.result[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
            let price  = this.result[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
            if(price == '' || price == undefined || price == null){
                orderrecord['price'] = this.priceNotAvailable;
            }else{
                orderrecord['price'] = perfixCurrencyISOCode(this.countryCurrencyCode,price);
            }
             

            // orderrecord['price']= price.toLocaleString(this.storeLocationText, {
            //     style: 'currency',
            //     currency: this.currencyValue,
            //     minimumFractionDigits: 2,
            //     maximumFractionDigits: 2
            // });
           // orderrecord['originalprice'] = this.result[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
            let originalprice  = this.result[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
            if(originalprice!= '' && originalprice!= null && originalprice!= undefined){
                orderrecord['originalprice'] = perfixCurrencyISOCode(this.countryCurrencyCode,originalprice); 

            // orderrecord['originalprice']= originalprice.toLocaleString(this.storeLocationText, {
            //     style: 'currency',
            //     currency: this.currencyValue,
            //     minimumFractionDigits: 2,
            //     maximumFractionDigits: 2
            // });
        }
            orderrecord['image'] = this.result[i].ccrz__E_ProductMedias__r[0].ccrz__URI__c;
            window.console.log('i=>'+i);
            orderrecordarray.push(orderrecord);
            
           }
           else{
               break;
           }
              
           
        
            
    }
    console.log('orderrecordarray'+JSON.stringify(orderrecordarray));
         this.lstProduct = orderrecordarray;  
        console.log('this.numbersortdata  data in sort  '+ this.numbersortdata.length);

    }

}