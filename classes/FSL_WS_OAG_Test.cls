@isTest
public class FSL_WS_OAG_Test {
    
    static testMethod void testAccessToken() {
        
        test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_WS_OAG.getAccessToken();
    }
    
    static testMethod void testCDSToken() {
        
        CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
        conDetail.Name = 'GetSymptomsTest';
        conDetail.Username__c = '562e164f-f255-4eff-9c29-3ceed139c0dd';
        conDetail.Passcode__c = 'nFdnKFgXVjKg5JZTOmA2zzCaSUgh0FZi6GXvJBYFV4M=';
        conDetail.End_Point__c = 'https://cdsdomain-dev.cummins.com/api/v1/GetToken';
        conDetail.Key__c = '562e164f-f255-4eff-9c29-3ceed139c0dd';
        insert conDetail;
        
        test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        HttpRequest req = new HttpRequest();
        List<CSS_Integration_Details__c> conDetails = new List<CSS_Integration_Details__c>();
        FSL_WS_OAG.getAccessTokenCDS('GetSymptomsTest');
        // added by harsha 04-21-2020
        FSL_WS_OAG.getAccessTokenCDS(null);
    }
    
    static testMethod void testCDSToken1() {
        
        CSS_Integration_Details__c conDetail1 = new CSS_Integration_Details__c();
        conDetail1.Name = 'GetSymptomsTesting';
        conDetail1.Username__c = '562e164f-f255-4eff-9c29-3ceed139c0dd';
        conDetail1.Passcode__c = 'nFdnKFgXVjKg5JZTOmA2zzCaSUgh0FZi6GXvJBYFV4M=';
        conDetail1.End_Point__c = 'https://cdsdomain-dev.cummins.com/api/v1/GetToken';
        conDetail1.Key__c = '562e164f-f255-4eff-9c29-3ceed139c0dd';
        insert conDetail1; 
        
        FSL_WS_OAG.getAccessTokenCDS('GetSymptomsTesting');
    }
}