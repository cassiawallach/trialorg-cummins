/**********************************************************************
Name:FSL_JobContactInfo
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  This is the handler class for Contact Create and
Update
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 -   Sriprada Sesham    5/23/2019       INITIAL DEVELOPMENT
1.1 -   Shirisha Pedditi   6/14/2022       Added Named Credentials
***********************************************************************/

public class FSL_JobContactInfo {
    
    public static String Sender = 'CSS';
    public static String TargetERP;
    // final static string postEND_PONT = 'https://services-dev-oauth.cummins.com/api/oauth/token/css'; 
    // final static string JEND_point = 'https://services-dev.cummins.com/csswarranty/csscontact';
    
    public static CallOutResponseWrap checkContactId(string workOrderID, string accCode) {
        system.debug('workOrderID is : '+workOrderID);
        system.debug('accCode is : '+accCode);
        CallOutResponseWrap retWrap = new CallOutResponseWrap();
        string jsonReq = '';
        User usr = new User();
        usr = [SELECT Id, ERP__c 
               FROM User 
               WHERE Id =: UserInfo.getUserId() LIMIT 1];
        String TargetERP;
        TargetERP = (String)usr.ERP__c;
        
        List<FSL_Communication_Language__mdt> custLangList =  [SELECT Id,Language_Code__c,Language__c FROM FSL_Communication_Language__mdt];
        Map<String,String> langPrefMap = new Map<String,String>();
        if(!custLangList.isEmpty()){
            for(FSL_Communication_Language__mdt custData : custLangList){
                langPrefMap.put(custData.Language__c,custData.Language_Code__c);
            }
        }
        
        
        list<workOrder> listWo = new list<Workorder>();
        listWo = [SELECT Id, WorkOrderNumber, ServiceTerritory.Location_Code__c, ContactId, Contact.FSL_Contact_Id__c, Account.CSS_DistributorCode__c, Account.CSS_DBCode__c, 
                  Account.FSL_ERP_Customer_Code__c, Contact.Name, Contact.firstName, Contact.lastName, Contact.Phone, Contact.Email, Contact.Email_Notification_Frequency__c, 
                  Contact.Text_SMS_Notification_Frequency__c, Contact.Language_Preferences__c, Contact.MobilePhone 
                  FROM WorkOrder
                  WHERE Id =: workOrderID LIMIT 1]; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        if(listWo.size() > 0) {
            String position = listWo[0].ServiceTerritory.Location_Code__c;
            String subString = position.substringBefore('-');
            String subString2 = position.substringAfter('-').substring(0,5);
            String emailNA;
            String ContName;
            String woNumber;
            String EmailNotification;
            String TextNotification;
            String LanguagePreference;
            String NightlyCommunication;
            String MobilePhoneNumber;
            String SourceType= System.Label.FSL_Source_Environment_Type;
            if(SourceType == 'GZEVLPRD') {
                woNumber = listWo[0].WorkOrderNumber;
            } else {
                woNumber = SourceType.right(3)+'-'+listWo[0].WorkOrderNumber;
            }
            if(TargetERP == 'BMS') {
                position = subString + '-' + subString2;
                ContName = listWo[0].Contact.FirstName + ', ' +listWo[0].Contact.LastName;
                EmailNotification = (listWo[0].Contact.Email_Notification_Frequency__c == 'Real-Time' || listWo[0].Contact.Email_Notification_Frequency__c == 'Nightly') ? 'Y' : 'N';
                NightlyCommunication = listWo[0].Contact.Email_Notification_Frequency__c == 'Nightly'?'Y':'N';
                TextNotification = listWo[0].Contact.Text_SMS_Notification_Frequency__c == 'Real-Time'?'Y':'N';
                LanguagePreference = langPrefMap.get(listWo[0].Contact.Language_Preferences__c);
                MobilePhoneNumber = listWo[0].Contact.MobilePhone;
            } else {
                ContName = listWo[0].Contact.Name;
            }
            if (listWo[0].Contact.Email != '' && listWo[0].Contact.Email != null) {
                emailNA = 'N';
            } else {
                emailNA = 'Y';
            }
            //Added Changes for Named Credentials

            if(listWo[0].ContactId != null) {
                jsonReq = '{"Header":{"Sender":{"ServiceName":"CreateUpdateContact","SenderID":"CSS"},"Target":{"TargetID":"'+TargetERP+'"},"Location":{"LocationID":"'+position+'"}},"DataArea":{"DistributorCode":"'+subString+'","BranchCode":"'+subString2+'","JobContactName":"'+ContName+'","JobContactPhone":"'+listWo[0].Contact.Phone+'","CustomerCode":"'+accCode+'","ContactID":"'+listWo[0].Contact.FSL_Contact_Id__c+'","JobContactEmail":"'+listWo[0].Contact.Email+'","EmailNotAvailable":"'+emailNA+'","CSSJobID":"'+woNumber+'","EmailNotification":"'+EmailNotification+'","TextNotification":"'+TextNotification+'", "NightlyCommunication":"'+NightlyCommunication+'", "LanguagePreference":"'+LanguagePreference+'","MobilePhoneNumber":"'+MobilePhoneNumber+'"}}';
                jsonReq = jsonReq.replaceAll('"null"','""');

                retWrap = updateContactId(jsonReq,workOrderID);
            
                system.debug('Request is:'+ jsonReq);
                if(retWrap != null  &&  string.isNotBlank(retWrap.conObj.FSL_Contact_Id__c))
                {
                    retWrap.conObj.Id = listWo[0].ContactId;
                    // con.FSL_Contact_Id__c = conId;
                }
                if(retWrap.status == 'ERROR' || retWrap.status == 'FAIL') {
                    FSL_ApplicationLogger.insertFSLIntegrationErrorLog(jsonReq,String.valueOf(retWrap),'createUpdateContact','Error','BMS','','CSS');
                  }
            }
        }
        system.debug('retWrap is : '+retWrap);
        return retWrap;
    }
    
