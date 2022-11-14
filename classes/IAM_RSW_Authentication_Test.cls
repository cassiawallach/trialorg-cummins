/*********************************************************************************
Author       :   Sushma Rajput
Created Date :   4th September,2019
Description  :   Unit test class for  IAM_RSW_Authentication.
*********************************************************************************/
@isTest
public class IAM_RSW_Authentication_Test {
   
   @isTest
    Static void TestDataOne(){
    
     String accessToken = 'test';
     String token_type = 'test';
     String scope = 'test';
     Integer expires_in = 1;
     String refresh_token = 'test';
     String resource = 'test';
     String error = 'test';
     String error_description = 'test';
       
         Test.startTest();        
         Test.setMock(HttpCalloutMock.class, new MockHttpFakeResponse());
         IAM_RSW_Authentication.getBearer();
         Test.stopTest();
    
    }
}