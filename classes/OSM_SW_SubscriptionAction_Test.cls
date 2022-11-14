//Test Class for the class OSM_SW_SubscriptionAction added for 1236
/**
VERSION          AUTHOR          DATE                 DETAIL
1.0             Singaiah         05-05-2021            Updated Test Class MAR-1642
2.0             Sharad           26-05-2021            Updated
3.0             Dhiraj           07-06-2021            Updated 
4.0             Singaiah         07-09-2021            Updated
4.1             Ashish           24/01/2022             MP-508
5.3             Subbu
**/
@isTest
public class OSM_SW_SubscriptionAction_Test 
{
    @testSetup static void setup() {
         
        CSS_Integration_Details__c objCID1 = new CSS_Integration_Details__c(AuthEnv__c = 'DA',
                                                                           IsActive__c = true,
                                                                           Timeout__c = 120000,
                                                                           Method_Type__c = 'POST',
                                                                           ApplicationName__c = 'DA-Test',
                                                                           Name = 'DA',
                                                                           Key__c = 'appSubscription-api-key',
                                                                           Passcode__c = 'Ih9Ivj3hoBRcSZYV7vtHoEPkwqcXoJgo76o9c64/GMw=',
                                                                           End_Point__c = 'https://services-dev.cummins.com/cso/taxquote');
        insert objCID1;
        
        
    
        CSS_Integration_Details__c objCID2 = new CSS_Integration_Details__c(AuthEnv__c = 'DA',
                                                                           IsActive__c = true,
                                                                           Timeout__c = 120000,
                                                                           Method_Type__c = 'POST',
                                                                           ApplicationName__c = 'GetOrder',
                                                                           Name = 'GetOrder',
                                                                           Key__c = 'appSubscription-api-key',
                                                                           Passcode__c = 'Ih9Ivj3hoBRcSZYV7vtHoEPkwqcXoJgo76o9c64/GMw=',
                                                                           End_Point__c = 'https://connectedsolutions-stg.cummins.com/appSubscriptionInternal/v1/subscription/orderUpdates');
        insert objCID2;
     }
     
    static testMethod void testFreeTrialSubscriptionOnInsert()  
    {
       /* TestProductSetupReq testProductSetupReq = OSM_TestDataCreationUtility.populatedTestProductSetupReq();
        
        TestProductSetupRes testProductSetupRes = OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq);


        TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes = OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes, 210.00, 10.00);*/
        //OSM_Incremental_Count__c countSetting= new OSM_Incremental_Count__c();
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
                  
   //     System.debug('transecRes: '+transecRes);

        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();                          
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        User usr=[Select id from User where Id=:UserInfo.getUserId()];
        System.runAs(usr) {
        OSM_Incremental_Count__c countSetting=new OSM_Incremental_Count__c();
        countSetting.Name='CurrentCount';
        countSetting.Current_Count__c='999';
        insert countSetting;
        
       // TestProductSetupReq testReq = new TestProductSetupReq();
        List<id> subscriptionIdList = new List<ID>();
            system.debug('Email Exception'+transecRes.subscription.ID);
        subscriptionIdList.add(transecRes.subscription.ID);
        Test.StartTest();
            try{
                  OSM_SW_SubscriptionAction.FreeTrialSubscriptionOnInsert(subscriptionIdList);
            }catch(exception ex){
                
            }
        
       
        
        Test.StopTest();
        }
    }
    
