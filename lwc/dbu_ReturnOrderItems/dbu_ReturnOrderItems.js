import {
    LightningElement,
    wire,
    track
} from 'lwc';
import returnOrderItemDetails from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.returnOrderItemDetails';
import communityName from '@salesforce/label/c.dbu_communityName';
import partialReturnOrder from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.partialReturnOrder';
import {
    NavigationMixin
} from 'lightning/navigation';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import getUserInfo from '@salesforce/apex/dbu_ReturnCCOrderApiUtil.getUserInfo';
//---Importing service component for CurrencyCode prefix--
import { perfixCurrencyISOCode,validateCookiesData  } from 'c/serviceComponent';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

//-------------Importing Custom Labels----------------
import dbu_CoreCharge_Availability_Msg from "@salesforce/label/c.dbu_CoreCharge_Availability_Msg";
import dbu_Return_PageHeader from "@salesforce/label/c.dbu_Return_PageHeader";
import dbu_Return_PageSubHeader from "@salesforce/label/c.dbu_Return_PageSubHeader";
import dbu_Return_Product from "@salesforce/label/c.dbu_Return_Product";
import dbu_Return_Quantity from "@salesforce/label/c.dbu_Return_Quantity";
import dbu_Return_Reason_for_Return from "@salesforce/label/c.dbu_Return_Reason_for_Return";
import dbu_Return_Price from "@salesforce/label/c.dbu_Return_Price";
import dbu_Return_HandlingFee10 from "@salesforce/label/c.dbu_Return_HandlingFee10";
import dbu_Return_ProductNotReturnable from "@salesforce/label/c.dbu_Return_ProductNotReturnable";
import dbu_Return_HandlingFee15 from "@salesforce/label/c.dbu_Return_HandlingFee15";
import dbu_Return_NoRemainingQty from "@salesforce/label/c.dbu_Return_NoRemainingQty";
import dbu_Return_ContactCS from "@salesforce/label/c.dbu_Return_ContactCS";
import dbu_Return_Core_Refund from "@salesforce/label/c.dbu_Return_Core_Refund";
import dbu_Return_EstTax from "@salesforce/label/c.dbu_Return_EstTax";
import dbu_Return_EstAmt from "@salesforce/label/c.dbu_Return_EstAmt";
import dbu_Return_AddInfo from "@salesforce/label/c.dbu_Return_AddInfo";
import dbu_Return_BtnLabel_Proceed from "@salesforce/label/c.dbu_Return_BtnLabel_Proceed";
import dbu_Return_BtnLabel_ProceedToReturn from "@salesforce/label/c.dbu_Return_BtnLabel_ProceedToReturn";
import dbu_Return_Part_no_longer_wanted from "@salesforce/label/c.dbu_Return_Part_no_longer_wanted";
import dbu_Return_Ordered_the_wrong_part from "@salesforce/label/c.dbu_Return_Ordered_the_wrong_part";
import dbu_Return_Damaged_in_shipping from "@salesforce/label/c.dbu_Return_Damaged_in_shipping";
import dbu_Return_Incorrect_part_was_received from "@salesforce/label/c.dbu_Return_Incorrect_part_was_received";
import dbu_Return_Toast_ReasonForReturn from "@salesforce/label/c.dbu_Return_Toast_ReasonForReturn";
import dbu_Return_BtnLabel_Cancel from "@salesforce/label/c.dbu_Return_BtnLabel_Cancel";
import dbu_DefaultProductImage from "@salesforce/label/c.dbu_DefaultProductImage";
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A';
import isGuest from '@salesforce/user/isGuest';


export default class Dbu_ReturnOrderItems extends NavigationMixin(LightningElement) {
    @track lstOrder = [];
    @track orderItemList;
    @track valueDrpdwn;
    @track totalquantity = [];
    @track orderId;
    @track returnItemList = [];
    @track isDisable = true;
    @track btnLabel = dbu_Return_BtnLabel_ProceedToReturn;
    @track showHandlingFee = false;
    @track isLoading = true;
    @track nonReturnableProductCount = 0;
    @track dbuPickupOnlyFlag = false;
    @track picklistOptions = [];
    @track isDropDown = false;
    @track quantityMapObj = new Map();
    @track oderItemMapObj = new Map();
    @track isDisable = false;
    @track selectedItemsCount = 0;
    @track isCheckedOrderItems = false;
    @track isAllSelected = false;
    @track totalAmount;
    @track totalRefundAmount = 0.0;
    @track addInfoData;
    @track orderDaysCompleted;
    @track isGuestUser = false;
    @track relatedProductMap = new Map();
    @track prodQtyMap = new Map();
    @track orderHasCoreCharge = false;
    @track sendLocBackToChangeLocTile;
    @track totalOrderItemPrice;
    @track refundedTax;
    @track currencyCode;
    @track displayError = false;
    @track isGuestU = isGuest;
  //  @track isRequired = false;

    //---------Custom labels-----

