public class CSS_ServiceJobTriggerHelper {    
    css_header_nav__c CS = css_header_nav__c.getInstance(UserInfo.getProfileId());

    public void shareParentAccountUsers(Map<Id,Id> mapAcntusrForParIds,CSS_Job_Order__c[] trigNew){
        // Sharing for Parent Account Contacts - Begins
        List<user>usList = new List<user>();
        List<user>usActList = new List<user>();
        List<CSS_Job_Order__share> jobOrderList = new List<CSS_Job_Order__share>(); 
        Map<Id,Id> mapAccntParnetId = new Map<Id,Id>();
        Map<Id,List<User>> mapParntIdUsers = new Map<Id,List<User>>();
        Map<Id,List<Id>> mapAccountUsers = new Map<Id,List<Id>>();
        List<Id> accTeamUserID = new List<Id>(); 


        //Retrieve Parent Account ID to determine Hierarchy
        for (Account Acc: [Select parentid,Id from account where id=:mapAcntusrForParIds.values()])
        {
            mapAccntParnetId.put(Acc.Id,Acc.parentId);
        }
        /* Providing read permissions for the JobOrder to the contact users linked to the parent account */
        if(mapAccntParnetId.size()>0)
        {            
            usList = [SELECT id,AccountId from User WHERE isActive = true and contactid IN ( select Id from Contact where AccountId in :mapAccntParnetId.values())];
            for(User us: usList){
                if(mapParntIdUsers.containsKey(us.AccountId))
                    mapParntIdUsers.get(us.AccountId).add(us);
                else{
                    List<User> neUsers = new List<User>();
                    neUsers.add(us);
                    mapParntIdUsers.put(us.AccountId,neUsers);
                }
            }
            for(CSS_Job_Order__c jobOrd : trigNew) 
            {
                if(mapAcntusrForParIds.containsKey(jobOrd.OwnerId)){
                    Id accountId = mapAcntusrForParIds.get(jobOrd.OwnerId);
                    if(mapAccntParnetId.containsKey(accountId)){
                        Id parentId = mapAccntParnetId.get(accountId);
                        if(mapParntIdUsers.containsKey(parentId)){
                            List<User> usersToShare = mapParntIdUsers.get(parentId);
                            List<CSS_Job_Order__share> jobstoShare = grantShareServJobs(usersToShare,jobOrd,Schema.CSS_Job_Order__share.RowCause.Account_Hierarchy__c);
                            jobOrderList.addAll(jobstoShare);                                 
                        }
                    }
                }
            }
            //system.debug (jobOrderList);
        }
        //Retrieve Account Team based on Owner's Account/Dealer based on Cross-Org Hierarchy
        for (AccountTeamMember Actm: [Select UserId,AccountId from AccountTeamMember where AccountId=:mapAccntParnetId.keySet() and TeamMemberRole = 'HQ Oversight']){            
            if(mapAccountUsers.containsKey(Actm.AccountId))
                mapAccountUsers.get(Actm.AccountId).add(Actm.UserId);
            else{
                List<Id> users = new List<Id>();
                users.add(Actm.UserId);
                mapAccountUsers.put(Actm.AccountId,users);
            }
        }            
        if (mapAccountUsers.size()>0)
        {
            // usActList = [SELECT id,AccountId from User WHERE id = :mapAccountUsers.values()];

            for(CSS_Job_Order__c jobOrd : trigNew) 
            {
                Id accountId = mapAcntusrForParIds.get(jobOrd.OwnerId);
                if(mapAccountUsers.containsKey(accountId)){
                    List<Id> usersToShare = mapAccountUsers.get(accountId);
                    List<CSS_Job_Order__share> jobstoShare = grantShareServJobs(usersToShare,jobOrd,Schema.CSS_Job_Order__share.RowCause.Cross_Org_Visibility__c);
                    jobOrderList.addAll(jobstoShare);                                 
                }
            }    
        }
        //Insert Record in Service Job Share object if either of the conditions turned out to be true.
        //system.debug ('before insert');    
        if (trigger.isInsert && !jobOrderList.isEmpty())
            insert jobOrderList;
        // Sharing for Parent Account Contacts - Ends
    }
    /*  public void shareDealerJobs(List<User> sameLocAccntUsers,Map<Id,Id> usersAccounts,CSS_Job_Order__c[] trigNew){
        List<CSS_Job_Order__share> srvJobShareList = new List<CSS_Job_Order__share>();
        // logic to find out the dealer users with same location and role name contains executive or manager
        map<Id,List<User>> mapAccountusers = new map<Id,List<User>>();
        if(!sameLocAccntUsers.isEmpty() && sameLocAccntUsers.size()>0){
            for(User u:sameLocAccntUsers){
                //if(u.AccountId != null && (u.UserRole.name.toupperCase().contains('EXECUTIVE') || u.UserRole.name.toupperCase().contains('MANAGER'))){
                if(u.AccountId != null && CS.EnablePeersSharing__c){
                    if(mapAccountusers.containsKey(u.AccountId)){
                        mapAccountusers.get(u.AccountId).add(u);
                    }else{
                        List<User> users = new List<User>();
                        users.add(u);
                        mapAccountusers.put(u.AccountId,users);
                    }                    
                }
            }
        }               
        if(mapAccountusers.size()>0){
            for(CSS_Job_Order__c jobOrd : trigNew) 
            {
                // Id Accountid = usersAccounts.get(jobOrd.ownerId);
                Id Accountid = jobOrd.Account__c; //Added this line as part of story 130893
                if(mapAccountusers.containsKey(Accountid)){
                    List<CSS_Job_Order__share> userShare = grantShareServJobs(mapAccountusers.get(Accountid),jobOrd,Schema.CSS_Job_Order__share.RowCause.Dealer_Writer_Supervisor_Same_Location__c);
                    srvJobShareList.addAll(userShare);                    
                }
            }        
        }
        if(srvJobShareList.size()>0)
            insert srvJobShareList;
    } */

