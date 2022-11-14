/**********************************************************************
Name: CSS_FN_Triage_V3
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is used for Business Logics of Triage functionality to
            handle reusable code modules such as Create/Update/View/Delete/etc operations
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
2.0     Surender M        11/09/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
public class CSS_FN_Triage_V3 {
    CSS_WPR_TG_GetAssessDataResJSON2Apex_V3 resJSON = null;
    CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex fcaPriFCsReqJSON = null;
    CSS_WPR_FCA_PrioritizedFCsResJSON2Apex fcaPriFCsResJSON = null;
    CSS_WPR_FCA_FaultDetailsReqJSON2Apex fcaFaultDetailsReqJSON = null;
    CSS_WPR_FCA_FaultDetailsResJSON2Apex fcaFaultDetailsResJSON = null;
    Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList> faultDetailsMap = null;
    
    /*
     * This method is used for getting Prioritized Fault Codes in the form of Triage response 
     * using FCA webservice & Fault Details webservice
     */
    public CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3 getPrioritizedFCResponse(CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 reqJSON){
        System.debug('################# entered into getPrioritizedFCResponse method ###################');
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3 tgPriFCsResJSON = null;
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
            System.debug('FCA service status...................................'+wrapperObj.status);
            if(wrapperObj == null || wrapperObj.status == null || wrapperObj.status == 'Error' ){
                wrapperObj.status = 'Error';
                if(wrapperObj.statusMsg == null || wrapperObj.statusMsg.trim() == '')
                wrapperObj.statusMsg = 'CSS18-FCA webservice execution failed';
                return prepareAssessPrioritizedFCsResponse(fcaPriFCsResJSON, faultDetailsMap, wrapperObj);
            }else if(wrapperObj != null && wrapperObj.status == 'Processed'){
                wrapperObj.status = 'Success';
                wrapperObj.statusMsg = 'Prioritized FCs sent successfully';
            }
            //logic for CSS enabled user or not
            //wrapperObj.CSSEnabled = checkCSSEnabled(reqJSON.DataArea.UserLocation);
            
            //Preparing Triage Proiritized FCs Response wrapper based on fcaPriUnPriResJSON warpper which got above by including description
            tgPriFCsResJSON = prepareAssessPrioritizedFCsResponse(fcaPriFCsResJSON, faultDetailsMap, wrapperObj);
            
        }catch(Exception ex){
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS12-CSS PrioritizedFC Internal Error';
            tgPriFCsResJSON = prepareAssessPrioritizedFCsResponse(fcaPriFCsResJSON, faultDetailsMap, wrapperObj);
            System.debug('in catch of getPrioritizedFCResponse of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally{
            wrapperObj=null;fcaPriFCsResJSON=null;faultDetailsMap=null;
        }
        return tgPriFCsResJSON;
    }
    
    /*
     * This method is used for getting LaborHrs for Fault Codes in the form of Triage response 
     * using FCA webservice & Fault Details webservice
     */
    public CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3 getLaborHrsDataResponse(CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 reqJSON){
        System.debug('################# entered into getLaborHrsDataResponse method ###################');
        CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3 tgLaborHrsDataResJSON = null;
        Boolean flag = false;
        Set<String> priFCsSet = null;
        Map<String, CSS_Make_Model_Access__c> laborHrsMap = null;
        WrapperInput wrapperObj = new WrapperInput();
        try{
            priFCsSet = new Set<String>();
            laborHrsMap = new Map<String, CSS_Make_Model_Access__c>();
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
                wrapperObj.status = 'Processing';
                wrapperObj.statusMsg = 'Labor Hours Data is under processing';
            }
            if(flag){
                priFCsSet = getPrioritizedFCSet(fcaPriFCsResJSON);
                //Retrieving Labor Hours Data using SOQL
                laborHrsMap = getLaborHrsMap(priFCsSet, wrapperObj.smn, wrapperObj.make, wrapperObj.model, wrapperObj.access);
            }
			//logic for CSS enabled user or not
            //wrapperObj.CSSEnabled = checkCSSEnabled(reqJSON.DataArea.UserLocation);
            
            //Preparing Triage Labor Hours FCs Response wrapper based on fcaPriUnPriResJSON warpper which got above by including description
            wrapperObj.status = 'Success';
            wrapperObj.statusMsg = 'Labor Hours Data sent successfully';
            tgLaborHrsDataResJSON = prepareAssessLaborHrsDataResponse(fcaPriFCsResJSON, faultDetailsMap, laborHrsMap, wrapperObj);

        }catch(Exception ex){
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS13-CSS LaborHours Internal Error';
            tgLaborHrsDataResJSON = prepareAssessLaborHrsDataResponse(fcaPriFCsResJSON, faultDetailsMap, laborHrsMap, wrapperObj);
            System.debug('in catch of getLaborHrsDataResponse of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally{
            wrapperObj=null;fcaPriFCsResJSON=null;faultDetailsMap=null;priFCsSet=null;laborHrsMap=null;
        }
        return tgLaborHrsDataResJSON;
    }
    
    /*
     * This method is used for getting Fault Details for Fault Codes in the form of Triage response 
     * using FCA webservice & Fault Details webservice
     */
    public CSS_WPR_TG_FaultDetailsDataResJSON_V3 getAssessDataResponse(CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 reqJSON){
        System.debug('################# entered into getAssessDataResponse method ###################');
        CSS_WPR_TG_FaultDetailsDataResJSON_V3 tgFaultDetailsDataResJSON = null;
        Boolean flag = false;
        Set<String> priFCsSet = null;
        Map<String, CSS_Make_Model_Access__c> laborHrsMap = null;
        WrapperInput wrapperObj = new WrapperInput();
        try{
            priFCsSet = new Set<String>();
            laborHrsMap = new Map<String, CSS_Make_Model_Access__c>();
            //checking for faultList is empty or not and
            //execute FCA & Fault Details webservices and get/assign response to global variables of 
            //fcaPriFCsResJSON, fcaFaultDetailsResJSON
            System.debug('########reqJSON.DataArea.faultList>>>>:'+reqJSON.DataArea.faultList);
            if(reqJSON.DataArea.faultList != null && reqJSON.DataArea.faultList.size() > 0){
            wrapperObj = executeFCAandFaultDetailsServices(reqJSON);
            }else{
                wrapperObj.status = 'Processing';
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
                wrapperObj.status = 'Processing';
                wrapperObj.statusMsg = 'Fault Details Data is under processing';
            }
            
            if(flag){
                priFCsSet = getPrioritizedFCSet(fcaPriFCsResJSON);
                //Retrieving Labor Hours Data using SOQL
                laborHrsMap = getLaborHrsMap(priFCsSet, wrapperObj.smn, wrapperObj.make, wrapperObj.model, wrapperObj.access);
            }
            //logic for CSS enabled user or not
            //wrapperObj.CSSEnabled = checkCSSEnabled(reqJSON.DataArea.UserLocation); //commented bcz inmplemented the same while storing IA record
            
            //Prepare Fault Details AssessData response
            wrapperObj.status = 'Success';
            wrapperObj.statusMsg = 'Fault Details Data sent successfully';
            tgFaultDetailsDataResJSON = prepareAssessFaultDetailsDataResponse(fcaPriFCsResJSON, faultDetailsMap, laborHrsMap, wrapperObj);

        }catch(Exception ex){
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS14-CSS AssessData Internal Error';
            tgFaultDetailsDataResJSON = prepareAssessFaultDetailsDataResponse(fcaPriFCsResJSON, faultDetailsMap, laborHrsMap, wrapperObj);
            System.debug('in catch of getAssessDataResponse of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally{
            wrapperObj=null;fcaPriFCsResJSON=null;faultDetailsMap=null;priFCsSet=null;laborHrsMap=null;
        }
        return tgFaultDetailsDataResJSON;
    }

    /*
     * This method is used for creating/Updating CSSJob using IA record
     * 
     */
    public CSS_WPR_TG_IACSSJobCreationResJSON_V3 createUpdateIACSSJob(WrapperInput wrapperObj){
        System.debug('################# entered into createUpdateIACSSJob of CSS_FN_Triage method ###################');
        CSS_WPR_TG_IACSSJobCreationResJSON_V3 resJSON = null;
        CSS_DataExchange_Parent__c deObj;
        try{
            resJSON = new CSS_WPR_TG_IACSSJobCreationResJSON_V3();
            List<CSS_DataExchange_Parent__c> deObjList = new List<CSS_DataExchange_Parent__c>(
                [Select Id, Name, SenderID__c, Version__c, CSS_Job_Number__c, CSS_Enabled__c, PSN__c, SERVICEMODELNAME__c, ERT__c, MAKE__c, MODEL__c, ACCESS__c, User_Location__c, 
                 User_Location_filtered__c, Customer_Company_Name__c, Complaint_Text__c, Request_JSON__c, Response_JSON__c from CSS_DataExchange_Parent__c where Name=:wrapperObj.IASNumber]);
            if(deObjList == null || deObjList.size()<=0){
                wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS06-IAS number does not exist in CSS';
            return prepareResponseWrapperForCSSJob(wrapperObj);
            }
            deObj = deObjList.get(0);
            
            if(deObj.CSS_Enabled__c != 'Y'){
                wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS07-IAS location is not CSS enabled';
            return prepareResponseWrapperForCSSJob(wrapperObj);
            }
            
            if( (wrapperObj.CSSJobNumber ==null || wrapperObj.CSSJobNumber.trim() =='') && deObj.CSS_Job_Number__c != null 
               && deObj.CSS_Job_Number__c.trim() != '' && String.isNotBlank(deObj.CSS_Job_Number__c) && String.isNotEmpty(deObj.CSS_Job_Number__c) ){
                wrapperObj.CSSJobNumber = deObj.CSS_Job_Number__c;
                wrapperObj.status = 'Error';
            	wrapperObj.statusMsg = 'CSS08-CSS Job already exists for the IA number';
                return prepareResponseWrapperForCSSJob(wrapperObj);
            }

            String userIdAdvancedRole = getAdvancedRoleUserId(deObj.SenderID__c, deObj.User_Location_filtered__c);
            System.debug('userIdAdvancedRole>>>>>>:'+userIdAdvancedRole);
            if(userIdAdvancedRole == null || userIdAdvancedRole.trim() == '' || String.isBlank(userIdAdvancedRole) 
               || String.isEmpty(userIdAdvancedRole) ){
                wrapperObj.status = 'Error';
                //wrapperObj.statusMsg = 'CSS09-UserId/UserLocation is invalid in CSS';
                wrapperObj.statusMsg = 'CSS09-UserLocation does not have Advanced Role in CSS';
                return prepareResponseWrapperForCSSJob(wrapperObj);
            }
            
            if(wrapperObj.CSSJobNumber !=null && wrapperObj.CSSJobNumber.trim() !=''){
                System.debug('in update block...cssJobNumber>>>:'+wrapperObj.CSSJobNumber);
                //Update CSS Job
                List<css_job_order__c> jobList = new List<css_job_order__c>([Select Id,Name,Customer_Name__c,Status__c,General_Symptoms__c,CSS_Job_Location_Code__c,Request_JSON__c,Response_JSON__c,OwnerId,CreatedById,LastModifiedById from css_job_order__c where Name=:wrapperObj.CSSJobNumber limit 1]);
                if(jobList.size()<=0){
                    wrapperObj.status = 'Error';
                    wrapperObj.statusMsg = 'CSS12-CSS Job in the request does not exist in CSS';
                    return prepareResponseWrapperForCSSJob(wrapperObj);
                }else{
                    if(jobList.get(0).Status__c !='Appointment'){
                        wrapperObj.status = 'Error';
                    	wrapperObj.statusMsg = 'CSS13-CSS Job in the request is not in apppointment status';
                    	return prepareResponseWrapperForCSSJob(wrapperObj);
                    }
                }
                String flagMsg = updateIACSSJob(deObj, userIdAdvancedRole, jobList.get(0));
                if(flagMsg !='Success'){
                    wrapperObj.status = 'Error';
                    wrapperObj.statusMsg = 'CSS11-CSS Internal Error'+'-'+flagMsg;
                    return prepareResponseWrapperForCSSJob(wrapperObj);
                }
                System.debug('CSS Job is updated successfully...cssJobNumber>>>:'+wrapperObj.CSSJobNumber);
                wrapperObj.status = 'Success';
                wrapperObj.statusMsg = 'CG02-CSS Job is updated successfully';
            }else{
                //Create CSS Job
                String cssJobNumber = createIACSSJob(deObj, userIdAdvancedRole);
                if(cssJobNumber == null){
                    wrapperObj.status = 'Error';
                    wrapperObj.statusMsg = 'CSS10-CSS Job Number is not generated';
                    return prepareResponseWrapperForCSSJob(wrapperObj);
                }
                wrapperObj.CSSJobNumber = cssJobNumber;
                System.debug('CSS Job Number is generated successfully...cssJobNumber>>>:'+cssJobNumber);
                
                //Update CSS Job Number in IA record
                deObj.CSS_Job_Number__c = cssJobNumber;
                update deObj;
                
                wrapperObj.status = 'Success';
                wrapperObj.statusMsg = 'CG01-CSS Job Number is generated successfully';
            }
            return prepareResponseWrapperForCSSJob(wrapperObj);
        }catch(Exception ex){
            System.debug('in catch of createUpdateIACSSJob of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS11-CSS Internal Error';
            return prepareResponseWrapperForCSSJob(wrapperObj);
        }finally{
            wrapperObj=null;
        }
        return resJSON;
    }
    
    /*
     * This method is used for creating CSS Job using IA record
     */ 
    public static String createIACSSJob(CSS_DataExchange_Parent__c deObj, String userIdAdvancedRole){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into createIACSSJob method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        css_job_order__c jobObj = null;
        List<Account> accountList;
        try{
            jobObj = new css_job_order__c();
            jobObj.ESN_IA__c = deObj.PSN__c;
            //jobObj.ESN__c = deObj.PSN__c;
            //jobObj.Service_Model__c = deObj.SERVICEMODELNAME__c;
            //jobObj.Make__c = deObj.MAKE__c;
            //jobObj.Model__c = deObj.MODEL__c;
            jobObj.Customer_Name__c = deObj.Customer_Company_Name__c;
            jobObj.General_Symptoms__c = deObj.Complaint_Text__c;
            jobObj.CSS_Job_Location_Code__c = deObj.User_Location_filtered__c; //User Location filtered
            jobObj.Request_JSON__c = deObj.Request_JSON__c;
            jobObj.Response_JSON__c = deObj.Response_JSON__c;
            //add user_location here
            accountList = new List<Account>([Select Id, Name from Account where Location__c=:deObj.User_Location_filtered__c limit 1]);
            if(accountList.size()>0)
                jobObj.JobLocation__c = (accountList.get(0)).Name;
            //jobObj.JobLocation__c = [Select Id, Name from Account where Location__c=:deObj.User_Location_filtered__c].Name;
            jobObj.Status__c = 'Intake';
            jobObj.OwnerId = userIdAdvancedRole;
            jobObj.CreatedById = userIdAdvancedRole;
            jobObj.LastModifiedById = userIdAdvancedRole;
            insert jobObj;

            return [Select Id, Name from css_job_order__c where Id=:jobObj.Id].Name;
        }catch(Exception ex){
            System.debug('in catch of createIACSSJob of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            jobObj=null;accountList=null;
        }
        return null;
    }
    
    /*
     * This method is used for creating CSS Job using IA record
     */ 
    public static String updateIACSSJob(CSS_DataExchange_Parent__c deObj, String userIdAdvancedRole, css_job_order__c jobObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into updateIACSSJob method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List<Account> accountList;
        String msg;
        try{
            jobObj.ESN_IA__c = deObj.PSN__c;
            //jobObj.ESN__c = deObj.PSN__c;
            //jobObj.Service_Model__c = deObj.SERVICEMODELNAME__c;
            //jobObj.Make__c = deObj.MAKE__c;
            //jobObj.Model__c = deObj.MODEL__c;
            jobObj.Customer_Name__c = deObj.Customer_Company_Name__c;
            jobObj.General_Symptoms__c = deObj.Complaint_Text__c;
            jobObj.CSS_Job_Location_Code__c = deObj.User_Location_filtered__c; //User Location filtered
            jobObj.Request_JSON__c = deObj.Request_JSON__c;
            jobObj.Response_JSON__c = deObj.Response_JSON__c;
            //add user_location here
            accountList = new List<Account>([Select Id, Name from Account where Location__c=:deObj.User_Location_filtered__c limit 1]);
            if(accountList.size()>0)
                jobObj.JobLocation__c = (accountList.get(0)).Name;
            //jobObj.JobLocation__c = [Select Id, Name from Account where Location__c=:deObj.User_Location_filtered__c].Name;
            jobObj.Status__c = 'Intake';
            jobObj.IsAppointment__c = 'No';
            //jobObj.OwnerId = userIdAdvancedRole;
            //jobObj.CreatedById = userIdAdvancedRole;
            //jobObj.LastModifiedById = userIdAdvancedRole;
            update jobObj;
            deObj.CSS_Job_Number__c = jobObj.Name;
            update deObj;
            msg = 'Success';
        }catch(Exception ex){
            System.debug('in catch of updateIACSSJob of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            msg = ex.getMessage()+'-'+ex.getLineNumber();
        } finally {
            jobObj=null;accountList=null;
        }
        return msg;
    }
    
    /*
     * This method is used for getting Prioritized Fault Codes in the form of Triage response
     * using FCA webservice & Fault Details webservice
     */
    public WrapperInput executeFCAandFaultDetailsServices(CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 reqJSON){
        System.debug('################# entered into executeFCAandFaultDetailsServices method ###################');
        //CSS_WPR_TG_PrioritizedFCsResJSON2Apex resJSON = null;
        CSS_Integration_Details__c fcaCon = null;
        WrapperInput wrapperObj = new WrapperInput();
        try{
            //Step: Preparing wrapper input object based on request JSON
            /*system.debug('reqJSON.Header'+reqJSON.Header);
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
            wrapperObj.IASNumber = reqJSON.DataArea.IASNumber.trim();
            System.debug('ServiceName>>>:'+reqJSON.Header.ServiceName+' psn>>>:'+reqJSON.DataArea.PSN+' smn>>>:'+reqJSON.DataArea.SERVICEMODELNAME+' ERT>>>:'+reqJSON.DataArea.ERT+' MAKE>>>:'+reqJSON.DataArea.MAKE+' MODEL>>>:'+reqJSON.DataArea.MODEL+' ACCESS>>>:'+reqJSON.DataArea.ACCESS);
            */
            assignInputValues(wrapperObj, reqJSON);
            
            //Calling FCA webservice to get Prioritized/Unprioritized Fault Codes
            fcaPriFCsResJSON = getResponseOfFCAService(reqJSON);
            System.debug('fcaPriFCsResJSON>>>>>>>>>>>>>:'+fcaPriFCsResJSON);
            if(fcaPriFCsResJSON == null){
                System.debug('enetered inner...fcaPriFCsResJSON>>>>>>>>>>>>>:'+fcaPriFCsResJSON);
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS15-FCA webservice execution failed';
                return wrapperObj;
            }
                        
            //Check whether data got or not for Prioritized FCs from FCA service
            Set<String> priFCsSet = getPrioritizedFCSet(fcaPriFCsResJSON);
            /*if(priFCsSet == null  || priFCsSet.size() <=0){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS16-FCA webservice does not return Prioritized FC data';
                return wrapperObj;
            }*/
            System.debug('priFCsSet size>>>>>>>>>>>>>>>>>>>>>>>>>:'+priFCsSet!=null?String.valueOf(priFCsSet.size()):priFCsSet+' priFCsSet>>>>>>>>>>>:'+priFCsSet);
            
            //Calling FCA FaultDetails webservice to get Fault Details
            fcaFaultDetailsResJSON = getResponseOfFCAFaultDetailsService(reqJSON);
            if(fcaFaultDetailsResJSON == null){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS17-FCA Fault Details webservice execution failed';
                return wrapperObj;
            }
            
            //Preparing Fault Details Map based on fcaFaultDetailsResJSON
            faultDetailsMap = prepareFaultDetailsMap(fcaFaultDetailsResJSON);
            wrapperObj.status = 'Processed'; //this Processed status is used for validating as no error found
        }catch(Exception ex){
            System.debug('in catch of executeFCAandFaultDetailsServices of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return wrapperObj;
    }

    /*
     * This method is used for getting Prioritized Fault Codes in the form of Triage response
     * using FCA webservice.
     */
    public WrapperInput executeFCAServices(CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 reqJSON){
        System.debug('################# entered into executeFCAServices method ###################');
        //CSS_WPR_TG_PrioritizedFCsResJSON2Apex resJSON = null;
        CSS_Integration_Details__c fcaCon = null;
        WrapperInput wrapperObj = new WrapperInput();
        try{
            //Step: Preparing wrapper input object based on request JSON
            /* wrapperObj.serviceName = reqJSON.Header.ServiceName;
            wrapperObj.ToolID = reqJSON.Header.ToolID;
            wrapperObj.psn = reqJSON.DataArea.PSN;
            wrapperObj.smn = reqJSON.DataArea.SERVICEMODELNAME;
            wrapperObj.ERT = reqJSON.DataArea.ERT;
            wrapperObj.make = reqJSON.DataArea.MAKE;
            wrapperObj.model = reqJSON.DataArea.MODEL;
            wrapperObj.serviceVersion = reqJSON.Header.ServiceVersion;
            wrapperObj.access = reqJSON.DataArea.ACCESS;
            wrapperObj.IASNumber = reqJSON.DataArea.IASNumber.trim();
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
            System.debug('in catch of executeFCAServices of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return wrapperObj;
    }
    
    
    /*
     * This method is used for getting Prioritized FCs Response using FCA service 
     */
    public CSS_WPR_FCA_PrioritizedFCsResJSON2Apex getResponseOfFCAService(CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 reqJSON){
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
            fcaPriFCsReqJSON = CSS_WS_FCA_V3.prepareReqJSONForProitizedFCsServiceOfFCA(reqJSON, fcaCon.Key__c);
            String fcaJSONReqBody = JSON.serialize(fcaPriFCsReqJSON);
            //fcaJSONReqBody = '{"version":1,"toolId":"toolId1234","token":"uPe4AzYnaWAPEXUbUMyLa%aSUhuBadaS","esn":"79470191","currentRunTime":1441238400,"faultList":{"items":[{"fc":"3682","occurenceTime":1441238400,"status":"active","count":2},{"fc":"39324","occurenceTime":1441238400,"status":"active","count":2},{"fc":"441","occurenceTime":1441238600,"status":"active","count":4},{"fc":"3932","occurenceTime":1441238600,"status":"active","count":4},{"fc":"596","occurenceTime":1541238600,"status":"inactive","count":1}]}}';
            System.debug('fcaJSONReqBody>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+fcaJSONReqBody);
            
            //Calling FCA webservice to get Prioritized/Unprioritized Fault Codes
            HttpResponse httpRes = CSS_WS_FCA_V3.executeProitizedFCsServiceOfFCA(fcaJSONReqBody, fcaCon.End_Point__c, 'Triage');
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
            System.debug('in catch of getResponseOfFCAService of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return fcaPriFCsResJSON;
    }
    
    /*
     * This method is used for getting Prioritized Fault Codes response
     * using Fault Details webservice
     */
    public CSS_WPR_FCA_FaultDetailsResJSON2Apex getResponseOfFCAFaultDetailsService(CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 reqJSON){
        System.debug('################# entered into getResponseOfFCAFaultDetailsService method ###################');
        CSS_WPR_FCA_FaultDetailsResJSON2Apex fcaFaultDetailsResJSON = null;
        CSS_Integration_Details__c fcaCon = null;
        try{
            //Preparing Request JSON for Fault Details webservice of FCA based on input of GetAssessData request JSON
            fcaFaultDetailsReqJSON = CSS_WS_FCA_V3.prepareReqJSONForFaultDetailsServiceOfFCA(reqJSON);
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
            HttpResponse httpRes = CSS_WS_FCA_V3.executeRESTWebservice(fcaFaultDetailsJSONReqBody, fcaCon.End_Point__c, fcaCon.Key__c, 'POST', 'application/json', 'Assess');
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
            System.debug('in catch of getResponseOfFCAFaultDetailsService of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
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
            System.debug('in catch of getPrioritizedFCSet of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
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
            System.debug('in catch of prepareFaultDetailsMap of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return faultDetailsMap;
    }
    
    public Map<String, CSS_Make_Model_Access__c> getLaborHrsMap(Set<String> fcSet, String smn, String make, String model, String access){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getLaborHrsMap method s$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        Map<String, CSS_Make_Model_Access__c> laborHrsMap = null;
        List<CSS_Make_Model_Access__c> laborHrsMakeModelList = null;
        try{
           laborHrsMap = new Map<String, CSS_Make_Model_Access__c>();
           //String iaRecTypeId = [Select Id, Name from RecordType where Name = 'IAData' limit 1].Id;
           laborHrsMakeModelList = new List<CSS_Make_Model_Access__c>([select Name, Make__c, Model__c, Access__c, Fault_Code__c, LessThanTwoLhr__c, 
                                   TwoToFourLhr__c, FourToSixLhr__c, MoreThanSixLhr__c, Labor_Estimate__c, Service_Model_Name__c 
                        from CSS_Make_Model_Access__c where Service_Model_Name__c=:smn and Fault_Code__c in :fcSet and RecordType.Name='IAData' limit 50000]);
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
                    //System.debug('key>>>>>>>>>>>>>>>:'+key+' Service_Model_Name__c>>>>>>>>>>>>>>>:'+mmaObj.Service_Model_Name__c+' make>>>>>>>>>>>>>>>:'+mmaObj.Make__c+' model>>>>>>>>>>>>>>>:'+mmaObj.Model__c+' access>>>>>>>>>>>>>>>:'+mmaObj.Access__c+' fc>>>>>>>>>>>>>>>:'+mmaObj.Fault_Code__c);
                }
                laborHrsMap.put(key, mmaObj);
            }
            System.debug('laborHrsMap size>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+laborHrsMap.size());
        }catch(Exception ex){
            System.debug('in catch of getLaborHrsMap of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } 
        return laborHrsMap;
    }
    
    public CSS_Make_Model_Access__c getLaborHrs(WrapperInput wrapperObj, String fc, Map<String, CSS_Make_Model_Access__c> laborHrsMap){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getLaborHrsKey method $$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        //String laborHrs = '';
        CSS_Make_Model_Access__c mmaObj = null;
        String laborHrsKey = null;
        try{
            //Step for make and model are UNLISTED/ALL
            if(wrapperObj.make == 'UNLISTED' && wrapperObj.model == 'ALL'){
                if(wrapperObj.access == '' || wrapperObj.access.trim() == '')
                    laborHrsKey = wrapperObj.smn+'|'+'UNLISTED'+'|'+'ALL'+'|'+null+'|'+fc;
                else
                    laborHrsKey = wrapperObj.smn+'|'+'UNLISTED'+'|'+'ALL'+'|'+wrapperObj.access+'|'+fc;
                if(css_utility.isMapContainsKey(laborHrsMap, laborHrsKey)){
                    mmaObj = laborHrsMap.get(laborHrsKey);
                    //System.debug('UNLISTED ALL laborHrs>>>>>>>>>>>>>>>>>>:'+laborHrs);
                }
                System.debug('entered into make model UNLISTED/ALL code>>>>>>>>laborHrsKey>>>>'+laborHrsKey);
            }else {
                //Step1: Preparing key when make & model are not null and not Unlisted/ALL
                laborHrsKey = wrapperObj.smn+'|'+wrapperObj.make+'|'+wrapperObj.model+'|'+fc;
                System.debug('prepared laborHrsKey>>>:'+laborHrsKey);
                if(css_utility.isMapContainsKey(laborHrsMap, laborHrsKey)){
                    mmaObj = laborHrsMap.get(laborHrsKey);
                    //System.debug('contains key laborHrs>>>:'+laborHrs);
                }
                //System.debug('Step1: laborHrs>>>:'+laborHrs+' laborHrsKey>>>>>>>>>>>>>>>:'+laborHrsKey+' wrapperObj.smn>>>>>>>>>>>>>>>:'+wrapperObj.smn+' make>>>>>>>>>>>>>>>:'+wrapperObj.make+' model>>>>>>>>>>>>>>>:'+wrapperObj.model+' access>>>>>>>>>>>>>>>:'+wrapperObj.access+' fc>>>>>>>>>>>>>>>:'+fc);
                //Step2: if Step1 laborHrs null, then pull laborHrs based on SMN, Access, FC
                if( mmaObj==null || ((mmaObj.LessThanTwoLhr__c == null || mmaObj.LessThanTwoLhr__c == '') && (mmaObj.TwoToFourLhr__c == null || mmaObj.TwoToFourLhr__c == '') && 
                   (mmaObj.FourToSixLhr__c == null || mmaObj.FourToSixLhr__c == '') && (mmaObj.MoreThanSixLhr__c == null || mmaObj.MoreThanSixLhr__c == '')) ){
                //if(laborHrs == null || laborHrs.trim() == '' || String.isBlank(laborHrs) || String.isEmpty(laborHrs) ){
                    if(wrapperObj.access == '' || wrapperObj.access.trim() == '')
                        laborHrsKey = wrapperObj.smn+'|'+'UNLISTED'+'|'+'ALL'+'|'+null+'|'+fc;
                    else
                        laborHrsKey = wrapperObj.smn+'|'+'UNLISTED'+'|'+'ALL'+'|'+wrapperObj.access+'|'+fc;
                    if(css_utility.isMapContainsKey(laborHrsMap, laborHrsKey)){
                        mmaObj = laborHrsMap.get(laborHrsKey);
                        System.debug('Step2: laborHrsKey>>>:'+laborHrsKey+' wrapperObj.smn>>>:'+wrapperObj.smn+' make>>>:'+wrapperObj.make+' model>>>:'+wrapperObj.model+' access>>>:'+wrapperObj.access+' fc>>>:'+fc);
                    }
                }
                System.debug('entered into make model Not Null code>>>>>>>>laborHrsKey>>>>'+laborHrsKey);
            }
        }catch(Exception ex){
            System.debug('in catch of getLaborHrsKey of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return mmaObj;
    }
    
    /*
     * This method is used to prepare the Prioritized FCs response of Assess Service based on the response of FCA FCs response
     */
    public CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3 prepareAssessPrioritizedFCsResponse(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex fcaPriFCsResJSON, Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList> faultDetailsMap, WrapperInput wrapperObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareAssessPrioritizedFCsResponse method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3 resJSON = null;
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.Header resHeader = null;
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.DataArea resDataArea = null;
        try{
            resHeader = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.Header();
            resHeader.ServiceName = wrapperObj.serviceName;
            resHeader.ServiceVersion = wrapperObj.serviceVersion;
            resHeader.Status = wrapperObj.status;
            resHeader.ReturnCodeDescription = wrapperObj.statusMsg;
            
            resDataArea = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.DataArea();
            resDataArea.PSN = wrapperObj.psn;
            resDataArea.algorithm = fcaPriFcsResJSON==null?null:fcaPriFcsResJSON.algorithm;
            resDataArea.IASNumber = wrapperObj.IASNumber;
            resDataArea.CSSEnabled = 'N'; //CSSEnabled logic is there while storing IA record //wrapperObj.CSSEnabled;
            resDataArea.prioritizedData = new List<CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.PrioritizedData>();
            resDataArea.unPrioritizedData = new List<CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.UnPrioritizedData>();
            
            //retrieving Prioritized Data from FCA response
            CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.PrioritizedData tgPriObj = null;
            CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.Relfc relFCObj = null;
            if(fcaPriFCsResJSON !=null && fcaPriFCsResJSON.PrioritizedData !=null)
            for(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.PrioritizedData fcaPriObj :fcaPriFCsResJSON.PrioritizedData){
                tgPriObj = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.PrioritizedData();
                tgPriObj.relfc = new List<CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.Relfc>();
                tgPriObj.prifc = fcaPriObj.pri;
                /*if(css_utility.isMapContainsKey(faultDetailsMap, fcaPriObj.pri)) //Commented as part of CR#1
                    tgPriObj.prifcdesc = (faultDetailsMap.get(fcaPriObj.pri)).faultCodeDescription; //fc description
                else
                    tgPriObj.prifcdesc = ''; */
                for(String relFC :fcaPriObj.rel){
                    relFCObj = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.Relfc();
                    relFCObj.rfc = relFC;
                    /*if(css_utility.isMapContainsKey(faultDetailsMap, relFC)) //Commented as part of CR#1
                        relFCObj.rfcdesc = (faultDetailsMap.get(relFC)).faultCodeDescription; //fc description
                    else
                        relFCObj.rfcdesc = ''; */
                    tgPriObj.relfc.add(relFCObj);
                }
                resDataArea.prioritizedData.add(tgPriObj); 
            }

            CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.UnPrioritizedData tgUnPriObj = null;
            if(fcaPriFCsResJSON !=null && fcaPriFCsResJSON.UnPrioritizedData !=null)
            for(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.UnPrioritizedData fcaUnPriObj :fcaPriFCsResJSON.UnPrioritizedData){
                tgUnPriObj = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.UnPrioritizedData();
                tgUnPriObj.upfc = fcaUnPriObj.fc;
                /*if(css_utility.isMapContainsKey(faultDetailsMap, fcaUnPriObj.fc)) //Commented as part of CR#1
                    tgUnPriObj.upfcdesc = (faultDetailsMap.get(fcaUnPriObj.fc)).faultCodeDescription; //fc description
                else
                    tgUnPriObj.upfcdesc = ''; */
                tgUnPriObj.rc = fcaUnPriObj.rc;
                resDataArea.unPrioritizedData.add(tgUnPriObj);
            }

            resJSON = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;

        }catch(Exception ex){
            System.debug('in catch of prepareAssessPrioritizedFCsResponse of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            resJSON = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
        }
        return resJSON;
    }
    
    /*
     * This method is used to prepare Labor Hours Data response of Assess Service based on the response of FCA FCs response
     */
    public CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3 prepareAssessLaborHrsDataResponse(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex fcaPriFCsResJSON, Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList> faultDetailsMap, Map<String, CSS_Make_Model_Access__c> laborHrsMap, WrapperInput wrapperObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareAssessLaborHrsDataResponse method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3 resJSON = null;
        CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.Header resHeader = null;
        CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.DataArea resDataArea = null;
        try{
            resHeader = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.Header();
            resHeader.ServiceName = wrapperObj.serviceName;
            resHeader.ServiceVersion = wrapperObj.serviceVersion;
            resHeader.Status = wrapperObj.status;
            resHeader.ReturnCodeDescription = wrapperObj.statusMsg;
            
            resDataArea = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.DataArea();
            resDataArea.PSN = wrapperObj.psn;
            resDataArea.algorithm = fcaPriFCsResJSON==null?null:fcaPriFCsResJSON.algorithm;
            resDataArea.IASNumber = wrapperObj.IASNumber;
            resDataArea.CSSEnabled = 'N'; //CSSEnabled logic is there while storing IA record //wrapperObj.CSSEnabled;
            resDataArea.prioritizedData = new List<CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.PrioritizedData>();
            resDataArea.unPrioritizedData = new List<CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.UnPrioritizedData>();
            
            //retrieving Prioritized Data from FCA response
            CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.PrioritizedData tgPriObj = null;
            CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.Relfc relFCObj = null;
            CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.Lhrprob lhrprob = null;
            if(fcaPriFCsResJSON !=null && fcaPriFCsResJSON.PrioritizedData !=null)
            for(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.PrioritizedData fcaPriObj :fcaPriFCsResJSON.PrioritizedData){
                tgPriObj = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.PrioritizedData();
                tgPriObj.relfc = new List<CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.Relfc>();
                tgPriObj.prifc = fcaPriObj.pri;
                /*if(css_utility.isMapContainsKey(faultDetailsMap, fcaPriObj.pri)) //Commented as part of CR#1
                    tgPriObj.prifcdesc = (faultDetailsMap.get(fcaPriObj.pri)).faultCodeDescription; //fc description
                else
                    tgPriObj.prifcdesc = ''; */                   
                for(String relFC :fcaPriObj.rel){
                    relFCObj = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.Relfc();
                    relFCObj.rfc = relFC;
                    /*if(css_utility.isMapContainsKey(faultDetailsMap, relFC)) //Commented as part of CR#1
                        relFCObj.rfcdesc = (faultDetailsMap.get(relFC)).faultCodeDescription; //fc description
                    else
                        relFCObj.rfcdesc = '';*/
                    tgPriObj.relfc.add(relFCObj);
                }
                //Preparing LaborHrs data
                //tgPriObj.lhrs = getLaborHrs(wrapperObj, fcaPriObj.pri, laborHrsMap); //V2 Code
                lhrprob = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.Lhrprob();
                CSS_Make_Model_Access__c mmaObj = getLaborHrs(wrapperObj, fcaPriObj.pri, laborHrsMap);
                if(mmaObj != null){
                    lhrprob.lbrprob1 = mmaObj.LessThanTwoLhr__c;
                	lhrprob.lbrprob2 = mmaObj.TwoToFourLhr__c;
                	lhrprob.lbrprob3 = mmaObj.FourToSixLhr__c;
                	lhrprob.lbrprob4 = mmaObj.MoreThanSixLhr__c;
                }
                if( (lhrprob.lbrprob1 == null || lhrprob.lbrprob1 == '' || lhrprob.lbrprob1 == '0') && (lhrprob.lbrprob2 == null || lhrprob.lbrprob2 == '' || lhrprob.lbrprob2 == '0') && 
                  (lhrprob.lbrprob3 == null || lhrprob.lbrprob3 == '' || lhrprob.lbrprob3 == '0') && (lhrprob.lbrprob4 == null || lhrprob.lbrprob4 == '' || lhrprob.lbrprob4 == '0') )
                	tgPriObj.lhrprob = null;
                else{
                    if(lhrprob.lbrprob1 == null || lhrprob.lbrprob1 == '')
                        lhrprob.lbrprob1 = '0';
                    if(lhrprob.lbrprob2 == null || lhrprob.lbrprob2 == '')
                        lhrprob.lbrprob2 = '0';
                    if(lhrprob.lbrprob3 == null || lhrprob.lbrprob3 == '')
                        lhrprob.lbrprob3 = '0';
                    if(lhrprob.lbrprob4 == null || lhrprob.lbrprob4 == '')
                        lhrprob.lbrprob4 = '0';
                    tgPriObj.lhrprob = lhrprob;
                }
                resDataArea.prioritizedData.add(tgPriObj);
            }
            //retrieving UnPrioritized Data from FCA response
            CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.UnPrioritizedData tgUnPriObj = null;
            if(fcaPriFCsResJSON !=null && fcaPriFCsResJSON.UnPrioritizedData !=null)
            for(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.UnPrioritizedData fcaUnPriObj :fcaPriFCsResJSON.UnPrioritizedData){
                tgUnPriObj = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.UnPrioritizedData();
                tgUnPriObj.upfc = fcaUnPriObj.fc;
                /*if(css_utility.isMapContainsKey(faultDetailsMap, fcaUnPriObj.fc)) //Commented as part of CR#1
                    tgUnPriObj.upfcdesc = (faultDetailsMap.get(fcaUnPriObj.fc)).faultCodeDescription; //fc description
                else
                    tgUnPriObj.upfcdesc = '';*/ 
                tgUnPriObj.rc = fcaUnPriObj.rc;
                resDataArea.unPrioritizedData.add(tgUnPriObj);
            }

            resJSON = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            system.debug('before returning.......................');
        }catch(Exception ex){
            System.debug('in catch of prepareAssessLaborHrsDataResponse of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            resJSON = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
        }
        return resJSON;
    }
    
    /*
     * This method is used to prepare RootCause Data response of Assess Service based on the response of FCA FCs response
     */
    public CSS_WPR_TG_FaultDetailsDataResJSON_V3 prepareAssessFaultDetailsDataResponse(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex fcaPriFCsResJSON, Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList> faultDetailsMap, Map<String, CSS_Make_Model_Access__c> laborHrsMap, WrapperInput wrapperObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareAssessFaultDetailsDataResponse method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_FaultDetailsDataResJSON_V3 resJSON = null;
        CSS_WPR_TG_FaultDetailsDataResJSON_V3.Header resHeader = null;
        CSS_WPR_TG_FaultDetailsDataResJSON_V3.DataArea resDataArea = null;
        try{
            resHeader = new CSS_WPR_TG_FaultDetailsDataResJSON_V3.Header();
            resHeader.ServiceName = wrapperObj.serviceName;
            resHeader.ServiceVersion = wrapperObj.serviceVersion;
            resHeader.Status = wrapperObj.status;
            resHeader.ReturnCodeDescription = wrapperObj.statusMsg;
            
            resDataArea = new CSS_WPR_TG_FaultDetailsDataResJSON_V3.DataArea();
            resDataArea.PSN = wrapperObj.psn;
            resDataArea.algorithm = fcaPriFcsResJSON==null?null:fcaPriFcsResJSON.algorithm;
            resDataArea.IASNumber = wrapperObj.IASNumber;
            resDataArea.CSSEnabled = 'N'; //CSSEnabled logic is there while storing IA record //wrapperObj.CSSEnabled;
            resDataArea.prioritizedData = new List<CSS_WPR_TG_FaultDetailsDataResJSON_V3.PrioritizedData>();
            resDataArea.unPrioritizedData = new List<CSS_WPR_TG_FaultDetailsDataResJSON_V3.UnPrioritizedData>();
            
            //retrieving Prioritized Data from FCA response
            CSS_WPR_TG_FaultDetailsDataResJSON_V3.PrioritizedData tgPriObj = null;
            CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList fcDetailsObj = null;
            CSS_WPR_TG_FaultDetailsDataResJSON_V3.Relfc relFCObj = null;
            CSS_WPR_TG_FaultDetailsDataResJSON_V3.Lhrprob lhrprob = null;
            if(fcaPriFCsResJSON !=null && fcaPriFCsResJSON.PrioritizedData !=null)
            for(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.PrioritizedData fcaPriObj :fcaPriFCsResJSON.PrioritizedData){
                tgPriObj = new CSS_WPR_TG_FaultDetailsDataResJSON_V3.PrioritizedData();
                tgPriObj.relfc = new List<CSS_WPR_TG_FaultDetailsDataResJSON_V3.Relfc>();
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
                    relFCObj = new CSS_WPR_TG_FaultDetailsDataResJSON_V3.Relfc();
                    relFCObj.rfc = relFC;
                    /*if(css_utility.isMapContainsKey(faultDetailsMap, relFC)){ //Commented as part of CR#1
                        relFCObj.rfcdesc = (faultDetailsMap.get(relFC)).faultCodeDescription; //fc description
                    }*/
                    tgPriObj.relfc.add(relFCObj);
                }
                //Preparing LaborHrs data
                //tgPriObj.lhrs = getLaborHrs(wrapperObj, fcaPriObj.pri, laborHrsMap); //V2 code
                lhrprob = new CSS_WPR_TG_FaultDetailsDataResJSON_V3.Lhrprob();
                CSS_Make_Model_Access__c mmaObj = getLaborHrs(wrapperObj, fcaPriObj.pri, laborHrsMap);
                if(mmaObj != null){
                    lhrprob.lbrprob1 = mmaObj.LessThanTwoLhr__c;
                	lhrprob.lbrprob2 = mmaObj.TwoToFourLhr__c;
                	lhrprob.lbrprob3 = mmaObj.FourToSixLhr__c;
                	lhrprob.lbrprob4 = mmaObj.MoreThanSixLhr__c;
                }
                if( (lhrprob.lbrprob1 == null || lhrprob.lbrprob1 == '' || lhrprob.lbrprob1 == '0') && (lhrprob.lbrprob2 == null || lhrprob.lbrprob2 == '' || lhrprob.lbrprob2 == '0') && 
                  (lhrprob.lbrprob3 == null || lhrprob.lbrprob3 == '' || lhrprob.lbrprob3 == '0') && (lhrprob.lbrprob4 == null || lhrprob.lbrprob4 == '' || lhrprob.lbrprob4 == '0') )
                	tgPriObj.lhrprob = null;
                else{
                    if(lhrprob.lbrprob1 == null || lhrprob.lbrprob1 == '')
                        lhrprob.lbrprob1 = '0';
                    if(lhrprob.lbrprob2 == null || lhrprob.lbrprob2 == '')
                        lhrprob.lbrprob2 = '0';
                    if(lhrprob.lbrprob3 == null || lhrprob.lbrprob3 == '')
                        lhrprob.lbrprob3 = '0';
                    if(lhrprob.lbrprob4 == null || lhrprob.lbrprob4 == '')
                        lhrprob.lbrprob4 = '0';
                    tgPriObj.lhrprob = lhrprob;
                }
                resDataArea.prioritizedData.add(tgPriObj);
            }
            //retrieving UnPrioritized Data from FCA response
            CSS_WPR_TG_FaultDetailsDataResJSON_V3.UnPrioritizedData tgUnPriObj = null;
            if(fcaPriFCsResJSON !=null && fcaPriFCsResJSON.UnPrioritizedData !=null)
            for(CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.UnPrioritizedData fcaUnPriObj :fcaPriFCsResJSON.UnPrioritizedData){
                tgUnPriObj = new CSS_WPR_TG_FaultDetailsDataResJSON_V3.UnPrioritizedData();
                tgUnPriObj.upfc = fcaUnPriObj.fc;
                /*if(css_utility.isMapContainsKey(faultDetailsMap, fcaUnPriObj.fc)){ //Commented as part of CR#1
                    tgUnPriObj.upfcdesc = (faultDetailsMap.get(fcaUnPriObj.fc)).faultCodeDescription;  //fc description
                }*/
                tgUnPriObj.rc = fcaUnPriObj.rc;
                resDataArea.unPrioritizedData.add(tgUnPriObj);
            }

            resJSON = new CSS_WPR_TG_FaultDetailsDataResJSON_V3();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            System.debug('before returning.......................resJSON:'+resJSON);
        }catch(Exception ex){
            System.debug('in catch of prepareAssessFaultDetailsDataResponse of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            resJSON = new CSS_WPR_TG_FaultDetailsDataResJSON_V3();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
        }
        return resJSON;
    }
    
    /*
     * This method is used for validations
     */
    public CSS_WPR_TG_GetAssessDataResJSON2Apex_V3 performValidations(RestRequest req){
        System.debug('################# entered into performValidations method ###################');
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 reqJSON = null;
        String jSONRequestBody = null;
        WrapperInput wrapperObj = new WrapperInput();
        try{
            jSONRequestBody = req.requestBody.toString().trim();
            //jSONRequestBody = '{"Header": {"ServiceName": "GetPrioritizedFC","ServiceVersion": "1.0","SenderID": "ATLASMOBILE","TargetID": "CSS"},"DataArea": {"PSN": "79484646","SERVICEMODELNAME": "ISB_CM2150","ERT": "1230000","MAKE": "KENWORTH","MODEL": "T800","ACCODE": "B","FAULTLIST": [{"fc": "123","occurenceTime": 1441238400,"status": "active","count": 1},{"fc": "2345","occurenceTime": 1521238400,"status": "active","count": 0},{"fc": "140","occurenceTime": 1341238400,"status": "active","count": 2},{"fc": "2341","occurenceTime": 1321238400,"status": "active","count": 2},{"fc": "2731","occurenceTime": 1311238400,"status": "active","count": 0}]}}';
            System.debug('before deserialize jSONRequestBody>>>>>>>>>>>>>>>>>>>>>>:'+jSONRequestBody);
            
            //Step1: Perform validations here
            if(jSONRequestBody == null || jSONRequestBody == '' || String.isBlank(jSONRequestBody) || String.isEmpty(jSONRequestBody) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS01-Requested input is blank/invalid';
                return prepareResponseWrapper(wrapperObj);
            }   
            System.debug('reqJSON'+reqJSON);

            reqJSON = CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(jSONRequestBody);
            System.debug('after deserialize reqJSON:'+reqJSON);
            if(reqJSON == null || reqJSON.Header == null || reqJSON.DataArea == null){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS01-Requested input is blank/invalid';
                return prepareResponseWrapper(wrapperObj);
            }
            
            if(reqJSON.Header.ServiceName == null || reqJSON.Header.ServiceName.trim() == '' || String.isBlank(reqJSON.Header.ServiceName) 
               || String.isEmpty(reqJSON.Header.ServiceName) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS02-Service Name is blank/invalid';
                return prepareResponseWrapper(wrapperObj);
            }
            if(reqJSON.Header.ServiceName.toLowerCase() != 'getprioritizedfc' && reqJSON.Header.ServiceName.toLowerCase() != 'getlaborhrsdata' 
              && reqJSON.Header.ServiceName.toLowerCase() != 'getassessdata' ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS02-Service Name is blank/invalid';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.serviceName = reqJSON.Header.ServiceName;
            System.debug('reqJSON.Header.ServiceName:'+reqJSON.Header.ServiceName);
            
            if(reqJSON.Header.ToolID == null || reqJSON.Header.ToolID.trim() == '' || String.isBlank(reqJSON.Header.ToolID) 
               || String.isEmpty(reqJSON.Header.ToolID) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS03-ToolID is blank';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.ToolID = reqJSON.Header.ToolID;
            
            if(reqJSON.DataArea.PSN == null || reqJSON.DataArea.PSN.trim() == '' || String.isBlank(reqJSON.DataArea.PSN) 
               || String.isEmpty(reqJSON.DataArea.PSN) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS04-PSN is blank';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.psn = reqJSON.DataArea.PSN;
            
            if(reqJSON.DataArea.SERVICEMODELNAME == null || reqJSON.DataArea.SERVICEMODELNAME.trim() == '' 
               || String.isBlank(reqJSON.DataArea.SERVICEMODELNAME) || String.isEmpty(reqJSON.DataArea.SERVICEMODELNAME) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS05-SERVICEMODELNAME is blank';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.smn = reqJSON.DataArea.SERVICEMODELNAME;
            
            if(reqJSON.DataArea.ERT == null || reqJSON.DataArea.ERT.trim() == '' || String.isBlank(reqJSON.DataArea.ERT) 
               || String.isEmpty(reqJSON.DataArea.ERT) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS06-ERT is blank';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.ERT = reqJSON.DataArea.ERT;
            
            if(reqJSON.DataArea.MAKE == null || reqJSON.DataArea.MAKE.trim() == '' || String.isBlank(reqJSON.DataArea.MAKE) 
               || String.isEmpty(reqJSON.DataArea.MAKE) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS07-MAKE is blank';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.make = reqJSON.DataArea.MAKE;
            
            if(reqJSON.DataArea.MODEL == null || reqJSON.DataArea.MODEL.trim() == '' || String.isBlank(reqJSON.DataArea.MODEL) 
               || String.isEmpty(reqJSON.DataArea.MODEL) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS08-MODEL is blank';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.model = reqJSON.DataArea.MODEL;
            
            /*if(reqJSON.DataArea.UserLocation == null || reqJSON.DataArea.UserLocation.trim() == '' || String.isBlank(reqJSON.DataArea.UserLocation) 
               || String.isEmpty(reqJSON.DataArea.UserLocation) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS17-UserLocation is invalid';
                return prepareResponseWrapper(wrapperObj);
            }
            wrapperObj.userLocation = reqJSON.DataArea.UserLocation;*/
            /*
            if(reqJSON.DataArea.faultList == null || reqJSON.DataArea.faultList.size() == 0){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS09-Requested FAULTLIST is blank';
                return prepareResponseWrapper(wrapperObj);
            }*/
            System.debug('ServiceName>>>:'+reqJSON.Header.ServiceName+' psn>>>:'+reqJSON.DataArea.PSN+' smn>>>:'+reqJSON.DataArea.SERVICEMODELNAME+' ERT>>>:'+reqJSON.DataArea.ERT+' MAKE>>>:'+reqJSON.DataArea.MAKE+' MODEL>>>:'+reqJSON.DataArea.MODEL+' ACCESS>>>:'+reqJSON.DataArea.ACCESS);
            wrapperObj.status = 'Processed'; //this Processed status is used for validating as no error found
            return prepareResponseWrapper(wrapperObj);
        }catch(Exception ex){
            System.debug('in catch of performValidations of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
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
    /*
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
            System.debug('in catch of performValidations of CSS_FN_Triage_V2>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS03-Invalid JSON Format';
            return prepareResponseWrapperForMakeModelAccess(wrapperObj);
        }finally{
            wrapperObj=null;reqJSON=null;jSONRequestBody=null;
        }
        return null;
    }
*/
    
    /*
     * This method is used for validations of Create CSS Job
     */
    public CSS_WPR_TG_IACSSJobCreationResJSON_V3 performValidationsForCreateUpdateCSSJob(RestRequest req, WrapperInput wrapperObj){
        System.debug('################# entered into performValidationsForCreateUpdateCSSJob method ###################');
        CSS_WPR_TG_IACSSJobCreationReqJSON_V3 reqJSON = null;
        String jSONRequestBody = null;
        try{
            jSONRequestBody = req.requestBody.toString().trim();
            System.debug('before deserialize jSONRequestBody>>>>>>>>>>>>>>>>>>>>>>:'+jSONRequestBody);
            
            //Step1: Perform validations here
            if(jSONRequestBody == null || jSONRequestBody == '' || String.isBlank(jSONRequestBody) || String.isEmpty(jSONRequestBody) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS01-Requested input is blank/invalid';
                return prepareResponseWrapperForCSSJob(wrapperObj);
            }   

            reqJSON = CSS_WPR_TG_IACSSJobCreationReqJSON_V3.parse(jSONRequestBody);
            System.debug('after deserialize reqJSON>>>>>>>:'+reqJSON);
            if(reqJSON == null || reqJSON.Header == null || reqJSON.DataArea == null){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS01-Requested input is blank/invalid';
                return prepareResponseWrapperForCSSJob(wrapperObj);
            }
            
            if(reqJSON.Header.ServiceName == null || reqJSON.Header.ServiceName.trim() == '' || String.isBlank(reqJSON.Header.ServiceName) 
               || String.isEmpty(reqJSON.Header.ServiceName) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS02-Service Name is blank/invalid';
                return prepareResponseWrapperForCSSJob(wrapperObj);
            }
            if(reqJSON.Header.ServiceName.toLowerCase() != 'iacssjobcreation'){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS02-Service Name is blank/invalid';
                return prepareResponseWrapperForCSSJob(wrapperObj);
            }
            wrapperObj.serviceVersion = reqJSON.Header.serviceVersion;
            wrapperObj.serviceName = reqJSON.Header.ServiceName;
            System.debug('reqJSON.Header.ServiceName:'+reqJSON.Header.ServiceName);
            
            if(reqJSON.Header.ToolID == null || reqJSON.Header.ToolID.trim() == '' || String.isBlank(reqJSON.Header.ToolID) 
               || String.isEmpty(reqJSON.Header.ToolID) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS03-ToolID is blank';
                return prepareResponseWrapperForCSSJob(wrapperObj);
            }
            wrapperObj.ToolID = reqJSON.Header.ToolID;
            
            if(reqJSON.DataArea.IASNumber == null || reqJSON.DataArea.IASNumber.trim() == '' || String.isBlank(reqJSON.DataArea.IASNumber) 
               || String.isEmpty(reqJSON.DataArea.IASNumber) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS04-IASNumber is blank';
                return prepareResponseWrapperForCSSJob(wrapperObj);
            }
            wrapperObj.IASNumber = reqJSON.DataArea.IASNumber;
            wrapperObj.CSSJobNumber = reqJSON.DataArea.CSSJobNumber;

            wrapperObj.status = 'Processed'; //this Processed status is used for validating as no error found
            return prepareResponseWrapperForCSSJob(wrapperObj);
        }catch(Exception ex){
            System.debug('in catch of performValidationsForCreateUpdateCSSJob of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS05-Invalid JSON Format';
            return prepareResponseWrapperForCSSJob(wrapperObj);
        }finally{
            reqJSON=null;jSONRequestBody=null;
        }
        return null;
    }
    
    /*
     * This method is used for validations of IA Appointments
     */
    public CSS_WPR_TG_IAAppointmentsResJSON_V1 performValidationsForIAAppointments(RestRequest req, WrapperInput wrapperObj){
        System.debug('################# entered into performValidationsForIAAppointments method ###################');
        CSS_WPR_TG_IAAppointmentsReqJSON_V1 reqJSON = null;
        String jSONRequestBody = null;
        List<Account> accList = null;
        try{
            jSONRequestBody = req.requestBody.toString().trim();
            System.debug('before deserialize jSONRequestBody>>>>>>>>>>>>>>>>>>>>>>:'+jSONRequestBody);
            
            //Step1: Perform validations here
            if(jSONRequestBody == null || jSONRequestBody == '' || String.isBlank(jSONRequestBody) || String.isEmpty(jSONRequestBody) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS01-Requested input is blank/invalid';
                return prepareResWrapperForIAAppoints(wrapperObj);
            }   

            reqJSON = CSS_WPR_TG_IAAppointmentsReqJSON_V1.parse(jSONRequestBody);
            System.debug('after deserialize reqJSON>>>>>>>:'+reqJSON);
            if(reqJSON == null || reqJSON.Header == null || reqJSON.DataArea == null){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS01-Requested input is blank/invalid';
                return prepareResWrapperForIAAppoints(wrapperObj);
            }
            
            if(reqJSON.Header.ServiceName == null || reqJSON.Header.ServiceName.trim() == '' || String.isBlank(reqJSON.Header.ServiceName) 
               || String.isEmpty(reqJSON.Header.ServiceName) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS02-Service Name is blank/invalid';
                return prepareResWrapperForIAAppoints(wrapperObj);
            }
            if(reqJSON.Header.ServiceName.toLowerCase() != 'iaappointments'){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS02-Service Name is blank/invalid';
                return prepareResWrapperForIAAppoints(wrapperObj);
            }
            wrapperObj.serviceVersion = reqJSON.Header.serviceVersion;
            wrapperObj.serviceName = reqJSON.Header.ServiceName;
            System.debug('reqJSON.Header.ServiceName:'+reqJSON.Header.ServiceName);
            
            if(reqJSON.Header.ToolID == null || reqJSON.Header.ToolID.trim() == '' || String.isBlank(reqJSON.Header.ToolID) 
               || String.isEmpty(reqJSON.Header.ToolID) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS03-ToolID is blank';
                return prepareResWrapperForIAAppoints(wrapperObj);
            }
            wrapperObj.ToolID = reqJSON.Header.ToolID;
            
            if(reqJSON.DataArea.CurrentDate == null || reqJSON.DataArea.CurrentDate.trim() == '' || String.isBlank(reqJSON.DataArea.CurrentDate) 
               || String.isEmpty(reqJSON.DataArea.CurrentDate) || reqJSON.DataArea.CurrentDate.trim().length() !=10){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS04-CurrentDate is blank/invalid';
                return prepareResWrapperForIAAppoints(wrapperObj);
            }
            try{
            	Date dt = Date.parse(reqJSON.DataArea.CurrentDate.trim());
            }catch(Exception ex){
                System.debug('in catch of Date convertion of getIAAppointments of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS04-CurrentDate is blank/invalid';
                return prepareResWrapperForIAAppoints(wrapperObj);
        	}
            wrapperObj.CurrentDate = reqJSON.DataArea.CurrentDate.trim();
            
            if(reqJSON.DataArea.UserLocation == null || reqJSON.DataArea.UserLocation.trim() == '' || String.isBlank(reqJSON.DataArea.UserLocation) 
               || String.isEmpty(reqJSON.DataArea.UserLocation) ){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS05-UserLocation is blank/invalid';
                return prepareResWrapperForIAAppoints(wrapperObj);
            }
            //Here do logic for length of 11 chars
            String userLoc = getFilteredUserLocation(reqJSON.DataArea.UserLocation);
            System.debug('After validations userLoc>>>>>>:'+userLoc);
			if(userLoc == null || userLoc.trim() == '' || String.isBlank(userLoc) || String.isEmpty(userLoc)){
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS05-UserLocation is blank/invalid';
                return prepareResWrapperForIAAppoints(wrapperObj);
            }
            wrapperObj.UserLocation = userLoc;
            accList = new List<Account>([Select Id, Location__c, IA_CSSEnabled__c from Account where IA_CSSEnabled__c=true and Location__c=:userLoc limit 1]);
            if(accList != null && accList.size()>0)
                wrapperObj.cssEnabled = 'Y';
            else{
                wrapperObj.cssEnabled = 'N';
                wrapperObj.status = 'Success';
            	wrapperObj.statusMsg = 'CG01-IAAppointments list is sent successfully';
            	return prepareResWrapperForIAAppoints(wrapperObj);
            }
            
            wrapperObj.status = 'Processed'; //this Processed status is used for validating as no error found
            return prepareResWrapperForIAAppoints(wrapperObj);
        }catch(Exception ex){
            System.debug('in catch of performValidationsForIAAppointments of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS06-Invalid JSON Format';
            return prepareResWrapperForIAAppoints(wrapperObj);
        }finally{
            reqJSON=null;jSONRequestBody=null;accList=null;
        }
        return null;
    }
    
    /*
     * This method is used for send IA Appointments
     * 
     */
    public CSS_WPR_TG_IAAppointmentsResJSON_V1 getIAAppointments(WrapperInput wrapperObj){
        System.debug('################# entered into getIAAppointments of CSS_FN_Triage_V3 method ###################');
        CSS_WPR_TG_IAAppointmentsResJSON_V1 resJSON = null;
        CSS_WPR_TG_IAAppointmentsResJSON_V1.IAAppointments iaAppintObj = null;
        CSS_DataExchange_Parent__c deObj;
        try{
            System.debug('input userLocation>>>>is::'+wrapperObj.userLocation+' input CurrentDate>>>>>:'+wrapperObj.CurrentDate);
            resJSON = new CSS_WPR_TG_IAAppointmentsResJSON_V1();
            wrapperObj.iaAppointList = new List<CSS_WPR_TG_IAAppointmentsResJSON_V1.IAAppointments>();
            Date cDate = Date.parse(wrapperObj.CurrentDate);
            Date yesterdayDate = cDate.addDays(-1);
            //Date todayDate = cDate.addDays(1);
            Date tomorrowDate = cDate.addDays(1);
            System.debug('cDate>>>>is::'+cDate+' yesterdayDate>>>>>:'+yesterdayDate+' tomorrowDate>>>>>>:'+tomorrowDate);
            List<css_job_order__c> jobList = new List<css_job_order__c>([Select Id,Name,Customer_Name__c,First_Name__c,BMS_Last_Name__c,Unit_Number__c,General_Symptoms__c,Date_in_Shop__c,Creator_Location__c from css_job_order__c where Status__c = 'Appointment' and Creator_Location__c=:wrapperObj.userLocation and (Date_in_Shop__c=:yesterdayDate OR Date_in_Shop__c=:cDate OR Date_in_Shop__c=:tomorrowDate) order by Date_in_Shop__c DESC ]);
            /*if(jobList.size()<=0){
                wrapperObj.status = 'Success';
                wrapperObj.statusMsg = 'CG01-IAAppointments list is sent successfully';
                return prepareResWrapperForIAAppoints(wrapperObj);
            }*/
			for(css_job_order__c jobObj: jobList){
                iaAppintObj = new CSS_WPR_TG_IAAppointmentsResJSON_V1.IAAppointments();
                iaAppintObj.CustomerName = jobObj.Customer_Name__c;
                iaAppintObj.ContactFirstName = jobObj.First_Name__c;
                iaAppintObj.ContactLastName = jobObj.BMS_Last_Name__c;
                iaAppintObj.UnitNumber = jobObj.Unit_Number__c;
                iaAppintObj.ComplaintText = jobObj.General_Symptoms__c;
                if(jobObj.Date_in_Shop__c !=null){
                	//iaAppintObj.AvailableForService = String.valueOf(jobObj.Date_in_Shop__c);
                    iaAppintObj.AvailableForService = jobObj.Date_in_Shop__c.month() + '/' + jobObj.Date_in_Shop__c.day() + '/' + jobObj.Date_in_Shop__c.year();
                }
                iaAppintObj.CSSJobNumber = jobObj.Name;
                wrapperObj.iaAppointList.add(iaAppintObj);
            }
            wrapperObj.status = 'Success';
            wrapperObj.statusMsg = 'CG01-IAAppointments list is sent successfully';
            return prepareResWrapperForIAAppoints(wrapperObj);
        }catch(Exception ex){
            System.debug('in catch of getIAAppointments of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS11-CSS Internal Error';
            return prepareResWrapperForIAAppoints(wrapperObj);
        }finally{
            wrapperObj=null;
        }
        return resJSON;
    }
    
    /*
     * This method is used for preparing Response Wrapper for the service
     */ 
    public CSS_WPR_TG_GetAssessDataResJSON2Apex_V3 prepareResponseWrapper(WrapperInput wrapperObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareResponseWrapper method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_GetAssessDataResJSON2Apex_V3 resJSON = null;
        CSS_WPR_TG_GetAssessDataResJSON2Apex_V3.Header resHeader = null;
        CSS_WPR_TG_GetAssessDataResJSON2Apex_V3.DataArea resDataArea = null;
        try{
            resHeader = new CSS_WPR_TG_GetAssessDataResJSON2Apex_V3.Header();
            resHeader.ServiceName = wrapperObj.serviceName;
            resHeader.ServiceVersion = wrapperObj.serviceVersion;
            resHeader.Status = wrapperObj.status;
            resHeader.ReturnCodeDescription = wrapperObj.statusMsg;
            
            resDataArea = new CSS_WPR_TG_GetAssessDataResJSON2Apex_V3.DataArea();
            resDataArea.PSN = wrapperObj.psn;
            resDataArea.algorithm = wrapperObj.algorithm;
            
            resDataArea.prioritizedData = new List<CSS_WPR_TG_GetAssessDataResJSON2Apex_V3.PrioritizedData>();
            resDataArea.unPrioritizedData = new List<CSS_WPR_TG_GetAssessDataResJSON2Apex_V3.UnPrioritizedData>();
            
            resJSON = new CSS_WPR_TG_GetAssessDataResJSON2Apex_V3();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            System.debug('before returning Response JSON>>>>>>>>>>>>>>>>>>>>>>>>>>resJSON:'+resJSON);
        }catch(Exception ex){
            System.debug('in catch of prepareResponseWrapper of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            //Perform some clean up
            resHeader = null; resDataArea = null;
        }
        return resJSON;
    }
    
    /*
     * This method is used for preparing the final response of this service
     */
    /*
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
            System.debug('in catch of prepareResponseWrapperForMakeModelAccess of CSS_FN_Triage_V2>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            //Perform some clean up
            resHeader = null; resDataArea = null;
        }
        return resJSON;
    }
    */
    
    /*
     * This method is used to get Make, Model, Access List of Service1
     */ 
    /*
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
            
            //getting SELECTMAKE, SELECTMODEL, SELECTACCESS from SIEBEL webservice
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
            System.debug('in catch of getMakeModelAccessList of CSS_FN_Triage_V2>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS08-CSS Internal Error';
            return prepareResponseWrapperForMakeModelAccess(wrapperObj);
        } finally {
            wrapperObj=null;
        }
        return resJSON;
    }
*/
    
    /*
     * This method is used to get Make Model Access List from CSS_Make_Model_Access__c object
     */
    /*
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
            System.debug('in catch of getMakeModelAccessListOfSMN of CSS_FN_Triage_V2>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } 
        return makeModelAccessList;
    }
*/    

    /*
     * This method is used to get Make Model Access Wrapper List
     */
    /*
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
            System.debug('in catch of getMMAWrapperList of CSS_FN_Triage_V2>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally{
            mmaSet=null;resMakeModelAccessObj=null;key=null;
        }
        return mmaList;
    }
*/    

    /*
     * This method is used for preparing Response Wrapper for the service
     */ 
    public CSS_WPR_TG_IACSSJobCreationResJSON_V3 prepareResponseWrapperForCSSJob(WrapperInput wrapperObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareResponseWrapperForCSSJob method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_IACSSJobCreationResJSON_V3 resJSON = null;
        CSS_WPR_TG_IACSSJobCreationResJSON_V3.Header resHeader = null;
        CSS_WPR_TG_IACSSJobCreationResJSON_V3.DataArea resDataArea = null;
        try{
            resHeader = new CSS_WPR_TG_IACSSJobCreationResJSON_V3.Header();
            resHeader.ServiceName = wrapperObj.serviceName;
            resHeader.ServiceVersion = wrapperObj.serviceVersion;
            resHeader.Status = wrapperObj.status;
            resHeader.ReturnCodeDescription = wrapperObj.statusMsg;
            
            resDataArea = new CSS_WPR_TG_IACSSJobCreationResJSON_V3.DataArea();
            resDataArea.IASNumber = wrapperObj.IASNumber;
            resDataArea.CSSJobNumber = wrapperObj.CSSJobNumber;
            
            resJSON = new CSS_WPR_TG_IACSSJobCreationResJSON_V3();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            System.debug('before returning Response JSON>>>>>>>>>>>>>>>>>>>>>>>>>>resJSON:'+resJSON);
        }catch(Exception ex){
            System.debug('in catch of prepareResponseWrapperForCSSJob of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            //Perform some clean up
            resHeader = null; resDataArea = null;
        }
        return resJSON;
    }
    
    /*
     * This method is used for preparing Response Wrapper for the service
     */ 
    public CSS_WPR_TG_IAAppointmentsResJSON_V1 prepareResWrapperForIAAppoints(WrapperInput wrapperObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareResWrapperForIAAppoints method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_IAAppointmentsResJSON_V1 resJSON = null;
        CSS_WPR_TG_IAAppointmentsResJSON_V1.Header resHeader = null;
        CSS_WPR_TG_IAAppointmentsResJSON_V1.DataArea resDataArea = null;
        try{
            resHeader = new CSS_WPR_TG_IAAppointmentsResJSON_V1.Header();
            resHeader.ServiceName = wrapperObj.serviceName;
            resHeader.ServiceVersion = wrapperObj.serviceVersion;
            resHeader.Status = wrapperObj.status;
            resHeader.ReturnCodeDescription = wrapperObj.statusMsg;
            
            resDataArea = new CSS_WPR_TG_IAAppointmentsResJSON_V1.DataArea();
            resDataArea.CSSEnabled = wrapperObj.CSSEnabled;
            resDataArea.IAAppointments = wrapperObj.iaAppointList;
            
            resJSON = new CSS_WPR_TG_IAAppointmentsResJSON_V1();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            System.debug('before returning Response JSON>>>>>>>>>>>>>>>>>>>>>>>>>>resJSON:'+resJSON);
        }catch(Exception ex){
            System.debug('in catch of prepareResWrapperForIAAppoints of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            //Perform some clean up
            resHeader = null; resDataArea = null;
        }
        return resJSON;
    }
    
    /*
     * This method is used for saving Req & Res details for tracking
     */ 
    public String saveReqResDetails(CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 reqJSON, String jSONRequestBody, Object res){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into saveReqResDetails method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List <Account> accList;
        try{
            //Perform validations
            String userLocFiltered = performValidationsForIARecordSaving(reqJSON.DataArea.UserLocation, res);
            System.debug('Final UserLoc>>>>:'+userLocFiltered);
            if(userLocFiltered == null)
                return reqJSON.DataArea.IASNumber;
            System.debug('No Validation Errors occured...Final userLocFiltered>>>>:'+userLocFiltered);
            accList = new List<Account>([Select Id, Location__c, IA_CSSEnabled__c from Account where IA_CSSEnabled__c=true and Location__c=:userLocFiltered limit 1]);
            if(accList != null && accList.size()>0)
               assignResDetails(res, null, null, 'Y');
            else
                assignResDetails(res, null, null, 'N');
            
            // Save/Update IA Record
            if(reqJSON.DataArea.IASNumber == null || reqJSON.DataArea.IASNumber.trim() == '' || String.isBlank(reqJSON.DataArea.IASNumber) 
               || String.isEmpty(reqJSON.DataArea.IASNumber) ){
               return insertReqResDetails(reqJSON, jSONRequestBody, res, userLocFiltered); //check return iasno here
            }else{
                return updateReqResDetails(reqJSON, jSONRequestBody, res, userLocFiltered);
            }
        }catch(Exception ex){
            System.debug('in catch of saveReqResDetails of CSS_FN_Triage_V3>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return reqJSON.DataArea.IASNumber;
     }
    
    /*
     * This method is used for saving Req & Res details for tracking
     */ 
    public String performValidationsForIARecordSaving(String userLocation, Object res){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into performValidationsForIARecordSaving method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List<Account> accList;
        List<String> locList;
        String userLoc;
        try{
            if(userLocation == null || userLocation.trim() == '' 
               || String.isBlank(userLocation) || String.isEmpty(userLocation)){
                   assignResDetails(res, null, 'CSS18-UserLocation is blank', null);
                   return null;
            }
            if(userLocation.trim().toUpperCase() == 'FACTORY'){
                assignResDetails(res, null, 'CSS20-UserLocation is Factory, IAS recdord will not be created/updated', null);
                return null;
            }
            
            //Here do logic for length of 11 chars
            userLoc = getFilteredUserLocation(userLocation);
/*
            locList = userLocation.trim().split(',');
            if(locList ==null || locList.size()<=0){
                System.debug('enetered into first block of comma separated...locList:'+locList.size());
                if(userLocation.length()>=11)
                userLoc = userLocation.trim().substring(0, 11);
            }else{
                if(userLocation.contains('-P')){
                    System.debug('enetered into -P block ...');
                    for(String location :locList){
                        if(location.contains('-P') && location.length()>=13){
                            userLoc = location.subString(0,13).replace('-P','');
                            userLoc = userLoc.trim();
                            break;
                        }
                    }
                }else {
                    for(String location :locList){
                        if(location.length()>=11){
                            System.debug('enetered into else block of comma separated...');
                            userLoc = location.subString(0,11);
                            userLoc = userLoc.trim();
                            break;
                        }
                    }
                }
            }*/
            System.debug('After validations userLoc>>>>>>:'+userLoc);
			if(userLoc == null || userLoc.trim() == '' || String.isBlank(userLoc) || String.isEmpty(userLoc)){
                   assignResDetails(res, null, 'CSS19-UserLocation is invalid', null);
                   return null;
            }
            
            //commenting below code for even allowing user location is still not available in CSS for IA record create/update
            /*accList = new List<Account>([Select Id, Location__c, IA_CSSEnabled__c from Account where Location__c=:userLoc limit 1]);
            if(accList.size()<=0){
                assignResDetails(res, null, 'CSS18-UserLocation is invalid', null);
                return null;
            }*/
            return userLoc;
        }catch(Exception ex){
            System.debug('in catch of performValidationsForIARecordSaving of CSS_FN_Triage_V3>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally{
            accList=null;locList=null;
        }
        return null;
     }
    
    /*
     * This method is used for saving Req & Res details for tracking
     */ 
    public String insertReqResDetails(CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 reqJSON, String jSONRequestBody, Object res, String userLocFiltered){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into insertReqResDetails method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_DataExchange_Parent__c dataExchangeObj = null;
        String iasNumber;
        try{
            dataExchangeObj = new CSS_DataExchange_Parent__c();
            dataExchangeObj.recordTypeId = [Select Id, Name from RecordType where Name = 'IA-Inbox' limit 1].Id;
            dataExchangeObj.Version__c = 'v03';
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
            dataExchangeObj.User_Location__c = reqJSON.DataArea.UserLocation;
            dataExchangeObj.User_Location_filtered__c = userLocFiltered;
            if(reqJSON.DataArea.CustomerName.length()>255)
            dataExchangeObj.Customer_Company_Name__c = reqJSON.DataArea.CustomerName.trim().substring(0, 255);
            else
                dataExchangeObj.Customer_Company_Name__c = reqJSON.DataArea.CustomerName;
            if(reqJSON.DataArea.ComplaintText.length()>4000)
            dataExchangeObj.Complaint_Text__c = reqJSON.DataArea.ComplaintText.trim().substring(0, 4000);
            else
                dataExchangeObj.Complaint_Text__c = reqJSON.DataArea.ComplaintText;
            dataExchangeObj.Request_JSON__c = jSONRequestBody;
            dataExchangeObj = assignResDetails(res, dataExchangeObj, 'CG01-IAS record inserted successfully', null);
            //insert DataExchange record here
            insert dataExchangeObj;
            System.debug('$$$$$$$$$$$$$$$$$$$$ DataExchange record inserted successfully....Id is:'+dataExchangeObj.Id);
            
            //Update again here inserted record with IASNumber
            CSS_DataExchange_Parent__c deObj = [Select Id, Name, Response_JSON__c from CSS_DataExchange_Parent__c where Id=:dataExchangeObj.Id];
            iasNumber = deObj.Name;
            System.debug('before iasNumber>>>>>>>>>>:'+deObj.Name+' deObj.Response_JSON__c>>>:'+deObj.Response_JSON__c);
            //deObj.Response_JSON__c = (deObj.Response_JSON__c).replace('"IASNumber":null', '"IASNumber":'+deObj.Name);
            deObj.Response_JSON__c = (deObj.Response_JSON__c).replace('"IASNumber":""', '"IASNumber":\"'+deObj.Name+'\"');
            update deObj;
            System.debug('iasNumber>>>>>>>>>>:'+deObj.Name+' deObj.Response_JSON__c>>>:'+deObj.Response_JSON__c);
        }catch(Exception ex){
            System.debug('in catch of insertReqResDetails of CSS_FN_Triage_V3>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
			assignResDetails(res, dataExchangeObj, 'CSS21-IAS record save failed due to internal issue', null);
        } finally {
            //Perform some clean up
            dataExchangeObj = null;
        }
        return iasNumber;
    }
    
    /*
     * This method is used for saving Req & Res details for tracking
     */ 
    public String updateReqResDetails(CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 reqJSON, String jSONRequestBody, Object res, String userLocFiltered){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into updateReqResDetails method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_DataExchange_Parent__c dataExchangeObj = null;
        try{
            List<CSS_DataExchange_Parent__c> deObjList = new List<CSS_DataExchange_Parent__c>([Select Id, Name from CSS_DataExchange_Parent__c where Name=:reqJSON.DataArea.IASNumber limit 1]);
            if(deObjList.size()>0){
                dataExchangeObj = deObjList.get(0);
            }else{
                assignResDetails(res, null, 'CSS23-IAS record doesn’t exist', null);
                return reqJSON.DataArea.IASNumber;
            }

            dataExchangeObj.Version__c = 'v03';
            dataExchangeObj.CSS_Job_Number__c = null; //here logic value to be assigned
            dataExchangeObj.CSS_Enabled__c = null; //here logic value to be assigned
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
            dataExchangeObj.User_Location__c = reqJSON.DataArea.UserLocation;
            dataExchangeObj.User_Location_filtered__c = userLocFiltered;
            if(reqJSON.DataArea.CustomerName.length()>255)
            dataExchangeObj.Customer_Company_Name__c = reqJSON.DataArea.CustomerName.trim().substring(0, 255);
            else
                dataExchangeObj.Customer_Company_Name__c = reqJSON.DataArea.CustomerName;
            if(reqJSON.DataArea.ComplaintText.length()>4000)
            dataExchangeObj.Complaint_Text__c = reqJSON.DataArea.ComplaintText.trim().substring(0, 4000);
            else
                dataExchangeObj.Complaint_Text__c = reqJSON.DataArea.ComplaintText;
            dataExchangeObj.Request_JSON__c = jSONRequestBody;
            dataExchangeObj = assignResDetails(res, dataExchangeObj, 'CG02-IAS record updated successfully', null);
            update dataExchangeObj; //update DataExchange record here
            System.debug('$$$$$$$$$$$$$$$$$$$$ DataExchange record updated successfully....Id is:'+dataExchangeObj.Id+' IASNumber is:'+dataExchangeObj.Name);
        }catch(Exception ex){
            System.debug('in catch of updateReqResDetails of CSS_FN_Triage_V3>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            assignResDetails(res, dataExchangeObj, 'CSS22-IAS record update failed due to internal issue', null);
        } finally {
            //Perform some clean up
            dataExchangeObj = null;
        }
        return reqJSON.DataArea.IASNumber;
    }
    
    /*
     * This method is used for saving Res details for tracking
     */ 
    public CSS_DataExchange_Parent__c assignResDetails(Object res, CSS_DataExchange_Parent__c dataExchangeObj, String txnCodeDesc, String cssEnabled){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into assignResDetails method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        try{
            if (res instanceof CSS_WPR_TG_GetAssessDataResJSON2Apex_V3){
      CSS_WPR_TG_GetAssessDataResJSON2Apex_V3 resJSON = (CSS_WPR_TG_GetAssessDataResJSON2Apex_V3) res;
                if(txnCodeDesc !=null && txnCodeDesc.trim() != '')
                resJSON.Header.TxnCodeDescription = txnCodeDesc;
                if(cssEnabled !=null && cssEnabled.trim() != '')
                resJSON.DataArea.CSSEnabled = cssEnabled;
                if(dataExchangeObj != null){
                    dataExchangeObj.Status__c = resJSON.Header.Status;
                    dataExchangeObj.ReturnCodeDescription__c = resJSON.Header.ReturnCodeDescription;
                    dataExchangeObj.Algorithm__c = resJSON.DataArea.algorithm;
                    dataExchangeObj.Response_JSON__c = JSON.serialize(resJSON);
                    dataExchangeObj.CSS_Enabled__c = resJSON.DataArea.CSSEnabled;
                }
            }else if (res instanceof CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3){
                CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3 resJSON = (CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3) res;
                if(txnCodeDesc !=null && txnCodeDesc.trim() != '')
                resJSON.Header.TxnCodeDescription = txnCodeDesc;
                if(cssEnabled !=null && cssEnabled.trim() != '')
                resJSON.DataArea.CSSEnabled = cssEnabled;
                if(dataExchangeObj != null){
                    dataExchangeObj.Status__c = resJSON.Header.Status;
                    dataExchangeObj.ReturnCodeDescription__c = resJSON.Header.ReturnCodeDescription;
                    dataExchangeObj.Algorithm__c = resJSON.DataArea.algorithm;
                    dataExchangeObj.Response_JSON__c = JSON.serialize(resJSON);
                    dataExchangeObj.CSS_Enabled__c = resJSON.DataArea.CSSEnabled;
                }
            }if (res instanceof CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3){
                CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3 resJSON = (CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3) res;
                if(txnCodeDesc !=null && txnCodeDesc.trim() != '')
                resJSON.Header.TxnCodeDescription = txnCodeDesc;
                if(cssEnabled !=null && cssEnabled.trim() != '')
                resJSON.DataArea.CSSEnabled = cssEnabled;
                if(dataExchangeObj != null){
                    dataExchangeObj.Status__c = resJSON.Header.Status;
                    dataExchangeObj.ReturnCodeDescription__c = resJSON.Header.ReturnCodeDescription;
                    dataExchangeObj.Algorithm__c = resJSON.DataArea.algorithm;
                    dataExchangeObj.Response_JSON__c = JSON.serialize(resJSON);
                    dataExchangeObj.CSS_Enabled__c = resJSON.DataArea.CSSEnabled;
                }
            }if (res instanceof CSS_WPR_TG_FaultDetailsDataResJSON_V3){
                CSS_WPR_TG_FaultDetailsDataResJSON_V3 resJSON = (CSS_WPR_TG_FaultDetailsDataResJSON_V3) res;
                if(txnCodeDesc !=null && txnCodeDesc.trim() != '')
                resJSON.Header.TxnCodeDescription = txnCodeDesc;
                if(cssEnabled !=null && cssEnabled.trim() != '')
                resJSON.DataArea.CSSEnabled = cssEnabled;
                if(dataExchangeObj != null){
                    dataExchangeObj.Status__c = resJSON.Header.Status;
                    dataExchangeObj.ReturnCodeDescription__c = resJSON.Header.ReturnCodeDescription;
                    dataExchangeObj.Algorithm__c = resJSON.DataArea.algorithm;
                    dataExchangeObj.Response_JSON__c = JSON.serialize(resJSON);
                    dataExchangeObj.CSS_Enabled__c = resJSON.DataArea.CSSEnabled;
                }
            }
        }catch(Exception ex){
            System.debug('in catch of assignResDetails of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            //Perform some clean up
        }
        return dataExchangeObj;
    }
    
    /*
     * This method is used for saving Req & Res details for tracking
     */ 
    /*public void assignTxnMsgCode(Object res, String txnMsgCode){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into assignTxnMsgCode method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        try{
            if (res instanceof CSS_WPR_TG_GetAssessDataResJSON2Apex_V2){
      CSS_WPR_TG_GetAssessDataResJSON2Apex_V2 resJSON = (CSS_WPR_TG_GetAssessDataResJSON2Apex_V2) res;
                resJSON.DataArea.TxnMsg = txnMsgCode;
            }else if (res instanceof CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2){
                CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2 resJSON = (CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2) res;
                resJSON.DataArea.TxnMsg = txnMsgCode;
            }if (res instanceof CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2){
                CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2 resJSON = (CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2) res;
                resJSON.DataArea.TxnMsg = txnMsgCode;
            }if (res instanceof CSS_WPR_TG_FaultDetailsDataResJSON_V2){
                CSS_WPR_TG_FaultDetailsDataResJSON_V2 resJSON = (CSS_WPR_TG_FaultDetailsDataResJSON_V2) res;
                resJSON.DataArea.TxnMsg = txnMsgCode;
            }
        }catch(Exception ex){
            System.debug('in catch of assignTxnMsgCode of CSS_FN_Triage_V2>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
     }*/
    
    /*
     * This method is used for checking the User's location is CSSEnabled or not
     */ 
    /*public String checkCSSEnabled(String userLocation){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into checkCSSEnabled method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$userLocation:'+userLocation);
        List<Account> accList;
        List<String> locList;
        String userLoc;
        try{
            if(userLocation == null || userLocation.trim() == '' || String.isBlank(userLocation) 
               || String.isEmpty(userLocation) || userLocation.length()<11){
                   return 'N';
            }
                        
            userLoc = userLocation.trim().substring(0, 11);
            accList = new List<Account>([Select Id, Location__c, IA_CSSEnabled__c from Account where IA_CSSEnabled__c=true and Location__c=:userLoc limit 1]);
            if(accList.size()>0)
                return 'Y';
            else
                return 'N';
        }catch(Exception ex){
            System.debug('in catch of checkCSSEnabled of CSS_FN_Triage_V2>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            locList=null;accList=null;userLoc=null;
        }
        return 'N';
    }*/
    
    /*
     * This method is used for checking the User's location is CSSEnabled or not
     */ 
    public String getFilteredUserLocation(String userLocation){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getFilteredUserLocation method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$userLocation:'+userLocation);
        List<Account> accList;
        List<String> locList;
        String userLoc;
        try{
         //Here do logic for length of 11 chars
         //String userLocation = reqJSON.DataArea.UserLocation;
         //locList = userLocation.trim().split(Pattern.quote('|'));
         locList = userLocation.trim().split('\\|');
         //locList = userLocation.trim().split(',');
         System.debug('locList size>>>>>>>>>>>:'+locList.size());
         if(locList ==null || locList.size()<=0){
            System.debug('enetered into first block of comma separated...locList:'+locList.size());
            if(userLocation.length()>=11)
                userLoc = userLocation.trim().substring(0, 11);
         }else{
            if(userLocation.contains('-P')){
                System.debug('enetered into -P block ...');
                for(String location :locList){
                    System.debug('location>>>>>>>>:'+location+' length>>>>:'+location.length());
                    if(location.contains('-P') && location.length()>=13){
                        userLoc = location.subString(0,13).replace('-P','');
                        System.debug('after removing -P userLoc>>>>>>>>:'+userLoc);
                        userLoc = userLoc.trim();
                        break;
                    }
                }
            }else {
                for(String location :locList){
                    if(location.length()>=11){
                        System.debug('enetered into else block of comma separated...');
                        userLoc = location.subString(0,11);
                        userLoc = userLoc.trim();
                        break;
                    }
                }
            }
         }
         System.debug('After validations inner userLoc>>>>>>:'+userLoc);
            
         }catch(Exception ex){
            System.debug('in catch of getFilteredUserLocation of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
         }finally {
            locList=null;accList=null;
         }
         return userLoc;
    }
    
    /*
     * This method is used for checking the User's location is CSSEnabled or not
     */ 
    public String getAdvancedRoleUserId(String inputUserId, String userLocation){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getAdvancedRoleUserId method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$inputUserId:'+inputUserId);
        List<User> userList;
        try{
            if(inputUserId == null || inputUserId.trim() == '' || String.isBlank(inputUserId) || String.isEmpty(inputUserId) ){
			//if SenderId is blank then do below logic
			System.debug('if inputUserId is null block...inputUserId>>>:'+inputUserId+' userLocation>>:'+userLocation);
                userList = new List<User>([Select Id, User_Location__c from User where User_Location__c=:userLocation and isActive=true and Profile.Name like '%Advanced%' limit 1]);
                if(userList.size()>0)
                    return (userList.get(0)).Id;
                else
                    return null;
            }else{
                //if SenderId & FederationId are not blank
                System.debug('if inputUserId not null block...inputUserId>>>:'+inputUserId+' userLocation>>:'+userLocation);
                userList = new List<User>([Select Id, FederationIdentifier from User where FederationIdentifier=:inputUserId and isActive=true and Profile.Name like '%Advanced%' limit 1]);
                if(userList.size()>0)
                    return (userList.get(0)).Id;
                else{
                    //if FederationId doesn't have records above then do below logic
                    System.debug('FederationId else block...inputUserId>>>:'+inputUserId+' userLocation>>:'+userLocation);
                    userList = new List<User>([Select Id, User_Location__c from User where User_Location__c=:userLocation and isActive=true and Profile.Name like '%Advanced%' limit 1]);
                    if(userList.size()>0)
                        return (userList.get(0)).Id;
                    else
                        return null;
                }
            }
        }catch(Exception ex){
            System.debug('in catch of getAdvancedRoleUserId of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            userList=null;
        }
        return null;
    }
    
    
    /*
     * This method is used for storing IAS recoprds in MDC
     */ 
    public static void storeIASRecordsInMDC(List<CSS_DataExchange_Parent__c> deObjList){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into storeIASRecordsInMDC method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        //List<CSS_DataExchange_Parent__c> deObjList;
        CSS_WPR_TG_IASMDCReqJSON mdcReqJSON;
        CSS_WPR_TG_IASMDCResJSON mdcResJSON;
        try{
            //Step1: pull IAS records
            /* deObjList = new List<CSS_DataExchange_Parent__c>(
                [Select Id, Name, ACCESS__c, Algorithm__c, Complaint_Text__c, Created_By__c, CSS_Enabled__c, CSS_Job_Number__c, Customer_Company_Name__c, 
                 ERT__c, MAKE__c, MDC_Sent_DateTime__c, MDC_Status__c, MODEL__c, PSN__c, Request_JSON__c, Response_JSON__c, ReturnCodeDescription__c, SenderID__c, 
                 SERVICEMODELNAME__c, ServiceName__c, ServiceVersion__c, Status__c, TargetID__c, ToolID__c, Updated_By__c, User_Location__c, User_Location_filtered__c, 
                 Version__c from CSS_DataExchange_Parent__c where MDC_Status__c=false and RecordType.Name='IA-Inbox']); */
            if(deObjList == null || deObjList.size()<=0){
                System.debug('############## No records found to process... ##############');
                return;
            }
            
            //calling getAccessToken Service
            String accessToken =  getTokenOfMDC();
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
               || String.isEmpty(accessToken) ){
                   css_utility.LogOutIntError('CSS_FN_Triage-storeIASRecordsInMDC', 'MDC Token service failed', 'MDC Token IS NULL', 'MDC');
                   return;
            }
            System.debug('accessToken>>>>>>>>>>>>>>>>>>>>:'+accessToken);
            
            //Prepare Request JSON
            mdcReqJSON = prepareReqJSONForMDC(deObjList);
            String mdcJSONReqBody = JSON.serialize(mdcReqJSON);
            System.debug('mdcJSONReqBody>>>>>>>>>>>>>>>>>>>>:'+mdcJSONReqBody);
            
            //calling diagnosticSRT webservice
            String endPointURL = CSS_getConnnectionDetails.getConnection('MachineDataCloud').End_Point__c;
            system.debug('endPointURL'+endPointURL);
            HttpResponse httpRes = executeRESTWebservice(mdcJSONReqBody, endPointURL, accessToken);
            if(httpRes == null || httpRes.getStatusCode() != 200){
                css_utility.LogOutIntError('CSS_FN_Triage-storeIASRecordsInMDC', 'MDC HttpResponse is null', 'MDC Webservice Execution failed', 'MachineDataCloud');
                return;
            }
            system.debug('IASMDCResponse>>>'+httpRes.getBody()+'-----> response --->'+httpRes);
            mdcResJSON = (CSS_WPR_TG_IASMDCResJSON)JSON.deserialize(httpRes.getBody(), CSS_WPR_TG_IASMDCResJSON.class);
			system.debug('mdcResJSON>>>>>>>>>>:'+mdcResJSON);
            
            if(mdcResJSON == null || mdcResJSON.Header == null || mdcResJSON.Header.Status != 'Success' || mdcResJSON.Header.ReturnCode != 'CG01'){
             System.debug('#################################Got Invalid Response Body##########################>>>>>>>>>>>>>>>>>>>:'+mdcResJSON);
                return;
            }
                        
            //update Records flag
            updateDERecords(deObjList);
            
        }catch(Exception ex){
            System.debug('in catch of storeIASRecordsInMDC of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            deObjList=null;
        }
    }
    
    public static String getTokenOfMDC(){
        System.debug('in getTokenOfMDC method...');
        String sEncryptToken;
        String sEndPointURL;
        DateTime dDtTime;
        String sDtTime;
        try {
            dDtTime = System.now();
            sDtTime = dDtTime.format('yyyy-MM-dd\'T\'HH:mm:ss.sss\'Z\'', 'GMT');
            System.debug('sDtTime>>>>>>>>>>>>:'+sDtTime);
            //sEndPoint = 'https://connectedsolutions-dev.cummins.com/IASRecords/v1/iasjsons';
            sEndPointURL = (CSS_getConnnectionDetails.getConnection('MachineDataCloud')).End_Point__c;
            System.debug('sEndPointURL>>>>>>>>>>>>>:'+sEndPointURL);
            string sPsPhrase = 'wEC38PruRaSw.bEm';
            Blob bIVKey = Blob.valueOf(sPsPhrase);
            string sUnEncrypt = 'IAJobs-'+sDtTime+ '|' + sDtTime;
            System.debug('sUnEncrypt>>>>:'+sUnEncrypt);
            Blob bTokenString = Blob.valueOf(sUnEncrypt);
            Blob bStrEncrypt = Crypto.encrypt('AES128',bIVKey,bIVKey,bTokenString);
            sEncryptToken = EncodingUtil.base64Encode(bStrEncrypt);
            System.debug('sEncryptToken>>>>>>:'+sEncryptToken);
           
        }catch(exception ex) {
           System.debug('in catch of getTokenOfMDC of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return sEncryptToken;
   }
    
     public static CSS_WPR_TG_IASMDCReqJSON prepareReqJSONForMDC(List<CSS_DataExchange_Parent__c> deObjList){
        System.debug('in prepareReqJSONForMDC method...');
        CSS_WPR_TG_IASMDCReqJSON mdcReqJSON;
        List<CSS_WPR_TG_IASMDCReqJSON.DataArea> dataAreaList;
        CSS_WPR_TG_IASMDCReqJSON.Header headerObj = null;
        CSS_WPR_TG_IASMDCReqJSON.DataArea dataAreaObj = null;
        CSS_WPR_TG_IASMDCReqJSON.Result resultObj = null;
        CSS_WPR_TG_IASMDCReqJSON.PrioritizedData prioritizedDataObj = null;
        CSS_WPR_TG_IASMDCReqJSON.UnPrioritizedData unPrioritizedDataObj = null;
        CSS_WPR_TG_IASMDCReqJSON.Relfc relfcObj = null;
        CSS_DataExchange_Parent__c dataExParentObj;
        DateTime dDtTime;
        String sDtTime;
        try {
            //Prepare Request JSON
        mdcReqJSON = new CSS_WPR_TG_IASMDCReqJSON();
            headerObj = new CSS_WPR_TG_IASMDCReqJSON.Header();
            dataAreaList = new List<CSS_WPR_TG_IASMDCReqJSON.DataArea>();
            
            dataAreaObj = new CSS_WPR_TG_IASMDCReqJSON.DataArea();
            resultObj = new CSS_WPR_TG_IASMDCReqJSON.Result();
            prioritizedDataObj = new CSS_WPR_TG_IASMDCReqJSON.PrioritizedData();
            unPrioritizedDataObj = new CSS_WPR_TG_IASMDCReqJSON.UnPrioritizedData();
            relfcObj = new CSS_WPR_TG_IASMDCReqJSON.Relfc();
            
            headerObj.ServiceName = 'SendIARecords';
            headerObj.ServiceVersion = '1.0';
            headerObj.Target = 'MachineData';
            headerObj.SenderID = 'CSS';
            
            dDtTime = System.now();
            sDtTime = dDtTime.format('yyyy-MM-dd\'T\'HH:mm:ss.sss\'Z\'', 'GMT');
            headerObj.RunTime = 'IAJobs-'+sDtTime;
            
            for(integer i=0;i<deObjList.size();i++){
                dataExParentObj = deObjList.get(i);
                dataAreaObj = assignValues(dataExParentObj);
                dataAreaList.add(dataAreaObj);
            }
                
            mdcReqJSON.Header = headerObj;
            mdcReqJSON.DataArea = dataAreaList;
           
        }catch(exception ex) {
           System.debug('in catch of prepareReqJSONForMDC of CSS_FN_Triage_v2 >>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return mdcReqJSON;
   }
    
    //This method is used for assignValues
    public static CSS_WPR_TG_IASMDCReqJSON.DataArea assignValues(CSS_DataExchange_Parent__c dataExParentObj){
        System.debug('Entered into assignValues...');
        CSS_WPR_TG_IASMDCReqJSON.DataArea dataAreaObj = new CSS_WPR_TG_IASMDCReqJSON.DataArea();
        try{
            dataAreaObj.Id = dataExParentObj.Id;
            dataAreaObj.IASNumber = dataExParentObj.Name;
            dataAreaObj.ServiceName = dataExParentObj.ServiceName__c;
            dataAreaObj.ServiceVersion = dataExParentObj.ServiceVersion__c;
            dataAreaObj.ToolID = dataExParentObj.ToolID__c;
            dataAreaObj.SenderID = dataExParentObj.SenderID__c;
            dataAreaObj.TargetID = dataExParentObj.TargetID__c;
            dataAreaObj.PSN = dataExParentObj.PSN__c;
            dataAreaObj.SERVICEMODELNAME = dataExParentObj.SERVICEMODELNAME__c;
            dataAreaObj.ERT = dataExParentObj.ERT__c;
            dataAreaObj.MAKE = dataExParentObj.MAKE__c;
            dataAreaObj.MODEL = dataExParentObj.MODEL__c;
            dataAreaObj.ACCESS = dataExParentObj.ACCESS__c;
            dataAreaObj.UserLocation = dataExParentObj.User_Location__c;
            dataAreaObj.CustomerName = dataExParentObj.Customer_Company_Name__c;
            dataAreaObj.ComplaintText = dataExParentObj.Complaint_Text__c;
            dataAreaObj.Algorithm = dataExParentObj.Algorithm__c;
            dataAreaObj.CSSEnabled = dataExParentObj.CSS_Enabled__c;
            dataAreaObj.CSSJobNumber = dataExParentObj.CSS_Job_Number__c;
            dataAreaObj.Status = dataExParentObj.Status__c;
            dataAreaObj.ReturnCodeDescription = dataExParentObj.ReturnCodeDescription__c;
            dataAreaObj.Version = dataExParentObj.Version__c;
            dataAreaObj.CreatedBy = String.valueOf(dataExParentObj.Created_By__c);
            dataAreaObj.UpdatedBy = String.valueOf(dataExParentObj.Updated_By__c);
            dataAreaObj.CreatedDateTime = String.valueOf(dataExParentObj.CreatedDate);
            dataAreaObj.UpdatedDateTime = String.valueOf(dataExParentObj.LastModifiedDate);
            System.debug('CreatedDateTime>>>:'+dataAreaObj.CreatedDateTime+' UpdatedDateTime>>>>:'+dataAreaObj.UpdatedDateTime);
            
            CSS_WPR_TG_IASMDCReqJSON.Result resultObj = new CSS_WPR_TG_IASMDCReqJSON.Result();
            List<CSS_WPR_TG_IASMDCReqJSON.PrioritizedData> priList = new List<CSS_WPR_TG_IASMDCReqJSON.PrioritizedData>(); 
            List<CSS_WPR_TG_IASMDCReqJSON.UnPrioritizedData> unPriList = new List<CSS_WPR_TG_IASMDCReqJSON.UnPrioritizedData>(); 
            
            if(dataExParentObj.ServiceName__c !=null && dataExParentObj.ServiceName__c == 'GetPrioritizedFC'){
                CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3 tgPriFCsResJSON = CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.parse(dataExParentObj.Response_JSON__c);
				getPriUnPriListsOfFC(priList, unPriList, tgPriFCsResJSON);
            }else if(dataExParentObj.ServiceName__c !=null && dataExParentObj.ServiceName__c == 'GetLaborHrsData'){
                CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3 tgLaborHrsDataResJSON = CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.parse(dataExParentObj.Response_JSON__c);
                getPriUnPriListsOfLaborHours(priList, unPriList, tgLaborHrsDataResJSON);
            }else if(dataExParentObj.ServiceName__c !=null && dataExParentObj.ServiceName__c == 'GetAssessData'){
                CSS_WPR_TG_FaultDetailsDataResJSON_V3 tgFaultDetailsDataResJSON = CSS_WPR_TG_FaultDetailsDataResJSON_V3.parse(dataExParentObj.Response_JSON__c);
				getPriUnPriListsOfFaultDetails(priList, unPriList, tgFaultDetailsDataResJSON);
            }
            
            resultObj.prioritizedData = priList;
            resultObj.unPrioritizedData = unPriList;
            dataAreaObj.Result = resultObj;
        }catch(Exception e){
            System.debug('in catch of assignValues of CSS_FN_Triage_v2 >>>>>getLineNumber is ::'+e.getLineNumber()+' Exception Message>>>'+e.getMessage());
        }
        return dataAreaObj;
    }
    
    //This method is used for getting PriUnPriLists Of FaultDetails
    public static void getPriUnPriListsOfFaultDetails(List<CSS_WPR_TG_IASMDCReqJSON.PrioritizedData> priList, List<CSS_WPR_TG_IASMDCReqJSON.UnPrioritizedData> unPriList, CSS_WPR_TG_FaultDetailsDataResJSON_V3 tgFaultDetailsDataResJSON){
        System.debug('Entered into getPriUnPriListsOfFaultDetails...');
        CSS_WPR_TG_IASMDCReqJSON.PrioritizedData priObj;
        CSS_WPR_TG_IASMDCReqJSON.UnPrioritizedData unPriObj;
        List<CSS_WPR_TG_IASMDCReqJSON.Relfc> relfcListMDC;
        CSS_WPR_TG_IASMDCReqJSON.Relfc relfcObjMDC;
        try{
            //Preparing Prioritized FCs
            List<CSS_WPR_TG_FaultDetailsDataResJSON_V3.PrioritizedData> resPriFCList = tgFaultDetailsDataResJSON.DataArea.prioritizedData;
            if(resPriFCList != null && resPriFCList.size()>0){
                for(CSS_WPR_TG_FaultDetailsDataResJSON_V3.PrioritizedData fcObj: resPriFCList){
                    priObj = new CSS_WPR_TG_IASMDCReqJSON.PrioritizedData();
                    priObj.prifc = fcObj.prifc;
                    //priObj.lhrs = fcObj.lhrs;
                    priObj.rootCause1 = fcObj.rootCause1;
                    priObj.rootCause2 = fcObj.rootCause2;
                    priObj.rootCause3 = fcObj.rootCause3;
                    priObj.rootCause4 = fcObj.rootCause4;
                    priObj.rc1Likelihood = fcObj.rc1Likelihood;
                    priObj.rc2Likelihood = fcObj.rc2Likelihood;
                    priObj.rc3Likelihood = fcObj.rc3Likelihood;
                    priObj.rc4Likelihood = fcObj.rc4Likelihood;
                    
                    //Related FC Codes
                    relfcListMDC = new List<CSS_WPR_TG_IASMDCReqJSON.Relfc>();
                    List<CSS_WPR_TG_FaultDetailsDataResJSON_V3.Relfc> relFCList = fcObj.relfc;
                    if(relFCList != null && relFCList.size()>0){
                        for(Integer relIndex=0; relIndex<relFCList.size(); relIndex++){
                            relfcObjMDC = new CSS_WPR_TG_IASMDCReqJSON.Relfc();
                            CSS_WPR_TG_FaultDetailsDataResJSON_V3.Relfc relFCObj = relFCList.get(relIndex);
                            relfcObjMDC.rfc = relFCObj.rfc;
                            relfcListMDC.add(relfcObjMDC);
                        }
                    }
                    
                    priObj.relfc = relfcListMDC;
                    priList.add(priObj);
                }
            }
            
            //Preparing UnPrioritized FCs
            List<CSS_WPR_TG_FaultDetailsDataResJSON_V3.UnPrioritizedData> resUnPriFCList = tgFaultDetailsDataResJSON.DataArea.unPrioritizedData;
            if(resUnPriFCList != null && resUnPriFCList.size()>0){
                for(CSS_WPR_TG_FaultDetailsDataResJSON_V3.UnPrioritizedData fcObj: resUnPriFCList){
                    unPriObj = new CSS_WPR_TG_IASMDCReqJSON.UnPrioritizedData();
                    unPriObj.upfc = fcObj.upfc;
                    unPriObj.rc = fcObj.rc;
                    unPriList.add(unPriObj);
                }
            }
        }catch(Exception e){
            System.debug('in catch of getPriUnPriListsOfFaultDetails of CSS_FN_Triage_v2 >>>>>getLineNumber is ::'+e.getLineNumber()+' Exception Message>>>'+e.getMessage());
        }
    }
    
    
    //This method is used for getting PriUnPriLists Of FaultDetails
    public static void getPriUnPriListsOfLaborHours(List<CSS_WPR_TG_IASMDCReqJSON.PrioritizedData> priList, List<CSS_WPR_TG_IASMDCReqJSON.UnPrioritizedData> unPriList, CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3 tgLaborHrsDataResJSON){
        System.debug('Entered into getPriUnPriListsOfLaborHours...');
        CSS_WPR_TG_IASMDCReqJSON.PrioritizedData priObj;
        CSS_WPR_TG_IASMDCReqJSON.UnPrioritizedData unPriObj;
        List<CSS_WPR_TG_IASMDCReqJSON.Relfc> relfcListMDC;
        CSS_WPR_TG_IASMDCReqJSON.Relfc relfcObjMDC;
        try{
            //Preparing Prioritized FCs
            List<CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.PrioritizedData> resPriFCList = tgLaborHrsDataResJSON.DataArea.prioritizedData;
            if(resPriFCList != null && resPriFCList.size()>0){
                for(CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.PrioritizedData fcObj: resPriFCList){
                    priObj = new CSS_WPR_TG_IASMDCReqJSON.PrioritizedData();
                    priObj.prifc = fcObj.prifc;
                    priObj.lhrs = fcObj.lhrs;
                    
                    //Related FC Codes
                    relfcListMDC = new List<CSS_WPR_TG_IASMDCReqJSON.Relfc>();
                    List<CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.Relfc> relFCList = fcObj.relfc;
                    if(relFCList != null && relFCList.size()>0){
                        for(Integer relIndex=0; relIndex<relFCList.size(); relIndex++){
                            relfcObjMDC = new CSS_WPR_TG_IASMDCReqJSON.Relfc();
                            CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.Relfc relFCObj = relFCList.get(relIndex);
                            relfcObjMDC.rfc = relFCObj.rfc;
                            relfcListMDC.add(relfcObjMDC);
                        }
                    }
                    
                    priObj.relfc = relfcListMDC;
                    priList.add(priObj);
                }
            }
            
            //Preparing UnPrioritized FCs
            List<CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.UnPrioritizedData> resUnPriFCList = tgLaborHrsDataResJSON.DataArea.unPrioritizedData;
            if(resUnPriFCList != null && resUnPriFCList.size()>0){
                for(CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3.UnPrioritizedData fcObj: resUnPriFCList){
                    unPriObj = new CSS_WPR_TG_IASMDCReqJSON.UnPrioritizedData();
                    unPriObj.upfc = fcObj.upfc;
                    unPriObj.rc = fcObj.rc;
                    unPriList.add(unPriObj);
                }
            }
        }catch(Exception e){
            System.debug('in catch of getPriUnPriListsOfLaborHours of CSS_FN_Triage_v3 >>>>>getLineNumber is ::'+e.getLineNumber()+' Exception Message>>>'+e.getMessage());
        }
    }
    
    //This method is used for getting PriUnPriLists Of FaultDetails
    public static void getPriUnPriListsOfFC(List<CSS_WPR_TG_IASMDCReqJSON.PrioritizedData> priList, List<CSS_WPR_TG_IASMDCReqJSON.UnPrioritizedData> unPriList, CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3 tgPriFCsResJSON){
        System.debug('Entered into getPriUnPriListsOfFC...');
        CSS_WPR_TG_IASMDCReqJSON.PrioritizedData priObj;
        CSS_WPR_TG_IASMDCReqJSON.UnPrioritizedData unPriObj;
        List<CSS_WPR_TG_IASMDCReqJSON.Relfc> relfcListMDC;
        CSS_WPR_TG_IASMDCReqJSON.Relfc relfcObjMDC;
        try{
            //Preparing Prioritized FCs
            List<CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.PrioritizedData> resPriFCList = tgPriFCsResJSON.DataArea.prioritizedData;
            if(resPriFCList != null && resPriFCList.size()>0){
                for(CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.PrioritizedData fcObj: resPriFCList){
                    priObj = new CSS_WPR_TG_IASMDCReqJSON.PrioritizedData();
                    priObj.prifc = fcObj.prifc;
                    
                    //Related FC Codes
                    relfcListMDC = new List<CSS_WPR_TG_IASMDCReqJSON.Relfc>();
                    List<CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.Relfc> relFCList = fcObj.relfc;
                    if(relFCList != null && relFCList.size()>0){
                        for(Integer relIndex=0; relIndex<relFCList.size(); relIndex++){
                            relfcObjMDC = new CSS_WPR_TG_IASMDCReqJSON.Relfc();
                            CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.Relfc relFCObj = relFCList.get(relIndex);
                            relfcObjMDC.rfc = relFCObj.rfc;
                            relfcListMDC.add(relfcObjMDC);
                        }
                    }
                    
                    priObj.relfc = relfcListMDC;
                    priList.add(priObj);
                }
            }
            
            //Preparing UnPrioritized FCs
            List<CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.UnPrioritizedData> resUnPriFCList = tgPriFCsResJSON.DataArea.unPrioritizedData;
            if(resUnPriFCList != null && resUnPriFCList.size()>0){
                for(CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.UnPrioritizedData fcObj: resUnPriFCList){
                    unPriObj = new CSS_WPR_TG_IASMDCReqJSON.UnPrioritizedData();
                    unPriObj.upfc = fcObj.upfc;
                    unPriObj.rc = fcObj.rc;
                    unPriList.add(unPriObj);
                }
            }
        }catch(Exception e){
            System.debug('in catch of getPriUnPriListsOfFC of CSS_FN_Triage_v3 >>>>>getLineNumber is ::'+e.getLineNumber()+' Exception Message>>>'+e.getMessage());
        }
    }
    
    public static void updateDERecords(List<CSS_DataExchange_Parent__c> deObjList){
        System.debug('in updateDERecords method...');
        CSS_DataExchange_Parent__c deObj;
        try {
        for(integer i=0;i<deObjList.size();i++){
                deObj = deObjList.get(i);
                deObj.MDC_Status__c = true;
                deObj.MDC_Sent_DateTime__c = System.now();
            }
            update deObjList;
            System.debug('############### updated DERecords successfully... #################');
        }catch(exception ex) {
           System.debug('in catch of updateDERecords of CSS_FN_Triage_V3>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
   }
    
    //This method is used for executing MDC REST webservice
    public static HttpResponse executeRESTWebservice(String jSONReqBody, String endPointURL, String accessToken){
        System.debug('Entered into Execute Rest Webservice');
         HttpRequest httpReq;
         HttpResponse httpRes;
        try{
            System.debug('endPointURL>>>>>'+endPointURL+' jSONReqBody>>>'+jSONReqBody);
            httpReq = new HttpRequest();
            httpReq.setHeader('Token', accessToken);
            httpReq.setHeader('Content-Type', 'application/json');
            httpReq.setMethod('POST');
            httpReq.setTimeout(120000);
            httpReq.setEndpoint(endPointURL);
            httpReq.setBody(jSONReqBody);
            httpRes = new Http().send(httpReq);
            system.debug('RESPONSE_BODY>>>>>>>>>'+httpRes.getbody()+' httpRes getStatusCode>>>>> '+httpRes.getStatusCode());
        }catch(Exception e){
            System.debug('in catch of executeRESTWebservice of CSS_FN_Triage_v2 >>>>>getLineNumber is ::'+e.getLineNumber()+' Exception Message>>>'+e.getMessage());
        }
        return httpRes;
    }
    
    private void assignInputValues(WrapperInput wrapperObj, CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 reqJSON){
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
            wrapperObj.IASNumber = reqJSON.DataArea.IASNumber.trim();
            System.debug('ServiceName>>>:'+reqJSON.Header.ServiceName+' psn>>>:'+reqJSON.DataArea.PSN+' smn>>>:'+reqJSON.DataArea.SERVICEMODELNAME+' ERT>>>:'+reqJSON.DataArea.ERT+' MAKE>>>:'+reqJSON.DataArea.MAKE+' MODEL>>>:'+reqJSON.DataArea.MODEL+' ACCESS>>>:'+reqJSON.DataArea.ACCESS);
        }catch(Exception e){
            System.debug('in catch of assignInputValues of CSS_FN_Triage_v2 >>>>>getLineNumber is ::'+e.getLineNumber()+' Exception Message>>>'+e.getMessage());
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
        public String IASNumber;
        public String CSSJobNumber;
        public String CSSEnabled;
        public String userLocation;
        public String CurrentDate;
        public List<CSS_WPR_TG_IAAppointmentsResJSON_V1.IAAppointments> iaAppointList;
    }
    
}