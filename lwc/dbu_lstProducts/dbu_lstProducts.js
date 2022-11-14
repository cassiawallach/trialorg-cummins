import { LightningElement, wire, track } from "lwc";
import pubsub from "c/pubsub";
import { NavigationMixin } from "lightning/navigation";
import { perfixCurrencyISOCode } from "c/serviceComponent";
import getSearchResultForESN from "@salesforce/apex/dbu_CCSearchExtension.getSearchResultForESN";
//custom labels
import communityName from "@salesforce/label/c.dbu_communityName";
import dbu_Filter_by from "@salesforce/label/c.dbu_Filter_by";
import dbu_Enter_ESN_Refine from "@salesforce/label/c.dbu_Enter_ESN_Refine";
import dbu_shopCart_apply from "@salesforce/label/c.dbu_shopCart_apply";
import dbu_Clear from "@salesforce/label/c.dbu_Clear";
import dbu_myAccount_home from "@salesforce/label/c.dbu_myAccount_home";
import dbu_Couldn_tFind from "@salesforce/label/c.dbu_Couldn_tFind";
import dbu_Found from "@salesforce/label/c.dbu_Found";
import dbu_results from "@salesforce/label/c.dbu_results";
import dbu_Show_per_page from "@salesforce/label/c.dbu_Show_per_page";
import dbu_Sort_By from "@salesforce/label/c.dbu_Sort_By";
import dbu_home_footer_sendUsYourQuestions from "@salesforce/label/c.dbu_home_footer_sendUsYourQuestions";
import dbu_home_footerCUMMINSTM from "@salesforce/label/c.dbu_home_footerCUMMINSTM";
import dbu_chatus from "@salesforce/label/c.dbu_chatus";
import dbu_NotFoundMSG from "@salesforce/label/c.dbu_NotFoundMSG";
import dbu_PhoneNumber from "@salesforce/label/c.dbu_contactnum";
import dbu_SearchCouldn_tFind from "@salesforce/label/c.dbu_SearchCouldn_tFind";
import dbu_Search_We_Sorry from "@salesforce/label/c.dbu_Search_We_Sorry";
import dbu_Search_Research from "@salesforce/label/c.dbu_Search_Research";
import dbu_Search_ShopNow from "@salesforce/label/c.dbu_Search_ShopNow";
import dbu_Search_Results from "@salesforce/label/c.dbu_Search_Results";
import dbu_applyAndClose from "@salesforce/label/c.dbu_applyAndClose";
//end custom labels
import getloginTime from "@salesforce/apex/dbu_IStToESTDateTimeDayConvevrsion.getloginTime";

import onlineText from "@salesforce/label/c.dbu_OnlineOfflineText";
import onlineRText from "@salesforce/label/c.dbu_OnlineOfflineresttext";
import offlinetext from "@salesforce/label/c.dbu_offlinetext";
import currencyCodeUSA from "@salesforce/label/c.dbu_home_store_country_currency_code_USA";
import currencyCodeCanada from "@salesforce/label/c.dbu_home_store_country_currency_code_Canada";
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import dbu_percentOff from '@salesforce/label/c.Dbu_percentOff';
import clearanceIcon from '@salesforce/resourceUrl/dbu_icons';
export default class dbu_LstProducts extends NavigationMixin(LightningElement) {
  @track sVal = "";
  @track enableinput = true;
  @track esnresult = [];
  @track finedesnresult = [];
  @track showfineesnresult = false;
  @track check = false;
  @track noesndata = false;
  @track findesnresult = [];

  @track pageLabel = "1";
  @track lstProduct = [];
  @track lstSearchProduct;
  @track sorteddata = [];
  @track sortedESNdata = [];
  @track sortESN = false;
  @track sort = false;
  @track isIdSearch = false;
  @track searchResult = [];
  @track isShowSearch = false;
  @track nodata = false;
  @track categories = [];
  @track aftersort = [];
  @track sfid;
  @track isLoading = true;
  @track baseURL;
  @track initialload;
  @track numbersortdata;
  @track listGridClass = "gridView";
  @track brands;
  @track sortoption;
  @track storeLocationText = "en-US";
  @track currencyValue = "USD";
  @track pageSize = 12;
  @track showESNRefine = false;
  @track userinput;
  @track locationstore;
  @track locationfromurl;
  @track price = "$0.00";

  @track productArray = [];
  @track productCopyArray = [];
  @track productCopyArrayMaster = [];

  @track LTime;
  @track enableDisableButton = false;
  @track OnlineOfflineText;
  @track offlineAtext = offlinetext;
  @track OnlineOfflineText1 = onlineText;
  @track OnlineOfflineText2 = onlineRText;
  @track OnlineOfflineRText;
  @track OnlineOfflineTextPh;
  @track OnlineOfflineRTextPh;
  @track contactUsURL;
  @track countryCurrencyCode;

  //custom labels
  @track filterbytxt;
  @track esnrefinetxt;
  @track applytxt;
  @track cleartxt;
  @track hometxt;
  @track couldnotfindtxt;
  @track foundtxt;
  @track resulttxt;
  @track showperpagetxt;
  @track sortbytxt;
  @track sendyourtxt;
  @track cumminstmtxt;
  @track chatustxt;
  @track notfoundtxt;
  @track phonetxt;
  @track searchcouldtxt;
  @track sorrytxt;
  @track researchtxt;
  @track shopnowtxt;
  @track SearchResulttxt;
  //end custom labels

  //try
  @track numberOfRecordsToDisplay = 12;
  @track maximumPageNumber;
  @track pageNumber = [];
  @track error;
  @track counter = 0;
  @track btnDisabledNext = false;
  @track btnDisabledPrev = false;

  @track VINProductInfo={};//lahari
  @track isVINSearch=false;//lahari
  @track clearanceImg = clearanceIcon+'/dbu_icons/dbu_saletag.svg';
  label={
    dbu_percentOff
};
  get ScreenLoaded() {
    return this.isLoading;
  }

