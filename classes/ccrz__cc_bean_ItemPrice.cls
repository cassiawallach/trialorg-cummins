/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_bean_ItemPrice {
    global List<ccrz.cc_bean_PriceMeta> adjustments {
        get;
        set;
    }
    global Map<String,Decimal> componentProducts {
        get;
        set;
    }
    global Boolean external {
        get;
        set;
    }
    global Map<String,Object> extrinisic {
        get;
        set;
    }
    global String itemID {
        get;
        set;
    }
    global String parentID {
        get;
        set;
    }
    global List<ccrz.cc_bean_PriceMeta> priceEntries {
        get;
        set;
    }
    global Decimal quantity {
        get;
        set;
    }
    global String sku {
        get;
        set;
    }
    global String unitOfMeasure {
        get;
        set;
    }
    global cc_bean_ItemPrice() {

    }
    global cc_bean_ItemPrice(ccrz__E_PriceListItem__c priceItem, String priceType) {

    }
    global cc_bean_ItemPrice(List<ccrz__E_PriceListItem__c> priceItems, String priceType) {

    }
    global cc_bean_ItemPrice(String sku, String uom, Decimal qty) {

    }
    global cc_bean_ItemPrice(String sku, String uom, Decimal qty, String parent) {

    }
    global void addItems(List<ccrz__E_PriceListItem__c> priceItems, String priceType) {

    }
}
