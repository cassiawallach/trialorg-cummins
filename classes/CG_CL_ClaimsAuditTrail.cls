/***********************************************************************
Name:CG_CL_ClaimsAuditTrail
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this class for Audit functionality for  Claims .
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                          DATE                DETAIL                                 
1.0 -    Rajesh Pasupuleti               04/16/2018           INITIAL DEVELOPMENT
1.1 -    Rajesh Pasupuleti               06/06/2018   Added code for getting Data from Claim Submission History Object
************************************************************************/
public class CG_CL_ClaimsAuditTrail
{   
    public list<cHistoriesFinal> last_hist1 {get;set;}
    public String jobId{get; set;}
    public String claimsid{get; set;}
    public String claimSubsId{get; set;}
    public String claimsNumber{get; set;}
    public Date creditDate{get; set;}
    public Boolean IsDealerClaim{get;set;}
    public Boolean isDealer;
    public string psnids {
        get;
        set {
            psnids = value;
            system.debug('inside psnids get set');
            //last_hist1 = getHistories(); //Commented as part of the defect # 191405 and added in Constructor
        }
    }
    public string JobIds;
    public string cpid;
    public string csid{get; set;}
    public string Cid{get;set;}
    public CSS_Claims__c claimsRec{get;set;}
    @Testvisible string strField;
    public CG_CL_ClaimsAuditTrail()
    {
        IsDealerClaim=false;
        if(ApexPages.CurrentPage().getParameters().get('id')!=NULL && ApexPages.CurrentPage().getParameters().get('id')!=''){
            Cid=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('cId****'+cId);
         if(cId != null)
        {
            claimsRec = [Select id,Status__c,Actual_Technician_Time__c,Pending_Authorization__c,IsDealerCreatedClaim__c  FROM CSS_Claims__c WHERE Id = :cId LIMIT 1];
        }
            if(ApexPages.CurrentPage().getParameters().size() > 1)
                cpid = ApexPages.CurrentPage().getParameters().get('psnid');
                JobIds = ApexPages.CurrentPage().getParameters().get('jobordID');
                csid = ApexPages.CurrentPage().getParameters().get('claSubmId');
        }
        if(claimsRec != null && claimsRec.IsDealerCreatedClaim__c == true){
            IsDealerClaim = true;
        }
        else{
            IsDealerClaim = false;
        }
        
        isDealer = false;
        string userType = css_Utility.getOrgType(userinfo.getUserId());
        if(userType!=null && userType!= '') {
            if(userType!=null && userType!= '') {
                if(userType == 'DLR') {
                    isDealer = true;
                }else if(userType == 'DISTR') {
                    isDealer = false;
                }
            } 

        }
        last_hist1 = getHistories(); //Added as part of the defect # 191405
    } 

    /************************* Below Method we are calling from Cg_ClaimsPopupAuditTrail Page ***************************************/

