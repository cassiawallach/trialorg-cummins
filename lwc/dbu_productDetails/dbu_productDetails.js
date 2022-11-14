import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
import {
    refreshApex
} from '@salesforce/apex';
import {
    NavigationMixin
} from 'lightning/navigation';
import fetchProductById from '@salesforce/apex/dbu_ProductCtrl.fetchProductById';
import fetchSpecsByProdId from '@salesforce/apex/dbu_ProductCtrl.fetchSpecsByProdId';
import fetchPriceByProdID from '@salesforce/apex/dbu_ProductCtrl.fetchPriceByProdID';
import getRelatedProductList from '@salesforce/apex/dbu_ccApiRelatedProduct.getRelatedProductList';
import fetchMessageByProdID from '@salesforce/apex/dbu_ProductCtrl.fetchMessageByProdID';
import fetchKitProductsByProdId from '@salesforce/apex/dbu_ProductCtrl.fetchKitProductsByProdId';
import fetchCartSize from '@salesforce/apex/dbu_CartCtrl.fetchCartSize';
import fetchAttachmentsbyProdId from '@salesforce/apex/dbu_ProductCtrl.fetchAttachmentsbyProdId'
import getProductInventoryDetails from '@salesforce/apex/dbu_ProductCtrl.getProductInventoryDetails'
import fetchReconSupersessionNumbers from '@salesforce/apex/dbu_ProductCtrl.fetchReconSupersessionNumbers';
import fetchReconSupersessionProducts from '@salesforce/apex/dbu_ProductCtrl.fetchReconSupersessionProducts'; //Sandeep
import showwarrenty from '@salesforce/apex/dbu_ProductCtrl.showwarrenty';
import { perfixCurrencyISOCode } from "c/serviceComponent";
import insertFrequentlyBougthProducts from '@salesforce/apex/dbu_FreqBgtProductsCtrl.insertOrUpdateMultipleCartitemsInFreqBgtProds';
import RecordNotifyMeData from '@salesforce/apex/dbu_NotifyMeCtrl.RecordNotifyMeData';
import clearanceIcon from '@salesforce/resourceUrl/dbu_icons';
//URL
import {
    getPicklistValues
} from 'lightning/uiObjectInfoApi';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import productdetailshareIcon from '@salesforce/resourceUrl/dbu_ProductShareImage';
import ImgWishlist from '@salesforce/resourceUrl/dbu_WishlistImage';
import insertCartItem from '@salesforce/apex/dbu_CartCtrl.insertCartItem';
import updateCartItem from '@salesforce/apex/dbu_CartCtrl.updateCartItem';
import notifyImage from '@salesforce/resourceUrl/cloudMVP';
import pubsub from 'c/pubsub';
import CumminsLogoWhite from '@salesforce/resourceUrl/dbu_CumminsLogoWhite';
//Related to crate engine start
import dbu_CrateinstallationGuide from '@salesforce/resourceUrl/dbu_CrateinstallationGuide';
import dbu_CrateBrochure from '@salesforce/resourceUrl/dbu_CrateBrochure';
import dbu_CrateQuickStartGuide from '@salesforce/resourceUrl/dbu_CrateQuickStartGuide';
import getCrateMetaData from '@salesforce/apex/dbu_ProductCtrl.getCrateMetaData';
import Checkcreateengine from '@salesforce/apex/dbu_ProductCtrl.Checkcreateengine';
import insertCartItemForCrateEngine from '@salesforce/apex/dbu_CartCtrl.insertCartItemForCrateEngine'
import getStatesData from '@salesforce/apex/dbu_CustomsettingCntrl.getStatesData';
import getProductcode from '@salesforce/apex/dbu_ProductCtrl.getProductcode';
// crate engine end
// ESN Validation start
import ValidateUserenteredESN from '@salesforce/apex/dbu_ProductCtrl.ValidateUserenteredESN';
//fetch modelsspec
import fetchmodelSpecsByProdId from '@salesforce/apex/dbu_ProductCtrl.fetchmodelSpecsByProdId';
//ESN Validation END
import isGuest from '@salesforce/user/isGuest';
import getlongdesc from '@salesforce/apex/dbu_ProductCtrl.getlongdesc';
import getESNPdpPopup from '@salesforce/apex/dbu_ProductCtrl.getESNPdpPopup';
import fetchLstCartItemsByCartIdAfterQuantityUpdate from '@salesforce/apex/dbu_CartCtrl.fetchLstCartItemsByCartIdAfterQuantityUpdate';
import wishlistForLoggedIn from '@salesforce/apex/dbu_SaveForLatetGeneric.AddProductTo_WishList_or_SaveForLater_forLoggedInUser';
import fetchCartId from '@salesforce/apex/dbu_CartCtrl.fetchCartId';
import checkProductInDefaultWishlist from '@salesforce/apex/dbu_SaveForLatetGeneric.checkProductInDefaultWishlist';
import LocateImage from '@salesforce/resourceUrl/dbu_locateImage';
import dbu_ESN_Image from '@salesforce/resourceUrl/dbu_ESN_Image';
//end
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import fetchproductdata from '@salesforce/apex/dbu_validateproductwithstore.getdata';
import { getGeoCode } from "c/serviceComponent";
import getLabels from 'c/dbu_custLabels';
import infoIcon from '@salesforce/resourceUrl/dbu_icons';
import closeIcon from '@salesforce/resourceUrl/dbu_icons';
import { getQuantityList } from "c/serviceComponent";
import getProductBreadCrumb from '@salesforce/apex/dbu_homePageCategoryTileCtrl.getBreadCrumb'; /*CECI-958 GTM Events*/
/*Removed custom labels from import and moved to custLabel common comp as part of CECI-1098 optimization*/
export default class dbu_ProductDetails extends NavigationMixin(LightningElement) {

    @api recordId;
    @api store;
    generatorlogo=LocateImage;
    esnimage = dbu_ESN_Image;
    whitelogoImg = CumminsLogoWhite;
    notifymePopupImg = notifyImage + '/images/InjectorwithBox.png';
    message;
    @track allLabels = getLabels.labels;
    //crate engine related
    @track CrateQuickStartGuidepdf = dbu_CrateQuickStartGuide;
    @track CrateBrochurepdf = dbu_CrateBrochure;
    @track CrateinstallationGuide = dbu_CrateinstallationGuide;
    // crate engine related end
    @track productDetails;
    @track openmodelwishlist = false;
    @track inputQuantity;
    @track isInputQuantityAddToCart = false;
    @track productMedia;
    productImage = false;
    @track productSpecs;
    @track productPrice;
    @track productMessage;
    @track openmodelNotify = false;
    @track openmodelNotifyError = false;
    @track WishListText = this.allLabels.dbu_productDetail_addToWishlist;
    @track wishlistIcon = 'icon-heart';
    @track sendWishlist = 'Wishlist';
    showNotifyPopup = true;
    @api defaultSelectedImage;
    @track picklistValues;
    @track kitDetails;
    @track stockFromInv;
    @track productavgRating;
    @track picklistvalues = [];
    @track valueDrpdwn;
    @track productVar;
    @track cartQuantityValue;
    shareIcon = productdetailshareIcon + '#shareicon';
    wishlistImg = ImgWishlist + '#wishlistImg';
    @track unitPrice;
    @track totalPrice;
    @track formatedTotalPrice;
    @track imgProdUrl;
    @track currentURL = window.location.href;
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isAddToCartModalOpen;
    @track cartItemId;
    @track isLoading = true;
    @track initialLoad = false;
    @track isCartUpdatedLoader = false;
    @track enableESNpopup =false;
    @track specs = false;
    @track zoomPopupWindow = false;
    @track isOpenModelForGuestCart = false;
    @track signInURL;
    @track registerURL;
    @track warrantyinformationURL;
    @track isGuestUser = isGuest;
    @track cartId;
    @track inputValForAddToCart; //shriram: 11Oct2020
    @track originalPrice;
    @track discPercent;
    @track isOriginalPrice;
    @track spinnerWishlist = false;
    @track isShowFirstTimeGuestUserPopup = true;
    @track attachmentid;
    @track sendLocBackToChangeLocTile;
    @track locationData;
    // @track goToCartUrl;
    @track objMetadataValues = {};
    @track fetchstate = this.allLabels.storeUSA;
    // related to crate engine
    @track Checkcreateengine=false;
    @track opencratemodel = false;
    @track cratemetadata;
    @track crateshowlongdesc = false;
    @track cratecheckbox = false;
    @track CrateLaws;
    @track arrayValues = '';
    @track statePicklistValues = '';
    @track statePicklistValuArray = [];
    @track inputVIN = '';
    @track inputYear = '';
    @track inputmake = '';
    @track inputmodel = '';
    @track inputstate = '';
    @track finalinputstate ='';
    @track acceptallagreements = false;
    @track origin;
    @track invalidstate = false;
    @track invalidVIN = false;
    @track longdesc;
    @track mandate = false;
    @track stateUS = false;
    @track stateCA = false;
    //c/modelspec
    @track modelspec = false;
    // end related to crate engine
    // related to ESN validation
    @track ESNval = '';
    @track validesn = false;
    @track esndata;
    @track openmodelforESN = false;
    @track ESNvalidated=false;
    @track GoogleAnalyticsPDPlandingPgeEventComplete = true;

    //Added by Malhar to get footerbanner cookie statis - 1/12/2020
    @track footerbannercookiestatus;
    // end esn validation
    @track locateheader;
    @track locatecontent1;
    @track locatecontent2;
    @track locateassit;
    @track locatecontactus;
    @track contactUsURL;
    @track baseURL;
    @track hasCoreCharge = false; //11 Nov 2020 core charge related
    @track coreCharge = 0.00; //11 Nov 2020 core charge related
    @track formatedCoreCharge = 0.00;
    @track totalCoreCharge = 0.00; //11 Nov 2020 core charge related
    @track formatedTotalCoreCharge = 0.00; //11 Nov 2020 core charge related
    @track corePolicyURL;
	@track supersessionURL; //Sandeep
	@track supersessionURLWrapper =[];
    @track doesSupersessionExist = false;
    @track countryCurrencyCode;
    @track isAddedtoWishlist = false;
    @track productInvWrapper;
    @track returningdata;
    @track productcode  = false;
    @track purchase;
    @track recondata; 
    @track supersession ;
    @track showwarrentyinfo=false;
    @track extrawarrenty = false;
    @track isLocateModalOpen = false;
    @track priceTotal;
    @track ipaddress; 
    @track currentproductpath;
    @track framedproductURLforstore = window.location.href;
    @track flaglichenstein = false;
    @track productdatafetched;
    @track isCAStateSelected=false;// Sri - CA validation
    @track vehiclePowered;// Sri - CA validation
    vpPicklistValuArray = [{label:'Diesel', value:'Diesel'},{label:'Gasoline', value:'Gasoline'}];// Sri - CA validation
    @track invalidYearforCA=false;// Sri CA Val
    @track invalidYearforCAMsg;// Sri CA Val
    @track invalidYearforCanada=false;// Canada Year Validatin Sri
    @track invalidYearforCanadaMsg;// Canada Year Validatin Sri
    @track isCanadaStore = false;
    @track cartCurrentValue = '';
    shippingPolicyURL;
    /*Aakriti CECI-693*/
    @track productCodeVal;
    @track hasQtyValidationError = false;
    @track maxAllowedQty;
    @track selectedProductQty = '1';
    @track showQtyExceedError = false;
    @track clearanceImg = clearanceIcon+'/dbu_icons/dbu_saletag.svg';
    @track promotionCategory;
    @track sumCoreProductPrice;
    /*Sasikanth CECI-1081 start*/
    @track infoImg = infoIcon+'/dbu_icons/dbu_info_icon.svg';
    @track closeImg = closeIcon+'/dbu_icons/dbu_close_icon.svg';
    @track adjDisc;
    @track isShowModal = true;
    @track updQty;
    @track hasCoreChild =  false;
    /*Sasikanth CECI-1081 end*/
    get ScreenLoaded() {
        return this.isLoading;
    }
    /*CECI-958 GTM Events start*/
    @track prodBrandName;
    @track prodCategoryName;
    @track productId;
    /*CECI-958 GTM Events end*/
     

