@IsTest
Public Class CSS_WS_Webservices_Test{
    
    Static Testmethod Void testWebServices(){
    
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxClaimRel',
            ApplicationName__c = 'MxClaimRel',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxEngData2',
            ApplicationName__c = 'MxEngData2',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2;              
        
        String jsonRequest;
        String esn = '12345678';
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        
        jsonRequest = '?sender=SFMX&target=CSSWarranty&esn=' + esn;
        
        CSS_WS_Webservices WSObj1 = new CSS_WS_Webservices('MxClaimRel');
        WSObj1.setRequestData(jsonRequest, 'MxClaimRel');
        
        CSS_WS_Webservices WSObj2 = new CSS_WS_Webservices('MxEngData2');
        WSObj2.setRequestData(jsonRequest, 'MxEngData2');
        
    }
}