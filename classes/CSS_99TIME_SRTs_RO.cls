/**********************************************************************
Name:CSS_99TIME_SRTs
======================================================
======================================================
Purpose:                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR              DATE                DETAIL                                 
1.0    -    Rajesh Pasupuleti   22/08/2017      INITIAL DEVELOPMENT
1.1    -    Vignesh S           11/06/2018      Included Save/Reset method functionality from page
***********************************************************************/
public class CSS_99TIME_SRTs_RO {

    public transient List<CSS_SRT__C> existingNonSRTList {get; set;}
    public transient List<NonSRTWrapper> NonSRTWrapperList {get;set;}
    public transient List<NonSRTWrapper> NonSRTWrapperList1 {get;set;}
    public transient string PName { get; set;}
    public transient Decimal TotalSRTTime{get; set;}
    public transient CSS_Solution_Component__c[] solutionComponentList;
    public transient set<string> failAcocuntCode;
    public transient boolean chkReqField{get;set;}
    public transient boolean ErrorMessage1 {get; set;}
    //public Id Wid;
    //Constructor.
    public CSS_99TIME_SRTs_RO() {
        ErrorMessage1=false;
        TotalSRTTime=0.0;
        existingNonSRTList = new List<CSS_SRT__C>();

        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        system.debug('--**Wid**--'+Wid);
        if(Wid != null) {
            //Fetch data from Existing Non SRT.
            existingNonSRTList = [select Id, Account_Code_Description__c, FailCode__c, Fail_Code_Description__c, SRT_Time__c, SRT_Warrantable__c, SRT_Notes__c,SRT_Estimate__c,                  
                                  isPerformed__c,CSS_nonSRTRow__c from CSS_SRT__c 
                                  where Job_order__c=:Wid AND Type__c='99Time' AND (Fail_Code_Description__c != null OR CSS_nonSRTRow__c != null)];//Venkat 171494
            system.debug('--**existingNonSRTList**--'+existingNonSRTList);
            if(existingNonSRTList !=null && existingNonSRTList.size() > 0){
                for(CSS_SRT__c existing : existingNonSRTList) {
                    if((existing.SRT_Time__c) != null && (existing.SRT_Time__c) != 0.0) {
                        TotalSRTTime += existing.srt_Time__C;
                        system.debug('existing.SRT_Time__c '+existing.isPerformed__c);
                         system.debug('Check value for SRTTime0 >> '+TotalSRTTime);
                        
                    }
                }
            }
            system.debug('Check value for TotalSRTTime >> '+TotalSRTTime);  
        }
    }

    //This method is called on TND and Repair Review job pages.
    public PageReference gotoJobPlanSrt(){       
        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanSRT?id='+Wid); 
        pageRef.setRedirect(true);
        return pageRef;
    }


    //Wrapper.
    public class NonSRTWrapper {
        public transient Integer Count { get; set; }
        public transient string srtId { get; set; }
        public transient string SRTCode { get; set; }
        public transient string SRTTime { get; set; }
        public transient string percentRequested { get; set; }
        public transient string failCode { get; set; }
        public transient string accountCode { get; set; }
        public transient string Notes { get; set; }
        public transient boolean isRemove { get; set; }//No need as of now.
        public NonSRTWrapper(Integer Count, string srtId, string SRTCode, string SRTTime, string percentRequested, string failCode, string accountCode, string Notes) {
            this.Count = Count;
            this.srtId = srtId;
            this.SRTCode = SRTCode;
            this.SRTTime = SRTTime;
            this.percentRequested = percentRequested;
            this.failCode = failCode;
            this.accountCode = accountCode;
            this.Notes = Notes;
        }
    }




}