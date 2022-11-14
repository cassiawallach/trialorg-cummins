//This is test class for the class OSM_AccountGroupMapping_Helper
// Sharad udpated 28 June 2021
// Sharad udpated 08 July 2021
//updated 
//Updated June - 8th.MP-733.
//Updated for OMG -1132

@isTest
public class OSM_AccountGroupMapping_Test 
{
    public static Account createAccount(String businessUnit, String channelOfDistribution)
    { 
    
        RecordType recid =[select id from recordType where name='wwsps' limit 1];  
        Account acc = new Account();
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        //acc.CMI_Account_Status__c = 'Active'; //This is commented
        acc.CMI_CDA_Status__c = 'New Customer Request';
        acc.IAM_WWSPS_Regions__c  = 'US and Canada';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = businessUnit;
        acc.EBU_Channel_of_Distribution__c = channelOfDistribution;
        acc.BillingCity = 'Sunnyvale'; 
        acc.Billingstate = 'California'; 
        acc.BillingPostalCode = '94085'; 
        acc.BillingCountry='United States';
        acc.BillingStreet='351 test street';
        return acc;
    }
    
    public static Account createAccount2(String businessUnit, String channelOfDistribution)
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
        acc.BillingCity = 'Sunnyvale'; 
        acc.Billingstate = 'California'; 
        acc.BillingPostalCode = '94085'; 
        acc.BillingCountry='United States';
        acc.BillingStreet='351 test street';
        
