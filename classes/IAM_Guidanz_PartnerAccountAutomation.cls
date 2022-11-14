/**************************************************************************
Name:  IAM_Guidanz_PartnerAccountAutomation
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class will handle the license change of users from Customer
community to partner community when Partner Account checkbox is checked
in Account record
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -     Anupam Adhikari              23/12/2021        INITIAL DEVELOPMENT 
1.1 -     Suresh Rathod Nanavath       18/05/2022        Enhancement- Added RSW,Cumpas 2.0 users to process along with EDS to create Guidanz access,
														 Made changes to handle and process bulk records
1.2 -     Suresh Rathod Nanavath       29/05/2022        Added code to bypass initilization of values in ContactTriggerHandlerNew to resolve Apex CPU Time limit
1.3	-     Souvik Lahiri                24/08/2022        Added chages for Guidanz Automation Flow Optimization
******************************************************************************/

public class IAM_Guidanz_PartnerAccountAutomation extends TriggerHandler{
    
    public static void processPartnerAccounts(Set<Id> acctIdSet){
        
        Set<Id> activeContactId = new Set<Id>();
        List<Contact> conListOfPartnerAcc = new List<Contact>();
        List<Contact> actvConListPartnrAcc = new List<Contact>();
        Boolean bIsActiveContact = False;
        
        conListOfPartnerAcc = [Select Id, IAM_Contact_Status__c, IAM_Contact_Owner__c, IAM_Legacy_User__c FROM Contact WHERE AccountId IN : acctIdSet AND 
                              IAM_Contact_Status__c =: System.Label.IAM_Active];
        
        if(conListOfPartnerAcc.size() > 0){
            for(Contact con : conListOfPartnerAcc){
                //only processing active contact records,however on Vamsi's confirm may need to consider Active legacy contact as well
                if(con.IAM_Contact_Status__c == 'Active' && con.IAM_Legacy_User__c == False){ 
                    activeContactId.add(con.Id);
                    actvConListPartnrAcc.add(con);
                } 
            }
        }
        if(activeContactId.size() > 0){
            bIsActiveContact = True;
            processActiveReclaimContacts(activeContactId, bIsActiveContact, actvConListPartnrAcc);
        }
              
    }
    
