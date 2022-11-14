/*************************************************************************************
Name:  IAM_Reclaim_ConProv_Process_Queable
Copyright © 2019  Cummins
**************************************************************************************
Purpose: This class is used in Reclaim process to create Account Feature & Access and
User Feature & Access records for given application access (App DN) based on Application
Group and Is Member Of field values on Contact object.
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Karthik Golakram          09/02/2020        INITIAL DEVELOPMENT
1.1      Karthik Golakaram         10/21/2020        To create Warranty User Feature &
                                                     Access record
1.2      Shubhangi Sardar          08/19/2021        QSOL, EDS, CST app creation logic
**************************************************************************************
**************************************************************************************/

public class IAM_Reclaim_ConProv_Process_Queable implements Queueable {

    private Contact contactObj;
    /* Contructor */
    public IAM_Reclaim_ConProv_Process_Queable(Contact contactObj) {
        this.contactObj = contactObj;     
    }
    
    public void execute(QueueableContext Context) {
        Map<String, IAM_Application_Groups__c> dnValAppGrpMap = new Map<String, IAM_Application_Groups__c>();
        Map<String, Set<IAM_Application_Groups__c>> appGrpMap = new Map<String, Set<IAM_Application_Groups__c>>();           
        String allGroupsToSplit = '';
        try{
            List<User> userList = getUserList(contactObj.Id);
            Contact reclaimedContact = getContactDetails(contactObj.Id);
            System.debug('#### reclaimedContact - ' + reclaimedContact);
            if(reclaimedContact == null) {
                return;
            }
            /* Get all Application Groups from Custom Setting */
            getApplicationGroupsCS(dnValAppGrpMap, appGrpMap);
            System.debug('#### dnValAppGrpMap Size - ' + dnValAppGrpMap.size()
            + ' #### appGrpMap Size - ' + appGrpMap.size());
            
            String appDNOnContact = getAppAppDNOnContact(reclaimedContact);            
            System.debug('#### appDNOnContact - ' + appDNOnContact);
            if(String.isBlank(appDNOnContact)) {
                return;
            }
            Map<String, List<IAM_Application__c>> accountAppMap = 
            getAccountAppMap(reclaimedContact.AccountId);
            Map<String, List<IAM_Contact_Provisioning__c>> contactAppMap =
            getContactProvisionings(reclaimedContact.Id);
            
            Set<String> contactAppDNSet = new Set<String>();
            Set<String> cumpasModuleSet = new Set<String>();           
            for(String appDN : appDNOnContact.split('\\|')){
                contactAppDNSet.add(appDN.toUpperCase());                    
            }
            
            Map<String, String> accAppToCreateMap = new Map<String, String>();
            List<IAM_Application__c> accAppToUpdateList = new List<IAM_Application__c>();
            Map<String, String> conAppToCreateMap = new Map<String, String>();
            Map<String, String> conAppToCreateGMMap = new Map<String, String>();
            Map<Id, IAM_Application__c> accAppGMMap = new Map<Id, IAM_Application__c>();
            Set<String> modularitySet = new Set<String>();
            List<IAM_Contact_Provisioning__c> conAppToUpdateList = new List<IAM_Contact_Provisioning__c>();
            
            for(String appDN : contactAppDNSet) {
                if(dnValAppGrpMap.containsKey(appDN)) {
                    IAM_Application_Groups__c appGrp = dnValAppGrpMap.get(appDN);
                    if(appGrp.IAM_Free_application__c) {
                        /* Create/Update Account Feature & Access and User Feature & Access 
                        for free applications - CUMPAS, Guidanz, RSW, */
                        if(!contactAppMap.containsKey(appGrp.IAM_Application_Name__c)) {
                            if(!accountAppMap.containsKey(appGrp.IAM_Application_Name__c)) {
                                // create account feature access
                                prepareAccAppMapToCreate(appGrp, accAppToCreateMap);
                            } else {
                                if(!(appGrp.IAM_Application_Name__c == Label.IAM_AppName_Cumpas 
                                && appGrp.IAM_DN_value__c.containsIgnoreCase('ou=app_cumpas'))) {
                                    List<IAM_Application__c> appList = accountAppMap.get(appGrp.IAM_Application_Name__c);
                                    // update account feature access
                                    IAM_Application__c accApp = appList[0];
                                    String accRole = accApp.IAM_Role__c;
                                    if(!accRole.containsIgnoreCase(appGrp.IAM_Role_Name__c)) {
                                        accApp.IAM_Role__c = accRole + ';'+ appGrp.IAM_Role_Name__c;
                                        accAppToUpdateList.add(accApp);
                                    }
                                }                             
                            }
                            //create user feature access
                            prepareConAppMapToCreate(appGrp, conAppToCreateMap);
                        } else {
                            // update user feature access
                            prepareConAppListToUpdate(appGrp, contactAppMap, reclaimedContact,
                            userList, conAppToUpdateList);                   
                        }
                        if(appGrp.IAM_Application_Name__c == Label.IAM_AppName_Cumpas 
                        && appGrp.IAM_DN_value__c.containsIgnoreCase('ou=app_cumpas')) {
                            modularitySet.add(appGrp.IAM_Role_Name__c);
                        }
                    } else {
                        /* Paid Subscriptions */
                        if((appGrp.IAM_Application_Name__c == Label.IAM_Quick_Serve_Online
                        || appGrp.IAM_Application_Name__c == Label.IAM_EDS
                        || appGrp.IAM_Application_Name__c == Label.IAM_Cummins_Service_Training)
                        && accountAppMap.containsKey(Label.IAM_Quick_Serve_Online)) {
                            if(appGrp.IAM_Application_Name__c == Label.IAM_Quick_Serve_Online) {
                                if(!contactAppMap.containsKey(appGrp.IAM_Application_Name__c)) {                                
                                    // create QSOL user feature access if it is not there for given role
                                    //create user feature access
                                    prepareConAppMapToCreate(appGrp, conAppToCreateMap);
                                } else {
                                    // update user feature access with user id
                                    prepareConAppListToUpdate(appGrp, contactAppMap, reclaimedContact,
                                    userList, conAppToUpdateList);
                                }
                            }
                            if(appGrp.IAM_Application_Name__c == Label.IAM_EDS
                            || appGrp.IAM_Application_Name__c == Label.IAM_Cummins_Service_Training) {
                                if(accountAppMap.containsKey(appGrp.IAM_Application_Name__c)) {
                                    if(!contactAppMap.containsKey(appGrp.IAM_Application_Name__c)) {
                                        // create EDS/CST user feature access if it is not there for given role
                                        prepareConAppMapToCreate(appGrp, conAppToCreateMap);
                                    } else {
                                        // update user feature access with user id
                                        prepareConAppListToUpdate(appGrp, contactAppMap, reclaimedContact,
                                        userList, conAppToUpdateList);
                                    }
                                } else {
                                    // create EDS/CST account feature access if it is not there for given role
                                    prepareAccAppMapToCreate(appGrp, accAppToCreateMap);
                                       
                                    // create EDS/CST user feature access if it is not there for given role
                                    prepareConAppMapToCreate(appGrp, conAppToCreateMap);
                                }                      
                            }
                        } else if((appGrp.IAM_Application_Name__c == Label.IAM_Quick_Serve_Online
                        || appGrp.IAM_Application_Name__c == Label.IAM_EDS
                        || appGrp.IAM_Application_Name__c == Label.IAM_Cummins_Service_Training)
                        && !accountAppMap.containsKey(Label.IAM_Quick_Serve_Online)) {
                            // update user feature access with inacrive status
                            if(contactAppMap.containsKey(appGrp.IAM_Application_Name__c)) {
                                List<IAM_Contact_Provisioning__c> conAppList = 
                                contactAppMap.get(appGrp.IAM_Application_Name__c);
                                IAM_Contact_Provisioning__c conApp = conAppList[0];
                                conApp.IAM_Status__c = Label.IAM_Status_Inactive;
                                conAppToUpdateList.add(conApp);
                            }
                        } else if(appGrp.IAM_Application_Name__c == Label.IAM_Guidanz_Mobile_App_Name) {
                            if(!contactAppMap.containsKey(appGrp.IAM_Application_Name__c)) {
                                if(accountAppMap.containsKey(appGrp.IAM_Application_Name__c)) {
                                    List<IAM_Application__c> accAppList =
                                    accountAppMap.get(appGrp.IAM_Application_Name__c);
                                    for(IAM_Application__c accApp : accAppList) {
                                        if(accApp.IAM_Role__c.containsIgnoreCase(appGrp.IAM_Role_Name__c)) {
                                            // Create user feature access record - GM
                                            conAppToCreateGMMap.put(accApp.Id,
                                            appGrp.IAM_Role_Name__c);
                                            accAppGMMap.put(accApp.Id, accApp);
                                        }
                                    }
                                }
                            } else {
                                List<IAM_Contact_Provisioning__c> conAppList = 
                                contactAppMap.get(appGrp.IAM_Application_Name__c);
                                for(IAM_Contact_Provisioning__c conApp : conAppList) {
                                    if(conApp.IAM_Role__c.containsIgnoreCase(appGrp.IAM_Role_Name__c)) {
                                        // Update user feature access with userId
                                        IAM_Contact_Provisioning__c conAppToUpdate = conApp;
                                        conAppToUpdate.IAM_userId__c = reclaimedContact.Username__c;
                                        if(!userList.isEmpty()) {
                                            conAppToUpdate.IAM_User__c = userList[0].Id;
                                        }
                                        conAppToUpdateList.add(conAppToUpdate);
                                    } else {
                                        /*check if account feature exist with ap grp role, 
                                        if yes create user feature access*/
                                        List<IAM_Application__c> accAppList =
                                        accountAppMap.get(appGrp.IAM_Application_Name__c);
                                        for(IAM_Application__c accApp : accAppList) {
                                            if(accApp.IAM_Role__c.containsIgnoreCase(appGrp.IAM_Role_Name__c)) {
                                                // Create user feature access record - GM
                                                conAppToCreateGMMap.put(accApp.Id,
                                                appGrp.IAM_Role_Name__c);
                                                accAppGMMap.put(accApp.Id, accApp);
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            /* Enter for other paid applications */
                            if(!contactAppMap.containsKey(appGrp.IAM_Application_Name__c)) {
                                if(accountAppMap.containsKey(appGrp.IAM_Application_Name__c)) {
                                    List<IAM_Application__c> accAppList =
                                    accountAppMap.get(appGrp.IAM_Application_Name__c);
                                    IAM_Application__c accApp = accAppList[0];                                    
                                    if(accApp.IAM_Role__c.containsIgnoreCase(appGrp.IAM_Role_Name__c)) {
                                        // Create user feature access record                            
                                        prepareConAppMapToCreate(appGrp, conAppToCreateMap);
                                    }                                    
                                }
                            } else {
                                // Update user feature access with userId
                                prepareConAppListToUpdate(appGrp, contactAppMap, reclaimedContact,
                                userList, conAppToUpdateList);
                            }
                        }                     
                    }
                }
            }
            createOrUpdateApps(accAppToCreateMap, accAppToUpdateList, conAppToCreateMap,
            conAppToUpdateList, modularitySet, conAppToCreateGMMap, accAppGMMap, accountAppMap, reclaimedContact, userList);
        } catch(Exception e) {
            System.debug('Printing Stack Trace string'+e.getStackTraceString());
            String processedData = 'Method - execute, Contact Id - ' + contactObj.Id;
            IAM_ErrorHandling.IAMerrorCapture(processedData, Label.IAM_Reclaim_Flow,
            e.getStackTraceString() + ' - ' + e.getMessage(),
            IAM_Reclaim_ConProv_Process_Queable.class.getName());
        }    
    }

    /* Create/Update Account Feaure & Access and User Feature & Access object */
    public static void createOrUpdateApps(Map<String, String> accAppToCreateMap, 
    List<IAM_Application__c> accAppToUpdateList, Map<String, String> conAppToCreateMap,
    List<IAM_Contact_Provisioning__c> conAppToUpdateList, Set<String> modularitySet, 
    Map<String, String> conAppToCreateGMMap, Map<Id, IAM_Application__c> accAppGMMap,
    Map<String, List<IAM_Application__c>> accountAppMap, Contact reclaimedContact, List<User> userList) {
        /* Update Account Feature & Access List */
        if(!accAppToUpdateList.isEmpty()) {
            for(IAM_Application__c accApp : accAppToUpdateList) {
                if(accApp.IAM_Application_Name__c == Label.IAM_AppName_Cumpas
                && !modularitySet.isEmpty()) {
                    String existingModules = accApp.IAM_Cumpas_Modularity__c;
                    accApp.IAM_Cumpas_Modularity__c = getModules(modularitySet, existingModules);
                }
            }
            insertUpdateDataRecord(accAppToUpdateList, 'update');
        }
        
        /* Insert Account Feature & Access List */
        if(!accAppToCreateMap.isEmpty()) {
            List<IAM_Application__c> accAppList = new List<IAM_Application__c>();
            for(String appName : accAppToCreateMap.keySet()) {
                if(appName == Label.IAM_EDS || appName == Label.IAM_Cummins_Service_Training) {
                    /* Get List of Paid Apps - EDS & CST to Insert */
                    IAM_Application__c qsolApp = accountAppMap.get(Label.IAM_Quick_Serve_Online)[0];
                    accAppList.add(getAccFeatureAccessToCreate(appName, accAppToCreateMap.get(appName), reclaimedContact.AccountId,
                    modularitySet, qsolApp.IAM_Subscription_Name__c, qsolApp.IAM_Subscription_End_Date__c));
                } else {
                    /* Get List of Free Apps to Insert */
                    accAppList.add(getAccFeatureAccessToCreate(appName, accAppToCreateMap.get(appName), reclaimedContact.AccountId,
                    modularitySet, '', null));
                }
            }
            insertUpdateDataRecord(accAppList, 'insert');
        }

        /* Update User Feature & Access */
        if(!conAppToUpdateList.isEmpty()) {
            insertUpdateDataRecord(conAppToUpdateList, 'update');
        }
        
        /* Create User Feature & Access */
        List<IAM_Contact_Provisioning__c> conAppCreateList = new List<IAM_Contact_Provisioning__c>();
        if(!conAppToCreateMap.isEmpty()) {
            Map<String, List<IAM_Application__c>> allAccountAppMap = 
            getAccountAppMap(reclaimedContact.AccountId);
            if(allAccountAppMap != null && !allAccountAppMap.isEmpty() && !conAppToCreateMap.isEmpty()) {
                for(String appName : conAppToCreateMap.Keyset()) {
                    IAM_Application__c accApp = allAccountAppMap.get(appName)[0];
                    conAppCreateList.add(getUserFeatureAccessToCreate(appName, accApp, reclaimedContact,
                    conAppToCreateMap.get(appName), modularitySet, userList));
                }
            }
        }
        if(!conAppToCreateGMMap.isEmpty()) {
            for(String accAppId : conAppToCreateGMMap.keySet()) {
                /* Add Guidanz Mobile User Feature & Access record to be created in th List */
                conAppCreateList.add(getUserFeatureAccessToCreate(Label.IAM_Guidanz_Mobile_App_Name, 
                accAppGMMap.get(accAppId), reclaimedContact,
                conAppToCreateGMMap.get(accAppId), modularitySet, userList));
            }            
        }
        if(!conAppCreateList.isEmpty()) {
            insertUpdateDataRecord(conAppCreateList, 'insert');
        }

        /* TO DO - Assign Permission Sets */
    }

    /* Prepare map for Account Feature & Access to be created */
    private static void prepareAccAppMapToCreate(IAM_Application_Groups__c appGrp,
    Map<String, String> accAppToCreateMap) {
        if(appGrp.IAM_Application_Name__c != Label.IAM_AppName_Cumpas
        || (appGrp.IAM_Application_Name__c == Label.IAM_AppName_Cumpas 
        && appGrp.IAM_DN_value__c.containsIgnoreCase('ou=app_dbu'))) {
            if(accAppToCreateMap.containsKey(appGrp.IAM_Application_Name__c)) {
                String role = accAppToCreateMap.get(appGrp.IAM_Application_Name__c);
                role = role + ';' + appGrp.IAM_Role_Name__c;
                accAppToCreateMap.put(appGrp.IAM_Application_Name__c, role);
            } else {
                accAppToCreateMap.put(appGrp.IAM_Application_Name__c,
                appGrp.IAM_Role_Name__c);
            }
        }
    }

    /* Prepare map for Contact Feature & Access to be created */
    private static void prepareConAppMapToCreate(IAM_Application_Groups__c appGrp,
    Map<String, String> conAppToCreateMap) {
        if(appGrp.IAM_Application_Name__c != Label.IAM_AppName_Cumpas
        || (appGrp.IAM_Application_Name__c == Label.IAM_AppName_Cumpas 
        && appGrp.IAM_DN_value__c.containsIgnoreCase('ou=app_dbu'))) {
            if(conAppToCreateMap.containsKey(appGrp.IAM_Application_Name__c)) {
                String role = conAppToCreateMap.get(appGrp.IAM_Application_Name__c);
                role = role + ';' + appGrp.IAM_Role_Name__c;
                conAppToCreateMap.put(appGrp.IAM_Application_Name__c, role);
            } else {
                conAppToCreateMap.put(appGrp.IAM_Application_Name__c,
                appGrp.IAM_Role_Name__c);
            }
        }
    }

    /* Prepare map for Contact Feature & Access to be updated */
    private static void prepareConAppListToUpdate(IAM_Application_Groups__c appGrp,
    Map<String, List<IAM_Contact_Provisioning__c>> contactAppMap, Contact reclaimedContact,
    List<User> userList, List<IAM_Contact_Provisioning__c> conAppToUpdateList) {
        List<IAM_Contact_Provisioning__c> conAppList = contactAppMap.get(appGrp.IAM_Application_Name__c);
        IAM_Contact_Provisioning__c conApp = conAppList[0];
        conApp.IAM_userId__c = reclaimedContact.Username__c;
        conApp.IAM_Is_Reclaim_Access_Email_Send__c = true;
        if(!userList.isEmpty()) {
            conApp.IAM_User__c = userList[0].Id;
        }
        if(conApp.IAM_Application_Name__c == Label.IAM_Cummins_Service_Training 
        && String.isNotBlank(reclaimedContact.IAM_Promotion__c)) {
            conApp.IAM_Promotion__c = reclaimedContact.IAM_Promotion__c;
        }
        if(!conAppToUpdateList.contains(conApp)) {
            conAppToUpdateList.add(conApp);
        }
    }
   
      
    @TestVisible
    private static void insertUpdateDataRecord(List<sObject> lstRecord, String action){
        Database.SaveResult[] srList;
        String errorString = '';
        if(action.equalsIgnoreCase('insert')) {
            srList = Database.insert(lstRecord, false);
        } else if(action.equalsIgnoreCase('update')) {
            srList = Database.update(lstRecord, false);
        }

        // Iterate through each returned result
        for(Database.SaveResult sr : srList) {
            if (sr.isSuccess()){
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted/updated records: ' + sr.getId());
            } else {
                errorString = 'Contact reclaim is not done properly. Please see the error:- ';
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()){
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    errorString += err.getMessage();
                }
            }
        }
        System.debug('error during inset or update errorString... ' + errorString);
    }

    /* Return existing Contact Provisioning records */
    private static Map<String, List<IAM_Contact_Provisioning__c>> getContactProvisionings(Id conId) {
        Map<String, List<IAM_Contact_Provisioning__c>> conProMap = 
        new Map<String, List<IAM_Contact_Provisioning__c>>();
        List<IAM_Contact_Provisioning__c> conProvisiningList = [
            SELECT Id
                 , IAM_Application_Name__c
                 , IAM_userId__c
                 , IAM_User__c
                 , IAM_Status__c
              FROM IAM_Contact_Provisioning__c
             WHERE IAM_Contact__c = :conId
               AND IAM_Status__c = :Label.IAM_Status_Active
        ];
        if(!conProvisiningList.isEmpty()){
            for(IAM_Contact_Provisioning__c conPro : conProvisiningList){
                if(conProMap.containsKey(conPro.IAM_Application_Name__c)) {
                    conProMap.get(conPro.IAM_Application_Name__c).add(conPro);
                } else {
                    conProMap.put(conPro.IAM_Application_Name__c, 
                    new List<IAM_Contact_Provisioning__c> {conPro});
                }
            }
            System.debug('#### Existing Contact Provisioning - ' + conProvisiningList);
        }
        return conProMap;
    }

    /* Return User List for Given Contact */
    private static List<User> getUserList(Id conId) {
        return [
            SELECT Id
                 , Username
              FROM User
             WHERE ContactId = :conId
        ];
    }

    /* Return Contact List for Given Contact */
    private static Contact getContactDetails(Id conId) {
        List<Contact> conList = [
            SELECT Id
                 , IAM_Applications__c
                 , AccountId
                 , IAM_is_Member_of__c
                 , Username__c
                 , IAM_Promotion__c
              FROM Contact
             WHERE Id = :conId
        ];
        if(!conList.isEmpty()) {
            System.debug('#### Reclaimed Contact ' + conList[0]);
            return conList[0];
        } else {
            return null;
        }
    }

    /* Return Map of Account Feature & Access object (App Name Vs Application) related to 
    Associated Account of Contact */
    private static Map<String, List<IAM_Application__c>> getAccountAppMap(Id accId) {
        List<IAM_Application__c> accountAppList = [
            SELECT Id
                 , IAM_Application_Name__c
                 , IAM_Account_Name__c
                 , IAM_Free_Subscription__c
                 , IAM_Role__c
                 , IAM_Status__c
                 , IAM_Subscription_Start_Date__c
                 , IAM_Subscription_End_Date__c
                 , IAM_Subscription_Name__c
                 , IAM_Subscription_Count__c
                 , IAM_Qsolview__c
                 , IAM_Qsolexpiration__c
                 , IAM_swregExpire__c
                 , IAM_Cumpas_Modularity__c
              FROM IAM_Application__c
             WHERE IAM_Account_Name__c = :accId
               AND IAM_Status__c = :Label.IAM_Status_Active
        ];

        Map<String, List<IAM_Application__c>> accountAppMap = new Map<String, List<IAM_Application__c>>();
        if(!accountAppList.isEmpty()) {
            for(IAM_Application__c accApp : accountAppList) {
                if(accountAppMap.containsKey(accApp.IAM_Application_Name__c)) {
                    accountAppMap.get(accApp.IAM_Application_Name__c).add(accApp);
                } else {
                    accountAppMap.put(accApp.IAM_Application_Name__c, new List<IAM_Application__c>{accApp});
                }
            }
        }
        System.debug('#### accountAppMap - ' + accountAppMap);
        return accountAppMap;
    }

    /* Return Account Feature Access & Record To Create */
    private static IAM_Application__c getAccFeatureAccessToCreate(String appName, String roles, Id accId,
    Set<String> modularitySet, String subscriptionName, Date endDate) {
        IAM_Application__c accApp = new IAM_Application__c();
        accApp.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(appName).getRecordTypeId(); 
        accApp.IAM_Account_Name__c = accId;
        if(appName == Label.IAM_Quick_Serve_Online || appName == Label.IAM_EDS || appName == 'INSITE'
        || appName == Label.IAM_Cummins_Service_Training || appName == Label.IAM_Guidanz_Mobile_App_Name){
            accApp.IAM_Free_Subscription__c = false;
            accApp.IAM_Subscription_Start_Date__c = System.today();
            accApp.IAM_Subscription_End_Date__c = endDate;
            accApp.IAM_Subscription_Name__c = subscriptionName;
        } else {
            accApp.IAM_Free_Subscription__c = true;
        }
        accApp.IAM_Application_Name__c = appName;
        accApp.IAM_Subscription_Count__c = Integer.valueof(Label.IAM_Default_App_Subscription_Count.trim()); 
        accApp.IAM_Status__c = Label.IAM_Status_Active;
        accApp.IAM_Role__c = roles;
        
        if(appName == Label.IAM_AppName_Cumpas && !modularitySet.isEmpty()) {
            accApp.IAM_Cumpas_Modularity__c = getModules(modularitySet, null);
        }
        System.debug('#### accApp - ' + accApp);
        return accApp;
    }

    /* Return User Feature & Access Record To Create */
    private static IAM_Contact_Provisioning__c getUserFeatureAccessToCreate(String appName, 
    IAM_Application__c accApp, Contact reclaimedContact, String roles, Set<String> modularitySet,
    List<User> userList) {
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId(); 
        conApp.IAM_Contact__c = reclaimedContact.Id;
        conApp.IAM_Start_Date__c = System.Today();
        conApp.IAM_Status__c = Label.IAM_Status_Active;
        conApp.IAM_Is_Reclaim_Access_Email_Send__c = true;
        conApp.IAM_Role__c = roles;
        if(appName.equalsIgnoreCase(Label.IAM_Cummins_Service_Training)) {
            conApp.IAM_Promotion__c = reclaimedContact.IAM_Promotion__c;
        }        
        if(!userList.isEmpty()){
            conApp.IAM_User__c = userList[0].Id;
        }
        conApp.IAM_End_Date__c = accApp.IAM_Subscription_End_Date__c;
        conApp.IAM_Application_Name__c = appName;
        conApp.IAM_Subscription_Name__c = accApp.IAM_Subscription_Name__c;
        conApp.IAM_Account_Application__c = accApp.Id;
        if(appName.equalsIgnoreCase(Label.IAM_AppName_Cumpas) && !modularitySet.isEmpty()) {
            conApp.IAM_Cumpas_Modularity__c = getModules(modularitySet, null);            
            if(String.isBlank(conApp.IAM_Role__c)){
                conApp.IAM_Role__c = Label.IAM_Cumpas_Default_Role;
            }
        } else if(appName.equalsIgnoreCase(Label.IAM_AppName_QSOL)){
            conApp.IAM_Qsolexpiration__c = accApp.IAM_Qsolexpiration__c;
            conApp.QSOLView__c = accApp.IAM_Qsolview__c;
        } else if(appName.equalsIgnoreCase(Label.IAM_Guidanz_Mobile_App_Name)) {
            conApp.IAM_Guidanz_Mobile_Roles__c = roles;
            conApp.IAM_swregExpire__c = accApp.IAM_swregExpire__c;
        }
        System.debug('#### conApp - ' + conApp);
        return conApp;
    }

    /* Return Maps From all Application Group Custom Setting */
    private static void getApplicationGroupsCS(Map<String, IAM_Application_Groups__c> dnValAppGrpMap,
    Map<String, Set<IAM_Application_Groups__c>> appGrpMap) {
        List<IAM_Application_Groups__c> applicationGroupsCSList = IAM_Application_Groups__c.getall().values();
        for(IAM_Application_Groups__c appGroup : applicationGroupsCSList) {
            dnValAppGrpMap.put(appGroup.IAM_DN_value__c.toUpperCase(), appGroup);
            if(appGrpMap.containsKey(appGroup.IAM_Application_Name__c)) {
                appGrpMap.get(appGroup.IAM_Application_Name__c).add(appGroup);
            } else {
                appGrpMap.put(appGroup.IAM_Application_Name__c, new Set<IAM_Application_Groups__c> {appGroup});
            }
        }
    }

    /* Concatinate & return all App DN values from Application Groups and Is Member of fields on Contact */
    private static String getAppAppDNOnContact(Contact reclaimedContact) {
        String appDNOnContact = '';
        if(String.isNotBlank(reclaimedContact.IAM_Applications__c)
        && String.isNotBlank(reclaimedContact.IAM_is_member_of__c)) {
            appDNOnContact = reclaimedContact.IAM_applications__c 
            + '|' + reclaimedContact.IAM_is_Member_of__c;
        }else if(String.isNotBlank(reclaimedContact.IAM_Applications__c)){
            appDNOnContact = reclaimedContact.IAM_applications__c;
        }else if(String.isNotBlank(reclaimedContact.IAM_is_member_of__c)){
            appDNOnContact = reclaimedContact.IAM_is_Member_of__c;
        }
        System.debug('#### appDNOnContact - ' + appDNOnContact);
        return appDNOnContact;
    }

    /* Return CUMPAS 2.0 Module String */
    private static String getModules(Set<String> modularitySet, String existingModules) {
        String modules = '';
        if(String.isNotBlank(existingModules)) {
            modules = existingModules + ';' + modules;
        }
        for(String modC : modularitySet){
            if(!modules.containsIgnoreCase(modC)) {
                if(String.isBlank(modules)) {
                    modules = modC;
                } else {
                    modules = modules + ';' + modC;
                }
            }
        }
        return modules;
    }    
}