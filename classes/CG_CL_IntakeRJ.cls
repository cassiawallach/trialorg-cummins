/*
 * Block comments with details of changes
 */
public class CG_CL_IntakeRJ
{
    //Global Veriables
    public CG_CL_IntakeRJ controllerRef{get;set;}
    public String userERPSystem{set;get;}
    public CSS_Job_order__c workJob{set;get;}
    public Id Wid;
    public List<CSS_CampTsbTrp__c> qsolCTTP {get;set;}
    public List<CSS_Solution_Component__c> solCompCTTP {get;set;}
    Transient map<string,CSS_CampTsbTrp__c> qsolCampMap = new map<string,CSS_CampTsbTrp__c>();
    Transient List<CSS_CampTsbTrp__c> lstQSOLDocs;
    public string comm {get;set;}
    public List<Note> workJob2 {get;set;}
    public boolean allFieldsValidate {get; set;}
    public boolean disableAssignmentBtn {get; set;}
    //public boolean isCampTrp{get;set;}
    // Veriables for validation  
    public boolean reqBoolean {get;set;}
     public boolean reqBooleanshop {get;set;}
     public Boolean isDealer {get;set;}
    public boolean displayPopup {get;set;}
    public boolean reqCusNumBoolean {get;set;}
    public boolean reqPhnnoBoolean {get; set;}//92817
    public boolean reqPhnnototalchar {get; set;}//92817
    public boolean reqFrstNamBoolean {get; set;}
    public boolean reqLastNamBoolean {get;set;}
    public boolean reqEmailBoolean {get; set;}
    public boolean reqEmailValidBoolean {get; set;}
    public boolean reqCstmrContactPhnBoolean {get; set;}
    public boolean reqCstmrContactPhntotalchar {get; set;}
    public boolean reqUNumBoolean {get; set;}
    public boolean reqESNBoolean {get;set;}
    public boolean reqAppBoolean {get;set;}
    public boolean reqMakeBoolean {get;set;}
    public boolean reqMdlBoolean {get;set;}
    public boolean reqCatBoolean {get;set;}
    public boolean reqComtypBoolean {get;set;}
    public boolean reqUTBoolean {get;set;}
    public boolean reqSTBoolean {get;set;}
    public String SubStatusPrevValue {get;set;}
    public String selectedSubStatusVal { get; set;}
    Public String selectedAppCode {get;set;}
    public string strCntry{get;set;}
    public string strCntryState{get;set;}
    //Global Veriables
    public String filterUnitType{get;set;}
    public String filterSubType{get;set;}
    public String filterMake{get;set;}
    public String filterModel{get;set;}
    public string mil_measure;
    public string fail_measure;
    public String filterCountry;
    public String filterState;
    public string EmailAddress {get;set;}
    public string EmailAddress1 {get;set;}
    public boolean bmsEnabled {get;set;}
     public boolean isClaimEnabled {get;set;}
    public String ShowSubStatuspopup{get;set;}
    //public string selectedLocation {get;set;}
    //String filterApplication {get;set;}
    public String appCode;
       /* Added as per Story# 64030 start*/
    public String filterApplication {get;set;}
    public String filterCategory;
    public String filterCategory2;
    public String filterCategory3;
    public String filterCategory4;
    public String filterCategory5;

    public String filterComplaintType;
    public String filterComplaintType2;
    public String filterComplaintType3;
    public String filterComplaintType4;
    public String filterComplaintType5;
    public CG_BL_Intake CG_BL_IntakeObj = new CG_BL_Intake();
    public CG_cancelServiceJobWrapper cancelSJWrapperObj1{get;set;}
    //public string strCntryState{get;set;}
    /* Added as per Story# 64030 end*/
    Transient public List<CSS_CampTsbTrp__c> lstTSB {get; set;}
     public List<CSS_UserLocation__c> checkclaims = new List<CSS_UserLocation__c>();
    public Boolean higherdateErrFlag{get;set;}
    //End
    public CG_CL_IntakeRJ()
    {
        try {
             substatuscheck = false;
            system.debug('***this***'+this);
            controllerRef = this;
            System.debug('in CG_CL_IntakeRJ constructor $$$$$$$$$$$$$$ controllerRef>>:'+controllerRef);
            ShowSubStatuspopup = 'false';
            allFieldsValidate=false;
            ShowSubStatuspopup = (String)Cache.Session.get('ShowSubStatuspopup2');
            Wid=ApexPages.CurrentPage().getParameters().get('id');
            lstTSB = new List<CSS_CampTsbTrp__c>();
            system.debug('job id--->'+Wid);
            
           
            if(Wid== null) 
            {
               workJob =new css_job_order__c();                    
            } else 
            {    
                mainSOQLs();
               // solCompCTTP = new List<CSS_Solution_Component__c>([select Id, Type__c,URL__c,  Component_Id__c, Campaign_Description__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_Solution_Component__c where Service_Job__c= :Wid AND Type__c in('Campaign','TRP','ATC') and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))  order by Type__c LIMIT 1000]);
                 //Get QSOL Docs for existing ESN And TSB's Accordian query
                lstQSOLDocs = new List<CSS_CampTsbTrp__c>([Select Id, Type__c, Job_Order__c,ESN__c, Doc_Num__c, 
                                                           Doc_Title__c, URL__c, Reviewed__c,Performed__c,
                                                           Performed_Review__c,Cu_Language__c from CSS_CampTsbTrp__c
                                                           where Job_Order__c = :workJob.Id and ESN__c = :workJob.ESN__c
                                                           order by Performed_Review__c desc]);
                system.debug('lstQSOLDocs++++++'+lstQSOLDocs);
             if (lstQSOLDocs.size()>0) {
                 for (CSS_CampTsbTrp__c recQSOLDocs : lstQSOLDocs ) {
                    if (recQSOLDocs.Type__c == 'TSB') { lstTSB.add(recQSOLDocs); }
                 
                 }
            
             }
                //ShowSubStatuspopup = (String)Cache.Session.get('ShowSubStatuspopup2');
                 if (workJob.Make__c==null || workJob.Make__c==''){
                filterMake = '----None----';}else{
                filterMake = workJob.Make__c;
            }

            if (workJob.Model__c==null || workJob.Model__c==''){
                filterModel = '----None----';}else{
                filterModel = workJob.Model__c;
            }

            if (workJob.Country__c=='' || workJob.Country__c=='----None----' || workJob.Country__c==null){
                filterCountry = '----None----';}else{
                strCntry=css_utility.getCountryDesc(workJob.Country__c);
                filterCountry = workJob.Country__c;
                system.debug('rajesh-filterCountry-->'+filterCountry);
            }
                
                system.debug('Appointment val'+workJob.IsAppointment__c);
                if(workJob.IsAppointment__c == null || workJob.IsAppointment__c == 'No') {
                    //AppointmentName = 'No';
                    disableAssignmentBtn = false;
                    system.debug('disableAssignmentBtn IF--'+disableAssignmentBtn );
                } else {
                    //AppointmentName = 'Yes';
                    disableAssignmentBtn = true;
                    system.debug('disableAssignmentBtn Else-'+disableAssignmentBtn );
                }

            if (workJob.CSS_State__c==null || workJob.CSS_State__c=='----None----' || workJob.CSS_State__c==''){
                filterState = '----None----';}else{
                strCntryState=css_utility.getStateDesc(workJob.Country__c, workJob.CSS_State__c);
                filterState = workJob.CSS_State__c;
            }

            if (workJob.Unit_Type__c==null || workJob.Unit_Type__c=='----None----' || workJob.Unit_Type__c==''){
                filterUnitType = '----None----';}else{
                filterUnitType = workJob.Unit_Type__c;
            }
            if (workJob.Sub_Type__c==null || workJob.Sub_Type__c=='----None----' || workJob.Sub_Type__c==''){
                //filterSubType = '----None----';}else{
                filterSubType = 'IS';}else{
                filterSubType = workJob.Sub_Type__c;
            }
                if (workJob.Category_Desc__c==null || workJob.Category_Desc__c=='----None----' || workJob.Category_Desc__c==''){
                filterCategory = '----None----';}else{
                filterCategory = workJob.Category_Desc__c;
            }
            if (workJob.Category2_Desc__c==null || workJob.Category2_Desc__c=='----None----' || workJob.Category2_Desc__c==''){
                filterCategory2 = '----None----';}else{
                filterCategory2 = workJob.Category2_Desc__c;
            }
            if (workJob.Category3_Desc__c==null || workJob.Category3_Desc__c=='----None----' || workJob.Category3_Desc__c==''){
                filterCategory3 = '----None----';}else{
                filterCategory3 = workJob.Category3_Desc__c;
            }
            if (workJob.Category4_Desc__c==null || workJob.Category4_Desc__c=='----None----' || workJob.Category4_Desc__c==''){
                filterCategory4 = '----None----';}else{
                filterCategory4 = workJob.Category4_Desc__c;
            }
            if (workJob.Category5_Desc__c==null || workJob.Category5_Desc__c=='----None----' || workJob.Category5_Desc__c==''){
                filterCategory5 = '----None----';}else{
                filterCategory5 = workJob.Category5_Desc__c;
            }
                if (workJob.Complaint_Type_Desc__c==null || workJob.Complaint_Type_Desc__c=='----None----' || workJob.Complaint_Type_Desc__c==''){
                filterComplaintType = '----None----';}else{
                filterComplaintType = workJob.Complaint_Type_Desc__c;
            }
            if (workJob.Complaint_Type2_Desc__c==null || workJob.Complaint_Type2_Desc__c=='----None----' || workJob.Complaint_Type2_Desc__c==''){
                filterComplaintType2 = '----None----';}else{
                filterComplaintType2 = workJob.Complaint_Type2_Desc__c;
            }
            if (workJob.Complaint_Type3_Desc__c==null || workJob.Complaint_Type3_Desc__c=='----None----' || workJob.Complaint_Type3_Desc__c==''){
                filterComplaintType3 = '----None----';}else{
                filterComplaintType3 = workJob.Complaint_Type3_Desc__c;
            }
            if (workJob.Complaint_Type4_Desc__c==null || workJob.Complaint_Type4_Desc__c=='----None----' || workJob.Complaint_Type4_Desc__c==''){
                filterComplaintType4 = '----None----';}else{
                filterComplaintType4 = workJob.Complaint_Type4_Desc__c;
            }
            if (workJob.Complaint_Type5_Desc__c==null || workJob.Complaint_Type5_Desc__c=='----None----' || workJob.Complaint_Type5_Desc__c==''){
                filterComplaintType5 = '----None----';}else{
                filterComplaintType5 = workJob.Complaint_Type5_Desc__c;
            }
                if(workJob.Email_Address__c != null && workJob.Email_Address__c != '' && workJob.Email_Address__c.contains('@')) {
                    string[] emails = workJob.Email_Address__c.split('@');
                    EmailAddress = emails[0];
                    EmailAddress1 = emails[1];
                }
            if (workJob.Sub_Status__c!=null && workJob.Sub_Status__c!=''){

                selectedSubStatusVal = workJob.Sub_Status__c;
                 system.debug('workJob.Sub_Status__c' + ' ' + workJob.Sub_Status__c + '-if-selectedSubStatusVal-->'+selectedSubStatusVal );
            }
            else
            {
               
                selectedSubStatusVal = 'None';
                 system.debug('workJob.Sub_Status__c' + ' ' + workJob.Sub_Status__c + '-else -selectedSubStatusVal-->'+selectedSubStatusVal);
            }

            }
            //Prida Added below Code (19/03)
            If(workJob.Mileage_Measure__c==null || workJob.Mileage_Measure__c=='')
              mil_measure = 'Miles';
            If(workJob.Failure_Point_Measure__c==null || workJob.Failure_Point_Measure__c=='')
              fail_measure = 'Miles';
            
             list<CSS_UserLocation__c> lstUserLocations = CG_BL_Intake.fetchMultiLocation();
            options = CG_BL_IntakeObj.fetchLocationName(lstUserLocations);
            
            if(string.isNotblank(workJob.Creator_Location__c)){
                    //setting the workjob location to the selectist field for vf 
                    selectedLocation = workJob.Creator_Location__c;
            }
            
            if(Userinfo.getUserId()!=null)
            {
                checkclaims =[select isClaims__c from CSS_UserLocation__c where UserId__c=:Userinfo.getUserId() and isClaims__c = true and isActive__c = true and Location_Source__c = 'ARF' and AccountId__c =:workJob.Account__c];
                if(checkclaims != null && checkclaims.size()>0){
                    isClaimEnabled = true;
                }
                else{
                    isClaimEnabled = false;
                }
            } 
          
        }
        catch(Exception e)  
        {
            system.debug('EXCEPTION of CG_CL_IntakeRJ constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        isDealer = false;
        string userType = css_Utility.getOrgType(userinfo.getUserId());
        if(userType !=null && userType != '') {
            if(userType == 'DLR') {
                 system.debug('DLR*****'+userType);
                isDealer = true;
            }else if(userType == 'DISTR') {
                system.debug('DISTR*****'+userType);
                isDealer = false;
            }
        }

    }

    public void mainSOQLs(){
//Prida Added "TSR_EscalateNumber__c and Failure_Point_Measure__c" to below Query (19/03)
//Added Get_Engine_data_flag__c for the story#183077
        workJob = [Select Id,Get_Engine_data_flag__c,FieldActionWebServiceResult__c ,SPDataWebserviceResult__c,PACCAR_Auth_Required__c,Name,Customer_Name__c,Account__r.ERP_System__c,Account__r.isCampTrp__c,AccessCode__c, Creator_Location__c,CreatedDate,Date_In__c,JobLocation__c,CSS_Job_Location_Code__c,Complaint_Type4_Desc__c, Primary_Segment__c,Failure_Date__c,Failure_Point__c,IsAppointment__c,
                   Customer_Code__c,First_Name__c,TSR_EscalateNumber__c,CSS_Bms_ContactBoolean__c ,CSS_Charge_Account_Status__c,Available_Credit__c, Amount_Due__c, Credit_Limit__c, BMS_Last_Name__c,Email_Address__c,Complaint_Type3_Desc__c, VIN_Flag__c,previousESN_MultiLoc__c,Location_Certification__c,
                   Email_check_box__c ,bmsCreateAccount__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Preventive_Maintenance__c,Complaint_Type2_Desc__c,Qsol_Engine_Family_Code__c,Warranty_Authorization_Flag__c,
                   CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                   
                   Address__c,City__c,ZipCode__c,Country__c,Category2_Desc__c,SP_Country__c, Category3_Desc__c,Category4_Desc__c,Category5_Desc__c ,Sub_Type__c,Application__c, Region__c,Territory__c,Before_In_Service__c,Contact_ID__c,
                   Category_Desc__c ,Complaint_Type_Desc__c,Expedited_Service__c ,Unit_Number__c ,Application_Desc__c,Make__c,Repair_Location__c,CSS_State__c ,BMSStatus__c,ApplicationCode__c,SP_ClaimAllowedDays__c,   
                   Status__c,License_Plate__c,LastModifiedDate,Repeat_Or_Recent_Calc__c,Shop_Work_Order__c,ESN__c,Service_Model__c,Model__c,VIN__c,Mileage__c,CSS_Hours__c,Unit_Type__c,Sub_Status__c, SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,    
                   General_Symptoms__c,Warranty_Start_Date__c,Mileage_Measure__c,Failure_Point_Measure__c,ESN_Locked__c,PSN_Not_Available__c,Date_in_Shop__c,ESN_IA__c , Complaint_Type5_Desc__c, Complaint_Type5__c, isWOServiceFailure__c,
                   (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC)
                   from CSS_Job_Order__c where id= :Wid];
        system.debug('workjob>>>>'+workjob);

        qsolCTTP = [select Type__c,URL__c,  Doc_Num__c, Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__c= :Wid AND Type__c !='TSB'  order by Type__c LIMIT 1000];
        //solCompCTTP = [select Type__c,URL__c,  Component_Id__c, Campaign_Description__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_Solution_Component__c where Service_Job__c= :Wid AND Type__c in('Campaign','TRP','ATC')  order by Type__c LIMIT 1000];
solCompCTTP = [select Type__c,URL__c,  Component_Id__c, Campaign_Description__c, Performed__c,Performed_Review__c,Reviewed__c,Selected_Component__c,Fail_Code__c,AccountCode__c,css_account_formula__c from CSS_Solution_Component__c where Service_Job__c= :Wid AND Type__c in('Campaign','TRP','ATC') and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))  order by Type__c LIMIT 1000];
    }
     public String getfail_measure() 
    {
        return fail_measure;
    }
    public void setfail_measure(String failmeasure) 
    {
        this.fail_measure = failmeasure; 
    }
    public String getmil_measure() 
    {
        return mil_measure;
    }
    public void setmil_measure(String mmeasure) 
    {
        this.mil_measure = mmeasure; 
    }
     public String getfilterMake() 
    {
        return filterMake;
    }
    public void setfilterMake(String mfilterMake) 
    {
        this.filterMake = mfilterMake; 
    }
    public String getfilterModel() 
    {
        return filterModel;
    }
    public void setfilterModel(String mfilterModel) 
    {
        this.filterModel = mfilterModel;
    }
    public String getfilterState() {
        return filterState;
    }

