import {
    LightningElement,
    track
} from 'lwc';
import communityName from '@salesforce/label/c.dbu_communityName';
import pubsub from 'c/pubsub';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada'; //custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French'; //custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';  //custom label refres to'CA'

export default class Dbu_footerCheckoutFlow extends LightningElement {
    @track returnAndRefumdURL;
    @track shippingPolicyURL;
    @track corePolicyURL;
    @track warantyInformationURL;
    @track PurchaseAgreementsURL;
    @track termOfUseURL;
    @track currentStorelocation;
    showUSPrivacyPlcy = true;
    showCAPrivacyPlcy = false;
    showTermAndCondition = true;

    connectedCallback() {

        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        //this.storeLocation = url.searchParams.get("store");

        this.storeLocation = window.sessionStorage.getItem('setCountryCode');
        //pubsub.fire('sendLocToStore', this.sendLocBackToChangeLocTile);
        /*added by mounika t to navigation through nav mixin */
        if(this.storeLocation == storeUSA || 
            this.storeLocation == undefined ||
            this.storeLocation == null || this.storeLocation == ''){
            this.storeLocation = storeUSA;
            this.currentStorelocation = storeUSA;  
        }else if(this.storeLocation == storeCA || this.storeLocation == storeCAF){
            this.currentStorelocation = storeCanada;             
        }
        


        this.baseURL = window.location.origin + communityName;
        this.returnAndRefumdURL = this.baseURL + 'refund-policy'+ '?store='+this.storeLocation;
        this.shippingPolicyURL = this.baseURL + 'shipping-policy'+'?store='+this.storeLocation;
        this.corePolicyURL = this.baseURL + 'core-policy'+'?store='+this.storeLocation;
        this.warantyInformationURL = this.baseURL + 'warranty'+'?store='+this.storeLocation;
        this.PrivacyURL = this.baseURL + 'privacy-policy'+'?store='+this.storeLocation;
        this.termOfUseURL = this.baseURL + 'termofuse'+'?store='+this.storeLocation;

        this.regiser();
    }
    regiser() {
        window.console.log('event registered ');
        pubsub.register('displayPrvtPlcy', this.handledisplayPrvtPlcy.bind(this));
        pubsub.register('locationSelected', this.handleLocationSelected.bind(this));


    }


    
    navigateTotermconditionURLPage(){        
        console.log('ENTERING IN THE navigateToterncondtiondURLPage');
        invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open Terms and conditions');                 
    } 

    navigateToReturnRefundURLPage(){        
        console.log('ENTERING IN THE navigateToReturnRefundURLPage');
        invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open Return and Refund policy');               
    } 

    navigateToShippingPolicyURLPage(){        
        console.log('ENTERING IN THE navigateToShippingPolicyURLPage');
        invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open shipping policy');               
    }  

    navigateTocorePolicyURLPage(){        
        console.log('ENTERING IN THE navigateTocorePolicyURLPage');
        invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open Core policy');
    }  

    navigateToWarantyInformationPage(){        
        console.log('ENTERING IN THE navigateToWarantyInformationPage');
        invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open Warranty Information');                 
    }   
    
    navigateToprivacypolicyPage(){        
        console.log('ENTERING IN THE navigateToprivacypolicyPage');
        invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open Privacy policy');             
    }    

    get corepolicyPageURL(){
        return this.corePolicyURL;
    }        
    
    get shippingpolicyPageURL(){
        return this.shippingPolicyURL;
    }        
    
    get returnRefundPageURL(){
        return this.returnAndRefumdURL;
    }            

    get navigateWarantyPageURL(){
        return this.warantyInformationURL;
    }

    get privacypolicyPageURL(){
        return this.PrivacyURL;
    }

    get termmconditionPageURL(){
        return this.termOfUseURL;
    }

    handledisplayPrvtPlcy(location) {
        if (location == 'US') {
            this.showUSPrivacyPlcy = true;
            this.showCAPrivacyPlcy = false;
        }
        if (location == 'CA' || location == 'CAF') {
            this.showUSPrivacyPlcy = false;
            this.showCAPrivacyPlcy = true;
        }

    }
    handleLocationSelected(location) {
        console.log('location value ' + location);
        if (location == 'US') {
            this.showTermAndCondition = true;
        } else if (location == 'CA' || location == 'CAF') {
            this.showTermAndCondition = false;
        }
    }

}