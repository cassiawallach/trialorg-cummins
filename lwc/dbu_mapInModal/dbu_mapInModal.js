import { LightningElement,track,api,wire} from 'lwc';
import { perfixCurrencyISOCode,getPickUpOnlyStores } from "c/serviceComponent";
import dbu_ReturnMapStoreName  from "@salesforce/label/c.dbu_ReturnMapStoreName";
import dbu_ReturnMapOpenHours  from "@salesforce/label/c.dbu_ReturnMapOpenHours";
import dbu_ReturnMapDistance  from "@salesforce/label/c.dbu_ReturnMapDistance";
import dbu_ReturnMapContact  from "@salesforce/label/c.dbu_ReturnMapContact";
import dbu_ReturnSelectBtnLabel  from "@salesforce/label/c.dbu_ReturnSelectBtnLabel";
import dbu_ReturnPrev  from "@salesforce/label/c.dbu_ReturnPrev";
import dbu_ReturnNext  from "@salesforce/label/c.dbu_ReturnNext";
import dbu_ReturnShowingPage  from "@salesforce/label/c.dbu_ReturnShowingPage";
import dbu_checkoutPage_Business_Hours from "@salesforce/label/c.dbu_checkoutPage_Business_Hours";
import searchicon from '@salesforce/resourceUrl/HeaderSearchIcon';

import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';//custom label refres to'CA'
import getStatesData from '@salesforce/apex/dbu_CustomsettingCntrl.getStatesData';

import getLocationFromZipCode from '@salesforce/apex/dbu_GeoCodingApi.getLocationFromZipCode';
import retriveAccsZipCode from '@salesforce/apex/dbu_GeolocationController.retriveAccsZipCode';
import getPostalCode from '@salesforce/apex/dbu_GoogleMapApi.getPostalCode';
import TickerSymbol from '@salesforce/schema/Account.TickerSymbol';
import insertPickUpStoreDataInCCObj from '@salesforce/apex/dbu_CheckOutCntrl.insertPickUpStoreDataInCCObj';
import insertUpdatePickUpStoreDataInCCObj from '@salesforce/apex/dbu_CheckOutCntrl.insertUpdatePickUpStoreDataInCCObj';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
export default class Dbu_mapInModal extends LightningElement {
    @track isLoading=false
    @track isModalOpen = false;
    @track cartId;
    @track cartItemId;
    @track isShipTo;
    @track storeLocationsToDisplay = [];

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
    @track dbuPickupOnlyFlag = true;
    @track screenLoaded;
    @track countryOptions =[];
    @track stateOptions = [];
    @track btnInactive = true;
    @track currentPageNumber = 1;
    @track maximumPageNumber;
    @track numberOfRecordsToDisplay = 5;
  //  @track storeLocationsToDisplay = [];
    @track showErrorMsg = false;
    @track sendLocBackToChangeLocTile;
    @track currentStore;
    @track valueDrpdwnMap = '';
    @track stateValMap = '';
    @track statesMtData;
    @track currentStorelocation;
    @track statesPicklistForMap = [];
    @track showState;
    @track zipCodeLat;
    @track zipCodeLng;
    @track zipCodeResultWrapper;
    @track pickupAddress;
    @track productId;
    @track activateApplybutton = false;
    label = {
        dbu_ReturnMapStoreName,
        dbu_ReturnMapOpenHours,
        dbu_ReturnMapDistance,
        dbu_ReturnMapContact,
        dbu_ReturnSelectBtnLabel,
        dbu_ReturnPrev,
        dbu_ReturnNext,
        dbu_ReturnShowingPage,
       // dbu_ShipToStore,
      //  dbu_DropOffAtStore,
        // dbu_LocationSearchInputError,
        // dbu_NoRecordFoundError,
        dbu_checkoutPage_Business_Hours
    };

    isdropoffLoc;
    //////
    @api
    get isdropoff() {
        //alert('Getter');
        return this.isdropoffLoc;
    }
    set isdropoff(value) {
        this.setAttribute('isdropoff', value);
        this.isdropoffLoc = value;
        //this.isShowMap();
    }
    
