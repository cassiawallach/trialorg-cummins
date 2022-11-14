/**********************************************************************
Name: EVL_RestrictDelNoteTriggerHandler_Test
Class:EVL_RestrictDelOnClSONoteTriggerHandle
======================================================
======================================================
Purpose:Built for CT1-93                                                         
Restriction Note from delete if service order is closed
======================================================a
======================================================a
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Sai Pisupati      02/18/2021      INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class EVL_RestrictDelNoteTriggerHandler_Test {
    
    public testmethod static void NotesRestrictDeletion_Test()
    {
        Account acc = new Account();
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.5;
        insert acc;
        
       Asset  ast = new Asset();
        ast.Account = acc;
        ast.Service_Model__c = 'ISL9 CM2350 L101';
        ast.Unit_Number__c = '1234';
        ast.Make__c = 'KENWORTH';
        ast.Model__c = 'T800';
        ast.Name = '79963830';
        ast.Unit_Type__c = 'EQ8349';
        ast.VIN__c = '1NKDX4TX6JJ180253';
        ast.Type_PSN__c = 'Engines-79963830';
        ast.Application_Description__c = 'AUTOMOTIVE';
        ast.Application_Code__c = '130';
        ast.Engine_Family__c    ='56'; 
        ast.Type__c = 'Engines';
        insert ast;
        
       WorkOrder wo = new WorkOrder();
       	wo.Account = acc;
        wo.EVL_Stage__c = 'Closed';
        wo.Asset = ast;
        wo.Repair_Location__c = 'Mobile';
        wo.EditComplaint__c = 'Testing';
        wo.EditCause__c = 'Testing';
        wo.EditCorrection__c = 'Testing';
        wo.EditCoverage__c = 'Testing';
        wo.status = 'Closed';
        wo.sub_status__c = 'Close';
        insert wo;
        
        Note no = new Note();
       	no.Title = 'Test Account Note';
        no.Body = 'Test Account Note Body.';
        no.ParentId = wo.Id;
        insert no;
        
        List<Note> notes = [SELECT Id, Title, Body,ParentId  FROM Note where ParentId=: wo.Id];
        
      Test.startTest();
        EVL_RestrictDelOnClSONoteTriggerHandle.restricNoteOnClosedSOBeforeDelete(notes);
        delete notes;
        Test.stopTest();
        
    }


}