  connectedCallback() {
    //custom labels
    this.filterbytxt = dbu_Filter_by;
    this.esnrefinetxt = dbu_Enter_ESN_Refine;
    this.applytxt = dbu_shopCart_apply;
    this.cleartxt = dbu_Clear;
    this.hometxt = dbu_myAccount_home;
    this.couldnotfindtxt = dbu_Couldn_tFind;
    this.foundtxt = dbu_Found;
    this.resulttxt = dbu_results;
    this.showperpagetx = dbu_Show_per_page;
    this.sortbytxt = dbu_Sort_By;
    this.sendyourtxt = dbu_home_footer_sendUsYourQuestions;
    this.cumminstmtxt = dbu_home_footerCUMMINSTM;
    this.chatustxt = dbu_chatus;
    this.notfoundtxt = dbu_NotFoundMSG;
    this.phonetxt = dbu_PhoneNumber;
    this.searchcouldtxt = dbu_SearchCouldn_tFind;
    this.sorrytxt = dbu_Search_We_Sorry;
    this.researchtxt = dbu_Search_Research;
    this.shopnowtxt = dbu_Search_ShopNow;
    this.SearchResulttxt = dbu_Search_Results;
    this.applyAndClose = dbu_applyAndClose;
    //end custom lables
    let locationURL = window.location.href;
    console.log("locationURL" + locationURL);
    var url = new URL(locationURL);
    // this.locationfromurl = url.searchParams.get("store");
    this.locationfromurl = window.sessionStorage.getItem("setCountryCode");
    console.log(" this.locationfromurl==>" + this.locationfromurl);
    this.baseURL = window.location.origin + communityName;
    this.contactUsURL =
      this.baseURL + "contact-us?store=" + this.locationfromurl;
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    this.userinput = urlParams.get("searchText");
    console.log("userinput" + this.userinput);
    this.register();
    //this.locationstore = window.location.href

    console.log("locationfromurl" + this.locationfromurl);
    if (this.locationfromurl == null || this.locationfromurl == "US") {
      this.locationfromurl = "US";
      this.countryCurrencyCode = currencyCodeUSA;
    } else if (this.locationfromurl == "EN") {
      this.locationfromurl = "EN";
      //this.currentLanguage = 'EN';
      this.countryCurrencyCode = currencyCodeCanada;
    } else if (this.locationfromurl == "FR") {
      this.locationfromurl = "FR";
      //this.currentLanguage = 'FR';
      this.countryCurrencyCode = currencyCodeCanada;
    }

    if (this.locationfromurl === "US") {
      this.currencyCode = "USD";
    } else if (this.locationfromurl === "EN" || this.locationfromurl === "FR") {
      this.currencyCode = "CAD";
      // this.locationfromurl = "CA";
    }
    //console.log('Search ESN product time START===='+window.performance.now());
    this.search();
    //console.log('Search ESN product time END===='+window.performance.now());

    getloginTime()
      .then((result) => {
        if (result) {
          console.log("result>>>" + JSON.stringify(result));
          this.LTime = result;
          console.log("this.LTime>>> " + this.LTime);
          if (this.LTime == "true") {
            this.enableDisableButton = false;
            console.log(
              "this.enableDisableButton>>> IF " + this.enableDisableButton
            );

            this.OnlineOfflineText = this.offlineAtext;
            console.log(
              "this.OnlineOfflineTextt>>> IF 55 " + this.OnlineOfflineText
            );
          }
          if (this.LTime == "false") {
            this.enableDisableButton = true;
            this.OnlineOfflineText = this.OnlineOfflineText1;
            this.OnlineOfflineRText = this.OnlineOfflineText2;
            this.OnlineOfflineTextPh = this.OnlineOfflineText1;
            this.OnlineOfflineRTextPh = this.OnlineOfflineText2;

            console.log("OnlineOfflineTextPh+++  " + OnlineOfflineTextPh);
            console.log(
              "this.OnlineOfflineText>>> ELSE 58 " + this.OnlineOfflineText
            );

            console.log(
              "this.OnlineOfflineText>>> ELSE 58 " + this.OnlineOfflineText
            );
            console.log(
              "this.OnlineOfflineText1>>> ELSE 59 " + this.OnlineOfflineText1
            );
            console.log(
              "this.enableDisableButton>>> ELSE " + this.enableDisableButton
            );
          }
        }
      })
      .catch((error) => {
        this.errorMessage = error.message;
        console.log("result from chat ", JSON.stringify(this.errorMessage));
      });
      this.pageLabel = !!window.sessionStorage.getItem('selectedPageNo1') ? window.sessionStorage.getItem('selectedPageNo1') : 1;
  }

  sendFeedToGoogleAnalyticsComponent(searchFeed) {
    let totalUrl = window.location.search;
    const allurlParams = new URLSearchParams(totalUrl);
    let searchkeystring = allurlParams.get("searchText");
    window.localStorage.setItem('CurrentGAlistname', 'Search key - ' + searchkeystring );
    invokeGoogleAnalyticsService('SEARCH DATA RETURNED', { searchKey: searchkeystring, dataReturned: searchFeed,currencycode : this.currencyCode, dataReturned : searchFeed });
  }

