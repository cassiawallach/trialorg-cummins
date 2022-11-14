import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import insertCon from '@salesforce/apex/dbu_ContactUs.insertCon';
import dbu_ContactUs__c from '@salesforce/schema/dbu_ContactUs__c';
import communityName from'@salesforce/label/c.dbu_communityName';
//import dbu_ContactUs__c_OBJECT from '@salesforce/schema/dbu_ContactUs__c';
//import isguest from '@salesforce/user/isGuest';
import getloginTime from '@salesforce/apex/dbu_IStToESTDateTimeDayConvevrsion.getloginTime';

import onlineText from '@salesforce/label/c.dbu_OnlineOfflineText';
import onlineRText from '@salesforce/label/c.dbu_OnlineOfflineresttext'; 
import offlinetext from '@salesforce/label/c.dbu_offlinetext'; 
import offlinetextManual from '@salesforce/label/c.dbu_offlinetextManual'; 
import dbu_home_footer_privacyPolicy from '@salesforce/label/c.dbu_home_footer_privacyPolicy';
import dbu_contactUs_message from '@salesforce/label/c.dbu_contactUs_message';
import dbu_contactUs_FirstName from '@salesforce/label/c.dbu_contactUs_FirstName';
import dbu_contactUs_title from '@salesforce/label/c.dbu_contactUs_title';
import dbu_contactUs_headerMessage from '@salesforce/label/c.dbu_contactUs_headerMessage';
import dbu_contactUs_whatCanHelp from '@salesforce/label/c.dbu_contactUs_whatCanHelp';
import dbu_contactUs_lastName from '@salesforce/label/c.dbu_contactUs_lastName';
import dbu_contactUs_email from '@salesforce/label/c.dbu_contactUs_email';
import dbu_contactUs_phoneNumber from '@salesforce/label/c.dbu_contactUs_phoneNumber';
import dbu_contactUs_provinceState from '@salesforce/label/c.dbu_contactUs_provinceState';
import dbu_contactUs_zipcode from '@salesforce/label/c.dbu_contactUs_zipcode';
import dbu_contactUs_typeOfCumminsProduct from '@salesforce/label/c.dbu_contactUs_typeOfCumminsProduct';
import dbu_contactUs_ESN from '@salesforce/label/c.dbu_contactUs_ESN';
import dbu_contactUs_GSN from '@salesforce/label/c.dbu_contactUs_GSN';
import dbu_contactUs_tellUsMore from '@salesforce/label/c.dbu_contactUs_tellUsMore';
import dbu_contactUs_submit from '@salesforce/label/c.dbu_contactUs_submit';
import dbu_eloqua_Post_URL from '@salesforce/label/c.dbu_eloqua_Post_URL';
import dbu_eloquaSubmitId from '@salesforce/label/c.dbu_eloquaSubmitId';
import dbu_contactUs_chat_with_us from '@salesforce/label/c.dbu_contactUs_chat_with_us';
import dbu_contactUs_contactno from '@salesforce/label/c.dbu_contactUs_contactno';
import dbu_contactUs_TM from '@salesforce/label/c.dbu_contactUs_TM';
import dbu_contactUs_dial_in from '@salesforce/label/c.dbu_contactUs_dial_in';
import dbu_contactUs_Thank_you from '@salesforce/label/c.dbu_contactUs_Thank_you';
import dbu_contactUs_record_sent_successfully from '@salesforce/label/c.dbu_contactUs_record_sent_successfully';
import dbu_contactUs_done from '@salesforce/label/c.dbu_contactUs_done';

//import { WaitUntilCustomerGUIDIsRetrieved } from 'c/Dbu_eloquaIntegration';

