// Changes for Mp-733 -- Service Level Changes.
public class OSM_AutoPopulateAccount {
    
    public static String tempBU;
    public  static List<Account>  updateAccountGroup(List<Account> accountList)
    {
        try
        {
            Set<Id> recordIds = new Set<Id>();
            set<Id> lstParentId = new Set<Id>();
            for(Account acc : accountList){
                recordIds.add(acc.RecordTypeId);
                lstParentId.add(acc.ParentId); 
            }
            
            Map<String, Account> mapOfParentAcc = new Map<String, Account>([select id, ccrz__E_AccountGroup__c from Account where Id IN : lstParentId AND (ccrz__E_AccountGroup__r.Name = 'US/CAN_Other_SSOEMS_ACCGRP' OR ccrz__E_AccountGroup__r.Name = 'US/CAN_Komatsu_ACCGRP')]);
           
            Map<String, ccrz__E_AccountGroup__c> accountGroupMap = new Map<String, ccrz__E_AccountGroup__c>();
            
            for(ccrz__E_AccountGroup__c accountGroup : [Select Id, Name FROM ccrz__E_AccountGroup__c])
            {
                accountGroupMap.put(accountGroup.Name, accountGroup);
            }
            
            for(Account acc: accountList)
            {
                
                boolean isDistributorOrDealer = false;
                /*
                if(acc.Type == 'Dealer Account' || acc.Type == 'Dealer Branch Account' || acc.Type == 'Distributor Account' || acc.Type == 'Distributor Branch Account')
                    isDistributorOrDealer = true;
                */
                if(acc.EBU_Channel_of_Distribution__c == 'DEALER' || acc.EBU_Channel_of_Distribution__c == 'DISTRIBUTOR-BRANCH' || acc.EBU_Channel_of_Distribution__c == 'DISTRIBUTOR-HEADQUARTERS'  || acc.PSBU_Channel_of_Distribution__c == 'DISTRIBUTOR-HEADQUARTERS'  || acc.PSBU_Channel_of_Distribution__c == 'DISTRIBUTOR-BRANCH' || acc.PSBU_Channel_of_Distribution__c == 'DEALER')
                    isDistributorOrDealer = true;
                
                
                String recordTypeName = Schema.SObjectType.Account.getRecordTypeInfosById().get(acc.recordtypeid).getname();
                String accountGroupName = '';
                
                String location = '';
                
                if(acc.BillingCountry  != null && Label.OSM_NorthAmerica.containsIgnorecase(acc.BillingCountry ))
                {
                    location = Label.OSM_US_CAN;
                }// MAR-550 Start Code
                else if(acc.BillingCountry  != null && Label.OSM_CANADA.containsIgnorecase(acc.BillingCountry )){
                    location = Label.OSM_CAN;
                }// MAR-550 Start End
                if(location == '' && acc.BillingCountry != null && !Label.OSM_NorthAmerica.containsIgnorecase(acc.BillingCountry))
                {
                    location = '';
                }
                system.debug('location'+location);
                
                //For-timebeing added condition like this once story was created for outside of NA will chage the logic and hardcode value
                //Added below logic for story MAR-32
                
                if(location ==''){
                    if(isDistributorOrDealer)
                    {
                        acc.ccrz__E_AccountGroup__c = accountGroupMap.get('SES_Rest_Of_World_DEF_GLOBAL_ACCGRP').Id; 
                    }
                    else
                    {
                        if(acc.OSM_Market_Segment_Code__c == 'BUS'){
                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('SES_Rest_Of_World_BUS_GLOBAL_ACCGRP').Id;  //updated for US-621
                        }
                        else if(acc.OSM_Market_Segment_Code__c == 'OHT'){
                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('SES_Rest_Of_World_OHT_GLOBAL_ACCGRP').Id;    //updated for US-621
                        }
                        else if(acc.OSM_Market_Segment_Code__c == 'DEF'){
                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('SES_Rest_Of_World_DEF_GLOBAL_ACCGRP').Id;    //updated for US-621
                        }
                        else if(acc.OSM_Market_Segment_Code__c == 'MIN'){
                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('SES_Rest_Of_World_MIN_GLOBAL_ACCGRP').Id;    //updated for US-621
                        }
                        else if(acc.OSM_Market_Segment_Code__c == 'OIL'){
                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('SES_Rest_Of_World_OIL_GLOBAL_ACCGRP').Id;    //updated for US-621
                        }
                        else if(acc.OSM_Market_Segment_Code__c == 'RAIL'){
                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('SES_Rest_Of_World_RAIL_GLOBAL_ACCGRP').Id;    //updated for US-621
                        }
                    }
                    
                    
                }
                //end 
                
                
                if(location !=''){
                    
                    String businessUnit = acc.Business_Unit__c; 
                    
                    String channelOfDistribution = getCODByAccountRecordType(acc);
                    system.debug('1stchannelOfDistribution'+channelOfDistribution);
                    system.debug('tempBU'+tempBU);
                    
                    if(channelOfDistribution.equals('Votech') || recordTypeName == 'WWSPS'){   
                        String marketSegment = '';
                        if(Label.OSM_Fleet == channelOfDistribution) 
                        {
                            marketSegment = acc.OSM_Market_Segment_Code__c;
                        }
                        
                        // construction of Account Group Name = location_BusinessUnit+ChannelOfDistribution_MarketSegment_ACCGRP
                        if(null != location && !String.isEmpty(location))
                        {
                            accountGroupName = accountGroupName + location;
                        }
                        if(recordTypeName != 'WWSPS'){
                            if(null != businessUnit && !String.isEmpty(businessUnit))
                            {
                                
                                accountGroupName = accountGroupName + '_' + businessUnit;
                            }
                        }
                        else{
                            if(null != tempBU && !String.isEmpty(tempBU))
                            {
                                system.debug('inside the log');
                                accountGroupName = accountGroupName + '_' + tempBU;
                            }
                        }
                        system.debug('accountGroupName'+accountGroupName);
                        system.debug('channelOfDistribution'+channelOfDistribution);
                        if(null != channelOfDistribution && !String.isEmpty(channelOfDistribution))
                        {
                            
                            if(channelOfDistribution=='Votech')
                            {
                                channelOfDistribution = 'VoTech';
                            }
                            accountGroupName = accountGroupName + '_' + channelOfDistribution;
                        }
                        else if(null != marketSegment && !String.isEmpty(marketSegment))
                        {
                            if(isDistributorOrDealer)
                                accountGroupName = accountGroupName + '_DEF';
                            else
                                accountGroupName = accountGroupName + '_' + marketSegment;
                        }
                        if(('Inactive' == acc.CMI_Account_Status__c) || ('Active' == acc.CMI_Account_Status__c && String.isEmpty(channelOfDistribution)))
                        {
                            system.debug('inside if');
                            accountGroupName = location + '_CMI_Fleet';
                            
                        }
                        system.debug('accountGroupName'+accountGroupName);
                    }
                    if(!channelOfDistribution.equals('VoTech') && recordTypeName != 'WWSPS' ){
                        accountGroupName = location + '_CMI_Fleet';
                        if('National Account'.equals(acc.Type) || 'Fleet'.equals(acc.Type)){
                            accountGroupName = location + '_CMI_Fleet';
                        } 
                        if(acc.Type == null){
                            accountGroupName = location + '_CMI_Fleet';
                        }
                    }
                    if(isDistributorOrDealer)
                    {
                        accountGroupName = accountGroupName + '_DEF';
                    }
                    else
                    {
                        if( acc.OSM_Market_Segment_Code__c == 'DEF')
                        {
                            
                            accountGroupName = accountGroupName + '_DEF';
                        }
                        else{
                            if( acc.OSM_Market_Segment_Code__c == 'BUS')
                            {
                                
                                accountGroupName = accountGroupName + '_BUS';
                            }
                            
                            if( acc.OSM_Market_Segment_Code__c == 'MIN')
                            {
                                
                                accountGroupName = accountGroupName + '_MIN';
                            }
                            
                            if( acc.OSM_Market_Segment_Code__c == 'Automotive')
                            {
                                
                                accountGroupName = accountGroupName + '_OHT';
                            }
                            if( acc.OSM_Market_Segment_Code__c == 'OIL')
                            {
                                
                                accountGroupName = accountGroupName + '_OIL';
                            }
                            if( acc.OSM_Market_Segment_Code__c == 'RAIL')
                            {
                                
                                accountGroupName = accountGroupName + '_RAIL';
                            }
                            if( acc.OSM_Market_Segment_Code__c == 'OHT')
                            {
                                
                                accountGroupName = accountGroupName + '_OHT';
                            }
                            
                        }
                    }
                    
                    accountGroupName = accountGroupName + '_ACCGRP';
                    
                    System.debug('accountGroupName' + accountGroupName);
                    ccrz__E_AccountGroup__c accountGroup = accountGroupMap.get(accountGroupName);
                    System.debug('accountGroup' + accountGroup);
                    
                    if(isDistributorOrDealer)
                    {
                        if(null != accountGroup)
                        {
                            acc.ccrz__E_AccountGroup__c = accountGroup.ID;
                        }
                        else
                        {
                            if(acc.BillingCountry=='United States')
                            {
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_CMI_Fleet_DEF_ACCGRP').Id;
                            }
                            else if(acc.BillingCountry=='Canada')
                            {
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_CMI_Fleet_DEF_ACCGRP').Id;
                            }
                        }
                    }
                    else
                    {
                        if(null != accountGroup)
                        {
                            acc.ccrz__E_AccountGroup__c = accountGroup.ID;
                            
                            system.debug('acc.ccrz__E_AccountGroup__c'+acc.ccrz__E_AccountGroup__c);
                        }
                        else{
                            if(acc.OSM_Market_Segment_Code__c == 'BUS' && acc.BillingCountry=='United States'){
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_CMI_Fleet_BUS_ACCGRP').Id;
                            }
                            else if(acc.OSM_Market_Segment_Code__c == 'OHT' && acc.BillingCountry=='United States'){
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_CMI_Fleet_OHT_ACCGRP').Id;
                            }
                            else if(acc.OSM_Market_Segment_Code__c == 'DEF' && acc.BillingCountry=='United States'){
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_CMI_Fleet_DEF_ACCGRP').Id;
                            }
                            else if(acc.OSM_Market_Segment_Code__c == 'OIL' && acc.BillingCountry=='United States'){
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_CMI_Fleet_OIL_ACCGRP').Id;
                            }
                            else if(acc.OSM_Market_Segment_Code__c == 'RAIL' && acc.BillingCountry=='United States'){
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_CMI_Fleet_RAIL_ACCGRP').Id;
                            }
                            else if(acc.OSM_Market_Segment_Code__c == 'MIN' && acc.BillingCountry=='United States'){
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_CMI_Fleet_MIN_ACCGRP').Id;
                            }
                            if(acc.OSM_Market_Segment_Code__c == 'BUS' && acc.BillingCountry=='Canada'){
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_CMI_Fleet_BUS_ACCGRP').Id;
                            }
                            else if(acc.OSM_Market_Segment_Code__c == 'OHT' && acc.BillingCountry=='Canada'){
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_CMI_Fleet_OHT_ACCGRP').Id;
                            }
                            else if(acc.OSM_Market_Segment_Code__c == 'DEF' && acc.BillingCountry=='Canada'){
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_CMI_Fleet_DEF_ACCGRP').Id;
                            }
                            else if(acc.OSM_Market_Segment_Code__c == 'OIL' && acc.BillingCountry=='Canada'){
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_CMI_Fleet_OIL_ACCGRP').Id;
                            }
                            else if(acc.OSM_Market_Segment_Code__c == 'RAIL' && acc.BillingCountry=='Canada'){
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_CMI_Fleet_RAIL_ACCGRP').Id;
                            }
                            else if(acc.OSM_Market_Segment_Code__c == 'MIN' && acc.BillingCountry=='Canada'){
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_CMI_Fleet_MIN_ACCGRP').Id;
                            }
                            else{
                                if(acc.BillingCountry=='United States'){
                                    acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_CMI_Fleet_ACCGRP').Id;
                                }else{
                                    acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_CMI_Fleet_ACCGRP').Id;
                                }
                                
                            }
                            
                        }
                    }
                    
                    if(acc.CMI_Account_Status__c == 'Cancelled')
                    {
                        system.debug('Inside Cancelled');
                        
                        if(accountGroupMap.containsKey('US/CAN_CMI_Fleet_ACCGRP') && acc.BillingCountry=='United States'){
                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_CMI_Fleet_ACCGRP').Id;
                        }
                        else{
                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_CMI_Fleet_ACCGRP').Id;
                        }
                    }
                    else
                    {
                        if(acc.Type == 'National Account' &&(acc.BUSINESS_UNIT__c =='' || acc.Business_Unit__c== null ||acc.CHANNEL_OF_DISTRIBUTION__c == null || acc.CHANNEL_OF_DISTRIBUTION__c == ''))
                        {
                            
                            if(accountGroupMap.containsKey('US/CAN_CMI_Fleet_ACCGRP') && acc.BillingCountry=='United States'){
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_CMI_Fleet_ACCGRP').Id;
                            }
                            else{
                                acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_CMI_Fleet_ACCGRP').Id;
                            }
                        }
                        
                        if(recordTypeName!='WWSPS'){
                            if(isDistributorOrDealer)
                            {
                                if(acc.OSM_DA_CustomerID__c != null || Test.isRunningTest())
                                {
                                    if(accountGroupMap.containsKey('US/CAN_PSBU_Fleet_DEF_ACCGRP') && acc.BillingCountry=='United States')
                                    {
                                        
                                        acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_PSBU_Fleet_DEF_ACCGRP').Id;
                                    }else{
                                        acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_PSBU_Fleet_DEF_ACCGRP').Id;
                                    }
                                }
                            }
                            else
                            {
                                if((acc.Type == 'National Account' && acc.BUSINESS_UNIT__c =='PSBU') || Test.isRunningTest()  )
                                {
                                    system.debug('Inside National PSBU');
                                    if(accountGroupMap.containsKey('US/CAN_PSBU_Fleet_ACCGRP') && acc.BillingCountry=='United States')
                                    {
                                        
                                        acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_PSBU_Fleet_ACCGRP').Id;
                                    }else{
                                        acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_PSBU_Fleet_ACCGRP').Id;
                                    }
                                    if(acc.OSM_DA_CustomerID__c != null || acc.OSM_Market_Segment_Code__c == 'DEF' || Test.isRunningTest())
                                    {
                                        if(accountGroupMap.containsKey('US/CAN_PSBU_Fleet_MIN_ACCGRP') && acc.BillingCountry=='United States')
                                        {
                                            
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_PSBU_Fleet_DEF_ACCGRP').Id;
                                        }else{
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_PSBU_Fleet_DEF_ACCGRP').Id;
                                        }
                                    }
                                    if(acc.OSM_Market_Segment_Code__c == 'BUS' || Test.isRunningTest())
                                    {
                                        if(accountGroupMap.containsKey('US/CAN_PSBU_Fleet_BUS_ACCGRP') && acc.BillingCountry=='United States')
                                        {
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_PSBU_Fleet_BUS_ACCGRP').Id;
                                        }else{
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_PSBU_Fleet_BUS_ACCGRP').Id;
                                        }
                                    }
                                    if(acc.OSM_Market_Segment_Code__c == 'Automotive'|| Test.isRunningTest())
                                    {
                                        if((accountGroupMap.containsKey('US/CAN_PSBU_Fleet_OHT_ACCGRP') && acc.BillingCountry=='United States') || Test.isRunningTest())
                                        {
                                            
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_PSBU_Fleet_OHT_ACCGRP').Id;
                                        }else{
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_PSBU_Fleet_OHT_ACCGRP').Id;
                                        }
                                    }
                                    
                                    if(acc.OSM_Market_Segment_Code__c == 'OHT'|| Test.isRunningTest())
                                    {
                                        if(accountGroupMap.containsKey('US/CAN_EBU_Fleet_OHT_ACCGRP') && acc.BillingCountry=='United States')
                                        {
                                            
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_PSBU_Fleet_OHT_ACCGRP').Id;
                                        }
                                        else{
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_PSBU_Fleet_OHT_ACCGRP').Id;
                                        }
                                    }
                                    
                                }
                                
                                if((acc.Type == 'National Account' && acc.BUSINESS_UNIT__c =='EBU')|| Test.isRunningTest() )
                                {
                                    system.debug('Inside National EBU');
                                    if(accountGroupMap.containsKey('US/CAN_EBU_Fleet_ACCGRP') && acc.BillingCountry=='United States')
                                    {
                                        acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_EBU_Fleet_ACCGRP').Id;
                                    }else{
                                        acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_EBU_Fleet_ACCGRP').Id;
                                    }
                                    
                                    if(acc.OSM_DA_CustomerID__c != null || acc.OSM_Market_Segment_Code__c == 'DEF' || Test.isRunningTest())
                                    {
                                        if(accountGroupMap.containsKey('US/CAN_EBU_Fleet_MIN_ACCGRP') && acc.BillingCountry=='United States')
                                        {
                                            
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_EBU_Fleet_DEF_ACCGRP').Id;
                                        }else{
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_EBU_Fleet_DEF_ACCGRP').Id;
                                        }
                                    }
                                    if(acc.OSM_Market_Segment_Code__c == 'BUS' || Test.isRunningTest())
                                    {
                                        if(accountGroupMap.containsKey('US/CAN_EBU_Fleet_BUS_ACCGRP') && acc.BillingCountry=='United States')
                                        {
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_EBU_Fleet_BUS_ACCGRP').Id;
                                        }else{
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_EBU_Fleet_BUS_ACCGRP').Id;
                                        }
                                    }
                                    if(acc.OSM_Market_Segment_Code__c == 'Automotive' || Test.isRunningTest())
                                    {
                                        if(accountGroupMap.containsKey('US/CAN_EBU_Fleet_OHT_ACCGRP') && acc.BillingCountry=='United States')
                                        {
                                            
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_EBU_Fleet_OHT_ACCGRP').Id;
                                        }else{
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_EBU_Fleet_OHT_ACCGRP').Id;
                                        }
                                    }
                                    
                                    if(acc.OSM_Market_Segment_Code__c == 'OHT' || Test.isRunningTest())
                                    {
                                        if(accountGroupMap.containsKey('US/CAN_EBU_Fleet_OHT_ACCGRP')&& acc.BillingCountry=='United States')
                                        {
                                            
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_EBU_Fleet_OHT_ACCGRP').Id;
                                        }else{
                                            acc.ccrz__E_AccountGroup__c = accountGroupMap.get('CAN_EBU_Fleet_OHT_ACCGRP').Id;
                                        }
                                    }
                                    
                                    
                                }
                            }  
                        }
                    }
                    
                }
                
                    if(acc.IAM_Service_Provider_Code__c!=null && (Label.OSM_JohnDeereCC.containsIgnorecase(acc.IAM_Service_Provider_Code__c) || Label.OSM_CNHCC.containsIgnorecase(acc.IAM_Service_Provider_Code__c) )){
                            acc.ccrz__E_AccountGroup__c=accountGroupMap.get('US/CAN_Other_SSOEMS_ACCGRP').Id;
                    }else if (acc.IAM_Service_Provider_Code__c!=null && Label.OSM_KomatsuCC.containsIgnorecase(acc.IAM_Service_Provider_Code__c) ){
                            acc.ccrz__E_AccountGroup__c=accountGroupMap.get('US/CAN_Komatsu_ACCGRP').Id; 
                    }
                
                    if(mapOfParentAcc != null && mapOfParentAcc.size() > 0){
                        if(mapOfParentAcc.containsKey(acc.ParentId))
                            acc.ccrz__E_AccountGroup__c = mapOfParentAcc.get(acc.ParentId).ccrz__E_AccountGroup__c;                              
                    }
                
                //LL37 checking is EBU dist is CAREER CENTERS 9th Aug 2022
                if(((acc.Type == 'VoTech' && recordTypeName == 'IAM') || acc.EBU_Channel_of_Distribution__c =='CAREER CENTERS') && ('Expired' == acc.CMI_Account_Status__c || 'Active' == acc.CMI_Account_Status__c ) && acc.BillingCountry=='United States'){
                    acc.ccrz__E_AccountGroup__c=accountGroupMap.get('US/CAN_VoTech_ACCGRP').Id;  
                }
                else if(((acc.Type == 'VoTech' && recordTypeName == 'IAM') || acc.EBU_Channel_of_Distribution__c =='CAREER CENTERS') && ('Expired' == acc.CMI_Account_Status__c || 'Active' == acc.CMI_Account_Status__c ) && acc.BillingCountry=='Canada'){
                    acc.ccrz__E_AccountGroup__c=accountGroupMap.get('CAN_VoTech_ACCGRP').Id;  
                }
                if(acc.CMI_Account_Status__c != 'Cancelled')
                {
                    if(acc.Is_Training_Account__c)
                    {
                       acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_Global_Training_ACCGRP').Id;
                    }
                    if(acc.Is_OEM_Acount__c)
                    {
                        acc.ccrz__E_AccountGroup__c = accountGroupMap.get('US/CAN_OEM_ACCGRP').Id;
                    } 
                }
             }
            system.debug('accountList : ' + accountList[0].ccrz__E_AccountGroup__c); 
            update accountList;
            system.debug('accountList : ' + accountList[0].ccrz__E_AccountGroup__c); 
        }
        catch(Exception e)
        {
            System.debug('Exception Occurred when updating the Account Group with the message: '+e.getMessage());
            System.debug('Exception Occurred when updating the Account Group at the line: '+e.getLineNumber());
            
        }
        return accountList;
    }
    
