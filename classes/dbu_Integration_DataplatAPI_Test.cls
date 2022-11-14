@isTest
public class dbu_Integration_DataplatAPI_Test {

static testmethod void method1(){
	  
	CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
	conDetails.Name='dbu_Dataplate_AccessToken';
	conDetails.End_Point__c= 'https://api-ue-stgnf4-aw-ex.cummins.com/pcc/v1/catalogs/partlists?esn=';
	conDetails.Method_Type__c= 'GET';
	conDetails.grant_type__c= 'application/json';
	insert conDetails;
	
	CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
	conDetails1.Name='dbu_DataplateCallout';
	conDetails1.End_Point__c= 'https://api-ue-stgnf4-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
	conDetails1.Method_Type__c= 'POST';
	conDetails1.grant_type__c= 'application/json';
	conDetails1.Key__c ='122c334d-a6a9-4d7f-bfae-78b78902b04d';
	conDetails1.Passcode__c='69veMf-iaMv-CiDIpkM-X_9-84te5X.-l_';
	insert conDetails1;
	
	test.starttest();
	Test.setMock(HttpCalloutMock.class, new dbu_Integration_DataplatAPI_Mock()); 
	dbu_Integration_DataplatAPI.getProductInfo('79464646');
	test.stopTest();
}
}