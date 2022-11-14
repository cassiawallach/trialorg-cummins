public class IAM_TrackUser_Reclaim {
    
    public Static boolean Assign_Permission_set=false;
    public Static boolean Contact_update=false;
    public Static boolean Create_User=false;
    public Static boolean LDAP_Create_User=false;
    public Static boolean LDAP_Group_Mapping=false;
    public Static boolean LDAP_Move_User=false;
    public Static boolean Promotion_Code=false;
    Public Static boolean Guidanz_User=false;
    
    public Static List<IAM_Reclaim_Tracker__c> reclaimUsers=new List<IAM_Reclaim_Tracker__c>();
    public Static Set<String> reclaimCheck = new Set<String>();
    
    @future
    public static void updateReclaimTrackerUser(String oldUserName,String newUsername,String methodName,Boolean check){
        reclaimUsers = [Select name,Assign_Permission_set__c, Guidanz_User__c,Contact_update__c, IAM_New_Username__c,Create_User__c, LDAP_Create_User__c, LDAP_Group_Mapping__c, LDAP_Move_User__c, Promotion_Code__c from IAM_Reclaim_Tracker__c Where name=:oldUserName LIMIT 1];
        if(reclaimUsers.isEmpty()){
            IAM_Reclaim_Tracker__c trackUser = new IAM_Reclaim_Tracker__c();
            trackUser.Name = oldUserName;
            reclaimUsers.add(trackUser);
            insert reclaimUsers;
            system.debug('@Inside insert Reclaim completed');
        }
        //List<IAM_Reclaim_Tracker__c> reclaimUsers = [Select name,Assign_Permission_set__c, Contact_update__c, Create_User__c, LDAP_Create_User__c, LDAP_Group_Mapping__c, LDAP_Move_User__c, Promotion_Code__c from IAM_Reclaim_Tracker__c Where name=:username];
        if(!reclaimUsers.isEmpty()){
            system.debug('@Inside update Reclaim start');
            if(String.isBlank(reclaimUsers[0].IAM_New_Username__c)){
                reclaimUsers[0].IAM_New_Username__c=newUsername;
            }
            system.debug('@reclaimUsers'+reclaimUsers);
            if(methodName=='Promotion_Code__c'){
                Promotion_Code=check;
                reclaimCheck.add('Promotion_Code__c');
                System.debug('@Promotion_Code__c '+Promotion_Code);
            }
            if(methodName=='Guidanz_User__c'){
                Guidanz_User=check;
                reclaimCheck.add('Guidanz_User__c');
                System.debug('@Guidanz_User__c '+Promotion_Code);
            }
            if(methodName=='Create_User__c'){
                Create_User=check;
                reclaimCheck.add('Create_User__c');
                System.debug('@Create_User__c '+Create_User);
            }
            if(methodName=='Assign_Permission_set__c'){
                Assign_Permission_set=check;
                reclaimCheck.add('Assign_Permission_set__c');
                System.debug('@Assign_Permission_set__c '+Assign_Permission_set);
            }
            
            System.debug('@reclaimCheck value '+reclaimCheck+' size '+reclaimCheck.size());
            
            if(Create_User){
                reclaimUsers[0].Create_User__c=Create_User; 
                update reclaimUsers;
                system.debug('@Inside update Create_User completed');
            }
            if(Promotion_Code){
                reclaimUsers[0].Promotion_Code__c=Promotion_Code;
                update reclaimUsers;
                system.debug('@Inside update Promotion_Code completed');
            }
            if(Assign_Permission_set){
                reclaimUsers[0].Assign_Permission_set__c=Assign_Permission_set;
                update reclaimUsers;
                system.debug('@Inside update Assign_Permission_set completed');
            }
            if(Guidanz_User){
                reclaimUsers[0].Guidanz_User__c=Guidanz_User;
                update reclaimUsers;
                system.debug('@Inside update Assign_Permission_set completed');
            }
        }
    }
    
    @future
    Public Static Void UpdateReclaimpasswordTimeStamp(Set<id> uids){
        System.debug('Prinintng entered value');
        Map<id,User> UserMap=new Map<id,User>([SELECT id,IAM_UID__C,Username,LastLoginDate,LastPasswordChangeDate,LastModifiedBy.Name FROM  User WHERE id=:uids AND isActive=TRUE]);
        Map<String,User> usernameMap= new Map<String,User>();
        List<IAM_Reclaim_Tracker__c> reclaimList= new List<IAM_Reclaim_Tracker__c>();
        Set<String> usernames= new Set<String>();
        List<IAM_Reclaim_Tracker__c> trackerToUpdate= new List<IAM_Reclaim_Tracker__c>();
        Map<string,IAM_Reclaim_Tracker__c> reclaimMap= new Map<string,IAM_Reclaim_Tracker__c>();
        if(!UserMap.isEmpty()){
            for(id i: uids){
                if(UserMap.ContainsKey(i)){
                    usernames.add(UserMap.get(i).IAM_UID__c);
                    usernameMap.put(UserMap.get(i).IAM_UID__c,UserMap.get(i));
                }
            }
            if(!usernames.isEmpty()){
                reclaimList=[SELECT id,Name,Create_User__c,Guidanz_User__c,IAM_Password_Time_Stamp__c,IAM_Password_Change_User__c FROM IAM_Reclaim_Tracker__c WHERE Name=:usernames AND (Create_User__c=TRUE OR Guidanz_User__c=TRUE)];
                if(!reclaimList.isEmpty()){
                    for(IAM_Reclaim_Tracker__c re:reclaimList){
                        reclaimMap.put(re.Name,re);
                    }
                }
            }
        }
        System.debug('Prinintg username Map '+usernameMap);
        System.debug('Prinintg reclaim Map'+reclaimMap);
        if(!usernameMap.isEmpty()&&!reclaimMap.isEmpty()){
            for(String im:reclaimMap.KeySet()){
                if(usernameMap.ContainsKey(im)&&reclaimMap.ContainsKey(im)){
                    reclaimMap.get(im).IAM_Password_Time_Stamp__c=string.valueOfGmt(usernameMap.get(im).LastPasswordChangeDate);
                    reclaimMap.get(im).IAM_Password_Change_User__c=usernameMAp.get(im).LastModifiedby.Name;
                trackertoUpdate.add(reclaimMap.get(im));
                }
            }
        }
        if(!trackertoUpdate.isEmpty()){
            System.debug('Printing reclaim Update');
            Update trackertoUpdate;
        }
    }
}