public class IAM_JIT_Partner_ErrorPage
{

    Public App_Mapping__c app{get;set;}
    public String currentRecordId {get;set;}
    public string url{get;set;}
    public string logouturl{get;set;}
    public Id Id{get;set;}
    public String currentRecalim {get;set;} //for 36 UAT issue
    public Boolean RecalimMessage {get;set;} //for 36 UAT issue
    public string errorMessage{get;set;}
    
    public IAM_JIT_Partner_ErrorPage()
    {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('appid');
        Map<String,String> pageParams=ApexPAges.CurrentPage().getParameters();
        String errorMessageTobeSet='';
        if(pageParams.containsKey('ErrorDetails')){
        System.debug('Printing exception'+pageParams.get('ErrorDetails'));
            errorMessageToBeSet=pageParams.get('ErrorDetails').substringAfterLast('JitException');
        }
        
        System.debug('Printing the exception message that needs to be displayed'+errorMessageToBeSet);
        if(!String.isEmpty(errorMessageTobeSet)){
           errorMessage='There is an issue with login. '+errorMessageToBeSet.removeStart(':');
        }else{
           errorMessage='Something unexpected has happened. Please close the browser and revisit the page. If the error continues, please contact Cummins Support.'; 
        }
        RecalimMessage = false; //for 36 UAT issue
        if(currentRecordId == null)
        {
            currentRecordId = Label.IAM_Default_Appmap;
        }
        system.debug('Id----------------------------------------------------'+currentRecordId);
        if(currentRecordId!=null)
        {
            app = [select AppId__c,Name,Internal_Employee_link__c, Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c,Login_Url__c from App_Mapping__c where id=:currentRecordId];
            url = app.Login_Url__c;
            system.debug('------------------------------'+url);
            system.debug('Id'+app);
        }
       //Karthik changes start for 36 UAT issue
       currentRecalim = ApexPages.CurrentPage().getparameters().get('recalim');
       if(currentRecalim == 'true')
        RecalimMessage = true;
       //Karthik changes end for 36 UAT issue 
     }
    
}