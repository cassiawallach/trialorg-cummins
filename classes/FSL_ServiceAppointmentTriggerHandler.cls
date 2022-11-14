/*
* Description: Trigger Handler class to excute and call business logic.
* CT3-198
*/
public class FSL_ServiceAppointmentTriggerHandler {
    
    public static Boolean isAfterUpdateExecutingRecurssive = false;
  //  public static Boolean isBeforeUpdateExecutingRecurssive = false; //Added: Charan CT3-562
    
    public static void ServiceAppointmentHandlerBeforeInsert(List<ServiceAppointment> newList) {
        
                
        Map<Id, Id> saIdResourceUserIdMap = new Map<Id, Id>();
        Map<Id, String> serviceOrderVsWoMap = new Map<Id, String>();
        Set<Id> saIdsSet = new Set<Id>();
        Set<Id> SAIds = new Set<Id>();
        
        for(ServiceAppointment sa: newList) {

            if(sa.Service_Order__c != null)
                
            if(sa.Status =='Scheduled') {
                saIdsSet.add(sa.Id);
            }
            
            //Collecting Dispatched ServiceAppointment Ids 
            if(sa.status == 'Dispatched') {
                SAIds.add(sa.Id);
            }
            
            /*Commenting as part of CT2-663*/
            /*
            if(sa.Service_Order__c == null && sa.ParentRecordId != sa.AccountId) {
                sa.Service_Order__c=sa.ParentRecordId;       
            }
            */
            /*CT2-663*/
            String parentRecordId = sa.ParentRecordId;
            if(parentRecordId != null && parentRecordId.startsWith('0WO')){
                sa.Service_Order__c = sa.ParentRecordId;
                if(sa.Assigned_ServiceResource__c != null) {
                    sa.Assigned_ServiceResource__c = null;
                }
            }
            
            if(sa.SchedStartTime != null) {
                sa.Formatted_Scheduled_Start__c = sa.SchedStartTime.format();
            }
        }
        for(ServiceAppointment sa : newList) {
            if(SAIds.contains(sa.Id)) {
                DateTime startTime = sa.SchedStartTime;
                DateTime currentTime = System.now();
                if(startTime != null) {
                    Long timeAvailable = (currentTime.getTime()/(1000*60)) - (startTime.getTime()/(1000*60));
                    if(timeAvailable >= 5) {
                        sa.CICO_No_Login__c = true;
                    }
                }
            }
        }
        
        // Added for CICO -----------------------
        if(!saIdsSet.isEmpty()) {
            for(AssignedResource arObj: [select Id, ServiceAppointmentId, ServiceResourceId, ServiceResource.RelatedRecordId 
                                         from AssignedResource where ServiceAppointmentId in:saIdsSet]){
                saIdResourceUserIdMap.put(arObj.ServiceAppointmentId, arObj.ServiceResource.RelatedRecordId);
            }
        }
        
        if(!saIdResourceUserIdMap.isEmpty()) {
            for(ServiceAppointment sa: newList) {
                // Assign the User Id for the AssignedResource on the appointment
                sa.User__c = saIdResourceUserIdMap.get(sa.Id);
            }
        }
        // ---------------------------------------
        fSLServiceAppointmentAutomation(newList,Null);
    }
    
     //This method invokes from after update
     //commeting this for further testing karthik G track 2
     /*
    public static void UpdateFSLScheduleStartTimeonServiceOrder(List<ServiceAppointment> saLst, Map<Id, ServiceAppointment> saOldMap){
        
        Set<ID> serviceOrderIds = new Set<ID>();
       for (ServiceAppointment sa : saLst) {
            ServiceAppointment oldSA;
            if(saOldMap != null) {
                oldSA = saOldMap.get(sa.Id);
            }
            if(oldSA != null && sa.SchedStartTime != oldSA.SchedStartTime && 
              sa.Service_Order__c!=null) {
                serviceOrderIds.add(sa.Service_Order__c);
               //FSL_Scheduled_Start__c   
            }
        }
        
        List<ServiceAppointment> listServiceAppointMent = new List<ServiceAppointment>([Select SchedStartTime,id 
                                                                                       from ServiceAppointment 
                                                                                       where Service_Order__c IN : serviceOrderIds Order by SchedStartTime ASC]);
        
        Map<Id,ServiceAppointment> mapServiceApp = new Map<Id,ServiceAppointment>();
        for(ServiceAppointment sa : listServiceAppointMent ){
            if(!mapServiceApp.containsKey(sa.Service_Order__c))
                mapServiceApp.put(sa.Service_Order__c,sa);
        }
        
        List<WorkOrder> salstUpdate = new List<WorkOrder>();
        
        for (ServiceAppointment sa : saLst) {
            if(mapServiceApp.containsKey(sa.Service_Order__c)){
                WorkOrder objService_Order = new WorkOrder();
                objService_Order.Id = sa.Service_Order__c;
                objService_Order.FSL_Scheduled_Start__c    = mapServiceApp.get(sa.Service_Order__c).SchedStartTime;
                salstUpdate.add(objService_Order);
            }
        }
        
        update salstUpdate ;
    
    }
        
        */
        
