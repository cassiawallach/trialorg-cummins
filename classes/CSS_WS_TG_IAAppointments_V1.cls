/**********************************************************************
Name: CSS_WS_TG_IAAppointments_V1
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This class contains REST webservice method 
            to send IA Appointments to Guidanz Mobile
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        11/27/2017     INITIAL DEVELOPMENT                    
***********************************************************************/

@RestResource(urlMapping='/Assess/V01/CSS/IAAppointments/*')
global with sharing class CSS_WS_TG_IAAppointments_V1 {

    /*
    ** This method is used for providing IA Appointments 
    **
    */
    @HttpPost
    global static void getIAAppointments() {
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getIAAppointments webservice $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_IAAppointmentsResJSON_V1 resJSON = null;
        CSS_FN_Triage_V3 tgFNObj = new CSS_FN_Triage_V3();
        CSS_FN_Triage_V3.WrapperInput wrapperObj = new CSS_FN_Triage_V3.WrapperInput();
        String jSONRequestBody = null;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try{
            //Perform Validations here
            resJSON = tgFNObj.performValidationsForIAAppointments(req, wrapperObj);
            System.debug('After Validations resJSON:'+resJSON+' wrapperObj status>>>:'+wrapperObj.status+' wrapperObj serviceName>>>:'+wrapperObj.serviceName);
            if(wrapperObj == null || wrapperObj.Status == null || wrapperObj.Status == 'Error' || wrapperObj.Status == 'Success'){
                res = css_utility.prepareRESTResponse(resJSON, 200);
                return;
            }
            System.debug('No Validation Error occured...');
            
            //Create CSS Job using IAS Number
            resJSON = tgFNObj.getIAAppointments(wrapperObj);
            css_utility.prepareRESTResponse(resJSON, 200);
            return;
        }catch(Exception ex){
            System.debug('in catch of getIAAppointments of CSS_WS_TG_IAAppointments_V1>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            wrapperObj=null;tgFNObj=null;jSONRequestBody=null;
        }
    }
    
}