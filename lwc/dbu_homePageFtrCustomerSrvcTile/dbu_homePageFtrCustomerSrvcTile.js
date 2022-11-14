import { LightningElement, track } from 'lwc';
import pubsub from 'c/pubsub';
import communityName from'@salesforce/label/c.dbu_communityName';
import FooterPhoneIcon from '@salesforce/resourceUrl/dbu_Footer_Phone';
import FooterMessage from '@salesforce/resourceUrl/FooterMessage';
import FooterLiveChat from '@salesforce/resourceUrl/FooterLiveChat';
import ChatIconFloating from '@salesforce/resourceUrl/dbu_chatIconFloating';

import getloginTime from '@salesforce/apex/dbu_IStToESTDateTimeDayConvevrsion.getloginTime';

import onlineText from '@salesforce/label/c.dbu_OnlineOfflineText';
import onlineRText from '@salesforce/label/c.dbu_OnlineOfflineresttext';
import offlinetext from '@salesforce/label/c.dbu_offlinetext';
import offlinetextManual from '@salesforce/label/c.dbu_offlinetextManual'; 
import contactnum from '@salesforce/label/c.dbu_contactnum';
import dbu_chatus from '@salesforce/label/c.dbu_chatus';
import dbu_home_footerCUMMINSTM from '@salesforce/label/c.dbu_home_footerCUMMINSTM';
import dbu_TM from '@salesforce/label/c.dbu_TM';
import dbu_home_footer_sendUsYourQuestions from '@salesforce/label/c.dbu_home_footer_sendUsYourQuestions';
import dbu_Have_a_question from '@salesforce/label/c.dbu_Have_a_question';

import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA';
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada';
import dbu_home_store_U_S_A from '@salesforce/label/c.dbu_home_store_U_S_A';
import dbu_home_store_Canada_CA from '@salesforce/label/c.dbu_home_store_Canada_CA';
import dbu_home_store_Canada from '@salesforce/label/c.dbu_home_store_Canada';
import dbu_home_store_Canada_French from '@salesforce/label/c.dbu_home_store_Canada_French';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

export default class Cm_homePageFtrCustomerSrvcTile extends LightningElement {

   @track contactUsURL;
    @track ChatIconFloating = ChatIconFloating;

   phoneIcon= FooterPhoneIcon+ '#phone';
   messageIcon =FooterMessage+'#Message';
   livechatIcon=FooterLiveChat+'#LiveChat';
   
    @track data;
    @track LTime;
    @track enableDisableButton = true;
    @track OnlineOfflineText;
    @track offlineManualDisablebtn;
    @track offlineAtext = offlinetext;
    @track offlineManual = offlinetextManual;
    @track OnlineOfflineText1 = onlineText;
    @track OnlineOfflineText2 = onlineRText;
    @track OnlineOfflineRText;
    @track OnlineOfflineTextPh;
    @track OnlineOfflineRTextPh;
    @track contactnum = contactnum;
    @track chatWithUs = dbu_chatus;
    @track footerCUMMINSTM = dbu_home_footerCUMMINSTM;
    @track tm = dbu_TM;
    @track sendUsYourQuestions = dbu_home_footer_sendUsYourQuestions;
    @track haveQuestion = dbu_Have_a_question;
    @track storeCountry; // Added By DKS on 15th March 2021
    @track countryCurrencyCode;
    @track storeUSA = dbu_home_store_U_S_A;
    @track storeCanada = dbu_home_store_Canada_CA;
    @track storeen = dbu_home_store_Canada;
    @track storefr = dbu_home_store_Canada_French;


