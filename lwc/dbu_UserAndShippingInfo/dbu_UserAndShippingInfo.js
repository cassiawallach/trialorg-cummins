import {
    LightningElement,
    track,
    api,
    wire
} from 'lwc';
import Checkcreateengine from '@salesforce/apex/dbu_ProductCtrl.Checkcreateengine';
import insertUserInfo from '@salesforce/apex/dbu_CheckOutCntrl.insertUserInfo';
import insertShippingInfo from '@salesforce/apex/dbu_CheckOutCntrl.insertShippingInfo';
import insertBillingInfo from '@salesforce/apex/dbu_CheckOutCntrl.insertBillingInfo';
import fetchLstCartItemsByCartId from '@salesforce/apex/dbu_CartCtrl.fetchLstCartItemsByCartId';
import getAddressVerify from '@salesforce/apex/dbu_Integration_EDQ.getAddressVerify';
import searchicon from '@salesforce/resourceUrl/HeaderSearchIcon';
import pubsub from 'c/pubsub';
import updateShippingAmountOnCart from '@salesforce/apex/dbu_CheckOutCntrl.updateShippingAmountOnCart';
import fetchCCAddressShipping from '@salesforce/apex/dbu_LoggedInUsrCntrl.fetchCCAddressShipping';
import fetchCCAddressBilling from '@salesforce/apex/dbu_LoggedInUsrCntrl.fetchCCAddressBilling';
import shippingAddressData from '@salesforce/apex/dbu_LoggedInUsrCntrl.shippingAddressData';
import billingAddressData from '@salesforce/apex/dbu_LoggedInUsrCntrl.billingAddressData';
import Id from '@salesforce/user/Id';
import fetchCustomerInfoDetails from '@salesforce/apex/dbu_CustomerInfoDetailsCtrl.fetchCustomerInfoDetails';
import getShiptoBilltoData from '@salesforce/apex/dbu_CheckOutCntrl.getShiptoBilltoData';
import updateCCAddress from '@salesforce/apex/dbu_CheckOutCntrl.updateCCAddress';
import isGuest from '@salesforce/user/isGuest';
import fetchCartId from '@salesforce/apex/dbu_CartCtrl.fetchCartId';
import getStatesData from '@salesforce/apex/dbu_CustomsettingCntrl.getStatesData';
import insertPickUpStoreDataInCCObj from '@salesforce/apex/dbu_CheckOutCntrl.insertPickUpStoreDataInCCObj';
import { getListOfAddresses, getSelectedAddress } from "c/serviceComponent";
import { perfixCurrencyISOCode } from 'c/serviceComponent';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import getLabels from 'c/dbu_custLabels' // CECI-1099 component optimization Import Custom Labels

export default class Dbu_UserAndShippingInfo extends LightningElement {

    userId = Id;
    @track allLabels = getLabels.labels; // CECI-1099 component optimization Referring CustomLabels

    @track location = [];
    @track isguestuser = isGuest;
    @track AccountData;
    //@track showGeoData = true;
    @track mandateFlag = false;
    @track valueDrpdwn = '';
    @track valueDrpdwnBil = '';
    @track valueDrpdwnMap = '';
    @track stateValMap = '';
    @track storeCdeVal = '';
    @track signInURL = this.allLabels.loginInURL;
    @track goToOrderReviewPage;
    @track shipSelected = true;
    @track sameShipAddSelected = false;
    @track pickUpSelected = false;

    @track userDetails = [];
    @track firstname = '';
    @track lastname = '';
    @track emailVal = '';
    @track phoneVal = '+1 ';
    @track cmpnameVal = '';
    
    @track shippingDetails = [];
    @track add1Val = '';
    @track add2Val = '';
    @track cityVal = '';
    @track stateVal = '';
    @track zipVal = '';
    @track cntryVal = '';
  
    @track billingDetails = [];
    @track add1ValBil = '';
    @track add2ValBil = '';
    @track cityValBil = '';
    @track stateValBil = '';
    @track zipValBil = '';
    @track cntryValBil = '';
   

    @track location = [];
    @api latFieldApiName;
    @api longFieldApiName;
    @track cartId;

    @track goToPaymentURL;
    @track accounts;
    @track mapDataAccounts;
    @track error;
    iconsearch = searchicon + '#searchIcon';

    @track searchData;
    @track errorMsg = '';
    @track showErrorMsg = false;
    @track strSearchAccName = '';

    @track showBillingCCAddress = false;


    @track cartDetails;
    @track isLoading = true

    @track shippingRates;

    @track weight;

    @track storeLocData;
    @track totalAmount;
    @track cartDiscountAmount = '0.00';
    @track cartOriginalAmount = '0.00';
    @track cartSubtotalAmount = '0.00';
    @track cartTotalAmount = '0.00';

    shippingId;
    billingId;
    pobox; // Added by Sri

    @track standardshipping = false;
    @track standardShippingValue;
    @track freeShipping = false;
    @track freeShippingValue;
    @track flatRateWgt100To149 = false;
    @track flatRateWgt100To149Value;
    @track flatRateBelow100 = false;
    @track flatRateBelow100Value;
    @track flatRateGreaterThan150 = false;
    @track flatRateGreaterThan150Value;
    
    @track addressPopup = false;
    @track responseData;
    @track add1RespData;
    @track addressVerifiedData;
    @track locationFirstIndex = [];
    @track AddressLine1txtRes;
    @track AddressLine2txtRes;
    @track CityIDRes;
    @track StateIDRes;
    @track ZipCodeIDRes;
    @track CountryIDRes;
    @track errorFlag;
    @track errorFlagNo = false;;
    @track errorFlagYes = false;
    @track errorDescRes;

    @track responseDataBilling;
    @track errorFlagBillingFromRes;
    @track errorFlagBillingYes = false;
    @track errorDescResBil;
    @track AddressLine1txtResBil;
    @track AddressLine2txtResBil;
    @track CityIDResBil;
    @track StateIDResBil;
    @track ZipCodeIDResBil;
    @track CountryIDResBil;
   
    @track ccAddressData = [];
    @track showCCAddress = false;
    @track ccAddressChecked = false;
    @track addressline1Val = '';
    @track addressline2Val = '';
    @track addresscity = '';
    @track addressstate = '';
    @track addresspostalcode = '';
    @track addresscountry = '';
    @track ccAddressDataBilling = [];
   
    @track amount;
    @track freeShipping = false;
    @track freeShippingValue;
    @track flatRateWgt100To149 = false;
    @track flatRateWgt100To149Value;
    @track flatRateBelow100 = false;
    @track flatRateBelow100Value;
    @track flatRateGreaterThan150 = false;

    @track ccAddressDataDefaultListShipping;
    @track ccAddressDataDefaultListBilling;

    @track storeLocDataFromCS = '';
    @track usLoc = false;
    @track usLocBil = false;
    @track statePicklistValues = '';
    @track statePicklistValuArray = [];
    @track statesPicklistForMap = [];
    @track arrayValues = '';

    @track statePicklistValuesCA = '';
    @track arrayValuesCA = '';

    @track showStateUSPicklist = false;
    @track showStateCAPicklist = false;
    @track statePicklistValuArrayCA = [];
    @track defaultvalue = true;
    @track statePicklistValuArrayBil = [];
    @track showManageAddress = false;
    @track statesMtData;

    @track addressLoaded = false;
    @track addressLoadedBill = false;

    @track isAvailableToPickUp = false;
    @track isAvailableToShip = false;
    @track showPopUpwithShipOnlyMsg = false;
    @track showPopUpwithPickUpMsg = false;
    @track customerinfo;



    @track checkuserdata = false;
    @track getShiptoBillto;
    @track billToIdCC;
    @track shipToIdCC;
    @track pickUpIdCC;
    //@track currencyValue = 'USD';
    @track storeLocationText = 'en-US';
    @track countryList = [];
    @track countryItem = [];
    @track countryOptionsNew = [];
    @track currentPageNumber = 1;
    @track maximumPageNumber;
    @track numberOfRecordsToDisplay = 5;
    @track storeLocationsToDisplay = [];
    @track countryCurrencyCode;
    @track currentStorelocation;
    @track showAddOnClickFrmOrdrRev = true;

    @track returnAndRefumdURL; //Added By Dhiraj for Return & Refund Policy.


    //Added for managing save for later
    @track shipToList = [];
    @track pickOnlyList = [];
    @track cartItemShipOnlyID = [];
    @track cartItemPickUpID = [];
    @track cartIDSFL;
    @track footerbannercookiestatus;
 
    @track showCookiePolicyModel;

    @track crateEngineProduct=false //Sri

    // added by saikomal for crate check
    @track cratecheckbox = false;
    @track crateEngineProduct=false; //Sri

    // Shipping Cost
    @track EstimatedShippingAmount;

    @track addressResults;
    @track selectedAddress;
    @track bilTypeAddress = false;
    @track shipTypeAddress = false;

    get ScreenLoaded() {
        return this.isLoading;
    }

