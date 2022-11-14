/*************************************************************************************
Name:  IAM_UserFeatureAndAccessTriggerHandler
Copyright © 2019  Cummins
**************************************************************************************
Purpose: It performs operations like updating fields on Contact Provisioning, Contact 
and User records, call LDAP group API to add/remove user to/from LDAP, call CST API, 
call RSW API, call CUMPAS API
***************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Karthik Raj Golakaram     23/04/2020     INITIAL DEVELOPMENT 
1.1      Chetan Gaikwad            10/30/2020     Made changes for CST deactivation
1.2      Shubhangi Sardar          12/03/2020     Added FT-NPBU Dignostics app logic
1.3      Shubhangi Sardar          27/04/2021     Code optimization and LDAP Sync Issue
1.4      Shubhangi Sardar          09/08/2021     Added EVL Guidanz Permission Set Changes
1.5 -    Anupam Adhikari           12/07/2021     Added changes for Conn Sol as prod issue 101 SOQL error.
1.6      Suresh Rathod			   20/01/2022     Added Cummins API portal App name in condition as to create user in miscellaneousLogiOnAfterUpdate()
1.7      Suresh Rathod             22/04/2022     Changed condition logic for Guidanz Service Portal in onAfterUpdate() as part of Guidanz Service Portal Enhancement
1.8      Chetan Gaikwad            14/07/2022     Calling CDO CreateUser and UpdateUser API for Connected Solution
1.9	     Souvik Lahiri             24/08/2022     Added chages for Guidanz Automation Flow Optimization
***************************************************************************************
**************************************************************************************/

public class IAM_UserFeatureAndAccessTriggerHandler{

    /* Validate different access for Contact Provisioning */
    public static void validateApplicationAccess(List<IAM_Contact_Provisioning__c> triggerNewList,
    Boolean isInsert, Boolean isUpdate) {
        if(isInsert) {
            List<IAM_Contact_Provisioning__c> conAccessList = new List<IAM_Contact_Provisioning__c>();
            /* Validate if logged in user has app access */
            checkIfUserHasAppAccess(triggerNewList);
            /* Before creating EDS or CST Contact Provisioning for a User it checks if it has QSOL access */
            //added changes for Conn SOl prod Issue of SOQL Error 101. Optimized to run method for EDS and CST only
            Boolean bSkipFlag = False;
            for(IAM_Contact_Provisioning__c cc : triggerNewList){
                if(cc.IAM_Application_Name__c == Label.IAM_AppName_QSOL){
                    bSkipFlag = True;
                }
                if(cc.IAM_Application_Name__c == Label.IAM_AppName_EDS || cc.IAM_Application_Name__c == Label.IAM_AppName_Promotion){
                   conAccessList.add(cc); 
                }
            }
            if(!bSkipFlag && conAccessList.size() > 0){
               isQSOLPresentBeforeEDSAndCST(conAccessList); 
            }
        }
        if(isUpdate) {
            /* Before creating EDS or CST Contact Provisioning for a User it checks if it has QSOL access */
            checkIfUserHasAppAccess(triggerNewList);
        }
    }

    /* Populate field values before inserting/updating Contact Provisioning record */
    public static void populateFieldValues(List<IAM_Contact_Provisioning__c> triggerNewList,
    Map<Id, IAM_Contact_Provisioning__c> triggerOldMap, Boolean isInsert, Boolean isUpdate) {
        if(isInsert) {
            /* Populate IAM_User__c and IAM_userId__c fields from User and Contact object */
            populateUserFields(triggerNewList, 'Insert');//CDO Preventech changes to update User Type on the basis of Role
        }
        if(isUpdate) {
            populateUserFields(triggerNewList, 'Update');//CDO Preventech changes to update User Type on the basis of Role
            /* Populate IAM_swregExpire__c and IAM_NpbuDiagExpire__c values from Role & End Date */
            populateExpirationFields(triggerNewList);
            /* Populate IAM_Remaining_Units__c value from IAM_Assigned_Units__c */
            populateRemainingCountField(triggerNewList, triggerOldMap);
        }
        updateConproActiveInactive(triggerNewList);//Added for guidanz automation optimization
    }

    /* Before app creation or edit, it checks application access for a logged in user.
    ** If no access then throws error */
    public static void checkIfUserHasAppAccess(List<IAM_Contact_Provisioning__c> newConProList) {
        Map<String, Boolean> appMap = IAM_Trigger_Check.checkApplicationAccess(userInfo.getUserId());
        System.debug('Printing application Name'+newConProList);
        System.debug('Printing logged in user id'+UserInfo.getProfileId());
        if(Limits.getQueries()<Limits.getLimitQueries()) {
            User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
            String profileName = currentUser.Profile.Name;
            if(profileName.equalsIgnoreCase(Label.IAM_Profile_Admin_User)
            || profileName.equalsIgnoreCase(Label.IAM_Profile_CSS_CPS_Advanced)
            || profileName.equalsIgnoreCase(Label.IAM_Profile_CSS_Service_Technician)
            || profileName.equalsIgnoreCase(Label.IAM_Profile_CSS_Service_Advanced)
            || profileName.equalsIgnoreCase(Label.IAM_Profile_CMI_System_Admin)
            || profileName.equalsIgnoreCase(Label.IAM_Profile_PC_Admin)
            || profileName.equalsIgnoreCase(Label.IAM_Profile_CSS_Support)) {
                for(IAM_Contact_Provisioning__c cp : newConProList) {
                    if(!appMap.isEmpty()) {
                        if(!appMap.containsKey(cp.IAM_Application_Name__c)){
                            System.debug('CAme to exception place');
                            cp.addError(Label.IAM_Insufficient_Access_Privileges);
                        } 
                    } else {
                        System.debug('CAme to exception place');
                        cp.addError(Label.IAM_Insufficient_Access_Privileges);
                    }
                }
            }
        }
    }     

