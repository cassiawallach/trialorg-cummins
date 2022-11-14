import {
    api,
    track,
    LightningElement
} from 'lwc';
import communityName from '@salesforce/label/c.dbu_communityName';

export default class Dbu_productBreadCrumb extends LightningElement {
    @api subcategory;
    @track pageURL;

    connectedCallback() {
        console.log('Dbu_productBreadCrumb =>subcategory=>' + JSON.stringify(this.subcategory));
        let urlString = window.location.origin;
        
        this.pageURL = urlString + communityName + 'categories/' + this.subcategory.Id + '/' + this.subcategory.Name;
        //this.pageURL = urlString + communityName + this.subcategory.dbu_Community_Page_Name__c;
    }
}