    // CECI-1099 component optimization changed labels to this.allLabels
    connectedCallback() {
        let urlString = window.location.origin;
        this.goToOrderReviewPage = urlString + this.allLabels.communityName + 'dbu-orderreview';
        this.goToPaymentURL = urlString + this.allLabels.communityName + 'payment?catId=' + this.cartId;
        this.standardShippingValue = this.allLabels.standardShippingData;
        this.freeShippingValue = this.allLabels.freeShippingData;
        this.flatRateWgt100To149Value = this.allLabels.flatRateWgt100To149Data;
        this.flatRateBelow100Value = this.allLabels.flatRateBelow100Data;
        this.flatRateGreaterThan150Value = this.allLabels.flatRateGreaterThan150Data;
        this.template.addEventListener('click',this.escapeStructure.bind(this)); //CECI-772 added bind(this)
        if (!this.addressLoaded) {
            fetchCCAddressShipping()
                .then(result1 => {
                    if (result1) {
                        let loggedInUsrData = [];
                        loggedInUsrData = result1;
                        console.log('data in cc address>>>' + JSON.stringify(result1));

                        for (let i = 0; i < loggedInUsrData.length; i++) {
                            if (loggedInUsrData[i].country == this.currentStorelocation) {
                                this.ccAddressData.push(loggedInUsrData[i]);
                            }
                        }                        
                        if (this.ccAddressData.length > 0) {
                            console.log('this.ccAddressData > '+ JSON.stringify(this.ccAddressData));
                            this.showManageAddress = true;
                        } else if (this.ccAddressData.length === 0) {
                            this.showManageAddress = false;
                        }
                        console.log('  this.showManageAddress > ' +   this.showManageAddress );
                        this.error = undefined;
                        
                    }
                }).catch(error => {
                    this.error = error.message;
                    console.log('result from addressbook error ', JSON.stringify(this.error));
                });
            this.addressLoaded = true;
        }
        if (!this.addressLoadedBill) {
            fetchCCAddressBilling()
                .then(resultBill => {
                    if (resultBill) {
                        let loggedinUserDataBiling = [];
                        loggedinUserDataBiling = resultBill;

                        for (let i = 0; i < loggedinUserDataBiling.length; i++) {
                            if (loggedinUserDataBiling[i].country == this.currentStorelocation) {
                                this.ccAddressDataBilling.push(loggedinUserDataBiling[i]);
                            }
                        }
                        console.log('  this.showManageAddress > ' +   this.showManageAddress );

                        this.error = undefined;
                    }
                }).catch(error => {
                    this.error = error.message;                    
                });
            this.addressLoadedBill = true;
        }
        

        this.isLoading = false;
        this.regiser();
        let locationURL = window.location.href;
        var url = new URL(locationURL);
        this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');

        if (url.searchParams.get("pickupSelected") == 'false') {
            this.showAddOnClickFrmOrdrRev = false;
        } else if (url.searchParams.get("pickupSelected") == 'true') {
            this.showAddOnClickFrmOrdrRev = false;
        } else if (url.searchParams.get("pickupSelected") == undefined || url.searchParams.get("pickupSelected") == '') {
            this.showAddOnClickFrmOrdrRev = true;
        }


        pubsub.fire('sendLocToStore', this.sendLocBackToChangeLocTile);
        if (this.sendLocBackToChangeLocTile == this.allLabels.storeUSA || this.sendLocBackToChangeLocTile == null ||
            this.sendLocBackToChangeLocTile == undefined || this.sendLocBackToChangeLocTile == '') {
            this.countryCurrencyCode = this.allLabels.currencyCodeUSA;
            this.currentStorelocation = this.allLabels.storeUSA;
            this.sendLocBackToChangeLocTile = this.allLabels.storeUSA;
            
            this.cntryVal = this.allLabels.storeUSA;
            if (this.cntryVal == this.allLabels.storeUSA) {
                this.usLoc = true;
            }
            this.cntryValBil = this.allLabels.storeUSA;
            if (this.cntryValBil == this.allLabels.storeUSA) {
                this.usLocBil = true;
            }
           
        } else if (this.sendLocBackToChangeLocTile == this.allLabels.storeCA || this.sendLocBackToChangeLocTile == this.allLabels.storeCAF) {
            this.countryCurrencyCode = this.allLabels.currencyCodeCanada;
            this.currentStorelocation = this.allLabels.storeCanada;
            this.cntryVal = this.allLabels.storeCanada;

            
            if (this.cntryVal == this.allLabels.storeCanada) {
                this.usLoc = false;
            }
            this.cntryValBil = this.allLabels.storeCanada;
            if (this.cntryValBil == this.allLabels.storeCanada) {
                this.usLocBil = false;
            }

            
        }
        /**27 Oct 2020: New Logic to Handle cartId in case of loggeduser && GuestUser*/
        if (this.isguestuser) {
            
            this.getfooterbannerCookie('footerBanner');
            if (this.footerbannercookiestatus) {
                if (this.currentStorelocation == this.allLabels.storeUSA) {
                    this.getCookie('cartId');
                }
                else if (this.currentStorelocation == this.allLabels.storeCanada) {
                    this.getCookie('cartIdCA');
                }
            } else if (typeof this.footerbannercookiestatus === "undefined") {
                if (this.currentStorelocation == this.allLabels.storeUSA) {
                    this.cartId = window.sessionStorage.getItem('cartId');
                }
                else if (this.currentStorelocation == this.allLabels.storeCanada) {
                    this.cartId = window.sessionStorage.getItem('cartIdCA');
                }
            }
            this.fetchLstCartItemsByCartIdFn();
        } else {
            fetchCartId({
                storeCountry: this.currentStorelocation
            })
                .then(result => {
                    this.cartId = result;
                    this.error = undefined;
                    this.fetchLstCartItemsByCartIdFn();
                })
                .catch(error => {
                    this.error = error.message;
                });
        }
        /**Ended here */
        this.baseURL = window.location.origin + this.allLabels.communityName; 
        this.returnAndRefumdURL = this.baseURL + 'refund-policy?store=' + this.sendLocBackToChangeLocTile;
    }
    //CECI-772 added disconnectedCallback method
    disconnectedCallback() {
        this.template.removeEventListener('click',this.escapeStructure);
    }
    
    navigateToReturnRefundURLPage(){        
        console.log('ENTERING IN THE navigateToReturnRefundURLPage');
        invokeGoogleAnalyticsService('RETURNREFUND FOOTER LINK CLICK', 'Page Navigation');                 
    } 

    get returnrefundurl(){
        return this.returnAndRefumdURL;
    }


    handleToSignInLinkClick(){        
        console.log('ENTERING IN THE handleToSignInLinkClick');
        invokeGoogleAnalyticsService('SIGNIN LINK CLICK', 'IAM');                 
    }

    get navigateToSignInURL(){
        return this.signInURL;
    }      
    

    @wire(getStatesData)
    wiredgetStatesData({
      error,
      data
    }) {
      if (data) {
        console.log('data from get states method>>' + JSON.stringify(data));
        this.statesMtData = data;
        if (this.statesMtData != '' || this.statesMtData != undefined ||
          this.statesMtData != 'undefined' || this.statesMtData.length != undefined) {
          this.countryItem = [];
          this.statePicklistValuArray = [];
          this.statePicklistValuArrayBil = [];
          this.valueDrpdwn = '';
          this.statesMtData.forEach(element => {
            let itemExist = this.countryItem.some(el => el.label === element.dbu_Country__c);
            if (!itemExist) {
              if (element.dbu_Country_Code__c == this.currentStorelocation) {
                this.countryItem.push({
                  label: element.dbu_Country__c,
                  value: element.dbu_Country_Code__c
                });
              }
            }
            if (element.dbu_Country_Code__c == this.cntryVal) {
              this.statePicklistValuArray.push({
                label: element.dbu_State__c,
                value: element.dbu_State_Code__c
              });
              this.statePicklistValuArrayBil.push({
                label: element.dbu_State__c,
                value: element.dbu_State_Code__c
              });
            }
          });
          this.statePicklistValuArray.sort((a, b) => (a.label > b.label) ? 1 : -1);
          this.statePicklistValuArrayBil.sort((a, b) => (a.label > b.label) ? 1 : -1);
        }
        this.error = undefined;
      } else if (error) {
        console.log('error>>>' + JSON.stringify(error));
        this.error = error;
        this.statePicklistValuesCA = undefined;
      }
    }