    public static CallOutResponseWrap updateContactId(string jsonReq, string workOrderID) {
        //Added Changes for Named Credentials
        CallOutResponseWrap retWrap = new CallOutResponseWrap();
        FSL_IP_NamedCredentialWrapper reqWrapper = new FSL_IP_NamedCredentialWrapper();
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        system.debug('jsonReq : '+jsonReq);
        	reqWrapper.methodType = 'POST';
	    	reqWrapper.NamedCredential = 'FSL_NC_Customers';
	    	reqWrapper.Path = '/contact';
            reqWrapper.WorkOrder=workOrderID;
	        reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint;//+reqWrapper.Path
            reqWrapper.jsonReqBody=jsonReq;
            returnWrapper=FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
      
        system.debug('response body : '+returnWrapper.response.getBody());
        string conId = '';
        string response = returnWrapper.response.getBody();
        string returnval;
        if(response.contains('"Status":')) {
            JSONParser parser = JSON.createParser(response);
            while (parser.nextToken() != null) {
                if(parser.getText() == 'Status') {
                    parser.nextToken();
                    retWrap.status = (parser.getText());
                    returnval = (parser.getText());  
                    //System.debug('recordId = '+token);
                }
            }
        }
        if(response.contains('"ContactID":')) {
            JSONParser parser = JSON.createParser(response);
            while (parser.nextToken() != null) {
                if(parser.getText() == 'ContactID') {
                    parser.nextToken();
                    conId = (parser.getText());
                    //System.debug('recordId = '+token);
                }
            } 
        }
        if(response.contains('"ReturnCodeDescription":') && (returnval == 'ERROR' || returnval == 'FAIL')) {
            JSONParser parser = JSON.createParser(response);
            while (parser.nextToken() != null) {
                if(parser.getText() == 'ReturnCodeDescription') {
                    parser.nextToken();
                    retWrap.msg = (parser.getText());   
                }
            }
        }
        Contact con = new Contact ();
        con.FSL_Contact_Id__c = conId;
        retWrap.conObj = con;
        //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),httpRes.getBody(),Null,Null,'JobContactInfo',httpRes.getStatus(),'code','toolid',''));
        //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),httpRes.getBody(),Null,Null,'FSL_JobContactInfo',httpRes.getStatus(),'code','Guidanz',Sender,Null,TargetERP));  
        return retWrap;
    }
    
