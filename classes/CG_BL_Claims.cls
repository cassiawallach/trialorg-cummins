/**********************************************************************
Name:CG_BL_Claims
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------   
This is the Business layer for Claims module
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Surender M          03/20/2017      Implementation of Automated Campaigns
***********************************************************************/
public class CG_BL_Claims
{
    public static Map<String,CSS_JobEventTemporary__c> jobEventMap = new Map<String,CSS_JobEventTemporary__c>();
    public static Boolean onlyPWaccountCode;
    public CG_BL_Claims()
    {
        system.debug('inside CG_BL_Claims');
        for(CSS_JobEventTemporary__c jet : [SELECT Id, Key__c, Attribute1__c, Attribute2__c, Attribute3__c FROM CSS_JobEventTemporary__c WHERE Key__c =: 'AccountCodes']){
            String temp = jet.Attribute3__c;//jet.Attribute2__c + ' ' + jet.Attribute3__c;
            if(temp != null && temp != '' && temp.trim() != ''){
                jobEventMap.put(temp,jet);
            }
        }
        system.debug('inside constructorr'+jobEventMap);

    }

    public static void performClaimCreationBusinessLogic(){
        CG_OP_OAGWrapper ClaimCreationCallout;
        //ClaimCreationCallout = CG_BL_TSR.TSRWebservice(currentuser,ServiceJob,faultCodes,SymptomSrch,TechId,CustomerSupportLevel,ComplaintCode,EscalationGroup);
    }

