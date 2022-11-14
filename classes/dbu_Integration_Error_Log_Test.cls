@isTest
public class dbu_Integration_Error_Log_Test 
{
    public static testMethod void integrationError(){
        Id iamRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Account createAccount= dbu_TestDataCreationUtility.createAccount(iamRecordTypeId);
        createAccount.BillingCountry = 'Canada';
        insert createAccount;
        Contact createContact= dbu_TestDataCreationUtility.createContact(createAccount, ContactRecordTypeId);
        insert createContact;
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        String orgId = UserInfo.getOrganizationId();  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
         String uniqueName = orgId + dateString + randomInt;  
          Profile prof = [select id from profile where name LIKE '%System Administrator%' limit 1];
                            User user = new User(  FirstName = 'test',  
                            LastName = 'test2376',  
                            email = uniqueName + '@test' + orgId + '.org',  
                            Username = uniqueName + '@test' + orgId + '.org',  
                            EmailEncodingKey = 'ISO-8859-1',  
                            Alias = uniqueName.substring(18, 23),  
                            TimeZoneSidKey = 'America/Los_Angeles',  
                            LocaleSidKey = 'en_US',  
                            LanguageLocaleKey = 'en_US',  
                            ProfileId = prof.Id  
                            );  
                            insert user;
        dbu_IntegrationErrorLog__c errorLog = new dbu_IntegrationErrorLog__c();
        errorLog.Name='ErrorLogEmail';
        errorLog.SetToAddress__c='test2093@cumminstes.com';
        errorLog.TargetObjectId__c=Userinfo.getUserId();
        insert errorLog;
        dbu_Integration_Error_Log.createErrorLog(400,'ErrorDescription','Request','Response','ServiceName','Exception');
    }
}