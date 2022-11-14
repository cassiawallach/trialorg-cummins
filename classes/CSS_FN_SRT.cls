/**********************************************************************
Name: CSS_FN_SRT
Copyright © 2016 Cummins
=======================================================================
=======================================================================
Purpose:    This class is used for Business Logics of Triage functionality to
            handle reusable code modules such as Create/Update/View/Delete/etc operations
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        01/02/2016     INITIAL DEVELOPMENT
1.1     Vignesh S         07/25/2017     Component lookup(Failure code) WS callout - RTC#105212
1.2     Vignesh/Rajkumar  02/12/2018     Field Action SRT WS callout - RTC#84384
***********************************************************************
***********************************************************************/
public class CSS_FN_SRT {
    // This below methods till line no : 627 are commented as they are not being used yet and will be taken up when code modularisation is started
    /**
     * This is used for Diagnostic SRT webservice
     * 
     */
    /*   @future(callout=true)
    public static void diagnosticSRT(MAP<ID,ID> jobOrder, Map<ID, String> solName, String serviceModel, String jobName,decimal claim){
    System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into diagnosticSRT webservice of CSS_FN_SRT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_J2ADiagnostic_SRT diagSRTResWC;
        try{
            //calling getAccessToken Service
            String accessToken = CSS_WS_SRT1.getAccessTokenOfOAGOAuth();
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
               || String.isEmpty(accessToken) ){
                   css_utility.LogOutIntError('CSS_FN_SRT-diagnosticSRT', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                   return;
            }
            //Prepare Request JSON
            CSS_WPR_SRT_DiagnosticSRTReqJSON diagReqJSON = CSS_WS_SRT1.prepareReqJSONForDiagSRT(jobOrder, solName, serviceModel, jobName, claim);
            String diagSRTJSONReqBody = JSON.serialize(diagReqJSON);
            diagSRTJSONReqBody = diagSRTJSONReqBody.replace('Case_Z', 'Case'); //this stmt is used bcz Case is reserved keyword in WC
            System.debug('diagSRTJSONReqBody>>>>>>>>>>>>>>>>>>>>:'+diagSRTJSONReqBody);

            //calling diagnosticSRT webservice
            String endPointURL = CSS_getConnnectionDetails.getConnection('SRT').End_Point__c;
            HttpResponse httpRes = CSS_WS_SRT1.executeRESTWebservice(diagSRTJSONReqBody, endPointURL, accessToken);
            if(httpRes == null || httpRes.getStatusCode() != 200){
                css_utility.LogOutIntError('CSS_FN_SRT-diagnosticSRT', 'Diagnosis SRT HttpResponse is null', 'Diagnosis SRT Webservice Execution failed', 'SRT');
                return;
            }else if(httpRes.getBody().contains('OSB Service Callout action received SOAP Fault response') ){
                System.debug('Incorrect json format-- STATUS:'+httpRes.getStatus()+'STATUS_CODE:'+httpRes.getStatusCode());
                css_utility.LogOutIntError('CSS_FN_SRT-diagnosticSRT', 'Diagnosis SRT gives wrong response', 'OSB Service Callout action received SOAP Fault response', 'SRT');
                return;
            }
            diagSRTResWC = (CSS_J2ADiagnostic_SRT)JSON.deserializeStrict(httpRes.getBody(), CSS_J2ADiagnostic_SRT.class);

            //insert Diagnostic SRTs
            insertDiagnosticSRTs(diagSRTResWC, jobOrder, solName);

        }catch(Exception ex){
            System.debug('in catch of diagnosticSRT of CSS_FN_SRT >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
    }

    /**
     * This is used for Repair SRT webservice
     * 
     */
    /*  @future(callout=true)
    public static void repairSRT(List<String> solComp){
    System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into repairSRT webservice of CSS_FN_SRT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_J2ARepair_SRT repairSRTResWC;
        try{
            //calling getAccessToken Service
            String accessToken = CSS_WS_SRT1.getAccessTokenOfOAGOAuth();
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
               || String.isEmpty(accessToken) ){
                   css_utility.LogOutIntError('CSS_FN_SRT-repairSRT', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                   return;
            }
            //Prepare Request JSON
            CSS_WPR_SRT_RepairSRTReqJSON repairReqJSON = CSS_WS_SRT1.prepareReqJSONForRepairSRT(solComp);
            String repairSRTJSONReqBody = JSON.serialize(repairReqJSON);
            System.debug('repairSRTJSONReqBody>>>>>>>>>>>>>>>>>>>>:'+repairSRTJSONReqBody);

            //calling RepairSRT webservice
            String endPointURL = CSS_getConnnectionDetails.getConnection('SRT').End_Point__c;
            HttpResponse httpRes = CSS_WS_SRT1.executeRESTWebservice(repairSRTJSONReqBody, endPointURL, accessToken);
            if(httpRes == null || httpRes.getStatusCode() != 200){
                css_utility.LogOutIntError('CSS_FN_SRT-diagnosticSRT', 'Repair SRT HttpResponse is null', 'Repair SRT Webservice Execution failed', 'SRT');
                return;
            }
            repairSRTResWC = (CSS_J2ARepair_SRT)JSON.deserializeStrict(httpRes.getBody(), CSS_J2ARepair_SRT.class);

            //insert Repair SRTs
            insertRepairSRTs(repairSRTResWC, solComp);

        }catch(Exception ex){
            System.debug('in catch of repairSRT of CSS_FN_SRT >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
    }


    /**
     * This is used for GetPartsList SRT webservice
     * 
     */
    /*   public static CSS_getPartsListSRTResponseJ2A getPartsListSRT(CSS_getPartsListSRTRequestJ2A getPartsListSRTReq){
    System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getPartsListSRT webservice of CSS_FN_SRT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_getPartsListSRTResponseJ2A partsListSRTResWC;
        try{
            //calling getAccessToken Service
            String accessToken = CSS_WS_SRT1.getAccessTokenOfOAGOAuth();
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
               || String.isEmpty(accessToken) ){
                   css_utility.LogOutIntError('CSS_FN_SRT-getPartsListSRT', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                   return new CSS_getPartsListSRTResponseJ2A();
            }

            //Serialize Request JSON
            String partsListSRTJSONReqBody = JSON.serialize(getPartsListSRTReq);
            System.debug('partsListSRTJSONReqBody>>>>>>>>>>>>>>>>>>>>:'+partsListSRTJSONReqBody);
            partsListSRTJSONReqBody=partsListSRTJSONReqBody.remove('\\');
        partsListSRTJSONReqBody=partsListSRTJSONReqBody.remove('"[');
        partsListSRTJSONReqBody=partsListSRTJSONReqBody.remove(']"');

            //calling PartsListSRT webservice
            String endPointURL = CSS_getConnnectionDetails.getConnection('SRT').End_Point__c;
            endPointURL = endPointURL.substring(0, endPointURL.indexOf('css',0))+'css/srtpartslist';
            HttpResponse httpRes = CSS_WS_SRT1.executeRESTWebservice(partsListSRTJSONReqBody, endPointURL, accessToken);
            if(httpRes == null || httpRes.getStatusCode() != 200){
                css_utility.LogOutIntError('CSS_FN_SRT-diagnosticSRT', 'PartsListSRT HttpResponse is null', 'PartsListSRT Webservice Execution failed', 'SRT');
                return new CSS_getPartsListSRTResponseJ2A();
            }
            partsListSRTResWC = (CSS_getPartsListSRTResponseJ2A)JSON.deserializeStrict(httpRes.getBody(), CSS_getPartsListSRTResponseJ2A.class);

        }catch(Exception ex){
            System.debug('in catch of getPartsListSRT of CSS_FN_SRT >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return partsListSRTResWC;
    }


    /**
     * This is used for Admin SRT webservice & PMFlag webservice
     * 
     */
    /*  public static List<CSS_srt__c> getAllSRTs(String jobId,String PMflag,String srtType){
    System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getAllSRTs webservice of CSS_FN_SRT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_getAllSRTResponseJ2A adminSRTResWC = null;
        List<CSS_srt__c> dataAdminSRT = null;
        String adminSRTWSError = null;
        String srtCategory = null;
        try{
            dataAdminSRT = new List<CSS_srt__c>();
            //calling getAccessToken Service
            String accessToken = CSS_WS_SRT1.getAccessTokenOfOAGOAuth();
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
               || String.isEmpty(accessToken) ){
                   css_utility.LogOutIntError('CSS_FN_SRT-getAllSRTs', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                   return dataAdminSRT;
            }

            //Prepare Request JSON
            css_job_order__c jobOrderObj = [select name,Claim_No__c,Service_Model__c,Equipment_ID__c,Qsol_Engine_Family_Code__c,AccessCode__c from css_job_order__c where Id=:jobId limit 1];
            system.debug('css_job_order__c record is>>>>>>>>>>>>>>:'+jobOrderObj);
            srtCategory = 'General, Miscellaneous';
            CSS_WPR_SRT_AdminSRTReqJSON adminReqJSON = CSS_WS_SRT1.prepareReqJSONForSRTWS(jobId, srtType, jobOrderObj, srtCategory);
            String adminSRTJSONReqBody = JSON.serialize(adminReqJSON);
            System.debug('adminSRTJSONReqBody>>>>>>>>>>>>>>>>>>>>:'+adminSRTJSONReqBody);

            //calling Admin SRT webservice
            String endPointURL = CSS_getConnnectionDetails.getConnection('SRT').End_Point__c;
            endPointURL = endPointURL.substring(0,endPointURL.indexOf('css',0))+'css/srtlookup';
            HttpResponse httpRes = CSS_WS_SRT1.executeRESTWebservice(adminSRTJSONReqBody, endPointURL, accessToken);
            if(httpRes == null || httpRes.getStatusCode() != 200){
                //here save this error
adminSRTWSError = 'Admin SRT Webservice Execution failed';
            }else{
                adminSRTResWC = (CSS_getAllSRTResponseJ2A)JSON.deserializeStrict(httpRes.getBody(), CSS_getAllSRTResponseJ2A.class);
            dataAdminSRT = getAdminSRTsFromAdminResWC(adminSRTResWC, jobOrderObj.AccessCode__c, jobId);
            }

            //calling Admin PMFlag SRT webservice
            if(PMflag == 'Y'){
                System.debug('Before calling PMFlag Service...');
                srtCategory = 'Service, Maintenance, Contract Repair';
                adminReqJSON.DataArea.SRTCategory = srtCategory;
                //adminReqJSON = CSS_WS_SRT1.prepareReqJSONForSRTWS(jobId, srtType, jobOrderObj, srtCategory);
                adminSRTJSONReqBody = JSON.serialize(adminReqJSON);
                System.debug('PMFlag adminSRTJSONReqBody>>>>>>>>>>>>>>>>>>>>:'+adminSRTJSONReqBody);

                httpRes = CSS_WS_SRT1.executeRESTWebservice(adminSRTJSONReqBody, endPointURL, accessToken);
                if(httpRes == null || httpRes.getStatusCode() != 200){
                    //here store this error with above error
if(adminSRTWSError !=null)
                        css_utility.LogOutIntError('CSS_FN_SRT-getAllSRTs', 'getAllSRTs services HttpResponse is null', adminSRTWSError+'&&'+'getAllSRTs PMFlag Webservice Execution failed', 'SRT');
                    else
                    css_utility.LogOutIntError('CSS_FN_SRT-getAllSRTs', 'getAllSRTs services HttpResponse is null', 'getAllSRTs PMFlag Webservice Execution failed', 'SRT');
                    return dataAdminSRT;
                }else{
                    adminSRTResWC = (CSS_getAllSRTResponseJ2A)JSON.deserializeStrict(httpRes.getBody(), CSS_getAllSRTResponseJ2A.class);
                    List<CSS_srt__c> dataAdminPMSRTList = getAdminSRTsFromAdminResWC(adminSRTResWC, jobOrderObj.AccessCode__c, jobId);
                    dataAdminSRT.addAll(dataAdminPMSRTList);
                }
            }
        }catch(Exception ex){
            System.debug('in catch of getAllSRTs of CSS_FN_SRT >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return dataAdminSRT;
    }


    /**
     * This is used for Additional Diagnostic/repair SRT webservice
     * 
     */
    /* public static List<CSS_srt__c> getAllDigRepSRTs(String jobId, String srtType){
    System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getAllDigRepSRTs method of CSS_FN_SRT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_getAllSRTResponseJ2A addlDiagSRTResWC = null;
        List<CSS_srt__c> dataDiaRepSRT = null;
        String srtCategory = null;
        try{
            dataDiaRepSRT = new List<CSS_srt__c>();
            //calling getAccessToken Service
            String accessToken = CSS_WS_SRT1.getAccessTokenOfOAGOAuth();
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
               || String.isEmpty(accessToken) ){
                   css_utility.LogOutIntError('CSS_FN_SRT-getAllDigRepSRTs', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                   return dataDiaRepSRT;
            }

            //Prepare Request JSON
            css_job_order__c jobOrderObj = [select name,Claim_No__c,Service_Model__c,Equipment_ID__c,Qsol_Engine_Family_Code__c,AccessCode__c from css_job_order__c where Id=:jobId limit 1];
            system.debug('css_job_order__c record is>>>>>>>>>>>>>>:'+jobOrderObj);
            srtCategory = '';
            CSS_WPR_SRT_AdminSRTReqJSON addlDiagReqJSON = CSS_WS_SRT1.prepareReqJSONForSRTWS(jobId, srtType, jobOrderObj, srtCategory);
            String addlDiagSRTJSONReqBody = JSON.serialize(addlDiagReqJSON);
            System.debug('addlDiagSRTJSONReqBody>>>>>>>>>>>>>>>>>>>>:'+addlDiagSRTJSONReqBody);

            //calling Additional Dignostic/Repair SRT webservice
            String endPointURL = CSS_getConnnectionDetails.getConnection('SRT').End_Point__c;
            endPointURL = endPointURL.substring(0, endPointURL.indexOf('css',0))+'css/srtlookup';
            HttpResponse httpRes = CSS_WS_SRT1.executeRESTWebservice(addlDiagSRTJSONReqBody, endPointURL, accessToken);
            if(httpRes == null || httpRes.getStatusCode() != 200){
                css_utility.LogOutIntError('CSS_FN_SRT-getAllDigRepSRTs', 'getAllDigRepSRTs HttpResponse is null', 'Additional Dignostic/Repair SRT Webservice Execution failed', 'SRT');
                return dataDiaRepSRT;
            }
            addlDiagSRTResWC = (CSS_getAllSRTResponseJ2A)JSON.deserializeStrict(httpRes.getBody(), CSS_getAllSRTResponseJ2A.class);
            dataDiaRepSRT = getAdminSRTsFromAdminResWC(addlDiagSRTResWC, jobOrderObj.AccessCode__c, jobId);

        }catch(Exception ex){
            System.debug('in catch of getAllDigRepSRTs of CSS_FN_SRT >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return dataDiaRepSRT;
    }


    /**
     * This is used for getting OverlapSRTRecords SRT webservice
     * 
     */
    /* public static CSS_OverlapSRTResponse getOverlapSRTRecords(CSS_OverlapSRTReq overlapSRTReqJSON){
    System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getOverlapSRTRecords webservice of CSS_FN_SRT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_OverlapSRTResponse overlapSRTResWC;
        try{
            overlapSRTResWC = new CSS_OverlapSRTResponse();
            //calling getAccessToken Service
            String accessToken = CSS_WS_SRT1.getAccessTokenOfOAGOAuth();
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
               || String.isEmpty(accessToken) ){
                   css_utility.LogOutIntError('CSS_FN_SRT-getOverlapSRTRecords', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                   return overlapSRTResWC;
            }

            //Prepare Request JSON
String overlapSRTJSONReqBody = JSON.serialize(overlapSRTReqJSON);
            System.debug('overlapSRTJSONReqBody>>>>>>>>>>>>>>>>>>>>:'+overlapSRTJSONReqBody);

            //calling Overlap SRT webservice
            String endPointURL = CSS_getConnnectionDetails.getConnection('SRT').End_Point__c;
            endPointURL = endPointURL.substring(0, endPointURL.indexOf('css',0))+'css/srtoverlap';
            HttpResponse httpRes = CSS_WS_SRT1.executeRESTWebservice(overlapSRTJSONReqBody, endPointURL, accessToken);
            if(httpRes == null || httpRes.getStatusCode() != 200){
                css_utility.LogOutIntError('CSS_FN_SRT-getOverlapSRTRecords', 'getOverlapSRTRecords Webservice HttpResponse is null', 'getOverlapSRTRecords SRT Webservice Execution failed', 'SRT');
                return overlapSRTResWC;
            }
            overlapSRTResWC = (CSS_OverlapSRTResponse)JSON.deserializeStrict(httpRes.getBody(), CSS_OverlapSRTResponse.class);

        }catch(Exception ex){
            System.debug('in catch of getOverlapSRTRecords of CSS_FN_SRT >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return overlapSRTResWC;
    }

    /**
     * This is a controller method of Admin SRT webservice & PMFlag webservice
     * Story #64032-Admin SRT-Start
     */
    /*  public void getallSRTData(String flagPM, List<CSS_srt__c> lstDisplayAdmin, List<CSS_srt__c> lstOrigDisplayAdminFiltered, List<CSS_srt__c> SRTList1, Boolean displayPopup1){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getallSRTData method of CSS_FN_SRT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        String Wid;
        try{
            Wid=ApexPages.CurrentPage().getParameters().get('id');
            String lAppCode;
            CSS_Job_Order__c joLst = [Select INSITE_UpdateTimeStamp__c,Repair_Location__c,Application__c,Preventive_Maintenance__c from CSS_Job_Order__c where Id=:Wid];
            lAppCode = css_utility.getCodes('Application Code', joLst.Application__c, null, null);

            user uWrkGrp = css_utility.getUserAttributes(userinfo.getUserId());
            system.debug('joLst.Preventive_Maintenance__cIS'+joLst.Preventive_Maintenance__c);
            if (joLst.Preventive_Maintenance__c !='No'){
                flagPM = 'Y';
            }
            system.debug('Wid**getallSRTData##getallSRTData'+Wid);        
            lstDisplayAdmin = new List<CSS_srt__c>();
            lstDisplayAdmin = CSS_WS_SRT.getAllSRTs(Wid,flagPM,'Admin');
            // lstDisplayAdmin = CSS_FN_SRT.getAllSRTs(Wid,flagPM,'Admin');
            //getExisting from database and make them check

            for(css_Srt__c eList:SRTList1){            
                for (integer i=0;i<lstDisplayAdmin.size();i++){
                    if(eList.srt_id__c ==lstDisplayAdmin[i].srt_id__c ){            
                        lstDisplayAdmin[i].SRTAdmi_Check__c = true;
                        lstDisplayAdmin[i].SRT_Notes__c = eList.SRT_Notes__c;
                    }
                }
            }
            system.debug('MSNlstDisplayAdmin##'+lstDisplayAdmin);
            //Passing WS resp to wrapper to set the CheckBoxes by default

            for (CSS_SRT__c wSList:lstDisplayAdmin){   
                system.debug('Isnide wraploopadmnList'+wSList); 
                if (wSList.SRT_Id__c == '00-901-00'&& joLst.Repair_Location__c =='In Shop'){ 
                    wSList.SRTAdmi_Check__c = true;
                }
                if (wSList.SRT_Id__c == '00-724-00'  && joLst.INSITE_UpdateTimeStamp__c!=null){                
                    wSList.SRTAdmi_Check__c = true;
                }
                if (wSList.SRT_Id__c == '00-904-00' && (lAppCode == '310'|| lAppCode == '320'|| lAppCode == '610')){
                    wSList.SRTAdmi_Check__c = true;
                }
                if (wSList.SRT_Id__c == '00-902-00' && joLst.Repair_Location__c =='Mobile'){
                    wSList.SRTAdmi_Check__c = true;
                }
                if (wSList.SRT_Id__c == '00-906-00' && uWrkGrp.Work_Group_Name__c=='Dealer'){
                    wSList.SRTAdmi_Check__c = true;
                }             
            }
            lstOrigDisplayAdminFiltered = lstDisplayAdmin.clone();   
            displayPopup1 = true;
        }catch(Exception ex){
            System.debug('in catch of getallSRTData of CSS_FN_SRT >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
    }

    /**
     * This is used for a controller method of Additional Diagnostic SRT webservice
     * 
     */
    /*  public void getDiagnosisSRTs(String JobID, List<CSS_srt__c> lstDisplayDiagSRT, List<CSS_Srt__c> additionalSRTList, Boolean displayPopup){
        try{  
            JobID=ApexPages.CurrentPage().getParameters().get('id');
            lstDisplayDiagSRT = new List<CSS_srt__c>();
            lstDisplayDiagSRT = CSS_WS_SRT.getAllDigRepSRTs(JobID,'Diagnostic');
            //lstDisplayDiagSRT = CSS_FN_SRT.getAllDigRepSRTs(JobID,'Diagnostic');
            system.debug('MSNlstDisplayAdmin##'+lstDisplayDiagSRT);
            System.debug('lstDisplayDiagSRT size----------->:'+lstDisplayDiagSRT.size());
            for(css_Srt__c eList:additionalSRTList){            
                for (integer i=0;i<lstDisplayDiagSRT.size();i++){
                    if(eList.srt_id__c ==lstDisplayDiagSRT[i].srt_id__c ){            
                        lstDisplayDiagSRT[i].isPerformed__c = true;
                        lstDisplayDiagSRT[i].SRT_Notes__c = eList.SRT_Notes__c;
                    }
                }
            } 
            displayPopup = true;
        }
        catch(exception ex){
            System.debug('in catch of & inside additional diagnosis of getDiagnosisSRTs of CSS_FN_SRT >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
    }

    /**
     * This is used for inserting Diagnostic SRTs
     * 
     */
    /*  public static void insertDiagnosticSRTs(CSS_J2ADiagnostic_SRT wo1, MAP<ID,ID> jobOrder, Map<ID,String> solName){
System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into insertDiagnosticSRTs webservice of CSS_WS_SRT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List<CSS_SRT__c> diagnosisSRT;
        try{
            diagnosisSRT = new List<CSS_SRT__c>();
            if(wo1.DataArea.CaseResponse!=null){
                for(ID solID : jobOrder.keySet()){
                    for(integer i=0;i<wo1.DataArea.CaseResponse.size();i++){ 
                        CSS_SRT__c diagSRT = new CSS_SRT__c();
                        if(solName.get(solID)!=null){
                            //if(wo1.DataArea.CaseResponse[i].SRTTitle!='DUMMY'){
                            if(solName.get(solID)==wo1.DataArea.CaseResponse[i].CaseNumber){
                                if(wo1.DataArea.CaseResponse[i].SRTID==null||wo1.DataArea.CaseResponse[i].SRTID==''||wo1.DataArea.CaseResponse[i].SRTID=='""'){
                                    diagSRT.Name = '0';
                                }
                                else{
                                    diagSRT.Name = wo1.DataArea.CaseResponse[i].SRTID;
                                }
                                diagSRT.Job_Order__c = jobOrder.get(solID);
                                diagSRT.SRT_Title__c = wo1.DataArea.CaseResponse[i].SRTTitle;
                                diagSRT.SRT_ID__c = wo1.DataArea.CaseResponse[i].SRTID;
                                diagSRT.Type__c = 'Diagnosis';
                                diagSRT.SRT_Quantity__c = 1;
                                diagSRT.Solution_Number__c = solID;
                                diagSRT.isPerformed__c = True;
                                diagSRT.Response_Message__c = wo1.DataArea.ResponseMessage;
                                if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription!=null){
                                    for(integer j=0;j<wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription.size();j++){
                                        diagSRT.Step_Description__c = diagSRT.Step_Description__c + wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[j]+'\n'; 
                                        diagSRT.Access_Code_A__c = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.AccessCodeA * 60;
                                        diagSRT.Access_Code_B__c = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.AccessCodeB * 60;
                                        diagSRT.Access_Code_D__c = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.AccessCodeD * 60; 
                                        diagSRT.Access_Code_R__c = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.AccessCodeR * 60;
                                        diagSRT.Access_Code_C__c = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.AccessCodeC * 60; 
                                        diagSRT.Step_Id__c = string.valueof(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepID);
                                        if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTStatusMessage!='SRT is present'){
                                            diagSRT.SRT_Status_Message__c = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTStatusMessage;
                                        }
                                    }
                                }
                                diagnosisSRT.add(diagSRT); 
                            }
                            // }
                        }       
                    }
                }
            }
System.debug('diagnosisSRT size>>>>>>>>:'+diagnosisSRT.size());
            if(diagnosisSRT.size()>0)
        insert diagnosisSRT;
        }catch(Exception ex){
            System.debug('in catch of insertDiagnosticSRTs of CSS_WS_SRT>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        System.debug('The diagnosis list is>>>>>>>>>>>>>>>>>>:'+diagnosisSRT);
}


    /**
     * This is used for inserting Repair SRTs
     * 
     */
    /*  public static void insertRepairSRTs(CSS_J2ARepair_SRT wo1, List<String> solComp){
System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into insertRepairSRTs webservice of CSS_FN_SRT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List<CSS_SRT__c> repairSRT;
        CSS_SRT__c repSRT;
        SolCompWrapper solCompWrapperObj;
        try{
            repairSRT = new List<CSS_SRT__c>();
            String repNotFound = '{"DataArea":{"ResponseMessage":"Error:: Code:ORA-21001 Message:No SRT found for the input Failure ID, Service Model Name, Engine Family and Timestamp combination."},"Header":{"ReturnCodeDescription":"Error:: Code:ORA-21001 Message:No SRT found for the input Failure ID, Service Model Name, Engine Family and Timestamp combination.","Status":"Error"}}'; // defect # 62135
            if(wo1.DataArea.toString().contains(repNotFound) ){
                System.debug('Inside no srt found...');
                String solCompStr = solComp.get(0);
            solCompWrapperObj = (SolCompWrapper) JSON.deserialize(solCompStr, SolCompWrapper.class);
                repSRT = new CSS_SRT__c();
                repSRT.Name = '0';
                repSRT.Type__c = 'Repair'; 
                repSRT.Response_Message__c = 'Please refer to QSOL to determine if additional labor is warrantable for this action. If so, follow your current process to claim reimbursement.';
                repSRT.Job_Order__c = solCompWrapperObj.jobID; 
                repSRT.Solution_Number__c = solCompWrapperObj.solID;
                repSRT.Component_Id__c = solCompWrapperObj.compID;
                repSRT.SRT_Time__c = 0.0;
                repSRT.SRT_Quantity__c = 1;
                repSRT.SRT_ID__c = '0';
                repSRT.isPerformed__c = True;
                repairSRT.add(repSRT);
            }else if(wo1.DataArea.CaseResponse != null){
                for(String solCompWpr: solComp){
                solCompWrapperObj = (SolCompWrapper) JSON.deserialize(solCompWpr, SolCompWrapper.class);
                        for(integer i=0;i<wo1.DataArea.CaseResponse.size();i++){
                            //if(wo1.DataArea.CaseResponse[i].SRTTitle!='DUMMY'){
                            System.debug('Inside srt found'); // added for defect # 62135
                            if(wo1.DataArea.CaseResponse[i].FailureID!=null){ // added for defect # 62135
                                if(solCompWrapperObj.compoName== wo1.DataArea.CaseResponse[i].FailureID){
                                    repSRT = new CSS_SRT__c();    
                                    repSRT.Name = wo1.DataArea.CaseResponse[i].FailureID;
                                    repSRT.Type__c = 'Repair';    
                                    repSRT.SRT_Title__c = wo1.DataArea.CaseResponse[i].SRTTitle;
                                    // repSRT.SRT_Quantity__c = string.valueof(wo1.DataArea.CaseResponse[i].SRTQuantity);       
                                    repSRT.SRT_ID__c = wo1.DataArea.CaseResponse[i].SRTDetails;//SRTDETAILS equals SRT-ID
                                    repSRT.SRT_Access_Code__c = wo1.DataArea.CaseResponse[i].SRTAccessCode;
                                    if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription!=null){
                                        for(integer k=0;k<wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription.size();k++){
                                            if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[k]!='DUMMY'){
                                                repSRT.Step_Description__c = repSRT.Step_Description__c + wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[k]+'\n'; 
                                            }
                                        }
                                    }
                                    repSRT.Step_Id__c = String.valueOf(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepID);
                                    repSRT.Type__c = 'Repair';
                                    repSRT.Assignment__c = wo1.DataArea.CaseResponse[i].Assignment;
                                    repSRT.Failure_Name__c = wo1.DataArea.CaseResponse[i].FailureName;
                                    repSRT.Solution_Number__c = solCompWrapperObj.solID;
                                    repSRT.Job_Order__c = solCompWrapperObj.jobID; 
                                    repSRT.Component_Id__c = solCompWrapperObj.compID;
                                    repSRT.SRT_Time__c = wo1.DataArea.CaseResponse[i].SRTTime * 60; 
                                    repSRT.SRT_Quantity__c = 1;
                                    if(wo1.DataArea.CaseResponse[i].Assignment=='PRIMARY'){
                                    repSRT.isPerformed__c = True;
                                    }else{
                                        repSRT.isPerformed__c = false;
                                    }
                                    if( wo1.DataArea.CaseResponse[i].SRTTitle!='Dummy'){
                                        repairSRT.add(repSRT);    
                                    }
                                }
                            }
                            //}
                        }   
            }
            }
System.debug('repairSRT size>>>>>>>>:'+repairSRT.size());
            if(repairSRT.size()>0)
        insert repairSRT;
        }catch(Exception ex){
            System.debug('in catch of insertRepairSRTs of CSS_FN_SRT>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        System.debug('The Repair SRT list is>>>>>>>>>>>>>>>>>>:'+repairSRT);
}

    /**
     * This is used for pulling Admin SRTs from Response JSON
     * 
     */
    /*  public static List<CSS_srt__c> getAdminSRTsFromAdminResWC(CSS_getAllSRTResponseJ2A objAllSRTs, String accessCode, String jobId){
    System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getAdminSRTsFromAdminResWC webservice of CSS_FN_SRT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List<CSS_srt__c> dataAdminSRT;
        Integer setSize = 0;
        try{
            dataAdminSRT = new List<CSS_srt__c>();
            System.debug('objAllSRTs Header is>>'+objAllSRTs.Header.ReturnCodeDescription);
            System.debug('objAllSRTs DA is>>'+objAllSRTs.DataArea);
            if (objAllSRTs.Header.ReturnCodeDescription.contains('Successful') && objAllSRTs.DataArea != null )  {
                    System.debug('objAllSRTs DA Size is>>'+objAllSRTs.DataArea.size());
                    System.debug('objAllSRTs DA is>>'+objAllSRTs.DataArea); 
                if (objAllSRTs.DataArea.size() > 999)              
                        setSize = 500;           
                    else
                        setSize = objAllSRTs.DataArea.size();
                    for (integer i=0;i<setSize;i++){
                        CSS_srt__c recAdminSRT = new CSS_srt__c();
                        recAdminSRT.Step_id__c = String.valueof(objAllSRTs.DataArea[i].StepID);
                        recAdminSRT.SRT_Title__c = objAllSRTs.DataArea[i].SRTTitle;
                        recAdminSRT.SRT_Type__c = objAllSRTs.DataArea[i].SRTType;
                        recAdminSRT.SRT_Category__c= objAllSRTs.DataArea[i].SRTCategory ;
                        recAdminSRT.Access_Code_A__c =Integer.valueof(objAllSRTs.DataArea[i].ATime)*60;
                        recAdminSRT.Access_Code_B__c =Double.valueof(objAllSRTs.DataArea[i].BTime)*60;
                        recAdminSRT.Access_Code_C__c =Double.valueof(objAllSRTs.DataArea[i].CTime)*60;
                        recAdminSRT.Access_Code_D__c =Double.valueof(objAllSRTs.DataArea[i].DTime)*60;
                        recAdminSRT.Access_Code_R__c =Double.valueof(objAllSRTs.DataArea[i].RTime)*60;
                        recAdminSRT.SRT_Id__c = String.valueof(objAllSRTs.DataArea[i].SRTNumber);
                        if(!Test.isRunningTest())
                            recAdminSRT.SRTAdmi_Check__c = false;
                        else
                            recAdminSRT.SRTAdmi_Check__c = true;   
                        recAdminSRT.SRT_Notes__c ='';
                        recAdminSRT.Type__c ='Admin';
                        if (recAdminSRT.SRT_Id__c == '00-904-00'||recAdminSRT.SRT_Id__c == '00-902-00'){
                            recAdminSRT.Admin_Miles_In__c =0;
                            recAdminSRT.Admin_Miles_Out__c =0;
                            recAdminSRT.Admin_Arrive_Job__c =0;
                            recAdminSRT.Admin_Arrive_Shop__c =0;
                            recAdminSRT.Admin_Finish_Job__c =0;
                            recAdminSRT.Admin_Leave_Job__c =0;
                            recAdminSRT.Admin_Left_Shop__c =0;
                            recAdminSRT.Admin_Start_Job__c = 0;
                        }
                        system.debug('jo.AccessCode__c is'+accessCode);
                        if(accessCode =='A'){recAdminSRT.SRT_Time__c=Integer.valueof(objAllSRTs.DataArea[i].ATime)*60;}
                        else if(accessCode =='B'){recAdminSRT.SRT_Time__c=Double.valueof(objAllSRTs.DataArea[i].BTime)*60;}
                        else if(accessCode =='C'){recAdminSRT.SRT_Time__c=Double.valueof(objAllSRTs.DataArea[i].CTime)*60;}
                        else if(accessCode =='D'){recAdminSRT.SRT_Time__c=Double.valueof(objAllSRTs.DataArea[i].DTime)*60;}
                        else if(accessCode =='R'){recAdminSRT.SRT_Time__c=Double.valueof(objAllSRTs.DataArea[i].RTime)*60;}
                        recAdminSRT.Job_Order__c = jobId;
                        dataAdminSRT.add(recAdminSRT);
                    }

                    CSS_srt__c localSRTAdmin = new CSS_srt__c();
                    localSRTAdmin.SRT_Title__c = 'Local SRT';
                    localSRTAdmin.SRT_Type__c = 'Admin';
                    //localSRT.SRT_Category__c= objAllSRTs.DataArea[i].SRTCategory ;
                    localSRTAdmin.SRT_Id__c = '99-999';
                    localSRTAdmin.SRTAdmi_Check__c = false;
                    localSRTAdmin.SRT_Notes__c ='';
                    localSRTAdmin.Type__c ='Admin';
                    localSRTAdmin.Admin_Miles_In__c =0;
                    localSRTAdmin.Admin_Miles_Out__c =0;
                    localSRTAdmin.Admin_Arrive_Job__c =0;
                    localSRTAdmin.Admin_Arrive_Shop__c =0;
                    localSRTAdmin.Admin_Finish_Job__c =0;
                    localSRTAdmin.Admin_Leave_Job__c =0;
                    localSRTAdmin.Admin_Left_Shop__c =0;
                    localSRTAdmin.Admin_Start_Job__c = 0;
                    localSRTAdmin.Job_Order__c = jobId;
                    dataAdminSRT.add(localSRTAdmin);
                    System.debug('dataAdminSRT is >>>>'+dataAdminSRT);
                }
            }catch(Exception ex){
                System.debug('in catch of getAdminSRTsFromAdminResWC of CSS_FN_SRT >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            }
            return dataAdminSRT;
    }



    public class SolCompWrapper{
        public id solID{get;set;}
        public id jobID{get;set;}
        public string serviceModel{get;set;}
        public string equipID{get;set;}
        public id compID{get;set;}
        public string efc{get;set;}
        public string compoName{get;set;}
        public string jobName{get;set;}
        public decimal claimID{get;set;}
        public SolCompWrapper(id solID,id jobID,string serviceModel,string equipID,id compID,string efc,string compoName,string jobName,decimal claimId){
            this.solID = solID;
            this.jobID = jobID;
            this.serviceModel = serviceModel;
            this.equipID = equipID;
            this.compID = compID;
            this.efc = efc;            
            this.compoName = compoName;
            this.jobName = jobName;
            this.claimId = claimId;
        }
    }
   // the below code is already commented before modularisation. - Anirudh
   /**
     * This is used for pulling Additional Diagnostic/Repair SRTs from Response JSON
     * 
     */
    /*
    public static List<CSS_srt__c> getSRTsFromResWC(CSS_getAllSRTResponseJ2A objAllSRTs, String accessCode, String jobId, String srtType){
    System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getSRTsFromResWC method of CSS_FN_SRT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List<CSS_srt__c> dataDiaRepSRT;
        Integer setSize;
        try{
            dataDiaRepSRT = new List<CSS_srt__c>();
            System.debug('objAllSRTs Header is>>'+objAllSRTs.Header.ReturnCodeDescription);
            System.debug('objAllSRTs DA is>>'+objAllSRTs.DataArea);
            if (objAllSRTs.Header.ReturnCodeDescription.contains('Successful') && objAllSRTs.DataArea != null )  {
            System.debug('objAllSRTs DA Size is>>'+objAllSRTs.DataArea.size());
            System.debug('objAllSRTs DA is>>'+objAllSRTs.DataArea);                
            if ( objAllSRTs.DataArea.size() > 999){          
                setSize = 500;              
            }else {
                setSize = objAllSRTs.DataArea.size();
            }
            for (integer i=0;i<setSize;i++){
                CSS_srt__c recDiaRepSRT = new CSS_srt__c();
                recDiaRepSRT.Step_id__c = String.valueof(objAllSRTs.DataArea[i].StepID);
                recDiaRepSRT.SRT_Title__c = objAllSRTs.DataArea[i].SRTTitle;
                recDiaRepSRT.SRT_Type__c = objAllSRTs.DataArea[i].SRTType;
                recDiaRepSRT.SRT_Category__c= objAllSRTs.DataArea[i].SRTCategory ;
                recDiaRepSRT.Access_Code_A__c =Integer.valueof(objAllSRTs.DataArea[i].ATime)*60;
                recDiaRepSRT.Access_Code_B__c =Double.valueof(objAllSRTs.DataArea[i].BTime)*60;
                recDiaRepSRT.Access_Code_C__c =Double.valueof(objAllSRTs.DataArea[i].CTime)*60;
                recDiaRepSRT.Access_Code_D__c =Double.valueof(objAllSRTs.DataArea[i].DTime)*60;
                recDiaRepSRT.Access_Code_R__c =Double.valueof(objAllSRTs.DataArea[i].RTime)*60;
                recDiaRepSRT.SRT_Id__c = String.valueof(objAllSRTs.DataArea[i].SRTNumber);
                recDiaRepSRT.isPerformed__c = false;
                recDiaRepSRT.SRT_Notes__c ='';
                if(!Test.isRunningTest())
                    recDiaRepSRT.isPerformed__c = false;
                else
                    recDiaRepSRT.isPerformed__c = true;   
                if (srtType =='Diagnostic')
                    recDiaRepSRT.Type__c ='Diagnosis'; 
                if (srtType =='Repair')
                    recDiaRepSRT.Type__c ='Repair'; 
                if(accessCode =='A'){recDiaRepSRT.SRT_Time__c=Integer.valueof(objAllSRTs.DataArea[i].ATime)*60;}
                else if(accessCode =='B'){recDiaRepSRT.SRT_Time__c=Double.valueof(objAllSRTs.DataArea[i].BTime)*60;}
                else if(accessCode =='C'){recDiaRepSRT.SRT_Time__c=Double.valueof(objAllSRTs.DataArea[i].CTime)*60;}
                else if(accessCode =='D'){recDiaRepSRT.SRT_Time__c=Double.valueof(objAllSRTs.DataArea[i].DTime)*60;}
                else if(accessCode =='R'){recDiaRepSRT.SRT_Time__c=Double.valueof(objAllSRTs.DataArea[i].RTime)*60;}
                recDiaRepSRT.Job_Order__c =jobId;
                dataDiaRepSRT.add(recDiaRepSRT);
            }
            System.debug('FinalDataDiaRepSRTs Size>>>>>>>>>>>>>>>>>:'+dataDiaRepSRT.size()+' dataDiaRepSRT>>>>>>:'+dataDiaRepSRT);
        }
        }catch(Exception ex){
            System.debug('in catch of getSRTsFromResWC of CSS_FN_SRT >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return dataDiaRepSRT;
    }*/

