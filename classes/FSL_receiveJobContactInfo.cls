/*********************************************************************************************************************************
Name:FSL_receiveJobContactInfo
Copyright © 2019  Cummins
===================================================================================================================================
===================================================================================================================================
Purpose:                                                            
This is the integration api expose class for Job Contact details from MOVEX,BMS and MOVEX-UK.
===================================================================================================================================
===================================================================================================================================
History                                                            
-------                                                            
VERSION         AUTHOR                  DATE                DETAIL                                
1.0         Sriprada Sesham           02/12/2019          INITIAL DEVELOPMENT 
1.1         Sriprada Sesham           01/06/2020          Updated logic for BMS, MOVEX-UK
*****************************************************************************************************************************************/

@RestResource(urlMapping='/jobContact/*')
global class FSL_receiveJobContactInfo 
{
    @HttpPost
    global static void doPostOperation()
    {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        string str = FSL_receiveJobContactInfo.handleJobContactRequest(req);
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(str);
        // str = 'connected!';         
    }
    
    
    public static string handleJobContactRequest(RestRequest req)
    {
        list<FSL_JobContactWrapper.DataResponse> listResponses = new list<FSL_JobContactWrapper.DataResponse>();
        //list<FSL_JobContactWrapper.Sender> listSender = new list<FSL_JobContactWrapper.Sender>();
 
        string msg;
        string jSONRequestBody = req.requestBody.toString().trim();
        system.debug('Request:'+jSONRequestBody);
        try{ 
            
            FSL_JobContactWrapper obj = new FSL_JobContactWrapper();
            
            obj = (FSL_JobContactWrapper) System.JSON.deserialize(jSONRequestBody, FSL_JobContactWrapper.class); 
            system.debug('obj @@@@ '+obj);
            listResponses = contactResponseHandler(obj);
            //msg = '{"ReturnCode":"200","ReturnCodeDescription":"Successfully inserted"}';
            msg =  '{"DataArea": '+json.serialize(listResponses)+',"Header":{"ReturnCodeDescription": "Record Processed Succesfully" ,"Status": "SUCCESS"}}';
            
        } 
        
        catch(Exception ex)
        {
            System.debug('Execption at line no :: '+ex.getLineNumber()+' Exception Message>>>is:  '+ex.getMessage() +'At : '+ ex.getLineNumber());
            msg = '{"ReturnCode":"401","ReturnCodeDescription":"'+ex.getMessage()+' At line :'+ ex.getLineNumber()+'"}'; 
            
        }
        // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.requestBody.toString(), listResponses[0].tostring(), Null, Null, 'receiveJobContactInfo', '', '', 'Guidanz', 'Sender', Null, 'TargetERP'));   
        return msg;
    }
    
    
    //handler method for job contact    
    public static list<FSL_JobContactWrapper.DataResponse> contactResponseHandler(FSL_JobContactWrapper obj)
    {       
        try{
            list<FSL_JobContactWrapper.DataResponse> listResponses = new list<FSL_JobContactWrapper.DataResponse>();
            List<FSL_Communication_Language__mdt> custLangList = [SELECT Id,Language_Code__c,Language__c FROM FSL_Communication_Language__mdt];
            Map<String,String> langPrefMap = new Map<String,String>();
            if(!custLangList.isEmpty()){
                for(FSL_Communication_Language__mdt custData : custLangList){
                    langPrefMap.put(custData.Language_Code__c,custData.Language__c );
                }
            }
            if(obj != null && obj.DataArea.size()>0 )
            {
                String sendrId = obj.Header.sender.SenderID;
                Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guidanz').getRecordTypeId();
                set<string> setCustomerCode = new set<string>();
                list<Contact> listContact = new list<Contact>();
                list<Contact> listupadteCon = new list<Contact>();
                list<Contact> listDelCon = new list<Contact>();       //Phoen-152
                // map<string,Contact> conMap = new map<string,Contact>();
                map<string,string> mapContactError = new map<string,string>();
                map<string,string> mapCusCodeAccId  = new map<string,string>();
                map<string,string> mapConIdCusCode  = new map<string,string>();
                map<string,list<contact>> mapAccConS  = new map<string,list<Contact>>();
                map<string,contact> mapconId =new map<string,contact>();
                map<string, Boolean> mapConIdChkWithWOSOCumm = new map<string, Boolean>();
                set<string> setConIds = new set<string>();
                set<Id> setContactRecId = new set<Id>();
                
                integer blankConIdCount = 0;
                
                // list of all CustomerCodes
                for(integer i=0;i<obj.DataArea.size();i++)
                {
                    if(string.isNotBlank(obj.DataArea[i].CustomerCode))
                    {
                        setCustomerCode.add(obj.DataArea[i].CustomerCode);
                        
                    }
                }
                
                System.debug('::: setCustomerCode = '+setCustomerCode);
                
                // getting All AccountIds 
                for(Account acc: [select id,name,ParentId,FSL_ERP_Customer_Code__c,FSL_Source_ERP__c, (select id,Phone,IAM_Contact_Status__c,FSL_Contact_Id__c,FirstName,LastName,Email,AccountId,RecordTypeId, IAM_Contact_source__c,Email_Notification_Frequency__c,Text_SMS_Notification_Frequency__c,Language_Preferences__c,/*Mobile_Phone__c*/ MobilePhone from Contacts) from Account where FSL_ERP_Customer_Code__c in: setCustomerCode]) // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
                {
                    list<contact> listCon = new list<contact>();
                    for(contact con :acc.Contacts)
                    { 
                        //Start : Harsha commented this condition
                        /* if(con.IAM_Contact_source__c =='BMS' || con.IAM_Contact_source__c =='Movex'){*/
                        if(string.isNotBlank(string.valueOf(con.FSL_Contact_Id__c))){
                            mapconId.put(con.FSL_Contact_Id__c,con);
                        }
                        Contact cnct = new Contact();
                        cnct.FirstName =  (con.FirstName != null)?con.FirstName:'';
                        cnct.LastName =  (con.LastName != null)?con.LastName:'';
                        cnct.Email =  (con.Email != null)?con.Email:'';
                        //cnct.Email_Notifications__c = con.Email_Notifications__c != null?con.Email_Notifications__c:false;
                        cnct.Email_Notification_Frequency__c = con.Email_Notification_Frequency__c != null?con.Email_Notification_Frequency__c:'';
                        //cnct.Text_Notifications__c = con.Text_Notifications__c != null?con.Text_Notifications__c:false;
                        cnct.Text_SMS_Notification_Frequency__c = con.Text_SMS_Notification_Frequency__c!= null?con.Text_SMS_Notification_Frequency__c:'';
                        //cnct.Nightly_Communications__c = con.Nightly_Communications__c != null ?con.Nightly_Communications__c:false;
                        cnct.Language_Preferences__c = con.Language_Preferences__c != null ? con.Language_Preferences__c:'';
                        //cnct.Mobile_Phone__c = (con.Mobile_Phone__c!= null)?con.Mobile_Phone__c:''; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
                        cnct.MobilePhone= (con.MobilePhone!= null)?con.MobilePhone:'';
                        cnct.FSL_Contact_Id__c =  (con.FSL_Contact_Id__c != null)?con.FSL_Contact_Id__c:'';
                        
                        setConIds.add(cnct.FSL_Contact_Id__c);
                        //conMap.put(cnct.FSL_Contact_Id__c, cnct);
                        listCon.add(cnct);
                        
                        setContactRecId.add(cnct.Id);
                        /* } End*/
                    }
                    mapCusCodeAccId.put(acc.FSL_ERP_Customer_Code__c,acc.Id);
                    mapAccConS.put(acc.FSL_ERP_Customer_Code__c,listCon);
                    System.debug('::: mapCusCodeAccId = '+mapCusCodeAccId);
                    System.debug('::: mapAccConS = '+mapAccConS);
                    
                    /* } End */
                }
                
                //Phoen-152: As a Guidanz user, Need to Delete or Inactive a contact once it is removed from the BMS system 
                if(setContactRecId != null && setContactRecId.size() > 0){
                    //Get Contact related Work Order, Service Request & Communications
                    List<WorkOrder> lstWO = [select Id, ContactId, Contact.FSL_Contact_Id__c from WorkOrder where ContactId in :setContactRecId];
                    set<id> setContactIdChk = new set<id>();
                    if(lstWO != null && lstWO.size() > 0){
                        for(WorkOrder wo : lstWO){
                            mapConIdChkWithWOSOCumm.put(wo.Contact.FSL_Contact_Id__c, true);
                            setContactIdChk.add(wo.ContactId);
                        }
                    }
                    
                    List<Case> lstSR = [select Id, ContactId, Contact.FSL_Contact_Id__c from Case where (ContactId in :setContactRecId and ContactId NOT IN :setContactIdChk)];
                    if(lstSR != null && lstSR.size() > 0){
                        for(Case objCase : lstSR){
                            mapConIdChkWithWOSOCumm.put(objCase.Contact.FSL_Contact_Id__c, true);
                            setContactIdChk.add(objCase.ContactId);
                        }
                    }
                    
                    List<Service_Order_Communication__c> lstSerOrdCum = [select Id, Contact__c, Contact__r.FSL_Contact_Id__c from Service_Order_Communication__c where (Contact__c in :setContactRecId and Contact__c NOT IN :setContactIdChk)];
                    if(lstSerOrdCum != null && lstSerOrdCum.size() > 0){
                        for(Service_Order_Communication__c objCum : lstSerOrdCum){
                            mapConIdChkWithWOSOCumm.put(objCum.Contact__r.FSL_Contact_Id__c, true);
                        }
                    }
                }
                //--------------****------------
                
                // iterate All Data 
                for(integer i=0;i<obj.DataArea.size();i++)
                {
                    string parentAccId = '';
                    if(string.isNotBlank(obj.DataArea[i].ContactID.trim()))
                    {
                        list<contact> databaseContacts = new list<Contact>();
                        Contact con = new Contact();
                        
                        if(string.isNotBlank(obj.DataArea[i].ContactName))
                        {   /*
list<string> name = obj.DataArea[i].ContactName.split(' '); 
if(name.size()==1)
{
con.FirstName = '';
con.LastName  = name[0];
}else
{
con.FirstName = name[0];
con.LastName  = name[1];
}*/
                            string contactname = obj.DataArea[i].ContactName;
                            if(contactname.contains(' '))
                            {
                                con.FirstName = contactname.substringBefore(' ');
                                con.LastName  = contactname.substringAfter(' ');   
                            }else
                            {
                                con.FirstName = '';
                                con.LastName  = contactname;
                            }
                        }else
                        {
                            mapContactError.put(obj.DataArea[i].ContactID,'Name Cannot be Blank');
                        }
                        
                        if(obj.DataArea[i].EmailAddress != null)
                        {
                            con.Email = obj.DataArea[i].EmailAddress.toLowerCase();    
                        }
                        if(string.isNotBlank(obj.DataArea[i].CustomerCode))
                        {
                            mapConIdCusCode.put(obj.DataArea[i].ContactID,obj.DataArea[i].CustomerCode);
                            if(mapAccConS.containskey(obj.DataArea[i].CustomerCode))
                            {
                                databaseContacts = mapAccConS.get(obj.DataArea[i].CustomerCode);
                                parentAccId = mapCusCodeAccId.get(obj.DataArea[i].CustomerCode);
                            }
                        }else
                        {
                            mapConIdCusCode.put(obj.DataArea[i].ContactID,' ');
                            mapContactError.put(obj.DataArea[i].ContactID,'Customer Code Cannot be Blank');
                        }
                        if(!mapConIdCusCode.containskey(obj.DataArea[i].ContactID)){
                            mapContactError.put(obj.DataArea[i].ContactID, 'Customer is not available ');
                            
                        }
                        /*if(string.isNotBlank(obj.DataArea[i].EmailNotification)){
con.Email_Notifications__c = obj.DataArea[i].EmailNotification == 'Y'?true:false;
}*/
                        /* DB
if(string.isNotBlank(obj.DataArea[i].EmailNotificationFrequency)){
//con.Email_Notification_Frequency__c = obj.DataArea[i].EmailNotification=='Y'?'Real-Time':''; 
con.Email_Notification_Frequency__c = obj.DataArea[i].EmailNotificationFrequency; 
} DB End*/
                        
                        // CT4-286 - Vijay Mudam Start
                        if(sendrId == 'BMS'){
                            if(obj.DataArea[i].EmailNotification == 'Y' && obj.DataArea[i].NightlyCommunication == 'N'){
                                con.Email_Notification_Frequency__c='Real-Time';
                            }
                            else if(obj.DataArea[i].EmailNotification == 'N' && obj.DataArea[i].NightlyCommunication == 'N'){
                                con.Email_Notification_Frequency__c='Never/Unsubscribed';
                            }
                            else if(obj.DataArea[i].EmailNotification == 'Y' && obj.DataArea[i].NightlyCommunication == 'Y'){
                                con.Email_Notification_Frequency__c='Nightly';
                            }
                            
                            if(obj.DataArea[i].TextNotification == 'Y'){
                                con.Text_SMS_Notification_Frequency__c='Real-Time';
                            }
                            else if(obj.DataArea[i].TextNotification == 'N'){
                                con.Text_SMS_Notification_Frequency__c='Never/Unsubscribed';
                            }
                            
                            con.MobilePhone=obj.DataArea[i].MobilePhoneNumber;
                            
                            if(obj.DataArea[i].LanguagePreference == 'EN'){
                                con.Language_Preferences__c= 'English';
                            }
                            else if(obj.DataArea[i].LanguagePreference == 'FR'){
                                con.Language_Preferences__c= 'French';
                            }
                        }
                        // CT4-286 - Vijay Mudam End
                        

                        if(obj.DataArea[i].EventFlag.toLowerCase() == 'add' && mapConIdCusCode.containskey(obj.DataArea[i].ContactID) )
                        {
                            //if(!databaseContacts.contains(con))
                            con.Phone = obj.DataArea[i].ContactPhoneNo;
                            con.FSL_Contact_Id__c = obj.DataArea[i].ContactID;
                            if(!setConIds.contains(obj.DataArea[i].ContactID) && !mapconId.containskey(obj.DataArea[i].ContactID))
                            {
                                con.RecordTypeId = recTypeId;
                                if(string.isNotBlank(parentAccId))
                                {
                                    con.AccountId = parentAccId;                            
                                    listContact.add(con);
                                }else{
                                    mapContactError.put(obj.DataArea[i].ContactID, 'Customer is not available ');
                                }
                            }else if(mapconId.containskey(obj.DataArea[i].ContactID) &&  mapConIdCusCode.containskey(obj.DataArea[i].ContactID)){
                                Contact cnt = new Contact();
                                cnt = mapconId.get(obj.DataArea[i].ContactID);
                                if(cnt.IAM_Contact_Status__c == 'Inactive')
                                {
                                    cnt.IAM_Contact_Status__c = 'Active';
                                    listupadteCon.add(cnt);
                                }
                                else{
                                    //system.debug('Duplicate Contact Record :- '+con.LastName);
                                    con.id = mapconId.get(obj.DataArea[i].ContactID).Id;
                                    con.IAM_Contact_Status__c = 'Active';
                                    listupadteCon.add(con);
                                    System.debug('::: Contact = '+con);
                                    //  mapContactError.put(obj.DataArea[i].ContactID, 'Exiting ContactId Updated');
                                }
                            }
                            
                        }
                        
                        // For UPDATE
                        if(obj.DataArea[i].EventFlag.toLowerCase() == 'update' && !mapContactError.containskey(obj.DataArea[i].ContactID) && mapConIdCusCode.containskey(obj.DataArea[i].ContactID))
                        {
                            con.FSL_Contact_Id__c = obj.DataArea[i].ContactID;
                            //con.RecordTypeId = recTypeId;
                            con.Phone = obj.DataArea[i].ContactPhoneNo;
                            if(string.isNotBlank(parentAccId) && mapconId.containskey(obj.DataArea[i].ContactID))
                            {
                                
                                con.AccountId = parentAccId;
                                if(mapconId.containskey(obj.DataArea[i].ContactID))
                                {
                                    con.IAM_Contact_Status__c = 'Active';
                                    con.id = mapconId.get(obj.DataArea[i].ContactID).Id;
                                    listupadteCon.add(con);
                                    system.debug('test**:'+mapConIdCusCode);
                                }
                                else{
                                    mapContactError.put(obj.DataArea[i].ContactID,'No Record Found to update Contact with Id : '+obj.DataArea[i].ContactID);
                                    
                                }
                                
                            } else{
                                con.Phone = obj.DataArea[i].ContactPhoneNo;
                                con.FSL_Contact_Id__c = obj.DataArea[i].ContactID;
                                if(!setConIds.contains(obj.DataArea[i].ContactID) && !mapconId.containskey(obj.DataArea[i].ContactID))
                                {
                                    //con.RecordTypeId = recTypeId;
                                    if(string.isNotBlank(parentAccId))
                                    {
                                        con.AccountId = parentAccId;                            
                                        listContact.add(con);
                                    }else{
                                        mapContactError.put(obj.DataArea[i].ContactID, 'Customer is not available ');
                                    }
                                }else{
                                    if(mapconId.containskey(obj.DataArea[i].ContactID)){
                                        system.debug('test**:'+mapConIdCusCode);
                                        Contact cnt = new Contact();
                                        cnt = mapconId.get(obj.DataArea[i].ContactID);
                                        if(cnt.IAM_Contact_Status__c == 'Inactive')
                                        {
                                            cnt.IAM_Contact_Status__c = 'Active';
                                            listupadteCon.add(cnt);
                                        }
                                        else{
                                            //system.debug('Duplicate Contact Record :- '+con.LastName);
                                            con.id = mapconId.get(obj.DataArea[i].ContactID).Id;
                                            con.IAM_Contact_Status__c = 'Active';
                                            listupadteCon.add(con);
                                            System.debug('::: Contact = '+con);
                                            //  mapContactError.put(obj.DataArea[i].ContactID, 'Exiting ContactId Updated');
                                        }
                                    }
                                }
                            }
                            
                        }
                        // For DELETE
                        if(obj.DataArea[i].EventFlag.toLowerCase() == 'delete' && !mapContactError.containskey(obj.DataArea[i].ContactID))
                        {
                            if(mapconId.containskey(obj.DataArea[i].ContactID))
                            {
                                contact delCon = new Contact();
                                delCon = mapconId.get(obj.DataArea[i].ContactID);
                                delCon.IAM_Contact_Status__c = 'Inactive';
                                
                                //Phoen-152
                                if(mapConIdChkWithWOSOCumm.get(obj.DataArea[i].ContactID) != null && mapConIdChkWithWOSOCumm.get(obj.DataArea[i].ContactID) == true){                                   
                                    listupadteCon.add(delCon);
                                }
                                else{
                                    listDelCon.add(delCon);
                                }                                   
                            }
                            else{
                                mapContactError.put(obj.DataArea[i].ContactID,'No Record Found to delete Contact with Id : '+obj.DataArea[i].ContactID);
                                
                            }
                        }
                    }else
                    {
                        blankConIdCount++;
                    }
                }
                
                System.debug('::: Contacts = '+listContact);
                System.debug('::: Contacts Update = '+listupadteCon);
                
                Database.SaveResult[] srList = Database.insert(listContact, false);
                
                Database.SaveResult[] srListUpdate = Database.update(listupadteCon, false);
                
                Database.DeleteResult[] srListDelete = Database.Delete(listDelCon, false);
                
                // Iterate through each returned result
                for(integer i = 0 ; i<listContact.size() ;i++)
                {
                    Database.SaveResult sr = srList[i];
                    FSL_JobContactWrapper.DataResponse resObj = new FSL_JobContactWrapper.DataResponse();
                    
                    resObj.CustomerCode = mapConIdCusCode.get(listContact[i].FSL_Contact_Id__c);
                    resObj.ContactID = listContact[i].FSL_Contact_Id__c;
                    if(sr.isSuccess())
                    {                        
                        resObj.ReturnCodeDescription = 'Record Processed Succesfully';
                        resObj.Status = 'SUCCESS';
                    }else
                    {
                        string errMsg = '';
                        for(Database.Error err : sr.getErrors()) 
                        {
                            errMsg += err.getMessage() +',';                             
                            //System.debug(err.getStatusCode() + ': ' + err.getMessage());                             
                        }
                        resObj.ReturnCodeDescription = errMsg;
                        resObj.Status = 'Error';                                            
                    }
                    listResponses.add(resObj);
                }
                
                // Iterate through each returned result of Update
                for(integer i = 0 ; i<listupadteCon.size() ;i++)
                {
                    Database.SaveResult sr = srListUpdate[i];
                    FSL_JobContactWrapper.DataResponse resObj = new FSL_JobContactWrapper.DataResponse();
                    
                    resObj.CustomerCode = mapConIdCusCode.get(listupadteCon[i].FSL_Contact_Id__c);
                    resObj.ContactID = listupadteCon[i].FSL_Contact_Id__c;
                    if(sr.isSuccess())
                    {                        
                        resObj.ReturnCodeDescription = 'Record Processed Succesfully';
                        resObj.Status = 'SUCCESS';
                    }else
                    {
                        string errMsg = '';
                        for(Database.Error err : sr.getErrors()) 
                        {
                            errMsg += err.getMessage() +',';                             
                            //System.debug(err.getStatusCode() + ': ' + err.getMessage());                             
                        }
                        resObj.ReturnCodeDescription = errMsg;
                        resObj.Status = 'Error';                                            
                    }
                    listResponses.add(resObj);
                }
                
                //Phoen-152 ---
                if(srListDelete != null && srListDelete.size() > 0){
                    for(integer i = 0 ; i<listDelCon.size() ;i++)
                    {
                        Database.DeleteResult sr = srListDelete[i];
                        FSL_JobContactWrapper.DataResponse resObj = new FSL_JobContactWrapper.DataResponse();
                        
                        resObj.CustomerCode = mapConIdCusCode.get(listDelCon[i].FSL_Contact_Id__c);
                        resObj.ContactID = listDelCon[i].FSL_Contact_Id__c;
                        if(sr.isSuccess())
                        {                        
                            resObj.ReturnCodeDescription = 'Record Processed Succesfully';
                            resObj.Status = 'SUCCESS';
                        }else
                        {
                            string errMsg = '';
                            for(Database.Error err : sr.getErrors()) 
                            {
                                errMsg += err.getMessage() +',';                             
                                //System.debug(err.getStatusCode() + ': ' + err.getMessage());                             
                            }
                            resObj.ReturnCodeDescription = errMsg;
                            resObj.Status = 'Error';                                            
                        }
                        listResponses.add(resObj);
                    }
                }
                // For Custom Errors 
                for(string key : mapContactError.keyset())
                {
                    FSL_JobContactWrapper.DataResponse resObj = new FSL_JobContactWrapper.DataResponse();
                    
                    resObj.CustomerCode = mapConIdCusCode.get(key);
                    resObj.ContactID = key;
                    resObj.ReturnCodeDescription = mapContactError.get(key);
                    resObj.Status = 'Error';                                            
                    listResponses.add(resObj);
                }
                for(integer i=0;i<blankConIdCount;i++)
                {
                    FSL_JobContactWrapper.DataResponse resObj = new FSL_JobContactWrapper.DataResponse();
                    
                    resObj.CustomerCode = '';
                    resObj.ContactID = '';
                    resObj.ReturnCodeDescription = 'ContactId cannot be blank!';
                    resObj.Status = 'Error';                                            
                    listResponses.add(resObj);
                }
            }
            return listResponses;
        }Catch(exception e){
            System.debug('Execption at line no :: '+e.getLineNumber()+' Exception Message>>>is:  '+e.getMessage() +'At : '+ e.getLineNumber());
            return null;
        }
    }               
}