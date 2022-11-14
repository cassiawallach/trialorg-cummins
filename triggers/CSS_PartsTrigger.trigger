/**********************************************************************
Name:CSS_PartsTrigger
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this trigger for inserting audit trail related records in job history object
======================================================
======================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL  
1.0 -   Vignesh/Rajkumar    4/25/2019      Added code as part of user story 179208
***********************************************************************/
trigger CSS_PartsTrigger on CSS_Parts_Options__c (after insert, after update,after delete, before delete, before Update, before insert) {
    //****************** This is for GUIDANZ*******************/
    system.debug('Parts trigger call');
    boolean guidanzFlag = false;
    if(!trigger.isdelete) {
        for(CSS_Parts_Options__c par : Trigger.New) {
            system.debug('parts '+ par);
            if((par.CSS_Classic_SJId__c != null && par.CSS_Classic_SJId__c != '') || par.CSS_Claims__c != null){
                guidanzFlag = true;
                break;
            }
        } 
    } else {
        for(CSS_Parts_Options__c par : Trigger.Old) {
            system.debug('parts '+ par);
            if((par.CSS_Classic_SJId__c != null && par.CSS_Classic_SJId__c != '') || par.CSS_Claims__c != null){
                guidanzFlag = true;
                break;
            }
        } 
    }
    //****************** This is for GUIDANZ*******************/
    if(guidanzFlag) {
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                List<CG_Claim_Audit_Log__c> claimsAuditLst = [SELECT Id, isServicejob__c, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Edit_Message__c, Remove_Message__c
                                                              FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_Parts_Options__c' ORDER BY Sort_Order__c ASC]; 
                CG_CL_ClaimsAuditTrailEventHandler.onInsertPOC(Trigger.new, claimsAuditLst);
            }
            system.debug('isFirstTimePartsTriggerAfterUpdate -->'+RecursiveTriggerHandler.isFirstTimePartsTriggerAfterUpdate);
            if(Trigger.isUpdate && RecursiveTriggerHandler.isFirstTimePartsTriggerAfterUpdate == true){
                RecursiveTriggerHandler.isFirstTimePartsTriggerAfterUpdate = false;
                system.debug('isFirstTimePartsTriggerAfterUpdate -->'+RecursiveTriggerHandler.isFirstTimePartsTriggerAfterUpdate);
                if(CSS_RecursiveTriggerHandler.isFirstTimePartsTrigger == true){
                    List<CG_Claim_Audit_Log__c> claimsAuditLst = [SELECT Id, isServicejob__c, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Edit_Message__c, Remove_Message__c
                                                                  FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_Parts_Options__c' ORDER BY Sort_Order__c ASC]; 
    
                    CSS_RecursiveTriggerHandler.isFirstTimePartsTrigger = false;
                    CG_CL_ClaimsAuditTrailEventHandler.onUpdatePOC(Trigger.new, trigger.oldmap, claimsAuditLst);
                    CG_CL_ClaimsAuditTrailEventHandler.onPartsUpdate(Trigger.new, trigger.oldmap, claimsAuditLst);
                    
                }
            }
             // Anvesh add below code as part of defect GSSC-427
            if(Trigger.isDelete){
                system.debug('Parts trigger call isDelete called');
            List<Id> lstClaimIdsODMParts = new List<Id>();
            for(CSS_Parts_Options__c parts1 : trigger.old){
                    lstClaimIdsODMParts.add(parts1.CSS_Claims__c);
                }
                system.debug(' lstClaimIdsODMParts  >> ' + lstClaimIdsODMParts);
                CG_CL_UpdatePartsOptionsODMStatus.updatePartsODMStatusMethod(lstClaimIdsODMParts);
            }
        }
        else if(Trigger.isBefore){
            if(trigger.isDelete){
                system.debug('inside parts option trigger**Delete**');
                List<CG_Claim_Audit_Log__c> claimsAuditLst = [SELECT Id, isServicejob__c, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Edit_Message__c, Remove_Message__c
                                                              FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_Parts_Options__c' ORDER BY Sort_Order__c ASC]; 
                CG_CL_ClaimsAuditTrailEventHandler.onDeletePOC(Trigger.old, claimsAuditLst);
                List<CSS_Parts_Options__c> prcLst = new List<CSS_Parts_Options__c>();
                List<CSS_SRT__c> admSRT = new List<CSS_SRT__c>();
                Set<Id> partId = new Set<Id>();
                Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                Id claimId;
                for(CSS_Parts_Options__c parts : trigger.old){
                    if(parts.ReturnToFactory__c  == 'Y' && parts.ReturnWaiver__c == false && parts.selected_part__c == true && parts.RecordTypeId == recTypeIdPart && parts.Parts_Type__c == 'Custom' && parts.Service_Job__c == null){
                        claimId = parts.CSS_Claims__c;
                        partId.add(parts.Id);
                    }
                }
                if(partId != null && partId.size() > 0 && claimId != null){
                    prcLst = [SELECT Id FROM CSS_Parts_Options__c WHERE ReturnToFactory__c = 'Y' AND ReturnWaiver__c = false AND selected_part__c = TRUE AND Parts_Type__c = 'Custom' AND CSS_Claims__c =: claimId AND Id NOT IN: partId];
                    if(prcLst != null && prcLst.size() > 0){
                        //do nothing
                    }
                    else{
                        admSRT = [SELECT Id FROM CSS_SRT__c WHERE SRT_ID__c = '00-10S-00' AND CSS_Claims__c =: claimId];
                        if(admSRT != null && admSRT.size() > 0){
                            delete admSRT;
                            // Added as part of story 190053  to make PartReturnToCenter as 'N' if no URP start
                            CSS_Claims__c claimRec = new CSS_Claims__c();
                            claimRec.Id = claimId;
                            claimRec.PartReturnToCenter__c = 'N';
                            update claimRec;
                            // Added as part of story 190053 to make PartReturnToCenter as 'N' if no URP end
                        }
                    }
                }
    
            }
            //the below code is to implement Task 189224
            system.debug('isFirstTimePartsTriggerBeforeUpdate -->'+RecursiveTriggerHandler.isFirstTimePartsTriggerBeforeUpdate);
            if(trigger.isUpdate && RecursiveTriggerHandler.isFirstTimePartsTriggerBeforeUpdate == true){
                RecursiveTriggerHandler.isFirstTimePartsTriggerBeforeUpdate = false;
                system.debug('isFirstTimePartsTriggerBeforeUpdate -->'+RecursiveTriggerHandler.isFirstTimePartsTriggerBeforeUpdate);
                List<CSS_Solution_Component__c> lstSolComp = new List<CSS_Solution_Component__c>();
                List<CSS_Parts_Options__c> lstGsqPartstoUpd= new List<CSS_Parts_Options__c>();
                Id claimId;
                Map<String,Id> failAccCodeFailureMap = new Map<String,Id>();
                for(CSS_Parts_Options__c parts : trigger.old){
                    if(parts.Part_Assignment__c != null && parts.Part_Assignment__c != '' && parts.Part_Assignment__c.equalsignorecase('Primary')){
                        claimId = parts.CSS_Claims__c;
                        break;
                    }
                }
                if(claimId != null){
                    lstSolComp = [SELECT  Id,Fail_Code__c, FailCode_Formula__c, CSS_Account_Formula__c from CSS_Solution_Component__c where css_claims__c = :claimId and type__C NOT IN ('TSB', 'TRP','ATC','Campaign')]; 
                    for(CSS_Solution_Component__c solComp: lstSolComp){
                        if(failAccCodeFailureMap != null && failAccCodeFailureMap.Containskey(solComp.FailCode_Formula__c+solComp.CSS_Account_Formula__c)){}
                        else{
                            failAccCodeFailureMap.put(solComp.FailCode_Formula__c+solComp.CSS_Account_Formula__c,solComp.id);
                        }
        
                    }
                    for(CSS_Parts_Options__c parts : trigger.new){
                        if(parts.Part_Assignment__c == 'Primary' && failAccCodeFailureMap != null && failAccCodeFailureMap.get(parts.Fail_Code__c+parts.Account_Code__c) != null){
                            parts.failurepartid__c = failAccCodeFailureMap.get(parts.Fail_Code__c+parts.Account_Code__c);
                        }
                    }
                }
                //GSSC-138 - Start
                Id recTypeParts = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
                if(userinfo.getDefaultCurrency() == 'USD'){
                    lstCurrencyDetails = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c order by Bolt_Version__c desc limit 1];
                }
                else{
                    lstCurrencyDetails = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c where Bolt_To_Currency__c =: userinfo.getDefaultCurrency() order by Bolt_Version__c desc limit 1];
                }
                for(CSS_Parts_Options__c parts : trigger.new){
                    if(parts.CSS_Claims__c != null){
                        if(parts.RecordTypeId == recTypeParts && parts.CSS_Claims__c != null){ //GSQ Parts, Field Action Parts and URP - Claims
                            if((parts.Unit_Price__c != trigger.oldMap.get(parts.Id).Unit_Price__c)){
                                if(lstCurrencyDetails != null && lstCurrencyDetails.size() > 0){
                                    parts.Exchange_Rate__c = 1;
                                    parts.Unit_Price_Local_Currency__c = decimal.valueof(parts.Unit_Price__c);
                                    parts.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                    parts.Currency_Type__c = 'USD';
                                }
                            }
                        }
                    }
                }
            }
            //GSSC-138 - End
            if(trigger.isInsert){
                system.debug('Inside Before Insert IF');
                system.debug('trigger.new--'+trigger.new);
                Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
                Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
                Id recTypeParts = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                
                List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
                if(userinfo.getDefaultCurrency() == 'USD'){
                    lstCurrencyDetails = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c order by Bolt_Version__c desc limit 1];
                }
                else{
                    lstCurrencyDetails = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c where Bolt_To_Currency__c =: userinfo.getDefaultCurrency() order by Bolt_Version__c desc limit 1];
                }
                CSS_Claims__c claim = new CSS_Claims__c();
                if(trigger.new[0].CSS_Claims__c != null){
                    claim = [SELECT Id, CSS_Job__c, Dealer_Service_Job__c FROM CSS_Claims__c WHERE Id =: trigger.new[0].CSS_Claims__c];
                }
                for(CSS_Parts_Options__c parts : trigger.new){
                    if(parts.CSS_Claims__c == null){
                        if(parts.RecordTypeId == recTypeIdOC){
                            if(lstCurrencyDetails != null && lstCurrencyDetails.size() > 0){
                                if(userinfo.getDefaultCurrency() != 'USD'){
                                    parts.Exchange_Rate__c = lstCurrencyDetails[0].Bolt_Conversion_Rate__c;
                                    parts.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                    parts.Unit_Price_Local_Currency__c = parts.Sell_Price__c;
                                    parts.Amount_Local_Currency__c = parts.Amount__c;
                                    parts.Sell_Price__c = (parts.Sell_Price__c) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c);
                                    if(parts.Sell_Price__c != null){
                                        parts.Sell_Price__c = (parts.Sell_Price__c).setscale(2);
                                    }
                                    parts.Amount__c = (parts.Amount__c) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c);
                                    if(parts.Amount__c != null){
                                        parts.Amount__c = (parts.Amount__c).setscale(2);
                                    }
                                }
                                else{
                                    parts.Exchange_Rate__c = 1;
                                    parts.Unit_Price_Local_Currency__c = parts.Sell_Price__c;
                                    parts.Amount_Local_Currency__c = parts.Amount__c;
                                    parts.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                }
                                parts.Currency_Type__c = userinfo.getDefaultCurrency();
                            }
                        }
                        else if(parts.RecordTypeId == recTypeIdTTML){
                            if(lstCurrencyDetails != null && lstCurrencyDetails.size() > 0){
                                if(userinfo.getDefaultCurrency() != 'USD'){
                                    parts.Exchange_Rate__c = lstCurrencyDetails[0].Bolt_Conversion_Rate__c;
                                    parts.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                    parts.Unit_Price_Local_Currency__c = (parts.Unit_Price__c != null && parts.Unit_Price__c != '') ? decimal.valueof(parts.Unit_Price__c) : null;
                                    parts.Amount_Local_Currency__c = parts.ExpenseTotal__c;
                                    parts.Unit_Price__c = (parts.Unit_Price__c != null && parts.Unit_Price__c != '') ? (string.valueof((decimal.valueof(parts.Unit_Price__c)) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c))) : '';
                                    if(parts.Unit_Price__c != null && parts.Unit_Price__c != ''){
                                        parts.Unit_Price__c = string.valueof((decimal.valueof(parts.Unit_Price__c)).setscale(2));
                                    }
                                    parts.ExpenseTotal__c = (parts.ExpenseTotal__c) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c);
                                    if(parts.ExpenseTotal__c != null){
                                        parts.ExpenseTotal__c = (parts.ExpenseTotal__c).setscale(2);
                                    }
                                }
                                else{
                                    parts.Exchange_Rate__c = 1;
                                    parts.Unit_Price_Local_Currency__c = (parts.Unit_Price__c != null && parts.Unit_Price__c != '') ? decimal.valueof(parts.Unit_Price__c) : null;
                                    parts.Amount_Local_Currency__c = parts.ExpenseTotal__c;
                                    parts.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                }
                                parts.Currency_Type__c = userinfo.getDefaultCurrency();
                            }
                        }
                    }
                    else if(parts.CSS_Claims__c != null){
                       if(claim.CSS_Job__c == null && claim.Dealer_Service_Job__c == null){
                            if(parts.RecordTypeId == recTypeIdOC || parts.RecordTypeId == recTypeIdTTML){
                                if(lstCurrencyDetails != null && lstCurrencyDetails.size() > 0){
                                    if(userinfo.getDefaultCurrency() != 'USD'){
                                        parts.Exchange_Rate__c = lstCurrencyDetails[0].Bolt_Conversion_Rate__c;
                                        parts.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                        parts.Unit_Price_Local_Currency__c = (parts.Unit_Price__c != null && parts.Unit_Price__c != '') ? decimal.valueof(parts.Unit_Price__c) : null;
                                        parts.Amount_Local_Currency__c = parts.ExpenseTotal__c;
                                        parts.Unit_Price__c = (parts.Unit_Price__c != null && parts.Unit_Price__c != '') ? (string.valueof((decimal.valueof(parts.Unit_Price__c)) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c))) : null;
                                        if(parts.Unit_Price__c != null){
                                            parts.Unit_Price__c = string.valueof((decimal.valueof(parts.Unit_Price__c)).setscale(2));
                                        }
                                        parts.ExpenseTotal__c = (parts.ExpenseTotal__c) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c);
                                        if(parts.ExpenseTotal__c != null){
                                            parts.ExpenseTotal__c = (parts.ExpenseTotal__c).setscale(2);
                                        }
                                    }
                                    else{
                                        parts.Exchange_Rate__c = 1;
                                        parts.Unit_Price_Local_Currency__c = (parts.Unit_Price__c != null && parts.Unit_Price__c != '') ? decimal.valueof(parts.Unit_Price__c) : null;
                                        parts.Amount_Local_Currency__c = parts.ExpenseTotal__c;
                                        parts.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                    }
                                    parts.Currency_Type__c = userinfo.getDefaultCurrency();
                                }
                            }
                       }
                       else{
                           if(parts.RecordTypeId == recTypeIdOC || parts.RecordTypeId == recTypeIdTTML){
                                if(lstCurrencyDetails != null && lstCurrencyDetails.size() > 0){
                                    if(userinfo.getDefaultCurrency() != 'USD'){
                                        parts.Unit_Price_Local_Currency__c = (parts.Unit_Price__c != null && parts.Unit_Price__c != '') ? ((decimal.valueof(parts.Unit_Price__c)) * (lstCurrencyDetails[0].Bolt_Conversion_Rate__c)) : null;
                                        parts.Amount_Local_Currency__c = (parts.ExpenseTotal__c != null) ? (parts.ExpenseTotal__c * (lstCurrencyDetails[0].Bolt_Conversion_Rate__c)) : null;
                                    }
                                    else{
                                        parts.Exchange_Rate__c = 1;
                                        parts.Unit_Price_Local_Currency__c = (parts.Unit_Price__c != null && parts.Unit_Price__c != '') ? decimal.valueof(parts.Unit_Price__c) : null;
                                        parts.Amount_Local_Currency__c = parts.ExpenseTotal__c;
                                        parts.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                    }
                                    parts.Currency_Type__c = userinfo.getDefaultCurrency();
                                }
                            }
                       }
                    }
                }
                system.debug('parts--'+trigger.new);
            }
        }
    }
}