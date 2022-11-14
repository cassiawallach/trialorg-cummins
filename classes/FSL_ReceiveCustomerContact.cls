/*********************************************************************************************************************************
Name:FSL_ReceiveCustomerContact
Copyright © 2019  Cummins
===================================================================================================================================
===================================================================================================================================
Purpose:                                                            
This is the integration api expose class for Customer Contact details from MOVEX.
===================================================================================================================================
===================================================================================================================================
History                                                            
-------                                                            
VERSION                     AUTHOR                  DATE                            DETAIL                                
1.0 -                       PiyushR                 2/10/2019                       INITIAL DEVELOPMENT  
1.1 -                       Harsha                  5/03/2020                       MODIFICATIONS   
***************************************************************************************************************************************/
@RestResource(urlMapping='/CustomerContactData/*')
global class FSL_ReceiveCustomerContact {
    @HttpPost
    global static void doPostOperation() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        string str = FSL_ReceiveCustomerContact.handleContactRequest(req);
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(str);     
    }
    
    public static string handleContactRequest(RestRequest req) {
        
        list<FSL_CustomerContactWrapper.DataResponse> listResponses = new list<FSL_CustomerContactWrapper.DataResponse>();
        
        string msg;
        string jSONRequestBody = req.requestBody.toString().trim();
        String senderID;
        try { 
            FSL_CustomerContactWrapper obj = new FSL_CustomerContactWrapper();
            
            obj = (FSL_CustomerContactWrapper) System.JSON.deserialize(jSONRequestBody, FSL_CustomerContactWrapper.class); 
            senderID = obj.Header.Sender.SenderID;
            listResponses = contactResponseHandler(obj);
            msg =  '{"DataArea": '+json.serialize(listResponses)+',"Header":{"ReturnCodeDescription": "Record Processed Succesfully" ,"Status": "SUCCESS"}}';
        } 
        
        catch(Exception ex) {
            System.debug('Execption at line no :: '+ex.getLineNumber()+' Exception Message>>>is:  '+ex.getMessage() +'At : '+ ex.getLineNumber());
            msg = '{"ReturnCode":"401","ReturnCodeDescription":"'+ex.getMessage()+' At line :'+ ex.getLineNumber()+'"}'; 
        }
        return msg;
    }
    
    //handler method for job contact    
    public static list<FSL_CustomerContactWrapper.DataResponse> contactResponseHandler(FSL_CustomerContactWrapper obj) {       
        list<FSL_CustomerContactWrapper.DataResponse> listResponses = new list<FSL_CustomerContactWrapper.DataResponse>();
        List<FSL_Communication_Language__mdt> custLangList = [SELECT Id,Language_Code__c,Language__c FROM FSL_Communication_Language__mdt];
            Map<String,String> langPrefMap = new Map<String,String>();
            if(!custLangList.isEmpty()){
                for(FSL_Communication_Language__mdt custData : custLangList){
                    langPrefMap.put(custData.Language_Code__c,custData.Language__c );
                }
            }
        if(obj != null && obj.DataArea.size()>0 ) {
            Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guidanz').getRecordTypeId();
            set<string> setCustomerNumber = new set<string>();
            list<Contact> listContact = new list<Contact>();
            list<Contact> listupadteCon = new list<Contact>();
            map<string,string> mapContactError = new map<string,string>();
            map<string,string> mapCusCodeAccId  = new map<string,string>();
            map<string,string> mapConIdCusCode  = new map<string,string>();
            map<string,list<contact>> mapAccConS  = new map<string,list<Contact>>();
            map<string,contact> mapconId =new map<string,contact>();
            set<string> setConIds = new set<string>();
            integer blankConIdCount = 0;
            
            // list of all CustomerNumbers
            for(integer i=0;i<obj.DataArea.size();i++) {
                if(string.isNotBlank(obj.DataArea[i].CustomerNumber)) {
                    setCustomerNumber.add(obj.DataArea[i].CustomerNumber);
                }
            }
            System.debug(':::: setCustomerNumber = '+setCustomerNumber);
            // getting All AccountIds 
            for(Account acc: [select id,name,ParentId,FSL_ERP_Customer_Code__c, FSL_Source_ERP__c,(select id,Phone,IAM_Contact_Status__c,FSL_Contact_Id__c,FirstName,LastName,Email,AccountId,RecordTypeId,IAM_Contact_source__c,Email_Notification_Frequency__c,Text_SMS_Notification_Frequency__c,
            Language_Preferences__c,/*Mobile_Phone__c*/ MobilePhone from Contacts) from Account where FSL_ERP_Customer_Code__c in : setCustomerNumber]) // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
            {
                list<contact> listCon = new list<contact>();
                for(contact con :acc.Contacts) {
                    //mapconId.put((con.FSL_Contact_Id__c == null)? '0' : con.FSL_Contact_Id__c,con);
                    mapconId.put(con.FSL_Contact_Id__c ,con);
                    Contact cnct = new Contact();
                    cnct.FirstName =  (con.FirstName != null)?con.FirstName:'';
                    cnct.LastName =  (con.LastName != null)?con.LastName:'';
                    cnct.Email =  (con.Email != null)?con.Email:'';
                    //cnct.Email_Notifications__c = con.Email_Notifications__c != null?con.Email_Notifications__c:false;
                    cnct.Email_Notification_Frequency__c = con.Email_Notification_Frequency__c != null?con.Email_Notification_Frequency__c:'';
                    //cnct.Text_Notifications__c = con.Text_Notifications__c != null?con.Text_Notifications__c:false;
                    cnct.Text_SMS_Notification_Frequency__c = con.Text_SMS_Notification_Frequency__c != null?con.Text_SMS_Notification_Frequency__c:'';
                    //cnct.Nightly_Communications__c = con.Nightly_Communications__c != null ?con.Nightly_Communications__c:false;
                    cnct.Language_Preferences__c = con.Language_Preferences__c != null ? con.Language_Preferences__c:'';
                    //cnct.Mobile_Phone__c = (con.Mobile_Phone__c != null)?con.Mobile_Phone__c:''; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
                    cnct.MobilePhone = (con.MobilePhone != null)?con.MobilePhone:'';
                    cnct.FSL_Contact_Id__c =  (con.FSL_Contact_Id__c == null)? '0' : con.FSL_Contact_Id__c;
                    setConIds.add(cnct.FSL_Contact_Id__c);
                    listCon.add(cnct);
                }
                mapCusCodeAccId.put(acc.FSL_ERP_Customer_Code__c,acc.Id);
                mapAccConS.put(acc.FSL_ERP_Customer_Code__c,listCon);   
            }
            
            // iterate All Data 
            for(integer i=0;i<obj.DataArea.size();i++) {
                string parentAccId = '';
                list<contact> databaseContacts = new list<Contact>();
                Contact con = new Contact();
                
                if(string.isNotBlank(obj.DataArea[i].FirstName)) {  
                    string contactname = obj.DataArea[i].FirstName;
                    if(contactname.contains(' ')){
                        con.FirstName = contactname.substringBefore(' ');
                        con.LastName  = contactname.substringAfter(' ');   
                    } else {
                        con.FirstName = '';
                        con.LastName  = contactname;
                    }
                } else {
                    mapContactError.put('0','Name Cannot be Blank');
                }
                
                if(obj.DataArea[i].Email != null) {
                    con.Email = obj.DataArea[i].Email.toLowerCase();    
                }
                if(string.isNotBlank(obj.DataArea[i].CustomerNumber)) {
                    mapConIdCusCode.put('0',obj.DataArea[i].CustomerNumber);
                    if(mapAccConS.containskey(obj.DataArea[i].CustomerNumber)) {
                        databaseContacts = mapAccConS.get(obj.DataArea[i].CustomerNumber);
                        parentAccId = mapCusCodeAccId.get(obj.DataArea[i].CustomerNumber);
                    }
                } else {
                    mapConIdCusCode.put('0',' ');
                    mapContactError.put('0','Customer Code Cannot be Blank');
                }
                
                // For ADD
                if(obj.DataArea[i].EventFlag.toLowerCase() == 'add' && !mapContactError.containskey('0')) {
                    System.debug('::: For ADD BEGIN = '+obj.DataArea[i]);
                    //if(!databaseContacts.contains(con))
                    con.Phone = obj.DataArea[i].PhoneNumber;
                    //con.Email_Notifications__c = obj.DataArea[i].EmailNotification=='Y'?true:false;
                   // con.Email_Notification_Frequency__c = obj.DataArea[i].EmailNotification=='Y'?'Real-Time':'';
                   if(obj.DataArea[i].EmailNotification=='Y')
                   {
                      con.Email_Notification_Frequency__c = 'Real-Time';
                   }
                    else if(obj.DataArea[i].NightlyCommunication=='Y')
                   {
                      con.Email_Notification_Frequency__c ='Nightly'; 
                   }else //if((obj.DataArea[i].EmailNotification=='N') && (obj.DataArea[i].NightlyCommunication=='N'))
                   {
                      con.Email_Notification_Frequency__c ='Never/Unsubscribed'; 
                   }
                    //con.Text_Notifications__c = obj.DataArea[i].TextNotification=='Y'?true:false;
                   // con.Text_SMS_Notification_Frequency__c=obj.DataArea[i].TextNotification == 'Y'?'Real-Time':'';
                   if(obj.DataArea[i].TextNotification == 'Y')
                    {
                    con.Text_SMS_Notification_Frequency__c = 'Real-Time';
                    }
                     else {
                           con.Text_SMS_Notification_Frequency__c = 'Never/Unsubscribed';
                     
                           }
                    //con.Mobile_Phone__c = obj.DataArea[i].MobilePhoneNumber; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
                    con.MobilePhone = obj.DataArea[i].MobilePhoneNumber;
                    //con.Nightly_Communications__c = obj.DataArea[i].NightlyCommunication=='Y'?true:false;
                    con.Language_Preferences__c = langPrefMap.get(obj.DataArea[i].LanguagePreference);
                    
                    con.FSL_Contact_Id__c = '0';
                    con.CMI_Contact_Type__c = 'Customer';
                    if(!setConIds.contains(con.FSL_Contact_Id__c)) {
                        con.RecordTypeId = recTypeId;
                        if(string.isNotBlank(parentAccId)) {
                            con.AccountId = parentAccId;                            
                            listContact.add(con);
                        } else {
                            mapContactError.put(con.FSL_Contact_Id__c, 'Customer is not available ');
                        }
                    } else {
                        Contact cnt = new Contact();
                        System.debug('::: mapconId = '+mapconId);
                        cnt = mapconId.get('0');
                        if(cnt != null) {
                            if(cnt.IAM_Contact_Status__c == 'Inactive') {
                                cnt.IAM_Contact_Status__c = 'Active';
                                listupadteCon.add(cnt);
                            } else {
                                //system.debug('Duplicate Contact Record :- '+con.LastName);
                                con.id = mapconId.get('0').Id;
                                con.IAM_Contact_Status__c = 'Active';
                                listupadteCon.add(con);
                                
                                //  mapContactError.put(obj.DataArea[i].ContactID, 'Exiting ContactId Updated');
                            }
                        } else {
                            con.RecordTypeId = recTypeId;
                            con.AccountId = parentAccId;
                            listContact.add(con);
                        }
                    }
                }
                // For UPDATE
                if(obj.DataArea[i].EventFlag.toLowerCase() == 'update' && !mapContactError.containskey('0')) {
                    System.debug(':::: UPDATE BEGIN ='+mapconId);
                    //con.FSL_Contact_Id__c = '0';
                    con.RecordTypeId = recTypeId;
                    con.Phone = obj.DataArea[i].PhoneNumber;
                    //con.Email_Notifications__c = obj.DataArea[i].EmailNotification=='Y'?true:false;
                    //con.Email_Notification_Frequency__c = obj.DataArea[i].EmailNotification=='Y'?'Real-Time':'';
                    if(obj.DataArea[i].EmailNotification=='Y')
                   {
                      con.Email_Notification_Frequency__c = 'Real-Time';
                   }
                    else if(obj.DataArea[i].NightlyCommunication=='Y')
                   {
                      con.Email_Notification_Frequency__c ='Nightly'; 
                   }else //if((obj.DataArea[i].EmailNotification=='N') && (obj.DataArea[i].NightlyCommunication=='N'))
                   {
                      con.Email_Notification_Frequency__c ='Never/Unsubscribed'; 
                   }
                    //con.Text_Notifications__c = obj.DataArea[i].TextNotification=='Y'?true:false;
                    if(obj.DataArea[i].TextNotification == 'Y')
                    {
                    con.Text_SMS_Notification_Frequency__c = 'Real-Time';
                    }
                     else {
                           con.Text_SMS_Notification_Frequency__c = 'Never/Unsubscribed';
                     
                           }
                    //con.Text_SMS_Notification_Frequency__c=obj.DataArea[i].TextNotification == 'Y'?'Real-Time':'';
                    //con.Mobile_Phone__c = obj.DataArea[i].MobilePhoneNumber; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
                    con.MobilePhone = obj.DataArea[i].MobilePhoneNumber;
                    //con.Nightly_Communications__c = obj.DataArea[i].NightlyCommunication=='Y'?true:false;
                    con.Language_Preferences__c = langPrefMap.get(obj.DataArea[i].LanguagePreference);
                    con.CMI_Contact_Type__c = 'Customer';
                    if(string.isNotBlank(parentAccId)) {
                        con.AccountId = parentAccId;
                        System.debug('::: con.FSL_Contact_Id__c => '+con.FSL_Contact_Id__c+' and '+mapconId.containskey(con.FSL_Contact_Id__c));
                        if(mapconId.containskey((con.FSL_Contact_Id__c == null) ? '0' : con.FSL_Contact_Id__c) || mapconId.containskey('0') ) {
                            con.FSL_Contact_Id__c = '0';
                            con.IAM_Contact_Status__c = 'Active';
                            con.id = mapconId.get(con.FSL_Contact_Id__c).Id;
                            listupadteCon.add(con);
                        } else {
                            //mapContactError.put(con.FSL_Contact_Id__c,'No Record Found to update Contact with Id : '+'0');
                            System.debug('::: con.FSL_Contact_Id__c = '+con.FSL_Contact_Id__c);
                            con.IAM_Contact_Status__c = 'Active';
                            con.FSL_Contact_Id__c = '0';
                            listupadteCon.add(con);
                        }
                    }   
                    
                }
                // For DELETE
                if(obj.DataArea[i].EventFlag.toLowerCase() == 'delete' && !mapContactError.containskey('0')) {
                    if(mapconId.containskey('0')) {
                        contact delCon = new Contact();
                        delCon = mapconId.get('0');
                        delCon.IAM_Contact_Status__c = 'Inactive';
                        listupadteCon.add(delCon);
                    } else {
                        mapContactError.put(con.FSL_Contact_Id__c,'No Record Found to delete Contact with Id : '+'0');
                        
                    }
                }
            }
            
            Database.SaveResult[] srList = Database.insert(listContact, false);
            
            //Database.SaveResult[] srListUpdate = Database.update(listupadteCon, false);
            Database.UpsertResult[] upsertResult = Database.upsert(listupadteCon, false); 
            
            // Iterate through each returned result
            for(integer i = 0 ; i<listContact.size() ;i++) {
                Database.SaveResult sr = srList[i];
                FSL_CustomerContactWrapper.DataResponse resObj = new FSL_CustomerContactWrapper.DataResponse();
                
                resObj.CustomerNumber = mapConIdCusCode.get(listContact[i].FSL_Contact_Id__c);
                resObj.ContactID = listContact[i].FSL_Contact_Id__c;
                if(sr.isSuccess()) {                        
                    resObj.ReturnCodeDescription = 'Record Processed Succesfully';
                    resObj.Status = 'SUCCESS';
                } else {
                    string errMsg = '';
                    for(Database.Error err : sr.getErrors()) {
                        errMsg += err.getMessage() +',';                             
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());                             
                    }
                    resObj.ReturnCodeDescription = errMsg;
                    resObj.Status = 'Error';                                            
                }
                listResponses.add(resObj);
            }
            
            // Iterate through each returned result of Update
            for(integer i = 0 ; i<listupadteCon.size() ;i++) {
                Database.UpsertResult sr = upsertResult[i];
                FSL_CustomerContactWrapper.DataResponse resObj = new FSL_CustomerContactWrapper.DataResponse();
                
                resObj.CustomerNumber = mapConIdCusCode.get(listupadteCon[i].FSL_Contact_Id__c);
                resObj.ContactID = listupadteCon[i].FSL_Contact_Id__c;
                if(sr.isSuccess()) {                        
                    resObj.ReturnCodeDescription = 'Record Processed Succesfully';
                    resObj.Status = 'SUCCESS';
                } else {
                    string errMsg = '';
                    for(Database.Error err : sr.getErrors()) {
                        errMsg += err.getMessage() +',';                             
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());                             
                    }
                    resObj.ReturnCodeDescription = errMsg;
                    resObj.Status = 'Error';                                            
                }
                listResponses.add(resObj);
            }
            
            // For Custom Errors 
            for(string key : mapContactError.keyset()) {
                FSL_CustomerContactWrapper.DataResponse resObj = new FSL_CustomerContactWrapper.DataResponse();
                
                resObj.CustomerNumber = mapConIdCusCode.get(key);
                resObj.ContactID = key;
                resObj.ReturnCodeDescription = mapContactError.get(key);
                resObj.Status = 'Error';                                            
                listResponses.add(resObj);
            }
            for(integer i=0; i<blankConIdCount; i++) {
                FSL_CustomerContactWrapper.DataResponse resObj = new FSL_CustomerContactWrapper.DataResponse();
                resObj.CustomerNumber = '';
                resObj.ContactID = '';
                resObj.ReturnCodeDescription = 'ContactId cannot be blank!';
                resObj.Status = 'Error';
                listResponses.add(resObj);
            }
        }
        return listResponses;
    } 
}