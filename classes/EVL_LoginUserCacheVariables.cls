/**********************************************************************
Name:EVL_LoginUserCacheVariables
Copyright © 2020  Cummins
======================================================
======================================================
Purpose: To put user and his/her details in Session Cache variables                                                          
======================================================
======================================================
History                                                            
VERSION  	AUTHOR            			DATE                DETAIL                                 
1.0 	 	Krishnamoorthi N			06/26/2020			INITIAL DEVELOPMENT 
2.0         Krishnamoorthi N            07/13/2020          CT1-54.
3.0         Krishnamoorthi N            07/16/2020            adding account share to logged in user.
***********************************************************************/
public class EVL_LoginUserCacheVariables {
    @InvocableMethod
    public static void getUserAttributes() {
        System.debug(' SATISH - User session variables');
        User u = [SELECT Id,Profile.name,UserLoginCounter__c,CSS_User_MultiLocValues__c,LastLoginDate,UserPreviousLoginDate__c, 
                        UserGroup__c,User_Location__c,User_Role__c, UserRoleName__c,Product_Group_Access__c,Work_Group_Name__c,
                        FederationIdentifier,LanguageLocaleKey 
                  FROM user 
                  WHERE id=:userInfo.getUserId() 
                  LIMIT 1
                ];
                
        try {
            addLocations(u.CSS_User_MultiLocValues__c,u.FederationIdentifier,u.Id,u.Profile.name);
        } catch(exception e){
            system.debug('Login Flow - User Update'+ e.getMessage()+' LineNo>>:'+e.getLineNumber());        
        }
    }

