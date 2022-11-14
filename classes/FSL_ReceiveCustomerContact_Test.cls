@isTest
public class FSL_ReceiveCustomerContact_Test {
    @isTest 
    static void testCreateContact1() {
      //String myJSON = '{"Header":{"Status":"","Sender":{"ServiceName":"GetContactInfo","SenderID":"Movex"},"Target":"CSS","Location":""},"DataArea":[{"CustomerNumber":"2110054","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"einvoice@boral.com.au","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"ADD"},{"CustomerNumber":"2110054","FirstName":"TRAVIS G","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"test@test.com","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"UPDATE"},{"CustomerNumber":"2110054","FirstName":"","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"einvoice@boral.com.au","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"ADD"},{"CustomerNumber":"","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"UPDATE"}]}';
        String myJSON = '{"Header":{"Status":"","Sender":{"ServiceName":"GetContactInfo","SenderID":"BMS"},"Target":"CSS","Location":""},"DataArea":[{"CustomerNumber":"2110054","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"einvoice@boral.com.au","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"ADD"},{"CustomerNumber":"2110054","FirstName":"TRAVIS GG","MI":"","LastName":"","Salutation":"","Position":"","EmailNotification":"Y","TextNotification":"Y","LanguagePreference":"EN","NightlyCommunication":"N","MobilePhoneNumber":"7890123458","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"einvoice@boral.com.au","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"UPDATE"},{"CustomerNumber":"2110054","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"ADD"}]}';
        // String myJSON = '{"Header":{"Status":"","Sender":{"ServiceName":"GetContactInfo","SenderID":"BMS"},"Target":"CSS","Location":""},"DataArea":[{"CustomerNumber":"2110054","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"einvoice@boral.com.au","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"ADD","MobilePhoneNumber":"1234567891","EmailNotification":"true/false","TextNotification":"true/false","NightlyCommunication":"true/false","LanguagePreference":"English"},{"CustomerNumber":"2110054","FirstName":"TRAVIS GG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"einvoice@boral.com.au","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"UPDATE","MobilePhoneNumber":"1234567891","EmailNotification":"true/false","TextNotification":"true/false","NightlyCommunication":"true/false","LanguagePreference":"English"},{"CustomerNumber":"2110054","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"ADD","MobilePhoneNumber":"1234567891","EmailNotification":"true/false","TextNotification":"true/false","NightlyCommunication":"true/false","LanguagePreference":"English"}]}';
        Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guidanz').getRecordTypeId();
        //Testing 
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.FSL_ERP_Customer_Code__c = '2110054';
        // acc.ParentId= acc.Id;
        acc.Name = 'Test Acc';
        acc.Cmi_account_status__c = 'Active';
        acc.FSL_Source_ERP__c = 'BMS';
        acc.Type = 'Customer';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Travis';
        con.LastName = 'Grigg';
        con.AccountId = acc.Id;
        con.FSL_Contact_Id__c = '6';
        con.Phone = '(042) 988-3045';
        con.RecordTypeId = recTypeId;
        con.CMI_Contact_Type__c = 'Customer';
        con.Email = 'test@test.com';
        con.IAM_Contact_Status__c = 'Inactive';
        // con.IAM_Contact_source__c = 'BMS';
        //con.Email_Notifications__c = true;
        //con.Text_Notifications__c = true;
        //con.Mobile_Phone__c = '1234577900'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con.MobilePhone = '1234577900';
        //con.Nightly_Communications__c = true;
        con.Language_Preferences__c = 'English';
        insert con;
        acc.FSL_Source_ERP__c = 'BMS';
        update acc;
        Test.startTest();
        // String reqStr = FSL_TestDataUtility.getCustomerContactData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://cs13.salesforce.com/services/apexrest/customercontact/';  //Request URL
        req.httpMethod = 'POST';
        //req.requestBody = Blob.valueof(reqStr);
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        RestContext.response= res;
        
        FSL_ReceiveCustomerContact.doPostOperation();
        FSL_CustomerContactWrapper.DataResponse wrap = new FSL_CustomerContactWrapper.DataResponse();
        //FSL_CustomerContactWrapper wrap = new FSL_CustomerContactWrapper();
        
        System.debug(':::Response ='+res);
        System.debug(':::Response Body='+res.responseBody);
        System.debug(':::Response Status='+res.statusCode);
        
        Test.stopTest();
    }
    @isTest 
    static void testCreateContact() {
        // String myJSON = '{"Header":{"Status":"","Sender":{"ServiceName":"GetContactInfo","SenderID":"Movex"},"Target":"CSS","Location":""},"DataArea":[{"CustomerNumber":"2110054","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"einvoice@boral.com.au","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"ADD"},{"CustomerNumber":"2110054","FirstName":"TRAVIS G","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"test@test.com","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"UPDATE"},{"CustomerNumber":"2110054","FirstName":"","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"einvoice@boral.com.au","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"ADD"},{"CustomerNumber":"","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"UPDATE"}]}';
        String myJSON = '{"Header":{"Status":"","Sender":{"ServiceName":"GetContactInfo","SenderID":"BMS"},"Target":"CSS","Location":""},"DataArea":[{"CustomerNumber":"2110054","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"einvoice@boral.com.au","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"ADD"},{"CustomerNumber":"2110054","FirstName":"TRAVIS GG","MI":"","LastName":"","Salutation":"","Position":"","EmailNotification":"Y","TextNotification":"Y","LanguagePreference":"EN","NightlyCommunication":"N","MobilePhoneNumber":"7890123458","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"einvoice@boral.com.au","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"UPDATE"},{"CustomerNumber":"2110054","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"ADD"}]}';
        Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guidanz').getRecordTypeId();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.FSL_ERP_Customer_Code__c = '2110054';
        // acc.ParentId= acc.Id;
        acc.Name = 'Test Acc';
        acc.Cmi_account_status__c = 'Active';
        acc.FSL_Source_ERP__c = 'BMS';
        acc.Type = 'Customer';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Travis';
        con.LastName = 'Grigg';
        con.AccountId = acc.Id;
        con.FSL_Contact_Id__c = '6';
        con.Phone = '(042) 988-3045';
        //con.Mobile_Phone__c = '1234577900'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con.MobilePhone = '1234577900';
        con.RecordTypeId = recTypeId;
        con.CMI_Contact_Type__c = 'Customer';
        con.Email = 'test@test.com';
        con.IAM_Contact_Status__c = 'Inactive';
        // con.IAM_Contact_source__c = 'BMS';
        insert con;
        Contact con1 = new Contact();
        con1.FirstName = 'Travis';
        con1.LastName = 'Grigg';
        con1.AccountId = acc.Id;
        con1.FSL_Contact_Id__c = '0';
        con1.Phone = '(042) 988-3045';
        //con1.Mobile_Phone__c = '1235779021'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con1.MobilePhone = '1235779021';
        con1.RecordTypeId = recTypeId;
        con1.CMI_Contact_Type__c = 'Customer';
        con1.Email = 'test@test.com';
        con1.IAM_Contact_Status__c = 'Inactive';
        // con1.IAM_Contact_source__c = 'BMS';
        insert con1;
        
        acc.FSL_Source_ERP__c = 'BMS';
        update acc;
        Test.startTest();
        // String reqStr = FSL_TestDataUtility.getCustomerContactData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://cs13.salesforce.com/services/apexrest/customercontact/';  //Request URL
        req.httpMethod = 'POST';
        //req.requestBody = Blob.valueof(reqStr);
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        RestContext.response= res;
        
        FSL_ReceiveCustomerContact.doPostOperation();
        FSL_CustomerContactWrapper.DataResponse wrap = new FSL_CustomerContactWrapper.DataResponse();
        //FSL_CustomerContactWrapper wrap = new FSL_CustomerContactWrapper();
        
        System.debug(':::Response ='+res);
        System.debug(':::Response Body='+res.responseBody);
        System.debug(':::Response Status='+res.statusCode);
        
        Test.stopTest();
    }
    
