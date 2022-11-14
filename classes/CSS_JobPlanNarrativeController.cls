/*
 * Block comments with details of changes
 */

public  class CSS_JobPlanNarrativeController {

    public string workjobStatus;
    public Integer complaintcounter{set;get;}
    public Integer coveragecounter{set;get;}
    public Integer causecounter{set;get;}
    public Integer correctioncounter{set;get;}
   // public boolean accQuoteFlag{set; get;} 
   // public string NotesBody {get;set;} 
    //public id recTypeIdpart ;
    public list<CSS_Parts_Options__c> sendparts;
   // public list<string> faultList {get; set;}
   // public list<string> partlist {get; set;}
   // public list<string> partlistFAULT {get; set;}
    //public CSS_unitInboundJSON2Apex UIResp{get;set;}
    public string mil_measure;
    public string comm {get;set;}
    public string jobLocation;
    public List<CSS_Fault_Code__c> fauCod;
    public css_job_order__c closeJob{get;set;}
    public Boolean bmsUserCloseFlag;
    public integer countquote{get;set;}
    public List<selectOption> resolutionOptions{get;set;} 
    public List<CSS_Solutions__c> responseValues{get;set;}
    public List<selectOption> responseOptions{get;set;}
    public boolean showResolution{get;set;}
    set<Id> solutionIds = new set<Id>();
    list<CSS_Solutions__c> outOfOrderSolList = new list<CSS_Solutions__c>();
    public boolean dsidStatus {get;set;}
public Boolean displayClosePopup {get;set;}
    public Boolean displayPopup {get;set;}
    public Boolean nocamptsbtrps{get;set;}
    public boolean showRepairs{get;set;}
    public String nonSRTnotes{get;set;}
    public List<CSS_SRT__c> nonSRTList{get;set;}
    public CG_cancelServiceJobWrapper cancelSJWrapperObj1{get;set;}
    public boolean sendNarratives{get;set;}
    public boolean checkFailures{get;set;}
    public Boolean displayNarrativeButton{get;set;}
    public Boolean displayNarrativeButtonDist{get;set;}
    public boolean displaySendERP_Button{get;set;}
     public Boolean showResolutionRequired{get;set;}//ROD Defect 179167 Added by Rajesh Narra 
    public Boolean showRepairRequired {get;set;}//ROD Defect 179167 Added by Rajesh Narra
    public void mainSOQL(){
        workJob=[Select Id,Name,PACCAR_Auth_Required__c,AccessCode__c,Account__r.ERP_System__c,BMSWSStatus__c,BMSStatus__c,Customer_Name__c,Cstmr_Contacts_Phone__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                 Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c, Warranty_Start_Date__c,Make__c,
                 DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,EditComplaint__c,EditCorrection__c,EditCoverage__c,EditCause__c,Non_SRT_Details__c,
                 Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Category_Desc__c, Complaint_Type__c, Complaint_Type_Desc__c, Model__c,Creator_Location__c, Control_Number__c,Equipment_ID__c,
                 Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c, CSS_Job_Location_Code__c, CSS_Resolution__c,CSS_Feedback_Comments__c,
                 ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Actual_Technician_Time__c,ApplicationCode__c
                 from CSS_Job_Order__c where id= :Wid];
    }

    public CSS_JobPlanNarrativeController() {
        
     CauseNotesFlag=false;
     CorrectionNotesFlag=false;
     CoverageNotesFlag=false;
     ComplaintNotesFlag=false;
     nonSRTNotesFlag=false;
     Narrativebutton=false;
     showResolutionRequired = false;//Added by Rajesh Narra
     showRepairRequired = false;//Added by Rajesh Narra
        
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        workjobStatus=ApexPages.CurrentPage().getParameters().get('status');
        nonSRTList = new List<CSS_SRT__c>();
        //string partsUr = ApexPages.CurrentPage().getParameters().get('joPa');
        try {
            mainSOQL();
            displayNarrativeButton = css_utility.showQuotePage(UserInfo.getUserId(), workJob.Creator_Location__c);
              String orgtype = css_utility.getOrgType(userinfo.getUserId());
                if(orgtype == 'DISTR'){
                   displayNarrativeButtonDist = false;   
                }
                else {
                   displayNarrativeButtonDist = true;   
                }
            displaySendERP_Button = css_utility.getclaimsapprove(UserInfo.getUserId());
            system.debug('displaySendERP_Button-->'+displaySendERP_Button);
            if((workJob.EditComplaint__c!=null) || (workJob.EditCoverage__c!=null) || (workJob.EditCause__c!=null) || (workJob.EditCorrection__c!=null) || (workJob.Non_SRT_Details__c!=null)){
            sendNarratives = true;
            }
            else
                sendNarratives = false;
            
            if(workJob.BMSStatus__c != null && workJob.BMSStatus__c.contains('QTFI0') && displayNarrativeButton)//css_utility.getclaimsapprove(UserInfo.getUserId())
                checkFailures = true;
            else
                checkFailures = false;
            
            system.debug('sendNarratives--'+sendNarratives+'  checkFailures--'+checkFailures);
            
            if(workJob.EditComplaint__c!=null)
                complaintcounter=4000 - (workJob.EditComplaint__c).length() ;
            else{
                complaintcounter=4000;
            }
            if(workJob.EditCoverage__c!=null)
                coveragecounter=4000 - (workJob.EditCoverage__c).length() ;
            else{
                coveragecounter=4000;
            }
            if(workJob.EditCause__c!=null)
                causecounter=4000 - (workJob.EditCause__c).length() ;
            else{
                causecounter=4000;
            }
            if(workJob.EditCorrection__c!=null)
                correctioncounter=4000 - (workJob.EditCorrection__c).length() ;
            else{
                correctioncounter=4000;
            }
            System.debug('****workJob.EditComplaint__c'+workJob.EditComplaint__c);

            System.debug('****counter'+correctioncounter);

            system.debug('workjob status '+workjobStatus);
            css_header_nav__c CS = css_header_nav__c.getInstance(UserInfo.getProfileId()); 

            string userId = UserInfo.getUserId();
            system.debug('userId*****'+userId);

            //bmsEnabled=css_utility.getBMSEnabled(userId);
            //Modified as per story# 76192
            bmsEnabled=css_utility.getBMSEnabled(workJob.Creator_Location__c);
            system.debug('bmsEnabled - Intake'+bmsEnabled);

            if(workJob.chevron_page__c == 'Narr')
                showJobPlanBlocks(false,false,false,false,true,false,false); 
            
               /* if(CS.EnableBMSButton__c && bmsEnabled)    
                    showJobPlanBlocks(false,false,false,false,false,true,false);
                else
                    showJobPlanBlocks(false,true,false,false, false,false,false);
                    
            else{ showJobPlanBlocks(false,true,false,false, false,false,false); }*/

            /*if(partsUr == 'Parts'){
                system.debug('partsUr'+partsUr);
                showJobPlanBlocks(false,false,false,true, false,false,false);
            }*/

           //partsListWrap = getListWrap();
           for(CSS_SRT__c srt : [SELECT id,SRT_Notes__c FROM CSS_SRT__c WHERE Job_order__c=:Wid AND Type__c='99Time']){
                                        
                if(srt.SRT_Notes__c!=null && srt.SRT_Notes__c!= ''){ 
                    nonSRTList.add(srt);
                }    
            }
        }
        catch(Exception e)  {
        }
    }  

