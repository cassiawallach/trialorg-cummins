import { LightningElement,api,track,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import communityName from'@salesforce/label/c.dbu_communityName';
//import getAccount from '@salesforce/apex/dbu_GeolocationController.getAccount';
import serachAccs from '@salesforce/apex/dbu_GeolocationController.retriveAccs';
import updateOrder from '@salesforce/apex/dbu_GeolocationController.updateOrder';
import updateShipTo from '@salesforce/apex/dbu_GeolocationController.updateShipTo';
import searchicon from '@salesforce/resourceUrl/HeaderSearchIcon';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getShipToStoreAddress from '@salesforce/apex/dbu_GeolocationController.getShipToStoreAddress';
import updateShipToStoreAddress from '@salesforce/apex/dbu_GeolocationController.updateShipToStoreAddress';
//import resetSelectedOrdItems from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.resetSelectedOrdItems';
import returnOrderItemDetails from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.returnOrderItemDetails';
import returnOrderItemsLocation from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.returnOrderItemsLocation';

//import {countries, states} from 'c/dbu_countryAndState';
import { perfixCurrencyISOCode,getPickUpOnlyStores,validateCookiesData } from "c/serviceComponent";
//-------------Importing Custom Labels----------------
import dbu_CoreCharge_Availability_Msg from "@salesforce/label/c.dbu_CoreCharge_Availability_Msg";
import dbu_Return_PageHeader from "@salesforce/label/c.dbu_Return_PageHeader";
import dbu_Return_PageSubHeader from "@salesforce/label/c.dbu_Return_PageSubHeader";
import dbu_Return_Product from "@salesforce/label/c.dbu_Return_Product";
import dbu_Return_Quantity from "@salesforce/label/c.dbu_Return_Quantity";
import dbu_Return_Reason_for_Return from "@salesforce/label/c.dbu_Return_Reason_for_Return";
import dbu_Return_Price from "@salesforce/label/c.dbu_Return_Price";
import dbu_Return_HandlingFee10 from "@salesforce/label/c.dbu_Return_HandlingFee10";
import dbu_Return_ProductNotReturnable from "@salesforce/label/c.dbu_Return_ProductNotReturnable";
import dbu_Return_HandlingFee15 from "@salesforce/label/c.dbu_Return_HandlingFee15";
import dbu_Return_NoRemainingQty from "@salesforce/label/c.dbu_Return_NoRemainingQty";
import dbu_Return_ContactCS from "@salesforce/label/c.dbu_Return_ContactCS";
import dbu_Return_Core_Refund from "@salesforce/label/c.dbu_Return_Core_Refund";
import dbu_Return_EstTax from "@salesforce/label/c.dbu_Return_EstTax";
import dbu_Return_EstAmt from "@salesforce/label/c.dbu_Return_EstAmt";
import dbu_Return_AddInfo from "@salesforce/label/c.dbu_Return_AddInfo";
import dbu_Return_BtnLabel_Proceed from "@salesforce/label/c.dbu_Return_BtnLabel_Proceed";
import dbu_Return_BtnLabel_ProceedToReturn from "@salesforce/label/c.dbu_Return_BtnLabel_ProceedToReturn";
import dbu_Return_Part_no_longer_wanted from "@salesforce/label/c.dbu_Return_Part_no_longer_wanted";
import dbu_Return_Ordered_the_wrong_part from "@salesforce/label/c.dbu_Return_Ordered_the_wrong_part";
import dbu_Return_Damaged_in_shipping from "@salesforce/label/c.dbu_Return_Damaged_in_shipping";
import dbu_Return_Incorrect_part_was_received from "@salesforce/label/c.dbu_Return_Incorrect_part_was_received";
import dbu_Return_Toast_ReasonForReturn from "@salesforce/label/c.dbu_Return_Toast_ReasonForReturn";
import dbu_Return_ReturnMethod_PageHeader from "@salesforce/label/c.dbu_Return_ReturnMethod_PageHeader";
import dbu_Return_Select_Return_Method  from "@salesforce/label/c.dbu_Return_Select_Return_Method";
import dbu_Return_ShipLocationMsg from "@salesforce/label/c.dbu_Return_ShipLocationMsg";
import dbu_Return_Your_address from "@salesforce/label/c.dbu_Return_Your_address";
import dbu_Return_Review_your_return_request  from "@salesforce/label/c.dbu_Return_Review_your_return_request";
import dbu_Return_Toast_AddressUpdated  from "@salesforce/label/c.dbu_Return_Toast_AddressUpdated";
import dbu_Return_BtnLabel_Edit  from "@salesforce/label/c.dbu_Return_BtnLabel_Edit";
import dbu_Return_BtnLabel_Save  from "@salesforce/label/c.dbu_Return_BtnLabel_Save";
import dbu_Return_BtnLabel_Back  from "@salesforce/label/c.dbu_Return_BtnLabel_Back";
import dbu_ReturnMapStoreName  from "@salesforce/label/c.dbu_ReturnMapStoreName";
import dbu_ReturnMapOpenHours  from "@salesforce/label/c.dbu_ReturnMapOpenHours";
import dbu_ReturnMapDistance  from "@salesforce/label/c.dbu_ReturnMapDistance";
import dbu_ReturnMapContact  from "@salesforce/label/c.dbu_ReturnMapContact";
import dbu_ReturnSelectBtnLabel  from "@salesforce/label/c.dbu_ReturnSelectBtnLabel";
import dbu_ReturnPrev  from "@salesforce/label/c.dbu_ReturnPrev";
import dbu_ReturnNext  from "@salesforce/label/c.dbu_ReturnNext";
import dbu_ReturnShowingPage  from "@salesforce/label/c.dbu_ReturnShowingPage";
import dbu_checkoutPage_Business_Hours from "@salesforce/label/c.dbu_checkoutPage_Business_Hours";

import dbu_ShipToStore  from "@salesforce/label/c.dbu_ShipToStore";
import dbu_DropOffAtStore  from "@salesforce/label/c.dbu_DropOffAtStore";
import dbu_LocationSearchInputError  from "@salesforce/label/c.dbu_LocationSearchInputError";
import dbu_NoRecordFoundError  from "@salesforce/label/c.dbu_NoRecordFoundError";

/*added by MT*/
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';//custom label refres to'CA'
import getStatesData from '@salesforce/apex/dbu_CustomsettingCntrl.getStatesData';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
/*added by MT*/
import isGuest from '@salesforce/user/isGuest';

export default class Dbu_ReturnMethodCmp extends NavigationMixin(LightningElement) {
    @api orderId;
    @track shipToStoreAddress = false;
    @track dropOffAtStoreAddress = false;
    @track isReadOnly = true;
    @track addressValue ;
    @track showEdit = true;
    @track showSave = false;
    @track accounts;
    @track  strSearchAccName = '';
    iconsearch = searchicon + '#searchIcon';
    @track searchData;
    @track errorMsg = '';
    @track latitude;
    @track longitude;
    @track dbuPickupOnlyFlag = false;
    @track dbuShipToOnlyFlag = false;
    @track screenLoaded = false;
    @track countryOptions =[];
    @track stateOptions = [];
    @track btnInactive = true;
    @track currentPageNumber = 1;
    @track maximumPageNumber;
    @track numberOfRecordsToDisplay = 5;
    @track storeLocationsToDisplay = [];
    @track showErrorMsg = false;
    @track sendLocBackToChangeLocTile;
    @track currentStore;
    @track valueDrpdwnMap = '';
    @track stateValMap = '';
    @track statesMtData;
    @track currentStorelocation;
    @track statesPicklistForMap = [];
    @track showState;
    @track isGuestU = isGuest;

    //-------Custom Labels-----
    label = {
        dbu_CoreCharge_Availability_Msg,
        dbu_Return_PageHeader,
        dbu_Return_PageSubHeader,
        dbu_Return_Product,
        dbu_Return_Quantity,
        dbu_Return_Reason_for_Return,
        dbu_Return_Price,
        dbu_Return_HandlingFee10,
        dbu_Return_ProductNotReturnable,
        dbu_Return_HandlingFee15,
        dbu_Return_NoRemainingQty,
        dbu_Return_ContactCS,
        dbu_Return_Core_Refund,
        dbu_Return_EstTax,
        dbu_Return_EstAmt,
        dbu_Return_AddInfo,
        dbu_Return_BtnLabel_Proceed,
        dbu_Return_BtnLabel_ProceedToReturn,
        dbu_Return_Part_no_longer_wanted,
        dbu_Return_Ordered_the_wrong_part,
        dbu_Return_Damaged_in_shipping,
        dbu_Return_Incorrect_part_was_received,
        dbu_Return_Toast_ReasonForReturn,
        dbu_Return_ReturnMethod_PageHeader,
        dbu_Return_Select_Return_Method,
        dbu_Return_ShipLocationMsg,
        dbu_Return_Your_address,
        dbu_Return_Review_your_return_request,
        dbu_Return_Toast_AddressUpdated,
        dbu_Return_BtnLabel_Edit,
        dbu_Return_BtnLabel_Save,
        dbu_Return_BtnLabel_Back,
        dbu_ReturnMapStoreName,
        dbu_ReturnMapOpenHours,
        dbu_ReturnMapDistance,
        dbu_ReturnMapContact,
        dbu_ReturnSelectBtnLabel,
        dbu_ReturnPrev,
        dbu_ReturnNext,
        dbu_ReturnShowingPage,
        dbu_ShipToStore,
        dbu_DropOffAtStore,
        dbu_LocationSearchInputError,
        dbu_NoRecordFoundError,
        dbu_checkoutPage_Business_Hours
    };
    
    //-------------------------


   /* @track stateOptions = [];
    countryOptions = [
        { label: 'United States', value: 'US' },
        { label: 'Canada', value: 'CA' },
        
    ];

    handleCountryChange(event){
        let selectedCountry = event.target.value;
        alert(selectedCountry);
        if(selectedCountry === 'US'){
            this.stateOptions = [
                { label: 'Alabama', value: 'AL' },
                { label: 'California', value: 'CA' },
                
            ];
        }
        if(selectedCountry === 'CA'){
            this.stateOptions = [
                { label: 'British Columbia', value: 'BC' },
                { label: 'Ontario', value: 'ON' },
                
            ];
        }
    }*/
  
  /*  handleCountryChange(event){
        let selectedCountry = event.target.value;
        this.stateOptions = states(selectedCountry);

    }*/
    
    connectedCallback() {
        this.screenLoaded = true;
        let urlParameters = new URL(window.location.href).searchParams;
        this.orderId = urlParameters.get('orderid');
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        //  this.sendLocBackToChangeLocTile = url.searchParams.get("store");
        this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');

        /*added by MT */
        if (this.sendLocBackToChangeLocTile == storeUSA) {
            this.currentStorelocation = storeUSA;
            this.showState = true;
        } else if (this.sendLocBackToChangeLocTile == storeCA || this.sendLocBackToChangeLocTile == storeCAF) {
            this.currentStorelocation = storeCanada;
            this.showState = false;
        }
        /*added by MT */
        this.getPickupOnly();
        // Security changes, Added by Ranadip
        if(this.isGuestU && validateCookiesData(this.orderId)){
            return;
        }//end here

        this.updateOrder(false);
        // this.countryOptions = countries();
    }

    /*to defined picklist values based on states code and metada- added by MT */
    @wire(getStatesData)
    wiredgetStatesData({
        error,
        data
    }) {
        if (data) {
            this.statesMtData = data;
        }else if(error){
            this.error = error;
        }
    }
    /*to defined picklist values based on states code and metada- added by MT */




    

    getPickupOnly(){
        returnOrderItemsLocation({
            urlParam: window.location.href
        })
        .then(result => {
           
            if (result) {
                console.log('===result.isPickupOnly===='+result.isPickupOnly);
                console.log('===result.isShipTo===='+result.isShipTo);
                
                    if(result.isShipTo){
                        this.dbuShipToOnlyFlag = true;
                        this.dbuPickupOnlyFlag = true;
                    }
                    if(result.isPickupOnly){
                        this.dbuPickupOnlyFlag = true;
                    }
               this.screenLoaded = false;
            }
        })
        .catch(error => {
            if (error) {
                this.errorMsg = error.body.message;
            }
        })
    }
    updateOrder(isShipTo){
    updateShipTo({
        isShipTo: isShipTo,
        orderId : this.orderId
    })
    .then(result => {
        if(isShipTo){
        let urlString = window.location.origin;
        let redirectURL =  urlString+communityName+'return-review?orderid='+ this.orderId + '&store=' + this.sendLocBackToChangeLocTile; 
        invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Proceed to refund review page', eventAction : 'Navigate from refund method page to refund review page'});                
        window.location.href = redirectURL;          
            /*this[NavigationMixin.Navigate]({
                "type": "standard__webPage",
                "attributes": {
                    "url": redirectURL
                }
            });*/
        }
    })
    .catch(error => {
        if (error) {
            this.errorMsg = error.body.message;
        }
    })
}
 
    proceed(){
        window.sessionStorage.setItem(this.orderId + 'rtnAddress',this.shipToStoreAddress);
       if(this.shipToStoreAddress === true || this.dropOffAtStoreAddress === true){  
           if(this.shipToStoreAddress === true){
            this.updateOrder(this.shipToStoreAddress);
           }else{
            let urlString = window.location.origin;
            let redirectURL =  urlString+communityName+'return-review?orderid='+ this.orderId + '&store=' + this.sendLocBackToChangeLocTile; 
            invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Proceed to refund review page', eventAction : 'Navigate from refund method page to refund review page'});                
            window.location.href = redirectURL;

                /*this[NavigationMixin.Navigate]({
                    "type": "standard__webPage",
                    "attributes": {
                        "url": redirectURL
                        
                    }
                });*/
           }
       }
    }

    get backToSelectItemPage(){
        let urlString = window.location.origin;
        return urlString+communityName+'OderItems?orderid='+ this.orderId;
    }

    shipTo(event){
        
        if(event.target.value === 'shipToStore'){
            invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'ShipTo Method', eventAction : 'Refund Method selected'});                            
            this.btnInactive = false;
            this.getShipToStoreAddress();
            this.shipToStoreAddress = true;
            this.dropOffAtStoreAddress = false;
          //  this.updateOrder(this.shipToStoreAddress);
        }else if(event.target.value === 'dropOffAtStore'){
            invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'DropOff Method', eventAction : 'Refund Method selected'});                            
            this.btnInactive = true;
            this.dropOffAtStoreAddress = true;
            this.shipToStoreAddress = false;
            this.getDropOffStores();
        }
    }
    
    @track shipToObj;

    getShipToStoreAddress(){
        this.screenLoaded = true;
        getShipToStoreAddress({
            orderId : this.orderId
            
        })
        .then(result => {
            this.shipToObj = result;
            let address1 = result.firstAddress;
            let address2 = result.secondAddress;
            let tAddress = result.thirdAddress;
            let city = result.city;
            let state = result.state;
            let postalCode = result.postalCode;
            let country = result.country;

           if(address1 == null || address1 == undefined){
            address1 = '';
           }
           if(address2 == null || address2 == undefined){
            address2 = '';
           }
           if(tAddress == null || tAddress == undefined){
                tAddress = '';
           }
           if(city == null || city == undefined){
                city = '';
           }
           if(state == null || state == undefined){
                state = '';
           }    
           if(postalCode == null || postalCode == undefined){
                postalCode = '';
           }
           if(country == null || country == undefined){
            country = '';
       }
            this.addressValue = address1 +" "+ address2 +" "+ tAddress +" "+ city +" "+ state +" "+ postalCode;
            this.screenLoaded = false;
       console.log('=======state===='+state);
          /*  this.template.querySelector('.addr1').value = address1;
            this.template.querySelector('.addr2').value = address2;
            this.template.querySelector('.city').value = city;
            this.template.querySelector('.state').value = state;
            this.template.querySelector('.country').value = country;
            this.template.querySelector('.postalCode').value = postalCode;*/
           
        })
        .catch(error => {
            window.console.log('error =====> ' + JSON.stringify(error));
            if (error) {
                this.errorMsg = error.body.message;
            }
        })

    }

    getDropOffStores() {
        this.screenLoaded = true;
        var accName = '';
        // var countryCode = 'US';
        //--- Calling Service componet function
        console.log('==currentStore===' + this.currentStorelocation);

        getPickUpOnlyStores(accName, this.currentStorelocation)
            .then(data => {
                console.log('Service Component Resp=====' + data);
                this.accounts = data;
                this.accountsToDisplay = data;
                this.statesPicklistForMap = [];
                for (let i = 0; i < this.accountsToDisplay.length; i++) {
                    this.statesMtData.forEach(element => {
                        let stateItemExist = this.statesPicklistForMap.some(el => el.value === element.dbu_State_Code__c);
                        if (!stateItemExist) {
                            if (element.dbu_Country_Code__c == this.currentStorelocation &&
                                element.dbu_State__c == this.accountsToDisplay[i].location.State) {
                                this.statesPicklistForMap.push({
                                    label: element.dbu_State__c,
                                    value: element.dbu_State_Code__c
                                });
                            }
                        }
                    });
                    this.statesPicklistForMap.sort((a, b) => (a.label > b.label) ? 1 : -1);
                }
                this.maximumPageNumber = Math.ceil(this.accountsToDisplay.length / this.numberOfRecordsToDisplay);
                this.handlePaginationChange();
                this.screenLoaded = false;
            })
            .catch(error => {
                console.log(error.message);
            });
        // if (navigator.geolocation) {
        //     navigator.geolocation.getCurrentPosition(
        //         (position) => {
        //              this.latitude = position.coords.latitude;
        //              this.longitude = position.coords.longitude;
        //             if (this.latitude != '' && this.latitude != 'undefined' &&
        //                 this.longitude != '' && this.longitude != 'undefined') {
        //                     serachAccs({
        //                         strAccName : '',
        //                         lat: this.latitude,
        //                         lngtde: this.longitude
        //                 }).then(resultMap => {
        //                     if (resultMap) {
        //                         console.log('data in cc geo map>>>' + JSON.stringify(resultMap));
        //                         this.accounts = resultMap;
        //                         this.accountsToDisplay = [];
        //                         let allAccountStringData = JSON.stringify(this.accounts);
        //                         let allAccountsData = JSON.parse(allAccountStringData);
        //                         let accountArrayData = Array.from(allAccountsData);
        //                         this.accountsToDisplay = accountArrayData.sort((a, b) => (a.distance > b.distance) ? 1 : -1);
        //                         console.log('data in cc geo map 111>>>' + JSON.stringify(this.accountsToDisplay)); 
        //                         this.error = undefined;
        //                         console.log('acc length=='+this.accounts.length);
        //                         this.maximumPageNumber = Math.ceil(this.accountsToDisplay.length / this.numberOfRecordsToDisplay);
        //                         console.log('this.maximumPageNumber=>', this.maximumPageNumber);
        //                         this.handlePaginationChange();

        //                         this.screenLoaded = false;
        //                     }
        //                 }).catch(error => {
        //                     this.error = error.message;
        //                     console.log('result from addressbook error ', JSON.stringify(this.error));
        //                 });
        //             }
        //         });
        // }
    }


     //storeLocationsToDisplay
     prevPage() {
        console.log('prevPage=>currentPageNumber=>' + this.currentPageNumber);
        if (this.currentPageNumber != 1)
            this.currentPageNumber = this.currentPageNumber - 1;
        this.template.querySelector('.nextLink').style.display = 'inline-block';
        this.handlePaginationChange();
    }

    nextPage() {
        console.log('nextPage=>currentPageNumber=>' + this.currentPageNumber);

        if (this.currentPageNumber != this.maximumPageNumber)
            this.currentPageNumber = this.currentPageNumber + 1;
        this.template.querySelector('.prevLink').style.display = 'inline-block';
        this.handlePaginationChange();
    }

    // handlePaginationChange() {
    //     console.log('Function called');
    //     this.storeLocationsToDisplay = [];
    //     let allAccountString = JSON.stringify(this.accountsToDisplay);
    //     console.log('allAccountString===='+allAccountString);
    //     let allAccounts = JSON.parse(allAccountString);
    //     let accountArray = Array.from(allAccounts);
    //     if (this.currentPageNumber == this.maximumPageNumber) {
    //         this.template.querySelector('.nextLink').style.display = 'none';
    //         this.template.querySelector('.prevLink').style.display = 'inline-block';
    //         this.storeLocationsToDisplay = accountArray.slice((this.currentPageNumber - 1) * this.numberOfRecordsToDisplay, this.accounts.length);
    //     }
    //     else {
    //         if (this.currentPageNumber === 1) {
    //             this.template.querySelector('.prevLink').style.display = 'none';
    //             this.template.querySelector('.nextLink').style.display = 'inline-block';

    //         }
    //         this.storeLocationsToDisplay = accountArray.slice((this.currentPageNumber - 1) * this.numberOfRecordsToDisplay, this.currentPageNumber * this.numberOfRecordsToDisplay);
    //         console.log('handlePaginationChange=>storeLocationsToDisplay=>' + this.storeLocationsToDisplay);
    //     }
    // }

    handlePaginationChange() {
        this.storeLocationsToDisplay = [];
        let allAccountString = JSON.stringify(this.accountsToDisplay);
        let allAccounts = JSON.parse(allAccountString);
        let accountArray = Array.from(allAccounts);
        if ((this.currentPageNumber == this.maximumPageNumber) && this.currentPageNumber != 1) {
            this.template.querySelector('.nextLink').style.display = 'none';
            this.template.querySelector('.prevLink').style.display = 'inline-block';
            this.storeLocationsToDisplay = accountArray.slice((this.currentPageNumber - 1) * this.numberOfRecordsToDisplay, this.accounts.length);
        }
        
        if (this.currentPageNumber === 1) {
            this.template.querySelector('.prevLink').style.display = 'none';
            this.template.querySelector('.nextLink').style.display = 'inline-block';
        }
        if (this.currentPageNumber == 1 && this.maximumPageNumber == 1) {
            this.template.querySelector('.prevLink').style.display = 'none';
            this.template.querySelector('.nextLink').style.display = 'none';
        }
        this.storeLocationsToDisplay = accountArray.slice((this.currentPageNumber - 1) * this.numberOfRecordsToDisplay, this.currentPageNumber * this.numberOfRecordsToDisplay);
    }


