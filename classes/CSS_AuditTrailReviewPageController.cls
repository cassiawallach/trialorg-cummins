/*Name:CSS_AuditTrailReviewPageController
Copyright Â© 2019  Cummins
===============================================================================
===============================================================================
Purpose:                                                            
-------  
We are using this display audit trail records for custom history object.
===============================================================================
===============================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                DETAIL  
1.0 -       Prabhakar           12/16/2019     Added code as part of story GSSC-444
***********************************************************************************/
public class CSS_AuditTrailReviewPageController
{
    public list<cHistories> last_hist1 {get;set;}
    public string jobid{get;set;}
    public CSS_AuditTrailReviewPageController()
    {
     jobid = ApexPages.CurrentPage().getParameters().get('id');
        system.debug('jobid<><>'+jobid);
    }
     public Id vMore_JobId {
        get;
        set {
            vMore_JobId = value;
            last_hist1 = getOneHistory(vMore_JobId);           
        }
    }
     public list<cHistories> getOneHistory(Id JID){
     list<cHistories> list_ch2 = new list<cHistories>();
    // return list_ch2;
         return null;
     }
    public list<cHistories> getHistories(){


        list<cHistories> list_ch = new list<cHistories>();
        List<CSS_JobHistory__c> jobHistoryList = new List<CSS_JobHistory__c>();
        //Query jobhistoryobject with jobid
        jobHistoryList = [Select Id,CreatedDate,Audit_Message__c,TechnicianNotes__c,createdby.name,CSS_Job_Id__c,CSS_New_Value__c,CSS_Old_Value__c,CSS_Field_Name__c, System_Modified__c
                          from CSS_JobHistory__c
                          where CSS_Job_Id__c=:jobid Order by CreatedDate desc];
        system.debug('jobHistoryList'+jobHistoryList.size());
        set<Id> UserIdset = new set<Id>();
        map<Id, string> FedIdMap = new map<Id, string>();
        if(jobHistoryList != null && jobHistoryList.size() >0) {
            for(CSS_JobHistory__c jobHisRec : jobHistoryList)
                UserIdset.add(jobHisRec.CreatedById);
        }

        if(UserIdset != null && UserIdset.size() >0) {
            List<user> userObject = [Select Id, FederationIdentifier from user where Id IN : UserIdset];
            for(user us : userObject)
                FedIdMap.put(us.Id, us.FederationIdentifier);
        }
        //Looping the all history records
        if(jobHistoryList != null && !jobHistoryList.isEmpty()){
            for(CSS_JobHistory__c jobHisRec : jobHistoryList){
                cHistories ch = new cHistories();
                // if(FedIdMap != null && FedIdMap.size() > 0)
                       // ch.who = FedIdMap.get(jobHisRec.CreatedById);
                ch.who = jobHisRec.createdby.name;
                ch.technotes = jobHisRec.TechnicianNotes__c;
                ch.theDate = String.valueOf(jobHisRec.createddate);
                if(jobHisRec.Audit_Message__c != null){
                    system.debug('***insideaction');
                    ch.action = jobHisRec.Audit_Message__c;
                    system.debug('***ch.action'+ch.action);
                }
                 if(ch.action != null && ch.action != '')
                        list_ch.add(ch);
            }
        }
       // list_ch.sort();
         List<cHistories> finalResult = new List<cHistories>();
        finalResult.addall(list_ch);
        
        //return list_ch2;
        return finalResult;
    }
    
    public class cHistories  implements Comparable{
        public String theDate {get; set;}
        public String who {get; set;}
        public String action {get; set;}
        public String technotes {get; set;}
        public cHistories(){}
        public cHistories(String dte,String Name, String act, String technts) {
            theDate = dte;
            who = Name;
            action = act;
            technotes = technts;
        }
        public Integer compareTo(Object ObjToCompare) {
            // cHistories compareToHis = (cHistories)compareTo;
            return theDate.CompareTo(((cHistories)ObjToCompare).theDate);
        }
       

    }
}