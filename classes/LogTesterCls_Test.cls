@isTest
public class LogTesterCls_Test {
	@testSetup
    public static void createTestData(){
    	//create Account
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account';
        acc.phone = '6884382997';   
        acc.BillingStreet = 'Test Street';
        acc.BillingCountry = 'United States';
        acc.BillingCity = 'NewYork';
        acc.BillingState = 'Florida';
        acc.BillingPostalCode = '99999';
        insert acc;
         
        // create contact
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact contact = new Contact(FirstName = 'testFirst',
                                      LastName = 'testLast',
                                      Username__c = 'testUser@testEmail.com',
                                      Email = 'testUser@testEmail.com',
                                      AccountId = acc.Id,
                                      RecordTypeId = conRecId,
                                      //Mobile_Phone__c = '1212333300', // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
                                      MobilePhone = '1212333300');
        insert contact;   
    }
    
    @isTest
    public static void testLog_test(){
    	LogTesterCls.testLog();
    }
    
    @isTest
    public static void testPlafFormEventLog_test(){
    	LogTesterCls.testPlafFormEventLog();
    }
}