    /*  public void shareDistributorJobs(List<User> sameLocUsers,Map<Id,String> usersLocs,CSS_Job_Order__c[] trigNew){
        List<CSS_Job_Order__share> srvJobShareList = new List<CSS_Job_Order__share>();
        // logic to find out the similar users having the profile name as supvisor or writer with same location
        Map<String,List<User>> mapLocUsers = new Map<String,List<User>>();
        if(usersLocs.size()>0){
            //get all the users in same location
            for(User u:sameLocUsers){
                //if(u.profile.name.toupperCase().contains('SUPERVISOR') || u.profile.name.toupperCase().contains('WRITER') || u.profile.name.toupperCase().contains('ADVANCED')){
                //  if(CS.EnablePeersSharing__c && u.profile.name.toupperCase().contains('ADVANCED')){
                if(CS.EnablePeersSharing__c && u.profile.name.contains('CSS_Service_Advanced')){
                    if(mapLocUsers.containsKey(u.User_Location__c)){
                        mapLocUsers.get(u.User_Location__c).add(u);
                    }else{
                        List<User> users = new List<User>();
                        users.add(u);
                        mapLocUsers.put(u.User_Location__c,users);
                    }                    
                }
            }
        }
        if(mapLocUsers.size()>0){
            for(CSS_Job_Order__c jobOrd : trigNew) 
            {
                String userLoc = usersLocs.get(jobOrd.ownerId);
                //Added jobOrd.Account__r.Type == 'Distributor Account' to restrict this sharing rule for dealers and allow only for distributors
                if(mapLocUsers.containsKey(userLoc)){
                    List<CSS_Job_Order__share> userShare = grantShareServJobs(mapLocUsers.get(userLoc),jobOrd,Schema.CSS_Job_Order__share.RowCause.Writer_or_Supervisor_Same_Location__c);
                    srvJobShareList.addAll(userShare);
                }

            }        
        }
        if(srvJobShareList.size()>0)
            insert srvJobShareList;
    } */
    public List<CSS_Job_Order__share> grantShareServJobs(List<User> usersToShare,CSS_Job_Order__c srvJob,String rowCause){
        List<CSS_Job_Order__share> usersShareList = new List<CSS_Job_Order__share>();
        if(!usersToShare.isEmpty() && usersToShare.size()>0)
            for(User u: usersToShare) 
            {
                CSS_Job_Order__share cjo = new CSS_Job_Order__share(); 
                cjo.AccessLevel='Edit';
                cjo.ParentId = srvJob.id;
                cjo.UserOrGroupId = u.Id;
                cjo.RowCause = rowCause;
                usersShareList.add(cjo);
            }   
        return usersShareList;
    }
    public List<CSS_Job_Order__share> grantShareServJobs(List<Id> usersToShare,CSS_Job_Order__c srvJob,String rowCause){
        List<CSS_Job_Order__share> usersShareList = new List<CSS_Job_Order__share>();
        if(!usersToShare.isEmpty() && usersToShare.size()>0)
            for(Id uId: usersToShare) 
            {
                CSS_Job_Order__share cjo = new CSS_Job_Order__share(); 
                cjo.AccessLevel='Edit';
                cjo.ParentId = srvJob.id;
                cjo.UserOrGroupId = uId;
                cjo.RowCause = rowCause;
                usersShareList.add(cjo);
            }   
        return usersShareList;
    }  
    /* This method will call from CSS_locationBasedJobSharing on after update of any user and share all jobs to 
        users which is belongs to user's location. */

