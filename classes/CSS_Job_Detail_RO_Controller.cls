public class CSS_Job_Detail_RO_Controller{
    public List<account> accList{get;set;}
    //public List<CSS_Job_Order__c> serviceJob{get;set;}
    CSS_Job_Order__c serviceJob{get;set;}
    public CSS_Job_Detail_RO_Controller(){
        accList = [select id,name,type,accountnumber,annualrevenue,Rating from account limit 10];
    }
    public void getDetails(){
        Id jobId = ApexPages.currentPage().getParameters().get('id');
        serviceJob = [SELECT Id, JobLocation__c, Name, Shop_s_Work_Order__c, Date_In__c, Customer_Name__c, Failure_Date__c,Actual_Technician_Time__c,
                             Mileage_Measure__c, Engine_Run_Time_Hours_Mileage_km_miles__c, Make__c, Model__c, ESN__c, VIN__c, Unit_Number__c,
                             Complaint__c, CSS_Feedback_Comments__c, DSID__c, Coverage__c, Correction__c FROM CSS_Job_Order__c WHERE Id =: jobId limit 1];
    }
}