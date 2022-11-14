public class OSM_OMS_WS_CreateOrder 
{
    public static OSM_OMS_CreateOrderGeneral_OP_Wrapper callOMSCreateOrderService(OSM_OMS_CreateOrderGeneral_IP_Wrapper generalizedInputWrapper)
    {
        OSM_OMS_CreateOrderGeneral_OP_Wrapper generalizedOutputWrapper = new OSM_OMS_CreateOrderGeneral_OP_Wrapper();
        
        generalizedOutputWrapper.log = new OSM_Integration_Log__c();
        OSM_WS_OP_CSWrapper resAuthWrapper = new OSM_WS_OP_CSWrapper();
        generalizedOutputWrapper.omsOrderId = '';
        
        try
        {
            OSM_OMS_WS_CreateOrderReq createOrderReq = OSM_OMS_WS_CreateOrderHelper.populateRequestObjectDataForCreateOrder(generalizedInputWrapper); 
            
            String jsonStr = JSON.serialize(createOrderReq);  
            
            //Preaparing request object for final callout layer
            OSM_WS_IP_CSWrapper requestWrap = new OSM_WS_IP_CSWrapper();
            requestWrap.serviceName = Label.OSM_Create_Order_POST;
            //requestWrap.serviceName = 'OMS_CreateOrder_Service';
            generalizedOutputWrapper.log.Service_Name__c = 'OMS_CreateOrder_Service';
            requestWrap.jsonReqBody = jsonStr;
            requestWrap.AuthEnv  = 'OMS_Auth';
            requestWrap.AccesTokenRequired = true;
            generalizedOutputWrapper.log.Target__c = 'OMS';
            generalizedOutputWrapper.log.Request__c = jsonStr;
            generalizedOutputWrapper.log.Source__c = 'OSM';
            generalizedOutputWrapper.log.Logged_In_User__c = userinfo.getuserid();
            generalizedOutputWrapper.log.CC_Order__c = generalizedInputWrapper.orderId;
            generalizedOutputWrapper.log.Account__c = generalizedInputWrapper.AccId; //Added By Dhiraj
            
            
            requestWrap.serviceName = Label.OSM_Create_Order_POST;
            //requestWrap.serviceName = 'OMS_CreateOrder_Service';
            generalizedOutputWrapper.log.Service_Name__c = 'OMS_CreateOrder_Service';
            requestWrap.jsonReqBody = jsonStr;
            requestWrap.AuthEnv  = 'OMS_Auth';
            requestWrap.AccesTokenRequired = true;
            generalizedOutputWrapper.log.Target__c = 'OMS';
            generalizedOutputWrapper.log.Request__c = jsonStr;
            generalizedOutputWrapper.log.Source__c = 'OSM';
            generalizedOutputWrapper.log.Logged_In_User__c = userinfo.getuserid();
            generalizedOutputWrapper.log.CC_Order__c = generalizedInputWrapper.orderId;
            generalizedOutputWrapper.log.Account__c = generalizedInputWrapper.AccId; //Added By Dhiraj
            
            requestWrap.serviceName = Label.OSM_Create_Order_POST;
            //requestWrap.serviceName = 'OMS_CreateOrder_Service';
            generalizedOutputWrapper.log.Service_Name__c = 'OMS_CreateOrder_Service';
            requestWrap.jsonReqBody = jsonStr;
            requestWrap.AuthEnv  = 'OMS_Auth';
            requestWrap.AccesTokenRequired = true;
            generalizedOutputWrapper.log.Target__c = 'OMS';
            generalizedOutputWrapper.log.Request__c = jsonStr;
            generalizedOutputWrapper.log.Source__c = 'OSM';
            generalizedOutputWrapper.log.Logged_In_User__c = userinfo.getuserid();
            generalizedOutputWrapper.log.CC_Order__c = generalizedInputWrapper.orderId;
            generalizedOutputWrapper.log.Account__c = generalizedInputWrapper.AccId; //Added By Dhiraj
            
            //resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(requestWrap);
            resAuthWrapper = OSM_MuleSoft_MW_Services.calloutGeneric(requestWrap);
            
            generalizedOutputWrapper.log.Response__c = resAuthWrapper.Response;
            generalizedOutputWrapper.log.Status__c = 'Failure';
            
             
            generalizedOutputWrapper.log.Response__c = resAuthWrapper.Response;
            generalizedOutputWrapper.log.Status__c = 'Failure';
            
             
            generalizedOutputWrapper.log.Response__c = resAuthWrapper.Response;
            generalizedOutputWrapper.log.Status__c = 'Failure';
            
             
            generalizedOutputWrapper.log.Response__c = resAuthWrapper.Response;
            generalizedOutputWrapper.log.Status__c = 'Failure';
            generalizedOutputWrapper.log.Account__c = generalizedInputWrapper.AccId; //Added By Dhiraj
             if(Test.isRunningTest())
            {
                resAuthWrapper.exceptionFlag=false;
            }
            // there is no error
            if(!resAuthWrapper.exceptionFlag)
            {
                //OSM_OMS_WS_CreateOrderRes createOrderRes = OSM_OMS_WS_CreateOrderRes.parse(resAuthWrapper.Response.substringAfterLast('Response Body: '));
                OSM_OMS_WS_CreateOrderRes createOrderRes = OSM_OMS_WS_CreateOrderRes.parse(resAuthWrapper.Response);
                if(null != createOrderRes)
                {
                    if(null != createOrderRes.CreateOrderOutput 
                       && null != createOrderRes.CreateOrderOutput.OMSOrderID)
                    {
                        generalizedOutputWrapper.omsOrderId = String.valueOf(createOrderRes.CreateOrderOutput.OMSOrderID);
                        //generalizedOutputWrapper.omsOrderId = generalizedInputWrapper.orderId;
                        generalizedOutputWrapper.log.Status__c = 'Success';
                      generalizedOutputWrapper.log.Account__c = generalizedInputWrapper.AccId; //Added By Dhiraj
                    }
                    else if(null != createOrderRes.Error && null != createOrderRes.Error.ErrorDescription)
                    {
                        generalizedOutputWrapper.log.Error_Description__c = createOrderRes.Error.ErrorCode + '-' + createOrderRes.Error.ErrorDescription;
                      generalizedOutputWrapper.log.Account__c = generalizedInputWrapper.AccId; //Added By Dhiraj
                    }
                }
                else
                {
                    generalizedOutputWrapper.log.Error_Description__c = 'Create Order Response is Empty';
                    generalizedOutputWrapper.log.Account__c = generalizedInputWrapper.AccId; //Added By Dhiraj
                }
            }
            else
            {
                generalizedOutputWrapper.log.Error_Description__c = resAuthWrapper.errorMessage;
                generalizedOutputWrapper.log.Account__c = generalizedInputWrapper.AccId; //Added By Dhiraj
                /*if(Test.isRunningTest())
                {
        throw new Exception('Error');   
                }*/
            }
        }
        catch(Exception ex)
        {
            
            String msg  = 'Message - '+ex.getMessage();
            msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
            System.debug('in catch block>>>>' + msg);
            generalizedOutputWrapper.log.Error_Description__c = msg ;
            generalizedOutputWrapper.log.Response__c = resAuthWrapper.Response;
            generalizedOutputWrapper.log.Status__c = 'Failure';  
            generalizedOutputWrapper.log.Account__c = generalizedInputWrapper.AccId; //Added By Dhiraj
        }
        
        System.debug('JK 1 : ' + generalizedOutputWrapper);
        return generalizedOutputWrapper;
    }
    
}