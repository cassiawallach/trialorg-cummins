@isTest 
public class IAM_LDAP_Util_Callout_Batch_Test 
{
    static testMethod void batchTestMethod() 
    {
        //test account
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        insert acc;
        
        Contact con = new contact();
        con.lastName = 'Test';
        con.AccountId = acc.id;
        con.firstName = 'contact';
        con.Email = 'testContact@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Primary';
        con.phone = '8989898989';
        con.IAM_Application_Roles__c = 'Advanced';
        con.IAM_Promotion__c = '12345';
        con.IAM_Applications__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        con.IAM_is_member_of__c = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        Con.Username__c = 'test_user_helper6@eidm.com';
        Con.recordtypeid=Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        insert con;
        
        Set<Id> setIds = new Set<Id>();    
        setIds.add(con.id);
        
        Test.startTest();
			IAM_LDAP_Util_Subcription_Callout queueable = new IAM_LDAP_Util_Subcription_Callout(setIds, 'Update');
        	system.enqueueJob(queueable);
            IAM_LDAP_Util_Callout_Batch obj = new IAM_LDAP_Util_Callout_Batch(setIds, 'Update');
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}