    static testMethod void testFreeTrialSubscriptionOnUpdate()
    {
       /* TestProductSetupReq testProductSetupReq = OSM_TestDataCreationUtility.populatedTestProductSetupReq();
        
        TestProductSetupRes testProductSetupRes = OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq);
        TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes = OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes, 210.00, 10.00);*/
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
                  
   //     System.debug('transecRes: '+transecRes);

        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();                          
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        User usr=[Select id from User where Id=:UserInfo.getUserId()];
        System.runAs(usr) {
        OSM_Incremental_Count__c countSetting=new OSM_Incremental_Count__c();
        countSetting.Name='CurrentCount';
        countSetting.Current_Count__c='999';
        insert countSetting;

        List<id> subscriptionIdList = new List<ID>();
        subscriptionIdList.add(transecRes.subscription.ID);
        
        String json = '{'+
        '  \"PreviousQuantity\": \"3\",'+
        '  \"CurrentQuantity\": \"5\",'+
        '  \"PreviousEndDate\": \"2018-03-23T13:14:00.000Z\",'+
        '  \"CurrentEndDate\": \"2018-12-23T13:14:00.000Z\",'+
        '  \"subscriptionId\": \"'+ID.valueOf(transecRes.subscription.ID)+ '\"'+
        '    }';
        
        OSM_WS_FreeTrialUpdateReqWrapper wrapper = new OSM_WS_FreeTrialUpdateReqWrapper();
        
        wrapper.CurrentEndDate = Date.valueOf('2018-12-23T13:14:00.000Z');
        wrapper.CurrentQuantity = 3;
        wrapper.PreviousEndDate = Date.valueOf('2018-03-23T13:14:00.000Z');
        wrapper.PreviousQuantity = 5;
        wrapper.subscriptionId = transecRes.subscription.ID;
        
       // json = JSON.serialize(wrapper);
        
        List<String> jsonList = new List<String>();
        jsonList.add(json);
        Test.StartTest();
        
        OSM_SW_SubscriptionAction.FreeTrialSubscriptionOnUpdate(jsonList);
       // OSM_SW_SubscriptionTriggerHandlerUtility.CallFreeTrialBusinessLayerForInsert(subscriptionIdList);
       // OSM_SW_SubscriptionTriggerHandlerUtility.CallFreeTrialBusinessLayerForUpdate(jsonList);
       OSM_SW_SubscriptionAction.guidenzmobileaccesscount();
        
        Test.StopTest();
        }
        
    }
    
    static testMethod void testFreeTrialSubscriptionOnInsert_ExceptionOccurs() 
    {
     /*   TestProductSetupReq testProductSetupReq = OSM_TestDataCreationUtility.populatedTestProductSetupReq();
        
        TestProductSetupRes testProductSetupRes = OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq);
        TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes = OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes, 210.00, 10.00);*/
      TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();                          
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        User usr=[Select id from User where Id=:UserInfo.getUserId()];
        System.runAs(usr) {
        OSM_Incremental_Count__c countSetting=new OSM_Incremental_Count__c();
        countSetting.Name='CurrentCount';
        countSetting.Current_Count__c='999';
        insert countSetting;
        List<id> subscriptionIdList = new List<ID>();
        subscriptionIdList.add(transecRes.subscription.ID);
        Test.StartTest();
         OSM_SW_SubscriptionAction.FreeTrialSubscriptionOnInsert(subscriptionIdList);
        
        Test.StopTest();
        }
    }
    
    public static ccrz__E_Product__c setUpProduct(String name, String sku, String productType, String qsolType)
    {
        ccrz__E_Product__c product = new ccrz__E_Product__c();
        product.isIAMProvisioningRequired__c = true;
        product.QSOLType__c = qsolType;
        product.Name = name;
        product.ccrz__ProductType__c = productType;
        product.ccrz__SKU__c = sku;
        product.ccrz__Storefront__c = 'SoftwareStore';
        product.ccrz__StartDate__c = system.today();
        product.ccrz__EndDate__c = system.today() + 1;
        
        return product;
    }
    
    public static Account setUpAccount()
    {
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.CHANNEL_OF_DISTRIBUTION__c = 'ABCDFLEET';
        acc.Business_Unit__c = 'EBU';
        
        return acc;
    }
    
    public static ccrz__E_Subscription__c setUpSubscription(ID accountID, ID subscriptionProductID)
    {
        ccrz__E_Subscription__c subscription = new ccrz__E_Subscription__c();
        subscription.ccrz__Quantity__c = 2;
        subscription.ccrz__SubscriptionStatus__c = 'Active';
        subscription.OSM_Subscription_End_Date__c = System.now() + Integer.valueof(365);
        subscription.ccrz__SubscriptionStartDate__c = System.now();
        subscription.ccrz__Account__c = accountID;
        subscription.ccrz__SubscriptionProduct__c = subscriptionProductID;
        subscription.ccrz__Sequence__c = 500;
        subscription.ccrz__Storefront__c = 'SoftwareStore';
        
        return subscription;
    }
    
    public static ccrz__E_CompositeProduct__c setUpCompositeProduct(ID compositeID, ID componentID, Integer qty, String unit)
    {
        ccrz__E_CompositeProduct__c compositeProduct = new ccrz__E_CompositeProduct__c();
        compositeProduct.ccrz__Quantity__c = qty;
        compositeProduct.ccrz__Composite__c = compositeID;
        compositeProduct.ccrz__Component__c = componentID;
        compositeProduct.ccrz__Sequence__c = 500;
        compositeProduct.Unit__c = unit;
        
        return compositeProduct;
    }
    
