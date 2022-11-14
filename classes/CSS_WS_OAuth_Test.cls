@IsTest
Private Class CSS_WS_OAuth_Test{
    
    Public Static TestMethod Void testGetToken(){
        String auth_Token;
        //Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        //This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        auth_token = CSS_WS_OAuth.getToken('MxAuthEngi');
        //Verify mock response is not null
        System.assertNotEquals(null,auth_token,'The callout returned a null response.');
        system.debug (auth_token);
    }  
    
    Public Static TestMethod Void testNonGetToken() {
        String auth_token;
        //Set mock callout class Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        //This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        auth_token = CSS_WS_OAuth.getToken('token');
        //Verify mock response is not null
        System.assertEquals(null,auth_token,'The callout returned a null response.');
        System.debug (auth_token);
    }  
    
    Public Static TestMethod Void testGetConnection() {
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        
        CSS_Integration_Details__c MxTestConnection = new CSS_Integration_Details__c(
            Name = 'MxTest',
            ApplicationName__c = 'MxTest',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );
        
        insert MxTestConnection;
                
        Test.startTest();
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails = CSS_WS_OAuth.getConnection('MxTest');
        Test.stopTest();
        System.assertNotEquals(null,conDetails,'Getting a record from query');
    }
}