    getfooterbannerCookie(name) {
        var name = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
          var c = ca[i];
          while (c.charAt(0) == ' ') {
            c = c.substring(1);
          }
          if (c.indexOf(name) == 0) {
            this.footerbannercookiestatus = c.substring(name.length, c.length);
          }
        }
      }

   connectedCallback(){

    this.storeCountry = window.sessionStorage.getItem('setCountryCode'); //urlParams.get('store');
    console.log('this.storeCountry=>' + this.storeCountry);
    this.locationstore = this.storeCountry;
    console.log('this.locationstore=>' + this.locationstore); 

    if(this.locationstore == null || this.locationstore == undefined || this.locationstore == this.storeUSA){
        this.locationstore = this.storeUSA;
        this.countryCurrencyCode = currencyCodeUSA;  
    }else if(this.locationstore == this.storeen){
        this.locationstore = this.storeCanada;
        //this.currentLanguage = 'EN';
        this.countryCurrencyCode = currencyCodeCanada;
    }else if(this.locationstore == this.storefr){
        this.locationstore = this.storeCanada;
        //this.currentLanguage = 'FR';
        this.countryCurrencyCode = currencyCodeCanada;
    }


       setTimeout(() => {
           console.log('this.footerbannercookiestatus cart connected call > ' + this.footerbannercookiestatus);
           this.getfooterbannerCookie('footerBanner');
           if (this.footerbannercookiestatus) {
               this.template.querySelector('.chatIconFloating').classList.remove('chatPositionTop');
           }
       }, 500);

    this.register();

      this.baseURL = window.location.origin+communityName;
      //this.contactUsURL = this.baseURL + 'contact-us';
      this.contactUsURL = this.baseURL + 'contact-us?store=' + this.locationstore; // Added By DKS on 15th March 2021
        getloginTime({ 
             storeName : this.storeCountry==null || this.storeCountry==undefined?'US':this.storeCountry
         }) // Sri passing the store
            .then(result => {
                if (result) {
                    console.log('result>>>' + JSON.stringify(result));
                    this.LTime = result;
                    console.log('this.LTime>>> ' + this.LTime);
                    if (this.LTime == 'true') {
                        this.enableDisableButton = false;
                        console.log('this.enableDisableButton>>> IF ' + this.enableDisableButton);

                        this.OnlineOfflineText = this.offlineAtext;
                        console.log('this.OnlineOfflineTextt>>> IF 55 ' + this.OnlineOfflineText);
                    }
                    if (this.LTime == 'false') {
                        this.enableDisableButton = true;
                        this.OnlineOfflineText = this.OnlineOfflineText1;
                        this.OnlineOfflineRText = this.OnlineOfflineText2;
                        //this.OnlineOfflineTextPh = this.OnlineOfflineText1;
                        //this.OnlineOfflineRTextPh = this.OnlineOfflineText2;

                        console.log('this.OnlineOfflineText  ' + this.OnlineOfflineText);
                        console.log('this.OnlineOfflineRText ELSE 58 ' + this.OnlineOfflineRText);

                        //console.log('OnlineOfflineTextPh+++  ' + OnlineOfflineTextPh);
                        //console.log('this.OnlineOfflineText>>> ELSE 58 ' + this.OnlineOfflineText);
                        //console.log('this.OnlineOfflineText>>> ELSE 58 ' + this.OnlineOfflineText);
                        //console.log('this.OnlineOfflineText1>>> ELSE 59 ' + this.OnlineOfflineText1);
                        //console.log('this.enableDisableButton>>> ELSE ' + this.enableDisableButton);
                    }
                    
                    if(this.LTime == 'ManualDisable'){
                        console.log('@@@Log Entered'+this.LTime);
                        this.enableDisableButton = true;
                        //console.log('this.enableDisableButton>>> IF ' + this.enableDisableButton);
                        this.offlineManualDisablebtn = this.offlineManual; 
                        console.log('this.offlineManualDisablebtn>>> IF 55 ' + this.offlineManualDisablebtn);
                    }

                }
            }).catch(error => {
                this.errorMessage = error.message;
                console.log('result from chat ', JSON.stringify(this.errorMessage));
            });
    }
    register() { 
        pubsub.register('sendAcceptDataTChangeLocationtile', this.handlesendAcceptDataTChangeLocationtile.bind(this));
    }
    
    navigateToContactUsPage() {
        console.log('ENTERING IN THE navigateToContactUsPage');
        invokeGoogleAnalyticsService('CONTACT US FOOTER LINK CLICK', 'Page Navigation');
    }
    get ContactUSPageURL() {
        return this.contactUsURL;
    }

    handlesendAcceptDataTChangeLocationtile(event) { 
            console.log('asddddddddddddddddddd');  
            this.template.querySelector('.chatIconFloating').classList.remove('chatPositionTop');
    }
    openRequestedPopup() {
        invokeGoogleAnalyticsService('CHAT LINK CLICK','Chat');  
        var topsss=window.screen.height-583;
        var leftsss=window.screen.width-384;        
        var windowObjectReference = window.open(
            "https://chat.cummins.com/system/templates/chat/cummins/chat.html?subActivity=Chat&entryPointId=1015&templateName=cummins&languageCode=en&countryCode=US&ver=v11",
            "popup", "width=384, height=583, top="+topsss+",left="+leftsss+"");
    }

   
}