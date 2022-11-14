/**********************************************************************
Name:CG_CL_IntakeUE
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is used for Unit&Engine functionalities
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Surender M         12/20/2017      Redesigning Development                   
***********************************************************************/
public class CG_CL_IntakeUE
{
    //Global Veriables
    public CG_CL_IntakeUE controllerRef{get;set;}
    public CSS_Job_order__c workJob{set;get;}
    public Id Wid;
    public String userERPSystem{set;get;}
    public String region{get;set;}

    public CSS_accountLanguage__c accountlang{get; set;}
    public String filterApplication {get;set;}
    public String filterUnitType{get;set;}
    public String filterSubType{get;set;}
    public String filterMake{get;set;}
    public String filterModel{get;set;}
    public boolean PSNFlag{get;set;}//Stroy#183077
    public String filterCountry{get;set;}
    public String filterState{get;set;}
    public Map<String,String> mapDescriptionToCode;
    public string mil_measure;
    public string fail_measure;
    public string datebyLocaleValue {get;set;}
    public Boolean displayPopup {get;set;}
    public Date tempFailureDate;
    public Boolean displayWSDErrorMsg {get;set;}
    public Boolean isClaimEnabled {get;set;}
    public Boolean prodcodeErrormessage {get;set;}
    
    // public Boolean DontSaveJob {get;set;}
    //Global Veriables

