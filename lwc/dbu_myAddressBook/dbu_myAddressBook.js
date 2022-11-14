import {
    LightningElement,
    wire,
    track
} from 'lwc';
import fetchCCAddressShippingAndBilling from '@salesforce/apex/dbu_LoggedInUsrCntrl.fetchCCAddressShippingAndBilling';
//import fetchCCAddressShipping from '@salesforce/apex/dbu_LoggedInUsrCntrl.fetchCCAddressShipping';
//import fetchCCAddressBilling from '@salesforce/apex/dbu_LoggedInUsrCntrl.fetchCCAddressBilling';
import getContactIDFrLoginUsr from '@salesforce/apex/dbu_LoggedInUsrCntrl.getContactIDFrLoginUsr';
import updateCCAddress from '@salesforce/apex/dbu_CheckOutCntrl.updateCCAddress';
import addCCContactAddress from '@salesforce/apex/dbu_CheckOutCntrl.addCCContactAddress';
import deleteContactAdd from '@salesforce/apex/dbu_CheckOutCntrl.deleteContactAdd';
import getStatesData from '@salesforce/apex/dbu_CustomsettingCntrl.getStatesData';


import dbu_Address_Book from "@salesforce/label/c.dbu_Address_Book";
import dbu_myAddressBook_Address from "@salesforce/label/c.dbu_myAddressBook_Address";
import dbu_myAddressBook_Type from "@salesforce/label/c.dbu_myAddressBook_Type";
import dbu_myAddressBook_Actions from "@salesforce/label/c.dbu_myAddressBook_Actions";
import dbu_myAddressBook_Default from "@salesforce/label/c.dbu_myAddressBook_Default";
import dbu_myAddressBook_Edit from "@salesforce/label/c.dbu_myAddressBook_Edit";
import dbu_myAddressBook_Edit_Address from "@salesforce/label/c.dbu_myAddressBook_Edit_Address";
import dbu_myAddressBook_Company from "@salesforce/label/c.dbu_myAddressBook_Company";
import dbu_checkoutPage_firstName from "@salesforce/label/c.dbu_checkoutPage_firstName";
import dbu_checkoutPage_lastName from "@salesforce/label/c.dbu_checkoutPage_lastName";
import dbu_checkoutPage_address1 from "@salesforce/label/c.dbu_checkoutPage_address1";
import dbu_checkoutPage_address2 from "@salesforce/label/c.dbu_checkoutPage_address2";
import dbu_checkoutPage_city from "@salesforce/label/c.dbu_checkoutPage_city";
import dbu_checkoutPage_zipCode from "@salesforce/label/c.dbu_checkoutPage_zipCode";
import dbu_checkoutPage_postalCode from "@salesforce/label/c.dbu_checkoutPage_postalCode";
import dbu_myAddressBook_MandatoryCheck from "@salesforce/label/c.dbu_myAddressBook_MandatoryCheck";
import dbu_myAddressBook_Delete_this_address from "@salesforce/label/c.dbu_myAddressBook_Delete_this_address";
import dbu_myAddressBook_Default_address from "@salesforce/label/c.dbu_myAddressBook_Default_address";
import dbu_myAddressBook_Cancel from "@salesforce/label/c.dbu_myAddressBook_Cancel";
import dbu_myAddressBook_Save from "@salesforce/label/c.dbu_myAddressBook_Save";
import dbu_myAddressBook_Add_new_address from "@salesforce/label/c.dbu_myAddressBook_Add_new_address";
import dbu_myAddressBook_Close from "@salesforce/label/c.dbu_myAddressBook_Close";
import dbu_myAddressBook_Add_a_new_address from "@salesforce/label/c.dbu_myAddressBook_Add_a_new_address";
import getAddressAutoComplete from '@salesforce/apex/dbu_AddressSelectionCtrl.getAddressAutoComplete';
import getAddressDetailsFromPlaceId from '@salesforce/apex/dbu_AddressSelectionCtrl.getAddressDetailsFromPlaceId';

import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada'; //custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French'; //custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA'; //custom label refres to'CA'



