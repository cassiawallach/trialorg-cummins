/**********************************************************************
Name:CSS_LoginUserCacheVariables
Copyright © 2016  Cummins
======================================================
======================================================
Purpose: To put user and his/her details in Session Cache variables                                                          
======================================================
======================================================
History                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Satish         03/29/2017      INITIAL DEVELOPMENT 
2.0 - Anirudh  05/24/2017 Added Multi Location Logic
3.0 - Anvesh   08/23/2018 Added 3 new fields in User location object
3.1 - Anvesh   08/24/2018 Added logic to update the user locations as per LDAP 
3.2 - Anvesh   08/24/2018 Added logic to add the user to the queues
***********************************************************************/

public class CSS_LoginUserCacheVariables {

    @InvocableMethod
    public static void getUserAttributes()
    {
        System.debug(' SATISH - User session variables');

        // Attributes from User Object 
        User u = [select Id,Profile.name,UserLoginCounter__c,CSS_User_MultiLocValues__c,LastLoginDate,UserPreviousLoginDate__c, UserGroup__c,User_Location__c,User_Role__c, UserRoleName__c,Product_Group_Access__c,Work_Group_Name__c,FederationIdentifier,LanguageLocaleKey from user where id=:userInfo.getUserId() LIMIT 1];
        if(u.User_Location__c != null && u.User_Location__c != '')
            css_utility.setSessionVariables(u.User_Location__c);
        /*System.debug(' SATISH - User session variables' + u.User_Location__c);

Cache.Session.put('local.CSSPartition.UserPrimaryLocationCode', u.User_Location__c==null?'':u.User_Location__c);
Cache.Session.put('local.CSSPartition.UserEDSUserGroup', u.UserGroup__c==null?'':u.UserGroup__c);
Cache.Session.put('local.CSSPartition.UserEDSRole', u.User_Role__c==null?'':u.User_Role__c);
Cache.Session.put('local.CSSPartition.UserEDSPorductGroupAccess', u.Product_Group_Access__c==null?'':u.Product_Group_Access__c);
Cache.Session.put('local.CSSPartition.UserEDSWorkGroupName', u.Work_Group_Name__c==null?'':u.Work_Group_Name__c);

Cache.Session.put('local.CSSPartition.UserRoleName', u.UserRoleName__c==null?'':u.UserRoleName__c);
Cache.Session.put('local.CSSPartition.UserFederationIdentifier', u.FederationIdentifier==null?'':u.FederationIdentifier);
Cache.Session.put('local.CSSPartition.UserLanguageLocaleKey', u.LanguageLocaleKey==null?'':u.LanguageLocaleKey);
*/

        
        list<Account> acc = [select Id, Name, Location__c,BMS_Enabled__c,ERP_System__c, Region__c,Territory__c, IA_CSSEnabled__c from Account where Location__c =: u.User_Location__c LIMIT 1]; //188776 Added by Rajesh Narra to avoid the 50001 limit error.
        system.debug('Acc Size' + acc.size());
        /*
if(acc.size()>0){
Cache.Session.put('local.CSSPartition.UserBMSEnabled', acc[0].BMS_Enabled__c);
Cache.Session.put('local.CSSPartition.UserIAEnabled', acc[0].IA_CSSEnabled__c);      
Cache.Session.put('local.CSSPartition.UserRegion', acc[0].Region__c==null?'':acc[0].Region__c);
Cache.Session.put('local.CSSPartition.UserTerritory', acc[0].Territory__c==null?'':acc[0].Territory__c);
Cache.Session.put('local.CSSPartition.UserPrimaryLocationName', acc[0].Name==null?'':acc[0].Name);
}

String ProflieName = [SELECT Name FROM Profile WHERE Id=:userInfo.getProfileId() LIMIT 1].Name;
Cache.Session.put('local.CSSPartition.UserProfileName', ProflieName==null?'':ProflieName); 
*/
        // Code for 5STAR Rating 
        try{
            //method call to get all unit type and subtype as per loc code
            if(acc != null && acc.size()>0){
                if (acc[0].BMS_Enabled__c == true || acc[0].ERP_System__c == 'One BMS' || acc[0].ERP_System__c == 'BMS Legacy'){
                    getUnitTypeSubTyp(u.User_Location__c);
                }
            }

            system.debug('Last Login' + u.LastLoginDate);

            DateTime dT = System.now();
            Date todayDate = date.newinstance(dT.year(), dT.month(), dT.day());

            DateTime LLdT;
            Date LLDate;
            if (u.UserPreviousLoginDate__c != null){  
                LLdT = u.UserPreviousLoginDate__c; //u.LastLoginDate;
                LLDate = date.newinstance(LLdT.year(), LLdT.month(), LLdT.day());
            }else{
                LLDate = date.newinstance(dT.year(), dT.month(), dT.day()-1);
            }


            system.debug('LLDate'+ date.newinstance(dT.year(), dT.month(), dT.day()-1));

            system.debug('Date Variables' + LLDate + todayDate + u.UserLoginCounter__c);

            // Increment counter only if Last Logged in Date is different from Today's date.
            if(LLDate!=todayDate){ 

                if (u.UserLoginCounter__c==null){
                    u.UserLoginCounter__c = 1; 
                }else{
                    u.UserLoginCounter__c = u.UserLoginCounter__c + 1;
                }

                u.UserPreviousLoginDate__c=u.LastLoginDate;
                update u;
            }

            addLocations(u.CSS_User_MultiLocValues__c,u.FederationIdentifier,u.Id,u.Profile.name);
            //  shareAdvanced(u.Id,u.Profile.name,u.CSS_User_MultiLocValues__c);


        } catch(exception e){
            system.debug('Login Flow - User Update'+ e.getMessage()+' LineNo>>:'+e.getLineNumber());        
        }

    }

