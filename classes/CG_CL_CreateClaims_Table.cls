public class CG_CL_CreateClaims_Table
{
    public list<CSS_UserLocation__c> lstUserLocations;
    public string selectedLocation {get;set;}
    public string datebyLocaleValue {get;set;}
    public static List<CSS_Claims__c> listClaim {get; set;}
    public static List<CSS_Job_Order__c> lstjob{get;set;}
    public static List<CSS_Job_Order__c> lstjobnotRCC{get;set;}
    public static List<CSS_Job_Order__c> lstjobfinal{get;set;}
    public String ServiceJobList { get; set; }
    public Static String whClause;
    public List<SelectOption> options;
    public CG_BL_Claims CG_BL_ClaimsObj = new CG_BL_Claims();
    public String defaultLoc {get; set;}
    //public String defaultLocationCode {get; set;}
    public Id selectedJob {get; set;}
    public css_job_order__c workJob {get;set;}
    public CSS_Claims__c newClaim {get;set;}
    public CSS_PSN__c psnDetails {get;set;}
    public Boolean isDealer {get;set;}
    public static Boolean isDealer1 {get;set;}
    public string createdfrom{get;set;}
    public  CG_CL_CreateClaims_Table()
    {
        //selectedLocation = '-All-';
        datebyLocaleValue = css_utility.getFormattedDate();
        lstUserLocations = new list<CSS_UserLocation__c>();
        //query to get the user locations 
        lstUserLocations = CG_BL_Claims.fetchMultiLocation();

        getLocationsName();

    }

    //This function is to Create a New Guidanz Claim
    public PageReference CreateNeGclaim()
    {
        //
        system.debug('selectedJob--'+selectedJob);
        system.debug('****Test Create Claim***');
        PageReference pg;
        workJob = new CSS_Job_Order__c();
        newClaim = new CSS_Claims__c();
        psnDetails = new CSS_PSN__c();
        isDealer = false;
        string userType = css_Utility.getOrgType(userinfo.getUserId());
        if(userType!=null && userType!= '') {
            if(userType == 'DLR') {
                isDealer = true;
            }else if(userType == 'DISTR') {
                isDealer = false;
            }
        } 

        System.debug('Here.');
        //Added 4c's fields in Query -By RAJESH
        //Added Get_Engine_data_flag__c for the story#183077
        workJob = [Select Id,Get_Engine_data_flag__c,PACCAR_Auth_Required__c,Account__r.Type,Account__r.isCampTrp__c,Customer_Name__c,AccessCode__c,LastUpdateSubStatus__c,Date_in_Shop__c,City__c,CSS_State__c,Country__c,Date_In__c,Shop_Work_Order__c,Customer_Code__c,First_Name__c,BMS_Last_Name__c,Phone_Number__c,Email_Address__c,Address__c,ZipCode__c,
                   Repair_Location__c,Creator_Location__c,CSS_Job_Location_Code__c,jobLocation__c,ESN__c,Unit_Number__c,Application__c,Application_Desc__c,Service_Model__c,Qsol_Engine_Family_Code__c,
                   Make__c,Model__c,Unit_Type__c,VIN__c,Warranty_Start_Date__c,Before_In_Service__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,CSS_Hours__c,CreatedDate,Equipment_ID__c,
                   EditCause__c,EditComplaint__c,EditCorrection__c,EditCoverage__c,Assigned_to__c,Additional_Tech1__c,Additional_Tech2__c,Additional_Tech3__c,Additional_Tech4__c,Additional_Tech5__c,
                   Additional_Tech6__c,Additional_Tech7__c,Additional_Tech8__c,Additional_Tech9__c, ApplicationCode__c, Actual_Technician_Time__c, General_Symptoms__c, Preventive_Maintenance__c, Expedited_Service__c, 
                   Category_Desc__c, Category2_Desc__c, Account__c, Category3_Desc__c, Category4_Desc__c, Category5_Desc__c, Complaint_Type_Desc__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c,ODM_Status__c,ODM_Status_Message__c,ODM_Pre_submit_Status__c,ODM_Pre_Submit_Status_Message__c,
                   CSS_Channel_Of_Distribution__c,SP_ClaimAllowedDays__c,Territory_Class__c,Region__c,Territory_Class_Name__c,CSS_Channel_Code__c,CSS_Mission_Disabling__c,
                   Amount_Due__c,Available_Credit__c,Credit_Limit__c,DesignPhaseCode__c,EngineFamilyCode__c,EngineFamilyName__c,EtoConversionDate__c,
                   ETOOldESN__c,MarineFlag__c,Mutual_Exclusive_Message__c,SRT_Olap_Reason_Msg__c,SRT_902_Error_Message__c,DupAccessCodePercentReqMsg__c,Overlap_Service_Failure_Msg__c,Non_SRT_Details__c,ODM_Status_Code__c,OemCode__c,ProductApplicationCode__c,
                   ProductApplicationDesp__c,Quote_ID__c,ShipDate__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CommunicationMethod__c,
                   SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_Country__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,TSR_EscalateNumber__c,
                   SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,Automotive_App_Flag__c,License_Plate__c,
                   BillToCode__c,BuildDate__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,
                   SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RegionCode__c,
                   SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,Sp_TERRITORY__c,
                   SP_ViewDollarAmount__c,SP_CMISPExpirationDate__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,warrantyIndicatorFlag__c,
                   SP_WarrantyTrainingCertification__c,Location_Certification__c,Warranty_Authorization_Flag__c,SP_LTAFlag__c,SP_GroupName__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,SP_TerritoryCode__c,SP_OutfileAllClaims__c,Territory__c,Warranty_Coverage_Flag__c,
                   //Added below fields into the Query as per "I Survived" sprint story #152967,-By RAJESH 27th July 2018            
                   CSS_Travel_Rate__c,CSS_In_Shop_Labor_Rate__c
                   from CSS_Job_Order__c
                   where Id=:selectedJob];
        System.debug('THere.');
        system.debug('workJob--'+workJob);
        //system.debug('workJobRegion--'+workJob.Region__c);
        //system.debug('workJobTerritory--'+workJob.Territory__C);

        //job related fields to be populated to the claim customer related fields(if workjob exist)
        if(workJob != null)
        {
            newClaim.Customer_Name__c = workJob.Customer_Name__c;
            newClaim.Customer_Code__c = workJob.Customer_Code__c;
            newClaim.Contact_First_Name__c = workJob.First_Name__c;
            newClaim.Contact_Last_Name__c = workJob.BMS_Last_Name__c;
            newClaim.Customer_Contact_Phone__c = workJob.Phone_Number__c;
            newClaim.Email_Address__c = workJob.Email_Address__c;
            newClaim.Claims_city__c = workJob.City__c;
            newClaim.State__c = workJob.CSS_State__c;
            newClaim.Country__c = workJob.Country__c;
            newClaim.Product_Certification__c = workJob.Location_Certification__c;
            newClaim.Warranty_Authorization_Flag__c = workJob.Warranty_Authorization_Flag__c; 
            newClaim.Address__c = workJob.Address__c;
            newClaim.ZipCode__c = workJob.ZipCode__c;
            newClaim.Repair_Location__c = workJob.Repair_Location__c;
            
            newClaim.CG_Get_Engine_data_flag__c=workjob.Get_Engine_data_flag__c;//Story#183077
            //newClaim.Account__r.isCampTrp__c = workJob.Account__r.isCampTrp__c;
            //newClaim.PACCAR_Auth_Required__c = workJob.PACCAR_Auth_Required__c;
            newClaim.TSR1__c=workJob.TSR_EscalateNumber__c;
            if(createdfrom == 'Repair RJ')
                newClaim.Dealer_Service_Job__c = selectedJob;
            else
                newClaim.CSS_Job__c = selectedJob;
            newClaim.Status__c = 'Draft';
            newClaim.Location__c = workJob.jobLocation__c;
            newClaim.Location_Code__c = workJob.CSS_Job_Location_Code__c;
            newClaim.Repair_Completion__c = workJob.LastUpdateSubStatus__c;            
            newClaim.Service_Date__c = workJob.Date_In__c;
            //Commented as part of the story GSSC-291 - START
            //Added 4c's fields for Mapping -By RAJESH
            /*if(!isDealer){
                newClaim.JobEditComplaint__c = workJob.EditComplaint__c;
                newClaim.JobEditCause__c = workJob.EditCause__c;
                newClaim.JobEditCoverage__c = workJob.EditCoverage__c;
                newClaim.JobEditCorrection__c = workJob.EditCorrection__c;
            }
            else{ *///Commented as part of the story GSSC-291 - END
                newClaim.EditComplaint__c = workJob.EditComplaint__c;
                newClaim.EditCorrection__c = workJob.EditCorrection__c;
                newClaim.EditCause__c = workJob.EditCause__c;
                newClaim.EditCoverage__c = workJob.EditCoverage__c;
            //}Commented as part of the story GSSC-291
            //End     
            
            //Added below fields as per "I Survived" sprint story #152967,-By RAJESH 27th July 2018
            newClaim.CSS_Travel_Rate__c = workJob.CSS_Travel_Rate__c;
            newClaim.SP_INSHOP_LABOR_RATE__c = workJob.CSS_In_Shop_Labor_Rate__c;
            //End    
            newClaim.Account__c = workJob.Account__c;     
            //TO populate the PSN(esn__c) field of the claim object from service job PSN during automated claim creation.
            newClaim.Claims_General_Symptoms__c = workJob.General_Symptoms__c;
            newClaim.Claims_Preventive_Maintenance__c = workJob.Preventive_Maintenance__c;
            newClaim.Claims_Expedited_Service__c = workJob.Expedited_Service__c;

            newClaim.Claims_Category_Desc__c = workJob.Category_Desc__c;
            newClaim.Claims_Category2_Desc__c = workJob.Category2_Desc__c;
            newClaim.Claims_Category3_Desc__c = workJob.Category3_Desc__c;
            newClaim.Claims_Category4_Desc__c = workJob.Category4_Desc__c;
            newClaim.Claims_Category5_Desc__c = workJob.Category5_Desc__c;

            newClaim.Complaint_Type_Desc__c = workJob.Complaint_Type_Desc__c;
            newClaim.Complaint_Type2_Desc__c = workJob.Complaint_Type2_Desc__c;
            newClaim.Complaint_Type3_Desc__c = workJob.Complaint_Type3_Desc__c;
            newClaim.Complaint_Type4_Desc__c = workJob.Complaint_Type4_Desc__c;
            newClaim.Complaint_Type5_Desc__c = workJob.Complaint_Type5_Desc__c;

            newClaim.ESN__c = workJob.ESN__c;
            newClaim.Assigned_to__c = workJob.Assigned_to__c;
            newClaim.Additional_Tech1__c = workJob.Additional_Tech1__c;
            newClaim.Additional_Tech2__c = workJob.Additional_Tech2__c;
            newClaim.Additional_Tech3__c = workJob.Additional_Tech3__c;
            newClaim.Additional_Tech4__c = workJob.Additional_Tech4__c;
            newClaim.Additional_Tech5__c = workJob.Additional_Tech5__c;
            newClaim.Additional_Tech6__c = workJob.Additional_Tech6__c;
            newClaim.Additional_Tech7__c = workJob.Additional_Tech7__c;
            newClaim.Additional_Tech8__c = workJob.Additional_Tech8__c;
            newClaim.Additional_Tech9__c = workJob.Additional_Tech9__c;
            newClaim.Actual_Technician_Time__c = workJob.Actual_Technician_Time__c;
            newClaim.CSS_Channel_Of_Distribution__c = workJob.CSS_Channel_Of_Distribution__c;
            newClaim.SP_CHANNEL_OF_DISTRIBUTION__c = workJob.CSS_Channel_Of_Distribution__c;
            newClaim.Territory_Class_Name__c  = workJob.Territory_Class_Name__c;
            newClaim.SP_REGION__c = (workJob.Region__c!=null && workJob.Region__c!='')?workJob.Region__c:'';
            newClaim.SP_TERRITORY__c = (workJob.Territory_Class_Name__c!=null && workJob.Territory_Class_Name__c!='')?workJob.Territory_Class_Name__c:'';
            newClaim.SP_CLAIM_ALLOWED_DAYS__c = (workJob.SP_ClaimAllowedDays__c != null && workJob.SP_ClaimAllowedDays__c !='')?workJob.SP_ClaimAllowedDays__c:'';
            newClaim.CSS_Channel_Code__c = (workJob.CSS_Channel_Code__c != null && workJob.CSS_Channel_Code__c !='')?workJob.CSS_Channel_Code__c:'';
            newClaim.SP_TERRITORY_CODE__c= workJob.Territory_Class__c; 
            //newClaim.Region__c = workJob.Region__c;
            //newClaim.Territory__c = workJob.Territory__c;

            //ODM Status & Message
            newClaim.ODM_Status__c = workJob.ODM_Status__c;
            newClaim.ODM_Status_Message__c = workJob.ODM_Status_Message__c;
            newClaim.ODM_Pre_submit_Status__c = workJob.ODM_Pre_submit_Status__c;
            newClaim.ODM_Pre_Submit_Status_Message__c = workJob.ODM_Pre_Submit_Status_Message__c;

            //Added Part of ODM
            newClaim.Amount_Due__c = workJob.Amount_Due__c;
            newClaim.Available_Credit__c = workJob.Available_Credit__c;
            newClaim.Credit_Limit__c = workJob.Credit_Limit__c;
            newClaim.DesignPhaseCode__c = workJob.DesignPhaseCode__c;
            newClaim.EngineFamilyCode__c = workJob.EngineFamilyCode__c;
            newClaim.EngineFamilyName__c = workJob.EngineFamilyName__c;
            newClaim.EtoConversionDate__c = workJob.EtoConversionDate__c;
            newClaim.ETOOldESN__c = workJob.ETOOldESN__c;
            newClaim.MarineFlag__c = workJob.MarineFlag__c;
            newClaim.Mutual_Exclusive_Message__c = workJob.Mutual_Exclusive_Message__c;
            newClaim.SRT_Olap_Reason_Msg__c = workJob.SRT_Olap_Reason_Msg__c;
            newClaim.SRT_902_Error_Message__c = workJob.SRT_902_Error_Message__c;
            newClaim.DupAccessCodePercentReqMsg__c = workJob.DupAccessCodePercentReqMsg__c;
            newClaim.Overlap_Service_Failure_Msg__c = workJob.Overlap_Service_Failure_Msg__c;
            newClaim.Non_SRT_Details__c = workJob.Non_SRT_Details__c;
            newClaim.ODM_Status_Code__c = workJob.ODM_Status_Code__c;
            newClaim.OemCode__c = workJob.OemCode__c;
            newClaim.ProductApplicationCode__c = workJob.ProductApplicationCode__c;
            newClaim.ProductApplicationDesp__c = workJob.ProductApplicationDesp__c;
            newClaim.Quote_ID__c = workJob.Quote_ID__c;
            newClaim.ShipDate__c = workJob.ShipDate__c;
            newClaim.SP_AccountStatus__c = workJob.SP_AccountStatus__c;
            newClaim.SP_BusinessUnit__c = workJob.SP_BusinessUnit__c;
            newClaim.SP_CampaignTRP__c = workJob.SP_CampaignTRP__c;
            newClaim.SP_CommunicationMethod__c = workJob.SP_CommunicationMethod__c;
            newClaim.SP_CommunicationOccurrence__c = workJob.SP_CommunicationOccurrence__c;
            newClaim.SP_CostEffectiveExclusion__c = workJob.SP_CostEffectiveExclusion__c;
            newClaim.SP_Country__c = workJob.SP_Country__c;
            newClaim.SP_CutOffClaimAmt__c = workJob.SP_CutOffClaimAmt__c;
            newClaim.SP_DisableWebAccessFlag__c = workJob.SP_DisableWebAccessFlag__c;
            newClaim.SP_DistributorHQCode__c = workJob.SP_DistributorHQCode__c;
            newClaim.SP_DistributorHQName__c = workJob.SP_DistributorHQName__c;
            newClaim.SP_DSID__c = workJob.SP_DSID__c;
            newClaim.SP_DTNAFlag__c = workJob.SP_DTNAFlag__c;
            newClaim.SP_FreezeSubmitButton__c = workJob.SP_FreezeSubmitButton__c;
            newClaim.Automotive_App_Flag__c = workJob.Automotive_App_Flag__c;
            newClaim.BillToCode__c = workJob.BillToCode__c;
            newClaim.BuildDate__c = workJob.BuildDate__c;
            newClaim.SP_MaxClaimAmt__c = workJob.SP_MaxClaimAmt__c;
            newClaim.SP_NewOEM__c = workJob.SP_NewOEM__c;
            newClaim.SP_PACCAR__c = workJob.SP_PACCAR__c;
            newClaim.SP_PMUSplitPayment__c = workJob.SP_PMUSplitPayment__c;
            newClaim.SP_Policy__c = workJob.SP_Policy__c;
            newClaim.SP_PrimaryOEMCode__c = workJob.SP_PrimaryOEMCode__c;
            newClaim.SP_PrimaryOEMName__c = workJob.SP_PrimaryOEMName__c;
            newClaim.SP_ProductCertification__c = workJob.SP_ProductCertification__c;
            newClaim.SP_PromotionId__c = workJob.SP_PromotionId__c;
            newClaim.SP_Region__c = workJob.SP_Region__c;
            newClaim.SP_RegionCode__c = workJob.SP_RegionCode__c;
            newClaim.SP_RepairLevel__c = workJob.SP_RepairLevel__c;
            newClaim.SP_SCMDeductiblePercentage__c = workJob.SP_SCMDeductiblePercentage__c;
            newClaim.SP_SCMDollarAmt__c = workJob.SP_SCMDollarAmt__c;
            newClaim.SP_State__c = workJob.SP_State__c;
            newClaim.SP_TechActualHoursRequired__c = workJob.SP_TechActualHoursRequired__c;
            //newClaim.Sp_TERRITORY__c = workJob.Sp_TERRITORY__c;
            newClaim.SP_ViewDollarAmount__c = workJob.SP_ViewDollarAmount__c;
            newClaim.SP_WarrantyCertificationEndDate__c = workJob.SP_WarrantyCertificationEndDate__c;
            newClaim.SP_WarrantyEmail__c = workJob.SP_WarrantyEmail__c;
            newClaim.SP_WarrantyFax__c = workJob.SP_WarrantyFax__c;
            newClaim.warrantyIndicatorFlag__c = workJob.warrantyIndicatorFlag__c;
            newClaim.SP_WarrantyTrainingCertification__c = workJob.SP_WarrantyTrainingCertification__c;
            newClaim.SP_WarrantyTrainingStatus__c = workJob.SP_WarrantyTrainingStatus__c;
            newClaim.SP_WWSPSSPFlag__c = workJob.SP_WWSPSSPFlag__c;

            //system.debug('workJob.Territory__c--'+workJob.Territory__c.Trim());
            //  if(workJob.Territory__c != null && workJob.Territory__c != ''){
            //    newClaim.Territory__c = workJob.Territory__c;
            //    }
            // newClaim.Warranty_Coverage_Flag__c = workJob.Warranty_Coverage_Flag__c;
            newClaim.SP_CMI_SP_EXPIRATION__c = workJob.SP_CMISPExpirationDate__c;
            newClaim.SP_Group_Name__c = workJob.SP_GroupName__c;
            newClaim.SP_LTA_FLAG__c = workJob.SP_LTAFlag__c;
            newClaim.SP_OUTFILE_ALL_CLAIMS__c = workJob.SP_OutfileAllClaims__c;
            newClaim.SP_ProductCertification__c = workJob.SP_PSBUProductCertification__c;
            //newClaim.SP_TERRITORY_CODE__c = workJob.SP_TerritoryCode__c;
            newClaim.Territory_Class__c = workJob.Territory_Class__c;



            List<CSS_JobHistory__c> fourcNotes = new List<CSS_JobHistory__c>();

            fourcNotes = [SELECT Id, CreatedBy.Name, CreatedDate, CSS_Field_Name__c , CSS_New_Value__c FROM CSS_JobHistory__c WHERE CSS_Job_Id__c =: selectedJob AND 
                          CSS_Object_Name__c = 'CSS_Job_Order__c' AND (CSS_Field_Name__c = 'EditComplaint__c' OR CSS_Field_Name__c = 'EditCause__c'
                                                                       OR CSS_Field_Name__c = 'EditCoverage__c' OR CSS_Field_Name__c = 'EditCorrection__c')
                          ORDER BY CreatedDate DESC];

            boolean setComplaint = false;
            boolean setCause = false;
            boolean setCoverage = false;
            boolean setCorrection = false;

            for(CSS_JobHistory__c cccc : fourcNotes) {
                if(cccc.CSS_Field_Name__c == 'EditComplaint__c' && setComplaint == false) {
                    newClaim.JobComplaintLastModified__c = cccc.CreatedBy.Name + ';;' + cccc.CreatedDate;
                    newClaim.JobEditComplaint__c = cccc.CSS_New_Value__c;
                    setComplaint = true;
                }
                if(cccc.CSS_Field_Name__c == 'EditCause__c' && setCause == false) {
                    newClaim.JobCauseLastModified__c = cccc.CreatedBy.Name  + ';;' + cccc.CreatedDate;
                    newClaim.JobEditCause__c = cccc.CSS_New_Value__c;
                    setCause = true;
                }
                if(cccc.CSS_Field_Name__c == 'EditCoverage__c' && setCoverage == false) {
                    newClaim.JobCoverageLastModified__c = cccc.CreatedBy.Name  + ';;' + cccc.CreatedDate;
                    newClaim.JobEditCoverage__c = cccc.CSS_New_Value__c;
                    setCoverage = true;
                }
                if(cccc.CSS_Field_Name__c == 'EditCorrection__c' && setCorrection == false) {
                    newClaim.JobCorrectionLastModified__c = cccc.CreatedBy.Name  + ';;' + cccc.CreatedDate;
                    newClaim.JobEditCorrection__c = cccc.CSS_New_Value__c;
                    setCorrection = true;
                }
            }

            //If the workjob id is present then the workjob's swo field is also to be populated with claim swo field.
            newClaim.Shop_Work_Order__c=workJob.Shop_Work_Order__c;
        }

        system.debug('newClaim>>>' + newClaim);

        if(newClaim != null)
        {
            insert newClaim;

            psnDetails.PSN__c = workJob.ESN__c;
            psnDetails.Name = workJob.ESN__c;            
            psnDetails.Unit_Number__c = workJob.Unit_Number__c;
            psnDetails.Application__c = workJob.Application_Desc__c;
            psnDetails.Service_Model__c = workJob.Service_Model__c;
            psnDetails.License_Plate_State__c = workJob.License_Plate__c;
            psnDetails.Make__c = workJob.Make__c;
            psnDetails.Model__c = workJob.Model__c;
            psnDetails.Unit_Type__c = workJob.Unit_Type__c;
            psnDetails.VIN__c = workJob.VIN__c;
            psnDetails.Warranty_Start_Date__c = workJob.Warranty_Start_Date__c;
            psnDetails.Before_In_Service__c = workJob.Before_In_Service__c;
            psnDetails.Failure_Date__c = workJob.Failure_Date__c;
            psnDetails.Mileage__c = workJob.Mileage__c;
            psnDetails.Mileage_Measure__c = workJob.Mileage_Measure__c;
            psnDetails.Product_Hours__c = workJob.CSS_Hours__c;
            psnDetails.Mission_Disabling__c = workJob.CSS_Mission_Disabling__c;
            //SN - 6 Apr 2018 - added mapping for Failures Overview
            psnDetails.Qsol_Engine_Family_Code__c = workJob.Qsol_Engine_Family_Code__c;
            psnDetails.Equipment_ID__c = workJob.Equipment_ID__c;
            psnDetails.CSS_Claims__c = newClaim.id;
            psnDetails.ApplicationCode__c = workJob.ApplicationCode__c;
            psnDetails.Primary__c = true;


            system.debug('NewClaimName**'+newClaim.Name);
            system.debug('NewClaimId**'+newClaim.id);

            if(psnDetails != null)
                insert psnDetails;
            system.debug('psnDetails**'+psnDetails);
            system.debug('isDealer>>'+isDealer);
            system.debug('createdfrom>>'+createdfrom);
            boolean DealerTypeFlag = CSS_utility.getAccounttype(workJob.Account__r.Type);
            String accType;
            accType = (DealerTypeFlag == true) ? 'Dealer Account' : 'Distributor Account';
            //below code for camapigns records clone for automated
            if(workJob !=null && workJob.ESN__c !=null && newClaim.id !=null && psnDetails.id != null){
                if(createdfrom != 'Repair RJ')
                    CG_BL_Claims.cloneAutomatedCampaigns(workJob.id, workJob.ESN__c, newClaim.id, psnDetails.id,isDealer, accType, workJob.PACCAR_Auth_Required__c);
                else
                    CG_BL_Claims.dealercloneAutomatedCampaigns(workJob.id, workJob.ESN__c, newClaim.id, psnDetails.id, accType, workJob.PACCAR_Auth_Required__c);
            }

        }
        if(newClaim.id!=null)
        {
            workJob.Claim_ID__c = newClaim.Id;
            workjob.Sub_Status__c = 'Claim in Progress';
            update workJob;
        }

        system.debug('New Claim Id'+newClaim.Id);


        if(newClaim.id==null)
        {
            pg = new pageReference('/apex/CG_ClaimsIntake'); 
        }
        else
        {
            pg = new pageReference('/apex/CG_ClaimsIntake?id='+newClaim.id); 
        }
        return pg;
    }

    //method to fecth all the locations based on the logged in user 
    public List<SelectOption> getLocationsName() 
    {
        options = new List<SelectOption>();
        try {
            options = CG_BL_ClaimsObj.fetchLocationName(lstUserLocations);
            defaultLoc = CG_BL_ClaimsObj.defaultUserLoc;

            // defaultLocationCode = CG_BL_ClaimsObj.defaultUserLocCode;
            system.debug('defaultLoc--'+defaultLoc);
            // system.debug('defaultLocationCode--'+defaultLocationCode);
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - getLocationsName Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('OUT CG_CL_IntakeCustLegacyBMS - getLocationsName Method ...');
        return options;
    }      


    public static integer recCount=0;
    public static string getSOQLRecCount(){
        system.debug('recCountrecCount '+recCount);

        return String.valueOf(recCount.format());
    }

    @RemoteAction
    public static string CustomSearchJobs(String userLoc,string SOQLSTMT){    
        system.debug('SOQLSTMT ---->' + SOQLSTMT);
        system.debug('userLOC ---->' + userLoc );



        // string manuLocName = options.getValue(userLoc);
        // system.debug('manuLocName' + '   ' + manuLocName);
        Cache.Session.put('ManualClaimsSelectedLocation',userLoc); 

        whClause = SOQLSTMT;        
        system.debug('IN lstServiceJob ***************'+whClause);   

        String sJobs = getlstServiceJob(userLoc);
        string cnt=getSOQLRecCount();
        system.debug('Jobs in --->>>>>'+sJobs); 
        return sJobs+'rccnt-'+cnt;
    }
    public static string getlstServiceJob(string userLoc)
    { 
        //From Here



        lstJob = new List<CSS_Job_Order__c>();
        lstJobnotRCC = new List<CSS_Job_Order__c>();
        lstJobfinal = new List<CSS_Job_Order__c>();
        List < ServiceJobWrap > lstwrap = new List < ServiceJobWrap > ();

        isDealer1 = false;
        string userType = css_Utility.getOrgType(userinfo.getUserId());
        if(userType!=null && userType!= '') {
            if(userType == 'DLR') {
                isDealer1 = true;
            }else if(userType == 'DISTR') {
                isDealer1 = false;
            }
        }

        try{  
            if(userLoc == '-All-'){   
                system.debug('***InsideALL***'); 
                List<CSS_UserLocation__c> allLocation = new List<CSS_UserLocation__c>();
                List<String> allLocationName = new List<String>();
                allLocation = CG_BL_Claims.fetchMultiLocation();
                for(CSS_UserLocation__c Loc : allLocation) {
                    allLocationName.add(loc.Location_Name__c);
                }
                system.debug('allLocationName--'+allLocationName);  
                //RAJESH CODE START HERE
                string query1;
                if(isDealer1==true)
                {
                    system.debug('isDealer1'+isDealer1);
                    query1 ='select id,JobStatus__c,Creator_Location__c,  Name, Customer_Name__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,RecentVisit__c, Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__c, Status__c,Sub_Status__c,Warranty_Coverage_Flag__c,LastUpdateSubStatus__c,Unit_Number__c, Shop_Work_Order__c, JobLocation__c, (Select Id, Body from Notes where Title = \'Bold\') FROM CSS_Job_Order__c where Status__c NOT IN (\'Intake\',\'Appointment\',\'Canceled\',\'Not Supported\') AND JobLocation__c IN:allLocationName AND Claim_ID__c=null AND Sub_Status__c=\'Ready for claim creation\' AND ESN__c != \'\'';
                }else{
                    system.debug('isDealer1'+isDealer1);
                    query1 ='select id,JobStatus__c,Creator_Location__c,  Name, Customer_Name__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,RecentVisit__c, Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__c, Status__c,Sub_Status__c,Warranty_Coverage_Flag__c,LastUpdateSubStatus__c,Unit_Number__c, Shop_Work_Order__c, JobLocation__c, (Select Id, Body from Notes where Title = \'Bold\') FROM CSS_Job_Order__c where Status__c NOT IN (\'Intake\',\'Appointment\',\'Canceled\',\'Not Supported\') AND JobLocation__c IN:allLocationName AND Claim_ID__c=null AND Sub_Status__c=\'Ready for claim creation\' AND Warranty_Coverage_Flag__c=true AND ESN__c != \'\'';
                }
                //string query1 ='select id,JobStatus__c,Creator_Location__c,  Name, Customer_Name__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,RecentVisit__c, Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__c, Status__c,Sub_Status__c,LastUpdateSubStatus__c,Unit_Number__c, Shop_Work_Order__c, JobLocation__c, (Select Id, Body from Notes where Title = \'Bold\') FROM CSS_Job_Order__c where Status__c NOT IN (\'Intake\',\'Appointment\',\'Canceled\',\'Not Supported\')  AND Claim_ID__c=null AND Sub_Status__c=\'Ready for claim creation\' AND ESN__c != \'\'';
                //String query1 = 'select id,JobStatus__c,Creator_Location__c,  Name, Customer_Name__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,RecentVisit__c, Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__c, Status__c,Sub_Status__c,LastUpdateSubStatus__c,Unit_Number__c, Shop_Work_Order__c, JobLocation__c, (Select Id, Body from Notes where Title = \'Bold\') FROM CSS_Job_Order__c where Status__c NOT IN (\'Intake\',\'Appointment\',\'Canceled\',\'Not Supported\') AND JobLocation__c IN:allLocationName AND Claim_ID__c=null';
                //query1 += 'AND ' + whClause;
                system.debug('===> Final Query====>'+ query1);
                system.debug('===> sar whClause====>'+ whClause + '**');
                if(whClause == ' ')
                    whClause = whClause.trim();

                if(whClause == ' All =  ')
                    whClause = '';

                if(whClause!=null && whClause!=''){
                    query1 += 'AND (' + whClause + ')';
                    system.debug('===> Final Query====>'+ query1);
                    system.debug('===> sar whClause====>'+ whClause + '**');
                    query1 += ' order by LastModifiedDate desc LIMIT 100';
                    lstjob=Database.Query(query1);
                }

                else{
                    if(isDealer1==true){
                        system.debug('isDealer1'+isDealer1);
                        lstjob = [select id,JobStatus__c,Creator_Location__c,  Name, Customer_Name__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,
                                  RecentVisit__c, Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__c, Status__c,Sub_Status__c,Warranty_Coverage_Flag__c,LastUpdateSubStatus__c,Unit_Number__c, Shop_Work_Order__c, JobLocation__c, (Select Id, Body from Notes where Title = 'Bold') FROM CSS_Job_Order__c where Status__c NOT IN ('Intake','Appointment','Canceled','Not Supported') AND JobLocation__c  IN : allLocationName AND Claim_ID__c=null 
                                  AND Sub_Status__c='Ready for claim creation' AND ESN__c != '' order by Sub_Status__c desc, LastModifiedDate desc LIMIT 100];
                    }else
                    {
                        system.debug('notisDealer1'+isDealer1);
                        lstjob = [select id,JobStatus__c,Creator_Location__c,  Name, Customer_Name__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,
                                  RecentVisit__c, Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__c, Status__c,Sub_Status__c,Warranty_Coverage_Flag__c,LastUpdateSubStatus__c,Unit_Number__c, Shop_Work_Order__c, JobLocation__c, (Select Id, Body from Notes where Title = 'Bold') FROM CSS_Job_Order__c where Status__c NOT IN ('Intake','Appointment','Canceled','Not Supported') AND JobLocation__c  IN : allLocationName AND Claim_ID__c=null 
                                  AND Sub_Status__c='Ready for claim creation' AND Warranty_Coverage_Flag__c=true AND ESN__c != '' order by Sub_Status__c desc, LastModifiedDate desc LIMIT 100];
                    }
                    /*lstjob = [select id,JobStatus__c,Creator_Location__c,  Name, Customer_Name__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,
                              RecentVisit__c, Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__c, Status__c,Sub_Status__c,LastUpdateSubStatus__c,Unit_Number__c, Shop_Work_Order__c, JobLocation__c, (Select Id, Body from Notes where Title = 'Bold') FROM CSS_Job_Order__c where Status__c NOT IN ('Intake','Appointment','Canceled','Not Supported')  AND Claim_ID__c=null 
                              AND Sub_Status__c='Ready for claim creation' AND ESN__c != '' order by Sub_Status__c desc, LastModifiedDate desc LIMIT 100]; */
                    system.debug('===> RAJESH lstjob====>'+ lstjob);
                } 
                system.debug('***lstjob***'+lstjob);
            }

            else{
                String Locname = userLoc.substring(0,userLoc.length()-8); 
                system.debug('Locname' + ' ' + Locname);
                //RAJESH CODE START HERE
                string query1;
                if(isDealer1==true){
                    query1 ='select id,JobStatus__c,Creator_Location__c,  Name, Customer_Name__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,RecentVisit__c, Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__c, Status__c,Sub_Status__c,Warranty_Coverage_Flag__c,LastUpdateSubStatus__c,Unit_Number__c, Shop_Work_Order__c, JobLocation__c, (Select Id, Body from Notes where Title = \'Bold\') FROM CSS_Job_Order__c where Status__c NOT IN (\'Intake\',\'Appointment\',\'Canceled\',\'Not Supported\') AND JobLocation__c =:Locname AND Claim_ID__c=null AND Sub_Status__c=\'Ready for claim creation\' AND ESN__c != \'\'';
                }
                else{
                    query1 ='select id,JobStatus__c,Creator_Location__c,  Name, Customer_Name__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,RecentVisit__c, Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__c, Status__c,Sub_Status__c,Warranty_Coverage_Flag__c,LastUpdateSubStatus__c,Unit_Number__c, Shop_Work_Order__c, JobLocation__c, (Select Id, Body from Notes where Title = \'Bold\') FROM CSS_Job_Order__c where Status__c NOT IN (\'Intake\',\'Appointment\',\'Canceled\',\'Not Supported\') AND JobLocation__c =:Locname AND Claim_ID__c=null AND Sub_Status__c=\'Ready for claim creation\' AND Warranty_Coverage_Flag__c=true AND ESN__c != \'\'';
                }
                //String query1 = 'select id,JobStatus__c,Creator_Location__c,  Name, Customer_Name__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,RecentVisit__c, Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__c, Status__c,Sub_Status__c,LastUpdateSubStatus__c,Unit_Number__c, Shop_Work_Order__c, JobLocation__c, (Select Id, Body from Notes where Title = \'Bold\') FROM CSS_Job_Order__c where Status__c NOT IN (\'Intake\',\'Appointment\',\'Canceled\',\'Not Supported\') AND JobLocation__c =: userLoc AND Claim_ID_New__c=null';
                //query1 +=  ' AND (' +whClause+ '\''\'+')';
                if(whClause!=null){
                    query1 += ' AND (' + whClause + ')';// + '\'\')';
                }

                system.debug('whClause--'+whClause);
                system.debug('===> Final Query====>'+ query1);
                system.debug('whr clause -->**'+whClause+'**');                
                if(whClause!=null && whClause!='' && whClause != ' ' && whClause.Trim() != 'All ='){
                    query1 += ' order by LastModifiedDate desc LIMIT 100';
                    system.debug('query1Final--'+query1);
                    lstjob=Database.Query(query1);
                }
                else{
                    if(isDealer1==true){
                        lstjob = [select id,JobStatus__c,Creator_Location__c,  Name, Customer_Name__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,
                                  RecentVisit__c, Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__c, Status__c,Sub_Status__c,Warranty_Coverage_Flag__c,LastUpdateSubStatus__c,Unit_Number__c, Shop_Work_Order__c, JobLocation__c, (Select Id, Body from Notes where Title = 'Bold') FROM CSS_Job_Order__c where Status__c NOT IN ('Intake','Appointment','Canceled','Not Supported') AND JobLocation__c  =: Locname AND Claim_ID__c=null 
                                  AND Sub_Status__c='Ready for claim creation'  AND ESN__c != '' order by Sub_Status__c desc,LastModifiedDate desc LIMIT 100]; 
                    }
                    else{
                        lstjob = [select id,JobStatus__c,Creator_Location__c,  Name, Customer_Name__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,
                                  RecentVisit__c, Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__c, Status__c,Sub_Status__c,Warranty_Coverage_Flag__c,LastUpdateSubStatus__c,Unit_Number__c, Shop_Work_Order__c, JobLocation__c, (Select Id, Body from Notes where Title = 'Bold') FROM CSS_Job_Order__c where Status__c NOT IN ('Intake','Appointment','Canceled','Not Supported') AND JobLocation__c  =: Locname AND Claim_ID__c=null 
                                  AND Sub_Status__c='Ready for claim creation' AND Warranty_Coverage_Flag__c=true AND ESN__c != '' order by Sub_Status__c desc,LastModifiedDate desc LIMIT 100]; 
                    }
                    /* lstjob = [select id,JobStatus__c,Creator_Location__c,  Name, Customer_Name__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,
                              RecentVisit__c, Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__c, Status__c,Sub_Status__c,LastUpdateSubStatus__c,Unit_Number__c, Shop_Work_Order__c, JobLocation__c, (Select Id, Body from Notes where Title = 'Bold') FROM CSS_Job_Order__c where Status__c NOT IN ('Intake','Appointment','Canceled','Not Supported')  AND Claim_ID__c=null 
                              AND Sub_Status__c='Ready for claim creation' AND ESN__c != '' order by Sub_Status__c desc,LastModifiedDate desc LIMIT 100]; */
                    system.debug('===> RAJESH inside location lstjob====>'+ lstjob);
                    system.debug('===> RAJESH inside location lstjob size====>'+ lstjob.size());
                } 
            }
            //Till Here

            recCount=0;
            string userId = UserInfo.getUserId();

            for (CSS_Job_Order__c a: lstjob) {
                recCount += 1;
                ServiceJobWrap awrap = new ServiceJobWrap();
                awrap.showBold = true;

                if(a.Notes!=null){

                    for (Note b: a.Notes) {   

                        if (b.body!=null){
                            if(b.body.contains(userId)){  

                                awrap.showBold = false; 

                            }
                        }
                    }
                }
                awrap.id = a.id;
                awrap.name = a.name;
                if (a.Customer_Name__c != null) {
                    awrap.Customer_Name = a.Customer_Name__c;
                }
                // Location story start
                if (a.JobLocation__c != null) {
                    awrap.Job_Location = a.JobLocation__c;
                }
                if (a.Creator_Location__c != null) {        
                    awrap.Job_LocationCode = a.Creator_Location__c;     
                }
                // Location story end
                if (a.Assigned_To__c != null) {
                    awrap.Assigned_To = a.Assigned_To__c;
                }
                if (a.Assigned__c != null) {
                    awrap.Assigned = a.Assigned__c;
                }
                if (a.Additional_Tech1__c != null) {
                    awrap.Assigned_To1 = a.Additional_Tech1__c;
                }
                if (a.Add_Tech1__c != null) {
                    awrap.AssignedTech1 = a.Add_Tech1__c;
                }
                if (a.Additional_Tech2__c != null) {
                    awrap.Assigned_To2 = a.Additional_Tech2__c;
                }
                if (a.Add_Tech2__c != null) {
                    awrap.AssignedTech2 = a.Add_Tech2__c;
                }
                if (a.Additional_Tech3__c != null) {
                    awrap.Assigned_To3 = a.Additional_Tech3__c;
                }
                if (a.Add_Tech3__c != null) {
                    awrap.AssignedTech3 = a.Add_Tech3__c;
                }

                if (a.Additional_Tech4__c != null) {
                    awrap.Assigned_To4 = a.Additional_Tech4__c;
                }
                if (a.Add_Tech4__c != null) {
                    awrap.AssignedTech4 = a.Add_Tech4__c;
                }

                if (a.Additional_Tech5__c != null) {
                    awrap.Assigned_To5 = a.Additional_Tech5__c;
                }
                if (a.Add_Tech5__c != null) {
                    awrap.AssignedTech5 = a.Add_Tech5__c;
                }
                if (a.Additional_Tech6__c != null) {
                    awrap.Assigned_To6 = a.Additional_Tech6__c;
                }
                if (a.Add_Tech6__c != null) {
                    awrap.AssignedTech6 = a.Add_Tech6__c;
                }
                if (a.Additional_Tech7__c != null) {
                    awrap.Assigned_To7 = a.Additional_Tech7__c;
                }
                if (a.Add_Tech7__c != null) {
                    awrap.AssignedTech7 = a.Add_Tech7__c;
                }
                if (a.Additional_Tech8__c != null) {
                    awrap.Assigned_To8 = a.Additional_Tech8__c;
                }
                if (a.Add_Tech8__c != null) {
                    awrap.AssignedTech8 = a.Add_Tech8__c;
                }
                if (a.Additional_Tech9__c != null) {
                    awrap.Assigned_To9 = a.Additional_Tech9__c;
                }
                if (a.Add_Tech9__c != null) {
                    awrap.AssignedTech9 = a.Add_Tech9__c;
                }
                if (a.LastSaved__c != null) {
                    awrap.LastSaved = a.LastSaved__c.format('dd MMM YYYY hh:mm a z');
                    awrap.LastSaved_sort = a.LastSaved__c.format('yyyy MM dd HH:mm a z');
                }
                if (a.DSID__C != null) {
                    awrap.DSID = a.DSID__C;
                }
                if (a.Date_In__c != null) {
                    awrap.Date_In = a.Date_In__c.format('dd MMM YYYY HH:mm a z');
                    awrap.Date_In_sort = a.Date_In__c.format('yyyy MM dd HH:mm a z');
                }
                if (a.Service_Model__c != null) {
                    awrap.Service_Model = a.Service_Model__c;
                }  
                if (a.Status__c != null) {
                    awrap.Status = a.Status__c;
                } 
                if (a.Sub_Status__c != null && a.Sub_Status__c!='-Select One-') {
                    awrap.Sub_Status = a.Sub_Status__c;
                }
                if (a.LastUpdateSubStatus__c != null  && a.Sub_Status__c!='-Select One-') {
                    awrap.LastUpdateSubStatus = a.LastUpdateSubStatus__c.format('dd MMM YYYY hh:mm a z');
                }
                if (a.Unit_Number__c != null) {
                    awrap.Unit_Number = a.Unit_Number__c;
                }            
                if(a.Created_Time_Zone__c!=null){
                    awrap.Created_Time_Zone = a.Created_Time_Zone__c.format('MMM dd YYYY hh:mm a z');
                    awrap.Created_Time_sort = a.Created_Time_Zone__c.format('yyyy MM dd HH:mm a z');
                }
                if (a.Shop_Work_Order__c != null) {
                    awrap.Shop_s_Work_Order = a.Shop_Work_Order__c;
                } 
                if (a.RecentVisit__c != false) {
                    awrap.RecentVisit = a.RecentVisit__c;
                } 
                if (a.Repeat_Visit__c != false) {
                    awrap.Repeat_Visit = a.Repeat_Visit__c;
                } 
                if (a.JobStatus__c != null) {
                    awrap.jobStatus = a.JobStatus__c;
                } 
                awrap.dField='Visible';
                awrap.jobLocation=a.JobLocation__c;

                lstwrap.add(awrap);

            }

            system.debug('JSON Value is ==>'+JSON.serialize(lstwrap)); 

            return JSON.serialize(lstwrap);

        }catch(Exception e){ System.debug('Exception e' + e.getMessage()); return null;}  

    }


    /*Wrapper class to store the Service Job Info */
    public class ServiceJobWrap {
        //Static Variables 

        //varibale for showing Bold
        public boolean showBold;
        public string id;
        public string name;
        public string Customer_Name;
        // Location story start
        public string Job_Location;
        // Location story start
        public string Assigned_To;
        public string Assigned;

        public string Assigned_To1;
        public string AssignedTech1;

        public string Assigned_To2;
        public string AssignedTech2;
        //Added by shanthi- Assignee
        public string Assigned_To3;
        public string AssignedTech3;

        public string Assigned_To4;
        public string AssignedTech4;
        public string Assigned_To5;
        public string AssignedTech5;
        public string Assigned_To6;
        public string AssignedTech6;
        public string Assigned_To7;
        public string AssignedTech7;
        public string Assigned_To8;
        public string AssignedTech8;
        public string Assigned_To9;
        public string AssignedTech9;
        //end
        public string DSID;    
        public string Date_In;
        public string Date_In_sort;
        public string Created_Time_Zone;
        public string Created_Time_sort;
        public string Status;
        public string Sub_Status;
        public string LastUpdateSubStatus;
        public string Service_Model;
        public boolean RecentVisit;
        public boolean Repeat_Visit;
        public string LastSaved;
        public string LastSaved_sort;

        public string Unit_Number;
        public string Shop_s_Work_Order; 
        public string dField;
        public string jobStatus;
        public string jobLocation;
        public string Job_LocationCode;
        /*Wrapper class Constructor to initialize the value to members */
        public ServiceJobWrap () {
            LastSaved='';
            LastSaved_sort='';
            Customer_Name='';
            // Location story start
            Job_Location=''; 
            // Location story start
            Assigned_To='';
            Assigned='';

            Assigned_To1='';
            AssignedTech1='';
            Assigned_To2='';
            AssignedTech2='';
            Assigned_To3='';
            AssignedTech3='';
            Assigned_To4='';
            AssignedTech4='';
            Assigned_To5='';
            AssignedTech5='';
            Assigned_To6='';
            AssignedTech6='';
            Assigned_To7='';
            AssignedTech7='';
            Assigned_To8='';
            AssignedTech8='';
            Assigned_To9='';
            AssignedTech9='';
            DSID='';
            Date_In='';
            Date_In_sort='';
            Status='';
            Sub_Status ='';
            LastUpdateSubStatus = '';            
            Unit_Number='';
            Service_Model='';
            Shop_s_Work_Order='';
            dField='';
            Created_Time_Zone='';
            Created_Time_sort='';
            jobLocation='';
            Job_LocationCode ='';
        }

    }
}