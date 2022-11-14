/*
* Sai -- 10/24 - For View State issues.
* Clone of DARSRT Controller. Included the transient keywords for diagnosis & repair lists to avoid view state errors.
*/
public class CSS_DARSRT_RO {
    
    public transient List<srtWrapper> diagListWrap{get;set;}
    public transient List<srtWrapper> repListWrap{get;set;}
    public transient List<srtWrapper> additionalDiagListWrap{get;set;}
    public transient List<srtWrapper> additionalRepListWrap{get;set;}
    public transient List<CSS_SRT__c> lstSRT_VS{get;set;} 
    Transient List<CSS_Solution_Component__c> componentList = new List<CSS_Solution_Component__c>();
    public ID JobID{get;set;}
    Transient srtWrapper diagList;
    Transient srtWrapper repList;
    Transient srtWrapper adddiagList;
    Transient srtWrapper addrepList;
    Transient compWrapper cSRT;
    Transient compWrapper RepAccSRT;
    public transient boolean diagTotal{get;set{
        diagTotal=true;
    }}
    Transient List<CSS_Solutions__c> solutionList = new List<CSS_Solutions__c>();
    Transient List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
    public transient string diagnosisTime{get;set;}
    public transient string repairTime{get;set;}
    public transient Decimal diagAccTime{get;set;}
    public transient string repAccTime{get;set;}
    public transient Boolean displayPopup1{get;set;}
    public transient List<CSS_srt__c> lstDisplayDiagSRT{get;set;}
    public transient List<CSS_srt__c> lstDisplayRepSRT{get;set;}
    public transient List<CSS_srt__c> SRTList1{get;set;}
    public PageReference gotoJobPlanSrt(){       
        JobID=ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanSRT?id='+JobID); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    public transient decimal totalDecimalTimeRep{get;set;}
    public transient decimal totalDecimalTimediag{get;set;}
    public transient decimal totalDecimalTimeAccTot{get;set;}
    public transient decimal totalDecimalTimeAccRep{get;set;}
    public CSS_DARSRT_RO(){
       // system.debug('getSRTRoData>> callingmethod');
         getSRTRoData();
        
    }
    
    public void getSRTRoData(){
        try{
            diagListWrap = new List<srtWrapper>();
            repListWrap = new List<srtWrapper>();
            diagAccTime = 0;
            additionalDiagListWrap = new List<srtWrapper>();
            JobID=ApexPages.CurrentPage().getParameters().get('id');
            
            string pageData = ApexPages.CurrentPage().getURL();
            solutionList = [select id,Case_Name__c,Name,Solution_Title__c,Service_Job__r.AccessCode__c,Service_Job__r.Equipment_ID__c,Service_Job__c,Diagnostic_Response__c,Repair_Response__c,Symptom__r.Name,FaultCode__r.Name,
                            (select name,SRT_ID__c,Repair_Access_Calculated__c,Additional_SRT_Calculated__c,Diagnosis_Time__c,SRT_Decimal_Time__c,id,step_id__c,SRT_Time__c,Component_Id__c ,Type__c,Response_Message__c ,Repair_Time__c,Access_Code_A__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__c,Assignment__c,SRT_Status_Message__c,SRT_Title__c ,isPerformed__c,SRT_Quantity__c,SRT_Notes__c ,SRT_Warrantable__c,
                             Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Account_Code__c,FailCode__c,Access_Code_S1__c,Access_Code_S2__c,Access_Code_S3__c,Access_Code_S4__c,Access_Code_S5__c,Access_Code_S6__c,Access_Code_S7__c,Access_Code_S8__c,Access_Code_S9__c,S1_Description__c,S2_Description__c,S3_Description__c,S4_Description__c,Diag_Access_Time__c,
                             S5_Description__c,SRT_Access_Code__c,Access_Code__c,S6_Description__c,S7_Description__c,S8_Description__c,S9_Description__c,Special_Access_Code__c,Special_Access_Code_Desc__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code_Saved__c,Extended_Hours__c,SRT_Estimate__c from CSS_SRTS__r where CSS_Claims__c=null order by SRT_Order__c asc)
                            from CSS_Solutions__c where Service_Job__c=:JobID and (Diagnostic_Response__c = 'Most likely the solution' OR Diagnostic_Response__c = 'Not the solution')];
            
            //Added Root_Cause__c field and condition Root_Cause__c = true in where clause in below query as part of the defect GSSC 589
            componentList = [select name,action__c,Component_Id__c,AccountCode__c,AccountCodeEdit__c ,Fail_Code__c,Fail_Code_Editable__c,CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredTowingMiles__c,CoveredTravelLabor__c,CoveredTravelMiles__c,Solutions__c,Quantity__c,Service_Job__c,Service_Job__r.AccessCode__c,Selected_Component__c, Solutions__r.Symptom__r.Name,Solutions__r.FaultCode__r.Name,CSS_Account_Formula__c,
                             (select name,SRT_ID__c,Repair_Access_Calculated__c,step_id__c,Account_Code__c,FailCode__c,id,SRT_Time__c,Type__c,Additional_SRT_Calculated__c,Repair_Time__c,SRT_AccessiblityCheck__c,Diag_Access_Time__c,Diagnosis_Time__c,SRT_Decimal_Time__c,Access_Code_A__c,Component_Id__c ,Solution_Title__c,Solution_Number__c,Assignment__c,SRT_Title__c ,Response_Message__c ,isPerformed__c,SRT_Quantity__c,SRT_Notes__c ,SRT_Warrantable__c,SRT_Order__c,Access_Code__c
                              from CSS_SRTS__r where Assignment__c IN ('Primary', 'Progressive Damage','Alternative') order by Assignment__c desc ) 
                             from CSS_Solution_Component__c where Service_Job__c=:JobID AND Root_Cause__c = true];
            additionalSRTList  = [select name,Assignment__c,SRT_ID__c,id,Repair_Access_Calculated__c,Account_Code__c,FailCode__c,SRT_Time__c,step_id__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Time__c,Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,SRT_Status_Message__c,SRT_Notes__c ,SRT_Warrantable__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code__c,Access_Code_Saved__c,job_order__r.AccessCode__c,SRT_Category__c
                                  from CSS_SRT__C where Job_Order__c=:JobID and Solution_Number__c = null]; 
            
            
            decimal timediag=0.0;
            decimal timediagTot =0.0;
            decimal timeRep = 0.0;
            decimal timeAcc = 0.0;
            decimal timeAccRep = 0.0;
            //decimal timeAccTot = 0.0;
            decimal timeAccRepTot =0.0;
            decimal timeAddRepTime =0.0;
            decimal timeAddDiagTime =0.0;       
            string sDTime;
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
                timeAcc=0.0;
                timeAccRep = 0.0;
                diagList = new srtWrapper();
                repList = new srtWrapper();
                
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
                    diagList.fautCodeName = sol.FaultCode__r.Name ;
                    diagList.symptomName = sol.Symptom__r.Name ;
                    
                    list<CSS_SRT__c> dia = new List<CSS_SRT__c>();
                    if(sol.CSS_SRTS__r!=null && !sol.CSS_SRTS__r.isEmpty()){
                        for(integer i=0;i<sol.CSS_SRTS__r.size();i++){
                            if((sol.CSS_SRTS__r[i].Type__c.equalsIgnoreCase('Diagnosis') || sol.CSS_SRTS__r[i].Type__c.equalsIgnoreCase('Diag Access'))&& sol.CSS_SRTS__r[i].Solution_Number__c == sol.id){
                               
                                if(sol.CSS_SRTS__r[i].Access_Code__c == null){
                                    sol.CSS_SRTS__r[i].Access_Code__c  = sol.Service_Job__r.AccessCode__c;}
                                else
                                    sol.CSS_SRTS__r[i].Access_Code__c  = sol.CSS_SRTS__r[i].Access_Code__c;
                                diagList.lstDiagWrapSRT.add(new sortWrapper(sol.CSS_SRTS__r[i]));
                                if((sol.CSS_SRTS__r[i].isPerformed__c == true) && sol.CSS_SRTS__r[i].Type__c.equalsIgnoreCase('Diagnosis')){ //Kalpana Added Diagnosis Condition
                                    timediag = timediag + (sol.CSS_SRTS__r[i].Diagnosis_Time__c * sol.CSS_SRTS__r[i].SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633
                                }
                                diagList.AccessCode = sol.CSS_SRTS__r[i].Job_Engine_Access_Code__c;
                                diagList.EquipmentID = sol.Service_Job__r.Equipment_ID__c;
                                diagList.AccessCodeA = string.valueof(sol.css_Srts__r[i].Access_Code_A__c);
                                diagList.AccessCodeB = string.valueof(sol.css_Srts__r[i].Access_Code_B__c);
                                diagList.AccessCodeC = string.valueof(sol.css_Srts__r[i].Access_Code_C__c);
                                diagList.AccessCodeD = string.valueof(sol.css_Srts__r[i].Access_Code_D__c);
                                diagList.AccessCodeR = string.valueof(sol.css_Srts__r[i].Access_Code_R__c);
                                diagList.SpecialAccessCode = sol.css_Srts__r[i].Special_Access_Code__c;
                                diagList.SpecialDescription = sol.css_Srts__r[i].Special_Access_Code_Desc__c;
                                
                            }
                            
                        }
                    }
                }
                if(sol.CSS_SRTS__r!=null && !sol.CSS_SRTS__r.isEmpty()){
                    if(mapRepairAccessRec != null && !mapRepairAccessRec.containsKey(sol.id))
                    {
                        mapRepairAccessRec.put(sol.id, new list<CSS_SRT__c>());
                    }
                    for(integer a=0;a<sol.CSS_SRTS__r.size();a++){
                        if(sol.CSS_SRTS__r[a].Type__c!=null){
                            if(sol.CSS_SRTS__r[a].Type__c.equalsIgnoreCase('Diag Access') && sol.CSS_SRTS__r[a].Solution_Number__c == sol.id){
                                if(sol.CSS_SRTS__r[a].SRT_AccessiblityCheck__c){
                                    diagAccTime = diagAccTime + (sol.CSS_SRTS__r[a].Diag_Access_Time__c * sol.CSS_SRTS__r[a].SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633
                                }
                            }
                            if(sol.CSS_SRTS__r[a].Type__c.equalsIgnoreCase('Repair Access') && sol.CSS_SRTS__r[a].Solution_Number__c == sol.id ){
                                if(pageData.containsIgnoreCase('JobTnDRj') || pageData.containsIgnoreCase('JobRepair') ){ //|| pageData.containsIgnoreCase('JobReadOnly') || pageData.containsIgnoreCase('JobPlan')){
                                    
                                    if(sol.Repair_Response__c!=null && sol.Diagnostic_Response__c == 'Most likely the solution'){
                                        boolean compCheck;
                                        for(CSS_Solution_Component__c solComp : componentList){
                                            if(solComp.Selected_Component__c){
                                                compCheck = true;
                                                break;
                                            }
                                        }
                                        if(sol.CSS_SRTS__r[a].SRT_AccessiblityCheck__c && compCheck ==  true){
                                            timeAccRep =  sol.CSS_SRTS__r[a].Repair_Access_Calculated__c; 
                                            
                                            repList.accRepTime = string.valueof(sol.CSS_SRTS__r[a].Repair_Access_Calculated__c);
                                            timeAccRepTot = timeAccRepTot + (sol.CSS_SRTS__r[a].Repair_Access_Calculated__c * sol.CSS_SRTS__r[a].SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633;
                                            repAccTime = string.valueof(sol.CSS_SRTS__r[a].Repair_Access_Calculated__c);
                                        }
                                    }
                                }else{
                                    if(sol.CSS_SRTS__r[a].SRT_AccessiblityCheck__c){
                                        
                                        timeAccRep =  sol.CSS_SRTS__r[a].Repair_Access_Calculated__c; 
                                        
                                        repList.accRepTime = string.valueof(sol.CSS_SRTS__r[a].Repair_Access_Calculated__c);
                                        timeAccRepTot = timeAccRepTot + (sol.CSS_SRTS__r[a].Repair_Access_Calculated__c * sol.CSS_SRTS__r[a].SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633;;
                                        repAccTime = string.valueof(sol.CSS_SRTS__r[a].Repair_Access_Calculated__c);
                                    }}
                                if(mapRepairAccessRec != null && mapRepairAccessRec.keySet().size() > 0){
                                    mapRepairAccessRec.get(sol.id).add(sol.CSS_SRTS__r[a]);
                                }
                            }
                        }
                    }
                }
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
                if(pageData.containsIgnoreCase('JobTnDRj') || pageData.containsIgnoreCase('JobRepair')){ //|| pageData.containsIgnoreCase('JobReadOnly') || pageData.containsIgnoreCase('JobPlan')){
               
                    if(sol.Repair_Response__c!=null && sol.Diagnostic_Response__c == 'Most likely the solution'){
                        repList.solTitle = sol.Solution_Title__c;
                        repList.AccessCode = sol.Service_Job__r.AccessCode__c;
                        repList.solNum = sol.Name;
                        repList.jobOrderId = sol.Service_Job__c;
                        repList.solId = sol.id;
                        repList.fautCodeName = sol.FaultCode__r.Name ;
                        repList.symptomName = sol.Symptom__r.Name ;
                        Boolean AddAccSRT = false; //--END
                        for(CSS_Solution_Component__c solComp : componentList){
                            if(solComp.Selected_Component__c){
                                cSRT = new compWrapper();
                                if(solComp.Solutions__c == sol.id){
                                    if(solComp.CSS_SRTS__r!=null && !solComp.CSS_SRTS__r.isEmpty()){
                                        cSRT.compName = solComp.Name;
                                        cSRT.compId = solComp.Component_Id__c;
                                        cSRT.compenentId=solComp.Id;
                                        if((solComp.CoveredLaborHrs__c!=null && solComp.CoveredLaborHrs__c!='' && Integer.ValueOf(solComp.CoveredLaborHrs__c) > 0) || (solComp.CoveredMealsLodgingAmt__c!=null && solComp.CoveredMealsLodgingAmt__c!='' && Integer.ValueOf(solComp.CoveredMealsLodgingAmt__c) > 0) ||(solComp.CoveredOCAmount__c!=null && solComp.CoveredOCAmount__c!='' && Integer.ValueOf(solComp.CoveredOCAmount__c)> 0) || (solComp.CoveredPartsQty__c!=null && solComp.CoveredPartsQty__c!='' && Integer.ValueOf(solComp.CoveredPartsQty__c)> 0) || (solComp.CoveredTowingMiles__c!=null && solComp.CoveredTowingMiles__c!='' && Integer.ValueOf(solComp.CoveredTowingMiles__c )> 0) ||(solComp.CoveredTravelLabor__c!=null && solComp.CoveredTravelLabor__c!='' && Integer.ValueOf(solComp.CoveredTravelLabor__c )> 0) || (solComp.CoveredTravelMiles__c!=null && solComp.CoveredTravelMiles__c!='' && Integer.ValueOf(solComp.CoveredTravelMiles__c )> 0)){
                                            cSRT.percentagewarranty = '100';
                                        }
                                        else{
                                            cSRT.percentagewarranty = '0';
                                        }
                                        
                                        //end
                                        cSRT.srtCount = solComp.CSS_SRTS__r.size();
                                        integer j;//Anirudh
                                        for(j=0;j<solComp.CSS_SRTS__r.size();j++){
                                            allSRTCountForSol = allSRTCountForSol + 1;
                                            if(solComp.CSS_SRTS__r[j].Type__c.equalsIgnoreCase('Repair') && solComp.CSS_SRTS__r[j].Solution_Number__c == sol.id  && solComp.Solutions__c == sol.id && solComp.Id==solComp.CSS_SRTS__r[j].Component_Id__c){
                                                if(solComp.CSS_SRTS__r[j].Access_Code__c == null){
                                                    solComp.CSS_SRTS__r[j].Access_Code__c  = sol.Service_Job__r.AccessCode__c;}
                                                else
                                                    solComp.CSS_SRTS__r[j].Access_Code__c  = solComp.CSS_SRTS__r[j].Access_Code__c;
                                                
                                                if((solComp.CSS_SRTS__r[j].Assignment__c != null)  ){
                                                    cSRT.repairList.add(solComp.CSS_SRTS__r[j]);
                                                }
                                                if(solComp.CSS_SRTS__r[j].isPerformed__c == true){
                                                    timeRep = timeRep + (solComp.CSS_SRTS__r[j].Repair_Time__c * solComp.CSS_SRTS__r[j].SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633
                                                    
                                                }
                                                
                                            }
                                        }
                                        solCompCount = allSRTCountForSol + mapRepairAccessRec.get(sol.id).size();
                                        repList.allSRTCount = solCompCount;
                                        if(!AddAccSRT)
                                            if(mapRepairAccessRec != null && mapRepairAccessRec.size()>0){
                                                cSRT.repairList.addAll(mapRepairAccessRec.get(sol.id));
                                                AddAccSRT = true;
                                            }
                                        repList.compSRT.add(cSRT);
                                    }
                                }
                            }}
                        
                    } 
                }
                else
                {
                    if(sol.Diagnostic_Response__c == 'Most likely the solution'){
                        repList.solTitle = sol.Solution_Title__c;
                        repList.solNum = sol.Name;
                        repList.jobOrderId = sol.Service_Job__c;
                        repList.solId = sol.id;
                        repList.AccessCode = sol.Service_Job__r.AccessCode__c;
                        repList.fautCodeName = sol.FaultCode__r.Name ;
                        repList.symptomName = sol.Symptom__r.Name ;
                        Integer repCompCount = 0;
                        Boolean AddAccSRT1 = false;
                        for(CSS_Solution_Component__c solComp : componentList){
                            repCompCount = repCompCount + 1;
                            cSRT = new compWrapper();
                            if(solComp.Solutions__c == sol.id){
                                
                                if(solComp.CSS_SRTS__r!=null && !solComp.CSS_SRTS__r.isEmpty()){
                                    cSRT.compName = solComp.Name;
                                    cSRT.compId = solComp.Component_Id__c;
                                    cSRT.compenentId=solComp.Id;
                                    if((solComp.CoveredLaborHrs__c!=null && solComp.CoveredLaborHrs__c!='' && Integer.ValueOf(solComp.CoveredLaborHrs__c) > 0) || (solComp.CoveredMealsLodgingAmt__c!=null && solComp.CoveredMealsLodgingAmt__c!='' && Integer.ValueOf(solComp.CoveredMealsLodgingAmt__c) > 0) ||(solComp.CoveredOCAmount__c!=null && solComp.CoveredOCAmount__c!='' && Integer.ValueOf(solComp.CoveredOCAmount__c)> 0) || (solComp.CoveredPartsQty__c!=null && solComp.CoveredPartsQty__c!='' && Integer.ValueOf(solComp.CoveredPartsQty__c)> 0) || (solComp.CoveredTowingMiles__c!=null && solComp.CoveredTowingMiles__c!='' && Integer.ValueOf(solComp.CoveredTowingMiles__c )> 0) ||(solComp.CoveredTravelLabor__c!=null && solComp.CoveredTravelLabor__c!='' && Integer.ValueOf(solComp.CoveredTravelLabor__c )> 0) || (solComp.CoveredTravelMiles__c!=null && solComp.CoveredTravelMiles__c!='' && Integer.ValueOf(solComp.CoveredTravelMiles__c )> 0)){
                                        cSRT.percentagewarranty = '100';
                                    }
                                    else{
                                        cSRT.percentagewarranty = '0';
                                    }
                                    cSRT.srtCount = solComp.CSS_SRTS__r.size();  
                                    integer k;
                                    for(k=0;k<solComp.CSS_SRTS__r.size();k++){
                                        allSRTCountForSol = allSRTCountForSol + 1;
                                        if(solComp.CSS_SRTS__r[k].Type__c.equalsIgnoreCase('Repair') && solComp.CSS_SRTS__r[k].Solution_Number__c == sol.id  && solComp.Solutions__c == sol.id && solComp.Id==solComp.CSS_SRTS__r[k].Component_Id__c){
                                            
                                            if(solComp.CSS_SRTS__r[k].Access_Code__c == null){
                                                solComp.CSS_SRTS__r[k].Access_Code__c  = sol.Service_Job__r.AccessCode__c;}
                                            else
                                                solComp.CSS_SRTS__r[k].Access_Code__c  = solComp.CSS_SRTS__r[k].Access_Code__c;
                                            
                                            if((solComp.CSS_SRTS__r[k].Assignment__c != null) ){
                                                cSRT.repairList.add(solComp.CSS_SRTS__r[k]);
                                            }
                                            if(solComp.CSS_SRTS__r[k].isPerformed__c == true){
                                                timeRep = timeRep + (solComp.CSS_SRTS__r[k].Repair_Time__c * solComp.CSS_SRTS__r[k].SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633
                                            
                                            }
                                        }
                                    }
                                    solCompCount = allSRTCountForSol + mapRepairAccessRec.get(sol.id).size();
                                    repList.allSRTCount = solCompCount;
                                    if(!AddAccSRT1)
                                        if(mapRepairAccessRec != null && mapRepairAccessRec.size()>0){
                                            cSRT.repairList.addAll(mapRepairAccessRec.get(sol.id));
                                            AddAccSRT1 = true;
                                        }
                                    repList.compSRT.add(cSRT);
                                    
                                }
                            }
                        }
                    }
                }
                
                
                if (diagList.solTitle !=null ){
                    diagListWrap.add(diagList);
                    inc++;
                }
                if (repList.solTitle != null && repList.compSRT!=null && !repList.compSRT.isEmpty()){
                    repListWrap.add(repList);
                    inc1++;
                }
            }
            diagnosisTime=sDTime;
            if(additionalSRTList.size()>0){
                
                adddiagList = new srtWrapper();                      
                adddiagList.solNum = 'Additional SRTS';
                
                for (CSS_SRT__c addSRTLst:additionalSRTList){ 
                    if(addSRTLst.srt_category__c!= null && addSRTLst.srt_category__c.equalsIgnoreCase('AdditionalDiag')){ //Kalpana: story#121938

                        adddiagList.lstadditonalDiagSRT.add(new sortWrapper(addSRTLst));
                        
                        adddiagList.AccessCode = addSRTLst.job_order__r.AccessCode__c; //Dhaarmik
                        if(addSRTLst.type__c.equalsIgnoreCase('Access') && addSRTLst.SRT_AccessiblityCheck__c == true){ //Kalpana: story#121938
                            diagAccTime = diagAccTime+(addSRTLst.SRT_Time__c * addSRTLst.SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633;
                        }
                        
                        if(addSRTLst.isPerformed__c == true && addSRTLst.type__c != 'Access'){  //Kalpana: Added Type!='Access' Condition//&& addSRTLst.type__c.equalsIgnoreCase('Diagnosis')){  
                            timediag = timediag +(addSRTLst.Additional_SRT_Calculated__c * addSRTLst.SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633;
            
                        }
                    }
                }
     
                
                if(adddiagList.lstadditonalDiagSRT.size()>0){
                    adddiagList.lstadditonalDiagSRT.sort();
                    additionalDiagListWrap.add(adddiagList);
                }   
                
            }//End IFSize
            additionalRepListWrap = new List<srtWrapper>();
            if(additionalSRTList.size()>0){
                addrepList = new srtWrapper();   
                CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
                addrepList.solNum = 'Additional SRTS';
                cSRT = new compWrapper();
                cSRT.compName = 'Additional Components';
                for (CSS_SRT__c addSRTLst:additionalSRTList){
                    System.debug('Seven');
                    if(addSRTLst.srt_category__c!= null && addSRTLst.srt_category__c.equalsIgnoreCase('AdditionalRep')){ //Kalpana: story#121938
                        addrepList.AccessCode = addSRTLst.job_order__r.AccessCode__c; //Dhaarmik
                        cSRT.additionalSRT.add(addSRTLst);    
                        
                        if(addSRTLst.type__c.equalsIgnoreCase('Access') && addSRTLst.SRT_AccessiblityCheck__c == true){ //Kalpana: story#121938
                            timeAccRepTot = timeAccRepTot+(addSRTLst.SRT_Time__c * addSRTLst.SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633
                        }
                        
                        if(addSRTLst.isPerformed__c == true && addSRTLst.type__c != 'Access'){ //Kalpana: Added Type!='Access' Condition //&& addSRTLst.type__c.equalsIgnoreCase('Repair')){ 
                            timeRep = timeRep + (addSRTLst.Additional_SRT_Calculated__c * addSRTLst.SRT_Quantity__c);//venkat: added SRT_Quantity__c for the story 154633;           
                        }
                    }
                }
                addrepList.compSRT.add(cSRT);
                if(addrepList.compSRT.size()>0){
                    additionalRepListWrap.add(addrepList);
                }    
            }
            totalDecimalTimeRep = timeRep;
            totalDecimalTimediag = timediag; 
            
            totalDecimalTimeAccRep = timeAccRepTot;
        }        
        catch(Exception e){
            System.debug('The error in srt is'+e.getMessage()+e.getLineNumber());
        }
        
    }
    
    
    //Wrapper for Sort order for Diagnosis Access SRT. 
    public class sortWrapper implements Comparable{
        public CSS_SRT__c srtRec{get;set;}
        public boolean selectedRecord{get;set;}
        
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
    

    public class srtWrapper{
        
        public string solTitle{get;set;}
        public Integer allSRTCount{get;set;}
        public string solNum{get;set;}
        public string fautCodeName{get;set;}
        public string symptomName{get;set;}
        public boolean showHeader{get;set;}
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
        public id jobOrderId{get;set;}
        public id solId{get;set;}
        public list<sortWrapper> lstDiagWrapSRT{get;set;}
        public list<sortWrapper> lstadditonalDiagSRT{get;set;}
        public string accTime{get;set;}
        public decimal accTimeDec{get;set;} 
        public string accRepTime{get;set;}
        public list<compWrapper> compSRT {get;set;}
        public srtWrapper(){
            compSRT = new list<compWrapper>();
            lstDiagWrapSRT = new list<sortWrapper>();
            lstadditonalDiagSRT = new list<sortWrapper>();
        }
    }
    public class compWrapper{
        public list<CSS_SRT__c> additionalSRT{get;set;}
        public integer srtCount{get;set;}
        public string compName{get;set;}
        public string compId{get;set;}
        public id compenentId{get;set;}
        public string percentagewarranty{get;set;}
        public string failcode{get;set;}
        public string accountcode{get;set;}
        
        public list<CSS_SRT__c> repairList{get;set;}
        public compWrapper(){
            this.compName = compName;
            this.compId = compId;
            this.compenentId=compenentId;
            this.percentagewarranty = percentagewarranty;
            this.failcode = failcode;
            this.accountcode = accountcode;
            repairList = new list<CSS_SRT__c>();
            additionalSRT = new list<CSS_SRT__c>();
        }
    }
}