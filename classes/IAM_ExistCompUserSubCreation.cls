/*************************************************************************************
Name:  IAM_ExistCompUserSubCreation
Copyright © 2019  Cummins
**************************************************************************************
Purpose: This api will take service provider code value of Account and on that basis 
we are fetching related records of same account from account access and feature object.
The api will create records in contact, user access and feature and in account access
and feature related to same account. The records created in user provisiong and account
provisioning should be unique on the basis of application name and its role. We are
renewing existing record for same application and role in account and user provisioning
and making the existing record inactive in both user and account provisioning if we
are receiving new end date for same application and role combination.
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Karthik Golakaram      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar       09/23/2021      Assigned Value from Label to IAM_Subscription_Count__c
**************************************************************************************
**************************************************************************************/

@RestResource(urlMapping='/location/UserSubscriptioncreation/*')
global with sharing class IAM_ExistCompUserSubCreation{
    
    @HttpPost
    global static CMI_ResponseHandler Post(UserLocationSubscriptionInfo UserLocationSubscriptionInfo) {
    
        system.debug('request====' + UserLocationSubscriptionInfo);
                                
        CMI_ResponseHandler response = new CMI_ResponseHandler();
         
        string Fieldname = ValidateRequest(UserLocationSubscriptionInfo);
        RestRequest request = RestContext.request;
        String lDapId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        system.debug('Fieldname====' + Fieldname);
         Set<String> appName2 = new Set<String>();
         Set<id> appIds = new Set<id>();
         Map<String,List<IAM_Contact_Provisioning__c>> appMap = new Map<String,List<IAM_Contact_Provisioning__c>>();
        if(Fieldname == '') {
        
           List<IAM_Application__c> appList = [select id, IAM_Application_Name__c,IAM_Account_Name__r.id from IAM_Application__c where IAM_Account_Name__r.IAM_Service_Provider_Code__c =:lDapId];
              for(IAM_Application__c appObj:appList){
               appName2.add(appObj.IAM_Application_Name__c.toLowerCase()); 
               appIds.add(appObj.id);              
            }  
          List<IAM_Contact_Provisioning__c> userApp3 =[SELECT id,Name,IAM_Contact__r.id,IAM_Account_Application__c,IAM_Application_Name__c FROM IAM_Contact_Provisioning__c where IAM_Account_Application__r.Id in :appIds];
           for(IAM_Contact_Provisioning__c conProapp:userApp3){
            appMap.put(conProapp.IAM_Account_Application__c,userApp3);
           }    
                      
            try {
            
                List<IAM_Contact_Provisioning__c> conUserApp = new List<IAM_Contact_Provisioning__c>();
                Savepoint sp = Database.setSavepoint();                                   
               try{                             
                   
                   Contact conObj = new Contact();
                conObj.AccountId = appList[0].IAM_Account_Name__r.id;
                conObj.IAM_Product_Group_Access__c = UserLocationSubscriptionInfo.userInfo.pga;
                conObj.IAM_Contact_source__c = UserLocationSubscriptionInfo.userInfo.source;
                conObj.Phone = UserLocationSubscriptionInfo.userInfo.phone;
                conObj.CMI_Contact_Type__c = UserLocationSubscriptionInfo.userInfo.contactType;
                conObj.Email= UserLocationSubscriptionInfo.userInfo.email;
                conObj.IAM_Contact_Status__c = UserLocationSubscriptionInfo.userInfo.contactStatus;
                conObj.IAM_Site_Admin__c = UserLocationSubscriptionInfo.userInfo.siteAdmin;
                conObj.FirstName = UserLocationSubscriptionInfo.userInfo.firstName;
                conObj.LastName =  UserLocationSubscriptionInfo.userInfo.lastName;
                conObj.IAM_swregexpire__c = UserLocationSubscriptionInfo.subscriptionInfo.swregExpire;
                if(System.Label.css_org=='CSO'){
                	conObj.Username__c=UserLocationSubscriptionInfo.userInfo.email; 
                }else{
                    conObj.Username__c=UserLocationSubscriptionInfo.userInfo.email+System.Label.css_org;
                }
                conObj.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                   insert conObj;
                 
                if(!appName2.contains(UserLocationSubscriptionInfo.subscriptionInfo.applicationName.toLowerCase())){  
                                
                      IAM_Application__c app = new IAM_Application__c();
                    app.IAM_Account_Name__c = appList[0].IAM_Account_Name__r.id;                
                    app.IAM_Subscription_Start_Date__c = UserLocationSubscriptionInfo.subscriptionInfo.startDate;
                    app.IAM_Subscription_End_Date__c = UserLocationSubscriptionInfo.subscriptionInfo.endDate;
                    app.IAM_Subscription_Count__c = Integer.valueof(Label.IAM_Default_App_Subscription_Count.trim());
                    app.IAM_Application_Name__c = UserLocationSubscriptionInfo.subscriptionInfo.applicationName;
                    app.IAM_Role__c = UserLocationSubscriptionInfo.subscriptionInfo.role;
                    //checking Application Name is Guidanz Mobile and Assign Application
                    if(UserLocationSubscriptionInfo.subscriptionInfo.applicationName==System.Label.IAM_Guidanz_Mobile_App_Name){
                        app.IAM_Guidanz_Mobile_Roles__c=UserLocationSubscriptionInfo.subscriptionInfo.role;
                    }
                    app.IAM_Free_Subscription__c = UserLocationSubscriptionInfo.subscriptionInfo.free;                           
                    app.IAM_Status__c = UserLocationSubscriptionInfo.subscriptionInfo.subscriptionType;
                    app.IAM_Subscription_Name__c = UserLocationSubscriptionInfo.subscriptionInfo.SubscriptionName;
                  
                    app.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(UserLocationSubscriptionInfo.subscriptionInfo.applicationName).getRecordTypeId();
                       System.debug('Account access app insert');
                    insert app; 
                    
                 IAM_Contact_Provisioning__c conAccessObj = new IAM_Contact_Provisioning__c(); 
                  conAccessObj.IAM_Contact__c= conObj.Id; 
                  conAccessObj.IAM_Start_Date__c = UserLocationSubscriptionInfo.subscriptionInfo.startDate;
                  conAccessObj.IAM_End_Date__c = UserLocationSubscriptionInfo.subscriptionInfo.endDate;
                  conAccessObj.IAM_Application_Name__c = UserLocationSubscriptionInfo.subscriptionInfo.applicationName;
                  conAccessObj.IAM_Role__c = UserLocationSubscriptionInfo.subscriptionInfo.role;
                  //checking Application Name is Guidanz Mobile and Assign Application
                    if(UserLocationSubscriptionInfo.subscriptionInfo.applicationName==System.Label.IAM_Guidanz_Mobile_App_Name){
                        app.IAM_Guidanz_Mobile_Roles__c=UserLocationSubscriptionInfo.subscriptionInfo.role;
                    }
                  conAccessObj.IAM_Qsolexpiration__c = UserLocationSubscriptionInfo.subscriptionInfo.qsolExpiration;
                  conAccessObj.IAM_License_Type__c = UserLocationSubscriptionInfo.subscriptionInfo.licenseType;
                  conAccessObj.IAM_Status__c = UserLocationSubscriptionInfo.subscriptionInfo.subscriptionType;
                  conAccessObj.IAM_Source__c = UserLocationSubscriptionInfo.subscriptionInfo.source;
                  conAccessObj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(UserLocationSubscriptionInfo.subscriptionInfo.applicationName).getRecordTypeId();
                  conAccessObj.IAM_Account_Application__c = app.Id;                  
                      insert conAccessObj;          
               } else{                                         
                       IAM_Application__c appStatus = new IAM_Application__c();
                       List<IAM_Contact_Provisioning__c> userApp2 =[SELECT id,IAM_Account_Application__r.Id,IAM_Status__c FROM IAM_Contact_Provisioning__c where IAM_Account_Application__r.Id in :appIds and IAM_Application_Name__c=:UserLocationSubscriptionInfo.subscriptionInfo.applicationName.toLowerCase()];
                           system.debug('-----userApp information'+userApp2);
                          for(IAM_Contact_Provisioning__c userApp:userApp2){ 
                          appStatus = [select id,IAM_Status__c from IAM_Application__c where id=:userApp.IAM_Account_Application__r.Id];  
                              appStatus.IAM_Status__c = 'Inactive';
                              userApp.IAM_Status__c = 'Inactive';                              
                                    conUserApp.add(userApp);
                          }     update conUserApp; 
                                update appStatus; 
                                
                            IAM_Application__c app = new IAM_Application__c();
                    app.IAM_Account_Name__c = appList[0].IAM_Account_Name__r.id;                
                    app.IAM_Subscription_Start_Date__c = UserLocationSubscriptionInfo.subscriptionInfo.startDate;
                    app.IAM_Subscription_End_Date__c = UserLocationSubscriptionInfo.subscriptionInfo.endDate;
                    app.IAM_Subscription_Count__c = Integer.valueof(Label.IAM_Default_App_Subscription_Count.trim());
                    app.IAM_Application_Name__c = UserLocationSubscriptionInfo.subscriptionInfo.applicationName;
                    app.IAM_Role__c = UserLocationSubscriptionInfo.subscriptionInfo.role;
                    //checking Application Name is Guidanz Mobile and Assign Application
                    if(UserLocationSubscriptionInfo.subscriptionInfo.applicationName==System.Label.IAM_Guidanz_Mobile_App_Name){
                        app.IAM_Guidanz_Mobile_Roles__c=UserLocationSubscriptionInfo.subscriptionInfo.role;
                    }
                    app.IAM_Free_Subscription__c = UserLocationSubscriptionInfo.subscriptionInfo.free;                           
                    app.IAM_Status__c = UserLocationSubscriptionInfo.subscriptionInfo.subscriptionType;
                    app.IAM_Subscription_Name__c = UserLocationSubscriptionInfo.subscriptionInfo.SubscriptionName;
                    app.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(UserLocationSubscriptionInfo.subscriptionInfo.applicationName).getRecordTypeId();
                       System.debug('Account access app insert');
                    insert app; 
                    
                 IAM_Contact_Provisioning__c conAccessObj = new IAM_Contact_Provisioning__c(); 
                  conAccessObj.IAM_Contact__c= conObj.Id; 
                  conAccessObj.IAM_Start_Date__c = UserLocationSubscriptionInfo.subscriptionInfo.startDate;
                  conAccessObj.IAM_End_Date__c = UserLocationSubscriptionInfo.subscriptionInfo.endDate;
                  conAccessObj.IAM_Application_Name__c = UserLocationSubscriptionInfo.subscriptionInfo.applicationName;
                  conAccessObj.IAM_Role__c = UserLocationSubscriptionInfo.subscriptionInfo.role;
                  //checking Application Name is Guidanz Mobile and Assign Application
                    if(UserLocationSubscriptionInfo.subscriptionInfo.applicationName==System.Label.IAM_Guidanz_Mobile_App_Name){
                        app.IAM_Guidanz_Mobile_Roles__c=UserLocationSubscriptionInfo.subscriptionInfo.role;
                    }
                  conAccessObj.IAM_Qsolexpiration__c = UserLocationSubscriptionInfo.subscriptionInfo.qsolExpiration;
                  conAccessObj.IAM_License_Type__c = UserLocationSubscriptionInfo.subscriptionInfo.licenseType;
                  conAccessObj.IAM_Status__c = UserLocationSubscriptionInfo.subscriptionInfo.subscriptionType;
                  conAccessObj.IAM_Source__c = UserLocationSubscriptionInfo.subscriptionInfo.source;
                  conAccessObj.IAM_Account_Application__c = app.Id; 
                   conAccessObj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(UserLocationSubscriptionInfo.subscriptionInfo.applicationName).getRecordTypeId();                 
                      insert conAccessObj;                                 
                     }
                     
                                                        
                    response.Message = 'Inserted Successfully';
                    response.StatusCode = '200';
                    response.Status = 'Success';
                    response.Data = null;               
                 }
           catch (System.DmlException e) {
            cmiError(e.getMessage());
             
                system.debug('DmlException====' + e);
                response.StatusCode = '404';
                response.Status = 'error';
                response.Data = null;
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    // Process exception here
                    response.Message =  e.getDmlMessage(i); 
                }
                Database.rollback(sp);
                return response;
              }  
                 
           
            }
            catch (System.DmlException e) {
            cmiError(e.getMessage());
          
                
                response.StatusCode = '404';
                response.Status = 'error';
                response.Data = null;
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    // Process exception here
                    response.Message =  e.getDmlMessage(i); 
                }
                
            }            
       }
        else {
        
            response.StatusCode = '404';
            response.Status = 'error';
            response.Data = null;           
            response.Message = 'Fail : ' + Fieldname;
            
        }
        return response;
    }
    
    private static string ValidateRequest(UserLocationSubscriptionInfo NewuserInfoObj) {
    
        string Fieldname = '';   
        
        if(NewuserInfoObj.userInfo.pga== null) {
        
            Fieldname = Fieldname + ' pga is required, ';
        }
        
        if(NewuserInfoObj.userInfo.Phone == null) {
        
            Fieldname = Fieldname + ' Phone is required, ';
        }
        
        if(NewuserInfoObj.userInfo.Email == null) {
        
             
            Fieldname = Fieldname + ' first Name is required, ';
        }                
        
        if(NewuserInfoObj.userInfo.contactType == null || NewuserInfoObj.userInfo.contactType.trim() == '') {
        
            Set<string> tmplist = getPicklistValues('CMI_Contact_Type__c','Contact');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(NewuserInfoObj.userInfo.contactType)) {
             	Fieldname = Fieldname + ' Contact type is required, ';
            }           
        }
        
        if(NewuserInfoObj.userInfo.lastName == null || NewuserInfoObj.userInfo.lastName.trim() == '') {
            Fieldname = Fieldname + ' last Name is required, ';
        }
        
        if(NewuserInfoObj.userInfo.firstName == null || NewuserInfoObj.userInfo.firstName.trim() == '') {
            Fieldname = Fieldname + ' first Name is required, ';
        }
         
        if(NewuserInfoObj.userInfo.contactStatus == null || NewuserInfoObj.userInfo.contactStatus.trim() == '') {
            Set<string> tmplist = getPicklistValues('IAM_Contact_Status__c','Contact');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(NewuserInfoObj.userInfo.contactStatus)) {
            	Fieldname = Fieldname + ' contact Status is required, ';
            }  
        }        
            
        if(NewuserInfoObj.subscriptionInfo.startDate == null) {
            Fieldname = Fieldname + ' startDate is required, ';
        }
        
        if(NewuserInfoObj.subscriptionInfo.endDate == null) {
            Fieldname = Fieldname + ' endDate is required, ';
        }
        if(NewuserInfoObj.subscriptionInfo.applicationName == null || NewuserInfoObj.subscriptionInfo.applicationName.trim() == '') {
            Fieldname = Fieldname + ' applicationName is required, ';
        }
        if(NewuserInfoObj.subscriptionInfo.role== null || NewuserInfoObj.subscriptionInfo.role.trim() == '') {
            Set<string> tmplist = getPicklistValues('IAM_Role__c','IAM_Application__c');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(NewuserInfoObj.subscriptionInfo.role)) {
             	Fieldname = Fieldname + ' role  is required, ';
            }           
        }
        if(NewuserInfoObj.subscriptionInfo.qsolExpiration == null || NewuserInfoObj.subscriptionInfo.qsolExpiration.trim() == '') { 
            Fieldname = Fieldname + ' qsolExpiration is required, ';
        }
        if(NewuserInfoObj.subscriptionInfo.licenseType == null || NewuserInfoObj.subscriptionInfo.licenseType.trim() == '') {            
            Fieldname = Fieldname + ' licenseType is required, ';
        }         
        if(NewuserInfoObj.subscriptionInfo.subscriptionType == null || NewuserInfoObj.subscriptionInfo.subscriptionType.trim() == '') {
            Set<string> tmplist = getPicklistValues('IAM_Status__c','IAM_Application__c');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(NewuserInfoObj.subscriptionInfo.subscriptionType)) {
            
              Fieldname = Fieldname + ' subscriptionType is required, ';
            }  
        }
        if(NewuserInfoObj.subscriptionInfo.source == null || NewuserInfoObj.subscriptionInfo.source.trim() == '') {
            Fieldname = Fieldname + ' source is required, ';
        }        
        if(NewuserInfoObj.subscriptionInfo.free == null) { 
            Fieldname = Fieldname + ' free is required, ';
        }
        return Fieldname ;
    }    
    
    public static Boolean validateEmail(List<String> lstemails) {      
        Boolean res = true;
        system.debug('lstemails==' + lstemails);        
        for(string email: lstemails) {        
            system.debug('email==' + email); 
            String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
            Pattern MyPattern = Pattern.compile(emailRegex);        
            Matcher MyMatcher = MyPattern.matcher(email);       
            if (!MyMatcher.matches()) {   
                res = false;        
            }
			system.debug('res==' + res);            
        }       
        system.debug('res==' + res);        
    	return res;
	}    

    
    //Adding custom Exception sub-class 
    public class NoRecordMatchException extends Exception {}    
    
    public static void cmiError(String msg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Source__c='CS';
        errObj.Error_Description__c = msg;
        errObj.Source__c='IDENTITY';
        //errObj.Error_Type__c='There are no customers associated with the  Id:CId';
        errObj.Error_Description__c = msg;
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
    
    Public static Set<String> getPicklistValues(string fieldName,String objectName) {
    
        Set<String> setPickvals=new Set<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values) { 
            if(fieldName == 'BillingCountryCode' || fieldName=='BillingStateCode'){
                setPickvals.add(a.getLabel().tolowercase());
            }else{  
              setPickvals.add(a.getLabel());
            }
       	}
        return setPickvals;
    }
              
    global class UserLocationSubscriptionInfo {
        public subscriptionInfo subscriptionInfo{get;set;}
        public userInfo userInfo{get;set;}
    }
    global class userInfo {
        public String source{get;set;}
        public String phone{get;set;}
        public String pga{get;set;}
        public String username{get;set;}
        public String contactType{get;set;}
        public String email{get;set;}
        public String contactStatus{get;set;}
        public String lastName{get;set;}
        public Boolean siteAdmin{get;set;}
        public String firstName{get;set;}
    }
    global class subscriptionInfo {
        public Date endDate{get;set;}
        public String swregExpire{get;set;}
        public String qsolExpiration{get;set;}
        public Boolean free{get;set;}
        public String licenseType{get;set;}
        public String role{get;set;}
        public String subscriptionType{get;set;}
        public String applicationName{get;set;}
        public String source{get;set;}       
        public Date startDate{get;set;}
        public string SubscriptionName{get;set;}
    }                   
}