  search() {
    console.log("Search ESN product time START====" + window.performance.now());
     //lahari start
     const queryString = window.location.search;
     const urlParams = new URLSearchParams(queryString);
     this.searchedval = urlParams.get("searchText");
     this.isVINSearch= this.searchedval.trim().length==17?true:false;
     //lahari end
    this.isLoading = true;
    getSearchResultForESN({
      urlParam: window.location.href
    })
      .then((result) => {
        //console.log('gsndata'+result.gsnProducts.systemOptions[0].optionList[0].optionNo);
        this.isLoading = false;
          this.searchResult = JSON.parse(JSON.stringify(result.products));
          this.categories = result.Categories;
          this.brands = result.Brands;
          this.searchResultCount = this.searchResult.length;
          this.isIdSearch = result.isIdSearch;
          this.VINProductInfo = result.VINProductInfo;//lahari
          console.log('result.searchresult'+result.products);
          console.log('Search Result',JSON.parse(JSON.stringify(result.products)));
          let i = 0;
          let orderrecordarray = [];
          //for(i=0;i<data.length;i++)
          for (i = 0; i < this.searchResult.length; i++) {
            console.log('inside for loop');
            let orderrecord = {};
            orderrecord["id"] = this.searchResult[i].sfid;
            orderrecord["sfdcName"] = this.searchResult[i].sfdcName;
            if(this.searchResult[i].promotionTag != undefined){
              orderrecord["promotionTag"] = this.searchResult[i].promotionTag;
              console.log('sfdcName promo', this.searchResult[i].sfdcName);
              console.log('Inside promotionTag');
            }
            console.log('promotion category',orderrecord["promotionTag"]);
            // orderrecord['price'] = this.searchResult[i].price;
            this.price = this.searchResult[i].price;
            if (this.price != null && this.price != "" && this.price != undefined) {
              orderrecord["price"] = perfixCurrencyISOCode(this.currencyCode,this.price);
              orderrecord["gtmPrice"] = JSON.stringify(this.searchResult[i].price);/*CECI-958 GTM Events*/
              let productPrice = this.searchResult[i].price;
              let originalProdPrice = this.searchResult[i].originalPrice;
              if((productPrice == originalProdPrice) || (this.searchResult[i].discountPercentage == 0)){
                  orderrecord["isOriginalPrice"] = false; 
                  console.log('in isOriginalPrice false',orderrecord["isOriginalPrice"]);
              }
              else if(originalProdPrice !== productPrice && originalProdPrice > productPrice){
                  orderrecord["isOriginalPrice"] = true;
                  orderrecord["originalPrice"] = perfixCurrencyISOCode(this.currencyCode,originalProdPrice);
                  // this.productTileDetails.originalPrice = productElement.originalPrice;
                  console.log('in isOriginalPrice true',orderrecord["isOriginalPrice"]);
              }
            }
            let discPer = this.searchResult[i].discountPercentage;
            console.log('discountPercentage in lstProducts', discPer);
            if(discPer !=0 && discPer > 0 ) {
              console.log('checking discount > 0')
              console.log('discPer',discPer)
              orderrecord['discPercent'] = discPer;
              // console.log('orderrecord["discountPercentage"]',orderrecord["discPercent"])
            }
            orderrecord["shortDesc"] = this.searchResult[i].shortDesc;
            orderrecord["invstatus"] = this.searchResult[i].invstatus;
            orderrecord["URI"] = this.searchResult[i].URI;
            orderrecord["ProductCategory"] = this.searchResult[i].ProductCategory;
            orderrecord["ProductBrand"] = this.searchResult[i].ProductBrand;
            orderrecord["SKU"] = this.searchResult[i].SKU;/*CECI-958 GTM Events*/

            orderrecordarray.push(orderrecord);
            window.console.log("i=>" + i);

            // console.log('orderrecordarray in wire'+orderrecordarray.length);
          }
          this.numbersortdata = orderrecordarray;
          
          console.log('orderrecordarray esn > ' + JSON.stringify(orderrecordarray));
          console.log('orderrecordarray size > ' + orderrecordarray.length);
          this.sendFeedToGoogleAnalyticsComponent(orderrecordarray);

          this.productArray = this.numbersortdata;
          this.productCopyArray = this.numbersortdata;
          this.preparePagination();

          console.log(
            "this.numbersortdata intial load" + this.numbersortdata.length
          );
          // let i=0;
          console.log('orderrecordarray.length', orderrecordarray.length);
          console.log(".length==>" + this.searchResult.length);
          if (orderrecordarray === null || orderrecordarray.length == 0) {
            this.nodata = true;
            // let url = window.location.href;
            //this.searchedval = url.substring(76);
            const queryString = window.location.search;
            const urlParams = new URLSearchParams(queryString);
            this.searchedval = urlParams.get("searchText");
            console.log(this.searchedval);
          }
          const queryString = window.location.search;
          const urlParams = new URLSearchParams(queryString);
          this.searchedval = urlParams.get("searchText");
          console.log("categories data " + JSON.stringify(this.categories));
          console.log("searchresult data " + JSON.stringify(this.searchResult));
        setTimeout(() => {
          this.template
            .querySelector(".pgNums")
            .firstElementChild.classList.add("pgSelct");
        }, 500);
        console.log(
          "Search ESN product time END====" + window.performance.now()
        );
      })
      .catch((error) => {
        this.isLoading = false;
        this.nodata = true;
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        this.searchedval = urlParams.get("searchText");
        this.error = error;
        this.searchResult = undefined;
        this.sendFeedToGoogleAnalyticsComponent(this.searchResultl);    
        console.log("errorinsearchresult==>", this.error);
      });
  }

  
  /*@wire(getSearchResultForESN, { urlParam: window.location.href })
  wireSearch({ data, error }) {
    if (data) {
      this.isLoading = false;
      this.searchResult = data.products;
      this.categories = data.Categories;

    
      this.brands = data.Brands;

      this.searchResultCount = this.searchResult.length;

      let i = 0;
      let orderrecordarray = [];
      //for(i=0;i<data.length;i++)
      for (i = 0; i < this.searchResult.length; i++) {
        
          let orderrecord = {};
          orderrecord["id"] = this.searchResult[i].sfid;
          orderrecord["sfdcName"] = this.searchResult[i].sfdcName;
          // orderrecord['price'] = this.searchResult[i].price;
          this.price = this.searchResult[i].price;
          if (
            this.price != null &&
            this.price != "" &&
            this.price != undefined
          ) {
            orderrecord["price"] =  perfixCurrencyISOCode(this.currencyCode,this.price);
          }

          orderrecord["shortDesc"] = this.searchResult[i].shortDesc;
          orderrecord["invstatus"] = this.searchResult[i].invstatus;
          orderrecord["URI"] = this.searchResult[i].URI;
          orderrecord["ProductCategory"] = this.searchResult[i].ProductCategory;
          orderrecord["ProductBrand"] = this.searchResult[i].ProductBrand;

          orderrecordarray.push(orderrecord);
          window.console.log("i=>" + i);
        
        // console.log('orderrecordarray in wire'+orderrecordarray.length);
      }
      this.numbersortdata = orderrecordarray;
      this.productArray = this.numbersortdata;
      this.productCopyArray = this.numbersortdata;
      this.preparePagination();

      console.log(
        "this.numbersortdata intial load" + this.numbersortdata.length
      );
      // let i=0;

      console.log(".length==>" + this.searchResult.length);
      if (orderrecordarray === null || orderrecordarray.length == 0) {
        this.nodata = true;
        // let url = window.location.href;
        //this.searchedval = url.substring(76);
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        this.searchedval = urlParams.get("searchText");
        console.log(this.searchedval);
      }
      const queryString = window.location.search;
      const urlParams = new URLSearchParams(queryString);
      this.searchedval = urlParams.get("searchText");
      console.log("categories data " + JSON.stringify(this.categories));
      console.log("searchresult data " + JSON.stringify(this.searchResult));

      setTimeout(() => {
        this.template.querySelector(".pgNums").firstElementChild.classList.add('pgSelct');
    }, 500);

    } else if (error) {
      this.isLoading = false;
      this.nodata = true;
      const queryString = window.location.search;
      const urlParams = new URLSearchParams(queryString);
      this.searchedval = urlParams.get("searchText");
      this.error = error;
      this.searchResult = undefined;
      console.log("errorinsearchresult==>", this.error);
    }
  }

*/
  handleinputchnage(event) {
    this.sVal = event.target.value;
    console.log("sval" + this.sVal);
  }
  handleesnchekbox(event) {
    this.check = event.target.checked;
    console.log("check" + this.check);
    if (this.check) {
      this.enableinput = false;
    } else {
      this.enableinput = true;
      this.showfineesnresult = false;
      this.sVal = "";
    }
  }

