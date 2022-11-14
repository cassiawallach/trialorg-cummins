//Test Class for the class OSM_SW_CyberSourcePayment
//updated on 2nd Dec 20
//updated on for MAR-1739
//updated on for MP-337
//updated on for MP-349
//Updated test class by Sangeeta on 21-02-2022 for MP-652
//Updated
@isTest
public class OSM_SW_CyberSourcePayment_Test {
    static testMethod void testOSM_SW_CyberSourcePayment() {
        OSM_SW_CyberSourcePayment osmSWCyberSourcePayment = new OSM_SW_CyberSourcePayment();

        System.debug(OSM_SW_CyberSourcePayment.ALGORITHM_NAME);
        System.debug(OSM_SW_CyberSourcePayment.TRANSACTION_TYPE);
        System.debug(OSM_SW_CyberSourcePayment.PAYMENT_METHOD);
        System.debug(OSM_SW_CyberSourcePayment.UNSIGNED_FIELDS);
    }

    static testMethod void testGetCybersourceHostedFormData() {
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';

        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';


        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';

        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';


        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';


        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        //For remote action context 

        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
        User portalUser = new User(Alias = 'botman',
                                    Lastname = 'Wayneo',
                                    Firstname = 'Bruceo',
                                    LocaleSidKey = 'en_US',
                                    ProfileId = profile1.Id,
                                    EmailEncodingKey = 'UTF-8',
                                    UserRoleId = portalRole.Id,
                                    LanguageLocaleKey = 'en_US',
                                    Username = 'test20046@test.com',
                                    TimeZoneSidKey = 'America/Chicago',
                                    Email = 'bruce.wayne0@wayneenterprises.com'
        );
        
        Database.insert(portalUser);
        
        Account portalAccount = new Account(Name = 'TestAccount2',
                                            OwnerId = portalUser.Id,
                                            BMS_Customer_ID__c = '1234',
                                            OSM_Preferred_Payment_Method__c = 'po',
                                            OSM_Preferred_Payment_IsBolt_PO__c = false,
                                            OSM_Preferred_Billing_Frequency_Lock__c = false);
                                            
        System.runAs(portalUser) {
            Database.insert(portalAccount);
        }

        //Create contact
        Contact contact1 = new Contact(FirstName = 'Test',
                                        Lastname = 'McTesty',
                                        Email = 'test@test.com',
                                        AccountId = portalAccount.Id,
                                        IAM_Contact_Status__c = 'Pending',
                                        Username__c = 'testUserName7789@gmail.com');
        
        System.runAs(portalUser) {
            Database.insert(contact1);
        }

        User testUser = new User();
        testUser.Alias = 'botmon';
        testUser.isActive = true;
        testUser.LastName = 'lasttt';
        testUser.FirstName = 'Testttt';
        testUser.LocaleSidKey = 'en_US';
        testUser.ContactId = contact1.Id;
        testUser.LanguageLocaleKey = 'en_US';
        testUser.UserName = 'test2@test.com';
        testUser.ProfileId = portal_PROFILE_ID;
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.CommunityNickname = 'test12345h';
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.Email = 'bruce.wayne@wayneenterprises.com';
        
        System.runAs(portalUser) {
            insert testUser;

        }
        
        System.runAs(portalUser) {
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.portalUserId = testUser.Id;
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
    
            // ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            OSM_SW_CyberSourcePayment.getCybersourceHostedFormData(objRemotCtx);
            //OSM_SW_CybersourceHostedPageDataFields cyberObj=new OSM_SW_CybersourceHostedPageDataFields();
            //OSM_SW_CyberSourcePayment.populateSignatureData(cyberObj);
            
            String successResponse='{"reason_code":"100","decision":"ACCEPT","accountBalance":"70","ownerMerchantID":"bams_cummins","auth_avs_code":"X","payment_token":"","auth_code":"888888","req_card_type":"001","req_card_expiry_date":"03/2019","req_amount":"334","auth_trans_ref_no":"test"}';
            OSM_SW_CyberSourcePayment.processCybersourceResponse(objRemotCtx,successResponse);
            
            Map<String, Object> parametersFromBAMS = new Map<String, Object>();
            
            try{
                parametersFromBAMS.put('signed_field_names','abc:abc,xyz:xyz');
                OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
            }catch(exception ex){}
            
            try{
                parametersFromBAMS.put('signed_field_names',null);
                OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
            }catch(exception ex){}
        }
    }
    
