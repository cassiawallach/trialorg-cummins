@istest
public class OSM_SW_PopulateOrderManagementCode_Test {
    static testMethod void testmethod1(){
        list<account> acccounts = new list<account>();
        for(integer i=0;i<200;i++){
            Account portalAccount1 = new Account();
            portalAccount1.Name = 'TestAccount'+i;
            portalAccount1.OwnerId = UserInfo.getUserId();
            portalAccount1.OSM_Preferred_Billing_Frequency_Lock__c=false;
            portalAccount1.OSM_Preferred_Payment_Method__c='cc';
            portalAccount1.IAM_Movex_Customer_Code__c='12345';
            acccounts.add(portalAccount1);
        }
        insert acccounts;
        test.startTest();
        Database.executeBatch(new OSM_SW_PopulateOrderManagementCode(),2000);
        test.stopTest();
        string cron = '0 0 ' + string.valueof(2) + ' * * ?';
        system.schedule('Testjob', cron, new OSM_SW_PopulateOrderManagementCode());
        
        
    }
    
}