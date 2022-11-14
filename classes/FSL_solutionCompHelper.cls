/*************************************************************************************************
Name:FSL_solutionCompHelper 
Copyright Â© 2019  Cummins
===================================================================================================
===================================================================================================
Purpose: 
--------
This trigger helper is written for CSS_Solution_Component__c
Ravikanth: This class is used to delete SRT's and related parts when user uncheck the required to
perform on the availble field actions.
===================================================================================================
===================================================================================================
History
-------
VERSION  AUTHOR                     DATE
1.0     Ravikanth Macherla         02/24/2020
2.0     Mallika Subhashini         12/15/2019
3.0     Charan Teja                02/22/2021
****************************************************************************************************/
public class FSL_solutionCompHelper {
        public static void updateAccountCode(list<CSS_Solution_Component__c> lstcss){
        map<String,Id> mapAccCode = new map<String,Id>();
        map<Id,Id> mapCssAcc = new map<Id,Id>();
        for(CSS_Solution_Component__c objcss :lstcss){
            mapAccCode.put(objcss.FSL_Account_Code__c,objcss.Id);
        }
        system.debug('mallika testing####'+mapAccCode);
        List<FSL_Account_Code__c> fslAccCode = [SELECT Id,Name FROM FSL_Account_Code__c WHERE Name IN: mapAccCode.Keyset()];
        if(fslAccCode.size()>0){
        for(FSL_Account_Code__c accCode:fslAccCode){
            String accName = accCode.name;
            mapCssAcc.put(mapAccCode.get(accName),accCode.Id);
        }
            }
        for(CSS_Solution_Component__c objcss :lstcss){
            objcss.Account_Code__c = mapCssAcc.get(objcss.Id);
        }
    }
    
    // Added Ravikanth
    // Refactoring the code for 101 SOQL issue the BY Priyanka VGRS2-242
    public static void deleteSRTs(list<CSS_Solution_Component__c> lstCssComp, Map<Id,CSS_Solution_Component__c> OldMap,Map<Id,CSS_Solution_Component__c> MapSRT,List<FSL_SRT__c> srtList){
        //Map<Id,CSS_Solution_Component__c> MapSRT = new Map<Id,CSS_Solution_Component__c>();
        list<FSL_SRT__c> deleteSRT = new list<FSL_SRT__c>();
        /*for(CSS_Solution_Component__c objCSS : lstCssComp){
            if(!objCSS.Performed_Review__c && objCSS.Performed_Review__c != OldMap.get(objCSS.Id).Performed_Review__c){
                MapSRT.put(objCSS.id, objCSS);
            } 
        }*/
        if(MapSRT!=null){
            for(FSL_SRT__c objsrt : srtList){
                if(MapSRT.Containskey(objsrt.Component_Id__c)){
                    deleteSRT.add(objsrt);
                }
            }            
            if(deleteSRT.size()>0){
                //delete deleteSRT ;
                Database.delete(deleteSRT, false); //05/31/22 changes made for fieldactions Inline Editing NIN-179 by Naga Anusha
            } 
        } 
    }  
    //Added by Ravikanth For FSL SMN update
     public static void updateSMN(list<CSS_Solution_Component__c> lstcss){
       set<id> setFSLJob = new set<id>();
       map<id,WorkOrder> mapServiceOrder;
        for(CSS_Solution_Component__c objcss :lstcss){
             if(objcss.FSL_Service_Order__c != Null){
                  setFSLJob.add(objcss.FSL_Service_Order__c);
             }
               if(objcss.FSL_Service_Job__c!= Null){
                  setFSLJob.add(objcss.FSL_Service_Job__c);
             }
        }
        if(setFSLJob != Null && setFSLJob.size() > 0){
        mapServiceOrder = new map<id,WorkOrder>([select id,FSL_SMN__c from WorkOrder where id in :setFSLJob]);
        }
      for(CSS_Solution_Component__c objcss :lstcss){
          if(mapServiceOrder != Null && mapServiceOrder.containskey(objcss.FSL_Service_Order__c))
        {
                    objcss.FSL_SMN__c =  mapServiceOrder.get(objcss.FSL_Service_Order__c).FSL_SMN__c;//end by Ravikanth
        }     
      }
    }
    
