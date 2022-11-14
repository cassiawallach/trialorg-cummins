@isTest
public class IAM_userregpageTest {
	
    /* Send() method test  */
    static testmethod void sendTest() {
        PageReference pg = Page.IAM_userreg;        
		Test.setCurrentPage(pg);
        Account acc = IAM_TestData.createAccount();
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Connected Solutions', 'Operator');        
        Test.startTest();
       	ApexPages.currentPage().getParameters().put('aid',acc.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Contact());
        IAM_userregpage obj = new IAM_userregpage(sc);
        obj.contact = getContact();
        obj.conprov.IAM_DA_Calibaration_Role__c = 'Operator';
        PageReference pgRef = obj.send();
        //System.assertEquals(true, pgRef != null);
        Test.stopTest();
    }
    
    /* Invalid Data Test 1  */
    static testmethod void invalidDataTest1() {
        PageReference pg = Page.IAM_userreg;        
		Test.setCurrentPage(pg);
        Account acc = IAM_TestData.createAccount();
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Connected Solutions', 'Operator');        
        Test.startTest();
       	ApexPages.currentPage().getParameters().put('aid',acc.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Contact());
        IAM_userregpage obj = new IAM_userregpage(sc);
        obj.conprov.IAM_DA_Calibaration_Role__c = '';
        PageReference pgRef = obj.send();
        //System.assertEquals(true, pgRef != null);
        Test.stopTest();
    }
    
    /* Invalid Data Test 2  */
    static testmethod void invalidDataTest2() {
        PageReference pg = Page.IAM_userreg;        
		Test.setCurrentPage(pg);
        Account acc = IAM_TestData.createAccount();
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Connected Solutions', 'Operator');        
        Test.startTest();
       	ApexPages.currentPage().getParameters().put('aid',acc.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Contact());
        IAM_userregpage obj = new IAM_userregpage(sc);
        obj.contact.Email = 'abctest';
        obj.conprov.IAM_DA_Calibaration_Role__c = '';
        PageReference pgRef = obj.send();
        PageReference pgRef1 = obj.reset();
        System.assertEquals(true, pgRef1 != null);
        Test.stopTest();
    }
    
    /* Return test contact data */
    private static Contact getContact() {
        Contact con = new contact();
        //con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.IAM_Cummins_login_ID__c = 'fnamelname@test.com';
        con.phone = '1112223335';
        return con;
    } 
}