    //Payer Contact Integration
    public static CallOutResponseWrap checkPayerContactId(string workOrderID, string accCode) {
        system.debug('workorder id :'+workOrderID);
        CallOutResponseWrap retWrap1 = new CallOutResponseWrap();
        
        List<FSL_Communication_Language__mdt> custLangList = [SELECT Id,Language_Code__c,Language__c FROM FSL_Communication_Language__mdt];
        Map<String,String> langPrefMap = new Map<String,String>();
        if(!custLangList.isEmpty()){
            for(FSL_Communication_Language__mdt custData : custLangList){
                langPrefMap.put(custData.Language__c,custData.Language_Code__c);
            }   
        }
        
        string jsonReq ='';
        User usr = new User();
        usr = [SELECT Id, ERP__c 
               FROM User 
               WHERE Id =: UserInfo.getUserId() LIMIT 1];
        String TargetERP;
        TargetERP = (String)usr.ERP__c;
        
        list<workOrder> listWo =[SELECT Id,Status,Category1__c,Process_Step__c,Application__c, WorkOrderNumber, ServiceTerritory.Location_Code__c, Account.CSS_DistributorCode__c, Account.CSS_DBCode__c, Account.FSL_ERP_Customer_Code__c, 
                  Payer_ContactID__c, Payer_ContactID__r.Name, Payer_ContactID__r.FirstName, Payer_ContactID__r.LastName, Payer_ContactID__r.Phone, Payer_ContactID__r.Email, 
                  Payer_ContactID__r.FSL_Contact_Id__c, ContactId, Contact.Name, Contact.firstName, Contact.lastName, Contact.Phone, Contact.Email, 
                  Contact.Email_Notification_Frequency__c, Contact.Text_SMS_Notification_Frequency__c, Contact.Language_Preferences__c, Contact.MobilePhone 
                  FROM WorkOrder
                  WHERE Id =: workOrderID LIMIT 1]; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        if(listWo.size() > 0) {
            String position = listWo[0].ServiceTerritory.Location_Code__c;
            String subString = position.substringBefore('-');
            String subString2 = position.substringAfter('-').substring(0,5);
            String emailNA;
            String payerContactName;
            String woNumber;
            String SourceType= System.Label.FSL_Source_Environment_Type;
            String EmailNotification;
            String TextNotification;
            String NightlyCommunication;
            String LanguagePreference;
            String MobilePhoneNumber;
            if(SourceType == 'GZEVLPRD') {
                woNumber = listWo[0].WorkOrderNumber;
            } else {
                woNumber = SourceType.right(3)+'-'+listWo[0].WorkOrderNumber;
            }
            if(TargetERP == 'BMS') {
                position = subString + '-' + subString2;
                payerContactName = listWo[0].Payer_ContactID__r.FirstName +', '+listWo[0].Payer_ContactID__r.LastName;
                EmailNotification = (listWo[0].Contact.Email_Notification_Frequency__c == 'Real-Time' || listWo[0].Contact.Email_Notification_Frequency__c == 'Nightly') ? 'Y' : 'N';
                NightlyCommunication = listWo[0].Contact.Email_Notification_Frequency__c == 'Nightly'?'Y':'N';
                TextNotification = listWo[0].Contact.Text_SMS_Notification_Frequency__c == 'Real-Time'?'Y':'N';
                LanguagePreference = langPrefMap.get(listWo[0].Contact.Language_Preferences__c);
                MobilePhoneNumber = listWo[0].Contact.MobilePhone;
            } else {
                payerContactName = listWo[0].Payer_ContactID__r.Name;
            }
            if (listWo[0].Contact.Email != '' && listWo[0].Contact.Email != null) {
                emailNA = 'N';
            } else {
                emailNA = 'Y';
            }
         
            if(listWo[0].Payer_ContactID__c != null && listWo[0].Payer_ContactID__c != listWo[0].ContactId) {
                jsonReq = '{"Header":{"Sender":{"ServiceName":"CreateUpdateContact","SenderID":"CSS"},"Target":{"TargetID":"'+TargetERP+'"},"Location":{"LocationID":"'+position+'"}},"DataArea":{"DistributorCode":"'+subString+'","BranchCode":"'+subString2+'","JobContactName":"'+payerContactName+'","JobContactPhone":"'+listWo[0].Payer_ContactID__r.Phone+'","CustomerCode":"'+accCode+'","ContactID":"'+listWo[0].Payer_ContactID__r.FSL_Contact_Id__c+'","JobContactEmail":"'+listWo[0].Payer_ContactID__r.Email+'","EmailNotAvailable":"'+emailNA+'","CSSJobID":"'+woNumber+'","EmailNotification":"'+EmailNotification+'","TextNotification":"'+TextNotification+'", "NightlyCommunication":"'+NightlyCommunication+'", "LanguagePreference":"'+LanguagePreference+'","MobilePhoneNumber":"'+MobilePhoneNumber+'"}}';
                jsonReq = jsonReq.replaceAll('"null"','""');
   
                retWrap1 = updatePayerContactId(jsonReq,workOrderID);//Added Changes for Named Credentials
                system.debug('Request is:'+ jsonReq);
                if(retWrap1 != null  &&  string.isNotBlank(retWrap1.conObj.FSL_Contact_Id__c))
                {
                    retWrap1.conObj.Id = listWo[0].Payer_ContactID__c;
                    // con.FSL_Contact_Id__c = conId;
                }
            }
        }
        system.debug('retWrap1 is : '+retWrap1);
        return retWrap1;
    }

