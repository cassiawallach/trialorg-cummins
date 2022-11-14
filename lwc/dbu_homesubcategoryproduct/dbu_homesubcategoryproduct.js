import {
    LightningElement,
    api,
    track
} from 'lwc';
import communityName from '@salesforce/label/c.dbu_communityName';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import clearanceIcon from '@salesforce/resourceUrl/dbu_icons';
import dbu_percentOff from '@salesforce/label/c.Dbu_percentOff';
export default class Dbu_homesubcategoryproduct extends LightningElement {
    @api product;
    @api prod;
    @api pname;
    @api price;
    @api pimageurl;
    @api productid;
    @api prid;
    @api pstockstatus;
    @api gtmlistname;
    @api srcpage;
    @api productarray;
    @api countrycode;
    @api categoryname;
    @api productbreadcrumb;
    @api countrycurrencycode;
    @api analyticsdata;
    @api view;
    @track showGrid;
    @track imageUrl;
    @track showStock=true;
    productURL;
    //@track productPrice;

    @track currentLocation;
    @track currentLanguage = 'US';
    @track showgridView=false;
    @track clearanceImg = clearanceIcon+'/dbu_icons/dbu_saletag.svg';
    
    label={
      dbu_percentOff
  };
    @api
    changeView(strString) {
      this.view = strString;
      console.log('this.view',this.view);
      if(this.view == "gridView")
           this.showGrid = true;
        else
           this.showGrid = false;
  }
    connectedCallback() {
      console.log('clearanceImg',this.clearanceImg);
      console.log('templateView',this.view);
      console.log('typeOfView',this.prod.typeOfView);
      console.log('prodList',this.prod);
      /*Added by Malhar for retriving store location begin - 29/11/2020 */
        
       let queryString = window.location.search;
       let urlParams = new URLSearchParams(queryString);
       this.currentLocation = window.sessionStorage.getItem('setCountryCode'); //urlParams.get('store');
       console.log('connected callback homesub category prods curr locatn before > ' + JSON.stringify(this.currentLocation));
       console.log('connected callback homesub category prods lang before > ' + JSON.stringify(this.currentLanguage));
       if(this.currentLocation == null){
           this.currentLocation = 'US';    
       }else if(this.currentLocation == 'EN'){
           this.currentLocation = 'CA';
           this.currentLanguage = 'EN';
       }else if(this.currentLocation == 'FR'){
           this.currentLocation = 'CA';
           this.currentLanguage = 'FR';
       }
       console.log('connected callback homesub category prods after > ' + JSON.stringify(this.currentLocation));
       console.log('connected callback homesub category prods after > ' + JSON.stringify(this.currentLanguage));

       /*Added by Malhar for retriving store location ends - 29/11/2020 */     

       if(this.view == "gridView")
       this.showGrid = true;
       else
       this.showGrid = false;
        console.log("this.showGrid",this.showGrid);
        console.log('Dbu_homesubcategoryproduct =>Product=> ', JSON.stringify(this.product));
        console.log('homepagesubcategory gtmlistname',this.gtmlistname);
        console.log("prodyctImage",this.prod.imageUrl);
        console.log("this.srcpage in connectedCallBack",this.srcpage);
        if(this.srcpage=='RecentlyViewed')
          this.showStock=false;
        else
          this.showStock=true;
    }
    @api
    get productURL() {
       
        let productName = this.product.sfdcName.toLowerCase();
        let urlString = window.location.origin;
        //return urlString + communityName + 'product?pId=' + this.product.sfid + '&store=' + this.currentLocation;
        let prodName = productName;
        if(prodName.includes('/')){
            prodName = prodName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
          }
				return urlString + communityName +'product/'+this.prod.sfid +'/'+ this.prod.sfdcName+'/?store='+this.currentLanguage;
        //return urlString+communityName+'product?name='+productName+'&pId='+this.product.id + '&store=' + this.currentLanguage;
    }
    handleClick(event)
    {
        let productName = this.prod.sfdcName.toLowerCase(); // Added by Dhiraj for add name parameter  - 24/12/2020
         
        this.sfid= event.currentTarget.getAttribute('data-id');
        let productprice = event.currentTarget.getAttribute('data-productprice');
        let pr = this.prod.price;
        let productFeedForGoogleAnalytics = {
            ProductID : this.prod.SKU, /* Sasikanth CECI-958 GTM Events*/
            productName : productName,
            ProductInventoryStatus : 1,
            ProductPrice : pr.slice(pr.indexOf("$")+1, pr.length), /* Sasikanth CECI-958 GTM Events*/
            listname : this.gtmlistname,            
            ProductCategory : this.prod.category != undefined ? this.prod.category : "", /* Sasikanth CECI-958 GTM Events*/
            ProductBrand : this.prod.brand != undefined ? this.prod.brand : "" /* Sasikanth CECI-958 GTM Events*/
          };  
          // CECI-990 GTM issue
          invokeGoogleAnalyticsService('ON PRODUCT CLICK EVENT' , productFeedForGoogleAnalytics);
          

        let urlString = window.location.origin;
        //Malhar modified the below URL to hold the store parameter - 29/11/2020
        //window.location.href = urlString+communityName+'product?pId='+this.sfid + '&store=' + this.currentLocation;
        //window.location.href = urlString+communityName+'product?name='+productName+'&pId='+this.sfid + '&store=' + this.currentLanguage;
        let prodName = productName;
        if(prodName.includes('/')){
            prodName = prodName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
          }
				window.location.href = urlString + communityName +'product/'+this.prod.sfid +'/'+ prodName+'/?store='+this.currentLanguage;
       
    }
    renderedCallback()
    {
        console.log("in rendered callback", this.prod.imgUrl)
        let childComponents = this.template.querySelectorAll('c-dbu_image-Generator')
            if (childComponents != undefined) {
                let childComponent = this.template.querySelectorAll('c-dbu_image-Generator')[0];
                //.processMyData(this.parentArray);
                if (childComponent != undefined)
                {
                    // childComponent.imageurl = this.imageUrl;
                    childComponent.imageurl = this.prod.imgUrl;
                    childComponent.renderImage();
                }
                // console.log('childComponents=>', JSON.stringify(childComponents));
                // console.log('childComponent=>', JSON.stringify(childComponent)); 
            }
        console.log('Dbu_homesubcategoryproduct this.imageUrl=>', this.prod.imgUrl);
    }
}