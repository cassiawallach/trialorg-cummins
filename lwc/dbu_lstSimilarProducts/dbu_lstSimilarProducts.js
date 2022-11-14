import { LightningElement, wire,track,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import myResource from '@salesforce/resourceUrl/cloudMVP';
import pubsub from 'c/pubsub';
import fetchsimilarproducts from '@salesforce/apex/dbu_ProductCtrl.fetchsimilarproducts';
import getRelatedProductList from '@salesforce/apex/dbu_ccApiRelatedProduct.getRelatedProductList';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import communityName from '@salesforce/label/c.dbu_communityName';
export default class dbu_lstSimilarProducts extends NavigationMixin(LightningElement) {
   
    leftArrow = myResource+'/images/dbu_LeftArrow.png';
    rightArrow = myResource+'/images/dbu_RightArrow.png';
    @track queue = [];
    @track queueSize ;
    @track productListSize = 0;
    @track similarProducts = [];
    @track isLoading = true;
    @track flag =false;
    @track productURL;
    @track currentLocation;
    @track productId;
    @track communityname;
    @track listnametosend;

    get ScreenLoaded()
    {
        return this.isLoading;
    }
    connectedCallback(){
      this.communityname = communityName;
      let urlString = window.location.origin;
      this.currentLocation = window.sessionStorage.getItem('setCountryCode');
      let url = window.location.pathname;
      let splitpath = url.split('/');  
      this.productId = splitpath[4];
      this.productURL = urlString + communityName + 'product?name=Name&pId=' + this.productId + '&store='+this.currentLocation;
      console.log('this.productURL from similer ' ,this.productURL);
      if(this.productURL != undefined){
        this.fetchProduct();
      }
    }
    fetchProduct(){
      getRelatedProductList({ urlParam: this.productURL })
            .then((data) => {
              if (data) {
                //this.isLoading = false;
    
               window.console.log('SPdata>>>>>>>>>>', JSON.stringify( data));
               for(let i =0; i<data.length; i++){
                if(data[i].productType == 'CrossSell'){
                this.similarProducts.push(data[i]);
              }
               }
               
                //this.similarProducts = data;
                //console.log('this.similarProducts ', this.similarProducts[0].id);
                //this.error = undefined;
                //console.log('SPdataList>>>>>>>>>>', JSON.stringify( this.similarProducts));
                this.size = this.similarProducts.length;
                this.productListSize = this.similarProducts.length;
                console.log('size>>' +this.size);
                this.max = this.size -1;
                this.queueSize = this.similarProducts.length;
                if(this.similarProducts.length  == 0 || this.similarProducts.length == undefined){
                  this.flag = true;
                  console.log('insid if');
                 }else{
                  console.log('insid else');
                  this.initializeQueue(); 
                 }
                //this.initializeQueue();
                this.googleanalyticsFeed(data, this.currentLocation);
            } else if (error) {
                this.isLoading = false;
                this.error = error;
                this.similarProducts = undefined;
                //this.googleanalyticsFeed(this.similarProducts);
                console.log('Inside Error in related products>');
            }
            })
            .catch((error) => {
                this.error = error;
                console.log('this.error ' ,this.error);
            });
    }

    googleanalyticsFeed(crossellData, location){
      let locationURL = window.location.href;
      console.log('locationURL' + locationURL);
      var url = new URL(locationURL);
      //let UrlproductName = url.searchParams.get("name");       
      //console.log('UrlproductName > ' + UrlproductName);
      this.listnametosend = "CrossSell Product list";
      invokeGoogleAnalyticsService('CROSSSELL PRODUCTS ON PDP PAGE', {mainProduct : '', locationd : location, crossellFeed : crossellData});

    }


   /* @wire(getRelatedProductList,{urlParam:this.productURL})

    wireProduct({ error, data }) {
      alert('in wire');
        if (data) {
            //this.isLoading = false;

           window.console.log('SPdata>>>>>>>>>>', JSON.stringify( data));
           for(let i =0; i<data.length; i++){
            if(data[i].productType == 'CrossSell'){
            this.similarProducts.push(data[i]);
          }
           }
           
            //this.similarProducts = data;
            //console.log('this.similarProducts ', this.similarProducts[0].id);
            //this.error = undefined;
            //console.log('SPdataList>>>>>>>>>>', JSON.stringify( this.similarProducts));
            this.size = this.similarProducts.length;
            this.productListSize = this.similarProducts.length;
            console.log('size>>' +this.size);
            this.max = this.size -1;
            this.queueSize = this.similarProducts.length;
            if(this.similarProducts.length  == 0 || this.similarProducts.length == undefined){
              this.flag = true;
              console.log('insid if');
             }else{
              console.log('insid else');
              this.initializeQueue(); 
             }
            //this.initializeQueue();
            this.googleanalyticsFeed(data);
        } else if (error) {
            this.isLoading = false;
            this.error = error;
            this.similarProducts = undefined;
            this.googleanalyticsFeed(this.similarProducts);
            console.log('Inside Error in related products>');
        }
      }*/
    
    //initializeQueue(){
      //  let i=0;
        //console.log('insise initialise>>>>');
        //for(i=0;i<this.queueSize;i++){
            //this.queue[i] = this.lstProduct[i];
          //  this.queue.push(this.similarProducts[i]);
        //}

        //console.log('SimilarProductData>>>' +JSON.stringify(this.queue));

    //}
    /*initializeQueue() {
        let i = 0;
        //let productlstSize = this.lstProduct.size();
        console.log('insise initialise>>>>');
        for (i = 0; i < this.queueSize; i++) {
          //this.queue[i] = this.similarProducts[i];
          //if (productlstSize > i) {
            this.queue.push(this.similarProducts[i]);
          //}
        }
    
        console.log('jsondata>>>' + JSON.stringify(this.queue));
    
      }*/
    initializeQueue(){
        let i=0;
        console.log('insise initialise>>>>');
        if(this.similarProducts <= 5){
            this.queueSize = this.similarProducts;
            console.log('inside if recent ' , this.queueSize);
        }else if(this.similarProducts.length > 5){
            this.queueSize = 5;
            console.log('inside else if recent ' , this.queueSize);
        }
        for(i=0;i<this.queueSize;i++){
            console.log('inside for recent ' , this.queueSize);
            //this.queue[i] = this.lstProduct[i];
            this.queue.push(this.similarProducts[i]);
        }

        console.log('jsondata>>>' +JSON.stringify(this.queue));

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
        /*console.log('Going to fire event' + event.target.dataset.id);
        pubsub.fire('laodrelatedprodbyidevt', event.target.dataset.id); */
        

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
                console.log('items in queue>>>>'+JSON.stringify(this.queue));
                console.log('last items in queue>>>>'+JSON.stringify(this.queue[this.queueSize - 1]));
                console.log('4th items in similarProducts>>>>'+JSON.stringify(this.similarProducts[this.queueSize ]));
                                if(this.queue[this.queueSize - 1]!=this.similarProducts[this.productListSize - 1])
                                {
                                  var itemIndex = this.similarProducts.indexOf(this.queue[this.queueSize - 1]);
                                  console.log('itemIndex>>'+itemIndex);
                                  if(itemIndex != this.similarProducts.length)
                                  {
                                    var itemToPush = this.similarProducts[itemIndex + 1];
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
                                    var itemToPush = this.similarProducts[0];
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
                                    var itemToPush = this.similarProducts[0];
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
                      
        
                    handleClickPrev() {
                    console.log('Previousitems in queue>>>>'+JSON.stringify(this.queue));
                    console.log('Previouslast items in queue>>>>'+JSON.stringify(this.queue[this.queueSize - 1]));
                    console.log('Previous items in lstProduct>>>>'+JSON.stringify(this.similarProducts[this.queueSize ]));
                                if(this.queue[0]!=this.similarProducts[0])
                                {
                                    var itemIndex = this.similarProducts.indexOf(this.queue[0]);//commented by shriram
                                    //var itemIndex = this.lstProduct.indexOf(0);//added by shriram
                                    console.log('PreviousitemIndex>>'+itemIndex);
                                    console.log('PreviouslstProdLnght>>'+this.similarProducts.length);
        
                                    //if(itemIndex != this.lstProduct.length -1)//commented by shriram
                                    //if(true)//added by shriram itemIndex != 0
                                    //{
                                      //var itemToPush = this.lstProduct[itemIndex+ 1]; //commented by shriram as below line
                                      var itemToPush = this.similarProducts[itemIndex - 1];//added by shriram
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
                                    var itemToPush = this.similarProducts[this.similarProducts.length - 1];
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
                    } 
            
            
         
}