    public static CallOutResponseWrap updatePayerContactId(string jsonReq, string workOrderID) {
        //Added Changes for Named Credentials
        CallOutResponseWrap retWrap1 = new CallOutResponseWrap();
        FSL_IP_NamedCredentialWrapper reqWrapper = new FSL_IP_NamedCredentialWrapper();
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        system.debug('jsonReq : '+jsonReq);
           reqWrapper.methodType = 'POST';
	    	reqWrapper.NamedCredential = 'FSL_NC_Customers';
	    	reqWrapper.Path = '/contact';
	        reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint;//+reqWrapper.Path
            reqWrapper.jsonReqBody=jsonReq;
            returnWrapper=FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
        system.debug('response body : '+returnWrapper.response.getBody());
        string conId = '';
        string response = returnWrapper.response.getBody();
                system.debug('status is : '+returnWrapper.response.getStatus());
        system.debug('status code is : '+returnWrapper.response.getStatusCode());
        system.debug('response is : '+returnWrapper.response);
        string returnval;
        if(response.contains('"Status":')) {
            JSONParser parser = JSON.createParser(response);
            while (parser.nextToken() != null) {
                if(parser.getText() == 'Status') {
                    parser.nextToken();
                    retWrap1.status = (parser.getText());
                    returnval = (parser.getText());  
                    //System.debug('recordId = '+token);
                }
            }
        }
        if(response.contains('"ContactID":')) {
            JSONParser parser = JSON.createParser(response);
            while (parser.nextToken() != null) {
                if(parser.getText() == 'ContactID') {
                    parser.nextToken();
                    conId = (parser.getText());
                    //System.debug('recordId = '+token);
                }
            } 
        }
        if(response.contains('"ReturnCodeDescription":') && (returnval == 'ERROR' || returnval == 'FAIL')) {
            JSONParser parser = JSON.createParser(response);
            while (parser.nextToken() != null) {
                if(parser.getText() == 'ReturnCodeDescription') {
                    parser.nextToken();
                    retWrap1.msg = (parser.getText());
                    // System.debug('recordId = '+token);
                }
            }
        }
        Contact con = new Contact ();
        con.FSL_Contact_Id__c = conId;
        retWrap1.conObj = con;
        //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),httpRes.getBody(),Null,Null,'JobContactInfo',httpRes.getStatus(),'code','toolid',''));
        //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),httpRes.getBody(),Null,Null,'FSL_JobContactInfo',httpRes.getStatus(),'code','Guidanz',Sender,Null,TargetERP));  
        return retWrap1;
    }
    
    public class CallOutResponseWrap {
        Public Contact conObj;
        Public string status;
        Public string msg;
    }
}