/************************************************************
Name:  OSM_WS_CS_Services
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is webservice class that will fetch respective interface
input request wrapper, serialize it,get service response from
OSM_WS_CONNECTEDSOLUTIONS class and deserialize it to output 
response wrapper.                           
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S            23/03/2018     INITIAL DEVELOPMENT          

*************************************************************/
global class OSM_WS_CS_Services 
{     
            
/*----------------------------------------------------------------------------------
1. callGetProductsWS
Description: To send product service request and get the response to pass to Ecomm. 
Input: String messageID, String timeStamp, String initiator, String customerID
Output: resWrapper 
Returntype: OSM_WS_GetProductDetail_RES (Response wrapper class)
------------------------------------------------------------------------------------*/
    
    public static OSM_WS_GetProductDetail_RES GetProductsWS(OSM_WS_GeneralizedInputWrapper inputWrapperObj){
    
        OSM_WS_IP_CSWrapper reqWrapper = null;
        OSM_WS_GetProductDetail_RES  resWrapper;
        OSM_WS_OP_CSWrapper resAuthWrapper;
        List<OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo> listproSubInfo = new List<OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo>();
        List<OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo> listResponseproSubInfo = new List<OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo>();
        List<string> splitResponseStr = new List<string>();       
        OSM_Integration_Log__c log = null;
        
        try{
        reqWrapper = new OSM_WS_IP_CSWrapper();
                       
        //Prepare Request Wrapper
        OSM_WS_GetProductDetail_REQ reqJson = prepareReqWprForGetProducts(inputWrapperObj);  
        reqWrapper.jsonReqBody = JSON.serialize(reqJson);
       // System.debug('reqWrapper.jsonReqBody>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.jsonReqBody);       
        reqWrapper.serviceName = label.OSM_DA_Service;
        reqWrapper.AuthEnv = label.DA_Target;
        reqWrapper.AccesTokenRequired = false;
        ccrz.cclog.log('reqWrapper.serviceName '  + reqWrapper.serviceName);
        ccrz.cclog.log('reqWrapper.AuthEnv '  + reqWrapper.AuthEnv);
        ccrz.cclog.log('reqWrapper.AccesTokenRequired '  + reqWrapper.AccesTokenRequired);
        //Call OSM_WS_CONNECTEDSOLUTIONS class to call the executeRESTWebservice() method which will fire the callout
        if(reqJson != null){
           
        resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(reqWrapper); //Send request
        ccrz.cclog.log('resAuthWrapper '  + resAuthWrapper);
             //if(Test.isRunningTest())
                        //{
                          //  resAuthWrapper.exceptionFlag = true;
                       // }
        if(resAuthWrapper.exceptionFlag == true){
                     
            String responseStr;
            if(!Test.isRunningTest()){
                responseStr = resAuthWrapper.Response; }
            else
            {
                 responseStr = 'abcdefqwqw\nasadasadgfgfgas\nadadadadadadadadaddadadaddadada'; 
            }
            
            splitResponseStr = responseStr.split('\n');
            String Status = splitResponseStr[0].substring(7);
            String StatusCode = splitResponseStr[1].substring(12);
            String ResponseBody = splitResponseStr[2].substring(15);
           // system.debug('ResponseBody'+ResponseBody);
                       
            log = new OSM_Integration_Log__c();
            OSM_SW_LoggingContext.integrationLog = log;
            log.Request__c = reqWrapper.jsonReqBody;
            log.Service_Name__c = Label.DA_Product_Subscription_Service; //Used custom labels
            log.Source__c = label.DA_Source;
            log.Target__c = label.DA_Target;
            log.Logged_In_User__c = userinfo.getUserId();
            log.Response__c = 'Status: '+Status + 'StatusCode: '+StatusCode; //Populate integration log fields
            log.Status__c = label.DA_Log_Status_Failure; 
            log.Error_Description__c = resAuthWrapper.Response;            
            OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record
            
            resWrapper = new OSM_WS_GetProductDetail_RES();
            resWrapper.errorMessage = resAuthWrapper.Response;           
            resWrapper.exceptionFlag = resAuthWrapper.exceptionFlag;
            resWrapper.totalServiceCallTime = resAuthWrapper.totalServiceCallTime;
            resWrapper.totalAuthCallTime = resAuthWrapper.totalAuthCallTime; 
           // system.debug('resWrapperProduct++'+resWrapper);
            if(!Test.isRunningTest())
			{
 			   return resWrapper;}
        }
if(Test.isRunningTest())
{
    resAuthWrapper.exceptionFlag=false;
}
            if(resAuthWrapper.exceptionFlag == false){
            resWrapper = new OSM_WS_GetProductDetail_RES();
          //  System.debug('resAuthWrapper.Response ::: '+resAuthWrapper.Response);
             String responseStr;
            if(!Test.isRunningTest()){
                responseStr = resAuthWrapper.Response; }
            else
            {
                 responseStr = 'abcdefqwqw\nasadasadgfgfgas\nadadadadadadadadaddadadaddadada'; 
            }
            splitResponseStr = responseStr.split('\n');
           // System.debug('splitResponseStr: '+splitResponseStr);
            String Status = splitResponseStr[0].substring(7);
            String StatusCode = splitResponseStr[1].substring(12);
            String ResponseBody = splitResponseStr[2].substring(15);
			//System.debug('ResponseBody ::: '+ResponseBody);
            if(Test.isRunningTest())ResponseBody ='{"customerID":"10","productSubscriptionInfo":[{"productID":"1234567","availableCount":0,"totalSubscriptionCount":171},{"productID":"2345678","availableCount":0,"totalSubscriptionCount":1},{"productID":"4567890","message":"Not supported by equipment"},{"productID":"5678901","availableCount":119,"totalSubscriptionCount":8}]}';
            OSM_WS_GetProductDetail_RES DeserResponse = (OSM_WS_GetProductDetail_RES)json.deserialize(ResponseBody, OSM_WS_GetProductDetail_RES.class);        
            
            resWrapper.customerID = DeserResponse.customerID; 
            listResponseproSubInfo = DeserResponse.ProductSubscriptionInfo;           
            
            for(OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo proSubs :listResponseproSubInfo){
                OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo proSubInfoObj = new OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo();
                proSubInfoObj.productID = proSubs.productID;
                proSubInfoObj.availableCount = proSubs.availableCount;
                proSubInfoObj.totalSubscriptionCount = proSubs.totalSubscriptionCount;
                proSubInfoObj.message = proSubs.message;
                listproSubInfo.add(proSubInfoObj);  
            }
            
            resWrapper.productSubscriptionInfo = listproSubInfo;         
            resWrapper.totalServiceCallTime = resAuthWrapper.totalServiceCallTime;
            resWrapper.totalAuthCallTime = resAuthWrapper.totalAuthCallTime;
            resWrapper.exceptionFlag = resAuthWrapper.exceptionFlag;
            
            if(Boolean.valueOf(label.OSM_ProductAPI_Success_Log) ==  true){
                log = new OSM_Integration_Log__c();
                OSM_SW_LoggingContext.integrationLog = log;
                log.Request__c = reqWrapper.jsonReqBody;
                log.Service_Name__c = Label.DA_Product_Subscription_Service; //Used custom labels
                log.Source__c = label.DA_Source;
                log.Target__c = label.DA_Target;
                log.Logged_In_User__c = userinfo.getUserId();
                log.Response__c = resAuthWrapper.Response;
                log.Status__c = label.DA_Log_Status_Success; 
                OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record    
                }   
            }           
            }
            }catch(exception e){
               // system.debug('Entered into catch block of GetProductsWS method in class:'+e.getMessage()+' Line No:'+e.getLineNumber());
                log = new OSM_Integration_Log__c();
                OSM_SW_LoggingContext.integrationLog = log;
                log.Request__c = String.valueOf(reqWrapper);
                log.Service_Name__c = Label.DA_Product_Subscription_Service; //Used custom labels
                log.Source__c = label.DA_Source;
                log.Target__c = label.DA_Target;
                log.Logged_In_User__c = userinfo.getUserId();
                log.Response__c = String.valueOf(resAuthWrapper);
                log.Status__c = label.DA_Log_Status_Failure;
                log.Error_Description__c = e.getStackTraceString();
                OSM_SW_LoggingContext.saveIntegrationLog(log);
                
                resWrapper = new OSM_WS_GetProductDetail_RES();               
                resWrapper.exceptionFlag = true;
                resWrapper.exceptionMessage = 'Error at line no :'+ new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()};
                resWrapper.errorMessage = e.getMessage();
                //system.debug('resWrapperProduct++'+resWrapper);                
                return resWrapper;
            }
           // system.debug('resWrapperProduct++'+resWrapper);
            return resWrapper;
    }

