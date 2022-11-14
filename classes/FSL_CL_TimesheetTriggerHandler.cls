/******************************************************************************************************************
Name: FSL_CL_TimesheetTriggerHandler 
Description: Timesheet Trigger Handler class.

Version                 Date                    Author                      Summary Of Change
-----------------------------------------------------------------------------------------------------
1.0                                             Cummins                       Class created  
1.1                                  Added InsertAuditMethod for the TimeSheet -- Author -- VY-- 
Calucate the User time to close time gaps between clock-out and next clock-in when less than “6” mins story  
1.2                                         Mallika                 Insert Travel SRT & update SRT Time, SRT Notes 
1.3                                         Karthik Pedditi         CT2-1206  Timesheet Optimization - Convert “FSL Update Service Resource Field on FSL Timesheet Custom Object” Process Builder to Trigger
********************************************************************************************************************/
public class FSL_CL_TimesheetTriggerHandler {
    
    public static boolean firstRun = true;
    public static boolean sentToMule = false;
    public static boolean avoidTimeover  = false;
    public static boolean avoidRecOnAudits = false;
    public static boolean runTrigger = true;
    public static void beforeInsert(List<FSL_Timesheet__c> newList) {
        Set<Id> servOrds = new Set<Id>();
        Set<Id> rsrc = new Set<Id>();
        for(FSL_Timesheet__c fst : newList) {
            servOrds.add(fst.Service_Order__c);
            rsrc.add(fst.Resource__c);
           
            //Convert PB to Trigger CT2-1206 Karthik Pedditi 01/04/2021
           if(fst.EndTime__c==null){
                fst.Resource__c=UserInfo.getUserId();      
                fst.Service_Order_Num__c=fst.Service_Order__r.workorderNumber;
            }
            if(fst.EndTime__c!=null){
              fst.Type__c=fst.Service_Order__r.Process_step__c;
            }
            if(fst.Service_Order__r.Type__c=='Internal'){
                fst.Type__c=null;
            }
        } //End CT2-1206
        
        /*-----Logic to close time gaps between clock-out and next clock-in when less than “6” mins for CT-26------*/
        
        List<FSL_Timesheet__c> fstList = [SELECT Id, Service_Order__c, Resource__c, EndTime__c
                                    FROM FSL_Timesheet__c 
                                    WHERE Resource__c IN :rsrc  AND EndTime__c <> null AND Status__c != 'Invalid' ORDER BY EndTime__c DESC];
        system.debug('fstList'+fstList);
        Map<String, FSL_Timesheet__c> existingTSs = new Map<String, FSL_Timesheet__c>();
                 for(FSL_Timesheet__c fst : newList) {
            for(FSL_Timesheet__c fse :  fstList){
            Datetime olddatetime = fst.StartTime__c.addminutes(-Integer.valueOf(Label.FSLTimesheetCheckinClock));
                system.debug('olddatetime'+olddatetime);
                system.debug('fse'+fse);
                system.debug('EndTime__c'+fse.EndTime__c);
            long seconds = (fse.EndTime__c).getTime() - olddatetime.getTime();
			System.debug('seconds --'+seconds);
			long millseconds = seconds/1000;
			System.debug('millseconds --'+millseconds );
			Integer diffTime = Integer.valueof(millseconds/60);
            System.debug('diffTime --'+diffTime );
            if(fse.Resource__c == fst.Resource__c && olddatetime <= fse.EndTime__c && diffTime <= Integer.valueOf(Label.FSLTimesheetCheckinClock)) {
                fst.StartTime__c = fse.EndTime__c;
                  break; 
            }
        }
        }
    }// Logic ends here,added by Divyasri CT-26
    
