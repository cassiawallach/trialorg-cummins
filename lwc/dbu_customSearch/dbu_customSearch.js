import {
    LightningElement,
    track,
    api,
    wire
} from 'lwc';
import {
    NavigationMixin
} from 'lightning/navigation';

import pubsub from 'c/pubsub' ;

import getAllProducts from '@salesforce/apex/dbu_ProductCtrl.getAllProducts';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

import searchicon from '@salesforce/resourceUrl/HeaderSearchIcon';

import getAccount from "@salesforce/apex/dbu_GeolocationController.retriveAccs";
import communityName from '@salesforce/label/c.dbu_communityName';
import dbu_Recent_search from '@salesforce/label/c.dbu_Recent_search';
import dbu_SearchPlaceHolder from '@salesforce/label/c.dbu_SearchPlaceHolder';
import dbu_SearchPlaceHolderMobile from '@salesforce/label/c.dbu_SearchPlaceHolderMobile';

export default class dbu_customSearch extends NavigationMixin(LightningElement) {

    iconsearch = searchicon + '#searchIcon';
    //@track: Marks a property for internal monitoring. A template or function using- 
    //this property forces a component to rerender when the property’s value changes.
    @track products;
    @track product1;
    @track location = [];
    @track allProductsData=[];
    @api latFieldApiName;
    @api longFieldApiName;
    @track parts;
    @track error;
    @track delayTimeout;
    @track sfid;
    @track recentlySearched=[];
    @track firstsearchval;
    @track secondsearchval;
    @track thirdfirstsearchval;
    @track predictiveSearchDropDown=false;
    @track locationstore = 'US';

    //custom labelvariables
    @track Recentsearchtxt ;
    @track SearchPlaceHoldertxt;
    @track SearchPlaceHoldertxtMobile;
    offset = 0;
    
  //  const DELAY = 350;
     data=[];

    sVal = '';

