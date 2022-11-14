Public class IAM_New_Password_Login_Controller{

Public user loggedUser{set;get;}
Public App_Mapping__c app{set;get;}
public String language {get; set;}
    
    
    Public IAM_New_Password_Login_Controller(){
        
        String currentRecordId= ApexPages.CurrentPage().getparameters().get('appid');
         String langValue = ApexPages.currentPage().getParameters().get(Label.Language_Parameter);
        
        try{
            loggedUser=[select id,username from user where id=:UserInfo.getUserId()];
             
            if(currentRecordId!=null){
        app = [select AppId__c,Name,Internal_Employee_link__c,Registration__c,forgot_password__c,internal_Employee_Redirection__c,  Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where id=: currentRecordId  ];
          
        system.debug('Id'+app);
        }
        else
        {
         app = [select AppId__c,Name,Internal_Employee_link__c,Registration__c,forgot_password__c,internal_Employee_Redirection__c, Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where id=:System.Label.IAM_Default_Appmap];
         system.debug('app============'+app);
        } 
                      
        }catch(exception ex){
            System.debug('Prinitng exception in new logged in '+ex);            
        }
    
    }
    
    
    Public PageReference doLogin(){
       
       PageReference pageRef = new PageReference('/IAM_Authorize?appid='+app.id);
       pageRef.setRedirect(true);
       return pageRef;  
        
    }
    
    
  
}