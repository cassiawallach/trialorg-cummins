//CECI-954 deals page - created new component

import { LightningElement, track, api, wire } from 'lwc';
import { perfixCurrencyISOCode } from 'c/serviceComponent';
import fetchCategoriesForDealsPage from '@salesforce/apex/dbu_dealsPageController.fetchCategoriesForDealsPage';
import fetchProductsFromCategoryIds from '@salesforce/apex/dbu_dealsPageController.fetchProductsFromCategoryIds';
import productCountWhenFilter from '@salesforce/apex/dbu_dealsPageController.productCountWhenFilter';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import CumminsLogoWhite from '@salesforce/resourceUrl/dbu_CumminsLogoWhite';
import returnIcon from '@salesforce/resourceUrl/dbu_icons';

import getLabels from 'c/dbu_custLabels'

export default class Dbu_dealsPageProducts extends LightningElement {
    whitelogoImg = CumminsLogoWhite;
    
    
    @track applyAndClose;
    @track isLoading = false;
    @track returnIcon = returnIcon+'/dbu_icons/dbu_Return_Icon.svg';
    @track showDesc = false;
    @track numberOfRecordsToDisplay = 12;
    @track currentPageNumber = 1;
    @track currentPaginationSetNumber = 1;
    @track listGridClass = "gridView";
    @track promoCategories;
    @track brandCategories
    @track subsubCategories;
    @track ProductDetailsBySubCategoryName;
    @track productTileDetails={};
    @track productTileDetailsList =[];
    @track gtmlistname;
    @track sortoption;
    @track maximumPageNumber;
    @track maximumPaginationSetNumber;
    @track totalProducts;//= 9;
    @track paginationRange = [];
    @track categoryIdForProduct = '';
    @track allDealsCategoryId; //= 'a223C000001EkyYQAS';
    @track allDealsChecked = true;
    @track incLoaderVal = 1;
    @track endProdsFlag = false;
    @track moreLoadedProducts;
    @track addProductsOnScreen = [];
    @track loadmore = false;
    @track dealsDescription;
    @track resetMode = true;
    @track ProductDetailsBySubCategoryNameMaster;
    @track sortName;
    @track unsortedProductTileDetailsList = [];

    @track allLabels = getLabels.labels;

    activeSections = ['promotions', 'category', 'brand'];
    sortName = 'arrival';
    pagename = "DealsPage"

    get sortOptions() {
        return [{
                label: 'Low-High Price',
                value: 'ASC'
            },
            {
                label: 'High-Low Price',
                value: 'DESC'
            },
            {
                label: 'In-Stock',
                value: 'INSTOCK'
            },
        ];
    }
    get options() {
        return [
            {
                label: '12',
                value: '12'
            },
            {
                label: '24',
                value: '24'
            },
            {
                label: '48',
                value: '48'
            }
        ];
    }