    /* Populate User (IAM_User__c, IAM_userId__c) fields on Contact Provisioning record */
    public static void populateUserFields(List<IAM_Contact_Provisioning__c> conProList, String action) {
        Set<Id> contactIdSet = new Set<Id>();
        Map<Id, User> userMap = new Map<Id, User>();
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        //Code start - CDO changes for PrevenTech Role and User Type mapping -Chetan Gaikwad
        List<IAM_Application_Groups__c> lstAppGroup = IAM_Application_Groups__c.getall().values();//getting all the custom settings.
        Map<String, String> mapAppGroup = new Map<String, String>();//mapp to store application groups,roles and user type that we have from Custom settings
        for(IAM_Application_Groups__c appGrp : lstAppGroup){
            mapAppGroup.put(appGrp.IAM_Application_Name__c+appGrp.IAM_Role_Name__c, appGrp.User_Type__c);
        }
        //Code End - CDO changes for PrevenTech Role and User Type mapping -Chetan Gaikwad

        for(IAM_Contact_Provisioning__c conPro : conProList) {
            contactIdSet.add(conPro.IAM_Contact__c);
        }
        if(!contactIdSet.isEmpty() && action=='Insert') {
            contactMap = new Map<Id, Contact>([
                SELECT Id
                     , Username__c,Account.Parent.Type,Account.Parent.CMI_CId__c
                  FROM Contact
                 WHERE Id IN :contactIdSet
            ]);
            List<User> userList = [
                SELECT Id
                     , ContactId
                  FROM User
                 WHERE Contact.Id IN :contactIdSet
                   AND IsActive = true
            ];
            if(!userList.isEmpty()) {
                for(User u : userList) {
                    userMap.put(u.ContactId, u);
                }
            }
        }

    for(IAM_Contact_Provisioning__c conPro : conProList) {
        if(action == 'Insert'){
            if(!contactMap.isEmpty() 
            && String.isNotBlank(contactMap.get(conPro.IAM_Contact__c).Username__c)) {
                conPro.IAM_userId__c = contactMap.get(conPro.IAM_Contact__c).Username__c;
            }
            if(!userMap.isEmpty() && userMap.get(conPro.IAM_Contact__c) != null) {
                conPro.IAM_User__c = userMap.get(conPro.IAM_Contact__c).Id;
            }
            //added these changes for DA Enhancement - Assign parent level Account# to user as the customer list value for DA locations of type NATIONAL ACCT_CIHR - HQ.
            if(!contactMap.isEmpty() && conPro.IAM_Application_Name__c == system.label.IAM_AppName_ConnectedSolutions && contactMap.get(conPro.IAM_Contact__c).Account.Parent.Type == 'NATIONAL ACCT_CIHR - HQ'){
                conPro.IAM_DA_Customer_List__c = contactMap.get(conPro.IAM_Contact__c).Account.Parent.CMI_CId__c;                
            }
        }
        //Code start - CDO changes for PrevenTech Role and User Type mapping -Chetan Gaikwad
        if((action == 'Insert' && !contactMap.isEmpty()) || action == 'Update' ){
            system.debug('@AppName & Role check up'+mapAppGroup.containsKey(conPro.IAM_Application_Name__c+conPro.IAM_Role__c));
            if(conPro.IAM_Application_Name__c == system.label.IAM_AppName_ConnectedSolutions && mapAppGroup.containsKey(conPro.IAM_Application_Name__c+conPro.IAM_Role__c)){
                system.debug('@AppName & Role UserType value '+mapAppGroup.get(conPro.IAM_Application_Name__c+conPro.IAM_Role__c));
                conPro.IAM_User_Type__c = mapAppGroup.get(conPro.IAM_Application_Name__c+conPro.IAM_Role__c);
            }
        }
        //Code End - CDO changes for PrevenTech Role and User Type mapping -Chetan Gaikwad
    }
}
    
