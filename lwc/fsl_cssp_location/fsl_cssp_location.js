import {
    LightningElement,
    track,
    wire
} from 'lwc';
import getlocations from '@salesforce/apex/FSL_CSSP_getServiceLocations.getalllocations';
import getcurrentaddress from '@salesforce/apex/FSL_CSSP_getServiceLocations.getcurrentaddress';
import getAssetsRecord from '@salesforce/apex/FSL_CSSP_equipmentController.getAssetsRecord';
import getLocPointes from '@salesforce/apex/FSL_CSSP_getServiceLocations.getLocPointes';
import updateCaseId from '@salesforce/apex/FSL_CSSP_getServiceLocations.updateServiceReq';
import getallContactsAddress from '@salesforce/apex/FSL_CSSP_getServiceLocations.getallContacts';
import Id from "@salesforce/user/Id";
import getUserDetails from "@salesforce/apex/FSL_CSSP_equipmentController.currentuser";
import googleAPI from '@salesforce/apex/FSL_CSSP_googleAddressAutofill.getAddressSet';
import PlaceIdGoogleAPI from '@salesforce/apex/FSL_CSSP_googleAddressAutofill.getAddressDetailsByPlaceId';
import selectAServiceLocLabel from '@salesforce/label/c.FSL_Select_a_Service_Location';
//import proceedLabel from '@salesforce/label/c.FSL_Proceed';
import cancelLabel from '@salesforce/label/c.FSL_Close_Chevron_Cancel';
import searchLabel from '@salesforce/label/c.CSS_Search';
import locationInfo from '@salesforce/label/c.FSL_CSSP_Please_Enter_Cit_Name';// Added for Story#CT4-752
import locationLabel from '@salesforce/label/c.css_Location';// Added for Story#CT4-752
import distanceLabel from '@salesforce/label/c.FSL_CSSP_Distance';// Added for Story#CT4-752
import phoneNumberLabel from '@salesforce/label/c.CSS_Phone_Number';// Added for Story#CT4-752
import proceedLabel from '@salesforce/label/c.FSL_Proceed';// Added for Story#CT4-752
import locationErrorMessage from '@salesforce/label/c.FSL_CSSP_LocationErrorMessage';// Added for Story#CT4-752
import confirmationLabel from '@salesforce/label/c.FSL_CSSP_Confirmation';// Added for Story#CT4-752
import cancelMessageLabel from '@salesforce/label/c.FSL_CSSP_Cancel_Message';// Added for Story#CT4-752
import yesLabel from '@salesforce/label/c.css_Yes';// Added for Story#CT4-752
import noLabel from '@salesforce/label/c.CSS_No';// Added for Story#CT4-752

export default class Fsl_cssp_location extends LightningElement {
    label = {
        selectAServiceLocLabel,
        searchLabel,
        locationInfo,// Added for Story#CT4-752
        locationLabel,// Added for Story#CT4-752
        distanceLabel,// Added for Story#CT4-752
        phoneNumberLabel,// Added for Story#CT4-752
        proceedLabel,// Added for Story#CT4-752
        yesLabel,// Added for Story#CT4-752
        noLabel,// Added for Story#CT4-752
        cancelLabel
    };
    @track storeLocationsToDisplay;
    @track storeLocationsToDisplay1;
    @track showFooter = true;
    @track userinput = '';
    //@track userinput;
    @track userinputsearch;
    @track value = 'Recent Address';

    @track visible = false; //used to hide/show dialog
    @track confirmLabel; //confirm button label
    @track cancelLabel; //cancel button label
    @track messagevalue;
    @track titlemessage;

