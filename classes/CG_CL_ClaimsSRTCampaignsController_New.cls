/*
 * Block comments with details of changes
 */
public class CG_CL_ClaimsSRTCampaignsController_New
{

    
    //public List<srtWrapper> diagList{get;set;}
    public srtWrapper srtCamp;
    @TestVisible
    Transient List<CSS_Srt__c> SRTList = new List<CSS_Srt__c>();
    public List<CSS_Claims__c> claimsRecList {get; set;}
    public decimal totalDecimalTimeCamp{get;set;}
    public decimal totalDecimalTimeAccTot{get;set;}
    public list<sortWrapper> campListWrap{get;set;}

    public decimal totalDecimalTimeAtc{get;set;}
    public decimal totalDecimalTimeAccTotAtc{get;set;}
    public list<sortWrapper> atcListWrap{get;set;}

    public decimal totalDecimalTimeTrp{get;set;}
    public decimal totalDecimalTimeAccTotTrp{get;set;}
    public list<sortWrapper> trpListWrap{get;set;}

    public ID CID{get;set;}
    public Boolean isAutomatedClaim{get;set;}
    //---#171837 dealer and distributor can't able to edit by Sneha ---//
    public Boolean canEdit{get;set;}
    public Boolean isDealer{get;set;}
    public boolean checklaborrate{get;set;}
    public Boolean PenaltyExists{get;set;}
    public Map<string,string> pwPenaltyMap; //Added as per story 180325
    public Map<string,string> pwPenaltyAccCodeMap; //Added as per story 180325
    public Boolean isFieldActionSRTCovered{get;set;}
    public Map<id,List<SelectOption>> mapaccesscode{get;set;}//Added as part of the story#172627
    User usr = css_utility.getUserAttributes(userinfo.getUserId());
    string userRole = usr.UserRoleName__c;
    public List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
    //public Set<String> accSetPW{get;set;}
    public Set<String> accSet{get;set;}
    public Boolean isCatastrophic{get;
                                  set{
                                      isCatastrophic = value;

                                      if (isCatastrophic == true && isDealer == true && !userRole.contains('Factory')){
                                          canEdit = false;
                                          System.debug('line 35 canEdit***'+canEdit);
                                      } 
                                      if(isCatastrophic == false || isDealer == false || userRole.contains('Factory')){
                                          canEdit = true;
                                          System.debug('line 39 canEdit****'+canEdit);
                                      }
                                  }
                                 }
    //---#171837--END---//
    
    
    public CG_CL_ClaimsSRTs mainContr{get;
                                        set{
                                            mainContr = value;
                                        }}
    public String sVfComp;
    public void setsVfComp(String argId){
        sVfComp = argId; 
        //System.debug('The value of svfComp is'+sVfComp);

    } 
    public String getsVfComp(){
        return sVfComp; 
    }

    public string selSRTID{get;set;}
    public string selCoveredVal{get;set;}
    public String EquipmentId;

    public CG_CL_ClaimsSRTCampaignsController_New(){
        try{
            isFieldActionSRTCovered = true;
            System.debug('Kalpana***');
            isAutomatedClaim = false;
            checklaborrate=true;
            mapaccesscode = new map<id,list<selectoption>>();
            //decimal timecamp=0.0;
            //decimal campAccTime=0.0;
            CID=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('cid***'+CID);
            if(CID!=null){

                claimsRecList = new List<CSS_Claims__c>([Select Id ,Name, Dealer_Service_Job__c,Total_PSN_Count__c ,CSS_Job__c,SP_INSHOP_LABOR_RATE__c, IsDealerCreatedClaim__c, Catastrophic__c,ODM_Penalty__c,Information_Only_Claim__c,
                                                         (select id,Equipment_ID__c from CSS_PSNs__r) from CSS_Claims__c where Id=:CID]);
system.debug('claimsRecList'+ claimsRecList);
                EquipmentId = claimsRecList[0].CSS_PSNs__r[0].Equipment_ID__c;

                system.debug('EquipmentId' + EquipmentId);

                if(claimsRecList !=null && claimsRecList.size()>0){
                    if(claimsRecList[0].CSS_Job__c !=null || claimsRecList[0].Dealer_Service_Job__c!=null)
                        isAutomatedClaim = true;
                    system.debug('claimsRecList[0].SP_INSHOP_LABOR_RATE__c'+claimsRecList[0].SP_INSHOP_LABOR_RATE__c);

                    if(string.isBlank(claimsRecList[0].SP_INSHOP_LABOR_RATE__c) || (string.isNotBlank(claimsRecList[0].SP_INSHOP_LABOR_RATE__c) && double.valueOf(claimsRecList[0].SP_INSHOP_LABOR_RATE__c)==0))
                    {
                        checklaborrate=false;
                        system.debug('Test Labor'+checklaborrate);
                    }    
                    //story 155910 Added below condition
                    if(claimsRecList[0].Information_Only_Claim__c == false && claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '' && integer.valueof(claimsRecList[0].ODM_Penalty__c) > 0)
                        PenaltyExists = true;
                }

                /* SRTList = [select Calculated_Claimed_Hours__c,Extended_Hours__c,CSS_Claims__c,CSS_Claims__r.AccessCode__c,name,SRT_ID__c,Repair_Access_Calculated__c,Additional_SRT_Calculated__c,Diagnosis_Time__c,SRT_Decimal_Time__c,id,step_id__c,SRT_Time__c,Component_Id__c ,Type__c,Response_Message__c ,Repair_Time__c,Access_Code_A__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__r.Name,Solution_Number__r.Diagnostic_Response__c,Assignment__c,SRT_Status_Message__c,SRT_Title__c ,isPerformed__c,SRT_Quantity__c,SRT_Notes__c ,SRT_Warrantable__c,
                           Access_Code_B__c,Account_Code__c,FailCode__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Access_Code_S1__c,Access_Code_S2__c,Access_Code_S3__c,Access_Code_S4__c,Access_Code_S5__c,Access_Code_S6__c,Access_Code_S7__c,Access_Code_S8__c,Access_Code_S9__c,S1_Description__c,S2_Description__c,S3_Description__c,S4_Description__c,Diag_Access_Time__c,
                           S5_Description__c,srt_category__c,IsPopUpSRT__c,Symptom_Name__c,Fault_Code_Name__c,SRT_Access_Code__c,Access_Code__c,S6_Description__c,S7_Description__c,S8_Description__c,S9_Description__c,Special_Access_Code__c,Special_Access_Code_Desc__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code_Saved__c,Claimed_Hours__c,srt_type__c from CSS_SRT__c where css_claims__c =:CID order by SRT_Order__c asc];*/
                SRTList = [select id,step_id__c,Access_Code__c,Access_Code_A__c,Component_Id__r.CSS_Failure_Sequence_Number__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Job_Engine_Access_Code__c,SRT_Warrantable__c,Account_Code__c,AccountCode_Formula__c,FailCode__c,name,SRT_ID__c,type__c,srt_type__c,Additional_SRT_Calculated__c,SRT_Time__c,SRT_AccessiblityCheck__c,Assignment__c,SRT_Status_Message__c,SRT_Title__c ,isPerformed__c,SRT_Quantity__c,SRT_Notes__c ,srt_category__c,IsPopUpSRT__c,Extended_Hours__c,SRT_Order__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,Step_Description__c,
                           SRT_Access_Code__c,Flex_Flag__c,SRT_Time_Formula__c,FieldAction_Time__c,Diagnosis_Time__c,Diag_Access_Time__c,Component_Id__c,Component_Id__r.Selected_Component__c,Component_Id__r.Component_Id__c,Component_Id__r.Campaign_Description__c,CSS_Claims__c,isUserEntered__c,css_claims__r.AccessCode__c,Component_Id__r.type__c from CSS_SRT__c where css_claims__c =:CID AND (Assignment__c != 'NOT CLAIMABLE' AND Assignment__c !='UNLISTED' ) order by Component_Id__r.CSS_Failure_Sequence_Number__c,CSS_AssignmentOrder__c,SRT_ID__c asc]; //AND ((Component_Id__c != null AND Component_Id__r.Selected_Component__c = true) OR Component_Id__c = null) - Removed this condition as part of the defect # 190891
                system.debug('SRTList'+SRTList);
                List<CSS_SRT__c> srtTempLst1 = new List<CSS_SRT__c>();
                List<CSS_SRT__c> srtTempLst2 = new List<CSS_SRT__c>();
                for(CSS_SRT__c srt: SRTList){
                    if(srt.Component_Id__c != null){
                        srtTempLst1.add(srt);
                    }
                    else{
                        srtTempLst2.add(srt);
                    }
                }
                SRTList = new List<CSS_SRT__c>();
                SRTList.addAll(srtTempLst1);
                SRTList.addAll(srtTempLst2);
                system.debug('SRTList***'+SRTList);
            }
            getallCampSRTs();
            getallatcSRTs();
            getalltrpSRTs();

            //Kalpana story 155910
            //system.debug('jobEventTemp@@@'+jobEventTemp);
            //jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' and Attribute1__c IN ('POL','NPW','RPW')];
            jobEventTemp = css_utility.getJobEventTempPolicy();
            accSet = new Set<String>();
            Set<String> accSetPW = new Set<String>();
            pwPenaltyMap = new Map<string,string>();
            pwPenaltyAccCodeMap = new Map<string,string>();
            string failurePenalty;
            if(jobEventTemp != null && !jobEventTemp.isEmpty()){
                for(CSS_JobEventTemporary__c JET: jobEventTemp){
                    if(JET.Attribute1__c == 'POL'){
                        accSet.add(JET.Attribute2__c+' '+JET.Attribute3__c);
                    }
                    else if(JET.Attribute1__c == 'NPW' || JET.Attribute1__c ==  'RPW'){
                        accSetPW.add(JET.Attribute2__c+' '+JET.Attribute3__c);
                    }
                }
            }
            system.debug('accSet***'+accSet);
            system.debug('accSetPW***'+accSetPW);
            //Story 180325 -- START
            /*Commented below code after including NPW, RPW in above logic to avoid reduce 1 query
            List<CSS_JobEventTemporary__c> jobEventTempPW = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' and Attribute1__c IN ('NPW','RPW')];
            Set<String> accSetPW = new Set<String>();
            pwPenaltyMap = new Map<string,string>();
            pwPenaltyAccCodeMap = new Map<string,string>(); //Added as per story 180325
            string failurePenalty;
            if(jobEventTempPW != null && jobEventTempPW.size()>0){
                for(CSS_JobEventTemporary__c JET: jobEventTempPW){
                    accSetPW.add(JET.Attribute2__c+' '+JET.Attribute3__c);
                }
            }
            system.debug('accSetPW**'+accSetPW);*/
            List<CSS_Solution_Component__c> solCompList = [select id,fail_code__c,FailCode_Formula__c,ODM_Penalty__c,CSS_Account_Formula__c from css_solution_component__C where css_claims__c = :cId];
            for(CSS_Solution_Component__c sc:solCompList){
                system.debug('ODM_Penalty__c****--'+sc.ODM_Penalty__c);
                system.debug('sc.CSS_Account_Formula__c****--'+sc.CSS_Account_Formula__c);
                system.debug('accSetPW*****' + accSetPW);
                if(sc.ODM_Penalty__c != null && sc.ODM_Penalty__c != '' && integer.valueof(sc.ODM_Penalty__c) > 0 && (sc.CSS_Account_Formula__c != null && sc.CSS_Account_Formula__c != '') && accSetPW.contains(sc.CSS_Account_Formula__c.trim()))
                    pwPenaltyMap.put(sc.fail_code__c+sc.CSS_Account_Formula__c,sc.ODM_Penalty__c);
                pwPenaltyAccCodeMap.put(sc.fail_code__c+sc.CSS_Account_Formula__c,sc.ODM_Penalty__c);
            }
            //Story 180325 -- END
            system.debug('campListWrap'+campListWrap);
            system.debug('atcListWrap'+atcListWrap);
            system.debug('trpListWrap'+trpListWrap);
            if((campListWrap != null && campListWrap.size() > 0) || (atcListWrap != null && atcListWrap.size() > 0) || (trpListWrap != null && trpListWrap.size() > 0)){
                isFieldActionSRTCovered = true;
            }
            else{
                CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
                List<Boolean> coverageResult = new List<Boolean>();
                coverageResult = contr.checkFailuresCovered(Cid, false);
                system.debug('coverageResult--'+coverageResult);
                isFieldActionSRTCovered = coverageResult[4];
                system.debug('isFieldActionSRTCovered--'+isFieldActionSRTCovered);
            }
        }
        catch(Exception e){
            System.debug('The error in Campaignsrt is'+e.getMessage()+e.getLineNumber());
        }

    }

