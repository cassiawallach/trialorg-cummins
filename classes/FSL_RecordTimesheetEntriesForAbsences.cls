/* Created by - VINOD YELALA
* Date        - 10.8.2020
* Description - Create timesheet entries for the resource absences records that stars in FSL_AbsenceRangeforTimesheets (Custom label) no# of days. test
* Test Class  - FSL_RecordTimesheetEntriesForAbsences_Test
* JIRA NO      - CT2-8
*/

//for running in dev console for demo purpose -- Database.executeBatch(new FSL_RecordTimesheetEntriesForAbsences());
global class FSL_RecordTimesheetEntriesForAbsences implements Database.Batchable<sObject> {
    global Id recordTypeId =  Schema.SObjectType.FSL_Timesheet__c.getRecordTypeInfosByDeveloperName().get('Open_Timesheet').getRecordTypeId();
    global Id worecordTypeId =  Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId(); //raghav
    
    global Id allDayREcTypeID = Schema.SObjectType.ResourceAbsence.getRecordTypeInfosByDeveloperName().get('All_Day').getRecordTypeId();
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute - where the resource absence starts in FSL_AbsenceRangeforTimesheets next days.
        String query = 'select Id, resource.RelatedRecordId, start, end,RecordTypeId, resource.relatedRecord.FSL_Primary_Service_Territory_Code__c,Resource_ERP__c,Billing_Type__c '+
            'from ResourceAbsence where  start >= today and start < = NEXT_N_DAYS:'+Integer.valueOf(System.Label.FSL_AbsenceRangeforTimesheets.trim());
        return Database.getQueryLocator(query);
    }
 /**   global void execute(Database.BatchableContext bc, List<sObject> records){
        try{
            system.debug('kar_records'+records);
            // process each batch of records
            Set<Id> resourceIds = new Set<Id>();
            List<ResourceAbsence> allDayRsrcs = new List<ResourceAbsence>();
            Map<Id, String> userTerrCode = new Map<Id, String>();
            Map<String, Id> serTerrOpHrs = new Map<String, Id>();
            Map<Id, Map<String, TimeSlot>> opHrsSlots = new Map<Id, Map<String, TimeSlot>>();
            List<FSL_Timesheet__c> tss = new List<FSL_Timesheet__c>();
            Set<String> billTypes = new set<String>();
            ResourceAbsence ra;
            //collects all billing types to read work orders
            //collects the resource ids to get the timeslot for the user/resource.
            system.debug('kar_allDayREcTypeID'+allDayREcTypeID);
            for(sobject so : records){
                ra = (ResourceAbsence)so;
                 system.debug('kar_ra.RecordTypeId'+ra.RecordTypeId);
                if(allDayREcTypeID == ra.RecordTypeId){
                    system.debug('kar........');
                    billTypes.add(ra.Billing_Type__c);
                    resourceIds.add(ra.ResourceId);
                }
            }
             system.debug('kar_records1'+billTypes);
             system.debug('kar_records2'+resourceIds);
            if(!resourceIds.isEmpty()){
                //read the service territory codes belong to above resoruces from the user record using FSL_Primary_Service_Territory_Code__c
                for(ServiceResource sr : [select User__r.FSL_Primary_Service_Territory_Code__c, id from ServiceResource where id in:resourceIds AND 
                                          User__r.FSL_Primary_Service_Territory_Code__c <> NULL AND User__r.FSL_Primary_Service_Territory_Code__c<> ''])
                {
                    userTerrCode.put(sr.id, sr.User__r.FSL_Primary_Service_Territory_Code__c);
                     system.debug('kar_records3'+userTerrCode);
                }
                if(!userTerrCode.isEmpty()){
                    //read the service territory code with operation hours id
                    for(ServiceTerritory st : [select id, OperatingHoursId, FSL_Service_Territory_Code__c from ServiceTerritory where FSL_Service_Territory_Code__c IN :userTerrCode.values()]){
                        serTerrOpHrs.put(st.FSL_Service_Territory_Code__c, st.OperatingHoursId);
                         system.debug('kar_records4'+serTerrOpHrs);
                    }
                    if(!serTerrOpHrs.isEmpty()){
                        Map<String, TimeSlot> tempSlot;
                        //gets the operation hours with timeslots
                        for(OperatingHours oh : [select id, (select StartTime, EndTime, DayofWeek from TimeSlots) FROM OperatingHours where id in :serTerrOpHrs.values()]){
                            system.debug('oh.TimeSlots::'+oh.TimeSlots);
                            if(!oh.TimeSlots.isEmpty()){
                                //prepares map of operating hours with list of timeslots.
                                for(TimeSlot ts : oh.TimeSlots)
                                {
                                    if(opHrsSlots.containsKey(oh.id))
                                        opHrsSlots.get(oh.id).put(ts.DayOfWeek, ts);
                                    else{
                                        tempSlot = new Map<String, TimeSlot>();
                                        tempSlot.put(ts.DayOfWeek, ts);
                                        opHrsSlots.put(oh.id, tempSlot);
                                    }
                                }
                            }
                        }
                    }
                }
                String weekDay;
                system.debug('userTerrCode::'+userTerrCode);
                system.debug('serTerrOpHrs::'+serTerrOpHrs);
                system.debug('opHrsSlots::'+opHrsSlots);
            }
            Map<String, Id> womap = new Map<String, Id>();
            for(WorkOrder wo : [select id,ERP__c,Billing_Type__c from WorkOrder where Billing_Type__c in:billTypes AND recordtypeId=:worecordTypeId]){
                womap.put(wo.Billing_Type__c, wo.id);
                system.debug('kar_records5'+womap);
            }
            Date sdt,edt;
            for(sobject so : records){
                ra = (ResourceAbsence)so;
               
                system.debug('kar____'+ra);
                if(womap.containsKey(ra.Billing_Type__c)){
                    sdt = ra.start.date();
                    edt = ra.end.date();
                    Timeslot tempTS;
                    String weekDay;
                    //checks the days difference between start and end time in absence record if more than ZERO then creates timsheet record for every in that range including the weekends
                    if(sdt.daysBetween(edt) >0){
                        system.debug('kar_records6'+sdt);
                        for(Integer i=0; i<=sdt.daysBetween(edt); i++){
                            //check if the resource has timeslots/operation hours
                            if(userTerrCode.containsKey(ra.ResourceId) && serTerrOpHrs.containsKey(userTerrCode.get(ra.ResourceId)) && 
                               opHrsSlots.containsKey(serTerrOpHrs.get(userTerrCode.get(ra.ResourceId))))
                              {
                               system.debug('kar_records7'+opHrsSlots);
                                Map<String, TimeSlot> ts = opHrsSlots.get(serTerrOpHrs.get(userTerrCode.get(ra.ResourceId)));
                                system.debug('BEFORE>>>>ra start and end::'+ra.start+'&&&end::'+ra.End);
                                Date timesheetDt;
                                if(i == 0)
                                    timesheetDt = sdt;
                                else
                                    timesheetDt = sdt.addDays(i);
                                weekDay = DateTime.newInstance(timesheetDt.year(), timesheetDt.month(), timesheetDt.day(),0,0,0).format('EEEE');
                                //checks if the day has timeslot exist like monday tuesday etc. - if not, then defaults to 12am to 11.59pm hrs --see its ELSE
                                if(ts.containskey(weekDay)){
                                    tempTS = ts.get(weekDay);
                                    
                                    system.debug('start hrs::'+tempTS.startTime.hour()); 
                                    ra.start = DateTime.newInstance(timesheetDt.year(), timesheetDt.month(), timesheetDt.day(),tempTS.startTime.hour(), tempTS.startTime.minute(), tempTS.startTime.second());//DateTime.newInstance(2006, 3, 16, 12, 6, 13);
                                    //weekDay = ra.Start.format('EEEE'); 
                                    //tempTS = ts.get(weekDay);
                                    system.debug('end hrs::'+tempTS.endTime.hour());
                                    ra.end = DateTime.newInstance(timesheetDt.year(), timesheetDt.month(), timesheetDt.day(),tempTS.endTime.hour(), tempTS.endTime.minute(), tempTS.endTime.second());
                                    tss.add(new FSL_Timesheet__c(StartTime__c=ra.start, endTime__c=ra.end, recordtypeid=recordTypeId , Resource_Absence__c = ra.Id,Billing_Type__c	= ra.Billing_Type__c,
                                                                 resource__c = ra.resource.RelatedRecordId, Service_Order__c= womap.get(ra.Billing_Type__c)));
                                }
                                else{
                                    ra.start = DateTime.newInstance(timesheetDt.year(), timesheetDt.month(), timesheetDt.day(),0,0,0);
                                    ra.end = DateTime.newInstance(timesheetDt.year(), timesheetDt.month(), timesheetDt.day(),23,59,59);
                                    tss.add(new FSL_Timesheet__c(StartTime__c=ra.start, endTime__c=ra.end, recordtypeid=recordTypeId , Resource_Absence__c = ra.Id,Billing_Type__c	= ra.Billing_Type__c,
                                                                 resource__c = ra.resource.RelatedRecordId, Service_Order__c= womap.get(ra.Billing_Type__c)));
                                }
                            }//runs if no timeslots/operations found the resource on absence record  -defautls to 12am to 11.559pm hrs
                            else{
                                ra.start = DateTime.newInstance(ra.start.year(), ra.start.month(), ra.start.day(),0,0,0);
                                ra.end = DateTime.newInstance(ra.end.year(), ra.end.month(), ra.end.day(),23,59,59);
                                tss.add(new FSL_Timesheet__c(StartTime__c=ra.start, endTime__c=ra.end, recordtypeid=recordTypeId , Resource_Absence__c = ra.Id,Billing_Type__c	= ra.Billing_Type__c,
                                                             resource__c = ra.resource.RelatedRecordId, Service_Order__c= womap.get(ra.Billing_Type__c)));
                            } // added Resource_Absence__c = ra.Id this in the query by Ravi as per Us-201
                        }
                    }//for a day range absence
                    else
                        tss.add(new FSL_Timesheet__c(StartTime__c=ra.start, endTime__c=ra.end, recordtypeid=recordTypeId , Resource_Absence__c = ra.Id,Billing_Type__c	= ra.Billing_Type__c,
                                                     resource__c = ra.resource.RelatedRecordId, Service_Order__c= womap.get(ra.Billing_Type__c)));
                }
            }
            //inserts the timesheet
            if(!tss.isEmpty()){ 
                update ra;
                system.debug('kar_records8'+tss);
                insert tss;
                              }
        }catch(system.exception e){
        }
    }**/
    
      global void execute(Database.BatchableContext bc, List<sObject> records){
        try{
            system.debug('kar_worecordTypeId'+worecordTypeId);
            system.debug('kar_records'+records);
            // process each batch of records
            Set<Id> resourceIds = new Set<Id>();
            List<ResourceAbsence> allDayRsrcs = new List<ResourceAbsence>();
            Map<Id, String> userTerrCode = new Map<Id, String>();
            Map<String, Id> serTerrOpHrs = new Map<String, Id>();
            
             Map<String,List<ResourceAbsence>> codeResourceAbsences=new Map<String,List<ResourceAbsence>>();
            
            Map<Id, Map<String, TimeSlot>> opHrsSlots = new Map<Id, Map<String, TimeSlot>>();
            List<FSL_Timesheet__c> tss = new List<FSL_Timesheet__c>();
            ResourceAbsence ra;
            //collects all billing types to read work orders
            //collects the resource ids to get the timeslot for the user/resource.
            system.debug('kar_allDayREcTypeID'+allDayREcTypeID);
            for(sobject so : records){
                ra = (ResourceAbsence)so;
                 system.debug('kar_ra.RecordTypeId'+ra.RecordTypeId);
                if(allDayREcTypeID == ra.RecordTypeId){
                    resourceIds.add(ra.ResourceId);
                       system.debug('kar........'+resourceIds);
                }
            }
            
           Map<ServiceTerritory,String> serTerCodeMap=new Map<ServiceTerritory,String>();
             Map<ServiceTerritory,List<ResourceAbsence>> serTerAbsensesMap=new  Map<ServiceTerritory,List<ResourceAbsence>>();
            
            if(!resourceIds.isEmpty()){
                //read the service territory codes belong to above resoruces from the user record using FSL_Primary_Service_Territory_Code__c
                for(ServiceResource sr : [select User__r.FSL_Primary_Service_Territory_Code__c, id from ServiceResource where id in:resourceIds AND 
                                          User__r.FSL_Primary_Service_Territory_Code__c <> NULL AND User__r.FSL_Primary_Service_Territory_Code__c<> ''])
                {
                    userTerrCode.put(sr.id, sr.User__r.FSL_Primary_Service_Territory_Code__c);
                     system.debug('kar_records3'+userTerrCode);
                }
                if(!userTerrCode.isEmpty()){
                    //read the service territory code with operation hours id
                    for(ServiceTerritory st : [select id, OperatingHoursId, FSL_Service_Territory_Code__c from ServiceTerritory where FSL_Service_Territory_Code__c IN :userTerrCode.values()]){
                        serTerrOpHrs.put(st.FSL_Service_Territory_Code__c, st.OperatingHoursId);
                         system.debug('kar_records4'+serTerrOpHrs);
                        
                        
                         serTerCodeMap.put(st,st.FSL_Service_Territory_Code__c);
                    }
                    if(!serTerrOpHrs.isEmpty()){
                        Map<String, TimeSlot> tempSlot;
                        //gets the operation hours with timeslots
                        for(OperatingHours oh : [select id, (select StartTime, EndTime, DayofWeek from TimeSlots) FROM OperatingHours where id in :serTerrOpHrs.values()]){
                            system.debug('oh.TimeSlots::'+oh.TimeSlots);
                            if(!oh.TimeSlots.isEmpty()){
                                //prepares map of operating hours with list of timeslots.
                                for(TimeSlot ts : oh.TimeSlots)
                                {
                                    if(opHrsSlots.containsKey(oh.id))
                                        opHrsSlots.get(oh.id).put(ts.DayOfWeek, ts);
                                    else{
                                        tempSlot = new Map<String, TimeSlot>();
                                        tempSlot.put(ts.DayOfWeek, ts);
                                        opHrsSlots.put(oh.id, tempSlot);
                                    }
                                }
                            }
                        }
                    }
                }
                String weekDay;
                system.debug('userTerrCode::'+userTerrCode);
                system.debug('serTerrOpHrs::'+serTerrOpHrs);
                system.debug('opHrsSlots::'+opHrsSlots);
            }
            
            //resourceIds
           
            WorkOrder woRec;
            
            Set<String> ERPSet = new Set<String>{'BMS','MOVEX','MOVEX-UK'}; //raghav
            List<WorkOrder> woList=[SELECT Id,ERP__c,ServiceTerritory.Id,ServiceTerritory.FSL_Service_Territory_Code__c FROM WorkOrder where recordtypeId=:worecordTypeId AND  ERP__c IN: ERPSet AND FSL_Active__c = true]; //raghav
            system.debug('woListkarthik'+woList);
            map<Id,List<WorkOrder>> WorkOrderMap=new map<Id,List<WorkOrder>>();//Ser TerId and wo's
            map<String,List<WorkOrder>> codewosMap=new map<String,List<WorkOrder>>(); //code and wo's
            for(WorkOrder wo:woList){
                if(WorkOrderMap.containsKey(wo.ServiceTerritory.Id)){
                    WorkOrderMap.get(wo.ServiceTerritory.Id).add(wo);
                }else{
                    WorkOrderMap.put(wo.ServiceTerritory.Id,new List<WorkOrder>{wo});
                }
                if(codewosMap.containsKey(wo.ServiceTerritory.FSL_Service_Territory_Code__c)){
                    codewosMap.get(wo.ServiceTerritory.FSL_Service_Territory_Code__c).add(wo);
                }else{
                    codewosMap.put(wo.ServiceTerritory.FSL_Service_Territory_Code__c,new List<WorkOrder>{wo});
                }
            }
            system.debug('kar++1'+codewosMap);
            system.debug('kar++2'+WorkOrderMap);
            
            Date sdt,edt;
            for(sobject so : records){
                system.debug('kar_____so'+so);
                ra = (ResourceAbsence)so;
                
                system.debug('kar__1'+userTerrCode.containsKey(ra.ResourceId));
                system.debug('kar__2'+codewosMap.containsKey(userTerrCode.get(ra.ResourceId)));
                system.debug('kar__3'+codewosMap.get(userTerrCode.get(ra.ResourceId))[0]);
                
                
                if(userTerrCode.containsKey(ra.ResourceId) && codewosMap.containsKey(userTerrCode.get(ra.ResourceId)))
                {
                  //  woRec=codewosMap.values();
                  woRec= codewosMap.get(userTerrCode.get(ra.ResourceId))[0];
                  system.debug('kar__4'+codewosMap.get(userTerrCode.get(ra.ResourceId))[0]);  
                }
              
                if(woRec!=null){
                    sdt = ra.start.date();
                    edt = ra.end.date();
                    Timeslot tempTS;
                    String weekDay;
                    system.debug('kar_sdt'+sdt);
                    system.debug('kar_edt'+edt);
                    //checks the days difference between start and end time in absence record if more than ZERO then creates timsheet record for every in that range including the weekends
                    if(sdt.daysBetween(edt) >0){
                         system.debug('kar_...');
                        for(Integer i=0; i<=sdt.daysBetween(edt); i++){
                            //check if the resource has timeslots/operation hours
                            if(userTerrCode.containsKey(ra.ResourceId) && serTerrOpHrs.containsKey(userTerrCode.get(ra.ResourceId)) && 
                               opHrsSlots.containsKey(serTerrOpHrs.get(userTerrCode.get(ra.ResourceId))))
                              {
                               system.debug('kar_records7'+opHrsSlots);
                                Map<String, TimeSlot> ts = opHrsSlots.get(serTerrOpHrs.get(userTerrCode.get(ra.ResourceId)));
                                system.debug('BEFORE>>>>ra start and end::'+ra.start+'&&&end::'+ra.End);
                                Date timesheetDt;
                                if(i == 0)
                                    timesheetDt = sdt;
                                else
                                    timesheetDt = sdt.addDays(i);
                                weekDay = DateTime.newInstance(timesheetDt.year(), timesheetDt.month(), timesheetDt.day(),0,0,0).format('EEEE');
                                //checks if the day has timeslot exist like monday tuesday etc. - if not, then defaults to 12am to 11.59pm hrs --see its ELSE
                                if(ts.containskey(weekDay)){
                                    tempTS = ts.get(weekDay);
                                    
                                    system.debug('start hrs::'+tempTS.startTime.hour()); 
                                    ra.start = DateTime.newInstance(timesheetDt.year(), timesheetDt.month(), timesheetDt.day(),tempTS.startTime.hour(), tempTS.startTime.minute(), tempTS.startTime.second());//DateTime.newInstance(2006, 3, 16, 12, 6, 13);
                                    //weekDay = ra.Start.format('EEEE'); 
                                    //tempTS = ts.get(weekDay);
                                    system.debug('end hrs::'+tempTS.endTime.hour());
                                    ra.end = DateTime.newInstance(timesheetDt.year(), timesheetDt.month(), timesheetDt.day(),tempTS.endTime.hour(), tempTS.endTime.minute(), tempTS.endTime.second());
                                    tss.add(new FSL_Timesheet__c(StartTime__c=ra.start, endTime__c=ra.end, recordtypeid=recordTypeId , Resource_Absence__c = ra.Id,Billing_Type__c	= ra.Billing_Type__c,
                                    Resource_ERP__c	= ra.Resource_ERP__c, resource__c = ra.resource.RelatedRecordId, Service_Order__c=woRec.Id));
                                    system.debug('tss1'+new FSL_Timesheet__c(StartTime__c=ra.start, endTime__c=ra.end, recordtypeid=recordTypeId , Resource_Absence__c = ra.Id,Billing_Type__c	= ra.Billing_Type__c,
                                    Resource_ERP__c	= ra.Resource_ERP__c, resource__c = ra.resource.RelatedRecordId, Service_Order__c=woRec.Id));
                                }
                                else{
                                    ra.start = DateTime.newInstance(timesheetDt.year(), timesheetDt.month(), timesheetDt.day(),0,0,0);
                                    ra.end = DateTime.newInstance(timesheetDt.year(), timesheetDt.month(), timesheetDt.day(),23,59,59);
                                    tss.add(new FSL_Timesheet__c(StartTime__c=ra.start, endTime__c=ra.end, recordtypeid=recordTypeId , Resource_Absence__c = ra.Id,Billing_Type__c	= ra.Billing_Type__c,
                                    Resource_ERP__c	= ra.Resource_ERP__c,resource__c = ra.resource.RelatedRecordId, Service_Order__c= woRec.Id));
                                     system.debug('tss2'+new FSL_Timesheet__c(StartTime__c=ra.start, endTime__c=ra.end, recordtypeid=recordTypeId , Resource_Absence__c = ra.Id,Billing_Type__c	= ra.Billing_Type__c,
                                    Resource_ERP__c	= ra.Resource_ERP__c, resource__c = ra.resource.RelatedRecordId, Service_Order__c=woRec.Id));

                                }
                            }//runs if no timeslots/operations found the resource on absence record  -defautls to 12am to 11.559pm hrs
                            else{
                                ra.start = DateTime.newInstance(ra.start.year(), ra.start.month(), ra.start.day(),0,0,0);
                                ra.end = DateTime.newInstance(ra.end.year(), ra.end.month(), ra.end.day(),23,59,59);
                                tss.add(new FSL_Timesheet__c(StartTime__c=ra.start, endTime__c=ra.end, recordtypeid=recordTypeId , Resource_Absence__c = ra.Id,Billing_Type__c	= ra.Billing_Type__c,
                                 Resource_ERP__c= ra.Resource_ERP__c,resource__c = ra.resource.RelatedRecordId, Service_Order__c= woRec.Id));
                                  system.debug('tss3'+new FSL_Timesheet__c(StartTime__c=ra.start, endTime__c=ra.end, recordtypeid=recordTypeId , Resource_Absence__c = ra.Id,Billing_Type__c	= ra.Billing_Type__c,
                                    Resource_ERP__c	= ra.Resource_ERP__c, resource__c = ra.resource.RelatedRecordId, Service_Order__c=woRec.Id));

                            } // added Resource_Absence__c = ra.Id this in the query by Ravi as per Us-201
                        }
                    }//for a day range absence
                    else
                        tss.add(new FSL_Timesheet__c(StartTime__c=ra.start, endTime__c=ra.end, recordtypeid=recordTypeId , Resource_Absence__c = ra.Id,Billing_Type__c	= ra.Billing_Type__c,
                              Resource_ERP__c= ra.Resource_ERP__c,resource__c = ra.resource.RelatedRecordId, Service_Order__c= woRec.Id));
                      system.debug('tss4'+new FSL_Timesheet__c(StartTime__c=ra.start, endTime__c=ra.end, recordtypeid=recordTypeId , Resource_Absence__c = ra.Id,Billing_Type__c	= ra.Billing_Type__c,
                                    Resource_ERP__c	= ra.Resource_ERP__c, resource__c = ra.resource.RelatedRecordId, Service_Order__c=woRec.Id));

                }
                
            }
            //inserts the timesheet
            if (tss.size() > 0) {
                system.debug('tss' + tss.size());
                system.debug('tss' + tss);
                Database.SaveResult[] saveRes = database.insert(tss, false);
                for (Database.SaveResult sr: saveRes) {
                    if (!sr.isSuccess()) {
                        System.debug('Inserting returned the following errors.');
                        for (Database.Error e: sr.getErrors()) {
                            System.debug(e.getMessage());
                        }
                    }
                }
            }
        }catch(system.exception e){
             System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }       
    
    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }    
}