    public ID Wid; 
    public css_job_order__c workJob {get;set;}
    public boolean bmsEnabled {get;set;}
    
    public string jo_btn_cls { get; set; } 
    public string srt_btn_cls { get; set; }      
    public string prt_btn_cls { get; set; }
    public string war_btn_cls { get; set; }
    public string nar_btn_cls { get; set; }
    public string qt_btn_cls { get; set; }

    public string jo_chv_sts { get; set; }    
    public string srt_chv_sts { get; set; }
    public string prt_chv_sts { get; set; }
    public string war_chv_sts { get; set; }
    public string nar_chv_sts { get; set; }
    public string qt_chv_sts { get; set; }

    public string jo_txt_sts { get; set; }  
    public string srt_txt_sts { get; set; }      
    public string prt_txt_sts { get; set; }
    public string war_txt_sts { get; set; }
    public string nar_txt_sts { get; set; }
    public string qt_txt_sts { get; set; }

    public string jo_txt_val { get; set; }  
    public string srt_txt_val { get; set; }  
    public string prt_txt_val { get; set; } 
    public string war_txt_val { get; set; }
    public string nar_txt_val { get; set; }  
    public string qt_txt_val { get; set; }


    
     public Boolean show_jo_pnl { get; set; }  
    public Boolean show_jov_pnl { get; set; } 
    public Boolean show_jpq_pnl { get; set; } 
    public Boolean show_war_pnl { get; set; }  
    public Boolean show_prt_pnl { get; set; } 
    public Boolean show_narr_pnl { get; set; } 
    public Boolean show_srt_pnl { get; set; } 
    
    /******* Method for Chevrons Initialization ****/
    public void showJobPlanBlocks(boolean jo_stat,boolean srt_stat,boolean prt_stat, boolean war_stat, boolean jo_narr,boolean jpq_stat,boolean jov_stat)
    { 
        show_jo_pnl = jo_stat;
        show_narr_pnl = jo_narr;
        show_srt_pnl = srt_stat;
        show_prt_pnl = prt_stat;
        show_war_pnl = war_stat;
        show_jpq_pnl = jpq_stat;
        show_jov_pnl = jov_stat;
       if (jo_narr)
        {
            jo_btn_cls = 'chev_jpo_img_open';
            srt_btn_cls = 'chev_jpsrt_img_open';
            prt_btn_cls = 'chev_jpparts_img_open';
            war_btn_cls = 'chev_wr_img_open';
            nar_btn_cls = 'chev_jpnarrative_img_active';
            qt_btn_cls = 'chev_jpquote_img_open';

            jo_chv_sts = 'sopen';
            srt_chv_sts = 'sopen';
            prt_chv_sts = 'sopen';
            war_chv_sts = 'sopen';
            nar_chv_sts = 'sactive';
            qt_chv_sts = 'sopen';

            jo_txt_sts =  'chev_text_open';
            srt_txt_sts =  'chev_text_open';
            prt_txt_sts =  'chev_text_open';
            war_txt_sts =  'chev_text_open';
            nar_txt_sts =  'chev_text_active';
            qt_txt_sts =  'chev_text_open';

            jo_txt_val = '';
            srt_txt_val = '';
            prt_txt_val = '';
            war_txt_val = '';
            nar_txt_val = 'Diagnosis';
            qt_txt_val = '';
        }
        }
       
   public PageReference jobplan_jpq()
    {
        css_job_order__c worecord= new css_job_order__c();
        showJobPlanBlocks(false,false,false,false, false,true,false); 

        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        else
        {

            worecord.chevron_page__c = 'jpq';
            worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;
            if (Wid != null)
            {
                System.Debug('value of customer===='+workJob.customer_name__c);
                worecord.id=workJob.id;
                update worecord;
                System.Debug('record updated====='+worecord);
                //updateFailCodeComponents();
                //   return null;
            }
        } 
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanQuote?id='+worecord.id); 
        pageRef.setRedirect(true);
        return pageRef;
    }

    
    public PageReference jobplan_narr()
    {
        css_job_order__c worecord= new css_job_order__c();
        showJobPlanBlocks(false,true,false,false,false,false,false);

        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        else
        {

            worecord.chevron_page__c = 'narr';
            worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;

            if (Wid != null)
            {
                worecord.id=workJob.id;
                update worecord;
                //updateFailCodeComponents();
            }
        }
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanNarrative?id='+worecord.id); 
        pageRef.setRedirect(true);
        return pageRef;

    }
  public string ChkFieldBlank()
    {
        //Modified as per story# 64030
        //if ((workJob.Customer_Name__c == null) && (workJob.Shop_Work_Order__c == null) &&(workJob.Application__c == null) && (workJob.Unit_number__c == null) && (workJob.Mileage__c == null)&& (workJob.ESN__c== null) 
        if ((workJob.Customer_Name__c == null) && (workJob.Shop_Work_Order__c == null) &&(workJob.Application_Desc__c == null) && (workJob.Unit_number__c == null) && (workJob.Mileage__c == null)&& (workJob.ESN__c== null) 
            && (workJob.General_Symptoms__c == null))
        {
            //  System.Debug('in BLANK==============');
            return 'BLANK';
        }
        //Modified as per story# 64030
        //else if ((workJob.Customer_Name__c == null || workJob.Customer_Name__c == '') || (workJob.Application__c == null || workJob.Application__c == ''))
        else if ((workJob.Customer_Name__c == null || workJob.Customer_Name__c == '') || (workJob.Application_Desc__c == null || workJob.Application_Desc__c == ''))
        {
            //  System.Debug('in VALIDATE==============');
            return 'VALIDATE';
        }
        else
        {
            // System.Debug('in FILLED==============');
            return 'FILLED';
        }
    }
public PageReference pgSave(){
        // System.Debug('**in jobplan=============='+workJob.Customer_Name__c);

        css_job_order__c worecord= new css_job_order__c();


        if (ChkFieldBlank() =='BLANK')
        {
            //reqBoolean='true';
            return null;
        }
        else
        {

            worecord.Customer_Name__c=workJob.Customer_Name__c;     
            worecord.Shop_Work_Order__c=workJob.Shop_Work_Order__c;            
            worecord.ESN__c = workJob.ESN__c;       
            //Modifed as per story# 79153
            //worecord.Category__c = workJob.Category__c;        
            worecord.Category_Desc__c = workJob.Category_Desc__c;   
            worecord.Mileage__c = workJob.Mileage__c;
            worecord.Mileage_Measure__c = mil_measure;
            worecord.Failure_Date__c=workJob.Failure_Date__c;
            worecord.Failure_Point__c = workJob.Failure_Point__c;        
            worecord.General_Symptoms__c=workJob.General_Symptoms__c;
            worecord.Service_Model__c = workJob.Service_Model__c;
            worecord.VIN__c = workJob.VIN__c;
            worecord.Warranty_Start_Date__c=workJob.Warranty_Start_Date__c;
            worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;
            worecord.Actual_Technician_Time__c = workJob.Actual_Technician_Time__c;
            system.debug('nonSRTList--'+nonSRTList);
            //worecord.Non_SRT_Details__c = 
            //Defect Fix - 75783
            worecord.Status__c='Job Plan';
            // Defect fix 59457
            saveCheckBox();
            if (Wid == null)
            {
                worecord.jobLocation__c=jobLocation;
                insert worecord;
                Wid = worecord.id;
                //updateFailCodeComponents();
                PageReference pageRef = new pageReference('/apex/CSS_JobPlan?id='+worecord.id); 
                pageRef.setRedirect(true);
                return pageRef;
            }
            else
            {
                System.Debug('value of customer===='+workJob.customer_name__c);
                worecord.id=workJob.id;
                update worecord;
                System.Debug('record updated====='+worecord);
                //updateFailCodeComponents(); 
                return null;
            }
        }
    }    
   
