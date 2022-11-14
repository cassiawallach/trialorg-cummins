/***********************************************************************************************
Name:FSL_CL_UpdateActualSRT
==============================================================================================
==============================================================================================
Purpose:                                                            
-------  
This class is to update actual srt time field for reason working ts.
==============================================================================================
==============================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE                                   
1.0         PiyushR                    08/07/2020                         
************************************************************************************************/ 
public class FSL_CL_UpdateActualSRT {

    public static void updateActualSRTFromTrigger(List<FSL_Timesheet__c> newTimesheets, Map<Id, FSL_Timesheet__c> oldTimesheetMap) {
        Set<Id> WOIds = new Set<Id>();
        Map<Id, FSL_SRT__c> SRTMap = new Map<Id, FSL_SRT__c>();
        
        for(FSL_Timesheet__c ts : newTimesheets) {
            if(ts.Service_Order__c != null && ts.Duration_hr__c != null) {
                WOIds.add(ts.Service_Order__c);
                SRTMap.put(ts.Service_Order__c, new FSL_SRT__c(Service_Order__c = ts.Service_Order__c, Actual_SRT_Time__c = null));
            }
        }
        
        if(!SRTMap.isEmpty()) {
            Map<Id,Double> mapTSTotalAmount = new Map<Id,Double>();
            
            for(AggregateResult agg: [SELECT Service_Order__c, SUM(Duration_hr__c) FROM FSL_Timesheet__c where Reason__c ='Working' AND Status__c != 'Invalid'
                                      AND Duration_hr__c NOT IN(0, NULL) AND Service_Order__c IN: SRTMap.keySet() GROUP BY Service_Order__c] )
            {
                mapTSTotalAmount.put((Id)agg.get('Service_Order__c'), (Double)agg.get('expr0'));
            }
            
            
            List<FSL_SRT__c> SRTList2Update = new List<FSL_SRT__c>();
            for(FSL_SRT__c srt : [Select ID, Service_Order__c, Actual_SRT_Time__c FROM FSL_SRT__c WHERE Service_Order__c IN : SRTMap.keySet() AND
                                 Name IN ('00-901-00','00-902-00','00-904-00')]) {
                Double TotalDuration = mapTSTotalAmount.get(srt.Service_Order__c);
                srt.Actual_SRT_Time__c = String.valueOf(TotalDuration);
                SRTList2Update.add(srt);
            }
            System.debug('$$$ SRTList2Update = '+SRTList2Update);
            try {
                update SRTList2Update;
            } catch(Exception ex) {
                System.debug('$$$ Exception in updateActualSRTFromTrigger() = '+ex.getStackTraceString());
            }
        }
        
    }
    
}