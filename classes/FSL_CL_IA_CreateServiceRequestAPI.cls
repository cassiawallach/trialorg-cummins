/**********************************************************************
Name: FSL_CL_IA_CreateServiceRequestAPI
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose:    This class contains REST webservice logic 
to process service request creation and send request number to Guidanz Mobile
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Rajashekar N      12/13/2019     INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSL_CL_IA_CreateServiceRequestAPI {
    
    public static void createIAServiceRequest() {
        /*  Variable Declaration */
        RestRequest requestAPI;
        RestResponse responseAPI;
        FSL_CL_IAUtility iAUtility = new FSL_CL_IAUtility();
        FSL_CL_IA_CreateServiceRequestAPIResJSON resJSON = null;
        /* Capturing user test request into requestAPI variable */
        requestAPI = RestContext.request;
        /* responseAPI Will be used to process response */ 
        responseAPI = RestContext.response;  
        try {
            resJSON = iAUtility.validateCreateServiceRequestAPI(requestAPI);
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
    
    //Below code is Temp for another way which should be deleted
    /*public static FSL_CL_IA_CreateServiceRequestAPIResJSON createIAServiceRequest(RestRequest requestAPI){
//Variable Declaration
FSL_CL_IAUtility iAUtility = new FSL_CL_IAUtility();
FSL_CL_IA_CreateServiceRequestAPIResJSON resJSON = null;
try{
resJSON = iAUtility.validateCreateServiceRequestAPI(requestAPI);
System.debug('After Validations resJSON: '+resJSON);
}
catch(Exception ex){
System.debug('in catch of isIALocationEnabled of FSL_CL_IA_LocationEnabledAPI >>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
}
return resJSON;
}*/
}