export default class Dbu_contactUs extends LightningElement {
    // Expose the value of @salesforce/user/isGuest in the template.
    //@track isGuestUser = isguest;
    //console.log('First Name ==> ' + isGuestUser);
    label = {
        dbu_contactUs_title,
        dbu_contactUs_headerMessage,
        dbu_contactUs_whatCanHelp,
        dbu_contactUs_FirstName,
        dbu_contactUs_lastName,
        dbu_contactUs_email,
        dbu_contactUs_phoneNumber,
        dbu_contactUs_provinceState,
        dbu_contactUs_zipcode,
        dbu_contactUs_typeOfCumminsProduct,
        dbu_contactUs_ESN,
        dbu_contactUs_GSN,
        dbu_contactUs_tellUsMore,
        dbu_contactUs_submit,
        dbu_eloqua_Post_URL,
        dbu_eloquaSubmitId,
        dbu_contactUs_chat_with_us,
        dbu_contactUs_contactno,
        dbu_contactUs_TM,
        dbu_contactUs_dial_in,
        dbu_contactUs_Thank_you,
        dbu_contactUs_record_sent_successfully,
        dbu_contactUs_done
    };
    //@track fromtypevalue = '';
    @track privacymsg;
    @track contactUsmsg;
    @track conRecord = dbu_ContactUs__c;
    @track conRecord1 = false;
    @track conRecord2 = false;
    @track conRecord3 = false;
    @track conRecord4 = false;
    @track conRecord5 = false;
    @track conRecord6 = false;
    @track areDetailsVisible = false;
    @track disabledCondition =false;
    @track isModalOpen = false;
    @track errorMessage = '';
    strLastName = '';
    @track showAccResult = false;
    @track privacyPolicyURL;
    @track baseURL;
    @track homePageURL;
    //@track privacyPolicyURL;
    @track LTime;
    @track enableDisableButton = false;

    @track OnlineOfflineText1 = onlineText;
    @track OnlineOfflineText2 = onlineRText;
    @track OnlineOfflineText;
    @track offlineManualDisablebtn;
    @track OnlineOfflineRText;

    @track OnlineOfflineTextPh;
    @track OnlineOfflineRTextPh; 
    @track offlineAtext = offlinetext;
    @track offlineManual = offlinetextManual;

    @track eloquaPostUrl;
    @track phoneVal = '+1 ';
    @track eloquaSUbscribeValue;

