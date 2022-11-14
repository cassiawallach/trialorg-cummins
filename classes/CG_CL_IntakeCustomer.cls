/**********************************************************************
Name:CG_CL_IntakeCustomer
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this Page Controller for Customer Chevron.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Krishnamoorthi      12/19/2017      INITIAL DEVELOPMENT                    
***********************************************************************/
public class CG_CL_IntakeCustomer 
{

    //Global Veriables
    public String PageName {get;set;}
    public CG_CL_IntakeCustomer controllerRef{get;set;}
    public CG_CL_IntakeVH mainContrVH{set; get;}
    public CG_CL_IntakeRJ mainContrRJ{set; get;}
    public CG_CL_IntakeWarranty mainContrWR{set; get;}
    public String userERPSystem{set;get;}
    public Boolean checkFSLEnabled{set;get;}
    public CSS_Job_order__c workJob{set;get;}
    public string selectedLocation {get;set;}
    public string selectedLocationName {get;set;}
    public boolean displayPopup {get;set;}
    public string EmailAddress {get;set;}
    public string EmailAddress1 {get;set;}
    public String filterApplication {get;set;}
    public string AppointmentName{get;set;}
    public string filterCountry { get; set; }
    public string filterState { get; set; }
    public String strCntry {get;set;}
    public String strCntryState {get;set;}
    public CG_cancelServiceJobWrapper cancelSJWrapperObj1{get;set;}
    //public String BMSDelErrorMsg {get;set;}
    //public Boolean BMSError {get;set;}

    public Id Wid;
    public String appCode;
    public User userObj;
    public List<SelectOption> options;
    public list<CSS_UserLocation__c> lstUserLocations;

    public CG_BL_Intake CG_BL_IntakeObj = new CG_BL_Intake();
    
    //Global Veriables