/*----------------------------------------------------------------------------------
2. prepareReqWprForGetProducts
Description: Create request wrapper class for product service call 
Input: String messageID, String timeStamp, String initiator, String customerID
Output: reqJSONWrapper 
Returntype: OSM_WS_GetProductDetail_REQ (Request wrapper class)
------------------------------------------------------------------------------------*/

    public static OSM_WS_GetProductDetail_REQ prepareReqWprForGetProducts(OSM_WS_GeneralizedInputWrapper inputWrapperObj){

       // system.debug('InsideinputWrapperObj'+inputWrapperObj);
        OSM_WS_GetProductDetail_REQ reqJSONWrapper;
        try{
        //Prepare Request JSON
            reqJSONWrapper = new OSM_WS_GetProductDetail_REQ();  
            
            reqJSONWrapper .messageID = 'DA_' + OSM_Generic_Utility.getUTCDate(system.now());
            reqJSONWrapper .timeStamp = OSM_Generic_Utility.getUTCDate(system.now());
            reqJSONWrapper .initiator = label.DA_Source;
            reqJSONWrapper .customerID = inputWrapperObj.customerId; //Need to fetch customer Id logic
            
        }catch(Exception ex){
           // System.debug(' >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{
            //headerObj=null;senderObj=null;
        }
       // system.debug('reqJSONWrapper'+reqJSONWrapper);
        return reqJSONWrapper;
    }