    connectedCallback() 
    {
        this.baseURL = window.location.origin+communityName;
        this.disabledCondition = true; 
        this.privacyPolicyURL = this.baseURL + 'privacy-policy'
        this.privacymsg = dbu_home_footer_privacyPolicy;
        this.contactUsmsg = dbu_contactUs_message;
        this.firstName = dbu_contactUs_FirstName;
        this.eloquaSUbscribeValue = 'Off';
//  Sri Chat
       //  Sri Chat
        var locationstore = window.sessionStorage.getItem('setCountryCode'); //urlParams.get('store');
        console.log('this.locationstore=>' + locationstore); 
        if(locationstore == null || locationstore == undefined ){
            locationstore = 'US'; 
        }

        getloginTime({ 
             storeName : locationstore // Sri Manage chat
         })
            .then(result => {
                if (result) {
                    console.log('result>>>' + JSON.stringify(result));
                    this.LTime = result;
                    console.log('this.LTime>>> ' + this.LTime);
                    
                    if(this.LTime == 'true'){
                        this.enableDisableButton = false;
                        console.log('this.enableDisableButton>>> IF @@@ ' + this.enableDisableButton);
                        console.log('ABCPRINTLOG');
                        this.OnlineOfflineText = this.offlineAtext; 
                        console.log('this.OnlineOfflineTextt>>> IF 55 ' + this.OnlineOfflineText);
                    }
                    if(this.LTime == 'false'){
                        this.enableDisableButton = true;
                        this.OnlineOfflineText = this.OnlineOfflineText1;
                        this.OnlineOfflineRText = this.OnlineOfflineText2;
                        
                        //this.OnlineOfflineTextPh = this.OnlineOfflineText1;
                        //this.OnlineOfflineRTextPh = this.OnlineOfflineText2;
                        console.log('this.OnlineOfflineText  ' + this.OnlineOfflineText);
                        console.log('this.OnlineOfflineRText ELSE 58 ' + this.OnlineOfflineRText);
                        /*
                        console.log('OnlineOfflineTextPh+++  ' + OnlineOfflineTextPh);
                        console.log('this.OnlineOfflineText>>> ELSE 58 ' + this.OnlineOfflineText);
                        console.log('this.OnlineOfflineText>>> ELSE 58 ' + this.OnlineOfflineText);
                        console.log('this.OnlineOfflineText1>>> ELSE 59 ' + this.OnlineOfflineText1);
                        console.log('this.enableDisableButton>>> ELSE ' + this.enableDisableButton);
                        */
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
                console.log('result from Chat ', JSON.stringify(this.errorMessage));
            });
    } 
    get options() {
        return [
            { label: 'I am looking for technical product information', value: 'I am looking for technical Product Information'},
            { label: 'I am looking for technical website support', value: 'I am looking for technical website support' },
            { label: 'I am looking for information about placing an online order', value: 'I am looking for information about placing an online order'},
            { label: 'I am looking for help tracking my order', value: 'I am looking for help tracking my order'},
            { label: 'I am looking for information on product warranty', value: 'I am looking for information on product warranty'},
            { label: 'I have other online store inquiries', value: 'I have other online store inquiries'},

        ];
    }
    
    handleCheckboxChange(event) {
        if (event.target.checked)
        { 
            this.eloquaSUbscribeValue = 'On';
            console.log('IF this.eloquaSUbscribeValue+++' + this.eloquaSUbscribeValue);
            this.disabledCondition = false;
        }
        else
        {
            console.log('ELSE this.eloquaSUbscribeValue+++' + this.eloquaSUbscribeValue);
            this.eloquaSUbscribeValue = 'Off';
            this.disabledCondition = false;
        }
    }
    
    handleChange(event) {
        this.value = event.detail.value;
        this.conRecord.dbu_What_Can_we_help_with_us__c = this.value;
        this.areDetailsVisible = event.target.checked;
        console.log('this.value>>>>> 30 ' + this.value);
        if(this.value == 'I am looking for technical Product Information')
        {
            this.conRecord1 = true;
            this.conRecord2 = false;
            this.conRecord3 = false;
            this.conRecord4 = false;
            this.conRecord5 = false;
            this.conRecord6 = false;
        }
        if(this.value == 'I am looking technical website support')
        {
            this.conRecord1 = false;
            this.conRecord2 = true;
            this.conRecord3 = false;
            this.conRecord4 = false;
            this.conRecord5 = false;
            this.conRecord6 = false;
        }
        if(this.value == 'I am looking for information about placing an online order')
        {
            this.conRecord1 = false;
            this.conRecord2 = false;
            this.conRecord3 = true;
            this.conRecord4 = false;
            this.conRecord5 = false;
            this.conRecord6 = false;
        }
        if(this.value == 'I am looking for help tracking my order')
        {
            this.conRecord1 = false;
            this.conRecord2 = false;
            this.conRecord3 = false;
            this.conRecord4 = true;
            this.conRecord5 = false;
            this.conRecord6 = false;
        }
        if(this.value == 'I am looking for information on product warranty')
        {
            this.conRecord1 = false;
            this.conRecord2 = false;
            this.conRecord3 = false;
            this.conRecord4 = false;
            this.conRecord5 = true;
            this.conRecord6 = false;
        }
        if(this.value == 'I have other online store inquiries')
        {
            this.conRecord1 = false;
            this.conRecord2 = false;
            this.conRecord3 = false;
            this.conRecord4 = false;
            this.conRecord5 = false;
            this.conRecord6 = true;
        }
        console.log('conRecord>>>>> 148 ' + this.conRecord);
    }

    get cumminsProductOptions() {
        return [
            //{ label: '---Select---', value: '---Select---'},
            { label: 'Engine Part', value: 'Engine Part'},
            { label: 'Generator Part', value: 'Generator Part' },
            { label: 'Other Parts', value: 'Other Parts'},
        ];
    }
    cumminsProducthandleChange(event) {
        const selectedOption  = event.detail.value;
        this.conRecord.dbu_Cummins_Product_Support__c = selectedOption;
        console.log('selectedOption= 153>>>' + selectedOption);
        console.log('this.conRecord.dbu_Cummins_Product_Support__c>>>' + this.conRecord.dbu_Cummins_Product_Support__c);
        
    }
    
    formatPhone(obj) {
        var numbers = obj.target.value.replace(/\D/g, ''),
            char = {
                0: '+',
                1: ' (',
                4: ') ',
                7: '-'
            };
        obj.target.value = '';
        for (var i = 0; i < numbers.length; i++) {
            obj.target.value += (char[i] || '') + numbers[i];
        }
    }

    handleFirstNameChange(event) {
        
        this.conRecord.dbu_First_Name__c = event.target.value;
        Cconsole.log('First Name ==> ' + this.conRecord.dbu_First_Name__c);
        Console.log('First Name Console ==> ' + this.conRecord.dbu_First_Name__c);
        
        this.conRecord.dbu_What_Can_we_help_with_us__c = this.value;
        Console.log('dbu_What_Can_we_help_with_us__c ==> 145 ' + this.conRecord.dbu_What_Can_we_help_with_us__);

        this.conRecord.dbu_Cummins_Product_Support__c = selectedOption;
        Console.log('dbu_Cummins_Product_Support__c ==> 145 ' +  this.conRecord.dbu_Cummins_Product_Support__c);
        
        this.conRecord.dbu_Subscribe__c = this.areDetailsVisible;
        Console.log('dbu_Subscribe__c ==> 148 ' + this.conRecord.dbu_First_Name__c);
    }
    handleLastNameChange(event) {
        this.conRecord.dbu_Last_Name__c = event.target.value;
        console.log('Last Name ==> ' + this.conRecord.dbu_Last_Name__c);
        this.strLastName = event.target.value;
    }
    handlePhoneChange(event) {
        this.conRecord.dbu_Phone__c = event.target.value;
        console.log('Phone ==> ' + this.conRecord.dbu_Phone__c);
    }
    handleEmailChange(event) {
        this.conRecord.dbu_Email__c = event.target.value;
        console.log('Email ==> ' + this.conRecord.dbu_Email__c);
    }
    handleAddressChange(event) {
        this.conRecord.dbu_Address__c = event.target.value;
        console.log('Address ==> ' + this.conRecord.dbu_Address__c);
    }
    handleStateChange(event) {
        this.conRecord.dbu_State__c = event.target.value;
        console.log('State ==> ' + this.conRecord.dbu_State__c);
    }
    handleZipcodeChange(event) {
        this.conRecord.dbu_Zipcode__c = event.target.value;
        console.log('Zipcode ==> ' + this.conRecord.dbu_Zipcode__c);
    }
    handleMessageChange(event) {
        this.conRecord.dbu_Message__c = event.target.value;
        console.log('Message ==> ' + this.conRecord.dbu_Message__c);
    }

    handleProductSupporChange(event) {
        this.conRecord.dbu_Product_Support__c = event.target.value;
        console.log('Product Support ==> ' + this.conRecord.dbu_Product_Support__c);
    }
    handleESNChange(event) {
        this.conRecord.dbu_ESN__c = event.target.value;
        console.log('ESN ==> ' + this.conRecord.dbu_ESN__c);
    }
    handleGSNChange(event) {
        this.conRecord.dbu_GSN__c = event.target.value;
        console.log('GSN ==> ' + this.conRecord.dbu_GSN__c);
    }
    handleOrderConfirmationNumberChange(event) {
        this.conRecord.dbu_Order_Confirmation_Number__c = event.target.value;
        console.log('Order Confirmation Number ==> ' + this.conRecord.dbu_Order_Confirmation_Number__c);
    }
    handleTellUsChange(event) {
        this.conRecord.dbu_Tell_Us__c = event.target.value;
        console.log('Tell Us ==> ' + this.conRecord.dbu_Tell_Us__c);
    }
    showInfoToast(errorMessage) {
        console.log('Inside showInfoToast ===> 262');
    const evt = new ShowToastEvent({
        title: 'Toast Info',
        message: 'Operation will run in background',
        variant: 'info',
        mode: 'dismissable'
    });
        this.dispatchEvent(evt);
    }

    closeModal() {    
        this.isModalOpen = false; 
    }
    WaitUntilCustomerGUIDIsRetrieved() 
    {
        console.log('Inside WaitUntilCustomerGUIDIsRetrieved()');
        let timerId = null;
        let timeout = 5;
        if (timeout == 0) 
        {
            console.log('In timeout IF ===> 721');
            return;
        }
        console.log('Inside WaitUntilCustomerGUIDIsRetrieved()321');
        if(typeof this.GetElqCustomerGUID === 'function') 
        {
            console.log('In GetElqCustomerGUID IF ===> 727');
            //document.forms["ecommerce-parts-form"].elements["elqCustomerGUID"].value = GetElqCustomerGUID();
            this.conRecord = GetElqCustomerGUID();
            return;
        }
        timerId = setTimeout("WaitUntilCustomerGUIDIsRetrieved()", 500);
        return;

    }
    //window.onload = WaitUntilCustomerGUIDIsRetrieved;
    //_elqQ.push(['elqGetCustomerGUID']);
 
    createRec() { 
        console.log('In createRec ===>348 '+JSON.stringify(this.conRecord));
        /*
        let form = this.template.querySelector('form');
        console.log('form=>351 '+JSON.stringify(this.form));
        console.log('Form>>>' + form);
        form.submit();
        console.log('Form+++' + form);
        console.log('form=>353 '+JSON.stringify(this.form));
        */

       if(this.value == 'I am looking for technical Product Information'){
        console.log('In 1st ===> 245');
           

            if(this.conRecord.dbu_First_Name__c == undefined || this.conRecord.dbu_First_Name__c == ''){ 
                console.log('In 1st ===> 249');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'First Name is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return; 
            }
            if(this.conRecord.dbu_Last_Name__c == undefined || this.conRecord.dbu_Last_Name__c == ''){ 
                console.log('In 1st ===> 259');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Last Name is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;
            }
            
            var regExpEmailformat = new RegExp(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$/);
            if(this.conRecord.dbu_Email__c == undefined || this.conRecord.dbu_Email__c == ''){ 
                console.log('In 1st ===> 269');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Email Address Field is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }
            if(!this.conRecord.dbu_Email__c.match(regExpEmailformat)){ 
                console.log('In 1st ===> 269');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'You have entered an invalid Email format.',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }

            /*
            if(this.conRecord.dbu_Email__c == undefined || this.conRecord.dbu_Email__c == ''){ 
                console.log('In 1st ===> 269');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Email Address Field is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }
            */
            if(this.conRecord.dbu_Phone__c == undefined || this.conRecord.dbu_Phone__c == ''){ 
                console.log('In 1st ===> 279');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Phone Number is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return; 
            }             
            console.log(' this.conRecord.dbu_Cummins_Product_Support__c ===> 315' +  this.conRecord.dbu_Cummins_Product_Support__c);
            console.log(' this.conRecord.dbu_ESN__c ===> 316' +  this.dbu_Cummins_Product_Support__c);
               
            if((this.conRecord.dbu_Cummins_Product_Support__c != undefined || this.conRecord.dbu_Cummins_Product_Support__c =='---Select---') && (this.conRecord.dbu_ESN__c == undefined || this.conRecord.dbu_ESN__c == '')){ 
                   
                console.log('In 1st ===> 319');

                console.log(' this.conRecord.dbu_Cummins_Product_Support__c ===> 321' +  this.conRecord.dbu_Cummins_Product_Support__c);
                console.log(' this.conRecord.dbu_ESN__c ===> 322' +  this.conRecord.dbu_ESN__c);

               if(this.conRecord.dbu_Cummins_Product_Support__c == 'Engine Part')
               {
                    this.dispatchEvent(new ShowToastEvent({
                        title: '', 
                        message: 'ESN is required',
                        variant: 'error',
                        mode: 'dismissable'
                    }), );
                    return; 
                } 
            }
            if((this.conRecord.dbu_Cummins_Product_Support__c != undefined || this.conRecord.dbu_Cummins_Product_Support__c =='---Select---') && (this.conRecord.dbu_GSN__c == undefined || this.conRecord.dbu_GSN__c == '')){ 
                   
                console.log('In 1st ===> 319');

                console.log(' this.conRecord.dbu_Cummins_Product_Support__c ===> 321' +  this.conRecord.dbu_Cummins_Product_Support__c);
                console.log(' this.conRecord.dbu_GSN__c ===> 322' +  this.conRecord.dbu_GSN__c);
              
                if(this.conRecord.dbu_Cummins_Product_Support__c == 'Generator Part')
                {
                    this.dispatchEvent(new ShowToastEvent({
                        title: '', 
                        message: 'GSN is required',
                        variant: 'error',
                        mode: 'dismissable'
                    }), );
                    return; 
                }
            }
            if(this.conRecord.dbu_Tell_Us__c == undefined || this.conRecord.dbu_Tell_Us__c == ''){ 
                console.log('In 1st ===> 299');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Tell us more about how we can help you is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;
            }
        }

        // 2] I am looking technical website support
        if(this.value == 'I am looking technical website support'){
            console.log('In 2nd ===> 313');

            if(this.conRecord.dbu_First_Name__c == undefined || this.conRecord.dbu_First_Name__c == ''){ 
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'First Name is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return; 
            }
            if(this.conRecord.dbu_Last_Name__c == undefined || this.conRecord.dbu_Last_Name__c == ''){ 
    
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Last Name is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;
            }
            /*
            if(this.conRecord.dbu_Email__c == undefined || this.conRecord.dbu_Email__c == ''){ 
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Email Address Field is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }
            */
           var regExpEmailformat = new RegExp(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$/);
            if(this.conRecord.dbu_Email__c == undefined || this.conRecord.dbu_Email__c == ''){ 
                console.log('In 1st ===> 269');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Email Address Field is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }
            if(!this.conRecord.dbu_Email__c.match(regExpEmailformat)){ 
                console.log('In 1st ===> 269');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'You have entered an invalid Email format.',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }
            if(this.conRecord.dbu_Phone__c == undefined || this.conRecord.dbu_Phone__c == ''){ 
    
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Phone Number is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return; 
            }
            if(this.conRecord.dbu_Tell_Us__c == undefined || this.conRecord.dbu_Tell_Us__c == ''){ 
                console.log('Inside Tell>>> 387 ');
                console.log('this.conRecord ===> 387 ' + this.conRecord);
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Tell us more about how we can help you is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;
            }
            
        }

        // 3] I am looking for information about placing an online order
        if(this.value == 'I am looking for information about placing an online order'){
            console.log('In 3rd ===> 364');
            if(this.conRecord.dbu_First_Name__c == undefined || this.conRecord.dbu_First_Name__c == ''){ 
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'First Name is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return; 
            }
            if(this.conRecord.dbu_Last_Name__c == undefined || this.conRecord.dbu_Last_Name__c == ''){ 
    
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Last Name is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;
            }
            /*
            if(this.conRecord.dbu_Email__c == undefined || this.conRecord.dbu_Email__c == ''){ 
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Email Address is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }
            */
           var regExpEmailformat = new RegExp(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$/);
            if(this.conRecord.dbu_Email__c == undefined || this.conRecord.dbu_Email__c == ''){ 
                console.log('In 1st ===> 269');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Email Address Field is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }
            if(!this.conRecord.dbu_Email__c.match(regExpEmailformat)){ 
                console.log('In 1st ===> 269');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'You have entered an invalid Email format.',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }

            if(this.conRecord.dbu_Phone__c == undefined || this.conRecord.dbu_Phone__c == ''){ 
    
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Phone Number is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return; 
            }
            if(this.conRecord.dbu_Tell_Us__c == undefined || this.conRecord.dbu_Tell_Us__c == ''){ 
                console.log('Inside Tell>>> 442 ');
                console.log('this.conRecord ===> 443 ' + this.conRecord);
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Tell us more about how we can help you is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;
            }
        }
        
         // 4] I am looking for help tracking my order
        if(this.value == 'I am looking for help tracking my order'){
            console.log('In 4th ===> 415');
            if(this.conRecord.dbu_First_Name__c == undefined || this.conRecord.dbu_First_Name__c == ''){ 
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'First Name is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return; 
            }
            if(this.conRecord.dbu_Last_Name__c == undefined || this.conRecord.dbu_Last_Name__c == ''){ 
    
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Last Name is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;
            }
            /*
            if(this.conRecord.dbu_Email__c == undefined || this.conRecord.dbu_Email__c == ''){ 
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Email Address is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }*/
            var regExpEmailformat = new RegExp(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$/);
            if(this.conRecord.dbu_Email__c == undefined || this.conRecord.dbu_Email__c == ''){ 
                console.log('In 1st ===> 269');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Email Address Field is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }
            if(!this.conRecord.dbu_Email__c.match(regExpEmailformat)){ 
                console.log('In 1st ===> 269');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'You have entered an invalid Email format.',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }

            if(this.conRecord.dbu_Phone__c == undefined || this.conRecord.dbu_Phone__c == ''){ 
    
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Phone Number is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return; 
            }
            if(this.conRecord.dbu_Order_Confirmation_Number__c == undefined || this.conRecord.dbu_Order_Confirmation_Number__c == ''){ 
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Order Confirmation Number is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;
            }
            if(this.conRecord.dbu_Tell_Us__c == undefined || this.conRecord.dbu_Tell_Us__c == ''){ 
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Tell us more about how we can help you is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;
            }  
           // dbu_Order_Confirmation_Number__c
        }

        // 5] I am looking for information on product warranty
        if(this.value == 'I am looking for information on product warranty'){
            console.log('In 5th ===> 476');
            if(this.conRecord.dbu_First_Name__c == undefined || this.conRecord.dbu_First_Name__c == ''){ 
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'First Name is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return; 
            }
            if(this.conRecord.dbu_Last_Name__c == undefined || this.conRecord.dbu_Last_Name__c == ''){ 
    
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Last Name is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;
            }
            /*
            if(this.conRecord.dbu_Email__c == undefined || this.conRecord.dbu_Email__c == ''){ 
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Email Address is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }*/
            var regExpEmailformat = new RegExp(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$/);
            if(this.conRecord.dbu_Email__c == undefined || this.conRecord.dbu_Email__c == ''){ 
                console.log('In 1st ===> 269');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Email Address Field is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }
            if(!this.conRecord.dbu_Email__c.match(regExpEmailformat)){ 
                console.log('In 1st ===> 269');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'You have entered an invalid Email format.',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }

            if(this.conRecord.dbu_Phone__c == undefined || this.conRecord.dbu_Phone__c == ''){ 
    
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Phone Number is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return; 
            }
            console.log('this.conRecord.dbu_Tell_Us__c ===> 659' +this.conRecord.dbu_Tell_Us__c);
            if(this.conRecord.dbu_Tell_Us__c == undefined || this.conRecord.dbu_Tell_Us__c == ''){ 
                console.log('In 5th ===> 661');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Tell us more about how we can help you is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;
            }
        }

        // 6] I have other online store inquiries
        if(this.value == 'I have other online store inquiries'){
            console.log('In 6th ===> 528');

            if(this.conRecord.dbu_First_Name__c == undefined || this.conRecord.dbu_First_Name__c == ''){ 
                console.log('In FN ===> 528');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'First Name is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return; 
            }
            if(this.conRecord.dbu_Last_Name__c == undefined || this.conRecord.dbu_Last_Name__c == ''){ 
                console.log('In LNh ===> 528');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Last Name is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;
            }
            /*
            if(this.conRecord.dbu_Email__c == undefined || this.conRecord.dbu_Email__c == ''){ 
                console.log('In Email ===> 528');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Email Address is required!',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }*/
            var regExpEmailformat = new RegExp(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$/);
            if(this.conRecord.dbu_Email__c == undefined || this.conRecord.dbu_Email__c == ''){ 
                console.log('In 1st ===> 269');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Email Address Field is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }
            if(!this.conRecord.dbu_Email__c.match(regExpEmailformat)){ 
                console.log('In 1st ===> 269');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'You have entered an invalid Email format.',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;        
            }

            if(this.conRecord.dbu_Phone__c == undefined || this.conRecord.dbu_Phone__c == ''){ 
                console.log('In Phoone ===> 528');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Phone Number is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return; 
            }
            if(this.conRecord.dbu_Tell_Us__c == undefined || this.conRecord.dbu_Tell_Us__c == ''){ 
                console.log('In Tell ===> 528');
                this.dispatchEvent(new ShowToastEvent({
                    title: '', 
                    message: 'Tell us more about how we can help you is required',
                    variant: 'error',
                    mode: 'dismissable'
                }), );
                return;
            }
        }
        
        //else
        //{
            console.log('this.conRecord ===> 139 ' + this.conRecord);
            insertCon({ con: this.conRecord })
            .then(result => {
                console.log('In createRec ===>737 '+JSON.stringify(this.conRecord));
                //Clear the user enter values
                this.conRecord = {};
                //this.WaitUntilCustomerGUIDIsRetrieved();
                //this.isModalOpen = true;
                console.log('After Save ===>743 '+JSON.stringify(this.conRecord));

                //this.eloquaPostUrl = 'https://s1480.t.eloqua.com/e/f2';
                let form = this.template.querySelector('form');     
                console.log('Form>>> ' + form);
                try 
                {
                    console.log('Form>>>751 ' + form);
                    console.log('Before Submit>>> ' + form.elements[11].value);
                    console.log('Before Submit>>> ' + form.elements[12].value);
                    console.log('Before Submit>>> ' + form.elements[16].value);
                    form.submit();
                    console.log('After Submit>>> ' + form.elements[11].value);
                    console.log('After Submit>>> ' + form.elements[12].value);
                    console.log('After Submit>>> ' + form.elements[16].value);
                    this.isModalOpen = true;
                } 
                catch (e) 
                {
                    console.log('form submit error=>' + JSON.stringify(e));
                }
            })
            .catch(error => {
                //this.errorMsg = error.body.message;
            });
        //}      
    }
    
    openRequestedPopup() {
        var topsss=window.screen.height-583;
        var leftsss=window.screen.width-384;
        var windowObjectReference = window.open(
            "https://chat.cummins.com/system/templates/chat/cummins/chat.html?subActivity=Chat&entryPointId=1015&templateName=cummins&languageCode=en&countryCode=US&ver=v11",
            "popup", "width=384, height=583, top="+topsss+",left="+leftsss+"");
    }
    
}