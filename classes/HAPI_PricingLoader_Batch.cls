global class HAPI_PricingLoader_Batch implements Database.Batchable<sObject>,Database.AllowsCallouts
{
    String version;
    
    global HAPI_PricingLoader_Batch()
    {
        
    }
    
    global HAPI_PricingLoader_Batch(String userInputVersion)
    {
        version = userInputVersion;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Account_Group_Name__c, Currency__c, Data_Fully_Uploaded__c, Data_Partially_Uploaded__c, Error_Message__c, Message__c, Price__c, Distributor_Price__c, PriceList_Name__c, Price_Selection_Method__c, Product_SKU__c, Version__c, Subscription_Product__c, Subscription_Length__c, Billing_Frequency__c FROM HAPI_Price_Load__c WHERE Data_Fully_Uploaded__c=false AND Data_Partially_Uploaded__c=false';
        
        if(null != version && !String.isEmpty(version))
        {
            query = query + ' AND Version__c=:version';
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<HAPI_Price_Load__c> scope)
    {
        System.debug('Number of records picked up : ' + scope.size());
        for(HAPI_Price_Load__c hapiPriceLoad :scope)
        {
            // call the HapiLoader method
            HAPI_PriceLoader.loadPricingData(hapiPriceLoad);
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        System.debug('End : HAPI_PricingLoader_Batch');
    }
}