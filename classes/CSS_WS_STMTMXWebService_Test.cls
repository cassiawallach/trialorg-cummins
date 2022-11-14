@IsTest
Public Class CSS_WS_STMTMXWebService_Test{

    Public Static Testmethod Void WithMatchingID(){
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54321',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '54321',
            CSS_WS_DR_Credit_Number__c = '09876',
            CSS_WS_Total_Amount_Part__c = 900,
            CSS_WS_Total_Travel__c = 100,
            CSS_WS_Total_Amount_Travel__c = 250,
            CSS_WS_Total_Claim_Approved__c = 650,
            CSS_WS_Engine_Application_Code__c = '410',
            CSS_WS_Pay_Code__c = 'C',
            CSS_WS_Towing_Amount__c = 50,
            CSS_WS_Policy_Flag__c = 'Warranty',
            CSS_WS_Claim_Status__c = 'Pending CM');
        insert Claim;
        String ClaimNumber = [SELECT Name FROM CSS_WS_Warranty__c WHERE Id =: Claim.Id].Name;
        String SalesOrder = [SELECT CSS_WS_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Id =: Claim.Id].CSS_WS_Claim_Number__c;
        
        Test.startTest();
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestURI = '/stmt_mx/';
        RestContext.request.httpMethod = 'POST';
        RestContext.request.requestBody = Blob.valueof('{"documentType":"Transaction Type", "transactionNumber":"123456789", "transactionDate":"2016-09-21T00:00:00", "extendedAmount":"-800", "customerNumber":"98765432", "billToCustomerName":"Bill Customer Name", "shipToCustomerName":"Ship Customer Name", "timbreFiscal":"Tim9001", "idDocument":"09876", "salesOrder":"'+SalesOrder+'"}');
        system.debug(RestContext.request.requestBody);
        CSS_WS_STMTMXWebService.doPost();
        SPDLTest.Type = 'Distributor Account';
        upsert SPDLTest;
        Claim.CSS_WS_Claim_Status__c = 'Pending CM';
        upsert claim;
        CSS_WS_STMTMXWebService.doPost();
        
        SPDLTest.Type = 'Dealer Account';
        upsert SPDLTest;
        Claim.CSS_WS_Claim_Status__c = 'Pending CM';
        Claim.CSS_WS_Engine_Application_Code__c = '210';
        upsert claim;
        CSS_WS_STMTMXWebService.doPost();
        
        Claim.CSS_WS_Claim_Status__c = 'Pending CM';
        Claim.CSS_WS_Pay_Code__c = 'I';
        upsert claim;
        CSS_WS_STMTMXWebService.doPost();
        
        Claim.CSS_WS_Claim_Status__c = 'Pending CM';
        Claim.CSS_WS_Towing_Amount__c = 0;
        upsert claim;
        CSS_WS_STMTMXWebService.doPost();
        
        Claim.CSS_WS_Policy_Flag__c = 'Policy';
        upsert claim;
        CSS_WS_STMTMXWebService.doPost();
        Test.stopTest();
        
        System.assertEquals('{"Status":"Success","ErrorMessage":""}', System.RestContext.response.responseBody.toString());
    }
    
    Public Static Testmethod Void WithMatchingIDforInvoice(){
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54321',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '54321',
            CSS_WS_DR_Credit_Number__c = '09876',
            CSS_WS_Total_Amount_Part__c = 900,
            CSS_WS_Total_Travel__c = 100,
            CSS_WS_Total_Amount_Travel__c = 250,
            CSS_WS_Total_Claim_Approved__c = 650,
            CSS_WS_Account_Code__c = 'P101', 
            CSS_WS_Service_Order_Counter_Flag__c = 3,
            CSS_WS_Claim_Status__c = 'Pending CM');
        insert Claim;
        String ClaimNumber = [SELECT Name FROM CSS_WS_Warranty__c WHERE Id =: Claim.Id].Name;
        String SalesOrder = [SELECT CSS_WS_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Id =: Claim.Id].CSS_WS_Claim_Number__c;
        
        Test.startTest();
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestURI = '/stmt_mx/';
        RestContext.request.httpMethod = 'POST';
        RestContext.request.requestBody = Blob.valueof('{"documentType":"CGLF", "transactionNumber":"123456789", "transactionDate":"2016-09-21T00:00:00", "extendedAmount":"-800", "customerNumber":"98765432", "billToCustomerName":"Bill Customer Name", "shipToCustomerName":"Ship Customer Name", "timbreFiscal":"Tim9001", "idDocument":"09876", "salesOrder":"'+SalesOrder+'"}');
        system.debug(RestContext.request.requestBody);
        CSS_WS_STMTMXWebService.doPost();
        SPDLTest.Type = 'Distributor Account';
        upsert SPDLTest;
        Claim.CSS_WS_Claim_Status__c = 'Pending CM';
        upsert claim;
        CSS_WS_STMTMXWebService.doPost();
        Test.stopTest();
        
        System.assertEquals('{"Status":"Success","ErrorMessage":""}', System.RestContext.response.responseBody.toString());
    }
    
    Public Static Testmethod Void WithoutMatchingID(){
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '12345',
            Type = 'Distributor Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_Dealer__c = '12345',
            CSS_WS_Service_Provider_DR__c = '12345',
            CSS_WS_DR_Credit_Number__c = '09876',
            CSS_WS_Claim_Status__c = 'Pending CM');        
        insert Claim;
        
        String ClaimNumber = [select Name from CSS_WS_Warranty__c where Id =: Claim.Id].Name;
        
        Test.startTest();
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        RestContext.request.requestURI = '/stmt_mx/';
        RestContext.request.httpMethod = 'POST';
        RestContext.request.requestBody = Blob.valueof('{"documentType":"Transaction Type", "transactionNumber":"123456789", "transactionDate":"2016-09-21T00:00:00", "extendedAmount":"900", "customerNumber":"98765432", "billToCustomerName":"Bill Customer Name", "shipToCustomerName":"Ship Customer Name", "timbreFiscal":"Tim9001", "idDocument":"12345", "salesOrder":"SalesOrder-123"}');
        CSS_WS_STMTMXWebService.doPost();
        Test.stopTest();
        
        System.assertEquals('{"Status":"Error","ErrorMessage":"Credit Number not found"}', System.RestContext.response.responseBody.toString());
    }
      
}