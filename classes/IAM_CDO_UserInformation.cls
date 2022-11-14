/************************************************************
Name:  IAM_CDO_UserInformation
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
1.0 -    Sandeep Vuyyuru	     30/05/2022         INITIAL DEVELOPMENT  
*****************************************************/
@RestResource(urlMapping='/IAM_CDO_UserInformation/*')
global class IAM_CDO_UserInformation {
    
    @HttpPost
    Global static void doGet(List<getUserInfo> getUserInfo)
    { 
        String jsonResponse = '';
        String uName = '';
        String body = '';        
        System.debug('***getUserInputValues***'+getUserInfo);
        RestRequest req = RestContext.request;
        RestResponse response = RestContext.response; 
        response.addHeader('Content-Type','applicatin/json'); 
        String ContentType = RestContext.request.headers.get('Content-Type');       
        //String usernameuri = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Map<String,IAM_Contact_Provisioning__c> conRecMap = new Map<String,IAM_Contact_Provisioning__c>();
        Set<String> userMail = new Set<String>();
        Set<String> userNamePresent = new Set<String>();
        Set<String> userNameNotP = new Set<String>();
        List<getUserInfo> wrapinfo = new List<getUserInfo>();        
        for(getUserInfo wraprec: getUserInfo){
            userMail.add(wraprec.userName);
            System.debug('Usermail for the set'+userMail);
        }
        
        try{
            
            //List<Contact> getConProvList = [Select id,Phone,Account.CHANNEL_OF_DISTRIBUTION__c,Account.IAM_Primary_Market_Segment__c,Account.CMI_CId__c,Account.Id,Name,Username__c,Email,FirstName,LastName,IAM_Contact_Status__c,(Select id,Name,IAM_Role__c From Contact_Provisionings__r WHERE IAM_Application_Name__c = 'Connected Solutions' AND IAM_Status__c IN ('Active','Pending')) from Contact WHERE Username__c IN:userMail];
            //List<IAM_Contact_Provisioning__c> getConProvList = [Select id,Name,IAM_Contact__r.FirstName,IAM_Contact__r.LastName,IAM_Contact__r.Email,IAM_Contact__r.Phone,IAM_DA_Customer_List__c,IAM_Contact__r.username__c,IAM_Role__c,IAM_Contact__r.Account.CMI_CId__c,IAM_Contact__r.IAM_Contact_Status__c,IAM_Contact__r.Account.CHANNEL_OF_DISTRIBUTION__c,IAM_Contact__r.Account.IAM_Primary_Market_Segment__c,IAM_Contact__r.Language_Preferences__c,IAM_Status__c FROM IAM_Contact_Provisioning__c WHERE IAM_Application_Name__c='Connected Solutions' AND IAM_Status__c IN ('Active','Pending','Inactive') AND IAM_Contact__r.Username__c IN:userMail];
              List<IAM_Contact_Provisioning__c> getConProvList = [Select id,Name,IAM_Contact__r.FirstName,IAM_Contact__r.LastName,IAM_Contact__r.Email,IAM_Contact__r.Phone,IAM_DA_Customer_List__c,IAM_Contact__r.username__c,IAM_Role__c,IAM_Contact__r.Account.CMI_CId__c,IAM_Contact__r.IAM_Contact_Status__c,IAM_Contact__r.Account.CHANNEL_OF_DISTRIBUTION__c,IAM_Contact__r.Account.IAM_Primary_Market_Segment__c,IAM_Contact__r.Language_Preferences__c,IAM_Status__c FROM IAM_Contact_Provisioning__c WHERE IAM_Application_Name__c='Connected Solutions' AND IAM_Status__c IN ('Active','Pending') AND IAM_Contact__r.Username__c IN:userMail];
            system.debug('Contactprovision list'+getConProvList);
            for(IAM_Contact_Provisioning__c con1:getConProvList){
                if(!conRecMap.containsKey(con1.IAM_Contact__r.username__c)){
                    conRecMap.put(con1.IAM_Contact__r.username__c,con1);
                    System.debug('map of values'+conRecMap);
                } 
            } 
                                   
            if(!userMail.isEmpty()){
                for(String ss : userMail){ 
                    System.debug('This is for if entrance'+conRecMap.get(ss));
                    if(conRecMap.get(ss) != null){//checking if conRecMap has this username
                        userNamePresent.add(ss);//if present then add username in list
                        
                        getUserInfo wrap = new getUserInfo(); 
                        wrap.userName = ss ;  
                        wrap.accountNumber = conRecMap.get(ss).IAM_Contact__r.Account.CMI_CId__c;
                        wrap.firstName = conRecMap.get(ss).IAM_Contact__r.firstName;
                        wrap.lastName = conRecMap.get(ss).IAM_Contact__r.lastName;
                        wrap.emailAddress = conRecMap.get(ss).IAM_Contact__r.Email;
                        wrap.phoneNumber = conRecMap.get(ss).IAM_Contact__r.Phone;
                        wrap.role = conRecMap.get(ss).IAM_Role__c;
                        wrap.userStatus = conRecMap.get(ss).IAM_Contact__r.IAM_Contact_Status__c;
                        wrap.subscriptionStatus = conRecMap.get(ss).IAM_Status__c;
                        wrap.accountAccess = conRecMap.get(ss).IAM_DA_Customer_List__c;
                        wrap.distributionChannel = conRecMap.get(ss).IAM_Contact__r.Account.CHANNEL_OF_DISTRIBUTION__c;
                        wrap.primaryMarketType = conRecMap.get(ss).IAM_Contact__r.Account.IAM_Primary_Market_Segment__c;
                        wrap.languagePreference = conRecMap.get(ss).IAM_Contact__r.Language_Preferences__c;
                        wrap.userExists = 'Y';
                        wrapinfo.add(wrap);                        
                        System.debug('this is second'+wrapinfo);
                        body = JSON.serializePretty(wrapinfo);
                    }else {
                        getUserInfo wrap = new getUserInfo(); 
                        userNameNotP.add(ss);//if not present then add username in this list
                        wrap.userName = ss; 
                        wrap.userExists = 'N';
                        wrapinfo.add(wrap);                        
                        System.debug('this is third'+wrapinfo);
                        body = JSON.serializePretty(wrapinfo);
                    }
                }
                
            }
            
            else{
                System.debug('Inside else');
                response.statusCode = 200;
                jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" ,\n"isExistingUser":"false", \n"ReturnCode":"422",\n"Message": "User not found,or the user does not have access to subscription "}}';
                response.responseBody = blob.valueOf(jsonResponse);
                
            }
            
            response.responsebody = Blob.valueOf(body);  
            response.statusCode = 200;
            
        }
        
        Catch(Exception e){
            
        }
    } 
    global class getUserInfo{
        public getUserInfo() {}
        public String accountNumber{get;set;}
        public String userName{get;set;} 
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String emailAddress{get;set;}
        public String phoneNumber{get;set;}
        public string role{get;set;}
        public string userStatus{get;set;}
        public string subscriptionStatus{get;set;}
        public String userExists{get;set;}
        public String accountAccess{get;set;}
        public String distributionChannel{get;set;}
        public String primaryMarketType{get;set;}
        public string languagePreference{get;set;} 
    }
    
}