/**********************************************************************
Name: FSL_ServiceResourceTriggerHandler
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      11/10/2019      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSL_ServiceResourceTriggerHandler {
    
    public static void beforeInsertTrigger(List<ServiceResource> newSR) {
        
    }
    
    public static void beforeUpdateTrigger(List<ServiceResource> newSR, Map<Id, SObject> oldSRMap) {
        runServiceResourceActiveFlagChange(newSR, oldSRMap);
    }
    
    public static void runServiceResourceActiveFlagChange(List<ServiceResource> newSR, Map<Id, SObject> oldSRMap) {
        ServiceResource oldSR;
        Map<Id, ServiceResource> activeFlagChangedSRs;
        for(ServiceResource sr : newSR) {
            oldSR = (ServiceResource)oldSRMap.get(sr.Id);
            if(!sr.IsActive && oldSR.isActive != sr.IsActive) {
                if(activeFlagChangedSRs == null)
                    activeFlagChangedSRs = new Map<Id, ServiceResource>{sr.Id => sr};
                        else
                        activeFlagChangedSRs.put(sr.Id, sr);
            }
        }
        if(activeFlagChangedSRs != null && !activeFlagChangedSRs.isEmpty()) {
            Map<Id, Integer> openSACntMap = new Map<Id, Integer>();
            List<AggregateResult> aggr = [SELECT count(Id), ServiceResourceId FROM AssignedResource 
                                          WHERE ServiceResourceId in :activeFlagChangedSRs.keySet() 
                                          AND ServiceAppointment.Status <> 'Completed' GROUP BY ServiceResourceId];
            for(AggregateResult ag : aggr) {
                openSACntMap.put((Id)ag.get('ServiceResourceId'), (Integer)ag.get('expr0'));
            }
            Integer openSACount;
            for(ServiceResource sr : activeFlagChangedSRs.values()) {
                if(openSACntMap.containsKey(sr.Id) && openSACntMap.get(sr.Id) > 0)
                    sr.addError(System.Label.FSLServiceResourceActiveFlagChangeAlert);
            }
        }
    }
}