    public static void afterUpdateShareJobsToUser(List<User> userList){
        List<CSS_Job_Order__c> jobOrderList = new List<CSS_Job_Order__c>();
        List<CSS_Job_Order__Share> jobShrList   = new List<CSS_Job_Order__Share>();
        Set<String> userLocationsSet = new Set<String>();
        for(user usr:userList){
            if(usr.User_Location__c!=null){
                userLocationsSet.add(usr.User_Location__c);
            }       
        }

        if(userLocationsSet.size() >0){
            jobOrderList = [Select Id,Creator_Location__c FROM CSS_Job_Order__c WHERE CreatedDate <= TODAY AND Creator_Location__c IN :userLocationsSet];
            if(jobOrderList.size()>0){
                system.debug('Update-After jobOrderList '+ jobOrderList);
                for(user usr:userList){
                    for(CSS_Job_Order__c objJob : jobOrderList){
                        if(usr.User_Location__c == objJob.Creator_Location__c){
                            system.debug('Update-After jobOrderList loop'+ objJob.Creator_Location__c);
                            CSS_Job_Order__Share jobShr = new CSS_Job_Order__Share();
                            jobShr.ParentId         = objJob.Id;
                            jobShr.UserOrGroupId    = usr.id;
                            jobShr.AccessLevel = 'Edit';
                            jobShrList.add(jobShr);
                        }
                    }
                } 
                if(jobShrList.size() > 0 && !Test.isRunningtest())
                    insert jobShrList;

            }
        }


    }

