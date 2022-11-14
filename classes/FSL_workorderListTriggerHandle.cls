/**********************************************************************
Name: FSL_workorderListTriggerHandle
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================a
======================================================a
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      01/20/2019      INITIAL DEVELOPMENT
2.0 - Dinesh Yadav      10/20/2020      Delete TSBs associated with WorkOrder when Status = 'Closed' or 'Canceled'
3.0 - Charan Teja       03/23/2021      Avoiding recursive action for bug CT3-380
4.0 - Karthik Pedditi   06/15/2021      Setting Prepaid field on SO to 'Y' CT2-485
5.0 - Karthik Pedditi   07/29/2021      Adding Type and Part Number field to populateMaintenanceAsset_Parts.
6.0 - Jesse Allen       11/12/2021      FBI-84 - Corrected method to handle contact selection as comm recipient
7.0 - Lochana Rajput    06/22/2022      
***********************************************************************/
public class FSL_workorderListTriggerHandle {
    public static Boolean avoidAfterupdate = false;
    public static Boolean avoidBeforeInsert = false;
    public static Boolean avoidBeforeUpdate = false;
    Public static Boolean recursiveCheck = false;
    public static Boolean is4CInsertRun=false;//added by vinod 9/21
    public static boolean runWarrantyService=false;//to check if warranty integratin is needed to run.
    public static Boolean isSOCInsert=false;
    public static Boolean isSOCInsert1=false;
    public static Boolean avoidAdminSRTCall = false; // added to avoid Recursiveness for SRTS CT3-393
    public static map<id,Service_Order_Extension__c> extsor = new map<id,Service_Order_Extension__c>();
    public static User runningUser;
    
    static {
        runningUser = [Select id,Profile.Name From User Where Id = :UserInfo.getUserId()];
    }
    
    public static void workorderTriggerHandleAfterInsert(list<workorder> newWOs) {
        system.debug('**in handler class**');
        insertComplaintJobHistory(newWos);
        FSL_workOrderShare.workOrderRecShare(newWOs);
        // After insert messages.
        // 10/16 - Commeting as Customer Credit Messages and MRO Messages Integrations moved to Lightning Components' Init
        // FSL_CL_CustomerCreditMessages.customerCreditMessageTriggerHelperAfterInsert(newWOs);
        // FSL_CL_MROMessages.MROMessageTriggerHelperAfterInsert(newWOs); 
        Set<Id> setAssetIds = new Set<Id>(); 
        for(workorder wo : newWOS)  
        {   
            setAssetIds.add(wo.id);
        }

        FSL_UpdateAssetValuesOnWOCreation.updateWoDetails(newWOs);
        // FSL_populatePayer.updatePayer(newWOs,false);
        // FSL_populatePayer.updatePayerOnInsert(newWOs);
       
      
       
        FSL_TriggerHandler_ViewHistory.handleRepeatFlag(setAssetIds);  
        FSL_ServiceOrderRecentVisit.recentVisitFlag(newWOs,null); // By priyanka VGRS2-456
         // Update woList;
    }
    
    public static void workorderTriggerHandleBeforeInsert(list<workorder> newWOS) {
        System.debug('************************* In Before Insert Trigger Handle ***************************');
        // Before Insert Repeat Flag Callout Update
        if(!avoidBeforeInsert){
            avoidBeforeInsert=true;
        }
        
        //The below code is for User Sotry 458 and is Authoured by Harish
        // Start - Populate Service Territory and Record Type on WorkOrders created from Maintenance Plan
        //START
        Set<Id> setMaintaincePlan = new Set<Id>();
        Map<Id, Asset> mapIdVSAsset;
        Set<Id> setAsset = new Set<ID>();
        for(WorkOrder workOrderObj : newWOs) {
            if(workOrderObj.MaintenancePlanId != null){
                setMaintaincePlan.add(workOrderObj.MaintenancePlanId);
            }if(workOrderObj.AssetId != null){
                setAsset.add(workOrderObj.AssetId);
            }    
        }
        if(setAsset.size()>0){
            mapIdVSAsset= new map<Id, Asset>([SELECT Id, FSL_Site__c, FSL_Site__r.Street,FSL_Site__r.City,
                                              FSL_Site__r.State,FSL_Site__r.Country, FSL_Site__r.PostalCode 
                                                                                          FROM Asset 
                                                                                          WHERE Id IN: setAsset]);
        }
        
        if(setMaintaincePlan.size() > 0) {
            Id woIntakeRTId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
            Map<Id, MaintenancePlan> mapIdVSMaintaincePlan= new map<Id, MaintenancePlan>([SELECT Id, Complaint__c, Service_Territory__c, Service_Territory__r.Street, Service_Territory__r.City, 
                                                                                          Service_Territory__r.State, Service_Territory__r.Country, Service_Territory__r.PostalCode,Payment__c 
                                                                                          FROM MaintenancePlan 
                                                                                          WHERE Id IN: setMaintaincePlan]);
            for(WorkOrder workOrderObj : newWOs) {
                if(mapIdVSMaintaincePlan.get(workOrderObj.MaintenancePlanId) != null && mapIdVSMaintaincePlan.containsKey(workOrderObj.MaintenancePlanId)) {
                    workOrderObj.General_Symptoms__c = mapIdVSMaintaincePlan.get(workOrderObj.MaintenancePlanId).Complaint__c;
                }
                if(woIntakeRTId != null) {
                    workOrderObj.RecordTypeId = woIntakeRTId;
                }
                if(mapIdVSMaintaincePlan.get(workOrderObj.MaintenancePlanId) != null && mapIdVSMaintaincePlan.containsKey(workOrderObj.MaintenancePlanId)) {
                    workOrderObj.ServiceTerritoryId = mapIdVSMaintaincePlan.get(workOrderObj.MaintenancePlanId).Service_Territory__c;
                    workOrderObj.City  = mapIdVSMaintaincePlan.get(workOrderObj.MaintenancePlanId).Service_Territory__r.City;
                    workOrderObj.Country = mapIdVSMaintaincePlan.get(workOrderObj.MaintenancePlanId).Service_Territory__r.Country;
                    workOrderObj.State = mapIdVSMaintaincePlan.get(workOrderObj.MaintenancePlanId).Service_Territory__r.State;
                    workOrderObj.PostalCode = mapIdVSMaintaincePlan.get(workOrderObj.MaintenancePlanId).Service_Territory__r.PostalCode;
                    workOrderObj.Street = mapIdVSMaintaincePlan.get(workOrderObj.MaintenancePlanId).Service_Territory__r.Street;
                   
                    if(mapIdVSAsset.get(workOrderObj.AssetId) != null && mapIdVSAsset.containsKey(workOrderObj.AssetId)){
                        if(mapIdVSAsset.get(workOrderObj.AssetId).FSL_Site__c !=null){
                            workOrderObj.Repair_Location__c = 'Mobile';
                                workOrderObj.Repair_Site_Address__c  = mapIdVSAsset.get(workOrderObj.AssetId).FSL_Site__c;
                            If(mapIdVSAsset.containsKey(workOrderObj.MaintenancePlanId)){
                            workOrderObj.City  = mapIdVSAsset.get(workOrderObj.MaintenancePlanId).FSL_Site__r.City;
                            workOrderObj.Country = mapIdVSAsset.get(workOrderObj.MaintenancePlanId).FSL_Site__r.Country;
                            workOrderObj.State = mapIdVSAsset.get(workOrderObj.MaintenancePlanId).FSL_Site__r.State;
                            workOrderObj.PostalCode = mapIdVSAsset.get(workOrderObj.MaintenancePlanId).FSL_Site__r.PostalCode;
                            workOrderObj.Street = mapIdVSAsset.get(workOrderObj.MaintenancePlanId).FSL_Site__r.Street;
                        }
                               }
else{
                            workOrderObj.Repair_Location__c = 'In Shop';
                        }
                    }                   
                } 
                                     
                //CT2-485-starts here
                if(mapIdVSMaintaincePlan.get(workOrderObj.MaintenancePlanId) != null && mapIdVSMaintaincePlan.containsKey(workOrderObj.MaintenancePlanId) &&  mapIdVSMaintaincePlan.get(workOrderObj.MaintenancePlanId).Payment__c=='Prepaid')
                {
                    workOrderObj.Prepaid__c='Y';
                    workOrderObj.Payment_Type__c='Prepaid';
                } 
                //CT2-485-ends here
            }
        }
        //END
        
        Set<Id> setAssetIds = new Set<Id>();
        
        for(workorder wo : newWOS)
        {
            setAssetIds.add(wo.AssetId);
            
            system.debug('wo.Asset.Name>>'+wo);
            //wo.Repeat_Visit__c =  updateRepeatFlag(conDetails,'',wo.Asset.Name,wo.Mileage__c,wo.Mileage_Measure__c,wo.WorkOrderNumber,'',null,wo.RPVControlNumber__c); 
            
        }
        //FSL_TriggerHandler_ViewHistory.handleRepeatFlag(setAssetIds);
       // FSL_ServiceOrderRecentVisit.recentVisitFlag(newWOs,null);
        FSL_SMNUpdateOnServiceOrder so = new FSL_SMNUpdateOnServiceOrder();
        so.BeforeInsert(newWOs);
        //START --- Mallika: Logic to populate Location code for a assigned Service Territory on WO
        Set<Id> terrIdSet=new Set<Id>();
        Map<Id, String> terrIdLocationCodeMap = new Map<Id, String>();
       
        for(WorkOrder wo: newWOS){
            if(wo.ServiceTerritoryId!=null){
                terrIdSet.add(wo.ServiceTerritoryId);
            }
            // CT4- 288
            //do not populate if WO created from Recommendation accepted
            if(wo.Service_Team_Contact__c == null && !wo.CreatedFromRecommendation__c) {
                wo.Service_Team_Contact__c = UserInfo.getUserId();
            }
            // CT4- 288
        }
        
        if(!terrIdSet.isEmpty()){
            for(ServiceTerritory st: [Select Id, Location_Code__c from ServiceTerritory where Id IN: terrIdSet]){
                System.debug('Length:'+(st.Location_Code__c).length());
                if(st.Location_Code__c!=null && ((st.Location_Code__c).length() > 13)){
                    String ukBranchCode = ((st.Location_Code__c.left(15)).right(9)).replace('-','');
                    system.debug('BranchCode:'+ukBranchCode);
                    if(ukBranchCode.isNumeric()){
                        terrIdLocationCodeMap.put(st.Id, ukBranchCode);
                    }
                } else{
                    if(((st.Location_Code__c.left(11)).right(5)).isNumeric()){
                        terrIdLocationCodeMap.put(st.Id, (st.Location_Code__c.left(11)).right(5));
                    }
                }
            }
        }
        
        if(!terrIdLocationCodeMap.isEmpty()){
            for(WorkOrder wo: newWOS){
                if(wo.ServiceTerritoryId!=null && terrIdLocationCodeMap.containsKey(wo.ServiceTerritoryId)){ // raghav
                    wo.Branch_Code__c = Integer.valueOf(terrIdLocationCodeMap.get(wo.ServiceTerritoryId));
                    // wo.Service_Team_Contact__c=UserInfo.getUserId();
                }
            }
        }
        FSL_populatePayer.updatePayerOnInsert(newWOs);
        FSL_CL_ApplicationErrorMessage.insertErrMessage(newWOs);
    }
    