    selectedAccId = ''; //added on 06-14-2021
    //getting contactId
    /*userId = Id;
    //  @track user;
      @track error;
      @track ConId ;

      @wire(getUserDetails, {
          loggedInUserId: "$userId"
      })

      wiredUser({ error, data }) {
          if (data) {
              let userData = data;
             // this.fname = this.user[0].FirstName;

              let contactsID = userData[0].ContactId;
              this.ConId = contactsID;
              //let ContactAddress = this.user[0].Contact.MailingStreet;
             alert('this.ConId >>'+this.ConId);
             // sessionStorage.setItem('ContactId', '0034C00000OpWEWQA3');

          } else if (error) {
              this.error = error;
          }
      }*/
    //
    get recentAddress() {
        return [{
            label: 'Recent Address',
            value: 'Recent Address'
        }, ];
    }
    get enterFieldLoc() {
        return [{
            label: 'Enter Field Location',
            value: 'Enter Field Location'
        }, ];
    }
    get searchcummLoc() {
        return [{
            label: 'Search for Cummins Location',
            value: 'Search for Cummins Location'
        }];
    }
    handleFieldsearch(event) {
        this.userinputsearch = event.target.value;
        console.log('user text' + this.userinputsearch)
        if (this.userinputsearch.includes(',')) {
            this.updatestring = this.userinputsearch.replace(',', '%2C')
            console.log('final user input ' + this.updatestring)
            this.userinputsearch = this.updatestring;
        }
        this.xhr = new XMLHttpRequest();
        var access = 'pk.fd6cb9a3ba027394a5cb293681cc3182';
        //https://api.locationiq.com/v1/autocomplete.php?key=pk.58184c718364becbfac62b997c4d2757&q=&limit=5
        // this.xhr.open('GET', "https://us1.locationiq.com/v1/search.php?key=" + access + '&q=' + this.userinput + '&format=json');
        this.xhr.open('GET', "https://us1.locationiq.com/v1/search.php?key=" + access + '&q=' + this.userinputsearch + '&format=json');
        this.xhr.send();
        this.xhr.onreadystatechange = () => {
            if (this.xhr.readyState === 4 && this.xhr.status === 200) {
                let response = JSON.parse(this.xhr.responseText);
                console.log('response<><>' + JSON.stringify(response));
                //this.storeLocationsToDisplay1 = response[0].display_name;
                // this.storeLocationsToDisplay1 = response;
                let lat = response[0].lat;
                let lan = response[0].lon;
                // console.log('storeLocationsToDisplay1' + this.storeLocationsToDisplay1);
                this.getLocation(lat, lan);
                /* getcurrentaddress({
                     latitude: lat,
                     longitude: lan,


                 }).then(result => {
                     console.log('result' + JSON.stringify(result))
                     this.storeLocationsToDisplay = result;
                 }).catch(error => {
                     this.isLoading = false;
                     this.error = error;
                     console.log('error=>>Addressval' + JSON.stringify(this.error));
                 });*/
            }

        }

    }
    zoomLevel = 15;
    @track responsearry = [];
    getLocation(latt, lont) {
        console.log('lattitude ' + latt);
        console.log('lontitude ' + lont);
        this.xhr = new XMLHttpRequest();
        var access = 'pk.fd6cb9a3ba027394a5cb293681cc3182';
        //https://us1.locationiq.com/v1/reverse.php?key=pk.fd6cb9a3ba027394a5cb293681cc3182'&lat=&lon=&format=json
        // https://maps.googleapis.com/maps/api/geocode/json?latlng=44.4647452,7.3553838&key=YOUR_API_KEY
        // this.xhr.open('GET', "maps.googleapis.com/maps/api/geocode/json?latlng=44.4647452,7.3553838key=" + access + '&lat=' + latt + '&lon=' + lont + '&format=json');
        this.xhr.open('GET', "https://us1.locationiq.com/v1/reverse.php?key=" + access + '&lat=' + latt + '&lon=' + lont + '&format=json');
        this.xhr.send();
        this.xhr.onreadystatechange = () => {
            if (this.xhr.readyState === 4 && this.xhr.status === 200) {
                //alert('this.xhr.status'+this.xhr.status);
                var finalData = JSON.parse(this.xhr.responseText);
                let address = finalData.address;

                //console.log('finalData<><>'+finalData[0].display_name);
                console.log(JSON.stringify(finalData));
                //console.log('finalData<><>'+finalData.address);
                var cla = JSON.stringify(finalData);
                console.log('cla' + cla);
                //var address = cla.address;
                console.log('address<>' + address);
                console.log('displayname<>' + finalData.display_name);
                console.log('address.postcode<>' + address.postcode);
                var cityloc;
                if (address.city != null)
                    cityloc = address.city;
                else
                    cityloc = address.town;
                let lstArray = [];
                lstArray.push(cityloc);
                lstArray.push(address.neighbourhood);
                lstArray.push(address.state);
                lstArray.push(address.country);
                lstArray.push(address.postcode);
                // this.responsearry = lstArray;
                //alert('this.responsearrynonsave<><>'+this.responsearry);
                getLocPointes({
                    //responselst: cla
                    postalCode: address.postcode,
                    City: cityloc,
                    Country: address.country,
                    road: address.neighbourhood,
                    state: address.state,
                    description: finalData.display_name
                    //postalCode:address.postcode,
                    // postalCode:address.postcode,

                }).then(result => {
                    console.log('result' + JSON.stringify(result))
                    this.storeLocationsToDisplay1 = result;
                    this.value = 'Enter Field Location';

                }).catch(error => {
                    //this.isLoading = false;
                    this.error = error;
                    console.log('error=>>Addressval' + JSON.stringify(this.error));
                });
                /* var state = address.state;
                 var PostalCode = address.postcode;
                 var City = address.town;
                 var Country = address.country;
                 var road = address.neighbourhood;
                 console.log('Country<>'+Country);
                 var arrayList=[];
                 arrayList.push(address.neighbourhood);
                 arrayList.push(address.town);
                 //this.arrayList.push('action:map');
                 //ocDetail.icon = 'action:map';
                 arrayList.push(address.state);
                 arrayList.push(address.postcode);
                 arrayList.push(address.country);
                 arrayList.push(address.country_code);
                 //arrayList.push(finalData.lat);
                 //arrayList.push(finalData.lon);
                 console.log('arrayList<>'+arrayList);
                 this.storeLocationsToDisplay1 = arrayList;
                 console.log('this.storeLocationsToDisplay1<>'+this.storeLocationsToDisplay1);*/
            }

        }
    }
    @track recentAdd = true;
    @track enterFielddata;
    @track enterFielddata;
    /* handleChange(event) {
         this.selectedValue = event.detail.value;
        // alert('selectedValue '+this.selectedValue);
         if (this.selectedValue === 'Recent Address') {
             //value = 'Recent Address';
             this.recentAdd = true;
             this.enterFielddata = false;
             this.searchCumminsLoc = false;
             this.value = 'Recent Address';
             console.log('this.selectedValue' + this.selectedValue);
             console.log('this.recentAdd' + this.recentAdd);
             console.log('this.searchCumminsLoc' + this.searchCumminsLoc);
             console.log('this.enterFielddata' + this.enterFielddata);
             //this.serviceData = 'hello data';

         }
         if (this.selectedValue === 'Enter Field Location') {


             this.recentAdd = false;
             this.enterFielddata = true;
             this.searchCumminsLoc = false;
             this.value = 'Enter Field Location';
             console.log('this.selectedValue' + this.selectedValue);
             console.log('this.recentAdd' + this.recentAdd);
             console.log('this.searchCumminsLoc' + this.searchCumminsLoc);
             console.log('this.enterFielddata' + this.enterFielddata);
             //alert('I am in else');
         }
         if (this.selectedValue === 'Search for Cummins Location') {



             this.recentAdd = false;
             this.enterFielddata = false;
             this.searchCumminsLoc = true;
             this.value = 'Search for Cummins Location';
             console.log('value' + value);
             console.log('this.selectedValue' + this.selectedValue);
             console.log('this.recentAdd' + this.recentAdd);
             console.log('this.searchCumminsLoc' + this.searchCumminsLoc);
             console.log('this.enterFielddata' + this.enterFielddata);

         }
     }*/
    @track assetrecId;
    @track conID;
    connectedCallback() {

        let basrurl = window.location.search;
        //c/csp_headerStepsconst queryString = window.location.search;
        let urlParams = new URLSearchParams(basrurl);
        this.serviceTerritoryID = urlParams.get("accId");
        if (this.serviceTerritoryID != null) {
            this.errorMessage = false;
        }
        //alert(this.serviceTerritoryID);
        // this.conID = sessionStorage.getItem("ContactId");
        // alert('connectedthis.conID<><>' + this.conID);


    }
    @track City;
    @track Country;
    @track PostalCode;
    @track State;
    @track Street;
    @track phone;
    @track conData;