    /*
@InvocableMethod(label='ClaimHistory' description='Update Job Event Temporary with ClaimHostory Records')
public static void ClaimHistory(List<String> PSN) {
performClaimHistoryBusinessLogic(PSN[0]);
}

@future(callout=true)
*/
    public static List<CSS_JobEventTemporary__c> performClaimHistoryBusinessLogic(string PSN){
        List<CSS_JobEventTemporary__c> claimList;
        try {
            CG_OP_OAGWrapper OPWrapper = null;

            system.debug('PSN PSN' + PSN);
            OPWrapper = CG_SL_Claims.claimHistoryWebservice(PSN);
            system.debug('resWrapper>>>:'+OPWrapper);
            system.debug('ResBody>>>:'+OPWrapper.response.getBody());
            string claimHisytory = ''+ OPWrapper.response.getBody();
            system.debug(claimHisytory);
            if(claimHisytory != null && claimHisytory.length() > 0) {
                if(!claimHisytory.contains('{"Details":'))
                    return claimList;
            }
            //System.debug('#####httpRes:'+resWrapper.response+'######httpRes.getBody:'+resWrapper.response.getBody());
            //Kalpana Hardcoding Response, as the service is failing
            CG_ClaimsResJSON outputRes = (CG_ClaimsResJSON)JSON.deserialize(OPWrapper.response.getBody(), CG_ClaimsResJSON.class);
            //   CG_ClaimsResJSON outputRes = (CG_ClaimsResJSON)JSON.deserializeStrict('{"DataArea":{"Details":[{"FailureDate":"2012-01-24T00:00:00.000-06:00","SPName":"SOUTHEASTERN FREIGHT LINES","SPCode":"30468","WorkOrderNumber":"WAT-S150","ClaimNumber":"04530-2047112-0","FailCode":"WEQP","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"449","UnitOfMeasure":"Miles","WarrantyStartDate":"2011-03-25T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0001714-0","FailCode":"WEQP","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0001814-0","FailCode":"HYBD","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Denied"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0001814-0","FailCode":"IRCL","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Denied"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0005614-0","FailCode":"HYBD","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2011-03-16T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Denied"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0005614-0","FailCode":"IRCL","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2011-03-16T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Denied"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0015414-0","FailCode":"HYBD","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2013-12-20T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"84301","ClaimNumber":"04970-0015414-0","FailCode":"IRCL","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"48003","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2015-02-16T00:00:00.000-06:00","SPName":"SOUTHEASTERN FREIGHT LINES","SPCode":"30468","WorkOrderNumber":"FTW0468","ClaimNumber":"04530-2137015-0","FailCode":"IRVB","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"291426","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2015-04-02T00:00:00.000-05:00","SPName":"SOUTHEASTERN FREIGHT LINES","SPCode":"30468","WorkOrderNumber":"ORL3982","ClaimNumber":"04530-2141115-0","FailCode":"LCEL","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"311425","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2015-10-26T00:00:00.000-05:00","SPName":"","SPCode":"","WorkOrderNumber":"157949","ClaimNumber":"02932-0233915-0","FailCode":"BPCR","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"399618","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"SHIM (LOWER)","ClaimStatus":"Paid"},{"FailureDate":"2015-11-10T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"158309","ClaimNumber":"02932-0241815-0","FailCode":"XXIP","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"405878","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Denied"},{"FailureDate":"2015-11-10T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"158309","ClaimNumber":"02932-0012616-0","FailCode":"XXIP","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"405878","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2016-01-22T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"159684","ClaimNumber":"02932-0034716-0","FailCode":"BPCR","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"446800","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"SHIM (LOWER)","ClaimStatus":"Paid"},{"FailureDate":"2016-01-22T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"159684","ClaimNumber":"02932-0034716-0","FailCode":"CHSE","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"446800","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2016-01-22T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"159684","ClaimNumber":"02932-0034716-0","FailCode":"BKCL","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"446800","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2016-01-22T00:00:00.000-06:00","SPName":"","SPCode":"","WorkOrderNumber":"159684","ClaimNumber":"02932-0034816-0","FailCode":"WLCV","SMN":"ISX15 CM2250","CreditStatementNumber":"","FailurePoint":"446800","UnitOfMeasure":"Miles","WarrantyStartDate":"2013-10-14T00:00:00.000-05:00","FailureName":"","ClaimStatus":"Paid"},{"FailureDate":"2013-10-02T00:00:00.000-05:00","SPName":"SOUTHEASTERN FREIGHT LINES","SPCode":"30468","WorkOrderNumber":"CM45A21A","ClaimNumber":"04530-2091713-0","FailCode":"WEQP","SMN":"","CreditStatementNumber":"","FailurePoint":"0","UnitOfMeasure":"Miles","WarrantyStartDate":"","FailureName":"","ClaimStatus":"Paid"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}', CG_ClaimsResJSON.class);
            // CG_ClaimsResJSON outputRes = (CG_ClaimsResJSON)JSON.deserializeStrict('{"DataArea": {"Details": []}, "Header": {"ReturnCodeDescription": "","Status": "Success"}}', CG_ClaimsResJSON.class);
            system.debug('outputRes**'+outputRes);
            if(outputRes.DataArea != null) {
                system.debug('InsideIF**');
                claimList = new List<CSS_JobEventTemporary__c>();
                for(CG_ClaimsResJSON.Details det : outputRes.DataArea.Details) {
                    CSS_JobEventTemporary__c JET = new CSS_JobEventTemporary__c();
                    JET.Type__c='ClaimHistory';
                    JET.key__c=PSN; // + ' : ' + inpClaimId;
                    JET.Attribute1__c=det.FailureDate;
                    JET.Attribute3__c=det.SPName;
                    JET.Attribute2__c=det.SPCode;
                    JET.Attribute7__c=det.WorkOrderNumber;
                    JET.Attribute8__c=det.ClaimNumber;
                    JET.Circuit_Description__c=det.FailCode;
                    JET.Service_Model_Name__c=det.SMN;
                    JET.Attribute10__c=det.CreditStatementNumber;
                    JET.Attribute4__c=det.FailurePoint;
                    JET.Attribute6__c=det.UnitOfMeasure;
                    JET.Attribute11__c=det.WarrantyStartDate;
                    JET.Attribute5__c=det.FailureName;
                    JET.Attribute9__c=det.ClaimStatus;
                    claimList.add(JET);
                }
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_BL_Claims performClaimHistoryBusinessLogic method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return claimList;
    }        

    //Fetch Multilocation values.
    public static list<CSS_UserLocation__c> fetchMultiLocation() {
        //UserRole urRole = new UserRole();
        Id usrId = UserInfo.getUserId();
        system.debug('usrId>>>'+usrId);
        //if(UserInfo.getUserRoleId()!=null){
          //  urRole = [Select name from UserRole where id=: UserInfo.getUserRoleId()];
        //}
        list<CSS_UserLocation__c> userLocationList = new List<CSS_UserLocation__c>();
        try {
            //query to get the user locations
            /*if(urRole.name == 'Factory'){
                Map<String,String > uniqueListMap = new Map<String,String>();

                List<CSS_UserLocation__c> usrList = new List<CSS_UserLocation__c>();


                for(CSS_UserLocation__c usr:[SELECT AccountId__c,isActive__c,isPrimary__c,Location_Name__c,BMSApplicationURL__c,
                                             UserId__c,BMS_Enabled__c,Location_code__c
                                             FROM CSS_UserLocation__c
                                             WHERE   UserId__c = : usrId and isActive__c = true AND isClaims__c = true AND Location_Source__c = 'ARF'   
                                             ORDER BY Location_Name__c asc]){
                    if(!uniqueListMap.containsKey(usr.Location_Name__c)){

                        uniqueListMap.put(usr.Location_Name__c,usr.Location_Name__c);
                        userLocationList.add(usr); 


                    }
                    system.debug('uniqueListMap' + uniqueListMap);
                }
                system.debug('for factory user - userLocationList' + userLocationList);
                system.debug('IF LOOP');

            }else{*//*Commented by Anirudh for GSSC-196 for infant care issue.Please discuss if any issue comes up*/
                userLocationList = [SELECT AccountId__c,isActive__c,isPrimary__c,Location_Name__c,BMSApplicationURL__c,
                                    UserId__c,BMS_Enabled__c,Location_code__c,AccountId__r.Type
                                    FROM CSS_UserLocation__c
                                    WHERE UserId__c = : usrId AND isActive__c = true
                                    AND isClaims__c = true AND Location_Source__c = 'ARF'
                                    //AND AccountId__r.ERP_System__c = 'One BMS' //AND isPrimary__c = true
                                    ORDER BY Location_Name__c asc];
                system.debug('userLocationList'+userLocationList);
                system.debug('ELSE LOOP');
            //} 
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_BL_Intake fetchMultiLocation method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        system.debug('userLocationList--'+userLocationList);
        return userLocationList;
    }

    //Fetch Selected Locations.
    public static string selectedLocation(list<CSS_UserLocation__c> userLocationList) {
        string selectLocation;
        try {
            if(userLocationList != null && userLocationList.size() >0) {
                for(CSS_UserLocation__c ul : userLocationList) {
                    if(ul.isPrimary__c) 
                        selectLocation = ul.Location_code__c;
                }
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_BL_Intake selectedLocation method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return selectLocation;
    }

    //Fetching Location values.
    public String defaultUserLoc;
    public string defaultUserLocCode;
    public List<SelectOption> fetchLocationName(list<CSS_UserLocation__c> lstUserLocations) {
        List<SelectOption> options = new List<SelectOption>();        
        try {
            if(lstUserLocations != null && lstUserLocations.size()>0) {
                options.add(new SelectOption('-All-','-All-'));
                //for loop to build the alll locations name options list 
                for(CSS_UserLocation__c ul : lstUserLocations) {
                    options.add(new SelectOption( ul.Location_code__c , ul.Location_Name__c + ' - ' + ul.Location_code__c.right(5).trim()));
                    //options.add(new SelectOption( ul.Location_code__c , ul.Location_Name__c + ' - ' + ul.Location_code__c));
                    if(ul.isPrimary__c == True){
                        //defaultUserLoc = ul.Location_Name__c.trim() + ' - ' + ul.Location_code__c.right(5).trim();    //GSSC:223 By Krishna
                        defaultUserLoc = ul.Location_code__c;   //GSSC:223 By Krishna
                        //defaultUserLoc = ul.Location_Name__c + ' - ' + ul.Location_code__c;
                        //defaultUserLocCode = ul.Location_code__c;
                        system.debug('defaultUserLoc' + ' ' + defaultUserLoc);
                        system.debug('defaultUserLocCode' + ' ' + defaultUserLocCode);
                    }                                     
                }
                if(defaultUserLoc == null || defaultUserLoc == '')
                    defaultUserLoc = '-All-';
            } else {
                options.add(new SelectOption('--None--','--None--'));
                system.debug('SelectOption123.......');
            }
        } catch(Exception e)  {
            system.debug('CG_BL_Claims - fetchLoactionName Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return options;
    }

    //Clone Automated Campaigns
    public static void cloneAutomatedCampaigns(Id workJobId, String workJobPSN, Id claimRecId, Id psnRecId,Boolean isDealer, String claimAccType, Boolean paccarAuthReqdJob) {
        system.debug('claimRecId--'+claimRecId);
        system.debug('in cloneAutomatedCampaigns of CG_BL_Claims...');
        system.debug('isDealer--'+isDealer);
        List<CSS_Solution_Component__c> solCompList;
        Integer repairSortOrder=0;
        Set<id> duplicateSRTSet = new Set<id>();
        Set<id> duplicateSRTSetNew = new Set<id>();
        Boolean isAllAccCodeNull;
        Boolean isAnyAccCodeNull;
        boolean mileageProdHrsError;
        try{
            
            CSS_Job_Order__c ServJob = new CSS_Job_Order__c();
            ServJob = [select id,FieldActionWebServiceResult__c, License_Plate__c, Automotive_App_Flag__c, Mileage__c, CSS_Hours__c from CSS_Job_Order__c where id= :workJobId];
            
            //Cloning SolComp Records
            //Added "Fault_Code__c" field in below query as per SIT story #150030, -By RAJESH 25th June 2018   
            //adding below condition as per the story#161010
            //added ODM_Penalty__c field in solCompList Query as per story 180325
            system.debug('inside CG_BL_Claims');
            for(CSS_JobEventTemporary__c jet : [SELECT Id, Key__c, Attribute1__c, Attribute2__c, Attribute3__c FROM CSS_JobEventTemporary__c WHERE Key__c =: 'AccountCodes']){
                String temp = jet.Attribute3__c;//jet.Attribute2__c + ' ' + jet.Attribute3__c;
                if(temp != null && temp != '' && temp.trim() != ''){
                    jobEventMap.put(temp,jet);
                }
            }
            system.debug('inside constructorr'+jobEventMap);
            //defect 191529, modified srt query to fetch field actions and Non-SRTs
            //if(!isDealer)
            if(claimAccType.contains('Distributor'))
            {
                //Added the field Root_Cause__c and the WHERE clause "Root_Cause__c = true" in below CSS_Solution_Component__c query as part of the story GSSC-458
                solCompList = new List<CSS_Solution_Component__c>([select Name, Root_Cause__c, CoverageLimitExceedMsg_Status__c, CoverageLimitExceedMsg__c, AccountCode__c,AccountCode_Call_Status__c,AccountCodeEdit__c,AccountCodeType__c,Action__c,Approval_Code__c,Selected_Claim_Type__c,Claim_Type__c,Fault_Code__c,
                                                                   Authorization_Number__c,Business_Unit__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,
                                                                   Campaign_Start_Date__c,CoverageLimitExceedMsgSRT_Status__c,CoverageLimitExceedMsgSRT__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,CertificateNumber__c,Charlength__c,Complete_Indicator__c,Component_Code__c,Component_Id__c,
                                                                   CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredPartsQty_Percentage__c,CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c,
                                                                   CoveredTravelLabor__c,CoveredTravelMiles__c,CSS_Account_Formula__c,CSS_CoverageType__c,Solutions__c,DeductibleAmount__c,Customer_Take_Possession__c,Engine_Family_Code__c,
                                                                   Equip_ID__c,Fail_Code__c,Fail_Code_Editable__c,FailCode_Formula__c,Failure_Date__c,Failure_Measure__c,Failure_Mode__c,Failure_Point__c,In_Shop_SRT_Limit_Flag__c,
                                                                   Multiple_Times__c,Notes__c,Parts_Warranty__c,RoadRelay_Warranty__c,Part_Warranty_Start_Date__c,Pay_Code__c,Performed__c,Performed_Review__c,Quantity__c,Reviewed__c,Selected_Component__c,SystemCode_Desc__c,
                                                                   Service_Model__c,SRT_Fetched__c,SRT_Total__c,Status__c,System_Code__c,Type__c,FailMode_Desc__c,Unique_Component__c,URL__c,WarrantyId__c,Claims_Failure_Select__c,ODM_Status__c,ODM_Status_Message__c,ComponentCode_Desc__c,ODM_Penalty__c,	
                                                                    Solutions__r.Symptom__r.Name, Solutions__r.FaultCode__r.Name,
                                                                   (select name,Component_Id__c,Flex_Flag__c,ECM_Flag__c,Extended_Hours__c,AccountCode_Formula__c,Account_Code__c,FailCode__c,SRT_ID__c,SRT_Order__c,id,Repair_Access_Calculated__c,SRT_Time__c,step_id__c,Diagnosis_Time__c,Additional_SRT_Calculated__c, 
                                                                    Repair_Time__c,Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,Assignment__c,Solution_Number__c, SRT_Status_Message__c,SRT_Notes__c ,SRT_Warrantable__c,Job_Engine_Access_Code__c,SRT_Access_Code__c, 
                                                                    Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Access_Code_Saved__c,job_order__r.AccessCode__c,srt_category__c,ODM_Status__c,ODM_Status_Message__c,SRT_Select__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c, 
                                                                    Fail_Code_Description__c,Account_Code_Description__c,SRT_Usage__c,isDuplicateRootCause__c
                                                                    from CSS_SRTs__r where (AccountCode_Formula__c != null and AccountCode_Formula__c != '' and AccountCode_Formula__c not in ('Select One')) and (SRT_ID__c != null and SRT_ID__c != '') and 
                                                                    (Solution_Number__c = null or (Solution_Number__c != null and (Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' or Solution_Number__r.Diagnostic_Response__c = 'Not the solution'))) and isDuplicateRootCause__c =: false), //and (Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' 
                                                                   (Select Id,selected_part__c, Item__c, Part_Description__c,Unit_Price__c,
                                                                    Quantity__c, amount__c, Covered__c, Fail_Code__c,Account_Code__c, Notes__c, Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,Return_Instructions__c, Shipping_Address__c,FailurepartId__r.Fail_Code__c,Replacement_Reason__c,
                                                                    HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,ODM_Status__c,ODM_Status_Message__c, Part_Assignment__c, Parts_Type__c,Option_Number__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate__c, Currency_Type__c, Exchange_Rate_Version__c FROM CSS_Parts_Options__r where (Account_Code__c != null and Account_Code__c != '') and RecordType.Name !='Parts')//where Part_Assignment__c = 'Primary'
                                                                   from CSS_Solution_Component__c where Service_Job__c =:workJobId and (CSS_Account_Formula__c != null and CSS_Account_Formula__c != '') and ((Selected_Component__c= true and Root_Cause__c = true and Type__c not in ('Campaign','TRP','ATC') ) or (Type__c in ('Campaign','TRP','ATC')) ) ]);  // and Selected_Component__c= true and AccountCode__c!=null (defect 151373 )//where Type__c in ('Campaign','TRP','ATC')  and Service_Job__c =:workJobId and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))]);

            }
            else{
                //Getting all the suggested parts and srt
                //Added the field Root_Cause__c and the WHERE clauses "Root_Cause__c = true" and "CSS_Account_Formula__c != null and CSS_Account_Formula__c != ''" in below CSS_Solution_Component__c query as part of the story GSSC-458
                //Added the WHERE clause "(AccountCode_Formula__c != null and AccountCode_Formula__c != '' and AccountCode_Formula__c not in ('Select One'))" in below CSS_SRT__c query as part of the story GSSC-458
                system.debug('dealer solution component query starts>>');
                solCompList = new List<CSS_Solution_Component__c>([select Name, Root_Cause__c, CoverageLimitExceedMsg_Status__c, CoverageLimitExceedMsg__c, AccountCode__c,AccountCode_Call_Status__c,AccountCodeEdit__c,AccountCodeType__c,Action__c,Approval_Code__c,Selected_Claim_Type__c,Claim_Type__c,Fault_Code__c,
                                                                   Authorization_Number__c,Business_Unit__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,
                                                                   Campaign_Start_Date__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,CertificateNumber__c,Charlength__c,Complete_Indicator__c,Component_Code__c,Component_Id__c,
                                                                   CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoverageLimitExceedMsgSRT_Status__c,CoverageLimitExceedMsgSRT__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredPartsQty_Percentage__c,CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c,
                                                                   CoveredTravelLabor__c,CoveredTravelMiles__c,CSS_Account_Formula__c,CSS_CoverageType__c,Solutions__c,DeductibleAmount__c,Customer_Take_Possession__c,Engine_Family_Code__c,
                                                                   Equip_ID__c,Fail_Code__c,Fail_Code_Editable__c,FailCode_Formula__c,Failure_Date__c,Failure_Measure__c,Failure_Mode__c,Failure_Point__c,In_Shop_SRT_Limit_Flag__c,
                                                                   Multiple_Times__c,Notes__c,Parts_Warranty__c,RoadRelay_Warranty__c,Part_Warranty_Start_Date__c,Pay_Code__c,Performed__c,Performed_Review__c,Quantity__c,Reviewed__c,Selected_Component__c,SystemCode_Desc__c,
                                                                   Service_Model__c,SRT_Fetched__c,SRT_Total__c,Status__c,System_Code__c,Type__c,FailMode_Desc__c,Unique_Component__c,URL__c,WarrantyId__c,Claims_Failure_Select__c,ODM_Status__c,ODM_Status_Message__c,ComponentCode_Desc__c,ODM_Penalty__c,
                                                                    Solutions__r.Symptom__r.Name, Solutions__r.FaultCode__r.Name,
                                                                   (select name,Flex_Flag__c,ECM_Flag__c,Component_Id__c,Claimed_Hours__c,SRT_Access_Code__c,Extended_Hours__c,AccountCode_Formula__c,Account_Code__c,FailCode__c,SRT_ID__c,SRT_Order__c,id,Repair_Access_Calculated__c,SRT_Time__c,step_id__c,Diagnosis_Time__c, 
                                                                    Additional_SRT_Calculated__c,Repair_Time__c,Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,Assignment__c,Solution_Number__c, SRT_Status_Message__c,SRT_Notes__c ,SRT_Warrantable__c,Job_Engine_Access_Code__c, 
                                                                    Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Access_Code_Saved__c,job_order__r.AccessCode__c,srt_category__c,ODM_Status__c,ODM_Status_Message__c,SRT_Select__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,Fail_Code_Description__c,
                                                                    Account_Code_Description__c,SRT_Usage__c,isDuplicateRootCause__c
                                                                    from CSS_SRTs__r where SRT_ID__c != null and SRT_ID__c != '' and (AccountCode_Formula__c != null and AccountCode_Formula__c != '' and AccountCode_Formula__c not in ('Select One')) and
                                                                    (Solution_Number__c = null or (Solution_Number__c != null and (Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' or Solution_Number__r.Diagnostic_Response__c = 'Not the solution'))) and isDuplicateRootCause__c = false),
                                                                    (Select Id,selected_part__c, Item__c, Part_Description__c,Unit_Price__c,
                                                                    Quantity__c, amount__c, Covered__c, Fail_Code__c,Account_Code__c, Notes__c, Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,Return_Instructions__c, Shipping_Address__c,FailurepartId__r.Fail_Code__c,Replacement_Reason__c,
                                                                    HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,ODM_Status__c,ODM_Status_Message__c, Part_Assignment__c, Parts_Type__c,Option_Number__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate__c, Currency_Type__c, Exchange_Rate_Version__c FROM CSS_Parts_Options__r where (Account_Code__c != null and Account_Code__c != '' and Account_Code__c != 'Select One'))//where Part_Assignment__c = 'Primary' - GSSC 485 /460
                                                                   from CSS_Solution_Component__c where Service_Job__c =:workJobId and (CSS_Account_Formula__c != null and CSS_Account_Formula__c != '') and  ((Selected_Component__c= true and Root_Cause__c = true and Type__c not in ('Campaign','TRP','ATC') ) or (Type__c in ('Campaign','TRP','ATC')) ) ]);
            }
            Map<id, List<CSS_Parts_Options__c>> partOptionMap= new Map<id,List<CSS_Parts_Options__c>>();
            System.debug('solCompList size>>:'+solCompList.size()+' solCompList>>>>:'+solCompList);
            if(solCompList !=null && solCompList.size()>0){


                List<CSS_Solution_Component__c> solCompListTemp = new List<CSS_Solution_Component__c>(); 
                Map<id,CSS_Solution_Component__c> solCompListTempMap = new Map<id,CSS_Solution_Component__c> ();
                Map<id,CSS_Parts_Options__c> partsOptionsMap = new Map<id,CSS_Parts_Options__c> ();
                List<CSS_Solution_Component__c> lstNewSolComp = new List<CSS_Solution_Component__c>();
                List<CSS_Parts_Options__c> lstNewpartOption = new List<CSS_Parts_Options__c>();
                List<CSS_Parts_Options__c> lstNewpartOption1 = new List<CSS_Parts_Options__c>();
                List<CSS_SRT__C> srtCloneList = new List<CSS_SRT__C>();
                Map<id,List<CSS_SRT__C>> srtCloneMap = new Map<id,List<CSS_SRT__C>>();
                onlyPWaccountCode = true;
                isAllAccCodeNull = true;
                isAnyAccCodeNull = false; 
                for(CSS_Solution_Component__c solComp : solCompList) {
                    system.debug('SolComp Record--'+solComp);
                    system.debug('jobEventMap--'+jobEventMap);
                    if(claimAccType == 'Dealer Account' && paccarAuthReqdJob == true){
                        if(solComp.CSS_Account_Formula__c != null && solComp.CSS_Account_Formula__c != '' && solComp.CSS_Account_Formula__c.trim() != ''){
                            if((solComp.Type__c == null || solComp.Type__c == '') || ((solComp.Type__c != null && solComp.Type__c != '') && (solComp.Performed__c == true || solComp.Performed_Review__c == true))){
                                CSS_JobEventTemporary__c tempJET = jobEventMap.get(solComp.CSS_Account_Formula__c.RIGHT(2));
                                system.debug('solComp.CSS_Account_Formula__c-->'+solComp.CSS_Account_Formula__c);
                                system.debug('tempJET-->'+tempJET);
                                if(tempJET != null){
                                    String covType = tempJET.Attribute1__c;
                                    system.debug('covType'+covType);
                                    if(covType != null && covType != '' && (covType != 'NPW' && covType != 'RPW')){
                                        onlyPWaccountCode = false;
                                    }
                                }
                                isAllAccCodeNull = false;
                            }
                        }
                        else{
                            isAnyAccCodeNull = true;
                        }
                    }
                    else{
                        onlyPWaccountCode = false;
                        isAllAccCodeNull = false;
                    }
                    
                    //GSSC-106
                    if(solComp.CSS_Account_Formula__c != null && solComp.CSS_Account_Formula__c != '' && solComp.CSS_Account_Formula__c.contains('70')){
                        if(ServJob.Automotive_App_Flag__c == 'Y' && ServJob.License_Plate__c == 'CA - California'){
                            if((ServJob.Mileage__c == null || ServJob.Mileage__c == 0) || (ServJob.CSS_Hours__c == null || ServJob.CSS_Hours__c == 0)){
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
                    
                    system.debug('onlyPWaccountCode-->'+onlyPWaccountCode);
                    system.debug('isAllAccCodeNull-->'+isAllAccCodeNull);
                    system.debug('isAnyAccCodeNull-->'+isAnyAccCodeNull);
                    //solComp.Id = null;
                    solcomp.OldSolCompID__c = solComp.Id;
                    //solComp.Service_Job__c = null;
                    solComp.CSS_Claims__c = claimRecId;
                    system.debug('Parts Records--'+solComp.CSS_Parts_Options__r);
                    System.debug('Part Record size'+solComp.CSS_Parts_Options__r.size());
                    if(solComp.CSS_Parts_Options__r!=null && solComp.CSS_Parts_Options__r.size()>0){
                        partOptionMap.put(solComp.id,solComp.CSS_Parts_Options__r);    
                    }
                    system.debug('solComp.CSS_SRTs__r**'+solComp.CSS_SRTs__r);
                    if(solComp.CSS_SRTs__r!=null && solComp.CSS_SRTs__r.size()>0){
                        if((solComp.Type__c == null || solComp.Type__c == '') || (solComp.Type__c != null && solComp.Type__c != '' && solComp.Performed_Review__c == true)){
                            srtCloneMap.put(solComp.id,solComp.CSS_SRTs__r);
                            for(CSS_SRT__c srt : solComp.CSS_SRTs__r){
                                duplicateSRTSet.add(srt.id);   
                            }
                        }
                        else if(solComp.Type__c != null && solComp.Type__c != '' && solComp.Performed_Review__c == false){
                            for(CSS_SRT__c srt : solComp.CSS_SRTs__r){
                                duplicateSRTSetNew.add(srt.id);   
                            }
                        }
                    }
                    
                     if(solComp.Fault_Code__c != null && solComp.Fault_Code__c != ''){
                        solComp.Fault_Code__c = solComp.Fault_Code__c;
                    }
                    else if(solComp.Solutions__r.Symptom__r.Name != null && solComp.Solutions__r.Symptom__r.Name != ''){
                        solComp.Fault_Code__c = solComp.Solutions__r.Symptom__r.Name;
                    }
                    else
                        solComp.Fault_Code__c = solComp.Solutions__r.FaultCode__r.Name;
                        
                    if(solComp.Fault_Code__c != null && solComp.Fault_Code__c != null){
                        //Story 188014 code changes start
                        List<CSS_SMN_FaultCode__c> jobEvSCCC=[select FC_Desc__c,Fault_Code__c from CSS_SMN_FaultCode__c where 
                                                                  Fault_Code__c=: solComp.Fault_Code__c limit 1];
                        if(jobEvSCCC != null && jobEvSCCC.size() > 0){
                            solComp.Fault_Code__c = jobEvSCCC[0].FC_Desc__c;
                        }
                        //Story 188014 code changes end
                    }
                    
                    
                    system.debug('srtCloneMap**'+srtCloneMap);
                    solComp.Id = null;

                    //where Type__c in ('Campaign','TRP','ATC')  and Service_Job__c =:workJobId and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))]);
                    if(solComp.Type__c=='Campaign' || solComp.Type__c=='TRP' || solComp.Type__c=='ATC' ){
                        System.debug('before insert... ');
                        solComp.Selected_Component__c = false;
                        if(solComp.Performed_Review__c == true && solComp.Status__c=='Approved' && ((solComp.Complete_Indicator__c==true && solComp.Multiple_Times__c==true) || (solComp.Complete_Indicator__c==false || solComp.Multiple_Times__c==true) || (solComp.Complete_Indicator__c==false && solComp.Multiple_Times__c==false)) ){
                            System.debug('solComp.Performed_Review__c>>:'+solComp.Performed_Review__c+' solComp.Status__c>>>>:'+solComp.Status__c+' solComp.Complete_Indicator__c>>>>:'+solComp.Complete_Indicator__c+' solComp.Multiple_Times__c>>>>:'+solComp.Multiple_Times__c);
                            solComp.Selected_Component__c = true;
                        }
                    }
                    solComp.Claims_Failure_Select__c = true;
                    //solCompListTemp.add(solComp);
                    system.debug('solCompMap--'+solComp.id +' '+ solComp);


                    lstNewSolComp.add(solComp);

                }
                system.debug('lstNewSolComp--'+lstNewSolComp);
                //SN - clone the part options related to the solution component
                List<CSS_Parts_Options__c> partOptionsToInsert = new List<CSS_Parts_Options__c>();
                if(lstNewSolComp !=null && lstNewSolComp.size()>0){
                    system.debug('lstNewSolComp--'+lstNewSolComp);
                    insert lstNewSolComp;
                    system.debug('partOptionMap-->>> '+partOptionMap);
                    for(CSS_Solution_Component__c solCompN : lstNewSolComp) {
                        //System.debug('inserted solComp Id>>:'+solComp.Id+' solComp Name>>>>:'+solComp.Id)
                        system.debug('solCompN.OldSolCompID__c--'+solCompN.OldSolCompID__c);
                        //SN - fetch the parts based on old CompId and create the new partOptions with new CompId
                        if(partOptionMap.containsKey((solCompN.OldSolCompID__c).Trim())){
                            //system.debug('solCompListTempMap--'+solCompListTempMap);
                            system.debug('partOptionMap--'+partOptionMap.get(solCompN.OldSolCompID__c));
                            for(CSS_Parts_Options__c partOption :  partOptionMap.get(solCompN.OldSolCompID__c)){
                                 if(solCompN.Selected_Component__c == false){
                                   continue;
                               }
                                system.debug('New Comp ID--'+solCompN.id);
                                partOption.FailurepartId__c = solCompN.id;
                                partOption.id=null;
                                partOption.Service_Job__c = null; //added newly
                                partOption.CSS_Claims__c = solCompN.CSS_Claims__c;
                                partOptionsToInsert.add(partOption);

                            }       
                        }

                        if(srtCloneMap.containsKey((solCompN.OldSolCompID__c).Trim())){

                            for(CSS_SRT__c srt :  srtCloneMap.get(solCompN.OldSolCompID__c)){
                                if((claimAccType.contains('Distributor') && srt.SRT_Type__c != 'Admin') || (claimAccType.contains('Distributor') && srt.SRT_Type__c == 'Admin' && srt.isPerformed__c == true) || !claimAccType.contains('Distributor')){//changed is delaer to claimtype - 191529
                                    system.debug('New Comp ID--'+solCompN.id);
                                    repairSortOrder = repairSortOrder + 1;
                                    srt.Component_Id__c = solCompN.id;
                                    srt.id=null;
                                    srt.Job_Order__c = null; //added newly
                                    srt.SRT_Order__c = repairSortOrder;
                                    srt.CSS_Claims__c = solCompN.CSS_Claims__c;
                                    srt.IsPopUpSRT__c = false;
                                    srt.SRT_From_Job__c = true;
                                    srt.Claimed_Hours__c = srt.Extended_Hours__c;
                                    srtCloneList.add(srt);
                                    // system.debug('solCompN.OldSolCompID__c**'+solCompN.OldSolCompID__c);
                                }
                            }       
                        }
                        system.debug('srtCloneList>>>>>>'+srtCloneList.size());
                        system.debug('srtCloneList>>>>>>'+srtCloneList);


                    }

                }

                //insert cloned SRT records of solution component
                System.debug('srtCloneList size>>:'+solCompList.size());
                if(srtCloneList.size()>0){
                    insert srtCloneList;
                    System.debug('after srtCloneList size>>:'+solCompList.size());
                    
                }
                system.debug('partOptionsToInsert.size--'+partOptionsToInsert.size()+' '+ partOptionsToInsert);
                //insert cloned part options
                if(partOptionsToInsert.size()>0){
                    insert partOptionsToInsert;   
                }  


            }
            List<CSS_Parts_Options__c> lstNewpartOption2 = new List<CSS_Parts_Options__c>();
            List<CSS_Parts_Options__c> lstNewpartOption3 = new List<CSS_Parts_Options__c>();
            recordtype rdp = [select Id, Name from recordtype where Name = :'Parts'];
            //if(!isDealer)
            if(claimAccType.contains('Distributor'))
            {
                lstNewpartOption2 = [Select Id,selected_part__c, Item__c, Part_Description__c,CSS_Claims__c,ExpenseTotal__c,
                                     Quantity__c, amount__c, Covered__c, Fail_Code__c,Account_Code__c, Notes__c,
                                     Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,Return_Instructions__c, Shipping_Address__c,FailurepartId__r.Fail_Code__c,
                                     Replacement_Reason__c, HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Parts_Type__c,ODM_Status__c,ODM_Status_Message__c,
                                     Part_Assignment__c, Unit_Price__c,Price_Book__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate__c, Currency_Type__c, Exchange_Rate_Version__c FROM CSS_Parts_Options__c where service_job__c = :workJobId and recordtypeId =: rdp.Id  and Parts_Type__c != 'Custom' and (Account_Code__c != null and Account_Code__c != '' and Account_Code__c != 'Select One') and RecordType.Name !='Parts' ]; //

                /*   else
         {
                system.debug('dealer parts option1 query starts>>');
             lstNewpartOption2 = [Select Id,selected_part__c, Item__c, Part_Description__c,CSS_Claims__c,ExpenseTotal__c,
                                 Quantity__c, amount__c, Covered__c, Fail_Code__c,Account_Code__c, Notes__c,
                                 Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,
                                 Replacement_Reason__c, HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Parts_Type__c,ODM_Status__c,ODM_Status_Message__c,
                                 Part_Assignment__c, Unit_Price__c,Price_Book__c FROM CSS_Parts_Options__c where service_job__c = :workJobId and recordtypeId =: rdp.Id  and Parts_Type__c != 'Custom']; //
         }*/
                system.debug('lstNewpartOption2----->'+lstNewpartOption2);
                if(lstNewpartOption2 !=null){
                    for(CSS_Parts_Options__c partOption1 :  lstNewpartOption2){
                        system.debug('partOption1----->'+partOption1);
                        partOption1.id=null;
                        partOption1.service_job__c = null;
                        partOption1.CSS_Claims__c = claimRecId;
                        partOption1.selected_part__c=true;
                        lstNewpartOption3.add(partOption1);

                    }       
                }

                if(lstNewpartOption3.size()>0){
                    insert lstNewpartOption3;
                }    
            }
			
            // GSSC 485 /460 start

	    /*List<CSS_Parts_Options__c> lstpartOptionGSQURP = new List<CSS_Parts_Options__c>();
            List<CSS_Parts_Options__c> lstpartOptionGSQURP1 = new List<CSS_Parts_Options__c>();
           
          
                lstpartOptionGSQURP= [Select Id,selected_part__c, Item__c, Part_Description__c,CSS_Claims__c,ExpenseTotal__c,
                                     Quantity__c, amount__c, Covered__c, Fail_Code__c,Account_Code__c, Notes__c,
                                     Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,Return_Instructions__c, Shipping_Address__c,FailurepartId__r.Fail_Code__c,
                                     Replacement_Reason__c, HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Parts_Type__c,ODM_Status__c,ODM_Status_Message__c,
                                     Part_Assignment__c, Unit_Price__c,Price_Book__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate__c, Currency_Type__c, Exchange_Rate_Version__c FROM CSS_Parts_Options__c where service_job__c = :workJobId and  RecordType.Name = 'Parts' and (Account_Code__c != null and Account_Code__c != '' and Account_Code__c != 'Select One') ];


                system.debug('lstpartOptionGSQURP----->'+lstpartOptionGSQURP);
                if(lstpartOptionGSQURP !=null){
                    for(CSS_Parts_Options__c partOption11 :  lstpartOptionGSQURP){
                        system.debug('partOption11----->'+partOption11);
                        partOption11.id=null;
                        partOption11.service_job__c = null;
                        partOption11.CSS_Claims__c = claimRecId;
                        partOption11.selected_part__c=true;
                       
                        lstpartOptionGSQURP1.add(partOption11);

                    }       
                }

                if(lstpartOptionGSQURP1.size()>0){
                    insert lstpartOptionGSQURP1;
                }    */
           // GSSC 485 /460 end

            //Cloning CSS_CampTsbTrp Records
            List<CSS_CampTsbTrp__c> CTAList = [select Type__c,URL__c,  Doc_Num__c, Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__c= :workJobId AND ESN__c = :workJobPSN  AND Type__c !='TSB'
                                               order by Performed_Review__c desc LIMIT 1000];
            System.debug('CTAList size>>:'+CTAList.size()+' CTAList>>>>:'+CTAList);
            if(CTAList !=null && CTAList.size()>0){

                List<CSS_CampTsbTrp__c> CTAListTemp = new List<CSS_CampTsbTrp__c>();
                for(CSS_CampTsbTrp__c campTsbTrp : CTAList) {
                    campTsbTrp.Id = null;
                    campTsbTrp.Job_Order__c = null;
                    campTsbTrp.CSS_Claims__c = claimRecId;
                    CTAListTemp.add(campTsbTrp);
                }
                if(CTAListTemp !=null && CTAListTemp.size()>0){
                    insert CTAListTemp;
                    System.debug('inserted CTAListTemp size>>:'+CTAListTemp.size()+' CTAListTemp>>>>:'+CTAListTemp);
                    for(CSS_CampTsbTrp__c campTsbTrp : CTAListTemp) {
                        System.debug('inserted campTsbTrp Id>>:'+campTsbTrp.Id+' campTsbTrp Type__c>>>>:'+campTsbTrp.Type__c);
                    }
                }

            }

            //As Guidanz PO on an Automated Claim only copy Part, TTML OC over to the Claim if there is an account code present
            List<CSS_Parts_Options__c> partOptionToInsert = new List<CSS_Parts_Options__c>();
            List<CSS_Parts_Options__c> partOptionToInsert1 = new List<CSS_Parts_Options__c>();
            //if(!isDealer)
            if(claimAccType.contains('Distributor'))
            {
                partOptionToInsert = [
                    select Id, FailurepartId__r.CoveredOCAmount__c, selected_part__c, Item__c, Part_Description__c,Replacement_Reason__c,
                    Quantity__c, amount__c, Covered__c, Fail_Code__c,Account_Code__c, Notes__c, ExpenseTotal__c,Siebel_Value__c,
                    HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Quantity_Used__c,Part_Name__c,Item_BMS__c,Type_BMS__c,Unit_Price__c,Parts_Type__c,
                    Sell_Price__c,Service_partnumber__c,ReturnToFactory__c,Return_Instructions__c, Shipping_Address__c,Parts_Return__c,Comments__c,ODM_Status__c,ODM_Status_Message__c,Option_Number__c ,Option_ESN__c,Warranty_Allocation__c,RecordType.Name, 
                    Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate__c, Currency_Type__c, Exchange_Rate_Version__c from CSS_Parts_Options__c where  Service_Job__c=:workJobId and FailurepartId__c = '' 
                    and ( Account_Code__c != null and Account_Code__c != '' and Account_Code__c != 'Select One') and RecordType.Name !='Parts' //Story Number 105942 Addition
                ];
            }
            else{
                system.debug('dealer parts option2 query starts>>');
                partOptionToInsert = [
                    select Id, FailurepartId__r.CoveredOCAmount__c, selected_part__c, Item__c, Part_Description__c,Replacement_Reason__c,
                    Quantity__c, amount__c, Covered__c, Fail_Code__c,Account_Code__c, Notes__c, ExpenseTotal__c,Siebel_Value__c,
                    HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Quantity_Used__c,Part_Name__c,Item_BMS__c,Type_BMS__c,Unit_Price__c,Parts_Type__c,
                    Sell_Price__c,Service_partnumber__c,ReturnToFactory__c,Return_Instructions__c, Shipping_Address__c,Parts_Return__c,Comments__c,ODM_Status__c,ODM_Status_Message__c,Option_Number__c ,Option_ESN__c,Warranty_Allocation__c,RecordType.Name,
                    Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate__c, Currency_Type__c, Exchange_Rate_Version__c
                    from CSS_Parts_Options__c where  Service_Job__c=:workJobId and FailurepartId__c = ''];//and RecordType.Name !='Parts' GSSC 485 /460

            }

            system.debug('partOptionToInsert--'+partOptionToInsert);
            for(CSS_Parts_Options__c p: partOptionToInsert ){
                p.id = null;
                p.Service_Job__c = null;
                //commented the ExpenseTotal__c field as per the Defect #154107//
                // p.ExpenseTotal__c = null;
                // Commented the below line for getting Quantity from job to claim as per "I Survived" sprint story #152963,-By RAJESH 27rd July 2018        

                //p.Unit_Price__c = String.valueof(p.Sell_Price__c);
                //End
                if(p.RecordType.Name =='OtherClaimables'){
                    p.Unit_Price__c = String.valueof(p.Sell_Price__c);
                    p.ExpenseTotal__c = p.Amount__c;
                }
                p.Sell_Price__c = null;
                p.CSS_Claims__c = claimRecId;
                p.Item_BMS__c = p.Item__c;
                if(p.Siebel_Value__c != null && p.Siebel_Value__c != '' && p.Siebel_Value__c.contains('Unlisted')){
                    p.Item__c = 'Unlisted';
                }
                p.selected_part__c = true;//Added as part of #story 190271
                p.Type_BMS__c = p.Type__c;

                if(p.Type__c != null && p.Type__c != ''){
                    if(p.Type__c.contains('LODGE- FSE'))
                        p.Type__c = 'Lodging';
                    else if(p.Type__c.contains('MEAL- FSE'))
                        p.Type__c = 'Meals';
                    else if(p.Type__c.contains('MEAL- FSPG'))
                        p.Type__c = 'Meals';
                   
                    // Removed the space from "Non Commercial-Travel" as per "I Survived" sprint story #152963,-By RAJESH 27th July 2018                             
                    else if(p.Type__c.contains('MILE WARR FSE')){
                        p.Type__c = 'Non Commercial-Travel';
                        // Passing quantity to Mileage when type is "Non Commercial-Travel" as per "I Survived" sprint story #152963,-By RAJESH 27th July 2018                        
                        p.Mileage__c=p.Quantity__c;
                        p.ExpenseTotal__c=p.ExpenseTotal__c;
                        system.debug('****p.Mileage__c'+p.Mileage__c);
                    }
                    // Removed the space from "Commercial-Travel" as per "I Survived" sprint story #152963,-By RAJESH 27th July 2018                  
                    else if(p.Type__c.contains('MILE WARR FSPG')){
                        p.Type__c = 'Non Commercial-Travel';
                        p.Mileage__c=p.Quantity__c;
                        p.ExpenseTotal__c=p.ExpenseTotal__c;                        
                        system.debug('****p.Mileage__c'+p.Mileage__c);
                    }
                    else if(p.Type__c.contains('PARKING-FSE'))
                        p.Type__c = 'Commercial-Travel';
                    else if(p.Type__c.contains('PARKING-FSPG'))
                        p.Type__c = 'Commercial-Travel';
                    else if(p.Type__c.contains('TOLLS-FSE'))
                        p.Type__c = 'Commercial-Travel';
                    else if(p.Type__c.contains('TOLLS-FSPG'))
                        p.Type__c = 'Commercial-Travel';
                    //else
                    //p.Type__c = p.Type__c; //Commented as part of the defect #165807
                }
                
                if(p.Parts_Type__c != 'Custom'){
                    partOptionToInsert1.add(p);
                }
                else{
                    if(p.Account_Code__c != null && p.Account_Code__c != '' && p.Account_Code__c != 'Select One'){
                        partOptionToInsert1.add(p);
                    }
                }

            }

            system.debug('partOptionToInsert1--'+partOptionToInsert1);

            if(partOptionToInsert1.size()>0){

                insert partOptionToInsert1;
            } 
            //Clone method for Claims SRT object
            List<CSS_SRT__C> srt1 = new List<CSS_SRT__C>();
            List<CSS_SRT__C> srt2 = new List<CSS_SRT__C>();
            duplicateSRTSet.addAll(duplicateSRTSetNew);
            system.debug('Today duplicateSRTSet ' + duplicateSRTSet);
            //Added condition like Type__c !='Private' in query as per Simpsons story #145402, By -RAJESH   
            //if(!isDealer)//Commented and added claim type condition instead of user for defect 191877
            if(claimAccType.contains('Distributor'))//
            {
                srt1 = [select Id,Name,Flex_Flag__c,Overlap_Hours__c,Extended_Hours__c,Account_Code__c,FailCode__c,SRT_Order__c,Component_Id__c,Component_Id__r.Root_Cause__c,Override__c,OverrideReason__c,Override_Reason__c,Overlap_Step_Id__c,Adjusted_Overlap_Hours__c,Overlap_SRT_Number__c,SRT_ID__c,Account_Code_Description__c,Fail_Code_Description__c,
                        Repair_Access_Calculated__c,SRT_Time__c,Assignment__c, Solution_Number__c, step_id__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Time__c,
                        Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,ECM_Flag__c,
                        SRT_Status_Message__c,SRT_Notes__c ,SRT_Warrantable__c,Job_Engine_Access_Code__c,AccountCode_Formula__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,
                        Access_Code_Saved__c,job_order__r.AccessCode__c,srt_category__c,ODM_Status__c,ODM_Status_Message__c,SRT_Select__c,SRT_Access_Code__c,SRT_Usage__c,isDuplicateRootCause__c
                        from CSS_SRT__C where Job_Order__c=:workJobId AND ID NOT IN:duplicateSRTSet AND Type__c !='Private' and (AccountCode_Formula__c != null and AccountCode_Formula__c != '' and AccountCode_Formula__c not in ('Select One')) and SRT_ID__c != '' and SRT_ID__c != null and 
                        (Solution_Number__c = null or (Solution_Number__c != null and (Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' or Solution_Number__r.Diagnostic_Response__c = 'Not the solution'))) and isDuplicateRootCause__c = false];
                        //and Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution'];/*  AND Component_Id__c= NULL and Type__c IN('Diagnosis','Repair','Diag Access','Repair Access')*/
            }
            else{
                system.debug('dealer srt query starts>>');
                srt1 = [select Id, Name,Flex_Flag__c,Overlap_Hours__c,Account_Code__c,Extended_Hours__c,FailCode__c,SRT_Order__c,Component_Id__c,Component_Id__r.Root_Cause__c,Override__c,OverrideReason__c,Override_Reason__c,Overlap_Step_Id__c,Adjusted_Overlap_Hours__c,Overlap_SRT_Number__c,SRT_ID__c,Account_Code_Description__c,Fail_Code_Description__c,
                        Repair_Access_Calculated__c,SRT_Time__c,Assignment__c, Solution_Number__c, step_id__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Time__c,
                        Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,ECM_Flag__c,
                        SRT_Status_Message__c,SRT_Notes__c ,SRT_Warrantable__c,Job_Engine_Access_Code__c,AccountCode_Formula__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,
                        Access_Code_Saved__c,job_order__r.AccessCode__c,srt_category__c,ODM_Status__c,ODM_Status_Message__c,SRT_Select__c,SRT_Access_Code__c,SRT_Usage__c,isDuplicateRootCause__c
                        from CSS_SRT__C where Job_Order__c=:workJobId AND ID NOT IN:duplicateSRTSet AND Type__c !='Private' and SRT_ID__c != null and SRT_ID__c != '' and 
                        (Solution_Number__c = null or (Solution_Number__c != null and (Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' or Solution_Number__r.Diagnostic_Response__c = 'Not the solution'))) and isDuplicateRootCause__c =false];
                        //and Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution'];
            }

            system.debug('SRTObject'+srt1.size());
            system.debug('JobSRTs***'+srt1);
            Integer DiagnosisSortOrder=0;
            integer i = 0;
            for(CSS_SRT__C s:srt1){
                system.debug('for  s.SRTid= ' + s.SRT_ID__c);
                
                if((s.Type__c == 'Repair' || s.SRT_Category__c == 'AdditionalRep') && (s.Component_Id__c == null)){	// && s.Component_Id__r.Root_Cause__c != true
                    if(s.AccountCode_Formula__c != null && s.AccountCode_Formula__c != '' && s.AccountCode_Formula__c != 'Select One'){
                       system.debug('second If s.SRTid= ' + s.SRT_ID__c);
                        s.id=null;
                        s.Job_Order__c = null;
                        s.CSS_Claims__c = claimRecId;
                        srt2.add(s);
                    }
                    //system.debug('inside root cause false value ' + s.Component_Id__r.Root_Cause__c);
                    //continue;
                }
                
              else  if(s.Type__c == 'Repair'  && s.Component_Id__r.Root_Cause__c != true){
                    system.debug('first If s.SRTid= ' + s.SRT_ID__c);
                    system.debug('inside root cause false value ' + s.Component_Id__r.Root_Cause__c);
                    continue;
                }
                
                else{
                    if((claimAccType.contains('Distributor') && s.SRT_Type__c != 'Admin') || (claimAccType.contains('Distributor') && s.SRT_Type__c == 'Admin' && s.isPerformed__c == true) || !claimAccType.contains('Distributor')){
                         system.debug('third If s.SRTid= ' + s.SRT_ID__c);
                        s.id=null;
                        s.Job_Order__c = null;
                        s.CSS_Claims__c = claimRecId;
                        if((s.SRT_Category__c != null && s.SRT_Category__c == 'AdditionalRep') || (s.Type__c!= null && s.Type__c == 'Repair Access') || (s.Solution_Number__c!= null && s.Type__c == 'Repair')){
                            repairSortOrder = repairSortOrder + 1;
                            s.SRT_Order__c = repairSortOrder;
                        }
                        if((s.Solution_Number__c != null && s.Type__c == 'Diagnosis')|| (s.Type__c!= null && s.Type__c == 'Diag Access') || (s.SRT_Category__c != null && s.srt_category__c == 'AdditionalDiag')){
                            DiagnosisSortOrder = DiagnosisSortOrder + 1;
                            s.SRT_Order__c = DiagnosisSortOrder;
                        }
                        s.SRT_From_Job__c = true;
                        //srt2.add(s);  //Commented as part of the story GSSC-459
                    }
                    //GSSC-459 - START
                    if(!claimAccType.contains('Distributor')){
                        if((s.Type__c == 'Repair Access' && s.SRT_Type__c == 'Access') || (s.SRT_Category__c == 'AdditionalRep') || (s.type__c=='Repair')){
                            if(s.AccountCode_Formula__c != null && s.AccountCode_Formula__c != '' && s.AccountCode_Formula__c != 'Select One'){
                                srt2.add(s);
                            }
                            else{
                                repairSortOrder = repairSortOrder - 1;
                            }
                        }
                        else{
                            srt2.add(s);
                        }
                    }
                    else{
                        srt2.add(s);
                    }
                    //GSSC-459 - END
                }
            }
            System.debug('srt2 size>>:'+srt2.size());
            system.debug('ClaimSRTs***'+srt2);
            if(srt2.size()>0){
                insert srt2;
                System.debug('after srt2 size>>:'+srt2.size());
                
            }
            //Clone Method for Attachments
            List<Attachment>att1 = new List<Attachment>();
            List<Attachment>att2 = new List<Attachment>();
            //att1 = [Select Id,Body,Name,Description,parentid, LastModifiedDate from attachment where parentid= :workJobId];
           // system.debug('Attachments'+att1);
            Attachment ab;
            for(Attachment a:[Select Id,Body,Name,Description,parentid, LastModifiedDate from attachment where parentid= :workJobId]){
                //a.id = null;
                // a.parentid = null;
                ab = new Attachment();
                ab.body = a.body;
                ab.name = a.name;
                ab.description = a.description;

                ab.parentid = claimRecId;
                att2.add(ab); 


            }
            if(att2.size()>0){
                insert att2;
                system.debug('claimatt'+att2);

            }
            CSS_Claims__c claimInsert = new CSS_Claims__c();
            system.debug('onlyPWaccountCode-->'+onlyPWaccountCode);
            system.debug('claimAccType-->'+claimAccType);
            system.debug('paccarAuthReqdJob-->'+paccarAuthReqdJob);
            if(solCompList != null && solCompList.size() > 0){
                if(isAllAccCodeNull == true){
                    claimInsert.Id = claimRecId;
                    claimInsert.No_Failure_PACCAR_Flag__c = true;
                }
                else if(onlyPWaccountCode == true && claimAccType == 'Dealer Account' && paccarAuthReqdJob == true){
                    if(isAnyAccCodeNull == false){
                        claimInsert.Id = claimRecId;
                        claimInsert.Parts_Warranty_Claim_Only__c = true;
                        claimInsert.PACCAR_PW_AutoSelected__c = true;
                    }
                    else{
                        claimInsert.Id = claimRecId;
                        claimInsert.No_Failure_PACCAR_Flag__c = true;
                    }
                }
                else if(onlyPWaccountCode == false && claimAccType == 'Dealer Account' && paccarAuthReqdJob == true){
                    claimInsert.Id = claimRecId;
                    claimInsert.PACCAR_Auth_Required__c = true;
                    claimInsert.PACCAR_Flag__c = true;
                    claimInsert.PACCAR_Mixed_Accountcodes__c = true; //Added as part of the defect #GSSC-225
                }
            }
            else{
                if(paccarAuthReqdJob == true){
                    claimInsert.Id = claimRecId;
                    claimInsert.No_Failure_PACCAR_Flag__c = true;
                }
            }
            
            if(ServJob!=null && ServJob.FieldActionWebServiceResult__c == 'Error'){
               System.debug('FieldActionWebServiceResult1****' + ServJob.FieldActionWebServiceResult__c);
                claimInsert.Id = claimRecId;
                claimInsert.FieldActionWebServiceResult__c = 'Error';
                System.debug('FieldActionWebServiceResult2****' + claimInsert.FieldActionWebServiceResult__c);
            }
            
            CSS_Claims__c emptyClaim = new CSS_Claims__c();
            system.debug('claimInsert-->'+claimInsert);
            system.debug('claimRecId-->'+claimRecId);
            if(claimInsert != emptyClaim){
                update claimInsert;
            }
            system.debug('paccarAuthReqdJob-->'+claimInsert);
            
            //GSSC-106
            CSS_Claims__c mileageProdHrsErrorUpd = new CSS_Claims__c();
            mileageProdHrsErrorUpd.Id = claimRecId;
            system.debug('mileageProdHrsError--'+mileageProdHrsError);
            if(mileageProdHrsError == true){
                mileageProdHrsErrorUpd.MileageProdHrsError__c = 'Error';
            }
            else{
                mileageProdHrsErrorUpd.MileageProdHrsError__c = 'Success';
            }
            
            update mileageProdHrsErrorUpd;

        }catch(exception e){
            system.debug('EXCEPTION of CG_BL_Claims - cloneAutomatedCampaigns Method ErrorMessage>>>:'+e.getMessage() + ' LineNumber>>:' + e.getLineNumber() + ' Rootcause>>:' +e.getCause());
        }
    }
    //Method to display list of Claim Types in Failures Popup
    //clone automated campaigns for claims
    public static void cloneCopyCampaigns(string claimRecId, String workJobPSN, string claimRecId1) {
        system.debug('claimRecId--'+claimRecId);
        system.debug('in cloneAutomatedCampaigns of CG_BL_Claims...');
        List<CSS_Solution_Component__c> solCompList;
        Integer repairSortOrder=0;
        Set<id> duplicateSRTSet = new Set<id>();
        try{
            //Cloning SolComp Records
            //Added "Fault_Code__c" field in below query as per SIT story #150030, -By RAJESH 25th June 2018
            //Added "ODM_Penalty__c" field in the below query as per story 180325 on 02/04/2019
            solCompList = new List<CSS_Solution_Component__c>([select Name,AccountCode__c,AccountCode_Call_Status__c,AccountCodeEdit__c,AccountCodeType__c,Action__c,Approval_Code__c,Selected_Claim_Type__c,Claim_Type__c,Fault_Code__c,
                                                               Authorization_Number__c,Business_Unit__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,
                                                               Campaign_Start_Date__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,CertificateNumber__c,Charlength__c,Complete_Indicator__c,Component_Code__c,Component_Id__c,
                                                               CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredPartsQty_Percentage__c,CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c,
                                                               CoveredTravelLabor__c,CoveredTravelMiles__c,CSS_Account_Formula__c,CSS_CoverageType__c,Solutions__c,DeductibleAmount__c,Customer_Take_Possession__c,Engine_Family_Code__c,
                                                               Equip_ID__c,Fail_Code__c,Fail_Code_Editable__c,FailCode_Formula__c,Failure_Date__c,Failure_Measure__c,Failure_Mode__c,Failure_Point__c,In_Shop_SRT_Limit_Flag__c,
                                                               Multiple_Times__c,Notes__c,Parts_Warranty__c,RoadRelay_Warranty__c,Part_Warranty_Start_Date__c,Pay_Code__c,Performed__c,Performed_Review__c,Quantity__c,Reviewed__c,Selected_Component__c,ComponentCode_Desc__c,
                                                               Service_Model__c,SRT_Fetched__c,SRT_Total__c,Status__c,System_Code__c,SystemCode_Desc__c,FailMode_Desc__c,Type__c,Unique_Component__c,URL__c,WarrantyId__c,Claims_Failure_Select__c,ODM_Status__c,ODM_Status_Message__c,ODM_Penalty__c,
                                                               (select name,Flex_Flag__c,ECM_Flag__c,Component_Id__c,Extended_Hours__c,AccountCode_Formula__c,Account_Code__c,FailCode__c,SRT_ID__c,SRT_Order__c,id,Repair_Access_Calculated__c,SRT_Time__c,step_id__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Time__c,Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,Assignment__c,Solution_Number__c, SRT_Status_Message__c,SRT_Notes__c ,SRT_Warrantable__c,Job_Engine_Access_Code__c,SRT_Access_Code__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Access_Code_Saved__c,job_order__r.AccessCode__c,srt_category__c,ODM_Status__c,ODM_Status_Message__c,SRT_Select__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c
                                                                from CSS_SRTs__r  where SRT_ID__c != null and SRT_ID__c != '' and 
                                                                (Solution_Number__c = null or (Solution_Number__c != null and (Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' or Solution_Number__r.Diagnostic_Response__c = 'Not the solution')))),
                                                                (Select Id,selected_part__c, Item__c, Part_Description__c,Unit_Price__c,
                                                                Quantity__c, amount__c, Covered__c, Fail_Code__c,Account_Code__c, Notes__c, Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,Return_Instructions__c, Shipping_Address__c,FailurepartId__r.Fail_Code__c,Replacement_Reason__c,
                                                                HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,ODM_Status__c,ODM_Status_Message__c, Part_Assignment__c, Parts_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate__c, Currency_Type__c, Exchange_Rate_Version__c FROM CSS_Parts_Options__r)//where Part_Assignment__c = 'Primary'
                                                               from CSS_Solution_Component__c where  CSS_Claims__c =:claimRecId]);  // and Selected_Component__c= true and AccountCode__c!=null (defect 151373 )//where Type__c in ('Campaign','TRP','ATC')  and Service_Job__c =:workJobId and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))]);
            Map<id, List<CSS_Parts_Options__c>> partOptionMap= new Map<id,List<CSS_Parts_Options__c>>();
            System.debug('solCompList size>>:'+solCompList.size()+' solCompList>>>>:'+solCompList);
            if(solCompList !=null && solCompList.size()>0){


                List<CSS_Solution_Component__c> solCompListTemp = new List<CSS_Solution_Component__c>();
                Map<id,CSS_Solution_Component__c> solCompListTempMap = new Map<id,CSS_Solution_Component__c> ();
                Map<id,CSS_Parts_Options__c> partsOptionsMap = new Map<id,CSS_Parts_Options__c> ();
                List<CSS_Solution_Component__c> lstNewSolComp = new List<CSS_Solution_Component__c>();
                List<CSS_Parts_Options__c> lstNewpartOption = new List<CSS_Parts_Options__c>();
                List<CSS_Parts_Options__c> lstNewpartOption1 = new List<CSS_Parts_Options__c>();
                List<CSS_SRT__C> srtCloneList = new List<CSS_SRT__C>();
                Map<id,List<CSS_SRT__C>> srtCloneMap = new Map<id,List<CSS_SRT__C>>();
                for(CSS_Solution_Component__c solComp : solCompList) {
                    //solComp.Id = null;
                    solcomp.OldSolCompID__c = solComp.Id;
                    //solComp.Service_Job__c = null;
                    solComp.CSS_Claims__c = claimRecId1;
                    system.debug('Parts Records--'+solComp.CSS_Parts_Options__r);
                    if(solComp.CSS_Parts_Options__r!=null && solComp.CSS_Parts_Options__r.size()>0){
                        partOptionMap.put(solComp.id,solComp.CSS_Parts_Options__r);    
                    }

                    if(solComp.CSS_SRTs__r!=null && solComp.CSS_SRTs__r.size()>0){
                        srtCloneMap.put(solComp.id,solComp.CSS_SRTs__r);
                        for(CSS_SRT__c srt : solComp.CSS_SRTs__r){
                            duplicateSRTSet.add(srt.id);   
                        }
                    }
                    system.debug('srtCloneMap**'+srtCloneMap);
                    solComp.Id = null;

                    //where Type__c in ('Campaign','TRP','ATC')  and Service_Job__c =:workJobId and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))]);
                    if(solComp.Type__c=='Campaign' || solComp.Type__c=='TRP' || solComp.Type__c=='ATC' ){
                        System.debug('before insert... ');
                        solComp.Selected_Component__c = false;
                        if(solComp.Performed_Review__c == true && solComp.Status__c=='Approved' && ((solComp.Complete_Indicator__c==true && solComp.Multiple_Times__c==true) || (solComp.Complete_Indicator__c==false || solComp.Multiple_Times__c==true) || (solComp.Complete_Indicator__c==false && solComp.Multiple_Times__c==false)) ){
                            System.debug('solComp.Performed_Review__c>>:'+solComp.Performed_Review__c+' solComp.Status__c>>>>:'+solComp.Status__c+' solComp.Complete_Indicator__c>>>>:'+solComp.Complete_Indicator__c+' solComp.Multiple_Times__c>>>>:'+solComp.Multiple_Times__c);
                            solComp.Selected_Component__c = true;
                        }
                    }
                    solComp.Claims_Failure_Select__c = true;
                    //solCompListTemp.add(solComp);
                    system.debug('solCompMap--'+solComp.id +' '+ solComp);


                    lstNewSolComp.add(solComp);

                }

                system.debug('lstNewSolComp--'+lstNewSolComp);
                //SN - clone the part options related to the solution component
                List<CSS_Parts_Options__c> partOptionsToInsert = new List<CSS_Parts_Options__c>();
                if(lstNewSolComp !=null && lstNewSolComp.size()>0){
                    system.debug('lstNewSolComp--'+lstNewSolComp);
                    insert lstNewSolComp;

                    for(CSS_Solution_Component__c solCompN : lstNewSolComp) {
                        //System.debug('inserted solComp Id>>:'+solComp.Id+' solComp Name>>>>:'+solComp.Id)
                        system.debug('solCompN.OldSolCompID__c--'+solCompN.OldSolCompID__c);
                        //SN - fetch the parts based on old CompId and create the new partOptions with new CompId
                        if(partOptionMap.containsKey((solCompN.OldSolCompID__c).Trim())){
                            //system.debug('solCompListTempMap--'+solCompListTempMap);
                            system.debug('partOptionMap--'+partOptionMap.get(solCompN.OldSolCompID__c));
                            for(CSS_Parts_Options__c partOption :  partOptionMap.get(solCompN.OldSolCompID__c)){
                                system.debug('New Comp ID--'+solCompN.id);
                                partOption.FailurepartId__c = solCompN.id;
                                partOption.id=null;
                                partOption.Service_Job__c = null; //added newly
                                partOption.CSS_Claims__c = solCompN.CSS_Claims__c;
                                partOptionsToInsert.add(partOption);

                            }       
                        }

                        if(srtCloneMap.containsKey((solCompN.OldSolCompID__c).Trim())){

                            for(CSS_SRT__c srt :  srtCloneMap.get(solCompN.OldSolCompID__c)){
                                system.debug('New Comp ID--'+solCompN.id);
                                repairSortOrder = repairSortOrder + 1;
                                srt.Component_Id__c = solCompN.id;
                                srt.id=null;
                                srt.Job_Order__c = null; //added newly
                                srt.SRT_Order__c = repairSortOrder;
                                srt.CSS_Claims__c = solCompN.CSS_Claims__c;
                                srtCloneList.add(srt);
                                // system.debug('solCompN.OldSolCompID__c**'+solCompN.OldSolCompID__c);
                            }       
                        }
                        system.debug('srtCloneList>>>>>>'+srtCloneList.size());
                        system.debug('srtCloneList>>>>>>'+srtCloneList);


                    }

                }

                //insert cloned SRT records of solution component
                System.debug('srtCloneList size>>:'+solCompList.size());
                if(srtCloneList.size()>0){
                    insert srtCloneList;
                    System.debug('after srtCloneList size>>:'+solCompList.size());
                }
                system.debug('partOptionsToInsert--'+partOptionsToInsert);
                //insert cloned part options
                if(partOptionsToInsert.size()>0){
                    insert partOptionsToInsert;   
                }  


            }
            /*  List<CSS_Parts_Options__c> lstNewpartOption2 = new List<CSS_Parts_Options__c>();
            List<CSS_Parts_Options__c> lstNewpartOption3 = new List<CSS_Parts_Options__c>();
            recordtype rdp = [select Id, Name from recordtype where Name = :'Parts'];
            lstNewpartOption2 = [Select Id,selected_part__c, Item__c, Part_Description__c,CSS_Claims__c,ExpenseTotal__c,
                                 Quantity__c, amount__c, Covered__c, Fail_Code__c,Account_Code__c, Notes__c,
                                 Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,
                                 Replacement_Reason__c, HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Parts_Type__c,ODM_Status__c,ODM_Status_Message__c,
                                 Part_Assignment__c, Unit_Price__c,Price_Book__c FROM CSS_Parts_Options__c where CSS_Claims__c = :claimRecId and recordtypeId =: rdp.Id  and Parts_Type__c != 'Custom' and (Account_Code__c != null and Account_Code__c != '' and Account_Code__c != 'Select One')]; //

            if(lstNewpartOption2 !=null){
                for(CSS_Parts_Options__c partOption1 :  lstNewpartOption2){
                    system.debug('partOption1----->'+partOption1);
                    partOption1.id=null;
                    partOption1.service_job__c = null;
                    partOption1.CSS_Claims__c = claimRecId1;
                    lstNewpartOption3.add(partOption1);

                }       
            }

            if(lstNewpartOption3.size()>0){
                insert lstNewpartOption3;
            }    
*/


            //Cloning CSS_CampTsbTrp Records//workjobpsn
            List<CSS_CampTsbTrp__c> CTAList = [select Type__c,URL__c,  Doc_Num__c, Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where CSS_Claims__c= :claimRecId AND ESN__c = :workJobPSN  AND Type__c !='TSB'
                                               order by Performed_Review__c desc LIMIT 1000];
            System.debug('CTAList size>>:'+CTAList.size()+' CTAList>>>>:'+CTAList);
            if(CTAList !=null && CTAList.size()>0){

                List<CSS_CampTsbTrp__c> CTAListTemp = new List<CSS_CampTsbTrp__c>();
                for(CSS_CampTsbTrp__c campTsbTrp : CTAList) {
                    campTsbTrp.Id = null;
                    campTsbTrp.Job_Order__c = null;
                    campTsbTrp.CSS_Claims__c = claimRecId1;
                    CTAListTemp.add(campTsbTrp);
                }
                if(CTAListTemp !=null && CTAListTemp.size()>0){
                    insert CTAListTemp;
                    System.debug('inserted CTAListTemp size>>:'+CTAListTemp.size()+' CTAListTemp>>>>:'+CTAListTemp);
                    for(CSS_CampTsbTrp__c campTsbTrp : CTAListTemp) {
                        System.debug('inserted campTsbTrp Id>>:'+campTsbTrp.Id+' campTsbTrp Type__c>>>>:'+campTsbTrp.Type__c);
                    }
                }

            }

            //As Guidanz PO on an Automated Claim only copy Part, TTML OC over to the Claim if there is an account code present
            List<CSS_Parts_Options__c> partOptionToInsert = new List<CSS_Parts_Options__c>();
            List<CSS_Parts_Options__c> partOptionToInsert1 = new List<CSS_Parts_Options__c>();
            partOptionToInsert = [
                select Id, FailurepartId__r.CoveredOCAmount__c, selected_part__c, Item__c, Part_Description__c,Replacement_Reason__c,
                Quantity__c, amount__c, Covered__c, Fail_Code__c,Account_Code__c, Notes__c, ExpenseTotal__c,Siebel_Value__c,
                HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Quantity_Used__c,Part_Name__c,Item_BMS__c,Type_BMS__c,Unit_Price__c,Parts_Type__c,
                Sell_Price__c,Service_partnumber__c,ReturnToFactory__c,Return_Instructions__c, Shipping_Address__c,Parts_Return__c,Comments__c,ODM_Status__c,ODM_Status_Message__c,Option_Number__c ,Option_ESN__c,Warranty_Allocation__c,RecordType.Name,
                Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate__c, Currency_Type__c, Exchange_Rate_Version__c
                from CSS_Parts_Options__c where  CSS_Claims__c=:claimRecId and FailurepartId__c = '' 
                //Story Number 105942 Addition
            ];
            system.debug('partOptionToInsert--'+partOptionToInsert);
            for(CSS_Parts_Options__c p: partOptionToInsert ){
                p.id = null;
                p.Service_Job__c = null;
                //commented the ExpenseTotal__c field as per the Defect #154107//
                // p.ExpenseTotal__c = null;
                // Commented the below line for getting Quantity from job to claim as per "I Survived" sprint story #152963,-By RAJESH 27rd July 2018        

                //p.Unit_Price__c = String.valueof(p.Sell_Price__c);
                //End
                if(p.RecordType.Name =='OtherClaimables'){
                    p.Unit_Price__c = String.valueof(p.Sell_Price__c);
                    p.ExpenseTotal__c = p.Amount__c;
                }
                p.Sell_Price__c = null;
                p.selected_part__c = true;//Added as part of story#190271
                p.CSS_Claims__c = claimRecId1;
                p.Item_BMS__c = p.Item__c;
                if(p.Siebel_Value__c != null && p.Siebel_Value__c != '' && p.Siebel_Value__c.contains('Unlisted')){
                    p.Item__c = 'Unlisted';
                }

                p.Type_BMS__c = p.Type__c;

                if(p.Type__c != null && p.Type__c != ''){
                    if(p.Type__c.contains('LODGE- FSE'))
                        p.Type__c = 'Lodging';
                    else if(p.Type__c.contains('MEAL- FSE'))
                        p.Type__c = 'Meals';
                    else if(p.Type__c.contains('MEAL- FSPG'))
                        p.Type__c = 'Meals';
                    // Removed the space from "Non Commercial-Travel" as per "I Survived" sprint story #152963,-By RAJESH 27th July 2018                             
                    else if(p.Type__c.contains('MILE WARR FSE')){
                        p.Type__c = 'Non Commercial-Travel';
                        // Passing quantity to Mileage when type is "Non Commercial-Travel" as per "I Survived" sprint story #152963,-By RAJESH 27th July 2018                        
                        p.Mileage__c=p.Quantity__c;
                        p.ExpenseTotal__c=p.ExpenseTotal__c;
                        system.debug('****p.Mileage__c'+p.Mileage__c);
                    }
                    // Removed the space from "Commercial-Travel" as per "I Survived" sprint story #152963,-By RAJESH 27th July 2018                  
                    else if(p.Type__c.contains('MILE WARR FSPG')){
                        p.Type__c = 'Non Commercial-Travel';
                        p.Mileage__c=p.Quantity__c;
                        p.ExpenseTotal__c=p.ExpenseTotal__c;                        
                        system.debug('****p.Mileage__c'+p.Mileage__c);
                    }
                    else if(p.Type__c.contains('PARKING-FSE'))
                        p.Type__c = 'Commercial-Travel';
                    else if(p.Type__c.contains('PARKING-FSPG'))
                        p.Type__c = 'Commercial-Travel';
                    else if(p.Type__c.contains('TOLLS-FSE'))
                        p.Type__c = 'Commercial-Travel';
                    else if(p.Type__c.contains('TOLLS-FSPG'))
                        p.Type__c = 'Commercial-Travel';
                    else
                        p.Type__c = '';
                }
                partOptionToInsert1.add(p);

            }

            system.debug('partOptionToInsert1--'+partOptionToInsert1);

            if(partOptionToInsert1.size()>0){

                insert partOptionToInsert1;
            } 
            //Clone method for Claims SRT object
            List<CSS_SRT__C> srt1 = new List<CSS_SRT__C>();
            List<CSS_SRT__C> srt2 = new List<CSS_SRT__C>();
            //Added condition like Type__c !='Private' in query as per Simpsons story #145402, By -RAJESH           
            srt1 = [select name,Flex_Flag__c,Overlap_Hours__c,Account_Code__c,Extended_Hours__c,FailCode__c,SRT_Order__c,Component_Id__c,Override__c,OverrideReason__c,Override_Reason__c,Overlap_Step_Id__c,Adjusted_Overlap_Hours__c,Overlap_SRT_Number__c,SRT_ID__c,Account_Code_Description__c,Fail_Code_Description__c,
                    Repair_Access_Calculated__c,SRT_Time__c,Assignment__c, Solution_Number__c, step_id__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Time__c,
                    Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,ECM_Flag__c,
                    SRT_Status_Message__c,SRT_Notes__c ,SRT_Warrantable__c,Job_Engine_Access_Code__c,AccountCode_Formula__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,
                    Access_Code_Saved__c,job_order__r.AccessCode__c,srt_category__c,ODM_Status__c,ODM_Status_Message__c,SRT_Select__c,SRT_Access_Code__c
                    from CSS_SRT__C where CSS_Claims__c=:claimRecId AND ID NOT IN:duplicateSRTSet AND Type__c !='Private' and SRT_ID__c != null and SRT_ID__c != '' and 
                    (Solution_Number__c = null or (Solution_Number__c != null and (Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' or Solution_Number__r.Diagnostic_Response__c = 'Not the solution')))];
                    //and Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution'];/*  AND Component_Id__c= NULL and Type__c IN('Diagnosis','Repair','Diag Access','Repair Access')*/
            system.debug('SRTObject'+srt1.size());
            system.debug('JobSRTs***'+srt1);
            Integer DiagnosisSortOrder=0;
            for(CSS_SRT__C s:srt1){
                s.id=null;
                s.Job_Order__c = null;
                s.CSS_Claims__c = claimRecId1;
                if((s.SRT_Category__c != null && s.SRT_Category__c == 'AdditionalRep') || (s.Type__c!= null && s.Type__c == 'Repair Access') || (s.Solution_Number__c!= null && s.Type__c == 'Repair')){
                    repairSortOrder = repairSortOrder + 1;
                    s.SRT_Order__c = repairSortOrder;
                }
                if((s.Solution_Number__c != null && s.Type__c == 'Diagnosis')|| (s.Type__c!= null && s.Type__c == 'Diag Access') || (s.SRT_Category__c != null && s.srt_category__c == 'AdditionalDiag')){
                    DiagnosisSortOrder = DiagnosisSortOrder + 1;
                    s.SRT_Order__c = DiagnosisSortOrder;
                }
                srt2.add(s);

            }
            System.debug('srt2 size>>:'+srt2.size());
            system.debug('ClaimSRTs***'+srt2);
            if(srt2.size()>0){
                insert srt2;
                System.debug('after srt2 size>>:'+srt2.size());
            }
            //Clone Method for Attachments
            List<Attachment>att1 = new List<Attachment>();
            List<Attachment>att2 = new List<Attachment>();
           // att1 = [Select Id,Body,Name,Description,parentid, LastModifiedDate from attachment where parentid= :claimRecId];
           // system.debug('Attachments'+att1);
            Attachment ab;
             for(Attachment a:[Select Id,Body,Name,Description,parentid, LastModifiedDate from attachment where parentid= :claimRecId]){
                //a.id = null;
                // a.parentid = null;
                ab = new Attachment();
                ab.body = a.body;
                ab.name = a.name;
                ab.description = a.description;

                ab.parentid = claimRecId1;
                att2.add(ab); 


            }
            if(att2.size()>0){
                insert att2;
                system.debug('claimatt'+att2);

            }


        }catch(exception e){
            system.debug('EXCEPTION of CG_BL_Claims - cloneAutomatedCampaigns Method ErrorMessage>>>:'+e.getMessage() + ' LineNumber>>:' + e.getLineNumber() + ' Rootcause>>:' +e.getCause());
        }
    }
    public static List<SelectOption> getClaimType(Id cid, String creator_Location, string pgName) {
        List<SelectOption> claimTypeList; 
        try {
            string strLoc;

            system.debug('***claimId***'+cid);
            if (cid == null){
                Id userId = UserInfo.getUserId();
                User usr = css_utility.getUserAttributes(userId);
                strLoc = usr.User_Location__c;
                system.debug('strLoc***'+strLoc);
            }else{
                strLoc = creator_Location;
                system.debug('strLoc--'+strLoc);
            }
            CSS_JobEventTemporary__c[] lclaimtype;
            system.debug('lclaimtype***'+lclaimtype);
            lclaimtype=[select Reason__c from CSS_JobEventTemporary__c where attribute1__c='ClaimType' and Key__c=:strLoc];
            system.debug('After+lclaimtype***'+lclaimtype);
            map<string, object> mpclaimtype=(map<string, object>)JSON.deserializeUntyped(lclaimtype[0].Reason__c);
            system.debug('mpclaimtype-->'+mpclaimtype); 

            claimTypeList = new List<SelectOption>();
            if(pgName=='JobPlan'){
                claimTypeList.add(new SelectOption('','-Select One-'));}
            else
                claimTypeList.add(new SelectOption('','Select One'));

            for(string ct: mpclaimtype.keyset()){

                claimTypeList.add(new SelectOption(ct, ct));
            }

            claimTypeList.sort();
            system.debug('claimTypeList**'+claimTypeList);
        }
        catch(exception e)
        {}
        return claimTypeList;
    }


    public static void psnTabOff(String esn){
        System.debug('in psnTabOff...');
        CSS_getEngineDataResponseJ2A engineData;
        String wsErrorMsg;
        String qsolLanguage; //Need to get value for this field ???
        try{
            //Step: GetEnginaData WS execution
            CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
            CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
            jidi.ESN = esn; //mainContr.workJob.ESN__c;
            wrapobj.DataArea = jidi;
            engineData = CSS_WS_SBL.getEngineData(wrapobj);
            if(engineData == null){
                wsErrorMsg = 'Web Service failure. Please try again later.';
                css_utility.LogOutIntError('SBL get EngineData','SBL get EngineData', 'RESPONSE IS NULL', 'SBL');
                return;
            }

            //Step:Check validations here
            //if failure is added, don't call below GetCampaigns WS


            //Step: GetCampaigns WS execution
            //calling GetCampaigns SIEBEL service here
            System.debug('before calling callGetCampaignsWS...');
            String region = '';
            Date todayDate = system.today();
            String failureDate = DateTime.newInstance(todayDate.year(),todayDate.month(),todayDate.day()).format('dd-MMM-YY'); //????
            String wId = System.currentPagereference().getParameters().get('id');
            //List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getCampaigns(esn, engineData.DataArea.ServiceModelName, todayDate, 'en', wId);
            CG_OP_OAGWrapper resWrapper = CG_SL_Campaigns.callGetCampaignsWS(esn, failureDate, region, '', 'CSS','GetCampaign','UniqueID','CSSWarranty');
            if(resWrapper == null || resWrapper.response == null || resWrapper.response.getStatusCode() != 200 || resWrapper.response.getBody() == null){
                wsErrorMsg = 'Web Service failure. Please try again later.';
                css_utility.LogOutIntError('GetCampaignsWS','GetCampaignsWS', 'RESPONSE IS NULL', 'SBL');
                return;
            }
            CG_OP_CampaignsResJSON outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_CampaignsResJSON.class);
            system.debug('CG_OP_CampaignsResJSON outputRes>>>:'+outputRes+' resWrapper.response.getBody>>>:'+resWrapper.response.getBody());

            list<CSS_CampTsbTrp__c> lstSBLCAM;
            list<CSS_CampTsbTrp__c> lstSBLTRP;
            list<CSS_CampTsbTrp__c> lstSBLATC;

            if(outputRes.DataArea != null){
                lstSBLCAM = new list<CSS_CampTsbTrp__c>(); 
                lstSBLTRP = new list<CSS_CampTsbTrp__c>();
                lstSBLATC = new list<CSS_CampTsbTrp__c>();

                CSS_CampTsbTrp__c campaignComp;
                for(CG_OP_CampaignsResJSON.Details det : outputRes.DataArea.Details){
                    campaignComp = new CSS_CampTsbTrp__c();
                    if(det.CampaignType == 'Campaign'){
                        campaignComp.Name = 'CAM' ;
                        campaignComp.Type__c = 'CAM' ;
                        campaignComp.Job_Order__c = wId;
                        campaignComp.ESN__c = esn;
                        system.debug('det.CampaignNumber**'+det.CampaignNumber);
                        campaignComp.Doc_Num__c = det.CampaignNumber;
                        campaignComp.Doc_Title__c = det.CampaignDesc;
                        //campaignComp.URL__c = wCAMTSBTRB[i].url;
                        campaignComp.Cu_Language__c = qsolLanguage;
                        lstSBLCAM.add(campaignComp);
                    }else if(det.CampaignType == 'TRP'){
                        campaignComp.Name = 'TRP' ;
                        campaignComp.Type__c = 'TRP' ;
                        campaignComp.Job_Order__c = wId;
                        campaignComp.ESN__c = esn;
                        campaignComp.Doc_Num__c = det.CampaignNumber;
                        campaignComp.Doc_Title__c = det.CampaignDesc;
                        //campaignComp.URL__c = wCAMTSBTRB[i].url;
                        campaignComp.Cu_Language__c = qsolLanguage;
                        lstSBLTRP.add(campaignComp);
                    }else if(det.CampaignType == 'ATC'){
                        campaignComp.Name = 'ATC' ;
                        campaignComp.Type__c = 'ATC' ;
                        campaignComp.Job_Order__c = wId;
                        campaignComp.ESN__c = esn;
                        campaignComp.Doc_Num__c = det.CampaignNumber;
                        campaignComp.Doc_Title__c = det.CampaignDesc;
                        //campaignComp.URL__c = wCAMTSBTRB[i].url;
                        campaignComp.Cu_Language__c = qsolLanguage;
                        lstSBLATC.add(campaignComp);
                    }
                }
                System.debug('lstSBLCAM>>>:'+lstSBLCAM);
                System.debug('lstSBLTRP>>>:'+lstSBLTRP);
                System.debug('lstSBLATC>>>:'+lstSBLATC);
            }


            //Step: WarrantyDetailCoverage WS execution
            //Get Selected Campaign/ATC, pass as input
            //if no selected campaign/ATC, don't call WarrantyDetail WS???



        }catch(Exception ex){
            System.debug('in catch of psnTabOff of CG_BL_Claims>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally{

        }   
    }

    public static String validateGetCampaigns(String selectedPSN, Date failureDate, String region, String wId, String campaignType, String campaignNumber){
        System.debug('in validateGetCampaigns...');
        String errorMsg;
        try{
            //Step: GetCampaigns WS execution
            //calling GetCampaigns SIEBEL service here
            System.debug('before calling callGetCampaignsWS...');
            String failureDateStr = DateTime.newInstance(failureDate.year(),failureDate.month(),failureDate.day()).format('dd-MMM-YY');
            //String wId = System.currentPagereference().getParameters().get('id');
            //List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getCampaigns(esn, engineData.DataArea.ServiceModelName, todayDate, 'en', wId);
            CG_OP_OAGWrapper resWrapper = CG_SL_Campaigns.callGetCampaignsWS(selectedPSN, failureDateStr, region, '', 'CSS','GetCampaign','UniqueID','CSSWarranty');
            if(resWrapper == null || resWrapper.response == null || resWrapper.response.getStatusCode() != 200 || resWrapper.response.getBody() == null){
                //errorMsg = 'Web Service failure. Please try again later.';
                errorMsg = Label.CG_Web_Service_failure_Please_try_again_later;
                css_utility.LogOutIntError('GetCampaignsWS','GetCampaignsWS', 'RESPONSE IS NULL', 'SBL');
                return errorMsg;
            }
            CG_OP_CampaignsResJSON outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_CampaignsResJSON.class);
            system.debug('CG_OP_CampaignsResJSON outputRes>>>:'+outputRes+' resWrapper.response.getBody>>>:'+resWrapper.response.getBody());

            if(outputRes.DataArea != null){
                CSS_CampTsbTrp__c campaignComp;
                Boolean campaignMatch = false;
                for(CG_OP_CampaignsResJSON.Details det : outputRes.DataArea.Details){
                    if(det.CampaignType =='CAM')
                        det.CampaignType = 'Campaign';
                    if(det.CampaignType == campaignType && det.CampaignNumber == campaignNumber) //also check Type as Camapign or CAM
                        campaignMatch = true;
                }
                if(!campaignMatch)
                    errorMsg = Label.CG_PSN_does_not_have_coverage_available_for_selected_Failure_Campaign_ATC;
                //errorMsg = 'PSN does not have coverage available for selected Failure / Campaign / ATC.';
            }
            //else part added for Defect #168255,-By RAJESH 24th Oct 2018      
            else{
                errorMsg = Label.CG_PSN_does_not_have_coverage_available_for_selected_Failure_Campaign_ATC;
            }
            //else part end 
        }catch(Exception ex){
            System.debug('in catch of validateGetCampaigns of CG_BL_Claims>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally{

        }  
        return errorMsg;

    }

    public static void dealercloneAutomatedCampaigns(Id workJobId, string workJobpsND, Id claimRecIdDel, Id psnRecIdD, String claimAccType, Boolean paccarAuthReqdJob){
        system.debug('claimRecIdDel--'+claimRecIdDel);
        system.debug('in dealercloneAutomatedCampaigns of CG_BL_Claims...');
        List<Css_solution_Component__c> DealersolCompList;
        Integer repairsortOrder=0;
        set<id> duplicateDealersrtset = new set<id>();
        set<id> duplicateDealersrtsetNew = new set<id>();
        Boolean isAllAccCodeNull;
        Boolean isAnyAccCodeNull;
        try{
            
            CSS_Job_Order__c ServJob = new CSS_Job_Order__c();
            ServJob = [select id,FieldActionWebServiceResult__c, License_Plate__c, Automotive_App_Flag__c, Mileage__c, CSS_Hours__c from CSS_Job_Order__c where id= :workJobId];
            
            //Cloning DealersolComp Records
            for(CSS_JobEventTemporary__c jet : [SELECT Id, Key__c, Attribute1__c, Attribute2__c, Attribute3__c FROM CSS_JobEventTemporary__c WHERE Key__c =: 'AccountCodes']){
                String temp = jet.Attribute3__c;//jet.Attribute2__c + ' ' + jet.Attribute3__c;
                if(temp != null && temp != '' && temp.trim() != ''){
                    jobEventMap.put(temp,jet);
                }
            }
            system.debug('inside constructorr'+jobEventMap);
            //Added "Fault_Code__c" field in below query as per sIT story #150030, -By RAJEsH 25th June 2018
            //Added the field Root_Cause__c and the WHERE clauses "Root_Cause__c = true" and "CSS_Account_Formula__c != null and CSS_Account_Formula__c != ''" in below CSS_Solution_Component__c query as part of the story GSSC-458
            //Added the WHERE clause "(AccountCode_Formula__c != null and AccountCode_Formula__c != '' and AccountCode_Formula__c not in ('Select One'))" in below CSS_SRT__c query as part of the story GSSC-458
            DealersolCompList = new List<Css_solution_Component__c>([select Name, Root_Cause__c, CoverageLimitExceedMsg_Status__c, CoverageLimitExceedMsg__c, AccountCode__c,AccountCode_Call_Status__c,AccountCodeEdit__c,AccountCodeType__c,Action__c,Approval_Code__c,Selected_Claim_Type__c,Claim_Type__c,Fault_Code__c,
                                                                     Authorization_Number__c,Business_Unit__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,
                                                                     Campaign_Start_Date__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,CertificateNumber__c,Charlength__c,Complete_Indicator__c,Component_Code__c,Component_Id__c,
                                                                     CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredPartsQty_Percentage__c,CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c,
                                                                     CoveredTravelLabor__c,CoveredTravelMiles__c,CoverageLimitExceedMsgSRT_Status__c,CoverageLimitExceedMsgSRT__c,CSS_Account_Formula__c,CSS_CoverageType__c,Solutions__c,DeductibleAmount__c,Customer_Take_Possession__c,Engine_Family_Code__c,
                                                                     Equip_ID__c,Fail_Code__c,Fail_Code_Editable__c,FailCode_Formula__c,Failure_Date__c,Failure_Measure__c,Failure_Mode__c,Failure_Point__c,In_Shop_SRT_Limit_Flag__c,
                                                                     Multiple_Times__c,Notes__c,Parts_Warranty__c,RoadRelay_Warranty__c,Part_Warranty_Start_Date__c,Pay_Code__c,Performed__c,Performed_Review__c,Quantity__c,Reviewed__c,Selected_Component__c,
                                                                     Service_Model__c,FailMode_Desc__c,ComponentCode_Desc__c,SystemCode_Desc__c,SRT_Fetched__c,SRT_Total__c,Status__c,System_Code__c,Type__c,Unique_Component__c,URL__c,WarrantyId__c,Claims_Failure_Select__c,ODM_Status__c,ODM_Status_Message__c,
                                                                    Solutions__r.Symptom__r.Name, Solutions__r.FaultCode__r.Name,
                                                                     (select name,Flex_Flag__c,ECM_Flag__c,Component_Id__c,Claimed_Hours__c,Extended_Hours__c,AccountCode_Formula__c,Account_Code__c,Account_Code_Description__c,Fail_Code_Description__c,FailCode__c,SRT_ID__c,SRT_Order__c,id,Repair_Access_Calculated__c,SRT_Time__c,step_id__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Time__c,Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,Assignment__c,Solution_Number__c, SRT_Status_Message__c,SRT_Notes__c ,SRT_Warrantable__c,Job_Engine_Access_Code__c,SRT_Access_Code__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Access_Code_Saved__c,job_order__r.AccessCode__c,srt_category__c,ODM_Status__c,ODM_Status_Message__c,SRT_Select__c,isDuplicateRootCause__c
                                                                      from CSS_SRTs__r where SRT_ID__c != null and SRT_ID__c != '' and (AccountCode_Formula__c != null and AccountCode_Formula__c != '' and AccountCode_Formula__c not in ('Select One')) and
                                                                      (Solution_Number__c = null or (Solution_Number__c != null and (Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' or Solution_Number__r.Diagnostic_Response__c = 'Not the solution'))) and isDuplicateRootCause__c = false),
                                                                      (Select Id,selected_part__c, Item__c, Part_Description__c,Unit_Price__c,
                                                                      Quantity__c, amount__c, Covered__c, Fail_Code__c,Account_Code__c, Notes__c, Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,Return_Instructions__c, Shipping_Address__c,FailurepartId__r.Fail_Code__c,Replacement_Reason__c,
                                                                      //HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,ODM_Status__c,ODM_Status_Message__c, Part_Assignment__c, Parts_Type__c FROM CSS_Parts_Options__r WHERE FailurepartId__c != '') // Kalpana commented the line as failures without account code and parts are also getting created in claims FC
                                                                      HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,ODM_Status__c,ODM_Status_Message__c, Part_Assignment__c, Parts_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate__c, Currency_Type__c, Exchange_Rate_Version__c FROM CSS_Parts_Options__r WHERE FailurepartId__c != null AND FailurepartId__c != '' and Account_Code__c != null and Account_Code__c != '' and Account_Code__c != 'Select One')
                                                                     from CSS_Solution_Component__c where  Service_Job__c =:workJobId and (CSS_Account_Formula__c != null and CSS_Account_Formula__c != '') and ((Selected_Component__c= true and Root_Cause__c = true and Type__c not in ('Campaign','TRP','ATC') ) or (Type__c in ('Campaign','TRP','ATC')) )]); 
            Map<id, List<Css_parts_Options__c>> DealerpartOptionMap= new Map<id,List<Css_parts_Options__c>>();
            system.debug('DealersolCompList size>>:'+DealersolCompList.size()+' DealersolCompList>>>>:'+DealersolCompList);
            if(DealersolCompList !=null && DealersolCompList.size()>0){


                List<Css_solution_Component__c> DealersolCompList1 = new List<Css_solution_Component__c>();
                Map<id,Css_solution_Component__c> DealersolCompList2 = new Map<id,Css_solution_Component__c> ();
                Map<id,Css_parts_Options__c> DealerpartsOptionsMap = new Map<id,Css_parts_Options__c> ();
                List<Css_solution_Component__c> DealerlstNewDealersolComp = new List<Css_solution_Component__c>();
                List<Css_parts_Options__c> DealerlstNewpartOption = new List<Css_parts_Options__c>();
                List<Css_parts_Options__c> DealerlstNewpartOption1Del = new List<Css_parts_Options__c>();
                List<CSS_SRT__C> DealersrtCloneList = new List<CSS_SRT__C>();
                Map<id,List<CSS_SRT__C>> DealersrtCloneMap = new Map<id,List<CSS_SRT__C>>();
                onlyPWaccountCode = true;
                isAllAccCodeNull = true;
                isAnyAccCodeNull = false;
                for(Css_solution_Component__c DealersolComp : DealersolCompList){
                    if(claimAccType == 'Dealer Account' && paccarAuthReqdJob == true){
                        if(DealersolComp.CSS_Account_Formula__c != null && DealersolComp.CSS_Account_Formula__c != '' && DealersolComp.CSS_Account_Formula__c.trim() != ''){
                            if((DealersolComp.Type__c == null || DealersolComp.Type__c == '') || ((DealersolComp.Type__c != null && DealersolComp.Type__c != '') && (DealersolComp.Performed__c == true || DealersolComp.Performed_Review__c == true))){
                                CSS_JobEventTemporary__c tempJET = jobEventMap.get(DealersolComp.CSS_Account_Formula__c.RIGHT(2));
                                if(tempJET != null){
                                    String covType = tempJET.Attribute1__c;
                                    if(covType != null && covType != '' && (covType != 'NPW' && covType != 'RPW')){
                                        onlyPWaccountCode = false;
                                    }
                                }
                                isAllAccCodeNull = false;
                            }
                        }
                        else{
                            isAnyAccCodeNull = true;
                        }
                    }
                    else{
                        onlyPWaccountCode = false;
                        isAllAccCodeNull = false;
                    }
                    system.debug('onlyPWaccountCode-->'+onlyPWaccountCode);
                    system.debug('isAllAccCodeNull-->'+isAllAccCodeNull);
                    system.debug('isAnyAccCodeNull-->'+isAnyAccCodeNull);
                    //DealersolComp.Id = null;
                    DealersolComp.OldsolCompID__c = DealersolComp.Id;
                    //DealersolComp.service_Job__c = null;
                    DealersolComp.Css_Claims__c = claimRecIdDel;
                    system.debug('parts Records--'+DealersolComp.Css_parts_Options__r);
                    if(DealersolComp.Css_parts_Options__r!=null && DealersolComp.Css_parts_Options__r.size()>0){
                        DealerpartOptionMap.put(DealersolComp.id,DealersolComp.Css_parts_Options__r);    
                    }

                    if(DealersolComp.CSS_SRTs__r!=null && DealersolComp.CSS_SRTs__r.size()>0){
                        if((DealersolComp.Type__c == null || DealersolComp.Type__c == '') || (DealersolComp.Type__c != null && DealersolComp.Type__c != '' && DealersolComp.Performed_Review__c == true)){
                            DealersrtCloneMap.put(DealersolComp.id,DealersolComp.CSS_SRTs__r);
                            
                            for(CSS_SRT__c Dealersrt : DealersolComp.CSS_SRTs__r){
                                duplicateDealersrtset.add(Dealersrt.id);   
                            }
                            system.debug('Today Type null>> duplicateDealersrtset' + duplicateDealersrtset);
                        }
                        else if(DealersolComp.Type__c != null && DealersolComp.Type__c != '' && DealersolComp.Performed_Review__c == false){
                            for(CSS_SRT__c srt : DealersolComp.CSS_SRTs__r){
                                duplicateDealersrtsetNew.add(srt.id);   
                            }
                             system.debug('Today Type null>> duplicateDealersrtsetNew' + duplicateDealersrtsetNew);
                        }
                    }
                    
                    if(DealersolComp.Fault_Code__c != null && DealersolComp.Fault_Code__c != ''){
                        DealersolComp.Fault_Code__c = DealersolComp.Fault_Code__c;
                    }
                    else if(DealersolComp.Solutions__r.Symptom__r.Name != null && DealersolComp.Solutions__r.Symptom__r.Name != ''){
                        DealersolComp.Fault_Code__c = DealersolComp.Solutions__r.Symptom__r.Name;
                    }
                    else
                        DealersolComp.Fault_Code__c = DealersolComp.Solutions__r.FaultCode__r.Name;
                        
                    if(DealersolComp.Fault_Code__c != null && DealersolComp.Fault_Code__c != null){
                        List<CSS_JobEventTemporary__c> jobEvSCCC=[select  Attribute1__c,Attribute3__c
                                                                   from CSS_JobEventTemporary__c 
                                                                   where key__c='CDSFaultCodes' AND Attribute1__c =: DealersolComp.Fault_Code__c LIMIT 1];
                        if(jobEvSCCC != null && jobEvSCCC.size() > 0){
                            DealersolComp.Fault_Code__c = DealersolComp.Fault_Code__c + '-' + jobEvSCCC[0].Attribute3__c;
                        }
                    }
                    
                    system.debug('DealersrtCloneMap**'+DealersrtCloneMap);
                    DealersolComp.Id = null;

                    //where Type__c in ('Campaign','TRp','ATC')  and service_Job__c =:workJobId and performed_Review__c = true and status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))]);
                    if(DealersolComp.Type__c=='Campaign' || DealersolComp.Type__c=='TRp' || DealersolComp.Type__c=='ATC' ){
                        system.debug('before insert... ');
                        DealersolComp.selected_Component__c = false;
                        if(DealersolComp.performed_Review__c == true && DealersolComp.status__c=='Approved' && ((DealersolComp.Complete_Indicator__c==true && DealersolComp.Multiple_Times__c==true) || (DealersolComp.Complete_Indicator__c==false || DealersolComp.Multiple_Times__c==true) || (DealersolComp.Complete_Indicator__c==false && DealersolComp.Multiple_Times__c==false)) ){
                            system.debug('DealersolComp.performed_Review__c>>:'+DealersolComp.performed_Review__c+' DealersolComp.status__c>>>>:'+DealersolComp.status__c+' DealersolComp.Complete_Indicator__c>>>>:'+DealersolComp.Complete_Indicator__c+' DealersolComp.Multiple_Times__c>>>>:'+DealersolComp.Multiple_Times__c);
                            DealersolComp.selected_Component__c = true;
                        }
                    }//else */ //Uncommented above piece of logic and commented below piece as requested by Karthik Kameshwaran(defect #180330)
                    /*DealersolComp.selected_Component__c = true;
                    DealersolComp.status__c='Approved';
                    DealersolComp.Complete_Indicator__c=true;
                    DealersolComp.Multiple_Times__c=true;*/

                    DealersolComp.Claims_Failure_select__c = true;
                    //DealersolCompListTemp.add(DealersolComp);
                    system.debug('DealersolCompMap--'+DealersolComp.id +' '+ DealersolComp);

                    
                    DealerlstNewDealersolComp.add(DealersolComp);
                }

                system.debug('DealerlstNewDealersolComp--'+DealerlstNewDealersolComp);
                //sN - clone the part options related to the solution component
                List<Css_parts_Options__c> partOptionsToInsertD1 = new List<Css_parts_Options__c>();
                if(DealerlstNewDealersolComp !=null && DealerlstNewDealersolComp.size()>0){
                    system.debug('DealerlstNewDealersolComp--'+DealerlstNewDealersolComp);
                    insert DealerlstNewDealersolComp;

                    for(Css_solution_Component__c DealersolCompN : DealerlstNewDealersolComp) {
                        //system.debug('inserted DealersolComp Id>>:'+DealersolComp.Id+' DealersolComp Name>>>>:'+DealersolComp.Id)
                        system.debug('DealersolCompN.OldSolCompID__c--'+DealersolCompN.OldSolCompID__c);
                        //sN - fetch the parts based on old CompId and create the new partOptions with new CompId
                        if(DealerpartOptionMap.containsKey((DealersolCompN.OldSolCompID__c).Trim())){
                            //system.debug('DealersolCompListTempMap--'+DealersolCompListTempMap);
                            system.debug('DealerpartOptionMap--'+DealerpartOptionMap.get(DealersolCompN.OldSolCompID__c));
                            for(Css_parts_Options__c partOption :  DealerpartOptionMap.get(DealersolCompN.OldSolCompID__c)){
                                if(DealersolCompN.Selected_Component__c == false){
                                   continue;
                               }
                                partOption.FailurepartId__c = DealersolCompN.id;
                                partOption.id=null;

                                //  partOption.selected_part__c = true;
                                partOption.service_Job__c = null; //added newly
                                partOption.Css_Claims__c = DealersolCompN.Css_Claims__c;
                                partOptionsToInsertD1.add(partOption);

                            }       
                        }

                        if(DealersrtCloneMap.containsKey((DealersolCompN.OldSolCompID__c).Trim())){

                            for(CSS_SRT__C Dealersrt :  DealersrtCloneMap.get(DealersolCompN.OldSolCompID__c)){
                                system.debug('New Comp ID--'+DealersolCompN.id);
                                repairsortOrder = repairsortOrder + 1;
                                Dealersrt.Component_Id__c = DealersolCompN.id;
                                Dealersrt.id=null;
                                
                                // Dealersrt.isPerformed__c = true;
                                Dealersrt.Job_Order__c = null; //added newly
                                Dealersrt.SRT_Order__c = repairsortOrder;
                                Dealersrt.Css_Claims__c = DealersolCompN.Css_Claims__c;
                                Dealersrt.Claimed_Hours__c = Dealersrt.Extended_Hours__c;
                                Dealersrt.SRT_From_Job__c = true;
                                DealersrtCloneList.add(Dealersrt);
                                // system.debug('DealersolCompN.OldDealersolCompID__c**'+DealersolCompN.OldDealersolCompID__c);
                            }       
                        }
                        system.debug('DealersrtCloneList>>>>>>'+DealersrtCloneList.size());
                        system.debug('DealersrtCloneList>>>>>>'+DealersrtCloneList);


                    }

                }

                //insert cloned Dealersrt records of solution component
                system.debug('DealersrtCloneList size>>:'+DealersrtCloneList.size());
                if(DealersrtCloneList.size()>0){
                    insert DealersrtCloneList;
                    system.debug('after DealersrtCloneList size>>:'+DealersrtCloneList.size());
                }
                system.debug('partOptionsToInsertD1--'+partOptionsToInsertD1);
                //insert cloned part options
                if(partOptionsToInsertD1.size()>0){
                    insert partOptionsToInsertD1;   
                }  


            }
            List<Css_parts_Options__c> lstNewpartOption2D = new List<Css_parts_Options__c>();
            List<Css_parts_Options__c> lstNewpartOption3D = new List<Css_parts_Options__c>();
            /*  recordtype rdpD = [select Id, Name from recordtype where Name = :'parts'];
            lstNewpartOption2D = [select Id,selected_part__c, Item__c, part_Description__c,Css_Claims__c,ExpenseTotal__c,
                                 Quantity__c, amount__c, Covered__c, Fail_Code__c,Account_Code__c, Notes__c,
                                 service_partnumber__c,OEM__c,part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,
                                 Replacement_Reason__c, HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,parts_Type__c,ODM_status__c,ODM_status_Message__c,
                                 part_Assignment__c, Unit_price__c,price_Book__c FROM Css_parts_Options__c where service_job__c = :workJobId and recordtypeId =: rdpD.Id  and parts_Type__c != 'Custom']; 

            if(lstNewpartOption2D !=null){
                for(Css_parts_Options__c partOption1Del :  lstNewpartOption2D){
                    system.debug('partOption1Del----->'+partOption1Del);
                    partOption1Del.id=null;
                    partOption1Del.service_job__c = null;
                    partOption1Del.Css_Claims__c = claimRecIdDel;
                    lstNewpartOption3D.add(partOption1Del);

                }       
            }

            if(lstNewpartOption3D.size()>0){
                insert lstNewpartOption3D;
            }  */



            //Cloning Css_campTsbTrpDel Records
            List<CSS_CampTsbTrp__c> CTAListDel = [select Type__c,URL__c,  Doc_Num__c, Doc_Title__c, performed__c,performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__c= :workJobId AND EsN__c = :workJobpsND  AND Type__c !='TsB'
                                                  order by performed_Review__c desc LIMIT 1000];
            system.debug('CTAListDel size>>:'+CTAListDel.size()+' CTAListDel>>>>:'+CTAListDel);
            if(CTAListDel !=null && CTAListDel.size()>0){

                List<CSS_CampTsbTrp__c> CTAListDelTempDel = new List<CSS_CampTsbTrp__c>();
                for(CSS_CampTsbTrp__c campTsbTrpDel : CTAListDel) {
                    campTsbTrpDel.Id = null;
                    campTsbTrpDel.Job_Order__c = null;
                    campTsbTrpDel.Css_Claims__c = claimRecIdDel;
                    CTAListDelTempDel.add(campTsbTrpDel);
                }
                if(CTAListDelTempDel !=null && CTAListDelTempDel.size()>0){
                    insert CTAListDelTempDel;
                    system.debug('inserted CTAListDelTempDel size>>:'+CTAListDelTempDel.size()+' CTAListDelTempDel>>>>:'+CTAListDelTempDel);
                    for(CSS_CampTsbTrp__c campTsbTrpDel : CTAListDelTempDel) {
                        system.debug('inserted campTsbTrpDel Id>>:'+campTsbTrpDel.Id+' campTsbTrpDel Type__c>>>>:'+campTsbTrpDel.Type__c);
                    }
                }

            }

            //As Guidanz pO on an Automated Claim only copy part, TTML OC over to the Claim if there is an account code present
            List<Css_parts_Options__c> partOptionToInsertDel = new List<Css_parts_Options__c>();
            List<Css_parts_Options__c> partOptionToInsertDel1 = new List<Css_parts_Options__c>();
            partOptionToInsertDel = [
                select Id, FailurepartId__r.CoveredOCAmount__c, selected_part__c, Item__c, part_Description__c,Replacement_Reason__c,
                Quantity__c, amount__c, Covered__c, Fail_Code__c,Account_Code__c, Notes__c, ExpenseTotal__c,siebel_Value__c,
                HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Quantity_Used__c,part_Name__c,Item_BMs__c,Type_BMs__c,Unit_price__c,parts_Type__c,
                sell_price__c,service_partnumber__c,ReturnToFactory__c,Return_Instructions__c, Shipping_Address__c,parts_Return__c,Comments__c,ODM_status__c,ODM_status_Message__c,Warranty_Allocation__c, RecordType.Name,
                Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate__c, Currency_Type__c, Exchange_Rate_Version__c
                from Css_parts_Options__c where  service_Job__c=:workJobId and FailurepartId__c = ''];
            system.debug('partOptionToInsertDel--'+partOptionToInsertDel);
            for(Css_parts_Options__c pD: partOptionToInsertDel ){
                pD.id = null;
                pD.service_Job__c = null;

                pD.selected_part__c = true;
                //commented the ExpenseTotal__c field as per the Defect #154107//
                // pD.ExpenseTotal__c = null;
                // Commented the below line for getting Quantity from job to claim as per "I survived" sprint story #152963,-By RAJEsH 27rd July 2018        

                //pD.Unit_price__c = string.valueof(pD.sell_price__c);
                //End  
                if(pD.recordtype.Name =='OtherClaimables'){
                    pD.Unit_price__c = string.valueof(pD.sell_price__c);
                    pD.ExpenseTotal__c = pD.Amount__c;
                }
                pD.sell_price__c = null;
                pD.Css_Claims__c = claimRecIdDel;
                pD.Item_BMs__c = pD.Item__c;
                if(pD.siebel_Value__c != null && pD.siebel_Value__c != '' && pD.siebel_Value__c.contains('Unlisted')){
                    pD.Item__c = 'Unlisted';
                }

                pD.Type_BMs__c = pD.Type__c;

                if(pD.Type__c != null && pD.Type__c != ''){
                    if(pD.Type__c.contains('LODGE- FsE'))
                        pD.Type__c = 'Lodging';
                    else if(pD.Type__c.contains('MEAL- FsE'))
                        pD.Type__c = 'Meals';
                    else if(pD.Type__c.contains('MEAL- FspG'))
                        pD.Type__c = 'Meals';
                    // Removed the space from "Non Commercial-Travel" as per "I survived" sprint story #152963,-By RAJEsH 27th July 2018                             
                    else if(pD.Type__c.contains('MILE WARR FsE')){
                        pD.Type__c = 'Non Commercial-Travel';
                        // passing quantity to Mileage when type is "Non Commercial-Travel" as per "I survived" sprint story #152963,-By RAJEsH 27th July 2018                        
                        pD.Mileage__c=pD.Quantity__c;
                        pD.ExpenseTotal__c=pD.ExpenseTotal__c;
                        system.debug('****pD.Mileage__c'+pD.Mileage__c);
                    }
                    // Removed the space from "Commercial-Travel" as per "I survived" sprint story #152963,-By RAJEsH 27th July 2018                  
                    else if(pD.Type__c.contains('MILE WARR FspG')){
                        pD.Type__c = 'Non Commercial-Travel';
                        pD.Mileage__c=pD.Quantity__c;
                        pD.ExpenseTotal__c=pD.ExpenseTotal__c;                        
                        system.debug('****pD.Mileage__c'+pD.Mileage__c);
                    }
                    else if(pD.Type__c.contains('pARKING-FsE'))
                        pD.Type__c = 'Commercial-Travel';
                    else if(pD.Type__c.contains('pARKING-FspG'))
                        pD.Type__c = 'Commercial-Travel';
                    else if(pD.Type__c.contains('TOLLs-FsE'))
                        pD.Type__c = 'Commercial-Travel';
                    else if(pD.Type__c.contains('TOLLs-FspG'))
                        pD.Type__c = 'Commercial-Travel';
                    else
                        pD.Type__c =  pD.Type__c;
                }
                
                if(pD.Parts_Type__c != 'Custom'){
                    partOptionToInsertDel1.add(pD);
                }
                else{
                    if(pD.Account_Code__c != null && pD.Account_Code__c != '' && pD.Account_Code__c != 'Select One'){
                        partOptionToInsertDel1.add(pD);
                    }
                }
            }

            system.debug('partOptionToInsertDel1--'+partOptionToInsertDel1);

            if(partOptionToInsertDel1.size()>0){

                insert partOptionToInsertDel1;
            } 
            //Clone method for Claims Dealersrt object
            List<CSS_SRT__C> Dealersrt1 = new List<CSS_SRT__C>();
            List<CSS_SRT__C> Dealersrt2 = new List<CSS_SRT__C>();
            duplicateDealersrtset.addAll(duplicateDealersrtsetNew);
            system.debug('duplicateDealersrtset>>' + duplicateDealersrtset);
            //Added condition like Type__c !='private' in query as per simpsons story #145402, By -RAJEsH           
            Dealersrt1 = [select Id,Name,Flex_Flag__c,ECM_Flag__c,Overlap_Hours__c,Account_Code__c,Extended_Hours__c,FailCode__c,SRT_Order__c,Component_Id__c,Override__c,OverrideReason__c,Override_Reason__c,Overlap_Step_Id__c,Adjusted_Overlap_Hours__c,Overlap_SRT_Number__c,SRT_ID__c,Account_Code_Description__c,Fail_Code_Description__c,
                          Repair_Access_Calculated__c,SRT_Time__c,Assignment__c, Solution_Number__c, step_id__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Time__c,
                          Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,SRT_Access_Code__c,
                          SRT_Status_Message__c,SRT_Notes__c ,SRT_Warrantable__c,Job_Engine_Access_Code__c,AccountCode_Formula__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,
                          Access_Code_Saved__c,job_order__r.AccessCode__c,srt_category__c,ODM_Status__c,ODM_Status_Message__c,SRT_Select__c,Component_Id__r.Root_Cause__c,isDuplicateRootCause__c
                          from CSS_SRT__C where Job_Order__c=:workJobId AND ID NOT IN:duplicateDealersrtset AND Type__c !='Private' and SRT_ID__c != null and SRT_ID__c != '' and 
                          (Solution_Number__c = null or (Solution_Number__c != null and (Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' or Solution_Number__r.Diagnostic_Response__c = 'Not the solution'))) and isDuplicateRootCause__c =: false];
                          //and Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution'];
            system.debug('DealersrtObject'+Dealersrt1.size());
            system.debug('JobDealersrts***'+Dealersrt1);
            Integer DiagnosissortOrder=0;
            for(CSS_SRT__C sD:Dealersrt1){
                
                // Anvesh added below if cond as part of defect GSSC- 599
               if((sD.Type__c == 'Repair' || sD.SRT_Category__c == 'AdditionalRep') && (sD.Component_Id__c == null)){	// && s.Component_Id__r.Root_Cause__c != true
                    if(sD.AccountCode_Formula__c != null && sD.AccountCode_Formula__c != '' && sD.AccountCode_Formula__c != 'Select One'){
                       sD.id=null;
                        sD.Job_Order__c = null;
                        sD.CSS_Claims__c = claimRecIdDel;
                        Dealersrt2.add(sD);
                    }
                    //system.debug('inside root cause false value ' + s.Component_Id__r.Root_Cause__c);
                    //continue;
                }
                
              else  if(sD.Type__c == 'Repair'  && sD.Component_Id__r.Root_Cause__c != true){
                    continue;
                }
                else{
                    if((claimAccType.contains('Distributor') && sD.SRT_Type__c != 'Admin') || (claimAccType.contains('Distributor') && sD.SRT_Type__c == 'Admin' && sD.isPerformed__c == true) || !claimAccType.contains('Distributor')){
                        sD.id=null;
                        sD.Job_Order__c = null;
                        sD.Css_Claims__c = claimRecIdDel;
                        //sD.isPerformed__c = true;
                        if((sD.SRT_Category__c != null && sD.SRT_Category__c == 'AdditionalRep') || (sD.Type__c!= null && sD.Type__c == 'Repair Access') || (sD.solution_Number__c!= null && sD.Type__c == 'Repair')){
                            repairsortOrder = repairsortOrder + 1;
                            sD.SRT_Order__c = repairsortOrder;
        
                        }
        
                        if((sD.solution_Number__c != null && sD.Type__c == 'Diagnosis')|| (sD.Type__c!= null && sD.Type__c == 'Diag Access') || (sD.SRT_Category__c != null && sD.SRT_Category__c == 'AdditionalDiag')){
                            DiagnosissortOrder = DiagnosissortOrder + 1;
                            sD.SRT_Order__c = DiagnosissortOrder;
                        }
                        sD.SRT_From_Job__c = true;
                        //Dealersrt2.add(sD);  //Commented as part of the story GSSC-459
                    }
                        //GSSC-459 - START
                   if(!claimAccType.contains('Distributor')){
                        if((sD.Type__c == 'Repair Access' && sD.SRT_Type__c == 'Access') || (sD.SRT_Category__c == 'AdditionalRep')){
                            if(sD.AccountCode_Formula__c != null && sD.AccountCode_Formula__c != '' && sD.AccountCode_Formula__c != 'Select One'){
                                Dealersrt2.add(sD);
                            }
                            else{
                                repairsortOrder = repairsortOrder - 1;
                            }
                        }
                        else{
                            Dealersrt2.add(sD);
                        }
                    }
                    else{
                        Dealersrt2.add(sD);
                    }
                    //GSSC-459 - END
               }

            }
            system.debug('Dealersrt2 size>>:'+Dealersrt2.size());
            system.debug('ClaimDealersrts***'+Dealersrt2);
            if(Dealersrt2.size()>0){
                insert Dealersrt2;
                system.debug('after Dealersrt2 size>>:'+Dealersrt2.size());
            }

            //cloning attachments for Dealer authomatic claims 
            List<Attachment>att1 = new List<Attachment>();
            List<Attachment>att2 = new List<Attachment>();
          //  att1 = [Select Id,Body,Name,Description,parentid, LastModifiedDate from attachment where parentid= :workJobId];
           // system.debug('Attachments'+att1);
            Attachment ab;
            for(Attachment a:[Select Id,Body,Name,Description,parentid, LastModifiedDate from attachment where parentid= :workJobId]){
                //a.id = null;
                // a.parentid = null;
                ab = new Attachment();
                ab.body = a.body;
                ab.name = a.name;
                ab.description = a.description;

                ab.parentid = claimRecIdDel;
                att2.add(ab); 


            }
            if(att2.size()>0){
                insert att2;
                system.debug('claimatt'+att2);

            }
            
            CSS_Claims__c claimInsert = new CSS_Claims__c();
            system.debug('onlyPWaccountCode-->'+onlyPWaccountCode);
            system.debug('claimAccType-->'+claimAccType);
            system.debug('paccarAuthReqdJob-->'+paccarAuthReqdJob);
            if(DealersolCompList != null && DealersolCompList.size() > 0){
                if(isAllAccCodeNull == true){
                    claimInsert.Id = claimRecIdDel;
                    claimInsert.No_Failure_PACCAR_Flag__c = true;
                }
                else if(onlyPWaccountCode == true && claimAccType == 'Dealer Account' && paccarAuthReqdJob == true){
                    if(isAnyAccCodeNull == false){
                        claimInsert.Id = claimRecIdDel;
                        claimInsert.Parts_Warranty_Claim_Only__c = true;
                        claimInsert.PACCAR_PW_AutoSelected__c = true;
                    }
                    else{
                        claimInsert.Id = claimRecIdDel;
                        claimInsert.No_Failure_PACCAR_Flag__c = true;
                    }
                }
                else if(onlyPWaccountCode == false && claimAccType == 'Dealer Account' && paccarAuthReqdJob == true){
                    claimInsert.Id = claimRecIdDel;
                    claimInsert.PACCAR_Auth_Required__c = true;
                    claimInsert.PACCAR_Flag__c = true;
                    claimInsert.PACCAR_Mixed_Accountcodes__c = true;  //Added as part of the defect #GSSC-225
                }
            }
            else{
                if(paccarAuthReqdJob == true){
                    claimInsert.Id = claimRecIdDel;
                    claimInsert.No_Failure_PACCAR_Flag__c = true;
                }
            }
            
            if(ServJob!=null && ServJob.FieldActionWebServiceResult__c == 'Error'){
               claimInsert.Id = claimRecIdDel;
                claimInsert.FieldActionWebServiceResult__c = 'Error';
                }
            
            CSS_Claims__c emptyClaim = new CSS_Claims__c();
            system.debug('claimInsert--->'+claimInsert);
            if(claimInsert != emptyClaim){
                update claimInsert;
            }

        }catch(exception e){
            system.debug('EXCEpTION of CG_BL_Claims - cloneAutomatedCampaigns Method ErrorMessage>>>:'+e.getMessage() + ' LineNumber>>:' + e.getLineNumber() + ' Rootcause>>:' +e.getCause());
        }
    }

    public static void DuplicateSRT(Id claimRecId,List<id> failurelst){

        List<CSS_Solution_Component__c> solCompList;
        try{
            solCompList = new List<CSS_Solution_Component__c>([Select id, (select name,Component_Id__c,Extended_Hours__c,solution_number__r.Diagnostic_Response__c,AccountCode_Formula__c,Account_Code__c,FailCode__c,SRT_ID__c,SRT_Order__c,id,Repair_Access_Calculated__c,SRT_Time__c,step_id__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Time__c,Diag_Access_Time__c,SRT_AccessiblityCheck__c,Type__c,SRT_Type__c,SRT_Quantity__c,isPerformed__c,SRT_Title__c,Assignment__c,Solution_Number__c, SRT_Status_Message__c,SRT_Notes__c ,SRT_Warrantable__c,Job_Engine_Access_Code__c,Access_Code__c,SRT_Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Access_Code_Saved__c,job_order__r.AccessCode__c,srt_category__c,ODM_Status__c,ODM_Status_Message__c,SRT_Select__c
                                                                           from CSS_SRTs__r  ) from CSS_Solution_Component__c where id in:failurelst and CSS_Claims__c =:claimRecId]);

            Map<id,List<CSS_SRT__C>> srtCloneMap = new Map<id,List<CSS_SRT__C>>();
            Map<id,List<CSS_SRT__C>> DuplicatesrtMap = new Map<id,List<CSS_SRT__C>>();
            List<CSS_SRT__C> srtList = new List<CSS_SRT__C>();
            List<CSS_SRT__C>  DuplicatesrtList = new List<CSS_SRT__C>();
            if(solCompList !=null && solCompList.size()>0){
                for(CSS_Solution_Component__c solComp : solCompList) {
                    if(solComp.CSS_SRTs__r!=null && solComp.CSS_SRTs__r.size()>0){
                        srtCloneMap.put(solComp.id,solComp.CSS_SRTs__r);
                    }
                }
                for(CSS_Solution_Component__c solCompN : solCompList) {

                    if(srtCloneMap.containsKey(solCompN.Id)){


                        Boolean isALTERNATIVE=false;
                        Boolean isPROGRESSIVE=false;
                        Boolean AccessCodeAsR=false;
                        for(CSS_SRT__c srt :  srtCloneMap.get(solCompN.Id)){
                            if(srt.solution_number__r.Diagnostic_Response__c!=null && srt.solution_number__r.Diagnostic_Response__c == 'Most likely the solution'){
                                system.debug('DuplicatesrtMap---->'+DuplicatesrtMap);
                                
                                if(DuplicatesrtMap.containsKey(srt.SRT_ID__c)){
                                    List<CSS_SRT__c> slist = DuplicatesrtMap.get(srt.SRT_ID__c);
                                    slist.add(srt);
                                    DuplicatesrtMap.put(srt.SRT_ID__c,slist);

                                } 
                                else{
                                    DuplicatesrtMap.put(srt.SRT_ID__c,new List<CSS_SRT__c>{srt}); 
                                }

                            }
                        }

                        for(CSS_SRT__c srt :  srtCloneMap.get(solCompN.Id)){
                            if(DuplicatesrtMap.get(srt.SRT_ID__c).size()==1){
                                srtList.add(srt);
                            }
                            else  if(DuplicatesrtMap.get(srt.SRT_ID__c).size()>1){
                                DuplicatesrtList.add(srt);
                            }

                        }
                        for(CSS_SRT__c srt :  DuplicatesrtList){
                            Boolean isPrimary=false;

                            if(srt.Assignment__c=='PRIMARY'){
                                isPrimary=true;
                                if(AccessCodeAsR==true && (srt.Access_Code__c=='A' || srt.Access_Code__c=='B' || srt.Access_Code__c=='C' || srt.Access_Code__c=='D')){
                                    srtList.add(srt);
                                }
                                else if(AccessCodeAsR==false && srt.Access_Code__c=='R'){
                                    srtList.add(srt);
                                }
                                else{
                                    srtList.add(srt);

                                }
                                break;
                            }
                            else if(srt.Assignment__c=='ALTERNATIVE' &&  isPrimary==false && isALTERNATIVE==true){
                                srtList.add(srt);
                            }
                            else if(srt.Assignment__c=='PROGRESSIVE DAMAGE' &&  isPrimary==false && isALTERNATIVE==false && isPROGRESSIVE==true){
                                srtList.add(srt);
                            }


                        }
                    }
                }
            }
        }
        catch(exception e){
            system.debug('EXCEpTION of CG_BL_Claims - DuplicateSRT>>>:'+e.getMessage() + ' LineNumber>>:' + e.getLineNumber() + ' Rootcause>>:' +e.getCause());
        }
    }
    
    //Fetch Active locations for job & claim as per story GSSC-621
    public static list<CSS_UserLocation__c> fetchActiveLocations() {
        Id usrId = UserInfo.getUserId();
        system.debug('usrId>>>'+usrId);

        list<CSS_UserLocation__c> userLocationList = new List<CSS_UserLocation__c>();
        try {
                userLocationList = [SELECT AccountId__c,isActive__c,isPrimary__c,Location_Name__c,BMSApplicationURL__c, Location_Source__c,
                                    UserId__c,BMS_Enabled__c,Location_code__c,AccountId__r.Type
                                    FROM CSS_UserLocation__c
                                    WHERE UserId__c = : usrId AND isActive__c = true
                                    ORDER BY Location_Name__c asc];
                system.debug('userLocationList'+userLocationList);
                system.debug('ELSE LOOP');
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_BL_Intake fetchMultiLocation method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        system.debug('userLocationList--'+userLocationList);
        return userLocationList;
    }
}