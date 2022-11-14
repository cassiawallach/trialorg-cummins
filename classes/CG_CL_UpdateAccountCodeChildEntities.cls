public class CG_CL_UpdateAccountCodeChildEntities {
    @InvocableMethod(label='updateRelatedRecsAccCode' description='update account code at Child level') 
    public static void updateAccCode(List<String> oldAccCode_SolCompId){
        //Added as part of the defect # 191933 - START
        Map<String, String> accCodeCovTypeMap = new Map<String, String>();
        for(CSS_JobEventTemporary__c jet : [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes']){
            if(!accCodeCovTypeMap.containsKey(jet.Attribute3__c)){
                accCodeCovTypeMap.put(jet.Attribute3__c, jet.Attribute1__c);
            }
        }
        //Added as part of the defect # 191933 - END
        system.debug('Input**'+oldAccCode_SolCompId[0]);
        List<String> inputParam = oldAccCode_SolCompId[0].split(';;');
        List<CSS_Parts_Options__c> partsLst = new List<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> partsToUpd = new List<CSS_Parts_Options__c>();
        List<CSS_SRT__c> srtLst = new List<CSS_SRT__c>();
        List<CSS_SRT__C> srtsToUpd = new List<CSS_SRT__c>();
        List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
        String oldAccCode = '';
        String solCompId;
        String oldFailCode;
        if(inputParam.size() > 0)
            oldAccCode = inputParam[0].trim();
        if(inputParam.size() > 1)
            solCompId = inputParam[1].trim();
            if(inputParam.size() > 2)
            oldFailCode = inputParam[2].trim();
        system.debug('oldAccCode'+oldAccCode);
        system.debug('solCompId'+solCompId);
        system.debug('oldFailCode'+oldFailCode);
        solComp = [SELECT Id, CSS_Claims__c, CSS_Account_Formula__c,Type__c, CSS_Failure_Sequence_Number__c, CoveredPartsQty__c, CampaignPartsPercentage__c, CoveredOCAmount__c, 
                      CampaignOCPercentage__c, CoveredLaborHrs__c, CampaignLaborPercentage__c, CoveredTravelBaseFareAmt__c, CoveredTravelLabor__c,
                      CoveredTravelMiles__c, CoveredTowingMiles__c, CoveredMealsLodgingAmt__c, CampaignTravelPercentage__c, CampaignTowingPercentage__c,Fail_Code__c FROM CSS_Solution_Component__c 
                      WHERE Id =: solCompId AND CSS_Claims__c != null AND Type__c NOT IN ('Campaign','ATC','TRP')];
        if(solComp != null && solComp.size() > 0){
            //partsLst = [SELECT Id, RecordTypeId, Type__c, Account_Code__c, CSS_Claims__c FROM CSS_Parts_Options__c WHERE (Account_Code__c =: oldAccCode OR Account_Code__c = null OR Account_Code__c = '') AND CSS_Claims__c =: solComp[0].CSS_Claims__c];
            //srtLst = [SELECT Id, AccountCode_Formula__c, CSS_Claims__c FROM CSS_SRT__c WHERE (AccountCode_Formula__c =: oldAccCode OR AccountCode_Formula__c = null OR AccountCode_Formula__c = '') AND CSS_Claims__c =: solComp[0].CSS_Claims__c]; //Commented, as the null Coverage to Coverage account code does not come under requirement
            //partsLst = [SELECT Id, RecordTypeId, Type__c, Account_Code__c, CSS_Claims__c FROM CSS_Parts_Options__c WHERE Account_Code__c =: oldAccCode AND CSS_Claims__c =: solComp[0].CSS_Claims__c];
            //srtLst = [SELECT Id, FailCode__c,Fail_Code_Description__c,AccountCode_Formula__c, CSS_Claims__c,type__c FROM CSS_SRT__c WHERE AccountCode_Formula__c =: oldAccCode AND CSS_Claims__c =: solComp[0].CSS_Claims__c]; 
            partsLst = [SELECT Id, RecordTypeId, Type__c, Fail_Code__c,Account_Code__c, CSS_Claims__c FROM CSS_Parts_Options__c WHERE Fail_Code__c =: oldFailCode AND Account_Code__c =: oldAccCode AND CSS_Claims__c =: solComp[0].CSS_Claims__c];
            //Below if else is added as part of the defect # 191933
            if(oldAccCode != null && oldAccCode != ''){
                srtLst = [SELECT Id, FailCode__c,Fail_Code_Description__c,AccountCode_Formula__c, CSS_Claims__c,type__c FROM CSS_SRT__c WHERE AccountCode_Formula__c =: oldAccCode AND CSS_Claims__c =: solComp[0].CSS_Claims__c AND (FailCode__c = : oldFailCode.Right(4))];// OR Fail_Code_Description__c.Right(4))];
            }
            else{
                srtLst = [SELECT Id, FailCode__c,Fail_Code_Description__c,AccountCode_Formula__c, CSS_Claims__c,type__c FROM CSS_SRT__c WHERE (AccountCode_Formula__c =: oldAccCode OR AccountCode_Formula__c = 'Select One') AND CSS_Claims__c =: solComp[0].CSS_Claims__c AND (FailCode__c = : oldFailCode.Right(4))];
            }
            system.debug('solComp'+solComp[0]);
            system.debug('partsLst'+partsLst);
            system.debug('srtLst'+srtLst);
        }
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        //Loop through parts and update to new accountcode if coverage exists if not update to blank
        if(partsLst != null && partsLst.size() > 0){
            for(CSS_Parts_Options__c parts : partsLst){
                CSS_Parts_Options__c singlePartRec = new CSS_Parts_Options__c();
                singlePartRec.Id = parts.Id;
                if(parts.RecordTypeId == recTypeIdpart){
                    if(solComp[0].CoveredPartsQty__c != null && solComp[0].CoveredPartsQty__c != '' && double.valueof(solComp[0].CoveredPartsQty__c) > 0){
                        singlePartRec.Account_Code__c = solComp[0].CSS_Account_Formula__c;
                        singlePartRec.ReturnToFactory__c = '';
                       // singlePartRec.Fail_Code__c = solComp[0].Fail_Code__c;
                    }
                    else{
                        singlePartRec.Account_Code__c = '';
                        singlePartRec.Fail_Code__c = '';
                        singlePartRec.Covered__c=0;
                        singlePartRec.ReturnToFactory__c = '';
                    }
                    partsToUpd.add(singlePartRec);
                }
                else if(parts.RecordTypeId == recTypeIdOC){
                    if(solComp[0].CoveredOCAmount__c != null && solComp[0].CoveredOCAmount__c != '' && double.valueof(solComp[0].CoveredOCAmount__c) > 0){
                        singlePartRec.Account_Code__c = solComp[0].CSS_Account_Formula__c;
                        singlePartRec.ReturnToFactory__c = '';
                        //singlePartRec.Fail_Code__c = solComp[0].Fail_Code__c;
                    }
                    else{
                        singlePartRec.Account_Code__c = '';
                        singlePartRec.Fail_Code__c = '';
                        singlePartRec.Covered__c=0;
                        singlePartRec.ReturnToFactory__c = '';
                    }
                    partsToUpd.add(singlePartRec);
                }
                else if(parts.RecordTypeId == recTypeIdTTML){
                    if(parts.Type__c == 'Commercial-Travel'){
                        if((solComp[0].CoveredTravelBaseFareAmt__c != null && solComp[0].CoveredTravelBaseFareAmt__c != '' && double.valueof(solComp[0].CoveredTravelBaseFareAmt__c) > 0) && 
                          (solComp[0].CoveredTravelLabor__c != null && solComp[0].CoveredTravelLabor__c != '' && double.valueof(solComp[0].CoveredTravelLabor__c) > 0)){
                            singlePartRec.Account_Code__c = solComp[0].CSS_Account_Formula__c;
                            singlePartRec.ReturnToFactory__c = '';
                            //singlePartRec.Fail_Code__c = solComp[0].Fail_Code__c;
                        }
                        else{
                            singlePartRec.Account_Code__c = '';
                            singlePartRec.Fail_Code__c = '';
                            singlePartRec.Covered__c=0;
                            singlePartRec.ReturnToFactory__c = '';
                        }
                        partsToUpd.add(singlePartRec);
                    }
                    else if(parts.Type__c == 'Non Commercial-Travel'){
                        if((solComp[0].CoveredTravelMiles__c != null && solComp[0].CoveredTravelMiles__c != '' && double.valueof(solComp[0].CoveredTravelMiles__c) > 0) && 
                          (solComp[0].CoveredTravelLabor__c != null && solComp[0].CoveredTravelLabor__c != '' && double.valueof(solComp[0].CoveredTravelLabor__c) > 0)){
                            singlePartRec.Account_Code__c = solComp[0].CSS_Account_Formula__c;
                            singlePartRec.ReturnToFactory__c = '';
                            //singlePartRec.Fail_Code__c = solComp[0].Fail_Code__c;
                        }
                        else{
                            singlePartRec.Account_Code__c = '';
                            singlePartRec.Fail_Code__c = '';
                            singlePartRec.Covered__c=0;
                            singlePartRec.ReturnToFactory__c = '';
                        }
                        partsToUpd.add(singlePartRec);
                    }
                    else if(parts.Type__c == 'Towing'){
                        if(solComp[0].CoveredTowingMiles__c != null && solComp[0].CoveredTowingMiles__c != '' && double.valueof(solComp[0].CoveredTowingMiles__c) > 0){
                            singlePartRec.Account_Code__c = solComp[0].CSS_Account_Formula__c;
                            singlePartRec.ReturnToFactory__c = '';
                            //singlePartRec.Fail_Code__c = solComp[0].Fail_Code__c;
                        }
                        else{
                            singlePartRec.Account_Code__c = '';
                            singlePartRec.Fail_Code__c = '';
                            singlePartRec.Covered__c=0;
                            singlePartRec.ReturnToFactory__c = '';
                        }
                        partsToUpd.add(singlePartRec);
                    }
                    else if(parts.Type__c=='Meals' || parts.Type__c=='Lodging'){
                        if(solComp[0].CoveredMealsLodgingAmt__c != null && solComp[0].CoveredMealsLodgingAmt__c != '' && double.valueof(solComp[0].CoveredMealsLodgingAmt__c) > 0){
                            singlePartRec.Account_Code__c = solComp[0].CSS_Account_Formula__c;
                            singlePartRec.ReturnToFactory__c = '';
                           // singlePartRec.Fail_Code__c = solComp[0].Fail_Code__c;
                        }
                        else{
                            singlePartRec.Account_Code__c = '';
                            singlePartRec.Fail_Code__c = '';
                            singlePartRec.Covered__c=0;
                            singlePartRec.ReturnToFactory__c = '';
                        }
                        partsToUpd.add(singlePartRec);
                    }
                }
            }
            if(partsToUpd != null && partsToUpd.size() > 0){
                update partsToUpd;
            }
        }
        if(srtLst != null && srtLst.size()>0){
             for(CSS_SRT__c srt : srtLst){
                 //Added as part of the defect # 191933 - START
                 String covtype = '';
                 if(accCodeCovTypeMap != null && solComp[0].CSS_Account_Formula__c != null && solComp[0].CSS_Account_Formula__c != ''){
                    covtype = accCodeCovTypeMap.get(solComp[0].CSS_Account_Formula__c.RIGHT(2));
                 }
                 //Added as part of the defect # 191933 - END
                 if((srt.FailCode__c != null && srt.FailCode__c != '' && srt.FailCode__c == oldFailCode.Right(4)) || (srt.Fail_Code_Description__c != null && srt.Fail_Code_Description__c != '' && srt.Fail_Code_Description__c == oldFailCode)){
                   if((solComp[0].CoveredLaborHrs__c != null && solComp[0].CoveredLaborHrs__c != '' && double.valueof(solComp[0].CoveredLaborHrs__c) > 0) || (covtype == 'POL' || covtype == 'OTH')){ ////Added POL/OTH as part of the defect # 191933 - START
                        srt.Account_Code__c = solComp[0].CSS_Account_Formula__c;
                        //srt.FailCode__c = solComp[0].Fail_Code__c;
                        if(srt.type__c == '99Time')
                        srt.Account_Code_Description__c = solComp[0].CSS_Account_Formula__c;
                        //srt.Fail_Code_Description__c = solComp[0].Fail_Code__c;
                    }
                    else{
                        srt.Account_Code__c = '';
                        srt.FailCode__c = '';
                        if(srt.type__c == '99Time')
                        srt.Account_Code_Description__c = '';
                         srt.Fail_Code_Description__c = '';
                        
                    }
                    srtsToUpd.add(srt);
                 }
                }
                if(srtsToUpd != null && srtsToUpd.size() > 0){
                update srtsToUpd;
            }
        }
    }
}