import { LightningElement, track } from 'lwc';
import dbu_home_footer_customerService from '@salesforce/label/c.dbu_home_footer_customerService';
import dbu_home_footer_resources from '@salesforce/label/c.dbu_home_footer_resources';
import dbu_home_footer_specialOffers from '@salesforce/label/c.dbu_home_footer_specialOffers';



export default class Cm_homePageFtrRbnTile extends LightningElement {
    @track customerService = dbu_home_footer_customerService;
    @track resources = dbu_home_footer_resources;
    @track specialOffers = dbu_home_footer_specialOffers;
}