Public Class OSM_FetchCustomMetaData_Ctrl
{
    public static Map<String, OSM_Southern_Plain__mdt> getSouthernPlainMetaDataMap(){
        List<OSM_Southern_Plain__mdt> osmSouthernPlainMetaDataList = [Select Label,BC_Code__c,RC_Code__c,Division_Code__c,CC_Bill_From_Remit_To__c,PO_Bill_From_Remit_To__c,Distributor_Code__c from OSM_Southern_Plain__mdt];
        
        Map<String, OSM_Southern_Plain__mdt> southernPlainMap = new Map<String, OSM_Southern_Plain__mdt>();
        for(OSM_Southern_Plain__mdt osmSouthernPlain: osmSouthernPlainMetaDataList){
            southernPlainMap.put(osmSouthernPlain.Distributor_Code__c, osmSouthernPlain);
        }
        
        return southernPlainMap;
    }
    //MP-136 Code Start - 28-10-2021
    public static Map<String, OSM_SubscriptionLength__mdt> getSubscriptionMetaDataMap(){
        List<OSM_SubscriptionLength__mdt> osmSubscriptionLengthMetaDataList = [Select Label,Product_SKU__c,Subscription_Length__c from OSM_SubscriptionLength__mdt];
        
        Map<String, OSM_SubscriptionLength__mdt> subscriptionLengthMap = new Map<String, OSM_SubscriptionLength__mdt>();
        for(OSM_SubscriptionLength__mdt osmSubsLength: osmSubscriptionLengthMetaDataList){
            subscriptionLengthMap.put(osmSubsLength.Product_SKU__c, osmSubsLength);
        }
        
        return subscriptionLengthMap;
    }//MP-136 Code End- 28-10-2021
}