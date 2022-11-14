/************************************************************
Name:  IAM_EDQ_WebService_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Apex class to sync Customer Data to CDH and Capture the repsonse and update it Accordingly 2                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram     11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020     Changed the end points for Mule API convertion API      
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
public class IAM_EDQ_WebService_Test {

     @TestSetup
    Public Static Void TestData(){
        CSS_Integration_Details__c iamCDH = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        iamCDH.Name = 'IAM_EDQ_Mule_Address_Validation';
            iamCDH.ApplicationName__c ='IAM_EDQ_Mule_Address';
            iamCDH.End_Point__c = 'https://testconnection.com';
            iamCDH.IsActive__c = TRUE;
            iamCDH.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
            iamCDH.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
            iamCDH.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
            //Added below two lines for IAM purpose by Karthik Golakaram
            iamCDH.Logging__c ='IAMCDH' ;
            iamCDH.Method_Type__c ='POST' ;
            iamCDH.AuthEnv__c='IAMCDH' ;
            iamCDH.grant_type__c='Client_credentials';
            iamCDH.Resource__c='https://testconnections.com';
            iamCDH.Timeout__c=120000;
            
            insert iamCDH;
    }
        
 static testmethod void myUnitTest(){
    Account a= new Account();
    a.Name='testing EDQ service';
    insert a;
    
    
    Account ant=[select id,Name from account where name='testing EDQ service'];
    TestData();
    IAM_EDQ_AddressCleanse edq=new IAM_EDQ_AddressCleanse();
    IAM_EDQ_LocationResParser parser=IAM_EDQ_AddressCleanse.EDQAddress(ant);
    IAM_EDQ_LocationResParser parser2=IAM_EDQ_AddressCleanse.EDQAddress(a);
    
}
  
}