    public static void workorderTriggerHandleBeforeUpdate(Map<Id, workorder> newWoMap, Map<Id, workorder> oldWoMap) {
        System.debug('************************* In Before update Trigger Handle ***************************');
        if(!recursiveCheck && Test.isRunningTest()){
           FSL_workOrderConsolidation.updateWoDetails(newWoMap,oldWoMap);
        }
        if(!avoidBeforeUpdate || Test.isRunningTest()) {
            avoidBeforeUpdate = true;
            updateWarrantyServiceStatusToInProgress(newWoMap,oldWoMap);
            System.debug('avoidBeforeUpdate');
           // FSL_ServiceOrderRecentVisit.recentVisitFlag(newWoMap.values(), oldWoMap);
            FSL_SMNUpdateOnServiceOrder so = new FSL_SMNUpdateOnServiceOrder();
            so.BeforeUpdate(newWoMap, oldWoMap);
            // Added By mallika as part of code optimization starts
           // if(UserInfo.getUserId() == '0053C000003ejYa'){
           if(!Test.isRunningTest())
                FSL_workOrderConsolidation.updateWoDetails(newWoMap,oldWoMap);
           // }
            // Added By mallika as part of code optimization Ends
            // FSL_CL_ApplicationErrorMessage.updateErrMessage(newWoMap,oldWoMap);
            
            //FSL_populatePayer.updatePayer(newWoMap, oldWoMap);
                        
            //START --- Mallika: Logic to populate Location code for a assigned Service Territory on WO
            Set<Id> terrIdSet = new Set<Id>();
            Map<Id, String> terrIdLocationCodeMap = new Map<Id, String>();
            // Sub type records creation Map // Start
            List<FSL_Additional_Sub_Type__c> subtypeToCreate = new List<FSL_Additional_Sub_Type__c>();
            /*List<FSL_SubType__c> SubTypes = new List<FSL_SubType__c>();
            Map<Id, FSL_SubType__c> SubTypeMap = new Map<Id, FSL_SubType__c>();
            SubTypes = [SELECT Id, Name, Code_Value__c FROM FSL_SubType__c];
            for(FSL_SubType__c ad:SubTypes) {
                if(!SubTypeMap.Containskey(ad.Id))
                    SubTypeMap.put(ad.Id,ad);
                else 
                    SubTypeMap.get(ad.Id);
            }  // End : Sub type records creation Map*/
            
            //***** Mallika 
            Map<Id, FSL_SubType__c> SubTypeMap = woSubTypeMap(newWoMap.values());
            //***** 
            List<Id> closedWorkOrderList = new List<Id>();//MV_257 Work Order Closure 
        
            User currentUser = [Select ERP__c From User Where Id = :UserInfo.getUserId()];//MV_257 Work Order Closure 
        
            for(WorkOrder wo: newWoMap.values()) {
                //added by harsha 06-08-2020
                WorkOrder oldwo = oldWoMap.get(wo.Id);
                if(oldwo.AssetId != wo.AssetId)
                {
                    wo.Field_Actions__c = '';
                    //Bharat - Added to not show FA Retry button when Asset is changed on WO    
                    wo.FieldActionService_Failure_Flag__c = false;
                }
                //ended by harsha 06-08-2020
                if(wo.ServiceTerritoryId!=null && wo.ServiceTerritoryId!=oldWoMap.get(wo.Id).ServiceTerritoryId){
                    terrIdSet.add(wo.ServiceTerritoryId);
                }
                
                //Update Date/Time and person that closed the Job in Service Order //CT3-112, Dinesh Yadav
                if((wo.Status =='Closed' || wo.Status =='Canceled') && wo.Status != oldwo.Status){
                    wo.Service_Order_Close_Date_Time__c = System.now();
                    wo.Service_Order_Closed_By__c = UserInfo.getUserId();
                }
                // CT4- 288
                //do not populate if WO created from Recommendation accepted
                if(String.isEmpty(wo.Service_Team_Contact__c) && !wo.CreatedFromRecommendation__c) {
                    wo.Service_Team_Contact__c = UserInfo.getUserId();
                }
                // CT4- 288
                
                /* CT3-236 , added by sailaja to insert/update WO INSITE Images
                if(wo.Before_Image__c!=oldwo.Before_Image__c){
                    system.debug('wo.Before_Image__c' + wo.Before_Image__c);
                    FSL_WO_INSITEImageFeed.beforeImageInsert(wo.Id);
                }
                if(wo.After_Image__c!=oldwo.After_Image__c){
                    system.debug('wo.After_Image__c' + wo.After_Image__c);
                    FSL_WO_INSITEImageFeed.afterImageUpdate(wo.Id);
                } */
                //Creating Additional Sub Type record //START
                if(wo.FSL_Sub_Type__c != null && wo.FSL_Sub_Type__c != oldwo.FSL_Sub_Type__c) {
                    FSL_Additional_Sub_Type__c AddSubType = new FSL_Additional_Sub_Type__c();
                    if(SubTypeMap.containskey(wo.FSL_Sub_Type__c)) {
                        AddSubType.Name = SubTypeMap.get(wo.FSL_Sub_Type__c).Name;
                        AddSubType.Sub_Type__c = SubTypeMap.get(wo.FSL_Sub_Type__c).Code_Value__c;
                    }
                    AddSubType.Status__c = 'Open';
                    AddSubType.Service_Order__c = wo.Id;
                    subtypeToCreate.add(AddSubType);
                } 
            /*    //MV_257 Work Order Closure 
                if(wo.Status == 'Closed' && oldWoMap.get(wo.Id).status != 'Closed' && currentUser.ERP__c == 'BMS'){
                    wo.Job_Complete__c = 'Y';
                    wo.Job_Status__c = 'Closed';
                    closedWorkOrderList.add(wo.Id);
                    //oldWorkOrderStatusMap.put(wo.Id,oldWoMap.get(wo.Id).status);    
                }//MV_257 Work Order Closure */
            }
            if(!subtypeToCreate.isEmpty())
                Insert subtypeToCreate; // End : Sub type records creation
            if(!terrIdSet.isEmpty()){
                for(ServiceTerritory st: [Select Id, Location_Code__c from ServiceTerritory where Id IN: terrIdSet]){
                    System.debug('Length:'+(st.Location_Code__c).length());
                    if(st.Location_Code__c!=null && ((st.Location_Code__c).length() > 13)){
                        String ukBranchCode = ((st.Location_Code__c.left(15)).right(9)).replace('-','');
                        system.debug('BranchCode:'+ukBranchCode);
                        if(ukBranchCode.isNumeric()){
                            terrIdLocationCodeMap.put(st.Id, ukBranchCode);
                        }
                    } else{
                        if(((st.Location_Code__c.left(11)).right(5)).isNumeric()){
                            terrIdLocationCodeMap.put(st.Id, (st.Location_Code__c.left(11)).right(5));
                        }
                    }
                }
            }
            
            if(!terrIdLocationCodeMap.isEmpty()){
                for(WorkOrder wo: newWoMap.values()){
                    if(wo.ServiceTerritoryId!=null){
                        wo.Branch_Code__c = Integer.valueOf(terrIdLocationCodeMap.get(wo.ServiceTerritoryId));
                        //    wo.Service_Team_Contact__c=UserInfo.getUserId();
                    }
                }
            }
             /* //MV_257 Work Order Closure
            if(!closedWorkOrderList.isEmpty()){
                String oldWorkOrderMapString = JSON.serialize(oldWoMap);
                FSL_CL_JobClosureService.sendWorkOrders(closedWorkOrderList,oldWorkOrderMapString);
            }//MV_257 Work Order Closure */
        }
    }
    
