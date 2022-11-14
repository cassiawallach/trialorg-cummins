import { LightningElement,api,track,wire } from 'lwc';
import communityName from '@salesforce/label/c.dbu_communityName';
import {
    NavigationMixin
} from 'lightning/navigation';
//---Importing service component for CurrencyCode prefix--
import { perfixCurrencyISOCode } from 'c/serviceComponent';
//----Importing Custom labels--
import dbu_MyOrder_ReturnTableHeader from "@salesforce/label/c.dbu_MyOrder_ReturnTableHeader";
import dbu_Return_Product from "@salesforce/label/c.dbu_Return_Product";
import dbu_Return_Quantity from "@salesforce/label/c.dbu_Return_Quantity";
import dbu_MyOrder_ReturnStatus from "@salesforce/label/c.dbu_MyOrder_ReturnStatus";
import dbu_MyOrder_ReturnUnitPrice from "@salesforce/label/c.dbu_MyOrder_ReturnUnitPrice";
import dbu_CoreCharge_Availability_Msg from "@salesforce/label/c.dbu_CoreCharge_Availability_Msg";
import dbu_DefaultProductImage from "@salesforce/label/c.dbu_DefaultProductImage";
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
export default class Dbu_returnOrderItemDetails extends NavigationMixin(LightningElement) {

    @api itemdetails;
    @track returnOrderItemDetails;
    @track haveReturnOrderItems = false;
    @track sendLocBackToChangeLocTile;
    @track currencyCode;
    @track returnedOrderQty = 0;

    //-----Custom Labels-----
    label = {
        dbu_Return_Product,
        dbu_Return_Quantity,
        dbu_MyOrder_ReturnStatus,
        dbu_MyOrder_ReturnUnitPrice,
        dbu_CoreCharge_Availability_Msg,
        dbu_MyOrder_ReturnTableHeader,
        dbu_DefaultProductImage
    };

