/**********************************************************************
    Name:CG_CL_ClaimsIntake
    Copyright Â© 2018  Cummins
    ======================================================
    ======================================================
    Purpose:                                                            
    -------  
    We are using this Page Controller for Claims Overview Chevron.
    ======================================================
    ======================================================
    History                                                            
    -------                                                            
    VERSION  AUTHOR            DATE                DETAIL                                 
    1.0 - Anvesh Reddy      01/22/2018      Added Navigations to other chevrons   
    1.0 - Surender M        02/05/2018      Added Create Claims and implementented U&E functionalities
    2.0 - Arpita Sarangee   6/04/2018       Added code for calling getserviceProdviderDataClaims method (137880)
    3.0 - Rajesh Pasupuleti 29/05/2018      Added ERP System field in Query as per 145403 Simpsons story
    3.1 - Rajesh Pasupuleti 06/06/2018      Added Query code on claim submission object as per SImpsons Story #144554 
    3.2 - Rajesh Pasupuleti 12/07/2018      Added code for getting erp sytem field from account object basend user location when we don't have a claim
    ***********************************************************************/
public class CG_CL_ClaimsIntake
{
    public CG_CL_ClaimsIntake controllerRef{set;get;}
    public Id cId{get;set;}
    public CSS_Claims__c claimsRec{get;set;}
    public CSS_PSN__c psnRec{get;set;}
    public Boolean secondaryPSN{get;set;}
    public Boolean isWarrCustomer{get;set;}
    public List<CSS_PSN__c> lstPsnRec;
    public CSS_Claim_Submission__c claSubRec{set;get;}
    Public Boolean Information{get;set;}
    public Boolean prodcodeErrormessage {get;set;}
    public Id PsnId{get;set;}
    public String AssignedTo{get;set;}
    public String AdditionalTech1{get;set;}
    public String AdditionalTech2{get;set;}
    public String AdditionalTech3{get;set;}
    public String AdditionalTech4{get;set;}
    public String AdditionalTech5{get;set;}
    public String AdditionalTech6{get;set;}
    public String AdditionalTech7{get;set;}
    public String AdditionalTech8{get;set;}
    public String AdditionalTech9{get;set;}

    public Map<String,String> mapDescriptionToCode;
    public String filterApplication {get;set;}
    public String filterMake{get;set;}
    public String filterModel{get;set;}
    public String filterUnitType{get;set;}
    public String mil_measure{set;get;}
    public String filterCountry {get;set;}
    public String filterState {get;set;}
    public string strCntry{get;set;}
    public string strCntryState{get;set;}
    public string strRepairloc{get;set;}
    public string EmailAddress {get;set;}
    public string EmailAddress1 {get;set;}
    public Boolean justficationErrMsg {get;set;}
    public Boolean wsdReadOnlyFromContr {get;set;}
    public boolean showErrorPopup{get;set;}
    public String pageName;
    public Boolean psncheck {get;set;}
    public User userObj{get; set;}
    public CSS_accountLanguage__c accountlang{get; set;}
    public String region{get;set;}
    public string datebyLocaleValue {get;set;}
    public String FormattedDate {get; set;}
    public Boolean ExternReturnDateFlag{get; set;}
    public string mainFlag{get; set;}
    public Decimal totaldigSRT{get;set;}
    public Decimal totalrepSRT{get;set;}
    public Decimal totalcampSRT{get;set;}
    public Decimal totaltrpSRT{get;set;}
    public Decimal totalatcSRT{get;set;}
    public Decimal totalNON{get;set;}
    public Decimal totalSRT{get;set;}
    public Decimal actual{get;set;}
    public DateTime repaircomple{get;set;}
    public Date tempFailureDate;
    public string LocationManualClaims {get; set;}
    public string repairCompdate {get;set;}
    public string servDate {get;set;}
    public Boolean isDealer{get; set;}
    public Boolean checkValidEmail{get; set;}
    public Boolean MultipsncheckboxEnable{get;set;}
    public list<CG_ODM_ResJSONParser.messages> ODMDisplayMsgs{get;set;}
    public List<CSS_Solution_Component__c> FailuresList;
    public List<CSS_Solution_Component__c> updateFailuresList;
    public List<CSS_Parts_Options__c> updatepartslist;
    public List<CSS_SRT__c> updatesrtlist;
    public List<CSS_Parts_Options__c> octtmllist;
    public List<CSS_Parts_Options__c> updateocttmllist;
    public List<CSS_SRT__c> adminsrtlist;
    public List<CSS_SRT__c> updateadminsrtlist;
    public String existingPSN{get;set;}
    public String accType{get;set;}

    public string idNotNullLocationManualClaims {get; set;}
    Public List<CSS_Claim_Submission__c> claimSubmissionList = new List<CSS_Claim_Submission__c>();
    //Created by Rajesh Narra on 7-02-2018 to save the claim data based if the claim object doesn't have the claim submission information