    public static set<string> faildssim;
    public static list<string> uniquelist;

    public static void srtPartsService(List<CSS_Solution_Component__c> solCompObj,CSS_Job_Order__c serJobObj,Id recTypeIdpart){
        try{
            system.debug('Inside Parts Service method'+ solCompObj);
            CSS_getPartsListSRTRequestJ2A PartsSRTREq = new CSS_getPartsListSRTRequestJ2A();

            datetime systemDate = System.now();
            string sysdt = systemDate.format('YYYY-MM-dd') +'T00:00:00'; 
            Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
            //Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');

            User u = css_utility.getUserAttributes(userinfo.getUserId()); 
            string lang = u.LanguageLocaleKey;

            CSS_getPartsListSRTRequestJ2A.Header headerDeatail = new CSS_getPartsListSRTRequestJ2A.Header();

            CSS_getPartsListSRTRequestJ2A.Sender senderDetail = new CSS_getPartsListSRTRequestJ2A.Sender();

            senderDetail.ServiceName = 'GetPartsListSRT';
            senderDetail.SenderID ='CSS';

            headerDeatail.Sender = senderDetail;

            CSS_getPartsListSRTRequestJ2A.Target targetDetail = new CSS_getPartsListSRTRequestJ2A.Target();
            targetDetail.TargetID = 'SRT';
            headerDeatail.Target = targetDetail;


            CSS_getPartsListSRTRequestJ2A.DataArea dataAreadetails = new CSS_getPartsListSRTRequestJ2A.DataArea();

            //failids = new list<string>();
            faildssim = new set<string>();
            uniquelist = new list<string>();

            if(solCompObj != null && solCompObj.size()>0){
                for(CSS_Solution_Component__c x : solCompObj){

                    if(x.Component_Id__c != null && x.Component_Id__c != ''){

                        faildssim.add(x.Component_Id__c);  

                        //sample map end
                    }
                }
                //faildssim.addall(failids); 
                uniquelist.addall(faildssim);



                list<CSS_Parts_Options__c> Parts = new list<CSS_Parts_Options__c>();
                Parts =  [Select id,Option_Number__c,Service_Job__c,Solutions__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c from CSS_Parts_Options__c where ((Service_Job__c =: serJobObj.Id AND RecordType.Name = 'Options') OR (Service_Job__c =: serJobObj.Id AND Solutions__c =: solCompObj[0].Solutions__c))];



                // string rectype = 
                list<CSS_Parts_Options__c> prtRec = new list<CSS_Parts_Options__c>();
                list<string> options = new list<string>();
                if(Parts != null){
                    for(CSS_Parts_Options__c y : Parts){
                        if(y.Option_Number__c != null && y.Option_Number__c != '' && y.Option_ESN__c == serJobObj.ESN__c && y.recordtypeId == recTypeIdoption ){
                            options.add(y.Option_Number__c);
                        }
                        if(y.RecordType.Name == 'Parts'){
                            system.debug('Anirudh Entered PartrecList'+y.RecordType.Name);
                            prtRec.add(y);
                        }
                        system.debug('Anirudh Entered PartrecList Outside'+y.RecordType.Name);
                    }
                } 
                system.debug('options list testr'+options);
                //system.debug('uniquelist testr'+uniquelist);
                dataAreadetails.JobID =  serJobObj.Name; // Sai: 6/2 : Changed JobId to JobID
                dataAreadetails.ClaimID = 'C100002045';
                dataAreadetails.Languagecode = lang;
                dataAreadetails.EngineFamilyCode = serJobObj.Qsol_Engine_Family_Code__c;
                dataAreadetails.ServiceModelName = serJobObj.Service_Model__c;
                dataAreadetails.EquipmentID = serJobObj.Equipment_ID__c;
                dataAreadetails.DTTimestamp = sysdt;
                dataAreadetails.EffectiveDTTime = sysdt;
                dataAreadetails.FailureID = uniquelist;
                dataAreadetails.OptionNumber = options;

                PartsSRTREq.Header = headerDeatail;
                PartsSRTREq.DataArea = dataAreadetails;    
                system.debug('Santosh testing parts1'+PartsSRTREq);

                //Anirudh
                CSS_getPartsListSRTResponseJ2A partslist =  CSS_WS_SRT.getPartsListSRT(PartsSRTREq);       
                system.debug('partsresponse'+partslist);



                if(partslist.Header.MessageType=='S'){
                    list<CSS_Parts_Options__c> partinsert = new list<CSS_Parts_Options__c>();
                    if(solCompObj != null && !solCompObj.isEmpty()){
                        system.debug('service job related components'+solCompObj);

                        for(CSS_Solution_Component__c compfail : solCompObj){
                            system.debug('insideparts'+compfail);
                            system.debug('Anirudh>>>>prtRec>>>>>>>>>>>'+prtRec);
                            if(prtRec.isEmpty()){
                                system.debug('insideparts'+prtRec);
                                // for(integer s=0; s=failmapfinallist.size(); s++){
                                for(CSS_getPartsListSRTResponseJ2A.DataArea partData : partslist.DataArea){
                                    system.debug('shd'+partData);
                                    if(compfail.Component_Id__c != null && compfail.Component_Id__c == partData.FailureID){
                                        system.debug('insideparts');
                                        CSS_Parts_Options__c partobj = new CSS_Parts_Options__c();
                                        partobj.recordtypeId  = recTypeIdpart;
                                        partobj.FailurepartId__c = compfail.id;
                                        partobj.Name = partData.PartNumberService+string.valueOf(serJobObj.Id)+compfail.id;
                                        partobj.Part_Name__c = partData.PartNameService;
                                        partobj.Part_Description__c = partData.PartNumberMfg;
                                        partobj.OEM__c = partData.OEM;
                                        partobj.FailureName__c = partData.FailureName;
                                        partobj.Part_Assignment__c = partData.Assignment;
                                        partobj.Service_partnumber__c = partData.PartNumberService;
                                        partobj.Option_Number__c = partData.OptionNumber;
                                        partobj.Option_ESN__c = serJobObj.ESN__c;
                                        partobj.Quantity__c = partData.Qty;
                                        partobj.Default_Part_Quantity__c = partData.Qty;
                                        partobj.part_size__c = partData.PartSize;
                                        partobj.Notes__c = partData.Notes;
                                        partobj.Service_Job__c = serJobObj.Id;
                                        partobj.Solutions__c = compfail.Solutions__c;
                                        //175940 Story
                                        partobj.Replacement_Reason__c = 'GSQ Part';
                                        partinsert.add(partobj); 


                                    }  
                                }
                                // } // for loop 

                            }
                        } 
                        system.debug('final object related list records'+partinsert);
                        insert partinsert;
                    } 
                }
            }  
            //Code for Service Parts - Start.
            /*  if(partinsert != null){
                    system.debug('checking the maplist all'+partinsert);
                    if(partdispjbp == null){
                        partdispjbp = new list<CSS_Parts_Options__c>();
                    }
                    system.debug('sam12222'+servicejob.CSS_Parts_Options__r);
                    for(CSS_Parts_Options__c z: partinsert){

                        if(z.recordtypeId == recTypeIdpart){

                            partdispjbp.add(z);

                        }

                    }
                    system.debug('part display list'+partdispjbp);
                }
                //Code ofr Srevice Parts - End. 
            }

            else{
                srtpartsErrorMsg = partslist.Header.ReturnCodeDescription;
                srtpb =true;
                system.debug('error description of parts'+srtpartsErrorMsg);
            } */
        }
        catch(Exception ex){
            system.debug('Exception in parts--'+ex.getMessage()+' '+ex.getLineNumber());
        }
    }
    
