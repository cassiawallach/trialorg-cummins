import { LightningElement, wire,track,api } from 'lwc';
import pubsub from 'c/pubsub' ; 
import { NavigationMixin } from 'lightning/navigation';
import dbu_home_carousel_recentlyViewedParts from '@salesforce/label/c.dbu_home_carousel_recentlyViewedParts';
import dbu_home_carousel_shopAllRecentlyViewed from '@salesforce/label/c.dbu_home_carousel_shopAllRecentlyViewed';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A';
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import fetchFeaturedLstProducts from '@salesforce/apex/dbu_ProductCtrl.fetchFeaturedLstProducts';
import communityName from '@salesforce/label/c.dbu_communityName';
import fetchRecentLstProducts from '@salesforce/apex/dbu_ProductCtrl.fetchRecentLstProducts';
export default class dbu_lstRecentlyViewedProducts extends NavigationMixin(LightningElement) {

    @track queue = [];
    @track queueSize ;
    @track productListSize = 0;
    @track lstProduct;
    @track frstlstProduct;
    @track lstSearchProduct;
    @track isShowSearch = false;
    @track isLoading = true;
    @track pIds = [];
    @track flag =false;
    @track recenttext;
    @track shopalltext;
    @track listnametosend = 'Recently Viewed Products Results';
    //variable by Malhar for storing the user selected store location - 7/12/2020
    @track currentLocation;
    @track currentLanguage = storeUSA;

    get ScreenLoaded()
    {
        return this.isLoading;
    }
    
    connectedCallback(){
        //window.location.hash="no-back-button";
        //window.location.hash="Again-No-back-button";
        //window.onhashchange=function(){window.location.hash = "no-back-button";}
        /*Added by Malhar for retriving store location begin - 7/12/2020 */
        let queryString = window.location.search;
        console.log('queryString ',queryString);
        let urlParams = new URLSearchParams(queryString);
        console.log('urlParams ',urlParams);
        //this.currentLocation = urlParams.get('store');
        this.currentLocation = window.sessionStorage.getItem('setCountryCode');
        console.log('connected callback curr promotn before> ' + JSON.stringify(this.currentLocation));
        if (this.currentLocation == null) {
            this.currentLocation = storeUSA;
        }
        if (this.currentLocation == storeCA) {
            this.currentLocation = storeCanada;
            this.currentLanguage = storeCA;
        }
        if (this.currentLocation == storeCAF) {
            this.currentLocation = storeCanada;
            this.currentLanguage = storeCAF;
        }
        console.log('connected callback iss after > ' + JSON.stringify(this.currentLocation));
        this.register();
        /*Added by Malhar for retriving store location End - 7/12/2020 */     

        this.getCookiesData('RecentPids');
        this.recenttext=dbu_home_carousel_recentlyViewedParts;
        this.shopalltext = dbu_home_carousel_shopAllRecentlyViewed;
        const url = new URL(window.location);
        window.history.pushState({}, '', url);
    }

    /*Methods by Malhar  for handling the geniunPartsLocationChange event fire begin - 19/11/2020 */
    register() {
        window.console.log('lstRecentlyViewProdLocationChange event registered ');
        pubsub.register('lstRecentlyViewProdLocationChange', this.handleLocationChangeEvent.bind(this));
        pubsub.register('lstRecentlyViewProdCurrentLanguage', this.handleLanguageChange.bind(this));
    }   
    
    
    handleLanguageChange(event) {
        console.log('handleLanguageChange lstRecentlyViewProd > ' + JSON.stringify(event));
        this.currentLanguage = event;
    }
    handleLocationChangeEvent(event) {
        console.log('hickup lstRecentlyViewProd > ' + JSON.stringify(event));
        //console.log('hickup plain > ' + event);
        this.currentLocation = event;
    }
    /*Methods by Malhar  for handling the geniunPartsLocationChange event fire end - 19/11/2020 */    
 