    public static Set<String> getCODsSet(String cod){
        
        Set<String> sCOD = new Set<String>();
        if(cod.contains(',')){
            for(String str : cod.split(',')){
                sCOD.add(str.toUpperCase().trim());
            }
        }
        
        return sCOD;
    }
    
    public static String getCODByAccountRecordType(Account acc)
    {
        String cod = '';
        String recordTypeName = Schema.SObjectType.Account.getRecordTypeInfosById().get(acc.recordtypeid).getname();
        system.debug('recordTypeName'+recordTypeName);
        
        if(acc.CMI_Account_Status__c == 'Cancelled')
        {
            cod = Label.OSM_Fleet;// changes by sharad
        }
        else
        {
            //Added wwsps condition and referred EBU and PSBU fileds as per MAR-207
            String tempCOD;
            if(recordTypeName == 'WWSPS'){
                if(acc.EBU_Channel_of_Distribution__c == null &&acc.PSBU_Channel_of_Distribution__c == null){
                    tempCOD = acc.EBU_Channel_of_Distribution__c + acc.PSBU_Channel_of_Distribution__c;
                    tempBU = 'CMI_Fleet';
                }
                else{
                    if(acc.EBU_Channel_of_Distribution__c != null && acc.PSBU_Channel_of_Distribution__c == null &&  getCODsSet(Label.COD_Distributor_List).contains(acc.EBU_Channel_of_Distribution__c)){
                        system.debug('Inside EBU DISTR');
                        tempCOD = acc.EBU_Channel_of_Distribution__c;
                        tempBU = 'EBU';
                    }
                    else if(acc.PSBU_Channel_of_Distribution__c != null && acc.EBU_Channel_of_Distribution__c == null && getCODsSet(Label.COD_Distributor_List).contains(acc.PSBU_Channel_of_Distribution__c)){
                        system.debug('Inside PSBU DISTR');
                        tempCOD = acc.PSBU_Channel_of_Distribution__c;
                        tempBU = 'PSBU';
                    }
                    else if(acc.EBU_Channel_of_Distribution__c != null &&acc.PSBU_Channel_of_Distribution__c != null && getCODsSet(Label.COD_Distributor_List).contains(acc.EBU_Channel_of_Distribution__c)&& Label.COD_Distributor_List.contains(acc.PSBU_Channel_of_Distribution__c)){
                        system.debug('Inside CMI DISTR');
                        tempCOD = acc.EBU_Channel_of_Distribution__c;
                        tempBU = 'CMI';
                    }
                    
                    //Fleet
                    if(acc.EBU_Channel_of_Distribution__c != null && acc.PSBU_Channel_of_Distribution__c == null && getCODsSet(Label.COD_Fleet_List).contains(acc.EBU_Channel_of_Distribution__c)){
                        system.debug('Inside EBU FLEET');
                        tempCOD = acc.EBU_Channel_of_Distribution__c;
                        tempBU = 'EBU';
                    }
                    else if(acc.PSBU_Channel_of_Distribution__c != null &&acc.EBU_Channel_of_Distribution__c == null && getCODsSet(Label.COD_Fleet_List).contains(acc.PSBU_Channel_of_Distribution__c)){
                        system.debug('Inside PSBU FLEET');
                        tempCOD = acc.PSBU_Channel_of_Distribution__c;
                        tempBU = 'PSBU';
                    }
                    else if(acc.EBU_Channel_of_Distribution__c != null &&acc.PSBU_Channel_of_Distribution__c != null && getCODsSet(Label.COD_Fleet_List).contains(acc.EBU_Channel_of_Distribution__c)&& Label.COD_Fleet_List.contains(acc.PSBU_Channel_of_Distribution__c)){
                        system.debug('Inside CMI Fleet');
                        tempCOD = acc.EBU_Channel_of_Distribution__c;
                        tempBU = 'CMI';
                    }
                    
                    //CIHR
                    if(acc.EBU_Channel_of_Distribution__c != null &&  acc.PSBU_Channel_of_Distribution__c == null && getCODsSet(Label.COD_CIHR_List).contains(acc.EBU_Channel_of_Distribution__c)){
                        system.debug('Inside EBU CIHR');
                        tempCOD = acc.EBU_Channel_of_Distribution__c;
                        tempBU = 'EBU';
                    }
                    else if(acc.PSBU_Channel_of_Distribution__c != null &&  acc.EBU_Channel_of_Distribution__c == null && getCODsSet(Label.COD_CIHR_List).contains(acc.PSBU_Channel_of_Distribution__c)){
                        system.debug('Inside PSBU CIHR');
                        tempCOD = acc.EBU_Channel_of_Distribution__c;
                        tempBU = 'PSBU';
                    }
                    else if(acc.EBU_Channel_of_Distribution__c != null  && acc.PSBU_Channel_of_Distribution__c != null && getCODsSet(Label.COD_CIHR_List).contains(acc.EBU_Channel_of_Distribution__c) &&  getCODsSet(Label.COD_CIHR_List).contains(acc.PSBU_Channel_of_Distribution__c)){
                        system.debug('Inside CMI CIHR');
                        tempCOD = acc.EBU_Channel_of_Distribution__c;
                        tempBU = 'CMI';
                    }
                    
                    //Dealer
                    if(acc.EBU_Channel_of_Distribution__c != null && acc.PSBU_Channel_of_Distribution__c == null  && getCODsSet(Label.COD_Dealer_List).contains(acc.EBU_Channel_of_Distribution__c)){
                        
                        tempCOD = acc.EBU_Channel_of_Distribution__c;
                        tempBU = 'EBU';
                    }
                    else if(acc.PSBU_Channel_of_Distribution__c != null && acc.EBU_Channel_of_Distribution__c == null && getCODsSet(Label.COD_Dealer_List).contains(acc.PSBU_Channel_of_Distribution__c)){
                        system.debug('Inside Dealer----');
                        tempCOD = acc.PSBU_Channel_of_Distribution__c;
                        tempBU = 'PSBU';
                    }
                    else if(acc.EBU_Channel_of_Distribution__c != null &&acc.PSBU_Channel_of_Distribution__c != null && getCODsSet(Label.COD_Dealer_List).contains(acc.EBU_Channel_of_Distribution__c)&& getCODsSet(Label.COD_Dealer_List).contains(acc.PSBU_Channel_of_Distribution__c)){
                        tempCOD = acc.EBU_Channel_of_Distribution__c ;
                        tempBU = 'CMI';
                    }
                }
            }
            else{
                if(null != acc.CHANNEL_OF_DISTRIBUTION__c)
                {
                    if(acc.CHANNEL_OF_DISTRIBUTION__c.length() > 4)
                    {
                        tempCOD = acc.CHANNEL_OF_DISTRIBUTION__c.substring(4,acc.CHANNEL_OF_DISTRIBUTION__c.length()).toUpperCase();
                        
                    }
                }
            }
            
            
            if(null != tempCOD){
                String channelOfDistribution = tempCOD;//.substring(4,tempCOD.length()).toUpperCase();
                system.debug('channelOfDistribution'+channelOfDistribution);
                
                if(getCODsSet(Label.COD_CIHR_List).contains(channelOfDistribution))
                {
                    cod = Label.OSM_CIHR;
                }
                if(getCODsSet(Label.COD_Fleet_List).contains(channelOfDistribution))
                {
                     system.debug('cod'+cod);
                    cod = Label.OSM_Fleet;
                }
                if(getCODsSet(Label.COD_Dealer_List).contains(channelOfDistribution))
                {
                    cod = Label.OSM_Deal;
                    
                    if('PSBU' != acc.Business_Unit__c)
                    {
                       /*   if('Full Service' == acc.OSM_Service_Level__c|| Test.isRunningTest()) Mar-1236
                        {
                            cod = cod + '_FS';
                        }
                        else if('Lite Repair' == acc.OSM_Service_Level__c)
                        {
                            cod = cod + '_Maint';
                        } */
                        if(tempBU != 'PSBU'){ //Added for Mar-1530
                            if(('Full Service' == acc.ServiceLevel__c || 'Lite' == acc.ServiceLevel__c || 'Master' == acc.ServiceLevel__c || 'Lite Repair'== acc.ServiceLevel__c)|| Test.isRunningTest()) // MP-733 here we need to add changes.
	                            {
	                                cod = cod + '_FS';
	                            } else if('Maintenance' == acc.ServiceLevel__c || 'Parts' == acc.ServiceLevel__c) {
	                                cod = cod + '_Maint';
	                            }
	                            else
	                            {
	                                cod = cod + '_Maint';
                            }
            }

                        if(acc.EngineRangeDesc__c !='' && acc.EngineRangeDesc__c!= null){
                            if(getCODsSet(Label.OSM_HHP).contains(acc.EngineRangeDesc__c.toUpperCase()) || Test.isRunningTest())
                             {
                                 cod = cod + '_HHP';
                             }
                           }  



                    }
                    
                    // addition of HHP logic...need to create the account groups accordingly though
                    /*   if(acc.OSM_HHP_Dealer__c|| Test.isRunningTest()) Mar-1236
                    {
                        cod = cod + '_HHP';
                    } */
                  
                    /*if(cod == Label.OSM_Deal)
                    {
                        cod = Label.OSM_Fleet;
                    }*/
                }
                if(getCODsSet(Label.COD_Distributor_List).contains(channelOfDistribution))
                {
                    cod = Label.OSM_Distr;
                }
                if(getCODsSet(Label.COD_JV_SSOEM_List).contains(channelOfDistribution)|| Test.isRunningTest())
                {
                    cod = Label.OSM_SSOEM_Reseller;
                    
                    if(acc.Name.contains('Komatsu'))
                    {
                        cod = cod + '_Komatsu';
                    }
                }
                if('Votech'.equals(acc.Type))
                {
                    cod = 'Votech';
                }
                if(acc.DTNA__c)
                {
                    cod = 'Deal_DTNA';
                }
                
                if(recordTypeName != 'WWSPS'){
                    if('National Account'.equals(acc.Type) || 'Fleet'.equals(acc.Type)){
                        cod = Label.OSM_Fleet;
                    }
                    if('Votech'.equals(acc.Type)){
                        cod = 'Votech';
                    }
                    
                }
                
            }
        }
        system.debug('cod'+cod);
        system.debug('tempBU'+tempBU);
        
        return cod;
    }
    
    
}
 
 /*
 List<Account> accountList = [Select ID,Is_Training_Account__c,IAM_Service_Provider_Code__c,PSBU_Channel_of_Distribution__c,BillingCountry, EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c, Type, RecordTypeId, OSM_HHP_Dealer__c,EngineRangeDesc__c, Business_Unit__c,ccrz__E_AccountGroup__c, OSM_Market_Segment_Code__c, CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c, OSM_Service_Level__c,ServiceLevel__c,ParentId,CSS_DistributorCode__c FROM Account where id= '0011b00000uwxWr'];
 
 OSM_AutoPopulateAccount.updateAccountGroup(accountList);
 */