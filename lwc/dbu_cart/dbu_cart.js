import {LightningElement, track, wire} from 'lwc';
import pubsub from 'c/pubsub';
import myResource from '@salesforce/resourceUrl/cloudMVP';
import fetchLstCartItemsByCartIdAfterQuantityUpdate from '@salesforce/apex/dbu_CartCtrl.fetchLstCartItemsByCartIdAfterQuantityUpdate';
import fetchLstCartItemsAfterDelete from '@salesforce/apex/dbu_CartCtrl.fetchLstCartItemsAfterDelete';
import AddProductToSaveforLater from '@salesforce/apex/dbu_SaveForLatetGeneric.AddProductTo_WishList_or_SaveForLater_forLoggedInUser';
import FetchLoggedInUserSaveforLaterItems from '@salesforce/apex/dbu_SaveForLatetGeneric.fetchLoggedInUserWishlistItems';
import AddAllProductsToCartfromSaveforlaterGuestUser from '@salesforce/apex/dbu_SaveForLatetGeneric.AddAllProductsToCartfromSaveforlater_GuestUser';
import returnNonCoreProducts from '@salesforce/apex/dbu_SaveForLatetGeneric.returnNonCoreProducts';
import updateShippingMethod from '@salesforce/apex/dbu_CartCtrl.updateShippingMethod';
import checkInventoryAPIInterval from '@salesforce/apex/dbu_CartCtrl.checkInventoryAPIInterval';
import checkMarketingEmailFlag from '@salesforce/apex/dbu_CartCtrl.checkMarketingEmailFlag';
import tagIcon from '@salesforce/resourceUrl/dbu_tag';
import {NavigationMixin} from 'lightning/navigation';
import updateCartItemShopCart from '@salesforce/apex/dbu_CartCtrl.updateCartItemShopCart';
import deleteIc from '@salesforce/resourceUrl/dbu_delete';
import deleteCartItemOnShopCart from '@salesforce/apex/dbu_CartCtrl.deleteCartItem';
import isGuest from '@salesforce/user/isGuest';
import getCrateMetaData from '@salesforce/apex/dbu_ProductCtrl.getCrateMetaData';
import AddProductToCartFromSaveForLaterGuestUser from '@salesforce/apex/dbu_SaveForLatetGeneric.AddProductToCart_From_SaveForLater_GuestUser';
import GetCartProducts from '@salesforce/apex/dbu_SaveForLatetGeneric.GetCartProducts';
import AddProductToCartFromWishList from '@salesforce/apex/dbu_SaveForLatetGeneric.AddProductToCart_From_WishList';
import SaveForLaterFetchProductDetails from '@salesforce/apex/dbu_SaveForLatetGeneric.fetchProductDetailsByProductID';
import DeleteProductsFromSaveforLater from '@salesforce/apex/dbu_SaveForLatetGeneric.deleteDefaultWishlist_WishListItem_OR_SaveforLaterItem';
import getcurrentCartItemCartID from '@salesforce/apex/dbu_SaveForLatetGeneric.getcurrentCartItemCartID';
import getRelatedProductByProductId from '@salesforce/apex/dbu_CallCCWishListApi.getRelatedProductByProductId';
import fetchCartId from '@salesforce/apex/dbu_CartCtrl.fetchCartId';
import { perfixCurrencyISOCode } from 'c/serviceComponent';
import dbu_freeShipping from '@salesforce/resourceUrl/dbu_freeShipping';
import progressbar from '@salesforce/resourceUrl/progressbar';
import { loadStyle } from 'lightning/platformResourceLoader';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import clearanceIcon from '@salesforce/resourceUrl/dbu_icons';
import getLabels from 'c/dbu_custLabels'//CECI-1097 Cart code optimization

export default class Dbu_cart extends NavigationMixin(LightningElement) {
    @track imageUrl = myResource;
    @track cartDetails;
    @track cartId;
    @track isLoading = true;
    @track cartItemId;
    @track baseURL;
    @track isEmptyCart = false;
    @track termsandconditions;
    @track footerbannercookiestatus = false;
    @track cartDiscountAmount = '0.00';
    @track cartOriginalAmount = '0.00';
    @track cartSubtotalAmount = '0.00';
    @track cartTotalAmount = '0.00';
    @track productDetails;
    @track showCouponPlaceholder = true;
    @track removeCouponPlaceHolder = false;
    @track showInvalidCouponPlaceolder = false;
    @track isGuestUser = isGuest;
    @track currentStorelocation;
    @track saveforlaterProductList = [];
    @track saveforlatercookievalue;
    @track saveForLaterNotLoaded = true;
    @track saveForLaterItemsAvailable = false;
    @track loggeInSFLData;
    @track showSFLItemsLoggedIN = false;
    @track saveForLaterEventData;
    @track navigateToProdURL;
    @track successfullyAddedTocart = false;
    @track alreadyExistsInCart = false;
    @track displayMessage;
    @track isSFLmessageModalOpen = false;
    @track isOpenModelForGuestCart = false;
    @track navToCheckoutForGuest = false;
    @track showCookiePolicyModel = false;
    @track sendLocBackToChangeLocTile;
    @track orderSummaryDisplay=false;
    @track countryCurrencyCode;
    @track currentItemChangedQuantityId;
    @track currentItemChangedQuantity
    @track productName;
    @track homePageUrlWithStore;
    @track shipToStoreAddress = false;
    @track dropOffAtStoreAddress = false;
    @track displayFreeShipping;
    @track cartValuePercentage ;
    @track remainingValue;
    @track freeShippingRemainingValue;
    @track freeShippingImage = dbu_freeShipping;
    @track maxLimit;
    @track displayShippingMessage;
    @track costShippedProduct;
    @track isPartialAvailability;
    @track pickUpAddress;
    @track EstimatedShippingAmount;
    @track tagIconVar = tagIcon;
    @track isPickupOnlyErrorMsg = false;
    @track shippingPolicyURLredirect;
    @track proceedToCheckoutBtnDisabled;
    /* Aakriti CECI748 start */
    @track enableMarketingEmail = false;// Aakriti CECI-933 may30 changed from true
    @track isCanadaStore = false;
    /* Aakriti CECI748 end */
    /*Aakriti CECI-693*/
    @track showFinalQtyExceedError = false;
    @track cartEmailSubscriptionVal;
    @track clearanceImg = clearanceIcon+'/dbu_icons/dbu_saletag.svg';
    @track saleTag;
    @track allLabels = getLabels.labels;//CECI-1097 Cart code optimization
    @track IsCrateProd;
    get ScreenLoaded() {
        return this.isLoading;
    }
    updateShipMethod(){
        let cartdata = JSON.stringify(this.cartDetails);
        this.cartDetails = JSON.parse(cartdata);
        this.cartDetails.forEach(element => {
            element.lstCartItem.forEach(item => {
                if(item.cartItem.Id == this.cartItemId){
                    this.handleQuantityUpdateFnForShipMethod(item,true);
                }
            })
        });  
    }
    shipTo(event){
        invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Select another store', eventAction : 'Pickup from store - cart page'});                      
        let isShipTo;
        if(event.target.value === 'shipToStore'){
                this.dropOffAtStoreAddress = false;
                this.shipToStoreAddress = true;
                this.pickUpAddress = null;
                isShipTo = true;
            }else if(event.target.value === 'dropOffAtStore' || event.target.value === 'dropOffAtStoreForChangeStore'){
                if(this.cartDetails[0].cartDetails.dbu_Pick_Up_From_Store__r === undefined || this.cartDetails[0].cartDetails.dbu_Pick_Up_From_Store__r === 'undefined' || event.target.value === 'dropOffAtStoreForChangeStore'){
                    this.dropOffAtStoreAddress = true;
                }
                this.shipToStoreAddress = false;
                isShipTo = false;
            }
            this.cartItemId = event.target.dataset.id;
            let isChangeStore = event.target.value;
            if(this.dropOffAtStoreAddress && (this.cartDetails[0].cartDetails.dbu_Pick_Up_From_Store__r === undefined || this.cartDetails[0].cartDetails.dbu_Pick_Up_From_Store__r === 'undefined' || isChangeStore === 'dropOffAtStoreForChangeStore')){
                this.template.querySelector("c-dbu_map-in-modal").isShowMap(this.cartId,event.target.dataset.id,isShipTo,event.target.dataset.productid);
            }else{
                    this.updateShippingMethodFn(event);
            }
        }

    fetchPickUpAddress(event){
        this.pickUpAddress = event.detail;
        if(this.pickUpAddress == null || this.pickUpAddress == undefined){
            this.updateShipMethod();
        }else{
            this.fetchCartDetailsFn('cart');
        }
    }