  register() {
    console.log("event registered in lst product details");
    pubsub.register("sendDataTolstProducts", this.handleEventLoc.bind(this));
  }

  handleEventLoc(event) {
    this.locationstore = event;
    console.log(" this.locationstore" + this.locationstore);
  }

  handleclickesn() {
    if (this.check == true && this.searchResult.length > 0) {
      console.log("calling handleESN");
      this.getesndata();
    } else {
      this.nodata = true;
    }
  }
  getesndata() {
    this.isLoading = true;
    getSearchResultForESN({
      urlParam: this.sVal
    })
      .then((result) => {
        this.isLoading = false;
        this.esnresult = result;
        this.isIdSearch = result.isIdSearch;
        this.showESNRefine = true;
        this.esndata = [];
        this.esndata = this.esnresult.products;
        console.log("ESN Result" + JSON.stringify(this.esnresult));
        console.log("esn result length " + this.esnresult.products.length);
        console.log("this.userinput" + this.userinput);

        var productMap = new Map();
        for (let i = 0; i < this.searchResult.length; i++) {
          productMap.set(this.searchResult[i].sfid, this.searchResult[i]);
        }

        if (this.esnresult.length !== 0) {
          this.showfineesnresult = true;
          console.log("inside if sort ");
          this.finedesnresult = this.esndata.filter(({ sfdcName }) => (sfdcName = this.userinput)
          );
          console.log("catdata Result" + JSON.stringify(this.finedesnresult));

          if (this.finedesnresult.length == 0) {
            this.noesndata = true;
          } else {
            let i = 0;
            let orderrecordarray = [];
            //for(i=0;i<data.length;i++)
            for (i = 0; i < this.finedesnresult.length; i++) {
              if (i != 12) {
                let orderrecord = {};
                if (productMap.has(this.finedesnresult[i].sfid)) {
                  orderrecord["id"] = productMap.get(this.finedesnresult[i].sfid).sfid;
                  orderrecord["sfdcName"] = productMap.get(this.finedesnresult[i].sfid).sfdcName;
                  orderrecord["shortDesc"] = productMap.get(this.finedesnresult[i].sfid).shortDesc;
                  orderrecord["invstatus"] = productMap.get(this.finedesnresult[i].sfid).invstatus;
                  orderrecord["URI"] = productMap.get(this.finedesnresult[i].sfid).URI;
                  orderrecord["SKU"] = productMap.get(this.finedesnresult[i].sfid).SKU;/*CECI-958 GTM Events*/
                  orderrecord["gtmPrice"] = JSON.stringify(productMap.get(this.finedesnresult[i].sfid).price);/*CECI-958 GTM Events*/
                  // orderrecord["price"] =  productMap.get(this.finedesnresult[i].sfid).price;
                  if(this.finedesnresult[i].promotionTag != undefined){
                    orderrecord["promotionTag"] = this.finedesnresult[i].promotionTag;
                    console.log('sfdcName promo ', this.finedesnresult[i].sfdcName);
                    console.log('Inside promotionTag ESNsearch Result');
                  }
                  if (this.finedesnresult[i].price != null) {
                    this.price = productMap.get(this.finedesnresult[i].sfid).price;

                    orderrecord["price"] = this.price.toLocaleString(this.storeLocationText,
                      {
                        style: "currency",
                        currency: this.countryCurrencyCode,
                        minimumFractionDigits: 2,
                        maximumFractionDigits: 2
                      }
                    );
                    let productPrice = this.finedesnresult[i].price;
                    let originalProdPrice = this.finedesnresult[i].originalPrice;
                    if((productPrice == originalProdPrice) || (this.finedesnresult[i].discountPercentage == 0)){
                        orderrecord["isOriginalPrice"] = false; 
                        console.log('in isOriginalPrice false',orderrecord["isOriginalPrice"]);
                    }
                    else if(originalProdPrice !== productPrice && originalProdPrice > productPrice){
                        orderrecord["isOriginalPrice"] = true;
                        orderrecord["originalPrice"] = originalProdPrice.toLocaleString(this.storeLocationText,
                          {
                            style: "currency",
                            currency: this.countryCurrencyCode,
                            minimumFractionDigits: 2,
                            maximumFractionDigits: 2
                          }
                        )
                        console.log('in isOriginalPrice true',orderrecord["isOriginalPrice"]);
                    }
                  }
                  let discPer = this.finedesnresult[i].discountPercentage;
                  console.log('discountPercentage in lstProducts', discPer);
                  if(discPer !=0 && discPer > 0 ) 
                    orderrecord['discPercent'] = discPer;
                  
                  orderrecordarray.push(orderrecord);

                  console.log('orderrecordarray esn 2 > ' + JSON.stringify(orderrecordarray));
                  console.log('orderrecordarray size 2 > ' + orderrecordarray.length);
                    this.sendFeedToGoogleAnalyticsComponent(orderrecordarray);                   
                  // console.log('it has product'+price);
                }

                window.console.log("i=>" + i);
              } else {
                break;
              }
              // console.log('orderrecordarray in wire'+orderrecordarray.length);
            }
            this.findesnresult = orderrecordarray;
            //this. = orderrecordarray;
            console.log("calling handleESN findesnresult" + this.findesnresult);
            this.noesndata = false;
          }
        }
      })
      .catch((error) => {
      //  this.sendFeedToGoogleAnalyticsComponent(null);
        this.error = error.message;
        console.log("error" + this.error);
      });
  }

  handleclear() {
    this.showfineesnresult = false;
    this.sVal = "";
    this.sortESN = false;
    this.noesndata = false;
    this.showESNRefine = false;
    this.check = false;
    //  this.enableinput = false;
  }

