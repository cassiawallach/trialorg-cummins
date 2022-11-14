import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
import getSubCategoryByCategoryId from '@salesforce/apex/dbu_homePageCategoryTileCtrl.getSubCategoryByCategoryId';
import getDescriptionBySubCategoryId from '@salesforce/apex/dbu_homePageCategoryTileCtrl.getDescriptionBySubCategoryId';
import getProductDetailsBySubCategoryId from '@salesforce/apex/dbu_homePageCategoryTileCtrl.getProductDetailsBySubCategoryId';
import getProductBreadCrumb from '@salesforce/apex/dbu_homePageCategoryTileCtrl.getProductBreadCrumb';
import getProductBreadCrumbSubCategory from '@salesforce/apex/dbu_homePageCategoryTileCtrl.getProductBreadCrumbSubCategory';
import getSubCategoryWithProductByCategoryId from '@salesforce/apex/dbu_homePageCategoryTileCtrl.getSubCategoryWithProductByCategoryId';
import ccrz__E_Category__c_OBJECT from '@salesforce/schema/ccrz__E_Category__c';
//import SUBCATEGORYNAME_FIELD from '@salesforce/schema/ccrz__E_Category__c.ccrz__ParentCategory__c';
import ID_FIELD from '@salesforce/schema/ccrz__E_Category__c.Id';
import pubsub from 'c/pubsub';
import fetchhomePageCategoryDetails from '@salesforce/apex/dbu_homePageCategoryTileCtrl.fetchhomePageCategoryDetails';
import communityName from '@salesforce/label/c.dbu_communityName';
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA';
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada';
import categoryBannerResources from '@salesforce/resourceUrl/dbu_cumminCategoryBanner';
import dbu_category_filter from '@salesforce/label/c.dbu_category_filter';
import dbu_category_home from '@salesforce/label/c.dbu_category_home';
import dbu_category_sortby from '@salesforce/label/c.dbu_category_sortby';
import dbu_category_showperpage from '@salesforce/label/c.dbu_category_showperpage';
import dbu_category_showingpage from '@salesforce/label/c.dbu_category_showingpage';
import dbu_home_store_U_S_A from '@salesforce/label/c.dbu_home_store_U_S_A';
import dbu_home_store_Canada_CA from '@salesforce/label/c.dbu_home_store_Canada_CA';
import dbu_home_store_Canada from '@salesforce/label/c.dbu_home_store_Canada';
import dbu_home_store_Canada_French from '@salesforce/label/c.dbu_home_store_Canada_French';
import dbu_applyAndClose from "@salesforce/label/c.dbu_applyAndClose";
import { perfixCurrencyISOCode } from 'c/serviceComponent';
import 	dbu_locateheader from '@salesforce/label/c.dbu_locateheader';
import 	dbu_locatecontent1 from '@salesforce/label/c.dbu_locatecontent1';
import 	dbu_locatecontent2 from '@salesforce/label/c.dbu_locatecontent2';
import 	dbu_locateassit from '@salesforce/label/c.dbu_locateassit';
import 	dbu_locatecontactus from '@salesforce/label/c.dbu_locatecontactus';
import dbu_HowtoLocateSpec from '@salesforce/label/c.dbu_HowtoLocateSpec';
import 	dbu_Close from '@salesforce/label/c.dbu_Close';
import LocateImage from '@salesforce/resourceUrl/dbu_locateImage';
import CumminsLogoWhite from '@salesforce/resourceUrl/dbu_CumminsLogoWhite';
import dbu_ESNMainHeader from '@salesforce/label/c.dbu_ESNMainHeader';
import dbu_RVGreenLabelParts from '@salesforce/label/c.dbu_RVGreenLabelParts'; //Added by Dhiraj 10th Mar 2021
import onanRVMaintenancePartResource from '@salesforce/resourceUrl/dbu_Onan_RV_Maintenance_Parts_Guide_2019'; //Added by Dhiraj 10th Mar 2021
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

export default class Dbu_homPageSubSubCategoryList extends LightningElement {
    generatorlogo=LocateImage;
    whitelogoImg = CumminsLogoWhite;
    @api categoryName; //DO NOT USE IT
    @track ESNMainHeader
    @track isLocateModalOpen = false;
    @track locateheader;
    @track locatecontent1;
    @track locatecontent2;
    @track locateassit;
    @track locatecontactus;
    @track contactUsURL;
    @track categoryId;
    @track categoryIdForProduct = '';
    @track subsubCategories;
    @track categoryDescription;
    @track ProductDetailsBySubCategoryName;
    @track numberOfRecordsToDisplay = 12;
    @track currentPageNumber = 1;
    @track currentPaginationSetNumber = 1;
    @track totalProducts;
    //@track totalPages;
    @track paginationRange = [];
    @track currentPaginationSize =6;
    //@track pagination = false;
    //@track currentPageNum = 1;
    @track maximumPageNumber;
    @track maximumPaginationSetNumber;
    @track sortoption = '';
    @track sortoptionValue;
    @track filter = dbu_category_filter;
    @track home = dbu_category_home;
    @track sortby = dbu_category_sortby;
    @track showperpage = dbu_category_showperpage;
    @track showingpage = dbu_category_showingpage;
    @track storeUSA = dbu_home_store_U_S_A;
    @track storeCanada = dbu_home_store_Canada_CA;
    @track storeen = dbu_home_store_Canada;
    @track storefr = dbu_home_store_Canada_French;
    @track listnametosend;
    //@track currentPageNo;
    //@track startCurrentPageNum;
    //@track pageRange = 1;
    //@track maxPage = 6;
    //@track restMaxPage = 6;
    //@track paginationvalue;