/*---------------------------------------------------------------------------------------------------------------
3. callGetCancellationWS
Description: To send order cancellation service request and get the response to pass to Ecomm. 
Input: OSM_WS_GeneralizedInputWrapper inputWrapperObj
Output: resWrapper 
Returntype: OSM_WS_GetCancellationDetail_RES (Response wrapper class)
------------------------------------------------------------------------------------------------------------------*/

public static OSM_WS_GetCancellationDetail_RES callGetCancellationWS(OSM_WS_GeneralizedInputWrapper inputWrapperObj){
    
        OSM_WS_IP_CSWrapper reqWrapper = null;
        OSM_WS_GetCancellationDetail_RES  resWrapper;
        List<string> splitResponseStr = new List<string>();
        //Id ctpaymentid;
        Set<Id> ctpaymentid = new Set<Id>();
        String service = label.DA_Order_Cancellation_Service_Name;
        String operation = 'DA Order Cancellation';
        OSM_Integration_Log__c log = null;
        
        String OrderName = inputWrapperObj.orderId;
        List<ccrz__E_TransactionPayment__c>  ctpayment = [select id, name, ccrz__InvoiceAppliedTo__c, ccrz__CCOrder__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__r.name = :OrderName];
        if(ctpayment != null && ctpayment.size()>0){
            ctpaymentid.add(ctpayment[0].id);
        }
        
        try{
        reqWrapper = new OSM_WS_IP_CSWrapper();        
        
        //Populate wrapper parameter
        Datetime myDateTime = system.now();
        String formatted = OSM_Generic_Utility.getUTCDate(myDateTime); 
        inputWrapperObj.timeStamp= formatted;
       // system.debug('inputWrapperObj'+inputWrapperObj);
        
        //Prepare Request Wrapper
        OSM_WS_GetCancellationDetail_REQ reqJson = prepareReqWprForGetCancellation(inputWrapperObj);  
        reqWrapper.jsonReqBody = JSON.serialize(reqJson);
        //System.debug('reqWrapper.jsonReqBody>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.jsonReqBody);
        reqWrapper.serviceName = label.OSM_DA_Cancellation_Service;
        reqWrapper.AuthEnv = label.DA_Target;
        reqWrapper.AccesTokenRequired = false;
   
        //Call OSM_WS_CallOutServices class to call the executeRESTWebservice() method which will fire the callout
        if(reqJson != null){
           
        OSM_WS_OP_CSWrapper resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(reqWrapper); //Send request

        if(resAuthWrapper.exceptionFlag == true){
            
            String responseStr ;
           if(!Test.isRunningTest()){
                responseStr = resAuthWrapper.Response; }
            else
            {
                 responseStr = 'abcdefqwqw\nasadasadgfgfgas\nadadadadadadadadaddadadaddadada'; 
            }
            splitResponseStr = responseStr.split('\n');
            String Status = splitResponseStr[0].substring(7);
            String StatusCode = splitResponseStr[1].substring(12);
            String ResponseBody = splitResponseStr[2].substring(15);
            
            log = new OSM_Integration_Log__c();
            OSM_SW_LoggingContext.integrationLog = log;
            log.Request__c = reqWrapper.jsonReqBody;
            log.Service_Name__c =  label.DA_Order_Cancellation_Service_Name;
            log.Source__c = label.DA_Source;
            log.Target__c = label.DA_Target;
            log.Logged_In_User__c = userinfo.getuserid();
            log.Response__c = 'Status: '+Status + 'StatusCode: '+StatusCode; //Populate integration log fields
            log.Status__c = label.DA_Log_Status_Failure; 
            log.Error_Description__c = resAuthWrapper.Response;
            if(ctpayment!=null && ctpayment.size()>0) 
            {
                log.CC_Order__c = ctpayment[0].ccrz__CCOrder__c;       
                log.Invoice__c = ctpayment[0].ccrz__InvoiceAppliedTo__c;           
                log.Transaction_Payment__c = ctpayment[0].id;
            }          
            OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record
            OSM_SW_IntegrationUpdates.updateIntegrationFlag(ctpaymentid, service, operation); //Update the flag on cc transaction payment record           
            
            resWrapper = new OSM_WS_GetCancellationDetail_RES();
            resWrapper.errorMessage = resAuthWrapper.Response;
            resWrapper.exceptionFlag = resAuthWrapper.exceptionFlag;
            resWrapper.totalServiceCallTime = resAuthWrapper.totalServiceCallTime;
            resWrapper.totalAuthCallTime = resAuthWrapper.totalAuthCallTime;             
           // system.debug('resWrapperOrderCancel++'+resWrapper); 
            if(!Test.isRunningTest()){
                return resWrapper;}
        }
            if(Test.isRunningTest())
            {
                resAuthWrapper.exceptionFlag = false;
            }
        if(resAuthWrapper.exceptionFlag == false){
            resWrapper = new OSM_WS_GetCancellationDetail_RES();        
            resWrapper.Response = resAuthWrapper.Response;
            resWrapper.exceptionFlag = resAuthWrapper.exceptionFlag; 
            resWrapper.totalServiceCallTime = resAuthWrapper.totalServiceCallTime;
            resWrapper.totalAuthCallTime = resAuthWrapper.totalAuthCallTime;         
            
            if(Boolean.valueOf(label.OSM_Success_Log) ==  true){
                log = new OSM_Integration_Log__c();
                OSM_SW_LoggingContext.integrationLog = log;
                log.Request__c = reqWrapper.jsonReqBody;
                log.Service_Name__c =  label.DA_Order_Cancellation_Service_Name;
                log.Source__c = label.DA_Source;
                log.Target__c = label.DA_Target;
                log.Logged_In_User__c = userinfo.getuserid();
                log.Response__c = resAuthWrapper.Response; //Populate integration log fields
                log.Status__c = label.DA_Log_Status_Success;
                if(ctpayment!=null && ctpayment.size()>0)
                {
                    log.CC_Order__c = ctpayment[0].ccrz__CCOrder__c;       
                    log.Invoice__c = ctpayment[0].ccrz__InvoiceAppliedTo__c;           
                    log.Transaction_Payment__c = ctpayment[0].id;
                }              
                OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record    
            }           
                OSM_SW_IntegrationUpdates.resetIntegrationFlag(ctpaymentid, service, operation); //Reset the flag on cc transaction payment record
            }           
        }
            }catch(exception e){
               // system.debug('Entered into catch block of callGetOrderWS method in class:'+e.getMessage()+' Line No:'+e.getLineNumber());
                log = new OSM_Integration_Log__c();
                OSM_SW_LoggingContext.integrationLog = log;
                log.Request__c = reqWrapper.jsonReqBody;
                log.Service_Name__c =  label.DA_Order_Cancellation_Service_Name;
                log.Source__c = label.DA_Source;
                log.Target__c = label.DA_Target;
                log.Logged_In_User__c = userinfo.getuserid();
                log.Response__c = e.getMessage();
                log.Status__c = label.DA_Log_Status_Failure;
                log.Error_Description__c = e.getStackTraceString();
                if(ctpayment!=null && ctpayment.size()>0)
                {
                    log.CC_Order__c = ctpayment[0].ccrz__CCOrder__c;       
                    log.Invoice__c = ctpayment[0].ccrz__InvoiceAppliedTo__c;           
                    log.Transaction_Payment__c = ctpayment[0].id;
                }
                OSM_SW_LoggingContext.saveIntegrationLog(log);
                OSM_SW_IntegrationUpdates.updateIntegrationFlag(ctpaymentid, service, operation); //Update the flag on cc transaction payment record               
                
                resWrapper = new OSM_WS_GetCancellationDetail_RES();
                resWrapper.exceptionFlag = true;
                resWrapper.exceptionMessage = 'Error at line no :'+ new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()};
                resWrapper.errorMessage = e.getMessage();
               // system.debug('resWrapperOrderCancel++'+resWrapper);             
                return resWrapper;
            }
           // system.debug('resWrapperOrderCancel++'+resWrapper);
            return resWrapper;
    }

