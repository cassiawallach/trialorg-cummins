import { LightningElement,track } from 'lwc';

import dbu_myGarageTile_My_Garage from '@salesforce/label/c.dbu_myGarageTile_My_Garage';
import dbu_myGarageTile_MenuItemOne from '@salesforce/label/c.dbu_myGarageTile_MenuItemOne';
import dbu_myGarageTile_MenuItemTwo from '@salesforce/label/c.dbu_myGarageTile_MenuItemTwo';
import dbu_myGarageTile_MenuItemThree from '@salesforce/label/c.dbu_myGarageTile_MenuItemThree';

export default class Cm_myGarageTile extends LightningElement {

  @track dbu_myGarageTile_My_Garage     = dbu_myGarageTile_My_Garage;
  @track dbu_myGarageTile_MenuItemOne   = dbu_myGarageTile_MenuItemOne;
  @track dbu_myGarageTile_MenuItemTwo   = dbu_myGarageTile_MenuItemTwo;
  @track dbu_myGarageTile_MenuItemThree = dbu_myGarageTile_MenuItemThree;

    get options() {
        return [
                 { label: 'xx', value: 'xxx' },
                 { label: 'yyyyy', value: 'yyyyy' },
                 { label: 'zzzz', value: 'zzz' },
               ];
    }
    
    handleChange(event) {
            this.value = event.detail.value;
         }
    }