    public static void processActiveReclaimContacts(Set<Id> activeReclaimConId, Boolean bIsActiveContact, List<Contact> actvConListPartnrAcc){
        List<IAM_Contact_Provisioning__c> userFeatureList = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Contact_Provisioning__c> guidanzUserProvList = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Contact_Provisioning__c> edsUserProvList = new List<IAM_Contact_Provisioning__c>();
        Set<Id> contactIdSet = new Set<Id>();
        Set<Id> userIdSet = new Set<Id>();
        List<User> userCustCommList = new List<User>();
        Map<Id, String> mapCusCommUser = new Map<Id, String>();
        Map<Id, String> mapCusCommNick = new Map<Id, String>();
        Map<Id, User> mapTempCusCommUser = new Map<Id, User>();
        Set<Id> userIdCusComm = new Set<Id>();
        Set<Id> contIdCusComm = new Set<Id>();
        Set<Id> evlContactId = new Set<Id>();
        Set<Id> otherProfUserId = new Set<Id>();
        List<User> otherProfUserList = new List<User>();
        Map<Id, String> mapUserIdRole = new Map<Id, String>();
        Map<Id, String> mapUserIdAppRole = new Map<Id, String>();
        Map<Id, String> mapUserIdAppGrp = new Map<Id, String>();
        Map<Id, User> mapOtherProfUser = new Map<Id, User>();
        List<IAM_Contact_Provisioning__c> guiConProvInsertList = New List<IAM_Contact_Provisioning__c>();
        Set<Id> contIdToTrue = new Set<Id>();
        try{
            edsUserProvList = [Select Id, IAM_Contact__c, IAM_Application_Name__c, IAM_Role__c, IAM_Status__c,IAM_Contact__r.AccountId
                              FROM IAM_Contact_Provisioning__c where IAM_Contact__c IN : activeReclaimConId
                              AND ((IAM_Application_Name__c = 'EDS' AND IAM_Partner_EDS_Usage__c=true)
                              OR (IAM_Application_Name__c = 'Rapid Serve Web' AND IAM_Role__c includes('CLAIMFILER') )
                              OR (IAM_Application_Name__c = 'CUMPAS 2.0' AND IAM_Role__c includes('Dealer Admin','Dealer User')))
                              AND IAM_Status__c =: System.Label.IAM_Active AND IAM_End_Date__c >=: System.today()];
            System.debug('Records retrived for automation EDS,RSW,Cumpas'+ edsUserProvList.size());
            System.debug('Records retrived for automation EDS,RSW,Cumpas'+ edsUserProvList);
            if(edsUserProvList.size() > 0){
                guiConProvInsertList = processEDSToCreateGuidanz(edsUserProvList);
            }            
            userFeatureList = [Select Id, IAM_Contact__c, IAM_Application_Name__c, IAM_Role__c,
                                      IAM_Contact__r.IAM_Contact_Owner__c,
                                      IAM_Account_Application__c,IAM_End_Date__c,
                                      IAM_Contact__r.IAM_Applications__c,IAM_Contact__r.IAM_Application_Roles__c                                                                    		  
                                      FROM IAM_Contact_Provisioning__c where IAM_Contact__c IN : activeReclaimConId 
                                      AND IAM_Application_Name__c = 'Guidanz' 
                                      AND IAM_Status__c =: System.Label.IAM_Active AND IAM_End_Date__c >=: System.today()];
            if(userFeatureList.size() > 0){
                for(IAM_Contact_Provisioning__c conprov : userFeatureList){
                    if(conprov.IAM_Application_Name__c == 'Guidanz'){
                        if(bIsActiveContact){
                            guidanzUserProvList.add(conprov);
                            userIdSet.add(conprov.IAM_Contact__r.IAM_Contact_Owner__c);
                            contactIdSet.add(conprov.IAM_Contact__c);  
                        }						                      
                    }                   
                }
                system.debug('userIdSet value--->'+userIdSet);
                system.debug('contactIdSet value--->'+contactIdSet);               
                if(bIsActiveContact && guidanzUserProvList.size() > 0){
                    if(userIdSet.size() > 0){
                        userCustCommList = getCusCommUserDetails(userIdSet, contactIdSet);
                    }
                    system.debug('userCustCommList--->'+userCustCommList);
                    for(User usr : userCustCommList){
                        String sProfileName = usr.Profile.Name;
                        if(sProfileName.startsWith('EVL_') || usr.Profile.UserLicense.name == 'Partner Community'){
                            evlContactId.add(usr.ContactId);
                        }else if(usr.Profile.UserLicense.name == 'External Identity' || usr.Profile.UserLicense.name == 'Customer Community'){
                            otherProfUserId.add(usr.Id);
                            otherProfUserList.add(usr);
                        }else{
                            userIdCusComm.add(usr.Id);
                            contIdCusComm.add(usr.ContactId);
                            if(!mapTempCusCommUser.containsKey(usr.ContactId)){
                                mapTempCusCommUser.put(usr.ContactId, usr);
                            }                           
                        }                            
                    }
                    system.debug('contIdCusComm--->'+contIdCusComm);
                    system.debug('otherProfUserId--->'+otherProfUserId);
                    if(contIdCusComm.size() > 0 && userIdCusComm.size() > 0){
                        IAM_ContactTriggerHandlerNew.guidanzAutomationBypassRun=true;
                        //method will update User Deatils field in Contact record to null
                        /* Changes Start for Guidanz Automation Optimization Date - 08/25/2022 */
                        //List<IAM_Contact_Provisioning__c> userAccessList = updateUserInContact(contIdCusComm, actvConListPartnrAcc);
                        //temp code to increase efficiency - Anupam
                        Set<Id> idContact = new Set<Id>();
                        for(Contact con : actvConListPartnrAcc){
                            if(contIdCusComm.contains(con.Id)){
                                idContact.add(con.Id);
                            }
                        }
                        //IAM_ContactTriggerHandlerNew.guidanzAutomationBypassRun=false;
                        List<IAM_Contact_Provisioning__c> userAccessList = [Select Id, IAM_Contact__c, IAM_Application_Name__c, IAM_Role__c,
                                                                            IAM_Contact__r.IAM_Contact_Owner__c,
                                                                            IAM_Account_Application__c,IAM_End_Date__c,
                                                                            IAM_Contact__r.IAM_Applications__c,IAM_Contact__r.IAM_Application_Roles__c
                                                                            FROM IAM_Contact_Provisioning__c where IAM_Contact__c IN : idContact 
                                                                            AND IAM_Application_Name__c = 'Guidanz'
                                                                            AND IAM_Status__c =: System.Label.IAM_Active AND IAM_End_Date__c >=: System.today()];
                        /* Changes end for Guidanz Automation Optimization */
                        system.debug('userAccessList--->'+userAccessList);
                        for(IAM_Contact_Provisioning__c cc : userAccessList){
                            if(mapTempCusCommUser.containsKey(cc.IAM_Contact__c) && mapTempCusCommUser.get(cc.IAM_Contact__c) != null){
                                contIdToTrue.add(cc.IAM_Contact__c);
                                if(!mapCusCommUser.containsKey(mapTempCusCommUser.get(cc.IAM_Contact__c).Id)){
                                    mapCusCommUser.put(mapTempCusCommUser.get(cc.IAM_Contact__c).Id, mapTempCusCommUser.get(cc.IAM_Contact__c).Username);
                                }
                                if(!mapCusCommNick.containsKey(mapTempCusCommUser.get(cc.IAM_Contact__c).Id)){
                                    mapCusCommNick.put(mapTempCusCommUser.get(cc.IAM_Contact__c).Id, mapTempCusCommUser.get(cc.IAM_Contact__c).CommunityNickname);
                                }                               
                            }
                        }
                        system.debug('contIdToTrue---->'+contIdToTrue);
                        system.debug('mapCusCommUser inside active contact block--->'+mapCusCommUser);                       
                        deactiveateCustCommUser(userIdCusComm, mapCusCommUser,mapCusCommNick);
                        /* Changes Start for Guidanz Automation Optimization */
                        if(!contIdToTrue.isEmpty()){                       
                            updateContactPartnerField(contIdToTrue);
                        }
                        /* Changes end for Guidanz Automation Optimization */
                        IAM_ContactTriggerHandlerNew.guidanzAutomationBypassRun=false;
                    }
                    //this condition is for Users with External Identity License
                    if(otherProfUserId.size() > 0){
                        for(User u : otherProfUserList){
                            if(!mapOtherProfUser.containsKey(u.ContactId)){
                                mapOtherProfUser.put(u.ContactId, u);
                            }                           
                        }
                        for(IAM_Contact_Provisioning__c conFeat : guidanzUserProvList){
                            if(mapOtherProfUser.containsKey(conFeat.IAM_Contact__c) && mapOtherProfUser.get(conFeat.IAM_Contact__c) != null){
                                if(!mapUserIdRole.containsKey(mapOtherProfUser.get(conFeat.IAM_Contact__c).Id)){
                                    mapUserIdRole.put(mapOtherProfUser.get(conFeat.IAM_Contact__c).Id, conFeat.IAM_Role__c);
                                }
                                if(!mapUserIdAppRole.containsKey(mapOtherProfUser.get(conFeat.IAM_Contact__c).Id)){
                                    mapUserIdAppRole.put(mapOtherProfUser.get(conFeat.IAM_Contact__c).Id, conFeat.IAM_Contact__r.IAM_Application_Roles__c);
                                }
                                if(!mapUserIdAppGrp.containsKey(mapOtherProfUser.get(conFeat.IAM_Contact__c).Id)){
                                    mapUserIdAppGrp.put(mapOtherProfUser.get(conFeat.IAM_Contact__c).Id, conFeat.IAM_Contact__r.IAM_Applications__c);
                                }
                            }
                        }
                        system.debug('mapUserIdAppRole--->'+mapUserIdAppRole);
                        system.debug('mapUserIdRole--->'+mapUserIdRole);
                        system.debug('mapUserIdAppGrp--->'+mapUserIdAppGrp);
                        updateUserProfile(mapUserIdRole,mapUserIdAppRole,mapUserIdAppGrp);
                    }
                    if(guiConProvInsertList.size() > 0){
                        if(!Test.isRunningTest()){
                            ID jobID = System.enqueueJob(new IAM_Guidanz_ProcessEDSRec_Queueable(guiConProvInsertList));
                            System.debug('Printing Secondary JOB ID'+jobID);
                        }
                    }                   
                }
            }           
        }catch(exception e){
            IAM_ErrorHandling.IAMerrorCapture('', '', 
            e.getStackTraceString() + ' : ' + e.getMessage(),
            IAM_Guidanz_PartnerAccountAutomation.class.getName());
        }        
    }
    //method to fetch users with License as 'Customer Community Plus'
    public static List<User> getCusCommUserDetails(Set<Id> userIdSet, Set<Id> contactIdSet){
        List<User> userCustCommList = new List<User>();
        userCustCommList = [Select Id, IAM_UID__c, FederationIdentifier, IAM_OAM_Federation_ID__c, IsActive,
                            Profile.UserLicense.name, Username, CommunityNickname, ContactId,LocaleSidKey,LanguageLocaleKey,
                            TimeZoneSidKey,IAM_Random_Number__c,IAM_Applicationgroups__c,IAM_Promotion__c,
                            IAM_Application_Roles__c, Contact.IAM_Contact_Owner__c, Profile.Name, ProfileId
                            FROM User Where Id IN : userIdSet AND ContactId IN : contactIdSet AND IsActive = True];
                            //Profile.UserLicense.name = 'Customer Community Plus' AND IsActive = True];
        return userCustCommList;
    }
	