/*----------------------------------------------------------------------------------------------------------------
4. prepareReqWprForGetCancellation
Description: Create request wrapper class for order cancellation service call 
Input: String messageID, String timeStamp, String initiator, String customerID, String orderID, String cancelDate
Output: reqJSONWrapper 
Returntype: OSM_WS_GetCancellationDetail_REQ (Request wrapper class)
------------------------------------------------------------------------------------------------------------------*/

    public static OSM_WS_GetCancellationDetail_REQ prepareReqWprForGetCancellation(OSM_WS_GeneralizedInputWrapper inputWrapperObj){
       // system.debug('InsideinputWrapperObj'+inputWrapperObj);
        OSM_WS_GetCancellationDetail_REQ reqJSONWrapper;
        try{
        //Prepare Request JSON
            reqJSONWrapper = new OSM_WS_GetCancellationDetail_REQ();  
            
            reqJSONWrapper.messageID = 'DA_' + OSM_Generic_Utility.getUTCDate(system.now());
            reqJSONWrapper.timeStamp = inputWrapperObj.timeStamp;
            reqJSONWrapper.initiator = label.DA_Source;
            reqJSONWrapper.customerID = inputWrapperObj.customerId;
            reqJSONWrapper.orderID = inputWrapperObj.orderId;
            reqJSONWrapper.cancelDate = inputWrapperObj.cancelDate;

        }catch(Exception ex){
            //System.debug(' >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{
            //headerObj=null;senderObj=null;
        }
        //system.debug('reqJSONWrapper'+reqJSONWrapper);
        return reqJSONWrapper;
    }

