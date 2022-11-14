/************************************************************
Name:  IAM_AccountTriggerHandlerNew
Copyright © 2019  Cummins
=============================================================
Purpose:                                                            
Account trigger Handler for trigger implementation. Make sure that we are executing this trigger only for IAM record types and Internal recordt types.                       
// All Methods need to be filtered though record type since only IAM and WWSPS related record types need to trigger these flows.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -    Karthik Golakaram         05/19/2021        INITIAL DEVELOPMENT. 
********************************************************************************
********************************************************************************/ 
public class IAM_AccountTriggerHandlerNew extends TriggerHandler{

    public List<Account> TriggerNew;
    public List<Account> listAccAPIReg;
    public Map<id,Account> TriggerNewMap;
    public List<Account> TriggerOld;
    public Map<id,Account> TriggerOldMap;
    public static List<String> recordtypeNamesList= new List<String>();
    
    Public IAM_AccountTriggerHandlerNew() {
        this.setMaxLoopCount((Integer)TriggerHandler.triggerSettings[0].IAM_Loop_Count__c);
        //this.setMaxLoopCount(1);
        TriggerNew= new List<Account>();
        listAccAPIReg= new List<Account>();
        TriggerNewMap= new Map<id,Account>();
        TriggerOld= new List<Account>();
        TriggerOldMap= new Map<id,Account>();
        if(String.isNotBlank(TriggerHandler.triggerSettings[0].IAM_Record_Types_Names__c)){
            recordtypeNamesList=TriggerHandler.triggerSettings[0].IAM_Record_Types_Names__c.split(';');
        }else{
            //Default the values to IAM and WWSPS.
            recordtypeNamesList.add('01261000000X6tCAAS');
            recordtypeNamesList.add('0124N000000SgoJQAS');
        }
        
    
        //above variables need to be set for IAM record type only.
        //before insert will have trigger new only no map will be present.
        if(Trigger.New!=null&&!Trigger.New.isEmpty()){
            TriggerNew= getListOfAccounts((List<Account>)Trigger.New);
        }
    
        if(Trigger.NewMap!=null&&!Trigger.NewMap.isEmpty()){
            TriggerNewMap=getMapOfAccounts((Map<id,Account>)Trigger.NewMap);
        }
    
        if(Trigger.Old!=null&&!Trigger.Old.isEmpty()){
            TriggerOld=getListOfAccounts((List<Account>)Trigger.Old);
        }
    
        if(Trigger.OldMap!=null&&!Trigger.OldMap.isEmpty()){
            TriggerOldMap=getMapOfAccounts((Map<id,Account>)Trigger.OldMap);
        }
        //changes done as part of Connected solution web registration infant care issue.
        if(TriggerNew.size() > 0){
            listAccAPIReg = getAccList(TriggerNew);
        }
    }
    
    public override void beforeInsert(){
        System.debug('Printing before insert scenario');
    }
    
    //IAM Triggers are getting exected only on after insert
    public override void afterInsert(){
        System.debug('Printing after insert scenario');
        System.debug('Printing TriggerNew in after insert'+TriggerNew);
        if(!TriggerNew.isEmpty()){
            IAM_Account_Trigger_Handler.onAfterInsert(TriggerNew);
            IAM_CopyHQSubsciptionsOnCIHRLocation.copyHQLocationAppsonCIHR(TriggerNew, true, null, null);
            //commented calling out below method, as this logic is taken care in IAM_NewAccountRegistration class in createApplicationContPro method
            if(listAccAPIReg.size() > 0){
                IAM_Account_Trigger_Handler.createOsmSubcripcritiondefault(TriggerNew); //Nishant Verma D-3265 OSM
            }       
        }
    }
    
    public override void beforeUpdate(){
        System.debug('Printing before Update Scenario');
    }
    
    //IAM Triggers are getting exected only on after insert
    public override void afterUpdate(){
        System.debug('Printing after Update Scenario');
        System.debug('Printing TriggerNew in  after Update'+TriggerNew);
        System.debug('Printing TriggerNewMap in after Update'+TriggerNEwMap);
        System.debug('Printing TriggerOld in after Update'+TriggerOld);
        System.debug('Printing TriggerOldMap after Update'+TriggerOldMap);
        If(!TriggerNew.isEmpty()&&!TriggerNewMap.isEmpty()&&!TriggerOldMap.isEmpty()){
            IAM_CopyHQSubsciptionsOnCIHRLocation.copyHQLocationAppsOnCIHR(TriggerNew, false, TriggeroldMap, TriggernewMap);
        }
        If(!TriggerNew.isEmpty()&&!TriggerNewMap.isEmpty()&&!TriggerOldMap.isEmpty()&&!TriggerOld.isEmpty()){
            IAM_Account_Trigger_Handler.onAfterUpdate(TriggerNew,TriggerOld,TriggerNewMap,TriggerOldMap);
            //change for Guidanz Partner Dealer Automation
            IAM_Account_Trigger_Handler.guidanzDealerAutomation(TriggerNew,TriggerOldMap);
        }
        
    }
    
    
    public List<Account> getListOfAccounts(List<Account> accountsList){
        System.debug('Printing accounts List values recieved'+accountsList);
        List<Account> accountsListToReturn = new List<Account>();
        for(Account record: accountsList){
            System.debug('Printing record type Name'+record.RecordTypeId);
            System.debug('Prinitng record list values'+recordtypeNamesList);
            System.debug('Prinitng condition value is '+recordtypeNamesList.Contains(record.RecordTypeId));
            if(recordtypeNamesList.Contains(record.RecordTypeId)){
                if(!accountsListToReturn.Contains(record)){
                    accountsListToReturn.add(record);
                }
            }
        }
        System.debug('Printing return list of values'+accountsListToReturn);
        return accountsListToReturn;  
    }
    
    public Map<id,Account> getMapOfAccounts(Map<id,Account> accountsMap){
        Map<id,Account> accountsMapToReturn = new Map<id,Account>();
        for(id accountId: accountsMap.keySet()){
            if(recordtypeNamesList.Contains(accountsMap.get(accountId).RecordTypeId)){
                if(!accountsMapToReturn.ContainsKey(accountId)){
                    accountsMapToReturn.put(accountId,accountsMap.get(accountId));
                }
            }
        } 
        System.debug('Prinitng return map'+accountsMapToReturn);
        return accountsMapToReturn;
    }
        
        public List<Account> getAccList(List<Account> accountList){
            List<Account> apiAccountList = new List<Account>();
            for(Account accRec : accountList){
                if(accRec.IAM_from_Registration__c == false){
                    apiAccountList.add(accRec); 
                }
            }
            return apiAccountList;
        }
    
    }