        return acc;
    }
    
     public static Account createAccount5(String businessUnit, String channelOfDistribution)
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
        acc.BillingCity = 'Bangalore'; 
        acc.Billingstate = 'Karnataka'; 
        acc.BillingPostalCode = '560037';
        acc.BillingStreet='351 test street'; 
        return acc;
    }
    
    public static Account createAccount3(String businessUnit, String channelOfDistribution)
    { 
        RecordType recid =[select id from recordType where name='wwsps' limit 1];  
        Account acc = new Account();
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        //acc.CMI_Account_Status__c = 'Active';
        acc.CMI_CDA_Status__c = 'New Customer Request';
        acc.IAM_WWSPS_Regions__c  = 'US and Canada';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = businessUnit;
        acc.PSBU_Channel_of_Distribution__c = channelOfDistribution;
        
        return acc;
    }
    public static Account createAccount4(String businessUnit, String channelOfDistribution)
    { 
        RecordType recid =[select id from recordType where name='wwsps' limit 1];  
        Account acc = new Account();
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        //acc.CMI_Account_Status__c = 'Active';
        acc.CMI_CDA_Status__c = 'New Customer Request';
        acc.IAM_WWSPS_Regions__c  = 'US and Canada';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = businessUnit;
        acc.PSBU_Channel_of_Distribution__c = channelOfDistribution;
        acc.EBU_Channel_of_Distribution__c = channelOfDistribution;
        acc.BillingCity = 'Columbus'; 
        acc.Billingstate = 'Indiana'; 
        acc.BillingPostalCode = '47201'; 
        acc.BillingCountry='United States';
        acc.BillingStreet='351 test street';
        return acc;
    }
     public static Account createAccount6(String businessUnit, String channelOfDistribution)
    { 
        RecordType recid =[select id from recordType where name='wwsps' limit 1];  
        Account acc = new Account();
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        //acc.CMI_Account_Status__c = 'Active';
        acc.CMI_CDA_Status__c = 'New Customer Request';
        acc.IAM_WWSPS_Regions__c  = 'US and Canada';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = businessUnit;
        acc.PSBU_Channel_of_Distribution__c = channelOfDistribution;
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'Fredericton';
        acc.BillingCountry='Canada';
        acc.BillingPostalCode = 'E3C 2E7';
        acc.BillingState='New Brunswick';
        return acc;
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
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'Fredericton';
        acc.BillingCountry='Canada';
        acc.BillingPostalCode = 'E3C 2E7';
        acc.BillingState='New Brunswick';
        acc.Type = 'National Account';
        return acc;
    }
    
    public static void createAccountGroup()
    {
        List<ccrz__E_AccountGroup__c> accountGrpList = new List<ccrz__E_AccountGroup__c>();
        
        ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c();
        accGrp.Name = 'US/CAN_EBU_SIR_ACCGRP';
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
        accGrp12.Name = 'US/CAN_VoTech_ACCGRP';//LL37 checking is EBU dist is CAREER CENTERS 9th Aug 2022
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
        accGrp17.Name = 'SES_Rest_Of_World_BUS_GLOBAL_ACCGRP';
        accountGrpList.add(accGrp17);
        
        ccrz__E_AccountGroup__c accGrp18 = new ccrz__E_AccountGroup__c();
        accGrp18.Name = 'SES_Rest_Of_World_OHT_GLOBAL_ACCGRP';
        accountGrpList.add(accGrp18);
        
        ccrz__E_AccountGroup__c accGrp19 = new ccrz__E_AccountGroup__c();
        accGrp19.Name = 'SES_Rest_Of_World_DEF_GLOBAL_ACCGRP';
        accountGrpList.add(accGrp19);
        
        ccrz__E_AccountGroup__c accGrp20 = new ccrz__E_AccountGroup__c();
        accGrp20.Name = 'SES_Rest_Of_World_MIN_GLOBAL_ACCGRP';
        accountGrpList.add(accGrp20);
        
        ccrz__E_AccountGroup__c accGrp21 = new ccrz__E_AccountGroup__c();
        accGrp21.Name = 'SES_Rest_Of_World_OIL_GLOBAL_ACCGRP';
        accountGrpList.add(accGrp21);
        
        ccrz__E_AccountGroup__c accGrp22 = new ccrz__E_AccountGroup__c();
        accGrp22.Name = 'SES_Rest_Of_World_RAIL_GLOBAL_ACCGRP';
        accountGrpList.add(accGrp22);
        
        ccrz__E_AccountGroup__c accGrp23 = new ccrz__E_AccountGroup__c();
        accGrp23.Name = 'US/CAN_Other_SSOEMS_ACCGRP';
        accountGrpList.add(accGrp23);
        
        ccrz__E_AccountGroup__c accGrp24 = new ccrz__E_AccountGroup__c();
        accGrp24.Name = 'US/CAN_VoTech_ACCGRP';
        accountGrpList.add(accGrp24);
        
        ccrz__E_AccountGroup__c accGrp25 = new ccrz__E_AccountGroup__c();
        accGrp25.Name = 'US/CAN_Reseller_ACCGRP';
        accountGrpList.add(accGrp25);
        
         ccrz__E_AccountGroup__c accGrp26 = new ccrz__E_AccountGroup__c();
        accGrp26.Name = 'US/CAN_Global_Training_ACCGRP';
        accountGrpList.add(accGrp26);
        
        
        ccrz__E_AccountGroup__c accGrp27 = new ccrz__E_AccountGroup__c();
        accGrp27.Name = 'US/CAN_PSBU_Fleet_DEF_ACCGRP';
        accountGrpList.add(accGrp27);
        
         ccrz__E_AccountGroup__c accGrp28 = new ccrz__E_AccountGroup__c();
        accGrp28.Name = 'CAN_CMI_Fleet_BUS_ACCGRP';
        accountGrpList.add(accGrp28);
        
        ccrz__E_AccountGroup__c accGrp29 = new ccrz__E_AccountGroup__c();
        accGrp29.Name = 'US/CAN_OEM_ACCGRP';
        accountGrpList.add(accGrp29); 
         ccrz__E_AccountGroup__c accGrp30 = new ccrz__E_AccountGroup__c();
        accGrp30.Name = 'US/CAN_CMI_Fleet_RAIL_ACCGRP';
        accountGrpList.add(accGrp30); 
        
        
        
        insert accountGrpList;
    }
    
    
    @isTest
    public static void accountGroupMappingTrigger_test333()
    {
        createAccountGroup();
        
        List<Account> accountList = new List<Account>();
        Account acc1 = createAccount6('EBU','DISTRIBUTOR-BRANCH'); 
        acc1.IAM_Service_Provider_Code__c='01031';
        acc1.CSS_DistributorCode__c='03521';
        acc1.EngineRangeDesc__c='HHP';
        acc1.ServiceLevel__c ='HalfService';
        accountList.add(acc1);
        
        Account acc2 = createAccount6('EBU', 'FLEET');
        acc2.IAM_Service_Provider_Code__c='01032';
        acc2.CSS_DistributorCode__c='03522';
        acc2.EngineRangeDesc__c='HHP';
        acc2.ServiceLevel__c ='Full Service';
        accountList.add(acc2);
        
        Account acc3a = createAccount6('EBU','DEALER' );
        acc3a.IAM_Service_Provider_Code__c='010333';
        acc3a.CSS_DistributorCode__c='03523';
        accountList.add(acc3a);
        
        Account acc3b = createAccount6('EBU','CIHR' );
        acc3b.IAM_Service_Provider_Code__c='01034';
        acc3b.CSS_DistributorCode__c='03524';
        accountList.add(acc3b);
        
        /****************************************/
        
        Account acc8 = createAccount7('PSBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc8.IAM_Service_Provider_Code__c='01035';
        acc8.CSS_DistributorCode__c='03525';
        accountList.add(acc8);
        
        Account acc4 = createAccount6('','');
        acc4.IAM_Primary_Market_Segment__c ='Mining';
        acc4.CMI_Account_Status__c='Cancelled';
        acc4.IAM_Service_Provider_Code__c='01036';
        acc4.CSS_DistributorCode__c='03526';
        acc4.EBU_Channel_of_Distribution__c='DISTRIBUTOR-BRANCH';
        accountList.add(acc4);
        
        Account acc5 = createAccount6('','');
        //acc5.IAM_Primary_Market_Segment__c ='Oil & Gas';
        acc5.PSBU_Channel_of_Distribution__c='DISTRIBUTOR-BRANCH';
        acc5.IAM_Service_Provider_Code__c='01037';
        acc5.CSS_DistributorCode__c='03527';
        accountList.add(acc5);
        
        Account acc6 = createAccount6('','');
        acc6.IAM_Primary_Market_Segment__c ='Railcar';
        acc6.PSBU_Channel_of_Distribution__c='DISTRIBUTOR-BRANCH';
        acc6.EBU_Channel_of_Distribution__c='';
        acc6.IAM_Service_Provider_Code__c='01038';
        acc6.CSS_DistributorCode__c='03528';
        accountList.add(acc6);
        
        Account acc7 = createAccount6('','');
        acc7.IAM_Primary_Market_Segment__c ='Bus';
        acc7.PSBU_Channel_of_Distribution__c='CIHR';
        acc7.EBU_Channel_of_Distribution__c='CIHR';
        acc7.IAM_Service_Provider_Code__c='01039';
        acc7.CSS_DistributorCode__c='03529';
        accountList.add(acc7);
             
        insert accountList;
        
        Test.startTest();
        List<id> finalIds = new List<id>();
        List<Account> accountList2 = [Select ID,Is_Training_Account__c,IAM_Service_Provider_Code__c,PSBU_Channel_of_Distribution__c,BillingCountry, EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c, Type, RecordTypeId, OSM_HHP_Dealer__c,EngineRangeDesc__c, Business_Unit__c,ccrz__E_AccountGroup__c, OSM_Market_Segment_Code__c, CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c, OSM_Service_Level__c,ServiceLevel__c,ParentId,CSS_DistributorCode__c FROM Account limit 5000];
        for(Account accid:accountList2){
            finalIds.add(accid.id);
        } 
        //OSM_AccountGroupMapping_Helper.runAccountGroupMappingManually();
        OSM_AccountGroupMapping_Helper.getChannelOfDistribution(accountList[0]);
        OSM_AccountGroupMapping_Helper.getChannelOfDistribution(accountList[1]);
        //Added
        OSM_AccountGroupMapping_Helper.getCODByAccountRecordType(accountList[0]);
        OSM_AccountGroupMapping_Helper.updateAccountGroup(finalIds);
        
        List<Account> accforassertList = [SELECT Id,ccrz__E_AccountGroup__r.Name,ccrz__E_AccountGroup__c FROM Account LIMIT 50];
        
        
        Test.stopTest();
    }
    
   
    @isTest
    public static void accountGroupMappingTrigger_test11()
    {
        createAccountGroup();
        List<Account> accountList = new List<Account>();      
        
        Account acc7 = createAccount2('EBU', Label.COD_JV_SSOEM_List.split(',')[0]);
        acc7.Name = 'Komatsu Test Account';
        acc7.Type = null;
        acc7.IAM_Primary_Market_Segment__c = 'Automotive';
        acc7.Type='Distributor Account';
        acc7.IAM_Service_Provider_Code__c='01033';
        acc7.CSS_DistributorCode__c='03520';
        accountList.add(acc7);
          
        Account acc1 = createAccount2('EBU', Label.COD_CIHR_List.split(',')[0].substring(0,4) + Label.COD_CIHR_List.split(',')[0]); 
        acc1.Type = 'Votech';
        acc1.Type='Distributor Account';
        acc1.IAM_Service_Provider_Code__c='01031';
        acc1.CSS_DistributorCode__c='03521';
        accountList.add(acc1);
        
        // need to add market segment for FLEET
        Account acc2 = createAccount2('EBU', Label.COD_Fleet_List.split(',')[0].substring(0,4) + Label.COD_Fleet_List.split(',')[0]);
        acc2.IAM_Primary_Market_Segment__c = 'Bus';
        acc2.Type = 'Fleet';
        acc2.Type='Distributor Account';
        acc2.IAM_Service_Provider_Code__c='01032';
        acc2.CSS_DistributorCode__c='03522';
        accountList.add(acc2);
        
        
        Account acc3a = createAccount2('EBU', Label.COD_Dealer_List.split(',')[0].substring(0,4) + Label.COD_Dealer_List.split(',')[0]);
        acc3a.OSM_Service_Level__c = 'Lite Repair';
        acc3a.Type='Distributor Account';
        acc3a.IAM_Service_Provider_Code__c='01030';
        acc3a.CSS_DistributorCode__c='03523';
        accountList.add(acc3a);
        
        
        Account acc3b = createAccount2('EBU', Label.COD_Dealer_List.split(',')[0].substring(0,4) + Label.COD_Dealer_List.split(',')[0]);
        acc3b.OSM_Service_Level__c = 'Full Service';
        acc3b.Type='Distributor Account';
        acc3b.IAM_Service_Provider_Code__c='01034';
        acc3b.CSS_DistributorCode__c='03524';
        accountList.add(acc3b);
        
        Account acc4 = createAccount2('EBU', Label.COD_Distributor_List.split(',')[0].substring(0,4) + Label.COD_Distributor_List.split(',')[0]);
        acc4.Type = 'National Account';
        acc4.Type='Distributor Account';
        acc4.IAM_Service_Provider_Code__c='01035';
        acc4.CSS_DistributorCode__c='03525';
        accountList.add(acc4);
        
        Account acc5 = createAccount2('EBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc5.Type = 'National Account';
        acc5.BUSINESS_UNIT__c ='PSBU';
        acc5.IAM_Primary_Market_Segment__c = 'Automotive';
        acc5.Type='Distributor Account';
        acc5.IAM_Service_Provider_Code__c='01036';
        acc5.CSS_DistributorCode__c='03526';
        accountList.add(acc5);
        
        Account acc6 = createAccount2('EBU', Label.COD_JV_SSOEM_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        //acc6.CMI_Account_Status__c = 'Inactive';
        acc6.IAM_Primary_Market_Segment__c = 'BUS';
        acc6.Type='Distributor Account';
        acc6.IAM_Service_Provider_Code__c='01037';
        acc6.CSS_DistributorCode__c='03527';
        accountList.add(acc6);
                
        Account acc8 = createAccount2('EBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc8.Type = 'National Account';
        acc8.BUSINESS_UNIT__c ='';
        acc8.CHANNEL_OF_DISTRIBUTION__c = '';
        acc8.Type='Distributor Account';
        acc8.IAM_Service_Provider_Code__c='01039';
        acc8.CSS_DistributorCode__c='03529';
        accountList.add(acc8);
       
        
        Account acc9 = createAccount2('', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc9.Type = 'National Account';
        acc9.BUSINESS_UNIT__c ='';
        acc9.CHANNEL_OF_DISTRIBUTION__c = '';
        acc9.Type='Distributor Account';
        acc9.IAM_Service_Provider_Code__c='01040';
        acc9.CSS_DistributorCode__c='03530';
        accountList.add(acc9);
        
        
         Account acc10 = createAccount2('PSBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc10.Type = 'National Account';
        acc10.BUSINESS_UNIT__c ='';
        acc10.CHANNEL_OF_DISTRIBUTION__c = '';
        acc10.Type='Distributor Account';
        acc10.IAM_Service_Provider_Code__c='01041';
        acc10.CSS_DistributorCode__c='03531';
        accountList.add(acc10);
        
        Account acc11 = createAccount2('EBU', Label.COD_Distributor_List.split(',')[0].substring(0,4) + Label.COD_Distributor_List.split(',')[0]);
        acc11.Type = 'National Account';
        acc11.IAM_Primary_Market_Segment__c = 'BUS';
        acc11.Type='Distributor Account';
        acc11.IAM_Service_Provider_Code__c='01042';
        acc11.CSS_DistributorCode__c='03532';
        accountList.add(acc11);
        
        Account acc12 = createAccount2('EBU', Label.COD_Distributor_List.split(',')[0].substring(0,4) + Label.COD_Distributor_List.split(',')[0]);
        acc12.Type = 'National Account';
        acc12.IAM_Primary_Market_Segment__c = 'Automotive';
        acc12.Type='Distributor Account';
        acc12.IAM_Service_Provider_Code__c='01043';
        acc12.CSS_DistributorCode__c='03533';
        accountList.add(acc12);
        
        Account acc14 = createAccount2('EBU', Label.COD_Distributor_List.split(',')[0].substring(0,4) + Label.COD_Distributor_List.split(',')[0]);
        acc14.Type = 'National Account';
        acc14.Type='Distributor Account';
        acc14.IAM_Service_Provider_Code__c='01044';
        acc14.CSS_DistributorCode__c='03534';
        accountList.add(acc14);
        
        Account acc13 = createAccount2('EBU', Label.COD_Distributor_List.split(',')[0].substring(0,4) + Label.COD_Distributor_List.split(',')[0]);
        acc13.Type = 'National Account';
        acc13.Type='Distributor Account';
        acc13.IAM_Service_Provider_Code__c='01045';
        acc13.CSS_DistributorCode__c='03535';
        accountList.add(acc13);
        
        Account acc15 = createAccount2('','');
        acc15.IAM_Primary_Market_Segment__c ='Mining';
        acc15.Type='Distributor Account';
        acc15.IAM_Service_Provider_Code__c='01046';
        acc15.CSS_DistributorCode__c='03536';
        accountList.add(acc15);
        
        
        Account acc16 = createAccount2('','');
        acc16.IAM_Primary_Market_Segment__c ='Railcar';
        acc16.Type='Distributor Account';
        acc16.IAM_Service_Provider_Code__c='01047';
        acc16.CSS_DistributorCode__c='03537';
        accountList.add(acc16);
        Account acc17 = createAccount2('','');
        acc17.IAM_Primary_Market_Segment__c ='Bus';
        acc17.Type='Distributor Account';
        acc17.IAM_Service_Provider_Code__c='01048';
        acc17.CSS_DistributorCode__c='03538';
        accountList.add(acc17);
        
        /****************************************/
        Account acc18 = createAccount4('','');
        acc18.IAM_Primary_Market_Segment__c ='Mining';
        acc18.CMI_Account_Status__c='Cancelled';
        acc18.IAM_Service_Provider_Code__c='01049';
        acc18.CSS_DistributorCode__c='03539';
        accountList.add(acc18);
         
        Account acc20 = createAccount4('','');
        acc20.IAM_Primary_Market_Segment__c ='Railcar';
        acc20.PSBU_Channel_of_Distribution__c='DISTRIBUTOR-BRANCH';
        acc20.EBU_Channel_of_Distribution__c='';
        acc20.IAM_Service_Provider_Code__c='01050';
        acc20.CSS_DistributorCode__c='03540';
        accountList.add(acc20);
        
        Account acc21 = createAccount4('','');
        acc21.IAM_Primary_Market_Segment__c ='Bus';
        acc21.PSBU_Channel_of_Distribution__c='CIHR';
        acc21.EBU_Channel_of_Distribution__c='CIHR';
        acc21.IAM_Service_Provider_Code__c='01051';
        acc21.CSS_DistributorCode__c='03541';
        accountList.add(acc21);
         
        
        insert accountList;
        
        Test.startTest();
        List<id> finalIds = new List<id>();
        List<Account> accountList2 = [Select ID,Is_Training_Account__c,IAM_Service_Provider_Code__c,PSBU_Channel_of_Distribution__c,BillingCountry, EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c, Type, RecordTypeId, OSM_HHP_Dealer__c,EngineRangeDesc__c, Business_Unit__c,ccrz__E_AccountGroup__c, OSM_Market_Segment_Code__c, CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c, OSM_Service_Level__c,ServiceLevel__c,ParentId,CSS_DistributorCode__c FROM Account limit 5000];
        for(Account accid:accountList2){
            finalIds.add(accid.id);
        }
        //OSM_AccountGroupMapping_Helper.runAccountGroupMappingManually();
        system.debug('#######Acc to process'+accountList);
        OSM_AccountGroupMapping_Helper.updateAccountGroup(finalIds);
         OSM_AccountGroupMapping_Helper.getChannelOfDistribution(accountList[0]);
         
        OSM_AccountGroupMapping_Helper.getCODByAccountRecordType(accountList[1]);
        OSM_AccountGroupMapping_Helper.getCODByAccountRecordType(accountList[2]);
        OSM_AccountGroupMapping_Helper.getCODByAccountRecordType(accountList[3]);
        
        List<Account> accforassertList = [SELECT Id,ccrz__E_AccountGroup__r.Name,ccrz__E_AccountGroup__c FROM Account LIMIT 50];
      
        Test.stopTest();
    }
   @isTest
    public static void accountGroupMappingTrigger_test213()
    {
        createAccountGroup();
        
    
        List<Account> accountList = new List<Account>();
      
        Account acc1 = createAccount5('EBU', Label.COD_CIHR_List.split(',')[0].substring(0,4) + Label.COD_CIHR_List.split(',')[0]); 
        acc1.Type = 'Votech';
        acc1.IAM_Service_Provider_Code__c='01033';
        acc1.CSS_DistributorCode__c='03520';
        accountList.add(acc1);
        
        // need to add market segment for FLEET
        Account acc2 = createAccount5('EBU', Label.COD_Fleet_List.split(',')[0].substring(0,4) + Label.COD_Fleet_List.split(',')[0]);
        acc2.IAM_Primary_Market_Segment__c = 'Bus';
        acc2.Type = 'Fleet';
        acc2.PSBU_Channel_of_Distribution__c='Fleet';
        acc2.IAM_Service_Provider_Code__c='10001';
        acc2.CSS_DistributorCode__c='03521';
        accountList.add(acc2);
        
        
        Account acc3a = createAccount5('EBU', Label.COD_Dealer_List.split(',')[0].substring(0,4) + Label.COD_Dealer_List.split(',')[0]);
        acc3a.OSM_Service_Level__c = 'Lite Repair';
        acc3a.IAM_Service_Provider_Code__c='10002';
        acc3a.CSS_DistributorCode__c='03522';
        acc3a.PSBU_Channel_of_Distribution__c='Dealer';
        accountList.add(acc3a);
        
        
        Account acc3b = createAccount5('EBU', Label.COD_Dealer_List.split(',')[0].substring(0,4) + Label.COD_Dealer_List.split(',')[0]);
        acc3b.OSM_Service_Level__c = 'Full Service';
        acc3b.IAM_Primary_Market_Segment__c = 'Mining';
        acc3b.IAM_Service_Provider_Code__c='10003';
        acc3b.CSS_DistributorCode__c='03523';
        accountList.add(acc3b);
        
        Account acc4 = createAccount5('EBU', Label.COD_Distributor_List.split(',')[0].substring(0,4) + Label.COD_Distributor_List.split(',')[0]);
        acc4.Type = 'National Account';
        acc4.IAM_Primary_Market_Segment__c = 'Railcar';
        acc4.IAM_Service_Provider_Code__c='10004';
        acc4.CSS_DistributorCode__c='03524';
        accountList.add(acc4);
        
        Account acc5 = createAccount5('EBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc5.Type = 'National Account';
        acc5.BUSINESS_UNIT__c ='PSBU';
        acc5.IAM_Primary_Market_Segment__c = 'Automotive';
        acc5.IAM_Service_Provider_Code__c='10005';
        acc5.CSS_DistributorCode__c='03525';
        accountList.add(acc5);
        
        //Account acc6 = createAccount5('EBU', '');
        //acc6.CMI_Account_Status__c = 'Inactive';
        //acc6.IAM_Primary_Market_Segment__c = 'BUS';
        //accountList.add(acc6);
        
        Account acc7 = createAccount5('EBU', Label.COD_JV_SSOEM_List.split(',')[0].substring(0,4) + Label.COD_JV_SSOEM_List.split(',')[0]);
        acc7.Name = 'Komatsu Test Account';
        acc7.Type = null;
        acc7.IAM_Primary_Market_Segment__c = 'Automotive';
        acc7.IAM_Service_Provider_Code__c='10006';
        acc7.CSS_DistributorCode__c='03526';
        accountList.add(acc7);
        
        Account acc8 = createAccount5('EBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc8.Type = 'National Account';
        acc8.BUSINESS_UNIT__c ='';
        acc8.CHANNEL_OF_DISTRIBUTION__c = '';
        acc8.IAM_Service_Provider_Code__c='10007';
        acc8.CSS_DistributorCode__c='03527';
        accountList.add(acc8);
       
        
        Account acc9 = createAccount5('', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc9.Type = 'National Account';
        acc9.BUSINESS_UNIT__c ='';
        acc9.CHANNEL_OF_DISTRIBUTION__c = '';
        acc9.IAM_Service_Provider_Code__c='10008';
        acc9.CSS_DistributorCode__c='03528';
        accountList.add(acc9);
        
        
         Account acc10 = createAccount5('PSBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc10.Type = 'National Account';
        acc10.BUSINESS_UNIT__c ='';
        acc10.CHANNEL_OF_DISTRIBUTION__c = '';
        acc10.IAM_Service_Provider_Code__c='10009';
        acc10.CSS_DistributorCode__c='03529';
        accountList.add(acc10);
        
        insert accountList;
        
        Test.startTest();
        List<id> finalIds = new List<id>();
        List<Account> accountList2 = [Select ID,Is_Training_Account__c,IAM_Service_Provider_Code__c,PSBU_Channel_of_Distribution__c,BillingCountry, EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c, Type, RecordTypeId, OSM_HHP_Dealer__c,EngineRangeDesc__c, Business_Unit__c,ccrz__E_AccountGroup__c, OSM_Market_Segment_Code__c, CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c, OSM_Service_Level__c,ServiceLevel__c,ParentId,CSS_DistributorCode__c FROM Account limit 5000];
        for(Account accid:accountList2){
            finalIds.add(accid.id);
        } 
        OSM_AccountGroupMapping_Helper.updateAccountGroup(finalIds);
        OSM_AccountGroupMapping_Helper.getChannelOfDistribution(accountList[0]);
         OSM_AccountGroupMapping_Helper.getChannelOfDistribution(accountList[1]);
         OSM_AccountGroupMapping_Helper.getChannelOfDistribution(accountList[2]);
         OSM_AutoPopulateAccount.updateAccountGroup(accountList);
         OSM_AccountGroupMapping_Helper.getCODByAccountRecordType(accountList[0]); 
        List<Account> accforassertList = [SELECT Id,ccrz__E_AccountGroup__r.Name,ccrz__E_AccountGroup__c FROM Account LIMIT 50];
        
        
        Test.stopTest();
    }
    
     
     @isTest
    public static void accountGroupMappingTrigger_test51()
    {
        createAccountGroup();
        List<id> accountIds = new List<id>();
        List<Account> accountList = new List<Account>();
        Account acc1 = createAccount4('EBU','DISTRIBUTOR-BRANCH');
        acc1.IAM_Primary_Market_Segment__c ='Mining';
        acc1.CMI_Account_Status__c='Cancelled';
        acc1.EBU_Channel_of_Distribution__c='DISTRIBUTOR-BRANCH';
        acc1.Type='Distributor Account';
        accountList.add(acc1);
        
        Account acc2 = createAccount4('','');
        //acc2.IAM_Primary_Market_Segment__c ='Oil & Gas';
        acc1.CMI_Account_Status__c='Cancelled';
        acc2.PSBU_Channel_of_Distribution__c='DISTRIBUTOR-BRANCH';
        acc2.EBU_Channel_of_Distribution__c='DISTRIBUTOR-BRANCH';
        acc2.Type='Distributor Account';
        accountList.add(acc2);
        
        Account acc3 = createAccount2('PSBU','');
        acc3.IAM_Primary_Market_Segment__c ='Railcar';
        acc3.PSBU_Channel_of_Distribution__c='DISTRIBUTOR-BRANCH';
        acc3.EBU_Channel_of_Distribution__c='';
        acc3.CHANNEL_OF_DISTRIBUTION__c = null;
        acc1.Type = 'Votech';
        accountList.add(acc3);
        Account acc4 = createAccount2('','');
        acc4.IAM_Primary_Market_Segment__c ='Bus';
        acc4.Type='Distributor Account';
        acc3.PSBU_Channel_of_Distribution__c='';
        acc3.EBU_Channel_of_Distribution__c='';
        acc3.Type='Distributor Account';
        accountList.add(acc4);
        insert accountList;
        
        Test.startTest();
        //OSM_AccountGroupMapping_Helper.runAccountGroupMappingManually();
        
        OSM_AccountGroupMapping_Helper.getCODByAccountRecordType(accountList[0]);
        OSM_AccountGroupMapping_Helper.getCODByAccountRecordType(accountList[1]);
        
        List<Account> accountList2 = [Select ID,Is_Training_Account__c,IAM_Service_Provider_Code__c,PSBU_Channel_of_Distribution__c,BillingCountry, EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c, Type, RecordTypeId, OSM_HHP_Dealer__c,EngineRangeDesc__c, Business_Unit__c,ccrz__E_AccountGroup__c, OSM_Market_Segment_Code__c, CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c, OSM_Service_Level__c,ServiceLevel__c,ParentId,CSS_DistributorCode__c FROM Account where id =: acc3.Id];
        accountList2[0].CHANNEL_OF_DISTRIBUTION__c = null;
                            accountList2[0].CMI_Account_Status__c = 'Cancelled';
        accountIds.add(accountList2[0].id);
        OSM_AccountGroupMapping_Helper.updateAccountGroup(accountIds);
        accountList2[0].CMI_Account_Status__c = 'Active';

        OSM_AccountGroupMapping_Helper.updateAccountGroup(accountIds);
        
        List<Account> accforassertList = [SELECT Id,ccrz__E_AccountGroup__r.Name,ccrz__E_AccountGroup__c FROM Account LIMIT 50];
        Test.stopTest();
    } 
    
    
}