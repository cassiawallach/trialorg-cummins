/**
 *      @author             Vineet 
 *      @date               18/08/2018
 *      @description        OSM_SW_General_Util
 
        Modification Log:
        ------------------------------------------------------------------------------------
        Developer                       Date                Description
        ------------------------------------------------------------------------------------
        Vineet                         18/08/2018           Initial Setup
        Subbu
         
 */  
public without sharing class OSM_SW_General_Util {
      
    Public static boolean ALREADY_CHECK_USER_PERMISSIONSET = false;    
    Public static String USER_TYPE = ''; 
    
    Public static boolean ALREADY_CHECK_USER_PERMISSIONSET_FOR_CANCEL_BUTTON = false;
    Public static String CANCEL_BUTTON_USER_TYPE = ''; 
    
  Public static boolean ALREADY_CHECK_USER_DETAILS = false;
    Public static String OSM_STOREFRONT_USER_TYPE = '';
 
    public static Boolean getEffEnabled(){
        Id userId = UserInfo.getUserId();
        Boolean effectiveSelectEnabled = false;
        List<User> currUser = [SELECT Id, OSM_Storefront_User_Type__c FROM User WHERE id=:userId];
        if(!currUser.isEmpty()){
            if(!String.isBlank(currUser[0].OSM_Storefront_User_Type__c) || test.isRunningTest()){
                effectiveAccount_enable_ProfileUserType__c featureSwitch =  effectiveAccount_enable_ProfileUserType__c.getInstance(String.valueOf(currUser[0].OSM_Storefront_User_Type__c));
                if(featureSwitch != null)
                    effectiveSelectEnabled = featureSwitch.Enable_Effective_Account_Selection__c;
            }
        }
        return effectiveSelectEnabled;
    }
    
    public static String getuserType(String userId){
        String userType = '';
        if(!ALREADY_CHECK_USER_PERMISSIONSET){
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [   SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE AssigneeId = :userId];
            for(PermissionSetAssignment permSet: lstcurrentUserPerSet)
            {
                System.debug('Permission Set Assigned to User: '+permSet.PermissionSet.Name);
                if(permSet.PermissionSet.Name==Label.OSM_Business_Admin)
                {
                    
                    userType=Label.OSM_Business_Admin_UserType;
                    break;
                }
                else  if(permSet.PermissionSet.Name== Label.OSM_Support_Admin)
                {
                 
                    userType=Label.OSM_Support_Admin_UserType;
                    break;
                }
                else if(permSet.PermissionSet.Name== Label.OSM_Sales_Admin)
                {
                   
                    userType=Label.OSM_Sales_Admin_UserType;
                    break;
                }
                else if(permSet.PermissionSet.Name==Label.OSM_Sales_User )
                {
                  
                    userType=Label.OSM_Sales_UserType;
                    break;
                }
                else if(permSet.PermissionSet.Name== Label.OSM_Dealer_Admin)
                {
                   
                    userType=Label.OSM_Dealer_Admin_UserType;
                    break;
                }
                else if(permSet.PermissionSet.Name== Label.OSM_Distributor_Admin)
                {
                    
                    userType=Label.OSM_Distributor_Admin_UserType;
                    break;
                }
                else if(permSet.PermissionSet.Name== Label.OSM_Fleet_Admin)
                {
                  
                    userType=Label.OSM_Fleet_Admin_UserType;
                    break;
                }
                 else if(permSet.PermissionSet.Name== Label.OSM_Storefront_Admin)
                {
                  
                    userType=Label.OSM_Storefront_Admin_UserType;
                    break;
                }
                else if(permSet.PermissionSet.Name== Label.OSM_SSOEM_Admin)
                {
                  
                    userType=Label.OSM_SSOEM_Admin_UserType;
                    break;
                }
                else if(permSet.PermissionSet.Name== Label.OSM_Training_Admin)
                {
                  
                    userType=Label.OSM_Training_Admin_UserType;
                    break;
                }
                else if(permSet.PermissionSet.Name== Label.OSM_Reseller_Admin)
                {
                  
                    userType=Label.OSM_Reseller_Admin_UserType;
                    break;
                }

            } 
            
         USER_TYPE = userType;
         ALREADY_CHECK_USER_PERMISSIONSET = true;   
        }
        return userType;
    }

  /*
    Share Quote records with edit permission to passed user or Group 
    */
    public static boolean manualQuoteShareEdit(Id recordId, Id userOrGroupId){
       /* system.debug('Manual sharing-->'+recordId+'===='+userOrGroupId);
      // Create new sharing object for the custom object Job.
      ccrz__E_RequestForQuote__Share jobShr  = new ccrz__E_RequestForQuote__Share();
   
      // Set the ID of record being shared.
      jobShr.ParentId = recordId;
        
      // Set the ID of user or group being granted access.
      jobShr.UserOrGroupId = userOrGroupId;
        
      // Set the access level.
      jobShr.AccessLevel = 'Edit';
        
      // Set rowCause to 'manual' for manual sharing.
      // This line can be omitted as 'manual' is the default value for sharing objects.
      //jobShr.RowCause = Schema.ccrz__E_RequestForQuote__Share.RowCause.Manual;
        
      // Insert the sharing record and capture the save result. 
      // The false parameter allows for partial processing if multiple records passed 
      // into the operation.
      Database.SaveResult sr = Database.insert(jobShr,true);

      // Process the save results.
      if(sr.isSuccess()){
         // Indicates success
         return true;
      }
     
        return false;
        */
        return true;
   }
   
    public static String getpermissionset(String userId)
    {
        String cancelButtonUserType = '';
        if(!ALREADY_CHECK_USER_PERMISSIONSET_FOR_CANCEL_BUTTON)
        {
            List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :userId];
            
            for(PermissionSetAssignment permSet: lstcurrentUserPerSet)
            {
                System.debug('permSet FOR if...' + permSet);
                if(permSet.PermissionSet.Name == Label.OSM_Support_Admin)
                {
                    System.debug('Inside 1st FOR if...');
                    cancelButtonUserType = 'true';
                    //inputData.put('orderCanCancel',true);  
                }   
            }
            System.debug('lstcurrentUserPerSet...' + lstcurrentUserPerSet); 
            
            CANCEL_BUTTON_USER_TYPE = cancelButtonUserType;
            ALREADY_CHECK_USER_PERMISSIONSET_FOR_CANCEL_BUTTON = true;   
        }
        System.debug('cancelButtonUserType...' + cancelButtonUserType);
        return cancelButtonUserType;
    }
    
    public static String getuserdetails(String userId)
    {
        User objUser = new User();
        String strOSMStorefrontUserType = '';
        if(!ALREADY_CHECK_USER_DETAILS)
        {
            objUser = [SELECT IsActive,IsPortalEnabled,OSM_Storefront_User_Type__c FROM User where Id =: userId];
            
            //return objUser.OSM_Storefront_User_Type__c; 
            strOSMStorefrontUserType = objUser.OSM_Storefront_User_Type__c; 
            OSM_STOREFRONT_USER_TYPE = strOSMStorefrontUserType;
              ALREADY_CHECK_USER_DETAILS = true;  
        }
        return strOSMStorefrontUserType; 
 
    }

    
    @future
    public static void quoteApexSharing(String quote){
       /* ccrz__E_RequestForQuote__c rfq = [Select id, OwnerId from ccrz__E_RequestForQuote__c where Id =:quote];
        User usr = [select id, ManagerId from User where Id =: rfq.OwnerId];
         // Create new sharing object for the custom object Job.
        try{
      ccrz__E_RequestForQuote__Share jobShr  = new ccrz__E_RequestForQuote__Share();
   
      // Set the ID of record being shared.
      jobShr.ParentId = quote;
        
      // Set the ID of user or group being granted access.
      jobShr.UserOrGroupId = '00G4C0000015PJT';
        
      // Set the access level.
      jobShr.AccessLevel = 'Edit';
        
      // Set rowCause to 'manual' for manual sharing.
      // This line can be omitted as 'manual' is the default value for sharing objects.
      //jobShr.RowCause = Schema.ccrz__E_RequestForQuote__Share.RowCause.Manual;
        
      // Insert the sharing record and capture the save result. 
      // The false parameter allows for partial processing if multiple records passed 
      // into the operation.
      Database.SaveResult sr = Database.insert(jobShr,true);

        }Catch(exception ex){System.debug(ex);}*/
    }
    
    
    public static void maintainErrorLog(Exception ex, String ServiceName, String accountId){
        
         String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();

        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        if(String.isNotBlank(accountId)){
            log.Account__c = accountId;
        }
        log.Error_Description__c = errorMsg;

        log.Service_Name__c = ServiceName;

        log.Status__c = Label.OSM_Failed;

        insert log;
        
    }
    
    public static void maintainErrorLog(String ex, String ServiceName, String accountId){
        
         String errorMsg = ex;

        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        if(String.isNotBlank(accountId)){
            log.Account__c = accountId;
        }
        log.Error_Description__c = errorMsg;

        log.Service_Name__c = ServiceName;

        log.Status__c = Label.OSM_Failed;

        insert log;
        
    }
}