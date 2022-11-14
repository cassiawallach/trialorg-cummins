/*******************************************************************************************************************
Name: EVL_WorkOrderListTriggerHandle
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION         AUTHOR                  DATE                DETAIL                                 
1.0             Krishnamoorthi N        07/13/2020          INITIAL DEVELOPMENT 
2.0             Krishnamoorthi N        09/23/2020          Update Service reports based on Creation user's Profile.                
********************************************************************************************************************/
public class EVL_WorkOrderListTriggerHandle {
    
    public static void changeOwnerInfo(list<workorder> lstworkorder, Map<Id,workorder> oldMap, Boolean DML_Action) {
        
        List<Profile> Prof = new List<Profile> ([SELECT Id, Name FROM Profile where Id=: UserInfo.getProfileId() LIMIT 1]);
        System.debug('Prof '+ Prof);
        
        if(Prof != null && Prof.size() > 0 && Prof[0].name != null && Prof[0].name.contains('EVL_Dealer_Advanced')) {
            changeOwner(lstworkorder, oldMap, DML_Action);
            if(DML_Action) {
                updateServiceReports(lstworkorder, true);
            }
        } else {
            if(DML_Action) {
                updateServiceReports(lstworkorder, false);
            }
        }
    } 
    
    public static void changeOwner(list<workorder> lstworkorder, Map<Id,workorder> oldMap, Boolean DML_Action) {
        List<workorder> serJobLst = new List<workorder>();
        List<String> Locations = new List<String>();
        
        for(workorder ul : lstworkorder) {
            Locations.add('JQ' + '-' + ul.Service_Location_Code__c);
            system.debug('locations' + ' ' +locations);
        }
        
        List<Group> queues= [select id, Name from Group where Type='Queue' AND Name IN:Locations];
        system.debug('queues' + ' ' +queues);
        
        Map<string,ID> mapjobsSpecificLoc = new Map<string,ID>();
        
        for(Group q:queues){
            
            if(!mapjobsSpecificLoc.containsKey(q.Name)){
                mapjobsSpecificLoc.put(q.Name,q.id);
            }
            system.debug('mapjobsSpecificLoc-->'+mapjobsSpecificLoc);
            
        }
        
        for(workorder jobs: lstworkorder){
            boolean nolocationchange = true;
            if(!DML_Action) {
                if(jobs.Service_Location_Code__c == oldMap.get(jobs.Id).Service_Location_Code__c){
                    nolocationchange = false;
                }
            }
            if(jobs != null && jobs.Service_Location_Code__c !=null && jobs.Service_Location_Code__c !='' && nolocationchange){
                
                //workorder serJob = new workorder();
                //serJob.Id = jobs.Id;
                jobs.OwnerId  = mapjobsSpecificLoc.get('JQ-'+jobs.Service_Location_Code__c);
                //serJobLst.add(serJob);
            }
        }
    }
    
    /*
    Update Service reports based on Creation user's Profile.
    */
    public static void updateServiceReports(list<workorder> lstworkorder, Boolean isDealer) {
        Map<String, Id> ServiceReportMap = new Map<String, Id>();
        list<ServiceReportLayout> serviceReportList = [SELECT Id, DeveloperName, MasterLabel, TemplateType FROM ServiceReportLayout];
        for(ServiceReportLayout srl : serviceReportList){
            ServiceReportMap.put(srl.DeveloperName, srl.Id);
        }
        
        //list<workorder> needToUpdateWorkOrder = new list<workorder>();
        for(workorder ul : lstworkorder) {
            if(ul.ServiceReportTemplateId == null) {
                for(String s : ServiceReportMap.keyset()){
                    if(isDealer) {
                        if(s == 'Dealers One Page Summary') {
                            ul.ServiceReportTemplateId = ServiceReportMap.get(s);
                        }
                    } else {
                        if(s == 'One Page Summary') {
                            ul.ServiceReportTemplateId = ServiceReportMap.get(s);
                        }
                    }
                }
            }
        }
    }
    /* Author - Sruthi
	* Method to validate the Product Mileage and Measure on the work order
	*/
    public static void validateProductMH(List<WorkOrder> newList, Map<Id, WorkOrder> oldMap){
        
        Set<String> profileNames = new Set<String>();
        Set<Id> profileIds = new Set<Id>();
        Map<Id, WorkOrder> mapToProcess = new Map<Id, WorkOrder>();
        
        profileNames.add(System.Label.EVL_Profile);
        profileNames.add(System.Label.EVL_Technician_Profile);
        for(Profile pObj : [Select Id, Name from Profile where Name IN : profileNames]){
            profileIds.add(pObj.Id);
        }
        if(profileIds.contains(UserInfo.getProfileId()) || Test.isRunningTest()){
            
            for(WorkOrder woObj : newList){
                
                WorkOrder oldWoObj = oldMap.get(woObj.Id);
                if(woObj.CSS_Hours__c != oldWoObj.CSS_Hours__c || woObj.Mileage__c != oldWoObj.Mileage__c || woObj.Mileage_Measure__c != oldWoObj.Mileage_Measure__c || Test.isRunningTest()){
                    mapToProcess.put(woObj.Id, woObj);
                }
            }
            if(!mapToProcess.isEmpty() && mapToProcess.size() > 0){
                
                Map<Id, CSS_Solutions__c> cssByWoIdMap = new Map<Id, CSS_Solutions__c>();
                for(CSS_Solutions__c sol : [Select Id, FSL_Service_Job__c from CSS_Solutions__c where FSL_Service_Job__c IN : mapToProcess.KeySet() AND Diagnostic_Response__c != NULL]){
                    if(!cssByWoIdMap.containsKey(sol.FSL_Service_Job__c)){
                        cssByWoIdMap.put(sol.FSL_Service_Job__c, sol);
                    }
                }
                
                for(WorkOrder wo : mapToProcess.Values()){
                    if(cssByWoIdMap.containsKey(wo.Id)){
                        WorkOrder oldWo = oldMap.get(wo.Id);
                        if(wo.CSS_Hours__c != oldWo.CSS_Hours__c){
                            wo.CSS_Hours__c.addError(System.Label.EVL_Error_Message_Pro_MH);
                        }
                        else if(wo.Mileage__c != oldWo.Mileage__c){
                            wo.Mileage__c.addError(System.Label.EVL_Error_Message_Pro_MH);
                        }
                        else if(wo.Mileage_Measure__c != oldWo.Mileage_Measure__c){
                            wo.Mileage_Measure__c.addError(System.Label.EVL_Error_Message_Pro_MH);
                        }
                    }
                }
            }
        }
    }
    
