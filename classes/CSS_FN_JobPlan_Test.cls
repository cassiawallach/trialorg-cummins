/**********************************************************************
Name:CSS_FN_JobPlan_Test
Copyright © 2011  Cummins
=======================================================================
=======================================================================
Purpose:                                                            
To perform all the Functionalties of Job Plan                                                          
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE             DETAIL                                 
  1.0      Venkat G         12/30/2016        INITIAL DEVELOPMENT
***********************************************************************/
@istest
public class CSS_FN_JobPlan_Test {
    public static testmethod void updateCause_Method(){
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(True);
        CSS_Solutions__c solPer = CSS_TestData.createSolutions(true,jo.id);
    CSS_Solutions__c sol = CSS_TestData.createSolutions(true,jo.id);
        sol.CSS_Nested_Solutions__c = solPer.Id;
        update sol;
        test.startTest();
        CSS_Solution_Component__c solCompNew = CSS_TestData.createSRT(True,jo.id,solPer.id);
        CSS_Solution_Component__c solComp = CSS_TestData.createSRT(True,jo.id,sol.id);
        List<CSS_Solutions__c> lstsol = new  List<CSS_Solutions__c>();
        lstsol.add(sol);
        List<Id> lstId = new List<Id>();
        lstId.add(solPer.Id);
        List<CSS_Solutions__c> cjh=[Select Id, Name,Solution_Title__c, Service_Job__c, Rank__c,DSID__c,
                        Diagnostic_notes__c, Diagnostic_Response__c, FaultCode__c,(select Id,Name,Action__c,Component_Id__c, Solutions__c,Quantity__c,Selected_Component__c,Charlength__c, Service_Job__c from CSS_Solution_Components__r)
                        from CSS_Solutions__c where Id = :solPer.id and CSS_Nested_Solutions__c = null];
      /*  CSS_Solutions__c sol1 =  CSS_TestData.createSolutions(false,jo.Id);
        sol1.CSS_Nested_Solutions__c = jo.Id;
        lstsol.add(sol1);
        update sol1;*/
        
         List<CSS_Solutions__c> NestedSOls=[Select Id, Name,Solution_Title__c, Service_Job__c, Rank__c,DSID__c,
                                           Diagnostic_notes__c, Diagnostic_Response__c, FaultCode__c,(select Id,Name,Action__c,Component_Id__c, Solutions__c,Quantity__c,Selected_Component__c,Charlength__c, Service_Job__c from CSS_Solution_Components__r),CSS_Nested_Solutions__c
                                           from CSS_Solutions__c where CSS_Nested_Solutions__c IN: cjh];
        CSS_FN_JobPlan.updateCause(lstId);
        test.stopTest();
       
    }
}