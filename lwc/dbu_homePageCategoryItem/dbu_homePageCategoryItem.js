import {
    LightningElement,
    api,
    wire,
    track
} from 'lwc';
import getSubCategoryByCategoryId from '@salesforce/apex/dbu_homePageCategoryTileCtrl.getSubCategoryByCategoryId';
import getLabels from 'c/dbu_custLabels'

export default class Dbu_homePageCategoryItem extends LightningElement {
    @api category;
    @track subCategories;
    @track currentLanguage = 'US';
    @track countryCurrencyCode;
    @track locationstore;
    @track storeCountry;
    @track isLoading = true;
    @track allLabels = getLabels.labels;
     connectedCallback(){
        this.storeCountry = window.sessionStorage.getItem('setCountryCode');
        this.locationstore = this.storeCountry;
        if(this.locationstore == null || this.locationstore == this.allLabels.storeUSA){
            this.locationstore = this.allLabels.storeUSA;
            this.countryCurrencyCode = this.allLabels.currencyCodeUSA; 
            this.currentLanguage = 'US'; 
        }else if(this.locationstore == this.allLabels.storeCA){
            this.locationstore = this.allLabels.storeCanada;
            this.currentLanguage = 'EN';
            this.countryCurrencyCode = this.allLabels.currencyCodeCanada;
        }else if(this.locationstore == this.allLabels.storeCAF){
            this.locationstore = this.allLabels.storeCanada;
            this.currentLanguage = 'FR';
            this.countryCurrencyCode = this.allLabels.currencyCodeCanada;
        }
     }
    @wire(getSubCategoryByCategoryId, {
        categoryId: '$category',
        country: '$currentLanguage'
    })
    GetSubCategories({
        error,
        data
    }) {
        if (data) {
            //refreshApex(data);
            console.log('subCategories>>>>>>>>>>21', (data));
            this.subCategories = data;
            console.log('subCategories>>>>>>>>>>23', (data));
        } else if (error) {
            this.error = error;
            this.subCategories = undefined;
        }
    }
}