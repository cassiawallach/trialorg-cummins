/*************************************************************************************
Name:  IAM_UserSubscriptionCreation
Copyright © 2019  Cummins
**************************************************************************************
Purpose: REST Post :  It creates/renew/revoke user subscriptions for paid application
for given username
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Karthik Golakaram      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar       09/23/2021      Assigned Value from Label to IAM_Subscription_Count__c
**************************************************************************************
**************************************************************************************/

@RestResource(urlMapping='/user/newsubscriptioncreation/*')
global with sharing class IAM_UserSubscriptionCreation{
    
    private static CMI_ResponseHandler response;
    
    @HttpPost
    global static CMI_ResponseHandler Post(NewSubscriptionInfo NewSubscriptionInfo) {
        NewSubscriptionInfo subscription = NewSubscriptionInfo;
        system.debug('#### request====' + subscription);                             
        //RestRequest req = RestContext.request;
        response = new CMI_ResponseHandler();        
        String fieldName = validateRequest(subscription);
        List<IAM_Application__c> subscriptionLOP= new List<IAM_Application__c>();
        Set<id> lopIDs= new Set<id>();
        if(String.isNotBlank(fieldName)) {
            /* If any required data is missing in a request then send error response */
            response = getResponse(false, fieldName);
        } else {
            Savepoint sp = Database.setSavepoint();
            try {
                RestRequest request = RestContext.request;
                String username = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
                List<Contact>  con = getContact(username);
                if(con == null || con.isEmpty()) {
                    return getResponse(false, 'Username does not exist');
                }
                system.debug('subscription@@@@'+subscription);
                system.debug('con[0].AccountId@@@@'+con[0].AccountId);
                List<IAM_Application__c> activeAppList = getAccFeatureAccessList(con[0].AccountId, subscription);
                system.debug('activeAppList'+activeAppList);
                List<IAM_Application__c> activeAppCheckList = getAccFeatureAccessCheckList(con[0].AccountId, subscription);
                MAP<String, IAM_Application__c> activeAppMap = new Map<String, IAM_Application__c>();
                if(!activeAppCheckList.isEmpty()) {
                    for(IAM_Application__c appObj : activeAppCheckList) {
                        if(appObj.IAM_Application_Name__c == Label.IAM_AppName_QSOL 
                           || appObj.IAM_Application_Name__c == Label.IAM_AppName_guidanzmobile) {
                            String appKey = appObj.IAM_Subscription_Name__c.toLowerCase() + appObj.IAM_Application_Name__c.toLowerCase();
                            activeAppMap.put(appKey, appObj);
                            
                            //check if subscription at account level is LOP then an payload subscription is 
                           //QUICKSERVE ONLINE EBU OR QUIKSERVE ONLINE CPG then Inactivate that subscription.
                           System.debug('Printing app'+appObj);
                               if(appObj.IAM_Application_Name__c==System.Label.IAM_AppName_QSOL&&appObj.IAM_Subscription_Name__c==System.Label.IAM_QuickServe_Online_LOP_SubName
                                 &&(subscription.subscriptionName==System.Label.IAM_QuickServe_Online_EBU_SubName||subscription.subscriptionName==System.Label.IAM_QuickServe_Online_CPG_SubName)
                                 &&subscription.subscriptionType==System.Label.IAM_Status_Active){
                                 subscriptionLOP.add(appObj);  
                                 lopIDs.add(appObj.id);    
                               }
                        }                        
                    }
                }
                if(activeAppList != null && !activeAppList.isEmpty()) {
                    List<IAM_Contact_Provisioning__c> userFeatureAccessList = getUserFeatureAccessList(con[0].Id, activeAppList[0].Id, subscription);
                    List<IAM_Contact_Provisioning__c> userFeatureAccessCheckList = getUserFeatureAccessCheckList(con[0].Id, activeAppList[0].Id, subscription);
                    MAP<String, IAM_Contact_Provisioning__c> activeUserProMap = new Map<String, IAM_Contact_Provisioning__c>();
                    if(!userFeatureAccessCheckList.isEmpty()) {
                        for(IAM_Contact_Provisioning__c userProObj : userFeatureAccessCheckList) {
                            if(userProObj.IAM_Application_Name__c == Label.IAM_AppName_QSOL 
                               || userProObj.IAM_Application_Name__c == Label.IAM_AppName_guidanzmobile) {
                                String userProKey = userProObj.IAM_Subscription_Name__c.toLowerCase() + userProObj.IAM_Application_Name__c.toLowerCase();
                                activeUserProMap.put(userProKey, userProObj);
                            }                        
                        }
                    }
                    if(userFeatureAccessList != null && !userFeatureAccessList.isEmpty()) {
                        /* It is a user subscription renewal or revoke request */
                        if(subscription.subscriptionType == Label.IAM_Status_Active) {
                            if(subscription.endDate != userFeatureAccessList[0].IAM_End_Date__c) {
                                updateUserSubscription(userFeatureAccessList[0], Label.IAM_Status_Active, subscription);
                            } else {
                                return getResponse(false, 'User subscription already exist');
                            }                            
                        } else if(subscription.subscriptionType == Label.IAM_Status_Inactive) {
                            updateUserSubscription(userFeatureAccessList[0], Label.IAM_Status_Inactive, subscription);
                        }
                    } else {
                        /*It is a user subscription creation request */
                        String userProKey = subscription.subscriptionName.toLowerCase() + subscription.applicationName.toLowerCase();
                        if(activeUserProMap.containsKey(userProKey)) {
                            return getResponse(false, 'User subscription of same group already exist');
                        }
                        createUserSubscription(con[0], subscription, activeAppList[0].Id);
                    }
                } else {
                    /* If there is no active Account subscription available then create new Account subscription for 
                    * external users only. 
                    * Assumption - Internal users must have active account subscriptions for paid applications.  */
                    if(!con[0].IAM_Internal__c) {
                        String appKey = subscription.subscriptionName.toLowerCase() + subscription.applicationName.toLowerCase();
                        if(activeAppMap.containsKey(appKey)) {
                            return getResponse(false, 'Account subscription of same group already exist');
                        }
                        IAM_Application__c accountAccessObj = createAccountSubscription(con[0], subscription);
                        createUserSubscription(con[0], subscription, accountAccessObj.Id);
                    }                    
                }
                
                System.debug('Printing LOP Subcription'+subscriptionLOP);
                if(!subscriptionLOP.isEmpty()){
                  updateLOPSubscriptions(subscriptionLOP,lopIDs);  
                }
                
                return getResponse(true, 'Inserted Successfully');
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
        return response;
    }
    
    
    //Method to make LOP Subscriptions Inactive
    Private static void updateLOPSubscriptions(List<IAM_Application__c> subscriptionLOP,Set<id> lopIds){
       
        List<IAM_Contact_Provisioning__c> allSubscriptions= new List<IAM_Contact_Provisioning__c>();	
        List<IAM_Contact_Provisioning__c> lop= [Select id,IAM_Status__c,IAM_Contact__c from IAM_Contact_Provisioning__c where IAM_Account_Application__c=:lopIds AND IAM_Status__c=:System.Label.IAM_Status_Active];
       System.debug('Pringint lop'+lop);
        if(!lop.isEmpty()){
            for(IAM_Contact_Provisioning__c ap:lop){
                ap.IAM_Status__c=System.Label.IAM_Status_Inactive;
                ap.IAM_Reason__c='EBU Subscription is Added';
            }
            Update lop;
            allSubscriptions=[SELECT id,IAM_Status__c,IAM_Contact__c,IAM_Role__c,IAM_Application_Name__c,IAM_User__c
                              FROM IAM_Contact_Provisioning__c where IAM_Contact__c=:lop[0].IAM_Contact__c AND IAM_Status__c=:System.Label.IAM_Status_Active];
        }
        System.debug('Prinitng all Subscriptions142'+allSubscriptions);
        For(IAM_Application__c app: subscriptionLOP){
            app.IAM_Status__c=System.Label.IAM_Status_Inactive;
            app.IAM_Reason__c='EBU Subscription is Added';
        }   
        Update subscriptionLOP;
        
        //Since trigger will not execute other time for these update we need to manually call the class that will update application groups on Contact
        if(!allSubscriptions.isEmpty()){
            System.debug('Prinitng inside contact update'+allSubscriptions);
            IAM_contactHelperClass.updateApplicationContact(allSubscriptions);   
        }
        
    }
    
    private static IAM_Application__c createAccountSubscription(Contact con, NewSubscriptionInfo subscription) {
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = con.AccountId;                
        obj.IAM_Subscription_Start_Date__c = subscription.startDate;
        obj.IAM_Subscription_End_Date__c = subscription.endDate;
        obj.IAM_Subscription_Count__c = Integer.valueof(Label.IAM_Default_App_Subscription_Count.trim());
        obj.IAM_Application_Name__c = subscription.applicationName;
        obj.IAM_Role__c = subscription.role;
        if(subscription.applicationName == Label.IAM_Guidanz_Mobile_App_Name){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Guidanz_Mobile_Roles__c = subscription.role;
            obj.IAM_swregExpire__c = subscription.swregExpire;
        }
        if(subscription.applicationName == Label.IAM_AppName_QSOL){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Qsolexpiration__c = subscription.qsolExpiration;
        }
        obj.IAM_Free_Subscription__c = subscription.free;                           
        obj.IAM_Status__c = subscription.subscriptionType;
        obj.IAM_Subscription_Name__c = subscription.subscriptionName;
        obj.IAM_Source__c = subscription.source;
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(subscription.applicationName).getRecordTypeId();
        System.debug('#### Account access obj '+obj);
        insert obj;
        return obj;
    }
    
    private static void createUserSubscription(Contact con, NewSubscriptionInfo subscription, 
    Id accAccFeatureId) {
        IAM_Contact_Provisioning__c obj = new IAM_Contact_Provisioning__c();
        obj.IAM_Contact__c= con.Id; 
        obj.IAM_Start_Date__c = subscription.startDate;
        obj.IAM_End_Date__c = subscription.endDate;
        obj.IAM_Application_Name__c = subscription.applicationName;
        obj.IAM_Role__c = subscription.role;
        if(subscription.applicationName == Label.IAM_Guidanz_Mobile_App_Name){
            obj.IAM_Guidanz_Mobile_Roles__c = subscription.role;
            obj.IAM_swregExpire__c = subscription.swregExpire;
        }
        if(subscription.applicationName == Label.IAM_AppName_QSOL){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Qsolexpiration__c = subscription.qsolExpiration;
        }
        obj.IAM_License_Type__c = subscription.licenseType;
        obj.IAM_Status__c = subscription.subscriptionType;
        obj.IAM_Source__c = subscription.source;
        obj.IAM_Account_Application__c = accAccFeatureId;
        obj.IAM_Subscription_Name__c = subscription.SubscriptionName;        
        obj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(subscription.applicationName).getRecordTypeId();                 
        insert obj;      
    }
    
    /* Renew or revoke the user provisioning record */
    private static void updateUserSubscription(IAM_Contact_Provisioning__c userProObj, String action, 
        NewSubscriptionInfo subscription) {
        if(action == Label.IAM_Status_Active) {
            userProObj.IAM_End_Date__c = subscription.endDate;
            if(subscription.applicationName == Label.IAM_AppName_guidanzmobile){
                userProObj.IAM_swregExpire__c = subscription.swregExpire;
            }
            if(subscription.applicationName == Label.IAM_AppName_QSOL){
                /* TO DO - Need to confirm role upgrade for QSOL in case of user subscription.
                 * In case of renewal, role upgrade is possible in QSOL application only.
                userProObj.IAM_Role__c = subscription.role; */
                userProObj.IAM_Qsolexpiration__c = subscription.qsolExpiration;
            }                
        } else if(action == Label.IAM_Status_Inactive) {
            userProObj.IAM_Status__c = Label.IAM_Status_Inactive;
        }
        update userProObj;
    }
    
    /* Response returned from IAM */
    private Static CMI_ResponseHandler getResponse(Boolean isSuccess, String msg) {
        CMI_ResponseHandler response = new CMI_ResponseHandler();
        if(isSuccess) {
            response.StatusCode = '200';
            response.Status = 'Success';
            response.Data = null;           
            response.Message = 'Success : ' + msg;
        } else {
            response.StatusCode = '404';
            response.Status = 'error';
            response.Data = null;
            string tspexist = '';            
            response.Message = 'Fail : ' + msg;
        }
        return response;
    }
    
    /* Validate the request to check if all mandatory fields are available */
    private static String validateRequest(NewSubscriptionInfo subscription) {
        String fieldName = '';
        List<String> msgList = new List<String>();

        if(subscription.startDate == null) {
            msgList.add('startDate is required');
        }
        if(subscription.endDate == null) {
            msgList.add('endDate is required');
        }       
        if(String.isBlank(subscription.subscriptionName)) {
            msgList.add('subscriptionName is required');
        }
        if(String.isBlank(subscription.applicationName)) {
            msgList.add('applicationName is required');
        }       
        if(String.isNotBlank(subscription.applicationName)) {           
            if(subscription.applicationName == Label.IAM_AppName_QSOL) {
                if(String.isBlank(subscription.qsolExpiration)) {
                    msgList.add('qsolExpiration is required');
                }
                if(String.isBlank(subscription.licenseType)) {
                    msgList.add('licenseType is required');
                }
            }
            if(subscription.applicationName == Label.IAM_AppName_guidanzmobile) {
                if(String.isBlank(subscription.swregExpire)) {
                    msgList.add('swregExpire is required');
                }
            }
        }       
        if(String.isBlank(subscription.role)) {
            msgList.add('role is required');
        }
        if(String.isNotBlank(subscription.role)) {
            Set<string> tmplist = getPicklistValues('IAM_Role__c','IAM_Application__c');
            System.debug('Printing Subscription role from Payload'+subscription.role);
            System.debug('#### tmplist Role - '+tmplist );
            if(!tmplist.contains(subscription.role)){
                msgList.add('invalid role');
            }           
        }
        if(String.isBlank(subscription.subscriptionType)) {
            msgList.add('subscriptionType  is required');
        }       
        if(String.isNotBlank(subscription.subscriptionType)) { 
            Set<string> tmplist = getPicklistValues('IAM_Status__c','IAM_Application__c');
            System.debug('#### tmplist subscriptionType - '+tmplist );
            if(!tmplist.contains(subscription.subscriptionType)) {
                msgList.add('invalid subscriptionType');
            }
        }
        if(String.isBlank(subscription.source)) {
            msgList.add('source is required');
        }
        if(subscription.free == null) {
            msgList.add('free is required');
        }
        if(!msgList.isEmpty()) {
            fieldName = String.join(msgList, ', ');
        }
        System.debug('#### fieldName - '+fieldName);
        return fieldName; 
    }  
       
       
    /* Adding custom Exception sub-class */
    public class NoRecordMatchException extends Exception {}    
    
    /* If there is error in subscription creation/renewal/revokation then it is captured 
    * in CSS_Integration_Error__c object*/
    public static void cmiError(String msg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Source__c = 'CS';
        errObj.Error_Description__c = msg;
        errObj.Processed_Data__c = msg;        
        insert errObj;
    }   
       
    /* Return valid picklist value of given field of given object */
    private static Set<String> getPicklistValues(string fieldName,String objectName) {
        Set<String> setPickvals = new Set<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values) { 
            setPickvals.add(a.getLabel());
        }
        return setPickvals;
    }     
    
    /* Return Contact with given username */    
    private static List<Contact> getContact(String username) {
        return [
            SELECT AccountId
                 , Name
                 , Id
                 , Username__c
                 , IAM_Internal__c
              FROM Contact
             WHERE Username__c = :username
        ]; 
    }
    
    /* Return list of Account Feature Access */
    private static List<IAM_Application__c> getAccFeatureAccessList(String accId, NewSubscriptionInfo subscription ) { 
        return [
            SELECT IAM_Account_Name__c
                 , IAM_Application_Name__c
                 , IAM_Role__c
                 , IAM_Guidanz_Mobile_Roles__c
                 , IAM_Subscription_Name__c
                 , IAM_Status__c
              FROM IAM_Application__c
             WHERE IAM_Account_Name__r.id = :accId
               AND IAM_Application_Name__c = :subscription.applicationName
               AND IAM_Status__c = :Label.IAM_Status_Active
               AND IAM_Role__c = :subscription.role
               AND IAM_Subscription_Name__c = :subscription.subscriptionName
        ];             
    }
    
    /* Return list of Account Feature Access */
    private static List<IAM_Application__c> getAccFeatureAccessCheckList(String accId, NewSubscriptionInfo subscription ) {
        return [
            SELECT IAM_Account_Name__c
                 , IAM_Application_Name__c
                 , IAM_Role__c
                 , IAM_Guidanz_Mobile_Roles__c
                 , IAM_Subscription_Name__c
                 , IAM_Status__c
              FROM IAM_Application__c
             WHERE IAM_Account_Name__r.id = :accId
               AND IAM_Application_Name__c = :subscription.applicationName
               AND IAM_Status__c = :Label.IAM_Status_Active
               AND (IAM_Subscription_Name__c = :subscription.subscriptionName OR IAM_Subscription_Name__c =:System.Label.IAM_QuickServe_Online_LOP_SubName)
        ];             
    }
    
    /* Return user feature access list for given criteria */
    private static List<IAM_Contact_Provisioning__c> getUserFeatureAccessList(Id contactId, Id accAccessFeatureId,
        NewSubscriptionInfo subscription) {
        return [
            SELECT Id
                 , IAM_Status__c
                 , IAM_swregExpire__c
                 , IAM_Qsolexpiration__c
                 , IAM_End_Date__c
                 , IAM_Account_Application__r.Id
                 , IAM_Contact__r.Id
              FROM IAM_Contact_Provisioning__c
             WHERE IAM_Contact__r.Id = :contactId
               AND IAM_Account_Application__r.Id = :accAccessFeatureId
               AND IAM_Application_Name__c = :subscription.applicationName
               AND IAM_Status__c = :Label.IAM_Status_Active
               AND IAM_Role__c = :subscription.role 
               AND IAM_Subscription_Name__c = :subscription.SubscriptionName
        ];
    }
    
    /* Return user feature access list for given criteria */
    private static List<IAM_Contact_Provisioning__c> getUserFeatureAccessCheckList(Id contactId, Id accAccessFeatureId,
        NewSubscriptionInfo subscription) {
        return [
            SELECT Id
                 , IAM_Status__c
                 , IAM_swregExpire__c
                 , IAM_Qsolexpiration__c
                 , IAM_End_Date__c
                 , IAM_Account_Application__r.Id
                 , IAM_Contact__r.Id
                 , IAM_Application_Name__c
                 , IAM_Subscription_Name__c
              FROM IAM_Contact_Provisioning__c
             WHERE IAM_Contact__r.Id = :contactId
               AND IAM_Account_Application__r.Id = :accAccessFeatureId
               AND IAM_Application_Name__c = :subscription.applicationName
               AND IAM_Status__c = :Label.IAM_Status_Active
               AND (IAM_Subscription_Name__c = :subscription.SubscriptionName OR IAM_Subscription_Name__c =:System.Label.IAM_QuickServe_Online_LOP_SubName)
        ];
    }
    
    /* Response returned after success or failure of operation */
    global class CMI_ResponseHandler{    
        public String Status {get; set;}
        public List<sObject> Data {get;set;}
        public String Message {get;set;}
        public String StatusCode {get; set;} 
    }  
    
    /* Wrapper to catch request and parse further */
    global class NewSubscriptionInfo{
        public string username{get;set;}
        public Date startDate{get;set;}
        public Date endDate{get;set;}
        public string applicationName{get;set;}
        public string role{get;set;}
        public boolean free{get;set;}
        public string swregExpire{get;set;}
        public string qsolExpiration{get;set;}
        public string licenseType{get;set;}
        public string subscriptionType{get;set;}
        public string applicationGroups{get;set;}
        public string source{get;set;}
        public String subscriptionName{get;set;}
    }     
}