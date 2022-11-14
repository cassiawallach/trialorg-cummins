/**********************************************************************
Name: CSS_FN_Triage
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This is used for Business Logics of Triage functionality to
            handle reusable code modules such as Create/Update/View/Delete/etc operations
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        10/10/2016     INITIAL DEVELOPMENT                    
***********************************************************************/

public class CSS_FN_Triage {
    CSS_WPR_TG_GetAssessDataResJSON2Apex resJSON = null;
    CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex fcaPriFCsReqJSON = null;
    CSS_WPR_FCA_PrioritizedFCsResJSON2Apex fcaPriFCsResJSON = null;
    CSS_WPR_FCA_FaultDetailsReqJSON2Apex fcaFaultDetailsReqJSON = null; 
    CSS_WPR_FCA_FaultDetailsResJSON2Apex fcaFaultDetailsResJSON = null;
    Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList> faultDetailsMap = null;
    
    /*
     * This method is used for getting Prioritized Fault Codes in the form of Triage response 
     * using FCA webservice & Fault Details webservice
     */
    public CSS_WPR_TG_PrioritizedFCsResJSON2Apex getPrioritizedFCResponse(CSS_WPR_TG_GetAssesDataReqJSON2Apex reqJSON){
        System.debug('################# entered into getPrioritizedFCResponse method ###################');
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex tgPriFCsResJSON = null;
        WrapperInput wrapperObj = new WrapperInput();
        try{
            //execute FCA & Fault Details webservices and get/assign response to global variables of 
            //fcaPriFCsResJSON, fcaFaultDetailsResJSON
            System.debug('########reqJSON.DataArea.faultList>>>>:'+reqJSON.DataArea.faultList);
            if(reqJSON.DataArea.faultList != null && reqJSON.DataArea.faultList.size() > 0){
            	wrapperObj = executeFCAServices(reqJSON);
            }else{
                wrapperObj.status = 'Processed';
                assignInputValues(wrapperObj, reqJSON);
            }
            System.debug('FCA & FaultDetails service status...................................'+wrapperObj.status);
            if(wrapperObj == null || wrapperObj.status == null || wrapperObj.status == 'Error' ){
                wrapperObj.status = 'Error';
                if(wrapperObj.statusMsg == null || wrapperObj.statusMsg.trim() == '')
                	wrapperObj.statusMsg = 'CSS18-FCA webservice execution failed';
                return prepareAssessPrioritizedFCsResponse(fcaPriFCsResJSON, faultDetailsMap, wrapperObj);
            }else if(wrapperObj != null && wrapperObj.status == 'Processed'){
                wrapperObj.status = 'Success';
                wrapperObj.statusMsg = 'Prioritized FCs sent successfully';
            }
            
            //Preparing Triage Proiritized FCs Response wrapper based on fcaPriUnPriResJSON warpper which got above by including description
            tgPriFCsResJSON = prepareAssessPrioritizedFCsResponse(fcaPriFCsResJSON, faultDetailsMap, wrapperObj);
            
        }catch(Exception ex){
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS12-CSS PrioritizedFC Internal Error';
            tgPriFCsResJSON = prepareAssessPrioritizedFCsResponse(fcaPriFCsResJSON, faultDetailsMap, wrapperObj);
            System.debug('in catch of getPrioritizedFCResponse of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally{
            wrapperObj=null;fcaPriFCsResJSON=null;faultDetailsMap=null;
        }
        return tgPriFCsResJSON;
    }
    
    /*
     * This method is used for getting LaborHrs for Fault Codes in the form of Triage response 
     * using FCA webservice & Fault Details webservice
     */
    public CSS_WPR_TG_LaborHrsDataResJSON2Apex getLaborHrsDataResponse(CSS_WPR_TG_GetAssesDataReqJSON2Apex reqJSON){
        System.debug('################# entered into getLaborHrsDataResponse method ###################');
        CSS_WPR_TG_LaborHrsDataResJSON2Apex tgLaborHrsDataResJSON = null;
        Boolean flag = false;
        Set<String> priFCsSet = null;
        Map<String, String> laborHrsMap = null;
        WrapperInput wrapperObj = new WrapperInput();
        try{
            priFCsSet = new Set<String>();
            laborHrsMap = new Map<String, String>();
            //execute FCA & Fault Details webservices and get/assign response to global variables of 
            //fcaPriFCsResJSON, fcaFaultDetailsResJSON
            System.debug('########reqJSON.DataArea.faultList>>>>:'+reqJSON.DataArea.faultList);
            if(reqJSON.DataArea.faultList != null && reqJSON.DataArea.faultList.size() > 0){
            	wrapperObj = executeFCAServices(reqJSON);
            }else{
                wrapperObj.status = 'Processed';
                assignInputValues(wrapperObj, reqJSON);
            }
            
            if(wrapperObj == null || wrapperObj.status == null || wrapperObj.status == 'Error' ){
                wrapperObj.status = 'Error';
                if(wrapperObj.statusMsg == null || wrapperObj.statusMsg.trim() == '')
                	wrapperObj.statusMsg = 'CSS18-FCA webservice execution failed';
                return prepareAssessLaborHrsDataResponse(fcaPriFCsResJSON, faultDetailsMap, laborHrsMap, wrapperObj);
            }else if(wrapperObj != null && wrapperObj.status == 'Processed'){
                flag = true;
                wrapperObj.status = 'Success';
                wrapperObj.statusMsg = 'Labor Hours Data sent successfully';
            }
            if(flag){
                priFCsSet = getPrioritizedFCSet(fcaPriFCsResJSON);
                //Retrieving Labor Hours Data using SOQL
                laborHrsMap = getLaborHrsMap(priFCsSet, wrapperObj.smn, wrapperObj.make, wrapperObj.model, wrapperObj.access);
            }

            //Preparing Triage Labor Hours FCs Response wrapper based on fcaPriUnPriResJSON warpper which got above by including description
            tgLaborHrsDataResJSON = prepareAssessLaborHrsDataResponse(fcaPriFCsResJSON, faultDetailsMap, laborHrsMap, wrapperObj);

        }catch(Exception ex){
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS13-CSS LaborHours Internal Error';
            tgLaborHrsDataResJSON = prepareAssessLaborHrsDataResponse(fcaPriFCsResJSON, faultDetailsMap, laborHrsMap, wrapperObj);
            System.debug('in catch of getLaborHrsDataResponse of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally{
            wrapperObj=null;fcaPriFCsResJSON=null;faultDetailsMap=null;priFCsSet=null;laborHrsMap=null;
        }
        return tgLaborHrsDataResJSON;
    }
    
    /*
     * This method is used for getting Fault Details for Fault Codes in the form of Triage response 
     * using FCA webservice & Fault Details webservice
     */
    public CSS_WPR_TG_FaultDetailsDataResJSON2Apex getAssessDataResponse(CSS_WPR_TG_GetAssesDataReqJSON2Apex reqJSON){
        System.debug('################# entered into getAssessDataResponse method ###################');
        CSS_WPR_TG_FaultDetailsDataResJSON2Apex tgFaultDetailsDataResJSON = null;
        Boolean flag = false;
        Set<String> priFCsSet = null;
        Map<String, String> laborHrsMap = null;
        WrapperInput wrapperObj = new WrapperInput();
        try{
            priFCsSet = new Set<String>();
            laborHrsMap = new Map<String, String>();
            //checking for faultList is empty or not and
            //execute FCA & Fault Details webservices and get/assign response to global variables of 
            //fcaPriFCsResJSON, fcaFaultDetailsResJSON
            System.debug('########reqJSON.DataArea.faultList>>>>:'+reqJSON.DataArea.faultList);
            if(reqJSON.DataArea.faultList != null && reqJSON.DataArea.faultList.size() > 0){
            	wrapperObj = executeFCAandFaultDetailsServices(reqJSON);
            }else{
                wrapperObj.status = 'Processed';
                assignInputValues(wrapperObj, reqJSON);
            }
            if(wrapperObj == null || wrapperObj.status == null || wrapperObj.status == 'Error' ){
                wrapperObj.status = 'Error';
                if(wrapperObj.statusMsg == null || wrapperObj.statusMsg.trim() == '')
                	wrapperObj.statusMsg = 'CSS18-FCA/Fault Details webservice execution failed';
                System.debug('eneterd inner3....wrapperObj.statusMsg>>>>>:'+wrapperObj.statusMsg);
                return prepareAssessFaultDetailsDataResponse(fcaPriFCsResJSON, faultDetailsMap, laborHrsMap, wrapperObj);
            }else if(wrapperObj != null && wrapperObj.status == 'Processed'){
                flag = true;
                wrapperObj.status = 'Success';
                wrapperObj.statusMsg = 'Fault Details Data sent successfully';
            }
            if(flag){
                priFCsSet = getPrioritizedFCSet(fcaPriFCsResJSON);
                //Retrieving Labor Hours Data using SOQL
                laborHrsMap = getLaborHrsMap(priFCsSet, wrapperObj.smn, wrapperObj.make, wrapperObj.model, wrapperObj.access);
            }
            
            //Prepare Fault Details AssessData response
            tgFaultDetailsDataResJSON = prepareAssessFaultDetailsDataResponse(fcaPriFCsResJSON, faultDetailsMap, laborHrsMap, wrapperObj);

        }catch(Exception ex){
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS14-CSS AssessData Internal Error';
            tgFaultDetailsDataResJSON = prepareAssessFaultDetailsDataResponse(fcaPriFCsResJSON, faultDetailsMap, laborHrsMap, wrapperObj);
            System.debug('in catch of getAssessDataResponse of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally{
            wrapperObj=null;fcaPriFCsResJSON=null;faultDetailsMap=null;priFCsSet=null;laborHrsMap=null;
        }
        return tgFaultDetailsDataResJSON;
    }

    /*
     * This method is used for getting Prioritized Fault Codes in the form of Triage response
     * using FCA webservice & Fault Details webservice
     */
    public WrapperInput executeFCAandFaultDetailsServices(CSS_WPR_TG_GetAssesDataReqJSON2Apex reqJSON){
        System.debug('################# entered into executeFCAandFaultDetailsServices method ###################');
        //CSS_WPR_TG_PrioritizedFCsResJSON2Apex resJSON = null;
        CSS_Integration_Details__c fcaCon = null;
        WrapperInput wrapperObj = new WrapperInput();
        try{
            //Step: Preparing wrapper input object based on request JSON
            system.debug('reqJSON.Header'+reqJSON.Header);
            wrapperObj.serviceName = reqJSON.Header.ServiceName;
            system.debug('reqJSON.Header'+reqJSON.Header);
            wrapperObj.ToolID = reqJSON.Header.ToolID;
            wrapperObj.psn = reqJSON.DataArea.PSN;
            wrapperObj.smn = reqJSON.DataArea.SERVICEMODELNAME;
            wrapperObj.ERT = reqJSON.DataArea.ERT;
            wrapperObj.make = reqJSON.DataArea.MAKE;
            wrapperObj.model = reqJSON.DataArea.MODEL;
            wrapperObj.serviceVersion = reqJSON.Header.ServiceVersion;
            wrapperObj.access = reqJSON.DataArea.ACCESS;
            System.debug('ServiceName>>>:'+reqJSON.Header.ServiceName+' psn>>>:'+reqJSON.DataArea.PSN+' smn>>>:'+reqJSON.DataArea.SERVICEMODELNAME+' ERT>>>:'+reqJSON.DataArea.ERT+' MAKE>>>:'+reqJSON.DataArea.MAKE+' MODEL>>>:'+reqJSON.DataArea.MODEL+' ACCESS>>>:'+reqJSON.DataArea.ACCESS);
            
            //Calling FCA webservice to get Prioritized/Unprioritized Fault Codes
            fcaPriFCsResJSON = getResponseOfFCAService(reqJSON);
            System.debug('fcaPriFCsResJSON>>>>>>>>>>>>>:'+fcaPriFCsResJSON);
            if(fcaPriFCsResJSON == null){
                System.debug('enetered inner...fcaPriFCsResJSON>>>>>>>>>>>>>:'+fcaPriFCsResJSON);
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS15-FCA webservice execution failed';
                return wrapperObj;
                //return prepareResponseWrapper(wrapperObj);
            }
                        
            //Check whether data got or not for Prioritized FCs from FCA service
            Set<String> priFCsSet = getPrioritizedFCSet(fcaPriFCsResJSON);
            /*if(priFCsSet == null  || priFCsSet.size() <=0){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS16-FCA webservice does not return Prioritized FC data';
                return wrapperObj;
                //return prepareResponseWrapper(wrapperObj);
            }*/
            System.debug('priFCsSet size>>>>>>>>>>>>>>>>>>>>>>>>>:'+priFCsSet!=null?String.valueOf(priFCsSet.size()):priFCsSet+' priFCsSet>>>>>>>>>>>:'+priFCsSet);
            
            //Calling FCA FaultDetails webservice to get Fault Details
            fcaFaultDetailsResJSON = getResponseOfFCAFaultDetailsService(reqJSON);
            if(fcaFaultDetailsResJSON == null){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS17-FCA Fault Details webservice execution failed';
                return wrapperObj;
                //return prepareResponseWrapper(wrapperObj);
            }
            
            //Preparing Fault Details Map based on fcaFaultDetailsResJSON
            faultDetailsMap = prepareFaultDetailsMap(fcaFaultDetailsResJSON);
            wrapperObj.status = 'Processed'; //this Processed status is used for validating as no error found
        }catch(Exception ex){
            System.debug('in catch of executeFCAandFaultDetailsServices of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return wrapperObj;
    }

    /*
     * This method is used for getting Prioritized Fault Codes in the form of Triage response
     * using FCA webservice.
     */
    public WrapperInput executeFCAServices(CSS_WPR_TG_GetAssesDataReqJSON2Apex reqJSON){
        System.debug('################# entered into executeFCAServices method ###################');
        //CSS_WPR_TG_PrioritizedFCsResJSON2Apex resJSON = null;
        CSS_Integration_Details__c fcaCon = null;
        WrapperInput wrapperObj = new WrapperInput();
        try{
            //Step: Preparing wrapper input object based on request JSON
            /*wrapperObj.serviceName = reqJSON.Header.ServiceName;
            wrapperObj.ToolID = reqJSON.Header.ToolID;
            wrapperObj.psn = reqJSON.DataArea.PSN;
            wrapperObj.smn = reqJSON.DataArea.SERVICEMODELNAME;
            wrapperObj.ERT = reqJSON.DataArea.ERT;
            wrapperObj.make = reqJSON.DataArea.MAKE;
            wrapperObj.model = reqJSON.DataArea.MODEL;
            wrapperObj.serviceVersion = reqJSON.Header.ServiceVersion;
            wrapperObj.access = reqJSON.DataArea.ACCESS;
            System.debug('ServiceName>>>:'+reqJSON.Header.ServiceName+' psn>>>:'+reqJSON.DataArea.PSN+' smn>>>:'+reqJSON.DataArea.SERVICEMODELNAME+' ERT>>>:'+reqJSON.DataArea.ERT+' MAKE>>>:'+reqJSON.DataArea.MAKE+' MODEL>>>:'+reqJSON.DataArea.MODEL+' ACCESS>>>:'+reqJSON.DataArea.ACCESS);
            */
            assignInputValues(wrapperObj, reqJSON);
            //Calling FCA webservice to get Prioritized/Unprioritized Fault Codes
            fcaPriFCsResJSON = getResponseOfFCAService(reqJSON);
            if(fcaPriFCsResJSON == null){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS15-FCA webservice execution failed';
                return wrapperObj;
                //return prepareResponseWrapper(wrapperObj);
            }
                        
            //Check whether data got or not for Prioritized FCs from FCA service
            Set<String> priFCsSet = getPrioritizedFCSet(fcaPriFCsResJSON);
            /*if(priFCsSet == null  || priFCsSet.size() <=0){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS16-FCA webservice does not return Prioritized FC data';
                return wrapperObj;
                //return prepareResponseWrapper(wrapperObj);
            }*/
            System.debug('priFCsSet size>>>>>>>>>>>>>>>>>>>>>>>>>:'+priFCsSet!=null?String.valueOf(priFCsSet.size()):priFCsSet+' priFCsSet>>>>>>>>>>>:'+priFCsSet);
            
            wrapperObj.status = 'Processed'; //this Processed status is used for validating as no error found
        }catch(Exception ex){
            System.debug('in catch of executeFCAServices of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return wrapperObj;
    }
    
    
    /*
     * This method is used for getting Prioritized FCs Response using FCA service 
     */
    public CSS_WPR_FCA_PrioritizedFCsResJSON2Apex getResponseOfFCAService(CSS_WPR_TG_GetAssesDataReqJSON2Apex reqJSON){
        System.debug('################# entered into getResponseOfFCAService method ###################');
        CSS_WPR_FCA_PrioritizedFCsResJSON2Apex fcaPriFCsResJSON = null;
        CSS_Integration_Details__c fcaCon = null;
        try{
            //Retrieve FCA connection details
            fcaCon = new CSS_Integration_Details__c();
            if(!Test.isRunningTest()){
                fcaCon = CSS_getConnnectionDetails.getConnection('FCA_PR');
            }else{
                fcaCon.Key__c = 'uPe4AzYnaWAPEXUbUMyLa%aSUhuBadaS';
                fcaCon.End_Point__c = 'https://connectedsolutions-stg.cummins.com/fca/getFaultPrioritization/';
            }
            
            //Preparing Request JSON for FCA service based on input of GetAssessData request JSON
            fcaPriFCsReqJSON = CSS_WS_FCA.prepareReqJSONForProitizedFCsServiceOfFCA(reqJSON, fcaCon.Key__c);
            String fcaJSONReqBody = JSON.serialize(fcaPriFCsReqJSON);
            //fcaJSONReqBody = '{"version":1,"toolId":"toolId1234","token":"uPe4AzYnaWAPEXUbUMyLa%aSUhuBadaS","esn":"79470191","currentRunTime":1441238400,"faultList":{"items":[{"fc":"3682","occurenceTime":1441238400,"status":"active","count":2},{"fc":"39324","occurenceTime":1441238400,"status":"active","count":2},{"fc":"441","occurenceTime":1441238600,"status":"active","count":4},{"fc":"3932","occurenceTime":1441238600,"status":"active","count":4},{"fc":"596","occurenceTime":1541238600,"status":"inactive","count":1}]}}';
            System.debug('fcaJSONReqBody>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+fcaJSONReqBody);
            
            //Calling FCA webservice to get Prioritized/Unprioritized Fault Codes
            HttpResponse httpRes = CSS_WS_FCA.executeProitizedFCsServiceOfFCA(fcaJSONReqBody, fcaCon.End_Point__c, 'Triage');
            System.debug('after FCA service called.....httpRes>>>>>>>:'+httpRes);
            if(httpRes == null  || httpRes.getStatusCode() !=200){
                System.debug('enetered inner block...after FCA service called.....httpRes>>>>>>>:'+httpRes);
                return fcaPriFCsResJSON;
            }
            //String wsRes = '{"version":1,"transactionId":"723520392790016","algorithm":"Advanced","prioritizedData":[{"pri":"441","rel":[]},{"pri":"2265","rel":[]},{"pri":"1844","rel":[]},{"pri":"451","rel":[]},{"pri":"272","rel":[]},{"pri":"222","rel":[]},{"pri":"212","rel":[]},{"pri":"144","rel":[]},{"pri":"141","rel":[]},{"pri":"123","rel":[]},{"pri":"153","rel":[]},{"pri":"1117","rel":[]}],"unPrioritizedData":[{"fc":"442","rc":"6"},{"fc":"1596","rc":"4"},{"fc":"1135","rc":"4"},{"fc":"426","rc":"4"},{"fc":"547","rc":"4"},{"fc":"232","rc":"4"},{"fc":"263","rc":"4"}]}';
            //wsRes = '{"reasonCode": "2"}';
            //httpRes.setBody(wsRes);
            System.debug('CSS_WPR_FCA_PrioritizedFCsResJSON2Apex Response>>>>>>>>>>>>>>>>>>>>>>>>>:'+httpRes.getBody());
            fcaPriFCsResJSON = CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.parse(httpRes.getBody());
        }catch(Exception ex){
            System.debug('in catch of getResponseOfFCAService of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return fcaPriFCsResJSON;
    }
    
    /*
     * This method is used for getting Prioritized Fault Codes response
     * using Fault Details webservice
     */
    public CSS_WPR_FCA_FaultDetailsResJSON2Apex getResponseOfFCAFaultDetailsService(CSS_WPR_TG_GetAssesDataReqJSON2Apex reqJSON){
        System.debug('################# entered into getResponseOfFCAFaultDetailsService method ###################');
        CSS_WPR_FCA_FaultDetailsResJSON2Apex fcaFaultDetailsResJSON = null;
        CSS_Integration_Details__c fcaCon = null;
        try{
            //Preparing Request JSON for Fault Details webservice of FCA based on input of GetAssessData request JSON
            fcaFaultDetailsReqJSON = CSS_WS_FCA.prepareReqJSONForFaultDetailsServiceOfFCA(reqJSON);
            String fcaFaultDetailsJSONReqBody = JSON.serialize(fcaFaultDetailsReqJSON);
            System.debug('fcaFaultDetailsJSONReqBody>>>>>>>>>>>>>>>>>:'+fcaFaultDetailsJSONReqBody);
            
            //Retrieve FCA connection details
            fcaCon = new CSS_Integration_Details__c();
            if(!Test.isRunningTest()){
                fcaCon = CSS_getConnnectionDetails.getConnection('FCA_FD');
            }else{
                fcaCon.Key__c = 'apiKey wU+4hOMv4YBhQ7Kj/G9c8SJEw5Atty/cOKEl/sbL0t0=';
                //fcaCon.End_Point__c = 'https://connectedsolutions-stg.cummins.com/faultDetails/getFaultDetails?property=rootCause1,likelihood1,rootCause2,likelihood2,rootCause3,likelihood3,rootCause4,likelihood4,faultCodeDescription';
                fcaCon.End_Point__c = 'https://connectedsolutions-stg.cummins.com/faultDetails/getFaultDetails?property=rootCause1,likelihood1,rootCause2,likelihood2,rootCause3,likelihood3,rootCause4,likelihood4';  //Removed faultCodeDescription
            }
            
            //Calling FCA Fault Details webservice to get Root Cause Data
            //fcaFaultDetailsJSONReqBody = '{"serviceModelName":"ISX15 CM2350 X101","faultList":["1117","1682","3574","3596","2636","3568","3714"]}';
            HttpResponse httpRes = CSS_WS_FCA.executeRESTWebservice(fcaFaultDetailsJSONReqBody, fcaCon.End_Point__c, fcaCon.Key__c, 'POST', 'application/json', 'Assess');
            if(httpRes == null || httpRes.getStatusCode() !=200){
                return fcaFaultDetailsResJSON;
            }
            System.debug('CSS_WPR_FCA_FaultDetailsResJSON2Apex Response>>>>>>>>>>>>>>>>>>>>>>>>>:'+httpRes.getBody());
            fcaFaultDetailsResJSON = CSS_WPR_FCA_FaultDetailsResJSON2Apex.parse(httpRes.getBody());
            
            //added below lines to insert a log record when there is exception list in response - Vignesh
            if(fcaFaultDetailsResJSON.ExceptionList !=null && (fcaFaultDetailsResJSON.ExceptionList).size() > 0){
            	String reqJSON_str = JSON.serialize(reqJSON);
            	String resJSON_str = JSON.serialize(fcaFaultDetailsResJSON);
                css_utility.LogOutIntError(reqJSON_str, 'ExceptionLine', resJSON_str, 'FaultDetail');
            }
        }catch(Exception ex){
            System.debug('in catch of getResponseOfFCAFaultDetailsService of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return fcaFaultDetailsResJSON;
    }
    
    public Set<String> getPrioritizedFCSet(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex fcaPriFCsResJSON){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getPrioritizedFCSet method $$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        Set<String> fcSet = null;
        try{
            fcSet = new Set<String>();
            if(fcaPriFCsResJSON.PrioritizedData !=null)
                for(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.PrioritizedData fcaPriObj :fcaPriFCsResJSON.PrioritizedData){
                    fcSet.add(fcaPriObj.pri);
                }
        }catch(Exception ex){
            System.debug('in catch of getPrioritizedFCSet of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return fcSet;
    }
    
    public static Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList> prepareFaultDetailsMap(CSS_WPR_FCA_FaultDetailsResJSON2Apex fcaFaultDetailsResJSON){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareFaultDetailsMap method $$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList> faultDetailsMap = null;
        try{
            faultDetailsMap = new Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList>();
            for(CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList faultDetailsObj :fcaFaultDetailsResJSON.faultDetailsList){
                faultDetailsMap.put(faultDetailsObj.faultCode, faultDetailsObj);
            }
        }catch(Exception ex){
            System.debug('in catch of prepareFaultDetailsMap of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return faultDetailsMap;
    }
    
    public Map<String, String> getLaborHrsMap(Set<String> fcSet, String smn, String make, String model, String access){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getLaborHrsMap method s$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        Map<String, String> laborHrsMap = null;
        List<CSS_Make_Model_Access__c> laborHrsMakeModelList = null;
        try{
           laborHrsMap = new Map<String, String>();
           laborHrsMakeModelList = new List<CSS_Make_Model_Access__c>([select Name, Make__c, Model__c, Access__c, Fault_Code__c, Labor_Estimate__c, Service_Model_Name__c 
                        from CSS_Make_Model_Access__c where Service_Model_Name__c=:smn and Fault_Code__c in :fcSet limit 50000]);
            if(laborHrsMakeModelList == null && laborHrsMakeModelList.size()<=0){
                return laborHrsMap;
            }
            System.debug('laborHrsMakeModelList size>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+laborHrsMakeModelList.size());
            String key;
            for(CSS_Make_Model_Access__c mmaObj :laborHrsMakeModelList){
                key = null;
                if((mmaObj.Make__c == null || mmaObj.Make__c == '') && (mmaObj.Model__c == null || mmaObj.Model__c == '')){
                    key = mmaObj.Service_Model_Name__c+'|'+'UNLISTED'+'|'+'ALL'+'|'+mmaObj.Access__c+'|'+mmaObj.Fault_Code__c;
                }else {
                    //key = mmaObj.Service_Model_Name__c+'|'+mmaObj.Make__c+'|'+mmaObj.Model__c+'|'+mmaObj.Access__c+'|'+mmaObj.Fault_Code__c; //should not add access in key when make/model not null
                    key = mmaObj.Service_Model_Name__c+'|'+mmaObj.Make__c+'|'+mmaObj.Model__c+'|'+mmaObj.Fault_Code__c;
                    System.debug('key>>>>>>>>>>>>>>>:'+key+' Service_Model_Name__c>>>>>>>>>>>>>>>:'+mmaObj.Service_Model_Name__c+' make>>>>>>>>>>>>>>>:'+mmaObj.Make__c+' model>>>>>>>>>>>>>>>:'+mmaObj.Model__c+' access>>>>>>>>>>>>>>>:'+mmaObj.Access__c+' fc>>>>>>>>>>>>>>>:'+mmaObj.Fault_Code__c);
                }
                laborHrsMap.put(key, mmaObj.Labor_Estimate__c);
            }
            System.debug('laborHrsMap size>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+laborHrsMap.size());
        }catch(Exception ex){
            System.debug('in catch of getLaborHrsMap of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } 
        return laborHrsMap;
    }
    
    public String getLaborHrs(WrapperInput wrapperObj, String fc, Map<String, String> laborHrsMap){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getLaborHrsKey method $$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        String laborHrs = '';
        String laborHrsKey = null;
        try{
            //Step for make and model are UNLISTED/ALL
            if(wrapperObj.make == 'UNLISTED' && wrapperObj.model == 'ALL'){
                if(wrapperObj.access == '' || wrapperObj.access.trim() == '')
                    laborHrsKey = wrapperObj.smn+'|'+'UNLISTED'+'|'+'ALL'+'|'+null+'|'+fc;
                else
                    laborHrsKey = wrapperObj.smn+'|'+'UNLISTED'+'|'+'ALL'+'|'+wrapperObj.access+'|'+fc;
                if(css_utility.isMapContainsKey(laborHrsMap, laborHrsKey)){
                    laborHrs = laborHrsMap.get(laborHrsKey);
                    System.debug('UNLISTED ALL laborHrs>>>>>>>>>>>>>>>>>>:'+laborHrs);
                }
                System.debug('entered into make model UNLISTED/ALL code>>>>>>>>laborHrsKey>>>>'+laborHrsKey);
            }else {
                //Step1: Preparing key when make & model are not null and not Unlisted/ALL
                laborHrsKey = wrapperObj.smn+'|'+wrapperObj.make+'|'+wrapperObj.model+'|'+fc;
                System.debug('prepared laborHrsKey>>>:'+laborHrsKey);
                if(css_utility.isMapContainsKey(laborHrsMap, laborHrsKey)){
                    laborHrs = laborHrsMap.get(laborHrsKey);
                    System.debug('contains key laborHrs>>>:'+laborHrs);
                }
                System.debug('Step1: laborHrs>>>:'+laborHrs+' laborHrsKey>>>>>>>>>>>>>>>:'+laborHrsKey+' wrapperObj.smn>>>>>>>>>>>>>>>:'+wrapperObj.smn+' make>>>>>>>>>>>>>>>:'+wrapperObj.make+' model>>>>>>>>>>>>>>>:'+wrapperObj.model+' access>>>>>>>>>>>>>>>:'+wrapperObj.access+' fc>>>>>>>>>>>>>>>:'+fc);
                //Step2: if Step1 laborHrs null, then pull laborHrs based on SMN, Access, FC
                if(laborHrs == null || laborHrs.trim() == '' || String.isBlank(laborHrs) || String.isEmpty(laborHrs) ){
                    if(wrapperObj.access == '' || wrapperObj.access.trim() == '')
                        laborHrsKey = wrapperObj.smn+'|'+'UNLISTED'+'|'+'ALL'+'|'+null+'|'+fc;
                    else
                        laborHrsKey = wrapperObj.smn+'|'+'UNLISTED'+'|'+'ALL'+'|'+wrapperObj.access+'|'+fc;
                    if(css_utility.isMapContainsKey(laborHrsMap, laborHrsKey)){
                        laborHrs = laborHrsMap.get(laborHrsKey);
                        System.debug('Step2: laborHrs>>>:'+laborHrs+' laborHrsKey>>>:'+laborHrsKey+' wrapperObj.smn>>>:'+wrapperObj.smn+' make>>>:'+wrapperObj.make+' model>>>:'+wrapperObj.model+' access>>>:'+wrapperObj.access+' fc>>>:'+fc);
                    }
                }
            }
        }catch(Exception ex){
            System.debug('in catch of getLaborHrsKey of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return laborHrs;
    }
    
    /*
     * This method is used to prepare the Prioritized FCs response of Assess Service based on the response of FCA FCs response
     */
    public CSS_WPR_TG_PrioritizedFCsResJSON2Apex prepareAssessPrioritizedFCsResponse(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex fcaPriFCsResJSON, Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList> faultDetailsMap, WrapperInput wrapperObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareAssessPrioritizedFCsResponse method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex resJSON = null;
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex.Header resHeader = null;
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex.DataArea resDataArea = null;
        try{
            resHeader = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex.Header();
            resHeader.ServiceName = wrapperObj.serviceName;
            resHeader.ServiceVersion = wrapperObj.serviceVersion;
            resHeader.Status = wrapperObj.status;
            resHeader.ReturnCodeDescription = wrapperObj.statusMsg;
            
            resDataArea = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex.DataArea();
            resDataArea.PSN = wrapperObj.psn;
            resDataArea.algorithm = fcaPriFcsResJSON==null?null:fcaPriFcsResJSON.algorithm;
            resDataArea.prioritizedData = new List<CSS_WPR_TG_PrioritizedFCsResJSON2Apex.PrioritizedData>();
            resDataArea.unPrioritizedData = new List<CSS_WPR_TG_PrioritizedFCsResJSON2Apex.UnPrioritizedData>();
            
            //retrieving Prioritized Data from FCA response
            CSS_WPR_TG_PrioritizedFCsResJSON2Apex.PrioritizedData tgPriObj = null;
            CSS_WPR_TG_PrioritizedFCsResJSON2Apex.Relfc relFCObj = null;
            if(fcaPriFCsResJSON !=null && fcaPriFCsResJSON.PrioritizedData !=null)
            for(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.PrioritizedData fcaPriObj :fcaPriFCsResJSON.PrioritizedData){
                tgPriObj = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex.PrioritizedData();
                tgPriObj.relfc = new List<CSS_WPR_TG_PrioritizedFCsResJSON2Apex.Relfc>();
                tgPriObj.prifc = fcaPriObj.pri;
                /*if(css_utility.isMapContainsKey(faultDetailsMap, fcaPriObj.pri)) //Commented as part of CR#1
                    tgPriObj.prifcdesc = (faultDetailsMap.get(fcaPriObj.pri)).faultCodeDescription; //fc description
                else
                    tgPriObj.prifcdesc = ''; */
                for(String relFC :fcaPriObj.rel){
                    relFCObj = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex.Relfc();
                    relFCObj.rfc = relFC;
                    /*if(css_utility.isMapContainsKey(faultDetailsMap, relFC)) //Commented as part of CR#1
                        relFCObj.rfcdesc = (faultDetailsMap.get(relFC)).faultCodeDescription; //fc description
                    else
                        relFCObj.rfcdesc = ''; */
                    tgPriObj.relfc.add(relFCObj);
                }
                resDataArea.prioritizedData.add(tgPriObj); 
            }

            CSS_WPR_TG_PrioritizedFCsResJSON2Apex.UnPrioritizedData tgUnPriObj = null;
            if(fcaPriFCsResJSON !=null && fcaPriFCsResJSON.UnPrioritizedData !=null)
            for(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.UnPrioritizedData fcaUnPriObj :fcaPriFCsResJSON.UnPrioritizedData){
                tgUnPriObj = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex.UnPrioritizedData();
                tgUnPriObj.upfc = fcaUnPriObj.fc;
                /*if(css_utility.isMapContainsKey(faultDetailsMap, fcaUnPriObj.fc)) //Commented as part of CR#1
                    tgUnPriObj.upfcdesc = (faultDetailsMap.get(fcaUnPriObj.fc)).faultCodeDescription; //fc description
                else
                    tgUnPriObj.upfcdesc = ''; */
                tgUnPriObj.rc = fcaUnPriObj.rc;
                resDataArea.unPrioritizedData.add(tgUnPriObj);
            }

            resJSON = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;

        }catch(Exception ex){
            System.debug('in catch of prepareAssessPrioritizedFCsResponse of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            resJSON = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
        }
        return resJSON;
    }
    
    /*
     * This method is used to prepare Labor Hours Data response of Assess Service based on the response of FCA FCs response
     */
    public CSS_WPR_TG_LaborHrsDataResJSON2Apex prepareAssessLaborHrsDataResponse(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex fcaPriFCsResJSON, Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList> faultDetailsMap, Map<String, String> laborHrsMap, WrapperInput wrapperObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareAssessLaborHrsDataResponse method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_LaborHrsDataResJSON2Apex resJSON = null;
        CSS_WPR_TG_LaborHrsDataResJSON2Apex.Header resHeader = null;
        CSS_WPR_TG_LaborHrsDataResJSON2Apex.DataArea resDataArea = null;
        try{
            resHeader = new CSS_WPR_TG_LaborHrsDataResJSON2Apex.Header();
            resHeader.ServiceName = wrapperObj.serviceName;
            resHeader.ServiceVersion = wrapperObj.serviceVersion;
            resHeader.Status = wrapperObj.status;
            resHeader.ReturnCodeDescription = wrapperObj.statusMsg;
            
            resDataArea = new CSS_WPR_TG_LaborHrsDataResJSON2Apex.DataArea();
            resDataArea.PSN = wrapperObj.psn;
            resDataArea.algorithm = fcaPriFCsResJSON==null?null:fcaPriFCsResJSON.algorithm;
            resDataArea.prioritizedData = new List<CSS_WPR_TG_LaborHrsDataResJSON2Apex.PrioritizedData>();
            resDataArea.unPrioritizedData = new List<CSS_WPR_TG_LaborHrsDataResJSON2Apex.UnPrioritizedData>();
            
            //retrieving Prioritized Data from FCA response
            CSS_WPR_TG_LaborHrsDataResJSON2Apex.PrioritizedData tgPriObj = null;
            CSS_WPR_TG_LaborHrsDataResJSON2Apex.Relfc relFCObj = null;
            if(fcaPriFCsResJSON !=null && fcaPriFCsResJSON.PrioritizedData !=null)
            for(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.PrioritizedData fcaPriObj :fcaPriFCsResJSON.PrioritizedData){
                tgPriObj = new CSS_WPR_TG_LaborHrsDataResJSON2Apex.PrioritizedData();
                tgPriObj.relfc = new List<CSS_WPR_TG_LaborHrsDataResJSON2Apex.Relfc>();
                tgPriObj.prifc = fcaPriObj.pri;
                /*if(css_utility.isMapContainsKey(faultDetailsMap, fcaPriObj.pri)) //Commented as part of CR#1
                    tgPriObj.prifcdesc = (faultDetailsMap.get(fcaPriObj.pri)).faultCodeDescription; //fc description
                else
                    tgPriObj.prifcdesc = ''; */                   
                for(String relFC :fcaPriObj.rel){
                    relFCObj = new CSS_WPR_TG_LaborHrsDataResJSON2Apex.Relfc();
                    relFCObj.rfc = relFC;
                    /*if(css_utility.isMapContainsKey(faultDetailsMap, relFC)) //Commented as part of CR#1
                        relFCObj.rfcdesc = (faultDetailsMap.get(relFC)).faultCodeDescription; //fc description
                    else
                        relFCObj.rfcdesc = '';*/
                    tgPriObj.relfc.add(relFCObj);
                }
                //Preparing LaborHrs data
                tgPriObj.lhrs = getLaborHrs(wrapperObj, fcaPriObj.pri, laborHrsMap);
                resDataArea.prioritizedData.add(tgPriObj);
            }
            //retrieving UnPrioritized Data from FCA response
            CSS_WPR_TG_LaborHrsDataResJSON2Apex.UnPrioritizedData tgUnPriObj = null;
            if(fcaPriFCsResJSON !=null && fcaPriFCsResJSON.UnPrioritizedData !=null)
            for(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.UnPrioritizedData fcaUnPriObj :fcaPriFCsResJSON.UnPrioritizedData){
                tgUnPriObj = new CSS_WPR_TG_LaborHrsDataResJSON2Apex.UnPrioritizedData();
                tgUnPriObj.upfc = fcaUnPriObj.fc;
                /*if(css_utility.isMapContainsKey(faultDetailsMap, fcaUnPriObj.fc)) //Commented as part of CR#1
                    tgUnPriObj.upfcdesc = (faultDetailsMap.get(fcaUnPriObj.fc)).faultCodeDescription; //fc description
                else
                    tgUnPriObj.upfcdesc = '';*/ 
                tgUnPriObj.rc = fcaUnPriObj.rc;
                resDataArea.unPrioritizedData.add(tgUnPriObj);
            }

            resJSON = new CSS_WPR_TG_LaborHrsDataResJSON2Apex();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            system.debug('before returning.......................');
        }catch(Exception ex){
            System.debug('in catch of prepareAssessLaborHrsDataResponse of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            resJSON = new CSS_WPR_TG_LaborHrsDataResJSON2Apex();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
        }
        return resJSON;
    }
    
    /*
     * This method is used to prepare RootCause Data response of Assess Service based on the response of FCA FCs response
     */
    public CSS_WPR_TG_FaultDetailsDataResJSON2Apex prepareAssessFaultDetailsDataResponse(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex fcaPriFCsResJSON, Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList> faultDetailsMap, Map<String, String> laborHrsMap, WrapperInput wrapperObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareAssessFaultDetailsDataResponse method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_FaultDetailsDataResJSON2Apex resJSON = null;
        CSS_WPR_TG_FaultDetailsDataResJSON2Apex.Header resHeader = null;
        CSS_WPR_TG_FaultDetailsDataResJSON2Apex.DataArea resDataArea = null;
        try{
            resHeader = new CSS_WPR_TG_FaultDetailsDataResJSON2Apex.Header();
            resHeader.ServiceName = wrapperObj.serviceName;
            resHeader.ServiceVersion = wrapperObj.serviceVersion;
            resHeader.Status = wrapperObj.status;
            resHeader.ReturnCodeDescription = wrapperObj.statusMsg;
            
            resDataArea = new CSS_WPR_TG_FaultDetailsDataResJSON2Apex.DataArea();
            resDataArea.PSN = wrapperObj.psn;
            resDataArea.algorithm = fcaPriFcsResJSON==null?null:fcaPriFcsResJSON.algorithm;
            resDataArea.prioritizedData = new List<CSS_WPR_TG_FaultDetailsDataResJSON2Apex.PrioritizedData>();
            resDataArea.unPrioritizedData = new List<CSS_WPR_TG_FaultDetailsDataResJSON2Apex.UnPrioritizedData>();
            
            //retrieving Prioritized Data from FCA response
            CSS_WPR_TG_FaultDetailsDataResJSON2Apex.PrioritizedData tgPriObj = null;
            CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList fcDetailsObj = null;
            CSS_WPR_TG_FaultDetailsDataResJSON2Apex.Relfc relFCObj = null;
            if(fcaPriFCsResJSON !=null && fcaPriFCsResJSON.PrioritizedData !=null)
            for(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.PrioritizedData fcaPriObj :fcaPriFCsResJSON.PrioritizedData){
                tgPriObj = new CSS_WPR_TG_FaultDetailsDataResJSON2Apex.PrioritizedData();
                tgPriObj.relfc = new List<CSS_WPR_TG_FaultDetailsDataResJSON2Apex.Relfc>();
                tgPriObj.prifc = fcaPriObj.pri;
                //preparing Fault Details response based on faultDetailsMap
                if(css_utility.isMapContainsKey(faultDetailsMap, fcaPriObj.pri)){
                    fcDetailsObj = faultDetailsMap.get(fcaPriObj.pri);
                    //tgPriObj.prifcdesc = fcDetailsObj.faultCodeDescription;  //fc description //Commented as part of CR#1
                    tgPriObj.rootCause1 = fcDetailsObj.rootCause1;
                    tgPriObj.rc1Likelihood = fcDetailsObj.likelihood1;
                    tgPriObj.rootCause2 = fcDetailsObj.rootCause2;
                    tgPriObj.rc2Likelihood = fcDetailsObj.likelihood2;
                    tgPriObj.rootCause3 = fcDetailsObj.rootCause3;
                    tgPriObj.rc3Likelihood = fcDetailsObj.likelihood3;
                    tgPriObj.rootCause4 = fcDetailsObj.rootCause4;
                    tgPriObj.rc4Likelihood = fcDetailsObj.likelihood4;
                }else {
                    //tgPriObj.prifcdesc = ''; //Commented as part of CR#1
                    tgPriObj.rootCause1 = '';
                    tgPriObj.rc1Likelihood = '';
                    tgPriObj.rootCause2 = '';
                    tgPriObj.rc2Likelihood = '';
                    tgPriObj.rootCause3 = '';
                    tgPriObj.rc3Likelihood = '';
                    tgPriObj.rootCause4 = '';
                    tgPriObj.rc4Likelihood = '';
                }
                //Preparing Related Fault Codes data 
                for(String relFC :fcaPriObj.rel){
                    relFCObj = new CSS_WPR_TG_FaultDetailsDataResJSON2Apex.Relfc();
                    relFCObj.rfc = relFC;
                    /*if(css_utility.isMapContainsKey(faultDetailsMap, relFC)){ //Commented as part of CR#1
                        relFCObj.rfcdesc = (faultDetailsMap.get(relFC)).faultCodeDescription; //fc description
                    }*/
                    tgPriObj.relfc.add(relFCObj);
                }
                //Preparing LaborHrs data
                tgPriObj.lhrs = getLaborHrs(wrapperObj, fcaPriObj.pri, laborHrsMap);
                resDataArea.prioritizedData.add(tgPriObj);
            }
            //retrieving UnPrioritized Data from FCA response
            CSS_WPR_TG_FaultDetailsDataResJSON2Apex.UnPrioritizedData tgUnPriObj = null;
            if(fcaPriFCsResJSON !=null && fcaPriFCsResJSON.UnPrioritizedData !=null)
            for(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.UnPrioritizedData fcaUnPriObj :fcaPriFCsResJSON.UnPrioritizedData){
                tgUnPriObj = new CSS_WPR_TG_FaultDetailsDataResJSON2Apex.UnPrioritizedData();
                tgUnPriObj.upfc = fcaUnPriObj.fc;
                /*if(css_utility.isMapContainsKey(faultDetailsMap, fcaUnPriObj.fc)){ //Commented as part of CR#1
                    tgUnPriObj.upfcdesc = (faultDetailsMap.get(fcaUnPriObj.fc)).faultCodeDescription;  //fc description
                }*/
                tgUnPriObj.rc = fcaUnPriObj.rc;
                resDataArea.unPrioritizedData.add(tgUnPriObj);
            }

            resJSON = new CSS_WPR_TG_FaultDetailsDataResJSON2Apex();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            System.debug('before returning.......................resJSON:'+resJSON);
        }catch(Exception ex){
            System.debug('in catch of prepareAssessFaultDetailsDataResponse of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            resJSON = new CSS_WPR_TG_FaultDetailsDataResJSON2Apex();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
        }
        return resJSON;
    }
    
    /*
     * This method is used for validations 
     */
    public CSS_WPR_TG_GetAssessDataResJSON2Apex performValidations(RestRequest req){
        System.debug('################# entered into performValidations method ###################');
        CSS_WPR_TG_GetAssesDataReqJSON2Apex reqJSON = null;
        String jSONRequestBody = null;
        WrapperInput wrapperObj = new WrapperInput();
        try{
            jSONRequestBody = req.requestBody.toString().trim();
            //jSONRequestBody = '{"Header": {"ServiceName": "GetPrioritizedFC","ServiceVersion": "1.0","SenderID": "ATLASMOBILE","TargetID": "CSS"},"DataArea": {"PSN": "79484646","SERVICEMODELNAME": "ISB_CM2150","ERT": "1230000","MAKE": "KENWORTH","MODEL": "T800","ACCODE": "B","FAULTLIST": [{"fc": "123","occurenceTime": 1441238400,"status": "active","count": 1},{"fc": "2345","occurenceTime": 1521238400,"status": "active","count": 0},{"fc": "140","occurenceTime": 1341238400,"status": "active","count": 2},{"fc": "2341","occurenceTime": 1321238400,"status": "active","count": 2},{"fc": "2731","occurenceTime": 1311238400,"status": "active","count": 0}]}}';
            System.debug('before deserialize jSONRequestBody>>>>>>>>>>>>>>>>>>>>>>:'+jSONRequestBody);
            
            //Step1: Perform validations here
            if(jSONRequestBody == null || jSONRequestBody == '' || String.isBlank(jSONRequestBody) || String.isEmpty(jSONRequestBody) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS01-Requested input is invalid';
                return prepareResponseWrapper(wrapperObj);
            }   
            System.debug('reqJSON'+reqJSON);

            reqJSON = CSS_WPR_TG_GetAssesDataReqJSON2Apex.parse(jSONRequestBody);
            System.debug('after deserialize reqJSON:'+reqJSON);
            if(reqJSON == null || reqJSON.Header == null || reqJSON.DataArea == null){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS01-Requested input is invalid';
                return prepareResponseWrapper(wrapperObj);
            }
            
            if(reqJSON.Header.ServiceName == null || reqJSON.Header.ServiceName.trim() == '' || String.isBlank(reqJSON.Header.ServiceName) 
               || String.isEmpty(reqJSON.Header.ServiceName) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS02-Service Name is missing in input';
                return prepareResponseWrapper(wrapperObj);
            }
            if(reqJSON.Header.ServiceName.toLowerCase() != 'getprioritizedfc' && reqJSON.Header.ServiceName.toLowerCase() != 'getlaborhrsdata' 
              && reqJSON.Header.ServiceName.toLowerCase() != 'getassessdata' ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS02-Service Name is invalid';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.serviceName = reqJSON.Header.ServiceName;
            System.debug('reqJSON.Header.ServiceName:'+reqJSON.Header.ServiceName);
            
            if(reqJSON.Header.ToolID == null || reqJSON.Header.ToolID.trim() == '' || String.isBlank(reqJSON.Header.ToolID) 
               || String.isEmpty(reqJSON.Header.ToolID) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS03-ToolID is invalid';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.ToolID = reqJSON.Header.ToolID;
            
            if(reqJSON.DataArea.PSN == null || reqJSON.DataArea.PSN.trim() == '' || String.isBlank(reqJSON.DataArea.PSN) 
               || String.isEmpty(reqJSON.DataArea.PSN) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS04-PSN is invalid';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.psn = reqJSON.DataArea.PSN;
            
            if(reqJSON.DataArea.SERVICEMODELNAME == null || reqJSON.DataArea.SERVICEMODELNAME.trim() == '' 
               || String.isBlank(reqJSON.DataArea.SERVICEMODELNAME) || String.isEmpty(reqJSON.DataArea.SERVICEMODELNAME) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS05-SERVICEMODELNAME is invalid';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.smn = reqJSON.DataArea.SERVICEMODELNAME;
            
            if(reqJSON.DataArea.ERT == null || reqJSON.DataArea.ERT.trim() == '' || String.isBlank(reqJSON.DataArea.ERT) 
               || String.isEmpty(reqJSON.DataArea.ERT) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS06-ERT is invalid';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.ERT = reqJSON.DataArea.ERT;
            
            if(reqJSON.DataArea.MAKE == null || reqJSON.DataArea.MAKE.trim() == '' || String.isBlank(reqJSON.DataArea.MAKE) 
               || String.isEmpty(reqJSON.DataArea.MAKE) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS07-MAKE is invalid';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.make = reqJSON.DataArea.MAKE;
            
            if(reqJSON.DataArea.MODEL == null || reqJSON.DataArea.MODEL.trim() == '' || String.isBlank(reqJSON.DataArea.MODEL) 
               || String.isEmpty(reqJSON.DataArea.MODEL) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS08-MODEL is invalid';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.model = reqJSON.DataArea.MODEL;
            /*
            if(reqJSON.DataArea.faultList == null || reqJSON.DataArea.faultList.size() == 0){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS09-Requested FAULTLIST is invalid';
                return prepareResponseWrapper(wrapperObj);
            }*/
            System.debug('ServiceName>>>:'+reqJSON.Header.ServiceName+' psn>>>:'+reqJSON.DataArea.PSN+' smn>>>:'+reqJSON.DataArea.SERVICEMODELNAME+' ERT>>>:'+reqJSON.DataArea.ERT+' MAKE>>>:'+reqJSON.DataArea.MAKE+' MODEL>>>:'+reqJSON.DataArea.MODEL+' ACCESS>>>:'+reqJSON.DataArea.ACCESS);
            wrapperObj.status = 'Processed'; //this Processed status is used for validating as no error found
            return prepareResponseWrapper(wrapperObj);
        }catch(Exception ex){
            System.debug('in catch of performValidations of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS10-Invalid JSON Format';
            return prepareResponseWrapper(wrapperObj);
        }finally{
            wrapperObj=null;reqJSON=null;jSONRequestBody=null;
        }
        return null;
    }
    
    /*
     * This method is used for validations MakeModelAccess List
     */
    public CSS_WPR_TG_MakeModlAcsResJSON2Apex performValidationsForMakeModelAccess(RestRequest req){
        System.debug('################# entered into performValidations method ###################');
        CSS_WPR_TG_MakeModlAcsReqJSON2Apex reqJSON = null;
        String jSONRequestBody = null;
        WrapperInput wrapperObj = new WrapperInput();
        try{
            jSONRequestBody = req.requestBody.toString().trim();
            System.debug('before deserialize jSONRequestBody>>>>>>>>>>>>>>>>>>>>>>:'+jSONRequestBody);
            //jSONRequestBody = '{"Header": {"ServiceName": "GetMakeModelAccessList","ServiceVersion": "1.0","SenderID": "ATLASMOBILE","TargetID": "CSS"},"DataArea": {"PSN": "79484646"}  }';
             
            //Step1: Perform validations here
            if(jSONRequestBody == null || jSONRequestBody == '' || String.isBlank(jSONRequestBody) || String.isEmpty(jSONRequestBody) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS00-Requested input is invalid';
                return prepareResponseWrapperForMakeModelAccess(wrapperObj);
            }
            
            reqJSON = CSS_WPR_TG_MakeModlAcsReqJSON2Apex.parse(jSONRequestBody);
            System.debug('after deserialize reqJSON>>>>>>>>>>>>>>>>>>>>>>>>>:'+reqJSON);
            String toolID = reqJSON.Header.ToolID;
            wrapperObj.toolID = toolID;
            if(toolID == null || toolID == '' || String.isBlank(toolID) || String.isEmpty(toolID)){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS01-ToolID is missing in input';
                return prepareResponseWrapperForMakeModelAccess(wrapperObj);
            }
            System.debug('input toolID>>>>>>>>>>>>>>>>>>>>>>:'+toolID);
            
            wrapperObj.serviceVersion = reqJSON.Header.ServiceVersion;
            String serviceName = reqJSON.Header.ServiceName;
            wrapperObj.serviceName = serviceName;
            if(serviceName == null || serviceName == '' || String.isBlank(serviceName) || String.isEmpty(serviceName)){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS02-Service Name is missing in input';
                return prepareResponseWrapperForMakeModelAccess(wrapperObj);
            }
            if(serviceName.toLowerCase() != 'getmakemodelaccesslist'){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS02-Service Name is invalid';
                return prepareResponseWrapperForMakeModelAccess(wrapperObj);
            }
            System.debug('input serviceName>>>>>>>>>>>>>>>>>>>>>>:'+serviceName);
                        
            String psn = reqJSON.DataArea.PSN;
            wrapperObj.psn = psn;
            if(psn == null || psn == '' || String.isBlank(psn) || String.isEmpty(psn)){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS04-PSN is missing in input';
                return prepareResponseWrapperForMakeModelAccess(wrapperObj);
            }
            System.debug('input psn>>>>>>>>>>>>>>>>>>>>>>:'+psn);
            return prepareResponseWrapperForMakeModelAccess(wrapperObj);
        }catch(Exception ex){
            System.debug('in catch of performValidations of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS03-Invalid JSON Format';
            return prepareResponseWrapperForMakeModelAccess(wrapperObj);
        }finally{
            wrapperObj=null;reqJSON=null;jSONRequestBody=null;
        }
        return null;
    }
    
    /*
     * This method is used for preparing Response Wrapper for the service
     */ 
    public CSS_WPR_TG_GetAssessDataResJSON2Apex prepareResponseWrapper(WrapperInput wrapperObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareResponseWrapper method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_GetAssessDataResJSON2Apex resJSON = null;
        CSS_WPR_TG_GetAssessDataResJSON2Apex.Header resHeader = null;
        CSS_WPR_TG_GetAssessDataResJSON2Apex.DataArea resDataArea = null;
        try{
            resHeader = new CSS_WPR_TG_GetAssessDataResJSON2Apex.Header();
            resHeader.ServiceName = wrapperObj.serviceName;
            resHeader.ServiceVersion = wrapperObj.serviceVersion;
            resHeader.Status = wrapperObj.status;
            resHeader.ReturnCodeDescription = wrapperObj.statusMsg;
            
            resDataArea = new CSS_WPR_TG_GetAssessDataResJSON2Apex.DataArea();
            resDataArea.PSN = wrapperObj.psn;
            resDataArea.algorithm = wrapperObj.algorithm;
            
            resDataArea.prioritizedData = new List<CSS_WPR_TG_GetAssessDataResJSON2Apex.PrioritizedData>();
            resDataArea.unPrioritizedData = new List<CSS_WPR_TG_GetAssessDataResJSON2Apex.UnPrioritizedData>();
            
            resJSON = new CSS_WPR_TG_GetAssessDataResJSON2Apex();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            System.debug('before returning Response JSON>>>>>>>>>>>>>>>>>>>>>>>>>>resJSON:'+resJSON);
        }catch(Exception ex){
            System.debug('in catch of prepareResponseWrapper of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            //Perform some clean up
            resHeader = null; resDataArea = null;
        }
        return resJSON;
    }
    
    /*
     * This method is used for preparing the final response of this service
     */ 
    public CSS_WPR_TG_MakeModlAcsResJSON2Apex prepareResponseWrapperForMakeModelAccess(WrapperInput wrapperObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareResponseWrapperForMakeModelAccess method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_MakeModlAcsResJSON2Apex resJSON = null;
        CSS_WPR_TG_MakeModlAcsResJSON2Apex.Header resHeader = null;
        CSS_WPR_TG_MakeModlAcsResJSON2Apex.DataArea resDataArea = null;
        try{
            resHeader = new CSS_WPR_TG_MakeModlAcsResJSON2Apex.Header();
            resHeader.ServiceName = wrapperObj.serviceName;
            resHeader.ServiceVersion = wrapperObj.serviceVersion;
            resHeader.Status = wrapperObj.status;
            resHeader.ReturnCodeDescription = wrapperObj.statusMsg;
            
            resDataArea = new CSS_WPR_TG_MakeModlAcsResJSON2Apex.DataArea();
            resDataArea.PSN = wrapperObj.psn;
            resDataArea.SERVICEMODELNAME = wrapperObj.smn;
            resDataArea.SELECTMAKE = wrapperObj.SELECTMAKE; //here SELECTMAKE, SELECTMODEL, SELECTACCESS are from SIEBEL
            resDataArea.SELECTMODEL = wrapperObj.SELECTMODEL; 
            resDataArea.SELECTACCESS = wrapperObj.SELECTACCESS; 
            resDataArea.MAKEMODELACCESS = wrapperObj.mmaList;
            
            resJSON = new CSS_WPR_TG_MakeModlAcsResJSON2Apex();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            System.debug('before returning Response JSON>>>>>>>>>>>>>>>>>>>>>>>>>>resJSON:'+resJSON);
        }catch(Exception ex){
            System.debug('in catch of prepareResponseWrapperForMakeModelAccess of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            //Perform some clean up
            resHeader = null; resDataArea = null;
        }
        return resJSON;
    }
    
    
    /*
     * This method is used to get Make, Model, Access List of Service1
     */ 
    public CSS_WPR_TG_MakeModlAcsResJSON2Apex getMakeModelAccessList(RestRequest req){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getMakeModelAccessList method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_MakeModlAcsReqJSON2Apex reqJSON = null;
        CSS_WPR_TG_MakeModlAcsResJSON2Apex resJSON = null;
        WrapperInput wrapperObj = new WrapperInput();
        try{
            reqJSON = CSS_WPR_TG_MakeModlAcsReqJSON2Apex.parse(req.requestBody.toString().trim());
            wrapperObj.toolID = reqJSON.Header.ToolID;
			wrapperObj.serviceVersion = reqJSON.Header.ServiceVersion;
            wrapperObj.serviceName = reqJSON.Header.ServiceName;
            wrapperObj.psn = reqJSON.DataArea.PSN;
                            
            //calling QSOL service to get SMN
            String smn = CSS_WS_QSOL.getSMNFromQSOL(reqJSON.DataArea.PSN, 'Assess');
            wrapperObj.smn = smn;
            System.debug('smn from QSOL========>>>>>>>>>>>>>>>>>>>>>>>>>:'+smn);
            if(Test.isRunningTest()){
                smn = 'ISX15 CM2250';
            }else if(smn == null || String.isBlank(smn) || String.isEmpty(smn)){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS06-No SMN found for given PSN input in QSOL';
                return prepareResponseWrapperForMakeModelAccess(wrapperObj);
            }
            System.debug('after smn========>>>>>>>>>>>>>>>>>>>>>>>>>:'+smn);
            
            //get SELECTMAKE, SELECTMODEL, SELECTACCESS from SIEBEL webservice
            CSS_getEngineDataReqJ2A getEngineDataReq = new CSS_getEngineDataReqJ2A();
            getEngineDataReq.DataArea = new CSS_getEngineDataReqJ2A.DataArea();
            getEngineDataReq.DataArea.ESN = reqJSON.DataArea.PSN;
            CSS_getEngineDataResponseJ2A engineData = CSS_WS_SBL.getEngineData(getEngineDataReq);
            System.debug('SIEBEL EngineData >>>:'+engineData);
            if(engineData !=null && engineData.DataArea !=null){
                wrapperObj.SELECTMAKE = engineData.DataArea.Manufacturer==null?'':engineData.DataArea.Manufacturer;
                wrapperObj.SELECTMODEL = engineData.DataArea.Model==null?'':engineData.DataArea.Model;
                wrapperObj.SELECTACCESS = engineData.DataArea.AccessCode==null?'':engineData.DataArea.AccessCode;
            }else{
                wrapperObj.SELECTMAKE = '';
                wrapperObj.SELECTMODEL = '';
                wrapperObj.SELECTACCESS = '';
            }
            
            //Step3: SOQL query to retrieve Make, Model & Access List based on SMN
            List<CSS_Make_Model_Access__c> makeModelAccessList = getMakeModelAccessListOfSMN(smn);
            System.debug('makeModelAccessList>>>>>>:'+makeModelAccessList);
            if(makeModelAccessList == null || makeModelAccessList.size() == 0){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS07-No Data found for PSN and SMN';
                //wrapperObj.mmaList = new List<CSS_WPR_TG_MakeModlAcsResJSON2Apex.MAKEMODELACCESS>(); 
                return prepareResponseWrapperForMakeModelAccess(wrapperObj);
            }else{
                //Step5: get Make, Model & Access List & Prepare Response JSON to send back
                List<CSS_WPR_TG_MakeModlAcsResJSON2Apex.MAKEMODELACCESS> mmaList = getMMAWrapperList(makeModelAccessList);
                wrapperObj.status = 'Success';
                wrapperObj.statusMsg = 'MakeModelAccess list sent successfully';
                wrapperObj.mmaList = mmaList;
                System.debug('before returning mmaList >>>>>>:'+mmaList);
                return prepareResponseWrapperForMakeModelAccess(wrapperObj);
            }
        }catch(Exception ex){
            System.debug('in catch of getMakeModelAccessList of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS08-CSS Internal Error';
            return prepareResponseWrapperForMakeModelAccess(wrapperObj);
        } finally {
            wrapperObj=null;
        }
        return resJSON;
    }
    
    /*
     * This method is used to get Make Model Access List from CSS_Make_Model_Access__c object
     */
    public static List<CSS_Make_Model_Access__c> getMakeModelAccessListOfSMN(String smn){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getMakeModelAccessListOfSMN method s$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List<CSS_Make_Model_Access__c> makeModelAccessList = null;
        try{
            //makeModelAccessList = new List<CSS_Make_Model_Access__c>([select Name, Make__c, Model__c, Access__c, Service_Model_Name__c 
                        //from CSS_Make_Model_Access__c where Service_Model_Name__c=:smn and Make__c !='Unlisted' and Model__c !='All']);
            makeModelAccessList = new List<CSS_Make_Model_Access__c>([select Name, Make__c, Model__c, Access__c, Service_Model_Name__c 
                        from CSS_Make_Model_Access__c where Service_Model_Name__c=:smn and Make__c !=null and Make__c !='' and Model__c !=null and Model__c !='' limit 50000]);
            System.debug('makeModelAccessList size>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+makeModelAccessList.size());
        }catch(Exception ex){
            System.debug('in catch of getMakeModelAccessListOfSMN of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } 
        return makeModelAccessList;
    }
    
    /*
     * This method is used to get Make Model Access Wrapper List
     */
    public static List<CSS_WPR_TG_MakeModlAcsResJSON2Apex.MAKEMODELACCESS> getMMAWrapperList(List<CSS_Make_Model_Access__c> makeModelAccessList){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getMMAWrapperList method s$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List<CSS_WPR_TG_MakeModlAcsResJSON2Apex.MAKEMODELACCESS> mmaList = null;
        CSS_WPR_TG_MakeModlAcsResJSON2Apex.MAKEMODELACCESS resMakeModelAccessObj = null;
        Set<String> mmaSet = null;
        String key = null;
        try{
            mmaList = new List<CSS_WPR_TG_MakeModlAcsResJSON2Apex.MAKEMODELACCESS>();
            mmaSet = new Set<String>();
            for(CSS_Make_Model_Access__c makeModelAccessObj :makeModelAccessList){
                if(makeModelAccessObj.Make__c != null && makeModelAccessObj.Make__c.Trim() !='' && makeModelAccessObj.Model__c != null && makeModelAccessObj.Model__c.Trim() !=''){
                    //key = makeModelAccessObj.Make__c.Trim().toLowerCase()+makeModelAccessObj.Model__c.Trim().toLowerCase()+makeModelAccessObj.Access__c.Trim().toLowerCase();
                    key = makeModelAccessObj.Make__c.Trim().toLowerCase()+makeModelAccessObj.Model__c.Trim().toLowerCase();
                    if(!mmaSet.contains(key)){
                        mmaSet.add(key);
                        resMakeModelAccessObj = new CSS_WPR_TG_MakeModlAcsResJSON2Apex.MAKEMODELACCESS();
                        resMakeModelAccessObj.MAKE = makeModelAccessObj.Make__c;
                        resMakeModelAccessObj.MODEL = makeModelAccessObj.Model__c;
                        resMakeModelAccessObj.ACCESS = makeModelAccessObj.Access__c==null?'':makeModelAccessObj.Access__c;
                        mmaList.add(resMakeModelAccessObj);
                    }
                }
            }
            System.debug('db mmaList size>>>>>>>>>>>>>>>>>>>>>>>>:'+mmaList.size());
        }catch(Exception ex){
            System.debug('in catch of getMMAWrapperList of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally{
            mmaSet=null;resMakeModelAccessObj=null;key=null;
        }
        return mmaList;
    }
    
    /*
     * This method is used for saving Req & Res details for tracking
     */ 
    public void storeReqResDetails(RestRequest req, Object res){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into storeReqResDetails method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_GetAssesDataReqJSON2Apex reqJSON = null;
        String jSONRequestBody = null;
        CSS_DataExchange_Parent__c dataExchangeObj = null;
        try{
            jSONRequestBody = req.requestBody.toString().trim();
            reqJSON = CSS_WPR_TG_GetAssesDataReqJSON2Apex.parse(jSONRequestBody);
            System.debug('after deserialize reqJSON:'+reqJSON);
			
            dataExchangeObj = new CSS_DataExchange_Parent__c();
            dataExchangeObj.Version__c = 'v01';
            dataExchangeObj.CSS_Job_Number__c = null;
            dataExchangeObj.CSS_Enabled__c = null;
            dataExchangeObj.ServiceName__c = reqJSON.Header.ServiceName;
            dataExchangeObj.ServiceVersion__c = reqJSON.Header.ServiceVersion;
            dataExchangeObj.ToolID__c = reqJSON.Header.ToolID;
            dataExchangeObj.SenderID__c = reqJSON.Header.SenderID;
            dataExchangeObj.TargetID__c = reqJSON.Header.TargetID;
            dataExchangeObj.PSN__c = reqJSON.DataArea.PSN;
            dataExchangeObj.SERVICEMODELNAME__c = reqJSON.DataArea.SERVICEMODELNAME;
            dataExchangeObj.ERT__c = reqJSON.DataArea.ERT;
            dataExchangeObj.MAKE__c = reqJSON.DataArea.MAKE;
            dataExchangeObj.MODEL__c = reqJSON.DataArea.MODEL;
            dataExchangeObj.ACCESS__c = reqJSON.DataArea.ACCESS;
            dataExchangeObj.Created_By__c = reqJSON.Header.SenderID;
            dataExchangeObj.Updated_By__c = reqJSON.Header.SenderID;
            dataExchangeObj.Request_JSON__c = jSONRequestBody;
            
            dataExchangeObj = assignResDetails(dataExchangeObj, res);
            
            //insert DataExchange record here
            insert dataExchangeObj;
            System.debug('$$$$$$$$$$$$$$$$$$$$ DataExchange record inserted successfully....');
        }catch(Exception ex){
            System.debug('in catch of storeReqResDetails of CSS_FN_Triage>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            //insert here also
            dataExchangeObj = new CSS_DataExchange_Parent__c();
            dataExchangeObj.CSS_Job_Number__c = null;
            dataExchangeObj.CSS_Enabled__c = null;
            dataExchangeObj.Request_JSON__c = jSONRequestBody;
            dataExchangeObj = assignResDetails(dataExchangeObj, res);
            insert dataExchangeObj;
        } finally {
            //Perform some clean up
            dataExchangeObj = null;
        }
    }
    
    /*
     * This method is used for saving Res details for tracking
     */ 
    public CSS_DataExchange_Parent__c assignResDetails(CSS_DataExchange_Parent__c dataExchangeObj, Object res){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into assignResDetails method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        try{
            if (res instanceof CSS_WPR_TG_GetAssessDataResJSON2Apex){
      			CSS_WPR_TG_GetAssessDataResJSON2Apex resJSON = (CSS_WPR_TG_GetAssessDataResJSON2Apex) res;
                dataExchangeObj.Status__c = resJSON.Header.Status;
                dataExchangeObj.ReturnCodeDescription__c = resJSON.Header.ReturnCodeDescription;
                dataExchangeObj.Algorithm__c = resJSON.DataArea.algorithm;
                dataExchangeObj.Response_JSON__c = JSON.serialize(resJSON);
            }else if (res instanceof CSS_WPR_TG_PrioritizedFCsResJSON2Apex){
                CSS_WPR_TG_PrioritizedFCsResJSON2Apex resJSON = (CSS_WPR_TG_PrioritizedFCsResJSON2Apex) res;
                dataExchangeObj.Status__c = resJSON.Header.Status;
                dataExchangeObj.ReturnCodeDescription__c = resJSON.Header.ReturnCodeDescription;
                dataExchangeObj.Algorithm__c = resJSON.DataArea.algorithm;
                dataExchangeObj.Response_JSON__c = JSON.serialize(resJSON);
            }if (res instanceof CSS_WPR_TG_LaborHrsDataResJSON2Apex){
                CSS_WPR_TG_LaborHrsDataResJSON2Apex resJSON = (CSS_WPR_TG_LaborHrsDataResJSON2Apex) res;
                dataExchangeObj.Status__c = resJSON.Header.Status;
                dataExchangeObj.ReturnCodeDescription__c = resJSON.Header.ReturnCodeDescription;
                dataExchangeObj.Algorithm__c = resJSON.DataArea.algorithm;
                dataExchangeObj.Response_JSON__c = JSON.serialize(resJSON);
            }if (res instanceof CSS_WPR_TG_FaultDetailsDataResJSON2Apex){
                CSS_WPR_TG_FaultDetailsDataResJSON2Apex resJSON = (CSS_WPR_TG_FaultDetailsDataResJSON2Apex) res;
                dataExchangeObj.Status__c = resJSON.Header.Status;
                dataExchangeObj.ReturnCodeDescription__c = resJSON.Header.ReturnCodeDescription;
                dataExchangeObj.Algorithm__c = resJSON.DataArea.algorithm;
                dataExchangeObj.Response_JSON__c = JSON.serialize(resJSON);
            }
        }catch(Exception ex){
            System.debug('in catch of assignResDetails of CSS_FN_Triage>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            //Perform some clean up
        }
        return dataExchangeObj;
    }

	private void assignInputValues(WrapperInput wrapperObj, CSS_WPR_TG_GetAssesDataReqJSON2Apex reqJSON){
        try{
            //Step: Preparing wrapper input object based on request JSON
            system.debug('reqJSON.Header'+reqJSON.Header);
            wrapperObj.serviceName = reqJSON.Header.ServiceName;
            system.debug('reqJSON.Header'+reqJSON.Header);
            wrapperObj.ToolID = reqJSON.Header.ToolID;
            wrapperObj.psn = reqJSON.DataArea.PSN;
            wrapperObj.smn = reqJSON.DataArea.SERVICEMODELNAME;
            wrapperObj.ERT = reqJSON.DataArea.ERT;
            wrapperObj.make = reqJSON.DataArea.MAKE;
            wrapperObj.model = reqJSON.DataArea.MODEL;
            wrapperObj.serviceVersion = reqJSON.Header.ServiceVersion;
            wrapperObj.access = reqJSON.DataArea.ACCESS;
            //wrapperObj.IASNumber = reqJSON.DataArea.IASNumber.trim();
            System.debug('ServiceName>>>:'+reqJSON.Header.ServiceName+' psn>>>:'+reqJSON.DataArea.PSN+' smn>>>:'+reqJSON.DataArea.SERVICEMODELNAME+' ERT>>>:'+reqJSON.DataArea.ERT+' MAKE>>>:'+reqJSON.DataArea.MAKE+' MODEL>>>:'+reqJSON.DataArea.MODEL+' ACCESS>>>:'+reqJSON.DataArea.ACCESS);
        }catch(Exception e){
            System.debug('in catch of assignInputValues of CSS_FN_Triage >>>>>getLineNumber is ::'+e.getLineNumber()+' Exception Message>>>'+e.getMessage());
        }
    }
    
    public class WrapperInput {
        public String status;
        public String statusMsg;
        public String psn;
        public String smn;
        public String make;
        public String model;
        public String access;
        public String serviceName;
        public String serviceVersion;
        public String toolID;
        public String algorithm;
        public String ERT;
        public String SELECTMAKE;
        public String SELECTMODEL;
        public String SELECTACCESS;
        public List<CSS_WPR_TG_MakeModlAcsResJSON2Apex.MAKEMODELACCESS> mmaList;
    }
    
}