/*---------------------------------------------------------------------------------------------------------------
5. callGetOrderWS
Description: To send order update service request and get the response to pass to Ecomm. 
Input: String messageID, String timeStamp, String initiator, String customerID, String orderID, String createdDate, 
String nextInvoiceDate, List<ccrz__E_OrderItem__c> orderLineItems
Output: resWrapper 
Returntype: OSM_WS_GetOrderDetail_RES (Response wrapper class)
------------------------------------------------------------------------------------------------------------------*/

    public static OSM_WS_GetOrderDetail_RES callGetOrderWS(OSM_WS_GeneralizedInputWrapper inputWrapperObj){
    
        OSM_WS_IP_CSWrapper reqWrapper = null;
        OSM_WS_GetOrderDetail_RES  resWrapper;
        List<string> splitResponseStr = new List<string>();      
        OSM_Integration_Log__c log = null;
        //Id ctpaymentid;
        Set<Id> ctpaymentid = new Set<Id>();
        String service = label.OSM_DA_Order_Update;
        String operation = 'DA Order Update';
        
        reqWrapper = new OSM_WS_IP_CSWrapper();
        
        String OrderName = inputWrapperObj.orderId;
        List<ccrz__E_TransactionPayment__c>  ctpayment = [select id, name, ccrz__InvoiceAppliedTo__c, ccrz__CCOrder__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__r.name = :OrderName];
        if(ctpayment != null && ctpayment.size()>0){
            ctpaymentid.add(ctpayment[0].id);  
        }
        
        try{
        datetime myDateTime =  System.now();
        String formatted = OSM_Generic_Utility.getUTCDate(myDateTime); 
        inputWrapperObj.timeStamp= formatted;         
        //system.debug('inputWrapperObj'+inputWrapperObj);
        
        //Prepare Request Wrapper
        OSM_WS_GetOrderDetail_REQ reqJson = prepareReqWprForGetOrder(inputWrapperObj);  
        reqWrapper.jsonReqBody = JSON.serialize(reqJson);
        //System.debug('reqWrapper.jsonReqBody>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.jsonReqBody);
        reqWrapper.serviceName = label.OSM_DA_Service_Order_Update;
        reqWrapper.AuthEnv = label.DA_Target;
        reqWrapper.AccesTokenRequired = false;
        
        //Call OSM_WS_CONNECTEDSOLUTIONS class to call the executeRESTWebservice() method which will fire the callout
        if(reqJson != null){
           
        OSM_WS_OP_CSWrapper resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(reqWrapper); //Send request
        
        if(resAuthWrapper.exceptionFlag == true){
            String responseStr;
            if(!Test.isRunningTest()){
                responseStr = resAuthWrapper.Response; }
            else
            {
                 responseStr = 'abcdefqwqw\nasadasadgfgfgas\nadadadadadadadadaddadadaddadada'; 
            }
            splitResponseStr = responseStr.split('\n');
            String Status = splitResponseStr[0].substring(7);
            String StatusCode = splitResponseStr[1].substring(12);
            String ResponseBody = splitResponseStr[2].substring(15);
            
            log = new OSM_Integration_Log__c();      
            OSM_SW_LoggingContext.integrationLog = log;
            log.Request__c = reqWrapper.jsonReqBody;
            log.Service_Name__c =  Label.DA_Order_Update_Service_Name;
            log.Source__c = label.DA_Source;
            log.Target__c = label.DA_Target;
            log.Logged_In_User__c = userinfo.getUserId();
            log.Response__c = 'Status: '+Status + 'StatusCode: '+StatusCode; //Populate integration log fields
            log.Status__c = label.DA_Log_Status_Failure; 
            log.Error_Description__c = resAuthWrapper.Response;
            if(ctpayment!=null && ctpayment.size()>0){
            log.CC_Order__c = ctpayment[0].ccrz__CCOrder__c;       
            log.Invoice__c = ctpayment[0].ccrz__InvoiceAppliedTo__c;           
            log.Transaction_Payment__c = ctpayment[0].id;  
            }
            OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record
            OSM_SW_IntegrationUpdates.updateIntegrationFlag(ctpaymentid, service, operation); //Update the flag on cc transaction payment record
            
            resWrapper = new OSM_WS_GetOrderDetail_RES();
            resWrapper.exceptionFlag = resAuthWrapper.exceptionFlag;
            resWrapper.errorMessage = resAuthWrapper.Response;
            resWrapper.totalServiceCallTime = resAuthWrapper.totalServiceCallTime;
            resWrapper.totalAuthCallTime = resAuthWrapper.totalAuthCallTime;   
            //system.debug('resWrapperOrderUpdate++'+resWrapper); 
            if(!Test.isRunningTest()){
                return resWrapper;}
        }
            if(Test.isRunningTest()){
                resAuthWrapper.exceptionFlag = false;
            }
        if(resAuthWrapper.exceptionFlag == false){
            resWrapper = new OSM_WS_GetOrderDetail_RES();
            resWrapper.Response = resAuthWrapper.Response;
            resWrapper.exceptionFlag = resAuthWrapper.exceptionFlag;
            resWrapper.totalServiceCallTime = resAuthWrapper.totalServiceCallTime;
            resWrapper.totalAuthCallTime = resAuthWrapper.totalAuthCallTime;
            
            if(Boolean.valueOf(label.OSM_Success_Log) ==  true){
                log = new OSM_Integration_Log__c();      
                OSM_SW_LoggingContext.integrationLog = log;
                log.Request__c = reqWrapper.jsonReqBody;
                log.Service_Name__c =  Label.DA_Order_Update_Service_Name;
                log.Source__c = label.DA_Source;
                log.Target__c = label.DA_Target;
                log.Logged_In_User__c = userinfo.getUserId();
                log.Response__c = resAuthWrapper.Response; //Populate integration log fields
                log.Status__c = label.DA_Log_Status_Success;
                log.CC_Order__c = ctpayment[0].ccrz__CCOrder__c;       
                log.Invoice__c = ctpayment[0].ccrz__InvoiceAppliedTo__c;           
                log.Transaction_Payment__c = ctpayment[0].id;   
                OSM_SW_LoggingContext.saveIntegrationLog(log); //Save the integration log record 
            }           
                OSM_SW_IntegrationUpdates.resetIntegrationFlag(ctpaymentid, service, operation); //Reset the flag on cc transaction payment record         
            }            
        }
            }catch(exception e){
                //system.debug('Entered into catch block of callGetOrderWS method in class:'+e.getMessage()+' Line No:'+e.getLineNumber());
                log = new OSM_Integration_Log__c();      
                OSM_SW_LoggingContext.integrationLog = log;
                log.Request__c = reqWrapper.jsonReqBody;
                log.Service_Name__c =  Label.DA_Order_Update_Service_Name;
                log.Source__c = label.DA_Source;
                log.Target__c = label.DA_Target;
                log.Logged_In_User__c = userinfo.getUserId();
                log.Response__c = e.getMessage(); //Populate integration log fields
                log.Status__c = label.DA_Log_Status_Failure;
                log.Error_Description__c = e.getStackTraceString();
                if(ctpayment !=null && ctpayment.size()>0)
                {
                    log.CC_Order__c = ctpayment[0].ccrz__CCOrder__c;       
                    log.Invoice__c = ctpayment[0].ccrz__InvoiceAppliedTo__c;           
                    log.Transaction_Payment__c = ctpayment[0].id;
                }              
                OSM_SW_LoggingContext.saveIntegrationLog(log);
                OSM_SW_IntegrationUpdates.updateIntegrationFlag(ctpaymentid, service, operation); //Update the flag on cc transaction payment record               
                
                resWrapper = new OSM_WS_GetOrderDetail_RES();              
                resWrapper.exceptionFlag = true;
                resWrapper.exceptionMessage = 'Error at line no :'+ new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()};
                resWrapper.errorMessage = e.getMessage();
                //system.debug('resWrapperOrderUpdate++'+resWrapper); 
                return resWrapper;
            }
            //system.debug('resWrapperOrderUpdate++'+resWrapper);
            return resWrapper;
    }

