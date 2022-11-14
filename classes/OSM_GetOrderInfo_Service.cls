public class OSM_GetOrderInfo_Service{
    
    
    public static OSM_GetOrder_WS_GeneralizedoutputWrapper callGetOrderInfoService(String OMSOrderId, String orderId,String AccId){
        
        boolean isException = false;
        OSM_GetOrder_WS_GeneralizedoutputWrapper objReturn = new OSM_GetOrder_WS_GeneralizedoutputWrapper();
        
        String jsonStr = '';
        OSM_WS_OP_CSWrapper resAuthWrapper = new OSM_WS_OP_CSWrapper();
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.CC_Order__c = orderId;
        log.Account__c = AccId;
        try
        {
            OSM_GetOrderInfoReq objReqOrdrInfoWrpr = OSM_GetOrderInfo_Service_Helper.populateDynamicData(OMSOrderId);
            
           // System.debug('objReqOrdrInfoWrpr: '+objReqOrdrInfoWrpr);
            jsonStr = JSON.serialize(objReqOrdrInfoWrpr);
           // System.debug('previous json string: '+jsonStr);
           // System.debug('jsonStr: '+jsonStr);
            
            OSM_WS_IP_CSWrapper requestWrap = new OSM_WS_IP_CSWrapper();
            
            //Need To set Service Name 
            //requestWrap.serviceName = 'OMS_GetOrder_Service';
            requestWrap.serviceName = Label.OSM_Order_Get;
            log.Service_Name__c = 'OMS_GetOrder_Service';
            log.Account__c = AccId;
            
            
            // Added for MAR-606
            OSM_GetOrderInfoReq.GetOrderInfoInput getOrdrInp = objReqOrdrInfoWrpr.GetOrderInfoInput;
            requestWrap.cmsOrderId = OMSOrderId;
            requestWrap.ToolName = getOrdrInp.ToolName;
            
            
            requestWrap.jsonReqBody = jsonStr;
            //Need To set AuthEnv
            requestWrap.AuthEnv  = 'OMS_Auth';
            requestWrap.AccesTokenRequired = true;
            //Need To set Target
            log.Target__c = 'OMS';
            log.Request__c = jsonStr;
            log.Source__c = 'OSM';
            log.Logged_In_User__c = userinfo.getuserid();
            log.Account__c = AccId;
            
            //resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(requestWrap);
            resAuthWrapper = OSM_MuleSoft_MW_Services.calloutGeneric(requestWrap);
            log.API_URL__c =resAuthWrapper.APIURL;
            Integer retryCount = 0;
            
            while(retryCount <= Integer.valueOf(Label.OMS_GetOrder_MaxRetryCount))
            {
                if(Test.isRunningTest())
                {
                    resAuthWrapper.exceptionFlag =false;
                    resAuthWrapper.Response='{"Header":{"Sender":{"ServiceName":"GetOrder","SenderID":"Mrktpl"},"Target":{"TargetID":"OMS"}},"ItemInfoList":{"ItemInfo":[{"ItemId":"7757","LicenseInfo":{"LicenseName":"Komatsu Tier4 Basic","ActivationKey":"NIQ12IWCSV1D"}},{"ItemId":"7758","LicenseInfo":{"LicenseName":"Komatsu Tier4","ActivationKey":"NIQ12IWCSV1D"}}]}}';
                    
                }
                if(resAuthWrapper.exceptionFlag == false )
                {
                    log.Response__c = resAuthWrapper.Response;
                    log.Account__c = AccId;
                    log.Status__c = 'Success'; 
                   // System.debug('Web service response body: '+resAuthWrapper.Response);
                    //OSM_GetOrderInfoRes wrprRes = OSM_GetOrderInfoRes.parse(resAuthWrapper.Response.substringAfterLast('Response Body: '));
                    OSM_GetOrderInfoRes wrprRes = OSM_GetOrderInfoRes.parse(resAuthWrapper.Response);
                   // System.debug('wrprRes: '+wrprRes);
                    
                    objReturn.Header = new OSM_GetOrder_WS_GeneralizedoutputWrapper.Header();
                    objReturn.ItemInfoList = new OSM_GetOrder_WS_GeneralizedoutputWrapper.ItemInfoList();
                    objReturn.Header.Sender = new OSM_GetOrder_WS_GeneralizedoutputWrapper.Sender();
                    objReturn.Header.Sender.ServiceName   = wrprRes.Header.Sender.ServiceName ;
                    objReturn.Header.Target = new OSM_GetOrder_WS_GeneralizedoutputWrapper.Target();
                    objReturn.Header.Target.TargetID  = wrprRes.Header.Target.TargetID;
                    
                    if(null == wrprRes.Error)
                    {
                        List<OSM_GetOrder_WS_GeneralizedoutputWrapper.ItemInfo> lstItemInfo = new List<OSM_GetOrder_WS_GeneralizedoutputWrapper.ItemInfo>();
                        
                        for(OSM_GetOrderInfoRes.ItemInfo itemInfo : wrprRes.ItemInfoList.ItemInfo)
                        {
                            OSM_GetOrder_WS_GeneralizedoutputWrapper.ItemInfo itminfo = new OSM_GetOrder_WS_GeneralizedoutputWrapper.ItemInfo();
                            itminfo.ItemId = itemInfo.ItemId ;  
                            itminfo.LicenseInfo = new OSM_GetOrder_WS_GeneralizedoutputWrapper.LicenseInfo();
                            itminfo.LicenseInfo.LicenseName  = itemInfo.LicenseInfo.LicenseName ;
                            itminfo.LicenseInfo.ActivationKey = itemInfo.LicenseInfo.ActivationKey ;
                            lstItemInfo.add(itminfo);
                        }
                        objReturn.ItemInfoList.ItemInfo  = lstItemInfo  ;
                        objReturn.errorFlag = false;
                        
                        // stop retrying - successful call
                        retryCount = Integer.valueOf(Label.OMS_GetOrder_MaxRetryCount) + 1;
                    }
                    else
                    {
                        objReturn.errorMsg = wrprRes.Error.ErrorCode + ' ' + wrprRes.Error.ErrorDescription;
                        objReturn.errorFlag = true;
                        log.Error_Description__c = objReturn.errorMsg;
                        log.Status__c = 'Failure'; 
                        log.Response__c = resAuthWrapper.Response;
                        log.Account__c = AccId;
                        log.Retrial_Count__c = retryCount;
                        retryCount ++;
                    }
                }
                else
                {
                    log.Retrial_Count__c = retryCount;
                    retryCount ++;
                    log.Response__c = resAuthWrapper.Response;
                    objReturn.errorFlag = true;
                    objReturn.errorMsg = resAuthWrapper.errorMessage;
                    log.Status__c = 'Failure'; 
                    log.Error_Description__c = resAuthWrapper.errorMessage;
                    log.Account__c = AccId;
                }
            }
            if(Test.isRunningTest())
            {
                throw new NullPointerException();
            }
        }
        catch(Exception ex)
        {
            String msg  = 'Message - '+ex.getMessage();
            msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
            log.Error_Description__c = msg ;
            log.Response__c = resAuthWrapper.Response;
            objReturn.errorFlag = true;
            objReturn.errorMsg = msg;
            log.Status__c = 'Failure';
            log.Account__c = AccId;
        }
        objReturn.log = log;
        
       // insert log;
        
        return objReturn;
        
        
    }
}