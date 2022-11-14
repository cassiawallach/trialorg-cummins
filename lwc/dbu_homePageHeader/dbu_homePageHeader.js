import { LightningElement, track } from 'lwc';
import CumminsLogoWhite from '@salesforce/resourceUrl/dbu_CumminsLogoWhite';
import dbu_contactUs_title from "@salesforce/label/c.dbu_contactUs_title";

export default class DBU_homePageHeader extends LightningElement {

    @track hamburgerMenu=false;
    @track hamburgerMenuClass="hamburgerMenu";
    @track whitelogoImg = CumminsLogoWhite;
    @track contactUsTit = dbu_contactUs_title;

    hamburgerMenuShow(){
        this.hamburgerMenu=true;
        this.hamburgerMenuClass="hamburgerMenu active";
    }
    hamburgerMenuHide(){
        this.hamburgerMenu=false;
        this.hamburgerMenuClass="hamburgerMenu";
    }

}