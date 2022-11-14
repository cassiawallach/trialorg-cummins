/*************************************************************************************
Name:  IAM_AcConSubsCreation
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Service to Register Account Contact in IAM
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Karthik Golakaram      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar       09/23/2021      Assigned Value from Label to IAM_Subscription_Count__c
**************************************************************************************
**************************************************************************************/

@RestResource(urlMapping='/IAMregistration/')
global with sharing class IAM_AcConSubsCreation {
    
    @HttpPost
    global static CMI_ResponseHandler Post(RegistrationInfo RegistrationInfo) {
        System.debug('request====' + RegistrationInfo);                                
        RestRequest req = RestContext.request;
        CMI_ResponseHandler response = new CMI_ResponseHandler(); 
        
        string Fieldname = ValidateRequest(RegistrationInfo);
        
        system.debug('Fieldname====' + Fieldname);
        Map<String,String> region=new Map<String,String>();
        region.put('1','US and Canada');
        region.put('3','Europe');
        region.put('4','Africa');
        region.put('5','Middle East');
        region.put('6','Latin America');
        region.put('8','Mexico');
        region.put('10','Southeast Asia');
        region.put('11','South Pacific');
        region.put('12','East Asia');
        region.put('13','India');
        region.put('15','CIS');
        region.put('16','Japan');
        region.put('17','Korea');
        
        if(Fieldname == '') {                     
            try {
                Savepoint sp = Database.setSavepoint(); 
                Account accObj = new Account();                    
                try { 
                    if(RegistrationInfo.locationPayloadInfo.type!='LOP Customer'){
                        //calucate parent from Distributpr Code
                        List<Account> acntDist=[Select id,ownerid from Account Where IAM_Service_Provider_Code__c=:RegistrationInfo.LocationPayloadInfo.distributorCode LIMIT 1];
                        if(!acntDist.isEmpty()){
                            accObj.Parentid=acntDist[0].id;
                        }else{
                            //if distributor Account is not found
                            if(String.isNotBlank(region.get(RegistrationInfo.LocationPayloadInfo.aboCode))){
                                List<Account> regionalAccount=[Select id from Account where Name=:region.get(RegistrationInfo.LocationPayloadInfo.aboCode)];
                                if(!regionalAccount.isEmpty()){
                                    accObj.Parentid=regionalAccount[0].id;
                                }
                            }
                        }
                    }else{
                        //LOP Account as parent.
                        if(String.isNotblank(System.Label.IAM_LOP_Parent_Name)){
                            accObj.Parentid=[Select id from Account where Name=:System.Label.IAM_LOP_Parent_Name].id;
                        }
                    }
                    //Karthik Golakaram-2/22/2020:End Parent Account Population 
                    accObj.CSS_Language__c = RegistrationInfo.LocationPayloadInfo.language;
                    accObj.CMI_Region__c = RegistrationInfo.LocationPayloadInfo.region;
                    accObj.BillingCity = RegistrationInfo.LocationPayloadInfo.City;
                    accObj.BillingPostalCode = RegistrationInfo.LocationPayloadInfo.Zipcode;
                    accObj.CMI_Account_Status__c = RegistrationInfo.LocationPayloadInfo.accountStatus;
                    accObj.Type= RegistrationInfo.LocationPayloadInfo.type;   
                    accObj.BillingState = RegistrationInfo.LocationPayloadInfo.StateName;                
                    accObj.CSS_DistributorCode__c = RegistrationInfo.LocationPayloadInfo.distributorCode;
                    accObj.BillingCountryCode = RegistrationInfo.LocationPayloadInfo.CountryName;
                    // accObj.IAM_ABO_code__c = RegistrationInfo.LocationPayloadInfo.aboCode;
                    accObj.CMI_Address2__c = RegistrationInfo.LocationPayloadInfo.AddressLine2;
                    accObj.AccountSource = RegistrationInfo.LocationPayloadInfo.accountSource;
                    accObj.BillingStreet = RegistrationInfo.LocationPayloadInfo.AddressLine1;
                    accObj.Name = RegistrationInfo.LocationPayloadInfo.Name;  
                    //Need to assign WWSPS region depnding upon the ABO code from payload.
                    if(!region.isEmpty()){
                        if(region.ContainsKey(RegistrationInfo.LocationPayloadInfo.aboCode)){
                            accObj.IAM_WWSPS_Regions__c=region.get(RegistrationInfo.LocationPayloadInfo.aboCode);
                        }
                    }             
                    accObj.RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();       
                    System.debug('Account insert');
                    insert accObj;
                    
                    Contact conObj = new Contact();
                    conObj.AccountId = accObj.id;
                    conObj.Username__c = RegistrationInfo.userInfo.username; 
                    conObj.Phone = RegistrationInfo.userInfo.phone;
                    conObj.Email= RegistrationInfo.userInfo.email;
                    conObj.IAM_Product_Group_Access__c = RegistrationInfo.userInfo.pga;
                    conObj.LastName =  RegistrationInfo.userInfo.lastName;
                    conObj.IAM_Contact_source__c = RegistrationInfo.userInfo.source;
                    conObj.FirstName = RegistrationInfo.userInfo.firstName;                
                    conObj.CMI_Contact_Type__c = RegistrationInfo.userInfo.contactType;
                    conObj.IAM_Site_Admin__c = RegistrationInfo.userInfo.siteAdmin;
                    conObj.IAM_Contact_Status__c = RegistrationInfo.userInfo.contactStatus;                           
                    conObj.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                    insert conObj;
                    
                    IAM_Application__c app = new IAM_Application__c();
                    app.IAM_Account_Name__c = accObj.id;                
                    app.IAM_Subscription_Start_Date__c = RegistrationInfo.subscriptionInfo.startDate;
                    app.IAM_Subscription_End_Date__c = RegistrationInfo.subscriptionInfo.endDate;
                    app.IAM_Subscription_Count__c = Integer.valueof(Label.IAM_Default_App_Subscription_Count.trim());
                    app.IAM_Application_Name__c = RegistrationInfo.subscriptionInfo.applicationName;
                    app.IAM_Role__c = RegistrationInfo.subscriptionInfo.role;
                    app.IAM_Free_Subscription__c = RegistrationInfo.subscriptionInfo.free;
                    app.IAM_Qsolexpiration__c = RegistrationInfo.subscriptionInfo.qsolExpiration;
                    app.IAM_Status__c = RegistrationInfo.subscriptionInfo.subscriptionType;
                    app.IAM_Subscription_Name__c = RegistrationInfo.subscriptionInfo.SubscriptionName;                  
                    app.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(RegistrationInfo.subscriptionInfo.applicationName).getRecordTypeId();
                    System.debug('Account access app insert');
                    insert app;
                    
                    IAM_Contact_Provisioning__c conAccessObj = new IAM_Contact_Provisioning__c(); 
                    conAccessObj.IAM_Contact__c= conObj.Id; 
                    conAccessObj.IAM_Start_Date__c = RegistrationInfo.subscriptionInfo.startDate;
                    conAccessObj.IAM_End_Date__c = RegistrationInfo.subscriptionInfo.endDate;
                    conAccessObj.IAM_Application_Name__c = RegistrationInfo.subscriptionInfo.applicationName;
                    conAccessObj.IAM_Role__c = RegistrationInfo.subscriptionInfo.role;
                    conAccessObj.IAM_Qsolexpiration__c = RegistrationInfo.subscriptionInfo.qsolExpiration;
                    // conAccessObj.IAM_License_Type__c = RegistrationInfo.subscriptionInfo.licenseType;
                    conAccessObj.IAM_Status__c = RegistrationInfo.subscriptionInfo.subscriptionType;
                    conAccessObj.IAM_Subscription_Name__c = RegistrationInfo.subscriptionInfo.SubscriptionName;//added on 1-23-2020 for updation logic
                    conAccessObj.IAM_Source__c = RegistrationInfo.subscriptionInfo.source;
                    conAccessObj.IAM_Account_Application__c = app.Id; 
                    conAccessObj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(RegistrationInfo.subscriptionInfo.applicationName).getRecordTypeId();                 
                    insert conAccessObj;
                    
                    response.Message = 'Inserted Successfully';
                    response.StatusCode = '200';
                    response.Status = 'Success';
                    //passing customer code in response-keerthy 11/20/18
                    Account a=[Select id,IAM_Service_Provider_Code__c from Account where id=:accObj.id LIMIT 1];
                    
                    response.message='Service Provide code-'+a.IAM_Service_Provider_Code__c;
                    response.Data = null;
                } catch (System.DmlException e) {
                    cmiError(e.getMessage());                    
                    //return response;
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
            } catch (System.DmlException e) {
                cmiError(e.getMessage());
                response.StatusCode = '404';
                response.Status = 'error';
                response.Data = null;
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    // Process exception here
                    response.Message =  e.getDmlMessage(i); 
                }                
            }            
        } else {
            response.StatusCode = '404';
            response.Status = 'error';
            response.Data = null;
            string tspexist = '';            
            response.Message = 'Fail : ' + Fieldname;            
        }
        return response;
    }
    
    private static string ValidateRequest(RegistrationInfo locationPayloadObj) {
        string Fieldname = '';        
        
        if(String.isBlank(locationPayloadObj.userInfo.username)) {
            Fieldname = Fieldname + 'username is required, ';
        }
        if(String.isBlank(locationPayloadObj.userInfo.email)) {
            Fieldname = Fieldname + 'email is required, ';
        }        
        if(String.isBlank(locationPayloadObj.userInfo.pga)) {
            Fieldname = Fieldname + 'pga is required, ';
        }        
        if(String.isBlank(locationPayloadObj.userInfo.lastName)) {
            Fieldname = Fieldname + 'lastName is required, ';
        }        
        if(String.isBlank(locationPayloadObj.userInfo.source)) {
            Fieldname = Fieldname + 'source is required, ';
        }        
        if(String.isBlank(locationPayloadObj.userInfo.firstName)) {
            Fieldname = Fieldname + 'firstName is required, ';
        }        
        if(String.isBlank(locationPayloadObj.userInfo.contactType)) {
            Fieldname = Fieldname + 'contactType is required, ';
        }        
        if(locationPayloadObj.userInfo.siteAdmin == null ) {
            Fieldname = Fieldname + 'siteAdmin is required, ';
        }        
        if(String.isBlank(locationPayloadObj.userInfo.contactStatus)) {
            Fieldname = Fieldname + 'contactStatus is required, ';
        }        
        if(String.isBlank(locationPayloadObj.subscriptionInfo.role)) {
            Fieldname = Fieldname + 'role is required, ';
        }        
        if(locationPayloadObj.subscriptionInfo.free == null ) {
            Fieldname = Fieldname + 'free is required, ';
        }        
        if(String.isBlank(locationPayloadObj.subscriptionInfo.subscriptionType)) {
            Fieldname = Fieldname + 'subscriptionType is required, ';
        }        
        if(String.isBlank(locationPayloadObj.subscriptionInfo.source)) {
            Fieldname = Fieldname + 'source is required, ';
        }        
        if(String.isBlank(locationPayloadObj.subscriptionInfo.applicationName)) {
            Fieldname = Fieldname + 'applicationName is required, ';
        }        
        if(locationPayloadObj.subscriptionInfo.endDate== null ) {
            Fieldname = Fieldname + 'endDate is required, ';
        }        
        if(String.isBlank(locationPayloadObj.subscriptionInfo.subscriptionName)) {
            Fieldname = Fieldname + 'subscriptionName is required, ';
        }        
        if(locationPayloadObj.subscriptionInfo.startDate== null ) {
            Fieldname = Fieldname + 'startDate is required, ';
        }        
        if(String.isBlank(locationPayloadObj.LocationPayloadInfo.language)) {
            Fieldname = Fieldname + 'language is required, ';
        }        
        if(String.isBlank(locationPayloadObj.LocationPayloadInfo.region)) {
            Fieldname = Fieldname + 'region is required, ';
        }        
        if(String.isBlank(locationPayloadObj.LocationPayloadInfo.city)) {
            Fieldname = Fieldname + 'city is required, ';
        }        
        if(String.isBlank(locationPayloadObj.LocationPayloadInfo.accountStatus)) {
            Fieldname = Fieldname + 'accountStatus is required, ';
        }        
        if(String.isBlank(locationPayloadObj.LocationPayloadInfo.zipCode)) {
            Fieldname = Fieldname + 'zipCode is required, ';
        }        
        if(String.isBlank(locationPayloadObj.LocationPayloadInfo.type)) {
            Fieldname = Fieldname + 'type is required, ';
        }        
        if(String.isBlank(locationPayloadObj.LocationPayloadInfo.stateName)) {
            Fieldname = Fieldname + 'stateName is required, ';
        }        
        if(String.isBlank(locationPayloadObj.LocationPayloadInfo.distributorCode)) {
            Fieldname = Fieldname + 'distributorCode is required, ';
        }        
        if(String.isBlank(locationPayloadObj.LocationPayloadInfo.countryName)) {
            Fieldname = Fieldname + 'countryName is required, ';
        }        
        if(String.isBlank(locationPayloadObj.LocationPayloadInfo.aboCode)) {
            Fieldname = Fieldname + 'aboCode is required, ';
        }
        if(String.isBlank(locationPayloadObj.LocationPayloadInfo.accountSource)) {
            Fieldname = Fieldname + 'accountSource is required, ';
        }        
        if(String.isBlank(locationPayloadObj.LocationPayloadInfo.addressLine1)) {
            Fieldname = Fieldname + 'addressLine1 is required, ';
        }        
        if(String.isBlank(locationPayloadObj.LocationPayloadInfo.name)) {
            Fieldname = Fieldname + 'name is required, ';
        }
        return Fieldname ;
    }

    public static Boolean validateEmail(List<String> lstemails) {     
        Boolean res = true;
        system.debug('lstemails==' + lstemails);        
        for(string email: lstemails)        
        {
            system.debug('email==' + email); 
            String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
            Pattern MyPattern = Pattern.compile(emailRegex);        
            Matcher MyMatcher = MyPattern.matcher(email);       
            if (!MyMatcher.matches())       
                res = false;        
            
            system.debug('res==' + res);            
        }       
        system.debug('res==' + res);        
        return res;
    }    
    
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

    public static Set<String> getPicklistValues(string fieldName,String objectName) {
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

    global class userInfo{
        public String username{get;set;}
        public String phone{get;set;}
        public String email{get;set;}
        public String pga{get;set;}
        public String lastName{get;set;}
        public String source{get;set;}
        public String firstName{get;set;}
        public String contactType{get;set;}
        public Boolean siteAdmin{get;set;}
        public String contactStatus{get;set;}
    }

    global class subscriptionInfo{
        public String role{get;set;}
        public String qsolExpiration{get;set;}
        public Boolean free{get;set;}
        public String subscriptionType{get;set;}
        public String applicationName{get;set;}
        public String source{get;set;}
        public Date   endDate{get;set;}
        public String subscriptionName{get;set;}
        public Date   startDate{get;set;}
    }

    global class RegistrationInfo{
        public LocationPayloadInfo LocationPayloadInfo{get;set;}
        public subscriptionInfo subscriptionInfo{get;set;}
        public userInfo userInfo{get;set;}
    }

    global class LocationPayloadInfo{
        public String language{get;set;}
        public String region{get;set;}
        public String city{get;set;}
        public String accountStatus{get;set;}
        public String zipCode{get;set;}
        public String type{get;set;}
        public String stateName{get;set;}
        public String distributorCode{get;set;}
        public String countryName{get;set;}
        public String aboCode{get;set;}
        public String addressLine2{get;set;}
        public String accountSource{get;set;}
        public String addressLine1{get;set;}
        public String name{get;set;}
    }       
}