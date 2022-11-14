/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          01/03/2021      Test Class Fixes
 */
@istest
public class OSM_AutopopulateAccountGroups_Test {
    
 
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
   
     public static Account createAccount(String businessUnit, String channelOfDistribution)
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
        //system.debug('createAccount22'+acc);
    }
    
    @isTest
    public static void accountGroupMapping_test1()
    {
        createAccountGroup();
        
        List<Account> accountList = new List<Account>();
        
        
        Account acc1 = createAccount('EBU', Label.COD_CIHR_List.split(',')[0].substring(0,4) + Label.COD_CIHR_List.split(',')[0]); 
        acc1.Type = 'Votech';
        acc1.OSM_Accountgroupbatch__c=true;
        accountList.add(acc1);
        
        // need to add market segment for FLEET
        Account acc2 = createAccount('EBU', Label.COD_Fleet_List.split(',')[0].substring(0,4) + Label.COD_Fleet_List.split(',')[0]);
        acc2.IAM_Primary_Market_Segment__c = 'Bus';
        acc2.Type = 'Fleet';
        acc2.OSM_Accountgroupbatch__c=true;
        accountList.add(acc2);
        
        
        Account acc3a = createAccount('EBU', Label.COD_Dealer_List.split(',')[0].substring(0,4) + Label.COD_Dealer_List.split(',')[0]);
        //acc3a.OSM_Service_Level__c = 'Lite Repair';
        acc3a.ServiceLevel__c = 'Lite Repair';
        acc3a.OSM_Accountgroupbatch__c=true;
        accountList.add(acc3a);
        
        
        Account acc4 = createAccount('EBU', Label.COD_Distributor_List.split(',')[0].substring(0,4) + Label.COD_Distributor_List.split(',')[0]);
        acc4.Type = 'National Account';
        acc4.OSM_Accountgroupbatch__c=true;
        accountList.add(acc4);
        
        Account acc5 = createAccount('EBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc5.Type = 'National Account';
        acc5.BUSINESS_UNIT__c ='PSBU';
        acc5.IAM_Primary_Market_Segment__c = 'Automotive';
        acc5.OSM_Accountgroupbatch__c=true;
        accountList.add(acc5);
        
        Account acc6 = createAccount('EBU', '');
        //acc6.CMI_Account_Status__c = 'Inactive';
        acc6.IAM_Primary_Market_Segment__c = 'BUS';
        acc6.OSM_Accountgroupbatch__c=true;
        accountList.add(acc6);
        
        Account acc7 = createAccount('EBU', Label.COD_JV_SSOEM_List.split(',')[0]);
        acc7.Name = 'Komatsu Test Account';
        acc7.Type = null;
        acc7.IAM_Primary_Market_Segment__c = 'Automotive';
        acc7.OSM_Accountgroupbatch__c=true;
        accountList.add(acc7);
        
        Account acc8 = createAccount('EBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc8.Type = 'National Account';
        acc8.BUSINESS_UNIT__c ='';
        acc8.CHANNEL_OF_DISTRIBUTION__c = '';
        acc8.OSM_Accountgroupbatch__c=true;
        
        accountList.add(acc8);
        
        Account acc12 = createAccount('EBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc12.Type = 'National Account';
        acc12.BUSINESS_UNIT__c ='EBU';
        acc12.OSM_DA_CustomerID__c='080jkjoioiu';
        acc12.OSM_Accountgroupbatch__c=true;
        
        accountList.add(acc12);
        
        
        Account acc9 = createAccount('', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc9.Type = 'National Account';
        acc9.BUSINESS_UNIT__c ='';
        acc9.CHANNEL_OF_DISTRIBUTION__c = '';
        accountList.add(acc9);
        
        
        Account acc10 = createAccount('PSBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc10.Type = 'National Account';
        acc10.BUSINESS_UNIT__c ='';
        acc10.CHANNEL_OF_DISTRIBUTION__c = '';
        acc10.OSM_Accountgroupbatch__c=true;
        accountList.add(acc10);
        
        
        Account acc11 = createAccount('PSBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        acc11.Type = 'National Account';
        acc11.BUSINESS_UNIT__c ='PSBU';
        acc11.OSM_DA_CustomerID__c='080jkjoioiu';
        acc11.OSM_Accountgroupbatch__c=true;
        accountList.add(acc11);
        
        
        
        Account acc13 = createAccount('PSBU', Label.COD_SIR_List.split(',')[0].substring(0,4) + Label.COD_SIR_List.split(',')[0]);
        //acc13.CMI_Account_Status__c='cancelled';
        acc13.Type = 'National Account';
        acc13.BUSINESS_UNIT__c ='PSBU';
        acc13.IAM_Primary_Market_Segment__c='BUS';
        acc13.OSM_Accountgroupbatch__c=true;
        accountList.add(acc13);
        
        
        insert accountList;
        system.debug('accountList'+accountList);
        List<Account> accountList2 = [Select ID,IAM_Service_Provider_Code__c,PSBU_Channel_of_Distribution__c,BillingCountry, EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c, Type, RecordTypeId, OSM_HHP_Dealer__c, Business_Unit__c,ccrz__E_AccountGroup__c, OSM_Market_Segment_Code__c, CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c, ServiceLevel__c,OSM_Service_Level__c,ParentId FROM Account];
        
         Test.startTest();

            OSM_AutopopulateAccountGroups obj = new OSM_AutopopulateAccountGroups();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }

}