    @track productPrice;
    @track sorteddata = [];
    @track numbersortdata;
    @track productBreadCrumb;
    @track subSubCategoryId;
    @track productBreadCrumbSubCategory;
    @track isLoading = true;
    @track listGridClass = "gridView";
    @track selectedSubSubCategories = [];


    @track baseURL;
    @track currentLanguage = 'US';
    @track currentLocation = 'US';
    @track locationstore;
    @track storeCountry;
    //@track conRecord1 = true;
    @track countryCurrencyCode;
    //@track subSubCategoryProCount = false;
    //@track procount;

    @track isEnableNext = false;
    @track isEnableNextPrev = false;
    label={
        dbu_RVGreenLabelParts, //Added by Dhiraj 10th Mar 2021
        dbu_HowtoLocateSpec,
        dbu_Close
    };
   
    fleetGuardFilter = categoryBannerResources + '/Images/Fleetgaurd.jpg';
    cumminsBanner = categoryBannerResources + '/Images/Cummins.jpg';
    @track categoryBannerName;
    @track categoryBannerNameimage;
    @track productBreadCrumbSubCategoryLowerCase;
    @track redirectURL;//Added by Dhiraj 14th Feb 2021

    @track onanRVMaintenancePart = onanRVMaintenancePartResource; //Added by Dhiraj 10th Mar 2021
    @track productTileDetails={};
    @track productTileDetailsList =[];
    @track gtmlistname;
    @track productTileDetailsCopyList=[];
    @track analyticsData;
    @track pagename = "HomeSubCategory";
    get ScreenLoaded() {
        return this.isLoading;
    }

    connectedCallback() {
        this.applyAndClose = dbu_applyAndClose;
       
        this.register();
       
        let queryString = window.location.search;
        let urlParams = new URLSearchParams(queryString);
        //this.categoryId = urlParams.get('id');
        this.categoryId = this.getproductidfromURL();
        let categoryArray = [];
        categoryArray.push(this.categoryId);
        this.categoryIdForProduct = JSON.stringify(categoryArray);

        this.baseURL = window.location.origin + communityName;

        console.log('this.categoryId=>' + this.categoryId);
        console.log('this.categoryIdForProduct=>' + this.categoryIdForProduct);

        this.storeCountry = window.sessionStorage.getItem('setCountryCode'); //urlParams.get('store');
        console.log('this.storeCountry=>' + this.storeCountry);
        this.locationstore = this.storeCountry;
        console.log('this.locationstore=>' + this.locationstore);
        window.sessionStorage.setItem('sendDataToCustomSearch',this.locationstore);
        /*
        if(this.locationstore == 'EN' || this.locationstore == 'FR')
        {
            this.locationstore = 'CA';
            console.log('this.currentLocation>>> ' + this.locationstore);
        }
        */

        if(this.locationstore == null || this.locationstore == this.storeUSA){
            this.locationstore = this.storeUSA;
            this.countryCurrencyCode = currencyCodeUSA; 
            this.currentLanguage = 'US'; 
        }else if(this.locationstore == this.storeen){
            this.locationstore = this.storeCanada;
            this.currentLanguage = 'EN';
            this.countryCurrencyCode = currencyCodeCanada;
        }else if(this.locationstore == this.storefr){
            this.locationstore = this.storeCanada;
            this.currentLanguage = 'FR';
            this.countryCurrencyCode = currencyCodeCanada;
        }
/*
        this.sortoptionValue =  localStorage.getItem('sortoptionStr');
        console.log('this.sortoptionValue128>>>>> ' + this.sortoptionValue);
        this.sortoption = this.sortoptionValue;
        console.log('this.this.sortoption130>>>>> ' + this.sortoption);

        if(this.sortoption == undefined)
        {
            console.log('Inside Sortoption If');
            this.sortoption = 'DESC';
            console.log('this.sortoption129=>' + this.sortoption);
            //localStorage.removeItem('sortoptionStr');
        }
        else if(this.sortoption == 'ASC')
        {
            console.log('Inside Sortoption else If');
            this.sortoption = 'ASC';
            console.log('this.sortoption1358=>' + this.sortoption);
            localStorage.removeItem('sortoptionStr');
        }  
        else if(this.sortoption == 'DESC')
        {
            console.log('Inside Sortoption else IfDESC');
            this.sortoption = 'DESC';
            console.log('this.sortoption1358=>' + this.sortoption);
            localStorage.removeItem('sortoptionStr');
        }
        */ 
       this.locateheader = dbu_locateheader;
       this.locatecontent1=dbu_locatecontent1;
       this.locatecontent2=dbu_locatecontent2;
       this.locateassit=dbu_locateassit;
       this.locatecontactus=dbu_locatecontactus;   
       this.ESNMainHeader = dbu_ESNMainHeader; 
       if(!!window.sessionStorage.getItem('selectedPageNo2')){
            if(window.sessionStorage.getItem('selectedPageNo2').split(':')[0] === this.categoryId){
            this.currentPageNumber = window.sessionStorage.getItem('selectedPageNo2').split(':')[1];            
            }
        }
        this.currentPaginationSetNumber = !!this.currentPageNumber ? Math.ceil(this.currentPageNumber/6) : 1;
    }