    //This method invokes from before insert
    public static void fSLServiceAppointmentAutomation(List<ServiceAppointment> saLst, Map<Id, ServiceAppointment> saOldMap){
        
        Set<ID> serviceOrderIds = new Set<ID>();
        for(ServiceAppointment sa: saLst){
            if(sa.Service_Order__c!=null)
                serviceOrderIds.add(sa.Service_Order__c);
        }
        Map<Id,WorkOrder> saParentFieldsMap = new 
            Map<Id,WorkOrder>([Select 
                               DurationInMinutes, Account.Name,General_Symptoms__c, 
                               AccountId from WorkOrder where Id in: 
                               serviceOrderIds]);
		for(ServiceAppointment sa : saLst) {
            ServiceAppointment oldSA;
            WorkOrder saParentFieldObj;
            saParentFieldObj = saParentFieldsMap.get(sa.Service_Order__c);
            if(saOldMap != null) {
                oldSA = saOldMap.get(sa.Id);
            }
            System.debug('karthikinsideForrrr>>');
            //Check has parent work order
            if((saOldMap == null || String.isNotBlank(sa.Service_Order__c)) 
                || (sa.Service_Order__c != oldSA.Service_Order__c && String.isNotBlank(sa.Service_Order__c))) {
                    System.debug('karthikinsideiiiiffffffffff>>');
                 
                //Set Duration
                if(sa.Duration == null) {
                    sa.Duration = saParentFieldObj.DurationInMinutes/60;//Vamsi - 03/07 - Changed the default duration to hrs conversion
                    sa.DurationType = 'Hours';//Vamsi - 03/07 - Changed the default duration type to hrs
                }
                //Set Grant Label
				//if(oldSA != null && oldSA.Status != sa.Status && sa.FSL__GanttLabel__c != oldSA.FSL__GanttLabel__c) {
                //Mallika changes starts
               // system.debug('oldSA.Status>>'+oldSA.Status);
               //system.debug('oldSA.AccountId>>'+oldSA.AccountId);
                    system.debug('sa.AccountId>>'+sa.AccountId);
                    system.debug('sa.Status>>'+sa.Status);
                if(oldSA != null && oldSA.AccountId != sa.AccountId && (sa.Status =='None' || sa.Status =='Scheduled') || (oldSA != null && oldSA.AccountId == sa.AccountId) ) {
                //Mallika changes Ends
                    system.debug('insideif170>>>');
                    if(String.isNotBlank(saParentFieldObj.AccountId)) {
                         system.debug('insideif172>>>');
                        sa.FSL__GanttLabel__c = saParentFieldObj.Account.Name + '('+sa.AppointmentNumber+')';
                    }
                    else {
                         system.debug('insideif176>>>');
                        sa.FSL__GanttLabel__c = sa.AppointmentNumber;
                    }
                }
                system.debug('sa.FSL__GanttLabel__c'+sa.FSL__GanttLabel__c);
                //Set Is Multiday only for non-pilot Multi-Resource users - Vamsi 04/19/2022 - Added switch on user permission
                boolean sMRDTPilotUser = FeatureManagement.checkPermission('FSL_MRAW_Accessible');
                if(sMRDTPilotUser == false && sa.FSL__IsMultiDay__c == false && ((sa.Assigned_ServiceResource__r.ResourceType == 'T' && sa.FSL_Parent_Crew_SA__c!= null) 
                   || (oldSA == null && sa.FSL_Parent_Crew_SA__c == null))) { 
                    sa.FSL__IsMultiDay__c = true;
                }
                //Set General Symptoms
                if(saParentFieldObj.General_Symptoms__c!=null && saParentFieldObj.General_Symptoms__c.left(100)!= sa.General_Symptoms__c) {
                    sa.General_Symptoms__c = saParentFieldObj.General_Symptoms__c.left(100);
                }
               
            }
            
            //Vamsi - 02/24/2022 - Logic change for Duration update on End time change (Gantt Update action related)
            if(oldSA != null && sa.Duration == oldsa.Duration && sa.SchedEndTime != oldSA.SchedEndTime && sa.SchedStartTime == oldSA.SchedStartTime) {
                if(sa.SchedStartTime != null && sa.SchedEndTime != null) {
                    sa.Duration= (sa.SchedEndTime.getTime() - sa.SchedStartTime.getTime())/3600000;                
                    sa.DurationType = 'Hours';
                }
            }
        }
    }
    
