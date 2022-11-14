global without sharing class IAM_forgotpasswordController {
    
    public String userEmail{get;set;}
    public String errorContactEmail{get;set;}
    Public App_Mapping__c app{get;set;}
    public String currentRecordId {get;set;}
    public String  resourceurl{get;set;}
    public String  en{get;set;}
    public Contact ConRedirect{get;set;}
    
    
    public IAM_forgotpasswordController() {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('appid');
        userEmail=ApexPages.CurrentPage().getparameters().get('username');
        if(currentRecordId  !=null)
        {
            app = [select AppId__c,Name,CMI_External_Start_Url__c,CMI_Internal_URL__c,IAM_OAM_Resource_URL__c,Internal_Employee_link__c,Internal_Redirect_URL2__c,Registration__c,forgot_password__c,internal_Employee_Redirection__c,  Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where Id=: currentRecordId  ];
            system.debug('Id'+app);
        }
        else
        {
            app = [select AppId__c,Name,CMI_External_Start_Url__c,CMI_Internal_URL__c,IAM_OAM_Resource_URL__c,Internal_Employee_link__c,Internal_Redirect_URL2__c,Registration__c,forgot_password__c,internal_Employee_Redirection__c,  Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where id=: System.label.IAM_Default_Appmap];
        }
        
    }
    

    
    
    
    
    
    public pageReference redirectForgorUsernamepage(){
        system.debug('email of user****'+userEmail);
        Boolean emailCheck = false;
        errorContactEmail = '';
        if(userEmail == null || userEmail == '') {
            errorContactEmail = 'Please fill out username';
            emailCheck = false;
            return null;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please fill out username'));
            //return null; 
        } 
        system.debug('email of user*length***'+userEmail.length());
        //removing email from query.
        //List<Contact> currentCon = [Select id,Username__c, IAM_Legacy_User__c, email from Contact where Username__c=:userEmail OR email=:userEmail];
        List<Contact> currentCon = [Select id,Username__c, IAM_Legacy_User__c, email from Contact where Username__c=:userEmail];
        if(currentCon.size()>0){
            //if(userEmail.contains('@')) {
            if(currentCon[0].IAM_Legacy_User__c) {
                String oamurl=system.label.IAM_forgot_password_link+userEmail+'&RealTARGET='+app.IAM_OAM_Resource_URL__c+'&CancelTARGET='+app.IAM_OAM_Resource_URL__c;
                PageReference newFloodOnlyUrl = new PageReference(oamurl);
                
                newFloodOnlyUrl.setRedirect(true);
                return newFloodOnlyUrl;
            } else {
                // IAM_forgot_password_link
                system.debug('ssss');
                String expr = System.Label.IAM_Email_Regular_Expression;
                expr = expr.removeStart('/').removeEnd('/');
                System.debug('label---'+System.Label.IAM_Email_Regular_Expression);
                System.debug('#### expr - '+expr);
                
                if(Pattern.matches(expr, userEmail)) {
                    emailCheck = true;
                    errorContactEmail = '';
                    
                } 
                else {
                    errorContactEmail = 'Invalid username';
                    emailCheck = false;     
                }
                system.debug('@@@@@@@emailCheck***@@@@@@@@'+emailCheck);
                if(emailCheck) {
                    //Karthik changes this method for 29 and 158 UAT issue
                    //legacy false
                    try {
                        List<User> currentUser = [Select id,Username,Email,contactId from user where username=:userEmail AND isActive=true limit 1];
                        if(currentUser.size() > 0) {
                            //fix - D-2880 - when user reset password then only reset password email should be send instead of registration processed
                            //List <id> uids=new List<id>();
                            //uids.add(currentUser[0].id);
                            //CMI_CreateUsersHelper.doResetPassword(uids);
                            IAM_AccountsController.resetPasswordUser(currentUser[0].id);
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'We have sent a reset password link to registered email'));       
                            //keerthy changes for success redirection
                            PageReference retURL=new PageReference('/IAM_forgotpassword_Confirmation?appid='+app.id);    
                            retURL.setRedirect(true);
                            return retURL;            
                        } else {
                            errorContactEmail = 'There is no user with the entered username';
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'There is no user with this username'));
                        }
                    }catch(exception ex) {
                        system.debug('exception is @@@@'+ex.getMessage());
                    }
                }
                
            }
        }
        else {
            errorContactEmail = 'Invalid username';
        }    
        return null;
    }
    
    public pageReference redirectCancelpage(){
        Pagereference  retURL=new PageReference('/IAM_Cummins_Login?appid='+app.id+'&lang='+getLanguage());     
        retURL.setRedirect(true);
        system.debug('redirection'+retURL);     
        return retURL;
    }
    public String getLanguage() {
        String langValue1 = ApexPages.currentPage().getParameters().get('lang');
        if(langValue1!=null)
        {
            String langValue=langValue1.escapeHtml4();
            System.debug('langValue.....  ' + langValue);
            return langValue;
        }
        return null;
    }
    
}