/*
 * Block comments with details of changes
 */
public class CG_CL_ClaimsJobNotesComp
{

    public string NotesBody {get;set;}
    public boolean updatecorrec{get;set;}
    public list<Note> ClaimNotesList;//GSSC 150
    public List<ClaimsNotesWrapper> WarrantyAdminWrapper {get;set;} 
    //public CG_CL_ClaimsJobNotes mainContr{get;set;}
    public Id cID {get; set;}

    public string URLAC {get;set;}
    public String URLClaimId {get;set;}
    
    public string EditCause {get;set;}
    public String EditComplaint {get;set;}
    public String EditCorrection {get;set;}
    public String EditCoverage {get;set;}

    Transient public list<Note> sortNotes;
    public String notesdesc {
        get;
        set {
            notesdesc = value;
        }
    }
    //Create Method for getting data Like 4c's from claims object as per Document #135259 -By RAJESH
    public CSS_Claims__c ClaimsRec{get; set;}

    public Integer complaintcounter{set;get;}
    public Integer coveragecounter{set;get;}
    public Integer causecounter{set;get;}
    public Integer correctioncounter{set;get;}
    public String jobComplaintModifiedBy{get;set;}
    public String jobCauseModifiedBy{get;set;}
    public String jobCoverageModifiedBy{get;set;}
    public String jobCorrectionModifiedBy{get;set;}
    public String jobComplaintModifiedDate{get;set;}
    public String jobCauseModifiedDate{get;set;}
    public String jobCoverageModifiedDate{get;set;}
    public String jobCorrectionModifiedDate{get;set;}
    public boolean dealerCustomer{get;set;}
    //public css_solution_component__c solComRec{get;set;}
    public List<css_solution_component__c> solComRec{get;set;}
    public string nonSRTnotes{get;set;}
    public list<claimWrapperClass> lstclaimWrapper {get;set;}//GSSC 150
    Map<String, List<ClaimNotes>> claimSubWithNotes;//GSSC 150
    public String claimSubID {get; set;}//GSSC 150
    public boolean sendNotesError{get;set;}//GSSC 150
    
    
    public List<CSS_Claim_Submission__c> claimSubList = new List<CSS_Claim_Submission__c>();
    