    Transient public List<CSS_CampTsbTrp__c> lstCAM {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTRP {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTSB {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstATC {get; set;}

    Transient List<CSS_CampTsbTrp__c> qsolCTTP {get;set;}
    Transient List<CSS_Solution_Component__c> solCompCTTP {get;set;} //Kalpana
    Transient map<string,CSS_CampTsbTrp__c> qsolCTTPMap = new map<string,CSS_CampTsbTrp__c>(); //Defect fix 95870
    Transient map<string,CSS_CampTsbTrp__c> qsolCampMap = new map<string,CSS_CampTsbTrp__c>(); //Defect 95870 fix
    Transient List<CSS_CampTsbTrp__c> lstQSOLDocs;
    Transient public list<CSS_CampTsbTrp__c> campList{get;set;}
    list<CSS_CampTsbTrp__c> qsolCTTP9 = new list<CSS_CampTsbTrp__c>();
    public CG_cancelServiceJobWrapper cancelSJWrapperObj1{get;set;}
    public List<CSS_UserLocation__c> checkclaims;


    //Setter/Getter Methods start
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

    public String getfilterState() 
    {
        return filterState;
    }
    public void setfilterState(String mfilterState) 
    {
        this.filterState = mfilterState;
    }
    public String getfilterUnitType() 
    {
        return filterUnitType;
    }    
    public void setfilterUnitType(String mfilterUnitType) 
    {
        this.filterUnitType = mfilterUnitType;
    }  
    public String getfilterSubType() 
    {
        return filterSubType;
    } 
    public void setfilterSubType(String mfilterSubType) 
    {
        this.filterSubType = mfilterSubType;
    }  

    public String getmil_measure() 
    {
        return mil_measure;
    }
    public void setmil_measure(String mmeasure) 
    {
        this.mil_measure = mmeasure; 
    }
    public String getfail_measure() 
    {
        return fail_measure;
    }
    public void setfail_measure(String failmeasure) 
    {
        this.fail_measure = failmeasure; 
    }
    
    public string previousPSN{get;set;}
    public boolean startRequestCalled{get;set;}

    //Constructor.
    public CG_CL_IntakeUE(){
        System.debug('IN CG_CL_IntakeUE constructor...');
        try {
            // DontSaveJob=false;
            controllerRef = this;
            Wid=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('Wid**'+Wid);
            if(Wid== null) {
                workJob =new css_job_order__c();                    
            } else {    
                workJob=[Select Id,Account__r.Warranty_Training_Certification__c, Account__r.Warranty_Training_Status__c, Account__r.CERTIFICATION_END_DATE__c,Get_Engine_data_flag__c,SPDataWebserviceResult__c,FieldActionWebServiceResult__c,PACCAR_Auth_Required__c,Name,IsAppointment__c, PSN_PACCAR_Flag__c, bmsCreateAccount__c,Account__c,Account__r.WR_Certfication_Flag__c,Account__r.Region__c,CSS_Bms_ContactBoolean__c,Email_Address__c,Email_check_box__c,BMSStatus__c,Contact_ID__c,Customer_Name__c,Customer_Code__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Address__c,City__c,ZipCode__c,Country__c,CSS_Charge_Account_Status__c,Shop_Work_Order__c,Application__c, Unit_Number__c, Status__c, css_resolution__c,CSS_Feedback_Comments__c, Previous_Status__c,previousESN_MultiLoc__c,date_in__c,Date_in_Shop__c,
                         ESN__c, ESN_IA__c, First_Name__c,BMS_Last_Name__c, Mileage__c,CSS_Hours__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, LastModifiedDate,CreatedDate, Location_Certification__c,CSS_State__c,Primary_Segment__c,Before_In_Service__c,ESN_Locked__c, 
                         Make__c,Model__c,CG_NoWarrantyFlag__c,AccessCode__c,Failure_Date__c,Failure_Point__c,Failure_Point_Measure__c,Service_Model__c,VIN__c,VIN_Flag__c,Warranty_Start_Date__c,Region__c,Creator_Location__c,EditCoverage__c,Unit_Type__c, Sub_Type__c,Account__r.ERP_System__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                         Repeat_Visit__c,TSR_EscalateNumber__c,Automotive_App_Flag__c,RecentVisit__c,Repeat_Or_Recent_Calc__c,JobLocation__c,CSS_Job_Location_Code__c,CreatedById,Qsol_Engine_Family_Code__c,Repair_Location__c,Territory__c,Warranty_Authorization_Flag__c,PSN_Not_Available__c,Sub_Status__c,LastUpdateSubStatus__c,Actual_Technician_Time__c,SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,
                         CSS_Channel_Code__c,Account__r.Product_Certification__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c, 
                         BillToCode__c,BuildDate__c,ProductApplicationCode__c,DesignPhaseCode__c,EngineFamilyCode__c,ShipDate__c, ETOOldESN__c, EngineFamilyName__c,EtoConversionDate__c,MarineFlag__c,OemCode__c,
                         ProductApplicationDesp__c,warrantyIndicatorFlag__c,SP_ClaimAllowedDays__c,SP_Country__c,CSS_Mission_Disabling__c,ReconEngineFlag__c,ProductAppcodeErrorflag__c,License_Plate__c,
                         (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC),Category__c,Category2__c,Category3__c,Category4__c,Category5__c,Complaint_Type__c,Complaint_Type2__c,Complaint_Type3__c,Complaint_Type4__c,Complaint_Type5__c, Preventive_Maintenance__c,Expedited_Service__c, Category_Desc__c, Category2_Desc__c, Category3_Desc__c, Category4_Desc__c, Category5_Desc__c, Complaint_Type_Desc__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, Application_Desc__c,ApplicationCode__c,
                         (Select Id,Name, Case_Name__c, Service_Job__c,Repair_response__c,Solution_Title__c ,Solution__c,Diagnostic_Response__c FROM CSS_Solutions__r),
                         (Select id, name , performed__c, performed_review__c, Reviewed__c from CSS_CampTsbTrp__r where( job_order__C=:Wid and( performed_review__c=True and performed__c=False))),
                         (select Id,name,OrderReference__c from css_quotes__r)
                         from CSS_Job_Order__c where id= :Wid];
            }
            previousPSN = (workJob != null ? workJob.ESN__c : '');
            startRequestCalled = false;
            //userERPSystem = (String) Cache.Session.get('UserERPSystem'); //not need this stmt since there in pageAction method
            system.debug('***workjob***'+workJob);
            lstCAM = new List<CSS_CampTsbTrp__c>();
            lstTSB = new List<CSS_CampTsbTrp__c>();
            lstTRP = new List<CSS_CampTsbTrp__c>();
            lstATC = new List<CSS_CampTsbTrp__c>();

            if(Userinfo.getUserId()!=null)
            {
                checkclaims =[select isClaims__c from CSS_UserLocation__c where UserId__c=:Userinfo.getUserId() and isClaims__c = true and Location_Source__c = 'ARF' and isActive__c = true];
                if(checkclaims.size()>0){
                    isClaimEnabled = true;
                }
                else{
                    isClaimEnabled = false;
                }
            }
            
             //This block is added to make failure date as today date using story number 182481
            if(workJob.Status__c == 'Appointment' && workJob.Failure_Date__c == null){
                workJob.Failure_Date__c = null;
            }else if(workJob.Status__c != 'Appointment' && workJob.Failure_Date__c == null ){
                workJob.Failure_Date__c = system.today();
            }else{
               workJob.Failure_Date__c = workJob.Failure_Date__c;
            }

            if(workJob.Warranty_Start_Date__c > date.today() && workJob.Status__c !='Appointment')
            {
                displayWSDErrorMsg = true;
            }
            else{
                displayWSDErrorMsg = false;
            }
            system.debug('***displayWSDErrorMsg***'+displayWSDErrorMsg);
            //Story#183077
            if(workJob!=null){
                if(workJob.ESN__c!=null && workJob.ESN__c!='' && string.isNotBlank(workJob.ESN__c))
                PSNFlag=workJob.Get_Engine_data_flag__c;
                else
                PSNFlag=false;
            }
            
            //end
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeUE constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('returning from CG_CL_IntakeUE constructor...');
    }

    //Page Loading Action.
    public void pageAction(){
        System.debug('IN CG_CL_IntakeUE pageAction method...');
        User userObj;
        List<Account> acList;
        String userLocation;
        String selectedLocation;
        try {
            userERPSystem = (String) Cache.Session.get('UserERPSystem');
            System.debug('current1 userERPSystem-->'+Cache.Session.get('UserERPSystem'));
            if(userERPSystem != null && userERPSystem != '') {
                selectedLocation = (String) Cache.Session.get('selectedLocation');

            }else if(workJob !=null && workJob.Creator_Location__c !=null && workJob.Creator_Location__c.trim() !=''){
                css_utility.setSessionVariables(workJob.Creator_Location__c);

            }else if(Wid== null) {
                userObj = [select Id,UserLoginCounter__c,CSS_User_MultiLocValues__c,LastLoginDate,UserPreviousLoginDate__c, UserGroup__c,User_Location__c,User_Role__c, UserRoleName__c,Product_Group_Access__c,Work_Group_Name__c,FederationIdentifier,LanguageLocaleKey from user where id=:UserInfo.getUserId() LIMIT 1];
                css_utility.setSessionVariables(userObj.User_Location__c);

            } else {
                userObj = [select Id,UserLoginCounter__c,CSS_User_MultiLocValues__c,LastLoginDate,UserPreviousLoginDate__c, UserGroup__c,User_Location__c,User_Role__c, UserRoleName__c,Product_Group_Access__c,Work_Group_Name__c,FederationIdentifier,LanguageLocaleKey from user where id=:UserInfo.getUserId() LIMIT 1];
                css_utility.setSessionVariables(userObj.User_Location__c);

            }
            userERPSystem = (String) Cache.Session.get('UserERPSystem');
            System.debug('current2 userERPSystem-->'+userERPSystem);
            //The below code should move to BL layer & to components if possible
            //code for prerequisites of Components
            if(userObj == null){
                userObj = css_utility.getUserAttributes(Userinfo.getUserId());
            }
            accountlang = css_utility.getLanguage(userObj.LanguageLocaleKey); 
            System.debug('accountlang>>>>:'+accountlang);

            mil_measure = 'Miles';
            fail_measure = 'Miles';
            //userERPSystem = 'BMS Legacy';
            if(userERPSystem == 'BMS Legacy' || userERPSystem == 'One BMS'){
                string strLoc;
                if (Wid == null){
                    strLoc = userObj.User_Location__c;
                }else {
                    strLoc = workJob.Creator_Location__c;
                }
                CSS_JobEventTemporary__c[] lUnitType =[select Reason__c from CSS_JobEventTemporary__c where attribute1__c='UnitTypes' and Key__c=:strLoc];
                system.debug('lUnitType***');

                if (workJob.Unit_Type__c==null || workJob.Unit_Type__c=='----None----' || workJob.Unit_Type__c==''){
                    filterUnitType = '';}else{
                    filterUnitType = workJob.Unit_Type__c;
                }
                if (workJob.Sub_Type__c==null || workJob.Sub_Type__c=='----None----' || workJob.Sub_Type__c==''){
                    //filterSubType = '----None----';}else{
                    filterSubType = 'IS';}else{
                    filterSubType = workJob.Sub_Type__c;
                }

            }

            if (workJob.Application_Desc__c==null || workJob.Application_Desc__c=='----None----' || workJob.Application_Desc__c==''){
                filterApplication = '----None----';}
            else{
                filterApplication = workJob.Application_Desc__c;
            }
            //appCode = workJob.ApplicationCode__c;

            if (workJob.Make__c==null || workJob.Make__c==''){
                filterMake = '----None----';}else{
                filterMake = workJob.Make__c;
            }

            if (workJob.Model__c==null || workJob.Model__c==''){
                filterModel = '----None----';}else{
                filterModel = workJob.Model__c;
            }

            if (workJob.Mileage_Measure__c==null || workJob.Mileage_Measure__c==''){
                mil_measure = 'Miles';
            } else{
                mil_measure = workJob.Mileage_Measure__c;
            }

            datebyLocaleValue = css_utility.getFormattedDate();
            system.debug('qsol language outside'+accountlang.CSS_QsolLanguage__c);
            getQSOLDocs();  //getSiebelQSOLCampaigns();

            //Fetch SP Data Values.
            if(workJob.Id != null)// && workJob.Territory_Class_Name__c == null) 
                workJob = CG_BL_Intake.fetchSPData(workJob, workJob.creator_location__c, null, workJob.Failure_Date__c, null);
            system.debug('workJob>>>SPdata>>' + workJob);
            //Fetch SP Data Values.

            //163193
            Date warrantyCertDate;
            if(workJob.SP_WarrantyCertificationEndDate__c != null && workJob.SP_WarrantyCertificationEndDate__c !='')
                warrantyCertDate = Date.valueOf(workJob.SP_WarrantyCertificationEndDate__c) +180;
            /*if(workJob.SP_WarrantyTrainingCertification__c == 'N'){
                system.debug('Not Applicable');
                workJob.Warranty_Authorization_Flag__c = 'Not Applicable';
            }else if(workJob.SP_WarrantyTrainingCertification__c == 'Y' && (workJob.SP_WarrantyTrainingStatus__c != 'R' && workJob.SP_WarrantyTrainingStatus__c != Null && workJob.SP_WarrantyTrainingStatus__c != '')){
                system.debug('Certified');
                workJob.Warranty_Authorization_Flag__c = 'Certified';
            }else if(workJob.SP_WarrantyTrainingCertification__c == 'Y' && (workJob.SP_WarrantyTrainingStatus__c == 'R' || workJob.SP_WarrantyTrainingStatus__c == null || workJob.SP_WarrantyTrainingStatus__c == '') && (workJob.Failure_Date__c > warrantyCertDate || warrantyCertDate ==null)){
                system.debug('Not Certified');
                workJob.Warranty_Authorization_Flag__c = 'Not Certified';
            }else{
                system.debug('Certified');
                workJob.Warranty_Authorization_Flag__c = 'Certified';
            }*/

            if(workJob != null && workJob.Id != null){
                tempFailureDate = workJob.Failure_Date__c;
            }
            
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

        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeUE pageAction method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('returning from CG_CL_IntakeUE-pageAction method...');
    }

    public id saveUE(id inpJobId, String status){
        system.debug('entered into saveue method');
        Id JobId;
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
       // try{
            if (ChkFieldBlank() =='BLANK'){
                system.debug('Inside Blank IF');
                return null;
            }else{
                // Create Job 
                system.debug('in Save ESN-->'+workJob.ESN__c+' inpJobId>>:'+inpJobId);
                css_job_order__c worecord= new css_job_order__c();

                worecord.chevron_page__c = 'ue';
                worecord.ESN__c = workJob.ESN__c;
                worecord.CG_NoWarrantyFlag__c = workJob.CG_NoWarrantyFlag__c; // 124
                system.debug('Testwar flag'+worecord.CG_NoWarrantyFlag__c);
                worecord.ReconEngineFlag__c = workJob.ReconEngineFlag__c;
                String selectedLocation = (String) Cache.Session.get('selectedLocation');
                system.debug('selectedLocation-->'+selectedLocation);
                if(selectedLocation !=null && inpJobId == null){
                    //do we need to take Cache location code
                    List<CSS_UserLocation__c> lstUserLocations = [SELECT isActive__c,isPrimary__c,UserId__c,Location_Name__c,Location_code__c
                                                                  FROM CSS_UserLocation__c
                                                                  WHERE UserId__c = : UserInfo.getUserId() AND isActive__c = true and Location_code__c=:selectedLocation and Location_Source__c != 'ARF'
                                                                  ORDER BY Location_Name__c asc limit 1];
                    System.debug('lstUserLocations>>>:'+lstUserLocations);
                    if(lstUserLocations.size()>0){
                        worecord.jobLocation__c = lstUserLocations.get(0).Location_Name__c;
                        worecord.CSS_Job_Location_Code__c = lstUserLocations.get(0).Location_code__c;
                        Cache.Session.put('selectedLocation', lstUserLocations.get(0).Location_code__c);
                        worecord.account__c = CG_BL_Intake.FetchAccountId(worecord.CSS_Job_Location_Code__c);
                    }
                }
                if(selectedLocation == null || selectedLocation == '') {
                    User u = [Select Id, User_Location__c from User Where Id =: UserInfo.getUserId()];
                    //worecord.account__c = CG_BL_Intake.FetchAccountId(u.User_Location__c);
                }
                worecord.Status__c = status;
                  
                if(workJob.FieldActionWebServiceResult__c =='Error'){
                    string FailureDateString;
                    if(workJob.Failure_Date__c != null){
                        FailureDateString = DateTime.newInstance(workJob.Failure_Date__c.year(),workJob.Failure_Date__c.month(),workJob.Failure_Date__c.day()).format('dd-MMM-YY');
                    }
                    CG_BL_Campaigns.callGetCampaignsWebServiceOnChevronChangeJob(workJob.ESN__c, FailureDateString, workJob.Region__c, workJob.Territory_Class__c, 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', workJob.Name, workJob.Id);
                }

                worecord.Unit_Number__c = workJob.Unit_Number__c;
                worecord.Application_Desc__c = filterApplication;
                //Added as per story# 79153
                String appCode;
                if(filterApplication != '' && mapDescriptionToCode != null){
                    appCode = mapDescriptionToCode.get(filterApplication);
                }
                 system.debug('appCode'+appCode);
                worecord.ApplicationCode__c = appCode;
                system.debug('worecord.ApplicationCode__c'+worecord.ApplicationCode__c);
                worecord.Service_Model__c = workJob.Service_Model__c;
                worecord.Make__c = filterMake;
                worecord.Model__c = filterModel;

                worecord.VIN__c = workJob.VIN__c;
                worecord.License_Plate__c = workJob.License_Plate__c;
                worecord.Warranty_Start_Date__c = workJob.Warranty_Start_Date__c;
                system.debug('worecord.Warranty_Start_Date__c>>>>>'+worecord.Warranty_Start_Date__c);
                worecord.Before_In_Service__c = workJob.Before_In_Service__c;
                if(status != 'Appointment' && workJob.Failure_Date__c == null){
                    worecord.Failure_Date__c = system.Today();
                }else if(status != 'Appointment'  && workJob.Failure_Date__c != null && workJob.Failure_Date__c > system.Today()){
                    worecord.Failure_Date__c = system.Today();
                }else{
                    worecord.Failure_Date__c=workJob.Failure_Date__c;
                }
                worecord.Warranty_Authorization_Flag__c = workJob.Warranty_Authorization_Flag__c;
                worecord.Mileage_Measure__c = mil_measure;
                worecord.Mileage__c = workJob.Mileage__c;
                system.debug('Miles Saved or not-->'+ worecord.Mileage__c);
                worecord.CSS_Hours__c = workJob.CSS_Hours__c;
                worecord.PSN_Not_Available__c = workJob.PSN_Not_Available__c;
                //Story#183077
               if(worecord.PSN_Not_Available__c!=null && worecord.PSN_Not_Available__c!=true){
                    if(PSNFlag!=null)
                     worecord.Get_Engine_data_flag__c=PSNFlag;
                }
                else{
                     worecord.Get_Engine_data_flag__c=false;
                }
               //end
                worecord.Failure_Point__c = workJob.Failure_Point__c;
                worecord.Repair_Location__c = workJob.Repair_Location__c;
                //worecord.Unit_Type__c = filterUnitType;
                worecord.Unit_Type__c = workJob.Unit_Type__c;
                worecord.Sub_Type__c = filterSubType;
                //Implemented as part of the defect number 143769    
                worecord.Qsol_Engine_Family_Code__c = workJob.Qsol_Engine_Family_Code__c;
                System.debug('filterUnitType>>>:'+filterUnitType);
                System.debug('filterSubType>>>:'+filterSubType);
                system.debug('inpJobId-->'+inpJobId);
                worecord.id=inpJobId;
                system.debug('in save...workJob.Region__c-->'+workJob.Region__c+' region>>>:'+region);
                worecord.Region__c = region;
                worecord = CG_BL_Intake.mapSPData(workJob, worecord); 
                system.debug('worecord-->'+worecord);

                // add new engine data new fields
                worecord.BillToCode__c = workJob.BillToCode__c;
                worecord.BuildDate__c = workJob.BuildDate__c;
                worecord.ProductApplicationCode__c = workJob.ProductApplicationCode__c;
                worecord.DesignPhaseCode__c = workJob.DesignPhaseCode__c;
                worecord.EngineFamilyCode__c = workJob.EngineFamilyCode__c;
                worecord.EtoConversionDate__c = workJob.EtoConversionDate__c;
                worecord.MarineFlag__c = workJob.MarineFlag__c;
                worecord.OemCode__c = workJob.OemCode__c;
                worecord.ProductApplicationDesp__c = workJob.ProductApplicationDesp__c;
                worecord.warrantyIndicatorFlag__c = workJob.warrantyIndicatorFlag__c; 
               // worecord.Automotive_App_Flag__c = workJob.Automotive_App_Flag__c; 
                //Added below condtion story GSSC 333 karthik G
                if(worecord.ApplicationCode__c == '130' || worecord.ApplicationCode__c == '210' || worecord.ApplicationCode__c == '220' || worecord.ApplicationCode__c == '310' || worecord.ApplicationCode__c =='320' || worecord.ApplicationCode__c =='410')
                    worecord.Automotive_App_Flag__c = 'Y';
                else
                    worecord.Automotive_App_Flag__c = 'N';
                worecord.ShipDate__c = workJob.ShipDate__c;
                worecord.EngineFamilyName__c = workJob.EngineFamilyName__c;
                worecord.ETOOldESN__c = workJob.ETOOldESN__c;
                worecord.CSS_Mission_Disabling__c = workJob.CSS_Mission_Disabling__c;
                worecord.ProductAppcodeErrorflag__c = workJob.ProductAppcodeErrorflag__c;
                worecord.Location_Certification__c = workJob.Location_Certification__c;
                worecord.PSN_PACCAR_Flag__c = workJob.PSN_PACCAR_Flag__c;
                system.debug('worecord.ProductAppcodeErrorflag__c'+worecord.ProductAppcodeErrorflag__c);
                worecord.SPDataWebserviceResult__c = workJob.SPDataWebserviceResult__c;
                //worecord.FieldActionWebServiceResult__c = workJob.FieldActionWebServiceResult__c;
                if(status=='Canceled' && workJob.Account__r.ERP_System__c == 'One BMS'){
                    cancelSJWrapperObj1 = CG_BL_Intake.cancel(workJob,worecord);

                }

                else{
                    system.debug('workJob WSD>>>>>'+workJob.Warranty_Start_Date__c);

                    //Commented below code as part of story - 148884
                    /*if(workJob.Warranty_Start_Date__c > date.today() && status=='Intake')
                       {
                            worecord.Warranty_Start_Date__c =null;
                       }
             system.debug('worecord WSD>>>>>'+worecord.Warranty_Start_Date__c);*/



                    worecord.Id = workJob.Id;
                    upsert worecord;
                    JobId = worecord.id;
                    system.debug('worecord>>>>>'+worecord.Warranty_Start_Date__c);
                    system.debug('worecord>>>>>'+workJob.Warranty_Start_Date__c);
                    system.debug('worecord>>>>>'+worecord);
                    cancelSJWrapperObj1.errorFlag = false;
                    cancelSJWrapperObj1.errorMessage = '';
                    cancelSJWrapperObj1.serviceJob = worecord;
                }
                //upsert worecord;
                //JobId = worecord.id;
            }
            system.debug('workjob>>>>>'+workjob.Warranty_Start_Date__c);
            return JobId;

       // } catch(exception e) {
         //   system.debug('EXCEPTION of CG_CL_IntakeUE pgSave method >>> '+e.getMessage() + e.getLineNumber());
           // return null;
        //}

    }

    //Save Functionality.
    public void pgSave() {
        System.debug('IN CG_CL_Intakeue -pgSave method...');
        try{
            Id sJobId;
            if(workJob.Status__c !='Appointment')
                sJobId = saveUE(Wid, 'Intake');
            else
                sJobId = saveUE(Wid, 'Appointment');

           // PageReference pageRef = new pageReference('/apex/CG_IntakeUE?id='+sJobId); 
            //pageRef.setRedirect(true);
            //return pageRef;
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeUE pgSave method >>> '+e.getMessage() + e.getLineNumber());
            //return null;
        }
    }

    // Begin Chevron Navigation methods
    public PageReference nvIntakeCustomer(){
        PageReference pageRef;
        //Implemented as part of the defect number 143637
        if(workJob.Status__c !='Appointment'){
            Wid =saveUE(Wid, 'Intake');
        }else{
            Wid =saveUE(Wid, 'Appointment');
        }
        //Wid = saveUE(Wid, 'Intake');
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeCustomer'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeCustomer?id='+Wid); 
        }
        return pageRef;
    }

    public PageReference nvIntakeCC(){
        system.debug('nvIntakeCC');
        PageReference pageRef;
        //Implemented as part of the defect number 143637
        if(workJob.Status__c !='Appointment'){
            Wid =saveUE(Wid, 'Intake');
        }else{
            Wid =saveUE(Wid, 'Appointment');
        }
        //Wid = saveUE(Wid, 'Intake');
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeCC'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeCC?id='+Wid); 
        }
        return pageRef;
    }
    
    public PageReference nvIntakeVH(){
        PageReference pageRef;
        //Implemented as part of the defect number 143637
        if(workJob.Status__c !='Appointment'){
            Wid =saveUE(Wid, 'Intake');
        }else{
            Wid =saveUE(Wid, 'Appointment');
        }
        //Wid = saveUE(Wid, 'Intake');
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeVH'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeVH?id='+Wid); 
        }
        return pageRef;
    }
    
