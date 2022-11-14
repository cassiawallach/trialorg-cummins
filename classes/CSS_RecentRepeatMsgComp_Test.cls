/**********************************************************************
Name:css_intake_job
Copyright © 2011  Cummins
======================================================
======================================================
Purpose: Test Class for ServiceHistory job                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Roopa G           30/3/2016      INITIAL DEVELOPMENT                    

***********************************************************************/

@IsTest(seealldata = true)
public class CSS_RecentRepeatMsgComp_Test {
   // public static Datetime newInstance(Integer year, Integer month, Integer day, Integer hour, Integer minute, Integer second) ;
    static testMethod void CSS_RecentRepeatMsgComp_Test(){
       Test.startTest();
        List<CSS_Job_Order__c> listJob1 = new List<CSS_Job_Order__c>();
        CSS_Job_Order__c newjob = new CSS_Job_Order__c();
        newjob.ESN__c='99999';
        //newjob.CreatedDate = System.now();
         DateTime dtCreatedTest = System.now().addDays(31);
       
        insert newjob;
      
        List<CSS_Job_Order__c> RecJobs;
        //DateTime lastDate1 = dtCreatedTest.addDays(30);  
        
        CSS_RecentRepeatMsgComp comp = new CSS_RecentRepeatMsgComp();
        CSS_RecentRepeatMsgComp.curESN = '99999'; 
        CSS_RecentRepeatMsgComp.dtCreated = dtCreatedTest;
        CSS_RecentRepeatMsgComp.getRepeatJobs();        
        CSS_RecentRepeatMsgComp.getRecentJobs();
       
        
        Test.stopTest();
    }
    
}