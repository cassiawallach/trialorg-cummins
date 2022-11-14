public class CSS_addnlAuditTracking {
    
    public static void css_jobHistoryAddnlAuditTracking(list<CSS_Job_Order__c> newList,map<Id,CSS_Job_Order__c> oldMap){
		list<CSS_AddnlAudit__c> addnlAudit = [select id, object_API_Name__c, Field_API_Name__c, Audit__c 
                                              From CSS_AddnlAudit__c 
                                              Where object_API_Name__c = 'CSS_Job_Order__c' and 
                                                    audit__c=TRUE];
        list<CSS_JobHistory__c> jobHistoryToInsertList = new list<CSS_JobHistory__c>();
        for(CSS_Job_Order__c jobOrderRec : newList){
            if(addnlAudit != null && !addnlAudit.isEmpty()){
                for(CSS_AddnlAudit__c addAuditrec : addnlAudit){
                    if(oldMap.get(jobOrderRec.Id).get(addAuditrec.Field_API_Name__c) != jobOrderRec.get(addAuditrec.Field_API_Name__c)){
                        CSS_JobHistory__c jobHist = new CSS_JobHistory__c();
                        jobHist.CSS_Field_Name__c = addAuditrec.Field_API_Name__c;
                        jobHist.CSS_Job_Id__c = jobOrderRec.Id;
                        jobHist.CSS_New_Value__c = String.ValueOf(jobOrderRec.get(addAuditrec.Field_API_Name__c));
                        jobHist.CSS_Old_Value__c = String.ValueOf(oldMap.get(jobOrderRec.Id).get(addAuditrec.Field_API_Name__c));
                        jobHist.CSS_Object_Name__c = 'CSS_Job_Order__c';
                        jobHistoryToInsertList.add(jobHist);
                    }                    
                }
            }
        }
        if(jobHistoryToInsertList != null && !jobHistoryToInsertList.isEmpty()){
               CSS_utility.createJobhistory(jobHistoryToInsertList);
        }       
        
    }//end of Method css_jobHistoryAddnlAuditTracking

}