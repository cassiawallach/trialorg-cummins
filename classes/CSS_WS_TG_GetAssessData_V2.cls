/**********************************************************************
Name: CSS_WS_TG_GetAssessData_V2 
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This class contains Version2 REST webservice method 
            to provide Labour Hours with Components Data of 
			Prioritized/Unprioritized Fault Codes
                                                          
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        01/19/2017     INITIAL DEVELOPMENT                    
***********************************************************************/

@RestResource(urlMapping='/Assess/V02/CSS/GetAssessData/*')
global with sharing class CSS_WS_TG_GetAssessData_V2 {
  
    /*
    ** This method is used for providing All Triage Data 
    *  i.e., Labour Hours with Components Data of Prioritize/Unprioritized
    *  Fault Codes
    **
    */
    @HttpPost
    global static void getAssessData() {
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getAssessData webservice $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2 reqJSON = null;
        CSS_WPR_TG_GetAssessDataResJSON2Apex_V2 resJSON = null;
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2 tgPriFCsResJSON = null;
        CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2 tgLaborHrsDataResJSON = null;
        CSS_WPR_TG_FaultDetailsDataResJSON_V2 tgFaultDetailsDataResJSON = null;
        CSS_FN_Triage_V2 tgFNObj = new CSS_FN_Triage_V2();
        CSS_FN_Triage_V2.WrapperInput wrapperObj = new CSS_FN_Triage_V2.WrapperInput();
        String jSONRequestBody = null;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try{
            //Perform Validations here
            resJSON = tgFNObj.performValidations(req);
            System.debug('After Validations resJSON:'+resJSON);
            if(resJSON == null || resJSON.Header == null || resJSON.Header.Status=='Error'){
                //storing Req & Response Details
                //tgFNObj.saveReqResDetails(req, resJSON);
                res = css_utility.prepareRESTResponse(resJSON, 200);
                return;
            }
            System.debug('No Validation Error occured...resJSON.Header.ServiceName>>>>>>>>>>>>>>>>>>>>>>>>>>:'+resJSON.Header.ServiceName);
            
            //Executing the service out of 3 services based on given service name
            jSONRequestBody = req.requestBody.toString().trim();
            reqJSON = CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.parse(jSONRequestBody);
            if(reqJSON.Header.ServiceName == 'GetPrioritizedFC'){
                tgPriFCsResJSON = tgFNObj.getPrioritizedFCResponse(reqJSON);
                if(tgPriFCsResJSON != null && tgPriFCsResJSON.Header.Status != 'Error')
                	tgPriFCsResJSON.DataArea.IASNumber = tgFNObj.saveReqResDetails(reqJSON, jSONRequestBody, tgPriFCsResJSON);
                css_utility.prepareRESTResponse(tgPriFCsResJSON, 200);
            }else if(reqJSON.Header.ServiceName =='GetLaborHrsData'){
                tgLaborHrsDataResJSON = tgFNObj.getLaborHrsDataResponse(reqJSON);
                if(tgLaborHrsDataResJSON != null && tgLaborHrsDataResJSON.Header.Status != 'Error')
                	tgLaborHrsDataResJSON.DataArea.IASNumber = tgFNObj.saveReqResDetails(reqJSON, jSONRequestBody, tgLaborHrsDataResJSON);
                css_utility.prepareRESTResponse(tgLaborHrsDataResJSON, 200);
            }else if(reqJSON.Header.ServiceName =='GetAssessData'){
                tgFaultDetailsDataResJSON = tgFNObj.getAssessDataResponse(reqJSON);
                if(tgFaultDetailsDataResJSON != null && tgFaultDetailsDataResJSON.Header.Status != 'Error')
                	tgFaultDetailsDataResJSON.DataArea.IASNumber = tgFNObj.saveReqResDetails(reqJSON, jSONRequestBody, tgFaultDetailsDataResJSON);
                	System.debug('tgFaultDetailsDataResJSON.DataArea.IASNumber>>>>>>>>>>:'+tgFaultDetailsDataResJSON.DataArea.IASNumber);
                css_utility.prepareRESTResponse(tgFaultDetailsDataResJSON, 200);
            }
            return;
        }catch(Exception ex){
            System.debug('in catch of getAssessData webservice>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS11-CSS Internal Error';
            resJSON = tgFNObj.prepareResponseWrapper(wrapperObj);
            css_utility.prepareRESTResponse(resJSON, 400);
            //tgFNObj.saveReqResDetails(reqJSON, jSONRequestBody, resJSON);
            return;
        } finally {
            wrapperObj = null;tgFNObj=null;reqJSON=null;jSONRequestBody=null;
        }
    }
	
}