/************************************************************
Name:  OSM_BOLT_WS_ARInvoiceOutbound 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is service layer class where AR Invoice and
Journal Entry input wrapper will be created. Dynamic wrapper 
coming in as input generalized class and static paramters 
will add up to form the final wrapper. This will then be sent
as jsonbody to access http callout and get the response.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_BOLT_WS_ARInvoiceOutbound{
   
    public static OSM_BOLT_WS_ARInvoiceOutboundRes callARInvoice(OSM_BOLT_WS_GeneralizedInputWrapper inputWrapperObj){
       
       // system.debug('inputWrapperObj'+inputWrapperObj);
       
        OSM_BOLT_WS_ARInvoiceOutboundReq reqJSONwrapper;    
        OSM_BOLT_WS_ARInvoiceOutboundRes resWrapper;
        OSM_WS_IP_CSWrapper requestWrap;               
        
        try{ 
            requestWrap = new OSM_WS_IP_CSWrapper();
            
            reqJSONwrapper =  new OSM_BOLT_WS_ARInvoiceOutboundReq();   
       
            reqJSONwrapper = prepareReqWrapper(inputWrapperObj);
            //system.debug('reqJSONwrapper'+reqJSONwrapper);
       
            String jBody = JSON.Serialize(reqJSONwrapper);
           // system.debug('jBody'+jBody);
           
            requestWrap.jsonReqBody = jBody;
            requestWrap.serviceName = Label.CSO_ARInvoice;
            // requestWrap.serviceName = 'getARInvoice'; //As in custom setting - Service Name
            requestWrap.AuthEnv  = 'OSMBolt'; //As in custom setting - Auth Env
            requestWrap.AccesTokenRequired = true;

            if(reqJSONwrapper != null){
                
                // OSM_WS_OP_CSWrapper resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(requestWrap); //Send request
                OSM_WS_OP_CSWrapper resAuthWrapper = OSM_MuleSoft_MW_Services.calloutGeneric(requestWrap);
                
                system.debug('resAuthWrapper'+resAuthWrapper);
                
                if(resAuthWrapper.exceptionFlag == true){
                    resWrapper = new OSM_BOLT_WS_ARInvoiceOutboundRes();
                    resWrapper.Status = label.OSM_Bolt_Log_Status_Failure;
                    resWrapper.exceptionFlag = true;
                    resWrapper.Request = resAuthWrapper.Request;
                    resWrapper.ReturnCodeDescription = resAuthWrapper.Response;
                    resWrapper.errorMessage = resAuthWrapper.errorMessage;                  
                    resWrapper.totalServiceCallTime = resAuthWrapper.totalServiceCallTime;
                    resWrapper.totalAuthCallTime = resAuthWrapper.totalAuthCallTime;
                
                    return resWrapper;
                    }
                if(resAuthWrapper.exceptionFlag == false){
                    resWrapper = new OSM_BOLT_WS_ARInvoiceOutboundRes();
                    resWrapper.Status = label.OSM_Bolt_Log_Status_Success;
                    resWrapper.exceptionFlag = false;
                    resWrapper.Request = resAuthWrapper.Request;
                    resWrapper.ReturnCodeDescription = resAuthWrapper.Response;                  
                    resWrapper.totalServiceCallTime = resAuthWrapper.totalServiceCallTime;
                    resWrapper.totalAuthCallTime = resAuthWrapper.totalAuthCallTime;
                
                    }   
                }           
            }catch(exception e){
                    //system.debug('Entered into catch block of callGetOrderWS method in class:'+e.getMessage()+' Line No:'+e.getLineNumber());
                    resWrapper = new OSM_BOLT_WS_ARInvoiceOutboundRes();
                    resWrapper.Status = label.OSM_Bolt_Log_Status_Failure;
                    resWrapper.exceptionFlag = true;
                    resWrapper.errorMessage = e.getmessage();
                    resWrapper.ReturnCodeDescription = e.getStackTraceString();
                
                    return resWrapper;
                }
               // system.debug('resWrapper++'+resWrapper);
                return resWrapper;
            }       
        
    //Preparing final wrapper
    public static OSM_BOLT_WS_ARInvoiceOutboundReq prepareReqWrapper(OSM_BOLT_WS_GeneralizedInputWrapper reqWrap){      
        
       // system.debug('reqWrap'+reqWrap);        

        OSM_BOLT_WS_ARInvoiceOutboundReq reqWrapperNew = new OSM_BOLT_WS_ARInvoiceOutboundReq();
        OSM_BOLT_WS_ARInvoiceOutboundReq.AR_INV_INBND_STG_ROW innerObj = new OSM_BOLT_WS_ARInvoiceOutboundReq.AR_INV_INBND_STG_ROW();
        
        OSM_BOLT_WS_ARInvoiceOutboundReq.Sender senderObj = new OSM_BOLT_WS_ARInvoiceOutboundReq.Sender(); 
        OSM_BOLT_WS_ARInvoiceOutboundReq.Target targetObj = new OSM_BOLT_WS_ARInvoiceOutboundReq.Target();
        OSM_BOLT_WS_ARInvoiceOutboundReq.Header headerObj = new OSM_BOLT_WS_ARInvoiceOutboundReq.Header();
        OSM_BOLT_WS_ARInvoiceOutboundReq.DataArea objDataArea = new OSM_BOLT_WS_ARInvoiceOutboundReq.DataArea();
        
        OSM_Label__mdt osmLabel = [Select OSM_WS_Batch_Source_Name__c, OSM_WS_Entity_Code__c, OSM_WS_Interface_Line_Context__c, OSM_WS_Invoice_Type__c, OSM_WS_LineType__c, OSM_INTERFACE_LINE_ATTRIBUTE4__c, OSM_WS_Segment3__c, OSM_WS_Segment6__c, OSM_TRANSACTION_INFO_CONTEXT__c, OSM_WS_Segment7__c from OSM_Label__mdt];
        
        try{            
            OSM_BOLT_WS_GeneralizedInputWrapper.AR_INV_INBND_STG_ROW objInputIns = reqWrap.DataArea.AR_INV_INBND_STG_ROW != null ? reqWrap.DataArea.AR_INV_INBND_STG_ROW : new OSM_BOLT_WS_GeneralizedInputWrapper.AR_INV_INBND_STG_ROW();
            OSM_BOLT_WS_GeneralizedInputWrapper.Sender senderInputIns ;
            if(!Test.isRunningTest()){
            senderInputIns = reqWrap.Header.Sender != null ? reqWrap.Header.Sender : new OSM_BOLT_WS_GeneralizedInputWrapper.Sender();
            }     
                //Assigning dynamic fields of AR_INV_INBND_STG_ROW
                innerObj.AMOUNT = objInputIns.AMOUNT;
                innerObj.BILL_TO_CUSTOMER_NUM  =  objInputIns.BILL_TO_CUSTOMER_NUM;
                innerObj.CURRENCY_CODE  =  objInputIns.CURRENCY_CODE;
                innerObj.CUST_TRX_TYPE_NAME  =  objInputIns.CUST_TRX_TYPE_NAME;
                innerObj.INTERFACE_LINE_ATTRIBUTE2  =  objInputIns.INTERFACE_LINE_ATTRIBUTE2;
                innerObj.ORIG_SYSTEM_BILL_ADDRESS_REF  =  objInputIns.ORIG_SYSTEM_BILL_ADDRESS_REF;
                innerObj.SEGMENT4  =  objInputIns.SEGMENT4;
                innerObj.SEGMENT5  =  objInputIns.SEGMENT5;
                innerObj.SIGN  =  objInputIns.SIGN;
                innerObj.TRX_DATE  =  objInputIns.TRX_DATE;
                innerObj.TRX_NUMBER  =  objInputIns.TRX_NUMBER;
                innerObj.ORIG_SYSTEM_BILL_CUSTOMER_REF = objInputIns.ORIG_SYSTEM_BILL_CUSTOMER_REF;
                innerObj.TRX_TYPE  =  objInputIns.TRX_TYPE;             
                innerObj.TERM_NAME  =  objInputIns.TERM_NAME;
                innerObj.ORACLE_CUSTOMER_NUMBER  =  objInputIns.ORACLE_CUSTOMER_NUMBER;
                innerObj.BATCH_DATE  =  objInputIns.BATCH_DATE;
                innerObj.BATCH_NUMBER  =  objInputIns.BATCH_NUMBER;
                innerObj.CONVERSION_DATE = objInputIns.CONVERSION_DATE;
                innerObj.CONVERSION_RATE = objInputIns.CONVERSION_RATE;
                innerObj.CONVERSION_TYPE = objInputIns.CONVERSION_TYPE;
                innerObj.COMMENTS = objInputIns.COMMENTS;
                innerObj.INVOICE_REF_FOR_CREDIT_MEMO = objInputIns.INVOICE_REF_FOR_CREDIT_MEMO ;
                innerObj.PURCHASE_ORDER = objInputIns.PURCHASE_ORDER;
                innerObj.INTERFACE_LINE_ATTRIBUTE3 = objInputIns.INTERFACE_LINE_ATTRIBUTE3;
                //innerObj.CREATION_DATE = objInputIns.CREATION_DATE;
                //innerObj.LAST_UPDATE_DATE = objInputIns.LAST_UPDATE_DATE;
                //innerObj.LAST_UPDATED_BY = objInputIns.LAST_UPDATED_BY;
                //innerObj.CREATED_BY = objInputIns.CREATED_BY;
                innerObj.TRANSACTION_ID = objInputIns.TRANSACTION_ID;
                innerObj.GL_DATE = objInputIns.GL_DATE;
                innerObj.ENTITY_CODE = objInputIns.ENTITY_CODE;
                innerObj.OPERATING_UNIT = objInputIns.OPERATING_UNIT;
                
                //Assigning dynamic fields of sender
                 if(!Test.isRunningTest()){
                senderObj.ServiceName = senderInputIns.ServiceName;
                
                //Adding Static fields
                //Setting up Header
           
                senderObj.SenderID = label.OSM_Bolt_Source;
                targetObj.TargetID = label.OSM_Bolt_Target;
        }
                headerObj.sender = senderObj;
                headerObj.target = targetObj;

                reqWrapperNew.header = headerObj;               
                                
                //Setting up static fields
                innerObj.ACCOUNT_CLASS  = '';
                innerObj.BATCH_SOURCE_NAME  = osmLabel.OSM_WS_Batch_Source_Name__c;
                innerObj.CODE_COMBINATION_ID  = '';
                innerObj.CUST_TRX_TYPE_ID  =  '';
                innerObj.INTERFACE_LINE_ATTRIBUTE1  =  Label.OSM_BC + Label.OSM_RC;
                innerObj.INTERFACE_LINE_CONTEXT  =  osmlabel.OSM_WS_Interface_Line_Context__c;
                innerObj.INVOICE_TYPE  =  osmlabel.OSM_WS_Invoice_Type__c;
                innerObj.LINE_TYPE  =  osmlabel.OSM_WS_LineType__c;
                innerObj.LINK_TO_LINE_ATTRIBUTE2  =  '';
                innerObj.SEGMENT1  =  Label.OSM_BC; 
                innerObj.SEGMENT2  =  Label.OSM_RC; 
                innerObj.SEGMENT3  =  osmlabel.OSM_WS_Segment3__c;
                innerObj.SEGMENT6  =  osmlabel.OSM_WS_Segment6__c;
                innerObj.SEGMENT7  =  osmlabel.OSM_WS_Segment7__c;
                innerObj.SET_OF_BOOKS_ID  =  '';
                innerObj.TAX_CODE  =  '';
                innerObj.VAT_AMOUNT  =  '';
                innerObj.INTERFACE_LINE_ATTRIBUTE4  =  osmlabel.OSM_INTERFACE_LINE_ATTRIBUTE4__c;
                innerObj.TRANSACTION_INFO_CONTEXT  =  osmlabel.OSM_TRANSACTION_INFO_CONTEXT__c;
    
                objDataArea.AR_INV_INBND_STG_ROW = innerObj;               
                reqWrapperNew.DataArea = objDataArea; 
                                  
        }catch(Exception ex){
           // System.debug('>>>>>>>>>>>>>>>getLineNumber is:'+ex.getLineNumber()+ 'Exception Message>>>is:'+ex.getMessage()); 
        }
       
        return reqWrapperNew;
    }
}