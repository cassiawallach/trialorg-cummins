import { LightningElement,api } from 'lwc';
//import svgLogos from "@salesforce/resourceUrl/cspsvgIcons";
export default class fSL_CSSP_serviceTab extends LightningElement {
    @api CurrentcheckoutStepHeader;
   // logoImg = svgLogos + "/SVG/CumminslogoBLACK.svg";
    get stepName()
    {
        return this.CurrentcheckoutStepHeader;  
    }
    handleClick() {
        let urlString = window.location.origin;
        
        window.location.href =urlString+"/"+"cumminsserviceportal"+"/s";
       // window.location.reload();
      }
}