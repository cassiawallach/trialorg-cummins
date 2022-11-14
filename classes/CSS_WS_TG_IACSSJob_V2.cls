/**********************************************************************
Name: CSS_WS_TG_IACSSJob_V2
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This class contains REST webservice method 
            to create a CSS Job using IA record
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        02/01/2017     INITIAL DEVELOPMENT                    
***********************************************************************/

@RestResource(urlMapping='/Assess/V02/CSS/IACSSJobCreation/*')
global with sharing class CSS_WS_TG_IACSSJob_V2 {

    /*
    ** This method is used for providing All Triage Data 
    *  i.e., Labour Hours with Components Data of Prioritize/Unprioritized
    *  Fault Codes
    **
    */
    @HttpPost
    global static void createIACSSJob() {
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into createIACSSJob webservice $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_IACSSJobCreationReqJSON_V2 reqJSON = null;
        CSS_WPR_TG_IACSSJobCreationResJSON_V2 resJSON = null;
        CSS_FN_Triage_V2 tgFNObj = new CSS_FN_Triage_V2();
        CSS_FN_Triage_V2.WrapperInput wrapperObj = new CSS_FN_Triage_V2.WrapperInput();
        String jSONRequestBody = null;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try{
            //Perform Validations here
            resJSON = tgFNObj.performValidationsForCreateCSSJob(req, wrapperObj);
            System.debug('After Validations resJSON:'+resJSON+' wrapperObj status>>>:'+wrapperObj.status+' wrapperObj IASNumber>>>:'+wrapperObj.IASNumber+' wrapperObj serviceName>>>:'+wrapperObj.serviceName);
            if(wrapperObj == null || wrapperObj.Status == null || wrapperObj.Status == 'Error'){
                res = css_utility.prepareRESTResponse(resJSON, 200);
                return;
            }
            System.debug('No Validation Error occured...');
            
            //Create CSS Job using IAS Number
            resJSON = tgFNObj.createIACSSJob(wrapperObj);
            css_utility.prepareRESTResponse(resJSON, 200);
            return;
        }catch(Exception ex){
            System.debug('in catch of createIACSSJob webservice>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            wrapperObj=null;tgFNObj=null;reqJSON=null;jSONRequestBody=null;
        }
    }
    
}