    @wire(Checkcreateengine, {
        urlParam: window.location.href
    })
    wireCheckcreateengine({
        error,
        data
    }) {

        if (data) {
            this.isLoading = false;
            this.Checkcreateengine = data;
            if (this.Checkcreateengine == true) {
                this.cratecheckbox = true;
            }
            this.error = undefined;
        } else if (error) {
            this.isLoading = false;
            this.error = error;
            this.Checkcreateengine = undefined;
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

    cartId = this.cartId;

    @wire(getShiptoBilltoData, {
        cartid: '$cartId'
    })
    wireCustomerDetails({
        error,
        data
    }) {
        if (data) {
            this.getShiptoBillto = data;
            if (this.getShiptoBillto[0].ccrz__ShipTo__c != null) {
                this.shipToIdCC = this.getShiptoBillto[0].ccrz__ShipTo__c;
            }
            if (this.getShiptoBillto[0].ccrz__BillTo__c != null) {
                this.billToIdCC = this.getShiptoBillto[0].ccrz__BillTo__c;
            }
            if (this.getShiptoBillto[0].dbu_Pick_Up_From_Store__c != null) {
                this.pickUpIdCC = this.getShiptoBillto[0].dbu_Pick_Up_From_Store__c;
            }

            if (!this.showAddOnClickFrmOrdrRev) {

                if (this.getShiptoBillto[0].ccrz__BuyerFirstName__c != null) {
                    this.firstname = this.getShiptoBillto[0].ccrz__BuyerFirstName__c;
                }
                if (this.getShiptoBillto[0].ccrz__BuyerLastName__c != null) {
                    this.lastname = this.getShiptoBillto[0].ccrz__BuyerLastName__c;
                }
                if (this.getShiptoBillto[0].ccrz__BuyerEmail__c != null) {
                    this.emailVal = this.getShiptoBillto[0].ccrz__BuyerEmail__c;
                }
                if (this.getShiptoBillto[0].ccrz__BuyerPhone__c != null) {
                    this.phoneVal = this.getShiptoBillto[0].ccrz__BuyerPhone__c;
                }
                if (this.getShiptoBillto[0].ccrz__ShipTo__r.ccrz__AddressFirstline__c != null) {
                    this.add1Val = this.getShiptoBillto[0].ccrz__ShipTo__r.ccrz__AddressFirstline__c;
                }
                if (this.getShiptoBillto[0].ccrz__ShipTo__r.ccrz__AddressSecondline__c != null) {
                    this.add2Val = this.getShiptoBillto[0].ccrz__ShipTo__r.ccrz__AddressSecondline__c;
                }
                this.stateVal = this.getShiptoBillto[0].ccrz__ShipTo__r.ccrz__State__c;
                this.valueDrpdwn = this.getShiptoBillto[0].ccrz__ShipTo__r.ccrz__State__c;
                this.cityVal = this.getShiptoBillto[0].ccrz__ShipTo__r.ccrz__City__c;
                this.zipVal = this.getShiptoBillto[0].ccrz__ShipTo__r.ccrz__PostalCode__c;
                this.cntryVal = this.getShiptoBillto[0].ccrz__ShipTo__r.ccrz__Country__c;
                if (this.cntryVal == this.allLabels.storeUSA) {
                    this.usLoc = true;

                } else if (this.cntryVal == this.allLabels.storeCanada) {
                    this.usLoc = false;
                }

                this.add1ValBil = this.getShiptoBillto[0].ccrz__BillTo__r.ccrz__AddressFirstline__c;
                if (this.getShiptoBillto[0].ccrz__BillTo__r.ccrz__AddressSecondline__c != null) {
                    this.add2ValBil = this.getShiptoBillto[0].ccrz__BillTo__r.ccrz__AddressSecondline__c;
                }
                this.cityValBil = this.getShiptoBillto[0].ccrz__BillTo__r.ccrz__City__c;
                this.stateValBil = this.getShiptoBillto[0].ccrz__BillTo__r.ccrz__State__c;
                this.valueDrpdwnBil = this.getShiptoBillto[0].ccrz__BillTo__r.ccrz__State__c;
                this.zipValBil = this.getShiptoBillto[0].ccrz__BillTo__r.ccrz__PostalCode__c;
                this.cntryValBil = this.getShiptoBillto[0].ccrz__BillTo__r.ccrz__Country__c;

                if (this.cntryValBil === this.allLabels.storeUSA) {
                    this.usLocBil = true;
                } else if (this.cntryValBil != this.allLabels.storeUSA) {
                    this.usLocBil = false;
                }              
            }
        } else if (error) {
            this.error = error;
            this.customer = undefined;
        }
    }

    @wire(fetchCustomerInfoDetails, {
        recId: '$userId'
    })
    wireCustomerInfoDetailsCntrl({
        error,
        data
    }) {

        if (data) {

            this.customerinfo = data;

            if (!this.isguestuser && this.showAddOnClickFrmOrdrRev == true) {
                this.cmpnameVal = this.customerinfo.dbu_Company_Name__c;
                if (this.customerinfo.FirstName != null) {
                    this.firstname = this.customerinfo.FirstName;                    
                }
                if (this.customerinfo.LastName != null) {
                    this.lastname = this.customerinfo.LastName;
                }
                if (this.customerinfo.Email != null) {
                    this.emailVal = this.customerinfo.Email;
                }
                if (this.customerinfo.Phone != null) {
                    let phnData = this.customerinfo.Phone;                   
                    if (phnData.includes("(") && phnData.includes("+1")) {
                        this.phoneVal = phnData;
                    }
                    else {
                        this.formatPhoneNumber(phnData);
                    }
                }
            }
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.customer = undefined;
        }
    }
    
    formatPhoneNumber(phoneNumberString) {
        var cleaned = ('' + phoneNumberString).replace(/\D/g, '')
        var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/)
        if (match) {
            this.phoneVal = '+1 (' + match[1] + ') ' + match[2] + '-' + match[3]
        }
    }

    @wire(shippingAddressData)
    wiredshippingAddressData({
        error,
        data
    }) {
        if (data) {

            this.ccAddressDataDefaultListShipping = data;
            if (!this.isguestuser && this.showAddOnClickFrmOrdrRev == true) {
                if (this.currentStorelocation == this.ccAddressDataDefaultListShipping[0].ccrz__Country__c) {

                    if (this.ccAddressDataDefaultListShipping[0].ccrz__AddressFirstline__c != null &&
                        this.ccAddressDataDefaultListShipping[0].ccrz__AddressFirstline__c != 'undefined') {
                        this.add1Val = this.ccAddressDataDefaultListShipping[0].ccrz__AddressFirstline__c;
                    } else if (this.ccAddressDataDefaultListShipping[0].ccrz__AddressFirstline__c === null) {
                        this.add1Val = '';
                    }
                    if (this.ccAddressDataDefaultListShipping[0].ccrz__AddressSecondline__c != null) {
                        this.add2Val = this.ccAddressDataDefaultListShipping[0].ccrz__AddressSecondline__c;
                    } else if (this.ccAddressDataDefaultListShipping[0].ccrz__AddressSecondline__c === null) {
                        this.add2Val = '';
                    }
                    if (this.ccAddressDataDefaultListShipping[0].ccrz__City__c != null) {
                        this.cityVal = this.ccAddressDataDefaultListShipping[0].ccrz__City__c;
                    } else if (this.ccAddressDataDefaultListShipping[0].ccrz__City__c === null) {
                        this.cityVal = '';
                    }
                    if (this.ccAddressDataDefaultListShipping[0].ccrz__State__c != null) {
                        this.stateVal = this.ccAddressDataDefaultListShipping[0].ccrz__State__c;
                        this.valueDrpdwn = this.ccAddressDataDefaultListShipping[0].ccrz__State__c;
                    } else if (this.ccAddressDataDefaultListShipping[0].ccrz__State__c === null) {
                        this.stateVal = '';
                        this.valueDrpdwn = '';

                    }
                    if (this.ccAddressDataDefaultListShipping[0].ccrz__Country__c != null) {
                        this.cntryVal = this.ccAddressDataDefaultListShipping[0].ccrz__Country__c;
                        if (this.cntryVal == this.allLabels.storeUSA) {
                            this.usLoc = true;
                            this.statePicklistValuArray = [];
                            this.statesMtData.forEach(element => {
                                if (element.dbu_Country_Code__c == this.cntryVal) {
                                    this.statePicklistValuArray.push({
                                        label: element.dbu_State__c,
                                        value: element.dbu_State_Code__c
                                    });
                                }
                            });
                        } else if (this.cntryVal == this.allLabels.storeCanada) {
                            this.usLoc = false;
                            this.statePicklistValuArray = [];
                            this.statesMtData.forEach(element => {
                                if (element.dbu_Country_Code__c == this.cntryVal) {
                                    this.statePicklistValuArray.push({
                                        label: element.dbu_State__c,
                                        value: element.dbu_State_Code__c
                                    });
                                }
                            });

                        }
                        this.statePicklistValuArray.sort((a, b) => (a.label > b.label) ? 1 : -1);
                    } else if (this.ccAddressDataDefaultListShipping[0].ccrz__Country__c === null) {
                        this.cntryVal = '';
                    }
                    if (this.ccAddressDataDefaultListShipping[0].ccrz__PostalCode__c != null) {
                        this.zipVal = this.ccAddressDataDefaultListShipping[0].ccrz__PostalCode__c;
                    } else if (this.ccAddressDataDefaultListShipping[0].ccrz__PostalCode__c === null) {
                        this.zipVal = '';
                    }
                }
            }
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.ccAddressDataDefaultListShipping = undefined;
        }
    }

    @wire(billingAddressData)
    wiredbillingAddressData({
        error,
        data
    }) {
        if (data) {
            this.ccAddressDataDefaultListBilling = data;
            if (!this.isguestuser && this.showAddOnClickFrmOrdrRev == true) {
                if (this.currentStorelocation == this.ccAddressDataDefaultListBilling[0].ccrz__Country__c) {
                    if (this.ccAddressDataDefaultListBilling[0].ccrz__AddressFirstline__c != null) {
                        this.add1ValBil = this.ccAddressDataDefaultListBilling[0].ccrz__AddressFirstline__c;
                    } else if (this.ccAddressDataDefaultListBilling[0].ccrz__AddressFirstline__c === null) {
                        this.add1ValBil = '';
                    }
                    if (this.ccAddressDataDefaultListBilling[0].ccrz__AddressSecondline__c != null) {
                        this.add2ValBil = this.ccAddressDataDefaultListBilling[0].ccrz__AddressSecondline__c;
                    } else if (this.ccAddressDataDefaultListBilling[0].ccrz__AddressSecondline__c === null) {
                        this.add2ValBil = '';
                    }
                    if (this.ccAddressDataDefaultListBilling[0].ccrz__City__c != null) {
                        this.cityValBil = this.ccAddressDataDefaultListBilling[0].ccrz__City__c;
                    } else if (this.ccAddressDataDefaultListBilling[0].ccrz__City__c === null) {
                        this.cityValBil = '';
                    }
                    if (this.ccAddressDataDefaultListBilling[0].ccrz__State__c != null) {
                        this.stateValBil = this.ccAddressDataDefaultListBilling[0].ccrz__State__c;
                        this.valueDrpdwnBil = this.ccAddressDataDefaultListBilling[0].ccrz__State__c;

                    } else if (this.ccAddressDataDefaultListBilling[0].ccrz__State__c === null) {
                        this.stateValBil = '';
                        this.valueDrpdwnBil = '';
                    }
                    if (this.ccAddressDataDefaultListBilling[0].ccrz__Country__c != null) {
                        this.cntryValBil = this.ccAddressDataDefaultListBilling[0].ccrz__Country__c;
                        if (this.cntryValBil === this.allLabels.storeUSA) {
                            this.usLocBil = true;
                            this.statePicklistValuArrayBil = [];

                            this.statesMtData.forEach(element => {
                                if (element.dbu_Country_Code__c == this.cntryValBil) {
                                    this.statePicklistValuArrayBil.push({
                                        label: element.dbu_State__c,
                                        value: element.dbu_State_Code__c
                                    });
                                }
                            });
                        } else if (this.cntryValBil != this.allLabels.storeUSA) {
                            this.usLocBil = false;
                            this.statePicklistValuArrayBil = [];
                            this.statesMtData.forEach(element => {
                                if (element.dbu_Country_Code__c == this.cntryValBil) {
                                    this.statePicklistValuArrayBil.push({
                                        label: element.dbu_State__c,
                                        value: element.dbu_State_Code__c
                                    });
                                }
                            });
                        }
                        this.statePicklistValuArrayBil.sort((a, b) => (a.label > b.label) ? 1 : -1);
                    } else if (this.ccAddressDataDefaultListBilling[0].ccrz__Country__c === null) {
                        this.cntryValBil = '';
                    }
                    if (this.ccAddressDataDefaultListBilling[0].ccrz__PostalCode__c != null) {
                        this.zipValBil = this.ccAddressDataDefaultListBilling[0].ccrz__PostalCode__c;
                    } else if (this.ccAddressDataDefaultListBilling[0].ccrz__PostalCode__c === null) {
                        this.zipValBil = '';
                    }
                }

            }


            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.ccAddressDataDefaultListBilling = undefined;
        }
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
        this.phoneVal = obj.target.value;
        if (obj.which == 27) {
            if (numbers.length <= 3) {
                obj.preventDefault();

            }
        }
    }

    handleUsrChange(event) {
        if (event.target.name == 'fname') {
            this.firstname = event.target.value;
        } else if (event.target.name == 'lname') {
            this.lastname = event.target.value;
        } else if (event.target.name == 'email') {
            this.emailVal = event.target.value;
        } else if (event.target.name == 'phnNum') {
            let phnData = event.target.value;
            this.formatPhone(phnData);
        } else if (event.target.name == 'cmnyName') {
            this.cmpnameVal = event.target.value;
        }

        this.userDetails = [{
            firstnme: this.firstname,
            lstnme: this.lastname,
            email: this.emailVal,
            phn: this.phoneVal,
            cmnyname: this.cmpnameVal

        }];
    }

    escapeStructure(e){
        if(e.target.classList.contains('slds-listbox__option-text') || e.target.classList.contains('add1') || e.target.classList.contains('add1ValBilClass')){       
        }else{
            this.addressResults = undefined;
        }
    }

    closeAddressResults(e){
        if(e.target.name == 'add2' || e.target.name == 'add2Bil')
        this.addressResults = undefined;
    }

    addressAutoComp(event){
        clearTimeout(this.typingTimer);
        const searchKey = event.target.value;
        //CECI-772 added if
        if (event.key === "Escape" || event.key === "Esc") {
            this.addressResults = undefined;
            return;
        }
        if(searchKey !== undefined && searchKey.length){

            //Remove POBox Validation when in Address1 Field
            let addr1 = this.template.querySelector('.add1');
            if(addr1 != undefined){
                addr1.setCustomValidity('');
                this.pobox = false;
                addr1.reportValidity();
            }
            
            
            let countryCodeVal;
            if(this.cntryVal == this.allLabels.storeUSA){
                countryCodeVal = 'country:'+this.cntryVal;
                console.log(countryCodeVal);
            }else{
                countryCodeVal = 'country:ca';
            }
            const addType = event.target.classList.contains('add1') ? 'shipping' : 'billing';
            this.typingTimer = setTimeout(() => {
                getListOfAddresses(searchKey, countryCodeVal) // CECI-1099 component optimization
                .then(addresses => {
                    if(addType =='shipping'){
                        this.shipTypeAddress = true;
                        this.bilTypeAddress = false;
                        
                    }else{
                        this.shipTypeAddress = false;
                        this.bilTypeAddress = true;
                        
                    }
                    this.addressResults = addresses;
                    this.selectedAddress = undefined;  
                })
            }, 300);
        }else{
            this.addressResults = undefined;
        }
    }
    addressSelected(event){
        let addType = event.currentTarget.dataset.adtype;
        getSelectedAddress(event.currentTarget.dataset.plid, event.currentTarget.dataset.desc)// CECI-1099 component optimization
        .then(data => {
            console.log('Address Selected From Service Comp Is'+data);
            if(addType == 'shipping'){
                this.add2Val = '';
                this.add1Val = data[0];
                this.zipVal = data[1];
                this.cityVal = data[2];
                this.stateVal = data[3];         
                this.checkForShippingErrors();
                this.template.querySelector('.add2').focus();
            }else{
                this.add2ValBil = '';
                this.add1ValBil = data[0];
                this.zipValBil = data[1];
                this.cityValBil = data[2];
                this.stateValBil = data[3];
                this.template.querySelector('.add2Bil').focus();
            }
            this.addressResults = undefined;
        })

    }

    checkForShippingErrors(){
        let firstTimeStateCheck = true;
        if(this.stateVal == 'YT' || this.stateVal == 'NU'){
            firstTimeStateCheck = true;
            this.template.querySelector('.stateValError').classList.add("errorField");
            this.template.querySelector('.stateValError').setCustomValidity(this.allLabels.dbu_ca_province_shipping_error);
            //this.stateVal = '';
        }
        else if(this.crateEngineProduct==true && (this.stateVal==='WV'|| this.stateVal=== 'TX' || this.stateVal==='QC')){
            firstTimeStateCheck = true;
            this.template.querySelector('.stateValError').classList.add("errorField");
            if(this.stateVal==='WV'|| this.stateVal=== 'TX'){
                this.template.querySelector('.stateValError').setCustomValidity(this.allLabels.dbu_product_crateUSError);
            }else{
                this.template.querySelector('.stateValError').setCustomValidity(this.allLabels.dbu_product_crateCAError);
            }               
        }else{
            this.template.querySelector('.stateValError').classList.remove("errorField");
            this.template.querySelector('.stateValError').setCustomValidity('');
            firstTimeStateCheck = this.template.querySelector('.stateValError').checkValidity();
        }
        if(firstTimeStateCheck == true){
            this.template.querySelector('.stateValError').reportValidity(); 
        }
    }


    handleShippingChange(event) {
        if (event.target.name == 'add1') {
            this.add1Val = event.target.value;
              /* Added by Sri */
              let strLower = this.add1Val.toLowerCase();
              let adStr = strLower.replace(/[\. ,-]+/g,"");
              let addr1 = this.template.querySelector('.add1');
              
              if(adStr.indexOf('pobox') == -1) {
                  addr1.setCustomValidity('');
                  this.pobox = false;
              } else {
                  addr1.setCustomValidity(this.allLabels.dbu_POBoxValidation);
                  this.pobox = true;
              }
              addr1.reportValidity();
              /*End */
        } else if (event.target.name == 'add2') {
            this.add2Val = event.target.value;
        } else if (event.target.name == 'city') {
            this.cityVal = event.target.value;
        } else if (event.target.name == 'state') {
            this.stateVal = event.target.value;
            // Sri Crate 
            this.checkForShippingErrors();
            // Sri Ends
        } else if (event.target.name == 'zip') {
            this.zipVal = event.target.value;
        } else if (event.target.name == 'country') {

            this.cntryVal = event.target.value;
            if (this.cntryVal == this.allLabels.storeUSA) {
                this.usLoc = true;
            } else {
                this.usLoc = false;
            }
            this.statePicklistValuArray = [];
            this.valueDrpdwn = '';
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
        if (this.sameShipAddSelected) {
            if (this.add1Val != null) {
                this.add1ValBil = this.add1Val;
            }
            if (this.add2ValBil != null) {
                this.add2ValBil = this.add2Val;
            }
            if (this.cityValBil != null) {
                this.cityValBil = this.cityVal
            }
            if (this.stateValBil != null) {
                if(!(this.stateVal == 'YT' || this.stateVal == 'NU')){               
                    this.stateValBil = this.stateVal;
                    this.valueDrpdwnBil = this.stateVal;
                }
            }
            if (this.zipValBil != null) {
                this.zipValBil = this.zipVal;
            }
            if (this.cntryValBil != null) {
                this.cntryValBil = this.cntryVal;
            }
        }
        this.shippingDetails = [{
            add1: this.add1Val,
            add2: this.add2Val,
            state: this.stateVal,
            zip: this.zipVal,
            country: this.cntryVal,
            city: this.cityVal
        }];
    }

    @track sendStateCodeTosearchAccs;



    handleBillingChange(event) {
        if (event.target.name == 'add1Bil') {
            this.add1ValBil = event.target.value;
        } else if (event.target.name == 'add2Bil') {
            this.add2ValBil = event.target.value;
        } else if (event.target.name == 'cityBil') {
            this.cityValBil = event.target.value;
        } else if (event.target.name == 'stateBil') {
            this.stateValBil = event.target.value;
        } else if (event.target.name == 'zipBil') {
            this.zipValBil = event.target.value;
        } else if (event.target.name == 'countryBil') {
            this.cntryValBil = event.target.value;
            if (this.cntryValBil === this.allLabels.storeUSA) {
                this.usLocBil = true;
            } else {
                this.usLocBil = false;
            }
            this.statePicklistValuArrayBil = [];
            this.valueDrpdwnBil = '';
            this.statesMtData.forEach(element => {
                if (element.dbu_Country_Code__c == this.cntryValBil) {
                    this.statePicklistValuArrayBil.push({
                        label: element.dbu_State__c,
                        value: element.dbu_State_Code__c
                    });
                }
            });
            this.statePicklistValuArrayBil.sort((a, b) => (a.label > b.label) ? 1 : -1);

        }
        this.billingDetails = [{
            add1: this.add1ValBil,
            add2: this.add2ValBil,
            state: this.stateValBil,
            zip: this.zipValBil,
            country: this.cntryValBil,
            city: this.cityValBil
        }];
    }

    sameShippingAddress(event) {
        invokeGoogleAnalyticsService('BUTTON CLICK', {EventAction : 'Checkout Page checkbox click Event', eventName : 'Same as shipping address'});
        if (event.target.checked) {
            this.sameShipAddSelected = true;
            this.add1ValBil = this.add1Val;
            this.add2ValBil = this.add2Val;
            this.cityValBil = this.cityVal;
            if(!(this.stateVal == 'YT'||this.stateVal == 'NU')){      
                this.stateValBil = this.stateVal;
                this.valueDrpdwnBil = this.stateVal;
            }
            this.zipValBil = this.zipVal;
            this.cntryValBil = this.cntryVal;
            if (this.cntryVal === this.allLabels.storeUSA) {
                this.usLocBil = true;
                this.statePicklistValuArrayBil = [];
                this.statesMtData.forEach(element => {
                    if (element.dbu_Country_Code__c == this.cntryValBil) {
                        this.statePicklistValuArrayBil.push({
                            label: element.dbu_State__c,
                            value: element.dbu_State_Code__c
                        });
                    }
                });
                this.statePicklistValuArrayBil.sort((a, b) => (a.label > b.label) ? 1 : -1);
            } else if (this.cntryVal != this.allLabels.storeUSA) {
                this.usLocBil = false;
                this.statePicklistValuArrayBil = [];
                this.statesMtData.forEach(element => {
                    if (element.dbu_Country_Code__c == this.cntryValBil) {
                        this.statePicklistValuArrayBil.push({
                            label: element.dbu_State__c,
                            value: element.dbu_State_Code__c
                        });
                    }
                });
                this.statePicklistValuArrayBil.sort((a, b) => (a.label > b.label) ? 1 : -1);
            }
            this.billingDetails = [{
                add1: this.add1ValBil,
                add2: this.add2ValBil,
                city: this.cityValBil,
                state: this.stateValBil,
                zip: this.zipValBil,
                country: this.cntryValBil
            }];
        } else {
            this.add1ValBil = '';
            this.add2ValBil = '';
            this.cityValBil = '';
            this.stateValBil = '';
            this.valueDrpdwnBil = '';
            this.zipValBil = '';
            this.sameShipAddSelected = false;
        }
    }


    @track showSuggestedChkbox = true;
    @track showSuggestedChkboxShipping = true;
    @track showSuggestedChkboxBilling = true;
    @track showPickupStoreNotSelectedMsg = false;
    @track showPickupselectedErrMsg;

    handleClickPaymentProceed() {
        //alert('interior ministry > ');
        var errorCls = this.template.querySelectorAll('.errorField');
        for (var s = 0; s < errorCls.length; s++) {
            errorCls[s].classList.remove("errorField");
        }
        //alert('interior ministry 2> ');
        this.add1ValShipping = this.add1Val;
        this.add2ValShipping = this.add2Val;
        this.cityValShipping = this.cityVal;
        this.stateValShipping = this.stateVal;
        this.zipValShipping = this.zipVal;
        this.cntryValShipping = this.cntryVal;

        this.add1ValBilbilling = this.add1ValBil;
        this.add2ValBilbilling = this.add2ValBil;
        this.cityValBilbilling = this.cityValBil;
        this.stateValBilbilling = this.stateValBil;
        this.zipValBilbilling = this.zipValBil;
        this.cntryValBilbilling = this.cntryValBil;
        //alert('interior ministry > 3');

        if (this.sameShipAddSelected) {
            //alert('interior ministry > (this.sameShipAddSelected)');
            if (this.add1Val != null) {
                this.add1ValBil = this.add1Val;
            }
            if (this.add2ValBil != null) {
                this.add2ValBil = this.add2Val;
            }
            if (this.cityValBil != null) {
                this.cityValBil = this.cityVal
            }
            if (this.stateValBil != null) {
                this.stateValBil = this.stateVal;
                this.valueDrpdwnBil = this.stateVal;
            }
            if (this.zipValBil != null) {
                this.zipValBil = this.zipVal;
            }
            if (this.cntryValBil != null) {
                this.cntryValBil = this.cntryVal;
            }
        }
        this.isLoading = true;
        
        let inputLst = this.template.querySelectorAll('.lnginp');
        inputLst.forEach(inpField => {
            inpField.reportValidity();
        }); 

        if (this.pickUpSelected === true) {
           
            if (this.add1ValBil === '' || this.stateValBil === '' || this.zipValBil === '' || this.cntryValBil === '' || this.cityValBil === '' ||
                this.firstname === '' || this.lastname === '' || this.emailVal === '' || this.phoneVal === '' || this.phoneVal.length < 17 ) {
                if (this.firstname === '') {
                    this.template.querySelector('.firstnameError').classList.add("errorField");
                } if (this.lastname === '') {
                    this.template.querySelector('.lastnameError').classList.add("errorField");
                } if (this.emailVal === '') {
                    this.template.querySelector('.emailValError').classList.add("errorField");
                } if (this.phoneVal === '' || this.phoneVal.length < 17) {
                    this.template.querySelector('.phoneValError').classList.add("errorField");
                }                      
                this.mandateFlag = true;
                this.isLoading = false;
                console.log(this.mandateFlag);                
            } else {                
                this.mandateFlag = false;
                this.showPickupStoreNotSelectedMsg = false;
                this.isLoading = true;
                  
            }
        } 
        if (this.pickUpSelected === false) {
            if (this.add1Val === '' || this.stateVal === '' || this.zipVal === '' || this.cntryVal === '' || this.firstname === '' || this.pobox || 
                this.lastname === '' || this.emailVal === '' || this.phoneVal === '' || this.phoneVal.length < 17 || this.add1ValBil === '' || this.stateValBil === '' || this.zipValBil === '' || this.cntryValBil === '' || this.cityValBil === '') {
                if (this.firstname === '') {
                    this.template.querySelector('.firstnameError').classList.add("errorField");
                } 
                if (this.lastname === '') {
                    this.template.querySelector('.lastnameError').classList.add("errorField");
                } 
                if (this.emailVal === '') {
                    this.template.querySelector('.emailValError').classList.add("errorField");
                }    
                if (this.phoneVal === '' || this.phoneVal.length < 17) {
                    this.template.querySelector('.phoneValError').classList.add("errorField");
                } 
                if(this.pobox) { /* Added by Sri */
                    this.template.querySelector('.add1ValError').classList.add("errorField");
                    this.template.querySelector('.add1').setCustomValidity(this.allLabels.dbu_POBoxValidation);
                }/*End */
                this.mandateFlag = true;
                this.isLoading = false;             
            } else {
                this.mandateFlag = false;
                this.isLoading = true;

            }
             // Sri Crate 
            if(this.crateEngineProduct==true && (this.stateVal==='WV'|| this.stateVal=== 'TX' || this.stateVal==='QC')){
                this.mandateFlag = true;
                this.isLoading = false;
            }// Sri Crate  end

                }            
        if (this.mandateFlag === false && !this.showPickupStoreNotSelectedMsg) {
            //this.navigateToReviewOrder();
            this.addressPopup = true;
            if (this.pickUpSelected === false) {
                getAddressVerify({
                    addressLine1: this.add1Val,
                    addressLine2: this.add2Val,
                    cityId: this.cityVal,
                    stateID: this.stateVal,
                    countryId: this.cntryVal,
                    psCode: this.zipVal

                }).then(result => {
                    this.isLoading = false;
                    this.responseData = result;
                    this.errorFlag = this.responseData.AddressCleanse.Location[0].GeographicalArea.AddressError.ErrorFlag;
                    if (this.errorFlag === 'N') {
                        this.errorFlagYes = false;
                        this.AddressLine1txtRes = this.responseData.AddressCleanse.Location[0].GeographicalArea.StreetAddress.AddressLine1txt;
                        if (this.responseData.AddressCleanse.Location[0].GeographicalArea.StreetAddress.AddressLine2txt != 'NULL' || this.responseData.AddressCleanse.Location[0].GeographicalArea.StreetAddress.AddressLine2txt != '') {
                            this.AddressLine2txtRes = this.responseData.AddressCleanse.Location[0].GeographicalArea.StreetAddress.AddressLine2txt;
                        }
                        this.CityIDRes = this.responseData.AddressCleanse.Location[0].GeographicalArea.City.CityID;
                        this.StateIDRes = this.responseData.AddressCleanse.Location[0].GeographicalArea.City.TerritoryID;

                        this.ZipCodeIDRes = this.responseData.AddressCleanse.Location[0].GeographicalArea.PostalCode.PostalCodeNum;
                        this.CountryIDRes = this.responseData.AddressCleanse.Location[0].GeographicalArea.Country.CountryID;
                        if (this.AddressLine1txtRes !== '' && this.CityIDRes !== '' &&
                            this.StateIDRes !== '' && this.ZipCodeIDRes !== '' && this.CountryIDRes !== '') {
                            this.showSuggestedChkboxShipping = true;
                        } else {
                            this.showSuggestedChkboxShipping = false;
                        }
                        this.showCheckboxOnEDQ();
                    }

                    if (this.errorFlag === 'Y') {
                        this.showSuggestedChkboxShipping = false;
                        console.log('sssss' + this.showSuggestedChkboxShipping);
                        if (this.responseData.AddressCleanse.Location[0].GeographicalArea.AddressError.ErrorDescription !== '') {
                            this.errorFlagYes = true;
                            this.errorDescRes = this.responseData.AddressCleanse.Location[0].GeographicalArea.AddressError.ErrorDescription;
                        }
                        if (this.errorDescRes == 'Missing Address_line_1|Missing City|Missing State|Missing Postal Code') {
                            this.showSuggestedChkboxShipping = true;
                        }
                        this.showCheckboxOnEDQ();
                    }
                    this.CountryIDRes = this.responseData[0].AddressCleanse.Location[0].GeographicalArea.Country.CountryID;

                })
                    .catch(error => {
                        if (this.responseData == null || this.responseData == '') {
                            this.showSuggestedChkboxShipping = false;
                            this.showCheckboxOnEDQ();
                            console.log('rrrrr' + this.showSuggestedChkboxShipping);

                        }
                        this.isLoading = false;
                        this.error = error;

                    });
            }
            /* Billing address method starts here*/ 


            getAddressVerify({
                addressLine1: this.add1ValBil,
                addressLine2: this.add2ValBil,
                cityId: this.cityValBil,
                stateID: this.stateValBil,
                countryId: this.cntryValBil,
                psCode: this.zipValBil

            }).then(result => {
                this.responseDataBilling = result;
                this.isLoading = false;
                this.errorFlagBillingFromRes = this.responseDataBilling.AddressCleanse.Location[0].GeographicalArea.AddressError.ErrorFlag;
                if (this.errorFlagBillingFromRes === 'N') {
                    this.errorFlagBillingYes = false;
                    this.AddressLine1txtResBil = this.responseDataBilling.AddressCleanse.Location[0].GeographicalArea.StreetAddress.AddressLine1txt;
                    if (this.responseDataBilling.AddressCleanse.Location[0].GeographicalArea.StreetAddress.AddressLine2txt != 'NULL' ||
                        this.responseDataBilling.AddressCleanse.Location[0].GeographicalArea.StreetAddress.AddressLine2txt != "") {
                        this.AddressLine2txtResBil = this.responseDataBilling.AddressCleanse.Location[0].GeographicalArea.StreetAddress.AddressLine2txt;
                    }
                    this.CityIDResBil = this.responseDataBilling.AddressCleanse.Location[0].GeographicalArea.City.CityID;
                    this.StateIDResBil = this.responseDataBilling.AddressCleanse.Location[0].GeographicalArea.City.TerritoryID;
                    this.ZipCodeIDResBil = this.responseDataBilling.AddressCleanse.Location[0].GeographicalArea.PostalCode.PostalCodeNum;
                    this.CountryIDResBil = this.responseDataBilling.AddressCleanse.Location[0].GeographicalArea.Country.CountryID;
                    if(this.AddressLine1txtResBil !== '' && this.CityIDResBil !== '' &&
                    this.StateIDResBil !== '' && this.ZipCodeIDResBil !== '' && this.CountryIDResBil !== ''){
                        this.showSuggestedChkboxBilling = true;
                        console.log('kkkkkkkkkkk billing' +this.showSuggestedChkboxBilling +'lll'+this.StateIDRes);
                    }else{
                        this.showSuggestedChkboxBilling = false;
                        console.log('uuuuuuuuuu billing' +this.showSuggestedChkboxBilling);

                    }
                    this.showCheckboxOnEDQ();
                }

                if (this.errorFlagBillingFromRes === 'Y') {
                    this.errorFlagBillingYes = true;
                    this.isLoading = false;
                    this.showSuggestedChkboxBilling = false;
                    this.showCheckboxOnEDQ();
                    console.log('22222' +this.showSuggestedChkboxBilling );
                    this.errorDescResBil = this.responseDataBilling.AddressCleanse.Location[0].GeographicalArea.AddressError.ErrorDescription;
                }

            })
                .catch(error => {
                    this.error = error;
                    this.isLoading = false;
                    if(this.responseDataBilling == null || this.responseDataBilling == ''){
                        this.showSuggestedChkboxBilling = false;
                        this.showCheckboxOnEDQ();
                        console.log('33333' +this.showSuggestedChkboxBilling );
                    }

                });
        }

        /*Billing method ends here */

    }

    showCheckboxOnEDQ(){
        console.log('showSuggestedChkboxBilling111' +this.showSuggestedChkboxBilling);
        console.log('showSuggestedChkboxShipping22' +this.showSuggestedChkboxShipping);
        if(this.showSuggestedChkboxShipping && this.showSuggestedChkboxBilling ){
            this.showSuggestedChkbox = true;
        }
        else if(!this.showSuggestedChkboxShipping && this.showSuggestedChkboxBilling ){
            this.showSuggestedChkbox = false;
        }
        else if(this.showSuggestedChkboxShipping && !this.showSuggestedChkboxBilling ){
            this.showSuggestedChkbox = false;
        }
        else if(!this.showSuggestedChkboxShipping && !this.showSuggestedChkboxBilling ){
            this.showSuggestedChkbox = false;
        }
    }


    @track addressBtnSelected = true;
    @track addressBtnSelectedBilling = true;

    addressRadioChecked(event) {
        this.addressBtnSelected = !event.target.checked;
    }

    addressRadioCheckedBilling(event) {
        this.addressBtnSelectedBilling = !event.target.checked;
    }
    handleClickValidate() {
        this.add1Val = this.AddressLine1txtRes;
        this.add2Val = this.AddressLine2txtRes;
        this.cityVal = this.CityIDRes;
        this.stateVal = this.StateIDRes;
        this.zipVal = this.ZipCodeIDRes;
        this.cntryVal = this.CountryIDRes;
    }

    closeAddressPopup() {
        this.addressPopup = false;
        this.showBillingCCAddress = false;
    }

    closeAddressPickUpOnlyPopup() {
        this.showPopUpwithShipOnlyMsg = false;        
    }

    closeShippingAddressPopup() {
        this.showCCAddress = false;
        this.showBillingCCAddress = false;
    }

    navigateToReviewOrder() {
        this.isLoading = true;
        this.addressPopup = false;
		invokeGoogleAnalyticsService('BUTTON CLICK', {EventAction : 'Navigate to Order Review Page from checkout page', eventName : 'Navigate to Order Review Page'});
        if (this.mandateFlag === false) {

            if (this.shipToIdCC == null) {
                console.log('entering the insert condition>>>>>');
                if (this.shippingDetails !== '' && this.shippingDetails != 'undefined' && this.add1Val != '' && this.add1Val != 'undefined') {
                    insertShippingInfo({
                        add1: this.add1Val,
                        add2: this.add2Val,
                        state: this.stateVal,
                        zip: this.zipVal,
                        country: this.cntryVal,
                        city: this.cityVal,
                        firstname : this.firstname,
                        lastname : this.lastname
                    }).then(result => {
                        this.shippingId = result;
                        if (this.userDetails !== '' && this.userDetails != 'undefined') {
                            insertUserInfo({
                                firstnme: this.firstname,
                                lstnme: this.lastname,
                                email: this.emailVal,
                                phn: this.phoneVal,
                                cmnyname: this.cmpnameVal,
                                finalShipAddressId: this.shippingId,
                                finalBillingAddressId: null,
                                cartID: this.cartId
                            })
                        }
                    })
                        .catch(error => {
                            this.error = error;
                            console.log('error=>>' + this.error);
                        });
                }
            } else {
                if (this.shipToIdCC != null && this.shipToIdCC != 'undefined' && !this.pickUpSelected) {
                    console.log('entering the else method where shiptoid exists' + this.shipToIdCC);
                    updateCCAddress({
                        ccAddressID: this.shipToIdCC,
                        companyName: this.cmpnameVal,
                        addType: 'Shipping',
                        fstCCName: this.firstname,
                        lstCCName: this.lastname,
                        emailCC: this.emailVal,
                        phnCC: this.phoneVal,
                        add1CC: this.add1Val,
                        add2CC: this.add2Val,
                        cityCC: this.cityVal,
                        stateCC: this.stateVal,
                        zipCC: this.zipVal,
                        cntryCC: this.cntryVal,
                        ccAddressDefaultedCC: false,
                        storeName: null
                    }).then(result => {
                        console.log('result in update shipTo method>>>' + JSON.stringify(result));
                    }).catch(error => {
                        this.error = error;
                    });

                }
            }

            if (this.billToIdCC == null) {
                if (this.billingDetails !== '' && this.billingDetails != 'undefined') {
                    console.log('this.billingDetails' + JSON.stringify(this.billingDetails));
                    insertBillingInfo({
                        add1: this.add1ValBil,
                        add2: this.add2ValBil,
                        state: this.stateValBil,
                        zip: this.zipValBil,
                        country: this.cntryValBil,
                        city: this.cityValBil
                    }).then(result => {
                        console.log('result>>' + result);
                        this.billingId = result;
                        if (this.userDetails !== '' && this.userDetails != 'undefined') {
                            insertUserInfo({
                                firstnme: this.firstname,
                                lstnme: this.lastname,
                                email: this.emailVal,
                                phn: this.phoneVal,
                                cmnyname: this.cmpnameVal,
                                finalShipAddressId: null,
                                finalBillingAddressId: this.billingId,
                                cartID: this.cartId
                            }).then(result123 => {

                            }).catch(error => {
                                this.error = error;
                                console.log('error=>>' + this.error);
                            });
                        }
                    })
                        .catch(error => {
                            this.error = error;
                            console.log('error=>>' + this.error);
                        });
                }
            } else {
                if (this.billToIdCC != null && this.billToIdCC != 'undefined') {
                    console.log('data in billTo method>>' + this.firstname + '' + this.phoneVal);
                    updateCCAddress({
                        ccAddressID: this.billToIdCC,
                        companyName: this.cmpnameVal,
                        addType: 'Billing',
                        fstCCName: this.firstname,
                        lstCCName: this.lastname,
                        emailCC: this.emailVal,
                        phnCC: this.phoneVal,
                        add1CC: this.add1ValBil,
                        add2CC: this.add2ValBil,
                        cityCC: this.cityValBil,
                        stateCC: this.stateValBil,
                        zipCC: this.zipValBil,
                        cntryCC: this.cntryValBil,
                        ccAddressDefaultedCC: false,
                        storeName: null
                    }).then(result => {
                        console.log('result lo > ' + result);
                    }).catch(error => {
                        this.error = error;
                        console.log('error in update billto=>>' + this.error);
                    });

                }
            }
            if(this.shipSelected) {
                console.log('this.shipSelected111' + this.shipSelected);
                //invokeGoogleAnalyticsService('CHECKOUT OPTION',{currenctStep : 1, option : 'Ship Selected'});
                insertPickUpStoreDataInCCObj({
                    storeLocCode: null,
                    cartID: this.cartId,
                    shipMethod: null,
                    pickupstorename: null,
                    cityPickup: null,
                    streetPickup: null,
                    statePickup: null,
                    cntryPickup: null,
                    phonePickup: null                 
                }).then(result => {
                    console.log('result' + result);
                }).catch(error => {
                    this.error = error;
                    console.log('error=>>' + this.error);
                });
            }
            if (this.pickUpSelected) {
                console.log('this.shipSelected' + this.shipSelected);
                insertPickUpStoreDataInCCObj({
                    storeLocCode: this.storeCdeVal,
                    cartID: this.cartId,
                    shipMethod: null,
                    pickupstorename: null,
                    cityPickup: null,
                    streetPickup: null,
                    statePickup: null,
                    cntryPickup: null,
                    phonePickup: null
                }).then(result => {
                    console.log('result' + result);
                }).catch(error => {
                    this.error = error;
                    console.log('error=>>' + this.error);
                });
            }


            let communityName1 = this.allLabels.communityName;
            setTimeout(function () {
                let urlString = window.location.origin;
                this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
				invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Navigate from checkout page to Order Review page', eventAction : 'Navigate to Order Review page'});				
                window.location.href = urlString + communityName1 + 'order-review?store=' + this.sendLocBackToChangeLocTile;
            }, 10000);
        }
        if (this.mandateFlag === false) {
            this.calculateShippingAmount();
        }
    }

    navigatetoCartpgURL(){
        console.log('ENTERING IN THE navigateToReturnRefundURLPage');
        invokeGoogleAnalyticsService('NAVIGATE TO CART PAGE', 'Navigate to cart Page on button click');   
    }

    get goToCartUrl() {
        let urlString = window.location.origin;
        return urlString + this.allLabels.communityName + 'cart?cartId=' + this.cartId + '&store=' + this.sendLocBackToChangeLocTile;
    }

    handleClickValidate(event) {
        if (event.target.checked) {
            this.add1Val = this.AddressLine1txtRes;
            if (this.AddressLine2txtRes == 'NULL') {
                this.add2Val = '';
            } else {
                this.add2Val = this.AddressLine2txtRes;
            }
            this.cityVal = this.CityIDRes;
            this.stateVal = this.StateIDRes;
            this.zipVal = this.ZipCodeIDRes;
            this.cntryVal = this.CountryIDRes;
        } else if (!event.target.checked) {
            this.add1Val = this.add1ValShipping;
            this.add2Val = this.add2ValShipping;
            this.cityVal = this.cityValShipping;
            this.stateVal = this.stateValShipping;
            this.zipVal = this.zipValShipping;
            this.cntryVal = this.cntryValShipping;
        }
    }
    handleClickValidateBilling(event) {

        if (event.target.checked) {
            this.add1ValBil = this.AddressLine1txtResBil;
            if (this.AddressLine2txtResBil == 'NULL') {
                this.add2ValBil = '';
            } else {
                this.add2ValBil = this.AddressLine2txtResBil;
            }
            this.cityValBil = this.CityIDResBil;
            this.stateValBil = this.StateIDResBil;
            this.zipValBil = this.ZipCodeIDResBil;
            this.cntryValBil = this.CountryIDResBil;
        } else if (!event.target.checked) {
            this.add1ValBil = this.add1ValBilbilling;
            this.add2ValBil = this.add2ValBilbilling;
            this.cityValBil = this.cityValBilbilling;
            this.stateValBil = this.stateValBilbilling;
            this.zipValBil = this.zipValBilbilling;
            this.cntryValBil = this.cntryValBilbilling;
        }
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

    updateSeachKey(event) {
        console.log('event>>' + event.target.value);
        this.strSearchAccName = event.target.value;
    }

    searchOnEnter(event) {
        if (event.which == 13) {
            event.preventDefault();
        }
    }
  
    @track ShipSectionDisplayFlag;
  
    @track shipOnlyList = [];
    @track PickUpOnlyList = [];
    @track shipablePickableList = [];
    @track shiponlyitem = [];
    @track pickupOnlyitem = [];

    @track googleAnalyticsPickUpFlag = false;
    @track googleAnalyticsShipToFlag = false;

    fetchLstCartItemsByCartIdFn(){
        fetchLstCartItemsByCartId({
            cartId: this.cartId,
            cart: ''
        })
            .then(data => {
            if (data) {
                console.log('data > ' + JSON.stringify(data));

                this.isLoading = false;
                this.cartDetails = data;
                this.totalAmount = data[0].totalAmount;

                // Estimated Shipping Cost
                let shipingAmount = this.cartDetails[0].shippingAmount;
                this.EstimatedShippingAmount = perfixCurrencyISOCode(this.countryCurrencyCode ,shipingAmount);  
    
                let localcartOriginalAmount = this.cartDetails[0].originalCartAmt;
                localcartOriginalAmount = ((Math.round(localcartOriginalAmount * 100) / 100).toFixed(2)) * 1;
    
                let localcartSubtotalAmount = this.cartDetails[0].subtotalAmount;
                localcartSubtotalAmount = ((Math.round(localcartSubtotalAmount * 100) / 100).toFixed(2)) * 1;
    
                let localcartTotalAmount = this.cartDetails[0].totalAmount;
                if(this.cartDetails[0].totalShippingAmount > 0 && localcartTotalAmount > 0){//added by Ranadip
                    console.log('this.cartDetails[0].isShippingAmount 3' + 'shipingAmount ', this.cartDetails[0].totalShippingAmount);
                    localcartTotalAmount = localcartTotalAmount - this.cartDetails[0].totalShippingAmount;
                    
                }
                if(shipingAmount > 0 && localcartTotalAmount > 0){
                    console.log('this.cartDetails[0].isShippingAmount 4' , shipingAmount);
                    localcartTotalAmount = localcartTotalAmount + shipingAmount;
                }
                if(localcartTotalAmount > 0){
                    localcartTotalAmount = localcartTotalAmount - this.cartDetails[0].taxAmount;
                    console.log('localcartTotalAmount after deduction==',localcartTotalAmount,'Tax=',this.cartDetails[0].taxAmount)
                }
                localcartTotalAmount = ((Math.round(localcartTotalAmount * 100) / 100).toFixed(2)) * 1;
                let localcartDiscountAmount = this.cartDetails[0].totalCartDiscount;
                localcartDiscountAmount = ((Math.round(localcartDiscountAmount * 100) / 100).toFixed(2)) * 1;
                this.cartOriginalAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartOriginalAmount);
                this.cartDiscountAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartDiscountAmount);
                this.cartSubtotalAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartSubtotalAmount);
                this.cartTotalAmount = perfixCurrencyISOCode(this.countryCurrencyCode, localcartTotalAmount);
                console.log(' this.cartDetails '+ JSON.stringify(this.cartDetails))
                
                for (let s = 0; s < this.cartDetails.length; s++) {
                    let cart = this.cartDetails[s];
                    for (let l = 0; l < cart.lstCartItem.length; l++) {
                        //SHIP ONLY LIST
                        if (cart.lstCartItem[l].cartItemProductDetailWrapper.availableToShip &&
                            !cart.lstCartItem[l].cartItemProductDetailWrapper.pickUpOnly) {
                            this.shipOnlyList.push(cart.lstCartItem[l]);
                           
                        }
                      //  Sri Crate
                        if(cart.lstCartItem[l].cartItemProductDetailWrapper.partNumber==this.allLabels.dbu_CrateEnginePartnumber){
                            this.crateEngineProduct=true;
                           
                        }// Sri end
                        //PICK UP ONLY LIST
                        if (!cart.lstCartItem[l].cartItemProductDetailWrapper.availableToShip &&
                            cart.lstCartItem[l].cartItemProductDetailWrapper.pickUpOnly) {
                            this.PickUpOnlyList.push(cart.lstCartItem[l]);
                        }
                        //  Sri Crate
                        //if(cart.lstCartItem[l].cartItemProductDetailWrapper.partNumber=='5467046'){
                        if(cart.lstCartItem[l].cartItemProductDetailWrapper.partNumber==this.allLabels.dbu_CrateEnginePartnumber){
                           
                            this.crateEngineProduct=true;
                           
                        }// Sri end                        
    
                        //SHIPABLE AND PICKABLE LIST
                        if (!cart.lstCartItem[l].cartItemProductDetailWrapper.availableToShip &&
                            !cart.lstCartItem[l].cartItemProductDetailWrapper.pickUpOnly) {
                            this.shipablePickableList.push(cart.lstCartItem[l]);
                        }
    
                        //SHIPABLE AND PICKABLE LIST
                        if (cart.lstCartItem[l].cartItemProductDetailWrapper.availableToShip &&
                            cart.lstCartItem[l].cartItemProductDetailWrapper.pickUpOnly) {
                            this.shipablePickableList.push(cart.lstCartItem[l]);
                        }
    
                        if(cart.lstCartItem[l].cartItem.dbu_isShipTo__c){
                            this.shiponlyitem.push(cart.lstCartItem[l]);  
                            if(this.googleAnalyticsShipToFlag != true){
                                this.googleAnalyticsShipToFlag = true;
                            }  
                            //this.ShipSectionDisplayFlag = true;
                        }else if(!cart.lstCartItem[l].cartItem.dbu_isShipTo__c){
                            this.pickupOnlyitem.push(cart.lstCartItem[l]);
                            if(this.googleAnalyticsPickUpFlag != true){
                                this.googleAnalyticsPickUpFlag = true;
                            }                              
                            //this.ShipSectionDisplayFlag = false;
                        }
    
                    }
                }
    
    
                if(this.shiponlyitem.length > 0){
                     this.ShipSectionDisplayFlag = true;
                }else if(this.shiponlyitem.length == 0){
                    this.ShipSectionDisplayFlag = false;
                }
    
                //CONDITION 1 : SETTING ONLY SHIP ONLY 
                if ((this.shipOnlyList.length > 0) && (this.PickUpOnlyList.length == 0) && (this.shipablePickableList.length == 0)) {
    
                    if(this.ShipSectionDisplayFlag){
                        this.pickUpSelected = false;
                        this.shipSelected = true;
                    }else{
                        this.pickUpSelected = true;
                        this.shipSelected = false;
                    }
    
    
                }
    
                //CONDITION 2 : SETTING ONLY PICKUP ONLY 
                if ((this.PickUpOnlyList.length > 0) && (this.shipOnlyList.length == 0) && (this.shipablePickableList.length == 0)) {
                
                    if(this.ShipSectionDisplayFlag){
                        this.pickUpSelected = false;
                        this.shipSelected = true;
                    }else{
                        this.pickUpSelected = true;
                        this.shipSelected = false;
                    }
                }
    
                //CONDITION 3 : SETTING ONLY SHIPABLE & PICKABLE
                if ((this.PickUpOnlyList.length == 0) && (this.shipOnlyList.length == 0) && (this.shipablePickableList.length > 0)) {
               
                    if(this.ShipSectionDisplayFlag){
                        this.pickUpSelected = false;
                        this.shipSelected = true;
                    }else{
                        this.pickUpSelected = true;
                        this.shipSelected = false;
                    }
                }
    
                //CONDITION 4 : SETTING ONLY FOR SHIPABLE ,PICKABLE & PICKUP ONLY
                if ((this.PickUpOnlyList.length > 0) && (this.shipOnlyList.length == 0) && (this.shipablePickableList.length > 0)) {
                    if(this.ShipSectionDisplayFlag){
                        this.pickUpSelected = false;
                        this.shipSelected = true;
                    }else{
                        this.pickUpSelected = true;
                        this.shipSelected = false;
                    }
    
                }
    
                //CONDITION 5 : SETTING ONLY FOR SHIPABLE ,PICKABLE & SHIP ONLY
                if ((this.PickUpOnlyList.length == 0) && (this.shipOnlyList.length > 0) && (this.shipablePickableList.length > 0)) {
                    if(this.ShipSectionDisplayFlag){
                        this.pickUpSelected = false;
                        this.shipSelected = true;
                    }else{
                        this.pickUpSelected = true;
                        this.shipSelected = false;
                    }                
                }
    
                //CONDITION 6 : SETTING ONLY FOR PICKUP ONLY & SHIP ONLY
                if ((this.PickUpOnlyList.length > 0) && (this.shipOnlyList.length > 0) && (this.shipablePickableList.length == 0)) {
                    if(this.ShipSectionDisplayFlag){
                        this.pickUpSelected = false;
                        this.shipSelected = true;
                    }else{
                        this.pickUpSelected = true;
                        this.shipSelected = false;
                    }
    
                }
    
                //CONDITION 7 : SETTING ONLY FOR PICKUP ONLY & SHIP ONLY
                if ((this.PickUpOnlyList.length > 0) && (this.shipOnlyList.length > 0) && (this.shipablePickableList.length > 0)) {
                    if(this.ShipSectionDisplayFlag){
                        this.pickUpSelected = false;
                        this.shipSelected = true;
                    }else{
                        this.pickUpSelected = true;
                        this.shipSelected = false;
                    }
                }
                
                if(this.googleAnalyticsPickUpFlag == true && this.googleAnalyticsShipToFlag == true){
                    invokeGoogleAnalyticsService('CHECKOUT OPTION',{currenctStep : 1, option : 'ShipTo and PickUp Selected'});
                }
                if(this.googleAnalyticsPickUpFlag == false && this.googleAnalyticsShipToFlag == true){
                    invokeGoogleAnalyticsService('CHECKOUT OPTION',{currenctStep : 1, option : 'ShipTo Selected'});
                }
                if(this.googleAnalyticsPickUpFlag == true && this.googleAnalyticsShipToFlag == false){
                    invokeGoogleAnalyticsService('CHECKOUT OPTION',{currenctStep : 1, option : 'PickUp Selected'});
                }
                if(this.googleAnalyticsPickUpFlag == false && this.googleAnalyticsShipToFlag == false){
                    invokeGoogleAnalyticsService('CHECKOUT OPTION',{currenctStep : 1, option : 'UNABLE TO DETERMINE SHIPTO OR PICKUP'});
                }
                console.log('EMIR KASTURICA PICK > ' + this.googleAnalyticsPickUpFlag + ' STANLEY KUBRICK SHIP > ' + this.googleAnalyticsShipToFlag);
    
                this.error = undefined;
                window.console.log('Cart data222222>>>>>>>>', this.cartDetails);
            } else if (error) {
                this.isLoading = false;
                this.error = error;
                this.cartDetails = undefined;
            }
        }).catch(error => {
            this.error = error;
        });
        
    }