    getproductidfromURL(){
        let locationURL = window.location.pathname;            
        let splitpath = locationURL.split('/');  
        let CategoryId = splitpath[4];
        console.log('kazan > CategoryId ' + CategoryId );
        return CategoryId;
    }

    register()
    {
        window.console.log('homepagesubsubcaategory event registered');
        //pubsub.register('homepagecateitemdetaillanguageChange', this.handleLanguageChangeEvent.bind(this));  
        pubsub.register('sendDataTolstProdDetailspage', this.handleEventLoc.bind(this));
    }

    handleEventLoc(event) {
        console.log('event in handler in mini cart>>' + event);
        this.currentLanguage= event;
        if(this.currentLanguage == this.storeUSA)
        {
          this.currentLocation == this.storeUSA;
        }
        else if(this.currentLanguage == this.storeen || this.currentLanguage == this.storefr)
        {
          this.currentLocation == this.storeCanada;
        }
        console.log('this.currentLocation homepagesubsubcaategory > ' + this.currentLocation);
        let countryinsession = window.sessionStorage.getItem('setCountryCode');
        if(window.location.pathname.includes('categories') && (countryinsession == null || countryinsession == undefined || countryinsession == '' || countryinsession == 'undefined')){
          window.location.reload();
        }        
        //pubsub.fire('sendLocToStoreFromMinicart', this.changedLocation);
    }
    
    /*handleLanguageChangeEvent(event){
        console.log('homepagesubsubcaategory event fire >> '  + JSON.stringify(event));
        this.currentLanguage = event;
        console.log('this.currentLanguage homepagesubsubcaategory event >> ' + this.currentLanguage);        

        if(this.currentLanguage == this.storeUSA)
        {
            this.currentLocation == this.storeUSA;
        }
        else if(this.currentLanguage == this.storeen || this.currentLanguage == this.storefr)
        {
            this.currentLocation == this.storeCanada;
        }
        console.log('this.currentLocation homepagesubsubcaategory > ' + this.currentLocation);
    }*/
     
    //ProductBreadCrumb
    @wire(getProductBreadCrumb, {
        categoryId: '$categoryId'
    })
    GetProductBreadCrumbSubSubsubCategory({
        error,
        data
    }) {
        if (data) {
            console.log('Inside getProductBreadCrumb IF >>> ');
            console.log('getProductBreadCrumb>>>>>>>>>>53', (data));
            this.productBreadCrumb = data[0].Name;
            document.title =  this.productBreadCrumb;
            this.subSubCategoryId = this.productBreadCrumb.ccrz__ParentCategory__c;
            console.log('getProductBreadCrumb>>>>>>>>>>55', (data));
            console.log('this.subSubCategoryName>>>>>>>>>>59' + this.subSubCategoryName);
        } else if (error) {
            this.error = error;
            this.productBreadCrumb = undefined;
        }
    }

    @track productBreadCrumbSubCategoryid;
    @wire(getProductBreadCrumbSubCategory, {
        categoryId: '$categoryId'
    })
    GetProductSUbCategoryName({
        error,
        data
    }) {
        if (data) {
            console.log('Inside getProductBreadCrumbSubCategory IF >>> ');
            console.log('getProductBreadCrumbSubCategory>>>>>>>>>>77', (data));
            this.productBreadCrumbSubCategory = data[0].Name; //Fleetguard   fleet-guard
            this.productBreadCrumbSubCategoryLowerCase = this.productBreadCrumbSubCategory.toLowerCase().replace(/\s/g , "-");
            console.log('getProductBreadCrumbSubCategory>>>>>>>>>>79', (data));

            // this.categoryBannerName =  categoryBannerResources + '/Images/' + this.productBreadCrumbSubCategory + '.jpg';
            this.productBreadCrumbSubCategoryid = data[0].Id;
            this.categoryBannerName =  categoryBannerResources + '/' + this.productBreadCrumbSubCategoryLowerCase + '.png';
            this.categoryBannerNameimage =  categoryBannerResources + '/' + this.productBreadCrumbSubCategoryLowerCase + '-image.png';
            console.log('this.categoryBannerName+++ ' +this.categoryBannerName);
            console.log('this.cumminsBanner+++ ' +this.cumminsBanner);
       
            // if(this.productBreadCrumbSubCategory == 'Cummins'){
            //     console.log('Inside C176');
            //     //this.categoryBannerName = this.cumminsBanner;
            //     this.categoryBannerName;
            // }
            // if(this.productBreadCrumbSubCategory == 'Fleetgaurd'){
            //     console.log('Inside F180');
            //     this.categoryBannerName = this.fleetGuardFilter;
            // }
            //Added by Dhiraj 14th Feb 2021
            //this.redirectURL =  this.baseURL+'shopbybrand?categoryName='+ this.productBreadCrumbSubCategory + '&store=' + this.locationstore;
            this.redirectURL = this.baseURL+'shopbybrand/' + this.productBreadCrumbSubCategoryid + '/' +this.productBreadCrumbSubCategory;
            //Added bu Dhiraj on 18th Feb 2021
            window.sessionStorage.setItem('setproductBreadCrumbSubCategory)', this.productBreadCrumbSubCategory);
            console.log('this.productBreadCrumbSubCategory ' + window.sessionStorage.getItem('setproductBreadCrumbSubCategory'));
            
            this.contactUsURL = this.baseURL + 'contact-us?store=' +this.locationstore;
            if(this.productBreadCrumbSubCategoryLowerCase=== "onan"){
                this.onanOnly = true;
                //this.onanRVMaintenancePart = 
            }
        } else if (error) {
            console.log('Inside getProductBreadCrumbSubCategory ELSE ERROR >>> ');
            this.error = error;
            this.productBreadCrumb = undefined;
        }
    }

