import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import shopByBrand from '@salesforce/resourceUrl/dbu_injector_with_box';


import communityName from '@salesforce/label/c.dbu_communityName';
import pubsub from 'c/pubsub';
import insertCon from '@salesforce/apex/dbu_ContactUs.insertCon';
import dbu_ContactUs__c from '@salesforce/schema/dbu_ContactUs__c';
import privacyText from '@salesforce/label/c.dbu_privacyText';
import privacyPolicyText from '@salesforce/label/c.dbu_Privacy_Policy';
import signUpNowOffersText from '@salesforce/label/c.dbu_signUpNowOffersText';
import subscribeNoteText from '@salesforce/label/c.dbu_home_footer_textMessage';
import pageText from '@salesforce/label/c.dbu_pageText';
import registrationURL from '@salesforce/label/c.dbu_registration_URL';
import dbu_ThanskYou from '@salesforce/label/c.dbu_ThanskYou';
import dbu_Subscribe from '@salesforce/label/c.dbu_Subscribe';
import dbu_haveaccount from '@salesforce/label/c.dbu_haveaccount';
import dbu_createaccount from '@salesforce/label/c.dbu_createaccount';
import dbu_done from '@salesforce/label/c.dbu_done';
import dbu_homepage_emailvalidation from '@salesforce/label/c.dbu_homepage_emailvalidation';
import dbu_homepage_invalidemailvalidation from '@salesforce/label/c.dbu_homepage_invalidemailvalidation';
import dbu_home_store_U_S_A from '@salesforce/label/c.dbu_home_store_U_S_A';
import dbu_home_store_Canada_CA from '@salesforce/label/c.dbu_home_store_Canada_CA';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
/*Aakriti CECI-765 added validation for guest user*/
import isGuest from '@salesforce/user/isGuest';

export default class Dbu_homePageSubscribe extends LightningElement {
    @track conRecord = dbu_ContactUs__c;
    @track backgroundImg = shopByBrand;

    showUS = true;
    showCA = false;
    showUSPrivacyPlcy = true;
    showCAPrivacyPlcy = false;
    @track homePage;
    @track thankYouSec = false;
    @track privacyPolicyURL;
    @track emailvalidation = dbu_homepage_emailvalidation;
    @track invalidemailvalidation = dbu_homepage_invalidemailvalidation;
    @track storeUSA = dbu_home_store_U_S_A;
    @track storeCanada = dbu_home_store_Canada_CA;


    @track email;
    @track emailvalue;
    @track textboxname;
    @track privacyText;
    @track signUpNowOffersText;
    @track subscribeNoteText;
    @track pageText;
    @track RegisterURL = registrationURL;
    @track thanksmsg;
    @track subscribemsg;
    @track createaccmsg;
    @track haveaccount ;
    @track donemsg;
    @track storeLocation;
    /*Aakriti CECI-765 added validation for guest user*/
    @track isGuestUser = isGuest;