    public void mainSOQL(){
        system.debug('**Enter into mainSOQL Method **'); 
        try{
            if(cId != null){
                ClaimsRec = [SELECT Id,Status__c, Dealer_Service_Job__c, PACCAR_Flag__c, PACCAR_Auth_Required__c, Parts_Warranty_Claim_Only__c, Name, CSS_Job__r.Non_SRT_Details__c,EditCause__c,Claims_General_Symptoms__c,Claims_Additional_Comments__c,EditComplaint__c, EditCoverage__c, CSS_Job__c, CSS_Job__r.CreatedDate,
                             JobEditCause__c, JobEditComplaint__c, JobEditCorrection__c, Pending_Authorization__c,JobEditCoverage__c, JobCauseLastModified__c, JobComplaintLastModified__c,
                             JobCorrectionLastModified__c, JobCoverageLastModified__c,PartsRelatedODMMessage__c,Dealer_Service_Job__r.ApplicationCode__c, CreatedById, Additional_Tech2__c, Additional_Tech3__c, Additional_Tech4__c, Additional_Tech5__c,Assigned_To__c,Non_SRT_Details__c,Actual_Technician_Time__c,SP_TERRITORY_CODE__c, CSS_Job__r.General_Symptoms__c,EditCorrection__c,Information_Only_Claim__c,Automotive_App_Flag__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Category2_Desc__c,
                        CSS_Job__r.Complaint_Type2_Desc__c,SRT_FlexTime_Error__c,Dealer_Service_Job__r.Name,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                        CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,ODM_Penalty__c, 
                        Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                        Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c, Customer_Code__c,
                        Claims_Category_Desc__c,Claims_Category2_Desc__c,
                        Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,IsDealerCreatedClaim__c,
                        Claims_Complaint_Type3__c,Location__c,
                        Location_Code__c,ESN__c, createdDate,Region__c,Territory__c, CSS_Job__r.ApplicationCode__c,
                        CoverageResponse__c,Claim_Submitted__c,SP_Country__c,SP_PrimaryOEMCode__c,EngineFamilyName__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                        CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                        TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                        SP_PromotionId__c, Repair_Location__c,CSS_Job__r.Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                        ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                        SP_Group_Name__c, SP_SCMDollarAmt__c, Service_Model__c, SP_SCMDeductiblePercentage__c,Mutual_Exclusive_Message__c,SRT_Olap_Reason_Msg__c,DupAccessCodePercentReqMsg__c,Overlap_Service_Failure_Msg__c,Multi_PSN_Claim__c, Account__r.Type,
                        SP_CMI_SP_EXPIRATION__c, SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,SP_INSHOP_LABOR_RATE__c,SP_FIELD_SERVICE_LABOR_RATE__c,
                        (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,Revision_Before__c,Revision_After__c,
                         Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c,Unit_Type__c,License_Plate_State__c  from CSS_PSNs__r where Primary__c=true Limit 1) FROM CSS_Claims__c 
                             WHERE id= :cId];


                system.debug('**ClaimsRec**'+ClaimsRec);
                system.debug('**ClaimsRecEditComplaint__c**'+ClaimsRec.EditComplaint__c);
                system.debug('**ClaimsRecEditCorrection__c**'+ClaimsRec.EditCorrection__c);
                system.debug('**ClaimsRecEditCoverage__c**'+ClaimsRec.EditCoverage__c);
                system.debug('**ClaimsRecJobEditCause__c**'+ClaimsRec.JobEditCause__c);
                system.debug('**ClaimsRecJobEditComplaint__c**'+ClaimsRec.JobEditComplaint__c);
                system.debug('**ClaimsRecJobEditCorrection__c**'+ClaimsRec.JobEditCorrection__c);
                system.debug('**ClaimsRecJobEditCoverage__c**'+ClaimsRec.JobEditCoverage__c);
                system.debug('**ClaimsRec CSS_Job__c**'+ClaimsRec.CSS_Job__c);
            }
        }
        catch(exception err){
            system.debug('In catch block of mainSOQL with the error '+err.getMessage()+' and in the line '+err.getLineNumber());
        }
    }
    public void soluComp(){
        solComRec = [SELECT Id, Name,Quantity__c,CSS_Claims__c//,(select id,name from CSS_Parts_Options__r)
                     FROM css_solution_component__c 
                     WHERE CSS_Claims__c= :cId and Selected_Component__c = true and type__C NOT IN ('TSB', 'TRP','ATC','Campaign')];

        //system.debug('**ClaimsRecName**'+solComRec.name);
        // ClaimsRec.EditCorrection__c = solComRec.Name;
    }
    public void claimsNotesSOQL(){ 
        if(notesdesc=='1')    
        {
            ClaimNotesList=[SELECT Id,Body,title, CreatedBy.firstname, CreatedDate, CreatedBy.lastname, LastModifiedDate,
                            CreatedById FROM Note WHERE parentId = :cID order by CreatedDate ASC  LIMIT 1000];
            system.debug('sortNotes--->'+sortNotes); 
        }

        else if(notesdesc=='2'){
            ClaimNotesList=[SELECT Id,Body,title, CreatedBy.firstname, CreatedDate, CreatedBy.lastname, LastModifiedDate,
                            CreatedById FROM Note WHERE parentId = :cID order by CreatedDate DESC  LIMIT 1000];
            system.debug('sortNotes--->'+sortNotes);
        }

        if(ClaimNotesList != null && ClaimNotesList.size() > 0) {
            WarrantyAdminWrapper = new List<ClaimsNotesWrapper>();
            for(note notes : ClaimNotesList) {
                ClaimsNotesWrapper cnw = new ClaimsNotesWrapper(notes);
                system.debug('ClaimsNotesWrapper' + cnw);
                WarrantyAdminWrapper.add(cnw);
            }
        }
    }
    //End
    public CG_CL_ClaimsJobNotesComp()
    {
        //system.debug('mainContr'+mainContr);
        cId=ApexPages.CurrentPage().getParameters().get('id');
        system.debug('MyClaimId**'+cID);
        
        URLClaimId = ApexPages.currentPage().getParameters().get('LineItemClaimId');
        system.debug('URLClaimId**'+URLClaimId);

        notesdesc ='1';

        //system.debug('solname'+solComRec.Name);

        // mainSOQL();
        //soluComp();
        try {
            if(cId != null){
                claimsNotesSOQL();
                mainSOQL();
                soluComp();
                String orgtype=css_utility.getOrgType(userinfo.getUserId());
                if (orgtype == 'DLR'){
                    dealerCustomer = true;
                }

                List<String> tempStr = new List<String>();

                if(ClaimsRec != null){  
                     //ClaimsRec.EditComplaint__c = ClaimsRec.Claims_General_Symptoms__c;
                    // ClaimsRec.EditComplaint__c = ClaimsRec.Claims_Additional_Comments__c;
                    if(ClaimsRec.EditComplaint__c!=null && ClaimsRec.EditComplaint__c!='')
                        complaintcounter=4000 - (ClaimsRec.EditComplaint__c).length() ;
                    else{
                        system.debug('compcharelse');
                        complaintcounter=4000;
                    }
                    if(ClaimsRec.EditCoverage__c!=null && ClaimsRec.EditCoverage__c!='')
                        coveragecounter=4000 - (ClaimsRec.EditCoverage__c).length() ;
                    else{
                        coveragecounter=4000;
                    }
                    if(ClaimsRec.EditCause__c!=null && ClaimsRec.EditCause__c!='')
                        causecounter=4000 - (ClaimsRec.EditCause__c).length() ;
                    else{
                        causecounter=4000;
                    }
                    if(ClaimsRec.EditCorrection__c!=null && ClaimsRec.EditCorrection__c!='')
                        correctioncounter=4000 - (ClaimsRec.EditCorrection__c).length() ;
                    else{
                        correctioncounter=4000;
                    }
                }
                else{
                    system.debug('entered into else***');
                    if(ClaimsRec.JobComplaintLastModified__c != null && ClaimsRec.JobComplaintLastModified__c != ''){
                        tempStr = ClaimsRec.JobComplaintLastModified__c.split(';;');
                        jobComplaintModifiedBy = tempStr[0];
                        jobComplaintModifiedDate = datetime.valueof(tempStr[1]).format('dd MMM YYYY hh:mm a z');
                        jobComplaintModifiedDate = jobComplaintModifiedDate.toUpperCase();
                    }
                    if(ClaimsRec.JobCauseLastModified__c != null && ClaimsRec.JobCauseLastModified__c != ''){
                        tempStr = new List<String>();
                        tempStr = ClaimsRec.JobCauseLastModified__c.split(';;');
                        jobCauseModifiedBy = tempStr[0];
                        jobCauseModifiedDate = datetime.valueof(tempStr[1]).format('dd MMM YYYY hh:mm a z');
                        jobCauseModifiedDate = jobCauseModifiedDate.toUpperCase();
                    }
                    if(ClaimsRec.JobCoverageLastModified__c != null && ClaimsRec.JobCoverageLastModified__c != ''){
                        tempStr = new List<String>();
                        tempStr = ClaimsRec.JobCoverageLastModified__c.split(';;');
                        jobCoverageModifiedBy = tempStr[0];
                        jobCoverageModifiedDate = datetime.valueof(tempStr[1]).format('dd MMM YYYY hh:mm a z');
                        jobCoverageModifiedDate = jobCoverageModifiedDate.toUpperCase();
                    }
                    if(ClaimsRec.JobCorrectionLastModified__c != null && ClaimsRec.JobCorrectionLastModified__c != ''){
                        tempStr = new List<String>();
                        tempStr = ClaimsRec.JobCorrectionLastModified__c.split(';;');
                        jobCorrectionModifiedBy = tempStr[0];
                        jobCorrectionModifiedDate = datetime.valueof(tempStr[1]).format('dd MMM YYYY hh:mm a z');
                        jobCorrectionModifiedDate = jobCorrectionModifiedDate.toUpperCase();
                    }
                }

                //STORY -145260 Non-SRT Details START     
                List<CSS_SRT__c> nonSRTList = new List<CSS_SRT__c>();
                nonSRTnotes ='';
                for(CSS_SRT__c srt : [SELECT id,SRT_Notes__c FROM CSS_SRT__c 
                                      WHERE css_claims__c=:cid AND Type__c='99Time' 
                                      AND Account_Code_Description__c != null 
                                      AND Fail_Code_Description__c != null ]){


                    if(srt.SRT_Notes__c!=null && srt.SRT_Notes__c!= ''){ 
                        nonSRTnotes += srt.SRT_Notes__c + '<br/>';   

                    }    

                }
                system.debug('noSRTnotes = '+nonSRTnotes);
                //STORY -145260 Non-SRT Details END 
                //verifySubmitpgAction();  // Anvesh added for POC
                
                //GSSC 150
                fetchClaimRecords();
                //GSSC 150
            }
        }
        catch(Exception e)  {
            system.debug('in the exception of constructor '+e.getMessage() + ' at the line '+e.getLineNumber());
        }
    }
    //Create Methods for getting data Like 4c's from claims object as per Document #135259 -By RAJESH
    public void saveComplaint(){
        try{
            system.debug('Inside Save Complaint--'+ClaimsRec.EditComplaint__c); 
            system.debug('Inside Save Complaint--'+ClaimsRec.Claims_General_Symptoms__c); 
            CSS_Claims__c clacord= new CSS_Claims__c();
            clacord.EditComplaint__c=ClaimsRec.EditComplaint__c;  
            if(ClaimsRec.CSS_Job__c == null && ClaimsRec.Dealer_Service_Job__c == null)
                clacord.Claims_General_Symptoms__c = ClaimsRec.Claims_General_Symptoms__c;
            clacord.id=ClaimsRec.id;
            update clacord;
        }
        catch(exception err){
            system.debug('In catch block of saveComplaint with the error '+err.getMessage() +' and in the line '+err.getLineNumber());
        }
    }
    public void saveCorrection(){

        try{
            CSS_Claims__c clacord= new CSS_Claims__c();
            system.debug('ClaimsRec.EditCorrection__c'+ClaimsRec.EditCorrection__c);
            clacord.EditCorrection__c=ClaimsRec.EditCorrection__c;            
            clacord.id=ClaimsRec.id;
            update clacord;
            system.debug('clacord'+clacord);
        }
        catch(exception err){
            system.debug('In catch block of saveCorrection with the error '+err.getMessage() +' and in the line '+err.getLineNumber());
        }

    }
    public void saveCause(){
        try{
            CSS_Claims__c clacord= new CSS_Claims__c();
            clacord.EditCause__c=ClaimsRec.EditCause__c;
            clacord.id=ClaimsRec.id;
            update clacord;
        }
        catch(exception err){
            system.debug('In catch block of saveCause with the error '+err.getMessage() +' and in the line '+err.getLineNumber());
        }
    }
    public void saveCoverage(){
        try{
            CSS_Claims__c clacord= new CSS_Claims__c();
            clacord.EditCoverage__c = ClaimsRec.EditCoverage__c;
            clacord.id=ClaimsRec.id;
            update clacord;
        }
        catch(exception err){
            system.debug('In catch block of saveCoverage with the error '+err.getMessage() +' and in the line '+err.getLineNumber());
        }
    }

