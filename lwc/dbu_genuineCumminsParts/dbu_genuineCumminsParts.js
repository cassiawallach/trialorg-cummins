import { LightningElement, wire,track,api } from 'lwc';
import pubsub from 'c/pubsub';
import { NavigationMixin } from 'lightning/navigation';
import myResource from '@salesforce/resourceUrl/cloudMVP';
import dbu_home_carousel_genuineCumminsParts from '@salesforce/label/c.dbu_home_carousel_genuineCumminsParts';
import dbu_home_carousel_shopAllGenuineCumminsParts from '@salesforce/label/c.dbu_home_carousel_shopAllGenuineCumminsParts';
import fetchGenuineCumminsParts from '@salesforce/apex/dbu_ProductCtrl.fetchGenuineCumminsParts';
import fetchCategoryID from '@salesforce/apex/dbu_ProductCtrl.fetchCategoryID';
import communityName from '@salesforce/label/c.dbu_communityName';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';//custom label refres to'CA'
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import { getCoreChargeList } from 'c/serviceComponent';
export default class Dbu_genuineCumminsParts extends NavigationMixin(LightningElement) {
    leftArrow = myResource+'/images/dbu_LeftArrow.png';
    rightArrow = myResource+'/images/dbu_RightArrow.png';
    @track queue = [];
    @track queueSize = 5;
    @track productListSize = 0;
    @track lstProduct;
    @track lstSearchProduct;
    @track isShowSearch = false;
    @track isLoading = true;
    @track currentprom;
    @track shopall;
    @track categoryID;
    @track listnametosend = 'Genuine Cummins Parts Results';
    
    //variable by Malhar for storing the user selected store location - 19/11/2020
    @track currentLocation;     
    @track currentLanguage = storeUSA;
    @track corePrice;
    @track mostPopularList;
    get ScreenLoaded()
    {
        return this.isLoading;
    }
    
    connectedCallback(){
        this.currentprom = dbu_home_carousel_genuineCumminsParts;
        this.shopall=dbu_home_carousel_shopAllGenuineCumminsParts;
        /*Added by Malhar for retriving store location begin - 19/11/2020 */
          
            let queryString = window.location.search;
            let urlParams = new URLSearchParams(queryString);
            //this.currentLocation = urlParams.get('store');
            console.log('sessin value in GCP' +window.sessionStorage.getItem('setCountryCode'));
            this.currentLocation = window.sessionStorage.getItem('setCountryCode');
            console.log('connected callback genuine parts curr locatn before  > ' + JSON.stringify(this.currentLocation));
            console.log('connected callback genuine parts curr lang before  > ' + JSON.stringify(this.currentLanguage));
            if(this.currentLocation == null){
                this.currentLocation = storeUSA;    
            }else if(this.currentLocation == storeCA){
                this.currentLocation = storeCanada;
                this.currentLanguage = storeCA;
            }else if(this.currentLocation == storeCAF){
                this.currentLocation = storeCanada;
                this.currentLanguage = storeCAF;
            }
            console.log('connected callback genuine parts curr locatn after > ' + JSON.stringify(this.currentLocation));
            console.log('connected callback genuine parts curr lang before  > ' + JSON.stringify(this.currentLanguage));
            this.register();
         
        /*Added by Malhar for retriving store location End - 19/11/2020 */

    }

    /*Methods by Malhar for handling the geniunPartsLocationChange event fire begin - 19/11/2020 */

    register() {
        window.console.log('geniunPartsLocationChange event registered ');
        pubsub.register('geniunPartsLocationChange', this.handleLocationChangeEvent.bind(this)); 
        pubsub.register('geniunPartsCurrentLanguage', this.handleLanguageChangeEvent.bind(this));                       
    }    

    handleLocationChangeEvent(event) {
        console.log('hickup > ' + JSON.stringify(event));
        //console.log('hickup plain > ' + event);
        this.currentLocation = event;
    }  
    
    handleLanguageChangeEvent(event){
        console.log('genuine part lang chage event > ' + JSON.stringify(event));
        this.currentLanguage = event;
    }
    
