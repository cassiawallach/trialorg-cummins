public class FSL_ContactUpdateToBMS {
    
    @InvocableMethod(label='UpdateContactToBMS' description='Update contact to BMS' category='Contact')
    public static void ContactUpdateBMS(List<Id> ContactId) {
        
        try {
            system.debug('inside bms class');
            CallOutResponseWrap retWrap = new CallOutResponseWrap();
            string jsonReq = '';
            User usr = new User();
            usr = [SELECT Id, ERP__c , FSL_Primary_Service_Territory_Code__c 
                   FROM User 
                   WHERE Id =: UserInfo.getUserId() LIMIT 1];
            string primaryServiceCode;
            if(usr.FSL_Primary_Service_Territory_Code__c != null){
                primaryServiceCode = string.valueOf(usr.FSL_Primary_Service_Territory_Code__c);
            }
            String TargetERP;
            TargetERP = (String)usr.ERP__c;
            
            List<FSL_Communication_Language__mdt> custLangList =  [SELECT Id,Language_Code__c,Language__c FROM FSL_Communication_Language__mdt];
            Map<String,String> langPrefMap = new Map<String,String>();
            if(!custLangList.isEmpty()){
                for(FSL_Communication_Language__mdt custData : custLangList){
                    langPrefMap.put(custData.Language__c,custData.Language_Code__c);
                }
            }
            
            list<Contact> contactLst = new list<Contact>();
            contactLst = [SELECT Id, Name, firstName,Work_Order__r.ServiceTerritory.Location_Code__c, lastName, Phone,Email,Email_Notification_Frequency__c,Text_SMS_Notification_Frequency__c,
                          Language_Preferences__c,MobilePhone,Account.FSL_ERP_Customer_Code__c, FSL_Contact_Id__c
                          FROM Contact
                          WHERE Id =: ContactId LIMIT 1];
            if(contactLst.size() > 0) {
                string subStr = '%'+primaryServiceCode+'%';
                list<ServiceTerritory> servTerr = [SELECT Id, Name, Location_Code__c FROM ServiceTerritory where Location_Code__c like: subStr];
                String position;
                if(servTerr.size() > 0){
                    position = servTerr[0].Location_Code__c;
                }
                if(test.isRunningTest()){
                    position = '02198-Itrewe';
                }
                //String position = contactLst[0].Work_Order__r.ServiceTerritory.Location_Code__c;
                
                String emailNA;
                //String DistributorCode = '04959';
                //String BranchCode = '04977';
                String ContName;
                String woNumber;
                String EmailNotification;
                String TextNotification;
                String LanguagePreference;
                String NightlyCommunication;
                String MobilePhoneNumber;
                String DistributorCode = position.substringBefore('-');
                String BranchCode = position.substringAfter('-').substring(0,5);
                
                //string position ;
                //String SourceType= system.Label.FSL_Source_Environment_Type;
                string acccode=ContactLst[0].Account.FSL_ERP_Customer_Code__c;
                
                if(TargetERP == 'BMS') {
                    //  position = subString + '-' + subString2;
                    ContName = contactLst[0].FirstName + ', ' +contactLst[0].LastName;
                    //EmailNotification = listWo[0].Contact.Email_Notifications__c == true?'Y':'N';
                    EmailNotification = (contactLst[0].Email_Notification_Frequency__c == 'Real-Time' || contactLst[0].Email_Notification_Frequency__c == 'Nightly') ? 'Y' : 'N';
                    NightlyCommunication = contactLst[0].Email_Notification_Frequency__c == 'Nightly'?'Y':'N';
                    TextNotification = contactLst[0].Text_SMS_Notification_Frequency__c == 'Real-Time'?'Y':'N';
                    LanguagePreference = langPrefMap.get(contactLst[0].Language_Preferences__c);
                    MobilePhoneNumber = contactLst[0].MobilePhone;
                } else {
                    ContName = contactLst[0].Name;
                }
                if (contactLst[0].Email != '' && contactLst[0].Email != null) {
                    emailNA = 'N';
                } else {
                    emailNA = 'Y';
                }
                
                if(contactLst[0].Id != null) {
                    system.debug('inside first if of contact');
                    
                    //Updated distributor and branch code from location code dynamically
                    jsonReq = '{"Header":{"Sender":{"ServiceName":"CreateUpdateContact","SenderID":"CSS"},"Target":{"TargetID":"'+TargetERP+'"},"Location":{"LocationID":"'+position+'"}},"DataArea":{"JobContactName":"'+ContName+'","DistributorCode":"'+DistributorCode+'","BranchCode":"'+BranchCode+'","JobContactPhone":"'+ContactLst[0].Phone+'","CustomerCode":"'+accCode+'","ContactID":"'+ContactLst[0].FSL_Contact_Id__c+'","JobContactEmail":"'+ContactLst[0].Email+'","EmailNotAvailable":"'+emailNA+'","CSSJobID":"'+woNumber+'","EmailNotification":"'+EmailNotification+'","TextNotification":"'+TextNotification+'", "NightlyCommunication":"'+NightlyCommunication+'", "LanguagePreference":"'+LanguagePreference+'","MobilePhoneNumber":"'+MobilePhoneNumber+'"}}';
                    // jsonReq = '{"Header":{"Sender":{"ServiceName":"CreateUpdateContact","SenderID":"CSS"},"Target":{"TargetID":"'+TargetERP+'"},"Location":{"LocationID":"'+position+'"}},"DataArea":{"DistributorCode":"'+subString+'","BranchCode":"'+subString2+'","JobContactName":"'+ContName+'","JobContactPhone":"'+listWo[0].Contact.Phone+'","CustomerCode":"'+accCode+'","ContactID":"'+listWo[0].Contact.FSL_Contact_Id__c+'","JobContactEmail":"'+listWo[0].Contact.Email+'","EmailNotAvailable":"'+emailNA+'","CSSJobID":"'+woNumber+'","EmailNotification":"'+EmailNotification+'","TextNotification":"'+TextNotification+'", "NightlyCommunication":"'+NightlyCommunication+'", "LanguagePreference":"'+LanguagePreference+'","MobilePhoneNumber":"'+MobilePhoneNumber+'"}}';
                    
                    jsonReq = jsonReq.replaceAll('"null"','""');
                    //Added Changes for Named Credentials(changed the parameters of the method)
                    updateContactId(jsonReq,ContactId);
                    system.debug('retWrap is  :::'+retWrap);
                    if(retWrap != null  &&  string.isNotBlank(retWrap.conObj.FSL_Contact_Id__c))
                    {
                        retWrap.conObj.Id = ContactLst[0].Id;
                    }
                }
            }
        } catch(Exception e) {
            system.debug('** Exception occured while updating contact to BMS'+e.getMessage());
            system.debug('** Exception occured while updating contact to BMS'+e.getLineNumber());
        }
    }
    
    @future(callout= true)
    public static void updateContactId(string jsonReq,List<Id> ContactId) {
        system.debug('updateContactId method////////');
        //Added Changes for Named Credentials
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        CallOutResponseWrap retWrap = new CallOutResponseWrap();
        FSL_IP_NamedCredentialWrapper reqWrapper = new FSL_IP_NamedCredentialWrapper();
        try {
             //Added Changes for Named Credentials
            reqWrapper.methodType = 'POST';
            reqWrapper.NamedCredential = 'FSL_NC_Customers';
            reqWrapper.Path = '/contact';
            reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint;//+reqWrapper.Path
            reqWrapper.jsonReqBody=jsonReq;
            returnWrapper=FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
            string conId = '';
            string response = returnWrapper.response.getBody();
            system.debug('response is : '+response);
            string returnval;
            if(response.contains('"Status":')) {
                system.debug('response contains Status : ');
                JSONParser parser = JSON.createParser(response);
                while (parser.nextToken() != null) {
                    if(parser.getText() == 'Status') {
                        parser.nextToken();
                        retWrap.status = (parser.getText());
                        returnval = (parser.getText());  
                    }
                }
            }
            if(response.contains('"ContactID":')) {
                system.debug('response contains ContactID : ');
                JSONParser parser = JSON.createParser(response);
                while (parser.nextToken() != null) {
                    if(parser.getText() == 'ContactID') {
                        parser.nextToken();
                        if((parser.getText()) != '0') {
                            conId = (parser.getText());
                        }
                    }
                } 
            }
            if(response.contains('"ReturnCodeDescription":') && (returnval == 'ERROR' || returnval == 'FAIL')) {
                system.debug('response contains ReturnCodeDescription : ');
                JSONParser parser = JSON.createParser(response);
                while (parser.nextToken() != null) {
                    if(parser.getText() == 'ReturnCodeDescription') {
                        parser.nextToken();
                        retWrap.msg = (parser.getText());
                    }
                }
                
                //Error logging
                //           FSL_ApplicationLogger.insertFSLIntegrationErrorLog(jsonReq,httpRes.getBody(),endPoint,httpres.getStatus(),'Mule','toolId','CSS');
            }
            system.debug('retWrap is /////// :'+retWrap);
            Contact con = new Contact ();
            List<Contact >contactLst = [SELECT Id, Name, FirstName, Work_Order__r.ServiceTerritory.Location_Code__c, LastName, Phone, Email, Email_Notification_Frequency__c, 
                                        Text_SMS_Notification_Frequency__c, Language_Preferences__c, MobilePhone, Account.FSL_ERP_Customer_Code__c, FSL_Contact_Id__c 
                                        FROM Contact 
                                        WHERE Id =: ContactId LIMIT 1];
            if(contactLst.size() > 0) {
                con.Id = contactLst[0].Id;
                if(contactLst[0].FSL_Contact_Id__c == null || contactLst[0].FSL_Contact_Id__c == '') {
                    con.FSL_Contact_Id__c = conId;
                }
            }
            retWrap.conObj = con;
            if(returnWrapper.response.getStatusCode() == 200) {
                update retWrap.conObj;
            }else{               
                string error = 'Error in getting response. Status code>>>>' +returnWrapper.response.getStatusCode();
                //Error logging
                //     FSL_ApplicationLogger.insertFSLIntegrationErrorLog(jsonReq,String.valueOf(returnWrapper),endPoint,'Error','Mule','toolId','CSS');
            }
        }
        
        catch(exception e) {
            system.debug('Entered into catch of Mule token Method in CG_WS_Mule>>>'+e.getMessage() +e.getLineNumber());
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = 'Some error in getting Mule response : '+e.getMessage();
            returnWrapper.appName = 'MuleToken';
            //   returnWrapper.endPoint = endPoint1;
            FSL_ApplicationLogger.insertFSLIntegrationErrorLog(jsonReq,returnWrapper.errorMessage,returnWrapper.endPoint,'Error','Mule','toolId','CSS');            
        }
    } 
    public class CallOutResponseWrap {
        Public Contact conObj;
        Public string status;
        Public string msg;
    }
}