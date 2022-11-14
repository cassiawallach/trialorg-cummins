/**********************************************************************
Name: CSS_WS_TG_IACSSJob_V3
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This class contains REST webservice method 
            to create/update CSS Job using IA record
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        11/27/2017     INITIAL DEVELOPMENT                    
***********************************************************************/

@RestResource(urlMapping='/Assess/V03/CSS/IACSSJobCreation/*')
global with sharing class CSS_WS_TG_IACSSJob_V3 {

    /*
    ** This method is used to create/update CSS Job using IA record 
    **
    */
    @HttpPost
    global static void createUpdateIACSSJob() {
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into createUpdateIACSSJob webservice $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_IACSSJobCreationReqJSON_V3 reqJSON = null;
        CSS_WPR_TG_IACSSJobCreationResJSON_V3 resJSON = null;
        CSS_FN_Triage_V3 tgFNObj = new CSS_FN_Triage_V3();
        CSS_FN_Triage_V3.WrapperInput wrapperObj = new CSS_FN_Triage_V3.WrapperInput();
        String jSONRequestBody = null;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try{
            //Perform Validations here
            resJSON = tgFNObj.performValidationsForCreateUpdateCSSJob(req, wrapperObj);
            System.debug('After Validations resJSON:'+resJSON+' wrapperObj status>>>:'+wrapperObj.status+' wrapperObj IASNumber>>>:'+wrapperObj.IASNumber+' wrapperObj serviceName>>>:'+wrapperObj.serviceName);
            if(wrapperObj == null || wrapperObj.Status == null || wrapperObj.Status == 'Error'){
                res = css_utility.prepareRESTResponse(resJSON, 200);
                return;
            }
            System.debug('No Validation Error occured...');
            
            //Create/Update CSS Job using IAS Number
            resJSON = tgFNObj.createUpdateIACSSJob(wrapperObj);
            css_utility.prepareRESTResponse(resJSON, 200);
            return;
        }catch(Exception ex){
            System.debug('in catch of createUpdateIACSSJob webservice>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            wrapperObj=null;tgFNObj=null;reqJSON=null;jSONRequestBody=null;
        }
    }
    
}