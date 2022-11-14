/************************************************************
Name:  OSM_WS_FreeTrialServiceCall 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is service layer for free trial subscription. This is
global class which will use business wrapper to make a servic
call. It will return, webservice call response through object
instance which will be use in business class. 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         01/07/2018     INITIAL DEVELOPMENT          


*************************************************************/
global class OSM_WS_FreeTrialServiceCall{
    
/*----------------------------------------------------------------------------------
1. callFreeTrailService
Description:Used to fetch business wrapper and pass it to make a service call
Input: OSM_WS_GeneralizedInputWrapper inputWrapperObj
Output: Response from callout layer
Returntype: OSM_WS_GetFreeTrailRes
------------------------------------------------------------------------------------*/  
    public static OSM_WS_GetFreeTrailRes callFreeTrailService(OSM_WS_GeneralizedInputWrapper inputWrapperObj){
        
        OSM_WS_IP_CSWrapper reqWrapper = null;
        OSM_WS_GetFreeTrailRes resWrapper;
        
        try{
        reqWrapper = new OSM_WS_IP_CSWrapper();
        
        //Prepare Request Wrapper
        OSM_WS_GetFreeTrailReq reqJson = prepareReqWprForFreeTrial(inputWrapperObj);  
        reqWrapper.jsonReqBody = JSON.serialize(reqJson);
        System.debug('reqWrapper.jsonReqBody>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.jsonReqBody);
        reqWrapper.serviceName = 'GetOrder';
        reqWrapper.AuthEnv = 'DA';
        reqWrapper.AccesTokenRequired = false;
        
        //Call OSM_WS_CallOutServices class to call the executeRESTWebservice() method which will fire the callout
        if(reqJson != null){
           
        OSM_WS_OP_CSWrapper resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(reqWrapper); //Send request
        
        if(resAuthWrapper.exceptionFlag == true){
            resWrapper = new OSM_WS_GetFreeTrailRes();
                    
            resWrapper.Status = Label.OSM_Callout_Fail_Response;
            resWrapper.Request = resAuthWrapper.Request;
            resWrapper.Response = resAuthWrapper.Response;
            resWrapper.errorMessage = resAuthWrapper.Response;
            resWrapper.exceptionFlag = resAuthWrapper.exceptionFlag;
            resWrapper.totalServiceCallTime = resAuthWrapper.totalServiceCallTime;
            resWrapper.totalAuthCallTime = resAuthWrapper.totalAuthCallTime;             
            
            system.debug('resWrapperFreeTrail++'+resWrapper);            
            return resWrapper;
        }
        if(resAuthWrapper.exceptionFlag == false){
            resWrapper = new OSM_WS_GetFreeTrailRes();         
            
            resWrapper.Status = Label.OSM_Callout_Pass_Response;
            resWrapper.Request = resAuthWrapper.Request;
            resWrapper.Response = resAuthWrapper.Response;
            resWrapper.exceptionFlag = resAuthWrapper.exceptionFlag; 
            resWrapper.totalServiceCallTime = resAuthWrapper.totalServiceCallTime;
            resWrapper.totalAuthCallTime = resAuthWrapper.totalAuthCallTime;         
        }           
        }
            }catch(exception e){
                system.debug('Entered into catch block of callFreeTrailService method in class:'+e.getMessage()+' Line No:'+e.getLineNumber());
                resWrapper = new OSM_WS_GetFreeTrailRes();
                resWrapper.Status = Label.OSM_Callout_Fail_Response;
                resWrapper.exceptionFlag = true;
                resWrapper.errorMessage = e.getMessage();
                resWrapper.Response = e.getStackTraceString();
                system.debug('resWrapperFreeTrial++'+resWrapper);                
                return resWrapper;
            }
            system.debug('resWrapperFreeTrial++'+resWrapper);
            return resWrapper;
        
    }
     
    //Prepare wrapper for free trial service call   
    public static OSM_WS_GetFreeTrailReq prepareReqWprForFreeTrial(OSM_WS_GeneralizedInputWrapper inputWrapperObj){
        system.debug('InsideinputWrapperObj'+inputWrapperObj);
        OSM_WS_GetFreeTrailReq reqJSONWrapper;
        try{
        //Prepare Request JSON
            reqJSONWrapper = new OSM_WS_GetFreeTrailReq();  
            
            reqJSONWrapper.messageID = 'FT' + OSM_Generic_Utility.getUTCDate(system.now()); //Check from Vaibhav
            reqJSONWrapper.initiator = Label.OSM_Bolt_Source;            
            reqJSONWrapper.timeStamp = inputWrapperObj.timeStamp;
            reqJSONWrapper.customerID = inputWrapperObj.customerId;
            reqJSONWrapper.orderID = inputWrapperObj.orderId;
            reqJSONWrapper.createdDate = inputWrapperObj.createdDate;
            reqJSONWrapper.nextInvoiceDate = inputWrapperObj.nextInvoiceDate;   
            
            //Create Order line Item wrapper
            List<OSM_WS_GetFreeTrailReq.OrderLineItems> oliLst = new List<OSM_WS_GetFreeTrailReq.OrderLineItems>();
            for( OSM_WS_GeneralizedInputWrapper.OrderLineItems inputOrderLI  :inputWrapperObj.orderLineItems)
            {
                OSM_WS_GetFreeTrailReq.OrderLineItems outputOrderLineObj= new OSM_WS_GetFreeTrailReq.OrderLineItems();
                
                outputOrderLineObj.productID = inputOrderLI.productID;
                outputOrderLineObj.freeTrial = inputOrderLI.freeTrial;
                outputOrderLineObj.subscriptionQuantity = inputOrderLI.subscriptionQuantity;
                outputOrderLineObj.subscriptionType = inputOrderLI.subscriptionType;
                outputOrderLineObj.pricePerUnit=inputOrderLI.pricePerUnit;
                outputOrderLineObj.currencyType=inputOrderLI.currencyType;
                outputOrderLineObj.startDate = inputOrderLI.startDate;
                outputOrderLineObj.expirationDate = inputOrderLI.expirationDate;
                //outputOrderLineObj.equipmentGroups = inputOrderLI.equipmentGroups;
                oliLst.add(outputOrderLineObj);
            }
            reqJSONWrapper .orderLineItems = oliLst;           
        }catch(Exception ex){
            System.debug(' >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{
            //headerObj=null;senderObj=null;
        }
        system.debug('reqJSONWrapperFinal'+reqJSONWrapper);
        return reqJSONWrapper;
    }
    
}