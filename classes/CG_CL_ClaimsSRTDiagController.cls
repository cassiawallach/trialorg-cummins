public class CG_CL_ClaimsSRTDiagController {

    //public List<srtWrapper> diagList{get;set;}
    public srtWrapper srtDiag;

    Transient List<CSS_Srt__c> SRTList = new List<CSS_Srt__c>();
    Transient List<CSS_Solution_Component__c> compList = new List<CSS_Solution_Component__c>();
    public decimal totalDecimalTimediag{get;set;}
    public decimal totalDecimalTimeAccTot{get;set;}
    public list<sortWrapper> diagListWrap{get;set;}
    List<CSS_SRT__c> lstSRTinsert;
    Map<String,String> failCodeFailureName = new Map<String,String>();
    public ID CID{get;set;}
    public Boolean isAutomatedClaim{get;set;}
    public Boolean isCatastrophic{get;set;}
    public boolean checklaborrate{get;set;}
    public Map<id,List<SelectOption>> mapaccesscode{get;set;}//Added as part of the story#172627
    public string selAccCode{get;set;}
    public string selSRTID{get;set;}
    public string selCoveredVal{get;set;}
    public List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
    public Set<String> accSet;
    public List<CSS_Claims__c> claimsRecList {get;set;}
    public Boolean PenaltyExists{get;set;}
    public Map<string,string> pwPenaltyMap; //Added as per story 180325
    public Map<string,string> pwPenaltyAccCodeMap; //Added as per story 180325
    public Map<string,String> SolcompCoveredlaborMap;// Added as part of GSSC -57
    public Boolean isDiagRepSRTCovered{get;set;}
    public decimal timediag=0.0;
    public decimal diagAccTime=0.0;
    public List<CSS_SRT__c> overlapSRT = new List<CSS_SRT__c>();
    public Transient List<CSS_SRT__c> srtListNew = new List<CSS_SRT__c>();
    public String EquipmentIdDiag;

    public CG_CL_ClaimsSRTDiagController(){
        isDiagRepSRTCovered = true;
        isAutomatedClaim = false;
        isCatastrophic = false;
        checklaborrate=true;
        CID=ApexPages.CurrentPage().getParameters().get('id');
        mapaccesscode = new map<id,list<selectoption>>();//Added as part of story#172627
        system.debug('cid***'+CID);
        try{
            if(CID!=null){
                claimsRecList = new List<CSS_Claims__c>([Select Id ,Name, CSS_Job__c,Total_PSN_Count__c,SP_INSHOP_LABOR_RATE__c, Catastrophic__c,ODM_Penalty__c,Information_Only_Claim__c,(select id,Equipment_ID__c from CSS_PSNs__r)  from CSS_Claims__c where Id=:CID]);
                EquipmentIdDiag = claimsRecList[0].CSS_PSNs__r[0].Equipment_ID__c;
                system.debug('EquipmentIdDiag' + EquipmentIdDiag);
                /*    if(claimsRecList != null && claimsRecList.size()>0)
                    isCatastrophic=claimsRecList[0].Catastrophic__c;

                if(claimsRecList !=null && claimsRecList.size()>0){
                    isAutomatedClaim = true;
                } */

                if(claimsRecList !=null && claimsRecList.size()>0){
                    isCatastrophic=claimsRecList[0].Catastrophic__c;
                    if(claimsRecList[0].CSS_Job__c !=null)
                        isAutomatedClaim = true;
                    if(string.isBlank(claimsRecList[0].SP_INSHOP_LABOR_RATE__c) || (string.isNotBlank(claimsRecList[0].SP_INSHOP_LABOR_RATE__c) && double.valueOf(claimsRecList[0].SP_INSHOP_LABOR_RATE__c)==0))
                    {
                        checklaborrate=false;
                        system.debug('Test Labor'+checklaborrate);
                    }
                    //Story 155910 Added below condition
                    if(claimsRecList[0].Information_Only_Claim__c == false && claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '' && integer.valueof(claimsRecList[0].ODM_Penalty__c) > 0)
                        PenaltyExists = true;
                }

                SRTList = [select Calculated_Claimed_Hours__c,SRT_Usage__c,SRT_Warrantable__c,Extended_Hours__c,CSS_Claims__c,CSS_Claims__r.AccessCode__c,name,SRT_ID__c,Repair_Access_Calculated__c,Additional_SRT_Calculated__c,Diagnosis_Time__c,SRT_Decimal_Time__c,id,step_id__c,SRT_Time__c,Component_Id__c ,Component_Id__r.name,Type__c,Response_Message__c ,Repair_Time__c,Access_Code_A__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__r.Name,
                           Solution_Number__r.Diagnostic_Response__c,Assignment__c,SRT_Status_Message__c,SRT_Title__c ,isPerformed__c,SRT_Quantity__c,SRT_Notes__c ,Access_Code_Flag__c,SRT_Warrantable_Flag__c,
                           Access_Code_B__c,Account_Code__c,AccountCode_Formula__c,Failure_Name__c,FailCode__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Access_Code_S1__c,Access_Code_S2__c,Access_Code_S3__c,Access_Code_S4__c,Access_Code_S5__c,Access_Code_S6__c,Access_Code_S7__c,Access_Code_S8__c,Access_Code_S9__c,S1_Description__c,S2_Description__c,S3_Description__c,S4_Description__c,Diag_Access_Time__c,
                           S5_Description__c,srt_category__c,Flex_Flag__c,IsPopUpSRT__c,Symptom_Name__c,Fault_Code_Name__c,SRT_Access_Code__c,Access_Code__c,S6_Description__c,S7_Description__c,S8_Description__c,S9_Description__c,Special_Access_Code__c,Special_Access_Code_Desc__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code_Saved__c,Claimed_Hours__c,isUserEntered__c from CSS_SRT__c where css_claims__c =:CID order by SRT_Order__c asc];
                system.debug('Testsrt'+SRTList);

                compList = [SELECT Id, Name, FailCode_Formula__c, Fail_Code__c, CSS_Account_Formula__c, Covered_Labor__c,ODM_Penalty__c FROM CSS_Solution_Component__c WHERE CSS_Claims__c =:CID AND Fail_Code__c != null AND CSS_Account_Formula__c != null];
            }
            for(CSS_Solution_Component__c cList: compList){
                if(!failCodeFailureName.containsKey(cList.Fail_Code__c))
                    failCodeFailureName.put(cList.Fail_Code__c,cList.Name);
            }

            if(SRTList!=null && !SRTList.isEmpty()){
                //diagList = new list<srtWrapper>();
                diagListWrap= new list<sortWrapper>();
                for(CSS_SRT__c srt:SRTList){
                    system.debug('Testsrt>>>'+srt);
                    system.debug('srt.solution_number__c>>'+srt.solution_number__c +'srt.solution_number__r.Diagnostic_Response__c'+srt.solution_number__r.Diagnostic_Response__c);


                    if(srt.Type__c == 'Overlap'){
                        overlapSRT.add(srt);
                    }
                    else if(srt.Type__c == 'Diagnosis' || srt.Type__c == 'Repair' || srt.Type__c == 'Diag Access' || srt.Type__c == 'Repair Access' || srt.Type__c == 'Admin' || srt.Type__c == 'Field Action' || srt.Type__c == 'Field Action Access'){
                        srtListNew.add(srt);
                    }
                    //Below code is added for story#172627
                    if(!mapaccesscode.containsKey(srt.id))
                        mapaccesscode.put(srt.id,new list<selectoption>());
                    //end

                    system.debug('srt.solution_number__c'+srt.solution_number__c +'srt.solution_number__r.Diagnostic_Response__c'+srt.solution_number__r.Diagnostic_Response__c);
                    if(srt.solution_number__c != null && srt.solution_number__r.Diagnostic_Response__c!=null){
                        system.debug('srt.Type__c'+srt.Type__c);
                        if(srt.Type__c != null && srt.Type__c != '' && (srt.Type__c.equalsIgnoreCase('Diagnosis') || srt.Type__c.equalsIgnoreCase('Diag Access')) && (srt.srt_category__c == null || srt.srt_category__c == '')){//&& srt.srt_category__c == null
                            system.debug('Anirudh Entered claims srt diag');
                            srtDiag = new srtWrapper();
                            srtDiag.sId = srt.Id;
                            srtDiag.solTitle = srt.Solution_Title__c;
                            srtDiag.solTitle = srtDiag.solTitle.replace('<br />','');
                            srtDiag.solNum = srt.solution_number__r.Name;
                            srtDiag.fautCodeName = srt.Fault_Code_Name__c ;
                            srtDiag.srtWarrantable= srt.SRT_Warrantable__c;
                            srtDiag.symptomName = srt.Symptom_Name__c ;
                            srtDiag.srtType = srt.Type__c;
                            srtDiag.flexFlag = srt.Flex_Flag__c;
                            srtDiag.srtUsage = srt.SRT_Usage__c;
                            //Added below condition for not displaying 'Select One'
                            if(srt.FailCode__c!='Select One')
                                srtDiag.failcode = srt.FailCode__c;
                            else
                                srtDiag.failcode='';
                            /*if(srt.Failure_Name__c!=null)
                                srtDiag.Failure = srt.Failure_Name__c;
                            else
                                srtDiag.Failure = srt.Component_Id__r.name;*/
                            if(srt.FailCode__c != null && srt.FailCode__c != '')
                                srtDiag.Failure = failCodeFailureName.get(srt.FailCode__c);
                            system.debug('srt.Access_Code__c>>>'+srt.Access_Code__c);
                            system.debug('srt.CSS_Claims__r.AccessCode__c>>>'+srt.CSS_Claims__r.AccessCode__c);

                            srtDiag.AccessCodeSaved  = srt.Job_Engine_Access_Code__c;
                            //Below code added for story#172627
                            if(srt.Access_Code__c == null || srt.Access_Code__c == '' || string.isBlank(srt.Access_Code__c)){ //Settingup Default Value for the story#172627.
                                srtDiag.AccessCode  = srt.Job_Engine_Access_Code__c;
                                srt.Access_Code__c=srt.Job_Engine_Access_Code__c;
                            }
                            else{
                                srtDiag.AccessCode  = srt.Access_Code__c;
                            }
                            CG_UtilityForSRT srtdiagaccesscodecls = new CG_UtilityForSRT();
                            list<selectoption> DiagAccesscodetmp = srtdiagaccesscodecls.getAccesscodeclaimoption(string.valueOf(srt.Access_Code_A__c),string.valueOf(srt.Access_Code_B__c),string.valueOf(srt.Access_Code_C__c),string.valueOf(srt.Access_Code_D__c),string.valueOf(srt.Access_Code_R__c),srt.CSS_Claims__r.AccessCode__c,srt.SRT_Access_Code__c,'Diag',srt.IsPopUpSRT__c);
                            if(DiagAccesscodetmp.size()>0)
                                mapaccesscode.put(srt.Id,DiagAccesscodetmp);

                            //end
                            srtDiag.accountcode = srt.AccountCode_Formula__c; //srt.Account_Code__c;
                            srtDiag.srtID = srt.SRT_ID__c;
                            srtDiag.srtDescription = srt.SRT_Title__c;
                            srtDiag.Quantity = srt.SRT_Quantity__c;
                            srtDiag.ClaimedHrs = (srt.Extended_Hours__c != null ? srt.Extended_Hours__c : 0.0);
                            srtDiag.IsPopUpSRT = srt.IsPopUpSRT__c;
                            srtDiag.sortOrder =srt.SRT_Order__c;
                            srtDiag.accessCodeFlag = srt.Access_Code_Flag__c != null && srt.Access_Code_Flag__c ==true ? true : false;
                            srtDiag.percentReqFlag = srt.SRT_Warrantable_Flag__c != null && srt.SRT_Warrantable_Flag__c ==true ? true : false;
                            //srtDiag.isUserEntered = srt.isUserEntered__c; //155910
                            srtDiag.isUserEntered = srt.isUserEntered__c != null && srt.isUserEntered__c ==true ? true : false;
                            srtDiag.stepId = srt.step_id__c; // GSSC -20

                            system.debug('Testsrt1'+srt.Type__c);
                            if(srt.Type__c.equalsIgnoreCase('Diagnosis')){ 
                                srtDiag.srtCheckBox = srt.isPerformed__c;
                                srtDiag.srtTime = srt.Diagnosis_Time__c;
                                system.debug('timediag>>>>'+srt.Extended_Hours__c);
                                if(srt.isPerformed__c == true)
                                    timediag = timediag + (srt.Extended_Hours__c != null ? srt.Extended_Hours__c : 0.0); //(srt.Diagnosis_Time__c * srt.SRT_Quantity__c);
                                system.debug('timediag>>>>'+timediag);
                            }

                            if(srt.Type__c.equalsIgnoreCase('Diag Access')){
                                system.debug('MySRTID**'+srtDiag.srtID);
                                system.debug('MySRTID**'+srt.Diag_Access_Time__c);
                                srtDiag.srtAccessTime = srt.Diag_Access_Time__c;
                                srtDiag.accessSrtCheckBox = srt.SRT_AccessiblityCheck__c;
                                if(srt.SRT_AccessiblityCheck__c == true)
                                    timediag = timediag + (srt.Extended_Hours__c != null ? srt.Extended_Hours__c : 0.0);
                                //Below code usage is stopped i.e., diagAccTime
                                if(srt.SRT_AccessiblityCheck__c){
                                    diagAccTime = diagAccTime + (srt.Diag_Access_Time__c * srt.SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633
                                    system.debug('diagAccTime>>>>'+diagAccTime);
                                }
                            }
                            if(srtDiag != null){
                                //diagList.add(srtDiag);
                                diagListWrap.add(new sortWrapper(srtDiag));
                                system.debug('diagListWrap>>>'+diagListWrap);
                            }
                        }

                    } 


                    if((srt.srt_category__c!= null && srt.srt_category__c.equalsIgnoreCase('AdditionalDiag'))){ 
                        system.debug('SRTID**'+srt.srt_id__c);
                        srtDiag = new srtWrapper();
                        srtDiag.solTitle = '';
                        srtDiag.solNum = '';
                        srtDiag.fautCodeName = '' ;
                        srtDiag.symptomName = '';
                        srtDiag.sId = srt.Id;
                        srtDiag.ClaimedHrs = (srt.Extended_Hours__c != null ? srt.Extended_Hours__c : 0.0);
                        srtDiag.srtWarrantable= (srt.SRT_Warrantable__c != null ? srt.SRT_Warrantable__c : '0'); //string.valueOf(srt.SRT_Hours_Percentage__c));
                        srtDiag.srtType = srt.Type__c;
                        srtDiag.flexFlag = srt.Flex_Flag__c;
                        srtDiag.srtUsage = srt.SRT_Usage__c;
                        if(srt.FailCode__c != null && srt.FailCode__c != '')
                            srtDiag.Failure = failCodeFailureName.get(srt.FailCode__c);

                        srtDiag.AccessCodeSaved  = srt.Job_Engine_Access_Code__c;

                        //Below code added for story#172627
                        if(string.isBlank(srt.Access_Code__c)) //Setting up default value for admin SRT.
                        {
                            if( srt.Access_Code_A__c==0 && srt.Access_Code_B__c==0 && srt.Access_Code_C__c==0 && srt.Access_Code_D__c==0 && srt.Access_Code_R__c!=0)
                            {
                                srtDiag.AccessCode  = 'R';
                                srt.Access_Code__c='R';
                            }
                            else
                            {
                                srtDiag.AccessCode=srt.Job_Engine_Access_Code__c;
                                srt.Access_Code__c=srt.Job_Engine_Access_Code__c;
                            }
                        }
                        else{
                            srtDiag.AccessCode  = srt.Access_Code__c;
                        }
                        //Note:- Above default value logic written for Admin SRT,
                        //For Diag,It's getting setting up save method of the editpopup.
                        CG_UtilityForSRT srtdiagaccesscodecls = new CG_UtilityForSRT();
                        list<selectoption> AddDiagAccesscodetmp = srtdiagaccesscodecls.getAccesscodeclaimoption(string.valueOf(srt.Access_Code_A__c),string.valueOf(srt.Access_Code_B__c),string.valueOf(srt.Access_Code_C__c),string.valueOf(srt.Access_Code_D__c),string.valueOf(srt.Access_Code_R__c),srt.CSS_Claims__r.AccessCode__c,srt.SRT_Access_Code__c,'Additional',srt.IsPopUpSRT__c);
                        if(AddDiagAccesscodetmp.size()>0)
                            mapaccesscode.put(srt.Id,AddDiagAccesscodetmp);

                        //end               
                        srtDiag.accountcode = srt.AccountCode_Formula__c; //srt.Account_Code__c;
                        srtDiag.srtID = srt.SRT_ID__c;
                        srtDiag.srtDescription = srt.SRT_Title__c;
                        srtDiag.Quantity = srt.SRT_Quantity__c;
                        //Added below condition for not displaying 'Select One'
                        if(srt.FailCode__c!='Select One')
                            srtDiag.failcode = srt.FailCode__c;
                        else
                            srtDiag.failcode='';
                        srtDiag.IsPopUpSRT = srt.IsPopUpSRT__c;
                        srtDiag.sortOrder =srt.SRT_Order__c;
                        srtDiag.accessCodeFlag = srt.Access_Code_Flag__c != null && srt.Access_Code_Flag__c ==true ? true : false;
                        srtDiag.percentReqFlag = srt.SRT_Warrantable_Flag__c != null && srt.SRT_Warrantable_Flag__c ==true ? true : false;

                        //if(srt.type__c != null && srt.type__c.equalsIgnoreCase('Access')){
                        if(srt.type__c != null && (srt.type__c.equalsIgnoreCase('Access') || srt.type__c.equalsIgnoreCase('Diag Access'))){ //Added Diag Access Condition as per defect 173341
                            srtDiag.accessSrtCheckBox = srt.SRT_AccessiblityCheck__c; //new line added
                            srtDiag.srtAccessTime = srt.Additional_SRT_Calculated__c; //srtDiag.srtAccessTime = srt.Diag_Access_Time__c;
                            if(srt.SRT_AccessiblityCheck__c == true)
                                timediag = timediag + (srt.Extended_Hours__c != null ? srt.Extended_Hours__c : 0.0);
                            //Below code usage is stopped i.e., diagAccTime
                            if(srt.SRT_AccessiblityCheck__c == true)
                                diagAccTime = diagAccTime+(srt.Additional_SRT_Calculated__c * Srt.SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633;
                        }
                        if(srt.type__c != null && srt.type__c != 'Access' && srt.type__c != 'Diag Access'){  //Added Diag Access Condition as per defect 173341
                            srtDiag.srtCheckBox = srt.isPerformed__c; //new line added
                            srtDiag.srtTime = srt.Additional_SRT_Calculated__c;
                            if(srt.isPerformed__c == true)
                                timediag = timediag + (srt.Extended_Hours__c != null ? srt.Extended_Hours__c : 0.0); //(srt.Additional_SRT_Calculated__c * srt.SRT_Quantity__c);
                            system.debug('Test*'+timediag);

                        }
                        //srtDiag.isUserEntered = srt.isUserEntered__c; //155910
                        srtDiag.isUserEntered = srt.isUserEntered__c != null && srt.isUserEntered__c ==true ? true : false;
                        srtDiag.stepId = srt.step_id__c; // GSSC -20
                        if(srtDiag != null){
                            //diagList.add(srtDiag);
                            diagListWrap.add(new sortWrapper(srtDiag));
                            system.debug('diagListWrap>>>'+diagListWrap);
                        }
                    } 
                    //story 166107
                    if(srt.solution_number__c==null){
                        system.debug('srt.solution_number__c>>>'+srt.solution_number__c);
                        if((srt.Type__c.equalsIgnoreCase('Repair') || srt.Type__c.equalsIgnoreCase('Repair Access'))&& srt.srt_category__c == null &&  srt.Assignment__c.equalsIgnoreCase('Diagnostic')){
                            srtDiag = new srtWrapper();
                            srtDiag.sId = srt.Id;
                            srtDiag.solTitle = srt.Solution_Title__c;
                            //srtDiag.solTitle = srtDiag.solTitle.replace('<br />','');
                            srtDiag.solNum = srt.solution_number__r.Name;
                            srtDiag.fautCodeName = srt.Fault_Code_Name__c ;
                            srtDiag.srtWarrantable= srt.SRT_Warrantable__c;
                            srtDiag.symptomName = srt.Symptom_Name__c ;
                            srtDiag.srtType = srt.Type__c;
                            srtDiag.flexFlag = srt.Flex_Flag__c;
                            srtDiag.srtUsage = srt.SRT_Usage__c;
                            //Added below condition for not displaying 'Select One'
                            if(srt.FailCode__c!='Select One')
                                srtDiag.failcode = srt.FailCode__c;
                            else
                                srtDiag.failcode='';
                            /*if(srt.Failure_Name__c!=null)
                                srtDiag.Failure = srt.Failure_Name__c;
                            else
                                srtDiag.Failure = srt.Component_Id__r.name;*/
                            if(srt.FailCode__c != null && srt.FailCode__c != '')
                                srtDiag.Failure = failCodeFailureName.get(srt.FailCode__c);
                            else
                                srtDiag.Failure = srt.Component_Id__r.name;
                            system.debug('srt.Access_Code__c>>>'+srt.Access_Code__c);
                            system.debug('srt.CSS_Claims__r.AccessCode__c>>>'+srt.CSS_Claims__r.AccessCode__c);

                            srtDiag.AccessCodeSaved  = srt.Job_Engine_Access_Code__c;

                            //Below code added for story#172627
                            if(srt.Access_Code__c == null || srt.Access_Code__c == '' || string.isBlank(srt.Access_Code__c)){ //Settingup Default Value for the story#172627.
                                srtDiag.AccessCode  = srt.Job_Engine_Access_Code__c;
                                srt.Access_Code__c=srt.Job_Engine_Access_Code__c;
                            }
                            else{
                                srtDiag.AccessCode  = srt.Access_Code__c;
                            }
                            CG_UtilityForSRT srtdiagaccesscodecls = new CG_UtilityForSRT();
                            list<selectoption> DiagAccesscodetmp = srtdiagaccesscodecls.getAccesscodeclaimoption(string.valueOf(srt.Access_Code_A__c),string.valueOf(srt.Access_Code_B__c),string.valueOf(srt.Access_Code_C__c),string.valueOf(srt.Access_Code_D__c),string.valueOf(srt.Access_Code_R__c),srt.CSS_Claims__r.AccessCode__c,srt.SRT_Access_Code__c,'Diag',srt.IsPopUpSRT__c);
                            if(DiagAccesscodetmp.size()>0)
                                mapaccesscode.put(srt.Id,DiagAccesscodetmp);

                            //end

                            srtDiag.accountcode = srt.AccountCode_Formula__c; //srt.Account_Code__c;
                            srtDiag.srtID = srt.SRT_ID__c;
                            srtDiag.srtDescription = srt.SRT_Title__c;
                            srtDiag.Quantity = srt.SRT_Quantity__c;
                            srtDiag.ClaimedHrs = (srt.Extended_Hours__c != null ? srt.Extended_Hours__c : 0.0);
                            srtDiag.IsPopUpSRT = srt.IsPopUpSRT__c;
                            srtDiag.sortOrder =srt.SRT_Order__c;
                            srtDiag.accessCodeFlag = srt.Access_Code_Flag__c != null && srt.Access_Code_Flag__c ==true ? true : false;
                            srtDiag.percentReqFlag = srt.SRT_Warrantable_Flag__c != null && srt.SRT_Warrantable_Flag__c ==true ? true : false;

                            if(srt.Type__c.equalsIgnoreCase('Repair')){ 
                                srtDiag.srtCheckBox = srt.isPerformed__c;
                                srtDiag.srtTime = srt.Diagnosis_Time__c;
                                if(srt.isPerformed__c == true)
                                    timediag = timediag + (srt.Extended_Hours__c != null ? srt.Extended_Hours__c : 0.0); //(srt.Diagnosis_Time__c * srt.SRT_Quantity__c);

                                system.debug('Test**'+timediag);
                            }

                            if(srt.Type__c.equalsIgnoreCase('Repair Access')){
                                srtDiag.srtAccessTime = srt.Diag_Access_Time__c;
                                //srtDiag.accessSrtCheckBox = srt.SRT_AccessiblityCheck__c;
                                if(srt.SRT_AccessiblityCheck__c){
                                    diagAccTime = diagAccTime + (srt.Diag_Access_Time__c * srt.SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633
                                }
                            }
                            //srtDiag.isUserEntered = srt.isUserEntered__c; //155910
                            srtDiag.isUserEntered = srt.isUserEntered__c != null && srt.isUserEntered__c ==true ? true : false;
                            srtDiag.stepId = srt.step_id__c; // GSSC -20
                            if(srtDiag != null){
                                //diagList.add(srtDiag);
                                diagListWrap.add(new sortWrapper(srtDiag));
                                system.debug('diagListWrap>>>'+diagListWrap);
                            }
                        }

                    }

                } // for loop
                diagListWrap.sort();
            }   
            totalDecimalTimediag = timediag; 
            system.debug('Testtime'+totalDecimalTimediag);
            totalDecimalTimeAccTot = diagAccTime;
            //Kalpana story 155910
            //jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' and Attribute1__c IN ('POL','NPW','RPW')];
            jobEventTemp = css_utility.getJobEventTempPolicy();
            accSet = new Set<String>();
            Set<String> accSetPW = new Set<String>();
            pwPenaltyMap = new Map<string,string>();
            pwPenaltyAccCodeMap = new Map<string,string>();
            SolcompCoveredlaborMap = new Map<String,String>();
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
            //Commented below query after changing below for loop variable to avoid reduce 1 query
            //List<CSS_Solution_Component__c> solCompList = [select id,fail_code__c,FailCode_Formula__c,ODM_Penalty__c,CSS_Account_Formula__c from css_solution_component__C where css_claims__c = :cId];
            for(CSS_Solution_Component__c sc:compList){
                if(sc.ODM_Penalty__c != null && sc.ODM_Penalty__c != '' && integer.valueof(sc.ODM_Penalty__c) > 0 && (sc.CSS_Account_Formula__c != null && sc.CSS_Account_Formula__c != '') && accSetPW.contains(sc.CSS_Account_Formula__c.trim()))
                    pwPenaltyMap.put(sc.fail_code__c+sc.CSS_Account_Formula__c,sc.ODM_Penalty__c);
                pwPenaltyAccCodeMap.put(sc.fail_code__c+sc.CSS_Account_Formula__c,sc.ODM_Penalty__c);
                SolcompCoveredlaborMap.put(sc.fail_code__c+sc.CSS_Account_Formula__c,sc.Covered_Labor__c);
            }
            //Story 180325 -- END
            if(diagListWrap != null && diagListWrap.size() > 0){
                isDiagRepSRTCovered = true;
            }
            else{
                CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
                List<Boolean> coverageResult = new List<Boolean>();
                coverageResult = contr.checkFailuresCovered(Cid, false);
                system.debug('coverageResult--'+coverageResult);
                isDiagRepSRTCovered = coverageResult[3];
                system.debug('isDiagRepSRTCovered--'+isDiagRepSRTCovered);
            }
        }
        catch(Exception e){
            System.debug('The error in srt is'+e.getMessage()+e.getLineNumber());
        }

        System.debug('SOQL Count so far Diag SRT ' + Limits.getQueries());
    }
    public boolean SavingFlag{get;set;}
    public void SRTPercReq(){
        SavingFlag = true;
        system.debug('inPercentReq**'+selCoveredVal);
        system.debug('inPercentReq1**'+selSRTID);
        //system.debug('inPercentReq2**'+srt.srtRec.srtWarrantable);
        if(diagListWrap != null && !diagListWrap.isEmpty()){
            String failurePenalty;
            string coveredlaborvalsol;
            for(sortwrapper srt:diagListWrap){
                if(selSRTID == srt.srtRec.srtid){
                    system.debug('inPercentReq**'+srt.srtRec.accountcode);
                    system.debug('inPercentReq2**'+srt.srtRec.srtWarrantable);
                    system.debug('accSet**'+accSet);
                    system.debug('failurePenalty**'+failurePenalty);
                    system.debug('claimsRecList[0].ODM_Penalty__c **'+claimsRecList[0].ODM_Penalty__c);

                    srt.srtRec.isUserEntered=true;
                    //Story 180325 added below pwPenaltyMap code
                    if(pwPenaltyMap != null && pwPenaltyMap.size() > 0 && (srt.srtRec.accountcode != null && srt.srtRec.accountcode != '') && claimsRecList[0].Information_Only_Claim__c==false){
                        if(srt.srtRec.failcode != null && srt.srtRec.failcode != '')
                            failurePenalty = pwPenaltyMap.get(srt.srtRec.failcode.trim()+srt.srtRec.AccountCode.trim());

                        else
                            failurePenalty = pwPenaltyAccCodeMap.get(srt.srtRec.AccountCode.trim());
                        system.debug('srt.srtRec.srtWarrantable1**'+srt.srtRec.srtWarrantable);
                        if(failurePenalty != null && failurePenalty != '' && (((srt.srtRec.srtWarrantable != null && srt.srtRec.srtWarrantable != '') && integer.valueof(srt.srtRec.srtWarrantable)>integer.valueof(failurePenalty)) || (srt.srtRec.srtWarrantable == null || srt.srtRec.srtWarrantable == ''))){
                            srt.srtRec.srtWarrantable = failurePenalty;

                        }
                    }

                    else if(claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '' && integer.valueof(claimsRecList[0].ODM_Penalty__c) > 0){
                        system.debug('Karthiksecind'+selCoveredVal);
                        if(srt.srtRec.AccountCode != null && srt.srtRec.AccountCode != '' && accSet != null && !accSet.contains(srt.srtRec.AccountCode) && claimsRecList[0].Information_Only_Claim__c==false){
                            system.debug('insidekarthiksecondelseif');
                            if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                            {srt.srtRec.srtWarrantable = selCoveredVal;}

                            else 
                            {srt.srtRec.srtWarrantable = claimsRecList[0].ODM_Penalty__c;
                             srt.srtRec.isUserEntered=false;}
                        }

                        else if(srt.srtRec.AccountCode == null || srt.srtRec.AccountCode == '' && claimsRecList[0].Information_Only_Claim__c==false){
                            if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                            {srt.srtRec.srtWarrantable = selCoveredVal;}
                            else 
                            {srt.srtRec.srtWarrantable = claimsRecList[0].ODM_Penalty__c;
                             srt.srtRec.isUserEntered=false;}

                        }


                        else if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) >= 100)
                        {
                            system.debug('Karthikentered'+selCoveredVal);
                            srt.srtRec.srtWarrantable = string.valueof(100);srt.srtRec.isUserEntered=false;}

                    }
                    else if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) >= 100)
                    {srt.srtRec.srtWarrantable = string.valueof(100);srt.srtRec.isUserEntered=false;}

                    //Karthik G Added GssC-57
                    if(srt.srtRec.AccountCode != null && srt.srtRec.AccountCode != '' && accSet != null && claimsRecList[0].Information_Only_Claim__c==false){
                        coveredlaborvalsol = SolcompCoveredlaborMap.get(srt.srtRec.failcode.trim()+srt.srtRec.AccountCode.trim());

                        system.debug('insidekarthiksecondelseif>>>'+coveredlaborvalsol);
                        if((selCoveredVal != null && selCoveredVal != '' && coveredlaborvalsol!='' && coveredlaborvalsol!=null) && integer.valueof(selCoveredVal) < integer.valueof(coveredlaborvalsol)) // karthikG check covered labor from solcomp
                        {srt.srtRec.srtWarrantable = selCoveredVal;}

                        else if((selCoveredVal != null && selCoveredVal != '' && (coveredlaborvalsol=='' || coveredlaborvalsol==null)) && integer.valueof(selCoveredVal) <= 100)
                        {srt.srtRec.srtWarrantable = selCoveredVal;}
                        else if ((selCoveredVal != null && selCoveredVal != '' && (coveredlaborvalsol=='' || coveredlaborvalsol==null)) && integer.valueof(selCoveredVal) >= 100)
                        {
                            system.debug('karthik100');
                            srt.srtRec.srtWarrantable = string.valueof(100);srt.srtRec.isUserEntered=false;}
                        else 
                        {
                            system.debug('coveredlaborvalsol>>>'+coveredlaborvalsol);
                            srt.srtRec.srtWarrantable = coveredlaborvalsol; //  add solcomp coered labor 
                            srt.srtRec.isUserEntered=false;}
                    }
                    //karthik G Done
                    // break;
                }
            }
        }
    }

    /* Defect 190620 - Below is for calculating only Access SRT times which is not in use so we have commented.
   public void getDiagAccessTime(){
        try{
            system.debug('InsideDiagAcc**'+diagListWrap);
            decimal timediag=0.0;
            for(sortwrapper srt:diagListWrap){
                if(srt.srtRec.accessSrtCheckBox == true){
                    if(srt.srtRec.srtType.equalsIgnoreCase('Diag Access') || srt.srtRec.srtType.equalsIgnoreCase('Access')){
                        system.debug('InsideIf**'+srt.srtRec.srtid+srt.srtRec.srtType+'-'+srt.srtRec.srtAccessTime);
                        if(srt.srtRec.srtAccessTime != null){
                            system.debug('srt.srtRec.srtAccessTime**'+srt.srtRec.srtAccessTime);
                            timediag = timediag + srt.srtRec.srtAccessTime;
                        }
                    }
                }
            }
            system.debug('timediag>>>>>>>>>'+timediag);
            totalDecimalTimeAccTot = timediag;
        }catch(exception e){
            system.debug('Entered into catch block of getDiagAccessTime method in CSS_DARSRT Class'+e.getMessage() + ' ' + e.getLineNumber());
        }
    } */


    public void getdiagnosisTime(){

        decimal diagTime = 0.0;
        for(sortwrapper srt:diagListWrap){
            system.debug('InsideDiag**'+srt.srtRec.srtid);
            if(srt.srtRec.srtCheckBox == true || srt.srtRec.accessSrtCheckBox == true){
                //Defect 190620 - Commenting belwo line since we need to include all Acess SRT Times in total.
                // if(!srt.srtRec.srtType.equalsIgnoreCase('Diag Access') && !srt.srtRec.srtType.equalsIgnoreCase('Access')){
                if(srt.srtRec.ClaimedHrs != null)
                    diagTime = diagTime + srt.srtRec.ClaimedHrs; //srt.srtRec.srtTime;
                system.debug('Timevalue'+diagTime);

                // }
            }

        }
        totalDecimalTimediag =  diagTime;

    }

    public pageReference saveDiagData(){
        try{
            PageReference pageRef;
            List<String> srtIdList = new List<String>();
            list<CSS_SRT__c> updateSRTList = new list<CSS_SRT__c>();
            system.debug('Inside SAVE**'+diagListWrap);
            if(diagListWrap != null && !diagListWrap.isEmpty()){
                for(sortWrapper s:diagListWrap){
                    CSS_SRT__c srtUpdate = new CSS_SRT__c();
                    srtUpdate.Id = s.srtRec.sId;
                    srtUpdate.Access_Code__c = s.srtRec.AccessCode;

                    system.debug('s.srtRec.srtCheckBox--'+s.srtRec.srtCheckBox);
                    system.debug('s.srtRec.accessSrtCheckBox--'+s.srtRec.accessSrtCheckBox);
                    system.debug('s.srtRec.flexFlag--'+s.srtRec.flexFlag);

                    if(s.srtRec.flexFlag == true){
                        if(s.srtRec.srtType != 'Diag Access' && s.srtRec.srtType != 'Access'){
                            srtUpdate.SRT_Time__c = s.srtRec.srtTime;
                        }
                        else if(s.srtRec.srtType == 'Diag Access' || s.srtRec.srtType == 'Access'){
                            srtUpdate.SRT_Time__c = s.srtRec.srtAccessTime;
                        }

                    }

                    if(s.srtRec.accessSrtCheckBox != null)
                        srtUpdate.SRT_AccessiblityCheck__c = s.srtRec.accessSrtCheckBox;


                    if(s.srtRec.srtCheckBox != null)
                        srtUpdate.isPerformed__c = s.srtRec.srtCheckBox;

                    if((s.srtRec.srtType != 'Diag Access' && s.srtRec.srtType != 'Access') || s.srtRec.srtType == 'Admin' || s.srtRec.srtType == 'Repair' || s.srtRec.srtType == 'Diagnosis'){
                        if(s.srtRec.srtCheckBox == false){ 
                            system.debug('Inside IF Access');
                            srtUpdate.Extended_Hours__c = 0.0;
                        }
                    }else{ 
                        if(s.srtRec.accessSrtCheckBox == false){ 
                            system.debug('Inside IF Access');
                            srtUpdate.Extended_Hours__c = 0.0;
                        }
                    }

                    srtUpdate.SRT_Quantity__c = s.srtRec.quantity;
                    /* if(s.srtRec.AccountCode != null && s.srtRec.AccountCode != '' && accSet != null && !accSet.Contains(s.srtRec.AccountCode.trim()) && claimsRecList[0].Information_Only_Claim__c==false){
                        if((s.srtRec.srtWarrantable != null && s.srtRec.srtWarrantable != '') && (claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '') && integer.valueof(s.srtRec.srtWarrantable) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                        srtUpdate.isUserEntered__c = true;
                    }
                     if((s.srtRec.AccountCode == null || s.srtRec.AccountCode == '') && claimsRecList[0].Information_Only_Claim__c==false){
                       if((s.srtRec.srtWarrantable != null && s.srtRec.srtWarrantable != '') && (claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '') && integer.valueof(s.srtRec.srtWarrantable) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                        srtUpdate.isUserEntered__c = true;
                    }*/
                    //if(s.srtRec.isUserEntered != null)
                    //system.debug('SRTID**'+s.srtRec.SRTID+'InsideSAVE**'+s.srtRec.isUserEntered);
                    /* if(s.srtRec.isUserEntered == true)
                    srtUpdate.isUserEntered__c = true;
                    else
                    srtUpdate.isUserEntered__c = false;*/
                    srtUpdate.isUserEntered__c = s.srtRec.isUserEntered;
                    system.debug('s.srtRec.srtWarrantable--'+s.srtRec.srtWarrantable);
                    srtUpdate.SRT_Warrantable__c= s.srtRec.srtWarrantable;
                    srtUpdate.SRT_Order__c =s.srtRec.sortOrder;
                    system.debug('srtUpdate--'+srtUpdate);
                    updateSRTList.add(srtUpdate);
                    system.debug('updated Succcessfully**'+updateSRTList);

                    /*if((s.srtRec.srtType!= 'Diag Access' && s.srtRec.srtType != 'Access' && s.srtRec.srtCheckBox==true) ||
                       ((s.srtRec.srtType!= 'Diag Access' || s.srtRec.srtType != 'Access') && s.srtRec.accessSrtCheckBox ==true)){

                        srtIdList.add(s.srtRec.sId);           

                    }*/

                }

                //function callout for sending and creating overlap SRT
                if(srtIdList.size()>0){
                    //createOverlapSRT(srtIdList);   
                }

                if(updateSRTList != null && !updateSRTList.isEmpty()){
                    update updateSRTList;
                }



            }
            String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
            pageRef = new PageReference(sDestURL+'id='+CID); 
            pageRef.setRedirect(true);
            return pageRef;
        }catch(exception e){
            system.debug('Entered into savediagdata method of CG_CL_ClaimsSRTDiagController class>>>>>>'+e.getmessage() + ' ' + e.getLineNumber());
        }
        return null;
    }


    //147392 SN -  function to create Overlap records
    //Commented below code as part of 101 query optimization since this seems to be not used anywhere
    /*public void createOverlapSRT(List<String> srtIdList){
        String tempAccCode;
        Map<String,List<CSS_SRT__c>> accountCodeWithSRTMap = new Map<String,List<CSS_SRT__c>>();
        List<CSS_SRT__c> querySrtList = new List<CSS_SRT__c>();
        for(CSS_SRT__c srt : [Select id,Step_Id__c,SRT_ID__c,SRT_Title__c,OverrideReason__c,Override__c,
                              Overlap__c,SRT_Notes__c,Account_Code__c,SRT_Quantity__c,CSS_Claims__r.AccessCode__c,CSS_Claims__r.name,Job_Order__r.AccessCode__c, Job_Order__r.Name
                              from CSS_SRT__c where ID IN :srtIdList ]){


            if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One'){
                tempAccCode = 'Customer Billable';
            }
            else
                tempAccCode = srt.Account_Code__c;

            if(!accountCodeWithSRTMap.containskey(tempAccCode)){
                accountCodeWithSRTMap.put(tempAccCode,new List<CSS_srt__c>{srt});
            }
            else{
                accountCodeWithSRTMap.get(tempAccCode).add(srt);

            }            

        }

        lstSRTinsert = new List<CSS_SRT__c>();
        for(String accountCode : accountCodeWithSRTMap.keySet()){
            //overlap callout for each account code combination
            if(accountCodeWithSRTMap.get(accountCode).size()>0){
                overlapSRTCallout(accountCode,accountCodeWithSRTMap.get(accountCode));   

            }   

        }

        if(lstSRTinsert.size() > 0)
            insert lstSRTinsert;
        //call function to calculate extended hours
        calculateExtendedHours();   


    }*/


    //147392 SN -  function to make callout for Overlap
    public void overlapSRTCallout(String accCode,List<CSS_SRT__c> srtList){
        try{
            CSS_OverlapSRTReq overlapSRTREq = new CSS_OverlapSRTReq();


            //List<CSS_SRT__c> overlapSRT = new List<CSS_SRT__c>();
            Set<String> overlapSRTIds = new Set<String>();

            system.debug('CID.Id'+CID);
            //query all the existing overlap SRTs
            //Commented below query and collected overlapSRT in main SRT query loop to reduce 1 query
            //overlapSRT = [SELECT Id, Account_Code__c, SRT_ID__c FROM CSS_SRT__c WHERE Type__c = 'Overlap' AND CSS_Claims__c =: cID];                
            for(CSS_SRT__c olsrt : overlapSRT){
                if(olsrt.Account_Code__c!=null && !overlapSRTIds.contains(olsrt.Account_Code__c+'-'+olsrt.SRT_ID__c))
                    overlapSRTIds.add(olsrt.Account_Code__c+'-'+olsrt.SRT_ID__c);

            }


            User u = css_utility.getUserAttributes(userinfo.getUserId()); 
            string lang = u.LanguageLocaleKey;

            datetime systemDate = System.now();
            string sysdt = systemDate.format('YYYY-MM-dd') +'T00:00:00';        

            //Create the JSON request
            CSS_OverlapSRTReq.Header headerDeatail = new CSS_OverlapSRTReq.Header();


            CSS_OverlapSRTReq.Sender sendeDetail = new CSS_OverlapSRTReq.Sender();
            sendeDetail.ServiceName = 'GetOverlapSRT';
            sendeDetail.SenderID = 'CSS';
            headerDeatail.Sender = sendeDetail;

            CSS_OverlapSRTReq.Target  targetDetail = new CSS_OverlapSRTReq.Target();
            targetDetail.TargetID = 'SRT';
            headerDeatail.Target = targetDetail;

            list<CSS_OverlapSRTReq.Steps> stepsrt1 = new list<CSS_OverlapSRTReq.Steps>();
            //loop through SRT List to send it for overlap check
            if(srtList != null && !srtList.isEmpty()){
                Set<String> stepIdsSet = new Set<String>();
                for(CSS_SRT__c srtrc: srtList){
                    if(srtrc.Step_Id__c !=null && srtrc.Step_Id__c !='0' && !stepIdsSet.contains(srtrc.Step_Id__c)){
                        CSS_OverlapSRTReq.Steps stepsrt = new CSS_OverlapSRTReq.Steps();

                        if(srtrc.Step_Id__c != '0'){
                            stepsrt.StepId = integer.valueof(srtrc.Step_Id__c);
                            system.debug('checking step id'+stepsrt.StepId );

                            if(srtrc.SRT_Quantity__c != null){ 
                                stepsrt.Qty = srtrc.SRT_Quantity__c.intvalue();
                            }
                            system.debug('Quantity'+stepsrt.Qty);

                            if(srtrc.Job_Order__r.AccessCode__c != null){
                                stepsrt.AccessCode = srtrc.Job_Order__r.AccessCode__c;
                            }
                            /*if(srtrc.Access_Code__c != null){
                                stepsrt.AccessCode = srtrc.Access_Code__c;
                            }*/
                            stepsrt1.add(stepsrt);
                            stepIdsSet.add(srtrc.Step_Id__c);
                        }

                    }
                }    
                system.debug('List size'+stepsrt1.size());  
            }
            CSS_OverlapSRTReq.DataArea dtarea = new CSS_OverlapSRTReq.DataArea();

            dtarea.JobID = srtList.size()>0?srtList[0].CSS_Claims__r.Name:''; //Sai:103959 8/3 : Changed the serviceJob.id to serviceJob.Name to hold the CSS Job number.
            dtarea.ClaimID = '';
            dtarea.Languagecode = lang;
            dtarea.DTTimestamp = sysdt;
            dtarea.EffectiveDTTime = sysdt;
            dtarea.Steps = stepsrt1;

            overlapSRTREq.DataArea = dtarea;
            overlapSRTREq.Header = headerDeatail;
            system.debug('***overlapSRTREq--->'+overlapSRTREq);


            if(!srtList.isEmpty()){
                //Callout for overlap
                CSS_OverlapSRTResponse overlapresponse = CSS_WS_SRT.getOverlapSRTRecords(overlapSRTREq);
                system.debug('overlapresponse-->'+overlapresponse);
                //if response is not null then create Overlap Records based on response
                if(overlapresponse.DataArea.OverlapSRTTime!=null){
                    for(CSS_OverlapSRTResponse.OverlapSRTTime srtTime : overlapresponse.DataArea.OverlapSRTTime){
                        //check if exist accountcode and srt id combination record exist or not.
                        if(overlapSRTIds != null && !overlapSRTIds.contains(accCode+'-'+srtTime.SRTNumber)){

                            //create OverLap Record
                            CSS_SRT__c tempSRT = new CSS_SRT__c();
                            tempSRT.Overlap_SRT_Number__c = srtTime.OverlapSRTNumber;
                            tempSRT.SRT_ID__c = srtTime.SRTNumber;

                            tempSRT.Name = srtTime.SRTNumber;
                            tempSRT.Overlap_Hours__c = srtTime.OverlapHrs;
                            tempSRT.SRT_Title__c = srtTime.SRTTitle;
                            tempSRT.Overlap_Step_Id__c = String.valueof(srtTime.OverlapStepId);    
                            tempSRT.Step_Id__c = String.valueof(srtTime.StepId);
                            tempSRT.Overlap_SRT_Title__c = srtTime.OverlapSRTTitle;
                            tempSRT.Type__c = 'Overlap';
                            tempSRT.Account_Code__c = accCode;
                            tempSRT.CSS_Claims__c = CID;
                            lstSRTinsert.add(tempSRT);
                        }
                    }

                }
            }



        } catch(exception e){
            system.debug('Entered into overlapSRTCallout method of CG_CL_ClaimsSRTDiagController class>>>>>>'+e.getmessage() + ' ' + e.getLineNumber());

        }

    }


    //function to calculate Extended Hours
    public void calculateExtendedHours(){

        try{
            //Below variable and query are commented after fetching necessary SRT to the variable srtList in main SRT query and for loop  to reduce 1 query
            //List<CSS_SRT__c> srtList = new List<CSS_SRT__c>();
            //srtList = [SELECT Id, SRT_ID__c,Diag_Access_Time__c,Diagnosis_Time__c, SRT_Category__c, Extended_Hours__c, SRT_Time__c, SRT_Quantity__c, Calculated_Claimed_Hours__c, Type__c, SRT_Warrantable__c, SRT_Hours_Percentage__c FROM CSS_SRT__c WHERE Type__c IN ('Diagnosis','Repair','Diag Access','Repair Access','Admin','Field Action','Field Action Access') AND CSS_Claims__c =: cID];
            System.debug('=======>1'+srtListNew);
            //Below variable and query are commented after reusing the variable overlapSRT to reduce 1 query
            //List<CSS_SRT__c> overlapSrtList = new List<CSS_SRT__c>();
            //overlapSrtList = [SELECT Id, SRT_ID__c, SRT_Category__c, Extended_Hours__c, SRT_Time__c, SRT_Quantity__c, Calculated_Claimed_Hours__c, Type__c, SRT_Warrantable__c, SRT_Hours_Percentage__c FROM CSS_SRT__c WHERE Type__c = 'Overlap' AND CSS_Claims__c =: cID];
            System.debug('=======>2'+overlapSRT);
            Map<id,CSS_SRT__c> srtListToUpd = new Map<id,CSS_SRT__c>();
            for(CSS_SRT__c srt : srtListNew){
                if(overlapSRT != null && overlapSRT.size() > 0){
                    for(CSS_SRT__c olapSrt : overlapSRT){
                        system.debug('srt.SRT_ID__c'+srt.SRT_ID__c);
                        system.debug('olapSrt.SRT_ID__c' + olapSrt.SRT_ID__c);
                        if(olapSrt.SRT_ID__c == srt.SRT_ID__c){
                            system.debug('matched srt-->' + olapSrt.SRT_ID__c);
                            CSS_SRT__c tempSRT = new CSS_SRT__c();
                            if(srt.Type__c == 'Diagnosis' || srt.Type__c == 'Diag Access' || srt.Type__c == 'Repair' || srt.Type__c == 'Repair Access' || srt.SRT_Category__c == 'AdditionalRep' || srt.SRT_Category__c == 'AdditionalDiag'){ //Repair SRT
                                tempSRT.Id = srt.Id;
                                try{
                                    if(srt.Type__c == 'Diag Access'){
                                        tempSRT.Extended_Hours__c = ((srt.Diag_Access_Time__c!=null?srt.Diag_Access_Time__c:0 * srt.SRT_Quantity__c) - olapSrt.Calculated_Claimed_Hours__c) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                                        srtListToUpd.put(tempSRT.Id,tempSRT);            
                                    }
                                    else if(srt.Type__c == 'Diagnosis'){
                                        tempSRT.Extended_Hours__c = ((srt.Diagnosis_Time__c!=null?srt.Diagnosis_Time__c:0 * srt.SRT_Quantity__c) - olapSrt.Calculated_Claimed_Hours__c) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                                        srtListToUpd.put(tempSRT.Id,tempSRT); 

                                    }
                                    else{
                                        system.debug('srt.SRT_Time__c'+srt.SRT_Time__c);
                                        system.debug('srt.SRT_Quantity__c'+srt.SRT_Quantity__c);
                                        system.debug('olapSrt.Calculated_Claimed_Hours__c'+olapSrt.Calculated_Claimed_Hours__c);
                                        system.debug('srt.SRT_Warrantable__c'+srt.SRT_Warrantable__c);
                                        tempSRT.Extended_Hours__c = ((srt.SRT_Time__c!=null?srt.SRT_Time__c:0 * srt.SRT_Quantity__c) - olapSrt.Calculated_Claimed_Hours__c) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                                        srtListToUpd.put(tempSRT.Id,tempSRT); 
                                    }
                                }
                                catch(exception ex){
                                    //to skip only this record if value is null
                                    system.debug('testing when overlap match -->' + ex.getMessage() + ' - ' +ex.getLineNumber());
                                }
                                break;
                            }
                            else if(srt.Type__c == 'Field Action' || srt.Type__c == 'Field Action Access'){ //ATC Campaign TRP
                                tempSRT.Id = srt.Id;
                                try{
                                    tempSRT.Extended_Hours__c = ((srt.SRT_Time__c * srt.SRT_Quantity__c) - olapSrt.Calculated_Claimed_Hours__c) * (double.valueof(srt.SRT_Warrantable__c)/100);
                                    srtListToUpd.put(tempSRT.Id,tempSRT); 
                                }
                                catch(exception ex){
                                    //to skip only this record if value is null
                                }
                                break;
                            }
                        }
                        else{
                            CSS_SRT__c tempSRT = new CSS_SRT__c();
                            if(srt.Type__c == 'Diagnosis' || srt.Type__c == 'Diag Access' || srt.Type__c == 'Repair' || srt.Type__c == 'Repair Access' || srt.SRT_Category__c == 'AdditionalRep' || srt.SRT_Category__c == 'AdditionalDiag'){ //Repair SRT
                                tempSRT.Id = srt.Id;
                                try{
                                    if(srt.Type__c == 'Diag Access'){
                                        tempSRT.Extended_Hours__c = ((srt.Diag_Access_Time__c!=null?srt.Diag_Access_Time__c:0 * srt.SRT_Quantity__c) - 0) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                                        srtListToUpd.put(tempSRT.Id,tempSRT);             
                                    }
                                    else if(srt.Type__c == 'Diagnosis'){
                                        tempSRT.Extended_Hours__c = ((srt.Diagnosis_Time__c!=null?srt.Diagnosis_Time__c:0 * srt.SRT_Quantity__c) - 0) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                                        srtListToUpd.put(tempSRT.Id,tempSRT);  

                                    }
                                    else{
                                        system.debug('srt.SRT_Time__c-el'+srt.SRT_Time__c);
                                        system.debug('srt.SRT_Quantity__c-el'+srt.SRT_Quantity__c);
                                        system.debug('olapSrt.Calculated_Claimed_Hours__c-el'+olapSrt.Calculated_Claimed_Hours__c);
                                        system.debug('srt.SRT_Warrantable__c-el'+srt.SRT_Warrantable__c);
                                        tempSRT.Extended_Hours__c = ((srt.SRT_Time__c!=null?srt.SRT_Time__c:0 * srt.SRT_Quantity__c) - 0) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                                        srtListToUpd.put(tempSRT.Id,tempSRT); 
                                    }
                                }
                                catch(exception ex){
                                    //to skip only this record if value is null
                                    system.debug('error calculating extendedhour--' + ex.getMessage() + '-' +ex.getLineNumber());
                                }
                                //break;
                            }
                            else if(srt.Type__c == 'Field Action' || srt.Type__c == 'Field Action Access'){ //ATC Campaign TRP
                                tempSRT.Id = srt.Id;
                                try{
                                    tempSRT.Extended_Hours__c = ((srt.SRT_Time__c * srt.SRT_Quantity__c) - 0) * (double.valueof(srt.SRT_Warrantable__c)/100);
                                    srtListToUpd.put(tempSRT.Id,tempSRT); 
                                }
                                catch(exception ex){
                                    //to skip only this record if value is null
                                }
                                break;
                            }
                        }
                    }
                }
                else{
                    system.debug('Inside Extended Hours Else');
                    CSS_SRT__c tempSRT = new CSS_SRT__c();
                    system.debug('srt.Type__c--'+srt.Type__c);
                    if(srt.Type__c == 'Repair' || srt.Type__c == 'Repair Access' || srt.SRT_Category__c == 'AdditionalRep' || 
                       srt.Type__c == 'Diagnosis' || srt.Type__c == 'Diag Access' || srt.SRT_Category__c == 'AdditionalDiag'){ //Repair SRT
                        tempSRT.Id = srt.Id;
                        try{
                            if(srt.Type__c == 'Diagnosis' || srt.Type__c == 'Diag Access'){
                                tempSRT.Extended_Hours__c = ((srt.Diag_Access_Time__c!=null?srt.Diag_Access_Time__c:0 * srt.SRT_Quantity__c) - 0) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                                srtListToUpd.put(tempSRT.Id,tempSRT);             
                            }
                            else if(srt.Type__c == 'Diagnosis'){
                                tempSRT.Extended_Hours__c = ((srt.Diagnosis_Time__c!=null?srt.Diagnosis_Time__c:0 * srt.SRT_Quantity__c) - 0) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                                srtListToUpd.put(tempSRT.Id,tempSRT);  

                            }
                            else{
                                tempSRT.Extended_Hours__c = ((srt.SRT_Time__c!=null?srt.SRT_Time__c:0 * srt.SRT_Quantity__c) - 0) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                                srtListToUpd.put(tempSRT.Id,tempSRT); 
                            }
                        }
                        catch(exception ex){
                            //to skip only this record if value is null
                        }
                        //break;
                    }
                }

            }
            system.debug('output size-->'+srtListToUpd.size());
            if(srtListToUpd != null && srtListToUpd.size() > 0){
                system.debug('output-->'+srtListToUpd);
                update srtListToUpd.values();
            }
        }
        catch (exception exc){
            system.debug('catch exception in Claimed hours calculation from CG_CL_ClaimsSRTDiagController class at line number '+exc.getLineNumber()+' with error message '+exc.getMessage());
        }       

    }

    //Wrapper for Sort order for Diagnosis Access SRT. 
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



    public void changeUpOrder(){
        integer i = 0;
        for(sortWrapper sortwrp : diagListWrap){

            if(sortwrp.srtRec.selectedRecord){
                decimal temp;
                if(i != 0){
                    temp = sortwrp.srtRec.sortOrder;
                    sortwrp.srtRec.sortOrder = diagListWrap[i-1].srtRec.sortOrder;
                    diagListWrap[i-1].srtRec.sortOrder = temp;
                }

            }
            i=i+1;
        }
        diagListWrap.sort();

    }

    public void changeDownOrder(){
        system.debug('insidechange downorder');
        integer i = 0;
        for(sortWrapper sortwrp : diagListWrap){
            if(sortwrp.srtRec.selectedRecord){
                decimal temp;
                if(i < diagListWrap.size()-1){
                    temp = sortwrp.srtRec.sortOrder;
                    sortwrp.srtRec.sortOrder = diagListWrap[i+1].srtRec.sortOrder;
                    diagListWrap[i+1].srtRec.sortOrder = temp;
                }

            }
            i=i+1;
        }
        diagListWrap.sort();
    }

    /*//Method to return the Max Sort order
public decimal getMaxSortOrder(){
system.debug('additionalSRTList-->order-->'+additionalSRTList);
AggregateResult[] groupedResults= [SELECT MAX(SRT_Order__c) 
FROM CSS_SRT__c 
WHERE Job_Order__c = : CID  and 
Solution_Number__c= null];
Decimal sortOrder;
if(groupedResults != null && groupedResults.size() > 0){
sortOrder =(decimal) groupedResults[0].get('expr0');
}
//Story 90222 End

return sortOrder;
}
Anirudh
*/


    // Story GSSC-20 begin     
    public String lineItemStepIdClaimsDiag {get;set;} 
    public String StepDescriptionDiag {get; set;}

    public void callClaimsAccessStepDetailsDiag(){
        try{
            system.debug('lineItemStepIdClaimsDiag  ' + lineItemStepIdClaimsDiag);
            system.debug('EquipmentIdDiag ' + EquipmentIdDiag);
            CSS_J2AAccessStepDetails_SRT stepDetailsWS = CSS_SRTAccessWebService.accessSRTStepDetails_New(EquipmentIdDiag,lineItemStepIdClaimsDiag);
            system.debug('stepDetailsWS ' + stepDetailsWS);
            if(stepDetailsWS.DataArea!=null){
                if(stepDetailsWS.DataArea.CaseResponse!=null){
                    for(integer i=0;i<stepDetailsWS.DataArea.CaseResponse.size();i++){
                        StepDescriptionDiag = stepDetailsWS.DataArea.CaseResponse[i].SRTContent;
                    }
                }
            }
            else
                StepDescriptionDiag ='';
            
            StepDescriptionDiag = StepDescriptionDiag.replaceAll('\\n','<br/>');
            StepDescriptionDiag = StepDescriptionDiag.replaceAll('\n','<br/>');

            system.debug('StepDescriptionDiag ' + StepDescriptionDiag);
        }
        catch(exception e){
            system.debug('Exception in callAccessStepDetails method Line Num' + e.getLineNumber() + ' Message' + e.getMessage());
        }
    }

    public void ClaimsDiagNotesPopupOk(){
        StepDescriptionDiag='';
        system.debug('Ok button>> StepDescriptionDiag ' + StepDescriptionDiag);
    }

    // Story GSSC -20 End


    public class srtWrapper{

        public string solTitle{get;set;}
        public string solNum{get;set;}
        public boolean srtCheckBox{get;set;}
        public boolean accessSrtCheckBox{get;set;}
        public id sId{get;set;}

        public string failcode{get;set;}
        public string srtType{get;set;}

        public string fautCodeName{get;set;}
        public string symptomName{get;set;}

        public string AccessCodeSaved{get;set;}
        public string SRTAccessCode{get;set;}
        public string AccessCode{get;set;}
        public string accountcode{get;set;}
        public string srtID{get;set;}
        public string srtDescription{get;set;}
        public decimal quantity{get;set;}
        public decimal srtTime{get;set;}
        public decimal srtAccessTime{get;set;}
        public string srtWarrantable{get;set;}
        public boolean selectedRecord{get;set;}
        public string accTime{get;set;}
        public decimal accTimeDec{get;set;} 
        public decimal ClaimedHrs{get;set;}
        public boolean IsPopUpSRT{get;set;}
        public decimal sortOrder{get;set;}
        public String Failure{get;set;}
        public Boolean accessCodeFlag{get;set;}
        public Boolean percentReqFlag{get;set;}
        public Boolean flexFlag{get;set;}
        public string srtUsage{get;set;}


        public boolean isUserEntered{get;set;}
        public string stepId{get;set;}

        public srtWrapper(){
            this.failcode = failcode;

        }
    }

}