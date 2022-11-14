public with sharing class IAM_ContactDistributorInfo
{
 
    Public App_Mapping__c app{get;set;}
    public String currentRecordId {get;set;}
    public String currentAccId {get;set;}
    Public Account acc{get;set;}
    public string url{get;set;}
    public boolean distributorInfo{get;set;}
    public boolean noDistributorInfo{get;set;}
    
    public IAM_ContactDistributorInfo()
    {
        distributorInfo = false;
        noDistributorInfo= false;
        
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('appid');
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
       currentAccId = ApexPages.CurrentPage().getparameters().get('accid');
       system.debug('Id-----------@@@@'+currentAccId);
       if(currentAccId!=null)
        {
            acc = [select id,Name,Parent.id,parent.Name,parent.BillingStreet,parent.BillingCity,parent.BillingPostalCode,parent.BillingStateCode,
                   parent.BillingCountryCode,parent.Phone from Account where id=:currentAccId];
            system.debug('Acc--******'+acc);
            if(acc.Parent.id != null)
                distributorInfo = true; 
            else 
                noDistributorInfo = true;
        }
     }
    public pageReference redirectBackpage() 
    {
        PageReference retURL ;
        if(app.Back_page__c != null)  
        {
            retURL = new PageReference(app.Back_page__c);
        }     
        retURL.setRedirect(true);
        return retURL;
    } 
    
    
    public PageReference Login() 
    {
        PageReference demoPage = new pagereference(url);
        demoPage.setRedirect(true);
        return demoPage;
    }
    
    public Pagereference SaveandClose()
    {
        return null;
    }

    public pagereference Close()
    {
        pageReference p=new pagereference('/apex/IAM_userreg');
        if(p!=null)
        {
            p.setredirect(true);
            return p;
        }else
        { 
            return null;
        }
    }
}