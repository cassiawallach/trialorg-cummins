/************************************************************
Name:  IAM_CDO_getUserByAccount
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
1.0 -    Sandeep Vuyyuru	     27/07/2022         INITIAL DEVELOPMENT  
*****************************************************/
@RestResource(urlMapping='/IAM_CDO_getUserByAccount/*')
global class IAM_CDO_getUserByAccount {
  
    @HttpGet
    Global static void doGet()
    { 
    String jsonResponse = '';        
        String body = '';  
        List<getUserInfo> wrapinfo = new List<getUserInfo>();
        RestRequest req = RestContext.request;
        RestResponse response = RestContext.response; 
        response.addHeader('Content-Type','applicatin/json'); 
        String ContentType = RestContext.request.headers.get('Content-Type'); 
        String accountNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        try{            
             //List<Contact> conList = [SELECT Id,username__c,firstName,lastName,Email,Account.CMI_CId__c FROM Contact WHERE Account.CMI_CId__c = :accountNumber];
             List<IAM_Contact_Provisioning__c> conList = [Select id,Name,IAM_Contact__r.firstName,IAM_Contact__r.lastName,IAM_Contact__r.Email,IAM_Contact__r.Username__c, IAM_Contact__r.Account.CMI_CId__c,IAM_Contact__r.IAM_Contact_Status__c,IAM_Role__c,IAM_DA_Calibaration_Role__c,IAM_Status__c,IAM_User_Type__c From IAM_Contact_Provisioning__c WHERE IAM_Application_Name__c = 'Connected Solutions' 
                                        AND IAM_Contact__r.Account.CMI_CId__c =: accountNumber AND IAM_Status__c IN ('Active','Pending')];
            if(!conList.isEmpty()){                 
                for(IAM_Contact_Provisioning__c con : conList){
                getUserInfo wrap = new getUserInfo();
                wrap.accountNumber = con.IAM_Contact__r.Account.CMI_CId__c;
                wrap.userName = con.IAM_Contact__r.username__c;
                wrap.firstName = con.IAM_Contact__r.firstName;
                wrap.lastName = con.IAM_Contact__r.lastName;
                wrap.emailAddress = con.IAM_Contact__r.Email;
                wrap.role = con.IAM_Role__c;
                wrap.roleType = con.IAM_User_Type__c;
                wrap.userStatus = con.IAM_Contact__r.IAM_Contact_Status__c;
                wrap.subscriptionStatus = con.IAM_Status__c;
                wrapinfo.add(wrap);
                body = JSON.serializePretty(wrapinfo);
                response.responsebody = Blob.valueOf(body);  
                response.statusCode = 200;
            }
            
        }
            else{
                response.statusCode = 200;
                jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" , \n"ReturnCode":"422",\n"Message": "Account number does not exist or does not have active subscription"}}';
                response.responseBody = blob.valueOf(jsonResponse);
                
            }
            
        }
        Catch(Exception e){            
            response.statusCode = 400;
            jsonResponse = jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" , \n"ReturnCode":"400",\n"Message": "'+e.getMessage()+'"}}';
            response.responseBody = blob.valueOf(jsonResponse);
        }
    }
    global class getUserInfo{
        public getUserInfo() {}
        public String accountNumber{get;set;}
        public String userName{get;set;}
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String emailAddress{get;set;}
        public String role{get;set;}
        public String roleType{get;set;}
        public String userStatus{get;set;}
        public string subscriptionStatus{get;set;}
    }
}