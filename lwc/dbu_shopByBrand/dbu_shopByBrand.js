import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import communityName from '@salesforce/label/c.dbu_communityName';
import getSubCategoryByParentCategoryName from '@salesforce/apex/dbu_ShopByBrandController.getSubCategoryByParentCategoryName';
import { perfixCurrencyISOCode } from 'c/serviceComponent';
import dbu_Filter_by from '@salesforce/label/c.dbu_Filter_by';
import dbu_Sort_By from '@salesforce/label/c.dbu_Sort_By';
import categoryBannerResources from '@salesforce/resourceUrl/dbu_cumminCategoryBanner';

//-------------Importing Custom Labels----------------
import dbu_myAccount_outOfStock from "@salesforce/label/c.dbu_myAccount_outOfStock";
import dbu_myAccount_inStock from "@salesforce/label/c.dbu_myAccount_inStock";
import dbu_Show_per_page from "@salesforce/label/c.dbu_Show_per_page";
import dbu_PriceNotAvailable from "@salesforce/label/c.dbu_PriceNotAvailable";
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada';//custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French';//custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA';//custom label refres to'CA'
import dbu_applyAndClose from "@salesforce/label/c.dbu_applyAndClose";
import dbu_breadCrumbData_Home from "@salesforce/label/c.dbu_breadCrumbData_Home";
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

export default class Dbu_shopByBrand extends NavigationMixin(LightningElement) {

    @track categoryBannerName;
    @track categoryBannerNameimage;
    @track categoryName;
    @track screenLoaded = false;
    @track sendLocBackToChangeLocTile;
    @track subCategoryArray = [];
    @track productArray = [];
    @track productCopyArray = [];
    @track sortoption;
    @track currencyCode;
    @track categoryDescription;
    @track currentLocation;
    @track numberOfRecordsToDisplay = 12;
    @track maximumPageNumber;
    @track pageNumber = [];
    @track error;
    @track counter = 0;
    @track btnDisabledNext = false;
    @track btnDisabledPrev = false;
    @track filterbytxt;
    @track sortbytxt;
    @track listGridClass = "gridView";
    @track baseURL;
    @track selectedPageNumber = 1;
    @track shopByBrandProdList=[];
    @track shopByBrandCopyProdList=[];
    @track gtmlistname;
    @track pagename = "ShopByBrand";
    activeSections = ['category'];
    @track coreProductList;
    @track corePrice;

    label = {
        dbu_myAccount_outOfStock,
        dbu_myAccount_inStock,
        dbu_Show_per_page,
        dbu_PriceNotAvailable,
        dbu_breadCrumbData_Home
    };

    value = '12';
    get options() {
        return [
            { label: '12', value: '12' },
            { label: '24', value: '24' },
            { label: '48', value: '48' },
        ];
    }

    handleChange(event) {
        console.log('====' + event.target.value);
        this.numberOfRecordsToDisplay = event.target.value;
        this.preparePagination();
    }