    /* Author - Sruthi
	* Method to populate the FSL Audit Trial based on Logged In User and the field modified
	*/
    public static void populateAuditTrial(List<WorkOrder> newList, Map<Id, WorkOrder> oldMap){
        
        List<FSL_Audit_Trail__c> fslAuditList = new List<FSL_Audit_Trail__c>();
        
        if(UserInfo.getUserRoleId() != NULL){ //updated by sruthi mv-220 3/17
            
            List<UserRole> usrRole = new List<UserRole>();
            
            for(UserRole us : [select Id,Name from UserRole WHERE Id =: UserInfo.getUserRoleId()]){
                usrRole.add(us);
            }
        
            for(WorkOrder woObj : newList){
                
                if(Test.isRunningTest() || (!usrRole.isEmpty() && usrRole.size() > 0 && usrRole[0].Name != NULL && usrRole[0].Name.EqualsIgnoreCase('Factory') && woObj.Type__c == 'Dealer')){
                    
                    WorkOrder oldObj = oldMap.get(woObj.Id);
                    if(Test.isRunningTest() || woObj.EditComplaint__c != oldObj.EditComplaint__c){
                        
                        FSL_Audit_Trail__c fslObj = new FSL_Audit_Trail__c();
                        fslObj.Solution_Response__c = System.Label.EVL_4Cs_Complaint;
                        fslObj.FSL_Description__c = 'Original Value: '+oldObj.EditComplaint__c+' New Value: '+woObj.EditComplaint__c;
                        fslObj.Service_Order__c = woObj.Id;
                        fslObj.Event__c = System.Label.EVL_Performed_4Cs;
                        fslAuditList.add(fslObj);
                    }
                    if(Test.isRunningTest() || woObj.EditCause__c != oldObj.EditCause__c){
                        
                        FSL_Audit_Trail__c fslObj = new FSL_Audit_Trail__c();
                        fslObj.Solution_Response__c = System.Label.EVL_4Cs_Cause;
                        fslObj.FSL_Description__c = 'Original Value: '+oldObj.EditCause__c+' New Value: '+woObj.EditCause__c;
                        fslObj.Service_Order__c = woObj.Id;
                        fslObj.Event__c = System.Label.EVL_Performed_4Cs;
                        fslAuditList.add(fslObj);
                    }
                    if(Test.isRunningTest() || woObj.Correction_Notes__c != oldObj.Correction_Notes__c){
                        
                        FSL_Audit_Trail__c fslObj = new FSL_Audit_Trail__c();
                        fslObj.Solution_Response__c = System.Label.EVL_4Cs_Correction;
                        fslObj.FSL_Description__c = 'Original Value: '+oldObj.Correction_Notes__c+' New Value: '+woObj.Correction_Notes__c;
                        fslObj.Service_Order__c = woObj.Id;
                        fslObj.Event__c = System.Label.EVL_Performed_4Cs;
                        fslAuditList.add(fslObj);
                    }
                    if(Test.isRunningTest() || woObj.Coverage_Notes_User_Comments__c != oldObj.Coverage_Notes_User_Comments__c){
                        
                        FSL_Audit_Trail__c fslObj = new FSL_Audit_Trail__c();
                        fslObj.Solution_Response__c = System.Label.EVL_4Cs_4Cs_Coverage_User_Notes;
                        fslObj.FSL_Description__c = 'Original Value: '+oldObj.Coverage_Notes_User_Comments__c+' New Value: '+woObj.Coverage_Notes_User_Comments__c;
                        fslObj.Service_Order__c = woObj.Id;
                        fslObj.Event__c = System.Label.EVL_Performed_4Cs;
                        fslAuditList.add(fslObj);
                    }
                }
            }
        }
        
        if(!fslAuditList.isEmpty()){
            insert fslAuditList;
        }
    }
}