  //ShowPerPage  - Raghava
  showCount = "12";
  get showPerPage() {
    return [
      { label: "12", value: "12" },
      { label: "24", value: "24" },
      { label: "48", value: "48" }
    ];
  }
  handleChange1(event) {
    console.log("====" + event.target.value);
    this.numberOfRecordsToDisplay = event.target.value;
    this.preparePagination();
  }
  handleRecordsPerPage(event) {
    this.pageSize = event.target.value;
    console.log("  this.pageSize" + this.pageSize);
    console.log("this.searchResult.length" + this.searchResult.length);
    let i = 0;
    let orderrecordarray = [];
    //for(i=0;i<data.length;i++)
    for (i = 0; i < this.searchResult.length; i++) {
      if (i != this.pageSize) {
        let orderrecord = {};
        orderrecord["id"] = this.searchResult[i].sfid;
        orderrecord["sfdcName"] = this.searchResult[i].sfdcName;
        if(this.searchResult[i].promotionTag != undefined) {
          orderrecord["promotionTag"] = this.searchResult[i].promotionTag;
        }
        this.price = this.searchResult[i].price;

        if (this.price == null || this.price == "") {
          orderrecord["price"] = this.price;
        } else {
          if (this.price != null && this.price != "") {
            orderrecord["price"] = this.price.toLocaleString(
              this.storeLocationText,
              {
                style: "currency",
                currency: this.countryCurrencyCode,
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
              }
            );
            let productPrice = this.searchResult[i].price;
            let originalProdPrice = this.searchResult[i].originalPrice;
            if((productPrice == originalProdPrice) || (this.searchResult[i].discountPercentage == 0)){
                orderrecord["isOriginalPrice"] = false; 
                console.log('in isOriginalPrice false',orderrecord["isOriginalPrice"]);
            }
            else if(originalProdPrice !== productPrice && originalProdPrice > productPrice){
                orderrecord["isOriginalPrice"] = true;
                orderrecord["originalPrice"] = originalProdPrice.toLocaleString(this.storeLocationText,
                  {
                    style: "currency",
                    currency: this.countryCurrencyCode,
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                  }
                )
                console.log('in isOriginalPrice true',orderrecord["isOriginalPrice"]);
            }
          }
        }
        let discPer = this.searchResult[i].discountPercentage;
          console.log('discountPercentage in lstProducts', discPer);
          if(discPer !=0 && discPer > 0 ) {
            orderrecord['discPercent'] = discPer;
          }
        orderrecord["shortDesc"] = this.searchResult[i].shortDesc;
        orderrecord["invstatus"] = this.searchResult[i].invstatus;
        orderrecord["URI"] = this.searchResult[i].URI;
        orderrecord["ProductCategory"] = this.searchResult[i].ProductCategory;

        orderrecordarray.push(orderrecord);
        // window.console.log('i=>'+i);
      } else {
        break;
      }
    }
    console.log("orderrecordarray size " + orderrecordarray);
    console.log("qty" + this.sortoption);
    if (
      this.sortoption === "lowprice" ||
      this.sortoption === "highprice" ||
      this.sortoption === "stock"
    ) {
      if (this.sortoption === "lowprice") {
        let reverse = false;
        let data_clone = JSON.parse(JSON.stringify(this.searchResult));
        console.log("BEFORE data_clone:" + JSON.stringify(data_clone));

        this.numbersortdataaa = data_clone.sort(this.sortBy("price", reverse));
        console.log(
          "this.numbersortdataaa" + JSON.stringify(this.numbersortdataaa)
        );
        //added later
        let orderrecorda = [];
        for (i = 0; i < this.numbersortdataaa.length; i++) {
          if (i != this.pageSize) {
            let orderrecord = {};
            orderrecord["id"] = this.numbersortdataaa[i].sfid;
            orderrecord["sfdcName"] = this.numbersortdataaa[i].sfdcName;
            this.price = this.numbersortdataaa[i].price;
            if (this.price != null && this.price != "") {
              orderrecord["price"] = this.price.toLocaleString(
                this.storeLocationText,
                {
                  style: "currency",
                  currency: this.countryCurrencyCode,
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                }
              );
            }

            orderrecord["shortDesc"] = this.numbersortdataaa[i].shortDesc;
            orderrecord["invstatus"] = this.numbersortdataaa[i].invstatus;
            orderrecord["URI"] = this.numbersortdataaa[i].URI;
            orderrecord["ProductCategory"] = this.numbersortdataaa[
              i
            ].ProductCategory;

            orderrecorda.push(orderrecord);
            window.console.log("i=>" + i);
          } else {
            break;
          }
        }
        this.numbersortdata = orderrecorda;
        //added later end
      }
      if (this.sortoption === "highprice") {
        let reverse = true;
        let data_clone = JSON.parse(JSON.stringify(this.searchResult));
        console.log("BEFORE data_clone:" + JSON.stringify(data_clone));
        //this.sorteddata = data_clone.sort(this.sortBy('price', reverse));
        this.numbe = data_clone.sort(this.sortBy("price", reverse));

        let order = [];
        for (i = 0; i < this.numbe.length; i++) {
          if (i != this.pageSize) {
            let orderrecord = {};
            orderrecord["id"] = this.numbe[i].sfid;
            orderrecord["sfdcName"] = this.numbe[i].sfdcName;
            this.price = this.numbe[i].price;
            if (this.price != null && this.price != "") {
              orderrecord["price"] = this.price.toLocaleString(
                this.storeLocationText,
                {
                  style: "currency",
                  currency: this.countryCurrencyCode,
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                }
              );
            }

            orderrecord["shortDesc"] = this.numbe[i].shortDesc;
            orderrecord["invstatus"] = this.numbe[i].invstatus;
            orderrecord["URI"] = this.numbe[i].URI;
            orderrecord["ProductCategory"] = this.numbe[i].ProductCategory;

            order.push(orderrecord);
            //  window.console.log('i=>'+i);
          } else {
            break;
          }
        }
        this.numbersortdata = order;
      }

      if (this.sortoption === "stock") {
        this.numbersortdata = orderrecordarray.filter(
          ({ invstatus }) => invstatus == "In Stock"
        );
        // this.numbersortdata = data_clone.sort(this.sortBy('price', reverse));
      }
    } else {
      this.numbersortdata = orderrecordarray;
    }
  }

  //Filter Active Selection - Raghava
  activeSections = ["category"];
  handleSectionToggle(event) {
    const openSections = event.detail.openSections;
  }

