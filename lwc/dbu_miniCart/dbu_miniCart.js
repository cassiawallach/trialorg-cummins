import { LightningElement , track, wire} from 'lwc';
import pubsub from 'c/pubsub' ; 
//import FooterPhoneIcon from '@salesforce/resourceUrl/dbu_Footer_Phone';
import myResource from '@salesforce/resourceUrl/cloudMVP';
import deleteIc from '@salesforce/resourceUrl/dbu_delete';
import fetchLstCartItemsByCartIdwithStoreLocation from '@salesforce/apex/dbu_CartCtrl.fetchLstCartItemsByCartIdwithStoreLocation';
import fetchCartSize from '@salesforce/apex/dbu_CartCtrl.fetchCartSize';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import deleteCartItem from '@salesforce/apex/dbu_CartCtrl.deleteCartItem';
import communityName from'@salesforce/label/c.dbu_communityName';
import isGuest from '@salesforce/user/isGuest';
//import fetchCartId from '@salesforce/apex/dbu_Util.fetchCartId';
import fetchCartId from '@salesforce/apex/dbu_CartCtrl.fetchCartId';
import mergeCart from '@salesforce/apex/dbu_CartCtrl.mergeCart';
import updateCartItemToDefaultShip from '@salesforce/apex/dbu_CartCtrl.updateCartItemToDefaultShip';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada'; //custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French'; //custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA'; //custom label refres to'CA'
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA'; //custom label refres to'USD'
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada'; //custom label refres to'CAD'


/*Added by Malhar for save for later - 17/12/2020*/
import SaveForLaterFetchProductDetails from '@salesforce/apex/dbu_SaveForLatetGeneric.fetchProductDetailsByProductID';
import FetchLoggedInUserSaveforLaterItems from '@salesforce/apex/dbu_SaveForLatetGeneric.fetchLoggedInUserWishlistItems';
import loginInURL from '@salesforce/label/c.dbu_login_URL';
import registrationURL from '@salesforce/label/c.dbu_registration_URL';
import getRelatedProductByProductId from '@salesforce/apex/dbu_CallCCWishListApi.getRelatedProductByProductId';
import AddProductToSaveforLater from '@salesforce/apex/dbu_SaveForLatetGeneric.AddProductTo_WishList_or_SaveForLater_forLoggedInUser';
import dbu_miniCart_accept from '@salesforce/label/c.dbu_miniCart_accept';
import dbu_miniCart_register from '@salesforce/label/c.dbu_miniCart_register';
import dbu_miniCart_noThanks from '@salesforce/label/c.dbu_miniCart_noThanks';
import dbu_miniCart_signIn from '@salesforce/label/c.dbu_miniCart_signIn';
import dbu_miniCart_doYouWant from '@salesforce/label/c.dbu_miniCart_doYouWant';
import dbu_miniCart_or from '@salesforce/label/c.dbu_miniCart_or';
import dbu_goToCart from '@salesforce/label/c.dbu_goToCart';
import dbu_miniCart_pleaseAcceptOurCookiePolicy from '@salesforce/label/c.dbu_miniCart_pleaseAcceptOurCookiePolicy';
//import dbu_minicart_goshop from '@salesforce/label/c.dbu_minicart_goshop';
import dbu_home_header_cartEmptyMessage from '@salesforce/label/c.dbu_home_header_cartEmptyMessage';
import dbu_home_header_cart from '@salesforce/label/c.dbu_home_header_cart';
import { perfixCurrencyISOCode } from 'c/serviceComponent';
import dbu_miniCart_oopsYourCartIsEmpty from '@salesforce/label/c.dbu_miniCart_oopsYourCartIsEmpty';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import dbu_freeShipping from '@salesforce/resourceUrl/dbu_freeShipping_miniCart'; //Sandeep
import dbu_fromShipping from '@salesforce/label/c.dbu_from_FREE_Shipping';
import dbu_gotFreeShipping from '@salesforce/label/c.dbu_You_ve_got_Free_Shipping';
import dbu_shippingonOrders from '@salesforce/label/c.dbu_Free_shipping_on_orders_100';
import dbu_restrictions_apply_link from '@salesforce/label/c.dbu_restrictions_apply_link';
import progressbar from '@salesforce/resourceUrl/progressbar'; //Sandeep
import { loadStyle, loadScript } from 'lightning/platformResourceLoader'; //Sandeep
import dbu_shippingonOrders_canada from '@salesforce/label/c.dbu_Free_shipping_on_orders_35_Canada';//sandeep
import dbu_ShippingCost_TotalAmout from '@salesforce/label/c.dbu_ShippingCost_TotalAmout';

//import mergeGuestWithAuthCart from '@salesforce/apex/dbu_CartCtrl.mergeGuestWithAuthCart';

export default class Dbu_miniCart extends NavigationMixin(LightningElement) {
    @track imageUrl = myResource;
    //deleteIcon = myResource +'/images/dbu_deleteIcon.png';
   // @track cartItemId;
    @track showHideDropDown = false;
    @track cartDetails ;
    @track cartId = '';
    @track numberOfItemInCart = 0;
    //@track goToCartUrl;
    @track isMiniCartLoading = false;
    @track baseURL;
    @track isGuestUser = isGuest;
    @track sendLocBackToChangeLocTile;
    @track changedLocation;
    @track signInURL = loginInURL;
    @track shippingonlimitCanada =dbu_shippingonOrders_canada;