    public PageReference nvIntakeWarranty(){
        PageReference pageRef;
        //Implemented as part of the defect number 143637
        if(workJob.Status__c !='Appointment'){
            Wid =saveUE(Wid, 'Intake');
        }else{
            Wid =saveUE(Wid, 'Appointment');
        }
        //Wid = saveUE(Wid, 'Intake');
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeWarranty'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeWarranty?id='+Wid); 
        }
        return pageRef;
    }
    
    public PageReference nvIntakeRJ(){
        PageReference pageRef;

        //Implemented as part of the defect number 143637
        if(workJob.Status__c !='Appointment'){
            Wid =saveUE(Wid, 'Intake');
        }else{
            Wid =saveUE(Wid, 'Appointment');
        }

        //Wid = saveUE(Wid, 'Intake');
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeRJ'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeRJ?id='+Wid); 
        }
        return pageRef;
    }
    //End Navigation methods




    public string ChkFieldBlank(){
        try{
            //Modified as per story# 64030
            system.debug('fA>:'+filterApplication+' Unit_number__c>:'+workJob.Unit_number__c+' Mileage__c>:'+workJob.Mileage__c+' ESN__c>:'+workJob.ESN__c+' Status__c>:'+workJob.Status__c);
            if ( (filterApplication == null || filterApplication == '') && (workJob.Unit_number__c == null || workJob.Unit_number__c == '') && (workJob.Mileage__c == null || workJob.Mileage__c == 0) && (workJob.ESN__c== null || workJob.ESN__c== '')
                && (workJob.Status__c == null || workJob.Status__c == '') )
            {
                System.Debug('in BLANK==============');
                return 'BLANK';
            }
            else
            {
                System.Debug('in FILLED==============');
                return 'FILLED';
            }
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeUE ChkFieldBlank method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }
        //add all fields check for null with OR condition
    }

    public void showPopup() {
        displayPopup = true;
    }

    public void closePopup() {
        displayPopup = false;
    } 

    public PageReference redirectPopup(){    
        /*displayPopup = false;
        PageReference p=new Pagereference('/apex/CSS_Job_Detail?nto=HOME');
        p.setRedirect(true);
        return p;*/
        try 
        {
            displayPopup = false;
            pageReference p = new pageReference('/apex/CSS_Job_Detail?nto=HOME');
            p.setRedirect(true);
            return p;
        } 
        catch(exception e) 
        {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer redirectPopup method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        } 

    } 

    public PageReference closeSession(){
        try{
            Id sJobId = saveUE(Wid, 'Closed');
            PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
            pageRef.setRedirect(true);
            return pageRef;
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeUE closeSession method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }

    }

    public void Cancel(){
        try{
            Id sJobId = saveUE(Wid, 'Canceled');
            /*PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
            pageRef.setRedirect(true);
            return pageRef;*/
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeUE Cancel method >>> '+e.getMessage() + e.getLineNumber());
            //return null;
        }

    } 

    public void getQSOLDocs(){
        try{
            lstCAM = new List<CSS_CampTsbTrp__c>();
            lstTRP = new List<CSS_CampTsbTrp__c>();
            lstTSB = new List<CSS_CampTsbTrp__c>();
            lstATC = new List<CSS_CampTsbTrp__c>();
            List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getSiebelQSOLCampaigns(workJob.Id, workJob.ESN__c, accountlang.CSS_QsolLanguage__c, workJob.Service_Model__c, workJob.Failure_Date__c);
            if(campaignsList !=null && campaignsList.size()>0)//191103 swapped tsb and cam with 0 and 1
                lstTSB = campaignsList.get(0);
            if(campaignsList !=null && campaignsList.size()>1)
                lstCAM = campaignsList.get(1);
            if(campaignsList !=null && campaignsList.size()>2)
                lstTRP = campaignsList.get(2);
            if(campaignsList !=null && campaignsList.size()>3)
                lstATC = campaignsList.get(3);
            system.debug('campaignsList>>>:'+campaignsList);
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeUE getQSOLDocs method >>> '+e.getMessage() + e.getLineNumber());
        }
    } 

    //Below method is moved to CG_BL_Intake
    //This method is used for retrieving Siebel campaigns with QSOL links
    public void getSiebelQSOLCampaigns() {
        System.debug('in getSiebelQSOLCampaigns method....');
        try{
            solCompCTTP = [select Type__c,URL__c,  Component_Id__c, Campaign_Description__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_Solution_Component__c where Service_Job__c= :workJob.Id AND Type__c in('Campaign','TRP','ATC') and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))  order by Type__c LIMIT 1000];
            //Get QSOL Docs for existing ESN
            lstQSOLDocs = new List<CSS_CampTsbTrp__c>([Select Id, Type__c, Job_Order__c,ESN__c, Doc_Num__c, 
                                                       Doc_Title__c, URL__c, Reviewed__c,Performed__c,
                                                       Performed_Review__c,Cu_Language__c from CSS_CampTsbTrp__c
                                                       where Job_Order__c = :workJob.Id and ESN__c = :workJob.ESN__c
                                                       order by Performed_Review__c desc]);
            system.debug('lstSOLCOMPDocs++++++'+solCompCTTP);
            system.debug('lstQSOLDocs++++++'+lstQSOLDocs);
            if (lstQSOLDocs.size()>0) {
                for (CSS_CampTsbTrp__c recQSOLDocs : lstQSOLDocs ) {
                    system.debug('**type***'+recQSOLDocs.Type__c);
                    if (recQSOLDocs.Type__c == 'CAM') { lstCAM.add(recQSOLDocs); }
                    if (recQSOLDocs.Type__c == 'TSB') { lstTSB.add(recQSOLDocs); }
                    if (recQSOLDocs.Type__c == 'TRP') { lstTRP.add(recQSOLDocs); }
                    if (recQSOLDocs.Type__c == 'ATC') { lstATC.add(recQSOLDocs); }
                }
            }
            //qsollanguage(); //is this method needed??? 

            if(solCompCTTP != null && solCompCTTP.size()>0 && lstQSOLDocs !=null && lstQSOLDocs.size()>0){
            system.debug('lstQSOLDocs[0].Cu_Language__c'+lstQSOLDocs[0].Cu_Language__c);
                system.debug('accountlang.CSS_QsolLanguage__c'+accountlang.CSS_QsolLanguage__c);
                //checking here if language is changed from header menu
                if(lstQSOLDocs[0].Cu_Language__c != null && lstQSOLDocs[0].Cu_Language__c != accountlang.CSS_QsolLanguage__c ){
                    //here call QSOL service to get campaigns
                    List<List<CSS_CampTsbTrp__c>> qsolList = CG_BL_Intake.getQSOLDocs(workJob.Id, workJob.ESN__c, accountlang.CSS_QsolLanguage__c);
                    system.debug('qsolList>>>:'+qsolList);
                    if(qsolList !=null && qsolList.size()>0)
                        lstCAM = qsolList.get(0);
                    if(qsolList !=null && qsolList.size()>1)
                        lstTSB = qsolList.get(1);
                    if(qsolList !=null && qsolList.size()>2)
                        lstTRP = qsolList.get(2);
                    if(qsolList !=null && qsolList.size()>3)
                        lstATC = qsolList.get(3);
                    System.debug('QSOL lstCAM>>>:'+lstCAM);
                    System.debug('QSOL lstTSB>>>:'+lstTSB);
                    System.debug('QSOL lstTRP>>>:'+lstTRP);
                    System.debug('QSOL lstATC>>>:'+lstATC);
                    //End QSOL CAM,ATC, TSB & TRB

                    //Here need to build save functionality for Qsol with changed/selected language

                    //Delete existing saved QSOL campaigns for previous language
                    delete lstQSOLDocs;
                }

                //Here adding QSOL links to SIEBEL list
                List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.addQSOLLinksToSiebelData(workjob.Id, solCompCTTP, lstCAM, lstTRP, lstATC);
                if(campaignsList !=null && campaignsList.size()>0)
                    lstCAM = campaignsList.get(0);
                if(campaignsList !=null && campaignsList.size()>1)
                    lstTRP = campaignsList.get(1);
                if(campaignsList !=null && campaignsList.size()>2)
                    lstATC = campaignsList.get(2);
                system.debug('campaignsList>>>:'+campaignsList);
            }
            
            
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeUE getSiebelQSOLCampaigns method >>> '+e.getMessage() + e.getLineNumber());
        }
    }

    //Not needed below method & need to delete
    // Method to call quick serve on page load - start
    public void qsollanguage(){
        list<CSS_CampTsbTrp__c> qsolla1 = new list<CSS_CampTsbTrp__c>();
        list<CSS_CampTsbTrp__c> qsolla2 = new list<CSS_CampTsbTrp__c>();       

        system.debug('**above user Lang');
        system.debug('**after user Lang');

        system.debug('checking qsolcttp9'+qsolCTTP9);   
        if(lstQSOLDocs != null && !lstQSOLDocs.isEmpty()){  
            //for(CSS_CampTsbTrp__c camp : qsolCTTP9){
            if(lstQSOLDocs[0].Cu_Language__c != null && lstQSOLDocs[0].Cu_Language__c != accountlang.CSS_QsolLanguage__c ){                    
                qsolla1.add(lstQSOLDocs[0]);                       
            }
            if(lstQSOLDocs[0].Cu_Language__c != null && lstQSOLDocs[0].Cu_Language__c == accountlang.CSS_QsolLanguage__c ){                    
                qsolla2.add(lstQSOLDocs[0]);                       
            }
            //}
            if(Wid != null && workjob.ESN__c != null && (!qsolla1.isEmpty()|| !qsolla2.isEmpty())){
                campList = CSS_QuickServe.getQsolDocSaveLang(workjob.Id, workjob.ESN__c, accountlang.CSS_QsolLanguage__c);
                if(campList != null && !campList.isEmpty()){
                    for(CSS_CampTsbTrp__c campRec : campList){
                        qsolCampMap.put(campRec.Doc_Num__c,campRec);
                    }
                }
            }
        }      

    } 


}