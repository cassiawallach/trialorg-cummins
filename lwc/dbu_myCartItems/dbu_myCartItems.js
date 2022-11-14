import { LightningElement, track, api, wire } from 'lwc';
import getCartItems from '@salesforce/apex/dbu_myCartItems.getMyCartItems';
import pubsub from 'c/pubsub';

export default class Dbu_myCartItems extends LightningElement {
    @track hasResults;
    @track size;
    @track cartitemslist;
    @wire(getCartItems)
    wiredCompetitorsMethod({ error, data }) {
        if (data) {
            this.cartitemslist = data;
            console.log('dataL' + JSON.stringify(data));
            this.error = undefined;
            this.hasResults = true;
            let message = {
                "message" : this.cartitemslist.size
            }
            pubsub.fire('cartCount', message);
        } else if (error) {
            this.cartitemslist = undefined;
            this.error = error;
            this.hasResults = false;
        }
    }
}