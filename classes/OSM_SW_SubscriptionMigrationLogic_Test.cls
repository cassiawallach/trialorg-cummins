@isTest
//Updated By Sangeeta on 09/07/2021
//Updated by Raju on 11/23/2021 for MP-341
public class OSM_SW_SubscriptionMigrationLogic_Test {
    
    @testSetup static void testData() {
    
    List<ccrz__E_AccountGroup__c> accountGrpList = new List<ccrz__E_AccountGroup__c>();
        
        ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c();
        accGrp.Name = 'US/CAN_EBU_SIR_ACCGRP';
        accountGrpList.add(accGrp);
        
        ccrz__E_AccountGroup__c accGrp1 = new ccrz__E_AccountGroup__c();
        accGrp1.Name = 'US/CAN_CMI_Deal_FS_HHP_DEF_ACCGRP';
        accountGrpList.add(accGrp1);
        
        ccrz__E_AccountGroup__c accGrp2 = new ccrz__E_AccountGroup__c();
        accGrp2.Name = 'US/CAN_EBU_Deal_FS_HHP_DEF_ACCGRP';
        accountGrpList.add(accGrp2);
        
        insert accountGrpList;
        
        //creating test Account for Dealer...
        Account testaccount = new Account();
        testAccount.type = 'Dealer';
        testAccount.Name = 'testacc';
        testAccount.BillingState = '';
        testAccount.BillingCity = 'City';
        testAccount.CMI_Region__c = 'India';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingPostalCode = '11000';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingCountry = 'United States';
        testAccount.CSS_Locale__c = 'English(India)';
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.ccrz__E_AccountGroup__c=accGrp1.Id;
        insert testAccount;

         Account testaccount3 = new Account();
        testAccount3.type = 'Dealer';
        testAccount3.Name = 'testacc3';
        testAccount3.BillingState = '';
        testAccount3.BillingCity = 'City';
        testAccount3.CMI_Region__c = 'India';
        testAccount3.BillingStreet = 'Street';
        testAccount3.BillingPostalCode = '11000';
        testAccount3.BOLT_Account_Number__c = '999';
        testAccount3.BillingCountry = 'United States';
        testAccount3.CSS_Locale__c = 'English(India)';
        testAccount3.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testAccount3.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount3.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount3.ccrz__E_AccountGroup__c=accGrp1.Id;
        insert testAccount3;

        //creating test Account for Distributor...
        Account testaccount2 = new Account();
        testAccount2.Name = 'testacc';
        testAccount2.BillingState = '';
        testAccount2.BillingCity = 'City';
        testAccount2.CMI_Region__c = 'India';
        testAccount2.BillingStreet = 'Street';
        testAccount2.BillingPostalCode = '11000';
        testAccount2.type = 'Distributor Account';
        testAccount2.BOLT_Account_Number__c = '999';
        testAccount2.BillingCountry = 'United States';
        testAccount2.CSS_Locale__c = 'English(India)';
        testAccount2.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testAccount2.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount2.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount2.ccrz__E_AccountGroup__c=accGrp2.Id;
        insert testAccount2;
        
         ccrz__E_Product__c prod = new ccrz__E_Product__c();
            prod.name = 'Connected Advisor';
            prod.ccrz__SKU__c = '15458776';
            prod.ccrz__Quantityperunit__c = 3343;
            prod.ccrz__StartDate__c = system.today();
            prod.ccrz__EndDate__c = system.today()+1;
            prod.ccrz__ShortDesc__c = 'testing';
            insert prod;
        
        //creating coupon code..
        ccrz__E_Coupon__c co = new ccrz__E_Coupon__c();
        co.ccrz__MaxUse__c = 1;
        co.ccrz__TotalUsed__c = 1;
        co.ccrz__CouponName__c = '25OFF';
        co.ccrz__CouponCode__c = '25OFF';
        co.ccrz__DiscountAmount__c = 10.00;
        co.ccrz__CouponType__c='Absolute';
        co.ccrz__DiscountType__c='Absolute';
        co.ccrz__RuleType__c='General';
        co.ccrz__TargetProduct__c=prod.Id;
        co.ccrz__TargetQty__c=1;
        co.ccrz__TargetRelation__c = 'Product';
        co.ccrz__Storefront__c='SoftwareStore';
        insert co;
    }
    
