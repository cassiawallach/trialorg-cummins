//updated by Sangeeta on 05/05/2021
@isTest
public class OSM_BMS_SW_CustomerOutboundINT_test{

public static testMethod void getBMSAvailableCreditTest(){

  //Account
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
        
        CSS_Integration_Details__c objCID = new CSS_Integration_Details__c(AuthEnv__c = 'BMS',
                                                                         IsActive__c = true,
                                                                         Timeout__c = 120000,
                                                                         Method_Type__c = 'POST',
                                                                         ApplicationName__c = 'BMS',
                                                                         Name = 'BMSCustomerLookupService',
                                                                         End_Point__c = 'https://services-stg.cummins.com/cso/bmscustomer');
      insert objCID;
        
        test.starttest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new OSM_GetCustomerMock());
        
        OSM_BMS_SW_BusinessLayerUtility.calculateBMSAvailableCredit(testAccount.id,true,'12345',testAccount.Id);
        
        ccrz__E_ContactAddr__c objContAdd = new ccrz__E_ContactAddr__c(Account__c = testAccount.Id, BMS_Site__c = true);
        insert objContAdd;
        
        ccrz__E_AccountAddressBook__c objAAB = new ccrz__E_AccountAddressBook__c(ccrz__Account__c = testAccount.Id,
                                                                                 ccrz__E_ContactAddress__c = objContAdd.Id);
        insert objAAB;
        
        OSM_BMS_SW_BusinessLayerUtility.calculateBMSAvailableCredit(testAccount.id,true,'12345',testAccount.Id);
        
        test.stoptest();
      
}
    
}