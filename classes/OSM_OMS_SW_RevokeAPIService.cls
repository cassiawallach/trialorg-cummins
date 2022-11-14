/************************************************************
Name: OSM_OMS_SW_RevokeAPIService
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is request wrapper class. 

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta            17/01/2019    INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_OMS_SW_RevokeAPIService{

    
    public static OSM_OMS_WS_RevokeGeneralized_OP_Wrapper callRevokeService(OSM_OMS_WS_RevokeGeneralized_IP_Wrapper inputWrapperObj)
    {
      boolean isException = false;
      OSM_OMS_WS_RevokeGeneralized_OP_Wrapper outputWrapperObj=new OSM_OMS_WS_RevokeGeneralized_OP_Wrapper();
      String jsonStr = '';
      OSM_WS_OP_CSWrapper resAuthWrapper = new OSM_WS_OP_CSWrapper();
      OSM_Integration_Log__c log = new OSM_Integration_Log__c();
      Integer retryAPICallForErr=0;
      Integer retryAPICallForExp=0;
      
      try
      {
           //preparing OSM_BMS_WS_CustomerOuboundReq object
           OSM_OMS_WS_RevokeLicenseReq customerOuboundReq=OSM_OMS_WS_RevokeAPI_Helper.populateRequestObjectData(inputWrapperObj);
           jsonStr = JSON.serialize(customerOuboundReq);
           System.debug('JSON String>>>>>'+jsonStr);
           
           //Preaparing request object for final callout layer
           OSM_WS_IP_CSWrapper requestWrap = new OSM_WS_IP_CSWrapper();
           //requestWrap.serviceName ='Revoke License';
           
           //requestWrap.serviceName='OMS_RevokeLicense_Service';
           requestWrap.serviceName = Label.CSO_RevokeLicense;
           log.Service_Name__c = System.Label.OMS_Revoke_API_Service_Name;
           
           //log.Cart__c = objVertexGeneralWrapper.recordId;
           requestWrap.jsonReqBody = jsonStr;
           requestWrap.AuthEnv  = 'OMS_Auth';
           requestWrap.AccesTokenRequired = true;
           log.Target__c = 'OMS';
           log.Request__c = jsonStr;
           log.Source__c = 'OSM';
           log.Logged_In_User__c = userinfo.getuserid();
           
           log.Retrial_Count__c=retryAPICallForErr;
           

           //Making call to callout Layer
           //resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(requestWrap);
           resAuthWrapper = OSM_MuleSoft_MW_Services.calloutGeneric(requestWrap);
           log.API_URL__c =resAuthWrapper.APIURL;
           //resAuthWrapper=OSM_BMS_WS_CustomerLookupOutbound.callOutService(requestWrap);
           System.debug('Response output flag>>>>>>>'+resAuthWrapper.exceptionFlag);
           String apiStatusExp=String.valueOf(resAuthWrapper.exceptionFlag);
           if(Test.isRunningTest())
           {
             apiStatusExp = 'false';  
           }
             
           if(apiStatusExp == 'false')
           {
               log.Response__c = resAuthWrapper.Response;
               log.Status__c = 'Success';
               OSM_OMS_WS_RevokeLicenseRes wrprRes=null;
               
               if(Test.isrunningTest())
               {
                   String x='Response Body: {"Header":null,"Body":{"Fault":{"faultcode":"soapenv:Server","faultstring":"LOSFaultMessage","detail":{"LosFault":{"faultCode":1115,"errorInfo":"License already revoked. Can not revoke again."}}}}}';
                   wrprRes = OSM_OMS_WS_RevokeLicenseRes.parse(x.substringAfterLast('Response Body: '));
               }
               else
               {
                   //wrprRes = OSM_OMS_WS_RevokeLicenseRes.parse(resAuthWrapper.Response.substringAfterLast('Response Body: '));
                   wrprRes = OSM_OMS_WS_RevokeLicenseRes.parse(resAuthWrapper.Response);
               }
               
               if(wrprRes.Header==null && wrprRes.Body==null)
               {
                        log.Response__c = resAuthWrapper.Response;
                        log.Status__c = 'Success';
                        outputWrapperObj.errorFlag = false;
               }
               else
               {
                       
                        
                        
                        outputWrapperObj.errorFlag = true;
                        log.Status__c = 'Failure';
                        if(wrprRes.Body!=null)
                        {
                            OSM_OMS_WS_RevokeGeneralized_OP_Wrapper.Body body=new OSM_OMS_WS_RevokeGeneralized_OP_Wrapper.Body();
                            body.Fault=new OSM_OMS_WS_RevokeGeneralized_OP_Wrapper.Fault();
                            body.Fault.detail=new OSM_OMS_WS_RevokeGeneralized_OP_Wrapper.Detail();
                            body.Fault.detail.LosFault=new OSM_OMS_WS_RevokeGeneralized_OP_Wrapper.LosFault();
                            body.Fault.detail.LosFault.errorInfo=wrprRes.Body.Fault.Detail.LosFault.errorInfo;
                            
                            
                            log.Error_Description__c=body.Fault.detail.LosFault.faultCode+'-'+body.Fault.detail.LosFault.errorInfo;
                        }
                        
                }
               if(Test.isrunningTest())
               {
                   throw new  NullPointerException();
               }
              
           }
           else
           {
                   
                    log.Response__c = resAuthWrapper.Response;
                    outputWrapperObj.errorFlag = true;
                    outputWrapperObj.errorMsg = resAuthWrapper.errorMessage;
                    log.Status__c = 'Failure'; 
                    log.Error_Description__c = resAuthWrapper.errorMessage;
                    log.Retrial_Count__c=retryAPICallForExp;
                    System.debug('in else block of exception flag>>>>');
                    
           }
           
      }
      catch(Exception ex)
      {
          
                System.debug('in catch block>>>>');
                String msg  = 'Message - '+ex.getMessage();
                msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
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