    public PageReference pgSaveFinish()
    {
        System.Debug('in pgSaveFinish==============');
        css_job_order__c worecord= new css_job_order__c();

        //   CSS_JobOrderWrapper wrap = new CSS_JobOrderWrapper(workJob,filterMake,filterModel,mil_measure,fail_measure);
        //   worecord = wrap.worecord;
        worecord.Previous_Status__c = workJob.Status__c;
        worecord.Status__c='Closed';
        worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
        worecord.Unit_Number__c = workJob.Unit_Number__c;
        worecord.Actual_Technician_Time__c = workJob.Actual_Technician_Time__c;
        saveCheckBox();
        System.debug('worecord'+worecord);
        if (Wid == null)
        {
            worecord.jobLocation__c=jobLocation;
            insert worecord;
            Wid = worecord.id;
        }
        else
        {
            System.Debug('value of customer===='+workJob.customer_name__c);
            worecord.id=workJob.id;
            update worecord;
            System.Debug('record updated====='+worecord);
        }

        PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    
  public pagereference saveCheckBox(){
        if(comm !='' && comm !=null ){
            system.debug('JobID' +Wid);
            Note x = new Note();
            x.Title = 'CAMPCOMMENTS';
            x.ParentId = Wid;  
            x.Body = comm;
            insert x;
        }
        return null;       
    }
     public void closeSession_close()
    {
        displayClosePopup=false;
         cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        cancelSJWrapperObj1.errorFlag = false;
        cancelSJWrapperObj1.errorMessage = '';
        cancelSJWrapperObj1.serviceJob = workJob;
    }
    
    public PageReference closeSession(){
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        cancelSJWrapperObj1.errorFlag = false;
        cancelSJWrapperObj1.errorMessage = '';
        cancelSJWrapperObj1.serviceJob = workJob;
        user u = css_utility.getUserAttributes(UserInfo.getUserId());
        CSS_EDSAuthentication.getEDSUpdateTnR(workJob.DSID__c, u.FederationIdentifier, workJob.Customer_Name__c, workJob.Make__c, workJob.Model__c, workJob.AccessCode__c, workJob.Equipment_ID__c, workJob.Failure_Point__c, workJob.Failure_Point_Measure__c, workJob.Unit_Number__c,workJob.ESN__c,workJob.Shop_Work_Order__c);
        css_dsidclose dscl = new css_dsidclose();
        AggregateResult[]  fc = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Wid];
        System.debug('One 4');
        if(fc.size()>0){
            System.debug('One 5');
            integer maxSeq = integer.valueOf(fc[0].get('maxSeq'));
            System.debug('One 6');
            fauCod = [select Primary_Fault_Code__c, FaultCode__c,Name, Fault_Code_Type__c, Related_Fault_Code__c from CSS_Fault_Code__c 
                      where Job_Order__c=:Wid and Sequence__c=:maxSeq and FaultCode__c !=Null and (Fault_Code_Type__c='APD-P' OR Fault_Code_Type__c='APD-R' OR Fault_Code_Type__c='BPD')];
        }
        //if (Wid != null && dsidIndi != null && dsidIndi.containsIgnoreCase('O'))
        if(Wid!=null)
        { 
            closeJob = [Select id,DSID__c, (Select Id,Name, Case_Name__c, Service_Job__c,Repair_response__c,Out_Of_Order__c,Rank__c,Solution_Title__c ,
                                            Solution__c,Diagnostic_Response__c FROM CSS_Solutions__r where service_job__c =:Wid), (Select id, name , performed__c, performed_review__c, 
                                                                                                                                   Reviewed__c from CSS_CampTsbTrp__r where job_order__C=:Wid and( performed_review__c=True and performed__c=False))                    
                        from CSS_Job_Order__c where id= :Wid];
            System.debug('closeJob'+closeJob);

            countquote = 0;
            AggregateResult[] quoteAgg;
            quoteAgg = [Select count(Id) countquote from CSS_Quote__c where Service_Job__c =:Wid ];
            countquote = integer.valueOf(quoteAgg[0].get('countquote'));
            System.Debug('>>>>>countquote '+countquote);
            //Fixed for non bms user
            if (bmsEnabled == true && (workJob.Customer_Code__c == null || workJob.Unit_Number__c== null || workJob.Shop_Work_Order__c == null || countquote==0)){
                System.Debug('>>>>>Inside bmsFistFlag '+bmsUserCloseFlag);
                bmsUserCloseFlag = true;
            }

            PageReference pr;
            resolutionOptions= new list<selectOption>();

            if(Wid!=null) {
                List<Schema.PicklistEntry> ple = CSS_Job_Order__c.CSS_Resolution__c.getDescribe().getPicklistValues();
                if(ple != null && !ple.isEmpty()){
                    for(Schema.PicklistEntry f : ple){
                        resolutionOptions.add(new SelectOption(f.getLabel(), f.getValue()));
                    }
                }     
                responseValues = new list<CSS_Solutions__c>();
                responseOptions = new List<selectOption>();
                List<Schema.PicklistEntry> pickVal = CSS_Solutions__c.Repair_response__c.getDescribe().getPicklistValues();
                if(pickVal != null && !pickVal.isEmpty()){
                    for(Schema.PicklistEntry values : pickVal){
                        responseOptions.add(new SelectOption(values.getLabel(), values.getValue()));
                    }
                }
            }
            system.debug('Inside close Method');
            list<CSS_Solutions__c> successSols = new List<CSS_Solutions__c>();
            list<CSS_Solutions__c> noSolPostivelyVerified = new list<CSS_Solutions__c>();
            list<css_CampTsbTrp__c> tsbTrpToBePerformed = new list<css_CampTsbTrp__c>();

            System.debug('closeJob campstsbtrps'+closejob.CSS_CampTsbTrp__r);
            for(CSS_CampTsbTrp__c camptsbtrps :closejob.CSS_CampTsbTrp__r) {
                if(camptsbtrps.performed_review__c && !camptsbtrps.performed__c){
                    tsbTrpToBePerformed.add(camptsbtrps);
                    showResolution= FALSE;
                    System.debug('CampTsbTrps'+tsbTrpToBePerformed);
                }
            }
            if(tsbTrpToBePerformed.isEmpty())   {
                System.debug('disd value'+closeJob.DSID__c);

                System.debug('Entered 1st loop');
                System.debug('b4 for iteration'+closeJob.CSS_Solutions__r);
                for(CSS_Solutions__c verfiedSols : closeJob.CSS_Solutions__r){
                    solutionIds.add(verfiedSols.Id);
                    if(verfiedSols.Out_Of_Order__c){
                        outOfOrderSolList.add(verfiedSols);
                        System.debug('out of order list'+outOfOrderSolList);
                    }
                    if( ( verfiedSols.Diagnostic_Response__c != null && 
                         verfiedSols.Diagnostic_Response__c.equalsIgnoreCase('Most Likely the Solution') ) &&
                       verfiedSols.Repair_Response__c!=null && verfiedSols.Repair_Response__c.contains('Successful')) {
                        successSols.add(verfiedSols);
                    }
                }   //end of for loop
                /* code for Update EDS webservice */
                css_accessSrtCompOutTo_Eds updateEDS = new css_accessSrtCompOutTo_Eds(solutionIds,workjob.DSID__c);

                if(workjob.DSID__c!= null && !string.isBlank(workJob.DSID__c)){
                    System.debug('entered if disd loop');
                    //css_accessSrtCompOutToEds updateEDS = new css_accessSrtCompOutToEds(solutionIds,workjob.DSID__c);
                    //updateEDS.accessSRTs();
                    //updateEDS.solComponents();
                    //updateEDS.outOfOrder(outOfOrderSolList);
                    System.debug('exiting if disd loop');
                }//end of If 


                if(!successSols.isEmpty() && bmsUserCloseFlag != true){
                    updateEDS.accessSRTs();
                    updateEDS.solComponents();
                    updateEDS.outOfOrder(outOfOrderSolList);                        
                    updateEDS.insiteFaultCodes(fauCod,workjob.DSID__c);
                    dsidStatus = dscl.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                    if(dsidStatus) {workJob.DSID_Status__c='Closed';} 
                    update workJob;
                    pr = pgSaveFinish();
                } else {
                    System.debug('Entered else loop');                    
                    jobClosePopup();
                    displayClosePopup = true;
                }
            } else {
                System.debug('Entered 4th loop');
                jobClosePopup();
                displayClosePopup = true;
            }
            system.debug('displayClosePopup'+displayClosePopup);
            //updateFailCodeComponents();
            return pr;
        } else{return null;}  
    }
public void jobClosePopup(){

        if (Wid != null)
        { 
            list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();
            responseValues = new List<css_solutions__c>();
            System.debug('Solutions for the entire Job:-->'+workJob.CSS_Solutions__r);
            if(closeJob != null){
                System.debug('Solutions for the entire Job:-->'+closeJob.CSS_Solutions__r);

                if(closeJob.CSS_CampTsbTrp__r == null || closeJob.CSS_CampTsbTrp__r.isEmpty()) {
                    nocamptsbtrps=false;
                    if(closeJob.CSS_Solutions__r == null || closeJob.CSS_Solutions__r.isEmpty()){
                        System.debug('Cond1');
                        showResolution = TRUE;
                        showRepairs = FALSE;
                    }else{
                        List<CSS_Solutions__c> repairSolutions = new List<CSS_Solutions__c>();
                        list<CSS_Solutions__c> noSolPostivelyVerified = new list<CSS_Solutions__c>();

                        System.debug('Solutions for the entire Job:-->'+workJob.CSS_Solutions__r);
                        for(CSS_Solutions__c soluRec : closeJob.CSS_Solutions__r){
                            if(soluRec.Diagnostic_Response__c != null && soluRec.Diagnostic_Response__c.equalsIgnoreCase('Most Likely the Solution')){
                                repairSolutions.add(soluRec);
                            }

                        } System.debug('repairSolutions'+repairSolutions);
                        if( noSolPostivelyVerified.isEmpty()){
                            System.debug('Cond2'+noSolPostivelyVerified);
                            showResolution = TRUE;
                            showRepairs = FALSE;
                            System.debug('Cond2showResolution'+showResolution);
                        }
                        if(repairSolutions.isEmpty()){
                            System.debug('Cond3'+repairSolutions);
                            showResolution = TRUE;
                            showRepairs = FALSE;
                        }else{
                            list<CSS_Solutions__c> noRepairList = new list<CSS_Solutions__c>();
                            for(CSS_Solutions__c solRec:repairSolutions){
                                if(solRec.Repair_Response__c == null){
                                    noRepairList.add(solRec);
                                    responseValues.add(solRec);
                                } else if(solRec.Repair_Response__c.contains('Successful')){
                                    postRepairList.add(solRec);
                                }
                            }

                            if(!noRepairList.isEmpty()){     
                                System.debug('Cond3'+noRepairList);
                                showResolution = FALSE;
                                showRepairs = TRUE;                                                     
                            }

                            if(noRepairList.isEmpty() && postRepairList.isEmpty()){
                                System.debug('Cond4'+noRepairList+''+postRepairList);
                                showResolution = TRUE;
                                showRepairs = FALSE;
                                System.debug('Cond4showResolution'+showResolution);
                            }                        

                        }
                    } }   
                else{
                    nocamptsbtrps= true;
                }            
            }
        }        
    }
    