    //This methods invokes after insert and after upadte
    public static void postToChatter(List<ServiceAppointment> saLst) {
        String body = System.Label.PostMsgForServiceAppointmentAutomation;
        Map<Id, ServiceAppointment> saParentFieldsMap = getSAParentFieldMap(saLst);
        List<ServiceAppointment> saLstAsUpdate = new List<ServiceAppointment>();
        List<FeedItem> postToChatterLst = new List<FeedItem>();
        for(ServiceAppointment sa : saLst) {
            //IsPassedSchTime
            if(sa.FSL_Passedschtime__c==true && sa.SR_Clocked_In__c==false && sa.Overdue_Alert_Sent__c==false) {
                //Post clockin overdue alert to the record
                FeedItem post = new FeedItem();
                post.ParentId = sa.Id;
                List<Object> parameters = new List<Object> {sa.OwnerId, sa.Service_Order__r.WorkOrderNumber, sa.User__c};
                post.Body = String.format(body, parameters);
                postToChatterLst.add(post);
                if(sa.Overdue_Alert_Sent__c == false) {
                    sa.Overdue_Alert_Sent__c = true;
                    saLstAsUpdate.add(sa);
                }
                
            }
        }
        if(!postToChatterLst.isEmpty()) {
            insert postToChatterLst;
        }
        if(!saLstAsUpdate.isEmpty()) {
            update saLstAsUpdate;
        }
    }
    
    private static  Map<Id, ServiceAppointment> getSAParentFieldMap(List<ServiceAppointment> saLst) {
        return new Map<Id, ServiceAppointment>([select Id, Service_Order__r.DurationInMinutes, Service_Order__r.Account.Name, 
                                                Service_Order__r.AccountId,
                                                Service_Order__r.General_Symptoms__c,Service_Order__r.WorkOrderNumber
                                                from ServiceAppointment where Id IN :saLst]);
    }
    
   
    
    /* public static void ServiceAppointmentHandlerAfterInsert(List<ServiceAppointment> newSAList) {
        // Bharat - 101, commenting this - populateResourceDetails required only when SA.Status changed to 'Scheduled'
        // FSL_ServiceAppointmentHelper.populateResourceDetails(New Map<id,ServiceAppointment>(newSAList), NULL);
    } */
    
    public static void ServiceAppointmentHandlerBeforeUpdate(Map<Id, ServiceAppointment> newMap, Map<Id, ServiceAppointment> oldMap) {
        Map<Id, String> serviceOrderVsWoMap = new Map<Id, String>();
        Set<Id> saIdsSet = new Set<Id>();
        Map<Id, Id> saIdResourceUserIdMap = new Map<Id, Id>();
        Set<Id> saIdssSet = new Set<Id>();
        
       // if(!isBeforeUpdateExecutingRecurssive) {  //Added: Charan CT3-562 
          //  isBeforeUpdateExecutingRecurssive = true; //Added: Charan CT3-562
        for(ServiceAppointment sa: newMap.values()) {
            if(oldMap!=null && sa.Status=='Scheduled'|| sa.Status=='Dispatched') {
                saIdsSet.add(sa.Id);
            }
            
            if(oldMap!=null && sa.SchedStartTime!=null && sa.SchedStartTime!=oldMap.get(sa.Id).SchedStartTime){
                sa.Formatted_Scheduled_Start__c = sa.SchedStartTime.format();
            }
            
            if((sa.Status=='Dispatched' && sa.Status != oldMap.get(sa.Id).Status) || (sa.SchedStartTime != oldMap.get(sa.Id).SchedStartTime)) {
                DateTime startTime = sa.SchedStartTime;
                DateTime currentTime = System.now();
                if(startTime != null) {
                    Long timeAvailable = (currentTime.getTime()/(1000*60)) - (startTime.getTime()/(1000*60));
                    if(timeAvailable >= 5) {
                        sa.CICO_No_Login__c  = true;
                    }
                }
            }
            //Service Appointment Status update Validation MV-683
            if(sa.Dispatched_Checkbox__c == true && oldMap.get(sa.Id).Dispatched_Checkbox__c != true){
                if(oldMap.get(sa.Id).Status != 'Scheduled'){
                    sa.addError('Status value should be Scheduled before moving it to Dispatched');
                }else{   
                	sa.Status = 'Dispatched';
                }
            }            
        }
        
        System.debug('serviceOrderVsWoMap : ' + serviceOrderVsWoMap);
        
        // Added for CICO -----------------------
        if(!saIdsSet.isEmpty()) {
            for(AssignedResource arObj: [select Id, ServiceAppointmentId, ServiceResourceId, ServiceResource.RelatedRecordId 
                                         from AssignedResource where ServiceAppointmentId in:saIdsSet]){
                saIdResourceUserIdMap.put(arObj.ServiceAppointmentId, arObj.ServiceResource.RelatedRecordId);
            }
        }
        
        if(!saIdResourceUserIdMap.isEmpty()) {
            for(ServiceAppointment sa: newMap.values()) {
                // Assign the User Id for the AssignedResource on the appointment
                sa.User__c = saIdResourceUserIdMap.get(sa.Id);
            }
        }
        
        List<Id> newSAListIds = new List<Id>(newMap.keySet());
        if(!newSAListIds.isEmpty() && !(System.isFuture())){
             //  updateExtendScheduledEndField(newSAListIds);
        }
        
        fSLServiceAppointmentAutomation(newMap.values(),oldMap);
       // } //Added: Charan CT3-562
        // ---------------------------------------
    }
    // public static boolean trgCtrlAfterUpdate = true;
    
