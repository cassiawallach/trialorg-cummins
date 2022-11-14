//This is the test class for the class OSM_BMS_SW_BusinessLayerHandler
/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          05/04/2021      Test Class Fixes
 */
@isTest
private class OSM_BMS_WS_CustomerLookupOutbound_Test {

    @testSetup
    static void setup(){
        CSS_Integration_Details__c conDetails4 = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails4.name = 'BMS_CustomerAuth';
        conDetails4.End_Point__c = 'http://example.com/example/test3';
        conDetails4.Resource__c = 'http://example.com/example/test2';
        conDetails4.Username__c= 'appSubscription-api-key';
        conDetails4.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails4;
        
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'BMS_CustomerGetAPI';
        conDetails.End_Point__c = 'http://example.com/example/test';
        conDetails.Resource__c = 'http://example.com/example/test2';
        conDetails.Username__c= 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        conDetails.AuthEnv__c = 'BMS_CustomerAuth';
        conDetails.Method_Type__c = 'GET';
        insert conDetails;
        
		Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';         
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.BMS_Customer_ID__c  = '12345';
        testAccount.CSS_DistributorCode__c  = '12345';
        testAccount.BMS_Customer_ID_Junction__c = '12345';
        insert testAccount;
        
		Account testaccount22 = new Account();
        testaccount22.Name = 'testacc22';
        testaccount22.BillingStreet = 'Street';
        testaccount22.BillingCity = 'City';
        testaccount22.BillingState = '';
        testaccount22.BOLT_Account_Number__c = '999';
        testaccount22.BillingPostalCode = '11000';
        testaccount22.BillingCountry = 'United States';
        testaccount22.CMI_Region__c = 'India';
        testaccount22.CSS_Locale__c = 'English(India)';         
        testaccount22.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testaccount22.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testaccount22.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testaccount22.BMS_Customer_ID__c  = '12345';
        testaccount22.CSS_DistributorCode__c  = '12345';
        testaccount22.BMS_Customer_ID_Junction__c = '12345';
        insert testaccount22;
		
        OSM_BMS_WS_GeneralizedInputWrapper objWrap = new OSM_BMS_WS_GeneralizedInputWrapper();
        
        OSM_BMS_WS_GeneralizedInputWrapper.DataArea objDA = new OSM_BMS_WS_GeneralizedInputWrapper.DataArea();
        objDA.CustomerName = 'Test';
        objDA.CustomerCode = '12345';
        objDA.DealerCode = '12345';
        
        OSM_BMS_WS_GeneralizedInputWrapper.Location objLocation = new OSM_BMS_WS_GeneralizedInputWrapper.Location();
        objLocation.LocationID = '12345';
        
        OSM_BMS_WS_GeneralizedInputWrapper.Sender objSender = new OSM_BMS_WS_GeneralizedInputWrapper.Sender();
        objSender.ServiceName = 'getVertexQuoteTax';
        objSender.SenderID = '12345';
        
        OSM_BMS_WS_GeneralizedInputWrapper.Target objTarget = new OSM_BMS_WS_GeneralizedInputWrapper.Target();
        objTarget.TargetID = '12345';
        
        OSM_BMS_WS_GeneralizedInputWrapper.Header objHeader = new OSM_BMS_WS_GeneralizedInputWrapper.Header();
        objHeader.Sender = objSender;
        objHeader.Target = objTarget;
        objHeader.Location = objLocation;
        
        objWrap.Header = objHeader;
        objWrap.DataArea = objDA;
        
        OSM_WS_IP_CSWrapper objCSWrap = new OSM_WS_IP_CSWrapper();
        objCSWrap.serviceName = 'BMSCustomerLookupService';
        
        
		
        //OSM_BMS_WS_CustomerLookupOutbound.callBMSService(new OSM_BMS_WS_GeneralizedInputWrapper());
        OSM_BMS_WS_CustomerLookupOutbound.callBMSService(objWrap);
        OSM_BMS_WS_CustomerLookupOutbound.retryCallOutService(objCSWrap);
        
        OSM_BMS_SW_BusinessLayerHandler.getBMSAvailableCredit(testaccount.id,false,null,null);
        
        ccrz__E_ContactAddr__c objContAdd = new ccrz__E_ContactAddr__c(Account__c = testAccount.Id, BMS_Site__c = true);
        insert objContAdd;
        
        ccrz__E_AccountAddressBook__c objAAB = new ccrz__E_AccountAddressBook__c(ccrz__Account__c = testAccount.Id,
                                                                                 ccrz__E_ContactAddress__c = objContAdd.Id);
        insert objAAB;
    }
    
    
    private static testMethod void test() {
        Test.startTest();
        Account testaccount = [SELECT Id FROM Account where name='testacc' LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new Mock_OSM_MuleSoft_MW_Services(Label.BMS_CustomerGetAPI));
        OSM_BMS_SW_BusinessLayerHandler.getBMSAvailableCredit(testaccount.id,false,null,null);        
        Test.stopTest();
    }
    
	private static testMethod void test1() {
        Test.startTest();
        Account testaccount = [SELECT Id FROM Account where name='testacc22' LIMIT 1];
        
        system.debug('AFTER DEleTE+==+==');
        Test.setMock(HttpCalloutMock.class, new Mock_OSM_MuleSoft_MW_Services(Label.BMS_CustomerGetAPI));
        OSM_BMS_SW_BusinessLayerHandler.getBMSAvailableCredit(testaccount.id,false,null,null); 
       
        Test.stopTest();
    }
	
    private static testMethod void test2() {
        Test.startTest();
        Account testaccount = [SELECT Id FROM Account LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new Mock_OSM_MuleSoft_MW_Services_Failure());
        OSM_BMS_SW_BusinessLayerHandler.getBMSAvailableCredit(testaccount.id,false,null,null);        
        Test.stopTest();
    }
}