    public static void workorderTriggerHandleAfterUpdate(Map<Id,workorder> newMap, Map<Id,workorder> oldMap) {
        System.debug('::: In AfterUpdate Handle Class'+newMap+'::avoidAfterupdate::'+avoidAfterupdate); 
        list<case> listCase=new list<case>();//added as a part of FBI 393
           set<id> caseIdset=new set<id>(); //added as a part of FBI 393
        for(WorkOrder wo: newMap.values()) {
            //added by Priya 19-05-2021
            WorkOrder oldwo = oldMap.get(wo.Id);
            if(oldwo.status != wo.status && wo.Type__c=='Dealer' && wo.CaseId!=null ){
                Case caseUpdate= new Case();
                caseUpdate.Status=wo.status;
                caseUpdate.id=wo.CaseId;
                caseUpdate.Bypass_Validation_Rule__c =true;
                //update caseUpdate;  //commented as a part of FBI 393
                //caseUpdate.Bypass_Validation_Rule__c =false;//commented as a part of FBI 393
                //update caseUpdate;  //commented as a part of FBI 393
                listCase.add(caseUpdate); //added as a part of FBI 393
                caseIdset.add(wo.CaseId); //added as a part of FBI 393
                system.debug('>>>caseUpdate>>'+caseUpdate);
            }
        }if(!listCase.isEmpty()){ //added as a part of FBI 393
            update listCase; //added as a part of FBI 393
            system.debug('listCase>>>>>'+listCase);
            list<case> listcaseToReset=new list<case>();
            for(case cs : [select id,Bypass_Validation_Rule__c from case where id =: caseIdset]){
                cs.Bypass_Validation_Rule__c = false;
                listcaseToReset.add(cs);
            }
            if(!listcaseToReset.isEmpty()){
                update listcaseToReset; //added as a part of FBI 393
            }
            
        } //added as a part of FBI 393
        if(!avoidAfterupdate)
        {       
            avoidAfterupdate = true;
            //Call RSW Webservice for Dealers.
            EVL_CL_RSW.callRSWTriggerHelperMethod(newMap, oldMap);
            FSL_CL_CustomerCreditMessages.customerCreditMessageTriggerHelper(newMap, oldMap);
            FSL_CL_MROMessages.MROMessageTriggerHelper(newMap, oldMap);
            //FSL_populatePayer.updatePayer(newMap,oldMap);
            //FSL_CL_ApplicationErrorMessage.updateErrMessage(newMap,oldMap);

            //CT3-289, Dinesh Yadav
            //if(RecursiveTriggerHandler.chkSRAccountId == true) // Added code directly in FSL_UpdateAssetValuesOnWOUpdate class. 
          //  FSL_UpdateAssetValuesOnWOUpdate.updateWoDetails(newMap,oldMap);
          updateUnitNumber(newMap,oldMap);
           
            //  CT3-236 , added by sailaja to insert/update WO INSITE Images
            system.debug('calling FSL_WO_INSITEImageFeed::');
            FSL_WO_INSITEImageFeed.woINSITEImageChange(newMap,oldMap);
        }
        if(!is4CInsertRun){
            updateFourCs(newMap.values(), oldMap);
        } //changd positon 8/26 -- vinod yelala
        system.debug('aftermethod execution::'+newMap);
            //Added by Priyanka Ct1-670 
        Set<Id> setWoIds = new Set<Id>();   
        for(workorder wo : newMap.values()) 
        {   
        if (oldMap.get(wo.Id).AssetId != wo.AssetId || oldMap.get(wo.Id).Mileage__c != wo.Mileage__c)   
        {   
        setWoIds.add(wo.id);    
        }   
        system.debug('wo.Asset.Name>>'+wo); 
        system.debug('setWoIds>>'+ setWoIds);
        }   
        if(System.IsBatch() == false && System.isFuture() == false && !setWoIds.isEmpty() ){    //isbatch condition added by mallika as part of CT-200
        FSL_TriggerHandler_ViewHistory.handleRepeatFlag(setWoIds);  
        FSL_ServiceOrderRecentVisit.recentVisitFlag(newMap.values(), oldMap);  // By priyanka VGRS2-456
        }
        /*
        * Method to execute logic for resource clock-out.
        */
        // FSLClockingTriggerHandle.executeResourceClockOut(newMap, oldMap);
    }
    //Removing this class as part of CT2-720: Karthik Pedditi   06/04/2021         
   /* public static void getAdminSRTCall(Map<Id,workorder> NewMap, Map<Id,workorder> OldMap,Boolean SRTcheck) {
        system.debug('Testing*****2');
        if(!avoidAdminSRTCall){
            if(SRTcheck && !OldMap.isEmpty()){
                system.debug('Testing*****');
                for (workorder wrkorder : NewMap.values()){
                    if (oldMap.get(wrkorder.Id).Application__c != wrkorder.Application__c || oldMap.get(wrkorder.Id).Repair_Location__c != wrkorder.Repair_Location__c) {
                        if(wrkorder.Status !='Closed' && wrkorder.Status !='Canceled'){
                            FSL_GetSolutions.upsertAdminSRT(wrkorder.Id); 
                            avoidAdminSRTCall = true;
                        }
                    }
                }
            } 
        }  
    } */
    
    
    //added by vinod  - for inserting complaint history in 4c
    public static void insertComplaintJobHistory(list<workorder> newWOs) {
        list<CSS_JobHistory__c> lstjobhistory = new list<CSS_JobHistory__c>();
        for(WorkOrder wo : newWos)
        {
            system.debug('old complaint value:'+wo.General_Symptoms__c );//EditComplaint__c);
            if(String.isNotBlank(wo.General_Symptoms__c)){
                CSS_JobHistory__c compHis = FSL_WorkorderTriggerHelper.createJobhistoryRecord('WorkOrder',wo.id,'EditComplaint__c','',wo.General_Symptoms__c);
                if(compHis != null){
                    lstjobhistory.add(compHis);
                }
            }
        }
        system.debug('lstjobhistory>'+lstjobhistory.size());
        if(!lstjobhistory.isEmpty()){
            insert lstjobhistory;
            is4CInsertRun=true;
        }
    }
    //Ends
    
