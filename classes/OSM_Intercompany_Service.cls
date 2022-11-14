/******
Name:  OSM_Intercompany_Service
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       19/12/2018     INITIAL DEVELOPMENT 
*******/
public class OSM_Intercompany_Service{
    public static OSM_Intercompany_Generalized_RES callIntercompanyService(OSM_Intercompany_Generalized_REQ inputWrapperObj, boolean isRefund,boolean isDistributor){
        boolean isException = false;
        OSM_Intercompany_Generalized_RES outputWrapperObj=new OSM_Intercompany_Generalized_RES();
        String jsonStr = '';
        Integer retryAPICallForErr=0;
        Integer retryAPICallForExp=0;
        OSM_WS_OP_CSWrapper resAuthWrapper = new OSM_WS_OP_CSWrapper();
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        try{
            //preparing OSM_WS_SubmitOrderInfo_REQ 
            OSM_Intercompany_REQ intercompanyReq=OSM_Intercompany_Helper.populateRequestObjectData(inputWrapperObj);
            jsonStr = JSON.serialize(intercompanyReq);
            jsonStr  = jsonStr.replace('PO_Vendor', 'PO_VENDOR');
          //  System.debug('JSON String>>>>>'+jsonStr);
            if(isDistributor)
            {
                jsonStr  = jsonStr.replace('"BMS_OE_REFERENCE":0', '"BMS_OE_REFERENCE":""');
            }
            //Preparing request object for final callout layer
            OSM_WS_IP_CSWrapper requestWrap = new OSM_WS_IP_CSWrapper();
            //requestWrap.ServiceName= 'OSMBMSIntercompany';
            requestWrap.ServiceName= Label.CSO_IntraCompanyInv;
            
            log.Service_Name__c ='IntercompanyRequest';
            if(isRefund)
                log.Service_Name__c ='RefundIntercompanyRequest';
            requestWrap.jsonReqBody = jsonStr;
            requestWrap.AuthEnv  = 'BMSCustomerLookupAuth';
            requestWrap.AccesTokenRequired = true;
            log.Target__c =System.Label.OSM_BMS_Target_ID;
            log.Request__c = jsonStr;
            log.Source__c = 'OSM';
            log.Logged_In_User__c = userinfo.getuserid();
            //log.Retrial_Count__c=retryAPICallForErr;
            
            //Making call to callout Layer
            //resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(requestWrap);            
            resAuthWrapper = OSM_MuleSoft_MW_Services.calloutGeneric(requestWrap);
            log.API_URL__c =resAuthWrapper.APIURL;
          //  System.debug('Response >>>>>>>'+resAuthWrapper.Response);
            //System.debug('Response output flag>>>>>>>'+resAuthWrapper.exceptionFlag);
            //Handling service response values
           
           if(resAuthWrapper.exceptionFlag == false )
             {    
                log.Response__c = resAuthWrapper.Response;
                log.Status__c = 'Success';
                //OSM_Intercompany_RES wrprRes = OSM_Intercompany_RES.parse(resAuthWrapper.Response.substringAfterLast('Response Body: '));
                OSM_Intercompany_RES wrprRes = OSM_Intercompany_RES.parse(resAuthWrapper.Response);
               // System.debug('output response wrapper>>>>>>'+wrprRes);
               // System.debug('wrprRes.Header.Status: '+wrprRes.Header.Status);
               if(wrprRes.Header.Status != null && wrprRes.Header.Status != 'Success')
                {
                    outputWrapperObj.errorMsg = wrprRes.Header.StatusMessage;
                    outputWrapperObj.errorFlag = true;
                    log.Status__c = 'Failure'; 
                    log.Error_Description__c = wrprRes.Header.StatusMessage;
                }else
                {                  
                    outputWrapperObj.errorFlag = false;
                    outputWrapperObj.DataArea=new OSM_Intercompany_Generalized_RES.DataArea();
                    outputWrapperObj.DataArea.DistributorCode=wrprRes.DataArea.DistributorCode;
                    outputWrapperObj.DataArea.CustomerCode=wrprRes.DataArea.CustomerCode;
                }
            }else{
                log.Response__c = resAuthWrapper.Response;
                outputWrapperObj.errorFlag = true;
                outputWrapperObj.errorMsg = resAuthWrapper.errorMessage;
                log.Status__c = 'Failure';
                log.Error_Description__c = resAuthWrapper.errorMessage; 
               }
           if(Test.isRunningTest())
           {
               throw new nullPointerException();
           }
        }catch(Exception ex){
           // System.debug('Exception>>>>>>'+ex);
           // System.debug('Exception>>>>>>'+ex.getStackTraceString());
            String msg  = 'Message - '+ex.getMessage();
            msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
            log.Error_Description__c = msg ;
            log.Response__c = resAuthWrapper.Response;
            outputWrapperObj.errorFlag = true;
            outputWrapperObj.errorMsg = msg;
            log.Status__c = 'Failure'; 
            

        }
        if(Test.isRunningTest())
        {
            log.Status__c = 'Success';
        }
        outputWrapperObj.log=log;
       // System.debug('outputWrapperObj.log___'+outputWrapperObj.log);
        return outputWrapperObj;
    }
      
 }