import { LightningElement, wire,track,api } from 'lwc';
import pubsub from 'c/pubsub' ; 
import fetchFeaturedLstProducts from '@salesforce/apex/dbu_ProductCtrl.fetchFeaturedLstProducts';
export default class dbu_lstRecentlyPurchasedProducts extends LightningElement {
    @track lstProduct;
    @track lstSearchProduct;
    @track isShowSearch = false;
    @wire(fetchFeaturedLstProducts,{urlParam:window.location.href})
    wireProduct({ error, data }) {
        if (data) {
            //alert('In the constructor'+window.location.href);
            window.console.log('data>>>>>>>>>>', data);
            this.lstProduct = data;
            this.error = undefined;
            window.console.log('data>>>>>>>>>>', this.lstProduct);
        } else if (error) {
            this.error = error;
            this.lstProduct = undefined;
        }
    }
    columns = [
         { label: 'Products', fieldName: 'Name',
        sortable: true }
    
        /*{label: 'Product Name', fieldName: 'Name', type: 'url', 
        typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}}*/
    ];

    handleClick(event){
        window.console.log('Event Firing..... ');
       
        //alert("getSelectedRows => ", this.template.querySelector('lightning-datatable').getSelectedRows());
        let recordId = {
            "recordId" : event.target.dataset.id
        }
        
         //event.target.style.background = 'red';
         let ff = event.target.textContent;
            
        console.log(event.target.dataset);
        console.log(event.target.dataset.id);
        event.preventDefault();
        pubsub.fire('simplevt', recordId );
        window.console.log('Event Fired ');
        return false;
    }

    connectedCallback(){
        this.regiser();
    }
    regiser(){
        window.console.log('event registered ');
        //alert('event registered');
        pubsub.register('searchevt', this.handleEvent.bind(this));
        window.console.log('after event registered in the lstProducts');
    }
    //this method is working as handler for
    handleEvent(event){
        window.console.log('event handled 123',event);
        //this.recordId = event ? JSON.stringify(event, null, '\t') : 'no message payload';
        //this.recordId = messageFromEvt ? messageFromEvt.recordId : 'no message payload';
        //this.recordId = messageFromEvt.recordId;
        //alert('List assigned'+event);
        var myJSON = JSON.stringify(event);
        this.lstProduct = event;
        //alert('myJSON After List assigned'+myJSON);
        window.console.log('333333this.lstProducth>>>>>>>>>',this.lstProduct);
        //window.console.log('event handled this.lstProduct',this.lstSearchProduct);
        this.isShowSearch = true;
        window.console.log('isShowSearch>>>>>>>>>',this.isShowSearch);
    }

    
    /*constructor(){
        alert('In the constructor'+window.location.href);
    }*/
}