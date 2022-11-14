//Made changes as part of MAR-1530
//Adding comment to include test class to run - MAR-1236
//Adding comment to include test class to run - MAR-1635
//Adding comment to include test class to run - MAR-1648
//Adding comment to include test class to run - MAR-1648 v.2
// updated by singaiah 10/june  
// Updated 08 July Sharad
// Updated 14 July Sharad
// Updated June 8th -MP-733
//

@istest
public class OSM_AutoPopulateAccount_Test {
    public static Account createAccount(String businessUnit, String channelOfDistribution)
    { 
        RecordType recid =[select id from recordType where name='wwsps' limit 1];  
        Account acc = new Account();
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        //acc.CMI_Account_Status__c = 'Active'; //This line is commented
        acc.CMI_CDA_Status__c = 'New Customer Request';
        //acc.BillingCountry  = 'NORTH AMERICA';
        acc.BillingCountry = 'United States';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = businessUnit;
        acc.EBU_Channel_of_Distribution__c = channelOfDistribution;
        system.debug('createAccount'+acc);
        return acc;
        // system.debug('createAccount'+acc);
    }
    
    
    
    public static Account createAccount2(String businessUnit, String channelOfDistribution)
    { 
        
        Account acc = new Account();
        RecordType recid =[select id from recordType where name='wwsps' limit 1];  
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        //acc.CMI_Account_Status__c = 'Active';
        acc.CMI_CDA_Status__c = 'New Customer Request';
        //acc.BillingCountry  = 'NORTH AMERICA';
        acc.BillingCountry = 'United States';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = businessUnit;
        acc.CHANNEL_OF_DISTRIBUTION__c = channelOfDistribution;
        
        return acc;
        //system.debug('createAccount2'+acc);
    }
    
    public static Account createAccount3(String businessUnit, String channelOfDistribution)
    { 
        RecordType recid =[select id from recordType where name='wwsps' limit 1];  
        Account acc = new Account();
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        //acc.CMI_Account_Status__c = 'Active';
        acc.CMI_CDA_Status__c = 'New Customer Request';
        //acc.BillingCountry  = 'NORTH AMERICA';
        acc.BillingCountry = 'United States';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = businessUnit;
        acc.PSBU_Channel_of_Distribution__c = channelOfDistribution;
        
        return acc;
        // system.debug('createAccount3'+acc);
    }
    public static Account createAccount4(String businessUnit, String channelOfDistribution)
    { 
        RecordType recid =[select id from recordType where name='wwsps' limit 1];  
        Account acc = new Account();
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        //acc.CMI_Account_Status__c = 'Active';
        acc.CMI_CDA_Status__c = 'New Customer Request';
        //acc.BillingCountry  = 'NORTH AMERICA';
        acc.BillingCountry = 'United States';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = businessUnit;
        acc.PSBU_Channel_of_Distribution__c = channelOfDistribution;
        acc.EBU_Channel_of_Distribution__c = channelOfDistribution;
        
        return acc;
        // system.debug('createAccount4'+acc);
    }
    
    public static Account createAccount5(String businessUnit, String channelOfDistribution)
    { 
        RecordType recid =[select id from recordType where name='IAM' limit 1];  
        Account acc = new Account();
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        acc.CMI_Account_Status__c = 'Active';
        acc.CMI_CDA_Status__c = 'New Customer Request';
        //acc.BillingCountry  = 'NORTH AMERICA';
        acc.BillingCountry = 'United States';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = businessUnit;
        acc.CHANNEL_OF_DISTRIBUTION__c=channelOfDistribution;
        //acc.PSBU_Channel_of_Distribution__c = channelOfDistribution;
        // acc.EBU_Channel_of_Distribution__c = channelOfDistribution;
        
        return acc;
        // system.debug('createAccount5'+acc);
    }
    public static Account createAccount6(String businessUnit, String channelOfDistribution)
    { 
        RecordType recid =[select id from recordType where name='IAM' limit 1];  
        Account acc = new Account();
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        acc.CMI_Account_Status__c = 'Cancelled';
        acc.CMI_CDA_Status__c = 'New Customer Request';
        //acc.BillingCountry  = 'NORTH AMERICA';
        acc.BillingCountry = 'India';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = businessUnit;
        acc.CHANNEL_OF_DISTRIBUTION__c=channelOfDistribution;
        //acc.IAM_Primary_Market_Segment__c = 'BUS';
        //acc.OSM_Market_Segment_Code__c = 'BUS';
        //acc.PSBU_Channel_of_Distribution__c = channelOfDistribution;
        // acc.EBU_Channel_of_Distribution__c = channelOfDistribution;
        
        return acc;
        // system.debug('createAccount6'+acc);
    }
    
    
    
      public static Account createAccount7(String businessUnit, String channelOfDistribution)
    { 
        
        Account acc = new Account();
        RecordType recid =[select id from recordType where name='IAM' limit 1];  
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        //acc.CMI_Account_Status__c = 'Active';
        acc.CMI_CDA_Status__c = 'New Customer Request';
        acc.IAM_WWSPS_Regions__c  = 'US and Canada';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = businessUnit;
        acc.CHANNEL_OF_DISTRIBUTION__c = channelOfDistribution;
        acc.BillingCountry='India';
        return acc;
        
    }
    
