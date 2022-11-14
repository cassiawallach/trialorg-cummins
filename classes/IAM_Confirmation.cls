public without Sharing class IAM_Confirmation
{

Public App_Mapping__c app{get;set;}
public String currentRecordId {get;set;}
public string url{get;set;}
public string logouturl{get;set;}
public Id Id{get;set;}
public String currentRecalim {get;set;} //for 36 UAT issue
public Boolean RecalimMessage {get;set;} //for 36 UAT issue

public IAM_Confirmation()
{
    currentRecordId  = ApexPages.CurrentPage().getparameters().get('appid');
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

public pagereference logout()
{
    pagereference p;
    
    List<user> u=[select id,username,Profile.id,Profile.Name from user where id=:UserInfo.getUserId()];
    system.debug(u);
    string s=system.Label.IAM_logout_URL;
    Set<String> whiteListedDomains = new Set<String>();
        whiteLIstedDomains.add(s);
    if(!u.isEmpty()){
    //if it is aguest profile .then we need to route user to global logout.
        if(u[0].Profileid==Label.IAM_Cummins_web_Profile||u[0].Profileid==Label.IAM_Fleetguard_Guest_User_Profile_ID){
        system.debug('user is Internal');
        //SonarQube fix
        if(s != null)
            p=new pagereference(s);
       
    }else{   
        //here since user is not a guest user and some valid SF user we need to route to sf logout :p
        
        
        system.debug('user is External');
        p=new pagereference('/secur/logout.jsp');
        
    }
    }
    else{ 
        //SonarQube fix
        if(s != null)
            p=new pagereference(s);
    }
     p.setredirect(true);
     return p;
}

}