/*
*Author: Sruthi
*Description: Handler class for CSS_SolutionsTrigger
*/
public class CSS_SolutionsTriggerHandler {
    
    //Method to assign sequence to the Fault Code record linked to the Solutions
    public static void assignSequence(List<CSS_Solutions__c> newList, Map<Id, CSS_Solutions__c> oldMap){
        
        Set<Id> faultCodeIds = new Set<Id>();
        Set<Id> workOrderIds = new Set<Id>();
        Map<Id, CSS_Fault_Code__c> fcByIdMap = new Map<Id, CSS_Fault_Code__c>();
        Map<Id, Integer> SeqByWOMap = new Map<Id, Integer>();
        List<CSS_Fault_Code__c> listToUpdate = new List<CSS_Fault_Code__c>();
        
        for(CSS_Solutions__c sol : newList){
            
            if(sol.Diagnostic_Response__c != NULL && sol.Diagnostic_Response__c != oldMap.get(sol.Id).Diagnostic_Response__c){
                if(sol.FaultCode__c != NULL){
                    
                    faultCodeIds.add(sol.FaultCode__c);
                }
            }
        }
        System.debug('---faultCodeIds'+faultCodeIds);
        if(!faultCodeIds.isEmpty()){
            
            for(CSS_Fault_Code__c  fcObj : [Select Id, Service_Order__c, EVL_Sequence__c from CSS_Fault_Code__c where Id IN : faultCodeIds]){
                
                if(fcObj.Service_Order__c != NULL && fcObj.EVL_Sequence__c == NULL){
                    workOrderIds.add(fcObj.Service_Order__c);
                    fcByIdMap.put(fcObj.Id, fcObj);
                }
            }
            System.debug('---fcByIdMap'+fcByIdMap);
            if(!workOrderIds.isEmpty()){
                
                for(CSS_Fault_Code__c childFc : [Select Id, EVL_Sequence__c, Service_Order__c from CSS_Fault_Code__c where Service_Order__c IN : workOrderIds AND ID NOT IN : fcByIdMap.KeySet() AND EVL_Sequence__c != NULL]){
                    if(SeqByWOMap.containsKey(childFc.Service_Order__c)){
                        
                        Integer i = SeqByWOMap.get(childFc.Service_Order__c);
                        if(childFc.EVL_Sequence__c > i){
                            SeqByWOMap.put(childFc.Service_Order__c, Integer.ValueOf(childFc.EVL_Sequence__c));
                        }
                    }
                    else{
                        SeqByWOMap.put(childFc.Service_Order__c, Integer.ValueOf(childFc.EVL_Sequence__c));
                    }
                }
            }
            
            for(CSS_Fault_Code__c fcObj : fcByIdMap.Values()){
                
                If(fcObj.EVL_sequence__c == NULL){
                    if(SeqByWOMap.containsKey(fcObj.Service_Order__c)){
                        
                        fcObj.EVL_sequence__c = SeqByWOMap.get(fcObj.Service_Order__c)+1;
                    }
                    else{
                        fcObj.EVL_sequence__c = 0;
                    }
                    listToUpdate.add(fcObj);
                }
            }
            
            if(!listToUpdate.isEmpty() && listToUpdate.size() > 0){
                update listToUpdate;
            }
        }
    }
    //Sruthi - Method to populate Control User when Troubleshooting is performed - Dealer
    public static void assignTakeControlOnWO(List<CSS_Solutions__c> newList){
        
        List<WorkOrder> woList = new List<WorkOrder>();
        
        Id userId = UserInfo.getUserId();
        Set<Id> woIds = new Set<Id>();
        
        for(CSS_Solutions__c sol : newList){
            
            if(sol.FSL_Service_Job__c != NULL && !woIds.contains(sol.FSL_Service_Job__c)){
                
                woIds.add(sol.FSL_Service_Job__c);
            }
        }
        if(!woIds.isEmpty()){
            for(WorkOrder wo : [Select Id, User__c, ServiceTerritoryId from WorkOrder where Id IN : woIds AND ServiceTerritoryId = NULL AND Type__c = 'Dealer']){
                wo.User__c = userId;
                woList.add(wo);
            }
        }
        if(!woList.isEmpty() && woList.size() > 0){
            update woList;
        }
    }
}