     public static Account createAccount8(String businessUnit, String channelOfDistribution)
    { 
        
        Account acc = new Account();
        RecordType recid =[select id from recordType where name='WWSPS' limit 1];  
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        acc.CMI_Account_Status__c = 'Active';
        acc.CMI_CDA_Status__c = 'New Customer Request';
        acc.IAM_WWSPS_Regions__c  = 'US and Canada';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = businessUnit;
        acc.CHANNEL_OF_DISTRIBUTION__c = channelOfDistribution;
        acc.EBU_Channel_of_Distribution__c = 'DEALER';
        acc.BillingCountry='Canada';
        return acc;
        
    }
    
    
    public static Account createAccount9(String businessUnit, String channelOfDistribution)
    { 
        
        Account acc = new Account();
        RecordType recid =[select id from recordType where name='WWSPS' limit 1];  
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        acc.CMI_Account_Status__c = 'Active';
        acc.CMI_CDA_Status__c = 'New Customer Request';
        acc.IAM_WWSPS_Regions__c  = 'US and Canada';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = businessUnit;
        acc.CHANNEL_OF_DISTRIBUTION__c = channelOfDistribution;
        acc.EBU_Channel_of_Distribution__c = 'DEALER';
        acc.BillingCountry='';
        return acc;
        
    }
    
    public static void createAccountGroup()
    {
        List<ccrz__E_AccountGroup__c> accountGrpList = new List<ccrz__E_AccountGroup__c>();
        
        ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c();
        accGrp.Name = 'US/CAN_EBU_SIR_ACCGRP';//LL37 checking is EBU dist is CAREER CENTERS 9th Aug 2022
        accountGrpList.add(accGrp);
        
        ccrz__E_AccountGroup__c accGrp1 = new ccrz__E_AccountGroup__c();
        accGrp1.Name = 'US/CAN_CMI_Fleet_ACCGRP';
        accountGrpList.add(accGrp1);
        
        ccrz__E_AccountGroup__c accGrp2 = new ccrz__E_AccountGroup__c();
        accGrp2.Name = 'US/CAN_PSBU_Fleet_MIN_ACCGRP';
        accountGrpList.add(accGrp2);
        
        ccrz__E_AccountGroup__c accGrp3 = new ccrz__E_AccountGroup__c();
        accGrp3.Name = 'US/CAN_PSBU_Fleet_BUS_ACCGRP';
        accountGrpList.add(accGrp3);
        
        ccrz__E_AccountGroup__c accGrp4 = new ccrz__E_AccountGroup__c();
        accGrp4.Name = 'US/CAN_PSBU_Fleet_OHT_ACCGRP';
        accountGrpList.add(accGrp4);
        
        ccrz__E_AccountGroup__c accGrp5 = new ccrz__E_AccountGroup__c();
        accGrp5.Name = 'US/CAN_PSBU_Fleet_OHT_ACCGRP';
        accountGrpList.add(accGrp5);
        
        ccrz__E_AccountGroup__c accGrp6 = new ccrz__E_AccountGroup__c();
        accGrp6.Name = 'US/CAN_EBU_Fleet_OHT_ACCGRP';
        accountGrpList.add(accGrp6);
        
        ccrz__E_AccountGroup__c accGrp7 = new ccrz__E_AccountGroup__c();
        accGrp7.Name = 'US/CAN_EBU_Fleet_ACCGRP';
        accountGrpList.add(accGrp7);
        
        ccrz__E_AccountGroup__c accGrp8 = new ccrz__E_AccountGroup__c();
        accGrp8.Name = 'US/CAN_EBU_Fleet_MIN_ACCGRP';
        accountGrpList.add(accGrp8);
        
        ccrz__E_AccountGroup__c accGrp9 = new ccrz__E_AccountGroup__c();
        accGrp9.Name = 'US/CAN_EBU_Fleet_DEF_ACCGRP';
        accountGrpList.add(accGrp9);
        
        ccrz__E_AccountGroup__c accGrp10 = new ccrz__E_AccountGroup__c();
        accGrp10.Name = 'US/CAN_EBU_Fleet_BUS_ACCGRP';
        accountGrpList.add(accGrp10);
        
        ccrz__E_AccountGroup__c accGrp11 = new ccrz__E_AccountGroup__c();
        accGrp11.Name = 'US/CAN_PSBU_Fleet_ACCGRP';
        accountGrpList.add(accGrp11);
        
        ccrz__E_AccountGroup__c accGrp12 = new ccrz__E_AccountGroup__c();
        accGrp12.Name = 'US/CAN_VoTech_ACCGRP';
        accountGrpList.add(accGrp12);
        
        ccrz__E_AccountGroup__c accGrp13 = new ccrz__E_AccountGroup__c();
        accGrp13.Name = 'US/CAN_CMI_Fleet_DEF_ACCGRP';
        accountGrpList.add(accGrp13);
        
        ccrz__E_AccountGroup__c accGrp14 = new ccrz__E_AccountGroup__c();
        accGrp14.Name = 'US/CAN_CMI_Fleet_MIN_ACCGRP';
        accountGrpList.add(accGrp14);
        
        
        ccrz__E_AccountGroup__c accGrp15 = new ccrz__E_AccountGroup__c();
        accGrp15.Name = 'US/CAN_CMI_Fleet_BUS_ACCGRP';
        accountGrpList.add(accGrp15);
        
        ccrz__E_AccountGroup__c accGrp16 = new ccrz__E_AccountGroup__c();
        accGrp16.Name = 'US/CAN_CMI_Fleet_OHT_ACCGRP';
        accountGrpList.add(accGrp16);
        
        ccrz__E_AccountGroup__c accGrp17 = new ccrz__E_AccountGroup__c();
        accGrp17.Name = 'US/CAN_EBU_Deal_DTNA_ACCGRP';
        accountGrpList.add(accGrp17);
        
        ccrz__E_AccountGroup__c accGrp18 = new ccrz__E_AccountGroup__c();
        accGrp18.Name = 'US/CAN_PSBU_Fleet_DEF_ACCGRP';
        accountGrpList.add(accGrp18);
        
        ccrz__E_AccountGroup__c accGrp19 = new ccrz__E_AccountGroup__c();
        accGrp19.Name = 'BUS_GLOBAL_ACCGRP';
        accountGrpList.add(accGrp19);
        
        ccrz__E_AccountGroup__c accGrp23 = new ccrz__E_AccountGroup__c();
        accGrp23.Name = 'SES_Rest_Of_World_BUS_GLOBAL_ACCGRP';
        accountGrpList.add(accGrp23);
        
        ccrz__E_AccountGroup__c accGrp24 = new ccrz__E_AccountGroup__c();
        accGrp24.Name = 'SES_Rest_Of_World_OHT_GLOBAL_ACCGRP';
        accountGrpList.add(accGrp24);
        
        ccrz__E_AccountGroup__c accGrp25 = new ccrz__E_AccountGroup__c();
        accGrp25.Name = 'SES_Rest_Of_World_DEF_GLOBAL_ACCGRP';
        accountGrpList.add(accGrp25);
        
        ccrz__E_AccountGroup__c accGrp20 = new ccrz__E_AccountGroup__c();
        accGrp20.Name = 'SES_Rest_Of_World_MIN_GLOBAL_ACCGRP';
        accountGrpList.add(accGrp20);
        
        ccrz__E_AccountGroup__c accGrp21 = new ccrz__E_AccountGroup__c();
        accGrp21.Name = 'SES_Rest_Of_World_OIL_GLOBAL_ACCGRP';
        accountGrpList.add(accGrp21);
        
        ccrz__E_AccountGroup__c accGrp22 = new ccrz__E_AccountGroup__c();
        accGrp22.Name = 'SES_Rest_Of_World_RAIL_GLOBAL_ACCGRP';
        accountGrpList.add(accGrp22);
        
        insert accountGrpList;
    }
    
