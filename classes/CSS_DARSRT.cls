public class CSS_DARSRT {

    public List<srtWrapper> diagListWrap{get;set;}
    public List<srtWrapper> repListWrap{get;set;}
    public List<srtWrapper> additionalDiagListWrap{get;set;}
    public List<srtWrapper> additionalRepListWrap{get;set;}
    public List<CSS_SRT__c> lstSRT_VS{get;set;} 
    public String sVfComp;
    public String SelectedFailCode{get;set;}
    public String SelectedaccCode{get;set;}
    public Boolean acccodelst{get;set;}
    public Boolean failcodelst{get;set;}
    public Boolean oneaccfailcode{get;set;}
    public Boolean totalPrivate{get;set;}
    /*-remove Total Private for dealers & factory user logged in to dealer's location--#165410 by Sneha -*/
    public Boolean isDealerUser{ get;
                                set {           
                                    isDealerUser = value;
                                    if(isDealerUser == true)
                                    {
                                        totalPrivate = true;
                                    }  
                                    else
                                    {
                                        totalPrivate = false;
                                    }  
                                }
                               } 
    /*-remove Total Private for dealers & factory user logged in to dealer's location--#165410 by Sneha - END */
    public Boolean isSRTFC{get;set;}
    public List<SelectOption> accCodes{get;set;}
    public Map<String,List<SelectOption>> failAccountCodeMap{get;set;}
    public Map<id,List<SelectOption>> mapaccesscode{get;set;}//Added as part of the story#172627
    List<CSS_SRT__c> lstSRTinsert;
    public string Territory{get;set;}
    //story #145252 START
    public Map<String,String> accountCodeWithWarrantMap{get;set;}
    public String selectedSolId{get;set;}
    public String selectedSrtId{get;set;}
    public String seltdSRTId{get;set;} //new 
    public String seltdSolId{get;set;} //new 
    //story #145252 END
    public void setsVfComp(String argId){
        sVfComp = argId; 
        //System.debug('The value of svfComp is'+sVfComp);
    } 

    public String getsVfComp(){
        return sVfComp; 
    }
    // srtRepWrapper allSRT;
    List<CSS_Solution_Component__c> componentList = new List<CSS_Solution_Component__c>();
    public ID JobID{get;set;}
    srtWrapper diagList;
    srtWrapper repList;
    srtWrapper adddiagList;
    srtWrapper addrepList;
    compWrapper cSRT;
    compWrapper RepAccSRT;
    public boolean diagTotal{get;set{
        diagTotal=true;
    }}
    Transient List<CSS_Solutions__c> solutionList = new List<CSS_Solutions__c>();
    List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
    //Story# 109744
    // Transient  List<CSS_Srt__c> lstRepAccSRT = new List<CSS_Srt__c>();
    public Map<Id, Boolean> selected{get;set;}
    public Map<Id, Boolean> selected1{get;set;}
    public string diagnosisTime{get;set;}
    public string repairTime{get;set;}
    public Decimal diagAccTime{get;set;}
    public string repAccTime{get;set;}
    public boolean blsrt{get;set;}
    public Boolean displayPopup{get;set;}

    public void showPopup() {
        displayPopup = true;
    }

    public Boolean displayPopup1{get;set;}
    public void showPopup1() {
        displayPopup1 = true;
    }

    public List<CSS_srt__c> SRTList1{get;set;}

    //Story 78945 Start
    public boolean noDiagdataFlag{get;set;}
    public boolean noSearchResultDiagFlag{get;set;}
    public integer countDiag = 0;
    public string searchDiagValue{get;set;}
    list<CSS_srt__c> tempDiagStorageList;


    //story 78945 - start
    public boolean noRepdataFlag{get;set;}
    public boolean noSearchResultRepFlag{get;set;}
    public string searchValue{get;set;}
    public integer count = 0;
    list<CSS_srt__c> tempStorageList;


    public void getallData() {
        try{
            JobID=ApexPages.CurrentPage().getParameters().get('id');

            SRTList1 = [Select id,SRTAdmi_Check__c,SRT_Details__c,SRT_Usage__c,Extended_Hours__c,DuplicateSRTDetails__c,IsDuplicateSRT__c,SRT_Title__c,Name,SRT_Time__c,SRT_Notes__c,Diagnosis_Time__c,SRT_Decimal_Time__c,Job_Order__c,SRT_Id__c,SRT_Time_Hr_Min__c,
                        Admin_Miles_In__c,Flex_Flag__c,Admin_Miles_Out__c,Admin_Arrive_Job__c,Admin_Arrive_Shop__c,Admin_Finish_Job__c,Admin_Leave_Job__c,Admin_Left_Shop__c,Admin_Start_Job__c,SRT_Estimate__c
                        from CSS_SRT__c where Job_order__c=:JobID AND SRT_Type__c='Diagnostic' ];



            system.debug('SRTList1##' + SRTList1);  
        }
        catch(Exception e) {
            system.debug('Error in Admin SRT Component ## ' + e.getmessage());
        }
    }
    // Code change for decimal display time in brackets S-78784
    public decimal totalDecimalTimeRep{get;set;}
    public decimal totalDecimalTimediag{get;set;}
    public decimal totalDecimalTimeAccTot{get;set;}
    public decimal totalDecimalTimeAccRep{get;set;}
    public decimal totalDecimalTimePrivateDiag{get;set;} //Private Diag
    public decimal totalDecimalTimePrivateRep{get;set;} //Private Rep
    public String orgType{get; set;}
    public Map<String,CSS_JobEventTemporary__c> jobEventMap = new Map<String,CSS_JobEventTemporary__c>();
    public User u;
    public String EquipId{get; set;} // Story GSSC-20

    //public string jobAccesscode{get; set;}
    //Story #71789-Diag SRT-End
    public CSS_DARSRT(){
        try{
            JobID=ApexPages.CurrentPage().getParameters().get('id');

            string pageData = ApexPages.CurrentPage().getURL();
            system.debug('pageData**'+pageData);
            SysteM.debug(LOGGINGLEVEL.ERROR, 'The id is'+JobID);
            mapaccesscode = new Map<id,List<SelectOption>>();//Added as part of the story#172627.
            for(CSS_JobEventTemporary__c jet : [SELECT Id, Key__c, Attribute1__c, Attribute2__c, Attribute3__c FROM CSS_JobEventTemporary__c WHERE Key__c =: 'AccountCodes']){
                String temp = jet.Attribute3__c;//jet.Attribute2__c + ' ' + jet.Attribute3__c;
                if(temp != null && temp != '' && temp.trim() != ''){
                    jobEventMap.put(temp,jet);
                }
            }
            diagListWrapper();
            repListWrapper();
        }
        catch(Exception e){
            System.debug('The error in srt is'+e.getMessage()+e.getLineNumber());
        }
        orgType = css_utility.getOrgType(UserInfo.getUserId());
    }
    
    // i have copied below method from css_darsrt_ro class to css_darsrt class for fixing the as per defect GSSC-568,-By RAJESH 05th Feb 2020
        public PageReference gotoJobPlanSrt(){       
        JobID=ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanSRT?id='+JobID); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    public void repListWrapper(){
        try{
            failAccountCodeMap = new  Map<String, List<SelectOption>>();
            repListWrap = new  List<srtWrapper>();
            accountCodeWithWarrantMap = new Map<String,String>();
            totalDecimalTimePrivateDiag = 0;
            acccodelst=false;
            failcodelst=false;
            oneaccfailcode=false;
            //story 78945
            noRepdataFlag = false;
            noSearchResultRepFlag = false;
            string pageData = ApexPages.CurrentPage().getURL();
            //Story #145252 START - Create accountCode Map for Warrantable
            JobID=ApexPages.CurrentPage().getParameters().get('id');

            system.debug('pageData**'+pageData);
            SysteM.debug(LOGGINGLEVEL.ERROR, 'The id is'+JobID);
            solutionList = [select id,Case_Name__c,Name,Solution_Title__c,Service_Job__r.AccessCode__c,Service_Job__r.Equipment_ID__c,Service_Job__c,Diagnostic_Response__c,Repair_Response__c,Symptom__r.Name,FaultCode__r.Name,
                            (select name,SRT_ID__c,SRT_Usage__c,Repair_Access_Calculated__c,Job_Order__r.Name,Job_Order__r.AccessCode__c,Additional_SRT_Calculated__c,Diagnosis_Time__c,SRT_Decimal_Time__c,id,step_id__c,SRT_Time__c,Component_Id__c ,Type__c,Response_Message__c ,Repair_Time__c,Access_Code_A__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__c,Assignment__c,SRT_Status_Message__c,SRT_Title__c ,isPerformed__c,SRT_Quantity__c,SRT_Notes__c ,SRT_Warrantable__c,
                             Access_Code_B__c,Flex_Flag__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Account_Code__c,FailCode__c,Access_Code_S1__c,Access_Code_S2__c,Access_Code_S3__c,Access_Code_S4__c,Access_Code_S5__c,Access_Code_S6__c,Access_Code_S7__c,Access_Code_S8__c,Access_Code_S9__c,S1_Description__c,S2_Description__c,S3_Description__c,S4_Description__c,Diag_Access_Time__c,
                             S5_Description__c,DuplicateSRTDetails__c,IsDuplicateSRT__c,SRT_Access_Code__c,Access_Code__c,S6_Description__c,S7_Description__c,S8_Description__c,S9_Description__c,Special_Access_Code__c,Special_Access_Code_Desc__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code_Saved__c,Extended_Hours__c,SRT_Estimate__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,SRT_Category__c from CSS_SRTS__r where CSS_Claims__c=null order by SRT_Order__c asc)
                            from CSS_Solutions__c where Service_Job__c=:JobID];
            //Added Root_Cause__c field and condition Root_Cause__c = true in where clause in below query as part of the story GSSC-385(User story 4)
            componentList = [select name,Root_Cause__c,action__c,Component_Id__c,CampaignLaborPercentage__c, System_Code__c,Component_Code__c,AccountCode__c,Type__c,FailCode_Formula__c,AccountCodeEdit__c ,Fail_Code__c,Solutions__r.Diagnostic_Response__c,Fail_Code_Editable__c,CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredTowingMiles__c,CoveredTravelLabor__c,CoveredTravelMiles__c,Solutions__c,Solutions__r.id,Quantity__c,Service_Job__c,Service_Job__r.AccessCode__c,Selected_Component__c, Solutions__r.Repair_Response__c ,Solutions__r.Symptom__r.Name,Solutions__r.FaultCode__r.Name,CSS_Account_Formula__c,
                             (select name,SRT_ID__c,SRT_Usage__c,SRT_Access_Code__c,SRT_Category__c,Flex_Flag__c,DuplicateSRTDetails__c,IsDuplicateSRT__c,Job_Engine_Access_Code__c,Extended_Hours__c,Job_Order__r.Name,Job_Order__r.AccessCode__c,Repair_Access_Calculated__c,step_id__c,id,SRT_Time__c,Account_Code__c,FailCode__c,Type__c,Additional_SRT_Calculated__c,Repair_Time__c,SRT_AccessiblityCheck__c,Diag_Access_Time__c,Diagnosis_Time__c,SRT_Decimal_Time__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Component_Id__c ,Solution_Title__c,Solution_Number__c,Assignment__c,SRT_Title__c ,Response_Message__c ,isPerformed__c,SRT_Quantity__c,SRT_Notes__c ,SRT_Warrantable__c,SRT_Order__c,Access_Code__c,SRT_Estimate__c,Adjustment_Reason__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c
                              from CSS_SRTS__r where CSS_Claims__c=null and Assignment__c IN ('Primary', 'Progressive Damage','Alternative') and isDuplicateRootCause__c =: false order by CSS_AssignmentOrder__c,SRT_ID__c asc ) //Removed ",'NOT CLAIMABLE'" from the query as per defect 569
                             from CSS_Solution_Component__c where Service_Job__c=:JobID AND Root_Cause__c = true];  //isDuplicateRootCause__c condition by krishna.

            additionalSRTList  = [select name,Assignment__c,SRT_ID__c,SRT_Usage__c,id,DuplicateSRTDetails__c,Flex_Flag__c,SRT_Access_Code__c,IsDuplicateSRT__c,Extended_Hours__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Estimate__c,Job_Order__r.Name, Repair_Access_Calculated__c,Account_Code__c,FailCode__c,SRT_Time__c,step_id__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Time__c,Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,SRT_Status_Message__c,SRT_Notes__c ,SRT_Warrantable__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code__c,Access_Code_Saved__c,job_order__r.AccessCode__c,srt_category__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c
                                  from CSS_SRT__C where Job_Order__c=:JobID and Solution_Number__c = null];
            for(CSS_Solution_Component__c f:componentList ){
                system.debug('inside accountcode '+componentList);
                    system.debug('inside accountcode '+f.CSS_Account_Formula__c );

                if(f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !='' && f.CSS_Account_Formula__c !=null ){
                    system.debug('inside accountcode not null');
                    CSS_JobEventTemporary__c tempJET;
                    if(!accountCodeWithWarrantMap.containsKey(f.CSS_Account_Formula__c)){
                        if(f.CSS_Account_Formula__c != null &&  f.CSS_Account_Formula__c != '' && f.CSS_Account_Formula__c != 'Select One')
                            tempJET = jobEventMap.get(f.CSS_Account_Formula__c.RIGHT(2));
                        String coverageType;
                        system.debug('f.CSS_Account_Formula__c-->'+f.CSS_Account_Formula__c);
                        if(tempJET != null){
                            coverageType = tempJET.Attribute1__c;
                            system.debug('coverageType-->'+coverageType); 
                        }
                        if((coverageType == 'OTH' || coverageType == 'POL') ||(f.CoveredLaborHrs__c!=null && f.CoveredLaborHrs__c!='' && Double.ValueOf(f.CoveredLaborHrs__c) > 0)){ 
                            accountCodeWithWarrantMap.put(f.CSS_Account_Formula__c,'100');
                        }
                        else{
                            accountCodeWithWarrantMap.put(f.CSS_Account_Formula__c,'0');
                        }    
                    }

                }    

            }
            system.debug('accountCodeWithWarrantMap' + accountCodeWithWarrantMap);
            //Story #145252 -  END 
            //moved below code to here
            List<SelectOption> failcodeList = getfailcodeDropDown();
            List<SelectOption> accodeList = getAccountCodeDropDown();

            system.debug('failcodeList'+failcodeList);
            system.debug('accodeList'+accodeList);
            system.debug('acccodelst'+acccodelst);
            system.debug('failcodelst'+failcodelst);
            if(acccodelst==true && failcodelst==true){
                oneaccfailcode=true; 
            }

            system.debug('KALcomponentList0**'+componentList);
            system.debug(LOGGINGLEVEL.ERROR,'solutionList is '+solutionList);
            system.debug(LOGGINGLEVEL.ERROR,'additionalSRTList is '+additionalSRTList);
            selected= new Map<Id, Boolean>();

            decimal timeRep = 0.0;
            decimal timeAcc = 0.0;
            decimal timeAccRep = 0.0;
            decimal timePrivateRep=0.0;
            //decimal timeAccTot = 0.0;
            decimal timeAccRepTot =0.0;
            decimal timeAddRepTime =0.0;
            integer iquantity;
            integer irquantity;
            integer iDiagTime;
            integer iMinutes;
            integer iHour;
            integer iRepTime;
            integer iRepMinutes;
            integer iRepHour;
            integer iAccTime;
            integer iAccMinutes;
            Decimal NewiAccMinutes;
            Decimal NewiAccRepMinutes;
            integer iAccHour;
            integer iTAccTime;
            integer iTAccMinutes;
            integer iTAccHour;
            integer iAccRepTime;
            integer iAccRepMinutes;
            Decimal NewiRAccRepMinutes;
            Decimal NewiAddRepMinutes;
            integer iAccRepHour;
            integer iRAccRepTime;
            integer iRAccRepMinutes;
            integer iRAccRepHour;
            integer iAddRepTime;
            integer iAddRepHour;
            integer iAddRepMinutes;            
            integer iAddDiagTime;
            integer iAddDiagHour;
            integer iAddDiagMinutes;            
            string sDTime;
            string sATime = '0.0';
            string sADTime;
            string sARTime;
            string sARTimeIn;
            string sRTime;
            String sAddRepTime;
            String sAddDiagTime;
            blsrt = false;
            integer inc=0;
            integer inc1=0;
            //Story 109744** Start
            map<id,list<CSS_SRT__C>> mapRepairAccessRec = new map<id,list<CSS_SRT__C>>();
            //Story 109744** End
            system.debug('diagListWrap nisha'+diagListWrap);
            system.debug(LOGGINGLEVEL.ERROR,'solutionList nisha2'+solutionList);
            for(CSS_Solutions__c sol:solutionList){
                Integer solCompCount = 0;
                Integer allSRTCountForSol = 0;
                timeAccRep = 0.0;
                repList = new srtWrapper();

                system.debug('Anirudh 2 diagList'+diagList);
                if(sol.CSS_SRTS__r!=null && !sol.CSS_SRTS__r.isEmpty()){
                    //Story 109744** start
                    if(mapRepairAccessRec != null && !mapRepairAccessRec.containsKey(sol.id))
                    {
                        mapRepairAccessRec.put(sol.id, new list<CSS_SRT__c>());
                    }
                    //Story 109744** End.
                    for(integer a=0;a<sol.CSS_SRTS__r.size();a++){
                        if(sol.CSS_SRTS__r[a].Type__c!=null){
                            if(sol.CSS_SRTS__r[a].Type__c.equalsIgnoreCase('Repair Access') && sol.CSS_SRTS__r[a].Solution_Number__c == sol.id ){
                                system.debug('entered'+sol.CSS_SRTS__r[a].Type__c+'pageData'+pageData);
                                //Code added for story#172627
                                if(!mapaccesscode.containsKey(sol.CSS_SRTS__r[a].id))
                                    mapaccesscode.put(sol.CSS_SRTS__r[a].id,new list<selectoption>());
                                CG_UtilityForSRT srtrepair = new CG_UtilityForSRT();
                                list<selectoption> RepairAccesscodetmp=srtrepair.getAccesscodejoboption(string.valueOf(sol.CSS_SRTS__r[a].Access_Code_A__c),string.valueOf(sol.CSS_SRTS__r[a].Access_Code_B__c),string.valueOf(sol.CSS_SRTS__r[a].Access_Code_C__c),string.valueOf(sol.CSS_SRTS__r[a].Access_Code_D__c),string.valueOf(sol.CSS_SRTS__r[a].Access_Code_R__c),sol.Service_Job__r.AccessCode__c, sol.CSS_SRTS__r[a].SRT_Access_Code__c, 'RepairOrFA');
                                if(RepairAccesscodetmp.size()>0)
                                    mapaccesscode.put(sol.CSS_SRTS__r[a].id,RepairAccesscodetmp);
                                if(string.isBlank(sol.CSS_SRTS__r[a].Access_Code__c)) //Setting up default value
                                {
                                    repList.AccessCode = sol.CSS_SRTS__r[a].SRT_Access_Code__c;
                                    sol.CSS_SRTS__r[a].Access_Code__c=repList.AccessCode;
                                    system.debug('InsideIf**'+sol.CSS_SRTS__r[a].SRT_Access_Code__c);
                                }
                                else
                                {
                                    repList.AccessCode = sol.CSS_SRTS__r[a].Access_Code__c;
                                    system.debug('InsideElse**'+sol.CSS_SRTS__r[a].Access_Code__c);
                                }
                                //end
                                if(pageData.containsIgnoreCase('JobTnDRj') || pageData.containsIgnoreCase('JobRepair') || pageData.containsIgnoreCase('JobReadOnly')){ //  || pageData.containsIgnoreCase('JobPlan')){
                                    system.debug('sol.Repair_Response__c'+sol.Repair_Response__c+'sol.Diagnostic_Response__c'+sol.Diagnostic_Response__c);

                                    if(sol.Repair_Response__c!=null && sol.Diagnostic_Response__c == 'Most likely the solution'){
                                        boolean compCheck;

                                        for(CSS_Solution_Component__c solComp : componentList){
                                            if(solComp.Selected_Component__c){
                                                compCheck = true;
                                                break;
                                            }
                                        }
                                        if(sol.CSS_SRTS__r[a].SRT_AccessiblityCheck__c && compCheck ==  true){
                                            system.debug('timeAccRep**'+timeAccRep);
                                            timeAccRep =  sol.CSS_SRTS__r[a].Repair_Access_Calculated__c; 

                                            repList.accRepTime = string.valueof(sol.CSS_SRTS__r[a].Repair_Access_Calculated__c);
                                            timeAccRepTot = timeAccRepTot + (sol.CSS_SRTS__r[a].Repair_Access_Calculated__c * sol.CSS_SRTS__r[a].SRT_Quantity__c);
                                            repAccTime = string.valueof(sol.CSS_SRTS__r[a].Repair_Access_Calculated__c);
                                        }
                                    }
                                }else{
                                    if(sol.CSS_SRTS__r[a].SRT_AccessiblityCheck__c){

                                        system.debug('timeAccRep**'+timeAccRep);
                                        timeAccRep =  sol.CSS_SRTS__r[a].Repair_Access_Calculated__c; 

                                        repList.accRepTime = string.valueof(sol.CSS_SRTS__r[a].Repair_Access_Calculated__c);
                                        timeAccRepTot = timeAccRepTot + (sol.CSS_SRTS__r[a].Repair_Access_Calculated__c * sol.CSS_SRTS__r[a].SRT_Quantity__c);
                                        repAccTime = string.valueof(sol.CSS_SRTS__r[a].Repair_Access_Calculated__c);
                                    }
                                }
                                //Story 109744** start //adding repair access srt to the list
                                if(mapRepairAccessRec != null && mapRepairAccessRec.keySet().size() > 0){
                                    mapRepairAccessRec.get(sol.id).add(sol.CSS_SRTS__r[a]);
                                }

                            }
                        }
                    }
                    system.debug('chakshu222');
                    system.debug('mapRepairAccessRec---chk'+mapRepairAccessRec);
                }
                //else
                System.debug('The value of sVfComp is'+sVfComp);
                //if(sVfComp == 'RJ'){
                system.debug('chakshu3333');
                if(repListWrap.size() == 0){
                    repList.showHeader = true;
                }
                else{
                    if((sol.Symptom__r.Name != null && sol.Symptom__r.Name.equals(repListWrap[inc1-1].symptomName)) || (sol.FaultCode__r.Name != null && sol.FaultCode__r.Name.equals(repListWrap[inc1-1].fautCodeName))){     
                        repList.showHeader = false;
                    }
                    else{
                        repList.showHeader = true;
                    }
                }
                system.debug('Outside For Loop'+pageData);
                if(pageData.containsIgnoreCase('JobTnDRj') || pageData.containsIgnoreCase('JobRepair') || pageData.containsIgnoreCase('JobReadOnly')){ // || pageData.containsIgnoreCase('JobPlan')){

                    if(sol.Repair_Response__c!=null && sol.Diagnostic_Response__c == 'Most likely the solution'){

                        repList.solTitle = sol.Solution_Title__c;
                        // repList.AccessCode = sol.Service_Job__r.AccessCode__c;
                        repList.solNum = sol.Name;
                        repList.jobOrderId = sol.Service_Job__c;
                        repList.solId = sol.id;
                        //story 109746 
                        repList.fautCodeName = sol.FaultCode__r.Name ;
                        repList.symptomName = sol.Symptom__r.Name ;

                        //end story 109746
                        system.debug('KALcomponentList**'+componentList);
                        //Story# 109744 -- START
                        Boolean AddAccSRT = false; //--END
                        system.debug('nisham'+componentList);
                        for(CSS_Solution_Component__c solComp : componentList){
                            system.debug('chakshu');
                            if(solComp.Selected_Component__c){
                                cSRT = new compWrapper();
                                if(solComp.Solutions__c == sol.id){
                                    if(solComp.CSS_SRTS__r!=null && !solComp.CSS_SRTS__r.isEmpty()){
                                        cSRT.compName = solComp.Name;
                                        cSRT.compId = solComp.Component_Id__c;
                                        cSRT.compenentId=solComp.Id;
                                        CSS_JobEventTemporary__c tempJET;
                                        if(solComp.CSS_Account_Formula__c!=null && solComp.CSS_Account_Formula__c!='') // Defect 191092
                                            tempJET = jobEventMap.get(solComp.CSS_Account_Formula__c.RIGHT(2));

                                        String coverageType;
                                        system.debug('solComp.CSS_Account_Formula__c-->'+solComp.CSS_Account_Formula__c);
                                        if(tempJET != null){
                                            coverageType = tempJET.Attribute1__c;
                                            system.debug('coverageType-->'+coverageType);
                                        }
                                        //added as part of 111885
                                        if((coverageType == 'POL' || coverageType == 'OTH') || (solComp.CoveredLaborHrs__c!=null && solComp.CoveredLaborHrs__c!='' && Double.ValueOf(solComp.CoveredLaborHrs__c) > 0)){
                                            cSRT.percentagewarranty = '100';
                                            system.debug('percentagewarranty'+ cSRT.percentagewarranty);
                                        }
                                        else{
                                            cSRT.percentagewarranty = '0';
                                            system.debug('percentagewarranty'+ cSRT.percentagewarranty);
                                        }
                                        //end
                                        cSRT.srtCount = solComp.CSS_SRTS__r.size();
                                        integer j;//Anirudh
                                        for(j=0;j<solComp.CSS_SRTS__r.size();j++){
                                            allSRTCountForSol = allSRTCountForSol + 1;

                                            //The below code added for the stroy#172627
                                            if(!mapaccesscode.containsKey(solComp.CSS_SRTS__r[j].id))
                                                mapaccesscode.put(solComp.CSS_SRTS__r[j].id, new list<selectoption>());
                                            //end
                                            //allSRT = new srtRepWrapper();
                                            //Story# 109744: To Display Rep Access SRTs alogn with Repair SRTs
                                            if(solComp.CSS_SRTS__r[j].Type__c.equalsIgnoreCase('Repair') && solComp.CSS_SRTS__r[j].Solution_Number__c == sol.id  && solComp.Solutions__c == sol.id && solComp.Id==solComp.CSS_SRTS__r[j].Component_Id__c){
                                                //if((solComp.CSS_SRTS__r[j].Type__c.equalsIgnoreCase('Repair') || solComp.CSS_SRTS__r[j].Type__c.equalsIgnoreCase('Repair Access')) && solComp.CSS_SRTS__r[j].Solution_Number__c == sol.id  && solComp.Solutions__c == sol.id && solComp.Id==solComp.CSS_SRTS__r[j].Component_Id__c){
                                                System.debug('The srt is'+solComp.CSS_SRTS__r[j]);

                                                // repList.AccessCode = solComp.CSS_SRTS__r[j].SRT_Access_Code__c;
                                                //Below code added as part of the Story#172627.
                                                if(string.isBlank(solComp.CSS_SRTS__r[j].Access_Code__c)) //Setting up default value
                                                {
                                                    repList.AccessCode = solComp.CSS_SRTS__r[j].SRT_Access_Code__c;
                                                    solComp.CSS_SRTS__r[j].Access_Code__c=repList.AccessCode;
                                                }
                                                else
                                                {
                                                    repList.AccessCode = solComp.CSS_SRTS__r[j].Access_Code__c;
                                                }

                                                CG_UtilityForSRT srtrepair = new CG_UtilityForSRT();
                                                list<selectoption> RepairAccesscodetmp=srtrepair.getAccesscodejoboption(string.valueOf(solComp.CSS_SRTS__r[j].Access_Code_A__c),string.valueOf(solComp.CSS_SRTS__r[j].Access_Code_B__c),string.valueOf(solComp.CSS_SRTS__r[j].Access_Code_C__c),string.valueOf(solComp.CSS_SRTS__r[j].Access_Code_D__c),string.valueOf(solComp.CSS_SRTS__r[j].Access_Code_R__c),solComp.Service_Job__r.AccessCode__c,solComp.CSS_SRTS__r[j].SRT_Access_Code__c, 'RepairOrFA');

                                                if(RepairAccesscodetmp.size()>0)
                                                    mapaccesscode.put(solComp.CSS_SRTS__r[j].id,RepairAccesscodetmp);
                                                //end
                                                //solComp.CSS_SRTS__r[j].Access_Code__c  = solComp.CSS_SRTS__r[j].Job_Engine_Access_Code__c;

                                                if(solComp.CSS_SRTS__r[j].FailCode__c != null  && solComp.CSS_SRTS__r[j].FailCode__c!='Select One'){
                                                    solComp.CSS_SRTS__r[j].FailCode__c  = solComp.CSS_SRTS__r[j].FailCode__c;}
                                                if(solComp.CSS_SRTS__r[j].Account_Code__c != null && solComp.CSS_SRTS__r[j].Account_Code__c!='Select One'){
                                                    solComp.CSS_SRTS__r[j].Account_Code__c  = solComp.CSS_SRTS__r[j].Account_Code__c;}

                                                //add coode here for saving single failcode/accountcode into SRT object
                                                if(oneaccfailcode){
                                                    System.debug('oneaccfailcode 2'+ solComp.CSS_SRTS__r[j].SRT_ID__c);
                                                    solComp.CSS_SRTS__r[j].FailCode__c  = failcodeList.get(1).getLabel(); 
                                                    solComp.CSS_SRTS__r[j].Account_Code__c  = accodeList.get(1).getValue(); 
                                                }

                                                if((solComp.CSS_SRTS__r[j].Assignment__c != null)  ){
                                                    cSRT.repairList.add(solComp.CSS_SRTS__r[j]);
                                                    //story --90222 -- add record 
                                                    //cSRT.repairListWrap.add(new repairWrapper(solComp.CSS_SRTS__r[j]));
                                                    //story --90222 -- add record  end
                                                }
                                                if(solComp.CSS_SRTS__r[j].isPerformed__c == true){
                                                    //timeRep = timeRep + (solComp.CSS_SRTS__r[j].Repair_Time__c * solComp.CSS_SRTS__r[j].SRT_Quantity__c);
                                                    timeRep = timeRep + (solComp.CSS_SRTS__r[j].Extended_Hours__c);
                                                    //repairTime = repTime;
                                                }
                                                system.debug('chakshu');


                                                // STORY 78937
                                                system.debug('nisham'+sol.Service_Job__r.AccessCode__c);

                                            }
                                            //  System.debug('The all srt is'+allSRT);
                                            //cSRT.srtRepWrap.add(allSRT);
                                        }
                                        solCompCount = allSRTCountForSol + mapRepairAccessRec.get(sol.id).size();
                                        repList.allSRTCount = solCompCount;
                                        //RepAccSRT = new compWrapper();
                                        system.debug('RakeshmapRepairAccessRec**'+mapRepairAccessRec);
                                        if(!AddAccSRT)
                                            if(mapRepairAccessRec != null && mapRepairAccessRec.size()>0){
                                                cSRT.repairList.addAll(mapRepairAccessRec.get(sol.id));
                                                AddAccSRT = true;
                                            }
                                        //Story 109744** End

                                        repList.compSRT.add(cSRT);
                                        //repList.compSRT.add(RepAccSRT);
                                        system.debug('Dhaarmik**'+repList);
                                    }
                                }
                            }}

                    } 

                }
                else
                {
                    system.debug('KALSOL'+sol);
                    if(sol.Diagnostic_Response__c == 'Most likely the solution'){
                        repList.solTitle = sol.Solution_Title__c;
                        repList.solNum = sol.Name;
                        repList.jobOrderId = sol.Service_Job__c;
                        repList.solId = sol.id;

                        //story 109746 
                        //repList.AccessCode = sol.Service_Job__r.AccessCode__c;
                        repList.fautCodeName = sol.FaultCode__r.Name ;
                        repList.symptomName = sol.Symptom__r.Name ;

                        //end story 109746
                        system.debug('KALSOLCOMP'+componentList);
                        Integer repCompCount = 0;
                        Boolean AddAccSRT1 = false;
                        for(CSS_Solution_Component__c solComp : componentList){
                            repCompCount = repCompCount + 1;
                            cSRT = new compWrapper(); 
                            system.debug('Inside Comp For Loop');
                            CSS_JobEventTemporary__c tempJET;
                            if(solComp.CSS_Account_Formula__c != 'Select One' && solComp.CSS_Account_Formula__c != '' && solComp.CSS_Account_Formula__c != null){
                                tempJET= jobEventMap.get(solComp.CSS_Account_Formula__c.RIGHT(2));
                            }
                            system.debug('solComp.CSS_Account_Formula__c-->'+solComp.CSS_Account_Formula__c);
                            String coverageType;
                            if(tempJET != null){
                                coverageType = tempJET.Attribute1__c;
                                system.debug('coverageType-->'+coverageType);
                            }
                            if(solComp.Solutions__c == sol.id){
                                system.debug('Inside IF Solution');

                                if(solComp.CSS_SRTS__r!=null && !solComp.CSS_SRTS__r.isEmpty()){
                                    system.debug('Inside IF SRT');
                                    cSRT.compName = solComp.Name;
                                    cSRT.compId = solComp.Component_Id__c;
                                    cSRT.compenentId=solComp.Id;

                                    if((coverageType == 'POL' || coverageType == 'OTH') || (solComp.CoveredLaborHrs__c!=null && solComp.CoveredLaborHrs__c!='' && Double.ValueOf(solComp.CoveredLaborHrs__c) > 0)){
                                        cSRT.percentagewarranty = '100';
                                        system.debug('percentagewarranty'+ cSRT.percentagewarranty);
                                    }
                                    else{
                                        cSRT.percentagewarranty = '0';
                                        system.debug('percentagewarranty'+ cSRT.percentagewarranty);
                                    }

                                    //end
                                    cSRT.srtCount = solComp.CSS_SRTS__r.size();  
                                    integer k;
                                    system.debug('SolCompSize**'+solComp.CSS_SRTS__r.size());
                                    for(k=0;k<solComp.CSS_SRTS__r.size();k++){
                                        System.debug('oneaccfailcode 3&&&&'+ solComp.CSS_SRTS__r[k].SRT_ID__c);
                                        allSRTCountForSol = allSRTCountForSol + 1;
                                        //Added code for the story#172625
                                        if(!mapaccesscode.containsKey(solComp.CSS_SRTS__r[k].id))
                                            mapaccesscode.put(solComp.CSS_SRTS__r[k].id,new list<selectoption>());
                                        //END
                                        // allSRT = new srtRepWrapper();
                                        //Story# 109744: To Display Rep Access SRTs alogn with Repair SRTs
                                        if(solComp.CSS_SRTS__r[k].Type__c.equalsIgnoreCase('Repair') && solComp.CSS_SRTS__r[k].Solution_Number__c == sol.id  && solComp.Solutions__c == sol.id && solComp.Id==solComp.CSS_SRTS__r[k].Component_Id__c){
                                            //if((solComp.CSS_SRTS__r[k].Type__c.equalsIgnoreCase('Repair') || solComp.CSS_SRTS__r[k].Type__c.equalsIgnoreCase('Repair Access')) && solComp.CSS_SRTS__r[k].Solution_Number__c == sol.id  && solComp.Solutions__c == sol.id && solComp.Id==solComp.CSS_SRTS__r[k].Component_Id__c){
                                            //System.debug('The srt is'+solComp.CSS_SRTS__r[k]);
                                            //repList.AccessCode = solComp.CSS_SRTS__r[k].Job_Engine_Access_Code__c;


                                            //Below code added as part of the Story#172627.

                                            if(string.isBlank(solComp.CSS_SRTS__r[k].Access_Code__c))//Setting up default value for the story#172627
                                            {
                                                repList.AccessCode = solComp.CSS_SRTS__r[k].SRT_Access_Code__c;
                                                solComp.CSS_SRTS__r[k].Access_Code__c=repList.AccessCode;
                                            }
                                            else{
                                                repList.AccessCode = solComp.CSS_SRTS__r[k].Access_Code__c;
                                            }
                                            CG_UtilityForSRT srtrepair = new CG_UtilityForSRT();
                                            list<selectoption> RepairAccesscodetmp=srtrepair.getAccesscodejoboption(string.valueOf(solComp.CSS_SRTS__r[K].Access_Code_A__c),string.valueOf(solComp.CSS_SRTS__r[K].Access_Code_B__c),string.valueOf(solComp.CSS_SRTS__r[K].Access_Code_C__c),string.valueOf(solComp.CSS_SRTS__r[K].Access_Code_D__c),string.valueOf(solComp.CSS_SRTS__r[K].Access_Code_R__c),solComp.Service_Job__r.AccessCode__c, solComp.CSS_SRTS__r[K].SRT_Access_Code__c, 'RepairOrFA');
                                            if(RepairAccesscodetmp.size()>0)
                                                mapaccesscode.put(solComp.CSS_SRTS__r[k].id,RepairAccesscodetmp);
                                            //end

                                            system.debug('solComp.CSS_SRTS__r[k].Account_Code__c**'+solComp.CSS_SRTS__r[k].Account_Code__c);
                                            system.debug('solComp.CSS_SRTS__r[k].SRT_Warrantable__c**'+solComp.CSS_SRTS__r[k].SRT_Warrantable__c);
                                            if(solComp.CSS_SRTS__r[k].Account_Code__c != null && solComp.CSS_SRTS__r[k].Account_Code__c!='Select One'){
                                                solComp.CSS_SRTS__r[k].Account_Code__c  = solComp.CSS_SRTS__r[k].Account_Code__c;}
                                            system.debug('Entered if: SRT_Warrantable__c22' +solComp.CSS_SRTS__r[k].SRT_Warrantable__c);    
                                            if(solComp.CSS_SRTS__r[k].SRT_Warrantable__c==null ){
                                                if(accountCodeWithWarrantMap.containsKey(solComp.CSS_SRTS__r[k].Account_Code__c)){                                            
                                                    solComp.CSS_SRTS__r[k].SRT_Warrantable__c = accountCodeWithWarrantMap.get(solComp.CSS_SRTS__r[k].Account_Code__c);
                                                    system.debug('Entered if: SRT_Warrantable__c' +solComp.CSS_SRTS__r[k].SRT_Warrantable__c);
                                                }
                                                else{
                                                    solComp.CSS_SRTS__r[k].SRT_Warrantable__c = '0';
                                                    system.debug('Entered else:SRT_Warrantable__c' +solComp.CSS_SRTS__r[k].SRT_Warrantable__c);

                                                }
                                            }
                                            if(solComp.CSS_SRTS__r[k].FailCode__c != null &&  solComp.CSS_SRTS__r[k].FailCode__c!='Select One'){
                                                solComp.CSS_SRTS__r[k].FailCode__c  = solComp.CSS_SRTS__r[k].FailCode__c;}
                                            /*if(solComp.CSS_SRTS__r[k].FailCode__c != null &&  solComp.CSS_SRTS__r[k].FailCode__c!='Select One' && solComp.CSS_SRTS__r[k].SRT_Warrantable__c == '100' && (solComp.CSS_SRTS__r[k].Account_Code__c == null || solComp.CSS_SRTS__r[k].Account_Code__c == '' || solComp.CSS_SRTS__r[k].Account_Code__c == 'Select One'))
                                            solComp.CSS_SRTS__r[k].Account_Code__c = solComp.CSS_Account_Formula__c;*/ //Kalpana's Code

                                            //add coode here for saving single failcode/accountcode into SRT object
                                            if(oneaccfailcode){
                                                System.debug('oneaccfailcode 3'+ solComp.CSS_SRTS__r[k].SRT_ID__c);
                                                solComp.CSS_SRTS__r[k].FailCode__c  = failcodeList.get(1).getLabel();
                                                solComp.CSS_SRTS__r[k].Account_Code__c  = accodeList.get(1).getValue();
                                            }

                                            if((solComp.CSS_SRTS__r[k].Assignment__c != null) ){
                                                cSRT.repairList.add(solComp.CSS_SRTS__r[k]);
                                                //Story -- 90222 add record 
                                                //cSRT.repairListWrap.add(new repairWrapper(solComp.CSS_SRTS__r[j]));
                                                //story 90222 End
                                            }
                                            if(solComp.CSS_SRTS__r[k].isPerformed__c == true){
                                                //timeRep = timeRep + (solComp.CSS_SRTS__r[k].Repair_Time__c * solComp.CSS_SRTS__r[k].SRT_Quantity__c);
                                                timeRep = timeRep + (solComp.CSS_SRTS__r[k].Extended_Hours__c);
                                                // repairTime = repTime;
                                            }
                                            /**************
***************
Anirudh Added for Repair SRT issue***** Confirm if any other isssue****/
                                            system.debug('nisham'+sol.Service_Job__r.AccessCode__c);

                                        }
                                    }
                                    solCompCount = allSRTCountForSol + mapRepairAccessRec.get(sol.id).size();
                                    repList.allSRTCount = solCompCount;
                                    //System.debug(LOGGINGLEVEL.ERROR,'The component wrap is'+cSRT);
                                    if(!AddAccSRT1)
                                        if(mapRepairAccessRec != null && mapRepairAccessRec.size()>0){
                                            cSRT.repairList.addAll(mapRepairAccessRec.get(sol.id));
                                            System.debug('cSRT.repairList'+cSRT.repairList);
                                            AddAccSRT1 = true;
                                        }
                                    //Story 109744** End

                                    repList.compSRT.add(cSRT);

                                }
                            }
                        }
                    }

                }



                if (repList.solTitle != null && repList.compSRT!=null && !repList.compSRT.isEmpty()){
                    repListWrap.add(repList);
                    inc1++;
                }
            }
            //diagnosisTime=sDTime;
            //repairTime = sRTime;

            //}

            //For Repair Additional SRT List
            System.debug('The additional list is'+additionalSRTList);
            system.debug('repListWrap--'+repListWrap);
            additionalRepListWrap = new List<srtWrapper>();
            if(additionalSRTList.size()>0){
                addrepList = new srtWrapper();   
                CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
                addrepList.solNum = 'Additional SRTS';
                cSRT = new compWrapper();
                cSRT.compName = 'Additional Components';
                //149764
                cSRT.PrivatecompName = 'Private SRTs';
                //end
                List<CSS_SRT__c> privateRepSrt =new  List<CSS_SRT__c>();
                List<CSS_SRT__c> RepSrt =new  List<CSS_SRT__c>();
                for (CSS_SRT__c addSRTLst:additionalSRTList){
                    System.debug('Seven');
                    //Added code for the story#172627
                    if(!mapaccesscode.containsKey(addSRTLst.id))
                        mapaccesscode.put(addSRTLst.id,new list<selectoption>());
                    //END
                    // if(addSRTLst.srt_category__c.equalsIgnoreCase('RepPopup')){
                    // if(addSRTLst.type__c.equalsIgnoreCase('Repair') || addSRTLst.type__c.equalsIgnoreCase('Access') || addSRTLst.type__c.equalsIgnoreCase('Admin')){    
                    if(addSRTLst.srt_category__c!= null && addSRTLst.srt_category__c.equalsIgnoreCase('AdditionalRep')){ //Kalpana: story#121938
                        //addrepList.AccessCode = addSRTLst.job_order__r.AccessCode__c; //Dhaarmik
                        // addrepList.AccessCode = addSRTLst.Job_Engine_Access_Code__c;
                        //Below code added as part of the Story#172627.

                        IF(string.isBlank(addSRTLst.Access_Code__c)){ //Setting up default value for the admin SRT 00-10S-00
                            if(addSRTLst.Access_Code_A__c==0 && addSRTLst.Access_Code_B__c==0 && addSRTLst.Access_Code_C__c==0 && addSRTLst.Access_Code_D__c==0 && addSRTLst.Access_Code_R__c!=0)
                            { 
                                addSRTLst.Access_Code__c='R';  
                                addSRTLst.SRT_Access_Code__c='R';
                            }
                            else{
                                addSRTLst.Access_Code__c=addSRTLst.Job_Engine_Access_Code__c;
                            }

                        }
                        else{
                            adddiagList.AccessCode = addSRTLst.Access_Code__c;
                        }


                        //Note:-Here default value is not settingup here, Because, It was setup in save method of editpopup already.
                        //Note: In above we are setting up default value ,After find one observation which is related to admin SRT 00-10S-00.
                        CG_UtilityForSRT srtrepair = new CG_UtilityForSRT();
                        list<selectoption> addRepAccesscodetmp=srtrepair.getAccesscodejoboption(string.valueOf(addSRTLst.Access_Code_A__c),string.valueOf(addSRTLst.Access_Code_B__c),string.valueOf(addSRTLst.Access_Code_C__c),string.valueOf(addSRTLst.Access_Code_D__c),string.valueOf(addSRTLst.Access_Code_R__c),addSRTLst.job_order__r.AccessCode__c,addSRTLst.SRT_Access_Code__c, 'RepairOrFA');
                        //list<selectoption> addRepAccesscodetmp=srtrepair.getAccesscodejoboption(string.valueOf(addSRTLst.Access_Code_A__c),string.valueOf(addSRTLst.Access_Code_B__c),string.valueOf(addSRTLst.Access_Code_C__c),string.valueOf(addSRTLst.Access_Code_D__c),string.valueOf(addSRTLst.Access_Code_R__c),addSRTLst.job_order__r.AccessCode__c,addrepList.AccessCode, 'RepairOrFA');
                        if(addRepAccesscodetmp.size()>0)
                            mapaccesscode.put(addSRTLst.Id,addRepAccesscodetmp);
                        //end


                        //add coode here for saving single failcode/accountcode into SRT object
                        if(oneaccfailcode){
                            System.debug('oneaccfailcode 6'+addSRTLst.SRT_ID__c);
                            addSRTLst.FailCode__c  = failcodeList.get(1).getLabel();
                            addSRTLst.Account_Code__c  = accodeList.get(1).getValue();
                        }
                        //149764
                        if(addSRTLst.type__c=='Private'){
                            addrepList.PrivateSrtCount+=1;
                            addSRTLst.Account_Code__c = '';
                            privateRepSrt.add(addSRTLst);
                        }
                        if(addSRTLst.type__c!='Private'){
                            addrepList.addSrtCount+=1;
                            RepSrt.add(addSRTLst);
                        }

                        //end
                        //}


                        if(addSRTLst.type__c.equalsIgnoreCase('Access') && addSRTLst.SRT_AccessiblityCheck__c == true){ //Kalpana: story#121938
                            timeAccRepTot = timeAccRepTot+(addSRTLst.SRT_Time__c * addSRTLst.SRT_Quantity__c);
                        }
                        //if(addSRTLst.isPerformed__c == true && addSRTLst.type__c != 'Access'){ //Kalpana: Added Type!='Access' Condition //&& addSRTLst.type__c.equalsIgnoreCase('Repair')){ 
                        if((addSRTLst.isPerformed__c == true && addSRTLst.type__c != 'Access') || (addSRTLst.SRT_AccessiblityCheck__c == true && addSRTLst.type__c != null && addSRTLst.type__c != '' && addSRTLst.type__c.contains('Access'))){ //defect fix 189171: Commented above line to include all types of SRTs to calculate time
                            //timeRep = timeRep+(addSRTLst.Additional_SRT_Calculated__c * addSRTLst.SRT_Quantity__c);           
                            timeRep = timeRep+(addSRTLst.Extended_Hours__c);           
                        }
                        if(addSRTLst.isPerformed__c == true && addSRTLst.type__c == 'Private'){
                            timePrivateRep = timePrivateRep+(addSRTLst.Additional_SRT_Calculated__c * addSRTLst.SRT_Quantity__c);           
                        }

                    }
                    // }
                }

                //149764
                if(RepSrt.size()>0){
                    cSRT.additionalSRT.addAll(RepSrt); }
                if(privateRepSrt.size()>0){
                    cSRT.additionalSRT.addAll(privateRepSrt); }
                //end
                addrepList.compSRT.add(cSRT);

                if(addrepList.compSRT.size()>0){
                    additionalRepListWrap.add(addrepList);
                }    

            }
            // story no 78784 change show value in decimal in bracket timeAccRepTot
            totalDecimalTimeRep = timeRep;
            totalDecimalTimePrivateRep = timePrivateRep;

            system.debug('totalDecimalTimediag nisha'+totalDecimalTimediag);
            totalDecimalTimeAccRep = timeAccRepTot;



        }

        catch(Exception e){
            System.debug('The error in srt is'+e.getMessage()+e.getLineNumber());
        }


    }
    public void diagListWrapper(){
        try{

            failAccountCodeMap = new  Map<String, List<SelectOption>>();
            diagListWrap = new  List<srtWrapper>();
            accountCodeWithWarrantMap = new Map<String,String>();
            diagAccTime = 0;
            totalDecimalTimePrivateDiag = 0;
            acccodelst=false;
            failcodelst=false;
            oneaccfailcode=false;
            //story 78945
            noSearchResultDiagFlag = false;
            noDiagdataFlag = false;
            additionalDiagListWrap = new List<srtWrapper>();
            CG_UtilityForSRT srtdiag = new CG_UtilityForSRT();//Story 172627
            //Story #145252 START - Create accountCode Map for Warrantable
            JobID=ApexPages.CurrentPage().getParameters().get('id');

            SysteM.debug(LOGGINGLEVEL.ERROR, 'The id is'+JobID);
            solutionList = [select id,Case_Name__c,Name,Solution_Title__c,Service_Job__r.AccessCode__c,Service_Job__r.Equipment_ID__c,Service_Job__c,Diagnostic_Response__c,Repair_Response__c,Symptom__r.Name,FaultCode__r.Name,
                            (select name,DuplicateSRTDetails__c,IsDuplicateSRT__c,SRT_ID__c,Repair_Access_Calculated__c,Job_Order__r.Name,Job_Order__r.AccessCode__c,Additional_SRT_Calculated__c,Diagnosis_Time__c,SRT_Decimal_Time__c,id,step_id__c,SRT_Time__c,Component_Id__c ,Type__c,Response_Message__c ,Repair_Time__c,Access_Code_A__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__c,Assignment__c,SRT_Status_Message__c,SRT_Title__c ,isPerformed__c,SRT_Quantity__c,SRT_Notes__c ,SRT_Warrantable__c,
                             Access_Code_B__c,Flex_Flag__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Account_Code__c,FailCode__c,Access_Code_S1__c,Access_Code_S2__c,Access_Code_S3__c,Access_Code_S4__c,Access_Code_S5__c,Access_Code_S6__c,Access_Code_S7__c,Access_Code_S8__c,Access_Code_S9__c,S1_Description__c,S2_Description__c,S3_Description__c,S4_Description__c,Diag_Access_Time__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,
                             S5_Description__c,SRT_Access_Code__c,Access_Code__c,S6_Description__c,S7_Description__c,S8_Description__c,S9_Description__c,Special_Access_Code__c,Special_Access_Code_Desc__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code_Saved__c,Extended_Hours__c,SRT_Estimate__c ,SRT_Category__c from CSS_SRTS__r where CSS_Claims__c=null order by SRT_Order__c asc)
                            from CSS_Solutions__c where Service_Job__c=:JobID and (Diagnostic_Response__c = 'Most likely the solution' OR Diagnostic_Response__c = 'Not the solution')];

            componentList = [select name,action__c,Component_Id__c,CampaignLaborPercentage__c, System_Code__c,Component_Code__c,AccountCode__c,Type__c,FailCode_Formula__c,AccountCodeEdit__c ,Fail_Code__c,Solutions__r.Diagnostic_Response__c,Fail_Code_Editable__c,CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredTowingMiles__c,CoveredTravelLabor__c,CoveredTravelMiles__c,Solutions__c,Solutions__r.id,Quantity__c,Service_Job__c,Service_Job__r.AccessCode__c,Selected_Component__c, Solutions__r.Repair_Response__c ,Solutions__r.Symptom__r.Name,Solutions__r.FaultCode__r.Name,CSS_Account_Formula__c,
                             (select name,DuplicateSRTDetails__c,Flex_Flag__c,SRT_Category__c,IsDuplicateSRT__c,SRT_ID__c,Job_Engine_Access_Code__c,Extended_Hours__c,Job_Order__r.Name,Job_Order__r.AccessCode__c,Repair_Access_Calculated__c,step_id__c,id,SRT_Time__c,Account_Code__c,FailCode__c,Type__c,Additional_SRT_Calculated__c,Repair_Time__c,SRT_AccessiblityCheck__c,Diag_Access_Time__c,Diagnosis_Time__c,SRT_Decimal_Time__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Component_Id__c ,Solution_Title__c,Solution_Number__c,Assignment__c,SRT_Title__c ,Response_Message__c ,isPerformed__c,SRT_Quantity__c,SRT_Notes__c ,SRT_Warrantable__c,SRT_Order__c,Access_Code__c,SRT_Estimate__c,Adjustment_Reason__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c
                              from CSS_SRTS__r where CSS_Claims__c=null and Assignment__c IN ('Primary', 'Progressive Damage','Alternative') order by Assignment__c desc ) 
                             from CSS_Solution_Component__c where Service_Job__c=:JobID];

            additionalSRTList  = [select name,DuplicateSRTDetails__c,Flex_Flag__c,Assignment__c,IsDuplicateSRT__c,SRT_ID__c,id,Extended_Hours__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Estimate__c,Job_Order__r.Name,Job_Order__r.AccessCode__c,SRT_Access_Code__c,Repair_Access_Calculated__c,Account_Code__c,FailCode__c,SRT_Time__c,step_id__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Time__c,Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,SRT_Status_Message__c,SRT_Notes__c ,SRT_Warrantable__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code__c,Access_Code_Saved__c,srt_category__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c
                                  from CSS_SRT__C where Job_Order__c=:JobID and Solution_Number__c = null];

            for(CSS_Solution_Component__c f:componentList ){

                if(f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !='' && f.CSS_Account_Formula__c != null){
                    CSS_JobEventTemporary__c tempJET = jobEventMap.get(f.CSS_Account_Formula__c.RIGHT(2));
                    String coverageType;
                    if(!accountCodeWithWarrantMap.containsKey(f.CSS_Account_Formula__c)){
                        if(tempJET != null){
                            coverageType = tempJET.Attribute1__c;
                            system.debug('coverageType-->'+coverageType);
                        }
                        if((coverageType == 'POL' || coverageType == 'OTH') || (f.CoveredLaborHrs__c != null && f.CoveredLaborHrs__c != '' && Double.ValueOf(f.CoveredLaborHrs__c) > 0)){
                            //cSRT.percentagewarranty = '100';
                            accountCodeWithWarrantMap.put(f.CSS_Account_Formula__c,'100');
                        }
                        else{
                            accountCodeWithWarrantMap.put(f.CSS_Account_Formula__c,'0');
                        }    
                    }

                }    

            }
            system.debug('accountCodeWithWarrantMap' + accountCodeWithWarrantMap);
            //Story #145252 -  END 
            List<SelectOption> failcodeList = getfailcodeDropDown();
            List<SelectOption> accodeList = getAccountCodeDropDown();
            // CompareFailCodes(); //Added to set a boolean, if the failcode is SRT failcode but not solComp failcode

            system.debug('failcodeList'+failcodeList);
            system.debug('accodeList'+accodeList);
            system.debug('acccodelst'+acccodelst);
            system.debug('failcodelst'+failcodelst);
            if(acccodelst==true && failcodelst==true){
                oneaccfailcode=true; 
            }

            system.debug('KALcomponentList0**'+componentList);
            system.debug(LOGGINGLEVEL.ERROR,'solutionList is '+solutionList);
            system.debug(LOGGINGLEVEL.ERROR,'additionalSRTList is '+additionalSRTList);
            selected= new Map<Id, Boolean>();
            decimal timediag=0.0;
            decimal timediagTot =0.0;
            decimal timeAcc = 0.0;
            decimal timeAccRep = 0.0;
            decimal timePrivateDiag=0.0;
            //decimal timeAccTot = 0.0;
            decimal timeAddDiagTime =0.0;
            integer iquantity;
            integer irquantity;
            integer iDiagTime;
            integer iMinutes;
            integer iHour;
            integer iRepTime;
            integer iRepMinutes;
            integer iRepHour;
            integer iAccTime;
            integer iAccMinutes;
            Decimal NewiAccMinutes;
            Decimal NewiAccRepMinutes;
            integer iAccHour;
            integer iTAccTime;
            integer iTAccMinutes;
            integer iTAccHour;
            integer iAccRepTime;
            integer iAccRepMinutes;
            Decimal NewiRAccRepMinutes;
            Decimal NewiAddRepMinutes;
            integer iAccRepHour;
            integer iRAccRepTime;
            integer iRAccRepMinutes;
            integer iRAccRepHour;
            integer iAddRepTime;
            integer iAddRepHour;
            integer iAddRepMinutes;            
            integer iAddDiagTime;
            integer iAddDiagHour;
            integer iAddDiagMinutes;            
            string sDTime;
            string sATime = '0.0';
            string sADTime;
            string sARTime;
            string sARTimeIn;
            string sRTime;
            String sAddRepTime;
            String sAddDiagTime;
            blsrt = false;
            integer inc=0;

            system.debug('diagListWrap nisha'+diagListWrap);
            system.debug(LOGGINGLEVEL.ERROR,'solutionList nisha2'+solutionList);
            for(CSS_Solutions__c sol:solutionList){
                Integer solCompCount = 0;
                Integer allSRTCountForSol = 0;
                timeAcc=0.0;
                diagList = new srtWrapper();

                if(sol.Diagnostic_Response__c!=null){
                    if(diagListWrap.size() == 0){
                        diagList.showHeader = true;
                    }
                    else{
                        if((sol.Symptom__r.Name != null && sol.Symptom__r.Name.equals(diagListWrap[inc-1].symptomName)) || (sol.FaultCode__r.Name != null && sol.FaultCode__r.Name.equals(diagListWrap[inc-1].fautCodeName))){    
                            diagList.showHeader = false;
                        }
                        else{
                            diagList.showHeader = true;
                        }
                    }
                    //inc++;
                    diagList.solTitle = sol.Solution_Title__c;
                    diagList.solNum = sol.Name;
                    diagList.jobOrderId = sol.Service_Job__c;
                    diagList.solId = sol.id;
                    //story 109746 
                    diagList.fautCodeName = sol.FaultCode__r.Name ;
                    diagList.symptomName = sol.Symptom__r.Name ;


                    //system.debug('Dhanvi**'+sol.CSS_SRTS__r);
                    list<CSS_SRT__c> dia = new List<CSS_SRT__c>();
                    if(sol.CSS_SRTS__r!=null && !sol.CSS_SRTS__r.isEmpty()){
                        for(integer i=0;i<sol.CSS_SRTS__r.size();i++){
                            //The below code added for the story#142625
                            if(!mapaccesscode.containsKey(sol.CSS_SRTS__r[i].id))
                                mapaccesscode.put(sol.CSS_SRTS__r[i].id, new list<selectoption>());
                            //end
                            //Story# 109744:To Display Diag Access SRTS along with Diag SRTs:
                            //if(sol.CSS_SRTS__r[i].Type__c.equalsIgnoreCase('Diagnosis') && sol.CSS_SRTS__r[i].Solution_Number__c == sol.id){
                            if((sol.CSS_SRTS__r[i].Type__c.equalsIgnoreCase('Diagnosis') || sol.CSS_SRTS__r[i].Type__c.equalsIgnoreCase('Diag Access'))&& sol.CSS_SRTS__r[i].Solution_Number__c == sol.id){

                                //Setting up default value for the story#172627
                                if(string.isBlank(sol.CSS_SRTS__r[i].Access_Code__c)){
                                    sol.CSS_SRTS__r[i].Access_Code__c  = sol.CSS_SRTS__r[i].Job_Engine_Access_Code__c;
                                    diagList.AccessCode=sol.CSS_SRTS__r[i].Job_Engine_Access_Code__c;
                                }
                                else
                                    if(sol.CSS_SRTS__r[i].SRT_Access_Code__c == null || sol.CSS_SRTS__r[i].SRT_Access_Code__c =='' )
                                        sol.CSS_SRTS__r[i].Access_Code__c='';
                                else
                                    diagList.AccessCode  = sol.CSS_SRTS__r[i].Access_Code__c;

                                //end

                                //diagList.diagWRAPsrt.add(sol.CSS_SRTS__r[i]);
                                //Story 90222 DiagSrt Sort start
                                //add coode here for saving single failcode/accountcode into SRT object
                                if(oneaccfailcode){
                                    System.debug('oneaccfailcode 1'+ sol.CSS_SRTS__r[i].SRT_ID__c);
                                    sol.CSS_SRTS__r[i].FailCode__c  = failcodeList.get(1).getLabel(); 
                                    sol.CSS_SRTS__r[i].Account_Code__c  = accodeList.get(1).getValue(); 
                                }
                                system.debug('sol.CSS_SRTS__r[i].Account_Code__c**'+sol.CSS_SRTS__r[i].Account_Code__c);
                                //Story #145252 START - Populate Warrantable based on Account Code   
                                if(sol.CSS_SRTS__r[i].Account_Code__c != null && sol.CSS_SRTS__r[i].Account_Code__c!='Select One'){
                                    sol.CSS_SRTS__r[i].Account_Code__c  = sol.CSS_SRTS__r[i].Account_Code__c;
                                    // if(sol.CSS_SRTS__r[i].SRT_Warrantable__c==null ||  sol.CSS_SRTS__r[i].SRT_Warrantable__c=='0' || sol.CSS_SRTS__r[i].SRT_Warrantable__c=='100'){
                                    if(sol.CSS_SRTS__r[i].SRT_Warrantable__c==null ){
                                        if(accountCodeWithWarrantMap.containsKey(sol.CSS_SRTS__r[i].Account_Code__c)){

                                            sol.CSS_SRTS__r[i].SRT_Warrantable__c = accountCodeWithWarrantMap.get(sol.CSS_SRTS__r[i].Account_Code__c);
                                            system.debug('Entered if: SRT_Warrantable__c' +sol.CSS_SRTS__r[i].SRT_Warrantable__c);
                                        }
                                        else{
                                            sol.CSS_SRTS__r[i].SRT_Warrantable__c = '0';
                                            system.debug('Entered else:SRT_Warrantable__c' +sol.CSS_SRTS__r[i].SRT_Warrantable__c);

                                        }
                                    }    

                                }
                                //Story #145252 - Populate Warrantable if Account Code is 'Select One'
                                if((sol.CSS_SRTS__r[i].Account_Code__c == null || sol.CSS_SRTS__r[i].Account_Code__c=='Select One') 
                                   && ( sol.CSS_SRTS__r[i].SRT_Warrantable__c==null || sol.CSS_SRTS__r[i].SRT_Warrantable__c=='0' || sol.CSS_SRTS__r[i].SRT_Warrantable__c=='100')){
                                    sol.CSS_SRTS__r[i].SRT_Warrantable__c = '0';
                                    system.debug('Entered else:SRT_Warrantable__c' +sol.CSS_SRTS__r[i].SRT_Warrantable__c);

                                }
                                //Story #145252 END


                                if(sol.CSS_SRTS__r[i].FailCode__c != null && sol.CSS_SRTS__r[i].FailCode__c=='Select One'){
                                    sol.CSS_SRTS__r[i].FailCode__c  = sol.CSS_SRTS__r[i].FailCode__c;   
                                }
                                diagList.lstDiagWrapSRT.add(new sortWrapper(sol.CSS_SRTS__r[i]));
                                system.debug('lstDiagWrapSRT**'+diagList.lstDiagWrapSRT);
                                //Story 90222 DiagSrt Sort End
                                if((sol.CSS_SRTS__r[i].isPerformed__c == true) && sol.CSS_SRTS__r[i].Type__c.equalsIgnoreCase('Diagnosis')){ //Kalpana Added Diagnosis Condition
                                    timediag = timediag + (sol.CSS_SRTS__r[i].Extended_Hours__c != null ? sol.CSS_SRTS__r[i].Extended_Hours__c  : 0.0);
                                }
                                if((sol.CSS_SRTS__r[i].SRT_AccessiblityCheck__c == true) && sol.CSS_SRTS__r[i].Type__c.equalsIgnoreCase('Diag Access')){ //Added for Access SRTs defect #176212
                                    timediag = timediag + (sol.CSS_SRTS__r[i].Extended_Hours__c != null ? sol.CSS_SRTS__r[i].Extended_Hours__c  : 0.0);
                                }
                                // STORY 78937
                                system.debug('sol.CSS_SRTS__r[i].Job_Engine_Access_Code__c**'+sol.CSS_SRTS__r[i].Job_Engine_Access_Code__c+'**srtid**'+sol.CSS_SRTS__r[i].SRT_ID__c);
                                diagList.AccessCode = sol.CSS_SRTS__r[i].Job_Engine_Access_Code__c;
                                diagList.EquipmentID = sol.Service_Job__r.Equipment_ID__c;
                                diagList.AccessCodeA = string.valueof(sol.css_Srts__r[i].Access_Code_A__c);
                                diagList.AccessCodeB = string.valueof(sol.css_Srts__r[i].Access_Code_B__c);
                                diagList.AccessCodeC = string.valueof(sol.css_Srts__r[i].Access_Code_C__c);
                                diagList.AccessCodeD = string.valueof(sol.css_Srts__r[i].Access_Code_D__c);
                                diagList.AccessCodeR = string.valueof(sol.css_Srts__r[i].Access_Code_R__c);
                                diagList.SpecialAccessCode = sol.css_Srts__r[i].Special_Access_Code__c;
                                diagList.SpecialDescription = sol.css_Srts__r[i].Special_Access_Code_Desc__c;

                                //Story 172627:- Calling method for getting list of accesscode.
                                list<selectoption> Diagaccesscodetemp=srtdiag.getAccesscodejoboption(diagList.AccessCodeA, diagList.AccessCodeB,diagList.AccessCodeC,diagList.AccessCodeD,diagList.AccessCodeR,sol.Service_Job__r.AccessCode__c,sol.CSS_SRTS__r[i].SRT_Access_Code__c,'Diag');
                                if(Diagaccesscodetemp.size()>0)
                                    mapaccesscode.put(sol.css_Srts__r[i].id,Diagaccesscodetemp);
                                //END

                                system.debug('Anirudh diagList>>>>>>>>>>>>>>>>'+diagList);
                                //END 78937 
                            }

                        }
                    }
                }
                system.debug('Anirudh 2 diagList'+diagList);
                //Below code usage is stopped i.e., diagAccTime
                if(sol.CSS_SRTS__r!=null && !sol.CSS_SRTS__r.isEmpty()){
                    //Story 109744** End.
                    for(integer a=0;a<sol.CSS_SRTS__r.size();a++){
                        if(sol.CSS_SRTS__r[a].Type__c!=null){

                            if(sol.CSS_SRTS__r[a].Type__c.equalsIgnoreCase('Diag Access') && sol.CSS_SRTS__r[a].Solution_Number__c == sol.id){
                                if(sol.CSS_SRTS__r[a].SRT_AccessiblityCheck__c){
                                    diagAccTime = diagAccTime + (sol.CSS_SRTS__r[a].Diag_Access_Time__c * sol.CSS_SRTS__r[a].SRT_Quantity__c);
                                }
                            }
                        }
                    }
                }
                if (diagList.solTitle !=null ){
                    diagListWrap.add(diagList);
                    inc++;
                }
            }
            diagnosisTime=sDTime;

            System.debug('calling Addtional');
            if(additionalSRTList.size()>0){
                adddiagList = new srtWrapper();  
                List<sortWrapper> privatesrtlst = new  List<sortWrapper>();
                adddiagList.solNum = 'Additional SRTS';
                //149764
                adddiagList.privatesolNum = 'Private SRTs';
                //end

                for (CSS_SRT__c addSRTLst: additionalSRTList){
                    //if(addSRTLst.srt_category__c.equalsIgnoreCase('DiagPopup')){
                    //if(addSRTLst.type__c.equalsIgnoreCase('Diagnosis') || addSRTLst.type__c.equalsIgnoreCase('Access') || addSRTLst.type__c.equalsIgnoreCase('Admin')){    
                    if(addSRTLst.srt_category__c!= null && addSRTLst.srt_category__c.equalsIgnoreCase('AdditionalDiag')){ //Kalpana: story#121938
                        //adddiagList.additonalDiagSRT.add(addSRTLst);
                        //Added as part of the Story# 172627
                        if(!mapaccesscode.containsKey(addSRTLst.id))
                        {
                            mapaccesscode.put(addSRTLst.id, new list<selectoption>());
                        }
                        if(addSRTLst.Account_Code__c != null && addSRTLst.Account_Code__c!='Select One' 
                           && (addSRTLst.SRT_Warrantable__c==null || addSRTLst.SRT_Warrantable__c=='0' || addSRTLst.SRT_Warrantable__c=='100')){
                            if(accountCodeWithWarrantMap.containsKey(addSRTLst.Account_Code__c)){
                                addSRTLst.SRT_Warrantable__c = accountCodeWithWarrantMap.get(addSRTLst.Account_Code__c); 
                            }
                            else{
                                addSRTLst.SRT_Warrantable__c = '0'; 

                            }
                        }

                        if((addSRTLst.Account_Code__c == null || addSRTLst.Account_Code__c=='Select One') 
                           && (addSRTLst.SRT_Warrantable__c==null || addSRTLst.SRT_Warrantable__c=='0' || addSRTLst.SRT_Warrantable__c=='100')){
                            addSRTLst.SRT_Warrantable__c = '0';    
                        }

                        //add coode here for saving single failcode/accountcode into SRT object
                        //Commented below code as per defect GSSC-597
                        /*if(oneaccfailcode){
                            System.debug('oneaccfailcode 4'+ addSRTLst.SRT_ID__c);
                            addSRTLst.FailCode__c  = failcodeList.get(1).getLabel();
                            addSRTLst.Account_Code__c  = accodeList.get(1).getValue();
                        }*/
                        //149764
                        if(addSRTLst.type__c=='Private'){
                            adddiagList.PrivateSrtCount+=1;}
                        if(addSRTLst.type__c!='Private'){
                            adddiagList.addSrtCount+=1;}

                        //Story 90222 - sort order for additional srt start
                        if(addSRTLst.type__c!='Private')
                            adddiagList.lstadditonalDiagSRT.add(new sortWrapper(addSRTLst));
                        if(addSRTLst.type__c=='Private'){
                            addSRTLst.Account_Code__c = '';
                            privatesrtlst.add(new sortWrapper(addSRTLst));
                        }
                        //end
                        //adddiagList.AccessCode = addSRTLst.job_order__r.AccessCode__c; //Dhaarmik
                        //  adddiagList.AccessCode = addSRTLst.Job_Engine_Access_Code__c;
                        //Story 172627:- Calling method for getting list of accesscode.
                        IF(string.isBlank(addSRTLst.Access_Code__c)){ //Setting up default value for the admin SRT 00-10S-00
                            if(addSRTLst.Access_Code_A__c==0 && addSRTLst.Access_Code_B__c==0 && addSRTLst.Access_Code_C__c==0 && addSRTLst.Access_Code_D__c==0 && addSRTLst.Access_Code_R__c!=0)
                            { 
                                addSRTLst.Access_Code__c='R';  
                                addSRTLst.SRT_Access_Code__c='R';
                            }
                            else{
                                addSRTLst.Access_Code__c=addSRTLst.Job_Engine_Access_Code__c;
                            }

                        }
                        else{
                            adddiagList.AccessCode = addSRTLst.Access_Code__c;
                        }


                        //Note:- Default value is getting setup in editpopup save method already.
                        list<selectoption> accesscodelist = srtdiag.getAccesscodejoboption(string.valueOf(addSRTLst.Access_Code_A__c),string.valueOf(addSRTLst.Access_Code_B__c),string.valueOf(addSRTLst.Access_Code_C__c),string.valueOf(addSRTLst.Access_Code_D__c),string.valueOf(addSRTLst.Access_Code_R__c),addSRTLst.job_order__r.AccessCode__c,addSRTLst.SRT_Access_Code__c,'Additional');
                        if(accesscodelist.size()>0)
                            mapaccesscode.put(addSRTLst.Id,accesscodelist);
                        //END
                        system.debug('MySRT**'+addSRTLst);
                        system.debug('DhaarmikCode1***'+addSRTLst.Access_Code__c);
                        system.debug('Tiger**'+adddiagList.lstadditonalDiagSRT);
                        system.debug('MySRTadd**'+adddiagList);
                        //Story 90222 - End
                        //}
                        if(addSRTLst.type__c.equalsIgnoreCase('Access') && addSRTLst.SRT_AccessiblityCheck__c == true){ //Kalpana: story#121938
                            diagAccTime = diagAccTime+(addSRTLst.SRT_Time__c * addSRTLst.SRT_Quantity__c);//venkat: added SRT_Quantity__c field as per story 154633
                        }
                        // if(addSRTLst.isPerformed__c == true && addSRTLst.type__c != 'Access'){  //Kalpana: Added Type!='Access' Condition//&& addSRTLst.type__c.equalsIgnoreCase('Diagnosis')){  
                        if((addSRTLst.isPerformed__c == true && addSRTLst.type__c != 'Access') || (addSRTLst.type__c.equalsIgnoreCase('Access') && addSRTLst.SRT_AccessiblityCheck__c == true)){  //Kalpana: Added Type=='Access' Condition, defect 189171
                            timediag = timediag + (addSRTLst.Extended_Hours__c != null ? addSRTLst.Extended_Hours__c : 0.0);
                            system.debug('timeAddDiagTime inside loop'+timediag);
                        }
                        if(addSRTLst.isPerformed__c == true && addSRTLst.type__c == 'Private'){  
                            timePrivateDiag = timePrivateDiag +(addSRTLst.Additional_SRT_Calculated__c * addSRTLst.SRT_Quantity__c);//venkat: added SRT_Quantity__c field as per story 154633
                            system.debug('timePrivateDiag inside loop'+timePrivateDiag);
                        }

                    }
                }
                System.debug('The addDiaSRTs is'+adddiagList);

                if(adddiagList.lstadditonalDiagSRT.size()>0){
                    //Story 90222 Start 
                    adddiagList.lstadditonalDiagSRT.sort();
                    //Story 90222 End 
                }
                //149764
                if(privatesrtlst.size()>0){
                    privatesrtlst.sort();
                    adddiagList.lstadditonalDiagSRT.Addall(privatesrtlst);
                }
                if(adddiagList.lstadditonalDiagSRT.size()>0){
                    additionalDiagListWrap.add(adddiagList);
                }
            }

            // story no 78784 change show value in decimal in bracket timeAccRepTot
            totalDecimalTimediag = timediag;
            totalDecimalTimePrivateDiag = timePrivateDiag;

            system.debug('totalDecimalTimediag nisha'+totalDecimalTimediag);
        }
        catch(Exception e){
            System.debug('The error in srt is'+e.getMessage()+e.getLineNumber());
        }


    }

    public void resetRepairData(){
        repListWrapper();
    }

    public void resetDiagData(){
        diagListWrapper();
    }
    public List<SelectOption> getAllACS(){
        return null;
    }

    public void getDiagAccessTime(){
        try{
            System.debug('Inside diagnosis time'+diagListWrap);
            decimal diagTime = 0;
            integer iDiagTime;
            integer iMinutes;
            integer iHour;
            for(srtWrapper s:diagListWrap){
                //Story 90222 changed diagWrapSRT to lstdiagWrapSRT for sort order
                for(integer i=0;i<s.lstDiagWrapSRT.size();i++){
                    System.debug('The s.diagWrapSrt outside is'+s.lstDiagWrapSRT[i].srtRec.SRT_AccessiblityCheck__c );
                    if(s.lstDiagWrapSRT[i].srtRec.SRT_AccessiblityCheck__c == true){
                        System.debug('The s.diagWrapSrt inside is'+s.lstDiagWrapSRT[i].srtRec.Diag_Access_Time__c );
                        diagTime = diagTime +s.lstDiagWrapSRT[i].srtRec.Diag_Access_Time__c ;
                        // diagnosisTime = string.valueof(diagTime);
                    }
                }
            }
            /***************************/
            for(srtWrapper addiDiag:additionalDiagListWrap){
                for(integer i=0;i<addiDiag.lstadditonalDiagSRT.size();i++){
                    if(addiDiag.lstadditonalDiagSRT[i].srtRec.srt_category__c != null &&addiDiag.lstadditonalDiagSRT[i].srtRec.srt_category__c.equalsIgnoreCase('AdditionalDiag') ){
                        if(addiDiag.lstadditonalDiagSRT[i].srtRec.type__c.equalsIgnoreCase('Access') && addiDiag.lstadditonalDiagSRT[i].srtRec.SRT_AccessiblityCheck__c == true){ 
                            diagTime = diagTime +addiDiag.lstadditonalDiagSRT[i].srtRec.Additional_SRT_Calculated__c ;
                        }
                    }
                }
            }
            /***************************/
            //Decimal display in bracket story change s-78784
            diagAccTime =  diagTime;
            system.debug('diagAccTime>>>>>>'+diagAccTime);
        }catch(exception e){
            system.debug('Entered into catch block of getDiagAccessTime method in CSS_DARSRT Class'+e.getMessage() + ' ' + e.getLineNumber());
        }
    }


    public void getdiagnosisTime(){

        System.debug('Inside diagnosis time');
        // calculateExtendedHours();
        decimal diagTime = 0;
        decimal privateTime = 0;
        integer iDiagTime;
        integer iMinutes;
        integer iHour;
        string sDTime;
        for(srtWrapper s:diagListWrap){
            for(integer i=0;i<s.lstDiagWrapSRT.size();i++){
                if(s.lstDiagWrapSRT[i].srtRec.isPerformed__c == true){
                    diagTime = diagTime +s.lstDiagWrapSRT[i].srtRec.Diagnosis_Time__c ;
                }
            }
        }
        for(srtWrapper addiDiag:additionalDiagListWrap){
            for(integer i=0;i<addiDiag.lstadditonalDiagSRT.size();i++){
                // if(addiDiag.lstadditonalDiagSRT[i].srtRec.isPerformed__c == true){
                if(addiDiag.lstadditonalDiagSRT[i].srtRec.isPerformed__c == true && addiDiag.lstadditonalDiagSRT[i].srtRec.type__c!= 'Access'){ //Kalpana: Added Type!='Access' Condition
                    diagTime = diagTime +addiDiag.lstadditonalDiagSRT[i].srtRec.Additional_SRT_Calculated__c ;
                }
                if(addiDiag.lstadditonalDiagSRT[i].srtRec.isPerformed__c == true && addiDiag.lstadditonalDiagSRT[i].srtRec.type__c== 'Private'){ 
                    privateTime = privateTime +addiDiag.lstadditonalDiagSRT[i].srtRec.Additional_SRT_Calculated__c ;
                }
            }
        }
        diagnosisTime = sDTime;
        totalDecimalTimediag =  diagTime;
        totalDecimalTimePrivateDiag =  privateTime;
    }
    public void getrepairTime(){
        System.debug('inside repair time');
        decimal repTime = 0;
        decimal privateTime = 0;
        integer iDiagTime;
        integer iMinutes;
        integer iHour;
        string sDTime;
        for(srtWrapper s:repListWrap){
            //System.debug('The size is'+s.repairSRT.size());
            for(compWrapper c:s.compSRT){
                //Story 90222 changing the repairList to repairListWrap for sort order imp**(again reverted)
                for(integer i=0;i<c.repairList.size();i++){
                    if(c.repairList[i].isPerformed__c){
                        //repTime = repTime +c.repairList[i].Repair_Time__c ; 
                        repTime = repTime +c.repairList[i].Extended_Hours__c ;
                    }
                }
            }
        }
        for(srtWrapper addiRepList:additionalRepListWrap){
            for(compWrapper c:addiRepList.compSRT){
                for(integer i=0;i<c.additionalSRT.size();i++){
                    if(c.additionalSRT[i].isPerformed__c && c.additionalSRT[i].type__c != 'Access'){ //Kalpana: Added Type!='Access' Condition
                        // repTime = repTime + c.additionalSRT[i].Additional_SRT_Calculated__c;
                        repTime = repTime + c.additionalSRT[i].Extended_Hours__c;
                    }
                    if(c.additionalSRT[i].isPerformed__c == true && c.additionalSRT[i].type__c== 'Private'){ 
                        privateTime = privateTime +c.additionalSRT[i].Additional_SRT_Calculated__c ;
                    }
                }
            }
        }

        System.debug('The repair time is'+sDTime);
        repairTime = sDTime;

        totalDecimalTimeRep = repTime;
        totalDecimalTimePrivateRep =  privateTime;
    }

    //Method to calculate the total rep access time 
    public void getRepairAccessTime(){
        decimal repAccTime = 0;
        for(srtWrapper s:repListWrap){
            for(compWrapper c:s.compSRT){
                for(integer i=0;i<c.repairList.size();i++){
                    if(c.repairList[i].SRT_AccessiblityCheck__c == true){
                        repAccTime = repAccTime +c.repairList[i].Repair_Access_Calculated__c; 
                    } 
                }
            }
        }  

        //
        for(srtWrapper addiRepList:additionalRepListWrap){
            for(compWrapper c:addiRepList.compSRT){
                for(integer i=0;i<c.additionalSRT.size();i++){
                    if(c.additionalSRT[i].srt_category__c != null && c.additionalSRT[i].srt_category__c.equalsIgnoreCase('AdditionalRep') ){
                        if(c.additionalSRT[i].type__c.equalsIgnoreCase('Access') && c.additionalSRT[i].SRT_AccessiblityCheck__c == true){
                            repAccTime = repAccTime + c.additionalSRT[i].Additional_SRT_Calculated__c; 
                        }
                    }
                }
            }
        }


        totalDecimalTimeAccRep =  repAccTime;
    }
    public pageReference saveDiagData(){
        try{
            PageReference pageRef;
            Transient  List<CSS_srt__c> toDeleteSRTList = new list<CSS_srt__c>();
            Transient  list<CSS_SRT__c> updateSRTList = new list<CSS_SRT__c>();
            Transient list<css_srt__c> updateAddSRTList = new list<css_srt__c>();
            system.debug('diagListWrapKAL**'+diagListWrap);
            Map<String,List<CSS_SRT__c>> accountCodeWithSRTMap = new Map<String,List<CSS_SRT__c>>(); 
            css_job_order__c serJob = new css_job_order__c();
            if(diagListWrap != null && !diagListWrap.isEmpty()){
                for(srtWrapper s:diagListWrap){
                    // for(compWrapper c:s.compSRT){
                    system.debug('lstDiagWrapSRT**'+s.lstDiagWrapSRT);
                    //story 90222 changed the diagWrapSRT to lstdiagWrapSRT --sort order
                    for(integer i=0;i<s.lstDiagWrapSRT.size();i++){
                        system.debug('s.lstDiagWrapSRT[i].srtRec.SRT_Warrantable__c'+s.lstDiagWrapSRT[i].srtRec.SRT_Warrantable__c);
                        system.debug('s.percentagewarranty'+s.percentagewarranty);
                        if(s.lstDiagWrapSRT[i].srtRec.SRT_Warrantable__c != null && s.lstDiagWrapSRT[i].srtRec.SRT_Warrantable__c != ''){
                            s.lstDiagWrapSRT[i].srtRec.SRT_Warrantable__c = s.lstDiagWrapSRT[i].srtRec.SRT_Warrantable__c;
                            system.debug('if if if s.lstDiagWrapSRT[i].srtRec.SRT_Warrantable__c'+s.lstDiagWrapSRT[i].srtRec.SRT_Warrantable__c);
                        }
                        else{
                            s.lstDiagWrapSRT[i].srtRec.SRT_Warrantable__c = s.percentagewarranty;
                            system.debug('else s.percentagewarranty'+s.percentagewarranty);
                        }

                        /*if(s.lstDiagWrapSRT[i].srtRec.Type__c == 'Diag Access'){
s.lstDiagWrapSRT[i].srtRec.SRT_Time__c = s.lstDiagWrapSRT[i].srtRec.SRT_Time__c*60;
system.debug('lstDiagWrapSRTTime>>>>>>**'+s.lstDiagWrapSRT[i].srtRec.SRT_Time__c);   
}*/
                        system.debug('s.lstDiagWrapSRT[i].srtRec - ' + s.lstDiagWrapSRT[i].srtRec.SRT_ID__c + 'accountCode - ' + s.lstDiagWrapSRT[i].srtRec.Account_Code__c);    
                        updateSRTList.add(s.lstDiagWrapSRT[i].srtRec);
                        system.debug('updateSRTList'+updateSRTList);
                        //147392 SN -  map SRT with Account Code START
                        if((s.lstDiagWrapSRT[i].srtRec.type__c !='Diag Access' && s.lstDiagWrapSRT[i].srtRec.isPerformed__c == true) ||
                           (s.lstDiagWrapSRT[i].srtRec.type__c =='Diag Access' && s.lstDiagWrapSRT[i].srtRec.SRT_AccessiblityCheck__c == true)){

                            String tempAccCode = '';
                            if(s.lstDiagWrapSRT[i].srtRec.Account_Code__c == null || s.lstDiagWrapSRT[i].srtRec.Account_Code__c == 'Select One' || s.lstDiagWrapSRT[i].srtRec.type__c =='Private'){
                                tempAccCode = 'Customer Billable';
                            }
                            else
                                tempAccCode = s.lstDiagWrapSRT[i].srtRec.Account_Code__c;

                            if(!accountCodeWithSRTMap.containskey(tempAccCode)){
                                accountCodeWithSRTMap.put(tempAccCode,new List<CSS_srt__c>{s.lstDiagWrapSRT[i].srtRec});
                            }
                            else{
                                accountCodeWithSRTMap.get(tempAccCode).add(s.lstDiagWrapSRT[i].srtRec);

                            }

                            //}
                            //147392 SN -  map SRT with Account Code END

                        }

                    }
                }

            }

            //Dhaarmik
            if(additionalDiagListWrap != null && !additionalDiagListWrap.isEmpty()){
                for(srtWrapper s:additionalDiagListWrap){
                    system.debug('lstadditonalDiagSRT**'+s.lstadditonalDiagSRT);
                    //story 90222 changed the diagWrapSRT to lstdiagWrapSRT --sort order
                    for(integer i=0;i<s.lstadditonalDiagSRT.size();i++){
                        updateAddSRTList.add(s.lstadditonalDiagSRT[i].srtRec);

                        //147392 SN -  map SRT with Account Code START
                        if((s.lstadditonalDiagSRT[i].srtRec.Type__c != 'Access' && s.lstadditonalDiagSRT[i].srtRec.isPerformed__c ==true) ||
                           (s.lstadditonalDiagSRT[i].srtRec.Type__c == 'Access' && s.lstadditonalDiagSRT[i].srtRec.SRT_AccessiblityCheck__c ==true)){

                            String tempAccCode = '';

                            if(s.lstadditonalDiagSRT[i].srtRec.Account_Code__c == null || s.lstadditonalDiagSRT[i].srtRec.Account_Code__c == 'Select One' || s.lstadditonalDiagSRT[i].srtRec.Type__c == 'Private'){//Story 152192 updated by Agassi
                                tempAccCode = 'Customer Billable';
                            }
                            else
                                tempAccCode = s.lstadditonalDiagSRT[i].srtRec.Account_Code__c;

                            if(!accountCodeWithSRTMap.containskey(tempAccCode)){
                                accountCodeWithSRTMap.put(tempAccCode,new List<CSS_srt__c>{s.lstadditonalDiagSRT[i].srtRec});
                            }
                            else{
                                accountCodeWithSRTMap.get(tempAccCode).add(s.lstadditonalDiagSRT[i].srtRec);
                            }
                        }
                        //147392 SN -  map SRT with Account Code END
                    }
                }
            }



            //147392 SN - Send SRT for OverLap Check
            if(accountCodeWithSRTMap.size()>0){
                //createOverlapSRT(accountCodeWithSRTMap);    
            }

            if(updateAddSRTList != null && !updateAddSRTList.isEmpty()){
                update updateAddSRTList;
            }

            if(updateSRTList != null && !updateSRTList.isEmpty()){
                update updateSRTList;
            }

            /*if(orgType == 'DLR' || (u.UserRole.Name != null && u.UserRole.Name.contains('Factory'))){
CG_CL_CoverageLimitExceedValidation callingSRTClaimedHour= new CG_CL_CoverageLimitExceedValidation();
//callingSRTClaimedHour.covLimitValidationSRTsJob(jobId,null);
callingSRTClaimedHour.covLimitValidationSRT(jobId,null);
}*/

            String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
            pageRef = new PageReference(sDestURL+'id='+JobID); 
            pageRef.setRedirect(true);
            return pageRef;
        }catch(exception e){
            system.debug('Entered into savediagdata method of css_darsrt class>>>>>>'+e.getmessage() + ' ' + e.getLineNumber());
        }
        return null;
    }



    //147392 SN -  function to create Overlap records
    public void createOverlapSRT(Map<String,List<CSS_SRT__c>> accountCodeWithSRTMap){
        lstSRTinsert = new List<CSS_SRT__c>();
        for(String accountCode : accountCodeWithSRTMap.keySet()){

            if(accountCodeWithSRTMap.get(accountCode).size()>0){
                overlapSRTCallout(accountCode,accountCodeWithSRTMap.get(accountCode));   

            }   

        }

        if(lstSRTinsert.size() > 0)
            insert lstSRTinsert;

        calculateExtendedHours();   


    }

    //147392 SN -  function to make callout for Overlap
    public void overlapSRTCallout(String accCode,List<CSS_SRT__c> srtList){
        try{
            CSS_OverlapSRTReq overlapSRTREq = new CSS_OverlapSRTReq();


            List<CSS_SRT__c> overlapSRT = new List<CSS_SRT__c>();
            Set<String> overlapSRTIds = new Set<String>();

            system.debug('jobID.Id'+jobID);
            //query all the existing overlap SRTs
            overlapSRT = [SELECT Id, Account_Code__c,Flex_Flag__c, SRT_ID__c FROM CSS_SRT__c WHERE Type__c = 'Overlap' AND Job_Order__c =: jobID];                
            for(CSS_SRT__c olsrt : overlapSRT){
                if(olsrt.Account_Code__c!=null && !overlapSRTIds.contains(olsrt.Account_Code__c+'-'+olsrt.SRT_ID__c))
                    overlapSRTIds.add(olsrt.Account_Code__c+'-'+olsrt.SRT_ID__c);

            }


            //User u = css_utility.getUserAttributes(userinfo.getUserId());//Commented the line and replaced with UserInfo.getLocale method to avoid query - Anirudh
            string lang = UserInfo.getLocale();

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
                            stepsrt1.add(stepsrt);
                            stepIdsSet.add(srtrc.Step_Id__c);
                        }

                    }
                }    
                system.debug('List size'+stepsrt1.size());  
            }
            CSS_OverlapSRTReq.DataArea dtarea = new CSS_OverlapSRTReq.DataArea();

            dtarea.JobID = srtList.size()>0?srtList[0].Job_Order__r.Name:''; //Sai:103959 8/3 : Changed the serviceJob.id to serviceJob.Name to hold the CSS Job number.
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
                            tempSRT.Job_Order__c = JobId;
                            lstSRTinsert.add(tempSRT);
                        }
                    }

                }
            }



        } catch(exception e){
            system.debug('Entered into overlapSRTCallout method of css_darsrt class>>>>>>'+e.getmessage() + ' ' + e.getLineNumber());

        }

    }


    public pageReference saveRepairData(){
        try{
            PageReference pageRef;
            list<CSS_SRT__c> updateRepSRTList = new list<CSS_SRT__c>();
            list<CSS_SRT__c> updateAddRepSRTList = new list<CSS_SRT__c>();
            Map<String,List<CSS_SRT__c>> accountCodeWithSRTMap = new Map<String,List<CSS_SRT__c>>();
            css_job_order__c serJob = new css_job_order__c();
            for(srtWrapper s:repListWrap){
                for(compWrapper c:s.compSRT){

                    for(integer i=0;i<c.repairList.size();i++){
                        system.debug('Before if SRT_Warrantable__c'+ c.repairList[i].SRT_Warrantable__c);
                        //   if(c.repairList[i].SRT_Warrantable__c != null && c.repairList[i].SRT_Warrantable__c != '')
                        //     c.repairList[i].SRT_Warrantable__c = c.repairList[i].SRT_Warrantable__c;
                        system.debug('After if SRT_Warrantable__c'+ c.repairList[i].SRT_Warrantable__c);
                        //else
                        //c.repairList[i].SRT_Warrantable__c = c.percentagewarranty;

                        //to fix the division defect
                        if(c.repairList[i].SRT_AccessiblityCheck__c){
                            c.repairList[i].SRT_Time__c=c.repairList[i].SRT_Time__c;//*60;
                        }
                        system.debug('c.repairList[i]'+c.repairList[i]);
                        system.debug('updateRepSRTList-->'+updateRepSRTList);
                        updateRepSRTList.add(c.repairList[i]);


                        if((c.repairList[i].type__c!='Repair Access' && c.repairList[i].isPerformed__c==true)||
                           (c.repairList[i].type__c=='Repair Access' && c.repairList[i].SRT_AccessiblityCheck__c==true)){
                            //147392 SN -  map SRT with Account Code START
                            String tempAccCode = '';

                            if(c.repairList[i].Account_Code__c == null || c.repairList[i].Account_Code__c == 'Select One'){
                                tempAccCode = 'Customer Billable';
                            }
                            else
                                tempAccCode = c.repairList[i].Account_Code__c;

                            if(!accountCodeWithSRTMap.containskey(tempAccCode)){
                                accountCodeWithSRTMap.put(tempAccCode,new List<CSS_srt__c>{c.repairList[i]});
                            }
                            else{
                                accountCodeWithSRTMap.get(tempAccCode).add(c.repairList[i]);

                            }
                        }
                        //147392 SN -  map SRT with Account Code END

                    }                        
                }

            }


            //Kalpana Added to save changes to Additional SRTs - START
            for(srtWrapper s:additionalRepListWrap){
                for(compWrapper c:s.compSRT){
                    //for(srtWrapper k:c.additionalSRT){
                    for(integer i=0;i<c.additionalSRT.size();i++){
                        updateAddRepSRTList.add(c.additionalSRT[i]);
                        //147392 SN -  map SRT with Account Code START
                        if((c.additionalSRT[i].type__c!='Access' && c.additionalSRT[i].isPerformed__c==true)||
                           (c.additionalSRT[i].type__c=='Access' && c.additionalSRT[i].SRT_AccessiblityCheck__c==true)){
                            String tempAccCode = '';
                            if(c.additionalSRT[i].Account_Code__c == null || c.additionalSRT[i].Account_Code__c == 'Select One'){
                                tempAccCode = 'Customer Billable';
                            }
                            else
                                tempAccCode = c.additionalSRT[i].Account_Code__c;

                            if(!accountCodeWithSRTMap.containskey(tempAccCode)){
                                accountCodeWithSRTMap.put(tempAccCode,new List<CSS_srt__c>{c.additionalSRT[i]});
                            }
                            else{
                                accountCodeWithSRTMap.get(tempAccCode).add(c.additionalSRT[i]);
                            }
                        }
                        //147392 SN -  map SRT with Account Code END
                    }  
                    //}
                }
            }




            //147392 SN - Send SRT for OverLap Check 
            if(accountCodeWithSRTMap.size()>0){
                //createOverlapSRT(accountCodeWithSRTMap);    
            }

            if(updateRepSRTList!= null && !updateRepSRTList.isEmpty()){
                update  updateRepSRTList;
                system.debug('updateRepSRTList'+updateRepSRTList);
            } 
            if(updateAddRepSRTList != null && !updateAddRepSRTList.isEmpty()){
                update updateAddRepSRTList;
            }
            // }*/

            /* if(orgType == 'DLR' || (u.UserRole.Name != null && u.UserRole.Name.contains('Factory'))) {
CG_CL_CoverageLimitExceedValidation callingSRTClaimedHour= new CG_CL_CoverageLimitExceedValidation();
//callingSRTClaimedHour.covLimitValidationSRTsJob(jobId,null);
callingSRTClaimedHour.covLimitValidationSRT(jobId,null);
}*/


            //Kalpana Added, to save changes to Additional SRTs - END

            String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
            pageRef = new PageReference(sDestURL+'id='+JobID); 
            pageRef.setRedirect(true);
            return pageRef;
        }catch(exception e){
            system.debug('Entered into saveRepairdata method of css_darsrt class>>>>>>'+e.getmessage() + ' ' + e.getLineNumber());
        }
        return null;

    }

    //function to calculate Extended Hours
    public void calculateExtendedHours(){

        try{
            List<CSS_SRT__c> srtList = new List<CSS_SRT__c>();
            srtList = [SELECT Id, SRT_ID__c,Flex_Flag__c,Diag_Access_Time__c,Diagnosis_Time__c, SRT_Category__c, Extended_Hours__c, SRT_Time__c, SRT_Quantity__c, Calculated_Claimed_Hours__c, Type__c, SRT_Warrantable__c FROM CSS_SRT__c WHERE Type__c IN ('Diagnosis','Repair','Diag Access','Repair Access','Admin','Field Action','Field Action Access') AND Job_Order__c =: jobId];
            System.debug('=======>1'+srtList);
            List<CSS_SRT__c> overlapSrtList = new List<CSS_SRT__c>();
            overlapSrtList = [SELECT Id, SRT_ID__c,Flex_Flag__c, SRT_Category__c, Extended_Hours__c, SRT_Time__c, SRT_Quantity__c, Calculated_Claimed_Hours__c, Type__c, SRT_Warrantable__c FROM CSS_SRT__c WHERE Type__c = 'Overlap' AND Job_Order__c =: jobId];
            System.debug('=======>2'+overlapSrtList);
            Map<id,CSS_SRT__c> srtListToUpd = new Map<id,CSS_SRT__c>();
            for(CSS_SRT__c srt : srtList){
                if(overlapSrtList != null && overlapSrtList.size() > 0){
                    for(CSS_SRT__c olapSrt : overlapSrtList){
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
                                        system.debug('srt.SRT_ID__c'+srt.SRT_ID__c);
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

            /*if(orgType == 'DLR' || (u.UserRole.Name != null && u.UserRole.Name.contains('Factory'))){
system.debug('****first darsrt method...');
CG_CL_CoverageLimitExceedValidation callingSRTClaimedHour= new CG_CL_CoverageLimitExceedValidation();
//callingSRTClaimedHour.covLimitValidationSRTsJob(jobId,null);
callingSRTClaimedHour.covLimitValidationSRT(jobId,null);
system.debug('darsrt method...');
}*/
        }
        catch (exception exc){
            system.debug('catch exception in Claimed hours calculation from CSS_DARSRT class at line number '+exc.getLineNumber()+' with error message '+exc.getMessage());
        } 
    }


    public class sortWrapper implements Comparable{
        public CSS_SRT__c srtRec{get;set;}
        public boolean selectedRecord{get;set;}

        public list<SelectOption> lstAccountCodes{get;set;} //new field for accountcode dropdown
        public Integer counting {get;set;} //new field for accountcode dropdown
        // public string AcCodeDisplay {get; set;}

        //constructor
        public sortWrapper(CSS_SRT__c srtRec){
            this.srtRec = srtRec;
            this.selectedRecord = false;
        }

        public Integer compareTo(Object ObjToCompare) {
            system.debug('srtRec--->'+srtRec);
            if(srtRec.SRT_Order__c == null){
                if(((sortWrapper)ObjToCompare).srtRec.SRT_Order__c == null)
                    return 0; //equal
                else
                    return -1; // null is before other strings
            }
            else // this.member != null
            {

                if(((sortWrapper)ObjToCompare).srtRec.SRT_Order__c == null)
                    return 1;  // all other strings are after null
                else
                    return integer.valueOf(srtRec.SRT_Order__c - ((sortWrapper)ObjToCompare).srtRec.SRT_Order__c);
            }
        }
    }

    public void changeUpOrder(){
        list<css_srt__c> updateSortSRTs = new list <css_srt__c>();
        for(srtWrapper srtWrap : diagListWrap){
            integer i = 0;
            system.debug('Anirudh sort wrap>>>>>>'+srtWrap.lstDiagWrapSRT);
            for(sortWrapper sortwrp : srtWrap.lstDiagWrapSRT){

                if(sortwrp.selectedRecord){
                    decimal temp;
                    if(i != 0){
                        temp = sortwrp.srtRec.SRT_Order__c;
                        sortwrp.srtRec.SRT_Order__c = srtWrap.lstDiagWrapSRT[i-1].srtRec.SRT_Order__c;
                        srtWrap.lstDiagWrapSRT[i-1].srtRec.SRT_Order__c = temp;
                    }

                }
                i=i+1;
                //updateSortSRTs.add();
            }
            srtWrap.lstDiagWrapSRT.sort();
            // system.debug('Anirudh updateSortSRTs>>>>>>>'+srtWrap); 
        }
        //system.debug('Anirudh updateSortSRTs>>>>>>>'+srtWrap);

        //Shuffeling the order for Additional SRT
        if(additionalDiagListWrap != null && additionalDiagListWrap.size() > 0){
            for(srtWrapper addsrtWrap : additionalDiagListWrap){
                integer i = 0;
                for(sortWrapper addsortwrp : addsrtWrap.lstadditonalDiagSRT){
                    if(addsortwrp.selectedRecord){
                        decimal temp;
                        if(i != 0){
                            temp = addsortwrp.srtRec.SRT_Order__c;
                            addsortwrp.srtRec.SRT_Order__c = addsrtWrap.lstadditonalDiagSRT[i-1].srtRec.SRT_Order__c;
                            addsrtWrap.lstadditonalDiagSRT[i-1].srtRec.SRT_Order__c = temp;
                        }

                    }
                    i=i+1;
                }
                addsrtWrap.lstadditonalDiagSRT.sort();
            }
        }
        //saveDiagData();
    }

    public void changeDownOrder(){

        for(srtWrapper srtWrap : diagListWrap){
            integer i = 0;
            for(sortWrapper sortwrp : srtWrap.lstDiagWrapSRT){
                if(sortwrp.selectedRecord){
                    decimal temp;
                    if(i < srtWrap.lstDiagWrapSRT.size()-1){
                        temp = sortwrp.srtRec.SRT_Order__c;
                        sortwrp.srtRec.SRT_Order__c = srtWrap.lstDiagWrapSRT[i+1].srtRec.SRT_Order__c;
                        srtWrap.lstDiagWrapSRT[i+1].srtRec.SRT_Order__c = temp;
                    }

                }
                i=i+1;
            }
            srtWrap.lstDiagWrapSRT.sort();
        }

        //Shuffeling the order for Additional SRT
        if(additionalDiagListWrap != null && additionalDiagListWrap.size() > 0){
            for(srtWrapper addsrtWrap : additionalDiagListWrap){
                integer i = 0;
                for(sortWrapper addsortwrp : addsrtWrap.lstadditonalDiagSRT){
                    if(addsortwrp.selectedRecord){
                        decimal temp;
                        if(i < addsrtWrap.lstadditonalDiagSRT.size()-1){
                            temp = addsortwrp.srtRec.SRT_Order__c;
                            addsortwrp.srtRec.SRT_Order__c = addsrtWrap.lstadditonalDiagSRT[i+1].srtRec.SRT_Order__c;
                            addsrtWrap.lstadditonalDiagSRT[i+1].srtRec.SRT_Order__c = temp;
                        }

                    }
                    i=i+1;
                }
                addsrtWrap.lstadditonalDiagSRT.sort();
            }
        }
        //saveDiagData();

    }
    //Method to return the Max Sort order
    public decimal getMaxSortOrder(){
        //Story 90222 start querying to get the Maximum Additional srt Sort Order
        /*AggregateResult[] groupedResults= [SELECT type__c, MAX(SRT_Order__c) 
FROM CSS_SRT__c GROUP BY type__c 
HAVING type__c= null];*/
        system.debug('additionalSRTList-->order-->'+additionalSRTList);
        AggregateResult[] groupedResults= [SELECT MAX(SRT_Order__c) 
                                           FROM CSS_SRT__c 
                                           WHERE Job_Order__c = : JobID  and 
                                           Solution_Number__c= null];
        Decimal sortOrder;
        if(groupedResults != null && groupedResults.size() > 0){
            sortOrder =(decimal) groupedResults[0].get('expr0');
        }
        //Story 90222 End

        return sortOrder;
    }




    //New method to set a boolean, if the failcode exists in SRT Object but not in Solution Component: kalpana
    public void CompareFailCodes(){
        List<css_srt__c> srtList = new List<css_srt__c>();
        List<css_srt__c> updatesrtList = new List<css_srt__c>();
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        srtList = [select id,FailCode__c,Flex_Flag__c,job_order__c from css_Srt__c where Job_Order__c = :JobID];
        //solCompList = [select id,Fail_code__c,service_job__c from CSS_Solution_Component__c where service_job__c = :Wid];
        for(css_srt__c srtFC: srtList){
            system.debug('srtFC**'+srtFC);
            system.debug('failAccountCodeMap**'+failAccountCodeMap);
            if(!failAccountCodeMap.containsKey(srtFC.FailCode__c)){
                system.debug('inside');
                // isSRTFC = true;
                srtFC.isSrtFailCode__c = true;
                updatesrtList.add(srtFC);
            }

        }
        /* if(updatesrtList != null && updatesrtList.size()>0)
update updatesrtList;*/
    }
    //venkat added below code for bluescreen Map Key USDU issue
    public void Failcodesrt(){
        List<css_srt__c> srtList = new List<css_srt__c>();

        srtList = [select id,FailCode__c,Flex_Flag__c,job_order__c from css_Srt__c where Job_Order__c = :JobID];
        for(css_srt__c srtFC: srtList){
            system.debug('srtFC**'+srtFC);
            system.debug('failAccountCodeMap**'+failAccountCodeMap);
            if(!failAccountCodeMap.containsKey(srtFC.FailCode__c)){

                if(srtFC.FailCode__c!=null){
                    String failcode= srtFC.FailCode__c.substring(0,4);
                    failAccountCodeMap.put(failcode,new List<SelectOption>());}
            }
        }
    }

    //Method for getting failcodes codes- 100309
    public List<SelectOption> getfailcodeDropDown()    
    {    
        List<SelectOption> options =  new List<SelectOption>(); 
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        options.add(new SelectOption('Select One','Select One'));
        failAccountCodeMap = new  Map<String, List<SelectOption>>();

        if(componentList.size()>0){
            List<SelectOption> acCodeSet;
            Set<SelectOption> acCodeSet1;
            //List<SelectOption> acCodeSet = new List<SelectOption>();
            //acCodeSet.add(new SelectOption('Select One','Select One'));
            for(CSS_Solution_Component__c f:componentList )  {
                system.debug('componentList**'+componentList);
                System.debug('f.Fail_Code__c$$$$$$$$$$$$'+f.Fail_Code__c);
                acCodeSet = new List<SelectOption>();
                //acCodeSet1 = new Set<SelectOption>();

                acCodeSet.add(new SelectOption('Select One','Select One'));
                system.debug('Selected_Component__c**'+f.Selected_Component__c);
                system.debug('f.Solutions__r.Diagnostic_Response__c*'+f.Solutions__r.Diagnostic_Response__c);
                system.debug('f.Type__c**'+f.Type__c);

                if(f.Selected_Component__c==true){   
                    system.debug('InsideIf**'+f.Fail_Code__c);
                    if(f.Fail_Code__c!=null && f.Fail_Code__c!='' && f.Fail_Code__c!='Select One'){
                        system.debug('InsideIf1**'+f.Fail_Code__c);
                        sortableSet.add(f.FailCode_Formula__c);
                        if(failAccountCodeMap.containsKey(f.Fail_Code__c)){
                            system.debug('**insidecontainkey**');
                            System.debug('f.Fail_Code__c**'+f.Fail_Code__c);
                            acCodeSet = failAccountCodeMap.get(f.Fail_Code__c);
                            acCodeSet1 = new Set<SelectOption>(acCodeSet);
                            system.debug('acCodeSet**'+acCodeSet);
                            system.debug('failAccountCodeMap**'+failAccountCodeMap);
                            // if(acCodeSet == null ){
                            if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c != '' && f.CSS_Account_Formula__c !='Select One'){
                                SelectedaccCode=f.CSS_Account_Formula__c;
                                if(!acCodeSet1.contains(new SelectOption(f.CSS_Account_Formula__c,f.CSS_Account_Formula__c))){ // Kalpana: added code to avoid duplicates
                                    //acCodeSet.add(new SelectOption(SelectedaccCode,SelectedaccCode)); 

                                    if(f.Solutions__r.Diagnostic_Response__c=='Most likely the solution' && f.Type__c != 'Campaign' && f.Type__c != 'TRP' && f.Type__c != 'ATC'){
                                        if(f.CoveredLaborHrs__c != null && f.CoveredLaborHrs__c != '' && double.valueof(f.CoveredLaborHrs__c)>0){
                                            acCodeSet.add(new SelectOption(SelectedaccCode,SelectedaccCode)); 
                                        }
                                    }
                                    else if(f.Type__c == 'Campaign' || f.Type__c == 'TRP' || f.Type__c == 'ATC'){
                                        if(f.CampaignLaborPercentage__c != null && f.CampaignLaborPercentage__c != '' || double.valueof(f.CampaignLaborPercentage__c)>0){
                                            acCodeSet.add(new SelectOption(SelectedaccCode,SelectedaccCode)); 
                                        }
                                    }

                                }
                                system.debug('acCodeSetAfterAdd**'+acCodeSet);
                                if(f.Fail_Code__c.length()==6)
                                    failAccountCodeMap.put(f.System_Code__c+f.Component_Code__c, acCodeSet);
                                else
                                    failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                            }
                            else{
                                system.debug('InsideNULLElse**'+f.Fail_Code__c);
                                if(f.Fail_Code__c.length()==6)
                                    failAccountCodeMap.put(f.System_Code__c+f.Component_Code__c, acCodeSet);
                                else
                                    failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                            }
                            //}
                        }
                        else{
                            system.debug('Insidedoesnotcontainelse**'+f.Fail_Code__c);
                            //acCodeSet = new List<SelectOption>();
                            /* if(f.CSS_Account_Formula__c != null){
if(f.CSS_Account_Formula__c !='Select One'){*/
                            if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c != '' && f.CSS_Account_Formula__c !='Select One'){
                                /*if(f.CoveredLaborHrs__c != null && f.CoveredLaborHrs__c != '' && double.valueof(f.CoveredLaborHrs__c)>0){
acCodeSet.add(new SelectOption(f.CSS_Account_Formula__c,f.CSS_Account_Formula__c));
system.debug('CSS_Account_Formula__c**'+f.CSS_Account_Formula__c);
failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
}*/
                                SelectedaccCode=f.CSS_Account_Formula__c;
                                if(f.Solutions__r.Diagnostic_Response__c=='Most likely the solution' && f.Type__c != 'Campaign' && f.Type__c != 'TRP' && f.Type__c != 'ATC'){
                                    if(f.CoveredLaborHrs__c != null && f.CoveredLaborHrs__c != '' && double.valueof(f.CoveredLaborHrs__c)>0){
                                        acCodeSet.add(new SelectOption(f.CSS_Account_Formula__c,f.CSS_Account_Formula__c));
                                        if(f.Fail_Code__c.length()==6){
                                            failAccountCodeMap.put(f.System_Code__c+f.Component_Code__c, acCodeSet);
                                            system.debug('failAccountCodeMap1**'+failAccountCodeMap);
                                        } 
                                        else{
                                            failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                                        }
                                    }
                                    else{
                                        failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                                    }
                                }
                                else if(f.Type__c == 'Campaign' || f.Type__c == 'TRP' || f.Type__c == 'ATC'){
                                    if(f.CampaignLaborPercentage__c != null && f.CampaignLaborPercentage__c != '' && double.valueof(f.CampaignLaborPercentage__c)>0){
                                        acCodeSet.add(new SelectOption(f.CSS_Account_Formula__c,f.CSS_Account_Formula__c));
                                        system.debug('CSS_Account_Formula__c**'+f.CSS_Account_Formula__c);
                                        failAccountCodeMap.put(f.Fail_Code__c, acCodeSet); 
                                    }
                                    else{
                                        failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                                    }
                                }
                                else{
                                    //acCodeSet.add(new SelectOption(f.CSS_Account_Formula__c,f.CSS_Account_Formula__c));
                                    failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                                }

                                system.debug('failAccountCodeMap**'+failAccountCodeMap);
                            }
                            else{
                                system.debug('InsideNULLElse**'+f.Fail_Code__c);
                                if(f.Fail_Code__c.length()==6)
                                    failAccountCodeMap.put(f.System_Code__c+f.Component_Code__c, acCodeSet);
                                else
                                    failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                            }


                        }
                    }




                }


            }

        }
        Failcodesrt();
        if(sortableSet.size()>0){
            sortable.AddAll(sortableSet);}
        sortable.sort();
        if (sortable.size()>0){
            for(String s:sortable)    
            {   
                String[] tempStr;
                if(s !='Select One'){
                    tempStr = s.split('-');
                    system.debug('***str***'+tempStr[1]);
                } 
                options.add(new selectOption(tempStr[1],s));                    
            }   
        }
        if(options.size()==2){
            failcodelst=true;}
        /*if(failAccountCodeMap.size() == 2)
acccodelst = true;*/
        system.debug('MapSize**'+failAccountCodeMap.size());
        system.debug('failAccountCodeMap**'+failAccountCodeMap);
        return Options;    
    }
    //END
    //Method for getting failcodes codes- 100309
    public List<SelectOption> getAccountCodeDropDown()    
    {    
        accCodes = new List<SelectOption>();
        accCodes.add(new SelectOption('Select One','Select One'));
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        if(componentList .size()>0){
            for(CSS_Solution_Component__c f:componentList){
                CSS_JobEventTemporary__c tempJET;
                if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c != '' && f.CSS_Account_Formula__c != 'Select One'){
                    tempJET = jobEventMap.get(f.CSS_Account_Formula__c.RIGHT(2));
                }
                String coverageType;
                system.debug('solComp.CSS_Account_Formula__c-->'+f.CSS_Account_Formula__c);
                if(tempJET != null){
                    coverageType = tempJET.Attribute1__c;
                    system.debug('coverageType-->'+coverageType);
                }
                if(f.Selected_Component__c==true && f.Solutions__r.Diagnostic_Response__c=='Most likely the solution' && f.Type__c!='CAMPAIGN' && f.Type__c!='TRP' && f.Type__c!='ATC'){
                    if((coverageType == 'POL' || coverageType == 'OTH') || (f.CSS_Account_Formula__c!=null && f.CSS_Account_Formula__c!='' && f.CoveredLaborHrs__c != null && f.CoveredLaborHrs__c != '' && double.valueof(f.CoveredLaborHrs__c) > 0)){
                        sortableSet.add(f.CSS_Account_Formula__c);
                        system.debug('sortableSetform**'+sortableSet);
                    }
                }
            }
        }
        if(sortableSet.size()>0){
            sortable.AddAll(sortableSet);}
        sortable.sort();
        if (sortable.size()>0){
            for(String s:sortable)    
            {    
                accCodes.add(new selectOption(s,s));                    
            }   
        }
        if(accCodes.size()==2 && failcodelst==true){
            acccodelst=true;}
        system.debug('accCodes>>> accountdropdown' + accCodes);
        return accCodes;    
    }
    //END
    //Method for getting account code based on failcode
    public void getonchangefailCode()    
    {    
        accCodes = new List<SelectOption>();
        accCodes.add(new SelectOption('Select One','Select One'));
        List<string> sortable = new  List<string>();
        system.debug('selectedFailCode$$$$$$$$$$$$$$'+selectedFailCode);

        if(failAccountCodeMap.containsKey(selectedFailCode)){

            accCodes=failAccountCodeMap.get(selectedFailCode);
        }
        system.debug('accCodes$$$$$$$$$$$$$$'+accCodes);
        if(accCodes.size()==2 && failcodelst==true){
            acccodelst=true;}

    }
    //END

    //New method1
    public void onChangeofFailCode(){
        try{
            system.debug('in onChangeofFailCode');
            //Integer selectedSRTRowNo = 0; //This rowCount No should be passed from VF UI
            system.debug('selectedFailCode>>>>>>>>>>: '+selectedFailCode);
            system.debug('seltdSRTId>>>>>>>>>>: '+seltdSRTId);
            List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
            solsComp= [SELECT  Id,CSS_Account_Formula__c, CoveredLaborHrs__c, CampaignLaborPercentage__c, CSS_CoverageType__c, Parts_Warranty__c,Type__c, CampaignTowingPercentage__c, CampaignTravelPercentage__c, CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c, Solutions__r.Diagnostic_Response__c, FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =: JobID AND ((Selected_Component__c = true AND Fail_Code__c =: selectedFailCode AND CSS_Account_Formula__c != null AND Solutions__r.Diagnostic_Response__c = 'Most likely the solution') OR (Selected_Component__c = true AND Fail_Code__c =: selectedFailCode AND CSS_Account_Formula__c != null AND Type__c IN ('Campaign','ATC','TRP')))];
            //List<SelectOption> options = getAccountCodeOptionList(selectedFailCode);
            system.debug('solsComp>>>'+solsComp);
            List<SelectOption> options = new List<SelectOption>();
            Set<string> sortableSet = new  Set<string>();
            List<string> sortable = new  List<string>();
            options.add(new SelectOption('Select One','Select One'));
            system.debug('solsComp>>>'+solsComp);
            String oneACCode;
            for(CSS_Solution_Component__c sollst1:solsComp) {
                system.debug('sollst1.Type__c>>>'+sollst1.Type__c);
                if(sollst1.Type__c != 'Campaign' && sollst1.Type__c != 'TRP' && sollst1.Type__c != 'ATC'){
                    if(sollst1.CoveredLaborHrs__c != null && sollst1.CoveredLaborHrs__c != '' && double.valueof(sollst1.CoveredLaborHrs__c) > 0){
                        sortableSet.add(sollst1.CSS_Account_Formula__c);
                    }
                }
                else{
                    if(sollst1.CampaignLaborPercentage__c != null && sollst1.CampaignLaborPercentage__c != '' && double.valueof(sollst1.CampaignLaborPercentage__c) > 0){
                        sortableSet.add(sollst1.CSS_Account_Formula__c);
                    }
                }
            }
            system.debug('sortableSet--'+sortableSet);
            if(sortableSet.size()>0){
                sortable.AddAll(sortableSet);
            }
            sortable.sort();
            if(sortable.size()>0){
                for(String s:sortable){    
                    options.add(new selectOption(s,s));                    
                }   
            }
            oneACCode = solsComp[0].CSS_Account_Formula__c;
            system.debug('oneACCode>>> ' + oneACCode);
            system.debug('returned accode options>>:' +options + ' options size' + options.size());

            // For Diag SRTs
            for(srtWrapper srtWrap : diagListWrap){
                integer i = 0;

                for(sortWrapper sortwrp : srtWrap.lstDiagWrapSRT){
                    system.debug('lstDiagWrapSRT**'+sortwrp);
                    CSS_SRT__c srtObj = sortwrp.srtRec;
                    //if(sortwrp.counting == selectedSRTRowNo){
                    if(srtObj.Id == seltdSRTId){
                        system.debug('matched seltdSRTId>>:' +seltdSRTId);

                        if(options.size() > 2){
                            system.debug('inside if oprtion>2 >>> ' + options);
                            sortwrp.lstAccountCodes = options;
                            srtObj.Account_Code__c = 'Select One';
                            if(sortwrp.srtRec.Account_Code__c != null && sortwrp.srtRec.Account_Code__c!='Select One'){
                                system.debug('inside sencond loop if accountcode' + sortwrp.srtRec.Account_Code__c );
                                if(accountCodeWithWarrantMap.containsKey(sortwrp.srtRec.Account_Code__c)){
                                    system.debug('inside sencond loop if srt match' + sortwrp.srtRec.SRT_Warrantable__c);           
                                    sortwrp.srtRec.SRT_Warrantable__c = accountCodeWithWarrantMap.get(sortwrp.srtRec.Account_Code__c);
                                    system.debug('SRT_Warrantable__c' +sortwrp.srtRec.SRT_Warrantable__c);
                                }
                                else{
                                    sortwrp.srtRec.SRT_Warrantable__c = '0';
                                    system.debug('SRT_Warrantable__c' +sortwrp.srtRec.SRT_Warrantable__c);


                                }
                            }
                            else if(sortwrp.srtRec.Account_Code__c == null || sortwrp.srtRec.Account_Code__c=='Select One'){
                                sortwrp.srtRec.SRT_Warrantable__c = '0';
                                system.debug('SRT_Warrantable__c' +sortwrp.srtRec.SRT_Warrantable__c);
                            }

                        }
                        else{
                            system.debug('inside if oprtion <2 >>> ' + options);
                            sortwrp.lstAccountCodes = options;
                            sortwrp.srtRec.SRT_Warrantable__c = '0';
                            srtObj.Account_Code__c = oneACCode;
                            if(sortwrp.srtRec.Account_Code__c != null && sortwrp.srtRec.Account_Code__c!='Select One'){
                                system.debug('inside sencond loop if accountcode' + sortwrp.srtRec.Account_Code__c );
                                if(accountCodeWithWarrantMap.containsKey(sortwrp.srtRec.Account_Code__c)){
                                    system.debug('inside sencond loop if srt match' + sortwrp.srtRec.SRT_Warrantable__c);           
                                    sortwrp.srtRec.SRT_Warrantable__c = accountCodeWithWarrantMap.get(sortwrp.srtRec.Account_Code__c);
                                    system.debug('SRT_Warrantable__c' +sortwrp.srtRec.SRT_Warrantable__c);
                                }
                                else{
                                    sortwrp.srtRec.SRT_Warrantable__c = '0';
                                    system.debug('SRT_Warrantable__c' +sortwrp.srtRec.SRT_Warrantable__c);


                                }
                            }
                            else if(sortwrp.srtRec.Account_Code__c == null || sortwrp.srtRec.Account_Code__c=='Select One'){
                                sortwrp.srtRec.SRT_Warrantable__c = '0';
                                system.debug('SRT_Warrantable__c' +sortwrp.srtRec.SRT_Warrantable__c);
                            } 
                            system.debug('sortwrp.lstAccountCodes >> ' + sortwrp.lstAccountCodes); 
                        }
                        break;
                    }
                }
            }

            // FOr Additional Diag SRTs

            if(additionalDiagListWrap != null){
                for(srtWrapper srtWrap : additionalDiagListWrap){
                    integer i = 0;
                    for(sortWrapper sortwrp : srtWrap.lstadditonalDiagSRT){
                        CSS_SRT__c srtObj = sortwrp.srtRec;
                        //if(sortwrp.counting == selectedSRTRowNo){
                        if(srtObj.Id == seltdSRTId){


                            if(options.size() > 2){
                                system.debug('inside if oprtion>2 >>> ' + options);
                                sortwrp.lstAccountCodes = options;
                                srtObj.Account_Code__c = 'Select One';

                                if(sortwrp.srtRec.Account_Code__c != null && sortwrp.srtRec.Account_Code__c!='Select One'){
                                    system.debug('inside sencond loop if accountcode' + sortwrp.srtRec.Account_Code__c );
                                    if(accountCodeWithWarrantMap.containsKey(sortwrp.srtRec.Account_Code__c)){
                                        system.debug('inside sencond loop if srt match' + sortwrp.srtRec.SRT_Warrantable__c);           
                                        sortwrp.srtRec.SRT_Warrantable__c = accountCodeWithWarrantMap.get(sortwrp.srtRec.Account_Code__c);
                                        system.debug('SRT_Warrantable__c' +sortwrp.srtRec.SRT_Warrantable__c);
                                    }
                                    else{
                                        sortwrp.srtRec.SRT_Warrantable__c = '0';
                                        system.debug('SRT_Warrantable__c' +sortwrp.srtRec.SRT_Warrantable__c);


                                    }
                                }
                                else if(sortwrp.srtRec.Account_Code__c == null || sortwrp.srtRec.Account_Code__c=='Select One'){
                                    sortwrp.srtRec.SRT_Warrantable__c = '0';
                                    system.debug('SRT_Warrantable__c' +sortwrp.srtRec.SRT_Warrantable__c);
                                }
                            }
                            else{
                                system.debug('inside if oprtion <2 >>> ' + options);
                                sortwrp.lstAccountCodes = options;
                                srtObj.Account_Code__c = oneACCode;
                                // system.debug('sortwrp.AcCodeDisplay >> ' + sortwrp.AcCodeDisplay);
                                if(sortwrp.srtRec.Account_Code__c != null && sortwrp.srtRec.Account_Code__c!='Select One'){
                                    system.debug('inside sencond loop if accountcode' + sortwrp.srtRec.Account_Code__c );
                                    if(accountCodeWithWarrantMap.containsKey(sortwrp.srtRec.Account_Code__c)){
                                        system.debug('inside sencond loop if srt match' + sortwrp.srtRec.SRT_Warrantable__c);           
                                        sortwrp.srtRec.SRT_Warrantable__c = accountCodeWithWarrantMap.get(sortwrp.srtRec.Account_Code__c);
                                        system.debug('SRT_Warrantable__c' +sortwrp.srtRec.SRT_Warrantable__c);
                                    }
                                    else{
                                        sortwrp.srtRec.SRT_Warrantable__c = '0';
                                        system.debug('SRT_Warrantable__c' +sortwrp.srtRec.SRT_Warrantable__c);


                                    }
                                }
                                else if(sortwrp.srtRec.Account_Code__c == null || sortwrp.srtRec.Account_Code__c=='Select One'){
                                    sortwrp.srtRec.SRT_Warrantable__c = '0';
                                    system.debug('SRT_Warrantable__c' +sortwrp.srtRec.SRT_Warrantable__c);
                                }
                            }
                            break;
                        }
                    }
                }
            }

            //For Repair SRTs
            if(repListWrap!=null){
                system.debug('inside repListWrap');
                List<CSS_SRT__c> srtObj = new List<CSS_SRT__c>();
                for(srtWrapper srtWrap : repListWrap){
                    for(compWrapper cmpwrp : srtWrap.compSRT){
                        system.debug('cmpwrp**'+cmpwrp);
                        srtObj.addAll(cmpwrp.additionalSRT);
                        for(CSS_SRT__c srtObjList :srtObj) {
                            if(srtObjList.Id == seltdSRTId){
                                system.debug('matched seltdSRTId>>:' +seltdSRTId);
                                if(options.size() > 2){
                                    system.debug('inside if oprtion>2 >>> ' + options);
                                    cmpwrp.lstAccountCodes = options;
                                    srtObjList.Account_Code__c = 'Select One';



                                    if(srtObjList.Account_Code__c != null && srtObjList.Account_Code__c!='Select One'){
                                        system.debug('inside sencond loop if accountcode' + srtObjList.Account_Code__c );
                                        if(accountCodeWithWarrantMap.containsKey(srtObjList.Account_Code__c)){
                                            system.debug('inside sencond loop if srt match' + srtObjList.SRT_Warrantable__c);           
                                            srtObjList.SRT_Warrantable__c = accountCodeWithWarrantMap.get(srtObjList.Account_Code__c);
                                            system.debug('SRT_Warrantable__c' +srtObjList.SRT_Warrantable__c);
                                        }
                                        else{
                                            srtObjList.SRT_Warrantable__c = '0';
                                            system.debug('SRT_Warrantable__c' +srtObjList.SRT_Warrantable__c);


                                        }
                                    }
                                    else if(srtObjList.Account_Code__c == null || srtObjList.Account_Code__c=='Select One'){
                                        srtObjList.SRT_Warrantable__c = '0';
                                        system.debug('SRT_Warrantable__c' +srtObjList.SRT_Warrantable__c);
                                    }


                                }
                                else{
                                    system.debug('inside if oprtion <2 >>> ' + options);
                                    cmpwrp.lstAccountCodes = options;
                                    //  cmpwrp.srtRec.SRT_Warrantable__c = '0';
                                    srtObjList.Account_Code__c = oneACCode;

                                    if(srtObjList.Account_Code__c != null && srtObjList.Account_Code__c!='Select One'){
                                        system.debug('inside sencond loop if accountcode' + srtObjList.Account_Code__c );
                                        if(accountCodeWithWarrantMap.containsKey(srtObjList.Account_Code__c)){
                                            system.debug('inside sencond loop if srt match' + srtObjList.SRT_Warrantable__c);           
                                            srtObjList.SRT_Warrantable__c = accountCodeWithWarrantMap.get(srtObjList.Account_Code__c);
                                            system.debug('SRT_Warrantable__c' +srtObjList.SRT_Warrantable__c);
                                        }
                                        else{
                                            srtObjList.SRT_Warrantable__c = '0';
                                            system.debug('SRT_Warrantable__c' +srtObjList.SRT_Warrantable__c);


                                        }
                                    }
                                    else if(srtObjList.Account_Code__c == null || srtObjList.Account_Code__c=='Select One'){
                                        srtObjList.SRT_Warrantable__c = '0';
                                        system.debug('SRT_Warrantable__c' +srtObjList.SRT_Warrantable__c);
                                    }

                                }
                                break;
                            }
                        }
                    }
                }
            }
            // For additional RepairSRTs
            if(additionalRepListWrap!=null){
                system.debug('inside repListWrap');
                List<CSS_SRT__c> srtObjAdd = new List<CSS_SRT__c>();
                for(srtWrapper srtWrap : additionalRepListWrap){
                    for(compWrapper cmpwrp : srtWrap.compSRT){
                        system.debug('cmpwrp**'+cmpwrp);
                        srtObjAdd.addAll(cmpwrp.additionalSRT);
                        for(CSS_SRT__c srtObjList :srtObjAdd) {
                            if(srtObjList.Id == seltdSRTId){
                                system.debug('matched seltdSRTId>>:' +seltdSRTId);
                                if(options.size() > 2){
                                    system.debug('inside if oprtion>2 >>> ' + options);
                                    cmpwrp.lstAccountCodes = options;
                                    srtObjList.Account_Code__c = 'Select One';

                                    if(srtObjList.Account_Code__c != null && srtObjList.Account_Code__c!='Select One'){
                                        system.debug('inside sencond loop if accountcode' + srtObjList.Account_Code__c );
                                        if(accountCodeWithWarrantMap.containsKey(srtObjList.Account_Code__c)){
                                            system.debug('inside sencond loop if srt match' + srtObjList.SRT_Warrantable__c);           
                                            srtObjList.SRT_Warrantable__c = accountCodeWithWarrantMap.get(srtObjList.Account_Code__c);
                                            system.debug('SRT_Warrantable__c' +srtObjList.SRT_Warrantable__c);
                                        }
                                        else{
                                            srtObjList.SRT_Warrantable__c = '0';
                                            system.debug('SRT_Warrantable__c' +srtObjList.SRT_Warrantable__c);


                                        }
                                    }
                                    else if(srtObjList.Account_Code__c == null || srtObjList.Account_Code__c=='Select One'){
                                        srtObjList.SRT_Warrantable__c = '0';
                                        system.debug('SRT_Warrantable__c' +srtObjList.SRT_Warrantable__c);
                                    }

                                }
                                else{
                                    system.debug('inside if oprtion <2 >>> ' + options);
                                    cmpwrp.lstAccountCodes = options;
                                    //  cmpwrp.srtRec.SRT_Warrantable__c = '0';
                                    srtObjList.Account_Code__c = oneACCode;

                                    if(srtObjList.Account_Code__c != null && srtObjList.Account_Code__c!='Select One'){
                                        system.debug('inside sencond loop if accountcode' + srtObjList.Account_Code__c );
                                        if(accountCodeWithWarrantMap.containsKey(srtObjList.Account_Code__c)){
                                            system.debug('inside sencond loop if srt match' + srtObjList.SRT_Warrantable__c);           
                                            srtObjList.SRT_Warrantable__c = accountCodeWithWarrantMap.get(srtObjList.Account_Code__c);
                                            system.debug('SRT_Warrantable__c' +srtObjList.SRT_Warrantable__c);
                                        }
                                        else{
                                            srtObjList.SRT_Warrantable__c = '0';
                                            system.debug('SRT_Warrantable__c' +srtObjList.SRT_Warrantable__c);


                                        }
                                    }
                                    else if(srtObjList.Account_Code__c == null || srtObjList.Account_Code__c=='Select One'){
                                        srtObjList.SRT_Warrantable__c = '0';
                                        system.debug('SRT_Warrantable__c' +srtObjList.SRT_Warrantable__c);
                                    }

                                }
                                break;
                            }
                        }
                    }
                }
            }

            if(options.size()==2 && failcodelst==true){
                acccodelst=true;}

        }catch(Exception ex) {
            System.debug('in catch of onChangeofFailCode>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }


    //New method2
    public List<SelectOption> getAccountCodeOptionList(String selectedFailCode){
        List<SelectOption> options;
        try{
            options =  new List<SelectOption>();
            //options.add(new SelectOption('Select One','Select One'));
            if(selectedFailCode==null || failAccountCodeMap ==null || failAccountCodeMap.size()<=0 || !failAccountCodeMap.containsKey(selectedFailCode)){
                return options;
            }

            List<string> sortable = new  List<string>();
            if(failAccountCodeMap.containsKey(selectedFailCode)){
                options = failAccountCodeMap.get(selectedFailCode);
            }
            system.debug('***final ac options' + options);
        }catch(Exception ex) {
            System.debug('in catch of getAccountCodeOptionList>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return options;
    }

    //Story #145252 - START - Code to update warrantable when accountcode is changed
    public void onChangeAccountCode(){

        system.debug('inside onchangeAccountCode-selectedSolId' + selectedSolId);
        system.debug('inside onchangeAccountCode-selectedSrtId' + selectedSrtId);
        system.debug('inside accountCodeWithWarrantMap' + accountCodeWithWarrantMap);
        //condition if requested for Diagnosis
        if(selectedSolId!=''){
            system.debug('inside srt'+diagListWrap+'selectedSolId'+selectedSolId);
            //loop through the DiagListWrap
            for(SrtWrapper srtwrap: diagListWrap){
                system.debug('inside srt'+diagListWrap);
                if(selectedSolId!=null && selectedSolId!=''){
                    //check for specific SRT
                    if(srtwrap.solId == selectedSolId){

                        for(SortWrapper sortWrap: srtwrap.lstDiagWrapSRT){

                            if(sortWrap.srtRec.Id == selectedSrtId){

                                //Populate warrantable based on Account Code
                                system.debug('sortWrap.srtRec.FailCode__c'+ sortWrap.srtRec.FailCode__c);
                                if(sortWrap.srtRec.FailCode__c == null || sortWrap.srtRec.FailCode__c=='Select One'){
                                    sortWrap.srtRec.Account_Code__c='Select One';

                                }
                                system.debug('SortWrap.Srt.Account_Code__c'+sortWrap.srtRec.Account_Code__c);
                                if(sortWrap.srtRec.Account_Code__c != null && sortWrap.srtRec.Account_Code__c!='Select One'){
                                    system.debug('inside sencond loop if accountcode' + sortWrap.srtRec.Account_Code__c );
                                    if(accountCodeWithWarrantMap.containsKey(sortWrap.srtRec.Account_Code__c)){
                                        system.debug('inside sencond loop if srt match' + sortWrap.srtRec.SRT_Warrantable__c);           
                                        sortWrap.srtRec.SRT_Warrantable__c = accountCodeWithWarrantMap.get(sortWrap.srtRec.Account_Code__c);
                                        system.debug('SRT_Warrantable__c' +sortWrap.srtRec.SRT_Warrantable__c);
                                    }
                                    else{
                                        sortWrap.srtRec.SRT_Warrantable__c = '0';
                                        system.debug('SRT_Warrantable__c' +sortWrap.srtRec.SRT_Warrantable__c);


                                    }
                                }
                                else if(sortWrap.srtRec.Account_Code__c == null || sortWrap.srtRec.Account_Code__c=='Select One'){
                                    sortWrap.srtRec.SRT_Warrantable__c = '0';
                                    system.debug('SRT_Warrantable__c' +sortWrap.srtRec.SRT_Warrantable__c);
                                }
                                break;

                            }
                            //break;
                        }
                        break;
                    }

                }    
            }
        }
        else{
            //Else if requested for Additional Diag
            system.debug('addi on changeaaccount' + additionalDiagListWrap);
            for(srtWrapper srtwrap : additionalDiagListWrap){
                system.debug('in fist for loop' + srtwrap.lstadditonalDiagSRT);
                if(selectedSrtId!=null && selectedSrtId!=''){

                    for(SortWrapper sortWrap: srtwrap.lstadditonalDiagSRT){

                        if(sortWrap.srtRec.Id == selectedSrtId){
                            system.debug('addi inside if' + sortWrap.srtRec.Account_Code__c);
                            system.debug('sortWrap.srtRec.FailCode__c'+ sortWrap.srtRec.FailCode__c);
                            if(sortWrap.srtRec.FailCode__c == null || sortWrap.srtRec.FailCode__c=='Select One'){
                                sortWrap.srtRec.Account_Code__c='Select One';

                            }
                            if(sortWrap.srtRec.Account_Code__c != null && sortWrap.srtRec.Account_Code__c!='Select One'){

                                if(accountCodeWithWarrantMap.containsKey(sortWrap.srtRec.Account_Code__c)){
                                    system.debug('inside sencond loop if srt match' + sortWrap.srtRec.SRT_Warrantable__c);           
                                    sortWrap.srtRec.SRT_Warrantable__c = accountCodeWithWarrantMap.get(sortWrap.srtRec.Account_Code__c); 
                                }
                                else{
                                    sortWrap.srtRec.SRT_Warrantable__c = '0'; 

                                }
                            }
                            else if(sortWrap.srtRec.Account_Code__c == null || sortWrap.srtRec.Account_Code__c=='Select One'){
                                sortWrap.srtRec.SRT_Warrantable__c = '0';    
                            }
                            break;

                        }

                    }
                    //break;
                }    

            }
        }
    }
    //Story #145252 - END 
    //code to populate warranty based on repair account code
    public void onChangeRepAccountCode(){

        system.debug('inside onChangeRepAccountCode-selectedSolId' + selectedSolId);
        system.debug('inside onChangeRepAccountCode-selectedSrtId' + selectedSrtId);
        system.debug('inside accountCodeWithWarrantMap' + accountCodeWithWarrantMap);
        //condition if requested for Diagnosis
        if(selectedSolId!=''){
            //loop through the DiagListWrap
            for(SrtWrapper srtwrap: repListWrap){

                if(selectedSolId!=null && selectedSolId!=''){
                    //check for specific SRT
                    system.debug('inside onChangeRepAccountCode-srtwrap.solId' + srtwrap.solId);
                    system.debug('inside onChangeRepAccountCode-selectedSolId' + selectedSolId);
                    if(srtwrap.solId == selectedSolId){

                        for(compWrapper sortWrap: srtwrap.compSRT){
                            for(integer i=0;i<sortWrap.repairList.size();i++){
                                system.debug('inside onChangeRepAccountCode-sortWrap.repairList[i].Id' + sortWrap.repairList[i].Id);
                                system.debug('inside onChangeRepAccountCode-selectedSrtId' + selectedSrtId);
                                if(sortWrap.repairList[i].Id == selectedSrtId){

                                    //Populate warrantable based on Account Code
                                    system.debug('sortWrap.repairList[i].FailCode__c'+ sortWrap.repairList[i].FailCode__c);
                                    if(sortWrap.repairList[i].FailCode__c == null || sortWrap.repairList[i].FailCode__c=='Select One'){
                                        sortWrap.repairList[i].Account_Code__c='Select One';

                                    }
                                    system.debug('SortWrap.Srt.Account_Code__c'+sortWrap.repairList[i].Account_Code__c);
                                    if(sortWrap.repairList[i].Account_Code__c != null && sortWrap.repairList[i].Account_Code__c!='Select One'){
                                        system.debug('inside sencond loop if accountcode' + sortWrap.repairList[i].Account_Code__c );
                                        if(accountCodeWithWarrantMap.containsKey(sortWrap.repairList[i].Account_Code__c)){
                                            system.debug('inside sencond loop if srt match' + sortWrap.repairList[i].SRT_Warrantable__c);  
                                            system.debug('inside sencond loop if srt match$$$$' + accountCodeWithWarrantMap.get(sortWrap.repairList[i].Account_Code__c));  
                                            sortWrap.repairList[i].SRT_Warrantable__c = accountCodeWithWarrantMap.get(sortWrap.repairList[i].Account_Code__c); 
                                            system.debug('SRT_Warrantable__c' +sortWrap.repairList[i].SRT_Warrantable__c);
                                        }
                                        else{
                                            sortWrap.repairList[i].SRT_Warrantable__c = '0';
                                            system.debug('SRT_Warrantable__c' +sortWrap.repairList[i].SRT_Warrantable__c);

                                        }
                                    }
                                    else if(sortWrap.repairList[i].Account_Code__c == null || sortWrap.repairList[i].Account_Code__c=='Select One'){
                                        sortWrap.repairList[i].SRT_Warrantable__c = '0';
                                        system.debug('SRT_Warrantable__c' +sortWrap.repairList[i].SRT_Warrantable__c);
                                    }
                                    break;

                                }
                                //break;
                            }
                        }
                        break;
                    }

                }    
            }
        }
        else{
            //Else if requested for Additional Repair
            system.debug('addi on changeaaccount' + additionalRepListWrap);
            for(srtWrapper srtwrap : additionalRepListWrap){
                system.debug('in fist for loop' + srtwrap.compSRT);
                if(selectedSrtId!=null && selectedSrtId!=''){

                    for(compWrapper sortWrap: srtwrap.compSRT){
                        for(integer i=0;i<sortWrap.additionalSRT.size();i++){
                            if(sortWrap.additionalSRT[i].Id == selectedSrtId){
                                system.debug('addi inside if' + sortWrap.additionalSRT[i].Account_Code__c);
                                system.debug('sortWrap.additionalSRT[i].FailCode__c'+ sortWrap.additionalSRT[i].FailCode__c);
                                if(sortWrap.additionalSRT[i].FailCode__c == null || sortWrap.additionalSRT[i].FailCode__c=='Select One'){
                                    sortWrap.additionalSRT[i].Account_Code__c='Select One';

                                }
                                if(sortWrap.additionalSRT[i].Account_Code__c != null && sortWrap.additionalSRT[i].Account_Code__c!='Select One'){

                                    if(accountCodeWithWarrantMap.containsKey(sortWrap.additionalSRT[i].Account_Code__c)){
                                        system.debug('inside sencond loop if srt match' + sortWrap.additionalSRT[i].SRT_Warrantable__c);           
                                        sortWrap.additionalSRT[i].SRT_Warrantable__c = accountCodeWithWarrantMap.get(sortWrap.additionalSRT[i].Account_Code__c);
                                        system.debug('SRT_Warrantable__c' + sortWrap.additionalSRT[i].SRT_Warrantable__c);
                                    }
                                    else{
                                        sortWrap.additionalSRT[i].SRT_Warrantable__c = '0';
                                        system.debug('SRT_Warrantable__c' + sortWrap.additionalSRT[i].SRT_Warrantable__c);


                                    }
                                }
                                else if(sortWrap.additionalSRT[i].Account_Code__c == null || sortWrap.additionalSRT[i].Account_Code__c=='Select One'){
                                    sortWrap.additionalSRT[i].SRT_Warrantable__c = '0'; 
                                    system.debug('SRT_Warrantable__c' + sortWrap.additionalSRT[i].SRT_Warrantable__c);
                                }
                                break;

                            }
                        }
                    }
                    //break;
                }    

            }
        }
    }
    //Story #145252 - END 

    // Story GSSC-20 Begin
    public String lineItemStepId {get;set;} 
    public String SRTContent {get;set;}
    public void callAccessStepDetailsDiag(){
        try{
            system.debug('lineItemStepId  ' + lineItemStepId);
            system.debug('EquipId ' + EquipId);
            CSS_J2AAccessStepDetails_SRT stepDetailsWS = CSS_SRTAccessWebService.accessSRTStepDetails_New(EquipId,lineItemStepId);
            system.debug('stepDetailsWS ' + stepDetailsWS);
            
            if(stepDetailsWS.DataArea!=null){
                if(stepDetailsWS.DataArea.CaseResponse!=null){
                    for(integer i=0;i<stepDetailsWS.DataArea.CaseResponse.size();i++){
                        SRTContent = stepDetailsWS.DataArea.CaseResponse[i].SRTContent;
                    }
                }
            }
            else
                SRTContent='';
            
            SRTContent = SRTContent.replaceAll('\\n','<br/>');
            SRTContent = SRTContent.replaceAll('\n','<br/>');

            system.debug('SRTContent ' + SRTContent);
        }
        catch(exception e){
            system.debug('Exception in callAccessStepDetails method Line Num' + e.getLineNumber() + ' Message' + e.getMessage());
        }
    }

    public void NotesPopupOkDiag(){
        SRTContent='';
    }

    // Repair

    public String lineItemStepIdRepair {get;set;} 
    public String SRTContentRepair {get;set;}
    public void callAccessStepDetailsRepair(){
        try{
            system.debug('lineItemStepIdRepair  ' + lineItemStepIdRepair);
            system.debug('EquipId ' + EquipId);
            CSS_J2AAccessStepDetails_SRT stepDetailsWS = CSS_SRTAccessWebService.accessSRTStepDetails_New(EquipId,lineItemStepIdRepair);
            system.debug('stepDetailsWS ' + stepDetailsWS);
            if(stepDetailsWS.DataArea!=null){
                if(stepDetailsWS.DataArea.CaseResponse!=null){
                    for(integer i=0;i<stepDetailsWS.DataArea.CaseResponse.size();i++){
                        SRTContentRepair = stepDetailsWS.DataArea.CaseResponse[i].SRTContent;
                    }
                }
            }
            else
                SRTContentRepair='';
            
             SRTContentRepair = SRTContentRepair.replaceAll('\\n','<br/>');
            SRTContentRepair = SRTContentRepair.replaceAll('\n','<br/>');

            system.debug('SRTContentRepair ' + SRTContentRepair);
        }
        catch(exception e){
            system.debug('Exception in callAccessStepDetails method Line Num' + e.getLineNumber() + ' Message' + e.getMessage());
        }
    }

    public void NotesPopupOkRepair(){
        SRTContentRepair='';
        system.debug('Ok button>> SRTContentRepair ' + SRTContentRepair );
    }
    // Story GSSC-20 End

    public class srtWrapper{
        public string solTitle{get;set;}
        public Integer allSRTCount{get;set;}
        public string solNum{get;set;}
        public string privatesolNum{get;set;}
        public string percentagewarranty{get;set;}
        //story 109746
        public string fautCodeName{get;set;}
        public string symptomName{get;set;}
        public boolean showHeader{get;set;}
        //end 109746
        //story 78937
        public string AccessCodeSaved{get;set;}
        public string SRTAccessCode{get;set;}
        public string AccessCode{get;set;}
        public string EquipmentID{get;set;}
        public string AccessCodeA{get;set;}
        public string AccessCodeB{get;set;}
        public string AccessCodeC{get;set;}
        public string AccessCodeD{get;set;}
        public string AccessCodeR{get;set;}
        public string SpecialAccessCode{get;set;}
        public string SpecialDescription{get;set;}
        //end   78937
        public id jobOrderId{get;set;}
        public id solId{get;set;}
        public list<sortWrapper> lstDiagWrapSRT{get;set;}
        public list<sortWrapper> lstadditonalDiagSRT{get;set;}

        //Story 90222 Diag Sort order change --end
        public string accTime{get;set;}
        public decimal accTimeDec{get;set;} 
        public string accRepTime{get;set;}
        public list<compWrapper> compSRT {get;set;}
        public List<selectOption> failcode{get;set;}
        public List<selectOption> accountcode{get;set;}
        public string selectedfailcode{get;set;}
        public string selectedaccountcode{get;set;}
        public List<selectOption> accesscodeoptions {get;set;}
        public List<selectOption> accCodes {get;set;}
        public Integer PrivateSrtCount{get;set;}
        public Integer addSrtCount{get;set;}
        // public boolean isSrtFailCode{get;set;}

        public srtWrapper(){
            compSRT = new list<compWrapper>();
            lstDiagWrapSRT = new list<sortWrapper>();
            lstadditonalDiagSRT = new list<sortWrapper>();
            failcode = new List<selectOption>();
            accountcode = new List<selectOption>();
            accesscodeoptions= new list<selectOption>();
            this.selectedfailcode = selectedfailcode;
            this.selectedaccountcode = selectedaccountcode;

            this.percentagewarranty = percentagewarranty;
            this.accCodes = accCodes;
            this.PrivateSrtCount=0;
            this.addSrtCount=0;

        }
    }
    public class compWrapper{
        public list<CSS_SRT__c> additionalSRT{get;set;}
        public integer srtCount{get;set;}
        public string compName{get;set;}
        public string compId{get;set;}
        public id compenentId{get;set;}
        //added as part of 111885
        public string percentagewarranty{get;set;}


        public list<CSS_SRT__c> repairList{get;set;}
        public list<SelectOption> lstAccountCodes{get;set;} //new field for accountcode dropdown
        public string PrivatecompName{get;set;}
        public compWrapper(){
            this.compName = compName;
            this.compId = compId;
            this.compenentId=compenentId;
            this.percentagewarranty = percentagewarranty;
            this.lstAccountCodes = lstAccountCodes;


            repairList = new list<CSS_SRT__c>();
            additionalSRT = new list<CSS_SRT__c>();

            //repairListWrap = new list<repairWrapper>();
        }
    }
}