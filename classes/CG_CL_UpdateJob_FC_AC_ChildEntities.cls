/**********************************************************************
Name:CG_CL_UpdateJob_FC_AC_ChildEntities
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this invocable method to update child items failcode accountcode upon failure edit
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR            DATE                DETAIL  
1.0 -   Rajkumar/Vignesh    5/13/2019      Added code as part of user stories 183428, 184816 
2.0 -   Rajkumar/Vignesh    7/04/2019      Added code as part of the defect 189148 to update field action parts failcode, accountcode
***********************************************************************/
public class CG_CL_UpdateJob_FC_AC_ChildEntities {
    public void updateFailCodeAccCode(String oldFailCode, String oldAccCode, String newFailCode, String newAccCode, CSS_Solution_Component__c thisSolCompPopUp, Id jobId, String covType){
        system.debug('oldFailCode-->'+oldFailCode);
        system.debug('oldAccCode-->'+oldAccCode);
        system.debug('newFailCode-->'+newFailCode);
        system.debug('newAccCode-->'+newAccCode);
        system.debug('thisSolCompPopUp-->'+thisSolCompPopUp);
        system.debug('jobId-->'+jobId);
        List<CSS_Solution_Component__c> solCompLst = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompPopupRec = new CSS_Solution_Component__c();
        Map<String, List<CSS_Solution_Component__c>> failCodeMap = new Map<String, List<CSS_Solution_Component__c>>();
        Map<String, List<CSS_Solution_Component__c>> accCodeMap = new Map<String, List<CSS_Solution_Component__c>>();
        Boolean singleFailCode;
        Boolean singleAccCode;
        List<CSS_Parts_Options__c> partsLst = new List<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> gsqParts = new List<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> nonGSQParts = new List<CSS_Parts_Options__c>();
        List<CSS_SRT__c> srtsLst = new List<CSS_SRT__c>();
        List<CSS_SRT__c> gsqRepSRTs = new List<CSS_SRT__c>();
        List<CSS_SRT__c> nonGsqSRTs = new List<CSS_SRT__c>();
        Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        List<CSS_Parts_Options__c> delGSQPart = new List<CSS_Parts_Options__c>();
        List<CSS_SRT__c> delGSQSRT = new List<CSS_SRT__c>();
        List<CSS_Parts_Options__c> updatePart = new List<CSS_Parts_Options__c>();
        List<CSS_SRT__c> updateSRT = new List<CSS_SRT__c>();
        
        solCompLst = [SELECT Id, FailCode_Formula__c, Solutions__c, Service_Model__c, Equip_ID__c, Engine_Family_Code__c, Component_Id__c, Service_Job__r.Name, Service_Job__r.Claim_no__c, SysCodeAndCompCode__c, Service_Job__c, CSS_Account_Formula__c,Type__c, CSS_Failure_Sequence_Number__c, CoveredPartsQty__c, CampaignPartsPercentage__c, CoveredOCAmount__c, 
                      CampaignOCPercentage__c, CoveredLaborHrs__c, CampaignLaborPercentage__c, CoveredTravelBaseFareAmt__c, CoveredTravelLabor__c,
                      CoveredTravelMiles__c, CoveredTowingMiles__c, CoveredMealsLodgingAmt__c, CampaignTravelPercentage__c, CampaignTowingPercentage__c FROM CSS_Solution_Component__c 
                      WHERE Service_Job__c =: jobId AND Type__c NOT IN ('Campaign','ATC','TRP') AND Selected_Component__c = true];
                      
        partsLst = [SELECT Id, RecordTypeId, Parts_Type__c, FailurepartId__r.Type__c, Get_Fail_Code_Formula__c, Account_Code__c, Type__c FROM CSS_Parts_Options__c WHERE Service_Job__c =: jobId and (FailurepartId__r.Type__c = null or FailurepartId__r.Type__c = '')];
        
        srtsLst = [SELECT Id, Type__c, SRT_Category__c, FailCode__c, AccountCode_Formula__c, Account_Code__c, Component_Id__r.Type__c FROM CSS_SRT__c WHERE Job_Order__c =: jobId and Type__c != '99Time' and (Component_Id__r.Type__c = null or Component_Id__r.Type__c = '')];
        
        for(CSS_Solution_Component__c sol : solCompLst){
            if(sol.Id == thisSolCompPopUp.Id){
                solCompPopupRec = sol;
            }
            if(!failCodeMap.containsKey(sol.SysCodeAndCompCode__c)){
                List<CSS_Solution_Component__c> tempLst = new List<CSS_Solution_Component__c>();
                tempLst.add(sol);
                failCodeMap.put(sol.SysCodeAndCompCode__c, tempLst);
            }
            else{
                List<CSS_Solution_Component__c> tempLst = new List<CSS_Solution_Component__c>();
                tempLst = failCodeMap.get(sol.SysCodeAndCompCode__c);
                tempLst.add(sol);
                failCodeMap.put(sol.SysCodeAndCompCode__c, tempLst);
            }
            if(!accCodeMap.containsKey(sol.CSS_Account_Formula__c)){
                List<CSS_Solution_Component__c> tempLst = new List<CSS_Solution_Component__c>();
                tempLst.add(sol);
                accCodeMap.put(sol.CSS_Account_Formula__c, tempLst);
            }
            else{
                List<CSS_Solution_Component__c> tempLst = new List<CSS_Solution_Component__c>();
                tempLst = accCodeMap.get(sol.CSS_Account_Formula__c);
                tempLst.add(sol);
                accCodeMap.put(sol.CSS_Account_Formula__c, tempLst);
            }
        }
        system.debug('failCodeMap-->'+failCodeMap);
        system.debug('accCodeMap-->'+accCodeMap);
        if(failCodeMap != null && failCodeMap.get(oldFailCode).size() > 1){
            singleFailCode = false;
        }
        else{
            singleFailCode = true;
        }
        if(accCodeMap != null && accCodeMap.get(oldAccCode).size() > 1){
            singleAccCode = false;
        }
        else{
            singleAccCode = true;
        }
        system.debug('singleFailCode-->'+singleFailCode);
        system.debug('singleAccCode-->'+singleAccCode);
        for(CSS_Parts_Options__c parts : partsLst){
            if(parts.RecordTypeId == recTypeIdPart){
                if(parts.Parts_Type__c != 'Custom' && (parts.FailurepartId__r.Type__c == '' || parts.FailurepartId__r.Type__c == null)){
                    gsqParts.add(parts); //GSQ Parts
                }
                else if(parts.Parts_Type__c == 'Custom'){
                    nonGSQParts.add(parts); //URP - Non GSQ
                }
            }
            else if(parts.RecordTypeId == recTypeIdOC){
                nonGSQParts.add(parts); //OC - Non GSQ
            }
            else if(parts.RecordTypeId == recTypeIdTTML){
                nonGSQParts.add(parts);  //TTML - Non GSQ
            }
        }
        system.debug('gsqParts-->'+gsqParts);
        system.debug('nonGSQParts-->'+nonGSQParts);
        for(CSS_SRT__c srts : srtsLst){
            if((srts.Type__c == 'Diagnosis' && (srts.SRT_Category__c == '' || srts.SRT_Category__c == null)) || srts.SRT_Category__c == 'AdditionalDiag' || srts.Type__c == 'Diag Access'){
                nonGsqSRTs.add(srts);
            }
            else if(srts.Type__c == 'Repair' && (srts.SRT_Category__c == '' || srts.SRT_Category__c == null)){ 
                gsqRepSRTs.add(srts);
            }
            else if(srts.SRT_Category__c == 'AdditionalRep' || srts.Type__c == 'Repair Access'){
                nonGsqSRTs.add(srts);
            }
        }
        system.debug('gsqRepSRTs-->'+gsqRepSRTs);
        system.debug('nonGsqSRTs-->'+nonGsqSRTs);
        
        //scenario 1 and scenario 5
        if((oldFailCode != newFailCode) && (oldAccCode == newAccCode)){
            //Remove GSQs
            for(CSS_Parts_Options__c parts : gsqParts){
                if(parts.Get_Fail_Code_Formula__c != null && parts.Get_Fail_Code_Formula__c != '' && parts.Get_Fail_Code_Formula__c.RIGHT(4) == oldFailCode && parts.Account_Code__c == oldAccCode){
                    delGSQPart.add(parts);
                }
            }
            system.debug('delGSQPart-->'+delGSQPart);
            if(delGSQPart != null && delGSQPart.size() > 0)
                delete delGSQPart;
            for(CSS_SRT__c srts : gsqRepSRTs){
                system.debug('srts.FailCode__c-->'+srts.FailCode__c);
                system.debug('oldFailCode-->'+oldFailCode);
                if(srts.FailCode__c == oldFailCode && srts.AccountCode_Formula__c == oldAccCode){
                    delGSQSRT.add(srts);
                }
            }
            system.debug('delGSQSRT-->'+delGSQSRT);
            if(delGSQSRT != null && delGSQSRT.size() > 0){
                delete delGSQSRT;
            }
            
            //Make GSQ Parts call
            FetchGSQParts(thisSolCompPopUp.Id, jobId);
            //Make GSQ SRT call
            callGSQSrts(solCompPopupRec, jobId, thisSolCompPopUp, newFailCode, newAccCode);
            
            //Other line items
            for(CSS_Parts_Options__c parts : nonGSQParts){
                if(parts.Get_Fail_Code_Formula__c != null && parts.Get_Fail_Code_Formula__c != '' && parts.Get_Fail_Code_Formula__c.RIGHT(4) == oldFailCode && (parts.Account_Code__c == null || parts.Account_Code__c == '' || parts.Account_Code__c == 'Select One')){
                    if(singleFailCode == true){  //scenario 1
                        parts.Fail_Code__c = '';
                        parts.Account_Code__c = ''; //Just to clear Select One value
                        parts.ReturnToFactory__c = '';
                    }
                }
                else if(parts.Get_Fail_Code_Formula__c != null && parts.Get_Fail_Code_Formula__c != '' && parts.Get_Fail_Code_Formula__c.RIGHT(4) == oldFailCode && parts.Account_Code__c == oldAccCode){  //scenario 1 & 5
                    parts.Fail_Code__c = '';
                    parts.Account_Code__c = '';
                    parts.Covered__c = 0;
                    parts.ReturnToFactory__c = '';
                }
                updatePart.add(parts);
            }
            if(updatePart != null && updatePart.size() > 0)
                update updatePart;
            for(CSS_SRT__c srts : nonGsqSRTs){
                if(srts.FailCode__c == oldFailCode && (srts.AccountCode_Formula__c == null || srts.AccountCode_Formula__c == '' || srts.AccountCode_Formula__c == 'Select One')){
                    if(singleFailCode == true){  //scenario 1
                        srts.FailCode__c = '';
                        srts.Fail_Code_Description__c = '';
                    }
                }
                else if(srts.FailCode__c == oldFailCode && srts.AccountCode_Formula__c == oldAccCode){
                    srts.FailCode__c = '';
                    srts.Fail_Code_Description__c = '';
                    srts.Account_Code__c = '';
                    srts.Account_Code_Description__c = '';
                    srts.SRT_Warrantable__c = '0';
                }
                updateSRT.add(srts);
            }
            if(updateSRT != null && updateSRT.size() > 0){
                update updateSRT;
            }
        }
        //scenario 2 and scenario 6
        if((oldFailCode == newFailCode) && (oldAccCode != newAccCode) && (oldAccCode != null && oldAccCode != '' && oldAccCode != 'Select One') && (newAccCode != null && newAccCode != '' && newAccCode != 'Select One')){ 
            for(CSS_Parts_Options__c parts : partsLst){
                if((parts.Get_Fail_Code_Formula__c != null && parts.Get_Fail_Code_Formula__c != '' && parts.Get_Fail_Code_Formula__c.RIGHT(4) == oldFailCode) && parts.Account_Code__c == oldAccCode){
                    if(parts.RecordTypeId == recTypeIdpart){
                        if((covType != 'POL' && covType != 'OTH' && thisSolCompPopUp.CoveredPartsQty__c != null && thisSolCompPopUp.CoveredPartsQty__c != '' && double.valueof(thisSolCompPopUp.CoveredPartsQty__c) > 0) ||
                        (covType == 'POL' || covType == 'OTH')){
                            parts.Account_Code__c = newAccCode;//solCompPopupRec.CSS_Account_Formula__c;
                            parts.ReturnToFactory__c = '';
                        }
                        else{
                            parts.Account_Code__c = '';
                            parts.Covered__c = 0;
                            parts.ReturnToFactory__c = '';
                        }
                        updatePart.add(parts);
                    }
                    else if(parts.RecordTypeId == recTypeIdOC){
                        if((covType != 'POL' && covType != 'OTH' && thisSolCompPopUp.CoveredOCAmount__c != null && thisSolCompPopUp.CoveredOCAmount__c != '' && double.valueof(thisSolCompPopUp.CoveredOCAmount__c) > 0) ||
                        (covType == 'POL' || covType == 'OTH')){
                            parts.Account_Code__c = newAccCode;//solCompPopupRec.CSS_Account_Formula__c;
                            parts.ReturnToFactory__c = '';
                        }
                        else{
                            parts.Account_Code__c = '';
                            parts.Covered__c = 0;
                            parts.ReturnToFactory__c = '';
                        }
                        updatePart.add(parts);
                    }
                    else if(parts.RecordTypeId == recTypeIdTTML){
                        if(parts.Type__c == 'Commercial-Travel'){
                            if((covType != 'POL' && covType != 'OTH' && thisSolCompPopUp.CoveredTravelBaseFareAmt__c != null && thisSolCompPopUp.CoveredTravelBaseFareAmt__c != '' && double.valueof(thisSolCompPopUp.CoveredTravelBaseFareAmt__c) > 0) && 
                              (thisSolCompPopUp.CoveredTravelLabor__c != null && thisSolCompPopUp.CoveredTravelLabor__c != '' && double.valueof(thisSolCompPopUp.CoveredTravelLabor__c) > 0) || (covType == 'POL' || covType == 'OTH')){
                                parts.Account_Code__c = newAccCode;//solCompPopupRec.CSS_Account_Formula__c;
                                parts.ReturnToFactory__c = '';
                            }
                            else{
                                parts.Account_Code__c = '';
                                parts.Covered__c = 0;
                                parts.ReturnToFactory__c = '';
                            }
                            updatePart.add(parts);
                        }
                        else if(parts.Type__c == 'Non Commercial-Travel'){
                            if((covType != 'POL' && covType != 'OTH' && (thisSolCompPopUp.CoveredTravelMiles__c != null && thisSolCompPopUp.CoveredTravelMiles__c != '' && double.valueof(thisSolCompPopUp.CoveredTravelMiles__c) > 0) && 
                              (thisSolCompPopUp.CoveredTravelLabor__c != null && thisSolCompPopUp.CoveredTravelLabor__c != '' && double.valueof(thisSolCompPopUp.CoveredTravelLabor__c) > 0)) || (covType == 'POL' || covType == 'OTH')){
                                parts.Account_Code__c = newAccCode;//solCompPopupRec.CSS_Account_Formula__c;
                                parts.ReturnToFactory__c = '';
                            }
                            else{
                                parts.Account_Code__c = '';
                                parts.Covered__c = 0;
                                parts.ReturnToFactory__c = '';
                            }
                            updatePart.add(parts);
                        }
                        else if(parts.Type__c == 'Towing'){
                            if((covType != 'POL' && covType != 'OTH' && thisSolCompPopUp.CoveredTowingMiles__c != null && thisSolCompPopUp.CoveredTowingMiles__c != '' && double.valueof(thisSolCompPopUp.CoveredTowingMiles__c) > 0)
                            || (covType == 'POL' || covType == 'OTH')){
                                parts.Account_Code__c = newAccCode;//solCompPopupRec.CSS_Account_Formula__c;
                                parts.ReturnToFactory__c = '';
                            }
                            else{
                                parts.Account_Code__c = '';
                                parts.Covered__c = 0;
                                parts.ReturnToFactory__c = '';
                            }
                            updatePart.add(parts);
                        }
                        else if(parts.Type__c=='Meals' || parts.Type__c=='Lodging'){
                            if((covType != 'POL' && covType != 'OTH' && thisSolCompPopUp.CoveredMealsLodgingAmt__c != null && thisSolCompPopUp.CoveredMealsLodgingAmt__c != '' && double.valueof(thisSolCompPopUp.CoveredMealsLodgingAmt__c) > 0) ||
                            (covType == 'POL' || covType == 'OTH')){
                                parts.Account_Code__c = newAccCode;//solCompPopupRec.CSS_Account_Formula__c;
                                parts.ReturnToFactory__c = '';
                            }
                            else{
                                parts.Account_Code__c = '';
                                parts.Covered__c = 0;
                                parts.ReturnToFactory__c = '';
                            }
                            updatePart.add(parts);
                        }
                    }
                }
            }
            system.debug('updatePart-->'+updatePart);
            if(updatePart != null && updatePart.size() > 0){
                update updatePart;
            }
            if(srtsLst != null && srtsLst.size()>0){
                for(CSS_SRT__c srt : srtsLst){
                    system.debug('srt.FailCode__c--->'+srt.FailCode__c);
                    system.debug('oldFailCode--->'+oldFailCode);
                    system.debug('srt.AccountCode_Formula__c--->'+srt.AccountCode_Formula__c);
                    system.debug('oldAccCode--->'+oldAccCode);
                    if(srt.FailCode__c == oldFailCode && srt.AccountCode_Formula__c == oldAccCode){
                       if((covType != 'POL' && covType != 'OTH' && thisSolCompPopUp.CoveredLaborHrs__c != null && thisSolCompPopUp.CoveredLaborHrs__c != '' && double.valueof(thisSolCompPopUp.CoveredLaborHrs__c) > 0)
                       || (covType == 'POL' || covType == 'OTH')){
                            srt.Account_Code__c = newAccCode;//solCompPopupRec.CSS_Account_Formula__c;
                        }
                        else{
                            srt.Account_Code__c = 'Select One';
                            srt.SRT_Warrantable__c = '0';
                        }
                        updateSRT.add(srt);
                    }
                }
                system.debug('updateSRT--->'+updateSRT);
                if(updateSRT != null && updateSRT.size() > 0){
                    update updateSRT;
                }
            }
        }
        //scenario 4
        if((oldFailCode == newFailCode) && (oldAccCode != newAccCode) && (oldAccCode == null || oldAccCode == '' || oldAccCode == 'Select One') && (newAccCode != null && newAccCode != '' && newAccCode != 'Select One')){ 
            for(CSS_Parts_Options__c parts : gsqParts){
                if((parts.Get_Fail_Code_Formula__c != null && parts.Get_Fail_Code_Formula__c != '' && parts.Get_Fail_Code_Formula__c.RIGHT(4) == oldFailCode) &&
                    (parts.Account_Code__c ==  null || parts.Account_Code__c ==  '' ||  parts.Account_Code__c ==  'Select One') && (oldAccCode ==  null || oldAccCode ==  '' ||  oldAccCode ==  'Select One')){
                    if((covType != 'POL' && covType != 'OTH' && thisSolCompPopUp.CoveredPartsQty__c != null && thisSolCompPopUp.CoveredPartsQty__c != '' && double.valueof(thisSolCompPopUp.CoveredPartsQty__c) > 0)
                    || (covType == 'POL' || covType == 'OTH')){
                        parts.Account_Code__c = newAccCode;//solCompPopupRec.CSS_Account_Formula__c;
                        parts.Covered__c = 100;
                        parts.ReturnToFactory__c = '';
                    }
                    updatePart.add(parts);
                }
            }
            if(updatePart != null && updatePart.size() > 0){
                update updatePart;
            }
            if(gsqRepSRTs != null && gsqRepSRTs.size()>0){
                for(CSS_SRT__c srt : gsqRepSRTs){
                    system.debug('srt.FailCode__c-->'+srt.FailCode__c);
                    system.debug('oldFailCode-->'+oldFailCode);
                    system.debug('srt.AccountCode_Formula__c-->'+srt.AccountCode_Formula__c);
                    system.debug('oldAccCode-->'+oldAccCode);
                    if(srt.FailCode__c == oldFailCode && (srt.AccountCode_Formula__c ==  null || srt.AccountCode_Formula__c ==  '' ||  srt.AccountCode_Formula__c ==  'Select One') && (oldAccCode ==  null || oldAccCode ==  '' ||  oldAccCode ==  'Select One')){
                       if((covType != 'POL' && covType != 'OTH' && thisSolCompPopUp.CoveredLaborHrs__c != null && thisSolCompPopUp.CoveredLaborHrs__c != '' && double.valueof(thisSolCompPopUp.CoveredLaborHrs__c) > 0)
                            || (covType == 'POL' || covType == 'OTH')){
                            srt.Account_Code__c = newAccCode;//solCompPopupRec.CSS_Account_Formula__c;
                            srt.SRT_Warrantable__c = '100';
                        }
                        updateSRT.add(srt);
                    }
                }
                if(updateSRT != null && updateSRT.size() > 0){
                    update updateSRT;
                }
            }
        }
        //scenario 8
        if((oldFailCode == newFailCode) && (oldAccCode != newAccCode) && (oldAccCode != null && oldAccCode != '' && oldAccCode != 'Select One') && (newAccCode == null || newAccCode == '' || newAccCode == 'Select One')){ 
            for(CSS_Parts_Options__c parts : partsLst){
                if((parts.Get_Fail_Code_Formula__c != null && parts.Get_Fail_Code_Formula__c != '' && parts.Get_Fail_Code_Formula__c.RIGHT(4) == oldFailCode) &&
                    parts.Account_Code__c == oldAccCode){
                    parts.Account_Code__c = '';
                    parts.Covered__c = 0;
                    parts.ReturnToFactory__c = '';
                    updatePart.add(parts);
                }
            }
            if(updatePart != null && updatePart.size() > 0){
                update updatePart;
            }
            if(srtsLst != null && srtsLst.size()>0){
                for(CSS_SRT__c srt : srtsLst){
                    if(srt.FailCode__c == oldFailCode && srt.AccountCode_Formula__c == oldAccCode){
                       srt.Account_Code__c = 'Select One';
                       srt.SRT_Warrantable__c = '0';
                       updateSRT.add(srt);
                    }
                }
                if(updateSRT != null && updateSRT.size() > 0){
                    update updateSRT;
                }
            }
        }
        //scenario 7
        if((oldFailCode != newFailCode) && (oldAccCode != newAccCode)){
            //Remove GSQs
            for(CSS_Parts_Options__c parts : gsqParts){
                if(parts.Get_Fail_Code_Formula__c != null && parts.Get_Fail_Code_Formula__c != '' && parts.Get_Fail_Code_Formula__c.RIGHT(4) == oldFailCode && parts.Account_Code__c == oldAccCode){
                    delGSQPart.add(parts);
                }
            }
            system.debug('delGSQPart-->'+delGSQPart);
            if(delGSQPart != null && delGSQPart.size() > 0)
                delete delGSQPart;
            for(CSS_SRT__c srts : gsqRepSRTs){
                if(srts.FailCode__c == oldFailCode && srts.AccountCode_Formula__c == oldAccCode){
                    delGSQSRT.add(srts);
                }
            }
            system.debug('delGSQSRT-->'+delGSQSRT);
            if(delGSQSRT != null && delGSQSRT.size() > 0){
                delete delGSQSRT;
            }

            //Make GSQ Parts call
            FetchGSQParts(thisSolCompPopUp.Id, jobId);
            //Make GSQ SRT call
            callGSQSrts(solCompPopupRec, jobId, thisSolCompPopUp, newFailCode, newAccCode);
            
            //Other line items
            for(CSS_Parts_Options__c parts : nonGSQParts){
                system.debug('parts.Get_Fail_Code_Formula__c-->'+parts.Get_Fail_Code_Formula__c);
                system.debug('parts.Account_Code__c-->'+parts.Account_Code__c);
                system.debug('oldFailCode-->'+oldFailCode);
                system.debug('oldAccCode-->'+oldAccCode);
                if(parts.Get_Fail_Code_Formula__c != null && parts.Get_Fail_Code_Formula__c != '' && parts.Get_Fail_Code_Formula__c.RIGHT(4) == oldFailCode && (parts.Account_Code__c == null || parts.Account_Code__c == '' || parts.Account_Code__c == 'Select One')){
                    parts.Fail_Code__c = '';
                    parts.Account_Code__c = '';
                    parts.ReturnToFactory__c = '';
                }
                else if(parts.Get_Fail_Code_Formula__c != null && parts.Get_Fail_Code_Formula__c != '' && parts.Get_Fail_Code_Formula__c.RIGHT(4) == oldFailCode && parts.Account_Code__c == oldAccCode){
                    parts.Fail_Code__c = '';
                    parts.Account_Code__c = '';
                    parts.Covered__c = 0;
                    parts.ReturnToFactory__c = '';
                }
                updatePart.add(parts);
            }
            if(updatePart != null && updatePart.size() > 0)
                update updatePart;
            for(CSS_SRT__c srts : nonGsqSRTs){
                if(srts.FailCode__c == oldFailCode && (srts.AccountCode_Formula__c == null || srts.AccountCode_Formula__c == '' || srts.AccountCode_Formula__c == 'Select One')){
                    srts.FailCode__c = '';
                    srts.Fail_Code_Description__c = '';
                }
                else if(srts.FailCode__c == oldFailCode && srts.AccountCode_Formula__c == oldAccCode){
                    srts.FailCode__c = '';
                    srts.Fail_Code_Description__c = '';
                    srts.Account_Code__c = '';
                    srts.Account_Code_Description__c = '';
                    srts.SRT_Warrantable__c = '0';
                }
                updateSRT.add(srts);
            }
            if(updateSRT != null && updateSRT.size() > 0){
                update updateSRT;
            }
        }
    }
    @future (callout=true)
    public static void FetchGSQParts(Id solCompId, Id serJobId){
        List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
        solComp = [SELECT Id, Component_Id__c, Solutions__c, FailCode_Formula__c, CSS_Account_Formula__c, CoveredPartsQty__c FROM CSS_Solution_Component__c WHERE Id =: solCompId LIMIT 1];
        CSS_Job_Order__c serJob = new CSS_Job_Order__c();
        serJob = [SELECT Id, ESN__c, Name, Qsol_Engine_Family_Code__c, Service_Model__c, Equipment_ID__c FROM CSS_Job_Order__c WHERE Id =: serJobId LIMIT 1];
        Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        //List<CSS_Parts_Options__c> insertPart = new List<CSS_Parts_Options__c>();
        //insertPart = CSS_FN_SRT.fetchGSQServiceParts(solComp, serJob);
        CSS_FN_SRT.srtPartsServiceNew(solComp, serJob, recTypeIdPart);
        //if(insertPart != null && insertPart.size() > 0){
          //  insert insertPart;
        //}
    }
    public static void callGSQSrts(CSS_Solution_Component__c thisSolComp, Id jobId, CSS_Solution_Component__c thisSolCompNew, String failCode, String accCode){
        List<String> solCompAdd = new List<String>();
        solCompAdd.add(JSON.Serialize(new solCompWrapper(thisSolComp.Solutions__c, jobId, thisSolComp.Service_Model__c, thisSolComp.Equip_ID__c, thisSolComp.id, thisSolComp.Engine_Family_Code__c, thisSolComp.Component_Id__c, thisSolComp.Service_Job__r.Name, null, failCode, accCode, '', thisSolCompNew.CoveredLaborHrs__c, thisSolCompNew.CampaignLaborPercentage__c)));
        CSS_SRT.repairSRT(solCompAdd);
    }
    public class solCompWrapper{ 
        public id solID;
        public id jobID;
        public string serviceModel;
        public string equipID;
        public id compID;
        public string efc;
        public string compoName;
        public string jobName;
        public decimal claimID;
        public string failCode;
        public string accountCode;
        public string type;
        public string CoveredLaborHrs; 
        public string CampaignLaborPercentage;
        public solCompWrapper(id solID,id jobID,string serviceModel,string equipID,id compID,string efc,string compoName,string jobName,decimal claimId,string failCode,string accountCode,string type,string CoveredLaborHrs,string CampaignLaborPercentage){
            this.solID = solID;
            this.jobID = jobID;
            this.serviceModel = serviceModel;
            this.equipID = equipID;
            this.compID = compID;
            this.efc = efc;            
            this.compoName = compoName;
            this.jobName = jobName;
            this.claimId = claimId;
            this.failCode = failCode;
            this.accountCode = accountCode;
            this.type = type;
            this.CoveredLaborHrs = CoveredLaborHrs;
            this.CampaignLaborPercentage = CampaignLaborPercentage;
        }
    }
    public void updateFieldActionPartsFailCodeAccCode(List<CSS_Solution_Component__c> solCompLst){
        List<Id> fieldActSolnComp = new List<Id>();
        for(CSS_Solution_Component__c sc : solCompLst){
            fieldActSolnComp.add(sc.Id);
        }
        List<CSS_Parts_Options__c> fieldActParts = new List<CSS_Parts_Options__c>();
        fieldActParts = [SELECT Id, FailurepartId__r.FailCode_Formula__c, FailurepartId__r.CSS_Account_Formula__c FROM CSS_Parts_Options__c WHERE FailurepartId__c IN: fieldActSolnComp];
        if(fieldActParts != null && fieldActParts.size() > 0){
            for(CSS_Parts_Options__c fieldParts : fieldActParts){
                fieldParts.Account_Code__c = fieldParts.FailurepartId__r.CSS_Account_Formula__c;
                fieldParts.Fail_Code__c = fieldParts.FailurepartId__r.FailCode_Formula__c;
            }
            update fieldActParts;
        }
    }
}