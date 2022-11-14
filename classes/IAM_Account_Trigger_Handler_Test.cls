/************************************************************
Name:  IAM_Account_Trigger_Handler_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is handler class of IAM_Account_Trigger_Handler_Test .                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Karthik Raj Golakaram          23/04/2020        INITIAL DEVELOPMENT.
1.1 -    Anupam Adhikari                25/01/2021        Adding comment for Guidanz Automation. 
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
public class IAM_Account_Trigger_Handler_Test {   
     
    static testMethod void testCDHSync1() {
        Test.startTest();
        Account pacc = new Account();
        pacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        pacc.name = 'parentAcc';
        pacc.type = 'Distributor Account';
        insert pacc;
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'test852';
        acc.parentid = pacc.id;
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'test1'; 
        acc.BillingCity = 'Nevada';
        acc.BillingStateCode = 'CA';
        acc.BillingPostalCode = '95959';
        acc.BillingState='California';
        acc.accountSource = 'QSOL';
        acc.CSS_DistributorCode__c='test';
        acc.CSS_DealerCode__c='prash';
        acc.CSS_Timezone__c = '(GMT+03:00) Arabia Standard Time (Asia/Baghdad)';
        acc.CSS_Locale__c = 'Arabic (Iraq)';
        acc.CSS_Language__c = 'Swedish';
        acc.IAM_Service_Provider_Code__c = '123456';
        acc.CMI_Account_Status__c = Label.IAM_Status_Active; //Label.IAM_Inactive_Label;
		acc.Type = 'Dealer Account';        
        insert acc;
        
        List<Account> accList = [SELECT IAM_ECN__c, IAM_CDH_Sync__c, BillingStreet, IAM_Service_Provider_Code__c,
                                 CMI_Account_Status__c FROM Account WHERE Id = :acc.Id];
        if(!accList.isEmpty()) {
            System.debug('#### IAM_ECN__c - '+ accList[0].IAM_ECN__c);
            System.debug('#### IAM_CDH_Sync__c - '+ accList[0].IAM_CDH_Sync__c);
            System.debug('#### BillingStreet - '+ accList[0].BillingStreet);
            System.debug('#### IAM_Service_Provider_Code__c - '+ accList[0].IAM_Service_Provider_Code__c);
            accList[0].IAM_Service_Provider_Code__c = 'C34343';
            accList[0].BillingStreet = 'test2';
            update accList[0];
        }
        Test.stopTest();
    }
    
    static testMethod void testCDHSync2() {
        Test.startTest();
        Account pacc = new Account();
        pacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        pacc.name = 'parentAcc';
        pacc.type = 'Distributor Account';
        insert pacc;
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'test852';
        acc.parentid = pacc.id;
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'test1'; 
        acc.BillingCity = 'Nevada';
        acc.BillingStateCode = 'CA';
        acc.BillingPostalCode = '95959';
        acc.BillingState='California';
        acc.accountSource = 'QSOL';
        acc.CSS_DistributorCode__c='test';
        acc.CSS_DealerCode__c='prash';
        acc.CSS_Timezone__c = '(GMT+03:00) Arabia Standard Time (Asia/Baghdad)';
        acc.CSS_Locale__c = 'Arabic (Iraq)';
        acc.CSS_Language__c = 'Swedish';
        acc.IAM_Service_Provider_Code__c = '123456';
        acc.CMI_Account_Status__c = Label.IAM_Status_Active; //Label.IAM_Inactive_Label;
		acc.Type = 'Dealer Account';        
        insert acc;
        //createAccountSubscription(acc.Id, Label.IAM_OSM_App_Name, 'Distributor Admin');
        List<Account> accList = [SELECT IAM_ECN__c, IAM_CDH_Sync__c, BillingStreet, IAM_Service_Provider_Code__c,
                                 CMI_Account_Status__c FROM Account WHERE Id = :acc.Id];
        IAM_Account_Trigger_Handler.onBeforeInsertOrUpdate(new List<IAM_Application__c>(), true, true, false);    

        if(!accList.isEmpty()) {
            System.debug('#### IAM_ECN__c - '+ accList[0].IAM_ECN__c);
            System.debug('#### IAM_CDH_Sync__c - '+ accList[0].IAM_CDH_Sync__c);
            System.debug('#### BillingStreet - '+ accList[0].BillingStreet);
            System.debug('#### IAM_Service_Provider_Code__c - '+ accList[0].IAM_Service_Provider_Code__c);
            //accList[0].CMI_Account_Status__c = Label.IAM_Status_Active;
            accList[0].BillingStreet = 'test2';
            accList[0].IAM_ECN__c = '123456';
            accList[0].IAM_CDH_Sync__c = true;
            update accList[0];
            System.debug('#### accList[0] updated - '+accList[0]);
        }
        Test.stopTest();
    }
    
    static testMethod void testCDHSync3() {
        Test.startTest();
        Account pacc = new Account();
        pacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        pacc.name = 'parentAcc';
        pacc.type = 'Distributor Account';
        insert pacc;
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'test852';
        acc.parentid = pacc.id;
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'test1'; 
        acc.BillingCity = 'Nevada';
        acc.BillingStateCode = 'CA';
        acc.BillingPostalCode = '95959';
        acc.BillingState='California';
        acc.accountSource = 'QSOL';
        acc.CSS_DistributorCode__c='test';
        acc.CSS_DealerCode__c='prash';
        acc.CSS_Timezone__c = '(GMT+03:00) Arabia Standard Time (Asia/Baghdad)';
        acc.CSS_Locale__c = 'Arabic (Iraq)';
        acc.CSS_Language__c = 'Swedish';
        acc.IAM_Service_Provider_Code__c = '123456';
        acc.CMI_Account_Status__c = Label.IAM_Status_Active; //Label.IAM_Inactive_Label;
		acc.Type = 'Dealer Account';  
        acc.IAM_ECN__c = '123456';  
        acc.IAM_CDH_Sync__c = true;  
        insert acc;
        List<Account> accList = [SELECT IAM_ECN__c, IAM_CDH_Sync__c, BillingStreet, IAM_Service_Provider_Code__c,
                                 CMI_Account_Status__c FROM Account WHERE Id = :acc.Id];
        
        if(!accList.isEmpty()) {
            System.debug('#### IAM_ECN__c - '+ accList[0].IAM_ECN__c);
            System.debug('#### IAM_CDH_Sync__c - '+ accList[0].IAM_CDH_Sync__c);
            System.debug('#### BillingStreet - '+ accList[0].BillingStreet);
            System.debug('#### IAM_Service_Provider_Code__c - '+ accList[0].IAM_Service_Provider_Code__c);
            //accList[0].CMI_Account_Status__c = Label.IAM_Status_Active;
            accList[0].BillingStreet = 'test2';
            update accList[0];
            System.debug('#### accList[0] updated - '+accList[0]);
        }
        Test.stopTest();
    }
    
    static testMethod void testInsertAccount() {
        Test.startTest();
        	createAccount();
        Test.stopTest();
    }
    
    static testMethod void testUpdateAccount() {
        Test.startTest();
        Account acc = createAccount();
        List<Account> accList = [SELECT IAM_ECN__c, IAM_CDH_Sync__c, BillingStreet, IAM_Service_Provider_Code__c,
                                 CMI_Account_Status__c FROM Account WHERE Id = :acc.Id];
        if(!accList.isEmpty()) {
            accList[0].BillingStreet = 'test2';
            accList[0].IAM_ECN__c = '123456';
            accList[0].IAM_CDH_Sync__c = true;
            update accList[0];
            System.debug('#### accList[0] updated - '+accList[0]);
        }
        Test.stopTest();
    }
    
    static testMethod void dummyTest1() {
        Test.startTest();
        try {
            List<Account> accToInsertList = new List<Account>();
            Account acc = new Account();
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
            acc.name = 'test852';
            acc.BillingCountryCode = 'US';
            acc.BillingStreet = 'test1'; 
            acc.BillingCity = 'Nevada';
            acc.BillingStateCode = 'CA';
            acc.BillingPostalCode = '95959';
            acc.BillingState='California';
            acc.accountSource = 'QSOL';
            acc.IAM_Service_Provider_Code__c = '123456';
            acc.CMI_Account_Status__c = Label.IAM_Status_Active; //Label.IAM_Inactive_Label;
            acc.Type = 'Dealer Account';  
            acc.IAM_ECN__c = '123456';  
            acc.IAM_CDH_Sync__c = true;
            accToInsertList.add(acc);
            
            Account acc1 = new Account();
            acc1.Name = 'dummyAcc25';
            acc1.BillingCountryCode = 'US';
            acc1.BillingStreet = 'test1456444'; 
            acc1.BillingCity = 'Test';
            acc1.BillingStateCode = 'CA';
            acc1.BillingPostalCode = '95960';
            acc1.BillingState='California';
            acc1.accountSource = 'QSOL';
            acc1.IAM_Service_Provider_Code__c = '123457';
            acc1.CMI_Account_Status__c = Label.IAM_Status_Active; //Label.IAM_Inactive_Label;
            acc1.Type = 'Dealer Account';  
            acc1.IAM_ECN__c = '123456';  
            acc1.IAM_CDH_Sync__c = true;
            accToInsertList.add(acc1);
            insert accToInsertList;
            List<Account> accList = getAccountList();
            Map<Id, Account> accOldMap = new Map<Id, Account>();
            Map<Id, Account> accNewMap = new Map<Id, Account>();
            List<Account> accNewList = new List<Account>();
            List<Account> accOldList = new List<Account>();
            if(!accList.isEmpty() && accList.size() > 1) {
                accNewList.add(accList[0]);
                accNewMap.put(accList[0].Id, accList[0]);
                accOldList.add(accList[1]);
                accOldMap.put(accList[1].Id, accList[1]);
                IAM_Account_Trigger_Handler.onAfterUpdate(accNewList,accOldList,accNewMap,accOldMap);
            }
        } catch(Exception e) {
            System.debug('#### Error Message - ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    static testMethod void dummyTest2() {
        Test.startTest();
        try {
            List<Account> accToInsertList = new List<Account>();
            Account acc = new Account();
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
            acc.name = 'test852';
            acc.BillingCountryCode = 'US';
            acc.BillingStreet = 'test1'; 
            acc.BillingCity = 'Nevada';
            acc.BillingStateCode = 'CA';
            acc.BillingPostalCode = '95959';
            acc.BillingState='California';
            acc.accountSource = 'QSOL';
            acc.IAM_Service_Provider_Code__c = '123456';
            acc.CMI_Account_Status__c = Label.IAM_Status_Active; //Label.IAM_Inactive_Label;
            acc.Type = 'Dealer Account';  
            acc.IAM_ECN__c = '123456';  
            acc.IAM_CDH_Sync__c = true;
            accToInsertList.add(acc);
            
            Account acc1 = new Account();
            acc1.Name = 'dummyAcc25';
            acc1.BillingCountryCode = 'US';
            acc1.BillingStreet = 'test1456444'; 
            acc1.BillingCity = 'Test';
            acc1.BillingStateCode = 'CA';
            acc1.BillingPostalCode = '95960';
            acc1.BillingState='California';
            acc1.accountSource = 'QSOL';
            acc1.IAM_Service_Provider_Code__c = '123457';
            acc1.CMI_Account_Status__c = Label.IAM_Inactive_Label; //Label.IAM_Inactive_Label;
            acc1.Type = 'Dealer Account';  
            acc1.IAM_ECN__c = '123456';  
            acc1.IAM_CDH_Sync__c = true;
            accToInsertList.add(acc1);
            insert accToInsertList;
            List<Account> accList = getAccountList();
            Map<Id, Account> accOldMap = new Map<Id, Account>();
            Map<Id, Account> accNewMap = new Map<Id, Account>();
            List<Account> accNewList = new List<Account>();
            List<Account> accOldList = new List<Account>();
            if(!accList.isEmpty() && accList.size() > 1) {
                accNewList.add(accList[0]);
                accNewMap.put(accList[0].Id, accList[0]);
                accOldList.add(accList[1]);
                accOldMap.put(accList[1].Id, accList[1]);
                IAM_Account_Trigger_Handler.onAfterUpdate(accNewList,accOldList,accNewMap,accOldMap);
            }
        } catch(Exception e) {
            System.debug('#### Error Message - ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    static testMethod void dummyTest3() {
        Test.startTest();
        try {
            List<Account> accToInsertList = new List<Account>();
            Account acc = new Account();
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
            acc.name = 'test852';
            acc.BillingCountryCode = 'US';
            acc.BillingStreet = 'test1'; 
            acc.BillingCity = 'Nevada';
            acc.BillingStateCode = 'CA';
            acc.BillingPostalCode = '95959';
            acc.BillingState='California';
            acc.accountSource = 'QSOL';
            acc.IAM_Service_Provider_Code__c = '123456';
            acc.CMI_Account_Status__c = Label.IAM_Inactive_Label; //Label.IAM_Inactive_Label;
            acc.Type = 'Dealer Account';  
            acc.IAM_ECN__c = '123456';  
            acc.IAM_CDH_Sync__c = true;
            accToInsertList.add(acc);
            
            Account acc1 = new Account();
            acc1.Name = 'dummyAcc25';
            acc1.BillingCountryCode = 'US';
            acc1.BillingStreet = 'test1456444'; 
            acc1.BillingCity = 'Test';
            acc1.BillingStateCode = 'CA';
            acc1.BillingPostalCode = '95960';
            acc1.BillingState='California';
            acc1.accountSource = 'QSOL';
            acc1.IAM_Service_Provider_Code__c = '123457';
            acc1.CMI_Account_Status__c = Label.IAM_Inactive_Label; //Label.IAM_Inactive_Label;
            acc1.Type = 'Dealer Account';  
            acc1.IAM_ECN__c = '123456';  
            acc1.IAM_CDH_Sync__c = true;
            accToInsertList.add(acc1);
            insert accToInsertList;
            List<Account> accList = getAccountList();
            Map<Id, Account> accOldMap = new Map<Id, Account>();
            Map<Id, Account> accNewMap = new Map<Id, Account>();
            List<Account> accNewList = new List<Account>();
            List<Account> accOldList = new List<Account>();
            if(!accList.isEmpty() && accList.size() > 1) {
                accNewList.add(accList[0]);
                accNewMap.put(accList[0].Id, accList[0]);
                accOldList.add(accList[1]);
                accOldMap.put(accList[1].Id, accList[1]);
                IAM_Account_Trigger_Handler.onAfterUpdate(accNewList,accOldList,accNewMap,accOldMap);
            }
        } catch(Exception e) {
            System.debug('#### Error Message - ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    public static Account createAccount() {
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

        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = '123';
        insert acc;
        return acc;
    }
    
    /* Create and return IAM_Application__c record for given Account -Added by Karthik */
    public static void createAccountSubscription(Id accId, String appName, String appRole) {
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = accId;                
        obj.IAM_Subscription_Start_Date__c = Date.today();
        obj.IAM_Subscription_End_Date__c = Date.today() + 365;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = appName;
        obj.IAM_Role__c = appRole;
        obj.IAM_Status__c = 'Active';
        obj.IAM_Subscription_Name__c = appName;
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
        insert obj;
        System.debug('#### Account access obj '+obj);
    } 
    
    /* Return List of Account */
    public static List<Account> getAccountList() {
        return [SELECT Id, Name, CMI_Address2__c, IAM_ECN__c, IAM_CDH_Sync__c,CMI_Primary_Contact_Phone__c,
         IAM_Verification_code__c, IAM_Verified_Flag__c, BillingStreet, BillingCity,BillingCountryCode,BillingStateCode,
         BillingState, BillingCountry, BillingPostalCode, IAM_Service_Provider_Code__c,
         CMI_Account_Status__c FROM Account WHERE Name = 'test852' OR Name = 'dummyAcc25'];
    }
}