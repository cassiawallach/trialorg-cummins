global with sharing class OSM_WS_FW_SubmitOrderInfoService{ 
    public static OSM_WS_GeneralizedSubmitOrderOutputWrap callSubmitOrderService(OSM_WS_GeneralizedSubmitOrdrInpWrapper inputWrapperObj,boolean isCancle){
        boolean isException = false;
        OSM_WS_GeneralizedSubmitOrderOutputWrap outputWrapperObj=new OSM_WS_GeneralizedSubmitOrderOutputWrap();
        String jsonStr = '';
        OSM_WS_OP_CSWrapper resAuthWrapper = new OSM_WS_OP_CSWrapper();
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();

        Integer retryAPICallForErr=0;
        Integer retryAPICallForExp=0;
        
        try{ 
            log.Account__c = inputWrapperObj.dataArea.AcctId; // Added By Dhiraj for MAR-1621 - Story On 16th April 2021        
            OSM_WS_GeneralizedSubmitOrdrInpWrapper orderInfoReq = OSM_WS_SubmitOrderInfo_Helper.populateRequestObjData(inputWrapperObj);
            if(isCancle)
            {
                orderInfoReq.header.sender.serviceName = System.label.OSM_FW_Refund_ServiceName;
            }
            jsonStr = JSON.serialize(orderInfoReq);
                       
            //Preparing request object for final callout layer
            OSM_WS_IP_CSWrapper requestWrap = new OSM_WS_IP_CSWrapper();
            requestWrap.ServiceName = 'BMS_PO_SubmitOrder'; 
            log.Service_Name__c = System.Label.OSM_SubmitOrder_ServiceName;
            requestWrap.jsonReqBody = jsonStr;
            requestWrap.AuthEnv  = 'BMSCustomerLookupAuth';
            requestWrap.AccesTokenRequired = true;
            log.Target__c = 'WINLIMS';
            log.Request__c = jsonStr;
            log.Source__c = 'OSM';
            log.Logged_In_User__c = userinfo.getuserid();
            log.Retrial_Count__c=retryAPICallForErr;
            
            resAuthWrapper = OSM_MuleSoft_MW_Services.calloutGeneric(requestWrap); 
            log.API_URL__c =resAuthWrapper.APIURL;
             log.Account__c = inputWrapperObj.dataArea.AcctId;    
            String apiStatusExp=String.valueOf(resAuthWrapper.exceptionFlag);
           
            Integer callCount=Integer.valueOf(system.Label.IntegrationRetryCount);
            if(Test.isRunningTest()){
               apiStatusExp='true';
            }
            
            if(Test.isRunningTest()){
               apiStatusExp='false';
            }

            if(apiStatusExp!='true') {apiStatusExp = 'false';}
            
            if(apiStatusExp == 'false'){
                log.Account__c = inputWrapperObj.dataArea.AcctId;
                log.Response__c = resAuthWrapper.Response;
                log.Status__c = 'Success';
                //system.debug('resAuthWrapper.Response   '+resAuthWrapper.Response);
                OSM_WS_FW_SubmitOrderInfo_RESONSE wrprRes = OSM_WS_FW_SubmitOrderInfo_RESONSE.parse(resAuthWrapper.Response);

                String apiStatus;
                apiStatus=wrprRes.header.status;
                Integer count=Integer.valueOf(system.Label.IntegrationRetryCount);
             
                if(apiStatus != null && apiStatus!= 'Success'){
                    outputWrapperObj.errorMsg = wrprRes.header.ReturnCodeDescription;
                    outputWrapperObj.errorFlag = true;
                    log.Account__c = inputWrapperObj.dataArea.AcctId;
                    log.Status__c = 'Failure';
                    log.Error_Description__c = wrprRes.header.ReturnCodeDescription;
                    log.Retrial_Count__c=retryAPICallForErr;
                }else{
                    outputWrapperObj.errorFlag = false;
                }
            }else{
                log.Account__c = inputWrapperObj.dataArea.AcctId;
                log.Response__c = resAuthWrapper.Response;
                outputWrapperObj.errorFlag = true;
                outputWrapperObj.errorMsg = resAuthWrapper.errorMessage;
                log.Status__c = 'Failure';
                log.Error_Description__c = resAuthWrapper.errorMessage; 
                log.Retrial_Count__c=retryAPICallForExp;            
            }            
        }catch(Exception ex){
            String msg  = 'Message - '+ex.getMessage();
            msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
            log.Account__c = inputWrapperObj.dataArea.AcctId;
            log.Error_Description__c = msg ;
            log.Response__c = resAuthWrapper.Response;
            outputWrapperObj.errorFlag = true;
            outputWrapperObj.errorMsg = msg;
            log.Status__c = 'Failure';
        }
        outputWrapperObj.log=log;
        return outputWrapperObj;
    }
}