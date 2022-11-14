import { LightningElement, wire,track,api } from 'lwc';
import fetchFAQsName from '@salesforce/apex/dbu_footerFAQs.fetchFAQsName';

export default class Dbu_footerFAQs extends LightningElement {


    @track myFAQs;
    @track isLoading = true;
    @track mapData = [];

    get ScreenLoaded() {
        return this.isLoading;
    }


    @wire(fetchFAQsName)
    // @wire(fetchLstCartItemsByCartId,{cartId:'' })
    wireFAQs({ error, data }) {

        if (data) {
            console.log('data of the faqs==================>', data);
            var faqRecords = data; 
            for(var key in faqRecords){
                this.mapData.push({value:faqRecords[key], key:key}); //Here we are creating the array to show on UI.
            }
          //  this.myFAQs = data;
            this.isLoading = false;
        } else if (error) {
            this.error = error; 
        }

        
     }

     
     


     activeSections = ['faq'];
     handleSectionToggle(event) {
         const openSections = event.detail.openSections;
     }



}