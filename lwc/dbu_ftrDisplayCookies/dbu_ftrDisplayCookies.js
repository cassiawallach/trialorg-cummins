import {
  LightningElement,
  track
} from 'lwc';
import communityName from'@salesforce/label/c.dbu_communityName';
import dbu_home_footer_cookieMessage from '@salesforce/label/c.dbu_home_footer_cookieMessage';
import dbu_home_footer_cookieAccept from '@salesforce/label/c.dbu_home_footer_cookieAccept';
import dbu_home_footer_privacyPolicy from '@salesforce/label/c.dbu_home_footer_privacyPolicy';
import pubsub from 'c/pubsub';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

export default class Dbu_ftrDisplayCookies extends LightningElement {
  @track data;
  @track privacyPolicyURL;
  @track footercookimsg;
  @track acceptmsg;
  @track privacyPolicyMsg;
  @track cookieaccepted = false;

  createCookie(name, value, days) {
    var expires;

    if (days) {
      var date = new Date();
      date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
      expires = "; expires=" + date.toGMTString();
    } else {
      expires = "";
    }
    document.cookie = name + "=" + escape(value) + expires + "; path=/";
  }

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
      }
    }
  }
  @track isModalOpen = true;

  submitDetails() {

    //this.getCookie('footerBanner');
    this.isModalOpen = false;
    this.cookieaccepted = true;
    console.log(' this.cookieaccepted'+ this.cookieaccepted);
    invokeGoogleAnalyticsService('ACCEPT COOKIES', 'ACCEPT COOKIES'); 
    this.createCookie('footerBanner', 'true', 7);
    pubsub.fire('sendAcceptDataTChangeLocationtile', this.cookieaccepted);
    location.reload();
  }
  connectedCallback() {
    this.getCookie('footerBanner');
    this.footercookimsg=dbu_home_footer_cookieMessage;
    this.acceptmsg = dbu_home_footer_cookieAccept;
    this.privacyPolicyMsg = dbu_home_footer_privacyPolicy;

    if (this.data == 'true') {
      this.isModalOpen = false;
    }
    this.baseURL = window.location.origin+communityName;
    
    //this.privacyPolicyURL = this.baseURL + 'privacy-policy';
    this.privacyPolicyURL = this.baseURL + 'privacy-policy'; // Addes By Dhiraj for SEO (4th Jan 2021)
    //FOLLOWING REGISTER ADDED BY MALHAR - 15/12/2020
    this.register();
  }

  //FOLLOWING REGISTER ADDED BY MALHAR - 15/12/2020
  register(){
    window.console.log('entering in ftrdisplaycookies register method');
    pubsub.register('ResetFooterBannermodalfromCart', this.handleModalOpenCloseEvent.bind(this));
  }
  
  //FOLLOWING METHOD ADDED BY MALHAR - 15/12/2020
  handleModalOpenCloseEvent(event){
    console.log('entering in ResetFooterBannermodalfromCart event > '+ JSON.stringify(event));
    if(event){
      this.isModalOpen = false;
      this.cookieaccepted = true;
    }
  }


}