    //Method to insert record in job history object for updating 4c's
    public static void updateFourCs(list<CSS_Job_Order__c> lstNewServiceJob,map<id,CSS_Job_Order__c> mapOldServiceJob){
        list<CSS_JobHistory__c> lstjobhistory = new list<CSS_JobHistory__c>();
        CSS_JobHistory__c hist;
        //looping the new list 
        for(CSS_Job_Order__c csj : lstNewServiceJob){

           /* if(csj.EditComplaint__c != mapOldServiceJob.get(csj.id).EditComplaint__c && mapOldServiceJob.get(csj.id).EditComplaint__c != null && mapOldServiceJob.get(csj.id).EditComplaint__c != ''){
                CSS_JobHistory__c compHis = createJobhistoryRecord('CSS_Job_Order__c',csj.id,'EditComplaint__c',mapOldServiceJob.get(csj.id).EditComplaint__c,csj.EditComplaint__c);
                if(compHis != null){
                    lstjobhistory.add(compHis);
                }
            } */
                if(csj.EditComplaint__c != mapOldServiceJob.get(csj.id).EditComplaint__c){
                CSS_JobHistory__c compHis = createJobhistoryRecord('CSS_Job_Order__c',csj.id,'EditComplaint__c',mapOldServiceJob.get(csj.id).EditComplaint__c,csj.EditComplaint__c);
                if(compHis != null){
                    lstjobhistory.add(compHis);
                }
            }
            if(csj.EditCause__c != mapOldServiceJob.get(csj.id).EditCause__c){
                CSS_JobHistory__c causeHis = createJobhistoryRecord('CSS_Job_Order__c',csj.id,'EditCause__c',mapOldServiceJob.get(csj.id).EditCause__c,csj.EditCause__c);  
                if(causeHis != null){
                    lstjobhistory.add(causeHis);
                }
            } 
            if(csj.EditCorrection__c != mapOldServiceJob.get(csj.id).EditCorrection__c){
                CSS_JobHistory__c correctionHis = createJobhistoryRecord('CSS_Job_Order__c',csj.id,'EditCorrection__c',mapOldServiceJob.get(csj.id).EditCorrection__c,csj.EditCorrection__c);  
                if(correctionHis != null){
                    lstjobhistory.add(correctionHis);
                }
            }
            if(csj.EditCoverage__c != mapOldServiceJob.get(csj.id).EditCoverage__c){
                CSS_JobHistory__c coverageHis = createJobhistoryRecord('CSS_Job_Order__c',csj.id,'EditCoverage__c',mapOldServiceJob.get(csj.id).EditCoverage__c,csj.EditCoverage__c);  
                if(coverageHis != null){
                    lstjobhistory.add(coverageHis);
                }
            }

        }

        if(!lstjobhistory.isEmpty()){
            insert lstjobhistory;
        }
    }
    //Rajesh Start
    //Method to insert record in job history object for Assigne's
    public static void insertAssigne(list<CSS_Job_Order__c> lstNewJob,map<id,CSS_Job_Order__c> mapOldJob){
        list<CSS_JobHistory__c> lstjobhistory = new list<CSS_JobHistory__c>();
        // system.debug('Rajesh-lstNewJob-->'+lstNewJob[0].id);
        // system.debug('lstNewJob--->'+lstNewJob);
        //system.debug('mapOldJob--->'+mapOldJob);

        for(CSS_Job_Order__c jobRec : lstNewJob){
            system.debug('jobRec id---'+jobRec.Id);
            system.debug('Tech4 Value--->'+mapOldJob.get(jobRec.id).Add_Tech4__c);
            if((jobRec.Additional_Tech3__c!=null||jobRec.Additional_Tech3__c!='')&&(jobRec.Additional_Tech3__c!= mapOldJob.get(jobRec.id).Additional_Tech3__c)){
                CSS_JobHistory__c Tech3 = createJobhistoryRecord('CSS_Job_Order__c',jobRec.id,'Additional_Tech3__c',mapOldJob.get(jobRec.id).Add_Tech3__c,jobRec.Add_Tech3__c);
                if(Tech3 != null){
                    lstjobhistory.add(Tech3);
                    // system.debug('Rajesh-jobRec.id-->'+jobRec.id);
                }
            }
            if( (jobRec.Additional_Tech4__c!=null||jobRec.Additional_Tech4__c!='')&&(jobRec.Additional_Tech4__c!= mapOldJob.get(jobRec.id).Additional_Tech4__c)){
                CSS_JobHistory__c Tech4 = createJobhistoryRecord('CSS_Job_Order__c',jobRec.id,'Additional_Tech4__c',mapOldJob.get(jobRec.id).Add_Tech4__c,jobRec.Add_Tech4__c);
                if(Tech4 != null){
                    lstjobhistory.add(Tech4);

                }
            }

            if((jobRec.Additional_Tech5__c!=null||jobRec.Additional_Tech5__c!='')&& (jobRec.Additional_Tech5__c!= mapOldJob.get(jobRec.id).Additional_Tech5__c)){
                CSS_JobHistory__c Tech5 = createJobhistoryRecord('CSS_Job_Order__c',jobRec.id,'Additional_Tech5__c',mapOldJob.get(jobRec.id).Add_Tech5__c,jobRec.Add_Tech5__c);
                if(Tech5 != null){
                    lstjobhistory.add(Tech5);
                }
            }

            if((jobRec.Additional_Tech6__c!=null||jobRec.Additional_Tech6__c!='')&& (jobRec.Additional_Tech6__c!= mapOldJob.get(jobRec.id).Additional_Tech6__c)){
                CSS_JobHistory__c Tech6 = createJobhistoryRecord('CSS_Job_Order__c',jobRec.id,'Additional_Tech6__c',mapOldJob.get(jobRec.id).Add_Tech6__c,jobRec.Add_Tech6__c);
                if(Tech6 != null){
                    lstjobhistory.add(Tech6);
                }
            }

            if((jobRec.Additional_Tech7__c!=null||jobRec.Additional_Tech7__c!='')&& (jobRec.Additional_Tech7__c!= mapOldJob.get(jobRec.id).Additional_Tech7__c)){
                CSS_JobHistory__c Tech7 = createJobhistoryRecord('CSS_Job_Order__c',jobRec.id,'Additional_Tech7__c',mapOldJob.get(jobRec.id).Add_Tech7__c,jobRec.Add_Tech7__c);
                if(Tech7 != null){
                    lstjobhistory.add(Tech7);
                }
            }

            if((jobRec.Additional_Tech8__c!=null||jobRec.Additional_Tech8__c!='')&& (jobRec.Additional_Tech8__c!= mapOldJob.get(jobRec.id).Additional_Tech8__c)){
                CSS_JobHistory__c Tech8 = createJobhistoryRecord('CSS_Job_Order__c',jobRec.id,'Additional_Tech8__c',mapOldJob.get(jobRec.id).Add_Tech8__c,jobRec.Add_Tech8__c);
                if(Tech8 != null){
                    lstjobhistory.add(Tech8);
                }
            }

            if((jobRec.Additional_Tech9__c!=null||jobRec.Additional_Tech9__c!='')&& (jobRec.Additional_Tech9__c!= mapOldJob.get(jobRec.id).Additional_Tech9__c)){
                CSS_JobHistory__c Tech9 = createJobhistoryRecord('CSS_Job_Order__c',jobRec.id,'Additional_Tech9__c',mapOldJob.get(jobRec.id).Add_Tech9__c,jobRec.Add_Tech9__c);
                if(Tech9 != null){
                    lstjobhistory.add(Tech9);
                }
            }

        }
        if(!lstjobhistory.isEmpty()){
            insert lstjobhistory;
            //  system.debug('Assignes--->'+lstjobhistory);
        }
    }
    //Rajesh End
    // Method to Update the DSID Owner

