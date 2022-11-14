@isTest 
public class OSM_SW_SubscriptionExperssionBatch_Test 
{
    static testMethod void OSM_SW_SubscriptionExperssion() 
    {
        List<ccrz__E_Subscription__c > lstSub= new List<ccrz__E_Subscription__c >();
        for (Integer i=0;i<200;i++) {
         ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
      //  sub.OSM_Display_Product__c = prod.id;
        sub.ccrz__Quantity__c = 10;
        sub.ccrz__Sequence__c = 2;
        sub.ccrz__SubscriptionStatus__c = 'Requested';
        sub.ccrz__Storefront__c = 'SoftwareStore';
        sub.ccrz__SubscriptionStartDate__c  = system.today();
        sub.OSM_Subscription_End_Date__c=Date.newInstance(2020,03,6);
        sub.ccrz__SubscriptionStatus__c = 'Active';
        //sub.OSM_Display_Product__r.ccrz__ShortDesc__c = 'test description';
        lstSub.add(sub);
        }
        insert lstSub;
        //lstSub.ccrz__SubscriptionStatus__c = 'Expired';
        
        update lstSub;
        
        Test.startTest();

            OSM_SW_SubscriptionExperssionBatch obj = new OSM_SW_SubscriptionExperssionBatch();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
        
        ccrz__E_Subscription__c [] accUpdatedList = [SELECT Id,ccrz__SubscriptionStatus__c,Name FROM ccrz__E_Subscription__c];
        //System.assert(accUpdatedList[0].ccrz__SubscriptionStatus__c .Contains('Expired'));
    }
}