    public static void ServiceAppointmentHandlerAfterUpdate(Map<Id, ServiceAppointment> newMap, Map<Id, ServiceAppointment> oldMap) {
        System.debug('isAfterUpdateExecutingRecurssive' + isAfterUpdateExecutingRecurssive);
        if(!isAfterUpdateExecutingRecurssive) {
            isAfterUpdateExecutingRecurssive = true;
            FSL_ServiceAppointmentHelper.populateTechnicianDispatchStatus(newMap,oldMap);
            //FSL_ServiceAppointmentHelper.populateResourceDetails(newMap, oldMap);
            
            /*List<Id> newSAListIds = new List<Id>(newMap.keySet());
            if(!newSAListIds.isEmpty() && !(System.isFuture())) {
                updateExtendScheduledEndField(newSAListIds);
            }*/
        }
        
        // Bharat - 101, added conditions in if
        List<ServiceAppointment> newLstSA = newMap.values();
        List<ServiceAppointment> oldLstSA = oldMap.values();
        if(RecursiveTriggerHandler.checkResource && newLstSA[0].Status != oldLstSA[0].Status && newLstSA[0].Status == 'Scheduled') {
            FSL_ServiceAppointmentHelper.populateResourceDetails(newMap, oldMap); //Added by Ravi Bug CT2-507
            system.debug('populateResourceDetails...'+ newMap +'***'+oldMap +'**');
        }
    }
    