//    updateSeachKey(event) {
//         this.strSearchAccName = event.target.value.trim();
//         if(this.strSearchAccName.length === 0){
//             this.getDropOffStores();
//             this.showErrorMsg = false; 
//         }
//     }


    showSelectedSates(event){
        this.strSearchAccName = event.target.value;
        console.log('this.strSearchAccName > ' + this.strSearchAccName);
        invokeGoogleAnalyticsService('STATE COUNTRY FOR PICKUP REFFUND', {state : this.strSearchAccName, country : this.currentStorelocation});        
    }

    handleSearch() {
        // var countryCode = 'US'; // HardCoded Value
        if (this.strSearchAccName != null) {
            this.showAccResult = true;
            if (!this.strSearchAccName) {
                this.showErrorMsg = true;
                this.errorMsg = dbu_LocationSearchInputError;
                this.accounts = undefined;
                return;
            }
            this.screenLoaded = true;
            getPickUpOnlyStores(this.strSearchAccName, this.currentStorelocation)
                .then(data => {

                    console.log('Service Component Resp=====' + data);
                    console.log('Searched Records' + JSON.stringify(data));
                    this.accountsToDisplay = data;
                    this.maximumPageNumber = Math.ceil(this.accountsToDisplay.length / this.numberOfRecordsToDisplay);
                    if (this.maximumPageNumber > 0) {
                        this.showErrorMsg = false;
                        this.handlePaginationChange();
                    } else {
                        this.handlePaginationChange();
                        this.showErrorMsg = true;
                        this.errorMsg = dbu_NoRecordFoundError;
                    }
                    console.log('this.maximumPageNumber=>', this.maximumPageNumber);

                    this.screenLoaded = false;
                    // this.showErrorMsg = false;
                })
                .catch(error => {
                    this.accounts = undefined;
                    window.console.log('error =====> ' + JSON.stringify(error));
                    // if (error) {
                    //          this.screenLoaded = false;
                    //            this.showErrorMsg = true;
                    //            this.errorMsg = 'No Records Found';

                    //      }
                });
            // serachAccs({
            //         strAccName: this.strSearchAccName,
            //         lat: this.latitude,
            //         lngtde:this.longitude
            //     })
            //     .then(result => {
            //         this.accounts = '';
            //         console.log('resultofaccountdata>>' + result.length);
            //         this.accounts = result;
            //         this.accountsToDisplay = [];
            //         let allAccountStringData = JSON.stringify(this.accounts);
            //         let allAccountsData = JSON.parse(allAccountStringData);
            //         let accountArrayData = Array.from(allAccountsData);
            //         this.accountsToDisplay = accountArrayData.sort((a, b) => (a.distance > b.distance) ? 1 : -1);
            //         this.maximumPageNumber = Math.ceil(this.accountsToDisplay.length / this.numberOfRecordsToDisplay);
            //             console.log('this.maximumPageNumber=>', this.maximumPageNumber);
            //             this.handlePaginationChange();
            //             this.showErrorMsg = false;
            //             this.screenLoaded = false;
            //     })
            //     .catch(error => {
            //         this.accounts = undefined;
            //         window.console.log('error =====> ' + JSON.stringify(error));
            //         if (error) {
            //                 this.screenLoaded = false;
            //                 this.showErrorMsg = true;
            //                 this.errorMsg = 'No Records Found';

            //         }
            //     })
        }
    }

    getSelectedStore(event){
       this.btnInactive = false;
        let selectedRecordId = event.target.value;
        console.log('==selectedRecordId='+selectedRecordId);
        console.log('===this.accounts.length=='+this.accounts.length);
        let gaeventaction = event.target.getAttribute('data-pickupstorename') + ' - ' + this.strSearchAccName+ ' - ' +this.currentStorelocation;        
        invokeGoogleAnalyticsService('BUTTON CLICK', {eventAction : gaeventaction, eventName : 'PickUp Store Selected for refund'});                    
        for(let i=0;i<this.accounts.length;i++){
            if(this.accounts[i].id === selectedRecordId){
                console.log('======this.accounts[i].id ==='+this.accounts[i].id );
               updateOrder({
                orderId : this.orderId,
                orderRecord: this.accounts[i]
            })
            .then(result => {
                console.log('resultofaccountdata>>' + result);
               
            })
            .catch(error => {
                window.console.log('error =====> ' + JSON.stringify(error));
                if (error) {
                    this.errorMsg = error.body.message;
                }
            })

            }
        }
        
    }
   // @track openModal = false;

    editAddress(){
        this.btnInactive = true;
        this.isReadOnly = false;
        this.showEdit = false;
        this.showSave = true;
       // this.openModal =true;

    }
    saveAddress(event){
        this.screenLoaded = true;
     let changedAddress = this.template.querySelector(".shipAddress").value;  
    
  /*  let addr1 = this.template.querySelector(".addr1").value;
    let addr2 = this.template.querySelector(".addr2").value;
    let city = this.template.querySelector(".city").value;
    let state = this.template.querySelector(".state").value;
    let country = this.template.querySelector(".country").value;
    let postalCode = this.template.querySelector(".postalCode").value;
    let changedAddress= addr1 +" "+ addr2 +" "+ city +" "+ state +" "+ country +" "+ postalCode;*/
      if(changedAddress == null || changedAddress == undefined){

      }else{
        updateShipToStoreAddress({
            orderId : this.orderId,
            newShipToAddress: changedAddress
        })
        .then(result => {
            this.screenLoaded= false;
            const event = new ShowToastEvent({
                title: 'Success',
                message: dbu_Return_Toast_AddressUpdated,
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
            this.btnInactive = false;
        })
        .catch(error => {
            window.console.log('error =====> ' + JSON.stringify(error));
            if (error) {
                this.errorMsg = error.body.message;
            }
        })
      }
      this.showEdit = true;
      this.showSave = false;
      this.isReadOnly = true;
    }

    backToReturnMethodPage(){
        
     /*   resetSelectedOrdItems({
            orderId : this.orderId
            
        })
        .then(result => {
            console.log('updated>>');
        })
        .catch(error => {
            if (error) {
                this.errorMsg = error.body.message;
            }
        })*/

        let urlString = window.location.origin;
        let redirectURL =  urlString+communityName+'returns-parts?orderid='+ this.orderId + '&store=' + this.sendLocBackToChangeLocTile;
        invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Back to refund method page', eventAction : 'Navigate from refund method page to parts return page'});                
        window.location.href = redirectURL;
        /*
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": redirectURL
            }
        });*/
     
    }

   
}