    static testMethod void iamProvisioningForBundle() 
    {
        Account acc = setUpAccount();
        insert acc;
        
        // Create Bundle Product
        ccrz__E_Product__c bundle_product = setUpProduct('Cummins Guidanz', 'CG-123', 'Bundle', '');
        insert bundle_product;
        
        // create a QSOL EBU Product
        ccrz__E_Product__c qsol_product = setUpProduct('QuickServe® Online Kit (QSOL, EDS, CVCOL )', 'QSOL-EBU-123', 'Product', 'EBU');
        insert qsol_product;
        
        // create a Guidanz Mobile Product
        ccrz__E_Product__c mobile_product = setUpProduct('Guidanz Mobile (Includes Immediate Assessment)', 'GZ-Mobile-005-1', 'Product', '');
        insert mobile_product;
        
        ccrz__E_CompositeProduct__c comp_1 = setUpCompositeProduct(bundle_product.ID, qsol_product.ID, 9999, 'Users');
        insert comp_1;
        
        ccrz__E_CompositeProduct__c comp_2 = setUpCompositeProduct(bundle_product.ID, mobile_product.ID, 2, 'Users');
        insert comp_2;
        
        ccrz__E_Subscription__c subscription = setUpSubscription(acc.ID, bundle_product.ID);
        insert subscription;
        
       
        
        Account acc2 = new Account();
        acc2.Name = 'TestAccount99';
        acc2.CHANNEL_OF_DISTRIBUTION__c = 'ABCDFLEET';
        acc2.Business_Unit__c = 'EBU';
        acc2.recordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc2.type='Votech';
        acc2.EBU_Channel_of_Distribution__c='Fleet';
        acc2.PSBU_Channel_of_Distribution__c='Fleet';
        insert acc2;
        
         ccrz__E_Subscription__c subscription2 = setUpSubscription(acc2.ID, mobile_product.ID);
        insert subscription2;
        
         List<Id> subscriptionIDList = new List<ID>();
        subscriptionIDList.add(subscription.ID);
        subscriptionIDList.add(subscription2.ID);
        
        IAM_Application__c app1 = new IAM_Application__c(IAM_Status__c='Active',
                                                        IAM_swregExpire__c = 'test',
                                                        IAM_Role__c='Guidanz Mobile Immediate Assessment Fleet',
                                                        IAM_Source__c = 'Marketplace',
                                                        IAM_Subscription_Count__c= 10,
                                                        IAM_Free_Subscription__c= False,
                                                        IAM_Provisioned_User_Count__c=1,
                                                        IAM_Account_Name__c = acc2.ID,
                                                        IAM_Application_Name__c = 'Guidanz Mobile',
                                                        IAM_Subscription_Name__c='TestSubscription1',
                                                        IAM_Subscription_Start_Date__c=System.today(),
                                                        IAM_Reject_Reason__c = 'Cancellation Comments',
                                                        IAM_Subscription_End_Date__c= System.today() + 5);
        
        insert app1;
        
        
        Test.startTest();
        
       // OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(subscriptionIDList);
        OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(subscriptionIDList, true, false);
        //OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(subscriptionIDList, false, true);
        
        OSM_Subscription_Account_Provision__c objSAP = new OSM_Subscription_Account_Provision__c(Subscription_Status__c = 'Active',
                                                                                                 Account_Features_Access__c = app1.Id,
                                                                                                 CC_Subscription__c = subscription2.Id);
        insert objSAP;
        
        OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(subscriptionIDList, true, false);
        
        Test.stopTest();
    }
    
