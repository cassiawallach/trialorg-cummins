/**********************************************************************
Name:CSS_FN_EditCorrection_Test
Copyright © 2011  Cummins
=======================================================================
=======================================================================
Purpose:                                                            
Test Class for CSS_FN_EditCorrection                                                   
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE             DETAIL                                 
1.0 - Prabakar/Prida               08/12/2016          INITIAL DEVELOPMENT
***********************************************************************/
@IsTest
public class CSS_FN_EditCorrection_Test {
static testMethod void testEditCorrection_method() {
    
     CSS_Job_Order__c jo = CSS_TestData.createJobOrder(True);
     CSS_Solutions__c sol = CSS_TestData.createSolutions(true,jo.id);
       
        CSS_Solution_Component__c solComp = CSS_TestData.createSRT(True,jo.id,sol.id);
        List<CSS_Solutions__c> lstsol = new  List<CSS_Solutions__c>();
        lstsol.add(sol);
        List<Id> lstId = new List<Id>();
        lstId.add(sol.Id);
        List<CSS_Solutions__c> cjh=[Select Id, Name,Solution_Title__c, Service_Job__c, Rank__c,DSID__c,
                        Diagnostic_notes__c, Diagnostic_Response__c, FaultCode__c,(select Id,Name,Action__c,Component_Id__c, Solutions__c,Quantity__c,Selected_Component__c,Charlength__c, Service_Job__c from CSS_Solution_Components__r)
                        from CSS_Solutions__c where Id = :sol.id and CSS_Nested_Solutions__c = null];
         Test.startTest();
            CSS_FN_EditCorrection.updateCorrection(lstId);
            System.assertNotEquals(lstId ,null,'success');

         Test.stopTest();
}
}