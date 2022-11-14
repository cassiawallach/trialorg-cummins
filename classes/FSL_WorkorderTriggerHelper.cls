/**********************************************************************
Name: FSL_WorkorderTriggerHelper
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
1.0 - Vinod Yelala      02/13/2020     INITIAL DEVELOPMENT     Created apex class for Mapping the 4cs from the CSS_JobHistory__c              
***********************************************************************/
   public class FSL_WorkorderTriggerHelper {     
    public static void updateFourCs(list<WorkOrder> mapOldWorkorder, map<id,WorkOrder> mapOldServiceorder){
        list<CSS_JobHistory__c> lstjobhistory = new list<CSS_JobHistory__c>();
        CSS_JobHistory__c hist;
        //looping the new list 
        for(WorkOrder Wo : mapOldWorkorder){
          
            if(Wo.EditComplaint__c != mapOldServiceorder.get(Wo.id).EditComplaint__c){
                CSS_JobHistory__c compHis = createJobhistoryRecord('WorkOrder',Wo.id,'EditComplaint__c',mapOldServiceorder.get(Wo.id).EditComplaint__c,Wo.EditComplaint__c);
                if(compHis != null){
                    lstjobhistory.add(compHis);
                }
            }
            if(Wo.EditCause__c != mapOldServiceorder.get(Wo.id).EditCause__c){
                CSS_JobHistory__c causeHis = createJobhistoryRecord('WorkOrder',Wo.id,'EditCause__c',mapOldServiceorder.get(Wo.id).EditCause__c,Wo.EditCause__c);  
                if(causeHis != null){
                    lstjobhistory.add(causeHis);
                }
            } 
            if(Wo.EditCorrection__c != mapOldServiceorder.get(Wo.id).EditCorrection__c){
                CSS_JobHistory__c correctionHis = createJobhistoryRecord('WorkOrder',Wo.id,'EditCorrection__c',mapOldServiceorder.get(Wo.id).EditCorrection__c,Wo.EditCorrection__c);  
                if(correctionHis != null){
                    lstjobhistory.add(correctionHis);
                }
            }
            if(Wo.EditCoverage__c != mapOldServiceorder.get(Wo.id).EditCoverage__c){
                CSS_JobHistory__c coverageHis = createJobhistoryRecord('WorkOrder',Wo.id,'EditCoverage__c',mapOldServiceorder.get(Wo.id).EditCoverage__c,Wo.EditCoverage__c);  
                if(coverageHis != null){
                    lstjobhistory.add(coverageHis);
                }
            }
            
        }
        
        if(!lstjobhistory.isEmpty()){
            insert lstjobhistory;
        }
    }
    
    public static CSS_JobHistory__c createJobhistoryRecord(String objName,Id jobId,String fieldName,String oldVal,String newVal){
        
        CSS_JobHistory__c hist = new CSS_JobHistory__c();
        hist.CSS_Object_Name__c = objName;
        hist.CSS_Job_Id__c = jobId;        
        hist.CSS_Field_Name__c = fieldName;
        hist.CSS_Old_Value__c = oldVal;
        hist.CSS_New_Value__c = newVal;
        
        return hist;
    } 
    
}