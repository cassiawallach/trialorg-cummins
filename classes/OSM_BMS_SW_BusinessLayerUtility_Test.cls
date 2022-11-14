// Update Sharad 9 April 2021
// Update Sharad 14 April 2021
// Update Sharad 14 April 2021
//Update Sangeeta 10 May 2021
@isTest
public class OSM_BMS_SW_BusinessLayerUtility_Test {
    static testMethod void tetsMethod1() {
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
        testAccount.CSS_DistributorCode__c = '02680';
        testAccount.CSS_DBCode__c = '020400';
        testAccount.BMS_Customer_ID__c = '12345';
        testAccount.Customer_Location_Code__c = '123';
        testAccount.IAM_Service_Provider_Code__c = '123456';

        insert testAccount;
        
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
        
        Test.StartTest();
        
        Test.setMock(HttpCalloutMock.class, new Mock_OSM_MuleSoft_MW_Services('BMS_CustomerGetAPI'));
        OSM_BMS_SW_BusinessLayerUtility.calculateBMSAvailableCredit(testAccount.id,true,'12345',testAccount.Id);
        Test.stopTest();
    }

}