    Static TestMethod Void testMethodScenarioA() {
        
        Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
        Account objAccDistributor = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Distributor Account' limit 1];
        
        //cretaing existing sub data for dealer...
        OSM_Existing_Subscription__c existSub = new OSM_Existing_Subscription__c();
        existSub.Product_Name__c = 'INSITE';
        existSub.Account__c = objAccDealer.id;
        existSub.End_Date__c = system.today().addDays(-2);
        existSub.Start_Date__c = system.today().addDays(-5);
        insert existSub;
        
        OSM_Existing_Subscription__c existSub2 = new OSM_Existing_Subscription__c();
        existSub2.Product_Name__c = 'QSOL';
        existSub2.Account__c = objAccDealer.id;
        existSub2.End_Date__c = system.today().addDays(-3);
        existSub2.Start_Date__c = system.today().addDays(-5);
        existSub2.Renewal_Date__c = system.today().addDays(-2);
        insert existSub2;
        
        //cretaing existing sub data for distributor...
        OSM_Existing_Subscription__c existSub3 = new OSM_Existing_Subscription__c();
        existSub3.Product_Name__c = 'QSOL';
        existSub3.Account__c = objAccDistributor.id;
        existSub3.End_Date__c = system.today().addDays(-2);
        existSub3.Start_Date__c = system.today().addDays(-5);
        existSub3.Renewal_Date__c = system.today().addDays(-2);
        insert existSub3;
        
        OSM_Existing_Subscription__c existSub4 = new OSM_Existing_Subscription__c();
        existSub4.Product_Name__c = 'INSITE';
        existSub4.Account__c = objAccDistributor.id;
        existSub4.End_Date__c = system.today().addDays(-3);
        existSub4.Start_Date__c = system.today().addDays(-5);
        insert existSub4;
        
      
        
        List<OSM_HHP_Dealers_For_Migration__c> hhlst=new List<OSM_HHP_Dealers_For_Migration__c>();
        OSM_HHP_Dealers_For_Migration__c hh=new OSM_HHP_Dealers_For_Migration__c();
        hh.Account_Group_Name__c='US/CAN_CMI_Deal_FS_HHP_DEF_ACCGRP'; hh.name='US/CAN_CMI_Deal_FS_HHP_DEF_ACCGRP';
        OSM_HHP_Dealers_For_Migration__c hh1=new OSM_HHP_Dealers_For_Migration__c();
        hh1.Account_Group_Name__c='US/CAN_EBU_Deal_FS_HHP_DEF_ACCGRP'; hh1.name='US/CAN_EBU_Deal_FS_HHP_DEF_ACCGRP';
        hhlst.add(hh);
        hhlst.add(hh1);
        insert hhlst;
        
     
        
        Test.StartTest();
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer( new Map<Id, Account>{objAccDealer.id => objAccDealer });
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDistributors(new Map<Id, Account>{objAccDistributor.id => objAccDistributor});
        Test.stopTest();
       
        
    }
     Static TestMethod Void testMethodScenarioSameDate() {
        
        Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE Name = 'testacc3' limit 1];
        
        OSM_Existing_Subscription__c existSub5 = new OSM_Existing_Subscription__c();
        existSub5.Product_Name__c = 'INSITE';
        existSub5.Account__c =  objAccDealer.id;
        existSub5.End_Date__c = system.today().addDays(2);
        existSub5.Start_Date__c = system.today().addDays(-5);
        insert existSub5;
        