    @isTest
    public static void accountGroupMappingTrigger_test()
    {
        createAccountGroup();
        
        List<Account> accountList = new List<Account>();
        Account acc1 = createAccount('EBU','DISTRIBUTOR-BRANCH'); 
        accountList.add(acc1);
        
        Account acc2 = createAccount('EBU', 'FLEET');
        accountList.add(acc2);
        
        Account acc3a = createAccount('EBU','DEALER' );
        accountList.add(acc3a);
        
        Account acc3b = createAccount('EBU','CIHR' );
        accountList.add(acc3b);
        
        insert accountList;
        
        Test.startTest();
        
        OSM_AutoPopulateAccount.updateAccountGroup(accountList);

        List<Account> accforassertList = [SELECT Id,ccrz__E_AccountGroup__r.Name,ccrz__E_AccountGroup__c FROM Account LIMIT 50];
        OSM_AutoPopulateAccount.getCODByAccountRecordType(acc1);
        
        Test.stopTest();
    } 
    @isTest
    public static void accountGroupMappingTrigger_test1()
    {
        createAccountGroup();
        
        List<Account> accountList = new List<Account>();
        
        
        Account acc1 = createAccount2('EBU', Label.COD_CIHR_List.split(',')[0].substring(0,4) + Label.COD_CIHR_List.split(',')[0]); 
        acc1.Type = 'Votech';
        accountList.add(acc1);
        
        // need to add market segment for FLEET
        Account acc2 = createAccount2('EBU', Label.COD_Fleet_List.split(',')[0].substring(0,4) + Label.COD_Fleet_List.split(',')[0]);
        acc2.IAM_Primary_Market_Segment__c = 'Bus';
        acc2.Type = 'Fleet';
        accountList.add(acc2);
        
        
        Account acc3a = createAccount2('EBU', Label.COD_Dealer_List.split(',')[0].substring(0,4) + Label.COD_Dealer_List.split(',')[0]);
        acc3a.OSM_Service_Level__c = 'Lite Repair';
        accountList.add(acc3a);
        
        
        Account acc3b = createAccount2('EBU', Label.COD_Dealer_List.split(',')[0].substring(0,4) + Label.COD_Dealer_List.split(',')[0]);
        acc3b.OSM_Service_Level__c = 'Full Service';
        accountList.add(acc3b);
        
        Account acc4 = createAccount2('EBU', Label.COD_Distributor_List.split(',')[0].substring(0,4) + Label.COD_Distributor_List.split(',')[0]);
        acc4.Type = 'National Account';
        accountList.add(acc4);
        
        Account acc5 = createAccount2('EBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc5.Type = 'National Account';
        acc5.BUSINESS_UNIT__c ='PSBU';
        acc5.IAM_Primary_Market_Segment__c = 'Automotive';
        accountList.add(acc5);
        
        Account acc6 = createAccount2('EBU', '');
        //acc6.CMI_Account_Status__c = 'Inactive';
        acc6.IAM_Primary_Market_Segment__c = 'BUS';
        accountList.add(acc6);
        
        Account acc7 = createAccount2('EBU', Label.COD_JV_SSOEM_List.split(',')[0]);
        acc7.Name = 'Komatsu Test Account';
        acc7.Type = null;
        acc7.IAM_Primary_Market_Segment__c = 'Automotive';
        accountList.add(acc7);
        
        Account acc8 = createAccount2('EBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc8.Type = 'National Account';
        acc8.BUSINESS_UNIT__c ='';
        acc8.CHANNEL_OF_DISTRIBUTION__c = '';
        accountList.add(acc8);
        
        
        Account acc9 = createAccount2('', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc9.Type = 'National Account';
        acc9.BUSINESS_UNIT__c ='';
        acc9.CHANNEL_OF_DISTRIBUTION__c = '';
        accountList.add(acc9);
        
        
        Account acc10 = createAccount2('PSBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc10.Type = 'National Account';
        acc10.BUSINESS_UNIT__c ='';
        acc10.CHANNEL_OF_DISTRIBUTION__c = ''; 
        acc10.IAM_Primary_Market_Segment__c = 'Automotive';
        accountList.add(acc10);
        insert accountList;
        
        Test.startTest();
        
        
        OSM_AutoPopulateAccount.updateAccountGroup(accountList);
        List<Account> accforassertList = [SELECT Id,ccrz__E_AccountGroup__r.Name,ccrz__E_AccountGroup__c FROM Account LIMIT 50];
        
        Test.stopTest();
    }
    
    @isTest
    public static void accountGroupMappingTrigger_test4()
    {
        createAccountGroup();
        
        List<Account> accountList = new List<Account>();
        
        
        Account acc1 = createAccount2('EBU', Label.COD_CIHR_List.split(',')[0].substring(0,4) + Label.COD_CIHR_List.split(',')[0]); 
        acc1.Type = 'Votech';
        accountList.add(acc1);
        
        // need to add market segment for FLEET
        Account acc2 = createAccount2('EBU', Label.COD_Fleet_List.split(',')[0].substring(0,4) + Label.COD_Fleet_List.split(',')[0]);
        acc2.IAM_Primary_Market_Segment__c = 'Bus';
        acc2.Type = 'Fleet';
        accountList.add(acc2);
        
        
        Account acc3a = createAccount2('EBU', Label.COD_Dealer_List.split(',')[0].substring(0,4) + Label.COD_Dealer_List.split(',')[0]);
        acc3a.OSM_Service_Level__c = 'Lite Repair';
        accountList.add(acc3a);
        
        
        Account acc4 = createAccount2('EBU', Label.COD_Distributor_List.split(',')[0].substring(0,4) + Label.COD_Distributor_List.split(',')[0]);
        acc4.Type = 'National Account';
        accountList.add(acc4);
        
        Account acc5 = createAccount2('EBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc5.Type = 'National Account';
        acc5.BUSINESS_UNIT__c ='PSBU';
        acc5.IAM_Primary_Market_Segment__c = 'Automotive';
        accountList.add(acc5);
        
        Account acc6 = createAccount2('EBU', '');
        //acc6.CMI_Account_Status__c = 'Inactive';
        acc6.IAM_Primary_Market_Segment__c = 'BUS';
        accountList.add(acc6);
        
        Account acc7 = createAccount2('EBU', Label.COD_JV_SSOEM_List.split(',')[0]);
        acc7.Name = 'Komatsu Test Account';
        acc7.Type = null;
        acc7.IAM_Primary_Market_Segment__c = 'Automotive';
        accountList.add(acc7);
        
        Account acc8 = createAccount2('EBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc8.Type = 'National Account';
        acc8.BUSINESS_UNIT__c ='';
        acc8.CHANNEL_OF_DISTRIBUTION__c = '';
        
        accountList.add(acc8);
        
        Account acc12 = createAccount2('EBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc12.Type = 'National Account';
        acc12.BUSINESS_UNIT__c ='EBU';
        acc12.OSM_DA_CustomerID__c='080jkjoioiu';
        
        accountList.add(acc12);
        
        
        Account acc9 = createAccount2('', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc9.Type = 'National Account';
        acc9.BUSINESS_UNIT__c ='';
        acc9.CHANNEL_OF_DISTRIBUTION__c = '';
        accountList.add(acc9);
        
        
        Account acc10 = createAccount2('PSBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc10.Type = 'National Account';
        acc10.BUSINESS_UNIT__c ='';
        acc10.CHANNEL_OF_DISTRIBUTION__c = '';
        accountList.add(acc10);
        
        
        Account acc11 = createAccount2('PSBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc11.Type = 'National Account';
        acc11.BUSINESS_UNIT__c ='PSBU';
        acc11.OSM_DA_CustomerID__c='080jkjoioiu';
        accountList.add(acc11);
        
        
        
        Account acc13 = createAccount2('PSBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        //acc13.CMI_Account_Status__c='cancelled';
        acc13.Type = 'National Account';
        acc13.BUSINESS_UNIT__c ='PSBU';
        acc13.IAM_Primary_Market_Segment__c='BUS';
        accountList.add(acc13);
        
        
        Account acc14 = createAccount5('PSBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        //acc13.CMI_Account_Status__c='cancelled';
        acc14.Type = 'National Account';
        
        acc14.BUSINESS_UNIT__c ='PSBU';
        acc14.IAM_Primary_Market_Segment__c='BUS';
        accountList.add(acc14);
        
        
        Account acc15 = createAccount5('EBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        //acc13.CMI_Account_Status__c='cancelled';
        acc15.Type = 'National Account';
        acc15.BUSINESS_UNIT__c ='EBU';
        acc15.IAM_Primary_Market_Segment__c='BUS';
        accountList.add(acc15);
        
        
        insert accountList;
        system.debug('accountList'+accountList);
        List<Account> accountList2 = [Select ID,IAM_Service_Provider_Code__c,PSBU_Channel_of_Distribution__c,BillingCountry, EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c, Type, RecordTypeId, OSM_HHP_Dealer__c, Business_Unit__c,ccrz__E_AccountGroup__c, OSM_Market_Segment_Code__c, CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c, OSM_Service_Level__c,ParentId FROM Account];
        
        Test.startTest();
        //OSM_AutoPopulateAccount obj = new OSM_AutoPopulateAccount();
        OSM_AutoPopulateAccount.updateAccountGroup(accountList2);
        List<Account> accforassertList = [SELECT Id,ccrz__E_AccountGroup__r.Name,ccrz__E_AccountGroup__c FROM Account LIMIT 50];
        
        Test.stopTest();
    }
    
    @isTest
    public static void accountGroupMappingTrigger_test2()
    {
        createAccountGroup();
        
        List<Account> accountList = new List<Account>();
        Account acc1 = createAccount3('PSBU','DISTRIBUTOR-BRANCH'); 
        accountList.add(acc1);
        
        Account acc2 = createAccount3('PSBU', 'FLEET');
        accountList.add(acc2);
        
        Account acc3a = createAccount3('PSBU','CIHR' );
        accountList.add(acc3a);
        
        Account acc3b = createAccount3('PSBU','Dealer' );
        accountList.add(acc3b);
        
        insert accountList;
        
        Test.startTest();
        
        OSM_AutoPopulateAccount.updateAccountGroup(accountList);
        List<Account> accforassertList = [SELECT Id,ccrz__E_AccountGroup__r.Name,ccrz__E_AccountGroup__c FROM Account LIMIT 50];
        
        
        Test.stopTest();
    } 
    
    
    static testMethod void testmethod5(){
         List<Account> acntsList = new List<Account>();
        Account acc= createAccount8('EBU','DEALER');
        acc.IAM_Primary_Market_Segment__c = 'Bus';
        acntsList.add(acc);

        Account acc1= createAccount8('EBU','DEALER');
        acc1.IAM_Primary_Market_Segment__c = 'Automotive';
        acntsList.add(acc1);

        Account acc2= createAccount8('EBU','DEALER');
        acc2.IAM_Primary_Market_Segment__c = 'Railcar';
        acntsList.add(acc2);

        Account acc3= createAccount8('EBU','DEALER');
        acc3.IAM_Primary_Market_Segment__c = 'Mining';
        acntsList.add(acc3);

        Account acc4= createAccount8('EBU','DEALER');
        acc4.IAM_Primary_Market_Segment__c = 'Oil & Gas';
        acntsList.add(acc4);
        
        insert acntsList;
        
        
       
        OSM_AutoPopulateAccount.updateAccountGroup(acntsList);
    } 
 
     static testMethod void testmethod6(){
         List<Account> acntsList = new List<Account>();
        Account acc= new Account();
        acc.Name = 'Test FleetTestMEthod5';
        acc.Type = 'Fleet';
        acc.RecordTypeId = [select id from recordType where name='WWSPS' limit 1].id;  
        acc.IAM_Primary_Market_Segment__c = 'Oil & Gas';
        acc.BillingCountry = 'United States'; 
        acntsList.add(acc);
        
       
        
        insert acntsList;
        
        List<Account> acnts = [Select EngineRangeDesc__c, ID,Is_OEM_Acount__c,Is_Training_Account__c,ParentId,IAM_Service_Provider_Code__c,IAM_WWSPS_Regions__c,PSBU_Channel_of_Distribution__c,BillingCountry,OSM_Accountgroupbatch__c,EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c,Type,RecordTypeId,RecordType.Name,OSM_HHP_Dealer__c,Business_Unit__c,ccrz__E_AccountGroup__c,OSM_Market_Segment_Code__c,CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c,OSM_Service_Level__c,ServiceLevel__c FROM Account where Name = 'Test FleetTestMEthod5'];
        
        OSM_AutoPopulateAccount.updateAccountGroup(acnts);
    } 
    
    static testMethod void testmethod7(){
         List<Account> acntsList = new List<Account>();
        
        
        Account acc2= new Account();
        acc2.Name = 'Test FleetTestMethod7';
        acc2.Type = 'Fleet';
        acc2.RecordTypeId = [select id from recordType where name='WWSPS' limit 1].id;  
        acc2.IAM_Primary_Market_Segment__c = 'Mining';
        acc2.BillingCountry = 'United States'; 
        acntsList.add(acc2);
        
        insert acntsList;
        
        List<Account> acnts = [Select EngineRangeDesc__c, ID,Is_OEM_Acount__c,Is_Training_Account__c,ParentId,IAM_Service_Provider_Code__c,IAM_WWSPS_Regions__c,PSBU_Channel_of_Distribution__c,BillingCountry,OSM_Accountgroupbatch__c,EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c,Type,RecordTypeId,RecordType.Name,OSM_HHP_Dealer__c,Business_Unit__c,ccrz__E_AccountGroup__c,OSM_Market_Segment_Code__c,CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c,OSM_Service_Level__c,ServiceLevel__c FROM Account where Name='Test FleetTestMethod7'];
        
        OSM_AutoPopulateAccount.updateAccountGroup(acnts);
    } 
    
    static testMethod void testmethod8(){
         List<Account> acntsList = new List<Account>();
        
        
        Account acc2= new Account();
        acc2.Name = 'Test FleetTestMethod7';
        acc2.Type = 'Fleet';
        acc2.RecordTypeId = [select id from recordType where name='WWSPS' limit 1].id;  
        acc2.IAM_Primary_Market_Segment__c = 'Railcar';
        acc2.BillingCountry = 'United States'; 
        acntsList.add(acc2);
        
        insert acntsList;
        
        List<Account> acnts = [Select EngineRangeDesc__c, ID,Is_OEM_Acount__c,Is_Training_Account__c,ParentId,IAM_Service_Provider_Code__c,IAM_WWSPS_Regions__c,PSBU_Channel_of_Distribution__c,BillingCountry,OSM_Accountgroupbatch__c,EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c,Type,RecordTypeId,RecordType.Name,OSM_HHP_Dealer__c,Business_Unit__c,ccrz__E_AccountGroup__c,OSM_Market_Segment_Code__c,CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c,OSM_Service_Level__c,ServiceLevel__c FROM Account where Name='Test FleetTestMethod7'];
        
        OSM_AutoPopulateAccount.updateAccountGroup(acnts);
    } 
    
    static testMethod void testmethod9(){
         List<Account> acntsList = new List<Account>();
        
        
        Account acc2= new Account();
        acc2.Name = 'Test FleetTestMethod7';
        acc2.Type = 'Fleet';
        acc2.RecordTypeId = [select id from recordType where name='WWSPS' limit 1].id;  
        acc2.IAM_Primary_Market_Segment__c = 'Automotive';
        acc2.BillingCountry = 'United States'; 
        acntsList.add(acc2);
        
        insert acntsList;
        
        List<Account> acnts = [Select EngineRangeDesc__c, ID,Is_OEM_Acount__c,Is_Training_Account__c,ParentId,IAM_Service_Provider_Code__c,IAM_WWSPS_Regions__c,PSBU_Channel_of_Distribution__c,BillingCountry,OSM_Accountgroupbatch__c,EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c,Type,RecordTypeId,RecordType.Name,OSM_HHP_Dealer__c,Business_Unit__c,ccrz__E_AccountGroup__c,OSM_Market_Segment_Code__c,CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c,OSM_Service_Level__c,ServiceLevel__c FROM Account where Name='Test FleetTestMethod7'];
        
        OSM_AutoPopulateAccount.updateAccountGroup(acnts);
    }
    
    static testMethod void testmethod10(){
         List<Account> acntsList = new List<Account>();
        
        
        Account acc2= new Account();
        acc2.Name = 'Test FleetTestMethod7';
        acc2.Type = 'Fleet';
        acc2.RecordTypeId = [select id from recordType where name='WWSPS' limit 1].id;  
        acc2.IAM_Primary_Market_Segment__c = 'Railcar';
        acc2.BillingCountry = 'Canada'; 
        acntsList.add(acc2);
        
        insert acntsList;
        
        List<Account> acnts = [Select EngineRangeDesc__c, ID,Is_OEM_Acount__c,Is_Training_Account__c,ParentId,IAM_Service_Provider_Code__c,IAM_WWSPS_Regions__c,PSBU_Channel_of_Distribution__c,BillingCountry,OSM_Accountgroupbatch__c,EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c,Type,RecordTypeId,RecordType.Name,OSM_HHP_Dealer__c,Business_Unit__c,ccrz__E_AccountGroup__c,OSM_Market_Segment_Code__c,CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c,OSM_Service_Level__c,ServiceLevel__c FROM Account where Name='Test FleetTestMethod7'];
        
        OSM_AutoPopulateAccount.updateAccountGroup(acnts);
    }
    
    static testMethod void testmethod11(){
         List<Account> acntsList = new List<Account>();
        
        
        Account acc2= new Account();
        acc2.Name = 'Test FleetTestMethod7';
        acc2.Type = 'Fleet';
        acc2.RecordTypeId = [select id from recordType where name='WWSPS' limit 1].id;  
        acc2.IAM_Primary_Market_Segment__c = 'Automotive';
        acc2.BillingCountry = 'Canada'; 
        acntsList.add(acc2);
        
        insert acntsList;
        
        List<Account> acnts = [Select EngineRangeDesc__c, ID,Is_OEM_Acount__c,Is_Training_Account__c,ParentId,IAM_Service_Provider_Code__c,IAM_WWSPS_Regions__c,PSBU_Channel_of_Distribution__c,BillingCountry,OSM_Accountgroupbatch__c,EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c,Type,RecordTypeId,RecordType.Name,OSM_HHP_Dealer__c,Business_Unit__c,ccrz__E_AccountGroup__c,OSM_Market_Segment_Code__c,CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c,OSM_Service_Level__c,ServiceLevel__c FROM Account where Name='Test FleetTestMethod7'];
        
        OSM_AutoPopulateAccount.updateAccountGroup(acnts);
    }
    
    @isTest
    public static void accountGroupMappingTrigger_test3()
    {
        createAccountGroup();
        
        List<Account> accountList = new List<Account>();
        Account acc1 = createAccount4('CMI','DISTRIBUTOR-BRANCH'); 
        accountList.add(acc1);
        
        Account acc2 = createAccount4('CMI', 'FLEET');
        accountList.add(acc2);
        
        Account acc3a = createAccount4('CMI','CIHR' );
        accountList.add(acc3a);
        
        Account acc3b = createAccount4('CMI','Dealer' );
        accountList.add(acc3b);
        
        insert accountList;
        
        Test.startTest();
        
        OSM_AutoPopulateAccount.updateAccountGroup(accountList);
        List<Account> accforassertList = [SELECT Id,ccrz__E_AccountGroup__r.Name,ccrz__E_AccountGroup__c FROM Account LIMIT 50];
        Test.stopTest();
    } 
    @isTest
    public static void accountGroupMappingTrigger_test5(){createAccountGroup();
                                                          
                                                          List<Account> accountList = new List<Account>();
                                                          
                                                          
                                                          Account acc1 = createAccount5('EBU', 'Distributor'); 
                                                          acc1.Type = 'Votech';
                                                          accountList.add(acc1);
                                                          
                                                          
                                                          insert accountList;
                                                          system.debug('accountList'+accountList);
                                                          
                                                          Test.startTest();
                                                          //OSM_AutoPopulateAccount obj = new OSM_AutoPopulateAccount();
                                                          OSM_AutoPopulateAccount.updateAccountGroup(accountList);
                                                          List<Account> accforassertList = [SELECT Id,ccrz__E_AccountGroup__r.Name,ccrz__E_AccountGroup__c FROM Account LIMIT 50];
                                                          
                                                          Test.stopTest();
                                                         }
    @isTest
    public static void accountGroupMappingTrigger_test6()
    {
        createAccountGroup();
        
        List<Account> accountList = new List<Account>();
        Account acc1 = createAccount6('PSBU','DISTRIBUTOR-BRANCH'); 
        acc1.IAM_Primary_Market_Segment__c = 'BUS';
        acc1.Type = 'National Account';
        accountList.add(acc1);
        
        Account acc2 = createAccount6('PSBU', 'FLEET');
        acc2.IAM_Primary_Market_Segment__c = 'BUS';
        accountList.add(acc2);
        
        Account acc3a = createAccount6('PSBU','CIHR' );
        acc3a.IAM_Primary_Market_Segment__c = 'BUS';
        accountList.add(acc3a);
        
        Account acc3b = createAccount6('PSBU','Dealer' );
        acc3b.IAM_Primary_Market_Segment__c = 'BUS';
        accountList.add(acc3b);
        
        insert accountList;
        
        //accountList = [SELECT Id,Name,CMI_CDA_Status__c,RecordTypeId,CSS_Language__c,DTNA__c,Business_Unit__c,EBU_Channel_of_Distribution__c,IAM_Primary_Market_Segment__c,Type,OSM_Market_Segment_Code__c,BillingCountry FROM Account WHERE BillingCountry = 'India' AND OSM_Market_Segment_Code__c = 'BUS' LIMIT 50];
        //system.debug('OSM_Market_Segment_Code__c==='+accountList[0].OSM_Market_Segment_Code__c);
        List<Account> accList = [SELECT Id,OSM_Market_Segment_Code__c,BUSINESS_UNIT__c,Type,RecordTypeId,BillingCountry FROM Account WHERE Id =: acc1.id and RecordTypeId='001Q0000011WVGhIAO' and BUSINESS_UNIT__c='PSBU' and Type='National Account'];
        Test.startTest();
        
        OSM_AutoPopulateAccount.updateAccountGroup(accountList);
        OSM_AutoPopulateAccount.updateAccountGroup(accList);
        List<Account> accforassertList = [SELECT Id,OSM_Market_Segment_Code__c,BillingCountry, ccrz__E_AccountGroup__r.Name,ccrz__E_AccountGroup__c FROM Account LIMIT 50];
        
        
        Test.stopTest();
    } 
    @isTest
    public static void getCODsSet_test5(){
        OSM_AutoPopulateAccount.getCODsSet('text account,fmh,vjhkj');
    } 
     @isTest
    public static void accountGroupMappingTrigger_test22()
    {
        createAccountGroup();
        
    
        List<Account> accountList = new List<Account>();
      
        Account acc1 = createAccount7('EBU', Label.COD_CIHR_List.split(',')[0].substring(0,4) + Label.COD_CIHR_List.split(',')[0]); 
        acc1.Type = 'Votech';
        accountList.add(acc1);
        
        // need to add market segment for FLEET
        Account acc2 = createAccount7('EBU', Label.COD_Fleet_List.split(',')[0].substring(0,4) + Label.COD_Fleet_List.split(',')[0]);
        acc2.IAM_Primary_Market_Segment__c = 'Bus';
        acc2.Type = 'Fleet';
        acc2.PSBU_Channel_of_Distribution__c='Fleet';
        accountList.add(acc2);
        
        
       /* Account acc3a = createAccount7('EBU', Label.COD_Dealer_List.split(',')[0].substring(0,4) + Label.COD_Dealer_List.split(',')[0]);
        acc3a.OSM_Service_Level__c = 'Lite Repair';
         acc3a.IAM_Primary_Market_Segment__c = 'Oil & Gas';
        acc3a.PSBU_Channel_of_Distribution__c='Dealer';
        accountList.add(acc3a); */
        
        
        Account acc3b = createAccount7('EBU', Label.COD_Dealer_List.split(',')[0].substring(0,4) + Label.COD_Dealer_List.split(',')[0]);
        acc3b.OSM_Service_Level__c = 'Full Service';
        acc3b.IAM_Primary_Market_Segment__c = 'Mining';
        accountList.add(acc3b);
        
        Account acc4 = createAccount7('EBU', Label.COD_Distributor_List.split(',')[0].substring(0,4) + Label.COD_Distributor_List.split(',')[0]);
        acc4.Type = 'National Account';
        acc4.IAM_Primary_Market_Segment__c = 'Railcar';
        accountList.add(acc4);
               
        
        insert accountList;
        List<Account> accountList2 = [Select ID,IAM_Service_Provider_Code__c,PSBU_Channel_of_Distribution__c,BillingCountry, EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c, Type, RecordTypeId, OSM_HHP_Dealer__c, Business_Unit__c,ccrz__E_AccountGroup__c, OSM_Market_Segment_Code__c, CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c, OSM_Service_Level__c,ParentId FROM Account];
        
        Test.startTest();
        
        OSM_AutoPopulateAccount.updateAccountGroup(accountList2);
        
        Test.stopTest();
    } 
 static testMethod void testMethod3(){
      
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
        
         Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
         
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='test24446@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago',
          OSM_Storefront_User_Type__c ='Distributor Admin'
          );
          Database.insert(portalAccountOwner2);
          
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          Type= 'Distributor Branch Account',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          IAM_Service_Provider_Code__c='123'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          IAM_Contact_Status__c='Pending',
          Username__c = 'testUserName654@gmail.com',
          AccountId = portalAccount2.Id,
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          }
          
          System.runAs(transecRes.objSetupDate.loggedInUser) {
           Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = transecRes.invoice.Id;
            insert attachment;
            system.debug('==Attachment inserted==');

          }
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'testsubbu2389@test.com'; //changed to bypass test failure in prod
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
          //testUser.UserRoleId = portalRole.Id;
          testUser.OSM_Storefront_User_Type__c ='Distributor Admin';
          
              System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }

        // Creating address
        System.runAs(portalAccountOwner2) {

            Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.IAM_Service_Provider_Code__c='1234';
            account.CHANNEL_OF_DISTRIBUTION__c='12345';
            account.Business_Unit__c='test';
            account.DTNA__c=true;
            //account.OSM_Service_Level__c='Lite Repair';
            account.OSM_Service_Level__c='Full Service';
            account.OSM_HHP_Dealer__c=true;
            account.Name='Komatsu';
            
            update account;
            
            Contact contact2 = new Contact(
              FirstName = 'Test12',
              Lastname = 'McTesty9356',
              IAM_Contact_Status__c='Pending',
              Username__c = 'testUserName6789@gmail.com',
              AccountId = account.Id,
              Email ='test129@test.com',
              IAM_Contact_Owner__c =portalAccountOwner2.id
              );
              insert contact2;

            effectiveAccount_enable_ProfileUserType__c effAccPro = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro.Name ='Distributor Admin';
            effAccPro.Enable_Effective_Account_Selection__c=true;
            insert effAccPro;
            effectiveAccount_enable_ProfileUserType__c effAccPro1 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro1.Name ='Regular';
            effAccPro1.Enable_Effective_Account_Selection__c=true;
            insert effAccPro1;
            effectiveAccount_enable_ProfileUserType__c effAccPro2 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro2.Name ='SSOEM Admin';
            effAccPro2.Enable_Effective_Account_Selection__c=true;
            insert effAccPro2;
            
            
            Map < String, Object > inputMap = new Map < String, Object > ();
      ccrz.cc_bean_CartSummary cartSum = new ccrz.cc_bean_CartSummary(transecRes.cart);
      
        inputMap.put('version',7);
        inputMap.put('storefront','SoftwareStore');
        inputMap.put('ownerId',transecRes.objSetupDate.objUserID);
        inputMap.put('cartId',transecRes.cart.Id);
        inputMap.put('sizing','{cart={sz_assc=false, sz_data=sz_s, sz_skiptrz=true}}');
        inputMap.put('CartBean',cartSum );
        inputMap.put(ccrz.cc_hk_EffectiveAccount.PARAM_ACCOUNT_ID,transecRes.order.ccrz__Account__c);
        inputMap.put('DistributorType', 'Distributor Branch Account');
        //inputMap.put('LocationCode', account.IAM_Service_Provider_Code__c);
 

            Test.startTest();

            OSM_SW_cc_hk_Order objCls = new OSM_SW_cc_hk_Order();
            Map < String, Object > returnMap = objCls.place(inputMap);
            OSM_SW_cc_hk_Order.processRefundForFailedOSMOrderPlacedProcess();
            
            
            
            
            inputMap = new Map < String, Object > ();

            try {
           
           
            } catch (Exception ex) {}
            
            

            Test.stopTest();

        }
    }    
 
 static testMethod void testMethod4(){
      
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
        
         Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
         
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='test24446@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago',
          OSM_Storefront_User_Type__c ='Distributor Admin'
          );
          Database.insert(portalAccountOwner2);
          
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          Type= 'Distributor Branch Account',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false,
          IAM_Service_Provider_Code__c='123'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          IAM_Contact_Status__c='Pending',
          Username__c = 'testUserName65594@gmail.com',
          AccountId = portalAccount2.Id,
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          }
          
          System.runAs(transecRes.objSetupDate.loggedInUser) {
           Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = transecRes.invoice.Id;
            insert attachment;
            system.debug('==Attachment inserted==');

          }
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test208912@test.com'; //changed to bypass test failure in prod
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
          //testUser.UserRoleId = portalRole.Id;
          testUser.OSM_Storefront_User_Type__c ='Distributor Admin';
          
              System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }

        // Creating address
        System.runAs(portalAccountOwner2) {

            Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.IAM_Service_Provider_Code__c='1234';
            account.CHANNEL_OF_DISTRIBUTION__c='12345';
            account.Business_Unit__c='test';
            account.DTNA__c=true;
            account.OSM_Service_Level__c='Lite Repair';
            //account.OSM_Service_Level__c='Full Service';
            account.OSM_HHP_Dealer__c=true;
            account.Name='Komatsu';
            
            update account;
            
            Contact contact2 = new Contact(
              FirstName = 'Test12',
              Lastname = 'McTesty9356',
              IAM_Contact_Status__c='Pending',
              Username__c = 'testUserName6789@gmail.com',
              AccountId = account.Id,
              Email ='test129@test.com',
              IAM_Contact_Owner__c =portalAccountOwner2.id
              );
              insert contact2;

            effectiveAccount_enable_ProfileUserType__c effAccPro = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro.Name ='Distributor Admin';
            effAccPro.Enable_Effective_Account_Selection__c=true;
            insert effAccPro;
            effectiveAccount_enable_ProfileUserType__c effAccPro1 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro1.Name ='Regular';
            effAccPro1.Enable_Effective_Account_Selection__c=true;
            insert effAccPro1;
            effectiveAccount_enable_ProfileUserType__c effAccPro2 = new effectiveAccount_enable_ProfileUserType__c();
            effAccPro2.Name ='SSOEM Admin';
            effAccPro2.Enable_Effective_Account_Selection__c=true;
            insert effAccPro2;
            
            
            Map < String, Object > inputMap = new Map < String, Object > ();
      ccrz.cc_bean_CartSummary cartSum = new ccrz.cc_bean_CartSummary(transecRes.cart);
      
        inputMap.put('version',7);
        inputMap.put('storefront','SoftwareStore');
        inputMap.put('ownerId',transecRes.objSetupDate.objUserID);
        inputMap.put('cartId',transecRes.cart.Id);
        inputMap.put('sizing','{cart={sz_assc=false, sz_data=sz_s, sz_skiptrz=true}}');
        inputMap.put('CartBean',cartSum );
        inputMap.put(ccrz.cc_hk_EffectiveAccount.PARAM_ACCOUNT_ID,transecRes.order.ccrz__Account__c);
        inputMap.put('DistributorType', 'Distributor Branch Account');
        Test.startTest();

            OSM_SW_cc_hk_Order objCls = new OSM_SW_cc_hk_Order();
            Map < String, Object > returnMap = objCls.place(inputMap);
            OSM_SW_cc_hk_Order.processRefundForFailedOSMOrderPlacedProcess();
            
            
            
            
            inputMap = new Map < String, Object > ();

            Test.stopTest();

        }
    } 
}