    //End

    public class ClaimsNotesWrapper{
        public Id nId {get; set;}
        public string nBody {get; set;}
        public string nTitle {get; set;}
        public string nfrstName {get; set;}
        public string nlastName {get; set;}
        public string nLastModified {get; set;}
        public string nCreatedId {get; set;}    

        public ClaimsNotesWrapper(Note n){
            this.nId=n.id;

            if(n.body!='' && n.body!=null){
                //this.nBody = n.body.replace('\n', '');
                this.nBody= n.Body.replaceall('\n', '<br/>');
                //System.debug('Comment1*******'+Comment1);
            }else{
                this.nBody = ' ';
            }
            //this.nBody=string.valueof(n.body);
            this.nTitle=n.Title;
            this.nfrstName=n.CreatedBy.firstname;
            this.nlastName=n.CreatedBy.lastname;
            this.nLastModified= (n.CreatedDate.format('dd MMM YYYY hh:mm a z')).toUpperCase();
            this.nCreatedId=n.CreatedById;
        } 
    }

    public List<SelectOption> getSortvalues() {
        List<SelectOption> SortList = new List<SelectOption>(); 

        SortList.add(new SelectOption('1',system.Label.css_Oldest_To_Newest));
        SortList.add(new SelectOption('2',system.Label.css_Newest_To_Oldest));

        return SortList;
    }
    public PageReference pageReferenceMethod()
    {
        if(CID!=null)
            return new PageReference('/apex/CG_ClaimsJobNotes?id='+cID);
        else
            return new PageReference('/apex/CG_ClaimsJobNotes');

    }

