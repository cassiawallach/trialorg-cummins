/************************************************************
Name:  IAM_Fleetguard_Registration
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Webservice class for Fleatguard User Registeration using REST API for IDM Project
@RestResource – defines the endpoint that we will later use to hit the URL of the custom API.
@HttpPost – defines the function to be called when issuing an HTTP GET command from the client.                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION     AUTHOR                   DATE              DETAIL                                
1.0  -    Sushma Rajput            16/04/2019       INITIAL DEVELOPMENT          
1.1  -    Karthik Golakaram        12/03/2020     Made changes to handle Duplicate Username Changes
1.2  -    Chetan Gaikwad           23/02/2021       Updating response to be sent from IAM
/********************************************************************************
***********************************************************************************/

@RestResource(urlMapping='/IAM_Fleetguard_Registration/*')
Global without sharing class IAM_Fleetguard_Registration
{   
    @HttpPost
    Global static void doPost()
    {    
        string errorContat;//property for storing error message during contact insertion.
        Boolean dupAccountselected;
        string accountID;
        string AccountaccessFeature_id;
        string contactID;
        String IAMUserId;
        String jsonResponse = '';
        Boolean duolicateRecord;
        String email;
        //Added changes for the email format on 30-10-2019
        String emailFormat = '([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2})';
     
        List<User> userlist = new List<User>();
        
        Id AccownerId;
        
        RestRequest req = RestContext.request;
        RestResponse response = RestContext.response; 
        response.addHeader('Content-Type','applicatin/json');
        
        String req_body= req.requestBody.toString().trim(); 
        String ContentType = RestContext.request.headers.get('Content-Type');
        
        if (req_body != NULL)
        {
            IAMUserCreationRequestWrapper wraprecord = IAMUserCreationRequestWrapper.parse(req_body);
            IAMUserCreationRequestWrapper objWrapper = new IAMUserCreationRequestWrapper();
            
            String profilevalue = System.Label.IAM_User_Profile;        
            List<Profile> profileIDVal = [select Id,Name from Profile WHERE Name =: profilevalue ]; //'IAM_FleetguardUser' Removed Hard Cord Value
            system.debug('User Profile Name-----'+profileIDVal);
            
            String AccCompanyName;
            String AccStreet;
            String AccCountry;
            String AccCity;
            String AccState;
            String AccPostalCode;
            String AccAddress;
            String UserLastName;
            String UserFirstName;
            String UserEmail;
            String UserNickName;
            String UserPhone;
            String UserAlias;
            String UserFederationIdentifier;
            
            String customLabelStatus = System.Label.IAM_Active_Status;
            String customLabelConType = System.Label.IAM_Contact_Type;
            String customLabelAccName = System.Label.IAM_Account_Name;
            String customLabelAccStreet = System.Label.IAM_Account_Street;
            
            System.debug('Printing location one'+wraprecord.UserInformation[0]);
            for(IAMUserCreationRequestWrapper.cls_UserInformation serializedUserAdd : wraprecord.UserInformation)
            {             
                AccCompanyName = serializedUserAdd.CompanyName;
                AccStreet = serializedUserAdd.Street;
                AccCountry = serializedUserAdd.Country;
                AccCity = serializedUserAdd.City;
                AccState = serializedUserAdd.State;
                AccPostalCode = serializedUserAdd.PostalCode;
                AccAddress = serializedUserAdd.Address;
                UserLastName=serializedUserAdd.LastName;
                UserFirstName=serializedUserAdd.FirstName;
                UserEmail= serializedUserAdd.Email;
                UserNickName = serializedUserAdd.CommunityNickname;
                UserPhone = serializedUserAdd.Phone;
                UserAlias = UserFirstName.left(1) + UserLastName.left(4);
                UserFederationIdentifier = serializedUserAdd.FederationIdentifier;            
            }  
               
             Savepoint sp = Database.setSavepoint();           
            
            try{
                if(UserFirstName !='' && UserLastName!='' && UserEmail!='' && AccCompanyName !='' && AccAddress!='' && AccCity!='' && AccPostalCode!='' && UserPhone!='')      
                {  
                    set<string> statePickListValuesSet = new Set<string>();
                    Schema.DescribeFieldResult fieldResult = User.statecode.getDescribe();
                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    for( Schema.PicklistEntry pickListVal : ple){
                        statePickListValuesSet.add(pickListVal.getLabel());
                    }     
                    set<string> countryPickListValuesSet = new Set<string>();
                    Schema.DescribeFieldResult fieldResultCou = User.Countrycode.getDescribe();
                    List<Schema.PicklistEntry> pleCon = fieldResultCou.getPicklistValues();
                    for( Schema.PicklistEntry pickListVal : pleCon){
                        countryPickListValuesSet.add(pickListVal.getLabel());
                    }     
                    
                    
                    if((AccState == '' || AccState == null || statePickListValuesSet.contains(AccState)) && (AccCountry == '' || AccCountry == null || countryPickListValuesSet.contains(AccCountry)))
                    {
                    
                        if(Pattern.matches(emailFormat, UserEmail))
                        {
                            
                            string userEmail_IAM= UserEmail; 
                            
                           /*list<User>DuplicateUser= [select id,FederationIdentifier , Email,CompanyName,City,FirstName,LastName,username from user where Email=:userEmail_IAM]; 
                            Commenting this line for checking username at Contact level and the check if user is a reclaimed or not.
                           */ 

                            List<Contact> DuplicateUser = [SELECT id,Accountid,FirstName,LastName,Email,Username__c,IAM_Ext_Legacy_Uid__c,IAM_Legacy_User__c,Account.Name,Account.BillingCity,Account.BillingCountry FROM Contact WHERE Username__c=:userEmail_IAM AND IAM_Contact_Status__c='Active'];

                            if(DuplicateUser.size()<1)
                            {      
                                List<Account> picklistVal= [Select ID,Type, CMI_Account_Status__c , CMI_Region__c, CSS_DistributorCode__c, IAM_WWSPS_Regions__c from Account where name =:AccCompanyName limit 1];       
                                system.debug('account'+AccCompanyName+picklistVal.size()+'size is ========>');
                                    
                                //Adding Changes for Account Creation Karthik Golakaram
                                Account acc= createAccount(wraprecord.UserInformation[0]);
                                //End of Account Creation Changes. Karthik Golakaram 12/10/2020
                                    
                                 System.debug('Printing account details at main class'+acc);
                                 System.debug('Printing account ID that needs to be passed to Account access'+acc.id);
                                //Adding Changes for Account access and Provisioning for new Account -Karthik Golakaram 12/10/2020
                                List<IAM_Application__c> exsistingAccess = duplicateAcountAccessCheck(acc.id);
                                IAM_Application__c AccountaccessFeature= new IAM_Application__c();
                                if(exsistingAccess.size()>0){
                                    AccountaccessFeature=exsistingAccess[0];
                                }else{
                                    AccountaccessFeature=createAccountAccessAndProvisioning(acc.id);
                                }   
                                //End of Code Addition -Karthik Golakaram 12/10/2020
                             
                                system.debug('AccountAccessFeature Record Details-----'+AccountaccessFeature); 
                                AccountaccessFeature_id=AccountaccessFeature.id;
                               
                                //Adding changes for code addition for Contact Creation-Karthik Golakaram 12/10/2020
                                Contact conNew=createContact(acc.id,wraprecord.UserInformation[0]);
                                //End of Code Addition for Contact Creation -Karthik Golakaram
                                
                                Id conid=conNew.id;
                                
                                User newUser = createUser(acc,conNew);  //Made Changes to Create User - Karthik Golakaram 12/10/2020             
                                System.debug('Printing User Information'+newUser);
                                Id usrid=newUser.id;
                                
                                //User Feature & Access Records:
                                IAM_Contact_Provisioning__c UseraccessFeature =createContactProvisioning(conNew.id,AccountaccessFeature) ;
                    
                                system.debug('UserAccessFeature Record Details-----'+UseraccessFeature);                                           
                                
                                response.statusCode = 200;
                                 if(newUser.City != null){
                                jsonResponse = '{"response": \n{\n"status": "Success", \n"isSuccess":"True" ,\n"isExistingUser":"False", \n"ErrorCode":"Nothing", \n"Message": "Success : New IAM User is created Successfully with Unique Emial address", \n"Username": "'+newUser.Username+'" ,\n"LegacyUsername":"'+newUser.Username+'",\n"FirstName":"'+newUser.FirstName+'",\n"LastName":"'+newUser.LastName+'", \n"usrid": "'+newUser.id+'",\n"City": "'+newUser.City+'",\n"CompanyName": "'+newUser.CompanyName+'" \n}\n}';
                                
                                response.responseBody = blob.valueOf(jsonResponse);
                                System.ResetPassword(newUser.Id, True); 
                               }
                               else{
                                   //code start - City value in response updated to be passed in quotes ""
                                    jsonResponse = '{"response": \n{\n"status": "Success", \n"isSuccess":"True" ,\n"isExistingUser":"False", \n"ErrorCode":"Nothing", \n"Message": "Success : New IAM User is created Successfully with Unique Emial address", \n"Username": "'+newUser.Username+'" ,\n"LegacyUsername":"'+newUser.Username+'",\n"FirstName":"'+newUser.FirstName+'",\n"LastName":"'+newUser.LastName+'", \n"usrid": "'+newUser.id+'",\n"City": "'+newUser.City+'",\n"CompanyName": "'+newUser.CompanyName+'" \n}\n}';
                                    //code end - City value in response updated to be passed in quotes ""
                                    response.responseBody = blob.valueOf(jsonResponse);
                                    System.ResetPassword(newUser.Id, True);                            
                                }                           
                            } //Duplicate if block close
                            else 
                            {   
                                //Start of Code Addition - Karthik Golakaram -12/2/2020
                                //what needs to be done if duplicate user is present in the system. 
                                //Check if location has Account access and feature. IF not create one. If Account access and feature 
                                //is not present create one and then create user access and Feature.
                                List<User> fleetAppUser=[SELECT id,USername,Email,City,CompanyName
                                                         FROM User 
                                                         WHERE Username=:DuplicateUser[0].Username__c
                                                         AND isActive=True];
                                if(!DuplicateUser[0].IAM_Legacy_User__c){
                                    //1. Check if user already have access to Fleetguard Customer Portal App.
                                    if(!fleetAppUser.isEmpty()){
                                        List<IAM_Contact_Provisioning__c> fleetAppCon=[SELECT id,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c
                                        FROM IAM_Contact_Provisioning__c
                                        WHERE IAM_Contact__c=:DuplicateUser[0].id
                                        AND IAM_Application_Name__c=:Label.IAM_AppName_Fleetguard_Customer
                                        AND IAM_Status__c=:Label.IAM_Active_status];
                                        if(fleetAppCon.Size()>0){
                                        //Contact is already Provisioned for App Access.Check user has permission set and the set the response.
                                        List<PermissionSet> fleetAppPermission=[SELECT id,Name FROM PermissionSet WHERE Label=:Label.IAM_AppName_Fleetguard_Customer];
                                        System.debug('Printing permission set ID'+fleetAppPermission);
                                        List<PermissionSetAssignment> assigned=[SELECT id FROM PermissionSetAssignment 
                                                                                WHERE PermissionSetId=:fleetAppPermission[0].id
                                                                                AND AssigneeId=:fleetAppUser[0].id];
                                            if(assigned.size()>0){
                                                //Set success response and say user has access.
                                                jsonResponse = '{"response": \n{\n"status": "Success", \n"isSuccess":"True" ,\n"isExistingUser":"True", \n"ErrorCode":"Nothing", \n"Message": "Success : User is already present in IAM with Fleetguard Access", \n"Username": "'+DuplicateUser[0].Username__c+'",\n"LegacyUsername":"'+DuplicateUser[0].IAM_Ext_Legacy_UID__c+'",\n"FirstName":"'+DuplicateUser[0].FirstName+'",\n"LastName":"'+DuplicateUser[0].LastName+'", \n"usrid": "'+fleetAppUser[0].id+'",\n"City": "'+fleetAppUser[0].City+'",\n"CompanyName": "'+fleetAppUser[0].CompanyName+'" \n}\n}';
                                                response.responseBody = blob.valueOf(jsonResponse);
                                            }else{
                                                //Assign Permission set and send user already present but assigned required permissions.
                                                PermissionSetAssignment psa= new PermissionSetAssignment(PermissionSetId=fleetAppPermission[0].id,AssigneeId=fleetAppUser[0].id);
                                                insert psa;
                                                //Set success response and say user has access.
                                                jsonResponse = '{"response": \n{\n"status": "Success", \n"isSuccess":"True" ,\n"isExistingUser":"True", \n"ErrorCode":"Nothing", \n"Message": "Success : User is already present in IAM. Provided access to My Fleetguard Customer Portal Application", \n"Username": "'+DuplicateUser[0].Username__c+'",\n"LegacyUsername":"'+DuplicateUser[0].IAM_Ext_Legacy_UID__c+'",\n"FirstName":"'+DuplicateUser[0].FirstName+'",\n"LastName":"'+DuplicateUser[0].LastName+'", \n"usrid": "'+fleetAppUser[0].id+'",\n"City": "'+fleetAppUser[0].City+'",\n"CompanyName": "'+fleetAppUser[0].CompanyName+'" \n}\n}';
                                                response.responseBody = blob.valueOf(jsonResponse);
                                            } 
                                        }else{
                                            //Check if location has access to App or Not.
                                            List<IAM_Application__c> fleetApp= [SELECT id,IAM_Application_NAme__c,IAM_Role__c,IAM_Status__C,IAM_Subscription_Start_Date__c,IAM_Subscription_End_Date__c
                                                                FROM IAM_Application__c
                                                                WHERE IAM_Account_Name__c=:DuplicateUser[0].Accountid
                                                                AND IAM_Application_Name__c=:Label.IAM_AppName_Fleetguard_Customer
                                                                AND IAM_Status__c=:Label.IAM_Active_Status];

                                            if(fleetApp.Size()>0){
                                                //Location has access then create User access and feature record and make sure Permission set is assigned.
                                                IAM_Contact_Provisioning__c newConApp= createContactProvisioning(DuplicateUser[0].id,fleetApp[0]);    
                                                if(newConApp!=null){
                                                    //Set Response as Success
                                                    jsonResponse = '{"response": \n{\n"status": "Success", \n"isSuccess":"True" ,\n"isExistingUser":"True", \n"ErrorCode":"Nothing", \n"Message": "Success : User is already present in IAM. Provided access to My Fleetguard Customer Portal Application", \n"Username": "'+DuplicateUser[0].Username__c+'",\n"LegacyUsername":"'+DuplicateUser[0].IAM_Ext_Legacy_UID__c+'",\n"FirstName":"'+DuplicateUser[0].FirstName+'",\n"LastName":"'+DuplicateUser[0].LastName+'", \n"usrid": "'+DuplicateUser[0].id+'",\n"City": "'+fleetAppUser[0].City+'",\n"CompanyName": "'+fleetAppUser[0].CompanyName+'" \n}\n}';
                                                    response.responseBody = blob.valueOf(jsonResponse);
                                                }else{
                                                    //Set response as failure to provide access.
                                                    jsonResponse = '{"response": \n{\n"status": "Failure", \n"isSuccess":"false" ,\n"isExistingUser":"True", \n"ErrorCode":"Not able to grant Access", \n"Message": "Failure : User is already present in IAM. Encountered error while granting access to applicaiton. Contact IAM IT Support.", \n"Username": "'+DuplicateUser[0].Username__c+'",\n"LegacyUsername":"'+DuplicateUser[0].IAM_Ext_Legacy_UID__c+'",\n"FirstName":"'+DuplicateUser[0].FirstName+'",\n"LastName":"'+DuplicateUser[0].LastName+'", \n"usrid": "'+fleetAppUser[0].id+'",\n"City": "'+fleetAppUser[0].City+'",\n"CompanyName": "'+fleetAppUser[0].CompanyName+'" \n}\n}';
                                                    response.responseBody = blob.valueOf(jsonResponse);
                                                }
                                            }else{
                                            //Create both Account access and feature and User access and feature.
                                                IAM_Application__c newFleetApp=createAccountAccessAndProvisioning(DuplicateUser[0].Accountid);
                                                if(newFleetApp!=null){
                                                    //Call CreateConProvFeature 
                                                    IAM_Contact_Provisioning__c newConProv1 =  createContactProvisioning(DuplicateUser[0].id,newFleetApp);
                                                    if(newConProv1!=null){
                                                        //set response to success
                                                        jsonResponse = '{"response": \n{\n"status": "Success", \n"isSuccess":"True" ,\n"isExistingUser":"True", \n"ErrorCode":"Nothing", \n"Message": "Success : User is already present in IAM. Provided access to My Fleetguard Customer Portal Application", \n"Username": "'+DuplicateUser[0].Username__c+'",\n"LegacyUsername":"'+DuplicateUser[0].IAM_Ext_Legacy_UID__c+'",\n"FirstName":"'+DuplicateUser[0].FirstName+'",\n"LastName":"'+DuplicateUser[0].LastName+'", \n"usrid": "'+fleetAppUser[0].id+'",\n"City": "'+fleetAppUser[0].City+'",\n"CompanyName": "'+fleetAppUser[0].CompanyName+'" \n}\n}';
                                                        response.responseBody = blob.valueOf(jsonResponse);
                                                    }else{
                                                        //set reponse to failure
                                                        jsonResponse = '{"response": \n{\n"status": "Failure", \n"isSuccess":"false" ,\n"isExistingUser":"True", \n"ErrorCode":"Not able to grant Access", \n"Message": "Failure : User is already present in IAM. Encountered error while granting access to applicaiton. Contact IAM IT Support.", \n"Username": "'+DuplicateUser[0].Username__c+'",\n"LegacyUsername":"'+DuplicateUser[0].IAM_Ext_Legacy_UID__c+'",\n"FirstName":"'+DuplicateUser[0].FirstName+'",\n"LastName":"'+DuplicateUser[0].LastName+'", \n"usrid": "'+fleetAppUser[0].id+'",\n"City": "'+fleetAppUser[0].City+'",\n"CompanyName": "'+fleetAppUser[0].CompanyName+'" \n}\n}';
                                                        response.responseBody = blob.valueOf(jsonResponse);
                                                    }
                                                }else{
                                                    //Set response to failure.
                                                    jsonResponse = '{"response": \n{\n"status": "Failure", \n"isSuccess":"false" ,\n"isExistingUser":"True", \n"ErrorCode":"Not able to grant Access", \n"Message": "Failure : User is already present in IAM. Encountered error while granting access to applicaiton. Contact IAM IT Support.", \n"Username": "'+DuplicateUser[0].Username__c+'",\n"LegacyUsername":"'+DuplicateUser[0].IAM_Ext_Legacy_UID__c+'",\n"FirstName":"'+DuplicateUser[0].FirstName+'",\n"LastName":"'+DuplicateUser[0].LastName+'", \n"usrid": "'+fleetAppUser[0].id+'",\n"City": "'+fleetAppUser[0].City+'",\n"CompanyName": "'+fleetAppUser[0].CompanyName+'" \n}\n}';
                                                    response.responseBody = blob.valueOf(jsonResponse);   
                                                }
                                            }
                                        }
                                    }else{
                                        //Create User.
        
                                    }
                                }else{
                                    //User is a Legacy user and response should say user should reclaim.
                                        jsonResponse = '{"response": \n{\n"status": "Failure", \n"isSuccess":"false" ,\n"isExistingUser":"True", \n"ErrorCode":"Not able to grant Access because User in Legacy User", \n"Message": "Failure : User is already present in IAM with LDAP Username and user needs to undergo Reclaim.", \n"Username": "'+DuplicateUser[0].Username__c+'",\n"LegacyUsername":"'+DuplicateUser[0].IAM_Ext_Legacy_UID__c+'",\n"FirstName":"'+DuplicateUser[0].FirstName+'",\n"LastName":"'+DuplicateUser[0].LastName+'", \n"usrid": "'+DuplicateUser[0].id+'",\n"City": "'+DuplicateUser[0].Account.BillingCity+'",\n"CompanyName": "'+DuplicateUser[0].Account.Name+'" \n}\n}';
                                        response.responseBody = blob.valueOf(jsonResponse); 
                                } 
                            }
                            //End of Code Addition - Karthik Golakaram -12/2/2020
                        }              
                        // Email format if close    
                        else
                        {
                            response.statusCode = 200;                                   
                            jsonResponse = '{"response": \n{\n"Status": "Failure", \n"isSuccess":"False" ,\n"isExistingUser":"False", \n"ErrorCode":"Invalid Email id",\n"Message": "Failure : Invalid Email id", \n"Username": "'+UserEmail+'",\n"LegacyUsername":"'+UserEmail+'",\n"FirstName":"'+UserFirstName+'", \n"LastName":"'+UserLastName+'",\n"CompanyName": "'+AccCompanyName+'",\n"City":"'+AccCity +'" \n}\n}';
                            response.responseBody = blob.valueOf(jsonResponse);
                        }
                    }
                    else{
                    
					//First check if country is valid or not then check for state 
                        response.statusCode = 200;
						if(String.isNotEmpty(AccCountry)){
							if(!countryPickListValuesSet.contains(AccCountry)){
								jsonResponse = '{"response": \n{\n"Status": "Failure", \n"isSuccess":"False" ,\n"isExistingUser":"False", \n"ErrorCode":"Invalid Country",\n"Message": "Failure : Invalid Country", \n"Username": "'+UserEmail+'",\n"LegacyUsername":"'+UserEmail+'",\n"FirstName":"'+UserFirstName+'", \n"LastName":"'+UserLastName+'",\n"CompanyName": "'+AccCompanyName+'",\n"City":"'+AccCity +'" \n}\n}';
								response.responseBody = blob.valueOf(jsonResponse);
							}else if(!statePickListValuesSet.contains(AccState)){
								jsonResponse = '{"response": \n{\n"Status": "Failure", \n"isSuccess":"False" ,\n"isExistingUser":"False", \n"ErrorCode":"Invalid State",\n"Message": "Failure : Invalid State", \n"Username": "'+UserEmail+'",\n"LegacyUsername":"'+UserEmail+'",\n"FirstName":"'+UserFirstName+'", \n"LastName":"'+UserLastName+'",\n"CompanyName": "'+AccCompanyName+'",\n"City":"'+AccCity +'" \n}\n}';
							response.responseBody = blob.valueOf(jsonResponse);
							}
						}else{
							jsonResponse = '{"response": \n{\n"Status": "Failure", \n"isSuccess":"False" ,\n"isExistingUser":"False", \n"ErrorCode":"Invalid Country",\n"Message": "Failure : Invalid Country", \n"Username": "'+UserEmail+'",\n"LegacyUsername":"'+UserEmail+'",\n"FirstName":"'+UserFirstName+'", \n"LastName":"'+UserLastName+'",\n"CompanyName": "'+AccCompanyName+'",\n"City":"'+AccCity +'" \n}\n}';
							response.responseBody = blob.valueOf(jsonResponse);
						}
                    }          
                }
                else
                {
                    system.debug('Error checing-----');
                    response.statusCode = 200;                                   
                    jsonResponse = '{"response": \n{\n"Status": "Failure", \n"isSuccess":"False",\n"isExistingUser":"False",\n"ErrorCode":"Missing Required Fields",\n"Message":"Failure-Required Fields are Missing please check FirstName,LastName,Email,Address,City,PostalCode also Check Valid Email Address",\n"Username":"'+UserEmail+'",\n"FirstName":"'+UserFirstName+'", \n"LastName":"'+UserLastName+'",\n"City":"'+AccCity+'",\n"CompanyName":"'+AccCompanyName+'" \n}\n}';
                    response.responseBody = blob.valueOf(jsonResponse);    
                }      
            } //try bolck end
            catch(DmlException e){
                // rollback functionality for Entire Transaction
                Database.RollBack(sp);
                if(e.getMessage().contains('Insert failed. First exception on row 0; first error: DUPLICATES_DETECTED, Use one of these records?: []')) {
                    system.debug('Checking  duplicate values found1: DUPLICATES_DETECTED');
                    // response.statusCode = 200; 
                    System.debug('Printing fields involved'+e.getDmlFields(0));
                    
                    jsonResponse = '{"response": {\n"Status": "Failure",\n"isSuccess":"False" , \n"ErrorCode":"Duplicate Account Detected",\n"Message": "This Account is already existing : Kindly Use Different Account"}}';
                    response.responseBody = blob.valueOf(jsonResponse); 
                }
                else{ 
                   System.debug('Printing fields involved 2'+e.getDmlFields(0));
                   System.debug('Printing dml error message'+e.getDmlMessage(0));
                    response.statusCode = 200;                                   
                    jsonResponse = '{"response": {\n"Status": "Failure",\n"isSuccess":"False" , \n"ErrorCode":"Invalid Data",\n"Message": "'+e.getMessage()+'"}}';
                    response.responseBody = blob.valueOf(jsonResponse);     
                    system.debug('Checking  duplicate values : DUPLICATES_DETECTED');
                } 
            }    
        }
        else{
            system.debug('Error checing-----');
            response.statusCode = 200;                                   
            jsonResponse = '{"response": \n{\n"Status": "Failure", \n"isSuccess":"False" ,\n"isExistingUser":"False", \n"ErrorCode":"Request Body is Required",\n"Message":"Request Body is Required Username,FirstName,LastName,Email,City,CompanyName"\n}\n}';
            response.responseBody = blob.valueOf(jsonResponse);
        }
        
    }


    //Method to create Account access and Feature -Karthik Added on 12-2-2020
    Public Static IAM_Application__c createAccountAccessAndProvisioning(id AccountId){
        
        IAM_Application__c fleetFit= new IAM_Application__c();
        fleetFit.IAM_Application_Name__c=Label.IAM_AppName_Fleetguard_Customer;
        fleetFit.IAM_Role__c='User';
        fleetFit.IAM_Account_Name__c=AccountId;
        fleetFit.IAM_Subscription_Start_Date__c=System.today();
        fleetFit.IAM_Subscription_end_Date__c=date.newInstance(2100, 12, 31);
        fleetFit.IAM_Status__c=Label.IAM_Active_Status;
        fleetFit.IAM_Free_Subscription__c=True;
        fleetFit.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(Label.IAM_AppName_Fleetguard_Customer).getRecordTypeId();
         
        insert fleetFit;
        return fleetFit;

    }

    //Method to create User access and feature record 
    Public Static IAM_Contact_Provisioning__c createContactProvisioning(id ContactId, IAM_Application__c fleetAccountApp){
        
        IAM_Contact_Provisioning__c fleetConProv= new IAM_Contact_Provisioning__c();
        fleetConProv.IAM_Application_Name__c=fleetAccountApp.IAM_Application_Name__c;
        fleetConProv.IAM_Role__c=fleetAccountApp.IAM_Role__c;
        fleetConProv.IAM_Account_Application__c=fleetAccountApp.id;
        fleetConProv.IAM_Status__c=fleetAccountApp.IAM_Status__c;
        fleetConProv.IAM_Start_Date__c=fleetAccountApp.IAM_Subscription_Start_Date__c;
        fleetConProv.IAM_End_Date__c=fleetAccountApp.IAM_Subscription_End_Date__c; 
        fleetConProv.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(fleetAccountApp.IAM_Application_Name__c).getRecordTypeId();
        fleetConProv.IAM_Contact__C=ContactId;

        insert fleetConProv;
        return fleetConProv;
    }
    
    //End of Code addition - Karthik Golakaram on 12/02/2020.
    
    //Code Addition for Account Creation -Karthik Golakaram on 12/09/2020
    Public Static Account createAccount(IAMUserCreationRequestWrapper.cls_UserInformation companyInfo){
        id duplicateAccountID;
        Account fleetAccount = new Account();
        fleetAccount.Name = companyInfo.CompanyName ;
        fleetAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        fleetAccount.CSS_Timezone__c = 'America/New_York';//'(GMT-05:00) Eastern Standard Time (America/Panama)'; 
        fleetAccount.CSS_Locale__c = 'en_US' ;// 'English(United States)'; 
        fleetAccount.CSS_Language__c = 'en_US'; //'English'; //Language                
        fleetAccount.Type ='Customer' ; //'Customer' ;                       
        fleetAccount.CMI_Account_Status__c = 'Active';     //'Active ' ;                                                           //'North America' ;                
        fleetAccount.BillingStreet = companyInfo.Address;
        fleetAccount.BillingCountry = companyInfo.Country;
        fleetAccount.BillingCity = companyInfo.City;
        fleetAccount.BillingState = companyInfo.State;
        fleetAccount.BillingPostalCode = companyInfo.PostalCode;
        fleetAccount.AccountSource='Fleetguard Customer Portal Registration API';
        System.debug('Printing parent account that will be assigned'+('Cummins - '+fleetAccount.BillingCountry));
        String parentAccountName='';
        if(String.isNotEmpty(fleetAccount.BillingCountry)){
              parentAccountName='Cummins - '+fleetAccount.BillingCountry;     
        }else{
             parentAccountName='Cummins - United States';          
        }
        
        Account parentAccount=[select id,CSS_DistributorCode__c,IAM_WWSPS_Regions__c from Account where name=:parentAccountName and type ='Internal' LIMIT 1];
        
        fleetAccount.Parentid=parentAccount.id;//Cummins- United States Parent Id
        fleetAccount.CSS_DistributorCode__c = parentAccount.CSS_DistributorCode__c; // 'Dis' ;
        fleetAccount.IAM_WWSPS_Regions__c = parentAccount.IAM_WWSPS_Regions__c; 
        
        List<Account> accDupList= new List<Account>();
        accDuplist.add(fleetAccount);
        
        
        List<Datacloud.FindDuplicatesResult> findDuplicates=Datacloud.FindDuplicates.findDuplicates(accDuplist);
        Boolean hasDuplicateAccount=false;
        
        System.debug('Printing Duplicatelist'+findDuplicates);
        System.debug('Prinitng duplicates list size()'+findDuplicates.Size());
        
         
             for (Datacloud.FindDuplicatesResult findDupeResult : findDuplicates) {
                for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) {
                    for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
                        System.debug('Printing Duplicate account result'+matchResult.getMatchRecords().Size());
                        if(matchResult.getMatchRecords().Size()>0){
                          hasDuplicateAccount=true;  
                        }
                        for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                            System.debug('Duplicate Record: ' + matchRecord.getRecord());
                            System.debug('Duplicate Record: ' + matchRecord.getRecord().id);
                            duplicateAccountId=matchRecord.getRecord().id;
                        }
                    }
                }
             }
        System.debug('Printing Duplicate Account '+duplicateAccountId);
        if(!hasDuplicateAccount){
            insert fleetAccount;
         }else{
             
             fleetAccount=[SELECT id,Name,Parentid,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode
                                                 FROM Account
                                                 WHERE id=:duplicateAccountId];
         } 
        System.debug('Printing return records of Accounts'+fleetAccount); 
        return fleetAccount;
    }
    //End of code addition for Account Creation -Karthik Golakram on 12/09/2020
    
    
    //Code Addition for Contact Creation - Karthik Golakaram 12/10/2020
    Public Static Contact createContact(id AccountId,IAMUserCreationRequestWrapper.cls_UserInformation userInformation){
        Contact fleetContact= new Contact();
        FleetContact.accountID = AccountId ;
        FleetContact.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();                     
        FleetContact.FirstName = userInformation.FirstName;
        FleetContact.LastName = userInformation.LastName;
        FleetContact.CMI_Contact_Type__c = Label.IAM_Contact_Type; //'Secondary'; //label
        FleetContact.Email= userInformation.Email;
        FleetContact.ownerid = UserInfo.getUserId(); 
        FleetContact.IAM_Contact_Status__c='Active';
        FleetContact.IAM_From_API__c=True;
        FleetContact.Username__c=userInformation.Email;
        FleetContact.IAM_Ext_Legacy_Uid__c=userInformation.Email;
        FleetContact.Phone=userInformation.Phone;
        
        insert FleetContact;
        
        
        return FleetContact;
    }   
    //End of Code Addition -Karthik Golakaram 12/10/2020
    
    //Code Addition for User Creation - Karthik Golakaram 12/10/2020
    Public Static User createUser(Account fleetAcc,Contact fleetCon){
        User fleetUser = new User();
     
        fleetUser.FirstName = fleetCon.FirstName;
        fleetUser.LastName = fleetCon.LastName;
        fleetUser.Email = fleetCon.Email;   
        fleetUser.CompanyName = fleetAcc.Name ; // Account Name                           
        //fleetUser.CommunityNickname = UserNickName; will be set automatically
        fleetUser.Alias = fleetCon.FirstName.left(1)+fleetCon.LastName.left(4);
        fleetUser.Username = fleetCon.Username__c;
        fleetUser.IAM_UID__c = fleetCon.IAM_Ext_Legacy_Uid__c;
        fleetUser.Phone = fleetCon.Phone; 
        fleetUser.TimeZoneSidKey =  'America/New_York'; //'GMT';
        fleetUser.LocaleSidKey= 'en_US' ; //'en_US';
        fleetUser.EmailEncodingKey = 'UTF-8' ; //'UTF-8';
        fleetUser.LanguageLocaleKey = 'en_US' ; //'en_US'; 
        fleetUser.ProfileId = [select Id,Name from Profile WHERE Name=:Label.IAM_User_Profile ].Id ;
        system.debug('New User Profile Id value---------' +fleetUser.ProfileId );               
        fleetUser.ContactId =fleetCon.Id;
        system.debug('New User Contact Id value---------' +fleetUser.ContactId);
        fleetUser.isActive = TRUE;
        fleetUser.Street = fleetAcc.BillingStreet; //'123 Test St';
        fleetUser.FederationIdentifier = fleetCon.IAM_Ext_Legacy_UID__c;
        fleetUser.City = fleetAcc.BillingCity ;
        fleetUser.State = fleetAcc.BillingState ;
        fleetUser.PostalCode = fleetAcc.BillingPostalCode;
        fleetUser.Country = fleetAcc.BillingCountry ;
        
        
        insert fleetUser;
        return fleetUser;
    }
    //End of Code addition for User Creation - Karthik Golakaram 12/10/2020
    
    
    //Code addition to check if location has active User access and feature record.
    Public static List<IAM_Application__c> duplicateAcountAccessCheck(id AccountId){
        List<IAM_Application__c> fleetAccountAccess=[SELECT id
                                                     		, IAM_Application_Name__c
                                                     		, IAM_Role__c
                                                     		, IAM_Subscription_Start_Date__c
                                                    		, IAM_Subscription_End_Date__c
                                                            , IAM_Status__c
                                                            , IAM_Account_Name__c
                                                             FROM IAM_Application__C
                                                             WHERE IAM_Account_Name__c=:AccountId
                                                             AND IAM_Status__c=:Label.IAM_Active_Status
                                                             AND IAM_Application_Name__c=:label.IAM_AppName_Fleetguard_Customer];
        return fleetAccountAccess;
    }
    //end of code addition
}