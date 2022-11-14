/* This class is used for only FSL Development*/
public class FSL_CL_IntakeWarranty 
{
    //Global Veriables
    public FSL_CL_IntakeWarranty controllerRef{get;set;}
    public String userERPSystem{set;get;}
    public CSS_Job_order__c workJob{set;get;}
    public String dummyValue{set;get;}
    public Id Wid;
    public CSS_accountLanguage__c accountlang{get; set;}
    public Map<String,String> mapDescriptionToCode;
    public string mil_measure;
    public string fail_measure;
    //public string datebyLocaleValue {get;set;}
    //public Boolean displayPopup {set;get;}
    public CG_cancelServiceJobWrapper cancelSJWrapperObj1{get;set;}
    //Global Veriables
    
    public FSL_CL_IntakeWarranty()
    {
    	System.debug('In CG_CL_IntakeWarranty constructor...');
        try {
            controllerRef = this;
            dummyValue = 'Hello world';
            Wid=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('Wid::'+Wid);
            if(Wid== null) 
            {
                workJob =new css_job_order__c();                    
            } else if(Wid.getSObjectType().getDescribe().getName() == 'CSS_Job_Order__c')
            {    
                workJob = [Select Id,Name,Customer_Name__c, Account__r.ERP_System__c,Creator_Location__c,CreatedDate,Date_In__c,JobLocation__c,CSS_Job_Location_Code__c,Complaint_Type4_Desc__c, Primary_Segment__c,Failure_Date__c,Failure_Point__c,
                   Customer_Code__c,First_Name__c,CSS_Bms_ContactBoolean__c ,CSS_Charge_Account_Status__c,BMS_Last_Name__c,Email_Address__c,Complaint_Type3_Desc__c, VIN_Flag__c,previousESN_MultiLoc__c,Location_Certification__c,
                   Email_check_box__c ,bmsCreateAccount__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Preventive_Maintenance__c,Complaint_Type2_Desc__c,Qsol_Engine_Family_Code__c,Warranty_Authorization_Flag__c,
                   Address__c,City__c,ZipCode__c,Country__c,Category2_Desc__c ,Category3_Desc__c,Category4_Desc__c,Category5_Desc__c ,Sub_Type__c,Application__c, Region__c,Territory__c,Before_In_Service__c,Contact_ID__c,
                   CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c,ProductAppcodeErrorflag__c ,
                   Category_Desc__c ,Complaint_Type_Desc__c,Expedited_Service__c,SP_Country__c,Unit_Number__c ,Application_Desc__c,Make__c,Repair_Location__c,CSS_State__c ,BMSStatus__c,ApplicationCode__c,SP_ClaimAllowedDays__c,   
                   Status__c,LastModifiedDate,Repeat_Or_Recent_Calc__c,Shop_Work_Order__c,ESN__c,Service_Model__c,Model__c,VIN__c,Mileage__c,CSS_Hours__c,Unit_Type__c,Sub_Status__c,SP_CampaignTRP__c,SP_BusinessUnit__c,SP_AccountStatus__c,SP_CMISPExpirationDate__c,SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,     
                   General_Symptoms__c,Warranty_Start_Date__c,Mileage_Measure__c,ESN_Locked__c,PSN_Not_Available__c,Date_in_Shop__c,ESN_IA__c , Complaint_Type5_Desc__c,Complaint_Type5__c,
                   (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC)
                   from CSS_Job_Order__c where id= :Wid];
            }
        }
        catch(Exception e)  
        {
         system.debug('EXCEPTION of CG_CL_IntakeWarranty constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('OUT CG_CL_IntakeWarranty constructor...');
    }
    
    /*public PageReference Redirect()
    {
    PageReference pageRef = new pageReference('/apex/CG_IntakeUE?id='+wid); 
    pageRef.setRedirect(true);
    System.debug('**********************Redirecting to UE Page****************************');     
    return pageRef;
    }*/
    
       /* public id saveIntakeWarranty(id inpJobId, String status)
       {
        Id JobId;
        try{
            if (ChkFieldBlank() =='BLANK')
            {
                
                system.debug('Inside Blank IF');
                return null;
            }
            else
            {
                // Create Job 
                system.debug('in Save ESN-->'+workJob.ESN__c);
                css_job_order__c worecord= new css_job_order__c();
                worecord.chevron_page__c = 'ue';
                           worecord.id=inpJobId;
                system.debug('worecord-->'+worecord);
                worecord = CG_BL_Intake.mapSPData(workJob, worecord); 
                upsert worecord;
                JobId = worecord.id;
            }
            return JobId;

        } catch(exception e) 
        {
            system.debug('EXCEPTION of CG_CL_IntakeUE pgSave method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }

    }*/
    //Save Functionality.
    
    
    
    /*public PageReference pgSave() 
    {
        System.debug('IN CG_CL_IntakeWarranty-pgSave method...');
        system.debug('IN CG_CL_IntakeWarranty-pgSave method...');
        system.debug('controllerRef ' + controllerRef);
        system.debug('workJob ' + workJob);
        system.debug('userERPSystem ' + userERPSystem);
        try 
        {
                    if (ChkFieldBlank() =='BLANK') 
                    {
                        return null;
                    } 
            else 
                    {
                        Id sJobId = saveIntakeWarranty(Wid, 'Intake');
                        if(sJobId!=null && sJobId!='' )
                        {
                        PageReference pag = new pageReference('/apex/cg_intakewarranty?id='+sJobId);
                        pag.setRedirect(true);
                        System.debug('OUT CG_CL_IntakeWarranty-pgSave method...');            
                        return pag;
                        }
                        else
                        {
                        PageReference pagr = new pageReference('/apex/cg_intakewarranty'); 
                        pagr.setRedirect(true);
                        System.debug('OUT CG_CL_IntakeWarranty-pgSave method...');            
                        return pagr;
                        }
                    }
                    //return null;            
        } 
        catch(exception e) 
        {
            system.debug('EXCEPTION of CG_CL_IntakeWarranty pgSave method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }
           
    }*/

    //Save and Job Closed functionality.
    /*public PageReference closeSession() 
    {
        System.debug('B4 entering');
        css_job_order__c worecord= new css_job_order__c();
        try {
            if(ChkFieldBlank() =='BLANK') {
                return null;
            } else {
                //worecord= saveIntakeCustomer();
                //worecord = (css_job_order__c)saveIntakeWarranty(Wid, 'Intake');
                worecord.Status__c='Closed';
                worecord = CG_BL_Intake.mapSPData(workJob, worecord); 
                if(Wid== null) 
                    insert worecord;
                else {
                    worecord.id = Wid;
                    update worecord;
                }               
                system.debug('worecord >>>>> ' + worecord);
                Wid = worecord.id;
                PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
                pageRef.setRedirect(true);
                return pageRef;
            }
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer closeSession method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }               
    }*/
    
    //Validations.
    /*public string ChkFieldBlank() 
    {
        System.Debug('in BLANK==============workJob.Customer_Name__c '+workJob.Customer_Name__c);
        System.Debug('in BLANK==============workJob.Shop_Work_Order__c '+workJob.Shop_Work_Order__c);
        try 
        {
            if((workJob.Customer_Name__c == null) && (workJob.Shop_Work_Order__c == null) && workJob.status__c == null) 
            
            {
                System.Debug('in BLANK==============');
                return 'BLANK';
            } else 
                if((workJob.Customer_Name__c == null || workJob.Customer_Name__c == '')) 
            {
                System.Debug('in VALIDATE==============');
                return 'VALIDATE';
            } else 
            {
                System.Debug('in FILLED==============');
                return 'FILLED';
            }
        } 
        catch(exception e) 
        {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer ChkFieldBlank method >>> '+e.getMessage() + e.getLineNumber());
            return 'null';
        }     
    }*/
    //Cancel Functionality.
    //Note Cancel()----Calls----saveIntakeWarranty()----calls----ChkFieldBlank()
    /*public void Cancel() 
    {
        System.debug('B4 entering');
        css_job_order__c worecord= new css_job_order__c();
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        try {
            if (ChkFieldBlank() =='BLANK') 
            {
                //reqBoolean='true';
                System.debug('***********************************************The job is not***********************************************'+worecord.Status__c);
                //return null;
            } else 
            {
                wid= saveIntakeWarranty(Wid,'Intake');
                worecord.Status__c='Canceled';
                System.debug('***********************************************The job is***********************************************'+worecord.Status__c);
                if(Wid==null) {
                    insert worecord;
                    cancelSJWrapperObj1.errorFlag = false;
                    cancelSJWrapperObj1.errorMessage = '';
                    cancelSJWrapperObj1.serviceJob = worecord;
                }
                else 
                {
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
                System.debug('***********************************************Does it reaching here***********************************************');
                system.debug('cancelSJWrapperObj1 >>>>> ' + cancelSJWrapperObj1);
                system.debug('worecord >>>>> ' + worecord);
                //Wid = cancelSJWrapperObj1.serviceJob.id;
                //return pageRef;
            }
        } 
        catch(exception e) 
        {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer Cancel method >>> '+e.getMessage() + e.getLineNumber());
            //return null;
        }       
    }*/
    public void pageAction() 
    {
        //Starts - Warranty - FSL Changes-Vinod Yelala - Added to bypass logic for FSL Servicejob object
        if(Wid != null && Wid.getSObjectType().getDescribe().getName() == 'CSS_Job_Order__c'){
            System.debug('IN CG_CL_IntakeWarranty-pageAction method...');
            List<Account> acList;
            String userLocation;
            try {
                if(Cache.Session.get('UserERPSystem') == null)
                {
                    if(Wid== null) {
                        User UserObject = [select User_Location__c from user where id=:UserInfo.getUserId() LIMIT 1];
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
            }
            catch(Exception e)  
            {
                system.debug('EXCEPTION of CG_CL_IntakeCustomer pageAction method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            }
            System.debug('OUT CG_CL_IntakeCustomer-pageAction method...');
        }
        //Ends Warranty - FSL Changes-Vinod Yelala
    }
    // Begin Chevron Navigation methods
    /*public PageReference nvIntakeCustomer()
    {
        PageReference pageRef;
        Wid = saveIntakeWarranty(Wid, 'Intake');
        if(Wid==null)
        {
            pageRef = new pageReference('/apex/CG_IntakeCustomer'); 
        }
        else
        {
            pageRef = new pageReference('/apex/CG_IntakeCustomer?id='+Wid); 
        }
        return pageRef;
    }

    public PageReference nvIntakeUE(){
        PageReference pageRef;
        Wid = saveIntakeWarranty(Wid, 'Intake');
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeUE'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeUE?id='+Wid); 
        }
        return pageRef;
    }
    public PageReference nvIntakeVH(){
        PageReference pageRef;
        Wid = saveIntakeWarranty(Wid, 'Intake');
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeVH'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeVH?id='+Wid); 
        }
        return pageRef;
    }
    public PageReference nvIntakeCC(){
        PageReference pageRef;
        Wid = saveIntakeWarranty(Wid, 'Intake');
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeCC'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeCC?id='+Wid); 
        }
        return pageRef;
    }
    public PageReference nvIntakeRJ(){
        PageReference pageRef;
        Wid = saveIntakeWarranty(Wid, 'Intake');
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeRJ'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeRJ?id='+Wid); 
        }
        return pageRef;
    }
    //End Navigation methods
    
   //Redirecting to Job Detail page on click of exit pop up yes button
    public PageReference redirectPopup()
    {
        try 
        {
            displayPopup = false;
            pageReference p = new pageReference('/apex/CSS_Job_Detail?nto=HOME');
            p.setRedirect(true);
            return p;
        } 
        catch(exception e) 
        {
            system.debug('EXCEPTION of CG_CL_IntakeWarranty redirectPopup method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }       
    }*/
}