/************************************************************
Name:  IAM_CDH_SyncCustomer
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
1.2 -    Shubhangi Sardar          06/12/2021     Test class execution - INC1499444, INC1583886, CHG0065903
1.3 -    Shubhangi Sardar          06/17/2021     Changed reclaim email template
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
public class IAM_CDH_SyncCustomer_Test {
    
    @TestSetup
    Public Static Void TestData(){
        CSS_Integration_Details__c iamCDH = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        iamCDH.Name = 'IAM_CDH_Mule_Customer_Sync';
            iamCDH.ApplicationName__c ='IAM_CDH_Mule_Customer_Sync';
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
    
    /* Test CDH Response */
    private static testmethod void cdhResponseTest() {
        Account acc = IAM_TestData.createAccount();
        IAM_TestData.create_CDH_SynCust_CS();
        TestData();
        String responseBodyCDH = IAM_TestData.testResponseCDH();
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyCDH, null));
        Test.startTest();
        IAM_CDH_SyncCustomer.CDHOutboundCall(acc.Name, acc.Id);
        Test.stopTest();
        /* Calling assert after Test.stpTest because IAM_CDH_SyncCustomer.CDHOutboundCall() is a future method */
        Account selAcc = [SELECT IAM_CDH_Sync__c FROM Account WHERE Id = :acc.Id];
        //System.assert(selAcc.IAM_CDH_Sync__c);
    }

    /* Test CDH Request */
    private static testmethod void cdhRequestTest() {
        Account acc = IAM_TestData.createAccount();
        TestData();
        Account selAcc = [
            SELECT Id
                 , Name
                 , IAM_Service_Provider_Code__c
                 , CMI_Primary_Contact_Phone__c
                 , CMI_Account_Status__c
                 , BillingCity
                 , BillingStreet
                 , CMI_Address2__c
                 , BillingCountryCode
                 , BillingStateCode
                 , BillingPostalCode
                 , IAM_Verified_Flag__c
                 , IAM_Verification_code__c
                 , IAM_ECN__c
              FROM Account
             WHERE Id = :acc.Id
        ];
        Test.startTest();
        String req = IAM_CDH_SyncCustomer.getCDHOutboundReq(selAcc);
        System.assert(String.isNotBlank(req));
        Test.stopTest();
    }    
}