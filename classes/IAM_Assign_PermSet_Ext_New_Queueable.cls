/*Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is class for IAM_Assign_PermSet_Ext_New_Queueable class. 
For Assigning permission sets to the Users after user creation.We will be passing contact ids, Seperate them into internal 
And External Users and then figure out the Contact Features present for both internal and External Contacts and Assign users 
Respective Permission Sets.Changes made                   
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION     AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram    23/04/2018       INITIAL DEVELOPMENT        
*****************************************************/
/********************************************************************************
***********************************************************************************/
public class IAM_Assign_PermSet_Ext_New_Queueable Implements Queueable{

    Public Set<id> contactIds;
    Public String action;

    public IAM_Assign_PermSet_Ext_New_Queueable(Set<id> contactIds,String action) {
        This.contactIds=contactIds;
        this.action=action;
    }
        //As of now Since it is being called from Basic Registration PAge. I am Implementing this for 
        //External User
    Public Void Execute(QueueableContext qc){
        Map<Id,List<IAM_Contact_Provisioning__c>> mapConProv = new Map<Id,List<IAM_Contact_Provisioning__c>>(); // Map To Store Contact Id to Contactc Provisionings.
        Map<Id,User> mapUser = new Map<Id,User>();// Map to Store Contact Id to User.
        Map<String,IAM_Application_Groups__c> mapApplicationGroups = new Map<String,IAM_Application_Groups__c>();// Map to Store Application name and Role as Key and then application group.
        Map<String,PermissionSet> mapPermissionSet= new Map<String,PermissionSet>();// map to Store application name and Permision set.
        
        List<IAM_Application_Groups__c> appGroups = IAM_Application_Groups__c.getall().values();//getting all the custom settings.
        for(IAM_Application_Groups__c ap:appGroups){
            if(!mapApplicationGroups.ContainsKey(ap.IAM_Application_Name__c+ap.IAM_Role_Name__c)){
                mapApplicationGroups.Put(ap.IAM_Application_Name__c+ap.IAM_Role_Name__c,ap);
            }
        }

        List<PermissionSet> allPermissionSets= [SELECT id,Name,Label FROM PermissionSet LIMIT 500];
        if(!allPermissionSets.isEmpty()){
            for(PermissionSet p:allPermissionSets){
                mapPermissionSet.put(p.Label,p);
            }
        }

        List<User> userList= [SELECT id,Username,ContactId FROM User WHERE ContactId=:contactIds AND isActive=True];
        if(!userList.isEmpty()){
            for(User u:userList){
                mapUser.put(u.ContactId,u);
            }
        }

        List<Contact> allContacts=[SELECT id,Username__c,
                                  (SELECT id,IAM_Contact__c,IAM_Application_Name__c,IAM_Role__c 
                                   FROM Contact_Provisionings__r 
                                   WHERE IAM_Status__c='Active')
                                   FROM Contact 
                                   WHERE id=:contactIds 
                                   AND IAM_Contact_Status__c='Active'];

        List<IAM_Contact_Provisioning__c> allConProvs=[SELECT id,IAM_Contact__c,IAM_Application_Name__c,IAM_Role__c 
                                                       FROM IAM_Contact_Provisioning__c 
                                                       WHERE IAM_Status__c='Active' 
                                                       AND IAM_Contact__c=:contactIds];
        if(!allContacts.isEmpty()){
            for(Contact c:allContacts){
                mapConProv.Put(c.id,c.Contact_Provisionings__r);
            } 
        }

        //Loop through all the contact Provisionings. For Every provision Create one Permission set record add
        //it to list and insert all permission sets using DataBase.insert

        List<PermissionSetAssignment> PermissionSetList = new List<PermissionSetAssignment>();
        if(!allConProvs.isEmpty()){
            for(IAM_Contact_Provisioning__c cp:allConProvs){ 
                if(mapUser.ContainsKey(cp.IAM_Contact__c)){
                    if(mapApplicationGroups.containsKey(cp.IAM_Application_Name__c+cp.IAM_Role__c)){
                        List<String> permissionSets=new List<String>();
                        if(!Test.isRunningTest()){
                            permissionSets= mapApplicationGroups.get(cp.IAM_Application_Name__c+cp.IAM_Role__c).IAM_Permission_Sets_To_Be_Assigned__c.Split(';');
                        }else{
                            permissionSets.add('Guidanz');
                            permissionSets.add('Shop Cummins Online Store');
                        }
                        if(allPermissionSets.Size()>1){
                            //for loop
                            for(String st:permissionSets){
                                if(mapPermissionSet.containsKey(st)){
                                    PermissionSetAssignment psa= new PermissionSetAssignment(AssigneeId = mapUser.get(cp.IAM_Contact__c).id,PermissionSetId=mapPermissionSet.get(st).id);
                                    PermissionSetList.add(psa);
                                }
                            }
                        }else{
                            if(mapPermissionSet.containsKey(mapApplicationGroups.get(cp.IAM_Application_Name__c+cp.IAM_Role__c).IAM_Permission_Sets_To_Be_Assigned__c)){
                                PermissionSetAssignment psa= new PermissionSetAssignment(AssigneeId = mapUser.get(cp.IAM_Contact__c).id,PermissionSetId=mapPermissionSet.get(mapApplicationGroups.get(cp.IAM_Application_Name__c+cp.IAM_Role__c).IAM_Permission_Sets_To_Be_Assigned__c).id);
                                PermissionSetList.add(psa);
                            }
                        }
                    }
                } 

                System.debug('Prinitng all the permission set values'+PermissionSetList);
                If(!PermissionSetList.isEmpty()){
                    System.debug('Priniting before Save result');
                    Database.SaveResult[] saveResult = Database.insert(PermissionSetList,false); 
                }
            }
        }
     }
}