//CECI-953 home page clearance widget - created new component

import { LightningElement, api, wire, track } from 'lwc';
import communityName from '@salesforce/label/c.dbu_communityName';
import fetchProductsForClearance from '@salesforce/apex/dbu_dealsPageController.fetchProductsForClearance';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A';
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';
import deals from '@salesforce/label/c.dbu_deals';//Custome Label refers to 'Deals'
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

export default class Dbu_homeDealsWidget extends LightningElement {
    @api dealsWidgetHeader; 
    @api navigateToDealsLink; 
    @api fetchProductsBy; 

    @track ProductDetailsBySubCategoryName = [];
    @track productTileDetails = {};
    @track productTileDetailsList = [];
    @track currentLocation;
    @track currentLanguage = storeUSA;  
    @track showClearance;
    @track deals = deals;
    @track listnametosend = 'Parts on Clearance Results';


    connectedCallback(){

        this.currentLocation = window.sessionStorage.getItem('setCountryCode');
        if(this.currentLocation == null){
            this.currentLocation = storeUSA;   
        }else if(this.currentLocation == storeCA){
            this.currentLocation = storeCanada;
            this.currentLanguage = storeCA;
        }else if(this.currentLocation == storeCAF){
            this.currentLocation = storeCanada;
            this.currentLanguage = storeCAF;
        }


        fetchProductsForClearance({
            country: this.currentLanguage,
            fetchProductsBy: this.fetchProductsBy
        }).then(result => {
            this.showClearance = result.length == 5 ? true : false;
            this.ProductDetailsBySubCategoryName = result;
            this.objectifyResponse();
        }).catch(error => {
            this.error = error.message;
        }) 
    }

    handleClickShopAll(){
        invokeGoogleAnalyticsService('DEALS LINK CLICK', "Deals");
        window.location.href = window.location.origin + communityName + this.deals.toLowerCase()+'?store='+this.currentLanguage;
    }

    objectifyResponse(){
        if(this.ProductDetailsBySubCategoryName.length){
                this.ProductDetailsBySubCategoryName.forEach(productElement => 
                {
                    
                    this.productTileDetails.Name = productElement.productName;
                    this.productTileDetails.Id = productElement.sfId;
                    this.productTileDetails.sfid = productElement.sfId;
                    this.productTileDetails.category = productElement.categoryname;/* Sasikanth CECI-958 GTM Events start*/
                    this.productTileDetails.brand = productElement.brandname;
                    this.productTileDetails.ccrz__SKU__c = productElement.SKU; /* Sasikanth CECI-958 GTM Events End*/
                    let prodMed = {};
                    this.productTileDetails.ccrz__E_ProductMedias__r = [];
                    prodMed.ccrz__Product__c = productElement.sfId;
                    prodMed.ccrz__URI__c = productElement.productImageURI;
                    this.productTileDetails.ccrz__E_ProductMedias__r.push(JSON.parse(JSON.stringify(prodMed)));

                    let pListItem = {};
                    this.productTileDetails.ccrz__E_PriceListItems__r = [];
                    pListItem.ccrz__Product__c = productElement.sfId;
                    pListItem.ccrz__Price__c = productElement.price;
                    pListItem.dbu_Original_Price__c = productElement.originalPrice;
                    pListItem.dbu_Discount_Percent__c = productElement.discountPercentage;
                    this.productTileDetails.ccrz__E_PriceListItems__r.push(JSON.parse(JSON.stringify(pListItem)));

                    let promoListItem = {};
                    this.productTileDetails.ccrz__Promotions__r = [];
                    promoListItem.ccrz__Product__c = productElement.sfId;
                    promoListItem.Name = productElement.saleTag;
                    promoListItem.ccrz__Category__r = {
                        Name : productElement.saleTag
                    };
                    this.productTileDetails.ccrz__Promotions__r.push(JSON.parse(JSON.stringify(promoListItem)));

                    this.productTileDetails.discountPercentage = productElement.discountPercentage;
                    
                    this.productTileDetailsList.push(JSON.parse(JSON.stringify(this.productTileDetails)));
                    
                });
                this.productTileDetailsList.sort(function(a,b) { return (b.discountPercentage) - (a.discountPercentage) } );
                this.frameProductImpressiondata(this.productTileDetailsList, this.currentLanguage);
                this.ProductDetailsBySubCategoryName = this.productTileDetailsList;
        }
    }

    frameProductImpressiondata(promodata, location){
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
                                "id": promodata[i].ccrz__SKU__c, /* Sasikanth CECI-958 GTM Events*/
                                "name": promodata[i].Name,
                                "list": "Parts on Clearance",                    
                                "position": i+1,
                                "price": JSON.stringify(pr)  /* Sasikanth CECI-958 GTM Events*/                
                            }                        
                            impressiondata.push(itemdata);
                        }else{
                            let itemdata = {
                                "id": promodata[i].ccrz__SKU__c, /* Sasikanth CECI-958 GTM Events*/
                                "name": promodata[i].Name,
                                "list": "Parts on Clearance",                    
                                "position": i+1,                            
                                "price": "0"          /* Sasikanth CECI-958 GTM Events*/         
                            }
                            impressiondata.push(itemdata);
                        }
                    }else{
                        let itemdata = {
                            "id": promodata[i].ccrz__SKU__c, /* Sasikanth CECI-958 GTM Events*/
                            "name": promodata[i].Name,
                            "list": "Parts on Clearance",                    
                            "position": i+1,                            
                            "price": "0"                /* Sasikanth CECI-958 GTM Events*/   
                        }
                        impressiondata.push(itemdata);
                    }              

                }
                invokeGoogleAnalyticsService('PRODUCT IMPRESSION', {currlocation : location, impressiondetail : impressiondata});                 
            }
        }

    }

    handleClickNext(){
        let prodRemoved = this.productTileDetailsList.shift();
        this.productTileDetailsList.push(prodRemoved);
    }

    handleClickPrev(){
        let prodRemoved = this.productTileDetailsList.pop();
        this.productTileDetailsList.unshift(prodRemoved);
    }
}