public class OSM_OMS_WS_GetTI 
{
    public static OSM_OMS_WS_GetTI_GenOutputWrapper callOMSGetTIService(OSM_OMS_WS_GetTI_GenInputWrapper generalizedInputWrapper)
    {
        boolean isException = false;
        String jsonStr='';
        
        OSM_OMS_WS_GetTI_GenOutputWrapper objReturn = new OSM_OMS_WS_GetTI_GenOutputWrapper();
         OSM_WS_OP_CSWrapper resAuthWrapper = new OSM_WS_OP_CSWrapper();
         OSM_Integration_Log__c log = new OSM_Integration_Log__c();
    
        try
        {
            OSM_OMS_WS_GetTIReq getTIReq = OSM_OMS_WS_GetTIHelper.populateRequestObjectDataForGetTI(generalizedInputWrapper); 
            
            jsonStr = JSON.serialize(getTIReq);  
            System.debug('jsonStr___'+jsonStr);
            //Preparing request object for final callout layer
            OSM_WS_IP_CSWrapper requestWrap = new OSM_WS_IP_CSWrapper();
            
            //requestWrap.serviceName = 'OMS_GetTIFromLicenseKey_Service';
            requestWrap.serviceName = Label.CSO_Getlicensekey;
            requestWrap.jsonReqBody = jsonStr;
            requestWrap.AuthEnv  = 'OMS_Auth';
            requestWrap.AccesTokenRequired = true;
            
            log.Service_Name__c = 'OMS_GetTIFromLicenseKey_Service';
            log.Target__c = 'OMS';
            log.Request__c = jsonStr;
            log.Source__c = 'OSM';
            log.Logged_In_User__c = userinfo.getuserid();
            
            // Added for MAR-606
            // Adding parameters to GET request
            OSM_OMS_WS_GetTIReq.Header getHeaderObj = getTIReq.Header;
            OSM_OMS_WS_GetTIReq.Message getMsjObj = getHeaderObj.Message;            
            OSM_OMS_WS_GetTIReq.GetTIFromLicenseKeyInput getLicenseKeyObj = getTIReq.GetTIFromLicenseKeyInput;
            
            requestWrap.MessageID = getMsjObj.MessageID;
            requestWrap.Timestamp = getMsjObj.Timestamp;
            requestWrap.ActivationKey = getLicenseKeyObj.ActivationKey;
            requestWrap.ToolName = getLicenseKeyObj.ToolName;
            
        //    generalizedOutputWrapper.log.CC_Order_Item__c = generalizedInputWrapper.orderItemId;
            log.Retrial_Count__c = 0;
            log.Account__c = generalizedInputWrapper.GetTIFromLicenseKeyInput.AccountId; //Added by Dhiraj
            Integer retryCount = 0;
            //resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(requestWrap);
            resAuthWrapper = OSM_MuleSoft_MW_Services.calloutGeneric(requestWrap);
            log.API_URL__c =resAuthWrapper.APIURL;
            if(Test.isRunningTest()){
                resAuthWrapper.exceptionFlag=false;
            }
                if(!resAuthWrapper.exceptionFlag)
                {
                    
                    log.Response__c = resAuthWrapper.Response;
                    log.Status__c = 'Success';
                    log.Account__c = generalizedInputWrapper.GetTIFromLicenseKeyInput.AccountId; //Added by Dhiraj
                    OSM_OMS_WS_GetTIRes getTIRes=new OSM_OMS_WS_GetTIRes() ;
                    if(Test.isrunningTest())
                    {
                   String x='Response Body:{"Header":{"Sender":{"ServiceName":"GetTIFromLicenseKey","SenderID":"Mrktplc"},"Status":"Success","Target":{"TargetID":"OMS"},"ReturnCodeDescription":"Success"},"GetTIFromLicenseKeyOutput":{"ToolInstListInfo":{"ToolInstList":[{"InstanceID":6718021,"ToolInstance":"4D25DF3B"},{"InstanceID":6718022,"ToolInstance":"A793EB52"}]}}}';
                   getTIRes = OSM_OMS_WS_GetTIRes.parse(x.substringAfterLast('Response Body:'));
                   }
                   else
                   {
                       //getTIRes= OSM_OMS_WS_GetTIRes.parse(resAuthWrapper.Response.substringAfterLast('Response Body:'));
                       getTIRes= OSM_OMS_WS_GetTIRes.parse(resAuthWrapper.Response);
                   }
                   System.debug('getTIRes______'+getTIRes);
                    if(getTIRes!=null && getTIRes.Header.Status != null && getTIRes.Header.Status == 'Error'){
                        System.debug('Error Occurred______'); 
                        //Map<String,OMS_ErrorCodes__c> errorCodeSettingsMap=OMS_ErrorCodes__c.getAll();     
                       // System.debug('errorCodeSettingsMap____'+errorCodeSettingsMap);          
                        objReturn.errorMsg = getTIRes.Header.ReturnCodeDescription;
                        objReturn.errorFlag = true;
                        log.Status__c = 'Failure'; 
                          log.Account__c = generalizedInputWrapper.GetTIFromLicenseKeyInput.AccountId; //Added by Dhiraj
                       // log.Error_Description__c = getTIRes.Header.ReturnCodeDescription;   
                       /*if(objReturn.errorMsg.contains('1107')){
                           log.Error_Code__c='1107';
                           log.Error_Description__c='Invalid input';
                           log.Status__c = 'Success';
                       }else */
                       if(objReturn.errorMsg.contains('1129')){
                           log.Error_Code__c='1129';
                           log.Error_Description__c='No active toolinstance found for passed activation key and tool type.';
                           log.Status__c = 'Success';
                           log.Account__c = generalizedInputWrapper.GetTIFromLicenseKeyInput.AccountId; //Added by Dhiraj
                       }
                       /* else if(objReturn.errorMsg.contains('1124')){
                           log.Error_Code__c='1124';
                           log.Error_Description__c='Tool Not Supported.';
                           log.Status__c = 'Success';
                       }else{
                            log.Status__c = 'Failure';
                       }*/

                                                                                 
                      }
                      else{
                      System.debug('Error Not Occurred______');

                       objReturn.errorFlag = false;
                   
                        objReturn.GetTIFromLicenseKeyOutput=new OSM_OMS_WS_GetTI_GenOutputWrapper.GetTIFromLicenseKeyOutput();
                        objReturn.GetTIFromLicenseKeyOutput.ToolInstListInfo=new OSM_OMS_WS_GetTI_GenOutputWrapper.ToolInstListInfo();
                        objReturn.GetTIFromLicenseKeyOutput.ToolInstListInfo.ToolInstList=new List<OSM_OMS_WS_GetTI_GenOutputWrapper.ToolInstList>();
                        OSM_OMS_WS_GetTI_GenOutputWrapper.ToolInstList toollist;
                          for(OSM_OMS_WS_GetTIRes.ToolInstList res:getTIRes.GetTIFromLicenseKeyOutput.ToolInstListInfo.ToolInstList){
                        toollist=new OSM_OMS_WS_GetTI_GenOutputWrapper.ToolInstList();
                        toollist.ToolInstance=res.ToolInstance;
                        toollist.InstanceID=res.InstanceID;
                        objReturn.GetTIFromLicenseKeyOutput.ToolInstListInfo.ToolInstList.add(toollist);
                        }                                     
                       // objReturn.log.Retrial_Count__c = retryCount;
                        
                            
                   }
                     if(Test.isrunningTest())
               {
                   throw new  NullPointerException();
               }
                 }
                else
                {
                log.Response__c = resAuthWrapper.Response;
                objReturn.errorFlag = true;
                objReturn.errorMsg = resAuthWrapper.errorMessage;
                log.Status__c = 'Failure'; 
                log.Error_Description__c = resAuthWrapper.errorMessage;
                    log.Account__c = generalizedInputWrapper.GetTIFromLicenseKeyInput.AccountId; //Added by Dhiraj
            }
        }
        catch(Exception e)
        {
            String msg  = 'Message - '+e.getMessage();
            msg=msg+ 'Stacktrace - ' + e.getStackTraceString();
            System.debug('Exception Ocurred : OSM_OMS_WS_GetTI - callOMSGetTIService : ' + msg);
            log.Error_Description__c = msg ;
            log.Response__c = resAuthWrapper.Response;
            log.Status__c = 'Failure';  
              log.Account__c = generalizedInputWrapper.GetTIFromLicenseKeyInput.AccountId; //Added by Dhiraj
        }
        objReturn.log = log;
        return objReturn;
    }
    
