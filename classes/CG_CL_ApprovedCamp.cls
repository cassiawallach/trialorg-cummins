/**********************************************************************
Name:CG_CL_ApprovedCamp
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this component Controller for Customer Approved/Completed Campaigns,TRPS in Reviewjob Page.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Karthik Gorantla      12/28/2017      INITIAL DEVELOPMENT                    
***********************************************************************/

public class CG_CL_ApprovedCamp { 
    
    //public string comm {get;set;}
    public Id Wid;
    //public CSS_Job_order__c workJob{set;get;}
    public List<Note> workJob2 {get;set;}
    public CG_CL_IntakeRJ mainContrRJ{set; get;}
    public List<CSS_Solution_Component__c> solCompCTTP {get;set;}
    
    //Transient List<CSS_CampTsbTrp__c> qsolCTTP {get;set;}
    Transient map<string,CSS_CampTsbTrp__c> qsolCampMap = new map<string,CSS_CampTsbTrp__c>(); //not needed this
    
    List<CSS_CampTsbTrp__c> lstALL {get;set;}//not needed this
    public CG_CL_IntakeRJ intakeRJController = new CG_CL_IntakeRJ();
    
    public CG_CL_ApprovedCamp()
    {
        try {
            //controllerRef = this;
            system.debug('ApprovedCamp');
            Wid=ApexPages.CurrentPage().getParameters().get('id');
            if(Wid== null) 
            {
                //mainContrRJ.workJob =new css_job_order__c();                    
            } else 
            {    
                
            }
        }
        catch(Exception e)  
        {
            system.debug('EXCEPTION of CG_CL_IntakeRJ constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        
    }
    
    /* code added for tsps and trps  start*/
    public map<string,CSS_CampTsbTrp__c> qsolCTTPMap = new map<string,CSS_CampTsbTrp__c>(); //Defect fix 95870
    public map<string,CSS_Solution_Component__c> solCompCTTPMap = new map<string,CSS_Solution_Component__c>();
    
    // public List<CSS_Solution_Component__c> getALLRecords(){
    public List<CSS_CampTsbTrp__c> getALLRecords_old(){
        
        //system.debug('qsolCTTP'+qsolCTTP);
        // List<CSS_CampTsbTrp__c> CTT = new  List<CSS_CampTsbTrp__c>();
        
        try{
            
            ///////////////////////////// not sure why this block exist? 
            for(CSS_CampTsbTrp__c campRec : mainContrRJ.qsolCTTP){
                system.debug('**Inside For Loop **');
                qsolCTTPMap.put(campRec.Doc_Num__c,campRec);
                if(qsolCampMap != null && !qsolCampMap.isEmpty()){
                    system.debug('qsolCampMap.get(campRec.Doc_Num__c).URL__c-->'+qsolCampMap.get(campRec.Doc_Num__c).URL__c);
                    if(qsolCampMap.get(campRec.Doc_Num__c) != null && qsolCampMap.get(campRec.Doc_Num__c).URL__c != null){
                        campRec.URL__c = qsolCampMap.get(campRec.Doc_Num__c).URL__c;
                    }
                }
            }
            //////////////////////////////////////////
            //Kalpana Story# 115658
            system.debug('mainContrRJ.solCompCTTP**'+mainContrRJ.solCompCTTP);
            for(CSS_Solution_Component__c campRec : mainContrRJ.solCompCTTP){
                system.debug('**Inside For Loop **');
                solCompCTTPMap.put(campRec.Component_id__c,campRec);
                if(qsolCampMap != null && !qsolCampMap.isEmpty()){
                    system.debug('qsolCampMap.get(campRec.Doc_Num__c).URL__c-->'+qsolCampMap.get(campRec.Component_Id__c).URL__c);
                    if(qsolCampMap.get(campRec.Component_Id__c) != null && qsolCampMap.get(campRec.Component_Id__c).URL__c != null){
                        campRec.URL__c = qsolCampMap.get(campRec.Component_Id__c).URL__c;
                    }
                }
            }
            
            /*****Modularized code***** START**/
            User userObj;
            if(userObj == null){
                userObj = css_utility.getUserAttributes(Userinfo.getUserId());
            }
            CSS_accountLanguage__c accountlang = css_utility.getLanguage(userObj.LanguageLocaleKey);
            system.debug('accountlang**'+accountlang);
            lstALL = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstCAM = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstTRP = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstTSB = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstATC = new List<CSS_CampTsbTrp__c>();
            List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getSiebelQSOLCampaigns(wId,  mainContrRJ.workjob.ESN__c, accountlang.CSS_QsolLanguage__c,  mainContrRJ.workjob.Service_Model__c, mainContrRJ.workjob.Failure_Date__c);
            if(campaignsList !=null && campaignsList.size()>0)
                lstTSB = campaignsList.get(0);
            if(campaignsList !=null && campaignsList.size()>1)
                lstCAM = campaignsList.get(1);
            if(campaignsList !=null && campaignsList.size()>2)
                lstTRP = campaignsList.get(2);
            if(campaignsList !=null && campaignsList.size()>3)
                lstATC = campaignsList.get(3);
            
            lstALL.addAll(lstCAM);
            lstALL.addAll(lstTRP);
            lstALL.addAll(lstATC);
            system.debug('lstALL >>>>> ' + lstALL);
            
            if(mainContrRJ.workJob.Notes != null && !mainContrRJ.workJob.Notes.isEmpty()){
                workjob2 = new List<Note>();
                for(Note b : mainContrRJ.workJob.Notes){
                    if(b.title.equalsIgnoreCase('CAMPCOMMENTS')){
                        workjob2.add(b);
                    }
                    
                }
            } 
            
        }
        catch(exception e){
            
        }
        
        return lstALL;
    }
    
    public List<CSS_Solution_Component__c> getALLRecords(){
        system.debug('in getALLRecords...');
        try{
            if(mainContrRJ.workJob.Notes != null && !mainContrRJ.workJob.Notes.isEmpty()){
                workjob2 = new List<Note>();
                for(Note b : mainContrRJ.workJob.Notes){
                    if(b.title.equalsIgnoreCase('CAMPCOMMENTS')){
                        workjob2.add(b);
                    }
                    
                }
            } 
            //update mainContrRJ.solCompCTTP;
            //new code start
            //solCompCTTP = new List<CSS_Solution_Component__c>([select Id, Type__c,URL__c,  Component_Id__c, Campaign_Description__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_Solution_Component__c where Service_Job__c= :Wid AND Type__c in('Campaign','TRP','ATC') and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))  order by Type__c LIMIT 1000]);
            //Get QSOL Docs for existing ESN
            List<CSS_CampTsbTrp__c> lstQSOLDocs = new List<CSS_CampTsbTrp__c>([Select Id, Type__c, Job_Order__c,ESN__c, Doc_Num__c, 
                                                                               Doc_Title__c, URL__c, Reviewed__c,Performed__c,
                                                                               Performed_Review__c,Cu_Language__c from CSS_CampTsbTrp__c
                                                                               where Job_Order__c = :Wid and ESN__c = :mainContrRJ.workJob.ESN__c and Type__c !='TSB' 
                                                                               order by Performed_Review__c desc]);
            //add qsol links
            mainContrRJ.solCompCTTP = CG_BL_Intake.addQSOLLinksToSiebelQueryList(mainContrRJ.solCompCTTP, lstQSOLDocs);
            //new code end
        }catch(exception ex){
            System.debug('in catch of getALLRecords of css_repair_job >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return mainContrRJ.solCompCTTP;
    }
    
    /* Move to Main Controller  */
    public boolean showCampaignPopup{get;set;}
    public pageReference showFieldActionPopup(){
        showCampaignPopup = false;
        System.debug('inside showFieldActionPopup:'+mainContrRJ.solCompCTTP);
        //Saving Comments first
            if(mainContrRJ.comm !='' && mainContrRJ.comm !=null ){
                    system.debug('JobID' +Wid);
                    Note x = new Note();
                    x.Title = 'CAMPCOMMENTS';
                    x.ParentId = Wid;  
                    x.Body = mainContrRJ.comm;
                    insert x;
             }
        List<CSS_Solution_Component__c> solCompCampTRP = [select Selected_Claim_Type__c,Type__C,css_claims__r.Information_Only_Claim__c, Name,Component_Id__c,Fail_Code__c,Failure_Mode__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,Campaign_Start_Date__c,CampaignTravelPercentage__c,Service_Job__c,Performed__c,Performed_Review__c,Reviewed__c,URL__C,Approval_Code__c,AccountCodeEdit__c,Pay_Code__c,AccountCodeType__c,AccountCode__c,Selected_Component__c 
                                                          from CSS_Solution_Component__c where Type__c in ('Campaign','TRP','ATC') and Service_Job__c =:mainContrRJ.workJob.id  and Status__c='Approved'];
        Map<String, Boolean> existingSelection = new Map<String, Boolean>();
        for(css_solution_component__c SolComp1: SolCompCampTRP){
            existingSelection.put(SolComp1.Component_Id__c, SolComp1.Performed_Review__c);
        }
        if(mainContrRJ.solCompCTTP != null && !mainContrRJ.solCompCTTP.isEmpty()){
            for(CSS_Solution_Component__c fcw : mainContrRJ.solCompCTTP){
                system.debug('fcw.SelectedComp--->'+fcw.Performed_Review__c);
                system.debug('inside if fcw.FieldActNum.'+fcw.Component_Id__c);
                /*if(fcw.Performed_Review__c == false){
showCampaignPopup = true;
break;
system.debug('inside if showCampaignPopup'+showCampaignPopup);
}*/
                if(fcw.Performed_Review__c == false && existingSelection.containsKey(fcw.Component_Id__c) && existingSelection.get(fcw.Component_Id__c) == true){ //to find out unselected FieldActions which are selected previously
                    showCampaignPopup = true;
                    break;
                    system.debug('inside if showCampaignPopup'+showCampaignPopup);
                }   
            }
        }
        if(showCampaignPopup)
            return null;
        else{
            saveCheckBoxComp_New();}
        //return null;
        PageReference ReturnPage = new PageReference('/apex/CG_IntakeRJ?id='+Wid); 
        ReturnPage.setRedirect(true);
        return ReturnPage;
    }
    
    public pageReference saveCheckBoxComp_New(){
        system.debug('inside savecheckbox in CG_CL_ApprovedCamp');
        try{
            //Saving Comments first
            /*if(mainContrRJ.comm !='' && mainContrRJ.comm !=null ){
                    system.debug('JobID' +Wid);
                    Note x = new Note();
                    x.Title = 'CAMPCOMMENTS';
                    x.ParentId = Wid;  
                    x.Body = mainContrRJ.comm;
                    insert x;
             }*/
            
            List<CSS_Solution_Component__c> solCompCampTRP = [select Selected_Claim_Type__c,Type__C,css_claims__r.Information_Only_Claim__c, Name,Component_Id__c,Fail_Code__c,Failure_Mode__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,Campaign_Start_Date__c,CampaignTravelPercentage__c,Service_Job__c,Performed__c,Performed_Review__c,Reviewed__c,URL__C,Approval_Code__c,AccountCodeEdit__c,Pay_Code__c,AccountCodeType__c,AccountCode__c,Selected_Component__c 
                                                              from CSS_Solution_Component__c where Type__c in ('Campaign','TRP','ATC') and Service_Job__c =:mainContrRJ.workJob.id  and Status__c='Approved'];
            Map<String, Boolean> existingSelection = new Map<String, Boolean>();
            for(css_solution_component__c SolComp1: SolCompCampTRP){
                existingSelection.put(SolComp1.Component_Id__c, SolComp1.Performed_Review__c);
            }
            System.debug('ExistingsolCompCampTRP>>>:'+solCompCampTRP);
            System.debug('existingSelection>>>:'+existingSelection);
            if(mainContrRJ.solCompCTTP != null && !mainContrRJ.solCompCTTP.isEmpty()){
                //To delete associated line items of CAM/ATC/TRP & prepare delete lists -- #190513-Start
                Map<string,string> failAccCodeMap = new Map<string,string>();
                Set<String> nonSelFieldAction = new Set<String>();
                Set<String> SelFieldAction = new Set<String>();
                for(CSS_Solution_Component__c fcw : mainContrRJ.solCompCTTP){
                    system.debug('fcw.SelectedComp--->'+fcw.Performed_Review__c);
                    system.debug('inside if fcw.FieldActNum.'+fcw.Component_Id__c);
                    if((fcw.Performed_Review__c == false && existingSelection.get(fcw.Component_Id__c)) 
                       || (fcw.Performed_Review__c == false && existingSelection.containsKey(fcw.Component_Id__c) && existingSelection.get(fcw.Component_Id__c) == false)){ //to find out unselected FieldActions which are not selected previously
                           // showCampaignPopup = true;
                           system.debug('inside if fcw.SelectedComp.'+fcw.Performed_Review__c);
                           failAccCodeMap.put(fcw.Fail_Code__c,fcw.css_account_formula__c);
                           nonSelFieldAction.add(fcw.Component_Id__c);
                           fcw.Selected_Component__c = false; // to keep it in sync with Performed_Review__c
                       }
                    else if(fcw.Performed_Review__c == true && existingSelection.containsKey(fcw.Component_Id__c) && existingSelection.get(fcw.Component_Id__c) == false){ //to find out selected FieldActions which are not selected previously
                        SelFieldAction.add(fcw.Component_Id__c); 
                        fcw.Selected_Component__c = true; // to keep it in sync with Performed_Review__c
                    }
                    else {
                        continue; //to ignore already selected & saved FieldActions for not retriggering FieldActionSRTs/Parts
                    }
                }
                system.debug('failAccCodeMap**'+failAccCodeMap);
                system.debug('nonSelFieldAction**'+nonSelFieldAction);
                system.debug('SelFieldAction**'+SelFieldAction);
                
                List<css_srt__c> srtList = [Select id,Component_Id__c,Component_Id__r.Component_Id__c,FailCode__c, AccountCode_Formula__c from css_Srt__c where Job_Order__c = :Wid AND 
                                            (Type__c IN ('Admin','Field Action','Field Action Access','CAMPAIGN','TRP','ATC','99Time') OR SRT_Category__c IN ('CAMPAIGN','TRP','ATC'))];
                system.debug('srtList**'+srtList);
                
                List<css_srt__c> deletesrtList = new List<css_srt__c>();
                for(css_Srt__c srt:srtList){
                    system.debug('Inside SRT ELSE**'+srt.FailCode__c);
                    system.debug('Inside SRT ELSE1**'+srt.AccountCode_Formula__c);
                    if(srt.FailCode__c != null && srt.FailCode__c != ''){
                        if((srt.AccountCode_Formula__c != null && srt.AccountCode_Formula__c != '') && (srt.FailCode__c != null && srt.FailCode__c != '') && failAccCodeMap.get(srt.FailCode__c) == srt.AccountCode_Formula__c)
                            deletesrtList.add(srt);
                        else if((srt.AccountCode_Formula__c == null || srt.AccountCode_Formula__c == '') && (failAccCodeMap.get(srt.FailCode__c) != null && failAccCodeMap.get(srt.FailCode__c) != ''))
                            deletesrtList.add(srt);
                    }
                    else{
                        if(nonSelFieldAction.contains(srt.Component_Id__r.Component_Id__c)){
                            deletesrtList.add(srt);
                        }
                    }
                }
                system.debug('deletesrtList'+deletesrtList);
                //query for associated Parts
                List<CSS_Parts_Options__c> partsList = [select id,Fail_Code__c,FailurepartId__c,Get_Fail_Code_Formula__c,Account_Code__c,recordtype.name,Parts_Type__c from CSS_Parts_Options__c
                                                        where Service_Job__c = :Wid AND ((recordtype.name = 'Parts' AND parts_type__c = 'Custom') OR (recordtype.name = 'Parts' AND FailurepartId__r.type__c IN ('CAMPAIGN','TRP','ATC')) OR recordtype.name IN('OtherClaimables','TTML'))];
                system.debug('partsList**'+partsList);
                
                List<CSS_Parts_Options__c> deletepartsList = new List<CSS_Parts_Options__c>();
                for(CSS_Parts_Options__c part: partsList){
                    system.debug('Inside ELSE**'+part.Get_Fail_Code_Formula__c);
                    system.debug('Inside ELSE1**'+part.Account_Code__c);
                    system.debug('failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6))**'+failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)));
                    if((part.Get_Fail_Code_Formula__c != null && part.Get_Fail_Code_Formula__c != '') && (part.Account_Code__c != null && part.Account_Code__c != '') && failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) == part.Account_Code__c ){
                        system.debug('Inside SET**');
                        deletepartsList.add(part);
                    }
                    //Task 191433
                    //else if((part.Get_Fail_Code_Formula__c != null && part.Get_Fail_Code_Formula__c != '') && (part.Account_Code__c == null || part.Account_Code__c == '') && (failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) != null && failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) != '') )
                    else if((part.Get_Fail_Code_Formula__c != null && part.Get_Fail_Code_Formula__c != '') && (part.Account_Code__c == null || part.Account_Code__c == '' || part.Account_Code__c == 'Select One') && (failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) != null && failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) != '') )
                        deletepartsList.add(part);
                }
                system.debug('deletepartsList'+deletepartsList);
                
                //CG_OP_OAGWrapper ReselectResp = new CG_OP_OAGWrapper();
                if(SelFieldAction != null && SelFieldAction.size()>0){
                    String FailureDateString = DateTime.newInstance(mainContrRJ.workJob.Failure_Date__c.year(),mainContrRJ.workJob.Failure_Date__c.month(),mainContrRJ.workJob.Failure_Date__c.day()).format('dd-MMM-YY');
                    CG_BL_Campaigns.callGetCampaignsWebServiceforReselectonJob(mainContrRJ.workJob.esn__c, FailureDateString,mainContrRJ.workJob.Region__c,mainContrRJ.workJob.Territory__c, 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty',mainContrRJ.workJob.id,SelFieldAction, nonSelFieldAction);
                }
                
                //Update Field Actions then delete prepared line items lists
                update mainContrRJ.solCompCTTP;
                System.debug('after updating solCompCTTP>>>:'+mainContrRJ.solCompCTTP);
                
                //Deleting associated line items here
                if(deletesrtList != null && deletesrtList.size()>0)
                    delete deletesrtList;
                if(deletepartsList != null && deletepartsList.size()>0)
                    delete deletepartsList;
                //To delete associated line items of CAM/ATC/TRP & prepare delete lists -- #190513-End
            }
            
            /*PageReference ReturnPage = new PageReference('/apex/CG_IntakeRJ?id='+Wid); 
ReturnPage.setRedirect(true);
return ReturnPage;*/
        }catch(exception ex){
            System.debug('in catch of saveCheckBox of css_tnd_job >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        //return null;
        PageReference ReturnPage = new PageReference('/apex/CG_IntakeRJ?id='+Wid); 
        ReturnPage.setRedirect(true);
        return ReturnPage;
    }
    
    
    public pageReference saveCheckBoxComp(){
        system.debug('inside savecheckbox in CG_CL_ApprovedCamp');
        try{
            if(mainContrRJ.comm !='' && mainContrRJ.comm !=null ){
                system.debug('JobID' +Wid);
                Note x = new Note();
                x.Title = 'CAMPCOMMENTS';
                x.ParentId = Wid;  
                x.Body = mainContrRJ.comm;
                
                insert x;
                // }
            }
            
            System.debug('before updating solCompCTTP>>>:'+mainContrRJ.solCompCTTP);
            if(mainContrRJ.solCompCTTP != null && !mainContrRJ.solCompCTTP.isEmpty()){
                //To delete associated line items of CAM/ATC/TRP & prepare delete lists -- #190513-Start
                Map<string,string> failAccCodeMap = new Map<string,string>();
                Set<String> nonSelFieldAction = new Set<String>();
                for(CSS_Solution_Component__c fcw : mainContrRJ.solCompCTTP){
                    system.debug('fcw.SelectedComp--->'+fcw.Performed_Review__c);
                    system.debug('inside if fcw.FieldActNum.'+fcw.Component_Id__c);
                    if(fcw.Performed_Review__c == false){
                        // showCampaignPopup = true;
                        system.debug('inside if fcw.SelectedComp.'+fcw.Performed_Review__c);
                        failAccCodeMap.put(fcw.Fail_Code__c,fcw.css_account_formula__c);
                        nonSelFieldAction.add(fcw.Id);
                    }
                }
                system.debug('failAccCodeMap**'+failAccCodeMap);
                system.debug('nonSelFieldAction**'+nonSelFieldAction);
                
                List<css_srt__c> srtList = [Select id,Component_Id__c,FailCode__c, AccountCode_Formula__c from css_Srt__c where Job_Order__c = :Wid AND 
                                            (Type__c IN ('Admin','Field Action','Field Action Access','CAMPAIGN','TRP','ATC','99Time') OR SRT_Category__c IN ('CAMPAIGN','TRP','ATC'))];
                system.debug('srtList**'+srtList);
                
                List<css_srt__c> deletesrtList = new List<css_srt__c>();
                for(css_Srt__c srt:srtList){
                    system.debug('Inside SRT ELSE**'+srt.FailCode__c);
                    system.debug('Inside SRT ELSE1**'+srt.AccountCode_Formula__c);
                    if(srt.FailCode__c != null && srt.FailCode__c != ''){
                        if((srt.AccountCode_Formula__c != null && srt.AccountCode_Formula__c != '') && (srt.FailCode__c != null && srt.FailCode__c != '') && failAccCodeMap.get(srt.FailCode__c) == srt.AccountCode_Formula__c)
                            deletesrtList.add(srt);
                        else if((srt.AccountCode_Formula__c == null || srt.AccountCode_Formula__c == '') && (failAccCodeMap.get(srt.FailCode__c) != null && failAccCodeMap.get(srt.FailCode__c) != ''))
                            deletesrtList.add(srt);
                    }
                    else{
                        if(nonSelFieldAction.contains(srt.Component_Id__c)){
                            deletesrtList.add(srt);
                        }
                    }
                }
                system.debug('deletesrtList'+deletesrtList);
                //query for associated Parts
                List<CSS_Parts_Options__c> partsList = [select id,Fail_Code__c,FailurepartId__c,Get_Fail_Code_Formula__c,Account_Code__c,recordtype.name,Parts_Type__c from CSS_Parts_Options__c
                                                        where Service_Job__c = :Wid AND ((recordtype.name = 'Parts' AND parts_type__c = 'Custom') OR (recordtype.name = 'Parts' AND FailurepartId__r.type__c IN ('CAMPAIGN','TRP','ATC')) OR recordtype.name IN('OtherClaimables','TTML'))];
                system.debug('partsList**'+partsList);
                List<CSS_Parts_Options__c> deletepartsList = new List<CSS_Parts_Options__c>();
                for(CSS_Parts_Options__c part: partsList){
                    system.debug('Inside ELSE**'+part.Get_Fail_Code_Formula__c);
                    system.debug('Inside ELSE1**'+part.Account_Code__c);
                    if((part.Get_Fail_Code_Formula__c != null && part.Get_Fail_Code_Formula__c != '') && (part.Account_Code__c != null && part.Account_Code__c != '') && failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) == part.Account_Code__c ){
                        system.debug('Inside SET**');
                        deletepartsList.add(part);
                    }
                    else if((part.Get_Fail_Code_Formula__c != null && part.Get_Fail_Code_Formula__c != '') && (part.Account_Code__c == null || part.Account_Code__c == '') && (failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) != null && failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) != '') )
                        deletepartsList.add(part);
                }
                system.debug('deletepartsList'+deletepartsList);
                
                //Update Field Actions then delete prepared line items lists
                update mainContrRJ.solCompCTTP;
                System.debug('after updating solCompCTTP>>>:'+mainContrRJ.solCompCTTP);
                
                //Deleting associated line items here
                if(deletesrtList != null && deletesrtList.size()>0)
                    delete deletesrtList;
                if(deletepartsList != null && deletepartsList.size()>0)
                    delete deletepartsList;
                //To delete associated line items of CAM/ATC/TRP & prepare delete lists -- #190513-End
            }
            
            PageReference ReturnPage = new PageReference('/apex/CG_IntakeRJ?id='+Wid); 
            ReturnPage.setRedirect(true);
            return ReturnPage;
        }catch(exception ex){
            System.debug('in catch of saveCheckBox of css_tnd_job >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return null;
    }
    
}