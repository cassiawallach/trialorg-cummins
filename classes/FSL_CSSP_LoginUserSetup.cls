/**********************************************************************
Name: FSL_CSSP_LoginUserSetup
Copyright Â© 2021  Cummins
======================================================
======================================================
Purpose:  This class is to create and assign users to Queue 
which provides access to the Service Requests and Service Orders
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR           DATE                DETAIL                                 
1.0 -    Rajkumar BT      08/10/2021     INITIAL DEVELOPMENT               
***********************************************************************/
public class FSL_CSSP_LoginUserSetup {
    
    public static List<Account> lstAccounts;
    Public static Set<string> setLocationIds;
    public static Map<Id, Account> mapAccountDetails;
    public static List<Account> lstAccountHierarchy;
    public static Map<Id, List<Account>> mapParentChildLinked;
    public static List<account> acctList;
    public static string query;

    @InvocableMethod
    //Method to get the logged in user locations and create queue
    public static void getUserLocation(){
        try{
            Id accId;
            lstAccounts = new List<Account>();
            setLocationIds = new Set<string>();
            Account acc = new Account();
            User usr = [SELECT Id, Contact.AccountId from User WHERE Id =: userInfo.getUserId() LIMIT 1];
            
            if(usr != null){
                accId = usr.Contact.AccountId;
                lstAccounts = getChildAccountsInHierarchy(accId);
                system.debug('lstAccounts--'+lstAccounts);
                if(lstAccounts != null){
                    for(Account a : lstAccounts){
                        //if(a.Id != accId){
                        setLocationIds.add('SP' + '-' + a.FSL_ERP_Customer_Code__c);
                        //}
                    }
                    if(setLocationIds != null){
                        addUserToQueue(setLocationIds);
                    }
                }
            }
        }
        catch(Exception ex){
            system.debug('Exception in getUserLocation method--' + ex.getLineNumber() + ' ' + ex.getMessage());
        }
    }
    
