import { LightningElement,track } from 'lwc';
import communityName from'@salesforce/label/c.dbu_communityName';
import dbu_footerLocation from '@salesforce/label/c.dbu_footerLocation'; // Added by DS 27th Jan 2021
import dbu_home_footer_contactUs from '@salesforce/label/c.dbu_home_footer_contactUs';
import dbu_home_footer_locations from '@salesforce/label/c.dbu_home_footer_locations';
import dbu_home_footer_FAQ from '@salesforce/label/c.dbu_home_footer_FAQ';
import dbu_home_footer_returnAndRefundPolicy from '@salesforce/label/c.dbu_home_footer_returnAndRefundPolicy';
import dbu_home_footer_shoppingPolicy from '@salesforce/label/c.dbu_home_footer_shoppingPolicy';
import dbu_home_footer_corePolicy from '@salesforce/label/c.dbu_home_footer_corePolicy';
import dbu_home_footer_warrantyInformation from '@salesforce/label/c.dbu_home_footer_warrantyInformation';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

export default class Dbu_homePageFtrHelpTile extends LightningElement {
    @track contactUsURL;
    @track locationURL;
    @track FAQURL;
    @track returnAndRefumdURL;
    @track shippingPolicyURL;
    @track corePolicyURL;
    @track warantyInformationURL;
    @track PurchaseAgreementsURL;
    /*added by MT to form store value in url*/
    @track storeLocation;
    /*added by MT to form store value in url*/
    @track footerLocation; // Added by DS 27th Jan 2021
    @track contactUs = dbu_home_footer_contactUs;
    @track dbu_location = dbu_home_footer_locations;
    @track FAQ = dbu_home_footer_FAQ;
    @track returnAndRefundPolicy = dbu_home_footer_returnAndRefundPolicy;
    @track shoppingPolicy = dbu_home_footer_shoppingPolicy;
    @track corePolicy = dbu_home_footer_corePolicy;
    @track warrantyInformation = dbu_home_footer_warrantyInformation;


    connectedCallback(){

        let locationURL = window.location.href;
        var url = new URL(locationURL);
        //this.storeLocation = url.searchParams.get("store");
        this.storeLocation = window.sessionStorage.getItem('setCountryCode');
        console.log('storeLocation>>' +this.storeLocation);
        if(this.storeLocation == storeUSA || 
            this.storeLocation == undefined ||
            this.storeLocation == null || this.storeLocation == ''){
            this.storeLocation = storeUSA;            
        }          
        console.log('storeLocation 2 >>' +this.storeLocation);
        this.baseURL = window.location.origin+communityName;
        this.contactUsURL = this.baseURL + 'contact-us?store=' + this.storeLocation;
        this.locationURL = this.baseURL + 'locations?store=' + this.storeLocation;
        this.FAQURL = this.baseURL + 'faq?store=' + this.storeLocation;
        this.returnAndRefumdURL = this.baseURL + 'refund-policy?store=' + this.storeLocation;
        this.shippingPolicyURL = this.baseURL + 'shipping-policy?store=' + this.storeLocation;
        this.corePolicyURL = this.baseURL + 'core-policy?store=' + this.storeLocation;
        this.warantyInformationURL = this.baseURL + 'warranty?store=' + this.storeLocation;
        this.PurchaseAgreementsURL = this.baseURL + 'purchaseagreements?store=' + this.storeLocation;
        this.footerLocation = dbu_footerLocation; // Added by DS 27th Jan 2021
    }

    navigateToContactUsPage(){        
        console.log('ENTERING IN THE navigateToContactUsPage');
        invokeGoogleAnalyticsService('CONTACT US FOOTER LINK CLICK', 'Page Navigation');                 
    }

    navigateToWarantyInformationPage(){        
        console.log('ENTERING IN THE navigateToWarantyInformationPage');
        invokeGoogleAnalyticsService('WARRANTY INFORMATION FOOTER LINK CLICK', 'Page Navigation');                 
    }

    navigateToLocationsPage(){        
        console.log('ENTERING IN THE navigateToLocationsPage');
        invokeGoogleAnalyticsService('LOCATIONS FOOTER LINK CLICK', 'Page Navigation');      
        invokeGoogleAnalyticsService('EXTERNAL LINK', {eventAction : 'Navigate To Location URL', eventCategory : 'External Link', eventLabel : this.footerLocation});                 
    }

    navigateToFAQPage(){        
        console.log('ENTERING IN THE navigateToFAQPage');
        invokeGoogleAnalyticsService('FAQ FOOTER LINK CLICK', 'Page Navigation');                 
    }  

    navigateToReturnRefundURLPage(){        
        console.log('ENTERING IN THE navigateToReturnRefundURLPage');
        invokeGoogleAnalyticsService('RETURNREFUND FOOTER LINK CLICK', 'Page Navigation');                 
    } 

    navigateToShippingPolicyURLPage(){        
        console.log('ENTERING IN THE navigateToShippingPolicyURLPage');
        invokeGoogleAnalyticsService('SHIPPING POLICY FOOTER LINK CLICK', 'Page Navigation');                 
    }  

    navigateTocorePolicyURLPage(){        
        console.log('ENTERING IN THE navigateTocorePolicyURLPage');
        invokeGoogleAnalyticsService('CORE POLICY FOOTER LINK CLICK', 'Page Navigation');                 
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
    
    get FAQPageURL(){
        return this.FAQURL;
    }    

    get navigateWarantyPageURL(){
        return this.warantyInformationURL;
    }

    get ContactUSPageURL(){
        return this.contactUsURL;
    }

    get locationsPageURL(){
        return this.footerLocation;
    }    
        
}