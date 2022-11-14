//Test Class for HAPI_DataLoad_Queries
// Updated by Singaiah for MAR-1642 & MAR-1682
@isTest
public class HAPI_PriceLoad_Test 
{
	public static HAPI_Price_Load__c createTestHAPIPriceLoad(String version, String productSku, String accountGroupName, String priceListName, 
                                                             Double price, String priceSelectionMethod, 
                                                             Boolean subscriptionProduct, String subscriptionLength, String billingFrequency, 
                                                             Boolean doInsert)
    {
        HAPI_Price_Load__c  hapiPriceLoad = new HAPI_Price_Load__c();
        
        hapiPriceLoad.Version__c = version;
        
        hapiPriceLoad.Product_SKU__c = productSku;
        
        hapiPriceLoad.Account_Group_Name__c = accountGroupName;
        hapiPriceLoad.Price_Selection_Method__c = priceSelectionMethod;
        
        hapiPriceLoad.PriceList_Name__c = priceListName;
        hapiPriceLoad.Currency__c = 'USD';
        hapiPriceLoad.Price__c = price;
        
        hapiPriceLoad.Subscription_Product__c = subscriptionProduct;
        hapiPriceLoad.Subscription_Length__c = subscriptionLength;
        hapiPriceLoad.Billing_Frequency__c = billingFrequency;
            
        if(doInsert)
            insert hapiPriceLoad;
        
        return hapiPriceLoad;
    }
    
    static testMethod void insertPrices()
    {
        try
        {
            insertSubProdTermCustomSetting();
            
            List<HAPI_Product_Load__c> hapiProductLoadList = new List<HAPI_Product_Load__c>(); 
            
            // insert Aggregate Product
            hapiProductLoadList.add(HAPI_ProductLoad_Test.createTestHAPIProductLoad('t2.1', 'Test Product 1', 'Test-1', '[{Datasheets}#{Alternate Images}]', 
                                                              '[{Spotlight}]', null, '[{Test-1-1~Related}]', 
                                                              '[{Test Cat 1~Test Menu 1~None}#{Test Cat 2~Test Menu 2~Category}]', null, false));
            insert hapiProductLoadList;
            
            HAPI_ProductLoader.loadProductData('t2.1'); 
            
            List<HAPI_Price_Load__c> hapiPriceLoadList = new List<HAPI_Price_Load__c>(); 
            
            // all correct . Not a subscription product
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.1', 'Test-1', 'Test AccGrp 1', 'Test PL 1', 
                                                             Double.valueOf('20.00'), 'Best Price', 
                                                             false, null, null, 
                                                             false));
            
