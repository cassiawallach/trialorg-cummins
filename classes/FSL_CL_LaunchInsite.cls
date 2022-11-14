/**********************************************************************
Name:FSL_CL_LaunchInsite
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
------- 
It is used to Launch the insite app when you click on Insite button on T&Dss
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE         CHANGE                            
1.0     Ravikanth Macherla         1/21/2019       
2.0     Sakthiraj                  7/25/2022     Added methods for FTR Automation API  
3.0     Sakthiraj                  08/11/2022         Added methods related to Get SRT Parts and Get Part Returns Integration           
***********************************************************************/
public class FSL_CL_LaunchInsite {
    
    @AuraEnabled
    public static WorkOrder getjobordernumber(string strjobId) {
        system.debug(':::workorderid--->'+strjobId);
        //Updated query to include EVL related fields - Sruthi
        return [select id, isCICOVisible__c, AccountId,ServiceTerritory.isVisibileCICO__c,WorkOrderNumber,contact.name,AssetId,Asset.Name,ESN_Insite__c,User__r.id,User__r.Name,FaultCode_Max_Sequence__c,FSL_Locked_Assest__c,Clock_In_User_Ids_Formula__c,EVL_Assigned_Technician__c,User__c,CreatedById,CreatedBy.Name, Service_Location_Code__c  from WorkOrder where id=:strjobId limit 1];
    }
    
    @AuraEnabled
    public static Boolean fetchTakeControl(string strjobId){
        
        return EVL_TDSController.fetchTakeControl(strjobId);
    }
    
    @AuraEnabled
    public static WorkOrder getWorkOrderData(string workOrderId) {
        System.debug('::: getWorkOrderData called - '+workOrderId);
        WorkOrder w = [Select Id, AssetId, ESN_Insite__c From WorkOrder where id=:workOrderId limit 1];
        System.debug('::: WorkOrder - '+w.AssetId+' and '+w.ESN_Insite__c);
        WorkOrder wo;
        if(w.ESN_Insite__c != null ){
            List<Asset> assetList = [Select Id From Asset where Name=: w.ESN_Insite__c];
            if(!assetList.isEmpty()) {
                if(w.AssetId == null ) {
                    WorkOrder workOrd = new WorkOrder();
                    workOrd.Id = workOrderId;
                    workOrd.AssetId = assetList[0].Id;
                    workOrd.EVL_Solution_Marked_Most_Likely__c = false;
                    System.debug(':::: WorkOrder Before - '+workOrd);
                    update workOrd;
                    System.debug(':::: WorkOrder After - '+workOrd);
                }
                
                system.debug(':::workorderid--->'+workOrderId);
                wo = new WorkOrder();
                wo =  [select id, AccountId ,WorkOrderNumber,contact.name,AssetId,Asset.Name,ESN_Insite__c,User__r.id,User__r.Name,FaultCode_Max_Sequence__c,FSL_Locked_Assest__c  from WorkOrder where id=:workOrderId limit 1];
                
            } else {
                wo = new WorkOrder();
                wo =  [select id, AccountId ,WorkOrderNumber,contact.name,AssetId,Asset.Name,ESN_Insite__c,User__r.id,User__r.Name,FaultCode_Max_Sequence__c,FSL_Locked_Assest__c  from WorkOrder where id=:workOrderId limit 1];
            }
        }
        return wo;
    }
    
    //Piyush
    //Use Insite PSN Button Select
    @AuraEnabled
    public static String checkAsset(string assestNum,String accountId, string strjobId) {
        system.debug(':::assestNum**'+assestNum);
        system.debug(':::accountId**'+accountId);
        try{
            //List<Asset> assetLst = [select id,name,AccountId from Asset where name =:assestNum and accountId =:accountId];
            List<Asset> assetLst = [select id,name,AccountId from Asset where name =:assestNum];
            system.debug(':::assetLst###'+assetLst);
            if(!assetLst.isEmpty()){
                WorkOrder wo = new Workorder();
                wo.id = strjobId;
                wo.AssetId = assetLst[0].id;
                wo.FSL_Locked_Assest__c  = assestNum;
                //Clear Asset related fields
                //wo.Mileage__c = null;
                //wo.CSS_Hours__c = null;
                //wo.Fuel_Burn__c = null;
                 //wo.Warranty_Start_Date__c = 
                system.debug('::: Before WO Update###'+wo);
                update wo;
                system.debug('::: After WO Upate***'+wo);
            }
            return assetLst.isEmpty()?'No Assest exist':'';
        }
        catch (exception e){
            throw new AuraHandledException(e.getMessage());
        }
        //return [select id, WorkOrderNumber,contact.name,Asset.Name,ESN_Insite__c from WorkOrder where id=:strjobId limit 1];
    }
    
