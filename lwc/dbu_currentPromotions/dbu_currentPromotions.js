import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
import {
    NavigationMixin
} from 'lightning/navigation';
import myResource from '@salesforce/resourceUrl/cloudMVP';
import pubsub from 'c/pubsub' ; 
import communityName from '@salesforce/label/c.dbu_communityName';

//import fetchFeaturedLstProducts from '@salesforce/apex/dbu_ProductCtrl.fetchFeaturedLstProducts';
//import fetchLstCurrentPromotions from '@salesforce/apex/dbu_ProductCtrl.fetchLstCurrentPromotions';
import getPromotionProducts from '@salesforce/apex/dbu_ProductCtrl.getPromotionProducts';
import DBU_Current_Promotions from '@salesforce/label/c.DBU_Current_Promotions'; 
import DBU_Shop_All_Promotions from '@salesforce/label/c.DBU_Shop_All_Promotions';

import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

export default class Dbu_currentPromotions extends NavigationMixin(LightningElement) {
   
    leftArrow = myResource+'/images/dbu_LeftArrow.png';
    rightArrow = myResource+'/images/dbu_RightArrow.png';
    @track queue = [];
    @track queueSize ;
    @track productListSize = 0;
    @track lstProduct;
    @track lstSearchProduct;
    @track isShowSearch = false;
    @track selectedStoreLoc = '';
    @track flag =false;
    //variable by Malhar for storing the user selected store location - 19/11/2020
    @track currentLocation;
    @track currentLanguage = 'US';
    @track DBU_Current_Promotions = DBU_Current_Promotions;
    @track DBU_Shop_All_Promotions = DBU_Shop_All_Promotions;
    @track listnametosend = 'Current Promotion Results';
    connectedCallback() {
        /*Added by Malhar for retriving store location begin - 19/11/2020 */
        let queryString = window.location.search;
        let urlParams = new URLSearchParams(queryString);
        this.currentLocation = urlParams.get('store');
        console.log('connected callback curr promotn before> ' + JSON.stringify(this.currentLocation));
        if (this.currentLocation == null) {
            this.currentLocation = 'US';
            this.currentLanguage = 'US';
        }
        if (this.currentLocation == 'EN') {
            this.currentLocation = 'CA';
            this.currentLanguage = 'EN';
        }
        if (this.currentLocation == 'FR') {
            this.currentLocation = 'CA';
            this.currentLanguage = 'FR';
        }
        console.log('connected callback iss after > ' + JSON.stringify(this.currentLocation));
        this.register();
        /*Added by Malhar for retriving store location End - 19/11/2020 */
    }


    /*Methods by Malhar  for handling the geniunPartsLocationChange event fire begin - 19/11/2020 */
    register() {
        window.console.log('currentPromotionLocationChange event registered ');
        pubsub.register('currentPromotionLocationChange', this.handleLocationChangeEvent.bind(this));
        pubsub.register('currentPromotionCurrentLanguage', this.handleLanguageChange.bind(this));
    }

    handleLanguageChange(event) {
        console.log('handleLanguageChange promotion > ' + JSON.stringify(event));
        this.currentLanguage = event;
    }
    handleLocationChangeEvent(event) {
        console.log('hickup promotion > ' + JSON.stringify(event));
        //console.log('hickup plain > ' + event);
        this.currentLocation = event;
    }
    /*Methods by Malhar  for handling the geniunPartsLocationChange event fire end - 19/11/2020 */


    /*
       regiser(){
           console.log('event registered in current promotions' );
           pubsub.register('displayProductsAccLoc', this.handledisplayProductsAccLoc.bind(this));
           
       }

       handledisplayProductsAccLoc(location){
           if(location == 'US'){
               this.selectedStoreLoc = location;
               console.log('onselect of lcoation' +this.selectedStoreLoc);
           } else if (this.location == 'CA') {
               this.selectedStoreLoc = location;
               console.log('onselect of lcoation' +this.selectedStoreLoc);
           }
           fetchLstCurrentPromotions({urlParam:window.location.href,
               selectedStoreLocation: this.selectedStoreLoc}).then(result => {
                   console.log('resultCurrentPRomotions>>' + JSON.stringify(result));  
               })
       }*/



    /*@wire(fetchLstCurrentPromotions,{urlParam:window.location.href })
    //@wire(fetchLstCurrentPromotions)
    wireProduct({ error, data }) {
        if (data) {
            window.console.log('data>>>>>>>>>>', data);
            this.lstProduct = data;
            this.error = undefined;
            console.log('data>>>>>>>>>>', this.lstProduct);
            this.size = this.lstProduct.length;
            this.productListSize = this.lstProduct.length;
            console.log('size>>' +this.size);
            this.max = this.size -1;
             this.initializeQueue();
        } else if (error) {
            this.error = error;
            this.lstProduct = undefined;
        }

        
    }*/

