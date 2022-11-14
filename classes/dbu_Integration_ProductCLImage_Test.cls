/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-24-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class dbu_Integration_ProductCLImage_Test {
    
    
    @isTest public static void getAccessTokenTest(){
        String imageURL = 'http://test.imageUrl';
        //added fo rprod deployment
        String accessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IjVPZjlQNUY5Z0NDd0NtRjJCT0hIeEREUS1EayIsImtpZCI6IjVPZjlQNUY5Z0NDd0NtRjJCT0hIeEREUS1EayJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1kZXZuZi1hdy1leC5jdW1taW5zLmNvbS9jbWkvdjEvY29udGVudG1hbmFnZW1lbnQiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9iMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QvIiwiaWF0IjoxNjA4MTkxMDgzLCJuYmYiOjE2MDgxOTEwODMsImV4cCI6MTYwODE5NDk4MywiYWlvIjoiRTJKZ1lEaS85TnZYRlk0dWR5cjVYL3htOXAvc0JRQT0iLCJhcHBpZCI6ImI3OTIyZmFiLWNhY2ItNGUxMC1hOWIyLTE1ZTFhN2ZmMjY0MSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2IzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZC8iLCJvaWQiOiJmZGY5NTM3YS1hMzdjLTRhMDUtYjUyNC04YjZjNDEwNDViMGQiLCJyaCI6IjAuQUFBQWhsMGFzOXB0VjBTRjVjVmJ2QWVTUGFzdmtyZkx5aEJPcWJJVjRhZl9Ka0VPQUFBLiIsInN1YiI6ImZkZjk1MzdhLWEzN2MtNGEwNS1iNTI0LThiNmM0MTA0NWIwZCIsInRpZCI6ImIzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZCIsInV0aSI6IjdORzB3aVdMYmtHYXc1M3kwWDBUQUEiLCJ2ZXIiOiIxLjAifQ.qir6Cp4ns2_jAwhoNH1K4f31xWmTXIJubYuxizJAr3nNPkgIc77W_uAt-G9ag9fZZ49AXNhih5AzUSArZo6UE6w_Lnmncau12BrHgkYtzAKRYuNhDUiZDMVx-imEFlKH4qPOfd8gSCvQA0ceGOq6OW0QH9UJvspRBPpE9PQ3SLEUVG8stGGt80sFZ6FMqqmQOK-B_ij1pOEdeHm_rZL_fsHe3ZUJ-zt7lAFZ_TB_jnRSEwBNaYYpkcuyPGs07HKStAYd4by6CfD5NPZFXpaNOFUpVyIzXEVQxNGzA_M-O4_-5DDG2rO2JXdrlkyx3jhXQ794JqUV2QzEmiYH79CPm';
        
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.End_Point__c =  'https://test/v1/auth/token';
           	conDetails.Key__c = 'testKey';
            conDetails.Passcode__c =  'testPass';
            conDetails.Method_Type__c = 'POST';
        	conDetails.Name = 'dbu_ProductCloudfrontImageAccessToken';
        insert conDetails;

        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c =  'https://test/url';
            conDetails1.Method_Type__c = 'POST';
        	//conDetails1.grant_type__c = 'application/json';
        	conDetails1.Name = 'dbu_ProductCloudfrontImage';
        insert conDetails1;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new dbu_Integration_ProductCLImage_Mock()); 
        dbu_Integration_ProductCloudfrontImages.getAccessToken();
        dbu_Integration_ProductCloudfrontImages.getProductImages(imageURL, accessToken);
        Test.stopTest();
        
        
        
          
        
    }

}