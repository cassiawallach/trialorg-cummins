/************************************************************
Name:  IAM_GL_Webservice_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This Class will give the nearest distributor when address is sent to Global Locator team   Test class  2                   
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram     11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020      Changes made for Mule API   
1.2 -    Karthik Raj Golakaram     03/26/2021      Made changes for Global Locator fix  
*****************************************************/
/********************************************************************************
***********************************************************************************/

@isTest
Private Class IAM_GL_Webservice_Test{

    Private Static Void TestData(){
        CSS_Integration_Details__c iamCDH = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        iamCDH.Name = 'IAM_Global_Locator_Mule';
            iamCDH.ApplicationName__c ='IAM_Global_Locator';
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
    
    /*Static TestMethod void testCase1(){
    Account acc = IAM_TestData.createAccount();
    TestData();
    IAM_GL_Webservice.makeCallout(acc.BillingStreet,acc.BillingCity,acc.BillingCountry,acc.BillingPostalCode);
    
    }*/

    static testmethod void glWebServiceCallTest() {
        try {
            Account parentAcc = createParentAccount();
            TestData();
            Account acc = createDealerAccount();
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
                
            Test.startTest();
            	IAM_GL_Webservice.makeCallout(acc.BillingStreet,acc.BillingCity,acc.BillingCountry,acc.BillingPostalCode);
            Test.stopTest();
        } catch(Exception e) {
            System.debug('#### Exception - '+e.getMessage());
        }
    }
    
    /* Return GL service response body */
    private static String getGLResBody(String hqcode, String spcode) {
        return '{"getSPSearchResultsReturn":{"cumminsLocationDTO":{"branchDTO":{"zipCode":"E3C 2E7","durationText":"1 hour 11 mins","spName":"Eastern Canada - Fredericton","countyDistrict":{"nil":true},"hqCode":"'+hqcode+'","tollFreePhone":{"nil":true},"tollFreeFax":{"nil":true},"latitude":45.9072283,"city Name":"Fredericton","stateName":"New Brunswick","distanceText":"69.8 mi","marketProgram":{"nil":true},"spcode":"'+spcode+'","fax":"506 451-1927","spLocType":101,"email":{"nil":true},"longitude":-66.62141839999998,"address3":{"nil":true},"address2":{"nil":true},"address1":"321  Doak Road","webAddress":{"nil":true},"custServicePhone":{"nil":true},"amenityComments":{"nil":true},"distanceValue":0,"countryName":"Canada","busi nessPhone":"506 451-1929","emergencyPhone":{"nil":true}},"hqDTO":{"nil":true}},"errorCode":{"nil":true},"spDTO":{"nil":true},"paginationDTO":{"nil":true},"la ngId":1,"omrResultFlag":{"nil":true}}}';
    }
    
     /* Create and return parent account*/
    private static Account createParentAccount() {
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account Test Class';
        acc.IAM_Service_Provider_Code__c = '1234';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'Fredericton';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E3C 2E7';
        acc.BillingState='New Brunswick';
        acc.CSS_DistributorCode__c='1234';
        acc.Type = 'Distributor Account';
        insert acc;
        
        return [SELECT Id, Name, IAM_Service_Provider_Code__c FROM Account WHERE Id = :acc.Id];
    }
    
    private static Account createDealerAccount() {
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        

        acc.CSS_DistributorCode__c='1234';
        acc.CSS_DealerCode__c='test';
        
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = '2345';
        
        acc.CSS_Locale__c = 'English(United States)';
        acc.CSS_Language__c = 'English';
        acc.CSS_Timezone__c = '(GMT-05:00) Eastern Standard Time (America/Panama)';
        insert acc;
        return acc;
    }

}