    public static void trackDSIDOwner(list<CSS_Job_Order__c> lstJobRec,map<id,CSS_Job_Order__c> mapOldJobRec)
    {
        list<CSS_JobHistory__c> hisJobRec = new list<CSS_JobHistory__c>();
        CSS_JobHistory__c hist;
        for(CSS_Job_Order__c jobRec : lstJobRec){
            if(jobRec.DSID_Owner__c!= mapOldJobRec.get(jobRec.id).DSID_Owner__c)
            {
                CSS_JobHistory__c auditJobRec = createJobhistoryRecord('CSS_Job_Order__c',jobRec.id,'DSID_Owner__c',mapOldJobRec.get(jobRec.id).DSID_Owner__c,jobRec.DSID_Owner__c);  
                if(auditJobRec != null){
                    hisJobRec.add(auditJobRec);
                }
            }

        }
        if(!hisJobRec.isEmpty()){
            insert hisJobRec;
        }
    }
    // End of DSID Owner Tracking
    //Method to insert record in job history object for Sub Status
    public static void updateSubStatus(list<CSS_Job_Order__c> lstNewServiceJob,map<id,CSS_Job_Order__c> mapOldServiceJob){
        list<CSS_JobHistory__c> lstjobhistory = new list<CSS_JobHistory__c>();
        CSS_JobHistory__c hist;
        //looping the new list 
        for(CSS_Job_Order__c csj : lstNewServiceJob){

            if(csj.Sub_Status__c != mapOldServiceJob.get(csj.id).Sub_Status__c){
                CSS_JobHistory__c compHis = createJobhistoryRecord('CSS_Job_Order__c',csj.id,'Sub_Status__c',mapOldServiceJob.get(csj.id).Sub_Status__c,csj.Sub_Status__c);
                if(compHis != null){
                    lstjobhistory.add(compHis);
                }
            } 
        }
        if(!lstjobhistory.isEmpty()){
            insert lstjobhistory;
        }
    }