    getCookiesData(name){
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
        console.log('cookies data ' , cookiesName);
        if(cookiesName == 'yes'){
            var pIds = localStorage.getItem('ProductIdessss');
            console.log('pids in cookies ' , pIds);
            console.log('only data', JSON.stringify(pIds));
            var pIdsString = JSON.stringify(pIds);
            var pIdsInput = pIdsString.replace('"','');
            var pIdsInput1 = pIdsInput.replace(/.$/,"");
            var pIdsListInput= pIdsInput1.split(',');
            //var pIdsListInput= pIdsInput.split(',');
            //var pIdsListInput= pIdsString.split(',');
            console.log('cookies data in split ' , pIdsListInput);
            
            fetchRecentLstProducts({
                idList: pIdsListInput,
                storeCountry : this.currentLocation
            })
            .then(result => {
                console.log('from recently view');
                this.isLoading = false;
                window.console.log('data>>>>>>>>>>', JSON.parse(JSON.stringify(result)));
                window.console.log('data>>>>>>>>>> from recently viewed' +  JSON.stringify(result));
                /* Sasikanth CECI-958 GTM Events Start*/
                var brandProductMap = new Map(); 
                var categoryProductMap = new Map();
                var brandData = result.branddata;
                var categoryData = result.categorydata;
                let brandKey = Object.keys(brandData);
                let brandVal = Object.values(brandData);
                let categoryKey = Object.keys(categoryData);
                let categoryVal = Object.values(categoryData);
                for(let i= 0; i < brandKey.length; i++)
                    brandProductMap.set(brandKey[i],brandVal[i]);
                for(let k= 0; k < categoryKey.length; k++)
                    categoryProductMap.set(categoryKey[k],categoryVal[k]);
                    /* Sasikanth CECI-958 GTM Events End*/
                //CoreCharge Changes
                this.frstlstProduct = JSON.parse(JSON.stringify(result.productData));
                console.log('this.frstlstProduct',JSON.parse(JSON.stringify(result.productData)));
                this.corePrice = result.corePrice;
                for(let i = 0; i < this.frstlstProduct.length; i++){
                    console.log('in for loop')
                    this.frstlstProduct[i].brand = brandProductMap.get(this.frstlstProduct[i].Id);/* Sasikanth CECI-958 GTM Events*/
                    this.frstlstProduct[i].category = categoryProductMap.get(this.frstlstProduct[i].Id);/* Sasikanth CECI-958 GTM Events*/
                    var price;
                    var originalprice;
                    if(this.frstlstProduct[i].ccrz__E_PriceListItems__r != undefined){
                        price = parseFloat(this.frstlstProduct[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c);
                        if(this.frstlstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c != undefined
                            && this.frstlstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c != null
                            && this.frstlstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c > 0)
                        originalprice = parseFloat(this.frstlstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c);
                    }
                    var fnPrice;
                    var fnOriginalPrice;
                    if(this.frstlstProduct[i].dbu_Has_Core_Charge__c) {
                        for(let b in this.corePrice){
                            if(this.frstlstProduct[i].Id == b){
                                console.log('adding price');
                                let coreCharge = parseFloat(this.corePrice[b]);
                                console.log('core Charge', coreCharge);
                                if(this.frstlstProduct[i].ccrz__E_PriceListItems__r != undefined){
                                    this.frstlstProduct[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c = price + coreCharge;
                                    this.frstlstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c = originalprice + coreCharge;
                                    fnPrice = this.frstlstProduct[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                                    fnOriginalPrice = this.frstlstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                                    this.frstlstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c = Math.round(((fnOriginalPrice - fnPrice)/fnOriginalPrice)*100);
                                    console.log('discountPercentage in lstRecentlyViewed', this.frstlstProduct[i].ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c);
                                }
                            }
                        }  
                }     
                }
                


                this.lstProduct = this.frstlstProduct;
                //this.corePrice = result.corePrice;
                this.error = undefined;
                console.log('data>>>>>>>>>> lstProduct', JSON.parse(JSON.stringify(this.lstProduct)));
                this.size = this.lstProduct.length;
                // this.lstProduct = getCoreChargeList(this.lstProduct, this.corePrice);
                this.productListSize = this.lstProduct.length;
                console.log('size>>' +this.size);
                this.max = this.size -1;
               // this.queueSize = this.lstProduct.length;
               if(this.lstProduct.length  == 0 || this.lstProduct.length == undefined){
                this.flag = true;
               }else{
                this.frameProductImpressiondata(JSON.parse(JSON.stringify(this.lstProduct)), this.currentLanguage);   
                this.initializeQueue(); 
               }
               this.isRendered = false;    //Added by Malhar
            })
            .catch(error => {
                this.error = error.message;
                console.log('error.message ',error.message);
            });
        }else{
            localStorage.removeItem("ProductIdessss");
        }
    }


    frameProductImpressiondata(promodata, location){
        console.log('Hpswr');
        if(promodata != null && promodata != undefined && promodata != ''){
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
                                "id": promodata[i].ccrz__SKU__c, /* Sasikanth CECI-958 GTM Events*/
                                "name": promodata[i].Name,
                                "list_name": "Recently Viewed Products Results",                    
                                "list_position": i+1,
                                "quantity": 1,
                                "price": JSON.stringify(pr)     /* Sasikanth CECI-958 GTM Events*/             
                            }
                            impressiondata.push(itemdata);
                        }else{
                            let itemdata = {
                                "id": promodata[i].ccrz__SKU__c, /* Sasikanth CECI-958 GTM Events*/
                                "name": promodata[i].Name,
                                "list_name": "Recently Viewed Products Results",                    
                                "list_position": i+1,
                                "quantity": 1,
                                "price": "0"          /* Sasikanth CECI-958 GTM Events*/         
                            }
                            impressiondata.push(itemdata);
                        }
                    }else{
                        let itemdata = {
                            "id": promodata[i].ccrz__SKU__c, /* Sasikanth CECI-958 GTM Events*/
                            "name": promodata[i].Name,
                            "list_name": "Recently Viewed Products Results",                    
                            "list_position": i+1,
                            "quantity": 1,
                            "price": "0"   /* Sasikanth CECI-958 GTM Events*/                 
                        }
                        impressiondata.push(itemdata);
                    }       

                    console.log('impressiondata > ' + impressiondata);
                }
                invokeGoogleAnalyticsService('PRODUCT IMPRESSION', {currlocation : location, impressiondetail : impressiondata});                 
            }
        }

    }

   /* @wire(fetchFeaturedLstProducts,{urlParam:window.location.href})
    wireProduct({ error, data }) {
        if (data) {
            console.log('from recently view');
            this.isLoading = false;
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
            this.isLoading = false;
            this.error = error;
            this.lstProduct = undefined;
        }

        
    }*/

    initializeQueue(){
        let i=0;
        console.log('insise initialise>>>>');
        this.queue = [];    //Added by Malhar - 7/12/2020
        if(this.lstProduct.length <= 5){
            this.queueSize = this.lstProduct.length;
            console.log('inside if recent ' , this.queueSize);
        }else if(this.lstProduct.length > 5){
            this.queueSize = 5;
            console.log('inside else if recent ' , this.queueSize);
        }
    
        
        for(i=0;i<this.queueSize;i++){
            console.log('inside for recent ' , this.queueSize);
            //this.queue[i] = this.lstProduct[i];
            this.queue.push(this.lstProduct[i]);
        }
    
    
        console.log('jsondata>>>' +JSON.stringify(this.queue));
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
        let productlstSize = this.lstProduct.size();
        console.log('insise initialise>>>>');
        for(i=0;i<this.queueSize;i++){
            //this.queue[i] = this.lstProduct[i];
            if(productlstSize > i)
            {
            this.queue.push(this.lstProduct[i]);
            }
        }
        console.log('jsondata>>>' +JSON.stringify(this.queue));
    }*/

  // added by Ranadip on 23/12/2020
   handleClickShopAll(){
    invokeGoogleAnalyticsService('NAVIGATE TO RECENTLY VIEWED PRODUCTS PAGE', ' Shop all recently viewed parts');                    
    window.location.href = window.location.origin + communityName + 'recent-products?&store=' + this.currentLanguage;
    
    /*this[NavigationMixin.Navigate]({
        type: 'comm__namedPage',
        attributes: {
            name : 'recentproducts__c',
            
        },
        state: {
            '&store' : this.currentLanguage
        }
        },
    true 
    );*/
   }// end here

  
    handleClick(event){
        //window.console.log('Event Firing..... ');
        //alert("getSelectedRows => ", this.template.querySelector('lightning-datatable').getSelectedRows());
        // let recordId = {
        //     "recordId" : event.target.dataset.id
        // }
        //  //event.target.style.background = 'red';
        //  let ff = event.target.textContent;
        // console.log(event.target.dataset);
        console.log(event.target.dataset.id);
        // event.preventDefault();
        // pubsub.fire('simplevt', recordId );
        // window.console.log('Event Fired ');
        // return false;
        console.log('Just Going to navigate');
        //New Logic on 15th July
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
    //NAVIGATION END HERE
    //End of the logic 15th July

    }

    // connectedCallback(){
    //     this.regiser();
    // }
    // regiser(){
    //     window.console.log('event registered ');
    //     //alert('event registered');
    //     pubsub.register('searchevt', this.handleEvent.bind(this));
    //     window.console.log('after event registered in the lstProducts');
    // }
    // //this method is working as handler for
    // handleEvent(event){
    //     window.console.log('event handled 123',event);
    //     //this.recordId = event ? JSON.stringify(event, null, '\t') : 'no message payload';
    //     //this.recordId = messageFromEvt ? messageFromEvt.recordId : 'no message payload';
    //     //this.recordId = messageFromEvt.recordId;
    //     //alert('List assigned'+event);
    //     var myJSON = JSON.stringify(event);
    //     this.lstProduct = event;
    //     //alert('myJSON After List assigned'+myJSON);
    //     window.console.log('333333this.lstProducth>>>>>>>>>',this.lstProduct);
    //     //window.console.log('event handled this.lstProduct',this.lstSearchProduct);
    //     this.isShowSearch = true;
    //     window.console.log('isShowSearch>>>>>>>>>',this.isShowSearch);
    // }

    
    // /*constructor(){
    //     alert('In the constructor'+window.location.href);
    // }*/
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

                            //var itemToPop=this.queue[0];
                            //console.log('itemToPop>>'+JSON.stringify(itemToPop));
                            //console.log('this.queue[0] itemToPop>>'+JSON.stringify(this.queue[0]));
                            //console.log('this.queue[1] itemToPop>>'+JSON.stringify(this.queue[1]));
                            //console.log('this.queue[2] itemToPop>>'+JSON.stringify(this.queue[2]));

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

        /*Added by Malhar for passing store language to PDP page - begin - 25/11/2020 */
        console.log('next button lstRecentviewprod this.currentLanguage > ' + this.currentLanguage);
        //pubsub.fire('sendDataTolstProdDetailspage', this.currentLanguage);            
        this.isRendered = false;
        console.log('this.isRendered lstRecentviewprod next > ' + this.isRendered );
        console.log('currentLocation in  lstRecentviewprod next > ' + this.currentLocation);
        /*Added by Malhar for passing store language to PDP page - end - 25/11/2020 */   
                        
    } 
              

            handleClickPrev() {
            console.log('Previousitems in queue>>>>'+JSON.stringify(this.queue));
            console.log('Previouslast items in queue>>>>'+JSON.stringify(this.queue[this.queueSize - 1]));
            console.log('Previous items in lstProduct>>>>'+JSON.stringify(this.lstProduct[this.queueSize ]));
                        if(this.queue[0]!=this.lstProduct[0])
                        {
                            var itemIndex = this.lstProduct.indexOf(this.queue[0]);//commented by shriram
                            //var itemIndex = this.lstProduct.indexOf(0);//added by shriram
                            console.log('PreviousitemIndex>>'+itemIndex);
                            console.log('PreviouslstProdLnght>>'+this.lstProduct.length);

                            //if(itemIndex != this.lstProduct.length -1)//commented by shriram
                            //if(true)//added by shriram itemIndex != 0
                            //{
                              //var itemToPush = this.lstProduct[itemIndex+ 1]; //commented by shriram as below line
                              var itemToPush = this.lstProduct[itemIndex - 1];//added by shriram
                              console.log('PreviousitemToPush>>'+JSON.stringify(itemToPush));

                              //var itemToPop=this.queue[this.queueSize-1];
                              //console.log('PreviousitemToPop>>'+JSON.stringify(itemToPop));
                              //console.log('Previousthis.queue[0] itemToPop>>'+JSON.stringify(this.queue[0]));
                              //console.log('Previousthis.queue[1] itemToPop>>'+JSON.stringify(this.queue[1]));
                              //console.log('Previousthis.queue[2] itemToPop>>'+JSON.stringify(this.queue[2]));

                              this.queue.splice(this.queueSize - 1, 1);
                              console.log('Previousqueue after pop>>'+JSON.stringify(this.queue));
                              //this.queue.push(itemToPush);
                              //this.queue.splice(this.queueSize - 1,0, itemToPush);//commented by shriram as below line
                              this.queue.splice(0,0, itemToPush);//added by shriram
                              console.log('Previousqueue after push>>'+JSON.stringify(this.queue));
                            
                           
                          
                        }
                        else{
                            var itemToPush = this.lstProduct[this.lstProduct.length - 1];
                            console.log('PreviousitemToPush>>'+itemToPush);
                            var itemToPop=this.queue[0];
                            console.log('PreviousitemToPop>>'+itemToPop);
                            //this.queue.pop(itemToPop);
                            //this.queue.splice(0, 1);commented by shriram due to below line
                            this.queue.splice(this.queueSize - 1, 1);//Added by shriram 
                            console.log('Previous2nd Else queue after pop>>'+JSON.stringify(this.queue));
                            //this.queue.push(itemToPush);
                            this.queue.splice(0,0, itemToPush);
                            console.log('Previous2nd Else  queue after push>>'+JSON.stringify(this.queue));
                            
                        }

                /*Added by Malhar for passing store language to PDP page - begin - 25/11/2020 */
                console.log('prev button lstRecentviewprod this.currentLanguage > ' + this.currentLanguage);
                //pubsub.fire('sendDataTolstProdDetailspage', this.currentLanguage);            
                this.isRendered = false;
                console.log('this.isRendered lstRecentviewprod prev > ' + this.isRendered );
                console.log('currentLocation in  lstRecentviewprod prev > ' + this.currentLocation);
                /*Added by Malhar for passing store language to PDP page - end - 25/11/2020 */                          
            } 
}