    public CSS_Claims__c claimNewRecUpd{get;set;}
    Transient public List<CSS_CampTsbTrp__c> lstCAM {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTRP {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTSB {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstATC {get; set;}
    public Account acc{get; set;}
    Transient public CSS_GetServiceProviderResponse spDataWrapper {get; set;}
    public List<CSS_Solution_Component__c> FList;
    public List<CSS_Solution_Component__c> FailList;
    public boolean checkBIS{get; set;}
    public List<CSS_Solution_Component__c> solComps;
    List<Account> accnt;
    public boolean checkAccountCode{get; set;}
    //161401
    public boolean dealerUser{Get; set;}
    public boolean prodCert;
    public boolean FailListVar{Get; set;}
    public boolean valueOfBIS{Get; set;}
    public CG_PACCAR_Flag_SP_Info_Mapping__c paccarCustomSettingValues {get;set;}
    public boolean isPaccarAutoClaim {get; set;}
    public boolean isAutomatedDealer {get; set;}
    public boolean isManualDealer {get; set;}
    public boolean PSNFlag{get;set;}//Story#183077
    //public boolean isAttachmentLinkEnabled {get; set;}
    public String isPaccarAndPW{get;set;} //Added as part of the story GSSC-71
    public boolean disableinfocheck{get;set;} //Added as part of the story GSSC-69
    public boolean ecmFlag{get;set;} //Added as part the story GSSC-30
    public boolean startRequestCalled {get;set;} //GSSC-240
     public string previousPSN{get;set;} //GSSC-240
    
    //Constructor.
    public CG_CL_ClaimsIntake()
    {
        totaldigSRT = 0.0;
        totalrepSRT = 0.0;
        totalcampSRT = 0.0;
        totaltrpSRT = 0.0;
        totalatcSRT = 0.0;
        totalNON = 0.0;
        totalSRT = 0.0;
        actual = 000.0;
        servDate = '';
        repairCompdate = '';
        psncheck = false;
        checkBIS = false;
        isWarrCustomer = false;
        valueOfBIS=false;
        FailListVar=false;
        System.debug('IN CG_CL_ClaimsIntake constructor...');
        try {
            System.debug('Total Number of SOQL Queries in claimsintake constructor start: ' + Limits.getQueries());
            dealerUser=false;
            //isAttachmentLinkEnabled=false;
            //DistributorUser=false;
            checkAccountCode=false;
            isAutomatedDealer = false;
            isManualDealer = false;
            controllerRef = this;
            psnRec = new CSS_PSN__c(); 
            cId=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('MyClaimId**'+cId);
            String ManualClaimsLoc = (String)Cache.Session.get('ManualClaimsSelectedLocation');
            system.debug('ManualClaimsLoc' + ManualClaimsLoc);
            lstPsnRec = new List<CSS_PSN__c>();
            accnt = new List<Account>();
            string locCode;
            UserRole urRole;
            String custCode;
            urRole = [Select name from UserRole where id=:UserInfo.getUserRoleId()];
            
            if(cId == null) {
                //isAttachmentLinkEnabled=true;
                // Added code for getting erp sytem field from account object basend user location when we don't have a claim as per defect #153859 ,-By RAJESh 12th July 2018         
                String userid = UserInfo.getUserId();               
                system.debug('**SHJEAR+userid***'+userid);
                user u =[select id,User_Location__c from user where Id=:userid];
                system.debug('**SHJEAR+u.User_Location__c***'+u.User_Location__c);

                //**********************<!--Added code for getting location code with out name and with out claim as per Despicable Me story #161401,-By RAJESH 15th Nov 2018-->***************************************************************************************************                
                /*   UserRole urRole = new UserRole();
               if(UserInfo.getUserRoleId()!=null){
                  urRole = [Select name from UserRole where id=:UserInfo.getUserRoleId()];
                }*/
                // if(urRole.name == 'Factory'){
                //UserRole urRole;
                system.debug('Anirudh ManualClaimsLoc>>>>>'+ManualClaimsLoc);
                if(ManualClaimsLoc != null && ManualClaimsLoc.length() > 0){
                    custCode = '%'+ManualClaimsLoc.RIGHT(5); 
                    String[] arrOfStr = ManualClaimsLoc.split('-');
                    //locCode = arrOfStr[0].trim();
     //Added below code as per defect 173232,-By RAJESH 7th Dec 2018             
                    if(arrOfStr.size()<=2){
                    locCode = arrOfStr[0].trim();
                    system.debug('***inside if locCode**'+locCode);}
                    else{
                    //locCode = arrOfStr[0].trim()+'-'+arrOfStr[1].trim();
                    locCode = arrOfStr[0]+'-'+arrOfStr[1];
                    system.debug('***inside else locCode**'+locCode);}
     //End code as per defect 173232,-By RAJESH 7th Dec 2018               
                    system.debug('**locCode***'+locCode);
                    system.debug('**locCode***'+locCode);
                    system.debug('**custCode**'+custCode);
                    /*list<CSS_UserLocation__c> usrec=[SELECT Id, OwnerId, UserId__c, AccountId__c, Location_code__c, Location_Name__c, AccountId__r.Type 
                                                     from CSS_UserLocation__c
                                                     where Location_Name__c=:locCode 
                                                     and UserId__c=:userinfo.getUserId()];*/
                    list<CSS_UserLocation__c> usrec=[SELECT Id, OwnerId, UserId__c, AccountId__c, Location_code__c, Location_Name__c, AccountId__r.Type 
                                                     from CSS_UserLocation__c
                                                     where Location_code__c LIKE: custCode 
                                                     and UserId__c=:userinfo.getUserId()];
                    system.debug('**usrec***'+usrec);  
					boolean DealerTypeFlag = CSS_utility.getAccounttype(usrec[0].AccountId__r.Type);
                    if(UserInfo.getUserRoleId()!=null){
                        //urRole = [Select name from UserRole where id=:UserInfo.getUserRoleId()];
                        if(urRole.name == 'Factory'){
                            system.debug('**usrec[0].AccountId__r.Type***'+usrec[0].AccountId__r.Type);
                            if(usrec!=null && DealerTypeFlag == true ){
                                system.debug('**SHJEAR+inside if ***');
                                dealerUser=true;
                                isManualDealer=true;
                                system.debug('**SHJEAR+inside if dealerUser***'+dealerUser);
                            }
                        }
                        else if(usrec!=null && DealerTypeFlag==true){
                            dealerUser = true;
                            system.debug('**SHJEAR+inside else if dealerUser***'+dealerUser);
                        }
                       else{
                            dealerUser=false;
                            system.debug('**SHJEAR+inside else ***'+dealerUser);
                        }
                    }

                }

                // }

                //**********************End as per Despicable Me story #161401,-By RAJESH 15th Nov 2018-->**********************************************************
                LocationManualClaims = ManualClaimsLoc;

                system.debug('LocationManualClaims' + LocationManualClaims);


                system.debug('user**'+u);
                system.debug('account**'+acc);
                claimsRec = new CSS_Claims__c();  
                psnRec = new CSS_PSN__c();
                claSubRec = new CSS_Claim_Submission__c();
                solComps = new List<CSS_Solution_Component__c>();
            } else { 
               // isAttachmentLinkEnabled=false;
                /*claimsRec =[Select Id,Name,Address__c,Authorization_Comments__c,Catastrophic__c,Contact_First_Name__c,Contact_Id__c,
    Contact_Last_Name__c,Country__c,Customer_Code__c,Customer_Contact_Phone__c,Customer_Name__c,Customer_Phone__c,
    TSR1__c, TSR2__c, TSR3__c, TSR4__c, TSR5__c, TSR6__c, TSR7__c, TSR8__c, TSR9__c, TSR10__c,
    Distributor_Authorization_FN__c,Distributor_Authorization_LN__c,Distributor_Authorization_WWID__c,
    Email_Address__c,ESN__c,Location__c,Location_Code__c,PACCAR_Authorization_FN__c,PACCAR_Authorization_LN__c,
    PACCAR_Authorization_WWID__c,Repair_Completion__c,Repair_Location__c,Service_Date__c,Service_Model__c,Shop_Work_Order__c,
    State__c,Status__c,ZipCode__c from CSS_Claims__c where id= :cId];
    psnRec =[Select Id,Name,PSN__c,Application__c,Before_In_Service__c,Caliberation_After__c,Caliberation_Before__c,Failure_Date__c,Justification__c,License_Plate_State__c,
    Make__c,Mileage__c,Mileage_Measure__c,Mission_Disabling__c,Model__c,Primary__c,Product_Hours__c,Qsol_Engine_Family_Code__c,Qsol_Technical_Config__c,
    Qsol_Warranty_Start__c,Service_Model__c,Unit_Number__c,Unit_Type__c,VIN__c,Warranty_Start_Date__c,CSS_Claims__c from CSS_PSN__c where CSS_Claims__c =:claimsRec.Id and Primary__c=true Limit 1];
    system.debug('claimsRec>>>>:'+claimsRec);
    system.debug('psnRec>>>>:'+psnRec);*/

                // Added Account__r.ERP_System__c field in below query as per Simpsons document 145403 by -RAJESH 29th May 2018
                //Added IsCopyclaim__c field in below query as per copy claim story#161007
                //Added CG_Get_Engine_data_flag for the story 183077 //Added PACCAR_Mixed_Accountcodes__c as part of the defect #GSSC-225
                //Added All Category and Complaint fields in below query as per story GSSC-377-BY RAJESH 23rd Dec 2019      
                //Query Optimization By Krishna on Jan 27th 2020.
                claimsRec =[Select Id,Claims_Category__c,Claims_Preventive_Maintenance__c,Claims_Expedited_Service__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,LastSavedDate__c,	Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,Claims_Additional_Comments__c,Claims_General_Symptoms__c,
                            Last_saved_by__c,Failures_ODM_Status__c, Parts_ODM_Status__c, SRTs_ODM_Status__c, Account__r.Warranty_Training_Certification__c,Account__r.Warranty_Training_Status__c, Account__r.CERTIFICATION_END_DATE__c, SPDataWebserviceResult__c,ODM_Status_Message__c,FieldActionWebServiceResult__c,CG_Get_Engine_data_flag__c,No_Failure_PACCAR_Flag__c,Account__r.Type,Account__r.Region__c,IsDealerCreatedClaim__c,ReconEngineFlag__c,CSS_Paccar_Authorization_contact_text__c,PACCAR_Flag__c,CSS_PACCAR_Auth_Track__c,PACCAR_Auth_Required__c, IsCopyclaim__c,CSS_Channel_Of_Distribution__c,Assigned_To__c,CSS_Job__r.Assigned_To__c,Assigned_To__r.Name,Additional_Tech1__c,Additional_Tech1__r.Name,CSS_Job__r.Additional_Tech1__c,Additional_Tech2__c,CSS_Job__r.Additional_Tech2__c,Additional_Tech2__r.Name,Additional_Tech3__c,Additional_Tech3__r.Name, CSS_Job__r.Additional_Tech3__c,Additional_Tech4__c,CSS_Job__r.Additional_Tech4__c, Additional_Tech4__r.Name,Additional_Tech5__c,CSS_Job__r.Additional_Tech5__c,Additional_Tech5__r.Name,Additional_Tech6__c,CSS_Job__r.Additional_Tech6__c,Additional_Tech6__r.Name,Additional_Tech7__c,CSS_Job__r.Additional_Tech7__c,Additional_Tech7__r.Name,Additional_Tech8__c,CSS_Job__r.Additional_Tech8__c,Additional_Tech8__r.Name,Additional_Tech9__c,CSS_Job__r.Additional_Tech9__c,Additional_Tech9__r.Name,CSS_Job__r.CreatedDate,Account__r.ERP_System__c,CSS_Job__r.Date_in_Shop__c,CSS_Job__r.Date_in__c,CSS_Job__r.Repeat_Or_Recent_Calc__c,CSS_Job__r.RecentVisit__c,CreatedDate,LastModifiedDate,Name,Address__c,Authorization_Comments__c,Catastrophic__c,Contact_First_Name__c,Contact_Id__c,
                            Contact_Last_Name__c,ProductApplicationCode__c,Account__c,Country__c,Customer_Code__c,Customer_Contact_Phone__c,Customer_Name__c,Actual_Technician_Time__c,Actual_Time_for_Diagnostics__c,Actual_Time_for_Repair__c,Customer_Phone__c,
                            TSR1__c, TSR2__c,isAutomatedCopyClaim__c,Automotive_App_Flag__c,TSR3__c, TSR4__c, TSR5__c, TSR6__c, TSR7__c, TSR8__c, TSR9__c, TSR10__c,RejectedByUser__c,Rejection_Timestamp__c,Rejection_Comments__c,Claims_city__c, CSS_Channel_Code__c, 
                            Distributor_Authorization_FN__c,CSS_Job__r.Status__c,Information_Only_Claim__c,Parts_Warranty_Claim_Only__c,PACCAR_Mixed_Accountcodes__c,Distributor_Authorization_LN__c,Distributor_Authorization_WWID__c,
                            Email_Address__c,ESN__c,Multi_PSN_Claim__c,Account__r.RSS_RESP_BRANCH_CODE__c,SP_Country__c,Location__c,SP_PrimaryOEMCode__c,Location_Code__c,PACCAR_Authorization_FN__c,PACCAR_Authorization_LN__c,DesignPhaseCode__c , EngineFamilyCode__c, ShipDate__c, ETOOldESN__c, EngineFamilyName__c,EtoConversionDate__c, MarineFlag__c, OemCode__c, ProductApplicationDesp__c, warrantyIndicatorFlag__c,
                            PACCAR_Authorization_WWID__c,Account__r.WR_Certfication_Flag__c,Repair_Completion__c,Repair_Location__c,Service_Date__c,Service_Model__c,Shop_Work_Order__c,Dealer_Service_Job__r.Name,
                            State__c,Status__c,ZipCode__c,css_job__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Category4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,
                            CSS_Job__r.Expedited_Service__c,CSS_Job__r.Preventive_Maintenance__c,CSS_Job__r.ApplicationCode__c,Dealer_Service_Job__c,Dealer_Service_Job__r.ApplicationCode__c,CSS_Job__r.Name,CSS_Job__r.LastUpdateSubStatus__c,CSS_Job__r.General_Symptoms__c, BillToCode__c ,BuildDate__c ,SP_FIELD_SERVICE_LABOR_RATE__c,
                            SP_CHANNEL_OF_DISTRIBUTION__c,Account__r.Product_Certification__c,SP_WarrantyCertificationEndDate__c,SP_CLAIM_ALLOWED_DAYS__c,SP_CMI_SP_EXPIRATION__c,SP_LTA_FLAG__c,SP_OUTFILE_ALL_CLAIMS__c,Pending_Authorization__c,Warranty_Authorization_Flag__c,
                            SP_PACCAR__c,SP_REGION__c,Product_Certification__c,SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,bmsCreateAccount__c,SP_INSHOP_LABOR_RATE__c,Css_paccar_approve_reject_flag__c,
                            SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,SP_Group_Name__c,SP_TERRITORY__c,SP_REGIONCODE__c,Territory_Class__c,Territory_Class_Name__c,SP_PromotionId__c, MileageProdHrsError__c, ODM_Status__c , account__r.name,account__r.IAM_Service_Provider_Code__c,                       
                            (Select Id,Name,PSN__c,Location_Certification__c,Warranty_Authorization_Flag__c,Application__c,ApplicationCode__c,Before_In_Service__c,Calibration_After__c,Calibration_Before__c,Revision_After__c,Revision_Before__c,Failure_Date__c,Justification__c,License_Plate_State__c,
                             Make__c,Mileage__c,CoverageFlag__c,Mileage_Measure__c,Mission_Disabling__c,Model__c,Primary__c,Product_Hours__c,Qsol_Engine_Family_Code__c,Equipment_ID__c,Qsol_Technical_Config__c,
                             Qsol_Warranty_Start__c,Service_Model__c,Unit_Number__c,Unit_Type__c,VIN__c,Warranty_Start_Date__c,CSS_Claims__c,ProductAppcodeErrorflag__c, PACCAR_Flag__c from CSS_PSNs__r) 
                            from CSS_Claims__c where id= :cId]; // where Primary__c=true Limit 1 By Krishna on Jan 27th 2020.
                system.debug('IsDealerCreatedClaim__c'+claimsRec.IsDealerCreatedClaim__c);
               
                 boolean DealerTypeFlag = CSS_utility.getAccounttype(claimsRec.Account__r.Type);
                if(DealerTypeFlag== true && claimsRec.PACCAR_Auth_Required__c == true && (claimsRec.CSS_Job__c != null || claimsRec.Dealer_Service_Job__c != null) && claimsRec.Css_paccar_approve_reject_flag__c != 'Approved' && claimsRec.Css_paccar_approve_reject_flag__c != 'Rejected'){
                    isPaccarAutoClaim = true;
                }
                else{
                    isPaccarAutoClaim = false;
                }
                
                if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                    //Query Optimization By Krishna on Jan 27th 2020.
                    if(claimsRec.CSS_PSNs__r.size()>1)
                        secondaryPSN = true;
                    lstPsnRec = claimsRec.CSS_PSNs__r;
                    for(CSS_PSN__c psn : claimsRec.CSS_PSNs__r) {
                        if(psn.Primary__c) {
                            psnRec = new CSS_PSN__c();
                            psnRec = psn;
                             PsnId = psnRec.Id;
                            system.debug('Terstid'+PsnId);
                            existingPSN = psn.PSN__c;
                            if(psnRec.Failure_Date__c== null)
                                psnRec.Failure_Date__c = System.today();
                            tempFailureDate = psnRec.Failure_Date__c;
                            if(psn.Before_In_Service__c!=null && psn.Before_In_Service__c==true){
                                valueOfBIS=true;
                            }
                            else{
                                valueOfBIS=false;
                            }
                        }
                    }
                    /*
                    psnRec = claimsRec.CSS_PSNs__r.get(0);
                    PsnId = psnRec.Id;
                    system.debug('Terstid'+PsnId);
                    existingPSN = claimsRec.CSS_PSNs__r[0].PSN__c;
                    if(psnRec.Failure_Date__c== null)
                        psnRec.Failure_Date__c = System.today();
                    tempFailureDate = psnRec.Failure_Date__c;
//Start added below code for getting BIS field value As per Task #189398,-By RAJESH 31st July 2019                                                    
                    if(claimsRec.CSS_PSNs__r[0].Before_In_Service__c!=null && claimsRec.CSS_PSNs__r[0].Before_In_Service__c==true){
                        valueOfBIS=true;
                    }
                    else{
                        valueOfBIS=false;
                    }
                    */
                    //Query Optimization By Krishna on Jan 27th 2020.
//End  code for getting BIS field value As per Task #189398,-By RAJESH 31st July 2019
                }else {
                    psnRec = new CSS_PSN__c(); 
                    lstPsnRec = null;   //Query Optimization By Krishna on Jan 27th 2020.
                }

                system.debug('claimsRec1>>>>:'+claimsRec);
                System.debug('AssignedTo'+claimsRec.Assigned_To__c);
                System.debug('AssignedToJob'+claimsRec.CSS_Job__r.Assigned_To__c);
                System.debug('Job>>'+claimsRec.css_job__c);
                System.debug('Dealer>>'+ isDealer);
                //*************************************************************************************************************************
                String CreatorLocation;
                system.debug('Claim claimsRec******:'+claimsRec); 
                if(claimsRec != null){

                    if(claimsRec.Location__c!=null)
                    {
                        CreatorLocation = claimsRec.Location__c+' - '+claimsRec.Location_code__c.RIGHT(5); 
                        system.debug('CreatorLocation*******' + ' ' + CreatorLocation);
                    }

                } 
                 system.debug(' claimsRec.Location_Code__c***'+claimsRec.Location_Code__c);
              
                system.debug('CreatorLocation***'+claimsRec.Location__c);

				boolean DealerTypeFlag1 = CSS_utility.getAccounttype(claimsRec.Account__r.Type);
                if(DealerTypeFlag1 == true){
                    system.debug('**SHJEAR+inside if ***');
                    dealerUser=true;
                }
                else{
                    dealerUser=false;
                    system.debug('**SHJEAR+inside else ***');
                }

                /* START Query Optimization By Krishna on Jan 27th 2020. */
                solComps = new List<CSS_Solution_Component__c>();
                FList = new List<CSS_Solution_Component__c>();
                List<CSS_Solution_Component__c> checkSOLList = new List<CSS_Solution_Component__c>();
                checkSOLList = [select Id, Claim_FailCode__c,CampaignLaborPercentage__c,CampaignTravelPercentage__c, In_Shop_SRT_Limit_Flag__c,CoveredLaborHrs__c,CoveredTravelMiles__c,
                           Fail_Code__c,type__c,Selected_Component__c,AccountCode__c,CSS_Primary_Failure__c,CSS_Account_Formula__c,Over_The_Counter__c, Pay_Code__c,Status__c
                            from CSS_Solution_Component__c
                            where CSS_Claims__c =:cId AND Selected_Component__c = true];
                if(checkSOLList!= null && checkSOLList.size()>0){
                    FailListVar = true;
                }
                else{
                    FailListVar=false;
                }

                for(CSS_Solution_Component__c sol : checkSOLList) {
                    if(sol.Type__c == '' || sol.Type__c == null) {
                        FList.add(sol);
                    }
                    if((sol.Type__c == '' || sol.Type__c == null) || 
                    (sol.Type__c != null && (sol.Type__c == 'Campaign' || sol.Type__c == 'ATC') 
                    && sol.Status__c == 'Approved')) {
                        solComps.add(sol);
                    }
                }

                for(css_solution_component__c SC: solComps){
                    if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                        checkAccountCode=true;
                    }
                }

                /*FailList = new List<CSS_Solution_Component__c> ([Select id,Selected_Component__c,Type__c,Pay_Code__c from CSS_Solution_Component__c where CSS_Claims__c = :cId AND Selected_Component__c = true]);
                if(FailList!= null && FailList.size()>0){
                    FailListVar = true;
                }
                else{
                    FailListVar=false;
                }*/
                /* END Query Optimization By Krishna on Jan 27th 2020. */
                
                //*****************************************************************************************************************************
                //****************************************************************Getting Multi-PSN chevron basend on condition from Solution component Object 154239 By RAJESH *****************************************************************************************************                
                /* Query Optimization By Krishna on Jan 27th 2020. 
                solComps = [select Id, Claim_FailCode__c,CampaignLaborPercentage__c,CampaignTravelPercentage__c, In_Shop_SRT_Limit_Flag__c,CoveredLaborHrs__c,CoveredTravelMiles__c,
                            Fail_Code__c,type__c,Selected_Component__c,AccountCode__c,CSS_Primary_Failure__c,CSS_Account_Formula__c,Over_The_Counter__c, Pay_Code__c
                            from CSS_Solution_Component__c
                            where CSS_Claims__c =:cId AND Selected_Component__c = true AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC')) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved'))]; 
                for(css_solution_component__c SC: solComps){
                    if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                        checkAccountCode=true;
                    }
                }
                system.debug('solComps.size()****8'+solComps);*/
                //*********************************************************************END*****************************************************************************************8      
                /* Query Optimization By Krishna on Jan 27th 2020.
                FList = new List<CSS_Solution_Component__c>([Select id,Selected_Component__c,Over_The_Counter__c,Type__c,Pay_Code__c from CSS_Solution_Component__c 
                                                             where CSS_Claims__c =:cId AND Selected_Component__c = true and Type__c NOT IN ('TSB','TRP','Campaign','ATC') ]);  //where Selected_Component__c = true and CSS_Claims__c = :cId ]; //commented this since need only Failures not Campaigns
                system.debug('FList.size>>:'+FList.size());     */   

                /*
                //Query Optimization By Krishna on Jan 27th 2020.
                try{
                    lstPsnRec=   [Select Id,Name,PSN__c,Location_Certification__c,Warranty_Authorization_Flag__c,Application__c,Before_In_Service__c,Calibration_After__c,Calibration_Before__c,Revision_After__c,Revision_Before__c,Failure_Date__c,Justification__c,License_Plate_State__c,
                                  Make__c,Mileage__c,CoverageFlag__c,Mileage_Measure__c,Mission_Disabling__c,Model__c,Primary__c,Product_Hours__c,Qsol_Engine_Family_Code__c,Equipment_ID__c,Qsol_Technical_Config__c,
                                  Qsol_Warranty_Start__c,Service_Model__c,Unit_Number__c,Unit_Type__c,VIN__c,Warranty_Start_Date__c,CSS_Claims__c,ProductAppcodeErrorflag__c from CSS_PSN__c where css_cLaims__c = :claimsRec.id];
                    if(lstPsnRec.size()>1)
                        secondaryPSN = true;
                }
                catch (exception e){
                    lstPsnRec = null;
                }
                //Query Optimization By Krishna on Jan 27th 2020.
                */

                /* Added query from CSS_Claim_Submission__c object as per Simpsons story #144554, By -RAJESH*/     
                // Commenting below code by Rajkumar to resolve 101 issue
                /*try{
                    claSubRec=   [SELECT Id, Type__c, Rejection_Reason__c, Status__c, Claim_Number__c,Credit_Date__c, CSS_Claims__c from CSS_Claim_Submission__c where CSS_Claims__c=:claimsRec.Id]; //Claim_Number__c=:claimsRec.name
                    //This list is used to check weather we have a claim submission record for the claim object and if there is claim submission record for claim object then we are not suppossed to save any modified information
                    claimSubmissionList = [SELECT Id, Type__c, Rejection_Reason__c, Status__c, Claim_Number__c,Credit_Date__c, CSS_Claims__c from CSS_Claim_Submission__c where Claim_Number__c=:claimsRec.name];
                    //  system.debug('***claSubRec***'+claSubRec);
                }
                catch (exception e){
                    claSubRec = null;
                }*/
                //****************************************************************Getting Multi-PSN chevron basend on condition from PSN Object 154239 By RAJESH *****************************************************************************************************                                
                if(claimsRec!=null && checkAccountCode==true){
                    if(claimsRec.Multi_PSN_Claim__c== true)
                    {
                        psncheck = true;
                    }else{
                        psncheck = false;
                    }
                }
                //**************************************************************************END 154239 ************************************************************************************8                 


                if(claimsRec.css_job__c!=null)
                    repaircomple = claimsRec.CSS_Job__r.LastUpdateSubStatus__c;
                //if(claimsRec.CSS_Claim_Submissions__r != null && !claimsRec.CSS_Claim_Submissions__r.isEmpty() && claimsRec.CSS_Claim_Submissions__r.size()>0)
                //   claSubRec=claimsRec.CSS_Claim_Submissions__r.get(0);
                if(claimsRec.Service_Date__c != null)
                {
                    DateTime serviceDate = claimsRec.Service_Date__c;
                    servDate = serviceDate.format('MM/dd/yyyy');
                }
                if(claimsRec.Repair_Completion__c != null)
                {
                    DateTime repDate = claimsRec.Repair_Completion__c;
                    repairCompdate = repDate.format('MM/dd/yyyy');
                }


                /*Start ->RAJESH
    system.debug('claimsRec>>>>:'+claimsRec.Distributor_Authorization_FN__c);
    system.debug('claimsRec>>>>:'+claimsRec.Distributor_Authorization_LN__c);
    system.debug('claimsRec>>>>:'+claimsRec.Distributor_Authorization_WWID__c);
    system.debug('claimsRec>>>>:'+claimsRec.PACCAR_Authorization_FN__c);
    system.debug('claimsRec>>>>:'+claimsRec.PACCAR_Authorization_LN__c);
    system.debug('claimsRec>>>>:'+claimsRec.PACCAR_Authorization_WWID__c);
                 
    End*/ system.debug('claimsRec>>>>:'+claimsRec);
                system.debug('psnRec>>>>:'+psnRec);
                /*These two successive ifs are for populating the saved country and state values.If blank keep it blank else save the new value.*/
                if (claimsRec.Country__c=='' || claimsRec.Country__c=='----None----' || claimsRec.Country__c==null) 
                {
                    filterCountry = '----None----';                                        
                } else 
                {
                    strCntry=css_utility.getCountryDesc(claimsRec.Country__c);
                    filterCountry = claimsRec.Country__c;
                }

                if (claimsRec.State__c==null || claimsRec.State__c=='----None----' || claimsRec.State__c=='') 
                {
                    filterState = '----None----';
                } else 
                {
                    strCntryState=css_utility.getStateDesc(claimsRec.Country__c, claimsRec.State__c);
                    filterState = claimsRec.State__c;
                }
                if(psnRec.Warranty_Start_Date__c != null){
                    wsdReadOnlyFromContr = true;
                    system.debug('inside ifToday wsdReadOnlyFromContr ' +wsdReadOnlyFromContr);
                }
                else{
                    wsdReadOnlyFromContr = false;
                    system.debug('inside else Today wsdReadOnlyFromContr ' +wsdReadOnlyFromContr);
                }
                
                system.debug('Today wsdReadOnlyFromContr ' +wsdReadOnlyFromContr);
                /*Sucessive Two Ifs END here. Fixed by Rupesh*/
                if(claimsRec.Multi_PSN_Claim__c ==true && psnRec.Before_In_Service__c == true && FList.size()>0)
                {
                    checkBIS = true;
                }

                List<CSS_SRT__c> lstDiagRepTime = new List<CSS_SRT__c>([Select id, Extended_Hours__c, Additional_SRT_Calculated__c, type__c,srt_type__c,Repair_Time__c,srt_category__c,SRT_Select__c,Assignment__c,Solution_Number__r.Diagnostic_Response__c,diagnosis_time__c,isPerformed__c,SRT_AccessiblityCheck__c,ECM_Flag__c,SRT_Id__c,SRT_Decimal_Time__c,SRT_Time__c, job_order__c, Solution_Number__c , Solution_Number__r.Repair_Response__c,Component_Id__r.Selected_Component__c, Component_Id__r.Type__c from css_srt__c where CSS_Claims__c =:cId]);
                system.debug('lstDiagRepTime..2'+lstDiagRepTime);
                ecmFlag = false;
                if(lstDiagRepTime.size()>0){
                    for(css_srt__c srtTimes : lstDiagRepTime){
                        System.debug('srtTimes.type__c---:'+srtTimes.type__c);
                        System.debug('srtTimes.srt_category__c ---:'+srtTimes.srt_category__c );
                        System.debug('srtTimes.diagnosis_time__c---:'+srtTimes.diagnosis_time__c);
                        System.debug('srtTimes.isPerformed__c---:'+srtTimes.isPerformed__c);
                        system.debug('totaldigSRT---:'+totaldigSRT);
                        system.debug('srtTimes.Extended_Hours__c---:'+srtTimes.Extended_Hours__c);
                        
                        if(srtTimes.ECM_Flag__c==true && (srtTimes.isPerformed__c==true || srtTimes.SRT_AccessiblityCheck__c==true))
                            ecmFlag = true;
                        
                        if(srtTimes.type__c!=null && (srtTimes.type__c.equalsIgnorecase('Diagnosis') || srtTimes.Assignment__c == 'DIAGNOSTIC' || srtTimes.type__c.equalsIgnorecase('Diag Access')) && srtTimes.srt_category__c == null && srtTimes.diagnosis_time__c!=null && (srtTimes.isPerformed__c==true || srtTimes.SRT_AccessiblityCheck__c == true)){ 
                        //if(srtTimes.type__c!=null && srtTimes.type__c.equalsIgnorecase('Repair') && srtTimes.Assignment__c == 'DIAGNOSTIC' && srtTimes.srt_category__c == null && srtTimes.diagnosis_time__c!=null && srtTimes.isPerformed__c==true){ 
                            //totaldigSRT = totaldigSRT + srtTimes.diagnosis_time__c;
                            if(srtTimes.Extended_Hours__c != null){
                                totaldigSRT = totaldigSRT + (srtTimes.Extended_Hours__c != null ? srtTimes.Extended_Hours__c : 0.0);
                                system.debug('totaldigSRT+'+totaldigSRT);
                            }
                        }
                        if(srtTimes.Additional_SRT_Calculated__c != null && (srtTimes.srt_category__c!= null && srtTimes.srt_category__c.equalsIgnoreCase('AdditionalDiag')) && (srtTimes.isPerformed__c==true || srtTimes.SRT_AccessiblityCheck__c == true)){
                            //totaldigSRT= totaldigSRT+ srtTimes.Additional_SRT_Calculated__c;
                            if(srtTimes.Extended_Hours__c != null){
                                totaldigSRT = totaldigSRT + (srtTimes.Extended_Hours__c != null ? srtTimes.Extended_Hours__c : 0.0);
                                system.debug('srtTimes.Additional_SRT_Calculated__c+'+srtTimes.Additional_SRT_Calculated__c);
                            }
                        }

                        system.debug('Entered outside if Assignment check'+srtTimes.type__c + ' ' + srtTimes.Component_Id__r.Selected_Component__c + ' ' + srtTimes.isPerformed__c);

                        //if(srtTimes.solution_number__r.Diagnostic_Response__c!=null && srtTimes.solution_number__r.Diagnostic_Response__c == 'Most likely the solution'){
                           
                            system.debug('srtTimes.isPerformed__c'+srtTimes.isPerformed__c);
                            system.debug('srtTimes.srt_category__c'+srtTimes.srt_category__c);
                            if((srtTimes.Type__c.equalsIgnoreCase('Repair') || srtTimes.Type__c.equalsIgnoreCase('Repair Access'))  && (srtTimes.isPerformed__c==true || srtTimes.SRT_AccessiblityCheck__c == true) && srtTimes.srt_category__c == null){
                                system.debug('srtTimes.Assignment__c'+srtTimes.Assignment__c);
                                if(srtTimes.Assignment__c == 'Primary' || srtTimes.Assignment__c == 'Progressive Damage' || srtTimes.Assignment__c == 'Alternative'){
                                    //totalrepSRT= totalrepSRT+srtTimes.Repair_Time__c;
                                    if(srtTimes.Extended_Hours__c != null){
                                        totalrepSRT= totalrepSRT+(srtTimes.Extended_Hours__c != null ? srtTimes.Extended_Hours__c : 0.0);
                                    }     
                                }
                            }
                        //}
                        if(srtTimes.Additional_SRT_Calculated__c != null && (srtTimes.srt_category__c!= null && srtTimes.srt_category__c.equalsIgnoreCase('AdditionalRep')) && (srtTimes.isPerformed__c==true || srtTimes.SRT_AccessiblityCheck__c == true)){
                            if(srtTimes.Extended_Hours__c != null){
                                totalrepSRT = totalrepSRT + (srtTimes.Extended_Hours__c != null ? srtTimes.Extended_Hours__c : 0.0);
							}
                            //totalrepSRT= totalrepSRT+ srtTimes.Additional_SRT_Calculated__c; 
                            //totalrepSRT= totalrepSRT+ srtTimes.Extended_Hours__c;
                        }
                        system.debug('SRT Type' + srtTimes.srt_type__c);
                        if((srtTimes.srt_type__c!=null && srtTimes.SRT_Time__c != null && srtTimes.srt_type__c.equalsIgnoreCase('Campaign')  && srtTimes.type__c.equalsIgnoreCase('Field Action') || (srtTimes.srt_category__c != null && srtTimes.srt_category__c != '' && srtTimes.srt_category__c.equalsIgnoreCase('Campaign')) ) && (srtTimes.isPerformed__c==true || srtTimes.SRT_AccessiblityCheck__c == true)){
                            //totalcampSRT = totalcampSRT + srtTimes.SRT_Time__c;
                            if(srtTimes.Extended_Hours__c != null){
                            totalcampSRT = totalcampSRT + (srtTimes.Extended_Hours__c != null ? srtTimes.Extended_Hours__c : 0.0);
                            }
                            system.debug('Camp SRT' + totalcampSRT);
                        }
                         system.debug('srtTimes.Type__c'+srtTimes.Type__c);
                          system.debug('srtTimes.SRT_Time__c'+srtTimes.SRT_Time__c);
                           system.debug('srtTimes.isPerformed__c'+srtTimes.isPerformed__c);
                          
                          
                          
                         if((srtTimes.srt_type__c!=null && srtTimes.srt_time__c != null && srtTimes.srt_type__c.equalsIgnoreCase('TRP') && srtTimes.type__c.equalsIgnoreCase('Field Action') || (srtTimes.srt_category__c != null && srtTimes.srt_category__c != '' && srtTimes.srt_category__c.equalsIgnoreCase('TRP')) ) && (srtTimes.isPerformed__c==true || srtTimes.SRT_AccessiblityCheck__c == true)){
                            //totaltrpSRT = totaltrpSRT + srtTimes.SRT_Time__c;
                            if(srtTimes.Extended_Hours__c != null){
                            totaltrpSRT = totaltrpSRT + (srtTimes.Extended_Hours__c != null ? srtTimes.Extended_Hours__c : 0.0);
                            system.debug('TRP' + totaltrpSRT);
                            }
                        }


                        if((srtTimes.srt_type__c!=null && srtTimes.srt_time__c != null && srtTimes.srt_type__c.equalsIgnoreCase('ATC') && srtTimes.type__c.equalsIgnoreCase('Field Action') || (srtTimes.srt_category__c != null && srtTimes.srt_category__c != '' && srtTimes.srt_category__c.equalsIgnoreCase('ATC')) ) && (srtTimes.isPerformed__c==true || srtTimes.SRT_AccessiblityCheck__c == true)){
                            //totalatcSRT = totalatcSRT + srtTimes.SRT_Time__c;
                            if(srtTimes.Extended_Hours__c != null){
                            totalatcSRT = totalatcSRT + (srtTimes.Extended_Hours__c != null ? srtTimes.Extended_Hours__c : 0.0);
                            system.debug('ATC' +totalatcSRT);
                            }
                        }

                        if(srtTimes.type__c!=null && srtTimes.srt_time__c != null && srtTimes.srt_time__c != 0.0 && srtTimes.type__c == '99Time'){
                            //if(srtTimes.type__c!=null && srtTimes.Extended_Hours__c != null && srtTimes.Extended_Hours__c != 0.0 && srtTimes.type__c == '99Time'){
                            totalNON = totalNON + (srtTimes.Extended_Hours__c != null ? srtTimes.Extended_Hours__c : 0.0);
                            //totalNON = totalNON + srtTimes.Extended_Hours__c;

                            system.debug('99 srt time' + srtTimes.srt_time__c);
                        }

                    }// end of For loop
                }// end of if loop
                totalSRT = totaldigSRT + totalrepSRT + totalcampSRT + totaltrpSRT + totalatcSRT + totalNON;
                
                system.debug('*******claimsRec.Dealer_Service_Job__c***'+claimsRec.Dealer_Service_Job__c);
                system.debug('*******claimsRec.CSS_Job__c***'+claimsRec.CSS_Job__c);
                system.debug('*******urRole.name***'+urRole.name);
                system.debug('*******dealerUser***'+dealerUser);
                /*/Added condition for Factory user Dealer loction Automated claim #174458
                 if((DealerTypeFlag || claimsRec.CSS_Job__c!=null) && dealerUser==true && urRole.name == 'Factory'){
                     system.debug('******inside if for Auto claim***');
                   isAutomatedDealer = true;   
                }else if((claimsRec.Dealer_Service_Job__c ==null || claimsRec.CSS_Job__c==null) && dealerUser==true && urRole.name == 'Factory'){
                      system.debug('******inside else if for Manual claim***');
                      isManualDealer = true;   
                }
               else{
                   system.debug('******inside else for claim***');
                   isManualDealer = false;
                   isAutomatedDealer = false;
               }
               
               */
               
               
               
            /*   if(urRole.name == 'Factory'){
                   if((claimsRec.Dealer_Service_Job__c ==null || claimsRec.CSS_Job__c==null) && dealerUser==true){
                       system.debug('******inside if***'+dealerUser);
                       system.debug('******inside if1***'+claimsRec.Dealer_Service_Job__c);
                       system.debug('******inside if2***'+claimsRec.CSS_Job__c);
                       
                       isManualDealer = true;
                   }
                   else if((claimsRec.Dealer_Service_Job__c!=null || claimsRec.CSS_Job__c!=null) && dealerUser==true) {
                       system.debug('******inside else if ***');
                       isAutomatedDealer = true;
                   }
                   else{
                       system.debug('******inside else for claim***');
                       isManualDealer = false;
                       isAutomatedDealer = false;
                   }
               }
               if(urRole.name != 'Factory'){
                
                   system.debug('******inside else for claim***');
                   isManualDealer = false;
                   isAutomatedDealer = false;
                  
               }*/
               
             system.debug('claimsRec.Dealer_Service_Job__c-->'+claimsRec.Dealer_Service_Job__c);
             system.debug('claimsRec.CSS_Job__c-->'+claimsRec.CSS_Job__c);
            // system.debug('claimsRec.Account__r.Type-->'+claimsRec.Account__r.Type);
             if(DealerTypeFlag1 == true && urRole.name == 'Factory'){
                 if(claimsRec.Dealer_Service_Job__c != null || claimsRec.CSS_Job__c != null){ 
                     isAutomatedDealer = true;
                 }
                 else{
                     isManualDealer = true;
                 }
             }
             else{
                 system.debug('**isAutomatedDealer else ***'+isAutomatedDealer);
                 system.debug('claimsRec.Dealer_Service_Job__c'+claimsRec.Dealer_Service_Job__c);
                 system.debug('claimsRec.Account__r.Type'+claimsRec.Account__r.Type);
                 isAutomatedDealer = false;
             }
             //Added condition for Factory user Dealer loction Manual claim #174459
             if((claimsRec.Dealer_Service_Job__c ==null && claimsRec.CSS_Job__c==null) && DealerTypeFlag1 && urRole.name == 'Factory'){
                  system.debug('******inside if for Manual claim***');
               isManualDealer = true;   
             }
             else{
                 system.debug('******inside else for Manual claim***');
                isManualDealer = false;
             }
         }
          //GSSC-240
         previousPSN = (psnRec != null ? psnRec.PSN__c : '');
            startRequestCalled = false;
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsIntake constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('returning from CG_CL_ClaimsIntake constructor...');
        System.debug('Total Number of SOQL Queries in claimsintake constructor End: ' + Limits.getQueries());

        isDealer = false;
        string userType = css_Utility.getOrgType(userinfo.getUserId());
        //string userType = css_Utility.getOrgAccType(userinfo.getUserId());
        system.debug('***userType*'+userType);
        if(userType !=null && userType != '') {
            if(userType == 'DLR') {
                isDealer = true;
                system.debug('*inside if isDealer*'+isDealer);
            }
            else if(userType == 'DISTR') {
                isDealer = false;
                system.debug('*inside else if isDealer*'+isDealer);
            }
        }
    }

    public void uncheckPopupsave()
    {

        claimsRec.Information_Only_Claim__c = False;
        update claimsRec;
    }


    public void checkPopupsave()
    {

        FailuresList = new List<CSS_Solution_Component__c>();
        octtmllist= new List<CSS_Parts_Options__c>();
        adminsrtlist = new List<CSS_SRT__c>();
        
        updateFailuresList = new List<CSS_Solution_Component__c>();
        updatepartslist = new List<CSS_Parts_Options__c>();
        updatesrtlist = new List<CSS_SRT__c>();
        updateocttmllist = new List<CSS_Parts_Options__c>();
        updateadminsrtlist = new List<CSS_SRT__c>();
        system.debug('****claimsRec***'+claimsRec);
        if(cId !=null){
            claimsRec.Information_Only_Claim__c = True;
            update claimsRec;

            if(claimsRec.Information_Only_Claim__c == True)
            {
               // FailuresList =[Select id, name, Failure_Mode__C,CSS_Account_Formula__c, AccountCodeType__c, AccountCodeEdit__c, Selected_Component__c, Claims_Failure_Select__c, Solutions__c, Solutions__r.Service_Job__c,Solutions__r.FaultCode__r.Name, Solutions__r.FaultCode__r.RelatedFaultCode__c,Solutions__r.Symptom__r.Name,Solutions__r.Symptom__c, Service_Job__c, CSS_Claims__c, AccountCode__c, System_Code__c, Component_Code__c, Pay_Code__c, Claim_Type__c from CSS_Solution_Component__c where CSS_Claims__c =: cId and Selected_Component__c = true and type__C NOT IN ('TSB', 'TRP','ATC','Campaign')];
                FailuresList =[Select id, name, Failure_Mode__C,CSS_Account_Formula__c, AccountCodeType__c, AccountCodeEdit__c, Selected_Component__c, Claims_Failure_Select__c, Solutions__c, Solutions__r.Service_Job__c,Solutions__r.FaultCode__r.Name, Solutions__r.FaultCode__r.RelatedFaultCode__c,Solutions__r.Symptom__r.Name,Solutions__r.Symptom__c, Service_Job__c, CSS_Claims__c, AccountCode__c, System_Code__c, Component_Code__c, Pay_Code__c,(select id,name,Account_Code__c from CSS_Parts_Options__r), (select id,name,Account_Code__c from CSS_SRTs__r),Claim_Type__c from CSS_Solution_Component__c where CSS_Claims__c =:cId];
                system.debug('FailuresList'+FailuresList);
                if(FailuresList != null && FailuresList.size() > 0)
                {
                    for(CSS_Solution_Component__c SolComp:FailuresList)
                    {
                       
                        SolComp.Pay_Code__c = 'A';
                       // commented if condition as part of story.GSSC-68
                      //  if(SolComp.CSS_Account_Formula__c == null || SolComp.CSS_Account_Formula__c =='')// (SolComp.AccountCodeEdit__c == null && SolComp.AccountCodeEdit__c == ''))
                            SolComp.AccountCode__c ='NEW PRODUCT WARRANTY 67';
                            SolComp.AccountCodeEdit__c='NEW PRODUCT WARRANTY 67';
                            SolComp.AccountCodeType__c='';
                       // updateFailuresList.add(SolComp);
                        for(CSS_Parts_Options__c partsOp:SolComp.CSS_Parts_Options__r){
                            partsOp.Account_Code__c ='NEW PRODUCT WARRANTY 67';
                            updatepartslist.add(partsOp);
                            
                        }
                        for(CSS_SRT__c srtslist:SolComp.CSS_SRTs__r){
                            srtslist.Account_Code__c ='NEW PRODUCT WARRANTY 67';
                            srtslist.Account_Code_Description__c='NEW PRODUCT WARRANTY 67';
                            updatesrtlist.add(srtslist);
                            
                            
                        }
                         updateFailuresList.add(SolComp);
                    }
                    
                    
                }
                octtmllist = [select Id,name,Account_Code__c from CSS_Parts_Options__c where CSS_Claims__c=:cId and (RecordType.Name ='OtherClaimables' or RecordType.Name ='TTML' or RecordType.Name ='Parts' )];
                if(octtmllist != null && octtmllist.size()>0){
                    for(CSS_Parts_Options__c octtml :octtmllist){
                        octtml.Account_Code__c='NEW PRODUCT WARRANTY 67';
                        updateocttmllist.add(octtml); 
                    }
                }
                adminsrtlist =[select id,name,srt_id__c,Account_Code__c,Account_Code_Description__c from css_srt__c where CSS_Claims__c=:cId  and (type__c ='admin' or type__c ='99Time')];
                if(adminsrtlist != null && adminsrtlist.size()>0){
                    
                    for(CSS_SRT__c adminsrt :adminsrtlist){
                        adminsrt.Account_Code__c ='NEW PRODUCT WARRANTY 67';
                        adminsrt.Account_Code_Description__c ='NEW PRODUCT WARRANTY 67';
                        
                        updateadminsrtlist.add(adminsrt);
                        
                    }
                }
                if(updateFailuresList != null && updateFailuresList.size() >0)
                    update updateFailuresList;
                    update updatesrtlist;
                    update updatepartslist;
                    if(updateocttmllist !=null && updateocttmllist.size()>0){
                        update updateocttmllist;
                    }
                    if(updateadminsrtlist !=null && updateadminsrtlist.size()>0){
                        update updateadminsrtlist;
                    }
            }
        }
        else {
            Information =true;
            claimsRec.Information_Only_Claim__c = true;
        }

    }
    //Page Loading Action.
    public void pageAction()
    {
        System.debug('IN CG_CL_ClaimsIntake pageAction method...');
        system.debug('****dealerUser****'+dealerUser);
        try {
            //Assigning saved values on page load
            mil_measure = 'Miles';
            if(claimsRec.Email_Address__c != null && claimsRec.Email_Address__c != '' && claimsRec.Email_Address__c.contains('@')) {
                string[] emails = claimsRec.Email_Address__c.split('@');
                EmailAddress = emails[0];
                EmailAddress1 = emails[1];
                system.debug(EmailAddress + ' ------------ ' + EmailAddress1);
            }
            if (psnRec.Unit_Type__c ==null || psnRec.Unit_Type__c =='----None----' || psnRec.Unit_Type__c ==''){
                filterUnitType = '';
            }else{
                filterUnitType = psnRec.Unit_Type__c;
            }
            if (psnRec.Application__c==null || psnRec.Application__c=='----None----' || psnRec.Application__c==''){
                filterApplication = '----None----';}
            else{
                filterApplication = psnRec.Application__c;
            }
            if (psnRec.Make__c==null || psnRec.Make__c==''){
                filterMake = '----None----';
            }else{
                filterMake = psnRec.Make__c;
            }
            if (psnRec.Model__c==null || psnRec.Model__c==''){
                filterModel = '----None----';
            }else{
                filterModel = psnRec.Model__c;
            }
            if (psnRec.Mileage_Measure__c==null || psnRec.Mileage_Measure__c==''){
                mil_measure = 'Miles';
            } else{
                mil_measure = psnRec.Mileage_Measure__c;
            }
            if (psnRec.Mileage_Measure__c==null || psnRec.Mileage_Measure__c==''){
                mil_measure = 'Miles';
            } else{
                mil_measure = psnRec.Mileage_Measure__c;
            }
            datebyLocaleValue = css_utility.getFormattedDate();
            userObj = css_utility.getUserAttributes(Userinfo.getUserId());
            //accountlang = css_utility.getLanguage(userObj.LanguageLocaleKey);
            
           //Story 429
            if(claimsRec.CSS_Job__c != null || claimsRec.Dealer_Service_Job__c != null){
                Boolean allInShopYesFlag = false;
                Boolean allFailuresFlag = true;
                system.debug('Inside Auto AdminSRT'+solComps);
                /* START Query Optimization By Krishna on Jan 27th 2020. */
                if(solComps != null && solComps.size() >0 && claimsRec !=null )  {
                    CG_CL_ClaimsFC claimsFC = new CG_CL_ClaimsFC();
                    claimsFC.upsertAdminSRT(claimsRec,solComps,allInShopYesFlag,allFailuresFlag);
                }
                /*CG_CL_ClaimsFC claimsFC = new CG_CL_ClaimsFC();
               if(solComps != null && solComps.size() >0 && claimsRec !=null ) 
               claimsFC.upsertAdminSRT(claimsRec,solComps,allInShopYesFlag,allFailuresFlag);
               */
               
               /* START Query Optimization By Krishna on Jan 27th 2020. */
                
            }
             
            //
            
            
            //Added as part of the story #179800
            if(claimsRec.CSS_Job__c != null || claimsRec.Dealer_Service_Job__c != null){
                CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
                contr.covLimitValidation(null, cId, null, null);
            }
            //Added as part of the story #178812
            if(claimsRec.CSS_Job__c != null || claimsRec.Dealer_Service_Job__c != null){
                CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
                contr.checkFailuresCovered(cId, true);
            }
            ///////////////////////////////
           /* CG_CL_CoverageLimitExceedValidation validatoncontroller = new  CG_CL_CoverageLimitExceedValidation(); 
            validatoncontroller.covLimitValidationTTML(null,cId,null,true);*/
            
            //CG_CL_CoverageLimitExceedValidation validatoncontroller = new  CG_CL_CoverageLimitExceedValidation();
           /* CG_CL_CoverageLimitExceedValidation_TTML validatoncontroller = new  CG_CL_CoverageLimitExceedValidation_TTML();
            validatoncontroller.covLimitValidationTTML(null,cId,null,true);*/
            
            
            
            //////////////////////////////
            // ************************ below code for calling  covLimitValidationSRT Method as per story #179802 Aladdin sprint,-By RAJESH 04 Apr 2019 
              if((claimsRec.CSS_Job__c != null || claimsRec.Dealer_Service_Job__c != null) && dealerUser==true){  
                CG_CL_CoverageLimitExceedValidation callingSRTClaimedHour= new CG_CL_CoverageLimitExceedValidation();
                  system.debug('****class called above method****');
                  callingSRTClaimedHour.covLimitValidationSRT(null,cId);
                  system.debug('****called above method****');
                  callingSRTClaimedHour.covLimitfailcodeValidation (null,cId);
                  callingSRTClaimedHour.covLimitValidationTTML(null,cId,null,true);
              }
  // *******************************End code for calling  covLimitValidationSRT Method as per story #179802 Aladdin sprint,-By RAJESH 04 Apr 2019

        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsIntake pageAction method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('returning from CG_CL_ClaimsIntake-pageAction method...');
        if(cId != null){
            multipsnchecbox();
            //if(claimsRec.css_job__c!=null || claimsRec.Dealer_Service_Job__c!=null)
            //system.debug('claimsRec'+claimsRec+'claimsRec.css_job__c'+claimsRec.css_job__c+claimsRec.Dealer_Service_Job__c);
            if(claimsRec!=null && (claimsRec.css_job__c!=null || claimsRec.Dealer_Service_Job__c!=null))
                callgetCampaigns();
        }
    }

    //calling getCampaigns method from CG_BL_Intake inorder to update authorization field for automatedclaim
    public void callgetCampaigns()
    {
        //String sServiceModel;
        LIst<CSS_Accreditation__c> accredList = new List<CSS_Accreditation__c>();
        CSS_accountLanguage__c accountlang = css_utility.getLanguage(userObj.LanguageLocaleKey);
        system.debug('psnRec.Failure_Date__c'+psnRec.Failure_Date__c);
        if(psnRec.Failure_Date__c !=null){
            //List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getCampaigns(psnRec.PSN__c, psnRec.Service_Model__c,psnRec.Failure_Date__c, accountlang.CSS_QsolLanguage__c,psnRec.Id);
            try{
                //system.debug('campaignsLi'+campaignsList);
                //system.debug('campaignsList size'+campaignsList.size());
               // if(campaignsList !=null && campaignsList.size()>=5){
                    //if(campaignsList.get(5).get(0).Type__c=='SPData'){
                        if(userObj.User_Location__c != null)
                            accredList = [SELECT id, EndDate__c,Service_Model_Name__c,StartDate__c,Account__c,Account__r.Location__c FROM CSS_Accreditation__c where Account__r.Location__c =: userObj.User_Location__c];
                       // CSS_GetServiceProviderResponse outputRes = (CSS_GetServiceProviderResponse)JSON.deserializeStrict(campaignsList.get(5).get(0).Name, CSS_GetServiceProviderResponse.class);
                        
                        String selectedLocation;
                        selectedLocation = claimsRec.Location_Code__c;
                        if(selectedLocation==null || selectedLocation==''){
                            selectedLocation = ([select Id,User_Location__c,FederationIdentifier,LanguageLocaleKey from User where id=:UserInfo.getUserId() LIMIT 1]).User_Location__c;
                        }
                        String spCode = selectedLocation.trim().right(5); //take last 5 digits here
                        system.debug('first spCode>:'+spCode);
                        spCode = spCode.trim();
                        
                        String failureDateStr = DateTime.newInstance(psnRec.Failure_Date__c.year(),psnRec.Failure_Date__c.month(),psnRec.Failure_Date__c.day()).format('dd-MMM-YY');
                        System.debug('failureDateStr>>>:'+failureDateStr+' spCode>>:'+spCode);
                        
                        CSS_GetServiceProviderResponse outputRes = CSS_FN_SIEBEL.getServiceProviderDataWrapper(spCode.trim(), '', failureDateStr,claimsRec.Name);
                        
                        Boolean isActive = true;
                        Boolean dupSMNisActive;
                        Date warrantyCertDate;
                        Map<String,List<CSS_Accreditation__c>> accredMap = new Map<String,List<CSS_Accreditation__c>>();
                        Set<String> smnSet = new Set<String>();
                        List<CSS_Accreditation__c> accList = new List<CSS_Accreditation__c>();
                        warrantyCertDate = Date.valueOf(claimsRec.SP_WarrantyCertificationEndDate__c) +180;
                        system.debug('accredList'+accredList);
                        for(CSS_Accreditation__c accredObj:accredList){
                            smnSet.add(accredObj.Service_Model_Name__c);
                            if(!accredMap.containsKey(accredObj.Service_Model_Name__c)){
                                accredMap.put(accredObj.Service_Model_Name__c,new List<CSS_Accreditation__c>());
                            }
                            accredMap.get(accredObj.Service_Model_Name__c).add(accredObj);
                        }
                        for(String s:accredMap.keySet()){
                            dupSMNisActive = false;
                            accList=accredMap.get(s);
                            if(isActive==false){
                                break;
                            }

                            for(CSS_Accreditation__c accredObj: accList){
                                if((psnRec.Failure_Date__c >= accredObj.StartDate__c && psnRec.Failure_Date__c <= accredObj.EndDate__c)){
                                    dupSMNisActive=true;
                                    break;
                                }
                                else{
                                    dupSMNisActive=false;
                                    if(dupSMNisActive == false && accList.size()==1){
                                        isActive=false;
                                    }
                                }
                            }

                        }

                        //163193
                        system.debug('isActive'+isActive);
                        if(outputRes!=null){
                        claimsRec.SPDataWebserviceResult__c='Success';
                        system.debug('outputRes.DataArea.WarrantyTrainingCertification********' + outputRes.DataArea.WarrantyTrainingCertification);
                        if(outputRes.DataArea.WarrantyTrainingCertification == 'N'){
                            system.debug('Not Applicable');
                            claimsRec.Warranty_Authorization_Flag__c = 'Not Applicable';
                        }
                       else if(outputRes.DataArea.WarrantyTrainingCertification == 'Y' && (claimsRec.SP_WarrantyTrainingStatus__c != 'R' && claimsRec.SP_WarrantyTrainingStatus__c != Null && claimsRec.SP_WarrantyTrainingStatus__c != '')){//!='R' && != '' && != null
                            system.debug('Certified');
                            claimsRec.Warranty_Authorization_Flag__c = 'Certified';
                        }else if(outputRes.DataArea.WarrantyTrainingCertification == 'Y' && (claimsRec.SP_WarrantyTrainingStatus__c == 'R' || claimsRec.SP_WarrantyTrainingStatus__c == Null || claimsRec.SP_WarrantyTrainingStatus__c == '') && (psnRec.Failure_Date__c > warrantyCertDate || warrantyCertDate == Null)){// == 'R' || == '' || == null
                            system.debug('Not Certified');
                            claimsRec.Warranty_Authorization_Flag__c = 'Not Certified';
                        }else{
                            system.debug('Certified');
                            claimsRec.Warranty_Authorization_Flag__c = 'Certified';
                        }
                        //Added authorized logic condition for the defect#172041
                        if((claimsRec.CSS_Job__c!='' || claimsRec.Dealer_Service_Job__c!='')&& (claimsRec.Pending_Authorization__c=='--None--' || claimsRec.Pending_Authorization__c==''|| claimsRec.Pending_Authorization__c==null)){
                        if(outputRes.DataArea.ProductCertification =='Y'  && claimsRec.Pending_Authorization__c!='Authorized'){
                            //Use Case 1
                            if(isActive == true && (psnRec.Failure_Date__c <= warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y')){
                                claimsRec.Pending_Authorization__c = 'Not Applicable';
                            }
                            //Use Case 2
                            else if(isActive == false && (psnRec.Failure_Date__c <= warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y')){
                                claimsRec.Pending_Authorization__c = 'Authorization Required';
                            }
                            // Use Case 3
                            else if(isActive == true && (psnRec.Failure_Date__c > warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y')){
                                claimsRec.Pending_Authorization__c = 'Authorization Required';
                            }
                            //Use Case 4
                            else if(isActive == false && (psnRec.Failure_Date__c > warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y')){
                                claimsRec.Pending_Authorization__c = 'Authorization Required';
                            }
                            //use case 7
                            else if(isActive == true && (claimsRec.SP_WarrantyTrainingStatus__c == 'R' || claimsRec.SP_WarrantyTrainingStatus__c == Null || claimsRec.SP_WarrantyTrainingStatus__c =='')){ //claimsRec.SP_WarrantyTrainingStatus__c == 'N')
                                claimsRec.Pending_Authorization__c = 'Not Applicable';
                            }
                            //use case 8
                            else if(isActive == false && (claimsRec.SP_WarrantyTrainingStatus__c == 'R' || claimsRec.SP_WarrantyTrainingStatus__c == Null || claimsRec.SP_WarrantyTrainingStatus__c == '')){
                                claimsRec.Pending_Authorization__c = 'Authorization Required';
                            }
                        }
                        //Added authorized logic condition for the defect#172041
                        else if(outputRes.DataArea.ProductCertification =='N'  && claimsRec.Pending_Authorization__c!='Authorized'){
                            //Use Case 5
                            if(psnRec.Failure_Date__c > warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y'){
                                claimsRec.Pending_Authorization__c = 'Authorization Required';
                            }
                            //Use Case 6
                            else if(psnRec.Failure_Date__c <= warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y'){
                                claimsRec.Pending_Authorization__c = 'Not Applicable';
                            }
                            //Use Case 9
                            else if(outputRes.DataArea.WarrantyTrainingCertification == 'N'){
                                claimsRec.Pending_Authorization__c = 'Not Applicable';
                            }

                        }
                        system.debug('****claimsRec.Pending_Authorization__c**'+claimsRec.Pending_Authorization__c);

                  //  }
                    
                  //  }
                        }
                        else
                            claimsRec.SPDataWebserviceResult__c='Error';
                }
                if(claimsRec.Pending_Authorization__c!=null){

                    update claimsRec;
                }
            }
            catch(Exception e){
                system.debug('EXCEPTION of CSS_GetServiceProviderResponse convertion CG_CL_ClaimsUEOneBMS  >>>:'+e.getMessage() + ' Line No>>>:' + e.getLineNumber() + ' Cause>>:' +e.getCause());
            }

        }
    }

    public boolean warrantyStartDateValidate {get; set;}
    //Naviagation to Warranty Coverage.
    public PageReference nvClaimsWC(){
        PageReference pageRef;
        system.debug('in nvClaimsWC method...cId>>>:'+cId);
        system.debug('showErrorPopup>>>>'+showErrorPopup);
        system.debug('claimsRec'+claimsRec);
        //GSSC-240, hard stop the navigation if Service Model is null
        //psnRec.Service_Model__c = ''; //for Testing 
        if(psnRec.Service_Model__c == null || psnRec.Service_Model__c == ''){
        return null;}
        //Added this logic from save method to here start Defect 191861
         if(((psnRec.Calibration_Before__c != '' && psnRec.Calibration_Before__c != null) || (psnRec.Calibration_After__c != '' && psnRec.Calibration_After__c != null)) && (psnRec.Justification__c == '----Select One----')){
                justficationErrMsg =true;
                system.debug('InsideIF**');
                return null;   
            }
            else{
                justficationErrMsg = false;system.debug('InsideELSE**');}
            system.debug('justficationErrMsg**'+justficationErrMsg);
            //Added this logic from save method to here End Defect 191861
        if(claimsRec!= null && claimsRec.Status__c != 'Submitted' && claimsRec.Status__c != 'Not Authorized'){
            if(isPaccarAutoClaim != true){
                cId = saveClaim(cId, 'Draft');
            }
            else if(isPaccarAndPW == 'true'){  //Added as part of the story GSSC-71
                cId = saveClaim(cId, 'Draft');
            }
        }
        System.debug('in nvClaimsWC method...cIdaftersave>>>:'+cId);
        pageName='CG_ClaimsWarranty';
        if(cId==null){
            return null;
        }
        else{ //venkat Added the below code for Gap sprint #148104 
            claimNewRecUpd = [SELECT Id, PACCAR_Flag__c,ODM_Status__c, PACCAR_Auth_Required__c, Parts_Warranty_Claim_Only__c, Dealer_Service_Job__c, CSS_Job__c, Css_paccar_approve_reject_flag__c FROM CSS_Claims__c WHERE Id =: cId];
            
            if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (isPaccarAutoClaim == true && isPaccarAndPW != 'true') && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                pageRef.setRedirect(true); 
            }
            else if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                pageRef.setRedirect(true);
            }
           
            else{
                 if(claimNewRecUpd.ODM_Status__c == 'ERROR'){
                    showErrorPopup = true;
                     system.debug('showErrorPopup ODM Status__c>>' + showErrorPopup);
                }
                else{
                    showErrorPopup = false;
                }
                if(showErrorPopup==true){
                     system.debug('inside showErrorPopup Status>>>' + showErrorPopup);
                    return null;
                }
                else{
                    if(warrantyStartDateValidate == true){
                        return null;
                    }
                     /*Story#183077*/
                    else if(claimsRec.CG_Get_Engine_data_flag__c!=null && claimsRec.CG_Get_Engine_data_flag__c)
                      {
                      return null;
                       }
                     /*end*/
                    else{
                        pageRef = new pageReference('/apex/CG_ClaimsWarranty?id='+cId); 
                        system.debug('testing else');
                    }
                }
            }
        }
        return pageRef;
    }

    //Naviagation to View History.
    public PageReference nvClaimsVH(){
        PageReference pageRef;
        System.debug('in nvClaimsVH method...cIdbeforesave>>>:'+cId);
        //if(cId != null){
        //showErrorPopup = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',null,'WarrantyOverview');

        //}
        //GSSC-240, hard stop the navigation if Service Model is null
        if(psnRec.Service_Model__c == null || psnRec.Service_Model__c == ''){
        return null;}
           //Added this logic from save method to here start Defect 191861
         if(((psnRec.Calibration_Before__c != '' && psnRec.Calibration_Before__c != null) || (psnRec.Calibration_After__c != '' && psnRec.Calibration_After__c != null)) && (psnRec.Justification__c == '----Select One----')){
                justficationErrMsg =true;
                system.debug('InsideIF**');
                return null;   
            }
            else{
                justficationErrMsg = false;system.debug('InsideELSE**');}
            system.debug('justficationErrMsg**'+justficationErrMsg);
            //Added this logic from save method to here End Defect 191861
        if(claimsRec!= null && claimsRec.Status__c != 'Submitted' && claimsRec.Status__c != 'Not Authorized'){
            if(isPaccarAutoClaim != true){
                cId = saveClaim(cId, 'Draft');
            }
            else if(isPaccarAndPW == 'true'){  //Added as part of the story GSSC-71
                cId = saveClaim(cId, 'Draft');
            }
        }
        System.debug('in nvClaimsVH method...cIdaftersave>>>:'+cId);
        pageName='CG_ClaimsVH';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service

        //showErrorPopup=true;
        //if(isWarrCustomer!=true){
                system.debug('inside main if ****');    
        if(cId==null){
            system.debug('inside main if in if ****');
            //check if validation is failing
            //if(justficationErrMsg == true || warrantyStartDateValidate == true)
                return null;
            //pageRef = new pageReference('/apex/CG_ClaimsVH'); 
            system.debug('testing IF');

        }
        else{
            system.debug('inside main if else 888888else');
            claimNewRecUpd = [SELECT Id, PACCAR_Flag__c,ODM_Status__c, PACCAR_Auth_Required__c, Parts_Warranty_Claim_Only__c, Dealer_Service_Job__c, CSS_Job__c, Css_paccar_approve_reject_flag__c FROM CSS_Claims__c WHERE Id =: cId];
            if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (isPaccarAutoClaim == true && isPaccarAndPW != 'true') && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                    pageRef.setRedirect(true); 
            }
            else if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                pageRef.setRedirect(true);
            }
            
            else{
                if(claimNewRecUpd.ODM_Status__c == 'ERROR')
                    showErrorPopup = true;
                else
                    showErrorPopup = false;
    
                if(showErrorPopup==true)
                {
                    return null;
                }else{
                    System.debug('in nvClaimsVH method in else 1...cIdaftersave>>>:'+cId);
                    if(warrantyStartDateValidate == true){
                        System.debug('in nvClaimsVH method in if1...cIdaftersave>>>:'+cId);
                        return null;
                    }
                    /*Story#183077*/
                    else if(claimsRec.CG_Get_Engine_data_flag__c!=null && claimsRec.CG_Get_Engine_data_flag__c)
                      {
                      return null;
                       }
                     /*end*/
                    else{
                        System.debug('in nvClaimsVH method in else2...cIdaftersave>>>:'+cId);
                        pageRef = new pageReference('/apex/CG_ClaimsVH?id='+cId); 
                    }
                }
            }
        }
        
        /*}
        else{
            system.debug('inside main else****');
            
            if(cId==null){
             system.debug('inside if***');
             pageRef = new pageReference('/apex/CG_ClaimsIntake');}
            else{
               system.debug('inside sub else***'); 
             pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);}   }*/

        
        return pageRef;
 
        
    }

    //Naviagation to Customer Complaint.
    public PageReference nvClaimsCC(){
        PageReference pageRef;
        //if(cId != null){
        //showErrorPopup = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',null,'WarrantyOverview');

        //}
        //GSSC-240, hard stop the navigation if Service Model is null
        if(psnRec.Service_Model__c == null || psnRec.Service_Model__c == ''){
        return null;}
           //Added this logic from save method to here start Defect 191861
         if(((psnRec.Calibration_Before__c != '' && psnRec.Calibration_Before__c != null) || (psnRec.Calibration_After__c != '' && psnRec.Calibration_After__c != null)) && (psnRec.Justification__c == '----Select One----')){
                justficationErrMsg =true;
                system.debug('InsideIF**');
                return null;   
            }
            else{
                justficationErrMsg = false;system.debug('InsideELSE**');}
            system.debug('justficationErrMsg**'+justficationErrMsg);
            //Added this logic from save method to here End Defect 191861
        if(claimsRec!= null && claimsRec.Status__c != 'Submitted' && claimsRec.Status__c != 'Not Authorized'){
            if(isPaccarAutoClaim != true){
                cId = saveClaim(cId, 'Draft');
            }
            else if(isPaccarAndPW == 'true'){  //Added as part of the story GSSC-71
                cId = saveClaim(cId, 'Draft');
            }
        }
        pageName='CG_ClaimsCC';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service

        //showErrorPopup=true;
//if(isWarrCustomer!=true){
        if(cId==null){
            //if(justficationErrMsg == true || warrantyStartDateValidate == true)
                return null;
            //pageRef = new pageReference('/apex/CG_ClaimsCC'); 
        }
        else{
            if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){ //Defect fix: 154159
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); }
            else{
                // pageRef = new pageReference('/apex/CG_ClaimsCC?id='+cId); 
                claimNewRecUpd = [SELECT Id, PACCAR_Flag__c,ODM_Status__c, PACCAR_Auth_Required__c, Parts_Warranty_Claim_Only__c, Dealer_Service_Job__c, CSS_Job__c, Css_paccar_approve_reject_flag__c FROM CSS_Claims__c WHERE Id =: cId];
            if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (isPaccarAutoClaim == true && isPaccarAndPW != 'true') && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                    pageRef.setRedirect(true); 
            }
            else if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                pageRef.setRedirect(true);
            }else{
                if(claimNewRecUpd.ODM_Status__c == 'ERROR')
                    showErrorPopup = true;
                else
                    showErrorPopup = false;

                if(showErrorPopup==true)
                {
                    return null;
                }else{
                    if(warrantyStartDateValidate == true)
                        return null;
                    /*Story#183077*/
                    else if(claimsRec.CG_Get_Engine_data_flag__c!=null && claimsRec.CG_Get_Engine_data_flag__c)
                      {
                      return null;
                       }
                     /*end*/
                    else{
                        /*  if(claimsRec.Status__c == 'Submitted'){
    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); }
    else{
    pageRef = new pageReference('/apex/CG_ClaimsCC?id='+cId); 
    }*/

                        pageRef = new pageReference('/apex/CG_ClaimsCC?id='+cId); 
                    }
                }
            }

        }
        }
   /* }
    else{
            system.debug('inside main else****');
            
            if(cId==null){
             system.debug('inside if***');
             pageRef = new pageReference('/apex/CG_ClaimsIntake');}
            else{
               system.debug('inside sub else***'); 
             pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);}   } */

        
        return pageRef;
    }

    //Naviagation to Failures and Campaigns.
    public PageReference nvClaimsFC(){
        PageReference pageRef;
        //if(cId != null){
        //showErrorPopup = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',null,'WarrantyOverview');

        //}
        //GSSC-240, hard stop the navigation if Service Model is null
        if(psnRec.Service_Model__c == null || psnRec.Service_Model__c == ''){
        return null;}
           //Added this logic from save method to here start Defect 191861
         if(((psnRec.Calibration_Before__c != '' && psnRec.Calibration_Before__c != null) || (psnRec.Calibration_After__c != '' && psnRec.Calibration_After__c != null)) && (psnRec.Justification__c == '----Select One----')){
                justficationErrMsg =true;
                system.debug('InsideIF**');
                return null;   
            }
            else{
                justficationErrMsg = false;system.debug('InsideELSE**');}
            system.debug('justficationErrMsg**'+justficationErrMsg);
            //Added this logic from save method to here End Defect 191861
        if(claimsRec!= null && claimsRec.Status__c != 'Submitted' && claimsRec.Status__c != 'Not Authorized'){
            if(isPaccarAutoClaim != true){
                cId = saveClaim(cId, 'Draft');
            }
            else if(isPaccarAndPW == 'true'){  //Added as part of the story GSSC-71
                cId = saveClaim(cId, 'Draft');
            }
        }
            pageName='CG_ClaimsFC';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service

        //showErrorPopup=true;
//if(isWarrCustomer!=true){
        if(cId==null){
            //if(justficationErrMsg == true || warrantyStartDateValidate == true)
                return null;
            //pageRef = new pageReference('/apex/CG_ClaimsFC'); 
        }else{
            claimNewRecUpd = [SELECT Id, PACCAR_Flag__c,ODM_Status__c, PACCAR_Auth_Required__c, Parts_Warranty_Claim_Only__c, Dealer_Service_Job__c, CSS_Job__c, Css_paccar_approve_reject_flag__c FROM CSS_Claims__c WHERE Id =: cId];
            if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (isPaccarAutoClaim == true && isPaccarAndPW != 'true') && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                    pageRef.setRedirect(true); 
            }
            else if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                pageRef.setRedirect(true);
            }
            else{
                if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'  && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){ //Defect fix: 154159
                    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); }
                else{
    
                    if(claimNewRecUpd.ODM_Status__c == 'ERROR')
                        showErrorPopup = true;
                    else
                        showErrorPopup = false;
                    if(showErrorPopup==true)
                    {
                        return null;
                    }else{
                        if(warrantyStartDateValidate == true)
                            return null;
                        /*Story#183077*/
                    else if(claimsRec.CG_Get_Engine_data_flag__c!=null && claimsRec.CG_Get_Engine_data_flag__c)
                      {
                      return null;
                       }
                     /*end*/
                        else{
                            pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId); 
                        }
                    }
                }
            }
        }
   /* }
        else{
            system.debug('inside main else****');
            
            if(cId==null){
             system.debug('inside if***');
             pageRef = new pageReference('/apex/CG_ClaimsIntake');}
            else{
               system.debug('inside sub else***'); 
             pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);}   } */

        
        return pageRef;
    }
    //Naviagation to Multi PSN.
    //Added below Method as per Silicon Valley sprint #154239 -By RAJESH 20th Aug 2018 
    public PageReference nvClaimsPSN(){
        //GSSC-240, hard stop the navigation if Service Model is null
        if(psnRec.Service_Model__c == null || psnRec.Service_Model__c == ''){
        return null;}
           //Added this logic from save method to here start Defect 191861
         if(((psnRec.Calibration_Before__c != '' && psnRec.Calibration_Before__c != null) || (psnRec.Calibration_After__c != '' && psnRec.Calibration_After__c != null)) && (psnRec.Justification__c == '----Select One----')){
                justficationErrMsg =true;
                system.debug('InsideIF**');
                return null;   
            }
            else{
                justficationErrMsg = false;system.debug('InsideELSE**');}
            system.debug('justficationErrMsg**'+justficationErrMsg);
            //Added this logic from save method to here End Defect 191861
        PageReference pageRef;
        if(claimsRec!= null && claimsRec.Status__c != 'Submitted' && claimsRec.Status__c != 'Not Authorized'){
            if(isPaccarAutoClaim != true){
                cId = saveClaim(cId, 'Draft');
            }
            else if(isPaccarAndPW == 'true'){  //Added as part of the story GSSC-71
                cId = saveClaim(cId, 'Draft');
            }
        }
            pageName='CG_ClaimsMultiPSN';
         //if(isWarrCustomer!=true){
        if(cId==null){
            //if(justficationErrMsg == true || warrantyStartDateValidate == true)
                return null;
            //pageRef = new pageReference('/apex/CG_ClaimsMultiPSN'); 
        }else{
            claimNewRecUpd = [SELECT Id, PACCAR_Flag__c, ODM_Status__c, PACCAR_Auth_Required__c, Parts_Warranty_Claim_Only__c, Dealer_Service_Job__c, CSS_Job__c, Css_paccar_approve_reject_flag__c FROM CSS_Claims__c WHERE Id =: cId];
            if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (isPaccarAutoClaim == true && isPaccarAndPW != 'true') && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                    pageRef.setRedirect(true); 
            }
            else if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                pageRef.setRedirect(true);
            }
            else{
                if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized' && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){ 
                    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); }
                else{
    
                    if(claimNewRecUpd.ODM_Status__c == 'ERROR')
                        showErrorPopup = true;
                    else
                        showErrorPopup = false;
                    if(showErrorPopup==true)
                    {
                        return null;
                    }else{
                        if(warrantyStartDateValidate == true)
                            return null;
                         /*Story#183077*/
                       else if(claimsRec.CG_Get_Engine_data_flag__c!=null && claimsRec.CG_Get_Engine_data_flag__c)
                        {
                          return null;
                        }
                     /*end*/
                        else{
                            pageRef = new pageReference('/apex/CG_ClaimsMultiPSN?id='+cId); 
                        }
                    }
                }
            }
        }
  /*  }
         else{
            system.debug('inside main else****');
            
            if(cId==null){
             system.debug('inside if***');
             pageRef = new pageReference('/apex/CG_ClaimsIntake');}
            else{
               system.debug('inside sub else***'); 
             pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);}   } */
        return pageRef;
    }

    public void nvClaimsMulti_PSN()
    {

    }

    //Naviagation to Parts and Other Claimbles.
    public PageReference nvClaimsPOC(){
        //GSSC-240, hard stop the navigation if Service Model is null
        if(psnRec.Service_Model__c == null || psnRec.Service_Model__c == ''){
        return null;}
           //Added this logic from save method to here start Defect 191861
         if(((psnRec.Calibration_Before__c != '' && psnRec.Calibration_Before__c != null) || (psnRec.Calibration_After__c != '' && psnRec.Calibration_After__c != null)) && (psnRec.Justification__c == '----Select One----')){
                justficationErrMsg =true;
                system.debug('InsideIF**');
                return null;   
            }
            else{
                justficationErrMsg = false;system.debug('InsideELSE**');}
            system.debug('justficationErrMsg**'+justficationErrMsg);
            //Added this logic from save method to here End Defect 191861
        PageReference pageRef;
        // if(cId != null){
        //showErrorPopup = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',null,'WarrantyOverview');
        //   }
        if(claimsRec!= null && claimsRec.Status__c != 'Submitted' && claimsRec.Status__c != 'Not Authorized'){
            if(isPaccarAutoClaim != true){
                cId = saveClaim(cId, 'Draft');
            }
            else if(isPaccarAndPW == 'true'){  //Added as part of the story GSSC-71
                cId = saveClaim(cId, 'Draft');
            }
        }
            pageName='CG_ClaimsPartsandOtherClaimbles';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service

        //showErrorPopup=true;
        //if(isWarrCustomer!=true){
        if(cId==null){
            //if(justficationErrMsg == true || warrantyStartDateValidate == true)
                return null;
            //pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles'); 
        }else{
            claimNewRecUpd = [SELECT Id, PACCAR_Flag__c, ODM_Status__c, PACCAR_Auth_Required__c, Parts_Warranty_Claim_Only__c, Dealer_Service_Job__c, CSS_Job__c, Css_paccar_approve_reject_flag__c FROM CSS_Claims__c WHERE Id =: cId];
            if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (isPaccarAutoClaim == true && isPaccarAndPW != 'true') && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                    pageRef.setRedirect(true); 
            }
            else if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                pageRef.setRedirect(true);
            }
            else{
                if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized' && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){ //Defect fix: 154159
                    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); }
                else{
    
                    if(claimNewRecUpd.ODM_Status__c == 'ERROR')
                        showErrorPopup = true;
                    else
                        showErrorPopup = false;
    
                    if(showErrorPopup==true)
                    {
                        return null;
                    }else{
                        if(warrantyStartDateValidate == true)
                            return null;
                             /*Story#183077*/
                        else if(claimsRec.CG_Get_Engine_data_flag__c!=null && claimsRec.CG_Get_Engine_data_flag__c)
                          {
                         return null;
                          }
                         /*end*/
                        else{
                            pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cId); 
                        }
                    }
                }
            }
        }
   /* }
        else{
            system.debug('inside main else****');
            
            if(cId==null){
             system.debug('inside if***');
             pageRef = new pageReference('/apex/CG_ClaimsIntake');}
            else{
               system.debug('inside sub else***'); 
             pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);}   }*/
        
        return pageRef;
    }

    //Naviagation to SRTs.
    public PageReference nvClaimsSRTs(){
        //GSSC-240, hard stop the navigation if Service Model is null
        if(psnRec.Service_Model__c == null || psnRec.Service_Model__c == ''){
        return null;}
           //Added this logic from save method to here start Defect 191861
         if(((psnRec.Calibration_Before__c != '' && psnRec.Calibration_Before__c != null) || (psnRec.Calibration_After__c != '' && psnRec.Calibration_After__c != null)) && (psnRec.Justification__c == '----Select One----')){
                justficationErrMsg =true;
                system.debug('InsideIF**');
                return null;   
            }
            else{
                justficationErrMsg = false;system.debug('InsideELSE**');}
            system.debug('justficationErrMsg**'+justficationErrMsg);
            //Added this logic from save method to here End Defect 191861
        PageReference pageRef;
        //  if(cId != null){
        //showErrorPopup = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',null,'WarrantyOverview');
        //    }
        if(claimsRec!= null && claimsRec.Status__c != 'Submitted' && claimsRec.Status__c != 'Not Authorized'){
            if(isPaccarAutoClaim != true){
                cId = saveClaim(cId, 'Draft');
            }
            else if(isPaccarAndPW == 'true'){  //Added as part of the story GSSC-71
                cId = saveClaim(cId, 'Draft');
            }
        }
            pageName='CG_ClaimsSRTs';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service

        //showErrorPopup=true;
        //if(isWarrCustomer!=true){
        if(cId==null){
            //if(justficationErrMsg == true || warrantyStartDateValidate == true)
                return null;
            //pageRef = new pageReference('/apex/CG_ClaimsSRTs'); 
        }else{
            claimNewRecUpd = [SELECT Id, PACCAR_Flag__c, ODM_Status__c, PACCAR_Auth_Required__c, Parts_Warranty_Claim_Only__c, Dealer_Service_Job__c, CSS_Job__c, Css_paccar_approve_reject_flag__c FROM CSS_Claims__c WHERE Id =: cId];
            if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (isPaccarAutoClaim == true && isPaccarAndPW != 'true') && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                    pageRef.setRedirect(true); 
            }
            else if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                pageRef.setRedirect(true);
            }
            else{
                if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized' && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){ //Defect fix: 154159
                    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); }
                else{
    
                    if(claimNewRecUpd.ODM_Status__c == 'ERROR')
                        showErrorPopup = true;
                    else
                        showErrorPopup = false;
    
                    if(showErrorPopup==true)
                    {
                        return null;
                    }else{
                        if(warrantyStartDateValidate == true)
                            return null;
                            /*Story#183077*/
                        else if(claimsRec.CG_Get_Engine_data_flag__c!=null && claimsRec.CG_Get_Engine_data_flag__c)
                          {
                         return null;
                          }
                         /*end*/
                        else{
                            pageRef = new pageReference('/apex/CG_ClaimsSRTs?id='+cId); 
                        }
                    }
    
                }
            }
        }
   /* }
        else{
            system.debug('inside main else****');
            
            if(cId==null){
             system.debug('inside if***');
             pageRef = new pageReference('/apex/CG_ClaimsIntake');}
            else{
               system.debug('inside sub else***'); 
             pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);}   }*/
        
        return pageRef;
    }

    //Naviagation to Job Notes.
    public PageReference nvClaimsJobNotes(){
        //GSSC-240, hard stop the navigation if Service Model is null
        if(psnRec.Service_Model__c == null || psnRec.Service_Model__c == ''){
        return null;}
        //Added this logic from save method to here start Defect 191861
         if(((psnRec.Calibration_Before__c != '' && psnRec.Calibration_Before__c != null) || (psnRec.Calibration_After__c != '' && psnRec.Calibration_After__c != null)) && (psnRec.Justification__c == '----Select One----')){
                justficationErrMsg =true;
                system.debug('InsideIF**');
                return null;   
            }
            else{
                justficationErrMsg = false;system.debug('InsideELSE**');}
            system.debug('justficationErrMsg**'+justficationErrMsg);
            //Added this logic from save method to here End Defect 191861
        PageReference pageRef;
        // if(cId != null){
        //showErrorPopup = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',null,'WarrantyOverview');
        //   }
        if(claimsRec!= null && claimsRec.Status__c != 'Submitted' && claimsRec.Status__c != 'Not Authorized'){
            if(isPaccarAutoClaim != true){
                cId = saveClaim(cId, 'Draft');
            }
            else if(isPaccarAndPW == 'true'){  //Added as part of the story GSSC-71
                cId = saveClaim(cId, 'Draft');
            }
        }
        pageName='CG_ClaimsJobNotes';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service

        //showErrorPopup=true;
      //if(isWarrCustomer!=true){  
        if(cId==null){
            //if(justficationErrMsg == true || warrantyStartDateValidate == true)
                return null;
            //pageRef = new pageReference('/apex/CG_ClaimsJobNotes'); 
        }else{
            claimNewRecUpd = [SELECT Id, PACCAR_Flag__c, ODM_Status__c, PACCAR_Auth_Required__c, Parts_Warranty_Claim_Only__c, Dealer_Service_Job__c, CSS_Job__c, Css_paccar_approve_reject_flag__c FROM CSS_Claims__c WHERE Id =: cId];
            if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (isPaccarAutoClaim == true && isPaccarAndPW != 'true') && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                    pageRef.setRedirect(true); 
            }
            else if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                pageRef.setRedirect(true);
            }
            else{
                if(claimNewRecUpd.ODM_Status__c == 'ERROR')
                    showErrorPopup = true;
                else
                    showErrorPopup = false;
    
                if(showErrorPopup==true)
                {
                    return null;
                }else{
                    if(warrantyStartDateValidate == true)
                        return null;
                        /*Story#183077*/
                    else if(claimsRec.CG_Get_Engine_data_flag__c!=null && claimsRec.CG_Get_Engine_data_flag__c)
                          {
                         return null;
                          }
                         /*end*/
                    else{
                        pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId); 
                    }
                }
            }
        }
    /*}
         else{
            system.debug('inside main else****');
            
            if(cId==null){
             system.debug('inside if***');
             pageRef = new pageReference('/apex/CG_ClaimsIntake');}
            else{
               system.debug('inside sub else***'); 
             pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);}   }*/
        
        return pageRef;
    }

    //Naviagation to Verify and Submit
    public PageReference nvClaimsVS(){
        //GSSC-240, hard stop the navigation if Service Model is null
        if(psnRec.Service_Model__c == null || psnRec.Service_Model__c == ''){
        return null;}
        //Added this logic from save method to here start Defect 191861
         if(((psnRec.Calibration_Before__c != '' && psnRec.Calibration_Before__c != null) || (psnRec.Calibration_After__c != '' && psnRec.Calibration_After__c != null)) && (psnRec.Justification__c == '----Select One----')){
                justficationErrMsg =true;
                system.debug('InsideIF**');
                return null;   
            }
            else{
                justficationErrMsg = false;system.debug('InsideELSE**');}
            system.debug('justficationErrMsg**'+justficationErrMsg);
            //Added this logic from save method to here End Defect 191861
        PageReference pageRef;
        // if(cId != null){
        //showErrorPopup = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',null,'WarrantyOverview'); //Kalpana: Calling ODM Header Validation Service
        //}
        if(claimsRec!= null && claimsRec.Status__c != 'Submitted' && claimsRec.Status__c != 'Not Authorized'){
            if(isPaccarAutoClaim != true){
                cId = saveClaim(cId, 'Draft');
            }
            else if(isPaccarAndPW == 'true'){  //Added as part of the story GSSC-71
                cId = saveClaim(cId, 'Draft');
            }
        }
        pageName='CG_ClaimsVS';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service

        //showErrorPopup=true;
//if(isWarrCustomer!=true){
        if(cId==null){
            //if(justficationErrMsg == true || warrantyStartDateValidate == true)
                return null;
            //pageRef = new pageReference('/apex/CG_ClaimsVS'); 
        }else{
            claimNewRecUpd = [SELECT Id, PACCAR_Flag__c,ODM_Status__c, PACCAR_Auth_Required__c, Parts_Warranty_Claim_Only__c, Dealer_Service_Job__c, CSS_Job__c, Css_paccar_approve_reject_flag__c FROM CSS_Claims__c WHERE Id =: cId];
            if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (isPaccarAutoClaim == true && isPaccarAndPW != 'true') && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                    pageRef.setRedirect(true); 
            }
            else if(claimNewRecUpd.PACCAR_Flag__c == true && claimNewRecUpd.PACCAR_Auth_Required__c == true && claimNewRecUpd.Parts_Warranty_Claim_Only__c != true && claimNewRecUpd.Css_paccar_approve_reject_flag__c != 'Approved' && (claimsRec.CG_Get_Engine_data_flag__c!=null && !claimsRec.CG_Get_Engine_data_flag__c)){
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
                pageRef.setRedirect(true);
            }
            else{
                if(claimNewRecUpd.ODM_Status__c == 'ERROR')
                    showErrorPopup = true;
                else
                    showErrorPopup = false;
    
                if(showErrorPopup==true)
                {
                    return null;
                }else{
                    if(warrantyStartDateValidate == true)
                        return null;
                        /*Story#183077*/
                        else if(claimsRec.CG_Get_Engine_data_flag__c!=null && claimsRec.CG_Get_Engine_data_flag__c)
                          {
                         return null;
                          }
                         /*end*/
                    else{
                        pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId); 
                    }
                }
            }
        }
   /* }
        else{
            system.debug('inside main else****');
            
            if(cId==null){
             system.debug('inside if***');
             pageRef = new pageReference('/apex/CG_ClaimsIntake');}
            else{
               system.debug('inside sub else***'); 
             pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);}   }*/
        
        return pageRef;
    }
    public string emailAdd1{get;set;}
    //Story# 123090: Save Functionality
    /*public PageReference pgSave() 
    {
        System.debug('IN CG_CL_ClaimsIntake - pgSave method...');
        try{
            system.debug('EmailAddress'+emailAdd1);
            Id sClaimId = saveClaim(cId, 'Draft');
            system.debug('NewClaimId**'+sClaimId);
            system.debug('sClaimId'+sClaimId);
            if(sClaimId != null){
                PageReference pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+sClaimId); 
                pageRef.setRedirect(true);
                return pageRef;
            }
            else return null;

        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_ClaimsIntake pgSave method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }
    }*/

    public PageReference resolveErrorNow()
    {
        showErrorPopup = false;
        PageReference pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); 
        pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference continueNext()
    {
        try{    PageReference pageRef;
            if(pageName != '' && pageName !=null){
                if(cId==null){
                    pageRef = new pageReference('/apex/'+pageName); 
                }else{
                    pageRef = new pageReference('/apex/'+pageName+'?id='+cId); 
                }
                return pageRef;
            }
            else
                return null;
           }catch(exception e){
            system.debug('Entered into Continue Next method of CG_ClaimsIntake Controller>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage() + ' ' + e.getCause());
        }
        return null;
    }

    public id saveClaim(Id inpClaimId, String status){
        system.debug('Save Start...--->');
        system.debug('isPaccarAndPW--->'+isPaccarAndPW);
        Id claimId;
        String repSPdataClaims;
        string newManualLoc;
        //GSSC-106
        Boolean milProdhrsError = false;
        
        try{
            //ExternReturnDateFlag = true;
            
            system.debug('claimsRec.Location_Code__c**'+claimsRec.Location_Code__c);
            system.debug('claimsRec.Location__c**'+claimsRec.Location__c);
            //system.debug('psnRec.PSN__c**'+psnRec.PSN__c);
            //Check mandatory fields for Create Claim
            //claimsRec.Assigned_To__r.Name=AssignedTo;

            //Rajasekhar
            system.debug('claimsRec.Customer_Name__c**'+claimsRec.Customer_Name__c);
            system.debug('claimsRec.Shop_Work_Order__c**'+claimsRec.Shop_Work_Order__c);
            system.debug('psnRec.PSN__c**'+psnRec.PSN__c);
            system.debug('filterApplication--'+filterApplication);
            system.debug('filterMake--'+filterMake);
            system.debug('filterModel--'+filterModel);
            system.debug('psnRec.Warranty_Start_Date__c--'+psnRec.Warranty_Start_Date__c);
            system.debug('psnRec.Failure_Date__c--'+psnRec.Failure_Date__c);
            system.debug('psnRec.Before_In_Service__c--'+psnRec.Before_In_Service__c);
            system.debug('claimsRec.Actual_Technician_Time__c--'+claimsRec.Actual_Technician_Time__c);
            system.debug('claimsRec.SPDataWebserviceResult__c--'+claimsRec.SPDataWebserviceResult__c);
            //if(psnRec!=null)
            psnRec.Application__c = filterApplication;
            psnRec.Make__c = filterMake;
            psnRec.Model__c = filterModel;
            
             system.debug('filterApplication**--'+filterApplication);
            system.debug('filterMake**--'+filterMake);
            system.debug('filterModel**--'+filterModel);
             system.debug('sama b4 callout claimsRec.FieldActionWebServiceResult__c' + claimsRec.FieldActionWebServiceResult__c);
            
            Boolean bisWSDMandate = false;
            if(psnRec.Warranty_Start_Date__c ==null && psnRec.Before_In_Service__c == false){
                bisWSDMandate = true;
            }
            system.debug('bisWSDMandate--'+bisWSDMandate);
            if((claimsRec.Customer_Name__c == null || claimsRec.Customer_Name__c == '' || claimsRec.Shop_Work_Order__c == null || claimsRec.Shop_Work_Order__c == '' ||
               psnRec.PSN__c == null|| psnRec.PSN__c == '' || filterApplication == null || filterApplication == '' || filterMake ==null || filterMake == '' || 
               filterModel ==null || filterModel == '' || psnRec.Failure_Date__c ==null  || bisWSDMandate == true)){
                    isWarrCustomer = true;
                    system.debug('Returning Null--');
                    return null;
            }      
            else{
                if(claimsRec.Actual_Technician_Time__c == null)
                    isWarrCustomer = true;
                else
                    isWarrCustomer = false;
            }
            system.debug('isWarrCustomer--'+isWarrCustomer);
            //end
            
            if( (claimsRec.Customer_Name__c ==null || claimsRec.Customer_Name__c.trim()=='') && 
               (psnRec.PSN__c ==null || psnRec.PSN__c.trim()=='') )
             return null;
             
             if(claimsRec.SPDataWebserviceResult__c == 'Error')
                return null;
                system.debug('sama1 claimsRec.FieldActionWebServiceResult__c' + claimsRec.FieldActionWebServiceResult__c);
                system.debug('psnRec.PSN__c**' + psnRec.PSN__c);
                system.debug('psnRec.Service_Model__c**' + psnRec.Service_Model__c );
                system.debug(' psnRec.Failure_Date__c***' +  psnRec.Failure_Date__c );
                system.debug('psnRec.Id**' + psnRec.Id );
                if(claimsRec.FieldActionWebServiceResult__c == 'Error'){
                    string FailureDateString;
                    if(psnRec.Failure_Date__c != null){
                        FailureDateString = DateTime.newInstance(psnRec.Failure_Date__c.year(),psnRec.Failure_Date__c.month(),psnRec.Failure_Date__c.day()).format('dd-MMM-YY');
                    }
                    claimsRec.FieldActionWebServiceResult__c = CG_BL_Campaigns.callGetCampaignsWebServiceforClaimsOnChevronChangeClaim(psnRec.PSN__c, FailureDateString, claimsRec.Region__c,'', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', psnRec.CSS_Claims__c);
               }
            //Call the Claims history if PSN has value.
            List<CSS_JobEventTemporary__c> claimListOld = new List<CSS_JobEventTemporary__c>();
            List<CSS_JobEventTemporary__c> claimListNew = new List<CSS_JobEventTemporary__c>();
            if(psnRec != null && psnRec.PSN__c != null && psnRec.PSN__c != '') {
                if(inpClaimId != null) {
                    //string key = inpClaimId;  
                    claimListOld = [SELECT Id FROM CSS_JobEventTemporary__c WHERE Type__c='ClaimHistory' AND key__c LIKE : '%' + inpClaimId + '%'];
                }
                system.debug('psnRec.PSN__c+RAJESH***'+psnRec.PSN__c);
                claimListNew = CG_BL_Claims.performClaimHistoryBusinessLogic(psnRec.PSN__c);
                system.debug('css_job__c***'+claimsRec.css_job__c);
                system.debug('psnRec***'+psnRec);
                system.debug('psnRecPrimary__c***'+psnRec.Primary__c);
                //Calling getServiceProviderDataClaims method on claims creation

                /*
    if(claimsRec.css_job__c != null)
    { CSS_receive30DayAlerts.requestAlerts(claimsRec.css_job__c,psnRec.PSN__c, claimsRec.css_job__c,1.0,'Hours'); }
    else
    { CSS_receive30DayAlerts.requestAlerts(claimsRec.id,psnRec.PSN__c, claimsRec.id,1.0,'Hours'); }
    */
            }
            //Call the Claims History.


            //Create Claim Record below

            system.debug('in saveClaim status -->'+status+' inpClaimId>>:'+inpClaimId+' claimsRec>>>:'+claimsRec);
            CSS_Claims__c claimNewRec = new CSS_Claims__c();
            if(inpClaimId != null)
            {claimNewRec.id = inpClaimId;}
            else {claimNewRec.id = claimsRec.id;}
            claimNewRec.Customer_Name__c = claimsRec.Customer_Name__c;
            claimNewRec.Customer_Code__c = claimsRec.Customer_Code__c;
// <!--START Code added for saving category and Complaint related all 5 fields values are is not empty as per story #GSSC-377-BY RAJESH 23rd Dec 2019-->
                claimNewRec.Claims_Preventive_Maintenance__c = claimsRec.Claims_Preventive_Maintenance__c;
                claimNewRec.Claims_Expedited_Service__c      = claimsRec.Claims_Expedited_Service__c;
                claimNewRec.Claims_Category_Desc__c          = claimsRec.Claims_Category_Desc__c ;
                claimNewRec.Claims_Category2_Desc__c         = claimsRec.Claims_Category2_Desc__c ;
                claimNewRec.Claims_Category3_Desc__c         = claimsRec.Claims_Category3_Desc__c ;
                claimNewRec.Claims_Category4_Desc__c         = claimsRec.Claims_Category4_Desc__c ;
                claimNewRec.Claims_Category5_Desc__c         = claimsRec.Claims_Category5_Desc__c ;
                claimNewRec.Complaint_Type_Desc__c           = claimsRec.Complaint_Type_Desc__c ;
                claimNewRec.Complaint_Type2_Desc__c          = claimsRec.Complaint_Type2_Desc__c ;
                claimNewRec.Complaint_Type3_Desc__c          = claimsRec.Complaint_Type3_Desc__c ;
                claimNewRec.Complaint_Type4_Desc__c          = claimsRec.Complaint_Type4_Desc__c ;
                claimNewRec.Complaint_Type5_Desc__c          = claimsRec.Complaint_Type5_Desc__c ;
                claimNewRec.Claims_General_Symptoms__c       = claimsRec.Claims_General_Symptoms__c;
                claimNewRec.Claims_Additional_Comments__c    = claimsRec.Claims_Additional_Comments__c;
// <!--END Code added for saving category and Complaint related all 5 fields values are is not empty as per story #GSSC-377-BY RAJESH 23rd Dec 2019-->
            claimNewRec.Shop_Work_Order__c = claimsRec.Shop_Work_Order__c;
            claimNewRec.Contact_First_Name__c = claimsRec.Contact_First_Name__c;
            claimNewRec.Contact_Last_Name__c = claimsRec.Contact_Last_Name__c;
            claimNewRec.Address__c = claimsRec.Address__c;
             claimNewRec.Parts_Warranty_Claim_Only__c=claimsRec.Parts_Warranty_Claim_Only__c;
            claimNewRec.Information_Only_Claim__c = claimsRec.Information_Only_Claim__c;
            //claimNewRec.Contact_Id__c = claimsRec.Contact_Id__c;
            //claimNewRec.CSS_Job__c = claimsRec.CSS_Job__c;
            claimNewRec.Customer_Contact_Phone__c = claimsRec.Customer_Contact_Phone__c;
            //claimNewRec.Customer_Phone__c = claimsRec.Customer_Phone__c;
            checkValidEmail=false;
            system.debug('checkValidEmail'+checkValidEmail);
            system.debug('EmailAddress'+EmailAddress);
            system.debug('EmailAddress1'+EmailAddress1);
             system.debug('** claimNewRec.Complaint_Type_Desc__c  KG>>**'+claimsRec.Dealer_Service_Job__c);
             system.debug('**claimsRec.Dealer_Service_Job__c**'+claimsRec.Dealer_Service_Job__c);
              system.debug('* claimNewRec.Claims_Category_Desc__c KG *'+claimsRec.Dealer_Service_Job__c);

            if(EmailAddress != null && EmailAddress1 != null && EmailAddress != '' && EmailAddress1 != ''){
                system.debug('inside first ');
                if (EmailAddress1.contains('.')){
                    claimNewRec.Email_Address__c = EmailAddress+ '@' + EmailAddress1;
                } else {
                    //checkValidEmail=true;
                    //return null;
                    system.debug('checkValidEmail'+checkValidEmail);
                }
            }
            //claimNewRec.Repair_Completion__c = claimsRec.Repair_Completion__c;
            claimNewRec.Status__c = status;
            claimNewRec.TSR1__c = claimsRec.TSR1__c;
            claimNewRec.TSR2__c = claimsRec.TSR2__c;
            claimNewRec.TSR3__c = claimsRec.TSR3__c;
            claimNewRec.TSR4__c = claimsRec.TSR4__c;
            claimNewRec.TSR5__c = claimsRec.TSR5__c;
            claimNewRec.TSR6__c = claimsRec.TSR6__c;
            claimNewRec.TSR7__c = claimsRec.TSR7__c;
            claimNewRec.TSR8__c = claimsRec.TSR8__c;
            claimNewRec.TSR9__c = claimsRec.TSR9__c;
            claimNewRec.TSR10__c = claimsRec.TSR10__c;
            claimNewRec.Distributor_Authorization_FN__c = claimsRec.Distributor_Authorization_FN__c;
            claimNewRec.Distributor_Authorization_LN__c = claimsRec.Distributor_Authorization_LN__c;
            claimNewRec.Distributor_Authorization_WWID__c = claimsRec.Distributor_Authorization_WWID__c;
            claimNewRec.PACCAR_Authorization_FN__c = claimsRec.PACCAR_Authorization_FN__c;
            claimNewRec.PACCAR_Authorization_LN__c = claimsRec.PACCAR_Authorization_LN__c;
            claimNewRec.PACCAR_Authorization_WWID__c = claimsRec.PACCAR_Authorization_WWID__c;
            claimNewRec.Authorization_Comments__c = claimsRec.Authorization_Comments__c;
            claimNewRec.Catastrophic__c = claimsRec.Catastrophic__c;
            system.debug('claimNewRec.Catastrophic__c---'+claimNewRec.Catastrophic__c);
            claimNewRec.Repair_Location__c = claimsRec.Repair_Location__c;
            claimNewRec.Actual_Time_for_Diagnostics__c = claimsRec.Actual_Time_for_Diagnostics__c;
            claimNewRec.Actual_Time_for_Repair__c = claimsRec.Actual_Time_for_Repair__c;
            claimNewRec.Assigned_To__c=claimsRec.Assigned_To__c;
            System.debug('--Claims Rec Assigned To--'+claimsRec.Assigned_To__c);
            System.debug('--ClaimsNewRec Assigned To--'+claimNewRec.Assigned_To__c);
            claimNewRec.Additional_Tech1__c=claimsRec.Additional_Tech1__c;
            System.debug('--Claims Rec Assigned To--'+claimsRec.Additional_Tech1__c);
            System.debug('--ClaimsNewRec Additional Tech1--'+claimNewRec.Additional_Tech1__c);
            claimNewRec.Additional_Tech2__c=claimsRec.Additional_Tech2__c;
            claimNewRec.Additional_Tech3__c=claimsRec.Additional_Tech3__c;
            claimNewRec.Additional_Tech4__c=claimsRec.Additional_Tech4__c;
            claimNewRec.Additional_Tech5__c=claimsRec.Additional_Tech5__c;
            claimNewRec.Additional_Tech6__c=claimsRec.Additional_Tech6__c;
            claimNewRec.Additional_Tech7__c=claimsRec.Additional_Tech7__c;
            claimNewRec.Additional_Tech8__c=claimsRec.Additional_Tech8__c;
            claimNewRec.Additional_Tech9__c=claimsRec.Additional_Tech9__c;
            claimNewRec.Product_Certification__c=claimsRec.Product_Certification__c;
            //claimNewRec.SP_INSHOP_LABOR_RATE__c = claimsRec.SP_INSHOP_LABOR_RATE__c; //Added by Rajesh Narra
            claimNewRec.SP_FIELD_SERVICE_LABOR_RATE__c = claimsRec.SP_FIELD_SERVICE_LABOR_RATE__c;
            claimNewRec.Location_Code__c = claimsRec.Location_Code__c;

            //Added for Story - 152386 and 152387
            /*if(claimsRec.css_job__c==null)
                {
                    system.debug('Manual Claim>>');

                    claimNewRec.Assigned_To__c=claimsRec.Assigned_To__c;
                    claimNewRec.Additional_Tech1__c=claimsRec.Additional_Tech1__c;
                    claimNewRec.Additional_Tech2__c=claimsRec.Additional_Tech2__c;
                    claimNewRec.Additional_Tech3__c=claimsRec.Additional_Tech3__c;
                    claimNewRec.Additional_Tech4__c=claimsRec.Additional_Tech4__c;
                    claimNewRec.Additional_Tech5__c=claimsRec.Additional_Tech5__c;
                    claimNewRec.Additional_Tech6__c=claimsRec.Additional_Tech6__c;
                    claimNewRec.Additional_Tech7__c=claimsRec.Additional_Tech7__c;
                    claimNewRec.Additional_Tech8__c=claimsRec.Additional_Tech8__c;
                    claimNewRec.Additional_Tech9__c=claimsRec.Additional_Tech9__c;
                }
                else if(claimsRec.css_job__c!=null)
                {
                    claimNewRec.CSS_Job__r.Assigned_To__c=claimsRec.CSS_Job__r.Assigned_To__c;
                    system.debug('Automated Claim>>');
                }*/



            if(String.isNotBlank(servDate))
            {
                String [] servReplace = servDate.split('/');
                String formatService = servReplace[2]+ '-' + servReplace[0]+'-' +servReplace[1] + ' ' + '00:00:00';
                DateTime saveService = DateTime.valueOf(formatService);
                claimNewRec.Service_Date__c = saveService;
            }
            if(String.isNotBlank(repairCompdate))
            {
                String [] repReplace = repairCompdate.split('/');
                String formatCompletion = repReplace[2]+ '-' + repReplace[0]+'-' +repReplace[1] + ' ' + '00:00:00';
                DateTime saveRep = DateTime.valueOf(formatCompletion);
                claimNewRec.Repair_Completion__c = saveRep;
            }

            //claimNewRec.Country__c = filterCountry;
            if(filterCountry == null || filterCountry == '')
                claimNewRec.Country__c = claimsRec.Country__c;
            else
                claimNewRec.Country__c = filterCountry;
            system.debug('FilterC'+filterCountry);
            //claimNewRec.State__c = filterState;
            if(filterState == null || filterState == '')
                claimNewRec.State__c = claimsRec.State__c;
            else
                claimNewRec.State__c = filterState;
            system.debug('FilterS'+filterState);
            claimNewRec.ZipCode__c = claimsRec.ZipCode__c;
            claimNewRec.Actual_Technician_Time__c = claimsRec.Actual_Technician_Time__c;


            // add new engine data new fields
            claimNewRec.BillToCode__c = claimsRec.BillToCode__c;
            claimNewRec.BuildDate__c = claimsRec.BuildDate__c;
            claimNewRec.DesignPhaseCode__c = claimsRec.DesignPhaseCode__c;
            claimNewRec.EngineFamilyCode__c = claimsRec.EngineFamilyCode__c;
            claimNewRec.EtoConversionDate__c = claimsRec.EtoConversionDate__c;
            claimNewRec.MarineFlag__c = claimsRec.MarineFlag__c;
            claimNewRec.OemCode__c = claimsRec.OemCode__c;
            claimNewRec.ProductApplicationDesp__c = claimsRec.ProductApplicationDesp__c;
            claimNewRec.ProductApplicationCode__c = claimsRec.ProductApplicationCode__c;
            claimNewRec.warrantyIndicatorFlag__c = claimsRec.warrantyIndicatorFlag__c; 
            claimNewRec.EngineFamilyName__c = claimsRec.EngineFamilyName__c; 
            claimNewRec.ShipDate__c = claimsRec.ShipDate__c; 
            claimNewRec.ETOOldESN__c = claimsRec.ETOOldESN__c; 

            System.debug('before assign claimsRec.SP_TERRITORY_CODE__c>>>>>:'+claimsRec.SP_TERRITORY_CODE__c);
            System.debug('before assign claimsRec.SP_REGIONCODE__c>>>>>:'+claimsRec.SP_REGIONCODE__c);
            System.debug('before assign claimsRec.SP_CLAIM_ALLOWED_DAYS__c>>>>>:'+claimsRec.SP_CLAIM_ALLOWED_DAYS__c);

            claimNewRec.SP_CHANNEL_OF_DISTRIBUTION__c = claimsRec.SP_CHANNEL_OF_DISTRIBUTION__c;
            claimNewRec.SP_CLAIM_ALLOWED_DAYS__c = claimsRec.SP_CLAIM_ALLOWED_DAYS__c;
            claimNewRec.SP_CMI_SP_EXPIRATION__c = claimsRec.SP_CMI_SP_EXPIRATION__c;
            claimNewRec.SP_LTA_FLAG__c = claimsRec.SP_LTA_FLAG__c;
            claimNewRec.SP_OUTFILE_ALL_CLAIMS__c = claimsRec.SP_OUTFILE_ALL_CLAIMS__c;
            claimNewRec.SP_PACCAR__c = claimsRec.SP_PACCAR__c;    
            claimNewRec.SP_REGION__c = claimsRec.SP_REGION__c; 
            claimNewRec.SP_ACCOUNT_STATUS__c = claimsRec.SP_ACCOUNT_STATUS__c; 
            claimNewRec.SP_TERRITORY_CODE__c = claimsRec.SP_TERRITORY_CODE__c; 
            claimNewRec.SP_Group_Name__c = claimsRec.SP_Group_Name__c; 
            claimNewRec.SP_TERRITORY__c  = claimsRec.SP_TERRITORY__c; 
            claimNewRec.SP_REGIONCODE__c = claimsRec.SP_REGIONCODE__c;
            claimNewRec.SP_Country__c = claimsRec.SP_Country__c;
            claimNewRec.SP_PrimaryOEMCode__c = claimsRec.SP_PrimaryOEMCode__c;


            CSS_Claims__c claimAuthRec = new CSS_Claims__c();
            if(cId != null){
                claimAuthRec =[Select Id,Pending_Authorization__c from CSS_Claims__c where id= :cId];

                if(claimAuthRec != null && claimAuthRec.Pending_Authorization__c != 'Authorized'){
                    claimNewRec.Pending_Authorization__c = claimsRec.Pending_Authorization__c;
                }
            }else{
                claimNewRec.Pending_Authorization__c = claimsRec.Pending_Authorization__c;
            }
            claimNewRec.Warranty_Authorization_Flag__c = claimsRec.Warranty_Authorization_Flag__c;
            claimNewRec.CSS_Channel_Code__c = claimsRec.CSS_Channel_Code__c;
            claimNewRec.Territory_Class__c = claimsRec.Territory_Class__c; 
            claimNewRec.Territory_Class_Name__c = claimsRec.Territory_Class_Name__c; 
            claimNewRec.SP_PromotionId__c = claimsRec.SP_PromotionId__c;      
            claimNewRec.CSS_Channel_Of_Distribution__c = claimsRec.CSS_Channel_Of_Distribution__c;
            claimNewRec.Automotive_App_Flag__c = claimsRec.Automotive_App_Flag__c;
            claimNewRec.SP_SCMDeductiblePercentage__c = claimsRec.SP_SCMDeductiblePercentage__c;
            claimNewRec.SP_State__c = claimsRec.SP_State__c;
            claimNewRec.SP_WarrantyTrainingStatus__c = claimsRec.SP_WarrantyTrainingStatus__c;
            claimNewRec.SP_SCMDollarAmt__c = claimsRec.SP_SCMDollarAmt__c;
            claimNewRec.SP_WarrantyCertificationEndDate__c = claimsRec.SP_WarrantyCertificationEndDate__c;
            claimNewRec.bmsCreateAccount__c = claimsRec.bmsCreateAccount__c;
            claimNewRec.Claims_city__c = claimsRec.Claims_city__c;
            claimNewRec.ReconEngineFlag__c = claimsRec.ReconEngineFlag__c;
            system.debug('Recon Flag--'+claimNewRec.ReconEngineFlag__c);
            claimNewRec.SPDataWebserviceResult__c = claimsRec.SPDataWebserviceResult__c;
            claimNewRec.FieldActionWebServiceResult__c = claimsRec.FieldActionWebServiceResult__c ;
            if(claimsRec.Multi_PSN_Claim__c !=null){
                claimNewRec.Multi_PSN_Claim__c = claimsRec.Multi_PSN_Claim__c;
            }
            system.debug('claimsRec123' + claimsRec);
            System.debug('claimNewRec.Pending_Authorization__c---<>'+claimNewRec.Pending_Authorization__c);
            System.debug('claimNewRec.Warranty_Authorization_Flag__c---<>'+claimNewRec.Warranty_Authorization_Flag__c);
            System.debug('prodCert---<>'+prodCert);
              System.debug('claimsRec.Product_Certification__c---<>'+claimsRec.Product_Certification__c);
            
           if(claimsRec.Pending_Authorization__c != 'Authorized') {
             //  if(claimsRec.Pending_Authorization__c == null || claimsRec.Pending_Authorization__c == '' || claimsRec.Pending_Authorization__c == '--None--') {
               if(claimsRec.Warranty_Authorization_Flag__c == 'Not Certified' || (claimsRec.Product_Certification__c == '' || claimsRec.Product_Certification__c == null  || claimsRec.Product_Certification__c == 'false' || claimsRec.Product_Certification__c == 'NotCert')){
                    system.debug('isnide id prodcert' + prodCert );
                    claimNewRec.Pending_Authorization__c = 'Authorization Required';
                } else {
                        claimNewRec.Pending_Authorization__c = 'Not Applicable';
                }
         //  }
            }
            system.debug('claimNewRec.Pending_Authorization__c***'+claimNewRec.Pending_Authorization__c);

            //Populate the PSN__c of the PSN object to ESN__c field of the claims object 
            if(psnRec != null &&  psnRec.PSN__c != '')
                claimNewRec.ESN__c = psnRec.PSN__c;

            //As of now storing Login User Location 

            string locBranchCode;//Added as part of GSSC-196 to pass loc code in query instead of location name.
            if(inpClaimId == null){
                String lstLocName;
                system.debug('LocationManualClaims--'+LocationManualClaims);
                //    system.debug(' LocationManualClaims.length' + '      ' +  LocationManualClaims.length());
                if(LocationManualClaims !=null && LocationManualClaims!=''){
                    lstLocName = LocationManualClaims.substring(0,LocationManualClaims.length()-7);
                    
                    system.debug(' lstLocName' + '      ' +  lstLocName);
                    lstLocName = lstLocName.trim();
                    string locCodee = LocationManualClaims.trim();
                    locBranchCode = '%-'+locCodee.right(5);//Added as part of GSSC-196 to pass loc code in query instead of location name.
                }
                // string userName = UserInfo.getName();
                list<CSS_UserLocation__c> userLocationList = new list<CSS_UserLocation__c>();    
                 if(locBranchCode != null && locBranchCode != ''){//Added as part of GSSC-196 to pass loc code in query instead of location name.
                userLocationList = [select id, Location_Name__c,Location_code__c from  CSS_UserLocation__c where Location_code__c LIKE: locBranchCode and UserId__c=:UserInfo.getUserId()];            
                 }
                System.debug('locsize' + ' ' +userLocationList.size() );
                 if(userLocationList!=null && userLocationList.size()>0){
                    newManualLoc = userLocationList[0].Location_code__c;
                    System.debug(' inside if cond claimNewRec.Location_Code__c' + ' ' + newManualLoc );
                }

                claimNewRec.Location_Code__c = newManualLoc;
                System.debug(' claimNewRec.Location_Code__c' + ' ' + claimNewRec.Location_Code__c ); 



                // claimNewRec.Location_Code__c = css_utility.getUserAttributes(UserInfo.getUserId()).User_Location__c;
                // system.debug('ClaimLocationCode**'+css_utility.getUserAttributes(UserInfo.getUserId()).User_Location__c);
                List<Account> accList = new List<Account>([Select Id, Name, Type, Location__c from Account where Location__c=:claimNewRec.Location_Code__c]);
                //if(accList != null || accList.size()>0)
                if(accList != null && accList.size()>0)
                {
                    claimNewRec.Account__c = accList.get(0).Id;
                    claimsRec.Account__c = accList.get(0).Id; 
                    claimNewRec.Location__c = accList[0].Name;
                    accType = accList[0].Type;
                }
                system.debug('Account**'+accList);
                system.debug('in save...claimNewRec.Location__c-->'+claimNewRec.Location__c); 

            }
            //claimNewRec.Region__c = region; //Kalpana: commented to fix defect#142901: Warranty coverage Region and Territory fields are defaulting to None after or navigating to other chevrons.



            //upsert claimNewRec;
            //claimId = claimNewRec.id;
            system.debug('claimNewRec**'+claimNewRec);
            //Create PSN Record below
            system.debug('psnRec**'+psnRec);
            CSS_PSN__c psnNewRec = new CSS_PSN__c();
            /*set<boolean> setItemNullCheck = new set<boolean>() ;
    set<boolean> setUnlistedCheck = new set<boolean>();
    boolean x = ((psnRec.Calibration_Before__c==null || psnRec.Calibration_Before__c=='') && (psnRec.Justification__c=='----Select One----'));
    boolean y = ((psnRec.Calibration_After__c==null || psnRec.Calibration_After__c=='') && (psnRec.Justification__c=='----Select One----'));
    setItemNullCheck.add(x);
    setUnlistedCheck.add(y);
    if(setItemNullCheck.contains(true)){
    justficationErrMsg =true;
    return null;
    }
    if(setUnlistedCheck.contains(true)){
    justficationErrMsg =true;
    return null;
    }

    if((psnRec.Calibration_Before__c!=null && psnRec.Calibration_After__c !=null) &&(psnRec.Justification__c=='----Select One----')){
    justficationErrMsg =true;
    return null;
    } */
            /*system.debug('psnRec**'+psnRec.Calibration_Before__c);
    system.debug('psnRec**'+psnRec.Calibration_After__c);
    system.debug('psnRec**'+psnRec.Justification__c);*/
    //Below lines commented as per  Defect 191861 and moved to chevron navigations
         /*  if(((psnRec.Calibration_Before__c != '' && psnRec.Calibration_Before__c != null) || (psnRec.Calibration_After__c != '' && psnRec.Calibration_After__c != null)) && (psnRec.Justification__c == '----Select One----')){
                justficationErrMsg =true;
                system.debug('InsideIF**');
                return null;   
            }
            else{
                justficationErrMsg = false;system.debug('InsideELSE**');}
            system.debug('justficationErrMsg**'+justficationErrMsg);*/ 

            if(psnRec != null){                                         
                psnNewRec.id = psnRec.id;
                psnNewRec.PSN__c = psnRec.PSN__c;
                psnNewRec.Primary__c = true;
                if(psnRec.CSS_Claims__c == null){
                    psnNewRec.CSS_Claims__c = claimId;}           
                psnNewRec.Unit_Number__c = psnRec.Unit_Number__c;
                psnNewRec.License_Plate_State__c = psnRec.License_Plate_State__c;
                if(psnRec.License_Plate_State__c != null && psnRec.License_Plate_State__c != ''){
                    claimNewRec.License_Plate_State_Error_message__c = '';
                }
                psnNewRec.Service_Model__c = psnRec.Service_Model__c;
                psnNewRec.VIN__c = psnRec.VIN__c;
                system.debug('WSD**'+psnRec.Warranty_Start_Date__c);
                if(psnRec.Warranty_Start_Date__c != null){
                    psnNewRec.Warranty_Start_Date__c = date.valueof(psnRec.Warranty_Start_Date__c);
                }else{
                    psnNewRec.Warranty_Start_Date__c = null;
                }
                psnNewRec.Before_In_Service__c = psnRec.Before_In_Service__c;
               
                if(psnRec.Failure_Date__c > system.today()){
                  psnRec.Failure_Date__c = system.today();    
                }else{
                psnNewRec.Failure_Date__c = psnRec.Failure_Date__c;
                }
                
                psnNewRec.Mileage__c = psnRec.Mileage__c;
                psnRec.Mileage_Measure__c = mil_measure;
                psnNewRec.Mileage_Measure__c = mil_measure;
                psnNewRec.Product_Hours__c = psnRec.Product_Hours__c;
                psnNewRec.Mission_Disabling__c = psnRec.Mission_Disabling__c;

                psnNewRec.Calibration_Before__c = psnRec.Calibration_Before__c;
                psnNewRec.Revision_Before__c = psnRec.Revision_Before__c;
                psnNewRec.Calibration_After__c = psnRec.Calibration_After__c;
                psnNewRec.Revision_After__c = psnRec.Revision_After__c;
                psnNewRec.Justification__c = psnRec.Justification__c;

                psnNewRec.Qsol_Engine_Family_Code__c = psnRec.Qsol_Engine_Family_Code__c;
                psnNewRec.ProductAppcodeErrorflag__c = psnRec.ProductAppcodeErrorflag__c;
                psnNewRec.Equipment_ID__c = psnRec.Equipment_ID__c;
                system.debug('psnRec.PACCAR_Flag__c'+psnRec.PACCAR_Flag__c);
                psnNewRec.PACCAR_Flag__c = psnRec.PACCAR_Flag__c;
                /*if(psnRec.Multi_PSN_Claim__c!=null)
                    {
                        psnNewRec.Multi_PSN_Claim__c = psnRec.Multi_PSN_Claim__c;
                    }*/


                system.debug('psnNewRec.Qsol_Engine_Family_Code__c <><><><><><> ' + psnNewRec.Qsol_Engine_Family_Code__c);
                if(filterApplication == '----None----'){        
                    filterApplication ='';  
                }
                system.debug('mapDescriptionToCode <><><><><><> ' + mapDescriptionToCode);
                psnNewRec.Application__c = filterApplication;
                psnRec.Application__c = filterApplication;
                system.debug('filterApplication <><><><><><> ' + filterApplication);
                String appCode;
                if(filterApplication != '' && mapDescriptionToCode != null){
                    appCode = mapDescriptionToCode.get(filterApplication);
                }
                system.debug('appCode <><><><><><> ' + appCode);
                if(claimsRec.css_job__c == null && claimsRec.Dealer_Service_Job__c == null && appCode !=null) {
                    psnNewRec.ApplicationCode__c = appCode;
                    psnRec.ApplicationCode__c = appCode;
                }
                if(claimsRec.css_job__c != null){
                    if(psnRec.ApplicationCode__c == null || psnRec.ApplicationCode__c == ''){
                        psnRec.ApplicationCode__c = claimsRec.CSS_Job__r.ApplicationCode__c;
                        psnNewRec.ApplicationCode__c = claimsRec.CSS_Job__r.ApplicationCode__c;
                    }
                }
                else if(claimsRec.Dealer_Service_Job__c != null){
                    if(psnRec.ApplicationCode__c == null || psnRec.ApplicationCode__c == ''){
                        psnRec.ApplicationCode__c = claimsRec.Dealer_Service_Job__r.ApplicationCode__c;
                        psnNewRec.ApplicationCode__c = claimsRec.Dealer_Service_Job__r.ApplicationCode__c;
                    }
                }
                /*if(filterApplication == ''){        
    filterApplication ='----None----';  
    }*/
                system.debug('psnNewRec.Application__c <><><><><><> ' + psnNewRec.Application__c);
                system.debug('psnNewRec.ApplicationCode__c <><><><><><> ' + psnNewRec.ApplicationCode__c);
                psnNewRec.Make__c = filterMake;
                psnNewRec.Model__c = filterModel;
                psnRec.Make__c = filterMake;
                psnRec.Model__c = filterModel;

                //psnNewRec.Unit_Type__c = filterUnitType;
                psnNewRec.Unit_Type__c = psnRec.Unit_Type__c;
                //upsert psnNewRec;
                string ODMMessage = '';
                integer maxsize=32678;
                system.debug('claimsRec <><><><><><> ' + claimsRec);
                system.debug('psnRec ' + psnRec);
                if(psnRec != null && psnRec.PSN__c != null)
                    claimsRec.ESN__c  = psnRec.PSN__c;

                //As of now storing Login User Location
                if(claimsRec.Location_Code__c == null) 
                    claimsRec.Location_Code__c = newManualLoc;//Fixed by Anirudh as we have to take location from user location Obj and not user object.css_utility.getUserAttributes(UserInfo.getUserId()).User_Location__c;
                    
                //Calling SP Data
                String channelCode;
                String channelOFDist;
                String terClass;
                String terClassName;
                String promoId;
                String TravelRate;
                String InShopLaborRate;
                String FieldServiceLaborRate;
                String paccarFlag;
                if(psnRec != null){
                    //system.debug('Inside getServiceProviderDataClaims Call**');
                    string FailureDateString;
                    string SPCode;
                    string ServiceModelName='';
                    String userLOC;
                    system.debug('claimNewRec.Location_Code__c'+claimNewRec.Location_Code__c);
                    system.debug('psnRec'+psnRec);
                    if(claimNewRec.Location_Code__c != null && claimNewRec.Location_Code__c != '')
                        userLOC = claimNewRec.Location_Code__c;
                    else
                        userLOC = userObj.User_Location__c;
                    system.debug('userLOc***'+userLOC);
                    //if(psnRec.Primary__c == true){
                    //system.debug('psnrec.Failure_Date__c**'+psnRec.Failure_Date__c);
                    if(psnRec.Failure_Date__c != null && userLOc != null){
                        //System.debug('in psnrecinsert before calling qwebservice$$$$$$$$...');
                        FailureDateString = DateTime.newInstance(psnRec.Failure_Date__c.year(),psnRec.Failure_Date__c.month(),psnRec.Failure_Date__c.day()).format('dd-MMM-YY');
                        //SPCodeOrig= CSS_Claims__c.CSS_Claims__r.Location_Code__c;
                        SPCode = userLOC.split('-')[1];
                        system.debug('Anirudh Entered SP Data Call');
                        //System.debug('***SP Code***'+SPCode+'*****ServiceModelName*****'+ServiceModelName+'*****FailureDateString*****'+FailureDateString+'*****ClaimId****'+claimsRec.Id);
                        repSPdataClaims = CSS_FN_SIEBEL.getServiceProviderDataClaims(SPCode, ServiceModelName, FailureDateString, claimsRec.Id);
                        system.debug('repSPdataClaims11**'+repSPdataClaims);
                    }
                    //}
                }

                if(repSPdataClaims != null){
                    channelCode = repSPdataClaims.split('_')[0];
                    channelOFDist = repSPdataClaims.split('_')[1];
                    terClass = repSPdataClaims.split('_')[2];
                    terClassName = repSPdataClaims.split('_')[3];
                    promoId = repSPdataClaims.split('_')[4];
                    TravelRate = repSPdataClaims.split('_')[5];
                    InShopLaborRate = repSPdataClaims.split('_')[6];
                    FieldServiceLaborRate = repSPdataClaims.split('_')[7];
                    paccarFlag = repSPdataClaims.split('_')[8];
                    system.debug('****channelCode**'+channelCode+'***channelOFDist***'+channelOFDist+'***terClass***'+terClass+'***terClassName***'+terClassName);
                    claimNewRec.CSS_Channel_Code__c = channelCode;
                    claimNewRec.CSS_Channel_Of_Distribution__c = channelOFDist;
                    claimNewRec.Territory_Class__c = terClass;
                    claimNewRec.SP_TERRITORY_CODE__c = terClass;
                    claimNewRec.Territory_Class_Name__c = terClassName;
                    claimNewRec.SP_PromotionId__c = promoId;
                    claimNewRec.CSS_Travel_Rate__c = TravelRate;
                    claimNewRec.SP_INSHOP_LABOR_RATE__c = InShopLaborRate;
                    system.debug('Inshoplaborrate11'+claimNewRec.SP_INSHOP_LABOR_RATE__c);
                    claimNewRec.SP_FIELD_SERVICE_LABOR_RATE__c = FieldServiceLaborRate;
                    claimNewRec.SP_PACCAR__c = paccarFlag;
                    
                    claimsRec.CSS_Channel_Code__c = channelCode;
                    claimsRec.CSS_Channel_Of_Distribution__c = channelOFDist;
                    claimsRec.Territory_Class__c = terClass;
                    claimsRec.SP_TERRITORY_CODE__c = terClass;
                    claimsRec.Territory_Class_Name__c = terClassName;
                    claimsRec.SP_PromotionId__c = promoId;
                    claimsRec.CSS_Travel_Rate__c = TravelRate;
                    claimsRec.SP_INSHOP_LABOR_RATE__c = InShopLaborRate;
                    system.debug('Inshoplaborrate11'+claimsRec.SP_INSHOP_LABOR_RATE__c);
                    claimsRec.SP_FIELD_SERVICE_LABOR_RATE__c = FieldServiceLaborRate;
                    claimsRec.SP_PACCAR__c = paccarFlag;
                    
                    claimNewRec.Region__c = repSPdataClaims.split('_')[9];
                    claimsRec.Region__c = repSPdataClaims.split('_')[9];
                    claimsRec.SP_Region__c = repSPdataClaims.split('_')[9];
                    claimNewRec.SP_Region__c = repSPdataClaims.split('_')[9];
                    claimsRec.Territory__c = repSPdataClaims.split('_')[10];
                    claimNewRec.Territory__c = repSPdataClaims.split('_')[10];
                    claimsRec.SP_TERRITORY__c = repSPdataClaims.split('_')[10];
                    claimNewRec.SP_TERRITORY__c = repSPdataClaims.split('_')[10];
                    claimNewRec.SP_CLAIM_ALLOWED_DAYS__c = repSPdataClaims.split('_')[11];
                    claimsRec.SP_CLAIM_ALLOWED_DAYS__c = repSPdataClaims.split('_')[11];
                    if(claimId != null){ 
                        claimNewRec.Product_Certification__c = repSPdataClaims.split('_')[12];
                        claimsRec.SP_ProductCertification__c = repSPdataClaims.split('_')[12];
                        claimNewRec.Product_Certification__c = repSPdataClaims.split('_')[12];
                        claimsRec.SP_ProductCertification__c = repSPdataClaims.split('_')[12];
                    }
                }
                
                //Calling ODM Header Validation

                List<CSS_Integration_Error__c> IEList;
                system.debug('claimsRec.Status__c <><><><><><> ' + claimsRec.Status__c);
                system.debug('claimsRec.SP_Region__c ' + claimsRec.SP_Region__c);
                system.debug('claimsRec.SP_RegionCode__c ' + claimsRec.SP_RegionCode__c);
                system.debug('claimsRec.SP_CLAIM_ALLOWED_DAYS__c ' + claimsRec.SP_CLAIM_ALLOWED_DAYS__c);
                if(claimsRec.Status__c == 'Draft' || claimsRec.Status__c==null){
                     IEList = CG_BL_ODM.callODMHeaderValidationClaimService(null,claimsRec,psnRec,'CLAIM',null,'WarrantyOverview');
                     system.debug('IEList-->'+IEList);
                }
                
                String penaltyValue='';
               
                //Boolean isPaccar_ODMcode = false;
                if(IEList != null && IEList.size() >0) {
                    for(CSS_Integration_Error__c IE : IEList) {
                        if(IE.Error_Description__c == null && IE.Response_Body__c != null) {
                          CG_ODM_ResJSONParser  ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(IE.Response_Body__c,CG_ODM_ResJSONParser.class);
                           ODMDisplayMsgs = new list<CG_ODM_ResJSONParser.messages>();
                                                        system.debug('ODMResponse ' + ODMResponse); 
                            if(ODMResponse.Response.claim != null && ODMResponse.Response.claim.messages != null){
                                //system.debug('Entered messages section>>>>>>'+ODMResponse.Response.claim.messages[0].description);
                                for(CG_ODM_ResJSONParser.messages msg:ODMResponse.Response.claim.messages){
                                    system.debug('Entered for loop messages section>>>>>>'+msg.description);
                                    ODMMessage = ODMMessage + msg.type + ':' + msg.description + ';;';
                                    ODMDisplayMsgs.add(msg);
                                    /*if(msg.code == 'ODM-HE-WAR-403-1')
                                        isPaccar_ODMcode = true;*/
                                    //Below code is added for long data value issue 
                                    if(msg.code != null && msg.code.equalsIgnoreCase('ODM-HE-WAR-205')){
                                        penaltyValue = ODMResponse.Response.claim.penalty;
                                    }
                                    if(ODMMessage.length()>maxsize)
                                    {
                                        ODMMessage=ODMMessage.substring(0,maxsize);
                                        IE.Response_Body__c = IE.Response_Body__c.substring(0,maxsize); 
                                    }
                                }
                            }
                        }
                    }
                }
                
                //CSS_Claims__c clmRecord = new CSS_Claims__c();
                claimNewRec.ODM_Status_Message__c =  ODMMessage;
                if(ODMMessage != null && ODMMessage != ''){
                    if(ODMMessage.contains('ERROR')){
                        claimNewRec.ODM_Status__c = 'ERROR';
                    }
                    else{
                        claimNewRec.ODM_Status__c = 'WARN';
                    }
                    claimNewRec.ODM_Penalty__c = (penaltyValue != null && penaltyValue != '' ? penaltyValue : '');
                }else{
                    claimNewRec.ODM_Status__c = 'PASSED';
                    claimsRec.ODM_Status__c = 'PASSED';
                    claimNewRec.ODM_Status_Message__c =  '';
                    claimNewRec.ODM_Penalty__c = (penaltyValue != null && penaltyValue != '' ? penaltyValue : '');
                }
                system.debug('New PSN-->'+psnRec.PSN__c);
                system.debug('Existing PSN-->'+existingPSN);
                system.debug('claimsRec.CSS_Job__c'+claimsRec.CSS_Job__c);
                system.debug('claimsRec.Dealer_Service_Job__c'+claimsRec.Dealer_Service_Job__c);
                system.debug('claimsRec.Account__r.Type'+claimsRec.Account__r.Type);
                system.debug('claimNewRec.SP_PACCAR__c'+claimNewRec.SP_PACCAR__c);
                system.debug('claimNewRec.SP_PACCAR__c'+claimNewRec.SP_PACCAR__c);
                system.debug('accType'+accType);
                
                if(accType == null){
                    accType = claimsRec.Account__r.Type;
                }
                //if(claimNewRec.ODM_Status_Message__c == 'ODM-HE-WAR-403-1'){
                //if(isPaccar_ODMcode){
                    //if(isDealer && claimNewRec.SP_PACCAR__c == 'N'){
                    
                    boolean DealerTypeFlag = CSS_utility.getAccounttype(accType);
                    if((DealerTypeFlag==true) && claimNewRec.SP_PACCAR__c == 'N' && claimsRec.CSS_Job__c == null && claimsRec.Dealer_Service_Job__c == null){
                        system.debug('inside if');
                        String temp = claimNewRec.Territory_Class__c +'-'+ claimNewRec.CSS_Channel_Code__c;
                        if(temp != null && temp != '')
                            paccarCustomSettingValues = CG_PACCAR_Flag_SP_Info_Mapping__c.getValues(temp);
                        system.debug('paccarCustomSettingValues-->'+paccarCustomSettingValues);
                        system.debug('claimsRec.Css_paccar_approve_reject_flag__c-->'+claimsRec.Css_paccar_approve_reject_flag__c);
                        if(claimsRec.Css_paccar_approve_reject_flag__c!= 'Approved' && claimsRec.Css_paccar_approve_reject_flag__c!= 'Rejected'){
                            system.debug('inside 2nd if');
                            if(paccarCustomSettingValues == null){
                                system.debug('inside 3rd if');
                                claimNewRec.PACCAR_Auth_Required__c = false;
                                claimNewRec.PACCAR_Flag__c = false;
                            }
                            else{
                                //system.debug('inside else'+claimsRec.CSS_PSNs__r[0].PSN__c);
                                if(psnRec.PACCAR_Flag__c == 'N'){//claimsRec.CSS_PSNs__r[0].PSN__c == 'N')
                                    claimNewRec.PACCAR_Auth_Required__c = false;
                                    claimNewRec.PACCAR_Flag__c = false;
                                }
                                else{
                                    system.debug('inside 2nd else'+setPACCAR_Flag());
                                    claimNewRec.PACCAR_Flag__c = true;
                                    if(!setPACCAR_Flag()){
                                        claimNewRec.PACCAR_Auth_Required__c = true;
                                        //Below if Condition logic added for the story#170268.
                                        if(!claimNewRec.Parts_Warranty_Claim_Only__c)
                                        {
                                            claimNewRec.CSS_PACCAR_Auth_Track__c=true; 
                                        }
                                        else{
                                            claimNewRec.CSS_PACCAR_Auth_Track__c=false;
                                        }
                                    }
                                    else
                                        claimNewRec.PACCAR_Auth_Required__c = false;
                                }
                            }
                        }
                        else{
                            if(psnRec.PSN__c != existingPSN){ 
                                if(paccarCustomSettingValues == null)
                                claimNewRec.PACCAR_Auth_Required__c = false;
                            else{
                                if(psnRec.PACCAR_Flag__c == 'N'){
                                    claimNewRec.PACCAR_Auth_Required__c = false;
                                    claimNewRec.PACCAR_Flag__c = false;
                                }
                                else{
                                    claimNewRec.PACCAR_Flag__c = true;
                                    if(!setPACCAR_Flag()){
                                        claimNewRec.PACCAR_Auth_Required__c = true;
                                        //Below if Condition logic added for the story#170268.
                                        if(!claimNewRec.Parts_Warranty_Claim_Only__c)
                                        {
                                            claimNewRec.CSS_PACCAR_Auth_Track__c=true; 
                                        }
                                        else{
                                            claimNewRec.CSS_PACCAR_Auth_Track__c=false;
                                        }
                                    }
                                    else
                                        claimNewRec.PACCAR_Auth_Required__c = false;
                                }
                            }
                            }
                        }
                        system.debug('claimNewRec.PACCAR_Auth_Required__c = false'+claimNewRec.PACCAR_Auth_Required__c);
                    }
                //}
                system.debug('inside if -->'+claimsRec.Account__r.Type);
                system.debug('inside if -->'+claimsRec.CSS_Job__c);
                system.debug('inside if -->'+claimsRec.Dealer_Service_Job__c);
                system.debug('inside if -->'+claimsRec.No_Failure_PACCAR_Flag__c);
                system.debug('inside if -->'+claimsRec.Parts_Warranty_Claim_Only__c);
                
                if(DealerTypeFlag && (claimsRec.CSS_Job__c != null || claimsRec.Dealer_Service_Job__c != null) && claimsRec.No_Failure_PACCAR_Flag__c == true && claimsRec.Parts_Warranty_Claim_Only__c != true){
                    system.debug('inside if -->');
                    claimNewRec.PACCAR_Auth_Required__c = true;
                    claimNewRec.PACCAR_Flag__c = true;
                }
                system.debug('isPaccarAndPW in save-->'+isPaccarAndPW);
                //Added below if condition as part of the story GSSC-71
                if(isPaccarAndPW == 'true'){
                    claimNewRec.PACCAR_Auth_Required__c = false;
                    claimNewRec.PACCAR_Converted_to_PW__c = true;
                }
                /*story#183077*/
                if(claimsRec.CG_Get_Engine_data_flag__c!=null)
                    claimNewRec.CG_Get_Engine_data_flag__c=claimsRec.CG_Get_Engine_data_flag__c;
                /*end*/
                
                system.debug('claimNewRec11--'+claimNewRec);
                upsert claimNewRec;
                claimId = claimNewRec.id;
                
                //Code for knowing Product Mileage/Hours is 0 or not #GSSC-106
                List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
                solComp = [SELECT Id, CSS_Claims__c, CSS_Account_Formula__c,Type__c, CSS_Failure_Sequence_Number__c, CoveredPartsQty__c, CampaignPartsPercentage__c, CoveredOCAmount__c, 
                           CampaignOCPercentage__c, FailCode_Formula__c,CoveredLaborHrs__c, CampaignLaborPercentage__c, CoveredTravelBaseFareAmt__c, CoveredTravelLabor__c,
                           CoveredTravelMiles__c, CoveredTowingMiles__c, CoveredMealsLodgingAmt__c, CampaignTravelPercentage__c, CampaignTowingPercentage__c FROM CSS_Solution_Component__c 
                           WHERE CSS_Claims__c =: claimId AND (Type__c NOT IN ('Campaign','ATC','TRP') OR (Type__c IN ('Campaign','ATC','TRP') AND Selected_Component__c = true))];
                system.debug('solComp007--'+solComp);
                for(CSS_Solution_Component__c SC : solComp){
                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.CSS_Account_Formula__c.contains('70')){
                        milProdhrsError = true;
                    }
                }
                
                system.debug('claimsRec.CSS_Job__c--'+claimsRec.CSS_Job__c);
                system.debug('claimsRec.Dealer_Service_Job__c--'+claimsRec.Dealer_Service_Job__c);
                if(claimsRec.CSS_Job__c != null || claimsRec.Dealer_Service_Job__c != null) {
                    system.debug('8888888');
                    /*List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
                    solComp = [SELECT Id, CSS_Claims__c, CSS_Account_Formula__c,Type__c, CSS_Failure_Sequence_Number__c, CoveredPartsQty__c, CampaignPartsPercentage__c, CoveredOCAmount__c, 
                                      CampaignOCPercentage__c, FailCode_Formula__c,CoveredLaborHrs__c, CampaignLaborPercentage__c, CoveredTravelBaseFareAmt__c, CoveredTravelLabor__c,
                                      CoveredTravelMiles__c, CoveredTowingMiles__c, CoveredMealsLodgingAmt__c, CampaignTravelPercentage__c, CampaignTowingPercentage__c FROM CSS_Solution_Component__c 
                                      WHERE CSS_Claims__c =: claimId AND (Type__c NOT IN ('Campaign','ATC','TRP') OR (Type__c IN ('Campaign','ATC','TRP') AND Selected_Component__c = true))];
                    system.debug('solComp007--'+solComp);*/ //Moved to above which is required to execute for Manual Claims also
                    
                    Map<String, List<CSS_Solution_Component__c>> mapSolCompCoverage = new Map<String, List<CSS_Solution_Component__c>>();
                    for(CSS_Solution_Component__c SC : solComp){
                        if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.CSS_Account_Formula__c != 'Select One'){
                            List<CSS_Solution_Component__c> tempLst = new List<CSS_Solution_Component__c>();
                            string failcode;
                            if(sc.type__c == null || sc.type__c == '')
                                failcode = SC.FailCode_Formula__c.right(4);
                            else
                                failcode = SC.FailCode_Formula__c.right(6);
                            if(!mapSolCompCoverage.containskey(failcode)){
                                tempLst.add(SC);
                                mapSolCompCoverage.put(failcode, tempLst);
                            }
                            else{
                                tempLst = mapSolCompCoverage.get(failcode);
                                tempLst.add(SC);
                                mapSolCompCoverage.put(failcode, tempLst);
                            }
                        }
                        
                    //GSSC-106
                    /*if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.CSS_Account_Formula__c.contains('70')){
                        milProdhrsError = true;
                    }*/

                    }
                    system.debug('mapSolCompCoverage007--'+mapSolCompCoverage);
                    
                    list<CSS_Parts_Options__c> claimsPOList = [select Id, Account_Code__c, Fail_Code__c, Type__c, RecordTypeId, Parts_Type__c 
                                                                FROM CSS_Parts_Options__c
                                                                WHERE CSS_Claims__c =: claimsRec.id 
                                                                    AND (Account_Code__c = null OR Account_Code__c = '' OR Account_Code__c = 'Select One') 
                                                                    AND (Fail_Code__c != null OR Fail_Code__c != '') 
                                                              ];
                    system.debug('claimsPOList.size() ' + claimsPOList.size() + claimsPOList);
                    Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                    Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
                    Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
                    for(CSS_Parts_Options__c PO : claimsPOList){
                        string[] failcodestring;
                        string srtcode;
                        List<CSS_Solution_Component__c> tempLst = new List<CSS_Solution_Component__c>();
                        if(PO.Fail_Code__c != null && PO.Fail_Code__c.contains('-')) {
                            failcodestring = PO.Fail_Code__c.split('-');
                            srtcode = failcodestring[1];
                        } else
                            srtcode = PO.Fail_Code__c;
                            
                        tempLst = mapSolCompCoverage.get(srtcode);
                        
                        if(tempLst!=null){
                            if(PO.RecordTypeId == recTypeIdpart){
                                if(PO.Parts_Type__c == 'Custom'){
                                    if(((tempLst[0].Type__c == null || tempLst[0].Type__c == '') && (tempLst[0].CoveredPartsQty__c != null && tempLst[0].CoveredPartsQty__c != '' && double.valueof(tempLst[0].CoveredPartsQty__c) > 0)) ||
                                    ((tempLst[0].Type__c != null && tempLst[0].Type__c != '') && (tempLst[0].CampaignPartsPercentage__c != null && tempLst[0].CampaignPartsPercentage__c != '' && double.valueof(tempLst[0].CampaignPartsPercentage__c) > 0))){
                                        //Do nothing
                                    }
                                    else{
                                        PO.Fail_Code__c = 'Select One';
                                    }
                                }
                                else{
                                    if((tempLst[0].Type__c == null || tempLst[0].Type__c == '') && (tempLst[0].CoveredPartsQty__c != null && tempLst[0].CoveredPartsQty__c != '' && double.valueof(tempLst[0].CoveredPartsQty__c) > 0)){
                                        //Do nothing
                                    }
                                    else{
                                        PO.Fail_Code__c = 'Select One';
                                    }
                                }
                            }
                            else if(PO.RecordTypeId == recTypeIdOC){
                                if(((tempLst[0].Type__c == null || tempLst[0].Type__c == '') && (tempLst[0].CoveredOCAmount__c != null && tempLst[0].CoveredOCAmount__c != '' && double.valueof(tempLst[0].CoveredOCAmount__c) > 0)) ||
                                    ((tempLst[0].Type__c != null && tempLst[0].Type__c != '') && (tempLst[0].CampaignOCPercentage__c != null && tempLst[0].CampaignOCPercentage__c != '' && double.valueof(tempLst[0].CampaignOCPercentage__c) > 0))){
                                        //Do nothing
                                }
                                else{
                                    PO.Fail_Code__c = 'Select One';
                                }
                            }
                            else if(PO.RecordTypeId == recTypeIdTTML){
                                if(PO.Type__c == 'Commercial-Travel'){
                                    if(((tempLst[0].Type__c == null || tempLst[0].Type__c == '') && (tempLst[0].CoveredTravelBaseFareAmt__c != null && tempLst[0].CoveredTravelBaseFareAmt__c != '' && double.valueof(tempLst[0].CoveredTravelBaseFareAmt__c) > 0) && 
                                      (tempLst[0].CoveredTravelLabor__c != null && tempLst[0].CoveredTravelLabor__c != '' && double.valueof(tempLst[0].CoveredTravelLabor__c) > 0)) ||
                                      ((tempLst[0].Type__c != null && tempLst[0].Type__c != '') && (tempLst[0].CampaignTravelPercentage__c != null && tempLst[0].CampaignTravelPercentage__c != '' && double.valueof(tempLst[0].CampaignTravelPercentage__c) > 0))){
                                        //Do nothing
                                    }
                                    else{
                                        PO.Fail_Code__c = 'Select One';
                                    }
                                }
                                else if(PO.Type__c == 'Non Commercial-Travel'){
                                    if(((tempLst[0].Type__c == null || tempLst[0].Type__c == '') && (tempLst[0].CoveredTravelMiles__c != null && tempLst[0].CoveredTravelMiles__c != '' && double.valueof(tempLst[0].CoveredTravelMiles__c) > 0) && 
                                      (tempLst[0].CoveredTravelLabor__c != null && tempLst[0].CoveredTravelLabor__c != '' && double.valueof(tempLst[0].CoveredTravelLabor__c) > 0)) ||
                                      ((tempLst[0].Type__c != null && tempLst[0].Type__c != '') && (tempLst[0].CampaignTravelPercentage__c != null && tempLst[0].CampaignTravelPercentage__c != '' && double.valueof(tempLst[0].CampaignTravelPercentage__c) > 0))){
                                        //Do nothing
                                    }
                                    else{
                                        PO.Fail_Code__c = 'Select One';
                                    }
                                }
                                else if(PO.Type__c == 'Towing'){
                                    if(((tempLst[0].Type__c == null || tempLst[0].Type__c == '') && (tempLst[0].CoveredTowingMiles__c != null && tempLst[0].CoveredTowingMiles__c != '' && double.valueof(tempLst[0].CoveredTowingMiles__c) > 0)) ||
                                        ((tempLst[0].Type__c != null && tempLst[0].Type__c != '') && (tempLst[0].CampaignTowingPercentage__c != null && tempLst[0].CampaignTowingPercentage__c != '' && double.valueof(tempLst[0].CampaignTowingPercentage__c) > 0))){
                                            //Do nothing
                                    }
                                    else{
                                        PO.Fail_Code__c = 'Select One';
                                    }
                                }
                                else if(PO.Type__c=='Meals' || PO.Type__c=='Lodging'){
                                    if(((tempLst[0].Type__c == null || tempLst[0].Type__c == '') && (tempLst[0].CoveredMealsLodgingAmt__c != null && tempLst[0].CoveredMealsLodgingAmt__c != '' && double.valueof(tempLst[0].CoveredMealsLodgingAmt__c) > 0)) ||
                                        ((tempLst[0].Type__c != null && tempLst[0].Type__c != '') && (tempLst[0].CampaignTravelPercentage__c != null && tempLst[0].CampaignTravelPercentage__c != '' && double.valueof(tempLst[0].CampaignTravelPercentage__c) > 0))){
                                            //Do nothing
                                    }
                                    else{
                                        PO.Fail_Code__c = 'Select One';
                                    }
                                }
                            }
                        
                        }    
                    }
                    
                    list<CSS_SRT__c> claimsSRTList = [SELECT Id, Name, Account_Code__c,SRT_Category__c, FailCode__c, AccountCode_Formula__c
                                                        , Fail_Code_Description__c, Type__c,isPerformed__c, SRT_Type__c
                                                      FROM CSS_SRT__c 
                                                      WHERE CSS_Claims__c =: claimsRec.id  
                                                        AND (Account_Code__c = null OR Account_Code__c = '' OR Account_Code__c = 'Select One') 
                                                        AND (FailCode__c != null OR FailCode__c != '')
                                                    ];
                    system.debug('claimsSRTList.size() ' + claimsSRTList.size() + claimsSRTList);
                    
                    for(CSS_SRT__c srts : claimsSRTList){
                        List<CSS_Solution_Component__c> tempLst = new List<CSS_Solution_Component__c>();
                        string[] failcodestring;
                        string srtcode;
                        if(srts.FailCode__c != null && srts.FailCode__c.contains('-')) {
                            failcodestring = srts.FailCode__c.split('-');
                            srtcode = failcodestring[1];
                        } else
                            srtcode = srts.FailCode__c;
                            
                        tempLst = mapSolCompCoverage.get(srtcode);
                        system.debug('Testhou'+tempLst);
                        
                        if(tempLst!=null){
                            if((srts.Type__c == 'Diagnosis' && (srts.SRT_Category__c == '' || srts.SRT_Category__c == null)) || srts.SRT_Category__c == 'AdditionalDiag' || srts.Type__c == 'Diag Access'){
                                if((tempLst[0].CoveredLaborHrs__c != null && tempLst[0].CoveredLaborHrs__c != '' && double.valueof(tempLst[0].CoveredLaborHrs__c) > 0)){
                                    //Do nothing
                                }
                                else{
                                    srts.FailCode__c = 'Select One';
                                }
                                system.debug('Test33'+ tempLst[0].CoveredLaborHrs__c);
                            }
                            //system.debug('Testtype'+srts.Type__c);
                            
                            else if(srts.Type__c == 'Repair' && (srts.SRT_Category__c != '' || srts.SRT_Category__c != null)){ 
                                system.debug('Test33'+ tempLst[0].CoveredLaborHrs__c);
                                if((tempLst[0].CoveredLaborHrs__c != null && tempLst[0].CoveredLaborHrs__c != '' && double.valueof(tempLst[0].CoveredLaborHrs__c) > 0)){
                                    //Do nothing
                                }
                                else{
                                    srts.FailCode__c = 'Select One';
                                }
                            }
                            else if(srts.SRT_Category__c == 'AdditionalRep' || srts.Type__c == 'Repair Access'){
                                if((tempLst[0].CoveredLaborHrs__c != null && tempLst[0].CoveredLaborHrs__c != '' && double.valueof(tempLst[0].CoveredLaborHrs__c) > 0)){
                                    //Do nothing
                                }
                                else{
                                    srts.FailCode__c = 'Select One';
                                }
                            }
                            else if(srts.Type__c == '99Time'){
                                //do nothing
                            }
                            else{
                                if((tempLst[0].CampaignLaborPercentage__c != null && tempLst[0].CampaignLaborPercentage__c != '' && double.valueof(tempLst[0].CampaignLaborPercentage__c) > 0)){
                                    //Do nothing
                                }
                                else{
                                    srts.FailCode__c = 'Select One';
                                }
                            }
                    
                        }  
                        
                    }
                    
                    system.debug('claimsPOList - 007 - ' + claimsPOList);
                    if(claimsPOList != null && claimsPOList.size() >0)
                        update claimsPOList;
                    system.debug('claimsSRTList - 007 - ' + claimsSRTList);
                    if(claimsSRTList != null && claimsSRTList.size() >0)    
                        update claimsSRTList;
                }
                
                
                if(psnRec.CSS_Claims__c == null){
                    psnNewRec.CSS_Claims__c = claimId;}  
                upsert psnNewRec;
                
                //GSSC-106
                CSS_Claims__c mileageprodhrsError = new CSS_Claims__c();
                mileageprodhrsError.id = claimId;
                mileageprodhrsError.MileageProdHrsError__c = 'Success';
                system.debug('milProdhrsError--'+milProdhrsError+' psnNewRec.License_Plate_State__c:'+psnNewRec.License_Plate_State__c);
                if(milProdhrsError == true){
                    if(claimNewRec.Automotive_App_Flag__c == 'Y' && psnNewRec.License_Plate_State__c == 'CA - California'){
                            if((psnNewRec.Mileage__c == null || psnNewRec.Mileage__c == 0) || (psnNewRec.Product_Hours__c == null || psnNewRec.Product_Hours__c == 0)){
                                mileageprodhrsError.MileageProdHrsError__c = 'Error';
                                system.debug('Error loop--'+mileageprodhrsError.MileageProdHrsError__c);
                            }
                            else{
                                mileageprodhrsError.MileageProdHrsError__c = 'Success';
                                system.debug('Success loop--'+mileageprodhrsError.MileageProdHrsError__c);
                            }
                    }
                }
                system.debug('mileageprodhrsError--'+mileageprodhrsError);
                update mileageprodhrsError;

                if(IEList!=null && IEList.size()>0)
                insert IEList;

                if(claimListNew != null && claimListNew.size() > 0) {
                    for(CSS_JobEventTemporary__c jet : claimListNew) {
                        string key = psnRec.PSN__c + ':' + claimId;
                        jet.key__c = key;
                    }
                    delete claimListOld;
                    insert claimListNew;
                    system.debug('claimListNew >>> ' + claimListNew);
                }
            }
            //Calling Field Actions After insert of PSN & ClaimRecs
            /*if(claimNewRec != null && psnNewRec != null){
    system.debug('Inside CampService Call**');
    String FailureDateString = DateTime.newInstance(psnNewRec.Failure_Date__c.year(),psnNewRec.Failure_Date__c.month(),psnNewRec.Failure_Date__c.day()).format('dd-MMM-YY');
    CG_OP_OAGWrapper reswrap = CG_BL_Campaigns.callGetCampaignsWSforClaims(psnRec.psn__c, FailureDateString, '','', 'CSS','GetCampaign','UniqueID','CSSWarranty', '', null,claimsRec.id);

    system.debug('reswrap***'+reswrap);
    }*/

            //Calling getServiceProviderDataClaims method on claims creation
            /*if(claimNewRec != null && psnNewRec != null){
    system.debug('Inside getServiceProviderDataClaims Call**');
    string FailureDateString;
    string SPCode;
    string ServiceModelName='';
    if(psnNewRec.Primary__c == true){
    system.debug('psnrec.Failure_Date__c**'+psnNewRec.Failure_Date__c);
    system.debug('psnrec.CSS_Claims__r.Location_Code__c**'+claimNewRec.Location_Code__c);
    if(psnNewRec.Failure_Date__c != null && claimNewRec.Location_Code__c != null){
    System.debug('in psnrecinsert before calling qwebservice$$$$$$$$...');
    FailureDateString = DateTime.newInstance(psnNewRec.Failure_Date__c.year(),psnNewRec.Failure_Date__c.month(),psnNewRec.Failure_Date__c.day()).format('dd-MMM-YY');
    //SPCodeOrig= CSS_Claims__c.CSS_Claims__r.Location_Code__c;
    SPCode = claimNewRec.Location_Code__c.split('-')[1];
    System.debug('***SP Code***'+SPCode+'*****ServiceModelName*****'+ServiceModelName+'*****FailureDateString*****'+FailureDateString+'*****ClaimId****'+claimNewRec.Id);
    CSS_FN_SIEBEL.getServiceProviderDataClaims(SPCode, ServiceModelName, FailureDateString, claimNewRec.Id);
    }
    }
    }*/

            if(psnRec.Before_In_Service__c == false && psnRec.Warranty_Start_Date__c == null ){

                warrantyStartDateValidate = true;
                system.debug('warrantyStartDateValidate '+warrantyStartDateValidate);
            }
            else if(psnRec.Before_In_Service__c == true){

                warrantyStartDateValidate = false;
            }
            else{
                warrantyStartDateValidate = false;
            }
            system.debug('warrantyStartDateValidate '+warrantyStartDateValidate);
            system.debug('psnRec.Before_In_Service__c '+psnRec.Before_In_Service__c);
            system.debug('psnRec.Warranty_Start_Date__c '+psnRec.Warranty_Start_Date__c);

        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_ClaimsIntake pgSave method >>> '+e.getMessage() +' LineNo>>>:'+ e.getLineNumber());
            return null;
        }
        return claimId;
    }
    public boolean setPACCAR_Flag(){
        List<CSS_Accreditation__c> accredLst = new List<CSS_Accreditation__c>();
        //accredLst = [SELECT Id FROM CSS_Accreditation__c WHERE OEM_Code__c IN ('68','232','326','327') AND StartDate__c <: psnRec.Failure_Date__c AND EndDate__c >=: psnRec.Failure_Date__c  AND  Service_Model_Name__c =: psnRec.Service_Model__c AND Account__c =: claimsRec.Account__c];
        //Commented above to check any of the SMN is active for a given SP code
        accredLst = [SELECT Id FROM CSS_Accreditation__c WHERE OEM_Code__c IN ('68','232','326','327') AND StartDate__c <: psnRec.Failure_Date__c AND EndDate__c >=: psnRec.Failure_Date__c AND Account__c =: claimsRec.Account__c];
        //system.debug('accredLst'+accredLst[0].Id);
        system.debug('accredLst'+accredLst.size());
        if(accredLst != null && accredLst.size() > 0)
            return true;
        else
            return false;
    }
    public PageReference paccarPopUP_OK()
    {
        //showErrorPopup = false;
        if(claimsRec.CSS_Job__c != null){
            PageReference pageRef = new pageReference('/apex/CG_MyClaims'); 
            pageRef.setRedirect(true);
            delete claimsRec;
            return pageRef;            
        }
        else
            return null;
    }


    public void multipsnchecbox(){

        List<CSS_Solution_Component__c>  solComps1= new List<CSS_Solution_Component__c>();

        solComps1 = [select Id, Claim_FailCode__c,Fail_Code__c,type__c,Selected_Component__c,AccountCode__c,CSS_Account_Formula__c
                     from CSS_Solution_Component__c 
                     where CSS_Claims__c =:cId and Selected_Component__c = true];

        system.debug('solComps1'+solComps1);
        system.debug('cId'+cId);

        system.debug('psnRec'+psnRec); 
        integer campcount = 0;
        integer Atccount= 0;
        integer failurescount = 0;
        boolean hasfieldactions= false;


        if( psnRec.Before_In_Service__c!= true && solComps1.size()>0){
            if( psnRec.Before_In_Service__c!= true && solComps1.size()>0){
                integer i = 0;
                for(CSS_Solution_Component__c solComs:solComps1){
                    if(solComs.type__c!='Campaign' && solComs.type__c!= 'ATC' && solComs.type__c!= 'TRP'){
                        i++;
                        if(i>1){
                            MultipsncheckboxEnable = true; 
                            break;
                        }
                        else
                            MultipsncheckboxEnable = false;
                    }
                }
            }   
            system.debug('psnRec.Before_In_Service__c'+psnRec.Before_In_Service__c);
        }else if(psnRec.Before_In_Service__c== true ){
            system.debug('psnRec.Before_In_Service__c'+psnRec.Before_In_Service__c);
            if(solComps1.size() == 0)
                MultipsncheckboxEnable = false; 
            else{
                for(CSS_Solution_Component__c solComs:solComps1){
                    if(solComs.type__c!='Campaign' && solComs.type__c!= 'ATC' && solComs.type__c!= 'TRP'){

                        //if(solComs.CSS_Account_Formula__c== ('NEW-New Engine Warranty 67')){
                        if(solComs.CSS_Account_Formula__c != null && solComs.CSS_Account_Formula__c.contains('67')){
                            MultipsncheckboxEnable = false; 
                            system.debug('MultipsncheckboxEnable');
                        }
                        else{
                            MultipsncheckboxEnable = true;
                            break;
                        }
                    }
                }
                for(CSS_Solution_Component__c solComs:solComps1){
                    if(solComs.type__c!='Campaign' && solComs.type__c!= 'ATC' && solComs.type__c!= 'TRP'){
                        failurescount= failurescount+1;

                    }else{
                        hasfieldactions= true;
                        if(solComs.type__c== 'Campaign')
                            campcount= campcount+1;
                        else if(solComs.type__c == 'ATC') 
                            Atccount =  Atccount+1;
                    }
                }
                if(failurescount>0){
                    if( MultipsncheckboxEnable == false && hasfieldactions==false)
                        MultipsncheckboxEnable = false; 
                    else
                        MultipsncheckboxEnable = true; 
                }
                else{
                    if((campcount==1 && Atccount==0) ||(campcount==0 && Atccount==1)){

                        MultipsncheckboxEnable = false;
                        system.debug('MultipsncheckboxEnable'+MultipsncheckboxEnable);
                    }else {
                        MultipsncheckboxEnable = true; 
                        system.debug('MultipsncheckboxEnable'+MultipsncheckboxEnable);
                    }
                }
            }

        }
        
        if(claimsRec != null && claimsRec.status__c != null && claimsRec.status__c == 'Submitted')
            MultipsncheckboxEnable = true;

    }
    //Added below method as part of the story GSSC-71
    public void setPaccarPW(){
        system.debug(' inside setPaccarPW isPaccarAndPW--> '+isPaccarAndPW);
    }
    
    public List<SelectOption> getPreventiveMaintenance() { 
        Schema.DescribeFieldResult fieldResult = CSS_Claims__c.Claims_Preventive_Maintenance__c.getDescribe();
        List<Schema.PicklistEntry> lstPrevMaintenance = fieldResult.getPicklistValues();
        System.debug('Picklist::'+ lstPrevMaintenance);

        List<SelectOption> lstPrevMaintenance1=new List<SelectOption>();
        for( Schema.PicklistEntry entry : lstPrevMaintenance){
            lstPrevMaintenance1.add(new SelectOption(entry.getValue(),entry.getLabel()));
        }
        system.debug('LstAppValues1---->'+lstPrevMaintenance1);
        return lstPrevMaintenance1;
        

    }
}