@isTest
public class IAM_TrackUser_Reclaim_Test {
 
    static testMethod void validateReclaimTest() {
        IAM_Reclaim_Tracker__c trackUser = new IAM_Reclaim_Tracker__c();
        trackUser.Name = 'testreclaimuser';
        test.startTest();
        insert trackUser; 
        test.stopTest();
        IAM_TrackUser_Reclaim.updateReclaimTrackerUser('testreclaimuser','testreclaimuser@cmiuser.com','Promotion_Code__c',true);
        IAM_TrackUser_Reclaim.updateReclaimTrackerUser('testreclaimuser','testreclaimuser@cmiuser.com','Create_User__c',true);
        IAM_TrackUser_Reclaim.updateReclaimTrackerUser('testreclaimuser','testreclaimuser@cmiuser.com','Assign_Permission_set__c',true);
        
        IAM_TrackUser_Reclaim.updateReclaimTrackerUser('testreclaimuser1','testreclaimuser1@cmiuser.com','Create_User__c',true);
    }
    
    
     static testMethod void validateReclaimTest1() {
        IAM_Reclaim_Tracker__c trackUser = new IAM_Reclaim_Tracker__c();
        trackUser.Name = 'testreclaimuser';
        
         Account a = new Account();
        a.Name='Test User';
        a.IAM_Service_Provider_code__c='123421';
        a.Recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        a.Type='Fleet';
        insert a;
         
        Contact c= new contact();
        c.Accountid=a.id;
        c.FirstName='Fname';
        c.LastName='Lname';
        c.Email='oh611@cummins.com';
        c.Username__c='testusertriggerhelperreclaim@cmiuser.com';
        c.IAM_Ext_Legacy_Uid__c='reclaimUser';
        c.Recordtypeid= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        c.IAM_Contact_Status__c='Active';
        c.CMI_Contact_Type__c='Secondary';
        Insert c; 
        
        test.startTest();
        List<User> us=[SELECT id,FederationIdentifier from User where Contactid=:c.id];
        if(!us.isEmpty()){
            Set<id> uids = new Set<id>();
            uids.add(us[0].id);
            IAM_TrackUser_Reclaim.UpdateReclaimpasswordTimeStamp(uids);
        }
        insert trackUser; 
        test.stopTest();
    }
}