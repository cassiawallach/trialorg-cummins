import {
    LightningElement,
    track
} from 'lwc';
import pubsub from 'c/pubsub';
import usFlagIcon from '@salesforce/resourceUrl/dbu_usflag';
import caFlagIcon from '@salesforce/resourceUrl/dbu_caflag';

//labels starts here//
import communityName from '@salesforce/label/c.dbu_communityName';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //US
import storeCA from '@salesforce/label/c.dbu_home_store_Canada'; //EN
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French'; //FR
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA'; //CA
import frenchCommunityName from '@salesforce/label/c.dbu_FrenchDomainName';
import dbu_changeLocation_Title from '@salesforce/label/c.dbu_changeLocation_Title';
import dbu_changeLocation_UnitedStates from '@salesforce/label/c.dbu_changeLocation_UnitedStates';
import dbu_changeLocation_CanadaEng from '@salesforce/label/c.dbu_changeLocation_CanadaEng';
import dbu_changeLocation_CanadaFrench from '@salesforce/label/c.dbu_changeLocation_CanadaFrench';
import dbu_changeLocation_redirectToUS_msg from '@salesforce/label/c.dbu_changeLocation_redirectToUS_msg';
import dbu_changeLocation_redirectToCA_msg from '@salesforce/label/c.dbu_changeLocation_redirectToCA_msg';
import dbu_changeLocation_noThanks from '@salesforce/label/c.dbu_changeLocation_noThanks';
import dbu_changeLocation_yesPlease from '@salesforce/label/c.dbu_changeLocation_yesPlease';
import QuebecState from '@salesforce/label/c.dbu_changeLocation_QuebecState'; //Quebec
import customerLocUS from '@salesforce/label/c.dbu_changeLocation_us'; //us
import customeLocCA from '@salesforce/label/c.dbu_changeLocation_ca'; //ca
import accessToken from '@salesforce/label/c.dbu_changeLocation_accessToken';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
//labels ends here//

import {

    NavigationMixin

} from 'lightning/navigation';
import isGuest from '@salesforce/user/isGuest';

export default class Dbu_changeLocationTile extends NavigationMixin(LightningElement) {

    @track usflagIcon = usFlagIcon;
    @track caflagIcon = caFlagIcon;
    @track selectedflagIcon;
    @track isGuestUser = isGuest;


    @track sldsExpended = false;
    @track selectedText;
    @track selectedCountry;
    @track showHideDropDown = false;
    @track cCurrency;
    @track selectedValuefromEvent;
    @track xhr;
    @track coordinates;
    @track geoLocationState;
    @track geoLocationCountry;
    @track connectedCallbackExecuted = false;
    @track cookiePolicyAccepted = false;
    @track showUSSelectedPopup = false;
    @track showStoreChangedPopup = false;
    @track storeLocFromURL;
    @track navigateToCanadaEnglish = false;
    @track storeurlvalue;	
    @track communityPageNemFromurl;
    @track comntyPageNameExists = true;
    @track urlString;
    @track urlStringFrenchCommunity;
    @track urlStringFrenchCommunityNew; //A
    //@track goToHomePage;

    //Added by Malhar for getting the footer footerBanner cookie value - 8/12/2020
    @track footerbannercookiestatus;

    label={
        dbu_changeLocation_Title,
        dbu_changeLocation_UnitedStates,
        dbu_changeLocation_CanadaEng,
        dbu_changeLocation_CanadaFrench,
        dbu_changeLocation_redirectToUS_msg,
        dbu_changeLocation_redirectToCA_msg,
        dbu_changeLocation_noThanks,
        dbu_changeLocation_yesPlease
    }