    //Start Moulika - 130893 
    /*  public static void shareAdvanced(id UserId,String ProfileName,String multiLocs)//Profile,multilocs and userid
    {
        List<string> lstLocations = new List<string>();
        lstLocations = multiLocs.split(';');
        system.debug('Inside addLocations1'+ lstLocations);
        List<string> lstsbstrngloc = new List<string>();

        for(string sbstrngloc:lstLocations){
            system.debug('Inside For Loop Anirudh1'+sbstrngloc);
            string substrngLocation;
            substrngLocation = sbstrngloc.substring(0,11);
            lstsbstrngloc.add(substrngLocation);
            system.debug('Inside For Loop Anirudh2'+lstsbstrngloc);
        } 
        Map<id,CSS_Job_Order__c> jobOrderMap = new Map<id,CSS_Job_Order__c>();//Map of id and service job 
        for(CSS_Job_Order__c job:[SELECT id,Status__c,Sub_Status__c FROM CSS_Job_Order__c WHERE Status__c != 'Cancel' AND Status__c != 'supported' 
                                  AND Status__c != 'Closed' AND Creator_Location__c IN :lstsbstrngloc])
        {
            jobOrderMap.put(job.id,job);//This consists of jobs that is fetched from the user location
        }
        System.debug('User related service job is'+ jobOrderMap);
        Map<Id,CSS_Job_Order__share> UserServiceJob=new Map<Id,CSS_Job_Order__share>();//Map of Id and job share records
        For(CSS_Job_Order__share jobShare:[select id,ParentId,UserOrGroupId from CSS_Job_Order__share where UserOrGroupId=:UserId And ParentId=:jobOrderMap.keySet()]){
            UserServiceJob.put(jobShare.ParentId,jobShare);
        }
        System.debug('The User Sharing Service Jobs is:'+UserServiceJob);
        //list<User> lginuser=[SELECT id,Account.name,account.type FROM User where account.type like '%Dealer%' AND id=:UserId];
        List<CSS_Job_Order__share> usersShareList = new List<CSS_Job_Order__share>();
        if(ProfileName.contains('Advanced'))
        { 
            System.debug('Test Profile');
            For(CSS_Job_Order__c joborder:jobOrderMap.values())//We are traversing through all the jobs that fetched
            {
                if(!UserServiceJob.containsKey(joborder.id))//Through the contains we are searching the ids of the service which are not shared.
                {
                    CSS_Job_Order__share cjo = new CSS_Job_Order__share(); 
                    cjo.AccessLevel='Edit';
                    cjo.ParentId =joborder.id;
                    cjo.UserOrGroupId = UserId;
                    cjo.RowCause = Schema.CSS_Job_Order__share.RowCause.CG_Secondary_Sharing__c;
                    usersShareList.add(cjo);
                }
                else
                {
                    System.debug('no records shared');

                }
            }
        }



        if(usersShareList.size()>0)
        {
            upsert usersShareList;
            System.debug('The Sharing Records is:'+usersShareList);
        }
    } */
    //End Moulika - 130893 
    public static Map<String,CSS_UserLocation__c> mapUserLocations;
    public static void addLocations(String multiLocs,String FederationId,Id UserId,String ProfileName)
    {
        List<string> lstLocations = new List<string>();
        if(multiLocs!=null && multiLocs!='')
            lstLocations = multiLocs.split(';');
        system.debug('Inside addLocations1'+ lstLocations);
        system.debug('FedIdValue is'+FederationId);
        List<string> lstsbstrngloc = new List<string>();

        for(string sbstrngloc:lstLocations){
            system.debug('Inside For Loop Anirudh1'+sbstrngloc);
            string substrngLocation;
            substrngLocation = sbstrngloc.substring(0,11);
            lstsbstrngloc.add(substrngLocation);
            system.debug('Inside For Loop Anirudh2'+lstsbstrngloc);
        }

        //User Userdetails = [Select Id,FederationIdentifier from User where FederationIdentifier =: FederationId];

        mapUserLocations = new map<String,CSS_UserLocation__c>();
        for(CSS_UserLocation__c UserLocation : [Select id,AccountId__c,isActive__c,isPrimary__c,Location_code__c,UserId__c from CSS_UserLocation__c WHERE UserId__c =: UserId AND Location_Source__c != 'ARF']) //(Location_code__c=: lstsbstrngloc AND UserId__c =: UserId)
            mapUserLocations.put(UserLocation.Location_code__c, UserLocation);
        system.debug('mapUserLocations>>>>>>>>'+mapUserLocations);
        if(lstLocations != null )
        {
            for(string st:lstLocations)
            {
                CSS_UserLocation__c userLoc = new CSS_UserLocation__c();
                if(!(mapUserLocations.containsKey(st.substring(0,11)))){
                    userLoc.Location_Source__c = 'LDAP';
                    system.debug('Entered does not contain in user location-Anirudh');
                    system.debug('st.subString(0,13)>>>'+st.subString(0,13));
                    if(st.subString(0,13).contains('-P'))
                    {
                        userLoc.Location_code__c =  st.subString(0,13).replace('-P','');
                        userLoc.isPrimary__c = true;
                        if(UserId != null)
                            userLoc.UserId__c = UserId;
                        userLoc.isServiceJobs__c= true;
                       // userLoc.isClaims__c = true;
                        //userLoc.UserLocationKey__c = unique value;
                    }
                    else if(st.subString(0,13).contains('-S')){
                        userLoc.Location_code__c =  st.subString(0,13).replace('-S','');
                        userLoc.isPrimary__c = false;
                        if(UserId != null)
                            userLoc.UserId__c = UserId;
                        userLoc.isServiceJobs__c= true;
                       // userLoc.isClaims__c = false;
                    }
                }else if(mapUserLocations.containsKey(st.substring(0,11))){
                    userLoc.Location_Source__c = 'LDAP';
                    system.debug('Entered contains in user location-Anirudh');
                    CSS_UserLocation__c exUserLoc = mapUserLocations.get(st.substring(0,11));
                    if(st.subString(0,13).contains('-P'))
                    {
                        //userLoc.Location_code__c =  st.subString(0,13).replace('-P','');
                        userLoc.isPrimary__c = true;
                        userLoc.id = exUserLoc.id;
                        if(UserId != null)
                            userLoc.UserId__c = UserId;
                        userLoc.isServiceJobs__c= true;
                        //userLoc.isClaims__c = true;
                    }
                    else if(st.subString(0,13).contains('-S')){
                        // userLoc.Location_code__c =  st.subString(0,13).replace('-S','');
                        userLoc.isPrimary__c = false;
                        userLoc.id = exUserLoc.id;
                        if(UserId != null)
                            userLoc.UserId__c = UserId;
                        userLoc.isServiceJobs__c= true;
                       // userLoc.isClaims__c = false;
                    }
                }
                system.debug('mapUserLocations22222>>>>>>>>'+mapUserLocations);
                userLoc.isActive__c = false;
                mapUserLocations.put(st.substring(0,11), userLoc);
                system.debug('mapUserLocations333333>>>>>>>>'+mapUserLocations);
            }
        }

        List<Account> AccountLoc = new List<Account>(); 
        if(lstsbstrngloc != null && lstsbstrngloc.size()>0){
        AccountLoc = [Select Id,Location__c from Account WHERE Location__c =: lstsbstrngloc];//188776 Added by Rajesh Narra to avoid the 50001 limit error.
        }
        system.debug('AccountLoc>>>>>>>'+AccountLoc);
        if(AccountLoc != null )
        {
            for(Account ac:AccountLoc)
            {
                system.debug('ACC Locations>>>>>>'+ac.Location__c);
                if(mapUserLocations.containsKey(ac.Location__c)){
                    system.debug('Entered Account for Loop');
                    CSS_UserLocation__c userLoc = mapUserLocations.get(ac.Location__c);
                    userLoc.isActive__c = true;
                    userLoc.AccountId__c = ac.Id;
                    mapUserLocations.put(ac.Location__c,userLoc);
                    system.debug('mapUserLocations 259' + '  ' + mapUserLocations);
                }

            }
        }

        system.debug('mapUserLocations keyset ' + '  ' + mapUserLocations.keySet());
        system.debug('lstsbstrngloc 268 ' + '  ' + lstsbstrngloc);

        List<CSS_UserLocation__c> userLocs = new List<CSS_UserLocation__c> ();
        if(mapUserLocations != null){
        for(string locuser : mapUserLocations.keySet()){   // looping all stored userlocation object records
            if(!lstsbstrngloc.contains(locuser)){
                userLocs.add(mapUserLocations.get(locuser));
                mapUserLocations.remove(locuser);
                system.debug('after map remove' + ' ' +  mapUserLocations); 
            }
        }
        }
        system.debug('before delete userLocs' + userLocs);
        delete userLocs;
        system.debug('After delete userLocs' + userLocs ); 

        upsert mapUserLocations.values();
        system.debug('upsert' + '     ' + mapUserLocations.values() ); 
          if(ProfileName.contains('Advanced'))
        { 
        System.debug('Test Profile' + ProfileName);
        addUsersToQueues(mapUserLocations.keySet());
        }
    }

