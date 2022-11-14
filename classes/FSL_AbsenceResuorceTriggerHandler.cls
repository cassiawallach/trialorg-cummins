/* Created by - VINOD YELALA
* Date      - 10.8.2020
* Description - Create timesheet entries for the resource absences records that stars in FSL_AbsenceRangeforTimesheets (Custom label) no# of days.
                Created to get the Servie resuorce based on the service territory code and get the operationg hours from the time slots and assign those time slots in the vacation
                Time sheet records
* Test Class  - FSL_RecordTimesheetEntriesForAbsences_Test
// Added by VY
* JIRA NO     - CT2-8
*/

public class FSL_AbsenceResuorceTriggerHandler {
    public static void beforeInsert(List<ResourceAbsence> newList){
        Id recordTypeId = Schema.SObjectType.ResourceAbsence.getRecordTypeInfosByDeveloperName().get('All_Day').getRecordTypeId();
        Set<Id> resourceIds = new Set<Id>();
        List<ResourceAbsence> allDayRsrcs = new List<ResourceAbsence>();
        Map<Id, String> userTerrCode = new Map<Id, String>();
        Map<String, Id> serTerrOpHrs = new Map<String, Id>();
        Map<Id, Map<String, TimeSlot>> opHrsSlots = new Map<Id, Map<String, TimeSlot>>();
        //collect all resource ids
        for(ResourceAbsence ra : newList){
            if(recordTypeId == ra.RecordTypeId){
                resourceIds.add(ra.ResourceId);
                allDayRsrcs.add(ra);
            }
        }
        if(!resourceIds.isEmpty()){
            //read the service territory codes belong to above resoruces from the user record
            for(ServiceResource sr : [select User__r.FSL_Primary_Service_Territory_Code__c, id from ServiceResource where id in:resourceIds AND 
                                      User__r.FSL_Primary_Service_Territory_Code__c <> NULL AND User__r.FSL_Primary_Service_Territory_Code__c<> ''])
            {
                userTerrCode.put(sr.id, sr.User__r.FSL_Primary_Service_Territory_Code__c);
            }
            if(!userTerrCode.isEmpty()){
                //read the service territory code with operation hours id
                for(ServiceTerritory st : [select id, OperatingHoursId, FSL_Service_Territory_Code__c from ServiceTerritory where FSL_Service_Territory_Code__c IN :userTerrCode.values()]){
                    serTerrOpHrs.put(st.FSL_Service_Territory_Code__c, st.OperatingHoursId);
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
            TimeSlot tempTS;
            system.debug('userTerrCode::'+userTerrCode);
            system.debug('serTerrOpHrs::'+serTerrOpHrs);
            system.debug('opHrsSlots::'+opHrsSlots);
            //system.debug('serTerrOpHrs::'+serTerrOpHrs);
            for(ResourceAbsence ra : allDayRsrcs){
                if(userTerrCode.containsKey(ra.ResourceId) && serTerrOpHrs.containsKey(userTerrCode.get(ra.ResourceId)) && opHrsSlots.containsKey(serTerrOpHrs.get(userTerrCode.get(ra.ResourceId)))){
                    Map<String, TimeSlot> tss = opHrsSlots.get(serTerrOpHrs.get(userTerrCode.get(ra.ResourceId)));
                    system.debug('BEFORE>>>>ra start and end::'+ra.start+'&&&end::'+ra.End);
                    weekDay = ra.Start.format('EEEE');
                    tempTS = tss.get(weekDay);//move this statement out of if - by vinod 12.8
                    if(tempTS <> null)
                    {
                        //tempTS = tss.get(weekDay);--commented by vinod 12.8 to move out of above if 
                        system.debug('start hrs::'+tempTS.startTime.hour());
                        //Datetime dtt = Date.valueOf(String.valueOf());
                        //ra.start = ra.Start.addHours(tempTS.startTime.hour()); 
                        ra.start = DateTime.newInstance(ra.start.year(), ra.start.month(), ra.start.day(),tempTS.startTime.hour(), tempTS.startTime.minute(), tempTS.startTime.second());//DateTime.newInstance(2006, 3, 16, 12, 6, 13);
                    }
                    else
                        ra.start = DateTime.newInstance(ra.start.year(), ra.start.month(), ra.start.day(),23, 59, 59);
                    weekDay = ra.End.format('EEEE'); 
                    tempTS = tss.get(weekDay);
                    if(tempTS <> null)
                    {
                        system.debug('end hrs::'+tempTS.endTime.hour());
                        //ra.end = ra.End.addHours(tempTS.endTime.hour());
                        ra.end = DateTime.newInstance(ra.end.year(), ra.end.month(), ra.end.day(),tempTS.endTime.hour(), tempTS.endTime.minute(), tempTS.endTime.second());
                    }
                    else
                        ra.end = DateTime.newInstance(ra.end.year(), ra.end.month(), ra.end.day(),23, 59, 59);
                    system.debug('AFTER>>>>ra start and end::'+ra.start+'&&&end::'+ra.End);
                }
                //Default colour 
                ra.FSL__Gantt_Color__c='#d8dde6';
            }
        }
    }
    /*public static void afterInsert(Map<Id, ResourceAbsence> newMap){

}
public static void beforeUpdate(Map<Id, ResourceAbsence> newMap, Map<Id, ResourceAbsence> oldMap){

}
public static void afterUpdate(Map<Id, ResourceAbsence> newMap, Map<Id, ResourceAbsence> oldMap){

}*/
     public static void afterresourceDelete(map<id,ResourceAbsence> mapoldResource){ //Added by ravi for CT2-201
         list<FSL_Timesheet__c> lstTimesheet = new list<FSL_Timesheet__c>();
         set<id> setOldresid = new set<id>();
         setOldresid.addall(mapoldResource.keyset());
         
          if(setOldresid != null && setOldresid.size() > 0){
          for(FSL_Timesheet__c objTimeSheet : [select id,Status__c,Resource_Absence__c from FSL_Timesheet__c  where Resource_Absence__c in : setOldresid]){
                 objTimeSheet.Status__c = 'Invalid';
                 lstTimesheet.add(objTimeSheet);
            }      
                 system.debug('check list'+lstTimesheet);
                 if( lstTimesheet != Null){
                         update lstTimesheet;
                 }
       }
       }
       }