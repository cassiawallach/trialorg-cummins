/**********************************************************************
Name:CG_CL_ClaimsVS
Copyright © 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
We are using this Page Controller for Claims Verify & Submit Chevron.
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.0 -      Surender M        02/12/2018          Added Constructor & Updated Navigations
***********************************************************************/
public  class CG_CL_ClaimsVS {

    //Global Variables.
    public CG_CL_ClaimsVS controllerRef {set;get;}
    public Id cId{get;set;}
    public list<Note> ClaimNotesList {get;set;}
    public CSS_Claims__c claimsRec {set;get;}
    public List<CSS_PSN__c>lstPSN{get;set;}
    public CSS_Claim_Submission__c claimSubRec {set;get;}
    public Boolean psncheck {get;set;}
    public List<CSS_Solution_Component__c> solComps;
    public boolean checkAccountCode{get; set;}
    //public CSS_Solution_Component__c claimsSCList{get;set;}
    public string warrantyAuthFlag {get; set;}
    public list<CSS_Claim_Submission__c> lstsubmissionRecord {get; set;}    
    public list<claimWrapperClass> lstclaimWrapper {get;set;}
    public list<failureWrapperClass> lstfailureWrapper {get;set;}
    public list<multiPSNWrapperClass> lstmultiPartWrapper {get;set;}
    public list<partsWrapperClass> lstpartsWrapperClass {get;set;}
    public list<otherClaimWrapperClass> lstotherClaimWrapperClass {get;set;}
    public list<TTMLWrapperClass> lstTTMLWrapperClass {get;set;}
    public list<SRTsWrapperClass> lstSRTsWrapperClass {get;set;}
    public list<fieldActionSRTsWrapperClass> lstfieldActionSRTsWrapper {get;set;}
    public CSS_Solution_Component__c solncmpnt{get;set;}
    public CSS_Parts_Options__c prtopt{get;set;}
    public CSS_SRT__c srtrec{get;set;}
    public CSS_PSN__c psnRec{set;get;} 
    public boolean subButton{get;set;}
    public boolean dispSubmitButton{get;set;}
    public boolean showsubmitButton { get;set;}//showsubmitButton
    public boolean showReopenButton { get;set;}//showReopenButton
    public boolean editQuantity{get;set;}
    public boolean dealerCustomer{get;set;}
    public string accCodeSelected {get;set;}
    public Boolean licenseError {get;set;}
    public Boolean validationOnAdditionalPSN {get;set;}
    //public Boolean enableSubmitButton {get;set;}
    Map<String, List<ClaimNotes>> claimSubWithNotes;
    list<CSS_Claim_Submission__c> lstbmssubmissionRecord = new list<CSS_Claim_Submission__c>();
    Transient public list<CSS_Solution_Component__c> claimsSCList = new list<CSS_Solution_Component__c>();
    Transient public list<CSS_Parts_Options__c> claimsPOList = new list<CSS_Parts_Options__c>();
    Transient public list<CSS_SRT__c> claimsSRTList = new list<CSS_SRT__c>();
    Transient public CSS_Claims__c Claims = new CSS_Claims__c();
    Transient public list<Note> ClaimNotejsnList=new list<Note>();
    public list<Attachment> claimsattachment = new list<Attachment>();
    public list<CSS_Solution_Component__c> solPartsQuantityList = new list<CSS_Solution_Component__c>();
    list<CSS_Solution_Component__c> ZeroDollarSCList = new list<CSS_Solution_Component__c>();
    public list<CSS_Claim_Submission__c> ClaimsSubmissionList = new list<CSS_Claim_Submission__c>();
    public Map<string, list<CSS_Solution_Component__c>> SCAccountCodeMap = new Map<string, list<CSS_Solution_Component__c>>();//Account code, Solution component Records.
    public Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap = new Map<string, list<CSS_Parts_Options__c>>();//Account code+Fail Code, PART OPTION Records.
    public Map<string, list<CSS_SRT__c>> SRTAccountCodeMap = new Map<string, list<CSS_SRT__c>>();//Account code+Fail Code, PART OPTION Records.
    public List<String> partsWarranty = new List<String>();
    public List<String> fieldActionAcountcodeList = new List<String>();
    //public Set<String> coverageType = new Set<String>();
    public Map<String,String> categoryCompliantCode = new Map<String, String>();
    public string certiNumber = '';
    public Decimal totalUSD{get;set;}
    //public Boolean isMultiPSN{get;set;}
    public List<PromotionIds> promotionIdLst{get; set;}
    Map<id,CSS_Claim_Submission__c> claimSubMap;
    public boolean SWORequired {get; set;}
    public boolean displayEdit{get;set;}
    //public Map<String, String> accCodeCoverageType{get;set;}
    public Map<String, String> accCodeCoverageType = new Map<String, String>();//GSSC-246 - By Krishna
    public String multiPSN_CampNum{get;set;}
    public Map<String, String> techUserPromoIdTTML = new Map<String, String>();
    public Map<String, CSS_SRT__c> overlapSRT_Map{get;set;}
    public Map<String, list<CSS_SRT__c>> overlapSRTListMap{get;set;}
    public List<AdditionalESNs> addESNObj{get;set;}
    public boolean pendingAuthFlag{get;set;}
    public boolean FailcodeEQError{get;set;} 
    public string userType;
    public  Boolean isCatastrophic{get;set;}
    public decimal partsUSD{get;set;}
    public boolean dealerLocation {get; set;}
    public decimal partstotalUSd{get; set;}
    public string factoryUserWWid{get; set;}
    public boolean errorttmlflag{get;set;}
    public boolean errorserviceflag{get;set;}
    //public decimal totalUSD{get;set;}
    public static final Integer Claim_Fork = 1000;//Declaring a constant variable with infinity value
    public Boolean isPartsCovLimitExceed{get;set;}
    public Boolean isSRTCovLimitExceed{get;set;}
    public Boolean isSRTwithFailcodeCovLimitExceed{get;set;}
    public boolean isAutomatedDealer{get; set;}
    public UserRole urRole = new UserRole();
    public Boolean DealerTypeFlag{get; set;}
    public List<CSS_Solution_Component__c> solCompsPSNCheck;
    public User userRec{get;set;}
    public List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>(); //GSSC-138
    public Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>();//GSSC-138
    public Decimal exchangeRate;//GSSC-138
    //Constructor.
    public CG_CL_ClaimsVS(){
        userRec = [SELECT id, DefaultCurrencyIsoCode, CurrencyIsoCode From User Where id =: userInfo.getUserId() limit 1];
        
        //GSSC-138-start    
        if(userinfo.getDefaultCurrency() == 'USD'){
            lstCurrencyDetails = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c order by Bolt_Version__c desc limit 1];
        }
        else{
            lstCurrencyDetails = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c where Bolt_To_Currency__c =: userinfo.getDefaultCurrency() order by Bolt_Version__c desc limit 1];
        }
        //GSSC-138-end
        
        pendingAuthFlag = false;
        licenseError = false;
        subButton = false;
        dispSubmitButton = true;
        showsubmitButton = false;
        showReopenButton = false;
        SWORequired = false;
        //isMultiPSN = false;
        FailcodeEQError = false;
        //enableSubmitButton=false;
        validationOnAdditionalPSN=false;
        displayEdit = false;
        System.debug('IN CG_CL_ClaimsVS constructor...');
        try {
            psncheck = false;
            checkAccountCode=false;
            solComps = new List<CSS_Solution_Component__c>();
            solCompsPSNCheck = new List<CSS_Solution_Component__c>();
            claimSubRec = new CSS_Claim_Submission__c();
            cId=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('MyClaimId**'+cId);

            if(cId == null) {
                claimsRec = new CSS_Claims__c();  
                psnRec = new CSS_PSN__c(); 
            } 
            else {
                lstPSN = new List<CSS_PSN__c>();
                lstmultiPartWrapper = new list<multiPSNWrapperClass>();
                system.debug('MyClaimId**'+cId);
                fetchClaimRecords();
                //added the below line for claims enabled check for the story 156990
            }

        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsVS constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('returning from CG_CL_ClaimsVS constructor...');
        //GSSC-138-start
        if(userinfo.getDefaultCurrency() != 'USD'){
            Currency_Conversion__c[] CurrencyConversion = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c where Bolt_To_Currency__c =: userinfo.getDefaultCurrency() order by Bolt_Version__c desc limit 1];
            if(CurrencyConversion != null && CurrencyConversion.size() >0) {
            	exchangeRate = CurrencyConversion[0].Bolt_Conversion_Rate__c;
            }
            //if(exchangeRate!=null )
            //exchangeRate = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c where Bolt_To_Currency__c =: userinfo.getDefaultCurrency() order by Bolt_Version__c desc limit 1].Bolt_Conversion_Rate__c;
        }
        //GSSC-138-end
    }
    //Constructor.

    //Fetching Claims Record
    public void fetchClaimRecords(){
        
         
            urRole = [Select name from UserRole where id=:UserInfo.getUserRoleId()];
        system.debug('cId...'+ cId);

        try {
            claimsRec =[Select Id,LastSavedDate__c,IsCopyclaim__c,isAutomatedCopyClaim__c,Last_saved_by__c, Failures_ODM_Status__c, Parts_ODM_Status__c, SRTs_ODM_Status__c, PartsRelatedODMMessage__c,FieldActionWebServiceResult__c,Additional_Tech1__c, Dealer_Service_Job__c, Dealer_Service_Job__r.ApplicationCode__c, CreatedById, Additional_Tech2__c, Additional_Tech3__c, Additional_Tech4__c, Additional_Tech5__c, Additional_Tech6__c, Additional_Tech7__c, Additional_Tech8__c, Additional_Tech9__c,EditCause__c,EditComplaint__c,Assigned_To__c,Non_SRT_Details__c,Actual_Technician_Time__c,SP_TERRITORY_CODE__c, CSS_Job__r.General_Symptoms__c,License_Plate_State_Error_message__c,EditCorrection__c,Information_Only_Claim__c,Automotive_App_Flag__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                        CSS_Job__r.Complaint_Type2_Desc__c,SRT_FlexTime_Error__c,Dealer_Service_Job__r.Name,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                        CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c, ODM_Penalty__c, 
                        Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                        Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c, Customer_Code__c,MileageProdHrsError__c,
                        Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                        Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,IsDealerCreatedClaim__c,
                        Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                        Location_Code__c,ProductApplicationCode__c,Account__r.RSS_RESP_BRANCH_CODE__c,Account__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c, CSS_Job__r.ApplicationCode__c,
                        CoverageResponse__c,Claim_Submitted__c,SP_Country__c,SP_PrimaryOEMCode__c,EngineFamilyName__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                        CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                        TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,isCalibrationFieldsBlank__c,
                        SP_PromotionId__c, Repair_Location__c,CSS_Job__r.Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                        ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                        SP_Group_Name__c, SP_SCMDollarAmt__c, Service_Model__c, SP_WarrantyTrainingStatus__c,Pending_Authorization__c,SP_State__c,SP_SCMDeductiblePercentage__c,Mutual_Exclusive_Message__c,SRT_Olap_Reason_Msg__c,SRT_902_Error_Message__c,DupAccessCodePercentReqMsg__c,Overlap_Service_Failure_Msg__c,Multi_PSN_Claim__c, Account__r.Type,
                        SP_CMI_SP_EXPIRATION__c, SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,SP_INSHOP_LABOR_RATE__c,SP_FIELD_SERVICE_LABOR_RATE__c,Account__r.ERP_System__c, Total_PSN_Count__c,PACCAR_Flag__c,
                        (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,Revision_Before__c,Revision_After__c,
                         Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c,Unit_Type__c,License_Plate_State__c  from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id= :cId];   
                        
                        
                        system.debug('**claimsRec.Account__r.Enable_Claims__c**'+claimsRec.Account__r.Enable_Claims__c);
                        system.debug('**claimsRec.Account__r.Type**'+claimsRec.Account__r.Type);
                       DealerTypeFlag = CSS_utility.getAccounttype(claimsRec.Account__r.Type);
                        if(DealerTypeFlag ==true && claimsRec.Account__r.Enable_Claims__c==true){//Dealers with claim enabled locations
                            dealerLocation=true;
                        }
                        else
                            dealerLocation=false;
                        
                        if((claimsRec.Dealer_Service_Job__c!=null || claimsRec.CSS_Job__c!=null) && DealerTypeFlag ==true && urRole.name == 'Factory'){
                                isAutomatedDealer = true;
                                //system.debug('**isAutomatedDealer***'+isAutomatedDealer);
                            } else{
                                //system.debug('**isAutomatedDealer else ***'+isAutomatedDealer);
                                //system.debug('claimsRec.Dealer_Service_Job__c'+claimsRec.Dealer_Service_Job__c);
                                //system.debug('claimsRec.Account__r.Type'+claimsRec.Account__r.Type);
                                isAutomatedDealer = false;
                            }
                       

            solPartsQuantityList = [select Id,Type__c,CSS_Claims__c,(select Id,FailurepartId__c,selected_part__c,Quantity__c,BMS_Quantity__c,CSS_Claims__c from CSS_Parts_Options__r where Quantity__c != null) 
                                    from CSS_Solution_Component__c where (Type__c='Campaign' OR Type__c='TRP' OR Type__c='ATC') and CSS_Claims__c =:cId and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];

            system.debug('Solution component Parts' +solPartsQuantityList.size());
            system.debug('solution component parts' + solPartsQuantityList);

            claimSubMap =  new Map<id,CSS_Claim_Submission__c>([select Id,Name,Individual_Claim_Id__c, Claim_JSON__c, Account_Code__c, Status__c from CSS_Claim_Submission__c where CSS_Claims__c = :cId ]);
            system.debug('claimSubMap ' + claimSubMap); 

        } catch(Exception ex) {
            system.debug('in the exception of fetchClaimRecords Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }
    }

    //Fetching Claims Related Records like Solution Component, Parts and SRT records
    public void fetchClaimRelatedRecords(){
        system.debug('cId...'+ cId);

        try {

            //****************************************************************Getting Multi-PSN chevron basend on condition from Solution component Object 154239 By RAJESH *****************************************************************************************************                
            solComps = [select Id,CoverageTravelBaseFareMsgTstatus__c,Claim_FailCode__c,AccountCode_Call_Status__c, CSS_Primary_Failure__c,Failure_Mode__c,CSS_Failure_Sequence_Number__c,Name,Quantity__c,Component_Id__c,Fail_Code__c,type__c,Selected_Component__c,AccountCode__c,CSS_Account_Formula__c,
                        CoverageLimitExceedMsg_Status__c, CoverageLimitExceedMsgSRT_Status__c,OldSolCompID__c from CSS_Solution_Component__c
                        //where CSS_Claims__c =:claimsRec.id  AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC') AND Selected_Component__c = true) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved'))]; 
                        where CSS_Claims__c =:claimsRec.id AND Selected_Component__c = true AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC')) OR (Type__c IN ('Campaign','ATC', 'TRP') AND Status__c='Approved'))]; 

            if(claimsRec.Catastrophic__c==true)
            {
                isCatastrophic=true;  
            }
            else{
                isCatastrophic=false;
            }
            isPartsCovLimitExceed = false;
            isSRTwithFailcodeCovLimitExceed=false;
            isSRTCovLimitExceed=false;
            errorttmlflag = false;
            errorserviceflag = false;
            for(css_solution_component__c SC: solComps){
                if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                    checkAccountCode=true;
                }
                if(SC.CoverageLimitExceedMsg_Status__c == 'ERROR'){
                    isPartsCovLimitExceed = true;
                }
                if(SC.CoverageTravelBaseFareMsgTstatus__c == 'ERROR'){
                    errorttmlflag = true;
                }
                //Added Condition for Inside Out Sprint 183076 -- Rajasekhar H// 
                 if(SC.AccountCode_Call_Status__c == 'Failure'){
                    errorserviceflag = true;
                }
                //End
                //Below code as part of the stories #179802(Claims) and #180119(Claims)-By RAJESH 08 Apr 2019             
                if(SC.CoverageLimitExceedMsgSRT_Status__c =='ERROR'){
                    isSRTCovLimitExceed = true;
                }
                //End             
            }
            system.debug('solComps.size()*****'+solComps.size());
            if(claimsRec!=null && claimsRec.id!=null && checkAccountCode==true){
                if(claimsRec.Multi_PSN_Claim__c== true)
                {
                    psncheck = true;
                    for(css_solution_component__c SC: solComps){
                        if(SC.Type__c == 'Campaign' && multiPSN_CampNum == null){
                            multiPSN_CampNum = SC.Component_Id__c;
                        }
                    }
                }else{
                    psncheck = false;
                    for(css_solution_component__c SC: solComps){
                        if((SC.Type__c == 'Campaign' || SC.Type__c == 'TRP' || SC.Type__c == 'ATC') && multiPSN_CampNum == null){
                            multiPSN_CampNum = SC.Component_Id__c;
                        }
                    }
                }
            }
            //**************************************************************************END 154239 ************************************************************************************8                 
            //**************************************************************************Start code for  #164459 ************************************************************************************8                 
            List<CSS_PSN__c> lstPSN =[Select Id,Name,PSN__c,Before_In_Service__c,Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c,Unit_Type__c,License_Plate_State__c,
                                      Primary__c,Failure_Date__c,Failure_Point__c,VIN__c,Calibration_Before__c,Revision_Before__c,Calibration_After__c,Revision_After__c,Mileage_Measure__c
                                      from CSS_PSN__c 
                                      where CSS_Claims__c = :cId];

            system.debug('*******lstPSN****'+lstPSN);
            system.debug('*******lstPSN****'+lstPSN.size());

            if(lstPSN.size()>0)
                for(CSS_PSN__c psnData : lstPSN) {

                    if(psnData.Primary__c == false){
                        string failuredate = '';
                        string wsd = '';
                        if(psnData.Failure_Date__c != null)
                            failuredate = css_utility.FormatDate(psnData.Failure_Date__c);

                        if(psnData.Warranty_Start_Date__c != null)
                            wsd = css_utility.FormatDate(psnData.Warranty_Start_Date__c);

                        lstmultiPartWrapper.add(new multiPSNWrapperClass(psnData.PSN__c,failuredate,psnData.Failure_Point__c,wsd,psnData.VIN__c,psnData.Calibration_Before__c,psnData.Revision_Before__c,psnData.Calibration_After__c,psnData.Revision_After__c,psnData.Mileage_Measure__c));

                        system.debug('***lstmultiPartWrapper Data***' +lstmultiPartWrapper);

                    }
                }

            if(claimsRec.Multi_PSN_Claim__c== true && lstPSN.size()<=1){
                //enableSubmitButton=true;
                validationOnAdditionalPSN=true;
            }
            else{
                //enableSubmitButton=false;
                validationOnAdditionalPSN=false;
            }
            //**************************************************************************END 164459 ************************************************************************************8                 
            system.debug('License_Plate_State_Error_message__c>>>>:'+claimsRec.License_Plate_State_Error_message__c);
            if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                psnRec = claimsRec.CSS_PSNs__r.get(0);
            }else
                psnRec = new CSS_PSN__c();  
            //claimSubRec = [select Id,Name from CSS_Claim_Submission__c where CSS_Claims__c = :cId limit 1];
            if(claimsRec.Status__c == 'Draft'){
                subButton = true;
            }

            if(claimsRec.Shop_Work_Order__c ==null || claimsRec.Shop_Work_Order__c =='' )
                SWORequired = true;

            if(claimsRec.CoverageResponse__c != null && claimsRec.CoverageResponse__c != '') {
                CSS_getBasicCoverageResponseJ2A basicCoverageDetails = (CSS_getBasicCoverageResponseJ2A)JSON.deserialize(claimsRec.CoverageResponse__c,CSS_getBasicCoverageResponseJ2A.class);
                for(CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails c : basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails){
                    if(c.CertificateNumber != null && c.CertificateNumber != '')
                        certiNumber = c.CertificateNumber;
                }
            }

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

            claimsPOList = [select Id, Service_Job__c, CSS_Claims__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c, Name, ODM_Status__c,Account_Code__c, Fail_Code__c, Part_Description__c,recordtype.name, Item__c, Type__c, 
                            Technician__c, HoursTravelled__c, Part_Name__c, Mileage__c,Unit_Price__c, selected_part__c,
                            Quantity__c, Covered__c, Parts_Type__c,Sell_Price__c, ExpenseTotal__c, FailurepartId__c, FailurepartId__r.Fail_Code__c,
                            FailurepartId__r.FailCode_Formula__c,Service_partnumber__c,Replacement_Reason__c,Amount__c, Item_BMS__c,Get_Fail_Code_Formula__c,
                            ReturnToFactory__c, Tracking_Number__c, RID__c
                            from CSS_Parts_Options__c
                            where CSS_Claims__c =: cId AND Account_Code__c != null AND (Fail_Code__c != null OR (Get_Fail_Code_Formula__c != null AND recordtype.name ='Parts')) AND selected_part__c = true ORDER BY CreatedDate DESC]; //Added order by as part of the task #191794
            system.debug('claimsPOList.size() ' + claimsPOList.size());

            system.debug('claimsPOList() ' + claimsPOList);
            
            //GSSC-138 start
            css_utility utility = new css_utility();
            
            mapPartsList = utility.displayParts(claimsPOList);
            system.debug('mapPartsList--'+mapPartsList);
            //GSSC-138 end

            claimsSRTList = [SELECT Id, Name, SRT_Notes__c, Claimed_Hours__c,Flex_Flag__c,ODM_Status__c,Assignment__c,Account_Code__c,Access_code__c, FailCode__c, SRT_ID__c, SRT_Title__c, Access_Code_Saved__c, SRT_Amount__c, IsPopUpSRT__c, 
                             SRT_Time__c, SRT_Time_Formula__c, SRT_Quantity__c, SRT_Warrantable__c,AccountCode_Formula__c, Fail_Code_Description__c, Extended_Hours__c,Diagnosis_Time__c,Diag_Access_Time__c,Repair_Time__c,Repair_Access_Calculated__c,
                             Calculated_Claimed_Hours__c, Type__c,srt_category__c,Additional_SRT_Calculated__c,solution_number__c,isPerformed__c,SRT_AccessiblityCheck__c, SRT_Type__c, Overlap_Hours__c, Override__c, CSS_Claims__r.Repair_Location__c
                             FROM CSS_SRT__c WHERE CSS_Claims__c =: cId AND (Account_Code__c != null OR AccountCode_Formula__c != null) 
                             AND (FailCode__c != null OR Fail_Code_Description__c != null) AND (SRT_AccessiblityCheck__c = true OR isPerformed__c = true)];
            system.debug('claimsSRTList.size() ' + claimsSRTList.size());
            system.debug('claimsSRTList() ' + claimsSRTList);

            claimSubWithNotes = new Map<String, List<ClaimNotes>>();
            for(Note notes: [SELECT Id,Body,title,parentId, CreatedBy.firstname, CreatedDate,
                             CreatedBy.lastname, LastModifiedDate,CreatedById 
                             FROM Note WHERE parentId IN :claimSubMap.keySet() 
                             order by CreatedDate DESC  LIMIT 6]){
                system.debug('>>>notessss<<<' + notes);                  
                String indivisualClaimId = claimSubMap.get(notes.parentId).Individual_Claim_Id__c;
                List<String> lstStr = new List<String>();
                if(notes.Body != null){
                    if(notes.Body.contains(';;'))
                    lstStr = notes.Body.split(';;');
                    system.debug('lstStr'+lstStr);
                    if(!claimSubWithNotes.containsKey(indivisualClaimId)){
                        ClaimNotes temp  = new ClaimNotes();
                        //temp.Notes= notes;
                        temp.noteBody = lstStr[3];
                        temp.noteTitle =  notes.Title;
                        //temp.lastSaveDate = css_utility.getFormattedDate(notes.LastModifiedDate);
                        temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(lstStr[1]));
                        claimSubWithNotes.put(indivisualClaimId,new List<ClaimNotes>{temp});      
                    } 
                    else{
                        ClaimNotes temp  = new ClaimNotes();
                        //temp.Notes= notes;
                        temp.noteBody = lstStr[3];
                        temp.noteTitle =  notes.Title;
                        //temp.lastSaveDate = css_utility.getFormattedDate(notes.LastModifiedDate);
                        temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(lstStr[1]));
                        claimSubWithNotes.get(indivisualClaimId).add(temp);
                    }
                }
            }
            system.debug('claimSubWithNotes ' + claimSubWithNotes);

            //To implement Parts Warranty & FA Account codes Logic
            String PartsWarrantyValues = Label.CG_Parts_Warranty;


            if(PartsWarrantyValues != null && PartsWarrantyValues != '') {
                partsWarranty = PartsWarrantyValues.split(',');
            }
            system.debug('partsWarranty ' + partsWarranty);

            for(string s : partsWarranty) 
                system.debug('partsWarranty START' + s + 'END');

            String FAACValues = Label.CG_FA_AccountCodes;
            if(FAACValues != null && FAACValues != '') {
                fieldActionAcountcodeList = FAACValues.split(',');
            }
            system.debug('fieldActionAcountcodeList ' + fieldActionAcountcodeList);

            claimsattachment = [Select Id, LastModifiedDate from Attachment where ParentId=:cId order By LastModifiedDate DESC limit 1];
            system.debug('claimsattachment'+claimsattachment);

            user[] factoryUser = [select Id, FederationIdentifier from User where Id=: userinfo.getUserId() and userrole.Name = 'Factory'];
            system.debug('factoryUser '+factoryUser);
            if(factoryUser != null && factoryUser.size() ==1)
                factoryUserWWid = factoryUser[0].FederationIdentifier;
            else
                factoryUserWWid = 'SPUSER';
            system.debug('factoryUserWWid '+factoryUserWWid);
        } catch(Exception ex) {
            system.debug('in the exception of fetchClaimRelatedRecords Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }
    }

    public void savePartsTotal(){
        system.debug('This is save Parts total.');
        try
        {
            totalUSD = 0.00;
            List<CSS_Parts_Options__c> partslist = new List<CSS_Parts_Options__c>();
            partslist =[SELECT ExpenseTotal__c,Amount__c,Quantity__c,Covered__c,Unit_Price__c FROM CSS_Parts_Options__c WHERE  CSS_Claims__c =:cId AND Parts_Type__c = 'Custom'];
            for(CSS_Parts_Options__c csprt:partslist){                
                if(partslist!=null)
                {
                    partsUSD=partsUSD+csprt.Quantity__c*(csprt.Covered__c/100)*(csprt.Unit_Price__c!=null?Decimal.valueof(csprt.Unit_Price__c):0); 
                    system.debug('partsusd'+partsUSD);
                }
                //partsUSD=partsUSD+csprt.Quantity__c;
                totalUSD=partsUSD;
                system.debug('totall'+csprt.Covered__c);
                system.debug('partsUSD'+partsUSD);
                system.debug('partstotalUSd'+partstotalUSd);
            } 

        } 
        catch(Exception ex)
        {
            system.debug('in the exception of savePartsTotal Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }

    }

    public void assignWarrantyAuthFlag(){
        if(claimsRec!=null){
            warrantyAuthFlag = claimsRec.Account__r.Warranty_Training_Status__c;
            system.debug('warrantyAuthFlag>>>>:'+warrantyAuthFlag);
        }
    }

    //ClaimsVS page design is based on the account code and failcode combination.
    public void fetchAccountFailCodeCombo(){
        try {
            if(claimsRec != null) {
                if(claimsRec.ODM_Status__c == 'YTBV' || claimsRec.ODM_Status__c == 'ERROR')
                    dispSubmitButton = false;
            }  
            system.debug('dispSubmitButton C>>>>:'+dispSubmitButton);

            //Map of Account code and Solution component
            if(claimsSCList.size()>0){
                for(CSS_Solution_Component__c sctemp : claimsSCList) {
                    if(sctemp.ODM_Status__c == 'YTBV' || sctemp.ODM_Status__c == 'ERROR'){
                        dispSubmitButton = false;
                    }

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
            system.debug('dispSubmitButton SC>>>>:'+dispSubmitButton);

            //Map of Account code+Failcode and Part
            if(claimsPOList.size()>0){
                for(CSS_Parts_Options__c potemp : claimsPOList) {
                    string Failcode = null; 
                    if(potemp.Fail_Code__c != null){
                        system.debug('potemp.Fail_Code__c**** ' + potemp.Fail_Code__c);
                        Failcode= potemp.Fail_Code__c;
                    }
                    else{
                        Failcode= potemp.Get_Fail_Code_Formula__c;
                    }
                    string splittedFailcode=null;
                    if(potemp.ODM_Status__c == 'YTBV' || potemp.ODM_Status__c == 'ERROR'){
                        if(claimsRec.Information_Only_Claim__c && claimsRec.IsDealerCreatedClaim__c) //story 173516
                            dispSubmitButton = true;
                        else
                            dispSubmitButton = false;
                    }
                    if(Failcode!=null && Failcode.contains('-')){
                        string[] splittedFailcodelst = Failcode.split('\\-');
                        splittedFailcode = splittedFailcodelst[1];}
                    else{
                        if(potemp.Fail_Code__c != null){
                            splittedFailcode= potemp.Fail_Code__c;
                        }
                        else{
                            splittedFailcode= potemp.Get_Fail_Code_Formula__c;
                        }
                    }
                    //splittedFailcode = splittedFailcode.LEFT(4);

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
            system.debug('dispSubmitButton PO>>>>:'+dispSubmitButton);

            //Map of Account code+Failcode and SRT
            if(claimsSRTList.size()>0){
                for(CSS_SRT__c SRTtemp : claimsSRTList) {
                    string accountCode;
                    string failCode;
                    if(SRTtemp.ODM_Status__c == 'YTBV' || SRTtemp.ODM_Status__c == 'ERROR'){
                        if(claimsRec.Information_Only_Claim__c && claimsRec.IsDealerCreatedClaim__c) //story 173516
                            dispSubmitButton = true;
                        else
                            dispSubmitButton = false;
                    }
                    system.debug('dispSubmitButton SRT>>>>:'+ dispSubmitButton + SRTtemp);
                    system.debug('SRTtemp.Account_Code__c***** ' + SRTtemp.Account_Code__c);
                    if(SRTtemp.Account_Code__c == null)
                        accountCode = SRTtemp.AccountCode_Formula__c;
                    else
                        accountCode = SRTtemp.Account_Code__c;

                    system.debug('FailCode__c--'+SRTtemp.FailCode__c);
                    if(SRTtemp.FailCode__c == null){
                        failCode = SRTtemp.Fail_Code_Description__c;
                        if(failCode!=null && failCode.contains('-')){
                            string[] splittedFailcodelst = failCode.split('\\-');                  
                            if(splittedFailcodelst[1].length()==6)
                                //failCode = splittedFailcodelst[1].substring(0,splittedFailcodelst[1].length()-2);
                                failCode = splittedFailcodelst[1];
                            else
                                failCode = splittedFailcodelst[1];
                        }
                        else{
                            failCode= SRTtemp.Fail_Code_Description__c;
                            if(failCode!=null){
                                if(failCode.length()==6)
                                    //failCode = failCode.substring(0,failCode.length()-2);
                                    failCode = failCode;
                                else
                                    failCode = failCode; 
                            }}
                    }
                    else{
                        failCode = SRTtemp.FailCode__c;
                        if(failCode!=null){

                            if(failCode.length()==6)
                                //failCode = failCode.substring(0,failCode.length()-2);
                                failCode = failCode;
                            else if(failCode.length()==4) // added if condition for length 4, defect 189956
                                failCode = failCode; 
                            else if(failCode!=null && failCode.contains('-')){ //added if condition to split by '-', defect 189956
                            string[] splittedFailcodelst1 = failCode.split('\\-');                  
                                    failCode = splittedFailcodelst1[1];
                                 }
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
            system.debug('dispSubmitButton SRT>>>>:'+dispSubmitButton);

        } catch(Exception ex) {
            system.debug('in the exception of fetchAccountFailCodeCombo Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }    
    }

    public boolean showSubmitbtn(){
        boolean showSubmitbtnvalues = false;
        boolean infoOnlyClaim = false;
        boolean isCategoryEmpty = false;
        boolean isComplaintEmpty = false;
        //Validations for Category n Complaint for #173531//
        if((claimsRec.Claims_Category_Desc__c == null ||  claimsRec.Claims_Category_Desc__c == '') &&
           (claimsRec.Claims_Category2_Desc__c == null || claimsRec.Claims_Category2_Desc__c == '') &&
           (claimsRec.Claims_Category3_Desc__c == null || claimsRec.Claims_Category3_Desc__c == '' )&&
           (claimsRec.Claims_Category4_Desc__c == null || claimsRec.Claims_Category4_Desc__c == '') &&
           (claimsRec.Claims_Category5_Desc__c == null || claimsRec.Claims_Category5_Desc__c == '')){
            isCategoryEmpty = true;
        }
        else{
            isCategoryEmpty = false;

        }
        if((claimsRec.Complaint_Type_Desc__c == null  ||  claimsRec.Complaint_Type_Desc__c.trim() == '') &&
           (claimsRec.Complaint_Type2_Desc__c == null || claimsRec.Complaint_Type2_Desc__c.trim() == '') &&
           (claimsRec.Complaint_Type3_Desc__c == null || claimsRec.Complaint_Type3_Desc__c.trim() == '') &&
           (claimsRec.Complaint_Type4_Desc__c == null || claimsRec.Complaint_Type4_Desc__c.trim() == '') && 
           (claimsRec.Complaint_Type5_Desc__c == null || claimsRec.Complaint_Type5_Desc__c.trim() == '')){
            isComplaintEmpty = true;
        }
        else{
            isComplaintEmpty = false;

        }
        //End of Validations


        IF(DealerTypeFlag)      //userType == 'DLR'
        {
            system.debug('Dealor Logic Enter>>>>');
            IF(claimsRec != null)
            {
                system.debug('Anirudh claimsRec.Information_Only_Claim__c'+claimsRec.Information_Only_Claim__c);
                if(claimsRec.Information_Only_Claim__c == TRUE){
                    infoOnlyClaim = true;
                    system.debug('Anirudh claimsRec.Information_Only_Claim__c'+claimsRec.Information_Only_Claim__c);
                }
            }
        }  
        else //if(userType == 'DISTR')
        {
            system.debug('Distributor logic enters>>>');
            //list<CSS_Solution_Component__c> solcomp = [Select id,ODM_Status__c,ODM_Status_Message__c,CSS_Account_Formula__c from CSS_Solution_Component__c where CSS_Claims__c IN :claimIdList and pay_code__c = 'A'];

            if(claimsSCList.size()>0)
            {
                for(CSS_Solution_Component__c sol:claimsSCList)
                {
                    if(sol.pay_code__c=='A'){
                        infoOnlyClaim = true;
                        break;
                    }

                }
            }
        }

        system.debug('pendingAuthFlag.....' + pendingAuthFlag);
        system.debug('***warrantyAuthFlag**' + warrantyAuthFlag);
        system.debug('***SWORequired**' + SWORequired);
        system.debug('***claimsRec.Mutual_Exclusive_Message__c****' + claimsRec.Mutual_Exclusive_Message__c);
        system.debug('***claimsRec.SRT_Olap_Reason_Msg__c***' + claimsRec.SRT_Olap_Reason_Msg__c);
        system.debug('***claimsRec.Actual_Technician_Time__c***' + claimsRec.Actual_Technician_Time__c);
        system.debug('***FailcodeEQError***' + FailcodeEQError);
        system.debug('***dispSubmitButton***' + dispSubmitButton);
        system.debug('***infoOnlyClaim***' + infoOnlyClaim);
        if(claimsRec.Information_Only_Claim__c && claimsRec.IsDealerCreatedClaim__c){
            system.debug('A');
            if(SWORequired == false 
               && (claimsRec.SRT_Olap_Reason_Msg__c ==null || claimsRec.SRT_Olap_Reason_Msg__c.trim() =='')
               && (infoOnlyClaim == true || dispSubmitButton == true))
                showSubmitbtnvalues = true;
            else
                showSubmitbtnvalues = false;
        }
        else{
            system.debug('B');
            //(warrantyAuthFlag != null && warrantyAuthFlag != '' && (warrantyAuthFlag.LEFT(1) =='G' || warrantyAuthFlag.LEFT(1) =='Y')) && 
            system.debug('***claimsRec.SRT_902_Error_Message__c***' + claimsRec.SRT_902_Error_Message__c);
            system.debug('***claimsRec.isPartsCovLimitExceed***' + isPartsCovLimitExceed);
            system.debug('***claimsRec.isSRTCovLimitExceed***' + isSRTCovLimitExceed);
            system.debug('***claimsRec.isSRTwithFailcodeCovLimitExceed***' + isSRTwithFailcodeCovLimitExceed);
            system.debug('***claimsRec.errorttmlflag***' + errorttmlflag);
            system.debug('***claimsRec.errorserviceflag***' + errorserviceflag);
            if(SWORequired == false 
               && (claimsRec.Mutual_Exclusive_Message__c ==null || claimsRec.Mutual_Exclusive_Message__c.trim() =='')
               && (claimsRec.SRT_Olap_Reason_Msg__c ==null || claimsRec.SRT_Olap_Reason_Msg__c.trim() =='')
               && (claimsRec.DupAccessCodePercentReqMsg__c ==null || claimsRec.DupAccessCodePercentReqMsg__c.trim() =='')
               && (claimsRec.Overlap_Service_Failure_Msg__c ==null || claimsRec.Overlap_Service_Failure_Msg__c.trim() =='')
               && (claimsRec.SRT_902_Error_Message__c ==null || claimsRec.SRT_902_Error_Message__c.trim() =='')
               && claimsRec.Actual_Technician_Time__c != null  && pendingAuthFlag 
               && (infoOnlyClaim == true || dispSubmitButton == true)
               && isPartsCovLimitExceed != true && isSRTCovLimitExceed !=true && isSRTwithFailcodeCovLimitExceed !=true
               && errorttmlflag != true 
               && errorserviceflag !=true)
                showSubmitbtnvalues = true;
            else
                showSubmitbtnvalues = false;
        }
        //}
        system.debug('showSubmitbtnvalues ....' + showSubmitbtnvalues);



        //code for submit button enabling for MultiPSN
        if(claimsRec.Multi_PSN_Claim__c && showSubmitbtnvalues){
            List<CSS_PSN__c> lstPSNrec = new List<CSS_PSN__c>([Select Id,Name,PSN__c,primary__c,CSS_Claims__c from CSS_PSN__c where css_claims__c = :cId and primary__c != true]);
            if(lstPSNrec.size()>0){
                //isMultiPSN = true;
                showSubmitbtnvalues = true;
            }else{
                showSubmitbtnvalues = false;
            }
            if(psncheck && showSubmitbtnvalues){
                if(lstPSNrec.size()>0){
                    //isMultiPSN = true;
                    showSubmitbtnvalues = true;
                }else{
                    showSubmitbtnvalues = false;
                }
            }
        }
        if(showSubmitbtnvalues == true && (isCategoryEmpty == true || isComplaintEmpty == true)){
            showSubmitbtnvalues = false;
        }

        if(showSubmitbtnvalues && claimSubMap != null && claimSubMap.size() > 0)
            showSubmitbtnvalues = false;

        //Disable submit button if failmode is not present for failures of automated claim - story 181523
        if(showSubmitbtnvalues == true && claimsRec != null && (claimsRec.CSS_Job__c != null || claimsRec.Dealer_Service_Job__c != null)){
            if(solComps != null && solComps.size()>0){
                for(CSS_Solution_Component__c solCompObj : solComps){
                    system.debug('Value of Fail Mode***'+ solCompObj.Failure_Mode__c);
                    if(solCompObj.OldSolCompID__c != null && (solCompObj.Type__c != ('Campaign') || solCompObj.Type__c != ('TRP') || solCompObj.Type__c != ('ATC')) && (solCompObj.Failure_Mode__c == null || solCompObj.Failure_Mode__c == '')){
                        system.debug('Blank Fail Mode***'+ solCompObj.Failure_Mode__c);
                        showSubmitbtnvalues = false;
                        break;
                    }
                }
            }

        }
        if( showSubmitbtnvalues == true && claimsRec != null && claimsRec.FieldActionWebServiceResult__c == 'Error' && claimsRec.PartsRelatedODMMessage__c=='failed'){
            showSubmitbtnvalues = false;
            system.debug('showSubmitbtnvalues 321.....' + showSubmitbtnvalues);
        }
        
        //Controlling all conditions in apex class level. & Defect #189554
        //Cata
        if(showSubmitbtnvalues && claimsRec != null && urRole != null) {
            if(claimsRec.Catastrophic__c && claimsRec.IsDealerCreatedClaim__c && urRole.name != 'Factory')
        showSubmitbtnvalues = false;
        }
        //Cata
        //Controlling all conditions in apex class level. & Defect #189554
        
        if(claimsPOList !=null && claimsPOList.size()>0){
            for(CSS_Parts_Options__c p:claimsPOList){
                if(p.selected_part__c == true && (p.Tracking_Number__c=='' || p.Tracking_Number__c == null || p.Tracking_Number__c == 'Select One') && p.ReturnToFactory__c == 'Y'){
                    showSubmitbtnvalues=false;
                    break;
                }
            }
        }
        system.debug('SRT_FlexTime_Error__c.....' + claimsRec.SRT_FlexTime_Error__c);
        if(claimsRec.SRT_FlexTime_Error__c == true){//GSSC - 24 changes
            showSubmitbtnvalues=false;
        }
        
        if(claimsRec.MileageProdHrsError__c == 'Error'){//GSSC - 106 changes
            showSubmitbtnvalues=false;
        }
        if(claimsRec.isCalibrationFieldsBlank__c == true){//GSSC - 30 changes
            showSubmitbtnvalues=false;
        }
        //GSSC-330
        system.debug('isSRTFailAccCodeError FINAL.....' + isSRTFailAccCodeError);
        system.debug('showSubmitbtnvalues FINAL-1.....' + showSubmitbtnvalues);
        if(showSubmitbtnvalues && isSRTFailAccCodeError)
            showSubmitbtnvalues = false;
        system.debug('showSubmitbtnvalues FINAL.....' + showSubmitbtnvalues);
        return showSubmitbtnvalues;
    }

    //showReOpenbtn
    public boolean showReOpenbtn(){
        boolean showReOpenbtnvalues = false;
        if(claimsRec != null){
            if(claimsRec.Status__c != 'Draft') {
                if(claimSubMap != null && claimSubMap.size() > 0) {
                    integer i = 0;
                    for(CSS_Claim_Submission__c cs : claimSubMap.values()) {
                        if(cs.Status__c == 'Submitted')
                            i++;
                    }
                    if(i == claimSubMap.size())
                        showReOpenbtnvalues = true;   
                }
            }
        }
        return showReOpenbtnvalues;
    }

    public void checkQuantity(){
        system.debug('call off Quantity Check.....');
        if(solPartsQuantityList.size() > 0){
            for(CSS_Solution_Component__c solcomp : solPartsQuantityList){
                if(solcomp != null){
                    for(CSS_Parts_Options__c parts : solcomp.CSS_Parts_Options__r){
                        if(parts.CSS_Claims__c == solcomp.CSS_Claims__c){
                            system.debug('Enterted into claims validation..... ');
                            if(solcomp.Id == parts.FailurepartId__c && parts.BMS_Quantity__c != null){
                                system.debug('Both Ids equal');
                                system.debug('Quantity'+ parts.Quantity__c);
                                system.debug('BMS Quantity' + parts.BMS_Quantity__c);
                                if(parts.Quantity__c != parts.BMS_Quantity__c)
                                    editQuantity = true;
                                system.debug('Boolean of Quantity' +editQuantity);
                            }
                        }
                    }
                }                
            }
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
                    lstfailureWrapper = new List<failureWrapperClass>();
                    //lstmultiPartWrapper = new List<multiPSNWrapperClass>();
                    lstpartsWrapperClass = new List<partsWrapperClass>();
                    lstotherClaimWrapperClass = new list<otherClaimWrapperClass>();
                    lstTTMLWrapperClass = new list<TTMLWrapperClass>();
                    lstSRTsWrapperClass = new list<SRTsWrapperClass>();
                    lstfieldActionSRTsWrapper = new list<fieldActionSRTsWrapperClass>();
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
                            failureWrapperClass failWrapperTemp = new failureWrapperClass('','','','','','','','','','','','','','','','','','','','','','','','','','','','','',null,'',null);
                            if(csssc.AccountCode__c != null && csssc.AccountCode__c.length() > 2)
                                accountcodeTD = csssc.AccountCode__c.RIGHT(2);

                            string cType = '';
                            if(csssc.Claim_Type__c != null && csssc.Claim_Type__c != '')
                                cType = csssc.Claim_Type__c;
                            else if(csssc.Selected_Claim_Type__c != null && csssc.Selected_Claim_Type__c != '')
                                cType = csssc.Selected_Claim_Type__c;
                            else 
                                cType = '';

                            if(csssc.Type__c!=null){
                                if( (csssc.Type__c=='Campaign' || csssc.Type__c=='TRP' || csssc.Type__c=='ATC')){
                                    //lstfailureWrapper.add(new failureWrapperClass(csssc.Fail_Code__c,csssc.Type__c+'-'+csssc.Campaign_Description__c,csssc.Id,csssc.System_Code__c,csssc.Component_Code__c,csssc.Failure_Mode__c,accountTwoDigit,csssc.Pay_Code__c,csssc.CertificateNumber__c,csssc.Component_Id__c,'',csssc.WarrantyId__c,csssc.Approval_Code__c,csssc.CSS_CoverageType__c,csssc.CoveredLaborHrs__c,csssc.CoveredMealsLodgingAmt__c,csssc.CoveredOCAmount__c,csssc.CoveredPartsQty__c,csssc.CoveredTowingMiles__c,csssc.CoveredTravelLabor__c,csssc.CoveredTravelMiles__c,csssc.DeductibleAmount__c,csssc.Authorization_Number__c,csssc.CampaignLaborPercentage__c,csssc.CampaignOCPercentage__c,csssc.CampaignPartsPercentage__c,csssc.CampaignTowingPercentage__c,csssc.CampaignTravelPercentage__c,csssc.ODM_Status__c,'','',cType));
                                    failWrapperTemp.failcode = csssc.Fail_Code__c;
                                    failWrapperTemp.failureName = csssc.Type__c+'-'+csssc.Campaign_Description__c;
                                    failWrapperTemp.validationmessage = csssc.Id;
                                    failWrapperTemp.SystemCode=csssc.System_Code__c;
                                    failWrapperTemp.ComponentCode=csssc.Component_Code__c;
                                    failWrapperTemp.FailMode=csssc.Failure_Mode__c;
                                    failWrapperTemp.AccountCode=accountTwoDigit;
                                    failWrapperTemp.PayCode=csssc.Pay_Code__c;
                                    failWrapperTemp.CertificateNumber=csssc.CertificateNumber__c;
                                    failWrapperTemp.CampaignNumber=csssc.Component_Id__c;
                                    failWrapperTemp.FaultCode='';
                                    failWrapperTemp.WarrantyId=csssc.WarrantyId__c;
                                    failWrapperTemp.ApproverCode=csssc.Approval_Code__c;
                                    failWrapperTemp.CoverageType=csssc.CSS_CoverageType__c;
                                    failWrapperTemp.CoveredLaborHours=csssc.CoveredLaborHrs__c;
                                    failWrapperTemp.CoveredMealsLodgingAmt=csssc.CoveredMealsLodgingAmt__c;
                                    failWrapperTemp.CoveredOCAmount=csssc.CoveredOCAmount__c;
                                    failWrapperTemp.CoveredPartsQuantity=csssc.CoveredPartsQty__c;
                                    failWrapperTemp.CoveredTowingMiles=csssc.CoveredTowingMiles__c;
                                    failWrapperTemp.CoveredTravelLabor=csssc.CoveredTravelLabor__c;
                                    failWrapperTemp.CoveredTravelMiles=csssc.CoveredTravelMiles__c;
                                    failWrapperTemp.DeductibleAmount=csssc.DeductibleAmount__c;
                                    failWrapperTemp.AuthorizationNum=csssc.Authorization_Number__c;
                                    failWrapperTemp.CampaignLabourPrcnt=csssc.CampaignLaborPercentage__c;
                                    failWrapperTemp.CampaignOCPrcnt=csssc.CampaignOCPercentage__c;
                                    failWrapperTemp.CampaignPartsPrcnt=csssc.CampaignPartsPercentage__c;
                                    failWrapperTemp.CampaignTowingPrcnt=csssc.CampaignTowingPercentage__c;
                                    failWrapperTemp.CampaignTravelPrcnt=csssc.CampaignTravelPercentage__c;
                                    failWrapperTemp.odmstatus = csssc.ODM_Status__c;
                                    failWrapperTemp.ProductGroup = '';
                                    failWrapperTemp.GroupCode = '';
                                    failWrapperTemp.claimType = cType;
                                    failWrapperTemp.failureType = csssc.Type__c;
                                    failWrapperTemp.PrimaryFailureFlag = csssc.CSS_Primary_Failure__c;//Anirudh
                                    failWrapperTemp.sequenceNumber = Integer.valueof(csssc.CSS_Failure_Sequence_Number__c);
                                    lstfailureWrapper.add(failWrapperTemp);
                                }
                            }else if(csssc.Type__c==null){
                                //lstfailureWrapper.add(new failureWrapperClass(csssc.Fail_Code__c,csssc.name,csssc.Id,csssc.System_Code__c,csssc.Component_Code__c,csssc.Failure_Mode__c,accountTwoDigit,csssc.Pay_Code__c,csssc.CertificateNumber__c,'',csssc.Fault_Code__c,csssc.WarrantyId__c,csssc.Approval_Code__c,csssc.CSS_CoverageType__c,csssc.CoveredLaborHrs__c,csssc.CoveredMealsLodgingAmt__c,csssc.CoveredOCAmount__c,csssc.CoveredPartsQty__c,csssc.CoveredTowingMiles__c,csssc.CoveredTravelLabor__c,csssc.CoveredTravelMiles__c,csssc.DeductibleAmount__c,csssc.Authorization_Number__c,csssc.CampaignLaborPercentage__c,csssc.CampaignOCPercentage__c,csssc.CampaignPartsPercentage__c,csssc.CampaignTowingPercentage__c,csssc.CampaignTravelPercentage__c,csssc.ODM_Status__c,Integer.valueof(csssc.CSS_Failure_Sequence_Number__c),cType,csssc.CSS_Primary_Failure__c));//Anirudh   
                                failWrapperTemp.failcode = csssc.Fail_Code__c;
                                failWrapperTemp.failureName = csssc.name; //csssc.Type__c+'-'+csssc.Campaign_Description__c;
                                failWrapperTemp.validationmessage = csssc.Id;
                                failWrapperTemp.SystemCode=csssc.System_Code__c;
                                failWrapperTemp.ComponentCode=csssc.Component_Code__c;
                                failWrapperTemp.FailMode=csssc.Failure_Mode__c;
                                failWrapperTemp.AccountCode=accountTwoDigit;
                                failWrapperTemp.PayCode=csssc.Pay_Code__c;
                                failWrapperTemp.CertificateNumber=csssc.CertificateNumber__c;
                                failWrapperTemp.CampaignNumber='';//
                                failWrapperTemp.FaultCode=csssc.Fault_Code__c;//
                                failWrapperTemp.WarrantyId=csssc.WarrantyId__c;
                                failWrapperTemp.ApproverCode=csssc.Approval_Code__c;
                                failWrapperTemp.CoverageType=csssc.CSS_CoverageType__c;
                                failWrapperTemp.CoveredLaborHours=csssc.CoveredLaborHrs__c;
                                failWrapperTemp.CoveredMealsLodgingAmt=csssc.CoveredMealsLodgingAmt__c;
                                failWrapperTemp.CoveredOCAmount=csssc.CoveredOCAmount__c;
                                failWrapperTemp.CoveredPartsQuantity=csssc.CoveredPartsQty__c;
                                failWrapperTemp.CoveredTowingMiles=csssc.CoveredTowingMiles__c;
                                failWrapperTemp.CoveredTravelLabor=csssc.CoveredTravelLabor__c;
                                failWrapperTemp.CoveredTravelMiles=csssc.CoveredTravelMiles__c;
                                failWrapperTemp.DeductibleAmount=csssc.DeductibleAmount__c;
                                failWrapperTemp.AuthorizationNum=csssc.Authorization_Number__c;
                                failWrapperTemp.CampaignLabourPrcnt=csssc.CampaignLaborPercentage__c;
                                failWrapperTemp.CampaignOCPrcnt=csssc.CampaignOCPercentage__c;
                                failWrapperTemp.CampaignPartsPrcnt=csssc.CampaignPartsPercentage__c;
                                failWrapperTemp.CampaignTowingPrcnt=csssc.CampaignTowingPercentage__c;
                                failWrapperTemp.CampaignTravelPrcnt=csssc.CampaignTravelPercentage__c;
                                failWrapperTemp.odmstatus = csssc.ODM_Status__c;
                                failWrapperTemp.ProductGroup = '';
                                failWrapperTemp.GroupCode = '';
                                failWrapperTemp.claimType = cType;
                                failWrapperTemp.failureType = csssc.Type__c;
                                failWrapperTemp.PrimaryFailureFlag = csssc.CSS_Primary_Failure__c;//Anirudh
                                failWrapperTemp.sequenceNumber = Integer.valueof(csssc.CSS_Failure_Sequence_Number__c);
                                failWrapperTemp.CustomerPossession = csssc.Customer_Take_Possession__c;
                                if(csssc.Part_Warranty_Start_Date__c != null)
                                    failWrapperTemp.PartsWarrantyStartDate = string.valueOf(csssc.Part_Warranty_Start_Date__c);
                                else
                                    failWrapperTemp.PartsWarrantyStartDate = '';

                                if(csssc.Failure_Date__c != null)
                                    failWrapperTemp.FailureDate = string.valueOf(csssc.Failure_Date__c);
                                else
                                    failWrapperTemp.FailureDate = '';

                                if(csssc.Failure_Point__c != null)
                                    failWrapperTemp.FailurePoint = string.valueOf(csssc.Failure_Point__c);
                                else
                                    failWrapperTemp.FailurePoint = '';
                                failWrapperTemp.FailureMeasure = csssc.Failure_Measure__c; 
                                lstfailureWrapper.add(failWrapperTemp);
                            }    
                            system.debug('****accountcode**'+accountcode+'****fcode***'+csssc.Fail_Code__c);
                            //List<CSS_Parts_Options__c> POlist = POAccountCodeMap.get(accountcode+csssc.Fail_Code__c.LEFT(4));
                            List<CSS_Parts_Options__c> POlist = POAccountCodeMap.get(accountcode+csssc.Fail_Code__c);
                            system.debug('****POlist**'+POlist);
                            if(POlist != null && POlist.size() > 0) {
                                for(CSS_Parts_Options__c p : POlist) {
                                    //Below line added for defect#154640
                                    system.debug('p.Covered__c --- ' + p.Covered__c);
                                    system.debug('p.Unit_Price__c --- ' + p.Unit_Price__c);
                                    system.debug('p.Covered__c --- ' + p.Quantity__c);
                                    
                                    //GSSC-138 START
                                    decimal unitPrice;
                                    decimal amount;
                                    Map<decimal, decimal> mapTemp = new Map<decimal, decimal>();
                                    
                                    if(mapPartsList != null){
                                        mapTemp = mapPartsList.get(p.Id);
                                        
                                        if(mapTemp != null){
                                            for(decimal up : mapTemp.keyset()){
                                                unitPrice = up;
                                                amount = mapTemp.get(up);
                                            }
                                        }
                                    }
                                    unitPrice = unitPrice != null ? unitPrice.setscale(2) : 0.00;
                                    
                                    system.debug('unitPrice--'+unitPrice);
                                    system.debug('amount--'+amount);
                                    
                                    if(p.Covered__c!=null && unitPrice != null && p.Quantity__c != null)
                                    {
                                        amount = (p.Covered__c/100)*unitPrice*p.Quantity__c;
                                        if(amount == 0)
                                            amount = 0.00;
                                    }
                                    amount = amount.setscale(2);
                                    //GSSC-138 end
                                    
                                    /*if(p.Covered__c!=null && p.Unit_Price__c != null && p.Quantity__c != null)
                                    {
                                        p.ExpenseTotal__c=(p.Covered__c/100)*(p.Unit_Price__c!=null?Decimal.valueof(p.Unit_Price__c):0)*p.Quantity__c;
                                        if(p.ExpenseTotal__c == 0)
                                            p.ExpenseTotal__c = 0.00;
                                    }*/
                                    p.ExpenseTotal__c = amount; //GSSC-138
                                    //Added code for displaying the Parts based on claim type as per The gap story #147389, -By RAJESH 14th JUNE 2018   
                                    if(claimsRec.CSS_Job__c!=null || claimsRec.Dealer_Service_Job__c !=null){
                                        system.debug('****p.recordtype.name***'+p.recordtype.name+'*****dup***'+duplicatePartIdSet.contains(p.Id));
                                        if(p.recordtype.name=='BMS Parts' && !duplicatePartIdSet.contains(p.Id)) {
                                            system.debug('****inside bms parts***');
                                            if(P.Fail_Code__c != null && P.Fail_Code__c != ''){
                                                //lstpartsWrapperClass.add(new partsWrapperClass(P.Fail_Code__c,P.Service_partnumber__c,P.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(P.Covered__c),String.valueof(P.Unit_Price__c),String.valueof(P.ExpenseTotal__c),'',String.valueof(P.Service_partnumber__c),'',P.Replacement_Reason__c,P.ODM_Status__c,'','','','','',P.Parts_Type__c,'', p.RID__c, p.Tracking_Number__c, p.ReturnToFactory__c));
                                                //GSSC-138
                                                lstpartsWrapperClass.add(new partsWrapperClass(P.Fail_Code__c,P.Service_partnumber__c,P.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(P.Covered__c),String.valueof(unitPrice),String.valueof(amount),'',String.valueof(P.Service_partnumber__c),'',P.Replacement_Reason__c,P.ODM_Status__c,'','','','','',P.Parts_Type__c,'', p.RID__c, p.Tracking_Number__c, p.ReturnToFactory__c));
                                            }
                                            else{
                                                //lstpartsWrapperClass.add(new partsWrapperClass(P.Get_Fail_Code_Formula__c,P.Service_partnumber__c,P.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(P.Covered__c),String.valueof(P.Unit_Price__c),String.valueof(P.ExpenseTotal__c),'',String.valueof(P.Service_partnumber__c),'',P.Replacement_Reason__c,P.ODM_Status__c,'','','','','',P.Parts_Type__c,'', p.RID__c, p.Tracking_Number__c, p.ReturnToFactory__c));
                                                //GSSC-138
                                                lstpartsWrapperClass.add(new partsWrapperClass(P.Get_Fail_Code_Formula__c,P.Service_partnumber__c,P.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(P.Covered__c),String.valueof(unitPrice),String.valueof(amount),'',String.valueof(P.Service_partnumber__c),'',P.Replacement_Reason__c,P.ODM_Status__c,'','','','','',P.Parts_Type__c,'', p.RID__c, p.Tracking_Number__c, p.ReturnToFactory__c));
                                            }
                                            duplicatePartIdSet.add(p.Id);
                                        }
                                        //Venkat: added for the story 158780
                                        //if(userType !=null && userType != '') {
                                            if(DealerTypeFlag){     //
                                                if(p.recordtype.name=='Parts' && !duplicatePartIdSet.contains(p.Id)) {
                                                    //p.totalUSD = 0.00;
                                                    //Decimal.valueof(p.totalUSD) = Decimal.valueof(P.Quantity__c * P.Unit_Price__c);
                                                    if(P.Fail_Code__c != null && P.Fail_Code__c != ''){ // as per defect 178517
                                                        //lstpartsWrapperClass.add(new partsWrapperClass(P.Fail_Code__c,P.Service_partnumber__c,P.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(P.Covered__c),String.valueof(P.Unit_Price__c),String.valueof(P.ExpenseTotal__c),'',String.valueof(P.Service_partnumber__c),'',P.Replacement_Reason__c,P.ODM_Status__c,'','','','','',P.Parts_Type__c,'', p.RID__c, p.Tracking_Number__c, p.ReturnToFactory__c)); 
                                                        //GSSC-138
                                                        lstpartsWrapperClass.add(new partsWrapperClass(P.Fail_Code__c,P.Service_partnumber__c,P.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(P.Covered__c),String.valueof(unitPrice),String.valueof(amount),'',String.valueof(P.Service_partnumber__c),'',P.Replacement_Reason__c,P.ODM_Status__c,'','','','','',P.Parts_Type__c,'', p.RID__c, p.Tracking_Number__c, p.ReturnToFactory__c)); 
                                                    }
                                                    else{
                                                        //lstpartsWrapperClass.add(new partsWrapperClass(P.Get_Fail_Code_Formula__c,P.Service_partnumber__c,P.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(P.Covered__c),String.valueof(P.Unit_Price__c),String.valueof(P.ExpenseTotal__c),'',String.valueof(P.Service_partnumber__c),'',P.Replacement_Reason__c,P.ODM_Status__c,'','','','','',P.Parts_Type__c,'', p.RID__c, p.Tracking_Number__c, p.ReturnToFactory__c)); 
                                                        //GSSC-138
                                                        lstpartsWrapperClass.add(new partsWrapperClass(P.Get_Fail_Code_Formula__c,P.Service_partnumber__c,P.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(P.Covered__c),String.valueof(unitPrice),String.valueof(amount),'',String.valueof(P.Service_partnumber__c),'',P.Replacement_Reason__c,P.ODM_Status__c,'','','','','',P.Parts_Type__c,'', p.RID__c, p.Tracking_Number__c, p.ReturnToFactory__c)); 
                                                    }
                                                    duplicatePartIdSet.add(p.Id);
                                                    system.debug('****inside partslstpartsWrapperClass if***'+lstpartsWrapperClass);
                                                }
                                            }
                                        //}
                                    }
                                    else{

                                        if(p.recordtype.name=='Parts' && !duplicatePartIdSet.contains(p.Id) ) {

                                        //p.totalUSD = 0.00;
                                        //Decimal.valueof(p.totalUSD) = Decimal.valueof(P.Quantity__c * P.Unit_Price__c);
                                        if(P.Fail_Code__c != null && P.Fail_Code__c != '') {// as per defect 178517
                                            //lstpartsWrapperClass.add(new partsWrapperClass(P.Fail_Code__c,P.Service_partnumber__c,P.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(P.Covered__c),String.valueof(P.Unit_Price__c),String.valueof(P.ExpenseTotal__c),'',String.valueof(P.Service_partnumber__c),'',P.Replacement_Reason__c,P.ODM_Status__c,'','','','','',P.Parts_Type__c,'', p.RID__c, p.Tracking_Number__c, p.ReturnToFactory__c)); 
                                            //GSSC-138
                                            lstpartsWrapperClass.add(new partsWrapperClass(P.Fail_Code__c,P.Service_partnumber__c,P.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(P.Covered__c),String.valueof(unitPrice),String.valueof(amount),'',String.valueof(P.Service_partnumber__c),'',P.Replacement_Reason__c,P.ODM_Status__c,'','','','','',P.Parts_Type__c,'', p.RID__c, p.Tracking_Number__c, p.ReturnToFactory__c)); 
                                        }
                                        else{
                                            //lstpartsWrapperClass.add(new partsWrapperClass(P.Get_Fail_Code_Formula__c,P.Service_partnumber__c,P.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(P.Covered__c),String.valueof(P.Unit_Price__c),String.valueof(P.ExpenseTotal__c),'',String.valueof(P.Service_partnumber__c),'',P.Replacement_Reason__c,P.ODM_Status__c,'','','','','',P.Parts_Type__c,'', p.RID__c, p.Tracking_Number__c, p.ReturnToFactory__c)); 
                                            //GSSC-138
                                            lstpartsWrapperClass.add(new partsWrapperClass(P.Get_Fail_Code_Formula__c,P.Service_partnumber__c,P.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(P.Covered__c),String.valueof(unitPrice),String.valueof(amount),'',String.valueof(P.Service_partnumber__c),'',P.Replacement_Reason__c,P.ODM_Status__c,'','','','','',P.Parts_Type__c,'', p.RID__c, p.Tracking_Number__c, p.ReturnToFactory__c)); 
                                        }
                                        duplicatePartIdSet.add(p.Id);
                                        system.debug('****inside partslstpartsWrapperClass***'+lstpartsWrapperClass);
                                    }
                                }
                                //End  
                                    if(p.recordtype.name=='OtherClaimables' && !duplicatePartIdSet.contains(p.Id) ) {
                                        //lstotherClaimWrapperClass.add(new otherClaimWrapperClass(P.Fail_Code__c,p.Item__c,String.valueof(P.Quantity__c),String.valueof(p.ExpenseTotal__c),String.valueof(P.Covered__c),'',p.Part_Description__c,'Refer to Narrative',String.valueof(P.ExpenseTotal__c),P.ODM_Status__c,'',p.Item_BMS__c,p.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(P.Amount__c), string.valueof(p.ExpenseTotal__c))); 
                                        //GSSC-138
                                        lstotherClaimWrapperClass.add(new otherClaimWrapperClass(P.Fail_Code__c,p.Item__c,String.valueof(P.Quantity__c),String.valueof(amount),String.valueof(P.Covered__c),'',p.Part_Description__c,'Refer to Narrative',String.valueof(amount),P.ODM_Status__c,'',p.Item_BMS__c,p.Part_Description__c,String.valueof(P.Quantity__c),String.valueof(amount), string.valueof(amount))); 
                                        duplicatePartIdSet.add(p.Id);
                                    }

                                    if(claimsRec.CSS_Job__c!=null){
                                        if(p.recordtype.name=='TTML' && !duplicatePartIdSet.contains(p.Id)) {
                                            system.debug('claimsRec.SP_INSHOP_LABOR_RATE__c**'+claimsRec.SP_INSHOP_LABOR_RATE__c);
                                            system.debug('P.Quantity__c**'+P.Quantity__c);
                                            system.debug('p.Unit_Price__c**'+p.Unit_Price__c);
                                            if(P.Quantity__c == null)
                                                P.Quantity__c = 0;
                                            if(P.Unit_Price__c == '' || P.Unit_Price__c == null)
                                                P.Unit_Price__c = '0';
                                            if(claimsRec.SP_INSHOP_LABOR_RATE__c == '' || claimsRec.SP_INSHOP_LABOR_RATE__c == null)
                                                claimsRec.SP_INSHOP_LABOR_RATE__c = '0';
                                            if(p.type__c == 'Commercial-Travel'){
                                                //lstTTMLWrapperClass.add(new TTMLWrapperClass(P.Fail_Code__c,P.Type__c,P.Technician__c,String.valueof(P.ExpenseTotal__c),String.valueof(P.Covered__c),'',P.ODM_Status__c,'','','','','','','',P.Type__c,'Other','',techUserPromoIdTTML.get(P.Technician__c) == null ? '' : techUserPromoIdTTML.get(P.Technician__c),String.Valueof(decimal.Valueof(claimsRec.SP_INSHOP_LABOR_RATE__c)*0.4),String.Valueof(P.Unit_Price__c),String.valueof(P.HoursTravelled__c),String.valueof(P.Mileage__c),'',String.valueof(P.ExpenseTotal__c),String.valueof(P.ExpenseTotal__c),String.valueof(P.ExpenseTotal__c)));
                                                //GSSC-138
                                                lstTTMLWrapperClass.add(new TTMLWrapperClass(P.Fail_Code__c,P.Type__c,P.Technician__c,String.valueof(amount),String.valueof(P.Covered__c),'',P.ODM_Status__c,'','','','','','','',P.Type__c,'Other','',techUserPromoIdTTML.get(P.Technician__c) == null ? '' : techUserPromoIdTTML.get(P.Technician__c),String.Valueof(decimal.Valueof(claimsRec.SP_INSHOP_LABOR_RATE__c)*0.4),String.Valueof(unitPrice),String.valueof(P.HoursTravelled__c),String.valueof(P.Mileage__c),'',String.valueof(amount),String.valueof(amount),String.valueof(amount)));
                                            }
                                            else{
                                                //lstTTMLWrapperClass.add(new TTMLWrapperClass(P.Fail_Code__c,P.Type__c,P.Technician__c,String.valueof(P.ExpenseTotal__c),String.valueof(P.Covered__c),'',P.ODM_Status__c,'','','','','','','',P.Type__c,'Other','',techUserPromoIdTTML.get(P.Technician__c) == null ? '' : techUserPromoIdTTML.get(P.Technician__c),'','',String.valueof(P.HoursTravelled__c),String.valueof(P.Mileage__c),'',String.valueof(P.ExpenseTotal__c),String.valueof(P.ExpenseTotal__c),String.valueof(P.ExpenseTotal__c)));
                                                //GSSC-138
                                                lstTTMLWrapperClass.add(new TTMLWrapperClass(P.Fail_Code__c,P.Type__c,P.Technician__c,String.valueof(amount),String.valueof(P.Covered__c),'',P.ODM_Status__c,'','','','','','','',P.Type__c,'Other','',techUserPromoIdTTML.get(P.Technician__c) == null ? '' : techUserPromoIdTTML.get(P.Technician__c),'','',String.valueof(P.HoursTravelled__c),String.valueof(P.Mileage__c),'',String.valueof(amount),String.valueof(amount),String.valueof(amount)));
                                            }
                                            duplicatePartIdSet.add(p.Id);
                                            system.debug('lstTTMLWrapperClassAuto**'+lstTTMLWrapperClass);
                                        }
                                    }
                                    else{
                                        system.debug('claimsRec.SP_INSHOP_LABOR_RATE__c**'+claimsRec.SP_INSHOP_LABOR_RATE__c);
                                        system.debug('P.Quantity__c**'+P.Quantity__c);
                                        system.debug('p.Unit_Price__c**'+p.Unit_Price__c);
                                        if(P.Quantity__c == null)
                                            P.Quantity__c = 0;
                                        if(P.Unit_Price__c == '' || P.Unit_Price__c == null)
                                            P.Unit_Price__c = '0';
                                        if(claimsRec.SP_INSHOP_LABOR_RATE__c == '' || claimsRec.SP_INSHOP_LABOR_RATE__c == null)
                                            claimsRec.SP_INSHOP_LABOR_RATE__c = '0';
                                        if(p.recordtype.name=='TTML' && !duplicatePartIdSet.contains(p.Id)) {
                                            if(p.type__c == 'Commercial-Travel'){
                                                system.debug('Inside ComTravel**');
                                                //lstTTMLWrapperClass.add(new TTMLWrapperClass(P.Fail_Code__c,P.Type__c,P.Technician__c,String.valueof(P.ExpenseTotal__c),String.valueof(P.Covered__c),'',P.ODM_Status__c,'','','','','','','',P.Type__c,'Other','',techUserPromoIdTTML.get(P.Technician__c) == null ? '' : techUserPromoIdTTML.get(P.Technician__c),String.Valueof(decimal.Valueof(claimsRec.SP_INSHOP_LABOR_RATE__c)*0.4),String.Valueof(P.Unit_Price__c),String.valueof(P.HoursTravelled__c),String.valueof(P.Mileage__c),'',String.valueof(P.ExpenseTotal__c),String.valueof(P.ExpenseTotal__c),String.valueof(P.ExpenseTotal__c)));
                                                lstTTMLWrapperClass.add(new TTMLWrapperClass(P.Fail_Code__c,P.Type__c,P.Technician__c,String.valueof(amount),String.valueof(P.Covered__c),'',P.ODM_Status__c,'','','','','','','',P.Type__c,'Other','',techUserPromoIdTTML.get(P.Technician__c) == null ? '' : techUserPromoIdTTML.get(P.Technician__c),String.Valueof(decimal.Valueof(claimsRec.SP_INSHOP_LABOR_RATE__c)*0.4),String.Valueof(unitPrice),String.valueof(P.HoursTravelled__c),String.valueof(P.Mileage__c),'',String.valueof(amount),String.valueof(amount),String.valueof(amount)));
                                            }
                                            else{ 
                                                //lstTTMLWrapperClass.add(new TTMLWrapperClass(P.Fail_Code__c,P.Type__c,P.Technician__c,String.valueof(P.ExpenseTotal__c),String.valueof(P.Covered__c),'',P.ODM_Status__c,'','','','','','','',P.Type__c,'Other','','','',techUserPromoIdTTML.get(P.Technician__c) == null ? '' : techUserPromoIdTTML.get(P.Technician__c),String.valueof(P.HoursTravelled__c),String.valueof(P.Mileage__c),'',String.valueof(P.ExpenseTotal__c),String.valueof(P.ExpenseTotal__c),String.valueof(P.ExpenseTotal__c)));
                                                lstTTMLWrapperClass.add(new TTMLWrapperClass(P.Fail_Code__c,P.Type__c,P.Technician__c,String.valueof(amount),String.valueof(P.Covered__c),'',P.ODM_Status__c,'','','','','','','',P.Type__c,'Other','','','',techUserPromoIdTTML.get(P.Technician__c) == null ? '' : techUserPromoIdTTML.get(P.Technician__c),String.valueof(P.HoursTravelled__c),String.valueof(P.Mileage__c),'',String.valueof(amount),String.valueof(amount),String.valueof(amount)));
                                            }
                                            duplicatePartIdSet.add(p.Id);
                                            system.debug('lstTTMLWrapperClassMan**'+lstTTMLWrapperClass);
                                        }
                                    }
                                }
                            }
                            system.debug('accountcode+csssc.Fail_Code__c' + accountcode+' - '+csssc.Fail_Code__c);
                            //List<CSS_SRT__c> SRTlist = SRTAccountCodeMap.get(accountcode+csssc.System_Code__c+csssc.Component_Code__c);
                            List<CSS_SRT__c> SRTlist = SRTAccountCodeMap.get(accountcode+csssc.Fail_Code__c);
                            system.debug('****SRTlist**'+SRTlist);
                            map<string,list<CSS_SRT__c>> nonsrt = new map<string,list<CSS_SRT__c>>(); 

                            if(SRTlist != null && SRTlist.size() > 0) {
                                for(CSS_SRT__c srt : SRTlist) {
                                    string failCode;
                                    if(srt.FailCode__c == null){
                                        failCode = srt.Fail_Code_Description__c; 
                                    }
                                    else{
                                        failCode = srt.FailCode__c;
                                    }
                                    String srtJustification = '';
                                    //overlapSRTListMap
                                    if(srt.Type__c != '99Time' && overlapSRTListMap != null && overlapSRTListMap.size() >0){
                                        List<CSS_SRT__c> srtRecOverlap = overlapSRTListMap.get(SRT.SRT_ID__c);
                                        if(srtRecOverlap != null && srtRecOverlap.size() >0) {
                                            decimal OOhours = 0.0;
                                            string overridesrtcode = '';
                                            string overlapsRTNotes = '';
                                            string OverrideReason = '';
                                            system.debug('srtRecOverlap >>> ' + srtRecOverlap);
                                            boolean overlapBoolean = false;
                                            for(CSS_SRT__c overlap : srtRecOverlap) {
                                                if(overlap.Override__c) {
                                                    overlapBoolean = true;
                                                    srtJustification += 'The original overlap hours = '+overlap.Overlap_Hours__c+',Overrides with SRT code='+overlap.Overlap_SRT_Number__c+',Override Reason='+overlap.Override_Reason__c;  
                                                    //OverlapNotes = 
                                                    OOhours += overlap.Overlap_Hours__c;
                                                    if(overlap.Overlap_SRT_Number__c != null && overlap.Overlap_SRT_Number__c != '') {
                                                        if(overridesrtcode != null && overridesrtcode != '')
                                                            overridesrtcode += ','+ overlap.Overlap_SRT_Number__c;
                                                        else 
                                                            overridesrtcode = overlap.Overlap_SRT_Number__c;
                                                    }

                                                    if(overlap.OverrideReason__c != null && overlap.OverrideReason__c != '') {
                                                        if(overlapsRTNotes != null && overlapsRTNotes != '')
                                                            overlapsRTNotes += ','+ overlap.OverrideReason__c;
                                                        else 
                                                            overlapsRTNotes = overlap.OverrideReason__c;
                                                    }

                                                    if(overlap.Override_Reason__c != null && overlap.Override_Reason__c != '') {
                                                        if(OverrideReason != null && OverrideReason != '')
                                                            OverrideReason += ','+ overlap.Override_Reason__c;
                                                        else 
                                                            OverrideReason = overlap.Override_Reason__c;
                                                    }
                                                }
                                            }
                                            if(overlapBoolean)
                                                OverlapNotes += SRT.SRT_ID__c + ': The original overlap hours = <' + string.valueOf(OOhours) + '>, Overrides with SRT code=< ' + overridesrtcode + '>, Notes=<' + overlapsRTNotes + '>, Override Reason=<'+ OverrideReason + '>;';
                                        }
                                    }
                                    else if(srt.Type__c == '99Time'){
                                        srtJustification = SRT.SRT_Notes__c;    //'Refer To Narrative'; //
                                    }

                                    string SRTType = '';
                                    if(SRT.Type__c != null && SRT.Type__c != '') {
                                        if(SRT.Type__c == 'Diagnosis')
                                            SRTType = 'Diagnostic';
                                        else if(SRT.Type__c == 'Repair')
                                            SRTType = 'Repair';
                                        else if(SRT.Type__c == 'Diag Access' || SRT.Type__c == 'Repair Access')
                                            SRTType = 'Access';
                                        else if(SRT.Type__c == 'Admin') {
                                            if(SRT.IsPopUpSRT__c)
                                                SRTType = 'Custom';
                                            else
                                                SRTType = 'System';
                                        } else {
                                            SRTType = 'Custom';
                                        }
                                    }

                                    if(srt.Type__c =='Field Action'){

                                        if(overlapSRTListMap != null && overlapSRTListMap.size() >0) {
                                            List<CSS_SRT__c> srtRecOverlap = overlapSRTListMap.get(SRT.SRT_ID__c);
                                            if(srtRecOverlap != null && srtRecOverlap.size() >0) {
                                                string excludeOverlap = 'N';
                                                decimal OverlapHours = 0.0;
                                                for(CSS_SRT__c overlap : srtRecOverlap) {
                                                    if(overlap.Override__c) {
                                                        excludeOverlap = 'Y';
                                                        OverlapHours += overlap.Adjusted_Overlap_Hours__c;
                                                    } else {
                                                        OverlapHours += overlap.Overlap_Hours__c;
                                                    }
                                                }
                                                //lstSRTsWrapperClass.add(new SRTsWrapperClass(failCode,SRT.SRT_ID__c,SRT.SRT_Title__c,srt.Access_Code_Saved__c,srttimetemp12,String.valueof(SRT.SRT_Quantity__c), String.valueof(SRT.SRT_Warrantable__c), String.valueof((SRT.Extended_Hours__c != null ? SRT.Extended_Hours__c : 0.0)),'','Refer To Narrative',string.valueOf((srt.Access_Code_Saved__c != null && srt.Access_Code_Saved__c != 'R') ? 'Y' : 'N'), String.valueof(OverlapHours),SRT.CSS_Claims__r.Repair_Location__c,SRTType,SRT.ODM_Status__c,'','','','','','','', string.valueOf(SRT.SRT_Amount__c),excludeOverlap));
                                                lstfieldActionSRTsWrapper.add(new fieldActionSRTsWrapperClass(failCode,csssc.Component_Id__c,SRT.SRT_ID__c,SRT.SRT_Title__c,srt.Access_Code_Saved__c,String.valueof(SRT.SRT_Time__c),String.valueof(SRT.SRT_Quantity__c), String.valueof(SRT.SRT_Warrantable__c), String.valueof((SRT.Extended_Hours__c != null ? SRT.Extended_Hours__c : 0.0)),'','Refer To Narrative',string.valueOf((srt.Access_Code_Saved__c != null && srt.Access_Code_Saved__c == 'R') ? 'Y' : 'N'), String.valueof(OverlapHours),SRT.CSS_Claims__r.Repair_Location__c,SRTType,SRT.ODM_Status__c,'','','','','','','', string.valueOf(SRT.SRT_Amount__c),excludeOverlap,SRT.Flex_Flag__c));
                                            } else {
                                                //lstSRTsWrapperClass.add(new SRTsWrapperClass(failCode,SRT.SRT_ID__c,SRT.SRT_Title__c,srt.Access_Code_Saved__c,srttimetemp12,String.valueof(SRT.SRT_Quantity__c), String.valueof(SRT.SRT_Warrantable__c), String.valueof((SRT.Extended_Hours__c != null ? SRT.Extended_Hours__c : 0.0)),'',srtJustification,string.valueOf((srt.Access_Code_Saved__c != null && srt.Access_Code_Saved__c != 'R') ? 'Y' : 'N'), String.valueof(SRT.Overlap_Hours__c),SRT.CSS_Claims__r.Repair_Location__c,SRTType,SRT.ODM_Status__c,'','','','','','','', string.valueOf(SRT.SRT_Amount__c),'N'));
                                                lstfieldActionSRTsWrapper.add(new fieldActionSRTsWrapperClass(failCode,csssc.Component_Id__c,SRT.SRT_ID__c,SRT.SRT_Title__c,srt.Access_Code_Saved__c,String.valueof(SRT.SRT_Time__c),String.valueof(SRT.SRT_Quantity__c), String.valueof(SRT.SRT_Warrantable__c), String.valueof((SRT.Extended_Hours__c != null ? SRT.Extended_Hours__c : 0.0)),'','Refer To Narrative',string.valueOf((srt.Access_Code_Saved__c != null && srt.Access_Code_Saved__c == 'R') ? 'Y' : 'N'), String.valueof(SRT.Overlap_Hours__c),SRT.CSS_Claims__r.Repair_Location__c,SRTType,SRT.ODM_Status__c,'','','','','','','', string.valueOf(SRT.SRT_Amount__c),'N',SRT.Flex_Flag__c));//srtJustification
                                            }
                                        } else {
                                            //lstSRTsWrapperClass.add(new SRTsWrapperClass(failCode,SRT.SRT_ID__c,SRT.SRT_Title__c,srt.Access_Code_Saved__c,srttimetemp12,String.valueof(SRT.SRT_Quantity__c), String.valueof(SRT.SRT_Warrantable__c), String.valueof((SRT.Extended_Hours__c != null ? SRT.Extended_Hours__c : 0.0)),'',srtJustification,string.valueOf((srt.Access_Code_Saved__c != null && srt.Access_Code_Saved__c != 'R') ? 'Y' : 'N'), String.valueof(SRT.Overlap_Hours__c),SRT.CSS_Claims__r.Repair_Location__c,SRTType,SRT.ODM_Status__c,'','','','','','','', string.valueOf(SRT.SRT_Amount__c),'N'));
                                            lstfieldActionSRTsWrapper.add(new fieldActionSRTsWrapperClass(failCode,csssc.Component_Id__c,SRT.SRT_ID__c,SRT.SRT_Title__c,srt.Access_Code_Saved__c,String.valueof(SRT.SRT_Time__c),String.valueof(SRT.SRT_Quantity__c), String.valueof(SRT.SRT_Warrantable__c), String.valueof((SRT.Extended_Hours__c != null ? SRT.Extended_Hours__c : 0.0)),'','Refer To Narrative',string.valueOf((srt.Access_Code_Saved__c != null && srt.Access_Code_Saved__c == 'R') ? 'Y' : 'N'), String.valueof(SRT.Overlap_Hours__c),SRT.CSS_Claims__r.Repair_Location__c,SRTType,SRT.ODM_Status__c,'','','','','','','', string.valueOf(SRT.SRT_Amount__c),'N',SRT.Flex_Flag__c));//srtJustification
                                        }

                                        //lstfieldActionSRTsWrapper.add(new fieldActionSRTsWrapperClass(failCode,csssc.Component_Id__c,SRT.SRT_ID__c,SRT.SRT_Title__c,srt.Access_Code_Saved__c,String.valueof(SRT.SRT_Time__c),String.valueof(SRT.SRT_Quantity__c),String.valueof(SRT.SRT_Warrantable__c), String.valueof((SRT.Extended_Hours__c != null ? SRT.Extended_Hours__c : 0.0)), '',SRT.ODM_Status__c, string.valueOf(SRT.SRT_Amount__c))); 
                                        //Commented as part of the task # 191935
                                        /*if(SRT.SRT_Time__c!=null && SRT.SRT_Quantity__c!=null)
                                            totalfasrtTime+=SRT.SRT_Time__c*SRT.SRT_Quantity__c;*/
                                        //Added as part of the task # 191935
                                        if(SRT.Extended_Hours__c!=null){
                                            totalfasrtTime+=SRT.Extended_Hours__c;
                                        }
                                    }
                                    if(srt.Type__c !='Field Action'){
                                        //Added totalsrttemp logic for the defect#169887
                                        String srttimetemp12;
                                        boolean totsrtcheck;
                                        // Added as part of the defect fix 190492
                                        if(srt.Type__c != '99Time'){
                                            srttimetemp12 = string.valueOf(SRT.SRT_Time_Formula__c);
                                        }
                                        // Added as part of the defect fix 190492
                                        /*
                                        if(SRT.srt_category__c == null && (SRT.Diag_Access_Time__c!=null || SRT.Repair_Access_Calculated__c!=null) && 
                                           (SRT.Type__c.equalsIgnoreCase('Diag Access') || SRT.Type__c.equalsIgnoreCase('Repair Access'))) {
                                            if(SRT.Type__c.equalsIgnoreCase('Diag Access'))
                                                srttimetemp12=String.valueof(SRT.Diag_Access_Time__c);
                                            else
                                                srttimetemp12=String.valueof(SRT.Repair_Access_Calculated__c);
                                            totsrtcheck=false;
                                        } else if((srt.srt_category__c!= null && (srt.srt_category__c.equalsIgnoreCase('AdditionalDiag') || 
                                                                                  srt.srt_category__c.equalsIgnoreCase('AdditionalRep'))) || srt.solution_number__c!=null) {
                                            srttimetemp12=String.valueof(SRT.Additional_SRT_Calculated__c);
                                            totsrtcheck=true;
                                        } else{
                                            // Added as part of the defect fix 190492
                                            if(srt.Type__c == 'Diagnosis'){
                                                srttimetemp12=String.valueof(SRT.SRT_Time_Formula__c);
                                            }
                                            else{
                                                srttimetemp12=String.valueof(SRT.SRT_Time__c);
                                            }
                                            totsrtcheck=false;
                                        }

                                        if(srt.Access_Code__c == 'R'){

                                        }
                                        else{

                                        }
                                        */

                                        if(srt.Type__c == '99Time'){
                                            boolean isupdated = false;
                                            system.debug('SRTNotes***'+srt.SRT_Notes__c+'lstSRTsWrapperClass ' + lstSRTsWrapperClass.size() + ' ---- ' + lstSRTsWrapperClass);
                                            for(SRTsWrapperClass srtalready : lstSRTsWrapperClass) {
                                                if(srtalready.srtcode == '99-999') {
                                                    //pass the srt record to srtalready record and add time and hours field.
                                                    if(srt.SRT_Time__c != null) {
                                                        if(srtalready.srtTime != null && srtalready.srtTime != '')
                                                            srtalready.srtTime = string.valueOf(decimal.valueOf(srtalready.srtTime) + srt.SRT_Time__c);
                                                        else
                                                            srtalready.srtTime = string.valueOf(srt.SRT_Time__c);
                                                    }

                                                    if(srt.Claimed_Hours__c != null) {
                                                        if(srtalready.claimedHours != null && srtalready.claimedHours != '')
                                                            srtalready.claimedHours = string.valueOf(decimal.valueOf(srtalready.claimedHours) + srt.Claimed_Hours__c);
                                                        else
                                                            srtalready.claimedHours = string.valueOf(srt.Claimed_Hours__c);
                                                    }
                                                    if(srt.SRT_Notes__c != null) {
                                                        if(srtalready.Justification != null && srtalready.Justification != '') {    
                                                            srtalready.Justification = srtalready.Justification + ',' + SRT.SRT_Notes__c;
                                                            nonSRTtimeNotes = nonSRTtimeNotes + ',' + SRT.SRT_Notes__c;
                                                        } else {
                                                            srtalready.Justification = SRT.SRT_Notes__c;
                                                            nonSRTtimeNotes += SRT.SRT_Notes__c;
                                                        }
                                                    }
                                                    isupdated = true;
                                                }
                                            }
                                            if(!isupdated) {
                                                lstSRTsWrapperClass.add(new SRTsWrapperClass(failCode,SRT.SRT_ID__c,'Non-SRT Detail','R',string.valueOf(srt.SRT_Time__c),'1', SRT.SRT_Warrantable__c, String.valueof(srt.Claimed_Hours__c),'','Refer To Narrative','Y', String.valueof(SRT.Overlap_Hours__c),SRT.CSS_Claims__r.Repair_Location__c,'Custom',SRT.ODM_Status__c,'','','','','','','', string.valueOf(SRT.SRT_Amount__c), 'N',SRT.Flex_Flag__c));
                                                nonSRTtimeNotes = srtJustification;
                                            }
                                        } else {
                                            //lstSRTsWrapperClass.add(new SRTsWrapperClass(failCode,SRT.SRT_ID__c,SRT.SRT_Title__c,srt.Access_Code_Saved__c,srttimetemp12,String.valueof(SRT.SRT_Quantity__c), String.valueof(SRT.SRT_Warrantable__c), String.valueof((SRT.Extended_Hours__c != null ? SRT.Extended_Hours__c : 0.0)),'',srtJustification,string.valueOf((srt.Access_Code_Saved__c != null && srt.Access_Code_Saved__c != 'R') ? 'Y' : 'N'), String.valueof(SRT.Overlap_Hours__c),SRT.CSS_Claims__r.Repair_Location__c,'',SRT.ODM_Status__c,'','','','','','','', string.valueOf(SRT.SRT_Amount__c),'N'));
                                            if(overlapSRTListMap != null && overlapSRTListMap.size() >0) {
                                                List<CSS_SRT__c> srtRecOverlap = overlapSRTListMap.get(SRT.SRT_ID__c);
                                                if(srtRecOverlap != null && srtRecOverlap.size() >0) {
                                                    string excludeOverlap = 'N';
                                                    decimal OverlapHours = 0.0;
                                                    for(CSS_SRT__c overlap : srtRecOverlap) {
                                                        if(overlap.Override__c) {
                                                            excludeOverlap = 'Y';
                                                            OverlapHours += overlap.Adjusted_Overlap_Hours__c;
                                                        } else {
                                                            OverlapHours += overlap.Overlap_Hours__c;
                                                        }
                                                    }
                                                    lstSRTsWrapperClass.add(new SRTsWrapperClass(failCode,SRT.SRT_ID__c,SRT.SRT_Title__c,srt.Access_Code_Saved__c,srttimetemp12,String.valueof(SRT.SRT_Quantity__c), String.valueof(SRT.SRT_Warrantable__c), String.valueof((SRT.Extended_Hours__c != null ? SRT.Extended_Hours__c : 0.0)),'','Refer To Narrative',string.valueOf((srt.Access_Code_Saved__c != null && srt.Access_Code_Saved__c == 'R') ? 'Y' : 'N'), String.valueof(OverlapHours),SRT.CSS_Claims__r.Repair_Location__c,SRTType,SRT.ODM_Status__c,'','','','','','','', string.valueOf(SRT.SRT_Amount__c),excludeOverlap,SRT.Flex_Flag__c));
                                                } else {
                                                    lstSRTsWrapperClass.add(new SRTsWrapperClass(failCode,SRT.SRT_ID__c,SRT.SRT_Title__c,srt.Access_Code_Saved__c,srttimetemp12,String.valueof(SRT.SRT_Quantity__c), String.valueof(SRT.SRT_Warrantable__c), String.valueof((SRT.Extended_Hours__c != null ? SRT.Extended_Hours__c : 0.0)),'','Refer To Narrative',string.valueOf((srt.Access_Code_Saved__c != null && srt.Access_Code_Saved__c == 'R') ? 'Y' : 'N'), String.valueof(SRT.Overlap_Hours__c),SRT.CSS_Claims__r.Repair_Location__c,SRTType,SRT.ODM_Status__c,'','','','','','','', string.valueOf(SRT.SRT_Amount__c),'N',SRT.Flex_Flag__c));//srtJustification
                                                }
                                            } else {
                                                lstSRTsWrapperClass.add(new SRTsWrapperClass(failCode,SRT.SRT_ID__c,SRT.SRT_Title__c,srt.Access_Code_Saved__c,srttimetemp12,String.valueof(SRT.SRT_Quantity__c), String.valueof(SRT.SRT_Warrantable__c), String.valueof((SRT.Extended_Hours__c != null ? SRT.Extended_Hours__c : 0.0)),'','Refer To Narrative',string.valueOf((srt.Access_Code_Saved__c != null && srt.Access_Code_Saved__c == 'R') ? 'Y' : 'N'), String.valueof(SRT.Overlap_Hours__c),SRT.CSS_Claims__r.Repair_Location__c,SRTType,SRT.ODM_Status__c,'','','','','','','', string.valueOf(SRT.SRT_Amount__c),'N',SRT.Flex_Flag__c));//srtJustification
                                            }
                                        }
                                        /* - Commented due to Defect #188664 START
                                        //Added else if logic for the defect#169887
                                        if(SRT.SRT_Time__c!=null && SRT.SRT_Quantity__c!=null && !totsrtcheck)
                                        {
                                            if(SRT.Type__c.equalsIgnoreCase('Diag Access'))
                                                totalsrtTime+=SRT.Diag_Access_Time__c*SRT.SRT_Quantity__c;
                                            else if(SRT.Type__c.equalsIgnoreCase('Repair Access'))
                                                totalsrtTime+=SRT.Repair_Access_Calculated__c*SRT.SRT_Quantity__c;
                                            else
                                                totalsrtTime+=SRT.SRT_Time__c*SRT.SRT_Quantity__c;
                                        }
                                        else if(srt.Additional_SRT_Calculated__c!=null && srt.SRT_Quantity__c!=null && totsrtcheck && (srt.isPerformed__c == true || srt.SRT_AccessiblityCheck__c==true))
                                        {
                                            totalsrtTime+=srt.Additional_SRT_Calculated__c * srt.SRT_Quantity__c;
                                        }
*/
                                        if(srt.Extended_Hours__c != null) {
totalsrtTime += srt.Extended_Hours__c;
}
                                        //Defect #188664 END.
                                    }
                                }
                            }

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
                    //lstclaimWrapper.add(new claimWrapperClass(accountcode,claimids,lstfailureWrapper,lstpartsWrapperClass ,lstotherClaimWrapperClass,lstTTMLWrapperClass,lstSRTsWrapperClass,String.valueof(totalsrtTime),lstfieldActionSRTsWrapper,String.valueof(totalfasrtTime),claimsRec.Status__c));
                    List<Notes> lstnote = new  List<Notes>();
                    claimWrapperClass claim = new claimWrapperClass();
                    claim.accountcode=accountcode;
                    claim.CustomerCode = claimsRec.Customer_Code__c;
                    claim.nonSRTtimeNotes = nonSRTtimeNotes;
                    claim.OverlapNotes = OverlapNotes;
                    claim.claimid=claimids;
                    string[] location;
                    if(claimsRec.Location_Code__c != null && claimsRec.Location_Code__c !='') {
                        location = claimsRec.Location_Code__c.split('\\-');  
                        claim.ServiceProviderCode=location[1];//location[0]
                        claim.DistributorCode=location[0];
                        claim.BranchCode=location[1];
                    }

                    claim.EngineSerialNumber=claimsRec.ESN__c;
                    claim.RONumber=claimsRec.Shop_Work_Order__c;
                    claim.ClaimDate = string.valueOf(claimsRec.createddate);
                    claim.showEditLink = false;
                    if(claimsRec.status__c == 'Draft') {
                        claim.showEditLink = true;
                    } else {
                        if(claimSubMap != null && claimSubMap.size() > 0) {
                            for(CSS_Claim_Submission__c cs : claimSubMap.values()) {
                                if(cs.Account_Code__c == accountcode && cs.status__c == 'Pending Authorization')
                                    claim.showEditLink = true; 
                            }
                        }
                    }
                    system.debug('claim.showEditLink -----> ' + claim.showEditLink);
                    //claim status is draft and showEditLink
                    if(claimsRec.CSS_Job__c != null) {
                        claim.RONumber=claimsRec.Shop_Work_Order__c;
                        claim.owned = 'Y';
                    } else {
                        claim.RONumber = claimsRec.Shop_Work_Order__c;
                        claim.owned = 'N';
                    }

                    claim.WarrantyStartDate=string.valueof(claimsRec.CSS_PSNs__r[0].Warranty_Start_Date__c);

                    if(claimsRec.CSS_PSNs__r[0].ApplicationCode__c != null && claimsRec.CSS_PSNs__r[0].ApplicationCode__c != '') {
                        claim.EngineApplicationCode=claimsRec.CSS_PSNs__r[0].ApplicationCode__c;
                    } else {
                        if(claimsRec.CSS_Job__c != null)
                            claim.EngineApplicationCode = claimsRec.CSS_Job__r.ApplicationCode__c;
                        if(claimsRec.Dealer_Service_Job__c != null)
                            claim.EngineApplicationCode = claimsRec.Dealer_Service_Job__r.ApplicationCode__c;
                    }

                    if(claimsRec.CSS_Job__c != null)
                        claim.CSSJobID = claimsRec.CSS_Job__r.Name;
                    else if(claimsRec.Dealer_Service_Job__c != null)
                        claim.CSSJobID = claimsRec.Dealer_Service_Job__r.Name;
                    else
                        claim.CSSJobID = '';

                    if(claimsRec !=  null && claimsRec.CSS_PSNs__r[0].License_Plate_State__c != null && claimsRec.CSS_PSNs__r[0].License_Plate_State__c !='') {
                        string lpState = claimsRec.CSS_PSNs__r[0].License_Plate_State__c;
                        lpState =lpState.substring(0,2);
                        claim.LicencePlateState = lpState;
                    } else
                        claim.LicencePlateState = '';
                    claim.SubmittedBy = factoryUserWWid;
                    if(claimsRec.Actual_Technician_Time__c != null)
                        claim.TechActualHrs = string.valueOf(claimsRec.Actual_Technician_Time__c);
                    else
                        claim.TechActualHrs = '';
                    claim.PolicyRequestID = '';
                    claim.RMAFlag = 'N';
                    claim.Manufacturer=claimsRec.CSS_PSNs__r[0].Make__c;
                    claim.ModelSeries=claimsRec.CSS_PSNs__r[0].Model__c;
                    claim.hours = string.valueOf(claimsRec.CSS_PSNs__r[0].Product_Hours__c);
                    claim.EquipmentConfiguration = string.valueOf(claimsRec.CSS_PSNs__r[0].Unit_Type__c);
                    claim.EngineFamily = claimsRec.EngineFamilyCode__c;
                    claim.distancetype = claimsRec.CSS_PSNs__r[0].Mileage_Measure__c;
                    claim.FirstName='';
                    claim.LastName='';

                    if(claimsRec.CSS_PSNs__r[0].Before_In_Service__c == true)
                        claim.BISFlag = 'Y';
                    else
                        claim.BISFlag = 'N';

                    if(claimsRec.Multi_PSN_Claim__c == true){
                        claim.MultiESNFlg='Y';
                    }
                    else{
                        claim.MultiESNFlg='N';
                    }

                    if(claimsRec.Information_Only_Claim__c == true)
                        claim.InfoOnlyFlag='Y';
                    else
                        claim.InfoOnlyFlag='N';
                    if(accountTwoDigit != null && accountTwoDigit != '') {      //accountcode!=null && accountcode!='' - //GSSC-246 - By Krishna
                        //String covType = getCoverageType(accountcode); -//GSSC-246 - By Krishna
                        system.debug('accountTwoDigit 246' + accountTwoDigit);
                        String covType = getCoverageType(accountTwoDigit);  //GSSC-246 - By Krishna
                        system.debug('covType 246' + covType);
                        if(covType != null && covType != '' && covType == 'NPW')
                            claim.NewPartsWarrantyFlg='Y';
                        else
                            claim.NewPartsWarrantyFlg='N';
                        if(covType != null && covType != '' && covType == 'RPW')
                            claim.ReConPartsWarrantyFlg='Y';
                        else
                            claim.ReConPartsWarrantyFlg='N';
                        if(covType != null && covType != '' && covType == 'RRW')
                            claim.RoadRelayWarrantyFlg='Y';
                        else
                            claim.RoadRelayWarrantyFlg='N';
                    }
                    claim.FailureDate=string.valueof(claimsRec.CSS_PSNs__r[0].Failure_Date__c);
                   if(claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='130' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='210' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='220' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='310' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='320' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='410'){
                   system.debug('****Enter ApplicationCode__c*****');
                   system.debug('****accCodeSelected*****'+accCodeSelected);
                   system.debug('****claimsRec.CSS_PSNs__r[0].License_Plate_State__c*****'+claimsRec.CSS_PSNs__r[0].License_Plate_State__c);
                   claim.FailurePoint=String.valueof(claimsRec.CSS_PSNs__r[0].Mileage__c);//Mileage_Measure__c;
                   claim.FailureMeasure=string.valueof(claimsRec.CSS_PSNs__r[0].Mileage_Measure__c);//Product_Hours__c);
                   if((accCodeSelected != null && accCodeSelected.contains('70'))  && (claimsRec.CSS_PSNs__r[0].License_Plate_State__c == 'CA - California')) //START---Added,as per story GSSC-514
                        claim.ProductHours=string.valueof(claimsRec.CSS_PSNs__r[0].Product_Hours__c); 
                    else
                    claim.ProductHours = '';
                      //STOP---Added,as per story GSSC-514 
                   }
                    else{
                        system.debug('****Enter Else ApplicationCode__c*****');
                    claim.FailurePoint=String.valueof(claimsRec.CSS_PSNs__r[0].Product_Hours__c);//Mileage_Measure__c;
                    claim.FailureMeasure=string.valueof('Hours');//Product_Hours__c);
                    }

                    
                    
                    
                    
                   // claim.FailurePoint=String.valueof(claimsRec.CSS_PSNs__r[0].Mileage__c);//Mileage_Measure__c;
                    //claim.FailureMeasure=string.valueof(claimsRec.CSS_PSNs__r[0].Mileage_Measure__c);//Product_Hours__c);
                    //claim.MissionDisablingFlag=string.valueof(claimsRec.CSS_PSNs__r[0].Mission_Disabling__c);
                    if(claimsRec.CSS_PSNs__r[0].Mission_Disabling__c == true)
                        claim.MissionDisablingFlag = 'Y';
                    else
                        claim.MissionDisablingFlag = 'N';
                    //claim.CatastrophicFlag='';
                    system.debug('Object msg claimsRec.Catastrophic__c '+claimsRec.Catastrophic__c );
                    if(claimsRec.Catastrophic__c == true)
                        claim.CatastrophicFlag = 'Y';
                    else
                        claim.CatastrophicFlag = 'N';
                    claim.RepairDescription='';
                    claim.ReplacementPart='';
                    claim.SPCertifiedFlag='N';
                    claim.TechnicianQualifiedFlag = 'N';
                    //claim.WarrantyTrainedFlag='';
                    if(claimsRec.Account__r.Warranty_Training_Certification__c == true)
                        claim.WarrantyTrainedFlag = 'Y';
                    else
                        claim.WarrantyTrainedFlag = 'N';
                    claim.CustomerPossession='';
                    claim.DISDNumber='';
                    claim.CustomerName=claimsRec.Customer_Name__c;
                    claim.ECMCalibAfter=claimsRec.CSS_PSNs__r[0].Calibration_After__c;
                    claim.ReviewAfter = claimsRec.CSS_PSNs__r[0].Revision_After__c;
                    claim.ECMCalibBefore=claimsRec.CSS_PSNs__r[0].Calibration_Before__c;
                    claim.RevisionBefore = claimsRec.CSS_PSNs__r[0].Revision_Before__c;
                    if(claimsRec.CSS_PSNs__r[0].Justification__c != '----Select One----')
                        claim.Justification=claimsRec.CSS_PSNs__r[0].Justification__c;
                    else
                        claim.Justification='';
                    if(claimsRec.CSS_PSNs__r[0].VIN__c != null)
                        claim.EngineVIN=claimsRec.CSS_PSNs__r[0].VIN__c;
                    else
                        claim.EngineVIN='';
                    claim.ESNCount=String.valueof(claimsRec.Total_PSN_Count__c);
                    if(claimsRec.PACCAR_Flag__c)
                        claim.PaccarFlag = 'Y';
                    else
                        claim.PaccarFlag = 'N';
                    List<String> tsrList = new List<String>();
                    if(claimsRec.TSR1__c != null && claimsRec.TSR1__c != '')
                        tsrList.add(claimsRec.TSR1__c);//tsrList[0] = claimsRec.TSR1__c;
                    if(claimsRec.TSR2__c != null && claimsRec.TSR2__c != '')
                        tsrList.add(claimsRec.TSR2__c);//tsrList[1] = claimsRec.TSR2__c;
                    if(claimsRec.TSR3__c != null && claimsRec.TSR3__c != '')
                        tsrList.add(claimsRec.TSR3__c);//tsrList[2] = claimsRec.TSR3__c;
                    if(claimsRec.TSR4__c != null && claimsRec.TSR4__c != '')
                        tsrList.add(claimsRec.TSR4__c);//tsrList[3] = claimsRec.TSR4__c;
                    if(claimsRec.TSR5__c != null && claimsRec.TSR5__c != '')
                        tsrList.add(claimsRec.TSR5__c);//tsrList[4] = claimsRec.TSR5__c;
                    if(claimsRec.TSR6__c != null && claimsRec.TSR6__c != '')
                        tsrList.add(claimsRec.TSR6__c);//tsrList[5] = claimsRec.TSR6__c;
                    if(claimsRec.TSR7__c != null && claimsRec.TSR7__c != '')
                        tsrList.add(claimsRec.TSR7__c);//tsrList[6] = claimsRec.TSR7__c;
                    if(claimsRec.TSR8__c != null && claimsRec.TSR8__c != '')
                        tsrList.add(claimsRec.TSR8__c);//tsrList[7] = claimsRec.TSR8__c;
                    if(claimsRec.TSR9__c != null && claimsRec.TSR9__c != '')
                        tsrList.add(claimsRec.TSR9__c);//tsrList[8] = claimsRec.TSR9__c;
                    if(claimsRec.TSR10__c != null && claimsRec.TSR10__c != '')
                        tsrList.add(claimsRec.TSR10__c);//tsrList[9] = claimsRec.TSR10__c; 
                    if(tsrList.size() > 0){
                        tsrList.sort();
                        claim.TSRNumber=tsrList[0];
                    }
                    else
                        claim.TSRNumber = '';
                    claim.UnitNumber=claimsRec.CSS_PSNs__r[0].Unit_Number__c;
                    claim.PaccarFlag='N';
                    claim.PenaltyFlag='N';
                    if(claimsRec.ODM_Penalty__c != null && claimsRec.ODM_Penalty__c != '')
                        claim.SRTPenaltyPercentage=claimsRec.ODM_Penalty__c;
                    else
                        claim.SRTPenaltyPercentage='';

                    claim.manualAdjudicationFlag='N';
                    claim.DealerClaimNumber=claimIds;
                    claim.ClaimSource='Guidanz';
                    // claim.ClaimFiledDate=string.valueof(claimsRec.Claim_Submitted__c);
                      //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
                    claim.ClaimFiledDate= system.now().format('MM/d/yyyy');
                    if(claimsRec.CSS_Job__r.CSS_In_Shop_Labor_Rate__c != null && claimsRec.CSS_Job__r.CSS_In_Shop_Labor_Rate__c != '')
                        claim.SPInShopLaborRate=claimsRec.CSS_Job__r.CSS_In_Shop_Labor_Rate__c;
                    else
                        claim.SPInShopLaborRate='';
                    if(claimsRec.CSS_Job__r.CSS_Field_Service_Labor_Rate__c != null && claimsRec.CSS_Job__r.CSS_Field_Service_Labor_Rate__c != '')
                        claim.SPLaborRate=claimsRec.CSS_Job__r.CSS_Field_Service_Labor_Rate__c;
                    else
                        claim.SPLaborRate='';
                    if(claimsRec.CSS_Job__r.CSS_Travel_Rate__c != null && claimsRec.CSS_Job__r.CSS_Travel_Rate__c != '')
                        claim.SPTravelRate=claimsRec.CSS_Job__r.CSS_Travel_Rate__c;
                    else
                        claim.SPTravelRate='';
                    claim.Contact=claimsRec.CreatedBy.Name;
                    //claim.ListOfComplaintCodes=null;
                    //List<ComplaintCodes> lstCompCodes = new List<ComplaintCodes>();
                    List<CSS_JobEventTemporary__c> jobEventTemp1 = new List<CSS_JobEventTemporary__c>();
                    CSS_WPR_SBL_CatComplaintsListResJSON  resCatCompJSON;
                    jobEventTemp1 = [select Reason__c from CSS_JobEventTemporary__c where attribute1__c = 'CategoryComplaintCodes'];
                    string jsonResponse = jobEventTemp1[0].Reason__c;
                    resCatCompJSON = (CSS_WPR_SBL_CatComplaintsListResJSON )JSON.deserialize(jsonResponse ,CSS_WPR_SBL_CatComplaintsListResJSON .class);

                    if(resCatCompJSON != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                        for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                            if(det.ActiveFlag == 'Y'){
                                system.debug('Comp Codes--'+det.Description+' '+det.ComplaintCode);
                                categoryCompliantCode.put(det.Description,det.ComplaintCode);
                            }
                        }
                    }
                    system.debug('categoryCompliantCode--'+categoryCompliantCode);

                    claim.ListOfComplaintCodes = new List<ComplaintCodes>();
                    system.debug('categoryCompliantCode--'+categoryCompliantCode);
                    if(claimsRec.Complaint_Type_Desc__c != null && claimsRec.Complaint_Type_Desc__c != '' && claimsRec.Complaint_Type_Desc__c != '----None----'){
                        ComplaintCodes complaintcode = new ComplaintCodes();
                        system.debug('claimsRec.Complaint_Type_Desc__c--'+claimsRec.Complaint_Type_Desc__c);
                        complaintcode.ComplaintCode = categoryCompliantCode.get(claimsRec.Complaint_Type_Desc__c);
                        system.debug('complaintcode.ComplaintCode--'+complaintcode.ComplaintCode);
                        claim.ListOfComplaintCodes.add(complaintcode);
                    }
                    if(claimsRec.Complaint_Type2_Desc__c != null && claimsRec.Complaint_Type2_Desc__c != '' && claimsRec.Complaint_Type2_Desc__c != '----None----'){
                        ComplaintCodes complaintcode = new ComplaintCodes();
                        complaintcode.ComplaintCode = categoryCompliantCode.get(claimsRec.Complaint_Type2_Desc__c);
                        claim.ListOfComplaintCodes.add(complaintcode);
                    }
                    if(claimsRec.Complaint_Type3_Desc__c != null && claimsRec.Complaint_Type3_Desc__c != '' && claimsRec.Complaint_Type3_Desc__c != '----None----'){
                        ComplaintCodes complaintcode = new ComplaintCodes();
                        complaintcode.ComplaintCode = categoryCompliantCode.get(claimsRec.Complaint_Type3_Desc__c);
                        claim.ListOfComplaintCodes.add(complaintcode);
                    }
                    if(claimsRec.Complaint_Type4_Desc__c != null && claimsRec.Complaint_Type4_Desc__c != '' && claimsRec.Complaint_Type4_Desc__c != '----None----'){
                        ComplaintCodes complaintcode = new ComplaintCodes();
                        complaintcode.ComplaintCode = categoryCompliantCode.get(claimsRec.Complaint_Type4_Desc__c);
                        claim.ListOfComplaintCodes.add(complaintcode);
                    }
                    if(claimsRec.Complaint_Type5_Desc__c != null && claimsRec.Complaint_Type5_Desc__c != '' && claimsRec.Complaint_Type5_Desc__c != '----None----'){
                        ComplaintCodes complaintcode = new ComplaintCodes();
                        complaintcode.ComplaintCode = categoryCompliantCode.get(claimsRec.Complaint_Type5_Desc__c);
                        claim.ListOfComplaintCodes.add(complaintcode);
                    }
                    //PromotionIds promoId = new PromotionIds();
                    claim.ListOfPromotionIds = new List<PromotionIds>();
                    //promoId.PromotionID = 'No Promotion Id';
                    //claim.ListOfPromotionIds.add(promoId);
                    system.debug('claim.ListOfPromotionIds 1-->'+claim.ListOfPromotionIds);
                    claim.ListOfPromotionIds = promotionIdLst; //added as part of the story #161025
                    system.debug('claim.ListOfPromotionIds 2-->'+claim.ListOfPromotionIds);
                    if(claimSubWithNotes!=null && claimSubWithNotes.containsKey(claimIds)){
                        claim.claimSubNotes =  claimSubWithNotes.get(claimIds); 
                    }
                    else 
                        claim.claimSubNotes = null;
                    if(claimSubWithNotes!=null && claimSubWithNotes.containsKey(claimIds) ){
                        for( ClaimNotes no :  claimSubWithNotes.get(claimIds)){
                            Notes n =new Notes();
                            n.Note=no.Notes.body;
                            n.NoteType=no.Notes.title;
                            lstnote.add(n);
                        }}
                    system.debug('lstTTMLWrapperClass1**'+lstTTMLWrapperClass);
                    system.debug('lstfailureWrapper**'+lstfailureWrapper);
                    claim.ListOfNotes=lstnote;
                    claim.lstmultiPartWrapper = lstmultiPartWrapper; 
                    claim.failureWrapper=lstfailureWrapper;
                    claim.partsWrapper=lstpartsWrapperClass;
                    claim.otherClaimWrapper=lstotherClaimWrapperClass;
                    claim.TTMLWrapper=lstTTMLWrapperClass;
                    claim.SRTsWrapper=lstSRTsWrapperClass;
                    claim.fieldActionSRTsWrapper=lstfieldActionSRTsWrapper;
                    claim.SRTTime=String.valueof(totalsrtTime);
                    claim.FASRTTime=String.valueof(totalfasrtTime);
                    claim.status=claimsRec.Status__c;
                    claim.GuidanzClaimNumber=claimIds; 
                    claim.ListOfAdditionalESNs=addESNObj; //null; Added as part of the story #161688
                    if(lstfailureWrapper!=null&&lstfailureWrapper.size()>0){

                        if(lstfailureWrapper[0].failureType=='Campaign'||lstfailureWrapper[0].failureType=='ATC'||lstfailureWrapper[0].failureType=='TRP'){
                            claim.claimFAType=lstfailureWrapper[0].failureType;
                            claim.claimFACampaignNumber=lstfailureWrapper[0].CampaignNumber;
                            claim.CampaignNumber=lstfailureWrapper[0].CampaignNumber;
                        }
                        else{
                            claim.claimFAType='';
                            claim.claimFACampaignNumber='';
                            claim.CampaignNumber = '';
                        }
                    }

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

    //Bottom save button 
    public PageReference pgSave(){
        PageReference ReturnPage = new PageReference(ApexPages.currentPage().getUrl());
        ReturnPage.setRedirect(true);
        return ReturnPage;
    }

    //Submit Claim button- Do a odm validation for Failures,parts and SRTs before submit. Include the PrepareSiebelRequest and PrepareBMSRequest
    public PageReference SubmitClaim(){
        try {

            system.debug('inside submitclaim**');
            system.debug('accCodeSelected**'+accCodeSelected);
            system.debug('claimsRec.CSS_PSNs__r[0].License_Plate_State__c**'+claimsRec.CSS_PSNs__r[0].License_Plate_State__c);
            if(claimsRec.Information_Only_Claim__c == true && claimsRec.IsDealerCreatedClaim__c == true){ //Added condition as per story 173516
                licenseError = false;
                claimsRec.License_Plate_State_Error_message__c = '';
            }
            else{
                //for the story 154935
                if((accCodeSelected != null && accCodeSelected.contains('70'))  && (claimsRec.CSS_PSNs__r[0].License_Plate_State__c == 'Select One' || claimsRec.CSS_PSNs__r[0].License_Plate_State__c == '' || claimsRec.CSS_PSNs__r[0].License_Plate_State__c == null)){
                    licenseError = true;
                    claimsRec.License_Plate_State_Error_message__c = 'Error:You must enter License Plate State in \'Unit and Product\'';
                    saveClaimsVS();
                    update claimsRec;
                    PageReference ReturnPage = new pageReference('/apex/CG_ClaimsVS?id='+cId);
                    ReturnPage.setRedirect(true);
                    return ReturnPage;  

                }
                else{
                    licenseError = false;
                    claimsRec.License_Plate_State_Error_message__c = '';
                }
            }
            string ODMMessage = '';
            string [] IntRespBody;
            string ODMStatusCode  = '';
            list<CSS_Integration_Error__c> lstIntDetails = CG_BL_ODM.performODMPreSubmitServiceCS(SCAccountCodeMap, POAccountCodeMap, SRTAccountCodeMap, partsWarranty, fieldActionAcountcodeList, claimsRec, psnRec, null, true);
            system.debug('lstIntDetails**'+lstIntDetails);
            system.debug('claimsRec.EditCorrection__c**'+claimsRec.EditCorrection__c);
            if (DealerTypeFlag){    //userType == 'DLR'
                if(claimsRec.Information_Only_Claim__c == true && claimsRec.IsDealerCreatedClaim__c == true){
                    //Added condistion as per story 173516
                    ODMMessage = ''; }
                else{
                    if(claimsRec.CSS_Job__c == null){
                        if((claimsRec.EditCorrection__c==null || claimsRec.EditCorrection__c=='') ){
                            if(solComps.size()==0){
                                system.debug('inside if claimsRec.EditCorrection__c**'+claimsRec.EditCorrection__c);
                                ODMMessage ='You must enter Correction Notes on Job notes;;';
                            }
                            else if (solComps.size()>0){
                                Integer Campcorrectionmessage=0;
                                Integer correctionmessage=0;
                                for(css_solution_component__c SCs: solComps){
                                    if(SCs.Type__c=='Campaign' || SCs.Type__c=='ATC' || SCs.Type__c=='TSB' || SCs.Type__c=='TRP')
                                        Campcorrectionmessage+=1;
                                    else
                                        correctionmessage+=1;
                                } 
                                system.debug('Campcorrectionmessage**'+Campcorrectionmessage);
                                system.debug('correctionmessage**'+correctionmessage);
                                //if(correctionmessage==0 && Campcorrectionmessage>0)
                                if(correctionmessage>0 || Campcorrectionmessage>0) //added for Defect: #191831
                                    ODMMessage ='You must enter Correction Notes on Job notes;;';
                            }
                        }

                    }
                    else{
                        system.debug('START'+claimsRec.EditCorrection__c + 'END');
                        if(claimsRec.EditCorrection__c==null || claimsRec.EditCorrection__c==''){
                            system.debug('inside if claimsRec.EditCorrection__c**'+claimsRec.EditCorrection__c);
                            ODMMessage ='You must enter Correction Notes on Job notes;;';
                        }
                    }
                }
            }
            system.debug('ODMMessage**'+ODMMessage);
            if(lstIntDetails != null && lstIntDetails.size() >0) {
                for(CSS_Integration_Error__c IE : lstIntDetails) {
                    if(IE.Response_Body__c != null){
                        system.debug('origRespbody**'+IE.Response_Body__c);
                        IntRespBody = IE.Response_Body__c.split(';;');
                        IE.Response_Body__c = IntRespBody[0];
                        ODMStatusCode = string.valueof(IntRespBody[1]);
                    }
                    system.debug('Respbody**'+IE.Response_Body__c);
                    system.debug('statcode**'+ODMStatusCode);
                    if(IE.Error_Description__c == null && IE.Response_Body__c != null) {
                        CG_ODM_PreSubmit_ResJSONParser ODMResponse = (CG_ODM_PreSubmit_ResJSONParser)JSON.deserialize(IE.Response_Body__c,CG_ODM_PreSubmit_ResJSONParser.class);
                        system.debug('ODMResponse ' + ODMResponse); 
                        if(ODMResponse.Response.claim != null && ODMResponse.Response.claim.messages != null){
                            for(CG_ODM_PreSubmit_ResJSONParser.messages msg:ODMResponse.Response.claim.messages){
                                system.debug('Entered for loop messages section>>>>>>'+msg.description);
                                ODMMessage += msg.type + ':' + msg.description + ';;';
                            }
                        }
                    } else if(IE.Error_Description__c != null && IE.Error_Description__c.contains('Read timed out')) {
                        ODMMessage += 'ODM PreSubmit Service' + ':' + 'Read timed out' + ';;';
                    }
                }
            }
            system.debug('ODMMessage**'+ODMMessage);
            claimsRec.ODM_Pre_submit_Status_Message__c =  ODMMessage;
            //Added below if block to handle null response or failure response
            if(ODMStatusCode != '200'){
                claimsRec.ODM_Status_Code__c = string.valueOf(ODMStatusCode);

            }
            if(ODMMessage != null && ODMMessage != ''){
                if(ODMMessage.contains('ERROR') || ODMMessage.contains('You must enter Correction Notes on Job notes')){
                    claimsRec.ODM_Pre_submit_Status__c = 'ERROR';
                }
                else{
                    claimsRec.ODM_Pre_submit_Status__c = 'WARN';
                }
            }else{
                claimsRec.ODM_Pre_submit_Status__c = 'PASSED';
            }
            //prepareSiebelRequest();
            if(claimsRec.ODM_Pre_submit_Status__c == 'PASSED' || claimsRec.ODM_Pre_submit_Status__c == 'WARN') {//Temp
                prepareSiebelRequest();
                system.debug('lstsubmissionRecord ' + lstsubmissionRecord); 
                system.debug('SC-lstsubmissionRecord.SIZE ' + lstsubmissionRecord.size()); 
                CSS_JobHistory__c claimSubHist;
                try {
                    if(lstsubmissionRecord.size()>0){
                        system.debug('** Rajesh N inside');
                        insert lstsubmissionRecord;
                        
                        claimsRec.Status__c='Submitted';
                        update claimsRec;

                        claimSubHist = new CSS_JobHistory__c();
                        claimSubHist.CSS_Field_Name__c = claimsRec.name+' submitted at' + claimsRec.Claim_Submitted__c;
                        claimSubHist.CSS_Job_Id__c = claimsRec.CSS_Job__c;
                        claimSubHist.CSS_Object_Name__c = 'CSS_Claim__c';
                        insert claimSubHist;
                    }
                    system.debug('** Rajesh N Prepare BMS Request');
                    ZeroDollarSCList.clear();
                    /*prepareBMSRequest();
                    if(lstbmssubmissionRecord.size()>0){
                        update lstbmssubmissionRecord;
                    }*/
                    if(ZeroDollarSCList != null && ZeroDollarSCList.size() >0)
                        update ZeroDollarSCList;
                } catch(Exception ex) {
                    system.debug('in the exception of SubmitClaim for Siebel and BMS Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
                }  
            } else {
                system.debug('claimsRec.ODM_Pre_submit_Status_Message__c**'+claimsRec.ODM_Pre_submit_Status_Message__c);
                update claimsRec;
            }

            //Inserting Integration errors.
            if(lstIntDetails != null && lstIntDetails.size() >0) 
                insert lstIntDetails;

            //save vs page to update primary failure flag
            saveClaimsVS();
        } catch(Exception ex) {
            system.debug('in the exception of SubmitClaim - Main Method Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }  
        system.debug('After insert-->'+lstsubmissionRecord);
        PageReference ReturnPage = new pageReference('/apex/CG_ClaimsVS?id='+cId);
        ReturnPage.setRedirect(true);
        return ReturnPage;
    }

    //Claim Submission Record and the Siebel Request
    public void prepareSiebelRequest(){
        try {


            lstsubmissionRecord = new list<CSS_Claim_Submission__c>();
            system.debug('Inside SiebelRequest**'+lstclaimWrapper);
            system.debug('lstclaimWrapper**'+lstclaimWrapper.size());
            if(lstclaimWrapper.size()>0){
                for(claimWrapperClass c :lstclaimWrapper) {
                    CSS_Claim_Submission__c sRecord = new CSS_Claim_Submission__c();
                    
                    string PartReturnToCenter = 'N';
                    
                    sRecord.Status__c='Submitted';
                    //GSSC-478 start
                    if(c.partsWrapper !=null && c.partsWrapper.size()>0){
                        system.debug('exchangeRate-->'+exchangeRate);
                        for(partsWrapperClass p : c.partsWrapper){
                            if(userinfo.getDefaultCurrency() != 'USD'){
                                p.sellprice = string.valueof(decimal.valueof(p.sellprice) / exchangeRate);
                                p.totalUSD = string.valueof(decimal.valueof(p.totalUSD) / exchangeRate);
                                p.sellprice = (p.sellprice != null && p.sellprice != '') ? (string.valueof(decimal.valueof(p.sellprice).setscale(2))) : '0.00';
                                p.totalUSD = (p.totalUSD != null && p.totalUSD != '') ? (string.valueof(decimal.valueof(p.totalUSD).setscale(2))) : '0.00';
                            }
                        }
                    } 
                    
                    if(c.otherClaimWrapper !=null && c.otherClaimWrapper.size()>0){
                        for(otherClaimWrapperClass oc : c.otherClaimWrapper){ 
                            oc.amount = string.valueof(decimal.valueof(oc.amount) / exchangeRate);
                            oc.amount = (oc.amount != null && oc.amount != '') ? (string.valueof(decimal.valueof(oc.amount).setscale(2))) : '0.00';
                        }
                    }
                    
                    if(c.TTMLWrapper !=null && c.TTMLWrapper.size()>0){
                        for(TTMLWrapperClass ttml : c.TTMLWrapper){ 
                            ttml.expenseTotal = string.valueof(decimal.valueof(ttml.expenseTotal) / exchangeRate);
                            ttml.expenseTotal = (ttml.expenseTotal != null && ttml.expenseTotal != '') ? (string.valueof(decimal.valueof(ttml.expenseTotal).setscale(2))) : '0.00';
                        }
                    }
                    //GSSC-478 end
                    String ClaimJSON = JSON.serialize(c);
                    system.debug('ClaimJSON '+ClaimJSON);
                    sRecord.Claim_JSON__c=ClaimJSON;
                    //sRecord.Claim_JSON__c=String.Valueof(c);
                    sRecord.Batch_Status__c='Pre- Submitted';
                    sRecord.Individual_Claim_Id__c=c.claimid;
                    sRecord.Account_Code__c=c.accountcode;
                    sRecord.CSS_Claims__c=cId;
                    sRecord.Batch_Picked_Date__c= System.Now()+Integer.valueof(Label.CG_BatchProcessedDate);
                    CG_ClaimsInbound_SubmitToSiebel_Req submitReq = new CG_ClaimsInbound_SubmitToSiebel_Req();
                    CG_ClaimsInbound_SubmitToSiebel_Req.Header headerobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.Header();
                    CG_ClaimsInbound_SubmitToSiebel_Req.Sender Senderobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.Sender();
                    CG_ClaimsInbound_SubmitToSiebel_Req.DataArea DataAreaobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.DataArea();
                    CG_ClaimsInbound_SubmitToSiebel_Req.ListOfComplaintCodes  ListOfComplaintCodesobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.ListOfComplaintCodes();
                    CG_ClaimsInbound_SubmitToSiebel_Req.ListOfPromotionIds ListOfPromotionIdsobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.ListOfPromotionIds();
                    CG_ClaimsInbound_SubmitToSiebel_Req.ListOfNotes ListOfNotesobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.ListOfNotes();
                    CG_ClaimsInbound_SubmitToSiebel_Req.ListOfFailureList ListOfFailureListobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.ListOfFailureList();
                    CG_ClaimsInbound_SubmitToSiebel_Req.ListOfAdditionalESNs   ListOfAdditionalESNsobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.ListOfAdditionalESNs ();

                    //sender 
                    Senderobj.MessageID='UniqueID';
                    Senderobj.ServiceName='ClaimSubmission';
                    Senderobj.SenderID='CSS';

                    //Header
                    headerobj.Target='CSSWarranty';
                    headerobj.Sender=Senderobj;

                    //DataArea
                    DataAreaobj.ServiceProviderCode=c.ServiceProviderCode;
                    DataAreaobj.DistributorCode=c.DistributorCode;
                    DataAreaobj.EngineSerialNumber=c.EngineSerialNumber;
                    if(c.RONumber != null)
                        DataAreaobj.RONumber=c.RONumber;
                    else
                        DataAreaobj.RONumber = '';

                    //DataAreaobj.WarrantyStartDate=c.WarrantyStartDate;
                    if(c.WarrantyStartDate != null){
                        try {
                             //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
                            c.WarrantyStartDate = DateTime.newInstance(Date.valueof(c.WarrantyStartDate).year(),Date.valueof(c.WarrantyStartDate).month(),Date.valueof(c.WarrantyStartDate).day()).format('MM/d/yyyy');
                        } catch (exception ex) {
                            system.debug('testing' + ex);
                            if( ex.getmessage() != null &&  ex.getmessage().contains('Invalid date:'))
                                DataAreaobj.WarrantyStartDate = c.WarrantyStartDate;
                        }
                        DataAreaobj.WarrantyStartDate = c.WarrantyStartDate;
                    }
                    else
                        DataAreaobj.WarrantyStartDate = '';
                    if(c.EngineApplicationCode!=null)
                        DataAreaobj.EngineApplicationCode=c.EngineApplicationCode;
                    else
                        DataAreaobj.EngineApplicationCode='';
                    DataAreaobj.Manufacturer=c.Manufacturer;
                    DataAreaobj.ModelSeries=c.ModelSeries;
                    DataAreaobj.FirstName=c.FirstName;
                    DataAreaobj.LastName=c.LastName;
                    DataAreaobj.CSSJobID = c.CSSJobID;
                    DataAreaobj.LicencePlateState = c.LicencePlateState;
                    DataAreaobj.SubmittedBy = c.SubmittedBy;
                    DataAreaobj.TechActualHrs = c.TechActualHrs;
                    DataAreaobj.PolicyRequestID = c.PolicyRequestID;
                    DataAreaobj.RMAFlag = c.RMAFlag;
                    DataAreaobj.BISFlag=c.BISFlag;
                    DataAreaobj.MultiESNFlg=c.MultiESNFlg;
                    if(c.CampaignNumber != null)
                        DataAreaobj.CampaignNumber=c.CampaignNumber;
                    else
                        DataAreaobj.CampaignNumber = '';
                    DataAreaobj.InfoOnlyFlag=c.InfoOnlyFlag;
                    DataAreaobj.NewPartsWarrantyFlg=c.NewPartsWarrantyFlg;
                    DataAreaobj.ReConPartsWarrantyFlg=c.ReConPartsWarrantyFlg;
                    DataAreaobj.RoadRelayWarrantyFlg=c.RoadRelayWarrantyFlg;
                    if(c.FailureDate != null){
                        if(!c.FailureDate.contains('null')){
                            try {
                                 //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
                                c.FailureDate = DateTime.newInstance(Date.valueof(c.FailureDate).year(),Date.valueof(c.FailureDate).month(),Date.valueof(c.FailureDate).day()).format('MM/d/yyyy');
                            } catch (exception ex) {
                                system.debug('testing' + ex);
                                if( ex.getmessage() != null &&  ex.getmessage().contains('Invalid date:'))
                                    DataAreaobj.FailureDate=c.FailureDate;
                            }   
                            DataAreaobj.FailureDate=c.FailureDate;
                        }
                    }
                    else
                        DataAreaobj.FailureDate = '';

                    DataAreaobj.FailurePoint=c.FailurePoint;
                    DataAreaobj.FailureMeasure=c.FailureMeasure;
                    if((c.EngineApplicationCode=='130' || c.EngineApplicationCode=='210' || c.EngineApplicationCode=='220' || c.EngineApplicationCode=='310' || c.EngineApplicationCode=='320' || c.EngineApplicationCode=='410') && (accCodeSelected != null && accCodeSelected.contains('70'))  && (claimsRec.CSS_PSNs__r[0].License_Plate_State__c == 'CA - California')) //START---Added,as per story GSSC-514
                    DataAreaobj.SSAAvailableLimit=c.ProductHours; //Added, as per story GSSC-514
                    else
                    DataAreaobj.SSAAvailableLimit= '';
                    DataAreaobj.MissionDisablingFlag=c.MissionDisablingFlag;
                    DataAreaobj.CatastrophicFlag=c.CatastrophicFlag;
                    DataAreaobj.RepairDescription=c.RepairDescription;
                    DataAreaobj.ReplacementPart=c.ReplacementPart;
                    DataAreaobj.SPCertifiedFlag=c.SPCertifiedFlag;
                    DataAreaobj.WarrantyTrainedFlag=c.WarrantyTrainedFlag;
                    if(c.CustomerPossession != null && c.CustomerPossession != '')
                    DataAreaobj.CustomerPossession=c.CustomerPossession;
                    else
                        DataAreaobj.CustomerPossession = '';
                    //DataAreaobj.CustomerPossession=c.CustomerPossession;
                    DataAreaobj.DISDNumber=c.DISDNumber;
                    DataAreaobj.CustomerName=c.CustomerName;
                    if(c.ECMCalibAfter != null)
                        DataAreaobj.ECMCalibAfter=c.ECMCalibAfter;
                    else
                        DataAreaobj.ECMCalibAfter='';
                    if(c.ReviewAfter != null)
                        DataAreaobj.ReviewAfter=c.ReviewAfter;
                    else
                        DataAreaobj.ReviewAfter='';
                    if(c.ECMCalibBefore != null)
                        DataAreaobj.ECMCalibBefore=c.ECMCalibBefore;
                    else
                        DataAreaobj.ECMCalibBefore = '';
                    if(c.RevisionBefore != null)
                        DataAreaobj.RevisionBefore=c.RevisionBefore;
                    else
                        DataAreaobj.RevisionBefore='';
                    if(c.Justification != null)
                        DataAreaobj.Justification=c.Justification;
                    else
                        DataAreaobj.Justification='';
                    DataAreaobj.EngineVIN=c.EngineVIN;
                    DataAreaobj.ESNCount=c.ESNCount;
                    DataAreaobj.TSRNumber=c.TSRNumber;
                    if(c.UnitNumber != null && c.UnitNumber != '')
                        DataAreaobj.UnitNumber=c.UnitNumber;
                    else
                        DataAreaobj.UnitNumber=''; 
                    DataAreaobj.PaccarFlag=c.PaccarFlag;
                    DataAreaobj.PenaltyFlag=c.PenaltyFlag;
                    DataAreaobj.SRTPenaltyPercentage=c.SRTPenaltyPercentage;
                    DataAreaobj.manualAdjudicationFlag=c.manualAdjudicationFlag;
                    DataAreaobj.DealerClaimNumber=c.DealerClaimNumber;
                    DataAreaobj.ClaimSource=c.ClaimSource;
                    system.debug('c.ClaimFiledDate--'+c.ClaimFiledDate);
                    if(c.ClaimFiledDate != null)
                        DataAreaobj.ClaimFiledDate=c.ClaimFiledDate;
                    else
                        DataAreaobj.ClaimFiledDate='';
                    DataAreaobj.SPInShopLaborRate=c.SPInShopLaborRate;
                    DataAreaobj.SPLaborRate=c.SPLaborRate;
                    DataAreaobj.SPTravelRate=c.SPTravelRate;
                    DataAreaobj.Contact=c.Contact;
                    //ComplaintCode
                    ListOfComplaintCodesobj.ComplaintCodes =new List<CG_ClaimsInbound_SubmitToSiebel_Req.ComplaintCode>();
                    if(c.ListOfComplaintCodes!=null && c.ListOfComplaintCodes.size()>0){
                        for(ComplaintCodes cmp: c.ListOfComplaintCodes){
                            CG_ClaimsInbound_SubmitToSiebel_Req.ComplaintCode  ComplaintCodeobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.ComplaintCode();
                            ComplaintCodeobj.ComplaintCode=cmp.ComplaintCode;
                            ListOfComplaintCodesobj.ComplaintCodes.add(ComplaintCodeobj);
                        }}
                    DataAreaobj.ListOfComplaintCodes=ListOfComplaintCodesobj;

                    //PromotionIds
                    ListOfPromotionIdsobj.PromotionIds=new List<CG_ClaimsInbound_SubmitToSiebel_Req.PromotionId>();
                    if(c.ListOfPromotionIds!=null && c.ListOfPromotionIds.size()>0){
                        for(PromotionIds pro: c.ListOfPromotionIds){
                            CG_ClaimsInbound_SubmitToSiebel_Req.PromotionId  PromotionIdobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.PromotionId();
                            PromotionIdobj.PromotionID =pro.PromotionID;
                            ListOfPromotionIdsobj.PromotionIds.add(PromotionIdobj);
                        }
                    }
                    DataAreaobj.ListOfPromotionIds=ListOfPromotionIdsobj;

                    //Notes
                    ListOfNotesobj.Notes=new List<CG_ClaimsInbound_SubmitToSiebel_Req.Note>();
                    CG_ClaimsInbound_SubmitToSiebel_Req.Note Noteobject =  new CG_ClaimsInbound_SubmitToSiebel_Req.Note();
                    Noteobject.Note =System.Label.Source_Environment_Type;
                    Noteobject.NoteType = 'SourceEnv';
                    ListOfNotesobj.Notes.add(Noteobject);

                    //Added as part of the story #161688
                    Noteobject =  new CG_ClaimsInbound_SubmitToSiebel_Req.Note();
                    if(claimsRec.EditCause__c != null)
                        Noteobject.Note = claimsRec.EditCause__c;
                    else
                        Noteobject.Note = '';
                    Noteobject.NoteType = 'Cause';
                    ListOfNotesobj.Notes.add(Noteobject);

                    Noteobject =  new CG_ClaimsInbound_SubmitToSiebel_Req.Note();
                    if(claimsRec.EditCorrection__c != null)
                        Noteobject.Note = claimsRec.EditCorrection__c;
                    else{
                        for(css_solution_component__c sol:solComps){
                            if(sol.type__C!='ATC' && sol.type__C!='TSB' && sol.type__C!='TRP' && sol.type__C!='Campaign'){
                                if(solComps.size()>0 && sol.name!=null && sol.name!=''){
                                    if(Noteobject.Note==null){
                                        Noteobject.Note = 'Failure Name ='+sol.Name+ ' ' + 'Quantity =' +sol.Quantity__c+ ' ';
                                    } else
                                        Noteobject.Note += 'Failure Name ='+sol.Name+ ' ' + 'Quantity =' +sol.Quantity__c+ ' ';
                                }
                            }
                        }
                    }

                    //Noteobject.Note = '';
                    Noteobject.NoteType = 'Correction';
                    ListOfNotesobj.Notes.add(Noteobject);

                    Noteobject =  new CG_ClaimsInbound_SubmitToSiebel_Req.Note();
                    if(claimsRec.EditComplaint__c != null)
                        Noteobject.Note = claimsRec.EditComplaint__c;
                    else{

                        if(ClaimsRec.Claims_Additional_Comments__c!=null)
                            Noteobject.Note=ClaimsRec.Claims_Additional_Comments__c;
                        else
                            Noteobject.Note=ClaimsRec.Claims_General_Symptoms__c;
                    }
                    //Noteobject.Note = '';
                    Noteobject.NoteType = 'Complaint';
                    ListOfNotesobj.Notes.add(Noteobject);
                    system.debug('testtttttttt******ListOfNotesobj*'+ListOfNotesobj); 

                    Noteobject =  new CG_ClaimsInbound_SubmitToSiebel_Req.Note();
                    Noteobject.Note = c.nonSRTtimeNotes;
                    Noteobject.NoteType = '99 Time Details';
                    ListOfNotesobj.Notes.add(Noteobject);

                    //Add OverlapSRT notes  
                    Noteobject =  new CG_ClaimsInbound_SubmitToSiebel_Req.Note();
                    Noteobject.Note = c.OverlapNotes;
                    Noteobject.NoteType = 'SRT';
                    ListOfNotesobj.Notes.add(Noteobject);

                    if( c.ListOfNotes!=null && c.ListOfNotes.size()>0){
                        for(Notes n: c.ListOfNotes){
                            CG_ClaimsInbound_SubmitToSiebel_Req.Note Noteobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.Note();
                            Noteobj.Note =n.Note;
                            Noteobj.NoteType =n.NoteType;
                            ListOfNotesobj.Notes.add(Noteobj);
                        }
                    }
                    System.debug('claimsattachment'+claimsattachment);
                    if(claimsattachment != null && claimsattachment.size() == 1){
                        CG_ClaimsInbound_SubmitToSiebel_Req.Note Noteobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.Note();
                        Noteobj.Note = System.Label.CSS_Warranty_overview_link+cId;

                        Noteobj.NoteType ='AttachmentURL';
                        ListOfNotesobj.Notes.add(Noteobj);
                    }
                    DataAreaobj.ListOfNotes=ListOfNotesobj;
                    system.debug('ListOfNotesobj'+ListOfNotesobj);

                    //Created Map to checkparts duplicate wrapper records - story 178823
                    Map<String, List<partsWrapperClass>> claimSubWithAllParts = new Map<String, List<partsWrapperClass>>();
                    List<partsWrapperClass> tempPartsList;
                    if(c.partsWrapper !=null && c.partsWrapper.size()>0){
                        system.debug('*****c.partsWrapper***'+c.partsWrapper);
                        for(partsWrapperClass p : c.partsWrapper){
                            if(claimSubWithAllParts.containsKey(p.PartNumber)){
                                tempPartsList = claimSubWithAllParts.get(p.PartNumber);
                                tempPartsList.add(p);
                                claimSubWithAllParts.put(p.PartNumber, tempPartsList);
                            }
                            else{
                                tempPartsList = new List<partsWrapperClass>();
                                tempPartsList.add(p);
                                claimSubWithAllParts.put(p.PartNumber, tempPartsList);
                            }
                        }
                    }

                    //Created Map to checkSRTs duplicate wrapper records - story 178823
                    Map<String, List<SRTsWrapperClass>> claimSubWithAllSRTs = new Map<String, List<SRTsWrapperClass>>();
                    List<SRTsWrapperClass> tempSRTsList;
                    if(c.SRTsWrapper !=null && c.SRTsWrapper.size()>0){
                        for(SRTsWrapperClass s : c.SRTsWrapper){ 
                            if(claimSubWithAllSRTs.containsKey(s.srtcode)){
                                tempSRTsList = claimSubWithAllSRTs.get(s.srtcode);
                                tempSRTsList.add(s);
                                claimSubWithAllSRTs.put(s.srtcode, tempSRTsList);
                            }
                            else{
                                tempSRTsList = new List<SRTsWrapperClass>();
                                tempSRTsList.add(s);
                                claimSubWithAllSRTs.put(s.srtcode, tempSRTsList);
                            }
                        }
                    }

                    //Created Map to checkfieldactionSRTs duplicate wrapper records - story 178823
                    Map<String, List<fieldActionSRTsWrapperClass>> claimSubWithAllFASRTs = new Map<String, List<fieldActionSRTsWrapperClass>>();
                    List<fieldActionSRTsWrapperClass> tempFASRTsList;
                    if(c.fieldActionSRTsWrapper !=null && c.fieldActionSRTsWrapper.size()>0){
                        for(fieldActionSRTsWrapperClass fas : c.fieldActionSRTsWrapper){ 
                            if(claimSubWithAllSRTs.containsKey(fas.srtcode)){
                                tempFASRTsList = claimSubWithAllFASRTs.get(fas.srtcode);
                                tempFASRTsList.add(fas);
                                claimSubWithAllFASRTs.put(fas.srtcode, tempFASRTsList);
                            }
                            else{
                                tempFASRTsList = new List<fieldActionSRTsWrapperClass>();
                                tempFASRTsList.add(fas);
                                claimSubWithAllFASRTs.put(fas.srtcode, tempFASRTsList);
                            }
                        }
                    }

                    //Created Map to checkOCs duplicate wrapper records - story 178823
                    Map<String, List<otherClaimWrapperClass>> claimSubWithAllOCs = new Map<String, List<otherClaimWrapperClass>>();
                    List<otherClaimWrapperClass> tempOCsList;
                    if(c.otherClaimWrapper !=null && c.otherClaimWrapper.size()>0){
                        for(otherClaimWrapperClass oc : c.otherClaimWrapper){ 
                            if(claimSubWithAllOCs.containsKey(oc.Item)){
                                tempOCsList = claimSubWithAllOCs.get(oc.Item);
                                tempOCsList.add(oc);
                                claimSubWithAllOCs.put(oc.Item, tempOCsList);
                            }
                            else{
                                tempOCsList = new List<otherClaimWrapperClass>();
                                tempOCsList.add(oc);
                                claimSubWithAllOCs.put(oc.Item, tempOCsList);
                            }
                        }
                    }
                    
                    //Created Map to checkTTML duplicate wrapper records - task 191794
                    Map<String, List<TTMLWrapperClass>> claimSubWithAllTTMLs = new Map<String, List<TTMLWrapperClass>>();
                    List<TTMLWrapperClass> tempTTMLList;
                    if(c.TTMLWrapper !=null && c.TTMLWrapper.size()>0){
                        for(TTMLWrapperClass ttml : c.TTMLWrapper){ 
                            if(claimSubWithAllTTMLs.containsKey(ttml.Type)){
                                tempTTMLList = claimSubWithAllTTMLs.get(ttml.Type);
                                tempTTMLList.add(ttml);
                                claimSubWithAllTTMLs.put(ttml.Type, tempTTMLList);
                            }
                            else{
                                tempTTMLList = new List<TTMLWrapperClass>();
                                tempTTMLList.add(ttml);
                                claimSubWithAllTTMLs.put(ttml.Type, tempTTMLList);
                            }
                        }
                    }

                    system.debug('Today claimSubWithAllTTMLs>>    ' + claimSubWithAllTTMLs);
                    //Failurelst
                    Integer unlistedCount =0;
                    ListOfFailureListobj.FailureList=new List<CG_ClaimsInbound_SubmitToSiebel_Req.FailureList>();
                    if(c.failureWrapper!=null && c.failureWrapper.size()>0){
                        system.debug('c.failureWrapper*****'+c.failureWrapper);
                        for(failureWrapperClass f : c.failureWrapper){                       
                            CG_ClaimsInbound_SubmitToSiebel_Req.FailureList FailureListobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.FailureList();
                            CG_ClaimsInbound_SubmitToSiebel_Req.ListOfOtherClaimables  ListOfOtherClaimablesobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.ListOfOtherClaimables ();
                            CG_ClaimsInbound_SubmitToSiebel_Req.ListOfFailureCylinder  ListOfFailureCylinderobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.ListOfFailureCylinder ();
                            CG_ClaimsInbound_SubmitToSiebel_Req.ListOfTravelDetails  ListOfTravelDetailsobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.ListOfTravelDetails ();
                            CG_ClaimsInbound_SubmitToSiebel_Req.ListOfParts  ListOfPartsobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.ListOfParts();
                            CG_ClaimsInbound_SubmitToSiebel_Req.ListOfSRTs  ListOfSRTsobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.ListOfSRTs();
                            if(sRecord.Fail_Code__c!=null && sRecord.Fail_Code__c!='')
                                sRecord.Fail_Code__c=sRecord.Fail_Code__c+';'+f.failcode;
                            else
                                sRecord.Fail_Code__c=f.failcode; 

                            FailureListobj.SystemCode=f.SystemCode;
                            FailureListobj.ComponentCode=f.ComponentCode;
                            FailureListobj.FailMode=f.FailMode;
                            if(f.AccountCode != null)
                                FailureListobj.AccountCode=f.AccountCode;
                            else
                                FailureListobj.AccountCode='';
                            //For Parts Warranty Account code, pass the values at failure level(not at claim level)
                            if(partsWarranty != null && f.AccountCode != null) {
                                if(partsWarranty.contains(f.AccountCode)) {
                                    if(f.CustomerPossession != null && f.CustomerPossession != '')
                                        DataAreaobj.CustomerPossession=f.CustomerPossession;
                                    else
                                        DataAreaobj.CustomerPossession = '';
                                    //DataAreaobj.CustomerPossession=f.CustomerPossession;
                                    DataAreaobj.FailurePoint=f.FailurePoint;
                                    DataAreaobj.FailureMeasure=f.FailureMeasure;
                                    DataAreaobj.SSAAvailableLimit = ''; // GSSC-514, setting ProductHours to null at failure level, because we dont have product hours at failurelevel in case of PartsWarranty

                                    if(f.PartsWarrantyStartDate != null){
                                        try {
                                             //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
                                            f.PartsWarrantyStartDate = DateTime.newInstance(Date.valueof(f.PartsWarrantyStartDate).year(),Date.valueof(f.PartsWarrantyStartDate).month(),Date.valueof(f.PartsWarrantyStartDate).day()).format('MM/d/yyyy');
                                        } catch (exception ex) {
                                            system.debug('testing' + ex);
                                            if( ex.getmessage() != null &&  ex.getmessage().contains('Invalid date:'))
                                                DataAreaobj.WarrantyStartDate = f.PartsWarrantyStartDate;
                                        }
                                        DataAreaobj.WarrantyStartDate = f.PartsWarrantyStartDate;
                                    }
                                    else
                                        DataAreaobj.WarrantyStartDate = '';

                                    if(f.FailureDate != null){
                                        //if(!f.FailureDate.contains('null')){
                                        try {
                                            //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
                                            f.FailureDate = DateTime.newInstance(Date.valueof(f.FailureDate).year(),Date.valueof(f.FailureDate).month(),Date.valueof(f.FailureDate).day()).format('MM/d/yyyy');
                                        } catch (exception ex) {
                                            system.debug('testing' + ex);
                                            if( ex.getmessage() != null &&  ex.getmessage().contains('Invalid date:'))
                                                DataAreaobj.FailureDate = f.FailureDate;
                                        }   
                                        DataAreaobj.FailureDate = f.FailureDate;
                                        //}
                                    }
                                    else
                                        DataAreaobj.FailureDate = '';
                                }
                            }

                            if(f.PayCode != null)
                                FailureListobj.PayCode=f.PayCode;
                            else
                                FailureListobj.PayCode='';
                            if(f.CertificateNumber != null)
                                FailureListobj.CertificateNumber = f.CertificateNumber;
                            else
                                FailureListobj.CertificateNumber = '';
                            //Campaign Number
                            if(f.CampaignNumber != null)
                                FailureListobj.CampaignNumber=f.CampaignNumber;
                            else
                                FailureListobj.CampaignNumber='';
                            //Fault code for failures
                            if(f.FaultCode != null && f.FaultCode != ''){
                                if(f.FaultCode.contains('-')){
                                    String[] sFaultCode = f.FaultCode.split('-');
                                    boolean NumericFaultCode = sFaultCode[0].isNumeric();
                                    if(NumericFaultCode)
                                    FailureListobj.FaultCode = sFaultCode[0];
                                    else
                                     FailureListobj.FaultCode = '';
                                }      
                                else{
                                    FailureListobj.FaultCode = '';
                                }  
                            }
                            else
                                FailureListobj.FaultCode = '';
                            if(f.WarrantyId != null)
                                FailureListobj.WarrantyId=f.WarrantyId;
                            else
                                FailureListobj.WarrantyId = '';
                            
                            //Task: #190678
                            if(f.ApproverCode != null && f.ApproverCode != '')
                                FailureListobj.ApproverCode=f.ApproverCode.toUpperCase();
                            else
                                FailureListobj.ApproverCode='';
                            //Task: #190678
                            
                            if(f.CoverageType != null)
                                FailureListobj.CoverageType=f.CoverageType;
                            else
                                FailureListobj.CoverageType = '';
                            FailureListobj.CoveredLaborHours=f.CoveredLaborHours;
                            FailureListobj.CoveredMealsLodgingAmt=f.CoveredMealsLodgingAmt;
                            FailureListobj.CoveredOCAmount=f.CoveredOCAmount;
                            FailureListobj.CoveredPartsQuantity=f.CoveredPartsQuantity;
                            FailureListobj.CoveredTowingMiles=f.CoveredTowingMiles;
                            FailureListobj.CoveredTravelLabor=f.CoveredTravelLabor;
                            FailureListobj.CoveredTravelMiles=f.CoveredTravelMiles;
                            if(f.DeductibleAmount != null)
                                FailureListobj.DeductibleAmount=f.DeductibleAmount;
                            else
                                FailureListobj.DeductibleAmount = '';
                            if(f.AuthorizationNum != null)
                                FailureListobj.AuthorizationNum=f.AuthorizationNum;
                            else
                                FailureListobj.AuthorizationNum = '';
                            if(f.CampaignLabourPrcnt != null)
                                FailureListobj.CampaignLabourPrcnt=f.CampaignLabourPrcnt;
                            else
                                FailureListobj.CampaignLabourPrcnt='0';
                            if(f.CampaignOCPrcnt != null)
                                FailureListobj.CampaignOCPrcnt=f.CampaignOCPrcnt;
                            else
                                FailureListobj.CampaignOCPrcnt='0';
                            if(f.CampaignPartsPrcnt != null)
                                FailureListobj.CampaignPartsPrcnt=f.CampaignPartsPrcnt;
                            else
                                FailureListobj.CampaignPartsPrcnt='0';
                            if(f.CampaignTowingPrcnt != null)
                                FailureListobj.CampaignTowingPrcnt=f.CampaignTowingPrcnt;
                            else
                                FailureListobj.CampaignTowingPrcnt='0';
                            if(f.CampaignTravelPrcnt != null)
                                FailureListobj.CampaignTravelPrcnt=f.CampaignTravelPrcnt;
                            else
                                FailureListobj.CampaignTravelPrcnt='0';
                            FailureListobj.SupportPlanID = '';
                            FailureListobj.Bank = '';
                            //FailureListobj.PrimaryFailureFlag = 'N';

                            //Check primaryfailure to add SRTs, parts, Ttml and OC records to primary failure only - story 178823
                            system.debug('****claimSubWithAllParts****'+claimSubWithAllParts);
                            List<partsWrapperClass> uniquePartsList= new List<partsWrapperClass>();
                            List<otherClaimWrapperClass> uniqueOCList= new List<otherClaimWrapperClass>();
                            List<SRTsWrapperClass> uniqueSRTsList= new List<SRTsWrapperClass>();
                            List<fieldActionSRTsWrapperClass> uniqueFASRTsList= new List<fieldActionSRTsWrapperClass>();
                            List<TTMLWrapperClass> uniqueTTMLsList= new List<TTMLWrapperClass>();  //Added as part of the task 191794
                            system.debug('****f.PrimaryFailureFlag***'+f.PrimaryFailureFlag);
                            if(f.PrimaryFailureFlag==true){
                                FailureListobj.PrimaryFailureFlag = 'Y';
                                if(claimSubWithAllOCs!=null && claimSubWithAllOCs.size()>0)
                                    uniqueOCList=checkDuplicateOCs(f.failcode,claimSubWithAllOCs);
                                if(claimSubWithAllParts!=null && claimSubWithAllParts.size()>0)
                                    uniquePartsList=checkDuplicateParts(f.failcode,claimSubWithAllParts);
                                if(claimSubWithAllSRTs!=null && claimSubWithAllSRTs.size()>0)
                                    uniqueSRTsList=checkDuplicateSRTs(f.failcode,claimSubWithAllSRTs);
                                if(claimSubWithAllFASRTs!=null && claimSubWithAllFASRTs.size()>0)
                                    uniqueFASRTsList=checkDuplicateFASRTs(f.failcode,claimSubWithAllFASRTs);
                                if(claimSubWithAllFASRTs!=null && claimSubWithAllFASRTs.size()>0)
                                    uniqueFASRTsList=checkDuplicateFASRTs(f.failcode,claimSubWithAllFASRTs);
                                //Added below if condition as part of the task 191794
                                if(claimSubWithAllTTMLs != null && claimSubWithAllTTMLs.size() > 0)
                                    uniqueTTMLsList = checkDuplicateTTMLs(f.failcode,claimSubWithAllTTMLs);
                                    
                                    system.debug('TOday uniqueTTMLsList>>>  ' +uniqueTTMLsList);
                                

                                //Cylinder Start.
                                ListOfFailureCylinderobj.FailureCylinder = new List<CG_ClaimsInbound_SubmitToSiebel_Req.FailureCylinder>();
                                //CG_ClaimsInbound_SubmitToSiebel_Req.FailureCylinder  FailureCylinderobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.FailureCylinder();
                                //FailureCylinderobj.Cylinder = '';
                                //ListOfFailureCylinderobj.FailureCylinder.add(FailureCylinderobj);  
                                FailureListobj.listOfFailureCylinder = ListOfFailureCylinderobj;
                                //Cylinder end.

                                //listOfOtherClaimables start
                                ListOfOtherClaimablesobj.OtherClaimables=new List<CG_ClaimsInbound_SubmitToSiebel_Req.OtherClaimable>();
                                system.debug('uniqueOCList >>> ' + uniqueOCList);
                                if(uniqueOCList!=null && uniqueOCList.size()>0) {
                                    for(otherClaimWrapperClass o : uniqueOCList) {
                                        CG_ClaimsInbound_SubmitToSiebel_Req.OtherClaimable  OtherClaimableobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.OtherClaimable();
                                        if(o.Item == 'Unlisted'){
                                            if(unlistedCount == 0){
                                                OtherClaimableobj.Item = o.Item + ' (ADD DESCRIPTION)'; //' '+o.OtherClaimableDetails;
                                            }else{
                                                OtherClaimableobj.Item = o.Item + ' '+ unlistedCount+ ' (ADD DESCRIPTION)'; //+ ' '+ o.OtherClaimableDetails;
                                            }
                                            unlistedCount = unlistedCount+1;
                                        }else {
                                            OtherClaimableobj.Item=o.Item;
                                        }
                                        OtherClaimableobj.OtherClaimableDetails= (o.OtherClaimableDetails != null && o.OtherClaimableDetails != '' ? o.OtherClaimableDetails : '');
                                        OtherClaimableobj.ClaimedReason=o.ClaimedReason;
                                        OtherClaimableobj.ClaimedAmount=o.ClaimedAmount; //o.ClaimedAmount; This will be replaced with actual value in prepareBMSRequest method
                                        ListOfOtherClaimablesobj.OtherClaimables.add(OtherClaimableobj);   
                                    }
                                }
                                FailureListobj.listOfOtherClaimables=ListOfOtherClaimablesobj;
                                //listOfTravelDetails start
                                ListOfTravelDetailsobj.TravelDetails=new List<CG_ClaimsInbound_SubmitToSiebel_Req.TravelDetail>();
                                system.debug('TTMLWrapper**'+c.TTMLWrapper);
                                //Commented below as part of the task 191794 - START
                                /*if(c.TTMLWrapper!=null && c.TTMLWrapper.size()>0){
                                    for(TTMLWrapperClass t : c.TTMLWrapper){
                                        CG_ClaimsInbound_SubmitToSiebel_Req.TravelDetail TTMLobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.TravelDetail();

                                        switch on t.TravelType {
                                            when 'Non Commercial-Travel' { TTMLobj.TravelType = 'Non-Commercial';}

                                            when 'Commercial-Travel' { TTMLobj.TravelType = 'Commercial';}

                                            when 'Meals' { TTMLobj.TravelType = 'Non-Commercial';}

                                            when 'Lodging' { TTMLobj.TravelType = 'Non-Commercial';}

                                            when 'Towing' { TTMLobj.TravelType = 'Towing';}
                                        }
                                        TTMLobj.TravelMode = t.TravelMode;
                                        TTMLobj.OtherModeDetails = t.OtherModeDetails;
                                        system.debug('t.TechnicianPromotionId**'+t.TechnicianPromotionId);
                                        if(t.TechnicianPromotionId!=null && t.TechnicianPromotionId!=''){
                                            system.debug('***Inside If t.TechnicianPromotionId**');
                                            TTMLobj.TechnicianPromotionId = t.TechnicianPromotionId;
                                            system.debug('TTMLobj.TechnicianPromotionId**'+TTMLobj.TechnicianPromotionId);
                                        } else {
                                            system.debug('****Inside else**');
                                            TTMLobj.TechnicianPromotionId = '';
                                        }
                                        if(t.TravelType == 'Commercial-Travel'){
                                            TTMLobj.TechnicalWage = t.TechnicalWage;
                                        } else {
                                            TTMLobj.TechnicalWage = ''; 
                                        }
                                        TTMLobj.BaseFare = t.BaseFare;
                                        TTMLobj.Hours = t.Hours;
                                        TTMLobj.Distance = t.Distance;
                                        TTMLobj.UOM = t.UOM;
                                        system.debug('Anirudh Meals Amt outside if>>>'+t.MealsAmount + 'Lodging Amount>>>>>'+t.LodgingAmount+'t.TravelType>>'+t.TravelType);
                                        if(t.Traveltype == 'Meals'){
                                            TTMLobj.MealsAmount = t.MealsAmount;
                                        } else {
                                            TTMLobj.MealsAmount = '0.00';
                                        }

                                        if(t.Traveltype == 'Lodging'){
                                            TTMLobj.LodgingAmount = t.LodgingAmount;
                                        } else {
                                            TTMLobj.LodgingAmount = '0.00';
                                        }

                                        if(t.TravelType=='Towing'){
                                            TTMLobj.TowingAmount = t.TowingAmount;
                                        } else {
                                            TTMLobj.TowingAmount='0.00';  
                                        }
                                        //Anirudh changes end for Defect 165867 
                                        ListOfTravelDetailsobj.TravelDetails.add(TTMLobj);   
                                    }
                                }*/
                                //Commented above as part of the task 191794 - END
                                //Added below as part of the task 191794 - START

                                /* commented as part of story GSSC-144
                                    for(TTMLWrapperClass t : uniqueTTMLsList){
                                        CG_ClaimsInbound_SubmitToSiebel_Req.TravelDetail TTMLobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.TravelDetail();

                                        switch on t.TravelType {
                                            when 'Non Commercial-Travel' { TTMLobj.TravelType = 'Non-Commercial';}

                                            // when 'Commercial-Travel' { TTMLobj.TravelType = 'Commercial';}

                                            when 'Meals' { TTMLobj.TravelType = 'Non-Commercial';}

                                            when 'Lodging' { TTMLobj.TravelType = 'Non-Commercial';}

                                            // when 'Towing' { TTMLobj.TravelType = 'Towing';}
                                        }
                                        TTMLobj.TravelMode = t.TravelMode;
                                        TTMLobj.OtherModeDetails = t.OtherModeDetails;
                                        system.debug('t.TechnicianPromotionId**'+t.TechnicianPromotionId);
                                        if(t.TechnicianPromotionId!=null && t.TechnicianPromotionId!=''){
                                            system.debug('***Inside If t.TechnicianPromotionId**');
                                            TTMLobj.TechnicianPromotionId = t.TechnicianPromotionId;
                                            system.debug('TTMLobj.TechnicianPromotionId**'+TTMLobj.TechnicianPromotionId);
                                        } else {
                                            system.debug('****Inside else**');
                                            TTMLobj.TechnicianPromotionId = '';
                                        }
                                        if(t.TravelType == 'Commercial-Travel'){
                                            TTMLobj.TechnicalWage = t.TechnicalWage;
                                        } else {
                                            TTMLobj.TechnicalWage = ''; 
                                        }
                                        TTMLobj.BaseFare = t.BaseFare;
                                        TTMLobj.Hours = t.Hours;
                                        TTMLobj.Distance = t.Distance;
                                        TTMLobj.UOM = t.UOM;
                                        system.debug('Anirudh Meals Amt outside if>>>'+t.MealsAmount + 'Lodging Amount>>>>>'+t.LodgingAmount+'t.TravelType>>'+t.TravelType);
                                        if(t.Traveltype == 'Meals'){
                                            TTMLobj.MealsAmount = t.MealsAmount;
                                        } else {
                                            TTMLobj.MealsAmount = '0.00';
                                        }

                                        if(t.Traveltype == 'Lodging'){
                                            TTMLobj.LodgingAmount = t.LodgingAmount;
                                        } else {
                                            TTMLobj.LodgingAmount = '0.00';
                                        }

                                        if(t.TravelType=='Towing'){
                                            TTMLobj.TowingAmount = t.TowingAmount;
                                        } else {
                                            TTMLobj.TowingAmount='0.00';  
                                        }
                                        //Anirudh changes end for Defect 165867 
                                        ListOfTravelDetailsobj.TravelDetails.add(TTMLobj);   
                                    }  commented end GSSC 144 */

                                /* Anvesh added below code as part of story GSSC-144 */

                                if(uniqueTTMLsList != null && uniqueTTMLsList.size() > 0){

                                    Decimal amountMeals =0.00;
                                    Decimal amountLodging =0.00;
                                    Decimal HrsTotal = 0;
                                    Decimal DistanceTotal = 0;
                                    String TechnicianPromotionIdVar;

                                    for(TTMLWrapperClass t : uniqueTTMLsList){

                                         if(t.type == 'Meals'){
                                            if(t.MealsAmount!=null && t.MealsAmount!='')
                                                amountMeals = amountMeals+decimal.valueOf(t.MealsAmount);
                                        }
                                        if(t.type == 'Lodging'){
                                            if(t.LodgingAmount!=null && t.LodgingAmount!='')
                                                amountLodging = amountLodging+decimal.valueOf(t.LodgingAmount);
                                        }
 
                                        if(t.Hours != null && t.Hours != '')
                                            HrsTotal = HrsTotal + decimal.valueOf(t.Hours);
                                        if(t.Distance != null && t.Distance != '')
                                            DistanceTotal = DistanceTotal + decimal.valueOf(t.Distance);

 system.debug('t.TechnicianPromotionId**'+t.TechnicianPromotionId);
                                        if(t.TechnicianPromotionId!=null && t.TechnicianPromotionId!=''){
                                            TechnicianPromotionIdVar = t.TechnicianPromotionId;
                                        } 
                                        else {
                                            TechnicianPromotionIdVar = '';
                                        }
                                    }

                                    CG_ClaimsInbound_SubmitToSiebel_Req.TravelDetail TTMLobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.TravelDetail();

                                    TTMLobj.TravelType = 'Non-Commercial';
                                    TTMLobj.BaseFare = '';
                                    TTMLobj.Hours = string.valueOf(HrsTotal);
                                    TTMLobj.Distance = string.valueOf(DistanceTotal);
                                    TTMLobj.UOM = '';
                                    TTMLobj.MealsAmount = string.valueOf(amountMeals);
                                    TTMLobj.LodgingAmount = string.valueOf(amountLodging);
                                    TTMLobj.TowingAmount = '0.00';
                                    TTMLobj.TravelMode ='Other';
                                    TTMLobj.OtherModeDetails ='';
                                    TTMLobj.TechnicianPromotionId =TechnicianPromotionIdVar;
                                    TTMLobj.TechnicalWage='';
                                   
                                    ListOfTravelDetailsobj.TravelDetails.add(TTMLobj);   

                                    system.debug('Today ListOfTravelDetailsobj>>>   ' +ListOfTravelDetailsobj);

                                }  
                                 // GSSC 144 story code ENd
                                //Added below as part of the task 191794 - END
                                FailureListobj.listOfTravelDetails=ListOfTravelDetailsobj;

                                //listOfParts start
                                ListOfPartsobj.Parts=new List<CG_ClaimsInbound_SubmitToSiebel_Req.Part>();
                                system.debug('uniquePartsList >>> ' + uniquePartsList);
                                if(uniquePartsList!=null && uniquePartsList.size()>0){
                                    for(partsWrapperClass p : uniquePartsList){
                                        CG_ClaimsInbound_SubmitToSiebel_Req.Part Partobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.Part();
                                        if(p.partsType == null || p.partsType == ''){
                                            Partobj.PartNumber=p.PartNumber;
                                            Partobj.QtyClaimed=p.quantity;
                                            Partobj.PartUnitPrice= (p.sellprice != null && p.sellprice != '' ? p.sellprice : '');
                                            Partobj.PartPercentage=p.percentReq;
                                            Partobj.PricebookName=p.PricebookName;
                                            Partobj.ReplacementReason=p.ReplacementReason;
                                            Partobj.SupersededPart = p.SupersededPart;
                                            if(p.RIDNumber != null && p.RIDNumber != '')
                                                Partobj.RIDNumber = p.RIDNumber;
                                            else
                                                Partobj.RIDNumber = '';

                                            if(p.TrackingNumber != null && p.TrackingNumber != '')
                                                Partobj.TrackingNumber = p.TrackingNumber;
                                            else
                                                Partobj.TrackingNumber = '';
                                            if(p.PartsReturnFlag != null && p.PartsReturnFlag != '')
                                                Partobj.PartsReturnFlag = p.PartsReturnFlag;
                                            else
                                                Partobj.PartsReturnFlag = 'N';
                                            
                                            if(Partobj != null && Partobj.PartsReturnFlag == 'Y')
                                                PartReturnToCenter = 'Y';
                                            
                                            ListOfPartsobj.Parts.add(Partobj);
                                        }
                                        if(p.partsType != null && p.partsType == 'Custom'){
                                            Partobj.PartNumber=p.PartNumber;
                                            Partobj.QtyClaimed=p.quantity;
                                            Partobj.PartUnitPrice= (p.sellprice != null && p.sellprice != '' ? p.sellprice : '');
                                            Partobj.PartPercentage=p.percentReq;
                                            Partobj.PricebookName=p.PricebookName;
                                            Partobj.ReplacementReason=p.ReplacementReason;
                                            //commmenting as part of story 179611
                                            // Partobj.TrackingNumber = '';
                                            //Partobj.RIDNumber = '';
                                            if(p.RIDNumber != null && p.RIDNumber != '')
                                                Partobj.RIDNumber = p.RIDNumber;
                                            else
                                                Partobj.RIDNumber = '';
                                            if(p.TrackingNumber != null && p.TrackingNumber != '')
                                                Partobj.TrackingNumber = p.TrackingNumber;
                                            else
                                                Partobj.TrackingNumber = '';
                                            
                                            Partobj.SupersededPart = '';
                                            //Partobj.QtyClaimed = '';
                                            Partobj.PartsReturnFlag = 'N';
                                            ListOfPartsobj.Parts.add(Partobj);
                                        }
                                    }
                                }
                                system.debug('ListOfPartsobj >>> ' + ListOfPartsobj);
                                FailureListobj.listOfParts=ListOfPartsobj;

                                //listOfSRTs start
                                ListOfSRTsobj.SRTs=new List<CG_ClaimsInbound_SubmitToSiebel_Req.SRT>();
                                system.debug('uniqueSRTsList >>> ' + uniqueSRTsList);
                                if(uniqueSRTsList!=null && uniqueSRTsList.size()>0){
                                    for(SRTsWrapperClass   s : uniqueSRTsList){
                                        CG_ClaimsInbound_SubmitToSiebel_Req.SRT SRTobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.SRT();
                                        SRTobj.SRTCode=s.srtcode;
                                        SRTobj.SRTAccessCode= (s.accesscode != null && s.accesscode != '' ? s.accesscode : ''); 
                                        if(s.Justification != null)
                                            SRTobj.Justification=s.Justification;
                                        else
                                            SRTobj.Justification='';
                                        //Story 187673  - Pass SRt Hours to siebel 
                                        if(s.srtcode != null){      
                                            if((s.srtcode == '99-999' && s.srtDesc == 'Non-SRT Detail') || s.flexflag == true){
                                                 SRTobj.SRTHours=s.claimedHours;
                                            }
                                            else{
                                                SRTobj.SRTHours=s.srtTime; 
                                            }
                                        }    
                                        //SRTobj.SRTHours=s.srtTime;
                                        //SRTobj.SRTHours=s.claimedHours;
                                        SRTobj.SRTQty = s.quantity;
                                        SRTobj.SRTPrcnt=s.percentReq;
                                        SRTobj.OutOfChasis = s.OutOfChasis;

                                        if(s.OverlapHrs != null)
                                            SRTobj.OverlapHrs=s.OverlapHrs;
                                        else
                                            SRTobj.OverlapHrs='';
                                        if(s.Offiste == 'Mobile')
                                            SRTobj.Offiste = 'Y';
                                        else if(s.Offiste == 'In Shop')
                                            SRTobj.Offiste = 'N';
                                        else
                                            SRTobj.Offiste = 'N';                                       
                                        SRTobj.SRTType = s.SRTType; //''
                                        SRTobj.ExcludeOvrlpFlg = s.ExcludeOvrlpFlg;
                                        ListOfSRTsobj.SRTs.add(SRTobj);
                                    }
                                }

                                //Field Action.
                                system.debug('uniqueFASRTsList >>> ' + uniqueFASRTsList);
                                if(uniqueFASRTsList!=null && uniqueFASRTsList.size()>0){
                                    for(fieldActionSRTsWrapperClass   s : uniqueFASRTsList){
                                        CG_ClaimsInbound_SubmitToSiebel_Req.SRT SRTobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.SRT();
                                        SRTobj.SRTCode=s.srtcode;
                                        SRTobj.SRTAccessCode= (s.accesscode != null && s.accesscode != '' ? s.accesscode : ''); 
                                        if(s.Justification != null)
                                            SRTobj.Justification=s.Justification;
                                        else
                                            SRTobj.Justification='';
                                        
                                        if(s.srtcode != null){      
                                            if(s.srtcode == '99-999' && s.srtDesc == 'Non-SRT Detail'){
                                                 SRTobj.SRTHours=s.claimedHours;
                                            }
                                            else{
                                                SRTobj.SRTHours=s.srtTime; 
                                            }
                                        } 
                                        
                                        //SRTobj.SRTHours=s.srtTime;
                                        //SRTobj.SRTHours=s.claimedHours;

                                        SRTobj.SRTQty = s.quantity;
                                        SRTobj.SRTPrcnt=s.percentReq;
                                        SRTobj.OutOfChasis = s.OutOfChasis;
                                        if(s.OverlapHrs != null)
                                            SRTobj.OverlapHrs=s.OverlapHrs;
                                        else
                                            SRTobj.OverlapHrs='';
                                        if(s.Offiste == 'Mobile')
                                            SRTobj.Offiste = 'Y';
                                        else if(s.Offiste == 'In Shop')
                                            SRTobj.Offiste = 'N';
                                        else
                                            SRTobj.Offiste = 'N';                                       
                                        SRTobj.SRTType = s.SRTType; //''
                                        SRTobj.ExcludeOvrlpFlg = s.ExcludeOvrlpFlg;
                                        ListOfSRTsobj.SRTs.add(SRTobj);
                                    }
                                }

                                FailureListobj.listOfSRTs=ListOfSRTsobj;
                                ListOfFailureListobj.FailureList.add(FailureListobj);

                            }
                            else{
                                FailureListobj.PrimaryFailureFlag = 'N';
                                //Cylinder Start.
                                ListOfFailureCylinderobj.FailureCylinder = new List<CG_ClaimsInbound_SubmitToSiebel_Req.FailureCylinder>();
                                FailureListobj.listOfFailureCylinder = ListOfFailureCylinderobj;
                                //listOfOtherClaimables start
                                ListOfOtherClaimablesobj.OtherClaimables=new List<CG_ClaimsInbound_SubmitToSiebel_Req.OtherClaimable>();
                                FailureListobj.listOfOtherClaimables=ListOfOtherClaimablesobj;
                                //listOfTravelDetails start
                                ListOfTravelDetailsobj.TravelDetails=new List<CG_ClaimsInbound_SubmitToSiebel_Req.TravelDetail>();
                                FailureListobj.listOfTravelDetails=ListOfTravelDetailsobj;
                                //listOfParts start
                                ListOfPartsobj.Parts=new List<CG_ClaimsInbound_SubmitToSiebel_Req.Part>();
                                FailureListobj.listOfParts=ListOfPartsobj;
                                //listOfSRTs start
                                ListOfSRTsobj.SRTs=new List<CG_ClaimsInbound_SubmitToSiebel_Req.SRT>();
                                FailureListobj.listOfSRTs=ListOfSRTsobj;
                                ListOfFailureListobj.FailureList.add(FailureListobj);
                            }
                        }
                    }

                    DataAreaobj.listOfFailureList=ListOfFailureListobj;
                    system.debug('****DataAreaobj.listOfFailureList***'+DataAreaobj.listOfFailureList);

                    //Notes
                    ListOfAdditionalESNsobj.AdditionalESNs=new List<CG_ClaimsInbound_SubmitToSiebel_Req.AdditionalESNs>();
                    if(c.ListOfAdditionalESNs!=null && c.ListOfAdditionalESNs.size()>0){
                        for(AdditionalESNs a: c.ListOfAdditionalESNs){
                            system.debug('a' + a);
                            CG_ClaimsInbound_SubmitToSiebel_Req.AdditionalESNs  AdditionalESNsobj =  new CG_ClaimsInbound_SubmitToSiebel_Req.AdditionalESNs();
                            AdditionalESNsobj.EngineSerialNumber = a.EngineSerialNumber == null ? '' : a.EngineSerialNumber;
                            system.debug('a.WarrantyStartDate ---> ' + a.WarrantyStartDate);
                            if(a.WarrantyStartDate != null && a.WarrantyStartDate != ''){
                                String FailDateYear;
                                String FailDateMonth;
                                String FailDateDay;
                                String[] FailDate;
                                if(a.WarrantyStartDate.contains('/')) {
                                    FailDate = a.WarrantyStartDate.split('/');
                                    if(FailDate != null && FailDate.size() > 0 ){
                                        FailDateYear = FailDate[2];
                                        FailDateMonth = FailDate[0];
                                        FailDateDay = FailDate[1];
                                    }
                                } else if(a.WarrantyStartDate.contains('-')) {
                                    FailDate = a.WarrantyStartDate.split('-');
                                    if(FailDate != null && FailDate.size() > 0 ){
                                        FailDateYear = FailDate[0];
                                        FailDateMonth = FailDate[1];
                                        FailDateDay = FailDate[2];
                                    }
                                }

                                if(FailDateDay!=null && FailDateDay.length()<2)
                                    FailDateDay = '0'+FailDateDay;

                                if(FailDateMonth != null && FailDateMonth.length()<2)
                                    FailDateMonth = '0'+FailDateMonth;

                                a.WarrantyStartDate = FailDateMonth+'/'+FailDateDay+'/'+FailDateYear;
                                //c.FailureDate = DateTime.newInstance(Date.valueof(c.FailureDate).year(),Date.valueof(c.FailureDate).month(),Date.valueof(c.FailureDate).day()).format('YYYY-MM-dd');
                                AdditionalESNsobj.WarrantyStartDate = a.WarrantyStartDate;
                            }
                            else
                                AdditionalESNsobj.WarrantyStartDate = '';

                            AdditionalESNsobj.BISFlag = a.BISFlag == null ? '' : a.BISFlag;
                            system.debug('a.FailureDate ----> ' + a.FailureDate);
                            if(a.FailureDate != null && a.FailureDate != ''){
                                String FailDateYear;
                                String FailDateMonth;
                                String FailDateDay;
                                String[] FailDate;
                                if(a.FailureDate.contains('/')) {
                                    FailDate = a.FailureDate.split('/');
                                    if(FailDate != null && FailDate.size() > 0 ){
                                        FailDateYear = FailDate[2];
                                        FailDateMonth = FailDate[0];
                                        FailDateDay = FailDate[1];
                                    }
                                } else if(a.FailureDate.contains('-')) {
                                    FailDate = a.FailureDate.split('-');
                                    if(FailDate != null && FailDate.size() > 0 ){
                                        FailDateYear = FailDate[0];
                                        FailDateMonth = FailDate[1];
                                        FailDateDay = FailDate[2];
                                    }
                                }

                                if(FailDateDay!=null && FailDateDay.length()<2)
                                    FailDateDay = '0'+FailDateDay;

                                if(FailDateMonth != null && FailDateMonth.length()<2)
                                    FailDateMonth = '0'+FailDateMonth;

                                a.FailureDate = FailDateMonth+'/'+FailDateDay+'/'+FailDateYear;
                                if(a.FailureDate != null && a.FailureDate != '')
                                    AdditionalESNsobj.FailureDate = a.FailureDate;
                                else
                                    AdditionalESNsobj.FailureDate = '';
                            }
                            else
                                AdditionalESNsobj.FailureDate = '';

                            AdditionalESNsobj.FailurePoint =a.FailurePoint == null ? '' : a.FailurePoint;
                            AdditionalESNsobj.FailureMeasure =a.FailureMeasure == null ? '' : a.FailureMeasure;
                            //AdditionalESNsobj.SSAAvailableLimit =a.ProductHours == null ? '' : a.ProductHours; //Added as per story GSSC-514,commenting it for now, as its not mentioned in the story
                            if(a.FailureMeasure == 'MI'){
                                AdditionalESNsobj.FailureMeasure = 'Miles';
                            }
                            else if(a.FailureMeasure == 'KM'){
                                AdditionalESNsobj.FailureMeasure = 'Kilometers';
                            }
                            else if(a.FailureMeasure == 'HR'){
                                AdditionalESNsobj.FailureMeasure = 'Hours';
                            }
                            else{
                                AdditionalESNsobj.FailureMeasure = '';
                            }

                            AdditionalESNsobj.EngineVIN =a.EngineVIN == null ? '' : a.EngineVIN;
                            AdditionalESNsobj.ECMCalibAfter =a.ECMCalibAfter == null ? '' : a.ECMCalibAfter;
                            AdditionalESNsobj.ECMCalibBefore =a.ECMCalibBefore == null ? '' : a.ECMCalibBefore;
                            AdditionalESNsobj.RevisionBefore =a.RevisionBefore == null ? '' : a.RevisionBefore;
                            AdditionalESNsobj.ReviewAfter =a.ReviewAfter == null ? '' : a.ReviewAfter;
                            ListOfAdditionalESNsobj.AdditionalESNs.add(AdditionalESNsobj);
                        }
                    }
                    DataAreaobj.ListOfAdditionalESNs=ListOfAdditionalESNsobj;
                    submitReq.Header =Headerobj;
                    system.debug(' submitReq.DataArea'+ submitReq.DataArea);
                    submitReq.DataArea =DataAreaobj;
                    system.debug(' submitReq'+ submitReq);
                    String requestjsonvalue = JSON.serialize(submitReq);
                    
                    system.debug('jsssssooonnn'+requestjsonvalue);
                    sRecord.Siebel_Claim_JSON__c=requestjsonvalue;
                    sRecord.PartReturnToCenter__c = PartReturnToCenter;
                    lstsubmissionRecord.add(sRecord);
                }
            }
        } catch(Exception ex) {
            system.debug('in the exception of prepareSiebelRequest - Method Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }  
    } 

    //Method to check for parts duplicate records - story 178823
    public List<partsWrapperClass> checkDuplicateParts(String failCode, Map<String, List<partsWrapperClass>> partsWrapList){
        system.debug('**insidecheckDuplicateParts***'+partsWrapList);
        List<partsWrapperClass> tempList = new List<partsWrapperClass>();
        List<partsWrapperClass> uniquePartsList = new List<partsWrapperClass>();
        for(String partsKey: partsWrapList.keySet()){
            tempList = partsWrapList.get(partsKey);
            system.debug('**tempList***'+tempList+'**size***'+tempList.size());
            if(tempList.size()==1){
                system.debug('**insidecheckDuplicatePartsIF***');
                uniquePartsList.add(new partsWrapperClass(failCode,tempList[0].spn,tempList[0].partdescription,tempList[0].quantity,tempList[0].percentReq,tempList[0].sellprice,tempList[0].totalUSD,tempList[0].validationmessage,tempList[0].PartNumber,tempList[0].PricebookName,tempList[0].ReplacementReason,tempList[0].odmstatus,tempList[0].PartNumberService,tempList[0].ProductCodeOEM,tempList[0].UnitPrice,tempList[0].ExtendedPrice,tempList[0].PercentClaimed,tempList[0].partsType,tempList[0].SupersededPart, tempList[0].RIDNumber, tempList[0].TrackingNumber, tempList[0].PartsReturnFlag));
                continue;
            }
            else{
                system.debug('**insidecheckDuplicatePartsElse***');
                Decimal quantity=0;
                String ReplacementReason;
                String RIDNumber;
                String TrackingNumber;
                String PartsReturnFlag;
                Boolean rpReason=false;
                Boolean eprFlag=false;
                for(partsWrapperClass partsWrapObj: tempList){
                    if(partsWrapObj.quantity!=null && partsWrapObj.quantity!='')
                        quantity=quantity+decimal.valueOf(partsWrapObj.quantity);
                    if(ReplacementReason!=null && ReplacementReason.contains(partsWrapObj.ReplacementReason))
                        rpReason=true;
                    if(partsWrapObj.RIDNumber!=null || partsWrapObj.RIDNumber!='')
                        RIDNumber=partsWrapObj.RIDNumber;
                    if(partsWrapObj.TrackingNumber != null || partsWrapObj.TrackingNumber!='')
                        TrackingNumber=partsWrapObj.TrackingNumber;
                    if(partsWrapObj.PartsReturnFlag!=null || partsWrapObj.PartsReturnFlag=='Y')
                        eprFlag=true;
                }
                if(rpReason==true){
                    ReplacementReason=tempList[0].ReplacementReason;
                }
                else{
                    ReplacementReason='Refer to Narrative';
                }
                if(eprFlag==true){
                    PartsReturnFlag='Y';
                }
                else{
                    PartsReturnFlag='N';
                }
                //uniquePartsList.add(new partsWrapperClass(failCode,'','',string.valueOf(quantity),tempList[0].percentReq,'','','',tempList[0].PartNumber,'',ReplacementReason,'','','','','','',tempList[0].partsType,'', RIDNumber, TrackingNumber, PartsReturnFlag));
                uniquePartsList.add(new partsWrapperClass(failCode,tempList[0].spn,tempList[0].partdescription,string.valueOf(quantity),tempList[0].percentReq,tempList[0].sellprice,tempList[0].totalUSD,tempList[0].validationmessage,tempList[0].PartNumber,'',ReplacementReason,tempList[0].odmstatus,tempList[0].PartNumberService,tempList[0].ProductCodeOEM,tempList[0].UnitPrice,tempList[0].ExtendedPrice,tempList[0].PercentClaimed,tempList[0].partsType,tempList[0].SupersededPart, RIDNumber, TrackingNumber, PartsReturnFlag));
            }
        }
        system.debug('**insidecheckDuplicateParts--uniquePartsList***'+uniquePartsList);
        return uniquePartsList;
    }

    //Method to check for OC duplicate records - story 178823
    public List<otherClaimWrapperClass> checkDuplicateOCs(String failCode, Map<String, List<otherClaimWrapperClass>> OCWrapList){
        List<otherClaimWrapperClass> tempList = new List<otherClaimWrapperClass>();
        List<otherClaimWrapperClass> uniqueOCsList = new List<otherClaimWrapperClass>();
        system.debug('**OCWrapList--***'+OCWrapList.size()+'****'+OCWrapList);
        for(String OCKey: OCWrapList.keySet()){
            tempList = OCWrapList.get(OCKey);
            system.debug('*tempList**'+tempList.size()+'*****'+tempList);
            if(tempList.size()==1){
                system.debug('****insideIf****'+tempList[0].Item);
                if(tempList[0].Item=='Unlisted'){
                    system.debug('****insideIfUnlisted****');
                    uniqueOCsList.add(new otherClaimWrapperClass(failCode,tempList[0].Item,tempList[0].quantity,tempList[0].amount,tempList[0].percentReq,tempList[0].validationmessage,tempList[0].OtherClaimableDetails,'Refer to Narrative',tempList[0].ClaimedAmount,tempList[0].odmstatus,tempList[0].OCCreditType,tempList[0].MiscName,tempList[0].MiscDescription,tempList[0].MiscQuantity,tempList[0].MiscAmount,tempList[0].ExpenseTtoal));
                }
                else{
                    system.debug('****insideIfElse***');
                    //START GSSC-339 by Krishna.
                    //uniqueOCsList.add(new otherClaimWrapperClass(failCode,tempList[0].Item,tempList[0].quantity,tempList[0].amount,tempList[0].percentReq,tempList[0].validationmessage,'','',tempList[0].ClaimedAmount,tempList[0].odmstatus,tempList[0].OCCreditType,tempList[0].MiscName,tempList[0].MiscDescription,tempList[0].MiscQuantity,tempList[0].MiscAmount,tempList[0].ExpenseTtoal));
                    uniqueOCsList.add(new otherClaimWrapperClass(failCode,tempList[0].Item,tempList[0].quantity,tempList[0].amount, tempList[0].percentReq,tempList[0].validationmessage,tempList[0].OtherClaimableDetails,'',tempList[0].ClaimedAmount,tempList[0].odmstatus,tempList[0].OCCreditType,tempList[0].MiscName,tempList[0].MiscDescription,tempList[0].MiscQuantity,tempList[0].MiscAmount,tempList[0].ExpenseTtoal));
                    //END GSSC-339 by Krishna.
                }
                continue;
            }
            else{
                String Item;
                Decimal ClaimedAmount=0;
                string OtherClaimableDetails = '';   //Added ~ GSSC-339 by Krishna.
                for(otherClaimWrapperClass OCWrapObj: tempList){
                    system.debug('****insideElse****'+OCWrapObj.Item);
                    if(OCWrapObj.Item=='Unlisted'){
                        system.debug('****insideElseUnlisted****');
                        uniqueOCsList.add(new otherClaimWrapperClass(failCode,OCWrapObj.Item,OCWrapObj.quantity,OCWrapObj.amount,OCWrapObj.percentReq,OCWrapObj.validationmessage,OCWrapObj.OtherClaimableDetails,'Refer to Narrative',OCWrapObj.ClaimedAmount,tempList[0].odmstatus,tempList[0].OCCreditType,tempList[0].MiscName,tempList[0].MiscDescription,tempList[0].MiscQuantity,tempList[0].MiscAmount,tempList[0].ExpenseTtoal));
                        continue;
                    }
                    else{
                        system.debug('****insideElseElse***');
                        if(OCWrapObj.ClaimedAmount!=null && OCWrapObj.ClaimedAmount!='')
                            ClaimedAmount=ClaimedAmount+decimal.valueOf(OCWrapObj.ClaimedAmount);
                        //START ~ GSSC-339 by Krishna.
                        if(OCWrapObj.OtherClaimableDetails !=null && OCWrapObj.OtherClaimableDetails !='') {
                            OtherClaimableDetails +=OCWrapObj.OtherClaimableDetails;
                        }
                        //END ~ GSSC-339 by Krishna.
                        Item=OCWrapObj.Item;
                    }


                }
                if(Item != null && Item != '' && Item != 'Unlisted'){
                    system.debug('****insideitemnotunlisted***'+Item);
                    //START GSSC-339 by Krishna.
                    system.debug('****inside OtherClaimableDetails notunlisted***'+OtherClaimableDetails);
                    //uniqueOCsList.add(new otherClaimWrapperClass(failCode,Item,tempList[0].quantity,tempList[0].amount,tempList[0].percentReq,tempList[0].validationmessage,'','',String.valueOf(ClaimedAmount),tempList[0].odmstatus,tempList[0].OCCreditType,tempList[0].MiscName,tempList[0].MiscDescription,tempList[0].MiscQuantity,tempList[0].MiscAmount,tempList[0].ExpenseTtoal));
                    uniqueOCsList.add(new otherClaimWrapperClass(failCode,Item,tempList[0].quantity,tempList[0].amount, tempList[0].percentReq,tempList[0].validationmessage,OtherClaimableDetails,'',String.valueOf(ClaimedAmount),tempList[0].odmstatus,tempList[0].OCCreditType,tempList[0].MiscName,tempList[0].MiscDescription,tempList[0].MiscQuantity,tempList[0].MiscAmount,tempList[0].ExpenseTtoal));
                    //END GSSC-339 by Krishna.
                }
            }
        }
        system.debug('****uniqueOCsList****'+uniqueOCsList.size()+'****'+uniqueOCsList);
        return uniqueOCsList;
    }

    //Method to check for SRTs duplicate records - story 178823
    public List<SRTsWrapperClass> checkDuplicateSRTs(String failCode, Map<String, List<SRTsWrapperClass>> SRTsWrapList){
        system.debug('***SRTsWrapList***'+SRTsWrapList);
        system.debug('***failCode***'+failCode);
        List<SRTsWrapperClass> tempList = new List<SRTsWrapperClass>();
        List<SRTsWrapperClass> uniqueSRTsList = new List<SRTsWrapperClass>();
        for(String SRTsKey: SRTsWrapList.keySet()){
            tempList = SRTsWrapList.get(SRTsKey);
            if(tempList.size()==1){
                system.debug('**insideIF11**');
                uniqueSRTsList.add(new SRTsWrapperClass(failCode,tempList[0].srtcode,tempList[0].srtDesc,tempList[0].accesscode,tempList[0].srtTime,tempList[0].quantity,tempList[0].percentReq,tempList[0].claimedHours,tempList[0].validationmessage,'Refer to Narrative',tempList[0].OutOfChasis,tempList[0].OverlapHrs,tempList[0].Offiste,tempList[0].SRTType,tempList[0].odmstatus,tempList[0].SRTgroupnum,tempList[0].Procedureno,tempList[0].Stepnumber,tempList[0].SRTLaborRate,tempList[0].ExtendedAmount,tempList[0].ServiceModelName,tempList[0].AdjustmentReason,tempList[0].SRTAmount,tempList[0].ExcludeOvrlpFlg,tempList[0].flexflag));
                continue;
            }
            else{
                system.debug('**InsideElse11**');
                Decimal quantity=0;
                Decimal Hours=0;
                string uniqueSRTType = '';
                
                for(SRTsWrapperClass srtsWrapObj: tempList){
                    
                    if(srtsWrapObj.flexflag = true){
                        quantity =1;
                    }
                    else{
                        if(srtsWrapObj.quantity != null && srtsWrapObj.quantity!=''){
                            quantity=quantity+decimal.valueOf(srtsWrapObj.quantity);
                        }
                    }
                    
                    if(srtsWrapObj.claimedHours!=null && srtsWrapObj.claimedHours!=''){
                        Hours=Hours+decimal.valueOf(srtsWrapObj.claimedHours);
                        
                    }
                    if(srtsWrapObj.SRTType != null) {
                        if(uniqueSRTType == '') {
                            uniqueSRTType = srtsWrapObj.SRTType;
                        } else if(srtsWrapObj.SRTType == 'Repair') {
                            uniqueSRTType = 'Repair';
                        } else if(srtsWrapObj.SRTType == 'Diagnostic') {
                            if(uniqueSRTType != 'Repair')
                                uniqueSRTType = 'Diagnostic';
                        }
                    }
                }
                uniqueSRTsList.add(new SRTsWrapperClass(failCode,tempList[0].srtcode,tempList[0].srtDesc,tempList[0].accesscode,tempList[0].srtTime,string.valueOf(quantity),tempList[0].percentReq,string.valueOf(hours),tempList[0].validationmessage,'Refer to Narrative',tempList[0].OutOfChasis,tempList[0].OverlapHrs,tempList[0].Offiste,uniqueSRTType,tempList[0].odmstatus,tempList[0].SRTgroupnum,tempList[0].Procedureno,tempList[0].Stepnumber,tempList[0].SRTLaborRate,tempList[0].ExtendedAmount,tempList[0].ServiceModelName,tempList[0].AdjustmentReason,tempList[0].SRTAmount,tempList[0].ExcludeOvrlpFlg,tempList[0].flexflag));
            }
        }
        return uniqueSRTsList;
    }

    //Method to check for field action SRTs duplicate records - story 178823
    public List<fieldActionSRTsWrapperClass> checkDuplicateFASRTs(String failCode, Map<String, List<fieldActionSRTsWrapperClass>> FASRTsWrapList){
        List<fieldActionSRTsWrapperClass> tempList = new List<fieldActionSRTsWrapperClass>();
        List<fieldActionSRTsWrapperClass> uniqueFASRTsList = new List<fieldActionSRTsWrapperClass>();
        for(String FASRTsKey: FASRTsWrapList.keySet()){
            tempList = FASRTsWrapList.get(FASRTsKey);
            if(tempList.size()==1){
                uniqueFASRTsList.add(new fieldActionSRTsWrapperClass(failCode,tempList[0].fan,tempList[0].srtcode,tempList[0].srtDesc,tempList[0].accesscode,tempList[0].srtTime,tempList[0].quantity,tempList[0].percentReq,tempList[0].claimedHours,tempList[0].validationmessage,'Refer to Narrative',tempList[0].OutOfChasis,tempList[0].OverlapHrs,tempList[0].Offiste,tempList[0].SRTType,tempList[0].odmstatus,tempList[0].SRTgroupnum,tempList[0].Procedureno,tempList[0].Stepnumber,tempList[0].SRTLaborRate,tempList[0].ExtendedAmount,tempList[0].ServiceModelName,tempList[0].AdjustmentReason,tempList[0].SRTAmount,tempList[0].ExcludeOvrlpFlg,tempList[0].flexflag));
                continue;
            }
            else{
                Decimal quantity=0;
                Decimal Hours=0;
                string uniqueFSRTType = '';
                for(fieldActionSRTsWrapperClass fasrtsWrapObj: tempList){
                    if(fasrtsWrapObj.flexflag = true){
                        quantity =1;
                    }
                    else{
                        if(fasrtsWrapObj.quantity!=null && fasrtsWrapObj.quantity!=''){
                          quantity=quantity+decimal.valueOf(fasrtsWrapObj.quantity);
                        }
                    }
                    if(fasrtsWrapObj.claimedHours!=null || fasrtsWrapObj.claimedHours != '')
                        Hours=Hours+decimal.valueOf(fasrtsWrapObj.claimedHours);
                    if(fasrtsWrapObj.SRTType != null) {
                        if(uniqueFSRTType == '') {
                            uniqueFSRTType = fasrtsWrapObj.SRTType;
                        } else if(fasrtsWrapObj.SRTType == 'Repair') {
                            uniqueFSRTType = 'Repair';
                        } else if(fasrtsWrapObj.SRTType == 'Diagnostic') {
                            if(uniqueFSRTType != 'Repair')
                                uniqueFSRTType = 'Diagnostic';
                        }
                    }
                }
                uniqueFASRTsList.add(new fieldActionSRTsWrapperClass(failCode,tempList[0].fan,tempList[0].srtcode,tempList[0].srtDesc,tempList[0].accesscode,tempList[0].srtTime,string.valueOf(quantity),tempList[0].percentReq,string.valueOf(hours),tempList[0].validationmessage,'Refer to Narrative',tempList[0].OutOfChasis,tempList[0].OverlapHrs,tempList[0].Offiste,uniqueFSRTType,tempList[0].odmstatus,tempList[0].SRTgroupnum,tempList[0].Procedureno,tempList[0].Stepnumber,tempList[0].SRTLaborRate,tempList[0].ExtendedAmount,tempList[0].ServiceModelName,tempList[0].AdjustmentReason,tempList[0].SRTAmount,tempList[0].ExcludeOvrlpFlg,tempList[0].flexflag));
            }
        }
        return uniqueFASRTsList;
    }

    //Claim Submission Record and the BMS Request
    public void prepareBMSRequest(){
        try {
            Map<string,id> subRecordMap= new Map<string,id>();
            Map<Id,String> subRecordSiebelJSONMap = new Map<Id, String>();
            if(lstclaimWrapper.size()>0){
                for(claimWrapperClass c :lstclaimWrapper) {
                    if(lstsubmissionRecord!=null && lstsubmissionRecord.size()>0){
                        for(CSS_Claim_Submission__c cs: lstsubmissionRecord){
                            subRecordMap.put(cs.Individual_Claim_Id__c,cs.id);
                            subRecordSiebelJSONMap.put(cs.id,cs.Siebel_Claim_JSON__c);
                        }
                    }

                    CSS_Claim_Submission__c sRecord = new CSS_Claim_Submission__c();
                    if(subRecordMap!=null && subRecordMap.size()>0) {
                        sRecord.id=subRecordMap.get(c.claimid);}

                    CG_ClaimsInbound_SubmitToBMS_Req submitReq = new CG_ClaimsInbound_SubmitToBMS_Req();
                    CG_ClaimsInbound_SubmitToBMS_Req.Header headerobj =  new CG_ClaimsInbound_SubmitToBMS_Req.Header();
                    CG_ClaimsInbound_SubmitToBMS_Req.Sender Senderobj =  new CG_ClaimsInbound_SubmitToBMS_Req.Sender();
                    CG_ClaimsInbound_SubmitToBMS_Req.DataArea DataAreaobj =  new CG_ClaimsInbound_SubmitToBMS_Req.DataArea();

                    //sender 
                    Senderobj.MessageID='bac053ab-5b99-4301-8895-aeb67c10a2c9';
                    Senderobj.ServiceName='BMSClaimSubmission';
                    Senderobj.SenderID='CSS';

                    //Header
                    headerobj.Target='BMS';
                    headerobj.Sender=Senderobj;

                    //DataArea
                    DataAreaobj.DistributorCode = c.DistributorCode;
                    if(c.BranchCode != null)
                        DataAreaobj.BranchCode = c.BranchCode;
                    else
                        c.BranchCode = '';


                    if(c.Owned != null)
                        DataAreaobj.Owned = c.Owned;
                    else
                        DataAreaobj.Owned = '';
                    DataAreaobj.SiebelClaimNumber = 'SIEBEL CLAIM NUMBER TBU'; // This value will be updated from CSS_FN_SIEBEL class once Siebel Claim Number is genereated successfully
                    DataAreaobj.DealerClaimNumber = '';//it should be blank
                    DataAreaobj.GuidanzClaimNumber = c.GuidanzClaimNumber;
                    if(c.CSSJobID != null)
                        DataAreaobj.CSSJobID = c.CSSJobID;
                    else
                        DataAreaobj.CSSJobID = '';
                    if(c.BMSReferenceNumber != null)
                        DataAreaobj.BMSReferenceNumber = c.BMSReferenceNumber;
                    else
                        DataAreaobj.BMSReferenceNumber = '';
                    if(c.DealerCode != null)
                        DataAreaobj.DealerCode = c.DealerCode;
                    else
                        DataAreaobj.DealerCode = '';
                    if(c.CustomerCode != null)
                        DataAreaobj.CustomerCode = c.CustomerCode;
                    else
                        DataAreaobj.CustomerCode = '';
                    DataAreaobj.ESN = c.EngineSerialNumber;
                    if(c.EngineApplicationCode != null)
                        DataAreaobj.ApplicationCode = c.EngineApplicationCode;
                    else
                        DataAreaobj.ApplicationCode = '';
                    DataAreaobj.AccountCode = c.AccountCode.RIGHT(2);

                    if(c.AuthorizationNumber != null)
                        DataAreaobj.AuthorizationNumber = c.AuthorizationNumber;
                    else
                        DataAreaobj.AuthorizationNumber = '';
                    if(c.ApprovalCode != null)
                        DataAreaobj.ApprovalCode = c.ApprovalCode;
                    else
                        DataAreaobj.ApprovalCode = '';
                    if(c.PolicyRequestNumber != null)
                        DataAreaobj.PolicyRequestNumber = c.PolicyRequestNumber;
                    else
                        DataAreaobj.PolicyRequestNumber = '';
                    if(c.FailureLocation != null)
                        DataAreaobj.FailureLocation = c.FailureLocation;
                    else
                        DataAreaobj.FailureLocation = '';
                    if(c.CreateUser != null)
                        DataAreaobj.CreateUser = c.CreateUser;
                    else
                        DataAreaobj.CreateUser = '';
                    //DataAreaobj.FailureDate = c.FailureDate;

                    if(c.FailureDate != null){
                        String FailDateYear;
                        String FailDateMonth;
                        String FailDateDay;
                        //Date FailureDate_Value = c.FailureDate;
                        if(c.FailureDate.contains('/')) {
                            String []FailDate = c.FailureDate.split('/');
                            system.debug('FailDate FailDate'+FailDate);

                            if(FailDate != null && FailDate.size() > 0 ){
                                FailDateYear = FailDate[2];
                                FailDateMonth = FailDate[0];
                                FailDateDay = FailDate[1];
                            }}
                        system.debug('** Date Rajesh N'+FailDateYear+'-'+FailDateMonth+'-'+FailDateDay);
                        if(FailDateDay!=null && FailDateDay.length()<2)
                            FailDateDay = '0'+FailDateDay;

                        if(FailDateMonth != null && FailDateMonth.length()<2)
                            FailDateMonth = '0'+FailDateMonth;

                        c.FailureDate = FailDateYear+'-'+FailDateMonth+'-'+FailDateDay;
                        system.debug('** Rajesh N'+c.FailureDate);
                        //c.FailureDate = DateTime.newInstance(Date.valueof(c.FailureDate).year(),Date.valueof(c.FailureDate).month(),Date.valueof(c.FailureDate).day()).format('YYYY-MM-dd');
                        DataAreaobj.FailureDate = c.FailureDate;
                    }
                    else
                        DataAreaobj.FailureDate = '';
                    //DataAreaobj.WarrantyStartDate = c.WarrantyStartDate;
                    if(c.WarrantyStartDate != null){
                        String FailDateYear1;
                        String FailDateMonth1;
                        String FailDateDay1;
                        //Date FailureDate_Value = c.FailureDate;
                        String []FailDate1 = c.WarrantyStartDate.split('/');
                        if(FailDate1 != null && FailDate1.size() > 0 ){
                            FailDateYear1 = FailDate1[2];
                            FailDateMonth1 = FailDate1[0];
                            FailDateDay1 = FailDate1[1];
                        }

                        if(FailDateDay1!=null && FailDateDay1.length()<2)
                            FailDateDay1 = '0'+FailDateDay1;

                        if(FailDateMonth1 != null && FailDateMonth1.length()<2)
                            FailDateMonth1 = '0'+FailDateMonth1;

                        system.debug('** Date Rajesh N'+FailDateYear1+'-'+FailDateMonth1+'-'+FailDateDay1);
                        c.WarrantyStartDate = FailDateYear1+'-'+FailDateMonth1+'-'+FailDateDay1;
                        system.debug('** Rajesh N'+c.WarrantyStartDate);
                        //c.WarrantyStartDate = DateTime.newInstance(Date.valueof(c.WarrantyStartDate).year(),Date.valueof(c.WarrantyStartDate).month(),Date.valueof(c.WarrantyStartDate).day()).format('YYYY-MM-dd');
                        DataAreaobj.WarrantyStartDate = c.WarrantyStartDate;
                    }
                    else
                        DataAreaobj.WarrantyStartDate = '';

                    if(c.ClaimDate != null && c.ClaimDate.length() > 10){
                        String FailDateYear1;
                        String FailDateMonth1;
                        String FailDateDay1;
                        //Date FailureDate_Value = c.FailureDate;
                        system.debug('c.ClaimDate SIT ' + c.ClaimDate);
                        c.ClaimDate = c.ClaimDate.subString(0, 10);
                        String []FailDate1 = c.ClaimDate.split('-');
                        if(FailDate1 != null && FailDate1.size() > 0 ){
                            FailDateYear1 = FailDate1[0];
                            FailDateMonth1 = FailDate1[1];
                            FailDateDay1 = FailDate1[2];
                        }

                        if(FailDateDay1!=null && FailDateDay1.length()<2)
                            FailDateDay1 = '0'+FailDateDay1;

                        if(FailDateMonth1 != null && FailDateMonth1.length()<2)
                            FailDateMonth1 = '0'+FailDateMonth1;

                        system.debug('** Date Rajesh N'+FailDateYear1+'-'+FailDateMonth1+'-'+FailDateDay1);
                        c.ClaimDate = FailDateYear1+'-'+FailDateMonth1+'-'+FailDateDay1;
                        system.debug('** Rajesh N'+c.ClaimDate);
                        //c.WarrantyStartDate = DateTime.newInstance(Date.valueof(c.WarrantyStartDate).year(),Date.valueof(c.WarrantyStartDate).month(),Date.valueof(c.WarrantyStartDate).day()).format('YYYY-MM-dd');
                        DataAreaobj.ClaimDate = c.ClaimDate;
                    }
                    else
                        DataAreaobj.ClaimDate = '';

                    if(c.Severity != null)
                        DataAreaobj.Severity = 'A';
                    else
                        DataAreaobj.Severity = 'B';
                    if(c.SMN != null)
                        DataAreaobj.SMN = c.SMN;
                    else
                        DataAreaobj.SMN = '';
                    if(c.EngineFamily != null)
                        DataAreaobj.EngineFamily = c.EngineFamily;
                    else
                        DataAreaobj.EngineFamily = '';
                    if(c.Manufacturer != null)
                        DataAreaobj.Make = c.Manufacturer;
                    else
                        DataAreaobj.Make = '';
                    if(c.ModelSeries != null)
                        DataAreaobj.Model = c.ModelSeries;
                    else
                        DataAreaobj.Model = '';
                    if(c.EquipmentConfiguration != null)
                        DataAreaobj.EquipmentConfiguration = c.EquipmentConfiguration;
                    else
                        DataAreaobj.EquipmentConfiguration = '';
                    if(c.DistanceType != null)
                        DataAreaobj.DistanceType = c.DistanceType;
                    else
                        DataAreaobj.DistanceType = '';
                    if(c.Hours != null)
                        DataAreaobj.Hours = c.Hours;
                    else
                        DataAreaobj.Hours = '';
                    if(c.DealerApproval != null)
                        DataAreaobj.DealerApproval = c.DealerApproval;
                    else
                        DataAreaobj.DealerApproval = '';
                    if(c.DistributorAuthorization != null)
                        DataAreaobj.DistributorAuthorization = c.DistributorAuthorization;
                    else
                        DataAreaobj.DistributorAuthorization = '';
                    if(c.MaterialDisposition != null)
                        DataAreaobj.MaterialDisposition = c.MaterialDisposition;
                    else
                        DataAreaobj.MaterialDisposition = '';
                    if(c.TotalPartsAmount != null)
                        DataAreaobj.TotalPartsAmount = c.TotalPartsAmount;
                    else
                        DataAreaobj.TotalPartsAmount = '0';
                    if(c.TotalLaborAmount != null)
                        DataAreaobj.TotalLaborAmount = c.TotalLaborAmount;
                    else
                        DataAreaobj.TotalLaborAmount = '0';
                    if(c.TotalTravelAmount != null)
                        DataAreaobj.TotalTravelAmount = c.TotalTravelAmount;
                    else
                        DataAreaobj.TotalTravelAmount = '0';
                    if(c.TotalOtherAmount != null)
                        DataAreaobj.TotalOtherAmount = c.TotalOtherAmount;
                    else
                        DataAreaobj.TotalOtherAmount = '0';
                    if(c.PMU != null)
                        DataAreaobj.PMU = c.PMU;
                    else
                        DataAreaobj.PMU = '0.00';
                    if(c.BFC != null)
                        DataAreaobj.BFC = c.BFC;
                    else
                        DataAreaobj.BFC = '';
                    if(c.Tax != null)
                        DataAreaobj.Tax = c.Tax;
                    else
                        DataAreaobj.Tax = '0';
                    //if(c.TotalClaimAmount != null)
                    //  DataAreaobj.TotalClaimAmount = c.TotalClaimAmount;
                    //else
                    //  DataAreaobj.TotalClaimAmount = '0';
                    if(c.Reference1 != null)
                        DataAreaobj.Reference1 = c.Reference1;
                    else
                        DataAreaobj.Reference1 = '';
                    if(c.Reference2 != null)
                        DataAreaobj.Reference2 = c.Reference2;
                    else
                        DataAreaobj.Reference2 = '';
                    if(c.Reference3 != null)
                        DataAreaobj.Reference3 = c.Reference3;
                    else
                        DataAreaobj.Reference3 = '';

                    //FailCode
                    //ListOfComplaintCodesobj.FailCode =new List<CG_ClaimsInbound_SubmitToBMS_Req.FailCode>();
                    dataAreaObj.FailCode = new List<CG_ClaimsInbound_SubmitToBMS_Req.FailCode>();
                    dataAreaObj.Notes = new List<CG_ClaimsInbound_SubmitToBMS_Req.Notes>();
                    dataAreaObj.Parts = new List<CG_ClaimsInbound_SubmitToBMS_Req.Parts>();
                    dataAreaObj.OtherClaimables = new List<CG_ClaimsInbound_SubmitToBMS_Req.OtherClaimables>();
                    dataAreaObj.SRTs = new List<CG_ClaimsInbound_SubmitToBMS_Req.SRTs>();
                    dataAreaObj.TravelDetails = new List<CG_ClaimsInbound_SubmitToBMS_Req.TravelDetails>();
                    dataAreaObj.TravelDetails = new List<CG_ClaimsInbound_SubmitToBMS_Req.TravelDetails>();
                    dataAreaObj.AdditionalESNs = new List<CG_ClaimsInbound_SubmitToBMS_Req.AdditionalESNs>();

                    decimal totalclaimAmt = 0.0;//1.00;
                    decimal totalSRTAmount = 0.0;
                    decimal totalPartsAmount = 0.0;
                    decimal totalOCAmount = 0.0;
                    decimal totalTowingAmount = 0.0;
                    decimal totalTravelAmount = 0.0;

                    if(c.failureWrapper!=null && c.failureWrapper.size()>0){
                        for(failureWrapperClass f : c.failureWrapper){

                            if(f.PayCode != null)
                                DataAreaobj.PayCode = f.PayCode;
                            else
                                DataAreaobj.PayCode = '';

                            CG_ClaimsInbound_SubmitToBMS_Req.FailCode Fcodes = new  CG_ClaimsInbound_SubmitToBMS_Req.FailCode();
                            Fcodes.ProductGroup = 'HH';//f.ProductGroup;
                            Fcodes.GroupCode = '00';//f.GroupCode;
                            Fcodes.SystemCode = f.SystemCode;
                            Fcodes.ComponentCode = f.ComponentCode;
                            Fcodes.FailureMode = f.FailMode;
                            Fcodes.FailLocation = 'AA';//f.FailLocation;
                            if(f.FailureOrder != null)
                                Fcodes.FailureOrder = f.FailureOrder;
                            else
                                Fcodes.FailureOrder = '';
                            DataAreaobj.FailCode.add(Fcodes);

                            if(f.ClaimType != null && f.ClaimType != '')
                                DataAreaobj.ClaimType = f.ClaimType;
                            else
                                DataAreaobj.ClaimType = '';

                            if(c.partsWrapper != null && c.partsWrapper.size() > 0){
                                for(partsWrapperClass p : c.partsWrapper){
                                    CG_ClaimsInbound_SubmitToBMS_Req.Parts Partobj =  new CG_ClaimsInbound_SubmitToBMS_Req.Parts();
                                    system.debug(f.failcode + ' == ' + p.failcode);
                                    string failcodeString = '';

                                    if(!string.isblank(p.failcode) && p.failcode.containsany('-')) //Added as part of the defect#180417
                                    {
                                        p.failcode=p.failcode.substringAfterLast('-');
                                    }
                                    if(f.failcode == p.failcode){
                                        Partobj.PartNumberService = p.PartNumber;
                                        Partobj.ProductCodeOEM = 'NA';//p.ProductCodeOEM;
                                        Partobj.Description = p.PartNumber;//p.partdescription;
                                        Partobj.PartQuantity = p.quantity;
                                        Partobj.UnitPrice = p.sellprice;
                                        if(p.sellprice != null && p.sellprice != '' && p.quantity != null && p.quantity != '')
                                            Partobj.ExtendedPrice = string.valueOf(decimal.valueOf(p.sellprice) * decimal.valueOf(p.quantity) );
                                        else
                                            Partobj.ExtendedPrice = '0.0';
                                        Partobj.PercentClaimed = p.percentReq;

                                        if(p.totalUSD == null || p.totalUSD == '')
                                            p.totalUSD = '0.0';
                                        totalPartsAmount += Decimal.valueOf(p.totalUSD);
                                        DataAreaobj.Parts.add(Partobj);
                                    }
                                }
                            }

                            if(c.otherClaimWrapper != null && c.otherClaimWrapper.size() > 0){
                                for(otherClaimWrapperClass o : c.otherClaimWrapper){
                                    CG_ClaimsInbound_SubmitToBMS_Req.OtherClaimables  OtherClaimableobj =  new CG_ClaimsInbound_SubmitToBMS_Req.OtherClaimables();
                                    system.debug(f.failcode + ' == ' + o.failcode);
                                    string failcodeString = '';

                                    if(!string.isblank(o.failcode) && o.failcode.containsany('-')) //Added as part of the defect#180417
                                    {
                                        o.failcode=o.failcode.substringAfterLast('-');
                                    }

                                    if(f.failcode == o.failcode){
                                        OtherClaimableobj.OCCreditType = 'OTHER';//o.OCCreditType;
                                        if(o.item != null && o.item != '' && o.item.length() > 25)
                                            OtherClaimableobj.MiscName = o.item.substring(0,24);
                                        else
                                            OtherClaimableobj.MiscName = o.item;//o.MiscName;
                                        string item = '';
                                        if(o.MiscDescription != null && o.MiscDescription != '')
                                            item = o.MiscDescription;
                                        else
                                            item = o.item;
                                        if(item != null && item != '' && item.length() > 25)
                                            OtherClaimableobj.MiscDescription = item.substring(0,24);
                                        else
                                            OtherClaimableobj.MiscDescription = item;
                                        OtherClaimableobj.MiscQuantity = o.MiscQuantity;
                                        OtherClaimableobj.MiscAmount = o.ClaimedAmount;//o.MiscAmount;

                                        if(o.ExpenseTtoal == null || o.ExpenseTtoal == '')
                                            o.ExpenseTtoal = '0.0';
                                        totalOCAmount += Decimal.valueOf(o.ExpenseTtoal);

                                        DataAreaobj.OtherClaimables.add(OtherClaimableobj);   
                                    }
                                }
                            }

                            if(c.SRTsWrapper!=null && c.SRTsWrapper.size()>0){
                                for(SRTsWrapperClass   s : c.SRTsWrapper){
                                    CG_ClaimsInbound_SubmitToBMS_Req.SRTs SRTobj =  new CG_ClaimsInbound_SubmitToBMS_Req.SRTs();
                                    if(f.failcode == s.failcode){
                                        if(s.srtcode != null && s.srtcode != '') {
                                            list<string> srtSplit = s.srtcode.split('-');
                                            system.debug('srtSplit**'+srtSplit);
                                            if(srtSplit != null){
                                                if(srtSplit[0] != null && srtSplit[0] != '')
                                                    SRTobj.SRTgroupnum = srtSplit[0];
                                                else
                                                    SRTobj.SRTgroupnum = '';
                                                if(srtSplit[1] != null && srtSplit[1] != '')
                                                    SRTobj.Procedureno = srtSplit[1];
                                                else
                                                    SRTobj.Procedureno = '';
                                                if(srtSplit.size()>2){
                                                    if(srtSplit[2] != null && srtSplit[2] != '')
                                                        SRTobj.Stepnumber = srtSplit[2];
                                                }
                                                else
                                                    SRTobj.Stepnumber = '';
                                            }
                                        }

                                        //SRTobj. = s.Procedureno;
                                        //SRTobj. = s.Stepnumber;
                                        SRTobj.Accesscode = s.accesscode;
                                        SRTobj.PercentClaimed = s.percentReq;
                                        SRTobj.SRTquantity = s.quantity;
                                        SRTobj.SRTTime = s.srtTime;
                                        // if(claimsRec.CSS_Job__c != null && claimsRec.CSS_Job__c != ''){
                                        if(claimsRec.CSS_Job__c != null){
                                            if(claimsRec.CSS_Job__r.Repair_Location__c != null && claimsRec.CSS_Job__r.Repair_Location__c != '' && claimsRec.CSS_Job__r.Repair_Location__c == 'In Shop'){
                                                SRTobj.SRTLaborRate =  (claimsRec.CSS_Job__r.CSS_In_Shop_Labor_Rate__c != null && claimsRec.CSS_Job__r.CSS_In_Shop_Labor_Rate__c != '')?claimsRec.CSS_Job__r.CSS_In_Shop_Labor_Rate__c:'0.0';
                                            }else if(claimsRec.CSS_Job__r.Repair_Location__c != null && claimsRec.CSS_Job__r.Repair_Location__c != '' && claimsRec.CSS_Job__r.Repair_Location__c == 'Mobile'){
                                                SRTobj.SRTLaborRate = (claimsRec.CSS_Job__r.CSS_Field_Service_Labor_Rate__c != null && claimsRec.CSS_Job__r.CSS_Field_Service_Labor_Rate__c != '')?claimsRec.CSS_Job__r.CSS_Field_Service_Labor_Rate__c:'0.0';
                                            }else{
                                                SRTobj.SRTLaborRate = '0.0';
                                            }
                                        }else{
                                            if(claimsRec.Repair_Location__c != null && claimsRec.Repair_Location__c != '' && claimsRec.Repair_Location__c == 'In Shop'){
                                                SRTobj.SRTLaborRate =  (claimsRec.SP_INSHOP_LABOR_RATE__c != null && claimsRec.SP_INSHOP_LABOR_RATE__c != '')?claimsRec.SP_INSHOP_LABOR_RATE__c:'0.0';
                                            }else if(claimsRec.Repair_Location__c != null && claimsRec.Repair_Location__c != '' && claimsRec.Repair_Location__c == 'Mobile'){
                                                SRTobj.SRTLaborRate = (claimsRec.SP_FIELD_SERVICE_LABOR_RATE__c != null && claimsRec.SP_FIELD_SERVICE_LABOR_RATE__c != '')?claimsRec.SP_FIELD_SERVICE_LABOR_RATE__c:'0.0';
                                            }else{
                                                SRTobj.SRTLaborRate = '0.0';
                                            }
                                        }  
                                        //SRTobj.SRTLaborRate = s.SRTLaborRate; Commeted by Rajesh Narra on 7-11-2018
                                        SRTobj.ExtendedAmount = s.ExtendedAmount;
                                        SRTobj.ServiceModelName = s.ServiceModelName;
                                        SRTobj.AdjustmentReason = s.AdjustmentReason;
                                        if(s.SRTAmount == null || s.SRTAmount == '')
                                            s.SRTAmount = '0.0';
                                        totalSRTAmount += Decimal.valueOf(s.SRTAmount);

                                        DataAreaobj.SRTs.add(SRTobj);
                                    }
                                }
                            }
                            //Field Actions.
                            if(c.fieldActionSRTsWrapper!=null && c.fieldActionSRTsWrapper.size()>0){
                                for(fieldActionSRTsWrapperClass   s : c.fieldActionSRTsWrapper){
                                    CG_ClaimsInbound_SubmitToBMS_Req.SRTs SRTobj =  new CG_ClaimsInbound_SubmitToBMS_Req.SRTs();
                                    if(f.failcode == s.failcode){
                                        if(s.srtcode != null && s.srtcode != '') {
                                            list<string> srtSplit = s.srtcode.split('-');
                                            system.debug('srtSplit**'+srtSplit);
                                            if(srtSplit != null){
                                                if(srtSplit[0] != null && srtSplit[0] != '')
                                                    SRTobj.SRTgroupnum = srtSplit[0];
                                                else
                                                    SRTobj.SRTgroupnum = '';
                                                if(srtSplit[1] != null && srtSplit[1] != '')
                                                    SRTobj.Procedureno = srtSplit[1];
                                                else
                                                    SRTobj.Procedureno = '';
                                                if(srtSplit.size()>2){
                                                    if(srtSplit[2] != null && srtSplit[2] != '')
                                                        SRTobj.Stepnumber = srtSplit[2];
                                                }
                                                else
                                                    SRTobj.Stepnumber = '';
                                            }
                                        }

                                        //SRTobj. = s.Procedureno;
                                        //SRTobj. = s.Stepnumber;
                                        SRTobj.Accesscode = s.accesscode;
                                        SRTobj.PercentClaimed = s.percentReq;
                                        SRTobj.SRTquantity = s.quantity;
                                        SRTobj.SRTTime = s.srtTime;
                                        // if(claimsRec.CSS_Job__c != null && claimsRec.CSS_Job__c != ''){
                                        if(claimsRec.CSS_Job__c != null){
                                            if(claimsRec.CSS_Job__r.Repair_Location__c != null && claimsRec.CSS_Job__r.Repair_Location__c != '' && claimsRec.CSS_Job__r.Repair_Location__c == 'In Shop'){
                                                SRTobj.SRTLaborRate =  (claimsRec.CSS_Job__r.CSS_In_Shop_Labor_Rate__c != null && claimsRec.CSS_Job__r.CSS_In_Shop_Labor_Rate__c != '')?claimsRec.CSS_Job__r.CSS_In_Shop_Labor_Rate__c:'0.0';
                                            }else if(claimsRec.CSS_Job__r.Repair_Location__c != null && claimsRec.CSS_Job__r.Repair_Location__c != '' && claimsRec.CSS_Job__r.Repair_Location__c == 'Mobile'){
                                                SRTobj.SRTLaborRate = (claimsRec.CSS_Job__r.CSS_Field_Service_Labor_Rate__c != null && claimsRec.CSS_Job__r.CSS_Field_Service_Labor_Rate__c != '')?claimsRec.CSS_Job__r.CSS_Field_Service_Labor_Rate__c:'0.0';
                                            }else{
                                                SRTobj.SRTLaborRate = '0.0';
                                            }
                                        }else{
                                            if(claimsRec.Repair_Location__c != null && claimsRec.Repair_Location__c != '' && claimsRec.Repair_Location__c == 'In Shop'){
                                                SRTobj.SRTLaborRate =  (claimsRec.SP_INSHOP_LABOR_RATE__c != null && claimsRec.SP_INSHOP_LABOR_RATE__c != '')?claimsRec.SP_INSHOP_LABOR_RATE__c:'0.0';
                                            }else if(claimsRec.Repair_Location__c != null && claimsRec.Repair_Location__c != '' && claimsRec.Repair_Location__c == 'Mobile'){
                                                SRTobj.SRTLaborRate = (claimsRec.SP_FIELD_SERVICE_LABOR_RATE__c != null && claimsRec.SP_FIELD_SERVICE_LABOR_RATE__c != '')?claimsRec.SP_FIELD_SERVICE_LABOR_RATE__c:'0.0';
                                            }else{
                                                SRTobj.SRTLaborRate = '0.0';
                                            }
                                        }  
                                        //SRTobj.SRTLaborRate = s.SRTLaborRate; Commeted by Rajesh Narra on 7-11-2018
                                        SRTobj.ExtendedAmount = s.ExtendedAmount;
                                        SRTobj.ServiceModelName = s.ServiceModelName;
                                        SRTobj.AdjustmentReason = s.AdjustmentReason;
                                        if(s.SRTAmount == null || s.SRTAmount == '')
                                            s.SRTAmount = '0.0';
                                        totalSRTAmount += Decimal.valueOf(s.SRTAmount);

                                        DataAreaobj.SRTs.add(SRTobj);
                                    }
                                }
                            }

                            system.debug('c.TTMLWrapper**'+c.TTMLWrapper);
                            if(c.TTMLWrapper != null && c.TTMLWrapper.size()>0){
                                for(TTMLWrapperClass t : c.TTMLWrapper){
                                    CG_ClaimsInbound_SubmitToBMS_Req.TravelDetails TTMLobj =  new CG_ClaimsInbound_SubmitToBMS_Req.TravelDetails();
                                    system.debug(f.failcode + ' == ' + t.failcode);
                                    string failcodeString = '';

                                    if(!string.isblank(t.failcode) && t.failcode.containsany('-')) //Added as part of the defect#180417
                                    {
                                        t.failcode=t.failcode.substringAfterLast('-');
                                    }

                                    if(f.failcode == t.failcode){
                                        TTMLobj.TravelLaborHour = t.TravelLaborHour;
                                        TTMLobj.TravelRate = t.TravelRate;
                                        TTMLobj.TravelLaborAmount = t.TravelLaborAmount;
                                        TTMLobj.TravelDistance = t.TravelDistance;
                                        TTMLobj.TravelDistanceRate = t.TravelDistanceRate;
                                        TTMLobj.TravelMealAmount = t.TravelMealAmount;
                                        TTMLobj.TravelLodgingAmount = t.TravelLodgingAmount;

                                        if(t.expenseTotal == null || t.expenseTotal == '')
                                            t.expenseTotal = '0.0';

                                        if(t.type != null && t.type != '') {
                                            if(t.type == 'Towing')
                                                totalTowingAmount += Decimal.valueOf(t.expenseTotal);
                                            else
                                                totalTravelAmount += Decimal.valueOf(t.expenseTotal); 
                                        }
                                        system.debug('c.TTMLobj**'+TTMLobj);
                                        DataAreaobj.TravelDetails.add(TTMLobj);

                                    }
                                }
                            }

                            if(c.ListOfAdditionalESNs != null && c.ListOfAdditionalESNs.size() > 0){
                                for(AdditionalESNs a: c.ListOfAdditionalESNs){
                                    CG_ClaimsInbound_SubmitToBMS_Req.AdditionalESNs  AdditionalESNsobj =  new CG_ClaimsInbound_SubmitToBMS_Req.AdditionalESNs();
                                    AdditionalESNsobj.ESN = a.EngineSerialNumber;
                                    AdditionalESNsobj.ESNModel = a.ESNModel;
                                    AdditionalESNsobj.ApplicationCode = a.ApplicationCode;
                                    AdditionalESNsobj.DistanceType = a.DistanceType;
                                    AdditionalESNsobj.Hours = a.Hours;
                                    AdditionalESNsobj.FailureDate = a.FailureDate;
                                    AdditionalESNsobj.WarrantyStartDate = a.WarrantyStartDate;

                                    DataAreaobj.AdditionalESNs.add(AdditionalESNsobj);
                                }
                            }
                        }

                        if(c.ListOfNotes!=null && c.ListOfNotes.size()>0){
                            for(Notes n: c.ListOfNotes){
                                CG_ClaimsInbound_SubmitToBMS_Req.Notes Noteobj =  new CG_ClaimsInbound_SubmitToBMS_Req.Notes();
                                Noteobj.Notes =n.Note;
                                Noteobj.NoteType =n.NoteType;
                                DataAreaobj.Notes.add(Noteobj);  
                            }
                        }
                        //totalSRTAmount = 0.0;
                        totalclaimAmt = totalSRTAmount + totalPartsAmount + totalOCAmount + totalTowingAmount + totalTravelAmount;
                        system.debug('totalSRTAmount--- ' + totalSRTAmount + ' totalPartsAmount--- '+totalPartsAmount +' totalOCAmount--- ' + totalOCAmount +' totalTowingAmount--- ' + totalTowingAmount +' totalTravelAmount --- ' + totalTravelAmount);
                        system.debug(' totalclaimAmt ' + totalclaimAmt);
                        if(totalclaimAmt > 0)
                            DataAreaobj.TotalClaimAmount = string.valueOf(totalclaimAmt);
                        else
                            DataAreaobj.TotalClaimAmount = '0.0';

                        submitReq.Header =Headerobj;
                        submitReq.DataArea =DataAreaobj;
                        String requestbmsjsonvalue = JSON.serialize(submitReq);
                        system.debug('jsssssooonnn'+requestbmsjsonvalue);
                        if(subRecordMap!=null && subRecordMap.size()>0) {
                            sRecord.BMS_Claim_ReqJSON__c=requestbmsjsonvalue;
                        }

                        sRecord.Total_Claim_Amount__c = totalclaimAmt;
                        sRecord.Total_OC_Amount__c = totalOCAmount;
                        sRecord.Total_Parts_Amount__c = totalPartsAmount;
                        sRecord.Total_SRT_Amount__c = totalSRTAmount;
                        sRecord.Total_Towing_Amount__c = totalTowingAmount;
                        sRecord.Total_Travel_Amount__c = totalTravelAmount;
                        sRecord.Siebel_Claim_JSON__c = subRecordSiebelJSONMap.get(sRecord.Id);
                        //Added as part of the story # 161688
                        if(sRecord.Siebel_Claim_JSON__c != null && sRecord.Siebel_Claim_JSON__c != '')
                            sRecord.Siebel_Claim_JSON__c = sRecord.Siebel_Claim_JSON__c.replace('o.ClaimedAmount', string.valueof(totalOCAmount));

                        if(DataAreaobj.TotalClaimAmount == '0.0' && sRecord.Siebel_Claim_JSON__c != null && sRecord.Siebel_Claim_JSON__c != '') {
                            CG_ClaimsInbound_SubmitToSiebel_Req siebelClaim = (CG_ClaimsInbound_SubmitToSiebel_Req)JSON.deserializeStrict(sRecord.Siebel_Claim_JSON__c, CG_ClaimsInbound_SubmitToSiebel_Req.class);
                            system.debug('Response Data'+siebelClaim);

                            CG_ClaimsInbound_SubmitToSiebel_Req.ListOfFailureList ListOfFailureListobj =  siebelClaim.DataArea.listOfFailureList;
                            list<CG_ClaimsInbound_SubmitToSiebel_Req.FailureList> failureList = new list<CG_ClaimsInbound_SubmitToSiebel_Req.FailureList>();
                            failureList = ListOfFailureListobj.FailureList;
                            for(CG_ClaimsInbound_SubmitToSiebel_Req.FailureList fl : failureList)
                                fl.PayCode = 'A';

                            system.debug('failureList >>>> ' + failureList);

                            CG_ClaimsInbound_SubmitToSiebel_Req.ListOfNotes ListOfNotesobj = siebelClaim.DataArea.ListOfNotes;
                            list<CG_ClaimsInbound_SubmitToSiebel_Req.Note> NoteList = new list<CG_ClaimsInbound_SubmitToSiebel_Req.Note>();
                            NoteList = ListOfNotesobj.Notes;
                            CG_ClaimsInbound_SubmitToSiebel_Req.Note sysNote = new CG_ClaimsInbound_SubmitToSiebel_Req.Note();
                            sysNote.Note ='Information Only Claim for related failures';
                            sysNote.NoteType = 'System Note';
                            NoteList.add(sysNote);
                            system.debug('NoteList >>>>> ' + NoteList);
                            system.debug('ListOfNotesobj >>>>> ' + ListOfNotesobj);
                            system.debug('siebelClaim >>>>> ' + siebelClaim);

                            String requestjsonvalue = JSON.serialize(siebelClaim);
                            system.debug('jsssssooonnn >>> '+requestjsonvalue);
                            //sRecord.Siebel_Claim_JSON__c=requestjsonvalue; //Commented since no need to update Siebel json in BMS Json method.

                            //Paycode as A to Update Failure level.
                            //list<CSS_Solution_Component__c> ZeroDollarSCList = new list<CSS_Solution_Component__c>();
                            if(c.failureWrapper!=null && c.failureWrapper.size()>0) {
                                for(failureWrapperClass f : c.failureWrapper) {
                                    CSS_Solution_Component__c ZeroDollarSC = new CSS_Solution_Component__c();
                                    ZeroDollarSC.Id = f.validationmessage;
                                    ZeroDollarSC.Pay_Code__c = 'A';
                                    ZeroDollarSCList.add(ZeroDollarSC);
                                }
                            }
                        }
                        lstbmssubmissionRecord.add(sRecord);

                    }

                }
            }
        } catch(Exception ex) {
            system.debug('in the exception of prepareBMSRequest - Method Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        } 
    }

    //Re-Open Claim button 
    public PageReference ReopenClaim(){
        try{
            List<CSS_Claim_Submission__c> deletesubRecord = new List<CSS_Claim_Submission__c>();
            deletesubRecord=[select id from CSS_Claim_Submission__c where CSS_Claims__c=:cId and Status__c = 'Submitted'] ;
            if(deletesubRecord.size()>0){
                delete deletesubRecord;
                claimsRec.Status__c='Draft';
                update claimsRec;
            }
        }
        catch(Exception ex) {
            system.debug('in the exception of ReopenClaim Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }  

        PageReference ReturnPage = new pageReference('/apex/CG_ClaimsVS?id='+cId);
        ReturnPage.setRedirect(true);
        return ReturnPage;
    } 

    //Naviagation to Customer Complaint Chevron On click of Edit link.
    public PageReference redirectToCC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsIntake'); 
        }else{
            saveClaimsVS();
            pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); 
        }
        return pageRef;
    }

    //Naviagation to ClaimsIntake.
    public PageReference nvClaimsIntake(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsIntake'); 
        }else{
            saveClaimsVS();
            pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); 

        }
        return pageRef;
    }

    //Naviagation to Warranty Coverage.
    public PageReference nvClaimsWC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsWarranty'); 
        }else{
            saveClaimsVS();
            pageRef = new pageReference('/apex/CG_ClaimsWarranty?id='+cId); 
        }
        return pageRef;
    }

    //Naviagation to View History.
    public PageReference nvClaimsVH(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVH'); 
        }else{
            saveClaimsVS();
            pageRef = new pageReference('/apex/CG_ClaimsVH?id='+cId); 


        }
        return pageRef;
    }

    //Naviagation to Customer Complaint.
    public PageReference nvClaimsCC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsCC'); 
        }else{

            //Kalpana Defect 154159 fix. Added below if condition
            if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                saveClaimsVS();
                pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId); }
            else{
                saveClaimsVS();
                pageRef = new pageReference('/apex/CG_ClaimsCC?id='+cId); }

            // pageRef = new pageReference('/apex/CG_ClaimsCC?id='+cId); 
        }
        return pageRef;
    }

    //Naviagation to Failures and Campaigns.
    public PageReference nvClaimsFC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsFC'); 
        }else{
            //Kalpana Defect 154159 fix. Added below if condition
            if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                saveClaimsVS();
                pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId); }
            else{
                saveClaimsVS();
                pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId); }

            // pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId); 
        }
        return pageRef;
    }

    //Added below Method as per Silicon Valley sprint #154239 -By RAJESH 20th Aug 2018 
    public PageReference nvClaimsPSN(){
        PageReference pageRef;       
        if(cId==null){            
            pageRef = new pageReference('/apex/CG_ClaimsMultiPSN'); 
        }else{
            if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){ 
                saveClaimsVS();
                pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId); }
            else{                
                saveClaimsVS();
                pageRef = new pageReference('/apex/CG_ClaimsMultiPSN?id='+cId); }
        }
        return pageRef;
    }

    //Naviagation to Parts and Other Claimbles.
    public PageReference nvClaimsPOC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles'); 
        }else{
            //Kalpana Defect 154159 fix. Added below if condition
            if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                saveClaimsVS();
                pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId); }
            else{
                saveClaimsVS();
                pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cId); }
            //pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cId);
        }
        return pageRef;
    }

    //Naviagation to SRTs.
    public PageReference nvClaimsSRTs(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsSRTs'); 
        }else{
            //Kalpana Defect 154159 fix. Added below if condition
            if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                saveClaimsVS();
                pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId); }
            else{
                saveClaimsVS();
                pageRef = new pageReference('/apex/CG_ClaimsSRTs?id='+cId); }
            //pageRef = new pageReference('/apex/CG_ClaimsSRTs?id='+cId); 
        }
        return pageRef;
    }

    //Naviagation to Job Notes.
    public PageReference nvClaimsJobNotes(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsJobNotes'); 
        }else{
            saveClaimsVS();
            pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId); 
            //pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId);
        }
        return pageRef;
    }

    //Naviagation to Verify and Submit
    public PageReference nvClaimsVS(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVS'); 
        }else{
            saveClaimsVS();
            pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId); 
        }
        pageRef.setRedirect(true);
        return pageRef;
    }

    public void CampaignsWSCall(){
        // calling FieldAction WebService in case of failure response on chevron navigation
        if(claimsRec.FieldActionWebServiceResult__c == 'Error'){
            string FailureDateString;
            if(psnRec.Failure_Date__c != null){
                FailureDateString = DateTime.newInstance(psnRec.Failure_Date__c.year(),psnRec.Failure_Date__c.month(),psnRec.Failure_Date__c.day()).format('dd-MMM-YY');
            }
            claimsRec.FieldActionWebServiceResult__c = CG_BL_Campaigns.callGetCampaignsWebServiceforClaimsOnChevronChangeClaim(psnRec.PSN__c, FailureDateString, claimsRec.Region__c,'', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', psnRec.CSS_Claims__c);
    claimsRec.Id = cId;
    if(claimsRec.Id != null){
        update claimsRec; 
    }
       }
    }

    //Page Actions.
    public boolean isSRTFailAccCodeError = false;
     public List<CSS_SRT__C> ListSrt;
    public void verifySubmitpgAction() {
        try {
            if(cId != null && claimSubMap != null) {
                if(claimSubMap.size() == 0) {
                     //GSSC-330
                    ListSrt = [SELECT Id, Name,type__c,srt_id__c,CSS_Claims__c,Account_Code__c,FailCode__c,Fail_Code_Description__c,SRT_AccessiblityCheck__c,isPerformed__c,AccountCode_Formula__c 
                                FROM CSS_SRT__c 
                                WHERE CSS_Claims__c =: cId AND (Account_Code__c = null OR AccountCode_Formula__c = null) 
                                AND (FailCode__c = null OR Fail_Code_Description__c = null) 
                                AND type__c != 'Overlap' and type__c != '99Time' and ((isperformed__c = true and type__c in ('Diagnosis','Repair','Field Action','Admin','Access')) or (SRT_AccessiblityCheck__c = true and type__c in ('Diag Access','Repair Access','Field Action Access')))
                                ];
                     if(ListSrt != null && ListSrt.size()>0)
                     isSRTFailAccCodeError = true;
                    updateClaimRecord();
                    updateSRTforPenalty();
                    system.debug('lstClaimWrapper**'+lstClaimWrapper);
                    system.debug('lstSRTsWrapperClass**'+lstSRTsWrapperClass);
                    system.debug('lstfieldActionSRTsWrapper**'+lstfieldActionSRTsWrapper);
                    fetchClaimRelatedRecords();
                    displayEditfunctioanity();
                    system.debug('displayEdit-->'+displayEdit);

                    //userType=css_utility.getOrgType(claimsRec.CreatedById);   //Commented based on defect #190604
                    //system.debug(userType);
                    system.debug('*****pendingAuthFlag***'+pendingAuthFlag);
                    assignWarrantyAuthFlag();
                    system.debug('dispSubmitButton**'+dispSubmitButton);

                    fetchAccountFailCodeCombo();
                    checkQuantity();
                    promotionIdLst = getTechPromotionId();
                    system.debug('promotionIdLst--->'+promotionIdLst);
                    getTechPromotionId_TTML();
                    getOverlapSRTMap();
                    addESNObj = getAdditionalESNsdetails();
                    checkaccountcodeCoverage();//GSSC-246 - By Krishna
                    failcodeEQErrorFlag(); // moved the method calling up, GSSC-514
                    generateClaimSubmissionRecords();
                    populateLeastFailureSequenceAsPrimary();
                    system.debug('dispSubmitButton**'+dispSubmitButton);
                    //showsubmitButton = true; //Testing
                    pendingAuthrizationFlag();
                    //failcodeEQErrorFlag(); // Commented and moved the method calling up, GSSC-514
                    //checkaccountcodeCoverage();//GSSC-246 - By Krishna
                    showsubmitButton = showSubmitbtn();
                    //showsubmitButton = true;
                    showReopenButton = showReOpenbtn();
                    controllerRef=this;
                } else if(claimSubMap.size() > 0) {
                    displayEditfunctioanity();
                    getMultiPSN();
                    integer submittedclaim = 0;
                    for(CSS_Claim_Submission__c csscs : claimSubMap.values()) {
                        if(csscs.Status__c == 'Submitted')
                            submittedclaim +=1;
                    }

                    lstclaimWrapper= new List<claimWrapperClass>();
                    //Map<string, list<note>> ClaimSubNotesMap = new Map<Id, list<note>>();
                    claimSubWithNotes = new Map<String, List<ClaimNotes>>();
                    list<Note> notesAllList = [SELECT Id,Body,title,parentId, CreatedBy.firstname, CreatedDate, CreatedBy.lastname, LastModifiedDate,CreatedById 
                                            FROM Note WHERE parentId IN :claimSubMap.keySet() 
                                            order by CreatedDate DESC];
                    
                    for(Note notesAll : notesAllList) {
                        String indivisualClaimId = claimSubMap.get(notesAll.parentId).Individual_Claim_Id__c;
                        ClaimNotes temp  = new ClaimNotes();
                        
                         if(notesAll.Body != null && notesAll.title != null){
                            if(notesAll.title.contains('Service Provider Response')){
                                
                                temp.noteBody = notesAll.Body;
                                temp.noteTitle =  notesAll.Title;
                                temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(notesAll.CreatedDate));
                                
                            } else if(notesAll.title.contains('Adjudicator') && notesAll.Body.contains(';;')) {
                                
                                string[] lstStr = notesAll.Body.split(';;');
                                if(lstStr != null && lstStr.size() > 0 && lstStr[3]!= null && lstStr[3]!= '')
                                    temp.noteBody = lstStr[3];
                                 temp.noteTitle =  notesAll.Title;
                                temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(lstStr[1]));
                            }
                         }
                        
                        
                        if(claimSubWithNotes.containsKey(indivisualClaimId)){
                            List<ClaimNotes> claimnoteslist = claimSubWithNotes.get(indivisualClaimId);
                            if(claimnoteslist != null && claimnoteslist.size() <6)
                                claimnoteslist.add(temp);
                            claimSubWithNotes.put(indivisualClaimId, claimnoteslist);
                        } else {
                            claimSubWithNotes.put(indivisualClaimId, new List<ClaimNotes> { temp });
                        }
                    }
                    
                    /*
                    //Start(1) - Added below code as part of the defect # 191336
                    claimSubWithNotes = new Map<String, List<ClaimNotes>>();
                    for(Note notes: [SELECT Id,Body,title,parentId, CreatedBy.firstname, CreatedDate,
                                     CreatedBy.lastname, LastModifiedDate,CreatedById 
                                     FROM Note WHERE parentId IN :claimSubMap.keySet() 
                                     order by CreatedDate DESC]){
                        system.debug('>>>notessss<<<' + notes);                  
                        String indivisualClaimId = claimSubMap.get(notes.parentId).Individual_Claim_Id__c;
                        List<String> lstStr = new List<String>();
                        if(notes.Body != null){
                            
                            if(notes.title.contains('SP Update')){
                            if(!claimSubWithNotes.containsKey(indivisualClaimId)){
                                system.debug('**insideIfap2**');
                                ClaimNotes temp  = new ClaimNotes();
                               
                                    temp.noteBody = notes.Body;
                                 temp.noteTitle =  notes.Title;
                                //temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(lstStr[1]));
                                temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(notes.CreatedDate));
                                claimSubWithNotes.put(indivisualClaimId,new List<ClaimNotes>{temp});      
                            } 
                            else{
                                system.debug('**insideIfap3**');
                                ClaimNotes temp  = new ClaimNotes();
                                temp.noteBody = notes.Body;
                                 temp.noteTitle =  notes.Title;
                               // temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(lstStr[1]));
                                temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(notes.CreatedDate));
                                claimSubWithNotes.get(indivisualClaimId).add(temp);
                            } 
                                
                            }
                            
                            
                            
                             if(notes.title.contains('Adjudicator')){
                            if(notes.Body.contains(';;'))
                            lstStr = notes.Body.split(';;');
                            system.debug('Karthik' + lstStr);
                            if(!claimSubWithNotes.containsKey(indivisualClaimId)){
                                system.debug('**insideIf2**');
                                ClaimNotes temp  = new ClaimNotes();
                                if(lstStr[3]!= null && lstStr[3]!= '')
                                    temp.noteBody = lstStr[3];
                                 temp.noteTitle =  notes.Title;
                                temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(lstStr[1]));
                                claimSubWithNotes.put(indivisualClaimId,new List<ClaimNotes>{temp});      
                            } 
                            else{
                                system.debug('**insideIf3**');
                                ClaimNotes temp  = new ClaimNotes();
                                temp.noteBody = lstStr[3];
                                 temp.noteTitle =  notes.Title;
                                temp.lastSaveDate = css_utility.getFormattedDate(dateTime.valueof(lstStr[1]));
                                claimSubWithNotes.get(indivisualClaimId).add(temp);
                            }
                        }
                        }
                    }
                    */
                    //End(1) - Added below code as part of the defect # 191336
                    for(CSS_Claim_Submission__c csscs : claimSubMap.values()) {
                        try {
                            claimWrapperClass cwc = (claimWrapperClass) JSON.deserializeStrict(csscs.Claim_JSON__c, claimWrapperClass.class); //converting long text area
                            cwc.status = csscs.Status__c;
                            if(csscs.status__c == 'Pending Authorization')
                                cwc.showEditLink = true;
                            else
                            cwc.showEditLink = false;
                            //Start(2) - Added below code as part of the defect # 191336
                            List<Notes> lstnote = new  List<Notes>();
                            if(claimSubWithNotes!=null && claimSubWithNotes.containsKey(csscs.Individual_Claim_Id__c)){
                                cwc.claimSubNotes =  claimSubWithNotes.get(csscs.Individual_Claim_Id__c); 
                            }
                            /*else 
                                cwc.claimSubNotes = null;
                            if(claimSubWithNotes!=null && claimSubWithNotes.containsKey(csscs.Individual_Claim_Id__c) ){
                                for( ClaimNotes no :  claimSubWithNotes.get(csscs.Individual_Claim_Id__c)){
                                    Notes n =new Notes();
                                    n.Note=no.Notes.body;
                                    n.NoteType=no.Notes.title;
                                    lstnote.add(n);
                                }
                                
                            }*/
                            //GSSC-138-start
                            if(userinfo.getDefaultCurrency() != 'USD'){
                                if(cwc.otherClaimWrapper != null){
                                    for(otherClaimWrapperClass ocWrapper : cwc.otherClaimWrapper){
                                        ocWrapper.amount = string.valueof(decimal.valueof(ocWrapper.amount) * exchangeRate);
                                    }
                                }
                                if(cwc.TTMLWrapper != null){
                                    for(TTMLWrapperClass ttmlWrapper : cwc.TTMLWrapper){
                                        ttmlWrapper.expenseTotal = string.valueof(decimal.valueof(ttmlWrapper.expenseTotal) * exchangeRate);
                                    }
                                }
                                if(cwc.partsWrapper != null){
                                    for(partsWrapperClass partWrapper : cwc.partsWrapper){
                                        system.debug('************partWrapper1-->'+partWrapper);
                                        partWrapper.sellprice = string.valueof(decimal.valueof(partWrapper.sellprice) * exchangeRate);
                                        partWrapper.totalUSD = string.valueof(decimal.valueof(partWrapper.totalUSD) * exchangeRate);
                                        partWrapper.sellprice = (partWrapper.sellprice != null && partWrapper.sellprice != '') ? (string.valueof(decimal.valueof(partWrapper.sellprice).setscale(2))) : '0.00';
                                        partWrapper.totalUSD = (partWrapper.totalUSD != null && partWrapper.totalUSD != '') ? (string.valueof(decimal.valueof(partWrapper.totalUSD).setscale(2))) : '0.00';
                                        system.debug('************partWrapper-->'+partWrapper);
                                    }
                                }
                            }
                            //GSSC-138 end
                            system.debug('lstTTMLWrapperClass1**'+lstTTMLWrapperClass);
                            system.debug('lstfailureWrapper**'+lstfailureWrapper);
                            cwc.ListOfNotes=lstnote;
                            //End(2) - Added below code as part of the defect # 191336
                            lstclaimWrapper.add(cwc);
                        } catch(Exception e)  {
                            system.debug('EXCEPTION of CG_CL_ClaimsVS claimWrapperClass >>> '+e.getMessage() + ' LINE NO: ' + e.getLineNumber() + ' ' +e.getCause());
                        }
                    }
                    system.debug('lstclaimWrapper. '+ lstclaimWrapper);
                    if(claimSubMap.size() == submittedclaim) {
                        system.debug('submitted but not processed.');
                        //submitted but not processed.
                        showsubmitButton = false;
                        showReopenButton = true;
                        controllerRef=this;
                    } else {
                        system.debug('submitted and processed.');
                        //submitted and processed.
                        showsubmitButton = false;
                        showReopenButton = false;
                        controllerRef=this;
                    }
                }
            }
            
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsVS verifySubmitpgAction >>> '+e.getMessage() + ' LINE NO: ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }

    public void updateClaimRecord() {
        try {
            CSS_Claims__c claimPageActionRec = new CSS_Claims__c();
            claimPageActionRec.Id = cId;
            claimPageActionRec.User_Landed_CC__c = true;
            update claimPageActionRec;
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsVS updateClaimRecord >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }

    public void updateSRTforPenalty() {
        try {
            //Story 155910 START
            List<Css_Srt__C> srtList = new List<CSS_SRT__c>([Select id,Step_Id__c,SRT_ID__c,SRT_Title__c,OverrideReason__c,Override__c,Overlap__c,SRT_Notes__c,SRT_Quantity__c
                                                             ,Diag_Access_Time__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Access_Calculated__c,SRT_Category__c, Extended_Hours__c, SRT_Time__c, 
                                                             Calculated_Claimed_Hours__c, SRT_Warrantable__c,SRT_Time_Formula__c,Account_Code_Description__c,isUserEntered__c,
                                                             Job_Order__c, Type__c, FailCode__c, isPerformed__c, SRT_AccessiblityCheck__c, Account_Code__c, CSS_Claims__r.AccessCode__c, CSS_Claims__r.Name from css_srt__c where CSS_Claims__c =:cId and SRT_ID__c !=null and SRT_ID__c !='0' ]);
            System.debug('srtList=======>'+srtList);
            if(claimsRec !=null && claimsRec.id !=null && claimsRec.Information_Only_Claim__c==false){
                List<CSS_JobEventTemporary__c> jobEventTemp1 = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' and Attribute1__c = 'POL'];
                Set<String> accSet = new Set<String>();
                List<css_Srt__c> srtpercentReqList = new List<css_Srt__c>();
                for(CSS_JobEventTemporary__c JET: jobEventTemp1){
                    accSet.add(JET.Attribute2__c+' '+JET.Attribute3__c);
                }
                system.debug('accSet**'+accSet);
                //Story 180325
                List<CSS_JobEventTemporary__c> jobEventTempPW = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' and Attribute1__c IN ('NPW','RPW')];
                Set<String> accSetPW = new Set<String>();
                Map<string,string> pwPenaltyMap = new Map<string,string>();
                Map<string,string> pwPenaltyAccCodeMap = new Map<string,string>();
                Map<string,string> solCompCoverageMap = new Map<string,string>();
                Map<string,string> solCompCoverageMapforFA = new Map<string,string>();
                Map<string,string> solCompAccCodeCoverageMap = new Map<string,string>();
                Map<string,string> solCompAccCodeCoverageMapforFA = new Map<string,string>();
                string failurePenalty;
                if(jobEventTempPW != null && jobEventTempPW.size()>0){
                    for(CSS_JobEventTemporary__c JET: jobEventTempPW){
                        accSetPW.add(JET.Attribute2__c+' '+JET.Attribute3__c);
                    }
                }
                system.debug('accSetPW**'+accSetPW);
                List<CSS_Solution_Component__c> solCompList = [select id,Type__c,fail_code__c,FailCode_Formula__c,ODM_Penalty__c,CSS_Account_Formula__c,CoveredLaborHrs__c,CampaignLaborPercentage__c from css_solution_component__C where css_claims__c = :cId];
            for(CSS_Solution_Component__c sc:solCompList){
                if(sc.type__c == 'Campaign' || sc.type__c == 'TRP' || sc.type__c == 'ATC')
                {
                    solCompCoverageMapforFA.put(sc.fail_code__c+sc.CSS_Account_Formula__c,sc.CampaignLaborPercentage__c);
                    solCompAccCodeCoverageMapforFA.put(sc.CSS_Account_Formula__c,sc.CampaignLaborPercentage__c);
                }else{
                    solCompCoverageMap.put(sc.fail_code__c+sc.CSS_Account_Formula__c,sc.CoveredLaborHrs__c);
                    solCompAccCodeCoverageMap.put(sc.CSS_Account_Formula__c,sc.CoveredLaborHrs__c);
                }
                if(sc.ODM_Penalty__c != null && sc.ODM_Penalty__c != '' && integer.valueof(sc.ODM_Penalty__c) > 0 && (sc.CSS_Account_Formula__c != null && sc.CSS_Account_Formula__c != '') && accSetPW.contains(sc.CSS_Account_Formula__c.trim())){
                    pwPenaltyMap.put(sc.fail_code__c.trim()+sc.CSS_Account_Formula__c.trim(),sc.ODM_Penalty__c);
                    pwPenaltyAccCodeMap.put(sc.CSS_Account_Formula__c.trim(),sc.ODM_Penalty__c);
                }
            }
            system.debug('pwPenaltyMap**'+pwPenaltyMap);
            system.debug('solCompCoverageMap**'+solCompCoverageMap);
            system.debug('solCompCoverageMapforFA**'+solCompCoverageMapforFA);
            string[] fcSplit;
            string failcode;
            if(srtList != null && !srtList.isEmpty()){
                for(css_srt__c srt:srtList){
                    if(srt.Type__c == '99Time')
                        srt.Account_Code__c = srt.Account_Code_Description__c;
                    system.debug('AccountCode**'+srt.Account_Code__c);
                    system.debug('srtID**'+srt.SRT_ID__c);
                    if(srt.failcode__c != null && srt.failcode__c != '' && srt.failcode__c.contains('-')){
                        fcSplit = srt.failcode__c.split('-'); //srt.failcode__c.RIGHT(4);
                        system.debug('fcSplit**'+fcSplit);
                        if(fcSplit != null && fcSplit.size()>0)
                            failcode = fcSplit[1];//why updating existing SRT failcode with split value???
                    }
                    else
                        failcode = srt.failcode__c;
                        
                    if(pwPenaltyMap != null && pwPenaltyMap.size() > 0 && (failcode != null && failcode != '') && pwPenaltyMap.get(failcode.trim()+srt.Account_Code__c.trim()) != null && pwPenaltyMap.get(failcode.trim()+srt.Account_Code__c.trim()) != '' && (srt.Account_Code__c != null && srt.Account_Code__c != '') && accSetPW.contains(srt.Account_Code__c.trim())){    
                        system.debug('Inside If1**');
                        if(failcode != null && failcode != '')
                            failurePenalty = pwPenaltyMap.get(failcode.trim()+srt.Account_Code__c.trim());
                        else
                            failurePenalty = pwPenaltyAccCodeMap.get(srt.Account_Code__c.trim());
                        system.debug('pwPenaltyMap11**'+pwPenaltyMap);
                        system.debug('failurePenalty**'+failurePenalty);
                        system.debug('srt.SRT_Warrantable__c**'+srt.SRT_Warrantable__c);
                        if(failurePenalty != null && failurePenalty != '' && (((srt.SRT_Warrantable__c != null && srt.SRT_Warrantable__c != '') && integer.valueof(srt.SRT_Warrantable__c)>=integer.valueof(failurePenalty)) || (srt.SRT_Warrantable__c == null || srt.SRT_Warrantable__c == '' || srt.SRT_Warrantable__c == '0'))){
                            srt.SRT_Warrantable__c = failurePenalty;
                            system.debug('InsideFailurePenalty**');
                            srtpercentReqList.add(srt);
                        }
                    }
                    else if(claimsRec.ODM_Penalty__c != null && claimsRec.ODM_Penalty__c != '' && integer.valueof(claimsRec.ODM_Penalty__c) > 0 && srt.Account_Code__c != null && srt.Account_Code__c != '' && !accSetPW.contains(srt.Account_Code__c.trim()) && !accSet.contains(srt.Account_Code__c.trim())){
                        if(srt.Account_Code__c != null && srt.Account_Code__c != '' && accSet.contains(srt.Account_Code__c.trim())){
                            system.debug('Inside If2**');
                            if(srt.SRT_Warrantable__c != null && srt.SRT_Warrantable__c != '' && integer.valueof(srt.SRT_Warrantable__c)>=100){
                                srt.SRT_Warrantable__c = string.valueof(100);
                                srtpercentReqList.add(srt);
                            }
                        }
                        else{ 
                            system.debug('Inside ELSE**'+srt.SRT_Warrantable__c);
                            system.debug('Inside ELSE1**'+srt.isUserEntered__c);
                            if(srt.Account_Code__c == null || srt.Account_Code__c == ''){
                                srt.SRT_Warrantable__c = '0';
                                srtpercentReqList.add(srt);
                            }
                            else{
                                system.debug('Inside ELSE2**'+srt.Type__c+':'+srt.isPerformed__c);
                                if(srt.isUserEntered__c == false){
                                    srt.SRT_Warrantable__c = claimsRec.ODM_Penalty__c;
                                    srtpercentReqList.add(srt);
                                }
                                else if(srt.isUserEntered__c == true){
                                    if((srt.SRT_Warrantable__c == null || srt.SRT_Warrantable__c == '' || srt.SRT_Warrantable__c == '0') || (srt.SRT_Warrantable__c != null && srt.SRT_Warrantable__c != '' && integer.valueof(srt.SRT_Warrantable__c)>integer.valueof(claimsRec.ODM_Penalty__c))){
                                        system.debug('InsideAccCode**'+srt.Account_Code__c+''+'SRT_ID__c**'+srt.SRT_ID__c);

                                        srt.SRT_Warrantable__c = claimsRec.ODM_Penalty__c;
                                        srt.isUserEntered__c = false;
                                        srtpercentReqList.add(srt);
                                    }
                                }
                            }
                        }
                    }
                    else if((srt.Account_Code__c != null && srt.Account_Code__c != '') && ((solCompCoverageMap != null && solCompCoverageMap.size()>0) || (solCompCoverageMapforFA != null && solCompCoverageMapforFA.size()>0)) && !accSet.contains(srt.Account_Code__c.trim())){        
                        system.debug('Inside If**'+solCompCoverageMap.get(failcode+srt.Account_Code__c));
                        system.debug('kalpanasrtwarrantable**'+srt.SRT_Warrantable__c);
                        if(srt.FailCode__c != null && srt.FailCode__c != null){
                            if((solCompCoverageMap.get(failcode+srt.Account_Code__c)!= null && solCompCoverageMap.get(failcode+srt.Account_Code__c) != '' && integer.valueof(solCompCoverageMap.get(failcode+srt.Account_Code__c))>0) || (solCompCoverageMapforFA.get(failcode+srt.Account_Code__c) != null && solCompCoverageMapforFA.get(failcode+srt.Account_Code__c) != '' && integer.valueof(solCompCoverageMapforFA.get(failcode+srt.Account_Code__c))>0)){
                               // if(srt.isUserEntered__c == false){
                                if(srt.isUserEntered__c == false && srt.type__c != 'Admin' && claimsRec.Multi_PSN_Claim__c != true){
                                    system.debug('isnideUserEntered**'+srt.isUserEntered__c);
                                    srt.SRT_Warrantable__c = '100';
                                    srtpercentReqList.add(srt);
                                }
                            }
                            else{ //if(integer.valueof( loop else
                                system.debug('Inside If Else**');
                                srt.SRT_Warrantable__c = '0';
                                srtpercentReqList.add(srt);
                            }
                        }
                        else // Else for...if(srt.FailCode__c != null && srt.FailCode__c != null)
                        {
                            if((solCompAccCodeCoverageMap.get(srt.Account_Code__c)!= null && solCompAccCodeCoverageMap.get(srt.Account_Code__c) != '' && integer.valueof(solCompAccCodeCoverageMap.get(srt.Account_Code__c))>0) || (solCompAccCodeCoverageMapforFA.get(srt.Account_Code__c) != null && solCompAccCodeCoverageMapforFA.get(srt.Account_Code__c) != '' && integer.valueof(solCompAccCodeCoverageMapforFA.get(srt.Account_Code__c))>0)){
                                //if(srt.isUserEntered__c == false){
                                if(srt.isUserEntered__c == false && srt.type__c != 'Admin' && claimsRec.Multi_PSN_Claim__c != true){
                                    system.debug('isnideUserEntered**'+srt.isUserEntered__c);
                                    srt.SRT_Warrantable__c = '100';
                                    srtpercentReqList.add(srt);
                                }
                            }
                            else{ //if(integer.valueof( loop else
                                srt.SRT_Warrantable__c = '0';
                                srtpercentReqList.add(srt);
                            }
                        }
                    }
                    else if((srt.Account_Code__c != null && srt.Account_Code__c != '') && !accSet.contains(srt.Account_Code__c.trim())){
                        
                        srt.SRT_Warrantable__c = '0';
                        srtpercentReqList.add(srt);
                    }
                }

                    if(srtpercentReqList != null && !srtpercentReqList.isEmpty())
                        update srtpercentReqList;
                    system.debug('srtpercentReqList**'+srtpercentReqList);
                }  
            }
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsVS updateSRTforPenalty >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }

    public void displayEditfunctioanity() {
        try {
            displayEdit = css_utility.getclaimsapprove(UserInfo.getUserId());
            system.debug('displayEdit-->'+displayEdit);
            if(displayEdit) {
                DealerTypeFlag = CSS_utility.getAccounttype(claimsRec.Account__r.Type);
                       
                if(claimsRec != null && DealerTypeFlag==true)
                    displayEdit = true;
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsVS displayEditfunctioanity >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }

    public void pendingAuthrizationFlag() {
        try {
            //(userType == 'DLR') {
                if(claimsRec.Pending_Authorization__c =='Authorization Required' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                    pendingAuthFlag = false;
                }
                else if(claimsRec.Pending_Authorization__c =='Authorized' || claimsRec.Pending_Authorization__c =='Not Applicable'){
                    pendingAuthFlag = true;
                }
            //} else {
                //if(warrantyAuthFlag != null && warrantyAuthFlag != '' && (warrantyAuthFlag.LEFT(1) =='G' || warrantyAuthFlag.LEFT(1) =='Y'))
                    //pendingAuthFlag = true;
                //else
                    //pendingAuthFlag = false;
            //}  
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsVS pendingAuthrizationFlag >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }

// story - GSSC-75
    public void failcodeEQErrorFlag() {
        try {
            // Code for Failcode EQ/WE: 
            List<CSS_Solution_Component__c> solcomps = new List<CSS_Solution_Component__c>();
            solComps = [select Id,Claim_FailCode__c,Name,Component_Id__c,Fail_Code__c,type__c,Selected_Component__c,AccountCode__c,CSS_Account_Formula__c
                        from CSS_Solution_Component__c where CSS_Claims__c =:claimsRec.id AND Selected_Component__c = true];// AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC')) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved'))];
            //story 173516, to skip Warranty AuthFlag Validation for InfoOnly Claims
            if(claimsRec.Information_Only_Claim__c==True && claimsRec.IsDealerCreatedClaim__c == True)
                FailcodeEQError = false;
            else{
                for(css_solution_component__c SC: solComps){
                    if(SC.Claim_FailCode__c!= null && SC.Claim_FailCode__c!= '' && (SC.Claim_FailCode__c.startsWith('EQ') ||  SC.Claim_FailCode__c.startsWith('WE'))){
                        {
                            if(psnRec.Calibration_After__c == null || psnRec.Calibration_Before__c == null || psnRec.Revision_Before__c == null || psnRec.Revision_After__c == null){
                                FailcodeEQError = true;
                            }
                            else{
                                FailcodeEQError = false;
                            }
                        }
                    }
                    if(SC.CSS_Account_Formula__c.contains('70')){
                        system.debug('****insideew70***');
                        accCodeSelected = '70';
                    }
                }
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsVS failcodeEQErrorFlag >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }
    
// story - GSSC-75    

    public void checkaccountcodeCoverage() {
        try {
            List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
            //accCodeCoverageType = new Map<String, String>(); 
            jobEventTemp = [SELECT Id, Attribute1__c, Attribute3__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' and Attribute1__c != null and Attribute3__c != null];
            if(jobEventTemp != null && jobEventTemp.size() > 0){
                for(CSS_JobEventTemporary__c jobET : jobEventTemp){
                accCodeCoverageType.put(jobET.Attribute3__c,jobET.Attribute1__c); //GSSC-246 - By Krishna
                }
            }
            //system.debug('accCodeCoverageType 246' + accCodeCoverageType);
            //system.debug('accCodeCoverageType 246' + accCodeCoverageType.keyset());
            //Story 155910 END
        }  catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsVS checkaccountcodeCoverage >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }

    public void populateLeastFailureSequenceAsPrimary(){
        Integer leastPrimaryFailure = 0;
        Boolean assignLeastSeqAsPrimary;
        map<Integer,failureWrapperClass> sequenceNumberFailureMap = new map<Integer,failureWrapperClass>();
        failureWrapperClass tempFailWrap = new failureWrapperClass('','','','','','','','','','','','','','','','','','','','','','','','','','','','','',null,'',null);
        for(claimWrapperClass clmWrap:lstclaimWrapper){
            sequenceNumberFailureMap = new map<Integer,failureWrapperClass>();
            assignLeastSeqAsPrimary = false;
            if(clmWrap.failureWrapper != null){
                leastPrimaryFailure = clmWrap.failureWrapper[0].sequenceNumber;
                system.debug('leastPrimaryFailure outside for'+leastPrimaryFailure);
            }
            for(failureWrapperClass failWrap:clmWrap.failureWrapper){
                if(failWrap.PrimaryFailureFlag == true){
                    assignLeastSeqAsPrimary = false;
                    assignPrimaryFailuretoNonSRT(clmWrap, failWrap);
                    break;
                }else{
                    assignLeastSeqAsPrimary = true;
                }
                sequenceNumberFailureMap.put(failWrap.sequenceNumber,failWrap);

                if(leastPrimaryFailure > failWrap.sequenceNumber){
                    system.debug('leastPrimaryFailure inside if before'+leastPrimaryFailure + failWrap.sequenceNumber);
                    leastPrimaryFailure = failWrap.sequenceNumber;
                    system.debug('leastPrimaryFailure inside if after'+leastPrimaryFailure + failWrap.sequenceNumber);
                }
            }

            if(assignLeastSeqAsPrimary == true){
                tempFailWrap = new failureWrapperClass('','','','','','','','','','','','','','','','','','','','','','','','','','','','','',null,'',null);
                tempFailWrap = sequenceNumberFailureMap.get(leastPrimaryFailure);
                system.debug('leastPrimaryFailure'+leastPrimaryFailure);
                tempFailWrap.PrimaryFailureFlag = true;
                system.debug('tempFailWrap'+tempFailWrap);
                assignPrimaryFailuretoNonSRT(clmWrap, tempFailWrap);
            }
        }
        system.debug('lstclaimWrapper>>>>>'+lstclaimWrapper);
    }

    //assign primary failure to Non SRT.
    public void assignPrimaryFailuretoNonSRT(claimWrapperClass cwc, failureWrapperClass fwc) {
        for(SRTsWrapperClass lsrtwc:cwc.SRTsWrapper){ 
            if(lsrtwc.srtcode == '99-999' && lsrtwc.srtDesc == 'Non-SRT Detail') {
                lsrtwc.failcode = fwc.failcode;
            }
        }
        system.debug('lstclaimWrapper>>>>>'+lstclaimWrapper);
    }

    //save primary flag based on user selection
    public void saveClaimsVS(){
        list<CSS_Solution_Component__c> solCompRec = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompTempRec;
        for(claimWrapperClass clmWrap:lstclaimWrapper){
            for(failureWrapperClass failWrap:clmWrap.failureWrapper){
                solCompTempRec = new CSS_Solution_Component__c();
                solCompTempRec.Id = failWrap.validationmessage;
                solCompTempRec.CSS_Primary_Failure__c = failWrap.PrimaryFailureFlag;
                solCompRec.add(solCompTempRec);
            }
        }
        CampaignsWSCall();
        update solCompRec;
    }

    //Added as part of the story #161025 to fetch technicians list and their respective promotion Ids
    public List<PromotionIds> getTechPromotionId(){
        List<Id> technicianList = new List<Id>();
        if(claimsRec.Assigned_To__c != null)// && claimsRec.Assigned_To__c != '')
            technicianList.add(claimsRec.Assigned_To__c);//technicianList[0] = claimsRec.Assigned_To__c;
        if(claimsRec.Additional_Tech1__c != null)// && claimsRec.Additional_Tech1__c != '')
            technicianList.add(claimsRec.Additional_Tech1__c);//technicianList[1] = claimsRec.Additional_Tech1__c;
        if(claimsRec.Additional_Tech2__c != null)// && claimsRec.Additional_Tech2__c != '')
            technicianList.add(claimsRec.Additional_Tech2__c);//technicianList[2] = claimsRec.Additional_Tech2__c;
        if(claimsRec.Additional_Tech3__c != null)// && claimsRec.Additional_Tech3__c != '')
            technicianList.add(claimsRec.Additional_Tech3__c);//technicianList[3] = claimsRec.Additional_Tech3__c;
        if(claimsRec.Additional_Tech4__c != null)// && claimsRec.Additional_Tech4__c != '')
            technicianList.add(claimsRec.Additional_Tech4__c);//technicianList[4] = claimsRec.Additional_Tech4__c;
        if(claimsRec.Additional_Tech5__c != null)// && claimsRec.Additional_Tech5__c != '')
            technicianList.add(claimsRec.Additional_Tech5__c);//technicianList[5] = claimsRec.Additional_Tech5__c;
        if(claimsRec.Additional_Tech6__c != null)// && claimsRec.Additional_Tech6__c != '')
            technicianList.add(claimsRec.Additional_Tech6__c);//technicianList[6] = claimsRec.Additional_Tech6__c;
        if(claimsRec.Additional_Tech7__c != null)// && claimsRec.Additional_Tech7__c != '')
            technicianList.add(claimsRec.Additional_Tech7__c);//technicianList[7] = claimsRec.Additional_Tech7__c;
        if(claimsRec.Additional_Tech8__c != null)// && claimsRec.Additional_Tech8__c != '')
            technicianList.add(claimsRec.Additional_Tech8__c);//technicianList[8] = claimsRec.Additional_Tech8__c;
        if(claimsRec.Additional_Tech9__c != null)// && claimsRec.Additional_Tech9__c != '')
            technicianList.add(claimsRec.Additional_Tech9__c);//technicianList[9] = claimsRec.Additional_Tech9__c;
        List<CSS_AccredUser__c> listAccredUser = new List<CSS_AccredUser__c>();
        listAccredUser = [SELECT Id, Promotion_Id__c FROM CSS_AccredUser__c WHERE User__c =: technicianList AND Service_Model_Name__c =: claimsRec.CSS_PSNs__r[0].Service_Model__c];
        Map<Id, String> techUserPromoId = new Map<Id, String>();
        for(CSS_AccredUser__c accredUser : listAccredUser){
            if(!techUserPromoId.containskey(accredUser.Id)){
                techUserPromoId.put(accredUser.Id,accredUser.Promotion_Id__c);
            }
        }
        List<PromotionIds> promoIdsList = new List<PromotionIds>();
        if(technicianList != null && technicianList.size() > 0){
            for(Id techList : technicianList){
                PromotionIds promId = new PromotionIds();
                if(techUserPromoId.containskey(techList))
                    promId.PromotionID = techUserPromoId.get(techList);
                else
                    promId.PromotionID = 'No Promotion Id';
                promoIdsList.add(promId);
            }
        }
        else{
            PromotionIds promId = new PromotionIds();
            promId.PromotionID = 'No Promotion Id';
            promoIdsList.add(promId);
        }
        return promoIdsList;
    }

    public String getCoverageType(String accountCode){
        if(accountCode != null && accountCode != '' && accCodeCoverageType != null)
            return accCodeCoverageType.get(accountCode);
        else
            return null;
    }

    //Added as part of the story #161688 to fetch technicians list and their respective promotion Ids for TTML parts
    public void getTechPromotionId_TTML(){
        List<Id> technicianList = new List<Id>();
        List<CSS_Parts_Options__c> ttmlParts = new List<CSS_Parts_Options__c>();
        List<String> userName = new List<String>();
        ttmlParts = [SELECT Id, Technician__c FROM CSS_Parts_Options__c WHERE CSS_Claims__c =: cId AND RecordType.Name = 'TTML' AND Technician__c != ''];
        for(CSS_Parts_Options__c parts : ttmlParts){
            userName.add(parts.Technician__c);
        }
        List<User> techUsers = new List<User>();
        techUsers = [SELECT Id FROM User WHERE Name =: userName];
        for(User u : techUsers){
            technicianList.add(u.Id);
        }
        List<CSS_AccredUser__c> listAccredUser = new List<CSS_AccredUser__c>();
        listAccredUser = [SELECT Id, Promotion_Id__c,First_Name__c,Last_Name__c FROM CSS_AccredUser__c WHERE User__c =: technicianList AND Service_Model_Name__c =: claimsRec.CSS_PSNs__r[0].Service_Model__c];

        for(CSS_AccredUser__c accredUser : listAccredUser){
            String uNAME = accredUser.First_Name__c + ' ' + accredUser.Last_Name__c;
            if(!techUserPromoIdTTML.containskey(uName)){
                techUserPromoIdTTML.put(uName,accredUser.Promotion_Id__c);
            }
        }
    }

    //Added as part of the story #161688 to send Justification under SRT List
    public void getOverlapSRTMap(){
        List<CSS_SRT__c> ovLap = new List<CSS_SRT__c>();
        overlapSRTListMap = new Map<String, list<CSS_SRT__c>>();
        ovLap = [SELECT Id, SRT_ID__c, Overlap_SRT_Number__c, Overlap_Hours__c, Override__c, Adjusted_Overlap_Hours__c, OverrideReason__c, Override_Reason__c FROM CSS_SRT__c WHERE CSS_Claims__c =: cId AND Type__c = 'Overlap'];  // and Override__c = true
        system.debug('ovLap --- ' + ovLap);
        if(ovLap != null && ovLap.size()>0){
            for(CSS_SRT__c overlap : ovLap){
                if(overlapSRT_Map != null && !overlapSRT_Map.containskey(overlap.SRT_ID__c) && overlap.Override__c){
                    overlapSRT_Map.put(overlap.SRT_ID__c,overlap);
                }
                if(overlap.SRT_ID__c != null && overlap.SRT_ID__c != '') {
                    if(overlapSRTListMap.containsKey(overlap.SRT_ID__c)) {
                        List<CSS_SRT__c> srtList = overlapSRTListMap.get(overlap.SRT_ID__c);
                        srtList.add(overlap);
                        overlapSRTListMap.put(overlap.SRT_ID__c, srtList);
                    } else {
                        overlapSRTListMap.put(overlap.SRT_ID__c, new List<CSS_SRT__c> { overlap });
                    }
                }
            }
        }
    }

    //Added as part of the story #161688 to fetch additional PSNs
    public List<AdditionalESNs> getAdditionalESNsdetails(){
        List<CSS_PSN__c> multiPSNlst = new List<CSS_PSN__c>();
        multiPSNlst = [SELECT Id, PSN__c, Warranty_Start_Date__c, Failure_Date__c, Before_In_Service__c, Failure_Point__c, Product_Hours__c,  Mileage_Measure__c, 
                       VIN__c, Calibration_After__c, Calibration_Before__c, Revision_Before__c, Revision_After__c
                       FROM CSS_PSN__c WHERE CSS_Claims__c =: cId AND Primary__c != true];
        List<AdditionalESNs> addESNlst = new List<AdditionalESNs>();
        for(CSS_PSN__c mPSN : multiPSNlst){
            addESNlst.add(new AdditionalESNs(mPSN.PSN__c,string.valueof(mPSN.Warranty_Start_Date__c),mPSN.Before_In_Service__c == true ? 'Y' : 'N',string.valueof(claimsRec.CSS_PSNs__r[0].Failure_Date__c),mPSN.Failure_Point__c,mPSN.Mileage_Measure__c,string.valueof(mPSN.Product_Hours__c),mPSN.VIN__c,mPSN.Calibration_After__c,mPSN.Calibration_Before__c,mPSN.Revision_Before__c,mPSN.Revision_After__c,'','','',''));
        }
        return addESNlst;        
    }
    
    
    //Method to identify multi PSN claim after submit
    public void getMultiPSN(){
        solCompsPSNCheck = [select Id, CSS_Account_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =:claimsRec.id AND Selected_Component__c = true AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC')) OR (Type__c IN ('Campaign','ATC', 'TRP') AND Status__c='Approved'))]; 
        
        for(css_solution_component__c SC: solCompsPSNCheck){
            if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                checkAccountCode=true;
            }
}
        if(claimsRec!=null && claimsRec.id!=null && checkAccountCode==true){
            if(claimsRec.Multi_PSN_Claim__c== true)
            {
                psncheck = true;
    }else{
                psncheck = false;
    }
        }
        else{
            psncheck = false;
        }
    }


    //Wrapper Classes.
    public class claimWrapperClass{
        public String accountcode {get;set;}
        public String claimid {get;set;}
        public String ServiceProviderCode {get;set;}
        public String DistributorCode {get;set;}
        public String EngineSerialNumber {get;set;}
        public String RONumber {get;set;}
        public String WarrantyStartDate {get;set;}
        public String EngineApplicationCode {get;set;}
        public String Manufacturer {get;set;}
        public String ModelSeries {get;set;}
        public String FirstName {get;set;}
        public String LastName {get;set;}
        public String BISFlag {get;set;}
        public String MultiESNFlg {get;set;}
        public String CampaignNumber {get;set;}
        public String InfoOnlyFlag {get;set;}
        public String NewPartsWarrantyFlg {get;set;}
        public String ReConPartsWarrantyFlg {get;set;}
        public String RoadRelayWarrantyFlg {get;set;}
        public String FailureDate {get;set;}
        public String FailurePoint {get;set;}
        public String FailureMeasure {get;set;}
        public String ProductHours {get;set;} //Added as per story GSSC-514
        public String MissionDisablingFlag {get;set;}
        public String CatastrophicFlag {get;set;}
        public String RepairDescription {get;set;}
        public String ReplacementPart {get;set;}
        public String SPCertifiedFlag {get;set;}
        public String WarrantyTrainedFlag {get;set;}
        public String CustomerPossession {get;set;}
        public String DISDNumber {get;set;}
        public String CustomerName {get;set;}
        public String ECMCalibAfter {get;set;}
        public String ReviewAfter {get;set;}
        public String ECMCalibBefore {get;set;}
        public String RevisionBefore {get;set;}
        public String Justification {get;set;}
        public String EngineVIN {get;set;}
        public String ESNCount {get;set;}
        public String TSRNumber {get;set;}
        public String UnitNumber {get;set;}
        public String PaccarFlag {get;set;}
        public String PenaltyFlag {get;set;}
        public String SRTPenaltyPercentage {get;set;}
        public String manualAdjudicationFlag {get;set;}
        public String DealerClaimNumber {get;set;}
        public String ClaimSource {get;set;}
        public String ClaimFiledDate {get;set;}
        public String SPInShopLaborRate {get;set;}
        public String SPLaborRate {get;set;}
        public String SPTravelRate {get;set;}
        public String Contact {get;set;}
        public list<ComplaintCodes> ListOfComplaintCodes {get;set;}
        public list<PromotionIds> ListOfPromotionIds {get;set;}
        public list<Notes> ListOfNotes {get;set;}
        public list<failureWrapperClass> failureWrapper {get;set;}
        public list<multiPSNWrapperClass> lstmultiPartWrapper{get;set;}
        public list<partsWrapperClass> partsWrapper {get;set;}
        public list<otherClaimWrapperClass> otherClaimWrapper {get;set;}
        public list<TTMLWrapperClass> TTMLWrapper {get;set;}
        public list<SRTsWrapperClass> SRTsWrapper {get;set;}
        public string SRTTime { get; set;}
        public list<fieldActionSRTsWrapperClass> fieldActionSRTsWrapper {get;set;}
        public string FASRTTime { get; set;}
        public string status {get;set;}
        public list<AdditionalESNs> ListOfAdditionalESNs {get;set;}
        //BMS batch Processing fields
        public string BranchCode {get;set;}
        public string ClaimType {get;set;}
        public string ClaimDate {get;set;}
        public string Owned {get;set;}
        public string SiebelClaimNumber {get;set;}
        public string GuidanzClaimNumber {get;set;}
        public string CSSJobID {get;set;}
        public string BMSReferenceNumber {get;set;}
        public string DealerCode {get;set;}
        public string CustomerCode {get;set;}
        public string PayCode {get;set;}
        public string LicencePlateState {get;set;}
        public string SubmittedBy {get;set;}
        public string TechActualHrs {get;set;}
        public string PolicyRequestID {get;set;}
        public string RMAFlag {get;set;} 
        public string AuthorizationNumber {get;set;}
        public string ApprovalCode {get;set;}
        public string PolicyRequestNumber {get;set;}
        public string FailureLocation {get;set;}
        public string CreateUser {get;set;}
        public string Severity {get;set;}
        public string SMN {get;set;}
        public string EngineFamily {get;set;}
        public string Make {get;set;}
        public string Model {get;set;}
        public string EquipmentConfiguration {get;set;}
        public string DistanceType {get;set;}
        public string Hours {get;set;}
        public string DealerApproval {get;set;}
        public string DistributorAuthorization {get;set;}
        public string MaterialDisposition {get;set;}
        public string TotalPartsAmount {get;set;}
        public string TotalLaborAmount {get;set;}
        public string TotalTravelAmount {get;set;}
        public string TotalOtherAmount {get;set;}
        public string PMU {get;set;}
        public string BFC {get;set;}
        public string Tax {get;set;}
        public string TotalClaimAmount {get;set;}
        public string Reference1 {get;set;}
        public string Reference2 {get;set;}
        public boolean showEditLink { get; set; }
        public string Reference3 {get;set;}
        public string TechnicianQualifiedFlag {get;set;}
        public List<ClaimNotes> claimSubNotes{get;set;}
        public string nonSRTtimeNotes {get;set;}
        public string OverlapNotes {get;set;}
        public string claimFAType {get;set;}
        public string claimFACampaignNumber {get;set;}

        public claimWrapperClass(){}
    }

    public class failureWrapperClass{
        public String failcode {get;set;}
        public String failureName {get;set;}
        public String validationmessage {get;set;}  //@ FailureSFDCID
        public String SystemCode {get;set;}
        public String ComponentCode {get;set;}
        public String FailMode {get;set;}
        public String AccountCode {get;set;}
        public String PayCode {get;set;}
        public String CertificateNumber {get;set;}
        public String CampaignNumber {get;set;}
        public String FaultCode {get;set;}
        public String WarrantyId {get;set;}
        public String ApproverCode {get;set;}
        public String CoverageType {get;set;}
        public String CoveredLaborHours {get;set;}
        public String CoveredMealsLodgingAmt {get;set;}
        public String CoveredOCAmount {get;set;}
        public String CoveredPartsQuantity {get;set;}
        public String CoveredTowingMiles {get;set;}
        public String CoveredTravelLabor {get;set;}
        public String CoveredTravelMiles {get;set;}
        public String DeductibleAmount {get;set;}
        public String AuthorizationNum {get;set;}
        public String CampaignLabourPrcnt {get;set;}
        public String CampaignOCPrcnt {get;set;}
        public String CampaignPartsPrcnt {get;set;}
        public String CampaignTowingPrcnt {get;set;}
        public String CampaignTravelPrcnt {get;set;}
        public String odmstatus{get;set;}
        //BMS batch Processing fields
        public String ProductGroup{get;set;}
        public String GroupCode{get;set;}
        public String FailLocation{get;set;}
        public String FailureOrder{get;set;}
        public string claimType {get;set;}
        public String SupportPlanID;
        public String Bank;
        public Boolean PrimaryFailureFlag {get;set;}
        public String failureType{get;set;}//Anirudh
        public Integer sequenceNumber;
        public String CustomerPossession {get;set;}
        public String PartsWarrantyStartDate {get;set;}
        public String FailureDate {get;set;}
        public String FailurePoint {get;set;}
        public String FailureMeasure {get;set;}

        public failureWrapperClass(String failcode,String failureName,String validationmessage,String SystemCode,String ComponentCode,String FailMode,String AccountCode,String PayCode,String CertificateNumber,String CampaignNumber,String FaultCode,String WarrantyId,String ApproverCode,String CoverageType,String CoveredLaborHours,String CoveredMealsLodgingAmt,String CoveredOCAmount,String CoveredPartsQuantity,String CoveredTowingMiles,String CoveredTravelLabor,String CoveredTravelMiles,String DeductibleAmount,String AuthorizationNum,String CampaignLabourPrcnt,String CampaignOCPrcnt,String CampaignPartsPrcnt,String CampaignTowingPrcnt,String CampaignTravelPrcnt,String odmstatus,Integer sequenceNumber,String claimType,boolean PrimaryFailureFlag) {//Anirudh commented String GroupCode and ProductGroup as these values were not being used
            this.failcode = failcode;
            this.failureName = failureName;
            this.validationmessage = validationmessage;
            this.SystemCode=SystemCode;
            this.ComponentCode=ComponentCode;
            this.FailMode=FailMode;
            this.AccountCode=AccountCode;
            this.PayCode=PayCode;
            this.CertificateNumber=CertificateNumber;
            this.CampaignNumber=CampaignNumber;
            this.FaultCode=FaultCode;
            this.WarrantyId=WarrantyId;
            this.ApproverCode=ApproverCode;
            this.CoverageType=CoverageType;
            this.CoveredLaborHours=CoveredLaborHours;
            this.CoveredMealsLodgingAmt=CoveredMealsLodgingAmt;
            this.CoveredOCAmount=CoveredOCAmount;
            this.CoveredPartsQuantity=CoveredPartsQuantity;
            this.CoveredTowingMiles=CoveredTowingMiles;
            this.CoveredTravelLabor=CoveredTravelLabor;
            this.CoveredTravelMiles=CoveredTravelMiles;
            this.DeductibleAmount=DeductibleAmount;
            this.AuthorizationNum=AuthorizationNum;
            this.CampaignLabourPrcnt=CampaignLabourPrcnt;
            this.CampaignOCPrcnt=CampaignOCPrcnt;
            this.CampaignPartsPrcnt=CampaignPartsPrcnt;
            this.CampaignTowingPrcnt=CampaignTowingPrcnt;
            this.CampaignTravelPrcnt=CampaignTravelPrcnt;
            this.odmstatus = odmstatus;
            this.ProductGroup = ProductGroup;
            //this.GroupCode = GroupCode;
            //this.FailLocation = FailLocation;
            this.claimType = claimType;
            this.PrimaryFailureFlag = PrimaryFailureFlag;//Anirudh
            this.sequenceNumber = sequenceNumber;
        }        
    }

    public class multiPSNWrapperClass{
        public String PSN {get;set;}
        public string FailureDate {get;set;}
        public String FailurePoint {get;set;}
        public string WarrantyStartDate {get;set;}
        public String VIN  {get;set;}
        public String CalibrationBefore {get;set;}
        public String RevisionBefore {get;set;}
        public String CalibrationAfter {get;set;}
        public String RevisionAfter {get;set;} 
        public String Milagemeasure {get;set;}

        public multiPSNWrapperClass(String PSN ,string FailureDate,String FailurePoint,string WarrantyStartDate,String VIN,String CalibrationBefore,String RevisionBefore,String CalibrationAfter,String RevisionAfter,string Milagemeasure){
            this.PSN = PSN;
            this.FailureDate = FailureDate;
            this.FailurePoint = FailurePoint;
            this.WarrantyStartDate = WarrantyStartDate;
            this.VIN =VIN ;
            this.CalibrationBefore = CalibrationBefore;
            this.RevisionBefore = RevisionBefore;
            this.CalibrationAfter = CalibrationAfter;
            this.RevisionAfter = RevisionAfter;
            this.Milagemeasure = Milagemeasure;
        }        
    }

    public class partsWrapperClass{
        public String failcode {get;set;}
        public String spn {get;set;}
        public String partdescription {get;set;}
        public String quantity {get;set;}
        public String percentReq {get;set;}
        public String sellprice {get;set;}
        public String totalUSD {get;set;}
        public String validationmessage {get;set;}
        public String PartNumber {get;set;}
        public String PricebookName {get;set;}
        public String ReplacementReason {get;set;}
        public String odmstatus {get;set;}
        //BMS batch Processing fields
        public String PartNumberService {get;set;}
        public String ProductCodeOEM {get;set;}
        public String UnitPrice {get;set;}
        public String ExtendedPrice {get;set;}
        public String PercentClaimed {get;set;}
        public String partsType;
        public String SupersededPart{get;set;}
        public String RIDNumber{get;set;}
        public String TrackingNumber{get;set;}
        public String PartsReturnFlag{get;set;}

        public partsWrapperClass(String failcode,String spn,String partdescription,String quantity,String percentReq,String sellprice,String totalUSD,String validationmessage, String PartNumber, String PricebookName, String ReplacementReason,String odmstatus,String PartNumberService,String ProductCodeOEM,String UnitPrice,String ExtendedPrice,String PercentClaimed,String partsType, string SupersededPart, string RIDNumber, string TrackingNumber, string PartsReturnFlag) {
            this.failcode = failcode;
            this.spn = spn;
            this.partdescription = partdescription;
            this.quantity = quantity;
            this.percentReq = percentReq;
            this.sellprice = sellprice;
            this.totalUSD = totalUSD;
            this.validationmessage = validationmessage;
            this.PartNumber=PartNumber;
            this.PricebookName=PricebookName;
            this.ReplacementReason=ReplacementReason;
            this.odmstatus = odmstatus; 
            this.PartNumberService = PartNumberService;
            this.ProductCodeOEM = ProductCodeOEM;
            this.UnitPrice = UnitPrice;
            this.ExtendedPrice = ExtendedPrice;
            this.PercentClaimed = PercentClaimed;
            this.partsType = partsType;
            this.SupersededPart = SupersededPart;
            this.RIDNumber = RIDNumber;
            this.TrackingNumber = TrackingNumber;
            this.PartsReturnFlag = PartsReturnFlag;
        }        
    }

    public class otherClaimWrapperClass{
        public String failcode {get;set;}
        public String item {get;set;}
        public String quantity {get;set;}
        public string amount {get;set;}//venkat
        public String percentReq {get;set;}
        public String validationmessage {get;set;}
        public String OtherClaimableDetails {get;set;}
        public String ClaimedReason {get;set;}
        public String ClaimedAmount {get;set;}
        public String odmstatus {get;set;}
        //BMS batch Processing fields
        public String OCCreditType {get;set;}
        public String MiscName {get;set;}
        public String MiscDescription {get;set;}
        public String MiscQuantity {get;set;}
        public String MiscAmount {get;set;}
        public String ExpenseTtoal {get;set;}

        public otherClaimWrapperClass(String failcode,String item,String quantity,string amount,String percentReq,String validationmessage,String OtherClaimableDetails,String ClaimedReason,String ClaimedAmount,String odmstatus,String OCCreditType,String MiscName,String MiscDescription,String MiscQuantity,String MiscAmount, string ExpenseTtoal) {
            this.failcode = failcode;
            this.item = item;
            this.quantity = quantity;
            this.amount = amount;//venkat
            this.percentReq = percentReq;
            this.validationmessage = validationmessage;
            this.OtherClaimableDetails=OtherClaimableDetails;
            this.ClaimedReason=ClaimedReason;
            this.ClaimedAmount=ClaimedAmount;
            this.odmstatus = odmstatus;
            this.OCCreditType = OCCreditType;
            this.MiscName = MiscName;
            this.MiscDescription = MiscDescription;
            this.MiscQuantity = MiscQuantity;
            this.MiscAmount = MiscAmount;
            this.ExpenseTtoal = ExpenseTtoal;

        }        
    }

    public class TTMLWrapperClass {
        public String failcode {get;set;}
        public String type {get;set;}
        public String Technician {get;set;}
        public String expenseTotal {get;set;}
        public String percentReq {get;set;}
        public String validationmessage {get;set;}
        public String odmstatus {get;set;}
        //BMS batch Processing fields
        public String TravelLaborHour {get;set;}
        public String TravelRate {get;set;}
        public String TravelLaborAmount {get;set;}
        public String TravelDistance {get;set;}
        public String TravelDistanceRate {get;set;}
        public String TravelMealAmount {get;set;}
        public String TravelLodgingAmount {get;set;}
        //Siebel batch processing fields
        public String TravelType {get;set;}
        public String TravelMode {get;set;}
        public String OtherModeDetails {get;set;}
        public String TechnicianPromotionId {get;set;}
        public String TechnicalWage {get;set;}
        public String BaseFare {get;set;}
        public String Hours {get;set;}
        public String Distance {get;set;}
        public String UOM {get;set;}
        public String MealsAmount {get;set;}
        public String LodgingAmount {get;set;}
        public String TowingAmount {get;set;}

        public TTMLWrapperClass(String failcode,String type,String Technician, String expenseTotal,String percentReq,String validationmessage,String odmstatus,String TravelLaborHour,String TravelRate,String TravelLaborAmount,String TravelDistance,String TravelDistanceRate,String TravelMealAmount,String TravelLodgingAmount,String TravelType,String TravelMode,String OtherModeDetails,String TechnicianPromotionId,String TechnicalWage,String BaseFare,String Hours,String Distance,String UOM,String MealsAmount,String LodgingAmount,String TowingAmount) {

            this.failcode = failcode;
            this.type = type;
            this.Technician = Technician;
            this.expenseTotal = expenseTotal;
            this.percentReq = percentReq;
            this.validationmessage = validationmessage;
            this.odmstatus = odmstatus;
            this.TravelLaborHour = TravelLaborHour;
            this.TravelRate = TravelRate;
            this.TravelLaborAmount = TravelLaborAmount;
            this.TravelDistance = TravelDistance;
            this.TravelDistanceRate = TravelDistanceRate;
            this.TravelMealAmount = TravelMealAmount;
            this.TravelLodgingAmount = TravelLodgingAmount;
            this.TravelType=TravelType;
            this.TravelMode=TravelMode;
            this.OtherModeDetails=OtherModeDetails;
            this.TechnicianPromotionId=TechnicianPromotionId;
            this.TechnicalWage=TechnicalWage;
            this.BaseFare=BaseFare;
            this.Hours=Hours;
            this.Distance=Distance;
            this.UOM=UOM;
            this.MealsAmount=MealsAmount;
            this.LodgingAmount=LodgingAmount;
            this.TowingAmount=TowingAmount;
        }        
    }

    public class SRTsWrapperClass{
        public String failcode {get;set;}
        public String srtcode {get;set;}
        public String srtDesc {get;set;}
        public String accesscode {get;set;}
        public String srtTime {get;set;}
        public String quantity {get;set;}
        public String percentReq {get;set;}
        public String claimedHours {get;set;}
        public String validationmessage {get;set;}
        public String Justification {get;set;}
        public String OutOfChasis {get;set;}
        public String OverlapHrs {get;set;}
        public String Offiste {get;set;}
        public String SRTType {get;set;}
        public String odmstatus {get;set;}
        //BMS batch Processing fields
        public String SRTgroupnum {get;set;}
        public String Procedureno {get;set;}
        public String Stepnumber {get;set;}
        public String SRTLaborRate {get;set;}
        public String ExtendedAmount {get;set;}
        public String ServiceModelName {get;set;}
        public String AdjustmentReason {get;set;}
        public String SRTAmount {get;set;}
        public string ExcludeOvrlpFlg { get; set; }
        public Boolean flexflag {get;set;}

        public SRTsWrapperClass (String failcode,String srtcode,String srtDesc,String accesscode,String srtTime,String quantity,String percentReq,String claimedHours,String validationmessage,String Justification, String OutOfChasis, String OverlapHrs, String Offiste, String SRTType,String odmstatus,String SRTgroupnum,String Procedureno,String Stepnumber,String SRTLaborRate,String ExtendedAmount,String ServiceModelName,String AdjustmentReason, string SRTAmount, string ExcludeOvrlpFlg,Boolean flexflag) {
            this.failcode = failcode;
            this.srtcode = srtcode;
            this.srtDesc = srtDesc;
            this.accesscode = accesscode;
            this.srtTime = srtTime;
            this.quantity = quantity;
            this.percentReq = percentReq;
            this.claimedHours = claimedHours;
            this.validationmessage = validationmessage;
            this.Justification=Justification;
            this.OutOfChasis=OutOfChasis;
            this.OverlapHrs=OverlapHrs;
            this.Offiste=Offiste;
            this.SRTType=SRTType;
            this.odmstatus = odmstatus;
            this.SRTgroupnum = SRTgroupnum;
            this.Procedureno = Procedureno;
            this.Stepnumber = Stepnumber;
            this.SRTLaborRate = SRTLaborRate;
            this.ExtendedAmount = ExtendedAmount;
            this.ServiceModelName = ServiceModelName;
            this.AdjustmentReason = AdjustmentReason;
            this.SRTAmount = SRTAmount;
            this.ExcludeOvrlpFlg = ExcludeOvrlpFlg; 
            this.flexflag = flexflag;
        }        
    }

    public class fieldActionSRTsWrapperClass{
        public String failcode {get;set;}
        public String fan {get;set;}
        public String srtcode {get;set;}
        public String srtDesc {get;set;}
        public String accesscode {get;set;}
        public String srtTime {get;set;}
        public String quantity {get;set;}
        public String percentReq {get;set;}
        public String claimedHours {get;set;}
        public String validationmessage {get;set;}
        public String Justification {get;set;}
        public String OutOfChasis {get;set;}
        public String OverlapHrs {get;set;}
        public String Offiste {get;set;}
        public String SRTType {get;set;}
        public String odmstatus {get;set;}
        //BMS batch Processing fields
        public String SRTgroupnum {get;set;}
        public String Procedureno {get;set;}
        public String Stepnumber {get;set;}
        public String SRTLaborRate {get;set;}
        public String ExtendedAmount {get;set;}
        public String ServiceModelName {get;set;}
        public String AdjustmentReason {get;set;}
        public String SRTAmount {get;set;}
        public string ExcludeOvrlpFlg { get; set; }
        public Boolean flexflag{get;set;}

        public fieldActionSRTsWrapperClass (String failcode,String fan,String srtcode,String srtDesc,String accesscode,String srtTime,String quantity,String percentReq,String claimedHours,String validationmessage, String Justification, String OutOfChasis, String OverlapHrs, String Offiste, String SRTType,String odmstatus,String SRTgroupnum,String Procedureno,String Stepnumber,String SRTLaborRate,String ExtendedAmount,String ServiceModelName,String AdjustmentReason, string SRTAmount, string ExcludeOvrlpFlg, Boolean flexflag) {
            this.failcode = failcode;
            this.fan=fan;
            this.srtcode = srtcode;
            this.srtDesc = srtDesc;
            this.accesscode = accesscode;
            this.srtTime = srtTime;
            this.quantity = quantity;
            this.percentReq = percentReq;
            this.claimedHours = claimedHours;
            this.validationmessage = validationmessage;
            this.Justification=Justification;
            this.OutOfChasis=OutOfChasis;
            this.OverlapHrs=OverlapHrs;
            this.Offiste=Offiste;
            this.SRTType=SRTType;
            this.odmstatus = odmstatus;
            this.SRTgroupnum = SRTgroupnum;
            this.Procedureno = Procedureno;
            this.Stepnumber = Stepnumber;
            this.SRTLaborRate = SRTLaborRate;
            this.ExtendedAmount = ExtendedAmount;
            this.ServiceModelName = ServiceModelName;
            this.AdjustmentReason = AdjustmentReason;
            this.SRTAmount = SRTAmount;
            this.ExcludeOvrlpFlg = ExcludeOvrlpFlg; 
            this.flexflag = flexflag;
        }        
    }

    public class ComplaintCodes{
        public String ComplaintCode{get;set;}
    }

    public class PromotionIds{
        public String PromotionID{get;set;}
    }

    public class Notes{
        public String Note{get;set;}
        public String NoteType{get;set;}
    }  

    //Story #147533 Wrapper for Claim Submission Notes
    public Class ClaimNotes{
        public Note Notes{get;set;}
        public String lastSaveDate{get;set;}
        public String noteBody{get;set;}
        public String noteTitle{get;set;}
    }

    public class AdditionalESNs{
        public String EngineSerialNumber {get;set;}
        public String WarrantyStartDate {get;set;}
        public String BISFlag {get;set;}
        public String FailureDate {get;set;}
        public String FailurePoint {get;set;}
        public String FailureMeasure {get;set;}
        public String ProductHours {get;set;} //Added as per story GSSC-514
        public String EngineVIN {get;set;}
        public String ECMCalibAfter {get;set;}
        public String ECMCalibBefore {get;set;}
        public String RevisionBefore {get;set;}
        public String ReviewAfter {get;set;}
        //BMS batch Processing fields
        public String ESNModel {get;set;}
        public String ApplicationCode {get;set;}
        public String DistanceType {get;set;}
        public String Hours {get;set;}

        public AdditionalESNs (String EngineSerialNumber,String WarrantyStartDate,String BISFlag,String FailureDate,String FailurePoint,String FailureMeasure,String ProductHours,String EngineVIN,String ECMCalibAfter,String ECMCalibBefore,String RevisionBefore,String ReviewAfter,String ESNModel,String ApplicationCode,String DistanceType,String Hours) {
            this.EngineSerialNumber = EngineSerialNumber;
            this.WarrantyStartDate=WarrantyStartDate;
            this.BISFlag = BISFlag;
            this.FailureDate = FailureDate;
            this.FailurePoint = FailurePoint;
            this.FailureMeasure = FailureMeasure;
            this.EngineVIN = EngineVIN;
            this.ECMCalibAfter = ECMCalibAfter;
            this.ECMCalibBefore = ECMCalibBefore;
            this.RevisionBefore = RevisionBefore;
            this.ReviewAfter = ReviewAfter;
            this.ESNModel = ESNModel;
            this.ApplicationCode = ApplicationCode;
            this.DistanceType = DistanceType;
            this.Hours = Hours;
        }        
    }
    
    //Method to check for TTML duplicate records - task 191794
    public List<TTMLWrapperClass> checkDuplicateTTMLs(String failCode, Map<String, List<TTMLWrapperClass>> TTMLWrapList){
        List<TTMLWrapperClass> tempList = new List<TTMLWrapperClass>();
        List<TTMLWrapperClass> uniqueTTMLList = new List<TTMLWrapperClass>();
        system.debug('**TTMLWrapList--***'+TTMLWrapList.size()+'****'+TTMLWrapList);
        for(String ttmlKey: TTMLWrapList.keySet()){
            tempList = TTMLWrapList.get(ttmlKey);
            system.debug('*tempList**'+tempList.size()+'*****'+tempList);
            if(tempList.size()==1){
                system.debug('****insideIf****'+tempList[0].Type);
                if(tempList[0].Type == 'Commercial-Travel'){
                    system.debug('****insideIfCommercialTravel****');
uniqueTTMLList.add(new TTMLWrapperClass(failCode, tempList[0].type, tempList[0].Technician, tempList[0].expenseTotal, tempList[0].percentReq, '', tempList[0].odmstatus, '', '', '', '', '', '', '', tempList[0].TravelType, 'Other', '', tempList[0].TechnicianPromotionId, tempList[0].TechnicalWage, tempList[0].BaseFare, tempList[0].Hours, tempList[0].Distance, '', tempList[0].MealsAmount, tempList[0].LodgingAmount, tempList[0].TowingAmount));
                }
else{
    system.debug('****insideIfElse***');
uniqueTTMLList.add(new TTMLWrapperClass(failCode, tempList[0].type, tempList[0].Technician, tempList[0].expenseTotal, tempList[0].percentReq, '', tempList[0].odmstatus, '', '', '', '', '', '', '', tempList[0].TravelType, 'Other', '', tempList[0].TechnicianPromotionId, '', '', tempList[0].Hours, tempList[0].Distance, '', tempList[0].MealsAmount, tempList[0].LodgingAmount, tempList[0].TowingAmount));
                }
                continue;
            }
            else{
                String type;
                Decimal ClaimedAmount = 0;
                Decimal totalTechWage = 0;
                Decimal totalBaseFare = 0;
                Decimal totalHrs = 0;
                Decimal totalDistance = 0;
                for(TTMLWrapperClass ttmlWrapObj: tempList){
                    system.debug('****insideElse****'+ttmlWrapObj.type);
                    if(ttmlWrapObj.type == 'Commercial-Travel'){
                        system.debug('****insideCommercialTravel****');
                        if(ttmlWrapObj.expenseTotal != null && ttmlWrapObj.expenseTotal != '')
                            ClaimedAmount = ClaimedAmount + decimal.valueOf(ttmlWrapObj.expenseTotal);
                        if(ttmlWrapObj.BaseFare != null && ttmlWrapObj.BaseFare != '')
                            totalBaseFare = totalBaseFare + decimal.valueOf(ttmlWrapObj.BaseFare);
                        if(ttmlWrapObj.Hours != null && ttmlWrapObj.Hours != '')
                            totalHrs = totalHrs + decimal.valueOf(ttmlWrapObj.Hours);
                        if(ttmlWrapObj.Distance != null && ttmlWrapObj.Distance != '')
                            totalDistance = totalDistance + decimal.valueOf(ttmlWrapObj.Distance);
                    }
                    if(ttmlWrapObj.type == 'Non Commercial-Travel'){
                        system.debug('****insideNonCommercialTravel****');
                        if(ttmlWrapObj.expenseTotal != null && ttmlWrapObj.expenseTotal != '')
                            ClaimedAmount = ClaimedAmount+decimal.valueOf(ttmlWrapObj.expenseTotal);
                        if(ttmlWrapObj.Hours != null && ttmlWrapObj.Hours != '')
                            totalHrs = totalHrs + decimal.valueOf(ttmlWrapObj.Hours);
                        if(ttmlWrapObj.Distance != null && ttmlWrapObj.Distance != '')
                            totalDistance = totalDistance + decimal.valueOf(ttmlWrapObj.Distance);
                    }
                    if(ttmlWrapObj.type == 'Meals'){
                        system.debug('****insideMeals****');
                        if(ttmlWrapObj.MealsAmount != null && ttmlWrapObj.MealsAmount != '')
                            ClaimedAmount = ClaimedAmount+decimal.valueOf(ttmlWrapObj.MealsAmount);
                        if(ttmlWrapObj.Hours != null && ttmlWrapObj.Hours != '')
                            totalHrs = totalHrs + decimal.valueOf(ttmlWrapObj.Hours);
                        if(ttmlWrapObj.Distance != null && ttmlWrapObj.Distance != '')
                            totalDistance = totalDistance + decimal.valueOf(ttmlWrapObj.Distance);
                    }
                    if(ttmlWrapObj.type == 'Lodging'){
                        system.debug('****insideLodging****');
                        if(ttmlWrapObj.LodgingAmount != null && ttmlWrapObj.LodgingAmount != '')
                            ClaimedAmount = ClaimedAmount+decimal.valueOf(ttmlWrapObj.LodgingAmount);
                        if(ttmlWrapObj.Hours != null && ttmlWrapObj.Hours != '')
                            totalHrs = totalHrs + decimal.valueOf(ttmlWrapObj.Hours);
                        if(ttmlWrapObj.Distance != null && ttmlWrapObj.Distance != '')
                            totalDistance = totalDistance + decimal.valueOf(ttmlWrapObj.Distance);
                    }
                    if(ttmlWrapObj.type == 'Towing'){
                        system.debug('****insideTowing****');
                        if(ttmlWrapObj.TowingAmount != null && ttmlWrapObj.TowingAmount != '')
                            ClaimedAmount = ClaimedAmount+decimal.valueOf(ttmlWrapObj.TowingAmount);
                        if(ttmlWrapObj.Hours != null && ttmlWrapObj.Hours != '')
                            totalHrs = totalHrs + decimal.valueOf(ttmlWrapObj.Hours);
                        if(ttmlWrapObj.Distance != null && ttmlWrapObj.Distance != '')
                            totalDistance = totalDistance + decimal.valueOf(ttmlWrapObj.Distance);
                    }
                }
                if(ttmlKey == 'Commercial-Travel'){
                    system.debug('****insideIfCommercialTravel****');
uniqueTTMLList.add(new TTMLWrapperClass(failCode, ttmlKey, tempList[0].Technician, tempList[0].expenseTotal, tempList[0].percentReq, '', tempList[0].odmstatus, '', '', '', '', '', '', '', tempList[0].TravelType, 'Other', '', tempList[0].TechnicianPromotionId, tempList[0].TechnicalWage, String.valueof(totalBaseFare), String.valueof(totalHrs), String.valueof(totalDistance), '', String.valueof(ClaimedAmount), String.valueof(ClaimedAmount), String.valueof(ClaimedAmount)));
                }
else{
    system.debug('****insideIfElse***');
uniqueTTMLList.add(new TTMLWrapperClass(failCode, ttmlKey, tempList[0].Technician, tempList[0].expenseTotal, tempList[0].percentReq, '', tempList[0].odmstatus, '', '', '', '', '', '', '', tempList[0].TravelType, 'Other', '', tempList[0].TechnicianPromotionId, '', '', String.valueof(totalHrs), String.valueof(totalDistance), '', String.valueof(ClaimedAmount), String.valueof(ClaimedAmount), String.valueof(ClaimedAmount)));
                }
            }
        }
        system.debug('****uniqueTTMLList****'+uniqueTTMLList.size()+'****'+uniqueTTMLList);
        return uniqueTTMLList;
    }
}