            // all correct . Not a subscription product - update
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.1', 'Test-1', 'Test AccGrp 1', 'Test PL 1', 
                                                             Double.valueOf('30.00'), 'Best Price', 
                                                             false, null, null, 
                                                             false));
            
            // all correct . subscription product
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.1', 'Test-1', 'Test AccGrp 1', 'Test PL 1', 
                                                             Double.valueOf('20.00'), 'Best Price', 
                                                             true, '1 Year', 'Monthly', 
                                                             false));
            
            // incorrect SKU
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.1', 'Test-12', 'Test AccGrp 1', 'Test PL 1', 
                                                             Double.valueOf('20.00'), 'Best Price', 
                                                             true, '1 Year', 'Monthly', 
                                                             false));
            
            // all correct new Acct grp and price list
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.1', 'Test-1', 'Test AccGrp 2', 'Test PL 2', 
                                                             Double.valueOf('30.00'), 'Best Price', 
                                                             true, '1 Year', 'Monthly', 
                                                             false));
            
            // incorrect combo
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.1', 'Test-1', 'Test AccGrp 2', 'Test PL 2', 
                                                             Double.valueOf('30.00'), 'Best Price', 
                                                             true, '1 Week', 'One Time', 
                                                             false));
            
            // incorrect price list selection method
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.1', 'Test-1', 'Test AccGrp 2', 'Test PL 2', 
                                                             Double.valueOf('30.00'), 'Best Pr', 
                                                             true, '1 Year', 'Monthly', 
                                                             false));
            
            // required field missing
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.1', 'Test-1', null, 'Test PL 2', 
                                                             Double.valueOf('30.00'), 'Best Price', 
                                                             true, '1 Year', 'Monthly', 
                                                             false));
            
            // SKU is null
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.1', null, 'Test AccGrp 2', 'Test PL 2', 
                                                             Double.valueOf('30.00'), 'Best Price', 
                                                             true, '1 Year', 'Monthly', 
                                                             false));
            
            insert hapiPriceLoadList;
            
            Test.StartTest();
                HAPI_PricingLoader_Batch batch = new HAPI_PricingLoader_Batch('t2.1');
                database.executeBatch(batch);
            Test.StopTest();
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString()); 
        }
    }
    
    static testMethod void insertPricesExceptionScenarios()
    {
        try
        {
            insertSubProdTermCustomSetting();
            
            List<HAPI_Product_Load__c> hapiProductLoadList = new List<HAPI_Product_Load__c>(); 
            
            // insert Aggregate Product
            hapiProductLoadList.add(HAPI_ProductLoad_Test.createTestHAPIProductLoad('t2.2', 'Test Product 1', 'Test-1', '[{Datasheets}#{Alternate Images}]', 
                                                              '[{Spotlight}]', null, '[{Test-1-1~Related}]', 
                                                              '[{Test Cat 1~Test Menu 1~None}#{Test Cat 2~Test Menu 2~Category}]', null, false));
            insert hapiProductLoadList;
            
            HAPI_ProductLoader.loadProductData('t2.2'); 
            
            List<HAPI_Price_Load__c> hapiPriceLoadList = new List<HAPI_Price_Load__c>(); 
            
            // all correct . subscription product
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.0', 'Test-1', 'Test AccGrp 1', 'Test PL 1', 
                                                          Double.valueOf('20.00'), 'Best Price', 
                                                          true, '1 Year', 'Monthly', 
                                                          false));
            
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.1', 'Test-1', 'Test AccGrp 1', 'Test PL 1', 
                                                          Double.valueOf('20.00'), 'Best Price', 
                                                          true, '1 Year', 'Monthly', 
                                                          false));
            
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.2', 'Test-1', 'Test AccGrp 1', 'Test PL 1', 
                                                             Double.valueOf('20.00'), 'Best Price', 
                                                             true, '1 Year', 'Monthly', 
                                                             false));
            
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.3', 'Test-1', 'Test AccGrp 1', 'Test PL 1', 
                                                             Double.valueOf('20.00'), 'Best Price', 
                                                             true, '1 Year', 'Monthly', 
                                                             false));
            
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.4', 'Test-1', 'Test AccGrp 1', 'Test PL 1', 
                                                             Double.valueOf('20.00'), 'Best Price', 
                                                             true, '1 Year', 'Monthly', 
                                                             false));
            
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.5', 'Test-1', 'Test AccGrp 1', 'Test PL 1', 
                                                             Double.valueOf('20.00'), 'Best Price', 
                                                             true, '1 Year', 'Monthly', 
                                                             false));
            
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.6', 'Test-1', 'Test AccGrp 1', 'Test PL 1', 
                                                             Double.valueOf('20.00'), 'Best Price', 
                                                             true, '1 Year', 'Monthly', 
                                                             false));
            
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.7', 'Test-1', 'Test AccGrp 1', 'Test PL 1', 
                                                             Double.valueOf('20.00'), 'Best Price', 
                                                             true, '1 Year', 'Monthly', 
                                                             false));
            
            hapiPriceLoadList.add(createTestHAPIPriceLoad('t2.8', 'Test-1', 'Test AccGrp 1', 'Test PL 1', 
                                                             Double.valueOf('20.00'), 'Best Price', 
                                                             true, '1 Year', 'Monthly', 
                                                             false));
            
            insert hapiPriceLoadList;
            
            HAPI_PriceLoader.testCase = 'accountGroupException';
            HAPI_PriceLoader.loadPricingData(hapiPriceLoadList.get(0));
            
            HAPI_PriceLoader.testCase = 'pricelistException';
            HAPI_PriceLoader.loadPricingData(hapiPriceLoadList.get(1));
            
            HAPI_PriceLoader.testCase = 'accountgrp_pricelistException';
            HAPI_PriceLoader.loadPricingData(hapiPriceLoadList.get(2));
            
            HAPI_PriceLoader.testCase = 'pricelistItemException';
            HAPI_PriceLoader.loadPricingData(hapiPriceLoadList.get(3));
            
            HAPI_PriceLoader.testCase = 'subProdTermException';
            HAPI_PriceLoader.loadPricingData(hapiPriceLoadList.get(4));
            
            HAPI_PriceLoader.testCase = 'recurringPriceListItemException';
            HAPI_PriceLoader.loadPricingData(hapiPriceLoadList.get(5));
            
            HAPI_PriceLoader.testCase = 'nonrecurringPriceListItemException';
            HAPI_PriceLoader.loadPricingData(hapiPriceLoadList.get(6));
            
            HAPI_PriceLoader.testCase = 'allPriceListItemException';
            HAPI_PriceLoader.loadPricingData(hapiPriceLoadList.get(7));
            
            HAPI_PriceLoader.testCase = 'generalException';
            HAPI_PriceLoader.loadPricingData(hapiPriceLoadList.get(8));
            
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString()); 
        }
    }
    
    public static void insertSubProdTermCustomSetting()
    {
        ccrz_SubProdTerm__c customSettingSubProdTerm = new ccrz_SubProdTerm__c();
        customSettingSubProdTerm.Name = 'SubProd12';
        customSettingSubProdTerm.Effective_End__c = System.today().addMonths(10);
        customSettingSubProdTerm.Effective_Start__c = System.today();
        customSettingSubProdTerm.Display_Name__c = '1 Year'; 
        customSettingSubProdTerm.DisplayNameR__c = '1 Year';
        customSettingSubProdTerm.OrderDisplayName__c = '1 Year';
        customSettingSubProdTerm.OrderDisplayNameRT__c = '1 Year';
        customSettingSubProdTerm.EmailDisplayNameRT__c = 'xyz4@xyz.com';
        customSettingSubProdTerm.Enabled__c = true;
        customSettingSubProdTerm.IgnoreInstallmentFrequencyFields__c = false;
        customSettingSubProdTerm.InstallmentCount__c = 12;
        customSettingSubProdTerm.InstallmentFrequencyUOM__c = 'Monthly';
        customSettingSubProdTerm.InstallmentFrequency__c = 1.00;
        customSettingSubProdTerm.Order_Count__c = 1;
        customSettingSubProdTerm.OrderFrequency__c = 1.00;
        customSettingSubProdTerm.OrderFrequencyUOM__c = 'Yearly';
        customSettingSubProdTerm.Sequence__c = 2;
        customSettingSubProdTerm.Storefront__c = 'SoftwareStore';
        customSettingSubProdTerm.Billing_Display_Name__c = 'Monthly';
        
        insert customSettingSubProdTerm;
    }
}