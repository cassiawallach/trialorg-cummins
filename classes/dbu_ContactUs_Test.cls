@isTest
public class dbu_ContactUs_Test {
    static testMethod void testinsertCon() { 
        //Get Record Type Id
        String contactUsRecordId = Schema.SObjectType.dbu_ContactUs__c.getRecordTypeInfosByDeveloperName().get('dbu_ContactusRT').getRecordTypeId();
		String suscribeRecordId = Schema.SObjectType.dbu_ContactUs__c.getRecordTypeInfosByDeveloperName().get('dbu_SuscribeRT').getRecordTypeId();
        
        
        List<dbu_ContactUs__c> lstContactUs = new List<dbu_ContactUs__c>();
        dbu_ContactUs__c objContactUs = new dbu_ContactUs__c();
        objContactUs.RecordTypeId = contactUsRecordId;
        objContactUs.dbu_First_Name__c =  'testfirstname';
        objContactUs.dbu_Last_Name__c =  'testlastname';
        objContactUs.dbu_Phone__c =  '1234567890';
        objContactUs.dbu_Email__c =  'test@test.com';
        objContactUs.dbu_State__c =  'teststate';
        objContactUs.dbu_Zipcode__c =  '123456';
        objContactUs.dbu_Address__c =  'pune';
        objContactUs.dbu_Message__c =  'testmessage';
        objContactUs.dbu_Product_Support__c =  'testproductsupport';
        objContactUs.dbu_ESN__c =  '12345';
        objContactUs.dbu_Order_Confirmation_Number__c = '1234567';
        objContactUs.dbu_Tell_Us__c =  'testtellus';
        objContactUs.dbu_What_Can_we_help_with_us__c = 'testhelp';
        objContactUs.dbu_Cummins_Product_Support__c =  'testcsupport';
        objContactUs.dbu_Subscribe__c = false;
        objContactUs.dbu_isContected__c = 'true';
        
       	dbu_ContactUs__c objContactUs1 = new dbu_ContactUs__c();
        objContactUs.RecordTypeId = suscribeRecordId;
        objContactUs1.dbu_First_Name__c =  null;
        objContactUs1.dbu_Last_Name__c =  'testlastname';
        objContactUs1.dbu_Phone__c =  '1234567890';
        objContactUs1.dbu_Email__c =  'test@test.com';
        objContactUs1.dbu_State__c =  'teststate';
        objContactUs1.dbu_Zipcode__c =  '123456';
        objContactUs1.dbu_Address__c =  'pune';
        objContactUs1.dbu_Message__c =  'testmessage';
        objContactUs1.dbu_Product_Support__c =  'testproductsupport';
        objContactUs1.dbu_ESN__c =  '12345';
        objContactUs1.dbu_Order_Confirmation_Number__c = '1234567';
        objContactUs1.dbu_Tell_Us__c =  'testtellus';
        objContactUs1.dbu_What_Can_we_help_with_us__c = 'testhelp';
        objContactUs1.dbu_Cummins_Product_Support__c =  'testcsupport';
        objContactUs1.dbu_Subscribe__c = false;
        objContactUs1.dbu_isContected__c = 'true';
        objContactUs1.dbu_subscribeEmailId__c ='testsub@test.com'; 
        
        Test.startTest();
        dbu_ContactUs.insertCon(objContactUs);
        dbu_ContactUs.insertCon(objContactUs1);
        /*
        if(objContactUs1.dbu_First_Name__c!= null){
            dbu_ContactUs.insertCon(objContactUs);
        }
        else{
            dbu_ContactUs.insertCon(objContactUs1);
        }*/
        Test.stopTest(); 
    }
}