    label = {
        dbu_CoreCharge_Availability_Msg,
        dbu_Return_PageHeader,
        dbu_Return_PageSubHeader,
        dbu_Return_Product,
        dbu_Return_Quantity,
        dbu_Return_Reason_for_Return,
        dbu_Return_Price,
        dbu_Return_HandlingFee10,
        dbu_Return_ProductNotReturnable,
        dbu_Return_HandlingFee15,
        dbu_Return_NoRemainingQty,
        dbu_Return_ContactCS,
        dbu_Return_Core_Refund,
        dbu_Return_EstTax,
        dbu_Return_EstAmt,
        dbu_Return_AddInfo,
        dbu_Return_BtnLabel_Proceed,
        dbu_Return_BtnLabel_ProceedToReturn,
        dbu_Return_Part_no_longer_wanted,
        dbu_Return_Ordered_the_wrong_part,
        dbu_Return_Damaged_in_shipping,
        dbu_Return_Incorrect_part_was_received,
        dbu_Return_Toast_ReasonForReturn,
        dbu_Return_BtnLabel_Cancel,
        dbu_DefaultProductImage
    };


    //---------------------------

    get ScreenLoaded() {
        return this.isLoading;
    }

    connectedCallback() {
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
       // this.sendLocBackToChangeLocTile = url.searchParams.get("store");
       this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');
       if (this.sendLocBackToChangeLocTile === undefined || this.sendLocBackToChangeLocTile === null) {
        this.sendLocBackToChangeLocTile = storeUSA;
    }
        this.isDisable = true;
        this.valueDrpdwn = '1';
        this.getReturnOrderItems();
        this.getUserDetail();
    }

    getUserDetail() {
        getUserInfo({
        })
            .then(data => {
                if (data === 'Guest') {
                    this.isGuestUser = true;
                }
            })
            .catch(error => {
                if (error) {
                    this.errorMsg = error.body.message;
                }
            })
    }