    //End of Sub Status
    //Method to insert LOCATION Changes in audit(Document no 76192 start)
    public static void insertLocation(list<CSS_Job_Order__c> lstNewServiceJob,map<id,CSS_Job_Order__c> mapOldServiceJob){
        list<CSS_JobHistory__c> lstjobhistory = new list<CSS_JobHistory__c>();
        CSS_JobHistory__c hist;
        //looping the new list 
        for(CSS_Job_Order__c csj : lstNewServiceJob){

            if(csj.JobLocation__c != mapOldServiceJob.get(csj.id).JobLocation__c){
                CSS_JobHistory__c compHis = createJobhistoryRecord('CSS_Job_Order__c',csj.id,'JobLocation__c',mapOldServiceJob.get(csj.id).JobLocation__c,csj.JobLocation__c);
                if(compHis != null){
                    lstjobhistory.add(compHis);
                }
            } 
        }
        if(!lstjobhistory.isEmpty()){
            insert lstjobhistory;
        }
    }
    // 76192 End 

    //Method to update VIN Changes in audit
    public static void trackVIN(list<css_Job_Order__c> vinJobs, map<id,CSS_Job_Order__c> oldVinJob)
    {
        list<CSS_JobHistory__c> vinHistoryJobRec = new list<CSS_JobHistory__c>();
        for(CSS_Job_Order__c rJobRec : vinJobs)
        {
            CSS_JobHistory__c vinAuditJobRec = createJobhistoryRecord('CSS_Job_Order__c',rJobRec.id,'VIN__c',oldVinJob.get(rJobRec.id).VIN__C,rJobRec.VIN__c);
            if(vinAuditJobRec != null)
                vinHistoryJobRec.add(vinAuditJobRec);
        }
        if(!vinHistoryJobRec.isEmpty()){
            insert vinHistoryJobRec;
        }
    }
    //End of VIN Changes in audit