    connectedCallback() {
        this.valueDrpdwn = '1';
        let urlString = window.location.origin;
        this.origin = urlString;
        this.registerURL = urlString + '/cw/IAM_Basic_Registration?appid=a1a1F0000018d4x';
        this.purchase = urlString + this.allLabels.communityName + 'purchase-agreement';
        this.regiser();
        pubsub.fire('takeavailableToShipTocart', this.allLabels.avialbleShipData);
        this.createCookieData('RecentPids', 'yes', 7);
        let locationURL = window.location.href;
        var url = new URL(locationURL);
        this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode'); 
        

        let setSeesionCheckFlag = false;
        let currenctProductid = this.getproductidfromURL();
        if (this.sendLocBackToChangeLocTile == this.allLabels.storeUSA) {
            this.stateUS = true;
            this.fetchstate = this.allLabels.storeUSA;
            this.countryCurrencyCode = this.allLabels.currencyCodeUSA;
            setSeesionCheckFlag = true;
        }
        if (this.sendLocBackToChangeLocTile == this.allLabels.storeCA || this.sendLocBackToChangeLocTile == this.allLabels.storeCAF) {
            this.stateCA = true;
            this.fetchstate = this.allLabels.storeCanada;
            this.countryCurrencyCode = this.allLabels.currencyCodeCanada;
            setSeesionCheckFlag = true;
            this.isCanadaStore = true;
        }
        
        if(setSeesionCheckFlag){            
        }else if(!setSeesionCheckFlag){   
            if (this.sendLocBackToChangeLocTile == null ||this.sendLocBackToChangeLocTile == 'null' || this.sendLocBackToChangeLocTile == '' ||
                this.sendLocBackToChangeLocTile == undefined) {
                    this.fetchstate = 'null';
            }
        }
        try{
            fetchproductdata({
                countrycode : this.fetchstate,
                productid : currenctProductid
            }).then(result => {
                this.returningdata = {
                    country : result.countryreturned,
                    productid : result.productid,
                    countrysimilar : result.samecountrycode,
                    productname : result.productName
                }                
                if(result.samecountrycode){
                    this.flaglichenstein = true;
                    if(this.sendLocBackToChangeLocTile == null ||this.sendLocBackToChangeLocTile == 'null'  || this.sendLocBackToChangeLocTile == '' || this.sendLocBackToChangeLocTile == undefined){
                        this.setuptheLocation(currenctProductid);
                    }else{
                        //setup url            
                        this.framedproductURLforstore = urlString + this.allLabels.communityName + 'product?name='+this.returningdata.productname +'&pId=' + currenctProductid + '&store='+this.sendLocBackToChangeLocTile;
                        ;
                        this.handleafteconnectedcall(currenctProductid);
                    }    
                    
                }else if(!(result.samecountrycode)){
                    this.flaglichenstein = true;        
                    this.setuptheLocation(currenctProductid);
                    
                }                                   
            }).catch(error => {
                this.error = error.message;
            })                        
        }catch(error){ 
            console.log(error);
        };
    }
    /*Sasikanth CECI-1081 start*/
    closePopover(event) {
        this.isShowModal=false;
    }
    handlemouseover(){
        this.isShowModal=true;
    }
    /*Sasikanth CECI-1081 end*/
    getBreadCrumb() { /*CECI-958 GTM Events*/
        let productId =  this.getproductidfromURL();
        getProductBreadCrumb({
            productId: productId
        })
            .then(result => {
                if (result !== null) {
                    this.prodBrandName = result.brandName;
                    this.prodCategoryName = result.subCategoryName;
                }
            })
            .catch(error => {

            });
    }
    setuptheLocation(productId){
        if((this.returningdata.country) == getLabels.labels.storeUSA){
            this.sendLocBackToChangeLocTile = getLabels.labels.storeUSA;
            this.fetchstate = this.allLabels.storeUSA;  
            this.stateUS = true;       
            this.countryCurrencyCode = this.allLabels.currencyCodeUSA;               
        }else if((this.returningdata.country) == this.allLabels.storeCanada){
            if(window.location.origin == 'https://fr-shop.cummins.com' || window.location.origin == 'https://gwccdn.cummins.com'){
                this.sendLocBackToChangeLocTile = this.allLabels.storeCAF;
            }else{
                this.sendLocBackToChangeLocTile = this.allLabels.storeCA;
            }
            this.fetchstate = this.allLabels.storeCanada;  
            this.stateCA = true;
            this.countryCurrencyCode = this.allLabels.currencyCodeCanada; 
        }
        window.sessionStorage.setItem('setCountryCode', this.sendLocBackToChangeLocTile);                            
        //setup url            
        this.framedproductURLforstore = window.location.origin + this.allLabels.communityName + 'product?name='+this.returningdata.productname +'&pId=' + productId + '&store='+this.sendLocBackToChangeLocTile;
        this.handleafteconnectedcall(productId);
    }
    //sri CA Validation start
    handleVPChange(event) {
        this.vehiclePowered = event.detail.value;
        this.validateCAstatevalidation();
       
    }//sri CA Validation end

    validateCAstatevalidation(){
        this.invalidYearforCA=false;
        if(this.inputstate && this.inputstate == 'CA' && this.vehiclePowered && this.vehiclePowered!='' && this.inputYear && this.inputYear!=''){
            if(parseInt(this.inputYear)>1998 && this.vehiclePowered=='Diesel'){
            this.invalidYearforCA=true;
            this.invalidYearforCAMsg='Sorry, we are unable to ship this engine for use in vehicles newer than 1998. Please contact 1-800-CUMMINS<sup>TM</sup> for more information.';
        }
        if(parseInt(this.inputYear)>1976 && this.vehiclePowered=='Gasoline'){
            this.invalidYearforCA=true;
            this.invalidYearforCAMsg='Sorry, we are unable to ship this engine for use in vehicles newer than 1976. Please contact 1-800-CUMMINS<sup>TM</sup> for more information.';
        }
      //sri Canada year Validation start 
        }
        this.invalidYearforCanada=false;
        if(this.inputstate && (( this.stateCA && this.inputstate != 'QC' ) ||(!this.stateCA  && this.inputstate != 'CA' && this.inputstate != 'WV' && this.inputstate != 'TX')) && this.inputYear && this.inputYear!='' && parseInt(this.inputYear)>1999){
            this.invalidYearforCanada=true;
            this.invalidYearforCanadaMsg=this.allLabels.dbu_CrateEngineCanadaYearValidation.replace('CUMMINS','CUMMINS<sup>TM</sup>');
        } // sri Canada year Validation end
    }
    setCartId(){
        if(this.fetchstate == this.allLabels.storeUSA){
            this.cartId = window.sessionStorage.getItem('cartId');
        }    
        else if(this.fetchstate == this.allLabels.storeCanada){
            this.cartId = window.sessionStorage.getItem('cartIdCA');
        } 
    }
    handleafteconnectedcall(currentProductIDsent){

        this.priceTotal = perfixCurrencyISOCode( this.countryCurrencyCode,0);    
        let urlString = window.location.origin;                  
        if (this.isGuestUser) {   
            /*Modification by MALHAR - begin - store toggling - 30/11/2020 */
            this.getfooterbannerCookie('footerBanner');
            if(this.footerbannercookiestatus){  
                if(this.fetchstate == this.allLabels.storeUSA){                    
                    let UScartidInSessionStorage = window.sessionStorage.getItem('cartId');
                    this.getCookie('cartId');
                    if(UScartidInSessionStorage !== null && (typeof this.cartId == "undefined" || this.cartId.length === 0)){
                        this.cartId = UScartidInSessionStorage;
                        this.createCookie('cartId', this.cartId, 7);
                        window.sessionStorage.removeItem('cartId');
                    }
                    
                }    
                else if(this.fetchstate == this.allLabels.storeCanada){                  
                    let CAcartidInSessionStorage = window.sessionStorage.getItem('cartIdCA');
                    this.getCookie('cartIdCA');
                    if(CAcartidInSessionStorage !== null && (typeof this.cartId == "undefined" || this.cartId.length === 0)){
                        this.cartId = CAcartidInSessionStorage;
                        this.createCookie('cartIdCA', this.cartId, 7);
                        window.sessionStorage.removeItem('cartIdCA');
                    }
                }
            }
            else if(typeof this.footerbannercookiestatus == "undefined")              
                    this.setCartId();                              
        } else {
        fetchCartId({
            storeCountry : this.fetchstate
        })
            .then(result => {
                this.cartId = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error.message;
            });        
            checkProductInDefaultWishlist({
                currentProductID : currentProductIDsent,
                storeCountry : this.fetchstate
            }).then(result => {
                if(result){
                    this.WishListText = 'Added To Your Wishlist';
                    this.wishlistIcon = 'icon-heart-select';
                    this.spinnerWishlist = false;   
                    this.isAddedtoWishlist = true; 
                    
                }
            }).catch(error => {
                this.error = error.message;
            })    
        }        
        this.callInvDetails(); 
       
        this.baseURL = urlString + this.allLabels.communityName; 
        /**Ended here */
        this.corePolicyURL = this.baseURL + 'core-policy?store=' +this.sendLocBackToChangeLocTile; 
        this.warrantyinformationURL =  this.baseURL +  'warranty?store=' +this.sendLocBackToChangeLocTile;
        this.contactUsURL = this.baseURL + 'contact-us?store=' +this.sendLocBackToChangeLocTile;
        this.shippingPolicyURL = this.baseURL + 'shipping-policy?store=' + this.sendLocBackToChangeLocTile;
        
        this.fetchProductByIdFn();      
        this.fetchmodelSpecsByProdIdFn();
        this.showwarrentyFn();
        this.fetchReconSupersessionNumbersFn();
        this.getCrateMetaDataFn();
        this.getProductcodeFn();
        this.getStatesDataFn();
        this.getESNPdpPopupFn();
        this.CheckcreateengineFn();
        this.fetchSpecsByProdIdFn();
        this.fetchPriceByProdIDfN();
        this.fetchMessageByProdIDFn();
        this.fetchAttachmentsbyProdIdFn();
        this.fetchKitProductsByProdIdFn();
        this.fetchCartSizeFn();
        this.getRelatedProductListFn(); 
        if (this.sendLocBackToChangeLocTile == this.allLabels.storeUSA) {
            this.stateUS = true;
            this.fetchstate = this.allLabels.storeUSA;
            this.countryCurrencyCode = this.allLabels.currencyCodeUSA;
        }
        if (this.sendLocBackToChangeLocTile == this.allLabels.storeCA || this.sendLocBackToChangeLocTile == this.allLabels.storeCAF) {
            this.stateCA = true;
            this.fetchstate = this.allLabels.storeCanada;
            this.countryCurrencyCode = this.allLabels.currencyCodeCanada;
        }
       
        if (this.sendLocBackToChangeLocTile != null || this.sendLocBackToChangeLocTile != '' ||
            this.sendLocBackToChangeLocTile != undefined) {
            pubsub.fire('sendLocToStore', this.sendLocBackToChangeLocTile);
            pubsub.fire('sendLocToCumminsLogoLWC', this.sendLocBackToChangeLocTile);
        }else{
            this.sendLocBackToChangeLocTile = this.allLabels.storeUSA;
            this.stateUS = true;
            this.fetchstate = this.allLabels.storeUSA;
            this.countryCurrencyCode = this.allLabels.currencyCodeUSA;
            pubsub.fire('sendLocToStore', this.sendLocBackToChangeLocTile);
            pubsub.fire('sendLocToCumminsLogoLWC', this.sendLocBackToChangeLocTile);
        }  
    }

