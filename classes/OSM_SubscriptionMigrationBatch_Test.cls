//updated by Dhiraj
//Updated for Coupon generate batch issue fix - minor_coupon_fixes
@isTest
public class OSM_SubscriptionMigrationBatch_Test {
 Static TestMethod Void SubscriptionMigrationBatchTestMethod(){
 
        //creating test Account for Dealer...
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
        testAccount.type='Dealer';
        insert testAccount;
        
        //creating test Account for Distributor...
        Account testaccount2 = new Account();
        testAccount2.Name = 'testacc';
        testAccount2.BillingStreet = 'Street';
        testAccount2.BillingCity = 'City';
        testAccount2.BillingState = '';
        testAccount2.BOLT_Account_Number__c = '999';
        testAccount2.BillingPostalCode = '11000';
        testAccount2.BillingCountry = 'United States';
        testAccount2.CMI_Region__c = 'India';
        testAccount2.CSS_Locale__c = 'English(India)';         
        testAccount2.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount2.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testAccount2.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount2.type='Distributor Account';
     

        insert testAccount2;
        
        
        
        Test.startTest();
        OSM_SubscriptionMigrationBatch subMigBatch=new OSM_SubscriptionMigrationBatch();
        Database.executeBatch(subMigBatch);
        Test.stopTest();
        
        
        
        
 
 }
 
}