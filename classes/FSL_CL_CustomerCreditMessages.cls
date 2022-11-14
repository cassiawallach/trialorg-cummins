/**********************************************************************
Name: FSL_CL_CustomerCreditMessages
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose: This class is used for Cutomer credit Messages Integration.

=======================================================================
=======================================================================

VERSION  AUTHOR            DATE                DETAIL                                 
1.0      PiyushR           2/8/2019            INITIAL DEVELOPMENT
2.0      Harsha Ragam      10/15/2020          Mule API Changes
3.0     Prasanna Savalam   6/16/2022           Changes to add Named Credentials
***********************************************************************/
public class FSL_CL_CustomerCreditMessages {
    
    //Static Boolean isEligibleForAppLogging = FSL_Utility.setEligibilityForApplicationLogging();
    Static Boolean isEligibleForAppLogging =true;
    Static String executionLog = 'Log Start';
    public static WorkOrder woData{get;set;}
    public static String requestJSON;
    
    public static WorkOrder getCustomerCreditMEssageHeader(String jobID) {
        woData = [SELECT Id, Account.Location__c, Account.CSS_DistributorCode__c, ServiceTerritoryId, 
                  ServiceTerritory.Location_Code__c, Account.CSS_DBCode__c, Payer__c, Payer__r.FSL_ERP_Customer_Code__c, 
                  Asset.Name, Asset.Service_Model__c, CreatedDate 
                  FROM WorkOrder WHERE Id=: jobID LIMIT 1];
        System.debug('::: WorkOrder Data - '+woData);
        return woData;
    }
    
    public static void customerCreditMessageTriggerHelper(Map<Id, workorder> newMap, Map<Id,workorder> oldMap) {
        Set<ID> wordOrdIds = new Set<Id>();
        for(workorder wo : newMap.values()) {
            if(wo.Payer__c != oldMap.get(wo.Id).Payer__c) // || // Check Account Change //wo.ServiceTerritoryId != oldMap.get(wo.Id).ServiceTerritoryId)
            {
                //getCustomerCreditFutureService(wo.Id);
                wordOrdIds.add(wo.Id);
            }
        }
        System.debug(':::customerCreditMessageTriggerHelper = '+wordOrdIds);
        updatePayerChangeOnErpMessage(wordOrdIds);
    }
    
    private static void updatePayerChangeOnErpMessage(Set<Id> workOrdIds) {
        List<ERP_Message__c> erpMessageToUpdate = new List<ERP_Message__c>();
        if(!workOrdIds.isEmpty()) {
            for(ERP_Message__c erpm : [Select Id, Payer_Change__c FROM ERP_Message__c where Service_Order__c IN: workOrdIds]) {
                erpm.Payer_Change__c = true;
                erpMessageToUpdate.add(erpm);
            }
        }
        System.debug('::: updatePayerChangeOnErpMessage = '+erpMessageToUpdate);
        if(!erpMessageToUpdate.isEmpty()) update erpMessageToUpdate;
    }
    
