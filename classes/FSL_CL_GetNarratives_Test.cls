@isTest
global class FSL_CL_GetNarratives_Test {
    static testMethod void testNarrCallout() {
       
        CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        conDetail.End_Point__c = 'https://test.cummins.com/callNarratives';
        conDetail.Name = 'FSL_GetNarratives';
        conDetail.ApplicationName__c='FSL_GetNarratives';
        conDetail.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        conDetail.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        conDetail.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        conDetail.AuthEnv__c='MuleAuth123';
        conDetail.Method_Type__c='GET';
        conDetail.IsActive__c=true;
        insert conDetail;
        
        HttpResponse httpResp = FSL_CL_GetNarratives.getNarratives('1-0000001');
    }
}