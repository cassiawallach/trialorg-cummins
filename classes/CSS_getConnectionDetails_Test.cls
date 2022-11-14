@isTest
public class CSS_getConnectionDetails_Test {
    @isTest static void testConnection(){
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'QSOL';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'QSOL';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        insert inte;
        CSS_getConnnectionDetails.getConnection('QSOL');
    }
    
    @isTest static void testConnection1(){
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'QSOL';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'QSOL';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        //insert inte;
        CSS_getConnnectionDetails.getConnection('QSOL');
    }
}