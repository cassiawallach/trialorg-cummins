import { LightningElement, api,track } from 'lwc';
import callReturnOrderAPI from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.callReturnOrderAPI';
//import callReturnOrderItemAPI from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.callReturnOrderItemAPI';
import communityName from '@salesforce/label/c.dbu_communityName';
import {
    NavigationMixin
} from 'lightning/navigation';

//----Importing Custom labels--
import dbu_trackOrderProductHeader from "@salesforce/label/c.dbu_trackOrderProductHeader";
import dbu_Return_Product from "@salesforce/label/c.dbu_Return_Product";
import dbu_Return_Quantity from "@salesforce/label/c.dbu_Return_Quantity";
import dbu_MyOrder_ReturnStatus from "@salesforce/label/c.dbu_MyOrder_ReturnStatus";
import dbu_MyOrder_ReturnUnitPrice from "@salesforce/label/c.dbu_MyOrder_ReturnUnitPrice";
import dbu_CoreCharge_Availability_Msg from "@salesforce/label/c.dbu_CoreCharge_Availability_Msg";
import dbu_DefaultProductImage from "@salesforce/label/c.dbu_DefaultProductImage";
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import clearanceIcon from '@salesforce/resourceUrl/dbu_icons';
export default class Dbu_trackOrderItemDetails extends NavigationMixin(LightningElement) {

   
    @api itemdetails;
    @api cartdetails;
    @track sendLocBackToChangeLocTile;
    @track clearanceImg = clearanceIcon+'/dbu_icons/dbu_saletag.svg';
    //-----Custom Labels-----
    label = {
        dbu_Return_Product,
        dbu_Return_Quantity,
        dbu_MyOrder_ReturnStatus,
        dbu_MyOrder_ReturnUnitPrice,
        dbu_CoreCharge_Availability_Msg,
        dbu_DefaultProductImage,
        dbu_trackOrderProductHeader
    };
    
    connectedCallback(){
        console.log('========Called=======');
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        console.log('==Country==='+url.searchParams.get("store"));
      //  this.sendLocBackToChangeLocTile = url.searchParams.get("store");
      this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
    }


    goToProductDetailPage(event){
        let prodName = event.target.getAttribute('data-name');
        let prodId =   event.target.getAttribute('data-id');
        //Replacing comma and whitespace from hyphen in Product Name
        if(prodName.includes(",")){
            prodName =  prodName.replace(/,/g, '-').toLowerCase();
        }
        if(prodName.includes(" ")){
            prodName =  prodName.replace(/\s+/g, '-').toLowerCase();
        }

        if(prodName.includes('/')){
            prodName = prodName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
          }
       
        console.log('ProdName==='+prodName);
         let urlString = window.location.origin;
				 let redirectURL =  urlString + communityName +'product/'+prodId +'/'+ prodName;
         //let redirectURL = urlString + communityName + 'product?name=' + prodName + '&pId=' + prodId + '&store=' + this.sendLocBackToChangeLocTile;
         console.log('redirectURL trackOrder===='+redirectURL);
         invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Naviate to the ' + prodName + ' product page');
        window.location.href = redirectURL;
         /*this[NavigationMixin.Navigate]({
             "type": "standard__webPage",
             "attributes": {
                 "url": redirectURL
             }
         });*/
    }

}