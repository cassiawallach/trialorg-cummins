import { LightningElement,track} from 'lwc';
import pubsub from 'c/pubsub' ; 
import dbu_Sign_Up from '@salesforce/label/c.dbu_Sign_Up';
import dbu_Close from '@salesforce/label/c.dbu_Close';
import dbu_special_offers from '@salesforce/label/c.dbu_special_offers';
import dbu_special_offers_providing from '@salesforce/label/c.dbu_special_offers_providing';
import dbu_special_offers_exclusive from '@salesforce/label/c.dbu_special_offers_exclusive';
import dbu_special_offers_companies from '@salesforce/label/c.dbu_special_offers_companies';
import dbu_home_footer_privacyPolicy from '@salesforce/label/c.dbu_home_footer_privacyPolicy';
import dbu_checkoutPage_Cancel from '@salesforce/label/c.dbu_checkoutPage_Cancel';
 
export default class Dbu_signUpSpecialOffers extends LightningElement {
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
    showUSSpclOffer = true;
    showCASpclOffer = false;

    label={
        dbu_Sign_Up,
        dbu_Close,
        dbu_special_offers,
        dbu_special_offers_providing,
        dbu_special_offers_exclusive,
        dbu_special_offers_companies,
        dbu_home_footer_privacyPolicy,
        dbu_checkoutPage_Cancel
    }
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }
    connectedCallback() {
        this.regiser();
    }
    regiser(){
        window.console.log('event registered ');
        pubsub.register('spclOfferPrvcyPlcy', this.handlespclOfferPrvcyPlcy.bind(this));
    
        
    }
    handlespclOfferPrvcyPlcy(location) {
        
        if(location == 'US'){
            this.showUSSpclOffer = true;
            this.showCASpclOffer = false;
    
        } if(location == 'CA'){
            this.showUSSpclOffer = false;
            this.showCASpclOffer = true;
        }
        
    }
}