/**********************************************************************
Name:css_utility
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Global Functionality Class to handle reusable code modules  
			such as Create Job , Update Job, Create Solution ... etc
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Satish         0718/2016      INITIAL DEVELOPMENT                    

***********************************************************************/
public class css_functionality {

    public static void addToJobHistory(String objName,Id jobId,String fieldName,String oldVal,String newVal){
        CSS_JobHistory__c hist = new CSS_JobHistory__c();
        hist.CSS_Object_Name__c = objName;
        hist.CSS_Job_Id__c = jobId;        
        hist.CSS_Field_Name__c = fieldName;
        hist.CSS_Old_Value__c = oldVal;
        hist.CSS_New_Value__c = newVal;
        insert hist;
    }
}