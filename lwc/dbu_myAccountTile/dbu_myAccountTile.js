import {
    LightningElement,
    track,
    wire
} from 'lwc';
import getLoggedInUserInfo from '@salesforce/apex/dbu_LoggedInUserinfo.getLoggedInUserInfo';
//Amar added this below line to fetch userid
//import strUserId from '@salesforce/user/Id';
import communityName from '@salesforce/label/c.dbu_communityName';
import signInURL from '@salesforce/label/c.dbu_login_URL';
import signOutURL from '@salesforce/label/c.dbu_logout_URL';
import registrationURL from '@salesforce/label/c.dbu_registration_URL';
//Added by Malhar - 14/12/2020
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French'; //custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA'; //custom label refres to'CA'
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
export default class Dbu_myAccountTile extends LightningElement {

    @track sldsExpended = false;
    @track selectedText = 'My Account';
    @track selectedData = storeUSA;
    @track showHideDropDown = false;
    //userId = strUserId;
    //areDetailsVisible = false;
    @track IsCustomerLoggedIn;
    @track myAccBtnClass = "btn btn-secondary dropdown-toggle btn-clr";

    @track LoggedInLoggedOutCus;
    @track SignInURL = signInURL;
    @track CreateAccountURL = registrationURL;
    @track SignOutURL = signOutURL;
    @track isModalOpen = false;
    @track trackOrderURL;
    @track myAccountURL;
    @track wishListURL;
    @track ordersURL;

     //Added by Malhar for getting the storelocation  value - 14/12/2020
     @track currentStorelocation;    
     @track sendLocBackToChangeLocTile;

    //Login URL:- https://csodev-cumminscss.cs90.force.com/cw/IAM_Authorize?appid=a1a1F0000018d4x
    //https://dbuecomdev-cumminscss.cs24.force.comcw/IAM_Authorize?appid=a1a1F0000018d4x
    //            https://dbuecomdev-cumminscss.cs24.force.com/CSSNAStore/s/cw/IAM_Authorize?appid=a1a1F0000018d4x

    //Logout URL:- https://csodev-cumminscss.cs90.force.com/cw/IAM_Logout
    connectedCallback() {

        let urlString = window.location.origin;

        /*Added by Malhar for store toggling begins - 14/12/2020 */
            /*added by mounika t to navigation through nav mixin */
            let locationURL = window.location.href;
            console.log('locationURL on my accountile > ' + locationURL);
            var url = new URL(locationURL);
            
            //this.sendLocBackToChangeLocTile = url.searchParams.get("store");
            this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');

            //pubsub.fire('sendLocToStore', this.sendLocBackToChangeLocTile);
            console.log('locationURL111 my acct tile > ' + this.sendLocBackToChangeLocTile);
            /*added by mounika t to navigation through nav mixin */

            /*Added By Malhar to get store country from this.sendLocBackToChangeLocTile 1/12/2020 */
            if(this.sendLocBackToChangeLocTile == storeUSA || this.sendLocBackToChangeLocTile == null 
                || this.sendLocBackToChangeLocTile == undefined || this.sendLocBackToChangeLocTile == ''){
                this.sendLocBackToChangeLocTile = storeUSA;
                this.currentStorelocation = storeUSA;
                
            }else if(this.sendLocBackToChangeLocTile == storeCA || this.sendLocBackToChangeLocTile == storeCAF){
                this.currentStorelocation = storeCanada; 
                
            }
            console.log('this.currentStorelocation myaccountTile pg connected callback > ' + this.currentStorelocation);
            /*Added By Malhar to get store country from this.sendLocBackToChangeLocTile 1/12/2020 */        

        /*Added by Malhar for store toggling ends - 14/12/2020 */

        //this.SignInURL = urlString+'/cw/IAM_Authorize?appid=a1a1F0000018d4x';
        //this.CreateAccountURL = urlString + '/cw/IAM_Basic_Registration?appid=a1a1F0000018d4x';
        //this.SignOutURL = urlString+'/cw/IAM_Logout';
        console.log('SignInURL>>>>>>' + this.SignInURL);
        console.log('SignOutURL>>>>>>' + this.SignOutURL);
        this.trackOrderURL = urlString + communityName + 'track-order' + '?store=' + this.sendLocBackToChangeLocTile;
        //following url changed by Malhar for toggling store location - 14/12/2020
        this.myAccountURL = urlString + communityName + 'my-account' + '?store=' + this.sendLocBackToChangeLocTile;
        //following url changed by Malhar for toggling store location - 14/12/2020
        this.wishListURL = urlString + communityName + 'my-account?wishlist=true' + '&store=' + this.sendLocBackToChangeLocTile;
        this.ordersURL = urlString + communityName + 'my-account?orders=true' + '&store=' + this.sendLocBackToChangeLocTile;



    }

    @wire(getLoggedInUserInfo)
    response({
        error,
        data
    }) {
        if (data) {
            console.log('getLoggedInUserInfo>>>>>>20', (data));
            this.LoggedInLoggedOutCus = data;
            this.error = undefined;
            console.log('getLoggedInUserInfo>>>>>>23', (JSON.stringify(this.LoggedInLoggedOutCus)));
            //document.getElementById("drpleid").innerHTML = document.getElementById(record).innerHTML;
            if (this.LoggedInLoggedOutCus.length > 0) {
                console.log('Inside If');
                this.CustomerName = this.LoggedInLoggedOutCus[0].FirstName + ' ' + this.LoggedInLoggedOutCus[0].LastName;
                this.IsCustomerLoggedIn = true;
                this.myAccBtnClass = 'btn btn-secondary dropdown-toggle btn-clr loggedIn';
            } else {
                console.log('Inside 2If');
                this.IsCustomerLoggedIn = false;
                this.myAccBtnClass = 'btn btn-secondary dropdown-toggle btn-clr guest';
            }
        } else if (error) {
            this.error = error;
            this.CustomerName = undefined;

        }
    }
    openModal() {
        console.log('Inside openModal ==> ');
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }

    get ScreenLoaded() {
        return this.areDetailsVisible;
    }
    get ldsDiv() {
        return this.sldsExpended ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    }
    get languageSelector() {
        return this.sldsExpended ? 'languageSelectorOpen' : 'languageSelectorClosed';
    }

    handleToSignInLinkClick(){        
        console.log('ENTERING IN THE handleToSignInLinkClick');
        invokeGoogleAnalyticsService('SIGNIN LINK CLICK', 'IAM');                 
    }

    get navigateToSignInURL(){
        return this.SignInURL;
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

    handleClickOnChange(event) {

        this.selectedText = event.target.dataset.id;
        console.log("handleClickChangeLoaction" + this.selectedText);

        if (this.selectedText == 'Settings') {

            this.selectedText = 'Settings';
            this.selectedData = 'Settings';

        } else if (this.selectedText == 'Track Order') {
            this.selectedText = 'Track Order';
            this.selectedData = 'Track Order';

        } else if (this.selectedText == 'Wishlist') {
            this.selectedText = 'Wishlist';
            this.selectedData = 'Wishlist';

        }
        this.ldsClickHandler();
    }
    /*     
    handleChange(event) {
        if(userId != null){
            this.areDetailsVisible = true;
        }
        else{
            this.areDetailsVisible = false;
        }
        
    }
    */
}