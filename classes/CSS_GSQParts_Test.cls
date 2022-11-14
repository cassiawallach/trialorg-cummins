/**********************************************************************
Name: CSS_sendGSQParts_Test
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Test Class for CSS_GSQParts
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION       AUTHOR                   DATE          DETAIL                                 
1.0           shanthi                    14/9/2017   INITIAL dEVELOPMENT

***********************************************************************/
@isTest
public class CSS_GSQParts_Test {
    static testmethod void CSS_GSQPartstest(){
        
            //Add test data for Service job order
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol1= CSS_TestData.createSolutions(true,JO.id);
        CSS_Solution_Component__c csc = CSS_TestData.createSRT(true,JO.id,sol1.id);
          Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
         CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = JO.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = csc.Id;
        parts.Parts_Type__c ='Custom';
        parts.Part_Name__c='test';
        parts.Service_partnumber__c='';
        parts.Quantity__c=1;
        
        insert parts;
        
          Test.startTest();
        CSS_GSQParts gsq = new CSS_GSQParts();
        gsq.Ins_JobId =JO.Id;
        gsq.JobsolutionId=sol1.Id;
        gsq.assignedParts=0;
        gsq.getreplacementReasonOptions();
        gsq.getallCustomPartsData(false);
        gsq.saveCustomParts();
        gsq.AddRow();
        gsq.removingRow();
        gsq.closePopup();
        gsq.deleteParts();
        pageReference pref = gsq.closePopup2();
        Test.stopTest();
    }
    
     static testmethod void CSS_GSQPartstest2(){
        
            //Add test data for Service job order
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        
          
        
        
          Test.startTest();
        CSS_GSQParts gsq = new CSS_GSQParts();
        gsq.Ins_JobId =JO.Id;
        gsq.assignedParts=0;
        gsq.getreplacementReasonOptions();
        gsq.getallCustomPartsData(true);
        
        Test.stopTest();
    }
    
    static testmethod void CSS_GSQPartstest3(){
        
            //Add test data for Service job order
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol1= CSS_TestData.createSolutions(true,JO.id);
        CSS_Solution_Component__c csc = CSS_TestData.createSRT(true,JO.id,sol1.id);
        
          Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
         CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = recTypeIdpart;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = JO.Id;
        parts.selected_part__c = true;
        parts.FailurepartId__c = csc.Id;
        parts.Parts_Type__c ='Custom';
        //parts.Part_Name__c='test';
        parts.Quantity__c=1;
        
        insert parts;
        
          Test.startTest();
        CSS_GSQParts gsq = new CSS_GSQParts();
        gsq.Ins_JobId =JO.Id;
        gsq.JobsolutionId=sol1.Id;
        gsq.assignedParts=0;
        gsq.getreplacementReasonOptions();
        gsq.getallCustomPartsData(false);
        gsq.saveCustomParts();
        Test.stopTest();
    }
}