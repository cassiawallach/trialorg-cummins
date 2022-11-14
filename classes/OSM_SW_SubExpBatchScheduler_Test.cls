@IsTest
public class OSM_SW_SubExpBatchScheduler_Test 
{
    static testMethod void testSubscriptionExpJob()
    {    
        Account acc = new Account();
        
        acc.Name = 'Test Account';
        acc.CMI_Account_Status__c = 'Active';
        acc.CMI_CDA_Status__c = 'New Customer Request';
        acc.CMI_Region__c = 'South Pacific';
        acc.CSS_Language__c = 'English';
        
        insert acc;
     
        ccrz__E_Subscription__c subsc = new ccrz__E_Subscription__c();
        subsc.ccrz__Quantity__c = 10;
        subsc.ccrz__Account__c = acc.ID;
        subsc.ccrz__SubscriptionStatus__c = 'Active';
        subsc.OSM_Subscription_End_Date__c = System.today()- Integer.valueof('4');
        subsc.ccrz__Sequence__c = 500;
        subsc.ccrz__Storefront__c = 'SoftwareStore';
        subsc.ccrz__SubscriptionStartDate__c = System.today()- Integer.valueof('10');
        
        insert subsc;
        
        Test.StartTest();
        String jobId = System.schedule('ScheduledApexTest', '0 0 * * * ?', new OSM_SW_SubExpBatchScheduler());  
        Test.StopTest();
    }
    
}