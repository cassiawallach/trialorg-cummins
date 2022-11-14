import { LightningElement,track } from 'lwc';
import shopByBrand from '@salesforce/resourceUrl/dbu_shopByBrandSvg';
import shopByBrands from '@salesforce/resourceUrl/dbu_shopbybrand';
import shopByBrandText from '@salesforce/label/c.dbu_shopByBrandText';
import { NavigationMixin } from 'lightning/navigation';
import communityName from'@salesforce/label/c.dbu_communityName';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A';
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import branddataid from '@salesforce/apex/dbu_getBrandDataIds.getBrandId';
export default class Dbu_homePageShopByBrand extends NavigationMixin(LightningElement) {
    @track backgroundImg = shopByBrands + '/background.png';
    @track cummins = shopByBrand + '/cumminslogoBLACK.svg';
    @track cumminsOnan = shopByBrands + '/cummins-onan.png';
    @track fleetguard = shopByBrand + '/fleetguardLogo.svg';
    @track valvoline = shopByBrand + '/valvolineLogo.svg';
    @track hebasto = shopByBrand + '/webastoLogo.svg';
    @track powerService = shopByBrand + '/powerserviceLogo.svg';
    @track yamaha = shopByBrands + '/yamaha.png';
    @track title = shopByBrandText;
    @track sendLocBackToChangeLocTile;
    @track screenLoaded = false;
    @track showCanadaProd = false;
    @track sectionClass = 'slds-grid slds-wrap sbbList'
    connectedCallback(){
          //let urlParameters = new URL(window.location.href).searchParams;
        //  this.orderId = urlParameters.get('orderid');
          let locationURL = window.location.href;
          console.log('locationURL' + locationURL);
          var url = new URL(locationURL);
         // this.sendLocBackToChangeLocTile = url.searchParams.get("store");
         this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
          if( this.sendLocBackToChangeLocTile === undefined || this.sendLocBackToChangeLocTile === null){
            this.sendLocBackToChangeLocTile = storeUSA;
          }
          if( this.sendLocBackToChangeLocTile === storeCA || this.sendLocBackToChangeLocTile === storeCAF){
            this.showCanadaProd = true;
            this.sectionClass = 'slds-grid slds-wrap sbbList caSbbList';
          }
      }
    handleCategory(event) {
        this.screenLoaded = true;
        console.log('Category Name===' + event.currentTarget.dataset.id);        
        let categoryByName =  event.currentTarget.dataset.id;
        invokeGoogleAnalyticsService('NAVIGATE TO SHOP BY BRAND PAGE', categoryByName);                 

        branddataid({
          BrandName : categoryByName
         }).then(result => {
          console.log('brandid > ' + result);
          let urlString = window.location.origin;    
          let redirectURL = urlString+communityName+ 'shopbybrand/'+result+'/'+categoryByName;
          window.location.href = redirectURL;
         }).catch(error => {
          this.error = error.message;
         })

        //let urlString = window.location.origin;
        //let redirectURL =  urlString+communityName+'shopbybrand?categoryName='+ categoryByName + '&store=' + this.sendLocBackToChangeLocTile;


    }
}