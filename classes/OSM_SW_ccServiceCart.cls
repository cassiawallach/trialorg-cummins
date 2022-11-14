global with sharing  class OSM_SW_ccServiceCart extends ccrz.ccServiceCart // <1>
{

    
    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) // <2>
    {
        inputData = super.getFieldsMap(inputData); // <3>
        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);  // <3>
        objectFields += ',Total_Prorated_Amount__c,OSM_SW_Is_third_Party_BMS_Payment__c,ccrz__Account__r.name,Sum_Prorated_Price_AfterDiscount__c,Sum_Original_Prorated_Subtotal__c,ccrz__Contact__r.FirstName,ccrz__Contact__r.LastName';  // <4>
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'M:X','OSM_SW_ccServiceCartItem:getFieldsMap:inputData '+inputData);
        return new Map <String,Object> {ccrz.ccService.OBJECTFIELDS => objectFields};  // <5>
    }

global override Map<String, Object> getDirectQueryMap(Map<String, Object> inputData)
{
    
    

return CUSTOM_DIRECTQUERYMAP;
}

private static final Map<String, Object> CUSTOM_DIRECTQUERYMAP = new Map<String, Object>{
                                  
                                'E_CartItems__r'=>'SELECT PricingType__c,NonCartUpdate__c, Vertex_tax__c,Billing_Frequency__c, ProductPackage__c,Cart__r.Name,ExtName__c, ExtSKU__c, Id, AbsoluteDiscount__c,OSM_SW_AddOn_Product_Of__c,AdjustmentAmount__c,AvailabilityMessage__c,Cart__c,CartItemGroup__c,CartItemType__c,Category__c,Coupon__c,Comments__c,DisplayProduct__c,Is_Subscription_Selected__c,ItemLabel__c,ItemStatus__c,ItemTotal__c,Name,OriginalQuantity__c,ParentCartItem__c,ParentProduct__c,PercentDiscount__c,Price__c,OriginalItemPrice__c,Product__c,Product__r.ProductType__c,Product__r.ProductStatus__c,Product__r.StartDate__c,Product__r.ccrz__SKU__c,Product__r.EndDate__c,ProductType__c,Quantity__c,RequestDate__c,StoreId__c,SubAmount__c,Subscription_Duration__c,Subscription_Frequency__c,UnitOfMeasure__c,Actual_Tax__c,SubProdTerm__c,RecurringPrice__c,RecurringPriceSubAmt__c,Seller__c,PrimaryAttr__c,PrimaryAttr__r.ParentAttribute__c,SecondaryAttr__c, SecondaryAttr__r.ParentAttribute__c,TertiaryAttr__c, TertiaryAttr__r.ParentAttribute__c,SelectedAttr__c FROM E_CartItem__c WHERE Cart__c IN :cartIds',
                                'E_CartItemPricingTier__c'=>'SELECT Id, Name, CartItem__c, CartItemPricingTierId__c, Price__c, Quantity__c, SubAmount__c FROM E_CartItemPricingTier__c WHERE CartItem__c in :cartItemIds'
                         };


    

}