    // Sub Sub Category CheckBox Event...
    handlesubsubcategoryItem(event) {
        this.isLoading = true;
        let selectItemId = event.target.getAttribute('data-id');
        console.log('selectItemId=>' + selectItemId);
        let existingSubCategoryArray = JSON.parse(this.categoryIdForProduct);
        console.log('existingSubCategoryArray=>' + existingSubCategoryArray);
        if (existingSubCategoryArray.includes(this.categoryId))
            existingSubCategoryArray = existingSubCategoryArray.filter(item => item != this.categoryId);

        console.log('excluding original category Id existingSubCategoryArray=>' + existingSubCategoryArray);

        if (event.target.checked) {
            if (!existingSubCategoryArray.includes(selectItemId)) {
                existingSubCategoryArray.push(selectItemId);
                console.log('After adding selected category Id existingSubCategoryArray=>' + existingSubCategoryArray);
            }
        } else {
            existingSubCategoryArray = existingSubCategoryArray.filter(item => item != selectItemId);
            console.log('After removing selected category Id existingSubCategoryArray=>' + existingSubCategoryArray);

        }
        if (existingSubCategoryArray.length == 0)
            existingSubCategoryArray.push(this.categoryId);

        this.categoryIdForProduct = JSON.stringify(existingSubCategoryArray);
        console.log('this.categoryIdForProductd=>' + existingSubCategoryArray);

        //Start Implement Next and Previous Buttton

        this.currentPaginationSetNumber = 1;
        this.currentPageNumber = 1;
        //End of Implement Next and Previous Buttton Code.  
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

    handlenumberOfRecordsToDisplayChange(event) {

        this.numberOfRecordsToDisplay = event.detail.value;
        console.log('numberOfRecordsToDisplay>>>>> 268 ' + this.numberOfRecordsToDisplay);
        this.maximumPageNumber = Math.ceil(this.totalProducts / this.numberOfRecordsToDisplay);
        this.maximumPaginationSetNumber = Math.ceil(this.maximumPageNumber / 6);
        console.log('maximumPageNumber>>>>> 268 ' + this.maximumPageNumber);
        console.log('maximumPaginationSetNumber>>>>> 268 ' + this.maximumPaginationSetNumber);

        this.currentPaginationSetNumber =  1;
        this.currentPageNumber = 1;

    }
    handlePaginationClick(event) {

        this.isLoading = true;
        console.log('Inside Pagination Event>>>' + event.target.dataset.id);
        this.currentPageNumber = event.target.dataset.id;
        window.sessionStorage.setItem('selectedPageNo2', this.categoryId +':'+ this.currentPageNumber);
    }

    //Start Implement Next and Previous Buttton
    nextPage(event)
    {
        console.log('Inside nextPage()=>');

        if (this.currentPaginationSetNumber < this.maximumPaginationSetNumber)
        {
            this.currentPaginationSetNumber = this.currentPaginationSetNumber + 1;
        }

        this.SetPaginationRange();
        this.doSorting();  
    }
    prevPage()
    {
        if (this.currentPaginationSetNumber > 1)
            this.currentPaginationSetNumber = this.currentPaginationSetNumber - 1;

        this.SetPaginationRange();
        this.doSorting();
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
                console.log('this.currentPaginationSetNumber === 1');

            }
            else if (this.currentPaginationSetNumber == this.maximumPaginationSetNumber)
            {
                this.template.querySelector('.nextLink').style.display = 'none';
                this.template.querySelector('.prevLink').style.display = 'inline-block';
                console.log('this.currentPaginationSetNumber == this.maximumPaginationSetNumber');
            }
            else {
                this.template.querySelector('.prevLink').style.display = 'inline-block';
                this.template.querySelector('.nextLink').style.display = 'inline-block';
                console.log('this.currentPaginationSetNumber == this.maximumPaginationSetNumber-ELSE');
            }
        }