    //Added by Malhar for Save for Later - 17/12/2020
    @track footerbannercookiestatus;
    @track cookiePolicyAccepted = false;
    @track saveForLaterEventData;
    @track showCookiePolicyModel = false;
    @track saveforlatercookievalue;
    //Added by Malhar to store courrent store country
    @track currentStorelocation = storeUSA;
    @track countryCurrencyCode;
    @track navigateToProdURL;
    @track productName;
    @track dbu_miniCart_accept = dbu_miniCart_accept;
    @track dbu_miniCart_register = dbu_miniCart_register;
    @track dbu_miniCart_signIn = dbu_miniCart_signIn;
    @track dbu_miniCart_noThanks = dbu_miniCart_noThanks;
    @track dbu_miniCart_doYouWant = dbu_miniCart_doYouWant;
    @track dbu_miniCart_or = dbu_miniCart_or;
    @track dbu_goToCart = dbu_goToCart;
    @track dbu_miniCart_pleaseAcceptOurCookiePolicy = dbu_miniCart_pleaseAcceptOurCookiePolicy;
    //@track dbu_minicart_goshop = dbu_minicart_goshop;
    @track dbu_home_header_cartEmptyMessage = dbu_home_header_cartEmptyMessage;
    @track dbu_home_header_cart =dbu_home_header_cart;
    @track dbu_miniCart_oopsYourCartIsEmpty = dbu_miniCart_oopsYourCartIsEmpty;
    @track displayFreeShipping; //Sandeep
    @track cartValuePercentage; //Sandeep
    @track remainingValue; //Sandeep
    @track freeShippingRemainingValue; //CHG0106444 - Ramesh
    @track freeShippingImage = dbu_freeShipping; //Sandeep
    @track costShippedProduct; //Sandeep - 9th Nov
    @track totalCartValue; //Sandeep
    @track fromShipping =dbu_fromShipping;//Sandeep
    @track gotFreeShipping =dbu_gotFreeShipping;//sandeep
    @track shippingonlimit =dbu_shippingonOrders;//sandeep 
    @track restrictionsApply =dbu_restrictions_apply_link; //sandeep
    @track shippingPolicyURL; //sandeep
    @track displayShippingMessage; //Sandeep - 11th Nov           
    @track gUserCartId;
    @track isCanadaStore = false;
    @track maxLimit = parseInt(dbu_ShippingCost_TotalAmout);
    @track mergeCallDone;
    @track cartCurrentValue = '';
    @track authFlow = false;
    @track callBackDone;
    @track currQty = 0;
    
    get ScreenLoaded() {
        return this.isMiniCartLoading;
    }
    