    connectedCallback() {
        let locationURL = window.location.href;
        this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
        pubsub.fire('sendLocToStore', this.sendLocBackToChangeLocTile);
        if(this.sendLocBackToChangeLocTile == this.allLabels.storeUSA || this.sendLocBackToChangeLocTile == undefined || this.sendLocBackToChangeLocTile == null || this.sendLocBackToChangeLocTile == ''){
            this.currentStorelocation = this.allLabels.storeUSA;
            this.countryCurrencyCode = this.allLabels.currencyCodeUSA;
            this.sendLocBackToChangeLocTile = this.allLabels.storeUSA;
        }else if(this.sendLocBackToChangeLocTile == this.allLabels.storeCA || this.sendLocBackToChangeLocTile == this.allLabels.storeCAF){
            this.currentStorelocation = this.allLabels.storeCanada;
            this.countryCurrencyCode = this.allLabels.currencyCodeCanada;
            this.isCanadaStore = true;
        }
        if (this.isGuestUser) {  
            this.getSaveforLaterCookieByLocation();
        }
        this.imageUrl = myResource + '/images/CumminsEngine.jpg';
        this.deleteIcon = deleteIc;
        let urlString = window.location.origin;
        this.maxLimit = parseInt(this.allLabels.dbu_ShippingCost_TotalAmout);
        this.baseURL = urlString + this.allLabels.communityName;
        this.homePageUrlWithStore = this.baseURL + '?store='+this.sendLocBackToChangeLocTile;
        this.termsandconditions = this.baseURL + 'termsandconditions?store=' + this.sendLocBackToChangeLocTile;
        this.shippingPolicyURLredirect = this.baseURL + 'shipping-policy?store=' + this.sendLocBackToChangeLocTile;
        this.register();
        if (this.isGuestUser) {
            this.checkForSaveforLaterSessionvalue();
        } else {
            fetchCartId({
                storeCountry : this.currentStorelocation
            })
                .then(result => {
                    this.cartId = result;
                    this.fetchLstCartItemsByCartIdFn();
                    this.error = undefined;
                })
                .catch(error => {
                    this.error = error.message;
                });
        }
        this.fetchLstCartItemsByCartIdFn();
        this.isLoading = false;
       }

    @wire(getCrateMetaData, {
        urlParam: '$cartId'
    })
    getCrateMetaData({ error, data }) {
        if (data) {
            this.cratemetadata = data;
            this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.cratemetadata = undefined;
        }
    }

    handleEventLoc(event) {
        this.sendLocBackToChangeLocTile = event;
        if(this.sendLocBackToChangeLocTile == this.allLabels.storeUSA){
            this.currentStorelocation = this.allLabels.storeUSA;
        }else if(this.sendLocBackToChangeLocTile == this.allLabels.storeCA || this.sendLocBackToChangeLocTile == this.allLabels.storeCAF){
            this.currentStorelocation = this.allLabels.storeCanada;
        }
        pubsub.fire('sendLocToStore', this.sendLocBackToChangeLocTile);
        pubsub.fire('sendLocToCumminsLogoLWC', this.sendLocBackToChangeLocTile);
    }

    navigatetotermsandconditions(){
    invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open Terms & Conditions');      
    }
    get gototermsandconditionsurl(){
    return this.termsandconditions;
    }
    navigateToContinueToShoping(){
    invokeGoogleAnalyticsService('CONTINUE SHOPPING CLICKS', {eventname : 'Proceed to checkout - Cart Page'});
    }
    get docontinueshopping(){
    return this.homePageUrlWithStore;
    }