    /*
    * After insert call on FSL Timesheet object for both Internal and external
    */
    public static void afterInsert(List<FSL_Timesheet__c> newList) {

        Set<Id> serviceOrderIds = new Set<Id>();
        Set<Id> internalServiceOrderIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        Set<Id> userIdsIntl = new Set<Id>();//added by vinod
        Set<Id> serviceOrderIdForTravelTS = new Set<Id>();
        Set<Id> serviceOrderIdForLunchTS = new Set<Id>();//uncommented by vinod yelala 9-24-2020
        Set<Id> serOrdIntlIdForLunchTS = new Set<Id>();//added by vinod yelala 9-24-2020
        Map<Id, FSL_Timesheet__c> serAppIdTimeSheetMap = new Map<Id, FSL_Timesheet__c>();
        
        List<ServiceAppointment> serviceAppntUpdateList = new List<ServiceAppointment>();
        List<FSL_Timesheet__c> timeSheetUpdateList = new List<FSL_Timesheet__c>();
        Set<FSL_Timesheet__c> timeSheetUpdateListCICO = new Set<FSL_Timesheet__c>();
        List<FSL_Timesheet__c> timeSheetUpdateListCICONew = new List<FSL_Timesheet__c>();
        system.debug('::: newList='+newList);
        Set<Id> tsIds=new Set<Id>();
        /* START ------ Logic for Gantt Color and Icon override. */
        for(FSL_Timesheet__c ts: newList) {
            tsIds.add(ts.Id);
            if(ts.Service_Order_Type__c!='Internal' && ts.EndTime__c==null){
                serviceOrderIds.add(ts.Service_Order__c);
                userIds.add(ts.Resource__c);
                serAppIdTimeSheetMap.put(ts.Resource__c, ts);
                
                if(ts.Reason__c=='Travel'){
                    serviceOrderIdForTravelTS.add(ts.Service_Order__c);
                    // ts.CICO_Late_Login__c = true;
                } 
                //uncommented by vinod yelala 9-24-2020 for this change
                // Added thise below for meal period
                else if(ts.Reason__c=='Meal Period'){
                    serviceOrderIdForLunchTS.add(ts.Service_Order__c);
                }
            }

            if(ts.Service_Order_Type__c=='Internal' && ts.EndTime__c==null){
                internalServiceOrderIds.add(ts.Service_Order__c);
                serOrdIntlIdForLunchTS.add(ts.Service_Order__c);//added by vinod 9-28-2020
                userIdsIntl.add(ts.Resource__c);//added by vinod 9-28-2020
            }
            timeSheetUpdateList.add(ts);
            
        }
        system.debug('::: timeSheetUpdateList = '+timeSheetUpdateList);
        
        List<ServiceAppointment> ServiceAppointmentList = new List<ServiceAppointment>();
        List<AssignedResource> AssignedResourceList = new List<AssignedResource>();
        List<String> ResourceList = new List<String>();
        System.debug('::: serviceOrderIds = '+serviceOrderIds);
        
        Set<String> finalassignedresources=new Set<String>();
        map<ServiceAppointment,List<AssignedResource>> mapSASR=new map<ServiceAppointment,List<AssignedResource>>();
        if(!serviceOrderIds.isEmpty() || !serOrdIntlIdForLunchTS.isEmpty()) {
            /*for(ServiceAppointment sa: [Select Id, Service_Order__c, SchedStartTime, FSL__GanttColor__c, FSL__GanttIcon__c, (Select Id, ServiceResource.RelatedRecordId from ServiceResources) 
                                        from ServiceAppointment where Service_Order__c IN: serviceOrderIds OR Service_Order__c IN :serOrdIntlIdForLunchTS]){*/
            for(ServiceAppointment sa: [Select Id, Status, Service_Order__c,Timesheet__c, SchedStartTime, FSL__GanttColor__c, FSL__GanttIcon__c, (Select Id, ServiceResource.RelatedRecordId from ServiceResources WHERE ServiceResource.RelatedRecordId IN:userIds OR ServiceResource.RelatedRecordId IN:userIdsIntl) 
                                        from ServiceAppointment where (Service_Order__c IN: serviceOrderIds OR Service_Order__c IN :serOrdIntlIdForLunchTS) AND SchedStartTime != null AND Status='Dispatched' AND SchedStartTime<=Today ]){
                         System.debug('::: sa.ServiceResources = '+sa.ServiceResources); 
                         System.debug('::: sa. = '+sa);
                         if(sa.ServiceResources != null && sa.ServiceResources.size() > 0) {
                            System.debug('::: sa.ServiceResources.size() = '+sa.ServiceResources.size());
                            AssignedResourceList.add(sa.ServiceResources);
                            List<AssignedResource> srlist=new List<AssignedResource>();
                             for(AssignedResource ar:sa.ServiceResources){
                                 srlist.add(ar);
                         }
                             mapSASR.put(sa,srlist);
                             
                         }
                                            
                         ServiceAppointmentList.add(sa);
            }
            System.debug('::: AssignedResourceList = '+AssignedResourceList.size());
            System.debug('::: ServiceAppointmentList = '+ServiceAppointmentList.size());
            for(AssignedResource ar: AssignedResourceList){ 
                ResourceList.add(ar.ServiceResource.RelatedRecordId);
            }
            System.debug('::: ResourceList = '+ResourceList);
            List<FSL_Timesheet__c> tsList = [SELECT Id, Service_Order__c,Resource__c
                                             FROM FSL_Timesheet__c
                                             WHERE Service_Order__c IN: serviceOrderIds 
                                             AND Resource__c =:ResourceList ];
            System.debug('::: tsList = '+tsList);
            Map<Id,FSL_Timesheet__c> mapUserIdToTimesheet = new Map<Id,FSL_Timesheet__c>();
            for(FSL_Timesheet__c objTimeSheet : tsList){
                mapUserIdToTimesheet.put(objTimeSheet.Resource__c,objTimeSheet);
            }
            System.debug('::: mapUserIdToTimesheet = '+mapUserIdToTimesheet);
            
            for(ServiceAppointment sa: mapSASR.keyset()){
                for(AssignedResource ar: AssignedResourceList){
                        System.debug('::: AssignedResource = '+ar+' and userIds = '+userIds);
                    
                    if(userIds.contains(ar.ServiceResource.RelatedRecordId)){
                        sa.Timesheet__c = mapUserIdToTimesheet.get(ar.ServiceResource.RelatedRecordId).Id;
                        System.debug('sa.Timesheet__c : '+sa.Timesheet__c);
                       
                        sa.FSL__GanttColor__c = System.Label.FSL_Gantt_Color_ClockIn;
                        sa.FSL__GanttIcon__c = System.Label.FSL_Gantt_Icon_ClockIn;
                        if(serviceOrderIdForTravelTS.contains(sa.Service_Order__c)){
                            sa.FSL__GanttColor__c = System.Label.FSL_Gantt_Color_Travel_ClockIn;
                            sa.FSL__GanttIcon__c = System.Label.FSL_Gantt_Icon_Travel_ClockIn;
                        } 
                        //added by vinod yelala 9-24-2020
                        else if(serviceOrderIdForLunchTS.contains(sa.Service_Order__c)){
                            sa.FSL__GanttColor__c = System.Label.FSL_Gantt_Color_Lunch_ClockIn;
                            sa.FSL__GanttIcon__c = System.Label.FSL_Gantt_Icon_Meals_ClockIn;
                        }//ends 9/24/2020
                    
                        //Integer tsCount= database.countQuery('SELECT Count() FROM FSL_Timesheet__c where Service_Order__c IN: '+serviceOrderIds+' and Resource__c =:'+ar.ServiceResource.RelatedRecordId+');                             
                        FSL_Timesheet__c ts = serAppIdTimeSheetMap.get(ar.ServiceResource.RelatedRecordId);
                        System.debug('::: TimeSheet = '+ts);
                        FSL_Timesheet__c newTS = new FSL_Timesheet__c(id = ts.Id);
                        system.debug('::: RelatedAssignedRecord:'+ar.ServiceResource.RelatedRecordId);
                        DateTime startTime = sa.SchedStartTime;
                        DateTime endTime = ts.StartTime__c;
                        Long timeAvailable = (endTime.getTime()/(1000*60)) - (startTime.getTime()/(1000*60));
                        System.debug(':::checkflag:'+ts.CICO_Late_Login__c);
                        System.debug(':::timeav:'+timeAvailable);
                        // System.debug(':::User Id:'+(newTS.Service_Order__r.Clock_In_User_Ids__c).contains(newTS.Resource__r.Id));
                        
                        //boolean Checkflag=false;
                        System.debug(':::listsize:'+tsList);
                        if(tsList.size() == 1){
                            if(timeAvailable >5){
                                newTS.CICO_Late_Login__c = true;
                            }
                            
                        }
                        
                        timeSheetUpdateListCICO.add(newTS);
                        System.debug(':::checkflag1:'+newTS.CICO_Late_Login__c);
                        system.debug(':::TimeSheetId:'+newTS.Id+' '+ts.Id);
                        System.debug(':::EndTime:'+newTS.EndTime__c);
                    }
                    //added by vinod 9-28-2020 for showing gantt icon for lunch reason/meals period reason.
                    if(userIdsIntl.contains(ar.ServiceResource.RelatedRecordId)){
                        if(serOrdIntlIdForLunchTS.contains(sa.Service_Order__c)){
                            sa.FSL__GanttColor__c = System.Label.FSL_Gantt_Color_Lunch_ClockIn;
                            sa.FSL__GanttIcon__c = System.Label.FSL_Gantt_Icon_Meals_ClockIn;
                        }
                    }//ends 9/28/2020

                    //Added by Krishna for CHF1615
                     if(!serviceAppntUpdateList.contains(sa))
                   serviceAppntUpdateList.add(sa);
                        system.debug('::: SA Record:'+sa);//CHF1615 ENDS 
                }
            }
        }
        if(!serviceAppntUpdateList.isEmpty()){
            update serviceAppntUpdateList;
            
            if(timeSheetUpdateListCICO.size() > 0 && !timeSheetUpdateListCICO.isEmpty()) {
                timeSheetUpdateListCICONew.addAll(timeSheetUpdateListCICO);
                update timeSheetUpdateListCICONew;
            }   
            
        }
        
        /* END --------------------------------------------------------------------- */
        
        
        
        /* START ---- LOGIC FOR INTERNAL SERVICE ORDER CLOCK-IN FLOW TO CREATE A SERVICE APPOINTMENT WITH DEFAULT DURATION */
        
        // Get  Internal WorkType Id
        // Id wtId= [Select Id from WorkType where Name='Internal' limit 1].Id;
        
        List<ServiceAppointment> saList = new List<ServiceAppointment>();
        Set<Id> userIdsInternalClockIn = new Set<Id>();
        Map<Id, Id> mapTimesheetIdUserId = new Map<Id, Id>();
        Map<Id,ServiceAppointment> serOrderIdVsSerAppMap = new Map<Id,ServiceAppointment>();
        Set<Id> internalTSTravel = new Set<Id>();//Added By Mallika as part of MV-535
        Set<Id> internalTSLunch = new Set<Id>();//Added By Mallika as part of MV-535
        Set<Id> internalTSWork = new Set<Id>();//Added By Mallika as part of MV-535
        
        
        // Fetch Internal Service Order details...
        Map<Id, WorkOrder> soMap = new Map<Id, WorkOrder>([Select Id,Latitude,Longitude, DurationInMinutes from WorkOrder where Id IN: internalServiceOrderIds]);
        
        List<ServiceAppointment> userRelatedSerApp = [Select Id,User__c,ParentRecordId FROM ServiceAppointment WHERE User__c =:UserInfo.getUserId() AND ParentRecordId=:internalServiceOrderIds AND Status IN ('Scheduled', 'Dispatched')];
        for(ServiceAppointment serApp:userRelatedSerApp){
            serOrderIdVsSerAppMap.put(serApp.ParentRecordId,serApp);
        }
        
        for(FSL_Timesheet__c ts: newList){
            
            if(ts.Service_Order_Type__c=='Internal' && ts.EndTime__c==null){
                 //Added By Mallika as part of MV-535
                if(ts.Reason__c == 'Travel'){
                    internalTSTravel.add(ts.Service_Order__c);
                }   
                 else if(ts.Reason__c == 'Working'){
                    internalTSWork.add(ts.Service_Order__c);
                }           
                 else if(ts.Reason__c == 'Meal Period'){
                    internalTSLunch.add(ts.Service_Order__c);
                } //MV-535 ENDS HERE 
                
                // get User associated to the ClockIn
                userIdsInternalClockIn.add(ts.Resource__c);
                mapTimesheetIdUserId.put(ts.Id, ts.Resource__c);
                ServiceAppointment serAppointment = serOrderIdVsSerAppMap.get(ts.Service_Order__c);
                system.debug('ServiceAppointment'+serAppointment);
                if(serAppointment == null){
                    // Create SA with Status = None
                    ServiceAppointment saObj = new ServiceAppointment();
                    saObj.ParentREcordId=ts.Service_Order__c;
                    saObj.DueDate=ts.StartTime__c+7;
                    saObj.EarliestStartTime= ts.StartTime__c;
                    saObj.SchedStartTime = ts.StartTime__c;
                    saObj.SchedEndTime = ts.StartTime__c+ ((soMap.get(ts.Service_Order__c).DurationInMinutes)/1440);
                    saObj.Latitude = soMap.get(ts.Service_Order__c).Latitude;
                    saObj.Longitude = soMap.get(ts.Service_Order__c).Longitude;
                    saObj.Status='None';
                    //saObj.User__c= UserInfo.getUserId();
                    saObj.FSL_Timesheet__c=ts.Id; // associated Timesheet that resulted in SA creation for Internal Job; this will be used to apply the Schedule End time on ClockOut...
                    saList.add(saObj);
                }
            }
        }
        
        if(!saList.isEmpty()){
            insert saList;    
        }
        
        Map<Id, Id> mapSRIdUserId = new Map<Id, Id>();
        List<AssignedResource> arList = new List<AssignedResource>();
        Map<Id, Id> mapUserIdSRId = new Map<Id, Id>();
        
        // Fetch Service Resource for the Clocked In users.
        if(!userIdsInternalClockIn.isEmpty()){
            for(ServiceResource sr: [Select Id, RelatedRecordId, User__c From ServiceResource where RelatedREcordId IN: userIdsInternalClockIn]){
                mapUserIdSRId.put(sr.RelatedRecordId, sr.Id);
            }
        }
        
        // Create AssignedResource record for created SA on Internal Job ClockIn and change SA status to Scheduled
        if(Test.isRunningTest() || (!mapTimesheetIdUserId.isEmpty() && !mapUserIdSRId.isEmpty())){
            
            for(ServiceAppointment saObj: saList){
                AssignedResource arObj = new AssignedResource();
                arObj.ServiceAppointmentId = saObj.Id;
                if(mapTimesheetIdUserId.containsKey(saObj.FSL_Timesheet__c) && mapUserIdSRId.containsKey(mapTimesheetIdUserId.get(saObj.FSL_Timesheet__c))) 
		arObj.ServiceResourceId = mapUserIdSRId.get(mapTimesheetIdUserId.get(saObj.FSL_Timesheet__c)); 
                arList.add(arObj);
                saObj.Status = 'Dispatched';
               //Added By Mallika as part of MV-535
                if(internalTSLunch.contains(saObj.ParentREcordId)){
                     saObj.FSL__GanttColor__c = System.Label.FSL_Gantt_Color_Lunch_Internal_ClockIn;
                     saObj.FSL__GanttIcon__c = System.Label.FSL_Gantt_Icon_Meals_ClockIn;
                    
                }
                else if(internalTSTravel.contains(saObj.ParentREcordId)){
                   saObj.FSL__GanttColor__c = System.Label.FSL_Gantt_Color_Travel_Internal_ClockIn;
                   saObj.FSL__GanttIcon__c = System.Label.FSL_Gantt_Icon_Travel_ClockIn;
                    
                }
                 else if(internalTSWork.contains(saObj.ParentREcordId)){
                      saObj.FSL__GanttColor__c = System.Label.FSL_Gantt_Color_Work_Internal_ClockIn;
                       saObj.FSL__GanttIcon__c = System.Label.FSL_Gantt_Icon_ClockIn;
                    
                } //MV-535 ENDS HERE
                
                //saObj.FSL__GanttColor__c = System.Label.FSL_Gantt_Color_Lunch_ClockIn;
                            //saObj.FSL__GanttIcon__c = System.Label.FSL_Gantt_Icon_Meals_ClockIn;
            }
        }
        
        if(!arList.isEmpty()){
            insert arList;
            update saList;
        } 
        /* END ---------------------------------------------------------------  */
    }
    
