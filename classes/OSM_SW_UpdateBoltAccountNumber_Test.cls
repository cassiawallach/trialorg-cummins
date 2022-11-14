@istest
public class OSM_SW_UpdateBoltAccountNumber_Test {
    static testMethod void testmethod1(){
        list<account> acccounts = new list<account>();
        Account portalAccount = new Account();
        portalAccount.Name = 'Gulf Special Account';
        portalAccount.OwnerId = UserInfo.getUserId();
        portalAccount.OSM_Preferred_Billing_Frequency_Lock__c=false;
        portalAccount.OSM_Preferred_Payment_Method__c='cc';
        portalAccount.IAM_Movex_Customer_Code__c='12345';
        portalAccount.Type='SPECIAL ACCOUNT-HQ';
        portalAccount.BOLT_Account_Number__c='123456';
        portalAccount.Bolt_BC_Code__c='234';
        portalAccount.Bolt_Credit_Hold__c=true;
        portalAccount.Bolt_Party_Name__c='test';
        portalAccount.Bolt_Party_Number__c='test number';
        
        insert portalAccount;
        for(integer i=0;i<200;i++){
            Account portalAccount1 = new Account();
            portalAccount1.Name = 'TestAccount'+i;
            portalAccount1.ParentId=portalAccount.id;
            portalAccount1.OwnerId = UserInfo.getUserId();
            portalAccount1.Type='Distributor Branch';
            //portalAccount1.EBU_Channel_of_Distribution__c='Distributor Branch';
            portalAccount1.OSM_Preferred_Billing_Frequency_Lock__c=false;
            portalAccount1.OSM_Preferred_Payment_Method__c='cc';
            portalAccount1.IAM_Movex_Customer_Code__c='12345';
            acccounts.add(portalAccount1);
        }
        insert acccounts;
        test.startTest();
        Database.executeBatch(new OSM_SW_UpdateBoltAccountNumber(),2000);
        test.stopTest();
        string cron = '0 0 ' + string.valueof(2) + ' * * ?';
        system.schedule('Testjob', cron, new OSM_SW_UpdateBoltAccountNumber());
        
        
    }
    
}