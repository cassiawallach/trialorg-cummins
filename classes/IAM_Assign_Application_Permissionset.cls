/*************************************************************************************
Name:  IAM_Assign_Application_Permissionset
Copyright © 2019  Cummins
**************************************************************************************
Purpose: It is mainly used as a invokable class from process builder in order to assaign
and delete permission sets from users. This class will have two functions which gets
invoked on insertion and update on the application status.
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Karthik Raj Golakaram     20/04/2019     INITIAL DEVELOPMENT 
1.1      Nishant Verma             02/10/2020     Fluidwatch Changes for site admin page
1.2      Karthik Raj Golakaram     01/25/2021     Making Changes for OSM High Prod issue 
                                                  - INC1022619
1.4      Karthik Raj Golakaram     03/25/2021     Made changes for market place bulk user
                                                  provisioning issue.
1.5      Shubhangi Sardar          27/04/2021     Code optimization and LDAP Sync Issue
1.6      Shubhangi Sardar          09/08/2021     Added EVL Guidanz Permission Set Changes
1.7      Suresh Rathod             22/04/2022     Added changes for Guidanz Service Portal Enhancements(To remove Both permission sets of Guidanz Service Portal)
1.8	     Souvik Lahiri             25/08/2022     Added chages for Guidanz Automation Flow Optimization
1.9      Chetan Gaikwad            26/09/2022     Revoked changes for Guidanz Automation 
**************************************************************************************
**************************************************************************************/ 