    /*public void saveNotes(){

        try{
            system.debug('NotesBody '+NotesBody);
            Note nt = new Note();
            nt.ParentId = cID;
            nt.title = 'Claims';//changethe value later
            nt.Body = NotesBody;
            insert nt;
            system.debug('NotesBody'+NotesBody);
            claimsNotesSOQL();            
        }catch(exception e){
            system.debug('Exception in Save'+e.getMessage()+' '+e.getLineNumber());
        }
    }*/


    /*// Anvesh added for POC below code 


    //public  class CG_CL_ClaimsVS {

    //Global Variables.
    // public CG_CL_ClaimsVS controllerRef {set;get;}
    //public Id cId{get;set;}
    //  public list<Note> ClaimNotesList {get;set;}
    //public CSS_Claims__c claimsRec {set;get;}
    public List<CSS_PSN__c>lstPSN{get;set;}
    public CSS_Claim_Submission__c claimSubRec {set;get;}
    public Boolean psncheck {get;set;}
    public List<CSS_Solution_Component__c> solComps;
    public boolean checkAccountCode{get; set;}
    //public CSS_Solution_Component__c claimsSCList{get;set;}
    public string warrantyAuthFlag {get; set;}
    public list<CSS_Claim_Submission__c> lstsubmissionRecord {get; set;}    
    public list<claimWrapperClass> lstclaimWrapper {get;set;}

    Transient public list<CSS_Solution_Component__c> claimsSCList = new list<CSS_Solution_Component__c>();
    Transient public list<CSS_Parts_Options__c> claimsPOList = new list<CSS_Parts_Options__c>();
    Transient public list<CSS_SRT__c> claimsSRTList = new list<CSS_SRT__c>();
    Transient public CSS_Claims__c Claims = new CSS_Claims__c();

    public Map<string, list<CSS_Solution_Component__c>> SCAccountCodeMap = new Map<string, list<CSS_Solution_Component__c>>();//Account code, Solution component Records.
    public Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap = new Map<string, list<CSS_Parts_Options__c>>();//Account code+Fail Code, PART OPTION Records.
    public Map<string, list<CSS_SRT__c>> SRTAccountCodeMap = new Map<string, list<CSS_SRT__c>>();//Account code+Fail Code, PART OPTION Records.
    public List<String> partsWarranty = new List<String>();
    public List<String> fieldActionAcountcodeList = new List<String>();
    public Map<String, String> accCodeCoverageType{get;set;}
    public String ACcodeWrap {get; set;}

    //public decimal totalUSD{get;set;}
    public static final Integer Claim_Fork = 1000;//Declaring a constant variable with infinity value
    public Boolean isPartsCovLimitExceed{get;set;}

    public List<CSS_Solution_Component__c> solCompsPSNCheck;
    //Constructor.


    //Fetching Claims Record
    public void fetchClaimRecords(){


        try {
            claimsRec =[Select Id, PartsRelatedODMMessage__c,FieldActionWebServiceResult__c,EditCoverage__c,Additional_Tech1__c, Dealer_Service_Job__c, Dealer_Service_Job__r.ApplicationCode__c, CreatedById, Additional_Tech2__c, Additional_Tech3__c, Additional_Tech4__c, Additional_Tech5__c, Additional_Tech6__c, Additional_Tech7__c, Additional_Tech8__c, Additional_Tech9__c,EditCause__c,EditComplaint__c,Assigned_To__c,Non_SRT_Details__c,Actual_Technician_Time__c,SP_TERRITORY_CODE__c, CSS_Job__r.General_Symptoms__c,License_Plate_State_Error_message__c,EditCorrection__c,Information_Only_Claim__c,Automotive_App_Flag__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                        CSS_Job__r.Complaint_Type2_Desc__c,SRT_FlexTime_Error__c,Dealer_Service_Job__r.Name,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                        CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c, ODM_Penalty__c, 
                        Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                        Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c, Customer_Code__c,
                        Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                        Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,IsDealerCreatedClaim__c,
                        Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                        Location_Code__c,ProductApplicationCode__c,Account__r.RSS_RESP_BRANCH_CODE__c,Account__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c, CSS_Job__r.ApplicationCode__c,
                        CoverageResponse__c,Claim_Submitted__c,SP_Country__c,SP_PrimaryOEMCode__c,EngineFamilyName__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                        CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                        TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                        SP_PromotionId__c, Repair_Location__c,CSS_Job__r.Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                        ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                        SP_Group_Name__c, SP_SCMDollarAmt__c, Service_Model__c, SP_WarrantyTrainingStatus__c,Pending_Authorization__c,SP_State__c,SP_SCMDeductiblePercentage__c,Mutual_Exclusive_Message__c,SRT_Olap_Reason_Msg__c,DupAccessCodePercentReqMsg__c,Overlap_Service_Failure_Msg__c,Multi_PSN_Claim__c, Account__r.Type,
                        SP_CMI_SP_EXPIRATION__c, SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,SP_INSHOP_LABOR_RATE__c,SP_FIELD_SERVICE_LABOR_RATE__c,Account__r.ERP_System__c, Total_PSN_Count__c,PACCAR_Flag__c,
                        (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,Revision_Before__c,Revision_After__c,
                         Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c,Unit_Type__c,License_Plate_State__c  from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id= :cId];  


        } catch(Exception ex) {
            system.debug('in the exception of fetchClaimRecords Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }
    }


    //ClaimsVS page design is based on the account code and failcode combination.
    public void fetchAccountFailCodeCombo(){
        try {
            claimsSCList = [select Id, Name,ODM_Status__c,Parts_Warranty__c,RoadRelay_Warranty__c,System_Code__c,Component_Code__c,Failure_Mode__c,AccountCode__c,
                            Pay_Code__c,CertificateNumber__c,WarrantyId__c,Approval_Code__c,CSS_CoverageType__c,CoveredLaborHrs__c,
                            CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredTowingMiles__c,CoveredTravelLabor__c,
                            CoveredTravelMiles__c,DeductibleAmount__c,Authorization_Number__c,CampaignLaborPercentage__c, Claim_Type__c, Selected_Claim_Type__c,
                            CampaignOCPercentage__c,CSS_Primary_Failure__c,CSS_Failure_Sequence_Number__c,CampaignPartsPercentage__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,
                            CSS_Account_Formula__c, Fail_Code__c,FailCode_Formula__c,Campaign_Description__c,Type__c, In_Shop_SRT_Limit_Flag__c,
                            Part_Warranty_Start_Date__c, Failure_Point__c, Customer_Take_Possession__c, Campaign_Start_Date__c, Engine_Family_Code__c, 
                            Campaign_End_Date__c, Status__c, CoveredTravelBaseFareAmt__c, Failure_Date__c, Failure_Measure__c,Component_Id__c,Fault_Code__c
                            from CSS_Solution_Component__c
                            where CSS_Claims__c =: cId AND CSS_Account_Formula__c != null AND Fail_Code__c != null AND Selected_Component__c = true order by CSS_Failure_Sequence_Number__c asc];//AND Type__c = null
            system.debug('claimsSCList.size() ' + claimsSCList.size());
            system.debug('claimsSCList() ' + claimsSCList);
            //Map of Account code and Solution component
            if(claimsSCList.size()>0){
                for(CSS_Solution_Component__c sctemp : claimsSCList) {

                    if(SCAccountCodeMap.containsKey(sctemp.CSS_Account_Formula__c)){
                        List<CSS_Solution_Component__c> fclist = SCAccountCodeMap.get(sctemp.CSS_Account_Formula__c);
                        fclist.add(sctemp);
                        SCAccountCodeMap.put(sctemp.CSS_Account_Formula__c, fclist);
                    } else {
                        SCAccountCodeMap.put(sctemp.CSS_Account_Formula__c, new List<CSS_Solution_Component__c> { sctemp });
                    }
                }
            }
            system.debug('SCAccountCodeMap() ' + SCAccountCodeMap);


        } catch(Exception ex) {
            system.debug('in the exception of fetchAccountFailCodeCombo Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }    
    }

    //Generate Claim Wrapper with associated Failures,parts & SRTs. 
    //Called in PageACtions
    public void generateClaimSubmissionRecords(){
        system.debug('Inside generateClaimSubmissionRecord Method***');
        lstclaimWrapper= new List<claimWrapperClass>();

        integer accaccordioncount =0;
        integer accountcount =1;
        boolean isPartWarranty = false;
        string accountTwoDigit = '';

        try {
            system.debug(' SCAccountCodeMap ' + SCAccountCodeMap);
            for(string accountcode : SCAccountCodeMap.keyset()){
                system.debug('accountcode ' + accountcode);

                //Get the 2 digits of account code
                if(accountcode != null && accountcode != '' && accountcode.length() >= 2)
                    accountTwoDigit = accountcode.substring(accountcode.length()-2, accountcode.length());
                system.debug('accountTwoDigit ' + accountTwoDigit);

                // Map of Fail Code and Solution component
                set<string> uniqueFailcodeSet = new set<string>();
                map<string, List<CSS_Solution_Component__c>> uniqueFailCodeMap = new map<string, List<CSS_Solution_Component__c>>();
                String FCode;

                List<CSS_Solution_Component__c> fclist = SCAccountCodeMap.get(accountcode);
                system.debug('fclist ' + fclist);

                for(CSS_Solution_Component__c CSSsc : fclist) {
                    uniqueFailcodeSet.add(CSSsc.System_Code__c+CSSsc.Component_Code__c);
                    system.debug('uniqueFailcodeSet' + uniqueFailcodeSet);
                    if(CSSsc.type__c == 'CAMPAIGN' || CSSsc.type__c == 'ATC' || CSSsc.type__c == 'TRP'){
                        FCode=CSSsc.System_Code__c+CSSsc.Component_Code__c+CSSsc.Failure_Mode__c;
                    }
                    else{
                        FCode=CSSsc.System_Code__c+CSSsc.Component_Code__c;
                    }
                    if(uniqueFailCodeMap.containsKey(FCode)) { //if(uniqueFailCodeMap.containsKey(CSSsc.Fail_Code__c)) 
                        List<CSS_Solution_Component__c> fclistSC = uniqueFailCodeMap.get(FCode);
                        system.debug('fclistSC' + fclistSC);
                        fclistSC.add(CSSsc);
                        uniqueFailCodeMap.put(FCode, fclistSC);
                    } else {
                        system.debug('NEW One');
                        uniqueFailCodeMap.put(FCode, new List<CSS_Solution_Component__c> { CSSsc });
                    }
                }
                system.debug(' uniqueFailCodeMap ' + uniqueFailCodeMap);

                //Find Accordian Count.
                integer fcI = uniqueFailCodeMap.size();
                if(accountTwoDigit!=null && 
                   ((partsWarranty !=null && partsWarranty.contains(accountTwoDigit)) || (fieldActionAcountcodeList !=null && fieldActionAcountcodeList.contains(accountTwoDigit)))) {
                    system.debug('fcI() partsWarranty ' + partsWarranty +'<<<accountTwoDigit >>>'+accountTwoDigit);  
                    accaccordioncount += fcI;
                } else {
                    if(Math.Mod(fcI,Claim_Fork)==0)
                        accaccordioncount+= fcI/Claim_Fork;
                    else
                        accaccordioncount+= fcI/Claim_Fork+1; 
                }
                system.debug('fcI() ' + fcI +'<<<accaccordioncount >>>'+accaccordioncount);  


                integer failcodecount=0;
                system.debug('shan accaccordioncount'+accaccordioncount);
                //associate 3 failcode for any accountcode
                for(integer j=accountcount;j<=accaccordioncount;j++){
                    system.debug('shan accountcount'+accountcount+'accaccordioncount'+accaccordioncount);
                    decimal totalsrtTime=0.0;
                    decimal totalfasrtTime=0.0;
                    
                    string nonSRTtimeNotes = '';
                    string OverlapNotes = '';
                    String claimids=claimsRec.name;
                    if(accaccordioncount<=9)
                        claimids +='-0'+String.valueof(j);
                    else
                        claimids +='-'+String.valueof(j);  
                    accountcount++;

                    List<String> lstfailcodesString = new List<String>();
                    for(string failcodesString : uniqueFailCodeMap.keyset()) {
                        lstfailcodesString.add(failcodesString);
                    }
                    system.debug('lstfailcodesString'+lstfailcodesString); 

                    //Passing each Fail code to the wrapper.
                    for(Integer i =failcodecount; i<lstfailcodesString.size(); i++) {
                        system.debug('shan lstfailcodesString'+i); 
                        failcodecount++;

                        set<string> duplicatePartIdSet = new set<string>();
                        List<CSS_Solution_Component__c> fclistSC = uniqueFailCodeMap.get(lstfailcodesString[i]);
                        system.debug('fclistSC'+fclistSC); 

                        for(CSS_Solution_Component__c csssc : fclistSC) {
                            system.debug('****insidecsssc**'+fclistSC.size());
                            string accountcodeTD = '';
                            //  failureWrapperClass failWrapperTemp = new failureWrapperClass('','','','','','','','','','','','','','','','','','','','','','','','','','','','','',null,'',null);
                            if(csssc.AccountCode__c != null && csssc.AccountCode__c.length() > 2)
                                accountcodeTD = csssc.AccountCode__c.RIGHT(2);

                        } 
                        //Once it reaches 3 then brake the loop.
                        if(!partsWarranty.contains(accountTwoDigit) && !fieldActionAcountcodeList.contains(accountTwoDigit) && Math.Mod(failcodecount,Claim_Fork)==0){
                            system.debug('partsWarranty1111'+partsWarranty+'accountTwoDigit1111'+accountTwoDigit + 'fieldActionAcountcodeList >> ' + fieldActionAcountcodeList);
                            break;
                        }
                        if(partsWarranty.contains(accountTwoDigit) || fieldActionAcountcodeList.contains(accountTwoDigit)) {
                            system.debug('partsWarranty222'+partsWarranty+'accountTwoDigit222'+accountTwoDigit + 'fieldActionAcountcodeList >> '+ fieldActionAcountcodeList);
                            break;

                        }
                    }
                    claimWrapperClass claim = new claimWrapperClass();
                    claim.accountcode=accountcode;
                    claim.claimid=claimids;
                    lstclaimWrapper.add(claim);

                }
               
                
                system.debug('lstclaimWrapper ' + lstclaimWrapper);   
                system.debug('lstclaimWrapper().SIZE ' + lstclaimWrapper.size()); 

            }

            //ClaimsSubmissionList = lstsubmissionRecord;
        } catch(Exception ex) {
            system.debug('in the exception of fetchAccountFailCodeCombo Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage() + ex.getCause());
        }              
    }

    //Page Actions.
    public void verifySubmitpgAction() {
        try {
           fetchClaimRecords();
            fetchAccountFailCodeCombo();
            generateClaimSubmissionRecords();

        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsVS verifySubmitpgAction >>> '+e.getMessage() + ' LINE NO: ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }

    //Wrapper Classes.
    public class claimWrapperClass{
        public String accountcode {get;set;}
        public String claimid {get;set;}

        public claimWrapperClass(){}
    }

    // Anvesh added above code for POC end */ 

