/************************************************************
Name:  OSM_BOLT_WS_JournalEntryOutbound 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is service layer class where Journal Entry input wrapper
will be created. Dynamic wrapper coming in as input 
generalized class and static paramters will add up to form 
the final wrapper. This will then be sent as jsonbody to 
access http callout and get the response.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_BOLT_WS_JournalEntryOutbound{
    
    public static OSM_BOLT_WS_JournalEntryOutboundRes callJournalEntry(OSM_BOLT_WS_GeneralizedInputWrapper inputWrapperObj){
        
        system.debug('inputWrapperObj'+inputWrapperObj);
        
        OSM_BOLT_WS_JournalEntryOutboundReq reqJSONwrapper;    
        OSM_BOLT_WS_JournalEntryOutboundRes resWrapper;
        OSM_WS_IP_CSWrapper requestWrap;   
        
        try{
            requestWrap = new OSM_WS_IP_CSWrapper();
            
            reqJSONwrapper =  new OSM_BOLT_WS_JournalEntryOutboundReq();   
            
            reqJSONwrapper = prepareReqWrapper(inputWrapperObj);
            system.debug('reqJSONwrapper'+reqJSONwrapper);
            
            String jBody = JSON.Serialize(reqJSONwrapper);
            system.debug('jBody'+jBody);
            
            requestWrap.jsonReqBody = jBody;
            requestWrap.serviceName = Label.OSM_JournalAPI;
            //requestWrap.serviceName = 'getJournalEntry'; //Same as custom setting - service name
            requestWrap.AuthEnv  = 'OSMBolt'; //Same as custom setting - AuthEnv
            requestWrap.AccesTokenRequired = true;
            
            if(reqJSONwrapper != null){
                OSM_WS_OP_CSWrapper resAuthWrapper = OSM_MuleSoft_MW_Services.calloutGeneric(requestWrap);
                resWrapper = new OSM_BOLT_WS_JournalEntryOutboundRes();
                resWrapper.Request = resAuthWrapper.Request;
                resWrapper.ReturnCodeDescription = resAuthWrapper.Response ; 
                resWrapper.totalServiceCallTime = resAuthWrapper.totalServiceCallTime;
                resWrapper.totalAuthCallTime = resAuthWrapper.totalAuthCallTime;
                resWrapper.ReturnCodeDescription = resAuthWrapper.Response;
                
                Map<String, Object> statusmap = (Map<String, Object>) JSON.deserializeUntyped(resAuthWrapper.Response);
                
                if(resAuthWrapper.exceptionFlag == true ||(statusmap!=null && statusmap.containskey('Status') && statusmap.get('Status') !='Success')){
                    resWrapper.Status = label.OSM_Bolt_Log_Status_Failure;
                    resWrapper.exceptionFlag = true;
                    resWrapper.ReturnCodeDescription = resAuthWrapper.Response;
                    resWrapper.errorMessage = resAuthWrapper.errorMessage;                  
                    return resWrapper;
                }
                if(resAuthWrapper.exceptionFlag == false){
                    resWrapper.Status = label.OSM_Bolt_Log_Status_Success;
                    resWrapper.exceptionFlag = false;
                   
                }   
            }           
        }catch(exception e){
            system.debug('Entered into catch block of callGetOrderWS method in class:'+e.getMessage()+' Line No:'+e.getLineNumber());
            resWrapper = new OSM_BOLT_WS_JournalEntryOutboundRes();
            resWrapper.Status = label.OSM_Bolt_Log_Status_Failure;
            resWrapper.exceptionFlag = true;
            resWrapper.errorMessage = e.getStackTraceString();
            resWrapper.ReturnCodeDescription = e.getStackTraceString();                 
            
            return resWrapper;
        }
        system.debug('resWrapper++'+resWrapper);
        return resWrapper;
    }
    
    public static OSM_BOLT_WS_JournalEntryOutboundReq prepareReqWrapper(OSM_BOLT_WS_GeneralizedInputWrapper reqWrap){
        
        system.debug('reqWrap'+reqWrap);
        //initializing class objects
        OSM_BOLT_WS_JournalEntryOutboundReq reqWrapperNew = new OSM_BOLT_WS_JournalEntryOutboundReq();
        OSM_BOLT_WS_JournalEntryOutboundReq.Sender senderObj = new OSM_BOLT_WS_JournalEntryOutboundReq.Sender();
        OSM_BOLT_WS_JournalEntryOutboundReq.Target targetObj = new OSM_BOLT_WS_JournalEntryOutboundReq.Target();
        OSM_BOLT_WS_JournalEntryOutboundReq.DataArea dataAreaObj = new OSM_BOLT_WS_JournalEntryOutboundReq.DataArea();
        OSM_BOLT_WS_JournalEntryOutboundReq.JE_CTRL_TBL_ROW controlTObj = new OSM_BOLT_WS_JournalEntryOutboundReq.JE_CTRL_TBL_ROW();
        OSM_BOLT_WS_JournalEntryOutboundReq.Header  headerObj = new OSM_BOLT_WS_JournalEntryOutboundReq.Header();
        OSM_BOLT_WS_JournalEntryOutboundReq.JE_INV_INBND_STG_ROW stageTabObj = new OSM_BOLT_WS_JournalEntryOutboundReq.JE_INV_INBND_STG_ROW();
        
        OSM_BOLT_WS_JournalEntryOutboundReq.JE_INV_INBND_STG_ROW_LINES RevenueObj = new OSM_BOLT_WS_JournalEntryOutboundReq.JE_INV_INBND_STG_ROW_LINES();
        OSM_BOLT_WS_JournalEntryOutboundReq.JE_INV_INBND_STG_ROW_LINES TaxObj = new OSM_BOLT_WS_JournalEntryOutboundReq.JE_INV_INBND_STG_ROW_LINES();
        OSM_BOLT_WS_JournalEntryOutboundReq.JE_INV_INBND_STG_ROW_LINES DiscountObj = new OSM_BOLT_WS_JournalEntryOutboundReq.JE_INV_INBND_STG_ROW_LINES();
        OSM_BOLT_WS_JournalEntryOutboundReq.JE_INV_INBND_STG_ROW_LINES BalancingObj = new OSM_BOLT_WS_JournalEntryOutboundReq.JE_INV_INBND_STG_ROW_LINES();
        
        List<OSM_BOLT_WS_JournalEntryOutboundReq.JE_INV_INBND_STG_ROW_LINES> ListStageLine = new List<OSM_BOLT_WS_JournalEntryOutboundReq.JE_INV_INBND_STG_ROW_LINES>();
        
        OSM_Label__mdt osmLabel = [Select OSM_WS_Chart_Of_Account__c, OSM_REFERENCE1__c,OSM_REFERENCE2__c,OSM_REFERENCE3__c,OSM_REFERENCE5__c,OSM_REFERENCE10__c,OSM_User_JE_Source_Name__c, OSM_System_Code__c, OSM_User_JE_Category_Name__c, OSM_WS_In_Created_By__c, OSM_WS_Actual_Flag__c, OSM_WS_Segment3__c, OSM_WS_Segment6__c, OSM_WS_Segment7__c from OSM_Label__mdt];
        
        try{
            //Add dynamic parameters
            OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW journalObj = reqWrap.DataArea.JE_INV_INBND_STG_ROW != null ? reqWrap.DataArea.JE_INV_INBND_STG_ROW : new OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW();
            system.debug('journalObj'+journalObj);
            system.debug('****stageTabObj.LEDGER_ID: '+stageTabObj.LEDGER_ID);
            system.debug('****journalObj.LEDGER_ID: '+journalObj.LEDGER_ID);
            OSM_BOLT_WS_GeneralizedInputWrapper.JE_CTRL_TBL_ROW ConObj = reqWrap.Header.JE_CTRL_TBL_ROW != null ? reqWrap.Header.JE_CTRL_TBL_ROW : new OSM_BOLT_WS_GeneralizedInputWrapper.JE_CTRL_TBL_ROW();
            system.debug('ConObj'+ConObj);
            OSM_BOLT_WS_GeneralizedInputWrapper.Sender senObj = reqWrap.Header.Sender != null ? reqWrap.Header.Sender : new OSM_BOLT_WS_GeneralizedInputWrapper.Sender();
            
            List<OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES> LststageTabRowsObj = reqWrap.DataArea.JE_INV_INBND_STG_ROW.JE_INV_INBND_STG_ROW_LINES != null ? reqWrap.DataArea.JE_INV_INBND_STG_ROW.JE_INV_INBND_STG_ROW_LINES : new List<OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES>();
            system.debug('LststageTabRowsObj'+LststageTabRowsObj);
            
            OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES RObj = LststageTabRowsObj[0];
            OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES TObj = LststageTabRowsObj[1];
            OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES DObj = LststageTabRowsObj[2];
            OSM_BOLT_WS_GeneralizedInputWrapper.JE_INV_INBND_STG_ROW_LINES BObj = LststageTabRowsObj[3];
            
            stageTabObj.LEDGER_ID = journalObj.LEDGER_ID;
            stageTabObj.LEDGER_NAME = journalObj.LEDGER_NAME;
            stageTabObj.ACCOUNTING_DATE = journalObj.ACCOUNTING_DATE;
            stageTabObj.CURRENCY_CODE = journalObj.CURRENCY_CODE;
            stageTabObj.DATE_CREATED = journalObj.DATE_CREATED;
            stageTabObj.CURRENCY_CONVERSION_DATE = journalObj.CURRENCY_CONVERSION_DATE;
            stageTabObj.USER_CURRENCY_CONVERSION_TYPE = journalObj.USER_CURRENCY_CONVERSION_TYPE;
            stageTabObj.CURRENCY_CONVERSION_RATE = journalObj.CURRENCY_CONVERSION_RATE;
            // stageTabObj.SEGMENT5 = journalObj.SEGMENT5; commented for 860
            stageTabObj.REFERENCE6 = journalObj.REFERENCE6;
            stageTabObj.GROUP_ID = journalObj.GROUP_ID;
            stageTabObj.CREATION_DATE = journalObj.CREATION_DATE;
            stageTabObj.LAST_UPDATE_DATE = journalObj.LAST_UPDATE_DATE;
            stageTabObj.LAST_UPDATED_BY = journalObj.LAST_UPDATED_BY;
            stageTabObj.CREATED_BY = journalObj.CREATED_BY;
            stageTabObj.INVOICE_DATE = journalObj.INVOICE_DATE;
            
            //Populating Staging Object 
            RevenueObj.SEGMENT4 = RObj.SEGMENT4;
            RevenueObj.ENTERED_DR = RObj.ENTERED_DR; 
            RevenueObj.ENTERED_CR = RObj.ENTERED_CR;
            RevenueObj.ACCOUNTED_DR = RObj.ACCOUNTED_DR;
            RevenueObj.ACCOUNTED_CR = RObj.ACCOUNTED_CR;
            // Added below segments for 860
            RevenueObj.SEGMENT5 = RObj.SEGMENT5;
            RevenueObj.SEGMENT1 = Label.OSM_BC;
            RevenueObj.SEGMENT2 = Label.OSM_RC;
            RevenueObj.SEGMENT3 = osmLabel.OSM_WS_Segment3__c;
            RevenueObj.SEGMENT6 = osmLabel.OSM_WS_Segment6__c;
            RevenueObj.SEGMENT7 = osmLabel.OSM_WS_Segment7__c;
            ListStageLine.add(RevenueObj);  
            
            // RTC_182227 - BOLT Change Request - April 01, 2019 - Intercompany Invoice should not have this block at all
            if(!reqWrap.isIntercompanyInvoice)
            {
                TaxObj.SEGMENT4 = TObj.SEGMENT4;
                TaxObj.ENTERED_DR = TObj.ENTERED_DR; 
                TaxObj.ENTERED_CR = TObj.ENTERED_CR;
                TaxObj.ACCOUNTED_DR = TObj.ACCOUNTED_DR;
                TaxObj.ACCOUNTED_CR = TObj.ACCOUNTED_CR;
                // Added below segments for 860
                TaxObj.SEGMENT5 = TObj.SEGMENT5;    
                TaxObj.SEGMENT1 = Label.OSM_BC;
                TaxObj.SEGMENT2 = Label.OSM_RC;
                TaxObj.SEGMENT3 = osmLabel.OSM_WS_Segment3__c;
                TaxObj.SEGMENT6 = osmLabel.OSM_WS_Segment6__c;
                TaxObj.SEGMENT7 = osmLabel.OSM_WS_Segment7__c;
                ListStageLine.add(TaxObj);
            }
            
            DiscountObj.SEGMENT4 = DObj.SEGMENT4;
            DiscountObj.ENTERED_DR = DObj.ENTERED_DR; 
            DiscountObj.ENTERED_CR = DObj.ENTERED_CR;
            DiscountObj.ACCOUNTED_DR = DObj.ACCOUNTED_DR;
            DiscountObj.ACCOUNTED_CR = DObj.ACCOUNTED_CR;
            // Added below segments for 860
            DiscountObj.SEGMENT5 = DObj.SEGMENT5;
            DiscountObj.SEGMENT1 = Label.OSM_BC;
            DiscountObj.SEGMENT2 = Label.OSM_RC;
            DiscountObj.SEGMENT3 = osmLabel.OSM_WS_Segment3__c;
            DiscountObj.SEGMENT6 = osmLabel.OSM_WS_Segment6__c;
            DiscountObj.SEGMENT7 = osmLabel.OSM_WS_Segment7__c;
            ListStageLine.add(DiscountObj);
            
            BalancingObj.SEGMENT4 = BObj.SEGMENT4;
            BalancingObj.ENTERED_DR = BObj.ENTERED_DR; 
            BalancingObj.ENTERED_CR = BObj.ENTERED_CR;
            BalancingObj.ACCOUNTED_DR = BObj.ACCOUNTED_DR;
            BalancingObj.ACCOUNTED_CR = BObj.ACCOUNTED_CR;
            // Added below segments for 860
            BalancingObj.SEGMENT5 = BObj.SEGMENT5;
            BalancingObj.SEGMENT1 = Label.OSM_BC;
            BalancingObj.SEGMENT2 = Label.OSM_RC;
            BalancingObj.SEGMENT3 = osmLabel.OSM_WS_Segment3__c;
            BalancingObj.SEGMENT6 = osmLabel.OSM_WS_Segment6__c;
            BalancingObj.SEGMENT7 = osmLabel.OSM_WS_Segment7__c;
            ListStageLine.add(BalancingObj);
            
            stageTabObj.JE_INV_INBND_STG_ROW_LINES = ListStageLine;
            system.debug('ListStageLine'+ListStageLine);            
            
            controlTObj.Order_Number = ConObj.Order_Number;
            controlTObj.BATCH_AMOUNT = ConObj.BATCH_AMOUNT;
            controlTObj.BATCH_ID = ConObj.BATCH_ID;
            controlTObj.CREATION_DATE = ConObj.CREATION_DATE;
            controlTObj.LAST_UPDATE_DATE = ConObj.LAST_UPDATE_DATE;
            controlTObj.LAST_UPDATED_BY = ConObj.LAST_UPDATED_BY;
            controlTObj.CREATED_BY = ConObj.CREATED_BY;
            
            //Populating service name from sender object
            senderObj.ServiceName = senObj.ServiceName;
            
            //Adding Static paramters
            stageTabObj.JOURNAL_ID = null;
            stageTabObj.CHART_OF_ACCOUNTS_ID = osmLabel.OSM_WS_Chart_Of_Account__c;
            //stageTabObj.IN_CREATED_BY = osmLabel.OSM_WS_In_Created_By__c;
            stageTabObj.ACTUAL_FLAG = osmLabel.OSM_WS_Actual_Flag__c;
            stageTabObj.USER_JE_CATEGORY_NAME = osmLabel.OSM_User_JE_Category_Name__c; //To Update
            
            if(reqWrap.isIntercompanyInvoice)
            {
                if(journalObj.CURRENCY_CODE == 'USD')
                {
                    stageTabObj.USER_JE_SOURCE_NAME = osmLabel.OSM_User_JE_Source_Name__c;
                }
                else if(journalObj.CURRENCY_CODE == 'CAD')
                {
                    stageTabObj.USER_JE_SOURCE_NAME = 'CA MRKTPLC';
                }
            }
            else
            {
                stageTabObj.USER_JE_SOURCE_NAME = osmLabel.OSM_User_JE_Source_Name__c;
            }
            
            //stageTabObj.USER_JE_SOURCE_NAME = osmLabel.OSM_User_JE_Source_Name__c;
            /* stageTabObj.SEGMENT1 = Label.OSM_BC;
stageTabObj.SEGMENT2 = Label.OSM_RC;
stageTabObj.SEGMENT3 = osmLabel.OSM_WS_Segment3__c;
stageTabObj.SEGMENT6 = osmLabel.OSM_WS_Segment6__c;
stageTabObj.SEGMENT7 = osmLabel.OSM_WS_Segment7__c; */
            stageTabObj.REFERENCE7 = null;
            stageTabObj.REFERENCE8 = null;
            stageTabObj.REFERENCE9 = null;
            //stageTabObj.REFERENCE10 = null;
            //if(reqWrap.isIntercompanyInvoice) comment for story: 183273
            //{
            stageTabObj.REFERENCE1 = osmLabel.OSM_REFERENCE1__c;
            stageTabObj.REFERENCE2 = osmLabel.OSM_REFERENCE2__c;
            stageTabObj.REFERENCE3 = osmLabel.OSM_REFERENCE3__c;
            stageTabObj.REFERENCE4 = null;
            stageTabObj.REFERENCE5 = osmLabel.OSM_REFERENCE5__c;
            stageTabObj.REFERENCE10 = osmLabel.OSM_REFERENCE10__c;
            //}
            
            //stageTabObj.STATUS = null;
            stageTabObj.SYSTEM_CODE = osmLabel.OSM_System_Code__c;
            
            controlTObj.SYSTEM_CODE = osmLabel.OSM_System_Code__c;
            controlTObj.STATUS = null;
            
            dataAreaObj.JE_INV_INBND_STG_ROW = stageTabObj;
            reqWrapperNew.DataArea = dataAreaObj;
            
            headerObj.JE_CTRL_TBL_ROW = controlTObj;
            
            senderObj.SenderID = label.OSM_Bolt_Source;
            headerObj.Sender =  senderObj;
            
            targetObj.TargetID = label.OSM_Bolt_Target;
            headerObj.Target = targetObj;       
            reqWrapperNew.Header = headerObj;
            
        }catch(Exception e){
            System.debug('>>>>>>>>>>>>>>>getLineNumber is:'+e.getLineNumber()+ 'Exception Message>>>is:'+e.getMessage()); 
        }   
        system.debug('reqWrapperNew'+reqWrapperNew);
        return reqWrapperNew;
    }       
    
}