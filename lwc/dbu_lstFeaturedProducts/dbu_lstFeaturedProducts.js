import { LightningElement, wire,track,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import myResource from '@salesforce/resourceUrl/cloudMVP';

import pubsub from 'c/pubsub';
import fetchFeaturedLstProducts from '@salesforce/apex/dbu_ProductCtrl.fetchFeaturedLstProducts';
import fetchFeaturedLstProducts1 from '@salesforce/apex/dbu_ProductCtrl.fetchFeaturedLstProducts1';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A';
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';
import sizeOfQueue from '@salesforce/label/c.dbu_queueSize';
import productSize from '@salesforce/label/c.dbu_productListSize';
import mostPopularParts from '@salesforce/label/c.dbu_MostPopularParts';
import NewProducts from '@salesforce/label/c.dbu_newProducts';
import communityName from '@salesforce/label/c.dbu_communityName';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import { getCoreChargeList } from 'c/serviceComponent';
// import { getCoreChargeList } from '../serviceComponent/serviceComponent';
export default class Dbu_lstFeaturedProducts extends NavigationMixin(LightningElement) {

    leftArrow = myResource+'/images/dbu_LeftArrow.png';
    rightArrow = myResource+'/images/dbu_RightArrow.png';
    @track queue = [];
    @track queueSize = sizeOfQueue;
    @track productListSize = productSize;
    @track productListSize1 = productSize; //Sandeep


    @track lstProduct;
    @track lstSearchProduct;
    @track isShowSearch = false;
    @track isLoading = true;
    @track listnametosend = 'Most Popular Part Results';
    
    @track queue1 = []; // Change By Ravi
    @track lstProduct1; // Change By Ravi

    //variables by Malhar for storing the user selected store location - 19/11/2020
    @track currentLocation;  
    @track currentLanguage = storeUSA;   
    @track repos;
    @track corePrice;
    @track mostPopularList;
    label = {
        mostPopularParts,
        NewProducts
    }
    connectedCallback(){
        //this.mostpopular = dbu_home_carousel_mostPopularParts;

        /*Added by Malhar for retriving store location begin - 19/11/2020 */
          
        let queryString = window.location.search;
        let urlParams = new URLSearchParams(queryString);
        //this.currentLocation = urlParams.get('store');
        this.currentLocation = window.sessionStorage.getItem('setCountryCode');
        console.log('connected callback featured prod curr locatn before > ' + JSON.stringify(this.currentLocation));
        console.log('connected callback featured prod curr lang before > ' + JSON.stringify(this.currentLanguage));
        if(this.currentLocation == null){
            this.currentLocation = storeUSA;    
        }else if(this.currentLocation == storeCA){
            this.currentLocation = storeCanada;
            this.currentLanguage = storeCA;
        }else if(this.currentLocation == storeCAF){
            this.currentLocation = storeCanada;
            this.currentLanguage = storeCAF;
        }
        console.log('connected callback featured prod after > ' + JSON.stringify(this.currentLocation));
        console.log('connected callback featured prod curr lang after > ' + JSON.stringify(this.currentLanguage));
        this.register();
     
    /*Added by Malhar for retriving store location End - 19/11/2020 */        

    }
    /*Methods by Malhar for handling the geniunPartsLocationChange event fire begin - 19/11/2020 */
    register() {
        window.console.log('featuredProductsLocationChange event registered ');
        pubsub.register('featuredProductsLocationChange', this.handleLocationChangeEvent.bind(this));  
        pubsub.register('featuredProductsCurrentLanguage', this.handleLanguageChangeEvent.bind(this));            
    }    
    
    
    handleLocationChangeEvent(event) {        
        console.log('hickup featuredProducts > ' + JSON.stringify(event));
        //console.log('hickup plain > ' + event);
        this.currentLocation = event;
    } 
    handleLanguageChangeEvent(event){
        console.log('featur prod lang chage event > ' + JSON.stringify(event));
        this.currentLanguage = event;
    }
    // Create New By Ravi
    @wire(fetchFeaturedLstProducts1,{urlParam: '$currentLocation'})
    wireProduct1({ error, data }) {
        if (data) {
            let prodArray = [];
            let prod ={};
            this.isLoading = false;
            window.console.log('data>>>>>>>>>> in fetchFeatureLstProducts1', data.length);
            console.log('data in featuredProduct1',JSON.parse(JSON.stringify(data)));
            this.lstProduct1 = data
            this.error = undefined;
            console.log('data in featured>>>>>>>>>> fetchFeatureLstProducts1' +JSON.stringify(this.lstProduct1));
            this.productListSize1 = this.lstProduct1.length; //Sandeep: replaced variable productListSize with productListSize1
            
            console.log('size>>' +this.size);
            console.log('productListSize1>>' +this.productListSize1);
            this.initializeQueue();
             this.isRendered = false;   //Added by Malhar 
        } else if (error) {
            this.isLoading = false;
            this.error = error;
            this.lstProduct1 = undefined;
        }
    }
    // getCoreChargeList(lstProduct1, corePrice) {
    //     for(let i =0; i < lstProduct1.length; i++){
    //         let price = lstProduct1[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
    //         let originalprice = lstProduct1[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
    //         for(let b in this.corePrice){
    //             if(lstProduct1[i].Id == b){
    //                 console.log('adding price');
    //                 let coreCharge = parseFloat(corePrice[b]);
    //                 console.log('core Charge', coreCharge);
    //                 console.log(' price', lstProduct1[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c);
    //                 lstProduct1[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c = price + coreCharge;
    //                 lstProduct1[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c = originalprice + coreCharge;
    //                 // price = recentlyviewedProduct['price'];
    //                 // originalprice = recentlyviewedProduct['originalPrice'];
    //             }
    //         }  
    //     }
    // }
    /*Methods by Malhar for handling the geniunPartsLocationChange event fire end - 19/11/2020 */
    get ScreenLoaded()
    {
        return this.isLoading;
    }  
    @wire(fetchFeaturedLstProducts,{urlParam: '$currentLocation'})

    wireProduct({ error, data }) {
        if (data) {
            let prodArray = [];
            let prod ={};
            this.isLoading = false;
            window.console.log('data>>>>>>>>>> in fetchFeatureLstProducts', JSON.parse(JSON.stringify(data)));
          /*  for(let i=0 ;i < data.length ;i++){
               console.log('=========='+data[i].ccrz__E_ProductMedias__r);
               if(data[i].ccrz__E_ProductMedias__r === undefined){
                   console.log('IN Loop');
                data[i].ccrz__E_ProductMedias__r[0].ccrz__URI__c = "https://cssna-parts.gdc-rad.com/genuine_parts.jpg";
                   console.log('URI='+data[i].ccrz__E_ProductMedias__r[0].ccrz__URI__c);
              //  prodArray.push(data[i]);
               }
            }*/
           // console.log('lstProduct======'+prodArray.length);
          //  this.lstProduct = prodArray;
            /* Sasikanth CECI-958 GTM Events Start*/
            var brandProductMap = new Map(); 
            var categoryProductMap = new Map();
            /* Sasikanth CECI-958 GTM Events End*/
            let datatosendtoimpression = data;
            this.lstProduct = data.productData;
            /* Sasikanth CECI-958 GTM Events Start*/
            var brandData = data.branddata;
            var categoryData = data.categorydata;
            let brandKey = Object.keys(brandData);
            let brandVal = Object.values(brandData);
            let categoryKey = Object.keys(categoryData);
            let categoryVal = Object.values(categoryData);
            for(let i= 0; i < brandKey.length; i++)
                brandProductMap.set(brandKey[i],brandVal[i]);
            for(let k= 0; k < categoryKey.length; k++)
                categoryProductMap.set(categoryKey[k],categoryVal[k]);
            /* Sasikanth CECI-958 GTM Events End*/
            this.mostPopularList= JSON.parse(JSON.stringify(this.lstProduct));
            this.corePrice = data.corePrice;
            this.error = undefined;
            console.log('data in featured>>>>>>>>>> fetchFeatureLstProducts' +JSON.stringify(this.lstProduct));
            this.productListSize = this.lstProduct.length;
            this.lstProduct = getCoreChargeList(this.mostPopularList, this.corePrice);
            /* Sasikanth CECI-958 GTM Events Start*/
            for(let j=0; j<this.lstProduct.length; j++){
                this.lstProduct[j].brand = brandProductMap.get(this.lstProduct[j].Id);
                this.lstProduct[j].category = categoryProductMap.get(this.lstProduct[j].Id);
            }
            /* Sasikanth CECI-958 GTM Events End*/
            console.log('size>>' +this.size);
            console.log('productListSize>>' +this.productListSize);
            this.frameProductImpressiondata(JSON.parse(JSON.stringify(this.lstProduct)),this.currentLanguage);
             this.initializeQueue();
             this.isRendered = false;   //Added by Malhar 
        } else if (error) {
            this.isLoading = false;
            this.error = error;
            this.lstProduct = undefined;
        }
    }


    frameProductImpressiondata(promodata, location){
        console.log('Hpswr');
        if(promodata != null && promodata != undefined && promodata != ''){
            if(promodata.length > 0){
                let impressiondata = [];
                for(let i=0 ; i<promodata.length ; i++){ 
                    if(promodata[i].ccrz__E_PriceListItems__r != undefined && promodata[i].ccrz__E_PriceListItems__r.length != null){
                        if(promodata[i].ccrz__E_PriceListItems__r.length > 0 ){
                            let pr = 0;                        
                            if(promodata[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c != undefined){
                                pr = promodata[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                            }                        
                            let itemdata = {
                                "id": promodata[i].ccrz__SKU__c,/* Sasikanth CECI-958 GTM Events*/
                                "name": promodata[i].Name,
                                "list": "Most Popular Part Results",                    
                                "position": i+1,                        
                                "price": JSON.stringify(pr)  /* Sasikanth CECI-958 GTM Events*/               
                            }                        
                            impressiondata.push(itemdata);
                        }else{
                            let itemdata = {
                                "id": promodata[i].ccrz__SKU__c,/* Sasikanth CECI-958 GTM Events*/
                                "name": promodata[i].Name,
                                "list": "Most Popular Part Results",                    
                                "position": i+1,
                                "price": "0"    /* Sasikanth CECI-958 GTM Events*/               
                            }
                            impressiondata.push(itemdata);
                        }
                    }else{
                        let itemdata = {
                            "id": promodata[i].ccrz__SKU__c,/* Sasikanth CECI-958 GTM Events*/
                            "name": promodata[i].Name,
                            "list": "Most Popular Part Results",                    
                            "position": i+1,
                            "price": "0"         /* Sasikanth CECI-958 GTM Events*/          
                        }
                        impressiondata.push(itemdata);
                    }               
                    console.log('impressiondata > ' + impressiondata);
                }
                invokeGoogleAnalyticsService('PRODUCT IMPRESSION', {currlocation : location, impressiondetail : impressiondata});                 
            }
        }

    }



    /* Added by Malhar for setting store value begin - 25/11/2020 */
    @track isRendered = false;
    renderedCallback() {
        if (this.isRendered)
            return;
        this.isRendered = true;
        console.log('featured products ->> before fire sendDataTolstProdDetailspage event >>' + this.currentLanguage);
        pubsub.fire('sendDataTolstProdDetailspage', this.currentLanguage);
        console.log('featured products ->> after fire sendDataTolstProdDetailspage event >>' + this.currentLanguage);
    }
    /* Added by Malhar for setting store value end - 25/11/2020 */
    
    initializeQueue(){
        let i=0;
        this.queue = []; // Malhar - Queue reset
        console.log('insise initialise>>>>');
        console.log('queueSize>>>> '+ this.queueSize);
        console.log('queueSize222>>>> '+ this.lstProduct.length);
        console.log('queueSize333>>>> '+ this.lstProduct1.length);

        let sizeQueue = (this.queueSize >= this.lstProduct.length) ? this.lstProduct.length : this.queueSize; //Sandeep
        for(i=0;i<sizeQueue;i++){
            this.queue.push(this.lstProduct[i]);
        }
        console.log('jsondata>>>' +JSON.stringify(this.queue));

        // Change By Ravi
        let j=0;
        this.queue1 = [];
        console.log('inside  NEW initialise>>>>');
        console.log('queue NEW Size>>>> '+ this.queueSize);
        let sizeQueue1 = (this.queueSize >= this.lstProduct1.length) ? this.lstProduct1.length : this.queueSize; //Sandeep

        for(j=0;j<sizeQueue1;j++){
            this.queue1.push(this.lstProduct1[j]);
        }
        console.log('jsondata NEW>>>' +JSON.stringify(this.queue1));
    }


    handleClick(event){        
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name : 'dbu_product__c'
            },
            state: {
                'pId': event.target.dataset.id  //event.target.dataset.id
            }
            },
        true // Replaces the current page in your browser history with the URL
        );

    }
  
            handleClickNext() {
                //console.log('items in queue>>>>'+JSON.stringify(this.queue));
                //console.log('last items in queue>>>>'+JSON.stringify(this.queue[this.queueSize - 1]));
                //console.log('4th items in lstProduct>>>>'+JSON.stringify(this.lstProduct[this.queueSize ]));
                                if(this.queue[this.queueSize - 1]!=this.lstProduct[this.productListSize - 1])
                                {
                                  var itemIndex = this.lstProduct.indexOf(this.queue[this.queueSize - 1]);
                                  //console.log('itemIndex>>'+itemIndex);
                                  if(itemIndex != this.lstProduct.length)
                                  {
                                    var itemToPush = this.lstProduct[itemIndex + 1];
                                    //console.log('itemToPush>>'+JSON.stringify(itemToPush));
        
                                    //var itemToPop=this.queue[0];
                                    //console.log('itemToPop>>'+JSON.stringify(itemToPop));
                                    //console.log('this.queue[0] itemToPop>>'+JSON.stringify(this.queue[0]));
                                    //console.log('this.queue[1] itemToPop>>'+JSON.stringify(this.queue[1]));
                                    //console.log('this.queue[2] itemToPop>>'+JSON.stringify(this.queue[2]));
        
                                    this.queue.splice(0, 1);
                                    //console.log('queue after pop>>'+JSON.stringify(this.queue));
                                    //this.queue.push(itemToPush);
                                    this.queue.splice(this.queueSize -1,1, itemToPush);
                                    //console.log('queue after push>>'+JSON.stringify(this.queue));
                                  
                                  }
                                  else
                                  {
                                    var itemToPush = this.lstProduct[0];
                                    //console.log('itemToPush>>'+itemToPush);
                                    var itemToPop=this.queue[0];
                                    //console.log('itemToPop>>'+itemToPop);
                                    //this.queue.pop(itemToPop);
                                    this.queue.splice(0, 1);
                                    //console.log('Else queue after pop>>'+JSON.stringify(this.queue));
                                    //this.queue.push(itemToPush);
                                    this.queue.splice(this.queueSize -1,1, itemToPush);
                                    //console.log('Else  queue after push>>'+JSON.stringify(this.queue));
                                  }
                                
                                }
                                else{
                                    var itemToPush = this.lstProduct[0];
                                    //console.log('itemToPush>>'+itemToPush);
                                    var itemToPop=this.queue[0];
                                   // console.log('itemToPop>>'+itemToPop);
                                    //this.queue.pop(itemToPop);
                                    this.queue.splice(0, 1);
                                    //console.log('2nd Else queue after pop>>'+JSON.stringify(this.queue));
                                    //this.queue.push(itemToPush);
                                    this.queue.splice(this.queueSize -1,1, itemToPush);
                                    //console.log('2nd Else  queue after push>>'+JSON.stringify(this.queue));
                                    
                                }
                            
                            /*Added by Malhar for passing store language to PDP page - begin - 25/11/2020 */
                            console.log('next button featur prod this.currentLanguage > ' + this.currentLanguage);
                            //pubsub.fire('sendDataTolstProdDetailspage', this.currentLanguage);            
                            this.isRendered = false;
                            console.log('this.isRendered  feautr prod next > ' + this.isRendered );
                            console.log('currentLocation in lstfeaturedprod next > ' + this.currentLocation);
                            /*Added by Malhar for passing store language to PDP page - end - 25/11/2020 */    
                            
            } 
                      
        
                    handleClickPrev() {
                   // console.log('Previousitems in queue>>>>'+JSON.stringify(this.queue));
                   // console.log('Previouslast items in queue>>>>'+JSON.stringify(this.queue[this.queueSize - 1]));
                   // console.log('Previous items in lstProduct>>>>'+JSON.stringify(this.lstProduct[this.queueSize ]));
                                if(this.queue[0]!=this.lstProduct[0])
                                {
                                    var itemIndex = this.lstProduct.indexOf(this.queue[0]);//commented by shriram
                                    //console.log('PreviousitemIndex>>'+itemIndex);
                                    // console.log('PreviouslstProdLnght>>'+this.lstProduct.length);
                                      var itemToPush = this.lstProduct[itemIndex - 1];//added by shriram
                                      //console.log('PreviousitemToPush>>'+JSON.stringify(itemToPush));
        
                                      //var itemToPop=this.queue[this.queueSize-1];
                                      //console.log('PreviousitemToPop>>'+JSON.stringify(itemToPop));
                                      //console.log('Previousthis.queue[0] itemToPop>>'+JSON.stringify(this.queue[0]));
                                      //console.log('Previousthis.queue[1] itemToPop>>'+JSON.stringify(this.queue[1]));
                                      //console.log('Previousthis.queue[2] itemToPop>>'+JSON.stringify(this.queue[2]));
        
                                      this.queue.splice(this.queueSize - 1, 1);
                                      //console.log('Previousqueue after pop>>'+JSON.stringify(this.queue));
                                      //this.queue.push(itemToPush);
                                      //this.queue.splice(this.queueSize - 1,0, itemToPush);//commented by shriram as below line
                                      this.queue.splice(0,0, itemToPush);//added by shriram
                                      //console.log('Previousqueue after push>>'+JSON.stringify(this.queue));
                                    
                                   
                                  
                                }
                                else{
                                    var itemToPush = this.lstProduct[this.lstProduct.length - 1];
                                    //console.log('PreviousitemToPush>>'+itemToPush);
                                    var itemToPop=this.queue[0];
                                   //console.log('PreviousitemToPop>>'+itemToPop);
                                    this.queue.splice(this.queueSize - 1, 1);//Added by shriram 
                                    //console.log('Previous2nd Else queue after pop>>'+JSON.stringify(this.queue));
                                    this.queue.splice(0,0, itemToPush);
                                    //console.log('Previous2nd Else  queue after push>>'+JSON.stringify(this.queue));
                                    
                                }
                                
                                /*Added by Malhar for passing store language to PDP page - begin - 25/11/2020 */
                                console.log('prev button featur prod this.currentLanguage > ' + this.currentLanguage);
                                //pubsub.fire('sendDataTolstProdDetailspage', this.currentLanguage);            
                                this.isRendered = false;
                                console.log('this.isRendered  feautr prod prev > ' + this.isRendered );
                                console.log('currentLocation in lstfeaturedprod prev > ' + this.currentLocation);                                                                 
                                /*Added by Malhar for passing store language to PDP page - end - 25/11/2020 */
                    }
                    handleClickNext1() {
                        if(this.queue1[this.queueSize - 1]!=this.lstProduct1[this.productListSize1 - 1])
                        {
                          var itemIndex = this.lstProduct1.indexOf(this.queue1[this.queueSize - 1]);
                          //console.log('itemIndex>>'+itemIndex);
                          if(itemIndex != this.lstProduct1.length)
                          {
                            var itemToPush = this.lstProduct1[itemIndex + 1];
                            
                            this.queue1.splice(0, 1);
                            this.queue1.splice(this.queueSize -1,1, itemToPush);
                          }
                          else
                          {
                            var itemToPush = this.lstProduct1[0];
                            var itemToPop=this.queue1[0];
                            this.queue1.splice(0, 1);
                            this.queue1.splice(this.queueSize -1,1, itemToPush);
                          }
                        
                        }
                        else{
                            var itemToPush = this.lstProduct1[0];
                            var itemToPop=this.queue1[0];
                            this.queue1.splice(0, 1);
                            this.queue1.splice(this.queueSize -1,1, itemToPush);
                            
                        }         
                    this.isRendered = false;    
                    
    } 

    // Created By Ravi
    handleClickPrev1() {
            if(this.queue1[0]!=this.lstProduct1[0])
                     {
                         var itemIndex = this.lstProduct1.indexOf(this.queue1[0]);//commented by shriram
                         var itemToPush = this.lstProduct1[itemIndex - 1];//added by shriram
                           
                         this.queue1.splice(this.queueSize - 1, 1);
                         this.queue1.splice(0,0, itemToPush);//added by shriram
                         
                        
                       
                     }
                     else{
                         var itemToPush = this.lstProduct1[this.lstProduct1.length - 1];
                         var itemToPop=this.queue1[0];
                         this.queue1.splice(this.queueSize - 1, 1);//Added by shriram 
                         this.queue1.splice(0,0, itemToPush);
                        
                     }
                    this.isRendered = false;
         } 


}