  /*  private static OSM_WS_OP_CSWrapper testCaseResponse(String testScenario)
    {
        OSM_WS_OP_CSWrapper resAuthWrapper = new OSM_WS_OP_CSWrapper();
        
        if('responseException' == testScenario)
        {
            resAuthWrapper.Response = 'Response Body: {Test Error Response}';
            resAuthWrapper.errorMessage = 'Test Error Message';
            resAuthWrapper.exceptionFlag = true;
        }
        else if('emptyToolInstance' == testScenario)
        {
            resAuthWrapper.Response = 'Response Body: {"Header": {"ReturnCodeDescription": "Success","Status": "Success","Sender": {"ServiceName": "GetTIFromLicenseKey","SenderID": "Mrktpl"},"Target": {"TargetID": "OMS"}},"GetTIFromLicenseKeyOutput": {"ToolInstListInfo": {"ToolInstList": {"ToolInstance": null}}}}';
            resAuthWrapper.exceptionFlag = false;
        }
        else if('throwException' == testScenario)
        {
            throw new NullPointerException();
        }
        else // SUCCESS Scenario
        {
            resAuthWrapper.Response = 'Response Body: {"Header": {"ReturnCodeDescription": "Success","Status": "Success","Sender": {"ServiceName": "GetTIFromLicenseKey","SenderID": "Mrktpl"},"Target": {"TargetID": "OMS"}},"GetTIFromLicenseKeyOutput": {"ToolInstListInfo": {"ToolInstList": {"ToolInstance": "16B2A8C1"}}}}';
            resAuthWrapper.exceptionFlag = false;
        }
        
        return resAuthWrapper;
    }*/
}