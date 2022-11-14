//Test Class for the class OSM_BOLT_WS_CustomMasterInbound//
/***********************************************************
Name:  OSM_BOLT_WS_CustomMasterInbound_Test
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_BOLT_WS_CustomMasterInbound class                                   
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Moulika            08/04/2018     INITIAL DEVELOPMENT   
2.0     Sharad              10/03/21       Updated
3.0     Sharad              15/03/21        Updated
4.0     Sharad              15/03/21        Updated
5.0     Dhiraj              11/06/21        Updated

*************************************************************/

@isTest
global class OSM_BOLT_WS_CustomMasterInbound_Test{
    
    static testMethod void testCustomerInboundPositive()
    {
        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '429152';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert testAccount;
        system.debug('testAccount'+testAccount);
        
        ccrz__E_ContactAddr__c conAddrs = new ccrz__E_ContactAddr__c();
        conAddrs.ccrz__FirstName__c = 'STANADYNE (CHANGSHU)';
        conAddrs.ccrz__LastName__c = 'CORPORATION';
        conAddrs.ccrz__AddressFirstline__c = '155#HUANGSHI ROAD,SOUTHEAST DEVELOPMENT ZONE';
        conAddrs.ccrz__AddressSecondline__c = 'TEST22';
        conAddrs.ccrz__AddressThirdline__c = 'TEST22';
        conAddrs.Account__c = testAccount.id;
        conAddrs.Bolt_Active__c = true;
        conAddrs.BOLT_Operating_Unit__c = 'CN CFS Wuhan 745';
        conAddrs.Bolt_Site__c = true;
        conAddrs.ccrz__City__c = 'CHANGSHU';
        conAddrs.ccrz__ContactAddrId__c = '41252';
        //conAddrs.ccrz__Country__c = 
        conAddrs.ccrz__CountryISOCode__c = 'CN';
        conAddrs.ccrz__PostalCode__c = 'TEST22';
        conAddrs.Site_Use_Status__c = true;
        //conAddrs.ccrz__State__c = 
        conAddrs.ccrz__StateISOCode__c = 'TEST22';
        insert conAddrs;
        
        string accId = testAccount.id;      
        ccrz__E_AccountAddressBook__c addrsbook = new ccrz__E_AccountAddressBook__c();
        addrsbook.ccrz__Account__c = testAccount.id;
        addrsbook.ccrz__AccountId__c = accId;
        addrsbook.ccrz__E_ContactAddress__c = conAddrs.id;
        addrsbook.ccrz__AddressType__c = 'Billing';
        insert addrsbook;
          
        Test.startTest();  
        
        //Input JSON Request
        String JSONReq =  '{'+
                            '  \"Header\":{'+
                            '    \"Sender\":{'+
                            '      \"ServiceName\":\"CustomerMaster\",'+
                            '      \"SenderID\":\"BOLT\"'+
                            '    },'+
                            '    \"Target\":{'+
                            '      \"TargetID\":\"OSM\"'+
                            '    }'+
                            '  },'+
                            '  \"DataArea\":{'+
                            '    \"CUST_O_STG_ROW\":{'+
                            '      \"PARTY_TYPE\":\"ORGANIZATION\",'+
                            '      \"STATUS\":\"A\",'+
                            '      \"PARTY_NUMBER":\"2631555\",'+
                            '      \"PARTY_NAME":\"STANADYNE (CHANGSHU) CORPORATION\",'+
                            '      \"ORIG_SYSTEM_REFERENCE\":\"5441636\",'+
                            '      \"ATTR_CONTEXT\":null,'+
                            '      \"ATTRIBUTE1\":null,'+
                            '      \"ATTRIBUTE2\":null,'+
                            '      \"ATTRIBUTE3\":null,'+
                            '      \"ATTRIBUTE4\":null,'+
                            '      \"ATTRIBUTE5\":null,'+
                            '      \"ATTRIBUTE6\":null,'+
                            '      \"ATTRIBUTE7\":null,'+
                            '      \"ATTRIBUTE8\":null,'+
                            '      \"ATTRIBUTE9\":null,'+
                            '      \"ATTRIBUTE10\":null,'+
                            '      \"CUST_ACCTS_O_STG\":{'+
                            '        \"CUST_ACCTS_O_STG_ROW\":{'+
                            '          \"CUSTOMER_ACTION_TYPE\":\"SYNC\",'+
                            '          \"ACCOUNT_NUMBER\":\"429152\",'+
                            '          \"ALTERNATE_NAME":null,'+
                            '          \"TAXPAYER_ID":null,'+
                            '          \"ATTR_CONTEXT":"R",'+
                            '          \"ATTRIBUTE1":null,'+
                            '          \"ATTRIBUTE2":null,'+
                            '          \"ATTRIBUTE3":null,'+
                            '          \"ATTRIBUTE4":null,'+
                            '          \"ATTRIBUTE5":null,'+
                            '          \"ATTRIBUTE6":null,'+
                            '          \"ATTRIBUTE7":"No",'+
                            '          \"ATTRIBUTE9":null,'+
                            '          \"ATTRIBUTE10":null,'+
                            '          \"ATTRIBUTE11":null,'+
                            '          \"STATUS\":\"A\",'+
                            '          \"CUSTOMER_TYPE\":\"R\",'+
                            '          \"CUSTOMER_CLASS_CODE\":null,'+
                            '          \"ACCOUNT_REFERENCE":\"11694493\",'+
                            '          \"PROFILE_CLASS":\"DEFAULT\",'+
                            '          \"CREDIT_HOLD\":\"N\",'+
                            '          \"ACCT_SITES_O_STG\":{'+
                            '            \"ACCT_SITES_O_STG_ROW\":['+
                            '              {'+
                            '                \"ADDRESS_ACTION_TYPE\":\"SYNC\",'+
                            '                \"COUNTRY\":\"CN\",'+
                            '                \"ADDRESS1\":\"155#HUANGSHI ROAD,SOUTHEAST DEVELOPMENT ZONE\",'+
                            '                \"ADDRESS2\":\"TEST22\",'+
                            '                \"ADDRESS3\":\"TEST22\",'+
                            '                \"ADDRESS4\":null,'+
                            '                \"ADDRESS_LINES_PHONETIC\":null,'+
                            '                \"CITY\":\"CHANGSHU\",'+
                            '                \"STATE\":\"TEST22\",'+
                            '                \"POSTAL_CODE\":\"TEST22\",'+
                            '                \"PROVINCE\":\"JIANGSU\",'+
                            '                \"COUNTY\":null,'+
                            '                \"LOCATION_ATTRIBUTE1\":null,'+
                            '                \"LOCATION_ATTRIBUTE2\":null,'+
                            '                \"LOCATION_ATTRIBUTE3\":null,'+
                            '                \"LOCATION_ATTRIBUTE4\":null,'+
                            '                \"LOCATION_ATTRIBUTE5\":null,'+
                            '                \"LOCATION_ATTRIBUTE6\":null,'+
                            '                \"LOCATION_ATTRIBUTE7\":null,'+
                            '                \"LOCATION_ATTRIBUTE8\":null,'+
                            '                \"LOCATION_ATTRIBUTE9\":null,'+
                            '                \"LOCATION_ATTRIBUTE10\":null,'+
                            '                \"PARTY_SITE_REFERENCE\":\"3378442\",'+
                            '                \"PARTY_SITE_STATUS\":\"A\",'+
                            '                \"PARTY_SITE_NUMBER\":\"290694\",'+
                            '                \"BC_CODE\":\"745\",'+
                            '                \"ENTITY_CODE\":null,'+
                            '                \"BOLT_OPERATING_UNIT\":\"CN CFS Wuhan 745\",'+
                            '                \"IDENTIFYING_ADDRESS_FLAG\":\"Y\",'+
                            '                \"ACCOUNT_SITE_ACTION_TYPE\":\"UPDATE\",'+
                            '                \"ACC_SITE_REFERENCE\":\"41252\",'+
                            '                \"ACC_SITE_STATUS\":\"A\",'+
                            '                \"SITE_USE_CODE\":\"BILL_TO\",'+
                            '                \"LOCATION\":\"155#HUANGSHI ROAD,SOUTHEA\",'+
                            '                \"PRIMARY_FLAG\":\"Y\",'+
                            '                \"SITE_USE_STATUS\":\"A\",'+
                            '                \"RECEIVABLE_ACCOUNT\":\"TEST\",'+
                            '                \"SITE_USE_ATTRIBUTE1\":null,'+
                            '                \"SITE_USE_ATTRIBUTE2\":null,'+
                            '                \"SITE_USE_ATTRIBUTE3\":null,'+
                            '                \"SITE_USE_ATTRIBUTE4\":null,'+
                            '                \"SITE_USE_ATTRIBUTE5\":null,'+
                            '                \"SITE_USE_ATTRIBUTE6\":null,'+
                            '                \"SITE_USE_ATTRIBUTE7\":null,'+
                            '                \"SITE_USE_ATTRIBUTE8\":null,'+
                            '                \"SITE_USE_ATTRIBUTE9\":\"100368122\",'+
                            '                \"SITE_USE_ATTRIBUTE10\":null,'+
                            '                \"GLOBAL_ATTRIBUTE_CATEGORY\":null,'+
                            '                \"GLOBAL_ATTRIBUTE1\":null,'+
                            '                \"GLOBAL_ATTRIBUTE2\":null,'+
                            '                \"GLOBAL_ATTRIBUTE3\":null,'+
                            '                \"GLOBAL_ATTRIBUTE4\":null,'+
                            '                \"GLOBAL_ATTRIBUTE5\":null,'+
                            '                \"GLOBAL_ATTRIBUTE6\":null,'+
                            '                \"GLOBAL_ATTRIBUTE7\":null,'+
                            '                \"GLOBAL_ATTRIBUTE8\":null,'+
                            '                \"GLOBAL_ATTRIBUTE9\":null'+
                            '              }'+
                            '            ]'+
                            '          }'+
                            '        }'+
                            '      }'+
                            '    }'+
                            '  }'+
                            '}';
        System.debug('JSONReq____'+JSONReq);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestUri ='https://cumminscss--eidmdev.cs61.my.salesforce.com/services/apexrest/BoltCustomerMasterInbound/';
        req.requestBody = Blob.valueof(JSONReq);
        //req.params.put('ACTION','SendDataReceiptAcknowledgement');
        RestContext.response= res;
        RestContext.request = req;
        OSM_BOLT_WS_CustomMasterInbound.CustomMasterInboundService(); //Invoke the service
        Test.stopTest();           
    }    
    
    
    static testMethod void testCustomerInboundNegative()
    {
        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert testAccount;
        system.debug('testAccount'+testAccount);
        
        ccrz__E_ContactAddr__c conAddrs = new ccrz__E_ContactAddr__c();
        conAddrs.ccrz__FirstName__c = 'STANADYNE (CHANGSHU)';
        conAddrs.ccrz__LastName__c = 'CORPORATION';
        conAddrs.ccrz__AddressFirstline__c = '155#HUANGSHI ROAD,SOUTHEAST DEVELOPMENT ZONE';
        conAddrs.ccrz__AddressSecondline__c = 'TEST22';
        conAddrs.ccrz__AddressThirdline__c = 'TEST22';
        conAddrs.Account__c = testAccount.id;
        conAddrs.Bolt_Active__c = true;
        conAddrs.BOLT_Operating_Unit__c = 'CN CFS Wuhan 745';
        conAddrs.Bolt_Site__c = true;
        conAddrs.ccrz__City__c = 'CHANGSHU';
        conAddrs.ccrz__ContactAddrId__c = '41252';
        //conAddrs.ccrz__Country__c = 
        conAddrs.ccrz__CountryISOCode__c = 'CN';
        conAddrs.ccrz__PostalCode__c = 'TEST22';
        conAddrs.Site_Use_Status__c = true;
        //conAddrs.ccrz__State__c = 
        conAddrs.ccrz__StateISOCode__c = 'TEST22';
        insert conAddrs;
        
        string accId = testAccount.id;      
        ccrz__E_AccountAddressBook__c addrsbook = new ccrz__E_AccountAddressBook__c();
        addrsbook.ccrz__Account__c = testAccount.id;
        addrsbook.ccrz__AccountId__c = accId;
        addrsbook.ccrz__E_ContactAddress__c = conAddrs.id;
        addrsbook.ccrz__AddressType__c = 'Billing';
        insert addrsbook;
          
        Test.startTest();  
        
        //Input JSON Request
        String JSONReq =  '{'+
                            '  \"Header\":{'+
                            '    \"Sender\":{'+
                            '      \"ServiceName\":\"CustomerMaster\",'+
                            '      \"SenderID\":\"BOLT\"'+
                            '    },'+
                            '    \"Target\":{'+
                            '      \"TargetID\":\"OSM\"'+
                            '    }'+
                            '  },'+
                            '  \"DataArea\":{'+
                            '    \"CUST_O_STG_ROW\":{'+
                            '      \"PARTY_TYPE\":\"ORGANIZATION\",'+
                            '      \"STATUS\":\"A\",'+
                            '      \"PARTY_NUMBER":\"2631555\",'+
                            '      \"PARTY_NAME":\"STANADYNE (CHANGSHU) CORPORATION\",'+
                            '      \"ORIG_SYSTEM_REFERENCE\":\"5441636\",'+
                            '      \"ATTR_CONTEXT\":null,'+
                            '      \"ATTRIBUTE1\":null,'+
                            '      \"ATTRIBUTE2\":null,'+
                            '      \"ATTRIBUTE3\":null,'+
                            '      \"ATTRIBUTE4\":null,'+
                            '      \"ATTRIBUTE5\":null,'+
                            '      \"ATTRIBUTE6\":null,'+
                            '      \"ATTRIBUTE7\":null,'+
                            '      \"ATTRIBUTE8\":null,'+
                            '      \"ATTRIBUTE9\":null,'+
                            '      \"ATTRIBUTE10\":null,'+
                            '      \"CUST_ACCTS_O_STG\":{'+
                            '        \"CUST_ACCTS_O_STG_ROW\":{'+
                            '          \"CUSTOMER_ACTION_TYPE\":\"SYNC\",'+
                            '          \"ACCOUNT_NUMBER\":\"429152\",'+
                            '          \"ALTERNATE_NAME":null,'+
                            '          \"TAXPAYER_ID":null,'+
                            '          \"ATTR_CONTEXT":"R",'+
                            '          \"ATTRIBUTE1":null,'+
                            '          \"ATTRIBUTE2":null,'+
                            '          \"ATTRIBUTE3":null,'+
                            '          \"ATTRIBUTE4":null,'+
                            '          \"ATTRIBUTE5":null,'+
                            '          \"ATTRIBUTE6":null,'+
                            '          \"ATTRIBUTE7":"No",'+
                            '          \"ATTRIBUTE9":null,'+
                            '          \"ATTRIBUTE10":null,'+
                            '          \"ATTRIBUTE11":null,'+
                            '          \"STATUS\":\"A\",'+
                            '          \"CUSTOMER_TYPE\":\"R\",'+
                            '          \"CUSTOMER_CLASS_CODE\":null,'+
                            '          \"ACCOUNT_REFERENCE":\"11694493\",'+
                            '          \"PROFILE_CLASS":\"DEFAULT\",'+
                            '          \"CREDIT_HOLD\":\"N\",'+
                            '          \"ACCT_SITES_O_STG\":{'+
                            '            \"ACCT_SITES_O_STG_ROW\":['+
                            '              {'+
                            '                \"ADDRESS_ACTION_TYPE\":\"SYNC\",'+
                            '                \"COUNTRY\":\"CN\",'+
                            '                \"ADDRESS1\":\"155#HUANGSHI ROAD,SOUTHEAST DEVELOPMENT ZONE\",'+
                            '                \"ADDRESS2\":\"TEST22\",'+
                            '                \"ADDRESS3\":\"TEST22\",'+
                            '                \"ADDRESS4\":null,'+
                            '                \"ADDRESS_LINES_PHONETIC\":null,'+
                            '                \"CITY\":\"CHANGSHU\",'+
                            '                \"STATE\":\"TEST22\",'+
                            '                \"POSTAL_CODE\":\"TEST22\",'+
                            '                \"PROVINCE\":\"JIANGSU\",'+
                            '                \"COUNTY\":null,'+
                            '                \"LOCATION_ATTRIBUTE1\":null,'+
                            '                \"LOCATION_ATTRIBUTE2\":null,'+
                            '                \"LOCATION_ATTRIBUTE3\":null,'+
                            '                \"LOCATION_ATTRIBUTE4\":null,'+
                            '                \"LOCATION_ATTRIBUTE5\":null,'+
                            '                \"LOCATION_ATTRIBUTE6\":null,'+
                            '                \"LOCATION_ATTRIBUTE7\":null,'+
                            '                \"LOCATION_ATTRIBUTE8\":null,'+
                            '                \"LOCATION_ATTRIBUTE9\":null,'+
                            '                \"LOCATION_ATTRIBUTE10\":null,'+
                            '                \"PARTY_SITE_REFERENCE\":\"3378442\",'+
                            '                \"PARTY_SITE_STATUS\":\"A\",'+
                            '                \"PARTY_SITE_NUMBER\":\"290694\",'+
                            '                \"BC_CODE\":\"745\",'+
                            '                \"ENTITY_CODE\":null,'+
                            '                \"BOLT_OPERATING_UNIT\":\"CN CFS Wuhan 745\",'+
                            '                \"IDENTIFYING_ADDRESS_FLAG\":\"Y\",'+
                            '                \"ACCOUNT_SITE_ACTION_TYPE\":\"UPDATE\",'+
                            '                \"ACC_SITE_REFERENCE\":\"41252\",'+
                            '                \"ACC_SITE_STATUS\":\"A\",'+
                            '                \"SITE_USE_CODE\":\"BILL_TO\",'+
                            '                \"LOCATION\":\"155#HUANGSHI ROAD,SOUTHEA\",'+
                            '                \"PRIMARY_FLAG\":\"Y\",'+
                            '                \"SITE_USE_STATUS\":\"A\",'+
                            '                \"RECEIVABLE_ACCOUNT\":\"TEST\",'+
                            '                \"SITE_USE_ATTRIBUTE1\":null,'+
                            '                \"SITE_USE_ATTRIBUTE2\":null,'+
                            '                \"SITE_USE_ATTRIBUTE3\":null,'+
                            '                \"SITE_USE_ATTRIBUTE4\":null,'+
                            '                \"SITE_USE_ATTRIBUTE5\":null,'+
                            '                \"SITE_USE_ATTRIBUTE6\":null,'+
                            '                \"SITE_USE_ATTRIBUTE7\":null,'+
                            '                \"SITE_USE_ATTRIBUTE8\":null,'+
                            '                \"SITE_USE_ATTRIBUTE9\":\"100368122\",'+
                            '                \"SITE_USE_ATTRIBUTE10\":null,'+
                            '                \"GLOBAL_ATTRIBUTE_CATEGORY\":null,'+
                            '                \"GLOBAL_ATTRIBUTE1\":null,'+
                            '                \"GLOBAL_ATTRIBUTE2\":null,'+
                            '                \"GLOBAL_ATTRIBUTE3\":null,'+
                            '                \"GLOBAL_ATTRIBUTE4\":null,'+
                            '                \"GLOBAL_ATTRIBUTE5\":null,'+
                            '                \"GLOBAL_ATTRIBUTE6\":null,'+
                            '                \"GLOBAL_ATTRIBUTE7\":null,'+
                            '                \"GLOBAL_ATTRIBUTE8\":null,'+
                            '                \"GLOBAL_ATTRIBUTE9\":null'+
                            '              }'+
                            '            ]'+
                            '          }'+
                            '        }'+
                            '      }'+
                            '    }'+
                            '  }'+
                            '}';
        System.debug('JSONReq____'+JSONReq);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestUri ='https://cumminscss--eidmdev.cs61.my.salesforce.com/services/apexrest/BoltCustomerMasterInbound/';
        req.requestBody = Blob.valueof(JSONReq);
        //req.params.put('ACTION','SendDataReceiptAcknowledgement');
        RestContext.response= res;
        RestContext.request = req;
        OSM_BOLT_WS_CustomMasterInbound.CustomMasterInboundService(); //Invoke the service
        Test.stopTest();           
    }
    
    
    static testMethod void testCustomerInboundPositive2()
    {
        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '429152';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert testAccount;
        system.debug('testAccount'+testAccount);
        
        ccrz__E_ContactAddr__c conAddrs = new ccrz__E_ContactAddr__c();
        conAddrs.ccrz__FirstName__c = 'STANADYNE (CHANGSHU)';
        conAddrs.ccrz__LastName__c = 'CORPORATION';
        conAddrs.ccrz__AddressFirstline__c = '155#HUANGSHI ROAD,SOUTHEAST DEVELOPMENT ZONE';
        conAddrs.ccrz__AddressSecondline__c = 'TEST22';
        conAddrs.ccrz__AddressThirdline__c = 'TEST22';
        conAddrs.Account__c = testAccount.id;
        conAddrs.Bolt_Active__c = true;
        conAddrs.BOLT_Operating_Unit__c = 'CN CFS Wuhan 745';
        conAddrs.Bolt_Site__c = true;
        conAddrs.ccrz__City__c = 'CHANGSHU';
        conAddrs.ccrz__ContactAddrId__c = '4125222';
        //conAddrs.ccrz__Country__c = 
        conAddrs.ccrz__CountryISOCode__c = 'CN';
        conAddrs.ccrz__PostalCode__c = 'TEST22';
        conAddrs.Site_Use_Status__c = true;
        //conAddrs.ccrz__State__c = 
        conAddrs.ccrz__StateISOCode__c = 'TEST22';
        insert conAddrs;
        
        string accId = testAccount.id;      
        ccrz__E_AccountAddressBook__c addrsbook = new ccrz__E_AccountAddressBook__c();
        addrsbook.ccrz__Account__c = testAccount.id;
        addrsbook.ccrz__AccountId__c = accId;
        addrsbook.ccrz__E_ContactAddress__c = conAddrs.id;
        addrsbook.ccrz__AddressType__c = 'Billing';
        insert addrsbook;
          
        Test.startTest();  
        
        //Input JSON Request
        String JSONReq =  '{'+
                            '  \"Header\":{'+
                            '    \"Sender\":{'+
                            '      \"ServiceName\":\"CustomerMaster\",'+
                            '      \"SenderID\":\"BOLT\"'+
                            '    },'+
                            '    \"Target\":{'+
                            '      \"TargetID\":\"OSM\"'+
                            '    }'+
                            '  },'+
                            '  \"DataArea\":{'+
                            '    \"CUST_O_STG_ROW\":{'+
                            '      \"PARTY_TYPE\":\"ORGANIZATION\",'+
                            '      \"STATUS\":\"A\",'+
                            '      \"PARTY_NUMBER":\"2631555\",'+
                            '      \"PARTY_NAME":\"STANADYNE (CHANGSHU) CORPORATION\",'+
                            '      \"ORIG_SYSTEM_REFERENCE\":\"5441636\",'+
                            '      \"ATTR_CONTEXT\":null,'+
                            '      \"ATTRIBUTE1\":null,'+
                            '      \"ATTRIBUTE2\":null,'+
                            '      \"ATTRIBUTE3\":null,'+
                            '      \"ATTRIBUTE4\":null,'+
                            '      \"ATTRIBUTE5\":null,'+
                            '      \"ATTRIBUTE6\":null,'+
                            '      \"ATTRIBUTE7\":null,'+
                            '      \"ATTRIBUTE8\":null,'+
                            '      \"ATTRIBUTE9\":null,'+
                            '      \"ATTRIBUTE10\":null,'+
                            '      \"CUST_ACCTS_O_STG\":{'+
                            '        \"CUST_ACCTS_O_STG_ROW\":{'+
                            '          \"CUSTOMER_ACTION_TYPE\":\"SYNC\",'+
                            '          \"ACCOUNT_NUMBER\":\"429152\",'+
                            '          \"ALTERNATE_NAME":null,'+
                            '          \"TAXPAYER_ID":null,'+
                            '          \"ATTR_CONTEXT":"R",'+
                            '          \"ATTRIBUTE1":null,'+
                            '          \"ATTRIBUTE2":null,'+
                            '          \"ATTRIBUTE3":null,'+
                            '          \"ATTRIBUTE4":null,'+
                            '          \"ATTRIBUTE5":null,'+
                            '          \"ATTRIBUTE6":null,'+
                            '          \"ATTRIBUTE7":"No",'+
                            '          \"ATTRIBUTE9":null,'+
                            '          \"ATTRIBUTE10":null,'+
                            '          \"ATTRIBUTE11":null,'+
                            '          \"STATUS\":\"A\",'+
                            '          \"CUSTOMER_TYPE\":\"R\",'+
                            '          \"CUSTOMER_CLASS_CODE\":null,'+
                            '          \"ACCOUNT_REFERENCE":\"11694493\",'+
                            '          \"PROFILE_CLASS":\"DEFAULT\",'+
                            '          \"CREDIT_HOLD\":\"N\",'+
                            '          \"ACCT_SITES_O_STG\":{'+
                            '            \"ACCT_SITES_O_STG_ROW\":['+
                            '              {'+
                            '                \"ADDRESS_ACTION_TYPE\":\"SYNC\",'+
                            '                \"COUNTRY\":\"CN\",'+
                            '                \"ADDRESS1\":\"155#HUANGSHI ROAD,SOUTHEAST DEVELOPMENT ZONE\",'+
                            '                \"ADDRESS2\":\"TEST22\",'+
                            '                \"ADDRESS3\":\"TEST22\",'+
                            '                \"ADDRESS4\":null,'+
                            '                \"ADDRESS_LINES_PHONETIC\":null,'+
                            '                \"CITY\":\"CHANGSHU\",'+
                            '                \"STATE\":\"TEST22\",'+
                            '                \"POSTAL_CODE\":\"TEST22\",'+
                            '                \"PROVINCE\":\"JIANGSU\",'+
                            '                \"COUNTY\":null,'+
                            '                \"LOCATION_ATTRIBUTE1\":null,'+
                            '                \"LOCATION_ATTRIBUTE2\":null,'+
                            '                \"LOCATION_ATTRIBUTE3\":null,'+
                            '                \"LOCATION_ATTRIBUTE4\":null,'+
                            '                \"LOCATION_ATTRIBUTE5\":null,'+
                            '                \"LOCATION_ATTRIBUTE6\":null,'+
                            '                \"LOCATION_ATTRIBUTE7\":null,'+
                            '                \"LOCATION_ATTRIBUTE8\":null,'+
                            '                \"LOCATION_ATTRIBUTE9\":null,'+
                            '                \"LOCATION_ATTRIBUTE10\":null,'+
                            '                \"PARTY_SITE_REFERENCE\":\"3378442\",'+
                            '                \"PARTY_SITE_STATUS\":\"A\",'+
                            '                \"PARTY_SITE_NUMBER\":\"290694\",'+
                            '                \"BC_CODE\":\"745\",'+
                            '                \"ENTITY_CODE\":null,'+
                            '                \"BOLT_OPERATING_UNIT\":\"CN CFS Wuhan 745\",'+
                            '                \"IDENTIFYING_ADDRESS_FLAG\":\"Y\",'+
                            '                \"ACCOUNT_SITE_ACTION_TYPE\":\"UPDATE\",'+
                            '                \"ACC_SITE_REFERENCE\":\"41252\",'+
                            '                \"ACC_SITE_STATUS\":\"A\",'+
                            '                \"SITE_USE_CODE\":\"BILL_TO\",'+
                            '                \"LOCATION\":\"155#HUANGSHI ROAD,SOUTHEA\",'+
                            '                \"PRIMARY_FLAG\":\"Y\",'+
                            '                \"SITE_USE_STATUS\":\"A\",'+
                            '                \"RECEIVABLE_ACCOUNT\":\"TEST\",'+
                            '                \"SITE_USE_ATTRIBUTE1\":null,'+
                            '                \"SITE_USE_ATTRIBUTE2\":null,'+
                            '                \"SITE_USE_ATTRIBUTE3\":null,'+
                            '                \"SITE_USE_ATTRIBUTE4\":null,'+
                            '                \"SITE_USE_ATTRIBUTE5\":null,'+
                            '                \"SITE_USE_ATTRIBUTE6\":null,'+
                            '                \"SITE_USE_ATTRIBUTE7\":null,'+
                            '                \"SITE_USE_ATTRIBUTE8\":null,'+
                            '                \"SITE_USE_ATTRIBUTE9\":\"100368122\",'+
                            '                \"SITE_USE_ATTRIBUTE10\":null,'+
                            '                \"GLOBAL_ATTRIBUTE_CATEGORY\":null,'+
                            '                \"GLOBAL_ATTRIBUTE1\":null,'+
                            '                \"GLOBAL_ATTRIBUTE2\":null,'+
                            '                \"GLOBAL_ATTRIBUTE3\":null,'+
                            '                \"GLOBAL_ATTRIBUTE4\":null,'+
                            '                \"GLOBAL_ATTRIBUTE5\":null,'+
                            '                \"GLOBAL_ATTRIBUTE6\":null,'+
                            '                \"GLOBAL_ATTRIBUTE7\":null,'+
                            '                \"GLOBAL_ATTRIBUTE8\":null,'+
                            '                \"GLOBAL_ATTRIBUTE9\":null'+
                            '              }'+
                            '            ]'+
                            '          }'+
                            '        }'+
                            '      }'+
                            '    }'+
                            '  }'+
                            '}';
        System.debug('JSONReq____'+JSONReq);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestUri ='https://cumminscss--eidmdev.cs61.my.salesforce.com/services/apexrest/BoltCustomerMasterInbound/';
        req.requestBody = Blob.valueof(JSONReq);
        //req.params.put('ACTION','SendDataReceiptAcknowledgement');
        RestContext.response= res;
        RestContext.request = req;
        OSM_BOLT_WS_CustomMasterInbound.CustomMasterInboundService(); //Invoke the service
        Test.stopTest();           
    }
    
    
    static testMethod void testCustomerInboundNegative2()
    {
        //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert testAccount;
        system.debug('testAccount'+testAccount);
        
        ccrz__E_ContactAddr__c conAddrs = new ccrz__E_ContactAddr__c();
        conAddrs.ccrz__FirstName__c = 'STANADYNE (CHANGSHU)';
        conAddrs.ccrz__LastName__c = 'CORPORATION';
        conAddrs.ccrz__AddressFirstline__c = '155#HUANGSHI ROAD,SOUTHEAST DEVELOPMENT ZONE';
        conAddrs.ccrz__AddressSecondline__c = 'TEST22';
        conAddrs.ccrz__AddressThirdline__c = 'TEST22';
        conAddrs.Account__c = testAccount.id;
        conAddrs.Bolt_Active__c = true;
        conAddrs.BOLT_Operating_Unit__c = 'CN CFS Wuhan 745';
        conAddrs.Bolt_Site__c = true;
        conAddrs.ccrz__City__c = 'CHANGSHU';
        conAddrs.ccrz__ContactAddrId__c = '41252';
        //conAddrs.ccrz__Country__c = 
        conAddrs.ccrz__CountryISOCode__c = 'CN';
        conAddrs.ccrz__PostalCode__c = 'TEST22';
        conAddrs.Site_Use_Status__c = true;
        //conAddrs.ccrz__State__c = 
        conAddrs.ccrz__StateISOCode__c = 'TEST22';
        insert conAddrs;
        
        string accId = testAccount.id;      
        ccrz__E_AccountAddressBook__c addrsbook = new ccrz__E_AccountAddressBook__c();
        addrsbook.ccrz__Account__c = testAccount.id;
        addrsbook.ccrz__AccountId__c = accId;
        addrsbook.ccrz__E_ContactAddress__c = conAddrs.id;
        addrsbook.ccrz__AddressType__c = 'Billing';
        insert addrsbook;
          
        Test.startTest();  
        
        //Input JSON Request
        String JSONReq =  '{'+
                            '  \"Header\":{'+
                            '    \"Sender\":{'+
                            '      \"ServiceName\":\"CustomerMaster\",'+
                            '      \"SenderID\":\"BOLT\"'+
                            '    },'+
                            '    \"Target\":{'+
                            '      \"TargetID\":\"OSM\"'+
                            '    }'+
                            '  },'+
                            '  \"DataArea\":{'+
                            '    \"CUST_O_STG_ROW\":{'+
                            '      \"PARTY_TYPE\":\"ORGANIZATION\",'+
                            '      \"STATUS\":\"A\",'+
                            '      \"PARTY_NUMBER":\"2631555\",'+
                            '      \"ORIG_SYSTEM_REFERENCE\":\"5441636\",'+
                            '      \"ATTR_CONTEXT\":null,'+
                            '      \"ATTRIBUTE1\":null,'+
                            '      \"ATTRIBUTE2\":null,'+
                            '      \"ATTRIBUTE3\":null,'+
                            '      \"ATTRIBUTE4\":null,'+
                            '      \"ATTRIBUTE5\":null,'+
                            '      \"ATTRIBUTE6\":null,'+
                            '      \"ATTRIBUTE7\":null,'+
                            '      \"ATTRIBUTE8\":null,'+
                            '      \"ATTRIBUTE9\":null,'+
                            '      \"ATTRIBUTE10\":null,'+
                            '      \"CUST_ACCTS_O_STG\":{'+
                            '        \"CUST_ACCTS_O_STG_ROW\":{'+
                            '          \"CUSTOMER_ACTION_TYPE\":\"SYNC\",'+
                            '          \"ACCOUNT_NUMBER\":\"429152\",'+
                            '          \"ALTERNATE_NAME":null,'+
                            '          \"TAXPAYER_ID":null,'+
                            '          \"ATTR_CONTEXT":"R",'+
                            '          \"ATTRIBUTE1":null,'+
                            '          \"ATTRIBUTE2":null,'+
                            '          \"ATTRIBUTE3":null,'+
                            '          \"ATTRIBUTE4":null,'+
                            '          \"ATTRIBUTE5":null,'+
                            '          \"ATTRIBUTE6":null,'+
                            '          \"ATTRIBUTE7":"No",'+
                            '          \"ATTRIBUTE9":null,'+
                            '          \"ATTRIBUTE10":null,'+
                            '          \"ATTRIBUTE11":null,'+
                            '          \"STATUS\":\"A\",'+
                            '          \"CUSTOMER_TYPE\":\"R\",'+
                            '          \"CUSTOMER_CLASS_CODE\":null,'+
                            '          \"ACCOUNT_REFERENCE":\"11694493\",'+
                            '          \"PROFILE_CLASS":\"DEFAULT\",'+
                            '          \"CREDIT_HOLD\":\"N\",'+
                            '          \"ACCT_SITES_O_STG\":{'+
                            '            \"ACCT_SITES_O_STG_ROW\":['+
                            '              {'+
                            '                \"ADDRESS_ACTION_TYPE\":\"SYNC\",'+
                            '                \"COUNTRY\":\"CN\",'+
                            '                \"ADDRESS1\":\"155#HUANGSHI ROAD,SOUTHEAST DEVELOPMENT ZONE\",'+
                            '                \"ADDRESS2\":\"TEST22\",'+
                            '                \"ADDRESS3\":\"TEST22\",'+
                            '                \"ADDRESS4\":null,'+
                            '                \"ADDRESS_LINES_PHONETIC\":null,'+
                            '                \"CITY\":\"CHANGSHU\",'+
                            '                \"STATE\":\"TEST22\",'+
                            '                \"POSTAL_CODE\":\"TEST22\",'+
                            '                \"PROVINCE\":\"JIANGSU\",'+
                            '                \"COUNTY\":null,'+
                            '                \"LOCATION_ATTRIBUTE1\":null,'+
                            '                \"LOCATION_ATTRIBUTE2\":null,'+
                            '                \"LOCATION_ATTRIBUTE3\":null,'+
                            '                \"LOCATION_ATTRIBUTE4\":null,'+
                            '                \"LOCATION_ATTRIBUTE5\":null,'+
                            '                \"LOCATION_ATTRIBUTE6\":null,'+
                            '                \"LOCATION_ATTRIBUTE7\":null,'+
                            '                \"LOCATION_ATTRIBUTE8\":null,'+
                            '                \"LOCATION_ATTRIBUTE9\":null,'+
                            '                \"LOCATION_ATTRIBUTE10\":null,'+
                            '                \"PARTY_SITE_REFERENCE\":\"3378442\",'+
                            '                \"PARTY_SITE_STATUS\":\"A\",'+
                            '                \"PARTY_SITE_NUMBER\":\"290694\",'+
                            '                \"BC_CODE\":\"745\",'+
                            '                \"ENTITY_CODE\":null,'+
                            '                \"BOLT_OPERATING_UNIT\":\"CN CFS Wuhan 745\",'+
                            '                \"IDENTIFYING_ADDRESS_FLAG\":\"Y\",'+
                            '                \"ACCOUNT_SITE_ACTION_TYPE\":\"UPDATE\",'+
                            '                \"ACC_SITE_REFERENCE\":\"41252\",'+
                            '                \"ACC_SITE_STATUS\":\"A\",'+
                            '                \"SITE_USE_CODE\":\"BILL_TO\",'+
                            '                \"LOCATION\":\"155#HUANGSHI ROAD,SOUTHEA\",'+
                            '                \"PRIMARY_FLAG\":\"Y\",'+
                            '                \"SITE_USE_STATUS\":\"A\",'+
                            '                \"RECEIVABLE_ACCOUNT\":\"TEST\",'+
                            '                \"SITE_USE_ATTRIBUTE1\":null,'+
                            '                \"SITE_USE_ATTRIBUTE2\":null,'+
                            '                \"SITE_USE_ATTRIBUTE3\":null,'+
                            '                \"SITE_USE_ATTRIBUTE4\":null,'+
                            '                \"SITE_USE_ATTRIBUTE5\":null,'+
                            '                \"SITE_USE_ATTRIBUTE6\":null,'+
                            '                \"SITE_USE_ATTRIBUTE7\":null,'+
                            '                \"SITE_USE_ATTRIBUTE8\":null,'+
                            '                \"SITE_USE_ATTRIBUTE9\":\"100368122\",'+
                            '                \"SITE_USE_ATTRIBUTE10\":null,'+
                            '                \"GLOBAL_ATTRIBUTE_CATEGORY\":null,'+
                            '                \"GLOBAL_ATTRIBUTE1\":null,'+
                            '                \"GLOBAL_ATTRIBUTE2\":null,'+
                            '                \"GLOBAL_ATTRIBUTE3\":null,'+
                            '                \"GLOBAL_ATTRIBUTE4\":null,'+
                            '                \"GLOBAL_ATTRIBUTE5\":null,'+
                            '                \"GLOBAL_ATTRIBUTE6\":null,'+
                            '                \"GLOBAL_ATTRIBUTE7\":null,'+
                            '                \"GLOBAL_ATTRIBUTE8\":null,'+
                            '                \"GLOBAL_ATTRIBUTE9\":null'+
                            '              }'+
                            '            ]'+
                            '          }'+
                            '        }'+
                            '      }'+
                            '    }'+
                            '  }'+
                            '}';
        System.debug('JSONReq____'+JSONReq);
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        //Pass apexrest parameters
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestUri ='https://cumminscss--eidmdev.cs61.my.salesforce.com/services/apexrest/BoltCustomerMasterInbound/';
        req.requestBody = Blob.valueof(JSONReq);
        //req.params.put('ACTION','SendDataReceiptAcknowledgement');
        RestContext.response= res;
        RestContext.request = req;
        OSM_BOLT_WS_CustomMasterInbound.CustomMasterInboundService(); //Invoke the service
        Test.stopTest();           
    }
    
    
}