    //Added as part of the story 183428, 184816
    public static void srtPartsServiceNew(List<CSS_Solution_Component__c> solCompObj,CSS_Job_Order__c serJobObj,Id recTypeIdpart){
        try{
            system.debug('Inside Parts Service method New'+ solCompObj);
            CSS_getPartsListSRTRequestJ2A PartsSRTREq = new CSS_getPartsListSRTRequestJ2A();

            datetime systemDate = System.now();
            string sysdt = systemDate.format('YYYY-MM-dd') +'T00:00:00'; 
            Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');

            User u = css_utility.getUserAttributes(userinfo.getUserId()); 
            string lang = u.LanguageLocaleKey;

            CSS_getPartsListSRTRequestJ2A.Header headerDeatail = new CSS_getPartsListSRTRequestJ2A.Header();
            CSS_getPartsListSRTRequestJ2A.Sender senderDetail = new CSS_getPartsListSRTRequestJ2A.Sender();

            senderDetail.ServiceName = 'GetPartsListSRT';
            senderDetail.SenderID ='CSS';

            headerDeatail.Sender = senderDetail;

            CSS_getPartsListSRTRequestJ2A.Target targetDetail = new CSS_getPartsListSRTRequestJ2A.Target();
            targetDetail.TargetID = 'SRT';
            headerDeatail.Target = targetDetail;

            CSS_getPartsListSRTRequestJ2A.DataArea dataAreadetails = new CSS_getPartsListSRTRequestJ2A.DataArea();

            faildssim = new set<string>();
            uniquelist = new list<string>();

            if(solCompObj != null && solCompObj.size()>0){
                for(CSS_Solution_Component__c x : solCompObj){
                    if(x.Component_Id__c != null && x.Component_Id__c != ''){
                        faildssim.add(x.Component_Id__c);  
                    }
                }
                uniquelist.addall(faildssim);

                list<CSS_Parts_Options__c> Parts = new list<CSS_Parts_Options__c>();
                Parts =  [Select id,Option_Number__c,Service_Job__c,Solutions__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c from CSS_Parts_Options__c where ((Service_Job__c =: serJobObj.Id AND RecordType.Name = 'Options') OR (Service_Job__c =: serJobObj.Id AND Solutions__c =: solCompObj[0].Solutions__c))];

                list<CSS_Parts_Options__c> prtRec = new list<CSS_Parts_Options__c>();
                list<string> options = new list<string>();
                if(Parts != null){
                    for(CSS_Parts_Options__c y : Parts){
                        if(y.Option_Number__c != null && y.Option_Number__c != '' && y.Option_ESN__c == serJobObj.ESN__c && y.recordtypeId == recTypeIdoption ){
                            options.add(y.Option_Number__c);
                        }
                        if(y.RecordType.Name == 'Parts'){
                            system.debug('PartrecList-->'+y.RecordType.Name);
                            prtRec.add(y);
                        }
                        system.debug('PartrecList Outside-->'+y.RecordType.Name);
                    }
                } 
                system.debug('options list testr'+options);
                dataAreadetails.JobID =  serJobObj.Name; 
                dataAreadetails.ClaimID = 'C100002045';
                dataAreadetails.Languagecode = lang;
                dataAreadetails.EngineFamilyCode = serJobObj.Qsol_Engine_Family_Code__c;
                dataAreadetails.ServiceModelName = serJobObj.Service_Model__c;
                dataAreadetails.EquipmentID = serJobObj.Equipment_ID__c;
                dataAreadetails.DTTimestamp = sysdt;
                dataAreadetails.EffectiveDTTime = sysdt;
                dataAreadetails.FailureID = uniquelist;
                dataAreadetails.OptionNumber = options;

                PartsSRTREq.Header = headerDeatail;
                PartsSRTREq.DataArea = dataAreadetails;    
                system.debug('PartsSRTREq-->'+PartsSRTREq);

                CSS_getPartsListSRTResponseJ2A partslist =  CSS_WS_SRT.getPartsListSRT(PartsSRTREq);       
                system.debug('partsresponse-->'+partslist);
                system.debug('partslist.Header.MessageType>>'+partslist.Header.MessageType);
                if(partslist.Header.MessageType=='S'){
                    list<CSS_Parts_Options__c> partinsert = new list<CSS_Parts_Options__c>();
                    if(solCompObj != null && !solCompObj.isEmpty()){
                        system.debug('service job related components'+solCompObj);

                        for(CSS_Solution_Component__c compfail : solCompObj){
                            system.debug('insideparts'+compfail);
                            system.debug('>>>>prtRec>>>>>>>>>>>'+prtRec);
                            //if(prtRec.isEmpty()){
                                system.debug('insideparts'+prtRec);
                                for(CSS_getPartsListSRTResponseJ2A.DataArea partData : partslist.DataArea){
                                    system.debug('shd'+partData);
                                    if(compfail.Component_Id__c != null && compfail.Component_Id__c == partData.FailureID){
                                        system.debug('insideparts');
                                        CSS_Parts_Options__c partobj = new CSS_Parts_Options__c();
                                        partobj.recordtypeId  = recTypeIdpart;
                                        partobj.FailurepartId__c = compfail.id;
                                        partobj.Name = partData.PartNumberService+string.valueOf(serJobObj.Id)+compfail.id;
                                        partobj.Part_Name__c = partData.PartNameService;
                                        partobj.Part_Description__c = partData.PartNumberMfg;
                                        partobj.OEM__c = partData.OEM;
                                        partobj.FailureName__c = partData.FailureName;
                                        partobj.Part_Assignment__c = partData.Assignment;
                                        partobj.Service_partnumber__c = partData.PartNumberService;
                                        partobj.Option_Number__c = partData.OptionNumber;
                                        partobj.Option_ESN__c = serJobObj.ESN__c;
                                        partobj.Quantity__c = partData.Qty;
                                        partobj.Default_Part_Quantity__c = partData.Qty;
                                        partobj.part_size__c = partData.PartSize;
                                        partobj.Notes__c = partData.Notes;
                                        partobj.Service_Job__c = serJobObj.Id;
                                        partobj.Solutions__c = compfail.Solutions__c;
                                        partobj.Replacement_Reason__c = 'GSQ Part';
                                        partobj.Fail_Code__c = compfail.FailCode_Formula__c;
                                        if(compfail.CoveredPartsQty__c != null && compfail.CoveredPartsQty__c != '' && double.valueof(compfail.CoveredPartsQty__c) > 0){
                                            partobj.Account_Code__c = compfail.CSS_Account_Formula__c;
                                            partobj.Covered__c = 100;
                                        }
                                        partinsert.add(partobj); 
                                    }  
                                }
                            //}
                        } 
                        system.debug('final object related list records-->'+partinsert);
                        insert partinsert;
                    } 
                }
            }  
        }
        catch(Exception ex){
            system.debug('Exception in parts--'+ex.getMessage()+' '+ex.getLineNumber());
        }
    }
    