    // @wire(getallContactsAddress, { ConId: '0034C00000OpWEWQA3'})
    /* @wire(getallContactsAddress, { ConId: '$conID'})   
     conRecord({ data, error }) {
        // alert('wireconrec');
         if (data) {
             console.log('dta' + JSON.stringify(data));
             this.conData = data;
             let state = data;

             let address = state[0].location;

             this.City = address.City;
             this.Country = address.Country;
             this.PostalCode = address.PostalCode;
             this.State = address.State;
             this.Street = address.Street;
            // this.phone = state[0].PostalCode;

             console.log('address.postcode<>' + address.PostalCode);


        }
         else if (error) {
             console.log('error' + error);

         }
     }*/
    /* @track assetRecordInfo;
     @track astId;
     @wire(getAssetsRecord, { asstID: '$assetrecId'})
     AssetsRecord({ data, error }) {

         if (data) {
             // console.log('dta' + JSON.stringify(data));
             this.assetRecordInfo = data;
             this.astId = assetRecordInfo.Id;
         }
         else if (error) {
             console.log('error' + error);

         }
     }*/
    @wire(getlocations)
    wiredAccountss({
        error,
        data
    }) {

        if (data) {
            const queryString = window.location.search;
            const urlParams = new URLSearchParams(queryString);


            if (urlParams.has("accId")) {
                var resultdata = [];

                console.log(this.serviceTerritoryID + '----' + data.length);
                for (var i = 0; i < data.length; i++) {
                    if (data[i].Id == this.serviceTerritoryID) {
                        var Newdata = Object.assign({}, data[i]);
                        Newdata.isLocationMatched = true;

                        resultdata.push(Newdata);
                    } else {
                        resultdata.push(data[i]);
                    }
                }
                console.log('final result----- ' + JSON.stringify(resultdata));
                this.storeLocationsToDisplay = resultdata;
            } else {
                this.storeLocationsToDisplay = data;
            }
            this.errorMessage = false;

        } else if (error) {
            console.log(error);
            this.error = error;
        }

    }
    handlechange(event) {
        this.userinput = event.target.value;
        console.log('user text' + this.userinput)
        if (this.userinput.includes(',')) {
            this.updatestring = this.userinput.replace(',', '%2C')
            console.log('final user input ' + this.updatestring)
            this.userinput = this.updatestring;
        }
    }
    @track lstArray = [];
    @track serviceTerritoryID;
    storeLocationSelected(event) {
        // alert(event.target.checked);
        this.serviceTerritoryID = event.target.getAttribute('data-accid');




        if (this.serviceTerritoryID == null) {
            this.serviceTerritoryID = event.target.getAttribute('data-accid1');
            console.log('this.serviceTerritoryID' + this.serviceTerritoryID);

        }
        // this.selectedAccId = event.target.getAttribute('data-accid'); //added on 06-14-2021
        console.log('this.selectedAccId=====' + this.serviceTerritoryID);

        sessionStorage.setItem('serviceTerritoryID', this.serviceTerritoryID);
        // console.log('this.serviceTerritoryID====='+serviceTerritoryID);
        //  console.log('this.serviceTerritoryID====='+this.selectedAccId);
        let city = event.target.getAttribute('data-acccity');
        let street = event.target.getAttribute('data-accstreet');
        let state = event.target.getAttribute('data-accstate');
        let country = event.target.getAttribute('data-acccountry');
        let zipcode = event.target.getAttribute('data-acczipcode');
        var lstArray = [];
        lstArray.push(city);
        lstArray.push(street);
        lstArray.push(state);
        lstArray.push(country);
        lstArray.push(zipcode);
        this.lstArray = lstArray;
        sessionStorage.setItem('locAddress', this.lstArray);

        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        if (urlParams.has("accId") && this.serviceTerritoryID != null) {
            var resultdata = [];
            for (var i = 0; i < this.storeLocationsToDisplay; i++) {

                if (storeLocationsToDisplay[i].Id == this.serviceTerritoryID) {
                    var Newdata = Object.assign({}, storeLocationsToDisplay[i]);
                    Newdata.isLocationMatched = true;
                    resultdata.push(Newdata);
                } else {
                    var Newdata1 = Object.assign({}, storeLocationsToDisplay[i]);
                    Newdata1.isLocationMatched = false;
                    resultdata.push(Newdata1);
                }

            }
            system.debug('=======resultdata======' + resultdata);
            this.storeLocationsToDisplay = resultdata;
        }
    }
    @track errorMessage;
    updateServiceReq() {
        let caseIdValue = sessionStorage.getItem('CaseId');
        // alert('this.lstArray<>' + this.lstArray);
        if (this.lstArray != '') {

            updateCaseId({
                //responselst: cla
                caseId: caseIdValue,
                // RecordTypeIdCase:'0124N000000kygzQAA',
                locValues: this.lstArray
            })

            this.redirectTocontact();
        }
        if (this.serviceTerritoryID != null) {
            this.redirectTocontact();
        } else {
            // this.errorMessage = true;locationErrorMessage
            //alert('Please select the Location and click on proceed button');
            alert(locationErrorMessage);
        }
    }
    updateFieldServiceReq() {
        let caseIdValue = sessionStorage.getItem('CaseId');
        // alert('this.responsearrysave'+this.responsearry);
        if (this.responsearry != '') {
            updateCaseId({
                //responselst: cla
                caseId: caseIdValue,
                // RecordTypeIdCase:'0124N000000kygzQAA',
                locValues: this.responsearry
            })
            this.redirectTocontact();
        } else {
            alert('Please select Location and click on proceed button');
        }

    }
    redirectTocontact() {
        this.errorMessage = false;
        let urlstring = window.location.origin;
        //window.location.href = urlstring + '/cssp' + '/s/contact?' + 'AssetId=' + this.assetrecId;
        //window.location.href = urlstring + "/" + "cssp" + "/s/" + "servicetab";//comment on 07-12-2021
        //commented above line and added below line with parameter on 06-14-2021

        window.location.href = urlstring + "/" + "cssp" + "/s/" + "servicetab?accId=" + this.serviceTerritoryID;

    }