    public void setfilterState(String mfilterState) {
        this.filterState = mfilterState;
    }
     
    public void pageAction() 
    {
        System.debug('IN CG_CL_IntakeWarranty-pageAction method...');
        List<Account> acList;
        String userLocation;
        try {
            if(Cache.Session.get('UserERPSystem') == null)
            {
                if(Wid== null) {
                    User UserObject = [select User_Location__c,FederationIdentifier from user where id=:UserInfo.getUserId() LIMIT 1];
                    userLocation = UserObject.User_Location__c;
                    //userLocation = ((User) [select User_Location__c from user where id=:UserInfo.getUserId() LIMIT 1]).User_Location__c;
                } else 
                {
                    userLocation  = workJob.Creator_Location__c;
                }
                system.debug('userLocation ' + userLocation);
                css_utility.setSessionVariables(userLocation);
            }
            System.debug('ERP>>>:'+Cache.Session.get('UserERPSystem'));
            userERPSystem = (String) Cache.Session.get('UserERPSystem');
            
            //Fetch SP Data Values.
            if(workJob.Id != null && workJob.Territory_Class_Name__c == null) 
                workJob = CG_BL_Intake.fetchSPData(workJob, workJob.creator_location__c, null, workJob.Failure_Date__c, null);
            //Fetch SP Data Values.
            
            //Retrigger Get Campaigns
            if(workJob.FieldActionWebServiceResult__c =='Error'){
                string FailureDateString;
                if(workJob.Failure_Date__c != null){
                    FailureDateString = DateTime.newInstance(workJob.Failure_Date__c.year(),workJob.Failure_Date__c.month(),workJob.Failure_Date__c.day()).format('dd-MMM-YY');
                }
                CG_BL_Campaigns.callGetCampaignsWebServiceOnChevronChangeJob(workJob.ESN__c, FailureDateString, workJob.Region__c, workJob.Territory_Class__c, 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', workJob.Name, workJob.Id);
                //to fetch the updated webservice error flags
                if(Wid != null){
                    workJob.FieldActionWebServiceResult__c = [Select Id,FieldActionWebServiceResult__c from CSS_Job_Order__c where id= :Wid].FieldActionWebServiceResult__c;
                }
            }
        }
        catch(Exception e)  
        {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer pageAction method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('OUT CG_CL_IntakeCustomer-pageAction method...');
    }

     //Redirecting to Job Detail page.
    public PageReference redirectPopup()
    {
        try {
            displayPopup = false;
            pageReference p = new pageReference('/apex/CSS_Job_Detail?nto=HOME');
            p.setRedirect(true);
            return p;
        } catch(exception e) 
        {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer redirectPopup method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }       
    }
    //Save Functionality.
    public PageReference pgSave() 
    {
        system.debug('****************In PgSave******************************');

        if (Wid == null) {
            return null;
        }else{
            saveCheckBox();


            String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
            PageReference pageRef = new PageReference(sDestURL+'id='+Wid); 
            pageRef.setRedirect(true);
            return pageRef;
        }
    }
 //Save and Job Closed functionality.
    public PageReference closeSession() 
    {
        System.debug('**************************B4 entering*****************************');
        css_job_order__c worecord= new css_job_order__c();
        try {
            if(ChkFieldBlank() =='BLANK') {
                return null;
            } else 
            {
                //worecord= saveIntakeCustomer();
                worecord.Status__c='Closed';
                worecord = CG_BL_Intake.mapSPData(workJob, worecord); 
                if(Wid== null) 
                    insert worecord;
                else 
                {
                    worecord.id = Wid;
                    update worecord;
                }               
                system.debug('worecord >>>>> ' + worecord);
                Wid = worecord.id;
                PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
                pageRef.setRedirect(true);
                return pageRef;
            }
        } catch(exception e) 
        {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer closeSession method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }               
    }
     //Cancel Functionality.
    public void Cancel() 
    {
        System.debug('B4 entering');
        css_job_order__c worecord= new css_job_order__c();
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        try {
            if (ChkFieldBlank() =='BLANK') {
                //reqBoolean='true';
                //return null;
            } else {
                //worecord= saveIntakeCustomer();
                worecord.Status__c='Canceled';
                if(Wid== null){ 
                    insert worecord;
                    Wid = worecord.id;
                    cancelSJWrapperObj1.errorFlag = false;
                    cancelSJWrapperObj1.errorMessage = '';
                    cancelSJWrapperObj1.serviceJob = worecord;
                }
                else {
                    //worecord.id = Wid;
                    //update worecord;
                    system.debug('insideelseNoSWO');
                    if(workJob.Account__r.ERP_System__c == 'One BMS'){
                        cancelSJWrapperObj1 = CG_BL_Intake.cancel(workJob,worecord);
                    }
                    else{
                        worecord.id=workJob.id;
                        update worecord;
                        cancelSJWrapperObj1.errorFlag = false;
                        cancelSJWrapperObj1.errorMessage = '';
                        cancelSJWrapperObj1.serviceJob = worecord;
                    }
                }               
                system.debug('cancelSJWrapperObj1 >>>>> ' + cancelSJWrapperObj1);
                system.debug('worecord >>>>> ' + worecord);
                //Wid = cancelSJWrapperObj1.serviceJob.id;
            }
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer Cancel method >>> '+e.getMessage() + e.getLineNumber());
            //return null;
        }       
    }

    // Begin Chevron Navigation methods
    public PageReference nvIntakeCustomer(){
        PageReference pageRef;
        if(wid==null){
            pageRef = new pageReference('/apex/CG_IntakeCustomer');
        }
        else{
            pageRef = new pageReference('/apex/CG_IntakeCustomer?id='+wid); 
            pageRef.setRedirect(true);
        }
        return pageRef;

    }

    public PageReference nvIntakeUE(){
        PageReference pageRef;
        if(wid==null){
            pageRef = new pageReference('/apex/CG_IntakeUE');
        }
        else{
            pageRef = new pageReference('/apex/CG_IntakeUE?id='+wid); 
            pageRef.setRedirect(true);
        }
        return pageRef;

    }

    public PageReference nvIntakeCC(){
        PageReference pageRef;
        if(wid==null){
            pageRef = new pageReference('/apex/CG_IntakeCC');
        }
        else{
            pageRef = new pageReference('/apex/CG_IntakeCC?id='+wid); 
            pageRef.setRedirect(true);
        }
        return pageRef;

    }

    public PageReference nvIntakeVH(){
        PageReference pageRef;
        if(wid==null){
            pageRef = new pageReference('/apex/CG_IntakeVH');
        }
        else{
            pageRef = new pageReference('/apex/CG_IntakeVH?id='+wid); 
            pageRef.setRedirect(true);
        }
        return pageRef;

    }

    public PageReference nvIntakeWarranty(){
        PageReference pageRef;
        if(Wid==null){
            system.debug('ifwid>>>>>'+wid);
            pageRef = new pageReference('/apex/CG_IntakeWarranty'); 
        }
        else{
            system.debug('ifwid>>>>>'+wid);
            pageRef = new pageReference('/apex/CG_IntakeWarranty?id='+wid); 
            pageRef.setRedirect(true);
        }
        return pageRef;

    }
    
    
    //Fetching Country Values.
    public List<SelectOption> getCountry() {
        List<SelectOption> CountryList = new List<SelectOption>(); 
        try {  
            CountryList = CG_BL_IntakeObj.getCountry();
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - getCountry Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return CountryList;
    }
    
    // End Chevron Navigation methods
    /* code added for tsps and trps  start*/
    Transient map<string,CSS_CampTsbTrp__c> qsolCTTPMap = new map<string,CSS_CampTsbTrp__c>(); //Defect fix 95870
public map<string,CSS_Solution_Component__c> solCompCTTPMap = new map<string,CSS_Solution_Component__c>();
    
    public integer getCamps(){
        list<CSS_CampTsbTrp__c> qsol = new list<CSS_CampTsbTrp__c>();
        if(qsolCTTP != null){
            for(CSS_CampTsbTrp__c qsolcam : qsolCTTP){
                if(qsolcam.type__c.equalsIgnoreCase('CAM')){
                    qsol.add(qsolcam);
                }
            }
        }
        return qsol.size();
    }
    public integer getTrps(){
        list<CSS_CampTsbTrp__c> qsol1 = new list<CSS_CampTsbTrp__c>();
        if(qsolCTTP != null){
            for(CSS_CampTsbTrp__c qsoltrp : qsolCTTP){
                if(qsoltrp.type__c.equalsIgnoreCase('TRP')){
                    qsol1.add(qsoltrp);
                }
            }
        }
        return qsol1.size();
    }
    //Added as per story#63175
    public integer getAtcs(){
        list<CSS_CampTsbTrp__c> qsol2 = new list<CSS_CampTsbTrp__c>();
        if(qsolCTTP != null){
            for(CSS_CampTsbTrp__c qsolatc : qsolCTTP){
                if(qsolatc.type__c.equalsIgnoreCase('ATC')){
                    qsol2.add(qsolatc);
                }
            }
        }
        return qsol2.size();
    }
    public integer getTsbs(){
        list<CSS_CampTsbTrp__c> qsol3 = new list<CSS_CampTsbTrp__c>();
        if(lstQSOLDocs != null){
            for(CSS_CampTsbTrp__c qsoltsbs : lstQSOLDocs){
                if(qsoltsbs.type__c.equalsIgnoreCase('TSB')){
                    qsol3.add(qsoltsbs);
                }
            }
        }
        return qsol3.size();
    }  
    
    public void saveCheckBox(){
        system.debug('inside savecheckbox in CG_CL_IntakeRJ');
        if(comm !='' && comm !=null ){
            system.debug('JobID' +Wid);
            Note x = new Note();
            x.Title = 'CAMPCOMMENTS';
            x.ParentId = Wid;  
            x.Body = comm;

            //   system.debug('**MG calling**');
            //  if(x != null && !comm.isEmpty()){
            insert x;
            // }
        }
        System.debug('before updating solCompCTTP>>>:'+solCompCTTP);
        if(solCompCTTP != null && !solCompCTTP.isEmpty()){
            update solCompCTTP;
            System.debug('after updating solCompCTTP>>>:'+solCompCTTP);
        }
        
        
    }
    /* code added for tsps and trps ended */
     public String getfilterCategory() 
    {
        System.debug('********getfilterCategory'+filterCategory );
        return filterCategory;
    }
    public String getfilterCountry() 
    {
        return filterCountry;
    }
    public void setfilterCountry(String mfilterCountry) {
        this.filterCountry = mfilterCountry; 
    }
    public String getfilterCategory2() 
    {
        System.debug('********getfilterCategory2'+filterCategory2 );
        return filterCategory2;
    }
     /* Required String input Parameters to be passed */
    //3. WO-WOQT Inbound request param variables 
    static String CSSJobID;
    static String ESN;
    static String Model;
    static String Make;
    static String ServiceModelName1;
    static String DistributorCode;
    static String BranchCode;
    static String OrderType;
    static String CustomerNumber;
    static String Inshop;
    static String CreateDate;
    static String PromisedDate;
    static String BillType;
    static String CustNamePhone;
    static String SubType;
    static String UnitNumber;
    static String EngineFamily;
    static String Application; 
    public PageReference validateBeforeSave()
    {      
        system.debug('userERPSystem--'+userERPSystem);
        //Validation for customer name field
        if (workJob.Customer_Name__c==null || workJob.Customer_Name__c=='')  {
            reqBoolean=true;
            allFieldsValidate=true;
            return null;
        }else { reqBoolean=false;
               allFieldsValidate=false;}
               //validation for Shop_Work_Order__c
        if ((workJob.Shop_Work_Order__c==null || workJob.Shop_Work_Order__c=='') && isDealer)  {
            //reqBoolean=true;
            reqBooleanshop=true;
            allFieldsValidate=true;
            return null;
        }else if(workJob.Shop_Work_Order__c==null || workJob.Shop_Work_Order__c==''){
            //reqBoolean=false;
            reqBooleanshop=false;
               allFieldsValidate=false;}
        //Validation for customer code field
        if ((userERPSystem =='BMS Legacy' || userERPSystem =='One BMS') && (workJob.Customer_Code__c==null || workJob.Customer_Code__c==''))  {
            reqCusNumBoolean=true;
            allFieldsValidate=true;
            return null;
        }else { reqCusNumBoolean=false;
               allFieldsValidate=false;}
        //Validation for phone number field
        boolean Error = false;
        if(userERPSystem =='BMS Legacy' || userERPSystem =='One BMS'){
            if(workJob.Phone_Number__c != null)
                Error = css_utility.CheckPhoneNoIsValid(workJob.Phone_Number__c);
            if(workJob.Phone_Number__c == null || workJob.Phone_Number__c == '') {
                reqPhnnoBoolean = true;
                reqPhnnototalchar = false;
                allFieldsValidate = true;
                if(!Test.isRunningtest())
                    return null; 
            }
            else if(Error) {
                reqPhnnoBoolean = false;
                reqPhnnototalchar = true;
                allFieldsValidate = true;
                if(!Test.isRunningtest())
                    return null;
            }
            else if(!Error){
                reqPhnnoBoolean = false;
                reqPhnnototalchar = false; 
                allFieldsValidate = false; 
            }

        }
        else {
            reqPhnnoBoolean = false;
            reqPhnnototalchar = false; 
            allFieldsValidate = false;
        }
        //Validation for First Name field
        if ((userERPSystem =='BMS Legacy' || userERPSystem =='One BMS') && (workJob.First_Name__c == null || workJob.First_Name__c == '')){
            reqFrstNamBoolean = true;
            allFieldsValidate=true;
            if(!Test.isRunningtest())
                return null;  
        }else{
            reqFrstNamBoolean = false;
            allFieldsValidate=false;
        }
        //Validation for Last Name
        if ((userERPSystem =='BMS Legacy' || userERPSystem =='One BMS') && (workJob.BMS_Last_Name__c == null || workJob.BMS_Last_Name__c == '')){
            reqLastNamBoolean = true;
            allFieldsValidate=true;
            if(!Test.isRunningtest())
                return null;  
        }else{
            reqLastNamBoolean = false;
            allFieldsValidate=false;
        }
        //validation for Customer Contact's Phone field
        //START -92817
        system.debug('workJob.Cstmr_Contacts_Phone__c ' + workJob.Cstmr_Contacts_Phone__c);
        if (userERPSystem =='BMS Legacy' || userERPSystem =='One BMS') {
            boolean Error1 = false;
            if(workJob.Cstmr_Contacts_Phone__c != null)
                Error1 = css_utility.CheckPhoneNoIsValid(workJob.Cstmr_Contacts_Phone__c);
            if(workJob.Cstmr_Contacts_Phone__c == null || workJob.Cstmr_Contacts_Phone__c == '') {
                reqCstmrContactPhnBoolean = true;
                reqCstmrContactPhntotalchar = false;
                allFieldsValidate=true;
                if(!Test.isRunningtest())
                    return null; 
            } else if(Error1) {
                reqCstmrContactPhnBoolean = false;
                reqCstmrContactPhntotalchar = true;
                allFieldsValidate=true;
                if(!Test.isRunningtest())
                    return null; 
            } else if(!Error1) {
                reqCstmrContactPhnBoolean = false;
                reqCstmrContactPhntotalchar = false; 
                allFieldsValidate=false;
            }
        } else {
            reqCstmrContactPhnBoolean = false;
            reqCstmrContactPhntotalchar = false; 
            allFieldsValidate=false;
        }
        //END -92817

        //validation for Email Field
        if ((userERPSystem =='BMS Legacy' || userERPSystem =='One BMS') && (workJob.Email_Address__c == null || workJob.Email_Address__c == '')){
            reqEmailBoolean = true;
            allFieldsValidate=true;
            reqEmailValidBoolean=false;
            if(!Test.isRunningtest())
                return null;  
        }else{

            if((userERPSystem =='BMS Legacy' || userERPSystem =='One BMS') && workJob.Email_Address__c != null && workJob.Email_Address__c != ''){ //code added by roopa for email story

                reqEmailBoolean = css_utility.validateEmail(workJob.Email_Address__c);

                if(reqEmailBoolean == false){
                    system.debug('Inside Email IF');
                    reqEmailValidBoolean = true;
                    allFieldsValidate=true;
                    return null;
                    //reqEmailBoolean = false;
                }
                else{
                    system.debug('Inside Email ELSE');
                    reqEmailBoolean = false;
                    allFieldsValidate=false;
                    reqEmailValidBoolean=false;
                }
            }
        }
        //validation for ESN field start
        if ( (workJob.ESN__c==null || workJob.ESN__c=='') && workjob.ESN_Locked__c == false && workJob.PSN_Not_Available__c == false){
            reqESNBoolean=true;
            /* ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter value'));
             return null;*/
            allFieldsValidate=true;
            return null;
        }else { reqESNBoolean=false;
               allFieldsValidate=false;}
        system.debug('validation for ESN field start>>>'+allFieldsValidate);
        //validation for ESN field end
        //validation for Unit Number Field
   /*     if (workJob.Unit_Number__c==null || workJob.Unit_Number__c==''){
            system.debug('Printing IF');
            reqUNumBoolean=true;
            allFieldsValidate=true;
            if(!Test.isRunningtest())
                return null;
        }else { system.debug('Printing Else');
               reqESNBoolean=false;
               allFieldsValidate=false;}*/
        system.debug('workJob.Unit_Number__c>>>>>>'+workJob.Unit_Number__c);
        system.debug('validation for Unit Number Field>>>'+allFieldsValidate);
        //validation for unit number field end

        //validation for Application field
        if (workJob.Application_Desc__c  == null || workJob.Application_Desc__c  == '----None----'){
            reqAppBoolean=true;
            allFieldsValidate=true;
            if(!Test.isRunningtest())
                return null;
        }else { reqAppBoolean=false;
               allFieldsValidate=false;}
        system.debug('validation for Application field>>>'+allFieldsValidate);
        //validation for Application field end

        //Validation for Make field start
        if (workJob.Make__c==null || workJob.Make__c == '----None----'){
            reqMakeBoolean=true;
            allFieldsValidate=true;
            return null;
        }else { reqMakeBoolean=false;
               allFieldsValidate=false;}
        system.debug('Validation for Make field start>>>'+allFieldsValidate);
        //Validation for Make field end

        //Validation for Model field start
        if (workJob.Model__c==null || workJob.Model__c == '----None----'){
            reqMdlBoolean=true;
            allFieldsValidate=true;
            return null;
        }else { reqMdlBoolean=false;
               allFieldsValidate=false;}
        system.debug('Validation for Model field start'+allFieldsValidate);
        //Validation for Model field end
        //
        if (workJob.Category_Desc__c == null || workJob.Category_Desc__c == '' || workJob.Category_Desc__c == '----None----'){
            reqCatBoolean=true;
            allFieldsValidate=true;
            return null;
        }
        else { reqCatBoolean=false;
              allFieldsValidate=false;}
        system.debug('Validation for Model field end>>>>>'+allFieldsValidate);
       
         if((userERPSystem =='BMS Legacy' || userERPSystem =='One BMS') && workJob.PSN_Not_Available__c == false && (workJob.Unit_Number__c=='' || workJob.Unit_Number__c==null || workJob.Unit_Number__c=='----None----')){
             system.debug('InsidePSNNotAvchk>>'+reqUNumBoolean);
             reqUNumBoolean=true;
             allFieldsValidate = true;
             return null;
         }
         else{ reqUNumBoolean=false;
              allFieldsValidate = false;
             }
        //Prida Added below Code (19/03)
           //Anirudh Defect Fix
        if((userERPSystem =='BMS Legacy' || userERPSystem =='One BMS') && workJob.PSN_Not_Available__c == false && (workJob.Unit_Type__c=='' || workJob.Unit_Type__c==null || workJob.Unit_Type__c=='----None----')){
            system.debug('InsidePSNNotAvchk>>'+reqUTBoolean);
            reqUTBoolean=true;
            allFieldsValidate = true;
            return null;
        }
        else
        {
            reqUTBoolean=false;
            allFieldsValidate = false;
        }

        if((userERPSystem =='BMS Legacy' || userERPSystem =='One BMS') && workJob.PSN_Not_Available__c == false && (workJob.Sub_Type__c=='' || workJob.Sub_Type__c==null || workJob.Sub_Type__c=='----None----')){
            system.debug('InsidePSNNotAvchk>>'+reqSTBoolean);
            reqSTBoolean=true;
            allFieldsValidate = true;
            return null;
        }
          else
        {
            reqSTBoolean=false;
            allFieldsValidate = false;
        }
        //Anirudh Defect Fix End

        //validation for Complaint Type start
        if (workJob.Complaint_Type_Desc__c == null || workJob.Complaint_Type_Desc__c == '' || workJob.Complaint_Type_Desc__c == '----None----'){
            reqComtypBoolean=true;
            allFieldsValidate=true;
            return null;
        }
        else{ reqComtypBoolean=false;
             allFieldsValidate=false;}
system.debug('userERPSystemkal**'+userERPSystem);
        //validation for Complaint Type start
        String validateFields = ChkFieldBlank();
        if (ChkFieldBlank() =='VALIDATE'){
            system.debug('ChkFieldBlank--'+ChkFieldBlank());
            return null;
        }
        else{
            //Call the Wo-Woqt inbound and Wo Comment inbound
            if(userERPSystem =='BMS Legacy' || userERPSystem =='One BMS'){
                system.debug('Inside If statement for BMS');
                if (callCreateWoAndUpdateComment()) {
                    system.debug('inside if ******page message');
                    return null;
                }
                else{

                }

            }
            //Prida Commented below Code (19/03)
            //Commented by Satish on 03/05/2018
            //CSS_JobOrderWrapper wrap;
            css_job_order__c worecord= new css_job_order__c();
            //if(userERPSystem =='BMS Legacy' || userERPSystem =='One BMS')
            //wrap = new CSS_JobOrderWrapper(workJob,filterMake,filterModel,mil_measure,fail_measure,filterCountry,filterState,true,EmailAddress,EmailAddress1,false);
            //else
               // wrap = new CSS_JobOrderWrapper(workJob,filterMake,filterModel,mil_measure,fail_measure,filterCountry,filterState,false,EmailAddress,EmailAddress1,false);
            //worecord = wrap.worecord;
            //worecord.Mileage_Measure__c = mil_measure;
            //worecord.Failure_Point_Measure__c = fail_measure;
            //worecord.Unit_Type__c=filterUnitType;
            //worecord.Sub_Type__c=filterSubType;
            //worecord.Application_Desc__c=filterApplication;
            //worecord.Application_Desc__c=workJob.Application_Desc__c;
            //if(filterApplication != '' && mapDescriptionToCode != null){
                //appCode = mapDescriptionToCode.get(filterApplication);
            //}
            //worecord.ApplicationCode__c=appCode;
            //worecord.ApplicationCode__c=workJob.ApplicationCode__c;
            //worecord.Category_Desc__c=filterCategory;
            //worecord.Category2_Desc__c=filterCategory2;
            //worecord.Category3_Desc__c=filterCategory3;
            //worecord.Category4_Desc__c=filterCategory4;
            //worecord.Category5_Desc__c=filterCategory5;
            worecord.Contact_ID__c = workJob.Contact_ID__c;
            //worecord.Complaint_Type_Desc__c=filterComplaintType;
            //worecord.Complaint_Type2_Desc__c=filterComplaintType2;
            //worecord.Complaint_Type3_Desc__c=filterComplaintType3;
            //worecord.Complaint_Type4_Desc__c=filterComplaintType4;
            //worecord.Complaint_Type5_Desc__c=filterComplaintType5;
            worecord.Previous_Status__c = workJob.Status__c;
            //Prida Added below Code (19/03)
            worecord.Shop_Work_Order__c =workJob.Shop_Work_Order__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;
worecord.BMSStatus__c = workJob.BMSStatus__c;
            worecord = CG_BL_Intake.mapSPData(workJob, worecord); 
            
            system.debug('In PGSave assign BMSWSStatus__c+++++++++++++'+workJob.BMSStatus__c);
            worecord.BMSStatus__c = workJob.BMSStatus__c;
            worecord.isWOServiceFailure__c = workJob.isWOServiceFailure__c; //GSSC-86
            worecord.Status__c='Intake Complete';
            SubStatusPrevValue=workJob.Sub_Status__c;
            
            if (workJob.Sub_Status__c!=null && workJob.Sub_Status__c!=''){

                selectedSubStatusVal = workJob.Sub_Status__c;
                 system.debug('workJob.Sub_Status__c' + ' ' + workJob.Sub_Status__c + 'If-selectedSubStatusVal-->'+selectedSubStatusVal);
            }
            else {
                selectedSubStatusVal = '--Select One--';
                 system.debug('workJob.Sub_Status__c' + ' ' + workJob.Sub_Status__c + 'Else -selectedSubStatusVal-->'+selectedSubStatusVal);
            }
            
            if(SubStatusPrevValue != selectedSubStatusVal){
                worecord.Sub_Status__c =selectedSubStatusVal;
                worecord.LastUpdateSubStatus__c= system.now();
            }
            saveCheckBox();
            if (Wid == null)
                //Prida commented below Code (19/03)
            {
                //worecord.jobLocation__c=jobLocation;
                //start story 92895 setting location field based on the advace profile
                //worecord.jobLocation__c = getLocationLabel(selectedLocation);
                //worecord.CSS_Job_Location_Code__c = selectedLocation;
                //end story 92895
                // worecord.Before_In_Service__c = true;
                //insert worecord;
                //Wid = worecord.id;
                //system.debug('Inside If statement');
                return null;

            }
            else
            {
                //  System.Debug('value of customer===='+workJob.customer_name__c);
                worecord.id=workJob.id;
                worecord.account__c = CG_BL_Intake.FetchAccountId(selectedLocation);
                //start story 92895 setting location field based on the advace profile
                //worecord.jobLocation__c = getLocationLabel(selectedLocation);
                //worecord.CSS_Job_Location_Code__c = selectedLocation;
                //system.debug('selectedLocation>>>>>'+selectedLocation);
                //system.debug('worecord.CSS_Job_Location_Code__c>>>>>'+worecord.CSS_Job_Location_Code__c);
                //end story 92895
                //if(workjob.Warranty_Start_Date__c != null){worecord.Before_In_Service__c = false;}      
               // else{//worecord.Before_In_Service__c = false;
                //}
                //system.debug('worecord1----'+worecord);
                //system.debug('workJob----'+workJob);
                update worecord;
                System.Debug('record updated====='+worecord);
                system.debug('Inside else statement');
                //assign the values to the string 
               /* if(worecord != null){
                    system.debug('inside worrrrrrr');
                    CSSJobID = worecord.Id;
                    ESN = worecord.ESN__c;
                    Model = worecord.Model__c;
                    Make = worecord.Make__c;
                    ServiceModelName1 = worecord.Service_Model__c;
                    system.debug('Inside filterMakeworecord----'+Model+Make);
                }*/


            }


        }
        system.debug('cache session');
        Cache.Session.put('ShowSubStatuspopup2', 'true');
        //ShowSubStatuspopup='true';
        //ShowSubStatuspopup = (String)Cache.Session.get('ShowSubStatuspopup2');
        PageReference pageRef = new pageReference('/apex/CG_IntakeRJ?id='+workJob.id); 
        pageRef.setRedirect(true);
        return pageRef;
        
    }
    public Boolean substatuscheck {get;set;}
    public PageReference pgSaveAssign(){
        system.debug('pgSaveAssign');
        PageReference pageRef;
        css_job_order__c worecord= new css_job_order__c();
        Cache.Session.put('ShowSubStatuspopup2', 'false');
        worecord.Id = workJob.Id;
       /*worecord.Previous_Status__c = workJob.Status__c;
        worecord.Status__c='Intake Complete'; This line code is commented to fix the defect number 111234*/
        SubStatusPrevValue=workJob.Sub_Status__c;
        system.debug('SubStatusPrevValue>>>>>>>'+SubStatusPrevValue);
        if(SubStatusPrevValue != selectedSubStatusVal){
            worecord.Sub_Status__c =selectedSubStatusVal;
            worecord.LastUpdateSubStatus__c= system.now();
        }
        update worecord;
        system.debug('selectedSubStatusVal-->'+selectedSubStatusVal);
        if(selectedSubStatusVal == null || selectedSubStatusVal =='' || selectedSubStatusVal == '--Select One--'){
            substatuscheck = true;
            system.debug('substatuscheck1111'+substatuscheck);
              //pageRef = null;
              return null;
              
            // pageRef.setRedirect(true);
        }
        else{
            substatuscheck = false;
            system.debug('substatuscheck2222'+substatuscheck);
            pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
        }
       
      // pageRef.setRedirect(true);
       return pageRef;
        /* redirct to Job Page*/

    }
    public string ChkFieldBlank()
    {

        if ((workJob.Customer_Name__c == null) && (workJob.Shop_Work_Order__c == null) &&(workJob.Application__c == null) && (workJob.Unit_number__c == null) && (workJob.Mileage__c == null)&& (workJob.ESN__c== null) 
            && (workJob.Status__c == null) && (workJob.General_Symptoms__c == null || workJob.General_Symptoms__c == ''))
        {
            System.Debug('in BLANK==============');
            return 'BLANK';
        }
        //Modified as per story# 64030
        //else if ((workJob.Customer_Name__c == null || workJob.Customer_Name__c == '') || (workJob.Application__c == null || workJob.Application__c == ''))
        else if ((workJob.Customer_Name__c == null || workJob.Customer_Name__c == '') || (workJob.Application_Desc__c == null || workJob.Application_Desc__c == ''))
        {
            System.Debug('in VALIDATE==============');
            system.debug('workJob.Customer_Name__c--'+workJob.Customer_Name__c);
            system.debug('workJob.Application_Desc__c--'+workJob.Application_Desc__c);
            return 'VALIDATE';
        }
        else
        {
            System.Debug('in FILLED==============');
            return 'FILLED';
        }
    }
    // Method to call the WO-WOQT Inbound to create work order,Unit Inbound  and WO Comment Inbound webservice to update the Comments(S-67572) .
    public string DefaultInshop;
    public CSS_unitInboundJSON2Apex UIResp{get;set;}
    Public string BMSwarningMsg1 {get;set;}
    Public string BMSwarningMsg2 {get;set;}
    Public boolean dispBMSWarningMsg {get; set;}
    public String BMSReferenceNumber;
    static String Comment;
    


    public boolean callCreateWoAndUpdateComment(){

        try{
            SelectedAppCode = workjob.Application_Desc__c;
            dispBMSWarningMsg=false;

            // UIResp='';
            if(workJob.Unit_Number__c !=null && workJob.PSN_Not_Available__c == false){
                system.debug('SelectedAppCode-->'+SelectedAppCode);
                string applicationCode = css_utility.getCodes('Application Code',SelectedAppCode,null,null);
                system.debug('applicationCode--'+applicationCode);
                String FailureDateForUnitInbound;
                if(workJob.Failure_Date__c != null){
                datetime FailureDt = workJob.Failure_Date__c;
               FailureDateForUnitInbound = FailureDt.format('dd-MMM-yyyy','GMT') + ' ' + '13:00:00';//FailureDt.format('HH:mm:ss','GMT'); YYYY is modified to yyyy by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
                }
                String WarrantyStartDateforUnitInbound;
                if(workJob.Warranty_Start_Date__c != null){
                datetime WrntyDt = workJob.Warranty_Start_Date__c;
                //Prida Added below Code (19/03)
                WarrantyStartDateforUnitInbound = WrntyDt.format('dd-MMM-yyyy','GMT'); // YYYY is modified to yyyy by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31 
                }
                //Call the Unit Inbound Service
                UIResp = new CSS_unitInboundJSON2Apex();
                List<CSS_Integration_Error__c> lsterrObj = new List<CSS_Integration_Error__c>();
                //making a call to update the details
                UIResp = CSS_WS_BMS.callUnitInbound(workJob.Customer_Code__c,workJob.Unit_Number__c,workJob.Unit_Type__c,workJob.Model__c,workJob.VIN__c,workJob.Make__c,workJob.Service_Model__c,workJob.ESN__c,workJob.Qsol_Engine_Family_Code__c,applicationCode,workJob.Creator_Location__c,workJob.Mileage_Measure__c.toUpperCase(),string.valueof(workJob.Mileage__c),string.valueof(workJob.CSS_Hours__c),(FailureDateForUnitInbound == null ? '' : FailureDateForUnitInbound),(WarrantyStartDateforUnitInbound == null ? '' : WarrantyStartDateforUnitInbound),workJob.AccessCode__c);
                system.debug('UIResp>>>>>>>>'+UIResp);

                System.debug('>>:UIResp.DataArea>>:'+UIResp.DataArea+' UIResp.Header>>>>>>>:'+UIResp.Header + 'UIResp.DataArea.UnitNumber.trim()>>>>:'+UIResp.DataArea.UnitNumber.trim());
                if(UIResp.DataArea !=null && UIResp.Header!=null && UIResp.Header.Status!=null && UIResp.Header.Status=='SUCCESS' && UIResp.DataArea.UnitNumber != null && UIResp.DataArea.UnitNumber.trim() != '')
                {
                    workJob.Unit_Number__c= UIResp.DataArea.UnitNumber;//
                    if(workJob.BMSStatus__c !=null && workJob.BMSStatus__c.trim() !=''){
                        workJob.BMSStatus__c = workJob.BMSStatus__c + ','+'UI0';
                    }else {
                        workJob.BMSStatus__c = 'UI0';
                    }
                    system.debug('BMSStatus__c+++++++++++++'+workJob.BMSStatus__c);
                    workJob.isWOServiceFailure__c = false; //GSSC-86
                }
                system.debug('UIResp.Header.Status**'+UIResp.Header.Status);
                system.debug('UIResp.Header.Status.trim()**'+UIResp.Header.Status.trim());
                system.debug('UIResp.DataArea.UnitNumber abc' + UIResp.DataArea.UnitNumber);
                if(UIResp == null || UIResp.Header == null || UIResp.Header.Status == 'ERROR' || UIResp.Header.Status.trim() == 'ERROR' || (UIResp != null && UIResp.DataArea != null && (UIResp.DataArea.UnitNumber == null || UIResp.DataArea.UnitNumber == ''))){ //GSSC-86
                    system.debug('Inside If1**');
                    workJob.isWOServiceFailure__c = true;
                    //dispBMSWarningMsg=true;
                    //BMSwarningMsg1=UIResp.Header.ReturnCodeDescription; 
                                  }
                
            }else{
            system.debug('Inside else1**');
                //  dispBMSWarningMsg=true;
                //BMSwarningMsg1='Unit Number';

            }


            if(workJob.Repair_Location__c == 'Mobile'){
                DefaultInshop = 'N';
            }else{DefaultInshop = 'Y';}
              datetime currentDate_Failuredate = System.now(); 
            String currentTimeZoneInfo = currentDate_Failuredate.format('yyyy-MM-dd\'T\'HH:mm:ss'); //Added 187666 
            String failurDateToString = String.valueOf(workJob.Failure_Date__c);//Added 187666, Modified the Created date to Failure Date to based on story number 182481
            String currentTimeStampVal = currentTimeZoneInfo.Right(8);//Added 187666 
            DateTime currDateTimeInfo  = datetime.valueOf(failurDateToString+' '+currentTimeStampVal);//Added 187666 
            String currDate = currDateTimeInfo.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss'); //Added 187666
             
            //datetime currentDate= workJob.Failure_Date__c; // Modified the Created date to Failure Date to based on story number 182481
            //string currDate = currentDate.format('YYYY-MM-dd','GMT')+ 'T' + currentDate_Failuredate.format('HH:mm:ss','GMT');
             if(workJob.PSN_Not_Available__c == true)
                workJob.Unit_Number__c = '';
            system.debug('checking the esn'+workjob.ESN__c);
            system.debug('checking unit number'+workjob.Unit_Number__c); 
            //Modified as per story# 64030
            //CSS_BMSWOQTInboundJSON2APEX woqtRes = CSS_WS_BMS.callBMSWOQTInboundService(workJob.Name,'WO',workJob.Customer_Code__c,DefaultInshop,currDate,currDate,'Customer',CSS_utility.getSubStringValue(workJob.First_Name__c, 0, 15) + ',' + CSS_utility.getSubStringValue(workJob.BMS_Last_Name__c, 0, 15) ,workJob.Cstmr_Contacts_Phone__c,workJob.Sub_Type__c,workJob.Unit_Number__c,workJob.Model__c,workJob.Make__c,workJob.Service_Model__c,workJob.Qsol_Engine_Family_Code__c,workJob.ESN__c,workJob.Application__c,workJob.Creator_Location__c,(workJob.Contact_ID__c == null ? '' : workJob.Contact_ID__c));
           //if(UIResp.DataArea !=null && UIResp.Header!=null && UIResp.Header.Status!=null && UIResp.Header.Status=='SUCCESS' && UIResp.DataArea.UnitNumber != null && UIResp.DataArea.UnitNumber.trim() != ''){ //GSSC-86, if UnitInbound is success, then only call the WOQT and Comment Services.
           if(workJob.PSN_Not_Available__c == true || (UIResp != null && UIResp.DataArea !=null && UIResp.Header!=null && UIResp.Header.Status!=null && UIResp.Header.Status=='SUCCESS' && UIResp.DataArea.UnitNumber != null && UIResp.DataArea.UnitNumber.trim() != '')){ //GSSC-357, Changes condition to call woqt directly when psn not available is true as unit inbound is not required when psn is not available .
            CSS_BMSWOQTInboundJSON2APEX woqtRes = CSS_WS_BMS.callBMSWOQTInboundService(workJob.Name,'WO',workJob.Customer_Code__c,DefaultInshop,currDate,currDate,'Customer',CSS_utility.getSubStringValue(workJob.First_Name__c, 0, 15) + ',' + CSS_utility.getSubStringValue(workJob.BMS_Last_Name__c, 0, 15) ,workJob.Cstmr_Contacts_Phone__c,workJob.Sub_Type__c,workJob.Unit_Number__c,workJob.Model__c,workJob.Make__c,workJob.Service_Model__c,workJob.Qsol_Engine_Family_Code__c,workJob.ESN__c,workJob.Application_Desc__c,workJob.Creator_Location__c,(workJob.Contact_ID__c == null ? '' : workJob.Contact_ID__c),(workJob.Email_Address__c== null ? '' : workJob.Email_Address__c),(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),'');
            system.debug('woqtRes>>>>>>>>'+woqtRes);
            if(woqtRes.DataArea.WOReferenceNumber != null && woqtRes.DataArea.WOReferenceNumber != '' && woqtRes.DataArea.WOReferenceNumber != '0') // Updated WOReferenceNumber  not equal to null based on the defect number 187062 
                BMSReferenceNumber = woqtRes.DataArea.WOReferenceNumber;
            system.debug('BMSReferenceNumber>>>>*****'+BMSReferenceNumber);
            workJob.Shop_Work_Order__c = BMSReferenceNumber;
            if(woqtRes.DataArea.ContactID != null && woqtRes.DataArea.ContactID != '0')
                workJob.Contact_ID__c = woqtRes.DataArea.ContactID;
            if(woqtRes.DataArea !=null && woqtRes.Header!=null && woqtRes.Header.Status!=null && woqtRes.Header.Status=='SUCCESS' && woqtRes.DataArea.WOReferenceNumber != null && woqtRes.DataArea.WOReferenceNumber.trim() != '0')
            {
                if(workJob.BMSStatus__c !=null && workJob.BMSStatus__c.trim() !=''){
                    workJob.BMSStatus__c = workJob.BMSStatus__c + ','+'WC1';
                }else {
                    workJob.BMSStatus__c = 'WC1';
                }
                system.debug('BMSStatus__c+++++++++++++'+workJob.BMSStatus__c);
            }
            Comment = concatenateStrings();
            //  Call the WO Comment Inbound BMS Webservice to update the Comment .
           // if(woqtRes.Header.Status=='ERROR'){
           if(woqtRes == null || woqtRes.Header == null || woqtRes.Header.Status=='ERROR' || woqtRes.Header.Status.trim()=='ERROR' || (woqtRes != null && woqtRes.DataArea != null && (woqtRes.DataArea.WOReferenceNumber == null || woqtRes.DataArea.WOReferenceNumber == ''))){ //GSSC-86, commented above condition
                //dispBMSWarningMsg=true;
                //BMSwarningMsg2=woqtRes.Header.ReturnCodeDescription; 
                workJob.BMSStatus__c = 'WC0';
                workJob.isWOServiceFailure__c = true; //GSSC-86
                
            }
            /****** Moved to Narrative Chevron ******/
           if(woqtRes.Header.Status!=null && (woqtRes.Header.Status=='SUCCESS' || woqtRes.Header.Status.trim()=='SUCCESS')){ //GSSC-86
            if(BMSReferenceNumber!='0'){
                /*******Commented as part of Story No 80882 : Anirudh *******
                sendAdminSRTtoBMS();
                ********** End Story No :80882 *****************/

                String Comment1;    
                if(Comment!='' && Comment!=null){
                    Comment1 = Comment.replace('\r\n','\\n');
                    Comment1= Comment1.replace('\n','\\n');
                } 
                System.debug('Comment1*******'+Comment1);
                CSS_WOCommentInboundJson2Apex woCommentRes1 = CSS_WS_BMS.callWOCommentInboundService(workJob.Creator_Location__c,workJob.Name,'WO', 
                                                                                                     BMSReferenceNumber, 'COMPLAINT' , Comment1,(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),'',currDate,'');
            }else{
                //dispBMSWarningMsg=true;
                //BMSwarningMsg2 = woqtRes.Header.ReturnCodeDescription; 
            } 
            }
           }
        }catch(exception ex){
            System.debug('Exception in WOQT: '+ex.getMessage());
            System.debug('Exception in WOQT: '+ex.getLineNumber());
        }
        return dispBMSWarningMsg;
    }
     //method to get the label of the selected location code from the Ui i.e it returs the location name which we will stamp on the work job .
    public string getLocationLabel(string selectedLocation){
        string selectedLocationName;
        if(options !=null && options.size()>0){
            //for loop to set the location name selected on the user screen based on the location code .
            for(SelectOption s : options){
                if(s.getValue() == selectedLocation){
                    selectedLocationName = s.getLabel();
                }
                system.debug('selectedLocationName--->'+selectedLocationName);
            }
        }
        return selectedLocationName;
    }

    //Method to concatenate the Complaint type and Category 
    public String concatenateStrings(){
        System.debug('entered into concatenateStrings.............');
        //      return serviceJob.Category__c + ':' + serviceJob.Complaint_Type__c +','+serviceJob.Category2__c + ':' + serviceJob.Complaint_Type2__c +','+serviceJob.Category3__c + ':' + serviceJob.Complaint_Type3__c +','+serviceJob.Category4__c + ':' + serviceJob.Complaint_Type4__c +','+serviceJob.Category5__c + ':' + serviceJob.Complaint_Type5__c+','+serviceJob.General_Symptoms__c ;

        //77158- Story86428 Only customer complaint should go to BMS - By Krishna at 29/03/2017.
        //return (workJob.Category__c==null ? '' : 'Category = '+workJob.Category__c+ '\\n') + (workJob.Complaint_Type__c==null ? '' : 'Complaint type = '+workJob.Complaint_Type__c +'\\n') + (workJob.Category2__c==null ? '' : 'Category = '+workJob.Category2__c+ '\\n') + (workJob.Complaint_Type2__c==null ? '' : 'Complaint type = '+workJob.Complaint_Type2__c+'\\n') + (workJob.Category3__c==null ? '' :'Category = '+workJob.Category3__c+ '\\n') + (workJob.Complaint_Type3__c==null ? '':'Complaint type = '+workJob.Complaint_Type3__c+'\\n') + (workJob.Category4__c==null ? '':'Category = '+workJob.Category4__c+ '\\n') + (workJob.Complaint_Type4__c ==null ? '':'Complaint type = '+workJob.Complaint_Type4__c+'\\n') + (workJob.Category5__c ==null ? '':'Category = '+workJob.Category5__c+ '\\n') + (workJob.Complaint_Type5__c ==null ? '' : 'Complaint type = '+workJob.Complaint_Type5__c + '\\n') + (string.isBlank(workJob.General_Symptoms__c) ? '' : 'Customer Complaint = '+ workJob.General_Symptoms__c +'\\n'); 
        return (string.isBlank(workJob.General_Symptoms__c) ? '' :  workJob.General_Symptoms__c);
        //77158- Story86428 Only customer complaint should go to BMS - By Krishna at 29/03/2017.
    }
        map<string,string> mapDescriptionToCode;
    //Methhod to get Application codes and Description values from siebel web service

    public List<SelectOption> getApplication() {
        List<SelectOption> lstApplications ; 
        try {

            CSS_JobEventTemporary__c[] applicationCodes;

            applicationCodes = [select Reason__c from CSS_JobEventTemporary__c where attribute1__c = 'ApplicationCodes'];
            system.debug('applicationCodes>>>'+applicationCodes);
            string jsonResponse = applicationCodes[0].Reason__c;
            CSS_WPR_SBL_ApplicationResJSON resJSON;
            //jsonResponse='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "N","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
            resJSON = (CSS_WPR_SBL_ApplicationResJSON)JSON.deserialize(jsonResponse ,CSS_WPR_SBL_ApplicationResJSON.class);

            //create a map with code and description
            mapDescriptionToCode = new map<string,string>();

            lstApplications = new List<SelectOption>();
            lstApplications.add(new SelectOption('','----None----'));

            if(resJSON  != null && resJSON.DataArea != null && resJSON.DataArea.Details != null ){
                for(CSS_WPR_SBL_ApplicationResJSON.Details det : resJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.ApplicationCode!='890' && det.ApplicationCode!='891'){  // karthik G added as part of GSSC-512
                        lstApplications.add(new SelectOption(det.Description,det.ApplicationCode+' - '+det.Description));
                    //populating description to code map 
                    mapDescriptionToCode.put(det.Description,det.ApplicationCode);
                    }
                }
            }

            system.debug('lstApplications>>>'+lstApplications);

            lstApplications.sort();
        }
        catch(exception e)
        {}
        return lstApplications;
    }
    public string locationName{get;set;}
    public string selectedLocation {get;set;}
    public list<CSS_UserLocation__c> lstUserLocations;
    List<SelectOption> options;
    //method to fecth all the locations based on the logged in user 
    public List<SelectOption> getLocationsName() {
        options = new List<SelectOption>();
        try {
            lstUserLocations = CG_BL_Intake.fetchMultiLocation();
            options = CG_BL_IntakeObj.fetchLocationName(lstUserLocations);
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustNoERP - getLocationsName Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('OUT CG_CL_IntakeCustNoERP - getLocationsName Method ...' + options);
        return options;
    }
    
    public map<string,boolean> mapLocationBmsFlag = new map<string,boolean>() ;
    public map<string,string> mapLocationBmsUrl = new map<string,string>();
    public integer locationChangeCounter = 0 ;
    public string selectedoldLocation;
    public string locationChangeValue{get;set;}
    public string sessionlocationChangeValue;
    //method to determine various outcomes when the location is changed.
    public void changeLocationOutcomes(){
        //condtion to check the new job creation .
        if(wid == null){
            //Code to set the BMS Flag when new workJob location is changed to other than the primary location by user
            if(mapLocationBmsFlag != null && mapLocationBmsFlag.size() > 0 ){
                bmsEnabled = mapLocationBmsFlag.get(selectedLocation); 
            }
        }
        else{
            //Code to set the BMS Flag when existing workJob location is updated by user 
            if(mapLocationBmsFlag != null && mapLocationBmsFlag.size() > 0 ){
                //increementing the count when the location is change for the existing job 
                locationChangeCounter = locationChangeCounter + 1;
                //first change of location while changing location of existing job 
                if(locationChangeCounter == 1){
                    //condition to check the change of location from bms to non bms
                    if(mapLocationBmsFlag.get(workjob.Creator_Location__c ) == true && mapLocationBmsFlag.get(selectedLocation) == false) {
                        bmsEnabled = false;
                        selectedoldLocation = selectedLocation; //storing the old selected location for the second change on the same screen
                        locationChangeValue = 'b2n';

                        workJob.Customer_Code__c = '';
                        workJob.Phone_Number__c = '';
                        workJob.First_Name__c = '';
                        workJob.BMS_Last_Name__c = '';
                        workJob.Cstmr_Contacts_Phone__c = '';
                        //workJob.customer_phone__c = '';
                        
                        workJob.Address__c = '';
                        workJob.City__c = '';
                        workJob.Country__c = '';
                        workJob.CSS_State__c = '';
                        filterCountry = '----None----';
                        filterState = '----None----';
                        strCntry = '';
                        strCntryState = '';
                        workJob.ZipCode__c = '';
                        //filterApplication = '';
                        //workJob.Application_Desc__c = '';
                        workJob.Shop_Work_Order__c = '';
                        system.debug('workJob.Country__c>>>'+workJob.Country__c);
                        system.debug('workJob.CSS_State__c>>>'+workJob.CSS_State__c);
                    }
                    //condition to check the change of location from non Bms to bms 
                    else if(mapLocationBmsFlag.get(workjob.Creator_Location__c ) == false && mapLocationBmsFlag.get(selectedLocation) == true){
                        bmsEnabled = true;
                        selectedoldLocation = selectedLocation; //storing the old selected location for the second change on the same scren
                        locationChangeValue = 'n2b';
                        workJob.bmsCreateAccount__c = false;
                        workJob.Shop_Work_Order__c = '';
                        //Anirudh change
                        if(workJob.ESN__c != null && workJob.ESN__c != '')
                             workJob.previousESN_MultiLoc__c = workJob.ESN__c;
                        workJob.ESN__c = '';
                        workJob.Unit_Number__c= '';
                        workJob.Service_Model__c = '';
                        filterMake = '----None----';
                        workJob.Make__c = '';
                        workJob.Model__c = '';
                        filterModel = '----None----';
                        workJob.VIN__c = '';
                        workJob.Warranty_Start_Date__c = null;
                        //Anirudh change
                    }
                    //condition to check the change of location from Bms1 to bms2
                    else if(mapLocationBmsFlag.get(workjob.Creator_Location__c ) == true && mapLocationBmsFlag.get(selectedLocation) == true){
                        bmsEnabled = true;
                        selectedoldLocation = selectedLocation; //storing the old selected location for the second change on the same scren
                        if(mapLocationBmsUrl != null && mapLocationBmsUrl.size() > 0){
                            //condition to check the location change from bms1 instance to bms1 instance 
                            if(mapLocationBmsUrl.get(workjob.Creator_Location__c ) ==  mapLocationBmsUrl.get(selectedLocation)){
                                locationChangeValue = 'b2b';
                            }
                            //condition to check the change from BMS1 to BMS2 instance
                            else if(mapLocationBmsUrl.get(workjob.Creator_Location__c ) !=  mapLocationBmsUrl.get(selectedLocation)){
                                locationChangeValue = 'b12b2';
                                workJob.Customer_Code__c = '';
                                workJob.Cstmr_Contacts_Phone__c = '';
                                workJob.First_Name__c = '';
                                workJob.BMS_Last_Name__c = '';
                                workJob.Customer_Code__c = '';
                                workJob.Phone_Number__c = '';
                                workJob.Address__c = '';
                                workJob.City__c = '';
                                workJob.Country__c = '';
                                workJob.CSS_State__c = '';
                                filterCountry = '----None----';
                                filterState = '----None----';
                                strCntry = '';
                                strCntryState = '';
                                workJob.ZipCode__c = '';
                                filterApplication = '';
                                appCode = '';
                                workJob.Application_Desc__c = '';
                                workJob.bmsCreateAccount__c = false;
                                //Anirudh Change
                                if(workJob.ESN__c != null && workJob.ESN__c != '')
                                     workJob.previousESN_MultiLoc__c = workJob.ESN__c;
                                workJob.ESN__c = '';
                                workJob.Unit_Number__c= '';
                                //start -->To fix the defect 98996 
                                workJob.Service_Model__c = '';
                                filterMake = '----None----';
                                workJob.Make__c = '';
                                workJob.Model__c = '';
                                filterModel = '----None----';
                                workJob.VIN__c = '';
                                workJob.Warranty_Start_Date__c = null;
                                //end -->To fix the defect 98996
                                //Anirudh Change End

                                system.debug('previousESN_MultiLoc__c ------->'+workJob.previousESN_MultiLoc__c);
                            }
                        }

                    }
                }
                //consecutive change of location  of existing job on same screen
                else{
                    //condition to check the change of location from bms to non bms
                    if(mapLocationBmsFlag.get(selectedoldLocation) == true && mapLocationBmsFlag.get(selectedLocation) == false) {
                        bmsEnabled = false;
                        selectedoldLocation = selectedLocation; //storing the old selected location for the second change on the same screen
                        locationChangeValue = 'b2n';
                        workJob.Customer_Code__c = '';
                        workJob.Phone_Number__c = '';
                        workJob.First_Name__c = '';
                        workJob.BMS_Last_Name__c = '';
                        workJob.Cstmr_Contacts_Phone__c = '';
                        filterCountry = '----None----';
                        filterState = '----None----';
                        workJob.Address__c = '';
                        workJob.City__c = '';
                        workJob.Country__c = '';
                        workJob.CSS_State__c = '';
                        strCntry = '';
                        strCntryState = '';
                        workJob.ZipCode__c = '';
                        //filterApplication = '';
                        //workJob.Application_Desc__c = '';
                        workJob.Shop_Work_Order__c = '';
                        system.debug('workJob.Country__c>>>'+workJob.Country__c);
                        system.debug('workJob.CSS_State__c>>>'+workJob.CSS_State__c);
                    }
                    //condition to check the change of location from non Bms to bms 
                    else if(mapLocationBmsFlag.get(selectedoldLocation ) == false && mapLocationBmsFlag.get(selectedLocation) == true){
                        bmsEnabled = true;
                        selectedoldLocation = selectedLocation; //storing the old selected location for the second change on the same scren
                        locationChangeValue = 'n2b';
                        workJob.Shop_Work_Order__c = '';
                        workJob.bmsCreateAccount__c = false;
                        //Anirudh change
                        if(workJob.ESN__c != null && workJob.ESN__c != '')
                             workJob.previousESN_MultiLoc__c = workJob.ESN__c;
                        workJob.ESN__c = '';
                        workJob.Unit_Number__c= '';
                        workJob.Service_Model__c = '';
                        filterMake = '----None----';
                        workJob.Make__c = '';
                        workJob.Model__c = '';
                        filterModel = '----None----';
                        workJob.VIN__c = '';
                        workJob.Warranty_Start_Date__c = null;
                        //Anirudh change
                    }
                    //condition to check the change of location from Bms1 to bms2
                    else if(mapLocationBmsFlag.get(selectedoldLocation) == true && mapLocationBmsFlag.get(selectedLocation) == true){
                        bmsEnabled = true;
                        //selectedoldLocation = selectedLocation; //storing the old selected location for the second change on the same scren
                        system.debug('existing change bms to bms**** ');
                        if(mapLocationBmsUrl != null && mapLocationBmsUrl.size() > 0){
                            //condition to check the location change from bms1 instance to bms1 instance 
                            if(mapLocationBmsUrl.get(selectedoldLocation) ==  mapLocationBmsUrl.get(selectedLocation)){
                                locationChangeValue = 'b2b';
                                selectedoldLocation = selectedLocation; //storing the old selected location for the second change on the same scren
                                system.debug('locationChangeValue b to b --> '+locationChangeValue);
                            }
                            //condition to check the change from BMS1 to BMS2 instance
                            else if(mapLocationBmsUrl.get(selectedoldLocation) !=  mapLocationBmsUrl.get(selectedLocation)){
                                locationChangeValue = 'b12b2';
                                selectedoldLocation = selectedLocation; //storing the old selected location for the second change on the same scren
                                workJob.Customer_Code__c = '';
                                workJob.Cstmr_Contacts_Phone__c = '';
                                workJob.First_Name__c = '';
                                workJob.BMS_Last_Name__c = '';
                                workJob.Customer_Code__c = '';
                                workJob.Phone_Number__c = '';
                                workJob.Address__c = '';
                                workJob.City__c = '';
                                workJob.Country__c = '';
                                workJob.CSS_State__c = '';
                                filterCountry = '----None----';
                                filterState = '----None----';
                                strCntry = '';
                                strCntryState = '';
                                workJob.ZipCode__c = '';
                                filterApplication = '';
                                appCode = '';
                                workJob.Application_Desc__c = '';
                                workJob.bmsCreateAccount__c = false;
                                //Anirudh Change
                                if(workJob.ESN__c != null && workJob.ESN__c != '')
                                     workJob.previousESN_MultiLoc__c = workJob.ESN__c;
                                workJob.ESN__c = '';
                                workJob.Unit_Number__c= '';
                                //start -->To fix the defect 98996 
                                workJob.Service_Model__c = '';
                                filterMake = '----None----';
                                workJob.Make__c = '';
                                workJob.Model__c = '';
                                filterModel = '----None----';
                                workJob.VIN__c = '';
                                workJob.Warranty_Start_Date__c = null;
                                //end -->To fix the defect 98996
                                //Anirudh Change End

                                system.debug('customer Contact --->'+workJob.Cstmr_Contacts_Phone__c);
                                system.debug('locationChangeValue b1 to b2 --> '+locationChangeValue);
                            }
                        }

                    }
                }

            }

            if(locationChangeValue != null && locationChangeValue != ''){
                //passing the locationChangeValue through session variable
                Cache.Session.put('locationChangeKey', locationChangeValue);
                Cache.Session.put('warrantyLocationChangeKey', locationChangeValue);
            }
workJob.Contact_ID__c = '';
        }
        workJob.bmsCreateAccount__c = false;
        workJob.CSS_Bms_ContactBoolean__c = false;
    }
    // Method to call Unit Inbound WebService and store the Customer Code value

    public CSS_CustomerInboundJSON2APEX CustomerInboundRes{get;set;}
    public string strBMSAccountMsg {get; Set;}
    public boolean BMScrAcFlag;
    public boolean bmsCustInbound(){
        CustomerInboundRes = new CSS_CustomerInboundJSON2APEX();
        BMScrAcFlag=false;
        //making a callout to send the details to BMS
        try{

            //Modified as per story# 64030
            //String primarySgmntCD = css_utility.getCodes('Primary Segment',workjob.application__c,null,null);
            String primarySgmntCD = css_utility.getCodes('Primary Segment',filterApplication,null,null);
            system.debug('primarySgmntCD -->'+ primarySgmntCD);
            // To get User Location
            //Id userId = UserInfo.getUserId();
            string usrLoc ='';
            if(!Test.isRunningTest()){
                //User usr = css_utility.getUserAttributes(userId);
                //usrLoc = usr.User_Location__c;
                usrLoc = selectedLocation;
            }else{
                usrLoc  = 'testLoc';
            }
            System.debug('SelCountryCode '+ filterCountry + ' SelectedStateCode '+ filterState);

            CustomerInboundRes = CSS_WS_BMS.callBMSCustInboundService(workJob.Customer_Name__c,workJob.Address__c,'','',workJob.Phone_Number__c.substring(1,4),workJob.Phone_Number__c.substring(6,14),workJob.City__c,filterState,workJob.ZipCode__c,'',css_utility.getSubStringValue(workJob.First_Name__c, 0, 15) + css_utility.getSubStringValue(workJob.BMS_Last_Name__c, 0, 15),filterCountry,'en',primarySgmntCD,usrLoc);
            if(CustomerInboundRes.Header.Status=='SUCCESS'){
                BMScrAcFlag=true;
                workJob.Customer_Code__c = CustomerInboundRes.DataArea.CustomerCode;
                //strBMSAccountMsg=CustomerInboundRes.Header.ReturnCodeDescription;
            }else{
                BMScrAcFlag=false;
                strBMSAccountMsg=CustomerInboundRes.Header.ReturnCodeDescription;
                system.debug('strBMSAccountMsg>>>'+strBMSAccountMsg);
            }

        }
        catch(exception ex){
            System.debug('Excepton in CSS_WS_BMS.callBMSCustInboundService: '+ex.getLineNumber() +' '+ ex.getMessage());
        }
        return BMScrAcFlag;
    }
    public CSS_BMS_SRTReq req;
    /********* This Method is not Being Called as part of Story 80882 but will be reused later - Anirudh ********/
    public void sendAdminSRTtoBMS(){
        // if(!srtList.isEmpty() && srtList.size()>0){
        try{
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

            // To Send Srt's with Type 'WOQT'
            List<CSS_BMS_SRTReq.DataArea> dt = new List<CSS_BMS_SRTReq.DataArea>();
            //  for(CSS_SRT__c srtRec:srtList){
            //Modified as per story# 64030
            //if(workJob.Application__c == 'Recreational Vehicle' || workJob.Application__c == 'Recreational Vehicle Ad'){
            if(workJob.Application_Desc__c == 'Recreational Vehicle' || workJob.Application_Desc__c == 'Recreational Vehicle Ad'){
                CSS_BMS_SRTReq.DataArea DTA = new CSS_BMS_SRTReq.DataArea();
                // String SRT = srtRec.SRT_ID__c;
                /*String[] SRTId;
String GroupNum;
String ProcedureNum;
String StepNum;
if(SRT!=null && SRT!='')
SRTId= SRT.split('-');
if(SRTId != null && SRTId.size()>0){
GroupNum = SRTId[0];
ProcedureNum = SRTId[1];
if(SRTId.size()>2)
StepNum =  SRTId[2];
}
*/              if(workJob.ESN__c!= null && workJob.ESN__c !='')
    DTA.Accesscode = workJob.AccessCode__c;
                else
                    DTA.Accesscode = 'R';
                if(workJob.Name==null)    
                    DTA.CSSJobID = '';
                else
                    DTA.CSSJobID = workJob.Name;

                DTA.OrderType = 'WO';
                DTA.ShopWOnumber = BMSReferenceNumber;
                if(workJob.ESN__c!= null && workJob.ESN__c !='')
                    DTA.Model = workJob.Qsol_Engine_Family_Code__c;
                else
                    DTA.Model = '10';

                DTA.Location = workJob.Creator_Location__c;
                DTA.Bill = 'Y';
                DTA.SRTgroupnum='00';
                DTA.Procedureno ='904';
                DTA.Stepnumber ='';
                DTA.SRTquantity = '1';                   
                DTA.SRTTime = '54'; //string.valueof(srtRec.Diagnosis_Time__c); 
                dt.add(DTA);
            }else 

            {  
                if(workJob.Repair_Location__c == 'In Shop'){
                    CSS_BMS_SRTReq.DataArea DTA = new CSS_BMS_SRTReq.DataArea();
                    // String SRT = srtRec.SRT_ID__c;
                    /*String[] SRTId;
String GroupNum;
String ProcedureNum;
String StepNum;
if(SRT!=null && SRT!='')
SRTId= SRT.split('-');
if(SRTId != null && SRTId.size()>0){
GroupNum = SRTId[0];
ProcedureNum = SRTId[1];
if(SRTId.size()>2)
StepNum =  SRTId[2];
}
*/
                    if(workJob.ESN__c!=null && workJob.ESN__c!='')
                        DTA.Accesscode = workJob.AccessCode__c;
                    else
                        DTA.Accesscode = 'R';
                    if(workJob.Name==null)    
                        DTA.CSSJobID = '';
                    else
                        DTA.CSSJobID = workJob.Name;

                    DTA.OrderType = 'WO';

                    if(BMSReferenceNumber==null)
                        DTA.ShopWOnumber = '';
                    else    
                        DTA.ShopWOnumber = BMSReferenceNumber;
                    if(workJob.ESN__c!= null && workJob.ESN__c !='')
                        DTA.Model = workJob.Qsol_Engine_Family_Code__c;
                    else
                        DTA.Model = '10';


                    DTA.Location = workJob.Creator_Location__c;
                    DTA.Bill = 'Y';
                    DTA.SRTgroupnum='00';
                    DTA.Procedureno ='901';
                    DTA.Stepnumber ='';


                    DTA.SRTquantity = '1';

                    DTA.SRTTime = '24'; //string.valueof(srtRec.Diagnosis_Time__c); 
                    dt.add(DTA);

                }else if(workJob.Repair_Location__c == 'Mobile'){
                    CSS_BMS_SRTReq.DataArea DTA = new CSS_BMS_SRTReq.DataArea();
                    // String SRT = srtRec.SRT_ID__c;
                    /*String[] SRTId;
String GroupNum;
String ProcedureNum;
String StepNum;
if(SRT!=null && SRT!='')
SRTId= SRT.split('-');
if(SRTId != null && SRTId.size()>0){
GroupNum = SRTId[0];
ProcedureNum = SRTId[1];
if(SRTId.size()>2)
StepNum =  SRTId[2];
}
*/
                    if(workJob.ESN__c!=null && workJob.ESN__c!='')
                        DTA.Accesscode = workJob.AccessCode__c;
                    else
                        DTA.Accesscode = 'R';
                    if(workJob.Name==null)    
                        DTA.CSSJobID = '';
                    else
                        DTA.CSSJobID = workJob.Name;

                    DTA.OrderType = 'WO';

                    if(BMSReferenceNumber==null)
                        DTA.ShopWOnumber = '';
                    else    
                        DTA.ShopWOnumber = BMSReferenceNumber;
                    if(workJob.ESN__c!= null && workJob.ESN__c !='')
                        DTA.Model = workJob.Qsol_Engine_Family_Code__c;
                    else
                        DTA.Model = '10';


                    DTA.Location = workJob.Creator_Location__c;
                    DTA.Bill = 'Y';
                    DTA.SRTgroupnum='00';
                    DTA.Procedureno ='902';
                    DTA.Stepnumber ='';


                    DTA.SRTquantity = '1';

                    DTA.SRTTime = '42'; //string.valueof(srtRec.Diagnosis_Time__c); 
                    dt.add(DTA);
                }
            }
            system.debug('dt --->'+dt);
            req.DataArea = dt;
            system.debug('req.DataArea********'+req.DataArea);
            // dt.SRT = srtSelctdList;

            // }else{
            //   system.debug('Error Report');
            // }
            CSS_WS_BMS.callJobPlanInboundService(req);  
        }catch(exception e){

        }
    }    
}