/**********************************************************************
Name: CSS_WS_TG_GetAssessData 
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This class contains Version1 REST webservice method 
            to provide Labour Hours with Components Data of 
			Prioritized/Unprioritized Fault Codes
                                                          
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        09/04/2016     INITIAL DEVELOPMENT                    
***********************************************************************/

@RestResource(urlMapping='/Assess/V01/CSS/GetAssessData/*')
global with sharing class CSS_WS_TG_GetAssessData {
  
    /*
    ** This method is used for providing All Triage Data 
    *  i.e., Labour Hours with Components Data of Prioritize/Unprioritized
    *  Fault Codes
    **
    */
    @HttpPost
    global static void getAssessData() {
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getAssessData webservice $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_GetAssesDataReqJSON2Apex reqJSON = null;
        CSS_WPR_TG_GetAssessDataResJSON2Apex resJSON = null;
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex tgPriFCsResJSON = null;
        CSS_WPR_TG_LaborHrsDataResJSON2Apex tgLaborHrsDataResJSON = null;
        CSS_WPR_TG_FaultDetailsDataResJSON2Apex tgFaultDetailsDataResJSON = null;
        CSS_FN_Triage tgFNObj = new CSS_FN_Triage();
        CSS_FN_Triage.WrapperInput wrapperObj = new CSS_FN_Triage.WrapperInput();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try{
            //Perform Validations here
            resJSON = tgFNObj.performValidations(req);
            System.debug('After Validations resJSON:'+resJSON);
            if(resJSON == null || resJSON.Header == null || resJSON.Header.Status=='Error'){
                res = css_utility.prepareRESTResponse(resJSON, 200);
                //storing Req & Response Details
                tgFNObj.storeReqResDetails(req, resJSON);
                return;
            }
            System.debug('No Validation Error occured...resJSON.Header.ServiceName>>>>>>>>>>>>>>>>>>>>>>>>>>:'+resJSON.Header.ServiceName);
            
            //Executing the service out of 3 services based on given service name
            reqJSON = CSS_WPR_TG_GetAssesDataReqJSON2Apex.parse(req.requestBody.toString().trim());
            //here below change resJSON.Header.ServiceName to reqJSON.Header.ServiceName ******************* ***********
            if(reqJSON.Header.ServiceName == 'GetPrioritizedFC'){
                tgPriFCsResJSON = tgFNObj.getPrioritizedFCResponse(reqJSON);
                css_utility.prepareRESTResponse(tgPriFCsResJSON, 200);
                tgFNObj.storeReqResDetails(req, tgPriFCsResJSON);
            }else if(reqJSON.Header.ServiceName =='GetLaborHrsData'){
                tgLaborHrsDataResJSON = tgFNObj.getLaborHrsDataResponse(reqJSON);
                css_utility.prepareRESTResponse(tgLaborHrsDataResJSON, 200);
                tgFNObj.storeReqResDetails(req, tgLaborHrsDataResJSON);
            }else if(reqJSON.Header.ServiceName =='GetAssessData'){
                tgFaultDetailsDataResJSON = tgFNObj.getAssessDataResponse(reqJSON);
                css_utility.prepareRESTResponse(tgFaultDetailsDataResJSON, 200);
                tgFNObj.storeReqResDetails(req, tgFaultDetailsDataResJSON);
            }
            return;
        }catch(Exception ex){
            System.debug('in catch getAssessData webservice>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS11-CSS Internal Error';
            resJSON = tgFNObj.prepareResponseWrapper(wrapperObj);
            css_utility.prepareRESTResponse(resJSON, 400);
            tgFNObj.storeReqResDetails(req, resJSON);
            return;
        } finally {
            wrapperObj = null;tgFNObj=null;reqJSON=null;
        }
    }
	
}