    /* Cancel Button Logic*/
    docancel() {
        this.titlemessage = confirmationLabel;
        this.messagevalue = cancelMessageLabel;
       // this.titlemessage = 'Confirmation';
       // this.messagevalue = 'Data will not be saved, do you wish to continue?';
        this.visible = true;

    }

    ConfirmClick() {
        this.visible = false;
        let urlString = window.location.origin;
        var finalURL = urlString + "/" + "cssp" + "/s/new-service-request";
        window.location.assign(finalURL);
        // #CT4_719 Cancel Button Story related changes Start
        sessionStorage.clear();
        // #CT4_719 Cancel Button Story related changes End
    }

    CanceClick() {
        this.visible = false;
    }
    /* Cancel Button Logic end*/

    handleclik(event) {
        this.xhr = new XMLHttpRequest();
        var access = 'pk.fd6cb9a3ba027394a5cb293681cc3182';
        this.xhr.open('GET', "https://us1.locationiq.com/v1/search.php?key=" + access + '&q=' + this.userinput + '&format=json');
        this.xhr.send();
        this.xhr.onreadystatechange = () => {
            if (this.xhr.readyState === 4 && this.xhr.status === 200) {
                let response = JSON.parse(this.xhr.responseText);
                console.log('???' + JSON.stringify(response));
                let lat = response[0].lat;
                let lan = response[0].lon;
                console.log('lat' + lat + 'lan' + lan);
                getcurrentaddress({
                    latitude: lat,
                    longitude: lan,


                }).then(result => {
                    console.log('result' + JSON.stringify(result))
                    this.storeLocationsToDisplay = result;
                    this.value = 'Search for Cummins Location';
                    console.log('this.storeLocationsToDisplay>>' + this.storeLocationsToDisplay);
                }).catch(error => {
                    this.isLoading = false;
                    this.error = error;
                    console.log('error=>>Addressval' + JSON.stringify(this.error));
                });
            }

        }

    }


