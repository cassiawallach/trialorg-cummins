/*
* Block comments with details of changes
*/
public class CG_CL_GetClaimDetails
{
    public Id cSId{get;set;}
    //public CSS_Claim_Submission__c claimSubRec {set;get;}
    public CSS_Claims__c claimsRec {set;get;}
    //public String LocationCode {get;set;}
    public String WarrantyStartDate {get;set;}
    public String FailureDate {get;set;}
    public List<claimDetailSRTswrapper> lstclaimDetailSRTswrapper {set;get;}
    public List<claimDetailOtherClaimableswrapper> lstclaimDetailOtherClaimableswrapper {set;get;}
    public List<claimDetailPartswrapper> lstclaimDetailPartswrapper {set;get;}
    public List<claimDetailTravelwrapper> lstclaimDetailTravelwrapper {set;get;}
    public List<ClaimsubmissionNotes> lstClaimsubmissionNotes {set;get;}
    public List<claimDetailExternalNotesWrapper>lstclaimDetailExternalNotesWrapper {set;get;}
    public List<claimDetailExternalNotesWrapper>siebel3cExternalNotesWrapper {set;get;}
    public Boolean isDealer {get;set;}
    public string currDate  {get;set;}
    public double claimed_Total_Hours{get;set;}
    public double Adjusted_Total_Hours{get;set;}
   // public Integer Claimed_Total_Mileage{get;set;}
    public string Claimed_Total_Mileage{get;set;}
   // public Integer  Adjusted_Total_Mileage{get;set;}
    public string  Adjusted_Total_Mileage{get;set;}
    public double Claimed_ttTotal_Hours{get;set;}
   // public double Adjusted_ttTotal_Hours{get;set;}
    public string Adjusted_ttTotal_Hours{get;set;}
   // public Integer claimed_Lodging_Meals{get;set;}
    public string claimed_Lodging_Meals{get;set;}
   // public Decimal Adjusted_Lodging_Meals{get;set;}
    public string Adjusted_Lodging_Meals{get;set;}
    public String ServiceProviderCode {get;set;}
    public String DistributorCode {get;set;}
    public String DistributorName {get;set;}
    public String PSN {get;set;}
    public String WorkOrderNumber {get;set;}
    public String EngineApplicationCode {get;set;}
    public String Manufacturer {get;set;}
    public String ModelSeries {get;set;}
    public Integer FailurePoint {get;set;}
    public String FailureMeasure {get;set;}
    public String CustomerName {get;set;}
    public String EngineVIN {get;set;}
    public String UnitNumber {get;set;}
    public String DealerClaimNumber {get;set;}
    public String ClaimSource {get;set;}
    public Date ClaimFiledDate {get;set;}
    public String WarrantyStartDates {get;set;}
    public String FailureDates {get;set;}
    public String AccountCode {get;set;}
    public String SiebelClaimNumber {get;set;}
    public String IMSClaimNumber {get;set;}
    public String PayCode {get;set;}
    public String ClaimStatus {get;set;}
    public String RejectionReason {get;set;}
    public String Type {get;set;}
    public String StatementNumber {get;set;}
    public String CreditDate {get;set;}
    public String CreditNumber {get;set;}
    public decimal Parts {get;set;}
    public decimal Labor {get;set;}
    public decimal Travel {get;set;}
    public decimal Other {get;set;}
    public decimal Tax {get;set;}
    public decimal PMU {get;set;}
    public decimal BFC {get;set;}
    public decimal Deductible {get;set;}
    public decimal TotalPaid {get;set;}
    public Boolean enableMultiPSNsection {get;set;}
    public CG_CL_GetClaimDetails()
    {
        try {
            CSS_Claims__c lstclaimsRec = new CSS_Claims__c();
            cSId=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('MyClaimRecordId**'+cSId);
            string userType = css_Utility.getOrgType(userinfo.getUserId());
            claimed_Total_Hours=0.0;
            Adjusted_Total_Hours=0.0;
            Claimed_Total_Mileage='0';
            Adjusted_Total_Mileage='0';
            Claimed_ttTotal_Hours=0.0;
            Adjusted_ttTotal_Hours='0.0';
            claimed_Lodging_Meals='0';
            Adjusted_Lodging_Meals='0';
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
                claimsRec= new CSS_Claims__c();
            } 
            else{
                fetchClaimSubmissionRecords();
                CallGetClaimDetails();
                CallgetPaymentDetails();
            }

        }

        catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsViewPaymentDetails constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }

    }

    public void fetchClaimSubmissionRecords() {
        //String CreatorLocation;
        //claimSubRec=[Select id,Name,Account_Code__c,CreatedBy.name,Status__c,Individual_Claim_Id__c,CSS_Claims__c,Siebel_Claim_Number__c,BFC__c,Claim_Number__c,Credit_Date__c,Credit_Number__c,Deductible__c,IMS_Claim_Number__c,Labor__c,Other__c,Parts__c,PayCode__c,PMU__c,Rejection_Reason__c,Statement_Number__c,Tax__c,Total_Paid__c,Travel__c,Type__c from CSS_Claim_Submission__c where id= :cSId];
        // if(claimSubRec.CSS_Claims__c!=null){
        claimsRec=[Select id,Customer_Name__c,CSS_Job__c,SiebelClaimNumber__c,Location__c,Location_Code__c,Account__c,Account__r.RSS_RESP_BRANCH_NAME__c,Account__r.RSS_RESP_BRANCH_CODE__c,Actual_Technician_Time__c,CSS_Job__r.Name,Shop_Work_Order__c,JobEditCause__c,JobEditComplaint__c,JobEditCorrection__c,EditComplaint__c,Claims_General_Symptoms__c,EditCause__c,EditCorrection__c,(Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                                                                                                                   Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,Unit_Type__c,
                                                                                                                   Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1)  from CSS_Claims__c where id= :cSId];
        // }



        //Populate LocationCode
        /*if(claimsRec != null && claimsRec.Id != null) 
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
        }*/

    }


    public void CallGetClaimDetails() {
        lstclaimDetailPartswrapper =new List<claimDetailPartswrapper>();
        lstclaimDetailSRTswrapper=new List<claimDetailSRTswrapper>();
        lstclaimDetailOtherClaimableswrapper= new List<claimDetailOtherClaimableswrapper> ();
        lstclaimDetailTravelwrapper=new  List<claimDetailTravelwrapper> ();      
        lstclaimDetailExternalNotesWrapper =new List<claimDetailExternalNotesWrapper>();
        siebel3cExternalNotesWrapper=new List<claimDetailExternalNotesWrapper>();
        List<claimDetailExternalNotesWrapper> claimDetailExternalNotesWrapperlist = new List<claimDetailExternalNotesWrapper>();
        //List<Date> cdate= new List<Date>();
        List<String> cdatelist= new List<String>();
        set<String> cdate= new set<String>();
        CSS_GetClaimDetailsResponse cresWrap = new CSS_GetClaimDetailsResponse();

        //String jsonResponseBody = '{"Header":{"ReturnCodeDescription":"<Message from Siebel>","Status":"Success","ReturnCode":"<MessageCode from Siebel>","MessageIdentifier":"<Identifier from MW>"},"DataArea":[{"ServiceProviderCode":"34234","DistributorCode":"42333","DistributorName":"Cummins Distributor Name","PSN":"2342335","WorkOrderNumber":"ABC45233","WarrantyStartDate":"2012-06-06","EngineApplicationCode":"130","Manufacturer":"KENWORTH","ModelSeries":"T300","Contact":"FirstName LastName","BISFlag":"N","FailureDate":"2012-06-06","FailurePoint":2323,"FailureMeasure":"Miles","DISDNumber":"23423","CustomerName":"ABZ Tavels","EngineVIN":"234msdflo303jfp3ed","TSRNumber":"234434","UnitNumber":"D234","DealerClaimNumber":"C453453245","ClaimSource":"MX","ClaimFiledDate":"2017-06-06","ECMCalibAfter":"23423","ECMCalibBefore":"234234","ECMRevBfr":"34234","ECMRevAfter":"23423","FailureList":[{"SystemCode":"BS","ComponentCode":"HS","FailMode":"BR","Failurename":"Turbo Charger","CampaignNumber":"C24523","FaultCode":"125","AccountCode":"67","PayCode":"I","PartsList":[{"PartNumber":"345345","PartDescription":"PartName1","ClaimedQty":"2","AdjustedQty":"1","TrackingNumber":"23456232346","RID":"34234","AdjustmentReason":"Quantity used as not covered"},{"PartNumber":"77886","PartDescription":"PartName2","ClaimedQty":"1","AdjustedQty":"1","TrackingNumber":"3245345345","RID":"34534","AdjustmentReason":"ReasonDescription"}],"OtherClaimablesList":[{"Item":"abc1","ItemDescription":"abc2","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":"abc1233"},{"Item":"abc3","ItemDescription":"abc4","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":"abc5"}],"SRTList":[{"SRTCode":"abc6","SRTDescription":"abc7","SRTHours":3,"ClaimedQty":4,"ClaimedPercent":5,"ClaimedHours":6,"AdjustedQty":7,"AdjustedPercent":8,"AdjustedHours":9,"AdjustmentReason":"abc8","PenaltyAppliedFlag":"abc9"},{"SRTCode":"abc10","SRTDescription":"abc11","SRTHours":3,"ClaimedQty":4,"ClaimedPercent":5,"ClaimedHours":6,"AdjustedQty":7,"AdjustedPercent":8,"AdjustedHours":9,"AdjustmentReason":"abc12","PenaltyAppliedFlag":"abc13"}],"TravelList":[{"TravelType":"Commercial","ClaimedDistance":10,"ClaimedHours":6,"ClaimedAmount":1,"AdjustedDistance":123,"AdjustedHours":9,"AdjustedAmount":2,"LodgingAmount":11,"MealsAmount":12,"TowingAmount":13,"LaborAmount":14,"TravelAmount":15,"TotalTravel":16,"BaseFare":18,"AdjustmentReason":"abc16","PenaltyAppliedFlag":"abc15","AdjustedPercent":8},{"TravelType":"Towing","ClaimedDistance":10,"ClaimedHours":6,"ClaimedAmount":1,"AdjustedDistance":123,"AdjustedHours":9,"AdjustedAmount":2,"LodgingAmount":11,"MealsAmount":12,"TowingAmount":13,"LaborAmount":14,"TravelAmount":15,"TotalTravel":16,"BaseFare":18,"AdjustmentReason":"abc18","PenaltyAppliedFlag":"abc19","AdjustedPercent":8}]},{"SystemCode":"CR","ComponentCode":"JH","FailMode":"UH","Failurename":"Aftermarket assembly","CampaignNumber":"C86666","FaultCode":"563","AccountCode":"51","PayCode":"D","PartsList":[{"PartNumber":"abc","PartDescription":"abc","ClaimedQty":4,"AdjustedQty":7,"TrackingNumber":"abc","RID":"abc","AdjustmentReason":"abc"},{"PartNumber":"abc","PartDescription":"abc","ClaimedQty":4,"AdjustedQty":7,"TrackingNumber":"abc","RID":"abc","AdjustmentReason":"abc"}],"OtherClaimablesList":[{"Item":"abc","ItemDescription":"abc","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":"abc"},{"Item":"abc","ItemDescription":"abc","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":"abc"}],"SRTList":[{"SRTCode":"abc","SRTDescription":"abc","SRTHours":3,"ClaimedQty":4,"ClaimedPercent":5,"ClaimedHours":6,"AdjustedQty":7,"AdjustedPercent":8,"AdjustedHours":9,"AdjustmentReason":"abc","PenaltyAppliedFlag":"abc"},{"SRTCode":"abc","SRTDescription":"abc","SRTHours":3,"ClaimedQty":4,"ClaimedPercent":5,"ClaimedHours":6,"AdjustedQty":7,"AdjustedPercent":8,"AdjustedHours":9,"AdjustmentReason":"abc","PenaltyAppliedFlag":"abc"}],"TravelList":[{"TravelType":"Lodging","ClaimedDistance":10,"ClaimedHours":6,"ClaimedAmount":1,"AdjustedDistance":123,"AdjustedHours":9,"AdjustedAmount":2,"LodgingAmount":11,"MealsAmount":12,"TowingAmount":13,"LaborAmount":14,"TravelAmount":15,"TotalTravel":16,"BaseFare":18,"AdjustmentReason":"abc","PenaltyAppliedFlag":"abc","AdjustedPercent":8},{"TravelType":"Non-Commercial","ClaimedDistance":10,"ClaimedHours":6,"ClaimedAmount":1,"AdjustedDistance":123,"AdjustedHours":9,"AdjustedAmount":2,"LodgingAmount":11,"MealsAmount":12,"TowingAmount":13,"LaborAmount":14,"TravelAmount":15,"TotalTravel":16,"BaseFare":18,"AdjustmentReason":"abc","PenaltyAppliedFlag":"abc","AdjustedPercent":8}]}],"AdditionalESNs":[{"PSN":"abc","WarrantyStartDate":"2012-06-06","BISFlag":"abc","FailurePoint":2323,"FailureMeasure":"abc","VIN":"abc","ECMCalibAfter":"abc","ECMCalibBefore":"abc","ECMRevBfr":"abc","ECMRevAfter":"abc"},{"PSN":"abc","WarrantyStartDate":"2012-06-06","BISFlag":"abc","FailurePoint":2323,"FailureMeasure":"abc","VIN":"abc","ECMCalibAfter":"abc","ECMCalibBefore":"abc","ECMRevBfr":"abc","ECMRevAfter":"abc"}],"Notes":[{"Note":"abc","NoteType":"Correction","CreatedDate":"2012-06-06"},{"Note":"Cause","NoteType":"Cause","CreatedDate":"2012-06-06"},{"Note":"Cause","NoteType":"Complaint","CreatedDate":"2012-07-07"},{"Note":"Cause","NoteType":"abc","CreatedDate":"2012-06-06"},{"Note":"Correction","NoteType":"abc","CreatedDate":"2012-07-07"}],"ComplaintCodes":[{"ComplaintCode":"abc","ComplaintText":"abc"},{"ComplaintCode":"abc","ComplaintText":"abc"}]}]}';

        //system.debug('jsonResponseBody>>>'+jsonResponseBody);
        //cresWrap = (CSS_GetClaimDetailsResponse)JSON.deserialize(jsonResponseBody,CSS_GetClaimDetailsResponse.class);
        cresWrap=CSS_FN_SIEBEL.CallGetClaimDetails(claimsRec.SiebelClaimNumber__c);
        system.debug('Response Body cresWrap >>>'+cresWrap);
        if(cresWrap!=null && cresWrap.Header!=null){
            if(cresWrap.Header.Status=='Success'){
                if(cresWrap.DataArea!=null){

                    for(CSS_GetClaimDetailsResponse.DataArea da: cresWrap.DataArea){
                        CustomerName=da.CustomerName;
                        WorkOrderNumber=da.WorkOrderNumber;
                        DistributorCode=da.DistributorCode;
                        DistributorName=da.DistributorName;
                        PSN=da.PSN;
                        ModelSeries=da.ModelSeries;
                        Manufacturer=da.Manufacturer;
                        UnitNumber=da.UnitNumber;
                        EngineVIN=da.EngineVIN;
                        ServiceProviderCode=da.ServiceProviderCode;
                        EngineApplicationCode=da.EngineApplicationCode;
                        // DateTime WarrantyStartDateTime =datetime.newInstance(da.WarrantyStartDate.year(),da.WarrantyStartDate.month(),da.WarrantyStartDate.day());
                        // DateTime WarrantyStartDateTime=Datetime.parse(da.WarrantyStartDate);
                        // WarrantyStartDates=WarrantyStartDateTime.format('dd MMM YYYY hh:mm a z');
                        WarrantyStartDates=da.WarrantyStartDate;
                        //DateTime FailureDateTime =datetime.newInstance(da.FailureDate.year(),da.FailureDate.month(),da.FailureDate.day());
                        //DateTime FailureDateTime =Datetime.parse(da.FailureDate);
                        //FailureDates=FailureDateTime.format('dd MMM YYYY hh:mm a z');
                        FailureDates=da.FailureDate;
                        FailurePoint=da.FailurePoint;
                        FailureMeasure=da.FailureMeasure;
                        if(da.FailureList !=null){
                            for(CSS_GetClaimDetailsResponse.FailureList d: da.FailureList){
                                AccountCode=d.AccountCode;
                                if(d.PartsList !=null){
                                    for(CSS_GetClaimDetailsResponse.PartsList  p : d.PartsList){
                                        claimDetailPartswrapper parts =new claimDetailPartswrapper();
                                        parts.PartDescription=p.PartDescription;
                                        parts.ClaimedQuantity=p.ClaimedQty; 
                                        parts.EPRTracking=p.TrackingNumber;
                                        parts.ReturnID=p.RID;
                                        parts.PartQty=p.AdjustedQty;
                                        parts.PartNumber=p.PartNumber;
                                        parts.AdjustmentReason=p.AdjustmentReason;

                                        lstclaimDetailPartswrapper.add(parts);
                                    }}
                                if(d.OtherClaimablesList!=null){
                                    for(CSS_GetClaimDetailsResponse.OtherClaimablesList  o : d.OtherClaimablesList){
                                        claimDetailOtherClaimableswrapper oc =new claimDetailOtherClaimableswrapper();

                                        oc.ClaimedItemAmount=String.ValueOf(o.ClaimedAmount); 

                                        oc.Item=o.Item;
                                        oc.Description=o.ItemDescription;
                                        oc.ApprovedAmount=o.AdjustedAmount;
                                        oc.AdjustmentReason=o.AdjustmentReason;
                                        lstclaimDetailOtherClaimableswrapper.add(oc);
                                    }}
                                if(d.SRTList!=null){
                                    for(CSS_GetClaimDetailsResponse.SRTList  s : d.SRTList ){
                                        claimDetailSRTswrapper srt =new claimDetailSRTswrapper();
                                        srt.ClaimedQuantity=String.ValueOf(s.ClaimedQty);
                                        srt.Hours=String.ValueOf(s.ClaimedHours);
                                        if(srt.Hours!=null)
                                            claimed_Total_Hours=claimed_Total_Hours+Double.valueOf(srt.Hours);
                                        srt.Claimedper=String.ValueOf(s.ClaimedPercent);
                                        srt.SRTHours=s.SRTHours;
                                        srt.SRTQty=s.AdjustedQty;
                                        srt.PercentageAdjustment=s.AdjustedPercent;
                                        srt.AdjustmentReason=s.AdjustmentReason;
                                        srt.PenaltyAppliedFlag=s.PenaltyAppliedFlag;
                                        srt.SRTCode=s.SRTCode;
                                        lstclaimDetailSRTswrapper.add(srt);
                                    }}}}

                        for(Integer i=1;i<=5;i++){
                            system.debug('TravelList >>>'+i);
                            claimDetailTravelwrapper ttml =new claimDetailTravelwrapper();
                            if(i==1)
                                ttml.Type='Non-Commercial';
                            if(i==2)
                                ttml.Type='Commercial';
                            if(i==3)
                                ttml.Type='Towing';
                            if(i==4)
                                ttml.Type='Meals';
                            if(i==5)
                                ttml.Type='Lodging';
                            system.debug('ttml.Type >>>'+ttml.Type);
                            for(CSS_GetClaimDetailsResponse.FailureList d: da.FailureList){
                                if(d.TravelList !=null){
                                    for(CSS_GetClaimDetailsResponse.TravelList t : d.TravelList ){
                                        system.debug('TravelType1111111 >>>'+t.TravelType);
                                        if(t.TravelType!=null && t.TravelType==ttml.Type){
                                            ttml.TravelType=t.TravelType;
                                            system.debug('TravelType >>>'+t.TravelType);
                                            if(ttml.ClaimedAmount!=null)
                                                ttml.ClaimedAmount+=t.ClaimedAmount; 
                                            else
                                                ttml.ClaimedAmount=t.ClaimedAmount;
                                            system.debug('ttml.ClaimedAmount >>>'+ttml.ClaimedAmount);
                                            if(t.TravelType!=null && (t.TravelType.Contains('Lodging') || t.TravelType.Contains('Meals') )) {
                                                if(ttml.ClaimedLodgingMealsAmount!=null )
                                                    ttml.ClaimedLodgingMealsAmount+=t.ClaimedAmount;
                                                else
                                                    ttml.ClaimedLodgingMealsAmount=t.ClaimedAmount;

                                            }


                                            if(t.TravelType!=null && (t.TravelType=='Commercial' || t.TravelType=='Non-Commercial')) {
                                                if(ttml.ClaimedMileage!=null)
                                                    ttml.ClaimedMileage+=t.ClaimedDistance; 
                                                else
                                                    ttml.ClaimedMileage=t.ClaimedDistance; 
                                                if(ttml.ClaimedHours!=null)
                                                    ttml.ClaimedHours+=Double.ValueOf(t.ClaimedHours); 
                                                else
                                                    ttml.ClaimedHours=Double.ValueOf(t.ClaimedHours); 
                                            }
                                            if(t.TravelType!=null && (t.TravelType!='Lodging' && t.TravelType!='Meals' && t.TravelType!='Towing')) {
                                                if(ttml.Distance!=null)
                                                    ttml.Distance+=t.AdjustedDistance;
                                                else
                                                    ttml.Distance=t.AdjustedDistance;
                                                if(ttml.Hours!=null)
                                                    ttml.Hours+=t.AdjustedHours;
                                                else
                                                    ttml.Hours=t.AdjustedHours;
                                            }
                                            if(t.TravelType!=null && t.TravelType=='Lodging'){
                                                system.debug('Lodging >>>'+t.TravelType);
                                                if(ttml.LodgingAmount!=null)
                                                    ttml.LodgingAmount+=t.LodgingAmount;

                                                else
                                                    ttml.LodgingAmount=t.LodgingAmount;
                                                system.debug('ttml.LodgingAmount >>>'+ttml.LodgingAmount);
                                            }
                                            if(t.TravelType!=null && t.TravelType=='Meals'){
                                                system.debug('Meals >>>'+t.TravelType);
                                                if(ttml.MealsAmount!=null)
                                                    ttml.MealsAmount+=t.MealsAmount;
                                                else
                                                    ttml.MealsAmount=t.MealsAmount;
                                            }
                                            if(t.TravelType!=null && t.TravelType=='Towing'){
                                                system.debug('Towing >>>'+t.TravelType);
                                                if(ttml.TowingDetails!=null)
                                                    ttml.TowingDetails+=t.TowingAmount;
                                                else
                                                    ttml.TowingDetails=t.TowingAmount;
                                            }


                                            ttml.AdjustmentReason=t.AdjustmentReason;
                                            ttml.PenaltyAppliedFlag=t.PenaltyAppliedFlag;
                                            ttml.TotalTravel=t.TotalTravel;
                                            ttml.BaseFare=t.BaseFare;
                                            if(ttml.ClaimedMileage!=null)
                                                Claimed_Total_Mileage=Claimed_Total_Mileage+ttml.ClaimedMileage;
                                            if(ttml.Distance!=null)
                                                Adjusted_Total_Mileage=Adjusted_Total_Mileage+ttml.Distance;
                                            if(ttml.ClaimedHours!=null)
                                                Claimed_ttTotal_Hours=Claimed_ttTotal_Hours+ttml.ClaimedHours;
                                            if(ttml.Hours!=null)
                                                Adjusted_ttTotal_Hours=Adjusted_ttTotal_Hours+ttml.Hours;
                                            if(ttml.ClaimedLodgingMealsAmount!=null)
                                                claimed_Lodging_Meals=claimed_Lodging_Meals+ttml.ClaimedLodgingMealsAmount;
                                            if(ttml.LodgingAmount!=null)
                                                Adjusted_Lodging_Meals=Adjusted_Lodging_Meals+ttml.LodgingAmount;
                                            if(ttml.MealsAmount!=null)
                                                Adjusted_Lodging_Meals=Adjusted_Lodging_Meals+ttml.MealsAmount;
                                        }

                                    }
                                }

                            }
                            lstclaimDetailTravelwrapper.add(ttml); 
                        }

                        if(da.Notes!=null){
                            for(CSS_GetClaimDetailsResponse.Notes  n : da.Notes){
                                claimDetailExternalNotesWrapper parts =new claimDetailExternalNotesWrapper();
                                parts.Note=n.Note;
                                parts.NoteType=n.NoteType;
                                parts.CreatedDate=n.CreatedDate;
                                //DateTime CreatedDateTime =datetime.newInstance(parts.CreatedDate.year(),parts.CreatedDate.month(),parts.CreatedDate.day());
                                //parts.CreatedDateString=CreatedDateTime.format('dd MMM YYYY hh:mm a z');
                                parts.CreatedDateString=n.CreatedDate;
                                if(parts.NoteType!=null && (parts.NoteType=='Correction' || parts.NoteType=='Cause' || parts.NoteType=='Complaint' ))
                                    siebel3cExternalNotesWrapper.add(parts);
                                else{
                                    cdate.add(parts.CreatedDate);
                                    System.debug('cdate: ' + ' ' + cdate);
                                    claimDetailExternalNotesWrapperlist.add(parts);
                                    System.debug('claimDetailExternalNotesWrapperlist: ' + ' ' + claimDetailExternalNotesWrapperlist);
                                }
                            }}}}}
            if(cdate.size()>0)
                cdatelist.addAll(cdate);
            if(cdatelist.size()>0)
                cdatelist.sort();
            Integer sortvar =cdatelist.size();
            System.debug('cdate: ' + ' ' + cdatelist);
            System.debug('claimDetailExternalNotesWrapperlist: ' + ' ' + claimDetailExternalNotesWrapperlist);
            if(claimDetailExternalNotesWrapperlist.size()>0){
                System.debug('hhhhhh]: ' + ' ' + claimDetailExternalNotesWrapperlist.size());
                for(claimDetailExternalNotesWrapper h : claimDetailExternalNotesWrapperlist){
                    System.debug('hhhhhh]: ' + ' ' + h);
                    System.debug('sortvar ' + ' ' +sortvar);
                    for(Integer i = sortvar-1; i >= 0 ; i--){
                        System.debug('iiiii ' + ' ' +i);
                        System.debug('cdatelist[i]: ' + ' ' + cdatelist[i]);
                        System.debug('h.CreatedDate[i]: ' + ' ' + h.CreatedDate);
                        if(cdatelist[i] == h.CreatedDate){
                            lstclaimDetailExternalNotesWrapper.add(h);
                        }
                    }
                }}
        }}
    public void CallgetPaymentDetails() {
        CG_OP_OAGWrapper outputWrapper;
        //List<String> claimNumID = new List<String>();
        //claimNumID.add(claimsRec.SiebelClaimNumber__c);
        String claimNumID = claimsRec.SiebelClaimNumber__c;
        system.debug('siebelClaimNumber' + ' ' + claimNumID);
        try {
            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            //Mule Integration start
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CG_SBL_ClaimPaymentStatus');
            //Mule Integration end
            String endPoint = conDetails.End_Point__c;
            reqWrapper.endPoint = endPoint;
            reqWrapper.methodType = conDetails.Method_Type__c;
            List<string> lstClaimIds = new List<string>();
            lstClaimIds.add(claimNumID);
            String GetPaymentDetailsReqBody = '{ "Header": { "Target" : { "TargetID":"CSSWarranty"},"Sender":{"ServiceName": "getPaymentDetails","SenderID": "CSS"}},"DataArea": {"ClaimList" : { "ClaimNumber" : [ ' + claimNumID + ' ] }}}';//pass the Claim number.
            
            /*String GetPaymentDetailsReqBody ='{'+
'  "Header":{'+
'    "Target":{'+
'      "TargetID":"SIEBEL"'+
'    },'+
'    "Sender":{'+
'      "ServiceName":"GetPaymentDetails",'+
'      "SenderID":"CSS",'+
'      "MessageID":"" '+
'    }'+
'  },'+
'  "DataArea":{'+
'    "ClaimList":['+
'      {'+
'        "ClaimNumber":"1-1003814009"'+
'      },'+
'      {'+
'        "ClaimNumber":"1-1000034047"'+
'      }'+
'    ]'+
'  }'+
'}'+
'';*/

            System.debug('GetPaymentDetails reqBody ***'+ ' ' + GetPaymentDetailsReqBody);
            reqWrapper.jsonReqBody = GetPaymentDetailsReqBody;
            reqWrapper.serviceName = 'CG_SBL_ClaimPaymentStatus';
            String OAGWrapResp; 
            if(!Test.isRunningTest()){
                outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                OAGWrapResp = outputWrapper.response.getbody();
            }
            else{
               OAGWrapResp = '{'+
'  "DataArea":['+
'    {'+
'      "StatementNumber":375133,'+
'      "CreditDate":"05/30/2018",'+
'      "ClaimNumber":"1-1003814009",'+
'      "Deductible":0,'+
'      "Tax":60.77,'+
'      "TypeNumber":"Payment",'+
'      "Labor":26.58,'+
'      "RejectionReason":"",'+
'      "Travel":280.79,'+
'      "IMSClaimNumber":"06644",'+
'      "PayCode":"R",'+
'      "CreditNumber":"K5232",'+
'      "Parts":56.86,'+
'      "ClaimStatus":"Paid",'+
'      "TotalPaid":440.56,'+
'      "PMU":11.37,'+
'      "BFC":0,'+
'      "Other":4.19'+
'    },'+
'    {'+
'      "StatementNumber":375046,'+
'      "CreditDate":"05/26/2018",'+
'      "ClaimNumber":"1-1000034047",'+
'      "Deductible":0,'+
'      "Tax":0,'+
'      "TypeNumber":"Payment",'+
'      "Labor":319.8,'+
'      "RejectionReason":"",'+
'      "Travel":0,'+
'      "IMSClaimNumber":"78068",'+
'      "PayCode":"I",'+
'      "CreditNumber":"K2739",'+
'      "Parts":456.16,'+
'      "ClaimStatus":"Paid",'+
'      "TotalPaid":867.2,'+
'      "PMU":91.24,'+
'      "BFC":0,'+
'      "Other":0'+
'    }'+
'  ],'+
'  "Header":{'+
'    "Status":"Success",'+
'    "MessageIdentifier":""'+
'  }'+
'}';
            }
            //outputWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
            //String OAGWrapResp = '{ \"Header\": { \"ReturnCodeDescription\": \"<Message from Siebel>\", \"Status\": \"Success\", \"ReturnCode\": \"<MessageCode from Siebel>\", \"MessageIdentifier\": \"<Identifier from MW>\" }, \"DataArea\": [ { \"SiebelClaimNumber\": \"C0000190118\", \"IMSClaimNumber\": \"56270\", \"PayCode\": \"I\", \"ClaimStatus\": \"56275\", \"RejectionReason\": \"56275\", \"Type\": \"WO\", \"StatementNumber\": \"TEST\", \"CreditDate\": \"2010-03-19\", \"CreditNumber\": \"TEST\", \"Parts\": 56270, \"Labor\": 56275, \"Travel\": 56275, \"Other\": 987, \"Tax\": 987, \"PMU\": 56275, \"BFC\": 56275, \"Deductible\": 979, \"TotalPaid\": 955 }, { \"SiebelClaimNumber\": \"C0000190119\", \"IMSClaimNumber\": \"56270\", \"PayCode\": \"I\", \"ClaimStatus\": \"56275\", \"RejectionReason\": \"56275\", \"Type\": \"WO\", \"StatementNumber\": \"TEST\", \"CreditDate\": \"2010-03-19\", \"CreditNumber\": \"TEST\", \"Parts\": 56270, \"Labor\": 56275, \"Travel\": 56275, \"Other\": 987, \"Tax\": 987, \"PMU\": 56275, \"BFC\": 56275, \"Deductible\": 979, \"TotalPaid\": 955 } ] }';
            //  system.debug('Response of GetPaymentDetails' + ' ' + OAGWrapResp);
            //String OAGWrapResp = '{ \"Header\": { \"ReturnCodeDescription\": \"<Message from Siebel>\", \"Status\": \"Success\", \"ReturnCode\": \"<MessageCode from Siebel>\", \"MessageIdentifier\": \"<Identifier from MW>\" }, \"DataArea\": [ { \"SiebelClaimNumber\": \"1-48975744\", \"IMSClaimNumber\": \"56270\", \"PayCode\": \"I\", \"ClaimStatus\": \"56275\", \"RejectionReason\": \"56275\", \"Type\": \"WO\", \"StatementNumber\": \"TEST\", \"CreditDate\": \"2010-03-19\", \"CreditNumber\": \"TEST\", \"Parts\": 56270, \"Labor\": 56275, \"Travel\": 56275, \"Other\": 987, \"Tax\": 987, \"PMU\": 56275, \"BFC\": 56275, \"Deductible\": 979, \"TotalPaid\": 955 } ] }';

            
            system.debug('OAGWrapResp' + ' ' + OAGWrapResp);
            CG_SiebelGetPaymentDetailsRespWrapper PaymentDetailsRespWrapper = new CG_SiebelGetPaymentDetailsRespWrapper();
            PaymentDetailsRespWrapper = (CG_SiebelGetPaymentDetailsRespWrapper)JSON.deserializeStrict(OAGWrapResp, CG_SiebelGetPaymentDetailsRespWrapper.class);
            system.debug('Response of GetPaymentDetails ' + ' ' + PaymentDetailsRespWrapper);

            for(CG_SiebelGetPaymentDetailsRespWrapper.cls_DataArea  data: PaymentDetailsRespWrapper.DataArea){
                SiebelClaimNumber=data.ClaimNumber;
                IMSClaimNumber=data.IMSClaimNumber;
                PayCode=data.PayCode;
                ClaimStatus=data.ClaimStatus;
                RejectionReason=data.RejectionReason;
                Type=data.TypeNumber;
                StatementNumber=data.StatementNumber;
                CreditDate=data.CreditDate;
                CreditNumber=data.CreditNumber;
                Parts=data.Parts;
                Labor=data.Labor;
                Travel=data.Travel;
                Other=data.Other;
                Tax=data.Tax;
                PMU=data.PMU;
                BFC=data.BFC;
                Deductible=data.Deductible;
                TotalPaid=data.TotalPaid;
            }
        } catch(exception e){
            system.debug('Entered into catch of getPaymentDetails Method in CSS_FN_SIEBEL>>>'+e.getMessage() +e.getLineNumber());
        }
    }
    public PageReference generatePDF(){
        System.debug('generating: ');

        Id subid = ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = new PageReference('/apex/CG_PDFGetClaimDetails');
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
        public String CreatedDateString{get;set;}
        public claimDetailExternalNotesWrapper(){}
    }

    public class claimDetailSRTswrapper{
        public Decimal SRTHours{get;set;}
        public Integer SRTQty{get;set;}
        public Integer PercentageAdjustment{get;set;}
        public string AdjustmentReason{get;set;}
        public string AccessCode{get;set;}
        public string SRTCode{get;set;}
        public string Hours {get;set;}
        public string ClaimedQuantity {get;set;}
        public string Claimedper {get;set;}
        public string PenaltyAppliedFlag {get;set;}
        public claimDetailSRTswrapper(){}
    }

    public class claimDetailOtherClaimableswrapper{
        public string Item{get;set;}
        public string Description{get;set;}
        //public Integer ApprovedAmount{get;set;}
       // public Double ApprovedAmount{get;set;}
        public string ApprovedAmount{get;set;}
        public string AdjustmentReason{get;set;}
        public string ClaimedItemAmount{get;set;}
        public claimDetailOtherClaimableswrapper(){}
    }

    public class claimDetailPartswrapper{
        public Integer AdjustmentPartsPercent{get;set;}
        public string PartQty{get;set;}
        public string PartNumber{get;set;}
        public string AdjustmentReason{get;set;}
        public string PartDescription {get;set;}
        public string ClaimedQuantity {get;set;}
        public string EPRTracking  {get;set;}
        public string ReturnID  {get;set;}
        public claimDetailPartswrapper(){}
    }

    public class claimDetailTravelwrapper{
        public string Type{get;set;}
        public string TravelType{get;set;}
        public string AdjustmentReason{get;set;}
       // public Integer Distance{get;set;}
        public string Distance{get;set;}
       // public Double Hours{get;set;}
        public string Hours{get;set;}
       // public Decimal LodgingAmount{get;set;}
        public string LodgingAmount{get;set;}
       // public Integer MealsAmount{get;set;}
        public string MealsAmount{get;set;}
       // public Integer TowingDetails{get;set;}
        public string TowingDetails{get;set;}
       // public Integer ClaimedAmount{get;set;}
        public string ClaimedAmount{get;set;}
       // public Integer ClaimedLodgingMealsAmount{get;set;}
        public string ClaimedLodgingMealsAmount{get;set;}
       // public Integer ClaimedMileage{get;set;}
        public string ClaimedMileage{get;set;}
        public Double ClaimedHours{get;set;}
        // public Integer TotalTravel{get;set;}
       // public Double TotalTravel{get;set;}
        public string TotalTravel{get;set;}
        // public Integer BaseFare{get;set;}
        public string BaseFare{get;set;}
        public Integer TravelAdjustedPercentage{get;set;}
        public string PenaltyAppliedFlag{get;set;}
        public claimDetailTravelwrapper(){}
    }

    public class ClaimsubmissionNotes {
        public string Notes{get;set;}
        public string AdjudicatorName{get;set;}
        public string Notestime{get;set;}
        public ClaimsubmissionNotes(){}
    }

}