  handleClick(event) {
    window.console.log("Clicked on the product");

    this.sfid = event.currentTarget.getAttribute("data-sfid");
    this.sfdcname = event.currentTarget.getAttribute("data-sfdcname");
    console.log("getattr sfid " + event.currentTarget.getAttribute("data-sfid"));
    console.log("getattr availstock " + event.currentTarget.getAttribute('data-productstock'));  
    let currenctProductInventory = event.currentTarget.getAttribute('data-productstock');
    console.log("getattr pricing " + event.currentTarget.getAttribute('data-pricing'));
    let currenctProductPrice = event.currentTarget.getAttribute('data-pricing');
    console.log("getattr searched key " + this.searchedval);
    console.log('product cat > ' + event.currentTarget.getAttribute('data-category'));
    let currenctProductCategory = event.currentTarget.getAttribute('data-category');    
    
    console.log(
      "getattr name " + event.currentTarget.getAttribute("data-sfdcName")
    );
    console.log("locationfromurl353" + this.locationfromurl);


    let productFeedForGoogleAnalytics = {
      ProductID : this.sfid,
      productName : this.sfdcname,
      ProductInventoryStatus : currenctProductInventory,
      ProductPrice : currenctProductPrice,
      searchKey : this.searchedval,
      ProductCategory : currenctProductCategory
     };

    console.log('productFeedForGoogleAnalytics > ' + productFeedForGoogleAnalytics);
    invokeGoogleAnalyticsService('SEARCH PAGE PRODUCT CLICKED' , productFeedForGoogleAnalytics);     

    let urlString = window.location.origin;
			window.location.href = urlString + communityName +'product/'+this.sfid +'/'+ this.sfdcname+'/?store='+this.locationfromurl;
    // window.location.href =
    //   urlString +
    //   communityName +
    //   "product?name=+" +
    //   this.sfdcname +
    //   "&pId=" +
    //   this.sfid +
    //   "&store=" +
    //   this.locationfromurl;
    let prodName = this.sfdcname;
    if(prodName.includes(" ")){
      prodName =  prodName.replace(/\s+/g, '-').toLowerCase();
  }
      if(prodName.includes('/')){
        prodName = prodName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
      }
			window.location.href = urlString + communityName +'product/'+this.sfid +'/'+ prodName+'/?store='+this.locationfromurl;
      
    //urlString + communityName + "product?pId=" + this.sfid ;
  }

  //saikomal
  sortName = "arrival";

  get sortOptions() {
    return [
      { label: "Featured", value: "arrival" },
      { label: "In Stock", value: "stock" },
      { label: "Low-High Price", value: "lowprice" },
      { label: "High-Low Price", value: "highprice" }
    ];
  }

  sortBy(field, reverse, primer) {
    console.log("Sort by:reverse:" + reverse);

    var key = function (x) {
      return primer ? primer(x[field]) : x[field];
    };

    return function (a, b) {
      var A = key(a),
        B = key(b);

      if (A === undefined) A = "";
      if (B === undefined) B = "";

      return (A < B ? -1 : A > B ? 1 : 0) * [1, -1][+!!reverse];
    };
  }

  handleChange() {
    console.log("searchresult");

    var sortedArray = [];
    const localArray = [...this.sorteddata];
    for (let i = 0; i < localArray.length; i++) {
      // console.log('====' + localArray[i].price);
      if (localArray[i].price !== undefined) {
        sortedArray.push(localArray[i]);
      }
    }

    if (this.selectedOption == "Low-High") {
      if (sortedArray != null) {
        sortedArray.sort(function (a, b) {
          if (b.price !== undefined && a.price !== undefined) {
            console.log("Inside lowprice return>>> ");
            return (
              a.price.replace(/[^\d\.]/g, "") - b.price.replace(/[^\d\.]/g, "")
            );
          }
        });
      }
    }
    if (this.selectedOption == "High-Low") {
      console.log("Inside highprice>>> ");
      sortedArray.sort(function (a, b) {
        if (b.price !== undefined && a.price !== undefined) {
          return (
            b.price.replace(/[^\d\.]/g, "") - a.price.replace(/[^\d\.]/g, "")
          );
        }
      });
    }
    this.aftersort = sortedArray;
    let i = 0;
    let orderrecordarray = [];
    //for(i=0;i<data.length;i++)
    for (i = 0; i < this.aftersort.length; i++) {
      if (i != this.pageSize) {
        let orderrecord = {};
        orderrecord["id"] = this.aftersort[i].sfid;
        orderrecord["sfdcName"] = this.aftersort[i].sfdcName;
        orderrecord["price"] = this.aftersort[i].price;
        orderrecord["shortDesc"] = this.aftersort[i].shortDesc;
        orderrecord["invstatus"] = this.aftersort[i].invstatus;
        orderrecord["URI"] = this.aftersort[i].URI;
        orderrecord["ProductCategory"] = this.aftersort[i].ProductCategory;
        orderrecord['discPercent'] = this.aftersort[i].discPercent;
        orderrecord["isOriginalPrice"] = this.aftersort[i].isOriginalPrice;
        orderrecord["originalPrice"] = this.aftersort[i].originalPrice;
        orderrecord["promotionTag"] = this.aftersort[i].promotionTag;
        orderrecordarray.push(orderrecord);
        // window.console.log('i=>'+i);
      } else {
        break;
      }
      // console.log('this numbersort final'+this.numbersortdata);
    }
    this.sorteddata = orderrecordarray;
    console.log("final" + this.sorteddata);
  }

