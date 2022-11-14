/*
 * Block comments with details of changes
 */
public class CG_CL_IntakeCC
{

    //Global Veriables
    public CG_CL_IntakeCC controllerRef{get;set;}
    public String userERPSystem{set;get;}
    public CSS_Job_order__c workJob{set;get;}
    public Id Wid;
    public Boolean displayPopup {set;get;}

    
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

    public CSS_accountLanguage__c accountlang{get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstCAM {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTRP {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTSB {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstATC {get; set;}
    public CG_cancelServiceJobWrapper cancelSJWrapperObj1{get;set;}
    //Added below variable as per defect 173051,
    public integer generalSym{get; set;}
    public CG_CL_IntakeCC()
    {

        try {
            controllerRef = this;

            Wid=ApexPages.CurrentPage().getParameters().get('id');
            if(Wid== null) {
                workJob =new css_job_order__c();
                generalSym=4000;
            } else {    
                workJob = [Select Id, PACCAR_Auth_Required__c,Name, ESN__c, Model__c,Account__r.ERP_System__c,Warranty_Start_Date__c,Mileage_Measure__c,CSS_Hours__c ,Service_Model__c, VIN__c,Failure_Date__c,Customer_Name__c, CreatedDate ,Date_In__c ,JobLocation__c ,Status__c ,Shop_Work_Order__c,CSS_State__c,Country__c
                           ,LastModifiedDate ,Repeat_Or_Recent_Calc__c , Creator_Location__c, Preventive_Maintenance__c,Expedited_Service__c, SP_BusinessUnit__c, SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,SP_AccountStatus__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,Category_Desc__c
                           , Category2_Desc__c, Category3_Desc__c, Category4_Desc__c, Category5_Desc__c, Complaint_Type_Desc__c, Complaint_Type2_Desc__c
                           , Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, Application_Desc__c,General_Symptoms__c, SP_ClaimAllowedDays__c
                           , Date_in_Shop__c, CSS_Job_Location_Code__c,SP_Country__c, Customer_Code__c, Phone_Number__c, First_Name__c, BMS_Last_Name__c,Make__c
                           , CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c
                           , Cstmr_Contacts_Phone__c,Category__c,Unit_Number__c, Unit_Type__c,Mileage__c,Warranty_Authorization_Flag__c,Location_Certification__c,Repair_Location__c,Sub_Type__c,Email_Address__c, Address__c, City__c, ZipCode__c, CSS_Charge_Account_Status__c,Complaint_Type5__c
                           from CSS_Job_Order__c 
                           where id= :Wid];


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
    //Added below if and else condition  as per defect 173051,-By RAJESH 6th Dec 2018            
                if (workJob.General_Symptoms__c!=null && workJob.General_Symptoms__c.trim() !=''){
                    generalSym=4000 - (workJob.General_Symptoms__c).length() ;}else{
                    generalSym=4000;
                }
   //End if and else condition  as per defect 173051,-By RAJESH 6th Dec 2018

            }
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCC constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }

    }


    //Page Loading Action.
    public void pageAction()
    {
        System.debug('IN CG_CL_IntakeCC-pageAction method...');
        List<Account> acList;
        String userLocation;
        User userObj;
        try {
            if(Wid== null) {
                userERPSystem = (String) Cache.Session.get('UserERPSystem');
                if(userERPSystem == null || userERPSystem == '') {
                    userObj = [select Id,UserLoginCounter__c,CSS_User_MultiLocValues__c,LastLoginDate,UserPreviousLoginDate__c, UserGroup__c,User_Location__c,User_Role__c, UserRoleName__c,Product_Group_Access__c,Work_Group_Name__c,FederationIdentifier,LanguageLocaleKey from user where id=:UserInfo.getUserId() LIMIT 1];
                    css_utility.setSessionVariables(userObj.User_Location__c);
                }
            } else {
                if(workJob !=null && workJob.Creator_Location__c !=null && workJob.Creator_Location__c.trim() !=''){
                    css_utility.setSessionVariables(workJob.Creator_Location__c);
                } else {
                    userObj = [select Id,UserLoginCounter__c,CSS_User_MultiLocValues__c,LastLoginDate,UserPreviousLoginDate__c, UserGroup__c,User_Location__c,User_Role__c, UserRoleName__c,Product_Group_Access__c,Work_Group_Name__c,FederationIdentifier,LanguageLocaleKey from user where id=:UserInfo.getUserId() LIMIT 1];
                    css_utility.setSessionVariables(userObj.User_Location__c);
                }
            }
            System.debug('current1 userERPSystem-->'+Cache.Session.get('UserERPSystem'));


            userERPSystem = (String) Cache.Session.get('UserERPSystem');
            System.debug('current2 userERPSystem-->'+userERPSystem);
            
            if(userObj == null){
                userObj = css_utility.getUserAttributes(Userinfo.getUserId());
            }
             accountlang = css_utility.getLanguage(userObj.LanguageLocaleKey); 
            getQSOLDocs();
            
            //Fetch SP Data Values.
            if(workJob.Id != null && workJob.Territory_Class_Name__c == null) 
                workJob = CG_BL_Intake.fetchSPData(workJob, workJob.creator_location__c, null, workJob.Failure_Date__c, null);
            //Fetch SP Data Values.
            
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCC pageAction method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('OUT CG_CL_IntakeCC-pageAction method...'+ userERPSystem);
    }
    //Page Loading Action.

    public String getfilterCategory() 
    {
        System.debug('********getfilterCategory'+filterCategory );
        return filterCategory;
    }
    public void setfilterCategory(String mfilterCategory) 
    {
        this.filterCategory = mfilterCategory; 
        System.debug('********setfilterCategory'+mfilterCategory);
    }
    public String getfilterCategory2() 
    {
        System.debug('********getfilterCategory2'+filterCategory2 );
        return filterCategory2;
    }
    public void setfilterCategory2(String mfilterCategory2) 
    {
        this.filterCategory2 = mfilterCategory2; 
        System.debug('********setfilterCategory2'+mfilterCategory2);
    }
    public String getfilterCategory3() 
    {
        System.debug('********getfilterCategory3'+filterCategory3);
        return filterCategory3;
    }
    public void setfilterCategory3(String mfilterCategory3) 
    {
        this.filterCategory3 = mfilterCategory3; 
        System.debug('********setfilterCategory3'+mfilterCategory3);
    }
    public String getfilterCategory4() 
    {
        System.debug('********getfilterCategory4'+filterCategory4 );
        return filterCategory4;
    }
    public void setfilterCategory4(String mfilterCategory4) 
    {
        this.filterCategory4 = mfilterCategory4; 
        System.debug('********setfilterCategory4'+mfilterCategory4);
    }
    public String getfilterCategory5() 
    {
        System.debug('********getfilterCategory5'+filterCategory5 );
        return filterCategory5;
    }
    public void setfilterCategory5(String mfilterCategory5) 
    {
        this.filterCategory5 = mfilterCategory5; 
        System.debug('********setfilterCategory5'+mfilterCategory5);
    }

    public String getfilterComplaintType() 
    {
        System.debug('********getfilterComplaintType'+filterComplaintType);
        return filterComplaintType;

    }
    public void setfilterComplaintType(String mfilterComplaintType) 
    {
        this.filterComplaintType = mfilterComplaintType; 
        System.debug('********setfilterComplaintType'+mfilterComplaintType);
    }
    public String getfilterComplaintType2() 
    {
        System.debug('********getfilterComplaintType2'+filterComplaintType2);
        return filterComplaintType2;

    }
    public void setfilterComplaintType2(String mfilterComplaintType2) 
    {
        this.filterComplaintType2 = mfilterComplaintType2; 
        System.debug('********setfilterComplaintType2'+mfilterComplaintType2);
    }
    public String getfilterComplaintType3() 
    {
        System.debug('********getfilterComplaintType3'+filterComplaintType3);
        return filterComplaintType3;

    }
    public void setfilterComplaintType3(String mfilterComplaintType3) 
    {
        this.filterComplaintType3 = mfilterComplaintType3; 
        System.debug('********setfilterComplaintType3'+mfilterComplaintType3);
    }
    public String getfilterComplaintType4() 
    {
        System.debug('********getfilterComplaintType4'+filterComplaintType4);
        return filterComplaintType4;

    }
    public void setfilterComplaintType4(String mfilterComplaintType4) 
    {
        this.filterComplaintType4 = mfilterComplaintType4; 
        System.debug('********setfilterComplaintType4'+mfilterComplaintType4);
    }
    public String getfilterComplaintType5() 
    {
        System.debug('********getfilterComplaintType5'+filterComplaintType5);
        return filterComplaintType5;

    }
    public void setfilterComplaintType5(String mfilterComplaintType5) 
    {
        this.filterComplaintType5 = mfilterComplaintType5; 
        System.debug('********setfilterComplaintType5'+mfilterComplaintType5);
    }

    CSS_WPR_SBL_CatComplaintsListResJSON  resCatCompJSON;
    public List<SelectOption> getCategoryList() {
        List<SelectOption> lstCategory; 
        Set<SelectOption> setCategory;
        try {

            CSS_JobEventTemporary__c[] Categories;

            Categories = [select Reason__c from CSS_JobEventTemporary__c where attribute1__c = 'CategoryComplaintCodes'];
            system.debug('Categories>>>'+Categories);
            string jsonResponse = Categories[0].Reason__c;

            //jsonResponse='{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
            resCatCompJSON = (CSS_WPR_SBL_CatComplaintsListResJSON )JSON.deserialize(jsonResponse ,CSS_WPR_SBL_CatComplaintsListResJSON .class);

            lstCategory = new List<SelectOption>();
            setCategory= new Set<SelectOption>();
            lstCategory.add(new SelectOption('','----None----'));

            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y'){

                        //lstCategory.add(new SelectOption(det.Category,det.Category));
                        setCategory.add(new SelectOption(det.Category,det.Category));

                    }
                }
                lstCategory.addAll(setCategory);
            }

            system.debug('lstCategory>>>'+lstCategory);

            //lstCategory.sort();
        }
        catch(exception e)
        {}
        return lstCategory;
    }


    public List<SelectOption> getComplaintTypeList() {
        List<SelectOption> lstComplaint; 
        try {

            system.debug('filterCategory>>>'+filterCategory);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);

            lstComplaint = new List<SelectOption>();
            lstComplaint.add(new SelectOption('','----None----'));

            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory){
                        lstComplaint.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }

            system.debug('lstComplaint>>>'+lstComplaint);

            lstComplaint.sort();
        }
        catch(exception e)
        {}
        return lstComplaint;
    }