        OSM_Existing_Subscription__c existSub6 = new OSM_Existing_Subscription__c();
        existSub6.Product_Name__c = 'QSOL';
        existSub6.Account__c =  objAccDealer.id;
        existSub6.End_Date__c = system.today().addDays(2);
        existSub6.Start_Date__c = system.today().addDays(-5);
        existSub6.Renewal_Date__c = system.today().addDays(2);
        insert existSub6;
         Test.startTest();
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer( new Map<Id, Account>{objAccDealer.id => objAccDealer});
       
        
        Test.stopTest();
        }
    
    Static TestMethod Void testMethodScenarioB() {
        
        Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
        Account objAccDistributor = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Distributor Account' limit 1];
       
        List<OSM_HHP_Dealers_For_Migration__c> hhlst=new List<OSM_HHP_Dealers_For_Migration__c>();
        OSM_HHP_Dealers_For_Migration__c hh=new OSM_HHP_Dealers_For_Migration__c();
        hh.Account_Group_Name__c='US/CAN_CMI_Deal_FS_HHP_DEF_ACCGRP'; hh.name='US/CAN_CMI_Deal_FS_HHP_DEF_ACCGRP';
        OSM_HHP_Dealers_For_Migration__c hh1=new OSM_HHP_Dealers_For_Migration__c();
        hh1.Account_Group_Name__c='US/CAN_EBU_Deal_FS_HHP_DEF_ACCGRP'; hh1.name='US/CAN_EBU_Deal_FS_HHP_DEF_ACCGRP';
        hhlst.add(hh);
        hhlst.add(hh1);
        insert hhlst;
         
        //cretaing existing sub data for dealer...
        OSM_Existing_Subscription__c existSub = new OSM_Existing_Subscription__c();

        existSub.Product_Name__c = 'INSITE';
        existSub.Account__c = objAccDealer.id;
        existSub.End_Date__c = system.today().addDays(2);
        existSub.Start_Date__c = system.today().addDays(-5);
        insert existSub;
        
        OSM_Existing_Subscription__c existSub2 = new OSM_Existing_Subscription__c();
        existSub2.Product_Name__c = 'QSOL';
        existSub2.Account__c = objAccDealer.id;
        existSub2.End_Date__c = system.today().addDays(-3);
        existSub2.Start_Date__c = system.today().addDays(-5);
        existSub2.Renewal_Date__c = system.today().addDays(-2);
        insert existSub2;
        
        //cretaing existing sub data for distributor...
        OSM_Existing_Subscription__c existSub3 = new OSM_Existing_Subscription__c();
        existSub3.Product_Name__c = 'QSOL';
        existSub3.Account__c = objAccDistributor.id;
        existSub3.End_Date__c = system.today().addDays(-2);
        existSub3.Start_Date__c = system.today().addDays(-5);
        existSub3.Renewal_Date__c = system.today().addDays(-2);
        insert existSub3;
        
        OSM_Existing_Subscription__c existSub4 = new OSM_Existing_Subscription__c();
        existSub4.Product_Name__c = 'INSITE';
        existSub4.Account__c = objAccDistributor.id;
        existSub4.End_Date__c = system.today().addDays(3);
        existSub4.Start_Date__c = system.today().addDays(-5);
        insert existSub4;
                
        Test.startTest();
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer( new Map<Id, Account>{objAccDealer.id => objAccDealer });
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDistributors(new Map<Id, Account>{objAccDistributor.id => objAccDistributor});
        
        Test.stopTest();
        
    }
    
    Static TestMethod Void testMethodScenarioC() {
        
        Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
        Account objAccDistributor = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Distributor Account' limit 1];
        
         List<OSM_HHP_Dealers_For_Migration__c> hhlst=new List<OSM_HHP_Dealers_For_Migration__c>();
        OSM_HHP_Dealers_For_Migration__c hh=new OSM_HHP_Dealers_For_Migration__c();
        hh.Account_Group_Name__c='US/CAN_CMI_Deal_FS_HHP_DEF_ACCGRP'; hh.name='US/CAN_CMI_Deal_FS_HHP_DEF_ACCGRP';
        OSM_HHP_Dealers_For_Migration__c hh1=new OSM_HHP_Dealers_For_Migration__c();
        hh1.Account_Group_Name__c='US/CAN_EBU_Deal_FS_HHP_DEF_ACCGRP'; hh1.name='US/CAN_EBU_Deal_FS_HHP_DEF_ACCGRP';
        hhlst.add(hh);
        hhlst.add(hh1);
        insert hhlst;
        
        //cretaing existing sub data for dealer...
        OSM_Existing_Subscription__c existSub = new OSM_Existing_Subscription__c();

        existSub.Product_Name__c = 'INSITE';
        existSub.Account__c = objAccDealer.id;
        existSub.End_Date__c = system.today().addDays(-2);
        existSub.Start_Date__c = system.today().addDays(-5);
        insert existSub;
        
        OSM_Existing_Subscription__c existSub2 = new OSM_Existing_Subscription__c();
        existSub2.Product_Name__c = 'QSOL';
        existSub2.Account__c = objAccDealer.id;
        existSub2.End_Date__c = system.today().addDays(-3);
        existSub2.Start_Date__c = system.today().addDays(-5);
        existSub2.Renewal_Date__c = system.today().addDays(2);
        insert existSub2;
        
        //cretaing existing sub data for distributor...
        OSM_Existing_Subscription__c existSub3 = new OSM_Existing_Subscription__c();
        existSub3.Product_Name__c = 'QSOL';
        existSub3.Account__c = objAccDistributor.id;
        existSub3.End_Date__c = system.today().addDays(-2);
        existSub3.Start_Date__c = system.today().addDays(-5);
        existSub3.Renewal_Date__c = system.today().addDays(2);
        insert existSub3;
        
        OSM_Existing_Subscription__c existSub4 = new OSM_Existing_Subscription__c();
        existSub4.Product_Name__c = 'INSITE';
        existSub4.Account__c = objAccDistributor.id;
        existSub4.End_Date__c = system.today().addDays(-3);
        existSub4.Start_Date__c = system.today().addDays(-5);
        insert existSub4;
        
        Test.startTest();
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer( new Map<Id, Account>{objAccDealer.id => objAccDealer });
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDistributors(new Map<Id, Account>{objAccDistributor.id => objAccDistributor});
        
        Test.stopTest();
        
    }
    
    Static TestMethod Void testMethodScenarioD() {
        
        Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
        Account objAccDistributor = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Distributor Account' limit 1];
        
         List<OSM_HHP_Dealers_For_Migration__c> hhlst=new List<OSM_HHP_Dealers_For_Migration__c>();
        OSM_HHP_Dealers_For_Migration__c hh=new OSM_HHP_Dealers_For_Migration__c();
        hh.Account_Group_Name__c='US/CAN_CMI_Deal_FS_HHP_DEF_ACCGRP'; hh.name='US/CAN_CMI_Deal_FS_HHP_DEF_ACCGRP';
        OSM_HHP_Dealers_For_Migration__c hh1=new OSM_HHP_Dealers_For_Migration__c();
        hh1.Account_Group_Name__c='US/CAN_EBU_Deal_FS_HHP_DEF_ACCGRP'; hh1.name='US/CAN_EBU_Deal_FS_HHP_DEF_ACCGRP';
        hhlst.add(hh);
        hhlst.add(hh1);
        insert hhlst;
        
        //cretaing existing sub data for dealer...
        OSM_Existing_Subscription__c existSub = new OSM_Existing_Subscription__c();

        existSub.Product_Name__c = 'INSITE';
        existSub.Account__c = objAccDealer.id;
        existSub.End_Date__c = system.today().addDays(3);
        existSub.Start_Date__c = system.today().addDays(-5);
        insert existSub;
        
        OSM_Existing_Subscription__c existSub2 = new OSM_Existing_Subscription__c();
        existSub2.Product_Name__c = 'QSOL';
        existSub2.Account__c = objAccDealer.id;
        existSub2.End_Date__c = system.today().addDays(-3);
        existSub2.Start_Date__c = system.today().addDays(-5);
        existSub2.Renewal_Date__c = system.today().addDays(2);
        insert existSub2;
        
        //cretaing existing sub data for distributor...
        OSM_Existing_Subscription__c existSub3 = new OSM_Existing_Subscription__c();
        existSub3.Product_Name__c = 'QSOL';
        existSub3.Account__c = objAccDistributor.id;
        existSub3.End_Date__c = system.today().addDays(-2);
        existSub3.Start_Date__c = system.today().addDays(-5);
        existSub3.Renewal_Date__c = system.today().addDays(2);
        insert existSub3;
        
        OSM_Existing_Subscription__c existSub4 = new OSM_Existing_Subscription__c();
        existSub4.Product_Name__c = 'INSITE';
        existSub4.Account__c = objAccDistributor.id;
        existSub4.End_Date__c = system.today().addDays(3);
        existSub4.Start_Date__c = system.today().addDays(-5);
        insert existSub4;
        
        Test.startTest();
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer( new Map<Id, Account>{objAccDealer.id => objAccDealer });
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDistributors(new Map<Id, Account>{objAccDistributor.id => objAccDistributor});
        
        Test.stopTest();
        
    }
    
    Static TestMethod Void testMethodScenarioE() {
        
        Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
        Account objAccDistributor = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Distributor Account' limit 1];
        
        //cretaing existing sub data for dealer...
        OSM_Existing_Subscription__c existSub = new OSM_Existing_Subscription__c();

        existSub.Product_Name__c = 'INSITE';
        existSub.Account__c = objAccDealer.id;
        existSub.End_Date__c = system.today().addDays(2);
        existSub.Start_Date__c = system.today().addDays(-5);
        insert existSub;
        
        OSM_Existing_Subscription__c existSub2 = new OSM_Existing_Subscription__c();
        existSub2.Product_Name__c = 'QSOL';
        existSub2.Account__c = objAccDealer.id;
        existSub2.End_Date__c = system.today().addDays(-3);
        existSub2.Start_Date__c = system.today().addDays(-5);
        existSub2.Renewal_Date__c = system.today().addDays(3);
        insert existSub2;
        
        //cretaing existing sub data for distributor...
        OSM_Existing_Subscription__c existSub3 = new OSM_Existing_Subscription__c();
        existSub3.Product_Name__c = 'QSOL';
        existSub3.Account__c = objAccDistributor.id;
        existSub3.End_Date__c = system.today().addDays(-2);
        existSub3.Start_Date__c = system.today().addDays(-5);
        existSub3.Renewal_Date__c = system.today().addDays(2);
        insert existSub3;
        
        OSM_Existing_Subscription__c existSub4 = new OSM_Existing_Subscription__c();
        existSub4.Product_Name__c = 'INSITE';
        existSub4.Account__c = objAccDistributor.id;
        existSub4.End_Date__c = system.today().addDays(1);
        existSub4.Start_Date__c = system.today().addDays(-5);
        insert existSub4;
        
        Test.startTest();
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer( new Map<Id, Account>{objAccDealer.id => objAccDealer });
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDistributors(new Map<Id, Account>{objAccDistributor.id => objAccDistributor});
        
        Test.stopTest();
        
    }
    
    Static TestMethod Void testMethodScenarioDealerF() {
        
        Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
        //Account objAccDistributor = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Distributor Account' limit 1];
        
        //cretaing existing sub data for dealer...
        OSM_Existing_Subscription__c existSub = new OSM_Existing_Subscription__c();

        
        OSM_Existing_Subscription__c existSub2 = new OSM_Existing_Subscription__c();
        existSub2.Product_Name__c = 'QSOL';
        existSub2.Account__c = objAccDealer.id;
        existSub2.End_Date__c = system.today().addDays(-3);
        existSub2.Start_Date__c = system.today().addDays(-5);
        existSub2.Renewal_Date__c = system.today().addDays(3);
        insert existSub2;

        
        Test.startTest();
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer( new Map<Id, Account>{objAccDealer.id => objAccDealer });
        //OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDistributors(new Map<Id, Account>{objAccDistributor.id => objAccDistributor});
        
        Test.stopTest();
        
    }
    
    Static TestMethod Void testMethodScenarioElseC() {
        
        Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
        Account objAccDistributor = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Distributor Account' limit 1];
        
        //cretaing existing sub data for dealer...
        OSM_Existing_Subscription__c existSub = new OSM_Existing_Subscription__c();

        existSub.Product_Name__c = 'INSITE';
        existSub.Account__c = objAccDealer.id;
        existSub.End_Date__c = system.today().addDays(-2);
        existSub.Start_Date__c = system.today().addDays(-5);
        insert existSub;
        
        OSM_Existing_Subscription__c existSub2 = new OSM_Existing_Subscription__c();
        existSub2.Product_Name__c = 'QSOL';
        existSub2.Account__c = objAccDealer.id;
        existSub2.End_Date__c = system.today().addDays(-3);
        existSub2.Start_Date__c = system.today().addDays(-5);
        //existSub2.Registration_Date__c = system.today().addMonths(1);
        existSub2.Registration_Date__c = system.today().addDays(-1);
        insert existSub2;
        
        //cretaing existing sub data for distributor...
        OSM_Existing_Subscription__c existSub3 = new OSM_Existing_Subscription__c();
        existSub3.Product_Name__c = 'QSOL';
        existSub3.Account__c = objAccDistributor.id;
        existSub3.End_Date__c = system.today().addDays(-2);
        existSub3.Start_Date__c = system.today().addDays(-5);
        existSub3.Registration_Date__c = system.today().addMonths(1);
        insert existSub3;
        
        OSM_Existing_Subscription__c existSub4 = new OSM_Existing_Subscription__c();
        existSub4.Product_Name__c = 'INSITE';
        existSub4.Account__c = objAccDistributor.id;
        existSub4.End_Date__c = system.today().addDays(-1);
        existSub4.Start_Date__c = system.today().addDays(-5);
        insert existSub4;
        
        Test.startTest();
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer( new Map<Id, Account>{objAccDealer.id => objAccDealer });
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDistributors(new Map<Id, Account>{objAccDistributor.id => objAccDistributor});
        
        Test.stopTest();
        
    }
    
    Static TestMethod Void testMethodScenarioElseE() {
        
        Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
        Account objAccDistributor = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Distributor Account' limit 1];
        
        //cretaing existing sub data for dealer...
        OSM_Existing_Subscription__c existSub = new OSM_Existing_Subscription__c();

        existSub.Product_Name__c = 'INSITE';
        existSub.Account__c = objAccDealer.id;
        existSub.End_Date__c = system.today().addDays(2);
        existSub.Start_Date__c = system.today().addDays(-5);
        insert existSub;
        
        OSM_Existing_Subscription__c existSub2 = new OSM_Existing_Subscription__c();
        existSub2.Product_Name__c = 'QSOL';
        existSub2.Account__c = objAccDealer.id;
        existSub2.End_Date__c = system.today().addDays(-3);
        existSub2.Start_Date__c = system.today().addDays(-5);
        //existSub2.Registration_Date__c = system.today().addMonths(1);
        existSub2.Registration_Date__c = system.today().addDays(-1);
        insert existSub2;
        
        //cretaing existing sub data for distributor...
        OSM_Existing_Subscription__c existSub3 = new OSM_Existing_Subscription__c();
        existSub3.Product_Name__c = 'QSOL';
        existSub3.Account__c = objAccDistributor.id;
        existSub3.End_Date__c = system.today().addDays(-2);
        existSub3.Start_Date__c = system.today().addDays(-5);
        existSub3.Registration_Date__c = system.today().addMonths(1);
        insert existSub3;
        
        OSM_Existing_Subscription__c existSub4 = new OSM_Existing_Subscription__c();
        existSub4.Product_Name__c = 'INSITE';
        existSub4.Account__c = objAccDistributor.id;
        existSub4.End_Date__c = system.today().addDays(1);
        existSub4.Start_Date__c = system.today().addDays(-5);
        insert existSub4;
        
        Test.startTest();
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer( new Map<Id, Account>{objAccDealer.id => objAccDealer });
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDistributors(new Map<Id, Account>{objAccDistributor.id => objAccDistributor});
        
        Test.stopTest();
        
    }
    
    Static TestMethod Void testMethodScenarioElseD() {
        
        Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
        
        //cretaing existing sub data for dealer...
        OSM_Existing_Subscription__c existSub = new OSM_Existing_Subscription__c();

        existSub.Product_Name__c = 'INSITE';
        existSub.Account__c = objAccDealer.id;
        existSub.End_Date__c = system.today().addMonths(2);
        existSub.Start_Date__c = system.today().addDays(-5);
        insert existSub;
        
        OSM_Existing_Subscription__c existSub2 = new OSM_Existing_Subscription__c();
        existSub2.Product_Name__c = 'QSOL';
        existSub2.Account__c = objAccDealer.id;
        existSub2.End_Date__c = system.today().addDays(-3);
        existSub2.Start_Date__c = system.today().addDays(-5);
        existSub2.Registration_Date__c = system.today().addMonths(1);
        insert existSub2;
        
        Test.startTest();
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer( new Map<Id, Account>{objAccDealer.id => objAccDealer});
        
        Test.stopTest();
        
    }
     Static TestMethod Void testMethodScenarioF() {
        
        //Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
        Account objAccDistributor = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Distributor Account' limit 1];
        
        
        
        //cretaing existing sub data for distributor...
        OSM_Existing_Subscription__c existSub3 = new OSM_Existing_Subscription__c();
        existSub3.Product_Name__c = 'QSOL';
        existSub3.Account__c = objAccDistributor.id;
        existSub3.End_Date__c = system.today().addDays(+5);
        existSub3.Start_Date__c = system.today().addDays(-5);
        existSub3.Registration_Date__c = system.today().addDays(-5);
        //existSub3.Renewal_Date__c=system.today().addDays(-5);
        insert existSub3;
        
        OSM_Existing_Subscription__c existSub = new OSM_Existing_Subscription__c();
        existSub.Product_Name__c = 'INSITE';
        existSub.Account__c = objAccDistributor.id;
        existSub.End_Date__c = system.today().addMonths(-1);
        existSub.Start_Date__c = system.today().addDays(-5);
        insert existSub;
        
        Test.startTest();
        
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDistributors(new Map<Id, Account>{objAccDistributor.id => objAccDistributor});
        
        Test.stopTest();
        
    }
    Static TestMethod Void testMethodScenarioG() {
        
        //Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
        Account objAccDistributor = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Distributor Account' limit 1];
        
        
        
        //cretaing existing sub data for distributor...
        OSM_Existing_Subscription__c existSub3 = new OSM_Existing_Subscription__c();
        existSub3.Product_Name__c = 'QSOL';
        existSub3.Account__c = objAccDistributor.id;
        existSub3.End_Date__c = system.today().addDays(+5);
        existSub3.Start_Date__c = system.today().addDays(-5);
        existSub3.Registration_Date__c = system.today();
        //existSub3.Renewal_Date__c=system.today().addDays(-5);
        insert existSub3;
        
        OSM_Existing_Subscription__c existSub = new OSM_Existing_Subscription__c();
        existSub.Product_Name__c = 'INSITE';
        existSub.Account__c = objAccDistributor.id;
        existSub.End_Date__c = system.today().addMonths(+2);
        existSub.Start_Date__c = system.today().addDays(-5);
        insert existSub;
        
        Test.startTest();
        
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDistributors(new Map<Id, Account>{objAccDistributor.id => objAccDistributor});
        
        Test.stopTest();
        
    }
    Static TestMethod Void testMethodScenarioH() {
        
        //Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
        Account objAccDistributor = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Distributor Account' limit 1];
        
        
        
        //cretaing existing sub data for distributor...
        OSM_Existing_Subscription__c existSub3 = new OSM_Existing_Subscription__c();
        existSub3.Product_Name__c = 'QSOL';
        existSub3.Account__c = objAccDistributor.id;
        existSub3.End_Date__c = system.today().addDays(+5);
        existSub3.Start_Date__c = system.today().addDays(-5);
        existSub3.Registration_Date__c = system.today().addMonths(+1);
        //existSub3.Renewal_Date__c=system.today().addDays(-5);
        insert existSub3; 
        
        OSM_Existing_Subscription__c existSub = new OSM_Existing_Subscription__c();
        existSub.Product_Name__c = 'INSITE';
        existSub.Account__c = objAccDistributor.id;
        existSub.End_Date__c = system.today().addMonths(+3);
        existSub.Start_Date__c = system.today().addDays(-5);
        insert existSub;
        
        Test.startTest();
        
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDistributors(new Map<Id, Account>{objAccDistributor.id => objAccDistributor});
        
        Test.stopTest();
        
    }
    
    Static TestMethod Void testMethodScenarioF_dealer() {        
        Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
       // Account objAccDistributor = [SELECT Id FROM Account WHERE type = 'Distributor Account' limit 1];
        
        
        
        //cretaing existing sub data for distributor...
        OSM_Existing_Subscription__c existSub3 = new OSM_Existing_Subscription__c();
        existSub3.Product_Name__c = 'QSOL';
        existSub3.Account__c = objAccDealer.id;
        existSub3.End_Date__c = system.today().addDays(+5);
        existSub3.Start_Date__c = system.today().addDays(-5);
        existSub3.Registration_Date__c = system.today().addDays(-5);
        //existSub3.Renewal_Date__c=system.today().addDays(-5);
        insert existSub3;
        
        OSM_Existing_Subscription__c existSub = new OSM_Existing_Subscription__c();
        existSub.Product_Name__c = 'INSITE';
        existSub.Account__c = objAccDealer.id;
        existSub.End_Date__c = system.today().addMonths(-1);
        existSub.Start_Date__c = system.today().addDays(-5);
        insert existSub;
        
        Test.startTest();
        
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer(new Map<Id, Account>{objAccDealer.id => objAccDealer});
        
        Test.stopTest();
        
    }
     
    Static TestMethod Void testMethodScenarioElseF_dealer() {        
        Account objAccDealer = [SELECT Id, ccrz__E_AccountGroup__r.name FROM Account WHERE type = 'Dealer' limit 1];
       // Account objAccDistributor = [SELECT Id FROM Account WHERE type = 'Distributor Account' limit 1];
        
        
        
        //cretaing existing sub data for distributor...
        OSM_Existing_Subscription__c existSub3 = new OSM_Existing_Subscription__c();
        existSub3.Product_Name__c = 'QSOL';
        existSub3.Account__c = objAccDealer.id;
        existSub3.End_Date__c = system.today().addDays(+5);
        existSub3.Start_Date__c = system.today().addDays(-5);
        //existSub3.Registration_Date__c = system.today().addDays(-5);
        existSub3.Registration_Date__c = system.today().addDays(-1);
        //existSub3.Renewal_Date__c=system.today().addDays(-5);
        insert existSub3;
        
        
        Test.startTest();
        
        
        OSM_SW_SubscriptionMigrationLogic.getCouponCodeforDealer(new Map<Id, Account>{objAccDealer.id => objAccDealer});
        
        Test.stopTest();
        
    }
    
}