    //method to process EDS App records and create Guidanz App Feature & User Feature records if Contact has EDS App access
    //and not Guidanz App Access
    public static List<IAM_Contact_Provisioning__c> processEDSToCreateGuidanz(List<IAM_Contact_Provisioning__c> edsUserProvList){
        IAM_ContactTriggerHandlerNew.guidanzAutomationBypassRun=true;
        TriggerHandler.bypass('IAM_ContactTriggerHandlerNew');
        TriggerHandler.bypass('IAM_UserAccessTriggerHandlerNew');
        TriggerHandler.bypass('IAM_AccountAccessTriggerHndlrNew');
        Set<Id> ConIdSet = new Set<Id>();
        Map<Id, Id> mapConIdAccId = new Map<Id, Id>();
        Set<Id> nonGuiConIdSet = new Set<Id>();
        Set<Id> accIdSet = new Set<Id>();
        List<IAM_Application__c> guiAppFeatureList = new List<IAM_Application__c>();
        List<Contact> contactList = new List<Contact>();
        Map<Id, IAM_Application__c> mapAppFeatureRec = new Map<Id, IAM_Application__c>();
        List<IAM_Contact_Provisioning__c> guiConProvInsertList = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Application__c> appFeatureListGui = new List<IAM_Application__c>();
        List<String> roles= new List<String>();
        List<String> rolesSplit= new List<String>();
        Set<String> rolesFinal= new Set<String>();
        Map<Id, User> userMap = new Map<Id, User>();
        Set<Id> accIdSetFinal = new Set<Id>();
        List<IAM_Application__c> accIdToUpdateGuidanz = new List<IAM_Application__c>(); 
        Set<Id> accIdWithGuiAccFeat = new Set<Id>();
        Set<Id> accIdWithoutGuiAccFeat=new Set<Id>();
        for(IAM_Contact_Provisioning__c cc : edsUserProvList){
            ConIdSet.add(cc.IAM_Contact__c);
        }
        List<IAM_Contact_Provisioning__c> guiUserFeatList = [Select Id, IAM_Contact__c,IAM_Contact__r.AccountId
                                                             FROM IAM_Contact_Provisioning__c WHERE IAM_Contact__c IN : ConIdSet 
                                                             AND IAM_Application_Name__c = 'Guidanz' AND IAM_Status__c =: System.Label.IAM_Active];
        //if(guiUserFeatList.size() > 0){
            for(IAM_Contact_Provisioning__c userFeat : guiUserFeatList){
                if(!mapConIdAccId.containsKey(userFeat.IAM_Contact__c)){
                    mapConIdAccId.put(userFeat.IAM_Contact__c, userFeat.IAM_Contact__r.AccountId);
                }
            }
            system.debug('mapConIdAccId value--->'+ mapConIdAccId);
            for(IAM_Contact_Provisioning__c cprov : edsUserProvList){
                if(!mapConIdAccId.containsKey(cprov.IAM_Contact__c)){
                    nonGuiConIdSet.add(cprov.IAM_Contact__c);
                    accIdSet.add(cprov.IAM_Contact__r.AccountId);
                }
            }
            system.debug('nonGuiConIdSet--->'+nonGuiConIdSet);
            system.debug('accIdSet--->'+accIdSet);
            if(accIdSet.size() > 0){
                appFeatureListGui = [Select Id, IAM_Account_Name__c, IAM_Application_Name__c, IAM_Role__c, IAM_Subscription_End_Date__c
                                     FROM IAM_Application__c
                                     WHERE IAM_Account_Name__c IN : accIdSet AND IAM_Application_Name__c = 'Guidanz'
                                     AND IAM_Status__c =: System.Label.IAM_Active];
            }
        system.debug('appFeatureListGui--->'+appFeatureListGui);
        if(appFeatureListGui.size() > 0){
            /*for(IAM_Application__c app : appFeatureListGui){
                roles.add(app.IAM_Role__c);
            }
            for(String ss : roles){
                if(ss != ''){
                    String s2 = ss.replace(';',',');
                    rolesSplit = s2.split(',');
                    rolesFinal.addAll(rolesSplit);
                }
                system.debug('rolesFinal--->'+rolesFinal);
                if(rolesFinal.contains('Advanced')){
                    for(IAM_Application__c acctFeat : appFeatureListGui){
                        if(!accIdSet.contains(acctFeat.IAM_Account_Name__c)){
                            //finalappListGui.add(acctFeat);
                            accIdSetFinal.add(acctFeat.IAM_Account_Name__c);
                        }
                        if(!mapAppFeatureRec.containsKey(acctFeat.IAM_Account_Name__c)){
                            mapAppFeatureRec.put(acctFeat.IAM_Account_Name__c, acctFeat);
                        }
                    }               
                }
            }      */      
            for(IAM_Application__c app : appFeatureListGui)
            { 
                
                    rolesFinal.clear();
                    String ss= app.IAM_Role__c;
                    String s2 = ss.replace(';',',');
                    rolesSplit = s2.split(',');
                    rolesFinal.addAll(rolesSplit);
                	if(rolesFinal.contains('Advanced')){
                        if(!mapAppFeatureRec.containsKey(app.IAM_Account_Name__c)){
                            mapAppFeatureRec.put(app.IAM_Account_Name__c, app);
                        }
                    }
               		else
                    {
                        app.IAM_Role__c=app.IAM_Role__c+';Advanced';
						accIdToUpdateGuidanz.add(app);              
                    }
                    rolesFinal.clear();
                accIdWithGuiAccFeat.add(app.IAM_Account_Name__c);

            }
            
        }
        /*else{
            accIdSetFinal.addAll(accIdSet);
        }*/
        accIdWithoutGuiAccFeat.addAll(accIdSet);
        accIdWithoutGuiAccFeat.removeAll(accIdWithGuiAccFeat);
        
        System.debug('accIdWithoutGuiAccFeat-->'+accIdWithoutGuiAccFeat);
        accIdSetFinal.addAll(accIdWithoutGuiAccFeat);
        
        // Logic to update Guidanz account access feature with Advanced Role
        System.debug('accIdToUpdateGuidanz-->'+accIdToUpdateGuidanz);
        if(accIdToUpdateGuidanz.size()>0)
        {
            update accIdToUpdateGuidanz;
        }
        for(IAM_Application__c app : accIdToUpdateGuidanz)
        {
            if(!mapAppFeatureRec.containsKey(app.IAM_Account_Name__c))
            {
                mapAppFeatureRec.put(app.IAM_Account_Name__c, app);
            }
        }
        	system.debug('mapAppFeatureRec--->'+mapAppFeatureRec);
            system.debug('accIdSetFinal--->'+accIdSetFinal);
            if(accIdSetFinal.size() > 0){
                Id RecIdpro = [Select Id, Name, sobjecttype from RecordType where name = 'Guidanz' and sobjecttype = 'IAM_Application__c'].Id;
                for(Id appId : accIdSetFinal){
                    IAM_Application__c newApp = new IAM_Application__c();
                    newApp.IAM_Application_Name__c = 'Guidanz';
                    newApp.IAM_Role__c = 'Advanced';
                    newApp.IAM_Status__c = System.Label.IAM_Active;
                    newApp.IAM_Account_Name__c = appId;
                    newApp.IAM_Subscription_Start_Date__c = system.today();
                    newApp.IAM_Subscription_End_Date__c = system.today() + 36500;
                    newApp.recordtypeId = RecIdpro;
                    guiAppFeatureList.add(newApp);
                }                      
                if(guiAppFeatureList.size() > 0){
                    insert guiAppFeatureList;
                }
                for(IAM_Application__c app : guiAppFeatureList){
                    if(!mapAppFeatureRec.containsKey(app.IAM_Account_Name__c)){
                        mapAppFeatureRec.put(app.IAM_Account_Name__c, app);
                    }
                }
            }
            system.debug('mapAppFeatureRec--->'+mapAppFeatureRec);
            if(nonGuiConIdSet.size() > 0 && !mapAppFeatureRec.isEmpty()){
                contactList = [Select Id,AccountId,Username__c FROM Contact WHERE Id IN : nonGuiConIdSet];
                List<User> userList = [SELECT Id,ContactId FROM User WHERE Contact.Id IN :nonGuiConIdSet AND IsActive = true];
                if(!userList.isEmpty()) {
                    for(User u : userList) {
                        userMap.put(u.ContactId, u);
                    }
                }            
                Id RecIdpro1 = [Select Id, Name, sobjecttype from RecordType where name = 'Guidanz' and sobjecttype = 'IAM_Contact_Provisioning__c'].Id;
                for(Contact con : contactList){
                    if(mapAppFeatureRec.containsKey(con.AccountId) && mapAppFeatureRec.get(con.AccountId) != null){
                        IAM_Contact_Provisioning__c conP = new IAM_Contact_Provisioning__c();
                        conP.IAM_Application_Name__c =  mapAppFeatureRec.get(con.AccountId).IAM_Application_Name__c;
                        conP.RecordTypeId = RecIdpro1;
                        conP.IAM_Role__c = 'Advanced';
                        conP.IAM_Contact__c = con.Id;//conRec.Id;
                        conP.IAM_Status__c = System.Label.IAM_Active;
                        conP.IAM_Account_Application__c = mapAppFeatureRec.get(con.AccountId).Id;
                        conP.IAM_Start_Date__c = system.today();
                        conP.IAM_End_Date__c = mapAppFeatureRec.get(con.AccountId).IAM_Subscription_End_Date__c;
                        conP.IAM_userId__c = con.Username__c;
                        if(!userMap.isEmpty() && userMap.get(con.Id) != null) {
                            conP.IAM_User__c = userMap.get(con.Id).Id;
                        }
                        guiConProvInsertList.add(conP);
                    }
                }
            }
            system.debug('guiConProvInsertList--->'+guiConProvInsertList);
            if(guiConProvInsertList.size() > 0){
                insert guiConProvInsertList;
            }
        IAM_ContactTriggerHandlerNew.guidanzAutomationBypassRun=false;
        return guiConProvInsertList;
       // }
    }
    
