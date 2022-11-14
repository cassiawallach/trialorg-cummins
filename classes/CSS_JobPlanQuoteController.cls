/*
 * Block comments with details of changes
 */
public  class CSS_JobPlanQuoteController {

    public string workjobStatus;
    public boolean showErrorERP{get;set;}
    public String ERPErrorMsg{set;get;}
    public Integer complaintcounter{set;get;}
    public Integer coveragecounter{set;get;}
    public Integer causecounter{set;get;}
    public Integer correctioncounter{set;get;}
    public boolean accQuoteFlag{set; get;} 
    public string decQuoteSelectedList {get; set;}
    public string assignSelectedDeclineQuotevalue {get; set;}
    /*public string NotesBody {get;set;} 
    public id recTypeIdpart ;
    public list<CSS_Parts_Options__c> sendparts;
    public list<string> faultList {get; set;}
    public list<string> partlist {get; set;}
    public list<string> partlistFAULT {get; set;}
    public CSS_unitInboundJSON2Apex UIResp{get;set;}*/
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
    public boolean isBmsstatus {get;set;}
    public Boolean displayClosePopup {get;set;}
    public Boolean displayPopup {get;set;}
    public Boolean nocamptsbtrps{get;set;}
    public boolean showRepairs{get;set;}
    Public string datebyLocaleValue {get;set;}
    public CSS_Quote__c quote {get;set;}
    public CG_cancelServiceJobWrapper cancelSJWrapperObj1{get;set;}
    public boolean showAcceptDateError{get;set;}
    public boolean showAcceptDateError1{get;set;}
    public boolean EnableDecline{get;set;}
    public boolean ERPSuccessMsgParts{get;set;}
    public boolean declinesucessmsg{get;set;}
    public boolean Enabledeclinebutton{get;set;}
    public boolean errormsgdeclinequote{get;set;}
    public Date datetoday{get;set;}
    public List<CSS_Solution_Component__c> lstSolcom = new List<CSS_Solution_Component__c>();
    public List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
    public List<CSS_SRT__c> lstSrts = new List<CSS_SRT__c>();
    public Boolean ODMValidationForQuoteEnable {get; set;}
    Transient public list<CSS_Solution_Component__c> claimsSCList = new list<CSS_Solution_Component__c>();
    Transient public list<CSS_Parts_Options__c> claimsPOList = new list<CSS_Parts_Options__c>();
    Transient public list<CSS_SRT__c> claimsSRTList = new list<CSS_SRT__c>();
    public Map<string, list<CSS_Solution_Component__c>> SCAccountCodeMap = new Map<string, list<CSS_Solution_Component__c>>();//Account code, Solution component Records.
    public Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap = new Map<string, list<CSS_Parts_Options__c>>();//Account code+Fail Code, PART OPTION Records.
    public Map<string, list<CSS_SRT__c>> SRTAccountCodeMap = new Map<string, list<CSS_SRT__c>>();//Account code+Fail Code, PART OPTION Records.
    public List<String> partsWarranty = new List<String>();