    handleClickGoToCheckout(event) {
        if(this.enableMarketingEmail != this.cartEmailSubscriptionVal){
            checkMarketingEmailFlag({ cartId: this.cartId, dbuOPTEmailNotification: this.enableMarketingEmail })
            .then(result =>
                { this.error = undefined; })
            .catch(error =>
                { this.error = error;
            })
        }
        
        checkInventoryAPIInterval({
            cartId: this.cartId,
        }).then(data => {
            let isTimeExceeded;
            let isPickupItemButAddressNot;
            this.isPickupOnlyErrorMsg = false;
            for (let key in data) {
                if(key == 'isPickupItemButAddressNot'){
                    isPickupItemButAddressNot = data[key];
                }else if(key == 'isTimeExceeded'){
                    isTimeExceeded = data[key];
               }
             }
            if(isPickupItemButAddressNot){
                this.closeModelForGuestCart();
                this.isPickupOnlyErrorMsg = true;
                return false
            }else if(isTimeExceeded){
                this.closeModelForGuestCart();
                this.isLoading = true;
                this.fetchLstCartItemsByCartIdFn();
                return false;
            }else{
                invokeGoogleAnalyticsService('PROCEED TO CHECKOUT BUTTON CLICK', this.cartDetails);    
                let redirectToCheckoutURL = this.baseURL + 'checkout?cartId=' + this.cartId + '&store=' + this.sendLocBackToChangeLocTile;
                window.location.href = redirectToCheckoutURL;
            }
        }).catch(
            error => {
                this.error = error.message;
        })
    }
    //CECI-1097 Cart code optimization start
    setPricingforSaveforlater(){
        var saveForLaterArr = this.isGuestUser ? this.saveforlaterProductList : this.loggeInSFLData;
        if(saveForLaterArr.length > 0 ){
            saveForLaterArr.forEach(element => {
                if(element.ProductPrice != null){
                    var currentRetPriceSFL =  element.ProductPrice;
                    if(element.originalPrice != undefined&& element.originalPrice != null && element.originalPrice > 0 ) {
                            var orgProdPrice = element.originalPrice;
                        }
                        if(orgProdPrice != currentRetPriceSFL && orgProdPrice > currentRetPriceSFL){
                            element['isOriginalPrice'] = true;
                            element['originalprice'] = perfixCurrencyISOCode(this.countryCurrencyCode, orgProdPrice);
                        }else{
                            element['isOriginalPrice'] = false;
                        }
                        if(element.discountPercentage !=undefined && element.discountPercentage > 0) {
                            element['discountPercentage'] = element.discountPercentage;
                        } 
                    element['modifiedPrice'] = perfixCurrencyISOCode(this.countryCurrencyCode ,currentRetPriceSFL);
                }
            });
            if(this.isGuestUser){
                this.saveForLaterItemsAvailable = true;
                this.saveforlaterProductList = saveForLaterArr;
            }
            else{
                this.showSFLItemsLoggedIN = true;
                this.loggeInSFLData = saveForLaterArr;
            }
        }    
        else{
            if(this.isGuestUser){
                this.saveForLaterItemsAvailable = false;
            }
            else{
                this.showSFLItemsLoggedIN = false;
            }
        }
    }
    fetchLstCartItemsAfterDeleteFn(){
        fetchLstCartItemsAfterDelete({
            cartId: this.cartId,
            cart: 'cart'
        }).then(resultone => {
            pubsub.fire('fetchcartevt', resultone);
            /*Logic To display empty cart modal */
            if (resultone[0].lstCartItem.length == 0) {
                this.EstimatedShippingAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
                this.isEmptyCart = true;
                this.cartDetails = undefined;
                this.template.querySelector('.emptyCart').classList.add('show');
                this.displayShippingMessage = false;
                this.cartValuePercentage = 0;
            }else{
                this.isEmptyCart = false;
                this.template.querySelector('.emptyCart').classList.remove('show');
            }
            /*Logic To display empty cart modal */
        }).catch(error => {
            this.error = error.message;
             });
    }
    FetchLoggedInUserSaveforLaterItemsFn(){
        FetchLoggedInUserSaveforLaterItems({
            dbu_SFL_OR_WL_Value: 'Save For Later',
            storeCountry : this.currentStorelocation,
            storeLanguage : this.sendLocBackToChangeLocTile
        }).then(result => {
            if(result){
                this.isLoading = false;
                this.checkAllowedQtyFn(); /*Aakriti CECI-693*/
                let serverresp = JSON.stringify(result);
                this.loggeInSFLData = JSON.parse(serverresp);
                this.setPricingforSaveforlater();
            }
        }).catch(error => {
            this.error = error.message;
            })
    }
    SaveForLaterFetchProductDetailsFn(){
        SaveForLaterFetchProductDetails({
            ProductIDList: this.saveforlatercookievalue,
            storeCountry : this.currentStorelocation                  
        }).then(result => {
            this.isLoading = false;
            let serverResponse = JSON.stringify(result);
            this.saveforlaterProductList = JSON.parse(serverResponse);
            this.setPricingforSaveforlater();
        }).catch(error => {
            this.error = error.message;
        });
    }
    setQtyArr(item){
        let quantityArray = [];
        if(item.qtyAvailable < 10){  
            let c = item.qtyAvailable;
            for (let index = 1; index <= item.qtyAvailable; index++) {
                    quantityArray.push({
                        label: index,
                        value: index
                    });
            }
        }else if (item.qtyAvailable >= 10){
            for (let index = 1; index <= 9; index++) {
                if(index == 9){
                    quantityArray.push({
                        label: '9+',
                        value: '9+'
                    });
                }else{
                    quantityArray.push({
                        label: index,
                        value: index
                    });
                }
            }
        }
        return quantityArray;
    }
    fetchLstCartItemsFunction(cartval){
        fetchLstCartItemsByCartIdAfterQuantityUpdate({
            cartId: this.cartId,
            cart: cartval
        })
            .then(result1 => {
                this.isPickupOnlyErrorMsg = false;
                pubsub.fire('fetchcartevt', result1);
                this.isPartialAvailability = result1[0].isPartialAvailability;
                this.checkoutButtonDisabilityCheck();
                let cartdata = JSON.stringify(result1);
                this.cartDetails = JSON.parse(cartdata);
                this.cartDetails.forEach(element => {
                    element.lstCartItem.forEach(item => {
                        item['quantityOptions'] = this.setQtyArr(item);
                        this.handleQuantityUpdateFnForShipMethod(item,false);
                    })
                });
                this.isLoading = false;
                this.checkAllowedQtyFn(); /*Aakriti CECI-693*/
            }).catch(error=>{
                this.error = error.message;
                this.isLoading = false;
            });
    }
    setCartAmountDetailsFn(){
        //************* code with decimals and currency starts*/
                //fixes for this (92.40000000000000000000000000000000000002) issue
        let shipingAmount = this.cartDetails[0].shippingAmount;
        this.EstimatedShippingAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,shipingAmount);
         this.costShippedProduct = this.cartDetails[0].costShippedProduct;
         if( this.costShippedProduct > 0 &&  this.costShippedProduct < this.maxLimit){
             this.displayFreeShipping = false;
             this.remainingValue = ((Math.round((this.maxLimit- this.costShippedProduct)*100) / 100).toFixed(2)) * 1;
             this.freeShippingRemainingValue = perfixCurrencyISOCode(this.countryCurrencyCode,this.remainingValue);
             this.cartValuePercentage = (this.costShippedProduct/this.maxLimit)*100;  //this.costShippedProduct;
              this.displayShippingMessage = true;
         }
         else if(this.costShippedProduct == 0){
             this.displayShippingMessage = false;
             this.cartValuePercentage = 0;
         }
         else{
             this.cartValuePercentage = 100;  //this.maxLimit;    
             this.displayFreeShipping = true;
              this.displayShippingMessage = true;
         } 
        let localcartOriginalAmount = this.cartDetails[0].originalCartAmt;
        localcartOriginalAmount = ((Math.round(localcartOriginalAmount * 100) / 100).toFixed(2)) * 1;        
        let localcartSubtotalAmount = this.cartDetails[0].subtotalAmount;
        localcartSubtotalAmount = ((Math.round(localcartSubtotalAmount * 100) / 100).toFixed(2)) * 1;        
        let localcartTotalAmount = this.cartDetails[0].totalAmount;
        if(this.cartDetails[0].totalShippingAmount > 0 && localcartTotalAmount > 0){
            localcartTotalAmount = localcartTotalAmount - this.cartDetails[0].totalShippingAmount;
        }
        if(shipingAmount > 0 && localcartTotalAmount > 0){
        localcartTotalAmount = localcartTotalAmount + shipingAmount;
        }
        if(localcartTotalAmount > 0){
            localcartTotalAmount = localcartTotalAmount - this.cartDetails[0].taxAmount;
            }
        localcartTotalAmount = ((Math.round(localcartTotalAmount * 100) / 100).toFixed(2)) * 1;
        let localcartDiscountAmount = this.cartDetails[0].totalCartDiscount;
        localcartDiscountAmount = ((Math.round(localcartDiscountAmount * 100) / 100).toFixed(2)) * 1;
        this.cartOriginalAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,localcartOriginalAmount);                        
        this.cartDiscountAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,localcartDiscountAmount);                            
        this.cartSubtotalAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,localcartSubtotalAmount);                        
        this.cartTotalAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,localcartTotalAmount);   
    }
    setCartItemPriceFn(item){
        if(item.cartItem.ccrz__Price__c != null) {
            var currentRetPrice =  item.cartItem.ccrz__Price__c;
            if(item.cartItemProductDetailWrapper.originalPrice != undefined 
                    && item.cartItemProductDetailWrapper.originalPrice != null 
                    && item.cartItemProductDetailWrapper.originalPrice > 0)
                var originalProdPrice = item.cartItemProductDetailWrapper.originalPrice;
            if((currentRetPrice == originalProdPrice) || (item.cartItemProductDetailWrapper.discountPercentage == 0 || originalProdPrice == null || originalProdPrice == undefined || originalProdPrice < currentRetPrice)){
                item['isOriginalPrice'] = false; 
            }
            else if(item.cartItemProductDetailWrapper.originalPrice > item.cartItem.ccrz__Price__c) {
                item['isOriginalPrice'] = true;
                item['originalPrice'] = perfixCurrencyISOCode(this.countryCurrencyCode,originalProdPrice);
            }
        }
        item['formatedUnitPrice'] = perfixCurrencyISOCode(this.countryCurrencyCode ,currentRetPrice);
        if(item.cartItemProductDetailWrapper.discountPercentage > 0) {
            item['discountPercentage'] = item.cartItemProductDetailWrapper.discountPercentage;
        }   
        return item;
    }
    checkoutButtonDisabilityCheck(){
        if(this.showFinalQtyExceedError == true || this.isPartialAvailability == true){
            this.proceedToCheckoutBtnDisabled = true;
        }
        else{
            this.proceedToCheckoutBtnDisabled = false;
        }
    }
    //CECI-1097 Cart code optimization end
    renderedCallback() {
         Promise.all([
            loadStyle(this, progressbar)
        ]).then(() => {
            }).catch(error => {
        });
        if (this.saveForLaterNotLoaded && this.isGuestUser) {        
            this.getSaveforLaterCookieByLocation();
            if (typeof this.saveforlatercookievalue !== "undefined") {
                this.SaveForLaterFetchProductDetailsFn();
            }            
        }
        if (this.saveForLaterNotLoaded && !this.isGuestUser) {
            this.FetchLoggedInUserSaveforLaterItemsFn();
        }  
        this.saveForLaterNotLoaded = false;      
    }
   
    deleteSaveForLaterGuest(event) {
        this.isLoading = true;
        let ProductIdToDelete = event.target.getAttribute('data-id');
        let productprice = event.target.getAttribute('data-curproprice');
        let productname = event.target.getAttribute('data-curproname');
        invokeGoogleAnalyticsService('REMOVE FROM SAVEFORLATER', {id: ProductIdToDelete, price: productprice, name:productname, storeLanguage : this.sendLocBackToChangeLocTile});
        this.getSaveforLaterCookieByLocation();
        let relatedCoreProductId;
        getRelatedProductByProductId({
            parentProductId : ProductIdToDelete,
            storeCountry : this.currentStorelocation
        }).then(coreprodresult => {          
                if(coreprodresult){
                    relatedCoreProductId = coreprodresult.Id;
                }  
                let ProductIDarray = JSON.parse(this.saveforlatercookievalue);  
                ProductIDarray = [...new Set(ProductIDarray)];
                let index = ProductIDarray.indexOf(ProductIdToDelete);
                if (index > -1) {
                    ProductIDarray.splice(index, 1);
                }
                if(relatedCoreProductId){
                    let index = ProductIDarray.indexOf(relatedCoreProductId);
                    if (index > -1) {
                        ProductIDarray.splice(index, 1);
                    }
                }                            
                if(this.currentStorelocation == this.allLabels.storeUSA){
                    this.setsaveforlaterCookie('saveforlater', JSON.stringify(ProductIDarray), 7);              
                }    
                else if(this.currentStorelocation == this.allLabels.storeCanada){
                    this.setsaveforlaterCookie('saveforlaterCA', JSON.stringify(ProductIDarray), 7);              
                }                      
                this.getSaveforLaterCookieByLocation();
                this.SaveForLaterFetchProductDetailsFn();
            }).catch(error => {
                this.error = error.message;
                });
    }

    deleteSaveForLaterLoggedIn(event) {
        this.isLoading = true;
        let ProductIDtoDelete = event.target.getAttribute('data-id');       
        let productprice = event.target.getAttribute('data-curproname');
        let productname = event.target.getAttribute('data-curproname');
        invokeGoogleAnalyticsService('REMOVE FROM SAVEFORLATER', {id: ProductIDtoDelete, price: productprice, name: productname, storeLanguage : this.sendLocBackToChangeLocTile});        
        DeleteProductsFromSaveforLater({
            ProductId: ProductIDtoDelete,
            SFL_OR_WL_Value: 'Save For Later',
            storeCountry : this.currentStorelocation
        }).then(deleteResult => {
            if (deleteResult) {
                this.FetchLoggedInUserSaveforLaterItemsFn();
            }
        }).catch(error => {
            this.error = error.message;
        });
    }

    navigateToProductPage(event) {
        this.navigateToProdURL = event.target.getAttribute('data-id');
        this.productName = event.target.getAttribute('data-name');
        if(this.productName != null){
            invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Naviate to the ' + this.productName + ' product page');
          }
          let currproductname = this.productName;
          if(currproductname.includes('/')){
            currproductname = currproductname.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
           }  
           this.productName = currproductname;                  
    }

    get productURL() {
        let urlString = window.location.origin;
        return urlString + this.allLabels.communityName +'product/'+this.navigateToProdURL +'/'+ this.productName+'/?store='+this.sendLocBackToChangeLocTile;
    }

    handleToSignInLinkClick(){        
        invokeGoogleAnalyticsService('SIGNIN LINK CLICK', 'IAM');                
    }

    get navigateToSignInURL(){
        return this.allLabels.loginInURL;
    }    

    
    googleAnalyticsCartOperations(source, informationData){
        if(source === 'AddToCart'){
          invokeGoogleAnalyticsService('ADD TO CART', informationData);
        }
        else if(source == 'RemoveFromCart')
          invokeGoogleAnalyticsService('REMOVE FROM CART', informationData);
        if(source === 'AddAllToCartsfl'){
          invokeGoogleAnalyticsService('ADD ALL TO CART SAVE FOR LATER', informationData);
        }
        if(source === 'AddToSaveforlater'){
          invokeGoogleAnalyticsService('ADD TO SFL CART PAGE', informationData);
        }          
    }      

    saveforlaterAddProductToCart(event) {
        this.isLoading = true;
        //CECI-987 modified for addtocart GTM trigger from save for later
        let productID = event.target.getAttribute('data-id');
        let productSKU = event.target.getAttribute('data-productid');
        let currproductname = event.target.getAttribute('data-productname');
        let currproductprice = event.target.getAttribute('data-productprice');
        let productbrand = event.target.getAttribute('data-productbrand');/*CECI-958 GTM Events*/
        let productcategory = event.target.getAttribute('data-productcategory');/*CECI-958 GTM Events*/
        let ProductQuantity = 1;
        this.displayMessage = "";
        this.getfooterbannerCookie('footerBanner');          
        //check if the product is a crate Products or Not
        let PrdList = [productID];

        SaveForLaterFetchProductDetails({
            ProductIDList: JSON.stringify(PrdList),
            storeCountry : this.currentStorelocation                  
        }).then(res => {
            let IsCrateProd;
            for (let i = 0; i < res.length; i++) {
                if (res[i].IsCrateProductCheck == true) {
                    IsCrateProd = true;
                } else if (res[i].IsCrateProductCheck == false) {
                    IsCrateProd = false;
                }
            }
            if (IsCrateProd == false) {   
                /*CECI-958 GTM Events removed additional addtocart event*/         
                //For Guest User
                if (this.isGuestUser) {
                    let ProductMap = [];
                    ProductMap.push({ id: productID, Quantity: ProductQuantity });
                    //Check if Product present In the cart
                    this.checkForSaveforLaterSessionvalue();
                    //check if product has a related coreProduct or not.
                    let relatedCoreProductId;
                    getRelatedProductByProductId({
                        parentProductId : productID,
                        storeCountry : this.currentStorelocation
                    }).then(coreprodresult => {
                            if(coreprodresult){
                                relatedCoreProductId = coreprodresult.Id;
                            }  
                            GetCartProducts({
                                CurrentCartID: this.cartId
                            }).then(getcartprodresult => {
                                let CartProductIds = getcartprodresult;
                                //if product in cart
                                if (CartProductIds.includes(productID)) {
                                    this.isLoading = false;
                                    this.displayMessage = 'Product already exists in the cart';
                                    this.recordUpdate = this.displayMessage;
                                }
                                if (!CartProductIds.includes(productID)) {
                                    //Get save for later cookie value
                                    this.getSaveforLaterCookieByLocation(); 
                                    //Parse and store the save for later values in variables
                                    let ProductIDarray = JSON.parse(this.saveforlatercookievalue);
                                    ProductIDarray = [...new Set(ProductIDarray)];
                                    //Removing the Product from the array
                                    let index = ProductIDarray.indexOf(productID);
                                    if (index > -1) {
                                        ProductIDarray.splice(index, 1);
                                    }
                                    //check if relatedCoreProductId is present
                                    if(relatedCoreProductId){
                                        let index = ProductIDarray.indexOf(relatedCoreProductId);
                                        if (index > -1) {
                                            ProductIDarray.splice(index, 1);
                                        }
                                    }
                                    AddProductToCartFromSaveForLaterGuestUser({
                                        dbu_SFL_OR_WL_Value: 'Save For Later',
                                        productqty: JSON.stringify(ProductMap),
                                        GuestUserCartId: this.cartId,
                                        storeCountry : this.currentStorelocation
                                    }).then(result => {
                                        this.cartDetails = undefined;
                                        this.fetchLstCartItemsAfterDeleteFn(); 
                                    }).catch(error => {
                                        this.error = error.message;
                                        });
                                    if(this.currentStorelocation == this.allLabels.storeUSA){
                                        this.setsaveforlaterCookie('saveforlater', JSON.stringify(ProductIDarray), 7);                                
                                    }    
                                       else if(this.currentStorelocation == this.allLabels.storeCanada){
                                        this.setsaveforlaterCookie('saveforlaterCA', JSON.stringify(ProductIDarray), 7);                                                                  
                                    }     
                                    this.getSaveforLaterCookieByLocation();
                                   
                                    this.SaveForLaterFetchProductDetailsFn();
                                    this.displayMessage = 'Product is Added to Cart Successfully';
                                    this.recordUpdate = this.displayMessage;
                                }
                                this.isSFLmessageModalOpen = true;
                                this.successfullyAddedTocart = false;
                                this.alreadyExistsInCart = false;
                            })
                        }).catch(error => {
                            this.error = error.message;
                            });
                }
                if (!this.isGuestUser) {
                    let ProductMap = [];
                    ProductMap.push({ id: productID, Quantity: ProductQuantity });
                    AddProductToCartFromWishList({
                        dbu_SFL_OR_WL_Value: 'Save For Later',
                        productqty: JSON.stringify(ProductMap),
                        storeCountry : this.currentStorelocation,
                        storeLanguage : this.sendLocBackToChangeLocTile
                    }).then(SFLaddToCartresult => {
                         if (SFLaddToCartresult.PAddedToC.length > 0) {
                            this.successfullyAddedTocart = true;
                            this.cartDetails = undefined; //added by MALHAR 14-12-2021   
                            this.fetchLstCartItemsAfterDeleteFn(); 
                           }
                        if (SFLaddToCartresult.PExisting.length > 0) {
                            this.alreadyExistsInCart = true;
                            }
                        if (this.successfullyAddedTocart == true && this.alreadyExistsInCart == false) {
                            this.displayMessage = 'Product is Added to Cart Successfully';
                            this.isSFLmessageModalOpen = true;
                            this.recordUpdate = this.displayMessage;
                            this.successfullyAddedTocart = false;
                            this.alreadyExistsInCart = false;
                        } else if (this.successfullyAddedTocart == false && this.alreadyExistsInCart == true) {
                            this.displayMessage = 'Product already exists in the cart';
                            this.isSFLmessageModalOpen = true;
                            this.recordUpdate = this.displayMessage;
                            this.successfullyAddedTocart = false;
                            this.alreadyExistsInCart = false;
                        }
                        this.FetchLoggedInUserSaveforLaterItemsFn();
                        this.isLoading = false;
                    }).catch(error => {
                        this.error = error.message;
                         })
                }
                //CECI-987 added addtocart GTM trigger from save for later 
                setTimeout(() => {
                    if(this.displayMessage == 'Product is Added to Cart Successfully'){
                        this.googleAnalyticsCartOperations('AddToCart', {ProductType : 'Normal', unitPrice : currproductprice, quantity : ProductQuantity, Name : currproductname, id : productSKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.currentStorelocation, cartOperation : 'AddToCart', originalProductPrice : null,cartId : this.cartId, Brand: productbrand, Category: productcategory});/*CECI-958 GTM Events*/
                    }
                }, 7000);
            }
            if (IsCrateProd == true) {
                //CECI-987 removed addtocart GTM trigger for Crate Engine                        
                this.isLoading = false;
                let urlStr = window.location.origin;
                let retProductURL = urlStr + this.allLabels.communityName +'product/'+productID +'/'+ this.productName;
                window.location.href = retProductURL; 
            }
        }).catch(error => {
            this.error = error.message;
             });
    }
         
    SaveForLaterhandleAddallItemsToCart(){
        this.isLoading = true;
        let beforeAddAll = this.isGuestUser ? this.saveforlaterProductList : this.loggeInSFLData;//CECI-987 added for addtocart GTM trigger for add all from save for later
        if (this.isGuestUser) {
            this.checkForSaveforLaterSessionvalue();           
            this.getSaveforLaterCookieByLocation();       
            this.googleAnalyticsCartOperations('AddAllToCartsfl', {sfldata : this.saveforlaterProductList, cartid : this.cartId, prostorelang : this.sendLocBackToChangeLocTile, proStoreCountry : this.currentStorelocation});
            returnNonCoreProducts({
                ProductIDList : this.saveforlatercookievalue
            }).then(result => {
            AddAllProductsToCartfromSaveforlaterGuestUser({
                CurrentCartID : this.cartId,
                SFL_ProductIdsList : JSON.stringify(result),
                storeCountry : this.currentStorelocation
            }).then(addallguestresult =>{
                if(addallguestresult.ProductsAdded.length > 0){
                    let ProductIDarray = JSON.parse(this.saveforlatercookievalue);
                    ProductIDarray = [...new Set(ProductIDarray)];
                    for(let i=0 ; i < addallguestresult.ProductsAdded.length ; i++){
                        let index = ProductIDarray.indexOf(addallguestresult.ProductsAdded[i]);
                        if (index > -1) {
                            ProductIDarray.splice(index, 1);
                        }                          
                    }
                    if(this.currentStorelocation == this.allLabels.storeUSA){
                        this.setsaveforlaterCookie('saveforlater', JSON.stringify(ProductIDarray), 7);                                
                    }    
                       else if(this.currentStorelocation == this.allLabels.storeCanada){
                        this.setsaveforlaterCookie('saveforlaterCA', JSON.stringify(ProductIDarray), 7);                                                                  
                    }      
                    this.cartDetails = undefined;
                    this.fetchLstCartItemsAfterDeleteFn();    
                         //get the product ID Url and price
                         SaveForLaterFetchProductDetails({
                            ProductIDList: JSON.stringify(ProductIDarray),
                            storeCountry : this.currentStorelocation                  
                        }).then(result => {
                            let serverResponse = JSON.stringify(result);
                            this.saveforlaterProductList = JSON.parse(serverResponse);
                            this.setPricingforSaveforlater();                                          
                        }).catch(error => {
                            this.error = error.message;
                        });          
                    this.successfullyAddedTocart = true;
                }else{
                    this.successfullyAddedTocart = false;
                }
                this.alreadyExistsInCart = false;
                if(addallguestresult.prodexisting.length > 0){                    
                    this.alreadyExistsInCart = true;                    
                }
                this.isLoading = false;
                this.checkAllowedQtyFn(); /*Aakriti CECI-693*/
                if (this.successfullyAddedTocart == true && this.alreadyExistsInCart == false) {
                    this.displayMessage = 'Products are Added to Cart Successfully';
                    this.recordUpdate = this.displayMessage;
                    this.isSFLmessageModalOpen = true;
                    this.successfullyAddedTocart = false;
                }
                if (this.successfullyAddedTocart == false && this.alreadyExistsInCart == true) {
                    this.displayMessage = 'Existing cart products and crate engine products are not added to cart';
                    this.recordUpdate = this.displayMessage;
                    this.isSFLmessageModalOpen = true;
                    this.alreadyExistsInCart = false;
                }  
                if (this.successfullyAddedTocart == true && this.alreadyExistsInCart == true) {
                    this.displayMessage = 'Products are added to cart Successfully. Existing cart products and crate engine products are not added to cart.';
                    this.recordUpdate = this.displayMessage;
                    this.isSFLmessageModalOpen = true;
                    this.successfullyAddedTocart = false;
                    this.alreadyExistsInCart = false;
                }                
            }).catch(error =>{
                this.error = error.message;
            })
            }).catch(error => {
                this.error = error.message;            
            });
        }else if(!this.isGuestUser){
            //fetch all saveforlater items for a user
            this.googleAnalyticsCartOperations('AddAllToCartsfl', {sfldata : this.loggeInSFLData, cartid : this.cartId, prostorelang : this.sendLocBackToChangeLocTile, proStoreCountry : this.currentStorelocation});
            FetchLoggedInUserSaveforLaterItems({
                dbu_SFL_OR_WL_Value : 'Save For Later',
                storeCountry : this.currentStorelocation,
                storeLanguage : this.sendLocBackToChangeLocTile
            }).then(loggeinusrItemsFetch => {
                let ProductQuantity = '1';
                let ProductQuantityMap = [];
                for(let i=0 ; i<loggeinusrItemsFetch.length ; i++){
                    ProductQuantityMap.push({ id: loggeinusrItemsFetch[i].ProductID , Quantity: ProductQuantity })
                }
                AddProductToCartFromWishList({
                    dbu_SFL_OR_WL_Value: 'Save For Later',
                    productqty: JSON.stringify(ProductQuantityMap),
                    storeCountry : this.currentStorelocation,
                    storeLanguage : this.sendLocBackToChangeLocTile
                }).then(SFLaddallToCartresult => {
                    if (SFLaddallToCartresult.PAddedToC.length > 0) {
                        this.successfullyAddedTocart = true;   
                        this.cartDetails = undefined;   
                        this.fetchLstCartItemsAfterDeleteFn(); 
                    }
                    if (SFLaddallToCartresult.PExisting.length > 0) {
                        this.alreadyExistsInCart = true;
                    }
                    this.FetchLoggedInUserSaveforLaterItemsFn();
                    this.isLoading = false;  
                    if (this.successfullyAddedTocart == true && this.alreadyExistsInCart == false) {                        
                        this.displayMessage = 'Products are Added to Cart Successfully';
                        this.isSFLmessageModalOpen = true;
                        this.recordUpdate = this.displayMessage;
                        this.successfullyAddedTocart = false;
                    } else if (this.successfullyAddedTocart == false && this.alreadyExistsInCart == true) {
                        this.displayMessage = 'Existing cart products and crate engine products are not added to cart. Please manually add the crate engine products to cart.';
                        this.isSFLmessageModalOpen = true;
                        this.recordUpdate = this.displayMessage;
                        this.alreadyExistsInCart = false;
                    } else if(this.successfullyAddedTocart == true && this.alreadyExistsInCart == true){                                                
                        this.displayMessage = 'Products are Added to Cart Successfully. Existing cart products and crate engine products are not added to cart. Please manually add the crate engine products to cart.';
                        this.isSFLmessageModalOpen = true;
                        this.recordUpdate = this.displayMessage;
                        this.successfullyAddedTocart = false;
                        this.alreadyExistsInCart = false;                        
                    }  
                })
            }).catch(error => {
                this.error = error.message;
            });
        }        
        //CECI-987 added addtocart GTM trigger for add all from save for later
        setTimeout(() => {
            let afterAddAll = this.isGuestUser ? this.saveforlaterProductList : this.loggeInSFLData;
            let prodsAddedtoCart = beforeAddAll.filter(({ ProductName: pName1 }) => !afterAddAll.some(({ ProductName: pName2 }) => pName2 === pName1));
            if(prodsAddedtoCart){
                prodsAddedtoCart.forEach(prod => {
                    this.googleAnalyticsCartOperations('AddToCart', {ProductType : 'Normal', unitPrice : JSON.stringify(prod.ProductPrice), quantity : 1, Name : prod.ProductName, id : prod.ProductSKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.currentStorelocation, cartOperation : 'AddToCart', originalProductPrice : null,cartId : this.cartId, Brand: prod.Brandname, Category: prod.Categoryname});/*CECI-958 GTM Events*/
                })
            }
            }, 7000);
        
    }

    closeModal() {
        this.isSFLmessageModalOpen = false;
        invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname : 'Close save forlater modal'});
    }
       
    processSaveforlaterAddProductOperation() {
        if (this.data == 'true') {
            this.isModalOpen = false;
        }
        this.isLoading = true;
        let i = 0;
        let SaveforLaterCartItem = {};
        let productdetailwrapper = {};
        for (i = 0; i < this.cartDetails[0].lstCartItem.length; i++) {
            if (this.cartDetails[0].lstCartItem[i].cartItem.Id == this.saveForLaterEventData) {
                SaveforLaterCartItem = this.cartDetails[0].lstCartItem[i].cartItem;
                productdetailwrapper = this.cartDetails[0].lstCartItem[i].cartItemProductDetailWrapper;
                break;
            }
        }
        this.googleAnalyticsCartOperations('AddToSaveforlater' , {cartitem : SaveforLaterCartItem, proddetail : productdetailwrapper, page: 'cartpage'});
        let sflProductID = SaveforLaterCartItem.ccrz__Product__c;
        let sfcartId = this.cartId;
        let sfcartitemID = SaveforLaterCartItem.Id;
        if (this.isGuestUser) {
            this.getSaveforLaterCookieByLocation();  
            let relatedCoreProduct;
            getRelatedProductByProductId({
                parentProductId : sflProductID,
                storeCountry : this.currentStorelocation
            }).then(coreproresult => {              
                    if(coreproresult){
                        relatedCoreProduct = coreproresult.Id;
                    }                                   
                    if (typeof this.saveforlatercookievalue == 'undefined'){
                        let Productlist = [sflProductID];                
                        if(relatedCoreProduct){
                            Productlist.push(relatedCoreProduct);
                        }
                        Productlist = [...new Set(Productlist)];
                        //then setcookie
                        if(this.currentStorelocation == this.allLabels.storeUSA){  
                            this.setsaveforlaterCookie('saveforlater', JSON.stringify(Productlist), 7);
                        }else if(this.currentStorelocation == this.allLabels.storeCanada){
                            this.setsaveforlaterCookie('saveforlaterCA', JSON.stringify(Productlist), 7);
                        }
                        this.getSaveforLaterCookieByLocation();
                        SaveForLaterFetchProductDetails({
                            ProductIDList: this.saveforlatercookievalue,
                            storeCountry : this.currentStorelocation                  
                        })
                            .then(result => {
                                let serverResponse = JSON.stringify(result);
                                this.saveforlaterProductList = JSON.parse(serverResponse);
                                this.setPricingforSaveforlater();
                                deleteCartItemOnShopCart({
                                    cartItemId: sfcartitemID,
                                    cartId: sfcartId
                                })
                                    .then(result => {     
                                        this.cartDetails = undefined;                                                              
                                        fetchLstCartItemsAfterDelete({
                                            cartId: sfcartId,
                                            cart: 'cart'
                                        }).then(result1 => {                         
                                            pubsub.fire('fetchcartevt', result1);
                                            if(result1.length == 0){
                                                this.EstimatedShippingAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
                                                this.makeEmptyCartSummary();
                                                this.isEmptyCart = true;
                                                this.template.querySelector('.emptyCart').classList.add('show');
                                                this.displayShippingMessage = false;
                                                this.cartValuePercentage = 0;
                                            }                                                                                    
                                            this.isLoading = false;
                                        }).catch(error => {
                                            this.error = error.message;
                                        });
                                    })
                                    .catch(error => {
                                        this.error = error.message;
                                    });
                            }).catch(error => {
                                this.error = error.message;
                            })
                    }
                    else {                                                            
                        this.getSaveforLaterCookieByLocation();                                                                
                        let retrivedCookieArray = JSON.parse(this.saveforlatercookievalue);
                        retrivedCookieArray.push(sflProductID);
                        if(relatedCoreProduct){
                            retrivedCookieArray.push(relatedCoreProduct);
                        }
                        retrivedCookieArray = [...new Set(retrivedCookieArray)];
                        /*Added by Malhar Ulhas Agale - for handleing storetoggling - 4/12/2020 */
                        if(this.currentStorelocation == this.allLabels.storeUSA){  
                            this.setsaveforlaterCookie('saveforlater', JSON.stringify(retrivedCookieArray), 7);
                        }else if(this.currentStorelocation == this.allLabels.storeCanada){
                            this.setsaveforlaterCookie('saveforlaterCA', JSON.stringify(retrivedCookieArray), 7);
                        }
                        this.getSaveforLaterCookieByLocation();
                        /*Added by Malhar Ulhas Agale - for handleing storetoggling - 4/12/2020 */  
                        SaveForLaterFetchProductDetails({
                            ProductIDList: this.saveforlatercookievalue,
                            storeCountry : this.currentStorelocation                  
                        })
                            .then(result => {
                                let serverResponse = JSON.stringify(result);
                                this.saveforlaterProductList = JSON.parse(serverResponse);
                                this.setPricingforSaveforlater();
                                deleteCartItemOnShopCart({
                                    cartItemId: sfcartitemID,
                                    cartId: sfcartId
                                })
                                    .then(result => {    
                                        this.cartDetails = undefined; //added by MALHAR 14-12-2021                                                   
                                        fetchLstCartItemsAfterDelete({
                                            cartId: sfcartId,
                                            cart: 'cart'
                                        }).then(result1 => {
                                            pubsub.fire('fetchcartevt', result1);
                                            /*Logic To display empty cart modal */                                            
                                            if(result1.length == 0){
                                                this.EstimatedShippingAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
                                                this.makeEmptyCartSummary();
                                                this.isEmptyCart = true;   
                                                this.template.querySelector('.emptyCart').classList.add('show');
                                                this.displayShippingMessage = false;
                                                this.cartValuePercentage = 0;               
                                            }                                          
                                            this.isLoading = false;
                                        }).catch(error => {
                                            this.error = error.message;
                                        });
                                    })
                                    .catch(error => {
                                        this.error = error.message;
                                    });
                            }).catch(error => {
                                this.error = error.message;
                            })            
                    }                    
            }).catch(error => {
                this.error = error.message;
            });
        } else {
            AddProductToSaveforLater({
                storeCountry : this.currentStorelocation,                
                ProductId: sflProductID,
                ProductQuantity: 1,
                dbu_SFL_OR_WL_Value: 'Save For Later',
                storeLanguage : this.sendLocBackToChangeLocTile
            }).then(addedresult => {
                this.FetchLoggedInUserSaveforLaterItemsFn();
            }).catch(error => {
                this.error = error.message;
            });
            getcurrentCartItemCartID({
                CartItemId: sfcartitemID
            }).then(cartitemresult => {
                deleteCartItemOnShopCart({
                    cartItemId: sfcartitemID,
                    cartId: cartitemresult
                })
                    .then(result => {                       
                        this.cartDetails = undefined;
                        fetchLstCartItemsAfterDelete({
                            cartId: cartitemresult,
                            cart: 'cart'
                        })
                            .then(result1 => {          
                                pubsub.fire('fetchcartevt', result1);
                                if(result1.length == 0){
                                    this.EstimatedShippingAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
                                    this.makeEmptyCartSummary();
                                    this.isEmptyCart = true;
                                    this.template.querySelector('.emptyCart').classList.add('show');
                                    this.displayShippingMessage = false;
                                    this.cartValuePercentage = 0;
                                }                                                                  
                                this.isLoading = false;
                            }).catch(error => {
                                this.error = error.message;
                            });
                    })
                    .catch(error => {
                        this.error = error.message;
                    });
            }).catch(error => {
                this.error = error.message;
            });
        }
    }

    saveforlaterAddProductOperation(event) {
        this.saveForLaterEventData = event.target.dataset.id;
        if (this.isGuestUser) {
            this.getfooterbannerCookie('footerBanner');
            if (!this.footerbannercookiestatus) {
                this.showCookiePolicyModel = true;
            } else {
                this.showCookiePolicyModel = false;
                this.processSaveforlaterAddProductOperation();
            }
        } else {
            this.showCookiePolicyModel = false;
            this.processSaveforlaterAddProductOperation();
        }
        //CECI-987 added removefromcart GTM trigger for save for later
        let isCrateEngine = event.target.dataset.protype == 'true' ? 'Crate Engine' : 'Normal';
        let cartitemdelGAFeed = {
            productid : event.target.dataset.proid,
            productname : event.target.dataset.name,
            productprice : event.target.dataset.price,
            storeLanguage : this.sendLocBackToChangeLocTile,
            producttype: isCrateEngine,
            productqty: parseInt(event.target.dataset.proqty),
            Brand: event.target.dataset.probrand,/*CECI-958 GTM Events*/
            Category: event.target.dataset.procategory/*CECI-958 GTM Events*/
          }
          this.googleAnalyticsCartOperations('RemoveFromCart', cartitemdelGAFeed);
    }

    showCookiePolicyModelAcceptHandle() {        
        this.showCookiePolicyModel = false;
        invokeGoogleAnalyticsService('ACCEPT COOKIES', 'ACCEPT COOKIES');
        this.createCookiePolicy('footerBanner', 'true', 7);
        pubsub.fire('ResetFooterBannermodalfromCart', true);        
        this.checkForSaveforLaterSessionvalue();
        this.processSaveforlaterAddProductOperation();
        setTimeout(() => {
            location.reload();
        },5000);
    }
    showCookiePolicyModelCancelHandle() {
        this.showCookiePolicyModel = false;
    }
    createCookiePolicy(name, value, days) {
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
   
        fetchLstCartItemsByCartIdFn(){
            this.isPickupOnlyErrorMsg = false;
        fetchLstCartItemsByCartIdAfterQuantityUpdate({
            cartId: this.cartId,
            cart: 'cart'
        })
        .then(data => {   
            if (data && data.length > 0) {            
                this.isEmptyCart = false;
                this.template.querySelector('.emptyCart').classList.remove('show');
                this.orderSummaryDisplay = true;
                this.isPartialAvailability = data[0].isPartialAvailability;
                this.checkoutButtonDisabilityCheck();
                let cartdata = JSON.stringify(data);
                this.cartDetails = JSON.parse(cartdata);
                this.cartDetails.forEach(element => {
                        if(element.lstCartItem.length == 0){    
                            this.EstimatedShippingAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
                            this.cartDetails = undefined;
                            this.isEmptyCart = true;
                            this.isLoading = false;
                            this.template.querySelector('.emptyCart').classList.add('show');
                            this.displayShippingMessage = false;
                            this.cartValuePercentage = 0;
                            return;
                        }
                        element.lstCartItem.forEach(item => {
                            item['quantityOptions'] = this.setQtyArr(item);
                            this.handleQuantityUpdateFnForShipMethod(item,false);
                            item = this.setCartItemPriceFn(item);   
                        })
                });
                if (this.cartDetails[0].totalCartDiscount != '0') {                
                    this.removeCouponPlaceHolder = true;
                    this.showCouponPlaceholder = false;
                }
                this.setCartAmountDetailsFn();
                this.checkAllowedQtyFn(); /*Aakriti CECI-693*/
            }
            else if (error) {
                this.EstimatedShippingAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
                this.error = error;
                this.cartDetails = undefined;
                this.isEmptyCart = true;
                this.template.querySelector('.emptyCart').classList.add('show');
                this.displayShippingMessage = false;
                this.cartValuePercentage = 0;
            }
            if(!data){
                setTimeout(() => {
                    this.orderSummaryDisplay = true;  
                }, 2000);
            }
            this.isLoading = false;
            this.checkAllowedQtyFn(); /*Aakriti CECI-693*/
            this.cartEmailSubscriptionVal = this.cartDetails[0].dbu_optEmailNotification__c;
        }).catch(error => {
            this.isLoading = false;
            this.error = error.message;
        });
}

    get optionscrate() {
        return [{
            "label": "1",
            "value": 1
        }

        ];
    }

    handleChangeQuantityForCart(event) {
        this.currentItemChangedQuantityId = event.target.dataset.id;
        const qty = event.detail.value;
        let initialQty = event.target.dataset.quantity;
        var cartItem = {};
        var productDetailWrapper ={};
        let i = 0
        let j = 0;
        if (qty == '9+') {
            let cartdata = JSON.stringify(this.cartDetails);
                        this.cartDetails = JSON.parse(cartdata);
                        this.cartDetails.forEach(element => {
                            element.lstCartItem.forEach(item => {
                                if (item.cartItem.Id == this.currentItemChangedQuantityId) {
                                    item['isQuantityAsTextInput'] = true;
                                }else{
                                    item['isQuantityAsTextInput'] = false;
                                }
                            })
                        });
        } else {
            for (i = 0; i < this.cartDetails.length; i++) {
                let cart = this.cartDetails[i];
                for (j = 0; j < cart.lstCartItem.length; j++) {
                    let item = cart.lstCartItem[j];
                    if (item.cartItem.Id == this.currentItemChangedQuantityId) {
                        cartItem = item.cartItem;
                        productDetailWrapper = item.cartItemProductDetailWrapper;
                        break;
                    }
                }
            }
            console.log('cartDetails in handleChangeEvent', JSON.parse(JSON.stringify(this.cartDetails)));
            this.handleChange(event);
            invokeGoogleAnalyticsService('CHANGE PRODUCT QUANTITY', {ProductName : event.target.dataset.currprodname, productQuantity : qty, pageName : 'Cart Page'});
        }
        if(qty != '9+' && parseInt(qty) > parseInt(initialQty)) {
            let updateQty = parseInt(qty) - parseInt(initialQty);
            this.invokeAddToCartGTM(updateQty,cartItem,productDetailWrapper,event);
        }
        if(qty != '9+' && parseInt(qty) < parseInt(initialQty)) {
            let updateQty = parseInt(initialQty)- parseInt(qty);
            this.invokeRemoveFromCartGTM(updateQty,cartItem,productDetailWrapper,event);
        }
    }
    invokeRemoveFromCartGTM(updateQty,cartItem,productDetailWrapper,event) {
        if (productDetailWrapper.dbuCrateEngine == true) {
            this.googleAnalyticsCartOperations('RemoveFromCart', {producttype : 'Crate Engine', productprice : JSON.stringify(cartItem.ccrz__Price__c), productqty : updateQty, productname : event.target.dataset.currprodname, productid : productDetailWrapper.SKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.currentStorelocation, cartOperation : 'RemoveFromCart', originalProductPrice : null,cartId : this.cartId, Brand: productDetailWrapper.Brandname, Category: productDetailWrapper.Categoryname});/*CECI-958 GTM Events*/                        
        }
        if (productDetailWrapper.dbuCrateEngine == false) {
            this.googleAnalyticsCartOperations('RemoveFromCart', {producttype : 'Normal', productprice : JSON.stringify(cartItem.ccrz__Price__c), productqty : updateQty, productname : event.target.dataset.currprodname, productid : productDetailWrapper.SKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.currentStorelocation, cartOperation : 'RemoveFromCart', originalProductPrice : null,cartId : this.cartId, Brand: productDetailWrapper.Brandname, Category: productDetailWrapper.Categoryname});/*CECI-958 GTM Events*/
        }
    }
    handleChangeInputQuantity(event) {
        this.currentItemChangedQuantity = event.detail.value;
        this.currentItemChangedQuantityId = event.target.dataset.id;
    }
    handleChangeQuantityForCartOnInputTxt(event) {
        invokeGoogleAnalyticsService('CHANGE PRODUCT QUANTITY', {ProductName : event.target.dataset.currprodname, productQuantity : this.currentItemChangedQuantity, pageName : 'Cart Page'});        
        let cartItemId = this.currentItemChangedQuantityId;
        let myCartItem = {};
        var cartItem = {};
        var productDetailWrapper ={};
        let i = 0
        let j = 0;
        for (i = 0; i < this.cartDetails.length; i++) {
            let cart = this.cartDetails[i];
            for (j = 0; j < cart.lstCartItem.length; j++) {
                let item = cart.lstCartItem[j];
                if (item.cartItem.Id == cartItemId) {
                    myCartItem = item;
                    cartItem = item.cartItem;
                    productDetailWrapper = item.cartItemProductDetailWrapper;
                    break;
                }
            }
        }
        
        const qty = this.currentItemChangedQuantity - myCartItem.cartItem.ccrz__Quantity__c;
        this.isLoading = true;
        updateCartItemShopCart({
            cartItemId: myCartItem.cartItem.Id,
            cartId: this.cartId,
            itemPrice: myCartItem.cartItem.ccrz__Price__c,
            quantity: qty,
            storeCountry : this.currentStorelocation
        })
            .then(result => {
                this.fetchCartDetailsFn('cart');
            })
            .catch(error => {
                this.error = error.message;
            });
        var quantity = this.currentItemChangedQuantity;
        var initialQty = myCartItem.cartItem.ccrz__Quantity__c;
        if(parseInt(quantity) > initialQty) {
            let updateQty = parseInt(quantity) - initialQty;
            this.invokeAddToCartGTM(updateQty,cartItem,productDetailWrapper,event);
        }
        if(parseInt(quantity) < initialQty) {
            let updateQty = initialQty - parseInt(quantity);
            this.invokeRemoveFromCartGTM(updateQty,cartItem,productDetailWrapper,event);
        }
    }
    invokeAddToCartGTM(updateQty,cartItem,productDetailWrapper,event) {
        if (productDetailWrapper.dbuCrateEngine == true) {
            this.googleAnalyticsCartOperations('AddToCart', {ProductType : 'Crate Engine', unitPrice : JSON.stringify(cartItem.ccrz__Price__c), quantity : updateQty, Name : event.target.dataset.currprodname, id : productDetailWrapper.SKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.currentStorelocation, cartOperation : 'AddToCart', originalProductPrice : null,cartId : this.cartId, Brand: productDetailWrapper.Brandname, Category: productDetailWrapper.Categoryname});/*CECI-958 GTM Events*/                        
        }
        if (productDetailWrapper.dbuCrateEngine == false) {
            this.googleAnalyticsCartOperations('AddToCart', {ProductType : 'Normal', unitPrice : JSON.stringify(cartItem.ccrz__Price__c), quantity : updateQty, Name : event.target.dataset.currprodname, id : productDetailWrapper.SKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.currentStorelocation, cartOperation : 'AddToCart', originalProductPrice : null,cartId : this.cartId, Brand: productDetailWrapper.Brandname, Category: productDetailWrapper.Categoryname});/*CECI-958 GTM Events*/
        }
    }
    
    handleChange(event) {
        let cartItemId = event.target.dataset.id;
        let myCartItem = {};
        let i = 0
        let j = 0;
        for (i = 0; i < this.cartDetails.length; i++) {
            let cart = this.cartDetails[i];
            for (j = 0; j < cart.lstCartItem.length; j++) {
                let item = cart.lstCartItem[j];
                if (item.cartItem.Id == cartItemId) {
                    myCartItem = item;
                    break;
                }
            }
        }
        const qty = event.detail.value - myCartItem.cartItem.ccrz__Quantity__c;
        this.isLoading = true;
        updateCartItemShopCart({
            cartItemId: myCartItem.cartItem.Id,
            cartId: this.cartId,
            itemPrice: myCartItem.cartItem.ccrz__Price__c,
            quantity: qty,
            storeCountry : this.currentStorelocation
        })
            .then(result => {
                this.fetchLstCartItemsFunction('cart');
            })
            .catch(error => {
                this.error = error.message;
            });
    }

    setsaveforlaterCookie(name, value, days) {
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
                this.cartId = c.substring(name.length, c.length);
            }
        }
    }

    onProductDelete(event) {
        this.isLoading = true;
        deleteCartItemOnShopCart({
            cartItemId: event.target.dataset.id,
            cartId: this.cartId
        })
            .then(result => {
                this.cartDetails = undefined;
                fetchLstCartItemsAfterDelete({
                    cartId: this.cartId,
                    cart: 'cart'
                })
                    .then(result1 => {
                        pubsub.fire('fetchcartevt', result1);
                        if(result1.length == 0){
                            this.EstimatedShippingAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
                            this.makeEmptyCartSummary();
                            this.isEmptyCart = true;
                            this.cartDetails = undefined;
                            this.template.querySelector('.emptyCart').classList.add('show');
                            this.displayShippingMessage = false;
                            this.cartValuePercentage = 0;
                        }
                        this.isLoading = false;
                        this.checkAllowedQtyFn(); /*Aakriti CECI-693*/
                    })
            })
            .catch(error => {
                this.error = error.message;
            });
            //CECI-987 modified for delet from cart GTM trigger
            let isCrateEngine = event.target.dataset.protype == 'true' ? 'Crate Engine' : 'Normal';
            let cartitemdelGAFeed = {
                productid : event.target.dataset.proid,
                productname : event.target.dataset.name,
                productprice : event.target.dataset.price,
                storeLanguage : this.sendLocBackToChangeLocTile,
                producttype: isCrateEngine,
                productqty: parseInt(event.target.dataset.proqty),
                Brand: event.target.dataset.probrand,/*CECI-958 GTM Events*/
                Category: event.target.dataset.procategory/*CECI-958 GTM Events*/
              }
              this.googleAnalyticsCartOperations('RemoveFromCart', cartitemdelGAFeed);          
    }

    register() {
        pubsub.register('fetchcartevt', this.handleEvent.bind(this));
        pubsub.register('sendDataTolstProdDetailspage', this.handleEventLoc.bind(this));
        pubsub.register('saveforlatercartevt', this.handleEventSaveForLater.bind(this));
        pubsub.register('minicartclearevt', this.handleEventcartclear.bind(this));
    }

    handleEventSaveForLater(event){
        if(window.location.pathname == '/CSSNAStore/s/cart'){
            if(event.sentfrom != undefined && event.sentfrom != null){
            if(event.sentfrom == 'minicart'){                                
            if (this.isGuestUser) {
                this.saveforlaterProductList = event.data;
                if (this.saveforlaterProductList.length > 0) {
                    this.saveForLaterItemsAvailable = true;                   
                } else {
                    this.saveForLaterItemsAvailable = false;
                }                
            }else if(!this.isGuestUser) {
                this.loggeInSFLData = event.data;           
                if (this.loggeInSFLData.length > 0) {
                    this.showSFLItemsLoggedIN = true;
                } else {
                    this.showSFLItemsLoggedIN = false;
                }
            }
        }
        }
        }
    }

    handleEventcartclear(event){        
        if(event.cartclear != undefined && event.cartclear != null && event.cartclear != '' && event.cartclear == true){
            this.cartDetails = undefined;
            this.makeEmptyCartSummary();
        }
    }
    /* Aakriti CECI748 added function to handle marketing email check start */
    handleChangeMarketingEmail(event){
        this.enableMarketingEmail = event.target.checked;
    }
    /* Aakriti CECI748 end */

    handleEvent(event) {
        if(event.length == 0){
            this.EstimatedShippingAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
            this.isEmptyCart = true;
            this.isLoading = false;
            this.template.querySelector('.emptyCart').classList.add('show');
            this.displayShippingMessage = false;
            this.cartValuePercentage = 0;
             this.cartDetails.forEach(element => {
                element.lstCartItem = [];   
             });
             this.cartDetails[0].originalCartAmt = 0;
             this.cartDetails[0].subtotalAmount = 0;
             this.cartDetails[0].totalAmount = 0;
             this.cartDetails[0].totalCartDiscount = 0;  
             if(this.removeCouponPlaceHolder){                
                if(this.showInvalidCouponPlaceolder){
                     this.showCouponPlaceholder = false;
                 }else{
                     this.showCouponPlaceholder = true;
                 }
                this.removeCouponPlaceHolder = false;
              }              
        }else{
            this.cartDetails = event;  
            this.isPartialAvailability = event[0].isPartialAvailability;
            this.checkoutButtonDisabilityCheck();
        }
        this.cartDetails.forEach(element => {
            element.lstCartItem.forEach(item => {
                item['quantityOptions'] = this.setQtyArr(item);
                this.handleQuantityUpdateFnForShipMethod(item,false);
                item = this.setCartItemPriceFn(item);
            })
        });         
          if (this.cartDetails[0].totalCartDiscount != '0') {
            this.removeCouponPlaceHolder = true;
            this.showCouponPlaceholder = false;
            this.showInvalidCouponPlaceolder = false;
        }else if(this.cartDetails[0].totalCartDiscount == '0'){
            this.removeCouponPlaceHolder = false;
            if(this.showInvalidCouponPlaceolder){
                this.showCouponPlaceholder = false;
            }else{
                this.showCouponPlaceholder = true;
            }
        }
        this.setCartAmountDetailsFn();                     
        if (event != undefined && event.length > 0) {
            this.numberOfItemInCart = event[0].totalQuantity;
        } else {
            this.EstimatedShippingAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
            this.numberOfItemInCart = 0;
            this.cartDetails = undefined;
        }
        if(this.cartDetails[0].lstCartItem.length == 0){
            this.EstimatedShippingAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
                this.isEmptyCart = true;
                this.cartDetails = undefined;
                this.isLoading = false;
                this.template.querySelector('.emptyCart').classList.add('show');
                this.displayShippingMessage = false; 
                this.cartValuePercentage = 0;     
        }
        this.checkAllowedQtyFn(); /*Aakriti CECI-693*/
    }

    getSaveforLaterCookieByLocation(){
        if(this.currentStorelocation == this.allLabels.storeUSA){
            this.getsaveforlaterCookie('saveforlater');
        }    
           else if(this.currentStorelocation == this.allLabels.storeCanada){
            this.getsaveforlaterCookie('saveforlaterCA');
        }                  
    }

    checkForSaveforLaterSessionvalue(){
        this.getfooterbannerCookie('footerBanner');
        if(this.footerbannercookiestatus){
            if(this.currentStorelocation == this.allLabels.storeUSA){
                let UScartidInSessionStorage = window.sessionStorage.getItem('cartId');
                this.getCookie('cartId');
                if(UScartidInSessionStorage !== null && (typeof this.cartId == "undefined" || this.cartId.length === 0)){
                    this.cartId = UScartidInSessionStorage;
                    this.createCookie('cartId', this.cartId, 7);
                    window.sessionStorage.removeItem('cartId');
                }                                                            
            }    
            else if(this.currentStorelocation == this.allLabels.storeCanada){
                let CAcartidInSessionStorage = window.sessionStorage.getItem('cartIdCA');
                this.getCookie('cartIdCA');
                if(CAcartidInSessionStorage !== null && (typeof this.cartId == "undefined" || this.cartId.length === 0)){
                    this.cartId = CAcartidInSessionStorage;
                    this.createCookie('cartIdCA', this.cartId, 7);
                    window.sessionStorage.removeItem('cartIdCA');
                }                    
            }
        }else {                
            if(this.currentStorelocation == this.allLabels.storeUSA){
                this.cartId = window.sessionStorage.getItem('cartId');
            }    
            else if(this.currentStorelocation == this.allLabels.storeCanada){
                this.cartId = window.sessionStorage.getItem('cartIdCA');
            }                                
        }        
    }
    openModelForGuestCart() {
        this.isOpenModelForGuestCart = true;
    }
    closeModelForGuestCart() {
        this.isOpenModelForGuestCart = false;
        this.navToCheckoutForGuest = true;
        invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname : 'Close cart modal'});  
    }
    updateShippingMethodFn(event){
        this.isLoading = true;
        updateShippingMethod({
            dbu_isShipTo : this.shipToStoreAddress,
            cartId : this.cartId,
            cartItemId : event.target.dataset.id,
            productId : event.target.dataset.productid
        }).then(result=>{
                this.fetchCartDetailsFn('cart');
            })
            .catch(error => {
                this.error = error.message;
                this.isLoading = false;
            });
    }
   
    fetchCartDetailsFn(cartVal){
        this.isLoading = true;
        this.isPickupOnlyErrorMsg = false;
        this.fetchLstCartItemsFunction(cartVal);
    }
    handleQuantityUpdateFnForShipMethod(item, cancelCase){
        if((item.cartItemProductDetailWrapper.availableToShip == false && item.cartItemProductDetailWrapper.pickUpOnly == false) || (item.cartItemProductDetailWrapper.availableToShip == true && item.cartItemProductDetailWrapper.pickUpOnly == true)){
                item['isProductShipable'] = true;
                item['isProductPickupable'] = true;
                item['isPickUpShipToBoth'] = true;
                item['nameValForShipTo'] = item.cartItem.Id+'shipToTrue';
                item['nameValForPickUp'] = item.cartItem.Id+'pickUpTrue';
        }else{
            if(item.cartItemProductDetailWrapper.availableToShip == true){
                item['isProductShipable'] = true;
                item['isProductPickupable'] = false;
                item['isPickUpShipToBoth'] = false;
                item['nameValForShipTo'] = item.cartItem.Id+'shipToTrue';
                item['nameValForPickUp'] = item.cartItem.Id+'pickUpFalse';
            }else if(item.cartItemProductDetailWrapper.pickUpOnly == true){
                item['isProductShipable'] = false;
                item['isProductPickupable'] = true;
                item['isPickUpShipToBoth'] = false;
                item['nameValForShipTo'] = item.cartItem.Id+'shipToFalse';
                item['nameValForPickUp'] = item.cartItem.Id+'pickUpTrue';
            }
        }
            if(cancelCase){
                eval("$A.get('e.force:refreshView').fire();");
                return false;
            }
        return item;
    }
    makeEmptyCartSummary(){
        // Shriram 15thDec making 0 when No cartItem available
        this.cartOriginalAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
        this.cartDiscountAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
        this.cartSubtotalAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
        this.cartTotalAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,0.00);
        // ended here
    }
    /*Aakriti CECI-693*/
    checkAllowedQtyFn(){
        if(this.cartDetails != undefined && this.cartDetails != '' && this.cartDetails[0].lstCartItem.length >= 1){//CECI-1097 added if //14sept changed >1 to >=1
            let productAllowedQty = this.allLabels.dbu_product_max_allowed_qty.toLowerCase();
            var getAllowedQtyJSON = {};
            var allowedQtyArr = productAllowedQty.split(',');
            for(var i=0; i < allowedQtyArr.length; i++){
                allowedQtyArr[i] = allowedQtyArr[i].trim();
                getAllowedQtyJSON[allowedQtyArr[i].split(':')[0]] = parseInt(allowedQtyArr[i].split(':')[1]);
            };
            let cItemArr = JSON.parse(JSON.stringify(this.cartDetails[0].lstCartItem));
            this.showFinalQtyExceedError = false;
            for(let ci = 0; ci < cItemArr.length; ci++){
                let cItem = cItemArr[ci];
                let currProductCodeVal = cItem.cartItemProductDetailWrapper.productCode.toLowerCase();
                let selectedProductQty = parseInt(cItem.cartItem.ccrz__Quantity__c);
                if(getAllowedQtyJSON[currProductCodeVal]){
                    this.cartDetails[0].lstCartItem[ci].maxAllowedQty = getAllowedQtyJSON[currProductCodeVal];
                    this.cartDetails[0].lstCartItem[ci].hasQtyValidationError = true;
                }
                else{
                    this.cartDetails[0].lstCartItem[ci].hasQtyValidationError = false;
                }
                if(selectedProductQty > this.cartDetails[0].lstCartItem[ci].maxAllowedQty){
                    this.cartDetails[0].lstCartItem[ci].showQtyExceedError = true;
                    this.showFinalQtyExceedError = true;
                }
                else{
                    this.cartDetails[0].lstCartItem[ci].showQtyExceedError = false;
                }
                this.checkoutButtonDisabilityCheck();
            }
        }
    }
}