    static testMethod void iamProvisioningForQSOL_CPG() 
    {
        Account acc = setUpAccount();
        acc.Type = 'Distributor Account';
        acc.CMI_Account_Status__c='Pending';
        acc.CMI_CDA_Status__c='New Customer Request';
        acc.CSS_DistributorCode__c = '10010';
        acc.IAM_Service_Provider_Code__c = '1339';
        insert acc;
        
        // create a QSOL EBU Product
        ccrz__E_Product__c qsol_product = setUpProduct('QuickServe® Online for Power Generation - Alternator', 'QSOL-CPG-123', 'Product', 'CPG');
        insert qsol_product;
        
        ccrz__E_Subscription__c subscription = setUpSubscription(acc.ID, qsol_product.ID);
        insert subscription;
        
        List<Id> subscriptionIDList = new List<ID>();
        subscriptionIDList.add(subscription.ID);
        
        IAM_Application__c cumpasApplication = new IAM_Application__c(    
            IAM_Account_Name__c = acc.ID,
            IAM_Application_Name__c = 'QuickServe Online',
            IAM_Role__c='QSOL Distributor',
            IAM_Status__c='Active',
            IAM_Subscription_Count__c= 7,
            IAM_Provisioned_User_Count__c=5,
            IAM_Subscription_End_Date__c= System.today() + 5,
            IAM_Subscription_Name__c='QuickServe Online EBU',
            IAM_Free_Subscription__c= False,
            IAM_Subscription_Start_Date__c=System.today(),
            IAM_Cumpas_Modularity__c = 'View Credit',
            IAM_Qsolexpiration__c = '12345'
        );
        
        insert cumpasApplication;
        
        Test.startTest();
        
        OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(subscriptionIDList, true, false);
        OSM_SW_SubscriptionAction.getIAMApplicationMap(new Set<String>{'QuickServe Online'}, new Set<String>{acc.ID}, new Set<String>());
        
        Test.stopTest();
    }
    