    //Commented this method for guidanz automation optimization
    /*public static List<IAM_Contact_Provisioning__c> updateUserInContact(Set<Id> contIdCusComm, List<Contact> actvConListPartnrAcc){
        IAM_ContactTriggerHandlerNew.guidanzAutomationBypassRun=true;
        TriggerHandler.bypass('IAM_ContactTriggerHandlerNew');
        List<Contact> contListUserUpd = New List<Contact>();
        Set<Id> consIdSet = New Set<Id>();
        for(Contact con : actvConListPartnrAcc){
            if(contIdCusComm.contains(con.Id)){
                con.IAM_Contact_Owner__c = Null;
                consIdSet.add(con.Id);
                contListUserUpd.add(con);
            }
        }
        if(contListUserUpd.size() > 0){
            update contListUserUpd;
        }
        IAM_ContactTriggerHandlerNew.guidanzAutomationBypassRun=false;
        List<IAM_Contact_Provisioning__c> userAccessList = [Select Id, IAM_Contact__c, IAM_Application_Name__c, IAM_Role__c,
                                      IAM_Contact__r.IAM_Contact_Owner__c,
                                      IAM_Account_Application__c,IAM_End_Date__c,
                                      IAM_Contact__r.IAM_Applications__c,IAM_Contact__r.IAM_Application_Roles__c
                                      FROM IAM_Contact_Provisioning__c where IAM_Contact__c IN : consIdSet 
                                      AND IAM_Application_Name__c = 'Guidanz'
                                      AND IAM_Status__c =: System.Label.IAM_Active AND IAM_End_Date__c >=: System.today()];
        
        return userAccessList;
    }*/
    
