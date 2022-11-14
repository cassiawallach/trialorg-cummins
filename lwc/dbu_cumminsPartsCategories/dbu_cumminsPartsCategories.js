import {
    LightningElement,
    track
} from 'lwc';
import communityName from '@salesforce/label/c.dbu_communityName';
import {
    NavigationMixin
} from 'lightning/navigation';
import CumminsParts from '@salesforce/resourceUrl/CumminsParts';
import getProdCategoryMedia from '@salesforce/apex/dbu_homePageCategoryTileCtrl.getProdCategoryMedia';
import imagealttext from '@salesforce/label/c.dbu_imageAltTextVerbiage';
//-------------Importing Custom Labels----------------
import dbu_PartCategories from "@salesforce/label/c.dbu_PartCategories";
import dbu_ViewAllPartCategoriesBtn from "@salesforce/label/c.dbu_ViewAllPartCategoriesBtn";
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A';
export default class Dbu_cumminsPartsCategories extends NavigationMixin(LightningElement) {
    //  fleetGuardFilter = CumminsParts + '/Images/OnanOil.jpg';
    @track prodCategoryMediaArray = [];
    @track queue = [];
    @track queueMobile = [];
    @track counter = 0;
    @track screenLoaded = false;
    @track totalRecords;
    @track sendLocBackToChangeLocTile;
    @track isDesktopView = true;
    //  @track isMobileView = true;
    @track size;
    @track productListSize = 0;
    @track queueSize = 5;
    @track imgverb = imagealttext;
    //-------Custom Labels-----
    label = {
        dbu_PartCategories,
        dbu_ViewAllPartCategoriesBtn
    };
    connectedCallback() {
        let x = window.matchMedia("(max-width:768px)");
        if(x.matches){
            this.isDesktopView = false;
        }
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        // this.sendLocBackToChangeLocTile = url.searchParams.get("store");
        this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
        if (this.sendLocBackToChangeLocTile === undefined || this.sendLocBackToChangeLocTile === null) {
            this.sendLocBackToChangeLocTile = storeUSA;
        }
        console.log('this.sendLocBackToChangeLocTile====' + this.sendLocBackToChangeLocTile);

        this.getCategoryMedia();
    }

    getCategoryMedia() {
        let perfixURL = '/CSSNAStore/resource/';
        getProdCategoryMedia({

        })
            .then(result => {
                if (result) {
                    // this.totalRecords = result.length;
                    for (let i = 0; i < result.length; i++) {
                        let prodCategoryMediaObj = {};
                        console.log('==result ===' + result[i].ccrz__Category__r.Name);
                        console.log('===Id===' + result[i].ccrz__Category__c);
                        console.log('===locale===' + result[i].ccrz__Locale__c);
                        prodCategoryMediaObj['name'] = result[i].ccrz__Category__r.Name;
                        prodCategoryMediaObj['id'] = result[i].ccrz__Category__c;
                        prodCategoryMediaObj['locale'] = result[i].ccrz__Locale__c;
                        //--- URL Example -- /CSSNAStore/resource/CumminsParts/Images/OnanOil.jpg ----
                        prodCategoryMediaObj['mediaURL'] = perfixURL + '' + result[i].ccrz__StaticResourceName__c + '' + result[i].ccrz__FilePath__c;
                        console.log('==URL==' + perfixURL + '' + result[i].ccrz__StaticResourceName__c + '' + result[i].ccrz__FilePath__c);
                        this.prodCategoryMediaArray.push(prodCategoryMediaObj);
                    }
                    if (this.sendLocBackToChangeLocTile === 'US') {
                        this.prodCategoryMediaArray = this.prodCategoryMediaArray.filter(prodCategory => prodCategory.locale === 'en_US');

                    }
                    console.log('this.prodCategoryMediaArray=======' + this.prodCategoryMediaArray.length);
                    this.totalRecords = this.prodCategoryMediaArray.length;
                    this.size = this.prodCategoryMediaArray.length;
                    this.productListSize = this.prodCategoryMediaArray.length;
                    // this.max = this.size -1;
                    this.initializeQueue();

                    for (let i = 0; i < 10; i++) {
                        this.counter++;
                        this.queue.push(this.prodCategoryMediaArray[i]);
                    }
                }
            })
            .catch(error => {
                this.screenLoaded = false;
                this.error = error.status;
                console.error('==' + error);
            });
    }

    initializeQueue() {
        this.queueMobile = [];
        console.log('insise initialise>>>>');
        for (let i = 0; i < this.queueSize; i++) {
            this.queueMobile.push(this.prodCategoryMediaArray[i]);
        }
        console.log('MobileQue===' + this.queueMobile.length);


    }

