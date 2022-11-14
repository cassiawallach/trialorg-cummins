public class CG_CL_ClaimsSRTRepController {

    //public List<srtWrapper> diagListWrap{get;set;}
    public List<srtWrapper> repList{get;set;}
    public srtWrapper srtRep;
    public List<CSS_Srt__c> SRTList = new List<CSS_Srt__c>();
    public List<CSS_Claims__c> claimsRecList{get;set;}
    Transient List<CSS_Solution_Component__c> compList = new List<CSS_Solution_Component__c>();
    public decimal totalDecimalTimeRep{get;set;}
    public decimal totalDecimalTimeAccRep{get;set;}
    public list<sortWrapper> repListWrap{get;set;}
    public Boolean isCatastrophic{get;set;}
    public ID CID{get;set;}
    public Boolean isAutomatedClaim{get;set;}
    public CG_CL_ClaimsSRTs maincontro{set;get;}
    public boolean checklaborrate{get;set;}
    public Map<id,List<SelectOption>> mapaccesscode{get;set;}//Added as part of the story#172627
    List<CSS_SRT__c> lstSRTinsert;
    Map<String,String> failCodeFailureName = new Map<String,String>();
    public string selSRTID{get;set;}
    public string selCoveredVal{get;set;}
    public List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
    public Set<String> accSet;
    public Boolean PenaltyExists{get;set;}
    public Map<string,string> pwPenaltyMap; //Added as per story 180325
    public Map<string,string> pwPenaltyAccCodeMap; //Added as per story 180325
     public Map<string,String> SolcompCoveredlaborMap;// karthik G Added as part of GSSC -57
    //public List<CSS_Claims__c> claimsRecList;
    public Boolean isDiagRepSRTCovered{get;set;}
    public List<CSS_SRT__c> overlapSRT = new List<CSS_SRT__c>();
    public Transient List<CSS_SRT__c> srtListNew = new List<CSS_SRT__c>();
    public String EquipmentIdRepair;

    public CG_CL_ClaimsSRTRepController(){
        try{
            isDiagRepSRTCovered = true;
            isAutomatedClaim = false;
            isCatastrophic = false;
            checklaborrate=true;
            totalDecimalTimeRep = 0.0;
            totalDecimalTimeAccRep = 0.0;
            decimal timeRep=0.0;
            decimal repAccTime=0.0;
            CID=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('in CG_CL_ClaimsSRTRepController cid***'+CID);
            mapaccesscode= new map<id,list<selectoption>>(); //Added as part of the story#172627
            if(CID!=null){
                /*List<CSS_Claims__c> claimsRecList = new List<CSS_Claims__c>([Select Id ,Account__r.Type,Name, CSS_Job__c,Catastrophic__c from CSS_Claims__c where CSS_Job__c !=null and Id=:CID]);
                isCatastrophic=claimsRecList[0].Catastrophic__c;
                if(claimsRecList !=null && claimsRecList.size()>0){
                    isAutomatedClaim = true;
                }*/
                //new code to handle above scenario
                claimsRecList = new List<CSS_Claims__c>([Select Id ,Account__r.Type,Name,SP_INSHOP_LABOR_RATE__c,Total_PSN_Count__c, CSS_Job__c,Catastrophic__c,ODM_Penalty__c,Information_Only_Claim__c,(select id,Equipment_ID__c from CSS_PSNs__r) from CSS_Claims__c where Id=:CID]);
                 EquipmentIdRepair = claimsRecList[0].CSS_PSNs__r[0].Equipment_ID__c;
                
                system.debug('EquipmentIdRepair' + EquipmentIdRepair);
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
                SRTList = [select Calculated_Claimed_Hours__c,SRT_Usage__c, Flex_Flag__c,SRT_Warrantable__c,Extended_Hours__c,Component_Id__r.Name,CSS_Claims__c,CSS_Claims__r.AccessCode__c,name,SRT_ID__c,Repair_Access_Calculated__c,Additional_SRT_Calculated__c,Diagnosis_Time__c,SRT_Decimal_Time__c,id,step_id__c,SRT_Time__c,Component_Id__c ,Type__c,Response_Message__c ,Repair_Time__c,Access_Code_A__c,SRT_AccessiblityCheck__c,Solution_Title__c,
                           Solution_Number__r.Name,Solution_Number__r.Diagnostic_Response__c,Component_Id__r.CSS_Failure_Sequence_Number__c,Assignment__c,SRT_Status_Message__c,SRT_Title__c ,isPerformed__c,SRT_Quantity__c,SRT_Notes__c ,Access_Code_Flag__c,SRT_Warrantable_Flag__c,
                           Access_Code_B__c,Account_Code__c,isUserEntered__c,AccountCode_Formula__c,FailCode__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Access_Code_S1__c,Access_Code_S2__c,Access_Code_S3__c,Access_Code_S4__c,Access_Code_S5__c,Access_Code_S6__c,Access_Code_S7__c,Access_Code_S8__c,Access_Code_S9__c,S1_Description__c,S2_Description__c,S3_Description__c,S4_Description__c,Diag_Access_Time__c,
                           //S5_Description__c,srt_category__c,IsPopUpSRT__c,Symptom_Name__c,Fault_Code_Name__c,SRT_Access_Code__c,Access_Code__c,S6_Description__c,S7_Description__c,S8_Description__c,S9_Description__c,Special_Access_Code__c,Special_Access_Code_Desc__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code_Saved__c,Claimed_Hours__c from CSS_SRT__c where css_claims__c =:CID AND Assignment__c !='NOT CLAIMABLE' and SRT_ID__c !='0' order by SRT_Order__c asc]; //Commented as per defect 173599
                           S5_Description__c,srt_category__c,IsPopUpSRT__c,Symptom_Name__c,Fault_Code_Name__c,SRT_Access_Code__c,Access_Code__c,S6_Description__c,S7_Description__c,S8_Description__c,S9_Description__c,Special_Access_Code__c,Special_Access_Code_Desc__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code_Saved__c,Claimed_Hours__c from CSS_SRT__c where css_claims__c =:CID AND (Assignment__c IN ('Primary', 'Progressive Damage','Alternative') OR Assignment__c = Null OR SRT_Category__c = 'AdditionalRep') and SRT_ID__c !='0' order by Component_Id__r.CSS_Failure_Sequence_Number__c,CSS_AssignmentOrder__c,SRT_ID__c asc];
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
                
                System.debug('SRTList size:'+SRTList.size());             
                compList = [SELECT Id, Name, FailCode_Formula__c, Fail_Code__c,Covered_Labor__c, CSS_Account_Formula__c, ODM_Penalty__c FROM CSS_Solution_Component__c WHERE CSS_Claims__c =:CID AND Fail_Code__c != null AND CSS_Account_Formula__c != null];
            }
            
            for(CSS_Solution_Component__c cList: compList){
                if(!failCodeFailureName.containsKey(cList.Fail_Code__c))
                    failCodeFailureName.put(cList.Fail_Code__c,cList.Name);
            }
system.debug('Asc Code List###'+SRTList); 
            if(SRTList!=null && !SRTList.isEmpty()){
                //repList = new list<srtWrapper>();
                repListWrap= new list<sortWrapper>();
                for(CSS_SRT__c srt:SRTList){
                    system.debug('Testlist'+srt);
                    //Below code is added for story#172627
                    if(!mapaccesscode.containsKey(srt.id))
                        mapaccesscode.put(srt.id,new list<selectoption>());
                    //end
                    if(srt.Type__c == 'Overlap'){
                        overlapSRT.add(srt);
                    }
                    else if(srt.Type__c == 'Diagnosis' || srt.Type__c == 'Repair' || srt.Type__c == 'Diag Access' || srt.Type__c == 'Repair Access' || srt.Type__c == 'Admin' || srt.Type__c == 'Field Action' || srt.Type__c == 'Field Action Access'){
                        srtListNew.add(srt);
                    }
                    System.debug('SRT_ID__c:'+srt.SRT_ID__c+' srt.Type__c:'+srt.Type__c+' srt.srt_category__c>>:'+srt.srt_category__c);
                    System.debug('srt.solution_number__c:'+srt.solution_number__c+' srt.solution_number__r:'+srt.solution_number__r);
                    if(srt.solution_number__r.Diagnostic_Response__c!=null && srt.solution_number__r.Diagnostic_Response__c == 'Most likely the solution'){
                        if(srt.Type__c != null && srt.Type__c != '' && (srt.Type__c.equalsIgnoreCase('Repair') || srt.Type__c.equalsIgnoreCase('Repair Access')) && srt.srt_category__c == null){
                            //if(srt.Assignment__c == 'Primary' || srt.Assignment__c == 'Progressive Damage' || srt.Assignment__c == 'Alternative' || srt.SRT_AccessiblityCheck__c == true){ //commented as part of defect #154490
                            system.debug('in first if...');
                            srtRep = new srtWrapper();
                            srtRep.sId = srt.Id;
                            srtRep.solTitle = srt.Solution_Title__c;
                            srtRep.solNum = srt.solution_number__r.Name;
                            srtRep.fautCodeName = srt.Fault_Code_Name__c ;
                            srtRep.srtWarrantable= srt.SRT_Warrantable__c;
                            srtRep.ClaimedHrs = (srt.Extended_Hours__c != null ? srt.Extended_Hours__c : 0.0);
                            srtRep.symptomName = srt.Symptom_Name__c ;
                            srtRep.srtType = srt.Type__c;
                            srtRep.componentName = srt.Component_Id__r.Name;
                            srtRep.AccessCodetimeA = srt.Access_Code_A__c;
                            srtRep.AccessCodetimeB = srt.Access_Code_B__c;
                            srtRep.AccessCodetimeC = srt.Access_Code_C__c;
                            srtRep.AccessCodetimeD = srt.Access_Code_D__c;
                            srtRep.AccessCodetimeR = srt.Access_Code_R__c;
                            srtRep.flexFlag = srt.Flex_Flag__c;
                            srtRep.srtUsage = srt.SRT_Usage__c;
                            //Added below condition for not displaying 'Select One'
                            if(srt.FailCode__c!='Select One')
                                srtRep.failcode = srt.FailCode__c;
                            else
                                srtRep.failcode = '';
                            
                                srtRep.AccessCodeSaved  = srt.Job_Engine_Access_Code__c;
                         system.debug('srt.Access_Code__c**'+srt.Access_Code__c);
                         system.debug('SRT_Access_Code__c**'+srt.SRT_Access_Code__c);
                            //Below code added for story#172627
                              if(string.isBlank(srt.Access_Code__c) || srt.Access_Code__c==NULL || srt.Access_Code__c=='')//Setting up loic for default value for the story#172627
                            {
                                  srtRep.AccessCode = srt.SRT_Access_Code__c;
                                  srt.Access_Code__c=srtRep.AccessCode;
                            }
                            else
                            {
                                srtRep.AccessCode  = srt.Access_Code__c;
                            }

                            CG_UtilityForSRT srtRepaccesscodecls = new CG_UtilityForSRT();
                            list<selectoption> RepAccesscodetmp = srtRepaccesscodecls.getAccesscodeclaimoption(string.valueOf(srt.Access_Code_A__c),string.valueOf(srt.Access_Code_B__c),string.valueOf(srt.Access_Code_C__c),string.valueOf(srt.Access_Code_D__c),string.valueOf(srt.Access_Code_R__c),srt.CSS_Claims__r.AccessCode__c,srt.SRT_Access_Code__c,'RepairOrFA',srt.IsPopUpSRT__c);
                            system.debug('RepAccesscodetmp**'+RepAccesscodetmp);
                            if(RepAccesscodetmp.size()>0)
                                mapaccesscode.put(srt.Id,RepAccesscodetmp);
                                system.debug('mapaccesscode**'+mapaccesscode);
                            //end      
                            srtRep.accountcode = srt.AccountCode_Formula__c; //srt.Account_Code__c;
                            srtRep.srtID = srt.SRT_ID__c;
                            srtRep.srtDescription = srt.SRT_Title__c;
                            srtRep.assignmentValue = srt.Assignment__c;
                            srtRep.Quantity = srt.SRT_Quantity__c;
                            srtRep.IsPopUpSRT = srt.IsPopUpSRT__c;
                            srtRep.sortOrder =srt.SRT_Order__c;
srtRep.accessCodeFlag = srt.Access_Code_Flag__c != null && srt.Access_Code_Flag__c ==true ? true : false;
                            srtRep.percentReqFlag = srt.SRT_Warrantable_Flag__c != null && srt.SRT_Warrantable_Flag__c ==true ? true : false;
                            
                            if(srt.Type__c.equalsIgnoreCase('Repair')){ 
                                srtRep.srtCheckBox = srt.isPerformed__c;
                                srtRep.srtTime = srt.Repair_Time__c;
                                if(srt.isPerformed__c == true){
                                    if(srt.Extended_Hours__c !=null)
                                        timeRep = timeRep + srt.Extended_Hours__c;
                                }
                            }

                            if(srt.Type__c.equalsIgnoreCase('Repair Access')){
                                srtRep.srtAccessTime = srt.Repair_Access_Calculated__c;
                                srtRep.accessSrtCheckBox = srt.SRT_AccessiblityCheck__c;
                                if(srt.SRT_AccessiblityCheck__c){
                                    if(srt.Extended_Hours__c !=null)
                                    timeRep = timeRep + srt.Extended_Hours__c;//Added as part of GSSC-208
                                    repAccTime = repAccTime + (srt.Repair_Access_Calculated__c * srt.SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633
                                }
                            }
                            srtRep.isUserEntered = srt.isUserEntered__c != null && srt.isUserEntered__c == true ? true : false; //183955
                             srtRep.stepId = srt.step_id__c; // GSSC -20
                            if(srtRep != null){
                                //repList.add(srtRep);
                                repListWrap.add(new sortWrapper(srtRep));
                            }
                            //}
                        }

                    } 

                    if((srt.srt_category__c!= null && srt.srt_category__c.equalsIgnoreCase('AdditionalRep'))){ 
                        system.debug('in second if...');
                        srtRep = new srtWrapper();
                        srtRep.solTitle = '';
                        srtRep.solNum = '';
                        srtRep.fautCodeName = '' ;
                        srtRep.symptomName = '';
                        srtRep.componentName = '';
                        srtRep.sId = srt.Id;
                        srtRep.srtWarrantable= (srt.SRT_Warrantable__c != null ? srt.SRT_Warrantable__c : '0'); //string.valueOf(srt.SRT_Hours_Percentage__c));
                        srtRep.srtType = srt.Type__c;
                        srtRep.flexFlag = srt.Flex_Flag__c;
                        srtRep.srtUsage = srt.SRT_Usage__c;
                        if(srt.FailCode__c != null && srt.FailCode__c != '')
                            srtRep.componentName = failCodeFailureName.get(srt.FailCode__c);
                       
                        srtRep.AccessCodeSaved  = srt.Job_Engine_Access_Code__c;
                        system.debug('srt.Job_Engine_Access_Code__c**'+srt.Job_Engine_Access_Code__c);
                        system.debug('srt.Access_Code__c**'+srt.Access_Code__c);
                        //Below code added for story#172627
                        if(string.isBlank(srt.Access_Code__c)||srt.Access_Code__c==null || srt.Access_Code__c=='')
                        {
                            if( srt.Access_Code_A__c==0 && srt.Access_Code_B__c==0 && srt.Access_Code_C__c==0 && srt.Access_Code_D__c==0 && srt.Access_Code_R__c!=0)
                            {
                                srtRep.AccessCode  = 'R';
                                srt.Access_Code__c = 'R';
                            }
                            else
                            {
                                srtRep.AccessCode  = srt.Job_Engine_Access_Code__c ;
                                srt.Access_Code__c = srt.Job_Engine_Access_Code__c;
                            }
                            
                        }
                        else
                        {
                            srtRep.AccessCode  = srt.Access_Code__c;
                        }
                        
                        CG_UtilityForSRT srtRepaccesscodecls = new CG_UtilityForSRT();
                        list<selectoption> RepAccesscodetmp = srtRepaccesscodecls.getAccesscodeclaimoption(string.valueOf(srt.Access_Code_A__c),string.valueOf(srt.Access_Code_B__c),string.valueOf(srt.Access_Code_C__c),string.valueOf(srt.Access_Code_D__c),string.valueOf(srt.Access_Code_R__c),srt.CSS_Claims__r.AccessCode__c,srtRep.AccessCode,'RepairOrFA',srt.IsPopUpSRT__c);
                        if(RepAccesscodetmp.size()>0)
                            mapaccesscode.put(srt.Id,RepAccesscodetmp);
                            system.debug('RepAccesscodetmp**'+RepAccesscodetmp);
                        //end       
                        srtRep.AccessCodetimeA = srt.Access_Code_A__c;
                        srtRep.AccessCodetimeB = srt.Access_Code_B__c;
                        srtRep.AccessCodetimeC = srt.Access_Code_C__c;
                        srtRep.AccessCodetimeD = srt.Access_Code_D__c;
                        srtRep.AccessCodetimeR = srt.Access_Code_R__c;
                        srtRep.accountcode = srt.AccountCode_Formula__c; //srt.Account_Code__c;
                        srtRep.srtID = srt.SRT_ID__c;
                        srtRep.srtDescription = srt.SRT_Title__c;
                        srtRep.assignmentValue = srt.Assignment__c;
                        srtRep.Quantity = srt.SRT_Quantity__c;
                        srtRep.ClaimedHrs = (srt.Extended_Hours__c != null ? srt.Extended_Hours__c : 0.0);
                        srtRep.accessCodeFlag = srt.Access_Code_Flag__c != null && srt.Access_Code_Flag__c ==true ? true : false;
                        srtRep.percentReqFlag = srt.SRT_Warrantable_Flag__c != null && srt.SRT_Warrantable_Flag__c ==true ? true : false;
                        
                        //Added below condition for not displaying 'Select One'
                        if(srt.FailCode__c!='Select One')
                            srtRep.failcode = srt.FailCode__c;
                        else
                            srtRep.failcode ='';
                        srtRep.IsPopUpSRT = srt.IsPopUpSRT__c;
                        srtRep.sortOrder =srt.SRT_Order__c;
                        if(srt.type__c != null && srt.type__c.equalsIgnoreCase('Access')){
                            srtRep.accessSrtCheckBox = srt.SRT_AccessiblityCheck__c; //new line added
                            srtRep.srtAccessTime = srt.Additional_SRT_Calculated__c;
                            if(srt.SRT_AccessiblityCheck__c == true){
                                if(srt.Extended_Hours__c !=null)
                                    timeRep = timeRep + srt.Extended_Hours__c;//Added as part of GSSC-208
                                if(srt.Additional_SRT_Calculated__c !=null && srt.SRT_Quantity__c !=null)
                                    repAccTime = repAccTime+ (srt.Additional_SRT_Calculated__c * srt.SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633
                            }
                        }
                        if(srt.type__c != 'Access'){
                            srtRep.srtCheckBox = srt.isPerformed__c; //new line added
                            srtRep.srtTime = srt.Additional_SRT_Calculated__c;
                            if(srt.isPerformed__c == true){
                                if(srt.Extended_Hours__c !=null)
                                    timeRep = timeRep + srt.Extended_Hours__c; //(srt.Additional_SRT_Calculated__c * srt.SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633
                            }
                        }
                         srtRep.isUserEntered = srt.isUserEntered__c != null && srt.isUserEntered__c == true ? true : false; //183955
                         srtRep.stepId = srt.step_id__c; // GSSC -20
                        if(srtRep != null){
                            //repList.add(srtRep);
                            repListWrap.add(new sortWrapper(srtRep));
                        }
                    } 
                    //story 166107
                    if(srt.solution_number__c==null){
                        if((srt.Type__c.equalsIgnoreCase('Repair') || srt.Type__c.equalsIgnoreCase('Repair Access')) && srt.srt_category__c == null && (srt.Assignment__c!='Diagnostics' || srt.Assignment__c!='DIAGNOSTIC')){
                            //if(srt.Assignment__c == 'Primary' || srt.Assignment__c == 'Progressive Damage' || srt.Assignment__c == 'Alternative' || srt.SRT_AccessiblityCheck__c == true){ //commented as part of defect #154490
                            system.debug('in third if...');
                            srtRep = new srtWrapper();
                            srtRep.sId = srt.Id;
                            srtRep.solTitle = srt.Solution_Title__c;
                            srtRep.solNum = srt.solution_number__r.Name;
                            srtRep.fautCodeName = srt.Fault_Code_Name__c ;
                            srtRep.srtWarrantable= srt.SRT_Warrantable__c;
                            srtRep.ClaimedHrs = (srt.Extended_Hours__c != null ? srt.Extended_Hours__c : 0.0);
                            srtRep.symptomName = srt.Symptom_Name__c ;
                            srtRep.srtType = srt.Type__c;
                            srtRep.flexFlag = srt.Flex_Flag__c;
                            srtRep.srtUsage = srt.SRT_Usage__c;
                            srtRep.componentName = srt.Component_Id__r.Name;
                            srtRep.AccessCodetimeA = srt.Access_Code_A__c;
                            srtRep.AccessCodetimeB = srt.Access_Code_B__c;
                            srtRep.AccessCodetimeC = srt.Access_Code_C__c;
                            srtRep.AccessCodetimeD = srt.Access_Code_D__c;
                            srtRep.AccessCodetimeR = srt.Access_Code_R__c;
                            srtRep.accessCodeFlag = srt.Access_Code_Flag__c != null && srt.Access_Code_Flag__c ==true ? true : false;
                            srtRep.percentReqFlag = srt.SRT_Warrantable_Flag__c != null && srt.SRT_Warrantable_Flag__c ==true ? true : false;
                            
                            //Added below condition for not displaying 'Select One'
                            if(srt.FailCode__c!='Select One')
                                srtRep.failcode = srt.FailCode__c;
                            else
                                srtRep.failcode = '';
                           
                                srtRep.AccessCodeSaved  = srt.Job_Engine_Access_Code__c;
                          
                            //Below code added for story#172627
                              if(string.isBlank(srt.Access_Code__c) || srt.Access_Code__c==NULL || srt.Access_Code__c=='')//Setting up loic for default value for the story#172627
                            {
                                  srtRep.AccessCode = srt.SRT_Access_Code__c;
                                  srt.Access_Code__c=srtRep.AccessCode;
                            }
                            else
                            {
                                srtRep.AccessCode  = srt.Access_Code__c;
                            }

                            CG_UtilityForSRT srtRepaccesscodecls = new CG_UtilityForSRT();
                            list<selectoption> RepAccesscodetmp = srtRepaccesscodecls.getAccesscodeclaimoption(string.valueOf(srt.Access_Code_A__c),string.valueOf(srt.Access_Code_B__c),string.valueOf(srt.Access_Code_C__c),string.valueOf(srt.Access_Code_D__c),string.valueOf(srt.Access_Code_R__c),srt.CSS_Claims__r.AccessCode__c,srt.SRT_Access_Code__c,'RepairOrFA',srt.IsPopUpSRT__c);
                            if(RepAccesscodetmp.size()>0)
                                mapaccesscode.put(srt.Id,RepAccesscodetmp);
                            //end         
                            srtRep.accountcode = srt.AccountCode_Formula__c; //srt.Account_Code__c;
                            srtRep.srtID = srt.SRT_ID__c;
                            srtRep.srtDescription = srt.SRT_Title__c;
                            srtRep.assignmentValue = srt.Assignment__c;
                            srtRep.Quantity = srt.SRT_Quantity__c;
                            srtRep.IsPopUpSRT = srt.IsPopUpSRT__c;
                            srtRep.sortOrder =srt.SRT_Order__c;

                            if(srt.Type__c.equalsIgnoreCase('Repair')){ 
                                srtRep.srtCheckBox = srt.isPerformed__c;
                                srtRep.srtTime = srt.Repair_Time__c;
                                if(srt.isPerformed__c == true){
                                    if(srt.Extended_Hours__c !=null)
                                        timeRep = timeRep + srt.Extended_Hours__c;
                                }
                            }

                            if(srt.Type__c.equalsIgnoreCase('Repair Access')){
                                srtRep.srtAccessTime = srt.Repair_Access_Calculated__c;
                                // srtRep.accessSrtCheckBox = srt.SRT_AccessiblityCheck__c;
                                if(srt.SRT_AccessiblityCheck__c){
                                    if(srt.Extended_Hours__c !=null)
                                    timeRep = timeRep + srt.Extended_Hours__c;//Added as part of GSSC-208
                                    repAccTime = repAccTime + (srt.Repair_Access_Calculated__c * srt.SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633
                                }
                            }
                            srtRep.isUserEntered = srt.isUserEntered__c != null && srt.isUserEntered__c == true ? true : false; //183955
                            srtRep.stepId = srt.step_id__c; // GSSC -20
                            if(srtRep != null){
                                //repList.add(srtRep);
                                system.debug('Testswrap'+srtRep);
                                repListWrap.add(new sortWrapper(srtRep));
                                system.debug('Testswrap1'+repListWrap);
                                //repListWrap.add(srtRep);
                            }
                            //}
                        }

                    }

                } // for loop
                //repListWrap.sort();
            }   
            totalDecimalTimeRep = timeRep; 
            totalDecimalTimeAccRep = repAccTime;
            //Kalpana story 155910
            //jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' and Attribute1__c IN ('POL','NPW','RPW')];
            jobEventTemp =css_utility.getJobEventTempPolicy();
            accSet = new Set<String>();
            Set<String> accSetPW = new Set<String>();
            pwPenaltyMap = new Map<string,string>();
            pwPenaltyAccCodeMap = new Map<string,string>();
            SolcompCoveredlaborMap = new Map<string,string>();
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
                 system.debug('SolcompCoveredlaborMap--'+SolcompCoveredlaborMap);
            }
            //Story 180325 -- END
            if(repListWrap != null && repListWrap.size() > 0){
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
    public void SRTPercReqRep(){
        system.debug('inPercentReq**'+selCoveredVal);
        system.debug('inPercentReq1**'+selSRTID);
        if(repListWrap != null && !repListWrap.isEmpty()){
            String failurePenalty;
            String coveredlaborvalsol;
            for(sortwrapper srt:repListWrap){
                if(selSRTID == srt.srtRec.srtID){
                    system.debug('inPercentReq**'+srt.srtRec.accountcode);
                    system.debug('inPercentReq2**'+srt.srtRec.srtWarrantable);
                    system.debug('accSet**'+accSet);
                    //Story 180325 added below pwPenaltyMap code
                    srt.srtRec.isUserEntered=true;
                    if(pwPenaltyMap != null && pwPenaltyMap.size() > 0 && (srt.srtRec.accountcode != null && srt.srtRec.accountcode != '') && claimsRecList[0].Information_Only_Claim__c==false){
                        if(srt.srtRec.failcode != null && srt.srtRec.failcode != '')
                              failurePenalty = pwPenaltyMap.get(srt.srtRec.failcode.trim()+srt.srtRec.AccountCode.trim());
                              else
                              failurePenalty = pwPenaltyAccCodeMap.get(srt.srtRec.AccountCode.trim());
                        if(failurePenalty != null && failurePenalty != '' && (((srt.srtRec.srtWarrantable != null && srt.srtRec.srtWarrantable != '') && integer.valueof(srt.srtRec.srtWarrantable)>integer.valueof(failurePenalty)) || (srt.srtRec.srtWarrantable == null || srt.srtRec.srtWarrantable == ''))){
                            srt.srtRec.srtWarrantable = failurePenalty;

                        }
                    }

                    else if(claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '' && integer.valueof(claimsRecList[0].ODM_Penalty__c) > 0){
                        if(srt.srtRec.AccountCode != null && srt.srtRec.AccountCode != '' && accSet != null && !accSet.contains(srt.srtRec.AccountCode) && claimsRecList[0].Information_Only_Claim__c==false){

                            if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                                {srt.srtRec.srtWarrantable = selCoveredVal;}
                            else 
                                {srt.srtRec.srtWarrantable = claimsRecList[0].ODM_Penalty__c;srt.srtRec.isUserEntered=false;}
                        }
                        else if(srt.srtRec.AccountCode == null || srt.srtRec.AccountCode == '' && claimsRecList[0].Information_Only_Claim__c==false){
                            if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                                {srt.srtRec.srtWarrantable = selCoveredVal;}
                            else 
                                {srt.srtRec.srtWarrantable = claimsRecList[0].ODM_Penalty__c;srt.srtRec.isUserEntered=false;}

                        }

                        else if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) >= 100)
                            {srt.srtRec.srtWarrantable = string.valueof(100);srt.srtRec.isUserEntered=false;}

                    }
                    else if((selCoveredVal != null && selCoveredVal != '') && integer.valueof(selCoveredVal) >= 100)
                        {srt.srtRec.srtWarrantable = string.valueof(100);srt.srtRec.isUserEntered=false;}
                    // break;
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
                }
            }
        }
    }
  /*  Defect 190620 - Below is for calculating only Access SRT times which is not in use so we have commented. 
  public void getRepAccessTime(){
        try{
            decimal timeRep=0.0;
            for(sortwrapper srt:repListWrap){
                if(srt.srtRec.accessSrtCheckBox == true){
                    if(srt.srtRec.srtType.equalsIgnoreCase('Repair Access') || srt.srtRec.srtType.equalsIgnoreCase('Access')){
                        timeRep = timeRep + srt.srtRec.srtAccessTime;
                    }
                }
            }
            totalDecimalTimeAccRep = timeRep;
        }catch(exception e){
            system.debug('Entered into catch block of getDiagAccessTime method in CSS_DARSRT Class'+e.getMessage() + ' ' + e.getLineNumber());
        }
    } */


    public void getRepairTime(){
        system.debug('inside getRepairTime');
        decimal repTime = 0.0;
        for(sortwrapper srt:repListWrap){
            if(srt.srtRec.srtCheckBox == true || srt.srtRec.accessSrtCheckBox == true){
                //Defect 190620 - Commenting belwo line since we need to include all Acess SRT Times in total.
                //if(!srt.srtRec.srtType.equalsIgnoreCase('Repair Access') && !srt.srtRec.srtType.equalsIgnoreCase('Access')){
                    if(srt.srtRec.ClaimedHrs!=null){

                        system.debug('inside if'+srt.srtRec.ClaimedHrs);
                        //repTime = repTime + srt.srtRec.srtTime;
                        repTime = repTime + srt.srtRec.ClaimedHrs;}
                }
            //}
        }
        totalDecimalTimeRep =  repTime;

    }

    public pageReference saveRepData(){
        try{
            PageReference pageRef;
            List<String> srtIdList = new List<String>();
            system.debug('Anirudh Entered repair save method');
            list<CSS_SRT__c> updateSRTList = new list<CSS_SRT__c>();
            system.debug('***repListsize**'+repListWrap.size());
            if(repListWrap != null && !repListWrap.isEmpty()){
                system.debug('**inside**replist*');
                for(sortwrapper s:repListWrap){
                    CSS_SRT__c srtrec = new CSS_SRT__c();
                    srtrec.Id = s.srtRec.sId;
                    srtrec.Access_Code__c = s.srtRec.AccessCode;
                    if(s.srtRec.accessSrtCheckBox != null)
                        srtrec.SRT_AccessiblityCheck__c = s.srtRec.accessSrtCheckBox;
                    if(s.srtRec.srtCheckBox != null)
                        srtrec.isPerformed__c = s.srtRec.srtCheckBox;

                    if((s.srtRec.srtType != 'Repair Access' && s.srtRec.srtType != 'Access') || s.srtRec.srtType == 'Admin' || s.srtRec.srtType == 'Repair' || s.srtRec.srtType == 'Diagnosis'){
                        if(s.srtRec.srtCheckBox == false){ 
                            system.debug('Inside IF Access');
                            srtrec.Extended_Hours__c = 0.0;
                        }
                    }else{ 
                        if(s.srtRec.accessSrtCheckBox == false){ 
                            system.debug('Inside IF Access');
                            srtrec.Extended_Hours__c = 0.0;
                        }
                    }
                    
                    
                    if(s.srtRec.flexFlag == true){
                        if(s.srtRec.srtType != 'Repair Access' && s.srtRec.srtType != 'Access'){
                            srtrec.SRT_Time__c = s.srtRec.srtTime;
                        }
                        else if(s.srtRec.srtType == 'Repair Access' || s.srtRec.srtType == 'Access'){
                            srtrec.SRT_Time__c = s.srtRec.srtAccessTime;
                        }
                        
                    }
                    
                    srtrec.SRT_Quantity__c = s.srtRec.quantity;
                    /*if(s.srtRec.AccountCode != null && s.srtRec.AccountCode != '' && accSet != null && !accSet.Contains(s.srtRec.AccountCode.trim()) && claimsRecList[0].Information_Only_Claim__c==false){
                        if((s.srtRec.srtWarrantable != null && s.srtRec.srtWarrantable != '') && (claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '') && integer.valueof(s.srtRec.srtWarrantable) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                        srtrec.isUserEntered__c = true;
                    }
                    if((s.srtRec.AccountCode == null || s.srtRec.AccountCode == '') && claimsRecList[0].Information_Only_Claim__c==false){
                       if((s.srtRec.srtWarrantable != null && s.srtRec.srtWarrantable != '') && (claimsRecList[0].ODM_Penalty__c != null && claimsRecList[0].ODM_Penalty__c != '') && integer.valueof(s.srtRec.srtWarrantable) < integer.valueof(claimsRecList[0].ODM_Penalty__c))
                        srtrec.isUserEntered__c = true;
                    }*/
                    //system.debug('SRTID**'+s.srtRec.SRTID+'InsideSAVE**'+s.srtRec.isUserEntered);
                    srtrec.isUserEntered__c = s.srtRec.isUserEntered;
                    srtrec.SRT_Warrantable__c= s.srtRec.srtWarrantable;
                    srtrec.SRT_Order__c =s.srtRec.sortOrder;
                    updateSRTList.add(srtRec);
                    system.debug('srtrec.SRT_Quantity__c>>>>>'+srtrec.SRT_Quantity__c);

                    if((s.srtRec.srtType!= 'Diag Access' && s.srtRec.srtType != 'Access' && s.srtRec.srtCheckBox==true) ||
                       ((s.srtRec.srtType!= 'Diag Access' || s.srtRec.srtType != 'Access') && s.srtRec.accessSrtCheckBox == true)){

                        srtIdList.add(s.srtRec.sId);           

                    }


                }
                //call function to create and send overlap srts
                if(srtIdList.size()>0){
                    //createOverlapSRT(srtIdList);   
                }

                system.debug('updateSRTList>>>>>'+updateSRTList);
                if(updateSRTList != null && !updateSRTList.isEmpty()){
                    update updateSRTList;
                } 
            }
            String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
            pageRef = new PageReference(sDestURL+'id='+CID); 
            pageRef.setRedirect(true);
            return pageRef;
        }catch(exception e){
            system.debug('Entered into saveRepData method of CG_CL_ClaimsSRTRepController class>>>>>>'+e.getmessage() + ' ' + e.getLineNumber());
        }
        return null;
    }


    //147392 SN -  function to create Overlap records
    //Commented below code as part of 101 query optimization since this seems to be not used anywhere
    /*public void createOverlapSRT(List<String> srtIdList){
        String tempAccCode;
        Map<String,List<CSS_SRT__c>> accountCodeWithSRTMap = new Map<String,List<CSS_SRT__c>>();
        List<CSS_SRT__c> querySrtList = new List<CSS_SRT__c>();
        for(CSS_SRT__c srt : [Select id,Step_Id__c,SRT_ID__c,Account_Code__c,SRT_Title__c,OverrideReason__c,Override__c,
                              Overlap__c,SRT_Notes__c,SRT_Quantity__c,CSS_Claims__r.AccessCode__c,CSS_Claims__r.name
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
            //overlap Callout for each accountCode combination
            if(accountCodeWithSRTMap.get(accountCode).size()>0){
                overlapSRTCallout(accountCode,accountCodeWithSRTMap.get(accountCode));   

            }   

        }

        if(lstSRTinsert.size() > 0)
            insert lstSRTinsert;
        //call function to calculated extended hours
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
                            /*
                            if(srtrc.Access_Code__c!= null){
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
            system.debug('Entered into overlapSRTCallout method of CG_CL_ClaimsSRTRepController class>>>>>>'+e.getmessage() + ' ' + e.getLineNumber());

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
                        //system.debug('srt.SRT_ID__c'+srt.SRT_ID__c);
                        //system.debug('olapSrt.SRT_ID__c' + olapSrt.SRT_ID__c);
                        if(olapSrt.SRT_ID__c == srt.SRT_ID__c){
                            //system.debug('matched srt-->' + olapSrt.SRT_ID__c);
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
            system.debug('catch exception in Claimed hours calculation from CG_CL_ClaimsSRTRepController class at line number '+exc.getLineNumber()+' with error message '+exc.getMessage());
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
        for(sortWrapper sortwrp : repListWrap){

            if(sortwrp.srtRec.selectedRecord){
                decimal temp;
                if(i != 0){
                    temp = sortwrp.srtRec.sortOrder;
                    sortwrp.srtRec.sortOrder = repListWrap[i-1].srtRec.sortOrder;
                    repListWrap[i-1].srtRec.sortOrder = temp;
                }

            }
            i=i+1;
        }
        repListWrap.sort();

    }

    public void changeDownOrder(){

        integer i = 0;
        for(sortWrapper sortwrp : repListWrap){
            if(sortwrp.srtRec.selectedRecord){
                decimal temp;
                if(i < repListWrap.size()-1){
                    temp = sortwrp.srtRec.sortOrder;
                    sortwrp.srtRec.sortOrder = repListWrap[i+1].srtRec.sortOrder;
                    repListWrap[i+1].srtRec.sortOrder = temp;
                }

            }
            i=i+1;
        }
        repListWrap.sort();
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
    public String lineItemStepIdClaimsRepair {get;set;} 
    public String StepDescriptionRepair {get; set;}
    
    public void callClaimsAccessStepDetailsRepair(){
        try{
            system.debug('lineItemStepIdClaimsRepair  ' + lineItemStepIdClaimsRepair);
            system.debug('EquipmentIdRepair ' + EquipmentIdRepair);
            CSS_J2AAccessStepDetails_SRT stepDetailsWS = CSS_SRTAccessWebService.accessSRTStepDetails_New(EquipmentIdRepair,lineItemStepIdClaimsRepair);
            system.debug('stepDetailsWS ' + stepDetailsWS);
            if(stepDetailsWS.DataArea!=null){
                if(stepDetailsWS.DataArea.CaseResponse!=null){
                    for(integer i=0;i<stepDetailsWS.DataArea.CaseResponse.size();i++){
                        StepDescriptionRepair = stepDetailsWS.DataArea.CaseResponse[i].SRTContent;
                    }
                }
            }
            else
                StepDescriptionRepair ='';
            
             StepDescriptionRepair = StepDescriptionRepair.replaceAll('\\n','<br/>');
            StepDescriptionRepair = StepDescriptionRepair.replaceAll('\n','<br/>');
            
            system.debug('StepDescriptionRepair ' + StepDescriptionRepair);
        }
        catch(exception e){
            system.debug('Exception in callAccessStepDetails method Line Num' + e.getLineNumber() + ' Message' + e.getMessage());
        }
    }
    
    public void ClaimsRepairNotesPopupOk(){
      StepDescriptionRepair='';
       system.debug('Ok button>> StepDescriptionRepair ' + StepDescriptionRepair);
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
        public string componentName{get;set;}
        public string AccessCodeSaved{get;set;}
        public decimal AccessCodetimeA{get;set;}
        public decimal AccessCodetimeB{get;set;}
        public decimal AccessCodetimeC{get;set;}
        public decimal AccessCodetimeD{get;set;}
        public decimal AccessCodetimeR{get;set;}
        public string SRTAccessCode{get;set;}
        public string AccessCode{get;set;}
        public string accountcode{get;set;}
        public string srtID{get;set;}
        public string srtDescription{get;set;}
        public string assignmentValue{get;set;}
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
        public Boolean accessCodeFlag{get;set;}
        public Boolean percentReqFlag{get;set;}

        public boolean isUserEntered{get;set;}
        public Boolean flexFlag{get;set;}
        public string stepId{get;set;}
        public string srtUsage{get;set;}

        public srtWrapper(){
            this.failcode = failcode;
        }
    }

}