    //added by vinod
    // Refactoring the code for 101 SOQL issue the BY Priyanka VGRS2-242
    public static void logAudits(List<CSS_Solution_Component__c> newList, Map<Id, CSS_Solution_Component__c> oldMap, Map<Id, FSL_Fail_Mode__c> failmodesmap)
    {
        Map<String, String> fieldAPIs = FSL_CumminsUtilities.getFieldAPIsMap('CSS_Solution_Component__c', 'FailureEditsForAuditTrail');
        if(!fieldAPIs.isEmpty()){
            sObject newSO, oldSO;
            List<FSL_Audit_Trail__c> auditsToInsert = new List<FSL_Audit_Trail__c>();
            FSL_Audit_Trail__c temp;
            Set<Id> failModes = new Set<Id>();
            
            for(CSS_Solution_Component__c cssSol : newList){
                failModes.add(cssSol.Fail_Mode__c);
            }
            // Refactoring the code for 101 SOQL issue the BY Priyanka VGRS2-242
            //Map<Id, FSL_Fail_Mode__c> failmodesmap = new Map<Id, FSL_Fail_Mode__c>([select id, name from FSL_Fail_Mode__c where id in :failModes]);
            for(CSS_Solution_Component__c cssSol : newList){
                 newSO = cssSol;
                oldSO = oldMap.get(cssSol.Id);
                for(String fA : fieldAPIs.keySet()){ 
                    /*List<CSS_Fault_Code__c> listObjFaultCode =  [SELECT Id,
                                                                        (SELECT Id from CSS_Solutions__r)
                                                                        FROM CSS_Fault_Code__c
                                                                        WHERE Id=:listObjCSSSolution[0].FaultCode__c LIMIT 1];
                    Integer size =  listObjFaultCode[0].CSS_Solutions__r.size();
                    
                    String eventDes = 'Updated verification : '+repairRadio+'\n'+'Comments : '+comments;
                    FSL_CumminsUtilities.auditTrailInsert('Event-20',woId,eventDes,listObjCSSSolution[0].FaultCode__r.Name,rank,listObjCSSSolution[0].Diagnostic_Response__c);*/
                    //String rank = newSO.get('FSL_Solution_Position__c')+' of '+ String.valueOf(size);
                    if(newSO.get(fA) <> oldSO.get(fA)){
                        String newVal = String.valueOf(newSO.get(fA));
                        String failurename;
                        failurename = cssSol.Failure_Value__c;
                        //Added CT3-277
                        String failmodename ='';
                        if(cssSol.FSL_Account_Code__c != null && cssSol.FSL_Account_Code__c != 'DISTRIBUTOR WARRANTY - DW' 
                            && failmodesmap != null && failmodesmap.size() > 0)
                        {
                            if(failmodesmap.get(cssSol.Fail_Mode__c) != null)
                                failmodename  = failmodesmap.get(cssSol.Fail_Mode__c).name;
                        }
                        
                        if(fa == 'Fail_Mode__c')
                        {
                            newVal = failmodename;
                        }
                        String eventDes = '';
                        eventDes = 'Updated ' + fieldAPIs.get(fA) + ' to: ' + newVal;
                        /*if(fA == 'FSL_Account_Code__c')
                            eventDes = 'Updated Account Code : '+newVal;//+'\n'+'Comments : '+comments;
                        else if(fa == 'Customer_Take_Possession__c')
                            eventDes='Updated Did the customer take possession of the part option to '+newVal;
                        else if(fa == 'Failure_Point__c')
                            eventDes='Updated Failure Date '+newVal;
                        else if(fa == 'Failure_Date__c')
                            eventDes='Updated Failure Point '+newVal;
                        else if(fa == 'Failure_Measure__c')
                            eventDes='Updated Failure Measure '+newVal;
                        else if(fa == 'Part_Warranty_Start_Date__c')
                            eventDes='Updated Part Warranty Start Date'+newVal;*/
                        temp = new FSL_Audit_Trail__c();
                        //String eventID, String serviceOrderId, String Description,String SymptomOrFaultCode,String Rank, String ServiceResponse, String Failures) {
                        temp = FSL_CumminsUtilities.getAuditTrailRecord('Event-22',String.valueOf(newSO.get('FSL_Service_Job__c')),eventDes,'','','', '');
                        temp.Entity_Name__c = 'CSS_Solution_Component__c';
                        temp.Failure_Name__c = failurename;
                        auditsToInsert.add(temp);
                                }
                }
                //auditsToInsert.add(())
            }
            if(!auditsToInsert.isEmpty())
                insert auditsToInsert;
        }
    }
    //ends
   
}