    connectedCallback(){
        this.isLoading = true;
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

        if(this.allLabels.dbu_deals_description != null && this.allLabels.dbu_deals_description != undefined && this.allLabels.dbu_deals_description != ""){
            this.showDesc = true;
        }

        
            
        if(!!window.sessionStorage.getItem('selectedPageNo2')){
            if(window.sessionStorage.getItem('selectedPageNo2').split(':')[0] === 'Deals'){
            this.currentPageNumber = window.sessionStorage.getItem('selectedPageNo2').split(':')[1];            
            }
        }
        this.currentPaginationSetNumber = !!this.currentPageNumber ? Math.ceil(this.currentPageNumber/6) : 1;

       //this.isLoading = false;
    }

    
    @wire(productCountWhenFilter, {
        country: '$currentLanguage',
        categoryIds: '$categoryIdForProduct'
    })
    productCountOnFilter({
        error,
        data
    }) {
        if(data){
                this.isLoading = true;
                this.totalProducts = data;
                console.log('The TOTAL for'+this.categoryIdForProduct+' is '+this.totalProducts);
                this.maximumPageNumber = Math.ceil(this.totalProducts / this.numberOfRecordsToDisplay);
                this.maximumPaginationSetNumber = Math.ceil(this.maximumPageNumber / 6);
                this.SetPaginationRange();
                if (this.sortoption != undefined)
                    this.performSorting();
                    this.isLoading = false;
        }else if(error) {
                console.log("data in deals on filter num error ", error);
                this.isLoading = false;
        }
    }
    @wire(fetchCategoriesForDealsPage, {
        country: '$currentLanguage'
    })
    GetProductsForPromotion({
        error,
        data
    }){
        if(data){
            this.isLoading = true;  
            
            this.promoCategories = data.promotionCategoryList.filter(function(i){return i.Name!='All Deals'});
            this.brandCategories = data.brandCategoryList;
            this.subsubCategories = data.allSubCategoryList;
            this.dealsDescription = this.promoCategories[0].ccrz__LongDescRT__c;
            this.fetchAllDealsDetails();
            this.isLoading = false;
        } else if (error) {
            this.error = error;
            console.log("data in deals category error ", error);
            this.isLoading = false;
        }
    }
    @wire(fetchProductsFromCategoryIds, {
        country: '$currentLanguage',
        categoryIds: '$categoryIdForProduct',
        pageNumber: '$currentPageNumber',
        numberofrecords: '$numberOfRecordsToDisplay'
    })
    GetProductsFromCategoryIds({
        error,
        data
    }){
        this.isLoading = true;
        if(data){
            let productData = JSON.stringify(data);
            this.ProductDetailsBySubCategoryName = JSON.parse(productData);
            this.productTileDetailsList = this.objectifyResponse(this.ProductDetailsBySubCategoryName);
            this.unsortedProductTileDetailsList = this.productTileDetailsList;
            this.sortName = null;
            //this.isLoading = false;
        } else if (error) {
            this.error = error;
            console.log("data in deals category error ", error);
            this.isLoading = false;
        }
        
        //GTM issue
        if(data != undefined){
            console.log(`Google analytics data for Deals on location ${this.currentLanguage} is `, data);
            window.localStorage.setItem('CurrentGAlistname' , 'Deals Category Page'); 
            this.gtmlistname= window.localStorage.getItem('CurrentGAlistname');
            invokeGoogleAnalyticsService('DEALS DATA RETURNED', {parentCategory : "Deals", currency : this.currentLanguage,  dataReturned : data});
        }
            
    }


    fetchAllDealsDetails(){
        
        this.isLoading = true;
        let categoryArray = [];
        this.promoCategories.forEach(obj => {
            categoryArray.push(obj.Id);
        })

        this.categoryIdForProduct = JSON.stringify(categoryArray);

        if (this.sortoption != undefined)
            this.performSorting();
    }
    

    objectifyResponse(respArr){
        this.isLoading = true;
        let productTileList = []
            respArr.forEach(productElement => 
                {
                    this.productTileDetails.sfdcName = productElement.productName;
                    this.productTileDetails.Id = productElement.sfId;
                    this.productTileDetails.sfid = productElement.sfId;
                    this.productTileDetails.imgUrl = productElement.productImageURI;
                    this.productTileDetails.price = productElement.price;
                    this.productTileDetails.originalPrice = productElement.originalPrice;
                    this.productTileDetails.promotionCategory = productElement.saleTag;
                    this.productTileDetails.discountPercentage = productElement.discountPercentage;
                    this.productTileDetails.stockstatus = productElement.inventoryStatus;
                    this.productTileDetails.SKU = productElement.SKU;

                    if(productElement.price != null){
                        let productPrice = productElement.price;
                        let originalProdPrice = productElement.originalPrice; 
                        productElement.price = perfixCurrencyISOCode(this.countryCurrencyCode,productPrice);
                        this.productTileDetails.price = productElement.price;
                        productElement.priceToSort = productPrice;
                        if((productPrice == originalProdPrice) || (productElement.discountPercentage == 0)){
                            this.productTileDetails.isOriginalPrice = false; 
                        }
                        else if(originalProdPrice !== productPrice && originalProdPrice > productPrice){
                            this.productTileDetails.isOriginalPrice = true;
                            productElement.originalPrice = perfixCurrencyISOCode(this.countryCurrencyCode,originalProdPrice);
                            this.productTileDetails.originalPrice = productElement.originalPrice;
                        }
                        this.productTileDetails.priceToSort = productPrice;
                    }
                    else
                    {
                        productElement.priceToSort = 'No Price';
                        this.productTileDetails.priceToSort= 'No Price';
                        this.isLoading = false;
                    }
                    if(productElement.discountPercentage > 0){
                        this.productTileDetails.discountPercentage = productElement.discountPercentage;
                    }
                    productTileList.push(JSON.parse(JSON.stringify(this.productTileDetails)));
                    
                });
               
                this.isLoading = false;

                return productTileList;
    }

    

