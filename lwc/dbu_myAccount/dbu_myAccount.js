import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
import {
    NavigationMixin
} from 'lightning/navigation';
import communityName from '@salesforce/label/c.dbu_communityName';
import hometext from '@salesforce/label/c.dbu_myAccount_home';
import myaccounttext from '@salesforce/label/c.dbu_myAccount_MyAccount';
import getUserInfo from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.getUserInfo';
export default class Dbu_myAccount extends NavigationMixin(LightningElement) {

    @track baseURL;
    @track activeTab = 1;
    @track homeText;
    @track myaccountText;



    tabContent = '';

    connectedCallback() {
        this.getUserDetail();
        this.baseURL = window.location.origin + communityName;
        this.homeText = hometext;
        this.myaccountText = myaccounttext
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        const ordersPage = urlParams.get('orders');
        const wishlistPage = urlParams.get('wishlist');


        if (ordersPage) {
            console.log('orderstrue');
            this.activeTab = 3;
        }

        if (wishlistPage) {
            console.log('wishlisttrue');
            this.activeTab = 4;
        }


    }

    //--------Added by Mukesh Gupta ----(09-12-2020)----------
    //--------Checking current user is guest or logged in------
    getUserDetail() {
        getUserInfo({})
            .then(data => {
                console.log('===data====' + data);
                if (data === 'Guest') {
                    let urlString = window.location.origin;
                    let redirectURL = urlString + communityName + 'trackorder';
                    this[NavigationMixin.Navigate]({
                        "type": "standard__webPage",
                        "attributes": {
                            "url": redirectURL
                        }
                    });
                }
            })
            .catch(error => {
                if (error) {
                    this.errorMsg = error.body.message;
                }
            })
    }

    handleActive(event) {
        // const tab = event.target;
        // this.tabContent = `Tab ${
        //     event.target.value
        // } is now active`;
    }
}