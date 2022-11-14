/*
* Block comments with details of changes
*/
public class CG_CL_ClaimsViewPaymentDetails
{
    public Id cSId{get;set;}
    public String cStatus {get;set;}
    public CSS_Claims__c claimsRec {set;get;}
    public CSS_Claim_Submission__c claimSubRec {set;get;}
    public String LocationCode {get;set;}
    public String CreditDateValue {get;set;}
    public String WarrantyStartDate {get;set;}
    public String FailureDate {get;set;}    
    public String DistributorName {get;set;} //Story 166124
    public String DistributorCode {get;set;} //Story 166124
    public string DeniedRReason {get;set;} //GSSC-258 By Krishna
    public String Service_Model {get;set;} //Added by Krishna @ GSSC:#65
    public String Application {get;set;} //Added by Krishna @ GSSC:#65

    public List<claimDetailSRTswrapper> lstclaimDetailSRTswrapper {set;get;}
    public List<claimDetailOtherClaimableswrapper> lstclaimDetailOtherClaimableswrapper {set;get;}
    public List<claimDetailPartswrapper> lstclaimDetailPartswrapper {set;get;}
    public List<claimDetailTravelwrapper> lstclaimDetailTravelwrapper {set;get;}
    public List<ClaimsubmissionNotes> lstClaimsubmissionNotes {set;get;}
    public List<claimDetailExternalNotesWrapper>lstclaimDetailExternalNotesWrapper {set;get;}
    public List<claimDetailExternalNotesWrapper>siebel3cExternalNotesWrapper {set;get;}
    public List<css_solution_component__c> solComRec{get;set;}
    Transient public list<CSS_Parts_Options__c> claimsPOList = new list<CSS_Parts_Options__c>();
    Transient public list<CSS_SRT__c> claimsSRTList = new list<CSS_SRT__c>();
    public Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap = new Map<string, list<CSS_Parts_Options__c>>();
    public Map<string, list<CSS_Parts_Options__c>> OCAccountCodeMap = new Map<string, list<CSS_Parts_Options__c>>();
    public Map<string, list<CSS_Parts_Options__c>> TTMLAccountCodeMap = new Map<string, list<CSS_Parts_Options__c>>();
    public Map<string, list<CSS_SRT__c>> SRTAccountCodeMap = new Map<string, list<CSS_SRT__c>>();
    public Boolean isDealer {get;set;}
    public string currDate  {get;set;}
    public double claimed_Total_Hours{get;set;}
    public double Adjusted_Total_Hours{get;set;}
    public Integer Claimed_Total_Mileage{get;set;}
    public Integer  Adjusted_Total_Mileage{get;set;}
    public double Claimed_ttTotal_Hours{get;set;}
    public double Adjusted_ttTotal_Hours{get;set;}
    public Decimal claimed_Lodging_Meals{get;set;}
    public Decimal Adjusted_Lodging_Meals{get;set;}
    public Boolean enableMultiPSNsection {get;set;}
    public List<MultiPSNWrapper> lstofAdditionalESNs {get; set;}
    public Boolean DealerTypeFlag {get;set;}
    public List<CSS_Claims__c> claimsRecMPSN {set;get;}
    public User usr{get;set;}
    public Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>();//GSSC-138
    public List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();//GSSC-138
    public Map<Decimal, Decimal> versionExchangeRateMap = new Map<Decimal, Decimal>();//GSSC-138
    public Decimal partExchangeRate{get;set;}
    public Boolean isFailAccountCode{get;set;}
    public String MileageValue{get;set;}
    public String productHoursValue{get;set;}
    public CG_CL_ClaimsViewPaymentDetails()
    {
        try {
            usr = [select id,name,DefaultCurrencyIsoCode from user where id=:userinfo.getUserId() Limit 1];
            system.debug('**usr**'+usr);
            system.debug('**userinfo.getDefaultCurrency()**'+userinfo.getDefaultCurrency());
            //GSSC-138-start    
            if(userinfo.getDefaultCurrency() != 'USD'){
                lstCurrencyDetails = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c where Bolt_To_Currency__c =: userinfo.getDefaultCurrency()];
            }
            if(lstCurrencyDetails != null && lstCurrencyDetails.size() > 0){
                for(Currency_Conversion__c cc : lstCurrencyDetails){
                    if(!versionExchangeRateMap.containsKey(cc.Bolt_Version__c)){
                        versionExchangeRateMap.put(cc.Bolt_Version__c, cc.Bolt_Conversion_Rate__c);
                    }
                }
            }
            isFailAccountCode = false;
            //GSSC-138-end
            list<CSS_Claims__c> recClaims = new list<CSS_Claims__c>();
            cSId=ApexPages.CurrentPage().getParameters().get('id');
            cStatus = ApexPages.CurrentPage().getParameters().get('Status');
            system.debug('cSId' + ' ' + cSId);
            system.debug('cStatus' + ' ' + cStatus);
            system.debug('MyClaimSubmissionRecordId**'+cSId);
            string userType = css_Utility.getOrgType(userinfo.getUserId());
            DeniedRReason = '';	//GSSC-258 By Krishna
            claimed_Total_Hours=0.0;
            Adjusted_Total_Hours=0.0;
            Claimed_Total_Mileage=0;
            Adjusted_Total_Mileage=0;
            Claimed_ttTotal_Hours=0.0;
            Adjusted_ttTotal_Hours=0.0;
            claimed_Lodging_Meals=0.00;
            Adjusted_Lodging_Meals=0.00;
            //chooserender=null;
            if(userType!=null && userType!= '') {
                if(userType == 'DLR') {
                    isDealer = true;
                }else if(userType == 'DISTR') {
                    isDealer = false;
                }
            }
            datetime currentDate = System.now();
            currDate=currentDate.format('dd MMM YYYY hh:mm a z');
            if(cSId == null) {
                claimsRec = new CSS_Claims__c();  
                claimSubRec = new CSS_Claim_Submission__c(); 
            } 

            if(cSId!=null && cStatus!='Draft'){
                fetchClaimSubmissionRecords();

                if(claimsRec.SiebelClaimNumber__c == null || claimsRec.SiebelClaimNumber__c == ''){
                    Callgetpaidclaimdetails();//Guidanz Claims
                }

                if(claimsRec.SiebelClaimNumber__c != null && claimsRec.SiebelClaimNumber__c != ''){
                    CallGetClaimDetails();//Siebel Claims
                }
            }   

            if(cSId!=null && cStatus =='Draft'){
                system.debug('callinf cstatus Draft fetchClaimSubmissionRecords');
                fetchClaimSubmissionRecords();
            }

            //Added code below as per story #162525 [Only UI ]from Polar Express,-By RAJESH 17th Dec 2018
            system.debug('claimsRec.Multi_PSN_Claim__c*****'+claimsRec.Multi_PSN_Claim__c);
            if(claimsRec.Multi_PSN_Claim__c==true){         
                recClaims =  [Select id,Customer_Name__c,Account__r.Type,CSS_Job__c,Location__c,Status__c,SiebelClaimNumber__c,CSS_Job__r.Name,Shop_Work_Order__c,JobEditCause__c,
                              (Select Id,Name,PSN__c,Warranty_Start_Date__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c, CSS_Claims__c,Failure_Point__c,
                               Mileage_Measure__c,Revision_Before__c,Revision_After__c,Primary__c from CSS_PSNs__r ORDER BY Primary__c DESC) from CSS_Claims__c where id=:claimSubRec.CSS_Claims__c ];//AND SiebelClaimNumber__c=null
                if( recClaims[0].CSS_PSNs__r != null && recClaims[0].CSS_PSNs__r.size()>1){
                    enableMultiPSNsection=true;
                }
                else{
                    enableMultiPSNsection=false; 
                }

                // Added below code as per story #162526 from Polar Express,-By RAJESH 19th Dec 2018
                system.debug('Before for loop recClaims>>>>>>>' + recClaims);
                system.debug('Before for loop recClaims[0].CSS_PSNs__r>>>>>>>' + recClaims[0].CSS_PSNs__r);
                system.debug('Before for loop lstofAdditionalESNs>>>>>>>' + lstofAdditionalESNs);
                lstofAdditionalESNs = new List<MultiPSNWrapper>();
                integer i=0;
                for(CSS_Claims__c lstrecClaims:recClaims){
                    for(CSS_PSN__c lstrecPSN :lstrecClaims.CSS_PSNs__r){
                        i=i+1;
                        MultiPSNWrapper ESN = new MultiPSNWrapper();
                        ESN.counting = i;
                        ESN.PSN = lstrecPSN.PSN__c;
                        ESN.WSD = string.valueof(lstrecPSN.Warranty_Start_Date__c);
                        if(lstrecPSN.Before_In_Service__c == true)
                            ESN.BIS = true;
                        else   
                            ESN.BIS = false;
                        if(lstrecPSN.Mileage_Measure__c == 'MI')
                            lstrecPSN.Mileage_Measure__c ='Miles';
                        ESN.failurePoint = ((string.valueOf(lstrecPSN.Failure_Point__c) == null || string.valueOf(lstrecPSN.Failure_Point__c) == '') ? '0' : string.valueOf(lstrecPSN.Failure_Point__c)) + ' ' + lstrecPSN.Mileage_Measure__c;
                        ESN.VIN = lstrecPSN.VIN__c;
                        ESN.calibrationAfter = lstrecPSN.Calibration_After__c;
                        ESN.calibrationBefore = lstrecPSN.Calibration_Before__c;
                        ESN.revisionBefore = lstrecPSN.Revision_Before__c;
                        ESN.revisionAfter = lstrecPSN.Revision_After__c;
                        lstofAdditionalESNs.add(ESN);       
                    }
                }
                system.debug('lstofAdditionalESNs>>>>>>>' + lstofAdditionalESNs);
            }
            // End code as per story #162525 [Only UI ]from Polar Express,-By RAJESH 17th Dec 2018
        }

        catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsViewPaymentDetails constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }

    }

    public void fetchClaimSubmissionRecords() {
        system.debug('inside fetchClaimSubmissionRecords');
        String CreatorLocation;
        css_utility utility = new css_utility(); //GSSC-138
        if(cStatus != 'Draft'){ 
            claimSubRec=[Select id,Name,Account_Code__c,CreatedBy.name,Status__c,Individual_Claim_Id__c,CSS_Claims__c,Siebel_Claim_Number__c,BFC__c,Claim_Number__c,Credit_Date__c,
                         Credit_Number__c,Deductible__c,IMS_Claim_Number__c,Labor__c,Other__c,Parts__c,PayCode__c,PMU__c,Rejection_Reason__c,Statement_Number__c,Tax__c,
                         Total_Paid__c,Travel__c,Type__c,Fail_Code__c from CSS_Claim_Submission__c where id= :cSId];
            system.debug('claimSubRec' + ' ' + claimSubRec);
            
            //GSSC-258 By Krishna
            if(claimSubRec.status__c != null && claimSubRec.Status__c == 'Denied') {
                DeniedRReason = claimSubRec.Rejection_Reason__c;	
            }
            //GSSC-258 By Krishna
            
            if(claimSubRec.Credit_Date__c!=Null){
                /* DateTime DateformValue = claimSubRec.Credit_Date__c;
                Date DateformValue2 = claimSubRec.Credit_Date__c;
                system.debug('DateformValue2');
                CreditDateValue = DateformValue.format('dd MMM YYYY hh:mm a z');*/
                CreditDateValue =dateTime.newInstance(claimSubRec.Credit_Date__c.year(),claimSubRec.Credit_Date__c.month(),claimSubRec.Credit_Date__c.day()).format('dd MMM yyyy hh:mm a z');
                system.debug('Testdate'+CreditDateValue);
            }
            claimsRec=[Select id,Account__r.Type,Customer_Name__c,Multi_PSN_Claim__c,Dealer_Service_Job__r.Name,Dealer_Service_Job__c,CSS_Job__c,Status__c,Location__c,SiebelClaimNumber__c,Location_Code__c,Account__c,Account__r.RSS_RESP_BRANCH_NAME__c,Account__r.RSS_RESP_BRANCH_CODE__c,
                       Actual_Technician_Time__c,CSS_Job__r.Name,Shop_Work_Order__c,JobEditCause__c,JobEditComplaint__c,JobEditCorrection__c,EditComplaint__c,Claims_General_Symptoms__c,EditCause__c,
                       EditCorrection__c,(Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                                          Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,Unit_Type__c,
                                          Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1)  from CSS_Claims__c where id= :claimSubRec.CSS_Claims__c];
            system.debug('claimsRec' + ' ' + claimsRec);
            DealerTypeFlag = CSS_utility.getAccounttype(claimsRec.Account__r.Type);
            if(claimsRec != null && claimsRec.Id != null) {
                solComRec = [SELECT Id, Name,Quantity__c,CSS_Claims__c,CSS_CoverageType__c,CSS_Account_Formula__c,AccountCode__c,Fail_Code__c,Part_Warranty_Start_Date__c,Failure_Date__c,Failure_Point__c,Failure_Measure__c
                             FROM css_solution_component__c 
                             WHERE CSS_Claims__c= :claimsRec.ID and Selected_Component__c = true and type__C NOT IN ('TSB', 'TRP','ATC','Campaign')];
                             system.debug('solComRec***' + ' ' + solComRec);
                    //Siva Ganesh added condition for story GSSC-306
                    for(css_solution_component__c sol:solComRec){
                        if(solComRec.size()>0 && sol.name!=null && sol.name!=''){
                            if(sol.CSS_CoverageType__c == 'NPW' || sol.CSS_CoverageType__c == 'RPW' || sol.CSS_CoverageType__c == 'RRW'){
                               if(claimSubRec.Account_Code__c == sol.CSS_Account_Formula__c  && claimSubRec.Fail_Code__c  == sol.Fail_Code__c){
                                  isFailAccountCode = true;
                                    WarrantyStartDate = dateTime.newInstance(sol.Part_Warranty_Start_Date__c.year(),sol.Part_Warranty_Start_Date__c.month(),sol.Part_Warranty_Start_Date__c.day()).format('dd MMM yyyy hh:mm a z');    
                                    FailureDate = dateTime.newInstance(sol.Failure_Date__c.year(),sol.Failure_Date__c.month(),sol.Failure_Date__c.day()).format('dd MMM yyyy hh:mm a z');
                                    MileageValue = string.valueOf(sol.Failure_Point__c);
                                    productHoursValue = String.valueOf(sol.Failure_Point__c);
                                    failureMeasure = sol.Failure_Measure__c;
                                    if(failureMeasure.Contains('Miles') ||failureMeasure.Contains('Kilometers')){
                                        Mileage = MileageValue;
                                        productHours = '';
                                    } else if(failureMeasure.Contains('Hours')){
                                        Mileage = '';
                                        productHours = productHoursValue;
                                    }
                                }
                            }
                                
                         }
                     }
                if(ClaimsRec != null && ClaimsRec.CSS_Job__c == null){
                    if(ClaimsRec.EditCorrection__c=='' || ClaimsRec.EditCorrection__c==null){
                        system.debug('insideif'+ClaimsRec.EditCorrection__c);
                        for(css_solution_component__c sol:solComRec){
                            if(solComRec.size()>0 && sol.name!=null && sol.name!='')
                            {   
                                if(ClaimsRec.EditCorrection__c!=null)
                                    ClaimsRec.EditCorrection__c += 'Failure Name ='+sol.Name+ '\n' + 'Quantity =' +sol.Quantity__c+ '\n';
                                else{
                                    ClaimsRec.EditCorrection__c = '';
                                    ClaimsRec.EditCorrection__c +=  'Failure Name ='+sol.Name+ '\n' + 'Quantity =' +sol.Quantity__c+ '\n';
                                }
                                system.debug('solname'+sol.Name);
                                system.debug('Edit Correction'+ClaimsRec.EditCorrection__c);
                            }

                        }
                    }
                    else{
                        ClaimsRec.EditCorrection__c = ClaimsRec.EditCorrection__c;

                    }
                }
                //Added Tracking_Number__c, RID__c in below query as part of the defect # 191794
                claimsPOList = [select Id, Unit_Price__c, Service_Job__c, CSS_Claims__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c, Part_Name__c,Covered__c,Quantity__c,Type__c,Mileage__c,HoursTravelled__c,ExpenseTotal__c,Name,ReturnToFactory__c,RID__c,Option_Number__c,Tracking_Number__c,Item__c,Amount__c,Service_partnumber__c,Account_Code__c,Part_Description__c,recordtype.name
                                from CSS_Parts_Options__c
                                where CSS_Claims__c =: claimsRec.Id AND Account_Code__c != null ORDER BY CreatedDate DESC]; //Added order by as part of the task # 191794
                system.debug('claimsPOList' + ' ' + claimsPOList);
                
                //GSSC-138 start
                Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
                Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
                
                for(CSS_Parts_Options__c p : claimsPOList){
                    if(p.RecordTypeId == recTypeIdOC || p.RecordTypeId == recTypeIdTTML)
                    partExchangeRate = p.Exchange_Rate_Version__c;
                    break;
                }
                
                mapPartsList = utility.displayParts(claimsPOList);
                system.debug('mapPartsList--'+mapPartsList);
                //GSSC-138 end
            
                claimsSRTList = [SELECT Id, Name,Account_Code__c,SRT_ID__c, SRT_Title__c,Claimed_Hours__c,
                                 SRT_Time__c, SRT_Quantity__c, SRT_Warrantable__c, AccountCode_Formula__c,
                                 Calculated_Claimed_Hours__c, Type__c, SRT_Type__c, Overlap_Hours__c, Extended_Hours__c
                                 FROM CSS_SRT__c WHERE CSS_Claims__c =: claimsRec.Id AND (Account_Code__c != null OR AccountCode_Formula__c != null) 
                                ];
            }


            if(claimsSRTList.size()>0){
                for(CSS_SRT__c SRTtemp : claimsSRTList) {
                    if(SRTAccountCodeMap.containsKey(SRTtemp.AccountCode_Formula__c+SRTtemp.SRT_ID__c)) {
                        List<CSS_SRT__c> srtList = SRTAccountCodeMap.get(SRTtemp.AccountCode_Formula__c+SRTtemp.SRT_ID__c);
                        srtList.add(SRTtemp);
                        SRTAccountCodeMap.put(SRTtemp.AccountCode_Formula__c+SRTtemp.SRT_ID__c,srtList);
                    } else {
                        SRTAccountCodeMap.put(SRTtemp.AccountCode_Formula__c+SRTtemp.SRT_ID__c, new List<CSS_SRT__c>  { SRTtemp });
                    }

                }
            }

            if(claimsPOList.size()>0){
                for(CSS_Parts_Options__c potemp : claimsPOList) {
                    if(potemp.recordtype.name=='BMS Parts' || potemp.recordtype.name=='Parts'){
                        if(POAccountCodeMap.containsKey(potemp.Account_Code__c+potemp.Service_partnumber__c)) {
                            List<CSS_Parts_Options__c> polist = POAccountCodeMap.get(potemp.Account_Code__c+potemp.Service_partnumber__c);
                            polist.add(potemp);
                            POAccountCodeMap.put(potemp.Account_Code__c+potemp.Service_partnumber__c,polist);
                        } else {
                            POAccountCodeMap.put(potemp.Account_Code__c+potemp.Service_partnumber__c, new List<CSS_Parts_Options__c> { potemp });
                        }}
                    system.debug('POAccountCodeMapPOAccountCodeMap' + ' ' + POAccountCodeMap);
                    if(potemp.recordtype.name=='OtherClaimables'){
                        if(OCAccountCodeMap.containsKey(potemp.Account_Code__c+potemp.Item__c)) {
                            List<CSS_Parts_Options__c> polist = OCAccountCodeMap.get(potemp.Account_Code__c+potemp.Item__c);
                            polist.add(potemp);
                            OCAccountCodeMap.put(potemp.Account_Code__c+potemp.Item__c,polist);
                        } else {
                            OCAccountCodeMap.put(potemp.Account_Code__c+potemp.Item__c, new List<CSS_Parts_Options__c> { potemp });
                        }}
                    if(potemp.recordtype.name=='TTML'){
                        if(TTMLAccountCodeMap.containsKey(potemp.Account_Code__c+potemp.type__c)) {
                            List<CSS_Parts_Options__c> polist = TTMLAccountCodeMap.get(potemp.Account_Code__c+potemp.type__c);
                            polist.add(potemp);
                            TTMLAccountCodeMap.put(potemp.Account_Code__c+potemp.type__c,polist);
                        } else {
                            TTMLAccountCodeMap.put(potemp.Account_Code__c+potemp.type__c, new List<CSS_Parts_Options__c> { potemp });
                        }}

                }
            }

        } 

        if(cStatus == 'Draft'){

            system.debug('inside cstatus ' + cStatus);

            claimsRec=[Select id,Customer_Name__c,Multi_PSN_Claim__c,CSS_Job__c,Location__c,Status__c,SiebelClaimNumber__c,Location_Code__c,Account__c,Account__r.RSS_RESP_BRANCH_NAME__c,Account__r.RSS_RESP_BRANCH_CODE__c,
                       Actual_Technician_Time__c,CSS_Job__r.Name,Shop_Work_Order__c,JobEditCause__c,JobEditComplaint__c,JobEditCorrection__c,EditComplaint__c,Claims_General_Symptoms__c,EditCause__c,
                       EditCorrection__c,(Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                                          Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,Unit_Type__c,
                                          Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1)  from CSS_Claims__c where id= :cSID];
            system.debug('inside cstatus claimsRec' + ' ' + claimsRec );

            if(claimsRec != null && claimsRec.Id != null) {
                solComRec = [SELECT Id, Name,Quantity__c,CSS_Claims__c
                             FROM css_solution_component__c 
                             WHERE CSS_Claims__c= :claimsRec.ID and Selected_Component__c = true and type__C NOT IN ('TSB', 'TRP','ATC','Campaign')];
                if(ClaimsRec != null && ClaimsRec.CSS_Job__c == null){

                    if(ClaimsRec.EditCorrection__c=='' || ClaimsRec.EditCorrection__c==null){
                        system.debug('insideif'+ClaimsRec.EditCorrection__c);
                        for(css_solution_component__c sol:solComRec){
                            if(solComRec.size()>0 && sol.name!=null && sol.name!='')
                            {
                                if(ClaimsRec.EditCorrection__c!=null)
                                    ClaimsRec.EditCorrection__c += 'Failure Name ='+sol.Name+ '\n' + 'Quantity =' +sol.Quantity__c+ '\n';
                                else{
                                    ClaimsRec.EditCorrection__c = '';
                                    ClaimsRec.EditCorrection__c +=  'Failure Name ='+sol.Name+ '\n' + 'Quantity =' +sol.Quantity__c+ '\n';
                                }
                                system.debug('solname'+sol.Name);
                                system.debug('Edit Correction'+ClaimsRec.EditCorrection__c);
                            }

                        }
                    }
                    else{
                        ClaimsRec.EditCorrection__c = ClaimsRec.EditCorrection__c;

                    }
                }
                //Added RID__c in below query as part of the defect # 191794
                claimsPOList = [select Id, Unit_Price__c, Service_Job__c, CSS_Claims__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c, Part_Name__c,Covered__c,Quantity__c,Type__c,Mileage__c,HoursTravelled__c,ExpenseTotal__c,Name,ReturnToFactory__c,RID__c,Option_Number__c,
                                Item__c,Amount__c,Service_partnumber__c,Account_Code__c,Part_Description__c,recordtype.name,Tracking_Number__c
                                from CSS_Parts_Options__c
                                where CSS_Claims__c =: claimsRec.Id ORDER BY CreatedDate DESC]; //Added order by as part of the task # 191794
                
                //GSSC-138 start
                Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
                Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
                
                for(CSS_Parts_Options__c p : claimsPOList){
                    if(p.RecordTypeId == recTypeIdOC || p.RecordTypeId == recTypeIdTTML)
                    partExchangeRate = p.Exchange_Rate_Version__c;
                    break;
                }
                
                mapPartsList = utility.displayParts(claimsPOList);
                system.debug('mapPartsList--'+mapPartsList);
                //GSSC-138 end
                
                claimsSRTList = [SELECT Id, Name,Account_Code__c,SRT_ID__c, SRT_Title__c,
                                 SRT_Time__c, SRT_Quantity__c, SRT_Warrantable__c, AccountCode_Formula__c,
                                 Calculated_Claimed_Hours__c, Type__c, SRT_Type__c, Overlap_Hours__c
                                 FROM CSS_SRT__c WHERE CSS_Claims__c =: claimsRec.Id  
                                ];
            }

            lstclaimDetailPartswrapper =new List<claimDetailPartswrapper>();
            lstclaimDetailSRTswrapper=new List<claimDetailSRTswrapper>();
            lstclaimDetailOtherClaimableswrapper= new List<claimDetailOtherClaimableswrapper> ();
            lstclaimDetailTravelwrapper=new  List<claimDetailTravelwrapper> ();

            if(claimsPOList.size()>0){
                for(CSS_Parts_Options__c potemp : claimsPOList) {
                    if(potemp.recordtype.name=='BMS Parts' || potemp.recordtype.name=='Parts'){

                        claimDetailPartswrapper parts =new claimDetailPartswrapper();
                        parts.PartDescription=potemp.Part_Description__c;
                        parts.ClaimedQuantity=String.ValueOf(potemp.Quantity__c); 
                        //parts.EPRTracking=potemp.Option_Number__c;
                        parts.EPRTracking=potemp.Tracking_Number__c;
                        parts.ReturnID =potemp.ReturnToFactory__c;
                        parts.PartNumber = potemp.Service_partnumber__c;
                        lstclaimDetailPartswrapper.add(parts);
                        system.debug('lstclaimDetailPartswrapper' + lstclaimDetailPartswrapper);
                    }
                    if(potemp.recordtype.name=='OtherClaimables'){
                        
                        //GSSC-138 START
                        decimal amount;
                        Map<decimal, decimal> mapTemp = new Map<decimal, decimal>();
                        
                        if(mapPartsList != null){
                            mapTemp = mapPartsList.get(potemp.Id);
                            
                            if(mapTemp != null){
                                for(decimal up : mapTemp.keyset()){
                                    amount = mapTemp.get(up);
                                }
                            }
                        }
                        amount = amount.setscale(2);
                        
                        system.debug('amount--'+amount);
                        
                        //GSSC-138 end
                                    
                        claimDetailOtherClaimableswrapper OCparts = new claimDetailOtherClaimableswrapper();
                        if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                            OCparts.ClaimedItemAmount=String.ValueOf(potemp.ExpenseTotal__c);
                        }
                        else{
                            OCparts.ClaimedItemAmount=String.ValueOf(amount);
                        }
                        OCparts.Description  = potemp.Part_Description__c;
                        OCparts.Item = potemp.Item__c;
                        lstclaimDetailOtherClaimableswrapper.add(OCparts);
                        system.debug('lstclaimDetailOtherClaimableswrapper' + lstclaimDetailOtherClaimableswrapper);
                    }


                    if(potemp.recordtype.name=='TTML'){
                        claimDetailTravelwrapper ttml = new claimDetailTravelwrapper();
                        //GSSC-138 START
                        decimal amount;
                        Map<decimal, decimal> mapTemp = new Map<decimal, decimal>();
                        
                        if(mapPartsList != null){
                            mapTemp = mapPartsList.get(potemp.Id);
                            
                            if(mapTemp != null){
                                for(decimal up : mapTemp.keyset()){
                                    amount = mapTemp.get(up);
                                }
                            }
                        }
                        amount = amount.setscale(2);
                        
                        system.debug('amount--'+amount);
                        
                        //GSSC-138 end
                        if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                            if(ttml.ClaimedAmount!=null){
                                ttml.ClaimedAmount+=potemp.ExpenseTotal__c; 
                            }
                            else{  
                                ttml.ClaimedAmount=potemp.ExpenseTotal__c; 
                            }
                        }
                        else{
                            if(ttml.ClaimedAmount!=null){
                                ttml.ClaimedAmount+=amount;//potemp.ExpenseTotal__c; //GSSC-138
                            }
                            else{  
                                ttml.ClaimedAmount=amount; //potemp.ExpenseTotal__c; 
                            }
                        }
                        
                        if(ttml.ClaimedAmount!=null){
                            if(ttml.TravelType!=null && (ttml.TravelType.Contains('Lodging') || ttml.TravelType.Contains('Meals') )) {
                                ttml.ClaimedLodgingMealsAmount+=potemp.ExpenseTotal__c;  
                            }
                        }
                        else{  
                            if(ttml.TravelType!=null && (ttml.TravelType.Contains('Lodging') || ttml.TravelType.Contains('Meals') )) {
                                ttml.ClaimedLodgingMealsAmount=potemp.ExpenseTotal__c; 
                            }
                        }
                        if(ttml.TravelType!=null && ttml.TravelType.Contains('Commercial')) {
                            if(ttml.ClaimedMileage!=null){
                                ttml.ClaimedMileage+=Integer.ValueOf(potemp.Mileage__c); 
                            }
                            else{  ttml.ClaimedMileage=Integer.ValueOf(potemp.Mileage__c); } 
                            if(ttml.ClaimedHours!=null)
                                ttml.ClaimedHours+=Double.ValueOf(potemp.HoursTravelled__c); 
                            else{  ttml.ClaimedHours=Double.ValueOf(potemp.HoursTravelled__c); } 
                        } 
                        ttml.type = potemp.type__c;
                        lstclaimDetailTravelwrapper.add(ttml);
                        system.debug('lstclaimDetailTravelwrapper' + lstclaimDetailTravelwrapper);
                        if(potemp.Mileage__c != null && ttml.TravelType!=null && ttml.TravelType.Contains('Commercial'))
                            Claimed_Total_Mileage += Integer.ValueOf(potemp.Mileage__c);
                        //Adjusted_Total_Mileage = //web
                        if(potemp.HoursTravelled__c != null && ttml.TravelType!=null && ttml.TravelType.Contains('Commercial'))
                            Claimed_ttTotal_Hours +=Double.ValueOf(potemp.HoursTravelled__c);
                        //Adjusted_ttTotal_Hours = //web
                        if(potemp.ExpenseTotal__c != null)
                            claimed_Lodging_Meals +=potemp.ExpenseTotal__c;  
                        //Adjusted_Lodging_Meals = //web  

                    }
                }


            }

            system.debug('claimsSRTList' + claimsSRTList);
            if(claimsSRTList.size()>0){
                for(CSS_SRT__c srttemp : claimsSRTList) {
                    claimDetailSRTswrapper srt = new claimDetailSRTswrapper();
                    srt.ClaimedQuantity=String.ValueOf(srttemp.SRT_Quantity__c);
                    srt.Hours=String.ValueOf(srttemp.Calculated_Claimed_Hours__c);
                    if(srt.Hours!=null)
                        claimed_Total_Hours=claimed_Total_Hours+Double.valueOf(srt.Hours);
                    srt.Claimedper=srttemp.SRT_Warrantable__c;
                    srt.SRTCode =  srttemp.SRT_ID__c;
                    lstclaimDetailSRTswrapper.add(srt);
                    system.debug('lstclaimDetailSRTswrapper' + lstclaimDetailSRTswrapper);
                }
            }


        }



        //Populate LocationCode
        if(claimsRec != null && claimsRec.Id != null) 
        {
            if(claimsRec.Location_Code__c!=null)
            {
                CreatorLocation = claimsRec.Location_Code__c;
            }
            else
            {
                User user = css_utility.getUserAttributes(userInfo.getUserId());
                CreatorLocation = user.User_Location__c;                               
            }
            Integer JobLocLength = CreatorLocation.Length();
            Integer Index = JobLocLength-5;

            LocationCode = CreatorLocation.substring(Index,CreatorLocation.Length());
            system.debug('LocationCode End' + ' ' + LocationCode);
            if(claimsRec.CSS_PSNs__r[0].Warranty_Start_Date__c!=null && isFailAccountCode == false)
            {
                //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
                WarrantyStartDate =dateTime.newInstance(claimsRec.CSS_PSNs__r[0].Warranty_Start_Date__c.year(),claimsRec.CSS_PSNs__r[0].Warranty_Start_Date__c.month(),claimsRec.CSS_PSNs__r[0].Warranty_Start_Date__c.day()).format('dd MMM yyyy hh:mm a z');
            }
            if(claimsRec.CSS_PSNs__r[0].Failure_Date__c!=null && isFailAccountCode == false)
            {
               //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31

                FailureDate =dateTime.newInstance(claimsRec.CSS_PSNs__r[0].Failure_Date__c.year(),claimsRec.CSS_PSNs__r[0].Failure_Date__c.month(),claimsRec.CSS_PSNs__r[0].Failure_Date__c.day()).format('dd MMM yyyy hh:mm a z');
            }
        }

        //claimsubmission note-adjudicator notes
        lstClaimsubmissionNotes=new List<ClaimsubmissionNotes>();
        for(Note notes: [SELECT Id,Body,title,parentId, CreatedBy.firstname, CreatedDate,
                         CreatedBy.lastname, LastModifiedDate,CreatedById 
                         FROM Note WHERE parentId =:claimSubRec.id 
                         order by LastModifiedDate ASC  LIMIT 1000]){
            system.debug('>>>notessss<<<' + notes);                  
            ClaimsubmissionNotes temp  = new ClaimsubmissionNotes();
            List<String> lstStr = new List<String>();
            if(notes.Body != null){
                lstStr = notes.Body.split(';;');
                //temp.Notes= notes.Body;
                if(lstStr.size() > 3)
                    temp.Notes= lstStr[3];
                //temp.AdjudicatorName=notes.CreatedBy.firstname+'  '+notes.CreatedBy.lastname;
                if(lstStr.size() > 5)
                    temp.AdjudicatorName=lstStr[4]+'  '+lstStr[5];
                //temp.Notestime=(notes.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
                if(lstStr.size() > 1)
                    temp.Notestime=(dateTime.valueof(lstStr[1]).format('dd MMM yyyy hh:mm a z'));
                lstClaimsubmissionNotes.add(temp);
                system.debug('>>>lstClaimsubmissionNotes<<<' + lstClaimsubmissionNotes);
            }
        }


    }
    public Decimal TotalClaimedHours{get;set;}
    public Decimal TotalAdjustedHours{get;set;}
    public void Callgetpaidclaimdetails() {
        TotalAdjustedHours = 0.0;
        TotalClaimedHours = 0.0;
        lstclaimDetailPartswrapper =new List<claimDetailPartswrapper>();
        lstclaimDetailSRTswrapper=new List<claimDetailSRTswrapper>();
        lstclaimDetailOtherClaimableswrapper= new List<claimDetailOtherClaimableswrapper> ();
        lstclaimDetailTravelwrapper=new  List<claimDetailTravelwrapper> ();
        CG_PaidClaimsDetailsResWrapper resWrap = new CG_PaidClaimsDetailsResWrapper();
        CG_PaidClaimsDetailsReqWrapper submitReq =new CG_PaidClaimsDetailsReqWrapper();
        CG_PaidClaimsDetailsReqWrapper.Header headerobj = new  CG_PaidClaimsDetailsReqWrapper.Header();
        CG_PaidClaimsDetailsReqWrapper.Sender Senderobj = new  CG_PaidClaimsDetailsReqWrapper.Sender();
        Senderobj.MessageID='UniqueID';
        Senderobj.ServiceName='getPaidClaimsDetails';
        Senderobj.SenderID='CSS';
        headerobj.Sender=Senderobj;

        CG_PaidClaimsDetailsReqWrapper.DataArea  DataAreaobj  = new  CG_PaidClaimsDetailsReqWrapper.DataArea ();
        DataAreaobj.IMSClaimNumber=claimSubRec.IMS_Claim_Number__c;
        DataAreaobj.ClaimNumber=claimSubRec.Individual_Claim_Id__c;
        //DataAreaobj.IMSClaimNumber='66062';
        //DataAreaobj.ClaimNumber='0366062';
        CG_PaidClaimsDetailsResWrapper.DataArea  resDataAreaobj = new CG_PaidClaimsDetailsResWrapper.DataArea();

        submitReq.Header =Headerobj;
        submitReq.DataArea =DataAreaobj;
        /*   String jsonResponseBody='{'+
'  "DataArea": {'+
'    "DetailSRTs": ['+
'      {'+
'        "SRTHours": 0.4,'+
'        "SRTQty": 1,'+
'        "PercentageAdjustment": 100,'+
'        "AdjustmentReason": "",'+
'        "AccessCode": "R",'+
'        "SRTCode": "00-00C-00",'+
'        "PenaltyAppliedFlag": ""'+
'      },'+
'      {'+
'        "SRTHours": 0.2,'+
'        "SRTQty": 1,'+
'        "PercentageAdjustment": 100,'+
'        "AdjustmentReason": "",'+
'        "AccessCode": "B",'+
'        "SRTCode": "TS-051-01",'+
'        "PenaltyAppliedFlag": "Y"'+
'      }'+
'    ],'+
'    "DetailOtherClaimables": ['+
'      {'+
'        "Item": "BELT",'+
'        "Description": "1",'+
'        "ApprovedAmount": 2452,'+
'        "AdjustmentReason": ""'+
'      }'+
'    ],'+
'    "DetailParts": ['+
'      {'+
'        "AdjustmentPartsPercent": 100,'+
'        "PartQty": 1,'+
'        "PartNumber": "289733300",'+
'        "AdjustmentReason": ""'+
'      }'+
'    ],'+
'    "DetailTravel": ['+
'      {'+
'        "TravelType": "Commercial",'+
'        "AdjustmentReason": "",'+
'        "Distance": 2452,'+
'        "Hours": 2.3,'+
'        "LodgingAmount": 345,'+
'        "MealsAmount": 46,'+
'        "PenaltyAppliedFlag": "Y",'+
'        "TowingDetails": 234'+
'      },'+
'      {'+
'        "TravelType": "Non-Commercial",'+
'        "AdjustmentReason": "",'+
'        "Distance": 2452,'+
'        "Hours": 2.3,'+
'        "LodgingAmount": 345,'+
'        "MealsAmount": 46,'+
'        "PenaltyAppliedFlag": "",'+
'        "TowingDetails": 234'+
'      }'+
'    ]'+
'  },'+
'  "Header": {'+
'    "ReturnCodeDescription": "",'+
'    "Status": "Success",'+
'    "DistributorName": "Test Distributor USER",'+
'    "DistributorCode": "12345"'+
'  }'+
'}'+
'';
resWrap = (CG_PaidClaimsDetailsResWrapper )JSON.deserialize(jsonResponseBody,CG_PaidClaimsDetailsResWrapper.class); */
        resWrap=CSS_FN_SIEBEL.paidclaimdetails(submitReq);
        system.debug('resWrap' + ' ' + resWrap);
        if(resWrap!=null && resWrap.Header!=null){
            if(resWrap.Header.Status=='Success'){

                // Story 166124              
                DistributorName=resWrap.Header.DistributorName;
                //DistributorName='Test Distibutor';
                system.debug('Distributor Name' +DistributorName);
                DistributorCode=resWrap.Header.DistributorCode;
                //DistributorCode='234';
                system.debug('DistributorCode' +DistributorCode); 

                if(resWrap.DataArea!=null){ 
                    system.debug('resWrap.DataArea.DetailParts' + ' ' + resWrap.DataArea.DetailParts);
                    if(resWrap.DataArea.DetailParts!=null){
                        for(CG_PaidClaimsDetailsResWrapper.DetailParts p : resWrap.DataArea.DetailParts){
                            claimDetailPartswrapper parts =new claimDetailPartswrapper();
                            decimal claimedQtyTemp = 0; //Added as part of the defect # 191793
                            List<CSS_Parts_Options__c> POlist = POAccountCodeMap.get(claimSubRec.Account_Code__c+p.PartNumber);
                            if(POlist != null && POlist.size() > 0) {
                                for(CSS_Parts_Options__c p1 : POlist) {
                                    if(p1.recordtype.name=='BMS Parts' || p1.recordtype.name=='Parts'){
                                        parts.PartDescription=p1.Part_Description__c;
                                        claimedQtyTemp = claimedQtyTemp + p1.Quantity__c; //Added as part of the defect # 191793
                                        //parts.ClaimedQuantity=String.ValueOf(p1.Quantity__c);  //Commented as part of the defect # 191793
                                        parts.EPRTracking=p1.Tracking_Number__c;//p1.Option_Number__c; //Commented Option_Number__c and added Tracking_Number__c as part of the defect # 191794
                                        parts.ReturnID=p1.RID__c;//p1.ReturnToFactory__c;//Commented ReturnToFactory__c and added RID__c as part of the defect # 191794
                                        parts.ClaimedPercentage = String.valueOf(p1.Covered__c); 
                                    }
                                }

                            }
                            parts.ClaimedQuantity = string.valueof(claimedQtyTemp); //Added as part of the defect # 191793
                            parts.AdjustmentPartsPercent=p.AdjustmentPartsPercent;
                            parts.PartQty=p.PartQty;
                            parts.PartNumber=p.PartNumber;
                            parts.AdjustmentReason=p.AdjustmentReason;

                            lstclaimDetailPartswrapper.add(parts);
                            system.debug('lstclaimDetailPartswrapper lstclaimDetailPartswrapper' + ' ' + lstclaimDetailPartswrapper);
                        }}
                    system.debug('resWrap.DataArea.DetailOtherClaimables' + ' ' + resWrap.DataArea.DetailOtherClaimables);
                    Decimal latestVersion;
                    if(resWrap.DataArea.DetailOtherClaimables!=null){
                        for(CG_PaidClaimsDetailsResWrapper.DetailOtherClaimables o : resWrap.DataArea.DetailOtherClaimables){
                            claimDetailOtherClaimableswrapper oc =new claimDetailOtherClaimableswrapper();
                            try{
                                system.debug('claimSubRec.Account_Code__c' + ' ' + claimSubRec.Account_Code__c);
                                system.debug('o.Item' + ' ' + o.Item);
                                List<CSS_Parts_Options__c> POlist = OCAccountCodeMap.get(claimSubRec.Account_Code__c+o.Item);
                                system.debug('POlist POlist' + ' ' + POlist);
                                if(POlist != null && POlist.size() > 0) {
                                    for(CSS_Parts_Options__c p1 : POlist) {
                                        
                                        if(p1.recordtype.name=='OtherClaimables'){
                                            latestVersion = p1.Exchange_Rate_Version__c;
                                             //GSSC-138 START
                                            decimal amount;
                                            Map<decimal, decimal> mapTemp = new Map<decimal, decimal>();
                                            
                                            if(mapPartsList != null){
                                                mapTemp = mapPartsList.get(p1.Id);
                                                
                                                if(mapTemp != null){
                                                    for(decimal up : mapTemp.keyset()){
                                                        amount = mapTemp.get(up);
                                                    }
                                                }
                                            }
                                            amount = amount.setscale(2);
                                            
                                            system.debug('amount--'+amount);
                                            
                                            //GSSC-138 end
                        
                                            //oc.ClaimedItemAmount=String.ValueOf(p1.Amount__c);//Added as part of the defect #191863
                                            if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                                oc.ClaimedItemAmount=String.ValueOf(p1.ExpenseTotal__c);
                                            }
                                            else{
                                                oc.ClaimedItemAmount=String.ValueOf(amount);//Added as part of the defect #191863 
                                            }
                                        }
                                    }

                                }}
                            catch(Exception e)  {
                            }

                            oc.Item=o.Item;
                            oc.Description=o.Description;
                            if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                oc.ApprovedAmount=string.valueof(decimal.valueof(o.ApprovedAmount).setscale(2));
                            }
                            else{
                                Decimal tempExchangeRate = versionExchangeRateMap.get(latestVersion);
                                oc.ApprovedAmount = string.valueof((decimal.valueof(o.ApprovedAmount) * tempExchangeRate).setscale(2));
                            }
                            oc.AdjustmentReason=o.AdjustmentReason;
                            lstclaimDetailOtherClaimableswrapper.add(oc);
                        }}

                    if(resWrap.DataArea.DetailSRTs!=null){
                        for(CG_PaidClaimsDetailsResWrapper.DetailSRTs s : resWrap.DataArea.DetailSRTs){
                            claimDetailSRTswrapper srt =new claimDetailSRTswrapper();
                            if(s.SRTCode!=null && s.SRTCode.contains('99-999')){
                                s.SRTCode = '99-999';
                            }
                            List<CSS_SRT__c> srtList = SRTAccountCodeMap.get(claimSubRec.Account_Code__c+s.SRTCode);
                            decimal srtQuantity = 0;//Added as part of the defect # 191793
                            decimal srtClaimedHours = 0.0;//Added as part of the defect # 191793
                            if(srtList != null && srtList.size() > 0) {
                                for(CSS_SRT__c s1 : srtList) {
                                    system.debug('SRT ----' + s1);
                                    if(s1.SRT_Quantity__c != null)
                                        srtQuantity += s1.SRT_Quantity__c;//Added as part of the defect # 191793
                                    if(s1.Extended_Hours__c != null)
                                        srtClaimedHours += s1.Extended_Hours__c;//Added as part of the defect # 191793
                                    //Commented below code for the defect # 191793
                                    ////srt.ClaimedQuantity=String.ValueOf(s1.SRT_Quantity__c);
                                    //srt.Hours=String.ValueOf(s1.Calculated_Claimed_Hours__c);
                                    //if(srt.Hours!=null)
                                    //claimed_Total_Hours=claimed_Total_Hours+Double.valueOf(srt.Hours);
                                    //srt.SRTCode =  s1.SRT_ID__c;
                                    srt.Claimedper=s1.SRT_Warrantable__c;
                                    ////srt.ClaimedHours = s1.Claimed_Hours__c;
                                    //Commented above code for the defect # 191793
                                }
                            }
                            srt.ClaimedQuantity = String.ValueOf(srtQuantity);//Added as part of the defect # 191793
                            srt.ClaimedHours = srtClaimedHours;//Added as part of the defect # 191793
                            TotalClaimedHours = TotalClaimedHours + srt.ClaimedHours;//Added as pet story GSSC-288..By RAJESH 27th Nov 2019
                            //system.debug('Test#$#'+srt.ClaimedHours+ s.SRTQty+ s.PercentageAdjustment);
                            srt.SRTHours=s.SRTHours;
                            srt.SRTQty=s.SRTQty;
                            srt.PercentageAdjustment=s.PercentageAdjustment;
                            srt.AdjustmentReason=s.AdjustmentReason;
                            srt.PenaltyAppliedFlag=s.PenaltyAppliedFlag=='Y'?'Y':'N';
                            srt.AccessCode=s.AccessCode;
                            srt.SRTCode=s.SRTCode;
                            if(srt.ClaimedHours !=null &&  srt.SRTQty !=null && srt.PercentageAdjustment !=null ){
                                srt.AdjustedHours = srt.ClaimedHours * srt.SRTQty * srt.PercentageAdjustment/100;
                                TotalAdjustedHours = TotalAdjustedHours + srt.AdjustedHours; //Added as pet story GSSC-288..By RAJESH 27th Nov 2019 
                            }
                            lstclaimDetailSRTswrapper.add(srt);
                        }}

                    if(resWrap.DataArea.DetailTravel!=null){
                        for(Integer i=1; i<=3; i++){  
                            claimDetailTravelwrapper ttml =new claimDetailTravelwrapper();
                            if(i==1)
                                ttml.Type='Non-Commercial';
                            if(i==2)
                                ttml.Type='Meals';
                            if(i==3)
                                ttml.Type='Lodging';
                            //Commented below as part of the task # 191794 - START
                            /*for(CG_PaidClaimsDetailsResWrapper.DetailTravel t : resWrap.DataArea.DetailTravel){
                                if(t.TravelType!=null && t.TravelType.Contains(ttml.Type)){
                                    List<CSS_Parts_Options__c> POlist = TTMLAccountCodeMap.get(claimSubRec.Account_Code__c+t.TravelType);
                                    system.debug('POlist POlist' + ' ' + POlist);
                                    if(POlist != null && POlist.size() > 0) {
                                        for(CSS_Parts_Options__c p1 : POlist) {
                                            if(p1.recordtype.name=='TTML'){
                                                if(ttml.ClaimedAmount!=null)
                                                    ttml.ClaimedAmount+=p1.ExpenseTotal__c; 
                                                else{  ttml.ClaimedAmount=p1.ExpenseTotal__c; }
                                                if(ttml.ClaimedAmount!=null){
                                                    if(t.TravelType!=null && (t.TravelType.Contains('Lodging') || t.TravelType.Contains('Meals') )) {
                                                        ttml.ClaimedLodgingMealsAmount+=p1.ExpenseTotal__c;  
                                                    }
                                                }
                                                else{  
                                                    if(t.TravelType!=null && (t.TravelType.Contains('Lodging') || t.TravelType.Contains('Meals') )) {
                                                        ttml.ClaimedLodgingMealsAmount=p1.ExpenseTotal__c; 
                                                    }
                                                }
                                                if(t.TravelType!=null && t.TravelType.Contains('Commercial')) {
                                                    if(ttml.ClaimedMileage!=null){
                                                        ttml.ClaimedMileage+=Integer.ValueOf(p1.Mileage__c); 
                                                    }
                                                    else{  ttml.ClaimedMileage=Integer.ValueOf(p1.Mileage__c); } 
                                                    if(ttml.ClaimedHours!=null)
                                                        ttml.ClaimedHours+=Double.ValueOf(p1.HoursTravelled__c); 
                                                    else{  ttml.ClaimedHours=Double.ValueOf(p1.HoursTravelled__c); } 
                                                } 
                                            }
                                        }
                                    }
                                    ttml.TravelType=t.TravelType;
                                    ttml.AdjustmentReason=t.AdjustmentReason;

                                    if((t.TravelType == 'Commercial' || t.TravelType == 'Non-Commercial') && t.PenaltyAppliedFlag == 'Y')
                                        ttml.PenaltyAppliedFlag = 'Y';
                                    else
                                        ttml.PenaltyAppliedFlag = 'N';
                                    //ttml.PenaltyAppliedFlag=t.PenaltyAppliedFlag;

                                    system.debug('t.TravelType--'+t.TravelType);
                                    system.debug('t.PenaltyAppliedFlag--'+t.PenaltyAppliedFlag);

                                    //if(!t.TravelType.contains('Commercial') || !t.TravelType.contains('Non-Commercial'))


                                    if(t.TravelType!=null && (t.TravelType!='Lodging' && t.TravelType!='Meals' && t.TravelType!='Towing')) {
                                        ttml.Distance=t.Distance;
                                        ttml.Hours=t.Hours;
                                    }
                                    if(t.TravelType!=null && t.TravelType=='Lodging')
                                        ttml.LodgingAmount=t.LodgingAmount;
                                    if(t.TravelType!=null && t.TravelType=='Meals')
                                        ttml.MealsAmount=t.MealsAmount;
                                    ttml.TowingDetails=t.TowingDetails;
                                    ttml.TotalTravel=t.TotalTravel;
                                    ttml.BaseFare=t.BaseFare;
                                    ttml.TravelAdjustedPercentage=t.TravelAdjustedPercentage;
                                    if(ttml.ClaimedMileage!=null)
                                        Claimed_Total_Mileage=Claimed_Total_Mileage+ttml.ClaimedMileage;
                                    if(ttml.Distance!=null)
                                        Adjusted_Total_Mileage=Adjusted_Total_Mileage+Integer.valueOf(ttml.Distance);  // Anvesh Changed to integer.valueOf() as part of defect 191640
                                    if(ttml.ClaimedHours!=null)
                                        Claimed_ttTotal_Hours=Claimed_ttTotal_Hours+ttml.ClaimedHours;
                                    if(ttml.Hours!=null)
                                        Adjusted_ttTotal_Hours=Adjusted_ttTotal_Hours+Double.valueOf(ttml.Hours); //Anvesh Changed to Double.valueOf() as part of defect 191640
                                    if(ttml.ClaimedLodgingMealsAmount!=null)
                                        claimed_Lodging_Meals=claimed_Lodging_Meals+ttml.ClaimedLodgingMealsAmount;
                                    if(ttml.LodgingAmount!=null)
                                        Adjusted_Lodging_Meals=Adjusted_Lodging_Meals+Decimal.valueOf(ttml.LodgingAmount); //Anvesh Changed to Decimal.valueOf() as part of defect 191640
                                    if(ttml.MealsAmount!=null)
                                        Adjusted_Lodging_Meals=Adjusted_Lodging_Meals+Decimal.valueOf(ttml.MealsAmount); //Anvesh Changed to Decimal.valueOf() as part of defect 191640


                                }}*/
                            //Commented below as part of the task # 191794 - END
                            //Added below as part of the task # 191794 - START
                            system.debug('Anvesh full wrap'+resWrap);
                            system.debug('Anvesh'+resWrap.DataArea.DetailTravel);
                            for(CG_PaidClaimsDetailsResWrapper.DetailTravel t : resWrap.DataArea.DetailTravel){
                                List<CSS_Parts_Options__c> POlist = new List<CSS_Parts_Options__c>();
                                system.debug('Today t>> ' + t);
                                system.debug('Today POlist>> ' + POlist);
                                if(t.TravelType != null && t.TravelType != ''){
                                    /*  commented as part of story GSSC-145
                                        if(t.TravelType == 'Commercial' && ttml.Type =='Commercial'){
                                            system.debug('Commercial');
                                            //Comm
                                            POlist = TTMLAccountCodeMap.get(claimSubRec.Account_Code__c+'Commercial-Travel');
                                            system.debug('POlist POlist' + ' ' + POlist);
                                            ttml.ClaimedMileage = 0;
                                            ttml.Distance = '';
                                            ttml.Hours = t.Hours; //Siebel value
                                            ttml.AdjustmentReason = t.AdjustmentReason; //Siebel value
                                            ttml.AdjustedAmount = t.TotalTravel;    //recent changes        //t.BaseFare; //Siebel value
                                            Decimal totalHrs = 0;
                                            Decimal totalExp = 0;
                                            if(POlist != null && POlist.size() > 0) {
                                                for(CSS_Parts_Options__c p1 : POlist) {
                                                    if(p1.HoursTravelled__c != null){
                                                        totalHrs = totalHrs + p1.HoursTravelled__c;
                                                    }
                                                    if(p1.ExpenseTotal__c != null){
                                                        totalExp = totalExp + p1.ExpenseTotal__c;
                                                    }
                                                }

                                                ttml.ClaimedHours = totalHrs; //Guidanz value
                                                ttml.ClaimedAmount = totalExp; //Guidanz value

                                                Claimed_ttTotal_Hours += ttml.ClaimedHours;
                                                Adjusted_ttTotal_Hours += double.valueOf(t.hours);
                                            }
                                        } */

                                    if(t.TravelType == 'Non-Commercial' && (ttml.Type == 'Non-Commercial' || ttml.Type == 'Meals' || ttml.Type == 'Lodging')){
                                        system.debug('ttml.Type' +ttml.Type);
                                        system.debug('t.MealsAmount'+t.MealsAmount);
                                        
                                        if(ttml.Type == 'Meals' && t.MealsAmount != null && t.MealsAmount != '' && double.valueof(t.MealsAmount) > 0){
                                            //Meals
                                            system.debug('Meals');
                                            POlist = TTMLAccountCodeMap.get(claimSubRec.Account_Code__c+'Meals');
                                            system.debug('POlist POlist' + ' ' + POlist);
                                            ttml.ClaimedMileage = 0;
                                            ttml.ClaimedHours = 0;
                                            ttml.Distance = '';
                                            ttml.Hours = '';
                                            ttml.AdjustmentReason = t.AdjustmentReason; //Siebel value
                                            //ttml.AdjustedAmount = t.MealsAmount; //Siebel value GSSC-138
                                            Decimal totalExp = 0;
                                            if(POlist != null && POlist.size() > 0) {
                                                for(CSS_Parts_Options__c p1 : POlist) {
                                                    if(p1.ExpenseTotal__c != null){
                                                        totalExp = totalExp + p1.ExpenseTotal__c;
                                                    }
                                                }
                                                if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                                    ttml.ClaimedAmount = totalExp; //Guidanz value
                                                }
                                                else{
                                                    Decimal tempExchangeRate = versionExchangeRateMap.get(partExchangeRate);
                                                    if(tempExchangeRate != null){
                                                        ttml.ClaimedAmount = totalExp * tempExchangeRate; //Guidanz value
                                                    }
                                                    else{
                                                        ttml.ClaimedAmount = totalExp;
                                                    }
                                                }
                                            }
                                            if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                                ttml.AdjustedAmount = t.MealsAmount;
                                            }
                                            else{
                                                Decimal tempExchangeRate = versionExchangeRateMap.get(partExchangeRate);
                                                if(tempExchangeRate != null){
                                                    ttml.AdjustedAmount = string.valueof((decimal.valueof(t.MealsAmount) * tempExchangeRate).setScale(2));
                                                }
                                                else{
                                                    ttml.AdjustedAmount = t.MealsAmount;
                                                }
                                            }
                                            claimed_Lodging_Meals += ttml.ClaimedAmount;
                                            Adjusted_Lodging_Meals += decimal.valueOf(ttml.AdjustedAmount);
                                        }
                                        else if(ttml.Type == 'Lodging' && t.LodgingAmount != null && t.LodgingAmount != '' && double.valueof(t.LodgingAmount) > 0){
                                            //Lodging
                                            system.debug('Lodging');
                                            POlist = TTMLAccountCodeMap.get(claimSubRec.Account_Code__c+'Lodging');
                                            system.debug('POlist POlist' + ' ' + POlist);
                                            //ttml.Type = 'Lodging';
                                            ttml.ClaimedMileage = 0;
                                            ttml.ClaimedHours = 0;
                                            ttml.Distance = '';
                                            ttml.Hours = '';
                                            ttml.AdjustmentReason = t.AdjustmentReason; //Siebel value
                                            //ttml.AdjustedAmount = t.LodgingAmount; //Siebel value GSSC-138
                                            Decimal totalExp = 0;
                                            if(POlist != null && POlist.size() > 0) {
                                                for(CSS_Parts_Options__c p1 : POlist) {
                                                    if(p1.ExpenseTotal__c != null){
                                                        totalExp = totalExp + p1.ExpenseTotal__c;
                                                    }
                                                }
                                                if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                                    ttml.ClaimedAmount = totalExp; //Guidanz value
                                                }
                                                else{
                                                    Decimal tempExchangeRate = versionExchangeRateMap.get(partExchangeRate);
                                                    if(tempExchangeRate != null){
                                                        ttml.ClaimedAmount = totalExp * tempExchangeRate; //Guidanz value
                                                    }
                                                    else{
                                                        ttml.ClaimedAmount = totalExp;
                                                    }
                                                }
                                            }
                                            if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                                ttml.AdjustedAmount = t.LodgingAmount;
                                            }
                                            else{
                                                Decimal tempExchangeRate = versionExchangeRateMap.get(partExchangeRate);
                                                if(tempExchangeRate != null){
                                                    ttml.AdjustedAmount = string.valueof((decimal.valueof(t.LodgingAmount) * tempExchangeRate).setscale(2));
                                                }
                                                else{
                                                    ttml.AdjustedAmount = t.LodgingAmount;
                                                }
                                            }
                                            claimed_Lodging_Meals += ttml.ClaimedAmount;
                                            Adjusted_Lodging_Meals += decimal.valueOf(ttml.AdjustedAmount);
                                        }
                                        else if(ttml.Type == 'Non-Commercial' && (t.LodgingAmount == '0' || t.LodgingAmount != '0')  && (t.MealsAmount == '0' ||t.MealsAmount != '0')){
                                            //Non Comm
                                            system.debug('Non Commercial-Travel' + t);
                                            POlist = TTMLAccountCodeMap.get(claimSubRec.Account_Code__c+'Non Commercial-Travel');
                                            system.debug('POlist POlist' + ' ' + POlist);
                                            ttml.Distance = t.Distance; //Siebel value
                                            ttml.Hours = t.Hours; //Siebel value
                                            ttml.AdjustmentReason = t.AdjustmentReason; //Siebel value
            /* Added below code as part of GSSC -145 */
                                                Decimal amountLodge = Decimal.valueof(t.LodgingAmount);
                                                Decimal AmountMeal = Decimal.valueof(t.MealsAmount);
                                                Decimal addLodgeMeals = amountLodge+AmountMeal;
                                                Decimal TravelCalculation = Decimal.valueof(t.TotalTravel) - addLodgeMeals;
                                                system.debug('Today addLodgeMeals>>' + addLodgeMeals);
                                                system.debug('Today TravelCalculation>>' + TravelCalculation);
                                                //ttml.AdjustedAmount = String.valueof(TravelCalculation);  //GSSC-138
                                                /* Added Above End code as part of GSSC -145 */
                                            Decimal totalExp = 0;
                                            Decimal totalHrs = 0;
                                            Decimal totalMileage = 0;
                                            system.debug('versionExchangeRateMap-->'+versionExchangeRateMap);
                                            if(POlist != null && POlist.size() > 0) {
                                                for(CSS_Parts_Options__c p1 : POlist) {
                                                    if(p1.ExpenseTotal__c != null){
                                                        totalExp = totalExp + p1.ExpenseTotal__c;
                                                    }
                                                    if(p1.HoursTravelled__c != null){
                                                        totalHrs = totalHrs + p1.HoursTravelled__c;
                                                    }
                                                    if(p1.Mileage__c != null){
                                                        totalMileage = totalMileage + p1.Mileage__c;
                                                    }
                                                }
                                                if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                                    ttml.ClaimedAmount = totalExp; //Guidanz value
                                                }
                                                else{
                                                    system.debug('inside else');
                                                    Decimal tempExchangeRate = versionExchangeRateMap.get(partExchangeRate);
                                                    if(tempExchangeRate != null){
                                                        ttml.ClaimedAmount = totalExp * tempExchangeRate; //Guidanz value
                                                    }
                                                    else{
                                                        ttml.ClaimedAmount = totalExp;
                                                    }
                                                    system.debug('inside else'+ttml.ClaimedAmount);
                                                }
                                                ttml.ClaimedMileage = Integer.valueof(totalMileage); //Guidanz value
                                                ttml.ClaimedHours = totalHrs; //Guidanz value
                                            }
                                            if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                                ttml.AdjustedAmount = String.valueof(TravelCalculation);
                                            }
                                            else{
                                                Decimal tempExchangeRate = versionExchangeRateMap.get(partExchangeRate);
                                                if(tempExchangeRate != null){
                                                    ttml.AdjustedAmount = string.valueof((TravelCalculation * tempExchangeRate).setscale(2));
                                                }
                                                else{
                                                    ttml.AdjustedAmount = string.valueof(TravelCalculation);
                                                }
                                            }
                                            Claimed_ttTotal_Hours += ttml.ClaimedHours;
                                            Adjusted_ttTotal_Hours += double.valueOf(t.hours);
                                            Claimed_Total_Mileage = ttml.ClaimedMileage;
                                            Adjusted_Total_Mileage = integer.valueOf(t.Distance);
                                            system.debug('ttml' + ttml);
                                        }

                                    }
                                    /*
                                        commented as part of story GSSC-145
                                        else{
                                            if(t.TravelType == 'Towing' && ttml.Type == 'Towing'){
                                                //Towing
                                                system.debug('Towing');
                                                POlist = TTMLAccountCodeMap.get(claimSubRec.Account_Code__c+'Towing');
                                                system.debug('POlist POlist' + ' ' + POlist);
                                                //ttml.Type = 'Towing';
                                                ttml.ClaimedMileage = 0;
                                                ttml.ClaimedHours = 0;
                                                ttml.Distance = '';
                                                ttml.Hours = '';
                                                ttml.AdjustmentReason = t.AdjustmentReason; //Siebel value
                                                ttml.AdjustedAmount = t.TotalTravel;    //recent changes  t.BaseFare; //Siebel valuet.BaseFare; //Siebel value
                                                Decimal totalExp = 0;
                                                if(POlist != null && POlist.size() > 0) {
                                                    for(CSS_Parts_Options__c p1 : POlist) {
                                                        if(p1.ExpenseTotal__c != null){
                                                            totalExp = totalExp + p1.ExpenseTotal__c;
                                                        }
                                                    }
                                                    ttml.ClaimedAmount = totalExp; //Guidanz value
                                                }
                                            }
                                        } */
                                }
                                //Added below as part of the task # 191794 - END
                                if((t.TravelType == 'Commercial' || t.TravelType == 'Non-Commercial') && t.PenaltyAppliedFlag == 'Y')
                                    ttml.PenaltyAppliedFlag = 'Y';
                                else
                                    ttml.PenaltyAppliedFlag = 'N';
                                //if(ttml.ClaimedMileage!=null)
                                //Claimed_Total_Mileage=Claimed_Total_Mileage+ttml.ClaimedMileage;

                                //if(ttml.Distance!=null && ttml.Distance!='')
                                //Adjusted_Total_Mileage=Adjusted_Total_Mileage+Integer.valueOf(ttml.Distance);  // Anvesh Changed to integer.valueOf() as part of defect 191640
                                //if(ttml.ClaimedHours!=null)
                                //Claimed_ttTotal_Hours=Claimed_ttTotal_Hours+ttml.ClaimedHours;
                                //if(ttml.Hours!=null && ttml.Hours != '')
                                //Adjusted_ttTotal_Hours=Adjusted_ttTotal_Hours+Double.valueOf(ttml.Hours); //Anvesh Changed to Double.valueOf() as part of defect 191640
                                //if(ttml.ClaimedLodgingMealsAmount!=null)
                                //claimed_Lodging_Meals=claimed_Lodging_Meals+ttml.ClaimedLodgingMealsAmount;
                                //if(ttml.LodgingAmount!=null && ttml.LodgingAmount!='')
                                //Adjusted_Lodging_Meals=Adjusted_Lodging_Meals+Decimal.valueOf(ttml.LodgingAmount); //Anvesh Changed to Decimal.valueOf() as part of defect 191640
                                //if(ttml.MealsAmount!=null && ttml.MealsAmount!='')
                                //Adjusted_Lodging_Meals=Adjusted_Lodging_Meals+Decimal.valueOf(ttml.MealsAmount); //Anvesh Changed to Decimal.valueOf() as part of defect 191640
                            }
                            system.debug('ttml--->'+ttml);
                            lstclaimDetailTravelwrapper.add(ttml); 
                        }

                    }
                }
            }
        }
    }


    public String SiebelMake{get;set;}
    public String SiebelModel{get;set;}
    public string VIN {get;set;}
    public string unitNumber{get;set;}
    public string Mileage{get;set;}
    public string productHours{get;set;}
    public string failureMeasure{get;set;}
    public void CallGetClaimDetails() {
        TotalAdjustedHours = 0.0;
        TotalClaimedHours = 0.0;
        Claimed_Total_Mileage = 0;
        Adjusted_Total_Mileage = 0;
        Claimed_ttTotal_Hours = 0.0;
        Adjusted_ttTotal_Hours = 0.0;
        claimed_Lodging_Meals = 0.0;
        Adjusted_Lodging_Meals = 0.0; 
        lstclaimDetailPartswrapper =new List<claimDetailPartswrapper>();
        lstclaimDetailSRTswrapper=new List<claimDetailSRTswrapper>();
        lstclaimDetailOtherClaimableswrapper= new List<claimDetailOtherClaimableswrapper> ();
        lstclaimDetailTravelwrapper=new  List<claimDetailTravelwrapper> ();
        lstofAdditionalESNs = new List<MultiPSNWrapper>();
        lstclaimDetailExternalNotesWrapper =new List<claimDetailExternalNotesWrapper>();
        siebel3cExternalNotesWrapper=new List<claimDetailExternalNotesWrapper>();
        List<claimDetailExternalNotesWrapper> claimDetailExternalNotesWrapperlist = new List<claimDetailExternalNotesWrapper>();
        //List<Date> cdate= new List<Date>();
        List<String> cdatelist= new List<String>();
        set<String> cdate= new set<String>();
        CSS_GetClaimDetailsResponse cresWrap = new CSS_GetClaimDetailsResponse();
        CSS_GetClaimDetailsRequest  csubmitReq =new CSS_GetClaimDetailsRequest ();
        CSS_GetClaimDetailsRequest.Header cheaderobj = new  CSS_GetClaimDetailsRequest.Header();
        CSS_GetClaimDetailsRequest.Sender cSenderobj = new  CSS_GetClaimDetailsRequest.Sender();
        CSS_GetClaimDetailsRequest.Target  cTargetobj = new  CSS_GetClaimDetailsRequest.Target ();
        cSenderobj.ServiceName='getClaimsDetails';
        cSenderobj.SenderID='CSS';
        cTargetobj.TargetID='SIEBEL';
        cheaderobj.Sender=cSenderobj;
        cheaderobj.Target=cTargetobj;

        CSS_GetClaimDetailsRequest.DataArea  cDataAreaobj  = new  CSS_GetClaimDetailsRequest.DataArea ();
        cDataAreaobj.SiebelClaimNumber=claimsRec.SiebelClaimNumber__c;
        CSS_GetClaimDetailsResponse.DataArea  cresDataAreaobj = new CSS_GetClaimDetailsResponse.DataArea();

        csubmitReq.Header =cHeaderobj;
        csubmitReq.DataArea =cDataAreaobj;
        String message;
        String endPointURL;
        HttpResponse res1;
        //getting Access Token 
        String accessToken = CSS_WS_OAG.getAccessToken();
        system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+accessToken);
        system.debug('SBL$$$$$$$$@@@@@@@@@@:::'+csubmitReq);
        try
        {
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();

            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken))
            {
                system.debug('inside accessToken');
            }
            CSS_Integration_Details__c connection = new CSS_Integration_Details__c ();
            connection = CSS_getConnnectionDetails.getConnection('CSS_SBL_GetClaimDetails');
            if(connection != null && !Test.isRunningTest()){
                endPointURL = connection.End_Point__c;                
            }
            else{
                endPointURL = 'https://services-dev.cummins.com/csswarranty/getsiebelclaimdetails/'; 
            }

            req1.setHeader('Authorization','Bearer '+accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setMethod('POST');
            //req1.setTimeout(Integer.valueof(connection.Timeout__c));
            req1.setTimeout(120000);
            req1.setEndpoint(endPointURL);

            String reqWrpperInput = JSON.serialize(csubmitReq);
            req1.setBody(reqWrpperInput);              
            System.debug('req1.getBody======'+req1.getBody());
            String jsonResponseBody;
            res1 = h1.send(req1);

            jsonResponseBody=res1.getBody();
            system.debug('res1............'+res1);
            system.debug('Response Body >>>'+res1.getbody());
            //jsonResponseBody = '{"DataArea":[{"DistributorCode":"03525","ECMRevBfr":"","FailureList":[{"FaultCode":"","FailMode":"BR","Failurename":"TURBOCHARGER ASSEMBLY","PayCode":"D","CampaignNumber":"","SRTList":[{"SRTCode":"00-400-00","ClaimedPercent":100,"ClaimedHours":0,"AdjustedPercent":100,"AdjustedQty":1,"AdjustedHours":0.2,"SRTHours":0.2,"AdjustmentReason":"","SRTDescription":"Steam Clean - Single Component Repair","ClaimedQty":0,"PenaltyAppliedFlag":"N"},{"SRTCode":"10-043-00","ClaimedPercent":100,"ClaimedHours":0,"AdjustedPercent":100,"AdjustedQty":1,"AdjustedHours":2.7,"SRTHours":2.7,"AdjustmentReason":"","SRTDescription":"Turbocharger Assembly Variable Geometry, Remove and Install (CM871/CM2250/2350)","ClaimedQty":0,"PenaltyAppliedFlag":"N"}],"SystemCode":"TH","ComponentCode":"AS","AccountCode":67,"TravelList":[{"PenaltyAppliedFlag":"N"}]}],"ClaimSource":"Factory","ComplaintCodes":[{"ComplaintCode":101,"ComplaintText":"COOLANT LEAK EXTERNAL"}],"ECMRevAfter":"","DISDNumber":"","ServiceProviderCode":24555,"Manufacturer":"UNLISTED","BISFlag":"N","ClaimFiledDate":"07/31/2019 10:11:02","ModelSeries":"ALL","FailurePoint":3200,"CustomerName":"","FailureDate":"07/31/2019","EngineVIN":"1XKYA48X4GJ479251","DistributorName":"CENTRAL - WHITE BEAR LAKE","PSN":79812345,"TSRNumber":"","Contact":"Dale Mahnke","ECMCalibAfter":"","WorkOrderNumber":1244,"UnitNumber":"","ECMCalibBefore":"","FailureMeasure":"Miles","WarrantyStartDate":"07/01/2019 00:00:00","EngineApplicationCode":130,"DealerClaimNumber":""}],"Header":{"Status":"Success","ReturnCode":"","ReturnCodeDescription":"SUCCESS","MessageIdentifier":"1-2074647213"}}';
            cresWrap = (CSS_GetClaimDetailsResponse)JSON.deserialize(jsonResponseBody,CSS_GetClaimDetailsResponse.class);
            System.debug('Status Code >>> :: '+res1.getStatusCode());
            System.debug('REST response is :: '+res1);
            system.debug('Response Body >>>'+res1.getbody());
            system.debug('cresWrap >>>'+cresWrap);
        }
        catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                message = ex.getMessage();


            }
        }
        system.debug('cresWrap >>>'+cresWrap);
        if(cresWrap!=null && cresWrap.Header!=null){
            if(cresWrap.Header.Status=='Success'){
                if(cresWrap.DataArea!=null){
                    for(CSS_GetClaimDetailsResponse.DataArea d: cresWrap.DataArea){
                        DistributorName=d.DistributorName;
                        Service_Model = d.ServiceModel;    //Added by Krishna @ GSSC:#65
                        Application = d.EngineApplicationDescription; //Added by Krishna @ GSSC:#65
                        //DistributorName='Test Distibutor';
                        system.debug('Distributor Name' +DistributorName);
                        DistributorCode=d.DistributorCode;
                        SiebelMake = d.Manufacturer;
                        SiebelModel = d.ModelSeries;
                        VIN = d.EngineVIN;
                        unitNumber = d.UnitNumber;
                        failureMeasure = d.FailureMeasure;
                        if(d.FailureMeasure.containsIgnoreCase('Hours')){
                            productHours = String.valueOf(d.FailurePoint);
                        }else{
                            Mileage = String.valueOf(d.FailurePoint);
                        }
                        if(d.FailureList!=null && d.FailureList.size()>0){
                            for(CSS_GetClaimDetailsResponse.FailureList  Frec : d.FailureList){
                                if(Frec.PartsList!=null){
                                    for(CSS_GetClaimDetailsResponse.PartsList  Prec : Frec.PartsList){
                                        /*** Assigning Parts response to parts wrapper*****/
                                        claimDetailPartswrapper parts =new claimDetailPartswrapper();
                                        parts.PartNumber = Prec.PartNumber;
                                        parts.PartDescription = Prec.PartDescription;
                                        parts.ClaimedQuantity=Prec.ClaimedQty; 
                                        parts.ClaimedPercentage = Prec.PartsPercentage; //Added by Krishna @ GSSC:#65
                                        parts.AdjustmentPartsPercent = Prec.AdjustedPercentage; //Added by Krishna @ GSSC:#65
                                        parts.PartQty= Prec.AdjustedQty;
                                        parts.EPRTracking=Prec.TrackingNumber;
                                        parts.ReturnID=Prec.RID;
                                        parts.AdjustmentReason=Prec.AdjustmentReason;

                                        lstclaimDetailPartswrapper.add(parts);
                                        /***/
                                    }
                                }
                                /*** Assigning OC response to OtherClaimable wrapper*****/
                                if(Frec.OtherClaimablesList != null){
                                    for(CSS_GetClaimDetailsResponse.OtherClaimablesList  OCrec : Frec.OtherClaimablesList){
                                        /*****/
                                        claimDetailOtherClaimableswrapper oc =new claimDetailOtherClaimableswrapper();

                                        oc.Item = OCrec.Item;
                                        oc.Description = OCrec.ItemDescription;
                                        if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                            oc.ClaimedItemAmount = OCrec.ClaimedAmount;
                                            oc.ApprovedAmount= string.valueof(decimal.valueof(OCrec.AdjustedAmount).setscale(2));
                                        }
                                        else{
                                            Decimal tempExchangeRate = versionExchangeRateMap.get(partExchangeRate);
                                            oc.ClaimedItemAmount = string.valueof((decimal.valueof(OCrec.ClaimedAmount) * tempExchangeRate).setscale(2));
                                            oc.ApprovedAmount = string.valueof((decimal.valueof(OCrec.AdjustedAmount) * tempExchangeRate).setscale(2));
                                        }
                                        oc.AdjustmentReason=OCrec.AdjustmentReason;
                                        lstclaimDetailOtherClaimableswrapper.add(oc);

                                    }
                                }
                                /***/
                                /**** Assigning TTML Response to TTML Wrapper****/
                                if(Frec.TravelList != null){
                                    for(CSS_GetClaimDetailsResponse.TravelList  TravelRec : Frec.TravelList){
                                        claimDetailTravelwrapper ttml =new claimDetailTravelwrapper();
                                        system.debug('TravelRec.TravelType' +TravelRec.TravelType);
                                        if(TravelRec.TravelType == 'Towing'){
                                            ttml.Type = TravelRec.TravelType;
                                            //ttml.ClaimedMileage = '';
                                            //ttml.ClaimedHours = '';
                                            //ttml.ClaimedAmount = '';
                                            //ttml.Distance = '';//AdjustedMileage
                                            //ttml.Hours = '';//Adjusted Hours
                                            if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                                ttml.AdjustedAmount = TravelRec.AdjustedAmount;//Adjusted Amount
                                            }
                                            else{
                                                Decimal tempExchangeRate = versionExchangeRateMap.get(partExchangeRate);
                                                ttml.AdjustedAmount = string.valueof((decimal.valueof(TravelRec.AdjustedAmount) * tempExchangeRate).setscale(2));
                                            }
                                            ttml.AdjustmentReason = TravelRec.AdjustmentReason;
                                            ttml.PenaltyAppliedFlag = TravelRec.PenaltyAppliedFlag;
                                        }else if(TravelRec.TravelType == 'Non-Commercial'){
                                            ttml.Type = TravelRec.TravelType;
                                            //ttml.ClaimedMileage = '';
                                            //ttml.ClaimedHours = '';
                                            //ttml.ClaimedAmount = '';
                                            ttml.Distance = TravelRec.AdjustedDistance;//AdjustedMileage // Anvesh Removed Integer.valueOf() as part of the defect # 191640
                                            ttml.Hours = TravelRec.AdjustedHours;//Adjusted Hours // Anvesh Removed Integer.valueOf() as part of the defect # 191640
                                            if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                                ttml.AdjustedAmount = TravelRec.AdjustedAmount;//Adjusted Amount
                                            }
                                            else{
                                                Decimal tempExchangeRate = versionExchangeRateMap.get(partExchangeRate);
                                                ttml.AdjustedAmount = string.valueof((decimal.valueof(TravelRec.AdjustedAmount) * tempExchangeRate).setscale(2));
                                            }
                                            ttml.AdjustmentReason = TravelRec.AdjustmentReason;
                                            ttml.PenaltyAppliedFlag = TravelRec.PenaltyAppliedFlag;
                                        }else if(TravelRec.MealsAmount != null && TravelRec.MealsAmount != '' && Integer.valueOf(TravelRec.MealsAmount) > 0){
                                            ttml.Type = 'Meals';
                                            if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                                ttml.AdjustedAmount = TravelRec.MealsAmount;
                                            }
                                            else{
                                                Decimal tempExchangeRate = versionExchangeRateMap.get(partExchangeRate);
                                                ttml.AdjustedAmount = string.valueof((decimal.valueof(TravelRec.MealsAmount) * tempExchangeRate).setscale(2));
                                            }
                                            ttml.AdjustmentReason = TravelRec.AdjustmentReason;
                                            ttml.PenaltyAppliedFlag = TravelRec.PenaltyAppliedFlag;
                                        }else if(TravelRec.LodgingAmount != null && TravelRec.LodgingAmount != '' && Integer.valueOf(TravelRec.LodgingAmount) > 0){
                                            ttml.Type = 'Lodging';
                                            if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                                ttml.AdjustedAmount = TravelRec.LodgingAmount;
                                            }
                                            else{
                                                Decimal tempExchangeRate = versionExchangeRateMap.get(partExchangeRate);
                                                ttml.AdjustedAmount = string.valueof((decimal.valueof(TravelRec.LodgingAmount) * tempExchangeRate).setscale(2));
                                            }
                                            ttml.AdjustmentReason = TravelRec.AdjustmentReason;
                                            ttml.PenaltyAppliedFlag = TravelRec.PenaltyAppliedFlag;
                                        }else{
                                            ttml.Type = 'Commercial';
                                            if(userinfo.getDefaultCurrency() == 'USD' || isDealer == false){
                                                ttml.AdjustedAmount = TravelRec.BaseFare;
                                            }
                                            else{
                                                Decimal tempExchangeRate = versionExchangeRateMap.get(partExchangeRate);
                                                ttml.AdjustedAmount = string.valueof((decimal.valueof(TravelRec.BaseFare) * tempExchangeRate).setscale(2));
                                            }
                                            ttml.AdjustmentReason = TravelRec.AdjustmentReason;
                                            ttml.PenaltyAppliedFlag = TravelRec.PenaltyAppliedFlag;
                                        }
                                        lstclaimDetailTravelwrapper.add(ttml);
                                    }
                                }
                                /****/
                                if(Frec.SRTList!=null){
                                    for(CSS_GetClaimDetailsResponse.SRTList  SRTrec : Frec.SRTList){
                                        /*** Assigning SRT response to SRT wrapper*****/
                                        claimDetailSRTswrapper srt =new claimDetailSRTswrapper();
                                        srt.SRTCode=SRTrec.SRTCode; 
                                        srt.SRTHours=SRTrec.SRTHours;
                                        srt.ClaimedQuantity=String.ValueOf(SRTrec.ClaimedQty);
                                        srt.Claimedper=String.valueof(SRTrec.ClaimedPercent);
                                        srt.ClaimedHours = SRTrec.ClaimedHours;
                                        TotalClaimedHours = TotalClaimedHours + SRTrec.ClaimedHours;
                                        srt.SRTQty=SRTrec.AdjustedQty;//May be adjusted quantity
                                        srt.PercentageAdjustment=SRTrec.AdjustedPercent;
                                        srt.AdjustedHours = SRTrec.AdjustedHours;
                                        TotalAdjustedHours = TotalAdjustedHours + SRTrec.AdjustedHours;
                                        srt.AdjustmentReason=SRTrec.AdjustmentReason;
                                        srt.PenaltyAppliedFlag=SRTrec.PenaltyAppliedFlag;

                                        lstclaimDetailSRTswrapper.add(srt);
                                        /***/
                                    }
                                }

                            }
                        }
                        if(d.Notes!=null){
                            for(CSS_GetClaimDetailsResponse.Notes  n : d.Notes){
                                claimDetailExternalNotesWrapper parts =new claimDetailExternalNotesWrapper();
                                parts.Note=n.Note;
                                parts.NoteType=n.NoteType;
                                parts.CreatedDate=n.CreatedDate;


                                if(parts.NoteType!=null && (parts.NoteType=='Correction' || parts.NoteType=='Cause' || parts.NoteType=='Complaint' ))
                                    siebel3cExternalNotesWrapper.add(parts);
                                else{
                                    cdate.add(parts.CreatedDate);
                                    claimDetailExternalNotesWrapperlist.add(parts);
                                }
                            }}

                        system.debug('d.AdditionalESNs******8888'+d.AdditionalESNs);
                        if(d.AdditionalESNs!=null && d.AdditionalESNs.size()>1){
                            integer i=1;
                            for(CSS_GetClaimDetailsResponse.AdditionalESNs  MPSN : d.AdditionalESNs){
                                MultiPSNWrapper ESN = new MultiPSNWrapper();
                                ESN.counting = i;
                                ESN.PSN = MPSN.PSN;
                                ESN.WSD = string.valueof(MPSN.WarrantyStartDate);
                                if(MPSN.BISFlag == 'Y')
                                    ESN.BIS = true;
                                else   
                                    ESN.BIS = false;

                                ESN.failurePoint = string.valueOf(MPSN.FailurePoint) + ' ' + MPSN.FailureMeasure;
                                ESN.VIN = MPSN.VIN;
                                ESN.calibrationAfter = MPSN.ECMCalibAfter;
                                ESN.calibrationBefore = MPSN.ECMCalibBefore;
                                ESN.revisionBefore = MPSN.ECMRevBfr;
                                ESN.revisionAfter = MPSN.ECMRevAfter;
                                lstofAdditionalESNs.add(ESN);
                                i++;
                                system.debug('lstofAdditionalESNs>>>>>>>' + lstofAdditionalESNs);

                            }
                        }
                    }
                }
            }
        }
        if(cdate.size()>0)
            cdatelist.addAll(cdate);
        if(cdatelist.size()>0)
            cdatelist.sort();
        Integer sortvar =cdatelist.size();
        System.debug('cdate: ' + ' ' + cdatelist);
        if(claimDetailExternalNotesWrapperlist.size()>0){
            for(claimDetailExternalNotesWrapper h : claimDetailExternalNotesWrapperlist){
                for(Integer i = sortvar- 1; i >= 0 ; i--){
                    if(cdatelist[i] == h.CreatedDate){
                        lstclaimDetailExternalNotesWrapper.add(h);
                    }
                }
            }}
        System.debug('lstclaimDetailExternalNotesWrapper: '+lstclaimDetailExternalNotesWrapper);
    }
    public PageReference generatePDF(){
        System.debug('generating: ');

        Id subid = ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = new PageReference('/apex/CG_PDFClaimsViewPaymentDetails');
        pageRef.getParameters().put('id',subid);
        //pageRef.setRedirect(false);
        System.debug('pageRef: ' + ' ' + pageRef);
        try {
            //pageRef.getParameters().put('p','p');
            System.debug('pageRef: ' + ' ' + pageRef);
            return pageRef;
        }
        catch (Exception e) {
            system.debug('EXCEPTION of generatePDF >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            return pageRef;
        }  
    }
    public String getChooserender() {
        if (ApexPages.currentPage().getParameters().get('p') != null)
            return 'pdf';
        else
            return null;
    }

    public class claimDetailExternalNotesWrapper{
        public String Note{get;set;}
        public String NoteType{get;set;}
        public String CreatedDate{get;set;}
        public claimDetailExternalNotesWrapper(){}
    }

    public class claimDetailSRTswrapper{
        public Double SRTHours{get;set;}
        public Integer SRTQty{get;set;}
        public Integer PercentageAdjustment{get;set;}
        public string AdjustmentReason{get;set;}
        public string AccessCode{get;set;}
        public string SRTCode{get;set;}
        public string Hours {get;set;}
        public string ClaimedQuantity {get;set;}  
        public Decimal ClaimedHours{get;set;}
        public Decimal AdjustedHours {get;set;}
        public string Claimedper {get;set;}
        public String PenaltyAppliedFlag{get;set;}
        public claimDetailSRTswrapper(){}
    }

    public class claimDetailOtherClaimableswrapper{
        public string Item{get;set;}
        public string Description{get;set;}
        public string ApprovedAmount{get;set;}
        public string AdjustmentReason{get;set;}
        public string ClaimedItemAmount{get;set;}
        public claimDetailOtherClaimableswrapper(){}
    }

    public class claimDetailPartswrapper{
        public String AdjustmentPartsPercent{get;set;}//191640
        public String PartQty{get;set;}
        public string PartNumber{get;set;}
        public string AdjustmentReason{get;set;}
        public string PartDescription {get;set;}
        public string ClaimedQuantity {get;set;}
        public string EPRTracking  {get;set;}
        public string ReturnID  {get;set;}
        public string ClaimedPercentage {get;set;}
        public claimDetailPartswrapper(){}
    }

    public class claimDetailTravelwrapper{
        public string Type{get;set;}
        public string TravelType{get;set;}
        public string AdjustmentReason{get;set;}        
        public integer AdjustedBaseFare { get; set; }   //Added by Krishna @ GSSC:#65
        public integer AdjustedMeals { get; set; }      //Added by Krishna @ GSSC:#65
        public integer AdjustedTowing { get; set; }     //Added by Krishna @ GSSC:#65
        public integer AdjustedLodging { get; set; }    //Added by Krishna @ GSSC:#65    
        // public Integer Distance{get;set;}
        public String Distance{get;set;} // Anvesh Changed from Integer to String  as part of the defect # 191640
        // public Double Hours{get;set;}
        public String Hours{get;set;} // Anvesh Changed from Integer to String  as part of the defect # 191640
        //  public Decimal LodgingAmount{get;set;}
        public String LodgingAmount{get;set;} // Anvesh Changed from Decimal to String  as part of the defect # 191640
        // public Decimal MealsAmount{get;set;}
        public String MealsAmount{get;set;} // Anvesh Changed from Decimal to String  as part of the defect # 191640
        // public Integer TowingDetails{get;set;}
        public String TowingDetails{get;set;} // Anvesh Changed from Integer to String  as part of the defect # 191640
        //public Integer ClaimedAmount{get;set;}
        public Decimal ClaimedAmount{get;set;}
        public Decimal ClaimedLodgingMealsAmount{get;set;}
        public Integer ClaimedMileage{get;set;}
        public Double ClaimedHours{get;set;}
        //  public Integer TotalTravel{get;set;}
        public String TotalTravel{get;set;} // Anvesh Changed from Integer to String  as part of the defect # 191640
        public String BaseFare{get;set;}// Anvesh Changed from Integer to String  as part of the defect # 191640
        public String TravelAdjustedPercentage{get;set;}// Anvesh Changed from Integer to String  as part of the defect # 191640
        public String PenaltyAppliedFlag{get;set;}
        public string AdjustedAmount{get;set;}
        public claimDetailTravelwrapper(){}
    }

    public class ClaimsubmissionNotes {
        public string Notes{get;set;}
        public string AdjudicatorName{get;set;}
        public string Notestime{get;set;}
        public ClaimsubmissionNotes(){}
    }

    public class MultiPSNWrapper{
        public Integer counting {get;set;}
        public Id ids {get;set;}
        public String PSN {get;set;}
        public String failurePoint {get;set;}
        public String WSD {get;set;}
        public Boolean BIS {get;set;}
        public String VIN {get;set;}
        public String calibrationBefore {get;set;}
        public String revisionBefore {get;set;}
        public String calibrationAfter {get;set;}
        public String revisionAfter {get;set;}

        public MultiPSNWrapper() {
        }        
    }

}