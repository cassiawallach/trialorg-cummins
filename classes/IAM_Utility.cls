/*************************************************************************************
Name:  IAM_Utility
Copyright © 2019  Cummins
**************************************************************************************
Purpose: This class is Utility Class to Keep the common methods useed across our IAM 
application 
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Karthik Raj Golakaram     01/16/2020        INITIAL DEVELOPMENT 
1.1      Karthik Raj Golakaram     10/23/2020     Changes to TEC Locations for CST
1.2      Karthik Raj Golakaram     01/25/2021     Changes for OSM Prod defect - INC1022619
1.3      Karthik Raj Golakaram     02/21/2021     Bulkified the copy contacts method.
1.4      Shubhangi Sardar          27/04/2021     LDAP Sync Issue Fix
1.5      Shubhangi Sardar          09/23/2021     Assign Subscription Count From Label
**************************************************************************************
**************************************************************************************/

public class IAM_Utility implements Queueable{
    
    Public Map<id,id> surviourToVictimConIdMap;
    Public List<Contact> userToCreateConList;
    
    Public IAM_Utility(Map<id,id> surviourToVictimConIdMap){
        this.surviourToVictimConIdMap=surviourToVictimConIdMap;
        this.userToCreateConList=userToCreateConList;
    }
    
    Public void execute(QueueableContext Context){
       copyContacts(surviourToVictimConIdMap);
    }
    
    //Method to return AppMapping record when we pass App id or App Name.
    Public Static App_Mapping__c getAppMapping(String appId){
        return [select id,CMI_External_Start_Url__c,Name from App_Mapping__c where id=:appId or Name=:appId LIMIT 1];        
    }
    
