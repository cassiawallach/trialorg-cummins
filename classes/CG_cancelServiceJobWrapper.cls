public class CG_cancelServiceJobWrapper
{
    public boolean errorFlag{get;set;}
    public String errorMessage{get;set;}
    public CSS_Job_Order__c serviceJob{get;set;}
    
    public CG_cancelServiceJobWrapper()
    {
        errorFlag=false;  
        errorMessage = '';
        serviceJob = new CSS_Job_Order__c();
    }
}