    /* Populate IAM_swregExpire__c for Field Test Guidanz Mobile App and
    ** IAM_NpbuDiagExpire__c for FT - NPBU Dignostics App */
    public static void populateExpirationFields(List<IAM_Contact_Provisioning__c> conProList) {
        List<IAM_App_Expiration_Codes__mdt> appExpirationCodeList = [
            SELECT Label
                 , Role_Name__c
                 , Expiration_Code__c
                 , Application_Name__c
              FROM IAM_App_Expiration_Codes__mdt
        ];
        Map<String, Map<String, String>> appExpirationMap = new Map<String, Map<String, String>>();
        for(IAM_App_Expiration_Codes__mdt app : appExpirationCodeList) {
            if(appExpirationMap.containsKey(app.Application_Name__c)) {
                appExpirationMap.get(app.Application_Name__c).put(app.Role_Name__c, app.Expiration_Code__c);
            } else {
                Map<String, String> roleExpireCodeMap = new Map<String, String>();
                roleExpireCodeMap.put(app.Role_Name__c, app.Expiration_Code__c);
                appExpirationMap.put(app.Application_Name__c, roleExpireCodeMap);
            }
        }
        if(!appExpirationMap.isEmpty()) {
            for(IAM_Contact_Provisioning__c conPro : conProList) {
                if(conPro.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_App_GuidanzMobileFieldTest)) {
                    Map<String, String> roleExpireCodeMap = appExpirationMap.get(Label.IAM_App_GuidanzMobileFieldTest);
                    if(roleExpireCodeMap.containsKey(conPro.IAM_Role__c)) {
                        conPro.IAM_swregExpire__c = getExpirationStr(
                            roleExpireCodeMap.get(conPro.IAM_Role__c), conPro.IAM_End_Date__c);
                    } 
                } 
                    
                if(conPro.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_FT_NPBU_Diagnostics)) {
                    Map<String, String> roleExpireCodeMap = appExpirationMap.get(Label.IAM_FT_NPBU_Diagnostics);
                    if(roleExpireCodeMap.containsKey(conPro.IAM_Role__c)) {
                        conPro.IAM_NpbuDiagExpire__c = getExpirationStr(
                            roleExpireCodeMap.get(conPro.IAM_Role__c), conPro.IAM_End_Date__c);
                    }
                }
            }
        }
    }
    
    /* Create Expiration String */
    public static String getExpirationStr(String prefix, Date endDate) {
        String day = String.valueOf(endDate.day());
        String month = String.valueOf(endDate.month());
        if(day.length() == 1) {
            day = 0 + day;
        }
        if(month.length() == 1) {
            month = 0 + month;
        }
        return prefix + '-' + month + '/' + day + '/' + endDate.year();
    }

    /* Update IAM_Remaining_Units__c for Guidanz Mobile Units API */
    public static void populateRemainingCountField(List<IAM_Contact_Provisioning__c> triggerNew, 
    Map<Id,IAM_Contact_Provisioning__c> triggerOldMap) {       
        for(IAM_Contact_Provisioning__c conPro : triggerNew) {
            if(conPro.IAM_Assigned_Units__c != null && conPro.IAM_Remaining_Units__c != null) {               
                if(triggerOldMap.get(conPro.Id).IAM_Assigned_Units__c < conPro.IAM_Assigned_Units__c) {
                    // It is additional count given to user
                    Integer difference = Integer.valueOf(conPro.IAM_Assigned_Units__c) 
                    - Integer.valueOf(triggerOldMap.get(conPro.Id).IAM_Assigned_Units__c);
                    conPro.IAM_Remaining_Units__c = conPro.IAM_Remaining_Units__c + difference;
                } else {
                    // Count is revoked from user. Make sure count is available to revoke.
                    Integer difference = Integer.valueOf(triggerOldMap.get(conPro.Id).IAM_Assigned_Units__c)
                    - Integer.valueOf(conPro.IAM_Assigned_Units__c);
                    if(difference <= conPro.IAM_Remaining_Units__c) {
                        conPro.IAM_Remaining_Units__c = conPro.IAM_Remaining_Units__c - difference;
                    }                    
                }
            }
        }
    }

    /* Check if QSOL app is available on Contact before creating EDS and CST apps for HQ and 
    ** Internal locations. If not, then show error */
    public static void isQSOLPresentBeforeEDSAndCST(List<IAM_Contact_Provisioning__c> conProList) {
        Set<String> appNameSet = new Set<String>();
        Set<Id> contactIdSet = new Set<Id>();
        Map<Id, Contact> contactMap;
        Set<Id> contactWithQSOLAccessSet = new Set<Id>();
        for(IAM_Contact_Provisioning__c conPro : conProList) {
            appNameSet.add(conPro.IAM_Application_Name__c);
            contactIdSet.add(conPro.IAM_Contact__c);
        }
        Map<Id, Account> accountMap = new Map<Id, Account>();
        if(!contactIdSet.isEmpty()) {
            contactMap = new Map<Id, Contact>([
                SELECT Id
                     , Account.Id
                     , Account.ParentId
                     , Account.Type
                  FROM Contact
                 WHERE Id = :contactIdSet
            ]);
            List<IAM_Contact_Provisioning__c> qsolAppList = [
                SELECT Id
                     , IAM_Contact__c
                  FROM IAM_Contact_Provisioning__c
                 WHERE IAM_Contact__c IN : contactIdSet
                   AND IAM_Application_Name__c = :Label.IAM_AppName_QSOL
            ];
            for(IAM_Contact_Provisioning__c conPro : qsolAppList) {
                contactWithQSOLAccessSet.add(conPro.IAM_Contact__c);
            }
        }
            
        if(!appNameSet.isEmpty() && !appNameSet.contains(Label.IAM_AppName_QSOL) && !contactMap.isEmpty()) {
            for(IAM_Contact_Provisioning__c conPro : conProList) {
                if(contactMap.get(conPro.IAM_Contact__c).Account.Type != 'Internal'
                && !contactWithQSOLAccessSet.contains(conPro.IAM_Contact__c)
                && !(contactMap.get(conPro.IAM_Contact__c).Account.Id == Label.IAM_TEC_Location_HQ_ID
                || contactMap.get(conPro.IAM_Contact__c).Account.ParentId == Label.IAM_TEC_Location_HQ_ID)) {
                    if(conPro.IAM_Application_Name__c == Label.IAM_AppName_EDS) {
                        conPro.addError(Label.IAM_EDS_no_QSOL_error);
                    } else if(conPro.IAM_Application_Name__c == Label.IAM_AppName_Promotion) {
                        conPro.addError(Label.IAM_CST_no_QSOL_error);
                    }
                }
            }
        }
    }

    public static void onAfterInsert(List<IAM_Contact_Provisioning__c> triggerNew,
    Map<Id,IAM_Contact_Provisioning__c> triggerNewMap, Map<Id,IAM_Contact_Provisioning__c> triggerOldMap,
    Boolean isInsert, Boolean isUpdate) {
        
        System.debug('#### IAM_contactHelperClass.isFirstTimeUserAccessandFeatureTrigger - '
        + IAM_contactHelperClass.isFirstTimeUserAccessandFeatureTrigger);

        if(IAM_contactHelperClass.isFirstTimeUserAccessandFeatureTrigger){
            try {
                IAM_contactHelperClass.isFirstTimeUserAccessandFeatureTrigger = false;
                List<IAM_Contact_Provisioning__c> conProList;
                set<Id> conProSetId = new set<Id>();//added by sandeep for 101 soql issue
               /* if(Limits.getQueries() < Limits.getLimitQueries()) {
                    conProList = getContactProvisioningList(triggerNewMap.keySet());     
                }*/

                Map<String,String> rswConStatusMap = new Map<String,String>();
                Set<Id> rswPendingAppIdSet = new Set<Id>();
                Set<Id> pcRLSAppIdSet = new Set<Id>();
                Set<Id> cdoAppIdSet = new Set<Id>();//CDO CrateUser API
                Set<Id> guiServicePortalUserIdSet = new Set<Id>();
                for(IAM_Contact_Provisioning__c conPro : triggerNew){
                    if(conPro.IAM_Application_Name__c == Label.IAM_RSW_App){
                        rswConStatusMap.put(conPro.IAM_Contact__c, conPro.IAM_Status__c);
                        if(conPro.IAM_Status__c == Label.IAM_Status_Pending) {
                            rswPendingAppIdSet.add(conPro.Id);
                        }
                    }
                    if((conPro.IAM_Application_Name__c == Label.IAM_AppName_ProductConnectivity
                    || conPro.IAM_Application_Name__c == Label.IAM_AppName_RepairLogisticsServices)
                    && conPro.IAM_Contact__c != null && conPro.IAM_Role__c != null 
                    && conPro.IAM_User__c != null && conPro.IAM_Status__c == Label.IAM_Active) {
                        pcRLSAppIdSet.add(conPro.Id);
                    }
                    if(conPro.IAM_Application_Name__c == Label.IAM_AppName_GuidanzServicePortal
                    && conPro.IAM_Contact__c != null && conPro.IAM_Role__c != null 
                    && conPro.IAM_User__c != null && conPro.IAM_Status__c == Label.IAM_Active) {
                        guiServicePortalUserIdSet.add(conPro.IAM_User__c);
                    }
                    if(conPro.IAM_Application_Name__c != Label.IAM_OSM_App_Name){
                        conProSetId.add(conPro.Id);
                    }
                    //code start - call CDO outbound call for New User
                    if(conPro.IAM_Application_Name__c == Label.IAM_AppName_ConnectedSolutions && !conPro.IAM_From_CDO__c){
                        if(conPro.IAM_Status__c == Label.IAM_Active || conPro.IAM_Status__c == 'Pending') {
                            cdoAppIdSet.add(conPro.Id);
                        }
                    }
                    //code end - call CDO outbound call for New User

                }
                if(Limits.getQueries() < Limits.getLimitQueries()) {
                    conProList = getContactProvisioningList(conProSetId);     
                }
                
                if(!rswPendingAppIdSet.isEmpty()) {
                    callRSWAPI(rswPendingAppIdSet);
                }
                if(!rswConStatusMap.isEmpty()) {
                    updateRSWFieldOnContact(rswConStatusMap);
                }
                if(!pcRLSAppIdSet.isEmpty()) {
                    updateUserAppAttrForRLSAndPC(pcRLSAppIdSet, isInsert, isUpdate);
                } 
                if(!guiServicePortalUserIdSet.isEmpty()) {
                    updateProfileAndPSGuiSerPortalUser(guiServicePortalUserIdSet);
                }  
                //code start - call CDO outbound call for New User
                if(!cdoAppIdSet.isEmpty()) {
                    callCDOAPI(cdoAppIdSet,'create');
                }
                //code end - call CDO outbound call for New User            
                callLDAPServicesAPI(conProList, triggerOldMap, isInsert, isUpdate);
                callCSTServicesAPI(triggerNew, triggerOldMap, isInsert, isUpdate);
                callCUMPASServicesAPI(triggerNew, triggerOldMap, isInsert, isUpdate);
                updateContactAttributes(triggerNew, triggerOldMap, isInsert, isUpdate);
                
            } catch(Exception ex){
                System.debug('#### Exception Message - ' + ex.getMessage());
                IAM_ErrorHandling.IAMerrorCapture('', 'onAfterInsert method', 
                ex.getStackTraceString() + ' - ' + ex.getMessage(),
                IAM_UserFeatureAndAccessTriggerHandler.class.getName());
            }
        }
    }

    /* Create/Update Contact, User. Call LDAP, CST, CUMPAS API */
    public static void onAfterUpdate (List<IAM_Contact_Provisioning__c> triggerNew,
    Map<Id,IAM_Contact_Provisioning__c> triggerNewMap, Map<Id,IAM_Contact_Provisioning__c> triggerOldMap,
    Boolean isInsert, Boolean isUpdate){
        
        System.debug('#### IAM_contactHelperClass.isFirstTimeUserAccessandFeatureTrigger '
        + IAM_contactHelperClass.isFirstTimeUserAccessandFeatureTrigger);
        if(IAM_contactHelperClass.isFirstTimeUserAccessandFeatureTrigger){
            try{
                IAM_contactHelperClass.isFirstTimeUserAccessandFeatureTrigger = false;
                List<IAM_Contact_Provisioning__c> conProList = new List<IAM_Contact_Provisioning__c>();
                if(Limits.getQueries() < Limits.getLimitQueries()){
                    conProList = getContactProvisioningList(triggerNewMap.keySet());
                }
                Set<Id> pcRLSAppIdSet = new Set<Id>();
                Set<Id> cdoAppIdSet = new Set<Id>();//CDO UpdateUser API
                List<IAM_Contact_Provisioning__c> guidanzAppList = new List<IAM_Contact_Provisioning__c>();
                Set<Id> guiServicePortalUserIdSet = new Set<Id>();
                for(IAM_Contact_Provisioning__c conPro : triggerNew) {
                    if((conPro.IAM_Application_Name__c == Label.IAM_AppName_ProductConnectivity
                    || conPro.IAM_Application_Name__c == Label.IAM_AppName_RepairLogisticsServices)
                    && conPro.IAM_Contact__c != null && conPro.IAM_Role__c != null 
                    && conPro.IAM_User__c != null && conPro.IAM_Status__c == Label.IAM_Active) {
                        pcRLSAppIdSet.add(conPro.Id);
                    }

                    System.debug('#### conPro.IAM_Application_Name__c - '+conPro.IAM_Application_Name__c);
                    System.debug('#### conPro.IAM_Status__c - '+conPro.IAM_Status__c);
                    System.debug('#### conPro.IAM_Contact__c - '+conPro.IAM_Contact__c);
                    System.debug('#### conPro.IAM_User__c - '+conPro.IAM_User__c);
                    System.debug('#### conPro.IAM_Role__c - '+conPro.IAM_Role__c);
                    System.debug('#### conPro.triggerOldMap.get(conPro.Id).IAM_Role__c - '+triggerOldMap.get(conPro.Id).IAM_Role__c);
                    System.debug('#### conPro.triggerNewMap.get(conPro.Id).IAM_Role__c - '+triggerNewMap.get(conPro.Id).IAM_Role__c);
                    
                    
                    if(conPro.IAM_Application_Name__c == Label.IAM_AppName_Guidanz &&
                    triggerNewMap.get(conPro.Id).IAM_Role__c != triggerOldMap.get(conPro.Id).IAM_Role__c
                    && conPro.IAM_Status__c == Label.IAM_Active && conPro.IAM_Contact__c != null
                    && conPro.IAM_User__c != null && conPro.IAM_Role__c != null 
                    && triggerOldMap.get(conPro.Id).IAM_Role__c != null) {
                        guidanzAppList.add(conPro);                      
                    }
                    
                    //@Suresh -Guidanz Service Portal Enhancement Changed from Status==Pending to Status!=Active 
                    if(conPro.IAM_Application_Name__c == Label.IAM_AppName_GuidanzServicePortal &&
                    triggerOldMap.get(conPro.Id).IAM_Status__c != Label.IAM_Active
                    && conPro.IAM_Status__c == Label.IAM_Active && conPro.IAM_Contact__c != null
                    && conPro.IAM_User__c != null && conPro.IAM_Role__c != null) {
                        guiServicePortalUserIdSet.add(conPro.IAM_User__c);
                    }

                    //code start - call CDO outbound call for Update User
                    if(conPro.IAM_Application_Name__c == Label.IAM_AppName_ConnectedSolutions){
                            cdoAppIdSet.add(conPro.Id);
                    }
                    //code end - call CDO outbound call for Update User
                }
                if(!pcRLSAppIdSet.isEmpty()) {
                    updateUserAppAttrForRLSAndPC(pcRLSAppIdSet, isInsert, isUpdate);
                }
                if(!guidanzAppList.isEmpty()) {
                    deleteOldGuidanzPermissionSet(guidanzAppList, triggerOldMap, isInsert, isUpdate);
                }
                if(!guiServicePortalUserIdSet.isEmpty()) {
                    updateProfileAndPSGuiSerPortalUser(guiServicePortalUserIdSet);
                }
                //code start - call CDO outbound call for Update User
                if(!cdoAppIdSet.isEmpty()) {
                    callCDOAPI(cdoAppIdSet,'update');
                }
                //code end - call CDO outbound call for Update User

                callLDAPServicesAPI(conProList, triggerOldMap, isInsert, isUpdate);
                updateContactAttributes(triggerNew, triggerOldMap, isInsert, isUpdate);
                callCSTServicesAPI(triggerNew, triggerOldMap, isInsert, isUpdate);
                callCUMPASServicesAPI(triggerNew, triggerOldMap, isInsert, isUpdate);
                miscellaneousLogiOnAfterUpdate(triggerNew, triggerOldMap, isInsert, isUpdate);
                
            } catch(Exception ex){
                System.debug('#### Exception Message - ' + ex.getMessage());
                IAM_ErrorHandling.IAMerrorCapture('', 'onAfterUpdate method', 
                ex.getStackTraceString() + ' - ' + ex.getMessage(),
                IAM_UserFeatureAndAccessTriggerHandler.class.getName());
            }
        } 
    }    
    
    /* Logic to be called on after update */
    public static void miscellaneousLogiOnAfterUpdate (List<IAM_Contact_Provisioning__c> triggerNew, 
    Map<Id,IAM_Contact_Provisioning__c> triggerOldMap, Boolean isInsert, Boolean isUpdate){
        
        Set<Id> UpdateConProvID = new Set<Id>();
        Set<Id> setConAppIdArcher = new Set<Id>();
        Set<id> setAppIdArcher = new Set<Id>();

        if(isUpdate){
            for(IAM_Contact_Provisioning__c conPro : triggerNew) {                
                if(triggerOldMap.get(conPro.Id).IAM_Status__c != Label.IAM_Active 
                && conPro.IAM_Status__c == Label.IAM_Active
                && conPro.IAM_Active_Contact_Provisioning__c == null) {
                    updateConProvID.add(conPro.Id);
                }
                  //Added Cummins API portal App name in condition as to create user after user provision is Active from Approval process(Reusing IAM_Archer_User_Creation class for Cummins API portal app User creation )-Suresh 20/01/2022
                /* Code to hanlde Archer requirement on user provision request handler */
                if((conPro.IAM_Application_Name__c == Label.IAM_Application_Name_Archer||conPro.IAM_Application_Name__c == Label.IAM_Application_Name_Cummins_API_Portal) && conPro.IAM_Contact__c != null 
                && conPro.IAM_Role__c != null && conPro.IAM_Status__c == Label.IAM_Active )
            	 {
                    System.debug('#### Printing inside application Archer');
                    setConAppIdArcher.add(conPro.IAM_Contact__c);
                    setAppIdArcher.add(conPro.id);
                }
            }
        }
        System.debug('#### updateConProvID - '+updateConProvID);
        if(!updateConProvID.isEmpty()){
            IAM_Contact_Prov_Helper.UpdateToActive(updateConProvID);
        }
        
        System.debug('#### setAppIdArcher - ' + setAppIdArcher);
        System.debug('#### setConAppIdArcher - ' + setConAppIdArcher);
        if(!setAppIdArcher.isEmpty()&&!setConAppIdArcher.isEmpty()){
        System.debug('Calling Archer user create class');
            IAM_Archer_User_Creation.createUser(setConAppIdArcher,setAppIdArcher);
        }        
    }

    /* Call LDAP Services to add/remove user to/from LDAP application group */
    public static void callLDAPServicesAPI(List<IAM_Contact_Provisioning__c> conProList,
    Map<Id, IAM_Contact_Provisioning__c> triggerOldMap, Boolean isInsert,
    Boolean isUpdate) {
        if(isInsert) {
            IAM_LDAP_Util_group.invokeapexcallout(conProList);
        }
        if(isUpdate) {
            List<IAM_Contact_Provisioning__c> ldapGroupCallAppList = 
            new List<IAM_Contact_Provisioning__c>();
            Map<Id, String> rolesToBeAddedMap = new Map<Id, String>();
            Map<Id, String> rolesToBeRemovedMap = new Map<Id, String>();
            List<String> rolesToBeAddedList;
            List<String> rolesToBeRemovedList;
            List<String> oldRoleList;
            List<String> newRoleList;

            for(IAM_Contact_Provisioning__c conPro : conProList) {

                if(conPro.IAM_Application_Name__c != null && conPro.IAM_Contact__c != null 
                && conPro.IAM_Role__c != null) {

                    /* If contact provisioning status is changed then call both group api */
                    if((conPro.IAM_Status__c != triggerOldMap.get(conPro.Id).IAM_Status__c)
                    && (conPro.IAM_Role__c == triggerOldMap.get(conPro.Id).IAM_Role__c)) {
                        ldapGroupCallAppList.add(conPro);
                    }

                    /* If contact provisioning role is changes then call individual group api */
                    if(conPro.IAM_Status__c == Label.IAM_Active
                    && (conPro.IAM_Role__c != triggerOldMap.get(conPro.Id).IAM_Role__c)) {
                        oldRoleList = new List<String>();
                        newRoleList = new List<String>();
                        rolesToBeAddedList = new List<String>();
                        rolesToBeRemovedList = new List<String>();
                        oldRoleList = triggerOldMap.get(conPro.Id).IAM_Role__c.split(';');
                        newRoleList = conPro.IAM_Role__c.split(';');
                        for(String oldRole: oldRoleList){
                            System.debug('Value Comparing in the old roles loop'+oldRole);
                            if(!newRoleList.contains(oldRole) && String.isNotBlank(oldRole)) {
                                /* If a old role is not present in the newroles list that means 
                                ** it is removed.then we need to add it to remove set. */
                                rolesToBeRemovedList.add(oldRole);
                            }
                        }
                        System.debug('#### rolesToBeRemovedList - '+rolesToBeRemovedList); 
                        if(!rolesToBeRemovedList.isEmpty()) {
                            String rolesToRemove = String.join(rolesToBeRemovedList, ';');
                            rolesToBeRemovedMap.put(triggerOldMap.get(conPro.Id).Id, rolesToRemove);
                        }                       
                        for(String newRole: newRoleList){
                            System.debug('Value that is being compare in the new role loop'+newRole);
                            if(!oldRoleList.contains(newRole) && String.isNotBlank(newRole)){
                                /* If new role is not Present in olRoles List that means it got added.
                                ** Addin this new String to toAdd set. */
                                rolesToBeAddedList.add(newRole);
                            }
                        }
                        System.debug('#### rolesToBeAddedList - '+rolesToBeAddedList); 
                        if(!rolesToBeAddedList.isEmpty()) {
                            String rolesToAdd = String.join(rolesToBeAddedList, ';');
                            rolesToBeAddedMap.put(conPro.Id, rolesToAdd);
                        }
                    }
                }
            }
            if(!ldapGroupCallAppList.isEmpty()) {
                IAM_LDAP_Util_group.invokeapexcallout(ldapGroupCallAppList);
            }
            System.debug('#### rolesToBeRemovedMap - '+rolesToBeRemovedMap);
            if(!rolesToBeRemovedMap.isEmpty()){
                IAM_RC_DeleteUserFromGroup.basicAuthCallout(rolesToBeRemovedMap.keySet(),
                rolesToBeRemovedMap, true);
            }            
            System.debug('#### rolesToBeAddedMap - '+rolesToBeAddedMap);
            if(!rolesToBeAddedMap.IsEmpty()) {
                IAM_RC_UserGroupMapping.basicAuthCallout(rolesToBeAddedMap.keySet(),
                rolesToBeAddedMap, true);                            
            }
        }
    }
    
    /* Call CST Services API */
    public static void callCSTServicesAPI(List<IAM_Contact_Provisioning__c> conProList,
    Map<Id, IAM_Contact_Provisioning__c> triggerOldMap, Boolean isInsert, Boolean isUpdate) {
        if(isInsert) {
            Set<Id> serviceTrainingIdSet = new Set<Id>();
            Set<Id> blankServiceTrainingIdSet = new Set<Id>();
            Set<Id> inactivatedCSTAppIdSet = new Set<Id>();
            for(IAM_Contact_Provisioning__c conPro : conProList) {                    
                if(conPro.IAM_Application_Name__c == Label.IAM_AppName_Promotion) {
                    if(conPro.IAM_Status__c == Label.IAM_Active) {
                        if(String.isNotBlank(conPro.IAM_Promotion__c)) {
                            serviceTrainingIdSet.add(conPro.Id);
                        } else {
                            blankServiceTrainingIdSet.add(conPro.Id);
                        }
                    }
                    if(conPro.IAM_Contact__c != null 
                    && conPro.IAM_Status__c == Label.IAM_Inactive_Label) {
                        inactivatedCSTAppIdSet.add(conPro.Id);
                    }
                }    
            }
            if(!serviceTrainingIdSet.isEmpty()) {
                IAM_CSTServiceTrnIdUpdateCallout.cstUserServiceTrainingIdUpdate(serviceTrainingIdSet);
            }
            if(!blankServiceTrainingIdSet.isEmpty()) {
                IAM_CSTUserOutboundHelper.CstOutboundCall(blankServiceTrainingIdSet);
            }
            if(!inactivatedCSTAppIdSet.isEmpty()) {
                IAM_CSTUserStatusOutboundHelper.CstUserStatusUpdate(inactivatedCSTAppIdSet);
            }
        }

        if(isUpdate) {
            Set<Id> blankServiceTrainingIdSet = new Set<Id>();
            Set<Id> inactivatedCSTAppIdSet = new Set<Id>();
            for(IAM_Contact_Provisioning__c conPro : conProList) {                    
                if(conPro.IAM_Application_Name__c == Label.IAM_AppName_Promotion) {
                    if(triggerOldMap.get(conPro.Id).IAM_Status__c != Label.IAM_Active
                    && conPro.IAM_Status__c == Label.IAM_Active
                    && String.isBlank(conPro.IAM_Promotion__c)) {
                        blankServiceTrainingIdSet.add(conPro.Id);
                    }
                    if(conPro.IAM_Contact__c != null 
                    && triggerOldMap.get(conPro.Id).IAM_Status__c == Label.IAM_Active
                    && conPro.IAM_Status__c == Label.IAM_Inactive_Label) {
                        inactivatedCSTAppIdSet.add(conPro.Id);
                    }
                }    
            }
            if(!blankServiceTrainingIdSet.isEmpty()) {
                IAM_CSTUserOutboundHelper.CstOutboundCall(blankServiceTrainingIdSet);
            }
            if(!inactivatedCSTAppIdSet.isEmpty()) {
                IAM_CSTUserStatusOutboundHelper.CstUserStatusUpdate(inactivatedCSTAppIdSet);
            }
        }
    }

    /* When CUMPAS application access is removed in IAM, send these details to CUMPAS */
    public static void callCUMPASServicesAPI(List<IAM_Contact_Provisioning__c> conProList,
    Map<Id, IAM_Contact_Provisioning__c> triggerOldMap, Boolean isInsert, Boolean isUpdate) {
        if(isInsert || isUpdate) {
            Set<Id> inactivatedCUMPASAppIdSet = new Set<Id>();
            for(IAM_Contact_Provisioning__c conPro : conProList) {  

                if(conPro.IAM_Application_Name__c == Label.IAM_AppName_Cumpas && conPro.IAM_Contact__c != null
                && conPro.IAM_Status__c == Label.IAM_Inactive_Label) {
                    inactivatedCUMPASAppIdSet.add(conPro.Id);
                }
                if(!inactivatedCUMPASAppIdSet.isEmpty()) {
                    IAM_UserApp_Deactivation.deactivateCallOut(inactivatedCUMPASAppIdSet);
                }
            }
        }
    }

    /* Update IAM_IsRSW__c field on Contact object if RSW Contact Provisioning Status is set to true */
    @future
    public static void updateRSWFieldOnContact(Map<String,String> rswConStatusMap) {
        try {
            List<Contact> conListUpdate = new List<Contact>();
            if(!rswConStatusMap.isEmpty()){
                List<Contact> conList = [
                    SELECT Id
                         , IAM_IsRSW__c
                      FROM Contact 
                     WHERE Id IN :rswConStatusMap.keyset()
                ];
                for(Contact cn:conList) {
                    if(rswConStatusMap.get(cn.id) == Label.IAM_Active) {
                        cn.IAM_IsRSW__c = true;
                    } else {
                        cn.IAM_IsRSW__c = false;
                    }
                    conListUpdate.add(cn);
                }
                update conListUpdate;
            }
        } catch(Exception ex) {
            System.debug('#### Exception Message - ' + ex.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(''+rswConStatusMap, 'updateRSWFieldOnContact method', 
            ex.getStackTraceString() + ' - ' + ex.getMessage(),
            IAM_UserFeatureAndAccessTriggerHandler.class.getName());
        }
    }

    //Method to update the user record on creation or updation 
    @future
    public static void updateUserAppAttrForRLSAndPC(Set<Id> idSet,Boolean isInsert, Boolean isUpdate) {
        Set<Id> appUserIdSet = new set<id>();
        try {
            List<IAM_Contact_Provisioning__c> appList = [
                SELECT IAM_User__c
                     , IAM_Application_Name__c
                     , IAM_Role__c
                     , IAM_DA_Calibaration_Role__c
                     , IAM_DA_Customer_List__c
                     , IAM_RLS_Group_Admin_Email__c
                     , IAM_RLS_Customer_Number__c
                  FROM IAM_Contact_Provisioning__c
                 WHERE Id IN :idSet
            ];
            if(isInsert || isUpdate) {
                for(IAM_Contact_Provisioning__c conPro : appList) {
                    appUserIdSet.add(conPro.IAM_User__c);
                }
                if(!appUserIdSet.isEmpty() && !appList.isEmpty()) {
                    Map<Id, User> userMap = new Map<Id, User>([
                        SELECT Id
                             , Contact.Id
                             , Username
                             , CMI_Calibration_Role__c
                             , CMI_Customer_List__c
                             , RLS_Admin_Group_Email__c
                             , RLS_Customer_Number__c
                             , RLS_Role__c
                          FROM User
                         WHERE Id = :appUserIdSet
                    ]);
                    List<User> userToUpdateList = new List<User>();
                    for(IAM_Contact_Provisioning__c conPro : appList) {
                        if(userMap.containsKey(conPro.IAM_User__c)) {
                            User u = userMap.get(conPro.IAM_User__c);
                            if(conPro.IAM_Application_Name__c == Label.IAM_AppName_ProductConnectivity) {
                                u.CMI_Calibration_Role__c = conPro.IAM_DA_Calibaration_Role__c;
                                u.CMI_Customer_List__c = conPro.IAM_DA_Customer_List__c;
                            }
                            if(conPro.IAM_Application_Name__c == Label.IAM_AppName_RepairLogisticsServices) {
                                u.RLS_Admin_Group_Email__c = conPro.IAM_RLS_Group_Admin_Email__c;
                                u.RLS_Customer_Number__c = conPro.IAM_RLS_Customer_Number__c;
                                u.RLS_Role__c = conPro.IAM_Role__c;
                            }
                            userToUpdateList.add(u);
                        }
                    }
                    if(!userToUpdateList.isEmpty()) {
                        update userToUpdateList;
                    }
                }
            }          
        } catch(Exception ex) {
            System.debug('#### Exception Message - ' + ex.getMessage());
            IAM_ErrorHandling.IAMerrorCapture('' + appUserIdSet, 'updateUserAppAttributes method', 
            ex.getStackTraceString() + ' - ' + ex.getMessage(),
            IAM_UserFeatureAndAccessTriggerHandler.class.getName());
        }
    }

    /* Update Contact Attributes */
    public static void updateContactAttributes(List<IAM_Contact_Provisioning__c> conProList,
    Map<Id, IAM_Contact_Provisioning__c> triggerOldMap, Boolean isInsert, Boolean isUpdate) {
        
        if(isInsert) {
            List<IAM_Contact_Provisioning__c> appContactToUpdateList = 
            new List<IAM_Contact_Provisioning__c>();
            for(IAM_Contact_Provisioning__c conPro : conProList) {
                if(conPro.IAM_Status__c == Label.IAM_Active){
                    appContactToUpdateList.add(conPro);
                } else if(conPro.IAM_Status__c == Label.IAM_Inactive_Label) {
                    if(UserInfo.getUiThemeDisplayed() == 'Theme4d' 
                    && IAM_contactHelperClass.isRejectReasonFirstTime == true){
                        system.debug('======Inside if rejection====');
                        IAM_contactHelperClass.isRejectReasonFirstTime = false;
                        IAM_contactHelperClass.updateRejectReason(conPro.Id, conPro.IAM_Reject_Reason__c,
                        conPro.IAM_Reason__c);
                    }
                }
            }
            if(!appContactToUpdateList.isEmpty()){
                IAM_contactHelperClass.updateApplicationContact(appContactToUpdateList);
            }
        }
        if(isUpdate) {
            List<IAM_Contact_Provisioning__c> appContactToUpdateList = 
            new List<IAM_Contact_Provisioning__c>();
            List <ProcessInstanceStep> stepRejectsRecords;
            Map<Id, ProcessInstanceStep> mapRejectContApp = new Map<Id, ProcessInstanceStep>();                
            if(Limits.getQueries()<Limits.getLimitQueries()){
                stepRejectsRecords = [
                    SELECT Processinstance.targetobject.firstname
                         , Comments
                         , Id
                      FROM ProcessInstanceStep 
                     WHERE StepStatus = :Label.IAM_Rejected_Label
                ];
            }                           
            for(ProcessInstanceStep rejStep : stepRejectsRecords){
                mapRejectContApp.put(rejStep.processinstance.targetobject.id, rejStep);
            }
                  
            for(IAM_Contact_Provisioning__c conPro : conProList) {
                /*if(conPro.IAM_Status__c != triggerOldMap.get(conPro.Id).IAM_Status__c
                || conPro.IAM_Assigned_Units__c != triggerOldMap.get(conPro.Id).IAM_Assigned_Units__c
                || conPro.IAM_swregExpire__c != triggerOldMap.get(conPro.Id).IAM_swregExpire__c
                || conPro.IAM_Qsolexpiration__c != triggerOldMap.get(conPro.Id).IAM_Qsolexpiration__c
                || conPro.IAM_NpbuDiagExpire__c != triggerOldMap.get(conPro.Id).IAM_NpbuDiagExpire__c) {
                    appContactToUpdateList.add(conPro);
                }*/

                if(mapRejectContApp.containsKey(conPro.Id)
                && IAM_contactHelperClass.isRejectcommentFirstTime) {
                    IAM_contactHelperClass.isRejectcommentFirstTime = false;
                    IAM_contactHelperClass.updateRejectReason(conPro.Id, conPro.IAM_Reject_Reason__c,
                    mapRejectContApp.get(conPro.Id).Comments);
                }   
                    
                if(UserInfo.getUiThemeDisplayed() == 'Theme4d' 
                && IAM_contactHelperClass.isRejectReasonFirstTime 
                && conPro.IAM_Status__c == Label.IAM_Inactive_Label) {
                    IAM_contactHelperClass.isRejectReasonFirstTime = false;
                    IAM_contactHelperClass.updateRejectReason(conPro.Id, conPro.IAM_Reject_Reason__c,
                    conPro.IAM_Reason__c);
                }   
            }
            IAM_contactHelperClass.updateApplicationContact(conProList);
        }
    }

    /* It invokes RSW API when RSW Contact Provisioning record is created with Pending status */
    public static void callRSWAPI (Set<Id> idSet){        
        for(Id conProId : idSet) {
            System.debug('#### Making RSW API Call');
            IAM_RSWOutboundHelper.RSWOutboundCall(conProId);
        }
    }
    /* It invokes CDO API when CDO Contact Provisioning record is created with Active status */
    public static void callCDOAPI (Set<Id> idSet, String action){        
        for(Id conProId : idSet) {
            System.debug('#### Making CDO API Call');
            IAM_CDO_OutboundHelper.CDOOutboundCall(conProId,action);
        }
    }

    /* Return app list of triggered apps */
    public static List<IAM_Contact_Provisioning__c> getContactProvisioningList(Set<Id> conProAppIdSet) {
        return [
            SELECT Id
                 , IAM_Application_Name__c
                 , IAM_Assigned_Units__c
                 , IAM_Promotion__c
                 , IAM_Reject_Reason__c
                 , IAM_swregExpire__c
                 , IAM_Qsolexpiration__c
                 , IAM_NpbuDiagExpire__c
                 , IAM_Contact__c
                 , IAM_Role__c
                 , IAM_Status__c
                 , IAM_User__c
                 , IAM_User__r.IsActive
                 , IAM_Contact__r.IAM_Contact_Status__c
                 , IAM_Contact__r.IAM_Internal__c
                 , IAM_Reason__c
                 , IAM_contact__r.IAM_Ext_Legacy_Uid__c
                 , IAM_Contact__r.IAM_Legacy_User__c
              FROM IAM_Contact_Provisioning__c
             WHERE Id IN :conProAppIdSet
        ];
    }

    /* It deletes the EVL Guidanz Permission Set related to old role */
    public static void deleteOldGuidanzPermissionSet(List<IAM_Contact_Provisioning__c> conProList,
    Map<Id, IAM_Contact_Provisioning__c> triggerOldMap, Boolean isInsert, Boolean isUpdate) {
        if(isUpdate) {
            Map<String, Set<Id>> permissionSetToDeleteUserMap = new Map<String, Set<Id>>();
            for(IAM_Contact_Provisioning__c conPro : conProList) {
            	if(triggerOldMap.get(conPro.Id).IAM_Role__c == Label.IAM_GuidanzRole_Technician) {
                    if(permissionSetToDeleteUserMap.containsKey(Label.IAM_GuidanzPSet_EVLDealerTechnician)) {
                        permissionSetToDeleteUserMap.get(Label.IAM_GuidanzPSet_EVLDealerTechnician).add(
                            conPro.IAM_User__c);
                    } else {
                        permissionSetToDeleteUserMap.put(Label.IAM_GuidanzPSet_EVLDealerTechnician, 
                                                         new Set<Id>{conPro.IAM_User__c});
                    }
                } else if(triggerOldMap.get(conPro.Id).IAM_Role__c == Label.IAM_GuidanzRole_Advanced) {
                    if(permissionSetToDeleteUserMap.containsKey(Label.IAM_GuidanzPSet_EVLDealerAdv)) {
                        permissionSetToDeleteUserMap.get(Label.IAM_GuidanzPSet_EVLDealerAdv).add(conPro.IAM_User__c);
                    } else {
                        permissionSetToDeleteUserMap.put(Label.IAM_GuidanzPSet_EVLDealerAdv, 
                                                         new Set<Id>{conPro.IAM_User__c});
                    }
                }
        	}
            if(!permissionSetToDeleteUserMap.isEmpty()) {
                List<PermissionSet> permissionSetList = [
                    SELECT Id
                         , Label
                         , Name
                      FROM PermissionSet
                     WHERE Label IN :permissionSetToDeleteUserMap.keySet()
        		];
                Map<String,Id> permissionSetMap = new Map<String,Id>();
                if(!permissionSetList.isEmpty()) {
                    for(PermissionSet p : permissionSetList){
                        permissionSetMap.put(p.Label, p.Id);
                    }
                }
                if(!permissionSetMap.isEmpty()) {
                    for(String psKey : permissionSetToDeleteUserMap.keySet()) {
                        System.debug('#### psKey to delete - '+ psKey);
                        System.debug('#### psKey users - '+ permissionSetToDeleteUserMap.get(psKey));
                        IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(
                            permissionSetToDeleteUserMap.get(psKey), permissionSetMap.get(psKey), 'Delete');
                        System.debug('#### psKey to delete 1 - '+ psKey);
                        System.debug('#### psKey users 1 - '+ permissionSetToDeleteUserMap.get(psKey));
                    }
                }
            }
        }
    }

    /* Change Profile of Guidanz Service Portal user's profile and Permission Set */
    @future
    public static void updateProfileAndPSGuiSerPortalUser(Set<Id> userIdSet) {
        List<User> userList = [SELECT ProfileId FROM User WHERE Id = :userIdSet];
        if(!userList.isEmpty()) {
            List<Profile> fslCummunityProfile = [
                SELECT Id
                  FROM Profile
                 WHERE Name = :Label.IAM_FSLProfile_GuiCustCommunityUser
            ];
            List<User> userToUpdateList = new List<User>();
            if(!fslCummunityProfile.isEmpty()) {
                for(User usr : userList) {
                    usr.ProfileId = fslCummunityProfile[0].Id;
                    userToUpdateList.add(usr);
                }
            }

            List<PermissionSet> permissionSetList = [
                SELECT Id
                    , Label
                    , Name
                    , ProfileId
                FROM PermissionSet
                WHERE Label = :Label.IAM_FSL_CSSP_Customer
                   OR Label = :Label.IAM_AppName_GuidanzServicePortal
            ];

            /* Get existing Permission Set Assignment of a User */
            List<PermissionSetAssignment> existingPSAssignmentList = [
                SELECT Id
                     , PermissionSetId
                     , AssigneeId
                  FROM PermissionSetAssignment
                 WHERE AssigneeId IN :userIdSet
            ];
            System.debug('#### existingPSAssignmentList - '+existingPSAssignmentList);

            /* New Permission Set to assign */
            List<PermissionSetAssignment> psAssignmentList = new List<PermissionSetAssignment>();
            if(!permissionSetList.isEmpty()) {
                for (User usr : userList) {
                    for (PermissionSet ps : permissionSetList) {
                        psAssignmentList.add(new PermissionSetAssignment (
                        PermissionSetId = ps.Id,
                        AssigneeId = usr.Id));
                    }
                }
            }
            System.debug('#### New Permission Set To Assign - '+ psAssignmentList);
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

            if(!userToUpdateList.isEmpty()) {
                Database.SaveResult[] srList = Database.update(userToUpdateList, false);
                System.debug('#### srList - '+srList);
            }
            if(!psAssignmentList.isEmpty()) {
                Database.SaveResult[] srList = Database.insert(psAssignmentList, false);
                System.debug('#### srList - '+srList);
            }     
        }
    }

    public static void updateConproActiveInactive(List<IAM_Contact_Provisioning__c> conPros){
        
        system.debug('#####contact provisioning records without update--->'+conPros+'conPro Size' + conPros.size());
        
        for(IAM_Contact_Provisioning__c conPro:conPros){
            
            if(conPro.IAM_Status__c == System.Label.IAM_Active && conPro.IAM_Application_Name__c != null){
                    
                    conPro.IAM_Active_Contact_Provisioning__c = conPro.IAM_Contact__c;
                    conPro.IAM_Inactive_Contact_Provisioning__c = null;
                    
                }else if(conPro.IAM_Status__c != System.Label.IAM_Active && conPro.IAM_Application_Name__c != null){
                    
                    conPro.IAM_Active_Contact_Provisioning__c = null;
                    conPro.IAM_Inactive_Contact_Provisioning__c = conPro.IAM_Contact__c;
                    
                }
            
        }
        
        system.debug('#####contact provisioning records with update--->'+conPros+'conPro Size' + conPros.size());
        
    }

}