    getReturnOrderItems() {
        returnOrderItemDetails({
            urlParam: window.location.href
        })
            .then(data => {
                if (data) {
                    // Security changes, Added by Ranadip	
                    //if(this.isGuestU && validateCookiesData(data[0].sfid)){	
                           // return;	
                           if(this.isGuestU){	
                            let isTrue = validateCookiesData(data[0].sfid);	
                             if (isTrue) {	
                                 return;	
                               }	
                             	
                             }// End here	
                                         //}//end here
                    this.isLoading = false;
                    var itemListLocal = [];
                    this.lstOrder = data;
                    var productMap = new Map();
                    var numberOfDays = this.lstOrder[0].daysSinceOrderDate;
                    this.orderDaysCompleted = numberOfDays;
                    this.orderId = this.lstOrder[0].sfid;
                    var perUnitPriceAppliedHandlingFee = 0.00;

                    //---Added for country currency change---
                    this.currencyCode = this.lstOrder[0].currencyISOCode;
                    console.log('Currency Code value===' + this.currencyCode);
                    this.totalOrderItemPrice = perfixCurrencyISOCode(this.currencyCode, 0.00);
                    this.refundedTax = perfixCurrencyISOCode(this.currencyCode, 0.00);
                    //-------- Adding products in Map
                    for (let i = 0; i < this.lstOrder[0].productlist.length; i++) {
                        productMap.set(this.lstOrder[0].productlist[i].sfid, this.lstOrder[0].productlist[i]);
                    }

                    //-------- Adding related products in Map
                    for (let i = 0; i < this.lstOrder[0].relatedProducts.length; i++) {
                        this.relatedProductMap.set(this.lstOrder[0].relatedProducts[i].ccrz__Product__c, this.lstOrder[0].relatedProducts[i]);
                    }

                    //------- Iterating on Order line item list
                    for (let i = 0; i < this.lstOrder[0].EOrderItemsS.length; i++) {
                        let orderItemObj = {};
                        if ((this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Initiated' && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Abandoned' 
                            && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== undefined && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Rejected'
                            && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Approved'  && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Requested' 
                            && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Refunded') && (this.lstOrder[0].EOrderItemsS[i].dbuIsReturned === false)) {

                            //----Map for maintain prod qty 
                            console.log('Item Status==='+this.lstOrder[0].EOrderItemsS[i].orderItemStatus);
                            console.log('New qty==='+this.lstOrder[0].EOrderItemsS[i].newQuantity);
                            this.prodQtyMap.set(this.lstOrder[0].EOrderItemsS[i].prodId, this.lstOrder[0].EOrderItemsS[i].newQuantity);
                            //------------------------------
                            if (productMap.has(this.lstOrder[0].EOrderItemsS[i].prodId)) {
                                orderItemObj['id'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).sfid;
                                orderItemObj['sfdcName'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).sfdcName;
                                orderItemObj['genuinePart'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).genuinePart;
                                orderItemObj['nonReturnable'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).nonReturnable;
                                if (productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).EProductMediasS[0] !== undefined) {
                                    orderItemObj['URI'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).EProductMediasS[0].URI;
                                } else {
                                    orderItemObj['URI'] = dbu_DefaultProductImage;
                                }

                                orderItemObj['sfdcName'] = productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).sfdcName;
                                console.log('====IsNotRetrunable====' + productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).nonReturnable);
                                if (productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).dbuPickUpOnly) {
                                    this.dbuPickupOnlyFlag = true;
                                }
                                if ( productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).nonReturnable === true) {
                                    orderItemObj['isProdNotReturnable'] = true;
                                    orderItemObj['isProductReturnable'] = true;
                                    orderItemObj['isQtyDisable'] = true;
                                    orderItemObj['isReasonForReturnDisable'] = true;
                                    this.nonReturnableProductCount++;
                                } else {
                                    orderItemObj['isProductReturnable'] = false;
                                    orderItemObj['isProdNotReturnable'] = false;
                                    orderItemObj['isQtyDisable'] = false;
                                    orderItemObj['isReasonForReturnDisable'] = false;
                                }
                                if (productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).dbuCrateEngine) {
                                    orderItemObj['isCreateEngine'] = true;
                                    orderItemObj['isProductReturnable'] = true;
                                    orderItemObj['isQtyDisable'] = true;
                                    orderItemObj['isReasonForReturnDisable'] = true;
                                }
                                //----------Core Charge-----

                                if (productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).hasCoreCharge === true && productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).dbuHasCoreChild === true && numberOfDays <= 90) {
                                    this.orderHasCoreCharge = true;
                                    orderItemObj['coreCharge'] = true;
                                    if (numberOfDays > 45 && numberOfDays <= 90) {
                                        orderItemObj['isHandlingFeeOnCore'] = true;
                                    } else if (numberOfDays > 0 && numberOfDays <= 30) {
                                        // orderItemObj['isQtyDisable'] = true;
                                        // orderItemObj['isProductReturnable'] = true;
                                    }
                                } else if (productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).hasCoreCharge === false && numberOfDays > 30) {
                                    orderItemObj['coreCharge'] = false;
                                    orderItemObj['isQtyDisable'] = true;
                                    orderItemObj['isReasonForReturnDisable'] = true;
                                    orderItemObj['isProductReturnable'] = true;
                                } else if (productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).hasCoreCharge === true && productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).dbuHasCoreChild === false && numberOfDays > 30) {
                                    orderItemObj['isQtyDisable'] = true;
                                    orderItemObj['isReasonForReturnDisable'] = true;
                                    orderItemObj['isProductReturnable'] = true;
                                    orderItemObj['coreCharge'] = false;
                                }

                                //-----Manage qty from parent core charge to child
                                if (productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).hasCoreCharge === true && productMap.get(this.lstOrder[0].EOrderItemsS[i].prodId).dbuHasCoreChild === false) {
                                    orderItemObj['parentCoreCharge'] = true;
                                }

                                //-------------------------
                            }
                            orderItemObj['quantity'] = this.lstOrder[0].EOrderItemsS[i].quantity;
                            orderItemObj['vertexTax'] = this.lstOrder[0].EOrderItemsS[i].vertexTax;
                            orderItemObj['orderItemStatus'] = this.lstOrder[0].EOrderItemsS[i].orderItemStatus;
                            orderItemObj['orderId'] = this.orderId;
                            orderItemObj['sfid'] = this.lstOrder[0].EOrderItemsS[i].sfid;
                            orderItemObj['isStrikeThrough'] = false;
                            orderItemObj['removeStrikeThrough'] = true;
                            //---Getting currency prefix from service component--
                            orderItemObj['amtAfterHandlingFee'] = perfixCurrencyISOCode(this.currencyCode, perUnitPriceAppliedHandlingFee);
                            let amountInFormat = this.lstOrder[0].EOrderItemsS[i].subAmount / this.lstOrder[0].EOrderItemsS[i].quantity; // Changes for Promotions
                            orderItemObj['price'] = perfixCurrencyISOCode(this.currencyCode, amountInFormat);
                            //---- Promotion Changes---
                           // let listamountInFormat = this.lstOrder[0].EOrderItemsS[i].price;  
                           // orderItemObj['listprice'] = perfixCurrencyISOCode(this.currencyCode, listamountInFormat);
                            //-----------------------
                            let quantityArray = [];
                            for (let j = 1; j <= this.lstOrder[0].EOrderItemsS[i].newQuantity; j++) {
                                quantityArray.push({
                                    label: j,
                                    value: j
                                });
                            }
                            orderItemObj['returnReason'] = '';
                            orderItemObj['returnQuantity'] = this.lstOrder[0].EOrderItemsS[i].newQuantity;

                            if (this.lstOrder[0].EOrderItemsS[i].newQuantity == 0) {
                                orderItemObj['isProductReturnable'] = true;
                                orderItemObj['isQtyZero'] = true;
                                orderItemObj['isQtyDisable'] = true;
                                orderItemObj['isReasonForReturnDisable'] = true;
                            }
                            orderItemObj['handlingFee'] = '';
                            orderItemObj['quantityList'] = quantityArray;
                            orderItemObj['dispalyHandleFee'] = false;
                            if ((this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Initiated' && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Approved'
                                && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Return Requested' && this.lstOrder[0].EOrderItemsS[i].orderItemStatus !== 'Refunded')
                                && (this.lstOrder[0].EOrderItemsS[i].dbuIsReturned === false)) {
                                itemListLocal.push(orderItemObj);
                            }

                        }
                    }
                    //------Push records in array in sequence if core product exist----------//
                    let itemInSequence = [];
                    let itemCounter = 0;
                    for (let i = 0; i < itemListLocal.length; i++) {
                        if (itemListLocal[i].isProductReturnable) {
                            itemCounter++;
                        }
                        if (itemListLocal[i].parentCoreCharge) {
                            let relatedCoreProdId = this.relatedProductMap.get(itemListLocal[i].id).ccrz__RelatedProduct__c;
                            itemInSequence.push(itemListLocal[i]);
                            for (let j = 0; j < itemListLocal.length; j++) {
                                if (itemListLocal[j].id === relatedCoreProdId) {
                                    itemInSequence.push(itemListLocal[j]);
                                }
                            }
                        } else {
                            itemInSequence.push(itemListLocal[i]);
                        }
                    }
                    //---- Removing duplicates records from itemInSequence array
                    let itemsArray = [...new Set(itemInSequence)];
                    this.orderItemList = itemsArray;
                    //------Disable toplevel Checkbox if all items are disabled------------//

                    if (this.orderItemList.length === itemCounter) {
                        let topCheckBox = this.template.querySelector('.toplevelCheckbox');
                        topCheckBox.disabled = true;
                    }
                    //----------------------------------------------------------------------//

                } else if (error) {
                    console.log('fetchProductById Error>>>' + JSON.stringify(error));
                }
            })
            .catch(error => {
                if (error) {
                    this.errorMsg = error.body.message;
                }
            })
    }


    get orderReaturnReason() {
        return [{
            label: dbu_Return_Part_no_longer_wanted,
            value: dbu_Return_Part_no_longer_wanted
        },
        {
            label: dbu_Return_Ordered_the_wrong_part,
            value: dbu_Return_Ordered_the_wrong_part
        },
        {
            label: dbu_Return_Damaged_in_shipping,
            value: dbu_Return_Damaged_in_shipping
        },
        {
            label: dbu_Return_Incorrect_part_was_received,
            value: dbu_Return_Incorrect_part_was_received
        },
        // {
        //     label: 'Other',
        //     value: 'Other'
        // },
        ];
    }
    onReturnPartsReasonChange(event) {

        let reasonForReturn = event.detail.value;
        let selectItemId = event.target.getAttribute('data-id');

        for (let index = 0; index < this.orderItemList.length; index++) {
            if (this.orderItemList[index].id == selectItemId) {
                this.orderItemList[index].returnReason = reasonForReturn;
                if (reasonForReturn == dbu_Return_Part_no_longer_wanted || reasonForReturn == dbu_Return_Ordered_the_wrong_part) {
                    this.orderItemList[index].price.replace(/\,/g, '');
                    this.orderItemList[index].isStrikeThrough = true;
                    this.orderItemList[index].removeStrikeThrough = false;
                    this.orderItemList[index].dispalyHandleFee = true;
                    // Removing all speacial charachter from price using -- replace(/[^\d\.]/g, '') --- Regex
                    console.log('Price =' + this.orderItemList[index].price.replace(/[^\d\.]/g, ''));
                    let handlingFee = (this.orderItemList[index].price.replace(/[^\d\.]/g, '') / 100) * 15;
                    let unitPriceAppliedFee = this.orderItemList[index].price.replace(/[^\d\.]/g, '') - handlingFee;
                    this.orderItemList[index].amtAfterHandlingFee = perfixCurrencyISOCode(this.currencyCode, unitPriceAppliedFee);
                    this.template.querySelector('.isRequired').classList.remove('addInfoReq'); 
                    this.displayError = false;
                } else {
                   // this.isRequired = true;
                    this.orderItemList[index].isStrikeThrough = false;
                    this.orderItemList[index].removeStrikeThrough = true;
                    this.orderItemList[index].dispalyHandleFee = false;
                    this.template.querySelector('.isRequired').classList.remove('addInfoReq'); 
                    this.displayError = false;

                    if(reasonForReturn === 'Other'){
                        this.template.querySelector('.isRequired').classList.add('addInfoReq'); 
                        this.displayError = true;
                    }
                }

                break;
            }
        }

        for (let index = 0; index < this.returnItemList.length; index++) {
            if (this.returnItemList[index].id == selectItemId) {
                this.returnItemList[index].returnReason = reasonForReturn;
                break;
            }
        }
        this.calculateEstimatedAmount();
    }

    handleChangeQuantity(event) {

        const selectedReturnQuantity = event.detail.value;
        //-------Core charge handle-
        let isParentCoreCharge = event.target.getAttribute('data-parentcorecharge');
        if (isParentCoreCharge) {
            let parentProdId = event.target.getAttribute('data-id');
            if (this.relatedProductMap.has(parentProdId)) {
                let relatedCoreProdId = this.relatedProductMap.get(parentProdId).ccrz__RelatedProduct__c;
                for (let index = 0; index < this.orderItemList.length; index++) {
                    if (this.orderItemList[index].id == relatedCoreProdId) {
                        if (selectedReturnQuantity > this.prodQtyMap.get(relatedCoreProdId)) {
                            this.orderItemList[index].returnQuantity = this.prodQtyMap.get(relatedCoreProdId);
                        } else {
                            this.orderItemList[index].returnQuantity = selectedReturnQuantity;
                        }
                    }
                    if (this.orderItemList[index].id == parentProdId) {
                        this.orderItemList[index].returnQuantity = selectedReturnQuantity;
                    }
                }

                for (let index = 0; index < this.returnItemList.length; index++) {
                    if (this.returnItemList[index].id == relatedCoreProdId) {
                        if (selectedReturnQuantity > this.prodQtyMap.get(relatedCoreProdId)) {
                            this.returnItemList[index].returnQuantity = this.prodQtyMap.get(relatedCoreProdId);
                        } else {
                            this.returnItemList[index].returnQuantity = selectedReturnQuantity;
                        }
                    }
                    if (this.orderItemList[index].id == parentProdId) {
                        this.orderItemList[index].returnQuantity = selectedReturnQuantity;

                    }
                }

            }
        } else {
            let selectItemId = event.target.getAttribute('data-id');
            for (let index = 0; index < this.orderItemList.length; index++) {
                if (this.orderItemList[index].id == selectItemId) {
                    this.orderItemList[index].returnQuantity = selectedReturnQuantity;
                    break;
                }
            }

            for (let index = 0; index < this.returnItemList.length; index++) {
                if (this.returnItemList[index].id == selectItemId) {
                    this.returnItemList[index].returnQuantity = selectedReturnQuantity;
                    break;
                }
            }
        }
        this.calculateEstimatedAmount();
    }

    handleOrderItems(event) {
        //---------------------------
        var arrayOfSelectedItems = [];
        var selectedReturnQuantity;
        let isParentCoreCharge = event.target.getAttribute('data-parentcorecharge');

        //-----Manage top level checkbox---------------------
        let parentProdId = event.target.getAttribute('data-id');

        if (event.target.checked == true) {
            //------------------------------
            let selectedRows = this.template.querySelectorAll('lightning-input');
            for (let i = 1; i < selectedRows.length; i++) {
                if (selectedRows[i].type === 'checkbox') {
                    if (selectedRows[i].checked && selectedRows[i].name !== undefined) {
                        arrayOfSelectedItems.push(selectedRows[i].name);
                    }
                    if (selectedRows[i].checked === false && selectedRows[i].disabled && selectedRows[i].name !== undefined) {
                        arrayOfSelectedItems.push(selectedRows[i].name);
                    }
                }
            }
            //-----------------------------------
            if (isParentCoreCharge) {
                if (this.relatedProductMap.has(parentProdId)) {
                    let relatedCoreProdId = this.relatedProductMap.get(parentProdId).ccrz__RelatedProduct__c;
                    if (arrayOfSelectedItems.length > 0) {
                        if (!arrayOfSelectedItems.includes(relatedCoreProdId)) {
                            arrayOfSelectedItems.push(relatedCoreProdId);
                        }

                    } else {
                        arrayOfSelectedItems.push(parentProdId);
                        arrayOfSelectedItems.push(relatedCoreProdId);
                    }
                }
            } else {
                arrayOfSelectedItems.push(parentProdId);
            }

            let allItemsCount = this.nonReturnableProductCount + [...new Set(arrayOfSelectedItems)].length;
            if (this.orderItemList.length == allItemsCount) {
                let topCheckBox = this.template.querySelector('.toplevelCheckbox');
                topCheckBox.checked = true;
            }
        } else {
            if (isParentCoreCharge) {
                if (this.relatedProductMap.has(parentProdId)) {
                    let relatedCoreProdId = this.relatedProductMap.get(parentProdId).ccrz__RelatedProduct__c;
                    if (arrayOfSelectedItems.length > 0) {
                        if (arrayOfSelectedItems.includes(parentProdId)) {
                            const parentProdIdIndex = arrayOfSelectedItems.indexOf(parentProdId);
                            if (parentProdIdIndex > -1) {
                                arrayOfSelectedItems.splice(parentProdIdIndex, 1);
                            }
                        }
                        if (arrayOfSelectedItems.includes(relatedCoreProdId)) {
                            const relatedCoreProdIdIndex = arrayOfSelectedItems.indexOf(relatedCoreProdId);
                            if (relatedCoreProdIdIndex > -1) {
                                arrayOfSelectedItems.splice(relatedCoreProdIdIndex, 1);
                            }
                        }
                    }
                }
            } else {
                const parentProdIdIndex = arrayOfSelectedItems.indexOf(parentProdId);
                if (parentProdIdIndex > -1) {
                    arrayOfSelectedItems.splice(parentProdIdIndex, 1);
                }
            }
            let topCheckBox = this.template.querySelector('.toplevelCheckbox');
            topCheckBox.checked = false;

        }
        //-------Core charge handle-
        if (isParentCoreCharge) {
            let parentProdId = event.target.getAttribute('data-id');
            if (this.relatedProductMap.has(parentProdId)) {
                let relatedCoreProdId = this.relatedProductMap.get(parentProdId).ccrz__RelatedProduct__c;
                let relatedCoreProdQty = this.prodQtyMap.get(relatedCoreProdId);
                //---------Checked and disable core line item via parent controlling checkbox within 30 days-----------------------  
                let selectedRows = this.template.querySelectorAll('lightning-input');
                for (let i = 1; i < selectedRows.length; i++) {
                    if (selectedRows[i].type === 'checkbox') {
                        if (selectedRows[i].disabled === false && selectedRows[i].name === relatedCoreProdId && event.target.checked === true) {
                            selectedRows[i].checked = true;
                            selectedRows[i].disabled = true;
                        }
                        if (selectedRows[i].disabled === true && selectedRows[i].name === relatedCoreProdId && event.target.checked === false && relatedCoreProdQty > 0) {
                            selectedRows[i].checked = false;
                            selectedRows[i].disabled = false;
                        }

                    }
                }
                //--------------------------------

                //--------Disable core product qty field
                let allQtyRows = this.template.querySelectorAll('.Quantity');
                for (let i = 1; i < allQtyRows.length; i++) {
                    if (allQtyRows[i].name === relatedCoreProdId && event.target.checked === true) {
                        allQtyRows[i].disabled = true;
                    }
                    if (allQtyRows[i].name === relatedCoreProdId && event.target.checked === false) {
                        allQtyRows[i].disabled = false;
                    }

                }
                //-------------------------------------
                for (let index = 0; index < this.orderItemList.length; index++) {
                    if (this.orderItemList[index].id == parentProdId) {
                        selectedReturnQuantity = this.orderItemList[index].returnQuantity;
                    }
                }
                for (let index = 0; index < this.orderItemList.length; index++) {
                    if (this.orderItemList[index].id == relatedCoreProdId) {
                        if (event.target.checked) {
                            if (selectedReturnQuantity > this.prodQtyMap.get(relatedCoreProdId)) {
                                this.orderItemList[index].returnQuantity = this.prodQtyMap.get(relatedCoreProdId);
                            } else {
                                this.orderItemList[index].returnQuantity = selectedReturnQuantity;
                            }

                            //---Removing if relatedCore Product already in list
                            for (let i = 0; i < this.returnItemList.length; i++) {
                                if (this.returnItemList[i].id === relatedCoreProdId) {
                                    this.returnItemList.splice(i, 1);
                                }
                            }
                            if (this.prodQtyMap.get(relatedCoreProdId) > 0) {
                                this.returnItemList.push(this.orderItemList[index]);
                            }

                        } else {
                            this.returnItemList = this.returnItemList.filter(item => item.id != relatedCoreProdId);
                        }
                    }
                    if (this.orderItemList[index].id == parentProdId) {
                        if (event.target.checked) {
                            this.returnItemList.push(this.orderItemList[index]);
                        } else {
                            this.returnItemList = this.returnItemList.filter(item => item.id != parentProdId);

                        }

                    }
                }

            }
        } else {
            let selectItemId = event.target.getAttribute('data-id');

            for (let index = 0; index < this.orderItemList.length; index++) {
                if (this.orderItemList[index].id == selectItemId) {

                    if (event.target.checked) {
                        this.returnItemList.push(this.orderItemList[index]);
                    } else {
                        this.returnItemList = this.returnItemList.filter(item => item.id != selectItemId);
                    }

                    break;
                }

            }
        }
        if (this.returnItemList.length > 0) {
            this.isDisable = false;
            this.btnLabel = dbu_Return_BtnLabel_Proceed;
        } else {
            this.btnLabel = dbu_Return_BtnLabel_ProceedToReturn;
            this.isDisable = true
            let topCheckbox = this.template.querySelector('.toplevelCheckbox');
            topCheckbox.checked = false;
        }

        this.calculateEstimatedAmount();
    }

    calculateEstimatedAmount() {

        let priceToBeReduced;
        let returnTax = 0.00;
        let returnPrice = 0.00;
        let perItemTax;
        let totalVertaxTax = 0.00;
        if (this.returnItemList.length == 0) {
            this.totalOrderItemPrice = perfixCurrencyISOCode(this.currencyCode, returnPrice);
            this.refundedTax = perfixCurrencyISOCode(this.currencyCode, returnTax);
            return;
        }
        this.returnItemList.forEach(returnItem => {
            // Regex to remove commas from price.
            returnItem.price = returnItem.price.replace(/\,/g, '');
            // Calculate handling fee for core charge 
            if (returnItem.coreCharge === true && this.orderDaysCompleted > 45 && this.orderDaysCompleted <= 90) {
                if (returnItem.vertexTax != undefined && returnItem.vertexTax != null) {
                    perItemTax = returnItem.vertexTax / returnItem.quantity;
                    totalVertaxTax = returnItem.returnQuantity * perItemTax;
                    priceToBeReduced = returnItem.returnQuantity * returnItem.price.replace(/[^\d\.]/g, '');
                    let handlingFee = (priceToBeReduced / 100) * 10;
                    returnPrice = returnPrice + (priceToBeReduced - handlingFee) + totalVertaxTax;
                    returnTax = returnTax + totalVertaxTax;
                } else {
                    priceToBeReduced = returnItem.returnQuantity * returnItem.price.replace(/[^\d\.]/g, '');
                    let handlingFee = (priceToBeReduced / 100) * 10;
                    returnPrice = returnPrice + (priceToBeReduced - handlingFee);
                }
            } else {
                // Calculate handling fee for normal product 
                if (returnItem.returnReason == dbu_Return_Part_no_longer_wanted || returnItem.returnReason == dbu_Return_Ordered_the_wrong_part) {
                    if (returnItem.vertexTax != undefined && returnItem.vertexTax != null) {
                        perItemTax = returnItem.vertexTax / returnItem.quantity;
                        totalVertaxTax = returnItem.returnQuantity * perItemTax;
                        returnTax = returnTax + totalVertaxTax;
                        priceToBeReduced = (returnItem.returnQuantity * returnItem.price.replace(/[^\d\.]/g, ''));

                    } else {
                        priceToBeReduced = (returnItem.returnQuantity * returnItem.price.replace(/[^\d\.]/g, ''));
                    }

                    let handlingFee = (priceToBeReduced / 100) * 15;
                    returnPrice = returnPrice + (priceToBeReduced - handlingFee) + totalVertaxTax;
                    returnItem.dispalyHandleFee = true;

                } else {
                    if (returnItem.vertexTax != undefined && returnItem.vertexTax != null) {
                        perItemTax = returnItem.vertexTax / returnItem.quantity;
                        totalVertaxTax = returnItem.returnQuantity * perItemTax;
                        returnTax = returnTax + totalVertaxTax;
                        priceToBeReduced = (returnItem.returnQuantity * returnItem.price.replace(/[^\d\.]/g, '')) + totalVertaxTax;
                    } else {
                        priceToBeReduced = (returnItem.returnQuantity * returnItem.price.replace(/[^\d\.]/g, ''));
                    }
                    returnPrice = returnPrice + priceToBeReduced;
                    returnItem.dispalyHandleFee = false;

                }
            }
            console.log('totalVertaxTax-------' + totalVertaxTax);
            console.log('priceToBeReduced-------' + priceToBeReduced);
        });

        this.refundedTax = perfixCurrencyISOCode(this.currencyCode, returnTax);
        this.totalOrderItemPrice = perfixCurrencyISOCode(this.currencyCode, returnPrice);
        this.totalRefundAmount = returnPrice;
    }

    handleAllOrderItems(event) {
        this.selectedItemsCount = 0;
        this.returnItemList = [];
        var returnTax = 0.00;
        let amt = 0.00;
        let perItemTax;
        let totalVertaxTax = 0.00;
        let selectedRows = this.template.querySelectorAll('lightning-input');
        this.totalOrderItemPrice = perfixCurrencyISOCode(this.currencyCode, 0.00);
        this.refundedTax = perfixCurrencyISOCode(this.currencyCode, 0.00);
        var checkedOrderItems = event.target.getAttribute('data-checked');
        //----Handle Core Charge
        if (this.orderHasCoreCharge) {
            for (let i = 1; i < selectedRows.length; i++) {
                if (selectedRows[i].type === 'checkbox') {
                    if (selectedRows[i].disabled === false) {
                        selectedRows[i].checked = event.target.checked;

                        let prodId = selectedRows[i].name;
                        if (this.relatedProductMap.has(prodId)) {
                            let relatedCoreProdId = this.relatedProductMap.get(prodId).ccrz__RelatedProduct__c;
                            let relatedCoreProdQty = this.prodQtyMap.get(relatedCoreProdId);
                            for (let i = 1; i < selectedRows.length; i++) {
                                if (selectedRows[i].name === relatedCoreProdId && selectedRows[i].disabled === false && event.target.checked === true) {
                                    selectedRows[i].checked = true;
                                    selectedRows[i].disabled = true;
                                }
                                if (selectedRows[i].disabled === true && selectedRows[i].name === relatedCoreProdId && event.target.checked === false && relatedCoreProdQty > 0) {
                                    selectedRows[i].checked = false;
                                    selectedRows[i].disabled = false;
                                }
                            }
                            //--------Disable core product qty field
                            let allQtyRows = this.template.querySelectorAll('.Quantity');
                            for (let i = 1; i < allQtyRows.length; i++) {
                                if (allQtyRows[i].name === relatedCoreProdId && event.target.checked === true) {
                                    allQtyRows[i].disabled = true;
                                }
                                if (allQtyRows[i].name === relatedCoreProdId && event.target.checked === false) {
                                    allQtyRows[i].disabled = false;
                                }

                            }
                            //-------------------------------------
                        }
                    }
                }
            }
        } else {
            //-----------------
            for (let i = 1; i < selectedRows.length; i++) {
                if (selectedRows[i].type === 'checkbox') {
                    if (selectedRows[i].disabled === false) {
                        selectedRows[i].checked = event.target.checked;
                    }

                }
            }
        }
        if (event.target.checked === true) {
            let selectItemId = event.target.getAttribute('data-id');
            for (let index = 0; index < this.orderItemList.length; index++) {
                if (this.orderItemList[index].isProductReturnable === false) {
                    this.returnItemList.push(this.orderItemList[index]);
                }

            }
            let totalPrice = 0.00;
            for (let index = 0; index < this.returnItemList.length; index++) {
                //Regex to remove commas from price;
                this.returnItemList[index].price = this.returnItemList[index].price.replace(/\,/g, '');
                // Calculate 10% handling fee for core charge
                if (this.returnItemList[index].coreCharge === true && this.orderDaysCompleted > 45 && this.orderDaysCompleted <= 90) {
                    if (this.returnItemList[index].vertexTax != undefined && this.returnItemList[index].vertexTax != null) {
                        //  priceToBeReduced = returnItem.returnQuantity * returnItem.price.replace(/\$/g, '');
                        perItemTax = this.returnItemList[index].vertexTax / this.returnItemList[index].quantity;
                        totalVertaxTax = this.returnItemList[index].quantity * perItemTax;
                        let amt = this.returnItemList[index].quantity * this.returnItemList[index].price.replace(/[^\d\.]/g, '');
                        let handlingFee = (amt / 100) * 10;

                        totalPrice = totalPrice + (amt - handlingFee) + totalVertaxTax;
                        returnTax = returnTax + totalVertaxTax;
                    } else {
                        let amt = this.returnItemList[index].quantity * this.returnItemList[index].price.replace(/[^\d\.]/g, '');
                        let handlingFee = (amt / 100) * 10;
                        totalPrice = totalPrice + (amt - handlingFee);
                    }
                } else {

                    // Calculate handling fee for normal product 
                    if (this.returnItemList[index].returnReason == dbu_Return_Part_no_longer_wanted || this.returnItemList[index].returnReason == dbu_Return_Ordered_the_wrong_part) {
                        if (this.returnItemList[index].vertexTax != undefined && this.returnItemList[index].vertexTax != null) {
                            perItemTax = this.returnItemList[index].vertexTax / this.returnItemList[index].quantity;
                            totalVertaxTax = this.returnItemList[index].returnQuantity * perItemTax;
                            returnTax = returnTax + totalVertaxTax;
                            amt = (this.returnItemList[index].returnQuantity * this.returnItemList[index].price.replace(/[^\d\.]/g, ''));

                        } else {
                            amt = (this.returnItemList[index].returnQuantity * this.returnItemList[index].price.replace(/[^\d\.]/g, ''));
                        }

                        let handlingFee = (amt / 100) * 15;
                        totalPrice = totalPrice + (amt - handlingFee) + totalVertaxTax;

                    } else {
                        if (this.returnItemList[index].vertexTax != undefined && this.returnItemList[index].vertexTax != null) {
                            perItemTax = this.returnItemList[index].vertexTax / this.returnItemList[index].quantity;
                            totalVertaxTax = this.returnItemList[index].returnQuantity * perItemTax;
                            returnTax = returnTax + totalVertaxTax;
                            amt = (this.returnItemList[index].returnQuantity * this.returnItemList[index].price.replace(/[^\d\.]/g, '')) + totalVertaxTax;
                        } else {
                            amt = (this.returnItemList[index].returnQuantity * this.returnItemList[index].price.replace(/[^\d\.]/g, ''));

                        }
                        totalPrice = totalPrice + amt;
                        //  returnItem.dispalyHandleFee = false;

                    }

                    //--------------------------------------
                }
                this.totalOrderItemPrice = perfixCurrencyISOCode(this.currencyCode, totalPrice);
                this.refundedTax = perfixCurrencyISOCode(this.currencyCode, returnTax);

                this.totalRefundAmount = this.totalOrderItemPrice;

            }
            if (this.returnItemList.length > 0) {
                this.isDisable = false;
                this.btnLabel = dbu_Return_BtnLabel_Proceed;
            } else {
                this.btnLabel = dbu_Return_BtnLabel_ProceedToReturn;
                this.isDisable = true
            }
        } else {
            this.totalOrderItemPrice = perfixCurrencyISOCode(this.currencyCode, 0.00);
            this.returnItemList = [];

        }
        if (this.returnItemList.length > 0) {
            this.btnLabel = dbu_Return_BtnLabel_Proceed;
            this.isDisable = false;
        } else {
            this.btnLabel = dbu_Return_BtnLabel_ProceedToReturn;
            this.isDisable = true;
        }
    }
    sendRequest() {
        this.isLoading = true;
        let addInfo = this.template.querySelector(".addInformation").value.trim();
        console.log('addInfo==='+addInfo);
        for (let index = 0; index < this.returnItemList.length; index++) {
            if ((this.returnItemList[index].returnReason === '' || this.returnItemList[index].returnReason === undefined) && this.returnItemList[index].coreCharge === undefined) {
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: dbu_Return_Toast_ReasonForReturn,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.isLoading = false;
                this.dispatchEvent(evt);
                return;
            }
            
        }
        if(this.displayError && (addInfo === '' || addInfo === null || addInfo === undefined)){
            this.isLoading = false;
            return;
        }
       // this.isRequired = true;
        
        console.log('====EST REFUND AMOUNT===' + this.totalRefundAmount.toString());
        partialReturnOrder({
            orderData: this.returnItemList,
            addInfo: addInfo,
            estimatedReturnAmount: this.totalRefundAmount.toString(),
            orderId: this.orderId,
            storeLanguage : this.sendLocBackToChangeLocTile

        })
            .then(result => {
                invokeGoogleAnalyticsService('BUTTON CLICK', {eventName : 'Proceed for refund method select', eventAction : 'Navigate from parts return page to select return method page'});                
                let urlString = window.location.origin;
                let redirectURL = urlString + communityName + 'return-method?orderid=' + this.orderId + '&store=' + this.sendLocBackToChangeLocTile;
                window.location.href  = redirectURL;
                /*this[NavigationMixin.Navigate]({
                    "type": "standard__webPage",
                    "attributes": {
                        "url": redirectURL
                    }
                });*/
            })
            .catch(error => {
                this.error = error.status;
                console.error('==' + error);
            });
    }

    handlegotomyorders(){
        if (this.isGuestUser === true) {
            invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname  : 'Naviate to the track order page from parts return page'});            
        }else{
            invokeGoogleAnalyticsService('CANCEL CLICKS', {eventname  : 'Naviate to the my account page from parts return page'});
        }
    }

    get goToMyOrders() {
        let urlString = window.location.origin;
        if (this.isGuestUser === true) {
            return urlString + communityName + 'track-order' + '?store=' + this.sendLocBackToChangeLocTile; // Need to check COmmunity page name in Custom Label
        } else {
            return urlString + communityName + 'my-account' + '?orders=true&store=' + this.sendLocBackToChangeLocTile;
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
       // let redirectURL = urlString + communityName + 'product?name=' + prodName + '&pId=' + prodId + '&store=' + this.sendLocBackToChangeLocTile;
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