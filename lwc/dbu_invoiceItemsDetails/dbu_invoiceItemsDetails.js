import { LightningElement,api,track } from 'lwc';
import product from '@salesforce/label/c.dbu_product';
import quantity from '@salesforce/label/c.dbu_quantity';
import unitPrice from '@salesforce/label/c.dbu_unitPrice';
import discount from '@salesforce/label/c.dbu_discount';
import estTax from '@salesforce/label/c.dbu_estTax';
import totalAmount from '@salesforce/label/c.dbu_totalAmount';
import returnable from '@salesforce/label/c.dbu_returnable';
import dbu_CoreCharge_Availability_Msg from "@salesforce/label/c.dbu_CoreCharge_Availability_Msg";
import communityName from '@salesforce/label/c.dbu_communityName';


export default class Dbu_invoiceItemsDetails extends LightningElement {
    @api items;
    label = {
        product,
        quantity,
        unitPrice,
        discount,
        estTax,
        totalAmount,
        returnable,
        dbu_CoreCharge_Availability_Msg 
    }

    connectedCallback(){
        console.log('invoiceitems data ' , this.items);
       // console.log('invoiceitems data 1 ' , this.items[0].quantity);
    }

    goToProductDetailPage(event){
        let prodName = event.target.getAttribute('data-name');
        let prodId =   event.target.getAttribute('data-id');

        console.log('ProdName==='+prodName);
        console.log('ProdId==='+prodId);
        //Replacing comma and whitespace from hyphen in Product Name
        if(prodName.includes(",")){
            prodName =  prodName.replace(/,/g, '-').toLowerCase();
        }
        if(prodName.includes(" ")){
            prodName =  prodName.replace(/\s+/g, '-').toLowerCase();
        }

        if(prodName.includes('/')){
            prodName = prodName.replace('/','-');
          }
       
        console.log('ProdName==='+prodName);
         let urlString = window.location.origin;
		 let redirectURL =  urlString + communityName +'product/'+prodId +'/'+ prodName;
         
         console.log('redirectURL invoice===='+redirectURL);
        // invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Naviate to the ' + prodName + ' product page');
        window.location.href = redirectURL;
         
    }
}