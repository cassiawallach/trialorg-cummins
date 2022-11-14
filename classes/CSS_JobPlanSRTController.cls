/**********************************************************************
Name:CSS_JobPlanSRTController
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
We are using this Page Controller for Jobplan SRTs Chevron.
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.1 -      Surender M        08/09/2018            Overlap/Mutual/Extended Hours/Duplicate SRTs logic
***********************************************************************/
public  class CSS_JobPlanSRTController {

    public CSS_JobPlanSRTController controllerRef{set;get;}
    public string workjobStatus;
    public Integer complaintcounter{set;get;}
    public Integer coveragecounter{set;get;}
    public Integer causecounter{set;get;}
    public Integer correctioncounter{set;get;}
    public boolean accQuoteFlag{set; get;} 
    public string NotesBody {get;set;} 
    public id recTypeIdpart ;
    public list<CSS_Parts_Options__c> sendparts;
    public list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();

    public CG_cancelServiceJobWrapper cancelSJWrapperObj1{get;set;}
    //public list<string> faultList {get; set;}
    //public list<string> partlist {get; set;}
    //public list<string> partlistFAULT {get; set;}
    public CSS_unitInboundJSON2Apex UIResp{get;set;}
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
    public Boolean requiredBMSMessage {get;set;}
    public boolean showResolutionWithRepair{get;set;}
    public boolean showRepairErrorMessage{get;set;}
    //list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();
    CSS_OverlapSRTReq overlapSRTREq;
    public map<string,CSS_SRT__c> mapStepIdtoSrt;
    public CSS_Job_Order__c serviceJob{get; set;}
    public integer timemin{set;get;}
    public integer timeminov{set;get;}
    public Double TotalOverlapHours{set;get;}
    public Double TotalAdjustedHours{set;get;}
    public String overlapErrorMsg{set;get;}
    public list<overLapSrtWrapper> lstOverLapSrt{get;set;}
    public set<string> setSRTCode;
    public List<CSS_SRT__c> lstExistingOverlapSrt;
    public List<CSS_SRT__c> lstSendToERPSRTs;
    map<string,CSS_SRT__C> mapSRTcodetoSRT = new map<string,CSS_SRT__C>();
    public boolean showErrorBMS{get;set;}
    public String BMSErrorMsg{set;get;}
    public boolean showSucessBMS{get;set;}
    public String BMSSuccessMsg{set;get;}
    public String BMSSuccessWOQTMsg{set;get;}
    public boolean displaySRTButton{get;set;}
    public boolean displaySRTButtonDist{get;set;}
    public boolean displaySendERP_Button{get;set;}
    public list<CSS_JobEventTemporary__c> JETFA{get;set;}
    public transient   Map<String,CSS_JobEventTemporary__c> accCodeMapJET = new Map<String,CSS_JobEventTemporary__c>();// Transient is added by Vamshi and Rajesh to fix blue scree.
    public  CSS_Job_Order__c JobTotalSRTHrs {get;set;}
    public Boolean isDealer {get;set;}
    List<String> dupSRTMsg = new List<String>();
    public User usr{get;set;}
    public List<CSS_UserLocation__c> usrLocRec;
     public Boolean showResolutionRequired{get;set;}//ROD Defect 179167 Added by Rajesh Narra 
    public Boolean showRepairRequired {get;set;}//ROD Defect 179167 Added by Rajesh Narra
    public void mainSOQL(){
        workJob=[Select Id,PACCAR_Auth_Required__c,Name,Quote_ID__c,CSS_In_Shop_Labor_Rate__c,Account__c,ProductApplicationCode__c,AccessCode__c,Account__r.ERP_System__c,BMSWSStatus__c,BMSStatus__c,Customer_Name__c,Cstmr_Contacts_Phone__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                 Repair_Location__c,Failure_Date__c, Failure_Point__c,SP_WarrantyCertificationEndDate__c, Failure_Point_Measure__c, Service_Model__c,CSS_Hours__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                 DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,EditComplaint__c,EditCorrection__c,EditCoverage__c,EditCause__c,
                 Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Category_Desc__c, Complaint_Type__c, Complaint_Type_Desc__c, Model__c,Creator_Location__c, Control_Number__c,Equipment_ID__c,DupAccessCodePercentReqMsg__c,
                 Assigned_to__r.Name,account__r.RSS_RESP_BRANCH_CODE__c,SP_Country__c,EngineFamilyName__c,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c, CSS_Job_Location_Code__c, CSS_Resolution__c,CSS_Feedback_Comments__c,
                 Mutual_Exclusive_Message__c, ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, DuplicateSRTDetails__c,LastModifiedDate,CreatedDate,ESN_Locked__c,Actual_Technician_Time__c,ApplicationCode__c,Automotive_App_Flag__c,TotalSRTExtendedHours__c
                 from CSS_Job_Order__c where id= :Wid];
        system.debug('workJob'+workJob);
        system.debug('ERP System'+workJob.Account__r.ERP_System__c);
    }

    public CSS_JobPlanSRTController() {
        controllerRef = this;
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        workjobStatus=ApexPages.CurrentPage().getParameters().get('status');
        usr = css_utility.getUserAttributes(UserInfo.getUserId());
        showResolutionRequired = false;//Added by Rajesh Narra
        showRepairRequired = false;//Added by Rajesh Narra
        //displaySRTButton = css_utility.getclaimsapprove(UserInfo.getUserId());
        showErrorBMS = false;
        BMSErrorMsg = '';
        BMSSuccessMsg = '';
        showSucessBMS = false;
        JETFA = new list<CSS_JobEventTemporary__c>();
        JETFA = [select id,Attribute1__c,Attribute2__c,Attribute3__c,key__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes'];
        system.debug('JETFA***' + JETFA);
        for(CSS_JobEventTemporary__c jet : JETFA){
            string temp = jet.Attribute2__c+jet.Attribute3__c; 
            if(!accCodeMapJET.containskey(temp))
                accCodeMapJET.put(temp,jet);
        }

        //string partsUr = ApexPages.CurrentPage().getParameters().get('joPa');
        try {
            mainSOQL();          
            system.debug('TotalSRTExtendedHours__c '+workJob.TotalSRTExtendedHours__c);
            system.debug('***ref '+workJob.Shop_Work_Order__c);
            css_header_nav__c CS = css_header_nav__c.getInstance(UserInfo.getProfileId()); 

            string userId = UserInfo.getUserId();
            system.debug('userId*****'+userId);

            //bmsEnabled=css_utility.getBMSEnabled(userId);
            //Modified as per story# 76192
            //bmsEnabled=css_utility.getBMSEnabled(workJob.Creator_Location__c);

            usrLocRec =[select Id, name, Location_code__c, Enable_Claim__c,isActive__c from CSS_UserLocation__c where UserId__c=:userInfo.getUserId() and Enable_Claim__c = true and isActive__c = true AND Location_Source__c != 'ARF' and Location_code__c = : workJob.Creator_Location__c limit 1];
            if(usrLocRec != null && usrLocRec.size() > 0 && usrLocRec[0].Enable_Claim__c == true && usrLocRec[0].isActive__c == true){
                displaySRTButton = true;
            }

            String orgtype=css_utility.getOrgType(userinfo.getUserId());
            if(orgtype == 'DISTR'){
                displaySRTButtonDist = false;    
            }
            else {
                displaySRTButtonDist = true;   
            }
            if(orgtype == 'DLR'){
                isDealer = true;
            }
            else{
                isDealer = false;
            }

            if(!usr.profile.name.contains('Technician') && usrLocRec != null && usrLocRec.size() > 0 && usrLocRec[0].Enable_Claim__c == true && usrLocRec[0].isActive__c == true){
                displaySendERP_Button = true;
            }
            system.debug('displaySendERP_Button-->'+displaySendERP_Button);
            //system.debug('bmsEnabled - Intake'+bmsEnabled);

            //if(workJob.chevron_page__c == 'srt')
            showJobPlanBlocks(false,true,false,false, false,false,false); 

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


        }
        catch(Exception e)  {
        }
    }  

    public ID Wid; 
    public css_job_order__c workJob {get;set;}
    //public boolean bmsEnabled {get;set;}

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
        if (srt_stat)
        {
            jo_btn_cls = 'chev_jpo_img_open';
            srt_btn_cls = 'chev_jpsrt_img_active';
            prt_btn_cls = 'chev_jpparts_img_open';
            war_btn_cls = 'chev_wr_img_open';
            nar_btn_cls = 'chev_jpnarrative_img_open';
            qt_btn_cls = 'chev_jpquote_img_open'; 

            jo_chv_sts = 'sopen';
            srt_chv_sts = 'sactive';
            prt_chv_sts = 'sopen';
            war_chv_sts = 'sopen';
            nar_chv_sts = 'sopen';
            qt_chv_sts = 'sopen';

            jo_txt_sts =  'chev_text_open';
            srt_txt_sts =  'chev_text_active';
            prt_txt_sts =  'chev_text_open';
            war_txt_sts =  'chev_text_open';
            nar_txt_sts =  'chev_text_open';
            qt_txt_sts =  'chev_text_open';

            jo_txt_val = '';
            srt_txt_val = 'Narrative';//Check
            prt_txt_val = '';
            war_txt_val = '';
            nar_txt_val = '';
            qt_txt_val = '';
        }
    }

    /*********End Method for Chevrons Initialization *****/

    // Method to activate Srt Cheveron 
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
        PageReference pageRef = new pageReference('/apex/CSS_JobPlan?id='+worecord.id); 
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

