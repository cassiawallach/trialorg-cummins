import { LightningElement,wire,api, track } from 'lwc';
import drupleContent from '@salesforce/apex/dbu_Integration_Druple.getDrupleContent';

import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada';
import dbu_home_store_U_S_A from '@salesforce/label/c.dbu_home_store_U_S_A';
import dbu_home_store_Canada_CA from '@salesforce/label/c.dbu_home_store_Canada_CA';
import dbu_home_store_Canada from '@salesforce/label/c.dbu_home_store_Canada';
import dbu_home_store_Canada_French from '@salesforce/label/c.dbu_home_store_Canada_French';

export default class Dbu_druple extends LightningElement 
{
    @api contentId;
    @track content;
    @track title;
    @track contId;
    @track storeLocation;
    @track drupalContentName;
     
    @track storeCountry;
    @track locationstore;

    @track storeUSA = dbu_home_store_U_S_A;
    @track storeCanada = dbu_home_store_Canada_CA;
    @track storeen = dbu_home_store_Canada;
    @track storefr = dbu_home_store_Canada_French;
    @track countryCurrencyCode;


    connectedCallback()
    {
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);

        this.drupalContentName = locationURL.split('/s/').pop().split('?store')[0];
        console.log('this.drupalContentName+++ ' + this.drupalContentName); 
       
        this.storeLocation = url.searchParams.get("store");
        
        //this.storeLocation = window.sessionStorage.getItem('setCountryCode'); //urlParams.get('store');
        console.log('this.storeLocation+++ ' + this.storeLocation); 
        
        if(this.storeLocation === null)
        {
            this.storeLocation = this.storeUSA;
            console.log('INside  NUll +++ ' + this.storeLocation); 
        }
        if(this.storeLocation === undefined || this.storeLocation === null || 
            this.storeLocation === '' || this.storeLocation  === this.storeUSA)
        {
            console.log('Inside US');
            if(this.drupalContentName == 'termsandconditions')
            {
                console.log('termsandconditions For US');
                this.contentId = '39716';//'39741';//warrenty COntent Id
                console.log('termsandconditions US content id+++ '+this.contentId);
            }  
        } 
         
        else if(this.storeLocation  == this.storeCanada || this.storeLocation  == this.storeen || this.storeLocation  == this.storefr)
        {
            console.log('Inside CA'); 
            if(this.drupalContentName == 'termsandconditions')
            {
                console.log('termsandconditions For CA');  
                this.contentId = '39706';//'39741';//warrenty COntent Id
                console.log('termsandconditions CA content id+++ '+this.contentId);
            }  
        }
        /*
       this.storeCountry = window.sessionStorage.getItem('setCountryCode'); //urlParams.get('store');
       console.log('this.storeCountry=>' + this.storeCountry);
       this.locationstore = this.storeCountry;
       console.log('this.locationstore=>' + this.locationstore);
       
       if(this.locationstore == null || this.locationstore == this.storeUSA){
           this.locationstore = this.storeUSA;
           this.countryCurrencyCode = currencyCodeUSA;  
       }else if(this.locationstore == this.storeen){
           this.locationstore = this.storeCanada;
           //this.currentLanguage = 'EN';
           this.countryCurrencyCode = currencyCodeCanada;
       }else if(this.locationstore == this.storefr){
           this.locationstore = this.storeCanada;
           //this.currentLanguage = 'FR';
           this.countryCurrencyCode = currencyCodeCanada;
       }
       */

        this.getdrupleResponse();
    }

    getdrupleResponse()
    {
        drupleContent({
                    data: this.contentId 
        })
            .then(data => 
            {
                console.log('druple content id'+this.contentId);
                console.log('druple content'+JSON.stringify(data));
                this.title = data[0].title ;
                this.content = data[0].body ;
                console.log(' content'+JSON.stringify(this.content));
                this.error = undefined;
                //document.getElementById("drpleid").innerHTML = document.getElementById(record).innerHTML;
                let titleinfo = this.template.querySelector('h1');
                let container = this.template.querySelector('.staticContent');
                titleinfo.innerHTML = this.title ;
                container.innerHTML = this.content ;
                this.contacts = data;
            })
            .catch(error => 
            {
                this.error = error;
            });
    }

    /*
    @wire(drupleContent,{data:'$contentId'})
    DrupleResponse({ error, data }) 
    {
        if (data) 
        {
            console.log('druple content id'+this.contentId);
            console.log('druple content'+JSON.stringify(data));
            this.title = data[0].title ;
            this.content = data[0].body ;
            console.log(' content'+JSON.stringify(this.content));
            this.error = undefined;
            //document.getElementById("drpleid").innerHTML = document.getElementById(record).innerHTML;
            let titleinfo = this.template.querySelector('h1');
            let container = this.template.querySelector('.staticContent');
            titleinfo.innerHTML = this.title ;
            container.innerHTML = this.content ;
        } 
        else if(error) 
        {
            this.error = error;
            this.record = undefined;
            console.log('this.error+++ ' + this.error);
            this.isModalOpen = true;
            console.log('this.isModalOpen = true');
        }
    }
    */
    closeModal() 
    {
        // to close modal window set 'isModalOpen' tarck value as false
        this.isModalOpen = false;   
    }
}