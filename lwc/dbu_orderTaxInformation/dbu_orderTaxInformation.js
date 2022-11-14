import { LightningElement, api, track } from 'lwc';
import getOderTax from '@salesforce/apex/dbu_TaxSummaryCtrl.getOderTax';

import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada'; //custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French'; //custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';  //custom label refres to'CA'
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA'; //custom label refres to'USD'
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada'; //custom label refres to'CAD'
import dbu_Taxes_And_Fees_Pdf_Eng from '@salesforce/label/c.dbu_Taxes_And_Fees_Pdf_Eng';
import { perfixCurrencyISOCode } from 'c/serviceComponent';

export default class Dbu_orderTaxInformation extends LightningElement {

@api currentorderid;
@track taxsummary;
@track storeLanguage;
@track storeCountry;
@track countryCurrencyCode;
@track taxDataExist = false;
@track dbu_Taxes_And_Fees_Pdf_Eng = dbu_Taxes_And_Fees_Pdf_Eng;
connectedCallback(){

    this.storeLanguage = window.sessionStorage.getItem('setCountryCode');
    if(this.storeLanguage == storeUSA || 
        this.storeLanguage == undefined ||
        this.storeLanguage == null || this.storeLanguage == ''){
        this.storeCountry = storeUSA;
        this.countryCurrencyCode = currencyCodeUSA;
        this.storeLanguage = storeUSA;
    }else if(this.storeLanguage == storeCA || this.storeLanguage == storeCAF){
        this.storeCountry = storeCanada; 
        this.countryCurrencyCode = currencyCodeCanada;
    }

    console.log('this.storeCountry order tax information component callback > ' + this.storeCountry); 
    console.log('this.storeLanguage order tax information component callback  > ' + this.storeLanguage); 
    console.log('this.countryCurrencyCode order tax information component callback  > ' + this.countryCurrencyCode);    

    console.log('currentorderid in order tax information > ' + this.currentorderid);
    console.log('TaxDataExist > ' + this.taxDataExist);
    getOderTax({
        orderId : this.currentorderid
    }).then(result => {
        console.log('getordertax result > ' + result);
        if(result.length > 0){            
            this.taxDataExist = true;
            console.log('TaxDataExist inside> ' + this.taxDataExist);
            this.taxsummary = result;
            console.log('this.taxsummary before > ' + JSON.stringify(this.taxsummary));
            let counter = 0;
            //for(let i=0 ; i<this.taxsummary)
            this.taxsummary.forEach(element => {
                element['taxcounter'] = counter;
                counter = counter + 1;
                
                element['formattedcalculatedTax'] = perfixCurrencyISOCode(element.countryCurrency ,element.calculatedTax); 
                
            });
            console.log('this.taxsummary after > ' + JSON.stringify(this.taxsummary));
        }

    }).catch(error => {
        this.error = error.message;
        console.log('getordertax this.error > ' + this.error);
    });

}

}