    //Method to get Complaint Type2 values from siebel web service
    public List<SelectOption> getComplaintTypeList2() {
        List<SelectOption> lstComplaint2; 
        try {

            system.debug('filterCategory2>>>'+filterCategory2);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);

            lstComplaint2 = new List<SelectOption>();
            lstComplaint2.add(new SelectOption('','----None----'));

            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory2){
                        lstComplaint2.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }

            system.debug('lstComplaint2>>>'+lstComplaint2);

            lstComplaint2.sort();
        }
        catch(exception e)
        {}
        return lstComplaint2;
    }

    //Method to get Complaint Type3 values from siebel web service
    public List<SelectOption> getComplaintTypeList3() {
        List<SelectOption> lstComplaint3; 
        try {

            system.debug('filterCategory3>>>'+filterCategory3);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);

            lstComplaint3 = new List<SelectOption>();
            lstComplaint3.add(new SelectOption('','----None----'));

            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory3){
                        lstComplaint3.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }

            system.debug('lstComplaint3>>>'+lstComplaint3);

            lstComplaint3.sort();
        }
        catch(exception e)
        {}
        return lstComplaint3;
    }

    //Method to get Complaint Type4 values from siebel web service
    public List<SelectOption> getComplaintTypeList4() {
        List<SelectOption> lstComplaint4; 
        try {

            system.debug('filterCategory4>>>'+filterCategory4);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);

            lstComplaint4 = new List<SelectOption>();
            lstComplaint4.add(new SelectOption('','----None----'));

            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory4){
                        lstComplaint4.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }

            system.debug('lstComplaint4>>>'+lstComplaint4);

            lstComplaint4.sort();
        }
        catch(exception e)
        {}
        return lstComplaint4;
    }

    //Method to get Complaint Type5 values from siebel web service
    public List<SelectOption> getComplaintTypeList5() {
        List<SelectOption> lstComplaint5; 
        try {

            system.debug('filterCategory5>>>'+filterCategory5);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);

            lstComplaint5 = new List<SelectOption>();
            lstComplaint5.add(new SelectOption('','----None----'));

            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory5){
                        lstComplaint5.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }

            system.debug('lstComplaint5>>>'+lstComplaint5);

            lstComplaint5.sort();
        }
        catch(exception e)
        {}
        return lstComplaint5;
    }