    //Method to insert record in job history object for updating 4c's
    public static void updateFourCs(list<WorkOrder> lstNewServiceJob,map<id,WorkOrder> mapOldServiceJob) {
        list<CSS_JobHistory__c> lstjobhistory = new list<CSS_JobHistory__c>();
        CSS_JobHistory__c hist;
        //looping the new list 
        for(WorkOrder csj : lstNewServiceJob)
        {
            system.debug('old complaint value:'+mapOldServiceJob.get(csj.id).EditComplaint__c);
            system.debug('new complaint value:'+csj.EditComplaint__c);
            system.debug('old editcause value:'+mapOldServiceJob.get(csj.id).EditCause__c );
            system.debug('new complaint value:'+csj.EditCause__c );
            system.debug('old correction value:'+mapOldServiceJob.get(csj.id).EditCorrection__c);
            system.debug('new correction value:'+csj.EditCorrection__c);
            system.debug('old coveragevalue:'+csj.EditCoverage__c);
            system.debug('new complaint value:'+mapOldServiceJob.get(csj.id).EditCoverage__c);
            if(csj.EditComplaint__c != mapOldServiceJob.get(csj.id).EditComplaint__c){
                CSS_JobHistory__c compHis = FSL_WorkorderTriggerHelper.createJobhistoryRecord('WorkOrder',csj.id,'EditComplaint__c',mapOldServiceJob.get(csj.id).EditComplaint__c,csj.EditComplaint__c);
                if(compHis != null){
                    lstjobhistory.add(compHis);
                }
            } 
            
            if(csj.EditCause__c != mapOldServiceJob.get(csj.id).EditCause__c){
                CSS_JobHistory__c causeHis = FSL_WorkorderTriggerHelper.createJobhistoryRecord('WorkOrder',csj.id,'EditCause__c',mapOldServiceJob.get(csj.id).EditCause__c,csj.EditCause__c);
                if(causeHis != null){
                    lstjobhistory.add(causeHis);
                }
            } 
            if(csj.EditCorrection__c != mapOldServiceJob.get(csj.id).EditCorrection__c){
                CSS_JobHistory__c correctionHis = FSL_WorkorderTriggerHelper.createJobhistoryRecord('WorkOrder',csj.id,'EditCorrection__c',mapOldServiceJob.get(csj.id).EditCorrection__c,csj.EditCorrection__c);
                if(correctionHis != null){
                    lstjobhistory.add(correctionHis);
                }
            }
            if(csj.EditCoverage__c != mapOldServiceJob.get(csj.id).EditCoverage__c){
                CSS_JobHistory__c coverageHis = FSL_WorkorderTriggerHelper.createJobhistoryRecord('WorkOrder',csj.id,'EditCoverage__c',mapOldServiceJob.get(csj.id).EditCoverage__c,csj.EditCoverage__c);  
                if(coverageHis != null) {
                    lstjobhistory.add(coverageHis);
                }
            }
            if(csj.Non_SRT_Details__c != mapOldServiceJob.get(csj.id).Non_SRT_Details__c){
                CSS_JobHistory__c nonsrthis = FSL_WorkorderTriggerHelper.createJobhistoryRecord('WorkOrder',csj.id,'Non_SRT_Details__c',mapOldServiceJob.get(csj.id).Non_SRT_Details__c,csj.Non_SRT_Details__c);  
                if(nonsrthis != null) {
                    lstjobhistory.add(nonsrthis);
                }
            }
        }
        if(!lstjobhistory.isEmpty()){
            is4CInsertRun = true;
            insert lstjobhistory;
            
        }
    }
    
    /*
    *  Method name:  getcampaingintegration
    *  @description  Method to call getcampaign integration call 
    *  @param        Workorderlist , Map and Boolean , Boolean value to defferentiate the after insert and update .
    *  @Developer    Ravikanth M
    */
    public static void getcampaingintegration(list<workorder> lstworkorder,Map<Id,workorder> oldMap,Boolean bolcheck) {
        system.debug('in getcampaingintegration method WOHandle bolcheck:' + bolcheck+' lstworkorder:'+lstworkorder);
        for(workorder objwork :lstworkorder){
            system.debug('bolcheck:'+bolcheck+' getcampaingintegration objwork:' + objwork);
            if(objwork.AssetID!=null && !bolcheck){ //for Create
                system.debug('create FA objwork.id' + objwork.id);
                FSL_GETCampaignServices.storeApplicationOrCategoryComplaintList(objwork.id); 
            }
            else if(objwork.AssetID !=null && objwork.AssetID != oldMap.get(objwork.Id).AssetId && bolcheck){ //for Update
                system.debug('update FA objwork.id' + objwork.id+' bolcheck:'+bolcheck);
                if(oldMap.get(objwork.Id).AssetId !=null){ //only when AssetId !=null
                    deleteFieldActions(objwork.id);
                }
                FSL_GETCampaignServices.storeApplicationOrCategoryComplaintList(objwork.id);
                RecursiveTriggerHandler.isCheckFieldActions = false; //Added by Charan for bug CT3-380
            }else if(objwork.AssetID ==null && bolcheck){ //for Update && Asset is null
                if(oldMap.get(objwork.Id) !=null && oldMap.get(objwork.Id).AssetId !=null){ //only when old AssetId is there
                    system.debug('update FA null objwork.AssetID:' + objwork.AssetID);
                    deleteFieldActions(objwork.id); //Deleting FAs when Asset is null -- Added by Surender as part of CTE-2 story
                    system.debug('objwork.id-->'+objwork.id);
                    //WorkOrder objWO =[SELECT Id, FieldActionService_Failure_Flag__c   
                    //                  FROM WorkOrder WHERE id=:objwork.id ];  
                    //Commented By Sravanthi Gundreddy: removed Available_FAs_Count__c, Required_To_Complete__c fields from query beacuse of fieldactions issue we are deleting this two fields from object 
                    //objWO.Available_FAs_Count__c = 0;Line 270 
                    //objWO.Required_To_Complete__c = 0;Line270 
                    //objWO.FieldActionService_Failure_Flag__c = false; 
                    //update objWO; //if infinite loop, add Static flag to check    
                    //system.debug('After update objWO--->'+objWO);
                }
            }
        }
    }
    
