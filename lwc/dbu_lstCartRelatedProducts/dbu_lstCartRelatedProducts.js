import { LightningElement, wire, track, api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import myResource from '@salesforce/resourceUrl/cloudMVP';
import fetchrelatedproducts from '@salesforce/apex/dbu_ProductCtrl.fetchrelatedproducts';
import pubsub from 'c/pubsub';
import getRelatedProductList from '@salesforce/apex/dbu_ccApiRelatedProduct.getRelatedProductList';
import relatedProductsSize from '@salesforce/label/c.dbu_relatedProductsSize';
import dbu_Productsrelatedtotheitemyouareviewing from '@salesforce/label/c.dbu_Products_related_to_the_item_you_are_viewing';

export default class dbu_lstCartRelatedProducts extends NavigationMixin(LightningElement) {

  leftArrow = myResource + '/images/dbu_LeftArrow.png';
  rightArrow = myResource + '/images/dbu_RightArrow.png';
  @track queue = [];
  //@track queueSize;
  @track queueSize ;
  @track productListSize = 0;
  @track relatedProducts = [];
  @track isLoading = true;
  @track flag =false;
  @track sizeOfRelatedProducts = relatedProductsSize;
  label = {
    dbu_Productsrelatedtotheitemyouareviewing
}

  @wire(getRelatedProductList,{urlParam:window.location.href})
    wireProduct({ error, data }) {
        if (data) {
            //this.isLoading = false;
           window.console.log('SPdata>>>>>>>>>>', JSON.stringify( data));
           for(let i =0; i<data.length; i++){
              if(data[i].productType == 'Related'){
              this.relatedProducts.push(data[i]);
             }
           }
            this.size = this.relatedProducts.length;
            this.productListSize = this.relatedProducts.length;
            console.log('size>>' +this.size);
            this.max = this.size -1;
            this.queueSize = this.relatedProducts.length;
            if(this.relatedProducts.length  == 0 || this.relatedProducts.length == undefined){
              this.flag = true;
             }else{
              this.initializeQueue(); 
             }
        } else if (error) {
            this.isLoading = false;
            this.error = error;
            this.relatedProducts = undefined;
            console.log('Inside Error in related products>');
        }
      }

  initializeQueue(){
    let i=0;
    console.log('insise initialise>>>>');  
    if(this.relatedProducts <= this.sizeOfRelatedProducts){
        this.queueSize = this.relatedProducts;
        console.log('inside if recent ' , this.queueSize);
    }else if(this.relatedProducts.length > this.sizeOfRelatedProducts){
        this.queueSize = this.sizeOfRelatedProducts;
        console.log('inside else if recent ' , this.queueSize);
    }   
    for(i=0;i<this.queueSize;i++){
        console.log('inside for recent ' , this.queueSize);
        this.queue.push(this.relatedProducts[i]);
    }
    console.log('jsondata>>>' +JSON.stringify(this.queue));
}



  handleClick(event) {
    // this[NavigationMixin.Navigate]({
    //     type: 'comm__namedPage',
    //     attributes: {
    //         name : 'dbu_product__c'
    //     },
    //     state: {
    //         'pId': event.target.dataset.id  //event.target.dataset.id
    //     }
    //     },
    // true // Replaces the current page in your browser history with the URL
    // );
    console.log('Going to fire event' + event.target.dataset.id);
    pubsub.fire('laodrelatedprodbyidevt', event.target.dataset.id);

  }
  

  handleClickNext() {
    console.log('items in queue>>>>'+JSON.stringify(this.queue));
    console.log('last items in queue>>>>'+JSON.stringify(this.queue[this.queueSize - 1]));
    console.log('4th items in similarProducts>>>>'+JSON.stringify(this.relatedProducts[this.queueSize ]));
                    if(this.queue[this.queueSize - 1]!=this.relatedProducts[this.productListSize - 1])
                    {
                      var itemIndex = this.relatedProducts.indexOf(this.queue[this.queueSize - 1]);
                      console.log('itemIndex>>'+itemIndex);
                      if(itemIndex != this.relatedProducts.length)
                      {
                        var itemToPush = this.relatedProducts[itemIndex + 1];
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
                        var itemToPush = this.relatedProducts[0];
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
                        var itemToPush = this.relatedProducts[0];
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
        console.log('Previous items in lstProduct>>>>'+JSON.stringify(this.relatedProducts[this.queueSize ]));
                    if(this.queue[0]!=this.relatedProducts[0])
                    {
                        var itemIndex = this.relatedProducts.indexOf(this.queue[0]);//commented by shriram
                        //var itemIndex = this.lstProduct.indexOf(0);//added by shriram
                        console.log('PreviousitemIndex>>'+itemIndex);
                        console.log('PreviouslstProdLnght>>'+this.relatedProducts.length);

                        //if(itemIndex != this.lstProduct.length -1)//commented by shriram
                        //if(true)//added by shriram itemIndex != 0
                        //{
                          //var itemToPush = this.lstProduct[itemIndex+ 1]; //commented by shriram as below line
                          var itemToPush = this.relatedProducts[itemIndex - 1];//added by shriram
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
                        var itemToPush = this.relatedProducts[this.relatedProducts.length - 1];
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