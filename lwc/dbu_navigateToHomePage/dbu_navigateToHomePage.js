import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import dbu_navigateToHomePage_Home from '@salesforce/label/c.dbu_navigateToHomePage_Home'; 

export default class Dbu_navigateToHomePage extends NavigationMixin (LightningElement) {
    @track URL = "";
    @track dbu_navigateToHomePage_Home = dbu_navigateToHomePage_Home;

    onClickHomePage() {
        this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: 'https://dbuecomdev-cumminscss.cs24.force.com/MVPStore/s/'
                }
        });
    }
 
}