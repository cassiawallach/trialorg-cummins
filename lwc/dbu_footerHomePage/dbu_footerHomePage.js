import { LightningElement,track } from 'lwc';
import dbu_home_footer_contactUs from '@salesforce/label/c.dbu_home_footer_contactUs';
import dbu_home_footer_resources from '@salesforce/label/c.dbu_home_footer_resources';
import dbu_home_footer_specialOffers from '@salesforce/label/c.dbu_home_footer_specialOffers';
export default class Dbu_footerHomePage extends LightningElement {
    
    @track contactmsg;
    @track resourcemsg;
    @track spcloffermsg;
    connectedCallback(){
        this.contactmsg= dbu_home_footer_contactUs;
        this.resourcemsg= dbu_home_footer_resources;
        this.spcloffermsg = dbu_home_footer_specialOffers;
    }
}