    connectedCallback() {
        this.screenLoaded = true;
        this.filterbytxt = dbu_Filter_by;
        this.sortbytxt = dbu_Sort_By;
	    this.applyAndClose = dbu_applyAndClose;
        let urlParameters = new URL(window.location.href).searchParams;
        //this.categoryName = urlParameters.get('categoryName');
        this.categoryName = this.getBrandNamefromURL();
        document.title = this.categoryName;
        //-----------------
        let categoryNameLowerCase = this.categoryName.toLowerCase().replace(/\s/g , "-");
        this.categoryBannerName =  categoryBannerResources + '/' + categoryNameLowerCase + '.png';
        this.categoryBannerNameimage =  categoryBannerResources + '/' + categoryNameLowerCase + '-image.png';
        //-----------------
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
        
        if(this.sendLocBackToChangeLocTile == storeCA || this.sendLocBackToChangeLocTile == storeCAF)
        {
         console.log('inside CA');
         this.currentLocation = storeCanada;
         this.currencyCode = 'CAD';
        }

        if (this.sendLocBackToChangeLocTile == storeUSA) {
            //check if url has yamamha
            if (window.location.pathname.includes('yamaha')) {
             if (window.sessionStorage.getItem('setCountryCode') == storeUSA) {
              if (window.location.origin == 'https://fr-shop.cummins.com' || window.location.origin == 'https://gwccdn.cummins.com') {
               window.sessionStorage.setItem('setCountryCode', storeCAF);    
               this.currentLocation = storeCanada;
               this.sendLocBackToChangeLocTile = storeCAF; 
               this.currencyCode = 'CAD';
              } else {
               window.sessionStorage.setItem('setCountryCode', storeCA);     
               this.currentLocation = storeCanada;
               this.sendLocBackToChangeLocTile = storeCA;
               this.currencyCode = 'CAD';
              }
              pubsub.fire('sendLocToStoreForYahamaCategory', this.sendLocBackToChangeLocTile);
              pubsub.fire('sendLocToCumminsLogoLWC', this.sendLocBackToChangeLocTile);            
             }
            }else{
             this.currentLocation =storeUSA;
             this.currencyCode = 'USD';
            }
        }

        if (this.sendLocBackToChangeLocTile == undefined) {
            if (window.location.pathname.includes('yamaha')) {
                if (window.sessionStorage.getItem('setCountryCode') == storeUSA ||
                    window.sessionStorage.getItem('setCountryCode') == undefined ||
                    window.sessionStorage.getItem('setCountryCode') == null ||
                    window.sessionStorage.getItem('setCountryCode') == 'undefined') {
                    if (window.location.origin == 'https://fr-shop.cummins.com' || window.location.origin == 'https://gwccdn.cummins.com') {
                        window.sessionStorage.setItem('setCountryCode', storeCAF);
                        this.currentLocation = storeCanada;
                        this.currencyCode = 'CAD';
                        this.sendLocBackToChangeLocTile = storeCAF;
                    } else {
                        window.sessionStorage.setItem('setCountryCode', storeCA);
                        this.currentLocation = storeCanada;
                        this.currencyCode = 'CAD';
                        this.sendLocBackToChangeLocTile = storeCA;
                    }
                    console.log('Going to fire sendLocToStore event');
                    pubsub.fire('sendLocToStoreForYahamaCategory', this.sendLocBackToChangeLocTile);
                    console.log('Going to fire sendLocToCumminsLogoLWC event');
                    pubsub.fire('sendLocToCumminsLogoLWC', this.sendLocBackToChangeLocTile);
                }
            } else {
                this.currentLocation = storeUSA;
                this.sendLocBackToChangeLocTile = storeUSA;
                this.currencyCode = 'USD';
                window.sessionStorage.setItem('setCountryCode', storeUSA);
                pubsub.fire('sendLocToStore', this.sendLocBackToChangeLocTile);
                pubsub.fire('sendLocToCumminsLogoLWC', this.sendLocBackToChangeLocTile);
            }

            console.log('this.currentLocation======= ' + this.currentLocation);
        }

        window.sessionStorage.setItem('sendDataToCustomSearch',this.sendLocBackToChangeLocTile);
        this.baseURL = window.location.origin + communityName+'?store='+this.sendLocBackToChangeLocTile;
        this.handleSubCategory();
        this.selectedPageNumber = !!window.sessionStorage.getItem('selectedPageNo3') ? window.sessionStorage.getItem('selectedPageNo3') : 1;
    }

    getBrandNamefromURL(){
        let locationURL = window.location.pathname;            
        let splitpath = locationURL.split('/');  
        let BrandName = splitpath[5];
        console.log('kazaN > BrandName ' +BrandName );
        if(BrandName == 'power-service'){
            BrandName = 'Power Service';
        }
        
        return BrandName;
      }