    //public boolean showResolutionWithRepair{get;set;}
    // Added few of fields in below query as per krishna's mail, -By RAJESH 18th June 2018
     public void mainSOQL(){
         workJob=[Select Id,Name,PACCAR_Auth_Required__c,IsAppointment__c,Quote_ID__c,EngineFamilyCode__c,EtoConversionDate__c,MarineFlag__c,CSS_Repair_Location__c,OemCode__c,
                 ProductApplicationDesp__c,warrantyIndicatorFlag__c,bmsCreateAccount__c,CSS_Bms_ContactBoolean__c,Email_Address__c,Email_check_box__c,BMSStatus__c,BMSWSStatus__c,
                 Contact_ID__c,Customer_Name__c,Customer_Code__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Address__c,City__c,ZipCode__c,
                 Country__c,Account__c,CSS_Charge_Account_Status__c,Shop_Work_Order__c,Application__c, Unit_Number__c, Status__c, css_resolution__c,
                 CSS_Feedback_Comments__c, Previous_Status__c,previousESN_MultiLoc__c,date_in__c,Date_in_Shop__c,ESN__c, ESN_IA__c, 
                 First_Name__c,BMS_Last_Name__c, Mileage__c,CSS_Hours__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, 
                 LastModifiedDate,CreatedDate, Location_Certification__c,CSS_State__c,Primary_Segment__c,Before_In_Service__c,ESN_Locked__c, 
                 Make__c,Model__c,AccessCode__c,Failure_Date__c,Failure_Point__c,Failure_Point_Measure__c,Service_Model__c,VIN__c,VIN_Flag__c,
                 Warranty_Start_Date__c,Region__c,Creator_Location__c,EditCoverage__c,Unit_Type__c, Sub_Type__c,Account__r.ERP_System__c,
                 SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c, Repeat_Visit__c,TSR_EscalateNumber__c,
                 RecentVisit__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_Country__c,EngineFamilyName__c,Repeat_Or_Recent_Calc__c,JobLocation__c,CSS_Job_Location_Code__c,CreatedById,Qsol_Engine_Family_Code__c,
                 Repair_Location__c,Territory__c,Warranty_Authorization_Flag__c,PSN_Not_Available__c,Sub_Status__c,LastUpdateSubStatus__c,
                 Actual_Technician_Time__c,SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,
                 SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,
                 SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,
                 SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,
                 SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,
                 SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,
                 SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c, ProductApplicationCode__c,SP_ClaimAllowedDays__c,SP_RegionCode__c,SP_TerritoryCode__c,
                 BillToCode__c,DesignPhaseCode__c, CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, 
                 CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c,Category__c,Category2__c,Category3__c,Category4__c,
                 Category5__c,Complaint_Type__c,Complaint_Type2__c,Complaint_Type3__c,Complaint_Type4__c,Complaint_Type5__c, Preventive_Maintenance__c,
                 Expedited_Service__c, Category_Desc__c, Category2_Desc__c, Category3_Desc__c, Category4_Desc__c, Category5_Desc__c, 
                 Complaint_Type_Desc__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, 
                 Application_Desc__c,ApplicationCode__c, Control_Number__c, ODM_Status__c, EditComplaint__c, BuildDate__c, Sp_TERRITORY__c,
                 ODM_Pre_Submit_Status_Message__c, ODM_Pre_submit_Status__c,Automotive_App_Flag__c,Mutual_Exclusive_Message__c
                 from CSS_Job_Order__c where id= :Wid];
        System.debug('workJob ' + workJob);

        claimsSCList = [select Id, Name,ODM_Status__c,Parts_Warranty__c,RoadRelay_Warranty__c,System_Code__c,Component_Code__c,Failure_Mode__c,AccountCode__c,
                        Pay_Code__c,CertificateNumber__c,WarrantyId__c,Approval_Code__c,CSS_CoverageType__c,CoveredLaborHrs__c,
                        CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredTowingMiles__c,CoveredTravelLabor__c,
                        CoveredTravelMiles__c,DeductibleAmount__c,Authorization_Number__c,CampaignLaborPercentage__c,
                        CampaignOCPercentage__c,CampaignPartsPercentage__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,
                        CSS_Account_Formula__c, Fail_Code__c,FailCode_Formula__c,Campaign_Description__c,Type__c, 
                        Part_Warranty_Start_Date__c, Failure_Point__c, Campaign_Start_Date__c, Engine_Family_Code__c, 
                        Campaign_End_Date__c, Status__c, CoveredTravelBaseFareAmt__c
                        from CSS_Solution_Component__c
                        where Service_Job__c =: Wid AND CSS_Account_Formula__c != null AND Fail_Code__c != null AND Selected_Component__c = true];
        system.debug('claimsSCList.size() ' + claimsSCList.size());
        system.debug('claimsSCList() ' + claimsSCList);
        claimsPOList = [select Id, Name, ODM_Status__c,Account_Code__c, Fail_Code__c, Part_Description__c,recordtype.name, Item__c, Type__c, 
                        Technician__c, HoursTravelled__c, Part_Name__c, selected_part__c,
                        Quantity__c, Covered__c, Sell_Price__c, ExpenseTotal__c, FailurepartId__c, FailurepartId__r.Fail_Code__c,
                        FailurepartId__r.FailCode_Formula__c,Service_partnumber__c,Replacement_Reason__c,Amount__c,Mileage__c
                        from CSS_Parts_Options__c
                        where Service_Job__c =: Wid AND Account_Code__c != null AND Fail_Code__c != null AND selected_part__c = true];
        system.debug('claimsPOList.size() ' + claimsPOList.size());

        system.debug('claimsPOList() ' + claimsPOList);

        claimsSRTList = [SELECT Id, Name, ODM_Status__c,Account_Code__c, FailCode__c,Job_Order__c, SRT_ID__c, SRT_Title__c, Access_Code_Saved__c, 
                         SRT_Time__c, SRT_Quantity__c,Assignment__c, SRT_Warrantable__c, AccountCode_Formula__c, Fail_Code_Description__c, SRT_Amount__c, 
                         Calculated_Claimed_Hours__c, Type__c, SRT_Type__c, Overlap_Hours__c, Override__c, CSS_Claims__r.Repair_Location__c
                         FROM CSS_SRT__c WHERE Job_Order__c =: Wid AND (Account_Code__c != null OR AccountCode_Formula__c != null) 
                         AND (FailCode__c != null OR Fail_Code_Description__c != null) AND (SRT_AccessiblityCheck__c = true OR isPerformed__c = true)];
        system.debug('claimsSRTList.size() ' + claimsSRTList.size());
        system.debug('claimsSRTList() ' + claimsSRTList);

        String PartsWarrantyValues = Label.CG_Parts_Warranty;
        if(PartsWarrantyValues != null && PartsWarrantyValues != '') {
            partsWarranty = PartsWarrantyValues.split(',');
        }
        system.debug('partsWarranty ' + partsWarranty);
        for(string s : partsWarranty) 
            system.debug('partsWarranty START' + s + 'END');

        //quote = [Select Id,Name,Accepted_By__c,Accepted_Method__c,Customer_Quote__c,Date_Accepted__c,Purchase_Order__c,Reason_Quote_is_Declined__c,Received_Amount__c,Service_Job__c From CSS_Quote__c where Service_Job__c=:wid];

    }

