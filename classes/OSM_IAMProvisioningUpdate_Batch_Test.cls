@isTest
public class OSM_IAMProvisioningUpdate_Batch_Test {
    
    static testMethod void testfetchQuoteListItems(){
        //OSM_Subscription_Account_Provision__c pro = new OSM_Subscription_Account_Provision__c();
       // pro.Subscription_Status__c =  'Active';
     //   pro.sub
         //pro.Subscription_Start_Date__c =  date.today()-3;
       // pro.isSubscriptionStarted__c = false;
       // insert pro;
        OSM_IAMProvisioningUpdate_Batch obj = new OSM_IAMProvisioningUpdate_Batch();
        DataBase.executeBatch(obj);

    }

}