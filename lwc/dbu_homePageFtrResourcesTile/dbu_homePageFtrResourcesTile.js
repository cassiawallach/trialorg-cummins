import {
    LightningElement,
    track
} from 'lwc';
import pubsub from 'c/pubsub';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent'
import communityName from '@salesforce/label/c.dbu_communityName';
import dbu_home_footer_textMessage from '@salesforce/label/c.dbu_home_footer_textMessage';

import insertCon from '@salesforce/apex/dbu_ContactUs.insertCon';
import dbu_ContactUs__c from '@salesforce/schema/dbu_ContactUs__c';
import registrationURL from '@salesforce/label/c.dbu_registration_URL';
import dbu_home_footer_privacyPolicy from '@salesforce/label/c.dbu_home_footer_privacyPolicy';
import dbu_home_footer_followUs from '@salesforce/label/c.dbu_home_footer_followUs';
import dbu_ThanskYou from '@salesforce/label/c.dbu_ThanskYou';
import dbu_Subscribe from '@salesforce/label/c.dbu_Subscribe';
import dbu_haveaccount from '@salesforce/label/c.dbu_haveaccount';
import dbu_createaccount from '@salesforce/label/c.dbu_createaccount';
import dbu_done from '@salesforce/label/c.dbu_done';
import dbu_eloqua_Post_URL from '@salesforce/label/c.dbu_eloqua_Post_URL';
import dbu_eloquaSubmitId from '@salesforce/label/c.dbu_eloquaSubmitId';
import dbu_homefooter_subscribe_Recordsentsuccessfully from '@salesforce/label/c.dbu_homefooter_subscribe_Recordsentsuccessfully';
import dbu_homepage_emailvalidation from '@salesforce/label/c.dbu_homepage_emailvalidation';
import dbu_homepage_invalidemailvalidation from '@salesforce/label/c.dbu_homepage_invalidemailvalidation';
import dbu_home_store_U_S_A from '@salesforce/label/c.dbu_home_store_U_S_A';
import dbu_home_store_Canada_CA from '@salesforce/label/c.dbu_home_store_Canada_CA';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
/*Aakriti CECI-765 added validation for guest user*/
import isGuest from '@salesforce/user/isGuest';

export default class Dbu_homePageFtrResourcesTile extends LightningElement {
    label = {
        dbu_eloqua_Post_URL,
        dbu_eloquaSubmitId
    };
    
    @track conRecord = dbu_ContactUs__c;
    showUS = true;
    showCA = false;
    showUSPrivacyPlcy = true;
    showCAPrivacyPlcy = false;
    @track homePage;
    @track isModalOpen = false;
    @track RegisterURL = registrationURL;
    @track privacyPolicyURL;
    @track textmsg;
    @track privacymsg;
    @track followusmsg;
    @track thanksmsg;
    @track subscribemsg;
    @track createaccmsg;
    @track haveaccount ;
    @track donemsg;
    @track recordsentsuccessfully;
    @track emailvalidation = dbu_homepage_emailvalidation;
    @track invalidemailvalidation = dbu_homepage_invalidemailvalidation;
    @track storeUSA = dbu_home_store_U_S_A;
    @track storeCanada = dbu_home_store_Canada_CA;
    /*Aakriti CECI-765 added validation for guest user*/
    @track isGuestUser = isGuest;

    /*
    connectedCallback() {
        let urlString = window.location.origin;
        //this.RegisterURL = urlString+'/cw/IAM_Basic_Registration?appid=a1a1F0000018d4x';
        //this.RegisterURL = 'https://csodev-cumminscss.cs90.force.com/cw/IAM_Basic_Registration?appid=a1a1F0000018d4x'; 
        console.log('RegisterURL>>>>>>' + this.RegisterURL);
        this.baseURL = window.location.origin + communityName;
        this.privacyPolicyURL = this.baseURL + 'privacypolicy'
    }*/

    handleSubmit(event) {
        var inputValue = this.template.querySelector("input");
        var inputEmailValue = inputValue.value;
        var regExpEmailformat = new RegExp(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$/);
        var errorMessage = '';

        if (inputEmailValue == '' || inputEmailValue == undefined) {
            errorMessage = this.emailvalidation;
            this.showToast(errorMessage);

        } else if (!inputEmailValue.match(regExpEmailformat)) {
            errorMessage = this.invalidemailvalidation;
            this.showToast(errorMessage);
        } else {
            // to open modal set isModalOpen tarck value as true
            this.isModalOpen = true;
            console.log('Inside else ===> 47');

            //this.conRecord.dbu_First_Name__c == '';
            //console.log('this.conRecord.dbu_First_Name__c ===> 50 ' + this.conRecord.dbu_First_Name__c);

            this.conRecord.dbu_subscribeEmailId__c = inputEmailValue;
            console.log('this.conRecord.dbu_subscribeEmailId__c ===> 53 ' + this.conRecord.dbu_subscribeEmailId__c);
            let googleAnalyticsInput = {category : 'Sign Up', email : inputEmailValue};            
            invokeGoogleAnalyticsService('SIGN UP LINK CLICK', googleAnalyticsInput);   
            insertCon({
                    con: this.conRecord
                })
                .then(result => {
                    // Clear the user enter values
                    this.conRecord = {};
                    console.log('result ===> 74 ' + result);
                    this.lname = 'Initial';
                    // to close modal window set 'isModalOpen' tarck value as false
                    //this.isModalOpen = false;
                    // Show success messsage
                    /*this.dispatchEvent(new ShowToastEvent({
                        title: 'Success!!', 
                        message: 'Contact Created Successfully!!',
                        variant: 'success'
                    }), );*/
                     
                    // "https://s1480.t.eloqua.com/e/f2";
                    
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
            mode: 'sticky'
        });
        this.dispatchEvent(event);
    }
    closeModal() {
        // to close modal window set 'isModalOpen' tarck value as false
        //this.homePage = window.location.origin+communityName;
        var inp = this.template.querySelector("input.field");
        inp.value = '';
        this.isModalOpen = false;

        /*
        window.console.log('inputEmailValue Before ==> ' + this.inputEmailValue);
        teval("$A.get('e.force:refreshView').fire();");
        document.getElementById('inputEmailValue').reset()
        window.console.log('inputEmailValue After ==> ' + this.inputEmailValue);
        */
    }


    connectedCallback() {
        this.regiser();
        this.textmsg = dbu_home_footer_textMessage;
        this.donemsg = dbu_done;
        this.haveaccount = dbu_haveaccount;
        this.createaccmsg= dbu_createaccount;
        this.privacymsg = dbu_home_footer_privacyPolicy;
        this.followusmsg = dbu_home_footer_followUs;
        this.thanksmsg = dbu_ThanskYou; 
        this.recordsentsuccessfully = dbu_homefooter_subscribe_Recordsentsuccessfully;
        this.subscribemsg = dbu_Subscribe;
        this.baseURL = window.location.origin+communityName;
        this.privacyPolicyURL = this.baseURL + 'privacy-policy';
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