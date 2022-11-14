import { LightningElement,track } from 'lwc';
import myResource from '@salesforce/resourceUrl/cloudMVP';
import { NavigationMixin } from 'lightning/navigation';

export default class Dbu_footerSecureShoppig extends NavigationMixin (LightningElement) {
    @track URL = "";
    secureShopping = myResource+'/images/SecureShopping.png';
}