    public list<cHistoriesFinal> getHistories()
    {    
        system.debug('inside getHistories');
        // Initialize list to be returned
        list<cHistories> list_ch = new list<cHistories>();
        CSS_Claims__c css = [select id,Rejection_Comments__c from CSS_Claims__c where id=:Cid Limit 1];
        /*
        Map<Id, User> userMap = new MAP<Id, User>();
        list<user> UsersList = new list<user>();
        UsersList = css_Utility.getUserRecords();
        for(User usr : UsersList){
            if(!userMap.containskey(usr.Id)){
                userMap.put(usr.Id,usr);
            }
        }
        */
        /********************* Starting Code for printing the Field Values from service job history object. *******************************/
        if(JobIds != null && JobIds !=''){
            list<css_job_order__history> cssJobOrderHistoryList = new list<css_job_order__history>();
            cssJobOrderHistoryList = [select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name 
                                             From css_job_order__history 
                                             where parentId = :jobIds Order by CreatedDate desc];
            set<Id> UserIdset = new set<Id>();
            map<Id, string> FedIdMap = new map<Id, string>();
            for (css_job_order__history jh: cssJobOrderHistoryList) {
                UserIdset.add(jh.CreatedById);
            }
            
            if(UserIdset != null && UserIdset.size() >0) {
                List<user> userObject = [Select Id, FederationIdentifier from user where Id IN : UserIdset];
                for(user us : userObject)
                    FedIdMap.put(us.Id, us.FederationIdentifier);
            }
            
            for (css_job_order__history jh: cssJobOrderHistoryList) {
                Boolean show=true;
                cHistories ch = new cHistories();
                //User u = new User();
                //if(userMap != null)
                    //u = userMap.get(jh.CreatedById);
                system.debug('---->jobHisRec.createddate-->'+jh.createddate);
                ch.theDate = jh.createddate;//
                system.debug('---->ch.theDate-->'+ch.theDate);
                //ch.wwid = u.FederationIdentifier;
                if(FedIdMap != null && FedIdMap.size() > 0)
                    ch.wwid = FedIdMap.get(jh.CreatedById);
                    
                ch.who = jh.createdby.name;
                if (String.valueOf(jh.Field) == 'created'){    
                    ch.action = 'Created.';
                } 
                else if (jh.OldValue != null && jh.NewValue == null)
                { // when deleting a value from a field
                    // Format the Date and if there's an error, catch it and re
                    try {
                        String fromText = 'Blank';    
                        fromText = Date.valueOf(jh.OldValue).format();
                        system.debug('**fromText **'+fromText );
                        String toText = '';
                        toText = Date.valueOf(jh.NewValue).format();
                        system.debug('**toText **'+toText );
                        strField=String.valueOf(jh.Field);
                        strField=strField.replace('__c', '');

                        //Checking if value starts with 005 or not
                        if(strField=='Assigned_To' || strField=='Additional_Tech1' || strField=='Additional_Tech2'){
                            if((fromText.startsWith('005')))
                                show=false; 
                            if(toText!=null){ 
                                if(toText.startsWith('005'))   
                                    show=false;
                            } 
                        }
                        ch.action = 'Deleted ' + '<b>' + String.valueOf(jh.OldValue) + '</b>' + ' in <b>' + strField  + '</b>.';
                    }
                    catch (Exception e){

                        strField=String.valueOf(jh.Field);
                        strField=strField.replace('__c', '');
                        //Checking if value starts with 005 or not
                        if((strField=='Assigned_To' || strField=='Additional_Tech1' || strField=='Additional_Tech2') && (String.valueOf(jh.OldValue).startsWith('005')))                   
                        {
                            show=false; 
                        }  

                        else {
                            ch.action = 'Deleted ' +'<b>'+ String.valueOf(jh.OldValue)+'</b>' + ' in <b>' + strField  + '</b>.'; 
                        }

                    }
                } 
                else 
                {             // all other scenarios
                    String fromText = 'Blank';
                    if (jh.OldValue != null) 
                    {
                        try {
                            fromText = Date.valueOf(jh.OldValue).format();
                            system.debug('**fromText **'+fromText );
                        } 
                        catch (Exception e) {
                            fromText = String.valueOf(jh.OldValue);
                            system.debug('**fromTextCatch **'+fromText );
                        }
                    }
                    String toText = '';
                    try {
                        toText = Date.valueOf(jh.NewValue).format();
                        system.debug('**toText **'+toText );
                    } 
                    catch (Exception e) 
                    {
                        toText = String.valueOf(jh.NewValue);
                        system.debug('**toTextcatch **'+toText );
                    }

                    strField=String.valueOf(jh.Field);
                    strField=strField.replace('__c', '');

                    //Checking if value starts with 005 or not
                    if(strField=='Assigned_To' || strField=='Additional_Tech1' || strField=='Additional_Tech2'){
                        if((fromText.startsWith('005')))
                            show=false; 
                        if(toText!=null){ 
                            if(toText.startsWith('005'))   
                                show=false;
                        } 
                    } 
                    if(toText == null || toText == '')
                        toText = 'Blank';
         //Added below code as per Defect #152566, -By RAJESH 28th June 2018       
                    if(strField == 'ESN' )
                        strField = 'PSN';
                    if(strField == 'ESN_Insite' )
                        strField = 'PSN_Insite';
                    ch.action = 'Changed <b>' + strField + '</b>' + ' from <b>' + fromText  + '</b>' + ' to <b>' + toText + '</b>.';

                }    
                if(show)
                    list_ch.add(ch);            

            }
        }
        /************************************************* End sservice job History Code ***************************************************/
        /********************* Starting Code for printing the Field Values from custom job history object. *******************************/
        system.debug('JobIds>>>>>'+JobIds);
        
        List<CSS_JobHistory__c> jobHistoryList = new List<CSS_JobHistory__c>();
        List<CSS_JobHistory__c> claimHistoryList = new List<CSS_JobHistory__c>();
        if(jobIds !=null && jobIds !=''){  
         jobHistoryList = [Select Id,CreatedDate,Audit_Message__c,createdby.name,CSS_Job_Id__c,CSS_New_Value__c,CSS_Old_Value__c,CSS_Field_Name__c, System_Modified__c
                                                      from CSS_JobHistory__c
                                                      where CSS_Job_Id__c=:jobIds Order by CreatedDate desc];}
        if(cId!= null && cId != ''){
            claimHistoryList = [Select Id,CreatedDate,Audit_Message__c,createdby.name,CSS_Job_Id__c,CSS_New_Value__c,CSS_Old_Value__c,CSS_Field_Name__c, System_Modified__c
                                                      from CSS_JobHistory__c
                                                      where CSS_Job_Id__c=:cId Order by CreatedDate desc];
                    jobHistoryList.addAll(claimHistoryList);
        }
        
            system.debug('---->jobHistoryList->'+jobHistoryList.size()+jobHistoryList);
            
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
            
            if(jobHistoryList != null && !jobHistoryList.isEmpty()){
                for(CSS_JobHistory__c jobHisRec : jobHistoryList){
                    //User u = new User();
                    //if(userMap != null)
                        //u = userMap.get(jobHisRec.CreatedById);
                    cHistories ch = new cHistories();
                    //ch.wwid = u.FederationIdentifier;
                    if(FedIdMap != null && FedIdMap.size() > 0)
                        ch.wwid = FedIdMap.get(jobHisRec.CreatedById);
                        
                    ch.sysModified = jobHisRec.System_Modified__c;
                    system.debug('---->jobHisRec.createddate-->'+jobHisRec.createddate);
                    ch.theDate = jobHisRec.createddate;//
                    system.debug('---->ch.theDate-->'+ch.theDate);
                    system.debug('jobHisRec.Audit_Message__c-->'+jobHisRec.Audit_Message__c);
                    if((jobHisRec.Audit_Message__c != null && jobHisRec.Audit_Message__c.contains('Paycode')) ||
                    (jobHisRec.System_Modified__c == true)){
                        ch.who='System';
                    }
                    else{
                        ch.who = jobHisRec.createdby.name;
                    }
                    if(jobHisRec.Audit_Message__c == null || jobHisRec.Audit_Message__c == ''){ 
                        // Set the Action value
                        String fromText = 'Blank';
                        String OldValue = 'Blank';
                        String NewValue = 'Blank';
                        OldValue = (String.valueOf(jobHisRec.CSS_Old_Value__c) == null ? 'Blank' : String.valueOf(jobHisRec.CSS_Old_Value__c));
                        NewValue = String.valueOf(jobHisRec.CSS_New_Value__c);
                        fromText = String.valueOf(jobHisRec.CSS_New_Value__c); 
                        if (jobHisRec.CSS_Old_Value__c=='Added' && jobHisRec.CSS_Old_Value__c != null){    // on Creation
                            ch.action = 'Added Attachment <b>'  + fromText + '</b>.';
                        }
                        else if (jobHisRec.CSS_Old_Value__c != null && jobHisRec.CSS_Old_Value__c == 'Deleted'){ 
                            ch.action = 'Deleted  Attachment <b>'  + fromText + '</b>.';
                        }   
                        //Rajesh Added code  for JSA Audit Trail
                        else if (jobHisRec.CSS_Old_Value__c=='Added JSA form' && jobHisRec.CSS_Old_Value__c != null){    // on Creation
                            ch.action = 'Added JSAForm <b> '  + fromText + '</b>.';
                        }
                        // DSID Owner tracking: Sai 3/22 for Q1 UAT Defect
                        else if(jobHisRec.CSS_Field_Name__c=='DSID_Owner__c'){
                            ch.action = 'Changed <b> DSID owner </b> from ' + '<b>' + OldValue + '</b>' + ' to ' + '<b>' + NewValue + '</b>.';
                        }
                        // End of DSID Owner Track.
                        // VIN Audit, only If it is changed manually by user: Sai 4/11/2017 for CUBS story # 88616
                        else if(jobHisRec.CSS_Field_Name__c=='VIN__c'){
                            ch.action = 'Changed <b> VIN </b> from ' + '<b>' + OldValue + '</b>' + ' to ' + '<b>' + NewValue + '</b>.';
                        }
                        // End of VIN Audit
                        // Sub Status AuditSub_Status__c
                        else if(jobHisRec.CSS_Field_Name__c=='Sub_Status__c'){
                            ch.action = 'Changed <b> Sub Status </b> from ' + '<b>' + OldValue + '</b>' + ' to ' + '<b>' + NewValue + '</b>.';
                        }
                        else if(jobHisRec.CSS_Field_Name__c=='JobLocation__c'){
                            ch.action = 'Changed <b> Location </b> from ' + '<b>' + OldValue + '</b>' + ' to ' + '<b>' + NewValue + '</b>.';
                        }
                        if(jobHisRec.CSS_Field_Name__c=='Additional_Tech3__c' || jobHisRec.CSS_Field_Name__c=='Additional_Tech4__c' || jobHisRec.CSS_Field_Name__c=='Additional_Tech5__c' || jobHisRec.CSS_Field_Name__c=='Additional_Tech6__c' || jobHisRec.CSS_Field_Name__c=='Additional_Tech7__c' || jobHisRec.CSS_Field_Name__c=='Additional_Tech8__c' || jobHisRec.CSS_Field_Name__c=='Additional_Tech9__c'){
                            ch.action = 'Changed <b>' + jobHisRec.CSS_Field_Name__c + '</b>' + ' from '  + '<b>' + OldValue + '</b>' + ' to ' + '<b>' + NewValue + '</b>.';
    
                        }
                        if((jobHisRec.CSS_New_Value__c == null || jobHisRec.CSS_New_Value__c == '' ) && (jobHisRec.CSS_Old_Value__c !=''||jobHisRec.CSS_Old_Value__c !=null)){
                            ch.action = 'Deleted ' + '<b>' + OldValue + '</b>' + ' in <b>' + jobHisRec.CSS_Field_Name__c  + '</b>.';
    
                        }
                    }
                    else{
                        if((IsDealerClaim == false) || (IsDealerClaim == true && jobHisRec.Audit_Message__c != null && !(jobHisRec.Audit_Message__c.contains('Paycode'))) || (IsDealerClaim == true && jobHisRec.Audit_Message__c != null && jobHisRec.Audit_Message__c.contains('Paycode') &&  isDealer == false)){
                            system.debug('***insideIf1AuditMsgPaycode');
                            ch.action = jobHisRec.Audit_Message__c;
                        }
                        else{
                            system.debug('***insideelse1AuditMsgPaycode');
                            continue;
                        }
                    }
                    if(ch.action != null && ch.action != '')
                        list_ch.add(ch);
                }
            }        
        /************************************************* End custom job History Code ***************************************************/
        list_ch.sort();
        list<cHistories> list_ch3 = new list<cHistories>();
        List<cHistoriesFinal> finalResult = new List<cHistoriesFinal>();
        for(Integer i = list_ch.size() - 1; i >= 0; i--){
            cHistoriesFinal finalTemp = new cHistoriesFinal();
            String locale_formatted_date_time_value = css_utility.getFormattedDate(list_ch[i].theDate);
            locale_formatted_date_time_value = locale_formatted_date_time_value.toUpperCase();
            finalTemp.dteFinal = locale_formatted_date_time_value;
            finalTemp.NameFinal = list_ch[i].who;
            finalTemp.actFinal = list_ch[i].action;
            finalTemp.wwidFinal = list_ch[i].wwid;
            if((list_ch[i].action != null && list_ch[i].action.containsignorecase('paycode')) || list_ch[i].sysModified == true){
                finalTemp.NameFinal = '<b> System </b>';
                finalTemp.wwidFinal = '';
            }
            finalTemp.actFinal = (finalTemp.actFinal).replace('ESN', 'PSN');
            list_ch3.add(list_ch[i]);
            finalResult.add(finalTemp);
            system.debug('temp-->'+finalTemp);
        }
        //system.debug('*Rajesh+list_ch3***'+list_ch3);
        return finalResult;
    }
    public class cHistories  implements Comparable{
        public DateTime theDate {get; set;}
        public String who {get; set;}
        public String action {get; set;}
        public String wwid {get; set;}
        public Boolean sysModified{get; set;}
        private cHistories cHist;
        public cHistories(){}
        public cHistories(DateTime dte,String Name, String act, String wid, Boolean sysModified) {
            theDate = dte;
            who = Name;
            action = act;
            wwid = wid;
            sysModified = sysModified;
        }
        public integer compareTo(Object ObjToCompare) {
            cHistories cHistWrapper = (cHistories) ObjToCompare;
            if (cHistWrapper.theDate < this.theDate) return +1;
            if (cHistWrapper.theDate > this.theDate) return -1;
            return 0;
        }

    }
    public class cHistoriesFinal{
        public String dteFinal{get;set;}
        public String NameFinal{get;set;}
        public String actFinal{get;set;}
        public string wwidFinal{get;set;}
    }
}