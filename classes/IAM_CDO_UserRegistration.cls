/************************************************************
Name:  IAM_CDO_UserResgistration
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
1.0 -    Sandeep Vuyyuru	     10/05/2022         INITIAL DEVELOPMENT  
2.0      Sandeep Vuyyuru         30/08/2022         Changes related to s360 portal
*****************************************************/
@RestResource(urlMapping='/IAM_CDO_UserRegistration/*')
Global without sharing class IAM_CDO_UserRegistration
{   
    @HttpPost
    Global static void doPost(userInfo userInfo)
    {  
        
        userInfo usercreationInfo = userInfo;        
        
        if(usercreationInfo.appName == 'CDO'){
            cdoRelated(usercreationInfo);
        }
        else if(usercreationInfo.appName == Label.IAM_AppName_s360){
            createSupplier360(usercreationInfo);
        }
    }
    public static void cdoRelated(IAM_CDO_UserRegistration.userInfo usercreationInfo){
        String jsonResponse = '';
        
        IAM_Contact_Provisioning__c cdoConProv2= new IAM_Contact_Provisioning__c();
        
        //userInfo usercreationInfo = userInfo;
        
        RestRequest req = RestContext.request;
        RestResponse response = RestContext.response; 
        response.addHeader('Content-Type','applicatin/json'); 
        String ContentType = RestContext.request.headers.get('Content-Type');
        Savepoint sp = Database.setSavepoint();       
        try{        
            
            List<IAM_Application__c> accountCheck =[select id,IAM_Account_Name__r.CHANNEL_OF_DISTRIBUTION__c,IAM_Account_Name__r.IAM_Primary_Market_Segment__c,IAM_Account_Name__r.CMI_CId__c,IAM_Application_Name__c,IAM_Account_Name__r.id,IAM_Subscription_Start_Date__c,IAM_Subscription_End_Date__c from IAM_Application__c where IAM_Account_Name__r.CMI_CId__c=:usercreationInfo.accountNumber AND  IAM_Application_Name__c = 'Connected Solutions' AND IAM_Status__c = 'Active' AND IAM_Role__c includes(:usercreationInfo.role) LIMIT 1];
            
            if(!accountCheck.isEmpty()){  
                
                List<Contact> duplicateCon = [Select id,Phone,Account.CHANNEL_OF_DISTRIBUTION__c,Account.IAM_Primary_Market_Segment__c,Account.CMI_CId__c,Account.Id,Name,Username__c,Email,FirstName,LastName,IAM_Contact_Status__c, Language_Preferences__c, (Select id,Name From Contact_Provisionings__r WHERE IAM_Application_Name__c = 'Connected Solutions' AND IAM_Status__c IN ('Active','Pending')) from Contact WHERE Username__c =: usercreationInfo.userName LIMIT 1];
                
                
                
                if(duplicateCon.size()<1){
                    
                    Contact listCon = new Contact();
                    listCon.FirstName = usercreationInfo.firstName;
                    listCon.Email = usercreationInfo.emailAddress;
                    listCon.LastName = usercreationInfo.lastName;
                    listCon.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                    listCon.accountID = accountCheck[0].IAM_Account_Name__r.id;
                    listCon.Username__c = usercreationInfo.userName;
                    listCon.IAM_Contact_Status__c = 'Active';
                    listCon.Phone = usercreationInfo.phoneNumber;
                    listCon.Language_Preferences__c = usercreationInfo.languagePreference;
                    insert listCon;  
                    
                    IAM_Contact_Provisioning__c cdoConProv= new IAM_Contact_Provisioning__c();
                    cdoConProv.IAM_Application_Name__c= System.Label.IAM_AppName_ConnectedSolutions;
                    cdoConProv.IAM_Role__c=usercreationInfo.role;
                    cdoConProv.IAM_Account_Application__c=accountCheck[0].id;
                    cdoConProv.IAM_Status__c='Active';
                    cdoConProv.IAM_Start_Date__c=accountCheck[0].IAM_Subscription_Start_Date__c;
                    cdoConProv.IAM_End_Date__c=accountCheck[0].IAM_Subscription_End_Date__c; 
                    cdoConProv.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
                    cdoConProv.IAM_Contact__C=listCon.Id;
                    cdoConProv.IAM_DA_Customer_List__c = usercreationInfo.accountAccess;
                    cdoConProv.IAM_User_Type__c = usercreationInfo.roleType;  
                    cdoConProv.IAM_From_CDO__c = true;                  
                    insert  cdoConProv; 
                    
                    response.statusCode = 200;
                    jsonResponse = '{"response": \n{\n"Status": "Success", \n"isSuccess":"True" ,\n"isExistingUser":"False", \n"ReturnCode":"201", \n"Message": "Success : User is created Successfully", \n"appName": "'+cdoConProv.IAM_Application_Name__c+'" ,\n"accountNumber":"'+usercreationInfo.accountNumber+'",\n"emailAddress":"'+listCon.Email+'",\n"userName":"'+listCon.Username__c+'", \n"firstName": "'+listCon.FirstName+'",\n"lastName": "'+listCon.LastName+'",\n"userStatus": "'+listCon.IAM_Contact_Status__c+'",\n"subscriptionStatus": "'+cdoConProv.IAM_Status__c+'",\n"phoneNumber": "'+usercreationInfo.phoneNumber+'",\n"role": "'+cdoConProv.IAM_Role__c+'",\n"roleType": "'+cdoConProv.IAM_User_Type__c+'",\n"accountAccess": "'+usercreationInfo.accountAccess+'" ,\n"distributionChannel": "'+accountCheck[0].IAM_Account_Name__r.CHANNEL_OF_DISTRIBUTION__c+'",\n"primaryMarketType": "'+accountCheck[0].IAM_Account_Name__r.IAM_Primary_Market_Segment__c+'",\n"languagePreference": "'+listCon.Language_Preferences__c+'" \n}\n}';
                    response.responseBody = blob.valueOf(jsonResponse);
                }
                else if(duplicateCon[0].Account.Id != accountCheck[0].IAM_Account_Name__r.Id){
                    response.statusCode = 200;
                    jsonResponse = jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" ,\n"isExistingUser":"True", \n"ReturnCode":"409",\n"Message": "User creation failed. User presents in a different account, please check the account# and ensure the account# between CDO and IAM is the same."}}';
                    response.responseBody = blob.valueOf(jsonResponse);
                    
                }
                
                else if(duplicateCon[0].Contact_Provisionings__r.size()<1){
                    //IAM_Contact_Provisioning__c cdoConProv= new IAM_Contact_Provisioning__c();
                    cdoConProv2.IAM_Application_Name__c= System.Label.IAM_AppName_ConnectedSolutions;
                    cdoConProv2.IAM_Role__c=usercreationInfo.role;
                    cdoConProv2.IAM_Account_Application__c=accountCheck[0].id;
                    cdoConProv2.IAM_Status__c='Active';
                    cdoConProv2.IAM_Start_Date__c=accountCheck[0].IAM_Subscription_Start_Date__c;
                    cdoConProv2.IAM_End_Date__c=accountCheck[0].IAM_Subscription_End_Date__c; 
                    cdoConProv2.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
                    cdoConProv2.IAM_Contact__C=duplicateCon[0].Id;
                    cdoConProv2.IAM_DA_Customer_List__c = usercreationInfo.accountAccess;
                    cdoConProv2.IAM_User_Type__c = usercreationInfo.roleType;
                    cdoConProv2.IAM_From_CDO__c = true;
                    insert  cdoConProv2; 
                    
                    response.statusCode = 200;
                    jsonResponse = '{"response": \n{\n"status": "Success", \n"isSuccess":"True" ,\n"isExistingUser":"True", \n"ReturnCode":"202", \n"Message": "Success : User already present, subscription added", \n"appName": "'+cdoConProv2.IAM_Application_Name__c+'" ,\n"accountNumber":"'+duplicateCon[0].Account.CMI_CId__c+'",\n"emailAddress":"'+duplicateCon[0].Email+'",\n"userName":"'+duplicateCon[0].Username__c+'", \n"firstName": "'+duplicateCon[0].FirstName+'",\n"lastName": "'+duplicateCon[0].LastName+'",\n"userStatus": "'+duplicateCon[0].IAM_Contact_Status__c+'",\n"subscriptionStatus": "'+cdoConProv2.IAM_Status__c+'",\n"phoneNumber": "'+duplicateCon[0].Phone+'",\n"role": "'+cdoConProv2.IAM_Role__c+'",\n"roleType": "'+cdoConProv2.IAM_User_Type__c+'",\n"accountAccess": "'+cdoConProv2.IAM_DA_Customer_List__c+'",\n"distributionChannel": "'+duplicateCon[0].Account.CHANNEL_OF_DISTRIBUTION__c+'",\n"primaryMarketType": "'+duplicateCon[0].Account.IAM_Primary_Market_Segment__c+'",\n"languagePreference": "'+duplicateCon[0].Language_Preferences__c+'" \n}\n}';
                    response.responseBody = blob.valueOf(jsonResponse);
                    
                }                
                else{
                    List<IAM_Contact_Provisioning__c> showConProvs = [Select id,Name,IAM_Application_Name__c,IAM_Status__c,IAM_DA_Customer_List__c,IAM_Role__c,IAM_User_Type__c FROM IAM_Contact_Provisioning__c WHERE IAM_Contact__r.Id =: duplicateCon[0].ID];
                    response.statusCode = 200;
                    jsonResponse = jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" ,\n"isExistingUser":"True", \n"ReturnCode":"202",\n"Message": "User already present, subscription present with status : '+showConProvs[0].IAM_Status__c+'", \n"appName": "'+showConProvs[0].IAM_Application_Name__c+'" ,\n"accountNumber":"'+duplicateCon[0].Account.CMI_CId__c+'",\n"emailAddress":"'+duplicateCon[0].Email+'",\n"userName":"'+duplicateCon[0].Username__c+'", \n"firstName": "'+duplicateCon[0].FirstName+'",\n"lastName": "'+duplicateCon[0].LastName+'",\n"userStatus": "'+duplicateCon[0].IAM_Contact_Status__c+'",\n"subscriptionStatus": "'+showConProvs[0].IAM_Status__c+'",\n"phoneNumber": "'+duplicateCon[0].Phone+'",\n"role": "'+showConProvs[0].IAM_Role__c+'",\n"roleType": "'+showConProvs[0].IAM_User_Type__c+'",\n"accountAccess": "'+showConProvs[0].IAM_DA_Customer_List__c+'",\n"distributionChannel": "'+duplicateCon[0].Account.CHANNEL_OF_DISTRIBUTION__c+'",\n"primaryMarketType": "'+duplicateCon[0].Account.IAM_Primary_Market_Segment__c+'",\n"languagePreference": "'+duplicateCon[0].Language_Preferences__c+'" \n}\n}';
                    response.responseBody = blob.valueOf(jsonResponse);
                }
                
                
            }
            
            else{
                response.statusCode = 200;
                jsonResponse = jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" , \n"ReturnCode":"422",\n"Message": "User creation failed. Account does not present, or the account does not have active application or access with the required role, please check."}}';
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
    
    public static void createSupplier360(IAM_CDO_UserRegistration.userInfo usercreationInfo){
        String jsonResponse = '';
        RestRequest req = RestContext.request;
        RestResponse response = RestContext.response; 
        response.addHeader('Content-Type','applicatin/json'); 
        String ContentType = RestContext.request.headers.get('Content-Type');
        Savepoint sp = Database.setSavepoint();
        try{
            List<Contact> dupCheckCon = [Select id,name,Username__c From Contact Where Username__c =: usercreationInfo.userName Limit 1];
            if(dupCheckCon.size()<1){
            List<IAM_Application__c> supplieApp = [Select id,Name,IAM_Application_Name__c,IAM_Account_Name__r.id,IAM_Subscription_Start_Date__c,IAM_Subscription_End_Date__c FROM IAM_Application__c WHERE IAM_Account_Name__r.Name = 'S360 Portal' AND IAM_Application_Name__c = 'S360 Portal' LIMIT 1];
            System.debug('printsupplier'+supplieApp);
            if(!supplieApp.isEmpty()){                
                
                Contact listCon = new Contact();
                listCon.FirstName = usercreationInfo.firstName;
                listCon.Email = usercreationInfo.emailAddress;
                listCon.LastName = usercreationInfo.lastName;
                listCon.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                listCon.accountID = supplieApp[0].IAM_Account_Name__r.id;
                listCon.Username__c = usercreationInfo.userName;
                listCon.IAM_Contact_Status__c = 'Active';
                listCon.Phone = usercreationInfo.phoneNumber;                    
                insert listCon;  
                System.debug('printingsupplicontact'+listCon);
                
                IAM_Contact_Provisioning__c cdoConProv= new IAM_Contact_Provisioning__c();
                cdoConProv.IAM_Application_Name__c= System.Label.IAM_AppName_s360;
                cdoConProv.IAM_Role__c= 'User';
                cdoConProv.IAM_Account_Application__c=supplieApp[0].id;
                cdoConProv.IAM_Status__c='Active';
                cdoConProv.IAM_Start_Date__c=supplieApp[0].IAM_Subscription_Start_Date__c;
                cdoConProv.IAM_End_Date__c=supplieApp[0].IAM_Subscription_End_Date__c; 
                cdoConProv.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('S360 Portal').getRecordTypeId();
                cdoConProv.IAM_Contact__C=listCon.Id; 
                insert  cdoConProv; 
                
                response.statusCode = 200;
                jsonResponse = '{"response": \n{\n"Status": "Success", \n"isSuccess":"True" ,\n"isExistingUser":"False", \n"ReturnCode":"201", \n"Message": "Success : User is created Successfully", \n"appName": "'+cdoConProv.IAM_Application_Name__c+'" ,\n"emailAddress":"'+listCon.Email+'",\n"userName":"'+listCon.Username__c+'", \n"firstName": "'+listCon.FirstName+'",\n"lastName": "'+listCon.LastName+'",\n"phoneNumber": "'+listCon.phone+'" \n}\n}';
                response.responseBody = blob.valueOf(jsonResponse);
                
            }
            }
            else{
                response.statusCode = 200;
                jsonResponse = jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" ,\n"isExistingUser":"True", \n"ReturnCode":"202",\n"Message": "User with this username is already present." }}';
                response.responseBody = blob.valueOf(jsonResponse);
            }
        }
        catch(exception ex){
            Database.RollBack(sp);
            response.statusCode = 400;
            System.debug('Exception ex '+ex.getLineNumber());
            jsonResponse = jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" , \n"ReturnCode":"400",\n"Message": "'+ex.getMessage()+'"}}';
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
        public string role{get;set;}
        public string roleType{get;set;}
        public string accountAccess{get;set;}
        public string languagePreference{get;set;}        
    }     
    
}