    @isTest 
    static void testUpdateContact() {
        String myJSON = '{"Header":{"Status":"","Sender":{"ServiceName":"GetContactInfo","SenderID":"Movex"},"Target":"CSS","Location":""},"DataArea":[{"CustomerNumber":"2110054","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"einvoice@boral.com.au","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"DELETE"},{"CustomerNumber":"","FirstName":"TRAVIS GRIGF","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"einvoice@boral.com.au","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"UPDATE"},{"CustomerNumber":"2110054","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"DELETE"},{"CustomerNumber":"2110054","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"0406709876","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"test@test.com","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"UPDATE"}]}';
        // String myJSON = '{"Header":{"Status":"","Sender":{"ServiceName":"GetContactInfo","SenderID":"Movex"},"Target":"CSS","Location":""},"DataArea":[{"CustomerNumber":"2110054","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"(042) 988-3045","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"test@test.com","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"DELETE"},{"CustomerNumber":"","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"(042) 988-3045","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"test@test.com","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"UPDATE"},{"CustomerNumber":"2110054","FirstName":"TRAVIS GRIGG","MI":"","LastName":"","Salutation":"","Position":"","LocationAddressline1":"BORAL SHARED BUSINESS SERVICES","LocationAddressline2":"ACCOUNTS PAYABLE","LocationAddressline3":"LOCKED BAG 5016","City":"","State":"Queensland","PostalCode":"2124","PostalCodeSuffix":"","Country":"Australia","PhoneAreaCode":"","PhoneNumber":"(042) 988-3045","Ext":"","FaxAreaCode":"","FaxNumber":"","Email":"test@test.com","Comments":"","ContactID":"0","LocationAddressline4":"PARRAMATTA   NSW  2124 POBOX","LastUpdatedDate":"2019-06-20T06:52:44","EventFlag":"UPDATE"}]} '; 
        Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guidanz').getRecordTypeId();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.FSL_ERP_Customer_Code__c = '2110054';
        acc.Name = 'Test Acc';
        acc.Cmi_account_status__c = 'Active';
        acc.Type = 'Customer';
        insert acc;
        
        Contact cont = new Contact();
        cont.FirstName='Travis';
        cont.LastName='Grigg';
        //cont.Accountid= acc.id;
        cont.FSL_Contact_Id__c='7';
        cont.RecordTypeId = recTypeId;
        cont.Email = 'test@test.com';
        cont.Phone = '(042) 988-3045';
        //cont.Mobile_Phone__c = '1235669021'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        cont.MobilePhone = '1235669021';
        cont.CMI_Contact_Type__c = 'Customer';
        cont.IAM_Contact_Status__c = 'Inactive';
        insert cont;
        
        Contact con = new Contact();
        con.FirstName = ' ';
        con.LastName = 'Grigg1';
        con.AccountId = acc.id;
        con.FSL_Contact_Id__c = '9';
        con.RecordTypeId = recTypeId;
        con.Phone = '(042) 988-3045';
        //con.Mobile_Phone__c = '1233479021'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con.MobilePhone = '1233479021';
        con.CMI_Contact_Type__c = 'Customer';
        con.Email = 'test@test.com';
        con.IAM_Contact_Status__c = 'Active';
        insert con;
        
        
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'https://cs13.salesforce.com/services/apexrest/customercontact/';  //Request URL
        req.httpMethod = 'POST';
        //req.requestBody = Blob.valueof(reqStr);
        req.requestBody = Blob.valueof(myJSON);
        RestContext.request = req;
        RestContext.response= res;
        
        FSL_ReceiveCustomerContact.doPostOperation();
        FSL_CustomerContactWrapper.DataResponse resObj = new FSL_CustomerContactWrapper.DataResponse();
        
        System.debug(':::Response ='+res);
        System.debug(':::Response Body='+res.responseBody);
        System.debug(':::Response Status='+res.statusCode);
        
        Test.stopTest();
    }
    
}