import {
  LightningElement,
  wire,
  track,
  api
} from 'lwc';
import communityName from '@salesforce/label/c.dbu_communityName';
import fetchhomePageCategoryDetails from '@salesforce/apex/dbu_homePageCategoryTileCtrl.fetchhomePageCategoryDetails';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import Canada_CA from '@salesforce/label/c.dbu_home_store_Canada_CA';//custom label refres to'CA'
import currentPromotions from '@salesforce/label/c.dbu_home_carousel_currentPromotions';
import deals from '@salesforce/label/c.dbu_deals';//Custome Label refers to 'Deals'
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

import pubsub from 'c/pubsub';
/******************************************************
import bootstrap from '@salesforce/resourceUrl/dbu_bootstrap/css/bootstrap.min.css';
import jquery from '@salesforce/resourceUrl/jsquery224/jquery.min.js';
import bootstrapJquery from '@salesforce/resourceUrl/dbu_bootstrap/js/bootstrap.min.js';
import jquery from '@salesforce/resourceUrl/jquery224';
import bootstrap from '@salesforce/resourceUrl/dbu_bootstrap';/
******************************************************/ 
export default class Dbu_homePageCategoryTile extends LightningElement {

@track IsDisplayBannerShown = true;
@track allCategory;
@track currentpromotionsURL;
//@track currentLocation = 'US'; 
@track currentLocation; 
//@track currentLanguage = 'US';
@track storeUSA = storeUSA;
@track storeCA = storeCA;
@track storeCAF = storeCAF;
@track canada_CA = Canada_CA;
@track currentPromotions = currentPromotions;
@track locationstore;
@track isDealsAvailable = false;
@track currentdealsURL;
@track deals = deals;
@track catArray = [];
@track tmpObj = {};

  @wire(fetchhomePageCategoryDetails, 
  {
    country: '$locationstore'
  })
  wireProduct({
    error,
    data
  }) {
    if (data) 
    {
      if(data.Showdeals){
        this.isDealsAvailable = JSON.parse(data.Showdeals);
      }
      for(let key in data){
        if(key!='Showdeals'){
          this.tmpObj = {'Id':key, 'Name':data[key]}
          this.catArray.push(this.tmpObj);
        }
      }
      this.allCategory = this.catArray;
      console.log('allCategory>>>>>>>>>>23', (this.allCategory));
      console.log("CURRENT LOCATION 1", this.locationstore);
    } 
    else if (error) 
    {
      this.error = error;
      this.allCategory = undefined;
    }
  }

