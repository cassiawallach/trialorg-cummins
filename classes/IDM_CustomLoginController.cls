global without sharing class IDM_CustomLoginController {

    
Apexpages.StandardController controller; 
 // private final Loginu log;
    public String username{get;set;}
    public String password{get;set;}
    Public App_Mapping__c app{get;set;}
    integer m;
    public String currentRecordId {get;set;}
    DateTime NextReload;
    Long SecondsRemaining;
    Integer RefreshIntervalSeconds = 15;
     public IDM_CustomLoginController() {
          //this.app= (App_Mapping__c)controller.getRecord(); 
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('appid');
        system.debug('Id'+currentRecordId);
       if(currentRecordId!=null){
        app = [select AppId__c,Name,Internal_Employee_link__c,Registration__c,internal_Employee_Redirection__c, Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where id=: currentRecordId  ];
          
       // parameterValue = ApexPages.CurrentPage().getparameters().get('id');
 
        system.debug('Id'+app);
        }
        else
        {
         app = [select AppId__c,Name,Internal_Employee_link__c,Registration__c,internal_Employee_Redirection__c, Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where id='a164C000000L1VE' ];
          
       // parameterValue = ApexPages.CurrentPage().getparameters().get('id');
 
        system.debug('app============'+app);
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
       public pageReference redirectRegistartionpage() 
    {
      PageReference retURL ;
      
       if(app.Registration_Link__c != null)  
       {
          retURL = new PageReference(app.Registration_Link__c);
       }     
       retURL.setRedirect(true);
       return retURL;
    }
    public pageReference redirectpage() 
    {
      PageReference retURL ;
      
       if(app.Back_page__c != null)  
       {
          retURL = new PageReference(app.Back_page__c);
       }     
       retURL.setRedirect(true);
       return retURL;
    } 
    public IDM_CustomLoginController(ApexPages.StandardController controller) {
        //this.app= (App_Mapping__c)controller.getRecord(); 
         String s;
        
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('appid');
        system.debug('Id'+currentRecordId);
        app = [select AppId__c,Name,Internal_Employee_link__c,internal_Employee_Redirection__c,Registration__c,Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where id=:currentRecordId  ];
        if(app== null)
        {
         app = [select AppId__c,Name,contact_email__c,Registration__c,internal_Employee_Redirection__c,Footer_text__c from App_Mapping__c where id='a164C000000L1Uk'];
        }
       // parameterValue = ApexPages.CurrentPage().getparameters().get('id');
 
        system.debug('Id'+app);

    }
   
    global PageReference doLogin() {
    PageReference startPage ;
      String appid = ApexPages.CurrentPage().getparameters().get('appid');
        system.debug('Id'+appid);
    startPage = Site.login(username, password,'/EIDM_Cummins_Redirect?appid='+appid);     
    return startPage; 
       
}

 public pageReference redirectinternalpage() 
    {
      PageReference retURL ;
       if(app.Internal_Employee_link__c!= null)
          {
          retURL =new PageReference(app.Internal_Employee_link__c);
          }
          
       retURL.setRedirect(true);
       return retURL;
    }

}