    @track flag = false;

    calculateShippingAmount() {

        updateShippingAmountOnCart({
            cartId: this.cartId,
            isShipSelected: this.shipSelected,
            stateName: this.stateVal
        })
            .then(result => {
                console.log('result from user and shipping ', result);


            })
            .catch(error => {
                this.error = error.message;
            });

    }


    handleManageAddress() {
        console.log('entering the manageaddress method>>>');
        this.showCCAddress = true;
    }

    handleManageBillingAddress() {
        this.showBillingCCAddress = true;

    }

    handleSelectedAddress(event) {
        console.log('chekbox in manage address addresscountry' + event.target.getAttribute('data-addresscountry'));
        console.log('chekbox in manage address addressstate' + event.target.getAttribute('data-addressstate'));
        this.addressline1Val = event.target.getAttribute('data-addressline1');
        this.addressline2Val = event.target.getAttribute('data-addressline2');
        this.addresscity = event.target.getAttribute('data-addresscity');
        this.addressstate = event.target.getAttribute('data-addressstate');
        this.addresspostalcode = event.target.getAttribute('data-addresspostalcode');
        this.addresscountry = event.target.getAttribute('data-addresscountry');
        this.add1Val = this.addressline1Val;
        this.add2Val = this.addressline2Val;
        this.cityVal = this.addresscity;
        this.stateVal = this.addressstate;
        this.valueDrpdwn = this.addressstate;
        this.zipVal = this.addresspostalcode;
        this.cntryVal = this.addresscountry;

        if (this.cntryVal == this.allLabels.storeUSA) {
            this.usLoc = true;
        } else if (this.cntryVal == this.allLabels.storeCanada) {
            this.usLoc = false;
        }
        this.statePicklistValuArray = [];
        this.statesMtData.forEach(element => {
            console.log('entering the for loop>>>' + element.dbu_Country_Code__c);
            if (element.dbu_Country_Code__c == this.cntryVal) {
                console.log('entering the for if loop>>>');
                this.statePicklistValuArray.push({
                    label: element.dbu_State__c,
                    value: element.dbu_State_Code__c
                });
            }
        });
        this.statePicklistValuArray.sort((a, b) => (a.label > b.label) ? 1 : -1);
    }