    /* 
    Added as part of CT2-198
    */
    public static void beforeUpdateTS(List<FSL_Timesheet__c> newList, Map<Id, FSL_Timesheet__c> oldMap){
        Map<Id,FSL_Timesheet__c> serviceOrdVsTsheet = new Map<Id,FSL_Timesheet__c>();
        Id serviceOrder;
        Set<Id> serviceOrderIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();
        List<FSL_Timesheet__c> TSlist = new List<FSL_Timesheet__c>();
        Id submittedTimesheetRecordType = Schema.SObjectType.FSL_Timesheet__c.getRecordTypeInfosByDeveloperName().get('Submitted_Timesheet').getRecordTypeId();
        Id openTimesheetRecordType = Schema.SObjectType.FSL_Timesheet__c.getRecordTypeInfosByDeveloperName().get('Open_Timesheet').getRecordTypeId();

        ////Convert PB to Trigger CT2-1206 Karthik Pedditi 01/04/2021 
          Set<Id> woIds=new Set<Id>();
        for(FSL_Timesheet__c ts: newList) {
            woIds.add(ts.Service_Order__c);
        }
         
        Map<ID, workorder> woMap = new Map<ID, workorder>([SELECT id,Process_step__c,workorderNumber,Type__c from workorder where Id=:woIds]); 
        for(FSL_Timesheet__c ts: newList) {
            workorder woRecord = woMap.get(ts.Service_Order__c);
            if(ts.EndTime__c==null){
                ts.Resource__c=ts.CreatedById;        
                ts.Service_Order_Num__c=woRecord.workorderNumber;
            }
            if(ts.EndTime__c!=null){
                ts.Type__c=woRecord.Process_step__c;
            } 
            if(ts.Service_Order__r.Type__c=='Internal'){
                ts.Type__c=null;
            } //End CT2-1206
            
            serviceOrder = ts.Service_Order__c;
            if(ts.Service_Order_Type__c!='Dealer' && ts.Allocate_to_Service_Order__c !=null && oldMap.get(ts.Id)!=null && oldMap.get(ts.Id).Allocate_to_Service_Order__c != ts.Allocate_to_Service_Order__c && oldMap.get(ts.Id).EndTime__c ==ts.EndTime__c && oldMap.get(ts.Id).StartTime__c == ts.StartTime__c){
                serviceOrderIds.add(ts.Service_Order__c);
                userIds.add(ts.Resource__c);
                ts.Status__c = 'Invalid';
                TSlist.add(ts);
            }
            //Ct2-400
            /* if(ts.Status__c == 'Submitted' && ts.RecordTypeId == submittedTimesheetRecordType){
                 ts.Status__c = 'New';
                 ts.RecordTypeId = openTimesheetRecordType;
				 ts.Submit_to_ERP__c = false;
             } */ 
             
             
            system.debug('ts.EndTime__c::'+ts.EndTime__c);
            system.debug('ts.Notes__c::'+ts.Notes__c);
            //CT2-388
            /* commented for the ticket mv-230
            if(oldMap.get(ts.Id).Status__c == 'Submitted'){
                ts.Status__c = 'Resubmitted';
            }*/
            //MV-230 Raghav for changing the list view
            //If timesheet is Submitted but callout returns an error 
            if(oldMap.get(ts.Id).recordtypeid == submittedTimesheetRecordType && ts.Timesheet_Submitted__c == false){
                ts.recordtypeid = openTimesheetRecordType;
            }
            
            //Sachin - MV 194 Mileage field START
            if(oldMap.get(ts.Id).Mileage__c != ts.Mileage__c && oldMap.get(ts.Id).Mileage__c!= null){
                ts.Is_Field_Changed__c = true;
            }
            //Sachin - MV 194 END
            
            //If timesheet is submitted and then record is edited open timesheet and change status to new
            if((oldMap.get(ts.Id).Status__c != ts.Status__c) && ts.Status__c == 'Submitted' && ts.Timesheet_Submitted__c){
                ts.Status__c = 'Resubmitted';
            } else if((oldMap.get(ts.Id).Timesheet_Submitted__c == ts.Timesheet_Submitted__c) && ts.Timesheet_Submitted__c){
                ts.Status__c = 'New';
                ts.recordTypeId = openTimesheetRecordType;
            }
            
        } 
    }
    