    /*
    *  Method name:  getcampaingintegration
    *  @description  Method to call getTSBQSOLcall integration call 
    *  @param        Workorderlist , Map and Boolean , Boolean value to defferentiate the after insert and update .
    *  @Developer    Ravikanth M
    */
    public static void getTSBQSOLcall(list<workorder> lstworkorder, Map<Id,workorder> oldMap, Boolean bolcheck) {
        for(workorder objwork :lstworkorder) {
            if(objwork.AssetID!=null && !bolcheck) {
                system.debug('objwork.id' + objwork.id);
                FSL_TSB_Integration.TSBFromQSOL(objwork.id); 
            }
            else if(objwork.AssetID!=null && objwork.AssetID != oldMap.get(objwork.Id).AssetId && bolcheck) {
                system.debug('objwork.id' + objwork.id);
                FSL_TSB_Integration.TSBFromQSOL(objwork.id);
            }
        }
    }
    // End Ravikanth 
    
    public static void subStatusToTroubleshootingComplete(Map<Id,workorder> newWOMap,Map<Id,workorder> oldWOMap) {
        system.debug('********************** subStatusToTroubleshootingComplete Start******************************');
        WorkOrder newWorkOrder;
        WorkOrder oldWOrkOrder;
        
        for(Id wo:newWOMap.keySet()) {
            newWorkOrder = newWOMap.get(wo);
            oldWOrkOrder = oldWOMap.get(wo);
            if((oldWOrkOrder.Sub_Status__c !='Troubleshooting Complete' && newWorkOrder.Sub_Status__c == 'Troubleshooting Complete') || 
               (oldWOrkOrder.Sub_Status__c !='Send Account Updates' && newWorkOrder.Sub_Status__c == 'Send Account Updates')
              ) {
                  system.debug('newWorkOrder.Sub_Status__c' + newWorkOrder.Sub_Status__c);
                  system.debug('oldWOrkOrder.Sub_Status__c' + oldWOrkOrder.Sub_Status__c );
                  system.debug('Trigger Future WebServices Start');
                  //FSL_StatusUpdate.doCallUpdateWorkOrder(wo);
                  system.debug('Trigger Future WebServices End');
              }
        }
    }
    
    // Added Ravikanth
    public static void deleteFieldActions(Id lstworkoder) {
        set<Id> fielactionID = new set<Id>();
        set<ID> cssid = new set<ID>();
        
        List<CSS_Solution_Component__c> deletecss = new list<CSS_Solution_Component__c>();
        
        for(CSS_Solution_Component__c objcss : [SELECT Id FROM CSS_Solution_Component__c WHERE FSL_Service_Order__c = : lstworkoder ]) {
            deletecss.add(objcss);
            cssid.add(objcss.id);
        }
        if(cssid.size() > 0) {
            delete([select id from FSL_SRT__c where  Component_Id__c IN:cssid]);
        }
        if(deletecss.size() > 0) {
            Database.delete(deletecss, false); // deleting existing css solution comp
        }
    }
    
    public static void updateWarrantyServiceStatusToInProgress(Map<Id,workOrder> newWOMap, Map<Id,workOrder> oldWOMap) {
        WorkOrder newWorkOrder;
        WorkOrder oldWorkOrder;
        List<Id> lstWorkOrderIds = new List<Id>();
        for(Id wo:newWOMap.keySet()){
            newWorkOrder = newWOMap.get(wo);
            oldWorkOrder = oldWOMap.get(wo);
            if(oldWOrkOrder.AssetId != newWorkOrder.AssetId || 
               oldWOrkOrder.Application__c != newWorkOrder.Application__c || 
               oldWOrkOrder.Warranty_Start_Date__c != newWorkOrder.Warranty_Start_Date__c || 
               oldWOrkOrder.Mileage__c != newWorkOrder.Mileage__c ||
               oldWOrkOrder.CSS_Hours__c != newWorkOrder.CSS_Hours__c ||
               oldWOrkOrder.Mileage_Measure__c != newWorkOrder.Mileage_Measure__c ||
               oldWOrkOrder.Failure_Date__c != newWorkOrder.Failure_Date__c ||
               oldWOrkOrder.Before_In_Service__c != newWorkOrder.Before_In_Service__c
              )
            {
                lstWorkOrderIds.add(wo);
                newWorkOrder.Warranty_Integration_Status__c = 'Information Changed - Get Coverage';
                newWorkOrder.EditCoverage__c = '';
                newWorkOrder.Warranty_Integration_Descrption__c = '';
            } 
        }
        FSL_CL_IntakeWarrantyComp.deleteExistingCoverageAndCertificates(lstWorkOrderIds);
    }
    
