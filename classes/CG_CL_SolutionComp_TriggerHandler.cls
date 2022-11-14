public class CG_CL_SolutionComp_TriggerHandler {
    
    //Created method as part of the story GSSC-456
    public void deleteChildRecordsOnRootCauseUnSelect(Set<String> failCodeAccCode, Id jobId){
        Map<String, List<CSS_SRT__c>> mapSrt = new Map<String, List<CSS_SRT__c>>();
        Map<String, List<CSS_Parts_Options__c>> mappart = new Map<String, List<CSS_Parts_Options__c>>();
        List<CSS_Parts_Options__c> prtLstUpd = new List<CSS_Parts_Options__c>();
        List<CSS_SRT__c> srtLst = new List<CSS_SRT__c>();
        List<CSS_SRT__c> delSrt = new List<CSS_SRT__c>();
        List<CSS_SRT__c> srtLstUpd = new List<CSS_SRT__c>();
        
        srtLst = [SELECT Id, Type__c, isPerformed__c, FailCode__c, Fail_Code_Description__c, SRT_ID__c, SRT_Type__c,SRT_Category__c, Account_Code__c, Account_Code_Description__c, AccountCode_Formula__c FROM CSS_SRT__c WHERE Job_Order__c =: jobId
                            AND FailCode__c != null AND FailCode__c != '' AND FailCode__c != 'Select One' AND AccountCode_Formula__c != '' AND AccountCode_Formula__c != null AND AccountCode_Formula__c != 'Select One'];
                            
        
 
                              
        for(CSS_SRT__c srt : srtLst){
            String temp;
            temp = srt.FailCode__c + ';;' + srt.AccountCode_Formula__c;
            if(!mapSrt.containsKey(temp)){
                List<CSS_SRT__c> tempSrtLst = new List<CSS_SRT__c>();
                tempSrtLst.add(srt);
                mapSrt.put(temp, tempSrtLst);
            }
            else{
                List<CSS_SRT__c> tempSrtLst = new List<CSS_SRT__c>();
                tempSrtLst = mapSrt.get(temp);
                tempSrtLst.add(srt);
                mapSrt.put(temp, tempSrtLst);
            }
        }
        for(String fcac : failCodeAccCode){
            List<CSS_SRT__c> srtLstNew = new List<CSS_SRT__c>();
            srtLstNew = mapSrt.get(fcac);
            if(srtLstNew != null && srtLstNew.size() > 0){
                for(CSS_SRT__c srtRec : srtLstNew){
                    if((srtRec.SRT_Category__c == 'AdditionalDiag' || srtRec.SRT_Category__c == 'AdditionalRep') && srtRec.SRT_ID__c != '00-10S-00'){ //, Manual Diag, Manual Rep)
                        //delSrt.add(srtRec);
                        srtRec.FailCode__c = '';	//Defect: GSSC:597
                        srtRec.Account_Code__c ='';	//Defect: GSSC:597
                        system.debug('srtRec--'+srtRec);
                        srtLstUpd.add(srtRec);
                    }
                    else if(srtRec.Type__c == 'Diagnosis'){ //GSQ diag, GSQ Rep	//Defect: GSSC:574 - By Krishna.
                        //srtRec.isPerformed__c = false;	//Defect: GSSC:574 - By Krishna.
                        srtRec.FailCode__c = '';	//Defect: GSSC:574 - By Krishna.
                        srtRec.Account_Code__c ='';	//Defect: GSSC:574 - By Krishna.
                        srtLstUpd.add(srtRec);
                    }
                    else if(srtRec.Type__c == 'Repair'){ //GSQ diag, GSQ Rep
                        srtRec.isPerformed__c = false;
                        srtLstUpd.add(srtRec);
                    } 
                    else if(srtRec.Type__c == 'Diag Access' && srtRec.SRT_Type__c == 'Access') {	//Diag Access
                        srtRec.FailCode__c = '';	//Defect: GSSC:597 - By Krishna.
                        srtRec.Account_Code__c ='';	//Defect: GSSC:597 - By Krishna.
                        srtLstUpd.add(srtRec);
                    }
                    else if(srtRec.Type__c == 'Repair Access' && srtRec.SRT_Type__c == 'Access'){  //Rep Access
                        delSrt.add(srtRec);
                    }
                    /* Defect: GSSC:597 - By Krishna.
                    else if((srtRec.Type__c == 'Diag Access' && srtRec.SRT_Type__c == 'Access') || (srtRec.Type__c == 'Repair Access' && srtRec.SRT_Type__c == 'Access')){  //Diag Access, Rep Access
                        delSrt.add(srtRec);
                    }
					*/
                    else if(srtRec.Type__c == '99Time'){ //99 SRT
                        delSrt.add(srtRec);
                    }
                }
            }
        }
        if(delSrt != null && delSrt.size() > 0){
            delete delSrt;
        }
        if(srtLstUpd != null && srtLstUpd.size() > 0){
            update srtLstUpd;
        }
      
    }
    ////below code added for GSQ parts selected_part__c field making to  false as per Defect#GSSC-576
    public void uncheckPartid(Set<String> failCodeAccCode, Id jobId){
        system.debug('enteredinto<>'); 
        List<CSS_Parts_Options__c> prtLstUpd = new List<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> partsList = new List<CSS_Parts_Options__c>();
         partsList = [select Id, Name, Selected_part__c, FailurepartId__r.Root_Cause__c,Get_Fail_Code_Formula__c, Service_partnumber__c, Account_Code__c, Fail_Code__c, Service_Job__c, ReturnToFactory__c from CSS_Parts_Options__c where Service_Job__c =: jobId 
         AND FailurepartId__c !=null AND FailurepartId__c !=''];
         system.debug('partsListsolcomtrigger<><>'+partsList);
         //below code added for GSQ parts selected_part__c field making to  false as per Defect#GSSC-576
            for(CSS_Parts_Options__c prt : partsList){
                if(prt.FailurepartId__r.Root_Cause__c==false){
            prt.selected_part__c = false;
            prtLstUpd.add(prt);
            system.debug('prtLstUpdsolcomtrigger<><>'+prtLstUpd);
            }
            
        }
         // below code added for GSQ parts selected_part__c = false as per Defect#GSSC-576
        if(prtLstUpd!= null && prtLstUpd.size() > 0){
            update prtLstUpd;
            system.debug('prtLstUpdsolcomtrigger<><>'+prtLstUpd);
        }
        
    }
}