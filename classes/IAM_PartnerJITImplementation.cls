/************************************************************
Name:  IAM_PartnerJITImplementation
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class provides logic for inbound just-in-time provisioning of single sign-on users in your Salesforce organization.                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Karthik Raj Golakaram          1/16/2020        INITIAL DEVELOPMENT
1.1 -    Anupam Adhikari                03/23/2022       Changes for Ryder Fed
1.2 -    Anupam Adhikari                06/17/2022       Changes for Ryder-Cumpas Fed 
*****************************************************/
/********************************************************************************
***********************************************************************************/

global class IAM_PartnerJITImplementation implements Auth.SamlJitHandler {
    
    public static string APP_NAME_QSOL=System.Label.IAM_AppName_QSOL;
    public static string APP_NAME_EDS=System.Label.IAM_AppName_EDS;
    public static string APP_NAME_CST=System.Label.IAM_AppName_Promotion;
    public static string APP_NAME_CUMPAS=System.Label.IAM_AppName_Cumpas;//added for Ryder-Cumpas Integration changes
    public static string QSOL_ROLE_CIHR='QSOL CIHR';
    public static string EDS_ROLE_TECHNICIAN='Technician';
    public static string CST_ROLE_TRAINING='Service Training User';
    public static string CUMPAS_ROLE_DEALER='Dealer User';//added for Ryder-Cumpas Integration changes
    public User partnerUserDetails;
    public Contact partnerContactDetails;
    public Account partnerAccountDetails;
    public Map<String,IAM_Application__c> partnerAccountAccessAllMap= new Map<string,IAM_Application__c>();
    public Map<string,IAM_Contact_Provisioning__c> partnerContactAccessAllMap= new Map<string,IAM_Contact_Provisioning__c>();
    public User userToReturn;
    public Map<integer,string> monthToMonthNameMap=new Map<Integer,String>{1=>'JAN',2=>'FEB',3=>'MAR',4=>'APR',5=>'MAY',6=>'JUN',7=>'JUL',8=>'AUG',9=>'SEP',10=>'OCT',11=>'NOV',12=>'DEC'};
    
    //Method to create user if username is not present in IAM..
    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map<String, String> attributes, String assertion) {
            system.debug('Ryder User attribute'+attributes);
            system.debug('Ryder Community Id '+communityId);
            system.debug('Ryder portalId Id '+portalId);
            system.debug('Ryder Federation Id '+federationIdentifier);
            system.debug('Ryder SAML SSO PROVIDER '+samlSsoProviderId);
            system.debug('Ryder Assertion '+assertion);
        User u = new User();
        handleJit(true, u, samlSsoProviderId, communityId, portalId,
            federationIdentifier, attributes, assertion);
        return userToReturn;
    }
    
    //Method to Update the exsisting user.
    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map<String, String> attributes, String assertion) {
            system.debug('Ryder Updated User '+attributes);
        User u = getPartnerUserDetails(userId);
        handleJit(false, u, samlSsoProviderId, communityId, portalId,
            federationIdentifier, attributes, assertion);
    }
    
    //Hanlde both the Create and Update Scenarios.
    private void handleJit(boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map<String, String> attributes, String assertion) {
            system.debug('Ryder attribute '+attributes);
            system.debug('Ryder User '+u);
            system.debug('Ryder Community Id '+communityId);
            system.debug('Ryder portalId Id '+portalId);
            system.debug('Ryder Federation Id '+federationIdentifier);
            system.debug('Ryder SAML SSO PROVIDER '+samlSsoProviderId);
            system.debug('Ryder Assertion '+assertion);
        String sDefaultRyderCustCode = '';    
        sDefaultRyderCustCode = Label.IAM_RyderDefaultLoc_CustCode;
            system.debug('sDefaultRyderCustCode--->'+sDefaultRyderCustCode);
        partnerAccountDetails=getPartnerAccountDetails(attributes);
        partnerContactDetails=getPartnerContactDetails(federationIdentifier);
        //Start - Ryder-Cumpas Changes
        Boolean bIsPartnercode = False;
        //bIsPartnercode = getPartnerLocCode(attributes, bIsPartnercode);
        
        System.debug('Printing Loaction code'+attributes.get('location_num'));
        System.debug('Printing if it is update or create'+create);
            System.debug('partnerAccountDetails on top--->'+partnerAccountDetails);
            System.debug('partnerContactDetails on top--->'+partnerContactDetails);
            //Code part to handle creating user ,update user attributes and permission sets.
            //Checking if location is present in SF - IAM or not and Throwing Expection.
            if(partnerAccountDetails.id!=null){
                System.debug('inside if partnerAccountDetails != null');
                //Start - Ryder-Cumpas change
                partnerContactAccessAllMap = handleContactAccessValidation(partnerContactDetails.Contact_Provisionings__r,attributes,bIsPartnercode);
                //End - Ryder-Cumpas change
                //Check if Account Access features are blank or not.
                if(!partnerAccountDetails.Applications__r.isEmpty()){
                    partnerAccountAccessAllMap = handleAccountAccessValidation(partnerAccountDetails.Applications__r, attributes);
                    //Creating Account access features.
                    //Start - Ryder-Cumpas Changes
                    if(attributes.get('uid').containsIgnoreCase('ryd') && (!partnerAccountAccessAllMap.ContainsKey(APP_NAME_QSOL)||!partnerAccountAccessAllMap.ContainsKey(APP_NAME_CST)||!partnerAccountAccessAllMap.ContainsKey(APP_NAME_EDS))){
                       System.debug('inside if create acc feature--->'); 
                       createAccountAccessFeatures(userToReturn,partnerAccountDetails,partnerContactDetails,partnerAccountAccessAllMap,partnerContactAccessAllMap,attributes,bIsPartnercode); 
                    }else if(!partnerAccountAccessAllMap.ContainsKey(APP_NAME_QSOL)||!partnerAccountAccessAllMap.ContainsKey(APP_NAME_CST)||!partnerAccountAccessAllMap.ContainsKey(APP_NAME_EDS)){
                        System.debug('inside else if create acc feature--->');
                        createAccountAccessFeatures(userToReturn,partnerAccountDetails,partnerContactDetails,partnerAccountAccessAllMap,partnerContactAccessAllMap,attributes,bIsPartnercode);    
                    }
                	//End - Ryder-Cumpas Changes
                }else{
                    //Since we do not have any Account access and features. creating all new Account access and features.
                    createAccountAccessFeatures(userToReturn,partnerAccountDetails,partnerContactDetails,partnerAccountAccessAllMap,partnerContactAccessAllMap,attributes,bIsPartnercode); 
                }
                //Logic start for Ryder - @Anupam
            }else if(partnerContactDetails.Id != null && attributes.get('uid').containsIgnoreCase('ryd')){
				 System.debug('inside 1st else if partnerContactDetails != null');               
                partnerAccountDetails = getAcctRyderDefault(sDefaultRyderCustCode);
                partnerAccountAccessAllMap = handleAccountAccessValidation(partnerAccountDetails.Applications__r, attributes);
                partnerContactAccessAllMap = handleContactAccessValidation(partnerContactDetails.Contact_Provisionings__r,attributes,bIsPartnercode);               
                
            }else if(partnerContactDetails.Id == null && attributes.get('uid').containsIgnoreCase('ryd')){
                System.debug('inside 12nd else if partnerContactDetails == null'); 
                partnerAccountDetails = getAcctRyderDefault(sDefaultRyderCustCode);
                partnerAccountAccessAllMap = handleAccountAccessValidation(partnerAccountDetails.Applications__r, attributes);
                //logic end for Ryder - @Anupam
            }else{
                //Throw an exception and Route them to a Static Screen.zs3
                throw new JitException('Location is not a valid Location');
            }
            System.debug('partnerAccountDetails--->'+partnerAccountDetails);
            System.debug('partnerAccountAccessAllMap--->'+partnerAccountAccessAllMap);
            //Checking of contact exsits in the System and query along with the Location Code.
            //If location code in SAML is not the same as that of contact Location Code. throw error.
        if(Create){
            System.debug('Printing if Create section in JIT Handler');
            if(partnerContactDetails.id!=null){
                //Check Contact Access Feature , Create user record and assign permission sets and let the user to login to application.
                partnerContactAccessAllMap= new Map<string,IAM_Contact_Provisioning__c>();
                    //Contact and account belongs to same location. Check user access features(QSOL,EDS,CST) present for contact. If any them are missing,Create the records.Then Create User record and assign permission sets.
                    partnerContactAccessAllMap = handleContactAccessValidation(partnerContactDetails.Contact_Provisionings__r,attributes,bIsPartnercode);
                    System.debug('Printing all APP Map for contact access and feature'+partnerAccountAccessAllMap);
                //Start - Ryder-Cumpas changes
                if(attributes.get('uid').containsIgnoreCase('ryd') && (!partnerContactAccessAllMap.ContainsKey(APP_NAME_QSOL)||!partnerContactAccessAllMap.ContainsKey(APP_NAME_CST)||!partnerContactAccessAllMap.ContainsKey(APP_NAME_EDS))){
                    System.debug('inside if create user feature--->');
                    createContactProvisionings(u,partnerContactDetails,partnerAccountAccessAllMap,partnerContactAccessAllMap,attributes,bIsPartnercode);
                }else if(!partnerContactAccessAllMap.ContainsKey(APP_NAME_QSOL)||!partnerContactAccessAllMap.ContainsKey(APP_NAME_CST)||!partnerContactAccessAllMap.ContainsKey(APP_NAME_EDS)){
                    System.debug('inside if create acc feature--->');
                    createContactProvisionings(u,partnerContactDetails,partnerAccountAccessAllMap,partnerContactAccessAllMap,attributes,bIsPartnercode);
                }
                //End - Ryder-Cumpas changes
                        handleContact(Create,false,partnerAccountDetails,u,partnerContactDetails,attributes,partnerContactAccessAllMap,partnerAccountAccessAllMap,bIsPartnercode);
                        //handle contact details like updating Contact fields and then create user.    
            }else{
                //create a contact in handle Contact Method. and also need to create Contact Access and features and then user and assign permission sets.
                handleContact(Create,true,partnerAccountDetails,u,partnerContactDetails,attributes,partnerContactAccessAllMap,partnerAccountAccessAllMap,bIsPartnercode); 
            }   
        }else{
            //Code part ot handle Updating user attributes and permission sets.
            System.debug('Method to execute if user is present and what actions need to perform');
            handleContact(Create,false,partnerAccountDetails,u,partnerContactDetails,attributes,partnerContactAccessAllMap,partnerAccountAccessAllMap,bIsPartnercode);
        }
    }
    
    //Check Contact Location Details and If exsisting contact belongs to the location code that we recieved in the SAML token
    private void handleContact(boolean create,boolean createContact ,Account partnerAccount, User u,contact partnerContact ,Map<String, String> attributes,Map<string,IAM_Contact_Provisioning__c> partnerContactAccessMap,Map<String,IAM_Application__c> partnerAccountAccessMap, Boolean bIsPartnercode) {
        
        contact partnerContactToSetAttributes;
        //Boolean isCreateUser=false;
        Boolean partneContactisInactive=false;
        Boolean bUpdateWorkGrp = False;
        Map<String,Boolean>reclaimTracker= new Map<String,Boolean>();
        if(partnerAccount.Id != partnerContact.AccountId){
            bUpdateWorkGrp = True;
        }
        
        if(partnerContact.id!=null){
            System.debug('Printing not a new Contact');
            partnerContactToSetAttributes=new Contact(id=partnerContact.id);
            partnerContactToSetAttributes.IAM_Work_Group_Id__c = partnerContact.IAM_Work_Group_Id__c;
            if(bUpdateWorkGrp){
                partnerContactToSetAttributes.IAM_Work_Group_Id__c=partnerAccount.Location__c+System.Label.IAM_WorkGrpAddition_Symbol;
            }
            if(partnerContact.IAM_Contact_Status__c=='Inactive'){
                partneContactisInactive=True;
            }
        }else{
            System.debug('Printing a new Contact');
            partnerContactToSetAttributes = new Contact();
            //isCreateUser=True;
            partnerContactToSetAttributes.IAM_Work_Group_Id__c=partnerAccount.Location__c+System.Label.IAM_WorkGrpAddition_Symbol;
        }
        
        partnerContactToSetAttributes.Accountid=partnerAccount.id;
        if(attributes.ContainsKey('givenname')){
            partnerContactToSetAttributes.FirstName=attributes.get('givenname');         
        }
        if(attributes.containsKey('sn')){
            partnerContactToSetAttributes.LastName=attributes.get('sn');
        }
        if(attributes.containsKey('email')){
            partnerContactToSetAttributes.email=attributes.get('email');
        }
        if(attributes.containsKey('uid')){
            partnerContactToSetAttributes.Username__c=attributes.get('uid');
            partnerContactToSetAttributes.IAM_Ext_Legacy_Uid__c=attributes.get('uid');
        }
        partnerContactToSetAttributes.IAM_Contact_Status__c='Active';
        partnerContactToSetAttributes.CMI_Contact_Type__c='Secondary';
        //partnerContactToSetAttributes.IAM_ABO_Code__c=partnerAccount.IAM_ABO_Code_Formula__c;
        //partnerContactToSetAttributes.IAM_Contact_source__c='Penske';//Since penske federation.
        if(attributes.get('email').contains('penske')){
        partnerContactToSetAttributes.IAM_Contact_source__c='Penske';//Since penske federation.
        }
        //Start For Ryder
        if(attributes.get('uid').containsIgnoreCase('ryd')){
        partnerContactToSetAttributes.IAM_Contact_source__c='Ryder';//Since Ryder federation.
        }
        //End for Ryder
        partnerContactToSetAttributes.Language_Preferences__c='English';
        partnerContactToSetAttributes.IAM_Product_Group_Access__c='PGA03';
        partnerContactToSetAttributes.RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        partnerContactToSetAttributes.IAM_Legacy_User__c=True;
        partnerContactToSetAttributes.IAM_From_JIT_Execution__c=True;
        if(partnerContact.id!=null){
            Map<String,String> contactAttributesToSet=getcontactAttributes(partnerContact);
            if(contactAttributesToSet.ContainsKey('IAM_Applications__c')){
                partnerContactToSetAttributes.IAM_Applications__c=contactAttributesToSet.get('IAM_Applications__c');
            }
            if(contactAttributesToSet.ContainsKey('IAM_Application_Roles__c')){
                partnerContactToSetAttributes.IAM_Application_Roles__c=contactAttributesToSet.get('IAM_Application_Roles__c');
            }   
            if(contactAttributesToSet.ContainsKey('IAM_swregexpire__c')){
                partnerContactToSetAttributes.IAM_swregexpire__c=contactAttributesToSet.get('IAM_swregexpire__c');
            }
            if(contactAttributesToSet.ContainsKey('IAM_Qsolexpiration__c')){
                partnerContactToSetAttributes.IAM_Qsolexpiration__c=contactAttributesToSet.get('IAM_Qsolexpiration__c');
            }
            //update partnerContactToSetAttributes;
            id jobId=System.enqueueJob(new IAM_PartnerJIT_Contact_QueueableUpdate(u,partnerAccount,partnerContactToSetAttributes,partnerAccountAccessMap,partnerContactAccessMap,attributes,bIsPartnercode,bUpdateWorkGrp));
        }else{
            //since we are creating a new contact there won't be any new contact provisionings. so we can hard code the vales.
            if(bIsPartnercode){
                partnerContactToSetAttributes.IAM_Applications__c='cn=quickserve_cihr,ou=app_quickserve,ou=application,dc=cummins,dc=com|cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com|cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com|cn=DBU_DN_DEALER_USERS,ou=App_DBU_commerce,ou=application,dc=cummins,dc=com';
                partnerContactToSetAttributes.IAM_Application_Roles__c='QSOL CIHR,Service Training User,Technician,Dealer User';
            }else{
                partnerContactToSetAttributes.IAM_Applications__c='cn=quickserve_cihr,ou=app_quickserve,ou=application,dc=cummins,dc=com|cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com|cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com';
                partnerContactToSetAttributes.IAM_Application_Roles__c='QSOL CIHR,Service Training User,Technician';
            }          
            partnerContactToSetAttributes.IAM_is_Member_of__c='';
            partnerContactToSetAttributes.IAM_Qsolexpiration__c=partnerAccountAccessMap.get(APP_NAME_QSOL).IAM_Qsolexpiration__c;
            System.debug('partnerContactToSetAttributes--->'+partnerContactToSetAttributes);
            insert partnerContactToSetAttributes;
            if(!Test.isRunningTest()){
                System.debug('inside if for calling queueable class--->');
                id jobId= System.enqueueJob(new IAM_Reclaim_Queable_API_Class(partnerContactToSetAttributes));
                //IAM_Reclaim_Queable_API_Class.reclaim_LDAP_API_calls(partnerContactToSetAttributes.Username__c,partnerContactToSetAttributes.USername__C,partnerContactToSetAttributes.email,partnerContactToSetAttributes.id,'Insert',reclaimTracker);
            } 
        }
        System.debug('partnerContactToSetAttributes.Id--->'+partnerContactToSetAttributes.Id);
        if(partnerContactToSetAttributes!=null){
            handleUser(create,u,attributes,partnerAccount,partnerContactToSetAttributes,partnerAccountAccessMap,partnerContactAccessMap,bIsPartnercode);
        }
    }
    
    //Throw Custom handle Exception.
    private class JitException extends Exception{}
    
    private void handleUser(boolean isCreateUser, User u, Map<String, String> attributes,Account partnerAccount,Contact partnerContact,Map<String,IAM_Application__c> partnerAccountAccessMap,Map<String,IAM_contact_provisioning__c> partnerContactAccessMap, Boolean bIsPartnercode) {
       
       User partnerUser ;
       
       if(isCreateUser){
           partnerUser = new User();
       }else{
           partnerUser = new User(id=u.id);
       }
       if(attributes.ContainsKey('givenname')){
            partnerUser.FirstName=attributes.get('givenname');         
        }
        if(attributes.containsKey('sn')){
            partnerUser.LastName=attributes.get('sn');
        }
       if(attributes.containsKey('email')){
            partnerUser.Email=attributes.get('email');
        }
       partnerUser.Contactid=partnerContact.id;
       if(attributes.containsKey('uid')){
        partnerUser.Username=attributes.get('uid')+'@cmiuser.com';
        partnerUser.FederationIdentifier=attributes.get('uid');
        partnerUser.IAM_UID__c=attributes.get('uid');
        partnerUser.IAM_OAM_Federation_ID__c=attributes.get('uid');
       }
       
       partnerUser.CompanyName=partnerAccount.Name;
       if(partnerUser.LastName.length()>=4){
            partnerUser.alias=partnerUser.FirstName.substring(0,1)+''+partnerUser.LastName.substring(0,4);
       }else if(partnerUser.LastName.length()<=2&&partnerUser.FirstName.length()<=2){
            partnerUser.alias=partnerUser.FirstName+''+partnerUser.LastName;
       }else{
            partnerUser.alias=partnerUser.FirstName.substring(0,4-partnerUser.LastName.length())+''+partnerUser.LastName;
       }
       partnerUser.isActive=True;
       partnerUser.EmailEncodingKey='UTF-8';
       partnerUser.LocaleSidKey='en_US';
       partnerUser.LanguageLocaleKey='en_US';
       partnerUser.TimeZoneSidKey='America/New_York';
       partnerUser.IAM_Abocode__c=partnerAccount.IAM_ABO_Code_Formula__c;
       partnerUser.IAM_Customercode__c=partnerAccount.CSS_DistributorCode__c;
       partnerUser.IAM_SP_Code__c=partnerAccount.IAM_Service_Provider_Code__c;
       //PartnerUSer.IAM_Fleetcode__c=partnerAccount.IAM_Service_Provider_Code__c;
       //partnerUser.Fleet_Code__c=partnerAccount.IAM_Service_Provider_Code__c;
       partnerUser.IAM_Distributorcode__c=partnerAccount.CSS_DistributorCode__c;
       partnerUser.IAM_Distributorbranchcode__c=partnerAccount.CSS_DBCode__c;
       partnerUser.Department=partnerAccount.IAM_Service_Provider_Code__c;
       partnerUser.Product_Group_Access__c=partnerContact.IAM_Product_Group_Access__c;
       partnerUser.phone=partnerAccount.Phone;
       partnerUser.Work_Group_Name__c=partnerAccount.IAM_Service_Provider_Code__c;
       partnerUser.User_Location__c=partnerAccount.Location__c;
       partnerUser.UserGroup__c='EDS_USER';
       if(String.isNotEmpty(partnerContact.IAM_Work_Group_Id__c)){
            partnerUser.IAM_WorkGroup_id__c=partnerContact.IAM_Work_Group_Id__c;
            partnerUSer.CSS_User_MultiLocValues__c=partnerContact.IAM_Work_Group_Id__c.replace('|',';');
       }else{
           partnerUser.IAM_WorkGroup_id__c=partnerAccount.Location__c;
           partnerUser.CSS_User_MultiLocValues__c=partnerAccount.Location__c;
       }
       partnerUser.IAM_UserDn__c='uid='+partnerContact.Username__c+',ou=external,ou=people,dc=cummins,dc=com'; 
       partnerUser.Street=partnerAccount.BillingStreet;
       partnerUser.City=partnerAccount.BillingCity;
       partnerUser.Country=partnerAccount.BillingCountry;
       partnerUser.PostalCode=partnerAccount.BillingPostalCode;
       partnerUSer.IAM_Qsolexpiration__c=partnerContact.IAM_Qsolexpiration__c;
       partnerUser.IAM_swregExpire__c=partnerContact.IAM_swregExpire__c;
       partnerUser.IAM_WWSPS_Region__c=partnerAccount.IAM_WWSPS_Regions__c;
       partnerUser.IAM_Type_of_Location__c=partnerAccount.Type;
       /*if(partnerContact.IAM_Applications__c!=''){
           partnerUser.IAM_Applicationgroups__c=partnerContact.IAM_Applications__c;
       }else{
            partnerUser.IAM_Applicationgroups__c='cn=quickserve_cihr,ou=app_quickserve,ou=application,dc=cummins,dc=com|cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com|cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com';
       }*/
       if(bIsPartnercode){
        partnerUser.IAM_Applicationgroups__c='cn=quickserve_cihr,ou=app_quickserve,ou=application,dc=cummins,dc=com|cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com|cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com|cn=DBU_DN_DEALER_USERS,ou=App_DBU_commerce,ou=application,dc=cummins,dc=com';
        partnerUser.IAM_Application_Roles__c='QSOL CIHR,Service Training User,Technician,Dealer User';
        }else{
        partnerUser.IAM_Applicationgroups__c=partnerContact.IAM_Applications__c;
        partnerUser.IAM_Application_Roles__c=partnerContact.IAM_Application_Roles__c;
       }
       /*if(partnerContact.IAM_Application_Roles__c!=''){
           partnerUser.IAM_Application_Roles__c=partnerContact.IAM_Application_Roles__c;
       }else{
          partnerUser.IAM_Application_Roles__c='QSOL CIHR,Service Training User,Technician'; 
       }*/
       
       
       
       if(isCreateUser){
           System.debug('Printing User creation route');
           partnerUser.profileID=[select id from Profile where name='IAM_Partner_User'].id;
           //Need to create the User access feature records.
            if(!partnerContactAccessAllMap.isEmpty()){
                //Start - Ryder-Cumpas changes
                if(attributes.get('uid').containsIgnoreCase('ryd') && (!partnerContactAccessAllMap.ContainsKey(APP_NAME_QSOL)||!partnerContactAccessAllMap.ContainsKey(APP_NAME_CST)||!partnerContactAccessAllMap.ContainsKey(APP_NAME_EDS))){
                    createContactProvisionings(partnerUser,partnerContact,partnerAccountAccessMap,partnerContactAccessMap,attributes,bIsPartnercode);
                }else if(!partnerContactAccessAllMap.ContainsKey(APP_NAME_QSOL)||!partnerContactAccessAllMap.ContainsKey(APP_NAME_CST)||!partnerContactAccessAllMap.ContainsKey(APP_NAME_EDS)){
                    createContactProvisionings(partnerUser,partnerContact,partnerAccountAccessMap,partnerContactAccessMap,attributes,bIsPartnercode);
                }
                //End - Ryder-Cumpas changes
            }else{
                createContactProvisionings(partnerUser,partnerContact,partnerAccountAccessMap,partnerContactAccessMap,attributes,bIsPartnercode);
            }
           //insert partnerUser;
       }else{
           System.debug('Printing User Updatation route');
          /* if(partnerUser!=null){
            if(!partnerContactAccessAllMap.isEmpty()){
                if(!partnerContactAccessAllMap.ContainsKey(APP_NAME_QSOL)||!partnerContactAccessAllMap.ContainsKey(APP_NAME_CST)||!partnerContactAccessAllMap.ContainsKey(APP_NAME_EDS)){
                    createContactProvisionings(partnerUser,partnerContact,partnerAccountAccessMap,partnerContactAccessMap);
                }
            }else{
                createContactProvisionings(partnerUser,partnerContact,partnerAccountAccessMap,partnerContactAccessMap);
            }
           }*/
           System.debug('Printing Update user'+partnerUser);
           update partnerUser;
       }
       
       //Making a future callout to CST System to register user in CST application.
       if(partnerContactAccessAllMap.ContainsKey(APP_NAME_CST)){
            System.debug('Entered CST Application Call');
            Set<id> cstAppid=new Set<id>{partnerContactAccessAllMap.get(APP_NAME_CST).id}; 
            IAM_CSTUserOutboundHelper.CstOutboundCall(cstAppid);
       }
		System.debug('partnerUser--->'+partnerUser);
        System.debug('u--->'+u);
        System.debug('userToReturn--->'+userToReturn);
       u=partnerUser;
       userToReturn=partnerUser; 
    }
    
    //Assign Permission Sets
    public void assignPermissionSets(String AssignieId){
        List<PermissionSet> permissionSetToAssign=[SELECT Id,Label,Name FROM PermissionSet where Label=:APP_NAME_EDS OR Label=:APP_NAME_QSOL OR label=:APP_NAME_CST];
        
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
        
        for(PermissionSet pid:permissionSetToAssign){
            PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = pid.id, AssigneeId = AssignieId);
            permissionSetList.add(psa);
        }
        
        System.debug('Prinitng number of permissions getting assigned'+permissionSetList);
        //Database.SaveResult[] srList=Database.Insert(permissionSetList,false);
    }
    
    //Code to handle the Account Validation in IAM for partner users.
    public Boolean handleAccountValidation(boolean create, User u, Map<String, String> attributes) {
        
        Boolean isValidPartnerLocation=false;
        Account partnerLocationDetails=getPartnerAccountDetails(attributes);
        if(partnerLocationDetails!=null){
            isValidPartnerLocation=True;
        }
        return isValidPartnerLocation;
    }
    
    //Code to check if the location has access to which application.
    private Map<string,IAM_Application__c> handleAccountAccessValidation(List<IAM_Application__c> accountAccessList, Map<String, String> attributes){
        
        Map<string,IAM_Application__c> accountAccessValidationMap = new Map<string,IAM_Application__c>();
        
        if(accountAccessList!=null){
            if(!accountAccessList.isEmpty()){
                for(IAM_Application__c app:accountAccessList){
                    if(app.IAM_Application_Name__c==APP_NAME_QSOL&&app.IAM_Subscription_Name__c=='QuickServe Online EBU'){
                        accountAccessValidationMap.put(APP_NAME_QSOL,app);
                    }
                    if(app.IAM_Application_Name__c==APP_NAME_EDS){
                        accountAccessValidationMap.put(APP_NAME_EDS,app);
                    }
                    if(app.IAM_Application_Name__c==APP_NAME_CST){
                        accountAccessValidationMap.put(APP_NAME_CST,app);
                    }
                    //start - Ryder-Cupmas changes
                    /*if(attributes.get('uid').containsIgnoreCase('ryd') && app.IAM_Application_Name__c==APP_NAME_CUMPAS){
                       accountAccessValidationMap.put(APP_NAME_CUMPAS,app);
                    }*/
                    //end - Ryder-Cumpas changes
                }
            }
        }
        System.debug('Printing Account access validation Map'+accountAccessValidationMap);
        return accountAccessValidationMap;
    }
    
    //Perfom Contact access validation
    public Static Map<String,IAM_Contact_Provisioning__c> handleContactAccessValidation(List<IAM_Contact_Provisioning__c> contactAccessList, Map<String, String> attributes, Boolean bIsPartnercode){
        
        Map<string,IAM_Contact_Provisioning__c> contactAccessValidationMap = new Map<String,IAM_Contact_Provisioning__c>();
        //List<IAM_Contact_Provisioning__c> conProvCumpas = new List<IAM_Contact_Provisioning__c>();
        
        if(!contactAccessList.isEmpty()){
            for(IAM_Contact_Provisioning__c conProv : contactAccessList){
                if(conProv.IAM_Application_Name__c==APP_NAME_QSOL&&conProv.IAM_Subscription_Name__c=='QuickServe Online EBU'){
                    contactAccessValidationMap.put(APP_NAME_QSOL,conProv);
                }
                if(conProv.IAM_Application_Name__c==APP_NAME_EDS){
                    contactAccessValidationMap.put(APP_NAME_EDS,conProv);
                }
                if(conProv.IAM_Application_Name__c==APP_NAME_CST){
                    contactAccessValidationMap.put(APP_NAME_CST,conProv);
                }
                //start - Ryder-Cupmas changes
                /*if(attributes.get('uid').containsIgnoreCase('ryd') && conProv.IAM_Application_Name__c==APP_NAME_CUMPAS && bIsPartnercode){
                    //contactAccessValidationMap.put(APP_NAME_CUMPAS,conProv);
                    //conProv.IAM_Cumpas_Modularity__c =System.Label.IAM_RyderCumpas_Modules_Label;
                    //conProv.IAM_Role__c = CUMPAS_ROLE_DEALER;
                    //conProvCumpas.add(conProv);
                    contactAccessValidationMap.put(APP_NAME_CUMPAS,conProv);
                }*/
                
            }
            /*if(conProvCumpas.size() > 0){
                update conProvCumpas;
            }*/
            //end - Ryder-Cumpas changes
        }

        return contactAccessValidationMap;
    }
    
    //Method to Handle Account Access and Features.
     public void createAccountAccessFeatures(user partnerUser,Account partnerAccount,Contact partnerContact,Map<String,IAM_Application__c> accountAppsMap,Map<String,IAM_Contact_Provisioning__c> contactAppMap, Map<String, String> attributes, Boolean bIsPartnercode){
        List<IAM_Application__c> appFeatureToInsert=new List<IAM_Application__c>();

        if(!accountAppsMap.ContainsKey(APP_NAME_QSOL)){
            IAM_Application__c qsolApp=setVariablesForAccountAccess(APP_NAME_QSOL,QSOL_ROLE_CIHR,partnerAccount);
            appFeatureToInsert.add(qsolApp);
            partnerAccountAccessAllMap.put(APP_NAME_QSOL,qsolApp);
        }
        if(!accountAppsMap.ContainsKey(APP_NAME_EDS)){
            IAM_Application__c edsApp=setVariablesForAccountAccess(APP_NAME_EDS,EDS_ROLE_TECHNICIAN,partnerAccount);
            appFeatureToInsert.add(edsApp);
            partnerAccountAccessAllMap.put(APP_NAME_EDS,edsApp);
        }
        if(!accountAppsMap.ContainsKey(APP_NAME_CST)){
            IAM_Application__c cstApp=setVariablesForAccountAccess(APP_NAME_CST,CST_ROLE_TRAINING,partnerAccount);
            appFeatureToInsert.add(cstApp);
            partnerAccountAccessAllMap.put(APP_NAME_CST,cstApp);
        }
         //Start - Ryder-Cumpas changes
        /*if(attributes.get('uid').containsIgnoreCase('ryd') && !accountAppsMap.ContainsKey(APP_NAME_CUMPAS) && bIsPartnercode){
            IAM_Application__c cumpasApp=setVariablesForAccountAccess(APP_NAME_CUMPAS,CUMPAS_ROLE_DEALER,partnerAccount);
            appFeatureToInsert.add(cumpasApp);
            partnerAccountAccessAllMap.put(APP_NAME_CUMPAS,cumpasApp);
        }*/
         System.debug('Account access insert list--->'+appFeatureToInsert);
		//End - Ryder-Cumpas changes
        if(!appFeatureToInsert.isEmpty()){
            Database.SaveResult[] srList=Database.Insert(appFeatureToInsert,false);
            System.debug('Printing Debug Statement Account access insert'+srList);
        }
    }

    private IAM_Application__c setVariablesForAccountAccess(String applicationName,String roleName,Account partnerAccount){

        IAM_Application__c appNew= new IAM_Application__c();
        appNew.IAM_Application_Name__c=applicationName;
        appNew.IAM_Role__c=roleName;
        appNew.IAM_Status__c='Active';
        appNew.IAM_Subscription_Start_Date__c=System.today();
        appNew.IAM_Subscription_End_Date__c=System.today().addDays(36500);
        appNew.IAM_Account_Name__c=partnerAccount.id;
        appNew.IAM_Customer_Code__c=partnerAccount.IAM_Service_Provider_Code__c;
        appNew.IAM_Free_Subscription__c=false;
        //Start - Ryder-Cumpas changes
        if(applicationName == APP_NAME_CUMPAS){
            appNew.IAM_Free_Subscription__c=True;
            appNew.IAM_Cumpas_Modularity__c=System.Label.IAM_RyderCumpas_Modules_Label;
        }
        //End - Ryder-Cumpas changes
        appNew.IAM_From_JIT_Execution__c=true;
        if(applicationName==APP_NAME_QSOL||applicationName==APP_NAME_EDS){
            appNew.IAM_Subscription_Name__c='QuickServe Online EBU';
            appNew.IAM_Qsolexpiration__c=String.valueOf(appNew.IAM_Subscription_End_Date__c.day())+'-'+monthToMonthNameMap.get(appNew.IAM_Subscription_End_Date__c.month())+'-'+String.valueOf(appNew.IAM_Subscription_End_Date__c.year())+'EBUACTIVE';
        }else if(applicationName==APP_NAME_CST){
            appNew.IAM_Subscription_Name__c=APP_NAME_CST;
        }
        
        return appNew;
    }

    //Handle contact access feature record creation.
    public static void createContactProvisionings(user partnerUser,Contact partnerContact,Map<String,IAM_Application__c> accountAppsMap,Map<String,IAM_Contact_Provisioning__c> contactAppMap, Map<String, String> attributes, Boolean bIsPartnercode){
        
        System.debug('Printing User details during check'+partnerUser);
        System.debug('Printing Contact details during check'+partnerContact);
        
        List<IAM_Contact_Provisioning__c> conAppFeatureToCreateList= new List<IAM_Contact_Provisioning__c>();
        
        if(!contactAppMap.ContainsKey(APP_NAME_QSOL)){
            if(accountAppsMap.ContainsKey(APP_NAME_QSOL)){
                conAppFeatureToCreateList.add(setContactProVariables(APP_NAME_QSOL,QSOL_ROLE_CIHR,partnerContact,partnerUser,accountAppsMap.get(APP_NAME_QSOL)));
                
            }   
        }
        
        if(!contactAppMap.containsKey(APP_NAME_EDS)){
            if(accountAppsMap.ContainsKey(APP_NAME_EDS)){
                conAppFeatureToCreateList.add(setContactProVariables(APP_NAME_EDS,EDS_ROLE_TECHNICIAN,partnerContact,partnerUser,accountAppsMap.get(APP_NAME_EDS)));
            }
        }
        
        if(!contactAppMap.containsKey(APP_NAME_CST)){
            if(accountAppsMap.ContainsKey(APP_NAME_CST)){
                conAppFeatureToCreateList.add(setContactProVariables(APP_NAME_CST,CST_ROLE_TRAINING,partnerContact,partnerUser,accountAppsMap.get(APP_NAME_CST)));
                //Need to make a callout to CST application to get the Servie Training ID.
            }
        }
        
        //Start - Ryder-Cumpas changes
        /*if(attributes.get('uid').containsIgnoreCase('ryd') && !contactAppMap.ContainsKey(APP_NAME_CUMPAS) && bIsPartnercode){
            if(accountAppsMap.ContainsKey(APP_NAME_CUMPAS)){
                conAppFeatureToCreateList.add(setContactProVariables(APP_NAME_CUMPAS,CUMPAS_ROLE_DEALER,partnerContact,partnerUser,accountAppsMap.get(APP_NAME_CUMPAS)));
                //Need to make a callout to CST application to get the Servie Training ID.
            }
        }*/
        //End - Ryder-Cumpas changes
        System.debug('Printing ContactFeatures that are going to insert'+conAppFeatureToCreateList);
        if(!conAppFeatureToCreateList.isEmpty()){
            Database.SaveResult[] conAppSaveResultList= Database.Insert(conAppFeatureToCreateList,false);    
        }
    }
    
    //declare variables for Contact Access feature.
    public Static IAM_Contact_Provisioning__c setContactProVariables(String appName,String appRole,Contact partnerContact,user partnerUser,IAM_Application__c accountApp){
        System.debug('Printing User details during Creation'+partnerUser);
        System.debug('Printing Contact details during creation'+partnerContact);
        
        IAM_Contact_Provisioning__c conProv = new IAM_Contact_Provisioning__c();
        conProv.IAM_Application_Name__c=appName;
        conProv.IAM_Role__c=appRole;
        conProv.IAM_Contact__c=partnerContact.id;
        conProv.IAM_Status__c='Active';
        conProv.IAM_User__c=partnerUser.id;
        conProv.IAM_Account_Application__c=accountApp.id;
        conProv.IAM_Start_Date__c=accountApp.IAM_Subscription_Start_Date__c;
        conProv.IAM_End_Date__c=accountApp.IAM_Subscription_End_Date__c;
        conProv.IAM_userId__c=partnerContact.Username__c;
        conProv.IAM_Subscription_Name__c=accountApp.IAM_Subscription_Name__c;
        conProv.IAM_Qsolexpiration__c=accountApp.IAM_Qsolexpiration__c;
        conProv.IAM_From_JIT_Execution__c=True;
        conProv.RecordTypeid=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appNAme).getRecordTypeId();
        //Start - Ryder-Cumpas changes
        if(appName == APP_NAME_CUMPAS){
            conProv.IAM_Cumpas_Modularity__c=System.Label.IAM_RyderCumpas_Modules_Label;
        }
        //End - Ryder-Cumpas changes
        return conProv;
    }
    
    //Method to get Account details back for a specific location recieved in SAML.
    private Account getPartnerAccountDetails(Map<String,String> attributes){
        Account partnerAccount= new Account();
        if(attributes.containsKey('location_num')){
            System.debug('Printing the location code from SAML Token'+attributes.get('location_num'));
            if(!String.isEmpty(attributes.get('location_num'))){
                List<Account> partnerAccountList=[SELECT id
                                                   , Name
                                                   , Type
                                                   , IAM_Service_Provider_Code__c
                                                   , IAM_Partner_Location_Code__c
                                                   , Location__c
                                                   , CSS_DBCode__c
                                                   , CSS_DistributorCode__c
                                                   , CSS_DealerCode__c
                                                   , IAM_WWSPS_Regions__c
                                                   , IAM_ABO_Code_Formula__c
                                                   , phone
                                                   , BillingStreet
                                                   , BillingCity
                                                   , BillingCountry
                                                   , BillingState
                                                   , BillingPostalCode
                                                   , (SELECT id,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c,IAM_Subscription_Name__c,IAM_Qsolexpiration__c,IAM_Subscription_Start_Date__c,IAM_Subscription_End_Date__c FROM Applications__r WHERE IAM_Status__c='Active')
                                                     FROM Account
                                                     WHERE IAM_Partner_Location_Code__c=:attributes.get('location_num') LIMIT 1];    
                if(!partnerAccountList.isEmpty()){
                    System.debug('Printing Account Details'+partnerAccountList[0]);
                    partnerAccount=partnerAccountList[0];
                }
            }
        }
        System.debug('Printing Partner Account Details#####'+partnerAccount);
        System.debug('Printing Partner Account Application Access####'+partnerAccount.Applications__r);
        return partnerAccount;
    }
    
    private Contact getPartnerContactDetails(String FederationIdentifier){
        Contact partnerContact=new Contact();
        
        List<Contact> contactList= [SELECT Id
                                         , FirstName
                                         , LastName
                                         , Email
                                         , Username__c
                                         , IAM_Legacy_User__c
                                         , IAM_Ext_Legacy_Uid__c
                                         , IAM_Promotion__c
                                         , IAM_Application_Roles__c
                                         , IAM_Applications__c
                                         , IAM_Qsolexpiration__c
                                         , IAM_swregexpire__c
                                         , IAM_Contact_Status__c
                                         , CMI_Contact_Type__c
                                         , IAM_Work_Group_Id__c
                                         , Accountid,Account.Name,Account.CSS_DBCode__c,Account.CSS_DealerCode__c,Account.CSS_DistributorCode__c,Account.IAM_Service_Provider_Code__c,Account.Type,Account.IAM_ABO_Code_Formula__c,Account.IAM_WWSPS_Regions__c
                                         , (SELECT id,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c,IAM_Qsolexpiration__c,IAM_Subscription_Name__c,IAM_Cumpas_Modularity__c FROM Contact_Provisionings__r WHERE IAM_Status__c='Active')
                                         FROM Contact
                                         WHERE Username__c=:FederationIdentifier LIMIT 1];
        if(!contactList.isEmpty()){
            partnerContact=contactList[0];
        }
        System.debug('Printing partner Contact details#####'+partnerContact);
        return partnerContact;
    }

    //Method to get Users details for Exsisting User.   
    private User getPartnerUserDetails(String userId){
        User partnerUser=new User();
        List<User> userList=[SELECT id
                                  , Username
                                  , Email
                                  , FirstName
                                  , LastName
                                  , FederationIdentifier
                                  , IAM_UID__c
                                  , IAM_Application_Roles__c
                                  , IAM_Abocode__c
                                  , IAM_Applicationgroups__c
                                  , IAM_Customercode__c
                                  , IAM_Dealercode__c
                                  , IAM_Distributorbranchcode__c
                                  , IAM_Distributorcode__c
                                  , IAM_Fleetcode__c
                                  , IAM_HR_BMS_Instance_Name__c
                                  , IAM_HR_Customer_Number__c
                                  , IAM_Product_Certification__c
                                  , IAM_Promotion__c
                                  , IAM_Qsolexpiration__c
                                  , IAM_SP_Code__c
                                  , IAM_swregexpire__c
                                  , IAM_is_Member_of__c
                                  , IAM_HR_Language__c
                                  , IAM_Location_Modular_Access__c
                                  , IAM_Movex_Customer_Code__c
                                  , IAM_NpbuDiagExpire__c   
                                  , Product_Group_Access__c
                                  , IAM_WWSPS_Region__c
                                  , IAM_Type_of_Location__c
                                  , IAM_UserDn__c
                                  , IAM_WorkGroup_id__c
                                  , isActive
                                  , Contact.FirstName,Contact.LastName,Contact.Email,Contact.Username__c,Contact.IAM_Legacy_User__c,Contact.IAM_Ext_Legacy_Uid__c,  Contact.CMI_Contact_Type__c,Contact.IAM_Contact_Status__c,Contact.IAM_Applications__c,Contact.IAM_Application_Roles__c,Contact.IAM_is_Member_of__c,Contact.Language_Preferences__c,Contact.IAM_NpbuDiagExpire__c,Contact.IAM_Product_Group_Access__c,Contact.IAM_Qsolexpiration__c,Contact.IAM_Qsolview__c,Contact.IAM_Promotion__c,Contact.IAM_swregexpire__c,Contact.IAM_Work_Group_Id__c
                                  , Contact.Account.id,Contact.Account.Name,Contact.Account.IAM_Service_Provider_Code__c,Contact.Account.Type,Contact.Account.IAM_ABO_Code_Formula__c,Contact.Account.IAM_WWSPS_Regions__c,Contact.Account.CSS_DealerCode__c,Contact.Account.CSS_DBCode__c,Contact.Account.CSS_DistributorCode__c,Contact.Account.EBU_Channel_of_Distribution__c,Contact.Account.CSS_FleetCode__c
                                  FROM User
                                  WHERE id=:userId LIMIT 1];
                                  
        if(!userList.isEmpty()){
            partnerUser=userList[0];
        }
        System.debug('Printing Partner User details#####'+partnerUser);
        return partnerUser;
    }
    
    public Static Map<string,string> getcontactAttributes(Contact partnerContact){
        
        String ApplicationGroups='';
        String ApplicationRoles='';
        String qsolExpiration='';
        String swregExpiration='';
        
        Map<String,String> contactAttributes= new Map<String,String>();
        List<IAM_Application_Groups__c> lstAppGroup = IAM_Application_Groups__c.getall().values();//getting all the custom settings.
        Map<String,IAM_Application_Groups__c> appGrps= new Map<String,IAM_Application_Groups__c>();
        for(IAM_Application_Groups__c apgrp: lstAppGroup){
            appGrps.put((apgrp.IAM_Application_Name__c+apgrp.IAM_Role_Name__c).toUpperCase(),apgrp);   
        }
        
        Map<id,List<IAM_Contact_Provisioning__c>> toLoop= new Map<id,List<IAM_Contact_Provisioning__c>>();
        
        List<IAM_Contact_Provisioning__c> conProv=[Select id,IAM_Application_Name__c,IAM_Role__c,IAM_Qsolexpiration__c,IAM_swregexpire__c,IAM_Contact__c,IAM_Account_Application__r.IAM_Role__c,IAM_Account_Application__r.IAM_QSOLExpiration__c,IAM_Account_Application__r.IAM_swregexpire__c from IAM_Contact_Provisioning__c where IAM_Status__c='Active' and IAM_Contact__c=:partnerContact.id];
        
                    for(IAM_Contact_Provisioning__c cps:conProv){
                        if(appGrps.ContainsKey((cps.IAM_Application_Name__c+cps.IAM_Role__c).ToUpperCase())){
                            if(cps.IAM_Application_Name__c!='QuickServe Online'){
                                if(!String.isBlank(appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Role__c).ToUpperCase()).IAM_DN_value__c)){
                                    ApplicationGroups=ApplicationGroups+'|'+appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Role__c).ToUpperCase()).IAM_DN_value__c;
                                }
                                if(!String.isBlank(appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Role__c).ToUpperCase()).IAM_Role_Name__c)){
                                    ApplicationRoles=ApplicationRoles+','+ appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Role__c).ToUpperCase()).IAM_Role_Name__c;
                                }
                            }else if(cps.IAM_Application_Name__c=='QuickServe Online'){
                                if(!String.isBlank(appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Account_Application__r.IAM_Role__c).ToUpperCase()).IAM_DN_value__c)){
                                    ApplicationGroups=ApplicationGroups+'|'+appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Account_Application__r.IAM_Role__c).ToUpperCase()).IAM_DN_value__c;
                                }
                                if(!String.isBlank(appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Account_Application__r.IAM_Role__c).ToUpperCase()).IAM_Role_Name__c)){
                                    ApplicationRoles=ApplicationRoles+','+ appGrps.get((cps.IAM_Application_Name__c+cps.IAM_Account_Application__r.IAM_Role__c).ToUpperCase()).IAM_Role_Name__c;
                                }
                            }
                        }
                        
                        if(cps.IAM_Application_Name__c == System.Label.IAM_AppName_QSOL){
                            if(String.isNotEmpty(cps.IAM_Account_Application__r.IAM_Qsolexpiration__c)){
                                system.debug('====Inside qsolExpiration check===02');
                                qsolExpiration = qsolExpiration +'|'+cps.IAM_Account_Application__r.IAM_Qsolexpiration__c;
                            }
                            
                        }
                        
                        if(cps.IAM_Application_Name__c == System.Label.IAM_Guidanz_Mobile_App_Name && String.isNotBlank(cps.IAM_Account_Application__r.IAM_swregexpire__c)){
                            system.debug('===Inside swregexpire on contact===');
                            if(!String.isBlank(cps.IAM_Account_Application__r.IAM_swregexpire__c)){
                                swregExpiration =   swregExpiration + '|' + cps.IAM_Account_Application__r.IAM_swregexpire__c;
                            }
                        }
                        
                        if(cps.IAM_Application_Name__c == Label.IAM_App_GuidanzMobileFieldTest){
                            system.debug('===Inside swregexpire on contact FT===');
                            if(String.isNotBlank(cps.IAM_swregexpire__c)){
                                swregExpiration =   swregExpiration + '|' + cps.IAM_swregexpire__c;
                            }
                        }
                    }
                    
                    if(String.isNotBlank(ApplicationGroups)){
                        contactAttributes.put('IAM_Applications__c',ApplicationGroups.removeEnd('|').removeStart('|'));
                    }
                    
                    if(String.isNotBlank(ApplicationRoles)){
                        contactAttributes.put('IAM_Application_Groups__c',ApplicationRoles.removeEnd(',').removeStart(','));
                    }
                    
                    if(String.isNotBlank(qsolExpiration)){
                        contactAttributes.put('IAM_Qsolexpiration__c',qsolExpiration.removeEnd('|').removeStart('|'));
                    }
                    
                    if(String.isNotBlank(swregExpiration)){
                        contactAttributes.put('IAM_swregexpire__c',swregExpiration.removeEnd('|').removeStart('|'));
                    }
                    
        return contactAttributes;
    }
    //changes for Ryder
    private Account getAcctRyderDefault(String sDefaultRyderCustCode){
        Account partnerRyderAcct= new Account();
                List<Account> partnerAcctRyderList=[SELECT id
                                                   , Name
                                                   , Type
                                                   , IAM_Service_Provider_Code__c
                                                   , IAM_Partner_Location_Code__c
                                                   , Location__c
                                                   , CSS_DBCode__c
                                                   , CSS_DistributorCode__c
                                                   , CSS_DealerCode__c
                                                   , IAM_WWSPS_Regions__c
                                                   , IAM_ABO_Code_Formula__c
                                                   , phone
                                                   , BillingStreet
                                                   , BillingCity
                                                   , BillingCountry
                                                   , BillingState
                                                   , BillingPostalCode
                                                   , (SELECT id,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c,IAM_Subscription_Name__c,IAM_Qsolexpiration__c,IAM_Subscription_Start_Date__c,IAM_Subscription_End_Date__c FROM Applications__r WHERE IAM_Status__c='Active')
                                                     FROM Account
                                                     WHERE IAM_Service_Provider_Code__c=:sDefaultRyderCustCode LIMIT 1];    
                if(!partnerAcctRyderList.isEmpty()){
                    System.debug('Printing Account Details'+partnerAcctRyderList[0]);
                    partnerRyderAcct=partnerAcctRyderList[0];
                }
        System.debug('Printing Partner Account Details#####'+partnerRyderAcct);
        System.debug('Printing Partner Account Application Access####'+partnerRyderAcct.Applications__r);
        return partnerRyderAcct;
    }
    
    //changes for Ryder
    /*private boolean getPartnerLocCode(Map<String,String> attributes, Boolean bIsPartnercode){ 
        if(!String.isBlank(attributes.get('location_num'))){
            List<IAM_Partner_Loc_Codes_Settings__mdt> partnerdatList = [Select Id, IAM_PartnerLoc_Code__c from IAM_Partner_Loc_Codes_Settings__mdt 
                                                             where IAM_PartnerLoc_Code__c =:attributes.get('location_num')];
            if(partnerdatList.size()>0){
                bIsPartnercode = True;
            }
        }
        return bIsPartnercode;
    }*/
}