//Cancel Functionality.
    public void Cancel() 
    {
        System.debug('B4 entering');
        css_job_order__c worecord= new css_job_order__c();
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        try {
            if (ChkFieldBlank() =='BLANK') 
            {
                //reqBoolean='true';
                 System.debug('*****************************It reaching 1*****************************');
                //return null;
            } 
            else 
            {
                //worecord= saveIntakeCustomer();//Hope we do not require it here.
                //Wid = saveCC(Wid, 'Intake');
                saveCC(Wid, 'Intake');
                worecord.Status__c='Canceled';
                if(Wid== null) {
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
                     System.debug('*****************************It reaching 2*****************************');
                }               
                system.debug('worecord >>>>> ' + worecord);
                /*Wid = worecord.id;
                System.debug('*****************************It reaching 3*****************************');
                PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
                pageRef.setRedirect(true);
                return pageRef;*/
                system.debug('cancelSJWrapperObj1 >>>>> ' + cancelSJWrapperObj1);
                system.debug('worecord >>>>> ' + worecord);
                //Wid = cancelSJWrapperObj1.serviceJob.id;
            }
        } 
        catch(exception e) 
        {
            system.debug('EXCEPTION of CG_CL_IntakeCustomer Cancel method >>> '+e.getMessage() + e.getLineNumber());
            //return null;
        }       
    }

    //Save Functionality.
    public PageReference pgSave() 
    {
        system.debug('IN CG_CL_IntakeCC-pgSave method...');
        system.debug('controllerRef ' + controllerRef);
        system.debug('workJob ' + workJob);
        system.debug('userERPSystem ' + userERPSystem);
        try 
        {
            if (ChkFieldBlank() =='BLANK') 
            {
                return null;
            } else 
            {
                Id sJobId = saveCC(Wid,'INTAKE');
                PageReference pageRef = new pageReference('/apex/CG_IntakeCc?id='+sJobId); 
                pageRef.setRedirect(true);
                System.debug('OUT CG_CL_IntakeCC-pgSave method...');            
                return pageRef;
            }
            return null;            
        } 
        catch(exception e) 
        {
            system.debug('EXCEPTION of CG_CL_IntakeCC pgSave method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }
    }
    
    //Save and Job Closed functionality.
    public PageReference closeSession() 
    {
        System.debug('B4 entering');
        css_job_order__c worecord= new css_job_order__c();
        try {
            if(ChkFieldBlank() =='BLANK') {
                return null;
            } else {
                //worecord= saveIntakeCustomer();//Hope we do not require it here.
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
    }
    
    // Begin Chevron Navigation methods
    public PageReference nvIntakeCustomer(){
        PageReference pageRef;
        system.debug('nvIntakeCustomer before save'+ Wid);
        Wid = saveCC(Wid, 'Intake');
        system.debug('nvIntakeCustomer after save'+ Wid);
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeCustomer'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeCustomer?id='+Wid); 
        }
        return pageRef;
    }

    public PageReference nvIntakeUE(){
        PageReference pageRef;
        Wid = saveCC(Wid, 'Intake');
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeUE'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeUE?id='+Wid); 
        }
        return pageRef;
    }
    public PageReference nvIntakeVH(){
        PageReference pageRef;
        Wid = saveCC(Wid, 'Intake');
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeVH'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeVH?id='+Wid); 
        }
        return pageRef;
    }
    public PageReference nvIntakeWarranty(){
        PageReference pageRef;
        Wid = saveCC(Wid, 'Intake');
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeWarranty'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeWarranty?id='+Wid); 
        }
        return pageRef;
    }
    public PageReference nvIntakeRJ(){
        PageReference pageRef;
        Wid = saveCC(Wid, 'Intake');
        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeRJ'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeRJ?id='+Wid); 
        }
        return pageRef;
    }
    //End Navigation methods

    // exit code popup yes button functionality
    public PageReference redirectPopup(){

        pageReference p = new pageReference('/apex/CSS_Job_Detail?nto=HOME');
        p.setRedirect(true);
        return p;
    }

    public id saveCC(id inpJobId, String status){
        Id JobId;
        try{
            css_job_order__c worecord = new css_job_order__c();

            worecord.Category_Desc__c = filterCategory;
            worecord.Category2_Desc__c = filterCategory2;
            worecord.Category3_Desc__c = filterCategory3;
            worecord.Category4_Desc__c = filterCategory4;
            worecord.Category5_Desc__c = filterCategory5;
            worecord.Complaint_Type_Desc__c = filterComplaintType;
            worecord.Complaint_Type2_Desc__c = filterComplaintType2;
            worecord.Complaint_Type3_Desc__c = filterComplaintType3;
            worecord.Complaint_Type4_Desc__c = filterComplaintType4;
            worecord.Complaint_Type5_Desc__c = filterComplaintType5;
            
            worecord.Preventive_Maintenance__c = workJob.Preventive_Maintenance__c;
            worecord.Expedited_Service__c = workJob.Expedited_Service__c;
            worecord.General_Symptoms__c = workJob.General_Symptoms__c;
            worecord.General_Symptoms__c = workJob.General_Symptoms__c;
            worecord = CG_BL_Intake.mapSPData(workJob, worecord); 
            
            if(inpJobId == null){
                List<CSS_UserLocation__c> lstUserLocations = [SELECT isActive__c,isPrimary__c,UserId__c,Location_Name__c,Location_code__c
                                                              FROM CSS_UserLocation__c
                                                              WHERE UserId__c = : UserInfo.getUserId() AND isActive__c = true and isPrimary__c=true and Location_Source__c != 'ARF'
                                                              ORDER BY Location_Name__c asc limit 1];
                System.debug('lstUserLocations>>>:'+lstUserLocations);
                if(lstUserLocations.size()>0){
                    worecord.jobLocation__c = lstUserLocations.get(0).Location_Name__c;
                    worecord.CSS_Job_Location_Code__c = lstUserLocations.get(0).Location_code__c;
                    //worecord.account__c = CG_BL_Intake.FetchAccountId(worecord.CSS_Job_Location_Code__c);
                }
                worecord.Status__c = status;
            }
            
            worecord.Id=inpJobId;
            upsert worecord;
            JobId = worecord.id;    
            return JobId;

        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeUE pgSave method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }

    }

    public string ChkFieldBlank()
    {
        try{
            //Modified as per story# 64030
            if ( (workJob.General_Symptoms__c == null || workJob.General_Symptoms__c == '') && (workJob.Category__c == null || workJob.Category__c == '') && (workJob.Complaint_Type__c == null || workJob.Complaint_Type__c == '') )
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

     
   public void getQSOLDocs() {

        try{
            lstCAM = new List<CSS_CampTsbTrp__c>();
            lstTRP = new List<CSS_CampTsbTrp__c>();
            lstTSB = new List<CSS_CampTsbTrp__c>();
            lstATC = new List<CSS_CampTsbTrp__c>();
            if(workJob.ESN__c!=null && workJob.ESN__c!=''){
                List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getSiebelQSOLCampaigns(workJob.Id, workJob.ESN__c, accountlang.CSS_QsolLanguage__c, workJob.Service_Model__c, workJob.Failure_Date__c);
                if(campaignsList !=null && campaignsList.size()>0)
                    lstTSB = campaignsList.get(0);
                if(campaignsList !=null && campaignsList.size()>1)
                    lstCAM = campaignsList.get(1);
                if(campaignsList !=null && campaignsList.size()>2)
                    lstTRP = campaignsList.get(2);
                if(campaignsList !=null && campaignsList.size()>3)
                    lstATC = campaignsList.get(3);
                system.debug('campaignsList>>>:'+campaignsList);
            }
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeUE getQSOLDocs method >>> '+e.getMessage() + e.getLineNumber());
        }
    }
}