    connectedCallback() {
        this.urlString = window.location.origin;
        this.urlStringFrenchCommunity = frenchCommunityName;
        let homePAgeurl = window.location.href;
        var splitURL = homePAgeurl.split("/");
        var urlLastIndex = splitURL[5].split("?");
        console.log('urlLastIndex' +urlLastIndex[0]);
        this.communityPageNemFromurl = urlLastIndex[0];
        if(this.communityPageNemFromurl != '' && this.communityPageNemFromurl != undefined){
            this.comntyPageNameExists = true;
            console.log('vvvvvvvvv');
        }
        if(this.communityPageNemFromurl == '' || this.communityPageNemFromurl == undefined){
            this.comntyPageNameExists = false;
            console.log('cccccccccc');
        }
        this.selectedflagIcon = usFlagIcon;
        this.selectedText = storeUSA;
        this.selectedCountry = storeUSA;
        this.register();
        this.getCookiesData('CountryCodeFromCookie');
        console.log('cookie value in connected back first time 1>' +this.CountryCodeFromCookie);
        /*Added by mounika T on 1st Dec to get the country and state values w.r.t lat and long*/
        if (!window.sessionStorage.getItem('setStoreFromGeoLoc')) {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        this.latitude = position.coords.latitude;
                        this.longitude = position.coords.longitude;
                        this.coordinates = [this.latitude, this.longitude];

                        this.getCity(this.coordinates);
                    },

                    function (error) {
                        console.log('coming to error block' +error.code);
                        let locationURLWindow = window.location.href;
                        
                        console.log('locationURL' + locationURLWindow);
                        console.log('session value if location isnt accepted?' + window.sessionStorage.getItem('setCountryCode'));
                        var url = new URL(locationURLWindow);
                        let sessionValForLocNotAccepted = window.sessionStorage.getItem('setCountryCode');
                        let storeValueFromURL = url.searchParams.get("store");
                        console.log('storeValueFromURL' + storeValueFromURL);
                        if (storeValueFromURL == null && sessionValForLocNotAccepted == null) {
                            window.sessionStorage.setItem('setCountryCode', storeUSA);
                            console.log('session value when user not accepted location' + window.sessionStorage.getItem('setCountryCode'));
                        } else if (storeValueFromURL != null && sessionValForLocNotAccepted == null) {
                            console.log('store and session null looop>>>>');
                            window.sessionStorage.setItem('setCountryCode','');
                            if ((storeValueFromURL == storeUSA || storeValueFromURL == storeCA) && !this.comntyPageNameExists) {
                                //let urlString = window.location.origin;
                                window.location.href = this.urlString + communityName + '?store=' + storeValueFromURL;
                            } if (storeValueFromURL == storeCAF && !this.comntyPageNameExists) {
                                //let urlStringFrenchCommunity = frenchCommunityName;
                                window.location.href = this.urlStringFrenchCommunity + communityName + '?store=' + storeValueFromURL;
                            }

                        }
                    });
                this.getCookiesData('CountryCodeFromCookie');
                console.log('cookie value in connected back first time222>' +this.CountryCodeFromCookie);
                window.sessionStorage.setItem('setStoreFromGeoLoc', true);
                console.log('value from session>>' + window.sessionStorage.getItem('setStoreFromGeoLoc'));

            }
        }

        if (!window.sessionStorage.getItem('setStoreFromGeoLocLoggedin') && !this.isGuestUser) {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        this.latitude = position.coords.latitude;
                        this.longitude = position.coords.longitude;
                        this.coordinates = [this.latitude, this.longitude];
                        this.getCity(this.coordinates);
                    },
                    function (error) {
                        console.log('coming to error block' +error.code);
                        let locationURLWindow = window.location.href;
                        console.log('locationURL' + locationURLWindow);
                        console.log('session value if location isnt accepted?' + window.sessionStorage.getItem('setCountryCode'));
                        var url = new URL(locationURLWindow);
                        let sessionValForLocNotAccepted = window.sessionStorage.getItem('setCountryCode');
                        let storeValueFromURL = url.searchParams.get("store");
                        console.log('storeValueFromURL' + storeValueFromURL);
                        if (storeValueFromURL == null && sessionValForLocNotAccepted == null) {
                            window.sessionStorage.setItem('setCountryCode', storeUSA);
                            console.log('session value when user not accepted location' + window.sessionStorage.getItem('setCountryCode'));
                        } else if (storeValueFromURL != null && sessionValForLocNotAccepted == null) {
                            console.log('store and session null looop>>>>');
                            window.sessionStorage.setItem('setCountryCode', '');
                            if ((storeValueFromURL == storeUSA || storeValueFromURL == storeCA) && !this.comntyPageNameExists) {
                                //let urlString = window.location.origin;
                                 window.location.href = this.urlString + communityName + '?store=' + storeValueFromURL;
                            } if (storeValueFromURL == storeCAF && !this.comntyPageNameExists) {
                                //let urlString = frenchCommunityName;
                                window.location.href = this.urlStringFrenchCommunity + communityName + '?store=' + storeValueFromURL;
                            }

                        }
                    });
            }
            window.sessionStorage.setItem('setStoreFromGeoLocLoggedin', true);


        }
        let locationURLWindow = window.location.href;
        console.log('locationURL' + locationURLWindow);
        var url = new URL(locationURLWindow);
        let urlvalueStore = url.searchParams.get("store");
        console.log('session storag ein cnnected callback' +window.sessionStorage.getItem('setCountryCode'));
        console.log('urlvalue storag ein cnnected callback' +urlvalueStore);

        if (window.sessionStorage.getItem('setCountryCode') != null &&
            window.sessionStorage.getItem('setCountryCode') != '' &&
            window.sessionStorage.getItem('setCountryCode') != undefined) {
                console.log('coming to first if');

            this.storeLocFromURL = window.sessionStorage.getItem('setCountryCode');
            console.log('coming to first if' +this.storeLocFromURL);

        }
        else if (
            (window.sessionStorage.getItem('setCountryCode') === '' ||  window.sessionStorage.getItem('setCountryCode') === null)
            && urlvalueStore != null) {
               // alert('Condition True');
                console.log('storeLocFromURL in first else');

            this.storeLocFromURL = urlvalueStore;
            //if(urlvalueStore != storeCAF){
                window.sessionStorage.setItem('setCountryCode',urlvalueStore)
            //}
            console.log('storeLocFromURL in first else' + this.storeLocFromURL);


        } else if ((window.sessionStorage.getItem('setCountryCode') == null &&
            window.sessionStorage.getItem('setCountryCode') == '' &&
            window.sessionStorage.getItem('setCountryCode') == undefined) &&
            urlvalueStore == null) {
                console.log('storeLocFromURL in second else');

            this.storeLocFromURL = storeUSA;
            console.log('storeLocFromURL in second else' + this.storeLocFromURL);

        }

        // ---Added by Mukesh Gupta----
        if(window.sessionStorage.getItem('setCountryCode') != null && urlvalueStore != null){
           console.log('Both are null - URL and SessionStorage');
            window.sessionStorage.setItem('setCountryCode',urlvalueStore);
        }

        if (window.sessionStorage.getItem('setCountryCode')) {
            console.log('vdsjcks >>>>>>> ');
            //this.getCookiesData('CountryCodeFromCookie');
            console.log('herman hoth >>>>>> ' + window.sessionStorage.getItem('setCountryCode'));
            this.createCookieforCountry('CountryCodeFromCookie', window.sessionStorage.getItem('setCountryCode'), 7);
        }

        this.getCookiesData('CountryCodeFromCookie');
        console.log('cookie value in connected back first  33>' +this.CountryCodeFromCookie);



        /*Added by mounika T on 1st Dec to get the country and state values w.r.t lat and long*/
    }
    /*Added by mounika T on 1st Dec to get the country and state values w.r.t lat and long*/
    getCity(coordinates) {
        console.log('entering the get city method>>>');
        console.log('coordinates>>>' + coordinates);
        this.xhr = new XMLHttpRequest();
         var lat = this.coordinates[0];
         var lng = this.coordinates[1];
        //  var lat = '46.829853'; /**quebec location lat and longtitude */
        //  var lng = '-71.254028'; /**quebec location lat and longtitude */
        //var lat = '40.7128'; /**US location lat and longtitude */
        //var lng='-74.0060';/**US location lat and longtitude */
        var access = accessToken;
        this.xhr.open('GET', "https://us1.locationiq.com/v1/reverse.php?key=" + access + "&lat=" + lat + "&lon=" + lng + "&format=json", true);
        this.xhr.send();
        console.log('statusXHR>>>' + this.xhr.status);
        console.log('stateXHR>>>' + this.xhr.readyState);
        this.xhr.onreadystatechange = () => {
            if (this.xhr.readyState === 4 && this.xhr.status === 200) {
                let response = JSON.parse(this.xhr.responseText);
                console.log('response' + this.xhr.responseText);
                this.geoLocationState = response.address.state;
                this.geoLocationCountryCode = response.address.country_code;
                console.log('state' + this.geoLocationState);
                console.log('city' + this.geoLocationCountryCode);
                console.log('isGuestUser inside if' + this.isGuestUser);
                console.log('this.cookiePolicyAccepted inside if ' + this.cookiePolicyAccepted);
                this.displayStoreBasedOnGeoLoc(this.geoLocationCountryCode, this.geoLocationState);
            }
        };
    }

    /*Added by mounika T on 1st Dec to get the country and state values w.r.t lat and long*/

    @track callbackExecuted = false;
    renderedCallback() {
        if (this.callbackExecuted) {
            return;
        }
        let locationURL = window.location.href;
        console.log('locationURL in rendered' + locationURL);
        var url = new URL(locationURL);
        let urlvalueStore = url.searchParams.get("store");
        let store = '';


        if (window.sessionStorage.getItem('setCountryCode') != null &&
            window.sessionStorage.getItem('setCountryCode') != '' &&
            window.sessionStorage.getItem('setCountryCode') != undefined) {
            store = window.sessionStorage.getItem('setCountryCode');
        }
        else if (
            window.sessionStorage.getItem('setCountryCode') === ''
            && urlvalueStore != null) {
            store = urlvalueStore;
        } else if ((window.sessionStorage.getItem('setCountryCode') == null &&
            window.sessionStorage.getItem('setCountryCode') == '' &&
            window.sessionStorage.getItem('setCountryCode') == undefined) &&
            urlvalueStore == null) {
            store = storeUSA;
        }
        
        if (store != undefined) {
            this.selectedValuefromEvent = store;
            this.handleEvent();
        }

        pubsub.fire('sendDataTolstProdDetailspage', this.selectedValuefromEvent);
        //pubsub.fire('geniunPartsLocationChange', this.selectedValuefromEvent);
        console.log('selectedValuefromEvent in rendered call ack' + this.selectedValuefromEvent);
        this.callbackExecuted = true
        this.getCookiesData(window.sessionStorage.getItem('setCountryCode'));
    }
    regiser() {
        console.log('event registered in connected call back ');
        pubsub.register('sendLocToStore', this.handlesendLocToStore.bind(this));
        pubsub.register('sendLocToStoreFromMinicart', this.handlesendLocToStore.bind(this));

        pubsub.register('sendLocToStoreFromCheckout', this.handlesendLocToStoreFromCheckout.bind(this));
        pubsub.register('CumminsLogoSendLocToStore', this.handleCumminsLogoSendLocToStore.bind(this));


    }
    register() {
        console.log('pub sub is firing=>>>')
        pubsub.register('sendAcceptDataTChangeLocationtile', this.handlesendAcceptDataTChangeLocationtile.bind(this));
        pubsub.register('sendLocToStoreForYahamaCategory', this.handlesendLocToStore.bind(this));
    }
    handlesendAcceptDataTChangeLocationtile(event) {
        console.log('data cmng from cookie policy' + event);
        console.log('data cmng from cookie policy geoLocationState' + this.geoLocationState);
        console.log('data cmng from cookie policy geoLocationCountryCode' + this.geoLocationCountryCode);

        this.cookiePolicyAccepted = true;

        if (this.isGuestUser && this.cookiePolicyAccepted) {
            console.log('guest and accepted inside if pubsub');
            this.displayStoreBasedOnGeoLoc(this.geoLocationCountryCode, this.geoLocationState);
        }

    }
    handleCumminsLogoSendLocToStore(event) {
        console.log('handleCumminsLogoSendLocToStore event fired ');
        this.selectedValuefromEvent = event;
        console.log('selectedValuefromEvent=>' + this.selectedValuefromEvent);
        this.handleEvent();

    }
    handlesendLocToStore(event) {
        console.log('handlesendLocToStore event fired ');
        this.selectedValuefromEvent = event;
        console.log('selectedValuefromEvent=>' + this.selectedValuefromEvent);
        this.handleEvent();

    }
    handlesendLocToStoreFromCheckout(event) {
        console.log('handlesendLocToStoreFromCheckout event fired ');
        this.selectedValuefromEvent = event;
        console.log('selectedValuefromEvent=>' + this.selectedValuefromEvent);
        this.handleEvent();

    }
    handleEvent() {
        console.log('IN HANDLE EVENT OF CHANGE LOCATION TILE **>');
        // this.selectedValuefromEvent = event;
        if (this.selectedValuefromEvent != '' && this.selectedValuefromEvent != undefined && this.selectedValuefromEvent != null && this.selectedValuefromEvent != 'undefined' &&
            this.selectedValuefromEvent != 'null') {
            console.log('enetering the inside method>>>')
            if (this.selectedValuefromEvent == storeUSA) {
                this.setFlagForUS();
                // this.selectedflagIcon = this.usflagIcon;
                // this.selectedText = storeUSA;
                // this.selectedCountry = storeUSA;
                // this.template.querySelector('.classUS').classList.add('selected');
                // this.template.querySelector('.classCA-Eng').classList.remove('selected');
                // this.template.querySelector('.classCA-FR').classList.remove('selected');
            } else if (this.selectedValuefromEvent == storeCA) {
                this.setFlagForCanadaEng();
                // this.selectedflagIcon = this.caflagIcon;
                // this.selectedText = storeCA;
                // this.selectedCountry = storeCanada;
                // this.template.querySelector('.classCA-Eng').classList.add('selected');
                // this.template.querySelector('.classUS').classList.remove('selected');
                // this.template.querySelector('.classCA-FR').classList.remove('selected');

            } else if (this.selectedValuefromEvent == storeCAF) {
                this.setFlagForCanadaFrench();
                // this.selectedflagIcon = this.caflagIcon;
                // this.selectedText = storeCAF;
                // this.selectedCountry = storeCanada;
                // this.template.querySelector('.classUS').classList.remove('selected');
                // this.template.querySelector('.classCA-Eng').classList.remove('selected');
                // this.template.querySelector('.classCA-FR').classList.add('selected');

            }
        } else {
            console.log('default storeLOc=>' + event);
            this.setFlagForUS();
            // this.selectedflagIcon = usFlagIcon;
            // this.selectedText = storeUSA;
            // this.selectedCountry = storeUSA;
        }

        pubsub.fire('locationSelected', this.selectedCountry);
        pubsub.fire('displayYamaha', this.selectedCountry);
        pubsub.fire('displayTermsAndUse', this.selectedCountry);
        pubsub.fire('displayPrvtPlcy', this.selectedCountry);
        pubsub.fire('spclOfferPrvcyPlcy', this.selectedCountry);
        pubsub.fire('sendDataTolstProdDetailspage', this.selectedText);
        pubsub.fire('sendDataTolstProducts', this.selectedText); //CHG0109558 & CHG0109559 Ramesh
        pubsub.fire('sendDataToCustomSearch', this.selectedText); //CHG0109558 & CHG0109559 Ramesh

        /*Code added by Malhar - for change geneune, promotion and fetured products on store toggling - Begin */


        pubsub.fire('geniunPartsLocationChange', this.selectedCountry);
        pubsub.fire('featuredProductsLocationChange', this.selectedCountry);
        pubsub.fire('currentPromotionLocationChange', this.selectedCountry);
        pubsub.fire('currentPromotionCurrentLanguage', this.selectedText);
        pubsub.fire('featuredProductsCurrentLanguage', this.selectedText);
        pubsub.fire('geniunPartsCurrentLanguage', this.selectedText);
        pubsub.fire('homepagecateitemdetaillanguageChange', this.selectedText);
        pubsub.fire('lstRecentlyViewProdLocationChange', this.selectedCountry);
        pubsub.fire('lstRecentlyViewProdCurrentLanguage', this.selectedText);

        window.sessionStorage.setItem('sendDataToCustomSearch',this.selectedText);
        localStorage.setItem('scountry', this.selectedCountry); // Christopher CHG0109559
        //pubsub.fire('homepagecatetilelanguageChange', this.selectedText);
        /*Code added by Malhar - for change geneune, promotion and fetured products on store toggling - end */

        console.log('selectedCountry>>' + this.selectedCountry);

    }


    googleAnalyticsStoreInformationPush(PreviousStoreLocation, NewStoreLocation){
        let googleAnalyticsStoreData = {previousStore : PreviousStoreLocation, 
                                        NewStore : NewStoreLocation};
        invokeGoogleAnalyticsService('STORE TOGGLE', googleAnalyticsStoreData); 
    }    

    get ldsDiv() {
        return this.sldsExpended ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    }
    get languageSelector() {
        return this.sldsExpended ? 'languageSelectorOpen ml-5' : 'languageSelectorClosed ml-5';
    }
    ldsClickHandler() {
        if (this.sldsExpended) {
            this.sldsExpended = false;
        } else {
            this.sldsExpended = true;
        }
    }

    onmouseoutHandler() {
        this.sldsExpended = false;
    }

    handleButtonselect(event) {
        console.log('entering the method>>>');
        console.log(event.detail.value);
        let selectedValue = event.detail.value;
        let selectedObject = this.optionsList.find(function (element) {
            return element.value === selectedValue;
        });
        const test = selectedObject.label;
        this.dispalyLabel = test;
        //this.iconName =  selectedObject.iconName;
        console.log('selected dispalyLabel ->' + this.dispalyLabel);
        console.log('selected Label ->' + test);
        // console.log('selected iconName ->' + selectedObject.iconName);
    }
    //Added
    createCookieforCountry(name, value, days) {
        var expires;
        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = name + "=" + escape(value) + expires + "; path=/";
    }//Added End


    @track googleAnalyticsPreviousStore = storeUSA;    
    handleClickChangeLoaction(event) {

        console.log('IN HANDLE CLICK CHANGE LOCATION TILE **>');
        this.selectedText = event.target.dataset.id;
        let locationURLWindow = window.location.href;
        console.log('locationURL' + locationURLWindow);
        var url = new URL(locationURLWindow);
        //this.storeLocFromURL = url.searchParams.get("store");
         console.log('this.selectedText+++ ' + this.selectedText);
        console.log('window.sessionStorage.getItem+++ ' + window.sessionStorage.getItem('setCountryCode'));
        if (window.sessionStorage.getItem('setCountryCode') == null ||
            window.sessionStorage.getItem('setCountryCode') == '' ||
            window.sessionStorage.getItem('setCountryCode') == undefined) {
            this.storeLocFromURL = storeUSA;
            console.log('this.storeLocFromURL IF+++ ' + this.storeLocFromURL);
        } else {
            this.storeLocFromURL = window.sessionStorage.getItem('setCountryCode');
            console.log('this.storeLocFromURL ELSE+++ ' + this.storeLocFromURL);
        }
        
        
        console.log('storeLocFromURL111' + this.storeLocFromURL);
        this.googleAnalyticsPreviousStore = this.storeLocFromURL;
        if ((this.selectedText == storeUSA || this.selectedText == 'USFlag') && this.storeLocFromURL != storeUSA) {
          //  console.log('Inside this.selectedText == storeUSA  IF ');
            this.showStoreChangedPopup = true;
            this.showUSSelectedPopup = true;
            this.showCASelectedPopup = false;
            //commented code start for CHG0109558 & CHG0109559 Ramesh
            //this.googleAnalyticsStoreInformationPush(this.storeLocFromURL, storeUSA);
			//window.sessionStorage.setItem('setCountryCode', storeUSA);
			//this.createCookieforCountry('CountryCodeFromCookie', window.sessionStorage.getItem('setCountryCode'));
            //this.setFlagForUS();
            // this.selectedflagIcon = this.usflagIcon;
            // this.selectedText = storeUSA;
            // this.selectedCountry = storeUSA;
            // this.template.querySelector('.classUS').classList.add('selected');
            // this.template.querySelector('.classCA-Eng').classList.remove('selected');
            // this.template.querySelector('.classCA-FR').classList.remove('selected');
            //commented code ended for CHG0109558 & CHG0109559 Ramesh
            console.log('window.sessionStorage.getItem+++ IF' + window.sessionStorage.getItem('setCountryCode'));
        } else if (this.selectedText == storeCanada || this.selectedText == 'CAFlag') {
            console.log('Inside storeCanada ELSE IF');
            console.log('this.storeLocFromURL+++ ' + this.storeLocFromURL);
            this.navigateToCanadaEnglish = true; // Christopher CHG0109559
            if (this.storeLocFromURL == storeUSA) {
                console.log('coming to if in cannada english');
                this.showStoreChangedPopup = true;
                this.showCASelectedPopup = true;
                this.showUSSelectedPopup = false;
            } 
            // Christopher CHG0109559 Start
            else {  
                this.goToCanadaStore();
            }
            // Christopher CHG0109559 End
             //commented code start for CHG0109558 & CHG0109559 Ramesh
            //this.googleAnalyticsStoreInformationPush(this.storeLocFromURL, storeCA);
            // this.selectedflagIcon = this.caflagIcon;
            // this.selectedText = storeCA;
            // this.selectedCountry = storeCanada;
            // this.template.querySelector('.classCA-Eng').classList.add('selected');
            // this.template.querySelector('.classUS').classList.remove('selected');
            // this.template.querySelector('.classCA-FR').classList.remove('selected');
           // window.sessionStorage.setItem('setCountryCode', storeCA);
           // this.createCookieforCountry('CountryCodeFromCookie', window.sessionStorage.getItem('setCountryCode'), 7);
			//this.setFlagForCanadaEng();
             //commented code ended from Ramesh

            console.log('session1' +window.sessionStorage.getItem('setCountryCode'));
            console.log('this.createCookieforCountry+++ ' + this.createCookieforCountry('CountryCodeFromCookie', window.sessionStorage.getItem('setCountryCode'), 7));
        } else if (this.selectedText == 'CAF' || this.selectedText == 'CAFFlag') {
            console.log('Inside this.selectedText == CAF ELSE IF');
            console.log('this.storeLocFromURL+++ ' + this.storeLocFromURL);      
            this.navigateToCanadaEnglish = false; // Christopher CHG0109559
            if (this.storeLocFromURL == storeUSA) {
                console.log('Inside this.storeLocFromURL IF+++ ' + this.storeLocFromURL);
                this.showStoreChangedPopup = true;
                this.showCASelectedPopup = true;
                this.showUSSelectedPopup = false;
            } 
            // Christopher CHG0109559 Start
            else { 
                this.goToCanadaStore();
            }
            // Christopher CHG0109559 End

             //commented code started from Ramesh
            //this.googleAnalyticsStoreInformationPush(this.storeLocFromURL, storeCAF);
            // this.selectedflagIcon = this.caflagIcon;
            // this.selectedText = storeCAF;
            // this.selectedCountry = storeCanada;

            // this.template.querySelector('.classUS').classList.remove('selected');
            // this.template.querySelector('.classCA-Eng').classList.remove('selected');
            // this.template.querySelector('.classCA-FR').classList.add('selected');
            //this.urlStringFrenchCommunityNew = frenchCommunityName;//A
             //commented code ended from Ramesh
            //console.log('this.urlStringFrenchCommunity  = ' + this.urlStringFrenchCommunityNew);//A
            //console.log('communityName = ' + communityName);//A
            //console.log('this.selectedText = ' + this.selectedText);//A

             //commented code started from Ramesh
            /*
            window.sessionStorage.setItem('setCountryCode', 'CAF');//A
            this.createCookieforCountry('CountryCodeFromCookie', window.sessionStorage.getItem('setCountryCode'));
			this.setFlagForCanadaFrench();
            console.log('session2 = ' +window.sessionStorage.getItem('setCountryCode'));
            console.log('window.location.href = ' +  window.location.href);
            
            window.location.href = this.urlStringFrenchCommunityNew + communityName + '?store=FR';//A

            localStorage.setItem('scountry', this.selectedCountry); //Added
            console.log('local Storage ' + localStorage.setItem('scountry', this.selectedCountry)); //Added
            //window.location.href = this.urlStringFrenchCommunity + communityName + '?store=' + this.selectedText;
            //console.log('window.location.href = ' +  window.location.href);*/
             //commented code ended from Ramesh

        }
        this.ldsClickHandler();
         //commented code started from Ramesh
       // window.sessionStorage.setItem('setCountryCode', this.selectedText);

       // this.createCookieforCountry('CountryCodeFromCookie', window.sessionStorage.getItem('setCountryCode'), 7);

       /* 
        pubsub.fire('locationSelected', this.selectedCountry);
        pubsub.fire('displayYamaha', this.selectedCountry);
        pubsub.fire('displayTermsAndUse', this.selectedCountry);
        pubsub.fire('displayPrvtPlcy', this.selectedCountry);
        pubsub.fire('spclOfferPrvcyPlcy', this.selectedCountry);
        pubsub.fire('sendDataTolstProdDetailspage', this.selectedText);
        pubsub.fire('sendDataTolstProducts', this.selectedText);
        pubsub.fire('sendDataToCustomSearch', this.selectedText);
        console.log('selectedCountry>>' + this.selectedCountry);*/

        /*Code added by Malhar - for change geneune, promotion and fetured products on store toggling - Begin */
      /*  pubsub.fire('geniunPartsLocationChange', this.selectedCountry);
        pubsub.fire('featuredProductsLocationChange', this.selectedCountry);
        pubsub.fire('currentPromotionLocationChange', this.selectedCountry);
        pubsub.fire('currentPromotionCurrentLanguage', this.selectedText);
        pubsub.fire('featuredProductsCurrentLanguage', this.selectedText);
        pubsub.fire('geniunPartsCurrentLanguage', this.selectedText);
        pubsub.fire('homepagecateitemdetaillanguageChange', this.selectedText);
        pubsub.fire('lstRecentlyViewProdLocationChange', this.selectedCountry);
        pubsub.fire('lstRecentlyViewProdCurrentLanguage', this.selectedText);
        //pubsub.fire('homepagecatetilelanguageChange', this.selectedText);*/
 //commented code ended from Ramesh
        /*Code added by Malhar - for change geneune, promotion and fetured products on store toggling - End */


        console.log('MOVING TO NAVIGATION IN CHANGE LOCATION TILE');
         //commented code started from Ramesh
        /*Added by Malhar for navigating to home page after selecting the store - begins -  28/11/2020 */
        //Following changes added by Malhar - for stable store toggling - 14/12/2020 
       /* if (!this.showStoreChangedPopup) {	
            console.log('coming to loop>>>>' +window.sessionStorage.getItem('setCountryCode'));	
            let locationURLWindow = window.location.href;	
            var url = new URL(locationURLWindow);	
            let storeValFrmURL = url.searchParams.get("store");	
            if (window.sessionStorage.getItem('setCountryCode') != null &&	
                window.sessionStorage.getItem('setCountryCode') != '') {	
                this.storeurlvalue = window.sessionStorage.getItem('setCountryCode');	
            } else if ((window.sessionStorage.getItem('setCountryCode') == '' ||	
                window.sessionStorage.getItem('setCountryCode') == null) &&	
                storeValFrmURL != null) {	
                this.storeurlvalue = this.selectedText;	
                //window.sessionStorage.setItem('setCountryCode', this.storeurlvalue);	
                //this.createCookieforCountry('CountryCodeFromCookie', window.sessionStorage.getItem('setCountryCode'));	
            }
            if (this.selectedText == storeUSA || this.selectedText == storeCA) {
                if(this.selectedText == storeUSA){
                    this.googleAnalyticsStoreInformationPush(this.googleAnalyticsPreviousStore , storeUSA);	
                }if(this.selectedText == storeCA){
                    this.googleAnalyticsStoreInformationPush(this.googleAnalyticsPreviousStore , storeCA);	
                }
                //let urlString = window.location.origin;
                window.location.href = this.urlString + communityName + '?store=' + this.selectedText;
            }
            if (this.selectedText == storeCAF) {
                this.googleAnalyticsStoreInformationPush(this.googleAnalyticsPreviousStore , storeCAF);			
                console.log('coming to handleclick>>');
                //let urlString = frenchCommunityName;
                window.location.href = this.urlStringFrenchCommunity + communityName + '?store=' + this.selectedText;
            }
        }*/
        //commented code ended from Ramesh
        /*Added by Malhar for navigating to home page after selecting the store - ends -  28/11/2020 */
    } 


    displayStoreBasedOnGeoLoc(countrycode, state) {
        console.log('countrycode>>' + countrycode);
        console.log('countrycode>>' + state);

        if (countrycode == customerLocUS) {
            this.setFlagForUS();
            // this.selectedflagIcon = usFlagIcon;
            // this.selectedText = storeUSA;
            // this.selectedCountry = storeUSA;
            // this.template.querySelector('.classUS').classList.add('selected');
            // this.template.querySelector('.classCA-Eng').classList.remove('selected');
            // this.template.querySelector('.classCA-FR').classList.remove('selected');
        } else if (countrycode == customeLocCA && state == QuebecState) {
            console.log('entering the quebec state>>>');
            this.setFlagForCanadaFrench();
            // this.selectedflagIcon = this.caflagIcon;
            // this.selectedText = storeCAF;
            // this.selectedCountry = storeCanada;
            // this.template.querySelector('.classUS').classList.remove('selected');
            // this.template.querySelector('.classCA-Eng').classList.remove('selected');
            // this.template.querySelector('.classCA-FR').classList.add('selected');
        } else if (countrycode == customeLocCA && state != QuebecState) {
            this.setFlagForCanadaEng();
            // this.selectedflagIcon = this.caflagIcon;
            // this.selectedText = storeCA;
            // this.selectedCountry = storeCanada;
            // this.template.querySelector('.classCA-Eng').classList.add('selected');
            // this.template.querySelector('.classUS').classList.remove('selected');
            // this.template.querySelector('.classCA-FR').classList.remove('selected');

        }/*this below else if is only for testing purpose, if folks from India login, the store will display as Canada Eng*/
        else if (countrycode != customerLocUS && countrycode != customeLocCA) {
            //this.setFlagForCanadaEng();//CHG0103109- Ramesh
            // this.selectedflagIcon = this.caflagIcon;
            // this.selectedText = storeCA;
            // this.selectedCountry = storeCanada;
            // this.template.querySelector('.classCA-Eng').classList.add('selected');
            // this.template.querySelector('.classUS').classList.remove('selected');
            // this.template.querySelector('.classCA-FR').classList.remove('selected');

        }
        console.log('entering here 111>>' +window.sessionStorage.getItem('setCountryCode'));


        

        this.getCookiesData('CountryCodeFromCookie');
        console.log('iiiiiiiiiiiiiiiiiiiiiiiiiiiii > ' + this.countryCodeValueFromCookie);
        console.log('zzzzzzzzzzzzzzzzzzzzzzzzzzzzz > ' + window.sessionStorage.getItem('setStoreFromGeoLocLoggedin'));

        if (!this.isGuestUser && window.sessionStorage.getItem('setStoreFromGeoLocLoggedin') && this.countryCodeValueFromCookie) {
            console.log('is set to true heinrich > ');
            window.sessionStorage.setItem('setCountryCode', this.countryCodeValueFromCookie);
            console.log('session3' +window.sessionStorage.getItem('setCountryCode'));

            this.selectedText = this.countryCodeValueFromCookie;
        } 
        else if (this.isGuestUser && window.sessionStorage.getItem('setStoreFromGeoLoc') && this.countryCodeValueFromCookie) {
            console.log('is set to true heinrich in guest > ');
            window.sessionStorage.setItem('setCountryCode', this.countryCodeValueFromCookie);
            console.log('session11 in guest' +window.sessionStorage.getItem('setCountryCode'));

            this.selectedText = this.countryCodeValueFromCookie;
        }
        else {
            console.log('is set to true albert > ');
            window.sessionStorage.setItem('setCountryCode', this.selectedText);
            console.log('session4' +window.sessionStorage.getItem('setCountryCode'));

        }

        if(this.comntyPageNameExists && window.sessionStorage.getItem('setCountryCode')){
            let xyz = window.sessionStorage.getItem('setCountryCode')
            if (xyz == storeUSA) {
                this.setFlagForUS();
                // this.selectedflagIcon = this.usflagIcon;
                // this.selectedText = storeUSA;
                // this.selectedCountry = storeUSA;
                // this.template.querySelector('.classUS').classList.add('selected');
                // this.template.querySelector('.classCA-Eng').classList.remove('selected');
                // this.template.querySelector('.classCA-FR').classList.remove('selected');
            } else if (xyz == storeCA) {
                this.setFlagForCanadaEng();
                // this.selectedflagIcon = this.caflagIcon;
                // this.selectedText = storeCA;
                // this.selectedCountry = storeCanada;
                // this.template.querySelector('.classCA-Eng').classList.add('selected');
                // this.template.querySelector('.classUS').classList.remove('selected');
                // this.template.querySelector('.classCA-FR').classList.remove('selected');

            } else if (xyz == storeCAF) {
                this.setFlagForCanadaFrench();
                // this.selectedflagIcon = this.caflagIcon;
                // this.selectedText = storeCAF;
                // this.selectedCountry = storeCanada;
                // this.template.querySelector('.classUS').classList.remove('selected');
                // this.template.querySelector('.classCA-Eng').classList.remove('selected');
                // this.template.querySelector('.classCA-FR').classList.add('selected');

            }

        }

        console.log('value from session setCountryCode>>' + window.sessionStorage.getItem('setCountryCode'));


        if ((this.selectedText == storeUSA || this.selectedText == storeCA) && !this.comntyPageNameExists) {
            //let urlString = window.location.origin;
            window.location.href = this.urlString + communityName + '?store=' + this.selectedText;
        }
        else if(this.selectedText == storeCAF && !this.comntyPageNameExists){
            console.log('coming to handleclick111111>>');
            //let urlString = frenchCommunityName;
            window.location.href = this.urlStringFrenchCommunity + communityName + '?store=' + this.selectedText;
        }
        

        

        /*Code added by Malhar - for change geneune, promotion and fetured products on store toggling - Begin */
        
        pubsub.fire('currentPromotionLocationChange', this.selectedCountry);
        pubsub.fire('currentPromotionCurrentLanguage', this.selectedText);
        pubsub.fire('sendDataTolstProdDetailspage', this.selectedText);
        
        /*Code added by Malhar - for change geneune, promotion and fetured products on store toggling - End */


    }



    goToUSHomePage() {
        //window.alert('Inside goToUSHomePage()');
        this.selectedValuefromEvent == storeUSA; //ramesh 
        this.selectedText = storeUSA; //ramesh
        this.selectedCountry = storeUSA; //ramesh
        console.log('coming to navigateToUSOnlineStore' + communityName);
        //let urlString = window.location.origin;
        console.log('current domain' +this.urlString);
        window.sessionStorage.setItem('setCountryCode', storeUSA); // Christopher CHG0109559
        console.log('session5' +window.sessionStorage.getItem('setCountryCode'));
        this.handleEvent(); //ramesh
        window.sessionStorage.setItem('sendDataToCustomSearch',storeUSA);
        this.createCookieforCountry('CountryCodeFromCookie', window.sessionStorage.getItem('setCountryCode')); // Christopher CHG0109559
        this.googleAnalyticsStoreInformationPush(this.googleAnalyticsPreviousStore , storeUSA);
        window.location.href= this.urlString + communityName + '?store=US';
        
    }


    nothanksActionShowCanadaStore() {
        this.showUSSelectedPopup = false;
        this.showStoreChangedPopup = false;
        this.showCASelectedPopup = false;
        this.selectedCountry = storeCanada;
        this.selectedflagIcon = this.caflagIcon;
        console.log('sessio value' +window.sessionStorage.getItem('setCountryCode'));
        if (window.sessionStorage.getItem('setCountryCode') == storeCAF) {
            this.setFlagForCanadaFrench();
            // this.selectedText = storeCAF;
            // this.template.querySelector('.classCA-Eng').classList.remove('selected');
            // this.template.querySelector('.classUS').classList.remove('selected');
            // this.template.querySelector('.classCA-FR').classList.add('selected');
        }
        if (window.sessionStorage.getItem('setCountryCode') == storeCA) {
            this.setFlagForCanadaEng();
            // this.selectedText = storeCA;
            // this.template.querySelector('.classCA-Eng').classList.add('selected');
            // this.template.querySelector('.classUS').classList.remove('selected');
            // this.template.querySelector('.classCA-FR').classList.remove('selected');
        }
        window.sessionStorage.setItem('setCountryCode', this.selectedText);
        console.log('session6' +window.sessionStorage.getItem('setCountryCode'));


    }

    nothanksActionShowUSStore() {
        this.showUSSelectedPopup = false;
        this.showStoreChangedPopup = false;
        this.showCASelectedPopup = false;
        this.setFlagForUS();
        // this.selectedflagIcon = this.usflagIcon;
        // this.selectedText = storeUSA;
        // this.selectedCountry = storeUSA;
        // this.template.querySelector('.classUS').classList.add('selected');
        // this.template.querySelector('.classCA-Eng').classList.remove('selected');
        // this.template.querySelector('.classCA-FR').classList.remove('selected');
        window.sessionStorage.setItem('setCountryCode', this.selectedText);
        console.log('session7' +window.sessionStorage.getItem('setCountryCode'));

        console.log('session value in nothanks' +window.sessionStorage.getItem('setCountryCode'));

    }

    goToCanadaStore() {
       // window.alert('InsidegoToCanadaStore() CANADA');
        //let urlString = window.location.origin;
        console.log('current domain' +this.urlString);
        if (this.navigateToCanadaEnglish) {
            this.selectedValuefromEvent == storeCA;
             //this.selectedText = storeCA; //ramesh
            //this.selectedCountry = storeCanada; //ramesh
            // this.navigateToCanadaEnglish = true; //ramesh
            //window.alert('InsidegoToCanadaStore() CANADA IF CONDITION');
            //window.sessionStorage.setItem('setCountryCode', storeCA);
            window.sessionStorage.setItem('setCountryCode', storeCA); // Christopher
            this.createCookieforCountry('CountryCodeFromCookie', window.sessionStorage.getItem('setCountryCode'), 7); // Christopher
            this.handleEvent(); //ramesh	
			this.googleAnalyticsStoreInformationPush(this.googleAnalyticsPreviousStore , storeCA);		
            console.log('session8' +window.sessionStorage.getItem('setCountryCode'));
						
						
            window.sessionStorage.setItem('sendDataToCustomSearch',storeCA);
           window.location.href = this.urlString + communityName + '?store=EN';
        } else if (!this.navigateToCanadaEnglish) {
            this.selectedValuefromEvent == storeCAF;
            // this.selectedText = storeCAF; //ramesh
            //this.selectedCountry = storeCanada; //ramesh
            // this.navigateToCanadaEnglish = false; //ramesh
            //window.alert('InsidegoToCanadaStore() CANADA IF ELSE CONDITION');
            console.log('frenchCommunityName' +frenchCommunityName);
            //window.alert('frenchCommunityName' +frenchCommunityName);
            //let urlString = frenchCommunityName;
            window.sessionStorage.setItem('setCountryCode', '');// Christopher CHG0109559
            this.createCookieforCountry('CountryCodeFromCookie', window.sessionStorage.getItem('setCountryCode')); // Christopher CHG0109559
            this.handleEvent(); //ramesh
			this.googleAnalyticsStoreInformationPush(this.googleAnalyticsPreviousStore , storeCAF);			
						// window.sessionStorage.setItem('setCountryCode', '');
						// this.createCookieforCountry('CountryCodeFromCookie', window.sessionStorage.getItem('setCountryCode'));
            console.log('session9' +window.sessionStorage.getItem('setCountryCode'));
            window.sessionStorage.setItem('sendDataToCustomSearch',storeCAF);
           window.location.href = this.urlStringFrenchCommunity + communityName + '?store=FR';
        }


    }

    @track countryCodeValueFromCookie;


    getCookiesData(cname) {
        var decodedCookie = decodeURIComponent(document.cookie);
        var ca = decodedCookie.split(';');
        var res;
        var c;
        console.log('ca value>>>' + ca);
        for (var i = 0; i < ca.length; i++) {
            c = ca[i];
            res = c.split("=");
            console.log('res[0]===='+res[0]);
            console.log('res[1]===='+res[1]);
            console.log(typeof res[0]);
            let storeKey = res[0];
            if(storeKey.trim() == 'CountryCodeFromCookie'){
                console.log('IF block');
                this.countryCodeValueFromCookie = res[1];
            }
        }    
        console.log('countryCodeValueFromCookie====='+this.countryCodeValueFromCookie);
    }

    setFlagForUS(){
        this.selectedflagIcon = usFlagIcon;
        this.selectedText = storeUSA;
        this.selectedCountry = storeUSA;
        this.template.querySelector('.classUS').classList.add('selected');
        this.template.querySelector('.classCA-Eng').classList.remove('selected');
        this.template.querySelector('.classCA-FR').classList.remove('selected');
    }

    setFlagForCanadaEng(){
        this.selectedflagIcon = this.caflagIcon;
        this.selectedText = storeCA;
        this.selectedCountry = storeCanada;
        this.template.querySelector('.classCA-Eng').classList.add('selected');
        this.template.querySelector('.classUS').classList.remove('selected');
        this.template.querySelector('.classCA-FR').classList.remove('selected');
    }
      
    setFlagForCanadaFrench(){
        this.selectedflagIcon = this.caflagIcon;
        this.selectedText = storeCAF;
        this.selectedCountry = storeCanada;
        this.template.querySelector('.classUS').classList.remove('selected');
        this.template.querySelector('.classCA-Eng').classList.remove('selected');
        this.template.querySelector('.classCA-FR').classList.add('selected');
    }
}