    /*Methods by Malhar for handling the geniunPartsLocationChange event fire end - 19/11/2020 */

//urlParam:window.location.href
    @wire(fetchGenuineCumminsParts,{locationCode: '$currentLocation'})
    wireProduct({ error, data }) {
        if (data) {
            this.isLoading = false;
            window.console.log('data>>>>>>>>>> GenuineParts', data);
            this.lstProduct = JSON.parse(JSON.stringify(data.productData)); 
            this.mostPopularList= JSON.parse(JSON.stringify(this.lstProduct));
            this.corePrice = data.corePrice;
            this.error = undefined;
            /* Sasikanth CECI-958 GTM Events Start*/
            var brandProductMap = new Map(); 
            var categoryProductMap = new Map();
            var brandData = data.branddata;
            var categoryData = data.categorydata;
            let brandKey = Object.keys(brandData);
            let brandVal = Object.values(brandData);
            let categoryKey = Object.keys(categoryData);
            let categoryVal = Object.values(categoryData);
            for(let k= 0; k < brandKey.length; k++)
                brandProductMap.set(brandKey[k],brandVal[k]);
            for(let t= 0; t < categoryKey.length; t++)
                categoryProductMap.set(categoryKey[t],categoryVal[t]);
                /* Sasikanth CECI-958 GTM Events End*/
            console.log('GenuineParts productList', JSON.parse(JSON.stringify(this.lstProduct)));
            this.size = this.lstProduct.length;
            if(Object.keys(this.corePrice).length != 0)
                this.lstProduct = getCoreChargeList(this.mostPopularList, this.corePrice);
            this.productListSize = this.lstProduct.length;
            /* Sasikanth CECI-958 GTM Events Start*/
            for(let j=0; j<this.lstProduct.length; j++){
                this.lstProduct[j].brand = brandProductMap.get(this.lstProduct[j].Id);
                this.lstProduct[j].category = categoryProductMap.get(this.lstProduct[j].Id);
            }
            /* Sasikanth CECI-958 GTM Events End*/
            console.log('size>>' +this.size);
            this.max = this.size -1;
            this.frameProductImpressiondata(JSON.parse(JSON.stringify(this.lstProduct)), this.currentLanguage);
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
                    if(promodata[i].ccrz__E_PriceListItems__r != undefined && promodata[i].ccrz__E_PriceListItems__r != null){
                        if(promodata[i].ccrz__E_PriceListItems__r.length > 0 ){
                            let pr = 0;                        
                            if(promodata[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c != undefined){
                                pr = promodata[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                            }                        
                            let itemdata = {
                                "id": promodata[i].ccrz__SKU__c, /* Sasikanth CECI-958 GTM Events*/
                                "name": promodata[i].Name,
                                "list": "Genuine Cummins Parts",                    
                                "position": i+1,
                                "price": JSON.stringify(pr)   /* Sasikanth CECI-958 GTM Events*/              
                            }                        
                            impressiondata.push(itemdata);
                        }else{
                            let itemdata = {
                                "id": promodata[i].ccrz__SKU__c, /* Sasikanth CECI-958 GTM Events*/
                                "name": promodata[i].Name,
                                "list": "Genuine Cummins Parts",                    
                                "position": i+1,                            
                                "price": "0"     /* Sasikanth CECI-958 GTM Events*/              
                            }
                            impressiondata.push(itemdata);
                        }
                    }else{
                        let itemdata = {
                            "id": promodata[i].ccrz__SKU__c, /* Sasikanth CECI-958 GTM Events*/
                            "name": promodata[i].Name,
                            "list": "Genuine Cummins Parts",                    
                            "position": i+1,                            
                            "price": "0"               /* Sasikanth CECI-958 GTM Events*/    
                        }
                        impressiondata.push(itemdata);
                    }              

                    console.log('impressiondata > ' + impressiondata);
                }
                invokeGoogleAnalyticsService('PRODUCT IMPRESSION', {currlocation : location, impressiondetail : impressiondata});                 
            }
        }

    }

    @wire(fetchCategoryID)
    wiredfetchCategoryID({
        error,
        data
    }) {
        if (data) {
            if(data != undefined || data != null){
                console.log(';data' +data)
                this.categoryID = data;
            }
        }else if (error) {
            this.error = error;
        }
    }

    /* Added by Malhar for setting store value begin - 25/11/2020 */
    @track isRendered = false;
    renderedCallback() {
        if (this.isRendered)
            return;
        this.isRendered = true;
        console.log('cummins Genuine parts ->> before fire sendDataTolstProdDetailspage event >>' + this.currentLanguage);
        pubsub.fire('sendDataTolstProdDetailspage', this.currentLanguage);
        console.log('cummins Genuine parts ->> after fire sendDataTolstProdDetailspage event >>' + this.currentLanguage);
    }
    /* Added by Malhar for setting store value end - 25/11/2020 */    


    
    initializeQueue(){
        let i=0;
        this.queue = []; // Malhar - Queue reset
        console.log('insise initialise>>>>');
        for(i=0;i<this.queueSize;i++){
            //this.queue[i] = this.lstProduct[i];
            this.queue.push(this.lstProduct[i]);
        }

        console.log('jsondata>>>' +JSON.stringify(this.queue));

    }

    // handleClick(event){
    //     this[NavigationMixin.Navigate]({
    //         type: 'comm__namedPage',
    //         attributes: {
    //             name : 'dbu_product__c'
    //         },
    //         state: {
    //             'pId': event.target.dataset.id  //event.target.dataset.id
    //         }
    //         },
    //     true // Replaces the current page in your browser history with the URL
    //     );

    // }

    get handleClick(){
        let urlString = window.location.origin;
        
        return urlString+communityName+'categories/' + this.categoryID + '/' + 'cummins-genuine-parts'+'/?store='+this.currentLanguage;
            // return urlString+communityName+'categories' + '?id=' + this.categoryID + '&store=' + this.currentLocation;
      
    }

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
                            console.log('next button genuine parts this.currentLanguage > ' + this.currentLanguage);
                            //pubsub.fire('sendDataTolstProdDetailspage', this.currentLanguage);            
                            this.isRendered = false;
                            console.log('this.isRendered  genuine partsnext > ' + this.isRendered );
                            console.log('currentLocation in genuine parts next > ' + this.currentLocation);
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
                            console.log('prev button genuine parts this.currentLanguage > ' + this.currentLanguage);
                            //pubsub.fire('sendDataTolstProdDetailspage', this.currentLanguage);            
                            this.isRendered = false;
                            console.log('this.isRendered  genuine parts prev > ' + this.isRendered );
                            console.log('currentLocation in genuine parts prev > ' + this.currentLocation);
                            /*Added by Malhar for passing store language to PDP page - end - 25/11/2020 */ 
                        
            } 
}