    // Removing Duplicate Methods- Track4 Changes FBI-84(Jesse)     
    //Below method added to insert unique service order contact records on SO creation and update
    public static void insertServiceOrderContactList(List<workOrder> newWOs){
        system.debug('inside insertServiceOrderContactList***'+newWOs[0]);
        Set<Id> payerConList = new Set<Id>();
        Set<Id> AccConList = new Set<Id>();
        Set<Id> WOIds = new Set<Id>();
        List<ServiceOrderContact__c> insertSOCList = new List<ServiceOrderContact__c>();
        List<ServiceOrderContact__c> insertSOCList1 = new List<ServiceOrderContact__c>();
        if(newWOs != null){
            for(workOrder wo:newWOs){
                WOIds.add(wo.Id);
            }
            for(ServiceOrderContact__c soc : [select id, name, Account_Contact__c,Payer_Contact__c, Payer_Contact__r.Name from ServiceOrderContact__c where Service_Order__c IN: WOIds]){
                if(soc.Payer_Contact__c != null){
                    payerConList.add(soc.Payer_Contact__c);
                    AccConList.add(soc.Account_Contact__c);
                    
                }           
            }
        }
        system.debug('payerConList***'+payerConList);
        system.debug('newWOs data '+newWOs[0].payer__c);
        system.debug('newWOs data '+newWOs[0].Payer_ContactID__c);
        system.debug('newWOs data '+newWOs[0].Id);
        if(newWOs != null && newWOs.size()>0){            
            for(WorkOrder wo : newWOs){
                if(wo.Payer_ContactID__c != null){
                    if(payerConList == null || (!payerConList.contains(wo.Payer_contactId__c))) {
                        system.debug('inside111***');
                        //if(wo.Payer__c!= wo.AccountID){
                        if(wo.Payer_ContactID__c!= wo.ContactID){
                            ServiceOrderContact__c socObj = new ServiceOrderContact__c();
                            system.debug('** payer '+wo.Payer__c);
                            system.debug('** contact '+wo.Payer_contactId__c);
                            system.debug('** service order id '+wo.Id);
                            socObj.Payer_Account__c = wo.Payer__c;
                            socObj.Account__c = wo.AccountId; // As part of stroy CT4-98
                            socObj.Payer_Contact__c = wo.Payer_contactId__c;
                            
                            socObj.Service_Order__c = wo.Id;
                            socObj.Payer_Contact_Flag__c = true;
                            insertSOCList.add(socObj);
                            // }
                        }
                    }
                }// Start story CT4-93
                if(wo.ContactID != null){
                    if(payerConList == null || (!payerConList.contains(wo.ContactID))) {
                        //if(wo.Payer__c!= wo.AccountID){
                        ServiceOrderContact__c socObj1 = new ServiceOrderContact__c();                       
                        socObj1.Payer_Account__c = wo.Payer__c;
                        socObj1.Account__c = wo.AccountId; 
                        //socObj1.Payer_Contact__c = wo.Payer_contactId__c;
                        //socObj1.Account_Contact__c= wo.ContactID;
                        socObj1.Payer_Contact__c = wo.ContactID;
                        socObj1.Opt_In__c =True;
                        
                        socObj1.Service_Order__c = wo.Id;
                        //socObj1.Payer_Contact_Flag__c = true;
                        socObj1.Is_Inserted_Account_contact_del__c =true;
                        insertSOCList1.add(socObj1);
                        
                        // }   
                    }
                } // Endstory CT4-93
            }       
        }
        if(insertSOCList != null && insertSOCList.size() > 0) {
            if(!isSOCInsert) {
                insert(insertSOCList);
            }               
        }
        if(insertSOCList1 != null && insertSOCList1.size() > 0) {
            if(!isSOCInsert) {
                insert(insertSOCList1);// As part of stroy CT4-93
            }               
        }
    }        
    public static void serviceOrderSharing(Map<Id,workorder> NewMap, Map<Id,workorder> OldMap) {
        List<WorkOrderShare> woShareList = new List<WorkOrderShare>();
        Set<Id> serTerritoryId = new Set<Id>();
        Id workOrderId;
        Id recordOwner;
        Set<Id> territoryUsersList = new Set<Id>();
        for (workorder wrkorder : NewMap.values()){
            workOrderId = wrkorder.Id;
            recordOwner = wrkorder.ownerId;
            if (wrkorder.Type__c == 'Internal') {
                serTerritoryId.add(wrkorder.ServiceTerritoryId);
                }
        }
           
        if(serTerritoryId.size() > 0) {
            for(ServiceTerritoryMember objTeritorryMember : [SELECT id,OperatingHoursId,ServiceResourceId,ServiceResource.RelatedRecordId,ServiceTerritoryId FROM ServiceTerritoryMember WHERE ServiceTerritoryId =: serTerritoryId] ){
                if(objTeritorryMember.ServiceResource.RelatedRecordId != NULL && recordOwner != objTeritorryMember.ServiceResource.RelatedRecordId)
                    territoryUsersList.add(objTeritorryMember.ServiceResource.RelatedRecordId);
            }
            
            for(Id territoryUser : territoryUsersList){
                WorkOrderShare woShare = new WorkOrderShare();
                woShare.AccessLevel = 'edit';
                woShare.ParentId = workOrderId;
                woShare.UserOrGroupId = territoryUser;
                woShareList.add(woShare);
            }
            
            
            if(woShareList!= null && woShareList.size() != 0) {
                try {
                    system.debug('***woShareList**' + woShareList);
                    insert woShareList;
                } catch( Exception e) {
                    system.debug('Error::::::' + e.getMessage());
                }
            }
            
        }
        system.debug('woShareList###'+woShareList);
        
    }
    
    //Added by Vijay Start CT4-103
    public static void workorderTriggerHandleSOContactDEL(Map<Id, WorkOrder> NewMap, Map<Id, WorkOrder> Oldmap) {
        List<ServiceOrderContact__c> Del_serviceOrderContactList=new List<ServiceOrderContact__c>();
        
        List<ServiceOrderContact__c> serviceOrderContactList=new List<ServiceOrderContact__c>();
        
        serviceOrderContactList=[select id,Service_Order__c,Payer_Contact__r.AccountId,Account__c,Payer_Account__c from ServiceOrderContact__c where Service_Order__c IN: NewMap.keyset()];
        system.debug(serviceOrderContactList);
        for(ServiceOrderContact__c SOC:serviceOrderContactList){
            if(oldMap.containskey(SOC.Service_Order__c)){
                workorder WO=new workorder();
                WO=oldMap.get(SOC.Service_Order__c);
                if(  WO.AccountId!=WO.Payer__c && ( ( SOC.Payer_Contact__r.AccountId == WO.AccountId && SOC.Payer_Contact__r.AccountId != newMap.get(SOC.Service_Order__c).AccountId ) ||   (SOC.Payer_Contact__r.AccountId == WO.Payer__c && SOC.Payer_Contact__r.AccountId != newMap.get(SOC.Service_Order__c).Payer__c  ) ) ){
                    Del_serviceOrderContactList.add(SOC); 
                }else if(SOC.Payer_Contact__r.AccountId != newMap.get(SOC.Service_Order__c).AccountId && SOC.Payer_Contact__r.AccountId != newMap.get(SOC.Service_Order__c).Payer__c){
                    Del_serviceOrderContactList.add(SOC); 
                }
            }
        }
        if(Del_serviceOrderContactList.size() > 0){
            delete Del_serviceOrderContactList; 
        }
    }
    //added by vijay end CT4-103
    
    /* ---- Added by Dinesh Yadav, Start CT3-153   -----*/
    public static void DeleteTSBOnCloseWorkOrder(Map<Id, WorkOrder> NewMap, Map<Id, WorkOrder> Oldmap) {
        
        set<id> setWOId = new set<id>();
        WorkOrder newWorkOrder;
        WorkOrder oldWOrkOrder;
        for(Id wo:NewMap.keySet()) {
            newWorkOrder = NewMap.get(wo);
            oldWOrkOrder = Oldmap.get(wo);
            if((newWorkOrder.Status =='Closed' || newWorkOrder.Status =='Canceled') && newWorkOrder.Status != oldWOrkOrder.Status){
                setWOId.add(wo);
            }
        }
        
        if(setWOId != null && setWOId.size() > 0){
            list<CSS_CampTsbTrp__c> lstCampDelete = [select id,FSL_ServiceJob__c  from CSS_CampTsbTrp__c where FSL_ServiceJob__c in:setWOId];
            if(lstCampDelete.size()>0){
                Database.Delete(lstCampDelete ,false) ;
            }
        }
    }
    /*--- CT3-153 ends here --------*/
    
    //Added By Ravi as for US-384
    public static void populateGeneralSymptoms(list<WorkOrder> lstWO) {
        Set<Id> setMaintainceWR = new Set<Id>();
        Set<Id> setMaintaincePlan = new Set<Id>();
        Set<Id> setAssetId = new Set<Id>();
        map<string,MaintenanceAsset> mainPlan = new map<string,MaintenanceAsset>();
        for(WorkOrder objWO :lstWO) {
            if(objWO.MaintenanceWorkRuleId != null) {
                setMaintainceWR.add(objWO.MaintenanceWorkRuleId);
            }
            if(objWO.MaintenancePlanId != null) {
                mainPlan.put(objWO.MaintenancePlanId+':'+objWO.AssetId , null);
                setMaintaincePlan.add(objWO.MaintenancePlanId);
                setAssetId.add(objWO.AssetId);
            }
        }
        
        for(MaintenanceAsset objMA :[SELECT Id,AssetId,MaintenancePlanId,Branch_Code__c ,Sub_Type__c FROM MaintenanceAsset WHERE MaintenancePlanId IN :setMaintaincePlan AND AssetId IN : setAssetId]){
             mainPlan.put(objMA.MaintenancePlanId+':'+objMA.AssetId , objMA);
        }
        Map<Id, MaintenanceWorkRule> mapWorkRule;
        if(setMaintainceWR.size() > 0) {
            mapWorkRule= new map<Id, MaintenanceWorkRule>([SELECT Id, Title,ParentMaintenanceRecord.Branch_Code__c,ParentMaintenanceRecord.Sub_Type__c FROM MaintenanceWorkRule WHERE Id IN: setMaintainceWR]);
        }
            for(WorkOrder workOrderObj : lstWO){
                if(mapWorkRule != null && mapWorkRule.size() > 0 && mapWorkRule.containsKey(workOrderObj.MaintenanceWorkRuleId)) {
                    workOrderObj.General_Symptoms__c = mapWorkRule.get(workOrderObj.MaintenanceWorkRuleId).Title;
                }   //Raghav
                if(workorderobj.maintenancePlanId !=null){
                    workOrderObj.Branch_Code__c = mainPlan.get(workOrderObj.MaintenancePlanId+':'+workOrderObj.AssetId).Branch_Code__c;
                    workOrderObj.FSL_Sub_Type__c = mainPlan.get(workOrderObj.MaintenancePlanId+':'+workOrderObj.AssetId).Sub_Type__c;
                }
            }
        }
    
