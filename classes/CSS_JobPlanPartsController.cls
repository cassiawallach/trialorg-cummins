/*
 * Block comments with details of changes
 */
public class CSS_JobPlanPartsController {

    public string workjobStatus;
    public Integer complaintcounter{set;get;}
    public Integer coveragecounter{set;get;}
    public Integer causecounter{set;get;}
    public Integer correctioncounter{set;get;}
    public boolean accQuoteFlag{set; get;} 
    public string NotesBody {get;set;} 
    public id recTypeIdpart ;
    public list<CSS_Parts_Options__c> sendparts;
    public list<string> faultList {get; set;}
    public list<string> partlist {get; set;}
    public list<string> partlistFAULT {get; set;}
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
    public Boolean displayPartsButton{get;set;}
    public Boolean displayPartsButtonDist{get;set;}
    public boolean displayERPButtonDlr{get;set;}
    public boolean displaySendERP_Button{get;set;}
    public boolean showErrorERP{get;set;}
    public String ERPErrorMsg{set;get;}
    public String ERPErrorMsg1{set;get;}
    public boolean showSucessERP{get;set;}
    public String ERPSuccessMsg{set;get;}
    public boolean PartShowSucessERP{get;set;}
    public String ERPSuccessMsgParts{get;set;}
    public CG_cancelServiceJobWrapper cancelSJWrapperObj1{get;set;}
    public  boolean isDealer{get;set;}
    public Boolean showResolutionRequired{get;set;}//ROD Defect 179167 Added by Rajesh Narra 
    public Boolean showRepairRequired {get;set;}//ROD Defect 179167 Added by Rajesh Narra

    public void mainSOQL(){
        /* workJob=[Select Id,Name,AccessCode__c,Account__r.ERP_System__c,Quote_ID__c,BMSWSStatus__c,BMSStatus__c,Customer_Name__c,Cstmr_Contacts_Phone__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                 Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                 DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,EditComplaint__c,EditCorrection__c,EditCoverage__c,EditCause__c,
                 Phone_Number__c, Previous_Status__c,Sub_Type__c, Category__c, Category_Desc__c, Complaint_Type__c, Complaint_Type_Desc__c, Model__c,Creator_Location__c, Control_Number__c,Equipment_ID__c,
                 Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c, CSS_Job_Location_Code__c, CSS_Resolution__c,CSS_Feedback_Comments__c,
                 ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Actual_Technician_Time__c,ApplicationCode__c
                 from CSS_Job_Order__c where id= :Wid]; */


        //Added Engine and SP data in query as part of ODM
        workJob=[Select Id,Name,PACCAR_Auth_Required__c,ODM_Status_Message__c,AccessCode__c,Automotive_App_Flag__c,Account__r.Type,Account__c,Account__r.ERP_System__c,CSS_Channel_Code__c,Sp_TERRITORY__c,Quote_ID__c,BMSWSStatus__c,BMSStatus__c,Customer_Name__c,Cstmr_Contacts_Phone__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, 
                 Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,Repair_Location__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                 DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c,SP_WarrantyCertificationEndDate__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,EditComplaint__c,EditCorrection__c,EditCoverage__c,EditCause__c,Phone_Number__c, Previous_Status__c,Sub_Type__c,Sub_Status__c, Category__c, 
                 Category_Desc__c, Complaint_Type__c, Complaint_Type_Desc__c, Model__c,Creator_Location__c, Control_Number__c,Equipment_ID__c,Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c, CSS_Job_Location_Code__c, 
                 CSS_Resolution__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_Country__c,EngineFamilyName__c,CSS_Feedback_Comments__c,ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Actual_Technician_Time__c,ApplicationCode__c,
                 DesignPhaseCode__c,warrantyIndicatorFlag__c,SP_PrimaryOEMCode__c,SP_OutfileAllClaims__c,ProductApplicationDesp__c,Contact_ID__c,SP_PACCAR__c,SP_Region__c,SP_RegionCode__c,SP_AccountStatus__c,SP_TerritoryCode__c,BillToCode__c,BuildDate__c,
                 Email_Address__c,Before_In_Service__c,MarineFlag__c,OemCode__c,EtoConversionDate__c,ProductApplicationCode__c,CSS_Channel_Of_Distribution__c,SP_ClaimAllowedDays__c,SP_CMISPExpirationDate__c,SP_LTAFlag__c,Territory_Class_Name__c,SP_SCMDeductiblePercentage__c,SP_WarrantyTrainingStatus__c,SP_SCMDollarAmt__c,SP_State__c,SRT_902_Error_Message__c
                 from CSS_Job_Order__c where id= :Wid];
    }