    public String CoverageDetails;
    public String Correction1;
    public String Cause1;
    public string Comment1;
    public String NonSRTDetails;
   // public boolean editcoverage{get;set;}
    //start
    Public Boolean CauseNotesFlag{get;set;}
    Public Boolean CorrectionNotesFlag{get;set;}
    Public Boolean CoverageNotesFlag{get;set;}
    public Boolean ComplaintNotesFlag{get;set;}
    public Boolean nonSRTNotesFlag{get;set;}
    public Boolean NarrativeWSexception{get;set;}
    public Boolean NarrativeSuccess {get;set;}
     public Boolean Narrativebutton{get;set;}
    //End
     public void sendNarrativeToERP(){
   
         try{
             mainSOQL();
             Narrativebutton=True;
             datetime currentDate = System.now();
             string currDate = currentDate.format('YYYY-MM-dd','GMT')+ 'T' + currentDate.format('HH:mm:ss','GMT');
             system.debug('coverage det'+workJob.Shop_Work_Order__c);
             //WOQT Start
             List<CSS_Quote__c> quoteLst = new List<CSS_Quote__c>();
             quoteLst = [Select id, name, OrderReference__c, Service_Job__c from CSS_Quote__c where Service_Job__c =: Wid order by createdDate desc limit 1];
             system.debug('quoteLst'+quoteLst);
             //system.debug('quoteLst Order'+quoteLst[0].OrderReference__c);
            if(quoteLst.size()>0){
                 if(workJob.Shop_Work_Order__c!='0'&&workJob.Shop_Work_Order__c!=null){
                     //for Coverage
                     if(workJob.EditCoverage__c!='' && workJob.EditCoverage__c!=null){
                         CoverageDetails = workJob.EditCoverage__c.replace('\r\n','\\n') ;
                         CoverageDetails = CoverageDetails.replace('\n','\\n') ;
                         CoverageNotesFlag = false;
                         system.debug('CoverageDetails'+ CoverageDetails);
                         system.debug('CoverageNotesFlag'+ ' ' + CoverageNotesFlag);
                     }else{
                         CoverageDetails = ' ';
                         CoverageNotesFlag = true;
                          system.debug('CoverageDetails'+ CoverageDetails);
                         system.debug('CoverageNotesFlag'+ ' ' + CoverageNotesFlag);
                     }
                            
                     
                    CSS_WOCommentInboundJson2Apex woCommentResWOQTCov = CSS_WS_BMS.callWOCommentInboundService(workJob.Creator_Location__c, workJob.Name,'WOQT',
                                                                                                         quoteLst[0].OrderReference__c, 'COVERAGE',CoverageDetails,(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                                                                                                         (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                                                                                                         currDate,currDate); 
                      //4 Lines Commented by Gyan as per Story 148450
                      //CSS_WOCommentInboundJson2Apex woCommentResWoCov = CSS_WS_BMS.callWOCommentInboundService(workJob.Creator_Location__c, workJob.Name,'WO',
                      //                                                                               workJob.Shop_Work_Order__c, 'COVERAGE',CoverageDetails,(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                      //                                                                               (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                      //                                                                               currDate,currDate);

                     //for Complaint
                     if(workJob.EditComplaint__c!='' && workJob.EditComplaint__c!=null){
                         Comment1 = workJob.EditComplaint__c.replace('\n', '');
                         Comment1= Comment1.replace('\r', '\\n');
                         ComplaintNotesFlag = false;
                     }else{
                         Comment1 = ' ';
                         ComplaintNotesFlag = true;
                     }
                     CSS_WOCommentInboundJson2Apex woCommentResWOQTCom = CSS_WS_BMS.callWOCommentInboundService(workJob.Creator_Location__c,workJob.Name,'WOQT', 
                                                                                                          quoteLst[0].OrderReference__c, 'COMPLAINT' , Comment1,(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                                                                                                          (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                                                                                                          currDate,currDate);
                     //4 Lines Commented by Gyan as per Story 148450
                      //CSS_WOCommentInboundJson2Apex woCommentResWOCom = CSS_WS_BMS.callWOCommentInboundService(workJob.Creator_Location__c,workJob.Name,'WO', 
                      //                                                                                workJob.Shop_Work_Order__c, 'COMPLAINT' , Comment1,(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                      //                                                                                (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                      //                                                                                currDate,currDate);

                     system.debug('workJob.Creator_Location__c >>>>>>'+workJob.Creator_Location__c);
                     //for Correction
                     if(workJob.EditCorrection__c!=null && workJob.EditCorrection__c != ''){
                         Correction1 = workJob.EditCorrection__c.replace('\r\n','\\n');
                         Correction1 = Correction1.replace('\n','\\n');
                         CorrectionNotesFlag = false;
                     }else{
                         Correction1 = ' ';
                         CorrectionNotesFlag = true;
                     }
                     CSS_WOCommentInboundJson2Apex woCommentResWOQTCorr = CSS_WS_BMS.callWOCommentInboundService(workJob.Creator_Location__c, workJob.Name,'WOQT',quoteLst[0].OrderReference__c,'CORRECTION', Correction1,(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                                                                                                          (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                                                                                                          currDate,currDate); 
                     //4 Lines Commented by Gyan as per Story 148450
                     //CSS_WOCommentInboundJson2Apex woCommentResWoCorr = CSS_WS_BMS.callWOCommentInboundService(workJob.Creator_Location__c, workJob.Name,'WO',workJob.Shop_Work_Order__c,'CORRECTION', Correction1,(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                     //                                                                                 (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                     //                                                                                currDate,currDate);
                     
                     //for Cause
                     if(workJob.EditCause__c!=null && workJob.EditCause__c != ''){
                         Cause1 = workJob.EditCause__c.replace('\r\n','\\n');
                         Cause1 = Cause1.replace('\n', '\\n');
                         CauseNotesFlag = false;
                     }else{
                         Cause1 = ' ';
                         CauseNotesFlag = true;
                     }        
                     CSS_WOCommentInboundJson2Apex woCommentResWOQTCause = CSS_WS_BMS.callWOCommentInboundService(workJob.Creator_Location__c, workJob.Name,'WOQT',quoteLst[0].OrderReference__c,'CAUSE',Cause1,(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                                                                                                          (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                                                                                                          currDate,currDate); 
                     //3 Lines Commented by Gyan as per Story 148450
                     //CSS_WOCommentInboundJson2Apex woCommentResWoCause = CSS_WS_BMS.callWOCommentInboundService(workJob.Creator_Location__c, workJob.Name,'WO',workJob.Shop_Work_Order__c,'CAUSE',Cause1,(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                     //                                                                                 (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                     //                                                                                 currDate,currDate);
                     
                     //for Non SRT Details
                     if(workJob.Non_SRT_Details__c!=null && workJob.Non_SRT_Details__c != ''){
                         NonSRTDetails = workJob.Non_SRT_Details__c.replace('\r\n','\\n');
                         NonSRTDetails = NonSRTDetails.replace('\n', '\\n');
                         nonSRTNotesFlag = false;
                     }else{
                         NonSRTDetails = ' ';
                         nonSRTNotesFlag = true;
                     }        
                     CSS_WOCommentInboundJson2Apex woCommentResWOQTNonSRT = CSS_WS_BMS.callWOCommentInboundService(workJob.Creator_Location__c, workJob.Name,'WOQT',quoteLst[0].OrderReference__c,'SRO',NonSRTDetails,(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                                                                                                          (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                      currDate,currDate);
                      //3 Lines Commented by Gyan as per Story 148450                                                                                     
                      // CSS_WOCommentInboundJson2Apex woCommentResWOSRT = CSS_WS_BMS.callWOCommentInboundService(workJob.Creator_Location__c, workJob.Name,'WO',workJob.Shop_Work_Order__c,'SRO',NonSRTDetails,(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                      //                                                                                (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
                      //                                                                                currDate,currDate);
                     NarrativeWSexception = false;
                     NarrativeSuccess = true;
                     Narrativebutton=false;

                 
             }  
             
           }
         }
         catch(Exception ex){
             NarrativeWSexception = true;
             NarrativeSuccess = false;
             Narrativebutton=false;
             System.debug('in catch of SendNarratives to BMS >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
         }
         //PageReference ReturnPage = new pageReference('/apex/CSS_JobPlanNarrative?id='+Wid);
       // ReturnPage.setRedirect(true);
        //return ReturnPage;
     }
     public void saveComplaint(){
        integer compare;
         
        css_job_order__c worecord= new css_job_order__c();
        worecord.EditComplaint__c=workJob.EditComplaint__c;  
        System.Debug('value of EditComplaint===='+workJob.EditComplaint__c);
        worecord.id=workJob.id;
        update worecord;
        System.Debug('record updated====='+worecord);
         checkNarrativeForERP();

    }
  
    
    
    public void saveCorrection(){
        css_job_order__c worecord= new css_job_order__c();
        
        worecord.EditCorrection__c=workJob.EditCorrection__c;  
        System.Debug('value of EditComplaint===='+workJob.EditComplaint__c);
        worecord.id=workJob.id;
        update worecord;
        System.Debug('record updated====='+worecord);
        checkNarrativeForERP();

    }
    public void saveCause(){
        css_job_order__c worecord= new css_job_order__c();
        worecord.EditCause__c=workJob.EditCause__c;  
        System.Debug('value of EditCause===='+workJob.EditCause__c);
        worecord.id=workJob.id;
        update worecord;
        System.Debug('record updated====='+worecord);
        checkNarrativeForERP();
    }
    public void saveCoverage(){
        css_job_order__c worecord= new css_job_order__c();
        worecord.EditCoverage__c = workJob.EditCoverage__c;  
        System.Debug('value of EditComplaint===='+workJob.EditComplaint__c);
        worecord.id=workJob.id;
        update worecord;
        System.Debug('record updated====='+worecord);
        checkNarrativeForERP();

    }
    public void saveNonSRTDetails(){
        css_job_order__c worecord= new css_job_order__c();
        worecord.Non_SRT_Details__c = workJob.Non_SRT_Details__c;  
        System.Debug('value of NonSRTDetails===='+workJob.Non_SRT_Details__c);
        worecord.id=workJob.id;
        update worecord;
        System.Debug('record updated====='+worecord);
        checkNarrativeForERP();

    }
    
    public void checkNarrativeForERP(){
        
     mainSOQL();
        if((workJob.EditComplaint__c!=null) || (workJob.EditCoverage__c!=null) || (workJob.EditCause__c!=null) || (workJob.EditCorrection__c!=null) || (workJob.Non_SRT_Details__c!=null)){
            sendNarratives = true;
            
        }
        else
            sendNarratives = false;
        CoverageNotesFlag = false;
        ComplaintNotesFlag = false;
        CorrectionNotesFlag = false;
        CauseNotesFlag = false;
        nonSRTNotesFlag = false;
        
    }    
    public void showPopup(){
        displayPopup = true;        
    }
     public PageReference redirectPopup()
    {    
        displayPopup = false;
        PageReference p=new Pagereference('/apex/CSS_Job_Detail?nto=HOME');
        p.setRedirect(true);
        return p;
    } 
     public void Cancel()
    {   
        css_job_order__c worecord= new css_job_order__c();
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        if (ChkFieldBlank() =='BLANK')
        {
            /*PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME');
            pageRef.setRedirect(true);
            return pageRef;*/
        }
        else
        {
            System.Debug('inside cancel');  

            //  CSS_JobOrderWrapper wrap = new CSS_JobOrderWrapper(workJob,filterMake,filterModel,mil_measure,fail_measure);
            //   worecord = wrap.worecord;
            //worecord.Location_Certification__c=workjob.Location_Certification__c;
            worecord.Status__c='Canceled';
            worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;
            // Defect fix 59457
            //saveCheckBox();
            if (Wid == null)
            {
                System.Debug('inside CancelNull');
                worecord.jobLocation__c=jobLocation;
                insert worecord;
                Wid = worecord.id;
                /*PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME');
                pageRef.setRedirect(true);
                return pageRef;*/
                cancelSJWrapperObj1.errorFlag = false;
                cancelSJWrapperObj1.errorMessage = '';
                cancelSJWrapperObj1.serviceJob = worecord;
            }
            else
            {
                System.Debug('value of customer===='+workJob.customer_name__c);
                /*worecord.id=workJob.id;
                update worecord;
                System.Debug('inside CancelBlank====='+worecord);
                PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
                pageRef.setRedirect(true);
                return pageRef;*/
                system.debug('insideelseNoSWO');
                if(workJob.Account__r.ERP_System__c == 'One BMS'){
                    cancelSJWrapperObj1 = CG_BL_Intake.cancel(workJob,worecord);
                    //Defect Fix 151641
                     if(cancelSJWrapperObj1!=null && cancelSJWrapperObj1.errorFlag == false){
                       system.debug('**noerrors');
                       worecord.id=workJob.id;
                       Update worecord; 
                    }
                }
                else{
                    worecord.id=workJob.id;
                    update worecord;
                    cancelSJWrapperObj1.errorFlag = false;
                    cancelSJWrapperObj1.errorMessage = '';
                    cancelSJWrapperObj1.serviceJob = worecord;
                }
                
                //Wid = cancelSJWrapperObj1.serviceJob.id;
                system.debug('cancelSJWrapperObj1.serviceJob.id'+cancelSJWrapperObj1.serviceJob.id);
            }
            saveCheckBox();
        }

}
      public PageReference jobplan_prt()
    {
        System.debug('hello');
        updatestatus();
        css_job_order__c worecord= new css_job_order__c();
        showJobPlanBlocks(false,false,false,true,false,false,false);
        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        else
        {

            worecord.chevron_page__c = 'prt';
            worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;
            if (Wid != null)
            {
                System.Debug('value of customer===='+workJob.customer_name__c);
                worecord.id=workJob.id;
                update worecord;
                System.Debug('record updated====='+worecord);
                //updateFailCodeComponents();
                //   return null;
            }
        } 


        PageReference pageRef = new pageReference('/apex/CSS_JobPlanParts?id='+wid); 
        pageRef.setRedirect(true);
        return pageRef;
    }
     public PageReference jobplan_war()
    {
        css_job_order__c worecord= new css_job_order__c();
        showJobPlanBlocks(false,false,false,false,true,false,false); 

        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        else
        {

            worecord.chevron_page__c = 'war';
            worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;

            if (Wid != null)
            {
                System.Debug('value of customer===='+workJob.customer_name__c);
                worecord.id=workJob.id;
                update worecord;
                System.Debug('record updated====='+worecord);
                //updateFailCodeComponents();
                //   return null;
            }
        } 
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanWarranty?id='+worecord.id); 
        pageRef.setRedirect(true);
        return pageRef;
    }
     public PageReference jobplan_srt()
    {
        css_job_order__c worecord= new css_job_order__c();
        showJobPlanBlocks(false,false,true,false,false,false,false);
        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        else
        {

            worecord.chevron_page__c = 'srt';
            worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;

            if (Wid != null)
            {
                //  System.Debug('value of customer===='+workJob.customer_name__c);
                worecord.id=workJob.id;
                update worecord;
                //  System.Debug('record updated====='+worecord);
                //updateFailCodeComponents();
            }
        } 
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanSRT?id='+worecord.id); 
        pageRef.setRedirect(true);
        return pageRef;
    }
     public PageReference jobplan_jo()
    {
        css_job_order__c worecord= new css_job_order__c();
        showJobPlanBlocks(true,false,false,false,false,false,true);

        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        else
        {

            worecord.chevron_page__c = 'jo';
            worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;

            if (Wid != null)
            {
                worecord.id=workJob.id;
                update worecord;

            }
        }
        PageReference pageRef = new pageReference('/apex/CSS_JobPlan?id='+worecord.id); 
        pageRef.setRedirect(true);
        return pageRef;

    }
 public void updatestatus(){
        system.debug('inside the method after page load');
        /*---KALPANA---*///parts();
        if(workJob.status__c!='Job Plan' && workJob.status__c!='Repair'){
            workJob.Previous_Status__c=workJob.Status__c;
            workJob.status__c='Job Plan';
            system.debug('inside the method after page load&&&&&&&&&');

            update  workJob; 
            //TO Fetch Warranty Dertails


        }
    }
     public boolean showRepairErrorMessage{get;set;}
    list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();
    public boolean showResolutionWithRepair{get;set;}
    public Boolean requiredBMSMessage {get;set;}
public PageReference saveAndCloseJob()
        //void to  PageReference switch is done by  Roopa defect number 178147
    {
        // if(dsidIndi != null && dsidIndi.containsIgnoreCase('O'))
        if (Wid != null)
        {
            requiredBMSMessage =false;
            showResolutionRequired =false;//ROD Defect 179167 Added by Rajesh Narra                                    
            showResolutionWithRepair = false;//ROD Defect 179167 Added by Rajesh Narra                        
            showRepairRequired = false;//ROD Defect 179167 Added by Rajesh Narra 
            if ((bmsEnabled ==true)&&(workJob.Customer_Code__c==null || workJob.Unit_Number__c==null || workJob.Shop_Work_Order__c==null)){
                requiredBMSMessage = TRUE;
                System.debug('Entered error');            
                //return null;
            }
            css_accessSrtCompOutTo_Eds updateEDS = new css_accessSrtCompOutTo_Eds(solutionIds,workjob.DSID__c);
            //system.debug('checkingownerornot----->'+dsidIndi);
            System.debug('Entered Pg SaveFinish MEthod');
            css_dsidclose dscl = new css_dsidclose();
            //PageReference pageRef;
            System.debug('41');
            if(showRepairs  && !showResolutionWithRepair){
                System.debug('42');
                list<CSS_Solutions__c> negatRepairs = new list<CSS_Solutions__c>();
                List<CSS_Solutions__c> negatPosRepairs = new List<CSS_Solutions__c>();
                System.debug('43');
                if(!responseValues.isEmpty()){
                    System.debug('44');
                    for(CSS_Solutions__c solRec : responseValues){
                        System.debug('45');
                       
                        if(!String.isBlank(solRec.Repair_Response__c) && !solRec.Repair_Response__c.contains('Successful')){
                            System.debug('46');
                            System.debug('Entered neg if Loop:');
                            negatRepairs.add(solRec);
                            System.debug('47');
                        }else if(solRec.Repair_Response__c != null && solRec.Repair_Response__c.contains('Successful')){
                            negatPosRepairs.add(solRec);
                        }else if(solRec.Repair_Response__c == null){
                            System.debug('48');
                            //showRepairErrorMessage = TRUE; ROD Defect 179167 Added by Rajesh Narra 
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please select repair response for the below solutions'));
                            //return null;
                        }
                    }//end of For
                    System.debug('B4 MEthod'+negatRepairs+' '+responseValues+''+negatRepairs.size()+' '+responseValues.size());
                    
                    if(negatRepairs.isEmpty() && negatPosRepairs.isEmpty()){
                        showRepairRequired = false;//ROD Defect 179167 Added by Rajesh Narra 
                        showRepairErrorMessage = True;
                        cancelSJWrapperObj1.errorFlag=true;//ROD Defect 179167 Added by Rajesh Narra 
                    }else if(!negatRepairs.isEmpty() && !responseValues.isEmpty() && negatRepairs.size() == responseValues.size() && workJob.CSS_Resolution__c == null){
                        showRepairRequired = true;///ROD Defect 179167 Added by Rajesh Narra 
                        showRepairErrorMessage = false;
                        cancelSJWrapperObj1.errorFlag=true;//ROD Defect 179167 Added by Rajesh Narra 
                        showResolutionWithRepair=true;//ROD Defect 179167 Added by Rajesh Narra 
                    }else if(!negatPosRepairs.isEmpty() && !responseValues.isEmpty() && negatPosRepairs.size() != responseValues.size() && workJob.CSS_Resolution__c == null){
                        showRepairRequired = true;//ROD Defect 179167 Added by Rajesh Narra 
                        showRepairErrorMessage = false;
                        cancelSJWrapperObj1.errorFlag=true;//ROD Defect 179167 Added by Rajesh Narra 
                        showResolutionWithRepair=true;//ROD Defect 179167 Added by Rajesh Narra 
                    }else{
                        System.debug('50');
                        System.debug('Entered else Loop with repairs:');
                        
                        showResolutionWithRepair = FALSE;
                        if(requiredBMSMessage == TRUE){
                           showRepairErrorMessage = FALSE;
                         }
                        cancelSJWrapperObj1.errorFlag=false;//ROD Defect 179167 Added by Rajesh Narra 
                        workJob.Status__c='Closed';
                        System.debug('51');
                        updateEDS.accessSRTs();
                        updateEDS.solComponents();
                        updateEDS.outOfOrder(outOfOrderSolList);
                        updateEDS.insiteFaultCodes(fauCod,workjob.DSID__c);
                        dsidStatus = dscl.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                        if(dsidStatus) {
                            workJob.DSID_Status__c='Closed';
                        }                         
                        if(workJob.Account__r.ERP_System__c=='One BMS'){
                            cancelSJWrapperObj1 = CG_BL_Intake.closeServiceJob(workJob);
                             if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == true){
                                
                            }
                            else if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == false){
                                system.debug('**noerrors');
                                update workJob;
                            }
                        }
                        else{
                            if(requiredBMSMessage == false)//ROD Defect 179167 Added by Rajesh Narra 
                                update workJob;
                        }
                        if(!responseValues.isEmpty() && requiredBMSMessage == false){ //ROD Defect 179167 Added by Rajesh Narra 
                            update responseValues;
                        }
                        if(requiredBMSMessage == false){
                            cancelSJWrapperObj1.errorFlag=false;// Added by Rajesh Narra
                            pageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); // This code is uncommented by Roopa  178147
                            pageRef.setRedirect(true);// This code is uncommented by Roopa  178147
                        }else{
                           if(requiredBMSMessage == TRUE)
                                showRepairErrorMessage = TRUE;
                            cancelSJWrapperObj1.errorFlag=true;
                        }               
                    }
                }
            }//end of If repairs
         
            if(!postRepairList.isEmpty()){
                System.debug('52');
                showResolution = false;
                showRepairs = false;
                if(!showResolutionWithRepair || !showResolution){
                    if(workJob.CSS_Resolution__c != null){ 
                        System.debug('53');
                        workJob.Status__c='Closed';
                        updateEDS.accessSRTs();
                        updateEDS.solComponents();
                        updateEDS.outOfOrder(outOfOrderSolList);
                        updateEDS.insiteFaultCodes(fauCod,workjob.DSID__c);
                        dsidStatus = dscl.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                        if(dsidStatus) {
                            workJob.DSID_Status__c='Closed';
                        } 
                        if(workJob.Account__r.ERP_System__c=='One BMS'){
                            cancelSJWrapperObj1 = CG_BL_Intake.closeServiceJob(workJob);
                            if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == true){
                                
                            }
                           else if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == false){
                                system.debug('**noerrors');
                                update workJob;
                            }
                        }
                        else{
                           update workJob; 
                        }                        
                        if(!responseValues.isEmpty()){
                            System.debug('54');
                            update responseValues;
                        } 
                        pageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); // This code is uncommented by Roopa  178147
                        pageRef.setRedirect(true);// This code is uncommented by Roopa  178147
                    }
                }    
            }
            
            if(showResolutionWithRepair || showResolution){
                System.debug('55');
                if(workJob.CSS_Resolution__c != null){     
                    System.debug('56');
                    workJob.Status__c='Closed';
                    updateEDS.insiteFaultCodes(fauCod,workjob.DSID__c);
                    updateEDS.accessSRTs();
                    updateEDS.solComponents();
                    updateEDS.outOfOrder(outOfOrderSolList);
                    dsidStatus = dscl.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                    System.debug('57');
                    if(dsidStatus) {
                        workJob.DSID_Status__c='Closed';                        
                    } 
                    if(workJob.Account__r.ERP_System__c=='One BMS'){
                        cancelSJWrapperObj1 = CG_BL_Intake.closeServiceJob(workJob);
                        if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == true){
                                
                            }
                       else if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == false){
                            system.debug('**noerrors');
                            update workJob;
                        }
                    }
                    else{
                        if(requiredBMSMessage == false)//ROD Defect 179167 Added by Rajesh Narra 
                        update workJob;    
                    }                    
                    if(!responseValues.isEmpty() && requiredBMSMessage == false){//ROD Defect 179167 Added by Rajesh Narra 
                        System.debug('58');
                        update responseValues;
                    }
                    if(requiredBMSMessage == false){
                        cancelSJWrapperObj1.errorFlag=false;//ROD Defect 179167 Added by Rajesh Narra 
                        pageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); // This code is uncommented by Roopa  178147
                        pageRef.setRedirect(true);// This code is uncommented by Roopa  178147
                    }else{
                        cancelSJWrapperObj1.errorFlag=true;
                    }
                }else{
                    showResolutionRequired=true;//ROD Defect 179167 Added by Rajesh Narra                     
                    cancelSJWrapperObj1.errorFlag=true;//ROD Defect 179167 Added by Rajesh Narra 
                }
            }    
            
            System.Debug('record updated====='+workJob);            
             return null;
            //return pageRef;// This code is uncommented by Roopa  178147
        }
        else{ 
            return null; // This code is uncommented by Roopa  178147
        }   
    }   
    

}