/**********************************************************************
Name: FSL_CL_IA_LocationEnabledAPI
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose:    This class contains REST webservice method 
to send location enabled or not(Y/N) to Guidanz Mobile
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Rajashekar N      12/10/2019     INITIAL DEVELOPMENT                    
***********************************************************************/
@RestResource(urlMapping='/Assess/V01/CSS/IALocationEnabled/*')
global with sharing class FSL_CL_IA_LocationEnabledAPI {
    /*
** This method is used for   providing Location  Enabled(True/False) value  
*/
    @HttpPost
    global static void isIALocationEnabled() {
        System.debug('Web service isIALocationEnabled is initiated');
        // Variable Declaration
        FSL_CL_IA_LocationEnabledAPI_ResDataWrp resJSON = null;
        FSL_CL_IAUtility iAUtility = new FSL_CL_IAUtility();
        String jSONRequestBody = null;
        RestRequest requestAPI;
        RestResponse responseAPI;
        requestAPI = RestContext.request;
        responseAPI = RestContext.response;
        
        try {
            resJSON = iAUtility.validateIALocationEnabledRequest(requestAPI);
            System.debug('After Validations resJSON: '+resJSON);
            responseAPI.addHeader('Content-Type', 'application/json');
            responseAPI.responseBody = Blob.valueOf(JSON.serialize(resJSON));
            responseAPI.statusCode = 200;
            FSL_ApplicationLogger.insertIntegrationErrorLog(requestAPI, responseAPI, resJSON.Header.serviceName, resJSON.Header.status, resJSON.Header.serviceVersion, resJSON.Header.toolId, resJSON.Header.senderId);
            return;
        }
        catch(Exception ex) {
            FSL_ApplicationLogger.insertIntegrationErrorLog(requestAPI, responseAPI, resJSON.Header.serviceName, resJSON.Header.status, resJSON.Header.serviceVersion, resJSON.Header.toolId, resJSON.Header.senderId);
            System.debug('in catch of isIALocationEnabled of FSL_CL_IA_LocationEnabledAPI >>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
}