    //CT2-56 :Service  Appointment sharing for technicians to enable read access on Event Record//
    public static void ServiceAppointmentUserSharing(List<ServiceAppointment> newList,Map<Id,ServiceAppointment> oldMap){
        System.debug('**entered in SA sharing**');
        set<Id> serviceorderId = new set<Id>();
        set<Id> userIdtoShare = new set<Id>();
        set<Id> AssignedResourceUserIdtoShare = new set<Id>();
        Set<Id> technicianUId = new set<Id>();
        //set<Id> CId = new set<Id>();
        Id CId; //CT4-585
        List<ServiceAppointmentShare> SAShareList = new List<ServiceAppointmentShare>();
        List<CaseShare> SRShareList = new List<CaseShare>(); //CT4-585
        List<CaseShare> AssignedResourceSRShareList = new List<CaseShare>(); //CT4-585
       // if(!isAfterUpdateExecutingRecurssive) { //Added: Charan CT3-562
          //  isAfterUpdateExecutingRecurssive = true;
       for (ServiceAppointment SA: newList){
            //if(oldMap.get(SA.id).status != 'Dispatched' && SA.Status=='Dispatched'){
                serviceorderId.add(SA.Service_Order__c);
                
            //}
        }
        
        system.debug('***serviceorderId**' + serviceorderId);
        if(serviceorderId.size()> 0){
            List<ServiceAppointment> SAList = [select Id,status,User__c,Service_Order__r.caseID,Assigned_ServiceResource__r.User__c from ServiceAppointment where Service_Order__c=: serviceorderId] ;
            for(ServiceAppointment SA:SAList){
                userIdtoShare.add(SA.User__c);
                //CId.add(SA.Service_Order__r.caseID);
                CId = SA.Service_Order__r.caseID; //CT4-585
                AssignedResourceUserIdtoShare.add(SA.Assigned_ServiceResource__r.User__c); //CT4-585
            }
            system.debug('***CaseID**' + CId);
            system.debug('***userIdtoShare**' + userIdtoShare);
            system.debug('***AssignedResourceUserIdtoShare**' + AssignedResourceUserIdtoShare);
            List<User> technicianUserList = [SELECT Id from User WHERE id=: userIdtoShare ];
            //List<User> AssignedResourceUserList = [SELECT Id from User WHERE id=: AssignedResourceUserIdtoShare];
            for(User u:technicianUserList){
                technicianUId.add(u.Id);
            }
            system.debug('***technicianUId**' + technicianUId);
            for( ServiceAppointment SA:SAList) {
                for(Id uid:userIdtoShare){
                    //if(SA.User__c != uid && technicianUId.contains(uid)){
                    /*ServiceAppointmentShare  SAShare= new ServiceAppointmentShare();
                    SAShare.AccessLevel = 'Read';
                    SAShare.ParentId = SA.Id;
                    SAShare.UserOrGroupId = uid;
                    SAShareList.add(SAShare); */
                    if(uid != null){
                    SAShareList.add(new ServiceAppointmentShare(AccessLevel = 'Read',ParentId = SA.Id,UserOrGroupId = uid));
                    
                    //}
                    SRShareList.add(new CaseShare(CaseAccessLevel = 'edit',CaseId = CId,UserOrGroupId = uid)); //CT4-585 
                    }
                }
                for(Id uid:AssignedResourceUserIdtoShare){
                    if(uid != null){
                    //AssignedResourceSRShareList.add(new CaseShare(CaseAccessLevel = 'edit',CaseId = CId,UserOrGroupId = uid)); //CT4-585 
                    SRShareList.add(new CaseShare(CaseAccessLevel = 'edit',CaseId = CId,UserOrGroupId = uid)); //CT4-585 
                    SAShareList.add(new ServiceAppointmentShare(AccessLevel = 'Read',ParentId = SA.Id,UserOrGroupId = uid));//CT4-585 
                    }
                }
            }
            if(SAShareList != null && SAShareList.size() != 0) {
                try { system.debug('***before SAShareList**' + SAShareList);  insert SAShareList;//CHF-1820
                    system.debug('***after SAShareList**' + SAShareList);
                } catch( Exception e) {system.debug('Error::::::' + e.getMessage());}
            }
            //CT4-585 
            if(SRShareList != null && SRShareList.size() != 0) {
                try { system.debug('***before SRShareList**' + SRShareList);  insert SRShareList;
                    system.debug('***after SRShareList**' + SRShareList);
                } catch( Exception e) {system.debug('Error::::::' + e.getMessage());}
            }
            /*if(AssignedResourceSRShareList != null && AssignedResourceSRShareList.size() != 0) {
                try { system.debug('***before AssignedResourceSRShareList**' + AssignedResourceSRShareList);  insert AssignedResourceSRShareList;
                    system.debug('***after AssignedResourceSRShareList**' + AssignedResourceSRShareList);
                } catch( Exception e) {system.debug('Error::::::' + e.getMessage());}
            }*/
            //CT4-585
        }
      //  }
    }
    // Commented below line of code as it is allowing recursive from trigger. 
    // Called FSL_ServiceAppointmentHelper.populateResourceDetails method from ServiceAppointmentHandlerAfterUpdate method
    // and stoped recursive.
    //public static void SAHandlerAfterUpdateAllowsRecursive (Map<Id,ServiceAppointment> newMap, Map<Id,ServiceAppointment> oldMap) {
    //  FSL_ServiceAppointmentHelper.populateResourceDetails(newMap, oldMap);
    // }
    
    @future
    public static void updateExtendScheduledEndField(List<Id> newSAListIds){
        //Fetching Service Appointment list where Ids are in newSAListIds
        List<ServiceAppointment> newSAList = [SELECT Id, Extend_Scheduled_End__c
                                                FROM ServiceAppointment
                                                WHERE Id IN : newSAListIds  ];
        System.debug('*** newSAList *** '+newSAList);
        //new list in order to store updated service appointments
        List<ServiceAppointment> lstObjServiceAppnt = new List<ServiceAppointment>();
        
        for(ServiceAppointment objServiceAppointmnet : newSAList )  {
            if(objServiceAppointmnet.Extend_Scheduled_End__c == true){
                objServiceAppointmnet.Extend_Scheduled_End__c = false;
                lstObjServiceAppnt.add(objServiceAppointmnet);
            }
        } 
        System.debug('*** lstObjServiceAppnt *** '+lstObjServiceAppnt);
        try{
            if(!lstObjServiceAppnt.isEmpty()){
               // update lstObjServiceAppnt;
            }
            
        }catch(Exception ex){
            system.debug('error message : '+ex.getMessage());
        }
        
    }
    