    handlesubsubcategoryItem(event) {
        this.isLoading = true;
        let selectItemId = event.target.getAttribute('data-id');
        let existingSubCategoryArray = JSON.parse(this.categoryIdForProduct);

        if (event.target.checked) {
            if(this.resetMode){
                existingSubCategoryArray = [];
                existingSubCategoryArray.push(selectItemId);
                this.resetMode = false;
            }
            else{
                existingSubCategoryArray.push(selectItemId);
            }
        } else {
            existingSubCategoryArray = existingSubCategoryArray.filter(item => item != selectItemId);
        }
    
        if (existingSubCategoryArray.length == 0){
            this.promoCategories.forEach(obj => {
                existingSubCategoryArray.push(obj.Id);
            })
            this.fetchAllDealsDetails();
            this.resetMode = true;
            
        }

        this.categoryIdForProduct = JSON.stringify(existingSubCategoryArray);
        
        this.currentPaginationSetNumber = 1;
        this.currentPageNumber = 1;

        this.isLoading = false;
    }

    handleSortChange(event) {
        this.isLoading = true;
        this.sortoption = event.detail.value;
        this.sortName = event.detail.value;
        this.handleSortingFeedGoogleAnalytics(this.sortoption);
        this.doSorting();
    }

    handleSortingFeedGoogleAnalytics(sortingtype){
        let modifiedsortingType;
        if(sortingtype == 'DESC'){
            modifiedsortingType = 'high-low';
        }else if(sortingtype == 'ASC'){
            modifiedsortingType = 'low-high';            
        }else if(sortingtype == 'INSTOCK'){
            modifiedsortingType = 'in-stock';            
        }
        invokeGoogleAnalyticsService('PAGE SORTING', {sortType : modifiedsortingType, page : 'Deals Page'});
    }

    doSorting(){
        this.ProductDetailsBySubCategoryNameMaster = this.unsortedProductTileDetailsList;
        const localArray = [...this.ProductDetailsBySubCategoryNameMaster];

            var sortedArray = [];
            for(let i=0; i<localArray.length ;i++){
                if(localArray[i].price !== undefined){
                    sortedArray.push(localArray[i]);
                }
            }
            if (this.sortoption === 'DESC') {
                sortedArray.sort(function(a, b){  
                if(b.price !== undefined && a.price !== undefined){
                    return b.price.replace(/[^\d\.]/g, '') - a.price.replace(/[^\d\.]/g, '');
                }
                });
            
            }
            if (this.sortoption === 'ASC') {
                sortedArray.sort(function(a, b){  
                if(b.price !== undefined && a.price !== undefined){
                    return a.price.replace(/[^\d\.]/g, '') - b.price.replace(/[^\d\.]/g, '');
                }
                });
            }
            if (this.sortoption === "INSTOCK") {
                let localArray1 = [];
                let localArray2 = [];
                for (let i = 0; i < sortedArray.length; i++) {
                if (sortedArray[i].stockstatus ) {
                    localArray1.push(sortedArray[i]);
                } 
                }
                sortedArray = [];
                sortedArray = localArray1;
            }
            
            for(let i=0; i<localArray.length ;i++){
                if(localArray[i].price === undefined){
                    sortedArray.push(localArray[i]);
                }
            }
        
            this.productTileDetailsList = [...sortedArray];
            this.isLoading = false;
          
    }

