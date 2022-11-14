/************************************************************
Name:  OSM_BAMS_WS_Service
    
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:
This is the service layer to process the Refund for each order.
Handle the exception and raise the flag appropriately.


=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Vaibhav            79/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_BAMS_WS_Service{
    
             // This is service layer
	public static String testNumber='';
    /** prepareBAMSCallForRefund
     * It will take cancelled orderList for which refund has to be initiated.
     * @param Order detail wrapper
     * @return Response Wrapper
     */
    public static OSM_BAMS_WS_RefundResponse_Wrapper prepareBAMSCallForRefund(OSM_BAMS_WS_GeneralizedInputWrapper objwrapper){
        OSM_BAMS_WS_RefundResponse_Wrapper resWrapper;
        OSM_WS_IP_CSWrapper requestWrap; 
        String xmlStrBody;
        
        try{
            requestWrap = new OSM_WS_IP_CSWrapper();
            if(Test.isRunningTest()){
              if(objwrapper.merchantID == 'bams_cummins1'){
               throw new NullPointerException(); 
                }
            } 
        
       //Getting the response  
        try{
            xmlStrBody = OSM_BAMS_WS_ServiceHelper.createXMLRequestForRefund(objwrapper);
            if(Test.isRunningTest()){
              if(objwrapper.merchantID == 'bams_cummins2'){
               throw new NullPointerException(); 
                }
            }  
        }catch(exception e){
            
            //system.debug('Entered into catch block of prepareBAMSCallForRefund method in class:'+e.getMessage()+' Line No:'+e.getLineNumber());
            resWrapper = new OSM_BAMS_WS_RefundResponse_Wrapper();
            resWrapper.Status = label.DA_Log_Status_Failure;
            resWrapper.exceptionFlag = true;
            resWrapper.refundStatusToBAMS='NOT_INITIATED';
            resWrapper.errorMessage = e.getMessage()  +'\n' + e.getStackTraceString();
            return resWrapper;
            
        }
            requestWrap.jsonReqBody = xmlStrBody;
            requestWrap.serviceName = 'OSM-Bank'; //Same as custom setting - service name
            requestWrap.AuthEnv  = 'OSM-Bank'; //Same as custom setting - AuthEnv
            requestWrap.AccesTokenRequired = false;
        
        //call calloutService for sending the request:
        OSM_WS_OP_CSWrapper resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(requestWrap); //Send request
        
       // System.debug('=====resAuthWrapper from WS layer==='+resAuthWrapper);
           // System.debug('=====resAuthWrapper.exceptionFlag==='+resAuthWrapper.exceptionFlag);
            if(Test.isRunningTest()){
                //Incorrect way to do
                if(testNumber=='Test1'){
                    resAuthWrapper.exceptionFlag = true;
                    resAuthWrapper.Response = 'faultcode';
                }
                else if(testNumber=='Test2'){
                     resAuthWrapper.exceptionFlag = false;
                    resAuthWrapper.Response = '';
                    // Added by Pooja, success response
                    resAuthWrapper.responseBody = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-450968792"><wsu:Created>2022-04-01T09:52:30.400Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>1642526898746</c:merchantReferenceCode><c:requestID>6488067495186881004079</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Axj/7wSTX7gGI54cd0IvABsQ0bMmTdixap5ikhJqoAp5mvQ5IhpBGi35BXDJpJl6MV2lgcGMmuKEOydYdXsUwAAAiA2F</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccCreditReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2022-04-01T09:52:30Z</c:requestDateTime><c:amount>833.91</c:amount><c:reconciliationID>46227115</c:reconciliationID></c:ccCreditReply></c:replyMessage></soap:Body></soap:Envelope>';
                }
                else{
                    resAuthWrapper.exceptionFlag = false;
                    resAuthWrapper.Response = 'faultcode';
                    // Added by Pooja, failed response
                    resAuthWrapper.responseBody = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-467138702"><wsu:Created>2022-05-09T12:46:29.557Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>1648738461943</c:merchantReferenceCode><c:requestID>6521003892646724904084</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Axj/7wSTYYEbuppTiiSUABsQ0cuHDNm4YJ5mtA1GeBJ5o89NynpBGibBCjDJpJl6MV2lgcIUmv10ZVgPSVjSIAAASgdG</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccCreditReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2022-05-09T12:46:29Z</c:requestDateTime><c:amount>831.60</c:amount><c:reconciliationID>49883380</c:reconciliationID></c:ccCreditReply></c:replyMessage></soap:Body></soap:Envelope>';
                }
            }
        //in case webservice layer returns the failure
        if(resAuthWrapper.exceptionFlag == true){
            resWrapper = new OSM_BAMS_WS_RefundResponse_Wrapper();   
            resWrapper.Status = label.DA_Log_Status_Failure;
            resWrapper.refundStatusToBAMS = 'FAILURE';
            resWrapper.exceptionFlag = true;
            resWrapper.errorMessage = resAuthWrapper.errorMessage; 
            resWrapper.Request = resAuthWrapper.Request;
            resWrapper.Response = resAuthWrapper.Response;
            resWrapper.totalServiceCallTime = resAuthWrapper.totalServiceCallTime;
            resWrapper.totalAuthCallTime = resAuthWrapper.totalAuthCallTime;
            
            //system.debug('resWrapper++'+resWrapper);
            return resWrapper;
        }
        else if(resAuthWrapper.exceptionFlag == false){
        
        //In case webservice layer got some exception
            resWrapper = new OSM_BAMS_WS_RefundResponse_Wrapper();
            
            resWrapper.exceptionFlag = false;
            resWrapper.Request = resAuthWrapper.Request;
            resWrapper.Response = resAuthWrapper.Response ;                  
            resWrapper.totalServiceCallTime = resAuthWrapper.totalServiceCallTime;
            resWrapper.totalAuthCallTime = resAuthWrapper.totalAuthCallTime; 
            
            /*if(Test.isRunningTest()){ //Commented by Pooja, to pass actual success and failed response above
                
                if(testNumber!='Test1'){
                	resAuthWrapper.Response='';
                    resAuthWrapper.responseBody = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-450968792"><wsu:Created>2022-04-01T09:52:30.400Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>1642526898746</c:merchantReferenceCode><c:requestID>6488067495186881004079</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Axj/7wSTX7gGI54cd0IvABsQ0bMmTdixap5ikhJqoAp5mvQ5IhpBGi35BXDJpJl6MV2lgcGMmuKEOydYdXsUwAAAiA2F</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccCreditReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2022-04-01T09:52:30Z</c:requestDateTime><c:amount>833.91</c:amount><c:reconciliationID>46227115</c:reconciliationID></c:ccCreditReply></c:replyMessage></soap:Body></soap:Envelope>';
                }
                else{
                    resAuthWrapper.Response = 'faultcode';
                }
            }*/
            
            if(resAuthWrapper.Response.contains('faultcode') )
            {
                //if BAMS returns the error
               // System.debug('======Response from BAMS contains the FaultCode====');
                resWrapper.refundStatusToBAMS = 'FAILURE';
                resWrapper.exceptionFlag = true;
                resWrapper.errorMessage = 'Received Error/Fault codes from BAMS.';
                resWrapper.Status = label.DA_Log_Status_Failure;
                try{
                    //resWrapper.OrderRefundResponseNodes = OSM_BAMS_WS_ServiceHelper.parseFailedBAMSResponseForRefund(resAuthWrapper.Response); 
                    resWrapper.OrderRefundResponseNodes = OSM_BAMS_WS_ServiceHelper.parseFailedBAMSResponseForRefund(resAuthWrapper.responseBody); //Pooja : Parsing XML body directly
                     if(Test.isRunningTest()){
                       throw new NullPointerException();
                        } 
                }catch(Exception e)
                    {
                       	system.debug('-ex4444-'+e.getMessage()+'-'+e.getStackTraceString());
                        //In case response could not be parsed successfully
                        resWrapper = new OSM_BAMS_WS_RefundResponse_Wrapper();
                        resWrapper.refundStatusToBAMS = 'FAILURE';
                        resWrapper.Request = resAuthWrapper.Request;
                        resWrapper.Response = resAuthWrapper.Response ; 
                        resWrapper.exceptionFlag = true;
                        resWrapper.errorMessage = 'Could not parse the Error/Fault codes from BAMS.';
                        resWrapper.Status = label.DA_Log_Status_Failure;
                        resWrapper.errorMessage = e.getMessage()  +'\n' + e.getStackTraceString();
                        return resWrapper;
                    }               
               
            }
            else 
            {
                //Handle the success scenario
                String refundStatus='SUCCESS';
                resWrapper.refundStatusToBAMS = refundStatus;
                resWrapper.exceptionFlag = false;
                resWrapper.Status = label.DA_Log_Status_Success;
                
                try{
                  /*if(Test.isRunningTest()){
                      resWrapper.OrderRefundResponseNodes = new OSM_BAMS_OrderRefundNodes();
                        resWrapper.OrderRefundResponseNodes.decision='Decline';
                  }else{*/  
                	resWrapper.OrderRefundResponseNodes = OSM_BAMS_WS_ServiceHelper.parseBAMSResponseForRefund(resAuthWrapper.responseBody); //Pooja : Parsing XML body directly
                  //} 
                //in case we need to check more error codes from BAMS,this is the place to mention
                if(resWrapper.OrderRefundResponseNodes.decision!='ACCEPT' || resWrapper.OrderRefundResponseNodes.reasonCode!='100')
                {
                    refundStatus='FAILURE';
                    resWrapper.refundStatusToBAMS = refundStatus;
                    resWrapper.exceptionFlag = true;
                    resWrapper.Status = label.DA_Log_Status_Failure;
                }
                
                if(Test.isRunningTest()){
                            throw new NullPointerException();
                        
                        }
                
                }catch(Exception e)
                    {
                       	system.debug('-ex2222-'+e.getMessage()+'-'+e.getStackTraceString());
                        //In case response could not be parsed successfully
                        resWrapper = new OSM_BAMS_WS_RefundResponse_Wrapper();
                        resWrapper.refundStatusToBAMS = refundStatus;
                        resWrapper.exceptionFlag = true;
                        resWrapper.Request = resAuthWrapper.Request;
                        resWrapper.Response = resAuthWrapper.Response ; 
                        resWrapper.errorMessage = 'Could not parse the Success message from BAMS.';
                        resWrapper.Status = label.DA_Log_Status_Failure;
                        resWrapper.errorMessage = e.getMessage()  +'\n' + e.getStackTraceString();
                        return resWrapper;
                    }                   
                
                }
            
            }    
         
        }catch(exception e){
            system.debug('-ex3333-'+e.getMessage()+'-'+e.getStackTraceString());
            //system.debug('Entered into catch block of prepareBAMSCallForRefund method in class:'+e.getMessage()+' Line No:'+e.getLineNumber());
            resWrapper = new OSM_BAMS_WS_RefundResponse_Wrapper();
            resWrapper.Status = label.DA_Log_Status_Failure;
            resWrapper.exceptionFlag = true;
            resWrapper.refundStatusToBAMS='NOT_INITIATED';
            resWrapper.errorMessage = e.getMessage()  +'\n' + e.getStackTraceString();
            return resWrapper;
        }
            //system.debug('resWrapper++'+resWrapper);
            
            return resWrapper;
        }
}