    handleSubCategory() {
        getSubCategoryByParentCategoryName({
            locationCode: this.currentLocation,
            parentCategoryName: this.categoryName
        })
            .then(result => {
                var inventoryMap = new Map();
                var prodCountAgainstSubCateMap = new Map();
                console.log('Result===' + JSON.stringify(result));
                if (result !== null) {
                    console.log('==SubCatList===' + result.subCategoryList.length)
                    console.log('==ProdList==' + JSON.stringify(result.prodList))
                    console.log('==ProdLength===' + result.prodList.length)
                    let coreChargeObj = result.Coreprice;
                    let coreChKey = Object.keys(coreChargeObj);
                    let coreChVal = Object.values(coreChargeObj);
                    //==== Show Product count against sub category----
                    // if (result.prodAgainstSubCate !== null && result.prodAgainstSubCate !== undefined) {
                    //     for (let key in result.prodAgainstSubCate) {
                    //         prodCountAgainstSubCateMap.set(key, result.prodAgainstSubCate[key]);
                    //     }
                    // }

                    //===SubCategory list display---
                    if (result.subCategoryList.length > 0) {
                        if (result.subCategoryList[0].ccrz__ParentCategory__r.ccrz__LongDescRT__c !== undefined) {
                            let catDesc = JSON.stringify(result.subCategoryList[0].ccrz__ParentCategory__r.ccrz__LongDescRT__c);
                            let parseCatDesc = JSON.parse(catDesc);
                            let res = parseCatDesc.replaceAll('&lt;', '<');
                            let removeGt = res.replaceAll('&gt;', '>');
                            this.categoryDescription = removeGt.replaceAll('&quot;', '"');
                            console.log('Description===' + this.categoryDescription);
                        }

                        for (let i = 0; i < result.subCategoryList.length; i++) {
                            let subCateObj = {};
                            subCateObj['Id'] = result.subCategoryList[i].Id;
                            subCateObj['Name'] = result.subCategoryList[i].Name;
                            // if (prodCountAgainstSubCateMap.has(result.subCategoryList[i].Id)) {
                            //     subCateObj['prodCount'] = prodCountAgainstSubCateMap.get(result.subCategoryList[i].Id);
                            // } else {
                            //     subCateObj['prodCount'] = 0;
                            // }
                            this.subCategoryArray.push(subCateObj);
                        }
                    }
                    //==== Inventory Status Map----
                    console.log('inventoryStatus=========' + Object.keys(result.inventoryStatus));
                    if (result.inventoryStatus !== null && result.inventoryStatus !== undefined) {
                        for (let key in result.inventoryStatus) {
                            inventoryMap.set(key, result.inventoryStatus[key]);
                        }
                    }
                    console.log('inventoryMap=========' + inventoryMap);

                    //====Product list display----
                    if (result.prodList.length > 0) {
                        for (let i = 0; i < result.prodList.length; i++) {

                            let prodObj = {};
                            let shopByBrandProd={};
                            prodObj['id'] = result.prodList[i].Id;
                            shopByBrandProd['Id']=result.prodList[i].Id;
                            shopByBrandProd['sfid']=result.prodList[i].Id;
                            shopByBrandProd['SKU']=result.prodList[i].ccrz__SKU__c; /* Sasikanth CECI-958 GTM Events*/
                            console.log('Name=====' + result.prodList[i].Name);
                            prodObj['Name'] = result.prodList[i].Name;
                            console.log('result prodList', result.prodList);
                            // prodObj['sfdcName'] = result.prodList[i].Name;
                            shopByBrandProd['sfdcName']=result.prodList[i].Name;
                            if (result.prodList[i].ccrz__E_PriceListItems__r !== undefined && result.prodList[i].ccrz__E_PriceListItems__r !== null) {
                                console.log('Price==' + result.prodList[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c);
                                var prodPrice = result.prodList[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                                prodObj['price'] = perfixCurrencyISOCode(this.currencyCode, prodPrice);
                                shopByBrandProd['price']=prodObj['price'];
                                var discPerc = result.prodList[i].ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c;
                                shopByBrandProd['discountPercentage'] = discPerc;
                                prodObj['discountPercentage'] = discPerc;
                                if(result.prodList[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c != undefined
                                    && result.prodList[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c !=null 
                                    && result.prodList[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c > 0) {
                                    var prodOrigPrice = result.prodList[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                                }
                                if(prodOrigPrice > prodPrice){
                                    shopByBrandProd['isOriginalPrice'] = true;
                                    prodObj['isOriginalPrice'] = true;
                                    prodObj['originalPrice'] = perfixCurrencyISOCode(this.currencyCode, prodOrigPrice);
                                    shopByBrandProd['originalPrice']=prodObj['originalPrice'];
                                }
                                else if(prodOrigPrice > prodPrice || discPerc == 0){
                                    shopByBrandProd['isOriginalPrice'] = false;
                                    prodObj['isOriginalPrice'] = false;
                                }
                                
                            }
                            if (result.prodList[i].ccrz__Promotions__r !== undefined && result.prodList[i].ccrz__Promotions__r !== null){
                                let saleTag = result.prodList[i].ccrz__Promotions__r[0].ccrz__Category__r.Name;  //Aakriti UAT fix 6sept added ccrz__Category__r
                                shopByBrandProd['promotionCategory'] = saleTag;
                                prodObj['promotionCategory'] = saleTag;
                            }
                            let containCore = coreChKey.includes(result.prodList[i].Id)
                            if(result.prodList[i].dbu_Has_Core_Charge__c == true && containCore){
                                let coreChPos = coreChKey.indexOf(result.prodList[i].Id);
                                let corePriceVal = coreChVal[coreChPos];
                                console.log("THIS IS CORE PRICE "+ corePriceVal);
                                let finalProdPrice = parseFloat(result.prodList[i].ccrz__E_PriceListItems__r[0].ccrz__Price__c) + parseFloat(corePriceVal);
                                prodObj['price'] = perfixCurrencyISOCode(this.currencyCode, finalProdPrice);
                                shopByBrandProd['price']=prodObj['price'];
                                let finalOrigProdPrice = parseFloat(result.prodList[i].ccrz__E_PriceListItems__r[0].dbu_Original_Price__c) + parseFloat(corePriceVal);
                                prodObj['originalPrice'] = perfixCurrencyISOCode(this.currencyCode, finalOrigProdPrice);
                                shopByBrandProd['originalPrice']=prodObj['originalPrice'];
                                // prodObj['price'] = perfixCurrencyISOCode(this.currencyCode, finalOrigProdPrice);
                                // shopByBrandProd['price']=prodObj['price'];
                                prodObj['discountPercentage'] = Math.round(((finalOrigProdPrice - finalProdPrice)/finalOrigProdPrice)*100);
                                shopByBrandProd['discountPercentage'] = prodObj['discountPercentage'];
                                console.log('discountPercentage in shopByBrand', prodObj['discountPercentage']);
                            }
                {

}
                            if (result.prodList[i].ccrz__E_ProductMedias__r !== undefined && result.prodList[i].ccrz__E_ProductMedias__r !== null) {
                                console.log('URI===' + result.prodList[i].ccrz__E_ProductMedias__r[0].ccrz__URI__c);
                                prodObj['imageUrl'] = result.prodList[i].ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                                shopByBrandProd['imgUrl'] = result.prodList[i].ccrz__E_ProductMedias__r[0].ccrz__URI__c;
                            }
                            if (inventoryMap.has(result.prodList[i].Id)) {
                                prodObj['stockstatus'] = inventoryMap.get(result.prodList[i].Id);
                                shopByBrandProd['stockstatus'] = inventoryMap.get(result.prodList[i].Id);
                            }
                            

                            this.productArray.push(prodObj);
                            this.productCopyArray.push(prodObj);
                            this.shopByBrandProdList.push(shopByBrandProd);
                            this.shopByBrandCopyProdList.push(shopByBrandProd);
 
                        }

                        console.log('productArray shopby brand > ' + JSON.stringify(this.productArray));
                        console.log('shopByBrandProdList shopby brand >' + JSON.stringify(this.shopByBrandProdList))
                        window.localStorage.setItem('CurrentGAlistname', this.categoryName + ' Brand Page');
                        this.gtmlistname = window.localStorage.getItem('CurrentGAlistname');;
                        console.log('shopByBrand gtmlistname',this.gtmlistname);
                        invokeGoogleAnalyticsService('BRAND DATA RETURNED', {ProductFeed : JSON.parse(JSON.stringify(this.shopByBrandProdList)), currency : this.currencyCode, categoryName : this.categoryName});                        
                        
                        this.screenLoaded = false;
                        this.preparePagination();
                    }

                }
               
                setTimeout(() => {
                this.template.querySelector(".pgNums").firstElementChild.classList.add('pgSelct');
            }, 500);
            this.screenLoaded = false;
            })
            .catch(error => {
                console.log(error)
                this.screenLoaded = false;
            });
    }

    handleSelectedSubCategory(event) {
        this.screenLoaded = true;
        console.log('Sub Category ID===' + event.target.dataset.id);
        let subCategoryId = event.target.dataset.id;
        let subcatname = event.target.dataset.catname;
        console.log('subcatname > ' + subcatname);        
        let urlString = window.location.origin;

        //let redirectURL = urlString + communityName + 'categories?id=' + subCategoryId + '&store=' + this.sendLocBackToChangeLocTile;
        let redirectURL = urlString + communityName + 'categories/' + subCategoryId+ '/' + subcatname;
        console.log('redirectURL',redirectURL);
        window.location.href = redirectURL;
        /*
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": redirectURL
            }
        });*/
    }
    //-----------Pagination Logic----------
    preparePagination() {
        this.productArray = [];
        this.shopByBrandProdList=[];
        this.pageNumber = [];
        this.counter = 0;
        // this.maximumPageNumber = Math.ceil(this.productCopyArray.length / this.numberOfRecordsToDisplay);
        this.maximumPageNumber = Math.ceil(this.shopByBrandCopyProdList.length / this.numberOfRecordsToDisplay);
        console.log('=maximumPageNumber==' + this.maximumPageNumber);
        if (this.maximumPageNumber > 6) {
            this.btnDisabledPrev = true;
            this.btnDisabledNext = false;
            for (let i = 0; i < 6; i++) {
                this.pageNumber.push(i + 1);
                this.counter++;
            }

        } else {
            this.btnDisabledPrev = true;
            this.btnDisabledNext = true;
            for (let i = 0; i < this.maximumPageNumber; i++) {
                this.pageNumber.push(i + 1);
                this.counter++;
            }
        }
        if (this.shopByBrandCopyProdList.length >= this.numberOfRecordsToDisplay) {
            for (let j = 0; j < this.numberOfRecordsToDisplay; j++) {
                // this.productArray.push(this.productCopyArray[j]);
                this.shopByBrandProdList.push(this.shopByBrandCopyProdList[j]);
            }
        } else {
            for (let k = 0; k < this.shopByBrandCopyProdList.length; k++) {
                // this.productArray.push(this.productCopyArray[k]);
                this.shopByBrandProdList.push(this.shopByBrandCopyProdList[k]);
            }
        }
        if (this.productCopyArray.length >= this.numberOfRecordsToDisplay) {
            for (let j = 0; j < this.numberOfRecordsToDisplay; j++) {
                this.productArray.push(this.productCopyArray[j]);
            }
        } else {
            for (let k = 0; k < this.productCopyArray.length; k++) {
                this.productArray.push(this.productCopyArray[k]);
            }
        }
    }

    handleNext() {
        let localCounterNext;
        console.log('counter==' + this.counter);
        this.pageNumber = [];
        let remainingPage = this.maximumPageNumber - this.counter;
        console.log('Remaining==' + remainingPage);
        if (remainingPage >= 6) {
            console.log('IF');
            for (let i = this.counter; i < (this.counter + 6); i++) {
                this.pageNumber.push(i + 1);
                localCounterNext = i + 1;
            }
            this.counter = localCounterNext;

        } else {
            console.log('ELSE')
            console.log('CC===' + this.counter);
            for (let i = this.counter; i < this.maximumPageNumber; i++) {
                this.pageNumber.push(i + 1);
                localCounterNext = i + 1;
            }
            this.counter = localCounterNext;

        }
        console.log('FInal counter==' + this.counter);
        if (this.counter === this.maximumPageNumber) {
            this.btnDisabledNext = true;
        }
        if (this.counter > 6) {
            this.btnDisabledPrev = false;
        }
    }

    handlePrev() {
        this.pageNumber = [];
        let localCounterPrev;
        let remainingCount = this.counter - 6;
        console.log('remainingCount==' + remainingCount);

        if (remainingCount > 6) {
            for (let i = remainingCount; i < (remainingCount + 6); i++) {
                this.pageNumber.push(i);
                localCounterPrev = i;
            }

        } else {
            var finalIndex = this.counter - remainingCount;
            console.log('Inedx==' + finalIndex);
            for (let i = 0; i < finalIndex; i++) {
                this.pageNumber.push(i + 1);
                localCounterPrev = i + 1;
            }
        }
        this.counter = localCounterPrev;

        if (this.counter <= 6) {
            this.btnDisabledPrev = true;
            this.btnDisabledNext = false;
        } else {
            this.btnDisabledNext = false;
        }

    }

    handlePaginationClick(event) {
        // this.template.querySelector(".selectPage").classList.remove("class1");
        //  event.currentTarget.classList.add('class1');
        var selClass = this.template.querySelectorAll(".pgNum");

        for (var s = 0; s < selClass.length; s++) {
            selClass[s].classList.remove("pgSelct");
        }
        event.currentTarget.classList.add('pgSelct');
        this.productArray = [];
        this.shopByBrandProdList=[];
        console.log('CLicked page number===' + event.target.dataset.id);
        this.selectedPageNumber =  event.target.dataset.id;
        window.sessionStorage.setItem('selectedPageNo3', this.selectedPageNumber);
        let pageLabel = event.target.dataset.id;
        let finalIndex = pageLabel * this.numberOfRecordsToDisplay;
        console.log('finalIndex==' + finalIndex);
        let startingIndex = (pageLabel * this.numberOfRecordsToDisplay) - this.numberOfRecordsToDisplay;
        console.log('startingIndex==' + startingIndex);
        for (let i = startingIndex; i < finalIndex; i++) {
            if (this.productCopyArray[i] !== null && this.productCopyArray[i] !== undefined) {
                this.productArray.push(this.productCopyArray[i]);
            }
        }
        for (let i = startingIndex; i < finalIndex; i++) {
            if (this.shopByBrandCopyProdList[i] !== null && this.shopByBrandCopyProdList[i] !== undefined) {
                this.shopByBrandProdList.push(this.shopByBrandCopyProdList[i]);
            }
        }
    }
    //----Pagination End----------------
    //----Sorting Start-----------------
    get sortOptions() {
        return [{
            label: 'Low-High Price',
            value: 'Low-High'
        },
        {
            label: 'High-Low Price',
            value: 'High-Low'
        },
        {
            label: 'In-Stock',
            value: 'In-Stock'
        },
        ];
    }
    @track selectedOption;
    handleSortChange(event) {
        console.log('Function called')
        this.selectedOption = event.target.value;
        console.log('sortOptions===' + this.selectedOption);
        invokeGoogleAnalyticsService('PAGE SORTING', {sortType : this.selectedOption, page : 'ShopBy Brand Page'});
        this.doSorting();
    }

    doSorting() {
        console.log('Inside doSorting>>> ');

        let localArray = [...this.productCopyArray];
        localArray = [...this.shopByBrandCopyProdList];
        var sortedArray = [];
        for (let i = 0; i < localArray.length; i++) {
            // console.log('====' + localArray[i].price);
            if (localArray[i].price !== undefined) {
                sortedArray.push(localArray[i]);
            }
        }
        console.log('sortedArray===' + sortedArray.length);
        console.log('sortOptin Again===' + this.selectedOption);

        if (this.selectedOption == 'High-Low') {
            console.log('Inside highprice>>> ');
            sortedArray.sort(function (a, b) {
                if (b.price !== undefined && a.price !== undefined) {
                    return b.price.replace(/[^\d\.]/g, '') - a.price.replace(/[^\d\.]/g, '');
                }
            });

        }
        if (this.selectedOption == 'Low-High') {
            console.log('Inside lowprice>>> ');
            sortedArray.sort(function (a, b) {
                if (b.price !== undefined && a.price !== undefined) {
                    console.log('Inside lowprice return>>> ');
                    return a.price.replace(/[^\d\.]/g, '') - b.price.replace(/[^\d\.]/g, '');
                }
            });
        }
        if (this.selectedOption == 'In-Stock') {
            let localArray1 = [];
            let localArray2 = [];
            console.log('Inside In-Stock>>> ');
            for (let i = 0; i < sortedArray.length; i++) {
                console.log('StockStatus===' + sortedArray[i].stockstatus);
                if (sortedArray[i].stockstatus === true) {
                    localArray1.push(sortedArray[i]);
                } else {
                    localArray2.push(sortedArray[i]);
                }
            }
            console.log('localArray1===' + localArray1.length);
            console.log('localArray2===' + localArray2.length);
            sortedArray = [];
            sortedArray = localArray1.concat(localArray2);
            console.log('sortedArray====' + sortedArray.length);
        }

        for (let i = 0; i < localArray.length; i++) {
            if (localArray[i].price === undefined) {
                sortedArray.push(localArray[i]);
            }
        }
        this.productCopyArray = [...sortedArray];
        this.shopByBrandCopyProdList= [...sortedArray];
        this.preparePagination();
        console.log('localArray===' + localArray.length);
    }
    //---- Redirect to Product detail page--
    goToProductDetailPage(event) {
        let prodName = event.currentTarget.getAttribute('data-name');
        let prodId = event.currentTarget.getAttribute('data-id');
        let prodPrice = event.currentTarget.getAttribute('data-productprice');
        
        //Replacing comma and whitespace from hyphen in Product Name
        if (prodName.includes(",")) {
            prodName = prodName.replace(/,/g, '-').toLowerCase();
        }
        if (prodName.includes(" ")) {
            prodName = prodName.replace(/\s+/g, '-').toLowerCase();
        }
        if(prodName.includes('/')){
            prodName = prodName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
          }

        console.log('ProdName===' + prodName);

        console.log('ProdId===' + prodId);

        let galistname = window.localStorage.getItem('CurrentGAlistname');
        
        let productFeedForGoogleAnalytics = {
            ProductID : prodName,
            productName : prodName,
            ProductInventoryStatus : 1,
            ProductPrice : prodPrice,
            listname : gtmlistname,            
            ProductCategory : '',
            ProductBrand : ''
          };   

          invokeGoogleAnalyticsService('ON PRODUCT CLICK EVENT' , productFeedForGoogleAnalytics);

        let urlString = window.location.origin;
				 let redirectURL =  urlString + communityName +'product/'+prodId +'/'+ prodName+'/?store='+this.sendLocBackToChangeLocTile;
       // let redirectURL = urlString + communityName + 'product?name=' + prodName + '&pId=' + prodId + '&store=' + this.sendLocBackToChangeLocTile;
        console.log('redirectURL====' + redirectURL);
        window.location.href = redirectURL;
        /*
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": redirectURL
            }
        });*/
    }

    listView(event) {
        this.listGridClass = "listView";
        this.template.querySelector(".gridViewIcon").classList.remove("selected");
        event.currentTarget.classList.add("selected");
    }
    gridView(event) {
        this.listGridClass = "gridView";
        this.template.querySelector(".listViewIcon").classList.remove("selected");
        event.currentTarget.classList.add("selected");
    }

  openFilter(){
    this.template.querySelector('.searchFilter').classList.add('active');
    document.querySelector('body').classList.add('noscroll');
  }
  closeFilter(){
    this.template.querySelector('.searchFilter').classList.remove('active');
    document.querySelector('body').classList.remove('noscroll');
  }
}