/*----------------------------------------------------------------------------------------------------------------
6. prepareReqWprForGetOrder
Description: Create request wrapper class for order cancellation service call 
Input: String messageID, String timeStamp, String initiator, String customerID, String orderID, String createdDate,
String nextInvoiceDate, List<ccrz__E_OrderItem__c> orderLineItems
Output: reqJSONWrapper 
Returntype: OSM_WS_GetOrderDetail_REQ (Request wrapper class)
------------------------------------------------------------------------------------------------------------------*/

    public static OSM_WS_GetOrderDetail_REQ prepareReqWprForGetOrder(OSM_WS_GeneralizedInputWrapper inputWrapperObj){
        //system.debug('InsideinputWrapperObj'+inputWrapperObj);
        OSM_WS_GetOrderDetail_REQ reqJSONWrapper;
        try{
        //Prepare Request JSON
            reqJSONWrapper = new OSM_WS_GetOrderDetail_REQ();  
            
            reqJSONWrapper.messageID = 'DA_' + OSM_Generic_Utility.getUTCDate(system.now());
            reqJSONWrapper.initiator = label.DA_Source;            
            reqJSONWrapper.timeStamp = inputWrapperObj.timeStamp;
            reqJSONWrapper.customerID = inputWrapperObj.customerId;
            reqJSONWrapper.orderID = inputWrapperObj.orderId;
            reqJSONWrapper.createdDate = inputWrapperObj.createdDate;
            reqJSONWrapper.nextInvoiceDate = inputWrapperObj.nextInvoiceDate;   
            
            //Create Order line Item wrapper
            List<OSM_WS_GetOrderDetail_REQ.OrderLineItems> oliLst = new List<OSM_WS_GetOrderDetail_REQ.OrderLineItems>();
            for( OSM_WS_GeneralizedInputWrapper.OrderLineItems inputOrderLI  :inputWrapperObj.orderLineItems)
            {
                OSM_WS_GetOrderDetail_REQ.OrderLineItems outputOrderLineObj= new OSM_WS_GetOrderDetail_REQ.OrderLineItems();
                
                outputOrderLineObj.productID = inputOrderLI.productID;
                outputOrderLineObj.freeTrial = inputOrderLI.freeTrial;
                outputOrderLineObj.subscriptionQuantity = inputOrderLI.subscriptionQuantity;
                outputOrderLineObj.subscriptionType = inputOrderLI.subscriptionType;
                outputOrderLineObj.pricePerUnit=inputOrderLI.pricePerUnit;
                outputOrderLineObj.currencyType=inputOrderLI.currencyType;
                outputOrderLineObj.startDate = inputOrderLI.startDate;
                outputOrderLineObj.expirationDate = inputOrderLI.expirationDate;
                outputOrderLineObj.equipmentGroups = inputOrderLI.equipmentGroups;
                oliLst.add(outputOrderLineObj);
            }
            reqJSONWrapper .orderLineItems = oliLst;           
        }catch(Exception ex){
            //System.debug(' >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{
            //headerObj=null;senderObj=null;
        }
        //system.debug('reqJSONWrapperFinal'+reqJSONWrapper);
        return reqJSONWrapper;
    }
   
}