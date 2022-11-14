/*
* Block comments with details of changes
*/
public class CG_CL_ClaimsODMMessagesController
{
    public Id cId{get;set;}
    //Transient public Boolean odmstatusFlag{get;set;}
    public Boolean odmstatusFlag{get;set;}
    public boolean odmstatusCodeFlag{get;set;}
    public boolean odmsrtstatusCodeFlag{get;set;}
    public boolean odmpartstatusCodeFlag{get;set;}
    public boolean odmsolcompsatusCodeFlag{get;set;}
    public boolean odmsolcompsatusSRT{get;set;}  
    public boolean dealerCustomer{get;set;}
    public boolean distrCustomer{get;set;}
    public boolean pendingAuthFlag{get;set;}
    public boolean PartsDupMsg{get;set;} 
    public string licensePlate{get;set;}
    public boolean licensePlateError{get;set;}
    public boolean FieldActionError{get;set;}
    public boolean checklaborrate{get;set;}
    //Transient public List<String> headerclaimsRecMsg{get;set;}
    public List<String> headerclaimsRecMsg{get;set;}
    Transient public List<String> preSubmitclaimsRecMsg{get;set;}
    Transient public String jobNotesCorrectMsg{get;set;}
    Transient public List<claimsSCListWrapper> wrapclaimsSCList{get;set;}
    Transient public List<claimsPOListWrapper> wrapclaimsPOList{get;set;}
    Transient public List<claimsSRTListWrapper> wrapclaimsSRTList{get;set;}
    Transient List<CSS_Solution_component__c> claimsSCList = new List<CSS_Solution_component__c>();
    Transient List<CSS_Solution_component__c> claimsAllSCList = new List<CSS_Solution_component__c>();
    Transient public CSS_Claims__c claimsRec {get;set;}
    Transient public List<css_parts_options__c> claimsPOList = new List<css_parts_options__c>();
    Transient public List<CSS_SRT__c> claimsSRTList = new List<CSS_SRT__c>();
    Transient public List<CSS_SRT__c> claimsSRTListACErr = new List<CSS_SRT__c>();
    Transient public List<CSS_Solution_component__c> solcompListCoverage{get;set;} 
    public boolean isClaimEnabled {get;set;}
    public boolean isATT {get;set;}
    public String isSRTFailAccCodepresentError {get;set;}
    public boolean custcomplerrormsg{get;set;}
    public boolean categoryMandate{get;set;}
    public boolean isInfoOnly {get;set;}
    public boolean travelRateError {get;set;}
    public Id recTypeIdpart;
    public List<CSS_PSN__c> psnRec{get;set;}
    public CG_CL_ClaimsIntake mainContr{get;set;}
    public Boolean dealerLocation{get; set;}
    public Boolean partsODMMesasgeflag{get; set;}
    public Boolean srtsODMMesasgeflag{get; set;}
    public String  srtsODMerrMesasge{get; set;}
    public Boolean srtsODMMesasgeflag1{get; set;}
    public String  srtsODMerrMesasge1{get; set;}
    public list<string> ttmlerrorlst {get;set;}
    public boolean ttmlerrorcoverlmt {get;set;}
    public Boolean coveredPartsMsgFlag{get;set;}
    public Boolean coveredSRTMsgFlag{get;set;}
    public Boolean coveredTTMLMsgFlag{get;set;}
    public Boolean coveredOCMsgFlag{get;set;}
    public Boolean FailModeErrorFlag{get;set;}
    public Boolean srtDuplicateError{get; set;}
    public String  srtDuplicateMsg{get; set;}
    public boolean mutuallyExcSRTFlag{get;set;}
    public boolean olapReasonSRTFlag{get;set;}
    public boolean admin902SRTFlag{get;set;}
    public boolean dupAccessCodePercentReqFlag{get;set;}
    public boolean olapFailureSRTFlag{get;set;}
    public string mutuallyExcSRTMsg{get;set;}
    public string olapReasonSRTMsg{get;set;}
    public string admin902SRTMsg{get;set;}
    public string dupAccessCodePercentReqMsg{get;set;}
    public String olapFailureSRTMsg{get; set;}
    public boolean trackingNumberReq{get;set;}
    public boolean milprodhrsFlag {get;set;}
    public boolean licensePlateErr {get;set;}

