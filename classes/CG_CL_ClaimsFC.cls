/**********************************************************************
Name:CG_CL_ClaimsFC
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
We are using this  Controller for  Claims Failures & Campaigns Page.
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.0 -      Surender M        02/12/2018          Added Constructor & Updated Navigations & implementation of Campaigns functionality
***********************************************************************/
public class CG_CL_ClaimsFC 
{
    public CG_CL_ClaimsFC controllerRef{set;get;}
    public String fcErrorMessage{get;set;}  
    public Id cId{get;set;}
    public CSS_Claims__c claimsRec{set;get;}
    public CSS_PSN__c psnRec{set;get;}
    public string temp{set;get;}
    public boolean showErrorPopup{get;set;}
    public String pageName;
    public Boolean psncheck {get;set;}
    public List<CSS_Solution_Component__c> solComps;
    public boolean checkAccountCode{get; set;}
    public List<CSS_SRT__c> WSSRTList = new List<CSS_SRT__c>();
    List<CSS_Solution_Component__c> solutionList = new List<CSS_Solution_Component__c>();
    public Boolean isOnlyFieldAction{get;set;}
    public Boolean isOnlyFailure{get;set;}
    public Boolean allInShopYes{get;set;}
    public Boolean allInShopFieldAction{get;set;}
    public Boolean campaignTravelPercentage{get;set;}
    public Boolean covTravelMiles{get;set;}
    public Boolean inShopSrtFlag{get;set;}
    public String failCodeFASrt_admSRT{get;set;}
    public String accCodeFASrt_admSRT{get;set;}
    public String failCodeFA_admSRT{get;set;}
    public String accCodeFA_admSRT{get;set;}
    public Boolean adminSrt904Flag{get;set;}
    public String Fail_failCodeFA_admSRT{get;set;}
    public String Fail_accCodeFA_admSRT{get;set;}
    public static list<CG_ODM_ResJSONParser.message> ODMFailurePageDisplayMsgs{get;set;}
    //Create a map for account code and fail code combo for failures.
    public Map<string, CSS_Solution_Component__c> accFailFailuresMap = new Map<string, CSS_Solution_Component__c>();
    public String admSRTtype{get;set;}
    public Boolean warrantyFailure{get;set;}
    public List<CSS_SRT__c> srtFieldList;
    public List<CSS_Solution_Component__c> fieldcompList;
    public String fieldActionStatus;
    public transient List<CSS_Solution_Component__c> compList = new List<CSS_Solution_Component__c>(); 
    //Constructor.
    public CG_CL_ClaimsFC()
    {
        //fcErrorMessage = 'TEST';
        fcErrorMessage = fcErrorMessage;
        String tempStr = Label.CG_BillTo;
        System.debug('IN CG_CL_ClaimsFC constructor...');
        try {
            psncheck = false;
            checkAccountCode=false;
            solComps = new List<CSS_Solution_Component__c>();
            temp = 'testing12345';
            controllerRef = this;
            cId=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('MyClaimId>>>>:'+cId);
            if(cId == null) {
                claimsRec = new CSS_Claims__c();  
                psnRec = new CSS_PSN__c(); 
            } else {    
                /* claimsRec =[Select Id,Account__r.region__c,Account__r.ERP_System__c,Customer_Name__c,Service_Model__c,Location__c,CSS_Channel_Of_Distribution__c,SP_CLAIM_ALLOWED_DAYS__c,SP_CMI_SP_EXPIRATION__c,SP_LTA_FLAG__c,OemCode__c,SP_OUTFILE_ALL_CLAIMS__c,SP_PACCAR__c,SP_Region__c,SP_RegionCode__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,BillToCode__c,DesignPhaseCode__c,EngineFamilyCode__c,Location_Code__c,CSS_Job__c,CSS_Job__r.name,CSS_Job__r.createddate,Shop_Work_Order__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,CoverageResponse__c, 
(Select Id,Name,PSN__c,Before_In_Service__c,Service_Model__c,Make__c,ApplicationCode__c,Application__c,Qsol_Engine_Family_Code__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,
Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
from CSS_Claims__c where id= :cId]; */
                //Added Engine and SP data in query as part of ODM
                claimsRec = [Select Id,LastSavedDate__c,IsCopyclaim__c,isAutomatedCopyClaim__c,Last_saved_by__c,IsDealerCreatedClaim__c,MileageProdHrsError__c,Failures_ODM_Status__c,SRTs_ODM_Status__c,Parts_ODM_Status__c ,ODM_Status__c,ODM_Status_Message__c,ReconEngineFlag__c,Account__r.isCampTrp__c,Account__r.region__c,AccessCode__c,FieldActionWebServiceResult__c,PolicyClaim__c, Automotive_App_Flag__c,Account__r.ERP_System__c,Information_Only_Claim__c,Customer_Name__c,Service_Model__c,Location__c,CSS_Channel_Of_Distribution__c,SP_CLAIM_ALLOWED_DAYS__c,SP_CMI_SP_EXPIRATION__c,SP_LTA_FLAG__c,OemCode__c,SP_OUTFILE_ALL_CLAIMS__c,SP_PACCAR__c,SP_Region__c,
                             SP_RegionCode__c,SP_WarrantyCertificationEndDate__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,BillToCode__c,DesignPhaseCode__c,EngineFamilyCode__c,Location_Code__c,CSS_Job__c,CSS_Job__r.name,CSS_Job__r.createddate,Shop_Work_Order__c,LastModifiedDate,Name, ESN__c, 
                             createdDate,CSS_Channel_Code__c,Account__r.RSS_RESP_BRANCH_CODE__c,SP_Country__c,EngineFamilyName__c,ProductApplicationCode__c,Account__c, Region__c,Territory__c,CoverageResponse__c,Status__c,CSS_Job__r.Date_in_Shop__c,CSS_Job__r.Date_in__c,CSS_Job__r.Repeat_Or_Recent_Calc__c,CSS_Job__r.RecentVisit__c,Address__c,Authorization_Comments__c,Catastrophic__c,Contact_First_Name__c,
                             Contact_Id__c,Contact_Last_Name__c,Country__c,Parts_Warranty_Claim_Only__c,Customer_Code__c,Customer_Contact_Phone__c,Actual_Technician_Time__c,Customer_Phone__c,TSR1__c, TSR2__c, TSR3__c, TSR4__c, TSR5__c, TSR6__c, TSR7__c, TSR8__c, TSR9__c, TSR10__c,Claims_city__c,Dealer_Service_Job__r.Name,
                             Distributor_Authorization_FN__c,Multi_PSN_Claim__c,CSS_Job__r.Status__c,Distributor_Authorization_LN__c,Distributor_Authorization_WWID__c,Email_Address__c,PACCAR_Authorization_FN__c,PACCAR_Authorization_LN__c, EtoConversionDate__c, MarineFlag__c,ProductApplicationDesp__c,warrantyIndicatorFlag__c,
                             PACCAR_Authorization_WWID__c,Repair_Completion__c,Repair_Location__c,Service_Date__c,State__c,ZipCode__c,CSS_Job__r.LastUpdateSubStatus__c,BuildDate__c,SP_CHANNEL_OF_DISTRIBUTION__c,SP_Group_Name__c,SP_TERRITORY__c,
                             SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_PrimaryOEMCode__c,SP_State__c,SP_SCMDeductiblePercentage__c,SP_INSHOP_LABOR_RATE__c,
                             (Select Id,Name,PSN__c,Failure_Point__c,AccessCode__c, Before_In_Service__c,Service_Model__c,Make__c,ApplicationCode__c,Application__c,Qsol_Engine_Family_Code__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c, 
                              Location_Certification__c,Warranty_Authorization_Flag__c,Calibration_After__c,Calibration_Before__c,Justification__c,License_Plate_State__c,Mission_Disabling__c,Model__c,Primary__c,Equipment_ID__c,Qsol_Technical_Config__c,Qsol_Warranty_Start__c,Unit_Number__c,Unit_Type__c,VIN__c 
                              from CSS_PSNs__r where Primary__c=true Limit 1)
                             from CSS_Claims__c where id= :cId];
                //****************************************************************Getting Multi-PSN chevron basend on condition from Solution component Object 154239 By RAJESH *****************************************************************************************************                
                solComps = [select Id, AccountCode_Call_Status__c,Claim_FailCode__c,CampaignTravelPercentage__c,CampaignLaborPercentage__c,CoveredTravelMiles__c,Fail_Code__c,type__c,CoveredLaborHrs__c,Selected_Component__c,AccountCode__c,CSS_Account_Formula__c,CSS_Primary_Failure__c, FailCode_Formula__c, In_Shop_SRT_Limit_Flag__c
                            from CSS_Solution_Component__c
                            where CSS_Claims__c =:claimsRec.id AND Selected_Component__c!=false AND ((Type__c NOT IN ('TRP','Campaign','ATC')) OR (Type__c IN ('Campaign','ATC','TRP') AND Status__c='Approved')) order By CSS_Failure_Sequence_Number__c asc];  //Selected_Component__c = true - condition is removed since select checkbox is removed from UI
                isOnlyFieldAction = true;
                allInShopYes = true;
                inShopSrtFlag= true;
                campaignTravelPercentage = false;
                covTravelMiles = false;
                system.debug('******claimsRec[0].CSS_PSNs__r.ApplicationCode__c****'+claimsRec.CSS_PSNs__r[0].ApplicationCode__c);
                for(css_solution_component__c SC: solComps){
                    if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !='' && SC.Type__c != 'TRP' && SC.Selected_Component__c == true){
                        checkAccountCode=true;
                    }
                    system.debug('adminSRTFail**1'+campaignTravelPercentage+'tes'+SC.Selected_Component__c);
                    if(SC.Selected_Component__c == true && SC.CampaignTravelPercentage__c!=null && SC.CampaignTravelPercentage__c!='' && SC.CampaignTravelPercentage__c<='0'){
                        campaignTravelPercentage = true;                    
                    }
                    if(SC.Type__c == null || SC.Type__c == ''){
                        if(SC.AccountCode_Call_Status__c == 'Failure'){
                            system.debug('***InsidewarrantyfailureIf***');
                            warrantyFailure = true;
                        }
                    }
                    else{
                        if(claimsRec.Account__r.isCampTrp__c == 'Y' && SC.AccountCode_Call_Status__c == 'Failure'){
                            system.debug('***InsidewarrantyfailureIf***');
                            warrantyFailure = true;
                        }
                    }
                    if((SC.Type__c == 'Campaign' || SC.Type__c == 'TRP' || SC.Type__c == 'ATC') && SC.Selected_Component__c == true) {
                        system.debug('In_Shop_SRT_Limit_Flag__c***** ' + SC.In_Shop_SRT_Limit_Flag__c);
                        if(SC.In_Shop_SRT_Limit_Flag__c != true && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                            allInShopYes = false;
                            system.debug('Inside Field Action'+isOnlyFieldAction);
                            if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                if(failCodeFA_admSRT == null || failCodeFA_admSRT == '')
                                    failCodeFA_admSRT = SC.Fail_Code__c;
                                if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                    accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                if(admSRTtype == null || admSRTtype == '')
                                    admSRTtype = SC.Type__c;
                                system.debug('Testype'+admSRTtype);
                            }
                        }
                        //continue;
                        else if(SC.In_Shop_SRT_Limit_Flag__c != false && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                            //inShopSrtFlag= false;
                            allInShopYes = false;
                            if(failCodeFA_admSRT == null || failCodeFA_admSRT == '')
                                failCodeFA_admSRT = SC.Fail_Code__c;
                            if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                            if(admSRTtype == null || admSRTtype == '')
                                admSRTtype = SC.Type__c;

                        }
                    }
                    else{
                        isOnlyFieldAction = false;
                        system.debug('Inside Field Action'+isOnlyFieldAction);
                        system.debug('sc.CoveredTravelMiles__c**'+sc.CoveredTravelMiles__c);
                        system.debug('SC.Type__c**'+SC.Type__c);
                        if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) <= 0 && (SC.Type__c != 'Campaign' && SC.Type__c != 'TRP' && SC.Type__c != 'ATC')){
                            covTravelMiles = true;
                            system.debug('Test***');
                        }
                        system.debug('Testcovmiledsfor'+covTravelMiles);

                        if(SC.CoveredLaborHrs__c != null && SC.CoveredLaborHrs__c != '' && SC.CoveredLaborHrs__c!='0' ){
                            isOnlyFailure = true;
                            system.debug('Inside Failure'+isOnlyFailure);
                            system.debug('Inside Else Fail_accCodeFA_admSRT***'+Fail_accCodeFA_admSRT);
                            if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) > 0){
                                if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                    if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == '')
                                        Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                    if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                        Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                    if(admSRTtype == null || admSRTtype == '')
                                        admSRTtype = SC.Type__c;
                                }
                            }
                            else{
                                if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                    if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == '')
                                        Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                    if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                        Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                    if(admSRTtype == null || admSRTtype == '')
                                        admSRTtype = SC.Type__c;
                                }

                            }
                        }
                    }
                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != '')
                        accFailFailuresMap.put(SC.CSS_Account_Formula__c + '-' + SC.Fail_Code__c, SC); 
                }
                system.debug('solComps.size()****:'+solComps);
                system.debug('checkAccountCode****:'+checkAccountCode);
                if(claimsRec!=null && claimsRec.id!=null && checkAccountCode==true){
                    if(claimsRec.Multi_PSN_Claim__c== true)
                    {
                        psncheck = true;
                    }else{
                        psncheck = false;
                    }
                }
                //**************************************************************************END 154239 ************************************************************************************8                 

                if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                    psnRec = claimsRec.CSS_PSNs__r.get(0);
                }else
                    psnRec = new CSS_PSN__c(); 
                system.debug('claimsRec>>>>:'+claimsRec);
                system.debug('psnRec>>>>:'+psnRec);
                solutionList=[Select id,Over_The_Counter__c,ODM_Status__c,Selected_Component__c,ODM_Status_Message__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,In_Shop_SRT_Limit_Flag__c,Failure_Date__c,Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,Failure_Mode__c,Pay_Code__c
                              from CSS_Solution_Component__c 
                              where CSS_Claims__c = :cId ORDER BY CSS_Failure_Sequence_Number__c ASC];
            }

        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsFC constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('returning from CG_CL_ClaimsFC constructor...');
    }

    /* START Query Optimization By Krishna on Jan 27th 2020. */
    public CG_CL_ClaimsFC(String isThisConnotNeeded) {
        //Testing.
    }
    /* END Query Optimization By Krishna on Jan 27th 2020. */

    public List<CSS_SRT__c> fetchSRTWebservices(Id claimID) {
        return CSS_WS_SRT.getAllClaimsDigRepSRTs(claimID,'Admin');
    }
    //106
    public boolean mileageProdHrsError{get;set;}
    public void ClaimFcAction(){
        try{
            
            compList = [SELECT Id, Component_Id__c,FailCode_Formula__c,CSS_Account_Formula__c, Type__c, CampaignLaborPercentage__c FROM 
                        CSS_Solution_Component__c where  CSS_Claims__c =:claimsRec.id and Selected_Component__c = : true];
            system.debug('compList--'+compList);
            for(CSS_Solution_Component__c solComp:compList){
                system.debug('solComp.CSS_Account_Formula__c--'+solComp.CSS_Account_Formula__c);
                system.debug('claimsRec.Automotive_App_Flag__c--'+claimsRec.Automotive_App_Flag__c);
                system.debug('psnRec.License_Plate_State__c--'+psnRec.License_Plate_State__c);
                system.debug('psnRec.Mileage__c--'+ psnRec.Mileage__c);
                system.debug('psnRec.Product_Hours__c--'+psnRec.Product_Hours__c);
                if(solComp.CSS_Account_Formula__c != null && solComp.CSS_Account_Formula__c != '' && solComp.CSS_Account_Formula__c.contains('70')){
                    if(claimsRec.Automotive_App_Flag__c == 'Y' && psnRec.License_Plate_State__c == 'CA - California'){
                        if((psnRec.Mileage__c == null || psnRec.Mileage__c == 0) || (psnRec.Product_Hours__c == null || psnRec.Product_Hours__c == 0)){
                            //workJob.Id = Wid;
                            //workJob.MileageProdHrsError__c = 'Error';
                            mileageProdHrsError = true;
                        }
                        else{
                            //workJob.Id = Wid;
                            //workJob.MileageProdHrsError__c = 'Success';
                            mileageProdHrsError = false;
                        }
                    }

                }

            }
            CSS_Claims__c mileageProdHrsErrorUpd = new CSS_Claims__c();
            mileageProdHrsErrorUpd.Id = claimsRec.id;
            system.debug('mileageProdHrsError--'+mileageProdHrsError);
            if(mileageProdHrsError == true){
                mileageProdHrsErrorUpd.MileageProdHrsError__c = 'Error';
            }
            else{
                mileageProdHrsErrorUpd.MileageProdHrsError__c = 'Success';
            }

            update mileageProdHrsErrorUpd;
            system.debug('mileageProdHrsErrorUpd.MileageProdHrsError__c--'+mileageProdHrsErrorUpd.MileageProdHrsError__c);
        }
        catch(Exception ex){
            System.debug('Page Action >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }


    }

    public void upsertAdminSRT(CSS_Claims__c claimsRec, List<CSS_Solution_Component__c> solutionList, Boolean allInShopYesFlag, Boolean allFailuresFlag) {
        system.debug('claimsRec ' + claimsRec);
        system.debug('solutionList ' + solutionList);
        system.debug('Test232*'+admSRTtype);
        system.debug('Insidefalse value***** '+isOnlyFieldAction);
        
        //GSSC-297 - START
        String failCodeOTC;
        String accCodeOTC;
        Boolean hasOTCFailure;
        if(isOnlyFieldAction != true){
            for(CSS_Solution_Component__c sc : solutionList){
                if(sc.Over_The_Counter__c == true){
                    failCodeOTC = sc.Fail_Code__c;
                    accCodeOTC = sc.CSS_Account_Formula__c;
                    hasOTCFailure = true;
                    break;
                }
            }
        }
        system.debug('hasOTCFailure-->'+hasOTCFailure);
        system.debug('failCodeOTC-->'+failCodeOTC);
        system.debug('accCodeOTC-->'+accCodeOTC);
        //GSSC-297 - END
        
        /* START Query Optimization By Krishna on Jan 27th 2020. */
        List<CSS_SRT__c> existingAdminSRT = new List<CSS_SRT__c>();
        List<CSS_SRT__c> existingNotClaimableAdminSRT = new List<CSS_SRT__c>();
        List<CSS_SRT__c> ClaimsAllSRT = [select Id,step_id__c,SRT_Warrantable__c, Assignment__c, SRT_ID__c, Type__c, SRT_Type__c FROM CSS_SRT__c
                                                        where CSS_Claims__c =: claimsRec.Id];
        for(CSS_SRT__c srt : ClaimsAllSRT) {
            if(srt.Type__c == 'Admin' && srt.SRT_Type__c == 'Admin' && (srt.srt_id__c == '00-904-00' || srt.srt_id__c == '00-901-00' || srt.srt_id__c == '00-902-00')) {
                existingAdminSRT.add(srt);
            }
            if(((srt.Type__c == 'Admin' && srt.SRT_Type__c == 'Admin') || (srt.Type__c == 'Field Action')) 
            && (srt.srt_id__c == '00-904-00' || srt.srt_id__c == '00-901-00' || srt.srt_id__c == '00-902-00') && srt.Assignment__c == 'NOT CLAIMABLE' ) {
                existingNotClaimableAdminSRT.add(srt);
            }
        }
        

        //fetch Existing Admin SRT and pass the Id to upsert record.
        /*List<CSS_SRT__c> existingAdminSRT = [select Id,step_id__c,SRT_Warrantable__c, Assignment__c FROM CSS_SRT__c 
                                             where CSS_Claims__c =: claimsRec.Id AND
                                             Type__c = 'Admin' AND SRT_Type__c = 'Admin' AND
                                             (srt_id__c = '00-904-00' OR srt_id__c = '00-901-00' OR
                                              srt_id__c = '00-902-00') 
                                             Limit 1];

        //fetch Existing Admin SRT whose assignment = NOT CLAIMABLE.
        List<CSS_SRT__c> existingNotClaimableAdminSRT = [select Id,step_id__c,SRT_Warrantable__c, Assignment__c,SRT_ID__c FROM CSS_SRT__c 
                                                         where CSS_Claims__c =: claimsRec.Id AND
                                                         ((Type__c = 'Admin' AND SRT_Type__c = 'Admin') OR (Type__c = 'Field Action')) AND
                                                         (srt_id__c = '00-904-00' OR srt_id__c = '00-901-00' OR
                                                          srt_id__c = '00-902-00') AND Assignment__c = 'NOT CLAIMABLE'];*/

        /* END Query Optimization By Krishna on Jan 27th 2020. */

        string OldSRTID;
        Boolean isNotClaimable901 = false;
        Boolean isNotClaimable902 = false;
        Boolean isNotClaimable904 = false;
        for(CSS_SRT__c adsrt : existingNotClaimableAdminSRT){
            if(adsrt.SRT_ID__c == '00-901-00'){
                isNotClaimable901 = true;
            }
            if(adsrt.SRT_ID__c == '00-902-00'){
                isNotClaimable902 = true;
            }
            if(adsrt.SRT_ID__c == '00-904-00'){
                isNotClaimable904 = true;
            }
        }
        if(existingAdminSRT != null && existingAdminSRT.size() > 0){
            OldSRTID = existingAdminSRT[0].Id;
        }

        system.debug('existingAdminSRT**'+existingAdminSRT);
        List<CSS_SRT__c> srtOrderLst = [select Id, CSS_Claims__r.SP_INSHOP_LABOR_RATE__c FROM CSS_SRT__c 
                                        where CSS_Claims__c =: claimsRec.Id AND Id !=: OldSRTID AND
                                        (SRT_Category__c = 'AdditionalDiag' OR (Type__c = 'Diagnosis' OR Type__c = 'Diag Access'))
                                       ]; 
        system.debug('srtOrderLst ' + srtOrderLst);
        String inShopLaborRate;
        // if(srtOrderLst != null && srtOrderLst.size()>0) // Kalpana, Added null check
        //inShopLaborRate = srtOrderLst[0].CSS_Claims__r.SP_INSHOP_LABOR_RATE__c;
        inShopLaborRate = claimsRec.SP_INSHOP_LABOR_RATE__c; //defect 184868 Fix:Commented above lines, as Inshoplabor rate is from claim, we should get it directly from there. Otherwise,in case of null SRTOrderList, it gives error.
        system.debug('inShopLaborRate**'+inShopLaborRate);
        CSS_srt__c adminSRT = new CSS_srt__c();
        if(existingAdminSRT != null && existingAdminSRT.size() > 0){
            adminSRT.Id = OldSRTID;
            adminSRT.SRT_Warrantable__c = existingAdminSRT[0].SRT_Warrantable__c;
        } 
        //Flow chart Filteration for SRT Id.
        system.debug('Application**'+claimsRec.CSS_PSNs__r[0].Application__c);
        system.debug('AppCode**'+claimsRec.CSS_PSNs__r[0].ApplicationCode__c);
        /*if(claimsRec.CSS_PSNs__r[0].Application__c == 'Recreational Vehicle' || claimsRec.CSS_PSNs__r[0].Application__c == 'Marine Recreational') {*/
        //Kalpana, commented the above if condition and added the below if condition, as part of defect fix 165811
        //GSSC-297 - START
        system.debug('isNotClaimable901--'+isNotClaimable901+'hasOTCFailure--'+hasOTCFailure);
        if(hasOTCFailure == true && isNotClaimable901 == false){
            adminSRT.srt_id__c = '00-901-00';
            system.debug('Inside inshop Admin74');
        }
        else{ //GSSC-297 - END
            if(claimsRec.CSS_PSNs__r[0].ApplicationCode__c == '310' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c == '320' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c == '610') {
                if((allInShopYesFlag == true) || (isNotClaimable904 == false && allInShopYesFlag == false) || (allFailuresFlag == true)){
                    adminSRT.srt_id__c = '00-904-00';
                    // adminSRT.Step_Id__c = '00-904-63601';
                    adminSrt904Flag = false;
                }
                else
                    return;
            } 
            else if(claimsRec.Repair_Location__c == 'In Shop'){
                system.debug('Inside inshop Admin93'+allInShopYesFlag);
                if((allInShopYesFlag == true) || (isNotClaimable901 == false && allInShopYesFlag == false) || (allFailuresFlag == true) ){
                    adminSRT.srt_id__c = '00-901-00';
                    system.debug('Inside inshop Admin93');
                    // adminSRT.Step_Id__c = '00-901-2987';
                }
                else
                    return;
            } 
            else if (claimsRec.Repair_Location__c == 'Mobile') {
                if(solutionList != null && solutionList.size() > 0) {
                    for(CSS_Solution_Component__c sc : solutionList) {
                        if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) > 0 && allFailuresFlag == true || sc.CampaignTravelPercentage__c != null && integer.valueOf(sc.CampaignTravelPercentage__c) > 0 && allInShopYesFlag == false) {
                            system.debug('TEst343'+sc.CoveredTravelMiles__c);
                            if((allInShopYesFlag == true) || (isNotClaimable902 == false && allInShopYesFlag == false) || (allFailuresFlag == true)){
                                adminSRT.srt_id__c = '00-902-00';
                                failCodeFA_admSRT = sc.Fail_Code__c;//Anirudh defect # 184879
                                accCodeFA_admSRT = sc.CSS_Account_Formula__c;
                                adminSRT.SRT_Category__c = 'AdditionalDiag';
                                //adminSRT.Step_Id__c = '00-902-131337';
                                break;
                            }
                            else
                                return;
                        }
                    }
                    if(adminSRT.srt_id__c == null) {
                        if((allInShopYesFlag == true) || (isNotClaimable901 == false && allInShopYesFlag == false) || (allFailuresFlag == true))
                            adminSRT.srt_id__c = '00-901-00';
                        else
                            return;
                    }
                } 
                else {
                    if(( allInShopYesFlag == true) || (isNotClaimable901 == false && allInShopYesFlag == false) || (allFailuresFlag == true))
                        adminSRT.srt_id__c = '00-901-00';
                    else
                        return;
                }
            } 
            else {
                if((allInShopYesFlag == true) || (isNotClaimable901 == false && allInShopYesFlag == false) || (allFailuresFlag == true))
                  {  adminSRT.srt_id__c = '00-901-00';
                    system.debug('Inside inshop Admin33');
                  }
                else
                    return;
            }
        }
        system.debug('Testsrtadmin'+adminSRT.srt_id__c);
        adminSRT.SRT_Quantity__c = 1;
        adminSRT.isPerformed__c = true;
        //system.debug('existingAdminSRT[0].SRT_Warrantable__c**'+existingAdminSRT[0].SRT_Warrantable__c);
        if(adminSRT.SRT_Warrantable__c != null && adminSRT.SRT_Warrantable__c != '')
            adminSRT.SRT_Warrantable__c = adminSRT.SRT_Warrantable__c;
        else 
            adminSRT.SRT_Warrantable__c = '100';
        adminSRT.CSS_Claims__c = claimsRec.Id;
        if(srtOrderLst != null)
            adminSRT.SRT_Order__c = srtOrderLst.size()+1;
        else
            adminSRT.SRT_Order__c = 1;

        system.debug('WSSRTList** ' + WSSRTList);
        
        if(solutionList != null && solutionList.size() >0) //S-429
        	WSSRTList = fetchSRTWebservices(cId);//Admin SRT code
        system.debug('WSSRTList >>> ' + WSSRTList); 
        
        for(CSS_SRT__c srt : WSSRTList) {
            if(srt.SRT_ID__c == adminSRT.srt_id__c) {
                system.debug('SRT ' + srt);
                adminSRT.SRT_Title__c = srt.SRT_Title__c;
                adminSRT.SRT_Time__c = srt.SRT_Time__c;
                //Defect: #165278 - Added by Krishna 
                adminSRT.Access_Code_A__c = srt.Access_Code_A__c;
                adminSRT.Access_Code_B__c = srt.Access_Code_B__c;
                adminSRT.Access_Code_C__c = srt.Access_Code_C__c;
                adminSRT.Access_Code_D__c = srt.Access_Code_D__c;
                adminSRT.Access_Code_R__c = srt.Access_Code_R__c;
                //Defect: #165278 - Added by Krishna 
                //story#172627
                adminSRT.SRT_Access_Code__c=srt.SRT_Access_Code__c;
                adminSRT.Access_Code__c=srt.Access_Code__c;
                adminSRT.step_id__c = srt.step_id__c; //existing stepid
                //end
                break;
            }
        }
        system.debug('Testcode'+isOnlyFailure+'srt_id__c'+adminSRT.srt_id__c+'covTravelMiles'+covTravelMiles);
        //Pass the account code and fail code in Admin SRT.
        system.debug('accFailFailuresMap ' + accFailFailuresMap);
        //Added below if condition as part of the story GSSC-297
        if(hasOTCFailure == true){
            adminSRT.FailCode__c = failCodeOTC;

            if(inShopLaborRate != null && inShopLaborRate != '' && decimal.valueof(inShopLaborRate) > 0){
                adminSRT.Account_Code__c = accCodeOTC;
            }
            adminSRT.Type__c = 'Admin';
            adminSRT.SRT_Type__c = 'Admin';
            adminSRT.SRT_Category__c = 'AdditionalDiag';
        } //Changed below if condition to else if condition as part of the story GSSC-297
        else if(isOnlyFieldAction == true && isOnlyFailure != true){
            adminSRT.FailCode__c = failCodeFA_admSRT;

            if(inShopLaborRate != null && inShopLaborRate != '' && decimal.valueof(inShopLaborRate) > 0){
                adminSRT.Account_Code__c = accCodeFA_admSRT;
            }
            // adminSRT.Account_Code__c = accCodeFA_admSRT; commment and added as part of defect 181959 
            adminSRT.Type__c = 'Admin';
            adminSRT.SRT_Type__c = 'Admin';
            adminSRT.SRT_Category__c = admSRTtype;
        }

        else if(isOnlyFailure == true && adminSRT.srt_id__c == '00-902-00' && covTravelMiles == false){
            adminSRT.FailCode__c = Fail_failCodeFA_admSRT;
            if(inShopLaborRate != null && inShopLaborRate != '' && decimal.valueof(inShopLaborRate) > 0){
                adminSRT.Account_Code__c = Fail_accCodeFA_admSRT;
            }
            //adminSRT.Account_Code__c = Fail_accCodeFA_admSRT;
            adminSRT.Type__c = 'Admin';
            adminSRT.SRT_Type__c = 'Admin';
            adminSRT.SRT_Category__c = 'AdditionalDiag';
            system.debug('adminSRTFailCode__c**'+adminSRT.FailCode__c);
            system.debug('adminSRTAccCode__c**'+adminSRT.Account_Code__c);
        } 
        else{
            if(isOnlyFailure == true && adminSRT.srt_id__c != '00-902-00'){
                adminSRT.FailCode__c = Fail_failCodeFA_admSRT;
                if(inShopLaborRate != null && inShopLaborRate != '' && decimal.valueof(inShopLaborRate) > 0){
                    adminSRT.Account_Code__c = Fail_accCodeFA_admSRT;
                }   
                adminSRT.Type__c = 'Admin';
                adminSRT.SRT_Type__c = 'Admin';
                adminSRT.SRT_Category__c = 'AdditionalDiag';
                system.debug('adminSRTFailCode__c@@'+adminSRT.FailCode__c);
                system.debug('adminSRTAccCode__c@@'+adminSRT.Account_Code__c);
            }
            else{
                if(failCodeFA_admSRT != null && failCodeFA_admSRT != '')
                adminSRT.FailCode__c = failCodeFA_admSRT;
                /*else {
                    if(solutionList != null && solutionList.size()>0)
                adminSRT.FailCode__c = solutionList[0].Fail_Code__c;
                }*/
                if(inShopLaborRate != null && inShopLaborRate != '' && decimal.valueof(inShopLaborRate) > 0){
                    if(accCodeFA_admSRT != null && accCodeFA_admSRT != '')
                    adminSRT.Account_Code__c = accCodeFA_admSRT;
                    /*else{
                        if(solutionList != null && solutionList.size()>0)
                    adminSRT.Account_Code__c = solutionList[0].CSS_Account_Formula__c;}*/
                }   
                adminSRT.Type__c = 'Admin';
                adminSRT.SRT_Type__c = 'Admin';
                if(admSRTtype != null && admSRTtype != '') //Testing, defect GSSC-559
                adminSRT.SRT_Category__c = admSRTtype;
                else
                adminSRT.SRT_Category__c = 'AdditionalDiag'; //Testing, defect GSSC-559
                if(adminSRT.Access_Code__c == null || adminSRT.Access_Code__c == '')
                adminSRT.Access_Code__c = 'C'; //Testing, defect GSSC-559
                system.debug('adminSRTFailCode__c@@'+adminSRT.FailCode__c);
                system.debug('adminSRTAccCode__c@@'+adminSRT.Account_Code__c);
            }
        }
        system.debug('Testcat'+adminSRT.SRT_Category__c);
        system.debug('adminSRTFail**1'+campaignTravelPercentage+'Terst'+covTravelMiles+'22'+isNotClaimable901+'33'+allInShopYesFlag+'444'+allFailuresFlag);
        //if((campaignTravelPercentage == true && claimsRec.Repair_Location__c == 'Mobile') || isOnlyFailure == true && covTravelMiles == true && claimsRec.Repair_Location__c == 'Mobile'){
        //if((isNotClaimable901 == false && allInShopYesFlag == true ) || (allInShopYesFlag == false) || (allFailuresFlag == true))
        if(claimsRec.Repair_Location__c == 'Mobile' && hasOTCFailure != true){ //Added hasOTCFailure != true condition as part of the story GSSC-297
            if(((allFailuresFlag == false && campaignTravelPercentage == true) && (allFailuresFlag == true && covTravelMiles == true))){
                if((allInShopYesFlag == true  ) || (isNotClaimable901 == false &&  allInShopYesFlag == false ) || (allFailuresFlag == true ))
                    {
                        adminSRT.srt_id__c = '00-901-00';
                         system.debug('Inside inshop Admin563');
                    }
                else
                    return;
            }

            else if(adminSrt904Flag == false){
                if((allInShopYesFlag == true) || (isNotClaimable904 == false && allInShopYesFlag == false) || (allFailuresFlag == true))
                    adminSRT.srt_id__c = '00-904-00';
                else
                    return;

            }

            else if((allInShopYesFlag == false && campaignTravelPercentage == false) || (allFailuresFlag == true && covTravelMiles == false)) {
                system.debug('Test'+isNotClaimable902+' '+allInShopYesFlag+' '+campaignTravelPercentage);
                if((allInShopYesFlag == true  ) || (isNotClaimable902 == false && allInShopYesFlag == false ) || (allFailuresFlag == true)){
                    adminSRT.srt_id__c = '00-902-00';
                    //adminSRT.FailCode__c = failCodeFA_admSRT;
                    //adminSRT.Account_Code__c = accCodeFA_admSRT;
                    //system.debug('testadmin33'+adminSRT.FailCode__c+'  '+adminSRT.Account_Code__c);
                }
                else
                    return;
            }
        }
        //Story 155910:END
        //DML Oepration.

        //Adding StepsIds if blank
        if(adminSRT.step_id__c == null || adminSRT.step_id__c  == ''){
            system.debug('****stepid****');
            if(adminSRT.srt_id__c == '00-901-00') {
                adminSRT.step_id__c = '2987';
            }
            if(adminSRT.srt_id__c == '00-904-00') {
                adminSRT.step_id__c = '63601';
            }
            if(adminSRT.srt_id__c == '00-902-00') {
                adminSRT.step_id__c = '131337';
            }
        }


        system.debug('Test232'+adminSRT.SRT_Category__c);
        system.debug('adminSRT '+ adminSRT);
        upsert adminSRT;
        system.debug('adminSRT '+ adminSRT);
    } 

    //Naviagation to Warranty Overview.
    public PageReference nvClaimsIntake(){
        PageReference pageRef;
        boolean HeaderValidation;
        boolean FailureValidation;
        boolean callFailureOnInfoOnlyClaim;
        //cId = saveClaim(cId, 'Draft');
        try{
            if(cId != null){

                solutionList=[Select id,Over_The_Counter__c,ODM_Status__c,CoveredTravelMiles__c, Selected_Component__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,
                              Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,
                              Approval_Code__c,Authorization_Number__c,CoveredLaborHrs__c,In_Shop_SRT_Limit_Flag__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,
                              Failure_Mode__c,Pay_Code__c,Type__c,CampaignTravelPercentage__c,AccountCode_Call_Status__c,RoadRelay_Warranty__c, Performed_Review__c,CampaignLaborPercentage__c, Fail_Code__c,CSS_Claims__c,ODM_Penalty__c
                              from CSS_Solution_Component__c 
                              where CSS_Claims__c = :cId 
                              AND ((Type__c != null AND Performed_Review__c = true) OR 
                                   (Type__c = null AND Selected_Component__c = true) OR 
                                   (CSS_Claims__c != null AND Selected_Component__c = true)) ORDER BY CSS_Failure_Sequence_Number__c ASC];
                Id solCompId;
                if(solutionList != null && solutionList.size() >0){                   
                    isOnlyFieldAction = true;
                    allInShopYes = true;
                    for(css_solution_component__c SC: solutionList){
                        if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                            checkAccountCode=true;
                        }

                        system.debug('adminSRTFail**1'+campaignTravelPercentage+'tes'+SC.Selected_Component__c);
                        if(SC.Selected_Component__c == true && SC.CampaignTravelPercentage__c!=null && SC.CampaignTravelPercentage__c!='' && SC.CampaignTravelPercentage__c<='0'){
                            campaignTravelPercentage = true;                    
                        }
                        if(SC.Type__c == null || SC.Type__c == ''){
                            if(SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }
                        else{
                            if(claimsRec.Account__r.isCampTrp__c == 'Y' && SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }

                        if((SC.Type__c == 'Campaign' || SC.Type__c == 'TRP' || SC.Type__c == 'ATC') && SC.Selected_Component__c == true) {
                            system.debug('In_Shop_SRT_Limit_Flag__c***** ' + SC.In_Shop_SRT_Limit_Flag__c);
                            if(SC.In_Shop_SRT_Limit_Flag__c != true && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                allInShopYes = false;
                                system.debug('Inside Field Action'+isOnlyFieldAction);
                                if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                    if(failCodeFA_admSRT == null || failCodeFA_admSRT == ''){
                                        failCodeFA_admSRT = SC.Fail_Code__c;
                                        solCompId = SC.Id;
                                    }
                                    if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                        accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                    if(admSRTtype == null || admSRTtype == '')
                                        admSRTtype = SC.Type__c;
                                }
                            }
                            //continue;
                            else if(SC.In_Shop_SRT_Limit_Flag__c != false && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                //inShopSrtFlag= false;
                                allInShopYes = false;
                                if(failCodeFA_admSRT == null || failCodeFA_admSRT == '')
                                    failCodeFA_admSRT = SC.Fail_Code__c;
                                if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                    accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                if(admSRTtype == null || admSRTtype == '')
                                    admSRTtype = SC.Type__c;

                            }
                        }
                        else{
                            isOnlyFieldAction = false;
                            system.debug('Inside Field Action'+isOnlyFieldAction);
                            if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) <= 0){
                                covTravelMiles = true;
                            }
                            if(SC.CoveredLaborHrs__c != null && SC.CoveredLaborHrs__c != '' && SC.CoveredLaborHrs__c!='0' ){
                                isOnlyFailure = true;
                                system.debug('Inside Failure'+isOnlyFailure);
                                system.debug('Inside CoveredTravelMiles__c'+SC.CoveredTravelMiles__c);
                                system.debug('Inside CSS_Account_Formula__c'+SC.CSS_Account_Formula__c);
                                if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) > 0){
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }
                                }
                                else{
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }

                                }
                            }
                        }
                    }
                }


                if(solutionList != null && solutionList.size() >0)
                    WSSRTList = fetchSRTWebservices(cId);//Admin SRT code
                system.debug('WSSRTList >>> ' + WSSRTList);

                //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
                /****************************************************************************************************************************/

                HeaderValidation = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');//Header validation 


                //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
                Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
                IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
                {
                    //If the information only check box is checked then claims cannot receive warranty reimbursement. 
                    if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null || claimsRec.CSS_Job__c=='')) 
                    { 
                        FailureValidation = false;
                    }
                    //Else go ahead and do ODM validation
                    else
                    {

                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');

                    }
                }
                else//Distributor eligible for automated and manual claim hence no condition
                {
                    for(CSS_Solution_Component__c scomp:solutionList)
                    {
                        if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                        {
                            callFailureOnInfoOnlyClaim = false;
                            break;
                        }
                        else
                        {
                            callFailureOnInfoOnlyClaim = true;

                        }
                    }
                    if(callFailureOnInfoOnlyClaim == true)//ODM Pre submit Validation 

                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');

                }

                List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
                system.debug('fieldActionsLst-->'+fieldActionsLst);
                ODMFailurePageDisplayMsgs = CG_BL_ODM.calljobODMHeaderFailureValidationService('CLAIM');//ODM Header validation


                /***********************************************************************************************************************************************************/ 
                try {
                    if(solutionList != null && solutionList.size() > 0){
                        if((isOnlyFieldAction == true) || (isOnlyFailure == true)){
                            upsertAdminSRT(claimsRec, solutionList, allInShopYes, isOnlyFailure);
                        }
                    }
                    //  upserClaimsPolicy(claimsRec, solutionList);
                } catch(Exception ex){
                    System.debug('ADMIN SRT Intake >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
                if(fieldActionsLst != null && fieldActionsLst.size() > 0){
                    insert fieldActionsLst;
                }
                system.debug('After insert fieldActionsLst-->'+fieldActionsLst);
                CSS_Claims__c claimsUpd = new CSS_Claims__c();
                claimsUpd.Id = cId;
                if(fieldActionStatus != null && fieldActionStatus != ''){
                    claimsUpd.FieldActionWebServiceResult__c = fieldActionStatus;
                    if(claimsUpd.Id != null){
                        update claimsUpd;
                    }
                }
                
            }
            clmJobNotesAction(); //Added as part of the defect GSSC-423
        } catch(Exception ex){
            System.debug('in catch of CG_ClaimsIntake >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }

        pageName='CG_ClaimsIntake';

        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service
        if(HeaderValidation == true || FailureValidation == true)
            showErrorPopup=true;

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsIntake'); 
        }else{
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            contr.checkFailuresCovered(cId, true); //moved outside if as part of the task 189212
            //Added as part of the story #179800, 178812 ,178902 
            if(claimsRec.CSS_Job__c == null && claimsRec.Dealer_Service_Job__c == null){
                contr.covLimitValidation(null, cId, null, null);
                contr.covLimitValidationTTML(null,cId,null,true);
                contr.covLimitValidationSRT(null,cId);
                contr.covLimitfailcodeValidation(null,cId);
            }
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); 
            }
        }
      
        return pageRef;
    }

    //Naviagation to Warranty Coverage.
    public PageReference nvClaimsWC(){
        PageReference pageRef;
        boolean HeaderValidation;
        boolean FailureValidation;
        boolean callFailureOnInfoOnlyClaim;
        //cId = saveClaim(cId, 'Draft');
        try{
            if(cId != null){
                solutionList=[Select id,Over_The_Counter__c,ODM_Status__c,CoveredTravelMiles__c, Selected_Component__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,
                              Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,
                              Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,
                              Failure_Mode__c,Pay_Code__c, Type__c,CoveredLaborHrs__c,CampaignTravelPercentage__c,AccountCode_Call_Status__c,CampaignLaborPercentage__c,In_Shop_SRT_Limit_Flag__c,Performed_Review__c,RoadRelay_Warranty__c, Fail_Code__c
                              from CSS_Solution_Component__c 
                              where CSS_Claims__c = :cId 
                              AND ((Type__c != null AND Performed_Review__c = true) OR 
                                   (Type__c = null AND Selected_Component__c = true) OR 
                                   (CSS_Claims__c != null AND Selected_Component__c = true)) ORDER BY CSS_Failure_Sequence_Number__c ASC];
                Id solCompId;
                if(solutionList != null && solutionList.size() >0){                   
                    isOnlyFieldAction = true;
                    allInShopYes = true;
                    for(css_solution_component__c SC: solutionList){
                        if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                            checkAccountCode=true;
                        }
                        system.debug('adminSRTFail**1'+campaignTravelPercentage+'tes'+SC.Selected_Component__c);
                        if(SC.Selected_Component__c == true && SC.CampaignTravelPercentage__c!=null && SC.CampaignTravelPercentage__c!='' && SC.CampaignTravelPercentage__c<='0'){
                            campaignTravelPercentage = true;                    
                        }
                        if(SC.Type__c == null || SC.Type__c == ''){
                            if(SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }
                        else{
                            if(claimsRec.Account__r.isCampTrp__c == 'Y' && SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }

                        if((SC.Type__c == 'Campaign' || SC.Type__c == 'TRP' || SC.Type__c == 'ATC') && SC.Selected_Component__c == true) {
                            system.debug('In_Shop_SRT_Limit_Flag__c***** ' + SC.In_Shop_SRT_Limit_Flag__c);
                            if(SC.In_Shop_SRT_Limit_Flag__c != true && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                allInShopYes = false;
                                system.debug('Inside Field Action'+isOnlyFieldAction);
                                if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                    if(failCodeFA_admSRT == null || failCodeFA_admSRT == ''){
                                        failCodeFA_admSRT = SC.Fail_Code__c;
                                        solCompId = SC.Id;
                                    }
                                    if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                        accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                    if(admSRTtype == null || admSRTtype == '')
                                        admSRTtype = SC.Type__c;
                                }
                            }
                            //continue;
                            else if(SC.In_Shop_SRT_Limit_Flag__c != false && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                //inShopSrtFlag= false;
                                allInShopYes = false;
                                if(failCodeFA_admSRT == null || failCodeFA_admSRT == '')
                                    failCodeFA_admSRT = SC.Fail_Code__c;
                                if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                    accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                if(admSRTtype == null || admSRTtype == '')
                                    admSRTtype = SC.Type__c;

                            }
                        }
                        else{
                            isOnlyFieldAction = false;
                            system.debug('Inside Field Action'+isOnlyFieldAction);
                            if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) <= 0){
                                covTravelMiles = true;
                            }
                            if(SC.CoveredLaborHrs__c != null && SC.CoveredLaborHrs__c != '' && SC.CoveredLaborHrs__c!='0' ){
                                isOnlyFailure = true;
                                system.debug('Inside Failure'+isOnlyFailure);
                                if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) > 0){
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }
                                }
                                else{
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }

                                }
                            }
                        }
                    }
                }


                if(solutionList != null && solutionList.size() >0)
                    WSSRTList = fetchSRTWebservices(cId);//Admin SRT code
                system.debug('WSSRTList >>> ' + WSSRTList);

                //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
                /****************************************************************************************************************************/

                HeaderValidation = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');//Header validation 

                //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
                Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
                IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
                {
                    //If the information only check box is checked then claims cannot receive warranty reimbursement. 
                    if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null || claimsRec.CSS_Job__c=='')) 
                    { 
                        FailureValidation = false;
                    }
                    //Else go ahead and do ODM validation
                    else
                    {

                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');

                    }
                }
                else//Distributor eligible for automated and manual claim hence no condition
                {
                    for(CSS_Solution_Component__c scomp:solutionList)
                    {
                        if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                        {
                            callFailureOnInfoOnlyClaim = false;
                            break;
                        }
                        else
                        {
                            callFailureOnInfoOnlyClaim = true;

                        }
                    }
                    if(callFailureOnInfoOnlyClaim == true)//ODM Pre submit Validation 

                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');


                }

               List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
                ODMFailurePageDisplayMsgs = CG_BL_ODM.calljobODMHeaderFailureValidationService('CLAIM');//ODM Header validation

                /***********************************************************************************************************************************************************/ 
                try {
                    if(solutionList != null && solutionList.size() > 0){
                        if((isOnlyFieldAction == true) || (isOnlyFailure == true)){
                            upsertAdminSRT(claimsRec, solutionList,allInShopYes,isOnlyFailure);
                        }
                    }
                    //  upserClaimsPolicy(claimsRec, solutionList);
                } catch(Exception ex){
                    System.debug('ADMIN SRT WC>>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
            }
            clmJobNotesAction(); //Added as part of the defect GSSC-423
        } catch(Exception ex){
            System.debug('in catch of CG_ClaimsWarranty >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }

        pageName='CG_ClaimsWarranty';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service
        if(HeaderValidation == true || FailureValidation == true)
            showErrorPopup=true;


        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsWarranty'); 
        }else{
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            contr.checkFailuresCovered(cId, true); //moved outside if as part of the task 189212
            //Added as part of the story #179800, 178812
            if(claimsRec.CSS_Job__c == null && claimsRec.Dealer_Service_Job__c == null){
                contr.covLimitValidation(null, cId, null, null);
                contr.covLimitValidationTTML(null,cId,null,true);
                contr.covLimitValidationSRT(null,cId);
                contr.covLimitfailcodeValidation(null,cId);
            }
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsWarranty?id='+cId); 
            }
        }
        return pageRef;
    }

    //Naviagation to View History.
    public PageReference nvClaimsVH(){
        PageReference pageRef;
        boolean HeaderValidation;
        boolean FailureValidation;
        boolean callFailureOnInfoOnlyClaim;
        //cId = saveClaim(cId, 'Draft');
        try{
            if(cId != null){
                solutionList=[Select id,Over_The_Counter__c,ODM_Status__c,CoveredTravelMiles__c, Selected_Component__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,
                              Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,
                              Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,
                              Failure_Mode__c,Pay_Code__c, Type__c,CoveredLaborHrs__c,CampaignTravelPercentage__c,AccountCode_Call_Status__c,CampaignLaborPercentage__c,In_Shop_SRT_Limit_Flag__c,RoadRelay_Warranty__c, Performed_Review__c, Fail_Code__c
                              from CSS_Solution_Component__c 
                              where CSS_Claims__c = :cId 
                              AND ((Type__c != null AND Performed_Review__c = true) OR 
                                   (Type__c = null AND Selected_Component__c = true) OR 
                                   (CSS_Claims__c != null AND Selected_Component__c = true)) ORDER BY CSS_Failure_Sequence_Number__c ASC];
                Id solCompId;
                if(solutionList != null && solutionList.size() >0){                   
                    isOnlyFieldAction = true;
                    allInShopYes = true;
                    for(css_solution_component__c SC: solutionList){
                        if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                            checkAccountCode=true;
                        }

                        system.debug('adminSRTFail**1'+campaignTravelPercentage+'tes'+SC.Selected_Component__c);
                        if(SC.Selected_Component__c == true && SC.CampaignTravelPercentage__c!=null && SC.CampaignTravelPercentage__c!='' && SC.CampaignTravelPercentage__c<='0'){
                            campaignTravelPercentage = true;                    
                        }
                        if(SC.Type__c == null || SC.Type__c == ''){
                            if(SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }
                        else{
                            if(claimsRec.Account__r.isCampTrp__c == 'Y' && SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }

                        if((SC.Type__c == 'Campaign' || SC.Type__c == 'TRP' || SC.Type__c == 'ATC') && SC.Selected_Component__c == true) {
                            system.debug('In_Shop_SRT_Limit_Flag__c***** ' + SC.In_Shop_SRT_Limit_Flag__c);
                            if(SC.In_Shop_SRT_Limit_Flag__c != true && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                allInShopYes = false;
                                system.debug('Inside Field Action'+isOnlyFieldAction);
                                if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                    if(failCodeFA_admSRT == null || failCodeFA_admSRT == ''){
                                        failCodeFA_admSRT = SC.Fail_Code__c;
                                        solCompId = SC.Id;
                                    }
                                    if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                        accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                    if(admSRTtype == null || admSRTtype == '')
                                        admSRTtype = SC.Type__c;
                                }
                            }
                            //continue;
                            else if(SC.In_Shop_SRT_Limit_Flag__c != false && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                //inShopSrtFlag= false;
                                allInShopYes = false;
                                if(failCodeFA_admSRT == null || failCodeFA_admSRT == '')
                                    failCodeFA_admSRT = SC.Fail_Code__c;
                                if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                    accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                if(admSRTtype == null || admSRTtype == '')
                                    admSRTtype = SC.Type__c;

                            }
                        }
                        else{
                            isOnlyFieldAction = false;
                            system.debug('Inside Field Action'+isOnlyFieldAction);
                            if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) <= 0){
                                covTravelMiles = true;
                            }
                            if(SC.CoveredLaborHrs__c != null && SC.CoveredLaborHrs__c != '' && SC.CoveredLaborHrs__c!='0' ){
                                isOnlyFailure = true;
                                system.debug('Inside Failure'+isOnlyFailure);
                                if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) > 0){
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }
                                }
                                else{
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }

                                }
                            }
                        }
                    }
                }


                if(solutionList != null && solutionList.size() >0)
                    WSSRTList = fetchSRTWebservices(cId);//Admin SRT code
                system.debug('WSSRTList >>> ' + WSSRTList);

                //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
                /****************************************************************************************************************************/

                HeaderValidation = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');//Header validation 

                //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
                Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
                IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
                {
                    //If the information only check box is checked then claims cannot receive warranty reimbursement. 
                    if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null || claimsRec.CSS_Job__c=='')) 
                    { 
                        FailureValidation = false;
                    }
                    //Else go ahead and do ODM validation
                    else
                    {
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                    }
                }
                else//Distributor eligible for automated and manual claim hence no condition
                {
                    for(CSS_Solution_Component__c scomp:solutionList)
                    {
                        if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                        {
                            callFailureOnInfoOnlyClaim = false;
                            break;
                        }
                        else
                        {
                            callFailureOnInfoOnlyClaim = true;

                        }
                    }
                    if(callFailureOnInfoOnlyClaim == true)//ODM Pre submit Validation 
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                }

                List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
                ODMFailurePageDisplayMsgs = CG_BL_ODM.calljobODMHeaderFailureValidationService('CLAIM');//ODM Header validation

                /***********************************************************************************************************************************************************/ 
                try {
                    if(solutionList != null && solutionList.size() > 0){
                        if((isOnlyFieldAction == true) || (isOnlyFailure == true)){
                            upsertAdminSRT(claimsRec, solutionList, allInShopYes,isOnlyFailure);
                        }
                    }
                    //  upserClaimsPolicy(claimsRec, solutionList);
                } catch(Exception ex){
                    System.debug('ADMIN SRT VH >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
            }
            clmJobNotesAction(); //Added as part of the defect GSSC-423
        } catch(Exception ex){
            System.debug('in catch of CG_ClaimsVH >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }

        pageName='CG_ClaimsVH';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service
        if(HeaderValidation == true || FailureValidation == true)
            showErrorPopup=true;


        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVH'); 
        }else{
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            contr.checkFailuresCovered(cId, true); //moved outside if as part of the task 189212
            //Added as part of the story #179800, 178812
            if(claimsRec.CSS_Job__c == null && claimsRec.Dealer_Service_Job__c == null){
                contr.covLimitValidation(null, cId, null, null);
                contr.covLimitValidationTTML(null,cId,null,true);
                contr.covLimitValidationSRT(null,cId);
                contr.covLimitfailcodeValidation(null,cId);
            }
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsVH?id='+cId);
            }
        }
        return pageRef;
    }

    //Naviagation to Customer Complaint.
    public PageReference nvClaimsCC(){
        PageReference pageRef;
        boolean HeaderValidation;
        boolean FailureValidation;
        boolean callFailureOnInfoOnlyClaim;
        //cId = saveClaim(cId, 'Draft');
        try{
            if(cId != null){
                solutionList=[Select id,Over_The_Counter__c,ODM_Status__c,CoveredTravelMiles__c, Selected_Component__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,
                              Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,
                              Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,
                              Failure_Mode__c,Pay_Code__c, Type__c,RoadRelay_Warranty__c,CampaignTravelPercentage__c,AccountCode_Call_Status__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,In_Shop_SRT_Limit_Flag__c,Performed_Review__c, Fail_Code__c
                              from CSS_Solution_Component__c 
                              where CSS_Claims__c = :cId 
                              AND ((Type__c != null AND Performed_Review__c = true) OR 
                                   (Type__c = null AND Selected_Component__c = true) OR 
                                   (CSS_Claims__c != null AND Selected_Component__c = true)) ORDER BY CSS_Failure_Sequence_Number__c ASC];
                Id solCompId;
                if(solutionList != null && solutionList.size() >0){                   
                    isOnlyFieldAction = true;
                    allInShopYes = true;
                    for(css_solution_component__c SC: solutionList){
                        if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                            checkAccountCode=true;
                        }

                        system.debug('adminSRTFail**1'+campaignTravelPercentage+'tes'+SC.Selected_Component__c);
                        if(SC.Selected_Component__c == true && SC.CampaignTravelPercentage__c!=null && SC.CampaignTravelPercentage__c!='' && SC.CampaignTravelPercentage__c<='0'){
                            campaignTravelPercentage = true;                    
                        }
                        if(SC.Type__c == null || SC.Type__c == ''){
                            if(SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }
                        else{
                            if(claimsRec.Account__r.isCampTrp__c == 'Y' && SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }

                        if((SC.Type__c == 'Campaign' || SC.Type__c == 'TRP' || SC.Type__c == 'ATC') && SC.Selected_Component__c == true) {
                            system.debug('In_Shop_SRT_Limit_Flag__c***** ' + SC.In_Shop_SRT_Limit_Flag__c);
                            if(SC.In_Shop_SRT_Limit_Flag__c != true && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                allInShopYes = false;
                                system.debug('Inside Field Action'+isOnlyFieldAction);
                                if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                    if(failCodeFA_admSRT == null || failCodeFA_admSRT == ''){
                                        failCodeFA_admSRT = SC.Fail_Code__c;
                                        solCompId = SC.Id;
                                    }
                                    if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                        accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                    if(admSRTtype == null || admSRTtype == '')
                                        admSRTtype = SC.Type__c;
                                }
                            }
                            //continue;
                            else if(SC.In_Shop_SRT_Limit_Flag__c != false && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                //inShopSrtFlag= false;
                                allInShopYes = false;
                                if(failCodeFA_admSRT == null || failCodeFA_admSRT == '')
                                    failCodeFA_admSRT = SC.Fail_Code__c;
                                if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                    accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                if(admSRTtype == null || admSRTtype == '')
                                    admSRTtype = SC.Type__c;

                            }
                        }
                        else{
                            isOnlyFieldAction = false;
                            system.debug('Inside Field Action'+isOnlyFieldAction);
                            if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) <= 0){
                                covTravelMiles = true;
                            }
                            if(SC.CoveredLaborHrs__c != null && SC.CoveredLaborHrs__c != '' && SC.CoveredLaborHrs__c!='0' ){
                                isOnlyFailure = true;
                                system.debug('Inside Failure'+isOnlyFailure);
                                if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) > 0){
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }
                                }
                                else{
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }

                                }
                            }
                        }
                    }
                }


                if(solutionList != null && solutionList.size() >0)
                    WSSRTList = fetchSRTWebservices(cId);//Admin SRT code
                system.debug('WSSRTList >>> ' + WSSRTList);


                HeaderValidation = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');

               //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
                Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
                list<CSS_Solution_Component__c> tempsolist;
                IF(orgtype == true)
                {
                    if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null || claimsRec.CSS_Job__c=='')) { 
                        FailureValidation = false;
                    }
                    else{
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                    }
                }
                else{
                    for(CSS_Solution_Component__c scomp:solutionList)
                    {
                        if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A'){
                            callFailureOnInfoOnlyClaim = false;
                            break;
                        }
                        else{
                            callFailureOnInfoOnlyClaim = true;
                            //tempsolist.add(scomp); 
                        }
                    }
                    if(callFailureOnInfoOnlyClaim == true)//tempsolist.size()>0)
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                    system.debug('unique FailureValidation>>' + FailureValidation);
                }

                // FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
                ODMFailurePageDisplayMsgs = CG_BL_ODM.calljobODMHeaderFailureValidationService('CLAIM');


                try {
                    if(solutionList != null && solutionList.size() > 0){
                        if((isOnlyFieldAction == true) || (isOnlyFailure == true)){
                            upsertAdminSRT(claimsRec, solutionList, allInShopYes,isOnlyFailure);
                        }
                    }
                    //  upserClaimsPolicy(claimsRec, solutionList);
                    system.debug('after upserClaimsPolicy method call');
                } catch(Exception ex){
                    System.debug('ADMIN SRT CC >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
            }
            clmJobNotesAction(); //Added as part of the defect GSSC-423
        } catch(Exception ex){
            System.debug('in catch of CG_ClaimsCC >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }

        pageName='CG_ClaimsCC';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service
        if(HeaderValidation == true || FailureValidation == true){
            system.debug('inside FailureValidation true>>' + FailureValidation);
            showErrorPopup=true;
            system.debug('unique showErrorPopup>>' + showErrorPopup);
        }


        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsCC'); 
        }else{
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            contr.checkFailuresCovered(cId, true); //moved outside if as part of the task 189212
            //Added as part of the story #179800, 178812
            if(claimsRec.CSS_Job__c == null && claimsRec.Dealer_Service_Job__c == null){
                contr.covLimitValidation(null, cId, null, null);
                contr.covLimitValidationTTML(null,cId,null,true);
                contr.covLimitValidationSRT(null,cId);
                contr.covLimitfailcodeValidation(null,cId);
            }
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsCC?id='+cId); 
            }
        }
        return pageRef;
    }
    //Added below Method as per Silicon Valley sprint #154239 -By RAJESH 20th Aug 2018 
    public PageReference nvClaimsPSN(){
        PageReference pageRef;
        boolean HeaderValidation;
        boolean FailureValidation;
        boolean callFailureOnInfoOnlyClaim;
        //cId = saveClaim(cId, 'Draft');
        try{
            if(cId != null){
                solutionList=[Select id,Over_The_Counter__c,ODM_Status__c,CoveredTravelMiles__c, Selected_Component__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,
                              Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,
                              Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,
                              Failure_Mode__c,Pay_Code__c, Type__c,RoadRelay_Warranty__c,CampaignTravelPercentage__c,AccountCode_Call_Status__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,In_Shop_SRT_Limit_Flag__c,Performed_Review__c, Fail_Code__c
                              from CSS_Solution_Component__c 
                              where CSS_Claims__c = :cId 
                              AND ((Type__c != null AND Performed_Review__c = true) OR 
                                   (Type__c = null AND Selected_Component__c = true) OR 
                                   (CSS_Claims__c != null AND Selected_Component__c = true)) ORDER BY CSS_Failure_Sequence_Number__c ASC];
                Id solCompId;
                if(solutionList != null && solutionList.size() >0){                   
                    isOnlyFieldAction = true;
                    allInShopYes = true;
                    for(css_solution_component__c SC: solutionList){
                        if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                            checkAccountCode=true;
                        }

                        system.debug('adminSRTFail**1'+campaignTravelPercentage+'tes'+SC.Selected_Component__c);
                        if(SC.Selected_Component__c == true && SC.CampaignTravelPercentage__c!=null && SC.CampaignTravelPercentage__c!='' && SC.CampaignTravelPercentage__c<='0'){
                            campaignTravelPercentage = true;                    
                        }
                        if(SC.Type__c == null || SC.Type__c == ''){
                            if(SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }
                        else{
                            if(claimsRec.Account__r.isCampTrp__c == 'Y' && SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }

                        if((SC.Type__c == 'Campaign' || SC.Type__c == 'TRP' || SC.Type__c == 'ATC') && SC.Selected_Component__c == true) {
                            system.debug('In_Shop_SRT_Limit_Flag__c***** ' + SC.In_Shop_SRT_Limit_Flag__c);
                            if(SC.In_Shop_SRT_Limit_Flag__c != true && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                allInShopYes = false;
                                system.debug('Inside Field Action'+isOnlyFieldAction);
                                if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                    if(failCodeFA_admSRT == null || failCodeFA_admSRT == ''){
                                        failCodeFA_admSRT = SC.Fail_Code__c;
                                        solCompId = SC.Id;
                                    }
                                    if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                        accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                    if(admSRTtype == null || admSRTtype == '')
                                        admSRTtype = SC.Type__c;
                                }
                            }
                            //continue;
                            else if(SC.In_Shop_SRT_Limit_Flag__c != false && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                //inShopSrtFlag= false;
                                allInShopYes = false;
                                if(failCodeFA_admSRT == null || failCodeFA_admSRT == '')
                                    failCodeFA_admSRT = SC.Fail_Code__c;
                                if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                    accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                if(admSRTtype == null || admSRTtype == '')
                                    admSRTtype = SC.Type__c;

                            }
                        }
                        else{
                            isOnlyFieldAction = false;
                            system.debug('Inside Field Action'+isOnlyFieldAction);
                            if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) <= 0){
                                covTravelMiles = true;
                            }
                            if(SC.CoveredLaborHrs__c != null && SC.CoveredLaborHrs__c != '' && SC.CoveredLaborHrs__c!='0' ){
                                isOnlyFailure = true;
                                system.debug('Inside Failure'+isOnlyFailure);
                                if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) > 0){
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }
                                }
                                else{
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }

                                }
                            }
                        }
                    }
                }


                if(solutionList != null && solutionList.size() >0)
                    WSSRTList = fetchSRTWebservices(cId);//Admin SRT code
                system.debug('WSSRTList >>> ' + WSSRTList);

                //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
                /****************************************************************************************************************************/

                HeaderValidation = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');//Header validation 

                //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
                Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
                IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
                {
                    //If the information only check box is checked then claims cannot receive warranty reimbursement. 
                    if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null || claimsRec.CSS_Job__c=='')) 
                    { 
                        FailureValidation = false;
                    }
                    //Else go ahead and do ODM validation
                    else
                    {
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                    }
                }
                else//Distributor eligible for automated and manual claim hence no condition
                {
                    for(CSS_Solution_Component__c scomp:solutionList)
                    {
                        if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                        {
                            callFailureOnInfoOnlyClaim = false;
                            break;
                        }
                        else
                        {
                            callFailureOnInfoOnlyClaim = true;

                        }
                    }
                    if(callFailureOnInfoOnlyClaim == true)//ODM Pre submit Validation 
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                }
                  
                List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
                ODMFailurePageDisplayMsgs = CG_BL_ODM.calljobODMHeaderFailureValidationService('CLAIM');//ODM Header validation

                /***********************************************************************************************************************************************************/ 
                try {
                    if(solutionList != null && solutionList.size() > 0){
                        if((isOnlyFieldAction == true) || (isOnlyFailure == true)){
                            upsertAdminSRT(claimsRec, solutionList,allInShopYes,isOnlyFailure);
                        }
                    }
                    //  upserClaimsPolicy(claimsRec, solutionList);
                    clmJobNotesAction(); //Added as part of the defect GSSC-423
                } catch(Exception ex){
                    System.debug('ADMIN SRT PSN >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
            }
        } catch(Exception ex){
            System.debug('in catch of CG_ClaimsMultiPSN >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }

        pageName='CG_ClaimsMultiPSN';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service
        if(HeaderValidation == true || FailureValidation == true)
            showErrorPopup=true;

        System.debug('before popup showErrorPopup>>:'+showErrorPopup);
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsMultiPSN'); 
        }else{
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            contr.checkFailuresCovered(cId, true); //moved outside if as part of the task 189212
            if(claimsRec.CSS_Job__c == null && claimsRec.Dealer_Service_Job__c == null){
                contr.covLimitValidation(null, cId, null, null);
                contr.covLimitValidationTTML(null,cId,null,true);
                contr.covLimitValidationSRT(null,cId);
                contr.covLimitfailcodeValidation(null,cId);
            }
            if(showErrorPopup==true)
            {

                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsMultiPSN?id='+cId); 
            }
        }
        return pageRef;
    }

    //End 
    //Naviagation to Failures and Campaigns.
    public PageReference nvClaimsFC(){
        PageReference pageRef;
        boolean HeaderValidation;
        boolean FailureValidation;
        boolean callFailureOnInfoOnlyClaim;
        //cId = saveClaim(cId, 'Draft');
        try{
            if(cId != null){
                solutionList=[Select id,Over_The_Counter__c,ODM_Status__c,CoveredTravelMiles__c, Selected_Component__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,
                              Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,
                              Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,
                              Failure_Mode__c,Pay_Code__c, Type__c,RoadRelay_Warranty__c,CampaignTravelPercentage__c,AccountCode_Call_Status__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,In_Shop_SRT_Limit_Flag__c,Performed_Review__c, Fail_Code__c
                              from CSS_Solution_Component__c 
                              where CSS_Claims__c = :cId 
                              AND ((Type__c != null AND Performed_Review__c = true) OR 
                                   (Type__c = null AND Selected_Component__c = true) OR 
                                   (CSS_Claims__c != null AND Selected_Component__c = true)) ORDER BY CSS_Failure_Sequence_Number__c ASC];
                Id solCompId;
                if(solutionList != null && solutionList.size() >0){                   
                    isOnlyFieldAction = true;
                    allInShopYes = true;
                    for(css_solution_component__c SC: solutionList){
                        if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                            checkAccountCode=true;
                        }

                        system.debug('adminSRTFail**1'+campaignTravelPercentage+'tes'+SC.Selected_Component__c);
                        if(SC.Selected_Component__c == true && SC.CampaignTravelPercentage__c!=null && SC.CampaignTravelPercentage__c!='' && SC.CampaignTravelPercentage__c<='0'){
                            campaignTravelPercentage = true;                    
                        }
                        if(SC.Type__c == null || SC.Type__c == ''){
                            if(SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }
                        else{
                            if(claimsRec.Account__r.isCampTrp__c == 'Y' && SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }

                        if((SC.Type__c == 'Campaign' || SC.Type__c == 'TRP' || SC.Type__c == 'ATC') && SC.Selected_Component__c == true) {
                            system.debug('In_Shop_SRT_Limit_Flag__c***** ' + SC.In_Shop_SRT_Limit_Flag__c);
                            if(SC.In_Shop_SRT_Limit_Flag__c != true && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                allInShopYes = false;
                                system.debug('Inside Field Action'+isOnlyFieldAction);
                                if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                    if(failCodeFA_admSRT == null || failCodeFA_admSRT == ''){
                                        failCodeFA_admSRT = SC.Fail_Code__c;
                                        solCompId = SC.Id;
                                    }
                                    if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                        accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                    if(admSRTtype == null || admSRTtype == '')
                                        admSRTtype = SC.Type__c;
                                }
                            }
                            //continue;
                            else if(SC.In_Shop_SRT_Limit_Flag__c != false && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                //inShopSrtFlag= false;
                                allInShopYes = false;
                                if(failCodeFA_admSRT == null || failCodeFA_admSRT == '')
                                    failCodeFA_admSRT = SC.Fail_Code__c;
                                if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                    accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                if(admSRTtype == null || admSRTtype == '')
                                    admSRTtype = SC.Type__c;

                            }
                        }
                        else{
                            isOnlyFieldAction = false;
                            system.debug('Inside Field Action'+isOnlyFieldAction);
                            if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) <= 0){
                                covTravelMiles = true;
                            }
                            if(SC.CoveredLaborHrs__c != null && SC.CoveredLaborHrs__c != '' && SC.CoveredLaborHrs__c!='0' ){
                                isOnlyFailure = true;
                                system.debug('Inside Failure'+isOnlyFailure);
                                if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) > 0){
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }
                                }
                                else{
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }

                                }
                            }
                        }
                    }
                }


                if(solutionList != null && solutionList.size() >0)
                    WSSRTList = fetchSRTWebservices(cId);//Admin SRT code
                system.debug('WSSRTList >>> ' + WSSRTList);

                //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
                /****************************************************************************************************************************/

                HeaderValidation = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');//Header validation 

                //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
                Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
                IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
                {
                    //If the information only check box is checked then claims cannot receive warranty reimbursement. 
                    if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null || claimsRec.CSS_Job__c=='')) 
                    { 
                        FailureValidation = false;
                    }
                    //Else go ahead and do ODM validation
                    else
                    {
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                    }
                }
                else//Distributor eligible for automated and manual claim hence no condition
                {
                    for(CSS_Solution_Component__c scomp:solutionList)
                    {
                        if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                        {
                            callFailureOnInfoOnlyClaim = false;
                            break;
                        }
                        else
                        {
                            callFailureOnInfoOnlyClaim = true;

                        }
                    }
                    if(callFailureOnInfoOnlyClaim == true)//ODM Pre submit Validation 
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                }

                List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
                ODMFailurePageDisplayMsgs = CG_BL_ODM.calljobODMHeaderFailureValidationService('CLAIM');//ODM Header validation

                /***********************************************************************************************************************************************************/ 
                try {
                    if(solutionList != null && solutionList.size() > 0){
                        if((isOnlyFieldAction == true) || (isOnlyFailure == true)){
                            upsertAdminSRT(claimsRec, solutionList, allInShopYes,isOnlyFailure);
                        }
                    }
                } catch(Exception ex){
                    System.debug('ADMIN SRT FC >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
                clmJobNotesAction(); //Added as part of the defect GSSC-423
            }
        } catch(Exception ex){
            System.debug('in catch of CG_ClaimsFC >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }

        pageName='CG_ClaimsFC';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service
        if(HeaderValidation == true || FailureValidation == true)
            showErrorPopup=true;


        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsFC'); 
        }else{
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId); 
            }
        }
        return pageRef;
    }

    //Naviagation to Parts and Other Claimbles.
    public PageReference nvClaimsPOC(){
        PageReference pageRef;
        boolean HeaderValidation;
        boolean FailureValidation;
        boolean callFailureOnInfoOnlyClaim;
        //cId = saveClaim(cId, 'Draft');
        try{
            if(cId != null){
                solutionList=[Select id,Over_The_Counter__c,ODM_Status__c,CoveredTravelMiles__c,FailCode_Formula__c, Selected_Component__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,
                              Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,
                              Approval_Code__c,Authorization_Number__c,AccountCode_Call_Status__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,
                              Failure_Mode__c,Pay_Code__c, Type__c,RoadRelay_Warranty__c,CampaignTravelPercentage__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,In_Shop_SRT_Limit_Flag__c,Performed_Review__c, Fail_Code__c
                              from CSS_Solution_Component__c 
                              where CSS_Claims__c = :cId 
                              AND ((Type__c != null AND Performed_Review__c = true) OR 
                                   (Type__c = null AND Selected_Component__c = true) OR 
                                   (CSS_Claims__c != null AND Selected_Component__c = true)) ORDER BY CSS_Failure_Sequence_Number__c ASC];
                system.debug('Test324$');
                Id solCompId;
                if(solutionList != null && solutionList.size() >0){                   
                    isOnlyFieldAction = true;
                    allInShopYes = true;
                    for(css_solution_component__c SC: solutionList){
                        if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                            checkAccountCode=true;
                        }

                        system.debug('adminSRTFail**1'+SC.CampaignTravelPercentage__c+'tes'+SC.Selected_Component__c);
                        if(SC.Selected_Component__c == true && SC.CampaignTravelPercentage__c!=null && SC.CampaignTravelPercentage__c!='' && SC.CampaignTravelPercentage__c<='0'){
                            campaignTravelPercentage = true;                    
                        }
                        if(SC.Type__c == null || SC.Type__c == ''){
                            if(SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }
                        else{
                            if(claimsRec.Account__r.isCampTrp__c == 'Y' && SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }

                        if((SC.Type__c == 'Campaign' || SC.Type__c == 'TRP' || SC.Type__c == 'ATC') ) {
                            if(SC.Selected_Component__c == true){
                                system.debug('In_Shop_SRT_Limit_Flag__c***** ' + SC.In_Shop_SRT_Limit_Flag__c);
                                if(SC.In_Shop_SRT_Limit_Flag__c != true && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                    allInShopYes = false;
                                    system.debug('Inside Field Action'+isOnlyFieldAction);
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(failCodeFA_admSRT == null || failCodeFA_admSRT == ''){
                                            failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                            accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }
                                }
                                //continue;
                                else if(SC.In_Shop_SRT_Limit_Flag__c != false && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                    //inShopSrtFlag= false;
                                    allInShopYes = false;
                                    if(failCodeFA_admSRT == null || failCodeFA_admSRT == '')
                                        failCodeFA_admSRT = SC.Fail_Code__c;
                                    if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                        accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                    if(admSRTtype == null || admSRTtype == '')
                                        admSRTtype = SC.Type__c;

                                }
                            }
                        }
                        else{
                            isOnlyFieldAction = false;
                            system.debug('Inside Field Action'+isOnlyFieldAction);
                            if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) <= 0){
                                covTravelMiles = true;
                            }
                            if(SC.CoveredLaborHrs__c != null && SC.CoveredLaborHrs__c != '' && SC.CoveredLaborHrs__c!='0' ){
                                isOnlyFailure = true;
                                system.debug('Inside Failure'+isOnlyFailure);
                                if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) > 0){
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }
                                }
                                else{
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }

                                }
                            }
                        }
                    }
                }


                if(solutionList != null && solutionList.size() >0)
                    WSSRTList = fetchSRTWebservices(cId);//Admin SRT code
                system.debug('WSSRTList >>> ' + WSSRTList);

                //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
                /****************************************************************************************************************************/

                HeaderValidation = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');//Header validation 

                //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
                Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
                IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
                {
                    //If the information only check box is checked then claims cannot receive warranty reimbursement. 
                    if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null || claimsRec.CSS_Job__c=='')) 
                    { 
                        FailureValidation = false;
                    }
                    //Else go ahead and do ODM validation
                    else
                    {
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                    }
                }
                else//Distributor eligible for automated and manual claim hence no condition
                {
                    for(CSS_Solution_Component__c scomp:solutionList)
                    {
                        if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                        {
                            callFailureOnInfoOnlyClaim = false;
                            break;
                        }
                        else
                        {
                            callFailureOnInfoOnlyClaim = true;


                        }
                    }
                    if(callFailureOnInfoOnlyClaim == true){ 
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                        system.debug('inside callFailureOnInfoOnlyClaim>>>>>>'+FailureValidation);

                    }
                }

                List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
                ODMFailurePageDisplayMsgs = CG_BL_ODM.calljobODMHeaderFailureValidationService('CLAIM');//ODM Header validation

                /***********************************************************************************************************************************************************/ 
                try {
                    if(solutionList != null && solutionList.size() > 0){
                        if((isOnlyFieldAction == true) || (isOnlyFailure == true)){
                            upsertAdminSRT(claimsRec, solutionList, allInShopYes,isOnlyFailure);
                        }
                    }
                    //  upserClaimsPolicy(claimsRec, solutionList);
                    clmJobNotesAction(); //Added as part of the defect GSSC-423
                } catch(Exception ex){
                    System.debug('ADMIN SRT POC >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
            }
        } catch(Exception ex){
            System.debug('in catch of CG_ClaimsPartsandOtherClaimbles >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }

        pageName='CG_ClaimsPartsandOtherClaimbles';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service
        if(HeaderValidation == true || FailureValidation == true)
            showErrorPopup=true;

        system.debug('showErrorPopup>>>'+showErrorPopup);
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles'); 
        }else{
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            contr.checkFailuresCovered(cId, true); //moved outside if as part of the task 189212
            if(claimsRec.CSS_Job__c == null && claimsRec.Dealer_Service_Job__c == null){
                contr.covLimitValidation(null, cId, null, null);
                contr.covLimitValidationTTML(null,cId,null,true);
                contr.covLimitValidationSRT(null,cId);
                contr.covLimitfailcodeValidation(null,cId);
            }
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cId); 
            }
        }
        return pageRef;
    }

    //Naviagation to SRTs.
    public PageReference nvClaimsSRTs(){
        PageReference pageRef;
        boolean HeaderValidation;
        boolean FailureValidation;
        boolean callFailureOnInfoOnlyClaim;
        //cId = saveClaim(cId, 'Draft');
        try{
            if(cId != null){
                solutionList=[Select id,Over_The_Counter__c,ODM_Status__c,CampaignTravelPercentage__c,CoveredTravelMiles__c, Selected_Component__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,
                              Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,
                              Approval_Code__c,Authorization_Number__c,AccountCode_Call_Status__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,
                              Failure_Mode__c,Pay_Code__c, Type__c,RoadRelay_Warranty__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,In_Shop_SRT_Limit_Flag__c,Performed_Review__c, Fail_Code__c
                              from CSS_Solution_Component__c 
                              where CSS_Claims__c = :cId 
                              AND ((Type__c != null AND Performed_Review__c = true) OR 
                                   (Type__c = null AND Selected_Component__c = true) OR 
                                   (CSS_Claims__c != null AND Selected_Component__c = true)) ORDER BY CSS_Failure_Sequence_Number__c ASC];
                Id solCompId;
                system.debug('Test**'+solutionList[0].Type__c);
                if(solutionList != null && solutionList.size() >0){                   
                    isOnlyFieldAction = true;
                    allInShopYes = true;
                    for(css_solution_component__c SC: solutionList){
                        system.debug('Test**'+SC.Type__c);
                        if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                            checkAccountCode=true;
                        }

                        system.debug('adminSRTFail**1'+SC.CampaignTravelPercentage__c+'tes'+SC.Selected_Component__c);
                        if(SC.Selected_Component__c == true && SC.CampaignTravelPercentage__c!=null && SC.CampaignTravelPercentage__c!='' && SC.CampaignTravelPercentage__c<='0' && SC.Selected_Component__c == true){
                            campaignTravelPercentage = true;                    
                        }
                        if(SC.Type__c == null || SC.Type__c == ''){
                            if(SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }
                        else{
                            if(claimsRec.Account__r.isCampTrp__c == 'Y' && SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }

                        if((SC.Type__c == 'Campaign' || SC.Type__c == 'TRP' || SC.Type__c == 'ATC')) {
                            if(SC.Selected_Component__c == true){
                                system.debug('In_Shop_SRT_Limit_Flag__c***** ' + SC.In_Shop_SRT_Limit_Flag__c);
                                if(SC.In_Shop_SRT_Limit_Flag__c != true && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                    allInShopYes = false;
                                    system.debug('Inside Field Action'+isOnlyFieldAction);
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(failCodeFA_admSRT == null || failCodeFA_admSRT == ''){
                                            failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                            accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                        system.debug('Test123-->'+admSRTtype);

                                    }
                                    //continue;
                                }
                                //continue;
                                else if(SC.In_Shop_SRT_Limit_Flag__c != false && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                    //inShopSrtFlag= false;
                                    allInShopYes = false;
                                    if(failCodeFA_admSRT == null || failCodeFA_admSRT == '')
                                        failCodeFA_admSRT = SC.Fail_Code__c;
                                    if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                        accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                    if(admSRTtype == null || admSRTtype == '')
                                        admSRTtype = SC.Type__c;

                                }
                            }
                            //continue;
                        }
                        else{
                            isOnlyFieldAction = false;
                            system.debug('Inside Field Action'+isOnlyFieldAction);
                            if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) <= 0){
                                covTravelMiles = true;
                            }
                            if(SC.CoveredLaborHrs__c != null && SC.CoveredLaborHrs__c != '' && SC.CoveredLaborHrs__c!='0' ){
                                isOnlyFailure = true;
                                system.debug('Inside Failure'+isOnlyFailure);
                                if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) > 0){
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }
                                }
                                else{
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }

                                }
                            }
                        }
                    }
                }

                system.debug('Test123->'+admSRTtype);
                if(solutionList != null && solutionList.size() >0)
                    WSSRTList = fetchSRTWebservices(cId);//Admin SRT code
                system.debug('WSSRTList >>> ' + WSSRTList);

                //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
                /****************************************************************************************************************************/

                HeaderValidation = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');//Header validation 

                //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
                Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
                IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
                {
                    //If the information only check box is checked then claims cannot receive warranty reimbursement. 
                    if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null || claimsRec.CSS_Job__c=='')) 
                    { 
                        FailureValidation = false;
                    }
                    //Else go ahead and do ODM validation
                    else
                    {
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                    }
                }
                else//Distributor eligible for automated and manual claim hence no condition
                {
                    for(CSS_Solution_Component__c scomp:solutionList)
                    {
                        if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                        {
                            callFailureOnInfoOnlyClaim = false;
                            break;
                        }
                        else
                        {
                            callFailureOnInfoOnlyClaim = true;

                        }
                    }
                    if(callFailureOnInfoOnlyClaim == true)//ODM Pre submit Validation 
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                }
                
                List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
                ODMFailurePageDisplayMsgs = CG_BL_ODM.calljobODMHeaderFailureValidationService('CLAIM');//ODM Header validation

                /***********************************************************************************************************************************************************/ 
                try {
                    if(solutionList != null && solutionList.size() > 0){
                        system.debug('isOnlyFieldAction'+ isOnlyFieldAction);
                        system.debug('isOnlyFailure'+ isOnlyFailure);
                        if((isOnlyFieldAction == true) || (isOnlyFailure == true)){
                            system.debug('isOnlyFieldAction1'+ isOnlyFieldAction);
                            system.debug('Inside Failure1'+isOnlyFailure);
                            upsertAdminSRT(claimsRec, solutionList, allInShopYes,isOnlyFailure);
                        }
                    }
                    // upserClaimsPolicy(claimsRec, solutionList);
                    clmJobNotesAction(); //Added as part of the defect GSSC-423
                } catch(Exception ex){
                    System.debug('ADMIN SRT SRT >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
            }
        } catch(Exception ex){
            System.debug('in catch of CG_ClaimsSRTs >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }

        pageName='CG_ClaimsSRTs';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service
        if(HeaderValidation == true || FailureValidation == true)
            showErrorPopup=true;


        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsSRTs'); 
        }else{
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            contr.checkFailuresCovered(cId, true); //moved outside if as part of the task 189212
            if(claimsRec.CSS_Job__c == null && claimsRec.Dealer_Service_Job__c == null){
                contr.covLimitValidation(null, cId, null, null);
                contr.covLimitValidationTTML(null,cId,null,true);
                contr.covLimitValidationSRT(null,cId);
                contr.covLimitfailcodeValidation(null,cId);
            }
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsSRTs?id='+cId); 
            }
        }
        return pageRef;
    }

    //Naviagation to Job Notes.
    public PageReference nvClaimsJobNotes(){
        PageReference pageRef;
        boolean HeaderValidation;
        boolean FailureValidation;
        boolean callFailureOnInfoOnlyClaim;
        //cId = saveClaim(cId, 'Draft');
        try{
            if(cId != null){
                solutionList=[Select id,Over_The_Counter__c,ODM_Status__c,CoveredTravelMiles__c, Selected_Component__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,
                              Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,
                              Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,
                              Failure_Mode__c,Pay_Code__c, Type__c,RoadRelay_Warranty__c,CampaignTravelPercentage__c,AccountCode_Call_Status__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,In_Shop_SRT_Limit_Flag__c,Performed_Review__c, Fail_Code__c
                              from CSS_Solution_Component__c 
                              where CSS_Claims__c = :cId 
                              AND ((Type__c != null AND Performed_Review__c = true) OR 
                                   (Type__c = null AND Selected_Component__c = true) OR 
                                   (CSS_Claims__c != null AND Selected_Component__c = true)) ORDER BY CSS_Failure_Sequence_Number__c ASC];
                Id solCompId;
                if(solutionList != null && solutionList.size() >0){                   
                    isOnlyFieldAction = true;
                    allInShopYes = true;
                    for(css_solution_component__c SC: solutionList){
                        if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                            checkAccountCode=true;
                        }

                        system.debug('adminSRTFail**1'+campaignTravelPercentage+'tes'+SC.Selected_Component__c);
                        if(SC.Selected_Component__c == true && SC.CampaignTravelPercentage__c!=null && SC.CampaignTravelPercentage__c!='' && SC.CampaignTravelPercentage__c<='0'){
                            campaignTravelPercentage = true;                    
                        }
                        if(SC.Type__c == null || SC.Type__c == ''){
                            if(SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }
                        else{
                            if(claimsRec.Account__r.isCampTrp__c == 'Y' && SC.AccountCode_Call_Status__c == 'Failure'){
                                system.debug('***InsidewarrantyfailureIf***');
                                warrantyFailure = true;
                            }
                        }

                        if((SC.Type__c == 'Campaign' || SC.Type__c == 'TRP' || SC.Type__c == 'ATC') && SC.Selected_Component__c == true) {
                            system.debug('In_Shop_SRT_Limit_Flag__c***** ' + SC.In_Shop_SRT_Limit_Flag__c);
                            if(SC.In_Shop_SRT_Limit_Flag__c != true && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                allInShopYes = false;
                                system.debug('Inside Field Action'+isOnlyFieldAction);
                                if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                    if(failCodeFA_admSRT == null || failCodeFA_admSRT == ''){
                                        failCodeFA_admSRT = SC.Fail_Code__c;
                                        solCompId = SC.Id;
                                    }
                                    if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                        accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                    if(admSRTtype == null || admSRTtype == '')
                                        admSRTtype = SC.Type__c;
                                }
                            }
                            //continue;
                            else if(SC.In_Shop_SRT_Limit_Flag__c != false && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                //inShopSrtFlag= false;
                                allInShopYes = false;
                                if(failCodeFA_admSRT == null || failCodeFA_admSRT == '')
                                    failCodeFA_admSRT = SC.Fail_Code__c;
                                if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                    accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                if(admSRTtype == null || admSRTtype == '')
                                    admSRTtype = SC.Type__c;

                            }
                        }
                        else{
                            isOnlyFieldAction = false;
                            system.debug('Inside Field Action'+isOnlyFieldAction);
                            if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) <= 0){
                                covTravelMiles = true;
                            }
                            if(SC.CoveredLaborHrs__c != null && SC.CoveredLaborHrs__c != '' && SC.CoveredLaborHrs__c!='0' ){
                                isOnlyFailure = true;
                                system.debug('Inside Failure'+isOnlyFailure);
                                if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) > 0){
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }
                                }
                                else{
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }

                                }
                            }
                        }
                    }
                }


                if(solutionList != null && solutionList.size() >0)
                    WSSRTList = fetchSRTWebservices(cId);//Admin SRT code
                system.debug('WSSRTList >>> ' + WSSRTList);

                //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
                /****************************************************************************************************************************/

                HeaderValidation = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');//Header validation 

                //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
                Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
                IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
                {
                    //If the information only check box is checked then claims cannot receive warranty reimbursement. 
                    if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null || claimsRec.CSS_Job__c=='')) 
                    { 
                        FailureValidation = false;
                    }
                    //Else go ahead and do ODM validation
                    else
                    {
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                    }
                }
                else//Distributor eligible for automated and manual claim hence no condition
                {
                    for(CSS_Solution_Component__c scomp:solutionList)
                    {
                        if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                        {
                            callFailureOnInfoOnlyClaim = false;
                            break;
                        }
                        else
                        {
                            callFailureOnInfoOnlyClaim = true;

                        }
                    }
                    if(callFailureOnInfoOnlyClaim == true)//ODM Pre submit Validation 
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                }

                List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
                ODMFailurePageDisplayMsgs = CG_BL_ODM.calljobODMHeaderFailureValidationService('CLAIM');//ODM Header validation

                /***********************************************************************************************************************************************************/ 
                try {
                    if(solutionList != null && solutionList.size() > 0){
                        if((isOnlyFieldAction == true) || (isOnlyFailure == true)){
                            upsertAdminSRT(claimsRec, solutionList, allInShopYes,isOnlyFailure);
                        }
                    }
                    // upserClaimsPolicy(claimsRec, solutionList);
                    clmJobNotesAction(); //Added as part of the defect GSSC-423
                } catch(Exception ex){
                    System.debug('ADMIN SRT JOB NOTES >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
            }
        } catch(Exception ex){
            System.debug('in catch of CG_ClaimsJobNotes >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }

        pageName='CG_ClaimsJobNotes';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service
        if(HeaderValidation == true || FailureValidation == true)
            showErrorPopup=true;


        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsJobNotes'); 
        }else{
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            contr.checkFailuresCovered(cId, true); //moved outside if as part of the task 189212
            if(claimsRec.CSS_Job__c == null && claimsRec.Dealer_Service_Job__c == null){
                contr.covLimitValidation(null, cId, null, null);
                contr.covLimitValidationTTML(null,cId,null,true);
                contr.covLimitValidationSRT(null,cId);
                contr.covLimitfailcodeValidation(null,cId);
            }
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId); 
            }
        }
        return pageRef;
    }

    //Naviagation to Verify and Submit
    public PageReference nvClaimsVS(){
        PageReference pageRef;
        boolean HeaderValidation;
        boolean FailureValidation;
        boolean callFailureOnInfoOnlyClaim;
        //cId = saveClaim(cId, 'Draft');
        try{
            if(cId != null){
                solutionList=[Select id,Over_The_Counter__c,ODM_Status__c,CoveredTravelMiles__c, Selected_Component__c,Parts_Warranty__c,ODM_Status_Message__c,Failure_Date__c,
                              Failure_Measure__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,CSS_Account_Formula__c,
                              Approval_Code__c,Authorization_Number__c,Component_Id__c,CSS_CoverageType__c,System_Code__c,Component_Code__c,
                              Failure_Mode__c,Pay_Code__c, Type__c,RoadRelay_Warranty__c,CampaignLaborPercentage__c,CoveredLaborHrs__c,In_Shop_SRT_Limit_Flag__c ,Performed_Review__c, Fail_Code__c
                              from CSS_Solution_Component__c 
                              where CSS_Claims__c = :cId 
                              AND ((Type__c != null AND Performed_Review__c = true) OR 
                                   (Type__c = null AND Selected_Component__c = true) OR 
                                   (CSS_Claims__c != null AND Selected_Component__c = true)) ORDER BY CSS_Failure_Sequence_Number__c ASC];
                Id solCompId;
                if(solutionList != null && solutionList.size() >0){                   
                    isOnlyFieldAction = true;
                    allInShopYes = true;
                    for(css_solution_component__c SC: solutionList){
                        if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                            checkAccountCode=true;
                        }
                        if((SC.Type__c == 'Campaign' || SC.Type__c == 'TRP' || SC.Type__c == 'ATC') && SC.Selected_Component__c == true) {
                            system.debug('In_Shop_SRT_Limit_Flag__c***** ' + SC.In_Shop_SRT_Limit_Flag__c);
                            if(SC.In_Shop_SRT_Limit_Flag__c != true && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                allInShopYes = false;
                                system.debug('Inside Field Action'+isOnlyFieldAction);
                                if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                    if(failCodeFA_admSRT == null || failCodeFA_admSRT == ''){
                                        failCodeFA_admSRT = SC.Fail_Code__c;
                                        solCompId = SC.Id;
                                    }
                                    if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                        accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                    if(admSRTtype == null || admSRTtype == '')
                                        admSRTtype = SC.Type__c;
                                }
                            }
                            //continue;
                            else if(SC.In_Shop_SRT_Limit_Flag__c != false && (SC.CampaignLaborPercentage__c != null && SC.CampaignLaborPercentage__c != '' && sc.CampaignLaborPercentage__c !='0')){
                                //inShopSrtFlag= false;
                                allInShopYes = false;
                                if(failCodeFA_admSRT == null || failCodeFA_admSRT == '')
                                    failCodeFA_admSRT = SC.Fail_Code__c;
                                if(accCodeFA_admSRT == null || accCodeFA_admSRT == '')
                                    accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                if(admSRTtype == null || admSRTtype == '')
                                    admSRTtype = SC.Type__c;

                            }
                        }
                        else{
                            isOnlyFieldAction = false;
                            system.debug('Inside Field Action'+isOnlyFieldAction);
                            if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) <= 0){
                                covTravelMiles = true;
                            }
                            if(SC.CoveredLaborHrs__c != null && SC.CoveredLaborHrs__c != '' && SC.CoveredLaborHrs__c!='0' ){
                                isOnlyFailure = true;
                                system.debug('Inside Failure'+isOnlyFailure);
                                if(sc.CoveredTravelMiles__c != null && integer.valueOf(sc.CoveredTravelMiles__c) > 0){
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }
                                }
                                else{
                                    if(SC.CSS_Account_Formula__c != null && SC.CSS_Account_Formula__c != '' && SC.Fail_Code__c != null && SC.Fail_Code__c != ''){
                                        if(Fail_failCodeFA_admSRT == null || Fail_failCodeFA_admSRT == ''){
                                            Fail_failCodeFA_admSRT = SC.Fail_Code__c;
                                            solCompId = SC.Id;
                                        }
                                        if(Fail_accCodeFA_admSRT == null || Fail_accCodeFA_admSRT == '')
                                            Fail_accCodeFA_admSRT = SC.CSS_Account_Formula__c;
                                        if(admSRTtype == null || admSRTtype == '')
                                            admSRTtype = SC.Type__c;
                                    }

                                }
                            }
                        }
                    }
                }


                if(solutionList != null && solutionList.size() >0)
                    WSSRTList = fetchSRTWebservices(cId);//Admin SRT code
                system.debug('WSSRTList >>> ' + WSSRTList);

                //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
                /****************************************************************************************************************************/

                HeaderValidation = CG_BL_ODM.callODMHeaderValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');//Header validation 

                //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
                Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
                IF(orgtype == true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
                {
                    //If the information only check box is checked then claims cannot receive warranty reimbursement. 
                    if(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null || claimsRec.CSS_Job__c=='')) 
                    { 
                        FailureValidation = false;
                    }
                    //Else go ahead and do ODM validation
                    else
                    {
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                    }
                }
                else//Distributor eligible for automated and manual claim hence no condition
                {
                    for(CSS_Solution_Component__c scomp:solutionList)
                    {
                        if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')//If any of the the pay code which is in solution compoent is A
                        {
                            callFailureOnInfoOnlyClaim = false;
                            break;
                        }
                        else
                        {
                            callFailureOnInfoOnlyClaim = true;

                        }
                    }
                    if(callFailureOnInfoOnlyClaim == true)//ODM Pre submit Validation 
                        FailureValidation = CG_BL_ODM.callODMFailureValidationService(null,claimsRec,psnRec,'CLAIM',solutionList,'FailureChevron');
                }

                List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
                ODMFailurePageDisplayMsgs = CG_BL_ODM.calljobODMHeaderFailureValidationService('CLAIM');//ODM Header validation

                /***********************************************************************************************************************************************************/ 
                try {
                    if(solutionList != null && solutionList.size() > 0){
                        if((isOnlyFieldAction == true) || (isOnlyFailure == true)){
                            upsertAdminSRT(claimsRec, solutionList, allInShopYes,isOnlyFailure);
                        }
                    }
                    // upserClaimsPolicy(claimsRec, solutionList);
                } catch(Exception ex){
                    System.debug('ADMIN SRT VnS >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
                clmJobNotesAction(); //Added as part of the defect GSSC-423
            }
        } catch(Exception ex){
            System.debug('in catch of CG_ClaimsVS >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }

        pageName='CG_ClaimsVS';
        //cId = saveClaim(cId, 'Draft');

        //Method to call ODM webservice validation service

        //Method to call ODM webservice validation service
        if(HeaderValidation == true || FailureValidation == true)
            showErrorPopup=true;


        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVS'); 
        }else{
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            contr.checkFailuresCovered(cId, true); //moved outside if as part of the task 189212
            if(claimsRec.CSS_Job__c == null && claimsRec.Dealer_Service_Job__c == null){
                contr.covLimitValidation(null, cId, null, null);
                contr.covLimitValidationTTML(null,cId,null,true);
                contr.covLimitValidationSRT(null,cId);
                contr.covLimitfailcodeValidation(null,cId);
            }
            if(showErrorPopup==true)
            {
                return null;
            }else{
                pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId); 
            }
        }
        
        return pageRef;
    }
    
    public List<CSS_Solution_Component__c> CampaignsWSCall(){
        // calling FieldAction WebService in case of failure response on chevron navigation
        try{
        system.debug('CampaignsWSCall >>' + claimsRec.FieldActionWebServiceResult__c);
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        if(claimsRec.FieldActionWebServiceResult__c == 'Error'){
            string FailureDateString;
            if(psnRec.Failure_Date__c != null){
                FailureDateString = DateTime.newInstance(psnRec.Failure_Date__c.year(),psnRec.Failure_Date__c.month(),psnRec.Failure_Date__c.day()).format('dd-MMM-YY');
            }
            HttpResponse httpRes;
            httpRes = CG_BL_Campaigns.callGetCampaignsWSforClaimsRetrigger(psnRec.PSN__c, FailureDateString, claimsRec.Region__c,'', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', psnRec.CSS_Claims__c);
            system.debug('****httpRes****'+httpRes);
            
    if(httpRes == null || httpRes.getStatusCode() != 200){
        fieldActionStatus = 'Error';
    }
    else if(httpRes != null && httpRes.getStatusCode() == 200){
        fieldActionStatus = 'Success';
        CG_OP_CampaignsResJSON outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(httpRes.getBody(), CG_OP_CampaignsResJSON.class);
                system.debug('outputRes**'+outputRes);
                list<CG_BL_Campaigns.CampaignsWrapper> CampaignsWrapperList = new list<CG_BL_Campaigns.CampaignsWrapper>();
                
                if(outputRes.DataArea != null){
                    system.debug('outputRes.DataArea ' + outputRes.DataArea);
                    List<CSS_Parts_Options__c> partsOptionList;
                    Id recTypeId = [SELECT Id FROM RecordType WHERE Name =: 'Parts'].Id;
                    Map<String,List<CSS_Parts_Options__c>> wsDataMap = new Map<String,List<CSS_Parts_Options__c>>();
                    
                    system.debug('claimsRec'+claimsRec);
                    
                    for(CG_OP_CampaignsResJSON.Details det : outputRes.DataArea.Details){
                        system.debug('det.Status ' + det.Status);
                        //Here check Siebel Campaigns are meeting required criteria
                        if(det.Status != 'Approved' || (det.CompleteIndicator =='Y' && det.MultipleTimes=='N') )
                            continue;
                        if(det.Status == 'Approved' ){
                            CSS_Solution_Component__c campaignComp = new CSS_Solution_Component__c();
                            if(det.InShopSrtLimitFlag == 'Y'){
                                campaignComp.In_Shop_SRT_Limit_Flag__c = true;
                            }
                            else{
                                campaignComp.In_Shop_SRT_Limit_Flag__c = false;
                            }
                            campaignComp.Campaign_Description__c = det.CampaignDesc; 
                            if(det.CampaignEndDate != null && det.CampaignEndDate != ''){
                                campaignComp.Campaign_End_Date__c = date.valueof(det.CampaignEndDate);
                            }
                            if(det.CampaignStartDate != null && det.CampaignStartDate != ''){
                                campaignComp.Campaign_Start_Date__c = date.valueof(det.CampaignStartDate);
                            }
                            if(det.CampaignNumber != null){
                                campaignComp.Component_Id__c = string.valueof(det.CampaignNumber);
                            }
                            campaignComp.Failure_Mode__c = det.FailMode;
                            if(det.FailCode != null && det.FailCode != ''){
                                campaignComp.System_Code__c = (det.FailCode).substring(0,2);
                                campaignComp.Component_Code__c = (det.FailCode).substring(2);
                            }
                            campaignComp.Status__c = det.Status;
                            if(det.MultipleTimes == 'Y'){
                                campaignComp.Multiple_Times__c = true;
                            }
                            else{
                                campaignComp.Multiple_Times__c = false;
                            }
                            campaignComp.Business_Unit__c = det.BusinessUnit;
                            campaignComp.Type__c = det.CampaignType;
                            campaignComp.Name = det.CampaignType+' '+det.CampaignNumber;
                            campaignComp.Status__c = det.Status;
                            if(det.CompleteIndicator == 'Y'){
                                campaignComp.Complete_Indicator__c = true;
                            }
                            else{
                                campaignComp.Complete_Indicator__c = false;
                            }
                            campaignComp.css_claims__c = cId; 
    
                            //calling detail coverage as per story 184437 to check coverage before fieldaction insert
    
                            CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
                            comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,String.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,campaignComp.System_Code__c,campaignComp.Component_Code__c,'','',null,false,campaignComp.Component_Id__c,'','Second Call', claimsRec.ReconEngineFlag__c,false,claimsRec.Name);
                            if(comp != null){  
                                System.debug('comp****' + comp);
                                system.debug('comp.AccountCode__c'+comp.AccountCode__c);
                                if(comp.AccountCode__c!=null && comp.AccountCode__c!=''){
                                    solCompList.add(campaignComp);
                                    system.debug('campaignComp ' + campaignComp);
                                }
                            }
                        }
                    }
    
                    //Delete old saved solution comp & parts data for the job
                    /*List<CSS_Solution_Component__c> solCompListTemp = new List<CSS_Solution_Component__c>([Select Id from CSS_Solution_Component__c where css_claims__c=:cId and Type__c in ('CAMPAIGN','TRP','ATC')]);                
    
                    if(solCompListTemp !=null && solCompListTemp.size()>0){
                        List<CSS_Parts_Options__c> partsListTemp = new List<CSS_Parts_Options__c>([Select Id, Name from CSS_Parts_Options__c where CSS_Claims__c=:cId and RecordTypeId=:recTypeId and FailurepartId__c in :solCompListTemp]);                     
                        System.debug('partsListTemp>>>:'+partsListTemp);
                        if(partsListTemp !=null && partsListTemp.size() > 0)
                            delete partsListTemp; 
                        List<CSS_SRT__c> srtsListTemp = new List<CSS_SRT__c>([Select Id from CSS_SRT__c where CSS_Claims__c =: cId and (Type__c = 'Field Action' OR Type__c = 'Field Action Access')]);
                        if(srtsListTemp != null && srtsListTemp.size() > 0)
                            delete srtsListTemp; 
                        delete solCompListTemp;
                    }*/
    
                    if(solCompList !=null && solCompList.size() > 0){
                        for(CSS_Solution_Component__c sc : solCompList) {
                            CampaignsWrapperList.add(new CG_BL_Campaigns.CampaignsWrapper(cId,sc.System_Code__c,sc.Component_Code__c,sc.Id,sc.Component_Id__c,sc.Selected_Component__c));     
                        }
                    }
                    system.debug('solCompList'+solCompList.size());
                    system.debug('solCompList-->'+solCompList);

                    system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );
                    system.debug('START QUEUEABLE SOLUTION COMPONENT');
                    system.debug('Claims**CampaignsWrapperList ' + CampaignsWrapperList);
                    ID jobIDs = System.enqueueJob(new CG_ClaimsQueueable(CampaignsWrapperList));
                    System.debug('END QUEUEABLE SOLUTION COMPONENT');
                    system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );
        
                }      
    }
    
       }
        
            
            return solCompList;
        }
        catch(Exception ex){
           system.debug('Exception in CampaignsWSCall method  ex.getMessages()' + ex.getmessage() + 'ex.getLineNumber ' + ex.getLineNumber() );
           return null;
        }
        
    }

    //Method for resolving error in ODM Validation services
    public PageReference resolveErrorNow()
    {
        PageReference pageRef;
        //showErrorPopup = false;
        pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId); 
        pageRef.setRedirect(true);
        return pageRef;
    }

    //Method for continuing to clicked chevron in ODM Validation services
    public PageReference continueNext()
    {
        PageReference pageRef;
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
    }

    //Below method is added to retry the warranty webservice if any of the displayed solution component's accountcode status is failure(User story 183076)
    public List<CSS_Solution_Component__c> warrantyFailureSolCompList;
    public List<CSS_Solution_Component__c> warrantyFailureSolCompUpdateList;
    public PageReference retry(){
        try{
            system.debug('***inside retry***');

            //Initialise warrantyfailure lists
            warrantyFailureSolCompList = new List<CSS_Solution_Component__c>();
            warrantyFailureSolCompUpdateList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c compToUpdate = new CSS_Solution_Component__c();

            //Query to get all components with account code null and account code call status as failure
            warrantyFailureSolCompList = [select Id, Failure_Point__c, Failure_Measure__c, SysCodeAndCompCode__c, Type__c, System_Code__c, Component_Code__c, Fail_Code_Editable__c, AccountCode__c, Selected_Component__c, name,Component_Id__c,Solutions__c,Service_Job__c,AccountCode_Call_Status__c,solutions__r.FaultCode__c from CSS_Solution_Component__c where CSS_Claims__c=:cId and AccountCode_Call_Status__c = 'Failure' and (AccountCode__c = '' or AccountCode__c = null)];
            system.debug('***warrantyFailureSolCompList***'+warrantyFailureSolCompList +'******size****'+warrantyFailureSolCompList.size());

            if(warrantyFailureSolCompList != null){
                system.debug('***insideifwarr***');


                //Iterate the warrantyfailure list to get the updated component data from warrantycoverage_syncCall webservice method
                for(CSS_Solution_Component__c solComp: warrantyFailureSolCompList){

                    String systemCode;
                    String compCode;
                    String selectedFailCodeMod;

                    if(solComp.SysCodeAndCompCode__c != null && solComp.SysCodeAndCompCode__c != ''){
                        systemCode = solComp.SysCodeAndCompCode__c.left(2);
                        compCode =  solComp.SysCodeAndCompCode__c.right(2);
                    }

                    if(solComp.Type__c != null && solComp.Type__c != ''){

                        system.debug('***claimsRec.CSS_PSNs__r[0].ApplicationCode__c***'+claimsRec.CSS_PSNs__r[0].ApplicationCode__c);      
                        if(claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='130' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='210' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='220' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='310' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='320' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='410'){
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,systemCode,compCode,'','',solComp.id,solComp.Selected_Component__c,solComp.Component_Id__c,'','Second Call', '',true,claimsRec.Name);
                        }
                        else{
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Product_Hours__c),'Hours',psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,systemCode,compCode,'','',solComp.id,solComp.Selected_Component__c,solComp.Component_Id__c,'','Second Call', '',true,claimsRec.Name);

                        }
                        // compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,psnRec.Failure_Point__c,solComp.Failure_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,systemCode,compCode,'','',solComp.id,solComp.Selected_Component__c,solComp.Component_Id__c,'','Second Call', '',true);
                    }
                    else{
                        if(claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='130' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='210' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='220' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='310' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='320' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='410'){
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,systemCode,compCode,'','',solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true,claimsRec.Name);


                        }
                        else{
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Product_Hours__c),'Hours',psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,systemCode,compCode,'','',solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true,claimsRec.Name);


                        }

                        //compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,psnRec.Failure_Point__c,solComp.Failure_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,systemCode,compCode,'','',solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true);
                    }
                    system.debug('***compToUpdate-retry***'+compToUpdate);

                    //Add returned component data to warrantyFailureSolCompUpdateList
                    if(compToUpdate != null)
                        warrantyFailureSolCompUpdateList.add(compToUpdate);
                }
            }

            //Update all the warrantyfailurecomponents to the database
            if(warrantyFailureSolCompUpdateList != null){
                update warrantyFailureSolCompUpdateList;
            }            

        }
        catch(exception e){
            system.debug('inside retry exception -->'+ e.getmessage() + e.getLineNumber());
        }
        return null;
    }
   //Created as part of the defect GSSC-423
   public void clmJobNotesAction(){
        String editCorrection;
        List<CSS_Solution_Component__c> solCompsNew = [select Id, Name,Quantity__c,Claim_FailCode__c,Fail_Code__c,type__c,Selected_Component__c,AccountCode__c,CSS_Account_Formula__c
                            from CSS_Solution_Component__c
                              where CSS_Claims__c =:claimsRec.id AND Selected_Component__c = true AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC')) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved'))]; 
        if(ClaimsRec.EditCorrection__c == null || ClaimsRec.EditCorrection__c == ''){
            if(solCompsNew != null && solCompsNew.size()>0){
                editCorrection = '';
                for(css_solution_component__c sol:solCompsNew){
                    if(sol.Type__c == 'TSB' || sol.Type__c == 'TRP' || sol.Type__c == 'Campaign' || sol.Type__c == 'ATC'){
                        continue;
                    }
                    claimsRec.EditCorrection__c = '';
                    editCorrection += 'Failure Name='+sol.Name;
                   	editCorrection += '\n' +(sol.Quantity__c != null && sol.Quantity__c != 0 ? '\n' +'Quantity' + '=' + sol.Quantity__c : '');
                }
                CSS_Claims__c claimsnewrec = new CSS_Claims__c();
                claimsnewrec.id = ClaimsRec.Id;
                claimsnewrec.EditCorrection__c = editCorrection;
                update claimsnewrec;
            }
        }
        else{
            if(solCompsNew != null && solCompsNew.size()>0){
                editCorrection = ClaimsRec.EditCorrection__c + '\n';
                for(css_solution_component__c sol:solCompsNew){
                    if(!editCorrection.contains(sol.Name+'\n')){
                        if(sol.Type__c == 'TSB' || sol.Type__c == 'TRP' || sol.Type__c == 'Campaign' || sol.Type__c == 'ATC'){
                            continue;
                        }
                        editCorrection += 'Failure Name='+sol.Name;
                       	editCorrection += '\n' +(sol.Quantity__c != null && sol.Quantity__c != 0 ? '\n' +'Quantity' + '=' + sol.Quantity__c : '');
                    }
                }
                CSS_Claims__c claimsnewrec = new CSS_Claims__c();
                claimsnewrec.id = ClaimsRec.Id;
                claimsnewrec.EditCorrection__c = editCorrection;
                update claimsnewrec;
            }
        }
    }
}