    //this method will update only the profile of user holding External Identity License without deactivating user record
    @Future
    public static void updateUserProfile(Map<Id, String> mapUserIdRole, Map<Id, String> mapUserIdAppRole, Map<Id, String> mapUserIdAppGrp){
        List<User> uListUpdate = New List<User>();
        Set<Id> setUserIdAdv = new Set<Id>();
        Set<Id> setUserIdOther = new Set<Id>();
        List<PermissionSet> psListAdv = new List<PermissionSet>();
        List<PermissionSet> psListTech = new List<PermissionSet>();
        List<PermissionSetAssignment> existPSAListAdvnced = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> existPSAListTech = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> listOldPSA = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> psaListNewAdvTech = new List<PermissionSetAssignment>();
        List<String> errorListRec = new List<String>();
        Boolean sCheckFlag = False;
        String sAppRoleAdv = '';
        String sAppRoleTech = '';
        String sAppGroupAdv = '';
        String sAppGroupTech = '';
        sAppRoleAdv = 'Advanced';
        sAppRoleTech = 'Technician';
        sAppGroupAdv = 'cn=CSS_DN_Advanced,ou=APP_CSS,ou=application,dc=cummins,dc=com';
        sAppGroupTech = 'cn=css_dn_tech,ou=app_css,ou=application,dc=cummins,dc=com';
        try{
            //Query to fetch Profile Id based on Role and assign to Profile field of user:            
            List<profile> evlProfiles = [select Id,name from profile where name like 'EVL_%'];
            Map<string,Id> evlProfMap = new Map<string,Id>();
            for(profile pf:evlProfiles){
                evlProfMap.put(pf.name,pf.Id);
            }
            
            for(Id userId : mapUserIdRole.keySet()){
                User updUsr = New User();
                if(mapUserIdRole.get(userId) == 'Advanced' && mapUserIdAppRole.containsKey(userId) && mapUserIdAppGrp.containsKey(userId)){
                    setUserIdAdv.add(userId);
                    updUsr.Id = userId;               
                    updUsr.ProfileId=evlProfMap.get(System.label.EVL_DealerAdvanced_Gui);
                    if(mapUserIdAppRole.get(userId)==null)
                        updUsr.IAM_Application_Roles__c = sAppRoleAdv;
                    else
                        updUsr.IAM_Application_Roles__c = mapUserIdAppRole.get(userId)+','+sAppRoleAdv;
                    if(mapUserIdAppGrp.get(userId)==null)
                        updUsr.IAM_Applicationgroups__c = sAppGroupAdv;
                    else
                        updUsr.IAM_Applicationgroups__c = mapUserIdAppGrp.get(userId)+'|'+sAppGroupAdv;
                }else if(mapUserIdRole.get(userId) == 'Technician' && mapUserIdAppRole.containsKey(userId) && mapUserIdAppGrp.containsKey(userId)){
                    setUserIdOther.add(userId);
                    updUsr.Id = userId;
                    updUsr.ProfileId=evlProfMap.get(System.label.EVL_DealerTechnician_Gui);
                    if(mapUserIdAppRole.get(userId)==null)
                        updUsr.IAM_Application_Roles__c = sAppRoleTech;
                    else
                        updUsr.IAM_Application_Roles__c = mapUserIdAppRole.get(userId)+','+sAppRoleTech;
                    if(mapUserIdAppGrp.get(userId)==null)
                        updUsr.IAM_Applicationgroups__c = sAppGroupTech;
                    else
                        updUsr.IAM_Applicationgroups__c = mapUserIdAppGrp.get(userId)+'|'+sAppGroupTech;
                }else if(mapUserIdRole.get(userId) == 'Read Only'){
                    setUserIdOther.add(userId);
                    updUsr.Id = userId;
                    updUsr.ProfileId=evlProfMap.get(System.label.EVL_DealerReadonly_Gui);
                }else{
                    updUsr.Id = userId;
                }
                updUsr.UserPermissionsSFContentUser = True;
                uListUpdate.add(updUsr);
            }
            system.debug('uListUpdate--->'+uListUpdate);
            system.debug('setUserIdAdv--->'+setUserIdAdv);
            system.debug('setUserIdOther--->'+setUserIdOther);
                       
            List<PermissionSet> permissionSetList = [SELECT Id, Label, Name, ProfileId
                                                     FROM PermissionSet
                                                     WHERE Label = :Label.IAM_Guidanz
                                                     OR Label = :Label.IAM_GuidanzPSet_EVLDealerAdv
                                                     OR Label = :Label.IAM_GuidanzPSet_EVLDealerTechnician
                                                     OR Label = :Label.IAM_GuidanzPS_EVLClassicAdv
                                                     OR Label = :Label.IAM_GuidanzPS_EVLClassicTechnician];
            
            for(PermissionSet perSet : permissionSetList){
                if(perSet.Label == System.Label.IAM_Guidanz || perSet.Label == System.Label.IAM_GuidanzPSet_EVLDealerAdv || perSet.Label == System.Label.IAM_GuidanzPS_EVLClassicAdv){
                    psListAdv.add(perSet);
                    //setPSIdAdv.add(perSet.Id);
                }
                if(perSet.Label == System.Label.IAM_Guidanz || perSet.Label == System.Label.IAM_GuidanzPSet_EVLDealerTechnician || perSet.Label == System.Label.IAM_GuidanzPS_EVLClassicTechnician){
                    psListTech.add(perSet);
                    //setPSIdTech.add(perSet.Id);
                }
            }
            
            system.debug('psListAdv--->'+psListAdv);
            system.debug('psListTech--->'+psListTech);
            if(setUserIdAdv.size() > 0){
                existPSAListAdvnced = [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment
                                       WHERE AssigneeId IN :setUserIdAdv];
                system.debug('existPSAListAdvnced--->'+existPSAListAdvnced);
                if(existPSAListAdvnced.size() > 0){
                    for(PermissionSetAssignment psa : existPSAListAdvnced) {
                        psa.Id = null;
                        listOldPSA.add(psa);
                    }
                }
            }
            system.debug('listOldPSA--->'+listOldPSA);
            if(setUserIdOther.size() > 0){
                existPSAListTech = [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment
                                    WHERE AssigneeId IN :setUserIdOther];
                system.debug('existPSAListTech--->'+existPSAListTech);
                if(existPSAListTech.size() > 0){
                    for(PermissionSetAssignment ps : existPSAListTech) {
                        ps.Id = null;
                        listOldPSA.add(ps);
                    }
                }
            }
            //assign Guidanz & EVL Dealer Adv PS to new user who has Advanced role for Guidanz User Feature record
            if(psListAdv.size() > 0 && setUserIdAdv.size() > 0){
                for(Id usr : setUserIdAdv){
                    for(PermissionSet psGuiAdv : psListAdv){
                        PermissionSetAssignment psa = new PermissionSetAssignment();
                        psa.PermissionSetId = psGuiAdv.Id;
                        psa.AssigneeId = usr;
                        psaListNewAdvTech.add(psa);
                    }
                }
            }
            system.debug('psaListNewAdvTech--->'+psaListNewAdvTech);
            //assign Guidanz & EVL Dealer Technician PS to new user not having 'Advanced' role for Guidanz User Feature record
            if(psListTech.size() > 0 && setUserIdOther.size() > 0){
                for(Id u : setUserIdOther){
                    for(PermissionSet psGuiTech : psListTech){
                        PermissionSetAssignment ps = new PermissionSetAssignment();
                        ps.PermissionSetId = psGuiTech.Id;
                        ps.AssigneeId = u;
                        psaListNewAdvTech.add(ps);
                    }
                }
            }
            system.debug('psaListNewAdvTech--->'+psaListNewAdvTech);
            psaListNewAdvTech.addAll(listOldPSA);
            system.debug('psaListNewAdvTech--->'+psaListNewAdvTech);
            
            //insert Guidanz, EVL Dealer ADV, EVL Dealer Technician PS to users  and update license to Partner Community      
            if(uListUpdate.size() > 0){
                update uListUpdate;
            }
            if(!psaListNewAdvTech.isEmpty()) {
                Database.SaveResult[] srList = Database.insert(psaListNewAdvTech, false);
                System.debug('#### srList - '+srList);
            }
        }catch(exception e){
            sCheckFlag = True;
            if(!Test.isRunningTest()){
                ID jobID = System.enqueueJob(new IAM_Guidanz_writeException_Queueable(mapUserIdRole, mapUserIdAppRole, mapUserIdAppGrp,errorListRec,sCheckFlag));
                System.debug('Printing Secondary JOB ID'+jobID);
            }
        }
    }
    
