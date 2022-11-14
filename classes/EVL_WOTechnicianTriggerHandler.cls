/*****************************************************************************
Name: EVL_WOTechnicianTriggerHandler
===========================================================================
===========================================================================
Purpose:                                                            
-------  
============================================================================
============================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - 
******************************************************************************/
public class EVL_WOTechnicianTriggerHandler {
    public static void deleteSharedRecord(List<Work_Order_Technicians__c> oldList) {
        set<Id> relatedtTechnicians = new set<Id>();
        set<Id> woIds = new set<Id>();
        set<Id> WOTechnicians = new set<Id>();
        for (Work_Order_Technicians__c tec : oldList) {
            WOTechnicians.add(tec.Id);
            relatedtTechnicians.add(tec.user__c);
            woIds.add(tec.Service_Order__c);
        }
      
        List<Case> cases = [Select Id From Case where ServiceJob__c IN: woIds];
        List<WorkOrderShare> woShares = [Select Id FROM WorkOrderShare where parentId IN: woIds AND UserOrGroupId IN: relatedtTechnicians];
        List<CaseShare> caseShares = [Select Id FROM CaseShare where CaseId IN: cases AND UserOrGroupId IN: relatedtTechnicians];
        
        delete woShares;
        delete caseShares;
        system.debug('++wo'+  woShares );
        system.debug('++Case'+  caseShares );
         system.debug('++caseIds'+  cases );
        
        List<Work_Order_Technicians__c> woTechiciansRecords=[Select id,Name,Service_Order__r.CaseId From Work_Order_Technicians__c 
                                                             where Service_Order__c =: woIds];
        System.debug('++caseUpdate'+  woTechiciansRecords);
        
        map<Id, String> mapCasetoAssignTo = new map<Id,String>();
        for(Work_Order_Technicians__c wot : woTechiciansRecords){
            String CaseId = wot.Service_Order__r.CaseId;
            if(!mapCasetoAssignTo.containskey(CaseId)){
                mapCasetoAssignTo.put(CaseId,wot.Name);
            }
            else{
                String assignTo = mapCasetoAssignTo.get(CaseId);
                assignTo = assignTo +','+wot.Name;
                mapCasetoAssignTo.put(CaseId,assignTo);
            }
        }
        
        System.debug('++mapCasetoAssignTo'+  mapCasetoAssignTo);

        List<Case> caseUpdate = new List<Case>();
        for(Case icase : cases)
        {
            Case caseRecord =new Case();
            caseRecord.id = icase.Id;
            caseRecord.Assigned_to__c = '';
            if(mapCasetoAssignTo.containskey(icase.Id))
            {
                caseRecord.Assigned_to__c=mapCasetoAssignTo.get(icase.Id);
            }
            caseUpdate.add(caseRecord);
        }	
        System.debug('++caseUpdate'+  caseUpdate);
        if(caseUpdate.size() > 0) UPDATE caseUpdate;
    }
    
    
    //By Priyanka VGRS2-43
    public static void deleteSOCLose(List<Work_Order_Technicians__c> oldList) {
       map<Id,Work_Order_Technicians__c> woTechMap = new  map<Id,Work_Order_Technicians__c>([Select Service_Order__c,Service_Order__r.Status From Work_Order_Technicians__c 
                                                             where Id in: oldList]);
         for(Work_Order_Technicians__c tech : oldList)
         {
            
             if(woTechMap.get(tech.Id).Service_Order__c != null && woTechMap.get(tech.Id).Service_Order__r.Status == 'Closed')
             {
                 tech.addError(System.Label.EVL_Close_Lock);
             }
         }
     }
         
       
}