    handleToSignInLinkClick() {
        invokeGoogleAnalyticsService('SIGNIN LINK CLICK', 'IAM');
    }
    get navigateToSignInURL() {
        return this.allLabels.loginInURL;
    }

    renderedCallback() {
        this.getBreadCrumb(); /*CECI-958 GTM Events*/
        if(document.title == undefined || document.title == 'undefined'){
            document.title = this.productDetails[0].sfdcName;
         }
        if (this.productDetails != 'undefined' && this.productDetails != undefined) {
            var seoMetaKeyWord = JSON.stringify(this.productDetails[0].seoKeyword);
            if (seoMetaKeyWord != '' && seoMetaKeyWord != null && seoMetaKeyWord != undefined &&
                seoMetaKeyWord != 'undefined') {
                var seoMetaKeyWordList = seoMetaKeyWord.split(",");
                if (seoMetaKeyWordList != '' && seoMetaKeyWordList.length > 0) {
                    for (let index = 0; index < seoMetaKeyWordList.length; index++) {
                        var element = seoMetaKeyWordList[index];
                        var elementName = element.replace(/\s+/g, '-');
                        var script2 = document.createElement('meta');
                        script2.name = elementName;
                        script2.content = element;
                        document.getElementsByTagName('head')[0].appendChild(script2);
                    }
                }
            }
            /*CECI-958 GTM Events start*/
            let prodDetArr = [];
            let prodDetObj = JSON.parse(JSON.stringify(this.productDetails[0]));
            prodDetObj.brandName = this.prodBrandName;
            prodDetObj.categoryName = this.prodCategoryName;
            prodDetArr.push(prodDetObj);
            if(this.unitPrice == undefined){
                this.fetchPriceByProdIDfN();
                this.GoogleAnalyticsPDPlandingPgeEventComplete = false;
            }
            /*CECI-958 GTM Events end*/
            setTimeout(() => {
                if(this.GoogleAnalyticsPDPlandingPgeEventComplete == false){
                    this.googleAnalyticsInformationPush(prodDetArr, this.productInvWrapper, this.unitPrice, 'LAND ON PRODUCT DETAIL PAGE');/*CECI-958 GTM Events*/
                    this.GoogleAnalyticsPDPlandingPgeEventComplete = true;
                }    
            }, 3000);
            
        }
    }
    getproductidfromURL(){
        let locationURL = window.location.pathname;                        
        let splitpath = locationURL.split('/');     
        let ProductId = splitpath[4];
        return ProductId;
    }


    navigateTocorePolicyURLPage(){   
        invokeGoogleAnalyticsService('CORE POLICY FOOTER LINK CLICK', 'Page Navigation');                 
    }  

    get corepolicyPageURL(){
        return this.corePolicyURL;
    }  

    googleAnalyticsInformationPush(productDetails, productInventory, productPrice, requestSource){   
        let listname = window.localStorage.getItem('CurrentGAlistname');
        if(listname == undefined && listname == null && listname == 'undefined'){
          listname = 'Product viewed';
        }
        let requestdata = {currenctproductdetails : productDetails,
            currenctproductinventory : productInventory,
            currencyproductprice : JSON.stringify(productPrice),
            galistname : listname };/*CECI-958 GTM Events*/
        invokeGoogleAnalyticsService(requestSource, requestdata);                          
    }    

    handleGotoCart(){
        invokeGoogleAnalyticsService('NAVIGATE TO CART PAGE', 'Navigate to cart Page on button click');        
    }

    get goToCartUrl() {
        let urlString = window.location.origin;
   
        this.getfooterbannerCookie('footerBanner');
        
        if(this.footerbannercookiestatus){
            if(this.fetchstate == this.allLabels.storeUSA && this.getCookieValueOfCart('cartId').length){
                this.getCookie('cartId');
            }    
            else if(this.fetchstate == this.allLabels.storeCanada && this.getCookieValueOfCart('cartIdCA').length){
                this.getCookie('cartIdCA');
            }
        }else if(typeof this.footerbannercookiestatus == "undefined"){                
            this.setCartId();                              
        } 
        /*Modification by MALHAR - end - store toggling - 30/11/2020 */  
        return urlString + this.allLabels.communityName + 'cart?cartId=' + this.cartId+'&store='+this.sendLocBackToChangeLocTile;
    }
    handleEventLoc(event) {
        this.sendLocBackToChangeLocTile = event;
        pubsub.fire('sendLocToStore', this.sendLocBackToChangeLocTile);
        pubsub.fire('sendLocToCumminsLogoLWC', this.sendLocBackToChangeLocTile);
    }


      

        fetchmodelSpecsByProdIdFn(){
            fetchmodelSpecsByProdId({
                urlParam: this.framedproductURLforstore
            })
            .then(data => {
                this.modelspec = data;
                this.error = undefined;
            })
            .catch(error => {
                if(error){
                    this.error = error;
                    this.modelspec = undefined;
                }
                
            });
        }

    

    showwarrentyFn(){
        showwarrenty({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
            if (data) {
                this.wareentyis = data;
                 if( this.wareentyis=='false'){
                    this.showwarrentyinfo = true;
                 }
                 else if(this.wareentyis=='Battery' &&this.fetchstate =='US' ){
                        this.showwarrentyinfo = true;
                        this.extrawarrenty = true;
                    }
                 else if ((this.wareentyis=='Battery' && (this.fetchstate =='EN'||this.fetchstate =='CA' || this.fetchstate =='FR')) ||  (this.wareentyis='valpower')){
                    this.showwarrentyinfo = false;
                }
                this.error = undefined;
            }
        })
        .catch(error => {
            if(error){
                this.error = error;
                this.wareentyis = undefined;
            }
        });
    }

   
   
    fetchReconSupersessionNumbersFn(){
        fetchReconSupersessionNumbers({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
            if (data) {
                this.reconsuperdata = data;
                if( this.reconsuperdata[0].dbu_ReconEquivalentPartNumber__c!=null){
                    this.recondata = this.reconsuperdata[0].dbu_ReconEquivalentPartNumber__c;
                }
                if( this.reconsuperdata[0].dbu_Supersession_Number__c!=null){
                    this.supersession = this.reconsuperdata[0].dbu_Supersession_Number__c;
				    }
                this.fetchSupersessionURL(data[0].Id);
                this.error = undefined;
            } 
        })
        .catch(error => {
            if(error){
                this.error = error;
                this.recondata = undefined;
            }
        });	
    }
	
	fetchSupersessionURL(productId){  //Sandeep
		fetchReconSupersessionProducts({
			ccProductId : productId
		})
		.then(data => {
            if (data) {
				for(let i = 0; i < data.length; i++){
					let temp = {};
					temp['Name'] = data[i].ccrz__RelatedProduct__r.Name; //Sandeep 2 Dec
					temp['URL'] = window.location.origin + this.allLabels.communityname+'product/'+data[i].ccrz__RelatedProduct__r.Id+'/'+data[i].ccrz__RelatedProduct__r.Name; //Sandeep 2 Dec
					
					this.supersessionURLWrapper.push(temp);
                    this.doesSupersessionExist = true;
				}
            }
        })
        .catch(error => {
            if (error) {
            }   
        });
	}
    getCrateMetaDataFn(){
        getCrateMetaData({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
            if (data) {
                this.cratemetadata = data;
                this.error = undefined;
            }
        })
        .catch(error => {
            if (error) {
                this.error = error;
                this.cratemetadata = undefined;
            }   
        });
    }
    getProductcodeFn(){
        getProductcode({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
            if (data) {
                this.productcode = data;
                this.error = undefined;
            }
        })
        .catch(error => {
            if (error) {
                this.error = error;
                this.productcode = undefined;
             } 
        });
    }



    getStatesDataFn(){
        getStatesData({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
           if (data) {
                this.statesMtData = data;
                if (this.statesMtData != '' || this.statesMtData != undefined ||
                    this.statesMtData != 'undefined' || this.statesMtData.length != undefined) {
                    this.countryItem = [];
                    this.statesMtData.forEach(element => {
                        let itemExist = this.countryItem.some(el => el.label === element.dbu_Country__c);
                        if (!itemExist) {
                            this.countryItem.push({
                                label: element.dbu_Country__c,
                                value: element.dbu_Country_Code__c
                            });
                        }
                    });
                    this.cntryVal = this.fetchstate;
                    this.statePicklistValuArray = [];
                    this.statesMtData.forEach(element => {
                        if (element.dbu_Country_Code__c == this.cntryVal) {
                            this.statePicklistValuArray.push({
                                label: element.dbu_State__c,
                                value: element.dbu_State_Code__c
                            });
                        }
                    });
                    this.statePicklistValuArray.sort((a, b) => (a.label > b.label) ? 1 : -1);   
                }
                this.error = undefined;
            }
        })
        .catch(error => {
            if (error) {
                this.error = error;
                this.statePicklistValuesCA = undefined;
             } 
        });
    }


    @track esnPopupData;
   

    getESNPdpPopupFn(){
        getESNPdpPopup({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
            if (data) {
                this.esnPopupData = data;
                this.error = undefined;
            }
        })
        .catch(error => {
            if (error) {
                this.error = error;
                this.statePicklistValuesCA = undefined;
            } 
        });
    }

