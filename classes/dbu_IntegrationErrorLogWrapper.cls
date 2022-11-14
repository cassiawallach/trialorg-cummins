public class dbu_IntegrationErrorLogWrapper {
  
    public static dbu_Integration_Error_Log__c dbu_IntegrationErrorLogWrapper(Integer ErrorCode,String ErrorDescription,String Request,
                                      String Response,String ServiceName,String Status){
                                          return new dbu_Integration_Error_Log__c(
                                          dbu_Error_Code__c             =   ErrorCode,
                                          dbu_Error_Description__c      =   ErrorDescription,
                                          dbu_Request__c                =   Request,
                                          dbu_Response__c               =   Response,
                                          dbu_Service_Name__c           =   ServiceName,
                                          dbu_Status__c                 =   Status 
                                          );
                                      	 
    } 
}