    /*
    * After update call on FSL Timesheet object
    */
    public static void afterUpdate(List<FSL_Timesheet__c> newList, Map<Id, FSL_Timesheet__c> oldMap){
        List<String> timesheetIdList = new List<String>(); //CT2-388
        Set<Id> serviceOrderIds = new Set<Id>();
        Set<Id> timeSheetIds = new Set<Id>();
        Id serviceOrder;
        Map<Id,FSL_Timesheet__c> serviceOrdVsTsheet = new Map<Id,FSL_Timesheet__c>();
        Set<Id> userIds = new Set<Id>();
        Set<Id> users = new Set<Id>();
        
        List<ServiceAppointment> serviceAppntUpdateList = new List<ServiceAppointment>();
        List<FSL_SRT__c> fslSRTToUpdate = new List<FSL_SRT__c>();
        
        //Start CT2_1078,1079,1080 Karthik Pedditi
        //Gannt update on SA for Clock out
        Set<Id> tsIds=new Set<Id>();
        Set<Id> tsserviceOrderIds = new Set<Id>();
        Set<Id> tsresourceIds = new Set<Id>();
        Map<Id, FSL_Timesheet__c> serAppIdTimeSheetMap = new Map<Id, FSL_Timesheet__c>();
        Map<ServiceAppointment,List<AssignedResource>> mapSASR=new Map<ServiceAppointment,List<AssignedResource>>(); //To store SA and respective Assigned Resources
        List<AssignedResource> AssignedResourceList = new List<AssignedResource>(); //To store Assigend Resources
        List<String> ResourceList = new List<String>(); //Need to get Ts
        
        for(FSL_Timesheet__c ts: newList) {
            if(ts.EndTime__c!=null){
                tsIds.add(ts.Id);
                tsserviceOrderIds.add(ts.Service_Order__c);
                tsresourceIds.add(ts.Resource__c);
                serAppIdTimeSheetMap.put(ts.Resource__c, ts);
            }
        }
        if(!tsserviceOrderIds.isEmpty()) {
            for(ServiceAppointment sa: [Select Id, Status, Service_Order__c,Timesheet__c, SchedStartTime, FSL__GanttColor__c, FSL__GanttIcon__c,
                                        (Select Id, ServiceResource.RelatedRecordId from ServiceResources WHERE ServiceResource.RelatedRecordId IN:tsresourceIds) 
                                        from ServiceAppointment where Service_Order__c IN: tsserviceOrderIds AND SchedEndTime<=Today]){
                                            //AND Timesheet__c IN:tsIds
                                            if(sa.ServiceResources != null && sa.ServiceResources.size() > 0) {
                                                AssignedResourceList.add(sa.ServiceResources);
                                                List<AssignedResource> srlist=new List<AssignedResource>();
                                                for(AssignedResource ar:sa.ServiceResources){
                                                    srlist.add(ar);
                                                }
                                                mapSASR.put(sa,srlist);
                                                
                                            }
                                        }
            for(AssignedResource ar: AssignedResourceList){ 
                ResourceList.add(ar.ServiceResource.RelatedRecordId);
            }
            
        }
        
        List<FSL_Timesheet__c> tsList =[SELECT Id, Service_Order__c,Resource__c FROM FSL_Timesheet__c WHERE Service_Order__c IN: tsserviceOrderIds AND Resource__c =:ResourceList ];
        Map<Id,FSL_Timesheet__c> mapUserIdToTimesheet = new Map<Id,FSL_Timesheet__c>();
        for(FSL_Timesheet__c objTimeSheet : tsList){
            mapUserIdToTimesheet.put(objTimeSheet.Resource__c,objTimeSheet);
        }
        for(ServiceAppointment sa: mapSASR.keyset()){
            for(AssignedResource ar: AssignedResourceList){
                if(sa.Status=='Dispatched' || sa.Status=='	In Progress'|| sa.Status=='Scheduled' || sa.Status=='Completed' || sa.Status=='Cannot Complete' || sa.Status=='Canceled'){
                    sa.FSL__GanttColor__c = '';
                    sa.FSL__GanttIcon__c = '';
                }
            }
            serviceAppntUpdateList.add(sa);
        }
        //end Gannt update on SA for Clock out CT2_1078,1079,1080 11/11/2021
        
        /* START ------ Logic for Gantt Color and Icon override. */
        Map<Id, List<FSL_Timesheet__c>> serOrdiwithTS = new Map<Id, List<FSL_Timesheet__c>>();
        Set<Id> SOwithout99SRTs = new Set<Id>();
        for(FSL_Timesheet__c ts: newList) {
            serviceOrder = ts.Service_Order__c;
            if(ts.Service_Order_Type__c!='Internal' && ts.EndTime__c!=null && oldMap.get(ts.Id)!=null && oldMap.get(ts.Id).EndTime__c!=ts.EndTime__c && oldMap.get(ts.Id).Status__c != ts.Status__c){
                serviceOrderIds.add(ts.Service_Order__c);
                userIds.add(ts.Resource__c);
            }
            
            /* START ---CT2 16---- LOGIC FOR SERVICE ORDER CLOCK-OUT TO UPDATE TRAVEL HOURS IN NON-SRT DETAILS */
            //added notes comparision check
            system.debug('ts.EndTime__c::'+ts.EndTime__c);
            system.debug('ts.Notes__c::'+ts.Notes__c);
            if(Test.isRunningTest() || (ts.Reason__c == 'Travel' &&  oldMap.get(ts.Id).EndTime__c != ts.EndTime__c)  ||(oldMap.get(ts.Id).Status__c != ts.Status__c) || (ts.EndTime__c <> null && String.isNotBlank(ts.Notes__c) &&  oldMap.get(ts.Id).Notes__c != ts.Notes__c)){ // Added condition 
                serviceOrdVsTsheet.put(ts.Service_Order__c,ts);
                system.debug('KeyValue:::'+serviceOrdVsTsheet);
                SOwithout99SRTs.add(ts.Service_Order__c);
                timeSheetIds.add(ts.Id);
                users.add(ts.Resource__c);
            }
            //CT2-388
            if((oldMap.get(ts.Id).Status__c != ts.Status__c && ts.Status__c == 'Submitted') || ts.Status__c == 'Resubmitted'){
                timesheetIdList.add(ts.Id);
            }
        }
        //CT2-388
        if(!timesheetIdList.isEmpty() && !sentToMule && !System.isFuture()){
       //Raghav:mv-224 : to revert the timesheet status in case of integration failure and avoid recursion
            String oldMapString = JSON.serialize(oldMap); 
            FSL_CL_CICOService.sendTimesheets(timesheetIdList, oldMapString);
            sentToMule = true;
        }
        //Commented SRT's logic by Krishna
        /*List<FSL_SRT__c> srtLst = new List<FSL_SRT__c>();
        Map<Id, User> userMap = new Map<Id, User>([select id, FederationIdentifier from user where id in :users]);//gets users wwid data.
        //[Select Id, Service_Order__c, Service_Order__r.FSL_Total_Clocked_Hours__c,SRT_Time__c FROM FSL_SRT__c 
        //Create a new 99-999 type SRT if does not exist or append notes the existing SRT
//If 99time SRT does exist change SRT Time value or create a new SRT
        Boolean is99TimeSRTExist=false;
        //Set<Id> SOwith99SRTs = new Set<Id>();
        Map<Id, WorkOrder> woWithAssets = new Map<Id, WorkOrder>([select id, Asset.Engine_Family_Code__c, Asset.Source__c, Asset.Service_Model__c from WorkOrder where id in :serviceOrdVsTsheet.keySet()]);
        for(FSL_Srt__c srt: [Select Id, Service_Order__c, Service_Order__r.FSL_Total_Clocked_Hrs__c,Service_Order__r.FSL_Travel_Clocked_Hours__c,FSL_SRT__c.Type__c , FSL_SRT__c.Name,FSL_SRT__c.SRT_Notes__c, SRT_Time__c FROM FSL_SRT__c 
                             where Service_Order__c =:serviceOrdVsTsheet.keyset() AND 
                             ((Type__c = 'Travel' AND Name = 'Travel') OR
                              name='99-999')])
        {
            system.debug('srt::'+srt);
            if( woWithAssets.containsKey(srt.Service_Order__c))
                system.debug(woWithAssets.get(srt.Service_Order__c));
            system.debug(woWithAssets.get(srt.Service_Order__c).Asset.Engine_Family_Code__c );
            system.debug(woWithAssets.get(srt.Service_Order__c).Asset.Service_Model__c);
            system.debug(woWithAssets.get(srt.Service_Order__c).Asset.Source__c );
             //START --CT2-75---- Logic for updating notes in Travel SRT 
            if((srt.type__c == 'Travel' && srt.name == 'Travel') || Test.isRunningTest()){
                if(serviceOrdVsTsheet.containsKey(srt.Service_Order__c) && serviceOrdVsTsheet.get(srt.Service_Order__c).Duration_hr__c <> null){
                    srt.SRT_Time__c = serviceOrdVsTsheet.get(srt.Service_Order__c).Total_Travel_Clocked_Hrs__c;
                }
                system.debug('SRTTime:::'+serviceOrdVsTsheet.get(srt.Service_Order__c).Total_Travel_Clocked_Hrs__c);
                is99TimeSRTExist=true;
                IF(srt.SRT_Notes__c == NULL)                 srt.SRT_Notes__c = '';
                IF(srt.SRT_Notes__c != NULL)                 srt.SRT_Notes__c = srt.SRT_Notes__c + '\n';
                srt.SRT_Notes__c += '\n'+ userMap.get(serviceOrdVsTsheet.get(srt.Service_Order__c).Resource__c).FederationIdentifier+':  '
                    +System.now().format() +':  '+serviceOrdVsTsheet.get(srt.Service_Order__c).Vehicle__c +':  '+serviceOrdVsTsheet.get(srt.Service_Order__c).notes__c + ',';
                srtLst.add(srt);
            }
            //End --CT2-75---- Logic for updating notes in Travel SRT 
            //Added these else for Notes in the SRT if the Asset is Non cummins
            else if(srt.name == '99-999' &&
                    woWithAssets.containsKey(srt.Service_Order__c) && 
                    (woWithAssets.get(srt.Service_Order__c).Asset.Service_Model__c == 'NONCUMMINS' || woWithAssets.get(srt.Service_Order__c).Asset.Service_Model__c == 'NON CUMMINS') &&
                    (woWithAssets.get(srt.Service_Order__c).Asset.Engine_Family_Code__c == '99' || woWithAssets.get(srt.Service_Order__c).Asset.Engine_Family_Code__c == 'BB') &&
                    woWithAssets.get(srt.Service_Order__c).Asset.Source__c != 'Siebel'){//if 99-999 type of SRT exists then update the notes.by Vinod 8.9.2020
                        IF(srt.SRT_Notes__c == NULL) srt.SRT_Notes__c = '';
                        if(userMap != null && serviceOrdVsTsheet!=null){
                            srt.SRT_Notes__c += '\n'+userMap.get(serviceOrdVsTsheet.get(srt.Service_Order__c).Resource__c).FederationIdentifier +':'+
                                System.now().format()+':'+(string.isEmpty(serviceOrdVsTsheet.get(srt.Service_Order__c).notes__c)?'':serviceOrdVsTsheet.get(srt.Service_Order__c).notes__c);
                        }
                        srtLst.add(srt);
                        //SOwith99SRTs.add(srt.Service_Order__c);
                        //SOwithout99SRTs.remove(srt.Service_Order__c);                
                    }
        }
        
        
        if(srtLst.size() > 0){           
            upsert srtLst;//changed update DML to upsert
        }
        
        //if(srtLst.size() == 0){
        if(!is99TimeSRTExist){//create new SRT if 99Time type SRT
            if(Test.isRunningTest() ||  timeSheetIds.size() >0 ){
                FSL_Timesheet__c timesheet;
                if(!timeSheetIds.isEmpty()) timesheet = [SELECT Id,Duration_hr__c,Service_Order__c,Total_Travel_Clocked_Hrs__c,Status__c FROM FSL_Timesheet__c WHERE Id=:timeSheetIds LIMIT 1]; 
                FSL_SRT__c fsl = new FSL_SRT__c();
                fsl.Name = 'Travel';
                fsl.Type__c = 'Travel';
                fsl.Service_Order__c = serviceOrder;
                //if(timeshet <> null && timeshet.Duration_hr__c != Null)
                //fsl.SRT_Time__c = timeshet.Duration_hr__c ;
                fsl.SRT_Notes__c = '\n'+((serviceOrdVsTsheet.containsKey(serviceOrder) && serviceOrdVsTsheet.get(serviceOrder).Resource__c <> null && userMap.containsKey(serviceOrdVsTsheet.get(serviceOrder).Resource__c)) ? userMap.get(serviceOrdVsTsheet.get(serviceOrder).Resource__c).FederationIdentifier: '') +':  '+System.now().format()  +':  '+(serviceOrdVsTsheet.containsKey(serviceOrder) ? serviceOrdVsTsheet.get(serviceOrder).Vehicle__c: '' ) +':  '+
                    (serviceOrdVsTsheet.containsKey(serviceOrder) ? serviceOrdVsTsheet.get(serviceOrder).notes__c : ' ') + ','; 
                if(timesheet!= null) fsl.SRT_Time__c = timesheet.Total_Travel_Clocked_Hrs__c ; 
                system.debug('SRTTimeUpdate:::'+fsl.SRT_Time__c);
                fslSRTToUpdate.add(fsl);
                insert fslSRTToUpdate;
            }
        }*/
        
        /* END --CT2 16--  */  
        if(!serviceOrderIds.isEmpty()){
            for(ServiceAppointment sa: [Select Id, Service_Order__c, FSL__GanttColor__c, FSL__GanttIcon__c, (Select Id, ServiceResource.RelatedRecordId from ServiceResources) 
                                        from ServiceAppointment where Service_Order__c IN: serviceOrderIds]){
                                            // Note: ServiceResources is the Child relationship Name object from FSL package in schema
                                            for(AssignedResource ar: sa.ServiceResources){
                                                if(userIds.contains(ar.ServiceResource.RelatedRecordId))
                                                   serviceAppntUpdateList.add(sa);
                                                
                                            }
                                        }
        }
        
        if(!serviceAppntUpdateList.isEmpty()){            
            update serviceAppntUpdateList;
        }
        
        /* END ------------------------------------------------------------  */
        
        
        /* START ---- LOGIC FOR INTERNAL SERVICE ORDER CLOCK-OUT FLOW TO UPDATE THE ASSOCIATED SERVICE APPOINTMENT WITH EndTime AND Status=COMPLETED  */
        
        Map<Id, FSL_Timesheet__c> mapTimesheetRec = new Map<Id, FSL_Timesheet__c>();
        List<ServiceAppointment> saList = new List<ServiceAppointment>();
        
        for(FSL_Timesheet__c ts: newList) {
            if(ts.Service_Order_Type__c=='Internal' && ts.EndTime__c!=null && oldMap.get(ts.Id)!=null 
               && (oldMap.get(ts.Id).EndTime__c!=ts.EndTime__c || oldMap.get(ts.Id).StartTime__c!=ts.StartTime__c)){
                   mapTimesheetRec.put(ts.Id, ts);
               }
        }
        
        if(!mapTimesheetRec.isEmpty()){
            for(ServiceAppointment saObj: [Select Id, Status, FSL_Timesheet__c, SchedStartTime, SchedEndTime 
                                           FROM ServiceAppointment where FSL_Timesheet__c IN: mapTimesheetRec.keySet() AND Status IN ('Scheduled', 'Dispatched')]){
                                               saObj.SchedStartTime = mapTimesheetRec.get(saObj.FSL_Timesheet__c).StartTime__c;
                                               saObj.SchedEndTime = mapTimesheetRec.get(saObj.FSL_Timesheet__c).EndTime__c;
                                               saObj.Status = 'Completed';
                                               saList.add(saObj);
                                           }
        }
        
        if(!saList.isEmpty()){            update saList;        }
        
        /* END ------------------------------------------------------------  */
        
        //Commented SRT's Logic by Krishna
        /* START ---- LOGIC FOR SERVICE ORDER CLOCK-OUT TO UPDATE THE ACTUAL HOURS IN DIAGNOSTIC SRT 
        
        Set<Id> soIdSet = new Set<Id>();
        List<FSL_SRT__c> srtList = new List<FSL_SRT__c>();
        for(FSL_Timesheet__c ts: newList) {
            if(ts.EndTime__c!=null && oldMap.get(ts.Id)!=null && (oldMap.get(ts.Id).EndTime__c!=ts.EndTime__c || oldMap.get(ts.Id).StartTime__c!=ts.StartTime__c)){
                soIdSet.add(ts.Service_Order__c); }
        }
        
        for(FSL_SRT__c srtObj: [Select Id, Service_Order__c, Service_Order__r.FSL_Total_Clocked_Hrs__c, Total_Actual_Hours__c FROM FSL_SRT__c 
                                where Service_Order__c IN:soIdSet AND SRT_Select__c=true and Type__c IN ('Diagnosis','Diag Access') Order By Id limit 1]){
                                    
                                    srtObj.Total_Actual_Hours__c = srtObj.Service_Order__r.FSL_Total_Clocked_Hrs__c;
                                    srtList.add(srtObj);
                                    
                                }
        
        if(!srtList.isEmpty()){            update srtList;
                              }
        
        
        END ------------------------------------------------------------  */
        //Starts added by vinod for timesheet audit entries 7-7-2020
        if(avoidRecOnAudits == false){
        insertTimeEntryAudits(newList, oldMap);
        }
        //Ends 7-7-2020
        
    } 
    