    //CT3-198: Send the Technician and Job information to ANVL
    public static void SendTechnicianInfoToANVL(Map<Id,ServiceAppointment> newMap,Map<Id,ServiceAppointment> oldMap){
        set<Id> serviceorderId = new set<Id>();
        set<Id> saId = new set<Id>();
        map<id, set<id>> mapSOSAid = new map<id, set<id>>();
        
        for(ServiceAppointment SA :newMap.values() ){
            if(oldMap.get(SA.id).status != 'Dispatched' && SA.Status=='Dispatched'){
                if( String.valueof(SA.ParentRecordId).startsWith('0WO')){
                    serviceorderId.add(SA.ParentRecordId);  
                    //serviceorderId.add(SA.Service_Order__c);
                    
                    saId.add(SA.id);
                }
            }
        }
        
         /*if(saId != null && saId.size() > 0){
            List<ServiceAppointment> lstSA = [select Id, status, ParentRecordId, Service_Order__r.ServiceTerritory.ANVL_Enabled__c
                                                , Service_Order__c 
                                                from ServiceAppointment 
                                                WHERE Id IN : saId and Service_Order__r.ServiceTerritory.ANVL_Enabled__c = true];
            system.debug('lstSA :: '+lstSA);
            if(lstSA != null && lstSA.size() > 0){
                for(ServiceAppointment SA : lstSA ){
                    if( String.valueof(SA.ParentRecordId).startsWith('0WO')){
                        if(mapSOSAid.get(SA.ParentRecordId)== null){
                            mapSOSAid.put(SA.ParentRecordId, new set<id>());
                        }
                        mapSOSAid.get(SA.ParentRecordId).add(SA.id);
                    }
                }
                
                system.debug('mapSOSAid :: '+mapSOSAid);
                if(mapSOSAid != null && mapSOSAid.size() > 0)
                    ftSendTechnicianInfoToANVL(mapSOSAid);
            }
        }*/
        
        if(serviceorderId.size()> 0){
            
            List<WorkOrder> objListWO = [SELECT Id, ServiceTerritoryId, ServiceTerritory.ANVL_Enabled__c 
                                        FROM WorkOrder 
                                        WHERE Id IN : serviceorderId and ServiceTerritory.ANVL_Enabled__c = true];
            if(objListWO != null && objListWO.size() >0){
                //call ANVL integration mapping 
                set<id> setWOId = new set<id>();
                List<Id> newSAListIds = new List<Id>(newMap.keySet());
                if(!newSAListIds.isEmpty() && !(System.isFuture())){
                    for(WorkOrder objWO: objListWO){
                        setWOId.add(objWO.id);
                    }
                }
                
                if(setWOId != null && setWOId.size()>0)
                    ftSendTechnicianInfoToANVL(setWOId);
            }
            
        }
        
    }
    
