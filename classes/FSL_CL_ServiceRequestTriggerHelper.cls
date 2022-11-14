/*****************************************************************************
Name: FSL_ServiceRequestTriggerHelper
Copyright Â© 2020  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is used to make the Service request record read-only
===================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            		DATE               DETAIL                                 
1.0      Mallika Subhashini 	02/26/2020         GFSLFM-2165
*****************************************************************************/
public with sharing class FSL_CL_ServiceRequestTriggerHelper {
    
    @future
    public static void AfterInsert(Set<Id> csId) {
        List<Case> caseList = [SELECT Id, RecordTypeId FROM Case WHERE Id =: csId];
        system.debug('**in handler class AfterInsert**');
        FSL_serviceReqShare.serviceReqRecShare(caseList);
    }
    
    //Added by sailaja, CT3-257 update Mileage, product hours  in the WO once updated from SR for IA type
    public static void afterUpdate(Map<Id,case> newMap, Map<Id,case> oldMap) {
        FSL_ServiceOrderUpdateForIA.updateServiceOrderForIAType(newMap,oldMap);
    }
    
    //Below method to change the owner ID of portal SR as per story CT4-759 
    public static void changeOwnerSPSR(list<Case> lstCase, Map<Id,Case> oldMap) {
        List<Case> serJobLst = new List<Case>();
        List<String> Locations = new List<String>();
        
        for(Case ul : lstCase) {
            Locations.add('SP' + '-' + ul.SR_Location_Code__c);
            system.debug('locations' + ' ' +locations);
        }
        
        List<Group> queues= [select id, Name from Group where Type='Queue' AND Name IN:Locations];
        system.debug('queues' + ' ' +queues);
        
        Map<string,ID> mapjobsSpecificLoc = new Map<string,ID>();
        
        for(Group q:queues){
            
            if(!mapjobsSpecificLoc.containsKey(q.Name)){
                mapjobsSpecificLoc.put(q.Name,q.id);
            }
            system.debug('mapjobsSpecificLoc-->'+mapjobsSpecificLoc);
        }
        
        for(Case cs: lstCase){
            if(cs != null && cs.SR_Location_Code__c !=null && cs.SR_Location_Code__c !='' && cs.Is_Created_From_Portal__c == true){
                cs.OwnerId  = mapjobsSpecificLoc.get('SP-'+cs.SR_Location_Code__c);
            }
        }
    }
 
}