/**********************************************************************
    Name:CG_CL_UpdatePartReturnToCenterFlag
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
    1.0      Rajkumar/Vignesh      09/05/2018      INITIAL DEVELOPMENT                    
    ***********************************************************************/
public class CG_CL_UpdatePartReturnToCenterFlag { 

    public CG_CL_UpdatePartReturnToCenterFlag()
    {

    }

    //Invocable method to update Parts Return Center flag in Claim and Submission level
    //Invocable method to insert an Admin Diag SRT for EPR Y and Return Waiver N part
    @InvocableMethod(label='updatePRC_insertAdminSRT' description='update PRC at Claim level and Insert Admin SRT 00-10S-00 for Return to factory parts') 
    public static void updatePRCFlag(List<String> retToFactory_retWaiver_claimId){
        List<String> inputParam = retToFactory_retWaiver_claimId[0].split(';;');
        String ReturnToFactory;
        String ReturnWaiver;
        String claimID;
        String selectedPart;
        if(inputParam.size() > 0)
            ReturnToFactory = inputParam[0].trim();
        if(inputParam.size() > 1)
            ReturnWaiver = inputParam[1].trim();
        if(inputParam.size() > 2)
            claimID = inputParam[2].trim();
        if(inputParam.size() > 3)
            selectedPart = inputParam[3].trim();
        system.debug('RReturnToFactory'+ReturnToFactory);
        system.debug('ReturnWaiver'+ReturnWaiver);
        system.debug('claimID'+claimID);
        system.debug('selectedPart'+selectedPart);
        CSS_Claims__c claims = new CSS_Claims__c();
        List<CSS_Claim_Submission__c> claimsSub = new List<CSS_Claim_Submission__c>();
        List<CSS_Parts_Options__c> lstParts = new List<CSS_Parts_Options__c>();
        List<CSS_Solution_Component__c> solComps = new List<CSS_Solution_Component__c>();
        //List<CSS_SRT__c> existingAdmSRT = new List<CSS_SRT__c>();
        CSS_SRT__c existingAdmSRT = new CSS_SRT__c();//Commented above and added this code for the defect#185136
        claims.Id = claimID;
        if(ReturnToFactory == 'Y' && ReturnWaiver == 'FALSE' && selectedPart == 'TRUE'){
            claims.PartReturnToCenter__c = 'Y';
            claimsSub = setPRCtoClaimSubmissions(claimID,'Y');
            try{
                existingAdmSRT = [SELECT Id FROM CSS_SRT__c WHERE SRT_ID__c = '00-10S-00' AND Type__c = 'Admin' AND CSS_Claims__c =: claimID limit 1]; //Add Claim Id in filter
                system.debug('inside 1st try-->');
            }
            catch(exception ex){
                lstParts = [Select Id, Fail_Code__c, Account_Code__c, FailurepartId__r.Name, Get_Fail_Code_Formula__c, FailurepartId__r.Service_Job__c, FailurepartId__r.Type__c, FailurepartId__r.CoveredLaborHrs__c, FailurepartId__r.CampaignLaborPercentage__c, CSS_Claims__r.SP_INSHOP_LABOR_RATE__c from CSS_Parts_Options__c where CSS_Claims__c =: claimID and ReturnToFactory__c = 'Y' and ReturnWaiver__c = false and selected_part__c = true and FailurepartId__r.Service_Job__c = null ORDER BY CreatedDate DESC];
                String temp;
                if(lstParts != null && lstParts[0].FailurepartId__r.Type__c != null && lstParts[0].FailurepartId__r.Type__c != ''){
                    temp = lstParts[0].FailurepartId__r.Name+'-'+lstParts[0].Fail_Code__c;
                }
                else{
                    temp = (lstParts[0].Fail_Code__c != null && lstParts[0].Fail_Code__c != '') ? lstParts[0].Fail_Code__c : lstParts[0].Get_Fail_Code_Formula__c;
                }
                
                system.debug('lstParts---'+lstParts);
                system.debug('lstParts[0].Account_Code__c--'+lstParts[0].Account_Code__c);
                system.debug('temp-->'+temp);
                
                solComps = [Select Id, Type__c, CampaignLaborPercentage__c, CSS_Failure_Sequence_Number__c, CSS_Account_Formula__c, FailCode_Formula__c, CoveredLaborHrs__c FROM CSS_Solution_Component__c WHERE CSS_Claims__c =: claimID and CSS_Account_Formula__c =: lstParts[0].Account_Code__c AND FailCode_Formula__c =: temp ORDER BY CSS_Failure_Sequence_Number__c desc LIMIT 1];
                //system.debug('inside 1st exception-->'+solComps[0].Type__c+'Camp--'+solComps[0].CampaignLaborPercentage__c );
                if(solComps != null && solComps.size() > 0) {
                    system.debug('Inside IF'+solComps);
                    if(solComps[0].Type__c != null && solComps[0].CampaignLaborPercentage__c != null && solComps[0].CampaignLaborPercentage__c != '' && double.valueof(solComps[0].CampaignLaborPercentage__c) > 0){
                        system.debug('Inside Field Actions');
                        callAdminSRT(claimID, 'Admin', temp, lstParts[0].Account_Code__c, solComps[0].Type__c, lstParts[0].CSS_Claims__r.SP_INSHOP_LABOR_RATE__c);
                    } else {
                        if(solComps[0].CoveredLaborHrs__c != null && solComps[0].CoveredLaborHrs__c != '' && double.valueof(solComps[0].CoveredLaborHrs__c) > 0){    
                            system.debug('Inside Failures');
                            callAdminSRT(claimID, 'Admin', temp, lstParts[0].Account_Code__c, solComps[0].Type__c, lstParts[0].CSS_Claims__r.SP_INSHOP_LABOR_RATE__c);
                        }
                    }
                }
                /*
                if(solComps.size() > 0 && solComps[0].Type__c != null){
                    if(solComps[0].CampaignLaborPercentage__c != null && solComps[0].CampaignLaborPercentage__c != '' && double.valueof(solComps[0].CampaignLaborPercentage__c) > 0){
                        callAdminSRT(claimID, 'Admin', lstParts[0].Fail_Code__c, lstParts[0].Account_Code__c, solComps[0].Type__c, lstParts[0].CSS_Claims__r.SP_INSHOP_LABOR_RATE__c);
                    }
                }
                else{
                    if(solComps[0].CoveredLaborHrs__c != null && solComps[0].CoveredLaborHrs__c != '' && double.valueof(solComps[0].CoveredLaborHrs__c) > 0){    
                        callAdminSRT(claimID, 'Admin', lstParts[0].Fail_Code__c, lstParts[0].Account_Code__c, solComps[0].Type__c, lstParts[0].CSS_Claims__r.SP_INSHOP_LABOR_RATE__c);
                    }
                }
                */
            }
        }
        else{
            try{
                lstParts = [Select Id, Account_Code__c, Fail_Code__c, FailurepartId__r.Name, Get_Fail_Code_Formula__c, FailurepartId__r.Service_Job__c, FailurepartId__r.Type__c, FailurepartId__r.CoveredLaborHrs__c, FailurepartId__r.CampaignLaborPercentage__c, CSS_Claims__r.SP_INSHOP_LABOR_RATE__c from CSS_Parts_Options__c where CSS_Claims__c =: claimID and ReturnToFactory__c = 'Y' and ReturnWaiver__c = false and selected_part__c = true and FailurepartId__r.Service_Job__c = null];
                system.debug('***lstParts Value***'+lstParts);
                String temp;
                if(lstParts != null && lstParts[0].FailurepartId__r.Type__c != null && lstParts[0].FailurepartId__r.Type__c != ''){
                    temp = lstParts[0].FailurepartId__r.Name+'-'+lstParts[0].Fail_Code__c;
                }
                else{
                    temp = (lstParts[0].Fail_Code__c != null && lstParts[0].Fail_Code__c != '') ? lstParts[0].Fail_Code__c : lstParts[0].Get_Fail_Code_Formula__c;
                }
                solComps = [Select Id, CSS_Failure_Sequence_Number__c, CSS_Account_Formula__c, FailCode_Formula__c, CoveredLaborHrs__c FROM CSS_Solution_Component__c WHERE CSS_Claims__c =: claimID and CSS_Account_Formula__c =: lstParts[0].Account_Code__c AND FailCode_Formula__c =: temp ORDER BY CSS_Failure_Sequence_Number__c LIMIT 1];
                system.debug('inside else 1st try'+lstParts);
                if(lstParts != null && lstParts.size() > 0){
                    claims.PartReturnToCenter__c = 'Y';
                    claimsSub = setPRCtoClaimSubmissions(claimID,'Y');
                    try{
                        existingAdmSRT = [SELECT Id FROM CSS_SRT__c WHERE SRT_ID__c = '00-10S-00' AND Type__c = 'Admin' AND CSS_Claims__c =: claimID limit 1]; //Add Claim Id in filter
                        if(existingAdmSRT != null)
                            delete existingAdmSRT;
                        lstParts = [Select Id, Fail_Code__c, FailurepartId__r.Name, Get_Fail_Code_Formula__c, Account_Code__c, FailurepartId__r.Service_Job__c, FailurepartId__r.Type__c, FailurepartId__r.CoveredLaborHrs__c, FailurepartId__r.CampaignLaborPercentage__c, CSS_Claims__r.SP_INSHOP_LABOR_RATE__c from CSS_Parts_Options__c where CSS_Claims__c =: claimID and ReturnToFactory__c = 'Y' and ReturnWaiver__c = false and selected_part__c = true and FailurepartId__r.Service_Job__c = null ORDER BY CreatedDate DESC];
                        String temp1;
                        if(lstParts != null && lstParts[0].FailurepartId__r.Type__c != null && lstParts[0].FailurepartId__r.Type__c != ''){
                            temp1 = lstParts[0].FailurepartId__r.Name+'-'+lstParts[0].Fail_Code__c;
                        }
                        else{
                            temp1 = (lstParts[0].Fail_Code__c != null && lstParts[0].Fail_Code__c != '') ? lstParts[0].Fail_Code__c : lstParts[0].Get_Fail_Code_Formula__c;
                        }
                        solComps = [Select Id, Type__c, CampaignLaborPercentage__c, CSS_Failure_Sequence_Number__c, CSS_Account_Formula__c, FailCode_Formula__c, CoveredLaborHrs__c FROM CSS_Solution_Component__c WHERE CSS_Claims__c =: claimID and CSS_Account_Formula__c =: lstParts[0].Account_Code__c AND FailCode_Formula__c =: temp1 ORDER BY CSS_Failure_Sequence_Number__c LIMIT 1];
                        if(solComps.size() > 0 && solComps[0].Type__c != null){
                            if(solComps[0].CampaignLaborPercentage__c != null && solComps[0].CampaignLaborPercentage__c != '' && double.valueof(solComps[0].CampaignLaborPercentage__c) > 0){
                                callAdminSRT(claimID, 'Admin', temp1, lstParts[0].Account_Code__c, solComps[0].Type__c, lstParts[0].CSS_Claims__r.SP_INSHOP_LABOR_RATE__c);
                            }
                        }
                        else{
                            if(solComps[0].CoveredLaborHrs__c != null && solComps[0].CoveredLaborHrs__c != '' && double.valueof(solComps[0].CoveredLaborHrs__c) > 0){
                                callAdminSRT(claimID, 'Admin', temp1, lstParts[0].Account_Code__c, solComps[0].Type__c, lstParts[0].CSS_Claims__r.SP_INSHOP_LABOR_RATE__c);
                            }
                        }

                    }
                    catch(exception ex){
                        lstParts = [Select Id, Fail_Code__c, FailurepartId__r.Name, Get_Fail_Code_Formula__c, Account_Code__c, FailurepartId__r.Service_Job__c, FailurepartId__r.Type__c, FailurepartId__r.CoveredLaborHrs__c, FailurepartId__r.CampaignLaborPercentage__c, CSS_Claims__r.SP_INSHOP_LABOR_RATE__c from CSS_Parts_Options__c where CSS_Claims__c =: claimID and ReturnToFactory__c = 'Y' and ReturnWaiver__c = false and selected_part__c = true and FailurepartId__r.Service_Job__c = null ORDER BY CreatedDate DESC];
                        String temp1;
                        if(lstParts != null && lstParts[0].FailurepartId__r.Type__c != null && lstParts[0].FailurepartId__r.Type__c != ''){
                            temp1 = lstParts[0].FailurepartId__r.Name+'-'+lstParts[0].Fail_Code__c;
                        }
                        else{
                            temp1 = (lstParts[0].Fail_Code__c != null && lstParts[0].Fail_Code__c != '') ? lstParts[0].Fail_Code__c : lstParts[0].Get_Fail_Code_Formula__c;
                        }
                        solComps = [Select Id, Type__c, CampaignLaborPercentage__c, CSS_Failure_Sequence_Number__c, CSS_Account_Formula__c, FailCode_Formula__c, CoveredLaborHrs__c FROM CSS_Solution_Component__c WHERE CSS_Claims__c =: claimID and CSS_Account_Formula__c =: lstParts[0].Account_Code__c AND FailCode_Formula__c =: temp1 ORDER BY CSS_Failure_Sequence_Number__c LIMIT 1];
                        if(solComps.size() > 0 && solComps[0].Type__c != null){
                            if(solComps[0].CampaignLaborPercentage__c != null && solComps[0].CampaignLaborPercentage__c != '' && double.valueof(solComps[0].CampaignLaborPercentage__c) > 0){
                                callAdminSRT(claimID, 'Admin', temp1, lstParts[0].Account_Code__c, solComps[0].Type__c, lstParts[0].CSS_Claims__r.SP_INSHOP_LABOR_RATE__c);
                            }
                        }
                        else{
                            if(solComps[0].CoveredLaborHrs__c != null && solComps[0].CoveredLaborHrs__c != '' && double.valueof(solComps[0].CoveredLaborHrs__c) > 0){
                                callAdminSRT(claimID, 'Admin', temp1, lstParts[0].Account_Code__c, solComps[0].Type__c, lstParts[0].CSS_Claims__r.SP_INSHOP_LABOR_RATE__c);
                            }
                        }
                    }
                }
                else{
                    system.debug('inside N N exception');
                    claims.PartReturnToCenter__c = 'N';
                    claimsSub = setPRCtoClaimSubmissions(claimID,'N');
                    try{
                        existingAdmSRT = [SELECT Id FROM CSS_SRT__c WHERE SRT_ID__c = '00-10S-00' AND Type__c = 'Admin' AND CSS_Claims__c =: claimID  limit 1];
                        if(existingAdmSRT != null)
                            delete existingAdmSRT;
                    }
                    catch(exception err){
                        system.debug('Inside Delete--'+err.getMessage()+err.getlinenumber());
                    }
                }
            }
            catch(exception error){
                system.debug('inside N N exception');
                claims.PartReturnToCenter__c = 'N';
                claimsSub = setPRCtoClaimSubmissions(claimID,'N');
                try{
                    existingAdmSRT = [SELECT Id FROM CSS_SRT__c WHERE SRT_ID__c = '00-10S-00' AND Type__c = 'Admin' AND CSS_Claims__c =: claimID  limit 1];
                    delete existingAdmSRT;
                }
                catch(exception err){
                    system.debug('Inside Delete2--'+err.getMessage()+err.getlinenumber());
                }
            }
        }
        update claims;
        if(claimsSub != null && claimsSub.size() > 0)
            update claimsSub;
    }
    //Method to make SRT callout to bring the admin SRT 00-10S-00
    @future(callout=true)
    public static void callAdminSRT(String claimid, String srtType, String failCode, String accountCode, String compType, String inShopLaborRate){
        system.debug('inside callAdminSRT');
        system.debug('failCode'+failCode);
        system.debug('accountCode'+accountCode);
        system.debug('compType'+compType);
        List<CSS_SRT__c> lstSRT = new List<CSS_SRT__c>();
        List<CSS_SRT__c> srtOrderLst = new List<CSS_SRT__c>();
        srtOrderLst = [SELECT Id, CSS_Claims__r.SP_INSHOP_LABOR_RATE__c FROM CSS_SRT__c WHERE CSS_Claims__c =: claimid AND (SRT_Category__c = 'AdditionalDiag' OR (Type__c = 'Diagnosis' OR Type__c = 'Diag Access'))]; 
        CSS_SRT__c admSRT = new CSS_SRT__c();

        lstSRT = CSS_WS_SRT.getAllClaimsDigRepSRTs(claimID,'Admin');
        system.debug('lstSRT'+lstSRT);
        String failCodeSplit;
        if(failCode != null && failCode != ''){
            List<String> lstTempStr = failCode.split('-');            
            if(lstTempStr.size() > 1)
                failCodeSplit = lstTempStr[lstTempStr.size()-1].trim(); //defect fix GSSC-271
                //failCodeSplit = lstTempStr[1].trim();
            else
                failCodeSplit = lstTempStr[0].trim();
        }
        else
            failCodeSplit = '';
        if(lstSRT != null && lstSRT.size() != 0){
            for(integer i=0;i<lstSRT.size();i++){
                system.debug('SRT_ID__c '+lstSRT[i].SRT_ID__c);                
                if(lstSRT[i].SRT_ID__c == '00-10S-00'){
                    system.debug('SRT_ID__c '+lstSRT[i].SRT_ID__c);                        
                    admSRT.SRT_ID__c = lstSRT[i].SRT_ID__c;
                    admSRT.isPerformed__c = true;
                    admSRT.SRT_Quantity__c = 1;
                    admSRT.SRT_Title__c = lstSRT[i].SRT_Title__c;
                    admSRT.SRT_Warrantable__c = '100';                
                    admSRT.SRT_Time__c = lstSRT[i].SRT_Time__c;
                    admSRT.step_id__c = lstSRT[i].step_id__c; //existing stepid

                    if(compType != null && compType != ''){
                        admSRT.FailCode__c = failCode;
                        admSRT.Type__c = 'Admin';
                        admSRT.SRT_Type__c = 'Admin';
                        admSRT.SRT_Category__c = compType;
                        admSRT.CSS_Claims__c = claimID;
                        if(inShopLaborRate != null && inShopLaborRate != '' && decimal.valueof(inShopLaborRate) > 0){
                            admSRT.Account_Code__c = accountCode;
                        }

                    }else{
                        admSRT.FailCode__c = failCodeSplit;
                        admSRT.Type__c = 'Admin';
                        admSRT.SRT_Type__c = 'Admin';
                        admSRT.SRT_Category__c = 'AdditionalDiag';
                        admSRT.CSS_Claims__c = claimID;
                        if(inShopLaborRate != null && inShopLaborRate != '' && decimal.valueof(inShopLaborRate) > 0){
                            admSRT.Account_Code__c = accountCode;
                        }
                    }

                    admSRT.Access_Code_A__c = lstSRT[i].Access_Code_A__c;
                    admSRT.Access_Code_B__c = lstSRT[i].Access_Code_B__c;
                    admSRT.Access_Code_C__c = lstSRT[i].Access_Code_C__c;
                    admSRT.Access_Code_D__c = lstSRT[i].Access_Code_D__c;
                    admSRT.Access_Code_R__c = lstSRT[i].Access_Code_R__c;
                    //Story:- 172627
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
                    if(admSRT.srt_id__c == '00-10S-00') {
                        admSRT.step_id__c = '151787';
                    }
                }             
                insert admSRT;
            }
            system.debug('admSRT-->'+admSRT);
        }
    }
    //Method to set PartReturnToCenter for Claim Submission records
    public static List<CSS_Claim_Submission__c> setPRCtoClaimSubmissions(Id cId, String returnToWaiver){
        List<CSS_Claim_Submission__c> lstReturn = new List<CSS_Claim_Submission__c>();
        /*
        List<CSS_Claim_Submission__c> lstCS = [SELECT Id, PartReturnToCenter__c FROM CSS_Claim_Submission__c WHERE CSS_Claims__c =: cId];
        if(lstCS != null && lstCS.size() > 0){
            for(CSS_Claim_Submission__c lstClSub : lstCS){
                CSS_Claim_Submission__c cSub = new CSS_Claim_Submission__c();
                cSub.Id = lstClSub.Id;
                cSub.PartReturnToCenter__c = returnToWaiver;
                lstReturn.add(cSub);
            }
        }   
        */
        return lstReturn;
    }
}