    public CSS_JobPlanPartsController() {
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        workjobStatus=ApexPages.CurrentPage().getParameters().get('status');
        showResolutionRequired = false;//Added by Rajesh Narra
        showRepairRequired = false;//Added by Rajesh Narra
        //displayPartsButton = css_utility.getclaimsapprove(UserInfo.getUserId());
        //string partsUr = ApexPages.CurrentPage().getParameters().get('joPa');
        try {
            mainSOQL();

            displayPartsButtonDist = false;

            css_header_nav__c CS = css_header_nav__c.getInstance(UserInfo.getProfileId()); 

            string userId = UserInfo.getUserId();

            bmsEnabled=css_utility.getBMSEnabled(workJob.Creator_Location__c);
            displayPartsButton = css_utility.showQuotePage(UserInfo.getUserId(), workJob.Creator_Location__c);
            /*String orgtype = css_utility.getOrgType(UserInfo.getUserId());
               if(orgtype == 'DISTR'){
                  displayPartsButtonDist = false;  
               }
                else {
                  displayPartsButtonDist = true;   
                }*/
            isDealer = false;
            /*String userType = css_utility.getOrgType(UserInfo.getUserId());
            if(userType =='DLR'){
                isDealer = true;   
            }else if(userType == 'DISTR'){
                isDealer = false;   
            }*/
            isDealer=css_utility.getAccounttype(workJob.Account__r.Type);
            if(workJob != null && workJob.Account__c != null && workJob.Account__r.ERP_System__c != null && workJob.Account__r.ERP_System__c=='One BMS' && isDealer != true)
                displayPartsButtonDist = true;
            displaySendERP_Button = css_utility.getclaimsapprove(UserInfo.getUserId());
            system.debug('displaySendERP_Button-->'+displaySendERP_Button);
            system.debug('bmsEnabled - Intake'+bmsEnabled);
            showJobPlanBlocks(false,false,true,false, false,false,false);
        }
        catch(Exception e)  {
            system.debug('Entered into catch block of css_jobplanpartscontroller>>>>'+e.getmessage() + ' ' + e.getLinenumber());
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
        if (prt_stat)
        {
            jo_btn_cls = 'chev_jpo_img_open';
            srt_btn_cls = 'chev_jpsrt_img_open';
            prt_btn_cls = 'chev_jpparts_img_active';
            war_btn_cls = 'chev_wr_img_open';
            nar_btn_cls = 'chev_jpnarrative_img_open';//check
            qt_btn_cls = 'chev_jpquote_img_open';

            jo_chv_sts = 'sopen';
            srt_chv_sts = 'sopen';
            prt_chv_sts = 'sactive';
            war_chv_sts = 'sopen';
            nar_chv_sts = 'sopen';
            qt_chv_sts = 'sopen';

            jo_txt_sts =  'chev_text_open';
            srt_txt_sts =  'chev_text_open';
            prt_txt_sts =  'chev_text_active';
            war_txt_sts =  'chev_text_open';
            nar_txt_sts =  'chev_text_open';
            qt_txt_sts =  'chev_text_open';

            jo_txt_val = '';
            srt_txt_val = '';
            prt_txt_val = 'History';
            war_txt_val = '';
            nar_txt_val = '';
            qt_txt_val = '';
        }
    }

    /*********End Method for Chevrons Initialization *****/

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
                
                //Admin SRT 00-902-00 error message logic below
				CG_UtilityForSRT.executeAdminSRT902LogicForJob(Wid, workJob);
            }
        } 


        PageReference pageRef = new pageReference('/apex/CSS_JobPlanParts?id='+wid); 
        pageRef.setRedirect(true);
        return pageRef;
    } 

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
                
                //Admin SRT 00-902-00 error message logic below
				CG_UtilityForSRT.executeAdminSRT902LogicForJob(Wid, workJob);
            }
        } 
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanSRT?id='+worecord.id); 
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
                
                //Admin SRT 00-902-00 error message logic below
				CG_UtilityForSRT.executeAdminSRT902LogicForJob(Wid, workJob);
            }
        } 
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanWarranty?id='+worecord.id); 
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

                //Admin SRT 00-902-00 error message logic below
				CG_UtilityForSRT.executeAdminSRT902LogicForJob(Wid, workJob);
            }
            
        }
        PageReference pageRef = new pageReference('/apex/CSS_JobPlan?id='+worecord.id); 
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
                
                //Admin SRT 00-902-00 error message logic below
				CG_UtilityForSRT.executeAdminSRT902LogicForJob(Wid, workJob);
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
                
                //Admin SRT 00-902-00 error message logic below
				CG_UtilityForSRT.executeAdminSRT902LogicForJob(Wid, workJob);
            }
        } 
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanQuote?id='+worecord.id); 
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

    public void updatestatus(){
        system.debug('inside the method after page load');
        //parts();
        if(workJob.status__c!='Job Plan' && workJob.status__c!='Repair'){
            workJob.Previous_Status__c=workJob.Status__c;
            workJob.status__c='Job Plan';
            system.debug('inside the method after page load&&&&&&&&&');

            update  workJob; 
            //TO Fetch Warranty Dertails


        }
    }
    public void updateSubstatus()
    {
        //This method will called after the Parts send to BMS successfully Button.
        system.debug('Sub Status for the job' +workJob.Sub_Status__c);
        if(workJob.Sub_Status__c == null || workJob.Sub_Status__c != null){
            workJob.Sub_Status__c = 'Waiting for Parts from ERP';
            system.debug('Sub Status after if'+workJob.Sub_Status__c);
            //After changing th Sub Status it will update the WorkJob.
            update workJob;
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
            //Defect Fix - 75783
            worecord.Status__c='Job Plan';
            // Defect fix 59457
            system.debug('partShowSucessERP' + ' ' + partShowSucessERP);
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
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        cancelSJWrapperObj1.errorFlag = false;
        cancelSJWrapperObj1.errorMessage = '';
        cancelSJWrapperObj1.serviceJob = workJob;
        displayClosePopup=false;
    }

    public PageReference closeSession(){
        system.debug('insideCLoseSession***');
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
                System.debug('**closeJob.CSS_CampTsbTrp__r**'+closeJob.CSS_CampTsbTrp__r);
                System.debug('**closeJob**'+closeJob);
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
    public void onChangeOfUnitNumber(){
        /*** On Tab of Unit Number in Job Plan call Unit Inbound ******/
        callUnitInboundGeneric();
        if(workjob != null){
            update workjob;
        }  
    }
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


    public void updateservjob(){
        system.debug('--do--');
        if(workjob != null){
            update workjob;
        }  

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
    

    public boolean showRepairErrorMessage{get;set;}
    list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();
    public boolean showResolutionWithRepair{get;set;}
    public Boolean requiredBMSMessage {get;set;}
    

    public PageReference saveAndCloseJob()
        //void to  PageReference switch is done by  Roopa defect number 178147
    {
         System.debug('Entered saveAndCloseJob');
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
                    System.debug('44'+responseValues);
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
                        system.debug('Positive Val **'+negatPosRepairs.size()+'Negative Vals **'+negatRepairs.size());
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



    //function to send Part and Claimables to BMS
    public void sendPartsAndClaimablesToERP(){

        if(wid!=null){
            sendPartsToERP();
            sendOtherClaimableToERP();
            System.debug('showErrorERP'+showErrorERP);
            System.debug('errorMsg'+ERPErrorMsg);
        }
    }

    //function to send the GSQ Parts to ERP
    public void sendPartsToERP(){

        try{
            List<css_parts_options__c> partList = new list<css_parts_options__c>();
            // List<CSS_Solutions__c> solutionDetails = new List<CSS_Solutions__c>(); Commnted by Rajesh Narra for SIT Session

            ERPErrorMsg = '';
            showErrorERP = false;
            PartShowSucessERP = false;
            ERPSuccessMsgParts = '';

            CSS_getPartsListBMSRequestJ2A partListReq = new CSS_getPartsListBMSRequestJ2A();
            List<CSS_getPartsListBMSRequestJ2A.cls_PartDetails> partDetailsList = new List<CSS_getPartsListBMSRequestJ2A.cls_PartDetails>();

            if(Wid!=null){


                //Get all the Solutions along with component and parts
                /* solutiondetails = [Select id,Name,Solution_title__c,CSS_Nested_Solutions__c,
                           (Select id,name,Selected_Component__c,Component_Id__c,Service_Job__c,Solutions__c,Solutions__r.Name ,
                           Solutions__r.Solution_title__c,Fail_Code__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c,FailCode_Formula__c
                           from CSS_Solution_Components__r where Solutions__r.Diagnostic_Response__c='Most likely the solution' ),
                           (Select id,Option_Number__c,Service_Job__c,Replacement_Reason__c,Option_ESN__c,selected_part__c,Css_Estimate__c,
                           FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Selected_Component__c,Notes__c,Solutions__c,
                           RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Covered__c,Service_partnumber__c,
                           ReturnToFactory__c,Fail_Code__c,CreatedById,Warranty_Allocation__c,Claim_Type__c,LastModifiedById,Account_Code__c,FailurepartId__r.CSS_Account_Formula__c,FailurepartId__r.AccountCode__c 
                           from CSS_Parts_Options__r where Part_Assignment__c = 'Primary' order by Part_Name__c)
                           from CSS_Solutions__c where Diagnostic_Response__c='Most likely the solution' and Service_Job__c = :workJob.id order by LastModifiedDate desc];
               */ //Commented the by Rajesh Narra during claims SIT

                partList = [Select id,Option_Number__c,Service_Job__c,Unit_Price__c,Sell_Price__c,Replacement_Reason__c,Option_ESN__c,selected_part__c,Css_Estimate__c,
                            FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Selected_Component__c,Notes__c,Solutions__c,
                            RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Covered__c,Service_partnumber__c,
                            ReturnToFactory__c,Fail_Code__c,CreatedById,Warranty_Allocation__c,Claim_Type__c,LastModifiedById,Account_Code__c,FailurepartId__r.CSS_Account_Formula__c,FailurepartId__r.AccountCode__c,Misc_LOV__c,Siebel_Value__c 
                            from CSS_Parts_Options__c where  RecordType.Name='Parts' and selected_part__c=true and Service_Job__c =:workJob.id and Parts_Type__c != 'Custom' order by Part_Name__c];
            }


            list<css_parts_options__c> lstEstimatedpart = new list<css_parts_options__c>();

            //system.debug('solutiondetails**'+solutiondetails);
            //condition if solutions exist
            /*if(solutiondetails.size()>0){

                //creating the JSON Request Wrapper
                CSS_getPartsListBMSRequestJ2A.cls_Header headerDetails = new CSS_getPartsListBMSRequestJ2A.cls_Header();                               
                CSS_getPartsListBMSRequestJ2A.cls_Sender senderDetails = new CSS_getPartsListBMSRequestJ2A.cls_Sender();            
                senderDetails.SenderID = 'CSS';
                senderDetails.ServiceName = 'SendGSQParts';                        
                headerDetails.Sender = senderDetails;

                CSS_getPartsListBMSRequestJ2A.cls_Target targetDetails = new CSS_getPartsListBMSRequestJ2A.cls_Target();            
                targetDetails.TargetID = 'BMS';           
                headerDetails.Target = targetDetails;            

                CSS_getPartsListBMSRequestJ2A.cls_Location locationDetails = new CSS_getPartsListBMSRequestJ2A.cls_Location();            
                locationDetails.LocationID = workJob.Creator_Location__c;           
                headerDetails.Location = locationDetails;

                partListReq.Header = headerDetails;

                //To Send Parts to BMS
                CSS_getPartsListBMSRequestJ2A.cls_DataArea DTA = new CSS_getPartsListBMSRequestJ2A.cls_DataArea();

                //Validations before sending to ERP
                if(workJob.Name==null){
                    showErrorERP = true;
                    if(!ERPErrorMsg.contains('CSSJobID'))
                        ERPErrorMsg += 'CSSJobID is blank. Please enter value.<br/>';
                }
                else
                    DTA.CSSJobID = workJob.Name;

                if(workJob.Creator_Location__c==null){

                    showErrorERP = true;
                    if(!ERPErrorMsg.contains('DistributorCode') && !ERPErrorMsg.contains('BranchCode')){
                        ERPErrorMsg += 'DistributorCode is blank. Please enter value.<br/>'; 
                        ERPErrorMsg += 'BranchCode is blank. Please enter value.<br/>';
                    }    

                }
                else{
                    DTA.DistributorCode = workJob.Creator_Location__c.LEFT(5);
                    DTA.DistributorBranchCode = workJob.Creator_Location__c.RIGHT(5);
                    //lstLocCodes = workJob.Creator_Location__c.split('-'); 

                }

                if(workjob.Quote_ID__c==null){
                    showErrorERP = true;
                    if(!ERPErrorMsg.contains('Order Reference Number'))
                        ERPErrorMsg += 'Order Reference Number is blank. Please enter value.<br/>';

                }
                else
                    DTA.BMSQuoteID = workjob.Quote_ID__c;

                DTA.OrderType = 'WOQT';
                String CreateUser;
                String ChangeUser;

                //loop through all the Solutions 
                for(CSS_Solutions__c sol: solutiondetails){

                    for(CSS_Solution_Component__c c : sol.CSS_Solution_Components__r ){

                        for(CSS_Parts_Options__c part : sol.CSS_Parts_Options__r){
                            //match the part's Component ID with Solutions Component ID 
                            if(c.Id == part.FailurepartId__c){
                                //check if it selected to send to ERP
                                if(part.selected_part__c==true){

                                    User crtdUser = css_utility.getUserAttributes(part.CreatedById);
                                    CreateUser = crtdUser.FederationIdentifier;

                                    User mdfdUser = css_utility.getUserAttributes(part.LastModifiedById);
                                    ChangeUser = mdfdUser.FederationIdentifier;
                                    //create the dataArea partlist  of request wrapper
                                    CSS_getPartsListBMSRequestJ2A.cls_PartDetails partDetails = new CSS_getPartsListBMSRequestJ2A.cls_PartDetails();
                                    if(part.OEM__c == null){
                                        partDetails.ProductCodeOEM = '';
                                         showErrorERP = true;
                                        if(!ERPErrorMsg.contains('OEM'))
                                            ERPErrorMsg += 'OEM is blank. Please enter value.<br/>';

                                    }
                                    else
                                        partDetails.ProductCodeOEM = part.OEM__c;

                                    if(part.Service_partnumber__c == null){
                                        partDetails.PartNumberService = '';
                                         showErrorERP = true;
                                        if(!ERPErrorMsg.contains('Service Part Number'))
                                            ERPErrorMsg += 'Service Part Number is blank. Please enter value.<br/>';

                                    }
                                    else
                                        partDetails.PartNumberService = part.Service_partnumber__c;


                                    if(part.Quantity__c == null){
                                        partDetails.Quantity = 0;
                                        showErrorERP = true;
                                        if(!ERPErrorMsg.contains('Quantity'))
                                            ERPErrorMsg += 'Quantity is blank. Please enter value.<br/>';

                                    }
                                    else
                                        partDetails.Quantity = Integer.ValueOf(part.Quantity__c);

                                    system.debug('AllocationWarranty'+ part.Warranty_Allocation__c);
                                    if(part.Warranty_Allocation__c==null){
                                        partDetails.AllocationWarranty = 0;    

                                    } 
                                    else
                                        partDetails.AllocationWarranty = Integer.ValueOf(part.Warranty_Allocation__c);

                                    if(part.Account_Code__c==null){
                                        partDetails.AccountCode = '';
                                    }
                                    else
                                        partDetails.AccountCode = part.Account_Code__c;  

                                    system.debug('part.Claim_Type__c'+ part.Claim_Type__c);
                                    if(part.Claim_Type__c==null){
                                        partDetails.ClaimType = '';
                                    }
                                    else
                                        partDetails.ClaimType = part.Claim_Type__c;

                                    if(CreateUser == null){
                                        partDetails.CreateUser ='';
                                    }
                                    else
                                        partDetails.CreateUser = CreateUser;

                                    if(ChangeUser == null){
                                        partDetails.ChangeUser ='';
                                    }
                                    else
                                        partDetails.ChangeUser = ChangeUser; 

                                    partDetails.PartsPricing = 0;    


                                    partDetailsList.add(partDetails);

                                }
                            }    
                        }
                    } 

                }

                DTA.PartDetails = partDetailsList;
                partListReq.DataArea = DTA;


            }    */

            if(partList!=null && partList.size()>0){
                CSS_getPartsListBMSRequestJ2A.cls_Header headerDetails = new CSS_getPartsListBMSRequestJ2A.cls_Header();                               
                CSS_getPartsListBMSRequestJ2A.cls_Sender senderDetails = new CSS_getPartsListBMSRequestJ2A.cls_Sender();

                senderDetails.SenderID = 'CSS';
                senderDetails.ServiceName = 'SendGSQParts';                        
                headerDetails.Sender = senderDetails;

                CSS_getPartsListBMSRequestJ2A.cls_Target targetDetails = new CSS_getPartsListBMSRequestJ2A.cls_Target();            
                targetDetails.TargetID = 'BMS';           
                headerDetails.Target = targetDetails;

                CSS_getPartsListBMSRequestJ2A.cls_Location locationDetails = new CSS_getPartsListBMSRequestJ2A.cls_Location();            
                locationDetails.LocationID = workJob.Creator_Location__c;           
                headerDetails.Location = locationDetails;

                partListReq.Header = headerDetails;

                CSS_getPartsListBMSRequestJ2A.cls_DataArea DTA = new CSS_getPartsListBMSRequestJ2A.cls_DataArea();

                //Validations before sending to ERP
                if(workJob.Name==null){
                    showErrorERP = true;
                    if(!ERPErrorMsg.contains('CSSJobID'))
                        ERPErrorMsg += 'CSSJobID is blank. Please enter value.<br/>';
                }
                else
                    DTA.CSSJobID = workJob.Name;

                if(workJob.Creator_Location__c==null){

                    showErrorERP = true;
                    if(!ERPErrorMsg.contains('DistributorCode') && !ERPErrorMsg.contains('BranchCode')){
                        ERPErrorMsg += 'DistributorCode is blank. Please enter value.<br/>'; 
                        ERPErrorMsg += 'BranchCode is blank. Please enter value.<br/>';
                    }    

                }
                else{
                    DTA.DistributorCode = workJob.Creator_Location__c.LEFT(5);
                    DTA.DistributorBranchCode = workJob.Creator_Location__c.RIGHT(5);
                    //lstLocCodes = workJob.Creator_Location__c.split('-'); 

                }

                if(workjob.Quote_ID__c==null){
                    showErrorERP = true;
                    if(!ERPErrorMsg.contains('Order Reference Number'))
                        ERPErrorMsg += 'Order Reference Number is blank. Please enter value.<br/>';

                }
                else
                    DTA.BMSQuoteID = workjob.Quote_ID__c;

                DTA.OrderType = 'WOQT';
                String CreateUser;
                String ChangeUser;

                //Loop through all selected parts

                for(CSS_Parts_Options__c part : partList ){
                    User crtdUser = css_utility.getUserAttributes(part.CreatedById);
                    CreateUser = crtdUser.FederationIdentifier;
                    User mdfdUser = css_utility.getUserAttributes(part.LastModifiedById);
                    ChangeUser = mdfdUser.FederationIdentifier;
                    CSS_getPartsListBMSRequestJ2A.cls_PartDetails partDetails = new CSS_getPartsListBMSRequestJ2A.cls_PartDetails();
                    /*if(part.OEM__c == null  ){
            partDetails.ProductCodeOEM = '';
             showErrorERP = true;
          if(!ERPErrorMsg.contains('OEM'))
              ERPErrorMsg += 'OEM is blank. Please enter value.<br/>';
          }
          else*/
                    partDetails.ProductCodeOEM = part.OEM__c;

                    if(part.Service_partnumber__c == null){
                        partDetails.PartNumberService = '';
                        showErrorERP = true;
                        if(!ERPErrorMsg.contains('Service Part Number'))
                            ERPErrorMsg += 'Service Part Number is blank. Please enter value.<br/>';

                    }
                    else
                        partDetails.PartNumberService = part.Service_partnumber__c;

                    if(part.Quantity__c == null){
                        partDetails.Quantity = 0;
                        showErrorERP = true;
                        if(!ERPErrorMsg.contains('Quantity'))
                            ERPErrorMsg += 'Quantity is blank. Please enter value.<br/>';

                    }
                    else
                        partDetails.Quantity = Integer.ValueOf(part.Quantity__c);

                    system.debug('AllocationWarranty'+ part.Warranty_Allocation__c);
                    if(part.Warranty_Allocation__c==null){
                        partDetails.AllocationWarranty = 0;    

                    } 
                    else
                        partDetails.AllocationWarranty = Integer.ValueOf(part.Warranty_Allocation__c);

                    if(part.Account_Code__c==null){
                        partDetails.AccountCode = '';
                    }
                    else{

                        String AccCodePart = part.Account_Code__c;

                        partDetails.AccountCode = AccCodePart.right(2);
                    }


                    system.debug('part.Claim_Type__c'+ part.Claim_Type__c);
                    if(part.Claim_Type__c==null){
                        partDetails.ClaimType = '';
                    }
                    else
                        partDetails.ClaimType = part.Claim_Type__c;

                    if(CreateUser == null){
                        partDetails.CreateUser ='';
                    }
                    else
                        partDetails.CreateUser = CreateUser;

                    if(ChangeUser == null){
                        partDetails.ChangeUser ='';
                    }
                    else
                        partDetails.ChangeUser = ChangeUser; 

                    partDetails.PartsPricing = 0;  

                    partDetailsList.add(partDetails);

                }
                DTA.PartDetails = partDetailsList;
                partListReq.DataArea = DTA;

            }

            //check if validation fails 
            system.debug('partDetailsList' + partDetailsList);
            if(!showErrorERP && partDetailsList!=null && partDetailsList.size()>0){
                CSS_getPartsListBMSResponseJ2A WOQTOPWrap = new CSS_getPartsListBMSResponseJ2A();
                // webservice function to send parts to ERP
                WOQTOPWrap = CSS_WS_BMS.sendGSQParts(partListReq);

                system.debug('WOQTOPWrap' + WOQTOPWrap);
                String BMSSuccessWOQTMsg = '';

                BMSSuccessWOQTMsg = WOQTOPWrap.Header.ReturnCodeDescription;
                //check the response Wrapper
                if(BMSSuccessWOQTMsg.containsIgnoreCase('Error') ||  WOQTOPWrap.Header.Status=='ERROR'){
                    system.debug('inside error****'+BMSSuccessWOQTMsg);
                    partShowSucessERP = false;
                    showErrorERP = true;
                    //ERPErrorMsg = 'Send to ERP failed. Please retry or contact Guidanz@cummins.com';
                    ERPErrorMsg = BMSSuccessWOQTMsg;

                }//if success then show the success message
                else if(WOQTOPWrap !=null && WOQTOPWrap.Header!=null && WOQTOPWrap.Header.Status!=null && WOQTOPWrap.Header.Status=='SUCCESS'){
                    ERPSuccessMsgParts =  BMSSuccessWOQTMsg;
                    partShowSucessERP = true;
                    if(partShowSucessERP!=null && partShowSucessERP==true && ERPSuccessMsgParts!=null){
                        updateSubstatus();
                    }
                    showErrorERP = false;

                }

            } 

        }
        catch(Exception ex){
            partShowSucessERP = false;
            showErrorERP = true;
            ERPErrorMsg = 'Send to ERP failed. Please retry or contact Guidanz@cummins.com';
            System.debug('in catch of sendPartsToERP of GSQ >>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }

    }

    //function to send the other Claimables to ERP
    public void sendOtherClaimableToERP(){
        System.debug('Hi');
        try{
            List<css_parts_options__c> partList = new list<css_parts_options__c>();
            ERPSuccessMsg = '';

            if(Wid!=null){


                //query all other Claimables parts
                partList = [select Id, RecordType.Name,selected_part__c, Item__c,Unit_Price__c,Sell_Price__c, Part_Description__c, Quantity__c, amount__c, Covered__c,Mileage__c,
                            Fail_Code__c,Account_Code__c, Notes__c,Css_Estimate__c,Claim_Type__c,Part_Name__c,Create_User__c,Type__c,Days__c,Siebel_Value__c,
                            Change_User__c, CreatedById, LastModifiedById  from CSS_Parts_Options__c where Service_Job__c =:workJob.id and (RecordType.Name ='OtherClaimables' OR RecordType.Name ='TTML') and Service_partnumber__c=null and selected_part__c=true]; 
            }

            List<string> lstLocCodes = new list<string>();
            list<css_parts_options__c> lstSelectedPartList = new list<css_parts_options__c>();

            system.debug('otherClaimPartList**'+partList);

            //loop through all parts and check for validations   
            for(css_parts_options__c part: partList){

                //if(part.selected_part__c==true){
                if(part.selected_part__c==true && part.item__c != part.Siebel_Value__c){ // Added story 145413

                    if(part.RecordType.Name == 'TTML'){

                        if(part.Type__c.equalsignorecase('Commercial-Travel') || part.Type__c.equalsignorecase('Non Commercial-Travel')){
                            part.Quantity__c = part.Mileage__c;
                        }

                        if(part.Type__c.equalsignorecase('Lodging') || part.Type__c.equalsignorecase('Meals') || part.Type__c.equalsignorecase('Towing')){
                            part.Quantity__c = part.Days__c;

                        }

                    }
                    //validation for parts
                    if(workJob.Name==null){
                        showErrorERP = true;
                        if(!ERPErrorMsg.contains('CSSJobID'))
                            ERPErrorMsg += 'CSSJobID is blank. Please enter value.<br/>';
                    }

                    if(workJob.Creator_Location__c==null){

                        showErrorERP = true;
                        if(!ERPErrorMsg.contains('DistributorCode') && !ERPErrorMsg.contains('BranchCode')){
                            ERPErrorMsg += 'DistributorCode is blank. Please enter value.<br/>'; 
                            ERPErrorMsg += 'BranchCode is blank. Please enter value.<br/>';
                        }    

                    }
                    else{
                        lstLocCodes = workJob.Creator_Location__c.split('-');    
                    }

                    if(workjob.Quote_ID__c==null){
                        showErrorERP = true;
                        if(!ERPErrorMsg.contains('Order Reference Number'))
                            ERPErrorMsg += 'Order Reference Number is blank. Please enter value.<br/>';

                    }

                    /*if(part.Part_Name__c == null){//Code Commented by Rajesh Narra on 6/11/2018 for testing
                         showErrorERP = true;
                        if(!ERPErrorMsg.contains('Part Name'))
                            ERPErrorMsg += 'Part Name is blank. Please enter value.<br/>';

                    }*/

                    if(part.Quantity__c == null){
                        showErrorERP = true;
                        if(!ERPErrorMsg.contains('Quantity'))
                            ERPErrorMsg += 'Quantity is blank. Please enter value.<br/>';

                    }




                    lstSelectedPartList.add(part);

                }


            }
            system.debug('lstSelectedPartList' + lstSelectedPartList);
            //check for if validaiton failures this (!showErrorERP &&) condition is removed by Rajesh Narra of 6-27-2018 to make the both Sendparts and Misc call at once.
            if( lstSelectedPartList!=null && lstSelectedPartList.size()>0){
                CG_OP_OAGWrapper WOQTOPWrap = new CG_OP_OAGWrapper();
                //send the partlist to webservice
                WOQTOPWrap = cg_sl_bms.sendMISCCharges(workJob.Creator_Location__c,workJob.Name,lstLocCodes[0],lstLocCodes[1],workJob.Customer_Code__c,'WOQT',workjob.Quote_ID__c, lstSelectedPartList, 'Y'); //Rajesh Narra has changed the flag of misc change from N to Y during SIT on 6-27-2018

                String claimableWrapResp = WOQTOPWrap.response.getBody();

                //   String OAGWrapResp = '{\"Header\": {\r\n   \"ReturnCodeDescription\": \"Message If Any\",\r\n   \"Status\": \"SUCCESS\",\r\n   \"Sender\":    {\r\n      \"ServiceName\": \"sendMiscCharges \",\r\n      \"MessageID\": \"bac053ab-5b99-4301-8895-aeb67c10a2c9\",\r\n      \"SenderID\": \"CSS\"\r\n   },\r\n   \"Target\": {\"TargetID\": \"BMS\"},\r\n   \"Location\": {\"LocationID\": \"56270-56255\"}\r\n}}\r\n';

                CG_BMSSendMiscChargesRespWrapper sendMiscRespJSON = new CG_BMSSendMiscChargesRespWrapper();
                String BMSSuccessWOQTMsg = '';
                system.debug('sendMiscRespJSON' + sendMiscRespJSON);
                sendMiscRespJSON =  (CG_BMSSendMiscChargesRespWrapper)JSON.deserializeStrict(claimableWrapResp, CG_BMSSendMiscChargesRespWrapper.class);
                system.debug('WOQTOPWrap**'+sendMiscRespJSON);
                BMSSuccessWOQTMsg = sendMiscRespJSON.Header.ReturnCodeDescription;
                //check the response wrapper message for errors
                if(BMSSuccessWOQTMsg.containsIgnoreCase('Error') ||  sendMiscRespJSON.Header.Status=='ERROR'){
                    system.debug('inside error****'+BMSSuccessWOQTMsg);
                    showSucessERP = false;
                    partShowSucessERP = false;
                    showErrorERP = true;
                    //ERPErrorMsg = 'Send to ERP failed. Please retry or contact Guidanz@cummins.com';
                    ERPErrorMsg = BMSSuccessWOQTMsg;


                }//if success then show the success message 
                else if(sendMiscRespJSON !=null && sendMiscRespJSON.Header!=null && sendMiscRespJSON.Header.Status!=null && sendMiscRespJSON.Header.Status=='SUCCESS'){
                    ERPSuccessMsg =  BMSSuccessWOQTMsg;
                    //partShowSucessERP = true; 
                    showSucessERP = true;
                    showErrorERP = false;

                }

            }
            else{
                partShowSucessERP = false;    
            } 

        }
        catch(Exception ex){
            showSucessERP = false;
            showErrorERP = true;
            ERPErrorMsg = 'Send to ERP failed. Please retry or contact Guidanz@cummins.com';
            System.debug('in catch of SendOtherClaimablestoERP of OtherClaimables >>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }

    }
    //update account code in parts if account code field of solution component is modified.
    @InvocableMethod(label='updateAccountCode' description='update Account Code from Process Builder') 
    public static void updateAccountCode(List<Id> idList){
        //query parts Options record
        List<CSS_Solution_Component__c> solnCompLst = new List<CSS_Solution_Component__c>();
        List<CSS_Parts_Options__c> partsLstUpd = new List<CSS_Parts_Options__c>();
        solnCompLst = [SELECT id, Type__c, CampaignPartsPercentage__c, CoveredPartsQty_Percentage__c, CampaignOCPercentage__c, CoveredPartsQty__c, CoveredOCAmount__c, CSS_Account_Formula__c, (SELECT Id, Account_Code__c, Covered__c, RecordType.Name FROM CSS_Parts_Options__r) FROM CSS_Solution_Component__c where Id IN:idList];
        system.debug('solnComp'+solnCompLst);
        for(CSS_Solution_Component__c solcomp : solnCompLst){
            system.debug('solnComp Type'+solcomp.Type__c);
            for(CSS_Parts_Options__c prts : solcomp.CSS_Parts_Options__r){
                CSS_Parts_Options__c prtRec = new CSS_Parts_Options__c();
                if(solcomp.Type__c != null && solcomp.Type__c != '' && !solcomp.Type__c.equalsignorecase('Campaign') && !solcomp.Type__c.equalsignorecase('ATC') && !solcomp.Type__c.equalsignorecase('TRP')){
                    system.debug('Parts Record type'+prts.RecordType.Name);
                    if(prts.RecordType.Name == 'Parts'){
                        if(solcomp.CampaignPartsPercentage__c != null && solcomp.CampaignPartsPercentage__c != '' && double.valueof(solcomp.CampaignPartsPercentage__c) > 0){
                            prtRec.Id = prts.Id;
                            prtRec.Account_Code__c = solcomp.CSS_Account_Formula__c;
                            prtRec.Covered__c = solcomp.CoveredPartsQty_Percentage__c;
                            partsLstUpd.add(prtRec);
                        }
                    }
                    else if(prts.RecordType.Name == 'OtherClaimables'){
                        if(solcomp.CampaignOCPercentage__c != null && solcomp.CampaignOCPercentage__c != '' && double.valueof(solcomp.CampaignOCPercentage__c) > 0){
                            prtRec.Id = prts.Id;
                            prtRec.Account_Code__c = solcomp.CSS_Account_Formula__c;
                            prtRec.Covered__c = solcomp.CoveredPartsQty_Percentage__c;
                            partsLstUpd.add(prtRec);
                        }
                    }
                }
                else{
                    system.debug('Parts Record type'+prts.RecordType.Name);
                    if(prts.RecordType.Name == 'Parts'){
                        system.debug('solcomp.CoveredPartsQty__c'+solcomp.CoveredPartsQty__c);
                        if(solcomp.CoveredPartsQty__c != null && solcomp.CoveredPartsQty__c != '' && double.valueof(solcomp.CoveredPartsQty__c) > 0){
                            prtRec.Id = prts.Id;
                            prtRec.Account_Code__c = solcomp.CSS_Account_Formula__c;
                            prtRec.Covered__c = solcomp.CoveredPartsQty_Percentage__c;
                            partsLstUpd.add(prtRec);
                        }
                    }
                    else if(prts.RecordType.Name == 'OtherClaimables'){
                        if(solcomp.CoveredOCAmount__c != null && solcomp.CoveredOCAmount__c != '' && double.valueof(solcomp.CoveredOCAmount__c) > 0){
                            prtRec.Id = prts.Id;
                            prtRec.Account_Code__c = solcomp.CSS_Account_Formula__c;
                            prtRec.Covered__c = solcomp.CoveredPartsQty_Percentage__c;
                            partsLstUpd.add(prtRec);
                        }
                    }

                }
            }
        }
        system.debug('partsLstUpd'+partsLstUpd);
        if(partsLstUpd != null && partsLstUpd.size() > 0){
            update partsLstUpd;
        }
    }

    public void jobPlanPartsAction(){
        try{
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            contr.covLimitValidation(Wid, null, null, null);
            contr.covLimitValidationJob(Wid, null);

            //Admin SRT 00-902-00 error message logic below
            CG_UtilityForSRT.executeAdminSRT902LogicForJob(Wid, workJob);
            
        }catch(Exception ex){
            System.debug('in catch of jobPlanPartsAction of JobplanPartsController >>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    

    //Admin SRT 00-902-00 error message logic below
    /*public void executeAdminSRT902Logic(){
        try{
            //fetch Existing Admin SRT
            Boolean srt902NOTExistFlag = false;
            Boolean travelExistFlag = false;
            if(Wid != null && workJob !=null && workJob.Repair_Location__c == 'Mobile'){
                List<CSS_SRT__c> existingAdminSRT = new List<CSS_SRT__c>([select Id,step_id__c,AccountCode_Formula__c, SRT_Warrantable__c, Assignment__c FROM CSS_SRT__c 
                                                                          where Job_Order__c =:Wid AND Type__c = 'Admin' AND SRT_Type__c = 'Admin' AND srt_id__c = '00-902-00'
                                                                          Limit 1]);
                if(existingAdminSRT !=null && existingAdminSRT.size()>0 && existingAdminSRT.get(0).AccountCode_Formula__c !=null 
                   && existingAdminSRT.get(0).AccountCode_Formula__c.trim() !='' && existingAdminSRT.get(0).AccountCode_Formula__c !='Select One'){
                    CSS_SRT__c srtRec = existingAdminSRT.get(0);
                    Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
                    List<CSS_Parts_Options__c> lstParts = new List<CSS_Parts_Options__c>();
                    //Check here 902 account code formats of SRT & Parts
                    lstParts = [SELECT Id, Item__c, Account_Code__c, Get_Fail_Code_Formula__c, Fail_Code__c, RecordTypeId, Parts_Type__c 
                                FROM CSS_Parts_Options__c WHERE Service_Job__c =: Wid AND Account_Code__c != null AND Account_Code__c != '' 
                                AND Account_Code__c != 'Select One' and Account_Code__c =:srtRec.AccountCode_Formula__c 
                                AND RecordTypeId =: recTypeIdOC AND Item__c='COMMERCIAL TRAVEL' AND Parts_Type__c != 'Custom' AND selected_part__c = true];
                    if(lstParts !=null && lstParts.size()>0){
                        travelExistFlag = true;
                    }
                    if(!travelExistFlag){
                        Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
                        lstParts = [SELECT Id, Item__c, Account_Code__c, Get_Fail_Code_Formula__c, Fail_Code__c, RecordTypeId, Parts_Type__c 
                                    FROM CSS_Parts_Options__c WHERE Service_Job__c =: Wid AND Account_Code__c != null AND Account_Code__c != '' 
                                    AND Account_Code__c != 'Select One' and Account_Code__c =:srtRec.AccountCode_Formula__c 
                                    AND RecordTypeId =: recTypeIdTTML AND Parts_Type__c != 'Custom' AND selected_part__c = true];
                        if(lstParts !=null && lstParts.size()>0){
                            travelExistFlag = true;
                        }
                    }
                }else{
                    srt902NOTExistFlag = true;
                }
            }else{
                srt902NOTExistFlag = true;
            }

            //update Job with Admin SRT 00-902-00 error message
            //Checking whether 902 SRT exist along with Repair_Location__c='Mobile' or not 
            if(srt902NOTExistFlag){
                if(workJob !=null && workJob.SRT_902_Error_Message__c !=null && workJob.SRT_902_Error_Message__c.trim() !=''){
                    workJob.SRT_902_Error_Message__c = '';
                    update workJob;
                }
            }else{
                //Checking here TTML/OC Travel present or not
                if(travelExistFlag){
                    //Need to nullify SRT error message if exists
                    if(workJob !=null && workJob.SRT_902_Error_Message__c !=null && workJob.SRT_902_Error_Message__c.trim() !=''){
                        workJob.SRT_902_Error_Message__c = '';
                        update workJob;
                    }
                }else{
                    if(workJob !=null && (workJob.SRT_902_Error_Message__c ==null || workJob.SRT_902_Error_Message__c.trim() =='')){
                        workJob.SRT_902_Error_Message__c = Label.SRT_00_902_is_present_and_travel_is_not_entered; //'SRT 00-902 is present and travel is not entered';
                        update workJob;
                    }
                }
            }

        }catch(Exception ex){
            System.debug('in catch of executeAdminSRT902Logic-jobPlanPartsAction of JobplanPartsController >>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }*/


}