/*
Class Name : FSL_TextCommuniationUnsubscribe_Test
Description: Test class for FSL_TextCommuniationUnsubscribe 
Created By : Madhavi P
JIRA Story : CT4-182
19-10-2020 - Madhavi P - Created this test class to cover code coverage for FSL_TextCommuniationUnsubscribe controller
*/
@isTest
public class FSL_TextCommuniationUnsubscribe_Test {
    
    
    
    
    
    // Preparing test data for Workorder creation.
    static testMethod void doPostOperation_Test() {
        
        Id sysAdminProfileid = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        //List<Profile> ps = [select id, name from Profile where name = 'System Administrator'];
        string Test_LastName = 'Test_LastName';
        Integer nameEnd = (Test_LastName.length() < 8) ? Test_LastName.length()-1 : 8;
        
        // Creating Test user record 
        User testUser = new User();
        testUser.FirstName = 'Test_FirstName';
        testUser.LastName = 'Test_LastName';
        testUser.UserName = testUser.FirstName + '@test.com';
        testUser.Email = Test_LastName + '@test.com';
        testUser.Alias = Test_LastName.substring( 0, nameEnd );
        testUser.CommunityNickname = Test_LastName.substring( 0, nameEnd );
        testUser.ProfileId = '00e61000000sNkc';
        testUser.TimeZoneSidKey = 'America/New_York';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        
        insert testUser;
        
        // Creating ccrz__E_AccountGroup__c test record 
        
        ccrz__E_AccountGroup__c testAccGrp = new ccrz__E_AccountGroup__c();
        testAccGrp.Name = 'Test_AccGroupName';
        testAccGrp.ccrz__PriceListSelectionMethod__c = 'Best Price';
        testAccGrp.ccrz__Desc__c = 'test Description';
        insert testAccGrp;
        
        
        // Creating Account test record 
        Account testAccount = new Account();
        testAccount.Name = 'Test_AcountName';
        testAccount.ccrz__E_AccountGroup__c = testAccGrp.Id;
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '390';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
        testAccount.OSM_Preferred_Payment_Method__c = 'po';
        testAccount.OwnerId = userinfo.getuserid();
        testAccount.CMI_Cid__c = '390';
        testAccount.IAM_Primary_Market_Segment__c = 'Bus';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        
        insert testAccount;
        
        list<Contact> list_con = new list<Contact>();
        
        // Creating Contact record.
        Contact testContact = new Contact();
        testContact.FirstName = 'FirstName';
        testContact.LastName = 'LastName';
        testContact.AccountId = testAccount.Id;
        testContact.MobilePhone = '19999999999';
        testContact.Email = 'testEmail@test.com';
        testContact.IAM_Contact_Status__c = 'Active';
        //testContact.smssubscribeFlag = 'N';
        testContact.Username__c='testusernameunique1234321@gmail.com';
        list_con.add(testContact);
        
        insert list_con;
        
        double mileage = 20.0;
        WorkOrder WO = FSL_TestDataUtility.createWorkOrder( mileage, 'MILES');
        
        
        string JSONData =  '{ "MessageIdentifier": "dscvsdvnernv5151vdvd5svd5vdv", "ReturnCode": " UNSUB02", "ReturnCodeDescription": " The contact number 16178286985  is Unsubscribed",   "Status": "SUCCESS",  "MessageType": "S"  },';
        FSL_TextUnsubscribeWrapper.UnsubscribeResponse request1 = new FSL_TextUnsubscribeWrapper.UnsubscribeResponse();
        request1.MessageIdentifier = 'test message';
        request1.ReturnCode = 'test return code';
        request1.ReturnCodeDescription = 'test description';
        request1.Status = 'test status';
        request1.MessageType = 'test type'; 
        String JsonMsg1 = JSON.serialize(JSONData);
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Communications/Text/Unsubscribe/';       
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg1);
        RestContext.request = req;
        RestContext.response= res;
        FSL_TextUnsubscribeWrapper.UnsubscribeResponse request2 = new FSL_TextUnsubscribeWrapper.UnsubscribeResponse();
        FSL_TextCommuniationUnsubscribe.doPostOperation();
        Test.stopTest();
    }
    
    // Preparing test data for Workorder creation.
    static testMethod void doPostOperation_Test2() {
        
        Id sysAdminProfileid = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        
        string Test_LastName = 'Test_LastName';
        Integer nameEnd = (Test_LastName.length() < 8) ? Test_LastName.length()-1 : 8;
        
        // Creating Test user record 
        User testUser = new User();
        testUser.FirstName = 'Test_FirstName';
        testUser.LastName = Test_LastName;
        testUser.UserName = testUser.FirstName + '@test.com';
        testUser.Email = Test_LastName + '@test.com';
        testUser.Alias = Test_LastName.substring( 0, nameEnd );
        testUser.CommunityNickname = Test_LastName.substring( 0, nameEnd );
        testUser.ProfileId = sysAdminProfileid;
        testUser.TimeZoneSidKey = 'America/New_York';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        
        insert testUser;
        
        // Creating ccrz__E_AccountGroup__c test record 
        
        ccrz__E_AccountGroup__c testAccGrp = new ccrz__E_AccountGroup__c();
        testAccGrp.Name = 'Test_AccGroupName';
        testAccGrp.ccrz__PriceListSelectionMethod__c = 'Best Price';
        testAccGrp.ccrz__Desc__c = 'test Description';
        insert testAccGrp;
        
        
        // Creating Account test record 
        Account testAccount = new Account();
        testAccount.Name = 'Test_AcountName';
        testAccount.ccrz__E_AccountGroup__c = testAccGrp.Id;
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '390';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
        testAccount.OSM_Preferred_Payment_Method__c = 'po';
        testAccount.OwnerId = userinfo.getuserid();
        testAccount.CMI_Cid__c = '390';
        testAccount.IAM_Primary_Market_Segment__c = 'Bus';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        
        insert testAccount;
        
        list<Contact> list_con = new list<Contact>();
        
        // Creating Contact record.
        Contact testContact = new Contact();
        testContact.FirstName = 'FirstName';
        testContact.LastName = 'LastName';
        testContact.AccountId = testAccount.Id;
        testContact.MobilePhone = '9999999999';
        testContact.Email = 'testEmail@test.com';
        testContact.IAM_Contact_Status__c = 'Active';
        testContact.Username__c='testusernameunique1234321@gmail.com';
        list_con.add(testContact);
        
        insert list_con;
        
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        serviceterritory st = new serviceterritory();
        st.name='BrisbaneNew';
        st.state='Queensland';
        st.city='Carole Park';
        st.Street='39-53 Ron Boyle Crescent';
        st.country='Australia';
        st.postalcode='4300';
        st.Phone__c ='+61 7 3710 4700'; 
        st.OperatingHoursId = oh.Id;
        st.IsActive = true;
        st.Location_Code__c = '03522-04893';
        st.FSL_Service_Territory_Code__c = '04893';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        Asset ast = new Asset();
        ast.name='79371784';
        ast.Unit_Number__c='595769';
        ast.VIN__c='BJ361430';
        insert ast;
        
        Contact con= new Contact();
        con.FirstName = 'test1';
        con.LastName='test';
        con.AccountId=testAccount.id;
        con.Email = 'test@cummins.com';
        con.Language_Preferences__c = 'French';
        con.MobilePhone ='9999999999';
        con.Email_Notification_Frequency__c='Real-Time';
        con.Text_SMS_Notification_Frequency__c='Real-Time';
        con.IAM_Contact_Status__c = 'Active'; 
        con.Language_Preferences__c = 'English';
        con.CMI_IsActive__c = true;
        insert con;
        system.debug('dcon== '+con);
        double mileage = 120.0;
        test.startTest();
        WorkOrder WO = FSL_TestDataUtility.createWorkOrder( mileage, 'MILES');
        WO.AccountId = testAccount.Id;
        WO.Contact__c = con.Id;
        update WO;
        
        List<ServiceOrderContact__c> socList = new List<ServiceOrderContact__c>();
        ServiceOrderContact__c socData = new ServiceOrderContact__c();
        socData.Payer_Contact_Flag__c = true;
        socData.Payer_Account__c = testContact.AccountId;
        socData.Payer_Contact__c = testContact.Id;
        socData.Service_Order__c = WO.Id;
        socData.Opt_In__c =true;
        socList.add(socData);
        
        insert socList;
        
        system.debug('socList== '+socList);
        system.debug('socList1== '+socList[0].Payer_Contact__r.MobilePhone);
        
        string JSONData =  '{ "MessageIdentifier": "dscvsdvnernv5151vdvd5svd5vdv", "ReturnCode": " UNSUB02", "ReturnCodeDescription": " The contact number 16178286985  is Unsubscribed",   "Status": "SUCCESS",  "MessageType": "S"  },';
        FSL_TextUnsubscribeWrapper.UnsubscribeResponse request1 = new FSL_TextUnsubscribeWrapper.UnsubscribeResponse();
        
        String JsonMsg1 = JSON.serialize(JSONData);
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Communications/Text/Unsubscribe/';       
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg1);
        RestContext.request = req;
        RestContext.response= res;
        
        FSL_TextUnsubscribeWrapper.UnsubscribeResponse request2 = new FSL_TextUnsubscribeWrapper.UnsubscribeResponse();
        FSL_TextCommuniationUnsubscribe.doPostOperation();
        Test.stopTest();
    }
    
    static testMethod void doPostOperation_Test3() {
        
        Id sysAdminProfileid = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        string Test_LastName = 'Test_LastName';
        Integer nameEnd = (Test_LastName.length() < 8) ? Test_LastName.length()-1 : 8;
        
        // Creating Test user record 
        User testUser = new User();
        testUser.FirstName = 'Test_FirstName';
        testUser.LastName = Test_LastName;
        testUser.UserName = testUser.FirstName + '@test.com';
        testUser.Email = Test_LastName + '@test.com';
        testUser.Alias = Test_LastName.substring( 0, nameEnd );
        testUser.CommunityNickname = Test_LastName.substring( 0, nameEnd );
        testUser.ProfileId = sysAdminProfileid;
        testUser.TimeZoneSidKey = 'America/New_York';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        
        insert testUser;
        
        // Creating ccrz__E_AccountGroup__c test record 
        
        ccrz__E_AccountGroup__c testAccGrp = new ccrz__E_AccountGroup__c();
        testAccGrp.Name = 'Test_AccGroupName';
        testAccGrp.ccrz__PriceListSelectionMethod__c = 'Best Price';
        testAccGrp.ccrz__Desc__c = 'test Description';
        insert testAccGrp;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = accRecId;
        insert acc;
        
        list<Contact> list_con = new list<Contact>();
        
        // Creating Contact record.
        Contact testContact = new Contact();
        testContact.FirstName = 'FirstName';
        testContact.LastName = 'LastName';
        testContact.AccountId = acc.Id;
        testContact.MobilePhone = '999999999';
        testContact.Email = 'testEmail@test.com';
        testContact.IAM_Contact_Status__c = 'Active';
        testContact.Username__c='testusernameunique1234321@gmail.com';
        list_con.add(testContact);
        
        insert list_con;
        
        double mileage = 120.0;
        WorkOrder WO = FSL_TestDataUtility.createWorkOrder( mileage, 'MILES');
        WO.AccountId = acc.Id;
        WO.Contact__c = list_con[0].Id;
        update WO;
        
        string JSONData =  '{ "MessageIdentifier": "dscvsdvnernv5151vdvd5svd5vdv", "ReturnCode": " UNSUB02", "ReturnCodeDescription": " The contact number 16178286985  is Unsubscribed",   "Status": "SUCCESS",  "MessageType": "S"  },';
        FSL_TextUnsubscribeWrapper.UnsubscribeResponse request1 = new FSL_TextUnsubscribeWrapper.UnsubscribeResponse();
        
        String JsonMsg1 = JSON.serialize(JSONData);
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Communications/Text/Unsubscribe/';       
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = null;
        RestContext.request = req;
        RestContext.response= res;
        list<FSL_TextUnsubscribeWrapper.UnsubscribeResponse> request2 = new list<FSL_TextUnsubscribeWrapper.UnsubscribeResponse>();
        
        test.startTest();
        request2 = FSL_TextCommuniationUnsubscribe.doPostOperation();
        FSL_TextUnsubscribeWrapper wrapper = new FSL_TextUnsubscribeWrapper();
        wrapper.contact_mobile_phone = '9999999999';
        wrapper.smssubscribeFlag = 'M';
        
        Test.stopTest();
    }
    static testmethod void method4(){
        Test.startTest();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = accRecId;
        insert acc;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        serviceterritory st = new serviceterritory();
        st.name='BrisbaneNew';
        st.state='Queensland';
        st.city='Carole Park';
        st.Street='39-53 Ron Boyle Crescent';
        st.country='Australia';
        st.postalcode='4300';
        st.Phone__c ='+61 7 3710 4700'; 
        st.OperatingHoursId = oh.Id;
        st.IsActive = true;
        st.Location_Code__c = '03522-04893';
        st.FSL_Service_Territory_Code__c = '04893';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        Asset ast = new Asset();
        ast.name='79371784';
        ast.Unit_Number__c='595769';
        ast.VIN__c='BJ361430';
        insert ast;
        
        Contact con= new Contact();
        con.FirstName = 'test1';
        con.LastName='test';
        con.AccountId=acc.id;
        con.Email = 'test@cummins.com';
        con.Language_Preferences__c = 'French';
        con.MobilePhone ='9999999999';
        con.Email_Notification_Frequency__c='Real-Time';
        con.Text_SMS_Notification_Frequency__c='Real-Time';
        con.IAM_Contact_Status__c = 'Active'; 
        con.Language_Preferences__c = 'English';
        con.CMI_IsActive__c = true;
        insert con;
        
        WorkOrder wo = new WorkOrder();
        wo.Payer__c = acc.id;
        wo.AccountId = acc.id;
        wo.ESN__c='79371784';
        wo.Unit_Type__c='595769';
        wo.Make__c='INTERNATIONAL';
        wo.Model__c='PROSTAR';
        wo.AssetId=ast.Id;
        wo.ServiceTerritoryId=st.Id;
        wo.FSL_Additional_Email_Notifications__c='test@cummins.com';
        wo.Payer_ContactID__c=con.Id;
        wo.contactId = con.Id;
        insert wo;
        
        List<ServiceOrderContact__c> socList = new List<ServiceOrderContact__c>();
        ServiceOrderContact__c socData = new ServiceOrderContact__c();
        socData.Payer_Contact_Flag__c = true;
        socData.Payer_Account__c = wo.Payer__c;
        socData.Payer_Contact__c = wo.Payer_ContactID__c;
        socData.Service_Order__c = wo.Id;
        socData.Opt_In__c =true;
        socList.add(socData);
        
        insert socList;
        
        List<Id> woIds= new List<Id>();
        woIds.add(wo.Id);
        List<String> woIdCommName = new List<String>();
        woIdCommName.add(wo.Id+';'+'Authorized_Work_Started');
        list<FSL_TextUnsubscribeWrapper.UnsubscribeResponse> request2 = new list<FSL_TextUnsubscribeWrapper.UnsubscribeResponse>();
        request2 =  FSL_TextCommuniationUnsubscribe.doPostOperation();
        Test.stopTest();
    }
    
}