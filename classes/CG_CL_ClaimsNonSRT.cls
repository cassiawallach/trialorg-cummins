public class CG_CL_ClaimsNonSRT {

    public List<CSS_SRT__C> existingNonSRTList {get; set;}
    public List<NonSRTWrapper> NonSRTWrapperList {get;set;}
    public List<NonSRTWrapper> NonSRTWrapperList1 {get;set;}
    public string PName { get; set;}
    public Integer selectedRemoveRow {get; set;}
    public Decimal TotalSRTTime{get; set;}
    public CSS_Solution_Component__c[] solutionComponentList;
    public set<string> failAcocuntCode;
    public boolean chkReqField{get;set;}
    public boolean ErrorMessage1 {get; set;}
    public Id claimId;
    public List<CSS_JobEventTemporary__c> jobEventLst;
    public String coverageType;
    public boolean checklaborrate{get;set;}
    public List<CSS_Claims__c> claimsRecList;
    public Integer counting{get;set;}
    public string selCoveredVal{get;set;}
    public List<CSS_JobEventTemporary__c> jobEventTemp;
    public Set<String> accSet;
    public Boolean dealerLocation{get; set;}
    public Boolean dealerUserLocation{get; set;}
    public Boolean isFactory{get; set;}
    public Map<string,string> pwPenaltyMap; //Added as per story 180325
    public Map<string,string> pwPenaltyAccCodeMap; //Added as per story 
    public Map<string,String> SolcompCoveredlaborMap;// Added as part of GSSC -57
    Public Set<String> accSetPW;
    //public Boolean isCatastrophic{get;set;}//171838 Rupesh
    public Boolean isNonSRTCovered{get;set;}

    //Constructor.
    public CG_CL_ClaimsNonSRT(){
        isNonSRTCovered = true;
        requestederr = false;
        TotalSRTTime=0.0;
        checklaborrate=true;
        claimId=ApexPages.CurrentPage().getParameters().get('id');
        system.debug('--**claimId**--'+claimId);
    }
    public void getConstructorLoaded(){
      system.debug('kartheekinfload');
        existingNonSRTList = new List<CSS_SRT__C>();
        //isCatastrophic = false;//171838 Rupesh
        if(claimId != null) 
        {
            //Finding the catastrphpic checked: 171838
            claimsRecList = new List<CSS_Claims__c>([Select Id ,Name, CSS_Job__c,Dealer_Service_Job__c,Location_Code__c,SP_INSHOP_LABOR_RATE__c, Catastrophic__c,ODM_Penalty__c,Information_Only_Claim__c from CSS_Claims__c where Id=:claimId]);
            //isCatastrophic=claimsRecList[0].Catastrophic__c;
            if(claimsRecList !=null && claimsRecList.size()>0){
                if(string.isBlank(claimsRecList[0].SP_INSHOP_LABOR_RATE__c) || (string.isNotBlank(claimsRecList[0].SP_INSHOP_LABOR_RATE__c) && double.valueOf(claimsRecList[0].SP_INSHOP_LABOR_RATE__c)==0))
                {
                    checklaborrate=false;
                    system.debug('Test Labor'+checklaborrate);
                } 
                // below code for checking dealer location from utility class as per story #179802 Alladin  sprint,-By RAJESH 05 Apr 2019
                string claimLocation=claimsRecList[0].Location_Code__c;
                if(claimLocation!=null){
                    String locationcode = css_Utility.dealerUserLocation(claimLocation);
                    if(locationcode!=null && locationcode!='' ){
                        if(locationcode=='true')
                            dealerUserLocation=true;
                        else
                            dealerUserLocation=false;
                    }
                }
                //End
            }

            jobEventLst = [select Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c,Account_Code__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes'];
            system.debug('jobEventLst*size***'+jobEventLst.size());
            //Fetch data from Existing Non SRT.
            existingNonSRTList = [select Id, Account_Code_Description__c, isPerformed__c,Fail_Code_Description__c,SRT_Quantity__c, SRT_Time__c, SRT_Notes__c,CSS_Claims__c,CSS_Claims__r.CSS_Job__c,SRT_Warrantable__c,Claimed_Hours__c,Extended_Hours__c ,Access_Code_Flag__c,SRT_Warrantable_Flag__c,isUserEntered__c                  
                                  from CSS_SRT__c 
                                  where CSS_Claims__c=:claimId AND Type__c='99Time' AND Account_Code_Description__c != null AND Fail_Code_Description__c != null];
            system.debug('--**existingNonSRTList**--'+existingNonSRTList);
            if(existingNonSRTList !=null && existingNonSRTList.size() > 0){
                for(CSS_SRT__c existing : existingNonSRTList) {
                    // if((existing.Claimed_Hours__c) != null && (existing.Claimed_Hours__c) != 0.0 && existing.isPerformed__c==true) {
                    if(((existing.Claimed_Hours__c != null && existing.Claimed_Hours__c != 0.0) || (existing.Extended_Hours__c != null && existing.Extended_Hours__c != 0.0)) && existing.isPerformed__c==true) {
                        /*if(existing.SRT_Quantity__c != null){
            TotalSRTTime += (existing.srt_Time__C * existing.SRT_Quantity__c);// * existing.SRT_Quantity__c);venkat: added SRT_Quantity__c for the story 154633
            system.debug('Check value for SRTTime0 >> '+TotalSRTTime);
            }
            else{
                TotalSRTTime += existing.srt_Time__C;
            }*/
                        if(claimsRecList !=null && claimsRecList.size()>0){
                            if(claimsRecList[0].css_job__c != null || claimsRecList[0].Dealer_Service_Job__c != null){
                                TotalSRTTime = TotalSRTTime + ((existing.Extended_Hours__c != null) ? existing.Extended_Hours__c : 0.0);
                            }
                            else{
                                TotalSRTTime = TotalSRTTime + ((existing.Claimed_Hours__c != null) ? existing.Claimed_Hours__c : 0.0);
                            }
                        }
                    }
                }
            }
            system.debug('Check value for TotalSRTTime >> '+TotalSRTTime);  
            //getEditNonSRTValues();
            //Kalpana story 155910
            //Commented below query to reduce query as it is already present above - 101 SOQL issue
            //jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' and Attribute1__c IN ('POL','NPW','RPW')];
            accSet = new Set<String>();
            if(jobEventLst != null && !jobEventLst.isEmpty()){
                for(CSS_JobEventTemporary__c JET: jobEventLst){
                    if(JET.Attribute1__c == 'POL'){
                        accSet.add(JET.Attribute2__c+' '+JET.Attribute3__c);
                    }
                }
            }
            //Story 180325 -- START
            //Commented below query to reduce query as it is already present above - 101 SOQL issue
            //List<CSS_JobEventTemporary__c> jobEventTempPW = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' and Attribute1__c IN ('NPW','RPW')];
            accSetPW = new Set<String>();
            pwPenaltyMap = new Map<string,string>();
            pwPenaltyAccCodeMap = new Map<string,string>(); //Added as per story 180325
            SolcompCoveredlaborMap = new Map<String,String>();
            
            string failurePenalty;
            if(jobEventLst != null && jobEventLst.size()>0){
                for(CSS_JobEventTemporary__c JET: jobEventLst){
                    if(JET.Attribute1__c == 'NPW' || JET.Attribute1__c == 'RPW'){
                        accSetPW.add(JET.Attribute2__c+' '+JET.Attribute3__c);
                    }
                }
            }
            system.debug('accSetPW**'+accSetPW);
            List<CSS_Solution_Component__c> solCompList = [select id,fail_code__c,FailCode_Formula__c,Covered_Labor__c,ODM_Penalty__c,CSS_Account_Formula__c from css_solution_component__C where css_claims__c = :claimId];
            for(CSS_Solution_Component__c sc:solCompList){
                if(sc.ODM_Penalty__c != null && sc.ODM_Penalty__c != '' && integer.valueof(sc.ODM_Penalty__c) > 0 && (sc.CSS_Account_Formula__c != null && sc.CSS_Account_Formula__c != '') && accSetPW.contains(sc.CSS_Account_Formula__c.trim())){
                    pwPenaltyMap.put(sc.fail_code__c+sc.CSS_Account_Formula__c,sc.ODM_Penalty__c);
                    pwPenaltyAccCodeMap.put(sc.fail_code__c+sc.CSS_Account_Formula__c,sc.ODM_Penalty__c);}
                SolcompCoveredlaborMap.put(sc.fail_code__c+sc.CSS_Account_Formula__c,sc.Covered_Labor__c);
                system.debug('sc.CSS_Account_Formula__c**'+sc.CSS_Account_Formula__c);

            }
            //Story 180325 -- END
            system.debug('pwPenaltyMap**'+pwPenaltyMap);
            getEditNonSRTValues();
        }
        String orgType = css_Utility.getOrgType(UserInfo.getUserId());
        if(orgType == 'DLR'){
            dealerLocation = true;
        }
        else{
            dealerLocation = false;
        }
        isFactory=false;
        UserRole urRole = new UserRole();
        if(UserInfo.getUserRoleId() != null && UserInfo.getUserRoleId() != '') {
            urRole = [Select name from UserRole where id=:UserInfo.getUserRoleId()];
            if(urRole != null && urRole.name == 'Factory'){
                isFactory=true;
            }
            else
            {
                isFactory=false;
            }
        }
        if(existingNonSRTList == null || existingNonSRTList.size() == 0){
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            List<Boolean> coverageResult = new List<Boolean>();
            coverageResult = contr.checkFailuresCovered(claimId, false);
            system.debug('coverageResult--'+coverageResult);
            if(coverageResult != null && coverageResult.size()>0 && ((coverageResult.size() > 3 && coverageResult[3] == true) || (coverageResult.size() > 4 && coverageResult[4] == true))){ //Kalpana added list size and null check
                isNonSRTCovered = true;
            }
            else{
                isNonSRTCovered = false;
            }
            system.debug('isNonSRTCovered--'+isNonSRTCovered);
        }
    }
    //added below method to calculae %Req as per story 155910
    public void SRTPercReqNonSRT(){
        system.debug('inPercentReq**'+selCoveredVal);
        system.debug('inPercentReq1**'+counting);
        system.debug('pwPenaltyMap**'+pwPenaltyMap);
        String failurePenalty;
        string coveredlaborvalsol;
        if(NonSRTWrapperList != null && !NonSRTWrapperList.isEmpty()){
            for(NonSRTWrapper srt:NonSRTWrapperList){
                if(counting == srt.count){
                    system.debug('inPercentReq**'+srt.accountcode);
                    system.debug('inPercentReq2**'+srt.percentRequested);
                    system.debug('accSet**'+accSet);
                    //Story 180325 added below pwPenaltyMap code
                    srt.isUserEntered=true;
                    if(pwPenaltyMap != null && pwPenaltyMap.size() > 0 && (srt.accountcode != null && srt.accountcode != '') && claimsRecList[0].Information_Only_Claim__c==false){
                        if(srt.failcode != null && srt.failcode != ''){
                            if(srt.failcode.contains('-')){
                                string [] FC = srt.failcode.split('-');
                                if(FC != null && FC.size()>0)
                                    failurePenalty = pwPenaltyMap.get(FC[1]+srt.AccountCode.trim()); 
                            }
                            else
                                failurePenalty = pwPenaltyMap.get(srt.failcode.trim()+srt.AccountCode.trim());
                        }
                        else
                            failurePenalty = pwPenaltyAccCodeMap.get(srt.AccountCode.trim());
                        if(failurePenalty != null && failurePenalty != '' && (((srt.percentRequested != null && srt.percentRequested != '') && integer.valueof(srt.percentRequested)>integer.valueof(failurePenalty)) || (srt.percentRequested == null || srt.percentRequested == '' || srt.percentRequested == '0'))){
                            srt.percentRequested = failurePenalty;
                        }
                    }
                    else if(claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '' && integer.valueof(claimsRecList[0].ODM_Penalty__c) > 0){
                        system.debug('Inside first Else If**');
                        if(srt.AccountCode != null && srt.AccountCode != '' && accSetPW != null && !accSetPW.contains(srt.AccountCode) && claimsRecList[0].Information_Only_Claim__c==false){

                            if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                            {srt.percentRequested = selCoveredVal;}
                            else 
                            {srt.percentRequested = claimsRecList[0].ODM_Penalty__c;srt.isUserEntered=false;}
                        }
                        else if(srt.AccountCode == null || srt.AccountCode == '' && claimsRecList[0].Information_Only_Claim__c==false){
                            if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                            {srt.percentRequested = selCoveredVal;}
                            else 
                            {srt.percentRequested = claimsRecList[0].ODM_Penalty__c;srt.isUserEntered=false;}

                        }

                        else if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) >= 100)
                        {srt.percentRequested = string.valueof(100);srt.isUserEntered=false;}

                    }
                    else if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) >= 100)
                    {srt.percentRequested = string.valueof(100);srt.isUserEntered=false;}


                    //Karthik G Added GssC-57
                    if(srt.AccountCode != null && srt.AccountCode != '' && accSet != null && claimsRecList[0].Information_Only_Claim__c==false){
                        if(srt.failcode.contains('-')){
                            string [] FCR = srt.failcode.split('-');
                            if(FCR != null && FCR.size()>0)
                                coveredlaborvalsol = SolcompCoveredlaborMap.get(FCR[1]+srt.AccountCode.trim()); 
                        }
                        else
                            coveredlaborvalsol = SolcompCoveredlaborMap.get(srt.failcode.trim()+srt.AccountCode.trim());

                        system.debug('insidekarthiksecondelseif>>>'+coveredlaborvalsol);
                        
                        if((selCoveredVal != null && selCoveredVal != '' && coveredlaborvalsol!='' && coveredlaborvalsol!=null) && integer.valueof(selCoveredVal) < integer.valueof(coveredlaborvalsol)) // karthikG check covered labor from solcomp
                        {srt.percentRequested = selCoveredVal;}

                        else if((selCoveredVal != null && selCoveredVal != '' && (coveredlaborvalsol=='' || coveredlaborvalsol==null)) && integer.valueof(selCoveredVal) <= 100)
                        {srt.percentRequested = selCoveredVal;}
                        else if ((selCoveredVal != null && selCoveredVal != '' && (coveredlaborvalsol=='' || coveredlaborvalsol==null)) && integer.valueof(selCoveredVal) >= 100)
                        {
                            system.debug('karthik100');
                            srt.percentRequested = string.valueof(100);srt.isUserEntered=false;}
                        else 
                        {
                            system.debug('coveredlaborvalsol>>>'+coveredlaborvalsol);
                            srt.percentRequested = coveredlaborvalsol; //  add solcomp coered labor 
                            srt.isUserEntered=false;}
                    }
                    //karthik G Done
                    break;
                }
            }
        }
    }
    //Popup Functionality.
    public List<NonSRTWrapper> getEditNonSRTValues() {
        NonSRTWrapperList = new List<NonSRTWrapper>();
        Integer srtCount = 0;

        try {
            if(claimId != null) {
                failAcocuntCode = new set<string>();

                //Fetch data from Existing Non SRT.
                system.debug('--**existingNonSRTList**--'+existingNonSRTList);
                system.debug('--**pwPenaltyMap**--'+pwPenaltyMap);
                String failurePenalty;
                string coveredlaborvalsol;
                if(existingNonSRTList != null && existingNonSRTList.size() > 0) {
                    for(CSS_SRT__C existingNonSRT : existingNonSRTList) {


                        string uniquekey = existingNonSRT.Fail_Code_Description__c +':' + existingNonSRT.Account_Code_Description__c;
                        failAcocuntCode.add(uniquekey);
                        //Story 180325 added below pwPenaltyMap code
                        if(pwPenaltyMap != null && pwPenaltyMap.size() > 0 && (existingNonSRT.Account_Code_Description__c != null && existingNonSRT.Account_Code_Description__c != '') && claimsRecList[0].Information_Only_Claim__c==false){
                            system.debug('Inside If**');
                            //failurePenalty = pwPenaltyMap.get(existingNonSRT.Fail_Code_Description__c+existingNonSRT.Account_Code_Description__c);
                            if(existingNonSRT.Fail_Code_Description__c != null && existingNonSRT.Fail_Code_Description__c != '')
                                failurePenalty = pwPenaltyMap.get(existingNonSRT.Fail_Code_Description__c.trim()+existingNonSRT.Account_Code_Description__c.trim());
                            else
                                failurePenalty = pwPenaltyAccCodeMap.get(existingNonSRT.Account_Code_Description__c.trim());
                            if(failurePenalty != null && failurePenalty != '' && ((existingNonSRT.SRT_Warrantable__c != null && integer.valueof(existingNonSRT.SRT_Warrantable__c)>integer.valueof(failurePenalty)) || existingNonSRT.SRT_Warrantable__c == null || Integer.valueOf(existingNonSRT.SRT_Warrantable__c) == 0)){
                                existingNonSRT.SRT_Warrantable__c = failurePenalty;
                            }
                        }
                        //155910
                        else if(claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '' && integer.valueof(claimsRecList[0].ODM_Penalty__c) > 0){
                            system.debug('Inside First Else If**');
                            //if(existingNonSRT.Account_Code_Description__c != null && existingNonSRT.Account_Code_Description__c != '' && accSet != null && !accSet.contains(existingNonSRT.Account_Code_Description__c) && claimsRecList[0].Information_Only_Claim__c==false){
                            // if(existingNonSRT.Account_Code_Description__c != null && existingNonSRT.Account_Code_Description__c != '' && accSetPW != null && !accSetPW.contains(existingNonSRT.Account_Code_Description__c) && claimsRecList[0].Information_Only_Claim__c==false){
                            if(existingNonSRT.Account_Code_Description__c != null && existingNonSRT.Account_Code_Description__c != '' && accSetPW != null && !accSetPW.contains(existingNonSRT.Account_Code_Description__c) && accSet != null && !accSet.contains(existingNonSRT.Account_Code_Description__c) && claimsRecList[0].Information_Only_Claim__c==false){ // Added as per defect 191911, commented above If
                                system.debug('Kalpana Inside First Else If**');
                                if((existingNonSRT.SRT_Warrantable__c != null ) && integer.valueof(existingNonSRT.SRT_Warrantable__c) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                                    existingNonSRT.SRT_Warrantable__c = existingNonSRT.SRT_Warrantable__c;
                                else 
                                {existingNonSRT.SRT_Warrantable__c = claimsRecList[0].ODM_Penalty__c;
                                 existingNonSRT.isUserEntered__c = false;
                                }
                            }
                            else if(existingNonSRT.Account_Code_Description__c == null || existingNonSRT.Account_Code_Description__c == '' && claimsRecList[0].Information_Only_Claim__c==false){
                                system.debug('Inside SEcond Else If**');
                                if((existingNonSRT.SRT_Warrantable__c != null) && integer.valueof(existingNonSRT.SRT_Warrantable__c) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                                    existingNonSRT.SRT_Warrantable__c = existingNonSRT.SRT_Warrantable__c;
                                else 
                                { existingNonSRT.SRT_Warrantable__c = claimsRecList[0].ODM_Penalty__c;
                                 existingNonSRT.isUserEntered__c = false;
                                }

                            }
                        }
                 
                        NonSRTWrapperList.add(new NonSRTWrapper(srtCount, existingNonSRT.Id, '99-999', string.ValueOf(existingNonSRT.SRT_Time__c), existingNonSRT.SRT_Warrantable__c, string.ValueOf(existingNonSRT.Claimed_Hours__c),existingNonSRT.Fail_Code_Description__c, existingNonSRT.Account_Code_Description__c, existingNonSRT.SRT_Notes__c, existingNonSRT.isPerformed__c, existingNonSRT.isUserEntered__c));
                        srtCount +=1;

                        //UniqueSRTMap.put(uniquekey,existingNonSRT); 
                    }
                }


                //Insert the wrapper Records.
                system.debug('--**NonSRTWrapperList**--Part 1 >>> '+NonSRTWrapperList);
                //Fetching data from CSS Solution Components.
                solutionComponentList = [select Id, CSS_Account_Formula__c, FailCode_Formula__c, Selected_Component__c,CoveredLaborHrs__c,ODM_Penalty__c, CampaignLaborPercentage__c, Type__c
                                         From CSS_Solution_Component__c
                                         where Selected_Component__c = true AND (type__c =null OR type__c IN ('CAMPAIGN','TRP','ATC')) AND CSS_Claims__c=:claimId]; //Added FieldACtion types as per task 181911
                system.debug('--**solutionComponentList**--'+solutionComponentList);
                string[] fcSplit;
                string failcode;
                for(CSS_Solution_Component__c solComp : solutionComponentList) {
                    String reqPercent;
                    if(solComp.CSS_Account_Formula__c != null && solComp.FailCode_Formula__c != null) {
                        string s = solComp.FailCode_Formula__c + ':' + solComp.CSS_Account_Formula__c;
                        if(jobEventLst != null){
                            for(CSS_JobEventTemporary__c jobEntObj : jobEventLst){
                                if(jobEntObj.Account_Code__c == solComp.CSS_Account_Formula__c){
                                    coverageType = jobEntObj.Attribute1__c;
                                }
                            }
                        }
                        if(solComp.Type__c != 'CAMPAIGN' && solComp.Type__c != 'TRP' && solComp.Type__c != 'ATC'){
                            //Added OTH/POL condition below as part of the defect #190460
                            if(solComp.Selected_Component__c == true && ((solComp.CoveredLaborHrs__c != null && integer.ValueOf(solComp.CoveredLaborHrs__c) >0) || (coverageType == 'OTH' || coverageType == 'POL'))){
                                if(!failAcocuntCode.contains(s)) {
                                    system.debug('today is May first');

                                    system.debug('coverageType***'+coverageType);
                                    system.debug('failurePenalty***'+failurePenalty);
                                    system.debug('ODMPenalty***'+claimsRecList[0].ODM_Penalty__c);
                                    if(solComp.CSS_Account_Formula__c != null && solComp.FailCode_Formula__c != null){

                                        if(solComp.FailCode_Formula__c != null && solComp.FailCode_Formula__c != '' && solComp.FailCode_Formula__c.contains('-')){
                                            fcSplit = solComp.FailCode_Formula__c.split('-'); //srt.failcode__c.RIGHT(4);
                                            system.debug('fcSplit**'+fcSplit);
                                            if(fcSplit != null && fcSplit.size()>0)
                                                failcode = fcSplit[1];
                                        }
                                        else
                                            failcode = solComp.FailCode_Formula__c;
                                        if(pwPenaltyMap != null && pwPenaltyMap.size() > 0 && (failcode != null && failcode != '') && pwPenaltyMap.get(failcode.trim()+solComp.CSS_Account_Formula__c.trim()) != null && pwPenaltyMap.get(failcode.trim()+solComp.CSS_Account_Formula__c.trim()) != '' && (solComp.CSS_Account_Formula__c != null && solComp.CSS_Account_Formula__c != '') && accSetPW.contains(solComp.CSS_Account_Formula__c.trim()))
                                            failurePenalty = pwPenaltyMap.get(failcode.trim()+solComp.CSS_Account_Formula__c.trim());
                                    }
                                    if(coverageType == 'POL'){
                                        coveredlaborvalsol = SolcompCoveredlaborMap.get(failcode.trim()+solComp.CSS_Account_Formula__c.trim());

                                        reqPercent = coveredlaborvalsol;
                                    }

                                    //else if(solComp.ODM_Penalty__c != null && solComp.ODM_Penalty__c != '' && (failurePenalty != null && failurePenalty != '') && integer.valueof(solComp.ODM_Penalty__c) > 0 && claimsRecList[0].Information_Only_Claim__c==false){
                                    else if(failurePenalty != null && failurePenalty != '' && integer.valueof(failurePenalty) > 0 && claimsRecList[0].Information_Only_Claim__c==false && pwPenaltyMap.get(failcode.trim()+solComp.CSS_Account_Formula__c.trim()) != null && pwPenaltyMap.get(failcode.trim()+solComp.CSS_Account_Formula__c.trim()) != ''){
                                        reqPercent = failurePenalty; //Added as per story 180325

                                    }
                                    else if(claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '' && integer.valueof(claimsRecList[0].ODM_Penalty__c) > 0 && claimsRecList[0].Information_Only_Claim__c==false && !accSetPW.contains(solComp.CSS_Account_Formula__c.trim())){
                                        reqPercent = claimsRecList[0].ODM_Penalty__c;
                                    }
                                    //Added OTH/POL condition below as part of the defect #190460
                                    else if(solComp.Selected_Component__c == true && ((solComp.CoveredLaborHrs__c != null && integer.ValueOf(solComp.CoveredLaborHrs__c) >0) && (coverageType != 'OTH' || coverageType != 'POL'))){
                                        reqPercent = '100';
                                    }
                                     else if(solComp.Selected_Component__c == true && ((solComp.Covered_Labor__c != null && integer.ValueOf(solComp.Covered_Labor__c) >0) && (coverageType == 'OTH' || coverageType == 'POL'))){
                                       reqPercent = solComp.Covered_Labor__c;
                                     }
                                    else{
                                        reqPercent = '0';
                                    }
                                    NonSRTWrapperList.add(new NonSRTWrapper(srtCount, null, '99-999', '', reqPercent,'', solComp.FailCode_Formula__c, solComp.CSS_Account_Formula__c, '', false,false)); 
                                    srtCount +=1;
                                }
                                failAcocuntCode.add(s);
                            }
                        }
                        else{
                            if(solComp.Selected_Component__c == true && solComp.CampaignLaborPercentage__c != null && integer.ValueOf(solComp.CampaignLaborPercentage__c) >0){
                                if(!failAcocuntCode.contains(s)) {
                                    if(solComp.ODM_Penalty__c != null && solComp.ODM_Penalty__c != '' && integer.valueof(solComp.ODM_Penalty__c) > 0 && claimsRecList[0].Information_Only_Claim__c==false){
                                        reqPercent = solComp.ODM_Penalty__c; //Added as per story 180325
                                    }
                                    else if(claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '' && integer.valueof(claimsRecList[0].ODM_Penalty__c) > 0 && claimsRecList[0].Information_Only_Claim__c==false){
                                        reqPercent = claimsRecList[0].ODM_Penalty__c;
                                    }
                                    else if(solComp.Selected_Component__c == true && solComp.CampaignLaborPercentage__c != null && integer.ValueOf(solComp.CampaignLaborPercentage__c) >0){
                                        reqPercent = '100';
                                    }
                                    else{
                                        reqPercent = '0';
                                    }
                                    NonSRTWrapperList.add(new NonSRTWrapper(srtCount, null, '99-999', '', reqPercent,'', solComp.FailCode_Formula__c, solComp.CSS_Account_Formula__c, '', false,false)); 
                                    srtCount +=1;
                                }
                                failAcocuntCode.add(s);
                            }
                        }
                    }
                }
                system.debug('--**NonSRTWrapperList**--Final >>> '+NonSRTWrapperList);
                //Fetching data from CSS Solution Components.
            }
        } catch(Exception ex) {
            system.debug('in the exception of JobPlan Controller Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }
        return NonSRTWrapperList;
    }

    //Removing rows in Popup
    public void removingNonSRTRow(){
        system.debug('selectedRemoveRow>>>> ' + selectedRemoveRow);
        system.debug('NonSRTWrapperList>>>> ' + NonSRTWrapperList);

        try{
            NonSRTWrapperList1=NonSRTWrapperList.clone();
            NonSRTWrapperList.clear();
            for(Integer i=0; i<NonSRTWrapperList1.size(); i++){
                if(NonSRTWrapperList1[i].count == selectedRemoveRow) {
                    System.debug('selectedRemoveRow '+selectedRemoveRow);
                    System.debug('NonSRTWrapperList1[i].counting '+NonSRTWrapperList1[i].count);
                    NonSRTWrapperList1[i].SRTTime = '';
                    //NonSRTWrapperList1[i].percentRequested = ''; //Commented as per the task 181448
                    NonSRTWrapperList1[i].claimedhours = '';
                    NonSRTWrapperList1[i].Notes = '';
                }
            }

            NonSRTWrapperList=NonSRTWrapperList1.clone();
            NonSRTWrapperList1.clear();
            system.debug('NonSRTWrapperList>>>> ' + NonSRTWrapperList);
        }catch(Exception ex) {
            System.debug('in catch of removingRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }

    }

    //Method to close the pop up 
    public void closePopup(){
        system.debug('START closePopup '); 
        getEditNonSRTValues();
        ErrorMessage1 = false;
        requestederr = false;
        system.debug('END closePopup '); 
    }

    //map<string,list<NonSRTWrapper>> sameaccerrormap = new map<string,list<NonSRTWrapper>>();
    public boolean requestederr{get;set;}

    //Method for Save Function.
    public pagereference saveNonSRTPopup() {
        system.debug('--**NonSRTWrapperList**--'+NonSRTWrapperList);
        chkReqField = false;
        requestederr = false;
        system.debug('--**chkReqField**--'+chkReqField);
        ErrorMessage1 = false;
        PageReference pageRef;
        set<Id> deleteSRTIds = new set<Id>();
        list<CSS_SRT__c> SRTList = new list<CSS_SRT__c>();
        Map<String,Set<String>> accCodePerCov = new Map<String,Set<String>>();

        try {

            for(NonSRTWrapper NonSRT : NonSRTWrapperList) {
                //if((NonSRT.SRTTime != null && NonSRT.SRTTime != '') || (NonSRT.percentRequested != null && NonSRT.percentRequested != '')  || (NonSRT.Notes != null && NonSRT.Notes != '')) {
                if((NonSRT.SRTTime != null && NonSRT.SRTTime != '') ||  (NonSRT.Notes != null && NonSRT.Notes != '')) {    
                    if(isFactory == true && NonSRT.accountCode != null){
                        if(!accCodePerCov.containskey(NonSRT.accountCode)){
                            Set<String> tempLst = new Set<String>();
                            tempLst.add(NonSRT.percentRequested);
                            accCodePerCov.put(NonSRT.accountCode,tempLst);
                        }
                        else{
                            Set<String> tempLst = new Set<String>();
                            tempLst = accCodePerCov.get(NonSRT.accountCode);
                            if(!tempLst.contains(NonSRT.percentRequested)){
                                tempLst.add(NonSRT.percentRequested);
                            }
                            accCodePerCov.put(NonSRT.accountCode,tempLst);
                        }
                    }
                    //Removed percentageRequested mandatory condition below as per defect 173668
                    /*if((NonSRT.SRTTime != null && NonSRT.SRTTime != '')  || (NonSRT.Notes != null && NonSRT.Notes != '')) {
       if(sameaccerrormap.containskey(NonSRT.accountCode.trim())){
           list<NonSRTWrapper> oldvalues = sameaccerrormap.get(NonSRT.accountCode.trim());
           oldvalues.add(NonSRT);
           for(NonSRTWrapper srt:oldvalues){
              for(NonSRTWrapper srtold:oldvalues){
                 if(srt.percentRequested!=srtold.percentRequested){
                    requestederr=true;
                    return null;
                 }
              } 
           }

       }else{
           sameaccerrormap.put(NonSRT.accountCode.trim(),new list<NonSRTWrapper>{NonSRT});
           if(requestederr == true)
           requestederr=false;
       }*/

                    CSS_SRT__c srt = new CSS_SRT__c();
                    srt.Type__c = '99Time';
                    srt.Id = NonSRT.srtId;
                    srt.Account_Code_Description__c = NonSRT.accountCode;
                    srt.Fail_Code_Description__c = NonSRT.failCode;
                    String selectedFailCodeMod;
                    List<String> failCodeSplit = new List<String>();
                    failCodeSplit = NonSRT.failCode.split('-');

                    if(failCodeSplit.size() >= 1 && failCodeSplit[failCodeSplit.size()-1] != null && failCodeSplit[failCodeSplit.size()-1] != ''){
                        //selectedFailCodeMod = failCodeSplit[failCodeSplit.size()-1] .left(4);
                        selectedFailCodeMod = failCodeSplit[failCodeSplit.size()-1];
                    }                   

                    srt.FailCode__c = selectedFailCodeMod;

                    srt.SRT_ID__c = '99-999';                    
                    srt.CSS_Claims__c= claimId;
                    srt.SRT_Time__c = (NonSRT.SRTTime!=null && NonSRT.SRTTime!='')?Double.valueOf(NonSRT.SRTTime):0;
                    /*if(accSet != null && !accSet.Contains(NonSRT.AccountCode.trim()) && claimsRecList[0].Information_Only_Claim__c==false){
            if(NonSRT.percentRequested < claimsRecList[0].ODM_Penalty__c) 
            //srt.isUserEntered__c = true;
        }*/
                    srt.srt_warrantable__c = NonSRT.percentRequested; // story 155910
                    srt.isUserEntered__c = NonSRT.isUserEntered; //story 183955
                    srt.SRT_Warrantable__c = (NonSRT.percentRequested!=null && NonSRT.percentRequested != '') ? NonSRT.percentRequested:'0';
                    srt.SRT_Notes__c = NonSRT.Notes;
                    srt.SRT_Quantity__c = 1;
                    srt.isPerformed__c = true;
                    system.debug('--**NonSRT.SRTTime**--'+NonSRT.SRTTime);
                    system.debug('--**NonSRT.percentRequested**--'+NonSRT.percentRequested);
                    Decimal cHours;
                    if(NonSRT.SRTTime!=null && NonSRT.SRTTime!=''&&NonSRT.percentRequested!=null && NonSRT.percentRequested != ''){
                        cHours = ((Decimal.valueOf(NonSRT.SRTTime)*Decimal.valueOf(NonSRT.percentRequested))/100).setScale(1,RoundingMode.HALF_UP);
                    }
                    system.debug('--**cHours**--'+cHours);
                    //srt.Claimed_Hours__c = (NonSRT.SRTTime!=null && NonSRT.SRTTime!=''&&NonSRT.percentRequested!=null && NonSRT.percentRequested != '')?((Decimal.valueOf(NonSRT.SRTTime)*Decimal.valueOf(NonSRT.percentRequested)).setScale(1)/100):0;
                    srt.Claimed_Hours__c = cHours;
                    SRTList.add(srt);
                } 
                else {
                    if(NonSRT.srtId != null)
                        deleteSRTIds.add(NonSRT.srtId);
                }
                system.debug('--**NonSRT.SRTTime**--'+NonSRT.SRTTime);
                system.debug('--**NonSRT.Notes**--'+NonSRT.Notes);
                system.debug('--**NonSRT.percentRequested**--'+NonSRT.percentRequested);
                //Removed percentageRequested mandatory condition below as per defect 173668
                //if((NonSRT.SRTTime != null && NonSRT.SRTTime != '' && (NonSRT.Notes == null || NonSRT.Notes == '')) || (NonSRT.Notes != null && NonSRT.Notes != '' && (NonSRT.SRTTime == null || NonSRT.SRTTime == '')) || (NonSRT.percentRequested != null && NonSRT.percentRequested != '' && (NonSRT.SRTTime == null || NonSRT.SRTTime == '' || NonSRT.Notes == null || NonSRT.Notes == ''))){
                if((NonSRT.SRTTime != null && NonSRT.SRTTime != '' && (NonSRT.Notes == null || NonSRT.Notes == '')) || (NonSRT.Notes != null && NonSRT.Notes != '' && (NonSRT.SRTTime == null || NonSRT.SRTTime == ''))){
                    system.debug('--**chkReqField**--'+chkReqField);
                    chkReqField = true;
                    ErrorMessage1 = true;
                    system.debug('--**ErrorMessage1**--'+ErrorMessage1);
                    return null;
                }
            }

            if(accCodePerCov != null){ 
                for(String perCov : accCodePerCov.keyset()){
                    Set<String> tempLst = new Set<String>();
                    tempLst = accCodePerCov.get(perCov);
                    if(tempLst != null && tempLst.size() > 1){
                        requestederr = true;
                        return null;
                    }

                }
            }

            CSS_SRT__c[] deleteSRT = [select Id from CSS_SRT__c where Id IN :deleteSRTIds];

            if(SRTList != null && SRTList.size() > 0) 
                upsert SRTList;
            system.debug('savedSRTList' + SRTList);

            if(deleteSRT != null && deleteSRT.size() > 0)     
                delete deleteSRT; 


        } catch(Exception e) {
            system.debug('Error in Cust SRT Save Component ## ' + e.getmessage() + e.getLineNumber());
        }
        ErrorMessage1 = false;
        requestederr = false;
        // below code for calling  covLimitValidationSRT Method as per story #179802 Aladdin sprint,-By RAJESH 02 Apr 2019 
        try {           //Added TRY & CATCH condition by Krishna for GSSC-191
             if(claimsRecList != null && claimsRecList.size() > 0) {             //Added null condition by Krishna for GSSC-191
                if(((claimsRecList[0].CSS_Job__c != null || claimsRecList[0].Dealer_Service_Job__c != null) && dealerUserLocation==true ) || (claimsRecList[0].CSS_Job__c == null || claimsRecList[0].Dealer_Service_Job__c == null)){
                    CG_CL_CoverageLimitExceedValidation callingSRTClaimedHour= new CG_CL_CoverageLimitExceedValidation();
                    system.debug('****class called above method****');
                    callingSRTClaimedHour.covLimitValidationSRT(null,claimId);
                    system.debug('****called above method****');
                    callingSRTClaimedHour.covLimitfailcodeValidation(null,claimId);
                }
             }
        } catch(Exception ex) {
            system.debug('in the exception of claimsRecList ---> JobPlan Controller Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }
        // End code for calling  covLimitValidationSRT Method as per story #179802 Aladdin sprint,-By RAJESH 02 Apr 2019
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        pageRef = new PageReference(sDestURL+'id='+claimId); 
        system.debug('sDestURL' + sDestURL);
        pageRef.setRedirect(true);
        return pageRef; 
    }


    //Wrapper.
    public class NonSRTWrapper {
        public Integer Count { get; set; }
        public string srtId { get; set; }
        public string SRTCode { get; set; }
        public string SRTTime { get; set; }
        public string percentRequested { get; set; }
        public string claimedhours { get; set; }
        public string failCode { get; set; }
        public string accountCode { get; set; }
        public string Notes { get; set; }
        public boolean isRemove { get; set; }//No need as of now.
        public boolean isperformed { get; set; }
        public boolean isUserEntered{get;set;}
        public NonSRTWrapper(Integer Count, string srtId, string SRTCode, string SRTTime, string percentRequested, string claimedhours,string failCode, string accountCode, string Notes, boolean isperformed, boolean isUserEntered) {
            this.Count = Count;
            this.srtId = srtId;
            this.SRTCode = SRTCode;
            this.SRTTime = SRTTime;
            this.percentRequested = percentRequested;
            this.claimedhours = claimedhours;
            this.failCode = failCode;
            this.accountCode = accountCode;
            this.Notes = Notes;
            this.isperformed = isperformed;
            this.isUserEntered = isUserEntered;
        }
    }

    public pageReference saveNonSRTMethod(){
        system.debug('inside saveSRTMethod');
        PageReference pageRef;
        TotalSRTTime=0.0;
        system.debug('**Before Update existingNonSRTList**'+existingNonSRTList);
        system.debug('**Before size of  existingNonSRTList**'+existingNonSRTList.size());
        if(existingNonSRTList.size() > 0){
            update existingNonSRTList;
            system.debug('**inside Update existingNonSRTList**'+existingNonSRTList);
            existingNonSRTList = [select Id, Account_Code_Description__c, FailCode__c, Fail_Code_Description__c, SRT_Time__c, SRT_Notes__c,SRT_Estimate__c,                  
                                  isPerformed__c,SRT_Warrantable__c,Claimed_Hours__c,Extended_Hours__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c  from CSS_SRT__c 
                                  where css_claims__c=:claimId AND Type__c='99Time' AND Fail_Code_Description__c != null];
        }
        system.debug('**After Update existingNonSRTList**'+existingNonSRTList);
        for(CSS_SRT__c existing : existingNonSRTList) {
            if((existing.Claimed_Hours__c) != null && (existing.Claimed_Hours__c) != 0.0 && existing.isPerformed__c==true) {
                TotalSRTTime += existing.Claimed_Hours__c;
            }
        }
        system.debug('** Final TotalSRTTime**'+TotalSRTTime);
        //return null;
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        pageRef = new PageReference(sDestURL+'id='+claimId); 
        system.debug('sDestURL' + sDestURL);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public pageReference resetNonSRTMethod(){
        system.debug('inside resetNonSRTMethod');
        existingNonSRTList = [select Id, Account_Code_Description__c, FailCode__c, Fail_Code_Description__c, SRT_Time__c, SRT_Notes__c,SRT_Estimate__c,                  
                              isPerformed__c,SRT_Warrantable__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,Claimed_Hours__c,Extended_Hours__c from CSS_SRT__c 
                              where CSS_Claims__c=:claimId AND Type__c='99Time' AND Fail_Code_Description__c != null];
        return null;
    }
}