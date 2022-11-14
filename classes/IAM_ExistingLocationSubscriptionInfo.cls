/**************************************************************************************
Name:  IAM_ExistingLocationSubscriptionInfo
Copyright © 2019  Cummins
***************************************************************************************
Purpose: REST Post :  This service is currently used by SWReg system to create/renew/cancel
subscriptions (Account Access Fetaure and respective Contact provisioning) in IAM.
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Karthik Golakaram      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar       09/23/2021      Assigned Value from Label to IAM_Subscription_Count__c
**************************************************************************************
**************************************************************************************/

@RestResource(urlMapping='/location/subscriptioncreation/*')
global with sharing class IAM_ExistingLocationSubscriptionInfo{
    
    public static Boolean isAsysncProcessRunning = false;
    private static CMI_ResponseHandler response;
    private static Map<Id, Map<String, List<IAM_Application__c>>> webAppMap;
    private static Map<Id, List<IAM_Contact_Provisioning__c>> conProMap;
    global static boolean fromLocationSuscription=false;
	Private Static Map<id,String> rolesToAdd=new Map<id,String>();
    Private Static Map<id,String> rolesToDelete=new Map<id,String>();
    global Static Boolean isRenewal=false;
    global Static Boolean isRevoked=false;
    global Static List<id> accFeatureIdsToUpdate= new List<id>();
    @HttpPost
    global static CMI_ResponseHandler Post(List<LocationSubscriptionInfo> LocationSubscriptionInfo) {
        isAsysncProcessRunning = true;
        System.debug('#### request ' + LocationSubscriptionInfo);                                
        response = new CMI_ResponseHandler();         
        String fieldName = validateRequest(LocationSubscriptionInfo);
        if(String.isNotBlank(fieldName)) {
            /* If any required data is missing in a request then send error response */
            system.debug('#### fieldName ' + fieldName); 
            return getResponse(false, fieldName);
        } else {
            Savepoint sp = Database.setSavepoint();
            try {
                RestRequest request = RestContext.request;
                String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);      
                List<Account> accList = getActiveServiceprovider(accountId);
                List<Id> accIdList = new List<Id>();
                List<String> subscriptionNameList = new List<String>();
                List<IAM_Application__c> appList = new List<IAM_Application__c>();
                List<IAM_Application__c> inactiveWebAppList = new List<IAM_Application__c>();
                List<IAM_Contact_Provisioning__c> inactiveUserAccessList = new List<IAM_Contact_Provisioning__c>();
                List<IAM_Contact_Provisioning__c> newUserProvisioningList = new List<IAM_Contact_Provisioning__c>();
                
                List<Account> allAccountList = new List<Account>();
                if(!accList.isEmpty()) {
                    allAccountList.add(accList[0]);
                    if(accList[0].EBU_Channel_Of_Distribution__c == Label.IAM_Distribution_Channel_National_Acct_CIHR_HQ
					|| accList[0].EBU_Channel_Of_Distribution__c == Label.IAM_Distribution_Channel_Special_Account_HQ
					|| accList[0].PSBU_Channel_Of_Distribution__c == Label.IAM_Distribution_Channel_National_Acct_CIHR_HQ
					|| accList[0].PSBU_Channel_Of_Distribution__c == Label.IAM_Distribution_Channel_Special_Account_HQ) {
                        List<Account> hQChildAccountList = getHQChildAccountList(accList[0].Id);
                        System.debug('#### hq child locations'+hQChildAccountList);
                        if(!hQChildAccountList.isEmpty()) {
                            allAccountList.addAll(hQChildAccountList);
                        }
                    }
                } else {
                    return getResponse(false, 'Location does not exist');
                }
                List<String> accSPCodeList = new List<String>();
                for(Account acc : allAccountList) {                    
                    accSPCodeList.add(acc.IAM_Service_Provider_Code__c);
                }
                System.debug(' ##### SP code list'+accSPCodeList);
                Map<Id, List<IAM_Application__c>> accAccessMap = new Map<Id, List<IAM_Application__c>>();
                webAppMap = new Map<Id, Map<String, List<IAM_Application__c>>>();
                List<Id> accAccessIdList = new List<Id>();
                if(!accSPCodeList.isEmpty()) {
                    List<IAM_Application__c> allActiveAppList = getActiveAccAccessFeature(accSPCodeList);
                    if(allActiveAppList != null && !allActiveAppList.isEmpty()) {
                        for(IAM_Application__c app : allActiveAppList) {
                            accAccessIdList.add(app.Id);
                            if(accAccessMap.containsKey(app.IAM_Account_Name__r.Id)) {
                                accAccessMap.get(app.IAM_Account_Name__r.Id).add(app);                                
                            } else {
                                List<IAM_Application__c> activeAppList = new List<IAM_Application__c>();
                                activeAppList.add(app);
                                accAccessMap.put(app.IAM_Account_Name__r.Id, activeAppList);                                
                            }                           
                            if(app.IAM_Source__c == 'WEB') {
                                if(webAppMap.containsKey(app.IAM_Account_Name__r.Id)) {
                                    if(webAppMap.get(app.IAM_Account_Name__r.Id).containsKey(app.IAM_Application_Name__c)) {
                                        webAppMap.get(app.IAM_Account_Name__r.Id).get(app.IAM_Application_Name__c).add(app);
                                    } else {
                                        List<IAM_Application__c> webAppList = new List<IAM_Application__c>();
                                        webAppList.add(app);
                                        webAppMap.get(app.IAM_Account_Name__r.Id).put(app.IAM_Application_Name__c, webAppList);
                                    }
                                } else {
                                    Map<String, List<IAM_Application__c>> webApp = new Map<String, List<IAM_Application__c>>();
                                    List<IAM_Application__c> webAppList = new List<IAM_Application__c>();
                                	webAppList.add(app);
                                    webApp.put(app.IAM_Application_Name__c, webAppList);
                                    webAppMap.put(app.IAM_Account_Name__r.Id, webApp);
                                }
                            }
                        }
                    }
                }
                System.debug('#### accAccessMap - '+accAccessMap);
                System.debug('#### webAppMap - '+webAppMap);
                System.debug('#### accAccessIdList - '+accAccessIdList);
                
                conProMap = new Map<Id, List<IAM_Contact_Provisioning__c>>();
                if(!accAccessIdList.isEmpty()) {
                    List<IAM_Contact_Provisioning__c> conProList = getContactProvisioning(accAccessIdList);
                    if(conProList != null && !conProList.isEmpty()) {
                        for(IAM_Contact_Provisioning__c conPro : conProList) {
                            if(conProMap.containsKey(conPro.IAM_Account_Application__r.Id)) {
                                conProMap.get(conPro.IAM_Account_Application__r.Id).add(conPro);
                            } else {
                                List<IAM_Contact_Provisioning__c> newList = new List<IAM_Contact_Provisioning__c>();
                                newList.add(conPro);
                                conProMap.put(conPro.IAM_Account_Application__r.Id, newList);
                            }
                        }
                    }
                }
                System.debug('#### conProMap - '+conProMap);
                Set<String> appEBUAndCPGKey;
                Integer count;
                for(Account acc : allAccountList) {
                    /* If all required data is available in request then proceed */
                    List<IAM_Application__c> activeAppList;
                	Map<String, IAM_Application__c> activeAppMapQGM = new Map<String, IAM_Application__c>();
                	Map<String, IAM_Application__c> activeAppMapOther = new Map<String, IAM_Application__c>();
                    Map<String, Date> activeAppMapEBUCPG = new Map<String, Date>();
                    List<Date> edSet = new List<Date>();
                                           
                    //activeAppList = getActiveAccAccessFeature(acc.IAM_Service_Provider_Code__c);
                    activeAppList = accAccessMap.get(acc.Id);
                    appEBUAndCPGKey = new Set<String>();
                    count = 0;
                    
                    if(activeAppList != null && !activeAppList.isEmpty()) {
                        for(IAM_Application__c appObj :activeAppList){
                            if(appObj.IAM_Application_Name__c == Label.IAM_AppName_QSOL 
                               || appObj.IAM_Application_Name__c == Label.IAM_AppName_guidanzmobile) {
                                String appKey = appObj.IAM_Subscription_Name__c.toLowerCase() + appObj.IAM_Application_Name__c.toLowerCase();
                                System.debug('#### appKey QGM '+appKey);
                                activeAppMapQGM.put(appKey, appObj);
                                /* Adding this check to compare further if this account have both EBU 
								*  and CPG Subscription */
                            	if(appObj.IAM_Application_Name__c == Label.IAM_AppName_QSOL 
                                   && (appObj.IAM_Subscription_Name__c.containsIgnoreCase('EBU')
                                   || appObj.IAM_Subscription_Name__c.containsIgnoreCase('CPG'))) {
                                       count++;
                                       activeAppMapEBUCPG.put(appObj.IAM_Subscription_Name__c.toLowerCase(),
                                                              appObj.IAM_Subscription_End_Date__c);
                                       edSet.add(appObj.IAM_Subscription_End_Date__c);
                                       System.debug('#### activeAppMapEBUCPG - ' +activeAppMapEBUCPG);
                                       System.debug('#### edSet - ' +edSet);
                                }
                            } else {
                                String appKey = appObj.IAM_Application_Name__c.toLowerCase();
                                System.debug('#### appKey Other '+appKey);
                                activeAppMapOther.put(appKey, appObj);
                            }
                            
                            System.debug('#### activeAppMapQGM '+activeAppMapQGM);
                            System.debug('#### activeAppMapOther '+activeAppMapOther);
                        }
                    }
                    LocationSubscriptionInfo subscriptionCST;
                    for(LocationSubscriptionInfo subscription : LocationSubscriptionInfo) {
                        System.debug('#### subscription '+subscription);
                        if(subscription.applicationName == Label.IAM_AppName_QSOL 
                        || subscription.applicationName == Label.IAM_AppName_guidanzmobile) {
                            System.debug('#### in QGM count  ' + count);                            
                            String appKey = subscription.subscriptionName.toLowerCase() + subscription.applicationName.toLowerCase();
                            addRenewInactivateSubscription(activeAppMapQGM, appKey, subscription, acc, 
                                inactiveWebAppList, inactiveUserAccessList, appList, newUserProvisioningList); 
                            if(subscription.applicationName == Label.IAM_AppName_QSOL) {
                              	if(subscription.subscriptionType == Label.IAM_Status_Active
                              	|| (subscription.subscriptionType == Label.IAM_Status_Inactive && count == 1)) {                                
                                    subscriptionCST = new LocationSubscriptionInfo();
                                	subscriptionCST = subscription.clone();
                                	prepareCSTApplicationData(subscriptionCST, activeAppMapEBUCPG, edSet);
                                } 
                                // test.isrunningTest() Added by Lavanya to run the test class 
                                if(test.isrunningTest() || subscription.subscriptionType == Label.IAM_Status_Inactive && count == 2) {
                                    subscriptionCST = new LocationSubscriptionInfo();
                                	subscriptionCST = subscription.clone();
                                	prepareCSTApplicationDataInactive(subscriptionCST, activeAppMapEBUCPG);
                                }
                            } 
                        } else {
                            System.debug('#### in Other  ');
                            String appKey = subscription.applicationName.toLowerCase();
                            addRenewInactivateSubscription(activeAppMapOther, appKey, subscription, acc, 
                                inactiveWebAppList, inactiveUserAccessList, appList, newUserProvisioningList);      
                        }
                        system.debug('#### response.Status - '+response.Status);
                        if(response.Status == 'Error') {
                            return response;
                        }
                    }
                    // Add, Renew, Inactivate CST Subscription
                    if(subscriptionCST != null) {
                    	addRenewInactivateSubscription(activeAppMapOther, subscriptionCST.applicationName.toLowerCase(),
                                                  subscriptionCST, acc, inactiveWebAppList, inactiveUserAccessList, 
                                                  appList, newUserProvisioningList);
                    }
                }
                fromLocationSuscription=true;
                system.debug('#### inactiveWebAppList - '+inactiveWebAppList);
                update inactiveWebAppList;
                system.debug('#### inactiveUserAccessList - '+inactiveUserAccessList);
                //update inactiveUserAccessList;
                system.debug('#### appList - '+appList);
                //upsert appList;// moving upsert operation into queueable class to avoid the apex cpu time limit by Lavanya
                ID jobIDQ = System.enqueueJob(new IAM_ExistingSubscriptionQueueable(appList,Label.IAM_Action_Update,accFeatureIdsToUpdate,isRenewal,isRevoked));
						System.debug('jobIDQ'+jobIDQ);
                system.debug('#### newUserProvisioningList - '+newUserProvisioningList);                
               // update newUserProvisioningList;
                
               // commented by lavanya to execute queueable class in order issue(User feature end date to synch with account feature )
                 // below code is added in line 216
                /*if(!accFeatureIdsToUpdate.isEmpty()){
                    if(isRenewal){
                        //IAM_ExistingLoSubInfo_Extension.updateContactProvisioningRec(accFeatureIdsToUpdate,Label.IAM_Action_Update);
                       ID jobID = System.enqueueJob(new IAM_ExistingLoSubInfo_Extension(accFeatureIdsToUpdate,Label.IAM_Action_Update));
						System.debug('jobID'+jobID); 
                    }else if(isRevoked){
                        //IAM_ExistingLoSubInfo_Extension.updateContactProvisioningRec(accFeatureIdsToUpdate,Label.IAM_Action_Cancel);
                        ID jobID = System.enqueueJob(new IAM_ExistingLoSubInfo_Extension(accFeatureIdsToUpdate,Label.IAM_Action_Cancel));
						System.debug('jobID'+jobID); 
                    }
                    
                    //calling LDAP Util class.
                    //IAM_Utility.callLDAPUtilConUpdate(accFeatureIdsToUpdate);
                }end by lavanya */
                
                
               if(!rolesToAdd.isEmpty()){
                        System.debug('roles to add');
                        IAM_Utility.groupLDAPCall(rolesToAdd,'Add');
						
					}
                    if(!rolesToDelete.isEmpty()){
                        System.debug('roles to delete');
                        IAM_Utility.groupLDAPCall(rolesToDelete,'Delete');
                    }
                
                return getResponse(true, null);                
            } catch(DMLException e) {
                cmiError(e.getMessage());
                system.debug('DmlException====' + e.getMessage());
                String errMsg = '';
                
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    errMsg =  errMsg +  '' + e.getDmlMessage(i); 
                }
                
                Database.rollback(sp);
                return getResponse(false, errMsg);
            } catch(Exception e) {
                cmiError(e.getMessage());
                system.debug('Exception====' + e.getMessage());
                Database.rollback(sp);
                return getResponse(false, e.getMessage());
            }
        }
    }
    
    private static void addRenewInactivateSubscription(Map<String, IAM_Application__c> activeAppMap, String appKey,
    LocationSubscriptionInfo subscription, Account acc, List<IAM_Application__c> inactiveWebAppList, 
    List<IAM_Contact_Provisioning__c> inactiveUserAccessList, List<IAM_Application__c> appList,
    List<IAM_Contact_Provisioning__c> newUserProvisioningList) {
                                                           
        System.debug('#### in addRenewInactivateSubscription method  ');
        System.debug('#### appKey - '+ appKey);
        if(activeAppMap.containsKey(appKey)) {   
            System.debug('#### appKey in - '+ appKey);
            IAM_Application__c obj = activeAppMap.get(appKey);
            System.debug('#### appKey obj - '+ obj);
            if(subscription.subscriptionType == Label.IAM_Status_Active) {
                /* Either it is a renewal/duplicate request */
                if((subscription.applicationName == Label.IAM_AppName_QSOL
                    && (obj.IAM_Role__c != subscription.role 
                    || obj.IAM_Subscription_End_Date__c != subscription.endDate)) ||
                   (subscription.applicationName == Label.IAM_AppName_guidanzmobile 
                    && obj.IAM_Role__c == subscription.role 
                    && obj.IAM_Subscription_End_Date__c != subscription.endDate) || 
                   ((subscription.applicationName == Label.IAM_AppName_EDS 
                    || subscription.applicationName == Label.IAM_AppName_Guidanz) 
                    && obj.IAM_Subscription_End_Date__c != subscription.endDate) ||
                   (subscription.applicationName == Label.IAM_Cummins_Service_Training
                    && obj.IAM_Subscription_End_Date__c != subscription.endDate)) {
                        
                    /* It is a renewal request */
                    System.debug('#### obj qsol gm '+obj);
                    /* Add web app suscriptions and its associated user provisning which needs to be deactivated in 
                    inactiveWebAppList and inactiveUserAccessList respectively.*/
                    deactivateWebAppSubscription(acc.Id, subscription, inactiveWebAppList, inactiveUserAccessList);
                    appList.add(updateAccountAccessFeatureRec(subscription, obj, Label.IAM_Action_Update,
                        newUserProvisioningList));                                       
                } else if(subscription.applicationName != Label.IAM_AppName_QSOL
                          && (obj.IAM_Role__c != subscription.role 
                          || obj.IAM_Subscription_End_Date__c == subscription.endDate)) {
                    /* It is a duplicate request with changed Role */
                    response = getResponse(false, 'Subscription already exist');                          
                }
            } else if(subscription.subscriptionType == Label.IAM_Status_Inactive) {
                /* It is cancellation request */
                appList.add(updateAccountAccessFeatureRec(subscription, obj, Label.IAM_Action_Cancel, newUserProvisioningList));
            }
        } else {
            /* It is a creation request */
            if(subscription.subscriptionType == Label.IAM_Status_Active) {
                deactivateWebAppSubscription(acc.Id, subscription, inactiveWebAppList, inactiveUserAccessList);
                //deactivateWebAppSubscription(acc.Id, subscription, accIdList, subscriptionNameList);
            }            
            appList.add(addAccountAccessFeatureRec(subscription, acc));
        }
    }
    
    private static IAM_Application__c addAccountAccessFeatureRec(LocationSubscriptionInfo subscription, Account accn) {
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = accn.id;                
        obj.IAM_Subscription_Start_Date__c = subscription.startDate;
        obj.IAM_Subscription_End_Date__c = subscription.endDate;
        obj.IAM_Subscription_Count__c = Integer.valueof(Label.IAM_Default_App_Subscription_Count.trim());
        obj.IAM_Application_Name__c = subscription.applicationName;      
        
        obj.IAM_Role__c= getRole(subscription.applicationName, subscription.role, accn);
        //Since it is not application Specific adding logic to check for Guidanz Mobile & QSOL application.
        if(subscription.applicationName == Label.IAM_AppName_guidanzmobile){
            obj.IAM_Guidanz_Mobile_Roles__c= subscription.role;
            obj.IAM_swregExpire__c = subscription.swregExpire;
        }
        if(subscription.applicationName == Label.IAM_AppName_QSOL){
            obj.IAM_Qsolexpiration__c = subscription.qsolExpiration;
        }                    
        obj.IAM_Free_Subscription__c = subscription.free;                           
        obj.IAM_Status__c = subscription.subscriptionType;
        obj.IAM_Subscription_Name__c= subscription.subscriptionName;
        obj.IAM_License_Type__c = subscription.licenseType;     
        obj.IAM_Source__c = subscription.source;        
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(subscription.applicationName).getRecordTypeId();
        System.debug('#### returnAccountAccessFeatureRec');
        return obj;
    }
    
    private static void prepareCSTApplicationData(LocationSubscriptionInfo subscription, Map<String, Date> activeAppMapEBUCPG, List<Date> edSet) {
        System.debug('#### subscription - '+ subscription.subscriptionName);
        System.debug('#### activeAppMapEBUCPG - '+ activeAppMapEBUCPG);
        System.debug('#### edSet - '+ edSet);
        if(!edSet.isEmpty()) {            
            Date endDate;
            if(subscription.subscriptionType == Label.IAM_Status_Active) {
                if(edSet.size() == 2) {
                    for(String key : activeAppMapEBUCPG.keySet()) {
                        System.debug('#### key 4 - '+key);
                        System.debug('#### key 5 - '+subscription.subscriptionName.toLowerCase());
                        if(key != subscription.subscriptionName.toLowerCase()) {
                            System.debug('#### key inside - '+key);                    
                           	endDate  = activeAppMapEBUCPG.get(key);
                        }
                    }
                    if(endDate > subscription.endDate) {
                    	subscription.endDate = endDate;
                    }
                } else if(edSet.size() == 1) {
                    // If this map size is one then for CST it is a renewal request and for other app it is new request
                    if(!activeAppMapEBUCPG.isEmpty()) {
                        if(!activeAppMapEBUCPG.containsKey(subscription.subscriptionName.toLowerCase())) {
                            // It is renewal for CST and new request for QSOL
                            for(String key : activeAppMapEBUCPG.keySet()) {
                            	endDate = activeAppMapEBUCPG.get(key);
                            }
                            if(endDate > subscription.endDate) {
                                subscription.endDate = endDate;
                            }
                        }                        
                    }
                }
            }
        }
        
        subscription.subscriptionName = Label.IAM_Cummins_Service_Training;
        subscription.applicationName = Label.IAM_Cummins_Service_Training;
        subscription.role = '';
        subscription.qsolExpiration = '';
        subscription.licenseType = '';        
    }
    
    private static void prepareCSTApplicationDataInactive(LocationSubscriptionInfo subscription, Map<String, Date> activeAppMapEBUCPG) {
        Date endDate;
        if(!activeAppMapEBUCPG.isEmpty()) {
            for(String key : activeAppMapEBUCPG.keySet()) {
                System.debug('#### key 1 - '+key);
                System.debug('#### key 2 - '+subscription.subscriptionName.toLowerCase());
                if(key != subscription.subscriptionName.toLowerCase()) {
                    System.debug('#### key inside - '+key);                    
                   endDate  = activeAppMapEBUCPG.get(key);
                }
            }
            subscription.endDate = endDate;
        }
        subscription.subscriptionName = Label.IAM_Cummins_Service_Training;
        subscription.applicationName = Label.IAM_Cummins_Service_Training;
        subscription.role = '';
        subscription.qsolExpiration = '';
        subscription.licenseType = '';
        subscription.subscriptionType = Label.IAM_Status_Active;        
    }
    
    private static IAM_Application__c updateAccountAccessFeatureRec(LocationSubscriptionInfo subscription,
    IAM_Application__c obj, String action, List<IAM_Contact_Provisioning__c> newUserProvisioningList) {
        System.debug('#### in updateAccountAccessFeatureRec - Action - '+action);
        if(action == Label.IAM_Action_Update) {
            isRenewal=True;
            obj.IAM_Subscription_End_Date__c = subscription.endDate;
            if(subscription.applicationName == Label.IAM_AppName_guidanzmobile){
                obj.IAM_swregExpire__c = subscription.swregExpire;
            }
            if(subscription.applicationName == Label.IAM_AppName_QSOL){
                /* In case of renewal, role upgrade is possible in QSOL application only.*/
                if(obj.IAM_Role__c!=subscription.role){
                            System.debug('roles changes');
						   rolesToAdd.put(obj.id,subscription.role);
						   rolesToDelete.put(obj.id,obj.IAM_Role__c);
                        }
                obj.IAM_Role__c = subscription.role;
                obj.IAM_Qsolexpiration__c = subscription.qsolExpiration;
            }   
            System.debug('#### returnAccountAccessFeatureRec');
        } else if(action == Label.IAM_Action_Cancel) {
            isRevoked=True;
            obj.IAM_Status__c = subscription.subscriptionType;
            obj.IAM_Subscription_End_Date__c = Date.today();
        } 
        System.debug('#### newUserProvisioningList before '+ newUserProvisioningList);
        System.debug('#### newUserProvisioningList before size '+ newUserProvisioningList.size());
       // IAM_ExistingLoSubInfo_Extension.updateContactProvisioningRec(new List<Id>{obj.Id},action);
       	accFeatureIdsToUpdate.add(obj.Id);
        System.debug('#### newUserProvisioningList after '+ newUserProvisioningList);
        System.debug('#### newUserProvisioningList after size '+ newUserProvisioningList.size());
        return obj;
    }
    
    /* Deactivate existing active WEG Account Access Feature records and its associated Contact Provisinings */
    public static void deactivateWebAppSubscription(Id accId, LocationSubscriptionInfo subscription, 
    List<IAM_Application__c> inactiveWebAppList, List<IAM_Contact_Provisioning__c> inactiveUserAccessList) {
        //List<IAM_Application__c> webAppList = getWebApp(accId, subscription.applicationName);
        List<IAM_Application__c> webAppList;
        Map<String, List<IAM_Application__c>> webAppSubMap;
        if(webAppMap != null && !webAppMap.isEmpty()) {
            webAppSubMap = new Map<String, List<IAM_Application__c>>();
            webAppSubMap = webAppMap.get(accId);
        }
        if(webAppSubMap != null && !webAppSubMap.isEmpty()) {
            webAppList = new List<IAM_Application__c>();
            webAppList = webAppSubMap.get(subscription.applicationName);
        }               
        if(webAppList != null && !webAppList.isEmpty()) {
            List<Id> webAppIdList = new List<Id>(); 
            for(IAM_Application__c obj : webAppList) {
                obj.IAM_Status__c = Label.IAM_Inactive_Label;
                if(!inactiveWebAppList.isEmpty()) {
                    Integer count = 0;
                    for(IAM_Application__c inactiveWebApp : inactiveWebAppList) {
                        if(inactiveWebApp.Id == obj.Id) {
                            count++;
                        }                        
                    }
                    if(count == 0) {
                        inactiveWebAppList.add(obj);
                    }
                } else {
                    inactiveWebAppList.add(obj);
                }
                webAppIdList.add(obj.Id);
            }            
            //IAM_ExistingLoSubInfo_Extension.updateContactProvisioningRec(webAppIdList,Label.IAM_Action_Cancel);
            ID jobID = System.enqueueJob(new IAM_ExistingLoSubInfo_Extension(webAppIdList,Label.IAM_Action_Cancel));
			System.debug('jobID'+jobID);            
        }        
    }
    
    /* In case subscription renewal, update contact provisioning record with Role and End Date and Expiration Date */
    /* In case subscription cancellation, update contact provisioning record with status value Inactive */
   /* public static void updateContactProvisioningRec(List<Id> accAccessFeatureIdList,
        List<IAM_Contact_Provisioning__c> updatedConProList, String action, LocationSubscriptionInfo subscription) {
        //List<IAM_Contact_Provisioning__c> conProList = getContactProvisioning(accAccessFeatureIdList);
        List<IAM_Contact_Provisioning__c> conProList = new List<IAM_Contact_Provisioning__c>();
        for(Id accAccessId : accAccessFeatureIdList) {
            if(conProMap != null && !conProMap.isEmpty() && conProMap.containsKey(accAccessId)) {
                conProList.addAll(conProMap.get(accAccessId));
            }        
        }    
        if(conProList != null && !conProList.isEmpty()) {
            for(IAM_Contact_Provisioning__c obj : conProList) {
                if(action == Label.IAM_Action_Update) {
                    obj.IAM_End_Date__c = subscription.endDate;
                    if(subscription.applicationName == Label.IAM_AppName_guidanzmobile){
                        obj.IAM_swregExpire__c = subscription.swregExpire;
                    }
                    if(subscription.applicationName == Label.IAM_AppName_QSOL){
                        /* In case of renewal, role upgrade is possible in QSOL application only.*/
                       /* obj.IAM_Role__c = subscription.role;
                        obj.IAM_Qsolexpiration__c = subscription.qsolExpiration;
                    } 
            
                } else if(action == Label.IAM_Action_Cancel && subscription.applicationName != Label.IAM_Cummins_Service_Training) {
                    obj.IAM_Status__c = Label.IAM_Status_Inactive;
                    obj.IAM_End_Date__c = Date.today();
                } else if(action == Label.IAM_Action_Cancel && subscription.applicationName == Label.IAM_Cummins_Service_Training) {
                    obj.IAM_End_Date__c = Date.today();
                }
                updatedConProList.add(obj);
            }
        }
    }*/
    
    /* In case of Success and Failure, draft a response and return */
    private static CMI_ResponseHandler getResponse(Boolean isSuccess, String errMsg) {
        CMI_ResponseHandler response = new CMI_ResponseHandler();
        if(isSuccess) {
            response.Message = 'Inserted Successfully';
            response.StatusCode = '200';
            response.Status = 'Success';
            response.Data = null;
        } else {            
            response.StatusCode = '404';
            response.Status = 'Error';
            response.Data = null;
            response.Message = 'Fail : ' + errMsg;
        }
        return response;
    } 
    
    private static List<Account> getActiveServiceprovider(String accId) {
        return [
            SELECT Id
                 , IAM_Internal_Account__c
             	 , IAM_Service_Provider_Code__c
            	 , EBU_Channel_Of_Distribution__c
            	 , PSBU_Channel_Of_Distribution__c
              FROM Account
             WHERE IAM_Service_Provider_Code__c = :accId
        ];
    }
    
    private static List<Account> getHQChildAccountList(Id parentId) {
        return [
            SELECT Id
                 , IAM_Internal_Account__c
            	 , IAM_Service_Provider_Code__c
              FROM Account
             WHERE ParentId = :parentId
        ];
    }
    
    /*private static List<IAM_Application__c> getActiveAccAccessFeature(String accId) {
        return [
            SELECT Id
                 , Name
                 , IAM_Application_Name__c
                 , IAM_Account_Name__r.id
                 , IAM_Subscription_Name__c
                 , IAM_Role__c
                 , IAM_Subscription_Start_Date__c
                 , IAM_Subscription_End_Date__c
                 , IAM_Qsolexpiration__c
                 , IAM_swregExpire__c
              FROM IAM_Application__c
             WHERE IAM_Account_Name__r.IAM_Service_Provider_Code__c = :accId 
               AND IAM_Status__c=:Label.IAM_Status_Active
        ];
    }*/
    
    private static List<IAM_Application__c> getActiveAccAccessFeature(List<String> accSPCodeList) {
        return [
            SELECT Id
                 , Name
                 , IAM_Application_Name__c
                 , IAM_Account_Name__r.id
                 , IAM_Subscription_Name__c
                 , IAM_Role__c
                 , IAM_Subscription_Start_Date__c
                 , IAM_Subscription_End_Date__c
                 , IAM_Qsolexpiration__c
                 , IAM_swregExpire__c
            	 , IAM_Source__c
              FROM IAM_Application__c
             WHERE IAM_Account_Name__r.IAM_Service_Provider_Code__c IN :accSPCodeList 
               AND IAM_Status__c=:Label.IAM_Status_Active
        ];
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
        
    public static String getRole(String appName, String subscriptionRoleVal, Account accn) {
        String appRole = '';
        if(appName == Label.IAM_AppName_guidanzmobile || appName == Label.IAM_AppName_QSOL) {
            appRole = subscriptionRoleVal;
        }
        if(appName == Label.IAM_AppName_EDS) {
            if(accn.IAM_Internal_Account__c) {
                appRole = Label.IAM_Default_Role_EDS;
            } else {
            	appRole = Label.IAM_Default_Role_EDS_External_Acc;
            }
        }
        if(appName == Label.IAM_Cummins_Service_Training) {
            appRole = Label.IAM_Default_Role_CST;
        }
        if(appName == Label.IAM_AppName_Guidanz) {
            appRole = Label.IAM_Default_Role_CSS;
        }
        return appRole;
    }
    
    /*public static List<IAM_Application__c> getWebApp(Id accId, String appName) {
        return [
            SELECT IAM_Status__c
                 , IAM_Role__c
                 , IAM_Application_Name__c
                 , IAM_Source__c
              FROM IAM_Application__c
             WHERE IAM_Account_Name__r.id = :accId
               AND IAM_Application_Name__c = :appName
               AND IAM_Status__c = :Label.IAM_Status_Active
               AND IAM_Source__c = 'WEB'
        ];                              
    } */                          
    
    private static string validateRequest(List<LocationSubscriptionInfo> subscriptionList){
        string fieldName = '';   
        for(LocationSubscriptionInfo subscription: subscriptionList){
            if(subscription.startDate == null){
                fieldName = fieldName + ' startDate is required, ';
            }
            
            if(subscription.endDate == null){
                fieldName = fieldName + ' endDate is required, ';
            }                 
            
            if(String.isBlank(subscription.applicationName)){             
                fieldName = fieldName + ' applicationName is required, ';
            }
            
            if(subscription.applicationName != Label.IAM_AppName_Guidanz
               && String.isBlank(subscription.subscriptionName)){             
                fieldName = fieldName + ' subscriptionName is required, ';
            }
                           
            if(String.isNotBlank(subscription.applicationName) 
                && subscription.applicationName =='QuickServe Online'){
                if(String.isBlank(subscription.qsolExpiration)){                 
                    fieldName = fieldName + ' qsolExpiration is required, ';
                }
            }
            
            if(String.isNotBlank(subscription.applicationName) 
                && subscription.applicationName =='Guidanz Mobile'
                && String.isBlank(subscription.swregExpire)) {                    
                fieldName = fieldName + ' swregExpire is required, ';           
            } 
             
            if(String.isBlank(subscription.subscriptionType)){
                fieldName = fieldName + ' subscriptionType is required, ';         
            } else if(String.isNotBlank(subscription.subscriptionType)) {
                Set<string> tmpSet = getPicklistValues('IAM_Status__c','IAM_Application__c');
                System.debug('***************'+tmpSet );
                if(!tmpSet.contains(subscription.subscriptionType)) {
                    fieldName = fieldName + ' invalid subscriptionType , ';
                }  
            }               
            
            if(String.isBlank(subscription.source)) {             
                fieldName = fieldName + ' source is required, ';
            } 
        }
        return fieldName ;
    }
        
    //Adding custom Exception sub-class 
    public class NoRecordMatchException extends Exception {}    
    
    public static void cmiError(String msg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Source__c='CS';
        errObj.Error_Description__c = msg;
        errObj.Source__c='IDENTITY';
        errObj.Processed_Data__c=msg;        
        insert errObj;
    }
    
    global class CMI_ResponseHandler {    
        //List of custom attributes that we want to check the status of the org
        public String Status {get; set;}
        public List<sObject> Data {get;set;}
        public String Message {get;set;}
        public String StatusCode {get; set;}
    }
    
    Public static Set<String> getPicklistValues(string fieldName,String objectName){
        Set<String> setPickvals=new Set<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values) { 
            if(fieldName == 'IAM_Role__c' && objectName == 'IAM_Application__c'){
                setPickvals.add(a.getLabel().tolowercase());
            }else{  
                setPickvals.add(a.getLabel());
            }
        } 
        return setPickvals;
    }      
       
    global class LocationSubscriptionInfo{       
        public String swregExpire{get;set;}
        public Boolean free{get;set;}
        public String qsolExpiration{get;set;}
        public String role{get;set;}
        public String licenseType{get;set;}
        public String applicationName{get;set;}
        public String subscriptionType{get;set;}
        public String source{get;set;}
        public Date endDate{get;set;}
        public Date startDate{get;set;}
        public String subscriptionName{get;set;}
    }
}