    public static list<CSS_Parts_Options__c> fetchGSQServiceParts(CSS_Solution_Component__c solCompObj, CSS_Job_Order__c serJobObj) {
        list<CSS_Parts_Options__c> GSQParts = new list<CSS_Parts_Options__c>();
        try {
            system.debug('Inside Parts Service method'+ solCompObj);
            CSS_getPartsListSRTRequestJ2A PartsSRTREq = new CSS_getPartsListSRTRequestJ2A();

            datetime systemDate = System.now();
            string sysdt = systemDate.format('YYYY-MM-dd') +'T00:00:00'; 
            Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
            Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            User u = css_utility.getUserAttributes(userinfo.getUserId()); 
            string lang = u.LanguageLocaleKey;

            system.debug('Inside Parts Service method WEB REQUEST');
            CSS_getPartsListSRTRequestJ2A.Header headerDeatail = new CSS_getPartsListSRTRequestJ2A.Header();
            CSS_getPartsListSRTRequestJ2A.Sender senderDetail = new CSS_getPartsListSRTRequestJ2A.Sender();

            senderDetail.ServiceName = 'GetPartsListSRT';
            senderDetail.SenderID ='CSS';
            headerDeatail.Sender = senderDetail;

            CSS_getPartsListSRTRequestJ2A.Target targetDetail = new CSS_getPartsListSRTRequestJ2A.Target();
            targetDetail.TargetID = 'SRT';
            headerDeatail.Target = targetDetail;

            CSS_getPartsListSRTRequestJ2A.DataArea dataAreadetails = new CSS_getPartsListSRTRequestJ2A.DataArea();
            list<string> uniquelist = new list<string>();
            if(solCompObj != null && solCompObj.Component_Id__c != null && solCompObj.Component_Id__c != '')
                uniquelist.add(solCompObj.Component_Id__c);

            list<CSS_Parts_Options__c> Parts = new list<CSS_Parts_Options__c>();
            Parts =  [Select id,Option_Number__c,Service_Job__c,Solutions__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,
                      FailurepartId__c,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,
                      Service_partnumber__c 
                      from CSS_Parts_Options__c 
                      where Service_Job__c =: serJobObj.Id AND RecordType.Name = 'Options'];

            list<CSS_Parts_Options__c> prtRec = new list<CSS_Parts_Options__c>();
            list<string> options = new list<string>();
            system.debug('Inside Parts Service method WEB REQUEST 1.1' + serJobObj);
            system.debug('Inside Parts Service method WEB REQUEST 1.1' + serJobObj.ESN__c);
            if(Parts != null){
                for(CSS_Parts_Options__c y : Parts){
                    if(y.Option_Number__c != null && y.Option_Number__c != '' && y.Option_ESN__c == serJobObj.ESN__c && y.recordtypeId == recTypeIdoption ){
                        options.add(y.Option_Number__c);
                    }
                    if(y.RecordType.Name == 'Parts'){
                        system.debug('Anirudh Entered PartrecList'+y.RecordType.Name);
                        prtRec.add(y);
                    }
                    system.debug('Anirudh Entered PartrecList Outside'+y.RecordType.Name);
                }
            } 
            system.debug('options list testr'+options);

            dataAreadetails.JobID =  serJobObj.Name; // Sai: 6/2 : Changed JobId to JobID
            dataAreadetails.ClaimID = 'C100002045';
            dataAreadetails.Languagecode = lang;
            dataAreadetails.EngineFamilyCode = serJobObj.Qsol_Engine_Family_Code__c;
            dataAreadetails.ServiceModelName = serJobObj.Service_Model__c;
            dataAreadetails.EquipmentID = serJobObj.Equipment_ID__c;
            dataAreadetails.DTTimestamp = sysdt;
            dataAreadetails.EffectiveDTTime = sysdt;
            dataAreadetails.FailureID = uniquelist;
            dataAreadetails.OptionNumber = options;

            PartsSRTREq.Header = headerDeatail;
            PartsSRTREq.DataArea = dataAreadetails;    
            system.debug('Santosh testing parts1'+PartsSRTREq);

            CSS_getPartsListSRTResponseJ2A partslist =  CSS_WS_SRT.getPartsListSRT(PartsSRTREq);       
            system.debug('partsresponse'+partslist);

            if(partslist.Header.MessageType=='S'){
                if(prtRec.isEmpty()){
                    for(CSS_getPartsListSRTResponseJ2A.DataArea partData : partslist.DataArea){
                        system.debug('partData '+partData);
                        if(solCompObj.Component_Id__c != null && solCompObj.Component_Id__c == partData.FailureID){
                            system.debug('insideparts');
                            CSS_Parts_Options__c partobj = new CSS_Parts_Options__c();
                            partobj.recordtypeId  = recTypeIdpart;
                            //partobj.FailurepartId__c = solCompObj.id;
                            partobj.Name = partData.PartNumberService+string.valueOf(serJobObj.Id)+solCompObj.id;
                            partobj.Part_Name__c = partData.PartNameService;
                            partobj.Part_Description__c = partData.PartNumberMfg;
                            partobj.OEM__c = partData.OEM;
                            partobj.FailureName__c = partData.FailureName;
                            partobj.Part_Assignment__c = partData.Assignment;
                            partobj.Service_partnumber__c = partData.PartNumberService;
                            partobj.Option_Number__c = partData.OptionNumber;
                            partobj.Option_ESN__c = serJobObj.ESN__c;
                            partobj.Quantity__c = partData.Qty;
                            partobj.Default_Part_Quantity__c = partData.Qty;
                            partobj.part_size__c = partData.PartSize;
                            partobj.Notes__c = partData.Notes;
                            partobj.Service_Job__c = serJobObj.Id;
                            partobj.Replacement_Reason__c = 'GSQ Part';
                            //partobj.Solutions__c = compfail.Solutions__c;
                            GSQParts.add(partobj); 
                        }  
                    }
                }
            }
            system.debug('final object related list records'+GSQParts);
        } catch(exception e) {
            system.debug('Entered into catch block of fetchGSQParts in CG_CL_AddFailure_GSQParts' + e.getmessage() + ' ' + e.getLineNumber());
        }
        return GSQParts;
    }

