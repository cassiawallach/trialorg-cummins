@RestResource(urlMapping='/location/UserSubscriptioncreation_CS/*')
global with sharing class IAM_ExistCompUserSubCreation_CS{
    
    @HttpPost
    global static CMI_ResponseHandler Post(UserLocationSubscriptionInfo UserLocationSubscriptionInfo) {
        
        system.debug('request====' + UserLocationSubscriptionInfo);
        
        CMI_ResponseHandler response = new CMI_ResponseHandler();
        
        string Fieldname = ValidateRequest(UserLocationSubscriptionInfo.userInfo , UserLocationSubscriptionInfo.subscriptionInfo);
        RestRequest request = RestContext.request;
        String cId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        if(Fieldname == '') {       
            List<IAM_Application__c>  apprcd = [select id, IAM_Application_Name__c,IAM_Account_Name__r.id from IAM_Application__c where IAM_Account_Name__r.CMI_Account_Num__c =:cId and IAM_Application_Name__c = 'Connected Solutions'];
            System.debug('apprcd====='+apprcd);
            IAM_Application__c app = new IAM_Application__c();
            if(apprcd == null || apprcd.isEmpty()){ 
                response.StatusCode = '404';
                response.Status = 'error';
                response.Data = null;           
                response.Message = 'please enter a valid customer';
                return response;
            } 
            Map<string,subscriptionInfo> usrnameSubsMap = new Map<string,subscriptionInfo>();
            for(subscriptionInfo objSubsInfo :UserLocationSubscriptionInfo.subscriptionInfo) {
                usrnameSubsMap.put(objSubsInfo.userEmail,objSubsInfo);
            }
            
            try {
                List<Contact> newConList = new List<Contact>();
                List<IAM_Contact_Provisioning__c> conUserApp = new List<IAM_Contact_Provisioning__c>();
                Savepoint sp = Database.setSavepoint();                                   
                try{ 
                    for(userInfo objUsrInfo :UserLocationSubscriptionInfo.userInfo){
                        Contact conObj = new Contact();
                        conObj.AccountId = apprcd[0].IAM_Account_Name__r.id;
                        //conObj.IAM_Product_Group_Access__c = objUsrInfo.pga;
                        conObj.IAM_Contact_source__c = objUsrInfo.source;
                        conObj.Phone = objUsrInfo.phone;
                        conObj.CMI_Contact_Type__c = objUsrInfo.contactType;
                        conObj.Email= objUsrInfo.email;
                        conObj.Username__c = objUsrInfo.username;
                        conObj.IAM_Contact_Status__c = objUsrInfo.contactStatus;                                          
                        conObj.IAM_Site_Admin__c = false;//objUsrInfo.siteAdmin;
                        conObj.IAM_AppId__c=System.Label.IAM_Connected_Solution_Mapping_ID;
                        conObj.FirstName = objUsrInfo.firstName;
                        conObj.LastName =  objUsrInfo.lastName;               
                        conObj.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                        newConList.add(conObj);
                    }
                    Database.SaveResult[] srConList = Database.insert(newConList, false);
                    set<Id> conSuccessId = new set<Id>();
                    Set<Id> conFailedId = new Set<Id>();
                    String conError;
                    for (Database.SaveResult sr : srConList) {
                        if (sr.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            System.debug('Successfully inserted Contact. Contact ID: ' + sr.getId());
                            conSuccessId.add(sr.getId());
                        }
                        else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('The following error has occurred for Contact.');  
                                conError = err.getMessage();
                                System.debug('ContactErrorStatus@'+err.getStatusCode() + ':ContactErrorMessage@ ' + err.getMessage());
                                System.debug('Contact Fields that affected this error: ' + err.getFields());
                            }
                        }
                    }
                    
                    system.debug('newConList@@@'+newConList);
                    map<string,contact> usrnameConMap = new  map<string,contact>();
                    List<Contact> Successlistcon = [Select Id,Username__c,AccountId from Contact where ID IN:conSuccessId];
                    for(contact Objcon :Successlistcon){
                        usrnameConMap.put(Objcon.Username__c,Objcon);
                    }
                    
                    System.debug('Printing username Map'+usrnameConMap);
                    List<IAM_Contact_Provisioning__c> newSubcriptionList= new List<IAM_Contact_Provisioning__c>();
                    // User Subscription creation 
                    for(subscriptionInfo objSubsInfo :UserLocationSubscriptionInfo.subscriptionInfo){
                        System.debug('Printing debug Statements'+usrnameConMap.containsKey(objSubsInfo.userEmail));
                        if(usrnameConMap.containsKey(objSubsInfo.userEmail)){
                            
                            IAM_Contact_Provisioning__c conAccessObj = new IAM_Contact_Provisioning__c();
                            conAccessObj.IAM_Contact__c= usrnameConMap.get(objSubsInfo.userEmail).Id;                            
                            conAccessObj.IAM_Start_Date__c = objSubsInfo.startDate;
                            conAccessObj.IAM_End_Date__c = objSubsInfo.endDate;
                            conAccessObj.IAM_Application_Name__c = objSubsInfo.applicationName;
                            conAccessObj.IAM_Role__c = objSubsInfo.role;
                            conAccessObj.IAM_License_Type__c = objSubsInfo.licenseType;
                            conAccessObj.IAM_Status__c = objSubsInfo.subscriptionType;
                            conAccessObj.IAM_Source__c = objSubsInfo.source;
                            conAccessObj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(objSubsInfo.applicationName).getRecordTypeId();
                            conAccessObj.IAM_Account_Application__c = apprcd[0].Id; 
                            conAccessObj.IAM_DA_Customer_List__c =cid;
                            conAccessObj.IAM_DA_Session_Time_Out__c='86400000';
                            conAccessObj.IAM_DA_Calibaration_Role__c=objSubsInfo.role;
                            //add field for customer list=assign CMI_Account_Num on 
                            newSubcriptionList.add(conAccessObj); 
                        }
                    }
                    //insert newSubcriptionList;
                    Database.SaveResult[] srSubList = Database.insert(newSubcriptionList, false);
                    String subError;
                    List<String> errorFields;
                    Set<Id> subSuccessId = new Set<Id>();
                    
                    for (Database.SaveResult sr : srSubList) {
                        if (sr.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            System.debug('Successfully inserted Contact. Contactprov ID: ' + sr.getId());
                            subSuccessId.add(sr.getId());
                        }
                        else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('The following error has occurred.');   
                                subError = err.getMessage();
                                errorFields = err.getFields();
                                System.debug('conProErrorStatus@'+err.getStatusCode() + ':conProErrorMessage@ ' + err.getMessage());
                                System.debug('conPro Fields that affected this error: ' + err.getFields());
                            }
                        }
                    }
                    if((newConList.size() == conSuccessId.size()) && (newSubcriptionList.size() == subSuccessId.size())){
                        response.Message = 'Inserted Successfully';
                        response.StatusCode = '200';
                        response.Status = 'Success';
                        response.Data = null; 
                    }
                    else if(conSuccessId.size()==0 || subSuccessId.size()==0){
                        response.Message = conSuccessId.size()==0?conError:subError;
                        response.StatusCode = '404';
                        response.Status = 'error';
                        response.Data = null;
                       // Database.rollback(sp);      
                    }
                    else if(newConList.size() != conSuccessId.size() || newSubcriptionList.size() != subSuccessId.size()){
                        string Successcon='';
                        String errorcon='';
                        List<Contact> successRecord =[Select Name,Username__c from Contact Where ID IN :conSuccessId ];
                        for(contact objcon : successRecord){
                            Successcon =(Successcon =='')? (objcon.Username__c): (Successcon+','+objcon.Username__c);
                                system.debug('Successcon!!!'+Successcon);
                        }
                        for(userInfo objUsrInfo :UserLocationSubscriptionInfo.userInfo){
                            if(!Successcon.contains(objUsrInfo.username)){
                                if(errorcon==''){
                                    errorcon = +objUsrInfo.username;
                                }else{
                                    errorcon = errorcon +','+objUsrInfo.username;
                                }
                            }
                        }
                        response.StatusCode = '200';
                        response.Status = 'error';
                        response.Message = 'Partial Insert Successfully';
                        response.completeRecord=Successcon.removeEnd(',');
                        response.failRecord=errorcon.removeEnd(',');
                        response.Data = null; 
                    }
                }
                catch (System.DmlException e) {
                    if(e.getMessage().contains('Insert failed. First exception on row 0; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, IAM_UserFeatureAndAccessTrigger: execution of AfterInsert')){
                        response.StatusCode = '404';
                        response.Status = 'error';
                        response.Data = null;           
                        response.Message = 'Please re-use existing Provisioning records or else inactivate it and create new.';
                        return response;
                    }
                    cmiError(e.getMessage());
                    
                    //system.debug('DmlException====' + e);
                    System.debug('Exception e '+e.getLineNumber());
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
    
    private static string ValidateRequest(List<userInfo> NewuserInfoObj,List<subscriptionInfo> subsInfo ) {
        
        string Fieldname = ''; 
        for(userInfo objUsrInfo :NewuserInfoObj){
            /*if(objUsrInfo.pga== null) {
                
                Fieldname = Fieldname + ' pga is required, ';
                break;
            }  */  
            
            if(objUsrInfo.Phone == null) {
                
                Fieldname = Fieldname + ' Phone is required, ';
                break;
            }
            
            if(objUsrInfo.Email == null) {
                
                
                Fieldname = Fieldname + ' Email is required, ';
                break;
            }                
            
            if(objUsrInfo.contactType == null || objUsrInfo.contactType.trim() == '') {
                
                Set<string> tmplist = getPicklistValues('CMI_Contact_Type__c','Contact');
                System.debug('***************'+tmplist );
                if(!tmplist.contains(objUsrInfo.contactType)) {
                    Fieldname = Fieldname + ' Contact type is required,';  
                    break;
                }
            }
            if(objUsrInfo.contactType != null && objUsrInfo.contactType != 'Secondary'){
                Fieldname = Fieldname + ' Contact type shuold be always Secondary,';  
                    break;
            }
            
            if(objUsrInfo.lastName == null || objUsrInfo.lastName.trim() == '') {
                Fieldname = Fieldname + ' last Name is required, ';
                break;
            }
            
            if(objUsrInfo.firstName == null || objUsrInfo.firstName.trim() == '') {
                Fieldname = Fieldname + ' first Name is required, ';
                break;
            }
            
            if(objUsrInfo.contactStatus == null || objUsrInfo.contactStatus.trim() == '') {
                Set<string> tmplist = getPicklistValues('IAM_Contact_Status__c','Contact');
                System.debug('***************'+tmplist );
                if(!tmplist.contains(objUsrInfo.contactStatus)) {
                    Fieldname = Fieldname + ' Contact status is required, '; 
                }
                
                break;
            }
            if(objUsrInfo.contactStatus != null && objUsrInfo.contactStatus != 'Active') {
                    Fieldname = Fieldname + ' Contact status must be Active, ';
                }
            if(String.isNotBlank(objUsrInfo.username) 
               && objUsrInfo.username.containsIgnoreCase('@cummins.')) {
                   Fieldname = Fieldname + Label.IAM_Username_Should_Not_Contain_Cummins + ', ';
                   break;
               }
            if(objUsrInfo.source == null || objUsrInfo.source.trim() == '') {
                Set<string> tmplist = getPicklistValues('IAM_Contact_source__c','Contact');
                System.debug('***************'+tmplist );
                if(!tmplist.contains(objUsrInfo.source)) {
                    Fieldname = Fieldname + ' source is required, ';  
                } 
                if(objUsrInfo.source != 'PC') {
                    Fieldname = Fieldname + ' source shuold be always PC, ';
                }
                break;
            }
        }
            for(subscriptionInfo objSubsInfo :subsInfo){
                if(objSubsInfo.startDate == null) {
                    Fieldname = Fieldname + ' startDate is required, ';
                    break;
                }
                
                if(objSubsInfo.endDate == null) {
                    Fieldname = Fieldname + ' endDate is required, ';
                    break;
                }
                if(objSubsInfo.applicationName == null || objSubsInfo.applicationName.trim() == '') {
                    Fieldname = Fieldname + ' applicationName is required, ';
                    break;
                }
                if(objSubsInfo.role== null || objSubsInfo.role.trim() == '') {
                    Set<string> tmplist = getPicklistValues('IAM_Role__c','IAM_Application__c');
                    System.debug('***************'+tmplist );
                    if(!tmplist.contains(objSubsInfo.role)) {
                        Fieldname = Fieldname + ' role  is required, ';
                        break;
                    }           
                }
               /* if((objSubsInfo.qsolExpiration == null || objSubsInfo.qsolExpiration.trim() == '') && objSubsInfo.applicationName == 'QuickServe Online') { 
                    Fieldname = Fieldname + ' qsolExpiration is required, ';
                    break;
                }  
*/
                if(objSubsInfo.subscriptionType == null || objSubsInfo.subscriptionType.trim() == '') {
                    Set<string> tmplist = getPicklistValues('IAM_Status__c','IAM_Application__c');
                    System.debug('***************'+tmplist );
                    if(!tmplist.contains(objSubsInfo.subscriptionType)) {
                        
                        Fieldname = Fieldname + ' subscriptionType is required, ';
                        break;
                    }  
                }
                if(objSubsInfo.source == null || objSubsInfo.source.trim() == '') {
                    Fieldname = Fieldname + ' source is required, ';
                    break;
                }        
                if(objSubsInfo.free == null) { 
                    Fieldname = Fieldname + ' free is required, ';
                    break;
                }
            }    
        return Fieldname ;
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
        public String completeRecord {get;set;}
        public String failRecord {get;set;}
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
        public subscriptionInfo[] subscriptionInfo{get;set;}
        public userInfo[] userInfo{get;set;}
    }
    global class userInfo {
        public String source{get;set;}
        public String phone{get;set;}
        //public String pga{get;set;}
        public String username{get;set;}
        public String contactType{get;set;}
        public String email{get;set;}
        public String contactStatus{get;set;}
        public String lastName{get;set;}
        //public Boolean siteAdmin{get;set;}
        public String firstName{get;set;}
        
    }
    global class subscriptionInfo {
        public Date endDate{get;set;}
        //public String swregExpire{get;set;}
        //public String qsolExpiration{get;set;}
        public Boolean free{get;set;}
        public String licenseType{get;set;}
        public String role{get;set;}
        public String subscriptionType{get;set;}
        public String applicationName{get;set;}
        public String source{get;set;}       
        public Date startDate{get;set;}
        public string SubscriptionName{get;set;}
        public String userType{get;set;}
        public String userEmail{get;set;}
    }  
    
}