    // raghav
    public static void populateMaintenanceAsset_Parts(String jsonString){
        if(system.isBatch() || system.isFuture()){
            populateMaintenanceAsset_Parts_here(jsonString);
        }else{
            populateMaintenanceAsset_Parts_future(jsonString);
        }
    }
    
    @future
    public static void populateMaintenanceAsset_Parts_future(String jsonString){
        populateMaintenanceAsset_Parts_here(jsonString);
    }
    //Added by Ravi As for US-482
    private static void populateMaintenanceAsset_Parts_here(String jsonString) {
         List<WorkOrder> lstWO = (List<WorkOrder>)Json.deserialize(jsonString,List<WorkOrder>.class);
        Set<Id> setMaintaincePlan = new Set<Id>();
        Set<Id> setAssetId = new Set<Id>();
        Set<Id> setMAssetId = new Set<Id>();
        list<FSL_Custom_Part__c>lstcParts = new list<FSL_Custom_Part__c>();
        list<FSL_SRT__c> lstSRT = new list<FSL_SRT__c>();
        Map<Id,list<Workorder>> mapWO = new Map<Id,list<Workorder>>();
        list<Workorder> listWO = new list<Workorder>();
        
        Map<string,list<Maintenance_Asset_Part__c>> MaplistParts = new  Map<string,list<Maintenance_Asset_Part__c>>();
        Map<string,list<Maintenance_Asset_SRT__c>> Maplistsrts = new  Map<string,list<Maintenance_Asset_SRT__c>>();
        Id pmPartRTId = Schema.SObjectType.FSL_Custom_Part__c.getRecordTypeInfosByDeveloperName().get('Preventive_Maintenance_Part').getRecordTypeId();
        
        for(WorkOrder workOrderObj : lstWO) {
            if(workOrderObj.MaintenancePlanId != null) {
                setMaintaincePlan.add(workOrderObj.MaintenancePlanId);
                setAssetId.add(workOrderObj.AssetId);
                
                if(!mapWO.containsKey(workOrderObj.AssetId)) {
                    mapWO.put(workOrderObj.AssetId, new List<WorkOrder>());
                }
                mapWO.get(workOrderObj.AssetId).add(workOrderObj);
                listWO.addAll(mapWO.get(workOrderObj.AssetId));
            } 
            
        }
        set<Id> duplicatecheck = new set<Id>();
        Map<Id,MaintenanceAsset> assetMap = new Map<Id,MaintenanceAsset>();
        if(mapWO!=null) {
            for(MaintenanceAsset objMA :[SELECT Id,AssetId,MaintenancePlanId,(select id,Name,Sub_Location__c,Product_Code__c,ERP_Flag__c,Quantity_Ordered__c,Part_Description__c,Quantity_Used__c,Staging_Location__c,Parts_Hub__c,Type__c,Part_Number__c,Maintenance_Asset__r.AssetId from Maintenance_Asset_Parts__r),(SELECT Id, Name, SRT_Description__c, SRT_Time__c, SRT_Quantity__c, SRT_Access_Code__c, Maintenance_Asset__r.AssetId 
                                                        FROM Maintenance_Asset_SRTs__r ) FROM MaintenanceAsset WHERE MaintenancePlanId IN :setMaintaincePlan AND AssetId IN : mapWO.keySet()]){
                setMAssetId.add(objMA.Id);
                assetMap.put(objMA.AssetId, objMA);
                MaplistParts.put(objMA.AssetId,objMA.Maintenance_Asset_Parts__r);
                Maplistsrts.put(objMA.AssetId,objMA.Maintenance_Asset_SRTs__r);                                            
             
            }
             system.debug('listWO--'+listWO);
            set<WorkOrder> setWO = new set<WorkOrder>();
            setWO.addall(listWO);
             for(WorkOrder objWO : setWO){
              system.debug('objWO1--'+objWO);
                 if(MaplistParts!=null){
                 for(Maintenance_Asset_Part__c  objMAP : MaplistParts.get(objWO.AssetId))   {
                          system.debug('objMAP2--'+objMAP);
                            FSL_Custom_Part__c objpart = new FSL_Custom_Part__c();
                            objpart.RecordTypeId = pmPartRTId; 
                            objpart.Service_Order__c = objWO.Id;
                            objpart.Name = objMAP.Name;  
                            objpart.Quantity_Used__c = objMAP.Quantity_Used__c;  
                            objpart.Staging_Location__c =objMAP.Staging_Location__c; 
                            objpart.Parts_Hub__c =objMAP.Parts_Hub__c; 
                            objpart.Part_Description__c =objMAP.Part_Description__c; 
                            objpart.Quantity_Ordered__c =objMAP.Quantity_Ordered__c; 
                            objpart.ERP_Flag__c =objMAP.ERP_Flag__c; 
                            objpart.Product_Code__c =objMAP.Product_Code__c; 
                            objpart.Sub_Location__c =objMAP.Sub_Location__c; 
                            objpart.Type__c =objMAP.Type__c; //CT2-857 Karthik Pedditi
                            objpart.Part_Number__c =objMAP.Part_Number__c;//CT2-857 Karthik Pedditi
                            lstcParts.add(objpart);
                 }  
                 }
            }
                    for(WorkOrder objWO : setWO){
                        if(Maplistsrts!=null){
                        for(Maintenance_Asset_SRT__c  objMASRT : Maplistsrts.get(objWO.AssetId))   {
                            FSL_SRT__c objSRT = new FSL_SRT__c();
                            objSRT.Type__c='Repair'; 
                            objSRT.Name =    objMASRT.Name; 
                            objSRT.SRT_Title__c =objMASRT.SRT_Description__c;  
                            objSRT.SRT_Time__c =objMASRT.SRT_Time__c; 
                            objSRT.SRT_Quantity__c =objMASRT.SRT_Quantity__c; 
                            objSRT.SRT_Access_Code__c =string.valueof(objMASRT.SRT_Quantity__c);
                            objSRT.Repair_SRTs__c =objWO.Id; 
                            objSRT.Service_Order__c=objWO.Id; 
                            lstSRT.add(objSRT);
                        }
                        }
                    }
                
            
            if(lstcParts.size() > 0) {
                Database.insert(lstcParts,false);
            }
            if(lstSRT.size() > 0) {
                Database.insert(lstSRT,false);
            }
        }
    }  
    //Ravi Story ends here
    