    @future (callout=true)
    public static void FetchGSQParts(Id solCompId, Id ClaimId){
        try {
            system.debug('Entered FetchGSQParts');
            Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            list<CSS_Parts_Options__c> parts = new list<CSS_Parts_Options__c>();

            //Claim Query and check only manual Claim
            CSS_Claims__c claims =[Select Id, Name, ESN__c, Parts_ODM_Status__c, CSS_Job__c, (Select Id,Name,PSN__c,Service_Model__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Warranty_Start_Date__c
                                                                         ,Product_Hours__c,CoverageFlag__c, CSS_Claims__c,Unit_Type__c, Equipment_ID__c  
                                                                         from CSS_PSNs__r where Primary__c=true Limit 1) 
                                   from CSS_Claims__c where id= :ClaimId];
            //if(claims.CSS_Job__c == null) { //commented this manual claim checking condition bcz it calling GSQParts is applicable to Dealer Auto Claim as per #179355
                //If parts are already there then no action.
                //,Default_Part_Quantity__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Assignment__c,Part_Name__c
                //,part_size__c,Quantity__c,Service_partnumber__c,Replacement_Reason__c
                Parts = [Select id,Option_Number__c from CSS_Parts_Options__c
                         where RecordType.Name = 'Parts' and CSS_Claims__c =: ClaimId and FailurepartId__c =:solCompId order by Part_Name__c];

                //If parts are Empty then call the srt service.
                if(Parts.size()==0 || Parts.isempty()){
                    system.debug('Entered if parts size is empty');
                    CSS_FN_SRT.srtPartsClaims(solCompId,claims,recTypeIdpart);
                }
            //}
        } catch(exception e){
            system.debug('Entered in exception block of InsertGSQParts method>>>>'+e.getMessage() + ' ' + e.getLineNumber());
        }
    }