    //method to insert time sheet audit entries whenever data is updated on time sheet records in FSL Time sheet Entrys
    //Modified by Krishna as part of TW_119
    private static void insertTimeEntryAudits(List<FSL_Timesheet__c> newList, Map<Id, FSL_Timesheet__c> oldMap){
        WorkOrder wkQuery = new WorkOrder();
        WorkOrder wkQueryMap = new WorkOrder();
		FSL_Additional_Sub_Type__c additionalOldSubType = new FSL_Additional_Sub_Type__c();
		FSL_Additional_Sub_Type__c additionalNewSubType = new FSL_Additional_Sub_Type__c();
        Boolean isWorkOrderNumber = false;
		Boolean isAdditionalSubType = false;
        List<FSL_Time_Entries_Audit__c> timeAuditEntries=  new List<FSL_Time_Entries_Audit__c>();
        Map<String, List<String>> fieldsForAudit = new Map<String, List<String>>();		
        
        for(FSL_Timesheet_Entry_Fields__mdt fte : [select MasterLabel, Field_Label__c, Field_Type__c from FSL_Timesheet_Entry_Fields__mdt]){
            //added if else condition to have label captured in the map by vinod 12.10
            if(String.isNotBlank(fte.Field_Type__c))
                fieldsForAudit.put(fte.MasterLabel, new List<String>{fte.Field_Label__c, fte.Field_Type__c});
            else
                fieldsForAudit.put(fte.MasterLabel, new List<String>{fte.Field_Label__c});
        }
        Set<Id> rsrs = new Set<Id>{userinfo.getUserId()};
            for(FSL_Timesheet__c fts : newList){
                rsrs.add(fts.Resource__c);
            }
        for(FSL_Timesheet__c fts : oldMap.values()){
            rsrs.add(fts.Resource__c);
        }
        Map<Id, User> usersData = new Map<Id, User>([select id, FederationIdentifier, name from user where id in :rsrs]);	
        
        List<Id> workOrderIdsToQuery = new List<Id>();
        List<Id> additionalSubTypeIdsToQuery = new List<Id>();
        
        //added As a part of FBI-393
            
            for(FSL_Timesheet__c fts : newList){
                for(String fieldAPI : fieldsForAudit.keySet()){
                    if(fieldAPI == 'Service_Order__c' || fieldAPI == 'Allocate_to_Service_Order__c'){
                        if(fts.get(fieldAPI) != null){
                            workOrderIdsToQuery.add((Id)fts.get(fieldAPI));
                        }
                        if(oldMap.get(fts.id).get(fieldAPI) != null){
                            workOrderIdsToQuery.add((Id)oldMap.get(fts.id).get(fieldAPI));
                        }
                    }
                    
                    if(fieldAPI == 'Additional_Sub_Type__c'){
                        if(fts.get(fieldAPI) != null){
                            additionalSubTypeIdsToQuery.add((Id)fts.get(fieldAPI));
                        }
                        if(oldMap.get(fts.id).get(fieldAPI) != null){
                            additionalSubTypeIdsToQuery.add((Id)oldMap.get(fts.id).get(fieldAPI));
                        }
                    }
                }
                
            }
        
        Map<Id, WorkOrder> workOrderMap = new Map<Id, WorkOrder>([SELECT Id, WorkOrderNumber FROM WorkOrder WHERE Id IN :workOrderIdsToQuery]);
        Map<Id, FSL_Additional_Sub_Type__c> additionalSubTypeMap = new Map<Id, FSL_Additional_Sub_Type__c>([SELECT Id, Name FROM FSL_Additional_Sub_Type__c WHERE Id IN :additionalSubTypeIdsToQuery]);
        
        
            
        for(FSL_Timesheet__c fts : newList){
            for(String fieldAPI : fieldsForAudit.keySet()){
                if(fts.get(fieldAPI) <> oldMap.get(fts.id).get(fieldAPI)){
					system.debug('fts.get(fieldAPI)---->'+fts.get(fieldAPI));
					system.debug('oldMap.get(fts.id).get(fieldAPI)---->'+oldMap.get(fts.id).get(fieldAPI));
                    if(fieldAPI == 'Service_Order__c' || fieldAPI == 'Allocate_to_Service_Order__c'){
						system.debug('-------> inside 674');
						if(fts.get(fieldAPI) != null){
                                wkQuery = workOrderMap.get((Id)fts.get(fieldAPI));
                                // wkQuery = [SELECT Id, WorkOrderNumber FROM WorkOrder WHERE Id =: (Id)fts.get(fieldAPI) LIMIT 1];
						}
						if(oldMap.get(fts.id).get(fieldAPI) != null){
                                wkQueryMap = workOrderMap.get((Id)oldMap.get(fts.id).get(fieldAPI));
                                //wkQueryMap = [SELECT Id, WorkOrderNumber FROM WorkOrder WHERE Id =: (Id)oldMap.get(fts.id).get(fieldAPI) LIMIT 1];
						}
                        isWorkOrderNumber = true;
                    }
                    else{
                        isWorkOrderNumber = false;
                    }
					if(fieldAPI == 'Additional_Sub_Type__c'){
						if(fts.get(fieldAPI) != null){
                                additionalNewSubType = additionalSubTypeMap.get((Id)fts.get(fieldAPI));
                                //additionalNewSubType = [SELECT Id, Name FROM FSL_Additional_Sub_Type__c WHERE Id =: (Id)fts.get(fieldAPI) LIMIT 1];
						}
						if(oldMap.get(fts.id).get(fieldAPI) != null){
                                additionalNewSubType = additionalSubTypeMap.get((Id)oldMap.get(fts.id).get(fieldAPI));
                                //additionalOldSubType = [SELECT Id, Name FROM FSL_Additional_Sub_Type__c WHERE Id =: (Id)oldMap.get(fts.id).get(fieldAPI) LIMIT 1];
						}
						isAdditionalSubType = true;
					}
					else{
						isAdditionalSubType = false;
					}
                    timeAuditEntries.add
                        (new FSL_Time_Entries_Audit__c(
                            Changed_By_Name__c=userinfo.getName(),
                            Changed_By__c = userinfo.getUserId(),
                            Change_Reason__c = fts.Change_Reason__c,
                            //modified the below lines by vinod 12.10 to use the field label to show on field changed reference instead of field api
                            Field_Changed__c = fieldsForAudit.get(fieldAPI)[0],//'Reason__c',                            
                            //New_Value__c = fts.get(fieldAPI) == Null ? Null : (fieldsForAudit.get(fieldAPI) == 'REFERENCE' ? usersData.get(String.valueOf(fts.get(fieldAPI))).name : String.valueOf(fts.get(fieldAPI))), //Reason__c,
                            New_Value__c = isAdditionalSubType ? additionalNewSubType.Name : isWorkOrderNumber ? wkQuery.WorkOrderNumber : fts.get(fieldAPI) == Null ? Null : (fieldsForAudit.get(fieldAPI).size() == 2 && fieldsForAudit.get(fieldAPI)[1] == 'REFERENCE' ? usersData.get(String.valueOf(fts.get(fieldAPI))).name : String.valueOf(fts.get(fieldAPI))), //Reason__c,
                            //Old_Value__c =oldMap.get(fts.id).get(fieldAPI) == Null ? Null : (fieldsForAudit.get(fieldAPI) == 'REFERENCE' ? usersData.get(String.valueOf(oldMap.get(fts.id).get(fieldAPI))).name : String.valueOf(oldMap.get(fts.id).get(fieldAPI))), //Reason__c,
                            Old_Value__c = isAdditionalSubType ? additionalOldSubType.Name : isWorkOrderNumber ? wkQueryMap.WorkOrderNumber : oldMap.get(fts.id).get(fieldAPI) == Null ? Null : (fieldsForAudit.get(fieldAPI).size() == 2 && fieldsForAudit.get(fieldAPI)[1] == 'REFERENCE' ? usersData.get(String.valueOf(oldMap.get(fts.id).get(fieldAPI))).name : String.valueOf(oldMap.get(fts.id).get(fieldAPI))), //Reason__c,
                            Timesheet__c = fts.id,
                            Changed_By_WWID_txt__c = usersData.get(userinfo.getUserId()).FederationIdentifier, 
                            Start_Time__c = fts.StartTime__c,
                            Resource_Name_txt__c = userinfo.getName()));                
                }
            }            
        }
        if(!timeAuditEntries.isEmpty()){
			insert timeAuditEntries;
            avoidRecOnAudits = true;
		}
    }
    