    handleSubmit(event) {
        this.textboxname = event.target.name;
        //event.target.name.value
        //console.log('textboxname>>>73'+ this.textboxname);
        var inputValue = this.template.querySelector("input");
        var inputEmailValue = inputValue.value;
        var regExpEmailformat = new RegExp(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$/);
        var errorMessage = '';
        //this.emailvalue = event.target.value;
        console.log('emailvalue>>>73' + this.emailvalue);
        if (inputEmailValue == '' || inputEmailValue == undefined) {
            errorMessage = this.emailvalidation;
            this.showToast(errorMessage);

        } else if (!inputEmailValue.match(regExpEmailformat)) {
            errorMessage = this.invalidemailvalidation;
            this.showToast(errorMessage);
        } else {
            this.thankYouSec = true;
           // this.template.querySelector('.subscribeForm').style.display = 'none';
            console.log('Inside else ===> 47');
            let googleAnalyticsInput = {category : 'Sign Up', email : inputEmailValue};
            invokeGoogleAnalyticsService('SIGN UP LINK CLICK', googleAnalyticsInput);
            this.conRecord.dbu_subscribeEmailId__c = inputEmailValue;
            console.log('this.conRecord.dbu_subscribeEmailId__c ===> ' + this.conRecord.dbu_subscribeEmailId__c);
            insertCon({
                con: this.conRecord
            })
                .then(result => {
                    event.target.name = undefined;
                    console.log('Inside result52')
                    this.conRecord = {};
                    console.log('Inside result53' + event.target.name)

                    let form = this.template.querySelector('form');  
                    console.log('form=>'+JSON.stringify(form.elements[1].value));
                    try 
                    {
                        console.log('Before Submit>>> ' + form.elements[1].value);
                        console.log('Before Submit>>> ' + form.elements[2].value);
                        //console.log('Before Submit>>> ' + form.elements[3].value);
                        console.log('Before Submit>>> ' + form.elements[4].value);
                        console.log('Before Submit>>> ' + form.elements[5].value);
                        console.log('Before Submit>>> ' + form.elements[6].value);
                        
                        form.submit();
                        
                        console.log('After Submit>>> ' + form.elements[1].value);
                        console.log('After Submit>>> ' + form.elements[2].value);
                        //console.log('After Submit>>> ' + form.elements[3].value);
                        console.log('After Submit>>> ' + form.elements[4].value);
                        console.log('After Submit>>> ' + form.elements[5].value);
                        console.log('After Submit>>> ' + form.elements[6].value);
                    } 
                    catch (e) 
                    {
                        console.log('form submit error=>' + JSON.stringify(e));
                    }

                })
                .catch(error => {
                    this.error = error.message;
                });

        }
    }
    showToast(errorMessage) {
        const event = new ShowToastEvent({
            variant: 'error',
            message: errorMessage,
            mode: 'sticky' /*Aakriti CECI-765 added*/
        });
        this.dispatchEvent(event);
    }
    closeModal() {
        var inp = this.template.querySelector("input.field");
        inp.value = '';
        this.thankYouSec = false;
       // this.template.querySelector('.subscribeForm').style.display = 'block';

        //  this.email = inp.value;
        //  console.log(inp.value);
        //   console.log('this.email>>>97' + this.email);

        //  console.log('this.email>>>100' + this.email);
        // to close modal window set 'isModalOpen' tarck value as false
        //this.homePage = window.location.origin+communityName;  

        /*
        window.console.log('inputEmailValue Before ==> ' + this.inputEmailValue);
        teval("$A.get('e.force:refreshView').fire();");
        document.getElementById('inputEmailValue').reset()
        window.console.log('inputEmailValue After ==> ' + this.inputEmailValue);
        */
    }
    connectedCallback() {
        this.regiser();
        let locationURL = window.location.href;
        var url = new URL(locationURL);
        this.storeLocation = url.searchParams.get("store");
        this.baseURL = window.location.origin + communityName;
        this.privacyPolicyURL = this.baseURL + 'privacy-policy?store=' + this.storeLocation;
        this.privacyText = privacyText;
        this.privacyPolicyText = privacyPolicyText;
        this.signUpNowOffersText = signUpNowOffersText;
        this.subscribeNoteText = subscribeNoteText;
        this.pageText = pageText;
        this.thanksmsg = dbu_ThanskYou;
        this.subscribemsg = dbu_Subscribe;
        this.haveaccount = dbu_haveaccount;
        this.createaccmsg= dbu_createaccount;
        this.donemsg = dbu_done;


    }
    regiser() {
        window.console.log('event registered ');
        pubsub.register('displayTermsAndUse', this.handledisplayTermsAndUse.bind(this));
        pubsub.register('displayPrvtPlcy', this.handledisplayPrvtPlcy.bind(this));
    }
    handledisplayTermsAndUse(location) {
        if (location == this.storeUSA) {
            this.showUS = true;
            this.showCA = false;
        }
        if (location == this.storeCanada) {
            this.showUS = false;
            this.showCA = true;
        }
    }
    handledisplayPrvtPlcy(location) {
        if (location == this.storeUSA) {
            this.showUSPrivacyPlcy = true;
            this.showCAPrivacyPlcy = false;
        }
        if (location == this.storeCanada) {
            this.showUSPrivacyPlcy = false;
            this.showCAPrivacyPlcy = true;
        }
    }
}