    @AuraEnabled
    public static Integer checkCountFaultcode(string strjobId) {
        system.debug(':::strjobId**'+strjobId);
        Integer falutCodecount;
        ID sObjid = Id.valueof(strjobId);
        String objectname = sObjid.getSObjectType().getDescribe().getName();
        integer maxseq = FSL_orderController.maxSequenceMethod(sObjid);
        System.debug('::: MaxSeq - '+maxseq);
        /*if(objectname == 'WorkOrder'){
        falutCodecount = [select count() from CSS_Fault_Code__c where Service_Order__c =:strjobId and Status__c != null  and Count__c != null ];   
        }
        else{
        falutCodecount = [select count() from CSS_Fault_Code__c where Job_Order__c =:strjobId and Status__c != null and Count__c != null ]; 
        }*/
        //falutCodecount = 0; 
        return maxseq;
    }
    //Piyush End
    
    @AuraEnabled
    public static void captureFaultCodeAuditTrack(String workOrderId) {
        try {
            String faultCodes = getFaultCodes(workOrderId);
            System.debug('::: faultCodes - '+faultCodes);
            FSL_CumminsUtilities.auditTrailInsert('Event-02', workOrderId ,'Received Insite Fault Codes',faultCodes,'','');
        } catch(Exception ex) {
            System.debug('::: Exception in captureFaultCodeAuditTrack - '+ex.getMessage());
        }
    }
    
    public static String getFaultCodes(String workOrderId) {
        String priorityCodes = 'Prioritized Fault Codes :';
        Set<String> prioritySet = new Set<String>();
        Set<String> nonPrioritySet = new Set<String>();
        for(CSS_Fault_Code__c fc : [Select id,name,Status__c from CSS_Fault_Code__c where Service_Order__c=:workOrderId and Status__c != null 
                                    and Count__c != null AND (Fault_Code_Type__c ='APD-P' OR Fault_Code_Type__c ='APD-R' OR Fault_Code_Type__c='BPD' OR Fault_Code_Type__c='BLANK')]) {
                                        prioritySet.add(fc.name);
                                    }
        String nonPriorityCodes = 'Non Prioritized Fault Codes :';
        for(CSS_Fault_Code__c fc : [select Service_Order__c,id,name,DSID__c,Number_of_Solutions__c,Status__c,Count__c,sequence__c from CSS_Fault_Code__c where Service_Order__c!= null AND 
                                    Service_Order__c=:workOrderId  and Status__c != null and Count__c != null AND (Fault_Code_Type__c!='APD-P' AND Fault_Code_Type__c!='APD-R' AND Fault_Code_Type__c!='BPD')]) {
                                        nonPrioritySet.add(fc.name);
                                    }
        String FaultCodesString = priorityCodes+prioritySet+' and '+nonPriorityCodes+nonPrioritySet;
        return FaultCodesString;
    }
    
    @AuraEnabled
    public static void captureLaunchInsiteAuditTrack(String workOrderId) {
        try {
            FSL_CumminsUtilities.auditTrailInsert('Event-01', workOrderId ,'Launched INSITE','','','');
        } catch(Exception ex) {
            System.debug('::: Exception in captureLaunchInsiteAuditTrack - '+ex.getMessage());
        }
    }
    
    //This method will be invoked when click on Takecontrol button and updating with logged user id added by Ravikanth
    @AuraEnabled
    public static WorkOrder hidetakecontrol(string strjobId) {
        system.debug('Test'+strjobId);
        //Call RSW WebService for Dealer. Dealer condition is checked in the EVL_CL_RSW Classs.
        EVL_CL_RSW.buildRSWUpdateClaimReqWrapper(strjobId);
        
        WorkOrder objord = [select id, WorkOrderNumber,contact.name,Asset.Name,ESN_Insite__c from WorkOrder where id=:strjobId limit 1] ;
        objord.User__c = userinfo.getUserId();
        
        try{
            update objord ; 
        } catch(Exception ex)
        {
            throw new AuraHandledException(ex.getMessage());
        }
        return objord ;
    }
    //Ravikanth End
    
    // 2.0 Sakthiraj - 07/28/22 - SG-82 and SG-83 - Method to call API's for FTR Automation
    //This method will call Get solutions API
    @AuraEnabled
    public static string getSolutionsForFTR(Id woId){
        return FSL_CL_FTRUtility.getSolutionsForFTR(woId, false);
    }
    // This method will call Get options, GET SRT Repait and Get Detail coverage
    @AuraEnabled
    public static void callGetOptionsAndOtherApis(Id serviceOrderId){
        FSL_CL_FTRUtility.callGetOptionsAndOtherApis(serviceOrderId);
    }
    //2.0 End FTR API Automation End - Sakthiraj - SG-82 and SG-83
    //3.0 Start - Get SRT Parts and Get Part Returns for FTR - SG 99
    @AuraEnabled
    public static void callGetPartsAndPartReturn(Id serviceOrderId){
        FSL_CL_FTRUtility.callGetPartsAndPartReturn(serviceOrderId);
    }
    //3.0 End
}