        console.log('calling SetPaginationRange');

        if (this.currentPaginationSetNumber < this.maximumPaginationSetNumber)
        {
            this.currentPaginationSize = 6;
            console.log('this.currentPaginationSetNumber < this.maximumPaginationSetNumber==>'+this.currentPaginationSize);

        }
        if(this.currentPaginationSetNumber == this.maximumPaginationSetNumber)
        {
            if(this.maximumPageNumber <= 6)
                this.currentPaginationSize = this.maximumPageNumber;
            else
                this.currentPaginationSize = Math.ceil((this.totalProducts - (6 * this.numberOfRecordsToDisplay)) / this.numberOfRecordsToDisplay);

            console.log('this.currentPaginationSetNumber == this.maximumPaginationSetNumber==>' + this.currentPaginationSize);

            //this.currentPaginationSize = this.numberOfRecordsToDisplay - (this.maximumPageNumber * this.numberOfRecordsToDisplay - this.totalProducts);
        }

        this.paginationRange = [];
       
        for (let index = 1; index <= this.currentPaginationSize; index++) {
            console.log('this.totalProducts'+this.totalProducts);
            console.log('this.numberOfRecordsToDisplay'+this.numberOfRecordsToDisplay);
            console.log('this.currentPaginationSize'+this.currentPaginationSize);
            console.log('this.currentPageNumber'+this.currentPageNumber);
            console.log('this.currentPaginationSetNumber'+this.currentPaginationSetNumber);
            console.log('((this.currentPaginationSize * this.currentPageNumber) - this.currentPaginationSize'+((this.currentPaginationSize * this.currentPageNumber) - this.currentPaginationSize));

            this.paginationRange.push(index + ((6 * this.currentPaginationSetNumber) - 6));
        }

    }
    //End of Implement Next and Previous Buttton Code.

    @wire(getProductDetailsBySubCategoryId, {
        categoryId: '$categoryIdForProduct',
        pageNumber: '$currentPageNumber',
        numberofrecords: '$numberOfRecordsToDisplay',
        country: '$locationstore'
       //, sortOption: '$sortoption'      
    })
    GetProductDetailsBySubCategoryNamen({
        error,
        data
    }) {
        if (data) {
            if (data.length > 0)
            {
                
                let productData = JSON.stringify(data);
                this.analyticsData = data;
                /**************************************************Sandeep starts
                let start = (this.currentPageNumber-1)*this.numberOfRecordsToDisplay;
                let end = this.numberOfRecordsToDisplay*this.currentPageNumber;
                let totalRecords = data;
                let  limitedRecords = totalRecords.slice(start, end);
                let productData = JSON.stringify(limitedRecords);
                **************************Sandeep ends*/
                this.productTileDetailsList = [];
                // this.productTileDetails={};
                this.ProductDetailsBySubCategoryName = JSON.parse(productData);

                console.log("ProductDetailsBySubCategoryName>>>>",JSON.parse(productData));
                // console.log("productTileDetailsList>>>>",this.productTileDetailsList);
                this.ProductDetailsBySubCategoryName.forEach(productElement => 
                {   
                    this.productTileDetails={};
                    this.productTileDetails.typeOfView= this.listGridClass;
                    this.productTileDetails.SKU = productElement.SKU; /* Sasikanth CECI-958 GTM Events*/
                    if(productElement.price != null) {
                        let productPrice = productElement.price;
                        this.productTileDetails.priceToSort = productPrice;
                        let originalProdPrice = productElement.originalPrice; 
                        productElement.price = perfixCurrencyISOCode(this.countryCurrencyCode,productPrice);
                        this.productTileDetails.price = productElement.price;
                        productElement.priceToSort = productPrice;
                        if((productPrice == originalProdPrice) || (productElement.discountPercentage == 0|| originalProdPrice == null || originalProdPrice == undefined || originalProdPrice < productPrice)){
                            this.productTileDetails.isOriginalPrice = false; 
                            console.log('in isOriginalPrice false',this.productTileDetails.isOriginalPrice);
                        }
                        else if(originalProdPrice > productPrice){
                            this.productTileDetails.isOriginalPrice = true;
                            productElement.originalPrice = perfixCurrencyISOCode(this.countryCurrencyCode,originalProdPrice);
                            this.productTileDetails.originalPrice = productElement.originalPrice;
                            console.log('in isOriginalPrice true',this.productTileDetails.isOriginalPrice);
                        }
                    }
                    else
                    {
                        productElement.priceToSort = 'No Price';
                        this.productTileDetails.priceToSort= 'No Price';
                        this.isLoading = false;
                    }
                    if(productElement.discountPercentage > 0) {
                        this.productTileDetails.discountPercentage = productElement.discountPercentage;
                        console.log('this.productTileDetails.discountPercentage',this.productTileDetails.discountPercentage)
                    }
                    if(productElement.promotionCategory != undefined){
                        this.productTileDetails.promotionCategory = productElement.promotionCategory;
                    }
                    console.log('isOriginalPrice',this.productTileDetails.isOriginalPrice);
                    this.productTileDetails.sfdcName = productElement.sfdcName;
                    this.productTileDetails.stockstatus= productElement.stockstatus;
                    // this.productTileDetails.Id = productElement.Id;
                    this.productTileDetails.sfid = productElement.sfid;
                    // this.productTileDetails.promotionCategory = productElement.promotionCategory != undefined ? productElement.promotionCategory : 'Clearance Sale';
                    if(productElement.EProductMediasS.length > 0){
                        productElement.imgUrl= productElement.EProductMediasS[0].URI;
                        this.productTileDetails.imgUrl = productElement.EProductMediasS[0].URI;
                    }
                    console.log("ImageURL",productElement.imgUrl)
                    console.log("this.productTileDetails.imgUrl",JSON.stringify(this.productTileDetails.imgUrl));
                    console.log("this.productTileDetails",JSON.stringify(this.productTileDetails));
                    this.productTileDetailsList.push(JSON.parse(JSON.stringify(this.productTileDetails)));
                    this.productTileDetailsCopyList.push(JSON.parse(JSON.stringify(this.productTileDetails)))
                });
                console.log("this.productTileDetailsList",JSON.stringify(this.productTileDetailsList));
                let i = 1;
                this.totalProducts = data[0].productCount;
                this.maximumPageNumber = Math.ceil(this.totalProducts / this.numberOfRecordsToDisplay);
                this.maximumPaginationSetNumber = Math.ceil(this.maximumPageNumber / 6);
                this.SetPaginationRange();

                if (this.sortoption != undefined)
                    this.performSorting();
               
                this.isLoading = false;
            }
            else
            {
                this.ProductDetailsBySubCategoryName = undefined;
                this.productTileDetailsList = undefined;
                this.totalProducts = 0;
            }
            this.isLoading = false;
            console.log('getProductDetailsBySubCatperformSortingegoryName>>>>>>>>>>79'+ (data));
            console.log('this.productBreadCrumb > ' + this.productBreadCrumb);
            window.localStorage.setItem('CurrentGAlistname' , this.productBreadCrumb + ' Category Page'); 
            this.gtmlistname= window.localStorage.getItem('CurrentGAlistname');
            console.log("this.gtmlistname",this.gtmlistname);
            invokeGoogleAnalyticsService('CATEGORY DATA RETURNED', {parentCategory : this.productBreadCrumb, currency : this.countryCurrencyCode,  dataReturned : data});
        }
        else if (error)
        {
            console.log('failed to fetch data');
            this.isLoading = false;

            this.error = error;
            this.ProductDetailsBySubCategoryName = undefined;
            this.productTileDetailsList = undefined;
            console.log('this.ProductDetailsBySubCategoryName379' + this.ProductDetailsBySubCategoryName);
            console.log('this.productTileDetailsList379',+this.productTileDetailsList);
            //this.conRecord1 = false;
            //this.isEnableNext = true;
            //console.log('this.conRecord1 +++ ' + this.conRecord1);
            console.log('this.isEnableNext +++ ' + this.isEnableNext);
        }
    }

    handlingextclick(event){
        console.log('Vojislav > ' + event.target.getAttribute('data-link'));
        console.log('Miroslav > ' + event.target.getAttribute('data-linkname'));
        invokeGoogleAnalyticsService('EXTERNAL LINK', {eventAction : event.target.getAttribute('data-linkname'), eventCategory : 'External Link', eventLabel : event.target.getAttribute('data-link')});                         
    } 

    @track categoryDescriptionHTML;
    @track showURLs = false;
    @track frontalURLArray = [];
    @wire(getDescriptionBySubCategoryId, {
        //categoryId: '$categoryIdForProduct'
        categoryId: '$categoryId'
    })
    GetSubSubCategoriesDescription({
        error,
        data
    }) {
        if (data) {
            //refreshApex(data);
            console.log('Inside Description IF>>>31');
            console.log('getSubCategoryDescription>>>>>>>>>>33', (data));
            let result = JSON.stringify(data);
            let resultObj = JSON.parse(result);
            this.categoryDescription = data;
            let res = resultObj.replaceAll('&lt;', '<');
            let removeGt = res.replaceAll('&gt;', '>');
            this.categoryDescriptionHTML = removeGt.replaceAll('&quot;', '"');
            let categoryResponseHtml = this.categoryDescriptionHTML ;

            console.log('categoryDescriptionHTML>>>>>>>>>>33', (this.categoryDescriptionHTML));                                    
            //Code added by Malhar for page data spliting                    
            if((categoryResponseHtml).includes('<a href=')){
                if(categoryResponseHtml.includes('.pdf')){
                    let splitedstring = categoryResponseHtml.split('<a href=');
                    console.log('splitedstring > ' + splitedstring);
                    console.log('type of splitedstring > ' + typeof splitedstring);
                    console.log('splitedstring.length > ' + splitedstring.length);
                    if(splitedstring.length > 0){                    
                        for(let i=0; i<splitedstring.length; i++){
                            console.log('i value > ' + i);
                            if(i > 0){
                                console.log('the hrefs' + '<a href=' + splitedstring[i]);
                                
                                if(((splitedstring[i]).includes('.pdf'))){
                                    let curinstUrl = '<a href=' + splitedstring[i];
                                    console.log('the URL > ' + curinstUrl.substring(curinstUrl.indexOf('https'), curinstUrl.indexOf('.pdf')) + '.pdf');
                                    console.log('the Name > '+ curinstUrl.replace( /(<([^>]+)>)/ig, ''));
                                    
                                    let eachLink = {
                                        count : i,
                                        URL : curinstUrl.substring(curinstUrl.indexOf('https'), curinstUrl.indexOf('.pdf')) + '.pdf',
                                        Name : curinstUrl.replace( /(<([^>]+)>)/ig, '') + '\n'
                                    }
                                    this.frontalURLArray.push(eachLink);
                                }else{                                    
                                    if(this.categoryDescriptionHTML != '' && this.categoryDescriptionHTML != null && this.categoryDescriptionHTML != undefined){
                                        this.categoryDescriptionHTML = this.categoryDescriptionHTML + '<p>' + '<a href='  +splitedstring[i] + '</p>';
                                    }else{
                                        this.categoryDescriptionHTML = '<p>' + '<a href='  +splitedstring[i] + '</p>';
                                    }
                                    console.log('CatdescHTML > ' + JSON.stringify(this.categoryDescriptionHTML));
                                }

                            }else if(i == 0){
                                this.categoryDescriptionHTML = splitedstring[i] + '</p>';
                                console.log('zeroth > ' + splitedstring[i]);
                            }
                        }
                    }
                    if((this.frontalURLArray).length > 0){
                        console.log('this.frontalURLArray > ' + JSON.stringify(this.frontalURLArray));
                        this.showURLs = true;
                        console.log('this.showURLs  > ' + this.showURLs );
                    }
                    
                }
            }
            //let divElement = this.template.querySelector('.ds');
            console.log('frontalURLArray > ' + JSON.stringify(this.frontalURLArray));
            console.log('getSubCategoryDescription>>>>>>>>>>35', (data));
        } else if (error) {
            this.error = error;
            this.categoryDescription = undefined;
        }
    }
    //getSubCategoryWithProductByCategoryId
    /*
    @track isrenderCallback = false;
    renderedCallback() {
        if (this.isrenderCallback)
            return;
        this.isrenderCallback = true;
        let divElement = this.template.querySelector('.ds');
        console.log('divElement>>>>>>>>>>33', (divElement));
        divElement.innerHTML = this.categoryDescriptionHTML;
        //console.log('divElement after>>>>>>>>>>33', (divElement));
        //console.log('divElement.innerHTML after>>>>>>>>>>33', (divElement.innerHTML));
    }
    */
    @wire(getSubCategoryWithProductByCategoryId, {
        categoryId: '$categoryId' ,
        country: '$locationstore'
    })
    GetSubSubCategories({
        error,
        data
    }) {
        if (data) {
            //refreshApex(data);
            console.log('Inside IF>>>46');
            console.log('subCategories>>>>>>>>>>231', (data));
            this.subsubCategories = data;
            console.log('subCategories>>>>>>>>>>233', (data));

            // for(let i=0; i<this.subsubCategories.length; i++){

            //     console.log('Inside for 456');
            //     console.log('this.subsubCategories.length ' + this.subsubCategories.length );
               
            //     this.procount = this.subsubCategories.subsubcategoryproductCount;
            //     console.log('this.procount ' + this.procount );

            //     if(this.procount == 0 || this.procount == undefined){
            //         console.log('Inside If 458');
            //         this.subSubCategoryProCount = true;
            //         console.log('this.subSubCategoryProCount ' + this.subSubCategoryProCount);
            //     }
            // }
           
        } else if (error) {
            this.error = error;
            this.subsubCategories = undefined;
        }
    }


    // Sorting
    //For Sorting
    sortName = 'arrival';
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

    sortBy(field, reverse, primer) {
        console.log('Sort by:field:' + field);
        console.log('Sort by:reverse:' + reverse);
        console.log('Sort by:primer:' + primer);

        var key = function (x) {
            return primer ? primer(x[field]) : x[field]
        };
        return function (a, b) {
            var A = key(a),
                B = key(b);
            if (A === undefined) A = '';
            if (B === undefined) B = '';
            return (A < B ? -1 : (A > B ? 1 : 0)) * [1, -1][+!!reverse];
        }
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
        invokeGoogleAnalyticsService('PAGE SORTING', {sortType : modifiedsortingType, page : 'Categories Page'});
    }

    handleSortChange(event) {
        this.isLoading = true;
        this.sortoption = event.detail.value;
        console.log('this.sortoption>>> ' + this.sortoption);
        this.handleSortingFeedGoogleAnalytics(this.sortoption);
        //this.performSorting();
        this.doSorting();
    }

    doSorting(){
        console.log('Inside doSorting>>> ');
    //Master list is created to store the original list of records so that the filtering doesnot remove the out of stock records from the list
    if(!this.ProductDetailsBySubCategoryNameMaster) {
        this.ProductDetailsBySubCategoryNameMaster = this.productTileDetailsList;
    }
    const localArray = [...this.ProductDetailsBySubCategoryNameMaster];
   
        //const localArray = [...this.ProductDetailsBySubCategoryName];

        var sortedArray = [];
        for(let i=0; i<localArray.length ;i++){
            if(localArray[i].price !== undefined){
                sortedArray.push(localArray[i]);
            }
        }
        if (this.sortoption === 'DESC') {
            console.log('Inside highprice>>> ');
            sortedArray.sort(function(a, b){  
            if(b.price !== undefined && a.price !== undefined){
                return b.price.replace(/[^\d\.]/g, '') - a.price.replace(/[^\d\.]/g, '');
            }
            });
           
        }
        if (this.sortoption === 'ASC') {
            console.log('Inside lowprice>>> ');
            sortedArray.sort(function(a, b){  
               if(b.price !== undefined && a.price !== undefined){
                console.log('Inside lowprice return>>> ');
                   return a.price.replace(/[^\d\.]/g, '') - b.price.replace(/[^\d\.]/g, '');
               }
               });
           }
           if (this.sortoption === "INSTOCK") {
            let localArray1 = [];
            let localArray2 = [];
            console.log("Inside In-Stock>>> ");
            for (let i = 0; i < sortedArray.length; i++) {
              console.log("StockStatus===" + sortedArray[i].stockstatus);
              if (sortedArray[i].stockstatus ) {
                localArray1.push(sortedArray[i]);
              } 
            }
            console.log("localArray1===" + localArray1.length);
            console.log("localArray2===" + localArray2.length);
            sortedArray = [];
            sortedArray = localArray1;
            console.log("sortedArray====" + sortedArray.length);
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
            console.log('BEFORE data_clone:' + JSON.stringify(this.productTileDetailsList));

            let itemsString = JSON.stringify(this.productTileDetailsList);
            console.log('BEFORE data_clone328 :' + itemsString);
            console.log('this.ProductDetailsBySubCategoryName 329 :' + this.productTileDetailsList);

            if (itemsString == undefined || itemsString == '') {
                this.isLoading = false;
                return;
            }

            let items = JSON.parse(itemsString);
            console.log('items :' + items);
            console.log('this.items ::: ' + this.items);

            this.productTileDetailsList = items.sort(this.sortBy('priceToSort', reverse));

            console.log('AFTER data_clone:' + JSON.stringify(this.productTileDetailsList));

            this.isLoading = false;
        }
        if (this.sortoption === 'highprice') {
            let reverse = false;
            console.log('BEFORE data_clone:' + JSON.stringify(this.productTileDetailsList));
            let itemsString = JSON.stringify(this.productTileDetailsList);
            console.log('BEFORE data_clone328 :' + itemsString);
            if (itemsString == undefined || itemsString == '') {
                this.isLoading = false;
                return;
            }
            let items = JSON.parse(itemsString);
            this.productTileDetailsList = items.sort(this.sortBy('priceToSort', reverse));
            console.log('AFTER data_clone:' + JSON.stringify(this.productTileDetailsList));
            this.isLoading = false;
        }
    }
    //Filter Active Selection - Raghava
    activeSections = ['category'];
    handleSectionToggle(event) {
        const openSections = event.detail.openSections;
    }

    listView(event) {
        this.listGridClass = "listView";
        this.productTileDetails.typeOfView= this.listGridClass;
        this.template.querySelector('.gridViewIcon').classList.remove('selected');
        event.currentTarget.classList.add('selected');
        // let matches = this.getElementsByClassName('resultBlock');
        // console.log('matches.length in list',matches.length);
        // for(let i=0; i < matches.length;i++){
        //     matches[i].classList.add('listBlock');
        //     matches[i].classList.add('list');
        //     matches[i].classList.remove('resultBlock');
        // }
    }
    gridView(event) {
        this.listGridClass = "gridView";
        this.productTileDetails.typeOfView= this.listGridClass;
        this.template.querySelector('.listViewIcon').classList.remove('selected');
        event.currentTarget.classList.add('selected');
        // let matches = this.getElementsByClassName('listBlock');
        // console.log('matches.length in grid',matches.length);
        // for(let i=0; i < matches.length;i++){
        //     matches[i].classList.add('resultBlock');
        //     matches[i].classList.remove('listBlock');
        //     matches[i].classList.remove('list');
        // }
    }

  openFilter(){
    this.template.querySelector('.searchFilter').classList.add('active');
    document.querySelector('body').classList.add('noscroll');
  }
  closeFilter(){
    this.template.querySelector('.searchFilter').classList.remove('active');
    document.querySelector('body').classList.remove('noscroll');
  }

    openModal() 
    {
        console.log('Inside openModal ==> ');
        // to open modal set isModalOpen tarck value as true
        this.isLocateModalOpen = true;
        invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'open find your Model & Spec Number model');
        
    }
    closeModal() 
    {
        // to close modal set isModalOpen tarck value as false
        invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname  : 'Close Find Model & Spec number Modal'});
        this.isLocateModalOpen = false;
    }
}