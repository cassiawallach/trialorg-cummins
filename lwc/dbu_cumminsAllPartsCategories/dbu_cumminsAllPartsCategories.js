import {
    LightningElement,
    track
} from 'lwc';
import communityName from '@salesforce/label/c.dbu_communityName';
import {
    NavigationMixin
} from 'lightning/navigation';
import CumminsParts from '@salesforce/resourceUrl/CumminsParts';
import getProdCategoryMedia from '@salesforce/apex/dbu_homePageCategoryTileCtrl.getProdCategoryMedia';
//labels starts//
import imagealttext from '@salesforce/label/c.dbu_imageAltTextVerbiage';
import dbu_homepage_category_parts from "@salesforce/label/c.dbu_homepage_category_parts";
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A';
//labels ends//
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
export default class Dbu_cumminsAllPartsCategories extends NavigationMixin(LightningElement) {
    //  fleetGuardFilter = CumminsParts + '/Images/OnanOil.jpg';
    @track prodCategoryMediaArray = [];
    @track queue = [];
    @track counter = 0;
    @track screenLoaded = false;
    @track sendLocBackToChangeLocTile;

    label={
        dbu_homepage_category_parts
    }
    connectedCallback() {
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
      //  this.sendLocBackToChangeLocTile = url.searchParams.get("store");
      this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
      if( this.sendLocBackToChangeLocTile === undefined || this.sendLocBackToChangeLocTile === null){
       this.sendLocBackToChangeLocTile = storeUSA;
     }
        this.getCategoryMedia();
    }

    getCategoryMedia() {
        let perfixURL = '/CSSNAStore/resource/';
        getProdCategoryMedia({})
            .then(result => {
                if (result) {
                    for (let i = 0; i < result.length; i++) {
                        let prodCategoryMediaObj = {};
                        console.log('==result ===' + result[i].ccrz__Category__r.Name);
                        console.log('===id==='+result[i].ccrz__Category__c);
                        prodCategoryMediaObj['name'] = result[i].ccrz__Category__r.Name;
                        prodCategoryMediaObj['id'] = result[i].ccrz__Category__c;
                        prodCategoryMediaObj['locale'] = result[i].ccrz__Locale__c;
                        //--- URL Example -- /CSSNAStore/resource/CumminsParts/Images/OnanOil.jpg ----
                        prodCategoryMediaObj['mediaURL'] = perfixURL + '' + result[i].ccrz__StaticResourceName__c + '' + result[i].ccrz__FilePath__c;
                        console.log('==URL==' + perfixURL + '' + result[i].ccrz__StaticResourceName__c + '' + result[i].ccrz__FilePath__c);
                        this.prodCategoryMediaArray.push(prodCategoryMediaObj);
                    }
                    if(this.sendLocBackToChangeLocTile === 'US'){
                        this.prodCategoryMediaArray = this.prodCategoryMediaArray.filter(prodCategory => prodCategory.locale === 'en_US');   
                    }
                   /* for (let i = 0; i < 10; i++) {
                        this.counter++;
                        this.queue.push(this.prodCategoryMediaArray[i]);
                    }*/
                }
            })
            .catch(error => {
                this.screenLoaded = false;
                this.error = error.status;
                console.error('==' + error);
            });
    }

    redirectToSubCategory(event) {
        this.screenLoaded = true;
        let categoryId = event.currentTarget.getAttribute('data-id');
        let categoryName = event.currentTarget.getAttribute('data-name');
        console.log('categoryName==== ' + categoryName);
        console.log('categoryId====== ' + categoryId);
        if (categoryId !== '' && categoryId !== undefined) {
            window.localStorage.setItem('CurrentGAlistname', categoryName + ' Category' );
            invokeGoogleAnalyticsService('CATEGORY LINK CLICK', categoryName); 
            let urlString = window.location.origin;
            let redirectURL = urlString + communityName + 'categories/' + categoryId  + '/'+ categoryName;
            //let redirectURL = urlString + communityName + 'categories?id=' + categoryId  + '&store=' + this.sendLocBackToChangeLocTile;
            console.log('=======redirectURL====' + redirectURL);
            window.location.href = redirectURL;
            this.screenLoaded = false;
        }
    }


   
}