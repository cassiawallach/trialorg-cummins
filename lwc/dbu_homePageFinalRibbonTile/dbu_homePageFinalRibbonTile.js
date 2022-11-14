import { LightningElement,track } from 'lwc';
import communityName from'@salesforce/label/c.dbu_communityName';
import dbu_home_footer_transparencySupplyChains from '@salesforce/label/c.dbu_home_footer_transparencySupplyChains';
import dbu_home_footer_privacyPolicy from '@salesforce/label/c.dbu_home_footer_privacyPolicy';
import dbu_home_footer_termsOfUse from '@salesforce/label/c.dbu_home_footer_termsOfUse';
import dbu_AccessbilityStatement from '@salesforce/label/c.dbu_AccessbilityStatement';
import dbu_home_footer_siteMap from '@salesforce/label/c.dbu_home_footer_siteMap';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import Canada_CA from '@salesforce/label/c.dbu_home_store_Canada_CA';//custom label refres to'CA'
import dbu_Store_CAF from '@salesforce/label/c.dbu_Store_CAF';//custom label refres to'CAF'
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import pubsub from 'c/pubsub' ; 

export default class Dbu_homePageFinalRibbonTile extends LightningElement {
    showUSPrivacyPlcy = true;
    showCAPrivacyPlcy = false;
    showTermAndCondition = true;
    
    @track transfermsg;
    @track privacymsg;
    @track termsofusemsg;
    @track accessbilitymsg;
    @track sitemapmsg;
    @track termOfUseURL;
    @track privacyPolicyURL;
    @track storeLocation;
    @track storeUSA;
    @track storeCA;
    @track storeCAF;
    @track Canada_CA;
    @track canada_CAF;
    @track sitemapURL;

connectedCallback() {
    this.regiser();
    this.accessbilitymsg= dbu_AccessbilityStatement;
    this.sitemapmsg = dbu_home_footer_siteMap;
    this.transfermsg = dbu_home_footer_transparencySupplyChains;
    this.privacymsg = dbu_home_footer_privacyPolicy;
    this.termsofusemsg = dbu_home_footer_termsOfUse;
    this.storeUSA = storeUSA;
    this.storeCA = storeCA;
    this.storeCAF = storeCAF;
    this.Canada_CA = Canada_CA;
    this.canada_CAF = dbu_Store_CAF;

    //Date 11th Jan 2021 Dhiraj
    let locationURL = window.location.href;
    console.log('locationURL' + locationURL);
    var url = new URL(locationURL);
    this.storeLocation = url.searchParams.get("store");
    this.accessibilityUrl = 'https://www.cummins.com/company/diversity/accessibility';
    this.baseURL = window.location.origin+communityName;
    this.termOfUseURL = this.baseURL + 'termofuse?store=' + this.storeLocation;
    this.privacyPolicyURL = this.baseURL + 'privacy-policy?store=' + this.storeLocation;
    this.sitemapURL = this.baseURL + 'site-map?store=' + this.storeLocation;
    this.transperencySupplychain = 'https://www.cummins.com/company/ethics-and-compliance/transparency-in-supply-chains';
    
}
regiser(){
    window.console.log('event registered ');
    pubsub.register('displayPrvtPlcy', this.handledisplayPrvtPlcy.bind(this));
    pubsub.register('locationSelected', this.handleLocationSelected.bind(this));    
}

handleprypolicy(){
    invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open Privacy policy page'); 
}

get openprivacypolicyurl(){
    return this.privacyPolicyURL;
}

handleAccesscibility(){
    invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open Accessiblity statement');
    invokeGoogleAnalyticsService('EXTERNAL LINK', {eventAction : 'Open Accessiblity statement', eventCategory : 'External Link', eventLabel : this.accessibilityUrl});                 
}

get openAccessbility(){
    return this.accessibilityUrl;
}

handletermconditions(){
    invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open Terms of Use');
}

get openterncondition(){
    return this.termOfUseURL;
}

handlesitemap(){
    invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open Sitemap');
}

get opensitemap(){
    return this.sitemapURL;
}

handletranssupplychain(){
    invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open Transperency in supply chain URL');
    invokeGoogleAnalyticsService('EXTERNAL LINK', {eventAction : 'Open Transperency in supply chain URL', eventCategory : 'External Link', eventLabel : this.transperencySupplychain});                 
}

get supplychn(){
    return this.transperencySupplychain;
}


handledisplayPrvtPlcy(location) {
    if(location == this.storeUSA){
        this.showUSPrivacyPlcy = true;
        this.showCAPrivacyPlcy = false;
    this.canada_CAF = dbu_Store_CAF;
    } if(location == this.Canada_CA || location == this.canada_CAF){
        this.showUSPrivacyPlcy = false;
        this.showCAPrivacyPlcy = true;
    }
    
}
handleLocationSelected(location){
    console.log('location value ' + location);
    if(location == this.storeUSA){
        this.showTermAndCondition = true;
    }else if(location == this.Canada_CA || location == this.canada_CAF){
        this.showTermAndCondition = false;
    }
}

}