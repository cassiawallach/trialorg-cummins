import {
    api,
    track,
    LightningElement
} from 'lwc';
import communityName from '@salesforce/label/c.dbu_communityName';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A';
import pubsub from 'c/pubsub';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

export default class Dbu_homePageCategoryItemDetail extends LightningElement {
    @api subcategory;
    @track pageURL;

    @track subcategoryname;
    @track locationstore;
    @track storeUSA = storeUSA;

    connectedCallback() {
        console.log('Dbu_homePageCategoryItemDetail =>subcategory=>' + JSON.stringify(this.subcategory));

        /**Code added related to get store */
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        this.locationstore =  window.sessionStorage.getItem('setCountryCode');
        //this.locationstore = url.searchParams.get("store");
        console.log('this.locationstore ' + this.locationstore);
        
        if(this.locationstore == undefined){
            this.locationstore = this.storeUSA;
            console.log('Inside locationStore undefined======='+this.locationstore);
        }

        let urlString = window.location.origin;
          //this.pageURL = urlString + communityName + 'categories?id=' + this.subcategory.Id + '&store=' + this.locationstore;
        //this.pageURL = urlString + communityName + 'Categories?id=' + this.subcategory.Id;
        //this.pageURL = urlString + communityName + this.subcategory.dbu_Community_Page_Name__c;

        this.subcategoryname = this.subcategory.Name;
        this.pageURL = urlString + communityName + 'categories/' + this.subcategory.Id + '/'+ this.subcategoryname;        
        console.log('Dbu_homePageCategoryItemDetail =>this.subcategory.Id=>' + this.subcategory.Id);
        console.log('Dbu_homePageCategoryItemDetail =>this.subcategoryname=>' + this.subcategoryname);

    }
    register() {
        console.log('event registered in lst product details');
        pubsub.register('sendDataToCustomSearch', this.handleEventLoc.bind(this));
    }

    navigateToCategoryURL(){
        console.log('ENTERING IN THE navigateToCategoryURL');
        invokeGoogleAnalyticsService('SUBCATEGORY LINK CLICK', this.subcategoryname);                 
    }

    get categoryPageURL(){
        return this.pageURL;
    } 

    handleEventLoc(event){
        this.locationstore = event;
        console.log(' this.locationstore'+ this.locationstore)
      }
}