export default class Dbu_myAddressBook extends LightningElement {
    @track ccAddressData;
    @track ccAddressDataBilling;
    @track showEditFormCCAddress = false;
    @track ccAddressDefaulted = false;
    @track mandateFlag = false;
    @track makeAddressDefault = false;
    @track isChecked = false;
    @track valueDrpdwn;


    //CC address shipping info variables starts here
    @track ccShiippingDetails = [];
    @track cmpnameVal = '';
    //@track addTypeVal = '';
    @track firstnameVal = '';
    @track lastnameVal = '';
    @track emailVal = '';
    @track phoneVal = '';
    @track add1Val = '';
    @track add2Val = '';
    @track cityVal = '';
    @track stateVal = '';
    @track zipVal = '';
    @track cntryVal = '';
    // @track defaulted = false;
    @track ccAddId = '';
    @track hideDefaultOption = false;
    @track shippingComments = 'Shipping';
    @track billingComments = 'Billing';
    @track contactId = '';
    //CC address shipping info variables starts here

    //Add new address variables starts here
    @track showNewAddressForm = false;
    @track cmpnameValNewAdd = '';
    @track addTypeValNewAdd = 'Shipping';
    @track firstnameValNewAdd = '';
    @track lastnameValNewAdd = '';
    @track add1ValNewAdd = '';
    @track add2ValNewAdd = '';
    @track cityValNewAdd = '';
    @track stateValNewAdd = '';
    @track zipValNewAdd = '';
    @track cntryValNewAdd = '';
    @track newCCAddress = [];
    //Add new address variables starts here

    //State and country picklist varaibles//
    @track statePicklistValues = '';
    @track statePicklistValuArray = [];
    @track arrayValues = '';

    @track statePicklistValuesCA = '';
    @track arrayValuesCA = '';
    @track defaultedEdit = false;
    @track addressLoaded = false;
    @track addressLoadedBill = false;
    @track countryItem = [];


    //state and country picklist variables//

    @track isLoading = true
    @track contactId = '';

    @track ccAddressDataShippingBilling = [];
    @track addressResults;
    @track selectedAddress;

    label = {
        dbu_Address_Book,
        dbu_myAddressBook_Address,
        dbu_myAddressBook_Type,
        dbu_myAddressBook_Actions,
        dbu_myAddressBook_Default,
        dbu_myAddressBook_Edit,
        dbu_myAddressBook_Edit_Address,
        dbu_myAddressBook_Company,
        dbu_checkoutPage_firstName,
        dbu_checkoutPage_lastName,
        dbu_checkoutPage_address1,
        dbu_checkoutPage_address2,
        dbu_checkoutPage_city,
        dbu_checkoutPage_zipCode,
        dbu_checkoutPage_postalCode,
        dbu_myAddressBook_MandatoryCheck,
        dbu_myAddressBook_Delete_this_address,
        dbu_myAddressBook_Default_address,
        dbu_myAddressBook_Cancel,
        dbu_myAddressBook_Save,
        dbu_myAddressBook_Add_new_address,
        dbu_myAddressBook_Close,
        dbu_myAddressBook_Add_a_new_address
    };


    get ScreenLoaded() {
        return this.isLoading;
    }