    public static void validateSTCUser(list<WorkOrder> lstWO) {
        system.debug('Inside Validate STC Method');
        Boolean stcFlag = false;
        string stcUserName;
        set<Id> woSTC = new set<Id>();
        set<Id> woServiceTerritory = new set<Id>();
        set<Id> woServiceTerritoryParent = new set<Id>();
        for(WorkOrder WO:lstWO) {
            if(WO.Service_Team_Contact__c != null) {
                woSTC.add(WO.Service_Team_Contact__c);
            } 
            if(WO.ServiceTerritoryId != null) {
                woServiceTerritory.add(WO.ServiceTerritoryId);
            }
        }
        
        system.debug('woServiceTerritoryID-'+woServiceTerritory);
        
        List<ServiceTerritory> lstST = [select ParentTerritoryId, Name from ServiceTerritory where Id in: woServiceTerritory];
        for(ServiceTerritory ST: lstST){
            if(ST.ParentTerritoryId != null) {
                woServiceTerritoryParent.add(ST.ParentTerritoryId); 
            }
        }
        
        system.debug('woServiceTerritoryParent ID-'+woServiceTerritoryParent);
        
        map<Id,Id> mapUserTerritories = new map<Id,Id>();
        List<FSL__User_Territory__c> lstUT = [select FSL__User__c, FSL__ServiceTerritory__c from FSL__User_Territory__c where FSL__User__c in: woSTC and (FSL__ServiceTerritory__c in: woServiceTerritory OR FSL__ServiceTerritory__c in:woServiceTerritoryParent)];
        for(FSL__User_Territory__c UT: lstUT){
            mapUserTerritories.put(UT.FSL__User__c, UT.FSL__ServiceTerritory__c);
        }
      
        
        system.debug('mapUserTerritories values--'+mapUserTerritories);
        for(WorkOrder WOS:lstWO) {
            //skip validation if WO created from Recommendation accepted
           
           //if(WOS.CreatedFromRecommendation__c)
                //continue;
            
            system.debug('STC--'+WOS.Service_Team_Contact__c);
            system.debug('Service Territory--'+WOS.ServiceTerritoryId);
            if(WOS.Service_Team_Contact__c != null && mapUserTerritories != null && !mapUserTerritories.isEmpty()){
                //if(mapUserTerritories.get(WOS.Service_Team_Contact__c) != null && mapUserTerritories.get(WOS.Service_Team_Contact__c) == WOS.ServiceTerritoryId){
                    system.debug('Inside IF');
                    stcFlag = true;
                /*}
                else {
                    if(WOS.MaintenancePlanId == null && WOS.Service_Team_Contact__c != null && WOS.ServiceTerritoryId != null)
                        WOS.addError('Selected service team contact does not have access to the service territory. Please select different service team contact.'); 
                }*/
            }
            else {
                if(!Test.isRunningTest() && WOS.MaintenancePlanId == null && WOS.Service_Team_Contact__c != null && WOS.ServiceTerritoryId != null && !((WOS.Status == 'Closed' || WOS.Status == 'Canceled') && runningUser.profile.name.containsIgnoreCase('CSS Integration')))
                   WOS.addError('Selected service team contact does not have access to the service territory. Please select different service team contact.'); 
            }
        }
    }
    
    // raghav
    public static void attachFormToPMWO(String jsonString){
        if(system.isBatch() || system.isFuture()){
            attachFormToPMWOHere(jsonString);
        }else{
            attachFormToPMWOFuture(jsonString);
        }
    }
    
    @future
    public static void attachFormToPMWOFuture(String jsonString){
        attachFormToPMWOHere(jsonString);
    }
    
    //Added By Harish For Implementation Of CT2-793
    private static void attachFormToPMWOHere(String jsonString){
        Map<Id, WorkOrder> mapNewWorkOrder = (Map<id, WorkOrder>)Json.deserialize(jsonString,Map<id, WorkOrder>.class);
        if(mapNewWorkOrder.keySet().size()>0){
            List<WorkOrder> woList = [SELECT Id/*, AccountId, Repair_Site_Address__c, MaintenancePlan.Contract_Number__c,MaintenancePlan.MaintenancePlanNumber,ServiceTerritoryId, FSL_Sub_Type__c, WorkTypeId, FSL_SMN__c, CreatedById, Application__c, AssetId, Engine_Family_Code_Form__c, Make__c, Model__c, 
(SELECT Id,OwnerId FROM Forms__r),
(SELECT Id,Status,Assigned_ServiceResource__r.RelatedRecordId,Assigned_ServiceResource__r.Is_a_Tech__c FROM ServiceAppointments WHERE Status = 'Dispatched' AND Is_a_Tech_Appointment__c = true)*/
                                      FROM WorkOrder
                                      WHERE Id = :mapNewWorkOrder.keySet() AND MaintenancePlanId <> null AND (MaintenancePlan.Contract_Number__c <> null
                                                                                                              OR MaintenancePlan.MaintenancePlanNumber <> null )];
            if(!woList.isEmpty()){
                for(WorkOrder wo: woList){
                    if(!Test.isRunningTest())
                    FSL_AttachFormsController.createForm_apex(wo.id);
                }
            }
        }
    }
    
    public static Map<Id,FSL_SubType__c> woSubTypeMap(List<workOrder> woList) {
        Set<Id> SubTypeIds = new Set<Id>();
        Map<Id,FSL_SubType__c> SubTypeMap;
        for(workOrder wo: woList){
            SubTypeIds.add(wo.FSL_Sub_Type__c);
        }
        if(SubTypeIds.size()>0){
            //SOQL Map
            SubTypeMap= new Map<Id,FSL_SubType__c>([SELECT Id, Name, Code_Value__c FROM FSL_SubType__c WHERE Id=:SubTypeIds]);
            return SubTypeMap;
        }
        return SubTypeMap;
    }
        
     //Added by Harini - as a part of CT4-714
    public static void updateSubStatus(List<WorkOrder> newList,Map<Id, WorkOrder> Oldmap){
        system.debug('Inside UpdateSubStatus method');
        system.debug('newlist'+newlist[0].city);
        for(WorkOrder wo:newList){
            if(wo.IAS_Number__c !=null && Oldmap !=null  && (Oldmap.get(wo.id).IAS_Number__c == null || Oldmap.get(wo.id).IAS_Number__c == '')
               &&(wo.Status=='Intake' || wo.Status=='Scheduled') && (wo.Repair_Location__c =='In Shop')){
                   wo.Sub_Status__c = 'Unit/Vehicle on Lot';
                   //wo.Equipment_available__c = true; 
                   wo.IAS_Number_Populated__c = true;
               } 
        }
    
    //Added by Harini - as part of FBI-82
    if(Oldmap==null && newList !=null){
    for(WorkOrder wo:newList){
    if(wo.IAS_Number__c !=null &&(wo.Status=='Intake' || wo.Status=='Scheduled') && (wo.Repair_Location__c =='In Shop')){
           system.debug('+++++++++++updatesubstatus');
             wo.Sub_Status__c = 'Unit/Vehicle on Lot';
            wo.IAS_Number_Populated__c = true;
       } 
}
}
} 
 //Added by Sriprada - 10/12/2021 as part of VGRS2-28
    public static void updateUnitNumber(Map<Id,workorder> newMap,Map<Id, WorkOrder> Oldmap){
        system.debug('Inside Update method');
        avoidAfterupdate = true;
        for(WorkOrder wo:newMap.Values()){
            WorkOrder oldwo = oldMap.get(wo.Id);
            system.debug('OldMap****'+oldwo);
            if((wo.Type__c =='Dealer') && (oldwo != null && oldwo.Dealer_Unit_Number__c != wo.Dealer_Unit_Number__c) && ((oldwo.AssetId != wo.AssetId) ||(oldwo.AssetId == wo.AssetId))) {
                RecursiveTriggerHandler.isWorkOrderUpdate = false;
                Asset ast = [SELECT Id, Unit_Number__c, Engine_Manufacturer__c, Make_Model__c FROM Asset WHERE Id = : wo.AssetId LIMIT 1];

              /*  Asset ast = new Asset();
                ast.Id = wo.AssetId;
                ast.Unit_Number__c = wo.Dealer_Unit_Number__c; */
                system.debug('UnitNumberUpdate:::'+ast.Engine_Manufacturer__c);

                if(ast.Engine_Manufacturer__c == 'CUMMINS'){
                    ast.Unit_Number__c = wo.Dealer_Unit_Number__c;
                    update ast;  
                    system.debug('UnitNumberUpdate:::'+ast);
                    
                }
            } 
        }
    }   
}