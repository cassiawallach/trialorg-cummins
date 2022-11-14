import { LightningElement, api,track } from 'lwc';
import myResource from '@salesforce/resourceUrl/cloudMVP';
import { NavigationMixin } from 'lightning/navigation';

export default class Dbu_searchProduct extends NavigationMixin(LightningElement) {
    @api product=[];
    imageUrl = myResource;
    @track productRating=0;
    @track sorteddata;

    connectedCallback(){
        this.imageUrl = myResource +'/images/'+ this.product.dbu_Image_Src__c;
        this.productRating = (this.product.ccrz__AverageRating__c).toFixed(1);
    }


    handleClick(event){//Commented by Shriram

        this[NavigationMixin.Navigate]({
            //type: 'comm__namedPage',
            type:'standard__namedPage',
            attributes: {
                name : 'dbu_product__c'
            },
            state: {
                'pId': this.product.Id  //event.target.dataset.id
                
            }
            },
        true // Replaces the current page in your browser history with the URL
        );
        
        console.log('pIdinlstproductdetails====================================================================================>'+this.product.Id);
    }
}