    public void fetchAccountFailCodeCombo() {
        try {
            if(claimsSCList.size()>0){
                for(CSS_Solution_Component__c sctemp : claimsSCList) {
                    if(SCAccountCodeMap.containsKey(sctemp.CSS_Account_Formula__c)) {
                        List<CSS_Solution_Component__c> fclist = SCAccountCodeMap.get(sctemp.CSS_Account_Formula__c);
                        fclist.add(sctemp);
                        SCAccountCodeMap.put(sctemp.CSS_Account_Formula__c, fclist);
                    } else {
                        SCAccountCodeMap.put(sctemp.CSS_Account_Formula__c, new List<CSS_Solution_Component__c> { sctemp });
                    }
                }
            }
            system.debug('SCAccountCodeMap() ' + SCAccountCodeMap);

            if(claimsPOList.size()>0){
                for(CSS_Parts_Options__c potemp : claimsPOList) {
                    string Failcode= potemp.Fail_Code__c;
                    string splittedFailcode=null;
                    if(Failcode!=null && Failcode.contains('-')){
                        string[] splittedFailcodelst = Failcode.split('\\-');
                        splittedFailcode = splittedFailcodelst[1];}
                    else{
                        splittedFailcode= potemp.Fail_Code__c;
                    }

                    system.debug('splittedFailcode() ' + splittedFailcode);
                    if(POAccountCodeMap.containsKey(potemp.Account_Code__c+splittedFailcode)) {
                        List<CSS_Parts_Options__c> polist = POAccountCodeMap.get(potemp.Account_Code__c+splittedFailcode);
                        polist.add(potemp);
                        POAccountCodeMap.put(potemp.Account_Code__c+splittedFailcode,polist);
                    } else {
                        POAccountCodeMap.put(potemp.Account_Code__c+splittedFailcode, new List<CSS_Parts_Options__c> { potemp });
                    }
                }
            }
            system.debug('POAccountCodeMap() ' + POAccountCodeMap);

            if(claimsSRTList.size()>0){
                for(CSS_SRT__c SRTtemp : claimsSRTList) {
                    string accountCode;
                    string failCode;
                    if(SRTtemp.Account_Code__c == null)
                        accountCode = SRTtemp.AccountCode_Formula__c;
                    else
                        accountCode = SRTtemp.Account_Code__c;

                    if(SRTtemp.FailCode__c == null){
                        failCode = SRTtemp.Fail_Code_Description__c;
                        if(failCode!=null && failCode.contains('-')){
                            string[] splittedFailcodelst = failCode.split('\\-');                  
                            if(splittedFailcodelst[1].length()==6)
                                failCode = splittedFailcodelst[1].substring(0,splittedFailcodelst[1].length()-2);
                            else
                                failCode = splittedFailcodelst[1];
                        }
                        else{
                            failCode= SRTtemp.Fail_Code_Description__c;
                            if(failCode!=null){
                                if(failCode.length()==6)
                                    failCode = failCode.substring(0,failCode.length()-2);
                                else
                                    failCode = failCode; 
                            }}
                    }
                    else{
                        failCode = SRTtemp.FailCode__c;
                        if(failCode!=null){

                            if(failCode.length()==6)
                                failCode = failCode.substring(0,failCode.length()-2);
                            else
                                failCode = failCode; 
                        }}
                    if(SRTAccountCodeMap.containsKey(accountCode+failCode)) {
                        List<CSS_SRT__c> srtList = SRTAccountCodeMap.get(accountCode+failCode);
                        srtList.add(SRTtemp);
                        SRTAccountCodeMap.put(accountCode+failCode, srtList);
                    } else {
                        SRTAccountCodeMap.put(accountCode+failCode, new List<CSS_SRT__c> { SRTtemp });
                    }
                }
            }
            system.debug('SRTAccountCodeMap() ' + SRTAccountCodeMap);

        } catch(Exception ex) {
            system.debug('in the exception of fetchAccountFailCodeCombo Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }    
    }

    public CSS_JobPlanQuoteController() {
        showAcceptDateError = false;
        showAcceptDateError1 = false;
        Enabledeclinebutton = false;
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        workjobStatus=ApexPages.CurrentPage().getParameters().get('status');
        datebyLocaleValue = css_utility.getFormattedDate();  
        //string partsUr = ApexPages.CurrentPage().getParameters().get('joPa');
        try {
            mainSOQL();
            fetchAccountFailCodeCombo();
            generateQuoteButton();
            if(workJob.BMSStatus__c.contains('QTFI0') || workJob.BMSStatus__c.contains('QTJI0') || workJob.BMSStatus__c.contains('QTPI0') || workJob.BMSStatus__c.contains('QTNI0'))
                isBmsstatus = true;
            else{
                isBmsstatus = false;
            }
            System.debug('****workJob.EditComplaint__c'+workJob.EditComplaint__c);

            System.debug('****counter'+correctioncounter);

            system.debug('workjob status '+workjobStatus);
            css_header_nav__c CS = css_header_nav__c.getInstance(UserInfo.getProfileId()); 

            string userId = UserInfo.getUserId();
            system.debug('userId*****'+userId);
            system.debug(workJob.chevron_page__c);

            //bmsEnabled=css_utility.getBMSEnabled(userId);
            //Modified as per story# 76192
            bmsEnabled=css_utility.getBMSEnabled(workJob.Creator_Location__c);
            system.debug('bmsEnabled - Intake'+bmsEnabled);

            if (workJob.chevron_page__c == 'jpq') {

                if(CS.EnableBMSButton__c && bmsEnabled)    
                    showJobPlanBlocks(false,false,false,false,false,true,false);
                else
                    showJobPlanBlocks(false,true,false,false, false,false,false);
            }        
            else{ showJobPlanBlocks(false,true,false,false, false,false,false); }
            /*if(partsUr == 'Parts'){
                system.debug('partsUr'+partsUr);
                showJobPlanBlocks(false,false,false,true, false,false,false);
            }*/

            //partsListWrap = getListWrap();
            getAttachmentData();


            system.debug('Test ED14****');
            //generateQuote();
            system.debug('Test ED15****');
            //To Check If the User Location is BMS Enabled

            showResolutionWithRepair = FALSE;
            fetchclaimtypes();
            enablequotebutton();
            enabledeclinebutton();


        }
        catch(Exception e)  {
        }
    }  

    public ID Wid; 
    public css_job_order__c workJob {get;set;}
    public boolean bmsEnabled {get;set;}
    public Attachment attachObj{get;set;}

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

        jo_btn_cls = 'chev_jpo_img_open';
        srt_btn_cls = 'chev_jpsrt_img_open';
        prt_btn_cls = 'chev_jpparts_img_open';
        war_btn_cls = 'chev_wr_img_open';
        nar_btn_cls = 'chev_jpnarrative_img_open';
        qt_btn_cls = 'chev_jpquote_img_active';

        jo_chv_sts = 'sopen';
        srt_chv_sts = 'sopen';
        prt_chv_sts = 'sopen';
        war_chv_sts = 'sopen';
        nar_chv_sts = 'sopen';
        qt_chv_sts = 'sactive';

        jo_txt_sts =  'chev_text_open';
        srt_txt_sts =  'chev_text_open';
        prt_txt_sts =  'chev_text_open';
        war_txt_sts =  'chev_text_open';
        nar_txt_sts =  'chev_text_open';
        qt_txt_sts =  'chev_text_active';

        jo_txt_val = '';
        srt_txt_val = '';
        prt_txt_val = '';
        war_txt_val = '';
        nar_txt_val = '';
        qt_txt_val = 'Quote';
    }

    /*********End Method for Chevrons Initialization *****/

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
    //Method to display list of ReasonQuoteDecline drop down values in Quote chevron
    public  static List<SelectOption> getReasonQuoteDeclne(id wid,String CreatorLocation) {
        List<SelectOption> reasonQuoteDecList; 
        try {
            string strLoc;

            system.debug('***claimId***'+wid);
            if (wid == null){
                Id userId = UserInfo.getUserId();
                User usr = css_utility.getUserAttributes(userId);
                strLoc = usr.User_Location__c;
                system.debug('strLoc***'+strLoc);
            }else{
                strLoc = CreatorLocation;
                system.debug('strLoc--'+strLoc);
            }
            CSS_JobEventTemporary__c[] lclaimtype;
            system.debug('lclaimtype***'+lclaimtype);
            lclaimtype=[select Reason__c from CSS_JobEventTemporary__c where attribute1__c='WOQTRejectionReason' and Key__c=: strLoc];
            system.debug('After+lclaimtype***'+lclaimtype);
            map<string, object> mpclaimtype=(map<string, object>)JSON.deserializeUntyped(lclaimtype[0].Reason__c);
            system.debug('mpclaimtype-->'+mpclaimtype); 

            reasonQuoteDecList = new List<SelectOption>();
            // if(pgName=='JobPlan'){
            reasonQuoteDecList.add(new SelectOption('','--Select One--'));
            // else
            // claimTypeList.add(new SelectOption('','Select One'));

            for(string ct: mpclaimtype.keyset()){

                reasonQuoteDecList.add(new SelectOption(ct, ct));
            }

            reasonQuoteDecList.sort();
            system.debug('reasonQuoteDecList**'+reasonQuoteDecList);
        }
        catch(exception e)
        {
            System.debug('in catch of sendPartsToERP of GSQ >>>>>>>>>>>>>>is :: '+e.getLineNumber()+' Exception Message>>>is:'+e.getMessage());

        }
        return reasonQuoteDecList;
    }
    public List<SelectOption> cltype{get;set;}
    public List<SelectOption> fetchclaimtypes()
    {
        String CreatorLocation; 
        cltype = new List<SelectOption>();
        CreatorLocation = [select creator_Location__c from css_job_order__c where id = :Wid].Creator_Location__c;
        //03520-04892 location has data valueo
        cltype=CSS_JobPlanQuoteController.getReasonQuoteDeclne(wid,CreatorLocation);
        system.debug('cltype'+cltype);
        //cltype=CG_BL_Intake.getClaimType(Wid,CreatorLocation);
        system.debug('Location Code Fetched from the User:'+CreatorLocation); 
        return cltype;

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
            closeJob = [Select id,DSID__c, (Select Id,Name, Case_Name__c,Service_Job__c,Repair_response__c,Out_Of_Order__c,Rank__c,Solution_Title__c ,
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
    public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        //options.add( new SelectOption('','Select'));
        Schema.DescribeFieldResult fieldResult =  CSS_Quote__c.Accepted_Method__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getValue(),f.getLabel()));
        }       
        return options;
    } 
    public List<CSS_Quote__c> quoteList = null;
    public CSS_Quote__c quoteObj {get; set;}
    public void getAttachmentData() {
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getAttachmentData $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        System.debug('**RAJESH+workJob.Id'+workJob.Id);
        //List<CSS_Quote__c> quoteList = null;
        List<Attachment> attachList = null;
        try{

            quoteObj = new CSS_Quote__c();
            // cltype=fetchclaimtypes();
            quoteList = new List<CSS_Quote__c>([Select Id, Name,Accepted_By__c,Accepted_Method__c,Customer_Quote__c,Date_Accepted__c,Purchase_Order__c,Reason_Quote_is_Declined__c,Received_Amount__c, LastModifiedDate, OrderReference__c, Quote_decline_Reason__c, AcceptQuote__c,Service_Job__c from CSS_Quote__c where Service_Job__c=:workJob.Id order By LastModifiedDate DESC limit 1 ]);//limit 1
            System.debug('quoteList size>>>>>>>>>>>>>>>:'+quoteList.size());
            cltype=fetchclaimtypes();
            if(quoteList.size()<=0)
                return;
            //if(quoteList!=null)
            quoteObj = quoteList.get(0);
            System.debug('quoteObj'+quoteObj);
            if(quoteObj.Date_Accepted__c ==null ){
                quoteObj.Date_Accepted__c = system.today();    
            }
            attachList = new List<Attachment>([Select Id, Name, ParentId, Body, BodyLength, LastModifiedDate from Attachment where ParentId=:quoteObj.Id order By LastModifiedDate DESC limit 1]);
            System.debug('attachList size>>>>>>>>>>>>>>>:'+attachList.size());
            if(attachList.size()<=0)
                return;
            attachObj = attachList.get(0);
            System.debug('retrieved Attachment Id:'+attachObj.Id);
        }catch(Exception ex){
            System.debug('in catch getAttachmentData >>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            quoteList=null;attachList=null;
        }
    }
    public Account accURL{get; set;}
    public list<string> fieldActionAcountcodeList;
    public void generateQuote(){
        System.debug('**RAJESH+workJob.Id'+workJob.Id);
        system.debug('quoteObj.Purchase_Order__c'+quoteObj.Purchase_Order__c);
        system.debug('quoteObj'+quoteObj);
        system.debug('quoteObj'+quoteObj.Id);
        string ODMMessage = '';
        string ODMStatusCode  = '';
        string [] IntRespBody;
        fieldActionAcountcodeList = new list<string>();
        try{
            
            String FAACValues = Label.CG_FA_AccountCodes;
            if(FAACValues != null && FAACValues != '') {
                fieldActionAcountcodeList = FAACValues.split(',');
            }
           list<CSS_Integration_Error__c> lstIntDetails = CG_BL_ODM.performODMPreSubmitServiceCS(SCAccountCodeMap, POAccountCodeMap, SRTAccountCodeMap, partsWarranty, fieldActionAcountcodeList,null, null, workJob, false);
            system.debug('lstIntDetails**'+lstIntDetails);
            if(lstIntDetails != null && lstIntDetails.size() >0) {
                for(CSS_Integration_Error__c IE : lstIntDetails) {
                     system.debug('origRespbody**'+IE.Response_Body__c);
                    if(IE.Response_Body__c != null){
                    IntRespBody = IE.Response_Body__c.split(';;');
                    IE.Response_Body__c = IntRespBody[0];
                    ODMStatusCode = string.valueof(IntRespBody[1]);
                    }
                    system.debug('Respbody**'+IE.Response_Body__c);
                    system.debug('statcode**'+ODMStatusCode);
                    if(IE.Error_Description__c == null && IE.Response_Body__c != null) {
                        
                        CG_ODM_PreSubmit_ResJSONParser ODMResponse = (CG_ODM_PreSubmit_ResJSONParser)JSON.deserialize(IE.Response_Body__c,CG_ODM_PreSubmit_ResJSONParser.class);
                        system.debug('ODMResponse ' + ODMResponse); 
                        if(ODMResponse.Response.claim != null){
                            for(CG_ODM_PreSubmit_ResJSONParser.messages msg:ODMResponse.Response.claim.messages){
                                system.debug('Entered for loop messages section>>>>>>'+msg.description);
                                ODMMessage += msg.type + ':' + msg.description + ';;';
                            }
                        }
                    }
                }
            }

            workJob.ODM_Pre_Submit_Status_Message__c =  ODMMessage;
            system.debug('ODMMessage >>> ' + ODMMessage);
            //Added below if block to handle null response or failure response
            if(ODMStatusCode != '200'){
                    workJob.ODM_Status_Code__c = string.valueOf(ODMStatusCode);
                    
                }
            if(ODMMessage != null && ODMMessage != ''){
                if(ODMMessage.contains('ERROR')){
                    workJob.ODM_Pre_submit_Status__c = 'ERROR';
                }
                else{
                    workJob.ODM_Pre_submit_Status__c = 'WARN';
                }
            }else{
                workJob.ODM_Pre_submit_Status__c = 'PASSED';
            }

            if(workJob.ODM_Pre_submit_Status__c == 'PASSED') {
                CG_ReqPDFInbound_Req pdfReq = new CG_ReqPDFInbound_Req();
                CG_ReqPDFInbound_Req.Sender senderDetails = new CG_ReqPDFInbound_Req.Sender();
                senderDetails.ServiceName = 'sendPDFGenerationReq';
                senderDetails.SenderID = 'CSS';
                CG_ReqPDFInbound_Req.Target TargetDetails = new CG_ReqPDFInbound_Req.Target();
                TargetDetails.TargetID = 'BMS';
                CG_ReqPDFInbound_Req.Location LocationDetails = new CG_ReqPDFInbound_Req.Location();
                LocationDetails.LocationID = workJob.Creator_Location__c;
                CG_ReqPDFInbound_Req.Header HeaderDetails = new CG_ReqPDFInbound_Req.Header();
                HeaderDetails.Location = LocationDetails;
                HeaderDetails.Target = TargetDetails;
                HeaderDetails.Sender = senderDetails;

                pdfReq.Header = HeaderDetails;

                CG_ReqPDFInbound_Req.DataArea DataAreaDetails = new CG_ReqPDFInbound_Req.DataArea();            

                DataAreaDetails.CSSJobID = workJob.Name;
                DataAreaDetails.CustomerCode = workJob.Customer_Code__c;
                DataAreaDetails.Action = 'QUOTE REQUEST';
                DataAreaDetails.BMSReferenceNumber = workJob.Quote_ID__c;
                DataAreaDetails.CustomerPO = quoteObj.Purchase_Order__c;
                DataAreaDetails.OrderType = 'WOQT';
                DataAreaDetails.InvoiceUser = (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier');
                DataAreaDetails.SecurityCode = '';
                string[] location;
                if(workJob.Creator_Location__c != null)
                    location = workJob.Creator_Location__c.split('-');

                if(location != null && location.size()>0){
                    DataAreaDetails.BranchCode = location[1];
                    DataAreaDetails.DistributorCode = location[0];
                }else{
                    DataAreaDetails.BranchCode = '';
                    DataAreaDetails.DistributorCode = '';
                }
                pdfReq.DataArea = DataAreaDetails;

                CG_ReqPDFInbound_Resp requestPDFInbound = CSS_WS_BMS.reqPDFInbound(pdfReq); 
            } 
            //update the service job records.
                update workJob;
            quoteObj.Customer_Quote__c = false;
            quoteObj.AcceptQuote__c = false; // to make the accespt quote checkbox uncheck after click on generate quote
            system.debug('quoteObj.Customer_Quote__c' + ' ' + quoteObj.Customer_Quote__c + 'acp' + quoteObj.AcceptQuote__c);
            //Inserting Integration errors.
            //system.debug('lstIntDetails >>> ' + lstIntDetails);
            //insert lstIntDetails;
            //system.debug('lstIntDetails >>> LAST ' + lstIntDetails);
        }
        catch(exception e){
            system.debug('Entered into catch block of request pdf inbound call in Job Plan Quote Controller>>>>>'+ e.getMessage() + ' ' + e.getLineNumber() + ' ' + e.getCause());
        }
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
    public string accptQuote{get;set;}
    public void acceptQuote(){
        /* 
        CSS_WS_BMS.callBMSQTAccInboundService(workJob.Creator_Location__c,workJob.Name,quotedt.OrderReference__c,'Y',''); */

        try
        {
            ERPSuccessMsgParts = false;

            if(quoteObj!=null){

                showErrorERP = false;
                ERPErrorMsg = '';
                if(workjob.id==null)
                {
                    showErrorERP=true;
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
                /* if(quoteObj.LocationID__c==null){

                    showErrorERP = true;
                    if(!ERPErrorMsg.contains('DistributorCode') && !ERPErrorMsg.contains('BranchCode')){
                        ERPErrorMsg += 'DistributorCode is blank. Please enter value.<br/>'; 
                        ERPErrorMsg += 'BranchCode is blank. Please enter value.<br/>';
                    }    

                }*/

                system.debug('inside accept');
                system.debug('workJob.Creator_Location__c**'+workJob.Creator_Location__c);
                system.debug('workJob.Name**'+workJob.Name);
                system.debug('quoteObj.OrderReference__c**'+quoteObj.OrderReference__c);
                //if(showErrorERP=false){
                if(!showErrorERP){
                    CSS_BMSQTAcceptInboundJSON2APEX response = new CSS_BMSQTAcceptInboundJSON2APEX();
                    //response = CSS_WS_BMS.callBMSQTAccInboundService(workJob.Creator_Location__c,workJob.Name,quoteObj.OrderReference__c,'Y',quoteobj.Reason_Quote_is_Declined__c);
                    response = CSS_WS_BMS.callBMSQTAccInboundService(workJob.Creator_Location__c,workJob.Name,quoteObj.OrderReference__c,'Y',quoteobj.Reason_Quote_is_Declined__c,quoteObj.Purchase_Order__c);
                    /*CSS_WS_BMS.callBMSQTAccInboundService(workJob.Creator_Location__c,quoteObj.OrderReference__c,workJob.Name,quoteObj.DistributorCode__c,
                                                      quoteObj.BranchCode__c,quoteObj.TransactionType__c,quoteObj.Name,quoteObj.Acptquote__c,
                                                  quoteObj.Reason_Quote_is_Declined__c,quoteObj.LastModifiedBy.Name,'',quoteObj.CreatedBy.Name); */
                    System.debug('response.Header.status'+response.Header.status);
                    if(response.Header.status.containsIgnoreCase('SUCCESS')){
                        //EnableDecline = true;
                        ERPSuccessMsgParts = true;
                        System.debug('inside response.Header.status'+response.Header.status);

                        quoteObj.AcceptQuote__c = true;
                    }
                    else if(response.Header.status.containsIgnoreCase('ERROR')){
                        showErrorERP = true;
                        ERPErrorMsg = 'Send to ERP failed. Please retry or contact Guidanz@cummins.com';

                        quoteObj.AcceptQuote__c = false;    
                    }
                    CSS_Quote__c qt = new CSS_Quote__c();  
                    qt.Quote_decline_Reason__c=quoteObj.Quote_decline_Reason__c;
                    qt.Accepted_By__c=quoteObj.Accepted_By__c;
                    qt.Date_Accepted__c=quoteObj.Date_Accepted__c;
                    qt.Accepted_Method__c=quoteObj.Accepted_Method__c;
                    qt.Customer_Quote__c=quoteObj.Customer_Quote__c;
                    qt.Purchase_Order__c=quoteObj.Purchase_Order__c;
                    qt.Received_Amount__c=quoteObj.Received_Amount__c;

                    if(quoteObj.AcceptQuote__c==true)
                        qt.AcceptQuote__c = quoteObj.AcceptQuote__c;
                    //qt.AcceptQuote__c=accQuoteFlag;
                    qt.Id=quoteObj.Id;
                    update qt;
                    system.debug('qt'+qt);

                }
            }


        }
        catch(Exception ex)
        {
            //partShowSucessERP = false;
            showErrorERP = true;
            ERPErrorMsg = 'Send to ERP failed. Please retry or contact Guidanz@cummins.com';
            System.debug('in catch of sendPartsToERP of GSQ >>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    //Method for Date validation
    public void checkAcceptedDate(){
        if(quoteObj!=null)
        {
            system.debug('quote.Date_Accepted__c' + quoteObj.Date_Accepted__c);
            if(quoteObj.Date_Accepted__c!=null && quoteObj.Date_Accepted__c<workJob.Failure_Date__c)
            {
                showAcceptDateError = true;
            }
            else
                showAcceptDateError = false;
        }
    }
    //Method for enable the Quote Accept button
    public void enablequotebutton()
    {
        List<Attachment> notesAttchList = new List<Attachment>();
        if(quoteObj!=null)
        {
            system.debug('quote.Accepted_By__c' + quoteObj.Accepted_By__c);
            //showAcceptDateError1 = false;
            notesAttchList = [SELECT Id,ParentId FROM Attachment where ParentId  =: quoteObj.Id];
            //added "Customer_Quote__c" in below condition as per defect #152320,-By RAJESH 29th June 2018//add

            if((quoteObj.Accepted_By__c!=null && quoteObj.Accepted_By__c!='') && (quoteObj.Date_Accepted__c!=null && quoteObj.Date_Accepted__c<workJob.Failure_Date__c==false)&&(quoteObj.Accepted_Method__c!=null && quoteObj.Accepted_Method__c!='Select One')&&(quoteObj.Customer_Quote__c!=null && quoteObj.Customer_Quote__c!=false)&&(quoteObj!=null)&& (notesAttchList != null && notesAttchList.size()>0)){
                showAcceptDateError1 = true;
            }
            else
                showAcceptDateError1 = false;

        }
        enabledeclinebutton();
    }
    public void enabledeclinebutton()
    {
         List<Attachment> notesAttchList = new List<Attachment>();
        if(quoteObj!=null)
        {
            
            notesAttchList = [SELECT Id,ParentId FROM Attachment where ParentId  =: quoteObj.Id];

            system.debug('quoteObj.AcceptQuote__c'+quoteObj.AcceptQuote__c);
            decQuoteSelectedList = quoteObj.Reason_Quote_is_Declined__c;
            system.debug('decQuoteSelectedList'+ ' ' + decQuoteSelectedList);
//added Customer_Quote__c field in below condition as per defect #152320 and Uncommited (quoteObj.AcceptQuote__c!= true),-By RAJESH 29th June 2018             
            if((decQuoteSelectedList!=null && decQuoteSelectedList!='' && decQuoteSelectedList!='--Select One--') && quoteObj.Customer_Quote__c != true && (notesAttchList != null && notesAttchList.size()>0)) //(quoteObj.AcceptQuote__c!= true)
            {
                Enabledeclinebutton = true;
            }
            else
                Enabledeclinebutton = false;

        }
    }

    //Method for decline quote button
    public void declineQuote(){
       // system.debug('quoteObj'+quoteObj);
       // system.debug('quoteObj***Id'+quoteObj.Id);
        /*     CSS_Quote__c quotedt = null;
            quotedt=[select Id, Name, OrderReference__c, BranchCode__c, CustomerNumber__c from CSS_Quote__c where Service_Job__c = :Wid];
        if(quotedt != null) 
        CSS_WS_BMS.callBMSQTAccInboundService(workJob.Creator_Location__c,workJob.Name,quotedt.OrderReference__c,'N',quotedt.Quote_decline_Reason__c); */
        try
        {   
            declinesucessmsg = false;
            errormsgdeclinequote = false;
            if(quoteObj!=null) {
                showErrorERP = false;
                ERPErrorMsg = '';
                if(workjob.id==null)
                {
                    showErrorERP=true;
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

                system.debug('inside accept');
                system.debug('workJob.Creator_Location__c**'+workJob.Creator_Location__c);
                system.debug('workJob.Name**'+workJob.Name);
                system.debug('quoteObj.OrderReference__c**'+quoteObj.OrderReference__c);
                CSS_BMSQTAcceptInboundJSON2APEX response = new CSS_BMSQTAcceptInboundJSON2APEX();
                //response=CSS_WS_BMS.callBMSQTAccInboundService(workJob.Creator_Location__c,workJob.Name,quoteObj.OrderReference__c,'N',css_utility.getSubStringValue(quoteObj.Quote_decline_Reason__c, 0, 25));
                response=CSS_WS_BMS.callBMSQTAccInboundService(workJob.Creator_Location__c,workJob.Name,quoteObj.OrderReference__c,'N',css_utility.getSubStringValue(quoteObj.Reason_Quote_is_Declined__c, 0, 25),'');
                System.debug('response.Header.status'+response.Header.status);
                if(response.Header.status.containsIgnoreCase('SUCCESS')){
                    //EnableDecline = true;
                    declinesucessmsg = true;
                    System.debug('inside response.Header.status'+response.Header.status);

                    //quoteObj.AcceptQuote__c = true;
                }
                else if(response.Header.status.containsIgnoreCase('ERROR')){
                    errormsgdeclinequote = true;
                    //ERPErrorMsg = 'Send to ERP failed. Please retry or contact Guidanz@cummins.com';

                    //quoteObj.AcceptQuote__c = false;    
                }
                CSS_Quote__c qt = new CSS_Quote__c();  
                //qt.AcceptQuote__c=accQuoteFlag;
                qt.Reason_Quote_is_Declined__c=quoteObj.Reason_Quote_is_Declined__c;
                qt.Quote_decline_Reason__c=quoteObj.Quote_decline_Reason__c;
                qt.Id=quoteObj.Id;
                //system.debug('qt.Id'+qt.Id);
               // Upsert qt;
                update qt;
            }
        }
        catch(Exception ex)
        {
            //partShowSucessERP = false;
            //showErrorERP = true;
            ERPErrorMsg = 'Send to ERP failed. Please retry or contact Guidanz@cummins.com';
            System.debug('in catch of sendPartsToERP of GSQ >>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }

    }
    public PageReference pgSaveAssign()
    {
        css_job_order__c worecord= new css_job_order__c();
        if (workJob.Status__c =='Triage & Diagnosis/Repair' || workJob.Status__c =='Job Plan' || workJob.Status__c =='Repair' ){
            worecord.Previous_Status__c=workJob.Status__c;
            worecord.Status__c='Review';
        }
        if (Wid != null)
        {
            worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;
            /* if(bmsEnabled==true){
                    system.debug('Inside else statement');
                   callCreateWoAndUpdateComment();
                   } */
            //  System.Debug('value of customer===='+workJob.customer_name__c);
            //  Call RSW Claiminfo Service to send data to RSW
            // CSS_RSWClaimInfo.sendClaimInfoToRSW(workJob);
            worecord.id=workJob.id;
            update worecord;
            //  System.Debug('record updated====='+worecord);

        }

        PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
        pageRef.setRedirect(true);
        return pageRef;
    } 

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
    //82020- Story87378 Reminder when canceling a job - Krishna on 19-06-2017.

    public void Cancel()
    {   
        css_job_order__c worecord= new css_job_order__c();
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
    public boolean showRepairErrorMessage{get;set;}
    @testvisible
    list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();
    public boolean showResolutionWithRepair{get;set;}
    public Boolean requiredBMSMessage {get;set;}
    public void saveAndCloseJob()
    {
        // if(dsidIndi != null && dsidIndi.containsIgnoreCase('O'))
        if (Wid != null)
        {
            requiredBMSMessage =false;
            if ((bmsEnabled ==true)&&(workJob.Customer_Code__c==null || workJob.Unit_Number__c==null || workJob.Shop_Work_Order__c==null)){
                requiredBMSMessage = TRUE;
                System.debug('Entered error');            
                //return null;
            }
            css_accessSrtCompOutTo_Eds updateEDS = new css_accessSrtCompOutTo_Eds(solutionIds,workjob.DSID__c);

            System.debug('Entered Pg SaveFinish MEthod');
            css_dsidclose dscl = new css_dsidclose();
            PageReference pageRef;
            System.debug('41');
            if(showRepairs == null){
                showRepairs = FALSE;
            }
            if(showResolutionWithRepair == null){
                showResolutionWithRepair = FALSE;
            }
            if(showRepairs  && !showResolutionWithRepair){
                System.debug('42');
                list<CSS_Solutions__c> negatRepairs = new list<CSS_Solutions__c>();
                System.debug('43');
                if(!responseValues.isEmpty()){
                    System.debug('44');
                    for(CSS_Solutions__c solRec : responseValues){
                        System.debug('45');
                        if(solRec.Repair_Response__c != null && !solRec.Repair_Response__c.contains('Successful')){
                            System.debug('46');
                            System.debug('Entered neg if Loop:');
                            negatRepairs.add(solRec);
                            System.debug('47');
                        }else if(solRec.Repair_Response__c == null){
                            System.debug('48');
                            showRepairErrorMessage = TRUE;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please select repair response for the below solutions'));
                            //return null;
                        }
                    }//end of For
                    System.debug('B4 MEthod');

                    if(!negatRepairs.isEmpty() && !responseValues.isEmpty() && negatRepairs.size() == responseValues.size()){
                        System.debug('49');
                        System.debug('Entered If Loop:');

                        showResolutionWithRepair = TRUE;
                        //return null;
                    }else{
                        System.debug('50');
                        System.debug('Entered else Loop with repairs:');

                        showResolutionWithRepair = FALSE;
                        workJob.Status__c='Closed';
                        System.debug('51');
                        updateEDS.accessSRTs();
                        updateEDS.solComponents();
                        updateEDS.outOfOrder(outOfOrderSolList);
                        updateEDS.insiteFaultCodes(fauCod,workjob.DSID__c);
                        dsidStatus = dscl.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                        if(dsidStatus) {workJob.DSID_Status__c='Closed';} 
                        if(workJob.Account__r.ERP_System__c=='One BMS'){
                            cancelSJWrapperObj1 = CG_BL_Intake.closeServiceJob(workJob);
                            if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == false){
                                system.debug('**noerrors');
                                update workJob;
                            }
                        }
                        else{
                            update workJob;
                        }
                        if(!responseValues.isEmpty()){
                            update responseValues;
                        }
                        /*pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
                        pageRef.setRedirect(true);*/                    
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
                        if(dsidStatus) {workJob.DSID_Status__c='Closed';} 
                        if(workJob.Account__r.ERP_System__c=='One BMS'){
                            cancelSJWrapperObj1 = CG_BL_Intake.closeServiceJob(workJob);
                            if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == false){
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
                        /*pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
                        pageRef.setRedirect(true);*/
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
                    if(dsidStatus) {workJob.DSID_Status__c='Closed';} 
                    if(workJob.Account__r.ERP_System__c=='One BMS'){
                        cancelSJWrapperObj1 = CG_BL_Intake.closeServiceJob(workJob);
                        if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == false){
                            system.debug('**noerrors');
                            update workJob;
                        }
                    }
                    else{
                        update workJob;
                    }
                    if(!responseValues.isEmpty()){
                        System.debug('58');
                        update responseValues;
                    } 
                    /*pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
                    pageRef.setRedirect(true);*/
                }
            }    

            System.Debug('record updated====='+workJob);            

            //return pageRef;
        }
        else{
            //return null;

        }   
    } 


    public void generateQuoteButton(){
        try
        {
            system.debug('entered generateQuoteButton method');
            //mainSOQL();
           /* lstSolcom = [select id, ODM_Status__c from CSS_Solution_Component__c where Service_Job__c=:wid];
            lstparts  = [select id,ODM_Status__c from CSS_Parts_Options__c where Service_Job__c=:wid];
            lstSrts   = [select id, ODM_Status__c from CSS_SRT__c where Job_Order__c=:wid]; */
            lstSolcom = [select id, ODM_Status__c, Selected_Component__c from CSS_Solution_Component__c where Service_Job__c=:wid ];
            lstparts  = [select id,ODM_Status__c,PartOC__c,selected_part__c from CSS_Parts_Options__c where Service_Job__c=:wid and (RecordType.Name='BMS Parts' OR (RecordType.Name ='OtherClaimables' and selected_part__c=true) OR (RecordType.Name ='TTML' and selected_part__c=true) OR (PartOC__c = 'OC' and selected_part__c=true) OR (PartOC__c = 'TOW' and selected_part__c=true) ) ];
            lstSrts   = [select id, ODM_Status__c, SRT_AccessiblityCheck__c, isPerformed__c from CSS_SRT__c where Job_Order__c=:wid and (SRT_AccessiblityCheck__c = true or isPerformed__c = true)];

            //system.debug('sol odm status' + ' ' + lstSolcom.ODM_Status__c );
            //system.debug('part odm status' + ' ' + lstparts.ODM_Status__c);
            //system.debug('srt odm status' + ' ' + lstSrts.ODM_Status__c);
            system.debug('job odm status' + ' ' + workJob.ODM_Status__c+' Mutual>> Mutual_Exclusive_Message__c:'+workJob.Mutual_Exclusive_Message__c);

            ODMValidationForQuoteEnable = true;
            //if(workJob.ODM_Status__c != 'WARN' || workJob.ODM_Status__c != 'PASSED' ) {
        // Updated below conditions as per defect #152322,-By RAJESH 28th June 2018 
           
           if(workJob.ODM_Status__c != 'WARN' && workJob.ODM_Status__c != 'PASSED' && workJob.ODM_Status__c != 'NA' && workJob.Mutual_Exclusive_Message__c !=null  ) 
            {
                system.debug('Inside Job -- Mutual>> '); 
            ODMValidationForQuoteEnable =false;
                //return null;
            }  
            else{

                system.debug('Else Inside Job ');
                for(CSS_Solution_Component__c solOdmStatus : lstSolcom)
                {
                    //if(solOdmStatus.ODM_Status__c != 'WARN' || solOdmStatus.ODM_Status__c != 'PASSED')
                  //  if((solOdmStatus.ODM_Status__c == 'ERROR' || solOdmStatus.ODM_Status__c == 'YTBV') && solOdmStatus.Selected_Component__c == true)
                   if(solOdmStatus.ODM_Status__c != 'WARN' && solOdmStatus.ODM_Status__c != 'PASSED' && workJob.ODM_Status__c != 'NA' && solOdmStatus.ODM_Status__c != 'ERROR' && solOdmStatus.Selected_Component__c == true)
                    {
                        system.debug('Inside Solution');
                        ODMValidationForQuoteEnable =false;
                        break;
                    }
                }

                for(CSS_Parts_Options__c partsOdmStatus : lstparts)
                {
                    //if(partsOdmStatus.ODM_Status__c != 'WARN' || partsOdmStatus.ODM_Status__c != 'PASSED')
                    //if((partsOdmStatus.ODM_Status__c == 'ERROR' || partsOdmStatus.ODM_Status__c == 'YTBV') && partsOdmStatus.selected_part__c == true)
                   if(partsOdmStatus.ODM_Status__c != 'WARN' && partsOdmStatus.ODM_Status__c != 'PASSED' && workJob.ODM_Status__c != 'NA' && partsOdmStatus.ODM_Status__c != 'ERROR' && partsOdmStatus.selected_part__c == true)
                    {
                        system.debug('Inside PARTS');
                        ODMValidationForQuoteEnable =false;
                        break;
                    }
                }

                for(CSS_SRT__c SRTsOdmStatus : lstSrts)
                {
                    //if(SRTsOdmStatus.ODM_Status__c != 'WARN' || SRTsOdmStatus.ODM_Status__c != 'PASSED') 
                  //  if((SRTsOdmStatus.ODM_Status__c == 'ERROR' || SRTsOdmStatus.ODM_Status__c == 'YTBV') && (SRTsOdmStatus.SRT_AccessiblityCheck__c == true || SRTsOdmStatus.isPerformed__c == true))
                    if(SRTsOdmStatus.ODM_Status__c != 'WARN' && SRTsOdmStatus.ODM_Status__c != 'PASSED' && workJob.ODM_Status__c != 'NA' && SRTsOdmStatus.ODM_Status__c != 'ERROR' && (SRTsOdmStatus.SRT_AccessiblityCheck__c == true || SRTsOdmStatus.isPerformed__c == true)) 
                    {
                        system.debug('Inside SRT');
                        ODMValidationForQuoteEnable =false;
                        break;
                    }
                }
            }   // End Else part

        } // end Try part  

        catch(exception e){

        }

    }

}