    //method to fetch all unit type and sub type from the webservice 
    public static void getUnitTypeSubTyp(string strLoc){
        list<CSS_JobEventTemporary__c>  lUnitType=[select Reason__c from CSS_JobEventTemporary__c 
                                                   where attribute1__c='UnitTypes' and Key__c=:strLoc];
        if (lUnitType == null || lUnitType.size()==0){
            CSS_WS_BMS cbms=new CSS_WS_BMS();
            cbms.getSubTypesUnitTypesService(strLoc);

        }
    }

    @future(callout=true)
    public static void addUsersToQueues(Set<String> locIds){
        system.debug('SAMA Inside adduserqueues method' + ' ' + locIds); 
        List<String> jobsLocations = new List<String>();
        List<String> claimsLocations = new List<String>();
        for(String ul : locIds ){
            jobsLocations.add('JQ' + '-' + ul);
            claimsLocations.add('CQ' + '-' + ul);
        }

        Id UserId = UserInfo.getUserId();

        List<CSS_UserLocation__c> lstUserLocations = new List<CSS_UserLocation__c>();
        lstUserLocations = [select id, isServiceJobs__c,Enable_Claim__c,isClaims__c, Location_code__c from CSS_UserLocation__c where UserId__c=:UserId AND Location_code__c IN :locIds and Location_Source__c != 'ARF']; //add user id condition too
        List<CSS_UserLocation__c> lstClaimUserLocations = new List<CSS_UserLocation__c>();
        lstClaimUserLocations = [select id, isServiceJobs__c,Enable_Claim__c,isClaims__c, Location_code__c from CSS_UserLocation__c where UserId__c=:UserId AND Location_code__c IN :locIds and Location_Source__c = 'ARF']; //add user id condition too

        system.debug('lstUserLocations' + '  ' + lstUserLocations);
        if(lstClaimUserLocations != null && lstClaimUserLocations.size()>0){
        for(CSS_UserLocation__c clmLoc : lstClaimUserLocations ){
            claimsLocations.add('CQ' + '-' + clmLoc.Location_code__c);
        }
        }
        
        
        List<Group> LocQueuesJob= [select id, Name from Group where Type='queue' AND Name IN:jobsLocations];
        List<Group> LocQueuesClaim= [select id, Name from Group where Type='queue' AND Name IN:claimsLocations];
        List<Group> newQueues = new List<Group>();
        List<Group> newClaimsQueues = new List<Group>();



        /******************** Jobs Begin *************/
        // Logic for updating the Job queues when there was mismatch between locations and queues

        system.debug('LocQueuesJob.size() ' + ' ' +LocQueuesJob.size() );
        system.debug('jobsLocations.size()' + '  ' + jobsLocations.size() );
        if(LocQueuesJob.size() != jobsLocations.size()){
            for(String JL : jobsLocations){
                boolean isBroken = false;
                for(Group JQue : LocQueuesJob){
                    if(JQue.name == JL){
                        isBroken = true;
                        break;
                    }
                }
                if(isBroken == false){
                    Group newGroup =  new Group();
                    newGroup.Type = 'queue';
                    newGroup.Name = JL;
                    newQueues.add(newGroup);
                }
            }
            if(newQueues.size()>0){
                upsert newQueues;
            }
            system.debug('newQueues' + ' ' + newQueues);

            List<QueueSobject> mappingObject = new List<QueueSobject>();
            for(Group Qsobject : newQueues){
                QueueSobject sObjRec = new QueueSobject();
                sObjRec.QueueId = Qsobject.Id;
                sObjRec.SobjectType = 'CSS_Job_Order__c';
                mappingObject.add(sObjRec);
            }
            if(mappingObject.size()>0)
                upsert mappingObject;

        }

        LocQueuesJob.addAll(newQueues);

        system.debug('LocQueuesJob' + '  ' + LocQueuesJob);

        /******************** Jobs End ********/ 

        /********* CLaims Begin  **********/
        // Logic for updating the Claims queues when there was mismatch between locations and queues

        system.debug('LocQueuesClaim.size() ' + ' ' +LocQueuesClaim.size() );
        system.debug('claimsLocations.size()' + '  ' + claimsLocations.size() );
        if(LocQueuesClaim.size() != claimsLocations.size()){
            for(String CL : claimsLocations){
                boolean isBroken = false;
                for(Group CQue : LocQueuesClaim){
                    if(CQue.name == CL){
                        isBroken = true;
                        break;
                    }
                }
                if(isBroken == false){
                    Group newGroupClaims =  new Group();
                    newGroupClaims.Type = 'queue';
                    newGroupClaims.Name = CL;
                    newClaimsQueues.add(newGroupClaims);
                }
            }
            if(newClaimsQueues.size()>0){
                upsert newClaimsQueues;
            }
            system.debug('newClaimsQueues claims' + ' ' + newClaimsQueues);

            List<QueueSobject> mappingObject1 = new List<QueueSobject>();
            for(Group Qsobject : newClaimsQueues){
                QueueSobject sObjRec = new QueueSobject();
                sObjRec.QueueId = Qsobject.Id;
                sObjRec.SobjectType = 'CSS_Claims__c';
                mappingObject1.add(sObjRec);
            }
            if(mappingObject1.size()>0)
                upsert mappingObject1;

        }

        LocQueuesClaim.addAll(newClaimsQueues);

        system.debug('newClaimsQueues' + '  ' + newClaimsQueues);

        /******************** Claims End *******/


        Map<String,Id> locQueueJobMap = new Map<String,Id>();
        Map<String,Id> locQueueClaimMap = new Map<String,Id>();
        for(Group grp : LocQueuesJob){
            if(!locQueueJobMap.containsKey(grp.Name)){
                locQueueJobMap.put(grp.Name,grp.Id);
            }
        }
        for(Group grp : LocQueuesClaim){
            if(!locQueueClaimMap.containsKey(grp.Name)){
                locQueueClaimMap.put(grp.Name,grp.Id);
            }
        }

        List<GroupMember> listMembers = new List<GroupMember>();
        if(lstUserLocations != null && lstUserLocations.size()>0){

            for(CSS_UserLocation__c allLocLst : lstUserLocations){

                if(allLocLst.isServiceJobs__c == true){//allLocLst.isClaims__c == true){Enable_Claim__cAnirudh changed for ARF changes
                    GroupMember memberJob = new GroupMember();
                    memberJob.UserOrGroupId = userInfo.getUserId();
                    memberJob.GroupId = locQueueJobMap.get('JQ-' + allLocLst.Location_code__c);
                    listMembers.add(memberJob);
                   /* GroupMember memberClaim = new GroupMember();
                    memberClaim.UserOrGroupId = userInfo.getUserId();
                    memberClaim.GroupId = locQueueClaimMap.get('CQ-' +allLocLst.Location_code__c);
                    listMembers.add(memberClaim);*/
                }
                system.debug('listMembers' + listMembers);
            }
            if(listMembers.size()>0){
                insert listMembers;
            }

        }
        
         List<GroupMember> clmListMembers = new List<GroupMember>();
        if(lstClaimUserLocations != null && lstClaimUserLocations.size()>0){

            for(CSS_UserLocation__c allLocLst : lstClaimUserLocations){

                if(allLocLst.isClaims__c == true){//allLocLst.isClaims__c == true){Enable_Claim__cAnirudh changed for ARF changes
                   /* GroupMember memberJob = new GroupMember();
                    memberJob.UserOrGroupId = userInfo.getUserId();
                    memberJob.GroupId = locQueueJobMap.get('JQ-' + allLocLst.Location_code__c);
                    listMembers.add(memberJob);*/
                    GroupMember memberClaim = new GroupMember();
                    memberClaim.UserOrGroupId = userInfo.getUserId();
                    memberClaim.GroupId = locQueueClaimMap.get('CQ-' +allLocLst.Location_code__c);
                    clmListMembers.add(memberClaim);
                }
                system.debug('listMembers' + clmListMembers);
            }
            if(clmListMembers.size()>0){
                insert clmListMembers;
            }

        }

    }
}