    /* @track storeLocationsToDisplay;
    https://us1.locationiq.com/v1/reverse.php?key=pk.fd6cb9a3ba027394a5cb293681cc3182&lat=40.751688&lon=-79.166505&format=json
     https://us1.locationiq.com/v1/search.php?key=pk.fd6cb9a3ba027394a5cb293681cc3182&q=cummins%20office%2Ccoloumbus%2CIndiana&format=json
     @track error;
     @track showFooter = true ;
     @wire(getlocations)
     wiredAccountss({error,data}) {
         if (data) {
             this.storeLocationsToDisplay = data;
             console.log(data);
             console.log(JSON.stringify(data, null, '\t'));
         } else if (error) {
             console.log(error);
             this.error = error;
         }
     }*/
    @track fieldSerachData;
    handleFieldsearch(event) {
        this.userinputsearch = event.target.value;
        console.log('user text' + this.userinputsearch)
        /*if (this.userinputsearch.includes(',')) {
            this.updatestring = this.userinputsearch.replace(',', '%2C')
            console.log('final user input ' + this.updatestring)
            this.userinputsearch = this.updatestring;
        }*/
        googleAPI({
            SearchText: this.userinputsearch
        }).then(result => {
            // console.log('resultResponse' + JSON.stringify(result))
            var response = JSON.parse(result);

            //console.log('response<>' + response)
            var predictions = response.predictions;
            //console.log('predictions<>' + predictions)
            var addresses = [];
            if (predictions.length > 0) {
                for (var i = 0; i < predictions.length; i++) {
                    var bc = [];
                    addresses.push({
                        main_text: predictions[i].structured_formatting.main_text,
                        secondary_text: predictions[i].structured_formatting.secondary_text,
                        place_id: predictions[i].place_id
                    });

                }
            }
            for (var i = 0; i < addresses.length; i++) {
                console.log('maintext' + addresses[i].main_text);
                console.log('secon' + addresses[i].secondary_text);
                console.log('placeid' + addresses[i].place_id);
            }
            this.fieldSerachData = addresses;

            // console.log('this.storeLocationsToDisplay>>' + this.storeLocationsToDisplay);
        }).catch(error => {

            this.error = error;
            console.log('error=>>Addressval' + JSON.stringify(this.error));
        });


    }
    @track mapMarkers;
    onItemSelected(event) {
        // let city = event.target.getAttribute('data-item');
        // console.log('city<>'+city);
        // console.log('<>'+event.target.name)
        //alert('hi');
        // let tempPlaceId=event.currentTarget.dataset.id
        // console.log('onItemSelected:::'+temp);   
        let tempCopy = event.currentTarget.getAttribute("data-id");
        console.log('onItemSelected:::' + tempCopy);
        PlaceIdGoogleAPI({
            PlaceID: tempCopy
        }).then(result => {
            var response = JSON.parse(result);
            var postalCode = '',
                state = '',
                country = '',
                city = '',
                street = '',
                street_number = '',
                route = '',
                subLocal1 = '',
                subLocal2 = '';
            for (var i = 0; i < response.result.address_components.length; i++) {
                var FieldLabel = response.result.address_components[i].types[0];
                //console.log(FieldLabel);
                //debugger;
                if (FieldLabel == 'sublocality_level_2' || FieldLabel == 'sublocality_level_1' || FieldLabel == 'street_number' || FieldLabel == 'route' || FieldLabel == 'locality' || FieldLabel == 'country' || FieldLabel == 'postal_code' || FieldLabel == 'administrative_area_level_1') {
                    switch (FieldLabel) {
                        case 'sublocality_level_2':
                            subLocal2 = response.result.address_components[i].long_name;
                            break;
                        case 'sublocality_level_1':
                            subLocal1 = response.result.address_components[i].long_name;
                            break;
                        case 'street_number':
                            street_number = response.result.address_components[i].long_name;
                            break;
                        case 'route':
                            route = response.result.address_components[i].short_name;
                            break;
                        case 'postal_code':
                            postalCode = response.result.address_components[i].long_name;
                            break;
                        case 'administrative_area_level_1':
                            state = response.result.address_components[i].short_name;
                            break;
                        case 'country':
                            country = response.result.address_components[i].long_name;
                            break;
                        case 'locality':
                            city = response.result.address_components[i].long_name;
                            break;
                        default:
                            break;
                    }
                }
            }
            street = street_number + ' ' + route;
            if (street == null) {
                street = subLocal2 + ' ' + subLocal1;
            }
            let lstArray = [];
            lstArray.push(city);
            lstArray.push(street);
            lstArray.push(state);
            lstArray.push(country);
            lstArray.push(postalCode);
            this.responsearry = lstArray;
            this.mapMarkers = [{
                location: {
                    City: city,
                    Street: street,
                    State: state,
                    Country: country,
                    PostalCode: postalCode,


                },
                title: street,
                /*mapIcon : {
                    path: 'M 125,5 155,90 245,90 175,145 200,230 125,180 50,230 75,145 5,90 95,90 z',
                    fillColor: '#CF3476',
                    fillOpacity: .5,
                    strokeWeight: 1,
                    scale: .10,
                }*/
            }];
            this.fieldSerachData = '';
            console.log('street<>' + street + ' ' + postalCode + ' ' + state + ' ' + country + ' ' + city + ' ' + subLocal2 + ' ' + subLocal1 + '' + street_number + '' + route);
        }).catch(error => {

            this.error = error;
            console.log('error=>>Addressval' + JSON.stringify(this.error));
        });
    }
    /*docancel(){
       this.userinput = '';
       const gsearchaddress = this.template.querySelector('.gsearchaddress');
       gsearchaddress.innerHTML="unchecked";

      // gsearchaddress.innerHTML = 'unchecked';

    }*/
}