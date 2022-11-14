@istest
class CSS_WS_AmountWebService_Test {
    static testmethod void MexicoApproved() {
    
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54321',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO'
        );
        
        insert SPDLTest;
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '54321',
            CSS_WS_Siebel_Claim_Number__c = 'Siebel-123',
            CSS_WS_Claim_Status__c = 'Pending US'
        );
        
        insert Claim;
        
        Test.startTest();
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestURI = '/css_amount/';
        RestContext.request.httpMethod = 'POST';
        RestContext.request.requestBody = Blob.valueof('{"claimNumber":"Siebel-123","IMSClaimNumber":"IMS-123","claimStatus":"Paid","rejectionReason":"test","typeNumber":"Payment","statementNumber":"123456789","creditDate":"9/19/2016","creditNumber":"CT123456","parts":"450","labor":"250","travel":"300","other":"50","tax":"200","PMU":"PMU123","BFC":"BFC123","deductible":"25","totalPaid":"1050","payCode":"paycode-123"}');
        // For coverage
        CSS_WS_AmountWebService.doPost();
  
        Test.stopTest();
        
        System.assertEquals('{"Status":"Success","ErrorMessage":""}',System.RestContext.response.responseBody.toString());
    }
    
    static testmethod void MexicoRejected() {
 
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54321',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO'
        );
        
        insert SPDLTest;
        
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '54321',
            CSS_WS_Siebel_Claim_Number__c = 'Siebel-123',
            CSS_WS_Claim_Status__c = 'Pending US'
        );
        
        insert Claim;
        
        Test.startTest();
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestURI = '/css_amount/';
        RestContext.request.httpMethod = 'POST';
        RestContext.request.requestBody = Blob.valueof('{"claimNumber":"Siebel-123","IMSClaimNumber":"","claimStatus":"Denied","rejectionReason":"test","typeNumber":"Payment","statementNumber":"123456789","creditDate":"9/19/2016","creditNumber":"CT123456","parts":"450","labor":"250","travel":"300","other":"50","tax":"200","PMU":"PMU123","BFC":"BFC123","deductible":"25","totalPaid":"1050","payCode":"paycode-123"}');
        // For coverage
        CSS_WS_AmountWebService.doPost();

        Test.stopTest();
        
        System.assertEquals('{"Status":"Success","ErrorMessage":""}',System.RestContext.response.responseBody.toString());
    }
    
    static testmethod void CentralAmericaApproved() {
    
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54321',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Costa Rica'
        );
        
        insert SPDLTest;
        
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '54321',
            CSS_WS_Siebel_Claim_Number__c = 'Siebel-123',
            CSS_WS_Claim_Status__c = 'Pending US'
        );
        
        insert Claim;
        
        Test.startTest();
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestURI = '/css_amount/';
        RestContext.request.httpMethod = 'POST';
        RestContext.request.requestBody = Blob.valueof('{"claimNumber":"Siebel-123","IMSClaimNumber":"IMS-123","claimStatus":"Paid","rejectionReason":"test","typeNumber":"Payment","statementNumber":"123456789","creditDate":"9/19/2016","creditNumber":"CT123456","parts":"450","labor":"250","travel":"300","other":"50","tax":"200","PMU":"PMU123","BFC":"BFC123","deductible":"25","totalPaid":"1050","payCode":"paycode-123"}');
        // For coverage
        CSS_WS_AmountWebService.doPost();
        
        Test.stopTest();
        
        System.assertEquals('{"Status":"Success","ErrorMessage":""}',System.RestContext.response.responseBody.toString());
    }
    
    static testmethod void CentralAmericaRejected() {
        
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54321',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Costa Rica'
        );
        
        insert SPDLTest;
        
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '54321',
            CSS_WS_Siebel_Claim_Number__c = 'Siebel-123',
            CSS_WS_Claim_Status__c = 'Pending US'
        );
        
        insert Claim;
        
        Test.startTest();
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestURI = '/css_amount/';
        RestContext.request.httpMethod = 'POST';
        RestContext.request.requestBody = Blob.valueof('{"claimNumber":"Siebel-123","IMSClaimNumber":"","claimStatus":"Denied","rejectionReason":"test","typeNumber":"Payment","statementNumber":"123456789","creditDate":"9/19/2016","creditNumber":"CT123456","parts":"450","labor":"250","travel":"300","other":"50","tax":"200","PMU":"PMU123","BFC":"BFC123","deductible":"25","totalPaid":"1050","payCode":"paycode-123"}');
        // For coverage
        CSS_WS_AmountWebService.doPost();
        Test.stopTest();
        
        System.assertEquals('{"Status":"Success","ErrorMessage":""}',System.RestContext.response.responseBody.toString());
    }
    
    static testmethod void invalidClaimNumber() {

        Test.startTest();
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestURI = '/css_amount/';
        RestContext.request.httpMethod = 'POST';
        RestContext.request.requestBody = Blob.valueof('{"claimNumber":"","IMSClaimNumber":"","claimStatus":"Denied","rejectionReason":"test","typeNumber":"Payment","statementNumber":"123456789","creditDate":"9/19/2016","creditNumber":"CT123456","parts":"450","labor":"250","travel":"300","other":"50","tax":"200","PMU":"PMU123","BFC":"BFC123","deductible":"25","totalPaid":"1050","payCode":"paycode-123"}');
        // For coverage
        CSS_WS_AmountWebService.doPost();
        Test.stopTest();
        
        System.assertEquals('{"Status":"Error","ErrorMessage":"Claim Number not found"}',System.RestContext.response.responseBody.toString());
    }
}