public class FSL_JobDetailPDFController 
{
    public Workorder workJob {get;set;}
    public Datetime currentDate {get;set;}
    public Id jobId{get;set;}
    public Boolean Profilecheck { get; set; }
    public Boolean sType { get; set; }


    public List<CSS_Solution_Component__c> lstSolComp {get;set;}
    public List<CSS_Parts_Options__c> lstPartsComp {get;set;}
    public List<CSS_Solutions__c> solList{get;set;}
    public List<CSS_Solutions__c> solRepairList{get;set;}    
    private string woId;
    public FSL_JobDetailPDFController()
    {
        String myGeneratedFileName = 'WorkOrder.pdf';
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename);
        currentDate = system.now();
        workJob = new workorder();   
        String profileId = UserInfo.getProfileId();
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id =:profileId];
        system.debug('profile>>>>>>>>>>'+profile.Name);
        if(profile.Name == 'EVL_Dealer_Advanced' || profile.Name == 'EVL_Dealer_Technician' || profile.Name == 'EVL_Dealer_Readonly'){
            Profilecheck = true;
        }
        else{
            Profilecheck = false;
        }
        if(ApexPages.CurrentPage().getParameters().size() > 0)
        {
            woId = ApexPages.CurrentPage().getParameters().get('id');
            if(string.isNotBlank(woId))
            {
                fetchWorkOrder(woId);
            }
        }
    }
    public void fetchWorkOrder(string woId)
    {
        workJob = [select id,Account.Name, Account.Location__c, Location_Name__c,Type__c,ServiceTerritory.Name,Category1__c,Complaint_Type1__c,ServiceTerritory.Location_Code__c,WorkOrderNumber,CreatedDate,EditCause__c,EditCoverage__c,EditCorrection__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,CSS_Hours__c,Make__c,Model__c,Asset.name,asset.Unit_Number__c,Asset.VIN__c,General_Symptoms__c, EVL_Customer__c from workorder where id =: woId];
        if(workJob.Type__c == 'Dealer'){
            sType = true;

        } else{
            sType = false;

        }
        lstSolComp = [Select Id, Name,Solutions__r.Solution_Title__c,FSL_Service_Job__c,Solutions__r.Diagnostic_notes__c,Solutions__r.Repair_Notes__c from CSS_Solution_Component__c where FSL_Service_Job__c = :woId and Solutions__r.Diagnostic_Response__c='Most likely the solution. Repair recommended.' and Selected_Component__c= true ];
                system.debug('List of Components:'+lstSolComp);
        
        lstPartsComp =[select Id, Name,Service_Order__c,FailurepartId__r.Name,Part_Description__c, Quantity__c,Service_partnumber__c,Part_Name__c,Selected_Part__c from CSS_Parts_Options__c where Service_Order__c =:woId and FailurepartId__c != null and Selected_Part__c = true];
                system.debug('lstPartsComp--'+lstPartsComp);
                
        solList = [Select id,name,FSL_Service_Job__c,Solution_Title__c,Diagnostic_notes__c,Repair_Notes__c, (Select id, name, Selected_Component__c,FSL_Service_Job__c  from CSS_Solution_Components__r where FSL_Service_Job__c = :woId) from CSS_Solutions__c where (FSL_Service_Job__c = :woId) and Diagnostic_Response__c ='Most likely the solution. Repair recommended.'];
                system.debug('solList--'+solList);
                //system.debug('solListcmp--'+solList.CSS_Solution_Components__r);

        solRepairList = [Select id,name,FSL_Service_Job__c,Solution_Title__c,Diagnostic_notes__c,Repair_Notes__c, (Select id, name, Selected_Component__c,FSL_Service_Job__c from CSS_Solution_Components__r where FSL_Service_Job__c = :woId ) from CSS_Solutions__c where FSL_Service_Job__c = :woId and (Repair_Response__c='Repair Successful.' or Repair_Response__c='Repair Successful with additional parts/procedures.')];
                //system.debug('solListcmp--'+solRepairList.CSS_Solution_Components__r);
    
    }
    public String getDtStart() 
    {
        try{
            if(workJob.CreatedDate != null){
                String createdDate = css_utility.getFormattedDate(workJob.CreatedDate); //Get formatted String from Utility Class
                return createdDate; //return the string
            }else{
                return null;
            }
        }catch(exception e){
            system.debug('Entered into catch block of getDtStart method in css_readonly controller>>>>>>>>>'+e.getMessage() + ' ' + e.getLineNumber());
            return null;
        }
    }
}