public without sharing class IAM_Assign_Application_Permissionset { 
    /* Assaign permission set to the user record when contact provisioning record is inserted.
    ** This method needs user id,application name to get permission set Id. */
        
    @InvocableMethod
    public static void AssignApplication(List<IAM_Contact_Provisioning__c> app) {

        //Added by souvik developed by srini
        List<IAM_AssignPermissionSetToUsersWrapper> lstAssignPermissionSetToUsersWrapper = new List<IAM_AssignPermissionSetToUsersWrapper>();
        
        /* action defines the action that should be performed in permission set.*/
        String action;
        Set<String> appNameSet = new Set<String>();
        Map<String, Set<Id>> guidanzRoleMap = new Map<String, Set<Id>>();
        Map<String, Set<Id>> guidanzServPortalRoleMap = new Map<String, Set<Id>>();        // -@Suresh -To store Permission set and Users map for Guidanz Service Portal
        Set<Id> conIdsOSM = new Set<Id>();
        Map<String,String> mapofConIdOsmRoles =  new Map<String,String>();        
        List<IAM_Contact_Provisioning__c> conProAppList = New List<IAM_Contact_Provisioning__c>();
        System.debug('Printing applications in Assig app' + app);
        System.debug('Printing app size in Assign Application'+app.size());

        if(app[0].IAM_Status__c == 'Active') {
            action = 'Insert';
        } else {
            action = 'Delete';
        }
        conProAppList = app;
        for(IAM_Contact_Provisioning__c conProApp : conProAppList){
            System.debug('Printing application name'+conProApp.IAM_Application_Name__c);
            if(conProApp.IAM_Application_Name__c == 'Marketplace') {
                if(action == 'Insert') {
                    if(conProApp.IAM_Status__c == 'Active') {
                    	conIdsOSM.add(conProApp.IAM_Contact__c);
                		mapofConIdOsmRoles.put(conProApp.IAM_Contact__c,conProApp.IAM_Role__c); 
                    }   
                } else if(action=='Delete') {
                    if(conProApp.IAM_Status__c=='Inactive') {
                    	conIdsOSM.add(conProApp.IAM_Contact__c);
                		mapofConIdOsmRoles.put(conProApp.IAM_Contact__c,conProApp.IAM_Role__c); 
                    }  
                }  
            } else {
                appNameSet.add(conProApp.IAM_Application_Name__c);

                /* Add Guidanz Permission Set specific to Advanced and Technician role */
                if(conProApp.IAM_Application_Name__c == Label.IAM_AppName_Guidanz) {
                    if(conProApp.IAM_Role__c == Label.IAM_GuidanzRole_Technician) {
                        if(guidanzRoleMap.containsKey(Label.IAM_GuidanzPSet_EVLDealerTechnician)) {
                            guidanzRoleMap.get(Label.IAM_GuidanzPSet_EVLDealerTechnician).add(conProApp.IAM_User__c);
                        } else {
                            guidanzRoleMap.put(Label.IAM_GuidanzPSet_EVLDealerTechnician, new Set<Id>{conProApp.IAM_User__c});
                        }
                    } else if(conProApp.IAM_Role__c == Label.IAM_GuidanzRole_Advanced) {
                        if(guidanzRoleMap.containsKey(Label.IAM_GuidanzPSet_EVLDealerAdv)) {
                            guidanzRoleMap.get(Label.IAM_GuidanzPSet_EVLDealerAdv).add(conProApp.IAM_User__c);
                        } else {
                            guidanzRoleMap.put(Label.IAM_GuidanzPSet_EVLDealerAdv, new Set<Id>{conProApp.IAM_User__c});
                        }
                    }
                }
                /* Add Guidanz Service Portal Specific permission set i.e FSL_Guidanz_Customer_Community_User */
                if(conProApp.IAM_Application_Name__c == Label.IAM_AppName_GuidanzServicePortal)
                {
                    if(guidanzServPortalRoleMap.containsKey(Label.IAM_FSL_CSSP_Customer))
                    {
                     	guidanzServPortalRoleMap.get(Label.IAM_FSL_CSSP_Customer).add(conProApp.IAM_User__c);
                    } else {
                        guidanzServPortalRoleMap.put(Label.IAM_FSL_CSSP_Customer, new Set<Id>{conProApp.IAM_User__c});
                    }
                }
            }
        }	
        
        System.debug('Printing application name set'+appNameSet);
        List<PermissionSet> permissionSetList = new List<PermissionSet>();
        //added by sandeep for 101 soql issue
        if(appNameSet.size()>0 || !guidanzRoleMap.isEmpty() || !guidanzServPortalRoleMap.isEmpty()){
        //Quering permision set id's to Map them with application name except for OAM and PC
         permissionSetList = [
            SELECT Id
                 , Label
                 , Name
                 , NamespacePrefix
                 , ProfileId
              FROM PermissionSet
             WHERE Label IN :appNameSet
                OR Label IN :guidanzRoleMap.keySet()
                OR Label IN :guidanzServPortalRoleMap.keySet()
        ];
        System.debug('Printing permision set id'+permissionSetList);
        }
        if(!permissionSetList.isEmpty()){            
            Map<String,Id> permissionSetMap = new Map<String,Id>();
            for(PermissionSet p : permissionSetList){
                permissionSetMap.put(p.Label, p.Id);
            }
            Map<String, Set<Id>> appUserMap = new Map<String, Set<Id>>();
            for(IAM_Contact_Provisioning__c conPro : conProAppList) {
                if(appNameSet.contains(conPro.IAM_Application_Name__c)) {                    
                    if(appUserMap.containsKey(conPro.IAM_Application_Name__c)) {
                        appUserMap.get(conPro.IAM_Application_Name__c).add(conPro.IAM_User__c);
                    } else {
                        appUserMap.put(conPro.IAM_Application_Name__c, new Set<Id>{conPro.IAM_User__c});
                    }
                }

            }
            if(!appUserMap.isEmpty() && !permissionSetMap.isEmpty() && !System.isFuture() 
            && !System.isBatch()) {
                for(String appName : appUserMap.keySet()){
                    //Commented by Srini : changes revoked for Guidanz automation
                    AssignPermissionSetToUsers(appUserMap.get(appName),permissionSetMap.get(appName),
                    action);
                    //Added by Srini : changes revoked for Guidanz automation
                    //lstAssignPermissionSetToUsersWrapper.add(new IAM_AssignPermissionSetToUsersWrapper(appUserMap.get(appName),permissionSetMap.get(appName),action));
                    if(appName == Label.IAM_AppName_Guidanz && !guidanzRoleMap.isEmpty()) {
                        for(String rolePSName : guidanzRoleMap.keySet()) {
                            if(action == 'Delete') {
                                //Commented by Srini : changes revoked for Guidanz automation
                                AssignPermissionSetToUsers(guidanzRoleMap.get(rolePSName),
                                permissionSetMap.get(rolePSName), action);
                                 //Added by Srini : changes revoked for Guidanz automation
                                 //lstAssignPermissionSetToUsersWrapper.add(new IAM_AssignPermissionSetToUsersWrapper(guidanzRoleMap.get(rolePSName),permissionSetMap.get(rolePSName),action));
                            }
                        }
                    }
                    /*Start-Suresh -Guidanz Service Portal Permission set deletion code */
                    if(appName == Label.IAM_AppName_GuidanzServicePortal && !guidanzServPortalRoleMap.isEmpty()) {
                        for(String PSName : guidanzServPortalRoleMap.keySet()) {
                            if(action == 'Delete') {
                                //Commented by Srini : changes revoked for Guidanz automation
                                AssignPermissionSetToUsers(guidanzServPortalRoleMap.get(PSName),
                                permissionSetMap.get(PSName), action);
                                //Added by Srini : changes revoked for Guidanz automation
                                //lstAssignPermissionSetToUsersWrapper.add(new IAM_AssignPermissionSetToUsersWrapper(guidanzServPortalRoleMap.get(PSName),permissionSetMap.get(PSName),action));
                            }
                        }
                    }
                    /*End-Suresh -Guidanz Service Portal Permission set deletion code */
                }
            }
        }

        //Added By Srini : changes revoked for Guidanz automation 
        if(!lstAssignPermissionSetToUsersWrapper.isEmpty()){
			//System.enqueueJob(new IAM_AssignPermissionSetToUsersQueueable(lstAssignPermissionSetToUsersWrapper));
		}
        
        System.debug('Printing osm map contacts'+mapofConIdOsmRoles);  
        if(!mapofConIdOsmRoles.isEmpty()){
            Map<Id,String> roleUrsIdsMap = new Map<Id,String>();
            Map<String,Id> rolepsIdSMap=new Map<String,Id>();
            String Role;
            List<user> usrList;
            Map<string,string> fedIdAndRole = new Map<string,string>();
            Map<ID, Contact> conMap = new Map<ID, Contact>([SELECT Id,IAM_Internal__c,Username__c FROM Contact Where ID IN:mapofConIdOsmRoles.keyset() AND IAM_Internal__c= true]);
            for(contact con :conMap.values()){
                fedIdAndRole.put(con.Username__c,mapofConIdOsmRoles.get(con.id));
            }
            system.debug('fedIdAndRole@@@'+fedIdAndRole);
            if(conMap.size()>0){
                
                    usrList=  [select id,Name,email,contact.CMI_Contact_Type__c,profile.name,contactID,FederationIdentifier from User where  FederationIdentifier =:conMap.values().Username__c and  isActive = True];
                  
            }
            else{
               
                usrList=  [select id,Name,email,contact.CMI_Contact_Type__c,profile.name,contactID,FederationIdentifier from User where contactid =:mapofConIdOsmRoles.keySet() and  isActive = True];
            
            }
            for(User u:usrList){
                if(u.contactID != null){
                    if(mapofConIdOsmRoles.size()>0 && mapofConIdOsmRoles.get(u.contactID).contains('OSM Storefront Admin') ){
                        Role=mapofConIdOsmRoles.get(u.contactID);
                        roleUrsIdsMap.put(u.id,mapofConIdOsmRoles.get(u.contactID));
                    }
                }
                else{ 
                    system.debug('fedIdAndRole.get(u.FederationIdentifier)@@@'+fedIdAndRole.get(u.FederationIdentifier));
                    if(fedIdAndRole.get(u.FederationIdentifier).contains('Distributor Admin') ){
                        Role=fedIdAndRole.get(u.FederationIdentifier);
                        roleUrsIdsMap.put(u.id,fedIdAndRole.get(u.FederationIdentifier));
                    }
                    if((fedIdAndRole.get(u.FederationIdentifier).contains('OSM Sales Admin')||fedIdAndRole.get(u.FederationIdentifier).contains('OSM Sales User')||fedIdAndRole.get(u.FederationIdentifier).contains('OSM Support Admin')|| fedIdAndRole.get(u.FederationIdentifier).contains('OSM Business Admin'))){
                        Role=fedIdAndRole.get(u.FederationIdentifier);
                        roleUrsIdsMap.put(u.id,fedIdAndRole.get(u.FederationIdentifier));
                    }
                }
            }
            
            if(Role =='OSM Storefront Admin' || Role =='Distributor Admin'){
                system.debug('@@@@@@'+IAM_PermissionSet_Assignment__c.getValues(Role).IAM_Permission_Set_Name__c);
                string PsNAme=IAM_PermissionSet_Assignment__c.getValues(Role).IAM_Permission_Set_Name__c;
                PermissionSet PS = new PermissionSet();
                
                PS =[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Name =:PsNAme];
                
                
                System.debug('Printing Permission set id'+PS);
                rolepsIdSMap.put(Role,ps.id);
            }else{
                if(!System.isFuture() && System.IsBatch() == false){
                    Map<string,IAM_PermissionSet_Assignment__c> cSetting =IAM_PermissionSet_Assignment__c.getall();
                    for(PermissionSet PS :[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Label =:cSetting.keySet()]){
                        if(PS.label !='OSM Storefront Admin' && PS.Label !='Distributor Admin'){
                            rolepsIdSMap.put(cSetting.get(PS.label).Name,ps.id);
                        }
                    }
                }
                System.debug('#### '+roleUrsIdsMap + 'pSMAp... '+rolePsIdsMap+' Action... ' + Action); 
            }
            if(!test.isRunningTest()){
                if(fedIdAndRole.size()>0){
                    ID jobID = System.enqueueJob(new IAM_AssignApplication_Profile_Extension(fedIdAndRole,roleUrsIdsMap,rolepsIdSMap,action));
                    System.debug('jobID'+jobID);
                }else{
                    ID jobID = System.enqueueJob(new IAM_AssignApplication_Profile_Extension(mapofConIdOsmRoles,roleUrsIdsMap,rolepsIdSMap,action));
                    System.debug('jobID'+jobID);
                }
            }
        }        
    }
    
    @future 
    public static void AssignPermissionSetToUsers (Set<Id> usersId,id pid,String Action){
        try {
            String copareId = pid;
            System.debug('begin AssignPermissionSetToUsers.......'+usersId + 'pid... '+pid+' Action... ' + Action); 
            List<PermissionSetAssignment> lstPemisionIds = [select PermissionSet.id from PermissionSetAssignment where Assignee.Id =:usersId];
            System.debug('Permission set list lstPemisionIds.......'+lstPemisionIds);   
            Set<PermissionSetAssignment> setPemisionIds = new Set<PermissionSetAssignment>();
            if(!lstPemisionIds.isEmpty()){
                setPemisionIds.addAll(lstPemisionIds);
                lstPemisionIds.clear();
                lstPemisionIds.addAll(setPemisionIds);
            }
            System.debug('Permission set list remove dulicate lstPemisionIds.......'+lstPemisionIds);   
            if(Action=='Insert'){
                List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
                
                if(!usersId.isEmpty()){
                    for (User u : [Select Id, Name FROM User Where Id IN: usersId]){ // Add fields as per your requirement...
                        boolean isNewPerm = true;
                        for(PermissionSetAssignment permisionId : lstPemisionIds){
                            String perId = permisionId.PermissionSet.id;
                            if(!Test.isRunningTest()){
                                if(copareId.equalsIgnoreCase(perId)){
                                    isNewPerm = false;
                                    System.debug('Printing isNewPerm details .....'+isNewPerm);
                                }
                            }else{
                            isNewPerm=false;
                            }
                        }
                        if(isNewPerm){
                            permissionSetList.add(new PermissionSetAssignment (PermissionSetId = pid, AssigneeId = u.Id));
                        }
                    }
                    
                    System.debug('Permission set list that is going to updated......'+permissionSetList);
                    Database.SaveResult[] saveResult=DataBase.Insert(permissionSetList,false); //Changing the Insert statement to DataBase.Insert
                } 
            }  
            //part where delete of permision sets need to written
            if(Action == 'Delete'){
                List <PermissionSetAssignment> ps=[SELECT Id from PermissionSetAssignment WHERE PermissionSetId = : pid AND AssigneeId = : usersId];
                system.debug('Printing User details and permissionsset assaignment that are going to get delete '+ps);
                Delete ps;
            }
        } catch(Exception e) {
            System.debug('#### Exception Message - ' + e.getMessage());
            String processedData = 'User Ids - ' + usersId + ' Permission Set Id - ' + pid + ' Action - ' + Action;
            IAM_ErrorHandling.IAMerrorCapture(processedData, 'AssignPermissionSetToUsers', e.getStackTraceString() + ' - ' + e.getMessage(), IAM_Assign_Application_Permissionset.class.getName());
        }
    }

    public static Boolean checkIfContactExist(Id contactId) {
        List<Contact> conList = [SELECT Id FROM Contact WHERE Id = :contactId];
        if(!conList.isEmpty()) {
            return false;
        } else {
            return true;
        }
    }
}