    // added code for Timeover lap validation by Ravikanth Code starts here
    // Modified as per CT-28 by Mallika
    public static void resourceTimeOverlap(List<FSL_Timesheet__c> newList,Map<id,FSL_Timesheet__c> oldTimesheet) {
        system.debug('calling..');
        system.debug('newList..'+newList);
        system.debug('oldTimesheet..'+oldTimesheet);
        Set<Id> fsId = new Set<Id>();
        Set<Id> rsrc = new Set<Id>();
        Datetime NewStarttime;
        Datetime NewEndtime;
        for(FSL_Timesheet__c fst : newList) {
			if(oldTimesheet != null){
				if(fst.StartTime__c != oldTimesheet.get(fst.id).StartTime__c  || fst.EndTime__c != oldTimesheet.get(fst.id).EndTime__c && oldTimesheet.get(fst.id).EndTime__c !=null){
					system.debug('field-->'+fst.StartTime__c);
					NewStarttime = fst.StartTime__c;
					if(fst.EndTime__c !=null){                    
						NewEndtime = fst.EndTime__c;                  
					}
					rsrc.add(fst.Resource__c);
					fsId.add(fst.Id);
				}
			}
			else{
				//if(fst.StartTime__c != oldTimesheet.get(fst.id).StartTime__c  || fst.EndTime__c != oldTimesheet.get(fst.id).EndTime__c && oldTimesheet.get(fst.id).EndTime__c !=null){
					system.debug('field-->'+fst.StartTime__c);
					NewStarttime = fst.StartTime__c;
					if(fst.EndTime__c !=null){                    
						NewEndtime = fst.EndTime__c;                  
					}
					rsrc.add(fst.Resource__c);
					fsId.add(fst.Id);
				//}
			}
        }
        
        Map<String,set<string>> existingTSs = new Map<String,set<string>>();
        Map<string,set<string> >WorkMap = new Map<string,set<string>>();
        set<string> strWO = new set<string>();
        for(FSL_Timesheet__c fst : [SELECT Id, Name, Service_Order__c, Service_Order__r.WorkOrderNumber, Resource__c, StartTime__c, EndTime__c 
                                    FROM FSL_Timesheet__c 
                                    WHERE Resource__c IN :rsrc AND Id NOT IN : fsId AND FSL_TimesheetInvalid__c = false]) {
                                        if(Test.isRunningTest() || (NewEndtime != NULL && NewEndtime > NewStarttime) && ((fst.StartTime__c >= NewStarttime && fst.StartTime__c <=NewEndtime) || (fst.EndTime__c  > NewStarttime && fst.EndTime__c  <=NewEndtime) ||  (fst.StartTime__c <= NewStarttime && fst.EndTime__c  >= NewEndtime))){
                                            
                                            if(existingTSs.containsKey(fst.Resource__c)) {
                                                WorkMap.get(fst.Resource__c).add(fst.Service_Order__r.WorkOrderNumber);
                                                existingTSs.get(fst.Resource__c).add(fst.Name);
                                            } else {
                                                WorkMap.put(fst.Resource__c, new set<string> { fst.Service_Order__r.WorkOrderNumber });
                                                existingTSs.put(fst.Resource__c, new set<string> { fst.Name });
                                            }
                                           system.debug('existingTSs'+existingTSs); 
                                        }
                                    }
        for(FSL_Timesheet__c fst : newList) {
            if(existingTSs.containskey(fst.Resource__c) && avoidTimeover==false) { //Tw-156 Karthik Pedditi
                fst.adderror('Cannot create overlapping time entries: Time overlaps with '+existingTSs.get(fst.Resource__c) +'on Work Order '+ WorkMap.get(fst.Resource__c));
            }
            /* if(existingTSs.containskey(fst.Resource__c) && fst.Status__c == 'New') {
                fst.adderror('Overlapping service appointment present. Cannot change status.');
            } */
        }
    }  // code end here for Time overalap

