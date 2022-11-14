Public Class IAM_User_Trigger_Helper{

    Public Static Void userTriggerHandler(List<User> usrs){
        Set<id> allUserIds= new Set<id>();
        for(User u:usrs){
        allUserIds.add(u.id);
        }
        
        if(!allUserIds.isEmpty()){
            System.debug('calling Contact Update class');
            if(!System.isFuture()&&!System.isBatch())
            UpdateContactWithUserID(allUserIds);
        }
    }
    
    public static void onAfterUpdate(List<User> userList, Map<Id,User> newUserMap, Map<Id,User> oldUserMap) {
        
         
        if(!System.isFuture()){
        IAM_AWSCognito_CallService.callService(userList, newUserMap, oldUserMap);
        System.debug('Printing changing of password and last login time stamp');
            IAM_TrackUser_Reclaim.UpdateReclaimpasswordTimeStamp(newUserMap.Keyset());
        }
    }

    
    @future
    public Static Void UpdateContactWithUserID(Set<id> userids){
    try{
        Map<id,User> mapExtUsr= new Map<id,User>();
        Map<String,User> mapIntUsr= new Map<String,User>();
        List<Contact> conExt= new List<Contact>();
        List<Contact> ConInt=new List<Contact>();
        List<Contact> ConToUpdate= new List<Contact>();
        List<User> usr=[select id,FederationIdentifier,Contactid,isActive from User where id=:userids];
        if(!usr.isEmpty()){
            for(User u:usr){
                if(u.Contactid!=null){
                    //if contact ids are present then add them to set.
                    
                    mapExtUsr.put(u.Contactid,u);
                }else if(String.isBlank(u.FederationIdentifier)){
                    
                    mapIntUsr.put(u.FederationIdentifier,u);
                }   
            }
            
            
            if(!mapExtUsr.isEmpty()){
                conExt= [select id,IAM_Contact_Owner__c,Username__c from Contact where id=:mapExtUsr.KeySet()];
            }
            if(!mapIntUsr.isEmpty()){
                ConInt=[Select id,IAM_Contact_Owner__c,Username__c from Contact where Username__c=:mapIntUsr.KeySet()];
            }
             
                
            if(!conExt.isEmpty()){
                for(Contact c1: conExt){
                System.debug('Printing contact id'+c1.id);
                    if(mapExtUsr.containsKey(c1.id)){
                        if(mapExtUsr.get(c1.id).isActive){
                            c1.IAM_Contact_Owner__c=mapExtUsr.get(c1.id).id;
                        }else{
                            //Since we are not disabling the contact there will always be a contact associated to user.
                            c1.IAM_Contact_Owner__c=null;
                        }
                    }else{
                        //for suppose some one disables it.
                        c1.IAM_Contact_Owner__c=null;
                    }
                ConToUpdate.add(c1);    
                }
            }
            
            if(!conInt.isEmpty()){
                for(Contact c1: conInt){
                    if(mapIntUsr.containsKey(c1.Username__c)){
                        if(mapIntUsr.get(c1.id).isActive){
                            c1.IAM_Contact_Owner__c=mapIntUsr.get(c1.id).id;
                        }else{
                            //Since we are not disabling the contact there will always be a contact associated to user.
                            c1.IAM_Contact_Owner__c=null;
                        }
                    }else{
                        //for suppose some one disables it.
                        c1.IAM_Contact_Owner__c=null;
                    }
                ConToUpdate.add(c1);    
                }
            }
            
            if(!ConToUpdate.isEmpty()){
                    Update ConToUpdate;
            }
        }
    }catch(Exception e){
        System.debug('Printing exception '+e.getMessage());
    }
}
  
}