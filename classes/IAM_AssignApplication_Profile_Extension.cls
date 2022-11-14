/************************************************************
Name:  IAM_AssignApplication_Profile_Extension
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_AssignApplication_Profile_Extension class.
//below class is mainly used as a invokable class fron process builder in order to assaign and delete permission sets from users.
//this class will have two functions which gets invoked on insertion and update on the application status                           
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -    Nishant Verma             02/10/2020        Fluidwatch Changes for site admin page -INITIAL DEVELOPMENT
1.3 -    Karthik Raj Golakaram     01/25/2021        Making Changes for OSM High Prod issue - INC1022619
1.4 -    Suresh Rathod Nanavath	   07/03/2022		 Added logic to assign existing permission after Profile/license update to the user
													 Also skipped profile update when user has Customer Community Plus or Partner Community 

/********************************************************************************
***********************************************************************************/ 
public class IAM_AssignApplication_Profile_Extension implements Queueable{
    Public map<string,string> mapofIdAndroles;
    Public map<ID,string> roleUrsIdsMap;
    Public map<string,ID> rolePsIdsMap;
    Public string Action;
    
    Public IAM_AssignApplication_Profile_Extension(map<string,string> mapofIdAndroles,Map<Id,String> roleUrsIdsMap,Map<String,Id> rolePsIdsMap,String Action){
        this.mapofIdAndroles=mapofIdAndroles;
        this.roleUrsIdsMap=roleUrsIdsMap;
        this.rolePsIdsMap=rolePsIdsMap;
        this.Action=Action;
    
    }
    
