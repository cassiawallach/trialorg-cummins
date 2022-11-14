@istest
public class FSL_ContactUpdateToBMS_Test {
    @isTest static void Coverage_ContactUpdateToBMS()
    {
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account';
        acc.FSL_ERP_Customer_Code__c = '11234';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
        //con.Mobile_Phone__c='1234567890'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con.MobilePhone ='1234567890';
        con.email = 'invalid@cummins.com';
        insert con;
         //Added Changes for Named Credentials
        Contact con1=new Contact();
        con1.RecordTypeId = conRecId;
        con1.FirstName='TEST';
        con1.LastName='Contact';
        con1.Phone='1234567890';
        con1.AccountId=acc.id;
        //con.Mobile_Phone__c='1234567890'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con1.MobilePhone ='1234567890';
        con1.email = '';
        insert con1;
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        
        con.MobilePhone ='0001234567';
        update con;
        
        List<Id> contIds = new List<Id>();
        contIds.add(con.id);
         //Added Changes for Named Credentials
        List<Id> contactIds = new List<Id>();
        contactIds.add(con1.id);
        test.startTest();
        FSL_ContactUpdateToBMS.ContactUpdateBMS(contIds);
         //Added Changes for Named Credentials
        FSL_ContactUpdateToBMS.ContactUpdateBMS(contactIds);
        test.stopTest();
    }
}