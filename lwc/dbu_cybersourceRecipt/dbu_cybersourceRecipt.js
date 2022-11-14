import { LightningElement } from 'lwc';
import communityName from '@salesforce/label/c.dbu_communityName';
export default class Dbu_cybersourceRecipt extends LightningElement {

    connectedCallback() {
        console.log('window.location.href');
        console.log(window.location.href);
        let urlstring = window.location.href;
        console.log(urlstring);

        console.log(urlstring.split('cybersourceredirect?')[1]);
        console.log(communityName);
        let url = window.location.origin + communityName + 'payment-confirmation?' + urlstring.split('cybersourceredirect?')[1];
        window.open(url, '_parent');
        //window.open('https://dbuecomdev-cumminscss.cs24.force.com/CSSNAStore/s/paymentconfirmation', '_parent');
        //window.location.href = 'https://dbuecomdev-cumminscss.cs24.force.com/CSSNAStore/s/paymentconfirmation';
    }   

}