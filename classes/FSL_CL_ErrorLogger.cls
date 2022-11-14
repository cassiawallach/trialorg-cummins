/**********************************************************************
Name: FSL_CL_ErrorLogger
Copyright Â© 2021  Cummins
======================================================
======================================================
Purpose:                                              
-------  
This class is to capture Application and Integration error logs
======================================================
======================================================
History                                               
-------                                                            
VERSION  AUTHOR                     DATE             Detail                      
1.0      Rajkumar BT                11/19/2021       Created individual methods to capture error logs 
													 for story# APST-1144
***********************************************************************/
public class FSL_CL_ErrorLogger {
    
    //Method to capture Application error logs
    public static void insertApplicationErrorLog(Id userId, string className, string stackTraceString, string errMsg, integer errLineNo, string methodName, string errRecId){
        FSL_Application_Log__c objApplicationErrorLog = new FSL_Application_Log__c();
        objApplicationErrorLog.UserName__c = userId;
        objApplicationErrorLog.Class_Name__c = className;
        objApplicationErrorLog.Error_Description__c = stackTraceString + ' - ' + errMsg + ' - ' + errLineNo;
        objApplicationErrorLog.Processed_Data__c = 'Method -'+ methodName +' , Record Id - '+ errRecId;
        objApplicationErrorLog.Error_Occurred_Date__c = DateTime.now();
        try{
            insert objApplicationErrorLog;
        }catch(Exception ex){
            system.debug('Exception in Application Error log'+ ex.getMessage() + ' ' + ex.getLineNumber());
        }
    }
    
    //Method to capture Integration error logs
    @future
    public static void insertIntegrationErrorLog(Id userId, string request, string response, string serviceName, string status, string serviceVersion, string toolId, string senderId){
        FSL_Integration_Error_Log__c objIntegrationErrorLog = new FSL_Integration_Error_Log__c();
        objIntegrationErrorLog.User_Name__c =  userId;
        objIntegrationErrorLog.Request__c =  request;
        objIntegrationErrorLog.Response__c = response;
        objIntegrationErrorLog.Service_Name__c = serviceName;
        objIntegrationErrorLog.Service_Version__c = serviceVersion;
        if(status=='Success'){
            objIntegrationErrorLog.Status__c = 'Success';
        }else{
            objIntegrationErrorLog.Status__c = 'Error';
        }
        objIntegrationErrorLog.ToolID__c = toolId;
        objIntegrationErrorLog.SenderID__c = senderId;
        try{
            insert objIntegrationErrorLog;
        }catch(Exception ex){
            system.debug('Exception in Integration Error log'+ ex.getMessage() + ' ' + ex.getLineNumber());
        }
    }
}