    public static List<messageWrapper> getCreditMessageWebService(String serviceJob) {
        List<messageWrapper> messageList = new List<messageWrapper>();
        try {
            System.debug(':::getCreditMessageWebService start - '+serviceJob);
            FSL_CL_CustomerCreditResponseParser mro;
            DateTime startTime = System.Now();
            executionLog = FSL_ApplicationLogger.logStart('FSL_CL_CustomerCreditMessages : getCreditMessageWebService method ' + startTime, executionLog , isEligibleForAppLogging);
            WorkOrder wo = FSL_CL_CustomerCreditMessages.getCustomerCreditMEssageHeader(serviceJob);
            System.debug('::: WorkOrder#59 - '+wo);
            ERP_Message__c  erpMessage;
            List<ERP_Message__c> erpMessageList = [SELECT Id, Service_Order__c, Customer_Credit_Message__c, Credit_Message_Received__c FROM ERP_Message__c where Service_Order__c =: serviceJob AND Credit_Message_Received__c = true];
            System.debug('::: erpMessageList - '+erpMessageList);
            if(erpMessageList.isEmpty()) {
                erpMessage = new ERP_Message__c();
                erpMessage.Service_Order__c = serviceJob;
            } else {
                erpMessage = erpMessageList[0];
            }
            System.debug('::: erpMessage - '+erpMessage);
               String response ='';
          //PS  string endPoint;
            // HttpRequest req = new HttpRequest();
        //PS    CSS_Integration_Details__c conDetails =null;
       /*PS     if(Test.isRunningTest()) {
                endPoint = 'https://services-stg.cummins.com/csswarranty/bmscustomercredit';
                System.debug(':::Endpoint in Test - '+endPoint);
                executionLog = FSL_ApplicationLogger.logMessage('End point URL '+endPoint,executionLog,isEligibleForAppLogging);
            } else {
                conDetails = CSS_getConnnectionDetails.getConnection('FSL_MOVEXCustomercreditmessage');//CSS_Integration_Details__c.getValues('FSL_MOVEXCustomercreditmessage');
                System.debug('conDetails'+conDetails);
                endPoint = conDetails.End_Point__c;
                system.debug('EndPoint:'+endPoint);
            }
            if(test.isRunningTest()) {
                conDetails=new  CSS_Integration_Details__c();
            }  PS*/
         //PS   CG_OP_OAGWrapper accessTokenOPWrap = null;
            CG_OP_OAGWrapper outputWrapper = new CG_OP_OAGWrapper(); //Added by Prasanna for ROAD-368
            FSL_IP_NamedCredentialWrapper reqWrapper= new FSL_IP_NamedCredentialWrapper();//Added by Prasanna for ROAD-368
            
            
         /*PS   if(!Test.isRunningTest()) {
                accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('FSL_MOVEXCustomercreditmessage').AuthEnv__c,'FSL_MOVEXCustomercreditmessage');//Added  OAG to Mule 19/05/2020     
            } else {
                accessTokenOPWrap =new CG_OP_OAGWrapper();
            } PS*/
            if(wo.ServiceTerritoryId != null && wo.Payer__c != null) {
                System.debug('::: WorkOrder Details - '+wo.ServiceTerritoryId +' and '+ wo.Payer__c);
                User usr = new User();
                usr = [SELECT Id,ERP__c
                       FROM User
                       WHERE Id=:UserInfo.getUserId() LIMIT 1];
                String TargetERP;
                TargetERP = (String)usr.ERP__c;
                /*PS requestJSON = '{'+
                    '\"Header\":{' +
                    '      \"Sender\":{' +
                    '          \"ServiceName\": \"GetCustomerCreditMessage\",' +
                    '           \"SenderID\": \"CSS\"'+
                    '      },' +
                    '      \"Target\": { \"TargetID\": \"'+TargetERP+'\" },' +
                    '      \"Location\": { \"LocationID\": \"'+ wo.ServiceTerritory.Location_Code__c +'\" }' +
                    '  },'+
                    '   \"DataArea\":{' +
                    '     \"CustomerNumber\": \"'+ wo.Payer__r.FSL_ERP_Customer_Code__c+'\"'+
                    '  }' +
                    '} ';
                requestJSON = requestJSON.replaceAll('"null"', '""'); //Added by Prasanna for ROAD-368
                system.debug(':::requestJSON***'+requestJSON);
                reqwrapper.jsonReqBody = requestJSON;  PS*/ 
                
                reqwrapper.WorkOrder = serviceJob; //Added by Prasanna for ROAD-368
                executionLog = FSL_ApplicationLogger.logMessage('JSON Request Body '+requestJSON,executionLog,isEligibleForAppLogging);
                // FSL_ApplicationLogger.createLogFuture(executionLog, isEligibleForAppLogging ,startTime , System.Now(),serviceJob);
              //PS  HttpRequest req = new HttpRequest();
            //PS    Http http = new Http();
             //PS   endPoint=endPoint+'/v1/credit?sender=CSS&target='+TargetERP+'&locationId='+wo.ServiceTerritory.Location_Code__c+'&customerNumber='+wo.Payer__r.FSL_ERP_Customer_Code__c;
            //PS    req.setEndpoint(endPoint);
            //PS    req.setMethod('GET');
           //PS     req.setTimeout(120000);
                // req.setHeader('Content-Type','application/json');
                
                //Added by Prasanna for ROAD-368
                 String reqParam ='/v1/credit?sender=CSS&target='+TargetERP+'&locationId='+wo.ServiceTerritory.Location_Code__c+'&customerNumber='+wo.Payer__r.FSL_ERP_Customer_Code__c;
                reqWrapper.methodType = 'GET';
                reqWrapper.NamedCredential = 'FSL_NC_Warranty';
               	reqWrapper.Path = reqParam;
                reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;   
                system.debug('endPointURL Customer Credit Messages' +  ' ' + reqWrapper.endPoint);
                /*PS     if(!Test.isRunningTest()) {
                    req.setHeader('client-id',conDetails.Username__c);
                    req.setHeader('client-secret',conDetails.Passcode__c);
                }
                req.setHeader('Authorization', 'Bearer '+ accessTokenOPWrap.accessToken);
                system.debug(':::req.setHeader***'+req);
                // req.setBody(requestJSON);
                HTTPResponse res ;   PS*/
          /*PS    if(Test.isRunningTest()) {
                    // response = FSL_TestDataUtility.getCustomerCreditMessage();
                    response = FSL_TestDataUtility.getCustomerCreditMsgJSON();
                } else {
                    res = http.send(req);
                    response = res.getBody();
                    executionLog = FSL_ApplicationLogger.logMessage('Response Body '+response,executionLog,isEligibleForAppLogging);
                }  PS*/
                
                //Added by Prasanna for ROAD-368
                if(reqWrapper!=null){
                     outputWrapper =  FSL_WS_Mule.calloutNamedCredentials(reqWrapper); 
                     response = outputWrapper.response.getBody();
                    
                }
                system.debug(':::response***'+response);
                FSL_CL_CustomerCreditResponseParser creditMessageData;
                boolean flag = true;
                if(String.isNotBlank(response)) {
                    erpMessage.Customer_Credit_Message__c = response;
                    creditMessageData = (FSL_CL_CustomerCreditResponseParser)JSON.deserialize((erpMessage.Customer_Credit_Message__c).unescapeHtml4(), FSL_CL_CustomerCreditResponseParser.Class);
                    system.Debug(':::creditMessageData***'+creditMessageData);
                    system.Debug(':::creditMessageData.DataArea***'+creditMessageData.DataArea);
                    if(creditMessageData != null && creditMessageData.DataArea != null && creditMessageData.DataArea.CreditMessageDetails != null) 
                    {
                        for(FSL_CL_CustomerCreditResponseParser.CreditMessageDetails fslCCR : creditMessageData.DataArea.CreditMessageDetails) 
                        {
                            system.Debug(':::###'+fslCCR.CreditMessageCode);
                            if(fslCCR.CreditMessageCode!=null && fslCCR.CreditMessageCode!='') {
                                if((fslCCR.CreditMessageCode).trim() == 'Y'){
                                    erpMessage.Customer_Credit_Error_Msg__c = '<p style="color: red;">Save and Send for Assignment not available for this Payer, please select a different Payer</p>';
                                }
                                else{
                                    erpMessage.Customer_Credit_Error_Msg__c = '<p>Save and send for assignment available for the payer</p>';
                                }
                                if(fslCCR.CreditMessageCode!=null && fslCCR.CreditMessageCode!=''){
                                    messageWrapper msgWrap = new messageWrapper();
                                    msgWrap.CreditMessage = fslCCR.CreditMessage;
                                    msgWrap.CreditMessageCode = fslCCR.CreditMessageCode;
                                    messageList.add(msgWrap);   
                                }
                                flag = false;
                            }
                            else if ((fslCCR.CreditMessageCode ==null || fslCCR.CreditMessageCode =='') && flag){
                                erpMessage.Customer_Credit_Error_Msg__c = '<p>Save and send for assignment available for the payer</p>';
                            }
                        }
                    }
                    else {
                        erpMessage.Customer_Credit_Error_Msg__c = '<p>Save and send for assignment available for the payer</p>';
                        erpMessage.Customer_Credit_Message__c = null;
                    }
                } else {
                    system.debug(':::in else ***');
                    erpMessage.Customer_Credit_Error_Msg__c = '<p>Save and send for assignment available for the payer</p>';
                    erpMessage.Customer_Credit_Message__c = null;
                }
            } else {
                erpMessage.Customer_Credit_Error_Msg__c = '<p>Save and send for assignment available for the payer</p>';
                erpMessage.Customer_Credit_Message__c = null;
            }
            system.debug('::: erpMessage to upsert === '+erpMessage);
            erpMessage.Payer_Change__c = false;
            erpMessage.Credit_Message_Received__c = true;
            upsert erpMessage;
        }
        catch(Exception ex) {
            // FSL_ApplicationLogger.createLogFuture(executionLog, isEligibleForAppLogging ,startTime , System.Now(),serviceJob);
            System.debug(':::Error in Customer credit Message Servive Call : ' + ex.getMessage());
            system.debug(':::Print stack trace'+ex.getStackTraceString());
        }
        System.debug('::: messageList - '+messageList);
        return messageList;
    } 
    
