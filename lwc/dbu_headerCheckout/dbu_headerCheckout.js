import { LightningElement, api, track } from 'lwc';

export default class Dbu_headerCheckout extends LightningElement {

    @api CurrentcheckoutStepHeader;
   
    get stepName()
    {
        return this.CurrentcheckoutStepHeader;  
    }
}