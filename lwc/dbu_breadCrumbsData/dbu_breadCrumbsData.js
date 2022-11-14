import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import communityName from '@salesforce/label/c.dbu_communityName';
import getProductBreadCrumb from '@salesforce/apex/dbu_homePageCategoryTileCtrl.getBreadCrumb';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import dbu_breadCrumbData_Home from "@salesforce/label/c.dbu_breadCrumbData_Home";
import branddataid from '@salesforce/apex/dbu_getBrandDataIds.getBrandId';
export default class Dbu_breadCrumbsData extends NavigationMixin(LightningElement){

    @track productId;
    @track brandCategoryName;
    @track brandSubCategoryName;
    @track brandProductName;
    @track brandSubCategoryId;
    @track sendLocBackToChangeLocTile;
    @track baseURL;

    label = {
        dbu_breadCrumbData_Home    
    }

    connectedCallback() {
        let locationURL = window.location.href;
        var url = new URL(locationURL);
        this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
        if (this.sendLocBackToChangeLocTile === undefined || this.sendLocBackToChangeLocTile === null) {
            this.sendLocBackToChangeLocTile = storeUSA;
        }
        this.baseURL = window.location.origin + communityName+'?store='+this.sendLocBackToChangeLocTile;
        if(locationURL.includes('?') && url.searchParams.get('pId')!=null){
            this.productId = url.searchParams.get("pId");
        }else{
            this.productId = this.getproductidfromURL();
        }
        console.log('PID======' + this.productId);
        this.getBreadCrumb();
    }

    getBreadCrumb() {
        getProductBreadCrumb({
            productId: this.productId
        })
            .then(result => {
                if (result !== null) {

                    console.log('==brandName====' + result.brandName);
                    console.log('==subCategoryName====' + result.subCategoryName);
                    console.log('==productName====' + result.productName);
                    
                    this.brandCategoryName = result.brandName;
                    this.brandSubCategoryName = result.subCategoryName;
                    this.brandProductName = result.productName;
                    this.brandSubCategoryId = result.subCategoryId;
                    document.title = result.productName;
                   
                }

            })
            .catch(error => {

            });
    }

    goToBrandPage() {
        var cateName;
        if (this.brandCategoryName === 'Cummins Onan') {
            cateName = 'Onan';
        } else {
            cateName = this.brandCategoryName;
        }
      
        branddataid({
            BrandName: cateName
        }).then(result => {
            console.log('brandid > ' + result);
            let urlString = window.location.origin;
            let redirectURL = urlString + communityName + 'shopbybrand/' + result + '/' + cateName;
            window.location.href = redirectURL;
        }).catch(error => {
            this.error = error.message;
        })

        //let urlString = window.location.origin;
        //let redirectURL = urlString + communityName + 'shopbybrand?categoryName=' + cateName + '&store=' + this.sendLocBackToChangeLocTile;
        //window.location.href = redirectURL;


    }               

    goToSubCategoryPage(event) {
        let urlString = window.location.origin;
        

        let categoryname = event.target.dataset.catname;

        //let redirectURL = urlString + communityName + 'categories?id=' + this.brandSubCategoryId + '&store=' + this.sendLocBackToChangeLocTile;
        let redirectURL = urlString + communityName + 'categories/' + this.brandSubCategoryId + '/' + categoryname;
        window.location.href = redirectURL;

    //     this[NavigationMixin.Navigate]({
    //         type: 'comm__namedPage',
    //         attributes: {
    //             name: 'Categories__c'
    //         },
    //         state: {
    //             'id': this.brandSubCategoryId,
    //             'store': this.sendLocBackToChangeLocTile
    //         }
    //     },
    //         true
    //     );
    }


    getproductidfromURL(){
        let locationURL = window.location.pathname;                        
        let splitpath = locationURL.split('/');     
        let ProductId = splitpath[4];
        console.log('kazal > ProductId ' +ProductId )
        return ProductId;
    }
}