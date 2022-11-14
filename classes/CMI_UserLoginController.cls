global with sharing class CMI_UserLoginController{
public String currentRecordId {get;set;}
global String currentlang {get;set;}
Public App_Mapping__c app{get;set;}
public string forgotpwdcustomLabelValue{get;set;}
global User u{get;set;}

global CMI_UserLoginController() {

currentRecordId  = ApexPages.CurrentPage().getparameters().get('appid');
currentlang = ApexPages.CurrentPage().getparameters().get('language').left(5);
system.debug('currentlang :'+currentlang);
forgotpwdcustomLabelValue= System.Label.IDM_forgotpassword_lang+currentlang ;
        system.debug('Id'+currentRecordId);
        
       if(currentRecordId!=null){
        app = [select AppId__c,Name,Internal_Employee_link__c,Registration__c,internal_Employee_Redirection__c, Registration_Mobile__c , Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where id=: currentRecordId  ];
       system.debug('Id'+app);
        }
        else
        {
         app = [select AppId__c,Name,Internal_Employee_link__c,Registration__c,internal_Employee_Redirection__c,Registration_Mobile__c , Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where id='a164C000000L1VE' ];
        system.debug('app============'+app);
}
}
  public PageReference doLogin() {
           
       // String startUrl = System.currentPageReference().getParameters().get('startURL');
      //   String startUrl = system.label.CS_Mobile_URL;
       // return Site.login(username, password, startUrl);
 
     List<User> obj = new List<User>();
if(username != null && username != '')
{
system.debug('Myusername:'+username );
if(password != null && password != '')
{
//String startUrl;
        String startUrl = system.label.CS_Mobile_URL;
     if(currentRecordId!=null||currentRecordId!='')
    {
    starturl='/Eidmredirect_mobile?appid='+currentRecordId+'&language='+currentlang;
    }else{
    starturl='/Eidmredirect_mobile';
    } 
        Pagereference p= Site.login(username, password, startUrl);
       
        if(p!=null)
        {

        return p;
       }
       else
       {
    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, system.label.IDM_userpassword_error );
    ApexPages.addMessage(myMsg);
    
    system.debug('MyMsg:'+myMsg);
}
}
else
{
    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, system.label.IDM_password_error );
    ApexPages.addMessage(myMsg);
    system.debug('MyMsg:'+myMsg);
}
}

else
{
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, system.label.IDM_UserName_error );
ApexPages.addMessage(myMsg);
system.debug('MyMsg:'+myMsg);
}
return null;


}
@future
public static void updateuser(string currentlang) {

             system.debug('userID:'+ userinfo.getuserid()); 

             User u= [select Username,LocaleSidKey,LanguageLocaleKey,LastLoginDate from User where id=:userinfo.getuserid()];
             
             if((currentlang!=null))
              {
              u.LocaleSidKey=currentlang;
              u.LanguageLocaleKey=currentlang;
            // u.CMI_Calibration_Role__c='Role1';
              system.debug('currentlang:'+ currentlang); 
              
              update u;
             }
              else
              {
              u.LocaleSidKey='en_US';
              u.LanguageLocaleKey='en_US';
              system.debug('user details:'+u); 
              update u;
              }
            system.debug('currentlang for user:'+currentlang); 
        }
        
    public String password { get; set; }

    public String username { get; set; }
}