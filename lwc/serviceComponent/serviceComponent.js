import serachAccs from '@salesforce/apex/dbu_GeolocationController.retriveAccs';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';//custom label refres to'CA'
import communityName from '@salesforce/label/c.dbu_communityName';
import getAddressAutoComplete from '@salesforce/apex/dbu_AddressSelectionCtrl.getAddressAutoComplete';
import getAddressDetailsFromPlaceId from '@salesforce/apex/dbu_AddressSelectionCtrl.getAddressDetailsFromPlaceId';


function perfixCurrencyISOCode(currencyISOCode, item) {
    var currencyUSD = {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
        style: 'currency',
        currency: 'USD'
    };

    if (item !== null && item !== undefined) {
        if (currencyISOCode === 'USD') {
            return item.toLocaleString('en-US', currencyUSD);
        } else if (currencyISOCode === 'CAD') {
            return currencyISOCode + ' ' + item.toLocaleString('en-US', currencyUSD);
        }
    } else {
        if (currencyISOCode === 'USD') {
            return 0.00.toLocaleString('en-US', currencyUSD);
        } else if (currencyISOCode === 'CAD') {
            return currencyISOCode + ' ' + 0.00.toLocaleString('en-US', currencyUSD);
        }

    }
}
function getQuantityList() {
    return [{
                label: '1',
                value: '1'
            },
            {
                label: '2',
                value: '2'
            },
            {
                label: '3',
                value: '3'
            },
            {
                label: '4',
                value: '4'
            },
            {
                label: '5',
                value: '5'
            },
            {
                label: '6',
                value: '6'
            },
            {
                label: '7',
                value: '7'
            },
            {
                label: '8',
                value: '8'
            },
            {
                label: '9+',
                value: '9+'
            },
        ];
}
// CECI 960 Start
function getCoreChargeList(lstProduct, corePrice) {
    console.log('indise getCoreCharList');
    console.log('lstProduct length', lstProduct.length);
    for(let i = 0; i < lstProduct.length; i++){
        console.log('in for loop')
        if (lstProduct[i].ccrz__E_PriceListItems__r != undefined) {
            var price = parseFloat(lstProduct[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c);
            if(lstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c != undefined 
                && lstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c != null
                && lstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c > 0) {
                    var originalprice = parseFloat(lstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c);
                }
        }
        let fnPrice;
        let fnOriginalPrice;
        if(lstProduct[i].dbu_Has_Core_Charge__c) {
            for(let b in corePrice) {
                if(lstProduct[i].Id == b) {
                    console.log('old Price',price);
                    console.log('old OriginalPrice',originalprice);
                    let coreCharge = parseFloat(corePrice[b]);
                    console.log('core Charge', coreCharge);
                    console.log(' price', lstProduct[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c);
                    if(lstProduct[i].ccrz__E_PriceListItems__r != undefined){
                        lstProduct[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c = price + coreCharge;
                        lstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c = originalprice + coreCharge;
                        fnPrice = lstProduct[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                        fnOriginalPrice = lstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                        lstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c = Math.round(((fnOriginalPrice - fnPrice)/fnOriginalPrice)*100);
                        console.log('discountPercentage in serviceComponent', lstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c);
                    }
                }
            }
        }
    }
    console.log('lstProduct1',JSON.parse(JSON.stringify(lstProduct)));
    return lstProduct;
}
function getCorePrice(lstProduct,corePrice){
    for(let b in corePrice){
        if(lstProduct1.Id == b){
            console.log('adding price');
            let coreCharge = parseFloat(corePrice[b]);
            console.log('core Charge', coreCharge);
            console.log(' price', lstProduct1[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c);
            if(lstProduct.ccrz__E_PriceListItems__r != undefined){
                lstProduct.ccrz__E_PriceListItems__r[0].ccrz__Price__c = price + coreCharge;
                lstProduct.ccrz__E_PriceListItems__r[0].ccrz__Price__c = originalprice + coreCharge;
            }
        }
    }
    return lstProduct;  
}
//CECI 960 End
const getPickUpOnlyStores = (strAccName, countryCode) => {
    return new Promise(resolve => {
        var latitude;
        var longitude;
        var accounts;
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    latitude = position.coords.latitude;
                    longitude = position.coords.longitude;
                    if (latitude != '' && latitude != 'undefined' &&
                        longitude != '' && longitude != 'undefined') {
                        serachAccs({
                            strAccName: strAccName,
                            lat: latitude,
                            lngtde: longitude
                        }).then(resultMap => {
                            if (resultMap) {
                                console.log('data in cc geo map>>>' + JSON.stringify(resultMap));
                                accounts = resultMap;

                                let accsRecords = displayMapData(strAccName,accounts,countryCode);
                                resolve(accsRecords);
                            }
                        }).catch(error => {
                            resolve(error);
                            console.log('result from addressbook error ', JSON.stringify(error));
                        });
                    }
                },
                    (error)=>{
                        serachAccs({
                            strAccName: strAccName,
                            lat: null,
                            lngtde: null
                        }).then(resultMap => {
                            if (resultMap) {
                                console.log('data in cc geo map in else >>>' + JSON.stringify(resultMap));
                                accounts = resultMap;

                                let accsRecords = displayMapData(strAccName,accounts,countryCode);
                                resolve(accsRecords);
                            }
                        }).catch(error => {
                            resolve(error);
                            console.log('result from addressbook error ', JSON.stringify(error));
                        });

                });
        }

    });
};

function displayMapData(strAccName,accounts,countryCode) {
    console.log('xxxxxxxxx' +accounts);
    let accountsToDisplay = [];
    let allAccountStringData = JSON.stringify(accounts);
    console.log('====allAccountStringData==' + allAccountStringData);
    let allAccountsData = JSON.parse(allAccountStringData);
    let accountArrayData = Array.from(allAccountsData);
    console.log('====Length===' + accountArrayData.length);
    for (let i = 0; i < accountArrayData.length; i++) {
        console.log('CountryCode=========' + countryCode);
        if (strAccName == '') {
            if (countryCode === storeUSA && accountArrayData[i].location.Country === 'U.S.A') {
                accountsToDisplay.push(accountArrayData[i]);
            } else if ((countryCode === storeCanada)
                && (accountArrayData[i].location.Country === storeCanada || accountArrayData[i].location.Country === 'Canada')) {
                accountsToDisplay.push(accountArrayData[i]);

            }
        } else {
            if (strAccName != null) {
                console.log('strAccName=========' + strAccName +'>>>>>>'+JSON.stringify(accountArrayData) +'>>>>>'+countryCode);
                console.log('storeUSA==='+storeUSA);
                console.log('accountArrayData[i].location.Country===='+accountArrayData[i].location.Country);
                console.log('accountArrayData[i].stateCode===='+accountArrayData[i].stateCode);

                if (countryCode === storeUSA && accountArrayData[i].location.Country === 'U.S.A'
                    ) {
                    accountsToDisplay.push(accountArrayData[i]);
                } else if ((countryCode === storeCanada)
                    && (accountArrayData[i].location.Country === storeCanada || accountArrayData[i].location.Country === 'Canada' )
                    ) {
                    accountsToDisplay.push(accountArrayData[i]);
                }
            }
        }

    }
    accountsToDisplay.sort((a, b) => (a.distance > b.distance) ? 1 : -1);
    return accountsToDisplay;
}

function validateCookiesData(OrderIds){

    let cookiesName = getCookiesData('temp-data');
    console.log('cookiesName Security ' , cookiesName);
    let tempVar = OrderIds;
            tempVar = tempVar.replace(OrderIds.slice(12,13),OrderIds.charCodeAt(12));
            tempVar = tempVar.replace(OrderIds.slice(13,14),OrderIds.charCodeAt(13));
            tempVar = tempVar.replace(OrderIds.slice(14,15),OrderIds.charCodeAt(14));
            tempVar = tempVar.replace(OrderIds.slice(1,2),OrderIds.charCodeAt(1));
    if(tempVar !== cookiesName){
        let baseURL = window.location.origin+communityName;
        let location = window.sessionStorage.getItem('setCountryCode');
        if(location === null || location === undefined){
            location= 'US';
        }
        window.location.href = baseURL + 'track-order?'+'&store=' + location;
         return true;
    }else{
        return false;
    }
}
function createCookiesData(orderId) {
    let tempVar = orderId;
    tempVar = tempVar.replace(orderId.slice(12,13),orderId.charCodeAt(12));
    tempVar = tempVar.replace(orderId.slice(13,14),orderId.charCodeAt(13));
    tempVar = tempVar.replace(orderId.slice(14,15),orderId.charCodeAt(14));
    tempVar = tempVar.replace(orderId.slice(1,2),orderId.charCodeAt(1));

    console.log('tempVar Security ' ,tempVar);
    createCartCookie('temp-data', tempVar, 1);
}
   
function getCookiesData(name){
    console.log('name ',name);
    var cookiesName;
    var name = name + "=";
    var ca = document.cookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
         c = c.substring(1);
        }
        if (c.indexOf(name) == 0) 
        {
            cookiesName = c.substring(name.length, c.length);
        }
    }

    console.log('cookiesName order ',cookiesName);
    return cookiesName;
}

function createCartCookie(name, value, days){
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

const getListOfAddresses = (searchKey, countryValToParse) => {
    return new Promise(resolve => {
        getAddressAutoComplete({
            input : searchKey,
            countryCode : countryValToParse
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
            resolve(addresses);
            //this.selectedAddress = undefined; 
            
        })
        .catch(error => {
            console.log(error);
        });
        
    })
}


const getSelectedAddress = (placeId, desc) => {
    return new Promise(resolve => {
        getAddressDetailsFromPlaceId({
            placeId : placeId,
            selectedAddress : desc
        })
        .then(result => {
            var placeResults = JSON.parse(result);
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
                        address1Value += ' '+component.long_name;
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
            let theAddress = [address1Value, zipValue, cityValue, stateValue, countryValue];
            resolve(theAddress);
        })
    })
}



export { perfixCurrencyISOCode, getPickUpOnlyStores, validateCookiesData,createCookiesData, getCoreChargeList, getCorePrice, getQuantityList, getListOfAddresses, getSelectedAddress};