  /******************************************************
  getCookie(name) {
    var name = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0) == ' ') {
        c = c.substring(1);
      }
      if (c.indexOf(name) == 0) {
        this.data = c.substring(name.length, c.length);
        console.log('this.currentLocation>>>51 ' +this.currentLocation);
      }
    }
  }
  ******************************************************/ 
  connectedCallback() 
  {
      let locationURL = window.location.href;
      console.log('locationURL' + locationURL);
      var url = new URL(locationURL);
      this.locationstore = window.sessionStorage.getItem('setCountryCode');
     // this.locationstore = url.searchParams.get("store");

      console.log('this.currentLocation 57>>> ' + this.currentLocation );
      if(this.locationstore == this.storeCA || this.locationstore == this.storeCAF) 
      {
        console.log('inside US');
        this.currentLocation = this.canada_CA;
      }


      if (this.locationstore == this.storeUSA) {
        //check if url has yamamha
        if (window.location.pathname.includes('yamaha')) {
         if (window.sessionStorage.getItem('setCountryCode') == this.storeUSA) {
          if (window.location.origin == 'https://fr-shop.cummins.com' || window.location.origin == 'https://gwccdn.cummins.com') {
           window.sessionStorage.setItem('setCountryCode', this.storeCAF);    
           this.currentLocation = this.canada_CA;
           this.locationstore = this.storeCAF; 
          } else {
           window.sessionStorage.setItem('setCountryCode', this.storeCA);     
           this.currentLocation = this.canada_CA;
           this.locationstore = this.storeCA;
          }
          pubsub.fire('sendLocToStoreForYahamaCategory', this.locationstore);
          pubsub.fire('sendLocToCumminsLogoLWC', this.locationstore);            
         }
        }else{
         this.currentLocation = this.storeUSA;
        }
       }

       if(this.currentLocation == undefined)
       {
        if (window.location.pathname.includes('yamaha')) {
         if (window.sessionStorage.getItem('setCountryCode') == this.storeUSA ||
           window.sessionStorage.getItem('setCountryCode') == undefined ||
           window.sessionStorage.getItem('setCountryCode') == null ||
           window.sessionStorage.getItem('setCountryCode') == 'undefined' ) {
          if (window.location.origin == 'https://fr-shop.cummins.com' || window.location.origin == 'https://gwccdn.cummins.com') {
           window.sessionStorage.setItem('setCountryCode', this.storeCAF);
           this.currentLocation = this.canada_CA;
           this.locationstore = this.storeCAF;
          } else {
           window.sessionStorage.setItem('setCountryCode', this.storeCA);
           this.currentLocation = this.canada_CA;
           this.locationstore = this.storeCA;
          }
          console.log('Going to fire sendLocToStore event');
          pubsub.fire('sendLocToStoreForYahamaCategory', this.locationstore);
          console.log('Going to fire sendLocToCumminsLogoLWC event');
          pubsub.fire('sendLocToCumminsLogoLWC', this.locationstore); 
         }
        }else{
         this.currentLocation = this.storeUSA;
         this.locationstore = this.storeUSA;
         window.sessionStorage.setItem('setCountryCode', this.storeUSA);
         pubsub.fire('sendLocToStore', this.locationstore);
         pubsub.fire('sendLocToCumminsLogoLWC', this.locationstore);
        }
        
        console.log('this.currentLocation======= '+ this.currentLocation);
       }


      
      /******************************************************
      let sdata = localStorage.getItem('scountry');
      console.log('sdata>>>59 ' + sdata ); 
      this.currentLocation = sdata;
      console.log('this.currentLocation 63>>> ' + this.currentLocation );
      ******************************************************/
      
      let urlString = window.location.origin; //Rajnish 

      this.currentdealsURL = urlString + communityName + this.deals.toLowerCase()+'?store=' + this.locationstore; //CECI-954 deals page redirection

      //this.getCookie('headerBanner');
      console.log('this.currentLocation>>>69 ' + this.currentLocation );
      if (this.data == 'true')
      {
        console.log('categoryTitle')
        this.IsDisplayBannerShown = false;
      }
      this.register();

      // fetchhomePageCategoryDetails({ country: this.locationstore })
      //       .then(result => 
      //           { console.log("location fetch result", result);
      //           this.allCategory = result;
      //             this.error = undefined; })
      //       .catch(error =>
      //           { this.error = error;
      //       })
  }


  register() 
  {
    console.log('Inside Register ');
    console.log('listening the isBannerOpen event');
    pubsub.register('isBannerOpen', this.handleIsModelClosed.bind(this));
    //pubsub.register('displayYamaha', this.handleDisplayYamaha.bind(this)); 
    //pubsub.register('homepagecatetilelanguageChange', this.handlelanguageofStore.bind(this)); 
  }
  /******************************************************
  handlelanguageofStore(language)
  {
    this.currentLanguage = language;
    console.log('language changed to  => ' + this.currentLanguage);
  } 
  ******************************************************/     
  handleDisplayYamaha(location) 
  {
    this.currentLocation = location;
    console.log('Location changed to=>' + this.currentLocation);
    /******************************************************
     if (location == 'US') {
       this.displayYamaha = false;
     }
     if (location == 'CA') {
       this.displayYamaha = true;
    }
    ******************************************************/ 
  }
  handleIsModelClosed(event) 
  {
    console.log('entering the listner>>>' + event)
    this.IsDisplayBannerShown = event;
    console.log('data after assignation>>' + this.IsDisplayBannerShown);
  }
  get mainCss() 
  {
    //console.log("IsDisplayBannerShown in get fun " + IsDisplayBannerShown);
    return this.IsDisplayBannerShown ? 'lgc-bg-with-displaybanner' : 'lgc-bg-without-displaybanner';
  }
  menuParentClicked(event){
    var selClass = this.template.querySelectorAll(".selectedMenu");

    for (var s = 0; s < selClass.length; s++) {
      selClass[s].classList.remove("selectedMenu");
    }
    event.currentTarget.classList.add("selectedMenu");
  }

  handleDealsClick(){
    invokeGoogleAnalyticsService('DEALS LINK CLICK', "Deals")
    //invokeGoogleAnalyticsService("NAVIGATE TO CURRENT PROMOTION PAGE", "Current Promotion Page link Click")
  }
}