    connectedCallback() {
        this.getCookiesData('searchtextdata');
        let locationURL = window.location.href;

        this.Recentsearchtxt= dbu_Recent_search;
        this.SearchPlaceHoldertxt=dbu_SearchPlaceHolder;
        this.SearchPlaceHoldertxtMobile=dbu_SearchPlaceHolderMobile;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        this.locationstore = url.searchParams.get("store");
        
        if(this.locationstore == undefined){
            this.locationstore = 'US';
            console.log('Inside locationStore undefined======='+this.locationstore);
        }
        this.register();
        //console.log('this.getCookiesData'+JSON.stringify(this.getCookiesData))
        if (navigator.geolocation) {
            console.log('entering the geolocationmethod>>>')
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    this.location.latitude = position.coords.latitude;
                    console.log('this.location.latitude' + position.coords.latitude);
                    this.location.longitude = position.coords.longitude;
                    console.log('this.location.longitude' + this.location.longitude);
                    //this.loading = false;
                    let location = {};
                    location[this.latFieldApiName] = this.location.latitude;
                    location[this.longFieldApiName] = this.location.longitude;
                    if (this.location.latitude != '' && this.location.latitude != 'undefined' &&
                        this.location.longitude != '' && this.location.longitude != 'undefined') {
                        console.log('entering here>>>>>' + this.location.latitude);
                        getAccount({
                            strAccName:'',
                            latitude: this.location.latitude,
                            longitude: this.location.longitude
                        })
                    }
                });
        }
    }

    
    register() {
        console.log('event registered in lst product details');
        pubsub.register('sendDataToCustomSearch', this.handleEventLoc.bind(this));
    }
    handleEventLoc(event){
        this.locationstore = event;
        console.log(' this.locationstore'+ this.locationstore)
      }

    handlefocus(event){
        console.log('inisde focus')
        this.getCookiesData('searchtextdata');
        this.predictiveSearchDropDown=true;
        event.target.classList.add('focused');
        console.log('this.predictiveSearchDropDown'+this.predictiveSearchDropDown)
    }
    handleMouseleave(event){
       this.predictiveSearchDropDown=false;
       this.template.querySelector('.searchField').blur();
       this.template.querySelector('.searchField.dWindow').classList.remove('focused'); 
       this.template.querySelector('.searchField.mWindow').classList.remove('focused'); 

    }
  
    updateSeachKey(event) {
        this.sVal = event.target.value;
        this.offset = 0;
        this.parts = [];
        setTimeout(() => {
            this.updateSeachKey1();
        }, 500);
    }

    updateSeachKey1() {        
        console.log( this.sVal);
        //this.sVal = this.sVal.trim();
        if(!!window.sessionStorage.getItem('sendDataToCustomSearch')) this.locationstore = window.sessionStorage.getItem('sendDataToCustomSearch');
        getAllProducts({
            searchval: this.sVal,
            storeCountry: this.locationstore,
            offset: this.offset
        })
        .then(result => {
            let updatedRecords = [...this.parts, ...result];
            this.parts = [...new Map(updatedRecords.map(item => [item.Id, item])).values()];
            console.log('this.parts', JSON.stringify(this.parts));
            this.error = undefined;
        })
        .catch((error) => {
            this.error = error;
            this.parts = undefined;
        });
     }

     getMoreRecords(){
         this.offset += 10;
         this.updateSeachKey1();
     }

    createCookieData(name, value, days) {
        var expires; 	
        // Shreyas (CECI-1064) start	
        var idsArray = [	
            this.sVal,	
            ...JSON.parse(localStorage.getItem('searches') || '[]')	
        ];	
        console.log("idsArray ", idsArray);	
        localStorage.setItem('searches', JSON.stringify(idsArray));	
        // Shreyas (CECI-1064) end	
        
        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = name + "=" + escape(value) + expires + "; path=/";
    }



    getCookiesData(name){
        var cookiesName;
        var name = name + "=";
        var ca = document.cookie.split(';');
         // Shreyas (CECI-1064) start	
         for(var i = 0; i < ca.length; i++) {	
            var c = ca[i];	
            	
            c = c.trimStart();	
            if (c.startsWith(name)) {

                cookiesName = c.substring(name.length, c.length);
            }
        }
    // Shreyas (CECI-1064) start comment-out
       // let orderrecordarray = [];
      // let searchidListInput=[];
      // let recordarray = [];
      // let finalarray = [];
    // Shreyas (CECI-1064) end comment-out
        console.log('cookies data ' , cookiesName);
        if(cookiesName == 'yes'){
           
            let searchid = JSON.parse(localStorage.getItem('searches'));	
            // Shreyas (CECI-1064) end	
            // Shreyas (CECI-1064) start comment-out

            /*var pIdsString = JSON.stringify(searchid);
            var pIdsInput = pIdsString.replace('"','');
            var pIdsInput1 = pIdsInput.replace(/.$/,"");
            var pIdsListInput = pIdsInput1.split(',');
            searchidListInput = pIdsInput1.split(',');
            let i =0;
            for(i=0;i<searchidListInput.length;i++){
                 if(i!=10){
                    let orderrecord ={};
                    orderrecord['searchtext'] = searchidListInput[i];
                   // recordarray.push(orderrecord);
                    recordarray.push(searchidListInput[i]);
                 }
                 else{
                     break;
                 }
                
            }*/

           // Shreyas (CECI-1064) end comment-out	
            let unique = [...new Set(searchid)].slice(0, 10);	
            let finalarray = unique.map((s) => ({ searchtext: s }));	
            // Shreyas (CECI-1064) start comment-out
           /* for(i=0;i<unique.length;i++){
                if(i!=10){
                   let orderrecord ={};
                   orderrecord['searchtext'] = unique[i];
                   finalarray.push(orderrecord);
                  // recordarray.push(searchidListInput[i]);
                }
                else{
                    break;
                }
               
           }*/
           // Shreyas (CECI-1064) end comment-out
            console.log('unique'+JSON.stringify(unique));
            this.recentlySearched=finalarray;
                console.log('recentlySearched'+JSON.stringify(this.recentlySearched))
        } else {	
            localStorage.removeItem('searches');	
        }	
        // Shreyas (CECI-1064) end
            
       // this.firstsearchval = searchidListInput[0];
        console.log('this.firstsearchval'+this.firstsearchval)
        //this.recentlySearched=searchidListInput;
        //console.log('this.recentlySearched'+this.recentlySearched)
    }  
    handleKeyUp(event){
        if (event.which == 13){
            console.log('user clicked on enter');
           // alert('enter presses'+this.sVal)
           // let urlString = window.location.origin;
          //  console.log('inisde hadle search if urlString'+urlString);
          //  window.location.href = urlString+communityName+'dbu-search?searchText='+this.sVal;
            this.handleSearch();

             /* this[NavigationMixin.Navigate]({
                            type: 'comm__namedPage',
                            attributes: {
                                name: 'dbu_search__c'
                            },
                            state: {
                                'searchText': this.sVal
                            }
                        },
                        true // Replaces the current page in your browser history with the URL
                    );*/
        }
    }
    handleSearch() {
        // if search input value is not blank then call apex method, else display error msg 
        console.log('inisde hadle search'+this.sVal);
        if (this.sVal !== '') {
            console.log('inisde hadle search if'+this.sVal);
            invokeGoogleAnalyticsService('ESN SEARCH', this.sVal); 
            if(!!window.sessionStorage.getItem('sendDataToCustomSearch')) this.locationstore = window.sessionStorage.getItem('sendDataToCustomSearch');
            let urlString = window.location.origin;
            console.log('inisde hadle search if urlString'+urlString);
            window.location.href = urlString+communityName+'search?searchText='+this.sVal+'&store='+this.locationstore;
            console.log('inisde hadle search if urlString'+window.location.href);
            this.createCookieData('searchtextdata','yes',7);
                          /* this[NavigationMixin.Navigate]({
                            type: 'comm__namedPage',
                            attributes: {
                                name: 'dbu_search__c'
                            },
                            state: {
                                'searchText': this.sVal
                            }
                        },
                        true // Replaces the current page in your browser history with the URL
                    );*/
                    
        } 
       
        else {
            console.log('inisde hadle search else'+this.sVal);
            window.location.reload();
            
        }
    }

    handleproduct(event){
        this.sfid= event.target.getAttribute('data-sfid');
        this.sfdcName = event.target.getAttribute('data-sfdcname');
        //this.sfid= event.target.getAttribute('data-sfid');
        console.log('getattr' +event.target.getAttribute('data-sfid'));
        console.log('getattr name ' +event.target.getAttribute('data-sfdcName'));
        invokeGoogleAnalyticsService('ESN SEARCH', this.sfdcName); 
       
        let urlString = window.location.origin;
        let prodName = this.sfdcName;
        if(prodName.includes('/')){
            prodName = prodName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
          }
				window.location.href = urlString + communityName +'product/'+this.sfid +'/'+ prodName+'/?store='+this.locationstore;
      //  window.location.href = urlString+communityName+'product?name='+this.sfdcName +'&pId='+this.sfid+'&store='+this.locationstore;
 }
 handlerecently(event)
 {
     console.log('calling on click in recently')
     this.sfid= event.target.getAttribute('data-sfid');
     if(!!window.sessionStorage.getItem('sendDataToCustomSearch')) this.locationstore = window.sessionStorage.getItem('sendDataToCustomSearch');
     //this.sfid= event.target.getAttribute('data-sfid');
 console.log('getattr' +event.target.getAttribute('data-sfid'));
 console.log('getattr name ' +event.target.getAttribute('data-sfdcName'));
    invokeGoogleAnalyticsService('ESN SEARCH', this.sfid);   
    
     let urlString = window.location.origin;
     window.location.href = urlString+communityName+'search?searchText='+this.sfid+'&store='+this.locationstore;
 }
}