    handleSelectedAddressBilling(event) {
        console.log('chekbox in manage address' + event.target.getAttribute('data-addressline1bil'));
        this.addressline1ValBil = event.target.getAttribute('data-addressline1bil');
        this.addressline2ValBil = event.target.getAttribute('data-addressline2bil');
        this.addresscityBil = event.target.getAttribute('data-addresscitybil');
        this.addressstateBil = event.target.getAttribute('data-addressstatebil');
        this.addresspostalcodeBil = event.target.getAttribute('data-addresspostalcodebil');
        this.addresscountryBil = event.target.getAttribute('data-addresscountrybil');
        this.add1ValBil = this.addressline1ValBil;
        this.add2ValBil = this.addressline2ValBil;
        this.cityValBil = this.addresscityBil;
        this.stateValBil = this.addressstateBil;
        this.valueDrpdwnBil = this.addressstateBil;
        this.zipValBil = this.addresspostalcodeBil;
        this.cntryValBil = this.addresscountryBil;
        if (this.cntryValBil == this.allLabels.storeUSA) {
            this.usLocBil = true;
        } else if (this.cntryValBil == this.allLabels.storeCanada) {
            this.usLocBil = false;
        }
        console.log('this.usLoc in connected6' + this.usLoc);
        this.statePicklistValuArrayBil = [];
        this.statesMtData.forEach(element => {
            if (element.dbu_Country_Code__c == this.cntryValBil) {
                this.statePicklistValuArrayBil.push({
                    label: element.dbu_State__c,
                    value: element.dbu_State_Code__c
                });
            }
        });
        this.statePicklistValuArrayBil.sort((a, b) => (a.label > b.label) ? 1 : -1);
    }

    regiser() {
        console.log('event registered in user n shipping');
        pubsub.register('sendDefaultShipAddress', this.handleSendDefaultShipAddress);
    }

    handleSendDefaultShipAddress(event) {
        console.log('comin to handler in user unfo' + event);

    }
}