    @api isShowMap(cartId,cartItemId,isShipTo,productId) {
       console.log('cartId map ', cartId);
       console.log('cartItemId map ', cartItemId);
       console.log('isShipTo map ', isShipTo);
        this.cartId = cartId;
        this.cartItemId = cartItemId;
        this.isShipTo = isShipTo;
        this.productId = productId;
        if(this.isdropoffLoc){
            this.isModalOpen = true;
            getStatesData()
            .then(result => {
                this.statesMtData = result;
                this.getDropOffStores();
            })
            .catch(error => {
                this.error = error;
            });
        }
    }
    //////
    connectedCallback(){
        //this.setup();
        this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
        console.log('this.sendLocBackToChangeLocTile==='+this.sendLocBackToChangeLocTile);

        /*added by MT */
        if (this.sendLocBackToChangeLocTile == storeUSA) {
            this.currentStorelocation = storeUSA;
           // this.showState = true;
        } else if (this.sendLocBackToChangeLocTile == storeCA || this.sendLocBackToChangeLocTile == storeCAF) {
            this.currentStorelocation = storeCanada;
           // this.showState = false;
        }
        // console.log('isdropoff==='+this.isdropoff);
        // if(this.isdropoff){
        //     this.isModalOpen = true;
        //     getStatesData()
        //     .then(result => {
        //         this.statesMtData = result;
        //         this.getDropOffStores();
        //     })
        //     .catch(error => {
        //         this.error = error;
        //     });
            
        // }
    }

    
    /*to defined picklist values based on states code and metada- added by MT */
    // @wire(getStatesData)
    // wiredgetStatesData({
    //     error,
    //     data
    // }) {
    //     if (data) {
    //         this.statesMtData = data;
    //     }else if(error){
    //         this.error = error;
    //     }
    // }
    /*to defined picklist values based on states code and metada- added by MT */
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname : 'Close Pick up from store modal on cart page'});
        this.isModalOpen = false;
        this.activateApplybutton = false;
        this.dispatchEvent( new CustomEvent( 'pass', {
            detail : null
        } ) );
    }

  //  @track showTable = false;
    getDropOffStores() {
        // if(this.strSearchAccName !== '' && this.strSearchAccName !== undefined){
        //     this.showTable = true;
        //     this.retreivePostalCode();
        // }
        this.retreivePostalCode();
        
        // this.screenLoaded = true;
        // var accName = '';
        // // var countryCode = 'US';
        // //--- Calling Service componet function
        // console.log('==currentStore===' + this.currentStorelocation);

        // getPickUpOnlyStores(accName, this.currentStorelocation)
        //     .then(data => {

        //         console.log('Service Component Resp=====' + data);
        //         this.retreivePostalCode();
        //         this.accounts = data;
        //         this.accountsToDisplay = data;
        //         this.statesPicklistForMap = [];
        //         for (let i = 0; i < this.accountsToDisplay.length; i++) {
        //             this.statesMtData.forEach(element => {
        //                 let stateItemExist = this.statesPicklistForMap.some(el => el.value === element.dbu_State_Code__c);
        //                 if (!stateItemExist) {
        //                     if (element.dbu_Country_Code__c == this.currentStorelocation &&
        //                         element.dbu_State__c == this.accountsToDisplay[i].location.State) {
        //                         this.statesPicklistForMap.push({
        //                             label: element.dbu_State__c,
        //                             value: element.dbu_State_Code__c
        //                         });
        //                     }
        //                 }
        //             });
        //             this.statesPicklistForMap.sort((a, b) => (a.label > b.label) ? 1 : -1);
        //         }
        //         this.maximumPageNumber = Math.ceil(this.accountsToDisplay.length / this.numberOfRecordsToDisplay);
        //         this.handlePaginationChange();
        //         this.screenLoaded = false;
        //     })
        //     .catch(error => {
        //         console.log(error.message);
        //     });
        
    }

    retreivePostalCode(){
        console.log('retreivePostalCode called');
        var latitude;
        var longitude;
       console.log('==navigator.geolocation='+navigator.geolocation);
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    console.log('Position Exist===='+position.coords);
                    latitude = position.coords.latitude;
                    longitude = position.coords.longitude;
                   console.log('latitude===='+latitude);
                   console.log('longitude===='+longitude);
                    if (latitude != '' && latitude != 'undefined' &&
                        longitude != '' && longitude != 'undefined') {
                            getPostalCode({
                            lat: latitude,
                            lng: longitude
                        }).then(result => {
                            if (result) {
                              console.log('postal code from google ===='+result);
                              this.strSearchAccName = result;
                              this.getNearByStores('',latitude,longitude);
                            // this.getNearByStores('',43.142,-85.049); // Hardcoded value
                            }
                        }).catch(error => {
                           
                            console.log('Error from Google Api', JSON.stringify(error));
                        });
                    }
                    // else{
                    //     getPickUpOnlyStores(this.strSearchAccName, this.currentStorelocation)
                    //     .then(data => {
        
                    //         console.log('Service Component Resp=====' + data);
                    //         console.log('Searched Records' + JSON.stringify(data));
                    //         this.accountsToDisplay = data;
                    //         this.maximumPageNumber = Math.ceil(this.accountsToDisplay.length / this.numberOfRecordsToDisplay);
                    //         if (this.maximumPageNumber > 0) {
                    //             this.showErrorMsg = false;
                    //             this.handlePaginationChange();
                    //         } else {
                    //             this.handlePaginationChange();
                    //             this.showErrorMsg = true;
                    //             this.errorMsg = dbu_NoRecordFoundError;
                    //         }
                    //         console.log('this.maximumPageNumber=>', this.maximumPageNumber);
        
                    //         this.screenLoaded = false;
                    //     })
                    //     .catch(error => {
                    //         console.log(error);
                    //     });
                    // }
                
            },(error) => {
                console.log('Location blocked by user');
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
                    })
                    .catch(error => {
                        console.log(error);
                    });
            },
                   
                       
                );
        }

        
    }

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

  //  @track showTable = false;
    handlePaginationChange() {
      //  if(this.accountsToDisplay.length > 0){
           // this.showTable= true;
        
        console.log('HandlePagination Called');
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
        console.log('current Page number=='+this.currentPageNumber);
        if (this.currentPageNumber > 1) {
              this.template.querySelector('.prevLink').style.display = 'inline-block';
          }
        this.storeLocationsToDisplay = accountArray.slice((this.currentPageNumber - 1) * this.numberOfRecordsToDisplay, this.currentPageNumber * this.numberOfRecordsToDisplay);
       console.log('==length==='+this.storeLocationsToDisplay.length);
       
           
  //  }
    }

    updateSeachKey(event) {
        console.log('event>>' + event.target.value);
        this.strSearchAccName = event.target.value;
    }

    searchOnEnter(event) {
        if (event.which == 13) {
            event.preventDefault();
            this.handleSearch();
        }
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
                })
                .catch(error => {
                    this.accounts = undefined;
                    window.console.log('Entered in Error Block ' + JSON.stringify(error));
                    if (error) {
                        console.log('Error True===');
                        console.log('this.strSearchAccName===='+this.strSearchAccName);
                        if(this.strSearchAccName){
                            getLocationFromZipCode({
                                zipCodeSearch:this.strSearchAccName
                            }).then(resultWrapper =>{
                                console.log('Result from backend');
                                this.zipCodeResultWrapper = resultWrapper;
                                this.zipCodeLat = this.zipCodeResultWrapper.results[0].geometry.location.lat;
                                this.zipCodeLng = this.zipCodeResultWrapper.results[0].geometry.location.lng;
                                console.log('resultWrapper11>>>>' +this.zipCodeLat +'>>>>>>'+this.zipCodeLng);
                                if(this.zipCodeLat && this.zipCodeLng){
                                    // retriveAccsZipCode({
                                    //     zipCode: this.strSearchAccName,
                                    //     lat: this.zipCodeLat,
                                    //     lngtde: this.zipCodeLng
                                    // }).then(result=>{
                                    //     this.executeResultFromCntrl(result);
                                    // }).catch(error=>{

                                    // })
                                    this.getNearByStores(this.strSearchAccName,this.zipCodeLat,this.zipCodeLng);
                                }
                            }).catch(error => {
                            })
                        }
                        this.isLoading = false;
                        this.error = error;
                    }
                });
            
        }
    }

    getNearByStores(searchAccName,zipCodeLat,zipCodeLong){
        console.log('searchAccName====='+searchAccName);
        console.log('zipCodeLat====='+zipCodeLat);
        console.log('zipCodeLong====='+zipCodeLong);
        retriveAccsZipCode({
            zipCode:searchAccName,
            lat: zipCodeLat,
            lngtde: zipCodeLong
        }).then(result=>{
            console.log('result====='+JSON.stringify(result));
            this.executeResultFromCntrl(result);
        }).catch(error=>{
            console.log(error);
        })
    }

    executeResultFromCntrl(result){
        console.log('entering the executecntrl method>>');
        this.isLoading = false;
        this.accounts = '';
        this.accounts = result;
        this.accountsToDisplay = [];
        let allAccountStringData = JSON.stringify(this.accounts);
        let allAccountsData = JSON.parse(allAccountStringData);
        let accountArrayData = Array.from(allAccountsData);

        for (let i = 0; i < accountArrayData.length; i++) {
            if (this.sendLocBackToChangeLocTile == storeUSA && accountArrayData[i].location.Country == 'U.S.A') {
                this.accountsToDisplay.push(accountArrayData[i]);
            } else if ((this.sendLocBackToChangeLocTile == storeCA || this.sendLocBackToChangeLocTile == storeCAF)
                && (accountArrayData[i].location.Country == storeCanada || accountArrayData[i].location.Country == 'Canada')) {
                this.accountsToDisplay.push(accountArrayData[i]);

            }

        }

        if (this.accountsToDisplay.length > 1) {
            console.log('before sorting data===='+JSON.stringify(this.accountsToDisplay));
            this.accountsToDisplay.sort((a, b) => (a.distance > b.distance) ? 1 : -1);
        }
        this.maximumPageNumber = Math.ceil(this.accountsToDisplay.length / this.numberOfRecordsToDisplay);

        this.handlePaginationChange();
        this.showErrorMsg = false;
    }

    storeLocationSelected(event) {
        console.log('entering the sleected button and the accound id' + event.target.getAttribute('data-accid') + '>>>>' +
        event.target.getAttribute('data-acczipcode') + ',,,,,,,' + event.target.getAttribute('data-storelocationcode')+'\tbusinesshrs\t'+event.target.getAttribute('data-businessHrs'));
        this.storeCdeVal = event.target.getAttribute('data-storelocationcode');
        this.pickupAddress = {
            pickupstorename: event.target.getAttribute('data-accdesc'),
            cityPickup: event.target.getAttribute('data-acccity'),
            streetPickup: event.target.getAttribute('data-accstreet'),
            statePickup: event.target.getAttribute('data-accstate'),
            zipPickup: event.target.getAttribute('data-acczipcode'),
            cntryPickup: event.target.getAttribute('data-acccountry'),
            businessHrs: event.target.getAttribute('data-businessHrs'),
            storeLocCode : event.target.getAttribute('data-storelocationcode'),
            timeZone : event.target.getAttribute('data-timezone'),
            zone : event.target.getAttribute('data-zone'),
            cartId : this.cartId,
            cartItemId : this.cartItemId,
            isShipTo: this.isShipTo,
            productId: this.productId,
            storeId : event.target.getAttribute('data-accid')
            }
            this.activateApplybutton = true;  
            invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Store selected', eventAction : 'Pickup from store - cart page'});                      
    }

    handleApply(){
        this.isLoading = true;
        if (this.pickupAddress != null) {
            console.log('pickupAddress===='+JSON.stringify(this.pickupAddress));
            //alert(JSON.stringify(this.pickupAddress));
            invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Applied Store for pickup', eventAction : 'Pickup from store - cart page'});                      
            insertUpdatePickUpStoreDataInCCObj({
                    storeAddressJson : JSON.stringify(this.pickupAddress)
                }).then(result => {
                    console.log('Map address result' + JSON.stringify(result));
                    this.dispatchEvent( new CustomEvent( 'pass', {
                        detail : this.pickupAddress
                    } ) );
                    console.log('Map Event Fired===='+ JSON.stringify(this.pickupAddress));
                    this.isLoading = false;
                    this.isModalOpen = false;
                }).catch(error => {
                    this.error = error;
                    console.log('error=>>' + this.error);
                });
                
            }
            this.activateApplybutton = false;

    }
    
    get ScreenLoaded() {
        return this.isLoading;
    }    

}