    public CG_CL_ClaimsODMMessagesController()
    {
        try {
            //PartsDupMsg =false;
            claimsRec = new CSS_Claims__c();
            isClaimEnabled = css_utility.getclaimsapprove(UserInfo.getUserId());
            isATT = false;
            isSRTFailAccCodepresentError = '';
            custcomplerrormsg = false;
            isInfoOnly = false;
            //claimsPOList= new List<css_parts_options__c>();
            //claimsSRTList = new List<CSS_SRT__c>();
            headerclaimsRecMsg=new List<String>();
            preSubmitclaimsRecMsg = new List<String>();
            solcompListCoverage = new List<CSS_Solution_component__c>(); 
            ttmlerrorlst=new List<String>();
            list<CSS_Parts_Options__c> lstPartsRec = new list<CSS_Parts_Options__c>();
            jobNotesCorrectMsg='';
            odmstatusFlag=false;
            odmstatusCodeFlag=false;
            dealerCustomer = false;
            checklaborrate=false;
            dealerLocation=false;
            partsODMMesasgeflag=false;
            srtsODMMesasgeflag=false;
            srtsODMMesasgeflag1=false;
            FailModeErrorFlag=false;
            mutuallyExcSRTFlag = false;
            olapReasonSRTFlag = false;
            admin902SRTFlag = false;
            dupAccessCodePercentReqFlag = false;
            olapFailureSRTFlag = false;
            licensePlateErr = false;
            cId=ApexPages.CurrentPage().getParameters().get('Id');
            //Get Claims ODM Validation Message
            if(cId!=null){
                System.debug('SOQL Count so far ODMMessages constructor start' + Limits.getQueries());
                claimsRec = [select id,Claims_Category_Desc__c,Account__c,Account__r.type,PartsRelatedODMMessage__c,CreatedById,Customer_Name__c,Shop_Work_Order__c,Claims_Category2_Desc__c,Claims_Category3_Desc__c,
                             Claims_Category4_Desc__c,SRT_FlexTime_Error__c,Claims_Category5_Desc__c,Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,
                             Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,Dealer_Service_Job__c,ODM_Status__c,SP_INSHOP_LABOR_RATE__c,Information_Only_Claim__c,
                             EditCorrection__c,License_Plate_State_Error_message__c,FieldActionWebServiceResult__c,ODM_Status_Code__c,ODM_Status_Message__c, ODM_Pre_submit_Status__c, 
                             ODM_Pre_submit_Status_Message__c,css_job__c,Mutual_Exclusive_Message__c,SRT_Olap_Reason_Msg__c,SRT_902_Error_Message__c,DupAccessCodePercentReqMsg__c,Overlap_Service_Failure_Msg__c,
                             isCalibrationFieldsBlank__c,Pending_Authorization__c, Actual_Technician_Time__c,CSS_Travel_Rate__c,IsDealerCreatedClaim__c,User_Landed_CC__c, CoveragePartsErrMsg__c,
                             CoverageTTMLErrMsg__c, CoverageOCErrMsg__c, CoverageSRTErrMsg__c,DuplicateSRTDetails__c, MileageProdHrsError__c,
                             (Select Id,Name,PSN__c,Location_Certification__c,Warranty_Authorization_Flag__c,Application__c,ApplicationCode__c,Before_In_Service__c,Calibration_After__c,Calibration_Before__c,Revision_After__c,
                             Revision_Before__c,Failure_Date__c,Justification__c,License_Plate_State__c,
                             Make__c,Mileage__c,CoverageFlag__c,Mileage_Measure__c,Mission_Disabling__c,Model__c,Primary__c,Product_Hours__c,Qsol_Engine_Family_Code__c,Equipment_ID__c,Qsol_Technical_Config__c,
                             Qsol_Warranty_Start__c,Service_Model__c,Unit_Number__c,Unit_Type__c,VIN__c,Warranty_Start_Date__c,CSS_Claims__c,ProductAppcodeErrorflag__c, PACCAR_Flag__c from CSS_PSNs__r where Primary__c=true Limit 1)
                             from CSS_Claims__c where id=:cId]; // Added css_job__c field to retrieve, //Query Optimization By Krishna on Jan 27th 2020.
                system.debug('claimsRec>>>ODMcontoller--' + claimsRec);
                
                //Query Optimization By Krishna on Jan 27th 2020.
                //psnRec = [SELECT Id, PSN__c, Warranty_Start_Date__c,Before_In_Service__c,Failure_Date__c, Application__c, Make__c, Model__c,License_Plate_State__c FROM CSS_PSN__c WHERE CSS_Claims__c =: cId AND Primary__c = true];
                if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                    psnRec = new List<CSS_PSN__c> ();
                    psnRec = claimsRec.CSS_PSNs__r;
                }
                //Query Optimization By Krishna on Jan 27th 2020.

                if(claimsRec.Information_Only_Claim__c==true && claimsRec.IsDealerCreatedClaim__c == true)
                    isInfoOnly = true;
                String orgtype=css_utility.getOrgType(userinfo.getUserId());
                system.debug('Test123'+claimsRec);
                if (orgtype == 'DLR' &&(claimsRec.EditCorrection__c==null || claimsRec.EditCorrection__c=='')){
                    dealerCustomer = true;
                }
                if(orgtype == 'DISTR'){
                    distrCustomer = true;
                }
                if(isClaimEnabled) {
                    if(claimsRec.Actual_Technician_Time__c == null) 
                        isATT = true;
                }
                // below code for checking dealer location from utility class as per story #176379 Kung Fu Panda sprint,-By RAJESH 11th Mar 2019
                system.debug('****Cid****'+Cid);
                dealerLocation = false;
                boolean DealerTypeFlag = CSS_utility.getAccounttype(claimsRec.Account__r.Type);
                if(claimsRec!=null){
                    if(DealerTypeFlag==true)
                        dealerLocation = true;
                    if(dealerLocation && claimsRec.PartsRelatedODMMessage__c=='failed')
                        partsODMMesasgeflag=true;
                    else
                        partsODMMesasgeflag=false;

                }
                //End

                //Validations for Category n Complaint for #173531//
                system.debug('**claimsRec.Claims_Category_Desc__c**'+claimsRec.Claims_Category_Desc__c);
                if((claimsRec.Claims_Category_Desc__c == null ||  claimsRec.Claims_Category_Desc__c == '') &&
                   (claimsRec.Claims_Category2_Desc__c == null || claimsRec.Claims_Category2_Desc__c == '') &&
                   (claimsRec.Claims_Category3_Desc__c == null || claimsRec.Claims_Category3_Desc__c == '' )&&
                   (claimsRec.Claims_Category4_Desc__c == null || claimsRec.Claims_Category4_Desc__c == '') &&
                   (claimsRec.Claims_Category5_Desc__c == null || claimsRec.Claims_Category5_Desc__c == '')){
                    system.debug('**enter inside if for checking Claims_Category_Desc__c**');
                    categoryMandate = true;
                }
                else{
                    categoryMandate = false;
                    system.debug('**enter inside else for checking system.debug Claims_Category_Desc__c**');
                }
                if((claimsRec.Complaint_Type_Desc__c == null  ||  claimsRec.Complaint_Type_Desc__c.trim() == '') &&
                   (claimsRec.Complaint_Type2_Desc__c == null || claimsRec.Complaint_Type2_Desc__c.trim() == '') &&
                   (claimsRec.Complaint_Type3_Desc__c == null || claimsRec.Complaint_Type3_Desc__c.trim() == '') &&
                   (claimsRec.Complaint_Type4_Desc__c == null || claimsRec.Complaint_Type4_Desc__c.trim() == '') && 
                   (claimsRec.Complaint_Type5_Desc__c == null || claimsRec.Complaint_Type5_Desc__c.trim() == '')){
                    custcomplerrormsg = true;
                }
                else{
                    custcomplerrormsg = false;

                }
                //End of Validations
                system.debug('*****FieldActionWebServiceResult__c***'+claimsRec.FieldActionWebServiceResult__c);
                if(claimsRec.FieldActionWebServiceResult__c == 'Error' && claimsRec.FieldActionWebServiceResult__c != ''){
                    FieldActionError = true;
                }
                if(claimsRec.License_Plate_State_Error_message__c != null && claimsRec.License_Plate_State_Error_message__c != ''){
                    licensePlateError = true;
                }
                //story 153618
                system.debug('*****claimsRec.Pending_Authorization__c***'+claimsRec.Pending_Authorization__c);
                String UserType=css_utility.getOrgType(claimsRec.CreatedById);
                if(claimsRec.Pending_Authorization__c =='Authorization Required'){ //&& UserType=='DLR'){
                    pendingAuthFlag = true;
                }
                else{
                    pendingAuthFlag = false;
                }
                system.debug('*****pendingAuthFlag***'+pendingAuthFlag);

                Map<String,CSS_Parts_Options__c> partERPAccCodeMap = new Map<String,CSS_Parts_Options__c>();
                recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'BMS Parts');
                //for(CSS_Parts_Options__c p:[SELECT Id,Service_partnumber__c, Account_Code__c from CSS_Parts_Options__c where CSS_Claims__c =:cId and Account_Code__c != null and selected_part__c = true and (RecordTypeId =: recTypeIdpart or Part_Assignment__c = 'Primary' or Parts_Type__c = 'Custom')])
                for(CSS_Parts_Options__c p:[SELECT Id,Tracking_Number__c,ReturnToFactory__c,Service_partnumber__c, Account_Code__c,selected_part__c,Part_Assignment__c,RecordTypeId,Parts_Type__c  from CSS_Parts_Options__c where CSS_Claims__c =:cId ])
                {
                    if(p.Account_Code__c != null && p.selected_part__c == true && (p.RecordTypeId == recTypeIdpart || p.Part_Assignment__c == 'Primary' || p.Parts_Type__c == 'Custom')){
                        if(partERPAccCodeMap.Containskey(p.Service_partnumber__c + p.Account_Code__c)){
                            PartsDupMsg = true;
                            break;
                        }
                        else{
                            partERPAccCodeMap.put(p.Service_partnumber__c+ p.Account_Code__c,p);
                        }
                    }
                    //Commented below code as part of defect 191660
                    /*system.debug('***part**'+p);
                    if(p.selected_part__c == true && (p.Tracking_Number__c=='' || p.Tracking_Number__c == null || p.Tracking_Number__c == 'Select One') && p.ReturnToFactory__c == 'Y'){
                        trackingNumberReq=true;
                    }*/
                }
                //added below code as part of defect 191660 start
                for(CSS_Parts_Options__c p:[SELECT Id,Tracking_Number__c,ReturnToFactory__c,Service_partnumber__c, Account_Code__c,selected_part__c,Part_Assignment__c,RecordTypeId,Parts_Type__c  from CSS_Parts_Options__c where CSS_Claims__c =:cId and selected_part__c = true and ReturnToFactory__c = 'Y' and Account_Code__c!='']) // karthik G added account code condtion for parts not displaying front end and return to facotry Y still error should not show
                {
                    system.debug('***part**'+p);
                    if((p.Tracking_Number__c=='' || p.Tracking_Number__c == null || p.Tracking_Number__c == 'Select One')){
                        trackingNumberReq=true;
                    }
                    system.debug('trackingNumberReq'+trackingNumberReq);
                }
                //added below code as part of defect 191660 end
                
                //Story 148912 -starts
                if((claimsRec.CSS_Travel_Rate__c == null || claimsRec.CSS_Travel_Rate__c == '') || (claimsRec.CSS_Travel_Rate__c != null && Decimal.valueOf(claimsRec.CSS_Travel_Rate__c)==0)){
                    travelRateError=true;
                }
                //Story 148912 - ends

               /* if(dealerCustomer==true){
                    Transient List<CSS_Solution_component__c> solComRec = new List<CSS_Solution_component__c>();
                    solComRec = [SELECT Id, Name,Quantity__c,CSS_Claims__c
                                 FROM css_solution_component__c 
                                 WHERE CSS_Claims__c= :cId and Selected_Component__c = true and type__C NOT IN ('TSB', 'TRP','ATC','Campaign')];
                    if(solComRec.size()>0){
                        for(css_solution_component__c sol:solComRec){
                            if(sol.name!=null && sol.name!='')
                            {
                                //dealerCustomer=false;
                                break;
                            }
                        }
                    }}*/
                //Get Failures ODM Validation Messages
                //claimsSCList = [select id,ODM_Status__c,ODM_Status_Message__c,FailCode_Formula__c from CSS_Solution_component__c where CSS_Claims__c=:cId  and ODM_Status__c!=null and (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA'  AND ODM_Status__c!='PASSED') ]; 
                //Query for only ODM Errors
                //claimsSCList = [select id,CoverageTravelBaseFareMsgTstatus__c,CoverageLimitExceedMsg__c,Failure_Mode__c,CoverageTravelBaseFareExceedMsg__c,CoverageLimitExceedMsg_Status__c,ODM_Status__c,ODM_Status_Message__c,ODM_Status_Code__c,Selected_Component__c,type__C,FailCode_Formula__c,CoverageLimitExceedMsgSRT__c,CoverageLimitExceedMsgSRT_Status__c from CSS_Solution_component__c where CSS_Claims__c=:cId  and ODM_Status__c != null and ODM_Status__c!='YTBV' AND ODM_Status__c!='NA'  AND ODM_Status__c!='PASSED']; //(OldSolCompID__c != null and Type__c NOT IN ('Campaign','TRP','ATC')) ) )Commented by Anirudh as it is pulling all the records for automated. Please discuss if any other issues comes up
//Start code As per defect #189898 have commented above query and covered using below query,-By RAJESH 29th July 2019    
                claimsSCLIST=[select id, CoverageTravelBaseFareMsgTstatus__c, Failure_Mode__c, CoverageTravelBaseFareExceedMsg__c, CoverageLimitExceedMsg_Status__c, ODM_Status__c, ODM_Status_Message__c, ODM_Status_Code__c, Selected_Component__c, type__C, FailCode_Formula__c, CoverageLimitExceedMsgSRT__c, CoverageLimitExceedMsgSRT_Status__c,CoverageLimitExceedMsg__c from CSS_Solution_component__c where CSS_Claims__c=:cId and ((ODM_Status__c != null and ODM_Status__c!='YTBV' AND ODM_Status__c!='NA' AND ODM_Status__c!='PASSED') 
                             OR (OldSolCompID__c != null AND Type__c NOT IN ('Campaign', 'TRP', 'ATC') AND 
                             CoverageLimitExceedMsg_Status__c != null AND CoverageLimitExceedMsg_Status__c != '' AND CoverageLimitExceedMsg_Status__c != 'PASSED'
                             AND CoverageTravelBaseFareMsgTstatus__c != null AND CoverageTravelBaseFareMsgTstatus__c !='' AND CoverageTravelBaseFareMsgTstatus__c != 'PASSED'
                             AND CoverageLimitExceedMsgSRT_Status__c != null AND CoverageLimitExceedMsgSRT_Status__c != '' AND CoverageLimitExceedMsgSRT_Status__c != 'PASSED'))];
//End code As per defect #189898, -By RAJESH 29th July 2019                 
                 
                claimsAllSCList = [select id,CoverageTravelBaseFareMsgTstatus__c,CoverageLimitExceedMsg__c,Failure_Mode__c,CoverageTravelBaseFareExceedMsg__c,CoverageLimitExceedMsg_Status__c,ODM_Status__c,ODM_Status_Message__c,ODM_Status_Code__c,Selected_Component__c,type__C,FailCode_Formula__c,CoverageLimitExceedMsgSRT__c,CoverageLimitExceedMsgSRT_Status__c,OldSolCompID__c,CSS_Account_Formula__c from CSS_Solution_component__c where CSS_Claims__c=:cId]; 
                system.debug('claimsSCList**'+claimsSCList);
                
                //Logic added by siva ganesh for Story #GSSC-55
                for(CSS_Solution_component__c solcomp: claimsAllSCList){
                    if(solcomp.CSS_Account_Formula__c!=null && solcomp.CSS_Account_Formula__c=='Emission Warranty 70' && (psnRec[0].License_Plate_State__c==null || psnRec[0].License_Plate_State__c=='' || psnRec[0].License_Plate_State__c=='Select One' ) && (claimsRec.css_job__c != null || claimsRec.Dealer_Service_Job__c  != null)){
                         licensePlateErr = true;
                    }
                }
                
                //Get Parts ODM Validation Messages
              if(claimsRec.css_job__c != null || claimsRec.Dealer_Service_Job__c  != null)
                {   //claimsPOList = [select id,ODM_Status__c,ODM_Status_Message__c,Service_partnumber__c,selected_part__c from CSS_Parts_Options__c where CSS_Claims__c=:cId and  ODM_Status__c!=null  and selected_part__c=true and (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA'  AND ODM_Status__c!='PASSED') ];
                    claimsPOList = [select id,ODM_Status__c,ODM_Status_Message__c,ODM_Status_Code__c,Service_partnumber__c,selected_part__c from CSS_Parts_Options__c where CSS_Claims__c=:cId and  ODM_Status__c!=null  and selected_part__c=true and ((ODM_Status_Code__c != null and ODM_Status_Code__c != '200') or (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA'  AND ODM_Status__c!='PASSED') )];
                    claimsSRTList = [select id,ODM_Status__c,ODM_Status_Message__c,ODM_Status_Code__c,FailCode__c,SRT_ID__c from CSS_SRT__c where CSS_Claims__c=:cId and  ODM_Status__c!=null and ((isperformed__c = true and type__c in ('Diagnosis','Repair','Field Action','Overlap','Admin','99Time','Access')) or (SRT_AccessiblityCheck__c = true and type__c in ('Diag Access','Repair Access','Field Action Access'))) and ((ODM_Status_Code__c != null and ODM_Status_Code__c != '200') or (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA'  AND ODM_Status__c!='PASSED')) ];
                }
                else   
                {  //claimsPOList = [select id,ODM_Status__c,ODM_Status_Message__c,Service_partnumber__c from CSS_Parts_Options__c where CSS_Claims__c=:cId and  ODM_Status__c!=null and (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA'  AND ODM_Status__c!='PASSED') ];
                    claimsPOList = [select id,ODM_Status__c,ODM_Status_Message__c,ODM_Status_Code__c,Service_partnumber__c from CSS_Parts_Options__c where CSS_Claims__c=:cId and  ODM_Status__c!=null   and selected_part__c=true and ((ODM_Status_Code__c != null and ODM_Status_Code__c != '200') or (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA'  AND ODM_Status__c!='PASSED') )];
                 //   system.debug('EXCEPTION of claimsPOList'+claimsPOList);

                    //Get SRT ODM Validation Messages
                    //claimsSRTList = [select id,ODM_Status__c,ODM_Status_Message__c,FailCode__c,SRT_ID__c from CSS_SRT__c where CSS_Claims__c=:cId and  ODM_Status__c!=null and (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA'  AND ODM_Status__c!='PASSED') ];
                    claimsSRTList = [select id,ODM_Status__c,ODM_Status_Message__c,ODM_Status_Code__c,FailCode__c,SRT_ID__c from CSS_SRT__c where CSS_Claims__c=:cId and  ODM_Status__c!=null and ((ODM_Status_Code__c != null and ODM_Status_Code__c != '200') or (ODM_Status__c!='YTBV' AND ODM_Status__c!='NA'  AND ODM_Status__c!='PASSED')) ];
                }
                if( (claimsRec.ODM_Status__c!=null && (claimsRec.ODM_Status__c!='YTBV' && claimsRec.ODM_Status__c!='NA') && claimsRec.ODM_Status_Message__c!=null && claimsRec.ODM_Status_Message__c!='')  || 
                   claimsSCList.Size()>0 || claimsPOList.Size()>0 || claimsSRTList.Size()>0 ||
                   (claimsRec.ODM_Pre_submit_Status__c!=null && (claimsRec.ODM_Pre_submit_Status__c!='YTBV' && claimsRec.ODM_Pre_submit_Status__c!='NA') && claimsRec.ODM_Pre_submit_Status_Message__c!=null && claimsRec.ODM_Pre_submit_Status_Message__c != ''))
                    odmstatusFlag=true;
                if(claimsRec.ODM_Status_Code__c != null && claimsRec.ODM_Status_Code__c != '200')
                    odmstatusCodeFlag = true;
                 //GSSC-330, added for loop to display Error Message
                    claimsSRTListACErr = [select id,ODM_Status__c,ODM_Status_Message__c,ODM_Status_Code__c,FailCode__c,Assignment__c,AccountCode_Formula__c,type__c,SRT_ID__c from CSS_SRT__c where CSS_Claims__c=:cId and type__c != 'Overlap' and type__c != '99Time' and ((isperformed__c = true and type__c in ('Diagnosis','Repair','Field Action','Admin','Access')) or (SRT_AccessiblityCheck__c = true and type__c in ('Diag Access','Repair Access','Field Action Access')))]; //GSSC-330, added AccountCode_Formula__c field in the query
                    system.debug('claimsSRTListACErr**'+claimsSRTListACErr);
                    system.debug('BeforeisSRTFailAccCodepresentError**'+isSRTFailAccCodepresentError);
                    
                 for(css_Srt__C srt: claimsSRTListACErr){
                    if((srt.FailCode__c == null || srt.FailCode__c == '' || srt.AccountCode_Formula__c == null || srt.AccountCode_Formula__c == '') && ((srt.Assignment__c== 'Primary' || srt.Assignment__c== 'Progressive Damage' || srt.Assignment__c== 'Alternative' || srt.Assignment__c==null))){//Added Assignment__c condition for Defect GSSC-555
                  // if(srt.FailCode__c == null || srt.FailCode__c == '' || srt.AccountCode_Formula__c == null || srt.AccountCode_Formula__c == ''){
                        if(isSRTFailAccCodepresentError != null && isSRTFailAccCodepresentError != ''){
                            system.debug('InsideIf**');
                        isSRTFailAccCodepresentError =  isSRTFailAccCodepresentError+'<br/>'+System.Label.CSS_SRTFailAccCodeError+' '+srt.srt_id__c;}
                       /* isSRTFailAccCodepresentError =  isSRTFailAccCodepresentError+'<br/>';
                        isSRTFailAccCodepresentError = '\n'+isSRTFailAccCodepresentError+System.Label.CSS_SRTFailAccCodeError+' '+srt.srt_id__c;}*/
                        else
                        isSRTFailAccCodepresentError = System.Label.CSS_SRTFailAccCodeError+' '+srt.srt_id__c;
                    
                }
                 }
                system.debug('isSRTFailAccCodepresentError**'+isSRTFailAccCodepresentError);
                system.debug('Label.CSS_SRTFailAccCodeError**'+Label.CSS_SRTFailAccCodeError);
                system.debug('System.Label.CSS_SRTFailAccCodeError**'+System.Label.CSS_SRTFailAccCodeError);
               // END://GSSC-330, added for loop to display Error Message
                for(css_Srt__C srt: claimsSRTList){
                    if(srt.ODM_Status_Code__c != null && srt.ODM_Status_Code__c != '200'){
                        odmsrtStatusCodeFlag = true;
                        break;
                    }
                }
                for(Css_parts_options__c part: claimsPOList){
                    if(part.ODM_Status_Code__c != null && part.ODM_Status_Code__c != '200'){
                        odmpartstatusCodeFlag = true;
                        break;
                    }
                }
                for(Css_Solution_Component__C solComp: claimsAllSCList){
                    system.debug('solComp**'+solComp);
                    if((solComp.ODM_Status_Code__c != null && solComp.ODM_Status_Code__c != '200') || (solComp.CoverageLimitExceedMsg_Status__c != null && solComp.CoverageLimitExceedMsg_Status__c != '' && solComp.CoverageLimitExceedMsg_Status__c != 'PASSED')){
                        odmsolcompsatusCodeFlag = true;

                    } 
                    if((solComp.ODM_Status_Code__c != null && solComp.ODM_Status_Code__c != '200') || (solComp.CoverageLimitExceedMsgSRT_Status__c!= 'PASSED' && solComp.CoverageLimitExceedMsgSRT_Status__c!= '' && solComp.CoverageLimitExceedMsgSRT_Status__c!= null)){
                        odmsolcompsatusSRT=true;
                        solcompListCoverage.add(solComp);

                    } 
                    system.debug('solComp.CoverageTravelBaseFareMsgTstatus__c'+solComp.CoverageTravelBaseFareMsgTstatus__c);
                    if((solComp.ODM_Status_Code__c != null && solComp.ODM_Status_Code__c != '200') || (solComp.CoverageTravelBaseFareMsgTstatus__c!=null && solComp.CoverageTravelBaseFareMsgTstatus__c!='' && solComp.CoverageTravelBaseFareMsgTstatus__c!='PASSED')){
                        ttmlerrorcoverlmt=true;
                        ttmlerrorlst.addAll(CG_CL_CoverageLimitExceedValidation.validationerrortypes(new List<string>(solComp.CoverageTravelBaseFareExceedMsg__c.split(';'))));
                        system.debug('ttmlerrorlst'+ttmlerrorlst);


                    } system.debug('FailModeErrorFlag' + FailModeErrorFlag);
                    system.debug('solComp.Failure_Mode__c' + solComp.Failure_Mode__c);
                     system.debug('solComp.Type__c' + solComp.Type__c);

                     if(((solComp.OldSolCompID__c != null  && ((solComp.Type__c==null || solComp.Type__c=='') || (!solComp.Type__c.containsIgnoreCase('Campaign') && !solComp.Type__c.containsIgnoreCase('TRP') && !solComp.Type__c.containsIgnoreCase('ATC'))))&& (solComp.Failure_Mode__c == null || solComp.Failure_Mode__c == ''))){
                        FailModeErrorFlag=true;
                        system.debug('FailModeErrorFlagInside' + FailModeErrorFlag);
                    }
                }

                if(claimsRec.Mutual_Exclusive_Message__c != '' && claimsRec.Mutual_Exclusive_Message__c != null){
                    mutuallyExcSRTFlag = true;
                    mutuallyExcSRTMsg = claimsRec.Mutual_Exclusive_Message__c;
                }
                if(claimsRec.SRT_Olap_Reason_Msg__c != '' && claimsRec.SRT_Olap_Reason_Msg__c != null){
                    olapReasonSRTFlag = true;
                    olapReasonSRTMsg = claimsRec.SRT_Olap_Reason_Msg__c;
                }
                if(claimsRec.SRT_902_Error_Message__c != '' && claimsRec.SRT_902_Error_Message__c != null){
                    admin902SRTFlag = true;
                    admin902SRTMsg = claimsRec.SRT_902_Error_Message__c;
                }
                if(claimsRec.DupAccessCodePercentReqMsg__c != '' && claimsRec.DupAccessCodePercentReqMsg__c != null){
                    dupAccessCodePercentReqFlag = true;
                    dupAccessCodePercentReqMsg = claimsRec.DupAccessCodePercentReqMsg__c;
                }
                if(claimsRec.Overlap_Service_Failure_Msg__c != '' && claimsRec.Overlap_Service_Failure_Msg__c != null){
                    olapFailureSRTFlag = true;
                    olapFailureSRTMsg = claimsRec.Overlap_Service_Failure_Msg__c;
                }
                
                if(claimsRec.CoveragePartsErrMsg__c != '' && claimsRec.CoveragePartsErrMsg__c != null){
                    coveredPartsMsgFlag = true;
                }
                if(claimsRec.CoverageTTMLErrMsg__c != '' && claimsRec.CoverageTTMLErrMsg__c != null){
                    coveredTTMLMsgFlag = true;
                }
                if(claimsRec.CoverageOCErrMsg__c != '' && claimsRec.CoverageOCErrMsg__c != null){
                    coveredOCMsgFlag = true;
                }
                if(claimsRec.CoverageSRTErrMsg__c != '' && claimsRec.CoverageSRTErrMsg__c != null){
                    coveredSRTMsgFlag = true;
                }
                if(claimsRec.DuplicateSRTDetails__c != null && claimsRec.DuplicateSRTDetails__c != ''){
                    srtDuplicateError=true;
                    srtDuplicateMsg='Warning: SRTs ('+claimsRec.DuplicateSRTDetails__c+') have already been applied. Please confirm that additional quantity is needed.';
                }
                if(string.isBlank(claimsRec.SP_INSHOP_LABOR_RATE__c) || (string.isNotBlank(claimsRec.SP_INSHOP_LABOR_RATE__c) && double.valueOf(claimsRec.SP_INSHOP_LABOR_RATE__c)==0))
                {
                    checklaborrate=true;
                    system.debug('Test Labor rate'+checklaborrate);
                } 
                //GSSC - 106
                if(claimsRec.MileageProdHrsError__c != null && claimsRec.MileageProdHrsError__c != '' && claimsRec.MileageProdHrsError__c != 'Success'){
                    milprodhrsFlag = true;
                }
                splitheaderclaimsRecStatusMsg();
                splitRelatedStatusMsg();
            }
        }
        catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsODMMessagesController constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }

        System.debug('SOQL Count so far ' + Limits.getQueries());
    }


    public void splitheaderclaimsRecStatusMsg() {
        if(claimsRec.ODM_Status__c!=null && claimsRec.ODM_Status__c!='YTBV' &&  claimsRec.ODM_Status__c!='NA'){
            if(claimsRec.ODM_Status_Message__c!=null && claimsRec.ODM_Status_Message__c!=''){
                system.debug('headerclaimsRecMsg ' + claimsRec.ODM_Status_Message__c);
                String[] claimODMmsg=claimsRec.ODM_Status_Message__c.split('\\;;')  ;
                if(claimODMmsg!=null && claimODMmsg.size()>0){
                    for(string s: claimODMmsg){

                        headerclaimsRecMsg.add(s);
                    }
                }
                else{
                    headerclaimsRecMsg.add(claimsRec.ODM_Status_Message__c);
                }
            }  
        }
        system.debug('headerclaimsRecMsg ' + headerclaimsRecMsg);
        //Pre-Submit
        if(claimsRec.ODM_Pre_submit_Status_Message__c !=null && claimsRec.ODM_Pre_submit_Status_Message__c !=''){
            system.debug('preSubmitclaimsRecMsg ' + claimsRec.ODM_Pre_submit_Status_Message__c);
            String[] claimODMmsg=claimsRec.ODM_Pre_submit_Status_Message__c.split('\\;;')  ;
            if(claimODMmsg!=null && claimODMmsg.size()>0){
                for(string s: claimODMmsg){
                    system.debug('s**** ' + s);
                    if(s.contains('Correction Notes on Job notes')){
                        jobNotesCorrectMsg=s;
                    }
                    else
                        preSubmitclaimsRecMsg.add(s);
                }
            }
            else{
                preSubmitclaimsRecMsg.add(claimsRec.ODM_Pre_submit_Status_Message__c);
            }
        } 
        system.debug('jobNotesCorrectMsg**** ' + jobNotesCorrectMsg);
        system.debug('headerclaimsRecMsg ' + headerclaimsRecMsg);
        System.debug('SOQL Count so far ' + Limits.getQueries());
    }

    public void splitRelatedStatusMsg() {
        system.debug('inside method splitRelatedStatusMsg');
        wrapclaimsSCList = new List<claimsSCListWrapper>();
        wrapclaimsPOList = new List<claimsPOListWrapper>();
        wrapclaimsSRTList = new List<claimsSRTListWrapper>();
        if(claimsSCList!=null  && claimsSCList.size()>0 ){
            for(CSS_Solution_component__c sol :claimsSCList){
                if(sol.ODM_Status_Message__c!=null && sol.ODM_Status_Message__c!=''){ //Rajesh Narra on 7-05-2018 sit to check weather the ODM Status Message is blank or empty
                    String[] claimSCODMmsg=sol.ODM_Status_Message__c.split('\\;;'); 
                    if(claimSCODMmsg!=null && claimSCODMmsg.size()>0){
                        for(String st:claimSCODMmsg){
                            claimsSCListWrapper solWrap = new claimsSCListWrapper();
                            solWrap.failcode=sol.FailCode_Formula__c;
                            solWrap.odmStatus=sol.ODM_Status__c;
                            solWrap.odmStatusMsg=st;
                            wrapclaimsSCList.add(solWrap);
                        }
                    }
                }
                /*else{
                    claimsSCListWrapper solWrap = new claimsSCListWrapper();
                    solWrap.failcode=sol.FailCode_Formula__c;
                    solWrap.odmStatus=sol.ODM_Status__c;
                    solWrap.odmStatusMsg=sol.ODM_Status_Message__c;
                    wrapclaimsSCList.add(solWrap);
                }*/
                //Commented below as part of the defect # GSSC-176 - START
                /*if(sol.CoverageLimitExceedMsg__c != null && sol.CoverageLimitExceedMsg__c != ''){
                    claimsSCListWrapper solWrap = new claimsSCListWrapper();
                    solWrap.odmStatus=sol.CoverageLimitExceedMsg_Status__c;
                    solWrap.odmStatusMsg='Error: '+sol.CoverageLimitExceedMsg__c;
                    wrapclaimsSCList.add(solWrap);
                }*/
                //Commented below as part of the defect # GSSC-176 - END
            }
        }
        //Added as part of the defect # GSSC-176 - START
        if(claimsAllSCList != null && claimsAllSCList.size() > 0){
            for(CSS_Solution_component__c sol :claimsAllSCList){
                if(sol.CoverageLimitExceedMsg__c != null && sol.CoverageLimitExceedMsg__c != ''){
                    claimsSCListWrapper solWrap = new claimsSCListWrapper();
                    solWrap.odmStatus=sol.CoverageLimitExceedMsg_Status__c;
                    solWrap.odmStatusMsg='Error: '+sol.CoverageLimitExceedMsg__c;
                    wrapclaimsSCList.add(solWrap);
                }
            }
        }
        //Added as part of the defect # GSSC-176 - END
        system.debug(' wrapclaimsSCList>>' +wrapclaimsSCList);
        if(claimsPOList!=null  && claimsPOList.size()>0 ){
            for(CSS_Parts_Options__c PO :claimsPOList){
                 if(PO.ODM_Status_Message__c!=null && PO.ODM_Status_Message__c!=''){
                String[] claimPOODMmsg=PO.ODM_Status_Message__c.split('\\;;'); 
                if(claimPOODMmsg!=null && claimPOODMmsg.size()>0){
                    for(String st:claimPOODMmsg){
                        claimsPOListWrapper POWrap = new claimsPOListWrapper();
                        POWrap.partnumber=PO.Service_partnumber__c;
                        POWrap.odmStatus=PO.ODM_Status__c;
                        POWrap.odmStatusMsg=st;
                        system.debug('POWrap>>>>'+POWrap);
                        wrapclaimsPOList.add(POWrap);
                    }
                }
                 }
                else{
                    claimsPOListWrapper POWrap = new claimsPOListWrapper();
                    POWrap.partnumber=PO.Service_partnumber__c;
                    POWrap.odmStatus=PO.ODM_Status__c;
                    POWrap.odmStatusMsg=PO.ODM_Status_Message__c;
                    system.debug('Else POWrap>>>>'+POWrap);
                    wrapclaimsPOList.add(POWrap);
                }
            }
        }
        if(claimsSRTList!=null  && claimsSRTList.size()>0 ){
            for(CSS_SRT__c srt :claimsSRTList){
                if(srt.ODM_Status_Message__c!=null && srt.ODM_Status_Message__c!=''){
                String[] claimSRTODMmsg=srt.ODM_Status_Message__c.split('\\;;'); 
                if(claimSRTODMmsg!=null && claimSRTODMmsg.size()>0){
                    for(String st:claimSRTODMmsg){
                        claimsSRTListWrapper srtWrap = new claimsSRTListWrapper();
                        srtWrap.failcode=srt.FailCode__c;
                        srtWrap.odmStatus=srt.ODM_Status__c;
                        srtWrap.odmStatusMsg=st;
                        wrapclaimsSRTList.add(srtWrap);
                    }
                }
                }
                else{
                    claimsSRTListWrapper srtWrap = new claimsSRTListWrapper();
                    srtWrap.failcode=srt.FailCode__c;
                    srtWrap.odmStatus=srt.ODM_Status__c;
                    srtWrap.odmStatusMsg=srt.ODM_Status_Message__c;
                    wrapclaimsSRTList.add(srtWrap);
                }
            }
        }
        //Below code as part of the stories 179802(Claims) and  180119(Claims)-By RAJESH 08 Apr 2019
        if(solcompListCoverage != null  && solcompListCoverage.size() > 0){
            system.debug('solcompListCoverage--'+solcompListCoverage);
            for(CSS_Solution_component__c sol :solcompListCoverage){
                claimsSRTListWrapper solWrap = new claimsSRTListWrapper();
                if(sol.CoverageLimitExceedMsgSRT_Status__c == 'ERROR'){
                    solWrap.odmStatus=sol.CoverageLimitExceedMsgSRT_Status__c;
                    solWrap.odmStatusMsg='Error: '+sol.CoverageLimitExceedMsgSRT__c;
                }
                wrapclaimsSRTList.add(solWrap);
                system.debug('***wrapclaimsSRTList***'+wrapclaimsSRTList);
            }
        }
        //End
        System.debug('SOQL Count so far ' + Limits.getQueries());
    }

    public class claimsSCListWrapper{
        public String failcode{get;set;}
        public String odmStatus{get;set;}
        public String odmStatusMsg{get;set;}
    }

    public class claimsPOListWrapper{
        public String partnumber{get;set;}
        public String odmStatus{get;set;}
        public String odmStatusMsg{get;set;}
    }

    public class claimsSRTListWrapper{
        public String failcode{get;set;}
        public String odmStatus{get;set;}
        public String odmStatusMsg{get;set;}
    }
}