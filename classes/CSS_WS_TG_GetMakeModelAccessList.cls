/**********************************************************************
Name: CSS_WS_TG_GetMakeModelAccessList
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This class contains REST webservice method  
            to provide Make, Model, Access List 
                                                          
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        09/03/2016     INITIAL DEVELOPMENT                    
***********************************************************************/

@RestResource(urlMapping='/Assess/V01/CSS/GetMakeModelAccessList/*')
global with sharing class CSS_WS_TG_GetMakeModelAccessList {
  
    /*
    ** This method is used to get/return Make, Model, Access List based on ESN input
    **
    */
    @HttpPost
    global static void getMakeModelAccessList() {
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getMakeModelAccessList webservice $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_MakeModlAcsReqJSON2Apex reqJSON = null;
        CSS_WPR_TG_MakeModlAcsResJSON2Apex resJSON = null;
        CSS_FN_Triage tgFNObj = new CSS_FN_Triage();
        CSS_FN_Triage.WrapperInput wrapperObj = new CSS_FN_Triage.WrapperInput();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try{
            //Perform Validations here
            resJSON = tgFNObj.performValidationsForMakeModelAccess(req);
            System.debug('After Validations resJSON:'+resJSON);
            if(resJSON == null || resJSON.Header == null || resJSON.Header.Status=='Error'){
                css_utility.prepareRESTResponse(resJSON, 200);
                return;
            }
			System.debug('No Validation Error occured...resJSON.Header.ServiceName>>>>>>>>:'+resJSON.Header.ServiceName+' resJSON.Header.Status>>>:'+resJSON.Header.Status);
            
            resJSON = tgFNObj.getMakeModelAccessList(req);
            css_utility.prepareRESTResponse(resJSON, 200);
            return;
        }catch(Exception ex){
            System.debug('in catch of getMakeModelAccessList of CSS_WS_TG_GetMakeModelAccessList>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS03-Invalid JSON Format';
            resJSON = tgFNObj.prepareResponseWrapperForMakeModelAccess(wrapperObj);
            css_utility.prepareRESTResponse(resJSON, 400);
            return;
        } finally {
            wrapperObj = null;tgFNObj=null;reqJSON=null;
        }
    }
    
}