    public void onChangeOfUnitNumber(){
        /*** On Tab of Unit Number in Job Plan call Unit Inbound ******/
        callUnitInboundGeneric();
        if(workjob != null){
            update workjob;
        }  
    }
    public void updateservjob(){
        system.debug('--do--');
        if(workjob != null){
            update workjob;
        }  

    }
    /******* Call Unit Inbound Generic Method *******/
    public void callUnitInboundGeneric(){
        system.debug('UnitNumber>>>>>'+workJob.Unit_Number__c);
        system.debug('BMSStatus>>>>>>'+workJob.BMSStatus__c);
        if(workJob.Unit_Number__c !=null && !workJob.BMSStatus__c.contains('UI0')){
            //Modified as per story# 64030    
            //string applicationCode = css_utility.getCodes('Application Code',workJob.Application__c,null,null);
            string applicationCode = css_utility.getCodes('Application Code',workJob.Application_Desc__c,null,null);
            String FailureDateForUnitInbound;
            if(workJob.Failure_Date__c != null){
                datetime FailureDt = workJob.Failure_Date__c;
                FailureDateForUnitInbound = FailureDt.format('dd-MMM-YYYY','GMT') + ' ' + '13:00:00';
            }
            String WarrantyStartDateforUnitInbound;
            if(workJob.Warranty_Start_Date__c != null){
                datetime WrntyDt = workJob.Warranty_Start_Date__c;
                WarrantyStartDateforUnitInbound = WrntyDt.format('dd-MMM-YYYY','GMT');
            }
            //Call the Unit Inbound Service
            UIResp = new CSS_unitInboundJSON2Apex();
            //making a call to update the details
            UIResp = CSS_WS_BMS.callUnitInbound(workJob.Customer_Code__c,workJob.Unit_Number__c,workJob.Unit_Type__c,workJob.Model__c,workJob.VIN__c,workJob.Make__c,workJob.Service_Model__c,workJob.ESN__c,workJob.Qsol_Engine_Family_Code__c,applicationCode,workJob.Creator_Location__c,workJob.Mileage_Measure__c,string.valueof(workJob.Mileage__c),string.valueof(workJob.CSS_Hours__c),(FailureDateForUnitInbound == null ? '' : FailureDateForUnitInbound),(WarrantyStartDateforUnitInbound == null ? '' : WarrantyStartDateforUnitInbound),workJob.AccessCode__c);
            system.debug('UIResp>>>>>>>>'+UIResp);

            workJob.Unit_Number__c= UIResp.DataArea.UnitNumber;
            if(UIResp.DataArea !=null && UIResp.Header!=null && UIResp.Header.Status!=null && UIResp.Header.Status=='SUCCESS' && UIResp.DataArea.UnitNumber != null && UIResp.DataArea.UnitNumber.trim() != '')
            {
                if(workJob.BMSStatus__c !=null && workJob.BMSStatus__c.trim() !=''){
                    workJob.BMSStatus__c = workJob.BMSStatus__c + ','+'UI0';
                }else {
                    workJob.BMSStatus__c = 'UI0';
                }
                system.debug('BMSStatus__c+++++++++++++'+workJob.BMSStatus__c);
            }

        }
    }
    /******* End Call Unit Inbound Generic Method ****/
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
            //Defect Fix - 75783
            worecord.Status__c='Job Plan';
            // Defect fix 59457
            saveCheckBox();
            if (Wid == null)
            {
                worecord.jobLocation__c=jobLocation;
                insert worecord;
                Wid = worecord.id;
                /*---KALPANA---**/ //updateFailCodeComponents();
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
                /*---KALPANA---**/ //updateFailCodeComponents(); 
                return null;
            }
        }
    }
    public void closeSession_close()
    {
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        cancelSJWrapperObj1.errorFlag = false;
        cancelSJWrapperObj1.errorMessage = '';
        cancelSJWrapperObj1.serviceJob = workJob;
        displayClosePopup=false;
    }
    public PageReference closeSession(){
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        cancelSJWrapperObj1.errorFlag = false;
        cancelSJWrapperObj1.errorMessage = '';
        cancelSJWrapperObj1.serviceJob = workJob;
        CSS_EDSAuthentication.getEDSUpdateTnR(workJob.DSID__c, usr.FederationIdentifier, workJob.Customer_Name__c, workJob.Make__c, workJob.Model__c, workJob.AccessCode__c, workJob.Equipment_ID__c, workJob.Failure_Point__c, workJob.Failure_Point_Measure__c, workJob.Unit_Number__c,workJob.ESN__c,workJob.Shop_Work_Order__c);
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

            //countquote = 0;
            AggregateResult[] quoteAgg;
            quoteAgg = [Select count(Id) countquote from CSS_Quote__c where Service_Job__c =:Wid ];
            //countquote = integer.valueOf(quoteAgg[0].get('countquote'));
            // System.Debug('>>>>>countquote '+countquote);
            //Fixed for non bms user
            if ((workJob.Account__r.ERP_System__c == 'BMS Legacy' || workJob.Account__r.ERP_System__c == 'One BMS') && (workJob.Customer_Code__c == null || workJob.Unit_Number__c== null || workJob.Shop_Work_Order__c == null || countquote==0)){
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
    /* Popup Code */
    public void showPopup(){
        displayPopup = true;        
    }
    public void closePopup() {
        displayPopup = false;
    }    

    public PageReference redirectPopup()
    {    
        displayPopup = false;
        PageReference p=new Pagereference('/apex/CSS_Job_Detail?nto=HOME');
        p.setRedirect(true);
        return p;
    } 

    //82020- Story87378 Reminder when canceling a job - Krishna on 19-06-2017.
    public Boolean displaycancelModPopup {get;set;}

    public void showcancelpopup(){
        displaycancelModPopup = true;
    }

    public void cancelModPopup(){
        displaycancelModPopup = false;
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
    public void jobClosePopup(){
		//list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();
        if (Wid != null)
        { 
            //list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();
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

                        } 
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
                system.debug('** erp system'+workJob.Account__r.ERP_System__c);
                if(workJob.Account__r.ERP_System__c == 'One BMS'){
                    cancelSJWrapperObj1 = CG_BL_Intake.cancel(workJob,worecord);
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
    
     public PageReference saveAndCloseJob()
        //void to  PageReference switch is done by  Roopa defect number 178147
    {
        // if(dsidIndi != null && dsidIndi.containsIgnoreCase('O'))
        system.debug('erp syst'+workJob.Account__r.ERP_System__c);
        if (Wid != null)
        {
            requiredBMSMessage =false;
            showResolutionRequired =false;//ROD Defect 179167 Added by Rajesh Narra                                    
            showResolutionWithRepair = false;//ROD Defect 179167 Added by Rajesh Narra                        
            showRepairRequired = false;//ROD Defect 179167 Added by Rajesh Narra 
            if ((workJob.Account__r.ERP_System__c == 'BMS Legacy' || workJob.Account__r.ERP_System__c == 'One BMS') &&(workJob.Customer_Code__c==null || workJob.Unit_Number__c==null || workJob.Shop_Work_Order__c==null)){
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
                        if(!String.isBlank(solRec.Repair_Response__c) && !solRec.Repair_Response__c.contains('Successful')){
                            System.debug('46');
                            System.debug('Entered neg if Loop:');
                            negatRepairs.add(solRec);
                            System.debug('47');
                        }else if(solRec.Repair_Response__c != null && solRec.Repair_Response__c.contains('Successful')){
                            negatPosRepairs.add(solRec);
                        }else if(solRec.Repair_Response__c == null){
                            System.debug('48');
                            showRepairErrorMessage = TRUE; //ROD Defect 179167 Added by Rajesh Narra 
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
            
            System.Debug('record updated====='+workJob.Account__r.ERP_System__c);            
             return null;
            //return pageRef;// This code is uncommented by Roopa  178147
        }
        else{ 
            return null; // This code is uncommented by Roopa  178147
        }   
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

    public void populateMap(CSS_Job_Order__c serviceJob){
        mapStepIdtoSrt = new map<string,CSS_SRT__c>();
        system.debug('serviceJob.CSS_SRTS__r-->'+serviceJob.CSS_SRTS__r);
        for(CSS_SRT__c srt : serviceJob.CSS_SRTS__r){
            mapStepIdtoSrt.put(srt.Step_Id__c, srt);
        }

    }



    List<CSS_SRT__c> lstSRTinsert = new List<CSS_SRT__c>();
    //List<CSS_SRT__c> lstSRTUpdate = new List<CSS_SRT__c>();
      Map<String, Map<String,List<CSS_SRT__c>>> acCodeSRTCountListMap = new Map<String, Map<String,List<CSS_SRT__c>>>();
    Map<String,List<CSS_SRT__c>> srtCountListMap = new Map<String,List<CSS_SRT__c>>();
     Map<String,List<CSS_SRT__c>> accountCodeWithSRTMap = new Map<String,List<CSS_SRT__c>>();

    //Map<String, Map<String,Integer>> acCodeSRTCountMap = new Map<String, Map<String,Integer>>();
    //Map<String,Integer> srtCountMap = new Map<String,Integer>();
    List<CSS_SRT__c> srtList = new List<CSS_SRT__c>();
    Set<String> overlapSRTIdsSet = new Set<String>();
    //Set<String> queriedSRTIds = new Set<String>();

    public void jobPlanSRTAction(){
        List<CSS_SRT__c> selectedSRTList;
        List<CSS_SRT__c> deleteOverlapSRTList;
        try{
            selectedSRTList = new List<CSS_SRT__c>();
            deleteOverlapSRTList = new List<CSS_SRT__c>();
            //This query is modified to fetch ALL SRTs as below && below query data is passed to other methods to reduce queries & 
            //please don't change it & don't manipulate this query
            srtList = new List<CSS_SRT__c>([Select Id,Component_Id__r.Fail_Code__c, Job_Order__r.CSS_In_Shop_Labor_Rate__c, Step_Id__c,SRT_ID__c,SRT_Title__c,Account_Code__c,Account_Code_Description__c,SRT_Notes__c,SRT_Quantity__c,SRT_Warrantable__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,
                                            Diag_Access_Time__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Access_Calculated__c,SRT_Category__c, Extended_Hours__c, SRT_Time__c, 
                                            Calculated_Claimed_Hours__c, SRT_Time_Formula__c,Override__c,OverrideReason__c,Override_Reason__c,Overlap__c, Overlap_Step_Id__c,Adjusted_Overlap_Hours__c, Overlap_SRT_Number__c,
                                            Job_Order__c, Type__c, FailCode__c, Access_Code__c,Access_Code_Saved__c,isPerformed__c, SRT_AccessiblityCheck__c, Flex_Flag__c, Job_Order__r.AccessCode__c, Job_Order__r.Name,Component_Id__c,Component_Id__r.CSS_Account_Formula__c,Component_Id__r.FailCode_Formula__c,Component_Id__r.CampaignLaborPercentage__c,Component_Id__r.Type__c,Component_Id__r.CoveredLaborHrs__c from css_srt__c where job_order__c =:workJob.Id and SRT_ID__c !=null and SRT_ID__c !='0' ]);
            system.debug('jobPlanSRTAction loading... srtList>>>: '+srtList.size());
            List<CSS_Solution_Component__c> solCompLst = new List<CSS_Solution_Component__c>(); 
            List<CSS_Solution_Component__c> solCompLstFA = new List<CSS_Solution_Component__c>(); //GSSC-297
            List<CSS_Solution_Component__c> solCompLstFailures = new List<CSS_Solution_Component__c>(); //GSSC-297
            Map<String, String> fieldActionFC_Map = new Map<String, String>(); //GSSC-297
            //Added Root_Cause__c field and the where clause "Root_Cause__c = true" in below query as part of the story GSSC-456
            solCompLst= [SELECT Id, Root_Cause__c, Service_Job__r.CSS_In_Shop_Labor_Rate__c, Fail_Code__c, CSS_Account_Formula__c,CoveredLaborHrs__c,CampaignLaborPercentage__c,Selected_Component__c,Performed__c,FailCode_Formula__c,Type__c FROM CSS_Solution_Component__c WHERE Service_Job__r.Id =:workJob.Id AND Root_Cause__c = true AND ((Type__c = null AND Selected_Component__c = true) OR (Type__c IN ('ATC','TRP','Campaign') AND (Performed__c = true OR Performed_Review__c = true))) ORDER BY CSS_Failure_Sequence_Number__c ASC];//CSS_Account_Formula__c != null AND FailCode_Formula__c != null AND Commented these two fields to fix GSSC-619
            system.debug('solCompLst'+solCompLst.size());
            //GSSC-297 - START
            for(CSS_Solution_Component__c sc : solCompLst){
                if(sc.Type__c != null && sc.Type__c != ''){
                    solCompLstFA.add(sc);
                }
                else{
                    solCompLstFailures.add(sc);
                }
                if(sc.Type__c != null && sc.Type__c != '' && sc.CampaignLaborPercentage__c != '0' && sc.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c != null
                 && sc.Service_Job__r.CSS_In_Shop_Labor_Rate__c != '0' && sc.Service_Job__r.CSS_In_Shop_Labor_Rate__c != '' && sc.Service_Job__r.CSS_In_Shop_Labor_Rate__c != null){
                    if(!fieldActionFC_Map.containskey(sc.CSS_Account_Formula__c)){
                        fieldActionFC_Map.put(sc.CSS_Account_Formula__c, sc.Fail_Code__c);
                    }
                    
                }
            }
            //GSSC-297 - END
            List<CSS_SRT__c> srtListToFCACUpd = new List<CSS_SRT__c>();
            List<CSS_SRT__c> srtListToFCACUpdNew = new List<CSS_SRT__c>(); //GSSC-297
            //GSSC-297 - START
            system.debug('fieldActionFC_Map-->'+fieldActionFC_Map);
            system.debug('solCompLstFA-->'+solCompLstFA.size());
            if(solCompLstFA != null  && solCompLstFA.size() == 1){
                for(CSS_SRT__c srtFA : srtList){
                    if(srtFA.Type__c == 'Field Action' && (srtFA.FailCode__c == '' || srtFA.FailCode__c == null || srtFA.FailCode__c == 'Select One')){
                        CSS_SRT__c newSRT = new CSS_SRT__c();
                        if(srtFA.Component_Id__r.CampaignLaborPercentage__c != '0' && srtFA.Component_Id__r.CampaignLaborPercentage__c != '' && srtFA.Component_Id__r.CampaignLaborPercentage__c != null
                 && srtFA.Job_Order__r.CSS_In_Shop_Labor_Rate__c != '0' && srtFA.Job_Order__r.CSS_In_Shop_Labor_Rate__c != '' && srtFA.Job_Order__r.CSS_In_Shop_Labor_Rate__c != null && srtFA.Component_Id__r.Fail_Code__c != null && srtFA.Component_Id__r.CSS_Account_Formula__c != null)
                        newSRT.FailCode__c = srtFA.Component_Id__r.Fail_Code__c;
                        newSRT.Account_Code__c = srtFA.Component_Id__r.CSS_Account_Formula__c;
                        newSRT.Id = srtFA.Id;
                        srtListToFCACUpdNew.add(newSRT);
                    }
                }
            }
            else{
                system.debug('fieldActionFC_Map-->'+fieldActionFC_Map);
                for(CSS_SRT__c srtFA : srtList){
                    if(srtFA.Type__c == 'Field Action' && (srtFA.FailCode__c == '' || srtFA.FailCode__c == null || srtFA.FailCode__c == 'Select One')){
                        String tempFailCode;
                        CSS_SRT__c newSRT = new CSS_SRT__c();
                        if(fieldActionFC_Map != null){
                            tempFailCode = fieldActionFC_Map.get(srtFA.Component_Id__r.CSS_Account_Formula__c);
                        }
                        system.debug('tempFailCode-->'+tempFailCode);
                        if(tempFailCode != null && tempFailCode != ''){
                            newSRT.FailCode__c = tempFailCode;
                        }
                        else{ 
                            newSRT.FailCode__c = srtFA.Component_Id__r.Fail_Code__c;
                        }
                        system.debug('newSRT.FailCode__c-->'+newSRT.FailCode__c);
                        newSRT.Account_Code__c = srtFA.Component_Id__r.CSS_Account_Formula__c;
                        newSRT.Id = srtFA.Id;
                        srtListToFCACUpdNew.add(newSRT);
                    }
                }
                
            }
            //GSSC-297 - END
            if(solCompLstFailures.size()==1){
                String coverageType;
                if(solCompLstFailures[0].CSS_Account_Formula__c != null){
                    string temp = solCompLstFailures[0].CSS_Account_Formula__c.substring(0,solCompLstFailures[0].CSS_Account_Formula__c.length()-3);
                    string temp1 = solCompLstFailures[0].CSS_Account_Formula__c.substring(solCompLstFailures[0].CSS_Account_Formula__c.length()-3,solCompLstFailures[0].CSS_Account_Formula__c.length()); 
                    system.debug('temp--->>>>'+temp);
                    system.debug('temp1--->>>>'+temp1);
                    temp1 = temp1.trim();
                    temp = temp.trim();
                    string temp2 = temp + temp1;
                    CSS_JobEventTemporary__c jetSingle = new CSS_JobEventTemporary__c();
                    jetSingle = accCodeMapJET.get(temp2);
                    if(jetSingle!= null){
                        coverageType = jetSingle.Attribute1__c;
                    }
                
                for(CSS_SRT__c srts : srtList){
                    CSS_SRT__c srtSingleRec = new CSS_SRT__c();
                    //Added type__c == null condition below as part of the defect # 190493 
                    if((srts.FailCode__c == null || srts.FailCode__c == '') && (solCompLstFailures[0].Type__c == null || solCompLstFailures[0].Type__c == '')){
                        srtSingleRec.FailCode__c = solCompLstFailures[0].FailCode_Formula__c.RIGHT(4);
                    }
                    if(srts.Type__c != 'Private'){ 
                        /*if((srts.Account_Code__c == null || srts.Account_Code__c == '') && solCompLst[0].Type__c != null && solCompLst[0].Type__c != '' && (solCompLst[0].Type__c.equalsIgnoreCase('ATC') || solCompLst[0].Type__c.equalsIgnoreCase('TRP') || solCompLst[0].Type__c.equalsIgnoreCase('Campaign'))){
                            //Commented below if and else as part of the defect # 190493
                            /*if((solCompLst[0].CampaignLaborPercentage__c != null && solCompLst[0].CampaignLaborPercentage__c != '' && double.valueof(solCompLst[0].CampaignLaborPercentage__c) > 0) || (coverageType == 'OTH' || coverageType == 'POL')){
                                srtSingleRec.Account_Code__c = solCompLst[0].CSS_Account_Formula__c;
                                srtSingleRec.SRT_Warrantable__c = '100';
                            }
                            else
                                srtSingleRec.SRT_Warrantable__c = '0';
                        }
                        else{*/
                            if(srts.Account_Code__c == null || srts.Account_Code__c == ''){ 
                                if((solCompLstFailures[0].CoveredLaborHrs__c != null && solCompLstFailures[0].CoveredLaborHrs__c != '' && double.valueof(solCompLstFailures[0].CoveredLaborHrs__c) > 0) || (coverageType == 'OTH' || coverageType == 'POL')){
                                    srtSingleRec.Account_Code__c = solCompLstFailures[0].CSS_Account_Formula__c;
                                    srtSingleRec.SRT_Warrantable__c = '100';
                                }
                                else
                                    srtSingleRec.SRT_Warrantable__c = '0';
                            }
                        //}
                    }
                    else
                        srtSingleRec.Account_Code__c = '';

                    srtSingleRec.Id = srts.Id;
                    srtListToFCACUpd.add(srtSingleRec);
                }
                }
            }
            system.debug('Today srtListToFCACUpd' + srtListToFCACUpd);

            //147392 - map SRT with Account Code START & Data Lists Preparation
            List<CSS_SRT__c> tempList = new List<CSS_SRT__c>();
            for(CSS_SRT__c srtToOvLp : srtList){
                //Blank out all existing flags
                if(srtToOvLp.Type__c != 'Overlap'){
                    srtToOvLp.Access_Code_Flag__c = false;
                    srtToOvLp.SRT_Warrantable_Flag__c = false;
                    tempList.add(srtToOvLp);
                }

                //Preparation of Overlap existing records list
                if(srtToOvLp.Type__c == 'Overlap'){
                    deleteOverlapSRTList.add(srtToOvLp);
                }
                
                //Preparation of selected records list for Mutual Exclusive Service
                if(srtToOvLp.SRT_AccessiblityCheck__c == true || srtToOvLp.isPerformed__c == true) {
                selectedSRTList.add(srtToOvLp);
                }

                //Below code for preparation of Overlap Map with individual account code
                //Only for Selected SRTs & No Flex SRTs
                if(srtToOvLp.Flex_Flag__c != true && (srtToOvLp.SRT_AccessiblityCheck__c == true || srtToOvLp.isPerformed__c == true)) {
                    String tempAccCode = '';
                    if(srtToOvLp.Account_Code__c == null || srtToOvLp.Account_Code__c == 'Select One'){
                        tempAccCode = 'Customer Billable';
                    }
                    else
                        tempAccCode = srtToOvLp.Account_Code__c;

                    //Step1: Preparing acCodeSRTCountListMap -- SRT List with SRTId based and then SRTs with AccountCode based Map
                    if(acCodeSRTCountListMap.containskey(tempAccCode)){
                        Map<String,List<CSS_SRT__c>> srtCountListMap = acCodeSRTCountListMap.get(tempAccCode);
                        if(srtCountListMap.containskey(srtToOvLp.Step_Id__c)){
                            //acCodeSRTCountListMap.get(srtToOvLp.SRT_ID__c).add(srtToOvLp);
                            List<CSS_SRT__c> tSRTList = srtCountListMap.get(srtToOvLp.Step_Id__c);
                            tSRTList.add(srtToOvLp);
                            srtCountListMap.put(srtToOvLp.Step_Id__c, tSRTList);
                            acCodeSRTCountListMap.put(tempAccCode, srtCountListMap);
                        }else{
                            //srtCountListMap = new Map<String,List<CSS_SRT__c>>();
                            srtCountListMap.put(srtToOvLp.Step_Id__c, new List<CSS_srt__c>{srtToOvLp});
                            acCodeSRTCountListMap.put(tempAccCode, srtCountListMap);
                        }
                    }else{
                        srtCountListMap = new Map<String,List<CSS_SRT__c>>();
                        srtCountListMap.put(srtToOvLp.Step_Id__c, new List<CSS_srt__c>{srtToOvLp});
                        acCodeSRTCountListMap.put(tempAccCode, srtCountListMap);
                    }
                    //queriedSRTIds.add(tempAccCode+'-'+srtToOvLp.Step_Id__c);  //how to handle duplicate SRTs here??

                    //Step2: Preparing accountCodeWithSRTMap 
                    if(!accountCodeWithSRTMap.containskey(tempAccCode)){
                        accountCodeWithSRTMap.put(tempAccCode,new List<CSS_srt__c>{srtToOvLp});
                    }
                    else{
                        accountCodeWithSRTMap.get(tempAccCode).add(srtToOvLp);
                    }
                }
            }
            system.debug('selectedSRTList>>>:'+selectedSRTList.size());
            system.debug('deleteOverlapSRTList>>>:'+deleteOverlapSRTList.size());
            //147392 - map SRT with Account Code END

            //Overlap & Mutual services execution in below method
            //147392 - Send SRT for OverLap Check 
            workJob.Overlap_Service_Failure_Msg__c = ''; //Blank out Error Message in the beginning & update it if it gets msg from service
            workJob.Mutual_Exclusive_Message__c = ''; //Blank out Error Message in the beginning & update it if it gets msg from service
            workJob.DupAccessCodePercentReqMsg__c = ''; //Blank out Error Message in the beginning & update it if it gets msg from service
            createOverlapSRT(accountCodeWithSRTMap,selectedSRTList,deleteOverlapSRTList);   
            
            //Do ALL DMLs here after ALL webservices execution completed
            try{
                //Blank out all existing flags
            update tempList; 
            tempList = null;
                
                //Updating Quantity & %Requested for SRTs 00-901,00-902-00,00-904-00
                if(srtListToFCACUpd != null && srtListToFCACUpd.size() > 0)
                    update srtListToFCACUpd;
                
                //GSSC-297 - START
                if(srtListToFCACUpdNew != null && srtListToFCACUpdNew.size() > 0){
                    update srtListToFCACUpdNew;
                }
                //GSSC-297 - END
            }catch(Exception ex){
                System.debug('in catch of srtListToFCACUpd update of CSS_JobPlanSRTController>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            }

            //calculate ExtendedHours logic should be called here after calling Overlaps
            calculateExtendedHours(srtList);

            //Check Duplicate SRTs
            checkDuplicateSRTs();
            
            //Duplicate Access Code & %Requested logic here
            //The below method should run after all SRTs are inserted/updated to find duplicates
            buildDuplicateAccessCodesLogic();

            //below method for showing SRT ODM message,-By RAJESH 16th Apr 2019
            system.debug('*****Calling method for showing ODM message**');
            CG_CL_CoverageLimitExceedValidation callingSRTClaimedHour= new CG_CL_CoverageLimitExceedValidation();
            callingSRTClaimedHour.covLimitValidationSRT(workJob.Id,null);
            callingSRTClaimedHour.covLimitfailcodeJobValidation(workJob.Id,null);

            //Finally update Job with SRT errorMsgs or with any other updates finally here in a single shot.
            if(workJob !=null){
                update workJob;
            }
            List<CSS_SRT__c> SRTHrsExtendedJob;
            List<CSS_SRT__c> lstSRTjob = new List<CSS_SRT__c>();
             if(workJob.Id!=null){
                 //Commented the existing query and added new one: defect #191658
                /*SRTHrsExtendedJob = new List<CSS_SRT__c>([Select id, Extended_Hours__c,type__c,Job_Order__c, Solution_Number__c ,SRT_Category__c,isPerformed__c
                                                          from CSS_SRT__c where Job_Order__c =: workJob.Id AND
                                                          (((isPerformed__c=true OR SRT_AccessiblityCheck__c=true) AND Type__c NOT IN ('Campaign','ATC','TRP','Overlap','Field Action')) 
                                                           OR ( isPerformed__c=true AND Component_Id__r.Performed_Review__c=true AND Component_Id__r.Type__c IN ('Campaign','ATC','TRP')))]);*/
               SRTHrsExtendedJob = new List<CSS_SRT__c>([Select id, srt_id__c, Extended_Hours__c, type__c, srt_type__c, Job_Order__c, Solution_Number__c, SRT_Category__c, isPerformed__c, createddate, solution_Number__r.name, solution_Number__r.diagnostic_response__c 
               from CSS_SRT__c where Job_Order__c = : workJob.Id AND (((isPerformed__c=true OR SRT_AccessiblityCheck__c=true) AND Type__c NOT IN ('Campaign', 'ATC', 'TRP', 'Overlap', 'Field Action')) //AND Solution_Number__r.Diagnostic_Response__c != 'Could not perform the solution verification'
               OR ( isPerformed__c=true AND Component_Id__r.Performed_Review__c=true AND Component_Id__r.Type__c IN ('Campaign', 'ATC', 'TRP')))]);
                system.debug(' Trigger Query Initail SRTHrsExtendedJob>>' + SRTHrsExtendedJob);
                system.debug(' Trigger Query Initail SRTHrsExtendedJob.size>>' + SRTHrsExtendedJob.size());
                /*if(SRTHrsExtendedJob.size() == 0)
                workJob.TotalSRTExtendedHours__c = 0.0;*/
            }
            if(SRTHrsExtendedJob!=null){ // && SRTHrsExtendedJob.size() > 0
               lstSRTjob.addAll(SRTHrsExtendedJob);
            }
            if(lstSRTjob != null) // && lstSRTjob.size()>0
                CG_CL_TotalSRTHoursCalculation.CalcualteExthrs(lstSRTjob, null, workJob.Id, null);
            JobTotalSRTHrs = new CSS_Job_Order__c();
            JobTotalSRTHrs =[select id,TotalSRTExtendedHours__c from CSS_Job_Order__c where id= :workJob.Id];

        }catch(Exception ex){
            System.debug('in catch of jobPlanSRTAction of CSS_JobPlanSRTController>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    //147392 -  function to create Overlap records
    Map<String,Decimal> olapAdjHrsMap = new Map<String,Decimal>();
    Map<String,String> olapReasonMap = new Map<String,String>();
    Map<String,String> olapReasonPickMap = new Map<String,String>();
    Boolean isOverlapServiceFailed = false;
    public void createOverlapSRT(Map<String,List<CSS_SRT__c>> accountCodeWithSRTMap, List<CSS_SRT__c> selectedSRTList, List<CSS_SRT__c> deleteOverlapSRTList){
        try{
            //Preparing Delete SRT List
            //List<CSS_SRT__c> deleteOverlapSRTList = new List<CSS_SRT__c>([SELECT Id, Account_Code__c, SRT_ID__c, Step_Id__c, Overlap_Step_Id__c, Override__c, Adjusted_Overlap_Hours__c, Overlap_SRT_Number__c,OverrideReason__c,Override_Reason__c FROM CSS_SRT__c WHERE Type__c = 'Overlap' and Job_Order__c =: workJob.Id ]);                
            if(deleteOverlapSRTList.size()>0){
                for(CSS_SRT__c olsrt : deleteOverlapSRTList){
                    //also check here Unselected SRTs/Quantity changed SRTs/Deleted SRTs
                    if(olsrt.Override__c){
                        olapAdjHrsMap.put(olsrt.Account_Code__c+'-'+olsrt.Step_Id__c+'-'+olsrt.Overlap_Step_Id__c, olsrt.Adjusted_Overlap_Hours__c);
                        olapReasonMap.put(olsrt.Account_Code__c+'-'+olsrt.Step_Id__c+'-'+olsrt.Overlap_Step_Id__c, olsrt.OverrideReason__c);
                        olapReasonPickMap.put(olsrt.Account_Code__c+'-'+olsrt.Step_Id__c+'-'+olsrt.Overlap_Step_Id__c, olsrt.Override_Reason__c);
                    }
                }
            }

            lstSRTinsert = new List<CSS_SRT__c>();
            if(accountCodeWithSRTMap.size()>0){
                for(String accountCode : accountCodeWithSRTMap.keySet()){
                    System.debug('accountCode>>:'+accountCode);
                    if(accountCodeWithSRTMap.get(accountCode).size()>0){
                        List<CSS_SRT__c> lstSRTinsertTemp = overlapSRTCallout(accountCode,accountCodeWithSRTMap.get(accountCode));
                        system.debug('accountCode>>:'+accountCode+' lstSRTinsertTemp size>>:'+lstSRTinsertTemp.size()+' isOverlapServiceFailed>:'+isOverlapServiceFailed);
                        if(isOverlapServiceFailed){
                            workJob.Overlap_Service_Failure_Msg__c = Label.CG_Unable_to_retrieve_Overlap_SRT_Information_Please_contact_support_by_LiveChat;
                            return; //Return here bcz of service failure & shouldn't delete user entered Adjusted Olap Hours of existing Overlap records 
                        }
                        if(!lstSRTinsertTemp.isEmpty()){
                            lstSRTinsert.addAll(lstSRTinsertTemp);
                            system.debug('lstSRTinsert size>>:'+lstSRTinsert.size());
                        }
                    }   
                }
            }
            if(!isOverlapServiceFailed){
                workJob.Overlap_Service_Failure_Msg__c = ''; //Blank out Olap error when it is success
            }
            system.debug('lstSRTinsert--'+lstSRTinsert);

            //Mutual Overlap service execution
            if(selectedSRTList.size()>0 && !isOverlapServiceFailed)
                mutualOverlapSRTCallout(selectedSRTList);
            
            //Deleting Overlap existing records
            if(deleteOverlapSRTList.size() > 0)
                delete deleteOverlapSRTList;
            //Inserting Fresh Overlap records
            if(lstSRTinsert.size() > 0){
                insert lstSRTinsert;
            }
            system.debug('after inserting lstSRTinsert--'+lstSRTinsert.size());

        }catch(Exception ex){
            System.debug('in catch of createOverlapSRT of CSS_JobPlanSRTController>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    //147392 -  function to make callout for Overlap
    public List<CSS_SRT__c> overlapSRTCallout(String accCode,List<CSS_SRT__c> srtList){
        system.debug('in overlapSRTCallout method...');
        List<CSS_SRT__c> lstSRTins = new List<CSS_SRT__c>();
        try{
            //System.debug('accCode>>:'+accCode+'srtList>:'+srtList);
            if(srtList ==null || srtList.size()<=0){
                return lstSRTins;
            }else{
                System.debug('accCode>>:'+accCode+' srtList size>:'+srtList.size());
            }

            //User u = css_utility.getUserAttributes(userinfo.getUserId()); 
            string lang = UserInfo.getLocale();
            datetime systemDate = System.now();
            string sysdt = systemDate.format('YYYY-MM-dd') +'T00:00:00';        

            //Create the JSON request
            CSS_OverlapSRTReq overlapSRTREq = new CSS_OverlapSRTReq();
            CSS_OverlapSRTReq.Header headerDeatail = new CSS_OverlapSRTReq.Header();
            CSS_OverlapSRTReq.Sender sendeDetail = new CSS_OverlapSRTReq.Sender();
            sendeDetail.ServiceName = 'GetOverlapSRT';
            sendeDetail.SenderID = 'CSS-Service';
            headerDeatail.Sender = sendeDetail;

            CSS_OverlapSRTReq.Target  targetDetail = new CSS_OverlapSRTReq.Target();
            targetDetail.TargetID = 'SRT';
            headerDeatail.Target = targetDetail;

            list<CSS_OverlapSRTReq.Steps> stepsrt1 = new list<CSS_OverlapSRTReq.Steps>();
            //loop through SRT List to send it for overlap check
            if(srtList != null && !srtList.isEmpty()){
                Set<String> stepIdsSet = new Set<String>();
                for(CSS_SRT__c srtrc: srtList){
                    if(srtrc.Step_Id__c !=null && srtrc.Step_Id__c !='0' && (srtrc.SRT_AccessiblityCheck__c == true || srtrc.isPerformed__c == true) ){
                        System.debug('srtrc.Step_Id__c>>:'+srtrc.Step_Id__c+' stepIdsSet>>:'+stepIdsSet);
                        if(!stepIdsSet.contains(srtrc.Step_Id__c)){
                            CSS_OverlapSRTReq.Steps stepsrt = new CSS_OverlapSRTReq.Steps();
                            if(srtrc.Step_Id__c != '0'){
                                stepsrt.StepId = integer.valueof(srtrc.Step_Id__c);
                                //system.debug('checking step id'+stepsrt.StepId );

                                if(srtrc.SRT_Quantity__c != null){ 
                                    stepsrt.Qty = srtrc.SRT_Quantity__c.intvalue();
                                }
                                //system.debug('Quantity'+stepsrt.Qty);
                                if(srtrc.Access_Code__c != null){
                                    stepsrt.AccessCode = srtrc.Access_Code__c;
                                }else{
                                    stepsrt.AccessCode = srtrc.Job_Order__r.AccessCode__c;// if srt record's access code is blank, then taking Access code from job level.
                                }
                                stepsrt1.add(stepsrt);
                                stepIdsSet.add(srtrc.Step_Id__c);
                            }
                        }else{
                            //System.debug('else srtrc.Step_Id__c>>:'+srtrc.Step_Id__c);
                            for(CSS_OverlapSRTReq.Steps stepsObj :stepsrt1){
                                if(stepsObj.StepId == Integer.valueof(srtrc.Step_Id__c)){
                                    //System.debug('else stepsObj>>:'+stepsObj);
                                    stepsObj.Qty = stepsObj.Qty + (srtrc.SRT_Quantity__c !=null? srtrc.SRT_Quantity__c.intvalue():0);
                                }
                            }
                        }
                    }
                }    
                system.debug('List size'+stepsrt1.size());  
            }

            CSS_OverlapSRTReq.DataArea dtarea = new CSS_OverlapSRTReq.DataArea();
            dtarea.JobID = srtList.size()>0?srtList[0].Job_Order__r.Name:'';
            dtarea.ClaimID = '';
            dtarea.Languagecode = lang;
            dtarea.DTTimestamp = sysdt;
            dtarea.EffectiveDTTime = sysdt;
            dtarea.ProcessOption = 'OVERLAP'; //MUT_EX/OVERLAP
            dtarea.Steps = stepsrt1;
            overlapSRTREq.DataArea = dtarea;
            overlapSRTREq.Header = headerDeatail;
            system.debug('***overlapSRTREq--->'+overlapSRTREq);

            if(!srtList.isEmpty()){
                //Callout for overlap
                CSS_OverlapSRTResponse overlapresponse = CSS_WS_SRT.getOverlapSRTRecords(overlapSRTREq);
                system.debug('overlapresponse-->'+overlapresponse);
                if(overlapresponse ==null || overlapresponse.DataArea ==null || overlapresponse.Header==null 
                   || String.isBlank(overlapresponse.Header.MessageType) || overlapresponse.Header.MessageType=='E'){
                    isOverlapServiceFailed = true;
                    system.debug('overlap service failed isOverlapServiceFailed-->'+isOverlapServiceFailed);
                    return lstSRTins;
                }

                //hardCodedResSample = '{"DataArea":{"MutualExMessage":"","TotalOverlapHours":4.1,"Steps":[{"Qty":1,"OverlapTime":[{"SRTNumber":"","OverlapHrs":0}],"SRTHours":2.7,"SRTAdjustedHours":2.7,"StepId":84860,"AccessCode":"B"},{"Qty":1,"OverlapTime":[{"SRTNumber":"10-049-00","OverlapHrs":0.7}],"SRTHours":1.4,"SRTAdjustedHours":0.7,"StepId":97307,"AccessCode":"B"}],"TotalAdjustedHours":3.4,"OverlapSRTTime":[{"SRTNumber":"10-049-00","OverlapHrs":0.7,"SRTTitle":"Electronic Actuator, Variable Geometry Turbocharger - Remove and Install","OverlapStepId":84860,"OverlapSRTNumber":"10-043-00","StepId":97307,"OverlapSRTTitle":"Turbocharger Assembly Variable Geometry, Remove and Install (CM871/CM2250/2350)"}]},"Header":{"ReturnCodeDescription":"Normal, Successful completion.","ReturnCode":"ORA-00000","MessageIdentifier":"S"}}';
                //if response is not null then create Overlap Records based on response
                if(overlapresponse !=null && overlapresponse.DataArea !=null && overlapresponse.DataArea.OverlapSRTTime !=null && overlapresponse.DataArea.OverlapSRTTime.size()>0){
                    for(CSS_OverlapSRTResponse.OverlapSRTTime srtTime : overlapresponse.DataArea.OverlapSRTTime){
                        system.debug('srtTime.SRTNumber-->:'+srtTime.SRTNumber+' srtTime.OverlapSRTNumber>>>:'+srtTime.OverlapSRTNumber+' accCode>>>:'+accCode);
                        //create OverLap Record
                        CSS_SRT__c tempSRT = new CSS_SRT__c();
                        tempSRT.SRT_ID__c = srtTime.SRTNumber;
                        tempSRT.Overlap_SRT_Number__c = srtTime.OverlapSRTNumber;
                        tempSRT.Name = srtTime.SRTNumber;
                        tempSRT.Overlap_Hours__c = srtTime.OverlapHrs;
                        tempSRT.SRT_Title__c = srtTime.SRTTitle;
                        tempSRT.Overlap_Step_Id__c = String.valueof(srtTime.OverlapStepId);    
                        tempSRT.Step_Id__c = String.valueof(srtTime.StepId);
                        tempSRT.Overlap_SRT_Title__c = srtTime.OverlapSRTTitle;
                        if(olapAdjHrsMap != null && olapAdjHrsMap.containsKey(accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId)){
                            //if(olapAdjHrsMap.get(accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId) <= srtTime.OverlapHrs){
                            tempSRT.Adjusted_Overlap_Hours__c = olapAdjHrsMap.get(accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId);
                            tempSRT.OverrideReason__c = olapReasonMap.get(accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId);
                            tempSRT.Override_Reason__c = olapReasonPickMap.get(accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId);
                            tempSRT.Override__c= true;
                            system.debug('contains Key-->'+accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId);
                            //}
                        }else{
                            system.debug('not contains Key-->'+accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId);
                        }

                        tempSRT.Type__c = 'Overlap';
                        tempSRT.Account_Code__c = accCode;
                        tempSRT.Job_Order__c = workJob.Id;
                        lstSRTins.add(tempSRT);
                        //}//else{ //update part is not required here since deleting all above

                    }
                }else{
                    //if no response, what should be done??
                    //if one Overlap service is success && other is fail, then how??
                }
            }
        } catch(exception e){
            system.debug('in catch of overlapSRTCallout method of CSS_JobPlanSRTController class>>>>>>'+e.getmessage() + ' ' + e.getLineNumber());
        }
        system.debug('lstSRTins--'+lstSRTins);
        return lstSRTins;
    }


    //153527 -  function to make callout for Mutual Overlap
    public void mutualOverlapSRTCallout(List<CSS_SRT__c> selectedSRTList){
        system.debug('in mutualOverlapSRTCallout method...');
        try{
            /*List<CSS_SRT__c> mutExSRTList = new List<CSS_SRT__c>([Select id,Step_Id__c,SRT_ID__c,SRT_Title__c,OverrideReason__c,Override__c,Overlap__c,SRT_Notes__c,SRT_Quantity__c
                                                                  ,SRT_Warrantable__c,Diag_Access_Time__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Access_Calculated__c,SRT_Category__c, Extended_Hours__c, SRT_Time__c, 
                                                                  Calculated_Claimed_Hours__c, SRT_Time_Formula__c,
                                                                  Job_Order__c, Type__c, FailCode__c, isPerformed__c, SRT_AccessiblityCheck__c, Account_Code__c, Job_Order__r.AccessCode__c, Job_Order__r.Name from css_srt__c 
                                                                  where job_order__c =:workJob.Id and SRT_ID__c !=null and SRT_ID__c !='0' and (SRT_AccessiblityCheck__c = true or isPerformed__c = true)]); */ //commeted this query bcz to use it from global query
            System.debug('selectedSRTList size=======>'+selectedSRTList.size());
            if(selectedSRTList ==null || selectedSRTList.size()<=0){
                return;
            }

            system.debug('jobID.Id'+workJob.Id);
            CSS_OverlapSRTReq overlapSRTREq = new CSS_OverlapSRTReq();
            //User u = css_utility.getUserAttributes(userinfo.getUserId()); 
            string lang = UserInfo.getLocale();
            datetime systemDate = System.now();
            string sysdt = systemDate.format('YYYY-MM-dd') +'T00:00:00';        

            //Create the JSON request
            CSS_OverlapSRTReq.Header headerDeatail = new CSS_OverlapSRTReq.Header();
            CSS_OverlapSRTReq.Sender sendeDetail = new CSS_OverlapSRTReq.Sender();
            sendeDetail.ServiceName = 'GetOverlapSRT';
            sendeDetail.SenderID = 'CSS-Service';
            headerDeatail.Sender = sendeDetail;

            CSS_OverlapSRTReq.Target  targetDetail = new CSS_OverlapSRTReq.Target();
            targetDetail.TargetID = 'SRT';
            headerDeatail.Target = targetDetail;

            list<CSS_OverlapSRTReq.Steps> stepsrt1 = new list<CSS_OverlapSRTReq.Steps>();
            //loop through SRT List to send it for overlap check
            if(selectedSRTList != null && !selectedSRTList.isEmpty()){
                Set<String> stepIdsSet = new Set<String>();
                for(CSS_SRT__c srtrc: selectedSRTList){
                    if(srtrc.Step_Id__c !=null && srtrc.Step_Id__c !='0' && (srtrc.SRT_AccessiblityCheck__c == true || srtrc.isPerformed__c == true) ){
                        System.debug('srtrc.Step_Id__c>>:'+srtrc.Step_Id__c+' stepIdsSet>>:'+stepIdsSet);
                        if(!stepIdsSet.contains(srtrc.Step_Id__c)){
                            CSS_OverlapSRTReq.Steps stepsrt = new CSS_OverlapSRTReq.Steps();
                            //if(srtrc.Step_Id__c !=null && srtrc.Step_Id__c !='0' ){ //not needed
                            stepsrt.StepId = integer.valueof(srtrc.Step_Id__c);
                            system.debug('checking step id'+stepsrt.StepId );

                            if(srtrc.SRT_Quantity__c != null){ 
                                stepsrt.Qty = srtrc.SRT_Quantity__c.intvalue();
                            }
                            system.debug('Quantity'+stepsrt.Qty);
                            if(srtrc.Access_Code__c != null){
                                stepsrt.AccessCode = srtrc.Access_Code__c;
                            }else{
                                stepsrt.AccessCode = srtrc.Job_Order__r.AccessCode__c; 
                            }
                            stepsrt1.add(stepsrt);
                            stepIdsSet.add(srtrc.Step_Id__c);
                            //}
                        }else{
                            System.debug('else srtrc.Step_Id__c>>:'+srtrc.Step_Id__c);
                            System.debug('else srtrc.SRT_Quantity__c>>:'+srtrc.SRT_Quantity__c);
                            for(CSS_OverlapSRTReq.Steps stepsObj :stepsrt1){
                                System.debug('else stepsObj>>:'+stepsObj);
                                System.debug('else loop stepsObj.Qty>>:'+stepsObj.Qty);
                                if(stepsObj.StepId == Integer.valueof(srtrc.Step_Id__c)){
                                    stepsObj.Qty = stepsObj.Qty + (srtrc.SRT_Quantity__c !=null? srtrc.SRT_Quantity__c.intvalue():0);
                                }
                            }
                        }
                    }
                }    
                system.debug('List size'+stepsrt1.size());  
            }

            CSS_OverlapSRTReq.DataArea dtarea = new CSS_OverlapSRTReq.DataArea();
            dtarea.JobID = selectedSRTList.size()>0?selectedSRTList[0].Job_Order__r.Name:'';
            dtarea.ClaimID = '';
            dtarea.Languagecode = lang;
            dtarea.DTTimestamp = sysdt;
            dtarea.EffectiveDTTime = sysdt;
            dtarea.ProcessOption = 'MUT_EX'; //MUT_EX/OVERLAP
            dtarea.Steps = stepsrt1;
            overlapSRTREq.DataArea = dtarea;
            overlapSRTREq.Header = headerDeatail;
            system.debug('*** mutual overlapSRTREq--->'+overlapSRTREq);

            if(!selectedSRTList.isEmpty()){
                //Callout for Mutual overlap
                CSS_OverlapSRTResponse overlapresponse = CSS_WS_SRT.getOverlapSRTRecords(overlapSRTREq);
                system.debug(' mutual overlapresponse-->'+overlapresponse);
                //if response is not null then create Overlap Records based on response
                if(overlapresponse !=null && overlapresponse.DataArea !=null && overlapresponse.DataArea.MutualExMessage !=null && overlapresponse.DataArea.MutualExMessage.trim() !=''){
                    workJob.Mutual_Exclusive_Message__c = overlapresponse.DataArea.MutualExMessage;
                }else
                    workJob.Mutual_Exclusive_Message__c = '';
            }
        } catch(exception e){
            system.debug('in catch of mutualOverlapSRTCallout method of CSS_JobPlanSRTController class>>>>>>'+e.getmessage() + ' ' + e.getLineNumber());
        }
        
    }

    //function to calculate Extended Hours
    Map<id,CSS_SRT__c> srtListToUpd = new Map<id,CSS_SRT__c>();
    public void calculateExtendedHours(List<CSS_SRT__c> srtList){
        System.debug('=======> in calculateExtendedHours');
        try{
            System.debug('srtList=======>'+srtList);
            if(srtList ==null){
                return;
            }

            Map<String, Decimal> overlapSRTHoursSum = new Map<String, Decimal>();
            //The Below code is for summing Overlap hours for each SRT based on AccountCode & need below query since needed newly inserted overlap records
            List<CSS_SRT__c> overlapSrtList = new List<CSS_SRT__c>();
            overlapSrtList = new List<CSS_SRT__c>([SELECT Id, SRT_ID__c, Step_Id__c, Account_Code__c, SRT_Category__c, Extended_Hours__c, SRT_Time__c, SRT_Quantity__c, Calculated_Claimed_Hours__c, Type__c, SRT_Warrantable__c FROM CSS_SRT__c WHERE Type__c = 'Overlap' AND Job_Order__c =: workJob.Id]);
            System.debug('overlapSrtList size=======>'+overlapSrtList.size());
            if(overlapSrtList != null && overlapSrtList.size() > 0){
                overlapSRTIdsSet = new Set<String>();
                for(CSS_SRT__c olapSrt : overlapSrtList){
                    overlapSRTIdsSet.add(olapSrt.Account_Code__c+'-'+olapSrt.Step_Id__c);
                    //Here need to add AccountCode basis logic
                    if(overlapSRTHoursSum.containsKey(olapSrt.Account_Code__c+'-'+olapSrt.Step_Id__c)){
                        Decimal existingHrs = overlapSRTHoursSum.get(olapSrt.Account_Code__c+'-'+olapSrt.Step_Id__c);
                        existingHrs = existingHrs + olapSrt.Calculated_Claimed_Hours__c;
                        overlapSRTHoursSum.put(olapSrt.Account_Code__c+'-'+olapSrt.Step_Id__c, existingHrs);
                        System.debug('olapSrt.SRT_ID>>:'+olapSrt.SRT_ID__c+' existingHrs=======>'+existingHrs);
                    }else{
                        overlapSRTHoursSum.put(olapSrt.Account_Code__c+'-'+olapSrt.Step_Id__c, olapSrt.Calculated_Claimed_Hours__c);
                        System.debug('olapSrt.SRT_ID>>:'+olapSrt.SRT_ID__c+' olapSrt.Calculated_Claimed_Hours=======>'+olapSrt.Calculated_Claimed_Hours__c);
                    }
                    System.debug('overlapSRTHoursSum =======>'+overlapSRTHoursSum);
                }
            }


            String tempAccCode = '';
            for(CSS_SRT__c srt : srtList){
                if(overlapSrtList != null && overlapSrtList.size() > 0){
                    System.debug('Inside Overlap block... srt.SRT_ID>>:'+srt.SRT_ID__c);
                    if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One'){
                        tempAccCode = 'Customer Billable';
                    }
                    else
                        tempAccCode = srt.Account_Code__c;

                    if(overlapSRTIdsSet.contains(tempAccCode+'-'+srt.Step_Id__c)){
                        System.debug('contains... srt.SRT_ID>>:'+srt.SRT_ID__c);
                        Map<String,List<CSS_SRT__c>> srtCountListMap = acCodeSRTCountListMap.get(tempAccCode);
                        if(srtCountListMap.get(srt.Step_Id__c).size()>1){
                            // if(srtCountListMap.containsKey(srt.SRT_ID__c) && srtCountListMap.get(srt.SRT_ID__c).size()>1){
                            System.debug('contains >1... srt.SRT_ID>>:'+srt.SRT_ID__c);
                            Decimal srtTotalQuantity = 0;
                            for(CSS_SRT__c tmpSRT :srtCountListMap.get(srt.Step_Id__c)){
                                //srtTotalQuantity++;
                                srtTotalQuantity = srtTotalQuantity + tmpSRT.SRT_Quantity__c;
                            }
                            System.debug('srtTotalQuantity>>:'+srtTotalQuantity);
                            getExtendedHours(srt, true, overlapSRTHoursSum.get(tempAccCode+'-'+srt.Step_Id__c), srtTotalQuantity);

                            /*List<CSS_SRT__c> tempSrtList = srtCountListMap.get(srt.Step_Id__c);
                            Decimal olapHrs = overlapSRTHoursSum.get(tempAccCode+'-'+srt.Step_Id__c);
                            if(olapHrs>0){
                                Decimal dividedHrs = olapHrs/tempSrtList.size();
                                getExtendedHours(srt, true, dividedHrs, srt.SRT_Quantity__c);
                            }*/
                        }else{
                            System.debug('not contains... srt.SRT_ID>>:'+srt.SRT_ID__c+' overlapSRTHoursSum.srt.SRT_ID__c>>:'+overlapSRTHoursSum.get(tempAccCode+'-'+srt.Step_Id__c));
                            getExtendedHours(srt, false, overlapSRTHoursSum.get(tempAccCode+'-'+srt.Step_Id__c), srt.SRT_Quantity__c);
                        }
                    }else{
                        //no overlap matching, this won't happen
                        getExtendedHours(srt, false, 0, srt.SRT_Quantity__c);
                    }
                }else{
                    //if no overlaps
                    getExtendedHours(srt, false, 0, srt.SRT_Quantity__c);
                }
            }

            system.debug('output size-->'+srtListToUpd.size());
            if(srtListToUpd != null && srtListToUpd.size() > 0){
                system.debug('output-->'+srtListToUpd);
                update srtListToUpd.values();
            }

            //To get updated TotalSRTExtendedHours
            //JobTotalSRTHrs = new CSS_Job_Order__c();
            //JobTotalSRTHrs =[select id,TotalSRTExtendedHours__c from CSS_Job_Order__c where id= :Wid]; //This query should is to get updated TotalSRTExtendedHours__c
            //system.debug('PAge Action JobTotalSRTHrs.TotalSRTExtendedHours__c' + JobTotalSRTHrs.TotalSRTExtendedHours__c);

        }
        catch (exception exc){
            system.debug('catch exception in calculateExtendedHours JobplansrtController class at line number '+exc.getLineNumber()+' with error message '+exc.getMessage());
        }       
    }

    public void getExtendedHours(CSS_SRT__c srt, Boolean isDuplicate, Decimal olapHrs, Decimal srtTotalQuantity){
        try{
            system.debug('Inside getExtendedHours method... ');
            system.debug('****Account_Code_Description__c***'+srt.Account_Code_Description__c);
            CSS_SRT__c tempSRT = new CSS_SRT__c();
            system.debug('srt.Type__c--'+srt.Type__c+' olapHrs>>:'+olapHrs+' srt.Account_Code__c>>:'+srt.Account_Code__c);
            system.debug('getExtendedHours SRTId: '+srt.SRT_ID__c+' SRT_Quantity__c:'+srt.SRT_Quantity__c+' SRT_Warrantable__c>:'+srt.SRT_Warrantable__c+' srt.SRT_Time_Formula__c>>:'+srt.SRT_Time_Formula__c+' srt.SRT_Time__c>>:'+srt.SRT_Time__c+' srt.Type__c--'+srt.Type__c+' olapHrs>>:'+olapHrs);
            //To handle 0 quantity
            if(srtTotalQuantity <=0 || srt.SRT_Quantity__c <=0){
                tempSRT.Id = srt.Id;
                tempSRT.Extended_Hours__c = 0.0;
                srtListToUpd.put(tempSRT.Id,tempSRT);
                return;
            }
            //end
            if(srt.Type__c == 'Repair' || srt.Type__c == 'Repair Access' || srt.SRT_Category__c == 'AdditionalDiag' || srt.SRT_Category__c == 'AdditionalRep' ||
               srt.Type__c == 'Diagnosis' || srt.Type__c == 'Diag Access' || srt.Type__c == '99Time' || srt.SRT_Category__c == 'Campaign' || srt.SRT_Category__c == 'TRP'|| srt.SRT_Category__c == 'ATC' || srt.Type__c == 'Field Action' || srt.Type__c == 'Field Action Access' ){
                tempSRT.Id = srt.Id;
                try{
                    //if(srt.Type__c == 'Diagnosis' || srt.Type__c == 'Diag Access'){
                    if(srt.Type__c == 'Diag Access'){
                        if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == '')
                            tempSRT.Extended_Hours__c = (( (srt.Diag_Access_Time__c!=null?srt.Diag_Access_Time__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                        //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs);
                        else
                            tempSRT.Extended_Hours__c = ( ((srt.Diag_Access_Time__c!=null?srt.Diag_Access_Time__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) ) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                        //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                    }
                    else if(srt.Type__c == 'Repair Access'){
                        system.debug('Repair Access getExtendedHours SRTId: '+srt.SRT_ID__c+' SRT_Quantity__c:'+srt.SRT_Quantity__c+' SRT_Warrantable__c>:'+srt.SRT_Warrantable__c+' srt.SRT_Time__c>>:'+srt.SRT_Time__c+' srt.Type__c--'+srt.Type__c+' olapHrs>>:'+olapHrs+' SRT_Time_Formula__c>>:'+srt.SRT_Time_Formula__c);
                        system.debug('SRT Time*Quantity-->'+((srt.Repair_Access_Calculated__c!=null?srt.Repair_Access_Calculated__c:0) * srt.SRT_Quantity__c));
                        system.debug('srtTotalQuantity-->'+srtTotalQuantity);
                        system.debug('SRT OlapHrs*Quantity-->'+((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                        system.debug('SRT Warrantable %-->'+double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                        if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == '')
                            tempSRT.Extended_Hours__c = (( (srt.Repair_Access_Calculated__c!=null?srt.Repair_Access_Calculated__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                        //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs);
                        else
                            tempSRT.Extended_Hours__c = ( ((srt.Repair_Access_Calculated__c!=null?srt.Repair_Access_Calculated__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) ) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                        //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                    }
                    else if(srt.Type__c == 'Diagnosis'){
                        system.debug('Diagnosis getExtendedHours SRTId: '+srt.SRT_ID__c+' SRT_Quantity__c:'+srt.SRT_Quantity__c+' SRT_Warrantable__c>:'+srt.SRT_Warrantable__c+' srt.SRT_Time__c>>:'+srt.SRT_Time__c+' srt.Type__c--'+srt.Type__c+' olapHrs>>:'+olapHrs+' SRT_Time_Formula__c>>:'+srt.SRT_Time_Formula__c+' srt.Account_Code__c>>:'+srt.Account_Code__c);
                        system.debug('SRT Time*Quantity-->'+((srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c));
                        system.debug('srtTotalQuantity-->'+srtTotalQuantity);
                        system.debug('SRT OlapHrs*Quantity-->'+((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                        system.debug('SRT Warrantable %-->'+double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);

                        if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == '')
                            tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                        //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs);
                        else
                            tempSRT.Extended_Hours__c = ( ((srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) ) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                        //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                    }
                    else if(srt.Type__c == 'Access'){
                        system.debug('Access getExtendedHours SRTId: '+srt.SRT_ID__c+' SRT_Quantity__c:'+srt.SRT_Quantity__c+' SRT_Warrantable__c>:'+srt.SRT_Warrantable__c+' srt.SRT_Time__c>>:'+srt.SRT_Time__c+' srt.Type__c--'+srt.Type__c+' olapHrs>>:'+olapHrs+' SRT_Time_Formula__c>>:'+srt.SRT_Time_Formula__c);
                        system.debug('SRT Time*Quantity-->'+((srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c));
                        system.debug('srtTotalQuantity-->'+srtTotalQuantity);
                        system.debug('SRT OlapHrs*Quantity-->'+((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                        system.debug('SRT Warrantable %-->'+double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                        if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == '')
                            tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                        //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs);
                        else
                            tempSRT.Extended_Hours__c = ( ((srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) ) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                        //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                    }
                    else if(srt.Type__c == '99Time'){
                        system.debug('in 99Time ');
                        srt.Account_Code__c=srt.Account_Code_Description__c; //Added the single line as per story #185705,-By RAJESH June 5th 2019
                       // system.debug('****srt.Account_Code__c***'+srt.Account_Code__c);
                        if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == ''){
                            //system.debug('****enter inside if with out Account code ***');
                            tempSRT.Extended_Hours__c = (( (srt.SRT_Time__c!=null?srt.SRT_Time__c:0) * srt.SRT_Quantity__c) - 0);
                           // system.debug('****enter inside if with out Account code tempSRT.Extended_Hours__c ***'+tempSRT.Extended_Hours__c);
                        }
                        else{
                            //system.debug('****enter inside if with Account code ***');
                            tempSRT.Extended_Hours__c = (( (srt.SRT_Time__c!=null?srt.SRT_Time__c:0) * srt.SRT_Quantity__c) - 0) * (double.valueof(srt.SRT_Warrantable__c)/100);
                            //system.debug('****enter inside if with Account code tempSRT.Extended_Hours__c ***'+tempSRT.Extended_Hours__c);
                        }
                    } 
                    else if(srt.Type__c == 'Field Action' || srt.Type__c == 'Field Action Access'){ //ATC Campaign TRP
                        tempSRT.Id = srt.Id;
                        system.debug('Field Actions srt.Type__c-->'+srt.Type__c);
                        try{
                            if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == '')
                                tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) );
                            else{
                                system.debug('***srt.SRT_Time_Formula__c***'+srt.SRT_Time_Formula__c);
                                system.debug('***srt.SRT_Quantity__c***'+srt.SRT_Quantity__c);
                                system.debug('***srtTotalQuantity***'+srtTotalQuantity);
                                system.debug('***olapHrs***'+olapHrs);
                                tempSRT.Extended_Hours__c = ( ((srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) ) * (double.valueof(srt.SRT_Warrantable__c)/100);
                            system.debug('***tempSRT.Extended_Hours__c***'+tempSRT.Extended_Hours__c);
                            }
                            Decimal toround = tempSRT.Extended_Hours__c; //3.14159265
                            tempSRT.Extended_Hours__c = css_utility.getCustomRoundValue(toround);
                            srtListToUpd.put(tempSRT.Id,tempSRT);
                            system.debug('Field Actions Ext Hrs:'+tempSRT.Extended_Hours__c+' SRT_ID__c:'+srt.SRT_ID__c+' SRT_Time__c:'+ srt.SRT_Time__c+' SRT_Quantity__c:'+srt.SRT_Quantity__c+' SRT_Warrantable__c:'+srt.SRT_Warrantable__c);
                        }
                        catch(exception ex){
                            system.debug('22 Inside Catch--'+ex.getMessage()+' '+ex.getLineNumber());
                            //to skip only this record if value is null
                        }
                    }else{
                        system.debug('Repair getExtendedHours SRTId: '+srt.SRT_ID__c+' SRT_Quantity__c:'+srt.SRT_Quantity__c+' SRT_Warrantable__c>:'+srt.SRT_Warrantable__c+' srt.SRT_Time__c>>:'+srt.SRT_Time__c+' srt.Type__c--'+srt.Type__c+' olapHrs>>:'+olapHrs+' SRT_Time_Formula__c>>:'+srt.SRT_Time_Formula__c);
                        system.debug('SRT Time*Quantity-->'+((srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c));
                        system.debug('srtTotalQuantity-->'+srtTotalQuantity);
                        system.debug('SRT OlapHrs*Quantity-->'+((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                        system.debug('SRT Warrantable %-->'+double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                        if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == '')
                            tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                        //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs);
                        else
                            tempSRT.Extended_Hours__c = ( ((srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) ) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                        //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);

                    }
                    system.debug('before roundUp -- tempSRT.Extended_Hours__c-->'+tempSRT.Extended_Hours__c);
                    Decimal toround = tempSRT.Extended_Hours__c; //3.14159265
                    /* //Decimal rounded = toround.setScale(1);
                    Decimal rounded = toRound.setScale(1, RoundingMode.HALF_UP);
                    system.debug('rounded>>:'+rounded+' before roundUp tempSRT.Extended_Hours>>:'+tempSRT.Extended_Hours__c);
                    tempSRT.Extended_Hours__c = rounded; */
                    tempSRT.Extended_Hours__c = css_utility.getCustomRoundValue(toround);
                    srtListToUpd.put(tempSRT.Id,tempSRT);
                }
                catch(exception ex){
                    system.debug('else Inside Catch--'+ex.getMessage()+' '+ex.getLineNumber());
                    //to skip only this record if value is null
                }
            }

        }catch (exception exc){
            system.debug('catch exception in getExtendedHours from JobplansrtController class at line number '+exc.getLineNumber()+' with error message '+exc.getMessage());
        }     
    }


    //Building logic for duplicate SRTs based on SRT Code/Account Code with AccessCode/%Requested
    public void buildDuplicateAccessCodesLogic(){
        List<CSS_SRT__c> srtList;
        try{
            /*srtList = new List<CSS_SRT__c>([Select Id,Step_Id__c,SRT_ID__c,Access_Code__c,Access_Code_Saved__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,SRT_Warrantable__c,
                                            Job_Order__c, Type__c, SRT_Type__c, FailCode__c, isPerformed__c, SRT_AccessiblityCheck__c, AccountCode_Formula__c,Account_Code__c, Job_Order__r.AccessCode__c,
                                            Solution_Number__c, Solution_Number__r.Diagnostic_Response__c,Component_Id__c,Assignment__c,Component_Id__r.Type__c,
                                            Component_Id__r.Performed_Review__c,Component_Id__r.Status__c,Component_Id__r.Complete_Indicator__c,
                                            Component_Id__r.Multiple_Times__c,isPopupSRT__c,srt_category__c 
                                            from css_srt__c where job_order__c =:workJob.Id and SRT_ID__c !=null and SRT_ID__c !='0' 
                                            and type__c !='Overlap']);*/
            srtList=[select Id,Step_Id__c,Name,SRT_ID__c,Access_Code__c,Access_Code_Saved__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,SRT_Warrantable__c,
                     AccountCode_Formula__c,Account_Code__c,FailCode__c,Job_Order__r.Name,Component_Id__c ,Type__c,SRT_Type__c,isPerformed__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__c,
                     SRT_Title__c ,SRT_Quantity__c from CSS_SRT__c where CSS_Claims__c=null and SRT_ID__c != '' and SRT_ID__c != '0' and Job_Order__c =: Wid and
                     AccountCode_Formula__c !=null and AccountCode_Formula__c !='Select One' and (SRT_AccessiblityCheck__c = true or isPerformed__c = true) and type__c !='Overlap' and 
                     (((Solution_Number__c != null and Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' 
                        and (Type__c = 'Diagnosis' or Type__c = 'Diag Access' //Diag end
                             or (Component_Id__c != null and Assignment__c IN ('Primary', 'Progressive Damage','Alternative') 
                                 and (Type__c = 'Repair Access' or Type__c='Repair'))))
                       or (Solution_Number__c = null and (srt_category__c='AdditionalDiag' or srt_category__c='AdditionalRep'))) //Repair end second square 
                      or (Assignment__c != 'NOT CLAIMABLE' and Assignment__c != 'NOT APPLICABLE' AND Assignment__c != 'UNLISTED' 
                          and Component_Id__r.Type__c IN ('Campaign','TRP','ATC') and Component_Id__r.Performed_Review__c = true 
                          and Component_Id__r.Status__c='Approved' and ((Component_Id__r.Complete_Indicator__c=true 
                                                                         and Component_Id__r.Multiple_Times__c=true) or (Component_Id__r.Complete_Indicator__c=false 
                                                                                                                         and Component_Id__r.Multiple_Times__c=true) or (Component_Id__r.Complete_Indicator__c=false 
                                                        and Component_Id__r.Multiple_Times__c=false))) 
                      or (Solution_Number__c = null and component_id__c = null and isPopupSRT__c = true 
                          and srt_category__c IN ('Campaign','TRP','ATC')) //Field Actions end
                      or Type__c = '99Time')];
            system.debug('buildDuplicateAccessCodesLogic loading... ***srtList size:'+srtList.size());

            String errorMsgs = '';
            if(srtList != null && srtList.size()>0){
                errorMsgs = CG_UtilityForSRT.buildDuplicateAccessCodesLogic(srtList,true,false);
            }
            system.debug('errorMsgs>>>:'+errorMsgs);
            //update Job with SRT errorMsgs
            if(workJob !=null){
                workJob.DupAccessCodePercentReqMsg__c = errorMsgs;
                update workJob;
            }

        }catch (exception ex){
            system.debug('catch exception in buildDuplicateAccessCodesLogic from JobplansrtController class at line number>:'+ex.getLineNumber()+' with error message '+ex.getMessage());
        } 
    }


    //List<CSS_SRT__c> lstSRTinsert = new List<CSS_SRT__c>();    
    public CSS_BMS_SRTReq req;
    public void sendSRTsToBMS(String OrderType,String ReferenceNumber){
        //String BMSErrorMsg;
        CSS_jobPlanInboundJSON2Apex jobPlanRespWO = new CSS_jobPlanInboundJSON2Apex();
        try{
            system.debug('***inside sendSRTsToBMS showErrorBMS:'+showErrorBMS);
            List<css_srt__c> srtList = new List<css_srt__c>();
            if (OrderType=='WO') {
                srtList = [Select id, CreatedById, LastModifiedById,type__c,Account_Code__c,SRT_Category__c, Diagnosis_Time__c,SRT_Select__c,
                           SRT_Estimate__c,SRT_Decimal_Time__c, srt_time__c, job_order__c ,SRT_Quantity__c ,SRT_ID__c,isPerformed__c,SRT_Notes__c, 
                           SRT_Warrantable__c,Component_Id__r.Claim_Type__c,Component_Id__r.Selected_Claim_Type__c, Component_Id__c,Diag_Access_Time__c,Repair_Access_Calculated__c,
                           Repair_Time__c,Access_Code_Saved__c from css_srt__c where job_order__c =: Wid  
                           and SRT_ID__c !=null and SRT_ID__c !='0' and (SRT_AccessiblityCheck__c = true or isPerformed__c = true) and SRT_Estimate__c = false 
                           and ((Solution_number__r.Diagnostic_Response__c IN ('Most likely the solution', 'Not the solution') and Type__c IN ('Admin','Diagnosis','Repair','Diag Access','Repair Access','99Time','Field Action')) 
                                or (SRT_Category__c IN ('AdditionalDiag','AdditionalRep')) or Type__c IN ('Field Action','Field Action Access'))]; 
            }
            system.debug('***srtList size:'+srtList.size()+'***srtList:'+srtList);
            if(!srtList.isEmpty() && srtList !=null){
                BMSErrorMsg = '';
                req = new CSS_BMS_SRTReq();
                CSS_BMS_SRTReq.Header headerDetails = new CSS_BMS_SRTReq.Header();                               
                CSS_BMS_SRTReq.Sender senderDetails = new CSS_BMS_SRTReq.Sender();            
                senderDetails.SenderID = 'CSS';
                senderDetails.ServiceName = 'SetJobPlan';                        
                headerDetails.Sender = senderDetails;

                CSS_BMS_SRTReq.Target targetDetails = new CSS_BMS_SRTReq.Target();            
                targetDetails.TargetID = 'BMS';           
                headerDetails.Target = targetDetails;            

                CSS_BMS_SRTReq.Location locationDetails = new CSS_BMS_SRTReq.Location();            
                locationDetails.LocationID = workJob.Creator_Location__c;           
                headerDetails.Location = locationDetails;

                req.Header = headerDetails;

                //To Send SRTs to BMS
                List<CSS_BMS_SRTReq.DataArea> dt = new List<CSS_BMS_SRTReq.DataArea>();

                for(CSS_SRT__c srtRec:srtList){
                    CSS_BMS_SRTReq.DataArea DTA = new CSS_BMS_SRTReq.DataArea();
                    String SRT = srtRec.SRT_ID__c;
                    String[] SRTId;
                    String GroupNum;
                    String ProcedureNum;
                    String StepNum;
                    String DistributorCode;
                    String BranchCode;
                    String CreateUser;
                    String ChangeUser;
                    String AccCode;

                    if(SRT!=null && SRT!='')
                        SRTId= SRT.split('-');
                    if(SRTId != null && SRTId.size()>0){
                        GroupNum = SRTId[0];
                        if(SRTId.size()>1)
                            ProcedureNum = SRTId[1];
                        if(SRTId.size()>2)
                            StepNum =  SRTId[2];
                    }

                    User crtdUser = css_utility.getUserAttributes(srtRec.CreatedById);
                    CreateUser = crtdUser.FederationIdentifier;

                    User mdfdUser = css_utility.getUserAttributes(srtRec.LastModifiedById);
                    ChangeUser = mdfdUser.FederationIdentifier;

                    if(workJob.Name==null){
                        system.debug('***inside WRKJB'+workJob.Name);
                        DTA.CSSJobID = '';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('CSSJobID'))
                            BMSErrorMsg += 'CSSJobID is blank. Please enter value.<br/>';
                    }
                    else
                        DTA.CSSJobID = workJob.Name;

                    if(workJob.Creator_Location__c==null){
                        system.debug('***inside WRKcl'+workJob.Creator_Location__c);
                        DTA.Location = '';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('Location'))
                            BMSErrorMsg += 'Location is blank. Please enter value.<br/>';
                    }
                    else
                        DTA.Location = workJob.Creator_Location__c;

                    if (workJob.Creator_Location__c != null){
                        DistributorCode = workJob.Creator_Location__c.LEFT(5);
                        BranchCode = workJob.Creator_Location__c.RIGHT(5);
                    }

                    if(OrderType==null){    
                        DTA.OrderType = '';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('OrderType'))
                            BMSErrorMsg += 'OrderType is blank. Please enter value.<br/>';
                    }
                    else
                        DTA.OrderType = OrderType;

                    if(ReferenceNumber==null){
                        DTA.ShopWOnumber = '';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('ShopWOnumber'))
                            BMSErrorMsg += 'ShopWOnumber is blank. Please enter value.<br/>';
                    }
                    else    
                        DTA.ShopWOnumber = ReferenceNumber;


                    if (srtRec.Access_Code_Saved__c==null){
                        DTA.Accesscode = '';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('AccessCode'))
                            BMSErrorMsg += 'AccessCode is blank. Please enter value.<br/>';

                    }
                    else    
                        DTA.Accesscode = srtRec.Access_Code_Saved__c;

                    if(workJob.Qsol_Engine_Family_Code__c==null){
                        DTA.Model='';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('Model'))
                            BMSErrorMsg += 'Model is blank. Please enter value.<br/>';
                    }
                    else
                        DTA.Model = workJob.Qsol_Engine_Family_Code__c;

                    if(GroupNum==null){
                        DTA.SRTgroupnum='';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('SRTgroupnum'))
                            BMSErrorMsg += 'SRTgroupnum is blank. Please enter value.<br/>';
                    }
                    else    
                        DTA.SRTgroupnum = GroupNum;

                    //BMSErrorMsg += 'Procedureno is blank. Please enter value.<br/>'+GroupNum+ProcedureNum+StepNum;
                    if(ProcedureNum==null){
                        DTA.Procedureno ='';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('Procedureno'))
                            BMSErrorMsg += 'Procedureno is blank. Please enter value.<br/>';
                    }
                    else
                        DTA.Procedureno = ProcedureNum;

                    if (StepNum==null){
                        DTA.Stepnumber ='';
                    }
                    else
                        DTA.Stepnumber = StepNum;

                    if(srtRec.SRT_Quantity__c==null){
                        DTA.SRTquantity='';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('SRTquantity'))
                            BMSErrorMsg += 'SRTquantity is blank. Please enter value.<br/>';
                    }
                    else
                        DTA.SRTquantity = string.valueof(srtRec.SRT_Quantity__c);                    

                    DTA.Bill = 'Y';

                    if(srtRec.Diagnosis_Time__c==null){
                        DTA.SRTTime = '0'; 
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('SRTTime'))
                            BMSErrorMsg += 'SRTTime is blank. Please enter value.<br/>';
                    }
                    else{
                        //DTA.SRTTime = string.valueof(srtRec.SRT_Decimal_Time__c); Commented by Rajesh Narra on 6/12/2018 Removed the single quotes during sit 
                        DTA.SRTTime = (srtRec.Type__c == 'Diagnosis' ? string.valueof(srtRec.Diagnosis_Time__c) : srtRec.Type__c == 'Diag Access' ? string.valueof(srtRec.Diag_Access_Time__c) : srtRec.Type__c == 'Repair Access' ? string.valueof(srtRec.Repair_Access_Calculated__c) : srtRec.Type__c == 'Repair' ? string.valueof(srtRec.Repair_Time__c) : (srtRec.SRT_Time__c!=null) ? String.valueOf(srtRec.SRT_Time__c) : '0.0'); 
                        System.debug('** SRT TIme'+DTA.SRTTime);
                        System.debug('** Type'+srtRec.Type__c);
                    }
                    if(workJob.Service_Model__c=='' || workJob.Service_Model__c==null) 
                        DTA.ServiceModelName = '';    
                    else
                        DTA.ServiceModelName = workJob.Service_Model__c;

                    if(srtRec.SRT_Notes__c=='' || srtRec.SRT_Notes__c==null) 
                        DTA.Note = '';    
                    else
                        //DTA.Note = srtRec.SRT_Notes__c;
                        DTA.Note = '';

                    if(srtRec.Account_Code__c == null){
                        DTA.AccountCode ='';
                    }
                    else
                        DTA.AccountCode = srtRec.Account_Code__c.RIGHT(2);

                    if(srtRec.Component_Id__c !=null){
                        if(srtRec.Component_Id__r.Selected_Claim_Type__c == null){
                            DTA.ClaimType='';
                        }
                        else
                            DTA.ClaimType = srtRec.Component_Id__r.Selected_Claim_Type__c;
                    }


                    if(srtRec.SRT_Warrantable__c=='' || srtRec.SRT_Warrantable__c==null){
                        DTA.WarrantyAllocation = '0'; 
                    }
                    else
                        DTA.WarrantyAllocation = srtRec.SRT_Warrantable__c;

                    if(CreateUser == null){
                        DTA.CreateUser ='';
                    }
                    else
                        DTA.CreateUser = CreateUser;

                    if(ChangeUser == null){
                        DTA.ChangeUser ='';
                    }
                    else
                        DTA.ChangeUser = ChangeUser;

                    dt.add(DTA);

                }
                system.debug('dt --->'+dt);
                req.DataArea = dt;
                system.debug('req>>>>>>>'+req);
                system.debug('req.DataArea********'+req.DataArea);

                // dt.SRT = srtSelctdList;

               
                //showErrorBMS = false;
                if(showErrorBMS == false){
                    jobPlanRespWO = CSS_WS_BMS.callJobPlanInboundService(req);
                    BMSSuccessMsg = jobPlanRespWO.Header.ReturnCodeDescription;
                    if(BMSSuccessMsg.contains('Error')){
                        system.debug('inside error****'+BMSSuccessMsg.contains('Error'));
                        showSucessBMS = false;
                        showErrorBMS = true;
                        BMSErrorMsg = 'Send to ERP failed. Please retry or contact Guidanz@cummins.com';

                    }
                    else
                        showSucessBMS = true;
                    system.debug('in sendSRTsToBMS showsuccessBMS>>>>>>>'+showSucessBMS);
                    system.debug('in sendSRTsToBMS showsuccessBMS>>>>>>>'+BMSSuccessMsg);
                    system.debug('in sendSRTsToBMS showErrorBMS>>>>>>>'+showErrorBMS);
                    system.debug('in sendSRTsToBMS BMSErrorMsg********'+BMSErrorMsg);
                    system.debug('jobPlanRespWO+++++++++++++'+jobPlanRespWO);
                    if(jobPlanRespWO !=null && jobPlanRespWO.Header!=null && jobPlanRespWO.Header.Status!=null && jobPlanRespWO.Header.Status=='SUCCESS')
                    {
                        if(workJob.BMSStatus__c !=null && workJob.BMSStatus__c.trim() !=''){
                            workJob.BMSStatus__c = workJob.BMSStatus__c + ','+'WOJI0';
                        }else {
                            workJob.BMSStatus__c = 'WOJI0';
                        }
                        system.debug('BMSStatus__c+++++++++++++'+workJob.BMSStatus__c);
                    }//else need to clear WOJI0 if WOJI0 is already present
                    else
                        workJob.BMSStatus__c = workJob.BMSStatus__c.replaceAll('WOJI0','');
                }


            }
            else{
                system.debug('Error Report--No Required Input Data present');
            }

        }
        catch(exception ex){
            showErrorBMS=true;
            BMSErrorMsg = 'Send to ERP failed. Please retry or contact Guidanz@cummins.com';
            system.debug('Debug inside sendSRTsToBMS exception -->' + ex.getMessage()+ '***'+ex.getLineNumber());
        }
    }

    public CSS_BMS_SRTReq reqWOQT;
    public void sendSRTsToBMSWOQT(String OrderType){
        String BMSErrorMsgWOQT=''; //added new criteria for WOQT
        //String quoteNumber;
        showErrorBMS = false; //added new criteria for WOQT
        CSS_jobPlanInboundJSON2Apex jobPlanRespWOQT = new CSS_jobPlanInboundJSON2Apex();
        try{
            system.debug('***inside sendSRTsToBMSWOQT showErrorBMS:'+showErrorBMS);
            List<css_srt__c> srtListWOQT = new List<css_srt__c>();
            List<css_srt__c> srtListWOQT_Temp = new List<css_srt__c>();
            //List<CSS_Quote__c> quoteLst = new List<CSS_Quote__c>();
            if (OrderType=='WOQT') {           
                /*quoteLst = [Select id, name, OrderReference__c, Service_Job__c from CSS_Quote__c where Service_Job__c =: Wid order by createdDate desc limit 1];
                if(!quoteLst.isEmpty() && quoteLst !=null){
                    quoteNumber = quoteLst[0].OrderReference__c;
                }*/

                srtListWOQT_Temp = [Select id, CreatedById, LastModifiedById,type__c,Account_Code__c,SRT_Category__c, Diagnosis_Time__c,SRT_Select__c,
                                    SRT_Estimate__c,SRT_Decimal_Time__c, srt_time__c, Extended_Hours__c, job_order__c ,SRT_Quantity__c ,SRT_ID__c,isPerformed__c,SRT_Notes__c, 
                                    SRT_Warrantable__c,Component_Id__r.Claim_Type__c,Component_Id__r.Selected_Claim_Type__c, Component_Id__c,Access_Code_Saved__c,Diag_Access_Time__c,
                                    Repair_Access_Calculated__c,Repair_Time__c,Claim_Type__c from css_srt__c where job_order__c =:Wid and SRT_ID__c !=null and SRT_ID__c !='0'
                                    and (SRT_AccessiblityCheck__c = true or isPerformed__c = true) and
                                    ((Solution_number__r.Diagnostic_Response__c IN ('Most likely the solution', 'Not the solution') 
                                      and Type__c IN ('Admin','Diagnosis','Repair','Diag Access','Repair Access','Field Action')) 
                                     or (SRT_Category__c IN ('AdditionalDiag','AdditionalRep')) or Type__c IN ('Field Action','Field Action Access','99Time','Private'))];//Removed 99Time from first set and added in next set//Story 152192 updated by Agassi
                system.debug('***srtListWOQT_Temp size:'+srtListWOQT_Temp.size());
            }
            Map<String, List<Decimal>> groupByQty = new Map<String, List<Decimal>>();
            Map<String, List<Decimal>> groupByExtHours = new Map<String, List<Decimal>>();
            Set<Id> srtUniqueId = new Set<Id>();
            for(CSS_SRT__c srtQty : srtListWOQT_Temp){
                List<String> srtIdLst = new List<String>();
                srtIdLst = srtQty.SRT_ID__c.split('-');
                String tempSRTId;
                if(srtIdLst.size() > 1){
                    tempSRTId = srtIdLst[0] + srtIdLst[1];
                }
                system.debug('tempSRTId -->>>'+tempSRTId);
                if(tempSRTId != '99999'){
                    if(!groupByQty.containsKey(tempSRTId)){
                        List<Decimal> templst = new List<Decimal>();
                        List<Decimal> templstExtHrs = new List<Decimal>();
                        templst.add(srtQty.SRT_Quantity__c);
                        templstExtHrs.add(srtQty.Extended_Hours__c);
                        groupByQty.put(tempSRTId,templst);
                        groupByExtHours.put(tempSRTId,templstExtHrs);
                        srtUniqueId.add(srtQty.Id);
                    }
                    else{
                        List<Decimal> templst = groupByQty.get(tempSRTId);
                        List<Decimal> templstExtHrs = groupByExtHours.get(tempSRTId);
                        templst.add(srtQty.SRT_Quantity__c);
                        templstExtHrs.add(srtQty.Extended_Hours__c);
                        groupByQty.put(tempSRTId,templst);
                        groupByExtHours.put(tempSRTId,templstExtHrs);
                    }
                }
                else{
                    if(srtQty.isPerformed__c == true){
                        List<Decimal> templst = new List<Decimal>();
                        List<Decimal> templstExtHrs = new List<Decimal>();
                        templst.add(srtQty.SRT_Quantity__c);
                        templstExtHrs.add(srtQty.Extended_Hours__c);
                        groupByQty.put(tempSRTId,templst);
                        groupByExtHours.put(tempSRTId,templstExtHrs);
                        srtUniqueId.add(srtQty.Id);
                    }
                }
            }
            system.debug('map -->'+groupByQty);
            srtListWOQT = [Select id, CreatedById, LastModifiedById,type__c,Account_Code__c,SRT_Category__c, Diagnosis_Time__c,SRT_Select__c,
                           SRT_Estimate__c,SRT_Decimal_Time__c, srt_time__c, job_order__c ,SRT_Quantity__c ,SRT_ID__c,isPerformed__c,SRT_Notes__c, 
                           SRT_Warrantable__c,Component_Id__r.Claim_Type__c,Component_Id__r.Selected_Claim_Type__c, Component_Id__c,Access_Code_Saved__c,Diag_Access_Time__c,
                           Repair_Access_Calculated__c,Extended_Hours__c, Repair_Time__c,Claim_Type__c from css_srt__c where job_order__c =:Wid and Id in: srtUniqueId and SRT_ID__c !=null and SRT_ID__c !='0'
                           and (SRT_AccessiblityCheck__c = true or isPerformed__c = true) and
                           ((Solution_number__r.Diagnostic_Response__c IN ('Most likely the solution', 'Not the solution') 
                             and Type__c IN ('Admin','Diagnosis','Repair','Diag Access','Repair Access','Field Action')) 
                            or (SRT_Category__c IN ('AdditionalDiag','AdditionalRep')) or Type__c IN ('Field Action','Field Action Access','99Time','Private'))];//Story 152192 updated by Agassi
           // system.debug('***srtListWOQT size:'+srtListWOQT.size()+'***srtListWOQT:'+srtListWOQT+' workJob.Quote_ID__c:'+workJob.Quote_ID__c);
            if(!srtListWOQT.isEmpty() && srtListWOQT !=null){
                BMSErrorMsg = '';
                reqWOQT = new CSS_BMS_SRTReq();
                CSS_BMS_SRTReq.Header headerDetails = new CSS_BMS_SRTReq.Header();                               
                CSS_BMS_SRTReq.Sender senderDetails = new CSS_BMS_SRTReq.Sender();            
                senderDetails.SenderID = 'CSS';
                senderDetails.ServiceName = 'SetJobPlan';                        
                headerDetails.Sender = senderDetails;

                CSS_BMS_SRTReq.Target targetDetails = new CSS_BMS_SRTReq.Target();            
                targetDetails.TargetID = 'BMS';           
                headerDetails.Target = targetDetails;            

                CSS_BMS_SRTReq.Location locationDetails = new CSS_BMS_SRTReq.Location();            
                locationDetails.LocationID = workJob.Creator_Location__c;           
                headerDetails.Location = locationDetails;

                reqWOQT.Header = headerDetails;

                //To Send SRTs to BMS
                List<CSS_BMS_SRTReq.DataArea> dt = new List<CSS_BMS_SRTReq.DataArea>();
                for(CSS_SRT__c srtRec:srtListWOQT){
                    CSS_BMS_SRTReq.DataArea DTA = new CSS_BMS_SRTReq.DataArea();
                    String SRT = srtRec.SRT_ID__c;
                    String[] SRTId;
                    String GroupNum;
                    String ProcedureNum;
                    String StepNum;
                    String DistributorCode;
                    String BranchCode;
                    String CreateUser;
                    String ChangeUser;
                    String AccCode;

                    if(SRT!=null && SRT!='')
                        SRTId= SRT.split('-');
                    if(SRTId != null && SRTId.size()>0){
                        GroupNum = SRTId[0];
                        if(SRTId.size()>1)
                            ProcedureNum = SRTId[1];
                        if(SRTId.size()>2)
                            StepNum =  SRTId[2];
                    }

                    User crtdUser = css_utility.getUserAttributes(srtRec.CreatedById);
                    CreateUser = crtdUser.FederationIdentifier;

                    User mdfdUser = css_utility.getUserAttributes(srtRec.LastModifiedById);
                    ChangeUser = mdfdUser.FederationIdentifier;

                    if(workJob.Name==null){
                        system.debug('***inside WRKJB'+workJob.Name);
                        DTA.CSSJobID = '';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('CSSJobID'))
                            BMSErrorMsg += 'CSSJobID is blank. Please enter value.<br/>';
                    }
                    else
                        DTA.CSSJobID = workJob.Name;

                    //Claim Type Code is added by Rajesh Narra on 7-3-2018 during SIT
                    /*if(srtRec.Claim_Type__c!=null && srtRec.Claim_Type__c!=''){
                        DTA.ClaimType = srtRec.Claim_Type__c;
                    }else{
                        DTA.ClaimType = '';
                    }*/

                    if(workJob.Creator_Location__c==null){
                        system.debug('***inside WRKcl'+workJob.Creator_Location__c);
                        DTA.Location = '';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('Location'))
                            BMSErrorMsg += 'Location is blank. Please enter value.<br/>';
                    }
                    else
                        DTA.Location = workJob.Creator_Location__c;

                    if (workJob.Creator_Location__c != null){
                        DistributorCode = workJob.Creator_Location__c.LEFT(5);
                        BranchCode = workJob.Creator_Location__c.RIGHT(5);
                    }

                    if(OrderType==null){    
                        DTA.OrderType = '';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('OrderType'))
                            BMSErrorMsg += 'OrderType is blank. Please enter value.<br/>';
                    }
                    else
                        DTA.OrderType = OrderType;

                    if(workJob.Quote_ID__c==null){
                        DTA.ShopWOnumber = '';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('Order Reference Number'))
                            BMSErrorMsg += 'Order Reference Number is blank. Please enter value.<br/>';
                    }else if(workJob.Quote_ID__c !=null && workJob.Quote_ID__c !=''){   
                        DTA.ShopWOnumber = workJob.Quote_ID__c;
                    }else{
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('Order Reference Number'))
                            BMSErrorMsg += 'Order Reference Number is blank. Please enter value.<br/>';
                    }

                    if(srtRec.Type__c != '99Time'){
                        if (srtRec.Access_Code_Saved__c==null){
                            DTA.Accesscode = '';
                            showErrorBMS = true;
                            if(!BMSErrorMsg.contains('AccessCode'))
                                BMSErrorMsg += 'AccessCode is blank. Please enter value.<br/>';
                        }
                        else    
                            DTA.Accesscode = srtRec.Access_Code_Saved__c;
                    }
                    else
                    {
                        if (srtRec.Access_Code_Saved__c==null){
                            DTA.Accesscode = '';
                        }
                        else{
                            DTA.Accesscode = srtRec.Access_Code_Saved__c;
                        }
                    }


                    if(workJob.Qsol_Engine_Family_Code__c==null){
                        DTA.Model='';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('Model'))
                            BMSErrorMsg += 'Model is blank. Please enter value.<br/>';
                    }
                    else
                        DTA.Model = workJob.Qsol_Engine_Family_Code__c;

                    if(GroupNum==null){
                        DTA.SRTgroupnum='';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('SRTgroupnum'))
                            BMSErrorMsg += 'SRTgroupnum is blank. Please enter value.<br/>';
                    }
                    else    
                        DTA.SRTgroupnum = GroupNum;

                    if(ProcedureNum==null){
                        DTA.Procedureno ='';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('Procedureno'))
                            BMSErrorMsg += 'Procedureno is blank. Please enter value.<br/>';
                    }
                    else
                        DTA.Procedureno = ProcedureNum;

                    if (StepNum==null){
                        DTA.Stepnumber ='';
                    }
                    else
                        DTA.Stepnumber = StepNum;

                    //if(srtRec.Type__c != '99Time'){
                    if(srtRec.SRT_Quantity__c==null){
                        DTA.SRTquantity='';
                        showErrorBMS = true;
                        if(!BMSErrorMsg.contains('SRTquantity'))
                            BMSErrorMsg += 'SRTquantity is blank. Please enter value.<br/>';
                    }
                    else{
                        system.debug('SRT ID-->'+srtRec.SRT_ID__c);
                        List<String> srtIdLst = new List<String>();
                        srtIdLst = srtRec.SRT_ID__c.split('-');
                        String tempSRTId;
                        if(srtIdLst.size() > 1){
                            tempSRTId = srtIdLst[0] + srtIdLst[1];
                        }
                        system.debug('tempSRTId-->'+tempSRTId);
                        List<Decimal> templst = groupByQty.get(tempSRTId);
                        system.debug('templst-->'+templst.size());
                        if(templst.size() > 1){
                            Decimal quantitySum = 0.0;
                            for(Decimal srtQtyAddition : templst){
                                quantitySum = quantitySum + srtQtyAddition;
                            }
                            DTA.SRTquantity = string.valueof(quantitySum);
                            system.debug('quantitySum-->'+quantitySum);
                        }
                        else{
                            DTA.SRTquantity = string.valueof(srtRec.SRT_Quantity__c);
                        }
                    }
                    /*}
                    else{
                        if(srtRec.SRT_Quantity__c==null){
                            DTA.SRTquantity='0';
                        }
                        else{
                            DTA.SRTquantity = string.valueof(srtRec.SRT_Quantity__c); 
                        }
                    }*/

                    DTA.Bill = 'Y';
                    //Commented as part of the story #152505
                    /*if(srtRec.Type__c != '99Time'){
                        if(srtRec.Diagnosis_Time__c==null){
                            DTA.SRTTime = '0'; 
                            showErrorBMS = true;
                            if(!BMSErrorMsg.contains('SRTTime'))
                                BMSErrorMsg += 'SRTTime is blank. Please enter value.<br/>';
                        }
                        else{
                            //DTA.SRTTime = string.valueof(srtRec.SRT_Decimal_Time__c); Commented by Rajesh Narra on 6/12/2018 Removed the single quotes during sit 
                            DTA.SRTTime = (srtRec.Type__c == 'Diagnosis' ? string.valueof(srtRec.Diagnosis_Time__c) : srtRec.Type__c == 'Diag Access' ? string.valueof(srtRec.Diag_Access_Time__c) : srtRec.Type__c == 'Repair Access' ? string.valueof(srtRec.Repair_Access_Calculated__c) : srtRec.Type__c == 'Repair' ? string.valueof(srtRec.Repair_Time__c) : (srtRec.SRT_Time__c!=null) ? String.valueOf(srtRec.SRT_Time__c) : '0.0'); 
                            System.debug('** SRT TIme'+DTA.SRTTime);
                            System.debug('** Type'+srtRec.Type__c);
                        }
                    }
                    else{
                        DTA.SRTTime = '0';
                    }*/
                    //Added as part of the story #152505
                    //if(srtRec.Type__c != '99Time'){
                    if(srtRec.Type__c != '99Time' && srtRec.Type__c != 'Private'){
                        system.debug('SRTType**'+srtRec.Type__c);
                            if(srtRec.Extended_Hours__c==null){
                            DTA.SRTTime = '0'; 
                            showErrorBMS = true;
                            if(!BMSErrorMsg.contains('SRTTime'))
                                BMSErrorMsg += 'SRTTime is blank. Please enter value.<br/>';
                        }
                        else{
                            system.debug('SRT ID-->'+srtRec.SRT_ID__c);
                            List<String> srtIdLst = new List<String>();
                            srtIdLst = srtRec.SRT_ID__c.split('-');
                            String tempSRTId;
                            if(srtIdLst.size() > 1){
                                tempSRTId = srtIdLst[0] + srtIdLst[1];
                            }
                            system.debug('tempSRTId-->'+tempSRTId);
                            List<Decimal> templst = groupByExtHours.get(tempSRTId);
                            system.debug('templst-->'+templst.size());
                            if(templst.size() > 1){
                                Decimal extHrsSum = 0.0;
                                for(Decimal srtHrsAddition : templst){
                                    extHrsSum = extHrsSum + srtHrsAddition;
                                }
                                DTA.SRTTime = string.valueof(extHrsSum);
                                system.debug('extHrsSum-->'+extHrsSum);
                            }
                            else{
                                DTA.SRTTime = string.valueof((srtRec.Extended_Hours__c != null ? srtRec.Extended_Hours__c : 0.0));
                            }
                        }
                    }
                    else{
                        if(srtRec.Type__c == '99Time')
                            DTA.SRTTime = string.valueof(srtRec.SRT_Time__c);
                        else
                            DTA.SRTTime = '0';
                    }

                    if(workJob.Service_Model__c=='' || workJob.Service_Model__c==null) 
                        DTA.ServiceModelName = '';    
                    else
                        DTA.ServiceModelName = workJob.Service_Model__c;

                    if(srtRec.SRT_Notes__c=='' || srtRec.SRT_Notes__c==null) 
                        DTA.Note = '';    
                    else
                        //DTA.Note = srtRec.SRT_Notes__c;
                        DTA.Note = '';

                    if(srtRec.Account_Code__c == null || srtRec.Type__c == 'Private'){//Story 152192 updated by Agassi
                        DTA.AccountCode ='';
                    }
                    else
                        DTA.AccountCode = srtRec.Account_Code__c.RIGHT(2);

                    if(srtRec.Type__c == 'Private'){ //Story 152192 updated by Agassi
                        if(srtRec.claim_type__c == null)
                            DTA.ClaimType='';
                    }else{
                        if(srtRec.claim_type__c != null){
                            DTA.ClaimType = srtRec.claim_type__c;
                        }else {
                            DTA.ClaimType = '';
                        }
                    }


                    if(srtRec.SRT_Warrantable__c=='' || srtRec.SRT_Warrantable__c==null){
                        DTA.WarrantyAllocation = '0'; 
                    }
                    else
                        DTA.WarrantyAllocation = srtRec.SRT_Warrantable__c;

                    if(CreateUser == null){
                        DTA.CreateUser ='';
                    }
                    else
                        DTA.CreateUser = CreateUser;

                    if(ChangeUser == null){
                        DTA.ChangeUser ='';
                    }
                    else
                        DTA.ChangeUser = ChangeUser;

                    dt.add(DTA);

                }
                system.debug('dt --->'+dt);
                reqWOQT.DataArea = dt;
                system.debug('req>>>>>>>'+reqWOQT);
                system.debug('req.DataArea********'+reqWOQT.DataArea);

                // dt.SRT = srtSelctdList;

                system.debug('in WOQT showErrorBMS>>>>>>>'+showErrorBMS);
                system.debug('in WOQT BMSErrorMsgWOQT********'+BMSErrorMsgWOQT);
                if(showErrorBMS == false){
                    jobPlanRespWOQT = CSS_WS_BMS.callJobPlanInboundService(reqWOQT);
                    BMSSuccessWOQTMsg = jobPlanRespWOQT.Header.ReturnCodeDescription;
                    if(BMSSuccessWOQTMsg.contains('Error')){
                        system.debug('inside error****'+BMSSuccessWOQTMsg.contains('Error'));
                        showSucessBMS = false;
                        showErrorBMS = true;
                        BMSErrorMsg = 'Send to ERP failed. Please retry or contact Guidanz@cummins.com';

                    }
                    else
                        showSucessBMS = true;
                    if(jobPlanRespWOQT !=null && jobPlanRespWOQT.Header!=null && jobPlanRespWOQT.Header.Status!=null && jobPlanRespWOQT.Header.Status=='SUCCESS')
                    {
                        if(workJob.BMSStatus__c !=null && workJob.BMSStatus__c.trim() !=''){
                            workJob.BMSStatus__c = workJob.BMSStatus__c + ','+'QTJI0';
                        }else {
                            workJob.BMSStatus__c = 'QTJI0';
                        }
                        system.debug('BMSStatus__c+++++++++++++:'+workJob.BMSStatus__c);
                    }//else need to clear QTJI0 if QTJI0 is already present
                    else
                        workJob.BMSStatus__c = workJob.BMSStatus__c.replaceAll('QTJI0','');
                }


            }
            else{
                showErrorBMS = true;
                system.debug('Error Report');
            }


        }
        catch(exception ex){
            showErrorBMS=true;
            BMSErrorMsg = 'Send to ERP failed. Please retry or contact Guidanz@cummins.com';
            system.debug('Debug inside sendSRTsToBMSWOQT exception -->' + ex.getMessage()+ '***'+ex.getLineNumber());
        }
        /*if(BMSErrorMsg !=null && BMSErrorMsg !='')
            BMSErrorMsg += BMSErrorMsgWOQT;
        else
            BMSErrorMsg = BMSErrorMsgWOQT;*/

    }

    public void sendSRTsToBMSWO(){
        if(Wid != null){
            system.debug('about to call ODM SRT Service**'+Wid);
            Boolean errorFlag = CG_BL_ODM.callODMSRTServices('Job',Wid);
            system.debug('After call ODM SRT Service**'+errorFlag);
            // CG_BL_ODM.callODMSRTServices('Job',Wid);
            //sendSRTsToBMS('WO',workJob.Shop_Work_Order__c); //commented bcz removing Estimate column
            if(!errorFlag)
                sendSRTsToBMSWOQT('WOQT');
            CG_BL_ODM.updateODMSRTServiceResponse();
        }
    }

    public void checkDuplicateSRTs(){
        Map<String,List<CSS_SRT__c>> dupSRTMap = new Map<String,List<CSS_SRT__c>>();
        list<CSS_srt__c> lstSRTDupCheck = new list<CSS_srt__c>();
        String ESRTDCLValues = Label.CG_ExcludeSRTsDuplicateCheck;
        List<String> excludeSRTsDuplicateCheckList = new List<String>();
        if(ESRTDCLValues != null && ESRTDCLValues != '') {
            excludeSRTsDuplicateCheckList = ESRTDCLValues.split(',');
        }
        lstSRTDupCheck=[select name,SRT_ID__c,Job_Order__r.Name,id,step_id__c,Component_Id__c ,Type__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__c,
                        SRT_Title__c ,isPerformed__c,SRT_Quantity__c from CSS_SRT__c where CSS_Claims__c=null and SRT_ID__c != '' and SRT_ID__c != '0' 
                        and Job_Order__c =: Wid and (((Solution_Number__c != null and (Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' or Solution_Number__r.Diagnostic_Response__c = 'Not the solution') 
                                                       and (Type__c = 'Diagnosis' or Type__c = 'Diag Access' or Type__c = 'Repair Access' or (Component_Id__c != null and Assignment__c IN ('Primary', 'Progressive Damage','Alternative') and (Type__c='Repair')))) 
                                                      or (Solution_Number__c = null and (srt_category__c='AdditionalDiag' or srt_category__c='AdditionalRep'))) 
                                                     or (Assignment__c != 'NOT CLAIMABLE' and Assignment__c != 'NOT APPLICABLE' AND Assignment__c != 'UNLISTED' and Component_Id__r.Type__c IN ('Campaign','TRP','ATC') 
                                                         and Component_Id__r.Performed_Review__c = true and Component_Id__r.Status__c='Approved' and ((Component_Id__r.Complete_Indicator__c=true 
                        and Component_Id__r.Multiple_Times__c=true) OR (Component_Id__r.Complete_Indicator__c=false and Component_Id__r.Multiple_Times__c=true) 
                                                                                                                                                      or (Component_Id__r.Complete_Indicator__c=false and Component_Id__r.Multiple_Times__c=false))) 
                                                     or (Solution_Number__c = null and component_id__c = null and isPopupSRT__c = true and srt_category__c IN ('Campaign','TRP','ATC')))];
        system.debug('****lstSRTDupCheck****'+lstSRTDupCheck.size());
        List<CSS_SRT__c> tempList;
        for(CSS_SRT__c srtObj: lstSRTDupCheck){
            if(dupSRTMap.containsKey(srtObj.SRT_ID__c.LEFT(6))){
                tempList = dupSRTMap.get(srtObj.SRT_ID__c.LEFT(6));
                tempList.add(srtObj);
                dupSRTMap.put(srtObj.SRT_ID__c.LEFT(6), tempList);
            }
            else{
                tempList = new List<CSS_SRT__c>();
                tempList.add(srtObj);
                dupSRTMap.put(srtObj.SRT_ID__c.LEFT(6), tempList);
                //System.debug('olapSrt.SRT_ID>>:'+olapSrt.SRT_ID__c+' olapSrt.Calculated_Claimed_Hours=======>'+olapSrt.Calculated_Claimed_Hours__c);
            }
        }
        tempList = new List<CSS_SRT__c>();
        system.debug('****dupSRTMap****'+dupSRTMap.size()+'*****'+dupSRTMap);
        system.debug('****keysetsize****'+dupSRTMap.keySet().size());
        for(String srtKey: dupSRTMap.keySet()){
            tempList = dupSRTMap.get(srtKey);
            system.debug('****srtKey****'+srtKey+'*****'+tempList.size());
            Boolean isSelected;
            String srtID;
            if(tempList.size()<=1)
                continue;
            Integer count=0;
            for(CSS_SRT__c srtObj: tempList){
                if((srtObj.SRT_AccessiblityCheck__c == true || srtObj.isPerformed__c == true) && excludeSRTsDuplicateCheckList!=null && !(excludeSRTsDuplicateCheckList.contains(srtObj.SRT_ID__c.LEFT(6)))){
                    srtID=srtKey;
                    //isSelected=true;
                    count=count+1;
                    system.debug('***insideif1111***');
                }
                else{
                    system.debug('***insideelse2222**');
                    isSelected=false;
                    //break;
                }
            }
            if(count>1){
                isSelected=true;
            }
            if(!dupSRTMsg.contains(srtKey) && isSelected==true){
                dupSRTMsg.add(srtKey);
            }

        }
        system.debug('*****dupSRTMsg****'+dupSRTMsg);
        if(dupSRTMsg != null && dupSRTMsg.size()>0){
            string tempStr;
            for(string s: dupSRTMsg){
                if(tempStr==null)
                    tempStr=s;
                else
                    tempStr=tempStr+', '+s;
            }
            workJob.DuplicateSRTDetails__c=tempStr;
        }
        else
            workJob.DuplicateSRTDetails__c='';
    }


    //Wrapper class to maintain the data related to overlapSRt s-109748
    public class overLapSrtWrapper{

        public string SRT_Code{get;set;}
        public string SRT_Description{get;set;}
        public double OverlapSRTTime{get;set;}///mapped with SRTHours from response
        public boolean overide{get;set;}
        public string SRT_Time{get;set;}
        public string SRT_Notes{get;set;}
        public string SRT_OverrideReason{get;set;}
        public double SRT_Overlap{get;set;}
        public String Id{get;set;}

        public overLapSrtWrapper(){

        }
    }
}