    @wire(getPromotionProducts, {
        urlParam: '$currentLocation'
    })
    //@wire(fetchLstCurrentPromotions)
    wireProduct({
        error,
        data
    }) {
        if (data) {
            window.console.log('promodata>>>>>>>>>>' + JSON.stringify(data));
            //window.sessionStorage.setItem('googlenalyticslistname', 'current promotion');                       
            this.lstProduct = data;
            this.error = undefined;
            console.log('data>>>>>>>>>>', this.lstProduct);
            this.size = this.lstProduct.length;
            this.productListSize = this.lstProduct.length;
            console.log('size>>' + this.size);
            this.max = this.size - 1;
            if (this.lstProduct.length == 0 || this.lstProduct.length == undefined) {
                this.flag = true;
            } else {
                console.log('Hps');
                this.frameProductImpressiondata(data, this.currentLocation); 
                this.initializeQueue();
            }
            // this.initializeQueue();
            this.isRendered = false;    //Added by Malhar
        } else if (error) {
            this.error = error;
            this.lstProduct = undefined;
        }


    }

    frameProductImpressiondata(promodata, location){
        console.log('Hpswr');
        if(promodata.length > 0){
            let impressiondata = [];
            for(let i=0 ; i<promodata.length ; i++){                    
                if(promodata[i].ccrz__E_PriceListItems__r != undefined && promodata[i].ccrz__E_PriceListItems__r != null){
                    if(promodata[i].ccrz__E_PriceListItems__r.length > 0 ){
                        let pr = 0;
                        if(promodata[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c != undefined){
                            pr = promodata[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c
                        }
                        let itemdata = {
                            "id": promodata[i].Name,
                            "name": promodata[i].Name,
                            "list": "Current Promotion Results",                    
                            "position": i+1,
                            "price": pr                
                        }
                        impressiondata.push(itemdata);
                    }else{
                        let itemdata = {
                            "id": promodata[i].Name,
                            "name": promodata[i].Name,
                            "list": "Current Promotion Results",                    
                            "position": i+1,
                            "price": 0                   
                        }
                        impressiondata.push(itemdata);
                    }
                }else{
                    let itemdata = {
                        "id": promodata[i].Name,
                        "name": promodata[i].Name,
                        "list": "Current Promotion Results",                    
                        "position": i+1,
                        "price": 0                   
                    }
                    impressiondata.push(itemdata);
                }

                console.log('impressiondata > ' + impressiondata);
            }
            invokeGoogleAnalyticsService('PRODUCT IMPRESSION', {currlocation : location, impressiondetail : impressiondata});                 
        }
    }


    /* Added by Malhar  for setting store value begin - 25/11/2020 */
    @track isRendered = false;    
    renderedCallback() {
        if (this.isRendered)
            return;
        this.isRendered = true;
        console.log('currentPromotions->> before fire sendDataTolstProdDetailspage event >>' + this.currentLanguage);
        pubsub.fire('sendDataTolstProdDetailspage', this.currentLanguage);
        console.log('currentPromotions->> after fire sendDataTolstProdDetailspage event >>' + this.currentLanguage);
    }
    /* Added by Malhar  for setting store value begin - 25/11/2020 */

    /*initializeQueue(){
        let i=0;
        console.log('insise initialise>>>>');
        for(i=0;i<this.queueSize;i++){
            //this.queue[i] = this.lstProduct[i];
            this.queue.push(this.lstProduct[i]);
        }

        console.log('jsondata>>>' +JSON.stringify(this.queue));

    }*/

    initializeQueue() {
        let i = 0;
        console.log('insise initialise>>>>');
        this.queue = []; // Malhar - Queue reset
        if (this.lstProduct.length <= 5) {
            this.queueSize = this.lstProduct.length;
            console.log('inside if recent ', this.queueSize);
        } else if (this.lstProduct.length > 5) {
            this.queueSize = 5;
            console.log('inside else if recent ', this.queueSize);
        }


        for (i = 0; i < this.queueSize; i++) {
            console.log('inside for recent ', this.queueSize);
            //this.queue[i] = this.lstProduct[i];
            this.queue.push(this.lstProduct[i]);
        }


        console.log('jsondata>>>' + JSON.stringify(this.queue));
    }


    handleClick(event) {
console.log('event.target.dataset.id' +event.target.dataset.id);
console.log('coming in handle event>>>');
        // let urlString = window.location.origin; 
        // return urlString + communityName + 'allcurrentpromotions?pId=' +event.target.dataset.id+ '&store=' + this.locationstore;
        console.log('tito > ');
        invokeGoogleAnalyticsService('NAVIGATE TO CURRENT PROMOTION PAGE', 'Current Promotion Page link Click');                 
        window.location.href = window.location.origin + communityName  + 'promotions?store=' + this.currentLanguage
        /*
        this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: 'dbu_allCurrentPromotions__c'
                },
                state: {
                    'pId': event.target.dataset.id,
                    'store':this.currentLanguage //event.target.dataset.id
                }
            },
            true // Replaces the current page in your browser history with the URL
        ); */

    }
    /*
     handleClickNext() {
         console.log('items in queue>>>>'+JSON.stringify(this.queue));
         console.log('last items in queue>>>>'+JSON.stringify(this.queue[this.queueSize - 1]));
         console.log('4th items in lstProduct>>>>'+JSON.stringify(this.lstProduct[this.queueSize ]));
                         if(this.queue[this.queueSize - 1]!=this.lstProduct[this.productListSize - 1])
                         {
                           var itemIndex = this.lstProduct.indexOf(this.queue[this.queueSize - 1]);
                           console.log('itemIndex>>'+itemIndex);
                           if(itemIndex != this.lstProduct.length)
                           {
                             var itemToPush = this.lstProduct[itemIndex + 1];
                             console.log('itemToPush>>'+JSON.stringify(itemToPush));

                             var itemToPop=this.queue[0];
                             console.log('itemToPop>>'+JSON.stringify(itemToPop));
                             console.log('this.queue[0] itemToPop>>'+JSON.stringify(this.queue[0]));
                             console.log('this.queue[1] itemToPop>>'+JSON.stringify(this.queue[1]));
                             console.log('this.queue[2] itemToPop>>'+JSON.stringify(this.queue[2]));

                             this.queue.splice(0, 1);
                             console.log('queue after pop>>'+JSON.stringify(this.queue));
                             //this.queue.push(itemToPush);
                             this.queue.splice(this.queueSize -1,1, itemToPush);
                             console.log('queue after push>>'+JSON.stringify(this.queue));
                           
                           }
                           else
                           {
                             var itemToPush = this.lstProduct[0];
                             console.log('itemToPush>>'+itemToPush);
                             var itemToPop=this.queue[0];
                             console.log('itemToPop>>'+itemToPop);
                             //this.queue.pop(itemToPop);
                             this.queue.splice(0, 1);
                             console.log('Else queue after pop>>'+JSON.stringify(this.queue));
                             //this.queue.push(itemToPush);
                             this.queue.splice(this.queueSize -1,1, itemToPush);
                             console.log('Else  queue after push>>'+JSON.stringify(this.queue));
                           }
                         
                         }
                         else{
                             var itemToPush = this.lstProduct[0];
                             console.log('itemToPush>>'+itemToPush);
                             var itemToPop=this.queue[0];
                             console.log('itemToPop>>'+itemToPop);
                             //this.queue.pop(itemToPop);
                             this.queue.splice(0, 1);
                             console.log('2nd Else queue after pop>>'+JSON.stringify(this.queue));
                             //this.queue.push(itemToPush);
                             this.queue.splice(this.queueSize -1,1, itemToPush);
                             console.log('2nd Else  queue after push>>'+JSON.stringify(this.queue));
                             
                         }
     } 
               

            
        */
            
        
            
           
    handleClickNext() {
        console.log('items in queue>>>>' + JSON.stringify(this.queue));
        console.log('last items in queue>>>>' + JSON.stringify(this.queue[this.queueSize - 1]));
        console.log('4th items in lstProduct>>>>' + JSON.stringify(this.lstProduct[this.queueSize]));
        if (this.queue[this.queueSize - 1] != this.lstProduct[this.productListSize - 1]) {
            var itemIndex = this.lstProduct.indexOf(this.queue[this.queueSize - 1]);
            console.log('itemIndex>>' + itemIndex);
            if (itemIndex != this.lstProduct.length) {
                var itemToPush = this.lstProduct[itemIndex + 1];
                console.log('itemToPush>>' + JSON.stringify(itemToPush));

                //var itemToPop=this.queue[0];
                //console.log('itemToPop>>'+JSON.stringify(itemToPop));
                //console.log('this.queue[0] itemToPop>>'+JSON.stringify(this.queue[0]));
                //console.log('this.queue[1] itemToPop>>'+JSON.stringify(this.queue[1]));
                //console.log('this.queue[2] itemToPop>>'+JSON.stringify(this.queue[2]));

                this.queue.splice(0, 1);
                console.log('queue after pop>>' + JSON.stringify(this.queue));
                //this.queue.push(itemToPush);
                this.queue.splice(this.queueSize - 1, 1, itemToPush);
                console.log('queue after push>>' + JSON.stringify(this.queue));

            } else {
                var itemToPush = this.lstProduct[0];
                console.log('itemToPush>>' + itemToPush);
                var itemToPop = this.queue[0];
                console.log('itemToPop>>' + itemToPop);
                //this.queue.pop(itemToPop);
                this.queue.splice(0, 1);
                console.log('Else queue after pop>>' + JSON.stringify(this.queue));
                //this.queue.push(itemToPush);
                this.queue.splice(this.queueSize - 1, 1, itemToPush);
                console.log('Else  queue after push>>' + JSON.stringify(this.queue));
            }

        } else {
            var itemToPush = this.lstProduct[0];
            console.log('itemToPush>>' + itemToPush);
            var itemToPop = this.queue[0];
            console.log('itemToPop>>' + itemToPop);
            //this.queue.pop(itemToPop);
            this.queue.splice(0, 1);
            console.log('2nd Else queue after pop>>' + JSON.stringify(this.queue));
            //this.queue.push(itemToPush);
            this.queue.splice(this.queueSize - 1, 1, itemToPush);
            console.log('2nd Else  queue after push>>' + JSON.stringify(this.queue));

        }

        /*Added by Malhar for passing store language to PDP page - begin - 25/11/2020 */
        console.log('next button current promotions this.currentLanguage > ' + this.currentLanguage);
        //pubsub.fire('sendDataTolstProdDetailspage', this.currentLanguage);            
        this.isRendered = false;
        console.log('this.isRendered  current promotions next > ' + this.isRendered );
        console.log('currentLocation in current promotions next > ' + this.currentLocation);
        /*Added by Malhar for passing store language to PDP page - end - 25/11/2020 */   
        
    }


    handleClickPrev() {
        console.log('Previousitems in queue>>>>' + JSON.stringify(this.queue));
        console.log('Previouslast items in queue>>>>' + JSON.stringify(this.queue[this.queueSize - 1]));
        console.log('Previous items in lstProduct>>>>' + JSON.stringify(this.lstProduct[this.queueSize]));
        if (this.queue[0] != this.lstProduct[0]) {
            var itemIndex = this.lstProduct.indexOf(this.queue[0]); //commented by shriram
            //var itemIndex = this.lstProduct.indexOf(0);//added by shriram
            console.log('PreviousitemIndex>>' + itemIndex);
            console.log('PreviouslstProdLnght>>' + this.lstProduct.length);

            //if(itemIndex != this.lstProduct.length -1)//commented by shriram
            //if(true)//added by shriram itemIndex != 0
            //{
            //var itemToPush = this.lstProduct[itemIndex+ 1]; //commented by shriram as below line
            var itemToPush = this.lstProduct[itemIndex - 1]; //added by shriram
            console.log('PreviousitemToPush>>' + JSON.stringify(itemToPush));

            //var itemToPop=this.queue[this.queueSize-1];
            //console.log('PreviousitemToPop>>'+JSON.stringify(itemToPop));
            //console.log('Previousthis.queue[0] itemToPop>>'+JSON.stringify(this.queue[0]));
            //console.log('Previousthis.queue[1] itemToPop>>'+JSON.stringify(this.queue[1]));
            //console.log('Previousthis.queue[2] itemToPop>>'+JSON.stringify(this.queue[2]));

            this.queue.splice(this.queueSize - 1, 1);
            console.log('Previousqueue after pop>>' + JSON.stringify(this.queue));
            //this.queue.push(itemToPush);
            //this.queue.splice(this.queueSize - 1,0, itemToPush);//commented by shriram as below line
            this.queue.splice(0, 0, itemToPush); //added by shriram
            console.log('Previousqueue after push>>' + JSON.stringify(this.queue));



        } else {
            var itemToPush = this.lstProduct[this.lstProduct.length - 1];
            console.log('PreviousitemToPush>>' + itemToPush);
            var itemToPop = this.queue[0];
            console.log('PreviousitemToPop>>' + itemToPop);
            //this.queue.pop(itemToPop);
            //this.queue.splice(0, 1);commented by shriram due to below line
            this.queue.splice(this.queueSize - 1, 1); //Added by shriram 
            console.log('Previous2nd Else queue after pop>>' + JSON.stringify(this.queue));
            //this.queue.push(itemToPush);
            this.queue.splice(0, 0, itemToPush);
            console.log('Previous2nd Else  queue after push>>' + JSON.stringify(this.queue));

        }

        /*Added by Malhar for passing store language to PDP page - begin - 25/11/2020 */
        console.log('prev button current promotions this.currentLanguage > ' + this.currentLanguage);
        //pubsub.fire('sendDataTolstProdDetailspage', this.currentLanguage);            
        this.isRendered = false;
        console.log('this.isRendered  current promotions prev > ' + this.isRendered );
        console.log('currentLocation in current promotions prev > ' + this.currentLocation);
        /*Added by Malhar for passing store language to PDP page - end - 25/11/2020 */  

    }



}