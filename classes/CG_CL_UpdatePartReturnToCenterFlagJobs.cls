/**********************************************************************
    Name:CG_CL_UpdatePartReturnToCenterFlagJobs
    Copyright Â© 2018  Cummins
    ======================================================
    ======================================================
    Purpose:                                                            
    -------  
    To update Part Return To Center Flag based on Retrn To Factory and Return To Waiver
    ======================================================
    ======================================================
    History                                                            
    -------                                                            
    VERSION       AUTHOR             DATE                DETAIL                                 
    1.0      Krishnamoorthi      09/05/2018      INITIAL DEVELOPMENT                    
    ***********************************************************************/
public class CG_CL_UpdatePartReturnToCenterFlagJobs{
    public CG_CL_UpdatePartReturnToCenterFlagJobs(){

    }

    //Invocable method to update Parts Return Center flag in Jobs
    //Invocable method to insert an Admin Diag SRT for EPR Y 
    @InvocableMethod(label='insertAdminSRTforJobs' description='update PRC at Service jobs level and Insert Admin SRT 00-10S-00 for Return to factory parts') 
    public static void CreateAdminSRTforJobs(List<String> retToFactory_retWaiver_jobId){
        List<String> inputParam = retToFactory_retWaiver_jobId[0].split(';;');
        String ReturnToFactory;
        String ReturnWaiver;
        String JobID;
        String selectedPart;
        if(inputParam.size() > 0)
            ReturnToFactory = inputParam[0].trim();
        if(inputParam.size() > 1)
            ReturnWaiver = inputParam[1].trim();
        if(inputParam.size() > 2)
            JobID = inputParam[2].trim();
        if(inputParam.size() > 3)
            selectedPart = inputParam[3].trim();
        system.debug('RReturnToFactory '+ReturnToFactory);
        system.debug('ReturnWaiver '+ReturnWaiver);
        system.debug('JobID '+JobID);
        system.debug('selectedPart '+selectedPart);
        List<CSS_Parts_Options__c> lstParts = new List<CSS_Parts_Options__c>();
        List<CSS_Solution_Component__c> solComps = new List<CSS_Solution_Component__c>();
        CSS_SRT__c existingAdmSRT = new CSS_SRT__c();

        if(ReturnToFactory == 'Y' && selectedPart == 'TRUE'){ 
            try{
                existingAdmSRT = [SELECT Id FROM CSS_SRT__c WHERE SRT_ID__c = '00-10S-00' AND Type__c = 'Admin' AND Job_Order__c =: JobID and CSS_Claims__c =: null limit 1]; //Add Claim Id in filter
                system.debug('inside 1st try-->');
            } catch(exception ex){
                lstParts = [Select Id, Fail_Code__c, Account_Code__c, FailurepartId__r.Name, Get_Fail_Code_Formula__c, FailurepartId__r.Service_Job__c, FailurepartId__r.Type__c, FailurepartId__r.CoveredLaborHrs__c, FailurepartId__r.CampaignLaborPercentage__c from CSS_Parts_Options__c where Service_Job__c =: JobID and ReturnToFactory__c = 'Y' and selected_part__c = true ORDER BY CreatedDate DESC];
                String temp;
                if(lstParts != null && lstParts[0].FailurepartId__r.Type__c != null && lstParts[0].FailurepartId__r.Type__c != ''){
                    temp = lstParts[0].Fail_Code__c;
                }
                else{
                    temp = (lstParts[0].Fail_Code__c != null && lstParts[0].Fail_Code__c != '') ? lstParts[0].Fail_Code__c : lstParts[0].Get_Fail_Code_Formula__c;
                }
                solComps = [Select Id, Type__c, CampaignLaborPercentage__c, CSS_Failure_Sequence_Number__c, CSS_Account_Formula__c, FailCode_Formula__c, CoveredLaborHrs__c FROM CSS_Solution_Component__c WHERE Service_Job__c =: JobID AND CSS_Account_Formula__c =: lstParts[0].Account_Code__c AND FailCode_Formula__c =: temp ORDER BY CSS_Failure_Sequence_Number__c LIMIT 1];
                system.debug('inside 1st exception-->'+solComps);
                if(solComps != null && solComps.size() > 0) {
                    system.debug('inside if-->'+solComps.size());
                    if(solComps[0].Type__c != null && solComps[0].Type__c != ''){
                        system.debug('inside if-->'+solComps[0].Type__c);
                        if(solComps[0].CampaignLaborPercentage__c != null && solComps[0].CampaignLaborPercentage__c != '' && double.valueof(solComps[0].CampaignLaborPercentage__c) > 0){
                            callAdminSRT(JobID, 'Admin', temp, lstParts[0].Account_Code__c, solComps[0].Type__c, solComps[0].Id);
                        }
                    }
                    else{
                        system.debug('inside else-->'+solComps[0].CoveredLaborHrs__c);
                        if(solComps[0].CoveredLaborHrs__c != null && solComps[0].CoveredLaborHrs__c != '' && double.valueof(solComps[0].CoveredLaborHrs__c) > 0){
                            system.debug('inside if-->');
                            callAdminSRT(JobID, 'Admin', temp, lstParts[0].Account_Code__c, solComps[0].Type__c, solComps[0].Id);
                        }
                    }
                }
            }
        } 
        else {
            try{
                lstParts = [Select Id, Account_Code__c, Fail_Code__c, Get_Fail_Code_Formula__c, FailurepartId__r.Name, FailurepartId__r.Service_Job__c, FailurepartId__r.Type__c, FailurepartId__r.CoveredLaborHrs__c, FailurepartId__r.CampaignLaborPercentage__c from CSS_Parts_Options__c where Service_Job__c =: JobID and ReturnToFactory__c = 'Y' and selected_part__c = true];
                system.debug('inside else 1st try'+lstParts);
                String temp;
                if(lstParts != null && lstParts[0].FailurepartId__r.Type__c != null && lstParts[0].FailurepartId__r.Type__c != ''){
                    temp = lstParts[0].Fail_Code__c;
                }
                else{
                    temp = (lstParts[0].Fail_Code__c != null && lstParts[0].Fail_Code__c != '') ? lstParts[0].Fail_Code__c : lstParts[0].Get_Fail_Code_Formula__c;
                }
                solComps = [Select Id, CSS_Failure_Sequence_Number__c, Type__c, CSS_Account_Formula__c, FailCode_Formula__c, CoveredLaborHrs__c FROM CSS_Solution_Component__c WHERE Service_Job__c =: JobID AND CSS_Account_Formula__c =: lstParts[0].Account_Code__c AND FailCode_Formula__c =: temp ORDER BY CSS_Failure_Sequence_Number__c LIMIT 1];
                if(lstParts != null && lstParts.size() > 0){
                    try{
                        existingAdmSRT = [SELECT Id FROM CSS_SRT__c WHERE SRT_ID__c = '00-10S-00' AND Type__c = 'Admin' AND Job_Order__c =: JobID and CSS_Claims__c =: null limit 1]; //Add Claim Id in filter
                    } 
                    catch(exception ex){
                        lstParts = [Select Id, Fail_Code__c, Account_Code__c from CSS_Parts_Options__c where Service_Job__c =: JobID and ReturnToFactory__c = 'Y' and selected_part__c = true ORDER BY CreatedDate DESC];
                        if(solComps[0].Type__c != null){
                            if(solComps[0].CampaignLaborPercentage__c != null && solComps[0].CampaignLaborPercentage__c != '' && double.valueof(solComps[0].CampaignLaborPercentage__c) > 0){
                                callAdminSRT(JobID,'Admin',temp,lstParts[0].Account_Code__c, solComps[0].Type__c, solComps[0].Id); 
                            }
                        }
                        else{
                            if(solComps[0].CoveredLaborHrs__c != null && solComps[0].CoveredLaborHrs__c != '' && double.valueof(solComps[0].CoveredLaborHrs__c) > 0){
                                callAdminSRT(JobID,'Admin',temp,lstParts[0].Account_Code__c, solComps[0].Type__c, solComps[0].Id); 
                            }
                        }
                    }
                } 
                else {
                    system.debug('inside N N exception');
                    try{
                        existingAdmSRT = [SELECT Id FROM CSS_SRT__c WHERE SRT_ID__c = '00-10S-00' AND Type__c = 'Admin' AND Job_Order__c =: JobID and CSS_Claims__c =: null limit 1];
                        delete existingAdmSRT;
                    } 
                    catch(exception err){
                    }
                }
            } 
            catch(exception error){
                system.debug('inside N N exception');
                try{
                    existingAdmSRT = [SELECT Id FROM CSS_SRT__c WHERE SRT_ID__c = '00-10S-00' AND Type__c = 'Admin' AND Job_Order__c =: JobID and CSS_Claims__c =: null limit 1];
                    delete existingAdmSRT;
                } 
                catch(exception err){
                }
            }
        }
    }