  handlecategory(event) {
    console.log("category" + event.target.getAttribute("data-id"));
    this.selectedcategory = event.target.getAttribute("data-id");
    this.inputval = event.target.checked;
    console.log("this.inputval" + this.inputval);

    if (event.target.checked) {
      console.log("  this.pageSize" + this.pageSize);
      console.log(
        "inside else sort numbersortdata length" + this.numbersortdata.length
      );
      console.log(this.inputval);
      console.log("this.searchResult" + this.searchResult);

      this.catdata = this.searchResult.filter(({ ProductCategory }) =>
        ProductCategory.includes(this.selectedcategory)
      );

      console.log(" this.catdata" + this.catdata);
      this.sort = true;

      /*saikomal added later */
      let i = 0;
      let orderrecordarray = [];
      //for(i=0;i<data.length;i++)
      for (i = 0; i < this.catdata.length; i++) {
        if (i != this.pageSize) {
          //  console.log('inside if'+this.searchResult[i].price;)
          let orderrecord = {};
          orderrecord["id"] = this.catdata[i].sfid;
          orderrecord["sfdcName"] = this.catdata[i].sfdcName;
          if(this.catdata[i].promotionTag != undefined) {
            orderrecord["promotionTag"] = this.catdata[i].promotionTag;
            console.log('sfdcName promo ', this.catdata[i].sfdcName);
            console.log('Inside promotionTag handlecategory Result');
          }
          this.price = this.catdata[i].price;
          console.log("let price " + this.price);
          if (this.price != null && this.price != "") {
            orderrecord["price"] = this.price.toLocaleString(
              this.storeLocationText,
              {
                style: "currency",
                currency: this.countryCurrencyCode,
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
              }
            );
            let productPrice = this.catdata[i].price;
            let originalProdPrice = this.catdata[i].originalPrice;
            if((productPrice == originalProdPrice) || (this.catdata[i].discountPercentage == 0)){
                orderrecord["isOriginalPrice"] = false; 
                console.log('in isOriginalPrice false',orderrecord["isOriginalPrice"]);
            }
            else if(originalProdPrice !== productPrice && originalProdPrice > productPrice){
                orderrecord["isOriginalPrice"] = true;
                orderrecord["originalPrice"] = originalProdPrice.toLocaleString(this.storeLocationText,
                  {
                    style: "currency",
                    currency: this.countryCurrencyCode,
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                  }
                )
                console.log('in isOriginalPrice true',orderrecord["isOriginalPrice"]);
            }
          }
          let discPer = this.catdata[i].discountPercentage;
          console.log('discountPercentage in lstProducts', discPer);
          if(discPer !=0 && discPer > 0 ) {
            console.log('checking discount > 0')
            console.log('discPer',discPer)
            orderrecord['discPercent'] = discPer;
          }
          orderrecord["shortDesc"] = this.catdata[i].shortDesc;
          orderrecord["invstatus"] = this.catdata[i].invstatus;
          orderrecord["URI"] = this.catdata[i].URI;
          orderrecord["ProductCategory"] = this.catdata[i].ProductCategory;
          orderrecordarray.push(orderrecord);
        } else {
          break;
        }
      }
      this.sorteddata = orderrecordarray;

      if (this.sorteddata === null || this.sorteddata.length === 0) {
        this.nodata = true;
      }
      console.log("  this.pageSize" + this.pageSize);
      console.log("filteredUsers" + JSON.stringify(this.sorteddata));
    } else {
      console.log("inside else sort");
      console.log(
        "inside else sort numbersortdata length" + this.numbersortdata.length
      );
      this.sorteddata = null;
      this.nodata = false;
      this.sort = false;
      this.numbersortdata = this.numbersortdata;
      console.log(
        "this.sorteddata else sort" + JSON.stringify(this.numbersortdata)
      );
    }
  }
  handlebrand(event) {
    console.log("brand" + event.target.getAttribute("data-id"));
    this.selectedcategory = event.target.getAttribute("data-id");
    this.inputval = event.target.checked;
    console.log("this.inputval" + this.inputval);

    if (event.target.checked) {
      this.brandddata = this.searchResult.filter(({ ProductBrand }) =>
        ProductBrand.includes(this.selectedcategory)
      );
      console.log("this.brandddata" + this.brandddata.length);
      this.sort = true;

      /*saikomal added later */
      let i = 0;
      let orderrecordarray = [];
      //for(i=0;i<data.length;i++)
      for (i = 0; i < this.brandddata.length; i++) {
        if (i != this.pageSize) {
          //  console.log('inside if'+this.searchResult[i].price;)
          let orderrecord = {};
          orderrecord["id"] = this.brandddata[i].sfid;
          orderrecord["sfdcName"] = this.brandddata[i].sfdcName;
          if(this.brandddata[i].promotionTag != undefined) {
            orderrecord["promotionTag"] = this.brandddata[i].promotionTag;
            console.log('sfdcName promo ', this.brandddata[i].sfdcName);
            console.log('Inside promotionTag handlecategory Result');
          }
          this.price = this.brandddata[i].price;
          console.log("let price " + this.price);
          if (this.price != null && this.price != "") {
            orderrecord["price"] = this.price.toLocaleString(
              this.storeLocationText,
              {
                style: "currency",
                currency: this.countryCurrencyCode,
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
              }
            );
            let productPrice = this.brandddata[i].price;
            let originalProdPrice = this.brandddata[i].originalPrice;
            if((productPrice == originalProdPrice) || (this.brandddata[i].discountPercentage == 0)){
                orderrecord["isOriginalPrice"] = false; 
                console.log('in isOriginalPrice false',orderrecord["isOriginalPrice"]);
            }
            else if(originalProdPrice !== productPrice && originalProdPrice > productPrice){
                orderrecord["isOriginalPrice"] = true;
                orderrecord["originalPrice"] = originalProdPrice.toLocaleString(this.storeLocationText,
                  {
                    style: "currency",
                    currency: this.countryCurrencyCode,
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                  }
                )
                console.log('in isOriginalPrice true',orderrecord["isOriginalPrice"]);
            }
          }
          let discPer = this.brandddata[i].discountPercentage;
          console.log('discountPercentage in lstProducts', discPer);
          if(discPer !=0 && discPer > 0 ) {
            console.log('checking discount > 0')
            console.log('discPer',discPer)
            orderrecord['discPercent'] = discPer;
          }
          orderrecord["shortDesc"] = this.brandddata[i].shortDesc;
          orderrecord["invstatus"] = this.brandddata[i].invstatus;
          orderrecord["URI"] = this.brandddata[i].URI;
          orderrecord["ProductCategory"] = this.brandddata[i].ProductCategory;
          orderrecordarray.push(orderrecord);
        } else {
          break;
        }
      }
      this.sorteddata = orderrecordarray;
      if (this.sorteddata === null || this.sorteddata.length === 0) {
        this.nodata = true;
      }
    } else {
      console.log("inside else sort");
      console.log(
        "inside else sort numbersortdata length" + this.numbersortdata.length
      );
      this.sorteddata = null;
      this.nodata = false;
      this.sort = false;
      this.productArray = this.productArray;
      console.log(
        "this.sorteddata else sort" + JSON.stringify(this.numbersortdata)
      );
    }
  }
  /////////////////////try///////////////////////
  //-----------Pagination Logic----------
  preparePagination() {
    this.productArray = [];
    this.pageNumber = [];
    this.counter = 0;
    this.maximumPageNumber = Math.ceil(
      this.productCopyArray.length / this.numberOfRecordsToDisplay
    );
    console.log("=maximumPageNumber==" + this.maximumPageNumber);
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
    console.log("counter==" + this.counter);
    this.pageNumber = [];
    let remainingPage = this.maximumPageNumber - this.counter;
    console.log("Remaining==" + remainingPage);
    if (remainingPage >= 6) {
      console.log("IF");
      for (let i = this.counter; i < this.counter + 6; i++) {
        this.pageNumber.push(i + 1);
        localCounterNext = i + 1;
      }
      this.counter = localCounterNext;
    } else {
      console.log("ELSE");
      console.log("CC===" + this.counter);
      for (let i = this.counter; i < this.maximumPageNumber; i++) {
        this.pageNumber.push(i + 1);
        localCounterNext = i + 1;
      }
      this.counter = localCounterNext;
    }
    console.log("FInal counter==" + this.counter);
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
    console.log("remainingCount==" + remainingCount);

    if (remainingCount > 6) {
      for (let i = remainingCount; i < remainingCount + 6; i++) {
        this.pageNumber.push(i);
        localCounterPrev = i;
      }
    } else {
      var finalIndex = this.counter - remainingCount;
      console.log("Inedx==" + finalIndex);
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
    var selClass = this.template.querySelectorAll(".pgSelct");

    for (var s = 0; s < selClass.length; s++) {
      selClass[s].classList.remove("pgSelct");
    }
    event.currentTarget.classList.add("pgSelct");
    this.productArray = [];
    console.log("CLicked page number===" + event.target.dataset.id);
    this.pageLabel = event.target.dataset.id;
    window.sessionStorage.setItem('selectedPageNo1', this.pageLabel);
    let finalIndex = this.pageLabel * this.numberOfRecordsToDisplay;
    console.log("finalIndex==" + finalIndex);
    let startingIndex =
      this.pageLabel * this.numberOfRecordsToDisplay -
      this.numberOfRecordsToDisplay;
    console.log("startingIndex==" + startingIndex);
    for (let i = startingIndex; i < finalIndex; i++) {
      if (
        this.productCopyArray[i] !== null &&
        this.productCopyArray[i] !== undefined
      ) {
        this.productArray.push(this.productCopyArray[i]);
      }
    }
  }
  //----Pagination End-------------------
  get sortOptions1() {
    return [
      {
        label: "Low-High Price",
        value: "Low-High"
      },
      {
        label: "High-Low Price",
        value: "High-Low"
      },
      {
        label: "In-Stock",
        value: "In-Stock"
      }
    ];
  }
  @track selectedOption;
  handleSortChange(event) {
    console.log("Function called");
    this.selectedOption = event.target.value;
    console.log("sortOptions===" + this.selectedOption);
    invokeGoogleAnalyticsService('PAGE SORTING', {sortType : this.selectedOption, page : 'search Page'});    
    if (this.sort == true) {
      this.handleChange();
    } else {
      this.doSorting();
    }
  }

  doSorting() {
    console.log("Inside doSorting>>> ");
    var sortedArray = [];

    //create a Master copy of the Product List so we do not loose Out of Stock product after filtering - Sri
    if(!this.productCopyArrayMaster.length > 0) { 
      this.productCopyArrayMaster = [...this.productCopyArray];
    }

      //const localArray = [...this.productCopyArray];

    const localArray = [...this.productCopyArrayMaster];
    console.log('localArray ',localArray);

    for (let i = 0; i < localArray.length; i++) {
      // console.log('====' + localArray[i].price);
      if (localArray[i].price !== undefined) {
        sortedArray.push(localArray[i]);
      }
    }
    console.log("sortedArray===" + sortedArray.length);
    console.log("sortOptin Again===" + this.selectedOption);

    if (this.selectedOption == "High-Low") {
      console.log("Inside highprice>>> ");
      sortedArray.sort(function (a, b) {
        if (b.price !== undefined && a.price !== undefined) {
          return (
            b.price.replace(/[^\d\.]/g, "") - a.price.replace(/[^\d\.]/g, "")
          );
        }
      });
    }
    if (this.selectedOption == "Low-High") {
      console.log("Inside lowprice>>> ");
      sortedArray.sort(function (a, b) {
        if (b.price !== undefined && a.price !== undefined) {
          console.log("Inside lowprice return>>> ");
          return (
            a.price.replace(/[^\d\.]/g, "") - b.price.replace(/[^\d\.]/g, "")
          );
        }
      });
    }
    if (this.selectedOption == "In-Stock") {
      let localArray1 = [];
      let localArray2 = [];
      console.log("Inside In-Stock>>> ");
      for (let i = 0; i < sortedArray.length; i++) {
        console.log("StockStatus===" + sortedArray[i].stockstatus);
        if (sortedArray[i].invstatus == "In Stock") {
          localArray1.push(sortedArray[i]);
        } else {
          //localArray2.push(sortedArray[i]); //commented this line so that just the In Stock product is added to the List
        }
      }
      console.log("localArray1===" + localArray1.length);
      console.log("localArray2===" + localArray2.length);
      sortedArray = [];
      sortedArray = localArray1.concat(localArray2);
      console.log("sortedArray====" + sortedArray.length);
    }

    for (let i = 0; i < localArray.length; i++) {
      if (localArray[i].price === undefined) {
        sortedArray.push(localArray[i]);
      }
    }

    this.productCopyArray = [...sortedArray];
    
    this.preparePagination();
    console.log("localArray===" + localArray.length);
  }

  ////////////////////////end////////////////

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
  openRequestedPopup() {
    var topsss = window.screen.height - 583;
    var leftsss = window.screen.width - 384;
    var windowObjectReference = window.open(
      "https://chat.cummins.com/system/templates/chat/cummins/chat.html?subActivity=Chat&entryPointId=1015&templateName=cummins&languageCode=en&countryCode=US&ver=v11",
      "popup",
      "width=384, height=583, top=" + topsss + ",left=" + leftsss + ""
    );
  }
  openFilter() {
    this.template.querySelector(".searchFilter").classList.add("active");
    document.querySelector("body").classList.add("noscroll");
  }
  closeFilter() {
    this.template.querySelector(".searchFilter").classList.remove("active");
    document.querySelector("body").classList.remove("noscroll");
  }
}