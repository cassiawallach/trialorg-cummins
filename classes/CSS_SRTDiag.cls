/*
 * Block comments with details of changes
 */
public  with sharing class CSS_SRTDiag
{
    public boolean isClaimEnabled {get;set;}
    public boolean isError {get;set;}
    public Id wId{
        get;
        set; /*{
            jobId = value;
        }*/
    }
    public CSS_Job_Order__c jobOrdr{get; set;}
    public string technician {get; set;}
    public string pgeName{get;set;}

    public CSS_SRTDiag()
    {
        wId=ApexPages.CurrentPage().getParameters().get('id');
        isError = false;
        isClaimEnabled = css_utility.getclaimsapprove(UserInfo.getUserId());
        // system.debug('JobId Print >>'+jobId);
        if(wId != null){
            jobOrdr = [Select id,Actual_Technician_Time__c,DiagTimeExtendedHrsCalculation__c,TotalSRTExtendedHours__c FROM CSS_Job_Order__c WHERE Id = :wId LIMIT 1];
        }
        //if(isClaimEnabled && wId != null && workJob.Actual_Technician_Time__c == null)
        //  isError = true;
        //  if (workJob.Actual_Technician_Time__c==null)
        //   workJob.Actual_Technician_Time__c= 000.0;


    }
    public PageReference techSave(){    

        try {
            isError = false;
            if(isClaimEnabled && wId != null && jobOrdr.Actual_Technician_Time__c == null)
                isError = true;
            else {
                CSS_Job_Order__c sJob = new CSS_Job_Order__c();
                sJob.Id =jobOrdr.Id;
                sJob.Actual_Technician_Time__c = jobOrdr.Actual_Technician_Time__c;
                system.debug('sJob'+sJob);
                update sJob;
            }
        } catch(Exception e) { 
            system.debug(e.getMessage());
        }
        PageReference pageRef;
        system.debug('pgeName>>>'+pgeName);
        if(pgeName=='TnDRJ') {
           
        pageRef = new pageReference('/apex/CSS_JobTnDRJ?id='+jobOrdr.id); 
        system.debug('pageRef>>>>'+pageRef);
        }
        if(pgeName == 'RepairRJ'){
        
        pageRef = new pageReference('/apex/CSS_JobRepairRj?id='+jobOrdr.id);
            system.debug('pageRef>>>>>'+pageRef);
        }
        pageRef.setRedirect(true);
        system.debug('pageRef>>>>>>'+pageRef);
        return pageRef; 
    }
}