    //Method to update contact app id feild to blank after first time log or set password after registration.
    @Future
    Public Static void updateAppIdOnContact(Set<id> conIds){
        List<Contact> Con=[Select id,IAM_AppId__c from Contact where id=:conIds];
        if(!Con.isEmpty()){    
            for(Contact c:con){
                c.IAM_AppId__c='';
            }  
            Update Con;
        }
    }
    
    
    Public Static void  updateContacts(Set<id> conIds){
        List<Contact> contactsToUpdate= processedContacts(conIds);
        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }
        
    }
    
    
    Public Static void updateUserAttribute(Set<id> conIds){
        
        // Map<id,Contact> conMap= new Map<id,Contact>([SELECT id,IAM_Applications__c,IAM_Application_Roles__c,IAM_Qsolexpiration__c,IAM_swregexpire__c FROM Contact WHERE id=:conIds]);
        List<Contact> consToProcess=processedContacts(conIds);
        List<User> usersToUpdate= new List<User>(); 
        if(!consToProcess.isEmpty()){
            Map<id,Contact> conMap= new Map<id,Contact>();
            for(contact c:consToProcess){
                conMap.put(c.id,c);
            }
            Map<id,User> UserMap=new Map<id,User>([SELECT id,IAM_Applicationgroups__c,IAM_Application_Roles__c,IAM_Qsolexpiration__c,IAM_swregexpire__c,Contactid FROM User WHERE Contactid=:conIds AND isActive=TRUE]);
            
            if(!UserMap.isEmpty()){
                for(id u:UserMap.keySet()){
                    if(conMap.ContainsKey(UserMap.get(u).Contactid)){
                        if(conMap.get(UserMap.get(u).Contactid)!=null){
                            if(!String.isBlank((conMap.get(UserMap.get(u).Contactid)).IAM_Applications__c)){
                                UserMap.get(u).IAM_Applicationgroups__c=conMap.get(UserMap.get(u).Contactid).IAM_Applications__c;
                            }
                            if(!String.isBlank((conMap.get(UserMap.get(u).Contactid)).IAM_Application_Roles__c)){
                                UserMap.get(u).IAM_Application_Roles__c=conMap.get(UserMap.get(u).Contactid).IAM_Application_Roles__c;
                            }
                            if(!String.isBlank((conMap.get(UserMap.get(u).Contactid)).IAM_Qsolexpiration__c)){
                                UserMap.get(u).IAM_Qsolexpiration__c=conMap.get(UserMap.get(u).Contactid).IAM_Qsolexpiration__c;
                            }
                            if(!String.isBlank((conMap.get(UserMap.get(u).Contactid)).IAM_swregexpire__c)){
                                UserMap.get(u).IAM_swregexpire__c=conMap.get(UserMap.get(u).Contactid).IAM_swregexpire__c;
                            }
                            
                        }
                    }
                    usersToUpdate.add(UserMap.get(u));
                }
            }
        }
        if(!usersToUpdate.isEmpty()&&!Test.isRunningTest()){
            update UsersToUpdate; 
        }
    }
    
    Public Static Void groupLDAPCall(Map<id,String> accFeature,String action){
        Map<id,String> conAppIds=new Map<id,String>();
        conAppIds=getConAppIds(accFeature);
        if(action.equalsIgnoreCase('Add')){
            //query list of Active user access features and call rc group addition
            if(!conAppIds.isEmpty()){
                IAM_RC_UserGroupMapping.basicAuthCallout(conAppIds.KeySet(),conAppIds,True);
            } 
            
        }
        if(action.equalsIgnoreCase('Delete')){
            //query active user access features and remove from groups.
            if(!conAppIds.isEmpty()){
                IAM_RC_DeleteUserFromGroup.basicAuthCallout(conAppIds.KeySet(),conAppIds,True);
            } 
        }
        
    }
    
    Public Static Map<id,String> getConAppIds(Map<id,String> accFeature){
        Map<id,String> conAppIds= new Map<id,String>();
        List<IAM_Contact_Provisioning__c> conFeature= [SELECT id,IAM_Account_Application__r.Id FROM IAM_Contact_Provisioning__c where IAM_Account_Application__c=:accFeature.KeySet() AND IAM_Status__c='Active'];
        if(!conFeature.isEmpty()){
            for(IAM_Contact_Provisioning__c iam:conFeature){
                conAppIds.put(iam.id,accFeature.get(iam.IAM_Account_Application__r.Id));
            }
        }
        return conAppIds;   
    }
    
    //class to call  LDAP update method
    
    Public Static Void callLDAPUtilConUpdate(List<id> appIds){
        Set<id> ConIds= new Set<id>();
        List<IAM_Contact_Provisioning__c>conProv=getContactProvisioning(appIds);
        if(!conProv.isEmpty()){
            for(IAM_Contact_Provisioning__c cn: conProv){
                conIds.add(cn.IAM_Contact__r.id);
            }
            if(!conIds.isEmpty()){
                ID jobID = System.enqueueJob(new IAM_Sub_ContactUpdate_Queueable(conIds));
                System.debug('jobID'+jobID);
                List<Contact> consToSend=processedContacts(ConIds);
                System.debug('Printing debug'+consToSend);
                if(!consToSend.isEmpty()){
                    //IAM_LDAP_Util_Subcription_Callout.sendToLDAP(consToSend,'Update');
                }
            }
        }
    } 
    
    
    Public Static List<Contact> processedContacts(Set<id> conIds){
        List<Contact> returnContact= new List<Contact>();
        Map<id,Contact> conMap= new Map<id,Contact>([Select id,IAM_Applications__c,IAM_Application_Roles__c,IAM_Qsolexpiration__c,IAM_swregexpire__c from Contact where id=:conIds]);
        List<IAM_Application_Groups__c> lstAppGroup = IAM_Application_Groups__c.getall().values();//getting all the custom settings.
        Map<String,IAM_Application_Groups__c> appGrps= new Map<String,IAM_Application_Groups__c>();
        for(IAM_Application_Groups__c apgrp: lstAppGroup){
            appGrps.put((apgrp.IAM_Application_Name__c+apgrp.IAM_Role_Name__c).toUpperCase(),apgrp);   
        }
        
        Map<id,List<IAM_Contact_Provisioning__c>> toLoop= new Map<id,List<IAM_Contact_Provisioning__c>>();
        
        List<IAM_Contact_Provisioning__c> conProv=[Select id,IAM_Application_Name__c,IAM_Role__c,IAM_Qsolexpiration__c,IAM_swregexpire__c,IAM_Contact__c,IAM_Account_Application__r.IAM_Role__c,IAM_Account_Application__r.IAM_QSOLExpiration__c,IAM_Account_Application__r.IAM_swregexpire__c from IAM_Contact_Provisioning__c where IAM_Status__c='Active' and IAM_Contact__c=:conIds];
        
        for(id c :conMap.KeySet()){
            List<IAM_Contact_Provisioning__c> conSet= new List<IAM_Contact_Provisioning__c>();
            for(IAM_Contact_Provisioning__c cp:conProv){
                if(c==cp.IAM_Contact__c){
                    conSet.add(cp);
                }
            }
            toLoop.put(c,conSet);
        }
        System.debug('Printing con Prv.size'+toLoop.Size());
        
        for(id cid: conMap.KeySet()){
            String ApplicationGroups='';
            String ApplicationRoles='';
            String qsolExpiration='';
            String swregExpiration='';
            if(!toLoop.isEmpty()){
                if(toLoop.ContainsKey(cid)&&!toLoop.get(cid).isEmpty()){
                    for(IAM_Contact_Provisioning__c cps:toLoop.get(cid)){
                        if(appGrps.ContainsKey((cps.IAM_Application_Name__c+cps.IAM_Role__c).ToUpperCase())){
                            if(cps.IAM_Application_Name__c!='QuickServe Online'){
                                if(!String.isBlank(appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Role__c).ToUpperCase()).IAM_DN_value__c)){
                                    ApplicationGroups=ApplicationGroups+'|'+appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Role__c).ToUpperCase()).IAM_DN_value__c;
                                }
                                if(!String.isBlank(appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Role__c).ToUpperCase()).IAM_Role_Name__c)){
                                    ApplicationRoles=ApplicationRoles+','+ appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Role__c).ToUpperCase()).IAM_Role_Name__c;
                                }
                            }else if(cps.IAM_Application_Name__c=='QuickServe Online'){
                                if(!String.isBlank(appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Account_Application__r.IAM_Role__c).ToUpperCase()).IAM_DN_value__c)){
                                    ApplicationGroups=ApplicationGroups+'|'+appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Account_Application__r.IAM_Role__c).ToUpperCase()).IAM_DN_value__c;
                                }
                                if(!String.isBlank(appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Account_Application__r.IAM_Role__c).ToUpperCase()).IAM_Role_Name__c)){
                                    ApplicationRoles=ApplicationRoles+','+ appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Account_Application__r.IAM_Role__c).ToUpperCase()).IAM_Role_Name__c;
                                }
                            }
                        }
                        
                        if(cps.IAM_Application_Name__c == System.Label.IAM_AppName_QSOL){
                            if(String.isNotEmpty(cps.IAM_Account_Application__r.IAM_Qsolexpiration__c)){
                                system.debug('====Inside qsolExpiration check===02');
                                qsolExpiration = qsolExpiration +'|'+cps.IAM_Account_Application__r.IAM_Qsolexpiration__c;
                            }
                            
                        }
                        
                        if(cps.IAM_Application_Name__c == System.Label.IAM_Guidanz_Mobile_App_Name && String.isNotBlank(cps.IAM_Account_Application__r.IAM_swregexpire__c)){
                            system.debug('===Inside swregexpire on contact===');
                            if(!String.isBlank(cps.IAM_Account_Application__r.IAM_swregexpire__c)){
                                swregExpiration =   swregExpiration + '|' + cps.IAM_Account_Application__r.IAM_swregexpire__c;
                            }
                        }
                        
                        if(cps.IAM_Application_Name__c == Label.IAM_App_GuidanzMobileFieldTest){
                            system.debug('===Inside swregexpire on contact FT===');
                            if(String.isNotBlank(cps.IAM_swregexpire__c)){
                                swregExpiration =   swregExpiration + '|' + cps.IAM_swregexpire__c;
                            }
                        }
                    }
                    conMap.get(cid).IAM_Applications__c=ApplicationGroups.removeEnd('|').removeStart('|');
                    conMap.get(cid).IAM_Application_Roles__c=ApplicationRoles.removeEnd(',').removeStart(',');
                    conMap.get(cid).IAM_Qsolexpiration__c=qsolExpiration.removeEnd('|').removeStart('|');
                    conMap.get(cid).IAM_swregexpire__c=swregExpiration.removeEnd('|').removeStart('|');
                }else{
                    conMap.get(cid).IAM_Applications__c='';
                    conMap.get(cid).IAM_Application_Roles__c='';
                    conMap.get(cid).IAM_Qsolexpiration__c='';
                    conMap.get(cid).IAM_swregexpire__c='';
                    
                }
            }
            returnContact.add(conMap.get(cid));
        }
        
        return returnContact;   
    }
    
    private static List<IAM_Contact_Provisioning__c> getContactProvisioning(List<Id> appId) {
        return [
            SELECT Id
            , IAM_Account_Application__r.Id
            , IAM_Status__c
            , IAM_Contact__r.Id
            FROM IAM_Contact_Provisioning__c
            WHERE IAM_Account_Application__r.Id IN :appId
            AND IAM_Status__c=:Label.IAM_Status_Active
        ];
    }

    //Method to Create Account Access and Feature record for Accound ids and Application ID.
    //for tech locations
    Public Static Void CreateCSTSubscription(Set<id> accIds){
        try{
            List<IAM_Application__c> appList= new List<IAM_Application__c>();
            for(id aId:accIds){
                IAM_Application__c cstApp= new IAM_Application__c();
                cstApp.IAM_Application_Name__c=Label.IAM_Cummins_Service_Training;
                cstApp.IAM_Role__c=Label.IAM_Default_Role_CST;
                cstApp.IAM_Status__c=Label.IAM_Status_Active;
                cstApp.IAM_Account_Name__c=aId;
                cstApp.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(System.Label.IAM_Cummins_Service_Training).getRecordTypeId();
                cstApp.IAM_Subscription_Start_Date__c=System.Today();
                cstApp.IAM_Subscription_End_Date__c=Date.newInstance(2100, 12, 31);
                cstApp.IAM_Subscription_Name__c=Label.IAM_Cummins_Service_Training;
                cstApp.IAM_Free_Subscription__c=false;
                cstApp.IAM_Subscription_Count__c = Integer.valueof(Label.IAM_Default_App_Subscription_Count.trim());
                appList.add(cstApp);
            } 
            if(!appList.isEmpty()){
                insert appList;
            } 
        }catch(exception ex){
            System.debug('Printing System exception'+ex);
        }
    }

    //Method to copy the contact information from one contact to another and 
    //also contact Provisioning records. -Karthik Golakaram - INC1022619 
    Public Static Void copyContacts(Map<id,id> surviourToVictimContactIds){
        System.debug('Printing reached contact copy');
        List<sObject> sObjectsToUpdate= new List<sObject>();
        /*if(!lstActiveCont.isEmpty()){
        	id createUserJobId=System.enqueueJob(new IAM_CreateUser(lstActiveCont));   
        } */
        if(!surviourToVictimContactIds.isEmpty()){
    	List<Contact> contactsToUpdate= new List<Contact>();
		List<Contact> legacyConsToUpdate= new List<Contact>();
		List<IAM_Contact_Provisioning__c> conProvToUpdate= new List<IAM_Contact_Provisioning__c>();
		List<Contact> con=[SELECT id,FirstName,LastName,AccountId,email,Username__c,CMI_Contact_Type__c,IAM_Contact_Status__c,IAM_Applications__c
                   		   ,IAM_Application_Roles__c,IAM_is_Member_of__c,IAM_Product_Group_Access__c,IAM_Qsolexpiration__c,IAM_Qsolview__c,IAM_NpbuDiagExpire__c
                   		   ,IAM_Work_Group_Id__c,IAM_swregexpire__c,IAM_Ext_Legacy_Uid__c,IAM_Legacy_User__c,IAM_Promotion__c,IAM_Is_Merged_Contact__c,
                   (SELECT id,IAM_Contact__c,IAM_Status__c,IAM_User__c,IAM_userId__c FROM Contact_Provisionings__r WHERE IAM_Status__c='Active') FROM Contact where id=:surviourToVictimContactIds.Values()];
        List<User> usrGuidanz= [SELECT id,Username,Contactid,FederationIdentifier FROM User WHERE contactId=:surviourToVictimContactIds.keySet() AND isActive=True];
		
		Map<String,User> surviourContactMap = new Map<String,User>();
		Map<String,Contact> victimContactMap = new Map<String,Contact>();
		
		for(Contact c:con){
			if(!victimContactMap.containsKey(c.Username__c)){
				victimContactMap.put(c.Username__c,c);
			}
		}
		
		for(User u:usrGuidanz){
			if(!surviourContactMap.containsKey(u.FederationIdentifier)){
				surviourContactMap.put(u.FederationIdentifier,u);
			}	
		}
		
        System.debug('Printing victim map'+victimContactMap);
        System.debug('Printing Survivour map'+surviourContactMap);
		for(String uName:victimContactMap.KeySet()){
			Contact gzCon= new Contact(id=surviourContactMap.get(uName).contactId);
               gzCon.AccountId=victimContactMap.get(uName).AccountId;
                gzCon.FirstName=(victimContactMap.get(uName).FirstName!=null?victimContactMap.get(uName).FirstName:'');
                gzCon.LastName=(victimContactMap.get(uName).LastName!=null?victimContactMap.get(uName).LastName:'');
                //email that user entered from the Reclaim page
                gzCon.email=(victimContactMap.get(uName).email!=null?victimContactMap.get(uName).email:'');
                gzCon.Username__c=(victimContactMap.get(uName).Username__c!=null?victimContactMap.get(uName).Username__c:'');
                //Username the user enterd in reclaim Page
                /*if(label.css_org=='.cso'){
                    gzCon.Username__c=(newUsername!=null?newUsername:'');
                }else{
                    gzCon.Username__c=(newUsername!=null?newUsername+Label.css_org:'');   
                }*/
                gzCon.CMI_Contact_Type__c=(victimContactMap.get(uName).CMI_Contact_Type__c!=null?victimContactMap.get(uName).CMI_Contact_Type__c:'');
                gzCon.IAM_Contact_Status__c='Active';//Making Contact status Active since there is user already present.
                gzCon.IAM_Applications__c=(victimContactMap.get(uName).IAM_Applications__c!=null?victimContactMap.get(uName).IAM_Applications__c:'');
                gzCon.IAM_Application_Roles__c=(victimContactMap.get(uName).IAM_Application_Roles__c!=null?victimContactMap.get(uName).IAM_Application_Roles__c:'');
                gzCon.IAM_is_Member_of__c=(victimContactMap.get(uName).IAM_is_Member_of__c!=null?victimContactMap.get(uName).IAM_is_Member_of__c:'');
                gzCon.IAM_Product_Group_Access__c=(victimContactMap.get(uName).IAM_Product_Group_Access__c!=null?victimContactMap.get(uName).IAM_Product_Group_Access__c:'');
                gzCon.IAM_Qsolexpiration__c=(victimContactMap.get(uName).IAM_Qsolexpiration__c!=null?victimContactMap.get(uName).IAM_Qsolexpiration__c:'');
                gzCon.IAM_Qsolview__c=(victimContactMap.get(uName).IAM_Qsolview__c!=null?victimContactMap.get(uName).IAM_Qsolview__c:'');
                /* 12/03/2020 - Added NPBU Diagnostic Expration */
                gzCon.IAM_NpbuDiagExpire__c=(victimContactMap.get(uName).IAM_NpbuDiagExpire__c!=null?victimContactMap.get(uName).IAM_NpbuDiagExpire__c:'');
                //Work group ID should be check While inserting the Contact.
                gzCon.IAM_Work_Group_Id__c=(victimContactMap.get(uName).IAM_Work_Group_Id__c!=null?victimContactMap.get(uName).IAM_Work_Group_Id__c:'');
                gzCon.IAM_swregexpire__c=(victimContactMap.get(uName).IAM_swregexpire__c!=null?victimContactMap.get(uName).IAM_swregexpire__c:'');
                //gzCon.IAM_ABO_Code_Formula__c=victimContactMap.get(uName).IAM_ABO_Code_Formula__c;
                gzCon.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                gzCon.IAM_Ext_Legacy_Uid__c=(victimContactMap.get(uName).IAM_Ext_Legacy_Uid__c!=null?victimContactMap.get(uName).IAM_Ext_Legacy_Uid__c:'');
                gzCon.IAM_Legacy_User__c=victimContactMap.get(uName).IAM_Legacy_User__c;
                gzCon.IAM_Promotion__c=(victimContactMap.get(uName).IAM_Promotion__c!=null?victimContactMap.get(uName).IAM_Promotion__c:'');
                        
                    victimContactMap.get(uName).IAM_Ext_Legacy_UID__c='';
                    victimContactMap.get(uName).IAM_Contact_Status__c='Inactive';
                    victimContactMAp.get(uName).IAM_Is_Merged_Contact__c=True;
        			victimContactMap.get(uName).Username__c=victimContactMap.get(uName).Username__c+'merged';
			if(!victimContactMap.get(uName).Contact_Provisionings__r.isEmpty()){
				For(IAM_Contact_Provisioning__c cp:victimContactMap.get(uName).Contact_Provisionings__r){
					cp.IAM_Contact__c=gzCon.id;
					cp.IAM_Status__c='Active';
					cp.IAM_userId__c=victimContactMap.get(uName).Username__c;
					if(!usrGuidanz.isEmpty()){
						cp.IAM_User__c=usrGuidanz[0].id;      
					}
					//conProvToUpdate.add(cp);
					sObjectsToUpdate.add(cp);
                }
			}
			legacyConsToUpdate.add(victimContactMap.get(uName));
			//contactsToUpdate.add(gzCon);
			sObjectsToUpdate.add(gzCon);
		}
				
        
        
        	//List<Contact> consToUpdate=new List<Contact>{cn,gzCon};
                    
        Update legacyConsToUpdate;
            
            
        //Update contactsToUpdate;
        //Update conProvToUpdate; 
        System.debug('Printing the records gettign updated'+sObjectsToUpdate);
        Database.SaveResult[] srList=DataBase.update(sObjectsToUpdate,false);
            for(Database.SaveResult sr:srList){
                if(sr.isSuccess()){
                    System.debug('Printing the values for'+sr.getID());
                }else{
                    System.debug('Printing the false values'+sr);
                }
            }
               
        }
		
	}
    //Code Addition - INC1022619

    /* Return if object trigger is Active or not from Trigger Switch Metadata */
    public static List<IAM_Trigger_Switches__mdt> getTriggerSwitch(String objectName) {
        return [
            SELECT IAM_Active__c
              FROM IAM_Trigger_Switches__mdt
             WHERE Label = :objectName
        ];
    }

    /* Return LDAP branch name of respective user */
    public static String getBranchName(String dnVal) {
        String branchName = '';
        if(String.isNotBlank(dnVal)) {
            List<String> arr = new List<String>();
            arr = dnVal.split(',');
            branchName = arr[1].replace('ou=', '');
        }
        if(String.isBlank(branchName)) {
            branchName = 'external';
        }
        return branchName;
    }

    /* Return type of user if Internal, External or Legacy based on few Contact flags*/
    public static String getUserType(IAM_Contact_Provisioning__c icp) {
        if(icp.IAM_Contact__r.IAM_Contact_Status__c == Label.IAM_Status_Active
        && icp.IAM_Contact__r.IAM_Internal__c == true
        && icp.IAM_Contact__r.IAM_Legacy_User__c == true) {
            /* Internal User */
            return Label.IAM_Value_Internal;
        } else if((icp.IAM_Contact__r.IAM_Contact_Status__c == Label.IAM_Status_Active
        || icp.IAM_Contact__r.IAM_Contact_Status__c == Label.IAM_Inactive_Label)
        && icp.IAM_Contact__r.IAM_Internal__c == false
        && icp.IAM_Contact__r.IAM_Legacy_User__c == false) {
            /* External Non-Legacy User - After reclaim legacy flag is false for extenal users */
            return Label.IAM_Value_External;
        } else if((icp.IAM_Contact__r.IAM_Contact_Status__c == Label.IAM_Status_Active
        || icp.IAM_Contact__r.IAM_Contact_Status__c == Label.IAM_Inactive_Label
        || icp.IAM_Contact__r.IAM_Contact_Status__c == Label.IAM_Reclaim)
        && icp.IAM_Contact__r.IAM_Internal__c == false
        && icp.IAM_Contact__r.IAM_Legacy_User__c == true){
            /* External Legacy User - In this case user will be ready to reclaim but 
            not yet reached their phase. */
            return Label.IAM_Value_Legacy;
        } else {
            return '';
        }
    }


    /* Populate DN Value on Contact */
    //public static String getDNValue(String username, Boolean isLegacy, Boolean isInternal) {
            public static String getDNValue(String username,String personType) {
                     String dnValue = '';

if(String.isBlank(personType)) {
    if(String.isNotBlank(username)) {
        dnValue = 'dn: uid=' + username + ',ou=external,ou=people,dc=cummins,dc=com';
          }
       } else {
    if(personType == 'Employee') {
        dnValue = 'dn: uid=' + username + ',ou=employee,ou=people,dc=cummins,dc=com';     
    } else {
        dnValue = 'dn: uid=' + username + ',ou=other,ou=people,dc=cummins,dc=com'; 
    }
        /*String dnValue = '';
        if(!isLegacy && String.isNotBlank(username)) {
            if(isInternal) {
                dnValue = 'uid=' + username + ',ou=employee,ou=people,dc=cummins,dc=com';     
            } else if(!isInternal) {
                dnValue = 'uid=' + username + ',ou=external,ou=people,dc=cummins,dc=com';   
            }
        }
        return dnValue;*/
      }
      return dnValue;
            }


}