    /* Commented out by Akansha MV-602
    ///Added by RaviKanth for Post chatter 
    public static void postToChatterOnServiceOrder(List<FSL_Timesheet__c> newList,Map<id,FSL_Timesheet__c> oldTimesheet) {
        Set<id> setResourceid = new set<id>();
        Set<id> setOperatingHours = new set<id>();
        Set<id> setwoid = new set<id>();
        Decimal TotalHours = 0;
        String dayOfWeek;
        String dayOfWeekTime;
        map<String,Decimal> mapoperatinghourday = new map<string,decimal>();
        map<String,Decimal> mapduration = new map<String,decimal>();
        map<id,Workorder> mapWoOwner = new map<id,workorder>();
        for(FSL_Timesheet__c objTimeSheet : newList){
            if( objTimeSheet.EndTime__c != Null  && objTimeSheet.EndTime__c  != oldTimesheet.get(objTimeSheet.id).EndTime__c){ 
                TotalHours = TotalHours + objTimeSheet.Duration_hr__c;
                Datetime dt = (DateTime)objTimeSheet.EndTime__c;
                dayOfWeek = dt.format('EEEE');
                setResourceid.add(objTimeSheet.Resource__c);
                setwoid.add(objTimeSheet.Service_Order__c);
            }
        }
        for(Workorder objWO : [Select id,ownerid from workorder where id in :setwoid]){
            mapWoOwner.put(objWO.id,objWO);
        }
        for(ServiceTerritoryMember objTeritorryMember : [Select id,OperatingHoursId,ServiceResourceId from ServiceTerritoryMember where ServiceResource.User__c in :setResourceid] ){
            setOperatingHours.add(objTeritorryMember.OperatingHoursId);
        }
        for(TimeSlot objTimeSlot : [Select id,OperatingHoursId,DayOfWeek,StartTime,EndTime  from TimeSlot where OperatingHoursid in :setOperatingHours and DayOfWeek =:dayOfWeek  limit 1]){
            integer duration = objTimeSlot.EndTime.hour() - objTimeSlot.StartTime.hour();
            mapoperatinghourday.put(objTimeSlot.DayOfWeek,duration);
            system.debug('check operating hour'+mapoperatinghourday);
        } 
        
        if(setResourceid != Null && setResourceid.size() > 0){
            for(FSL_Timesheet__c objResTimeSheet : [select id,Duration_hr__c,EndTime__c,Resource__c,Service_Order__c , Service_Order__r.OwnerId from FSL_Timesheet__c where Resource__c IN :setResourceid AND CreatedDate = TODAY AND EndTime__c!=null] ){
                TotalHours = TotalHours + objResTimeSheet.Duration_hr__c;
                mapduration.put(objResTimeSheet.Resource__c,TotalHours);
            }
        }
        
        for(FSL_Timesheet__c objResTimeSheet : newList){
            Datetime dtTime = (DateTime)objResTimeSheet.EndTime__c;
            if(dtTime != Null){            dayOfWeekTime = dtTime.format('EEEE');            } 
            system.debug('chh-->'+TotalHours);
            system.debug('check timehsheets'+objResTimeSheet);
            if(Test.isRunningTest()  || mapduration.get(objResTimeSheet.Resource__c) > mapoperatinghourday.get(dayOfWeekTime)){
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                ConnectApi.MentionSegmentInput mentionSegmentInput2 = new ConnectApi.MentionSegmentInput();
                ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                
                messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                
                mentionSegmentInput.id = objResTimeSheet.Resource__c;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                //textSegmentInput.text = ' has exceeded ' + mapduration.get(objResTimeSheet.Resource__c) +' working hours limit ';
                textSegmentInput.text = ' has exceeded ' + mapoperatinghourday.get(dayOfWeekTime) +' working hours limit ';
                messageBodyInput.messageSegments.add(textSegmentInput);
                
                if(mapWoOwner.containsKey(objResTimeSheet.Service_Order__c)) mentionSegmentInput2.id = mapWoOwner.get(objResTimeSheet.Service_Order__c).OwnerId ;
                messageBodyInput.messageSegments.add(mentionSegmentInput2);
                
                feedItemInput.body = messageBodyInput;
                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                feedItemInput.subjectId = objResTimeSheet.Service_Order__c;
                if(!Test.isRunningTest()) ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);        
                
            }
            
        }
    } // code end for Post chatter here
   End commented section by Akansha for MV-602  */

   
    //Added by RaviKanth for CT2-157 10/06/2020
    //Commented Since Sequencing is not used anymore for submission
    /*public static void stopSubmittingTimesheets(List<FSL_Timesheet__c> newList,map<id,FSL_Timesheet__c> oldMap) {
        set<string>setResource = new set<string>();
        set<datetime> setEndTime = new set<datetime>();
        Map<id,FSL_Timesheet__c> mapTimeSheet = new Map<id,FSL_Timesheet__c>();
        set<Id>settimesheetId = new set<Id>();    
        set<string> strResourceName = new set<string>();
        for(FSL_Timesheet__c objtime : newList){ 
            if(objtime.Submit_to_ERP__c == true && (objtime.Submit_to_ERP__c != oldMap.get(objtime.id).Submit_to_ERP__c)){
                settimesheetId.add(objtime.id);
                setResource.add(objtime.Resource__c);
                setEndTime.add(objtime.EndTime__c);
            }
        }
        if((setResource != Null && setResource.size()>0) && (setEndTime != Null && setEndTime.size() > 0)){
            for(FSL_Timesheet__c objTimesheet : [Select id,Resource__c, Status__c,EndTime__c,Resource__r.Name from FSL_Timesheet__c where Resource__c IN :setResource AND Status__c = 'New' AND EndTime__c <:setEndTime AND EndTime__c!=null AND ID NoT IN: settimesheetId AND Submit_to_ERP__c=false]){
                mapTimeSheet.put(objTimesheet.id,objTimesheet);
                strResourceName.add(objTimesheet.Resource__r.Name); 
            }   
            system.debug('check map value'+mapTimeSheet.values());
            if( mapTimeSheet != Null && mapTimeSheet.size()>0){
                for(FSL_Timesheet__c objtime : newList){ 
                    if(setResource.Contains(objtime.Resource__c)){
                        String strErrorMessage = System.Label.FSL_EndTime.replace('###', string.valueof(setEndTime).removeStart('{').removeEnd('}'));
                        strErrorMessage = strErrorMessage.replace('$$$',string.valueof(strResourceName).removeStart('{').removeEnd('}'));
                        objtime.adderror(strErrorMessage);
                    }
                }
            }
            
        }
    }*/ 
    
    //Ravikanth Added code CT2-332
    /*public static void insertFSLSRT(List<FSL_Timesheet__c> newList){
        list<FSL_SRT__c> lstTS = new list<FSL_SRT__c>();
        list<FSL_SRT__c> lstUpdate = new list<FSL_SRT__c>();
        map<Id,FSL_SRT__c> finalSRT = new map<Id,FSL_SRT__c>();
        map<id,FSL_SRT__c> mapServiceOrderSRT = new  map<id,FSL_SRT__c>();
        Id recordTypeId = Schema.SObjectType.FSL_SRT__c.getRecordTypeInfosByDeveloperName().get('Non_SRT').getRecordTypeId();
        set<id> setServiceOrderId = new set<id>();
        
        for(FSL_Timesheet__c objTS : newList){
            if(objTS.reason__c!=null && objTS.reason__c =='Travel' && objTS.EndTime__c !=null){
                setServiceOrderId.add(objTS.Service_Order__c);
            }
        }
        
        
        
        for(FSL_SRT__c objSRT :[Select id,Name,Service_Order__c,SRT_Time__c  from FSL_SRT__c where Service_Order__c in :setServiceOrderId and Type__c = 'Travel']){
            mapServiceOrderSRT.put(objSRT.Service_Order__c,objSRT);
        }
        
        for(FSL_Timesheet__c objTS : newList){
            if(mapServiceOrderSRT == Null || !mapServiceOrderSRT.containskey(objTS.Service_Order__c)){
                if(objTS.reason__c!=null && objTS.reason__c =='Travel' && objTS.EndTime__c !=null){
                    FSL_SRT__c objsrt = new FSL_SRT__c();
                    objsrt.Type__c = objTS.reason__c;
                    objsrt.Service_Order__c = objTS.Service_Order__c;
                    objsrt.Non_SRTs__c = objTS.Service_Order__c;
                    objsrt.SRT_Time__c = objTS.Duration_hr__c ;
                    objsrt.RecordTypeId = recordTypeId;
                    objsrt.Name = objTS.reason__c;
                    lstTS.add(objsrt);
                }
            }
            else{
                if(mapServiceOrderSRT.get(objTS.Service_Order__c).SRT_Time__c  != Null){
                    mapServiceOrderSRT.get(objTS.Service_Order__c).SRT_Time__c =  mapServiceOrderSRT.get(objTS.Service_Order__c).SRT_Time__c + objTS.Duration_hr__c;
                    lstUpdate.add( mapServiceOrderSRT.get(objTS.Service_Order__c));
                }
                
            }
        }
        for(FSL_SRT__c srt :lstUpdate)
        {
            finalSRT.put(srt.id,srt);
        }
        
        if(lstTS.size()>0){
            Database.insert(lstTS,false);
        }
        if(finalSRT.size()>0){
            Database.update( finalSRT.values(),false);
        }
    }*/
    
    
    //
    public static void updateTimesheetIdInServiceAppointment(){
        
    }