    @future(callout=true)
    //Method to create queue and assign user to the queue
    public static void addUserToQueue(Set<string> LocationIds){
        system.debug('UserLocationIds--'+LocationIds);
        try{
            List<Group> newQueues = new List<Group>();
            List<Group> newQueueslst = new List<Group>();
            set<string> Upsertedset = new Set<String>();
            
            Id UserId = UserInfo.getUserId();
            List<Group> lstSPQueue = [select id, Name from Group where Type='queue' AND Name IN: LocationIds];
            if(LocationIds != null){
                for(String Loc : LocationIds){
                    boolean isBroken = false;
                    for(Group SPQue : lstSPQueue){
                        if(SPQue.name == Loc){
                            isBroken = true;
                            break;
                        }
                    }
                    if(isBroken == false){
                        Group newGroup =  new Group();
                        newGroup.Type = 'queue';
                        newGroup.Name = Loc;	
                        newQueues.add(newGroup);
                    }
                }
                
                if(newQueues.size()>0){
                    upsert newQueues;
                }
                system.debug('newQueues' + ' ' + newQueues);
                newQueueslst.addall(newQueues);
                newQueueslst.addall(lstSPQueue);
                List<QueueSobject> mappingObject = new List<QueueSobject>();
                
                for(Group Qsobject : newQueueslst){
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
            
            lstSPQueue.addAll(newQueues);
            system.debug('lstSPQueue--'+lstSPQueue);
            Map<String,Id> mapQueueJob = new Map<String,Id>();
            for(Group grp : lstSPQueue){
                if(!mapQueueJob.containsKey(grp.Name)){
                    mapQueueJob.put(grp.Name,grp.Id);
                }
            }
            
            system.debug('mapQueueJob--'+mapQueueJob);
            system.debug('setLocationIds--'+LocationIds);
            
            List<GroupMember> lstMembers = new List<GroupMember>();
            for(string locCode : LocationIds){
                GroupMember memberJob = new GroupMember();
                memberJob.UserOrGroupId = userInfo.getUserId();
                memberJob.GroupId = mapQueueJob.get( locCode);
                lstMembers.add(memberJob);
            }
            system.debug('lstMembers' + lstMembers);
            if(lstMembers.size()>0){
                insert lstMembers;
                
                /*List<ListView> lstListViews = [Select Id, Name, DeveloperName From ListView where Name LIKE 'SP-%'];
                
                if(lstListViews != null){
                    delete lstListViews;
                }*/
            }
        }
        catch(Exception ex){
            system.debug('Exception in addUserToQueue method--'+ ex.getLineNumber() + ' ' + ex.getMessage());
        }
    }
    
    //Method to get all the child Accounts of logged in user
    public static List<Account> getChildAccountsInHierarchy(Id parentAcctId) {
        try{
            mapAccountDetails = new Map<Id, Account>();
            lstAccountHierarchy = new List<Account>();
            mapParentChildLinked = new Map<Id, List<Account>>();
            Boolean endTraversing = false;
            Integer accountLevel = 0;
            List<Id> parentIdList = new List<Id>();
            parentIdList.add(parentAcctId);
            //string query;
            acctList = new List<Account>();
            Map<Id, Integer> accountIdLevelMap = new Map<Id, Integer>();
             //added As a part of FBI 393
           /* if(accountLevel == 0) {
                    query = 'select Id, Name, ParentId, Location__c, FSL_ERP_Customer_Code__c from Account WHERE Id IN :parentIdList';
                } else {
                    query = 'select Id, Name, ParentId, Location__c, FSL_ERP_Customer_Code__c from Account WHERE ParentId IN :parentIdList';
                }
                acctList = Database.query(query);
                 //added As a part of FBI 393
            */
            while(!endTraversing) {
               /* Commented As a part of FBI 393 
                if(accountLevel == 0) {
                    query = 'select Id, Name, ParentId, Location__c, FSL_ERP_Customer_Code__c from Account WHERE Id IN :parentIdList';
                } else {
                    query = 'select Id, Name, ParentId, Location__c, FSL_ERP_Customer_Code__c from Account WHERE ParentId IN :parentIdList';
                }
                acctList = Database.query(query);
                Commented As a part of FBI 393 */
                acctList = acclist(accountLevel,parentIdList); //added As a part of FBI 393
                if(acctList.size() == 0 ) {
                    endTraversing = true;
                } else {
                    parentIdList.clear();
                    
                    acctList.sort();
                    Account a;
                    for(Integer i = 0; i < acctList.size(); i++ ) {
                        a = acctList.get(i);
                        parentIdList.add(a.Id);
                        List<Account> childAccts = new List<Account>();
                        childAccts.add(a);
                        accountIdLevelMap.put(a.Id, accountLevel);
                        mapAccountDetails.put(a.Id, a);
                        
                        if(accountLevel > 0) {
                            if(mapParentChildLinked.get(a.ParentId) == null) {
                                mapParentChildLinked.put(a.ParentId, childAccts); 
                            }
                           
                            mapParentChildLinked.get(a.ParentId).add(a);
                            mapParentChildLinked.get(a.ParentId).sort();
                            
                            
                        }
                    }
                    accountLevel++;
                }
            }
            
            addChildAccountsToList(parentAcctId);
        }
        catch(Exception ex){
            system.debug('Exception in getChildAccountsInHierarchy method--'+ ex.getLineNumber() + ' ' + ex.getMessage());
        }
        return lstAccountHierarchy;
    }    
    
    //Method to add all child Accounts to the list
  
    private static void addChildAccountsToList(Id parentAccountId) {
        try{
            Account a = mapAccountDetails.get(parentAccountId);
            lstAccountHierarchy.add(a);
            
            List<Account> childAccounts = mapParentChildLinked.get(parentAccountId);
            if(childAccounts != null) {
                childAccounts.sort();
                for(Account acct : childAccounts) {
                    addChildAccountsToList(acct.Id);
                }
            }
        }
        catch(Exception ex){
            system.debug('Exception in addChildAccountsToList method--'+ ex.getLineNumber() + ' ' + ex.getMessage());
        }
        return;
    }
        //added As a part of FBI 393
    public static list<account> acclist(Integer accountLevel,List<id> parentIdList){
             //added As a part of FBI 393
            if(accountLevel == 0) {
                    query = 'select Id, Name, ParentId, Location__c, FSL_ERP_Customer_Code__c from Account WHERE Id IN :parentIdList';
                } else {
                    query = 'select Id, Name, ParentId, Location__c, FSL_ERP_Customer_Code__c from Account WHERE ParentId IN :parentIdList';
                }
                acctList = Database.query(String.escapeSingleQuotes(query));//added As a part of FBI 393
                system.debug('acctList>>>'+acctList);
                 //added As a part of FBI 393
        return acctList;
    }
    //added As a part of FBI 393

}