    @AuraEnabled
    public static List<messageWrapper> getCustomerCreditMessageData(String serviceJob) {
        List<messageWrapper> messageList = new List<messageWrapper>();
        FSL_CL_CustomerCreditResponseParser creditMessageData;
        System.debug('::: serviceJob = '+serviceJob);
        List<ERP_Message__c > erpMessages = [Select Id, Service_Order__c, Payer_Change__c, Customer_Credit_Message__c  From ERP_Message__c where Service_Order__c =: serviceJob AND Credit_Message_Received__c=true];
        System.debug('::: erpMessages = '+erpMessages);
        try {
            String message;
            if(erpMessages.isEmpty() || (!erpMessages.isEmpty() && erpMessages[0].Payer_Change__c)) {
                messageList = getCreditMessageWebService(serviceJob);
            } 
            else {
                System.debug('::: erpMessages else - '+erpMessages);
                if(!erpMessages.isEmpty()) {
                    message= erpMessages[0].Customer_Credit_Message__c;
                }
                if(String.isNotBlank(message)) {
                    creditMessageData = (FSL_CL_CustomerCreditResponseParser)JSON.deserialize(message.unescapeHtml4(), FSL_CL_CustomerCreditResponseParser.Class);
                    System.debug('::: creditMessageData = '+creditMessageData);
                    for( FSL_CL_CustomerCreditResponseParser.CreditMessageDetails fslCCR : creditMessageData.DataArea.CreditMessageDetails){
                        if(fslCCR.CreditMessageCode!=null && fslCCR.CreditMessageCode!=''){
                            messageWrapper msgWrap = new messageWrapper();
                            msgWrap.CreditMessage = fslCCR.CreditMessage;
                            msgWrap.CreditMessageCode = fslCCR.CreditMessageCode;
                            messageList.add(msgWrap);   
                        }
                    }
                }
            }
        } catch(Exception ex) {
            System.debug('Error in Customer credit Message Servive Call : ' + ex.getMessage());
        }
        System.debug('::: messageList returns = '+messageList);
        return messageList; 
    }
    