    public static CSS_JobHistory__c createJobhistoryRecord(String objName,Id jobId,String fieldName,String oldVal,String newVal){

        CSS_JobHistory__c hist = new CSS_JobHistory__c();
        hist.CSS_Object_Name__c = objName;
        hist.CSS_Job_Id__c = jobId;        
        hist.CSS_Field_Name__c = fieldName;
        hist.CSS_Old_Value__c = oldVal;
        hist.CSS_New_Value__c = newVal;

        return hist;
    } 
    /* This method will call from CSS_locationBasedJobSharing on after insert of any user and share all jobs to 
        users which is belongs to user's location. */
    /* @future
    public static void afterInsertShareJobsToUser(Set<Id>userIdSet){
        List<User>userList = new List<User>();
        userList = [Select Id,User_Location__c FROM User WHERE Id IN:userIdSet];
        for(user usr : userList){
                if(usr.User_Location__c!=null){
                      system.debug('Insert After'+ usr.User_Location__c );
                    List<CSS_Job_Order__c> jobOrderList = new List<CSS_Job_Order__c>();
                    List<CSS_Job_Order__Share> jobShrList   = new List<CSS_Job_Order__Share>();
                    Set<String> userLocationsSet = new Set<String>();
                    jobOrderList = [Select Id,Creator_Location__c FROM CSS_Job_Order__c WHERE CreatedDate <= TODAY AND Creator_Location__c = :usr.User_Location__c];
                    if(jobOrderList.size()>0){
                        system.debug('Insert-After jobOrderList '+ jobOrderList);
                        for(CSS_Job_Order__c objJob : jobOrderList){
                            if(usr.user_location__c == objJob.Creator_Location__c){
                                CSS_Job_Order__Share jobShr = new CSS_Job_Order__Share();
                                jobShr.ParentId         = objJob.Id;
                                jobShr.UserOrGroupId    = usr.id;
                                jobShr.AccessLevel = 'Edit';
                                jobShrList.add(jobShr);
                            }
                        }
                        system.debug('jobShrList:::'+jobShrList);

                        if(jobShrList.size() > 0 && !Test.isRunningtest())
                        insert jobShrList;
                  }     
                }


            }
    }*/
    @InvocableMethod(label='failureCodeToJobEventTemp' description='make callout to insert FC details in Job event temporary')
    public static void failureCodeToJobEventTemp(List<String> smn_engcode){
        List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c, Reason__c, Key__c FROM CSS_JobEventTemporary__c WHERE Attribute3__c =: smn_engcode[0] AND Key__c = 'getFailureCodesSRT' AND CreatedDate = LAST_N_DAYS:7];
        system.debug('job even temp'+jobEventTemp);
        List<String> SMN_EngCode_Lst = new List<String>();
        SMN_EngCode_Lst = smn_engcode[0].split(';;');
        if(jobEventTemp.isEmpty()){
            callFailureComponent(SMN_EngCode_Lst[0], SMN_EngCode_Lst[1]);
        }
    }
    @future(callout=true)
    public static void callFailureComponent(String SMN, String engCode){
        CSS_FN_SRT controller = new CSS_FN_SRT();
        CSS_SRTComponentLookupResponseJ2A failureCodeDetails;
        failureCodeDetails = controller.getFailureCodesSRT(SMN, engCode, 'en');
        system.debug('output vignesh -->'+failureCodeDetails);
        String output = JSON.serialize(failureCodeDetails);
        CSS_JobEventTemporary__c jobEventTemp = new CSS_JobEventTemporary__c();
        jobEventTemp.Attribute1__c = SMN;
        jobEventTemp.Attribute2__c = engCode;
        jobEventTemp.Attribute3__c = SMN + ';;' + engCode; 
        jobEventTemp.Reason__c = output;
        jobEventTemp.Key__c = 'GetFailureCodesSRT';
        insert jobEventTemp;
    }


    public static void changeOwnerInfo(List<CSS_Job_Order__c> serviceJobs)
    {
        List<CSS_Job_Order__c> serJobLst = new List<CSS_Job_Order__c>();

        List<String> Locations = new List<String>();

        for(CSS_Job_Order__c ul : serviceJobs ){
            Locations.add('JQ' + '-' + ul.Creator_Location__c);
            system.debug('locations' + ' ' +locations);
        }

        List<Group> queues= [select id, Name from Group where Type='Queue' AND Name IN:Locations];
        system.debug('queues' + ' ' +queues);

        Map<string,ID> mapjobsSpecificLoc = new Map<string,ID>();

        for(Group q:queues){

            if(!mapjobsSpecificLoc.containsKey(q.Name))
                mapjobsSpecificLoc.put(q.Name,q.id);
            system.debug('mapjobsSpecificLoc-->'+mapjobsSpecificLoc);
        }

        for(CSS_Job_Order__c jobs: serviceJobs){
            if(jobs!= null && jobs.Creator_Location__c!=null && jobs.Creator_Location__c!=''){
                CSS_Job_Order__c serJob = new CSS_Job_Order__c();
                serJob.Id = jobs.Id;
                serJob.OwnerId  = mapjobsSpecificLoc.get('JQ-'+jobs.Creator_Location__c);
                serJobLst.add(serJob);
            }
        }

        system.debug('serJobLst-->'+serJobLst);
        if(serJobLst.size()>0)
            update serJobLst; 
    }
}