    gethederbannerCookie(name) {
        var name = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
          var c = ca[i];
          while (c.charAt(0) == ' ') {
            c = c.substring(1);
          }
          if (c.indexOf(name) == 0) {
            this.headerbannercookiestatus = c.substring(name.length, c.length);
          }
        }
      }

    //Sandeep Starts
    renderedCallback() {  
         Promise.all([
            loadStyle(this, progressbar)
        ]).then(() => {
                console.log( 'Files loaded' );
            })
            .catch(error => {
                console.log( error.body.message );
        }); 
    }
    //Sandeep Ends

    connectedCallback() {
        this.imageUrl = myResource + '/images/CumminsEngine.jpg';
        this.deleteIcon = deleteIc;
        let urlString = window.location.origin;
        /*added by mounika t to navigation through nav mixin */
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        
        //this.sendLocBackToChangeLocTile = url.searchParams.get("store");
        this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
        //pubsub.fire('sendLocToStoreFromMinicart', this.sendLocBackToChangeLocTile);
        /*added by mounika t to navigation through nav mixin */
        

        /*Added By Malhar to get store country from this.sendLocBackToChangeLocTile 1/12/2020 */
        if(this.sendLocBackToChangeLocTile == storeUSA || this.sendLocBackToChangeLocTile == null ||
            this.sendLocBackToChangeLocTile == undefined || this.sendLocBackToChangeLocTile == ''){
            this.currentStorelocation = storeUSA;
            this.sendLocBackToChangeLocTile = storeUSA;
            this.countryCurrencyCode = currencyCodeUSA;
        }else if(this.sendLocBackToChangeLocTile == storeCA || this.sendLocBackToChangeLocTile == storeCAF){
            this.currentStorelocation = storeCanada; 
            this.countryCurrencyCode = currencyCodeCanada;
            this.isCanadaStore = true;
        }
        console.log('this.currentStorelocation mini cart page connected callback > ' + this.currentStorelocation);

        /*Added By Malhar to get store country from this.sendLocBackToChangeLocTile 1/12/2020 */        
        
        /**27 Oct 2020: New Logic to Handle cartId in case of loggeduser && GuestUser*/

        if(this.currentStorelocation == "US" && this.getCookieValueOfCart('cartId').length){
            console.log("Setting GuestID");
            this.getCookie('cartId');
            this.gUserCartId = this.cartId;
        }    
        else if(this.currentStorelocation == "CA" && this.getCookieValueOfCart('cartIdCA').length){
            console.log("Setting GuestID");
            this.getCookie('cartIdCA');
            this.gUserCartId = this.cartId;
        }
        

        if (this.isGuestUser) {                        
            /*Modification by MALHAR - end - store toggling - 1/12/2020 */     
            this.checkForSaveforLaterSessionvalue();            
        } else {
            console.log("Else Condition");
            this.authFlow = true;
            if((this.currentStorelocation == 'US' && this.getCookieValueOfCart('cartId').length) || (this.currentStorelocation == 'CA' && this.getCookieValueOfCart('cartIdCA').length)){                
                mergeCart({ 
                    storeCountry:this.currentStorelocation, 
                    anonymousCartID: this.gUserCartId
                    //anonymousCartID: "a1y3C000000hucgQAA"
                })
                .then(result =>{ 
                    this.callBackDone = true;
                    console.log("Result for merging guest and authenticated carts", result);
                    this.cartId = result;
                    this.error = undefined;
                    if(this.currentStorelocation == 'US'){ 
                        this.createCookie('cartId', ''); 
                    }else{
                        this.createCookie('cartIdCA', '');
                    }
                    this.mergeCallDone = true;
                    updateCartItemToDefaultShip({authenticatedCartID: result})
                    .then(result =>{
                        console.log("Return from 2nd promise:"+result);
                    })
                })
                .catch(error =>{ 
                    this.error = error.message;
                })
            }else{
                fetchCartId({
                    storeCountry : this.currentStorelocation
                })
                .then(result => {
                    this.callBackDone = true;
                    console.log('CartId in case of loggedIn User in MiniCart===>', result);
                    this.cartId = result;
                    console.log('CartId in case of loggedIn User in MiniCart1===>', result);
                    this.error = undefined;
                })
                .catch(error => {
                    this.error = error.message;
                });
            }
            
        }
        /**Ended here */
        
        
        console.log('cartIdCookie=>' + this.cartId);
        this.register();
        this.baseURL = urlString + communityName;
        this.shippingPolicyURL = this.baseURL + 'shipping-policy?store=' + this.sendLocBackToChangeLocTile;
        setTimeout(() => {
            console.log('this.headerbannercookiestatus cart connected call > ' + this.headerbannercookiestatus);
            this.gethederbannerCookie('headerBanner');
            if (this.headerbannercookiestatus) {
                this.template.querySelector('.mcComboBox').classList.remove('hcbAvail');
            }
        }, 500);


    }

    navigatetocartpage(){
        invokeGoogleAnalyticsService('NAVIGATE TO CART PAGE', 'Navigate to cart Page on button click');
    }

    get goToCartUrl(){ 
        console.log(' Go to cart from Minicart with cartid ------- > ' + this.cartId);    
        return this.baseURL+'cart?cartId='+this.cartId+'&store='+this.sendLocBackToChangeLocTile;
    }
    
    get shippingPolicyURLredirect(){
        return this.shippingPolicyURL;   
      }
    getCookie(name) {//renamed
        var name = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                this.cartId = c.substring(name.length, c.length);
            }
        }
    }
    getCookieValueOfCart(name){
        var name = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {             
                console.log("The Cookie Value Currently is"+c.substring(name.length, c.length));
                this.cartCurrentValue = c.substring(name.length, c.length);
            }
        }
        return this.cartCurrentValue;
    }


     

    @wire(fetchLstCartItemsByCartIdwithStoreLocation, { cartId: '$cartId', cart: '', storeCountry:'$currentStorelocation' })
    wireProduct({ error, data }) {        
        if (data && data.length > 0) {
            console.log(data);
            window.console.log('Data = >fetchLstCartItemsByCartIdwithStoreLocation in MiniCart=====', data);
            this.cartDetails = data;
            this.error = undefined;
            this.currQty = data[0].totalQuantity;
            if(this.authFlow){
                if(this.callBackDone != undefined){
                    console.log("Auth and CallBack Pass datavalll", data[0]);
                    this.numberOfItemInCart = data[0].totalQuantity;
                }else{
                    console.log("Auth Pass, Callback Fail datavalll", data[0]);
                    this.numberOfItemInCart = 0;
                }
            }else{
                console.log("Non Auth Flow");
                this.numberOfItemInCart = data[0].totalQuantity;
            }
            this.totalCartValue = 0;
            let cartdata = JSON.stringify(data);
            this.cartDetails = JSON.parse(cartdata);
                //Sandeep starts - start
                this.costShippedProduct = this.cartDetails[0].costShippedProduct;
                //Sandeep ends - start
            this.cartDetails.forEach(element => {
                element.lstCartItem.forEach(item => {
                    item['formatedSubAmount'] = perfixCurrencyISOCode(this.countryCurrencyCode ,item.cartItem.ccrz__SubAmount__c);
                    // item['formatedSubAmount'] = item.cartItem.ccrz__SubAmount__c.toLocaleString('en-US', {
                    //     style: 'currency',
                    //     currency: this.countryCurrencyCode,
                    //     minimumFractionDigits: 2,
                    //     maximumFractionDigits: 2
                    // });
                    console.log('MiniCart item.cartItem.ccrz__SubAmount__c ==', item.cartItem.ccrz__SubAmount__c);
                    console.log('MiniCart itemformatedSubAmount', item['formatedSubAmount']);
                    this.totalCartValue =  this.totalCartValue + item.cartItem.ccrz__SubAmount__c;
                })
            });
            //Sandeep starts - start
            if( this.costShippedProduct > 0 &&  this.costShippedProduct < this.maxLimit){ //Sandeep - 9th Nov
                this.displayFreeShipping = false;
                this.remainingValue = ((Math.round((this.maxLimit- this.costShippedProduct)*100) / 100).toFixed(2)) * 1;
                 //CHG0106444 - ramesh start
                 this.freeShippingRemainingValue = perfixCurrencyISOCode(this.countryCurrencyCode,this.remainingValue);
                 //CHG0106444 - ramesh end
                this.cartValuePercentage =  (this.costShippedProduct/this.maxLimit)*100;  //this.costShippedProduct;
                    this.displayShippingMessage = true;
            }
            else if(this.costShippedProduct == 0){
                this.displayShippingMessage = false;
                this.cartValuePercentage = 0;
            }
            else{
                this.cartValuePercentage = 100;    
                this.displayFreeShipping = true;
                    this.displayShippingMessage = true;
            }
            //Sandeep ends - start
            this.isMiniCartLoading = false;
        } else if (error) {
            this.error = error;
            this.cartDetails = undefined;
            this.totalCartValue = 0;
        }            
        
    }

    fetchLstCartItemsByCartIdwithStoreLocationFn(){
        fetchLstCartItemsByCartIdwithStoreLocation({
            cartId:this.cartId,
            cart: 'cart',
            storeCountry: this.currentStorelocation
        }).then(data=>{
            if (data && data.length > 0) {
                console.log(data);
                window.console.log('Data = >fetchLstCartItemsByCartIdwithStoreLocation in MiniCart=====', data);
                this.cartDetails = data;
                this.error = undefined;
                this.numberOfItemInCart = data[0].totalQuantity;
                let cartdata = JSON.stringify(data);
                this.cartDetails = JSON.parse(cartdata);
                this.cartDetails.forEach(element => {
                    element.lstCartItem.forEach(item => {
                        item['formatedSubAmount'] = perfixCurrencyISOCode(this.countryCurrencyCode ,item.cartItem.ccrz__SubAmount__c);
                        console.log('MiniCart item.cartItem.ccrz__SubAmount__c ==', item.cartItem.ccrz__SubAmount__c);
                        console.log('MiniCart itemformatedSubAmount', item['formatedSubAmount']);
                    })
                });
                this.isMiniCartLoading = false;
            } else if (error) {
                this.error = error;
                this.cartDetails = undefined;
            }  
        });
    }

    expanded = false;
    sldsExpended = false;



    get ldsDiv() {
        return this.sldsExpended ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    }

    get divClass() {
        return this.expanded ? 'dropdown show' : 'dropdown';
    }

    get menuClass() {
        return this.expanded ? 'dropdown-menu show' : 'dropdown-menu';
    }

    getPosition() {
        return this.expanded ? 'position: absolute; transform: translate3d(0px, 38px, 0px); top: 0px; left: 0px; will-change: transform;' : '';
    }
    ldsClickHandler() {
        console.log('yyyyyyyyyyyyyyyyyyyyyyyyy');
        if (this.sldsExpended) {
            this.sldsExpended = false;
        }
        else {
            this.sldsExpended = true;
        }
        refreshApex(this.cartDetails);

        /*Adding noscroll to body tag starts */
        const bodyNoscroll = document.querySelector("body");
        if(bodyNoscroll.classList.contains("noscroll")){
            document.querySelector('body').classList.remove('noscroll');
        } else {
            document.querySelector('body').classList.add('noscroll');
        }
        /*Adding noscroll to body tag ends */
    }
    onClickHandler() {
        if (this.expanded) {
            this.expanded = false;
        }
        else {
            this.expanded = true;
        }
    }
    onmouseoutHandler() {
        this.expanded = false;
        this.sldsExpended = false;
        document.querySelector('body').classList.remove('noscroll');

    }
    bsMenuItemClick(event) {

        this.selectedText = event.target.value;
        console.log('selectedvalue>>>' + this.selectedText);

    }
    sldsMenuItemClick(event) {

        this.selectedValue = 'This is selected';
        // this.selectedValue = event.detail.value;
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


    handleDeleteItemFromCart() {

        System.debug('>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<');
    }

    handleClickAddToCart() {//Commented by Shriram
        console.log('????????????????');
        // const evt = new ShowToastEvent({
        //     title: 'Item Added Successfully',
        //     message: 'Item added successfully in the Cart',
        //     variant: 'success',
        //     mode: 'dismissable'
        // });
        // this.dispatchEvent(evt);
        //New Logic on 15th July
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'dbu_cart__c'
            }
        },
            true // Replaces the current page in your browser history with the URL
        );
        //NAVIGATION END HERE

    }


    register() {
        window.console.log('event registered ');
        pubsub.register('fetchcartevt', this.handleEvent.bind(this));
        pubsub.register('sendDataTolstProdDetailspage', this.handleEventLoc.bind(this));

    }
    handleEventLoc(event) {
        console.log('event in handler in mini cart>>' + event);
        this.changedLocation = event;
        pubsub.fire('sendLocToStoreFromMinicart', this.changedLocation);
    }
    handleEvent(event) {
        console.log('event Handled In Mini cart>>>>>>>>>>>', event);
        //this.numberOfItemInCart = event;
        //this.numberOfItemInCartByPubsub = event;
        this.cartDetails = event;
        //console.log('event Handled>In Mini cart Length>>>>>>>>>>>>>>>>>>>>.', event.length);
        if (event != undefined && event.length > 0) {
            console.log('InMini cart event Handled>event[0].totalQuantity>>>>>>>>>>>>>>>>>>>>.', event[0].totalQuantity);
            this.numberOfItemInCart = event[0].totalQuantity;
            // get sum of msgCount prop across all objects in array
            //this.numberOfItemInCart = event[0].lstCartItem.reduce(function(prev, cur) {
            // return prev + cur.quantity;
            //}, 0);
            /**Decimal related changes */                            //}, 0);
            let cartdata = JSON.stringify(event);
            this.totalCartValue =  0;
            
            this.cartDetails = JSON.parse(cartdata);
            //Sandeep starts - start
            this.costShippedProduct = this.cartDetails[0].costShippedProduct; //Sandeep
            //Sandeep ends - start
            this.cartDetails.forEach(element => {
                element.lstCartItem.forEach(item => {
                    item['formatedSubAmount'] = perfixCurrencyISOCode(this.countryCurrencyCode ,item.cartItem.ccrz__SubAmount__c);
                    // item['formatedSubAmount'] = item.cartItem.ccrz__SubAmount__c.toLocaleString('en-US', {
                    //     style: 'currency',
                    //     currency: this.countryCurrencyCode,
                    //     minimumFractionDigits: 2,
                    //     maximumFractionDigits: 2
                    // });
                    console.log('MiniCart formatedSubAmount in event register method ==', item.cartItem.ccrz__SubAmount__c);
                    this.totalCartValue =  this.totalCartValue + item.cartItem.ccrz__SubAmount__c;
                })
            });
            /**Ended here */
            //Sandeep starts - start
			if( this.costShippedProduct > 0 &&  this.costShippedProduct < this.maxLimit){ //Sandeep - 9th Nov
                this.displayFreeShipping = false;
                this.remainingValue = ((Math.round((this.maxLimit- this.costShippedProduct)*100) / 100).toFixed(2)) * 1;
                // CHG0106444 -ramesh start
             this.freeShippingRemainingValue = perfixCurrencyISOCode(this.countryCurrencyCode,this.remainingValue);
             // CHG0106444 - ramesh  end
                this.cartValuePercentage = (this.costShippedProduct/this.maxLimit)*100;  //this.costShippedProduct;
                 this.displayShippingMessage = true;
            }
            else if(this.costShippedProduct == 0){
                this.displayShippingMessage = false;
                this.cartValuePercentage = 0;
            }
            else{
                this.cartValuePercentage = 100;  
                 this.displayShippingMessage = true;  
                this.displayFreeShipping = true;
            }
            //Sandeep ends - start

        }
        else {
            this.numberOfItemInCart = 0;
            console.log('Making cart as blank>>>>>>>>>>>', event);
            this.cartDetails = undefined;
            this.totalCartValue =  0;
        }
    }
    onProductDelete(event) {
        this.isMiniCartLoading = true;
        console.log('onProductDelete event.target.dataset.id=======>' + event.target.dataset.id);
        console.log('onProductDelete cartIdCookie=============>' + this.cartId);
        if(window.location.pathname == '/CSSNAStore/s/cart'){
            pubsub.fire('minicartclearevt', {cartclear : true});
        }
        //ensenada 
        deleteCartItem({
            cartItemId: event.target.dataset.id,
            cartId: this.cartId
        }).then(result => {
            // Clear the user enter values
            window.console.log('In onProductDelete before fire eventresult ===> ' + result);
            //this.createCookie('In onProductDelete cartId', result[0].cartId, 1);
            pubsub.fire('fetchcartevt', result);
            window.console.log('After fire eventresult ===> ' + result);
            this.isMiniCartLoading = false;

        })
        .catch(error => {
            this.error = error.message;
        });
    }

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

    /*Added by Malhar -  17/12/2020 */
    getCookiePolicyAccepted(name) {
        var name = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                this.cookiePolicyAccepted = c.substring(name.length, c.length);
            }
        }
    }    
    
    /*Added by Malhar -  17/12/2020 */
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

    /*Added by Malhar -  17/12/2020 */
    checkForSaveforLaterSessionvalue(){
        this.getfooterbannerCookie('footerBanner');
        console.log('this.footerbannercookiestatus mini cart connected call > ' + this.footerbannercookiestatus);
        
        if(this.footerbannercookiestatus){
            if(this.currentStorelocation == storeUSA){

                console.log('Inside mini CART PG CONNECTED CALL UNITED STATES');
                let UScartidInSessionStorage = window.sessionStorage.getItem('cartId');
                console.log('UScartidInSessionStorage >>>>> ' + UScartidInSessionStorage);
                this.getCookie('cartId');
                console.log('this.cartId US >>>>>> ' + this.cartId);
                console.log('this.cartId US typeof >>>>>> ' + typeof this.cartId);

                if(UScartidInSessionStorage !== null && (typeof this.cartId == "undefined" || this.cartId.length === 0)){
                    console.log('inside UScartidInSessionStorage');
                    this.cartId = UScartidInSessionStorage;
                    console.log('this.cartId US ***** ' + this.cartId);
                    this.createCookie('cartId', this.cartId, 7);
                    window.sessionStorage.removeItem('cartId');
                }  

                //this.getCookie('cartId');
                console.log('CartId in case of Guest User for US store in connectd call metd of minicart page===>', this.cartId);
            }    
            else if(this.currentStorelocation == storeCanada){

                console.log('Inside CART PG CONNECTED CALL CANADA');                    
                let CAcartidInSessionStorage = window.sessionStorage.getItem('cartIdCA');
                console.log('CAcartidInSessionStorage >>>>> ' + CAcartidInSessionStorage);                    
                this.getCookie('cartIdCA');
                console.log('this.cartId CA >>>>>> ' + this.cartId);
                console.log('this.cartId CA typeof >>>>>> ' + typeof this.cartId);

                if(CAcartidInSessionStorage !== null && (typeof this.cartId == "undefined" || this.cartId.length === 0)){
                    console.log('inside CAcartidInSessionStorage');
                    this.cartId = CAcartidInSessionStorage;
                    console.log('this.cartId CA ***** ' + this.cartId);
                    this.createCookie('cartIdCA', this.cartId, 7);
                    window.sessionStorage.removeItem('cartIdCA');
                }    

                //this.getCookie('cartIdCA');
                console.log('CartId in case of Guest User for CA store in connectd call metd of minicart page===>', this.cartId);
            }
        }else if(typeof this.footerbannercookiestatus == "undefined"){                
            if(this.currentStorelocation == storeUSA){
                //this.getCookie('cartId');
                this.cartId = window.sessionStorage.getItem('cartId');
                console.log('session storage CartId in case of Guest User for US store in connectd call metd of minicart page===>', this.cartId);
            }    
            else if(this.currentStorelocation == storeCanada){
                //this.getCookie('cartIdCA');
                this.cartId = window.sessionStorage.getItem('cartIdCA');
                console.log('session storage CartId in case of Guest User for CA store in connectd call metd of minicart page===>', this.cartId);
            }                                
        }
        console.log('CartId in case of Guest User===>', this.cartId); 
    }

    /*Added By Malhar 17-12-2020*/
    getSaveforLaterCookieByLocation(){
        if(this.currentStorelocation == storeUSA){
            this.getsaveforlaterCookie('saveforlater');
               console.log('save for later Guest User US store forguest> ', this.saveforlatercookievalue);
        }    
           else if(this.currentStorelocation == storeCanada){
            this.getsaveforlaterCookie('saveforlaterCA');
               console.log('save for later Guest User CA store forguest>', this.saveforlatercookievalue);
        }                  
        console.log('this.saveforlatercookievalue >> ' + this.saveforlatercookievalue);        
    }  

    /*Added By Malhar 17-12-2020*/
    setsaveforlaterCookie(name, value, days) {
        var expires;

        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            //console.log('date.getTime() + (days * 24 * 60 * 60 * 1000)=>'+date.getTime() + (days * 24 * 60 * 60 * 1000))
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = name + "=" + escape(value) + expires + "; path=/";
    }

    /*Added By Malhar 29-12-2020*/
    getsaveforlaterCookie(name) {
        var name = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                this.saveforlatercookievalue = unescape(c.substring(name.length, c.length));
            }
        }
    }    
    
    /*Added By Malhar 17-12-2020*/
    showCookiePolicyModelCancelHandle() {
        this.showCookiePolicyModel = false;
    }

    /*Added By Malhar 17-12-2020*/    
    showCookiePolicyModelAcceptHandle() {
        console.log('cookie policy accept model > ');
        this.showCookiePolicyModel = false;
        invokeGoogleAnalyticsService('ACCEPT COOKIES', 'ACCEPT COOKIES'); 
        this.setsaveforlaterCookie('footerBanner', 'true', 7);
        
        console.log('cookie policy set');
        pubsub.fire('ResetFooterBannermodalfromCart', true);
        //pubsub.fire('ResetFooterBannermodalfromCart', true);
        /*Modification by MALHAR - end - store toggling - 1/12/2020 */
        this.checkForSaveforLaterSessionvalue();
        //this.processSaveforlaterAddProductOperation();
        //this.isLoading = false;
        console.log('OUT!!!');
    }    


    handleToSignInLinkClick(){        
        console.log('ENTERING IN THE handleToSignInLinkClick');
        invokeGoogleAnalyticsService('SIGNIN LINK CLICK', 'IAM');                 
    }

    get navigateToSignInURL(){
        return this.signInURL;
    }


    /*Added By Malhar 17-12-2020*/
    saveforlaterAddProductOperation(event) {
        console.log('SFL event > ' + event);
        console.log('SFL event ID > ' + event.target.dataset.id);
        this.saveForLaterEventData = event.target.dataset.id;
        console.log('this.saveForLaterEventData > ' + this.saveForLaterEventData);
        if (this.isGuestUser) {
            console.log('inside guestuser loop');
            this.getCookiePolicyAccepted('footerBanner');
            console.log('this.cookiePolicyAccepted >> ' + this.cookiePolicyAccepted);

            if (!this.cookiePolicyAccepted) {
                console.log('cookie policy not accepted');                
                this.showCookiePolicyModel = true;
            } else {
                console.log('cookie policy accepted');
                this.showCookiePolicyModel = false;
                this.beginSaveforlaterOperation();
            }
        } else {
            console.log('if not a guest user');
            this.showCookiePolicyModel = false;
            this.beginSaveforlaterOperation();
        }
    }  
    
    beginSaveforlaterOperation(){
        console.log('ENTERED IN beginSaveforlaterOperation METHOD');
        console.log('this.saveForLaterEventData >  ' + this.saveForLaterEventData);

        this.isMiniCartLoading = true;
        let SaveforLaterCartItem = {};
        for (let i = 0; i < this.cartDetails[0].lstCartItem.length; i++) {

            if (this.cartDetails[0].lstCartItem[i].cartItem.Id == this.saveForLaterEventData) {
                console.log('event.target.dataset.id=>', this.saveForLaterEventData);
                SaveforLaterCartItem = this.cartDetails[0].lstCartItem[i].cartItem;
                break;
            }
        }
        
        console.log(JSON.stringify(SaveforLaterCartItem));

        let sflProductID = SaveforLaterCartItem.ccrz__Product__c;
        console.log('sflProductID > ' + sflProductID);

        let sfcartId = this.cartId;
        console.log('sfcartId :: ' + sfcartId);

        let sfcartitemID = SaveforLaterCartItem.Id;
        console.log('sfcartitemID :: ' + sfcartitemID);   
        
        if (this.isGuestUser) {
            this.getSaveforLaterCookieByLocation();

            console.log('>> get done');
            console.log('this.saveforlatercookievalue >>' + this.saveforlatercookievalue);

            //Need Tocheck for the core product
            let relatedCoreProduct;
            getRelatedProductByProductId({
                parentProductId : sflProductID,
                storeCountry : this.currentStorelocation
            }).then(coreproresult => {
                console.log('core product details - save forlater - guest > ' + JSON.stringify(coreproresult));                
                if(coreproresult){
                    relatedCoreProduct = coreproresult.Id;
                    console.log('relatedCoreProduct populated bef > ' + relatedCoreProduct);  
                }   
                console.log('relatedCoreProduct populated aft > ' + relatedCoreProduct);
                                
                if (typeof this.saveforlatercookievalue == 'undefined'){
                    console.log('>> in if loop for save for later');

                    let Productlist = [sflProductID];
                    console.log('Productlist' + Productlist);
                                                    
                    if(relatedCoreProduct){
                        Productlist.push(relatedCoreProduct);
                    }
                    console.log('Productlist after core prod addition > ' + JSON.stringify(Productlist));
    
                    //then setcookie 
                    console.log('saveforlater cookie is set ::');
                    /*Added by Malhar Ulhas Agale - for handleing storetoggling - 4/12/2020 */
                    if(this.currentStorelocation == storeUSA){  
                        this.setsaveforlaterCookie('saveforlater', JSON.stringify(Productlist), 7);
                    }else if(this.currentStorelocation == storeCanada){
                        this.setsaveforlaterCookie('saveforlaterCA', JSON.stringify(Productlist), 7);
                    }

                    this.getSaveforLaterCookieByLocation();

                    //fire apex method to delete cartitem for that product
                    if(window.location.pathname == '/CSSNAStore/s/cart'){
                        pubsub.fire('minicartclearevt', {cartclear : true});
                    }                    
                    console.log('deletecart item begin ::');
                    deleteCartItem({
                        cartItemId: sfcartitemID,
                        cartId: sfcartId
                    })
                    .then(result => {                
                        // Clear the user enter values                                        
                        window.console.log('After fire eventresult delte method malhar ===> ' + JSON.stringify(result));                                                         
                        pubsub.fire('fetchcartevt', result);     
                        
                        if(window.location.pathname == '/CSSNAStore/s/cart'){
                            SaveForLaterFetchProductDetails({
                                ProductIDList: this.saveforlatercookievalue,
                                storeCountry : this.currentStorelocation                  
                            }).then(saveforlaterresult => {     
                                let sflguestrespstring;             
                                let sflguestrespparsed;              
                                if(saveforlaterresult.length > 0){
                                    sflguestrespstring = JSON.stringify(saveforlaterresult);             
                                    sflguestrespparsed = JSON.parse(sflguestrespstring);                                        
                                    sflguestrespparsed.forEach(element => {
                                        let currentRetPriceSFL =  element.ProductPrice;
                                        element['modifiedPrice'] = perfixCurrencyISOCode(this.countryCurrencyCode ,currentRetPriceSFL);                                                                         
                                    });
                                }
                                console.log('savefor later result first if > ' + JSON.stringify(sflguestrespparsed));
                                pubsub.fire('saveforlatercartevt', {sentfrom : 'minicart', data : sflguestrespparsed}); 
    
                            }).catch(error => {
                                this.error = error.message;
                                console.log('ERROR -> core product details - save forlater - guest > ' + this.error);
                            }); 
                        }

                        this.isMiniCartLoading = false;                        
                    })
                    .catch(error => {
                        this.error = error.message;
                    });
                    console.log('deletecart item end ::');                     
                    
                }else{
                    console.log('in else condition');
                    this.getSaveforLaterCookieByLocation();

                    let retrivedCookieArray = JSON.parse(this.saveforlatercookievalue);
                    retrivedCookieArray.push(sflProductID);
                    console.log('pushed retrivedCookieArray :: ' + retrivedCookieArray);                    

                    if(relatedCoreProduct){
                        retrivedCookieArray.push(relatedCoreProduct);
                    }
                    console.log('Productlist after core prod addition > ' + JSON.stringify(relatedCoreProduct));        
                    
                    if(this.currentStorelocation == storeUSA){  
                        this.setsaveforlaterCookie('saveforlater', JSON.stringify(retrivedCookieArray), 7);
                    }else if(this.currentStorelocation == storeCanada){
                        this.setsaveforlaterCookie('saveforlaterCA', JSON.stringify(retrivedCookieArray), 7);
                    }
                    
                    this.getSaveforLaterCookieByLocation();

                    console.log('else Method deletecart item begin ::');
                    if(window.location.pathname == '/CSSNAStore/s/cart'){
                       pubsub.fire('minicartclearevt', {cartclear : true});
                    } 
                    deleteCartItem({
                        cartItemId: sfcartitemID,
                        cartId: sfcartId
                    })
                        .then(result => {
                            // Clear the user enter values
                            console.log('In onProductDelete before fire eventresult ===> ' + result);
                            pubsub.fire('fetchcartevt', result);

                            if(window.location.pathname == '/CSSNAStore/s/cart'){
                                SaveForLaterFetchProductDetails({
                                    ProductIDList: this.saveforlatercookievalue,
                                    storeCountry : this.currentStorelocation                  
                                }).then(saveforlaterresult => {
                                    console.log('savefor later result second if > ' + saveforlaterresult);    
                                    let sflguestrespstring;          
                                    let sflguestrespparsed;                                                                  
                                    if(saveforlaterresult.length > 0){
                                        sflguestrespstring = JSON.stringify(saveforlaterresult);   
                                        sflguestrespparsed = JSON.parse(sflguestrespstring);    
                                        sflguestrespparsed.forEach(element => {
                                            let currentRetPriceSFL =  element.ProductPrice;
                                            element['modifiedPrice'] = perfixCurrencyISOCode(this.countryCurrencyCode ,currentRetPriceSFL);                                                                         
                                        });
                                    }
                                    console.log('savefor later result second if > ' + JSON.stringify(sflguestrespparsed));
                                    //pubsub.fire('saveforlatercartevt', sflguestrespparsed); 
                                    pubsub.fire('saveforlatercartevt', {sentfrom : 'minicart', data : sflguestrespparsed}); 
        
                                }).catch(error => {
                                    this.error = error.message;
                                    console.log('ERROR -> core product details - save forlater - guest > ' + this.error);
                                }); 
                            }

                            this.isMiniCartLoading = false; 
                        })
                        .catch(error => {
                            this.error = error.message;
                        });
                    console.log('else method deletecart item end ::');
                }                

            }).catch(error => {
                this.error = error.message;
                console.log('this.error >>>>> ' + this.error );
            })            

        }else if(!this.isGuestUser){
            this.isMiniCartLoading = true;
            AddProductToSaveforLater({
                storeCountry : this.currentStorelocation,                
                ProductId: sflProductID,
                ProductQuantity: 1,
                dbu_SFL_OR_WL_Value: 'Save For Later',
                storeLanguage : this.sendLocBackToChangeLocTile
            }).then(addedresult => {                
                console.log('Result after the product is added to save for later for loggedin user', JSON.stringify(addedresult));
                if(window.location.pathname == '/CSSNAStore/s/cart'){
                   pubsub.fire('minicartclearevt', {cartclear : true});
                } 
                console.log('else Method deletecart item begin ::');
                deleteCartItem({
                    cartItemId: sfcartitemID,
                    cartId: sfcartId
                })
                .then(result => {
                    //this.isLoading = false;
                    // Clear the user enter values
                    window.console.log('In onProductDelete before fire eventresult ===> ' + JSON.stringify(result));
                    pubsub.fire('fetchcartevt', result);


                    if(window.location.pathname == '/CSSNAStore/s/cart'){

                        FetchLoggedInUserSaveforLaterItems({
                            dbu_SFL_OR_WL_Value: 'Save For Later',
                            storeCountry : this.currentStorelocation,
                            storeLanguage : this.sendLocBackToChangeLocTile
                        }).then(retrivedResult => {                            
                            let serverresp;
                            let deJsonisedserverresp;
                            if(retrivedResult.length > 0 ){                            
                                serverresp = JSON.stringify(retrivedResult);
                                deJsonisedserverresp = JSON.parse(serverresp);                                 
                                deJsonisedserverresp.forEach(element => {
                                    let currentRetPriceSFL =  element.ProductPrice;
                                    element['modifiedPrice'] = perfixCurrencyISOCode(this.countryCurrencyCode ,currentRetPriceSFL);
                                });
                            } 
                            console.log('Result after perfoming fetch all saveforlater items for loggedin user', JSON.stringify(deJsonisedserverresp));
                            // pubsub.fire('saveforlatercartevt', deJsonisedserverresp);  
                            pubsub.fire('saveforlatercartevt', {sentfrom : 'minicart', data : deJsonisedserverresp});                                                        
                        }).catch(error => {
                            this.error = error.message;
                            console.log('this.error >>>>> ' + this.error );
                        });

                    }


                    this.isMiniCartLoading = false;
                }).catch(error => {
                    this.error = error.message;
                    console.log('this.error > ' + this.error);
                });                
            })  

        }

    }

    /*Navigate to Product URL begin */
    navigateToProductPage(event) {
        console.log(event.target.getAttribute('data-id'));
        this.navigateToProdURL = event.target.getAttribute('data-id');
        this.productName = event.target.getAttribute('data-name');
        console.log('event.target.getAttribute(data-id)'+event.target.getAttribute('data-name'));
        let prodname = this.productName;

        if(prodname.includes('/')){
            prodname = prodname.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
          }
         
        
          this.productName  = prodname;  
          console.log('productName > ' + this.productName);
    }

    get productURL() {
        let urlString = window.location.origin;


        return urlString + communityName + 'product/'+this.navigateToProdURL +'/'+this.productName+'/?store='+this.sendLocBackToChangeLocTile;
    }
    /*Navigate to Product URL end */
}