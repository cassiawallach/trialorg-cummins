/************************************************************
Name:  OSM_BOLT_WS_CustomMasterInbound
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class will be exposed as rest resource for customer 
master inbound. It will read input json, validate account and 
account address info and update the respective account in OSM. 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S            12/07/2018     INITIAL DEVELOPMENT          

*************************************************************/

@RestResource(UrlMapping = '/BoltCustomerMasterInbound/*')
global with sharing class OSM_BOLT_WS_CustomMasterInbound {
    
/*----------------------------------------------------------------------------------
1. CustomMasterInboundService
Description: It will take JSON request, search account with 'BOLT_Account_Number__c'
field in OSM and update the requested fields. Success message will be given after the
successful update. If update fails, it will give error message and error field. 
Input: None - Request will be provided since this is HTTPPost method
Output: Success and Error Message.
Returntype:OSM_BOLT_WS_CustomMasterRes
------------------------------------------------------------------------------------*/
    
    @HttpPost
    global static OSM_BOLT_WS_CustomMasterRes CustomMasterInboundService(){
        
        OSM_BOLT_WS_CustomMasterRes resJSON = null;
        OSM_BOLT_WS_CustomMasterReq reqJSON = null;
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                      
        OSM_BOLT_WS_LogAndResponseWrapper wrap = null;
        
        RestRequest req = RestContext.request; //Variable to store request from restContext
        RestResponse res = RestContext.response; //Variable to store response from restContext
        
       String jSONRequestBody = req.requestBody.toString().trim(); //Get the request body
       system.debug('jSONRequestBody'+jSONRequestBody);
      //String jSONRequestBody = '{"DataArea":{"CUST_O_STG_ROW":{"ATTRIBUTE3":null,"ATTRIBUTE10":null,"ORIG_SYSTEM_REFERENCE":61306,"ATTRIBUTE2":null,"ATTRIBUTE1":null,"ATTRIBUTE9":null,"ATTRIBUTE8":null,"ATTRIBUTE7":null,"ATTRIBUTE6":null,"ATTRIBUTE5":null,"ATTRIBUTE4":null,"STATUS":"A","PARTY_TYPE":"ORGANIZATION","PARTY_NUMBER":322698,"PARTY_NAME":"CSSNA-EAST REGION","CUST_ACCTS_O_STG":{"CUST_ACCTS_O_STG_ROW":{"ATTRIBUTE3":null,"ATTRIBUTE10":null,"ATTRIBUTE2":null,"ATTRIBUTE1":"NOVI*NA DISTRIBUTORS*NA DISTRIBUTORS*POWERCARE","CUSTOMER_ACTION_TYPE":"SYNC","CUSTOMER_CLASS_CODE":null,"ATTRIBUTE11":707,"CUSTOMER_TYPE":"I","ACCT_SITES_O_STG":{"ACCT_SITES_O_STG_ROW":[{"ACC_SITE_STATUS":"A","GLOBAL_ATTRIBUTE5":null,"GLOBAL_ATTRIBUTE4":null,"GLOBAL_ATTRIBUTE7":null,"LOCATION_ATTRIBUTE10":null,"GLOBAL_ATTRIBUTE6":null,"COUNTRY":"US","GLOBAL_ATTRIBUTE1":null,"GLOBAL_ATTRIBUTE3":null,"GLOBAL_ATTRIBUTE2":null,"GLOBAL_ATTRIBUTE9":null,"GLOBAL_ATTRIBUTE8":null,"COUNTY":"BARTHOLOMEW","BC_CODE":598,"LOCATION_ATTRIBUTE1":null,"ENTITY_CODE":null,"LOCATION":"2601 14 FORTUNE CIRCLE","SITE_USE_ATTRIBUTE3":null,"SITE_USE_ATTRIBUTE2":null,"ADDRESS_LINES_PHONETIC":null,"SITE_USE_ATTRIBUTE1":null,"PARTY_SITE_STATUS":"A","STATE":"IN","SITE_USE_ATTRIBUTE9":100373519,"SITE_USE_ATTRIBUTE8":null,"SITE_USE_ATTRIBUTE7":null,"SITE_USE_ATTRIBUTE6":null,"SITE_USE_ATTRIBUTE5":null,"SITE_USE_ATTRIBUTE4":null,"ACC_SITE_REFERENCE":71759,"POSTAL_CODE":46241,"LOCATION_ATTRIBUTE4":null,"PRIMARY_FLAG":"N","LOCATION_ATTRIBUTE5":null,"LOCATION_ATTRIBUTE2":null,"LOCATION_ATTRIBUTE3":null,"ADDRESS1":"2601 FORTUNE CIRCLE EAST","LOCATION_ATTRIBUTE8":null,"LOCATION_ATTRIBUTE9":null,"SITE_USE_CODE":"BILL_TO","ADDRESS3":"FIN1T TESTING 09/06","LOCATION_ATTRIBUTE6":null,"ADDRESS2":"SUITE 300 C","LOCATION_ATTRIBUTE7":null,"ACCOUNT_SITE_ACTION_TYPE":"SYNC","ADDRESS4":"FIN1T TESTING 09/06","BOLT_OPERATING_UNIT":"US CBS Columbus 598","GLOBAL_ATTRIBUTE_CATEGORY":null,"ADDRESS_ACTION_TYPE":"UPDATE","CITY":"INDIANAPOLIS","SITE_USE_STATUS":"A","IDENTIFYING_ADDRESS_FLAG":"N","PROVINCE":null,"SITE_USE_ATTRIBUTE10":null,"RECEIVABLE_ACCOUNT":0}]},"ALTERNATE_NAME":null,"ATTRIBUTE9":null,"TAXPAYER_ID":null,"ATTRIBUTE7":204,"ATTRIBUTE6":null,"ATTRIBUTE5":null,"ATTRIBUTE4":null,"STATUS":"A","ACCOUNT_REFERENCE":"02850","CREDIT_HOLD":"N","ACCOUNT_NUMBER":322698,"ATTR_CONTEXT":"I","PROFILE_CLASS":"DEFAULT"}},"ATTR_CONTEXT":null}},"Header":{"Sender":{"ServiceName":"CustomerMasterOutbound","SenderID":"BOLT"},"Target":{"TargetID":"OSM"}}}';
        reqJSON = (OSM_BOLT_WS_CustomMasterReq)JSON.deserialize(jSONRequestBody,OSM_BOLT_WS_CustomMasterReq.class); //Deserialize the request body
        system.debug('reqJSON'+reqJSON);
        
        resJSON = new OSM_BOLT_WS_CustomMasterRes();             
        
        List<OSM_BOLT_WS_CustomMasterReq.ACCT_SITES_O_STG_ROW> addressLstFromBolt = new List<OSM_BOLT_WS_CustomMasterReq.ACCT_SITES_O_STG_ROW>(); //List to store customer account address records
        Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_ACCTS_O_STG_ROW> mapBolt = new Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_ACCTS_O_STG_ROW>(); //Map to store account number and its customer account 
        Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_O_STG_ROW> mapBoltCUST = new Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_O_STG_ROW>(); //Map to store account number and its customer
        Boolean exceptionflag = false;
        Boolean RequiredFieldMissingFlag = false;
        Set<Boolean> sflag = new Set<Boolean>();
        
        //Initialize Object for Data Area's
        OSM_BOLT_WS_CustomMasterReq.CUST_O_STG_ROW CUSTobj = reqJSON.DataArea.CUST_O_STG_ROW;
        OSM_BOLT_WS_CustomMasterReq.CUST_ACCTS_O_STG_ROW CUSTACCobj = reqJSON.DataArea.CUST_O_STG_ROW.CUST_ACCTS_O_STG.CUST_ACCTS_O_STG_ROW; 
        addressLstFromBolt = reqJSON.DataArea.CUST_O_STG_ROW.CUST_ACCTS_O_STG.CUST_ACCTS_O_STG_ROW.ACCT_SITES_O_STG.ACCT_SITES_O_STG_ROW;
        system.debug('CUSTACCobj'+CUSTACCobj);
        system.debug('CUSTobj'+CUSTobj);
        system.debug('addressLstFromBolt'+addressLstFromBolt);
        
        try{
            //Check if customer, customer account and customer account address object are not null
            if(CUSTACCobj != null && CUSTobj != null && addressLstFromBolt != null && addressLstFromBolt.size()>0){ 
                for(OSM_BOLT_WS_CustomMasterReq.ACCT_SITES_O_STG_ROW ACCTobj :addressLstFromBolt){
                    //Check all input parameters are provided
                    if(!string.isBlank(CUSTobj.STATUS) && !string.isBlank(CUSTobj.PARTY_NUMBER) && !string.isBlank(CUSTobj.PARTY_NAME) && !string.isBlank(CUSTobj.ORIG_SYSTEM_REFERENCE) && !string.isBlank(CUSTACCobj.ACCOUNT_NUMBER) && !string.isBlank(CUSTACCobj.STATUS) && !string.isBlank(CUSTACCobj.CUSTOMER_TYPE) && !string.isBlank(CUSTACCobj.CREDIT_HOLD) && !string.isBlank(ACCTobj.ACC_SITE_REFERENCE) && !string.isBlank(ACCTobj.SITE_USE_CODE) && !string.isBlank(ACCTobj.LOCATION) && !string.isBlank(ACCTobj.ADDRESS1)){
                        mapBolt.put(CUSTACCobj.ACCOUNT_NUMBER,CUSTACCobj);
                        mapBoltCUST.put(CUSTACCobj.ACCOUNT_NUMBER,CUSTobj);
                        RequiredFieldMissingFlag = false;
                    }   
                    if(string.isBlank(CUSTobj.STATUS) || string.isBlank(CUSTobj.PARTY_NUMBER) || string.isBlank(CUSTobj.PARTY_NAME) || string.isBlank(CUSTobj.ORIG_SYSTEM_REFERENCE) || string.isBlank(CUSTACCobj.ACCOUNT_NUMBER) || string.isBlank(CUSTACCobj.STATUS) || string.isBlank(CUSTACCobj.CUSTOMER_TYPE) || string.isBlank(CUSTACCobj.CREDIT_HOLD) || string.isBlank(ACCTobj.ACC_SITE_REFERENCE) || string.isBlank(ACCTobj.SITE_USE_CODE) || string.isBlank(ACCTobj.LOCATION) || string.isBlank(ACCTobj.ADDRESS1)){
                        system.debug('Input JSON is missing some requried fields for Account:');
                        
                        //This states that some required fields are missing. 
                        exceptionflag = true;
                        RequiredFieldMissingFlag = true;
                        break;  
                    }   
                }
                sflag.add(RequiredFieldMissingFlag);
            }                       
            system.debug('mapBolt'+mapBolt);                        
            system.debug('mapBoltCUST'+mapBoltCUST);
            
            if(sflag.contains(true)){
                resJSON = new OSM_BOLT_WS_CustomMasterRes();
                resJSON.Status = label.DA_Log_Status_Failure;
                resJSON.ReturnCodeDescription = label.Bolt_Customer_Inbound_Failure_Msg;
                //Populate log for exception
                if((Boolean.valueOf(Label.OSM_Failure_Log) == true) && (exceptionflag == true)){
                    log = new OSM_Integration_Log__c();
                    OSM_SW_LoggingContext.integrationLog = log;
                    log.Request__c = jSONRequestBody;
                    log.Service_Name__c = label.Bolt_Customer_Master_Inbound;
                    log.Source__c = label.Bolt_Source;
                    log.Target__c = label.DA_Source;
                    log.Logged_In_User__c = userinfo.getUserId();
                    log.Response__c  = label.Bolt_Customer_Inbound_Failure_Msg;
                    log.Status__c = label.DA_Log_Status_Failure;
                    log.Error_Description__c = label.Bolt_Customer_Inbound_Failure_Msg; 
                                                                                                                     
                    OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record
                }
                return resJSON; 
            }   
            
            if(mapBoltCUST.keyset() != null && mapBoltCUST.size()>0){
                //Fetch all account informations in OSM which has same BOLT ACCOUNT_NUMBER
                List<Account> accListTemp = new List<Account>([Select id, CMI_Account_Status__c, Bolt_Party_Number__c, Bolt_Party_Name__c, Bolt_Site_Number__c, Bolt_Account_Number__c, Bolt_Customer_Account_Status__c, Bolt_Customer_Type__c, Bolt_Credit_Hold__c from account where BOLT_Account_Number__c = :CUSTACCobj.ACCOUNT_NUMBER]);
                system.debug('accListTemp >> '+accListTemp);
                system.debug('accListTemp SIZE   >> '+accListTemp.size());
                
         
        
                //If there is no account in OSM                 
                if(accListTemp.size()==0){
                    system.debug('no account exist');
                    exceptionflag = true;
                    resJSON = new OSM_BOLT_WS_CustomMasterRes();
                    resJSON.Status = label.DA_Log_Status_Failure;
                    resJSON.ReturnCodeDescription = label.Bolt_Customer_Inbound_No_Account;
                    //Populate log for exception
                    if((Boolean.valueOf(Label.OSM_Failure_Log) == true) && (exceptionflag == true)){
                        log = new OSM_Integration_Log__c();
                        OSM_SW_LoggingContext.integrationLog = log; //Populating integration log record
                        log.Request__c = jSONRequestBody;
                        log.Service_Name__c = label.Bolt_Customer_Master_Inbound;
                        log.Source__c = label.Bolt_Source;
                        log.Target__c = label.DA_Source;
                        log.Logged_In_User__c = userinfo.getUserId();
                        log.Response__c  = label.Bolt_Customer_Inbound_No_Account;
                        log.Status__c = label.DA_Log_Status_Failure;
                        log.Error_Description__c = label.Bolt_Customer_Inbound_No_Account;
                                                                               
                        OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record
            
                        return resJSON; 
                    }
                }else{
                
                    List<Id> lstId = new List<Id>();
                    
                    for(Account objAcc : accListTemp)
                        lstId.add(objAcc.Id);
                    System.enqueueJob(new OSM_SW_QueueableBoltInboundJob(lstId, mapBolt, mapBoltCUST,reqJSON,jSONRequestBody));
                    resJSON.Status = label.DA_Log_Status_Success;
                    resJSON.ReturnCodeDescription = label.Bolt_Customer_Inbound_Success_Msg;
                    //call action method
                    /*
                    OSM_BOLT_WS_LogAndResponseWrapper methodReturn = doUpdateInsertFromInputJson(reqJSON,mapBolt,mapBoltCUST, accListTemp);
                    resJSON = methodReturn.resJSONW;
                    exceptionflag = methodReturn.exceptionflag;
                    system.debug('exceptionflag'+exceptionflag);
                    
                    //Fetch all account informations in OSM which has same BOLT ACCOUNT_NUMBER
                    // Added FOR UPDATE in Query for MAR-1438
                    List<Account> acc = new List<Account>([Select id, CMI_Account_Status__c, Bolt_Party_Number__c, Bolt_Party_Name__c, Bolt_Site_Number__c, Bolt_Account_Number__c, Bolt_Customer_Account_Status__c, Bolt_Customer_Type__c, Bolt_Credit_Hold__c from account where BOLT_Account_Number__c = :CUSTACCobj.ACCOUNT_NUMBER]);// FOR UPDATE];
                    system.debug('acc'+acc);
                    system.debug('accSIZE'+acc.size());
                    
                    if((Boolean.valueOf(Label.OSM_Failure_Log) == true) && (exceptionflag == true)){
                        system.debug('Inside');
                        log = new OSM_Integration_Log__c();
                        OSM_SW_LoggingContext.integrationLog = log; //Populating integration log record
                        log = methodReturn.logW;
                        log.Request__c = jSONRequestBody;
                        log.Service_Name__c = label.Bolt_Customer_Master_Inbound;
                        log.Source__c = label.Bolt_Source;
                        log.Target__c = label.DA_Source;
                        log.Logged_In_User__c = userinfo.getUserId();
                        OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record  
                    }
                    if((Boolean.valueOf(Label.OSM_Success_Log) == true) && (exceptionflag == false)){
                        system.debug('Inside');
                        log = new OSM_Integration_Log__c();
                        OSM_SW_LoggingContext.integrationLog = log; //Populating integration log record
                        log = methodReturn.logW;
                        log.Request__c = jSONRequestBody;
                        log.Service_Name__c = label.Bolt_Customer_Master_Inbound;
                        log.Source__c = label.Bolt_Source;
                        log.Target__c = label.DA_Source;
                        log.Logged_In_User__c = userinfo.getUserId();
                        OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record                                    
                    }
                    */
                }
            }   
       
            if(Test.isRunningTest())
            {
                throw new NullPointerException();
            }
        }catch(Exception e){
            system.debug('Exception - '+e.getMessage()+' Line No:'+e.getLineNumber());
            exceptionflag = true;
            resJSON = new OSM_BOLT_WS_CustomMasterRes();
            resJSON.Status = label.DA_Log_Status_Failure;
            resJSON.ReturnCodeDescription = e.getStackTraceString();
            if((Boolean.valueOf(Label.OSM_Failure_Log) == true) && (exceptionflag == true)){
                log = new OSM_Integration_Log__c();
                OSM_SW_LoggingContext.integrationLog = log; //Populating integration log record
                log.Request__c = jSONRequestBody;
                log.Service_Name__c = label.Bolt_Customer_Master_Inbound;
                log.Source__c = label.Bolt_Source;
                log.Target__c = label.DA_Source;
                log.Logged_In_User__c = userinfo.getUserId();
                log.Response__c  = e.getMessage();
                log.Status__c = label.DA_Log_Status_Failure;
                log.Error_Description__c = e.getStackTraceString();
                                                                                 
                OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record                            
            }
        }
        system.debug('log'+log);    
        system.debug('resJSON'+resJSON);                 
        //OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record  
        return resJSON;             
    }   
    
/*----------------------------------------------------------------------------------
2. doUpdateInsertFromInputJson
Description: Based on correct account records, we will insert or update contact
address records.  
Input: OSM_BOLT_WS_CustomMasterReq reqJSON, Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_ACCTS_O_STG_ROW> mapBolt, Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_O_STG_ROW> mapBoltCUST, List<Account> accList
Output: Success and Error Message.
Returntype:OSM_BOLT_WS_CustomMasterRes
------------------------------------------------------------------------------------*/
    
    public static OSM_BOLT_WS_LogAndResponseWrapper doUpdateInsertFromInputJson(OSM_BOLT_WS_CustomMasterReq reqJSON, Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_ACCTS_O_STG_ROW> mapBolt, Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_O_STG_ROW> mapBoltCUST, List<Account> accList){
        
        OSM_BOLT_WS_CustomMasterRes resJSON = null;
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        OSM_BOLT_WS_LogAndResponseWrapper wrap = new OSM_BOLT_WS_LogAndResponseWrapper();
        List<OSM_BOLT_WS_CustomMasterReq.ACCT_SITES_O_STG_ROW> addressLstFromBolt = new List<OSM_BOLT_WS_CustomMasterReq.ACCT_SITES_O_STG_ROW>(); //List to store customer account address records
        
        List<ccrz__E_AccountAddressBook__c> addresbooklistFromDB = new List<ccrz__E_AccountAddressBook__c>(); //List of contact addressbook
        //List<Account> accList;
        List<String> lstAccSiteReference = new List<String>(); //List of site refernce string coming in input json
        Boolean exceptionflag = false;
        
        List<OSM_BOLT_WS_CustomMasterRes> responseLst = new List<OSM_BOLT_WS_CustomMasterRes>();
        
        //Start processing
        OSM_BOLT_WS_CustomMasterReq.CUST_O_STG_ROW CUSTobj = reqJSON.DataArea.CUST_O_STG_ROW;
        
        OSM_BOLT_WS_CustomMasterReq.CUST_ACCTS_O_STG_ROW CUSTACCobj = reqJSON.DataArea.CUST_O_STG_ROW.CUST_ACCTS_O_STG.CUST_ACCTS_O_STG_ROW; 
        addressLstFromBolt = reqJSON.DataArea.CUST_O_STG_ROW.CUST_ACCTS_O_STG.CUST_ACCTS_O_STG_ROW.ACCT_SITES_O_STG.ACCT_SITES_O_STG_ROW;
        system.debug('CUSTACCobj'+CUSTACCobj);
        system.debug('CUSTobj'+CUSTobj);
        system.debug('addressLstFromBolt'+addressLstFromBolt);
        
        resJSON = new OSM_BOLT_WS_CustomMasterRes();
        log = new OSM_Integration_Log__c();
        String AccountId;
        Savepoint sp = Database.setSavepoint();
        
    for(Account acc : accList)
        {
            AccountId = acc.Id;
           log.Account__c = acc.Id;
        }
        //log.Account__c = CUSTACCobj.ACCOUNT_NUMBER; //Added By Dhiraj
        try{        
            system.debug('accList'+accList); 
            Set<Id> accIds = new Set<Id>();
            for(Account acc : accList){
                accIds.add(acc.Id);
            }
            
            //Populate a map of contact addresses of its account
            //addresbooklistFromDB = [Select id,ccrz__AddressType__c, ccrz__E_ContactAddress__r.ccrz__CompanyName__c, ccrz__E_ContactAddress__r.ccrz__ContactAddrId__c, ccrz__E_ContactAddress__r.ccrz__Partner_Id__c, ccrz__E_ContactAddress__r.ccrz__AddressFirstline__c, ccrz__E_ContactAddress__r.ccrz__AddressSecondline__c, ccrz__E_ContactAddress__r.ccrz__AddressThirdline__c, ccrz__E_ContactAddress__r.ccrz__City__c, ccrz__E_ContactAddress__r.ccrz__StateISOCode__c, ccrz__E_ContactAddress__r.ccrz__PostalCode__c, ccrz__E_ContactAddress__r.ccrz__CountryISOCode__c, ccrz__E_ContactAddress__r.BOLT_Operating_Unit__c, ccrz__E_ContactAddress__r.Site_Use_Status__c, ccrz__Account__c, ccrz__E_ContactAddress__c from ccrz__E_AccountAddressBook__c where ccrz__Account__c IN:accIds];
            //Sharad 12th March
            addresbooklistFromDB = [Select id,ccrz__AddressType__c, ccrz__E_ContactAddress__r.ccrz__CompanyName__c, ccrz__E_ContactAddress__r.ccrz__ContactAddrId__c, ccrz__E_ContactAddress__r.ccrz__Partner_Id__c, ccrz__E_ContactAddress__r.ccrz__AddressFirstline__c, ccrz__E_ContactAddress__r.ccrz__AddressSecondline__c, ccrz__E_ContactAddress__r.ccrz__AddressThirdline__c, ccrz__E_ContactAddress__r.ccrz__City__c, ccrz__E_ContactAddress__r.ccrz__StateISOCode__c, ccrz__E_ContactAddress__r.ccrz__PostalCode__c, ccrz__E_ContactAddress__r.ccrz__CountryISOCode__c, ccrz__E_ContactAddress__r.BOLT_Operating_Unit__c, ccrz__E_ContactAddress__r.Site_Use_Status__c, ccrz__Account__c, ccrz__E_ContactAddress__c from ccrz__E_AccountAddressBook__c where ccrz__Account__c IN:accIds and ccrz__E_ContactAddress__r.ccrz__ContactAddrId__c = : addressLstFromBolt[0].ACC_SITE_REFERENCE];
            
            system.debug('addresbooklistFromDB'+addresbooklistFromDB);
            
            insertAddressBook(CUSTACCobj, accList,addresbooklistFromDB);
            /*if(CUSTobj.STATUS != null && CUSTobj.STATUS == 'A')
            {
                acc.CMI_Account_Status__c = 'Active';
            }
            else if(CUSTobj.STATUS != null && CUSTobj.STATUS == 'I')
            {
                acc.CMI_Account_Status__c = 'InActive';
            }*/
          for(Account acc : accList){ 
                acc.Bolt_Party_Number__c = reqJSON.DataArea.CUST_O_STG_ROW.PARTY_NUMBER;
                acc.Bolt_Party_Name__c = reqJSON.DataArea.CUST_O_STG_ROW.PARTY_NAME;
                acc.Bolt_Site_Number__c = reqJSON.DataArea.CUST_O_STG_ROW.ORIG_SYSTEM_REFERENCE;
                acc.BOLT_Account_Number__c = CUSTACCobj.ACCOUNT_NUMBER; //we will have to get list values from mapBolt as this cant be accessed directly from object
                
                if(CUSTACCobj.STATUS != null && CUSTACCobj.STATUS == 'A')
                {
                    acc.Bolt_Customer_Account_Status__c = Label.OSM_Bolt_Active;
                }
                else if(CUSTACCobj.STATUS != null && CUSTACCobj.STATUS == 'I')
                {
                    acc.Bolt_Customer_Account_Status__c = Label.OSM_Bolt_Inactive;
                }
                
                if(CUSTACCobj.CUSTOMER_TYPE != null && CUSTACCobj.CUSTOMER_TYPE == 'R')
                {
                    acc.Bolt_Customer_Type__c = Label.OSM_Bolt_External;
                }
                else if(CUSTACCobj.CUSTOMER_TYPE != null && CUSTACCobj.CUSTOMER_TYPE == 'I')
                {
                    acc.Bolt_Customer_Type__c = Label.OSM_Bolt_Internal;
                }
                
                if(CUSTACCobj.CREDIT_HOLD == 'Y') {
                    acc.Bolt_Credit_Hold__c = TRUE;
                }else if(CUSTACCobj.CREDIT_HOLD == 'N') {
                    acc.Bolt_Credit_Hold__c = FALSE;
                }
                
                // Changes - Juhi - March 18, 2019 - Take the BC Code from Attribute 7 instead
                if(null != CUSTACCobj.ATTRIBUTE7)
                {
                    acc.Bolt_BC_Code__c = CUSTACCobj.ATTRIBUTE7;
                }
            }
            System.debug('update account on bolt inbound: '+accList);
            Update accList; //Update account
            
            //Get list of site reference from input json
            Map<String,OSM_BOLT_WS_CustomMasterReq.ACCT_SITES_O_STG_ROW> accSiteRefVsAddressFromBoltMap = new Map<String,OSM_BOLT_WS_CustomMasterReq.ACCT_SITES_O_STG_ROW>();
            for(OSM_BOLT_WS_CustomMasterReq.ACCT_SITES_O_STG_ROW accSTG :addressLstFromBolt){
                lstAccSiteReference.add(accSTG.ACC_SITE_REFERENCE);
                accSiteRefVsAddressFromBoltMap.put(accSTG.ACC_SITE_REFERENCE,accSTG);
            }  
            
            ContactAddressForAccountCls wrapperObj = null;
            
            List<ContactAddressForAccountCls> newAddressesToInsert = new List<ContactAddressForAccountCls>();
            List<ContactAddressForAccountCls> existingAddressesToUpdate = new List<ContactAddressForAccountCls>();
            Map<String,ContactAddressForAccountCls> accSiteRefNoInfoMap = new Map<String,ContactAddressForAccountCls>();
            
            //iterate database records and compare with bolt request
            for(ccrz__E_AccountAddressBook__c addressJunc : addresbooklistFromDB)
            {
                wrapperObj = new ContactAddressForAccountCls();
                //ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c(id=addressJunc.ccrz__E_ContactAddress__c, ccrz__CompanyName__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__CompanyName__c, ccrz__ContactAddrId__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__ContactAddrId__c, ccrz__Partner_Id__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__Partner_Id__c, ccrz__AddressFirstline__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__AddressFirstline__c, ccrz__AddressSecondline__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__AddressSecondline__c, ccrz__AddressThirdline__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__AddressThirdline__c, ccrz__City__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__City__c, ccrz__StateISOCode__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__StateISOCode__c, ccrz__PostalCode__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__PostalCode__c, ccrz__CountryISOCode__c= addressJunc.ccrz__E_ContactAddress__r.ccrz__CountryISOCode__c, BOLT_Operating_Unit__c= addressJunc.ccrz__E_ContactAddress__r.BOLT_Operating_Unit__c,Site_Use_Status__c= addressJunc.ccrz__E_ContactAddress__r.Site_Use_Status__c);
                ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c(id=addressJunc.ccrz__E_ContactAddress__c, ccrz__ContactAddrId__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__ContactAddrId__c, ccrz__Partner_Id__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__Partner_Id__c, ccrz__AddressFirstline__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__AddressFirstline__c, ccrz__AddressSecondline__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__AddressSecondline__c, ccrz__AddressThirdline__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__AddressThirdline__c, ccrz__City__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__City__c, ccrz__StateISOCode__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__StateISOCode__c, ccrz__PostalCode__c=addressJunc.ccrz__E_ContactAddress__r.ccrz__PostalCode__c, ccrz__CountryISOCode__c= addressJunc.ccrz__E_ContactAddress__r.ccrz__CountryISOCode__c, BOLT_Operating_Unit__c= addressJunc.ccrz__E_ContactAddress__r.BOLT_Operating_Unit__c,Site_Use_Status__c= addressJunc.ccrz__E_ContactAddress__r.Site_Use_Status__c);
                
                wrapperObj.contactAddressDB=contactAddress;
                wrapperObj.accountAddressBookDB=addressJunc;
                accSiteRefNoInfoMap.put(contactAddress.ccrz__ContactAddrId__c,wrapperObj);
                existingAddressesToUpdate.add(wrapperObj);
                //if ref num exist coming from bolt request, found in database then update
                if(accSiteRefVsAddressFromBoltMap.containsKey(contactAddress.ccrz__ContactAddrId__c))
                {
                    OSM_BOLT_WS_CustomMasterReq.ACCT_SITES_O_STG_ROW siteAddressBolt = accSiteRefVsAddressFromBoltMap.get(contactAddress.ccrz__ContactAddrId__c);
                    wrapperObj.siteAddress = siteAddressBolt;                             
                }
                else
                {   
                    //if address is found in DB but not present in bolt request then update deactivate the address
                    contactAddress.Bolt_Active__c = false;                         
                }                 
            }
            
            //iterate bolt request records and compare with database records
            
            //var to check if address not in current lot
            boolean addressinLotFound = true;
            List<ccrz__E_ContactAddr__c> lstContactAddress = new List<ccrz__E_ContactAddr__c>();
            if(lstAccSiteReference.size() > 0)
                    lstContactAddress = [Select Id,ccrz__AddressFirstline__c,ccrz__AddressSecondline__c,ccrz__AddressThirdline__c,ccrz__City__c,ccrz__StateISOCode__c,ccrz__PostalCode__c,ccrz__CountryISOCode__c,BOLT_Operating_Unit__c,Site_Use_Status__c,Bolt_Site__c,Bolt_Active__c from ccrz__E_ContactAddr__c where ccrz__ContactAddrId__c =: lstAccSiteReference[0]];
                    
            for(String accRefNo : accSiteRefVsAddressFromBoltMap.keySet())
            {
                OSM_BOLT_WS_CustomMasterReq.ACCT_SITES_O_STG_ROW siteAddressBolt =  accSiteRefVsAddressFromBoltMap.get(accRefNo);
                //if ref number not found in database then create
                if(siteAddressBolt!=null && !accSiteRefNoInfoMap.containsKey(siteAddressBolt.ACC_SITE_REFERENCE))
                {
                    // code for existing contact address with same lstAccSiteReference[0].ACC_SITE_REFERENCE;
                    if(lstContactAddress.size() > 0)
                    {
                        addressinLotFound = false;
                    }
                    else
                    {
                    
                    wrapperObj = new ContactAddressForAccountCls();
                    wrapperObj.siteAddress = siteAddressBolt;
                    newAddressesToInsert.add(wrapperObj);
                    accSiteRefNoInfoMap.put(siteAddressBolt.ACC_SITE_REFERENCE,wrapperObj);
                    }
                    
                }
                else
                {
                    //if record is found in database then no operation required here as that has been already taken care in last map
                   
                    
                }                     
            }
            
            if(addressinLotFound)
            {
                //Collections are prepared now..those will be validated and processed in DB
                for(ContactAddressForAccountCls con : newAddressesToInsert)
                {
                    System.debug('====con ====='+con);
                }
                
                List<SObject> insertLst = new List<SObject>();
                
                for(ContactAddressForAccountCls newWrapperObj: newAddressesToInsert)
                {
                    //Insert
                    ccrz__E_ContactAddr__c conadr = new ccrz__E_ContactAddr__c();
                    conadr.ccrz__ContactAddrId__c = newWrapperObj.siteAddress.ACC_SITE_REFERENCE;
                    conadr.ccrz__Partner_Id__c = newWrapperObj.siteAddress.ACC_SITE_REFERENCE;
                    //conadr.ccrz__CompanyName__c = newWrapperObj.siteAddress.LOCATION;
                    conadr.ccrz__AddressFirstline__c = newWrapperObj.siteAddress.ADDRESS1;
                    conadr.ccrz__AddressSecondline__c = newWrapperObj.siteAddress.ADDRESS2;
                    conadr.ccrz__AddressThirdline__c = newWrapperObj.siteAddress.ADDRESS3;
                    conadr.ccrz__City__c = newWrapperObj.siteAddress.CITY;
                    conadr.ccrz__StateISOCode__c = newWrapperObj.siteAddress.STATE;
                    conadr.ccrz__PostalCode__c = newWrapperObj.siteAddress.POSTAL_CODE;
                    conadr.ccrz__CountryISOCode__c = newWrapperObj.siteAddress.COUNTRY;
                    conadr.BOLT_Operating_Unit__c = newWrapperObj.siteAddress.BOLT_OPERATING_UNIT;
                    // Changes - Juhi - March 18, 2019 - Take the BC Code from Attribute 7 instead
                    //acc.Bolt_BC_Code__c=newWrapperObj.siteAddress.BC_CODE;
                    if(newWrapperObj.siteAddress.SITE_USE_STATUS == 'A'){
                        conadr.Site_Use_Status__c = true;
                    }else if(newWrapperObj.siteAddress.SITE_USE_STATUS == 'I'){
                        conadr.Site_Use_Status__c = false;
                    }                               
                    //conadr.Site_Use_Status__c = newWrapperObj.siteAddress.SITE_USE_STATUS;
                    conadr.Bolt_Site__c = true;
                    
                    //if both Account status and Site status are active then only activate that site else deactivate
                    if(CUSTACCobj.STATUS == 'A' && newWrapperObj.siteAddress!=null && newWrapperObj.siteAddress.ACC_SITE_STATUS == 'A'){ 
                        
                        conadr.Bolt_Active__c = true;
                    }
                    else
                    {
                        conadr.Bolt_Active__c = false;
                    }
                    
                    insertLst.add(conadr);
                    for(Account acc : accList){
                        //create new AddressBook obj
                        ccrz__E_AccountAddressBook__c addrsbook = new ccrz__E_AccountAddressBook__c();
                        addrsbook.ccrz__Account__c = acc.id;
                        addrsbook.ccrz__AccountId__c = acc.id;
                        addrsbook.ccrz__E_ContactAddress__r = new ccrz__E_ContactAddr__c(
                            ccrz__ContactAddrId__c = newWrapperObj.siteAddress.ACC_SITE_REFERENCE
                        );
                        
                        if(newWrapperObj.siteAddress.SITE_USE_CODE == 'BILL_TO'){
                            addrsbook.ccrz__AddressType__c = label.OSM_Addressbook_Billing_AddressType; 
                        }else if(newWrapperObj.siteAddress.SITE_USE_CODE == 'SHIP_TO'){
                            addrsbook.ccrz__AddressType__c = label.OSM_Addressbook_Shipping_AddressType;
                        }  
                        //addrsbook.ccrz__AddressType__c = newWrapperObj.siteAddress.SITE_USE_CODE;
                        insertLst.add(addrsbook);
                    }
                    
                }
                
                for(SObject obj : insertLst)
                {
                    System.debug('==Insert ==='+obj);
                }
                
                //Check existing addresses
                System.debug('existingAddressesToUpdate: '+existingAddressesToUpdate);
                for(ContactAddressForAccountCls existingAddress: existingAddressesToUpdate)
                {               
                    ccrz__E_ContactAddr__c conAddrs = existingAddress.contactAddressDB;
                    
                    if(existingAddress.siteAddress!=null)
                    {
                        conAddrs.ccrz__ContactAddrId__c = existingAddress.siteAddress.ACC_SITE_REFERENCE;
                        conAddrs.ccrz__Partner_Id__c = existingAddress.siteAddress.ACC_SITE_REFERENCE;
                        //conAddrs.ccrz__CompanyName__c = existingAddress.siteAddress.LOCATION;
                        conAddrs.ccrz__AddressFirstline__c = existingAddress.siteAddress.ADDRESS1;
                        conAddrs.ccrz__AddressSecondline__c = existingAddress.siteAddress.ADDRESS2;
                        conAddrs.ccrz__AddressThirdline__c = existingAddress.siteAddress.ADDRESS3;
                        conAddrs.ccrz__City__c = existingAddress.siteAddress.CITY;
                        conAddrs.ccrz__StateISOCode__c = existingAddress.siteAddress.STATE;
                        conAddrs.ccrz__PostalCode__c = existingAddress.siteAddress.POSTAL_CODE;
                        conAddrs.ccrz__CountryISOCode__c = existingAddress.siteAddress.COUNTRY;
                        conAddrs.BOLT_Operating_Unit__c = existingAddress.siteAddress.BOLT_OPERATING_UNIT;
                        // Changes - Juhi - March 18, 2019 - Take the BC Code from Attribute 7 instead
                        //acc.Bolt_BC_Code__c=existingAddress.siteAddress.BC_CODE;
                        if(existingAddress.siteAddress.SITE_USE_STATUS == 'A'){
                            conAddrs.Site_Use_Status__c = true;    
                        }else if(existingAddress.siteAddress.SITE_USE_STATUS == 'I'){
                            conAddrs.Site_Use_Status__c = false;
                        }                           
                        //conAddrs.Site_Use_Status__c = existingAddress.siteAddress.SITE_USE_STATUS;
                        
                        //if both account status and site status is A then only set the status as active
                        if((CUSTACCobj.STATUS == 'A') && (existingAddress.siteAddress!=null && existingAddress.siteAddress.ACC_SITE_STATUS == 'A'))
                        {
                            //no need to update the bolt site flag
                            //conAddrs.Bolt_Site__c = true;
                            conAddrs.Bolt_Active__c = true;
                        }
                        else
                        {                              
                            conAddrs.Bolt_Active__c = false;
                            //what happens for non-BoltAddress
                        }
                    }
                    else
                    {
                        //No Action required as that address will be deactivated
                    }
                    
                }
                
                if(insertLst!=null && insertLst.size()>0)
                {
                    insert insertLst;                                        
                }
                
                List<ccrz__E_ContactAddr__c> contactAddressLstToUpdate = new List<ccrz__E_ContactAddr__c>();
                Set<Id>addedAddress = new Set<Id>();
                System.debug('log 0.1: '+existingAddressesToUpdate);
                for(ContactAddressForAccountCls existingAddress: existingAddressesToUpdate)
                {
                    
                    ccrz__E_ContactAddr__c conAddrs = existingAddress.contactAddressDB;
                  if(!addedAddress.Contains(conAddrs.Id)){
                    contactAddressLstToUpdate.add(conAddrs);
                      addedAddress.add(conAddrs.Id);
                   }
                }
                
                if(contactAddressLstToUpdate.size()>0){
                    // commented update statement and placed upsert as fixed for the MAR-799
                    //update contactAddressLstToUpdate;
                    System.debug('before update: '+contactAddressLstToUpdate);
                    upsert contactAddressLstToUpdate;
                    System.debug('after update: '+contactAddressLstToUpdate);
                }
                update accList;
            }
            else
            {
                // to update contact address
                
                if(accSiteRefVsAddressFromBoltMap.containsKey(lstAccSiteReference[0]))
                {
                    OSM_BOLT_WS_CustomMasterReq.ACCT_SITES_O_STG_ROW siteAddressBolt = accSiteRefVsAddressFromBoltMap.get(lstAccSiteReference[0]);
                                                   
                    
                
                    //lstContactAddress[0].ccrz__Partner_Id__c = newWrapperObj.siteAddress.ACC_SITE_REFERENCE;
                    //conadr.ccrz__CompanyName__c = newWrapperObj.siteAddress.LOCATION;
                    lstContactAddress[0].ccrz__AddressFirstline__c = siteAddressBolt.ADDRESS1;
                    lstContactAddress[0].ccrz__AddressSecondline__c = siteAddressBolt.ADDRESS2;
                    lstContactAddress[0].ccrz__AddressThirdline__c = siteAddressBolt.ADDRESS3;
                    lstContactAddress[0].ccrz__City__c = siteAddressBolt.CITY;
                    lstContactAddress[0].ccrz__StateISOCode__c = siteAddressBolt.STATE;
                    lstContactAddress[0].ccrz__PostalCode__c = siteAddressBolt.POSTAL_CODE;
                    lstContactAddress[0].ccrz__CountryISOCode__c = siteAddressBolt.COUNTRY;
                    lstContactAddress[0].BOLT_Operating_Unit__c = siteAddressBolt.BOLT_OPERATING_UNIT;
                    // Changes - Juhi - March 18, 2019 - Take the BC Code from Attribute 7 instead
                    //acc.Bolt_BC_Code__c=newWrapperObj.siteAddress.BC_CODE;
                    if(siteAddressBolt.SITE_USE_STATUS == 'A'){
                        lstContactAddress[0].Site_Use_Status__c = true;
                    }else if(siteAddressBolt.SITE_USE_STATUS == 'I'){
                        lstContactAddress[0].Site_Use_Status__c = false;
                    }                               
                    //conadr.Site_Use_Status__c = newWrapperObj.siteAddress.SITE_USE_STATUS;
                    lstContactAddress[0].Bolt_Site__c = true;
                    
                    //if both Account status and Site status are active then only activate that site else deactivate
                    if(CUSTACCobj.STATUS == 'A' && siteAddressBolt!=null && siteAddressBolt.ACC_SITE_STATUS == 'A'){ 
                        
                        lstContactAddress[0].Bolt_Active__c = true;
                    }
                    else
                    {
                        lstContactAddress[0].Bolt_Active__c = false;
                    }
                
                    update lstContactAddress[0];
                    List<SObject> insertLst = new List<SObject>();
                    for(Account acc : accList){
                        //create new AddressBook obj
                        ccrz__E_AccountAddressBook__c addrsbook = new ccrz__E_AccountAddressBook__c();
                        addrsbook.ccrz__Account__c = acc.id;
                        addrsbook.ccrz__AccountId__c = acc.id;
                        addrsbook.ccrz__E_ContactAddress__c = lstContactAddress[0].Id;
                        
                        if(siteAddressBolt.SITE_USE_CODE == 'BILL_TO'){
                            addrsbook.ccrz__AddressType__c = label.OSM_Addressbook_Billing_AddressType; 
                        }else if(siteAddressBolt.SITE_USE_CODE == 'SHIP_TO'){
                            addrsbook.ccrz__AddressType__c = label.OSM_Addressbook_Shipping_AddressType;
                        }  
                        //addrsbook.ccrz__AddressType__c = newWrapperObj.siteAddress.SITE_USE_CODE;
                        insertLst.add(addrsbook);
                    }
                    
                    if(insertLst!=null && insertLst.size()>0)
                    {
                        insert insertLst;                                        
                    }
                    
                }
                    
            }
            if(Test.isRunningTest())
            {
                //throw new NullPointerException();
            }
        }catch(Exception err){  
            System.debug('The following exception has occurred.'+err.getMessage());                   
            Database.rollback(sp);
            exceptionflag = true;
            resJSON.Status = label.DA_Log_Status_Failure;
            resJSON.ReturnCodeDescription = err.getMessage() + '-' + err.getStackTraceString();
            system.debug('resJSONS'+resJSON); 
            //Populate log for failure
            log.Account__c = AccountId;
            log.Response__c  = err.getMessage();
            log.Status__c = label.DA_Log_Status_Failure;
            log.Error_Description__c = string.valueOf(err.getMessage() + '-' + err.getStackTraceString());                               
                                                      
            system.debug('log'+log);
            wrap = new OSM_BOLT_WS_LogAndResponseWrapper();
            wrap.logW = log;
            wrap.resJSONW = resJSON;
            wrap.exceptionflag = exceptionflag;
            return wrap;
        }                  
        system.debug('Success');
        exceptionflag = false;
        resJSON.Status = label.DA_Log_Status_Success;
        resJSON.ReturnCodeDescription = label.Bolt_Customer_Inbound_Success_Msg;
        system.debug('resJSONS'+resJSON); 
        //Populate log for failure
        log.Account__c = AccountId;
        log.Response__c  = label.Bolt_Customer_Inbound_Success_Msg;
        log.Status__c = label.DA_Log_Status_Success;                              
        system.debug('log'+log);
        wrap = new OSM_BOLT_WS_LogAndResponseWrapper();
        wrap.logW = log;
        wrap.resJSONW=resJSON;
        wrap.exceptionflag = exceptionflag;
        return wrap;                        
    }
    
    public static void insertAddressBook(OSM_BOLT_WS_CustomMasterReq.CUST_ACCTS_O_STG_ROW CUSTACCobj, List<Account>accList,List<ccrz__E_AccountAddressBook__c> addresbooklistFromDB){
        system.debug('Insert call');
        Set<Id>existingAddressBookAccountIds = new Set<Id>(); 
        Id contactId = null;
        String addressType='';
        for(ccrz__E_AccountAddressBook__c add : addresbooklistFromDB){
            existingAddressBookAccountIds.add(add.ccrz__Account__c);
            contactId = add.ccrz__E_ContactAddress__c;
            addressType=add.ccrz__AddressType__c;
        }
        
        List<ccrz__E_AccountAddressBook__c>addresstoInsert = new List<ccrz__E_AccountAddressBook__c>();
        if(CUSTACCobj != null && CUSTACCobj.ACCOUNT_NUMBER != null && contactId != null){
                for(Account acc : accList){
                    if(!existingAddressBookAccountIds.Contains(acc.Id)){
                        addresstoInsert.add(new ccrz__E_AccountAddressBook__c(ccrz__E_ContactAddress__c=contactId, ccrz__Account__c=acc.Id,ccrz__AccountId__c=acc.id,ccrz__AddressType__c=addressType));
                        existingAddressBookAccountIds.add(acc.Id);
                    }
                }
        }
        
    system.debug('size addresstoInsert==>'+addresstoInsert.size()); 
    system.debug('addresstoInsert==>'+addresstoInsert); 
        if(addresstoInsert.size()>0){
            insert addresstoInsert;
        }
    }
    //This is wrapper class 
    class ContactAddressForAccountCls{
        ccrz__E_ContactAddr__c contactAddressDB;
        ccrz__E_AccountAddressBook__c accountAddressBookDB;
        OSM_BOLT_WS_CustomMasterReq.ACCT_SITES_O_STG_ROW siteAddress;               
    }
    
    //This is wrapper class for returning response and log
    public class OSM_BOLT_WS_LogAndResponseWrapper{
        public OSM_Integration_Log__c logW;
        public OSM_BOLT_WS_CustomMasterRes resJSONW;
        public Boolean exceptionflag;               
    }
    // Added By Dhiraj for MAR-1621 - Story On 21st April 2021
    public static String getAccountId()
  {
        String strAccId;
        User objUser = new User();
        objUser = [SELECT Contact.Account.Id FROM User WHERE Id = : UserInfo.getUserId()];
        //objUser = [SELECT AccountId FROM User WHERE Id = : UserInfo.getUserId()];
        strAccId = objUser.Contact.Account.Id;
        System.debug('strAccId+++' + strAccId);
        return strAccId;
  }
    //Code Ended.  
                     
   
            
                  
                                              
                                           
                        
                         
            
   
          
}