    public static Map<String,CSS_UserLocation__c> mapUserLocations;
    public static void addLocations(String multiLocs,String FederationId,Id UserId,String ProfileName) {
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
        if(lstLocations != null ) {
            for(string st:lstLocations) {
                CSS_UserLocation__c userLoc = new CSS_UserLocation__c();
                if(!(mapUserLocations.containsKey(st.substring(0,11)))){
                    userLoc.Location_Source__c = 'LDAP';
                    system.debug('Entered does not contain in user location-Anirudh');
                    system.debug('st.subString(0,13)>>>'+st.subString(0,13));
                    if(st.subString(0,13).contains('-P')) {
                        userLoc.Location_code__c =  st.subString(0,13).replace('-P','');
                        userLoc.isPrimary__c = true;
                        if(UserId != null)
                            userLoc.UserId__c = UserId;
                        userLoc.isServiceJobs__c= true;
                       // userLoc.isClaims__c = true;
                        //userLoc.UserLocationKey__c = unique value;
                    }
                    else if(st.subString(0,13).contains('-S')) {
                        userLoc.Location_code__c =  st.subString(0,13).replace('-S','');
                        userLoc.isPrimary__c = false;
                        if(UserId != null)
                            userLoc.UserId__c = UserId;
                        userLoc.isServiceJobs__c= true;
                       // userLoc.isClaims__c = false;
                    }
                }else if(mapUserLocations.containsKey(st.substring(0,11))) {
                    userLoc.Location_Source__c = 'LDAP';
                    system.debug('Entered contains in user location-Anirudh');
                    CSS_UserLocation__c exUserLoc = mapUserLocations.get(st.substring(0,11));
                    if(st.subString(0,13).contains('-P')) {
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
        list<AccountShare> AccountShareList = new list<AccountShare>();
        if(AccountLoc != null ) {
            for(Account ac:AccountLoc) {

                //Sharing Accounts to Advanced users.
                AccountShare accShare = new AccountShare();
                accShare.RowCause = 'Manual';
                accShare.userOrGroupId = userInfo.getUserId();
                accShare.AccountID = ac.id;
                accShare.AccountAccessLevel='Read';
                accShare.OpportunityAccessLevel='Read';
                AccountShareList.add(accShare);

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
        
        system.debug('AccountShareList BEFORE ' + AccountShareList);
        if(AccountShareList != null && AccountShareList.size() >0)
            insert AccountShareList;
        system.debug('AccountShareList AFTER ' + AccountShareList);

        system.debug('mapUserLocations keyset ' + '  ' + mapUserLocations.keySet());
        system.debug('lstsbstrngloc 268 ' + '  ' + lstsbstrngloc);

        List<CSS_UserLocation__c> userLocs = new List<CSS_UserLocation__c> ();
        if(mapUserLocations != null) {
            for(string locuser : mapUserLocations.keySet()) {   // looping all stored userlocation object records
                if(!lstsbstrngloc.contains(locuser)) {
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
        //START CT1-54.
        if(ProfileName.contains('EVL_Dealer_Advanced') || ProfileName.contains('EVL_Dealer_Readonly')) { 
        	System.debug('Test Profile' + ProfileName);
        	addUsersToQueues(mapUserLocations.keySet());
        }
        //END CT1-54.
    }

    @future(callout=true)
    public static void addUsersToQueues(Set<String> locIds){
        system.debug('SAMA Inside adduserqueues method' + ' ' + locIds); 
        List<String> jobsLocations = new List<String>();
        set<string> Upsertedset = new Set<String>();
        for(String ul : locIds ){
            jobsLocations.add('JQ' + '-' + ul);
        }

        Id UserId = UserInfo.getUserId();

        List<CSS_UserLocation__c> lstUserLocations = new List<CSS_UserLocation__c>();
        lstUserLocations = [select id, isServiceJobs__c,Enable_Claim__c,isClaims__c, Location_code__c from CSS_UserLocation__c where UserId__c=:UserId AND Location_code__c IN :locIds and Location_Source__c != 'ARF']; //add user id condition too
        system.debug('lstUserLocations' + '  ' + lstUserLocations);
        
        List<Group> LocQueuesJob= [select id, Name from Group where Type='queue' AND Name IN:jobsLocations];
        List<Group> newQueues = new List<Group>();
        List<Group> newQueueslst = new List<Group>();
        
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
            newQueueslst.addall(newQueues);
            newQueueslst.addall(LocQueuesJob);
            List<QueueSobject> mappingObject = new List<QueueSobject>();
            for(Group Qsobject : newQueueslst){
                Upsertedset.add(Qsobject.Name);
                QueueSobject sObjRec = new QueueSobject();
                sObjRec.QueueId = Qsobject.Id;
                sObjRec.SobjectType = 'CSS_Job_Order__c';
                mappingObject.add(sObjRec);
                
                //Add work order and case.
                QueueSobject sObjRecCase = new QueueSobject();
                sObjRecCase.QueueId = Qsobject.Id;
                sObjRecCase.SobjectType = 'WorkOrder';
                mappingObject.add(sObjRecCase);
                
                QueueSobject sObjRecWO = new QueueSobject();
                sObjRecWO.QueueId = Qsobject.Id;
                sObjRecWO.SobjectType = 'Case';
                mappingObject.add(sObjRecWO);
                
                
            }
            if(mappingObject.size()>0)
                upsert mappingObject;

        }
      //karthik G deleteing queue's part of CT1- 168
        
       /* set<id> queueids = new set<id>();
        List<ListView> mylstObjs = [Select SobjectType,Id,Name, DeveloperName From ListView where Name IN:Upsertedset];
        for(ListView l:mylstObjs){
            queueids.add(l.Id);
        }
       if(queueids!=null && queueids.size()>0)*/
        //delete mylstObjs;
      
       // listViewIdSet=[Select SobjectType,Id,Name, DeveloperName From ListView where Name LIKE 'JL%'];
    
        
        
        
        LocQueuesJob.addAll(newQueues);

        system.debug('LocQueuesJob' + '  ' + LocQueuesJob);

        /******************** Jobs End ********/ 

        Map<String,Id> locQueueJobMap = new Map<String,Id>();
        //Map<String,Id> locQueueClaimMap = new Map<String,Id>();
        for(Group grp : LocQueuesJob){
            if(!locQueueJobMap.containsKey(grp.Name)){
                locQueueJobMap.put(grp.Name,grp.Id);
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
                }
                system.debug('listMembers' + listMembers);
            }
            if(listMembers.size()>0){
                insert listMembers;
            }
        }
    }
}