    public static void srtPartsClaims(Id solCompId, CSS_Claims__c claims, Id recTypeIdpart) {
        system.debug('Entered srtPartsClaims');
        CSS_getPartsListSRTRequestJ2A PartsSRTREq = new CSS_getPartsListSRTRequestJ2A();
        try {
            datetime systemDate = System.now();
            string sysdt = systemDate.format('YYYY-MM-dd') +'T00:00:00'; 
            Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
            //Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');

            User u = css_utility.getUserAttributes(userinfo.getUserId()); 
            string lang = u.LanguageLocaleKey;

            CSS_getPartsListSRTRequestJ2A.Header headerDeatail = new CSS_getPartsListSRTRequestJ2A.Header();
            CSS_getPartsListSRTRequestJ2A.Sender senderDetail = new CSS_getPartsListSRTRequestJ2A.Sender();
            senderDetail.ServiceName = 'GetPartsListSRT';
            senderDetail.SenderID ='CSS';
            headerDeatail.Sender = senderDetail;
            CSS_getPartsListSRTRequestJ2A.Target targetDetail = new CSS_getPartsListSRTRequestJ2A.Target();
            targetDetail.TargetID = 'SRT';
            headerDeatail.Target = targetDetail;
            CSS_getPartsListSRTRequestJ2A.DataArea dataAreadetails = new CSS_getPartsListSRTRequestJ2A.DataArea();

            faildssim = new set<string>();
            uniquelist = new list<string>();
            
            

            CSS_Solution_Component__c solCompObj = [select Id, Name, Component_Id__c,Covered_Parts__c,CSS_Account_Formula__c, FailCode_Formula__c, CoveredPartsQty__c from CSS_Solution_Component__c where id =: solCompId];

            //Defect: 190433
            List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c,Account_Code__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' and Account_Code__c = : solCompObj.CSS_Account_Formula__c order by Attribute2__c asc];
            string coveragetype = '';
            for(CSS_JobEventTemporary__c temp : jobEventTemp)
                coveragetype = temp.Attribute1__c;
            
            //Defect: 190433
            //if(solCompObj != null && solCompObj.size()>0){
            //for(CSS_Solution_Component__c x : solCompObj){
            if(solCompObj.Component_Id__c != null && solCompObj.Component_Id__c != ''){
                faildssim.add(solCompObj.Component_Id__c);  
            }
            //}
            uniquelist.addall(faildssim);

            list<CSS_Parts_Options__c> Parts = new list<CSS_Parts_Options__c>();
            Parts =  [Select id,Option_Number__c,Service_Job__c, CSS_Claims__c, Solutions__c, Option_ESN__c, selected_part__c, FailureName__c,
                      Assignment__c,FailurepartId__c,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,
                      Service_partnumber__c from CSS_Parts_Options__c where CSS_Claims__c = : claims.Id AND RecordType.Name = 'Options'];
            //((Service_Job__c =: serJobObj.Id AND RecordType.Name = 'Options') OR (Service_Job__c =: serJobObj.Id AND Solutions__c =: solCompObj[0].Solutions__c))];

            // string rectype = 
            //list<CSS_Parts_Options__c> prtRec = new list<CSS_Parts_Options__c>();
            list<string> options = new list<string>();
            if(Parts != null && Parts.size() > 0){
                for(CSS_Parts_Options__c y : Parts){
                    if(y.Option_Number__c != null && y.Option_Number__c != '' && y.Option_ESN__c == claims.ESN__c && y.recordtypeId == recTypeIdoption ){
                        options.add(y.Option_Number__c);
                    }
                    if(y.RecordType.Name == 'Parts'){
                        system.debug('Anirudh Entered PartrecList'+y.RecordType.Name);
                        //prtRec.add(y);
                    }
                    system.debug('Anirudh Entered PartrecList Outside'+y.RecordType.Name);
                }
            } 
            system.debug('options list testr'+options);
            //system.debug('uniquelist testr'+uniquelist);
            dataAreadetails.JobID =  'CSS-00020125';//serJobObj.Name; // Sai: 6/2 : Changed JobId to JobID
            dataAreadetails.ClaimID = claims.Name;//'C100002045';
            dataAreadetails.Languagecode = lang;
            dataAreadetails.EngineFamilyCode = claims.CSS_PSNs__r[0].Qsol_Engine_Family_Code__c;//serJobObj.Qsol_Engine_Family_Code__c;
            dataAreadetails.ServiceModelName = claims.CSS_PSNs__r[0].Service_Model__c;//serJobObj.Service_Model__c;
            dataAreadetails.EquipmentID = claims.CSS_PSNs__r[0].Equipment_ID__c;//serJobObj.Equipment_ID__c;
            dataAreadetails.DTTimestamp = sysdt;
            dataAreadetails.EffectiveDTTime = sysdt;
            dataAreadetails.FailureID = uniquelist;
            dataAreadetails.OptionNumber = options;

            PartsSRTREq.Header = headerDeatail;
            PartsSRTREq.DataArea = dataAreadetails;    
            system.debug('Santosh testing parts1'+PartsSRTREq);

            //Anirudh
            CSS_getPartsListSRTResponseJ2A partslist =  CSS_WS_SRT.getPartsListSRT(PartsSRTREq);       
            system.debug('partsresponse'+partslist);



            if(partslist.Header.MessageType=='S'){
                list<CSS_Parts_Options__c> partinsert = new list<CSS_Parts_Options__c>();
                //if(solCompObj != null && !solCompObj.isEmpty()){
                system.debug('service job related components'+solCompObj);

                //for(CSS_Solution_Component__c compfail : solCompObj){
                //system.debug('insideparts'+compfail);
                //system.debug('Anirudh>>>>prtRec>>>>>>>>>>>'+prtRec);
                //if(prtRec.isEmpty()){
                //system.debug('insideparts'+prtRec);
                // for(integer s=0; s=failmapfinallist.size(); s++){
                for(CSS_getPartsListSRTResponseJ2A.DataArea partData : partslist.DataArea){
                    system.debug('shd'+partData);
                    if(solCompObj.Component_Id__c != null && solCompObj.Component_Id__c == partData.FailureID){
                        system.debug('insideparts');
                        CSS_Parts_Options__c partobj = new CSS_Parts_Options__c();
                        partobj.recordtypeId  = recTypeIdpart;
                        partobj.FailurepartId__c = solCompObj.id;
                        partobj.Name = partData.PartNumberService+string.valueOf(claims.Id)+solCompObj.id;
                        partobj.Part_Name__c = partData.PartNameService;
                        partobj.Part_Description__c = partData.PartNumberMfg;
                        partobj.OEM__c = partData.OEM;
                        partobj.FailureName__c = partData.FailureName;
                        partobj.Part_Assignment__c = partData.Assignment;
                        partobj.Service_partnumber__c = partData.PartNumberService;
                        partobj.Option_Number__c = partData.OptionNumber;
                        partobj.Option_ESN__c = claims.ESN__c;//updated
                        partobj.Quantity__c = partData.Qty;
                        partobj.Default_Part_Quantity__c = partData.Qty;
                        partobj.part_size__c = partData.PartSize;
                        partobj.Notes__c = partData.Notes;
                        //175940 Story
                        partobj.Replacement_Reason__c = 'GSQ Part';
                        //partobj.Service_Job__c = serJobObj.Id;
                        partobj.CSS_Claims__c = claims.Id;
                        if(solCompObj.CoveredPartsQty__c != null && integer.valueof(solCompObj.CoveredPartsQty__c) > 0){
                            partobj.Account_Code__c=solCompObj.CSS_Account_Formula__c;
                            partobj.Fail_Code__c = solCompObj.FailCode_Formula__c;
                            partobj.Covered__c = 100;
                        } 
                        //Defect # 190433
                        else {
                            
                             if(coveragetype!= null && coveragetype != '' &&  coveragetype == 'OTH') {
                                partobj.Account_Code__c=solCompObj.CSS_Account_Formula__c;
                            partobj.Fail_Code__c = solCompObj.FailCode_Formula__c;
                            partobj.Covered__c = 100;
                            }
                        }
                         if(coveragetype!= null && coveragetype != '' && coveragetype == 'POL') {
                                partobj.Account_Code__c=solCompObj.CSS_Account_Formula__c;
                            partobj.Fail_Code__c = solCompObj.FailCode_Formula__c;
                            partobj.Covered__c = integer.valueof(solCompObj.Covered_Parts__c);
                            }
                        
                        system.debug('partobj.Covered__c'+partobj.Covered__c);
                        //partobj.Covered__c=solCompObj.CoveredPartsQty_Percentage__c;
                        //partobj.Solutions__c = solCompObj.Solutions__c;
                        partinsert.add(partobj); 
                    }  
                }
                // } // for loop 
                //}
                //} 
                system.debug('final object related list records'+partinsert);
                if(partinsert != null && partinsert.size() > 0)
                    insert partinsert;
                //} 
                if(claims != null && partinsert != null && partinsert.size() > 0){
                    claims.Parts_ODM_Status__c = 'YTBV';
                    update claims;
                }
            }
            //} 
        } catch(exception e){
            system.debug('Entered in exception block of srtPartsClaims method>>>>'+e.getMessage() + ' ' + e.getLineNumber());
        }   
    }

