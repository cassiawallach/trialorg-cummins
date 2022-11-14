/* Created by - VINOD YELALA
* Date        - 10.8.2020
* Description - Create timesheet entries for the resource absences records that stars in FSL_AbsenceRangeforTimesheets (Custom label) no# of days. test 
* Test Class  - FSL_RecordTimesheetEntriesForAbsences_Test
* JIRA NO      - CT2-8
*/
public class FSL_CreateAbsenceRecordCls {
    @AuraEnabled
    public static List<DateTime> getOperatingHrs(){
        //DateTime dt;
        User usr = [select FSL_Primary_Service_Territory_Code__c from User where id=: UserInfo.getUserId() limit 1];
        List<DateTime> dates = new List<DateTime>();
        if(String.isNotBlank(usr.FSL_Primary_Service_Territory_Code__c))
        {
            ServiceTerritory st = [select operatinghoursId from serviceTerritory where FSL_Service_Territory_Code__c=:usr.FSL_Primary_Service_Territory_Code__c limit 1];
            List<TimeSlot> tempTSs = [select starttime, endTime from timeslot where operatinghoursId =:st.operatinghoursID limit 1];
                                      //and DayOfWeek = :System.now().format('EEEE') limit 1];
            if(tempTSs <> null && !tempTSs.isEmpty()){
                TimeSlot tempTS = tempTSs[0];
                dates.add(DateTime.newInstance(System.today().year(), System.today().month(), System.today().day(),tempTS.startTime.hour(), tempTS.startTime.minute(), tempTS.startTime.second()));//DateTime.newInstance(2006, 3, 16, 12, 6, 13);
                dates.add(DateTime.newInstance(System.today().year(), System.today().month(), System.today().day(),tempTS.endTime.hour(), tempTS.endTime.minute(), tempTS.endTime.second()));//DateTime.newInstance(2006, 3, 16, 12, 6, 13);
            }
            
        }
        return dates;//dt;
    }
    
    @AuraEnabled
    public static string insertAbsenceRec(String recStr, String startDate, String endDate, String isAllDayStr){
        try{
            Boolean isAllDay= false;
            system.debug('recstr from lwx::'+recStr+'startDate::'+startDate+'::endDate::'+endDate+'::isAllDay::'+isAllDayStr);
            Datetime startDT, endDT;
            ResourceAbsence ra  = (ResourceAbsence)JSON.deserialize(recStr, ResourceAbsence.Class);
            if(isAllDayStr == 'true'){
                if(startDate <> null)
                {
                    Date dToday = date.valueOf(startDate);
                    startDT= datetime.newInstance(dToday.year(), dToday.month(),dToday.day());
                } 
                if(endDate <> null)
                {
                    Date dToday = date.valueOf(endDate);
                    endDT= datetime.newInstance(dToday.year(), dToday.month(),dToday.day());
                } 
                ra.start  =startDT;
                ra.end = endDT;
                if(ra.start > ra.End)
                    return 'Start time can not be later than End time';
            }
            insert ra;
            return ra.id;
        }
        catch(System.Exception e){
            return 'Failed';
        }
    }
    
    @AuraEnabled
    public string defaultRecordTypeId {get; set;}
    @AuraEnabled
    public Map<Id, String> resAbsenceRecordTypes {get; set;}
     
    @AuraEnabled       
    public static FSL_CreateAbsenceRecordCls getRecordTypeValues(){
        FSL_CreateAbsenceRecordCls obj = new FSL_CreateAbsenceRecordCls();
        Map<Id, String> recordtypeMap = new Map<Id, String>();
        //Get all record types of ResourceAbsence object
        List<Schema.RecordTypeInfo> recordTypeInfoList = ResourceAbsence.SObjectType.getDescribe().getRecordTypeInfos();
        for(RecordTypeInfo info: recordTypeInfoList) {
            //Check record type is available for current user profile
            if(info.isAvailable()) {
                //Check master record type
                if(info.getName() != 'Master' && info.getName().trim() != ''){
                    recordtypeMap.put(info.getRecordTypeId(), info.getName());
                }
                //Get the default record type for current user profile
                if(info.isDefaultRecordTypeMapping()){
                    obj.defaultRecordTypeId = info.getRecordTypeId();
                }
            }
        }    
        obj.resAbsenceRecordTypes = recordtypeMap;
        return obj;
    }

}