    handlecrateinput(event) {
        if (event.target.name == 'vin') {
            this.inputVIN = event.target.value;
            var vinLength =this.inputVIN;	
            if (vinLength.length<10){	
                this.invalidVIN =true;		
            }	
            else{	
               this.invalidVIN =false; 	
            }	
        }
        if (event.target.name == 'year') {
            this.inputYear = event.target.value;
            this.validateCAstatevalidation();
        }
        if (event.target.name == 'make') {
            this.inputmake = event.target.value;
        }
        if (event.target.name == 'model') {
            this.inputmodel = event.target.value;
        }
        if (event.target.name == 'state') {
            this.inputstate = event.target.value;
            if (this.inputstate == 'TX' || this.inputstate == 'WV' || this.inputstate == 'QC') {
                this.invalidstate = true;
            } else {
                this.invalidstate = false;
                this.catdata = this.statePicklistValuArray.filter(({ value }) =>
                value.includes(this.inputstate)
              );
              this.finalinputstate = this.catdata[0].label;
            }
            //sri CA Validation start
            if(this.inputstate == 'CA'){
                this.isCAStateSelected=true;
            }else{
                this.vehiclePowered='';
                this.isCAStateSelected=false;
            }//sri CA Validation end
            this. validateCAstatevalidation();
        }
    }
    handlelongdes(event) {
        this.isLoading = true;
        this.selectedaggreement = event.target.getAttribute('data-id');
        getlongdesc({
                label: this.selectedaggreement
            })
            .then(result => {
                this.longdesc = result;
                this.crateshowlongdesc = true;
                this.isLoading = false;
            })
            .catch(error => {
                this.error = error.message;
            });
    }
    handlelongdescaccept() {
        if (this.selectedcategory == 'Warranty Limitation Acknowledgement') {
            this.WarrantyAcknowledgement = true;
        }
        if (this.selectedcategory == 'Export Agreement') {
            this.ExportAgreement = true;
        }
        if (this.selectedcategory == 'Emissions Agreement') {
            this.EmissionsAgreement = true;
        }
        if (this.selectedcategory == 'Shipping Agreement') {
            this.ShippingAgreement = true;
        }
        if (this.selectedcategory == 'Unloading Agreement') {
            this.UnloadingAgreement = true;
        }
        if (this.selectedcategory == 'Terms and Conditions of Sale') {
            this.TncAgreement = true;
        }
        this.handlelongdesc();
    }
    handlelongdesc() {
        this.crateshowlongdesc = false;
    }
    handlecratecheck(event) {
        this.selectedcategory = event.target.getAttribute('data-id');
        this.inputval = event.target.checked;
        if (this.inputval == true) {        
            if (this.selectedcategory == 'Warranty Limitation Acknowledgement') {
                this.WarrantyAcknowledgement = true;
            }
            if (this.selectedcategory == 'Export Agreement') {
                this.ExportAgreement = true;                
            }
            if (this.selectedcategory == 'Emissions Agreement') {
                this.EmissionsAgreement = true;                
            }
            if (this.selectedcategory == 'Shipping Agreement') {
                this.ShippingAgreement = true;
            }
            if (this.selectedcategory == 'Unloading Agreement') {
                this.UnloadingAgreement = true;
            }
            if (this.selectedcategory == 'Terms and Conditions of Sale') {
                this.TncAgreement = true;
            }
            if (this.TncAgreement == true && this.UnloadingAgreement == true && this.ShippingAgreement == true &&
                this.EmissionsAgreement == true && this.ExportAgreement == true && this.WarrantyAcknowledgement == true) {
                this.acceptallagreements = true;
            }
        } else {
            if (this.selectedcategory == 'Warranty Limitation Acknowledgement') {
                this.WarrantyAcknowledgement = false;
            }
            if (this.selectedcategory == 'Export Agreement') {
                this.ExportAgreement = false;
            }
            if (this.selectedcategory == 'Emissions Agreement') {
                this.EmissionsAgreement = false;
            }
            if (this.selectedcategory == 'Shipping Agreement') {
                this.ShippingAgreement = false;
            }
            if (this.selectedcategory == 'Unloading Agreement') {
                this.UnloadingAgreement = false;
            }
            if (this.selectedcategory == 'Terms and Conditions of Sale') {
                this.TncAgreement = false;
            }
            this.acceptallagreements = false;
        }
    }
    openmodelCrate() {
        // Add condition for CA and Canada year vaildation  - sri 
      if(this.invalidYearforCA==false && this.invalidYearforCanada==false){
        if (this.inputVIN != '' && this.inputmake != '' && this.inputmodel != '' && this.inputYear != '' && this.inputstate != '' && this.invalidVIN ==false && this.invalidstate == false && (this.isCAStateSelected ? this.vehiclePowered &&this.vehiclePowered!='':true)) {
            this.mandate = false;
            this.opencratemodel = true;
        } else {
            this.mandate = true;
        }
    }
    }
    closemodelCrate() {
        this.opencratemodel = false;
        invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname : 'Close Crate Engine Modal'});
    }
    openmodalNotify() {
        this.openmodelNotify = true
    }
    closeModalNotify() {
        this.openmodelNotify = false;
        invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname : 'Close NotifyMe Box'});
    }

    notifyMeProductsGoogleAnalyticsDataFeed(CurrenntProductDetails, currentUserEmail) {
        let NMPFeed = {
            ProductName: CurrenntProductDetails[0].sfdcName,
            Email: currentUserEmail
        };
        invokeGoogleAnalyticsService('NOTIFY ME WHEN IN STOCK', NMPFeed);
    }

    @track openmodelNotifyInValidEmailError = false;
    handleNotifyMe(){       
        if(this.template.querySelector('.notifyEmail').value===""){
            this.openmodelNotifyError = true;
        } else {
            this.isLoading = true;            
            let inputEmail = (this.template.querySelector('.notifyEmail').value).toLowerCase();
            let mailformat =/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            
            if(inputEmail.match(mailformat)){
                this.notifyMeProductsGoogleAnalyticsDataFeed(this.productDetails, inputEmail);
                RecordNotifyMeData({
                    urlParam : window.location.href,
                    storeCountry : this.fetchstate,
                    StoreLanguage : this.sendLocBackToChangeLocTile,
                    emailaddress : inputEmail
                }).then(result => {
                    if(result){
                        this.isLoading = false;                        
                        this.showNotifyPopup = false;
                        this.openmodelNotifyError = false;
                    }else{
                        this.isLoading = false;  
                        this.showNotifyPopup = false;
                        this.openmodelNotifyError = false;
                    }
                }).catch(error => {
                    this.error = error.message;
                });
                
            }else{
                this.isLoading = false;
                this.showNotifyPopup = true;
                this.openmodelNotifyInValidEmailError = true;
            }
        }   
    }

    // to store esn data  
    handleESNchange(event) {
        this.isLoading = true;
        this.ESNval = event.target.value;
        if (this.ESNval != null && this.ESNval != '') {
            this.handlefindESN();
        }else {
            this.isLoading = false;
            this.validesn = false;
            this.template.querySelector('.esnField').classList.remove('errorField');
            }
    }

    handlefindESN() {
        ValidateUserenteredESN({
                ESN: this.ESNval,
                urlParam: this.framedproductURLforstore
            })
            .then(result => {
                this.esndata = result;
                this.isLoading = false;
                if(this.esndata == true){
                    this.ESNvalidated = true;
                    this.validesn = false;
                    this.template.querySelector('.esnField').classList.remove('errorField');
                }
                else{
                    if (this.esndata == false || this.esndata == null) {
                        this.validesn = true;
                        this.template.querySelector('.esnField').classList.add('errorField'); 
                    } else {
                        this.validesn = false;
                       
                        this.template.querySelector('.esnField').classList.remove('errorField');
                    }
                }
            })
            .catch(error => {
                this.error = error.message;
            });
    }
    // end esn 
    
   

    CheckcreateengineFn(){
        Checkcreateengine({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
            if (data) {
                this.isLoading = false;
                this.Checkcreateengine = data;
                if (this.Checkcreateengine == true) {
                    this.cratecheckbox = true;
                }
                this.error = undefined;
            }
        })
        .catch(error => {
            if (error) {
                this.isLoading = false;
                this.error = error;
                this.Checkcreateengine = undefined;
             } 
        });

    }


    handlepurchase(event) {        
        invokeGoogleAnalyticsService('NAVIGATE TO PURCHASE POLICY PAGE', 'Purchase Policy page'); 
        let urlString = window.location.origin;
        window.location.href = urlString + this.allLabels.communityName + 'purchase-agreement';
        this.purchase = window.location.href;
    }
    // related to crate engine end
    openwishlistmodal() {
        
        if (this.isGuestUser) {
            this.spinnerWishlist = true;
            this.openmodelwishlist = true;
            this.spinnerWishlist = false;  
            this.googleAnalyticsInformationPush(this.productDetails, this.productInvWrapper, this.unitPrice, 'ADD TO WISHLIST');/*CECI-958 GTM Events*/
        } else {

            /*Adding the else part for the wishlist functionality for logged in user */
            if (this.productDetails[0].sfid !== '') {
                if(!this.isAddedtoWishlist){
                    this.spinnerWishlist = true;
                    this.googleAnalyticsInformationPush(this.productDetails, this.productInvWrapper, this.unitPrice, 'ADD TO WISHLIST');/*CECI-958 GTM Events*/
                    wishlistForLoggedIn({
                        ProductId: this.productDetails[0].sfid,
                        ProductQuantity: this.valueDrpdwn,
                        dbu_SFL_OR_WL_Value: this.sendWishlist,
                        storeCountry : this.fetchstate,
                        storeLanguage : this.sendLocBackToChangeLocTile
                    }).then(result => {
                       
                        if (result.length !== 0) {
                            this.WishListText = 'Added To Your Wishlist';
                            this.wishlistIcon = 'icon-heart-select';
                            this.isAddedtoWishlist = true;
                            this.spinnerWishlist = false;
                        }
                    })
                    .catch(error => {
                        this.error = error.message;
                    });
                }

            }
        }
    }
    closewishlistModal() {
        this.openmodelwishlist = false;
        invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname : 'Close add to Wishlist signIn PopUp'});               

    }
    wishlist() {
        this.closewishlistModal();
    }
    handleChangeQuantity(event) {
        this.valueDrpdwn = event.detail.value;
        let currprdname = event.target.dataset.currentproductname;        
        const qty = event.detail.value;
        if (qty == '9+') {
            this.inputQuantity = true;
            this.valueDrpdwn = '';
            this.isInputQuantityAddToCart = true;
        }else{
            /*Aakriti CECI-693*/
            this.selectedProductQty = qty;
            this.checkAllowedQtyFn();
            invokeGoogleAnalyticsService('CHANGE PRODUCT QUANTITY', {ProductName : currprdname, productQuantity : this.valueDrpdwn, pageName : 'Product detail Page'});       
        }
    }

     //Shri Ram Dubey fetchProductById
   

    fetchProductByIdFn(){
        var newURL = this.framedproductURLforstore;
        fetchProductById({
            urlParam : this.framedproductURLforstore
        }).then(data => {
            if (data) {
                this.isLoading = false;
                this.initialLoad = true;
                this.productDetails = data;
                if(data[0].EProductMediasS != undefined && data[0].EProductMediasS != null && data[0].EProductMediasS != ''){
                    for(let i=0;i<data[0].EProductMediasS.length;i++)  {
                        if(data[0].EProductMediasS[i].mediaType == 'Product Image' && data[0].EProductMediasS[i].URI != undefined ||  data[0].EProductMediasS[i].URI != null){
                            this.imgProdUrl = data[0].EProductMediasS[i].URI;
                            break;
                        }
                    }
                }            
                if (this.productDetails[0] != undefined && this.productDetails[0].productInventoryItemsS[0] != undefined) {
                    this.stockFromInv = this.productDetails[0].productInventoryItemsS[0].qtyAvailable;
                }
                if (this.productDetails[0] != undefined) {
                    this.productavgRating = this.productDetails[0].averageRating;
                    this.hasCoreCharge = this.productDetails[0].hasCoreCharge;
                    this.coreCharge = this.productDetails[0].coreCharge;
                    this.productCodeVal = this.productDetails[0].productCode; /*Aakriti CECI-693*/
                    this.checkAllowedQtyFn(); /*Aakriti CECI-693*/
                    
                    if (this.coreCharge != undefined) {
                        this.formatedCoreCharge = perfixCurrencyISOCode(this.countryCurrencyCode,this.coreCharge)                    
                    }
                    this.totalCoreCharge = this.productDetails[0].coreCharge;
                    if (this.totalCoreCharge != undefined) {
                        this.formatedTotalCoreCharge = perfixCurrencyISOCode(this.countryCurrencyCode,this.totalCoreCharge)                   
                    }
                }
                this.error = undefined;
            }
        })
        .catch(error => {
            if (error) {
                this.isLoading = false;
                this.error = error;
                this.productSpecs = undefined;
            }
        });
    }
   
  
    // }

    fetchSpecsByProdIdFn(){
        fetchSpecsByProdId({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
            if (data) {
                this.isLoading = false; 
                this.productSpecs = data;
                if (this.productSpecs !== 'undefined' && this.productSpecs.length > 0) {
                    this.specs = true;
                }        
                this.error = undefined;
            }
        })
        .catch(error => {
            if (error) {
                this.isLoading = false;
                this.error = error;
                this.productSpecs = undefined;
            } 
        });
    }


    fetchPriceByProdIDfN(){
        fetchPriceByProdID({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
            if (data) {
                console.log('Prod Price Data is '+JSON.stringify(data[0]));
                this.isLoading = false;   
                this.productPrice = data;
                if(data!=''&& data!=null  ){
                    this.promotionCategory = data[0].promotionCategory;
                    let orPrice = data[0].originalPrice;
                    if (orPrice == null || orPrice == undefined || orPrice == data[0].price || orPrice < data[0].price) {
                        this.isOriginalPrice = false;
                    } else {    
                        this.originalPrice = perfixCurrencyISOCode(this.countryCurrencyCode,orPrice)                   
                        this.isOriginalPrice = true;
                        this.discPercent = data[0].discountPercentage;
                    }                                   
                this.unitPrice = data[0].price;
                this.totalPrice = data[0].price;
                if(data[0].hasCoreChild)
                this.hasCoreChild = true;
                //Core Charge Price Update on PDP To show sum of core and actual price of product CECI-956 - Pratyusha
                if(data[0].hasCoreCharge == true) {
                    this.sumCoreProductPrice = parseFloat(data[0].price) + parseFloat(data[0].coreCharge);
                    this.originalPrice = parseFloat(orPrice) + parseFloat(data[0].coreCharge);
                    this.discPercent = Math.round(((this.originalPrice - this.sumCoreProductPrice)/this.originalPrice)*100);
                    this.sumCoreProductPrice = perfixCurrencyISOCode(this.countryCurrencyCode,this.sumCoreProductPrice);
                    this.originalPrice = perfixCurrencyISOCode(this.countryCurrencyCode,this.originalPrice);
                    if(this.discPercent > 0){  /*Sasikanth CECI-1081 */
                        this.adjDisc= true;
                    }
                }
                this.formatedTotalPrice =  perfixCurrencyISOCode( this.countryCurrencyCode,this.totalPrice)                        
                this.formatedprice =  perfixCurrencyISOCode(this.countryCurrencyCode,this.unitPrice)
                this.error = undefined;
                }
                
            }
        })
        .catch(error => {
            if (error) {
                this.isLoading = false;
                this.error = error;
                this.productPrice = undefined;
            } 
        });

        this.GoogleAnalyticsPDPlandingPgeEventComplete = false;
    }


    fetchMessageByProdIDFn(){
        fetchMessageByProdID({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
            if (data) {
                this.isLoading = false;
                this.productMessage = data;
                this.error = undefined;
            }
        })
        .catch(error => {
            if(error) {
                this.isLoading = false;
                this.error = error;
                this.productMessage = undefined;
            } 
        });
    }



  
    fetchAttachmentsbyProdIdFn(){
        fetchAttachmentsbyProdId({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
            if (data) {
                this.isLoading = false;
                this.baseurl = window.location;    
                this.attachmentid = data;
                this.error = undefined;
            }
        })
        .catch(error => {
            if (error) {
                this.isLoading = false;
                this.error = error;
                this.productMessage = undefined;
            } 
        });
    }

  

    fetchKitProductsByProdIdFn(){
        fetchKitProductsByProdId({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
            if (data) {
                this.isLoading = false;
                let rows = JSON.parse(JSON.stringify(data));
                for (let i = 0; i < rows.length; i++) {
                    let dataParse = rows[i];
                    let prodName = dataParse.ccrz__Component__r.Name
                    if(prodName.includes('/')){
                        prodName = prodName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
                    }

                    dataParse.productUrl = window.location.origin + this.allLabels.communityName +'product/'+dataParse.ccrz__Component__r.Id +'/'+ prodName;
                }
                data = rows;           
                this.kitDetails = data;            
                this.error = undefined;
            }
        })
        .catch(error => {
            if (error) {
                this.isLoading = false;
                this.error = error;
                this.kitDetails = undefined;
             } 
        });
    }

    /*Shriram 21 October 2020*/
    

    fetchCartSizeFn(){
        fetchCartSize({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
            if (data) {
                if (this.isGuestUser && data > 0) {
                    this.isShowFirstTimeGuestUserPopup = false;
                }
            }
        })
        .catch(error => {
            if (error) {
                this.error = error;
             } 
        });
    }


    handleChangeQuantityForCart(event) {        
        let currprdname = event.target.dataset.currentproductname;
        this.updQty = this.inputQuantityAddToCart;        
        this.valueDrpdwn = event.detail.value;        
        const qty = event.detail.value;
        this.totalPrice = event.detail.value * this.unitPrice;
        this.formatedTotalPrice = perfixCurrencyISOCode(this.countryCurrencyCode,this.totalPrice)        
        this.totalCoreCharge = event.detail.value * this.coreCharge;
        this.totalCoreCharge = perfixCurrencyISOCode(this.countryCurrencyCode,event.detail.value * this.coreCharge);  
        if (qty == '9+') {
            this.isInputQuantityAddToCart = true;
        } else {
            /*Aakriti CECI-693*/
            this.selectedProductQty = qty;
            this.checkAllowedQtyFn();
            invokeGoogleAnalyticsService('CHANGE PRODUCT QUANTITY', {ProductName : currprdname, productQuantity : this.valueDrpdwn, pageName : 'Product detail Page'});
        }
    }
    invokeAddToCartGTM(updateqty,currprdname) { /*Sasikanth CECI-992 start*/
        if (this.cratecheckbox == false) {
            let dataToSendToGA = {/*CECI-958 GTM Events*/
                ProductType: 'Normal', unitPrice: JSON.stringify(this.unitPrice), quantity: updateqty, Name: currprdname, id: this.productDetails[0].SKU, storeLanguage: this.sendLocBackToChangeLocTile, storeCountry: this.fetchstate, cartOperation: 'AddToCart', originalProductPrice: this.originalPrice, cartId: this.cartId, Brand: this.prodBrandName, Category: this.prodCategoryName
            };
            this.googleAnalyticsCartOperations('AddToCart', dataToSendToGA); 
        }
        if (this.cratecheckbox == true) {
            let dataToSendToGA = {/*CECI-958 GTM Events*/
                ProductType : 'CrateEngine', unitPrice : JSON.stringify(this.unitPrice), quantity : updateqty, Name : currprdname, id : this.productDetails[0].SKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.fetchstate, cartOperation : 'AddToCart', originalProductPrice : this.originalPrice ,cartId : this.cartId, Brand: this.prodBrandName, Category: this.prodCategoryName
            };
            this.googleAnalyticsCartOperations('AddToCart', dataToSendToGA); 
        }
    } /*Sasikanth CECI-992 end*/
    invokeRemoveFromCartGTM(updateqty,currprdname) { /*Sasikanth CECI-986 start*/
        if (this.cratecheckbox == false) {
            let dataToSendToGA = {/*CECI-958 GTM Events*/
                producttype: 'Normal', productprice : JSON.stringify(this.unitPrice), productqty : updateqty, productname : currprdname, productid : this.productDetails[0].SKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.fetchstate, cartOperation : 'RemoveFromCart', originalProductPrice : this.originalPrice, cartId : this.cartId, Brand: this.prodBrandName, Category: this.prodCategoryName
            };
            this.googleAnalyticsCartOperations('RemoveFromCart', dataToSendToGA); 
        }
        if(this.hasCoreCharge){
            let dataToSendToGA = {/*CECI-958 GTM Events*/
                producttype: 'Normal', productprice : JSON.stringify(this.coreCharge), productqty : updateqty, productname : currprdname, productid : this.productDetails[0].SKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.fetchstate, cartOperation : 'RemoveFromCart', originalProductPrice : this.originalPrice, cartId : this.cartId, Brand: this.prodBrandName, Category: this.prodCategoryName
            };
            this.googleAnalyticsCartOperations('RemoveFromCart', dataToSendToGA);
        }
        if (this.cratecheckbox == true) {
            let dataToSendToGA = {/*CECI-958 GTM Events*/
                producttype : 'CrateEngine', productprice : JSON.stringify(this.unitPrice), productqty : updateqty, productname : currprdname, productid : this.productDetails[0].SKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.fetchstate, cartOperation : 'RemoveFromCart', originalProductPrice : this.originalPrice, cartId : this.cartId, Brand: this.prodBrandName, Category: this.prodCategoryName
            };
            this.googleAnalyticsCartOperations('RemoveFromCart', dataToSendToGA); 
        }
    } /*Sasikanth CECI-992 end*/
    handleChangeQuantityForCart1(event) {
        this.inputQuantityAddToCart = this.valueDrpdwn;
        this.updQty = this.valueDrpdwn;
        this.valueDrpdwn = event.detail.value;
        let currprdname = event.target.dataset.currentproductname;
        /*Aakriti CECI-693*/
        this.selectedProductQty = this.valueDrpdwn;
        if(this.inputQuantityAddToCart != undefined && this.valueDrpdwn != '9+' && parseInt(this.valueDrpdwn) > parseInt(this.inputQuantityAddToCart)) { /*Sasikanth CECI-992 start*/
            let updateqty = parseInt(this.valueDrpdwn) - parseInt(this.inputQuantityAddToCart);
            this.invokeAddToCartGTM(updateqty,currprdname);
        }/*Sasikanth CECI-992 end*/
        else if(this.inputQuantityAddToCart != undefined && parseInt(this.valueDrpdwn) < parseInt(this.inputQuantityAddToCart)) { /*Sasikanth CECI-986 start*/
            let updateqty = parseInt(this.inputQuantityAddToCart) - parseInt(this.valueDrpdwn);
            this.invokeRemoveFromCartGTM(updateqty,currprdname);
        } /*Sasikanth CECI-986 end*/
        this.checkAllowedQtyFn();
        invokeGoogleAnalyticsService('CHANGE PRODUCT QUANTITY', {ProductName : currprdname, productQuantity : this.valueDrpdwn, pageName : 'Product detail Page'});
        const qty = event.detail.value;  
        if (qty == '9+') {
            this.valueDrpdwn = '';
            this.isInputQuantityAddToCart = true;
            this.inputQuantity = true;
        } else {
            if (this.showQtyExceedError == true) { /*Aakriti CECI-693 added showQtyExceedError condition*/
                this.valueDrpdwn = this.inputQuantityAddToCart;
                return;
            }
            const qty = event.detail.value - this.inputQuantityAddToCart;
            this.totalPrice = event.detail.value * this.unitPrice;
            this.formatedTotalPrice = perfixCurrencyISOCode(this.countryCurrencyCode,this.totalPrice)           
            this.totalCoreCharge = event.detail.value * this.coreCharge;
            this.formatedTotalCoreCharge = perfixCurrencyISOCode(this.countryCurrencyCode,this.totalCoreCharge)        
            this.handleChange(event);
        }
    }
    /**Shriram 11 Oct 2020 New Method to update quantity on Add to cart Popup*/
    handleChangeAddToCartPopup(event) {
        /*Aakriti CECI-693*/
        this.selectedProductQty = this.valueDrpdwn;
        let currprdname = event.target.dataset.currentproductname;
        this.checkAllowedQtyFn();
         const qty = this.valueDrpdwn - this.inputQuantityAddToCart;
        if (qty == 0 || this.showQtyExceedError == true) { /*Aakriti CECI-693 added showQtyExceedError condition*/
            return;
        }
        this.totalPrice = this.valueDrpdwn * this.unitPrice;
        this.formatedTotalPrice  = perfixCurrencyISOCode(this.countryCurrencyCode,this.totalPrice)      
        this.totalCoreCharge = this.valueDrpdwn * this.coreCharge;
        this.formatedTotalCoreCharge = perfixCurrencyISOCode(this.countryCurrencyCode,this.totalCoreCharge) 
        this.inputQuantityAddToCart = this.valueDrpdwn;
        this.handleUpdateCartItem(qty);
        /*Sasikanth CECI-992 start*/
        if(this.updQty != undefined && this.valueDrpdwn != '9+' && parseInt(this.valueDrpdwn) > parseInt(this.updQty)) {
            let updateqty = parseInt(this.valueDrpdwn) - parseInt(this.updQty);
            this.invokeAddToCartGTM(updateqty,currprdname);
        }/*Sasikanth CECI-992 end*/
        else if(this.updQty != undefined && parseInt(this.valueDrpdwn) < this.updQty) { /*Sasikanth CECI-992 start*/
            let updateqty = parseInt(this.updQty) - parseInt(this.valueDrpdwn);
            this.invokeRemoveFromCartGTM(updateqty,currprdname);
        }
        /*Sasikanth CECI-986 end*/
    }
    handleUpdateCartItem(qty) {
        updateCartItem({
            cartItemId: this.cartItemId,
            cartId: this.cartId,
            itemPrice: this.unitPrice,
            quantity: qty,
            storeCountry : this.fetchstate
        })
        .then(result => {
            pubsub.fire('fetchcartevt', result);
        })
        .catch(error => {
            this.error = error.message;
        });
    }
    handleChange(event) {
        const qty = event.detail.value - this.inputQuantityAddToCart;
        this.totalPrice = event.detail.value * this.unitPrice;
        this.formatedTotalPrice = perfixCurrencyISOCode(this.countryCurrencyCode,this.totalPrice)       
        this.totalCoreCharge = event.detail.value * this.coreCharge;
        this.formatedTotalCoreCharge = perfixCurrencyISOCode(this.countryCurrencyCode,this.totalCoreCharge)
        this.handleUpdateCartItem(qty);
    }
    