    @wire(getContactIDFrLoginUsr)
    wiredgetContactIDFrLoginUsr({
        error,
        data
    }) {
        if (data) {
            this.isLoading = false;
            console.log('contact data in getContactIDFrLoginUsr>>' + JSON.stringify(data));
            this.contactId = data;
            console.log('contact data in getContactIDFrLoginUsr>>' + this.contactId);
            this.error = undefined;
        } else if (error) {
            console.log('error in getContactIDFrLoginUsr>>>' + JSON.stringify(error));
            this.error = error;
            this.contactId = undefined;
        }
    }
    connectedCallback() {
        this.template.addEventListener('click',this.escapeStructure.bind(this)); //CECI-772 added bind(this)
        // if (!this.addressLoaded) {
        //     fetchCCAddressShipping()
        //         .then(result1 => {
        //             if (result1) {
        //                 this.isLoading = false;
        //                 console.log('data in cc address in result1 connectedCallback>>>' + JSON.stringify(result1));
        //                 this.ccAddressData = result1;
        //                 this.shippingComments = this.ccAddressData[0].shippingComments;
        //                 this.shippingComments = this.shippingComments.substring(0, this.shippingComments.lastIndexOf(" "));
        //                 //this.contactId = this.ccAddressData[0].dbuContact;
        //                 this.showEditFormCCAddress = false;
        //                 console.log('dbuContact connectedCallback' + this.ccAddressData[0].dbuDefaultAddress);
        //                 this.error = undefined;
        //             }

        //         }).catch(error => {
        //             this.error = error.message;
        //             console.log('result from addressbook error  connectedCallback', JSON.stringify(this.error));
        //         });
        //     this.addressLoaded = true;
        // }
        // console.log('eetring the laoded on bill0000' + this.addressLoadedBill);

        // if (!this.addressLoadedBill) {
        //     console.log('eetring the laoded on bill11 connectedCallback' + this.addressLoadedBill);
        //     fetchCCAddressBilling()
        //         .then(resultBill => {
        //             if (resultBill) {
        //                 this.isLoading = false;
        //                 console.log('data in cc addressBill connectedCallback>>>' + JSON.stringify(resultBill));
        //                 this.ccAddressDataBilling = resultBill;
        //                 this.billingComments = this.ccAddressDataBilling[0].shippingComments;
        //                 this.billingComments = this.billingComments.substring(0, this.billingComments.lastIndexOf(" "));
        //                 this.error = undefined;

        //             }

        //         }).catch(error => {
        //             this.error = error.message;
        //             console.log('result from connectedCallback ', JSON.stringify(this.error));
        //         });
        //     this.addressLoadedBill = true;

        // }


        if (!this.addressLoaded) {
            fetchCCAddressShippingAndBilling()
                    .then(resultFromApex => {
                        if (resultFromApex) {
                            this.isLoading = false;
                            console.log('data in cc address in result1 connectedCallback>>>' + JSON.stringify(resultFromApex[0].shippingWrapper));
                            console.log('data in cc address in result1 connectedCallback>>>' + JSON.stringify(resultFromApex[0].billingWrapper));

                            this.ccAddressDataShippingBilling = resultFromApex;
                            
                            this.showEditFormCCAddress = false;
                            console.log('dbuContact connectedCallback' + this.ccAddressData[0].dbuDefaultAddress);
                            this.error = undefined;
                        }
    
                    }).catch(error => {
                        this.error = error.message;
                        console.log('result from addressbook error  connectedCallback', JSON.stringify(this.error));
                    });
                this.addressLoaded = true;
            }

    }
    
