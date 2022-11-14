/************************************************************************************************************************************************************
Name: FSL_ApplicationLogger 
Description: This class is used to Capture the Apex Execution Flow.
Author: Rajashekar Nallapati
--------------- ------------------ ------------------------------
Date - 11/05/2019 
*************************************************************************************************************************************************************/
public class FSL_ApplicationLogger{
    /**
    * Name : logStart
    * Description: : This method is used to create the Request Start execution message . 
    * Parameter : String requestName  , executionLog , isApplicationFlagEnable
    * @return: executionLog Message 
    */  
    public static String  logStart(String requestName , String executionLog, boolean isApplicationFlagEnable){                
        if(isApplicationFlagEnable){
            executionLog += FSL_Constants.NL_NL_REQUEST_NAME + requestName;
            executionLog += FSL_Constants.NL_START_TIME + FSL_Utility.SetNow(); 
        }             
        return executionLog;
    }
    
      
    /**
    * Name : logMessage
    * Description: : This method is used to create the execution message .
    * Parameter : String requestName  , executionLog , isApplicationFlagEnable
    * @return: executionLog Message 
    */  
    public static String  logMessage(String requestName , String executionLog, boolean isApplicationFlagEnable){                
        if(isApplicationFlagEnable){
            executionLog += FSL_Constants.LOG_MESSAGE + requestName;    
        }             
        return executionLog ;       
    }
    
    /**
    * Name : logErrorMessage
    * Description: : This method is used to create the execution error message .
    * Parameter : String requestName  , executionLog , isApplicationFlagEnable
    * @return: executionLog Message 
    */  
    public static String  logErrorMessage(String requestName , String executionLog, boolean isApplicationFlagEnable){                
        if(isApplicationFlagEnable){
            executionLog += FSL_Constants.NL_ERROR + requestName;    
        }             
        return executionLog ;       
    }
    
    /**
    * Name : logEnd
    * Description: : This method is used to create the Request End execution message . 
    * Parameter :  String responseData , executionLog , isApplicationFlagEnable
    * @return: executionLog Message 
    */  
    public static String  logEnd(String responseData, String executionLog, boolean isApplicationFlagEnable){             
        if(isApplicationFlagEnable){
            executionLog += FSL_Constants.NL_END_TIME + FSL_Utility.SetNow();
            executionLog += FSL_Constants.NL_RESPONSE + responseData;    
        }          
        return executionLog ;       
    }
    
    
    /**
    * Name : createLog
    * Description: : Here we are adding application log data for Request Start 
    * Parameter : String requestName  , executionLog , isApplicationFlagEnable
    * @return: String 
    */  
    public static void createLog(String finalLogMessage , boolean isApplicationFlagEnable 
                                 , DateTime startTime , DateTime endTime, String workOrderId){                
        if(isApplicationFlagEnable){
            FSL_Application_Log__c objApplicationLog = new FSL_Application_Log__c();
            objApplicationLog.Start_Time__c = startTime;
            objApplicationLog.End_Time__c = endTime;
            if(workOrderId!='' || workOrderId!=null ){
                objApplicationLog.Service_Order__c = workOrderId;
            }
            
            Integer len= FSL_Application_Log__c.Log_Message__c.getDescribe().getLength();
            if(finalLogMessage.length()>len){
                finalLogMessage =  finalLogMessage.Substring(0, len);
            }
            
            objApplicationLog.Log_Message__c = finalLogMessage;
            objApplicationLog.Elapsed_Time_In_ms__c = String.valueOf(endTime.getTime() - startTime.getTime());
            try{
                Database.insert(objApplicationLog);
            }catch(Exception objEx){
                System.debug('Error Message >>>>'+ objEx.getMessage());
            }
        }                     
    }
    @future (callout = true)
    public static void createLogFuture(String finalLogMessage , boolean isApplicationFlagEnable 
                                 , DateTime startTime , DateTime endTime, String workOrderId){                
        if(isApplicationFlagEnable){
            FSL_Application_Log__c objApplicationLog = new FSL_Application_Log__c();
            objApplicationLog.Start_Time__c = startTime;
            objApplicationLog.End_Time__c = endTime;
            if(workOrderId!='' || workOrderId!=null ){
                objApplicationLog.Service_Order__c = workOrderId;
            }
            
            Integer len= FSL_Application_Log__c.Log_Message__c.getDescribe().getLength();
            if(finalLogMessage.length()>len){
                finalLogMessage =  finalLogMessage.Substring(0, len);
            }
            
            objApplicationLog.Log_Message__c = finalLogMessage;
            objApplicationLog.Elapsed_Time_In_ms__c = String.valueOf(endTime.getTime() - startTime.getTime());
            try{
                Database.insert(objApplicationLog);
            }catch(Exception objEx){
                System.debug('Error Message >>>>'+ objEx.getMessage());
            }
        }                     
    }  
    
    public static void insertIntegrationErrorLog(RestRequest request, RestResponse response, String serviceName, String status,String serviceVersion, String toolId,String senderId){
        FSL_Integration_Error_Log__c objIntegrationErrorLog = new FSL_Integration_Error_Log__c();
        objIntegrationErrorLog.Request__c =  request.requestBody.toString().trim();
        objIntegrationErrorLog.Response__c = response.responseBody.toString();
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
            ex.getStackTraceString();
        }
        
    } 
    
   //Added by Ravikanth For HTTP Request and Http Response 
   public static void insertFSLIntegrationErrorLog(string request, string response, String serviceName, String status,String serviceVersion, String toolId,String senderId){
        FSL_Integration_Error_Log__c objIntegrationErrorLog = new FSL_Integration_Error_Log__c();
       objIntegrationErrorLog.Request__c = string.valueof(request);
        objIntegrationErrorLog.Response__c = string.valueof(response);
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
            ex.getStackTraceString();
        }
        //Ended by Ravikanth
    }    
}