@track productInStock;
    callInvDetails(){
        getProductInventoryDetails({
            urlParam: this.framedproductURLforstore,
            storeLocation: this.fetchstate 
        })
        .then(result => {
            this.productInvWrapper = result;  
            if(this.productInvWrapper[0].invStockData == 'In Stock'){
                this.productInStock = true;
            }else if(this.productInvWrapper[0].invStockData == 'Out of Stock'){
                this.productInStock = false;
            }
        })
        .catch(error => {             
            this.error = error.message;
        });

    }

    get options() {
        let picklistOptions = [];
        let i = 1;
        if (this.productInvWrapper[0].quantityInInv < 10 & this.cratecheckbox == false) {
            for (i = 1; i <= this.productInvWrapper[0].quantityInInv; i++) {
                picklistOptions.push({
                    label: i,
                    value: i
                });
            }
            return picklistOptions;
        } else if (this.productInvWrapper[0].quantityInInv >= 10 && this.cratecheckbox == false)
                   return getQuantityList();
        
        if (this.cratecheckbox = true) {
            return [{
                label: '1',
                value: '1'
            }]
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
    getCookieValueOfCart(name){
        var name = name + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {    
                this.cartCurrentValue = c.substring(name.length, c.length);
            }
        }
        return this.cartCurrentValue;
    }
    /*Added by Malhar - For user story 1386 - Begins - 1/12/2020 */
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
      /*Added by Malhar - For user story 1386 - ends - 1/12/2020 */
    /**11 Oct 2020 SHriram */
    handleChangeInputQuantity(event) {
        let currPrdName = event.target.dataset.currentproductname;        
        this.valueDrpdwn = event.detail.value;
        /*Aakriti CECI-693*/
        this.selectedProductQty = this.valueDrpdwn;
        this.checkAllowedQtyFn();
        invokeGoogleAnalyticsService('CHANGE PRODUCT QUANTITY', {ProductName : currPrdName, productQuantity : this.valueDrpdwn, pageName : 'Product detail Page'});
    }

    /*Aakriti CECI-693*/
    handleChangeAddToCart(){
        this.selectedProductQty = this.valueDrpdwn;
        this.checkAllowedQtyFn();
    }

    googleAnalyticsCartOperations(source, informationData){
        if(source == 'AddToCart'){
            /*CECI-958 GTM Events removed method googleAnalyticsCartFeed*/
          invokeGoogleAnalyticsService('ADD TO CART', informationData); 
        }
        else if(source == 'RemoveFromCart')
          invokeGoogleAnalyticsService('REMOVE FROM CART', informationData); 
    }    

    /*Ended here*/
    handleClickAddToCart(event) { //Commented by Shriram
        this.checkAllowedQtyFn();/*Aakriti CECI-693*/
        if(this.openmodelforESN == true)
        {
            this.isLoading = true;
        }
        this.isCartUpdatedLoader = true;
        this.totalPrice = this.unitPrice * this.valueDrpdwn;
        this.formatedTotalPrice =perfixCurrencyISOCode(this.countryCurrencyCode,this.totalPrice)
        this.totalCoreCharge = this.coreCharge * this.valueDrpdwn;
        this.formatedTotalCoreCharge =perfixCurrencyISOCode( this.countryCurrencyCode,this.totalCoreCharge)
        /* Modification by MALHAR  begin  store toggling  30/11/2020 */  
        if(this.isGuestUser){
            this.getfooterbannerCookie('footerBanner');    
            if(this.footerbannercookiestatus){
                if(this.fetchstate == this.allLabels.storeUSA){
                    this.getCookie('cartId');
                }    
                else if(this.fetchstate == this.allLabels.storeCanada){
                    this.getCookie('cartIdCA');
                }
            }else if(typeof this.footerbannercookiestatus == "undefined"){                
                this.setCartId();                              
            }            
        }
        /*Modification by MALHAR - begin - store toggling - 30/11/2020 */             
        this.inputQuantityAddToCart = this.valueDrpdwn;
        if (this.cratecheckbox == false) {
                let dataToSendToGA = {/*CECI-958 GTM Events*/
                    ProductType: 'Normal', unitPrice: JSON.stringify(this.unitPrice), quantity: parseInt(this.valueDrpdwn), Name: event.target.dataset.name, id: event.target.dataset.id, storeLanguage: this.sendLocBackToChangeLocTile, storeCountry: this.fetchstate, cartOperation: 'AddToCart', originalProductPrice: this.originalPrice, cartId: this.cartId, Brand: this.prodBrandName, Category: this.prodCategoryName
                };
                this.googleAnalyticsCartOperations('AddToCart', dataToSendToGA); 
            insertCartItem({
                    productId: event.target.dataset.id,
                    cartId: this.cartId,
                    itemPrice: this.unitPrice,
                    quantity: this.valueDrpdwn,
                    hasCoreCharge : '',
                    storeCountry : this.fetchstate,
                    coreChargeAmt : this.coreCharge,  
                    storeLanguage : this.sendLocBackToChangeLocTile
                })
                .then(result => {
                    if (this.cartId == '' || this.cartId == undefined || this.cartId == 'undefined') {
                        if (this.isGuestUser) {
                             /*Added by Malhar - for store toggling cart cookie - 30/11/2020 */ 
                             this.getfooterbannerCookie('footerBanner');
                             if(this.footerbannercookiestatus){
                                 if(this.fetchstate == this.allLabels.storeUSA){
                                     this.createCookie('cartId', result[0].ccrz__Cart__c, 7);
                                 }    
                                 else if(this.fetchstate == this.allLabels.storeCanada){
                                     this.createCookie('cartIdCA', result[0].ccrz__Cart__c, 7);
                                 }
                             }else if(typeof this.footerbannercookiestatus == "undefined"){                
                                 if(this.fetchstate == this.allLabels.storeUSA){
                                     window.sessionStorage.setItem('cartId', result[0].ccrz__Cart__c);
                                 }    
                                 else if(this.fetchstate == this.allLabels.storeCanada){
                                     window.sessionStorage.setItem('cartIdCA', result[0].ccrz__Cart__c);
                                 }                                
                             }
                        }
                        this.cartId = result[0].ccrz__Cart__c;
                    }
                    this.cartId = result[0].ccrz__Cart__c;
                    this.cartItemId = result[0].Id;
                    fetchLstCartItemsByCartIdAfterQuantityUpdate({
                            cartId: this.cartId,
                            cart: ''
                        })
                        .then(result1 => {
                            pubsub.fire('fetchcartevt', result1);
                            pubsub.fire('fetchcartevtguest', result1);
                            this.isCartUpdatedLoader = false;
                            this.isLoading = false;
                        })
                })
                .catch(error => {
                    this.error = error.message;
                });
        }
        if (this.cratecheckbox == true) {
            let dataToSendToGA = {/*CECI-958 GTM Events*/
                ProductType : 'CrateEngine', unitPrice : JSON.stringify(this.unitPrice), quantity : parseInt(this.valueDrpdwn), Name : event.target.dataset.name, id : event.target.dataset.id, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.fetchstate, cartOperation : 'AddToCart', originalProductPrice : this.originalPrice ,cartId : this.cartId, Brand: this.prodBrandName, Category: this.prodCategoryName
            };
            this.googleAnalyticsCartOperations('AddToCart', dataToSendToGA);   

            insertCartItemForCrateEngine({
                    productId: event.target.dataset.id,
                    cartId: this.cartId,
                    itemPrice: this.unitPrice,
                    quantity: this.valueDrpdwn,
                    make: this.inputmake,
                    model: this.inputmodel,
                    vin: this.inputVIN,
                    year: this.inputYear,
                    EmissionAgreement: true,
                    ExportAgreement: true,
                    ShippingAgreement: true,
                    TncAgreement: true,
                    UnloadingAgreement: true,
                    WarrentyAggrement: true,
                    storeCountry : this.fetchstate,
                    storeLanguage : this.sendLocBackToChangeLocTile ,
                    state:this.finalinputstate,
                    vehiclePowered:this.vehiclePowered// Sri CA validation

                })
                .then(result => {
                    if (this.cartId == '' || this.cartId == undefined) {
                        /*Added by Malhar - for store toggling cart cookie - 3/12/2020 */
                        if (this.isGuestUser) {                             
                            this.getfooterbannerCookie('footerBanner');   
                            if(this.footerbannercookiestatus){
                                if(this.fetchstate == this.allLabels.storeUSA){
                                    this.createCookie('cartId', result[0].ccrz__Cart__c, 7);
                                }    
                                else if(this.fetchstate == this.allLabels.storeCanada){
                                    this.createCookie('cartIdCA', result[0].ccrz__Cart__c, 7);
                                }
                            }else if(typeof this.footerbannercookiestatus == "undefined"){                
                                if(this.fetchstate == this.allLabels.storeUSA){
                                    window.sessionStorage.setItem('cartId', result[0].ccrz__Cart__c);
                                }    
                                else if(this.fetchstate == this.allLabels.storeCanada){
                                    window.sessionStorage.setItem('cartIdCA', result[0].ccrz__Cart__c);
                                }                                
                            }   
                        }
                        this.cartId = result[0].ccrz__Cart__c;                        
                        /*Added by Malhar - for store toggling cart cookie - 3/12/2020 */  
                     }
                     this.cartId = result[0].ccrz__Cart__c;
                     this.cartItemId = result[0].Id;
                    fetchLstCartItemsByCartIdAfterQuantityUpdate({
                            cartId: this.cartId,
                            cart: ''
                        })
                        .then(result1 => {
                            pubsub.fire('fetchcartevt', result1);
                            pubsub.fire('fetchcartevtguest', result1);
                            this.isCartUpdatedLoader = false;
                            this.isLoading = false;
                        })
                })
                .catch(error => {
                    this.error = error.message;
                });
        }
    }
    regiser() {
        pubsub.register('fetchcartevtguest', this.handleEvent.bind(this));
        pubsub.register('sendDataTolstProdDetailspage', this.handleEventLoc.bind(this));
    }
    handleEvent(event) {
        this.openAddToCartModal();
    }
    handleClickKit(event) {
        this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: 'dbu_product__c'
                },
                state: {
                    'pId': event.target.dataset.id 
                }
            },
            true 
        );
    }
    get calculatedStarRating() {
        var mapObj = new Map();
        mapObj.set(0, "star-ratingsZero");
        mapObj.set(1.0, "star-ratingsOne");
        mapObj.set(1.1, "star-ratingsOne-POne");
        mapObj.set(1.2, "star-ratingsOne-PTwo");
        mapObj.set(1.3, "star-ratingsOne-PThree");
        mapObj.set(1.4, "star-ratingsOne-PFour");
        mapObj.set(1.5, "star-ratingsOne-PFive");
        mapObj.set(1.6, "star-ratingsOne-PSix");
        mapObj.set(1.7, "star-ratingsOne-PSeven");
        mapObj.set(1.8, "star-ratingsOne-PEight");
        mapObj.set(1.9, "star-ratingsOne-PNine");
        mapObj.set(2.0, "star-ratingsTwo");
        mapObj.set(2.1, "star-ratingsTwo-POne");
        mapObj.set(2.2, "star-ratingsTwo-PTwo");
        mapObj.set(2.3, "star-ratingsTwo-PThree");
        mapObj.set(2.4, "star-ratingsTwo-PFour");
        mapObj.set(2.5, "star-ratingsTwo-PFive");
        mapObj.set(2.6, "star-ratingsTwo-PSix");
        mapObj.set(2.7, "star-ratingsTwo-PSeven");
        mapObj.set(2.8, "star-ratingsTwo-PEight");
        mapObj.set(2.9, "star-ratingsTwo-PNine");
        mapObj.set(3.0, "star-ratingsThree");
        mapObj.set(3.1, "star-ratingsThree-POne");
        mapObj.set(3.2, "star-ratingsThree-PTwo");
        mapObj.set(3.3, "star-ratingsThree-PThree");
        mapObj.set(3.4, "star-ratingsThree-PFour");
        mapObj.set(3.5, "star-ratingsThree-PFive");
        mapObj.set(3.6, "star-ratingsThree-PSix");
        mapObj.set(3.7, "star-ratingsThree-PSeven");
        mapObj.set(3.8, "star-ratingsThree-PEight");
        mapObj.set(3.9, "star-ratingsThree-PNine");
        mapObj.set(4, 0, "star-ratingsFour");
        mapObj.set(4.1, "star-ratingsFour-POne");
        mapObj.set(4.2, "star-ratingsFour-PTwo");
        mapObj.set(4.3, "star-ratingsFour-PThree");
        mapObj.set(4.4, "star-ratingsFour-PFour");
        mapObj.set(4.5, "star-ratingsFour-PFive");
        mapObj.set(4.6, "star-ratingsFour-PSix");
        mapObj.set(4.7, "star-ratingsFour-PSeven");
        mapObj.set(4.8, "star-ratingsFour-PEight");
        mapObj.set(4.9, "star-ratingsFour-PNine");
        mapObj.set(5.0, "star-ratingsFive");
        if (mapObj.has(this.productavgRating)) {
            return mapObj.get(this.productavgRating);
        } else {
            return "star-ratingsZero";
        }
    }
    openAddToCartModal() {
        // to open modal set isModalOpen tarck value as true
        this.isAddToCartModalOpen = true;
        this.opencratemodel = false;
        this.openmodelforESN = false;
    }
    closeAddToCartModal() {
        // to close modal set isModalOpen tarck value as false
        this.isAddToCartModalOpen = false;
        invokeGoogleAnalyticsService('CONTINUE SHOPPING CLICKS', {eventname : 'Added to cart'});
    }
    openModelForGuestCart() {
        // to open modal set isModalOpen tarck value as true
        this.isShowFirstTimeGuestUserPopup = false;
        this.isOpenModelForGuestCart = true;
    }
    closeModelForGuestCart() {
        // to close modal set isModalOpen tarck value as false
        this.isOpenModelForGuestCart = false;
        invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname : 'Added to cart'});
        setTimeout(() => {
            this.openAddToCartModal();
        }, 500);
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isAddToCartModalOpen = false;
    }

    zoomPopup() {
        if (this.zoomPopupWindow) {
            this.zoomPopupWindow = false;
        } else {
            this.zoomPopupWindow = true;
        }
    }
    createCookieData(name, value, days) {
        var expires;	
        let ids = this.getproductidfromURL();	
        var idsArray = [];	
        idsArray.push(ids);	
        idsArray.push(localStorage.getItem('ProductIdessss'));	
        localStorage.setItem('ProductIdessss', idsArray);	
        if (days) {	
            var date = new Date();	
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));	
            expires = "; expires=" + date.toGMTString();	
        } else {	
            expires = "";	
        }	
        document.cookie = name + "=" + escape(value) + expires + "; path=/";
    }
    @track relatedProductData = [];
    @track totalProductPrice = 0.0;
    @track mapObjOfProduct = [];
    @track dataFlag = false;
    @track productIDToNameMapping = new Map();


    getRelatedProductListFn(){
        getRelatedProductList({
            urlParam: this.framedproductURLforstore
        })
        .then(data => {
            if (data) {         
                for (let i = 0; i < data.length; i++) {
                    if (data[i].productType == 'Complementary') {
                        this.relatedProductData.push(data[i]);
                        this.dataFlag = true;
                        this.productIDToNameMapping.set(data[i].id, data[i].Name);
                    }
                }            
            }
        })
        .catch(error => {
            if (error) {
                this.isLoading = false;
                this.error = error;
                window.alert(' this.error > ' + this.error );
             } 
        });
    }


    frequentlyBoughtProductsGoogleAnalyticsFeed(operation, productName, productPrice, currencyCode){
        let FGPGoogleAnalyticsFeed = {FGPoperation : operation,
                       FGPproductName : productName,
                       FGPProductPrice : currencyCode + productPrice};
        
        invokeGoogleAnalyticsService('FREQUENTLY BOUGHT PRODUCTS SELECTION', FGPGoogleAnalyticsFeed);
    }


    @track productMapObj = new Map();
    @track countProduct = 0;
    
    handlePrice(event) {
        var pId = event.target.getAttribute('data-id');
        var productName = event.target.getAttribute('data-productname');  
        var price = event.target.getAttribute('data-price');

        if (this.productMapObj.has(pId)) {
            this.frequentlyBoughtProductsGoogleAnalyticsFeed('deselected', productName, price, this.countryCurrencyCode);            
            this.productMapObj.delete(pId);
            this.countProduct--;
            this.totalProductPrice = this.totalProductPrice - Number(price);
            this.priceTotal =  perfixCurrencyISOCode(this.countryCurrencyCode,this.totalProductPrice)
            if(this.countryCurrencyCode == this.allLabels.currencyCodeUSA){
                if (this.priceTotal == '-$0.00') {
                    this.priceTotal = '$0.00';
                }
            }else if(this.countryCurrencyCode == this.allLabels.currencyCodeCanada){
                if (this.priceTotal == '-CAD$0.00') {
                    this.priceTotal = 'CAD$0.00';
                }
            }
        } else {
            this.frequentlyBoughtProductsGoogleAnalyticsFeed('selected', productName, price, this.countryCurrencyCode);
            this.totalProductPrice += Number(price);
            this.priceTotal= perfixCurrencyISOCode(this.countryCurrencyCode,this.totalProductPrice)
            
            this.countProduct++;
            this.productMapObj.set(pId, price);
        }
    }

    @track FreqBgtProdAddToCartInvokedFlag = false;
    @track FreqBgtdisplayMessage;
    @track isFreqBgtModalOpen; 
    @track FreqBgtrecordUpdate;     
    handleAddFreqBoughtProductToCart(event){
        this.isLoading = true;
        let FrequentLyBoughtProductIDList = Array.from(this.productMapObj.keys());
        if(FrequentLyBoughtProductIDList.length > 0){
            this.FreqBgtProdAddToCartInvokedFlag = true;
  
        if (this.isGuestUser) {  
            this.getCartIDforGuestandLoggedinUser();        
            if(this.cartId == null || this.cartId == undefined || typeof this.cartId == "undefined" || this.cartId == '' || this.cartId.length === 0){
                this.cartId = '';    
            }
            let gaDatafd = {proIdMap : this.productIDToNameMapping, proPriceMap : this.productMapObj, lang : this.sendLocBackToChangeLocTile, country : this.fetchstate};      
            insertFrequentlyBougthProducts({     
                ProductIdList : JSON.stringify(FrequentLyBoughtProductIDList),                   
                CartId : this.cartId,
                storeCountry : this.fetchstate,
                storeLanguage : this.sendLocBackToChangeLocTile 
            }).then(freqBgtinsertResult  => {
                if(freqBgtinsertResult.CartId != null){                    
                        if(this.cartId == null || this.cartId == undefined || typeof this.cartId == "undefined" || this.cartId == '' || this.cartId.length === 0){           
                            this.cartId = freqBgtinsertResult.CartId;    

                            if(this.footerbannercookiestatus){
                                if(this.fetchstate == this.allLabels.storeUSA){
                                    this.createCookie('cartId', this.cartId, 7);
                                    
                                }    
                                else if(this.fetchstate == this.allLabels.storeCanada){
                                    this.createCookie('cartIdCA', this.cartId, 7);
                                    
                                }
                            }else if(typeof this.footerbannercookiestatus == "undefined"){                
                                if(this.fetchstate == this.allLabels.storeUSA){
                                    window.sessionStorage.setItem('cartId', this.cartId);
                                }    
                                else if(this.fetchstate == this.allLabels.storeCanada){
                                    window.sessionStorage.setItem('cartIdCA', this.cartId);
                                }                                
                            }                                                                                  
                        }                                    
                }
                if(this.cartId != ''){
                    fetchLstCartItemsByCartIdAfterQuantityUpdate({
                        cartId : this.cartId,
                        cart : ''
                    }).then(result => {
                        pubsub.fire('fetchcartevt', result);
                        this.FreqBgtProdModalCtrl(freqBgtinsertResult);
                    }).catch(error => {
                        this.error = error.message;
                    });
                }else if(this.cartId == ''){
                    this.FreqBgtProdModalCtrl(freqBgtinsertResult);
                }                
            }).catch(error => {
                this.error = error.message;
            })           
            invokeGoogleAnalyticsService('FREQUENTLY BOUGHT ADD TO CART', gaDatafd);
        }else if (!this.isGuestUser){           
            fetchCartId({
                storeCountry : this.fetchstate
            })
            .then(result => { 
                    this.cartId = result;                    
                    if(this.cartId != null){
                    }else if (this.cartId == null){
                        this.cartId = '';
                    }
                    let gaDatafdd = {proIdMap : this.productIDToNameMapping, proPriceMap : this.productMapObj, lang : this.sendLocBackToChangeLocTile, country : this.fetchstate};                          
                    insertFrequentlyBougthProducts({
                        ProductIdList : JSON.stringify(FrequentLyBoughtProductIDList),  
                        CartId : this.cartId,
                        storeCountry : this.fetchstate,
                        storeLanguage : this.sendLocBackToChangeLocTile 
                    }).then(freqBgtinsertResult  => {                      
                        if(freqBgtinsertResult.CartId != null){
                            if(this.cartId != null){
                                this.cartId = freqBgtinsertResult.CartId;
                            } 
                        }                                                                   
                        if(this.cartId != ''){
                            fetchLstCartItemsByCartIdAfterQuantityUpdate({
                                cartId : this.cartId,
                                cart : ''
                            }).then(result => {
                                pubsub.fire('fetchcartevt', result);
                                this.FreqBgtProdModalCtrl(freqBgtinsertResult);
                            }).catch(error => {
                                this.error = error.message;
                            }); 
                        }else if(this.cartId == ''){
                            this.FreqBgtProdModalCtrl(freqBgtinsertResult);
                        }
                    }).catch(error => {
                        this.error = error.message;
                    })                       
                    this.error = undefined;
                    invokeGoogleAnalyticsService('FREQUENTLY BOUGHT ADD TO CART', gaDatafdd);
            })
            .catch(error => {
                    this.error = error.message;
            }); 
        }
    }else{
        this.isLoading = false;
    }
    }

    clearCheckBoxes(){
        var selClass = this.template.querySelectorAll('.fbcheckbox');

        for (var s = 0; s < selClass.length; s++) {
            selClass[s].checked=false;
        }
        this.productMapObj = new Map();
        this.countProduct = 0;  
        this.totalProductPrice = 0.0;
        if(this.countryCurrencyCode == this.allLabels.currencyCodeUSA){
                this.priceTotal = '$0.00';
        }else if(this.countryCurrencyCode == this.allLabels.currencyCodeCanada){
                this.priceTotal = 'CAD$0.00';
        }                 
    }

    closeFreqBgtModal(){
        this.isFreqBgtModalOpen = false; 
        this.unDisplayProceedToCartbtn = false;
        invokeGoogleAnalyticsService('CONTINUE SHOPPING CLICKS', {eventname : 'Frequently Bought Products - Added to cart'});
    }    

    @track unDisplayProceedToCartbtn = false;
    FreqBgtProdModalCtrl(freqBgtinsertResultReturned){
        if(freqBgtinsertResultReturned.ProductsInserted.length > 0 && 
            this.FreqBgtProdAddToCartInvokedFlag == true && 
            freqBgtinsertResultReturned.ProductsNotInserted.length == 0)
                this.FreqBgtdisplayMessage = 'Products added to cart successfuly.';
        
        else if(freqBgtinsertResultReturned.ProductsInserted.length == 0 && 
            this.FreqBgtProdAddToCartInvokedFlag == true &&  
            freqBgtinsertResultReturned.ProductsNotInserted.length > 0){
                this.FreqBgtdisplayMessage = 'Crate engine, Core products and out of stock products cannot be added to cart.';
                this.unDisplayProceedToCartbtn = true;
        }
        else if(freqBgtinsertResultReturned.ProductsInserted.length == 0 && 
            this.FreqBgtProdAddToCartInvokedFlag == true &&  
            freqBgtinsertResultReturned.ProductsNotInserted.length == 0){    
                this.FreqBgtdisplayMessage = 'Crate engine, Core products and out of stock products cannot be added to cart.';
                this.unDisplayProceedToCartbtn = true;
        }
        else if(freqBgtinsertResultReturned.ProductsInserted.length > 0 && 
            this.FreqBgtProdAddToCartInvokedFlag == true &&  
            freqBgtinsertResultReturned.ProductsNotInserted.length > 0)
                this.FreqBgtdisplayMessage = 'Products added to cart successfuly.Crate engine, Core products and out of stock products cannot be added to cart.';                
        
        this.isLoading = false;
        this.FreqBgtrecordUpdate = this.FreqBgtdisplayMessage;
        this.isFreqBgtModalOpen = true;
        this.clearCheckBoxes();
    }    

    navigateToPurchaseUrl(){
        invokeGoogleAnalyticsService('NAVIGATE TO PURCHASE POLICY PAGE', 'Purchase Policy page');    
    }

    get gotopurchasepolicyUrl(){
        return  this.purchase;
    }

    navigateToCraitequickstartguide(){
        invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open crate start guide');    
    }

    get gotoCrateQuickStartGuidepdf(){
        return this.CrateQuickStartGuidepdf;
    }

    navigateToCrateEngineBroucher(){
        invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open crate engine Broucher');            
    }

    get gotocrateenginebroucher(){
        return this.CrateBrochurepdf;
    }

    navigateToCrateengineInstallationguide(){
        invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Open crate engine installation pdf');            
    }

    get gotocrateengineinstallationguide(){
        return this.CrateinstallationGuide;
    }
    
    handleClickFreProduct(event) {
        var pId = event.target.getAttribute('data-id');
        var pName = event.target.getAttribute('data-name');
        let productName = pName.toLowerCase();
        let urlString = window.location.origin;
        if(productName.includes('/')){
            productName = productName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
        }
        let urls = urlString+this.allLabels.communityName+'product/'+ pId +'/'+ productName;
        window.location.href = urls;       
    }

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isLocateModalOpen = true;
        invokeGoogleAnalyticsService('OPEN MODALS', {eventname : 'How to find your Model & spec number link click'});
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isLocateModalOpen = false;
        invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname : 'Close How to find your Model & spec number Modal'});
    }
    openESNModal(){
        this.enableESNpopup = true;
        invokeGoogleAnalyticsService('OPEN MODALS', {eventname : 'How to find your ESN link click'});
    }
    closeESNModal(){        
        this.enableESNpopup = false;
        invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname : 'Close ESN popup'});
    }

    getCartIDforGuestandLoggedinUser(){            
        /*Modification by MALHAR - begin - store toggling - 30/11/2020 */
        this.getfooterbannerCookie('footerBanner');
        if(this.footerbannercookiestatus){                
            if(this.fetchstate == this.allLabels.storeUSA){    
                let UScartidInSessionStorage = window.sessionStorage.getItem('cartId');
                this.getCookie('cartId');
                if(UScartidInSessionStorage !== null && (typeof this.cartId == "undefined" || this.cartId.length === 0)){
                    this.cartId = UScartidInSessionStorage;
                    this.createCookie('cartId', this.cartId, 7);
                    window.sessionStorage.removeItem('cartId');
                }
            }    
            else if(this.fetchstate == this.allLabels.storeCanada){                 
                let CAcartidInSessionStorage = window.sessionStorage.getItem('cartIdCA');                   
                this.getCookie('cartIdCA');
                if(CAcartidInSessionStorage !== null && (typeof this.cartId == "undefined" || this.cartId.length === 0)){
                    this.cartId = CAcartidInSessionStorage;
                    this.createCookie('cartIdCA', this.cartId, 7);
                    window.sessionStorage.removeItem('cartIdCA');
                }
            }
        }else if(typeof this.footerbannercookiestatus == "undefined"){                
            this.setCartId();                                
        }        	
}