    @Future(callout=true)
    public static void ftSendTechnicianInfoToANVL(set<id> setWOId){
        system.debug('setWOId :: '+setWOId);
        map<Id, List<string>> mapSOIdFed= new map<Id, List<string>>();
        Boolean callANVLInte =false;
        
        list<WorkOrder> lstWO = [select Id, WorkOrderNumber, ServiceTerritory.FSL_Service_Territory_Code__c
                                    , ServiceTerritory.Name, Category1__c, Complaint_Type1__c, AssetId
                                    , Asset.Name, Service_Model__c, Application__c, Application_Code__c, Repair_Location__c
                                    , Account.Name, Account.FSL_ERP_Customer_Code__c, CreatedDate, LastModifiedDate
                                    , Account.IAM_ABO_Code_Formula__c
                                from WorkOrder 
                                where Id in:setWOId];
        
        for(AssignedResource arObj: [select Id, ServiceAppointmentId, ServiceResource.RelatedRecordId, ServiceResource.RelatedRecord.FederationIdentifier
                                         , ServiceAppointment.Service_Order__c
                                         from AssignedResource 
                                     where ServiceAppointment.Service_Order__c In:setWOId and (ServiceAppointment.status = 'Dispatched' OR ServiceAppointment.status = 'In Progress')]){
            if(mapSOIdFed.get(arObj.ServiceAppointment.Service_Order__c)== null){
                mapSOIdFed.put(arObj.ServiceAppointment.Service_Order__c, new List<string>());
            }
            mapSOIdFed.get(arObj.ServiceAppointment.Service_Order__c).add(arObj.ServiceResource.RelatedRecord.FederationIdentifier);
            
            if(arObj.ServiceResource.RelatedRecord.FederationIdentifier != null){
                callANVLInte = true;
            }
            
           system.debug('mapSOIdFed :In For Loop: '+mapSOIdFed+' :: '+arObj);
        }
        
        if(test.isrunningtest()){
            callANVLInte = true;
        }
        system.debug('mapSOIdFed :: '+mapSOIdFed);
        
        if(callANVLInte == true){
            //Prepare request JSON
            FSL_ANVL_ReqWrapper ANVLReq = new FSL_ANVL_ReqWrapper();
        
            FSL_ANVL_ReqWrapper.cls_Header headerDetails = new FSL_ANVL_ReqWrapper.cls_Header();                               
            FSL_ANVL_ReqWrapper.cls_Sender senderDetails = new FSL_ANVL_ReqWrapper.cls_Sender();

            senderDetails.SenderID = 'CSS';
            headerDetails.Sender = senderDetails;

            FSL_ANVL_ReqWrapper.cls_Target targetDetails = new FSL_ANVL_ReqWrapper.cls_Target();            
            targetDetails.TargetID = 'ANVL';           
            headerDetails.Target = targetDetails;
            
            ANVLReq.Header = headerDetails;
            
            FSL_ANVL_ReqWrapper.cls_DataArea DTA = new FSL_ANVL_ReqWrapper.cls_DataArea();
            DTA.transactionId = System.Label.FSL_Source_Environment_Type + '-' + String.valueOf(Datetime.now().format('YYYYMMDDHHMMSS'));
            //prepare workorders i.e assigned technicians list with fed ID's.
                
            List<FSL_ANVL_ReqWrapper.cls_workOrders> workOrders = new List<FSL_ANVL_ReqWrapper.cls_workOrders>();
            for(WorkOrder objWO: lstWO){
                FSL_ANVL_ReqWrapper.cls_workOrders clsWO = new FSL_ANVL_ReqWrapper.cls_workOrders();
                clsWO.id = objWO.WorkOrderNumber;
                if(objWO.Category1__c != null && objWO.Complaint_Type1__c != null)
                    clsWO.description = objWO.Category1__c + ' - ' + objWO.Complaint_Type1__c;
                else if(objWO.Category1__c != null)
                    clsWO.description = objWO.Category1__c;
                else if(objWO.Complaint_Type1__c != null)
                    clsWO.description = objWO.Complaint_Type1__c;
                else
                    clsWO.description = '';
                
                if(objWO.AssetId != null && objWO.Asset.Name != null)
                    clsWO.serial = objWO.Asset.Name;
                else
                    clsWO.serial = '';
                
                if(objWO.Service_Model__c != null)
                    clsWO.model = objWO.Service_Model__c;
                else
                    clsWO.model = '';
                
                if(objWO.Application__c != null)
                    clsWO.category = objWO.Application__c;
                else
                    clsWO.category = '';
                
                if(objWO.Repair_Location__c != null)
                    clsWO.type = objWO.Repair_Location__c;
                else
                    clsWO.type = '';
                
                system.debug('jRec>>>>'+objWO.CreatedDate);
                datetime createdDate= objWO.CreatedDate;
                //string crtdDate = createdDate.format('YYYY-MM-dd')+ 'T'; Commented by RAJESH on 24th of March 2021 as per CHF-1514
                string crtdDate = createdDate.format('yyyy-MM-dd')+ 'T';
                string crtdDate2 = createdDate.format('hh:mm:ssZ')+ 'Z';
                crtdDate2 = crtdDate2.replace('-','.');
                system.debug('currDate>>>>'+crtdDate + crtdDate2);
                clsWO.createdAt = crtdDate + crtdDate2;
                
                system.debug('jRec>>>>'+objWO.LastModifiedDate);
                datetime lastModifiedDate= objWO.LastModifiedDate;
                //string lmdDate = lastModifiedDate.format('YYYY-MM-dd')+ 'T'; Commented by RAJESH on 24th of March 2021 as per CHF-1514
                string lmdDate = lastModifiedDate.format('yyyy-MM-dd')+ 'T';
                string lmdDate2 = lastModifiedDate.format('hh:mm:ssZ')+ 'Z';
                lmdDate2 = lmdDate2.replace('-','.');
                system.debug('currDate>>>>'+lmdDate + lmdDate2);
                clsWO.updatedAt = lmdDate + lmdDate2;
                
                if(objWO.ServiceTerritory.FSL_Service_Territory_Code__c != null){
                    if(objWO.ServiceTerritory.FSL_Service_Territory_Code__c.contains('-')){
                        String[] strST = objWO.ServiceTerritory.FSL_Service_Territory_Code__c.split('-');
                        String stringFinal = strST[0]; 
                        clsWO.location = stringFinal + ' - ' + objWO.ServiceTerritory.Name;
                    }
                    else
                        clsWO.location = objWO.ServiceTerritory.FSL_Service_Territory_Code__c + ' - ' + objWO.ServiceTerritory.Name;
                }
                else 
                    clsWO.location = '';
                
                FSL_ANVL_ReqWrapper.cls_customer custDetails = new FSL_ANVL_ReqWrapper.cls_customer();
                custDetails.name = objWO.Account.Name;
                if(objWO.Account.FSL_ERP_Customer_Code__c != null)
                    custDetails.id = objWO.Account.FSL_ERP_Customer_Code__c;
                else
                    custDetails.id = '';
                
                clsWO.customer = custDetails;
                
                //call assignedUsers method to get list of assigned Users.
                list<string> lstAssignedUsers = new list<string>();
                if(mapSOIdFed != null && mapSOIdFed.size() > 0)
                    lstAssignedUsers = mapSOIdFed.get(objWO.Id);
                
                 if(lstAssignedUsers != null && lstAssignedUsers.size()>0) {
                    clsWO.assigned = lstAssignedUsers;
                 }else{
                     //return null;
                 }
                
                 if(clsWO != null) {
                    workOrders.add(clsWO);
                }
            }   
            
            DTA.workOrders = workOrders;

            ANVLReq.DataArea = DTA;
            
            system.debug('ANVLReq :: '+ANVLReq);
            callANVLService(ANVLReq);
        }
        
    }
    
