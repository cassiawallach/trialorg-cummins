/************************************************************
Name:  IAM_CDO_updateUserInformation
Copyright © 2022  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Request Parser Class for CDO  Inbound service                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Sandeep Vuyyuru	     06/06/2022         INITIAL DEVELOPMENT  
2.0 -    Sandeep Vuyyuru         08/08/2022         made changes to update cdo
*****************************************************/
@RestResource(urlMapping='/IAM_CDO_updateUserInformation/*')
global class IAM_CDO_updateUserInformation {
    
    @HttpPost
    Global static void doPost(userInfo userInfo)
    {  
        
        String jsonResponse = '';
        
        IAM_Contact_Provisioning__c cdoConProv2= new IAM_Contact_Provisioning__c();
        
        userInfo usercreationInfo = userInfo;
        
        RestRequest req = RestContext.request;
        RestResponse response = RestContext.response; 
        response.addHeader('Content-Type','applicatin/json'); 
        String ContentType = RestContext.request.headers.get('Content-Type');
        Savepoint sp = Database.setSavepoint();       
        try{      
            
            List<Contact> conExists = [Select id,Name,Username__c,FirstName,LastName,Email,Phone,Account.Id,Account.CMI_CId__c,Account.CHANNEL_OF_DISTRIBUTION__c,Account.IAM_Primary_Market_Segment__c,IAM_Contact_Status__c From Contact WHERE username__c =: usercreationInfo.userName AND IAM_Contact_Status__c = 'Active'];  
           //this condition is used to check if user if present in the system using username
            if(!conExists.isEmpty()){
                //List<IAM_Application__c> accountCheck =[select id,IAM_Account_Name__r.CHANNEL_OF_DISTRIBUTION__c,IAM_Account_Name__r.IAM_Primary_Market_Segment__c,IAM_Account_Name__r.CMI_CId__c,IAM_Application_Name__c,IAM_Account_Name__r.id,IAM_Subscription_Start_Date__c,IAM_Subscription_End_Date__c from IAM_Application__c where IAM_Account_Name__r.CMI_CId__c=:usercreationInfo.accountNumber AND  IAM_Application_Name__c = 'Connected Solutions'  LIMIT 1];
                List <Account> accountCheck = [Select id,Name FROM Account WHERE  CMI_CId__c =:usercreationInfo.accountNumber LIMIT 1];
                //this condition is used to check if the contact is present under the account shared in the payload
                if(!accountCheck.isEmpty() && conExists[0].Account.Id == accountCheck[0].Id){
                    List<IAM_Application__c> accountCheckRole =[select id,IAM_Account_Name__r.CHANNEL_OF_DISTRIBUTION__c,IAM_Account_Name__r.IAM_Primary_Market_Segment__c,IAM_Account_Name__r.CMI_CId__c,IAM_Application_Name__c,IAM_Account_Name__r.id,IAM_Subscription_Start_Date__c,IAM_Subscription_End_Date__c from IAM_Application__c where IAM_Account_Name__r.CMI_CId__c=:usercreationInfo.accountNumber AND  IAM_Application_Name__c = 'Connected Solutions' AND IAM_Status__c = 'Active' AND IAM_Role__c includes(:usercreationInfo.role) LIMIT 1];
                    //this condition is used to check if the account feature have active CS subscription with the required role received from payload
                    if(!accountCheckRole.isEmpty()){
                        List<IAM_Contact_Provisioning__c> conProv = [Select id,Name,IAM_Application_Name__c,IAM_Status__c,IAM_DA_Customer_List__c,IAM_Role__c,IAM_User_Type__c,IAM_Contact__r.Account.CMI_CId__c,IAM_Contact__r.Email,IAM_Contact__r.IAM_Contact_Status__c,IAM_Contact__r.firstName,IAM_Contact__r.lastName,IAM_Contact__r.Username__c,IAM_Contact__r.Phone,IAM_Contact__r.Account.CHANNEL_OF_DISTRIBUTION__c,IAM_Contact__r.Account.IAM_Primary_Market_Segment__c,IAM_Contact__r.Language_Preferences__c FROM IAM_Contact_Provisioning__c WHERE IAM_Contact__r.Id =: conExists[0].ID AND IAM_Application_Name__c = 'Connected Solutions'];   
                        if(conProv[0].IAM_Status__c == 'Active'){
                            List<Contact> conUpdate = new List<Contact>();
                            conExists[0].FirstName =  usercreationInfo.firstName;
                            conExists[0].LastName =  usercreationInfo.lastName;
                            conExists[0].Email =  usercreationInfo.emailAddress;              
                            conExists[0].Language_Preferences__c =  usercreationInfo.languagePreference;
                            conUpdate.add(conExists[0]);
                            update conUpdate;  
                            
                            List<IAM_Contact_Provisioning__c> conProUpdate = new List<IAM_Contact_Provisioning__c>();
                            conProv[0].IAM_DA_Customer_List__c = usercreationInfo.accountAccess;
                            conProv[0].IAM_User_Type__c = usercreationInfo.roleType;
                            conProv[0].IAM_Role__c = usercreationInfo.role;
                            if(!String.isBlank(usercreationInfo.subscriptionStatus)){
                                conProv[0].IAM_Status__c = usercreationInfo.subscriptionStatus;
                            }
                            conProUpdate.add(conProv[0]);                            
                            update conProUpdate;
                            response.statusCode = 200;
                            jsonResponse = '{"response": \n{\n"Status": "Success", \n"isSuccess":"True" ,\n"isExistingUser":"True", \n"ReturnCode":"201", \n"Message": "Success : User and its subscription updated successfully", \n"appName": "'+conProUpdate[0].IAM_Application_Name__c+'" ,\n"accountNumber":"'+conUpdate[0].Account.CMI_CId__c+'",\n"emailAddress":"'+conUpdate[0].Email+'",\n"userName":"'+conUpdate[0].Username__c+'", \n"firstName": "'+conUpdate[0].FirstName+'",\n"lastName": "'+conUpdate[0].LastName+'",\n"userStatus": "'+conUpdate[0].IAM_Contact_Status__c+'",\n"subscriptionStatus": "'+usercreationInfo.subscriptionStatus+'",\n"phoneNumber": "'+conUpdate[0].Phone+'",\n"role": "'+conProUpdate[0].IAM_Role__c+'",\n"roleType": "'+conProUpdate[0].IAM_User_Type__c+'",\n"accountAccess": "'+conProUpdate[0].IAM_DA_Customer_List__c+'" ,\n"distributionChannel": "'+conUpdate[0].Account.CHANNEL_OF_DISTRIBUTION__c+'",\n"primaryMarketType": "'+conUpdate[0].Account.IAM_Primary_Market_Segment__c+'" ,\n"languagePreference": "'+conUpdate[0].Language_Preferences__c+'" \n}\n}';
                            response.responseBody = blob.valueOf(jsonResponse);
                        }  
                        else if(conProv.isEmpty() || conProv[0].IAM_Status__c == 'Inactive'){
                            List<Contact> conUpdate = new List<Contact>();
                            conExists[0].FirstName =  usercreationInfo.firstName;
                            conExists[0].LastName =  usercreationInfo.lastName;
                            conExists[0].Email =  usercreationInfo.emailAddress;              
                            conExists[0].Language_Preferences__c =  usercreationInfo.languagePreference;
                            conUpdate.add(conExists[0]);
                            update conUpdate;
                            
                            IAM_Contact_Provisioning__c cdoConProv= new IAM_Contact_Provisioning__c();
                            cdoConProv.IAM_Application_Name__c='Connected Solutions';
                            cdoConProv.IAM_Role__c=usercreationInfo.role;
                            cdoConProv.IAM_Account_Application__c=accountCheckRole[0].id;
                            cdoConProv.IAM_Status__c='Active';
                            cdoConProv.IAM_Start_Date__c=accountCheckRole[0].IAM_Subscription_Start_Date__c;
                            cdoConProv.IAM_End_Date__c=accountCheckRole[0].IAM_Subscription_End_Date__c; 
                            cdoConProv.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
                            cdoConProv.IAM_Contact__C=conExists[0].Id;
                            cdoConProv.IAM_DA_Customer_List__c = usercreationInfo.accountAccess;
                            cdoConProv.IAM_User_Type__c = usercreationInfo.roleType;
                            cdoConProv.IAM_From_CDO__c = true;
                            insert  cdoConProv; 
                            
                            response.statusCode = 200;
                            jsonResponse = '{"response": \n{\n"Status": "Success", \n"isSuccess":"True" ,\n"isExistingUser":"True", \n"ReturnCode":"201", \n"Message": "Success : User is present created subscription successfully", \n"appName": "'+cdoConProv.IAM_Application_Name__c+'" ,\n"accountNumber":"'+conUpdate[0].Account.CMI_CId__c+'",\n"emailAddress":"'+conUpdate[0].Email+'",\n"userName":"'+conUpdate[0].Username__c+'", \n"firstName": "'+conUpdate[0].FirstName+'",\n"lastName": "'+conUpdate[0].LastName+'",\n"userStatus": "'+conUpdate[0].IAM_Contact_Status__c+'",\n"subscriptionStatus": "'+cdoConProv.IAM_Status__c+'",\n"phoneNumber": "'+usercreationInfo.phoneNumber+'",\n"role": "'+cdoConProv.IAM_Role__c+'",\n"roleType": "'+cdoConProv.IAM_User_Type__c+'",\n"accountAccess": "'+cdoConProv.IAM_DA_Customer_List__c+'" ,\n"distributionChannel": "'+conUpdate[0].Account.CHANNEL_OF_DISTRIBUTION__c+'",\n"primaryMarketType": "'+conUpdate[0].Account.IAM_Primary_Market_Segment__c+'",\n"languagePreference": "'+conUpdate[0].Language_Preferences__c+'"  \n}\n}';
                            response.responseBody = blob.valueOf(jsonResponse);
                        }   
                        else if(conProv[0].IAM_Status__c == 'Pending'){
                            response.statusCode = 200;
                            jsonResponse = jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" , \n"ReturnCode":"202",\n"Message": "Subscription is pending.",\n"appName": "'+conProv[0].IAM_Application_Name__c+'" ,\n"accountNumber":"'+conProv[0].IAM_Contact__r.Account.CMI_CId__c+'",\n"emailAddress":"'+conProv[0].IAM_Contact__r.Email+'",\n"userName":"'+conProv[0].IAM_Contact__r.IAM_Contact_Status__c+'", \n"firstName": "'+conProv[0].IAM_Contact__r.firstName+'",\n"lastName": "'+conProv[0].IAM_Contact__r.LastName+'",\n"userStatus": "'+conProv[0].IAM_Contact__r.IAM_Contact_Status__c+'",\n"subscriptionStatus": "'+conProv[0].IAM_Status__c+'",\n"phoneNumber": "'+conProv[0].IAM_Contact__r.Phone+'",\n"role": "'+conProv[0].IAM_Role__c+'",\n"roleType": "'+conProv[0].IAM_User_Type__c+'",\n"accountAccess": "'+conProv[0].IAM_DA_Customer_List__c+'" ,\n"distributionChannel": "'+conProv[0].IAM_Contact__r.Account.CHANNEL_OF_DISTRIBUTION__c+'",\n"primaryMarketType": "'+conProv[0].IAM_Contact__r.Account.IAM_Primary_Market_Segment__c+'" ,\n"languagePreference": "'+conProv[0].IAM_Contact__r.Language_Preferences__c+'" \n}\n}';
                            response.responseBody = blob.valueOf(jsonResponse);
                            
                        }
                        
                        
                    }
                    else{
                        response.statusCode = 200;
                        jsonResponse = jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" , \n"ReturnCode":"422",\n"Message": "User update failed. Account does not present, or the account does not have active application or access with the required role, please check."}}';
                        response.responseBody = blob.valueOf(jsonResponse); 
                    }   
                }
                else{
                    response.statusCode = 200;
                    jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" , \n"ReturnCode":"409",\n"Message": "User update failed. User presents in a different account, please check the account# and ensure the account# between CDO and IAM is the same."}}';
                    response.responseBody = blob.valueOf(jsonResponse);
                }
            }
            else{
                response.statusCode = 200;
                jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" , \n"ReturnCode":"422",\n"Message": "User not found."}}';
                response.responseBody = blob.valueOf(jsonResponse);
            }
        }
        
        catch(DmlException e){
            Database.RollBack(sp);
            response.statusCode = 400;
            jsonResponse = jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" , \n"ReturnCode":"400",\n"Message": "'+e.getMessage()+'"}}';
            response.responseBody = blob.valueOf(jsonResponse);
            
        }
    }
    
    
    
    global class userInfo{
        public string appName{get;set;}
        public string accountNumber{get;set;}
        public string emailAddress{get;set;}
        public string userName{get;set;}
        public string firstName{get;set;}
        public string lastName{get;set;}
        public boolean isInternal{get;set;}
        public string phoneNumber{get;set;}
        public string subscriptionStatus{get;set;}
        public string role{get;set;}
        public string roleType{get;set;}
        public string accountAccess{get;set;} 
        public string languagePreference{get;set;}    
    }     
    
}