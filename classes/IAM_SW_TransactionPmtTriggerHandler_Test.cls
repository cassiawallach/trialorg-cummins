@isTest
public class IAM_SW_TransactionPmtTriggerHandler_Test{
    
        public static final Id PROFILEID=TestingUtils.SYS_ADMIN_PROFILE_ID;
        
        static testMethod void OnBeforeInsert_Test(){
        
        Test.startTest();
        Account acc = new Account(name='Test');
        insert acc;
        Contact c= new Contact();
        c.firstname='fname';
        c.lastname='lname';
        c.email='email@cummins.com';
        c.Username__c='emailcummins@cummins.com';
        c.accountid=acc.id;
        insert c;
        Test.stopTest();
    }
    

}