    //Method to call ANVL service 
    public static void callANVLService(FSL_ANVL_ReqWrapper reqJson){
        string endpointURL='';
        String jsonReqBody = '';
        HttpRequest req1 = new HttpRequest();
        
        system.debug('reqJson>>>>:'+reqJson);
        
        if(reqJson != null){
            jsonReqBody = JSON.serialize(reqJson).replace('null','');
        }
        system.debug('jsonReqBody>>>>:'+jsonReqBody);
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails = CSS_getConnnectionDetails.getConnection('CG_ANVLService');   
        endpointURL = conDetails.End_Point__c;
        
        CG_OP_OAGWrapper accessTokenOPWrap=null;
        if(!Test.isRunningTest()){
            accessTokenOPWrap =  CG_WS_Mule.getAccessToken(conDetails.AuthEnv__c,'CG_ANVLService');     
        }else{
            accessTokenOPWrap=new CG_OP_OAGWrapper();
        }
        
        try{
            String access_token = accessTokenOPWrap.accessToken;                
            req1.setHeader('Authorization','Bearer '+access_token);
            conDetails.Method_Type__c = 'POST';//Added New
            conDetails.Timeout__c = 120000;//Added New
            Integer timeOut = conDetails.Timeout__c.intValue();
            req1.setTimeout(timeOut);
            req1.setHeader('Content-Type','application/json; charset=UTF-8');
            req1.setMethod('POST');
            System.debug('endPointURL Wo Comment '+endPointURL);
            req1.setEndpoint(endPointURL);
            req1.setBody(jsonReqBody); 
            System.debug('Username >>> :: '+conDetails.Username__c);
            if(Test.isRunningTest()){
                conDetails.Username__c=conDetails.Username__c==null? '4546545456454545444545':conDetails.Username__c;
                conDetails.Passcode__c=conDetails.Passcode__c==null? '54654564564654655454564565':conDetails.Passcode__c;
            }
            
            req1.setHeader('client-id',conDetails.Username__c);
            req1.setHeader('client-secret',conDetails.Passcode__c);
            system.debug('req1 :: '+req1);
            //Sending request and mapping the response 
            Http http = new Http();
            //startDt = System.now();
            HttpResponse httpRes = new HttpResponse();
            if(!Test.isRunningTest()) {
                httpres = http.send(req1);
            }
            System.debug('httpres '+httpres);
            System.debug('Status Code >>> :: '+httpres.getStatusCode());
            system.debug('Response Body >>>'+httpres.getbody());
        
            if(httpres.getStatusCode() != 200){
                FSL_ApplicationLogger.insertFSLIntegrationErrorLog(jsonReqBody,String.valueOf(httpres.getbody()),'ANVL','Failure','First','Mule','Guidanz');
            }
        }
        catch(Exception e){
            system.debug('** error '+e.getMessage());
        }
    }

    //If status changed to dispatch then attach form
    public static void createForms(List<ServiceAppointment> newList, Map<Id,ServiceAppointment> oldMap){
        Set<Id> saIdSet = new Set<Id>();
        for(ServiceAppointment sa:newList){
            system.debug(sa.ParentRecordId);
            system.debug(sa.status);
            system.debug(sa.Is_a_Tech_Appointment__c);
            if(String.valueof(sa.ParentRecordId).startsWith('0WO')){
                if(oldMap != null && oldMap.get(sa.Id).status != sa.status && sa.status == 'Dispatched' && sa.Is_a_Tech_Appointment__c){
                    saIdSet.add(sa.Id);
                } else if(oldMap == null && sa.status == 'Dispatched' && sa.Is_a_Tech_Appointment__c){
                    saIdSet.add(sa.Id);
                }
                else if(test.isRunningTest())
                    saIdSet.add(sa.Id);
            }
        }
        if(!saIdSet.isEmpty() && !System.isFuture()){
            FSL_ServiceAppointmentHelper.createForms(saIdSet);
        }
    }
   
}