    redirectToSubCategory(event) {
        this.screenLoaded = true;
        let categoryId = event.currentTarget.getAttribute('data-id');
        let categoryName = event.currentTarget.getAttribute('data-name');        
        console.log('categoryId======' + categoryId);
        if (categoryId !== '' && categoryId !== undefined) {
            let urlString = window.location.origin;
            let redirectURL = urlString + communityName + 'categories/' + categoryId  + '/'+ categoryName;
            //let redirectURL = urlString + communityName + 'categories?id=' + categoryId + '&store=' + this.sendLocBackToChangeLocTile;
            console.log('=======redirectURL====' + redirectURL);

            window.location.href = redirectURL;
            this.screenLoaded = false;
        }
    }

    handleClickNext() {
        this.queue = [];
        let localCounterNext;
        if (this.counter === this.totalRecords) {
            this.counter = 0;
            for (let i = 0; i < 10; i++) {
                this.counter++;
                this.queue.push(this.prodCategoryMediaArray[i]);
            }
            return;
        }

        console.log('Counter===' + this.counter);
        console.log('totalRecords===' + this.totalRecords);
        let remainingRecordCount = this.totalRecords - this.counter;
        if (remainingRecordCount > 10) {
            for (let i = this.counter; i < this.counter + 10; i++) {
                this.queue.push(this.prodCategoryMediaArray[i]);
                localCounterNext = i + 1;
            }
            this.counter = localCounterNext;
        } else {
            for (let i = this.counter; i < this.counter + remainingRecordCount; i++) {
                this.queue.push(this.prodCategoryMediaArray[i]);
                localCounterNext = i + 1;
            }
            this.counter = localCounterNext;
        }

    }

    handleClickPrev() {
        this.queue = [];
        let localCounterPrev;
        if (this.counter === 10) {
            let remains = this.totalRecords % 10;
            for (let i = (this.totalRecords - 1); i >= (this.totalRecords - remains); i--) {
                this.queue.push(this.prodCategoryMediaArray[i]);
                this.counter++;
            }
            return;
        }

        if (this.counter > 10) {
            let remainder = this.counter % 10;
            let prevPageIndex = (this.counter - remainder) - 10;
            console.log('prevPageIndex==' + prevPageIndex);
            for (let i = prevPageIndex; i < prevPageIndex + 10; i++) {
                this.queue.push(this.prodCategoryMediaArray[i]);
                localCounterPrev = i + 1;
            }
            this.counter = localCounterPrev;
            console.log('Counter in Prev==' + this.counter);
        }
    }

    handleAllPartCategories(event) {
        this.screenLoaded = true;
        let urlString = window.location.origin;
        let redirectURL = urlString + communityName + 'part-categories?store=' + this.sendLocBackToChangeLocTile;
        console.log('=======redirectURL====' + redirectURL);
        window.location.href = redirectURL;
        this.screenLoaded = false;

    }

    handleClickNextMobile() {
        if (this.queueMobile[this.queueSize - 1] != this.prodCategoryMediaArray[this.productListSize - 1]) {
            var itemIndex = this.prodCategoryMediaArray.indexOf(this.queueMobile[this.queueSize - 1]);
            if (itemIndex != this.prodCategoryMediaArray.length) {
                var itemToPush = this.prodCategoryMediaArray[itemIndex + 1];
                this.queueMobile.splice(0, 1);
                this.queueMobile.splice(this.queueSize - 1, 1, itemToPush);
            }
            else {
                var itemToPush = this.prodCategoryMediaArray[0];
                var itemToPop = this.queueMobile[0];
                this.queueMobile.splice(0, 1);
                this.queueMobile.splice(this.queueSize - 1, 1, itemToPush);
            }

        }
        else {
            var itemToPush = this.prodCategoryMediaArray[0];
            var itemToPop = this.queueMobile[0];
            this.queueMobile.splice(0, 1);
            this.queueMobile.splice(this.queueSize - 1, 1, itemToPush);
        }

    }

    handleClickPrevMobile() {
                    if(this.queueMobile[0]!=this.prodCategoryMediaArray[0])
                    {
                        var itemIndex = this.prodCategoryMediaArray.indexOf(this.queueMobile[0]);
                          var itemToPush = this.prodCategoryMediaArray[itemIndex - 1];
                          this.queueMobile.splice(this.queueSize - 1, 1);
                          this.queueMobile.splice(0,0, itemToPush);  
                    }
                    else{
                        var itemToPush = this.prodCategoryMediaArray[this.prodCategoryMediaArray.length - 1];
                        var itemToPop=this.queueMobile[0];
                        this.queueMobile.splice(this.queueSize - 1, 1);
                        this.queueMobile.splice(0,0, itemToPush);
                    }
                    
        } 

}