    connectedCallback() {
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
       // this.sendLocBackToChangeLocTile = url.searchParams.get("store");
       this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
        this.checkingOrderItemStatus();
    }
    checkingOrderItemStatus() {
        this.currencyCode = this.itemdetails[0].currencyISOCode;
        var itemListLocal = [];
        var productMap = new Map();
        var cloneOrderVsOrgOrderItem = new Map();

        // ==== Map for cloneOrder against original order item----
        if (this.itemdetails[0].cloneOrderAgainstOrgOrderItemMap !== null && this.itemdetails[0].cloneOrderAgainstOrgOrderItemMap !== undefined) {
            for (let key in this.itemdetails[0].cloneOrderAgainstOrgOrderItemMap) {
                cloneOrderVsOrgOrderItem.set(key, this.itemdetails[0].cloneOrderAgainstOrgOrderItemMap[key]);
            }
        }

        //-------- Adding products in Map
        for (let i = 0; i < this.itemdetails[0].productlist.length; i++) {
            productMap.set(this.itemdetails[0].productlist[i].sfid, this.itemdetails[0].productlist[i]);
        }
        //------- Iterating on Order line item list
        console.log('Total lineitem is ====='+this.itemdetails[0].EOrderItemsS.length);
        console.log('JSON RES==='+JSON.stringify(this.itemdetails[0].EOrderItemsS));
        for (let i = 0; i < this.itemdetails[0].EOrderItemsS.length; i++) {
            let orderItemObj = {};
            console.log('Every lineitem status===='+this.itemdetails[0].EOrderItemsS[i].orderItemStatus);
            console.log('Value of isReturned========'+this.itemdetails[0].EOrderItemsS[i].dbuIsReturned );

            if ((this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'Return Initiated' || this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'Refunded'
                || this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'Return Rejected' || this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'Return Approved'
                || this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'Return Requested' || this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'Open'
                ||  this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'OPEN' || this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'Retour initié' 
                || this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'Remboursé' || this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'Retour rejeté'
                || this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'Retour approuvé' || this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'Retour demandé' 
                || this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'Ouvert' || this.itemdetails[0].EOrderItemsS[i].orderItemStatus === 'OUVERT')
                && (this.itemdetails[0].EOrderItemsS[i].dbuIsReturned === true)) {
                    console.log('IsReturned========'+this.itemdetails[0].EOrderItemsS[i].dbuIsReturned );
                orderItemObj['quantity'] = this.itemdetails[0].EOrderItemsS[i].quantity;
                let amountInFormat = this.itemdetails[0].EOrderItemsS[i].price;
                if (this.itemdetails[0].EOrderItemsS[i].orderItemStatus !== 'Return Rejected' || this.itemdetails[0].EOrderItemsS[i].orderItemStatus !== 'Retour rejeté') {
                    this.returnedOrderQty = this.returnedOrderQty + this.itemdetails[0].EOrderItemsS[i].quantity;
                }

                orderItemObj['price'] = perfixCurrencyISOCode(this.currencyCode, amountInFormat);
                orderItemObj['orderItemStatus'] = this.itemdetails[0].EOrderItemsS[i].orderItemStatus;
                if (productMap.has(this.itemdetails[0].EOrderItemsS[i].prodId)) {
                    orderItemObj['sfdcName'] = productMap.get(this.itemdetails[0].EOrderItemsS[i].prodId).sfdcName;
                    if (productMap.get(this.itemdetails[0].EOrderItemsS[i].prodId).EProductMediasS[0] !== undefined) {
                        orderItemObj['URI'] = productMap.get(this.itemdetails[0].EOrderItemsS[i].prodId).EProductMediasS[0].URI;
                    } else {
                        orderItemObj['URI'] = dbu_DefaultProductImage;
                    }

                    orderItemObj['id'] = productMap.get(this.itemdetails[0].EOrderItemsS[i].prodId).sfid;
                }
                if (productMap.get(this.itemdetails[0].EOrderItemsS[i].prodId).hasCoreCharge === true && productMap.get(this.itemdetails[0].EOrderItemsS[i].prodId).dbuHasCoreChild === true) {
                    orderItemObj['coreCharge'] = true;
                }
                console.log('Org Order ITem Id===' + this.itemdetails[0].EOrderItemsS[i].sfid);
                if (cloneOrderVsOrgOrderItem.has(this.itemdetails[0].EOrderItemsS[i].sfid)) {
                    console.log('Clone Order ====' + cloneOrderVsOrgOrderItem.get(this.itemdetails[0].EOrderItemsS[i].sfid));
                    orderItemObj['cloneOrderId'] = cloneOrderVsOrgOrderItem.get(this.itemdetails[0].EOrderItemsS[i].sfid);
                }
                itemListLocal.push(orderItemObj);
            }
        }
        const selectedEvent = new CustomEvent('returnedorderqtyevent', { detail: this.returnedOrderQty });
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
        console.log('Event Fired');
        // Final List of order line items records
        console.log('Final List of Return order line items records==='+itemListLocal.length);
        if (itemListLocal.length > 0) {
            this.haveReturnOrderItems = true
            this.returnOrderItemDetails = itemListLocal;
        }
    }

    goToProductDetailPage(event) {
        let prodName = event.target.getAttribute('data-name');
        let prodId = event.target.getAttribute('data-id');
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
        let urlString = window.location.origin;
				 let redirectURL =  urlString + communityName +'product/'+prodId +'/'+ prodName+'/?store='+this.sendLocBackToChangeLocTile;
        //let redirectURL = urlString + communityName + 'product?name=' + prodName + '&pId=' + prodId + '&store=' + this.sendLocBackToChangeLocTile;
        console.log('redirectURL====' + redirectURL);
        invokeGoogleAnalyticsService('NAVIGATE TO URL LINKS', 'Naviate to the ' + prodName + ' product page');
        window.location.href = redirectURL;
        /*
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": redirectURL
            }
        });*/
    }
}