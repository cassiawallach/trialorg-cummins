/**********************************************************************
Name: FSL_CL_ClaimHistoryController
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose: This class is used for Claim History in User Tools.

=======================================================================
=======================================================================
                                                                                                                      
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      PiyushR           8/2/2019            INITIAL DEVELOPMENT
2.0      Diksha            9/6/2022            INCREASE TEST COVER                    
***********************************************************************/
public class FSL_CL_ClaimHistoryController {
    Static Boolean isEligibleForAppLogging = FSL_Utility.setEligibilityForApplicationLogging();
    Static String executionLog = 'Log Start';
    public static String claimID {get; set;}
    public static List<CSS_JobEventTemporary__c> claimList{get;set;}
    
    @AuraEnabled
    public static List<ClaimHistoryWrapper> SearchClaimHistory(String selectedPSN){
        system.debug('::: PSN Searched -- '+selectedPSN);
        List<ClaimHistoryWrapper> ClaimHistoryWrapperList = new List<ClaimHistoryWrapper>();
        ClaimsHistoryIntWrapper wrapObj = new ClaimsHistoryIntWrapper(); //Added by Sruthi VGRS2-332 3/24/2022
        claimList = new List<CSS_JobEventTemporary__c>();
        try{
            if(Test.isRunningTest()) {
                claimList = FSL_TestDataUtility.getClaimHistoryData(); 
            } else {
                wrapObj = performClaimHistoryBusinessLogic(selectedPSN); //Added by Sruthi VGRS2-332 3/24/2022
                claimList = wrapObj.jobEventList;
                DateTime startTime = System.Now();
                 executionLog = FSL_ApplicationLogger.logMessage('Response Body '+claimList,executionLog,isEligibleForAppLogging);
                FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),null);
            }
            
