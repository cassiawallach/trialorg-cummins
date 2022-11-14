/************************************************************************************************************************************************************
Name: FSL_ApplicationLoggerQueueable 
Description: This class is used to Capture the Request and Response log.
Author: Ravikanth Macherla
--------------- ------------------ ------------------------------
Date - 02/13/2020 
************************************************************************************************************************************************************/
public class FSL_ApplicationLoggerQueueable implements Queueable {
    
    RestRequest request;
    RestResponse response;
    HttpRequest req;
    HttpResponse res;
    String serviceName;
    String status;
    String serviceVersion;
    String toolId;
    String senderId;
    String ReqstBody;
    String RespBody;
    String Sourcesystem;
    String loginuserWWID;
    ID LoginUserName;
    String Timestamp;
    ID Workorderid;
    
    public FSL_ApplicationLoggerQueueable(String ReqBody, String ResBody, RestRequest request, RestResponse response, String serviceName, 
                                          String status, String serviceVersion, String toolId, String senderId, Id workorderid, String Sourcesystem) {
                                              
                                              this.ReqstBody=ReqBody;
                                              this.RespBody=ResBody;
                                              this.request = request;
                                              this.response  = response;
                                              this.serviceName = serviceName;
                                              this.status=status;
                                              this.serviceVersion = serviceVersion ;
                                              this.toolId=toolId;
                                              this.senderId=senderId;
                                              this.Workorderid = workorderid;
                                              this.loginuserWWID = FSL_Utility.UserInfo().FederationIdentifier;
                                              this.LoginUserName = FSL_Utility.UserInfo().Id;
                                              this.Timestamp = FSL_Utility.SetNow(); 
                                              this.Sourcesystem = Sourcesystem;
                                          }
    
    public void execute(QueueableContext context) {
        
        FSL_Integration_Error_Log__c objIntegrationErrorLog = new FSL_Integration_Error_Log__c();
        
        if(!String.isBlank(ReqstBody)){
            objIntegrationErrorLog.Request__c = ReqstBody.trim();
            objIntegrationErrorLog.Response__c = RespBody;
        }
        else{
            objIntegrationErrorLog.Request__c = ReqstBody;
            objIntegrationErrorLog.Response__c = RespBody;
        }
        if(request !=null){
            objIntegrationErrorLog.Request__c = request.requestBody.toString().trim();
        }
        if(response!=null){
            objIntegrationErrorLog.Response__c = response.responseBody.toString();
        }
        objIntegrationErrorLog.Service_Name__c = serviceName;
        objIntegrationErrorLog.Service_Version__c = serviceVersion;
        if(status == 'OK' || status == 'Success' ) {
            objIntegrationErrorLog.Status__c = 'Success';
        }
        else{
            objIntegrationErrorLog.Status__c = 'Error';
        }
        objIntegrationErrorLog.ToolID__c = toolId;
        objIntegrationErrorLog.SenderID__c = senderId;
        objIntegrationErrorLog.Work_Order__c = Workorderid;
        objIntegrationErrorLog.Source__c = Sourcesystem;
        objIntegrationErrorLog.login_user_WWID__c = loginuserWWID;
        objIntegrationErrorLog.Log_Captured_Time__c = Timestamp;
        objIntegrationErrorLog.User_Name__c = LoginUserName;
        
        try {
            insert objIntegrationErrorLog;
            system.debug('check id'+objIntegrationErrorLog);
        } catch(Exception ex) {
            ex.getStackTraceString(); 
        }                
    }    
}