    static testMethod void cardDeclinedTest() {
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';

        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';


        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';

        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';


        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';


        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        //For remote action context 

        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
        User portalUser = new User(Alias = 'botman',
                                    Lastname = 'Wayneo',
                                    Firstname = 'Bruceo',
                                    LocaleSidKey = 'en_US',
                                    ProfileId = profile1.Id,
                                    EmailEncodingKey = 'UTF-8',
                                    UserRoleId = portalRole.Id,
                                    LanguageLocaleKey = 'en_US',
                                    Username = 'test20046@test.com',
                                    TimeZoneSidKey = 'America/Chicago',
                                    Email = 'bruce.wayne0@wayneenterprises.com'
        );
        
        Database.insert(portalUser);
        
        Account portalAccount = new Account(Name = 'TestAccount2',
                                            OwnerId = portalUser.Id,
                                            BMS_Customer_ID__c = '1234',
                                            OSM_Preferred_Payment_Method__c = 'po',
                                            OSM_Preferred_Payment_IsBolt_PO__c = false,
                                            OSM_Preferred_Billing_Frequency_Lock__c = false);
                                            
        System.runAs(portalUser) {
            Database.insert(portalAccount);
        }

        //Create contact
        Contact contact1 = new Contact(FirstName = 'Test',
                                        Lastname = 'McTesty',
                                        Email = 'test@test.com',
                                        AccountId = portalAccount.Id,
                                        IAM_Contact_Status__c = 'Pending',
                                        Username__c = 'testUserName7789@gmail.com');
        
        System.runAs(portalUser) {
            Database.insert(contact1);
        }

        User testUser = new User();
        testUser.Alias = 'botmon';
        testUser.isActive = true;
        testUser.LastName = 'lasttt';
        testUser.FirstName = 'Testttt';
        testUser.LocaleSidKey = 'en_US';
        testUser.ContactId = contact1.Id;
        testUser.LanguageLocaleKey = 'en_US';
        testUser.UserName = 'test2@test.com';
        testUser.ProfileId = portal_PROFILE_ID;
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.CommunityNickname = 'test12345h';
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.Email = 'bruce.wayne@wayneenterprises.com';
        
        System.runAs(portalUser) {
            insert testUser;

        }
        
        System.runAs(portalUser) {
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.portalUserId = testUser.Id;
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
    
            // ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            OSM_SW_CyberSourcePayment.getCybersourceHostedFormData(objRemotCtx);
            //OSM_SW_CybersourceHostedPageDataFields cyberObj=new OSM_SW_CybersourceHostedPageDataFields();
            //OSM_SW_CyberSourcePayment.populateSignatureData(cyberObj);
            
            String successResponse='{"reason_code":"203","decision":"DECLINED","accountBalance":"70","ownerMerchantID":"bams_cummins","auth_avs_code":"X","payment_token":"","auth_code":"888888","req_card_type":"001","req_card_expiry_date":"03/2019","req_amount":"334","auth_trans_ref_no":"test"}';
            OSM_SW_CyberSourcePayment.processCybersourceResponse(objRemotCtx,successResponse);
            
            Map<String, Object> parametersFromBAMS = new Map<String, Object>();
            
            try{
                parametersFromBAMS.put('signed_field_names','abc:abc,xyz:xyz');
                OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
            }catch(exception ex){}
            
            try{
                parametersFromBAMS.put('signed_field_names',null);
                OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
            }catch(exception ex){}
        }
    }
    static testMethod void invalidVerificationNumberTest() {
        
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';

        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';


        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';

        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';


        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';


        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        //For remote action context 

        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1].Id;
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
        User portalUser = new User(Alias = 'botman',
                                    Lastname = 'Wayneo',
                                    Firstname = 'Bruceo',
                                    LocaleSidKey = 'en_US',
                                    ProfileId = profile1.Id,
                                    EmailEncodingKey = 'UTF-8',
                                    UserRoleId = portalRole.Id,
                                    LanguageLocaleKey = 'en_US',
                                    Username = 'test20046@test.com',
                                    TimeZoneSidKey = 'America/Chicago',
                                    Email = 'bruce.wayne0@wayneenterprises.com'
        );
        
        Database.insert(portalUser);
        
        Account portalAccount = new Account(Name = 'TestAccount2',
                                            OwnerId = portalUser.Id,
                                            BMS_Customer_ID__c = '1234',
                                            OSM_Preferred_Payment_Method__c = 'po',
                                            OSM_Preferred_Payment_IsBolt_PO__c = false,
                                            OSM_Preferred_Billing_Frequency_Lock__c = false);
                                            
        System.runAs(portalUser) {
            Database.insert(portalAccount);
        }

        //Create contact
        Contact contact1 = new Contact(FirstName = 'Test',
                                        Lastname = 'McTesty',
                                        Email = 'test@test.com',
                                        AccountId = portalAccount.Id,
                                        IAM_Contact_Status__c = 'Pending',
                                        Username__c = 'testUserName7789@gmail.com');
        
        System.runAs(portalUser) {
            Database.insert(contact1);
        }

        User testUser = new User();
        testUser.Alias = 'botmon';
        testUser.isActive = true;
        testUser.LastName = 'lasttt';
        testUser.FirstName = 'Testttt';
        testUser.LocaleSidKey = 'en_US';
        testUser.ContactId = contact1.Id;
        testUser.LanguageLocaleKey = 'en_US';
        testUser.UserName = 'test2@test.com';
        testUser.ProfileId = portal_PROFILE_ID;
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.CommunityNickname = 'test12345h';
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.Email = 'bruce.wayne@wayneenterprises.com';
        
        System.runAs(portalUser) {
            insert testUser;

        }
        
        System.runAs(portalUser) {
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.portalUserId = testUser.Id;
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
    
            // ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            OSM_SW_CyberSourcePayment.getCybersourceHostedFormData(objRemotCtx);
            //OSM_SW_CybersourceHostedPageDataFields cyberObj=new OSM_SW_CybersourceHostedPageDataFields();
            //OSM_SW_CyberSourcePayment.populateSignatureData(cyberObj);
            
            String successResponse='{"reason_code":"211","decision":"DECLINED","accountBalance":"70","ownerMerchantID":"bams_cummins","auth_avs_code":"X","payment_token":"","auth_code":"888888","req_card_type":"001","req_card_expiry_date":"03/2019","req_amount":"334","auth_trans_ref_no":"test"}';
            OSM_SW_CyberSourcePayment.processCybersourceResponse(objRemotCtx,successResponse);
            
            Map<String, Object> parametersFromBAMS = new Map<String, Object>();
            
            try{
                parametersFromBAMS.put('signed_field_names','abc:abc,xyz:xyz');
                OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
            }catch(exception ex){}
            
            try{
                parametersFromBAMS.put('signed_field_names',null);
                OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
            }catch(exception ex){}
        }
    }
}