    //Constructor.
    public CG_CL_IntakeCustomer()
    {
        System.debug('IN CG_CL_IntakeCustomer constructor...');
        try {
            controllerRef = this;
            //dummyValue = 'Hello world';
            System.debug('Before CG_CL_IntakeCustomer ' + Wid);
            Wid=ApexPages.CurrentPage().getParameters().get('id');
            System.debug('After CG_CL_IntakeCustomer ' + Wid);
            if(Wid== null) {
                workJob =new css_job_order__c();  
                AppointmentName = 'No';
            } else {    
                workJob = [Select Id, Name, Customer_Name__c, Account__r.ERP_System__c,Contact_Id__c, Customer_Code__c, First_Name__c, CSS_Bms_ContactBoolean__c, CSS_Charge_Account_Status__c, Primary_Segment__c,
                           CSS_State__c, BMS_Last_Name__c, Email_check_box__c, bmsCreateAccount__c, Phone_Number__c, Contact_Name__c, SP_ClaimAllowedDays__c,Repair_Location__c,
                           Cstmr_Contacts_Phone__c, Address__c, City__c, ZipCode__c, Country__c, Creator_Location__c, Shop_Work_Order__c,SP_AccountStatus__c,
                           Date_in_Shop__c, CreatedDate, IsAppointment__c, Email_Address__c, Application_Desc__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                           CSS_Channel_Code__c,SP_Country__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, Available_Credit__c, Amount_Due__c, Credit_Limit__c,
                           CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c, Failure_Date__c,Status__c,SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c
                           from CSS_Job_Order__c where id= :Wid];
                System.debug('workJob ' + workJob);
                AppointmentName = workJob.IsAppointment__c;
                if(workJob.Email_Address__c != null && workJob.Email_Address__c != '' && workJob.Email_Address__c.contains('@')) {
                    string[] emails = workJob.Email_Address__c.split('@');
                    EmailAddress = emails[0];
                    EmailAddress1 = emails[1];
                }
                filterApplication = workJob.Application_Desc__c;

                if (workJob.Country__c=='' || workJob.Country__c=='----None----' || workJob.Country__c==null) {
                    filterCountry = '----None----';                                        
                } else {
                    strCntry=css_utility.getCountryDesc(workJob.Country__c);
                    system.debug('rajput-strc-->'+strCntry);
                    filterCountry = workJob.Country__c;
                    system.debug('rajesh-filterCountry-->'+filterCountry);
                }

                if (workJob.CSS_State__c==null || workJob.CSS_State__c=='----None----' || workJob.CSS_State__c=='') {
                    filterState = '----None----';
                } else {
                    strCntryState=css_utility.getStateDesc(workJob.Country__c, workJob.CSS_State__c);
                    filterState = workJob.CSS_State__c;
                }
            }
            system.debug('Before fetchMultiLocation');
            list<CSS_UserLocation__c> lstUserLocations = CG_BL_Intake.fetchMultiLocation();
            options = CG_BL_IntakeObj.fetchLocationName(lstUserLocations);
            system.debug('After fetchMultiLocation');
            //userERPSystem = (String) Cache.Session.get('UserERPSystem');
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('OUT CG_CL_IntakeCustomer constructor...');
    }
    //Constructor.

    //Page Loading Action.
    public void pageAction()
    {
        System.debug('IN CG_CL_IntakeCustomer-pageAction method...');
        List<Account> acList;
        String userLocation;
        //User userObj;
        try {
            if(Wid== null) {
                userERPSystem = (String) Cache.Session.get('UserERPSystem');
                if(userERPSystem == null || userERPSystem == '') {
                userObj = [select Id,UserLoginCounter__c,CSS_User_MultiLocValues__c,LastLoginDate,UserPreviousLoginDate__c, UserGroup__c,User_Location__c,User_Role__c, UserRoleName__c,Product_Group_Access__c,Work_Group_Name__c,FederationIdentifier,LanguageLocaleKey from user where id=:UserInfo.getUserId() LIMIT 1];
                    system.debug('userObj IF'+userObj);
                    css_utility.setSessionVariables(userObj.User_Location__c);
                }
            } else {
            if(workJob !=null && workJob.Creator_Location__c !=null && workJob.Creator_Location__c.trim() !=''){
                    css_utility.setSessionVariables(workJob.Creator_Location__c);
                } else {
                system.debug('userObj Else'+userObj);
                    userObj = [select Id,UserLoginCounter__c,CSS_User_MultiLocValues__c,LastLoginDate,UserPreviousLoginDate__c, UserGroup__c,User_Location__c,User_Role__c, UserRoleName__c,Product_Group_Access__c,Work_Group_Name__c,FederationIdentifier,LanguageLocaleKey from user where id=:UserInfo.getUserId() LIMIT 1];
                    css_utility.setSessionVariables(userObj.User_Location__c);
                }
            }
            System.debug('current1 userERPSystem-->'+Cache.Session.get('UserERPSystem'));
userERPSystem = (String) Cache.Session.get('UserERPSystem');
            System.debug('current2 userERPSystem-->'+userERPSystem);
            
            //Fetch SP Data Values.
            if(workJob.Id != null && workJob.Territory_Class_Name__c == null) {
                workJob = CG_BL_Intake.fetchSPData(workJob, workJob.creator_location__c, null, workJob.Failure_Date__c, null);
            } //Fetch SP Data Values.
             checkFSLEnabled = css_utility.getFSLEnabled(UserInfo.getUserId()); //added by roopa for FSL story
            System.debug('checkFSLEnabled'+ checkFSLEnabled);
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer pageAction method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('OUT CG_CL_IntakeCustomer-pageAction method...'+ userERPSystem);
    }
    //Page Loading Action.

    //Save Functioanlity for Intacke Customer - Both BMS and NO ERP System.
    public css_job_order__c saveIntakeCustomer() {
        css_job_order__c worecord = new css_job_order__c();
        try {
            if(AppointmentName != '' && AppointmentName == 'Yes'){
                worecord.Status__c='Appointment';
                worecord.IsAppointment__c = 'Yes';
            } else {
                worecord.Status__c='Intake';
                worecord.IsAppointment__c = 'No';
            }
            system.debug('in Save1 -->'+workJob.Customer_Name__c);
            worecord.Customer_Code__c = workJob.Customer_Code__c;
            worecord.Customer_Name__c = workJob.Customer_Name__c;
            worecord.Shop_Work_Order__c = workJob.Shop_Work_Order__c;
            worecord.Repair_Location__c = workJob.Repair_Location__c;
            if(workJob.Date_in_Shop__c!=null)
             worecord.Date_In__c = datetime.newInstance(workJob.Date_in_Shop__c.year(), workJob.Date_in_Shop__c.month(),workJob.Date_in_Shop__c.day(),12,0,0);
            worecord.Date_in_Shop__c = workJob.Date_in_Shop__c;
            system.debug('selectedLocation123---> '+selectedLocation);
            selectedLocation = (String) Cache.Session.get('selectedLocation');
            system.debug('selectedLocation---> '+selectedLocation);
            system.debug('options---> '+options);
            if(options !=null && options.size()>0) {
                if(selectedLocation == null || selectedLocation == '') {
                    system.debug('inside171 if---> '+selectedLocation);
                    if(wid==null) // Added if condition as part of defect#137041
                         {
                    User users = [SELECT Id, User_Location__c FROM User WHERE Id = :UserInfo.getUserId()];
                        selectedLocation = users.User_Location__c;
                         }
                        else{ //Added else conditon and statement as part of defect#137041
                            
                            selectedLocation=workJob.Creator_Location__c;
                        }
                }
                system.debug('outside171 if---> '+selectedLocation);
                //selectedLocation = userObj.User_Location__c;
                //for loop to set the location name selected on the user screen based on the location code .
                for(SelectOption s : options){
                    if(s.getValue() == selectedLocation){
                        worecord.jobLocation__c = s.getLabel();
                    }
                    system.debug('worecord.jobLocation__c--->'+worecord.jobLocation__c);
                }
                if(worecord.jobLocation__c==null) //Added if condition as part of defect#137041
                {
                    system.debug('inside190 if---> '+worecord.jobLocation__c);
                    worecord.jobLocation__c=[select id,Location_Name__c from CSS_UserLocation__c where Location_code__c =:selectedLocation  limit 1].Location_Name__c;
                }
            }
            worecord.CSS_Job_Location_Code__c = selectedLocation;
            system.debug('selectedLocation**'+selectedLocation);
            if(!Test.isRunningTest()){  
worecord.account__c = CG_BL_Intake.FetchAccountId(selectedLocation);
            }else{
             worecord.account__c = '0014N00001ioptP';  
            }
            userERPSystem = (String) Cache.Session.get('UserERPSystem');
            if(userERPSystem == 'BMS Legacy' || userERPSystem =='One BMS') {
                worecord.Phone_Number__c = workJob.Phone_Number__c;
                worecord.First_Name__c = workJob.First_Name__c;
                worecord.BMS_Last_Name__c = workJob.BMS_Last_Name__c;
                worecord.Contact_ID__c = workJob.Contact_ID__c;
                worecord.Cstmr_Contacts_Phone__c = workJob.Cstmr_Contacts_Phone__c;
                worecord.Email_check_box__c = workJob.Email_check_box__c;
                worecord.Address__c = workJob.Address__c;
                worecord.City__c = workJob.City__c;
                worecord.ZipCode__c =workJob.ZipCode__c;
                worecord.CSS_Charge_Account_Status__c = workJob.CSS_Charge_Account_Status__c;
                system.debug('CSS_Charge_Account_Status' +worecord.CSS_Charge_Account_Status__c);
worecord.Available_Credit__c = workJob.Available_Credit__c;
worecord.Amount_Due__c = workJob.Amount_Due__c;
worecord.Credit_Limit__c = workJob.Credit_Limit__c;
                worecord.bmsCreateAccount__c = workJob.bmsCreateAccount__c;
                worecord.CSS_Bms_ContactBoolean__c = workJob.CSS_Bms_ContactBoolean__c;
                if(workJob.Email_check_box__c==true) {
                    worecord.Email_Address__c='declined@cummins.com';
                } else {
                    if(EmailAddress == null)
                        EmailAddress = '';
                    if(EmailAddress1 == null)
                        EmailAddress1 = '';    
                    if((EmailAddress == null || EmailAddress == '') && (EmailAddress1 == null || EmailAddress1 == ''))
                        worecord.Email_Address__c='';
                    else
                        worecord.Email_Address__c= EmailAddress+'@'+EmailAddress1;
                }

                worecord.CSS_State__c = filterState;
                worecord.Country__c = filterCountry;
                worecord.Application_Desc__c = filterApplication;
            }
            system.debug('in Save2 -->'+worecord);
            
            worecord = CG_BL_Intake.mapSPData(workJob, worecord);           
            return worecord;
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer saveIntakeCustomer method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            return null;
        }
        System.debug('OUT CG_CL_IntakeCustomer-saveIntakeCustomer method...'+ userERPSystem);
        return null;
    }

    //Save Customer Generic Method for BMS and NO ERP System.
    public id saveCustomer(id inpJobId) {
        Id JobId;           
        try {
            css_job_order__c worecord= saveIntakeCustomer();
            worecord.id = inpJobId;
            system.debug('BEFORE SAVE ' + worecord);
            upsert worecord;
            system.debug('AFTER SAVE ' + worecord);
            JobId = worecord.id;
            return JobId;
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer saveCustomer method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }
    }

    //Save Functionality.
    public PageReference pgSave() {
        System.debug('IN CG_CL_IntakeCustomer-pgSave method...');
        system.debug('controllerRef ' + controllerRef);
        system.debug('workJob ' + workJob);
        system.debug('userERPSystem ' + userERPSystem);
          try 
          {
                    if (ChkFieldBlank() =='BLANK') 
                    {
                        System.debug('*****************************It reaching 1*****************************');
                        return null;
                    } 
                    else 
                    {
                        System.debug('*****************************It reaching 2*****************************');
                        Id sJobId = saveCustomer(Wid);
                        if(sjobid==null)
                        {
                        PageReference pageRef1 = new pageReference('/apex/CG_IntakeCustomer?id='+wid); 
                        pageRef1.setRedirect(true);                        
                        return pageRef1;
                        }
                        else
                        {
                        PageReference pageRef2 = new pageReference('/apex/CG_IntakeCustomer?id='+sJobId); 
                        pageRef2.setRedirect(true);
                        return pageRef2;
                        }
                        
                        System.debug('OUT CG_CL_IntakeCustomer-pgSave method...');            
                        
                    }
            return null;            
        } 
        catch(exception e) 
        {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer pgSave method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }
    }

    //Validations.
    public string ChkFieldBlank() {
        try {
            if((workJob.Customer_Name__c != null && workJob.Customer_Name__c != '') || (workJob.Shop_Work_Order__c != null && workJob.Shop_Work_Order__c != '')
              || (workJob.Phone_Number__c != null && workJob.Phone_Number__c != '') || (workJob.First_Name__c != null && workJob.First_Name__c != '')
              || (workJob.BMS_Last_Name__c != null && workJob.BMS_Last_Name__c != '') || (workJob.Cstmr_Contacts_Phone__c != null && workJob.Cstmr_Contacts_Phone__c != '')
              || (workJob.Address__c != null && workJob.Address__c != '') || (workJob.City__c != null && workJob.City__c != '')
              || (filterCountry != null && filterCountry != '') || (filterState != null && filterState != '') || (filterApplication != null && filterApplication != '')
              //|| ((EmailAddress != null || EmailAddress != '') && (EmailAddress1 != null || EmailAddress1 != ''))
              ) 
                return 'FILLED';
            else 
            return 'BLANK';

        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer ChkFieldBlank method >>> '+e.getMessage() + e.getLineNumber());
            return 'null';
        }     
    }

    //Save and Job Closed functionality.
    public PageReference closeSession() {
        System.debug('B4 entering');
        css_job_order__c worecord= new css_job_order__c();
        try {
            if(ChkFieldBlank() =='BLANK') {
                return null;
            } else {
                worecord= saveIntakeCustomer();
                worecord.Status__c='Closed';
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
    }

    //Cancel Functionality.
    public void Cancel() {
        System.debug('B4 entering');
        css_job_order__c worecord= new css_job_order__c();
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        try {
            if (ChkFieldBlank() =='BLANK') {
                //reqBoolean='true';
                //return null;
            } else {
                System.debug('InsideElse b4 calling BMSwebservice');
                worecord= saveIntakeCustomer();
                worecord.Status__c='Canceled';
                if(Wid== null){ 
                    insert worecord;
                    cancelSJWrapperObj1.errorFlag = false;
                    cancelSJWrapperObj1.errorMessage = '';
                    cancelSJWrapperObj1.serviceJob = worecord;
                }
                
                else {
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

    //Redirecting to Job Detail page.
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
            system.debug('EXCEPTION of CG_CL_IntakeCustomer redirectPopup method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }       
    }

    //Begin Navigation methods
public boolean appointmentValidation{get;set;}
    //Naviagation to Unit and Engine.
    public PageReference nvIntakeUE(){
        PageReference pageRef;
        try {
            //Anirudh added code for defect 132009
             if(AppointmentName != '' && AppointmentName == 'Yes' && (workJob.Customer_Name__c == null || workJob.Customer_Name__c == '')) {
               appointmentValidation = true;
               return null;
            }
            else{
               appointmentValidation = false;
            }
//End Defect 132009
            if (ChkFieldBlank() =='BLANK') {
                pageRef = new pageReference('/apex/CG_IntakeUE'); 
            } else {
                Id sJobId = saveCustomer(Wid);
                pageRef = new pageReference('/apex/CG_IntakeUE?id='+sJobId); 
                pageRef.setRedirect(true);
            }
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer nvIntakeUE method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }      
        return pageRef;
    }

    //Naviagation to Customer Complaint.
    public PageReference nvIntakeCC(){
        PageReference pageRef;
        try {
            //Anirudh added code for defect 132009
             if(AppointmentName != '' && AppointmentName == 'Yes' && (workJob.Customer_Name__c == null || workJob.Customer_Name__c == '')) {
               appointmentValidation = true;
               return null;
            }
            else{
               appointmentValidation = false;
            }
            //End Defect 132009
            if (ChkFieldBlank() =='BLANK') {
                pageRef = new pageReference('/apex/CG_IntakeCC'); 
            } else {
                Id sJobId = saveCustomer(Wid);
                pageRef = new pageReference('/apex/CG_IntakeCC?id='+sJobId); 
                pageRef.setRedirect(true);
            }
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer nvIntakeCC method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }      
        return pageRef;

    }

    //Naviagation to View Histry.
    public PageReference nvIntakeVH(){
        PageReference pageRef;
        try {
            //Anirudh added code for defect 132009
             if(AppointmentName != '' && AppointmentName == 'Yes' && (workJob.Customer_Name__c == null || workJob.Customer_Name__c == '')) {
               appointmentValidation = true;
               return null;
            }
            else{
               appointmentValidation = false;
            }
            //End Defect 132009
            if (ChkFieldBlank() =='BLANK') {
                pageRef = new pageReference('/apex/CG_IntakeVH'); 
            } else {
                Id sJobId = saveCustomer(Wid);
                pageRef = new pageReference('/apex/CG_IntakeVH?id='+sJobId); 
                pageRef.setRedirect(true);
            }
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer nvIntakeVH method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }      
        return pageRef;
    }

    //Naviagation to Warranty.
    public PageReference nvIntakeWarranty(){
        PageReference pageRef;
        try {
            //Anirudh added code for defect 132009
             if(AppointmentName != '' && AppointmentName == 'Yes' && (workJob.Customer_Name__c == null || workJob.Customer_Name__c == '')) {
               appointmentValidation = true;
               return null;
            }
            else{
               appointmentValidation = false;
            }
            //End Defect 132009
            if (ChkFieldBlank() =='BLANK') {
                pageRef = new pageReference('/apex/CG_IntakeWarranty'); 
            } else {
                Id sJobId = saveCustomer(Wid);
                pageRef = new pageReference('/apex/CG_IntakeWarranty?id='+sJobId); 
                pageRef.setRedirect(true);
            }
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer nvIntakeWarranty method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }      
        return pageRef;

    }

    //Naviagation to Review Job.
    public PageReference nvIntakeRJ(){
        PageReference pageRef;
        try {
             //Anirudh added code for defect 132009
             if(AppointmentName != '' && AppointmentName == 'Yes' && (workJob.Customer_Name__c == null || workJob.Customer_Name__c == '')) {
               appointmentValidation = true;
               return null;
            }
            else{
               appointmentValidation = false;
            }
            //End Defect 132009
            if (ChkFieldBlank() =='BLANK') {
                pageRef = new pageReference('/apex/CG_IntakeRJ'); 
            } else {
                Id sJobId = saveCustomer(Wid);
                pageRef = new pageReference('/apex/CG_IntakeRJ?id='+sJobId); 
                pageRef.setRedirect(true);
            }
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer nvIntakeRJ method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        } 
        return pageRef;

    }
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

}