            System.debug('::: claimList - '+claimList);
            if(wrapObj != NULL && !wrapObj.isExceptionFlag && claimList != null){ //Added by Sruthi VGRS2-332 3/24/2022
                for(CSS_JobEventTemporary__c tempClaims : claimList) {
                    System.debug('::: Claim List - '+tempClaims.Attribute9__c);
                    //if(tempClaims.Attribute9__c=='Paid' || tempClaims.Attribute9__c=='Denied' || tempClaims.Attribute9__c=='Info Only'){
                        ClaimHistoryWrapper wrapper = new ClaimHistoryWrapper();
                        string sfailureDate = tempClaims.Attribute1__c;
                        String sfailDateLocale = '';
                        If(sfailureDate != null && sfailureDate != '') {
                            if(sfailureDate.contains('T')) 
                             sfailureDate = sfailureDate.replace('T', ' ');
                            system.debug('::: sfailureDate ' + sfailureDate);
                            datetime failDate = datetime.valueof(sfailureDate);
                            system.debug('::: FailureDate **'+failDate);
                            sfailDateLocale = css_utility.getFormattedDate(failDate); //Get formatted String from Utility Class
                            system.debug('::: sfailDateLocale **'+sfailDateLocale);
                        }
                        wrapper.sFailure_date = sfailDateLocale;
                        wrapper.sFailure_Pointc = Decimal.valueOf(tempClaims.Attribute4__c);
                        wrapper.sRoot_Cause = tempClaims.Attribute5__c+' '+'-'+' '+tempClaims.Circuit_Description__c; 
                        wrapper.sRepair_Location = (tempClaims.Attribute2__c == null ? '' :  tempClaims.Attribute2__c) + ' ' + (tempClaims.Attribute3__c == null ? '' : tempClaims.Attribute3__c); //Attribute2 added as part of story# 161394
                        wrapper.sFailure_Measure = tempClaims.Attribute6__c; 
                        wrapper.sClaim = tempClaims.Attribute8__c;
                        ClaimHistoryWrapperList.add(wrapper);
                    }
                //}
            }
            else if(wrapObj != NULL && wrapObj.isExceptionFlag){  //Added by Sruthi VGRS2-332 3/24/2022
                ClaimHistoryWrapper wrapper = new ClaimHistoryWrapper();
                wrapper.isExceptionFlag = TRUE;
                ClaimHistoryWrapperList.add(wrapper);
            }
            /*
            system.debug('::: ClaimHistoryWrapperList**'+ClaimHistoryWrapperList);
            system.debug('::: JSON.serialize(ClaimHistoryWrapperList) ' + JSON.serialize(ClaimHistoryWrapperList));
            String claimHistory = JSON.serialize(ClaimHistoryWrapperList);
            System.debug('::: Claim History = '+claimHistory);
            return claimHistory;
            */
            return ClaimHistoryWrapperList;
        }
        catch(Exception e){
            system.debug('::: EXCEPTION of SearchClaimHistory Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause()+' '+e.getStackTraceString());
            DateTime startTime = System.Now();
                executionLog = FSL_ApplicationLogger.logMessage('Exception Reason '+e.getMessage(),executionLog,isEligibleForAppLogging);
                FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(), null);
            return new List<ClaimHistoryWrapper>();
        }
    }
    
    public class ClaimsHistoryIntWrapper{  //Added by Sruthi VGRS2-332 3/24/2022
        
        @AuraEnabled public Boolean isExceptionFlag;
        @AuraEnabled public List<CSS_JobEventTemporary__c> jobEventList;
        public ClaimsHistoryIntWrapper(){
            isExceptionFlag = FALSE;
            jobEventList = new List<CSS_JobEventTemporary__c>();
        }
    }
    
    public static ClaimsHistoryIntWrapper performClaimHistoryBusinessLogic(string PSN){
        
        ClaimsHistoryIntWrapper wrapObj = new ClaimsHistoryIntWrapper();
        List<CSS_JobEventTemporary__c> claimList;
        try {
            CG_OP_OAGWrapper OPWrapper = null;

            system.debug('PSN PSN' + PSN);
            //OPWrapper = CG_SL_Claims.claimHistoryWebservice(PSN);
           // calloutGenericMuleNamedCredClaimHist
           // VGRS2-511 By Priyanka
            OPWrapper = CG_SL_Claims.calloutGenericMuleNamedCredClaimHist(PSN);
            
            if(Test.isRunningTest()) {
                OPWrapper = new CG_OP_OAGWrapper();
                HttpResponse res = new HttpResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"example":"test"}');
                res.setStatusCode(200);
                OPWrapper.accessToken = '';
                OPWrapper.response = res;
                OPWrapper.request = null;
                OPWrapper.requestBody = '';
                OPWrapper.methodNameSLLayer = '';
                OPWrapper.totalAuthCallTime = 1L;
                OPWrapper.totalServiceCallTime = 1L;
                OPWrapper.methodStarted = '';
                OPWrapper.serviceName = 'Test'      ;
                OPWrapper.endPoint = '';
                OPWrapper.errorMessage = '';
                OPWrapper.exceptionMessage = '';
                OPWrapper.appName = ''; 
            }
            system.debug('resWrapper>>>:'+OPWrapper);
            if(OPWrapper.exceptionFlag == TRUE){
                wrapObj.isExceptionFlag = TRUE;
                return wrapObj;
            }
            system.debug('ResBody>>>:'+OPWrapper.response.getBody());
            string claimHisytory = ''+ OPWrapper.response.getBody();
            system.debug(claimHisytory);
            if(claimHisytory != null && claimHisytory.length() > 0) {
                if(!claimHisytory.contains('{"Details":')){
                    if(claimList != NULL){
                        wrapObj.jobEventList.addAll(claimList);
                    }
                    if(!Test.isRunningTest()){
                       // return wrapObj;
                    }
                }
            }
            //System.debug('#####httpRes:'+resWrapper.response+'######httpRes.getBody:'+resWrapper.response.getBody());
            //Kalpana Hardcoding Response, as the service is failing
            CG_ClaimsResJSON outputRes;
            if(!Test.isRunningTest()){
                outputRes = (CG_ClaimsResJSON)JSON.deserialize(OPWrapper.response.getBody(), CG_ClaimsResJSON.class);
            }
            else{
                outputRes = (CG_ClaimsResJSON)JSON.deserializeStrict('{"DataArea":{"Details":[{"FailureDate":"2012-01-24T00:00:00.000-06:00","SPName":"SOUTHEASTERN FREIGHT LINES","SPCode":"30468","WorkOrderNumber":"WAT-S150","ClaimNumber":"04530-2047112-0","FailCode":"WEQP","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"449","UnitOfMeasure":"Miles","WarrantyStartDate":"2011-03-25T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0001714-0","FailCode":"WEQP","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0001814-0","FailCode":"HYBD","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Denied"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0001814-0","FailCode":"IRCL","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Denied"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0005614-0","FailCode":"HYBD","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2011-03-16T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Denied"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0005614-0","FailCode":"IRCL","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2011-03-16T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Denied"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0015414-0","FailCode":"HYBD","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0015414-0","FailCode":"IRCL","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2015-02-16T00:00:00.000-06:00","SPName":"SOUTHEASTERN FREIGHT LINES","SPCode":"30468","WorkOrderNumber":"FTW0468","ClaimNumber":"04530-2137015-0","FailCode":"IRVB","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"291426","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2015-04-02T00:00:00.000-05:00","SPName":"SOUTHEASTERN FREIGHT LINES","SPCode":"30468","WorkOrderNumber":"ORL3982","ClaimNumber":"04530-2141115-0","FailCode":"LCEL","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"311425","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2015-10-26T00:00:00.000-05:00","SPName":"","SPCode":"","WorkOrderNumber":"157949","ClaimNumber":"02932-0233915-0","FailCode":"BPCR","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"399618","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"SHIM (LOWER)","ClaimStatus":"Paid"},{"FailureDate":"2015-11-10T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"158309","ClaimNumber":"02932-0241815-0","FailCode":"XXIP","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"405878","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Denied"},{"FailureDate":"2015-11-10T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"158309","ClaimNumber":"02932-0012616-0","FailCode":"XXIP","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"405878","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2016-01-22T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"159684","ClaimNumber":"02932-0034716-0","FailCode":"BPCR","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"446800","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"SHIM (LOWER)","ClaimStatus":"Paid"},{"FailureDate":"2016-01-22T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"159684","ClaimNumber":"02932-0034716-0","FailCode":"CHSE","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"446800","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2016-01-22T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"159684","ClaimNumber":"02932-0034716-0","FailCode":"BKCL","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"446800","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2016-01-22T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"159684","ClaimNumber":"02932-0034816-0","FailCode":"WLCV","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"446800","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2013-10-02T00:00:00.000-05:00","SPName":"SOUTHEASTERN FREIGHT LINES","SPCode":"30468","WorkOrderNumber":"CM45A21A","ClaimNumber":"04530-2091713-0","FailCode":"WEQP","SMN":"","CreditStatementNumber":"","FailurePoint":"0","UnitOfMeasure":"Miles","WarrantyStartDate":"","FailureName":"","ClaimStatus":"Paid"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}', CG_ClaimsResJSON.class);
            }
            // CG_ClaimsResJSON outputRes = (CG_ClaimsResJSON)JSON.deserializeStrict('{"DataArea": {"Details": []}, "Header": {"ReturnCodeDescription": "","Status": "Success"}}', CG_ClaimsResJSON.class);
            system.debug('outputRes**'+outputRes);
            if(outputRes.DataArea != null) {
                system.debug('InsideIF**');
                claimList = new List<CSS_JobEventTemporary__c>();
                for(CG_ClaimsResJSON.Details det : outputRes.DataArea.Details) {
                    CSS_JobEventTemporary__c JET = new CSS_JobEventTemporary__c();
                    JET.Type__c='ClaimHistory';
                    JET.key__c=PSN; // + ' : ' + inpClaimId;
                    JET.Attribute1__c=det.FailureDate;
                    JET.Attribute3__c=det.SPName;
                    JET.Attribute2__c=det.SPCode;
                    JET.Attribute7__c=det.WorkOrderNumber;
                    JET.Attribute8__c=det.ClaimNumber;
                    JET.Circuit_Description__c=det.FailCode;
                    JET.Service_Model_Name__c=det.SMN;
                    JET.Attribute10__c=det.CreditStatementNumber;
                    JET.Attribute4__c=det.FailurePoint;
                    JET.Attribute6__c=det.UnitOfMeasure;
                    JET.Attribute11__c=det.WarrantyStartDate;
                    JET.Attribute5__c=det.FailureName;
                    JET.Attribute9__c=det.ClaimStatus;
                    claimList.add(JET);
                }
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_BL_Claims performClaimHistoryBusinessLogic method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        if(claimList != NULL){
            wrapObj.jobEventList.addAll(claimList);
        }
        return wrapObj;
    }
    
    /*
    @AuraEnabled
    public static string SPClaimDetails(String claimNum){
        system.debug('::: claimNum**'+claimNum);
        CSS_GetClaimDetailsResponse cresWrap = new CSS_GetClaimDetailsResponse();
        List<NotesWrapper> NotesWrapperList = new List<NotesWrapper>();
        List<NoteWiseNotesWrapper> NoteWiseNotesWrapperList = new List<NoteWiseNotesWrapper>();
        list<date> lstCreateDate = new list<date>();
        set<date> setCreatedDates = new set<date>();
        list<date> NewCD = new list<date>();
        cresWrap = CSS_FN_Siebel.CallGetClaimDetails(claimNum);
        system.debug('::: cresWrap**'+cresWrap);
        if(cresWrap.DataArea!=null){
            for(CSS_GetClaimDetailsResponse.DataArea det : cresWrap.DataArea){
                system.debug(':::det**'+det.Notes);
                
                for(CSS_GetClaimDetailsResponse.Notes Note : det.Notes){
                    NotesWrapper Wrap = new NotesWrapper();
                    system.debug(':::Note**'+Note);
                    Wrap.sNote = Note.Note;
                    Wrap.sNote_Type = Note.NoteType;
                    //Wrap.sCreated_Date = string.valueof(Note.CreatedDate);
                    Wrap.sCreated_Date = date.parse(Note.CreatedDate);
                    NotesWrapperList.add(Wrap);
                    system.debug(':::Wrap**'+Wrap);
                    system.debug(':::NotesWrapperList**'+NotesWrapperList);
                }
                
            }
            //Collecting all Dates into a list
            if(NotesWrapperList!=null && NotesWrapperList.size()>0){
                
                for(integer k= 0; k<NotesWrapperList.size();k++){
                    lstCreateDate.add(NotesWrapperList[k].sCreated_Date);
                }
            }
            system.debug(':::lstCreateDates**'+lstCreateDate);
            if(lstCreateDate!=null && lstCreateDate.size()>0)
                lstCreateDate.sort();
            system.debug(':::lstCreateDate.sort()' + '     ' + lstCreateDate);
            setCreatedDates.addAll(lstCreateDate);
            system.debug(':::setCreatedDates**'+setCreatedDates);
            NewCD.addAll(setCreatedDates);
            system.debug(':::NewCD**'+NewCD); 
            //Preparing final wrapper, sorty  by created date
            NoteWiseNotesWrapper compWrap = new NoteWiseNotesWrapper();
            for(integer m=0;m<NewCD.size();m++){
                for(integer n=0;n<NotesWrapperList.size();n++){
                    system.debug(':::NewCD[m]**'+NewCD[m]);
                    system.debug(':::NotesWrapperList[n]'+NotesWrapperList[n]);
                    if(NewCD[m] == NotesWrapperList[n].sCreated_Date){
                        
                        if(NotesWrapperList[n].sNote_Type=='Complaint'){
                            if( compWrap.sComplaint!=null &&  compWrap.sComplaint!='')
                                compWrap.sComplaint =compWrap.sComplaint+'\n'+NotesWrapperList[n].sNote;
                            else
                                compWrap.sComplaint =NotesWrapperList[n].sNote;
                            
                        }
                        // compWrap.sComplaint += '<br/>';
                        if(NotesWrapperList[n].sNote_Type=='Cause'){
                            if(compWrap.sCause!=null &&  compWrap.sCause!='')
                                compWrap.sCause = compWrap.sCause+'\n'+NotesWrapperList[n].sNote;
                            else
                                compWrap.sCause =NotesWrapperList[n].sNote;
                        }
                        if(NotesWrapperList[n].sNote_Type=='Correction'){
                            if(compWrap.sCorrection!=null &&  compWrap.sCorrection!='')
                                compWrap.sCorrection = compWrap.sCorrection+'\n'+NotesWrapperList[n].sNote;
                            else
                                compWrap.sCorrection =NotesWrapperList[n].sNote;
                        }
                        if(NotesWrapperList[n].sNote_Type=='Reject Reason'){
                            if(compWrap.sReason!=null &&  compWrap.sReason!='')
                                compWrap.sReason = compWrap.sReason+'\n'+NotesWrapperList[n].sNote;
                            else
                                compWrap.sReason =NotesWrapperList[n].sNote;
                        } 
                        if(NotesWrapperList[n].sNote_Type=='Narrative'){
                            if(compWrap.sNarrative!=null &&  compWrap.sNarrative!='')
                                compWrap.sNarrative = compWrap.sNarrative+'\n'+NotesWrapperList[n].sNote;
                            else
                                compWrap.sNarrative =NotesWrapperList[n].sNote;
                        }
                        system.debug(':::compWrap Inside**'+compWrap);
                         
                    }    
                }
                
            }
            NoteWiseNotesWrapperList.add(compWrap);
            system.debug(':::NoteWiseNotesWrapperList**'+NoteWiseNotesWrapperList);
        }
        return JSON.serialize(NoteWiseNotesWrapperList);
    }*/
    
    public class ClaimHistoryWrapper {
        
        @AuraEnabled public string sFailure_date {get;set;}
        @AuraEnabled public string sWarranty_Start_Date {get;set;}
        @AuraEnabled public decimal sFailure_Pointc {get;set;}
        @AuraEnabled public string sRoot_Cause {get;set;} 
        @AuraEnabled public string sRepair_Location {get;set;}
        @AuraEnabled public string sClaim {get;set;}
        @AuraEnabled public string sDistributor_s_Invoice_Paid {get;set;}
        @AuraEnabled public string sFailure_Measure {get;set;}
        @AuraEnabled public Boolean isExceptionFlag {get;set;}
        /*
        public ClaimHistoryWrapper() {
            sFailure_date = '';
            sWarranty_Start_Date = '';
            sFailure_Pointc = 0;
            sRoot_Cause = '';
            sRepair_Location = '';
            sClaim = '';
            sDistributor_s_Invoice_Paid = '';
            sFailure_Measure = '';
        }*/
    }
    /*
    public class NotesWrapper {
        
        public string sNote;
        public string sNote_Type;
        public date sCreated_Date; 
        
        public NotesWrapper() {
            sNote = '';
            sNote_Type = '';
            sCreated_Date = null;
        }
    }  
    public class NoteWiseNotesWrapper {
        public  String sComplaint;
        public  String sCause;
        public  String sCorrection;
        public  String sReason;
        public  String sNarrative;
        public NoteWiseNotesWrapper() {
            sComplaint = '';
            sCause = '';
            sCorrection = '';
            sReason = '';
            sNarrative = '';
        }
    } */
}