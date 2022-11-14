/**********************************************************************************************************************************
***********************************************************************************************************************************
Class Name: IAM_CustomLoginController
Description: This class is used for login into application after user name and password verified. After login, this will invoke redirect class for 
             redirect to site admin page if user had the access to application. Other wise it is redirect to Request access page.
************************************************************************************************************************************
***********************************************************************************************************************************/
global without sharing class IAM_CustomLoginController_RLS {

    public String pageMessage { get; set; }
    public String errorMsg {
        get;
        set;
    }
    public string cookievalue {
        get;
        set;
    }
    public String oamerrorMsg {
        get;
        set;
    }
    Apexpages.StandardController controller;
    public String username {
        get;
        set;
    }
    public String FederationIdentifier {
        get;
        set;
    }
    public boolean userNotexist {
        get;
        set;
    }
    public String password {
        get;
        set;
    }
    Public App_Mapping__c app {
        get;
        set;
    }
    Public string selectedLanguage {
        set;
        get;
    }
    integer m;
    string starturl;
    public String currentRecordId {
        get;
        set;
    }
    public String requestId {
        get;
        set;
    }
    public String en {
        get;
        set;
    }
    public boolean redirectPage {
        get;
        set;
    }
    DateTime NextReload;
    //Long SecondsRemaining;
    Integer RefreshIntervalSeconds = 15;
    public String Skuid {
        get;
        set;
    }
    public String Skuurl {
        get;
        set;
    }
    public boolean reclaim {
        get;
        set;
    }
    public String oamerrorcode {
        get;
        set;
    }
    public String r {
        get;
        set;
    }
    public boolean errordiv {
        get;
        set;
    }
    public String resourceurl {
        get;
        set;
    }
   
    Public map<String,string> params{set;get;}
    
    public IAM_CustomLoginController_RLS() {
        errorMsg = 'Please fix the errors below and resubmit the form';
        CorrectAnswer = true;
        isInternal = false;
        errordiv = false;
        
        String resource='';
        String decodedUrl='';
        
        //end of app specific code in constructor.
        
        params=ApexPages.CurrentPage().getparameters();
        System.debug('Printing all parameters'+params);
        app=IAM_Login_Utillity.getAppMapping(params);
        System.debug('Printing application returned from app mapping'+app);
            
        
        String userID = ApexPages.CurrentPage().getparameters().get('UID');
        //currentRecordId = ApexPages.CurrentPage().getparameters().get('appid');
        requestId = ApexPages.CurrentPage().getparameters().get('request_id');
        oamerrorcode = IAM_Login_Utillity.getOAMerrorcodes(params);
        skuurl = ApexPages.CurrentPage().getparameters().get('returl');
        system.debug('returl------' + skuurl);
        system.debug('oamerrorcode------' + oamerrorcode);
        
        System.debug('app names'+app);
        if (oamerrorcode == 'OAM-2') {
            errordiv = true;
            oamerrorMsg = 'Invalid Login attempt';
        } else if (oamerrorcode == 'OAM-3') {
            errordiv = true;
            oamerrorMsg = 'Processing submitted credentials failed for a reason';
        } else if (oamerrorcode == 'OAM-4') {
            errordiv = true;
            oamerrorMsg = 'An authentication exception is raised for a reason.';
        } else if (oamerrorcode == 'OAM-5') {
            errordiv = true;
            oamerrorMsg = 'User account is locked/disabled due to certain conditions. For example, the invalid attempt limit is exceeded.';
        } else if (oamerrorcode == 'OAM-6') {
            errordiv = true;
            oamerrorMsg = 'User exceeded the maximum number of allowed sessions.';
        } else {
            //errordiv=false;
            system.debug('oam code i am here ' + oamerrorcode);
        }
        system.debug('error message from oam' + oamerrorMsg);

    }

    public pageReference redirectBackpage() {
        PageReference retURL;

        if (app.Back_page__c != null) {
            String surl=app.Back_page__c;
            Set<String> whiteListedDomains = new Set<String>();
            whiteLIstedDomains.add(surl);
            retURL = new PageReference(surl);
        }
        retURL.setRedirect(true);
        return retURL;
    }

    public pageReference redirectRegistartionpage() {
        PageReference retURL;
        String surl1;
        string surl2;
        
        if(getLanguage()!=null){
        surl1=app.Footer_text__c + '&lang=' + getLanguage().escapeHtml4();
        surl2=app.Registration_Link__c + '&lang=' + getLanguage().escapeHtml4();
        }
        else
        {
        surl1=app.Footer_text__c ;
        surl2=app.Registration_Link__c ;
        }
            Set<String> whiteListedDomains = new Set<String>();
            whiteLIstedDomains.add(surl1);
            whiteLIstedDomains.add(surl2);
        if (app.Registration_Link__c != null && app.Id == system.label.ABO_appID) {
            retURL = new PageReference(surl1);
        } else if (app.Registration_Link__c != null) {
            retURL = new PageReference(surl2);
        
        }
        retURL.setRedirect(true);
        return retURL;
    }

    public pageReference redirectinternalpage() {
        PageReference retURL;
        String surl3=app.CMI_Internal_URL__c;
            Set<String> whiteListedDomains = new Set<String>();
            whiteLIstedDomains.add(surl3);
        if (app.CMI_Internal_URL__c != null) {
            retURL = new PageReference(surl3);
        }

        retURL.setRedirect(true);
        return retURL;
    }
    public pageReference redirectforgotpassword() {
        PageReference retURL;
        String surl4=app.forgot_password__c+ getLanguage()+'&username='+FederationIdentifier;
            Set<String> whiteListedDomains = new Set<String>();
            whiteLIstedDomains.add(surl4);
            system.debug('forgot password url'+surl4);
        retURL = new PageReference(surl4);
        retURL.setRedirect(true);
        return retURL;
    }


    public Pagereference cookieredirect() {
        Pagereference retURL;
         String surl5='/IAM_CumminsRedirectPage_new_RLS?appid=' + ApexPages.CurrentPage().getparameters().get('appid');
            Set<String> whiteListedDomains = new Set<String>();
            whiteLIstedDomains.add(surl5);
      
        retURL = new PageReference(surl5);
        retURL.setRedirect(true);
        system.debug('redirection' + retURL);
        return retURL;
    }


    public pagereference p;

    public List < contact > c {
        get;
        set;
    }
    public String userconAnswer {
        get;
        set;
    }
    public List < Contact > recCon;
    global PageReference doLogin() {
        system.debug('login action');
        FederationIdentifier = FederationIdentifier.tolowercase();
        system.debug('========FederationIdentifier='+FederationIdentifier);
       
        PageReference startPage;
       /* if (!string.isempty(currentRecordId)) {
            if (currentRecordId == 'a164C000000JbEV' && skuurl != null) {
                starturl = '/IAM_CumminsRedirectPage_new?appid=' + currentRecordId + '&returl=' + skuurl + '&lang=' + getLanguage();
                system.debug('starturl====' + starturl);
            } else {
                starturl = '/IAM_CumminsRedirectPage_new?appid=' + currentRecordId + '&lang=' + getLanguage();
            }
        } else if (resourceurl != null || resourceurl != '') {
            starturl = '/IAM_CumminsRedirectPage_new?resource_url=' + resourceurl + '&lang=' + getLanguage();
        } else {
            starturl = '/IAM_CumminsRedirectPage_new?appid=' + system.Label.IAM_Default_Appmap + '&lang=' + getLanguage();
        }

        system.debug('starturl====' + starturl);
        
        if(app.OTP_Required__c == true)
        { 
            String email = FederationIdentifier.replace('.iamdev','');
            User u = [select id from user where email =: email];
            //String url = starturl.replace('IAM_CumminsRedirectPage_new','IAM_OTPPage');
           starturl = '/IAM_OTPPage?appid=' + currentRecordId  + '&lang=' + getLanguage()+ '&uID=' + u.id;
           //pagereference otptPage = new pagereference('www.Google.com');
            //pagereference otptPage = new pagereference(url + '&Email=' + FederationIdentifier + '&uID=' + u.id);
            //otptPage.setredirect(true);
            //return otptPage;
        }*/
       // startPage = Site.login(FederationIdentifier, password, starturl);
       
       
      
       
       //Instance specific code where if we do not have Auth Schema configured at OAM end.
       if(String.isEmpty(starturl)){
         starturl='/IAM_CumminsRedirectPage_new_RLS?appid=' + ApexPages.CurrentPage().getparameters().get('appid'); 
       }
       //End of the code 
       
       //Setting up Start URL according to the type of the app.Since for SAML application we will have app id after authorization page. But where as in 
       //Web gate based applications we will not have any app id attribute.
       if(resourceurl != null){
            starturl=IAM_Relay_Values.GetValueFromParam('startURL')+'&appid='+app.id;
            system.debug('Printing Start URL for Web gate'+starturl);
       }else if(!String.isEmpty(IAM_Relay_Values.GetValueFromParam('startURL'))){
             
              starturl=IAM_Relay_Values.GetValueFromParam('startURL');
              system.debug('Printing Start URL for Web gate'+starturl);
           
       }
       //Code end for setting Start URL depending upon the application.
       
       startPage = Site.login(FederationIdentifier, password,starturl);
        
        System.debug('Printnig site.login' + startpage);
        if (null == startPage) {
            try {
                c = [select id, AccountId, Email, IAM_Cummins_login_ID__c,Username__c,IAM_Legacy_User__c,IAM_Contact_Status__c from contact where Username__c =: FederationIdentifier];
 
                if (c.size() > 0 && c[0] != null) {
                    recCon = [select id, IAM_Cummins_login_ID__c,Username__c, IAM_Legacy_User__c,IAM_Contact_Status__c from contact where IAM_Contact_Status__c = 'Reclaim' and id =: c[0].Id and IAM_Legacy_User__c=true];
                      //  integer userCount = [ select count() from user where ContactId=:c.Id];
                    system.debug('contact for user---' + c[0].id);
                }
                //if there is no user, redirection to registration page 
                if (recCon != null) {
                    system.debug('no user and reclaim starts');
                   // reclaim = IAM_Reclaim_LDAP_CallOut.authentication(FederationIdentifier, password);
                    reclaim=false;
                    system.debug('reclaim' + reclaim);
                    if (reclaim == true) {
                        errordiv = false;
                        system.debug('reclaim authorized and redirected to reclaim page');
                        redirectPage = true;
                        startPage = new pagereference('/IAM_reclaim?appid=' + app.id + '&id=' + c[0].AccountId + '&cid=' + c[0].id + '&lang=' + getLanguage());
                        startPage.setredirect(true);
                        return startPage;
                        //  return null;
                    }
                }
                if (reclaim != true) {
                    errordiv = true;
                    oamerrorMsg = 'Your login attempt has failed. Make sure the username and password are correct.';
                }
                return null;
            } catch (Exception ex) {
               system.debug('exception in Login is----' + ex.getMessage());
               userNotexist = true;
               errordiv = true;
                User u=[select id,isActive from user where username=:FederationIdentifier];
                if(u.isActive == false)
                {
                oamerrorMsg = 'Your login attempt has failed. User is inactive.';
                }
                else
                {
                oamerrorMsg = 'Your login attempt has failed. Make sure the username and password are correct.';
                }
                 system.debug('exception in Login oamerrorMsg ----' + oamerrorMsg);
               
            }
        } else if (null != startPage) {
            System.debug('URL to next page is=====' + startPage);
            startPage.setRedirect(true);
        }
        system.debug('starturl errorMsg  ====' + errorMsg);
        return startPage;

    }

    public pageReference Changelanguage() {

        string language = Apexpages.currentpage().getParameters().get('selectedLanguage');
        System.debug('Selected language is=====' + language);
        System.debug('Present vf page url is ===' + ApexPages.currentPage().getHeaders().get('referer'));
        String PresentURL = ApexPages.currentPage().getHeaders().get('referer');
        PageReference company = new pageReference(PresentURL);
        System.debug('Current page=====' + company);
        company.getParameters().put('lang', language);
        system.debug('return url is=====' + company);
        return company.setRedirect(true);

    }


    public void approvedclosePopup() {
        redirectPage = false;
    }

    public boolean CorrectAnswer {
        get;
        set;
    }
  /*  public Pagereference redirectToRegistration() {
        if (userconAnswer == c[0].IAM_Challange_Answer__c) {
            CorrectAnswer = true;

            return p;
        } else if (userconAnswer != c[0].IAM_Challange_Answer__c || c[0].IAM_Challange_Answer__c == '' || null == c[0].IAM_Challange_Answer__c) {
            CorrectAnswer = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Wrong answer.Try again or cancel the process. Contact admin'));

        }
        return null;
    }*/
    public boolean isInternal {
        get;
        set;
    }
    //condtion to check the internal flag on the contact record is enabled
    public void checkIsInternal() {
        try {
            String userId = Apexpages.currentpage().getParameters().get('userId');
            Contact c = [select id, IAM_Internal__c,IAM_Ext_Legacy_Uid__c,IAM_Contact_Status__c from contact where Username__c= :FederationIdentifier ];
            system.debug('Internal employee' + c);
            if (c.IAM_Internal__c == true && c.IAM_Legacy_User__c==true && c.IAM_Contact_Status__c=='Active') {
                system.debug('Internal employee exists with id ' + c);
                isInternal = true;
                system.debug('Internal employee exists with id ' + isInternal);
            }
        } catch (exception ex) {}
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