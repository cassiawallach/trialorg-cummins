global with sharing  class OSM_SW_ccServiceCartItem extends ccrz.ccServiceCartItem // <1>
{
    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) // <2>
    {
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'M:X','OSM_SW_ccServiceCartItem:getFieldsMap:inputData '+inputData);
        inputData = super.getFieldsMap(inputData); // <3>
        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);  // <3>
        //Subscription_Expiry_Date__c added by swetha
        objectFields += ',Custom_Proration_Price__c,OSM_SW_isCPGProduct__c,OSM_SW_Product_Link__r.ccrz__SKU__c,OSM_Renew_Subscription_Start_Date__c ,OSM_Renew_Subscription_End_Date__c ,NonCartUpdate__c,Coupon__r.CouponCode__c, isRenew__c,OSM_SW_AddOn_Product_Of__c,Billing_Frequency__c,OSM_Group_Name__c,Prorated_Price_AfterDiscount__c,Prorated_Price__c,Subscription_Expiry_Date__c,Prorated_Subamount__c,Prorated_Coupon_Discount__c,withCoTerm__c';  // <4>
        return new Map <String,Object> {ccrz.ccService.OBJECTFIELDS => objectFields};  // <5>
    }
     
}