    static testMethod void iamProvisioningForQSOL_EBU() 
    {
        Account acc = setUpAccount();
        insert acc;
        
        // create a QSOL EBU Product
        ccrz__E_Product__c qsol_product = setUpProduct('QuickServe® Online Kit (QSOL, EDS, CVCOL )', 'QSOL-EBU-1234', 'Product', 'EBU');
        insert qsol_product;
        
        ccrz__E_Subscription__c subscription = setUpSubscription(acc.ID, qsol_product.ID);
        insert subscription;
        
        List<Id> subscriptionIDList = new List<ID>();
        subscriptionIDList.add(subscription.ID);
        
        IAM_Application__c app = new IAM_Application__c(IAM_Status__c='Active',
                                                        IAM_Role__c='PrimaryContact',
                                                        IAM_Source__c = 'Marketplace',
                                                        IAM_Subscription_Count__c= 10,
                                                        IAM_Provisioned_User_Count__c=5,
                                                        IAM_Free_Subscription__c= False,
                                                        IAM_Account_Name__c = acc.ID,
                                                        IAM_Subscription_Name__c='TestSubscription1',
                                                        IAM_Subscription_Start_Date__c=System.today(),
                                                        IAM_Reject_Reason__c = 'Cancellation Comments',
                                                        IAM_Subscription_End_Date__c= System.today() + 5,
                                                        IAM_Application_Name__c = 'Cummins Service Training');
        
        insert app;
            
        OSM_Subscription_Account_Provision__c objSAP = new OSM_Subscription_Account_Provision__c(Subscription_Status__c = 'Active',
                                                                                                 Account_Features_Access__c = app.Id,
                                                                                                 CC_Subscription__c = subscription.Id);
        insert objSAP; 
        
        Test.startTest();
        OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(subscriptionIDList, true, false);
        subscription.ccrz__SubscriptionStatus__c = 'Cancelled';
        update subscription;
        Test.stopTest();
    } 
    static testMethod void createIAMRecordTest() 
    {
        Account acc = setUpAccount();
        insert acc;
        
        // Create Bundle Product
        ccrz__E_Product__c bundle_product = setUpProduct('Cummins Guidanz', 'CG-123', 'Bundle', '');
        insert bundle_product;
        
        // create a QSOL EBU Product
        ccrz__E_Product__c qsol_product = setUpProduct('QuickServe® Online Kit (QSOL, EDS, CVCOL )', 'QSOL-EBU-123', 'Product', 'EBU');
        insert qsol_product;
        
        // create a Guidanz Mobile Product
        ccrz__E_Product__c mobile_product = setUpProduct('Guidanz Mobile (Includes Immediate Assessment)', 'GZ-Mobile-005-1', 'Product', '');
        insert mobile_product;
        
        ccrz__E_CompositeProduct__c comp_1 = setUpCompositeProduct(bundle_product.ID, qsol_product.ID, 9999, 'Users');
        insert comp_1;
        
        ccrz__E_CompositeProduct__c comp_2 = setUpCompositeProduct(bundle_product.ID, mobile_product.ID, 2, 'Users');
        insert comp_2;
        
        ccrz__E_Subscription__c subscription = setUpSubscription(acc.ID, bundle_product.ID);
        insert subscription;
        
       
        
        Account acc2 = new Account();
        acc2.Name = 'TestAccount99';
        acc2.CHANNEL_OF_DISTRIBUTION__c = 'ABCDFLEET';
        acc2.Business_Unit__c = 'EBU';
        acc2.recordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc2.type='Votech';
        acc2.EBU_Channel_of_Distribution__c='Fleet';
        acc2.PSBU_Channel_of_Distribution__c='Fleet';
        insert acc2;
        
         ccrz__E_Subscription__c subscription2 = setUpSubscription(acc2.ID, mobile_product.ID);
        insert subscription2;
        
         List<Id> subscriptionIDList = new List<ID>();
        subscriptionIDList.add(subscription.ID);
        subscriptionIDList.add(subscription2.ID);
        
        IAM_Application__c app1 = new IAM_Application__c(IAM_Status__c='Inactive',
                                                        IAM_swregExpire__c = 'test',
                                                        IAM_Role__c='Guidanz Mobile Immediate Assessment Fleet',
                                                        IAM_Source__c = 'Marketplace',
                                                        IAM_Subscription_Count__c= 10,
                                                        IAM_Free_Subscription__c= False,
                                                        IAM_Provisioned_User_Count__c=1,
                                                        IAM_Account_Name__c = acc2.ID,
                                                        IAM_Application_Name__c = 'Guidanz Mobile',
                                                        IAM_Subscription_Name__c='TestSubscription1',
                                                        IAM_Subscription_Start_Date__c=System.today(),
                                                        IAM_Reject_Reason__c = 'Cancellation Comments',
                                                        IAM_Subscription_End_Date__c= System.today() + 5);
        
        insert app1;
        
        
        Test.startTest();
        
       // OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(subscriptionIDList);
        OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(subscriptionIDList, true, false);
        //OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(subscriptionIDList, false, true);
        
        OSM_Subscription_Account_Provision__c objSAP = new OSM_Subscription_Account_Provision__c(Subscription_Status__c = 'Inactive',
                                                                                                 Account_Features_Access__c = app1.Id,
                                                                                                 CC_Subscription__c = subscription2.Id);
        insert objSAP;
        
        OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(subscriptionIDList, true, false);
        
        Test.stopTest();
        
       /* Account acc = setUpAccount();
        insert acc;
        
        // create a QSOL EBU Product
        ccrz__E_Product__c qsol_product = setUpProduct('QuickServe® Online Kit (QSOL, EDS, CVCOL )', 'QSOL-EBU-1234', 'Product', 'EBU');
        insert qsol_product;
        
        ccrz__E_Subscription__c subscription = setUpSubscription(acc.ID, qsol_product.ID);
        insert subscription;
        list<String> listString = new List<String>();
        listString.add('Fleet');
        OSM_SW_SubscriptionAction.OSM_IAMProvisioningDetails osmIAMProDeta = new OSM_SW_SubscriptionAction.OSM_IAMProvisioningDetails();
        osmIAMProDeta.accountID =acc.id;
        osmIAMProDeta.subscriptionID=subscription.id;
        osmIAMProDeta.productName ='QuickServe® Online Kit (QSOL, EDS, CVCOL )';
        osmIAMProDeta.startDate = System.Today()-2;
        osmIAMProDeta.endDate = System.Today()+30;
        osmIAMProDeta.status = 'Active';
        osmIAMProDeta.userCount = 2;
        osmIAMProDeta.accountGroupName ='Test';
        osmIAMProDeta.accountType ='Fleet';
        osmIAMProDeta.roleFeature = 'QSOL Fleet';
        osmIAMProDeta.applicationName = 'QSOL';
        osmIAMProDeta.subscriptionName ='Test';
        osmIAMProDeta.qsolType = 'Fleet';
        osmIAMProDeta.roleFeatureList = listString;
        Map<String, ID> recordTypeMap = new Map<String, ID>();
        Test.startTest();
        OSM_SW_SubscriptionAction.createIAMRecord(osmIAMProDeta,'QSOL Fleet',recordTypeMap);
        Test.stopTest();*/
    }
}