/*Aakriti CECI-693*/
checkAllowedQtyFn(){
    let productAllowedQty = this.allLabels.dbu_product_max_allowed_qty.toLowerCase();
    let currProductCodeVal = this.productCodeVal.toLowerCase();
    if(productAllowedQty.includes(currProductCodeVal)){
        var getAllowedQtyJSON = {};
        var allowedQtyArr = productAllowedQty.split(',');
        for(var i=0; i < allowedQtyArr.length; i++){
            allowedQtyArr[i] = allowedQtyArr[i].trim();
            getAllowedQtyJSON[allowedQtyArr[i].split(':')[0]] = parseInt(allowedQtyArr[i].split(':')[1]);
        };
        this.maxAllowedQty = getAllowedQtyJSON[currProductCodeVal];
        this.hasQtyValidationError = true;
        if(parseInt(this.selectedProductQty) > this.maxAllowedQty){
            this.showQtyExceedError = true;
            let errorInputs = this.template.querySelectorAll(".productDetail_Combo");
            errorInputs.forEach(inp => inp.classList.add("qtyInputError"));
        }
        else{
            this.showQtyExceedError = false;
            let errorInputs = this.template.querySelectorAll(".productDetail_Combo");
            errorInputs.forEach(inp => inp.classList.remove("qtyInputError"));
        }
    }
}
}