    public void execute(QueueableContext Context) {
         system.debug('mapofIdAndroles##'+mapofIdAndroles);
          List<User> userProfileUpdatelist = new List<User>();
            Set<Id> UrsIds = new Set<Id>();
            map<string,string> mapOfprofiles= new map<string,string>();
            Map<String,string> accSCRoleID = new map<string,string>();
        	String osmStoreFrontAdmin=System.Label.IAM_OSM_ContPro_Default_Roles;
            List<Profile> profileList=[SELECT Id,Name FROM Profile WHERE Name LIKE '%IAM%'];
            for(profile pr : profileList){
                mapOfprofiles.put(pr.name, pr.id);
            }
            List<IAM_WWSPS_HQ_Regions__mdt> WWPS_HQ_rolesList =[Select Id,MasterLabel,IAM_User_Role_ID__c,Service_Provider_Code__c,IAM_User_Role__c from IAM_WWSPS_HQ_Regions__mdt];
              if(!WWPS_HQ_rolesList.isEmpty()){    
                  for(IAM_WWSPS_HQ_Regions__mdt objRole :WWPS_HQ_rolesList){
                      accSCRoleID.put(objRole.Service_Provider_Code__c,objRole.IAM_User_Role_ID__c);
                  }
              }
            for(User u:[select id,Name,email,profileid,profile.UserLicense.Name,contact.CMI_Contact_Type__c,profile.name,Division,contactID,FederationIdentifier,UserRole.Name from User where (contactid=:mapofIdAndroles.keySet() OR  FederationIdentifier =:mapofIdAndroles.keySet())]){
                system.debug('Inside User list for loop');
                system.debug('User id:'+u.id+' ProfileID:'+u.ProfileId+' ProfileName:'+u.profile.name); 
                if(u.contactID != null){
                    if(u.FederationIdentifier != null &&  mapofIdAndroles.get(u.contactID).contains('OSM Storefront Admin') && u.Profile.name !='IAM_Site_Admin_Community' && !u.Profile.name.startsWithIgnoreCase('CSS')&& u.Profile.UserLicense.Name !='Customer Community Plus' &&u.Profile.UserLicense.Name !='Partner Community'){
                        system.debug('Comin in site admin@@@'); 
                        system.debug('Comin in site admin@@@'+mapOfprofiles.get('IAM_Site_Admin_Community')); 
                        u.profileid=mapOfprofiles.get('IAM_Site_Admin_Community');
                        userProfileUpdatelist.add(u);
                    }
                }else{
                     if(u.FederationIdentifier != null && mapofIdAndroles.get(u.FederationIdentifier).contains('Distributor Admin')  && !u.Profile.name.startsWithIgnoreCase('CSS') && u.Profile.UserLicense.Name !='Customer Community Plus' &&u.Profile.UserLicense.Name !='Partner Community'){
                        u.UserRoleid=accSCRoleID.get(u.Division);
                        u.profileid=mapOfprofiles.get('IAM_Distributor_Admin_Platform');
                        userProfileUpdatelist.add(u);
                        
                    }
                    else if(u.FederationIdentifier != null &&(mapofIdAndroles.get(u.FederationIdentifier).contains('OSM Sales Admin')||mapofIdAndroles.get(u.FederationIdentifier).contains('OSM Sales User') && !u.Profile.name.startsWithIgnoreCase('CSS')&& u.Profile.UserLicense.Name !='Customer Community Plus' &&u.Profile.UserLicense.Name !='Partner Community')){
                        u.UserRoleid=accSCRoleID.get(u.Division);
                        u.profileid=mapOfprofiles.get('IAM_Admin_User');
                        userProfileUpdatelist.add(u);
                    } 
                    else if(u.FederationIdentifier != null && mapofIdAndroles.get(u.FederationIdentifier).contains('OSM Support Admin') && !u.Profile.name.startsWithIgnoreCase('CSS')&& u.Profile.UserLicense.Name !='Customer Community Plus' &&u.Profile.UserLicense.Name !='Partner Community'){
                        u.UserRoleid=accSCRoleID.get(u.Division);
                        u.profileid=mapOfprofiles.get('IAM_Admin_User');
                        userProfileUpdatelist.add(u);
                    }
                    else if(u.FederationIdentifier != null && mapofIdAndroles.get(u.FederationIdentifier).contains('OSM Business Admin') && !u.Profile.name.startsWithIgnoreCase('CSS')&& u.Profile.UserLicense.Name !='Customer Community Plus' &&u.Profile.UserLicense.Name !='Partner Community'){
                        u.UserRoleid=accSCRoleID.get(u.Division);
                        u.profileid=mapOfprofiles.get('IAM_Admin_User');
                        userProfileUpdatelist.add(u);
                    }
                }
            }
        system.debug('userProfileUpdatelist##'+userProfileUpdatelist);
        
        //Start-Permissionset Assignment -@Suresh
        List<PermissionSetAssignment> psAssignmentList = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> existingPSAssignmentList = [
                SELECT Id
                     , PermissionSetId
                     , AssigneeId
                  FROM PermissionSetAssignment
                 WHERE AssigneeId IN :userProfileUpdatelist
            ];
            System.debug('#### existingPSAssignmentList - '+existingPSAssignmentList);
                
            if(!existingPSAssignmentList.isEmpty()) {
                List<PermissionSetAssignment> oldPSAList = new List<PermissionSetAssignment>();
                for(PermissionSetAssignment psa : existingPSAssignmentList) {
                    psa.Id = null;
                    oldPSAList.add(psa);
                }
                psAssignmentList.addAll(oldPSAList);
                System.debug('#### existingPSAssignmentList without Ids - '+oldPSAList);
                System.debug('#### Old & New Permission Set To Assign - '+ psAssignmentList);
            }
        //End - Permissionset Assignment- @Suresh
       
        try{
            Update userProfileUpdatelist;
            Database.SaveResult[] saveResult = Database.insert(psAssignmentList,false);
        }catch(exception e){
            System.debug('#### AssignApplication Profile Extension Class Error -userlist'+userProfileUpdatelist+' Permission Set '+psAssignmentList+'error:'+e);
        }

        if(!test.isRunningTest()){
            System.enqueueJob(new IAM_AssignApplication_PS_Extension(roleUrsIdsMap,rolePsIdsMap,Action));
        }

       
    }
}