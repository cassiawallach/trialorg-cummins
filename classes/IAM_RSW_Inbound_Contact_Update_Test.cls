/*********************************************************************************
Author       :   Chetan Gaikwad

Created Date :   4th September,2019

Description  :   Unit test class for  IAM_RSW_Inbound_Contact_Update.
*********************************************************************************/
@isTest
public class IAM_RSW_Inbound_Contact_Update_Test{
    
    @isTest
    public static void createTestData(){
        
        Account accRecord = new Account();
        accRecord.Name = 'Test Company';
        accRecord.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        accRecord.phone = '6884382997';
        accRecord.Type = 'Special Account';
        accRecord.IAM_Service_Provider_Code__c = '54699';
        accRecord.CSS_DBCode__c = 'tesC';
        accRecord.CSS_DistributorCode__c = 'tesD';
        //accRecord.Location__c = 'testLoca';
        accRecord.CSS_DealerCode__c = 'testDea';
        accRecord.BillingStreet = 'street';
        accRecord.BillingCity = 'Telangana';
        accRecord.BillingCountry = 'India';
        accRecord.BillingPostalCode = '234567';
        accRecord.IAM_Movex_Customer_Code__c = 'testMov';
        accRecord.IAM_WWSPS_Regions__c = 'US and Canada';
        insert accRecord ;
        
        
        List<Contact> conlst=new List<Contact>();    
        
        Contact conNew = new Contact();
        conNew.accountID = accRecord.id;  
        conNew.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();       
        conNew.Email= 'testReclaim@mail.com'; 
        conNew.FirstName = 'Send';
        conNew.LastName = 'Send LDAP'; 
        conNew.IAM_Contact_Status__c = 'Pending';        
        conNew.Username__c =  'testReclaim@mail.com';        
        conNew.phone = '8989898989';  
        conNew.IAM_Final_Approver__c = 'N';
        conNew.IAM_Qsolexpiration__c = 'testABC';
        conNew.IAM_swregexpire__c ='testCon';
        conNew.IAM_Internal__c = true;
        conNew.IAM_Applications__c = 'CSS_DN_Advanced';
        conNew.CMI_Contact_Type__c = 'Primary';
        conNew.IAM_is_Member_of__c = 'testMemeber';
        conlst.add(conNew);  
        insert conlst;

        
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Rapid Serve Web';
        app.IAM_Role__c = 'Basic';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = accRecord.id;
        app.IAM_Subscription_Name__c = 'test';
        //App.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Rapid Serve Web').getRecordTypeId();
        insert app;
        
        //IAM Contact Provisioning
        List<IAM_Contact_Provisioning__c> lstconApp = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Rapid Serve Web').getRecordTypeId();
        conApp.IAM_Role__c = 'Basic';
        
        conApp.IAM_Status__c = 'Pending';
        conApp.IAM_Contact__c = conNew.id; 
        conApp.IAM_Account_Application__c = app.id;    
        insert conApp;
    }
    static testMethod void test1() {
        createTestData();
        List<Contact> con = [SELECT Id,Username__c,Phone,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email,FirstName,LastName,IAM_Contact_Status__c,CMI_Contact_Type__c,IAM_Applications__c,IAM_is_Member_of__c,IAM_Product_Group_Access__c,IAM_Qsolexpiration__c,IAM_Qsolview__c,IAM_swregexpire__c,IAM_Work_Group_Id__c,AccountId,Account.Name,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.Type,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Internal__c,Account.IAM_Service_Provider_Code__c,Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.CMI_Account_Num__c,Account.Location__c,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,Account.IAM_Movex_Customer_Code__c,Account.BillingStreet,Account.OwnerId,Account.IAM_WWSPS_Regions__c  FROM Contact WHERE Username__c = 'testReclaim@mail.com' LIMIT 1];
        
        
        List<IAM_Contact_Provisioning__c> contactProv = [select id,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c,IAM_Contact__c,IAM_Qsolexpiration__c,IAM_swregExpire__c FROM IAM_Contact_Provisioning__c WHERE IAM_Contact__c=: con[0].Id and IAM_Status__c='Pending'];  
        
        test.startTest();
        id JobId=System.enqueueJob(new IAM_RSW_Inbound_Contact_Update('Active',con[0].id,'testReclaim@mail.com',contactProv[0].Id));
        id JobId1=System.enqueueJob(new IAM_RSW_Inbound_Contact_Update('Cancel',con[0].id,'testReclaim@mail.com',contactProv[0].Id));
        
        Test.StopTest();
        
    }
        static testMethod void test2() {
         IAM_RSW_Inbound.rswIAMUserResponseDetails objURD = new IAM_RSW_Inbound.rswIAMUserResponseDetails();
        objURD.userID='test@test.com';
        objURD.roleID='CUMMINS';
        objURD.status='Cancelled';
        objURD.userEmail='test12@test.com';
        String JsonMsg=JSON.serialize(objURD );
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/rswstatus';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_RSW_Inbound.post(objURD);
       
        Test.stopTest();
    }
}