    //CECI-772 added disconnectedCallback method
    disconnectedCallback() {
        this.template.removeEventListener('click',this.escapeStructure);
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
                this.statesMtData.forEach(element => {
                    let itemExist = this.countryItem.some(el => el.label === element.dbu_Country__c);
                    if (!itemExist) {
                        this.countryItem.push({
                            label: element.dbu_Country__c,
                            value: element.dbu_Country_Code__c
                        });
                    }
                });
                this.statePicklistValuArray = [];

                this.statesMtData.forEach(element => {
                    if (element.dbu_Country_Code__c == storeUSA) {
                        this.labelUS = true;
                        this.statePicklistValuArray.push({
                            label: element.dbu_State__c,
                            value: element.dbu_State_Code__c
                        });
                    } else if (element.dbu_Country_Code__c == storeCanada) {
                        this.labelUS = false;
                        this.statePicklistValuArray.push({
                            label: element.dbu_State__c,
                            value: element.dbu_State_Code__c
                        });

                    }
                });
                this.statePicklistValuArray.sort((a, b) => (a.label > b.label) ? 1 : -1);
            }
            this.error = undefined;
        } else if (error) {
            console.log('error>>>' + JSON.stringify(error));
            this.error = error;
            this.statePicklistValuesCA = undefined;
        }
    }
    addressAutoComp(event){
        const searchKey = event.target.value;
        //CECI-772 added if
        if (event.key === "Escape" || event.key === "Esc") {
            this.addressResults = undefined;
            return;
        }
        if(event.target.name == 'add1nameNewAdd')
            this.add1ValNewAdd = searchKey;
        else if(event.target.name == 'add1name')
            this.add1Val = searchKey;
        if(searchKey !== undefined && searchKey.length){
            getAddressAutoComplete({
                input : searchKey,
                countryCode : 'country:us|country:ca'
            })
            .then(result => {
                let options = JSON.parse(result);
                let predictions = options.predictions;
                let addresses = [];
                if (predictions.length > 0) {
                    for (let i = 0; i < predictions.length; i++) {
                        addresses.push({
                            PlaceId: predictions[i].place_id,
                            Description: predictions[i].description
                        });     
                    }
                }
                
                this.addressResults = addresses;
                this.selectedAddress = undefined;              
            })
            .catch(error => {
                console.log(error);
            });
        }else{
            this.addressResults = undefined;
        }
    }
    addressSelected(event){
        let datatarget = event.currentTarget.dataset.trg;
        getAddressDetailsFromPlaceId({
            placeId : event.currentTarget.dataset.plid,
            selectedAddress : event.currentTarget.dataset.desc
        })
        .then(result => {
            var placeResults = JSON.parse(result);
            console.log(placeResults);
            var placeIdResults = null;
            if(placeResults.result !== undefined && placeResults.result.address_components !== undefined){
                placeIdResults = placeResults.result;
            }else{
                placeIdResults = placeResults.results[0];
            }
            let address1Value = '';
            let cityValue = '';
            let stateValue = '';
            let zipValue = '';
            let countryValue ='';
            let addComponents = placeIdResults.address_components;
            for (const component of placeIdResults.address_components){
                const componentType = component.types[0];
                switch (componentType) {
                    case "street_number": {
                        address1Value = component.long_name
                      break;
                    }
              
                    case "route": {
                        address1Value+= ' '+component.long_name;
                      break;
                    }
              
                    case "postal_code": {
                        zipValue = component.long_name
                      break;
                    }

                    case "locality":
                        cityValue = component.long_name;
                      break;
              
                    case "administrative_area_level_1": {
                        stateValue = component.short_name;
                      break;
                    }

                    case "country": {
                        countryValue = component.short_name;
                    }
                }
            }
            if(datatarget == 'newAdd'){
                console.log('Fron New Address');
                this.add2ValNewAdd = '';
                this.add1ValNewAdd = address1Value;
                this.cityValNewAdd = cityValue;
                this.stateValNewAdd = stateValue;
                this.zipValNewAdd = zipValue;
                this.cntryValNewAdd = countryValue;
                this.template.querySelector('.add2ValNewAdd').focus();
            }else{
                this.add2Val = '';
                this.add1Val = address1Value;
                this.cityVal = cityValue;
                this.stateVal = stateValue;
                this.zipVal = zipValue;
                this.cntryVal = countryValue;
                this.template.querySelector('.add2ValEdit').focus();
            }
            this.addressResults = undefined;
        })
        .catch(error =>{
            console.log('Error Occured '+error);
        });

    }

    escapeStructure(e){
        if(e.target.classList.contains('slds-listbox__option-text') || e.target.classList.contains('add1ValEdit') || e.target.classList.contains('add1ValNewAddress')){
        }else{
            this.addressResults = undefined;
        }
    }
    closeAddressResults(e){
        if(e.target.name == 'add2nameNewAdd' || e.target.name == 'add2name')
        this.addressResults = undefined;
    }

    handleModifyCCAddress(event) {
        this.showEditFormCCAddress = true;
        console.log('comimg here to the handler');
        this.ccAddId = event.target.getAttribute('data-sfid');
        this.addTypeVal = event.target.getAttribute('data-shippingname');
        console.log('this.addTypeVal' + this.addTypeVal);
        this.add1Val = event.target.getAttribute('data-addressline1');
        this.add2Val = event.target.getAttribute('data-addressline2');
        this.firstnameVal = event.target.getAttribute('data-addressfstname');
        this.lastnameVal = event.target.getAttribute('data-addresslstname');
        this.cityVal = event.target.getAttribute('data-addresscity');
        this.stateVal = event.target.getAttribute('data-addressstate');
        this.valueDrpdwn = event.target.getAttribute('data-addressstate');
        this.zipVal = event.target.getAttribute('data-addresspostalcode');
        this.cntryVal = event.target.getAttribute('data-addresscountry');
        this.cmpnameVal = event.target.getAttribute('data-cmnyname');
        this.emailVal = event.target.getAttribute('data-email');
        this.phoneVal = event.target.getAttribute('data-phn');
        console.log('awbdjwdjn' + event.target.getAttribute('data-defaultaddress'));
        console.log('chekbox in manage address' + this.cmpnameVal);

        if (event.target.getAttribute('data-defaultaddress') === 'true') {
            console.log('this.isChecked' + this.isChecked);
            this.isChecked = true;
            this.ccAddressDefaulted = true;

        } else if (event.target.getAttribute('data-defaultaddress') === 'false') {
            console.log('else part' + event.target.getAttribute('data-defaultaddress'));
            this.isChecked = false;
            this.ccAddressDefaulted = false;
            console.log('this.isChecked in else' + this.isChecked)
        }
        if (event.target.getAttribute('data-addresscountry') === storeUSA) {
            this.labelUS = true;
            this.statePicklistValuArray = [];
            this.statesMtData.forEach(element => {
                if (element.dbu_Country_Code__c == storeUSA) {
                    this.statePicklistValuArray.push({
                        label: element.dbu_State__c,
                        value: element.dbu_State_Code__c
                    });
                }
            });
            this.statePicklistValuArray.sort((a, b) => (a.label > b.label) ? 1 : -1);

        }
        if (event.target.getAttribute('data-addresscountry') === storeCanada) {
            this.labelUS = false;
            this.statePicklistValuArray = [];
            this.statesMtData.forEach(element => {
                if (element.dbu_Country_Code__c == storeCanada) {
                    this.statePicklistValuArray.push({
                        label: element.dbu_State__c,
                        value: element.dbu_State_Code__c
                    });
                }
            });
            this.statePicklistValuArray.sort((a, b) => (a.label > b.label) ? 1 : -1);
        }


        this.ccShiippingDetails = [{
            cmpnyName: this.cmpnyName,
            addType: this.addTypeVal,
            fstnameData: this.firstnameVal,
            lstnameData: this.lastnameVal,
            emailData: this.emailVal,
            phnData: this.phoneVal,
            add1Data: this.add1Val,
            add2Data: this.add2Val,
            cityData: this.cityVal,
            stateData: this.stateVal,
            zipData: this.zipVal,
            cntryData: this.cntryVal
        }];
    }

    handleModifyccAddressBil(event) {
        this.showEditFormCCAddress = true;
        console.log('chekbox in manage address' + event.target.getAttribute('data-addressfstname'));
        this.ccAddId = event.target.getAttribute('data-sfidbil');
        this.addTypeVal = event.target.getAttribute('data-billingname');
        this.add1Val = event.target.getAttribute('data-addressline1bil');
        this.add2Val = event.target.getAttribute('data-addressline2bil');
        this.firstnameVal = event.target.getAttribute('data-addressfirstnamebil');
        this.lastnameVal = event.target.getAttribute('data-addresslstnamebil');
        this.cityVal = event.target.getAttribute('data-addresscitybil');
        this.stateVal = event.target.getAttribute('data-addressstatebil');
        this.valueDrpdwn = event.target.getAttribute('data-addressstatebil');
        console.log('>>>' + event.target.getAttribute('data-addressstatebil'));
        console.log('this.valueDrpdwn billing' + this.valueDrpdwn);
        this.zipVal = event.target.getAttribute('data-addresspostalcodebil');
        this.cntryVal = event.target.getAttribute('data-addresscountrybil');
        this.cmpnameVal = event.target.getAttribute('data-cmnynamebil');
        this.emailVal = event.target.getAttribute('data-emailbil');
        this.phoneVal = event.target.getAttribute('data-phnbil');
        if (event.target.getAttribute('data-defaultaddressbil') === 'true') {
            console.log('this.isChecked' + this.isChecked);
            this.isChecked = true;
            this.ccAddressDefaulted = true;
            console.log('this.isChecked' + this.isChecked);
        } else if (event.target.getAttribute('data-defaultaddressbil') === 'false') {
            console.log('else part' + event.target.getAttribute('data-defaultaddressbil'));
            this.isChecked = false;
            this.ccAddressDefaulted = false;
            console.log('this.isChecked in else' + this.isChecked)
        }

        console.log('chekbox in manage address Biling' + event.target.getAttribute('data-addressline1bil'));
    }

    closeCCAddressPopup() {
        this.showEditFormCCAddress = false;
        this.showNewAddressForm = false;
    }

    handleDefaultAddress(event) {


        this.ccAddressDefaulted = event.target.checked;
        console.log('defaultChekbox' + this.ccAddressDefaulted);
        if (this.ccAddressDefaulted === true) {
            this.makeAddressDefault = true;
            console.log('entering here>>' + this.makeAddressDefault);

        }
    }

    handleCCAddressChange(event) {
        if (event.target.name == 'cmnyName') {
            this.cmpnameVal = event.target.value;
        } else if (event.target.name == 'addTypeName') {
            console.log('in if loop' + event.detail.value);
            this.addTypeVal = event.detail.value;
        } else if (event.target.name == 'fname') {
            this.firstnameVal = event.target.value;
        } else if (event.target.name == 'lname') {
            this.lastnameVal = event.target.value;
        } else if (event.target.name == 'add1name') {
            this.add1Val = event.target.value;
        } else if (event.target.name == 'add2name') {
            this.add2Val = event.target.value;
        } else if (event.target.name == 'cityname') {
            this.cityVal = event.target.value;
        } else if (event.target.name == 'statename') {
            this.stateVal = event.target.value;
        } else if (event.target.name == 'zipname') {
            this.zipVal = event.target.value;
        } else if (event.target.name == 'countryname') {
            this.cntryVal = event.target.value;
            console.log('cntryvalue after name change??' + this.cntryVal);
            if (event.target.value === storeUSA) {
                this.labelUS = true;
                this.valueDrpdwn = '';
                this.statePicklistValuArray = [];
                this.statesMtData.forEach(element => {
                    console.log('entering the for loop>>>' + element.dbu_Country_Code__c);
                    if (element.dbu_Country_Code__c == storeUSA) {
                        console.log('entering the for if loop>>>');
                        this.statePicklistValuArray.push({
                            label: element.dbu_State__c,
                            value: element.dbu_State_Code__c
                        });
                    }
                });
                this.statePicklistValuArray.sort((a, b) => (a.label > b.label) ? 1 : -1);
            }
            if (event.target.value === storeCanada) {
                this.labelUS = false;
                this.valueDrpdwn = '';
                this.statePicklistValuArray = [];
                this.statesMtData.forEach(element => {
                    console.log('entering the for loop>>>' + element.dbu_Country_Code__c);
                    if (element.dbu_Country_Code__c == storeCanada) {
                        console.log('entering the for if loop>>>');
                        this.statePicklistValuArray.push({
                            label: element.dbu_State__c,
                            value: element.dbu_State_Code__c
                        });
                    }
                });
                this.statePicklistValuArray.sort((a, b) => (a.label > b.label) ? 1 : -1);
            }
        }
        this.ccShiippingDetails = [{
            cmpnyName: this.cmpnameVal,
            addType: this.addTypeVal,
            fstnameData: this.firstnameVal,
            lstnameData: this.lastnameVal,
            emailData: this.emailVal,
            phnData: this.phoneVal,
            add1Data: this.add1Val,
            add2Data: this.add2Val,
            cityData: this.cityVal,
            stateData: this.stateVal,
            zipData: this.zipVal,
            cntryData: this.cntryVal
        }];
    }



    handleSave() {
        this.isLoading = true;
        if (this.firstnameVal != '' && this.lastnameVal != '' && this.add1Val != '' &&
            this.cityVal != '' && this.stateVal != '' && this.zipVal != '' &&
            this.cntryVal != '') {
            updateCCAddress({
                ccAddressID: this.ccAddId,
                companyName: this.cmpnameVal,
                addType: this.addTypeVal,
                fstCCName: this.firstnameVal,
                lstCCName: this.lastnameVal,
                emailCC: this.emailVal,
                phnCC: this.phoneVal,
                add1CC: this.add1Val,
                add2CC: this.add2Val,
                cityCC: this.cityVal,
                stateCC: this.stateVal,
                zipCC: this.zipVal,
                cntryCC: this.cntryVal,
                ccAddressDefaultedCC: this.ccAddressDefaulted
            })
            .then(result => {
                this.isLoading = false;
                console.log('updateCCAddress result=>' + result);
                    fetchCCAddressShippingAndBilling()
                            .then(resultFromApexSave => {
                                if (resultFromApexSave) {
                                    this.isLoading = false;
                                    console.log('data in cc shipping address in result1 handle save>>>' + JSON.stringify(resultFromApexSave[0].shippingWrapper));
                                    console.log('data in cc billing address in result1 handle save>>>' + JSON.stringify(resultFromApexSave[0].billingWrapper));
        
                                    this.ccAddressDataShippingBilling = resultFromApexSave;
                                    
                                    this.showEditFormCCAddress = false;
                                }
                            }).catch(error => {
                                this.error = error.message;
                                console.log('result from addressbook error  connectedCallback', JSON.stringify(this.error));
                            });
            }).catch(error => {
                this.isLoading = false;
                this.error = error.message;
                console.log('result from new address book method error ', JSON.stringify(this.error));

            });
        } else {
            this.isLoading = false;
            console.log('coming to the else part>>>')
            this.mandateFlag = true;
        }
    }

    handleNewAddressForm(event) {
        this.showNewAddressForm = true;
    }
    

    handleAddNewCCAddress(event) {
        if (event.target.name == 'cmnyNameNewAdd') {
            this.cmpnameValNewAdd = event.target.value;
        } else if (event.target.name == 'addTypeNameNewAdd') {
            this.addTypeValNewAdd = event.detail.value;
        } else if (event.target.name == 'fnameNewAdd') {
            this.firstnameValNewAdd = event.target.value;
        } else if (event.target.name == 'lnameNewAdd') {
            this.lastnameValNewAdd = event.target.value;
        } else if (event.target.name == 'add1nameNewAdd') {
            this.add1ValNewAdd = event.target.value;
        } else if (event.target.name == 'add2nameNewAdd') {
            this.add2ValNewAdd = event.target.value;
        } else if (event.target.name == 'citynameNewAdd') {
            this.cityValNewAdd = event.target.value;
        } else if (event.target.name == 'statenameNewAdd') {
            this.stateValNewAdd = event.target.value;
        } else if (event.target.name == 'zipnameNewAdd') {
            this.zipValNewAdd = event.target.value;
        } else if (event.target.name == 'countrynameNewAdd') {
            this.cntryValNewAdd = event.target.value;
            console.log('in handle cntryVal>>' + this.cntryVal);

            if (event.target.value === storeUSA) {
                this.labelUS = true;
                this.statePicklistValuArray = [];
                this.statesMtData.forEach(element => {
                    console.log('entering the for loop>>>' + element.dbu_Country_Code__c);
                    if (element.dbu_Country_Code__c == storeUSA) {
                        console.log('entering the for if loop>>>');
                        this.statePicklistValuArray.push({
                            label: element.dbu_State__c,
                            value: element.dbu_State_Code__c
                        });
                    }
                });
                this.statePicklistValuArray.sort((a, b) => (a.label > b.label) ? 1 : -1);

            }
            if (event.target.value === storeCanada) {
                this.labelUS = false;
                this.statePicklistValuArray = [];
                this.statesMtData.forEach(element => {
                    console.log('entering the for loop>>>' + element.dbu_Country_Code__c);
                    if (element.dbu_Country_Code__c == storeCanada) {
                        console.log('entering the for if loop>>>');
                        this.statePicklistValuArray.push({
                            label: element.dbu_State__c,
                            value: element.dbu_State_Code__c
                        });
                    }
                });
                this.statePicklistValuArray.sort((a, b) => (a.label > b.label) ? 1 : -1);
            }
        }

    }

    handleSaveNewAddress() {
        /**insert the cc address */
        this.isLoading = true;
        if (this.firstnameValNewAdd != '' && this.lastnameValNewAdd != '' && this.add1ValNewAdd != '' &&
            this.cityValNewAdd != '' && this.stateValNewAdd != '' && this.zipValNewAdd != '' &&
            this.cntryValNewAdd != '') {
            this.showNewAddressForm = false;
            console.log('contactId in handleSaveNewAddress' + this.contactId);

            console.log('stateValNewAdd ' + this.stateValNewAdd);
            console.log('ccAddressDefaulted' + this.ccAddressDefaulted);
            console.log('cmpnameValNewAdd' + this.cmpnameValNewAdd);
            this.newCCAddress = [{
                contactIdNew: this.contactId,
                cmnynameNew: this.cmpnameValNewAdd,
                addTypeNew: this.addTypeValNewAdd,
                firstnameNew: this.firstnameValNewAdd,
                lastnameNew: this.lastnameValNewAdd,
                add1New: this.add1ValNewAdd,
                add2New: this.add2ValNewAdd,
                cityNew: this.cityValNewAdd,
                stateNew: this.stateValNewAdd,
                zipNew: this.zipValNewAdd,
                cntryNew: this.cntryValNewAdd,
                defaultedAddressNew: this.ccAddressDefaulted
            }];


            addCCContactAddress({
                newCCAddress: JSON.stringify(this.newCCAddress)
            })           
                .then(result => {
                    this.isLoading = false;
                    console.log('updateCCAddress result=>' + result);
                        fetchCCAddressShippingAndBilling()
                                .then(resultFromApexSave => {
                                    if (resultFromApexSave) {
                                        this.isLoading = false;
                                        console.log('data in cc shipping address in result1 handle save>>>' + JSON.stringify(resultFromApexSave[0].shippingWrapper));
                                        console.log('data in cc billing address in result1 handle save>>>' + JSON.stringify(resultFromApexSave[0].billingWrapper));
            
                                        this.ccAddressDataShippingBilling = resultFromApexSave;
                                        
                                        this.showEditFormCCAddress = false;
                                    }
                
                                }).catch(error => {
                                    this.error = error.message;
                                    console.log('result from addressbook error  connectedCallback', JSON.stringify(this.error));
                                });
                }).catch(error => {
                    this.isLoading = false;
                    this.error = error.message;
                    console.log('result from new address book method error ', JSON.stringify(this.error));

                });
        } else {
            this.isLoading = false;
            this.mandateFlag = true;

        }
    }

    get options() {
        return [{
            label: 'Shipping',
            value: 'Shipping'
        },
        {
            label: 'Billing',
            value: 'Billing'
        },
        ];
    }

    deleteCCaddress(event) {
        console.log('sfid comming here on delete' + this.ccAddId);
        this.isLoading = true;
        this.showEditFormCCAddress = false;
        deleteContactAdd({
            ccDeleteID: this.ccAddId
        })
            .then(resultDelete => {
                console.log('updateCCAddress result=>' + JSON.stringify(resultDelete));
                this.isLoading = false;
                this.showEditFormCCAddress = false;
                this.ccAddressDataShippingBilling = resultDelete;
            }).catch(error => {
                this.error = error.message;
                console.log('result from addressbook error ', JSON.stringify(this.error));

            });
    }

}