    public void SRTPercReqFA(){
        system.debug('inPercentReq**'+selCoveredVal);
        system.debug('inPercentReq1**'+selSRTID);
        String failurePenalty;
        if(campListWrap != null && !campListWrap.isEmpty()){
            for(sortwrapper srt:campListWrap){
                if(selSRTID == srt.srtRec.srtID){
                    system.debug('inPercentReq**'+srt.srtRec.accountcode);
                    system.debug('inPercentReq2**'+srt.srtRec.percentCov);
                    system.debug('accSet**'+accSet);
                    //Story 180325 added below pwPenaltyMap code
                    srt.srtRec.isUserEntered=true;
                    if(pwPenaltyMap != null && pwPenaltyMap.size() > 0 && (srt.srtRec.accountcode != null && srt.srtRec.accountcode != '') && claimsRecList[0].Information_Only_Claim__c==false){
                        if(srt.srtRec.failcode != null && srt.srtRec.failcode != '')
                            failurePenalty = pwPenaltyMap.get(srt.srtRec.failcode.trim()+srt.srtRec.AccountCode.trim());
                        else
                            failurePenalty = pwPenaltyAccCodeMap.get(srt.srtRec.AccountCode.trim());
                        if(failurePenalty != null && failurePenalty != '' && (((srt.srtRec.percentCov != null && srt.srtRec.percentCov != '') && integer.valueof(srt.srtRec.percentCov)>integer.valueof(failurePenalty)) || (srt.srtRec.percentCov == null || srt.srtRec.percentCov == ''))){
                            srt.srtRec.percentCov = failurePenalty;

                        }
                    }
                    else if(claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '' && integer.valueof(claimsRecList[0].ODM_Penalty__c) > 0){
                        if(srt.srtRec.AccountCode != null && srt.srtRec.AccountCode != '' && accSet != null && !accSet.contains(srt.srtRec.AccountCode) && claimsRecList[0].Information_Only_Claim__c==false){

                            if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                            {srt.srtRec.percentCov = selCoveredVal;}
                            else 
                            {srt.srtRec.percentCov = claimsRecList[0].ODM_Penalty__c;srt.srtRec.isUserEntered=false;}
                        }
                        else if(srt.srtRec.AccountCode == null || srt.srtRec.AccountCode == '' && claimsRecList[0].Information_Only_Claim__c==false){
                            if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                            { srt.srtRec.percentCov = selCoveredVal;}
                            else 
                            {srt.srtRec.percentCov = claimsRecList[0].ODM_Penalty__c;srt.srtRec.isUserEntered=false;}

                        }

                        else if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) >= 100)
                        {srt.srtRec.percentCov = string.valueof(100);srt.srtRec.isUserEntered=false;}

                    }
                    else if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) >= 100)
                    {srt.srtRec.percentCov = string.valueof(100);srt.srtRec.isUserEntered=false;}
                    // break;
                }
            }
        }
        if(trpListWrap != null && !trpListWrap.isEmpty()){
            for(sortwrapper srt:trpListWrap){
                if(selSRTID == srt.srtRec.srtID){
                    system.debug('trpAccCode**'+srt.srtRec.accountcode);
                    system.debug('trppercCov**'+srt.srtRec.percentCov);
                    system.debug('trpaccSet**'+accSet);
                    //Story 180325 added below pwPenaltyMap code
                    if(pwPenaltyMap != null && pwPenaltyMap.size() > 0 && (srt.srtRec.accountcode != null && srt.srtRec.accountcode != '') && claimsRecList[0].Information_Only_Claim__c==false){
                        if(srt.srtRec.failcode != null && srt.srtRec.failcode != '')
                            failurePenalty = pwPenaltyMap.get(srt.srtRec.failcode.trim()+srt.srtRec.AccountCode.trim());
                        else
                            failurePenalty = pwPenaltyAccCodeMap.get(srt.srtRec.AccountCode.trim());
                        if(failurePenalty != null && failurePenalty != '' && (((srt.srtRec.percentCov != null && srt.srtRec.percentCov != '') && integer.valueof(srt.srtRec.percentCov)>integer.valueof(failurePenalty)) || (srt.srtRec.percentCov == null || srt.srtRec.percentCov == ''))){
                            srt.srtRec.percentCov = failurePenalty;

                        }
                    }
                    else if(claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '' && integer.valueof(claimsRecList[0].ODM_Penalty__c) > 0){
                        if(srt.srtRec.AccountCode != null && srt.srtRec.AccountCode != '' && accSet != null && !accSet.contains(srt.srtRec.AccountCode) && claimsRecList[0].Information_Only_Claim__c==false){

                            if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                            {srt.srtRec.percentCov = selCoveredVal;srt.srtRec.isUserEntered=true;}
                            else 
                                srt.srtRec.percentCov = claimsRecList[0].ODM_Penalty__c;
                        }
                        else if(srt.srtRec.AccountCode == null || srt.srtRec.AccountCode == '' && claimsRecList[0].Information_Only_Claim__c==false){
                            if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                            {srt.srtRec.percentCov = selCoveredVal;srt.srtRec.isUserEntered=true;}
                            else 
                                srt.srtRec.percentCov = claimsRecList[0].ODM_Penalty__c;

                        }

                        else if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) >= 100)
                            srt.srtRec.percentCov = string.valueof(100);

                    }
                    else if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) >= 100)
                        srt.srtRec.percentCov = string.valueof(100);
                    // break;
                }
            }
        }
        if(atcListWrap != null && !atcListWrap.isEmpty()){  
            for(sortwrapper srt:atcListWrap){
                if(selSRTID == srt.srtRec.srtID){
                    system.debug('atcAccCode**'+srt.srtRec.accountcode);
                    system.debug('atcPercCov**'+srt.srtRec.percentCov);
                    system.debug('atcaccSet**'+accSet);
                    //Story 180325 added below pwPenaltyMap code
                    if(pwPenaltyMap != null && pwPenaltyMap.size() > 0 && (srt.srtRec.accountcode != null && srt.srtRec.accountcode != '') && claimsRecList[0].Information_Only_Claim__c==false){
                        if(srt.srtRec.failcode != null && srt.srtRec.failcode != '')
                            failurePenalty = pwPenaltyMap.get(srt.srtRec.failcode.trim()+srt.srtRec.AccountCode.trim());
                        else
                            failurePenalty = pwPenaltyAccCodeMap.get(srt.srtRec.AccountCode.trim());
                        if(failurePenalty != null && failurePenalty != '' && (((srt.srtRec.percentCov != null && srt.srtRec.percentCov != '') && integer.valueof(srt.srtRec.percentCov)>integer.valueof(failurePenalty)) || (srt.srtRec.percentCov == null || srt.srtRec.percentCov == ''))){
                            srt.srtRec.percentCov = failurePenalty;
                        }
                    }
                    else if(claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '' && integer.valueof(claimsRecList[0].ODM_Penalty__c) > 0){
                        if(srt.srtRec.AccountCode != null && srt.srtRec.AccountCode != '' && accSet != null && !accSet.contains(srt.srtRec.AccountCode) && claimsRecList[0].Information_Only_Claim__c==false){

                            if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                            {srt.srtRec.percentCov = selCoveredVal;srt.srtRec.isUserEntered=true;}
                            else 
                                srt.srtRec.percentCov = claimsRecList[0].ODM_Penalty__c;
                        }
                        else if(srt.srtRec.AccountCode == null || srt.srtRec.AccountCode == '' && claimsRecList[0].Information_Only_Claim__c==false){
                            if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                            {srt.srtRec.percentCov = selCoveredVal;srt.srtRec.isUserEntered=true;}
                            else 
                                srt.srtRec.percentCov = claimsRecList[0].ODM_Penalty__c;

                        }

                        else if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) >= 100)
                            srt.srtRec.percentCov = string.valueof(100);

                    }
                    else if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) >= 100)
                        srt.srtRec.percentCov = string.valueof(100);
                    // break;
                }
            }
        }
    }

    public class srtWrapper{
        public id sid{get;set;}
        public string compId{get;set;}
        public string compDescription{get;set;}
        public string srtType{get;set;}
        public string AccessCode{get;set;}
        public string jobAccesscode{get;set;}
        public string accesscodeR{get;set;}
        public string accesscodeA{get;set;}
        public string accesscodeB{get;set;}
        public string accesscodeC{get;set;}
        public string accesscodeD{get;set;}
        public string accountcode{get;set;}
        public string srtDescription{get;set;}
        public decimal quantity{get;set;}
        public string srtID{get;set;}
        public decimal srtTime{get;set;}
        public decimal srtAccessTime{get;set;}
        public boolean selectedRecord{get;set;}
        public string accTime{get;set;}
        public decimal accTimeDec{get;set;} 
        public decimal ClaimedHrs{get;set;}
        public boolean IsPopUpSRT{get;set;}
        public decimal sortOrder{get;set;}
        public boolean srtCheckBox{get;set;}
        public boolean accessSrtCheckBox{get;set;}
        public string percentCov{get;set;}
        public string failcode; //Added as per story 180325
        public Boolean accessCodeFlag{get;set;}
        public Boolean percentReqFlag{get;set;}
        public string StepId {get;set;}
        public string StepDescription{get;set;}
        public Boolean flexFlag{get;set;}
        public boolean isUserEntered{get;set;}
        public srtWrapper(){
            this.compId = compId;
        }
    }

    public class sortWrapper implements Comparable{
        public srtWrapper srtRec{get;set;}
        // public boolean selectedRecord{get;set;}

        //constructor
        public sortWrapper(srtWrapper srtRec){
            this.srtRec = srtRec;
            //this.selectedRecord = false;
        }

        public Integer compareTo(Object ObjToCompare) {
            //sortWrapper srtRec = (sortWrapper)(obj);
            system.debug('srtRec--->'+srtRec);
            if(srtRec.sortOrder == null){
                if(((sortWrapper)ObjToCompare).srtRec.sortOrder == null)
                    return 0; //equal
                else
                    return -1; // null is before other strings
            }
            else // this.member != null
            {

                if(((sortWrapper)ObjToCompare).srtRec.sortOrder == null)
                    return 1;  // all other strings are after null
                else
                    return integer.valueOf(srtRec.sortOrder - ((sortWrapper)ObjToCompare).srtRec.sortOrder);
            }
        }
    }

    public void getallCampSRTs(){
        decimal timecamp=0.0;
        decimal campAccTime=0.0;
        system.debug('InsideCamp Method**');
        system.debug('SRTList**'+SRTList);

        if(SRTList!=null && !SRTList.isEmpty()){
            system.debug('InsideCamp IF**');
            //system.debug('srt.Type__c**'+srt.Type__c+'srt.srt_category__c'+srt.srt_category__c+'srt.Component_Id__r.type__c'+srt.Component_Id__r.type__c);
            campListWrap= new list<sortWrapper>();
            for(CSS_SRT__c srt:SRTList){

                //Below code added for the story#172627
                if(!mapaccesscode.containsKey(srt.id))
                    mapaccesscode.put(srt.id, new list<selectoption>());
                //end
                system.debug('srt.Type__c**'+srt.Type__c+'srt.srt_category__c'+srt.srt_category__c+'srt.Component_Id__r.type__c'+srt.Component_Id__r.type__c);
                //if((srt.Type__c.equalsIgnoreCase('Field Action') || srt.Type__c.equalsIgnoreCase('Field Action Access')) && (srt.srt_category__c == null || srt.srt_category__c == '') && srt.srt_type__c == 'Campaign'){
                if((srt.Type__c != null && srt.Type__c != '' && srt.Type__c.equalsIgnoreCase('Field Action') && (srt.srt_category__c == null || srt.srt_category__c == '') && srt.srt_type__c == 'Campaign')
                   || (srt.Type__c != null && srt.Type__c != '' && srt.Type__c.equalsIgnoreCase('Field Action Access') && srt.Component_Id__r.type__c == 'Campaign')){
                    system.debug('InsideCamp IF1**');
                    srtCamp = new srtWrapper();
                    srtCamp.sId = srt.Id;
                    srtCamp.compId = srt.Component_Id__r.Component_Id__c+'-'+srt.Component_Id__r.Campaign_Description__c;
                    srtCamp.srtType = srt.Type__c;



                    If( srt.Job_Engine_Access_Code__c!=null && srt.Job_Engine_Access_Code__c!='R' && (srt.Access_Code_A__c==0 && srt.Access_Code_B__c==0 && srt.Access_Code_C__c==0 && srt.Access_Code_D__c==0 ) && srt.Access_Code_R__c!=0)
                        srtCamp.jobAccesscode = 'R';
                    else
                        srtCamp.jobAccesscode = srt.Job_Engine_Access_Code__c;
                    //Code added for story#172627
                    if(srt.Access_Code__c == null || srt.Access_Code__c == '' || string.isBlank(srt.Access_Code__c))
                    {
                        srtCamp.AccessCode  = srt.SRT_Access_Code__c;
                        srt.Access_Code__c = srt.SRT_Access_Code__c;
                    }
                    else
                    {
                        srtCamp.AccessCode  = srt.Access_Code__c;
                    }  
                    CG_UtilityForSRT srtcampaccesscodecls = new CG_UtilityForSRT();
                    list<selectoption> campAccesscodetmp= srtcampaccesscodecls.getAccesscodeclaimoption(string.valueOf(srt.Access_Code_A__c),string.valueOf(srt.Access_Code_B__c),string.valueOf(srt.Access_Code_C__c),string.valueOf(srt.Access_Code_D__c),string.valueOf(srt.Access_Code_R__c),srt.CSS_Claims__r.AccessCode__c,srt.SRT_Access_Code__c,'RepairOrFA',srt.IsPopUpSRT__c);
                    if(campAccesscodetmp.size()>0)
                        mapaccesscode.put(srt.Id,campAccesscodetmp);
                    //end
                    srtCamp.accesscodeR  = string.valueOf(srt.Access_Code_R__c); 
                    srtCamp.accesscodeA  = string.valueOf(srt.Access_Code_A__c);
                    srtCamp.accesscodeB  = string.valueOf(srt.Access_Code_B__c);
                    srtCamp.accesscodeC  = string.valueOf(srt.Access_Code_C__c);
                    srtCamp.accesscodeD  = string.valueOf(srt.Access_Code_D__c);
                    srtCamp.accountcode = srt.AccountCode_Formula__c; //srt.Account_Code__c;
                    srtCamp.srtID = srt.SRT_ID__c;
                    srtCamp.srtDescription = srt.SRT_Title__c;
                    srtCamp.Quantity = srt.SRT_Quantity__c;
                    srtCamp.ClaimedHrs = srt.Extended_Hours__c;
                    srtCamp.IsPopUpSRT = srt.IsPopUpSRT__c;
                    srtCamp.sortOrder =srt.SRT_Order__c;
                    srtCamp.flexFlag = srt.Flex_Flag__c;
                    srtCamp.accessCodeFlag = srt.Access_Code_Flag__c != null && srt.Access_Code_Flag__c ==true ? true : false;
                    srtCamp.percentReqFlag = srt.SRT_Warrantable_Flag__c != null && srt.SRT_Warrantable_Flag__c ==true ? true : false;

                    if(string.isNotBlank(srt.SRT_Warrantable__c))
                        srtCamp.percentCov = srt.SRT_Warrantable__c;
                    //else
                    //srtCamp.percentCov = string.valueOf(srt.SRT_Hours_Percentage__c);

                    srtCamp.failcode = srt.FailCode__c; //Added as per story 180325, to apply failurepenalty based on failcode and accountcode

                    if(srt.Type__c.equalsIgnoreCase('Field Action')){ 
                        //Added as part of story 177350 -kung fu panda sprint
                        // srtCamp.srtCheckBox =  (srt.Assignment__c=='PRIMARY' && srt.Assignment__c!=null );
                        srtCamp.srtCheckBox = srt.isPerformed__c;
                        //srtCamp.srtTime = srt.SRT_Time__c;
                        srtCamp.srtTime = srt.FieldAction_Time__c;
                        //if(srt.isPerformed__c == true)
                        if(srt.Extended_Hours__c!=null && srt.isPerformed__c == true){//Added condition as per defecrt 173620,-by RAJESH 14th Dec 2018
                            timecamp = timecamp + (srt.Extended_Hours__c != null?srt.Extended_Hours__c:0.0); //(srt.SRT_Time__c * srt.SRT_Quantity__c);
                            system.debug('Testing Toal SRT time11***'+timecamp);
                        }    
                    }

                    if(srt.Type__c.equalsIgnoreCase('Field Action Access')){
                        //srtCamp.srtAccessTime = srt.SRT_Time__c;
                        srtCamp.srtAccessTime = srt.FieldAction_Time__c;
                        srtCamp.accessSrtCheckBox = srt.SRT_AccessiblityCheck__c;
                        timecamp = timecamp + (srt.Extended_Hours__c != null?srt.Extended_Hours__c:0.0);//Added as part of defect GSSC-208
                        // if(srt.SRT_AccessiblityCheck__c){
                        //campAccTime = campAccTime + (srt.SRT_Time__c * srt.SRT_Quantity__c);
                        campAccTime = campAccTime + (srt.FieldAction_Time__c * srt.SRT_Quantity__c);
                        system.debug('Testing Toal SRT time***'+campAccTime);
                        //  }
                    }
                    srtCamp.srtTime =srt.SRT_Time_Formula__c; //above srtTime code is not required since this stmnt formula works for all
                    srtCamp.isUserEntered = srt.isUserEntered__c; //183955
                    srtCamp.StepDescription = srt.Step_Description__c; //GSSC-20
                    srtCamp.StepId = srt.Step_Id__c; //GSSC-20
                    system.debug('srtCamp>>>>>>>>>>'+srtCamp);
                    if(srtCamp != null){
                        system.debug('srtCamp>>inside>>>>>>>>>>'+srtCamp);
                        system.debug('isAutomatedClaim'+isAutomatedClaim+'srt.Component_Id__r.Selected_Component__c'+srt.Component_Id__r.Selected_Component__c);
                        if(isAutomatedClaim == true || (srt.Component_Id__r.Selected_Component__c==true && isAutomatedClaim != true))
                            campListWrap.add(new sortWrapper(srtCamp));

                        system.debug('campListWrap>>>'+campListWrap);


                    }
                }


                if((srt.srt_category__c!= null && srt.srt_category__c!= '' && srt.srt_category__c.equalsIgnoreCase('Campaign'))){ 
                    system.debug('InsideCamp IF2**');
                    srtCamp = new srtWrapper();
                    srtCamp.sId = srt.Id;
                    srtCamp.compId = srt.FailCode__c;
                    srtCamp.flexFlag = srt.Flex_Flag__c;
                    //srtCamp.compId = srt.Component_Id__r.Component_Id__c+'-'+srt.Component_Id__r.Campaign_Description__c;
                    srtCamp.srtType = srt.Type__c;


                    If( srt.Job_Engine_Access_Code__c!=null && srt.Job_Engine_Access_Code__c!='R' && (srt.Access_Code_A__c==0 && srt.Access_Code_B__c==0 && srt.Access_Code_C__c==0 && srt.Access_Code_D__c==0 ) && srt.Access_Code_R__c!=0)
                        srtCamp.jobAccesscode = 'R';
                    else
                        srtCamp.jobAccesscode = srt.Job_Engine_Access_Code__c;
                    //Code added for story#172627
                    if(srt.Access_Code__c == null || srt.Access_Code__c == '')
                    {
                        if( srt.Access_Code_A__c==0 && srt.Access_Code_B__c==0 && srt.Access_Code_C__c==0 && srt.Access_Code_D__c==0 && srt.Access_Code_R__c!=0)
                        {
                            srtCamp.AccessCode  = 'R';
                            srt.Access_Code__c ='R';
                        }
                        else
                        {
                            srtCamp.AccessCode  = srt.Job_Engine_Access_Code__c;
                            srt.Access_Code__c =srt.Job_Engine_Access_Code__c;
                        }
                    }
                    else
                    {
                        srtCamp.AccessCode  = srt.Access_Code__c;
                    }

                    CG_UtilityForSRT srtcampaccesscodecls = new CG_UtilityForSRT();
                    list<selectoption> campAccesscodetmp = srtcampaccesscodecls.getAccesscodeclaimoption(string.valueOf(srt.Access_Code_A__c),string.valueOf(srt.Access_Code_B__c),string.valueOf(srt.Access_Code_C__c),string.valueOf(srt.Access_Code_D__c),string.valueOf(srt.Access_Code_R__c),srt.CSS_Claims__r.AccessCode__c,srt.SRT_Access_Code__c,'RepairOrFA',srt.IsPopUpSRT__c);
                    if(campAccesscodetmp.size()>0)
                        mapaccesscode.put(srt.Id,campAccesscodetmp);
                    //end
                    srtCamp.accesscodeR  = string.valueOf(srt.Access_Code_R__c);
                    srtCamp.accesscodeA  = string.valueOf(srt.Access_Code_A__c);
                    srtCamp.accesscodeB  = string.valueOf(srt.Access_Code_B__c);
                    srtCamp.accesscodeC  = string.valueOf(srt.Access_Code_C__c);
                    srtCamp.accesscodeD  = string.valueOf(srt.Access_Code_D__c);
                    srtCamp.accountcode = srt.AccountCode_Formula__c; //srt.Account_Code__c;
                    srtCamp.srtID = srt.SRT_ID__c;
                    srtCamp.srtDescription = srt.SRT_Title__c;
                    srtCamp.Quantity = srt.SRT_Quantity__c;
                    srtCamp.ClaimedHrs = srt.Extended_Hours__c != null?srt.Extended_Hours__c:0.0; // defect 190112
                    srtCamp.IsPopUpSRT = srt.IsPopUpSRT__c;
                    srtCamp.sortOrder =srt.SRT_Order__c;
                    srtCamp.accessCodeFlag = srt.Access_Code_Flag__c != null && srt.Access_Code_Flag__c ==true ? true : false;
                    srtCamp.percentReqFlag = srt.SRT_Warrantable_Flag__c != null && srt.SRT_Warrantable_Flag__c ==true ? true : false;

                    if(string.isNotBlank(srt.SRT_Warrantable__c))
                        srtCamp.percentCov = srt.SRT_Warrantable__c;
                    //else
                    //srtCamp.percentCov = string.valueOf(srt.SRT_Hours_Percentage__c);
                    srtCamp.failcode = srt.FailCode__c; //Added as per story 180325, to apply failurepenalty based on failcode and accountcode
                    if(srt.type__c != null && srt.type__c.containsIgnoreCase('Access')){
                        srtCamp.accessSrtCheckBox = srt.SRT_AccessiblityCheck__c; //new line added
                        srtCamp.srtAccessTime = srt.Additional_SRT_Calculated__c; //srtDiag.srtAccessTime = srt.Diag_Access_Time__c;
                        if(srt.SRT_AccessiblityCheck__c == true){
                            timecamp = timecamp + (srt.Extended_Hours__c != null?srt.Extended_Hours__c:0.0);//Added as part of defect GSSC-208
                            campAccTime = campAccTime+(srt.Additional_SRT_Calculated__c * srt.SRT_Quantity__c);
                        }
                    }
                    if(srt.type__c != null && !srt.type__c.containsIgnoreCase('Access')){  
                        srtCamp.srtCheckBox = srt.isPerformed__c; //new line added
                        //srtCamp.srtCheckBox =  (srt.Assignment__c=='PRIMARY' && srt.Assignment__c!=null );
                        //srtCamp.srtTime = srt.SRT_Time__c; 
                        srtCamp.srtTime =srt.Additional_SRT_Calculated__c;
                        //srtCamp.srtTime = srt.FieldAction_Time__c;
                        if(srt.isPerformed__c == true) 
                            if(srt.Extended_Hours__c!=null){
                                timecamp = timecamp + (srt.Extended_Hours__c != null?srt.Extended_Hours__c:0.0); //(srt.Additional_SRT_Calculated__c * srt.SRT_Quantity__c);
                            }
                    }
                    srtCamp.srtTime =srt.SRT_Time_Formula__c; //above srtTime code is not required since this stmnt formula works for all
                    srtCamp.isUserEntered = srt.isUserEntered__c; //183955
                    srtCamp.StepDescription = srt.Step_Description__c; //GSSC-20
                    srtCamp.StepId = srt.Step_Id__c; //GSSC-20
                    if(srtCamp != null){
                        if(isAutomatedClaim == true || (srt.Component_Id__r.Selected_Component__c==true && isAutomatedClaim != true)){
                            campListWrap.add(new sortWrapper(srtCamp));
                            system.debug('campListWrapAdditionals>>>'+campListWrap);
                        }

                        //Added below for 173609
                        else if(srt.Component_Id__r == null && isAutomatedClaim != true){
                            campListWrap.add(new sortWrapper(srtCamp));
                            system.debug('campListWrapAdditionalsElseIF>>>'+campListWrap); 
                        }
                    }
                }   

            } // for loop
            //campListWrap.sort();
        }   
        if(campListWrap != null && campListWrap.size() > 0)
        {
            totalDecimalTimecamp = timecamp; 
            system.debug('Testing Toal SRT time13***'+totalDecimalTimecamp);
        }
        else
            totalDecimalTimecamp = 0.0; 
        totalDecimalTimeAccTot = campAccTime;

    }

    public void getallatcSRTs(){
        decimal timeatc=0.0;
        decimal atcAccTime=0.0;
        system.debug('InsideATC Method**');
        system.debug('SRTList**'+SRTList);
        if(SRTList!=null && !SRTList.isEmpty()){
            system.debug('InsideCamp IF**');
            atcListWrap= new list<sortWrapper>();
            for(CSS_SRT__c srt:SRTList){


                //if((srt.Type__c.equalsIgnoreCase('Field Action') || srt.Type__c.equalsIgnoreCase('Field Action Access')) && (srt.srt_category__c == null || srt.srt_category__c == '') && srt.srt_type__c == 'ATC'){
                if((srt.Type__c != null && srt.Type__c != '' && srt.Type__c.equalsIgnoreCase('Field Action') && (srt.srt_category__c == null || srt.srt_category__c == '') && srt.srt_type__c == 'ATC')
                   || (srt.Type__c != null && srt.Type__c != '' && srt.Type__c.equalsIgnoreCase('Field Action Access') && srt.Component_Id__r.type__c == 'ATC')){
                    system.debug('InsideCamp IF1**');
                    srtCamp = new srtWrapper();
                    srtCamp.sId = srt.Id;
                    srtCamp.compId = srt.Component_Id__r.Component_Id__c+'-'+srt.Component_Id__r.Campaign_Description__c;
                    srtCamp.srtType = srt.Type__c;


                    If( srt.Job_Engine_Access_Code__c!=null && srt.Job_Engine_Access_Code__c!='R' && (srt.Access_Code_A__c==0 && srt.Access_Code_B__c==0 && srt.Access_Code_C__c==0 && srt.Access_Code_D__c==0 ) && srt.Access_Code_R__c!=0)
                        srtCamp.jobAccesscode = 'R';
                    else
                        srtCamp.jobAccesscode = srt.Job_Engine_Access_Code__c;
                    //Code added for story#172627
                    if(srt.Access_Code__c == null || srt.Access_Code__c == '' || string.isBlank(srt.Access_Code__c))
                    {
                        srtCamp.AccessCode  = srt.SRT_Access_Code__c;
                        srt.Access_Code__c = srt.SRT_Access_Code__c;
                    }
                    else
                    {
                        srtCamp.AccessCode  = srt.Access_Code__c;
                    }  
                    CG_UtilityForSRT srtcampaccesscodecls = new CG_UtilityForSRT();
                    list<selectoption> campAccesscodetmp= srtcampaccesscodecls.getAccesscodeclaimoption(string.valueOf(srt.Access_Code_A__c),string.valueOf(srt.Access_Code_B__c),string.valueOf(srt.Access_Code_C__c),string.valueOf(srt.Access_Code_D__c),string.valueOf(srt.Access_Code_R__c),srt.CSS_Claims__r.AccessCode__c,srt.SRT_Access_Code__c,'RepairOrFA',srt.IsPopUpSRT__c);
                    if(campAccesscodetmp.size()>0)
                        mapaccesscode.put(srt.Id,campAccesscodetmp);
                    //end
                    srtCamp.accesscodeR  = string.valueOf(srt.Access_Code_R__c);
                    srtCamp.accesscodeA  = string.valueOf(srt.Access_Code_A__c);
                    srtCamp.accesscodeB  = string.valueOf(srt.Access_Code_B__c);
                    srtCamp.accesscodeC  = string.valueOf(srt.Access_Code_C__c);
                    srtCamp.accesscodeD  = string.valueOf(srt.Access_Code_D__c);
                    srtCamp.accountcode = srt.AccountCode_Formula__c; //srt.Account_Code__c;
                    srtCamp.srtID = srt.SRT_ID__c;
                    srtCamp.srtDescription = srt.SRT_Title__c;
                    srtCamp.Quantity = srt.SRT_Quantity__c;
                    srtCamp.ClaimedHrs = srt.Extended_Hours__c != null?srt.Extended_Hours__c:0.0; // defect 190112
                    srtCamp.IsPopUpSRT = srt.IsPopUpSRT__c;
                    srtCamp.sortOrder =srt.SRT_Order__c;
                    srtCamp.flexFlag = srt.Flex_Flag__c;
                    srtCamp.accessCodeFlag = srt.Access_Code_Flag__c != null && srt.Access_Code_Flag__c ==true ? true : false; 
                    srtCamp.percentReqFlag = srt.SRT_Warrantable_Flag__c != null && srt.SRT_Warrantable_Flag__c ==true ? true : false;

                    if(string.isNotBlank(srt.SRT_Warrantable__c))
                        srtCamp.percentCov = srt.SRT_Warrantable__c;
                    //else
                    //srtCamp.percentCov = string.valueOf(srt.SRT_Hours_Percentage__c);
                    srtCamp.failcode = srt.FailCode__c; //Added as per story 180325, to apply failurepenalty based on failcode and accountcode
                    if(srt.Type__c.equalsIgnoreCase('Field Action')){ 
                        srtCamp.srtCheckBox = srt.isPerformed__c;

                        // srtCamp.srtCheckBox =  (srt.Assignment__c=='PRIMARY' && srt.Assignment__c!=null );
                        //srtCamp.srtTime = srt.SRT_Time__c;
                        srtCamp.srtTime = srt.FieldAction_Time__c;
                        if(srt.isPerformed__c == true)
                            if(srtCamp.ClaimedHrs!=null)//Added for the defect#185607
                                timeatc = timeatc + srtCamp.ClaimedHrs;//(srt.SRT_Time__c * srt.SRT_Quantity__c);
                    }

                    if(srt.Type__c.equalsIgnoreCase('Field Action Access')){
                        //srtCamp.srtAccessTime = srt.SRT_Time__c;
                        srtCamp.srtAccessTime = srt.FieldAction_Time__c;
                        srtCamp.accessSrtCheckBox = srt.SRT_AccessiblityCheck__c;
                        if(srt.SRT_AccessiblityCheck__c){
                             if(srtCamp.ClaimedHrs!=null)
                                timeatc = timeatc + srtCamp.ClaimedHrs;//Added as part of GSSC-208
                            //atcAccTime = atcAccTime + (srt.SRT_Time__c * srt.SRT_Quantity__c);
                            atcAccTime = atcAccTime + (srt.FieldAction_Time__c * srt.SRT_Quantity__c);
                        }
                    }
                    srtCamp.srtTime =srt.SRT_Time_Formula__c; //above srtTime code is not required since this stmnt formula works for all
                    srtCamp.isUserEntered = srt.isUserEntered__c; //183955
                    srtCamp.StepDescription = srt.Step_Description__c; //GSSC-20
                    srtCamp.StepId = srt.Step_Id__c; //GSSC-20
                    if(srtCamp != null){
                        if(isAutomatedClaim == true || (srt.Component_Id__r.Selected_Component__c==true && isAutomatedClaim != true))
                            atcListWrap.add(new sortWrapper(srtCamp));
                        system.debug('atcListWrap>>>'+atcListWrap);
                    }
                }


                if((srt.srt_category__c!= null && srt.srt_category__c!= '' && srt.srt_category__c.equalsIgnoreCase('ATC'))){ 
                    system.debug('InsideCamp IF2**');
                    srtCamp = new srtWrapper();
                    srtCamp.sId = srt.Id;
                    srtCamp.compId = srt.FailCode__c;
                    //srtCamp.compId = srt.Component_Id__r.Component_Id__c+'-'+srt.Component_Id__r.Campaign_Description__c;
                    srtCamp.srtType = srt.Type__c;
                    srtCamp.flexFlag = srt.Flex_Flag__c;

                    If( srt.Job_Engine_Access_Code__c!=null && srt.Job_Engine_Access_Code__c!='R' && (srt.Access_Code_A__c==0 && srt.Access_Code_B__c==0 && srt.Access_Code_C__c==0 && srt.Access_Code_D__c==0 ) && srt.Access_Code_R__c!=0)
                        srtCamp.jobAccesscode = 'R';
                    else
                        srtCamp.jobAccesscode = srt.Job_Engine_Access_Code__c;
                    //Code added for story#172627
                    if(srt.Access_Code__c == null || srt.Access_Code__c == '')
                    {
                        if( srt.Access_Code_A__c==0 && srt.Access_Code_B__c==0 && srt.Access_Code_C__c==0 && srt.Access_Code_D__c==0 && srt.Access_Code_R__c!=0)
                        {
                            srtCamp.AccessCode  = 'R';
                            srt.Access_Code__c ='R';
                        }
                        else
                        {
                            srtCamp.AccessCode  = srt.Job_Engine_Access_Code__c;
                            srt.Access_Code__c =srt.Job_Engine_Access_Code__c;
                        }
                    }
                    else
                    {
                        srtCamp.AccessCode  = srt.Access_Code__c;
                    }

                    CG_UtilityForSRT srtcampaccesscodecls = new CG_UtilityForSRT();
                    list<selectoption> campAccesscodetmp = srtcampaccesscodecls.getAccesscodeclaimoption(string.valueOf(srt.Access_Code_A__c),string.valueOf(srt.Access_Code_B__c),string.valueOf(srt.Access_Code_C__c),string.valueOf(srt.Access_Code_D__c),string.valueOf(srt.Access_Code_R__c),srt.CSS_Claims__r.AccessCode__c,srt.SRT_Access_Code__c,'RepairOrFA',srt.IsPopUpSRT__c);
                    if(campAccesscodetmp.size()>0)
                        mapaccesscode.put(srt.Id,campAccesscodetmp);
                    //end
                    srtCamp.accesscodeR  = string.valueOf(srt.Access_Code_R__c);
                    srtCamp.accesscodeA  = string.valueOf(srt.Access_Code_A__c);
                    srtCamp.accesscodeB  = string.valueOf(srt.Access_Code_B__c);
                    srtCamp.accesscodeC  = string.valueOf(srt.Access_Code_C__c);
                    srtCamp.accesscodeD  = string.valueOf(srt.Access_Code_D__c);
                    srtCamp.accountcode = srt.AccountCode_Formula__c; //srt.Account_Code__c;
                    srtCamp.srtID = srt.SRT_ID__c;
                    srtCamp.srtDescription = srt.SRT_Title__c;
                    srtCamp.Quantity = srt.SRT_Quantity__c;
                    srtCamp.ClaimedHrs = srt.Extended_Hours__c != null?srt.Extended_Hours__c:0.0; // defect 190112
                    system.debug('srt.Extended_Hours__c'+srt.Extended_Hours__c);
                    srtCamp.IsPopUpSRT = srt.IsPopUpSRT__c;
                    srtCamp.sortOrder =srt.SRT_Order__c;
                    srtCamp.accessCodeFlag = srt.Access_Code_Flag__c != null && srt.Access_Code_Flag__c ==true ? true : false;
                    srtCamp.percentReqFlag = srt.SRT_Warrantable_Flag__c != null && srt.SRT_Warrantable_Flag__c ==true ? true : false;

                    if(string.isNotBlank(srt.SRT_Warrantable__c))
                        srtCamp.percentCov = srt.SRT_Warrantable__c;
                    //else
                    //srtCamp.percentCov =string.valueOf(srt.SRT_Hours_Percentage__c);
                    srtCamp.failcode = srt.FailCode__c; //Added as per story 180325, to apply failurepenalty based on failcode and accountcode
                    if(srt.type__c != null && srt.type__c.containsIgnoreCase('Access')){
                        srtCamp.accessSrtCheckBox = srt.SRT_AccessiblityCheck__c; 
                        srtCamp.srtAccessTime = srt.Additional_SRT_Calculated__c; 
                        if(srt.SRT_AccessiblityCheck__c == true){
                            if(srtCamp.ClaimedHrs!=null){
                                timeatc = timeatc + srtCamp.ClaimedHrs;//Added as part of defect GSSC-208
                            }
                            atcAccTime = atcAccTime+(srt.Additional_SRT_Calculated__c * srt.SRT_Quantity__c);
                        }
                    }
                    if(srt.type__c != null && !srt.type__c.containsIgnoreCase('Access')){    
                        srtCamp.srtCheckBox = srt.isPerformed__c; //new line added
                        //srtCamp.srtCheckBox =  (srt.Assignment__c=='PRIMARY' && srt.Assignment__c!=null );
                        srtCamp.srtTime = srt.Additional_SRT_Calculated__c;
                        if(srt.isPerformed__c == true)
                            if(srtCamp.ClaimedHrs!=null)//Added for the defect#185607
                                timeatc = timeatc + srtCamp.ClaimedHrs;//(srt.Additional_SRT_Calculated__c * srt.SRT_Quantity__c);
                    }
                    srtCamp.srtTime =srt.SRT_Time_Formula__c; //above srtTime code is not required since this stmnt formula works for all
                    srtCamp.isUserEntered = srt.isUserEntered__c; //183955
                    srtCamp.StepDescription = srt.Step_Description__c; //GSSC-20
                    srtCamp.StepId = srt.Step_Id__c; //GSSC-20
                    if(srtCamp != null){
                        if(isAutomatedClaim == true || (srt.Component_Id__r.Selected_Component__c==true && isAutomatedClaim != true)){
                            atcListWrap.add(new sortWrapper(srtCamp));
                            system.debug('atcListWrapAdditionals>>>'+campListWrap);
                        }

                        //Added below for 173609
                        else if(srt.Component_Id__r == null && isAutomatedClaim != true){
                            atcListWrap.add(new sortWrapper(srtCamp));
                            system.debug('atcListWrapAdditionalsElseIF>>>'+campListWrap); 
                        }
                    }
                }   

            } // for loop
            system.debug('Testatc'+atcListWrap);
            //atcListWrap.sort();
        }   



        if(atcListWrap != null && atcListWrap.size() > 0)
            totalDecimalTimeatc = timeatc; 
        else
            totalDecimalTimeatc = 0.0; 
        totalDecimalTimeAccTotAtc = atcAccTime;

    }  

    public void getalltrpSRTs(){
        decimal timetrp=0.0;
        decimal trpAccTime=0.0;
        system.debug('InsideTRP Method**');
        system.debug('SRTList**'+SRTList);
        if(SRTList!=null && !SRTList.isEmpty()){
            system.debug('InsideCamp IF**');
            trpListWrap= new list<sortWrapper>();
            for(CSS_SRT__c srt:SRTList){

                system.debug('InsideCamp IF11**'+srt);
                //if((srt.Type__c.equalsIgnoreCase('Field Action') || srt.Type__c.equalsIgnoreCase('Field Action Access')) && (srt.srt_category__c == null || srt.srt_category__c == '') && srt.srt_type__c == 'TRP'){
                if((srt.Type__c != null && srt.Type__c != '' && srt.Type__c.equalsIgnoreCase('Field Action') && (srt.srt_category__c == null || srt.srt_category__c == '') && srt.srt_type__c == 'TRP')
                   || (srt.Type__c != null && srt.Type__c != '' && srt.Type__c.equalsIgnoreCase('Field Action Access') && srt.Component_Id__r.type__c == 'TRP')){
                    system.debug('InsideCamp IF1**'+srt);
                    srtCamp = new srtWrapper();
                    srtCamp.sId = srt.Id;
                    srtCamp.compId = srt.Component_Id__r.Component_Id__c+'-'+srt.Component_Id__r.Campaign_Description__c;
                    srtCamp.srtType = srt.Type__c;
                    srtCamp.flexFlag = srt.Flex_Flag__c;


                    If( srt.Job_Engine_Access_Code__c!=null && srt.Job_Engine_Access_Code__c!='R' && (srt.Access_Code_A__c==0 && srt.Access_Code_B__c==0 && srt.Access_Code_C__c==0 && srt.Access_Code_D__c==0 ) && srt.Access_Code_R__c!=0)
                        srtCamp.jobAccesscode = 'R';

                    else
                        srtCamp.jobAccesscode = srt.Job_Engine_Access_Code__c;
                    //Code added for story#172627
                    if(srt.Access_Code__c == null || srt.Access_Code__c == '' || string.isBlank(srt.Access_Code__c))
                    {
                        srtCamp.AccessCode  = srt.SRT_Access_Code__c;
                        srt.Access_Code__c = srt.SRT_Access_Code__c;
                    }
                    else
                    {
                        srtCamp.AccessCode  = srt.Access_Code__c;
                    }  
                    CG_UtilityForSRT srtcampaccesscodecls = new CG_UtilityForSRT();
                    list<selectoption> campAccesscodetmp= srtcampaccesscodecls.getAccesscodeclaimoption(string.valueOf(srt.Access_Code_A__c),string.valueOf(srt.Access_Code_B__c),string.valueOf(srt.Access_Code_C__c),string.valueOf(srt.Access_Code_D__c),string.valueOf(srt.Access_Code_R__c),srt.CSS_Claims__r.AccessCode__c,srt.SRT_Access_Code__c,'RepairOrFA',srt.IsPopUpSRT__c);
                    if(campAccesscodetmp.size()>0)
                        mapaccesscode.put(srt.Id,campAccesscodetmp);
                    //end
                    srtCamp.accesscodeR  = string.valueOf(srt.Access_Code_R__c);
                    srtCamp.accesscodeA  = string.valueOf(srt.Access_Code_A__c);
                    srtCamp.accesscodeB  = string.valueOf(srt.Access_Code_B__c);
                    srtCamp.accesscodeC  = string.valueOf(srt.Access_Code_C__c);
                    srtCamp.accesscodeD  = string.valueOf(srt.Access_Code_D__c);
                    system.debug('Test Accountcode1***'+srt.AccountCode_Formula__c);
                    srtCamp.accountcode = srt.AccountCode_Formula__c; //srt.Account_Code__c;
                    system.debug('Test Accountcode***'+srtCamp.accountcode);
                    srtCamp.srtID = srt.SRT_ID__c;
                    srtCamp.srtDescription = srt.SRT_Title__c;
                    srtCamp.Quantity = srt.SRT_Quantity__c;
                    //srtCamp.ClaimedHrs = srt.Extended_Hours__c;
                    srtCamp.ClaimedHrs = srt.Extended_Hours__c != null?srt.Extended_Hours__c:0.0;
                    srtCamp.IsPopUpSRT = srt.IsPopUpSRT__c;
                    srtCamp.sortOrder =srt.SRT_Order__c;
                    srtCamp.accessCodeFlag = srt.Access_Code_Flag__c != null && srt.Access_Code_Flag__c ==true ? true : false;
                    srtCamp.percentReqFlag = srt.SRT_Warrantable_Flag__c != null && srt.SRT_Warrantable_Flag__c ==true ? true : false;

                    if(string.isNotBlank(srt.SRT_Warrantable__c))
                        srtCamp.percentCov = srt.SRT_Warrantable__c;
                    //else
                    //srtCamp.percentCov = string.valueOf(srt.SRT_Hours_Percentage__c);
                    srtCamp.failcode = srt.FailCode__c; //Added as per story 180325, to apply failurepenalty based on failcode and accountcode
                    if(srt.Type__c.equalsIgnoreCase('Field Action')){ 
                        srtCamp.srtCheckBox = srt.isPerformed__c;

                        // srtCamp.srtCheckBox =  (srt.Assignment__c=='PRIMARY' && srt.Assignment__c!=null );
                        //srtCamp.srtTime = srt.SRT_Time__c;
                        srtCamp.srtTime = srt.FieldAction_Time__c;
                        system.debug('srtCamp.ClaimedHrs**'+srtCamp.ClaimedHrs);
                        if(srt.isPerformed__c == true)
                            timetrp = timetrp + srtCamp.ClaimedHrs;//(srt.SRT_Time__c * srt.SRT_Quantity__c);
                    }

                    if(srt.Type__c.equalsIgnoreCase('Field Action Access')){
                        //srtCamp.srtAccessTime = srt.SRT_Time__c;
                        srtCamp.srtAccessTime = srt.Additional_SRT_Calculated__c;
                        srtCamp.accessSrtCheckBox = srt.SRT_AccessiblityCheck__c;
                        if(srt.SRT_AccessiblityCheck__c){
                             if(srtCamp.ClaimedHrs !=null){
                                timetrp = timetrp + srtCamp.ClaimedHrs;//Added as part of GSSC-208
                            }
                            trpAccTime = trpAccTime + (srt.Additional_SRT_Calculated__c * srt.SRT_Quantity__c);
                        }
                    }
                    srtCamp.srtTime =srt.SRT_Time_Formula__c; //above srtTime code is not required since this stmnt formula works for all
                    srtCamp.isUserEntered = srt.isUserEntered__c; //183955
                    srtCamp.StepDescription = srt.Step_Description__c; //GSSC-20
                    srtCamp.StepId = srt.Step_Id__c; //GSSC-20
                    if(srtCamp != null){
                        if(isAutomatedClaim == true || (srt.Component_Id__r.Selected_Component__c==true && isAutomatedClaim != true))
                            trpListWrap.add(new sortWrapper(srtCamp));
                        system.debug('trpListWrap>>>'+trpListWrap);
                    }
                }

                //From Popup TRP data start
                if((srt.srt_category__c!= null && srt.srt_category__c!= '' && srt.srt_category__c.equalsIgnoreCase('TRP'))){ 
                    system.debug('InsideCamp IF2**');
                    srtCamp = new srtWrapper();
                    srtCamp.sId = srt.Id;
                    srtCamp.compId = srt.FailCode__c;
                    //srtCamp.compId = srt.Component_Id__r.Component_Id__c+'-'+srt.Component_Id__r.Campaign_Description__c;
                    srtCamp.srtType = srt.Type__c;
                    srtCamp.flexFlag = srt.Flex_Flag__c;


                    If( srt.Job_Engine_Access_Code__c!=null && srt.Job_Engine_Access_Code__c!='R' && (srt.Access_Code_A__c==0 && srt.Access_Code_B__c==0 && srt.Access_Code_C__c==0 && srt.Access_Code_D__c==0 ) && srt.Access_Code_R__c!=0)
                        srtCamp.jobAccesscode = 'R';
                    else
                        srtCamp.jobAccesscode = srt.Job_Engine_Access_Code__c;
                    //Code added for story#172627
                    if(srt.Access_Code__c == null || srt.Access_Code__c == '')
                    {
                        if( srt.Access_Code_A__c==0 && srt.Access_Code_B__c==0 && srt.Access_Code_C__c==0 && srt.Access_Code_D__c==0 && srt.Access_Code_R__c!=0)
                        {
                            srtCamp.AccessCode  = 'R';
                            srt.Access_Code__c ='R';
                        }
                        else
                        {
                            srtCamp.AccessCode  = srt.Job_Engine_Access_Code__c;
                            srt.Access_Code__c =srt.Job_Engine_Access_Code__c;
                        }
                    }
                    else
                    {
                        srtCamp.AccessCode  = srt.Access_Code__c;
                    }

                    CG_UtilityForSRT srtcampaccesscodecls = new CG_UtilityForSRT();
                    list<selectoption> campAccesscodetmp = srtcampaccesscodecls.getAccesscodeclaimoption(string.valueOf(srt.Access_Code_A__c),string.valueOf(srt.Access_Code_B__c),string.valueOf(srt.Access_Code_C__c),string.valueOf(srt.Access_Code_D__c),string.valueOf(srt.Access_Code_R__c),srt.CSS_Claims__r.AccessCode__c,srt.SRT_Access_Code__c,'RepairOrFA',srt.IsPopUpSRT__c);
                    if(campAccesscodetmp.size()>0)
                        mapaccesscode.put(srt.Id,campAccesscodetmp);
                    //end
                    srtCamp.accesscodeR  = string.valueOf(srt.Access_Code_R__c);
                    srtCamp.accesscodeA  = string.valueOf(srt.Access_Code_A__c);
                    srtCamp.accesscodeB  = string.valueOf(srt.Access_Code_B__c);
                    srtCamp.accesscodeC  = string.valueOf(srt.Access_Code_C__c);
                    srtCamp.accesscodeD  = string.valueOf(srt.Access_Code_D__c);
                    srtCamp.accountcode = srt.AccountCode_Formula__c; //srt.Account_Code__c;
                    srtCamp.srtID = srt.SRT_ID__c;
                    srtCamp.srtDescription = srt.SRT_Title__c;
                    srtCamp.Quantity = srt.SRT_Quantity__c;
                    srtCamp.ClaimedHrs = srt.Extended_Hours__c != null?srt.Extended_Hours__c:0.0;
                    srtCamp.IsPopUpSRT = srt.IsPopUpSRT__c;
                    srtCamp.sortOrder =srt.SRT_Order__c;
                    srtCamp.accessCodeFlag = srt.Access_Code_Flag__c != null && srt.Access_Code_Flag__c ==true ? true : false;
                    srtCamp.percentReqFlag = srt.SRT_Warrantable_Flag__c != null && srt.SRT_Warrantable_Flag__c ==true ? true : false;

                    if(string.isNotBlank(srt.SRT_Warrantable__c))
                        srtCamp.percentCov = srt.SRT_Warrantable__c;
                    //else
                    //srtCamp.percentCov = string.valueOf(srt.SRT_Hours_Percentage__c);
                    srtCamp.failcode = srt.FailCode__c; //Added as per story 180325, to apply failurepenalty based on failcode and accountcode
                    if(srt.type__c != null && srt.type__c.containsIgnoreCase('Access')){
                        srtCamp.accessSrtCheckBox = srt.SRT_AccessiblityCheck__c; 
                        srtCamp.srtAccessTime = srt.Additional_SRT_Calculated__c; 
                        if(srt.SRT_AccessiblityCheck__c == true){
                            if(srtCamp.ClaimedHrs !=null){
                                timetrp = timetrp + srtCamp.ClaimedHrs;//Added as part of GSSC-208
                            }
                            trpAccTime = trpAccTime+ (srt.Additional_SRT_Calculated__c * srt.SRT_Quantity__c);
                        }
                    }
                    if(srt.type__c != null && !srt.type__c.containsIgnoreCase('Access')){ 
                        srtCamp.srtCheckBox = srt.isPerformed__c; //new line added

                        // srtCamp.srtCheckBox =  (srt.Assignment__c=='PRIMARY' && srt.Assignment__c!=null );
                        srtCamp.srtTime = srt.Additional_SRT_Calculated__c;
                        if(srt.isPerformed__c == true)
                            if(srtCamp.ClaimedHrs !=null){
                                timetrp = timetrp + srtCamp.ClaimedHrs;//(srt.Additional_SRT_Calculated__c * srt.SRT_Quantity__c);
                            }
                    }
                    srtCamp.srtTime =srt.SRT_Time_Formula__c; //above srtTime code is not required since this stmnt formula works for all
                    srtCamp.isUserEntered = srt.isUserEntered__c; //183955
                    srtCamp.StepDescription = srt.Step_Description__c; //GSSC-20
                    srtCamp.StepId = srt.Step_Id__c; //GSSC-20
                    if(srtCamp != null){
                        if(isAutomatedClaim == true || (srt.Component_Id__r.Selected_Component__c==true && isAutomatedClaim != true)){
                            trpListWrap.add(new sortWrapper(srtCamp));
                            system.debug('trpListWrapAdditionals>>>'+campListWrap);
                        }

                        //Added below for 173609
                        else if(srt.Component_Id__r == null && isAutomatedClaim != true){
                            trpListWrap.add(new sortWrapper(srtCamp));
                            system.debug('trpListWrapAdditionalsElseIF>>>'+campListWrap); 
                        }
                    }
                }   

            } // for loop
            //trpListWrap.sort();
            // }   


        }
        if(trpListWrap != null && trpListWrap.size() > 0)
            totalDecimalTimetrp = timetrp;
        else
            totalDecimalTimetrp = 0.0;
        totalDecimalTimeAccTottrp = trpAccTime;

    } 

    //CAmpaign Methods--- Start---//
    public void changeUpOrder(){
        integer i = 0;
        for(sortWrapper sortwrp : campListWrap){

            if(sortwrp.srtRec.selectedRecord){
                decimal temp;
                if(i != 0){
                    temp = sortwrp.srtRec.sortOrder;
                    sortwrp.srtRec.sortOrder = campListWrap[i-1].srtRec.sortOrder;
                    campListWrap[i-1].srtRec.sortOrder = temp;
                }

            }
            i=i+1;
        }
        campListWrap.sort();

    }

    public void changeDownOrder(){
        system.debug('InsiddeDownSort**');
        integer i = 0;
        for(sortWrapper sortwrp : campListWrap){
            system.debug('InsiddeDownSort1**');
            if(sortwrp.srtRec.selectedRecord){
                decimal temp;
                if(i < campListWrap.size()-1){
                    system.debug('InsiddeDownSort2**');
                    temp = sortwrp.srtRec.sortOrder;
                    sortwrp.srtRec.sortOrder = campListWrap[i+1].srtRec.sortOrder;
                    campListWrap[i+1].srtRec.sortOrder = temp;
                }

            }
            i=i+1;
        }
        campListWrap.sort();
    }
    /*public void getDiagAccessTime(){
        try{
            decimal timediag=0.0;
            for(sortwrapper srt:campListWrap){
                if(srt.srtRec.accessSrtCheckBox == true){
                    if(srt.srtRec.srtType.equalsIgnoreCase('Field Action Access')){
                        timediag = timediag + srt.srtRec.srtAccessTime;
                    }
                }
            }
            system.debug('timediag>>>>>>>>>'+timediag);
            totalDecimalTimeAccTot = timediag;
        }catch(exception e){
            system.debug('Entered into catch block of getDiagAccessTime method in CSS_DARSRT Class'+e.getMessage() + ' ' + e.getLineNumber());
        }
    }Commented as part of GSSC-208*/


    public void getdiagnosisTime(){
        decimal diagTime = 0.0;
        for(sortwrapper srt:campListWrap){
            if(srt.srtRec.srtCheckBox == true || srt.srtRec.accessSrtCheckBox == true){
                    if(srt.srtRec.ClaimedHrs != null)
                        diagTime = diagTime + srt.srtRec.ClaimedHrs;
                }
        }
        totalDecimalTimecamp =  diagTime;

    }
    //CAmpaign Methods--- END---//

    //ATC Methods--- Start---//
    public void changeUpOrderATC(){
        integer i = 0;
        for(sortWrapper sortwrp : atcListWrap){

            if(sortwrp.srtRec.selectedRecord){
                decimal temp;
                if(i != 0){
                    temp = sortwrp.srtRec.sortOrder;
                    sortwrp.srtRec.sortOrder = atcListWrap[i-1].srtRec.sortOrder;
                    atcListWrap[i-1].srtRec.sortOrder = temp;
                }

            }
            i=i+1;
        }
        atcListWrap.sort();

    }

    public void changeDownOrderATC(){

        integer i = 0;
        for(sortWrapper sortwrp : atcListWrap){
            if(sortwrp.srtRec.selectedRecord){
                decimal temp;
                if(i < atcListWrap.size()-1){
                    temp = sortwrp.srtRec.sortOrder;
                    sortwrp.srtRec.sortOrder = atcListWrap[i+1].srtRec.sortOrder;
                    atcListWrap[i+1].srtRec.sortOrder = temp;
                }

            }
            i=i+1;
        }
        atcListWrap.sort();
    }
   /* public void getDiagAccessTimeATC(){
        try{
            decimal timeatc=0.0;
            for(sortwrapper srt:atcListWrap){
                if(srt.srtRec.accessSrtCheckBox == true){
                    if(srt.srtRec.srtType.equalsIgnoreCase('Field Action Access')){
                        timeatc = timeatc + srt.srtRec.srtAccessTime;
                    }
                }
            }
            system.debug('timeatc>>>>>>>>>'+timeatc);
            totalDecimalTimeAccTotAtc = timeatc;
        }catch(exception e){
            system.debug('Entered into catch block of getDiagAccessTime method in CSS_DARSRT Class'+e.getMessage() + ' ' + e.getLineNumber());
        }
    }Commented as part of GSSC-208*/


    public void getdiagnosisTimeATC(){
        decimal atcTime = 0.0;
        for(sortwrapper srt:atcListWrap){
            if(srt.srtRec.srtCheckBox == true || srt.srtRec.accessSrtCheckBox == true){
                    if(srt.srtRec.ClaimedHrs!=null){
                        atcTime = atcTime + srt.srtRec.ClaimedHrs;
                    }  
            }
        }
        totalDecimalTimeatc =  atcTime;

    }
    //ATC  Methods--- END---//

    //TRP Methods--- Start---//
    public void changeUpOrderTRP(){
        integer i = 0;
        for(sortWrapper sortwrp : trpListWrap){

            if(sortwrp.srtRec.selectedRecord){
                decimal temp;
                if(i != 0){
                    temp = sortwrp.srtRec.sortOrder;
                    sortwrp.srtRec.sortOrder = trpListWrap[i-1].srtRec.sortOrder;
                    trpListWrap[i-1].srtRec.sortOrder = temp;
                }

            }
            i=i+1;
        }
        trpListWrap.sort();

    }

    public void changeDownOrderTRP(){
        system.debug('trpListWrap**'+trpListWrap);
        integer i = 0;
        for(sortWrapper sortwrp : trpListWrap){
            system.debug('sortwrp.srtRec.selectedRecord**'+sortwrp.srtRec.selectedRecord);
            if(sortwrp.srtRec.selectedRecord){
                decimal temp;
                if(i < trpListWrap.size()-1){
                    temp = sortwrp.srtRec.sortOrder;
                    sortwrp.srtRec.sortOrder = trpListWrap[i+1].srtRec.sortOrder;
                    trpListWrap[i+1].srtRec.sortOrder = temp;
                }

            }
            i=i+1;
        }
        trpListWrap.sort();
    }
   /* public void getDiagAccessTimeTRP(){
        try{
            decimal timetrp=0.0;
            for(sortwrapper srt:trpListWrap){
                if(srt.srtRec.accessSrtCheckBox == true){
                    if(srt.srtRec.srtType.equalsIgnoreCase('Field Action Access')){
                        timetrp = timetrp + srt.srtRec.srtAccessTime;
                    }
                }
            }
            system.debug('timetrp>>>>>>>>>'+timetrp);
            totalDecimalTimeAccTottrp = timetrp;
        }catch(exception e){
            system.debug('Entered into catch block of getDiagAccessTime method in CSS_DARSRT Class'+e.getMessage() + ' ' + e.getLineNumber());
        }
    }Commented as part of GSSC-208*/


    public void getdiagnosisTimeTRP(){
        decimal trpTime = 0.0;
        for(sortwrapper srt:trpListWrap){
            if(srt.srtRec.srtCheckBox == true || srt.srtRec.accessSrtCheckBox == true){
                    if(srt.srtRec.ClaimedHrs!=null){
                        trpTime = trpTime + srt.srtRec.ClaimedHrs;
                    }    
            }
        }
        totalDecimalTimetrp =  trpTime;

    }
    //TRP Methods--- END---//
    public pageReference saveCampTRPATCData(){
        try{
            system.debug('Inside SAVE**');
            PageReference pageRef;
            list<CSS_SRT__c> updateCampSRTList = new list<CSS_SRT__c>();
            Transient list<CSS_SRT__c> updateAddCampSRTList = new list<CSS_SRT__c>();
            Transient list<CSS_SRT__c> updateTRPSRTList = new list<CSS_SRT__c>();
            Transient list<CSS_SRT__c> updateAddTRPSRTList = new list<CSS_SRT__c>();
            Transient list<CSS_SRT__c> updateATCSRTList = new list<CSS_SRT__c>();
            Transient list<CSS_SRT__c> updateATCRepSRTList = new list<CSS_SRT__c>();
            if(campListWrap != null){
                system.debug('campListWrap**'+campListWrap);
                for(sortwrapper s:campListWrap){
                    if(s.srtRec.sid!=null){

                        CSS_SRT__c srtObj = new CSS_SRT__c();
                        system.debug('Sid**'+s.srtRec.sid);
                        srtObj.Id = s.srtRec.sid;
                        srtObj.SRT_ID__c = s.srtRec.srtID;
                        // srtObj.SRT_Title__c = s.srtRec.SRTDescription;
                        srtObj.SRT_Quantity__c = s.srtRec.Quantity;
                        /* if(s.srtRec.srtType == 'Field Action')
                        srtObj.SRT_Time__c = s.srtRec.srtTime;
                    else 
                        srtObj.SRT_Time__c = s.srtRec.srtAccessTime;*/
                        if(s.srtRec.flexFlag == true){
                            if(s.srtRec.srtType != 'Field Action Access'){
                                srtObj.SRT_Time__c = s.srtRec.srtTime;
                            }
                            else{
                                srtObj.SRT_Time__c = s.srtRec.srtAccessTime;
                            }
                        }
                        srtObj.Access_Code__c = s.srtRec.AccessCode;
                        //srtObj.Adjustment_Reason__c = s.srtRec.AdjustmentReason;
                        //srtObj.SRT_Select__c = s.srtRec.selectedRecord; //commented since not in use
                        //srtObj.type__c = s.srtRec.srtType;
                        //srtObj.FailCode__c = s.srtRec.failCode;
                        // srtObj.Account_Code__c = s.srtRec.accountcode;
                        //srtObj.Extended_Hours__c = s.srtRec.ClaimedHrs;
                        // srtObj.IsPopUpSRT__c = s.srtRec.IsPopUpSRT;
                        srtObj.SRT_Order__c = s.srtRec.sortOrder;
                        system.debug('srtID**'+s.srtRec.srtID);
                        system.debug('AccountCode**'+s.srtRec.AccountCode);
                        system.debug('AccountCode**'+s.srtRec.AccountCode);
                        /* if((s.srtRec.AccountCode != null && s.srtRec.AccountCode != '') && accSet != null && !accSet.Contains(s.srtRec.AccountCode.trim()) && claimsRecList[0].Information_Only_Claim__c==false){
                        if((claimsRecList[0].ODM_Penalty__c!= null && claimsRecList[0].ODM_Penalty__c != '') && (s.srtRec.percentCov != null && s.srtRec.percentCov != '') && integer.valueof(s.srtRec.percentCov) < integer.valueof(claimsRecList[0].ODM_Penalty__c)) 
                        srtObj.isUserEntered__c = true;
                    }
                        if((s.srtRec.AccountCode == null || s.srtRec.AccountCode == '') && claimsRecList[0].Information_Only_Claim__c==false){
                        if((claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '') && (s.srtRec.percentCov != null && s.srtRec.percentCov != '') && integer.valueof(s.srtRec.percentCov) < integer.valueof(claimsRecList[0].ODM_Penalty__c)) 
                        srtObj.isUserEntered__c = true;
                    }*/
                        srtObj.isUserEntered__c = s.srtRec.isUserEntered;
                        srtObj.SRT_Warrantable__c = s.srtRec.percentCov;
                        //srtObj.SRT_Hours_Percentage__c = Decimal.valueof(s.srtRec.percentCov);
                        if(s.srtRec.accessSrtCheckBox != null)
                            srtObj.SRT_AccessiblityCheck__c = s.srtRec.accessSrtCheckBox;
                        if(s.srtRec.srtCheckBox != null)
                            srtObj.isPerformed__c = s.srtRec.srtCheckBox;

                        if((s.srtRec.srtType != 'Field Action Access' && s.srtRec.srtType != 'Access') || s.srtRec.srtType == 'Admin' || s.srtRec.srtType == 'Repair' || s.srtRec.srtType == 'Diagnosis'){
                            if(s.srtRec.srtCheckBox == false){ 
                                system.debug('Inside IF Access');
                                srtObj.Extended_Hours__c = 0.0;
                            }
                        }else{ 
                            if(s.srtRec.accessSrtCheckBox == false){ 
                                system.debug('Inside IF Access');
                                srtObj.Extended_Hours__c = 0.0;
                            }
                        }
                        updateCampSRTList.add(srtObj);
                        // }
                    }
                }

            }
            system.debug('updateCampSRTList**'+updateCampSRTList);
            if(updateCampSRTList!= null && !updateCampSRTList.isEmpty()){
                update  updateCampSRTList ;
            }


            if(trpListWrap != null){
                system.debug('trpListWrap**'+trpListWrap);
                for(sortwrapper s:trpListWrap){
                    if(s.srtRec.sid!=null){

                        CSS_SRT__c srtObj = new CSS_SRT__c();
                        srtObj.Id = s.srtRec.sid;
                        srtObj.SRT_ID__c = s.srtRec.srtID;
                        srtObj.SRT_Title__c = s.srtRec.SRTDescription;
                        srtObj.SRT_Quantity__c = s.srtRec.Quantity;
                        if(s.srtRec.flexFlag == true){
                            if(s.srtRec.srtType != 'Field Action Access'){
                                srtObj.SRT_Time__c = s.srtRec.srtTime;
                            }
                            else{
                                srtObj.SRT_Time__c = s.srtRec.srtAccessTime;
                            }
                        }
                        srtObj.Access_Code__c = s.srtRec.AccessCode;
                        //srtObj.Adjustment_Reason__c = s.srtRec.AdjustmentReason;
                        //srtObj.SRT_Select__c = s.srtRec.selectedRecord; //commented since not in use
                        srtObj.type__c = s.srtRec.srtType;
                        //srtObj.FailCode__c = s.srtRec.failCode;
                        srtObj.Account_Code__c = s.srtRec.accountcode;
                        srtObj.Extended_Hours__c = s.srtRec.ClaimedHrs;
                        srtObj.IsPopUpSRT__c = s.srtRec.IsPopUpSRT;
                        srtObj.SRT_Order__c = s.srtRec.sortOrder;
                        /*if((s.srtRec.AccountCode != null && s.srtRec.AccountCode != '') && accSet != null && !accSet.Contains(s.srtRec.AccountCode.trim()) && claimsRecList[0].Information_Only_Claim__c==false){
                        if((claimsRecList[0].ODM_Penalty__c!= null && claimsRecList[0].ODM_Penalty__c != '') && (s.srtRec.percentCov != null && s.srtRec.percentCov != '') && integer.valueof(s.srtRec.percentCov) < integer.valueof(claimsRecList[0].ODM_Penalty__c)) 
                        srtObj.isUserEntered__c = true;
                    }
                        if((s.srtRec.AccountCode == null || s.srtRec.AccountCode == '') && claimsRecList[0].Information_Only_Claim__c==false){
                        if((claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '') && (s.srtRec.percentCov != null && s.srtRec.percentCov != '') && integer.valueof(s.srtRec.percentCov) < integer.valueof(claimsRecList[0].ODM_Penalty__c)) 
                        srtObj.isUserEntered__c = true;
                    }*/
                        srtObj.isUserEntered__c = s.srtRec.isUserEntered;
                        srtObj.SRT_Warrantable__c = s.srtRec.percentCov;
                        //srtObj.SRT_Hours_Percentage__c = decimal.valueof(s.srtRec.percentCov);
                        if(s.srtRec.accessSrtCheckBox != null)
                            srtObj.SRT_AccessiblityCheck__c = s.srtRec.accessSrtCheckBox;
                        if(s.srtRec.srtCheckBox != null)
                            srtObj.isPerformed__c = s.srtRec.srtCheckBox;

                        updateTRPSRTList.add(srtObj);
                        // }
                    }
                }    
            }
            system.debug('updateTRPSRTList**'+updateTRPSRTList);
            if(updateTRPSRTList != null && !updateTRPSRTList.isEmpty()){
                update updateTRPSRTList;
            }



            if(atcListWrap != null){
                system.debug('atcListWrap**'+atcListWrap);
                for(sortwrapper s:atcListWrap){
                    if(s.srtRec.sid!=null){

                        CSS_SRT__c srtObj = new CSS_SRT__c();
                        srtObj.Id = s.srtRec.sid;
                        srtObj.SRT_ID__c = s.srtRec.srtID;
                        srtObj.SRT_Title__c = s.srtRec.SRTDescription;
                        srtObj.SRT_Quantity__c = s.srtRec.Quantity;
                        if(s.srtRec.flexFlag == true){
                            if(s.srtRec.srtType != 'Field Action Access'){
                                srtObj.SRT_Time__c = s.srtRec.srtTime;
                            }
                            else{
                                srtObj.SRT_Time__c = s.srtRec.srtAccessTime;
                            }
                        }
                        srtObj.Access_Code__c = s.srtRec.AccessCode;
                        //srtObj.Adjustment_Reason__c = s.srtRec.AdjustmentReason;
                        //srtObj.SRT_Select__c = s.srtRec.selectedRecord; //commented since not in use
                        srtObj.type__c = s.srtRec.srtType;
                        //srtObj.FailCode__c = s.srtRec.failCode;
                        srtObj.Account_Code__c = s.srtRec.accountcode;
                        srtObj.Extended_Hours__c = s.srtRec.ClaimedHrs;
                        srtObj.IsPopUpSRT__c = s.srtRec.IsPopUpSRT;
                        srtObj.SRT_Order__c = s.srtRec.sortOrder;
                        /* if((s.srtRec.AccountCode != null && s.srtRec.AccountCode != '') && accSet != null && !accSet.Contains(s.srtRec.AccountCode.trim()) && claimsRecList[0].Information_Only_Claim__c==false){
                        if((claimsRecList[0].ODM_Penalty__c!= null && claimsRecList[0].ODM_Penalty__c != '') && (s.srtRec.percentCov != null && s.srtRec.percentCov != '') && integer.valueof(s.srtRec.percentCov) < integer.valueof(claimsRecList[0].ODM_Penalty__c)) 
                        srtObj.isUserEntered__c = true;
                    }
                        if((s.srtRec.AccountCode == null || s.srtRec.AccountCode == '') && claimsRecList[0].Information_Only_Claim__c==false){
                        if((claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '') && (s.srtRec.percentCov != null && s.srtRec.percentCov != '') && integer.valueof(s.srtRec.percentCov) < integer.valueof(claimsRecList[0].ODM_Penalty__c)) 
                        srtObj.isUserEntered__c = true;
                    }*/
                        srtObj.isUserEntered__c = s.srtRec.isUserEntered;
                        srtObj.SRT_Warrantable__c = s.srtRec.percentCov;
                        //srtObj.SRT_Hours_Percentage__c = decimal.valueof(s.srtRec.percentCov);
                        if(s.srtRec.accessSrtCheckBox != null)
                            srtObj.SRT_AccessiblityCheck__c = s.srtRec.accessSrtCheckBox;
                        if(s.srtRec.srtCheckBox != null)
                            srtObj.isPerformed__c = s.srtRec.srtCheckBox;

                        updateATCSRTList.add(srtObj);
                        // }
                    }
                }
            }
            system.debug('updateATCSRTList**'+updateATCSRTList);
            if(updateATCSRTList != null && !updateATCSRTList.isEmpty()){
                update updateATCSRTList;
            }



            String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
            pageRef = new PageReference(sDestURL+'id='+CID); 
            pageRef.setRedirect(true);
            return pageRef;
        }catch(exception e){
            system.debug('Catch/Exception in saveCAmpTRPATCdata method of cg_cl_claimsSRTCampaignscontroller class>>>>>>'+e.getmessage() + ' ' + e.getLineNumber());
        }
        return null;

    }


    // Story GSSC-20 Begin

    /* Campaign */
    public String lineItemStepIdClaimsCamp {get;set;} 
    public String StepDescriptionClaims {get; set;}
    public void callClaimsAccessStepDetailsCamp(){
        try{
            system.debug('lineItemStepIdClaimsCamp  ' + lineItemStepIdClaimsCamp);
            system.debug('EquipmentId ' + EquipmentId);
            CSS_J2AAccessStepDetails_SRT stepDetailsWS = CSS_SRTAccessWebService.accessSRTStepDetails_New(EquipmentId,lineItemStepIdClaimsCamp);
            system.debug('stepDetailsWS ' + stepDetailsWS);
            if(stepDetailsWS.DataArea!=null){
                if(stepDetailsWS.DataArea.CaseResponse!=null){
                    for(integer i=0;i<stepDetailsWS.DataArea.CaseResponse.size();i++){
                        StepDescriptionClaims = stepDetailsWS.DataArea.CaseResponse[i].SRTContent;
                    }
                }
            }
            else
                StepDescriptionClaims = '';
            
             StepDescriptionClaims = StepDescriptionClaims.replaceAll('\\n','<br/>');
            StepDescriptionClaims = StepDescriptionClaims.replaceAll('\n','<br/>');
            system.debug('StepDescriptionClaims ' + StepDescriptionClaims);
        }
        catch(exception e){
            system.debug('Exception in callAccessStepDetails method Line Num' + e.getLineNumber() + ' Message' + e.getMessage());
        }
    }

    public void ClaimsCampNotesPopupOk(){
        StepDescriptionClaims='';
        system.debug('Ok button>> StepDescriptionClaims ' + StepDescriptionClaims);
    }

    /* TRP */

    public String lineItemStepIdClaimsTRP {get;set;} 
    public String StepDescriptionTRP {get; set;}
    public void callClaimsAccessStepDetailsTRP(){
        try{
            system.debug('lineItemStepIdClaimsTRP  ' + lineItemStepIdClaimsTRP);
            system.debug('EquipmentId ' + EquipmentId);
            CSS_J2AAccessStepDetails_SRT stepDetailsWS = CSS_SRTAccessWebService.accessSRTStepDetails_New(EquipmentId,lineItemStepIdClaimsTRP);
            system.debug('stepDetailsWS ' + stepDetailsWS);
            if(stepDetailsWS.DataArea!=null){
                if(stepDetailsWS.DataArea.CaseResponse!=null){
                    for(integer i=0;i<stepDetailsWS.DataArea.CaseResponse.size();i++){
                        StepDescriptionTRP = stepDetailsWS.DataArea.CaseResponse[i].SRTContent;
                    }
                }
            }
            else
                StepDescriptionTRP ='';
            
            StepDescriptionTRP = StepDescriptionTRP.replaceAll('\\n','<br/>');
            StepDescriptionTRP = StepDescriptionTRP.replaceAll('\n','<br/>');
            
            system.debug('StepDescriptionTRP ' + StepDescriptionTRP);
        }
        catch(exception e){
            system.debug('Exception in callAccessStepDetails method Line Num' + e.getLineNumber() + ' Message' + e.getMessage());
        }
    }

    public void ClaimsTRPNotesPopupOk(){
        StepDescriptionTRP='';
        system.debug('Ok button>> StepDescriptionTRP ' + StepDescriptionTRP );
    }

    /* ATC */

    public String lineItemStepIdClaimsATC {get;set;} 
    //  public String lineItemStepDescriptionClaimsATC {get;set;}   
    public String StepDescriptionATC {get; set;}
    public void callClaimsAccessStepDetailsATC(){
        try{
            system.debug('lineItemStepIdClaimsATC  ' + lineItemStepIdClaimsATC);
            system.debug('EquipmentId ' + EquipmentId);
            CSS_J2AAccessStepDetails_SRT stepDetailsWS = CSS_SRTAccessWebService.accessSRTStepDetails_New(EquipmentId,lineItemStepIdClaimsATC);
            system.debug('stepDetailsWS ' + stepDetailsWS);
            if(stepDetailsWS.DataArea!=null){
                if(stepDetailsWS.DataArea.CaseResponse!=null){
                    for(integer i=0;i<stepDetailsWS.DataArea.CaseResponse.size();i++){
                        StepDescriptionATC = stepDetailsWS.DataArea.CaseResponse[i].SRTContent;
                    }
                }
            }
            else{
                StepDescriptionATC ='';
            }
            
            StepDescriptionATC = StepDescriptionATC.replaceAll('\\n','<br/>');
            StepDescriptionATC = StepDescriptionATC.replaceAll('\n','<br/>');
            
            system.debug('StepDescriptionATC ' + StepDescriptionATC);
        }
        catch(exception e){
            system.debug('Exception in callAccessStepDetails method Line Num' + e.getLineNumber() + ' Message' + e.getMessage());
        }
    }

    public void ClaimsATCNotesPopupOk(){
        StepDescriptionATC='';
        // lineItemStepDescriptionClaimsATC ='';
        system.debug('Ok button>> StepDescriptionATC ' + StepDescriptionATC );
    }

    /* Story GSSC - 20 End */
}