    public CSS_SRTComponentLookupRequestJ2A failureCodeReq;
    public CSS_SRTComponentLookupResponseJ2A failureCodeDetails;
    public CSS_SRTComponentLookupResponseJ2A getFailureCodesSRT(String SMN, String engFamily, String langCode){
        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        if((SMN!=null && SMN!='') && (engFamily!=null && engFamily!='') && (langCode!=null && langCode!='')){
            //comment below link added by roopa for fixing the defect related to access token in CSS Training env on 10/30/2017
            //   String accessToken = CSS_WS_OAG.getAccessToken();
            //String accessToken = CSS_SRT.splreceiveToken(Label.CSS_SRTAltOAuth); //Commented for Dynamic Authentication and added below lines
            //Commented below line as part of Mule Integration
            //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('SRT').AuthEnv__c);
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('SRT').AuthEnv__c,'SRT');
            String accessToken = accessTokenOPWrap.accessToken;
            //system.debug('accessToken'+accessToken);

            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken)){
                css_utility.LogOutIntError('CSS_FN_SRT-ComponentLookupService', 'OAG Token Service failed', 'OAG Token is null', 'OAGOAuth');
                return null;
            }
            failureCodeReq = prepareRqWrapperSRTComponentLookup(SMN, engFamily, langCode);
            system.debug('failureCodeReq'+failureCodeReq);
            String ComponentLookupReqBody = JSON.serialize(failureCodeReq);
            
            //Added as part of Mule Integration Start
            
            String serviceModelName = SMN.replace(' ','%20');
            system.debug('serv**'+serviceModelName);
            
            //Added as part of Mule Integration End
            String endPointURL;
            CSS_Integration_Details__c connection = new CSS_Integration_Details__c ();
            connection = CSS_getConnnectionDetails.getConnection('SRT');
            system.debug('connection'+connection);
            if(connection != null) {
                endPointURL = connection.End_Point__c;
                //Commented below line as part of Mule Integration
                //endPointURL = endPointURL.substring(0, endPointURL.indexOf('css',0))+'css/srtfailurecode';
                //endPointURL = endPointURL.substring(0, endPointURL.indexOf('cmi-engine',0))+'cmi-engine/failcodes?sender=CSS&target=SRT&engineFamilyCode='+engFamily+'&serviceModelName='+SMN+'&languageCode='+langCode+'';
            //endPointURL = endPointURL.substring(0, endPointURL.indexOf('cmi-engine',0))+'cmi-engine/failcodes?sender=CSS&target=SRT&engineFamilyCode=10&serviceModelName=ISXCM871E&languageCode=en';
            endPointURL = endPointURL.substring(0, endPointURL.indexOf('cmi-engine',0))+'cmi-engine/failcodes?sender=CSS&target=SRT&engineFamilyCode='+engFamily+'&serviceModelName='+serviceModelName+'&languageCode='+langCode;
            system.debug('endPointURL'+endPointURL);
            }
            //Below code added as part of Mule Integration start
            reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.jsonReqBody = JSON.serialize(failureCodeReq).replace('null','""');
            reqWrapper.serviceName = 'SRT';
            reqWrapper.methodType = 'GET';
            reqWrapper.endPoint = endPointURL;
            
            if(!Test.isRunningTest() && failureCodeReq != null)
			{
				returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
			}
			HttpResponse httpRes;
			if(returnWrapper!=null){
			    httpRes=returnWrapper.response;
			}
            //Below code added as part of Mule Integration end
            
            
            //HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(ComponentLookupReqBody, endPointURL, accessToken);
            system.debug('httpRes>>>>>>'+httpRes);
            if(httpRes == null || httpRes.getStatusCode() != 200){
                css_utility.LogOutIntError('CSS_FN_SRT-ComponentLookupService', 'SRT Component Lookup(FailureCode) HttpResponse is null', 'SRT Component Lookup Webservice Execution failed', 'SRT');
                return null;
            }else if(httpRes.getBody().contains('OSB Service Callout action received SOAP Fault response') ){
                System.debug('Incorrect json format-- STATUS:'+httpRes.getStatus()+'STATUS_CODE:'+httpRes.getStatusCode());
                css_utility.LogOutIntError('CSS_FN_SRT-ComponentLookupService', 'SRT Component Lookup(FailureCode) gives wrong response', 'OSB Service Callout action received SOAP Fault response', 'SRT');
                return null;
            }
            failureCodeDetails = (CSS_SRTComponentLookupResponseJ2A)JSON.deserializeStrict(httpRes.getBody(), CSS_SRTComponentLookupResponseJ2A.class);
            system.debug('failureCodeDetails'+failureCodeDetails);
            return failureCodeDetails;        
        }
        return null;
    }
    public CSS_SRTComponentLookupRequestJ2A prepareRqWrapperSRTComponentLookup(String SMN, String engFamily, String langCode){
        failureCodeReq = new CSS_SRTComponentLookupRequestJ2A();
        failureCodeDetails = new CSS_SRTComponentLookupResponseJ2A();
        CSS_SRTComponentLookupRequestJ2A.Header HeaderDetails = new CSS_SRTComponentLookupRequestJ2A.Header();
        CSS_SRTComponentLookupRequestJ2A.Sender SenderDetails = new CSS_SRTComponentLookupRequestJ2A.Sender();
        SenderDetails.ServiceName = 'GetFailureCodesSRT';
        SenderDetails.SenderID = 'CSS';
        HeaderDetails.Sender = SenderDetails;
        CSS_SRTComponentLookupRequestJ2A.Target TargetDetails = new CSS_SRTComponentLookupRequestJ2A.Target();
        TargetDetails.TargetID = 'SRT';
        HeaderDetails.Target = TargetDetails;
        failureCodeReq.Header = HeaderDetails;
        CSS_SRTComponentLookupRequestJ2A.DataArea dArea = new CSS_SRTComponentLookupRequestJ2A.DataArea();
        dArea.ServiceModelName = SMN;
        dArea.EngineFamilyCode = engFamily;
        dArea.LanguageCode = langCode;
        failureCodeReq.DataArea = dArea;
        return failureCodeReq;
    }

    public static void getMakeModalEquipmentIdList(String lastRunDate){
        System.debug('################# entered into getMakeModalEquipmentIdList method ###################');
        String senderID;
        String serviceName;
        String messageID;
        String endPointURL;
        CSS_WPR_SRT_MakeModalEquipIdReqJSON makeModalEquipReqJSON;
        CSS_WPR_SRT_MakeModalEquipIdResJSON makeModalEquipResJSON;
        //Added as part of Mule Integration
        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        try{
            //calling getAccessToken Service
            //comment below link added by roopa for fixing the defect related to access token in CSS Training env on 10/30
            // String accessToken = CSS_WS_OAG.getAccessToken();
            //String accessToken = CSS_SRT.splreceiveToken(Label.CSS_SRTAltOAuth); //Commented for Dynamic Authentication and added below lines
            //Commented below line as part of Mule Integration
            //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('MakeModelEquipmentId').AuthEnv__c);
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('MakeModelEquipmentId').AuthEnv__c,'MakeModelEquipmentId');
            String accessToken = accessTokenOPWrap.accessToken;
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
               || String.isEmpty(accessToken) ){
                css_utility.LogOutIntError('CSS_FN_SRT-'+serviceName, 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                return;
            }

            //Prepare Request JSON
            makeModalEquipReqJSON = CSS_WS_SRT.prepareReqJSONForMakeModalEquipmentId(lastRunDate);
            String makeModalEquipReqJSONStr = JSON.serialize(makeModalEquipReqJSON);
            System.debug('makeModalEquipReqJSONStr>>>>>>>>>>>>>>>>>>>>:'+makeModalEquipReqJSONStr);

            //endPointURL = CSS_getConnnectionDetails.getConnection('MakeModelEquipmentId').End_Point__c;
            endPointURL = CSS_getConnnectionDetails.getConnection('MakeModelEquipmentId').End_Point__c+'?sender=CSS&target=CSSWarranty&LastRunDate='+lastRunDate+'&LangCode=en';
            system.debug('endPointURL__>'+endPointURL);
            
            //Below code added as part of Mule Integration start
            reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.jsonReqBody = JSON.serialize(makeModalEquipReqJSON).replace('null','""');
            reqWrapper.serviceName = 'MakeModelEquipmentId';
            reqWrapper.methodType = 'GET';
            reqWrapper.endPoint = endPointURL;
            
            HttpResponse httpRes;
            if(!Test.isRunningTest() && makeModalEquipReqJSON != null)
			{
				returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
			}
			else{
			    httpRes = new HttpResponse();
			    httpRes.setHeader('Content-Type', 'application/json');
			    httpRes.setStatusCode(200);
			    httpRes.setBody('{"Header": {"Status": "SUCCESS","ReturnCodeDescription": "Normal, Successful completion."},"DataArea": {"EquipmentData": [{"Make": "ADTRANZ","Model": "CAMOX G275","AccessCode": "B","EquipmentId": "EQ9809","Configuration": "BUS","ApplicationCategory": "A","EngineFamilyCode": "0H","Status": "ACTIVE","ServiceModelDetails": [{"SMN": "ISV5.0 CM3230 V104","EF": "0H"}]}]}}');
			}
			if(returnWrapper!=null){
			    httpRes=returnWrapper.response;
			}
            //Below code added as part of Mule Integration end
            
            //HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(makeModalEquipReqJSONStr, endPointURL, accessToken);Commented as part of Mule Integration
            if(httpRes == null || httpRes.getStatusCode() != 200){
                css_utility.LogOutIntError('CSS_FN_SRT-MakeAndModelEquipmentId', 'MakeAndModelEquipmentId Webservice Execution failed', 'MakeAndModelEquipmentId Webservice Execution failed', 'SRT');
                return;
            }
            System.debug('RESPONSE_BODY>>>:'+httpRes.getbody()+' httpRes getStatusCode is :: '+httpRes.getStatusCode()+' httpRes.toString>>>:'+httpRes.toString());
            makeModalEquipResJSON = (CSS_WPR_SRT_MakeModalEquipIdResJSON)JSON.deserializeStrict(httpRes.getBody(), CSS_WPR_SRT_MakeModalEquipIdResJSON.class);
            //System.debug('makeModalEquipResJSON>>>:'+makeModalEquipResJSON);

            String recordTypeIdSRT = [Select Id, Name from RecordType where Name = 'SRTData' limit 1].Id;
            //below logic on response data
            List<CSS_Make_Model_Access__c> makeModelEquipIdList = new List<CSS_Make_Model_Access__c>();
            //Map<Id,CSS_Make_Model_Access__c> makeModelEquipIdList = new Map<Id,CSS_Make_Model_Access__c>();
            //CSS_Make_Model__c makeModelEquipIdObj;
            CSS_Make_Model_Access__c makeModelAccessObj;
            if(makeModalEquipResJSON !=null && makeModalEquipResJSON.DataArea !=null && makeModalEquipResJSON.DataArea.EquipmentData !=null){
                List<CSS_WPR_SRT_MakeModalEquipIdResJSON.EquipmentData> equipObjList = makeModalEquipResJSON.DataArea.EquipmentData;
                Map<String, CSS_Make_Model_Access__c> makeModelAccessMap = new Map<String, CSS_Make_Model_Access__c>();
                for(CSS_WPR_SRT_MakeModalEquipIdResJSON.EquipmentData equipObj: equipObjList){
                    makeModelAccessObj = new CSS_Make_Model_Access__c();
                    makeModelAccessObj.RecordTypeId = recordTypeIdSRT;
                    makeModelAccessObj.Name = equipObj.Make + ' - ' + equipObj.Model;
                    makeModelAccessObj.Make__c = equipObj.Make;
                    makeModelAccessObj.Model__c = equipObj.Model;
                    makeModelAccessObj.Access__c = equipObj.AccessCode;
                    makeModelAccessObj.EquipmentId__c = equipObj.EquipmentId;
                    makeModelAccessObj.EngineFamilyCode__c = equipObj.EngineFamilyCode;
                    makeModelAccessObj.ApplicationCategory__c = equipObj.ApplicationCategory;
                    makeModelAccessObj.Configuration__c = equipObj.Configuration;
                    makeModelAccessObj.Status__c = equipObj.Status;
                    //added for defect 135113 by venkat
                    makeModelAccessObj.UniqueKey__c = equipObj.Make+'-'+equipObj.Model+'-'+equipObj.EngineFamilyCode+'-'+equipObj.EquipmentId;
                    if(equipObj.Status.equalsIgnorecase('ACTIVE')){
                        makeModelAccessMap.put(equipObj.Make+'-'+equipObj.Model+'-'+equipObj.EngineFamilyCode+'-'+equipObj.EquipmentId, makeModelAccessObj);
                    }

                }

                // makeModelEquipIdList.add(makeModelAccessObj);
                //makeModelEquipIdList.put(makeModelAccessObj.UniqueKey__c,makeModelAccessObj);

                System.debug('makeModelAccessMap.size()>>>:'+makeModelAccessMap.size());
                if(makeModelAccessMap !=null && makeModelAccessMap.size()>0){
                    upsert makeModelAccessMap.values() UniqueKey__c;
                    System.debug('after upsert makeModelAccessMap.size()>>>:'+makeModelAccessMap.size());
                }
            }
            //  upsert makeModelEquipIdList UniqueKey__c;
            //upsert makeModelEquipIdList.values() UniqueKey__c;

        }catch(Exception ex){
            System.debug('in catch of getMakeModalEquipmentIdList method '+serviceName+ 'of CSS_FN_SRT >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_SRT-MakeAndModelEquipmentId', 'MakeAndModelEquipmentId Webservice Execution failed', 'MakeAndModelEquipmentId Webservice Execution failed', 'SRT');
        }finally{
            endPointURL=null;makeModalEquipReqJSON=null;
        }
    }

    public static CG_FieldActionSRTResponse getFieldActionSRT(String SMN, String engFamily, String langCode, String equipID, List<CSS_Solution_Component__c> fieldActionList){
        try{
            CG_FieldActionSRTRequest fieldActionSRTRequest = new CG_FieldActionSRTRequest();
            CG_FieldActionSRTResponse fieldActionSRTResponse = new CG_FieldActionSRTResponse();
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
            system.debug('inside getFieldActionSRT');
            system.debug(SMN+' ** '+engFamily+' ** '+langCode+' ** '+equipID);
            if((SMN!=null && SMN!='') && (engFamily!=null && engFamily!='') && (langCode!=null && langCode!='') && (equipID!=null && equipID!='')){
                //String accessToken = CSS_SRT.splreceiveToken(Label.CSS_SRTAltOAuth);                 //Commented for Dynamic Authentication and added below lines
                //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CG_FieldActionSRT').AuthEnv__c);//Commented the line as part of Mule Integration
                CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CG_FieldActionSRT').AuthEnv__c,'CG_FieldActionSRT');
                String accessToken = accessTokenOPWrap.accessToken;
                //system.debug('accessToken---'+accessToken);
                if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken)){
                    css_utility.LogOutIntError('CSS_FN_SRT-Field Action SRT', 'OAG Token Service failed', 'OAG Token is null', 'OAGOAuth');
                    return null;
                }
                CG_FieldActionSRTRequest.Header HeaderDetails = new CG_FieldActionSRTRequest.Header();
                CG_FieldActionSRTRequest.Sender SenderDetails = new CG_FieldActionSRTRequest.Sender();
                SenderDetails.ServiceName = 'GetFieldActionSRTs';
                SenderDetails.MessageID = 'Unique Message ID at SF';
                SenderDetails.SenderID = 'SF';
                HeaderDetails.Sender = SenderDetails;
                CG_FieldActionSRTRequest.Target TargetDetails = new CG_FieldActionSRTRequest.Target();
                TargetDetails.TargetID = 'SRT';
                HeaderDetails.Target = TargetDetails;
                fieldActionSRTRequest.Header = HeaderDetails;
                CG_FieldActionSRTRequest.DataArea dArea = new CG_FieldActionSRTRequest.DataArea();
                String dateTemp;
                dateTemp = String.valueof(system.now());
                List<String> tempString = new List<String>();
                tempString = dateTemp.split(' ');
                dArea.DTTimestamp = tempString[0] + 'T' + tempString[1];//String.valueof(system.now());
                dArea.EngineFamilyCode = engFamily;
                dArea.ServiceModelName = SMN;
                dArea.EffectiveDTTime = tempString[0] + 'T' + tempString[1];//String.valueof(system.now());
                dArea.EquipmentID = equipID;
                dArea.Language = langCode;
                fieldActionSRTRequest.DataArea = dArea;
                dArea.FieldAction = new List<CG_FieldActionSRTRequest.FieldAction>();
                CG_FieldActionSRTRequest.FieldAction lstFieldAction = new CG_FieldActionSRTRequest.FieldAction();

                for(CSS_Solution_Component__c fieldAction : fieldActionList){
                    CG_FieldActionSRTRequest.FieldAction fieldActionObj = new CG_FieldActionSRTRequest.FieldAction();
                    if(fieldAction.Component_Id__c != null && fieldAction.Component_Id__c != ''){
                        fieldActionObj.FieldActionNumber = fieldAction.Component_Id__c;
                        fieldActionObj.FieldActionType = fieldAction.Type__c;
                        fieldActionObj.SRTTab = null;
                        fieldActionSRTRequest.DataArea.FieldAction.add(fieldActionObj);
                    }
                }

                String fieldActionReqBody = JSON.serialize(fieldActionSRTRequest);
                
                CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                conDetails = CSS_getConnnectionDetails.getConnection('CG_FieldActionSRT');
                String endPoint = conDetails.End_Point__c;
                reqWrapper.endPoint = endPoint;
                reqWrapper.jsonReqBody = fieldActionReqBody;
                reqWrapper.serviceName = 'CG_FieldActionSRT';
                //reqWrapper.methodType = 'POST';Commented as part of Mule Integration
                reqWrapper.methodType = conDetails.Method_Type__c;//Added as part of Mule Integration
                reqWrapper.timeOut = 120000;
                
                //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
                //returnWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
                returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                system.debug('returnWrapper--'+returnWrapper);
                HttpResponse httpRes = returnWrapper.response;
                system.debug('httpRes--'+httpRes);
                fieldActionSRTResponse = (CG_FieldActionSRTResponse)JSON.deserializeStrict(httpRes.getBody(), CG_FieldActionSRTResponse.class);
                return fieldActionSRTResponse;        
            }
            else
                return null;
        }
        catch (exception ex) {
            system.debug('In catch block of Field Action SRT service callout with message' + ex.getMessage() + ' in the line ' + ex.getLineNumber());
            return null;
        }
    }
    //Added as part of the story GSSC-155
    public static CG_DiagTargetTimeResponse getDiagnosticTargetTime(List<String> solIds, String equipID, String SMN, String engFamily, String langCode){
        try{
            CG_DiagTargetTimeRequest diagTargetTimeRequest = new CG_DiagTargetTimeRequest();
            CG_DiagTargetTimeResponse diagTargetTimeResponse = new CG_DiagTargetTimeResponse();
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
            system.debug('inside getDiagnosticTargetTime');
            system.debug(SMN+' ** '+engFamily+' ** '+langCode+' ** '+equipID);
            if(solIds != null && (SMN!=null && SMN!='') && (engFamily!=null && engFamily!='') && (langCode!=null && langCode!='') && (equipID!=null && equipID!='')){
                CG_DiagTargetTimeRequest.Header HeaderDetails = new CG_DiagTargetTimeRequest.Header();
                CG_DiagTargetTimeRequest.Sender SenderDetails = new CG_DiagTargetTimeRequest.Sender();
                SenderDetails.ServiceName = 'GetDiagnosticTargetTime';
                SenderDetails.MessageID = 'Unique Message ID at SF';
                SenderDetails.SenderID = 'SF';
                HeaderDetails.Sender = SenderDetails;
                CG_DiagTargetTimeRequest.Target TargetDetails = new CG_DiagTargetTimeRequest.Target();
                TargetDetails.TargetID = 'SRT';
                HeaderDetails.Target = TargetDetails;
                diagTargetTimeRequest.Header = HeaderDetails;
                CG_DiagTargetTimeRequest.DataArea dArea = new CG_DiagTargetTimeRequest.DataArea();
                String dateTemp;
                dateTemp = String.valueof(system.now());
                List<String> tempString = new List<String>();
                tempString = dateTemp.split(' ');
                dArea.EffectiveDateTime = tempString[0] + 'T' + tempString[1];
                dArea.ServiceModelName = SMN;
                dArea.EquipmentID = equipID;
                dArea.LanguageCode = langCode;
                dArea.EngineFamily = engFamily;
                diagTargetTimeRequest.DataArea = dArea;
                dArea.SolutionIds = new List<String>();

                for(String solutionId : solIds){
                    diagTargetTimeRequest.DataArea.SolutionIds.add(solutionId);
                }
        
                String diagTimeTargetReqBody = JSON.serialize(diagTargetTimeRequest);
                system.debug('diagTimeTargetReqBody-->'+diagTimeTargetReqBody);
                
                //Added below code for mule integration
                CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                conDetails = CSS_getConnnectionDetails.getConnection('CG_GetDiagTargetTime');
                String endPoint = conDetails.End_Point__c;
                reqWrapper.endPoint = endPoint;
                
                reqWrapper.jsonReqBody = diagTimeTargetReqBody;
                reqWrapper.serviceName = 'CG_GetDiagTargetTime';
                reqWrapper.methodType = 'POST';
                reqWrapper.timeOut = 120000;

                //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
                returnWrapper = CG_WS_Mule.calloutGeneric(reqWrapper); //calloutGenericMule //calloutGeneric
                system.debug('returnWrapper--'+returnWrapper);
                HttpResponse httpRes = returnWrapper.response;
                system.debug('httpRes--'+httpRes);
                diagTargetTimeResponse = (CG_DiagTargetTimeResponse)JSON.deserializeStrict(httpRes.getBody(), CG_DiagTargetTimeResponse.class);
                return diagTargetTimeResponse;        
            }
            else
                return null;
        }
        catch (exception ex) {
            system.debug('In catch block of Diagnosis Target Time service callout with message' + ex.getMessage() + ' in the line ' + ex.getLineNumber());
            return null;
        }
    }
      public static CG_DiagTargetTimeResponse getDiagnosticTargetTime(Set<String> solIds, String equipID, String SMN, String engFamily, String langCode){
        try{
            CG_DiagTargetTimeRequest diagTargetTimeRequest = new CG_DiagTargetTimeRequest();
            CG_DiagTargetTimeResponse diagTargetTimeResponse = new CG_DiagTargetTimeResponse();
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
            system.debug('inside getDiagnosticTargetTime');
            system.debug(SMN+' ** '+engFamily+' ** '+langCode+' ** '+equipID);
            if(solIds != null && (SMN!=null && SMN!='') && (engFamily!=null && engFamily!='') && (langCode!=null && langCode!='') && (equipID!=null && equipID!='')){
                CG_DiagTargetTimeRequest.Header HeaderDetails = new CG_DiagTargetTimeRequest.Header();
                CG_DiagTargetTimeRequest.Sender SenderDetails = new CG_DiagTargetTimeRequest.Sender();
                SenderDetails.ServiceName = 'GetDiagnosticTargetTime';
                SenderDetails.MessageID = 'Unique Message ID at SF';
                SenderDetails.SenderID = 'SF';
                HeaderDetails.Sender = SenderDetails;
                CG_DiagTargetTimeRequest.Target TargetDetails = new CG_DiagTargetTimeRequest.Target();
                TargetDetails.TargetID = 'SRT';
                HeaderDetails.Target = TargetDetails;
                diagTargetTimeRequest.Header = HeaderDetails;
                CG_DiagTargetTimeRequest.DataArea dArea = new CG_DiagTargetTimeRequest.DataArea();
                String dateTemp;
                dateTemp = String.valueof(system.now());
                List<String> tempString = new List<String>();
                tempString = dateTemp.split(' ');
                dArea.EffectiveDateTime = tempString[0] + 'T' + tempString[1];
                dArea.ServiceModelName = SMN;
                dArea.EquipmentID = equipID;
                dArea.LanguageCode = langCode;
                dArea.EngineFamily = engFamily;
                diagTargetTimeRequest.DataArea = dArea;
                dArea.SolutionIds = new List<String>();

                for(String solutionId : solIds){
                    diagTargetTimeRequest.DataArea.SolutionIds.add(solutionId);
                }
        
                String diagTimeTargetReqBody = JSON.serialize(diagTargetTimeRequest);
                system.debug('diagTimeTargetReqBody-->'+diagTimeTargetReqBody);
                
                //Added below code for mule integration
                CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                conDetails = CSS_getConnnectionDetails.getConnection('CG_GetDiagTargetTime');
                String endPoint = conDetails.End_Point__c;
                reqWrapper.endPoint = endPoint;
                
                reqWrapper.jsonReqBody = diagTimeTargetReqBody;
                reqWrapper.serviceName = 'CG_GetDiagTargetTime';
                reqWrapper.methodType = 'POST';
                reqWrapper.timeOut = 120000;

                //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
                returnWrapper = CG_WS_Mule.calloutGeneric(reqWrapper); //calloutGenericMule //calloutGeneric
                system.debug('returnWrapper--'+returnWrapper);
                HttpResponse httpRes = returnWrapper.response;
                system.debug('httpRes--'+httpRes);
                diagTargetTimeResponse = (CG_DiagTargetTimeResponse)JSON.deserializeStrict(httpRes.getBody(), CG_DiagTargetTimeResponse.class);
                return diagTargetTimeResponse;        
            }
            else
                return null;
        }
        catch (exception ex) {
            system.debug('In catch block of Diagnosis Target Time service callout with message' + ex.getMessage() + ' in the line ' + ex.getLineNumber());
            return null;
        }
    }
}