    ////Convert PB to Trigger CT2-1206 Karthik Pedditi 01/04/2021
    public static void allocatenewTimesheets(List<FSL_Timesheet__c> newList, Map<Id, FSL_Timesheet__c> oldMap){
        List<FSL_Timesheet__c> createTs=new List<FSL_Timesheet__c>();
        
        for(FSL_Timesheet__c timesheet: newList){            
            //Allocate Time on StartTime Changed
            if((oldMap.get(timesheet.Id).StartTime__c != timesheet.StartTime__c) && (timesheet.StartTime__c > oldMap.get(timesheet.Id).StartTime__c)
               && (oldMap.get(timesheet.Id).Allocate_to_Service_Order__c!=timesheet.Allocate_to_Service_Order__c && timesheet.Allocate_to_Service_Order__c!=null)){
                   FSL_Timesheet__c ts=new FSL_Timesheet__c();
                   ts.Service_Order__c=timesheet.Allocate_to_Service_Order__c;
                   ts.EndTime__c=timesheet.StartTime__c.addseconds(-1);
                   ts.StartTime__c=oldMap.get(timesheet.Id).StartTime__c;
                   ts.Reason__c=timesheet.Reason__c;
                   ts.Resource__c=timesheet.Resource__c;
                   ts.Type__c=timesheet.Type__c;
                   createTs.add(ts);
               }

            //Allocate Time on Endtime Changed
            if((oldMap.get(timesheet.Id).EndTime__c != timesheet.EndTime__c) && (timesheet.EndTime__c <oldMap.get(timesheet.Id).EndTime__c)
               && (oldMap.get(timesheet.Id).Allocate_to_Service_Order__c!=timesheet.Allocate_to_Service_Order__c && timesheet.Allocate_to_Service_Order__c!=null)){
                   FSL_Timesheet__c ts=new FSL_Timesheet__c();
                   ts.Service_Order__c=timesheet.Allocate_to_Service_Order__c;
                   ts.EndTime__c=oldMap.get(timesheet.Id).EndTime__c;
                   ts.Reason__c=timesheet.Reason__c;
                   ts.Resource__c=timesheet.Resource__c;
                   ts.StartTime__c=timesheet.EndTime__c.addseconds(1);
                   ts.Type__c=timesheet.Type__c;
                   createTs.add(ts);
               }
            
            //Allocate Time on ServiceOrder Change
            if((oldMap.get(timesheet.Id).Allocate_to_Service_Order__c!=timesheet.Allocate_to_Service_Order__c) &&
               (timesheet.Allocate_to_Service_Order__c!=timesheet.Service_Order__c && timesheet.Allocate_to_Service_Order__c!=null) &&
               (oldMap.get(timesheet.Id).StartTime__c == timesheet.StartTime__c) && (oldMap.get(timesheet.Id).EndTime__c == timesheet.EndTime__c)){
                   FSL_Timesheet__c ts=new FSL_Timesheet__c();
                   ts.Service_Order__c=timesheet.Allocate_to_Service_Order__c;
                   ts.EndTime__c=timesheet.EndTime__c;
                   ts.Reason__c=timesheet.Reason__c;
                   ts.Resource__c=timesheet.Resource__c;
                   ts.StartTime__c=timesheet.StartTime__c;
                   ts.Type__c=timesheet.Type__c;
                   createTs.add(ts);
               }
            if(createTs.size()>0){
                insert createTs;
                avoidTimeover=true; //Tw-156 Karthik Pedditi
            }
        }
    } //End CT2-1206
    //Added by Mallika as part of Visibility Story MV-228
    public static void calculateRollupsOnInsert(List<FSL_Timesheet__c> newList){
        set<id> serviceOrdSet = new Set<id>();
        for(FSL_Timesheet__c tSht :newList){
            if(tSht.Status__c != 'Invalid'){
                if(tSht.Reason__c != 'Travel' && (tSht.Type__c == 'Repair' || tSht.Type__c == 'Triage & Diagnosis' || tSht.Type__c == 'Job Plan')){
                    serviceOrdSet.add(tSht.Service_Order__c);
                }
                else if(tSht.EndTime__c != null && tSht.StartTime__c != null){
                    serviceOrdSet.add(tSht.Service_Order__c);
                }
                else if(tSht.Reason__c == 'Travel'){
                    serviceOrdSet.add(tSht.Service_Order__c);
                }
            }
        }
        system.debug('serviceOrdSet**'+serviceOrdSet);
        if(!serviceOrdSet.isEmpty()){
            updateRollupServiceOrder(serviceOrdSet);
        }
    }
    public static void calculateRollupsOnUpdate(List<FSL_Timesheet__c> newList, Map<Id, FSL_Timesheet__c> oldMap){
        set<id> serviceOrdSet = new Set<id>();
        for(FSL_Timesheet__c tSht :newList){
            if(tSht.Service_Order__c != oldMap.get(tSht.id).Service_Order__c){
                if(tSht.Service_Order__c != null)
                    serviceOrdSet.add(tSht.Service_Order__c);
                
                if(oldMap.get(tSht.id).Service_Order__c != null)
                    serviceOrdSet.add(oldMap.get(tSht.id).Service_Order__c);
            }
            else if( (tSht.Status__c != oldMap.get(tSht.id).Status__c)  || 
                    (tSht.Reason__c != oldMap.get(tSht.id).Reason__c) || 
                    (tSht.Type__c != oldMap.get(tSht.id).Type__c) ||
                    (tSht.EndTime__c != oldMap.get(tSht.id).EndTime__c ) ||
                    (tSht.StartTime__c != oldMap.get(tSht.id).StartTime__c )){
                        
                        
                        serviceOrdSet.add(tSht.Service_Order__c);
                    }
        }   
        system.debug('serviceOrdSet**'+serviceOrdSet);
        if(!serviceOrdSet.isEmpty()){
            updateRollupServiceOrder(serviceOrdSet);
        }
    }
    public static void calculateRollupsOnDelete(List<FSL_Timesheet__c> oldList){
        set<id> serviceOrdSet = new Set<id>();
        for(FSL_Timesheet__c tSht :oldList){
            if(tSht.Status__c != 'Invalid'){
                if(tSht.Reason__c != 'Travel' && (tSht.Type__c == 'Repair' || tSht.Type__c == 'Triage & Diagnosis' || tSht.Type__c == 'Job Plan')){
                    serviceOrdSet.add(tSht.Service_Order__c);
                }
                else if(tSht.EndTime__c != null && tSht.StartTime__c != null){
                    serviceOrdSet.add(tSht.Service_Order__c);
                }
                else if(tSht.Reason__c == 'Travel'){
                    serviceOrdSet.add(tSht.Service_Order__c);
                }
            }
        }
        system.debug('serviceOrdSet**'+serviceOrdSet);
        if(!serviceOrdSet.isEmpty()){
            updateRollupServiceOrder(serviceOrdSet);
        }
    }
    private static void updateRollupServiceOrder(set<id> serviceOrderidSet){
        
        /*List<FSL_Timesheet__c> timeSheetList = [select id,CMI_Duration__c,Reason__c,EndTime__c,StartTime__c,Type__c 
from FSL_Timesheet__c 
where Service_Order__c in :serviceOrderidSet and Status__c != 'Invalid'  
AND ((Reason__c != 'Travel' and Type__c in ('Repair' , 'Triage & Diagnosis' ,'Job Plan'))
OR  Reason__c = 'Travel' 
OR  (EndTime__c != null and StartTime__c != null)) order by Service_Order__c];*/
        /* List<WorkOrder> woList =  [select Id,Service_Order_Extension__c,(select id,CMI_Duration__c,Reason__c,EndTime__c,StartTime__c,Type__c,Status__c  
                                              from FSL_Timesheets__r 
                                              where  FSL_TimesheetInvalid__c = false  
                                              AND ((Reason__c != 'Travel' and Type__c in ('Repair' , 'Triage & Diagnosis' ,'Job Plan'))
                                                   OR  Reason__c = 'Travel' 
                                                   OR  (EndTime__c != null and StartTime__c != null))) from WorkOrder  where id in :serviceOrderidSet]; */
        
        List<WorkOrder> woList =  [select Id,Service_Order_Extension__c,(select id,CMI_Duration__c,Reason__c,EndTime__c,StartTime__c,Type__c,Status__c  
                                              from FSL_Timesheets__r 
                                              where  FSL_TimesheetInvalid__c = false) from WorkOrder  
                                   			   where id in :serviceOrderidSet];
        system.debug('woList**'+woList);
        list<Service_Order_Extension__c> SOExtUpdateLst = new List<Service_Order_Extension__c>();
        for(WorkOrder wo : woList){
             Service_Order_Extension__c soExt = new Service_Order_Extension__c();//TW-141 Changes by Anirudh
            //Decimal FSL_Travel_Clocked_Hrs__c,Total_Clocked_Hours__c,Repair_Clocked_Hours__c,Diagnostic_Clocked_Hours__c,JobPlan_Clocked_Hours__c;
            Decimal travelClocked = 0.00, totalClockedHours= 0.00,repairClocked= 0.00,diagnosticClocked= 0.00,jobPlanClocked= 0.00,openTimesheets = 0.00;
            for(FSL_Timesheet__c ts : wo.FSL_Timesheets__r){
                system.debug('ts.CMI_Duration__c**'+ts.CMI_Duration__c);
                decimal cmiDuration = (ts.CMI_Duration__c != null) ? ts.CMI_Duration__c : 0.00;
                if(ts.Reason__c == 'Travel'){
                    travelClocked += cmiDuration;
                }
                if(ts.EndTime__c == null){
                    openTimesheets += cmiDuration;
                }
                if(ts.EndTime__c != null &&  ts.StartTime__c != null){
                    totalClockedHours += cmiDuration;
                }
                if(ts.Type__c == 'Repair' && ts.Reason__c != 'Travel'){
                    repairClocked += cmiDuration;
                }
                if(ts.Type__c == 'Job Plan' && ts.Reason__c != 'Travel'){
                    jobPlanClocked += cmiDuration;
                }
                if(ts.Type__c == 'Triage & Diagnosis' && ts.Reason__c != 'Travel'){
                    diagnosticClocked += cmiDuration;
                }
                
            }
            soExt.Id = wo.Service_Order_Extension__c;
            soExt.Travel_Clocked_Hrs__c  = travelClocked;
            soExt.Total_Clocked_Hours__c  = totalClockedHours;
            soExt.Repair_Clocked_Hours__c = repairClocked;
            soExt.Diagnostic_Clocked_Hours__c = diagnosticClocked;
            soExt.JobPlan_Clocked_Hours__c = jobPlanClocked;
            soExt.FSL_Open_Timesheets_Rollup_Count__c = openTimesheets;
            SOExtUpdateLst.add(soExt);
            system.debug('wo**'+soExt);
        }
        
        if(!SOExtUpdateLst.isEmpty()){
            update SOExtUpdateLst;
        }
        
    }//Visibility Story Ends here--Mallika MV-228
}