    //this method is to update the Is Partner User Record checkbox field in contact, so that this can be picked by 
    //scheduled class for further processing of creating partner community users
    @Future
    public static void updateContactPartnerField(Set<Id> contIdToTrue){
        IAM_ContactTriggerHandlerNew.guidanzAutomationBypassRun=true;
        TriggerHandler.bypass('IAM_ContactTriggerHandlerNew');
        List<Contact> conListUpdate = New List<Contact>();
        system.debug('contIdToTrue--->'+contIdToTrue);
        List<Contact> conListFetch = [Select Id, IAM_Partner_User_Record__c FROM Contact
                                     WHERE Id IN : contIdToTrue];
        for(Contact con : conListFetch){
            con.IAM_Contact_Owner__c = Null;//Added logic from updateUserinContact method and merged these two methods
            con.IAM_Partner_User_Record__c = True;
            conListUpdate.add(con);
        }
        system.debug('conListUpdate--->'+conListUpdate);
        if(conListUpdate.size() > 0){
            update conListUpdate;
        } 
        IAM_ContactTriggerHandlerNew.guidanzAutomationBypassRun=false;
    }
    @Future
    public static void deactiveateCustCommUser(Set<Id> userIdCusComm, Map<Id, String> mapCusCommUser, Map<Id, String> mapCusCommNick){
        List<User> userListToUpdate = new List<User>();
        try{
            for(Id uRecord : userIdCusComm){
                if(mapCusCommUser.containsKey(uRecord) && mapCusCommNick.containsKey(uRecord)){
                    User uRec = New User();
                    uRec.Id = uRecord;
                    uRec.IsPortalEnabled = False;
                    uRec.IAM_UID__c = null;
                    uRec.FederationIdentifier = null;
                    uRec.IAM_OAM_Federation_ID__c = null;
                    uRec.Username = 'del_'+mapCusCommUser.get(uRecord);
                    if(mapCusCommNick.get(uRecord).length() >= 35){
                        uRec.CommunityNickname = 'del_'+mapCusCommNick.get(uRecord).substring(0,30);
                    }else{
                        uRec.CommunityNickname = 'del_'+mapCusCommNick.get(uRecord);
                    }                                  
                    userListToUpdate.add(uRec);
                }
            }
            system.debug('userListToUpdate--->'+userListToUpdate);
            if(userListToUpdate.size() > 0){
                Database.SaveResult[] srList = Database.update(userListToUpdate, false);
                System.debug('##### srList - '+srList);
            }
            
        }catch(exception e){
            IAM_ErrorHandling.IAMerrorCapture('', '', 
            e.getStackTraceString() + ' : ' + e.getMessage(),
            IAM_Guidanz_PartnerAccountAutomation.class.getName());
        }         
    }
}