    //Method to make SRT callout to bring the admin SRT 00-10S-00
    @future(callout=true)
    public static void callAdminSRT(String JobID, String srtType, String failCode, String accountCode, String compType, Id solCompId){
        system.debug('inside callAdminSRT method');
        system.debug('Id-->'+solCompId);
        List<CSS_SRT__c> lstSRT = new List<CSS_SRT__c>();
        List<CSS_SRT__c> srtOrderLst = new List<CSS_SRT__c>();
        srtOrderLst = [SELECT Id FROM CSS_SRT__c WHERE Job_Order__c =: JobID and CSS_Claims__c =: null AND (SRT_Category__c = 'AdditionalDiag' OR (Type__c = 'Diagnosis' OR Type__c = 'Diag Access'))]; 
        CSS_SRT__c admSRT = new CSS_SRT__c();
        lstSRT = CSS_WS_SRT.getAllDigRepSRTs(JobID,'Admin');
        String failCodeSplit;
        if(failCode != null && failCode != '' && failCode.contains('-')){
            List<String> lstTempStr = failCode.split('-');            
            if(lstTempStr.size() > 1)
                failCodeSplit = lstTempStr[1].trim();
            else
                failCodeSplit = lstTempStr[0].trim();
        }
        else
            failCodeSplit = failCode;
        if(lstSRT != null && lstSRT.size() != 0){
            for(integer i=0;i<lstSRT.size();i++){
                if(lstSRT[i].SRT_ID__c == '00-10S-00'){
                    /*if(admSRT.step_id__c == null || admSRT.step_id__c  == ''){
                       If(admSRT.srt_id__c == '00-10S-00') {
                       admSRT.step_id__c = '151787';
                        }
                        }*/
                    admSRT.SRT_ID__c = lstSRT[i].SRT_ID__c;
                    admSRT.isPerformed__c = true;
                    admSRT.SRT_Quantity__c = 1;
                    admSRT.SRT_Title__c = lstSRT[i].SRT_Title__c;
                    admSRT.SRT_Warrantable__c = '100';                
                    admSRT.SRT_Time__c = lstSRT[i].SRT_Time__c;
                    admSRT.step_id__c = lstSRT[i].step_id__c;//existing stepid
                    
                    if(compType != null && compType != ''){
                        admSRT.SRT_Category__c = compType;
                        admSRT.Component_Id__c = solCompId;
                    }else{
                        
                        admSRT.SRT_Category__c = 'AdditionalDiag';
                    }
                    admSRT.Type__c = 'Admin';
                    admSRT.SRT_Type__c = 'Admin';
                    admSRT.Job_Order__c = JobID;
                    admSRT.FailCode__c = failCodeSplit;
                    admSRT.Account_Code__c = accountCode;
                    admSRT.Access_Code_A__c = lstSRT[i].Access_Code_A__c;
                    admSRT.Access_Code_B__c = lstSRT[i].Access_Code_B__c;
                    admSRT.Access_Code_C__c = lstSRT[i].Access_Code_C__c;
                    admSRT.Access_Code_D__c = lstSRT[i].Access_Code_D__c;
                    admSRT.Access_Code_R__c = lstSRT[i].Access_Code_R__c;
                    //Story:-172627
                    if(!string.isBlank(lstSRT[i].SRT_Access_Code__c))
                        admSRT.SRT_Access_Code__c=lstSRT[i].SRT_Access_Code__c;
                    if(!string.isBlank(lstSRT[i].Access_Code__c))
                        admSRT.Access_Code__c=lstSRT[i].Access_Code__c;
                    //End
                    if(srtOrderLst != null)
                        admSRT.SRT_Order__c = srtOrderLst.size()+1;
                    else
                        admSRT.SRT_Order__c = 1;
                    break;
                }
            }
            if(admSRT != null){
                 if(admSRT.step_id__c == null || admSRT.step_id__c  == ''){
                       If(admSRT.srt_id__c == '00-10S-00') {
                       admSRT.step_id__c = '151787';
                        }
                        }
            
                insert admSRT;
            }
        }
        
    }
}