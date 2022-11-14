/************************************************************
Name:  IAM_NewAccountRegistration
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_NewAccountRegistration class.
This class is used for register the new account. and this class is creates the Account, Contact, Account provisoing and Contact provsioning records
for users. Based on application settings in App mapping object, we have given the access to users. And we are using this class in New Account and
Existing account registration. In new registration flow, we are creating all the records and sending to approval if approval needed on application.
In Existing account registration, we are not creating the Account, Just provding the access to contact and sending to approval. After registration is completed
then we are redirecting to confirmation page.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE                  DETAIL                                
1.0 -    Keerthy Gurumurthy     23/04/2018        INITIAL DEVELOPMENT 
1.1 -    Shubhangi Sardar       12/03/2020        Added Changes for parent location
1.2 -    Karthik Raj Golakaram  06/01/2021        MAde Changes for Registration issues for OSM
*****************************************************/
@RestResource(urlMapping='/user/Newuser/*')
global class IAM_NewUserCreation{
    
    //==============================================================================================
    // *** REST Post *** :  Requires the cummins customer id of Account and reutrn results as Response Type
    //===============================================================================================
    @HttpPost
    global static CMI_ResponseHandler3 Post(userInfo userInfo)
    {
        system.debug('request====' + userInfo);
                                
        RestRequest req = RestContext.request;
        CMI_ResponseHandler3 response = new CMI_ResponseHandler3();
         
        
        RestRequest request = RestContext.request;
        String lDapId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        string Fieldname = ValidateRequest(userInfo,lDapId);
        system.debug('Fieldname====' + Fieldname);
         List<Account> accntDist= new List<Account>();
          
    
        
        if(Fieldname == '')
        {   
            //changes for checking if contacts are present in the location and also making sure the Location Type is not Distributor Account.
            accntDist=[Select id,Type,(SELECT id FROM Contacts WHERE IAM_Contact_Status__c=:userInfo.contactStatus) from Account where IAM_Service_Provider_Code__c=:lDapId LIMIT 1];
              
              
            try
            {
                Savepoint sp = Database.setSavepoint();                                   
               try{                             
                   
                Contact conObj = new Contact();
                conObj.AccountId = accntDist[0].Id;
                conObj.IAM_Product_Group_Access__c = userInfo.pga;
                conObj.IAM_Contact_source__c = userInfo.source;
                conObj.Phone = userInfo.phone;
                if(accntDist[0].Contacts.isEmpty()){
                    conObj.CMI_Contact_Type__c = userInfo.contactType;
                }else{
                    conObj.CMI_Contact_Type__c ='Secondary';
                }
                conObj.Email= userInfo.email;
                conObj.IAM_Contact_Status__c = userInfo.contactStatus;
                conObj.Username__c= userInfo.username;
                if(userInfo.siteAdmin=='1')
                {
                conObj.IAM_Site_Admin__c = true;
                }
                else
                {
                conObj.IAM_Site_Admin__c = false;
                }
                
                conObj.FirstName = userInfo.firstName;
                conObj.LastName =  userInfo.lastName;   
                conObj.RecordtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                   insert conObj;
                                                   
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
        else
        {
            response.StatusCode = '404';
            response.Status = 'error';
            response.Data = null;
            string tspexist = '';            
            response.Message = 'Fail : ' + Fieldname;
            
        }
        
        return response;
    }
    
   private static string ValidateRequest(userInfo userInfoObj,String custCode)
    {
        string Fieldname = '';
       if(!String.isBlank(custCode)){
           List<Account> a=[Select id from Account where IAM_Service_Provider_Code__c=:custCode LIMIT 1];
           if(a.isEmpty()){
                Fieldname = Fieldname + ' No Location/Account is present, ';
           }
       }    
        
      if(userInfoObj.pga== null)
        {
            Fieldname = Fieldname + ' pga is required, ';
        }
        
         if(userInfoObj.Phone == null)
        {
            Fieldname = Fieldname + ' Phone is required, ';
        }
        
       if(userInfoObj.Email == null)
        {
             
            Fieldname = Fieldname + ' first Name is required, ';
        }                
        
         if(userInfoObj.contactType == null || userInfoObj.contactType.trim() == '')
        {
             Set<string> tmplist = getPicklistValues('CMI_Contact_Type__c','Contact');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(userInfoObj.contactType))
            {
             Fieldname = Fieldname + ' Contact type is required, ';
            }           
        }
        
         if(userInfoObj.lastName == null || userInfoObj.lastName.trim() == '')
        {
             
            Fieldname = Fieldname + ' last Name is required, ';
        }
        
         if(userInfoObj.firstName == null || userInfoObj.firstName.trim() == '')
        {
             
            Fieldname = Fieldname + ' first Name is required, ';
        }
         
         if(userInfoObj.contactStatus == null || userInfoObj.contactStatus.trim() == '')
        {
             Set<string> tmplist = getPicklistValues('IAM_Contact_Status__c','Contact');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(userInfoObj.contactStatus))
            {
              Fieldname = Fieldname + ' contact Status is required, ';
            }  
           
        }
        
    /*  if(userInfoObj.siteAdmin == null)
        {             
            Fieldname = Fieldname + ' site Admin is required, ';
        } */
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
    global class CMI_ResponseHandler3 {
    
        //List of custom attributes that we want to check the status of the org
        public String Status {get; set;}
        public List<sObject> Data {get;set;}
        public String Message {get;set;}
        public String StatusCode {get; set;}
        
         
    }
    Public static Set<String> getPicklistValues(string fieldName,String objectName)
    {
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
        public String pga{get;set;}
        public String source{get;set;}
        public String phone{get;set;}
        public String contactType{get;set;}
        public String username{get;set;}
        public String contactStatus{get;set;}
        public String email{get;set;}
        public String siteAdmin {get;set;}
        public String lastName{get;set;}
        public String firstName{get;set;}
    }

                   
}