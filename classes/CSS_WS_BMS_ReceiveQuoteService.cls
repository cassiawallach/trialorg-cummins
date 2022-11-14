/**********************************************************************
Name: CSS_WS_BMS_ReceiveQuoteService 
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This class contains REST webservice method 
            to store Quote PDF files in CSS system getting BMS system
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        10/13/2016     INITIAL DEVELOPMENT                    
***********************************************************************/

@RestResource(urlMapping='/BMS/V03/CSS/SendQuotePDF/')
global class CSS_WS_BMS_ReceiveQuoteService {

    @HttpPost
    global static void updateQuote(){
        System.debug('################### in updateQuote method ################################');
        CSS_WPR_BMS_WOQTOutboundQuoteReqJSON reqJSON = null;
        CSS_WPR_BMS_WOQTOutboundQuoteResJSON resJSON = null;
        CSS_FN_BMS fnBMSObj = new CSS_FN_BMS();
        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            
            //Perform Validations
            resJSON = fnBMSObj.performValidations(req);
            System.debug('After Validations resJSON:'+resJSON);
            if(resJSON == null || resJSON.Header == null || resJSON.Header.Status=='Error'){
                css_utility.prepareRESTResponse(resJSON, 200);
                return;
            }
            System.debug('No Validation Error occured...resJSON.Header.Status>>>>>>>>>>>>>>>>>>>>>>>>>>:'+resJSON.Header.Status);
            
            //Executing the service 
            reqJSON = CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.parse(req.requestBody.toString().trim());
            resJSON = fnBMSObj.updateQuote(reqJSON);
            css_utility.prepareRESTResponse(resJSON, 200);
            return;
            
        }catch(Exception ex){
            System.debug('in catch updateQuote CSS_WS_BMS_ReceiveQuoteService>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            resJSON = fnBMSObj.prepareWOQTOutboundQuoteResWrapper('Fail', 'Quote insertion/updation failed', reqJSON.Header.Location.locationId);
            css_utility.prepareRESTResponse(resJSON, 400);
            return;
        }finally{
            reqJSON=null;resJSON=null;fnBMSObj=null;
        }
    }  
    
}