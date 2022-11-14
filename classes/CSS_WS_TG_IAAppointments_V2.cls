/**********************************************************************
Name: CSS_WS_TG_IAAppointments_V2
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    This class contains REST webservice method 
to send IA Appointments to Guidanz Mobile
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                      DATE                DETAIL                                 
1.0     Surender Madipeddi        01/29/2020       INITIAL DEVELOPMENT                    
***********************************************************************/

@RestResource(urlMapping='/Assess/V02/CSS/IAAppointments/*')
global with sharing class CSS_WS_TG_IAAppointments_V2 {
    
    /*
** This method is used for providing IA Appointments 
**
*/
    @HttpPost
    global static void getIAAppointments() {
        System.debug('$$$$$$$$ entered into getIAAppointments webservice $$$$$$$$$');
        RestRequest req = RestContext.request;
        CSS_FN_Triage_V4 tgFNObj;
        CSS_FN_Triage_V4.WrapperInput wrapperObj;
        FSL_CL_IA_GetServiceRequestAPI_ReqJSON reqJSON;
        FSL_CL_IA_GetServiceRequestAPI_ResJSON resJSON;
        String jSONRequestBody;
        try{
            //Performing validations hetre
            tgFNObj = new CSS_FN_Triage_V4();
            wrapperObj = new CSS_FN_Triage_V4.WrapperInput();
            jSONRequestBody = req.requestBody.toString().trim();
            //System.debug('jSONRequestBody:'+ jSONRequestBody);
            
            //Validate request body is null/blank/empty
            if(jSONRequestBody == null || jSONRequestBody == '' || String.isBlank(jSONRequestBody) || String.isEmpty(jSONRequestBody) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS01-Requested input is blank/invalid';
                resJSON = tgFNObj.prepareResWrapperForGetSerRequestAPI(wrapperObj);
                css_utility.prepareRESTResponse(resJSON,200);
                return;
            }
            
            reqJSON = FSL_CL_IA_GetServiceRequestAPI_ReqJSON.parse(jSONRequestBody);
            System.debug('**** after deserialize reqJSON **** '+reqJSON);
            //Validating Request Attributes are null or not
            if(reqJSON == null || reqJSON.Header == null || reqJSON.DataArea == null){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS01-Requested input is blank/invalid';
                resJSON = tgFNObj.prepareResWrapperForGetSerRequestAPI(wrapperObj);
                css_utility.prepareRESTResponse(resJSON,200);
                return;
            }
            
            //Validating request User location  is blank/null
            if(reqJSON.DataArea.userLocation == null || reqJSON.DataArea.userLocation.trim() == '' || String.isBlank(reqJSON.DataArea.userLocation) 
               || String.isEmpty(reqJSON.DataArea.userLocation) ){
                   wrapperObj.status = 'Error';
                   wrapperObj.returnCodeDescription = 'CSS05-UserLocation is blank/invalid';
                   resJSON = tgFNObj.prepareResWrapperForGetSerRequestAPI(wrapperObj);
                   css_utility.prepareRESTResponse(resJSON,200);
                   return;
               }
            
            //Here do logic for length of 11 chars
            String userLocFiltered = tgFNObj.getFilteredUserLocation(reqJSON.DataArea.UserLocation);
            System.debug('After validations userLocFiltered>>>>>>:'+userLocFiltered);
            if(userLocFiltered == null || userLocFiltered.trim() == '' || String.isBlank(userLocFiltered) || String.isEmpty(userLocFiltered)){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS05-UserLocation is blank/invalid';
                resJSON = tgFNObj.prepareResWrapperForGetSerRequestAPI(wrapperObj);
                css_utility.prepareRESTResponse(resJSON,200);
                return;
            }
            wrapperObj.UserLocation = userLocFiltered;
            
            List<Account> accList = new List<Account>([Select Id, Location__c, Enable_FSL__c, IA_CSSEnabled__c from Account where IA_CSSEnabled__c=true and Location__c=:userLocFiltered limit 1]);
            if(accList != null && accList.size()>0){
                wrapperObj.cssEnabled = 'Y';
            }else{
                wrapperObj.cssEnabled = 'N';
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS07-IAS location is not CSS enabled'; //new code
                resJSON = tgFNObj.prepareResWrapperForGetSerRequestAPI(wrapperObj);
                css_utility.prepareRESTResponse(resJSON,200);
                return;
            }
            
            //Redirecting here to Guidanz Classic (or) FSL
            List<ServiceTerritory> serviceTerritoryList = new List<ServiceTerritory>([Select Id, IsActive from ServiceTerritory where IsActive=true and Location_Code__c LIKE:userLocFiltered+'%' limit 1]);
            if(serviceTerritoryList != null && serviceTerritoryList.size()>0){
                FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest(); //FSL
            } else {
                List<Account> accList1 = new List<Account>([Select Id, Location__c,IsPartner, Enable_FSL__c, IA_CSSEnabled__c from Account where IA_CSSEnabled__c=true and IsPartner=true and Location__c=:userLocFiltered limit 1]);
                if(accList1 != null && accList1.size()>0){//CT1-84
                    FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest(); //FSL
                }else{
                	tgFNObj.getIAAppointments(); //Guidanz Classic
                }
            }
            
        }catch(Exception ex){
            System.debug('in catch of getIAAppointments of CSS_WS_TG_IAAppointments_V2>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.returnCodeDescription = 'CSS06-Invalid JSON Format';
            resJSON = tgFNObj.prepareResWrapperForGetSerRequestAPI(wrapperObj);
            css_utility.prepareRESTResponse(resJSON,200);
        }
    }
    
    
}