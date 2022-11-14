import {

    LightningElement,

    track

} from 'lwc';

import myResource from '@salesforce/resourceUrl/cloudMVP';

//import cumminsLogo from '@salesforce/resourceUrl/dbu_CumminsLogo';
import svgLogos from '@salesforce/resourceUrl/dbu_svgLogos';

import {

    NavigationMixin

} from 'lightning/navigation';

import communityName from '@salesforce/label/c.dbu_communityName';

import pubsub from 'c/pubsub';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';//custom label refres to'CA'

export default class Dbu_cumminsLogo extends NavigationMixin(LightningElement) {

 

    //logoImg = myResource+'/images/cumminsLogo.png';

    //logoImg = cumminsLogo;
    logoImg = svgLogos + '/SVG/CumminslogoBLACK.svg';

    @track baseURL;

    @track locationData;

 

    connectedCallback() {

        this.regiser();

        /*commented to make the navigation through navigatiin mixin*/

        // let urlString = window.location.origin;

        // this.baseURL = urlString + communityName;

        /*commented to make the navigation through navigatiin mixin*/

 

        /*added by mounika t to navigation through nav mixin */

        let locationURL = window.location.href;

        console.log('locationURL' + locationURL);

        var url = new URL(locationURL);

        //this.locationData = url.searchParams.get("store");
        this.locationData = window.sessionStorage.getItem('setCountryCode');

        console.log('locationURL111' + this.locationData);

        /*added by mounika t to navigation through nav mixin */

    }

    handleClick(event) {

        console.log('locationData in cummins logo in onclick' + this.locationData);
        
        if(this.locationData == null || this.locationData == undefined || this.locationData == '' || this.locationData == 'undefined'){
            this.locationData = window.sessionStorage.getItem('setCountryCode');
          }
          if(this.locationData == null || this.locationData == undefined || this.locationData == '' || this.locationData == 'undefined'){
            this.locationData = storeUSA;
          }        

        let currlocationURL = window.location.href;
        let pathname = new URL(currlocationURL).pathname;
        console.log('pathname > ' + pathname);
        invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Cummins Logo CLick', eventAction : 'Navigate from ' + pathname + ' to home page'});
 
        window.localStorage.setItem('googleanalyticsOrderReview', false);
        window.localStorage.setItem('googleanalyticsreturnreview', false)
        pubsub.fire('CumminsLogoSendLocToStore', this.locationData);

        let urlString = window.location.origin;
        if (this.locationData == storeUSA || this.locationData == storeCA) {
            window.location.href = urlString + communityName + '?store=' + this.locationData;
          } if (this.locationData == storeCAF) {
            window.location.href = window.location.origin + communityName + '?store=' + this.locationData;
          }
        
       // window.location.href = urlString + communityName + '?store='+ this.locationData;        


    }

 

    regiser() {
        pubsub.register('sendLocToCumminsLogoLWC', this.handleEventLocation.bind(this));
        pubsub.register('sendDataTolstProdDetailspage', this.handleEventLoc.bind(this));
    }

    handleEventLoc(event) {
        console.log('event in handler sendDataTolstProdDetailspage>>' + event);
        this.locationData= event;    
      }

    handleEventLocation(event) {
        console.log('event in handler sendLocToCumminsLogoLWC >>' + event);
        this.locationData = event;
    }

}