/****************************************************************************************************************
Name: FSL_CL_RAPController
Copyright Â© 2019  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
This class is used for creating Case when Report a Problem is clicked from Solution page.
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0     Piyush Rani          		08/18/2019    Initial Development for path change
1.1     Sunitha M             		09/20/2020    Added code for populating Service Territory, WO, Asset
*****************************************************************************************************************/
global without sharing class FSL_CL_RAPController {
    /*@AuraEnabled
    global static CSS_Solutions__c fetchSolutionDetails(String solId){
        system.debug('solid**'+solId);
        CSS_Solutions__c solDetails = [Select id,name,Solution_Title__c from CSS_Solutions__c where id =:solId];
        system.debug('soldet@@@@'+solDetails);
        return solDetails;
    }*/
    @AuraEnabled
    global static String caseCreation(String solutionId, string description, String workOrderId, String solutionTitle) {
        
        // WorkOrder wo = [SELECT id, WorkOrderNumber, AssetId , Asset.Service_Model__c from WorkOrder where id =:workOrderId Limit 1];
        // Sunitha M:CT3-64 ASSET, SO(clickable link) & Territory added for service report
         WorkOrder wo = [SELECT Id, WorkOrderNumber, AssetId, Asset.Name, ServiceTerritoryId, Asset.Service_Model__c 
                         FROM WorkOrder 
                         WHERE Id =:workOrderId Limit 1];
        CSS_Solutions__c solDetails = [SELECT Id, Name, Solution_Title__c 
                                       FROM CSS_Solutions__c 
                                       WHERE Id =:solutionId];
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('FSL Reported Problem').getRecordTypeId();
        
        Case cs = new Case();
        cs.Job__c = wo.WorkOrderNumber;
        cs.ServiceJob__c = wo.Id; //CT3-64
        cs.Service_Model__c = wo.Asset.Service_Model__c;
        cs.AssetId = wo.AssetId; //CT3-64
        cs.Service_Territory__c = wo.ServiceTerritoryId; //CT3-64
        cs.Status = 'New';
        cs.Created_from_UI__c = False;
        cs.Solution_Id__c = solDetails.Name;
        cs.Solution_Title__c = solDetails.Solution_Title__c;
        cs.RecordTypeId = devRecordTypeId;
        //Rajashekar N ; 09/11/2020 ; No longer needed Reported_problem__c field and replaced with Description field
        // cs.Reported_problem__c = description; //System.now().format() + ' ' +//
        cs.Description = description;
        
        //Adding the DMLOptions AssignmentRule Header to Follow Case Assignment Rule
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        cs.setOptions(dmlOpts);
        
        system.debug('*****'+cs);
        insert cs;
        system.debug('*****####'+cs.id);
        //Method to share the record
        /* if(system.isBatch() == False && system.isFuture() == false){
            shareWithCreatedByUser(cs.Id);  
        }
        */
        return cs.id;
    }
    
    /* @future
    public static void shareWithCreatedByUser(Id recordId) {
        System.debug('::: Values = '+recordId);
        CaseShare caseShr = new CaseShare();
        caseShr.CaseId = recordId;
        caseShr.UserOrGroupId = UserInfo.getUserId();
        caseShr.CaseAccessLevel = 'Edit';
        
        insert caseShr;
    } */
}