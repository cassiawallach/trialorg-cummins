/*************************************************************************************
Name:  IAM_Sub_UserUpdate_Queueable
Copyright © 2019  Cummins
**************************************************************************************
Purpose: It is queueable class to update User records
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Karthik Raj Golakaram     01/16/2020        INITIAL DEVELOPMENT 
1.1      Karthik Raj Golakaram     01/03/2021     Made changes to make sure that we are 
                                                  calling LDAP API to remove changes, 
                                                  changed to update Contact and User record.
1.2      Karthik Raj Golakaram     02/10/2021     Added extra lines to populate blank Values.
**************************************************************************************
**************************************************************************************/
public class IAM_Sub_UserUpdate_Queueable Implements Queueable{
    
    Public Set<id> ConIds;
    Public Boolean fromLocationSubscriptionAdditionAPIClass;
    Public Boolean fromSubscriptionRemovalBatchClass;
    
    public IAM_Sub_UserUpdate_Queueable(Set<id> ConIds){
        this.ConIds=ConIds;
        this.fromLocationSubscriptionAdditionAPIClass=True;
        this.fromSubscriptionRemovalBatchClass=false;
    }
    
    Public IAM_Sub_UserUpdate_Queueable(Set<id> ConIds,Boolean fromLocationSubscriptionAdditionAPIClass,Boolean fromSubscriptionRemovalBatchClass){
        this.ConIds=ConIds;
        this.fromLocationSubscriptionAdditionAPIClass=fromLocationSubscriptionAdditionAPIClass;
        this.fromSubscriptionRemovalBatchClass=fromSubscriptionRemovalBatchClass;
    }
    
    public Void execute(QueueableContext Context){
        List<Contact> consToProcess=IAM_Utility.processedContacts(conIds);
        List<User> usersToUpdate= new List<User>(); 
        if(!consToProcess.isEmpty()){
            Map<id,Contact> conMap= new Map<id,Contact>();
            for(contact c:consToProcess){
                conMap.put(c.id,c);
            }
            ID jobID;
             if(!Test.isRunningTest()&&fromLocationSubscriptionAdditionAPIClass&&!fromSubscriptionRemovalBatchClass){
                jobID = System.enqueueJob(new IAM_LDAP_Util_Subcription_Callout(ConIds,'Update'));
                System.debug('jobID'+jobID);
             }
            Map<id,User> UserMap=new Map<id,User>([SELECT id,IAM_Applicationgroups__c,IAM_Application_Roles__c,IAM_Qsolexpiration__c,IAM_swregexpire__c,Contactid FROM User WHERE Contactid=:conIds AND isActive=TRUE]);
            
            if(!UserMap.isEmpty()){
                for(id u:UserMap.keySet()){
                    if(conMap.ContainsKey(UserMap.get(u).Contactid)){
                        if(conMap.get(UserMap.get(u).Contactid)!=null){
                            if(!String.isBlank((conMap.get(UserMap.get(u).Contactid)).IAM_Applications__c)){
                                UserMap.get(u).IAM_Applicationgroups__c=conMap.get(UserMap.get(u).Contactid).IAM_Applications__c;
                            }else{
                                UserMap.get(u).IAM_Applicationgroups__c='';
                            }
                            if(!String.isBlank((conMap.get(UserMap.get(u).Contactid)).IAM_Application_Roles__c)){
                                UserMap.get(u).IAM_Application_Roles__c=conMap.get(UserMap.get(u).Contactid).IAM_Application_Roles__c;
                            }else{
                                UserMap.get(u).IAM_Application_Roles__c='';
                            }
                            if(!String.isBlank((conMap.get(UserMap.get(u).Contactid)).IAM_Qsolexpiration__c)){
                                UserMap.get(u).IAM_Qsolexpiration__c=conMap.get(UserMap.get(u).Contactid).IAM_Qsolexpiration__c;
                            }else{
                                UserMap.get(u).IAM_Application_Roles__c='';
                            }
                            if(!String.isBlank((conMap.get(UserMap.get(u).Contactid)).IAM_swregexpire__c)){
                                UserMap.get(u).IAM_swregexpire__c=conMap.get(UserMap.get(u).Contactid).IAM_swregexpire__c;
                            }else{
                                UserMap.get(u).IAM_Application_Roles__c='';
                            }
                        }
                    }
                    usersToUpdate.add(UserMap.get(u));
                }
            }
        }
        if(!usersToUpdate.isEmpty()){
            update UsersToUpdate; 
        }
    }

}