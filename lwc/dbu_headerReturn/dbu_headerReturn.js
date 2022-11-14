import { LightningElement, api, track } from 'lwc';

export default class Dbu_headerReturn extends LightningElement {

    @api CurrentreturnStepHeader;
   
    get stepName()
    {
        return this.CurrentreturnStepHeader;  
    }
}