    performSorting() {
        if (this.sortoption === 'lowprice') {
            let reverse = false;

            let itemsString = JSON.stringify(this.productTileDetailsList);

            if (itemsString == undefined || itemsString == '') {
                this.isLoading = false;
                return;
            }

            let items = JSON.parse(itemsString);

            this.productTileDetailsList = items.sort(this.sortBy('priceToSort', reverse));

            this.isLoading = false;
        }
        if (this.sortoption === 'highprice') {
            let reverse = false;
            let itemsString = JSON.stringify(this.productTileDetailsList);
            if (itemsString == undefined || itemsString == '') {
                this.isLoading = false;
                return;
            }
            let items = JSON.parse(itemsString);
            this.productTileDetailsList = items.sort(this.sortBy('priceToSort', reverse));
            this.isLoading = false;
        }
        this.isLoading = false;
    }

    listView(event) {
        this.listGridClass = "listView";
        this.template.querySelector('.gridViewIcon').classList.remove('selected');
        event.currentTarget.classList.add('selected');
    }
    gridView(event) {
        this.listGridClass = "gridView";
        this.template.querySelector('.listViewIcon').classList.remove('selected');
        event.currentTarget.classList.add('selected');
    }

    handlenumberOfRecordsToDisplayChange(event) {

        this.numberOfRecordsToDisplay = event.detail.value;
        this.maximumPageNumber = Math.ceil(this.totalProducts / this.numberOfRecordsToDisplay);
        this.maximumPaginationSetNumber = Math.ceil(this.maximumPageNumber / 6);
        this.sortName = null;
        this.currentPaginationSetNumber =  1;
        this.currentPageNumber = 1;
        this.SetPaginationRange();

    }
    handlePaginationClick(event) {

        this.isLoading = true;
        this.currentPageNumber = event.target.dataset.id;
        window.sessionStorage.setItem('selectedPageNo2', 'Deals' +':'+ this.currentPageNumber);
        this.sortName = null;
        this.isLoading = false;
    }

    nextPage(event)
    {

        if (this.currentPaginationSetNumber < this.maximumPaginationSetNumber)
        {
            this.currentPaginationSetNumber = this.currentPaginationSetNumber + 1;
        }

        this.SetPaginationRange();
    }
    prevPage()
    {
        if (this.currentPaginationSetNumber > 1)
            this.currentPaginationSetNumber = this.currentPaginationSetNumber - 1;

        this.SetPaginationRange();
    }

    SetPaginationRange()
    {
        if (this.maximumPaginationSetNumber == 1){
            this.template.querySelector('.nextLink').style.display = 'none';
            this.template.querySelector('.prevLink').style.display = 'none';
        }
        else{
            if (this.currentPaginationSetNumber === 1)
            {
                this.template.querySelector('.prevLink').style.display = 'none';
                this.template.querySelector('.nextLink').style.display = 'inline-block';
            }
            else if (this.currentPaginationSetNumber == this.maximumPaginationSetNumber)
            {
                this.template.querySelector('.nextLink').style.display = 'none';
                this.template.querySelector('.prevLink').style.display = 'inline-block';
            }
            else {
                this.template.querySelector('.prevLink').style.display = 'inline-block';
                this.template.querySelector('.nextLink').style.display = 'inline-block';
            }
        }

        if (this.currentPaginationSetNumber < this.maximumPaginationSetNumber)
        {
            this.currentPaginationSize = 6;

        }
        if(this.currentPaginationSetNumber == this.maximumPaginationSetNumber) {
            if(this.maximumPageNumber <= 6)
                this.currentPaginationSize = this.maximumPageNumber; 
            else 
                this.currentPaginationSize = Math.ceil((this.totalProducts - (6 * this.numberOfRecordsToDisplay * (this.maximumPaginationSetNumber-1))) / this.numberOfRecordsToDisplay); //CECI-1056
        }

        this.paginationRange = [];
       
        for (let index = 1; index <= this.currentPaginationSize; index++) {
            this.paginationRange.push(index + ((6 * this.currentPaginationSetNumber) - 6));
        }
        this.isLoading = false;
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