    // Method added for refresh button 
    @AuraEnabled
    public static List<messageWrapper> updateCreditMessageData(String serviceJob) {
        DateTime startTime = System.Now();
        List<messageWrapper> messageList = new List<messageWrapper>();
        FSL_CL_CustomerCreditResponseParser creditMessageData;
        System.debug('::: serviceJob = '+serviceJob);
        List<ERP_Message__c > erpMessages = [Select Id, Service_Order__c, Payer_Change__c, Customer_Credit_Message__c  From ERP_Message__c where Service_Order__c =: serviceJob AND Credit_Message_Received__c=true];
        System.debug('::: erpMessages = '+erpMessages);
        try {
            String message;
            if(!erpMessages.isEmpty()) {
                messageList = getCreditMessageWebService(serviceJob);
            } 
            else {
                System.debug('::: erpMessages else - '+erpMessages);
                if(!erpMessages.isEmpty()) {
                    message= erpMessages[0].Customer_Credit_Message__c;
                }
                if(String.isNotBlank(message)) {
                    creditMessageData = (FSL_CL_CustomerCreditResponseParser)JSON.deserialize(message.unescapeHtml4(), FSL_CL_CustomerCreditResponseParser.Class);
                    System.debug('::: creditMessageData = '+creditMessageData);
                    for(FSL_CL_CustomerCreditResponseParser.CreditMessageDetails fslCCR : creditMessageData.DataArea.CreditMessageDetails) 
                    {
                        if(fslCCR.CreditMessageCode!=null && fslCCR.CreditMessageCode!='') {
                            messageWrapper msgWrap = new messageWrapper();
                            msgWrap.CreditMessage = fslCCR.CreditMessage;
                            msgWrap.CreditMessageCode = fslCCR.CreditMessageCode;
                            messageList.add(msgWrap);   
                        }
                    }
                }
            }   
            // FSL_ApplicationLogger.createLogFuture(executionLog, isEligibleForAppLogging ,startTime , System.Now(),serviceJob);
        } 
        catch(Exception ex) {
            // FSL_ApplicationLogger.createLogFuture(executionLog, isEligibleForAppLogging ,startTime , System.Now(),serviceJob);
            System.debug('Error in Customer credit Message Servive Call : ' + ex.getMessage());
        }
        System.debug('::: messageList returns = '+messageList);
        return messageList; 
    }
    
    public class messageWrapper {
        @AuraEnabled public String CreditMessage{get;set;}
        @AuraEnabled public String CreditMessageCode{get;set;}
    }
}