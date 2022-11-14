@isTest
public with sharing class dbu_Integration_EDQ_Test {
    
    @isTest 
    static void testgetAddressVerify(){
        //added for production deploymennt
        String addressLine1 = '400 BROWN ST';
        String addressLine2 = '';
        String cityId = 'SCOTTSDALE';
        String stateID = 'IN';
        String countryId = 'United States';
        String psCode = '47201' ;
        
        CSS_Integration_Details__c accessTokenConDetails = new CSS_Integration_Details__c();
            accessTokenConDetails.End_Point__c =  'https://api-ue-stgnf5-aw-ex.cummins.com:443/api/core-security-api/v1/auth/token';
           	accessTokenConDetails.Key__c = 'b7922fab-cacb-4e10-a9b2-15e1a7ff2641';
            accessTokenConDetails.Passcode__c =  'H4C3Ww1f~uRf5PIv6gi.fCdM4.f8l.u_YV';
            accessTokenConDetails.Method_Type__c = 'POST';
        	accessTokenConDetails.Name = 'dbu_EDQ_AccessToken';
        insert accessTokenConDetails;
        
          CSS_Integration_Details__c edqConDetails = new CSS_Integration_Details__c();
            edqConDetails.End_Point__c =  'https://api-ue-stgnf2-aw-ex.cummins.com:443/cmi/om/v1/address/validation';
            edqConDetails.Method_Type__c = 'POST';
        	edqConDetails.grant_type__c = 'application/json';
        	edqConDetails.Name = 'dbu_EDQ';
        insert edqConDetails;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new dbu_Integration_EDQ_Mock()); 
        dbu_EdqResposeWrapper edqResposeWrapperRes = dbu_Integration_EDQ.getAddressVerify( addressLine1,  addressLine2, cityId,  stateID,  countryId , psCode);
        Test.stopTest();
    }
    
}