    //GSSC 150 starts
    
    public void fetchClaimRecords() {
        try {
            
            Set<String> siebelClaimNoSet = new Set<String>();
            lstclaimWrapper= new List<claimWrapperClass>();
            claimSubList = [select Id,Name,Individual_Claim_Id__c, Siebel_Claim_Number__c,Status__c, Claim_Number__c,  Account_Code__c,isPendingResponse__c from CSS_Claim_Submission__c where CSS_Claims__c = :cId];
            claimSubWithNotes = new Map<String, List<ClaimNotes>>();
            system.debug('***size88'+claimSubList.size()+'**claimSubList**'+claimSubList);
            if(claimSubList != null && claimSubList.size()>0){
                for(CSS_Claim_Submission__c cs: claimSubList){
                    system.debug('**insideIf1**');
                    siebelClaimNoSet.add(cs.Siebel_Claim_Number__c);
                    
                    for(Note notes: [SELECT Id,Body,title,parentId, CreatedBy.firstname, CreatedDate,
                                 CreatedBy.lastname, LastModifiedDate,CreatedById 
                                 FROM Note WHERE parentId =: cs.id 
                                 order by CreatedDate DESC  LIMIT 1000]){
                        
                        system.debug('**notes**'+notes);
                        List<String> lstStr = new List<String>();
                        if(notes.Body != null){
                            if(notes.Body.contains(';;'))
                                lstStr = notes.Body.split(';;');
                                system.debug('lstStr'+lstStr);
                            if(!claimSubWithNotes.containsKey(cs.Individual_Claim_Id__c)){
                                system.debug('**insideIf2**');
                                ClaimNotes temp  = new ClaimNotes();
                                if(lstStr != null && lstStr.size()>0){
                                    temp.noteBody = lstStr[3];
                                    temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(lstStr[1]));
                                }
                                else{
                                    temp.noteBody = notes.Body;
                                    temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(notes.CreatedDate));
                                }
                                temp.noteTitle = notes.Title;
                                system.debug('***temp***'+temp);
                                claimSubWithNotes.put(cs.Individual_Claim_Id__c,new List<ClaimNotes>{temp});
                            }
                            else{
                                system.debug('**insideIf3**');
                                ClaimNotes temp  = new ClaimNotes();
                                temp.noteTitle = notes.Title;
                                if(lstStr != null && lstStr.size()>0){
                                    temp.noteBody = lstStr[3];
                                    temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(lstStr[1]));
                                }
                                else{
                                    temp.noteBody = notes.Body;
                                    temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(notes.CreatedDate));
                                }
                                claimSubWithNotes.get(cs.Individual_Claim_Id__c).add(temp);
                            }
                                
                        }
                    }
                }
            }
            system.debug('****claimSubWithNotes***'+claimSubWithNotes);
            if(siebelClaimNoSet != null && siebelClaimNoSet.size()>0){
                for(CSS_Claim_Submission__c cs: claimSubList){
                    claimWrapperClass claim = new claimWrapperClass();
                    claim.accountcode = cs.Account_Code__c;
                    claim.claimId = cs.Individual_Claim_Id__c;
                    claim.claimStatus = cs.Status__c;
                    claim.claimSubNotes = claimSubWithNotes.get(cs.Individual_Claim_Id__c);
                    claim.pendingSPResponse = cs.isPendingResponse__c;
                        lstclaimWrapper.add(claim);
                }
            }
            system.debug('lstclaimWrapper****'+lstclaimWrapper);

        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsJobNotes fetchClaimsRecords >>> '+e.getMessage() + ' LINE NO: ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }
    
    public void saveSPResponse(){
            
        try{
            system.debug('claimSubID****'+claimSubID);
            CG_SendNotesSiebelResponseWrapper sendnotesdetailsRes = new CG_SendNotesSiebelResponseWrapper();
            
            List<Note> notesList = new List<Note>();
           
            List<CSS_Claim_Submission__c> clSubUpdateList = new List<CSS_Claim_Submission__c>();
            Id claimsubmissionId;
            system.debug('listdata'+lstclaimWrapper);
            if(lstclaimWrapper!=null && lstclaimWrapper.size()>0){
                for(claimWrapperClass c :lstclaimWrapper) {
                    for(CSS_Claim_Submission__c cs : [select Id,Name,Individual_Claim_Id__c,isPendingResponse__c from CSS_Claim_Submission__c where Individual_Claim_Id__c =: claimSubID]){
                        system.debug('claimId****'+c.claimId);
                        system.debug('Individual_Claim_Id__c****'+cs.Individual_Claim_Id__c);
                        if(c.claimId == cs.Individual_Claim_Id__c){
                            system.debug('insideIf****');
                            claimsubmissionId = cs.Id;
                            Note nt = new Note();
                            nt.ParentId = cs.Id;
                            nt.title = 'SP Update';
                            nt.Body = c.SPResponse;
                            notesList.add(nt);
                            cs.isPendingResponse__c = false;
                            clSubUpdateList.add(cs);
                        }
                    }
                           
                }
            }
            
            if(notesList!=null && notesList.size()>0){
                sendnotesdetailsRes = CSS_FN_SIEBEL.sendnotesdetails(claimSubID,notesList);
                system.debug('sendnotesdetailsRes***'+sendnotesdetailsRes);
                if(sendnotesdetailsRes == null || (sendnotesdetailsRes != null && sendnotesdetailsRes.Header.Status != 'Success')) { 
                    system.debug('insideError***');
                    sendNotesError = true;
                }
                else{
                    sendNotesError = false; // karthik G added for error is not going and not saving even service is up
                }
                
            }
            
            if(notesList!=null && notesList.size()>0 && sendNotesError != true) {
                for(Note n : notesList)
                    n.title = 'Service Provider Response';
                  
              insert notesList;              
            }
         
                
            if(clSubUpdateList != null && clSubUpdateList.size()>0 && sendNotesError != true){
                update clSubUpdateList;
            }
                
            //Call sendNotesWebservice
            /*List<Note> finalNoteList = new List<Note>();
            List<ClaimNotes> claimNotesList = new List<ClaimNotes>();
            system.debug('claimsubmissionId****'+claimsubmissionId);
            finalNoteList = [SELECT Id,Body,title,parentId from note where parentId =:claimsubmissionId];
            if(finalNoteList != null && finalNoteList.size()>0){
                for(Note n : finalNoteList){
                    ClaimNotes cn = new ClaimNotes();
                    cn.noteId = n.Id;
                    cn.noteBody = n.Body;
                    cn.noteTitle = n.Title;
                    cn.parentId = n.parentId;
                    claimNotesList.add(cn);
                }
            }
            string jsonString = JSON.serialize(claimNotesList);
            system.debug('jsonString***'+jsonString);
            if(finalNoteList != null){
                //CSS_FN_SIEBEL.sendnotesdetails(claimSubID,jsonString);
            }*/
            system.debug('sendNotesError***'+sendNotesError);
            fetchClaimRecords();
            system.debug('sendNotesError***'+sendNotesError);
                       
        }catch(exception e){
            system.debug('Exception in Save'+e.getMessage()+' '+e.getLineNumber());
        }
    }
   
    public class claimWrapperClass{
        public String accountcode {get;set;}
        public String claimid {get;set;}
        public String claimStatus {get;set;}
        public List<ClaimNotes> claimSubNotes{get;set;}
        public String SPResponse {get;set;}
        public Boolean pendingSPResponse {get;set;}
     
        
    }
    
    //Wrapper for Claim Submission Notes
    public Class ClaimNotes{
        public Id noteId; 
        public String lastSaveDate{get;set;}
        public String noteBody{get;set;}
        public String noteTitle{get;set;}
        public Id parentId;
    }
}