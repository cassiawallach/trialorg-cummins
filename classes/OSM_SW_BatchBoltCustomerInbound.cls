/***********************************************************
Name: OSM_SW_BatchBoltCustomerInbound
Test Class Name:  OSM_BOLT_WS_CustomMasterInbound_Test
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
Batch for bolt customer inbound                                  
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad            08/03/2021     INITIAL DEVELOPMENT          


*************************************************************/



global class OSM_SW_BatchBoltCustomerInbound implements Database.Batchable<sObject>,Database.Stateful {
    global List<Id> accountIds = new List<Id>();
    global OSM_BOLT_WS_CustomMasterReq reqJSON = null;
    global Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_ACCTS_O_STG_ROW> mapBolt = new Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_ACCTS_O_STG_ROW>();
    global Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_O_STG_ROW> mapBoltCUST = new Map<String,OSM_BOLT_WS_CustomMasterReq.CUST_O_STG_ROW>();
    global String jSONRequestBody;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([Select id, CMI_Account_Status__c, Bolt_Party_Number__c, Bolt_Party_Name__c, Bolt_Site_Number__c, Bolt_Account_Number__c, Bolt_Customer_Account_Status__c, Bolt_Customer_Type__c, Bolt_Credit_Hold__c from account where Id IN :accountIds]);
        
    }
    public void execute(Database.BatchableContext BC, List<Account> scope) {
        
                    OSM_BOLT_WS_CustomMasterInbound.OSM_BOLT_WS_LogAndResponseWrapper methodReturn = OSM_BOLT_WS_CustomMasterInbound.doUpdateInsertFromInputJson(reqJSON,mapBolt,mapBoltCUST,scope);

                    boolean exceptionflag = methodReturn.exceptionflag;
                    system.debug('exceptionflag'+exceptionflag);
                    
                    
                    
                    if(((Boolean.valueOf(Label.OSM_Failure_Log) == true) && (exceptionflag == true)) || Test.isRunningTest()){
                        system.debug('Inside');
                        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
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
                        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                        OSM_SW_LoggingContext.integrationLog = log; //Populating integration log record
                        log = methodReturn.logW;
                        log.Request__c = jSONRequestBody;
                        log.Service_Name__c = label.Bolt_Customer_Master_Inbound;
                        log.Source__c = label.Bolt_Source;
                        log.Target__c = label.DA_Source;
                        log.Logged_In_User__c = userinfo.getUserId();
                        OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record                                    
                    }
    }
    global void finish(Database.BatchableContext BC){  
        
    }
}