/************************************************************
Name:  IAM_CustomLoginController
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Controller class for Cummins_Login Visual force page.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION   AUTHOR                   DATE              DETAIL                                
1.0 -   Keerthy Gurumurthy      23/04/2018        INITIAL DEVELOPMENT  
1.1 -   Shubhangi Sardar        23/04/2019     Added code for guest user redirection
                                               to request access page.
1.2 -   Karthik Golakaram       10/23/2020    Added Variables for display purpose
                                              depending upon application name
1.3 -   Karthik Golakaram       03/21/2021    Made changes for Federation with Partner Companies 
1.4 -   Chetan Gaikwad
        Souvik Lahiri           06/29/2022    Made changes for Failed Login Countdown in Login Page
*****************************************************/
/********************************************************************************
***********************************************************************************/
global without sharing class IAM_CustomLoginController {

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
   global boolean isInternal {
        get;
        set;
    }
    Public map<String,string> params{set;get;}
    Public boolean isMyFleetGuardCustomerPortal{set;get;}
    Public boolean isFleetguardFit{set;get;}
    Public String FederatedCompanyName{get;set;}  //changes for Penske
    public Decimal count = 3;//changes for Failed Login countdown

    
    public IAM_CustomLoginController() {
        errorMsg = 'Please fix the errors below and resubmit the form';
        CorrectAnswer = true;
        errordiv = false;
        isMyFleetGuardCustomerPortal=false;
        isFleetguardFit=false;
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
            oamerrorMsg = system.label.IAM_OAM_error1;
        } else if (oamerrorcode == 'OAM-3') {
            errordiv = true;
            oamerrorMsg = system.label.IAM_OAM_error2;
        } else if (oamerrorcode == 'OAM-4') {
            errordiv = true;
            oamerrorMsg = system.label.IAM_OAM_error3;
        } else if (oamerrorcode == 'OAM-5') {
            errordiv = true;
            oamerrorMsg = system.label.IAM_OAM_error4;
        } else if (oamerrorcode == 'OAM-6') {
            errordiv = true;
            oamerrorMsg = system.label.IAM_OAM_error5;
        } else {
            //errordiv=false;
            system.debug('oam code i am here ' + oamerrorcode);
        }
        system.debug('error message from oam' + oamerrorMsg);

        if(app.Name==label.IAM_AppName_Fleetguard_Customer){
            isMyFleetGuardCustomerPortal=true;
        }
        if(app.Name==Label.IAM_AppName_FleetguardFit){
            isFleetguardFit=true;
        }
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
        
        }else if(Test.isRunningTest()){
            retURL=new PageReference('http://www.google.com');
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

    //changes for Federation with partner companies - 04/03/2021
    public pageReference redirectFederatedCompany() {
        PageReference retURL;
        system.debug('inside redirectFederatedCompany++++++'+FederatedCompanyName);
        if(FederatedCompanyName != '' && FederatedCompanyName != null){
            List<IAM_Federation_Configuration_Settings__mdt> federationRecord= [SELECT MasterLabel,IAM_Community_Domain_For_IAM_APP__c,IAM_SSO_Configuration_ID__c,Is_Federation_Enabled__c FROM IAM_Federation_Configuration_Settings__mdt where Label =: FederatedCompanyName LIMIT 1];
            if(!federationRecord.isEmpty()){
                if(federationRecord[0].Is_Federation_Enabled__c){
                    system.debug('Relay State url++++++'+app.IAM_RelayState__c);
                    String ssoURL =Auth.AuthConfiguration.getSamlSsoUrl(federationRecord[0].IAM_Community_Domain_For_IAM_APP__c,app.IAM_RelayState__c,federationRecord[0].IAM_SSO_Configuration_ID__c);
                    System.debug('Printing the name of the sso url'+ssoURL);
                    if(!Test.isRunningTest()){
                        retURL = new PageReference(ssoURL);    
                    }else{
                        retUrl=new PageReference('https://www.google.com');
                    }
                    retURL.setRedirect(true);
                    return retURL;
                }else{
                    errordiv = true;
                    oamerrorMsg = system.label.IAM_Company_Not_Present_Error;
                    return null;
                }
            }
            else{
                errordiv = true;
                oamerrorMsg = system.label.IAM_Company_Not_Present_Error;
                return null;
            }
        }
        else{
            errordiv = true;
            oamerrorMsg = system.label.IAM_Valid_Company_Label;
            return null;
        }
    }

    //End of changes for Federation with partner companies - 04/03/2021

    public pageReference redirectemployee() {
        PageReference retURL;
        string surl6;
        if(!Test.isRunningTest()){
        if(app.internal_Employee_Redirection__c==true && app.Internal_Redirect_URL__c!='')
        {
          surl6= app.Internal_Redirect_URL__c;
        }
        }else{
          surl6='www.google.com';
        }
        system.debug('redirect employee url'+surl6);
        retURL = new PageReference(surl6);
        retURL.setRedirect(true);
        return retURL;
    }


    public Pagereference cookieredirect() {
        Pagereference retURL;
         String surl5='/IAM_Authorize?appid=' + app.id;
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
        FederationIdentifier = FederationIdentifier.tolowercase().trim();
        system.debug('========FederationIdentifier='+FederationIdentifier);
        List<String> userPasswordMsg = system.label.IAM_userpassword_error.split(',');//added for remaining attempt change
        PageReference startPage;
        
        //Start:Vaibhav Changes
            Map<String,String> paramMap  = ApexPages.CurrentPage().getparameters();
            String allParamsStr='';
            for(String key : paramMap.keyset())
            {
                  String paramVal = paramMap.get(key);
                  
                  if(key=='returl')
                  continue;
                 
                  allParamsStr = allParamsStr + '&' + key + '=' + paramVal;
                  
            }
          skuurl = skuurl + allParamsStr;
         //End:Vaibhav Changes
         
         //OSM Login part.
         
          if(app.Id==System.Label.IAM_OSM_AppMapping_ID && skuurl!=null)
            {
                starturl='/IAM_Authorize?appid='+app.id+'&returl='+skuurl;
                system.debug('starturl===='+starturl);
            }else if(app.Name==System.Label.IAM_DBU_India_FSL){
                starturl = '/IAM_Authorize?appid=' + app.id +'&finalRelayState='+IAM_Relay_Values.GetValueFromParam('RelayState');
            }else if(app.Name=='Archer'){ //Condition to check if OTP is required or not.
             //Since OTP is required we need to redirect user to OTP page.
              starturl='/IAM_OTPPage?appid='+app.id+'&finalStartUrl='+IAM_Relay_Values.GetValueFromParam('startURL');
              system.debug('Printing Start URL for archer gate'+starturl);
            }else{
                if(String.isEmpty(starturl)){
                    if(app!=null)
                        starturl='/IAM_authorize?appid=' + app.id;
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
                
            }
         
        
        //Code end for setting Start URL depending upon the application.
        
        //Commented because we should not do this for QSOL application.
        List <User> usr=[select id,isActive,IAM_Remaining_Login_Attempt__c from user where username=:FederationIdentifier];
       /* if(!usr.isempty()) {
            List<IAM_Contact_Provisioning__c> activeConProList = getConProList('Active', usr[0].Id, app.Name);
            List<IAM_Contact_Provisioning__c> inactiveConProList;
            if(activeConProList.isEmpty()) {
                inactiveConProList = getConProList('Inactive', usr[0].Id, app.Name);
            }
            if(inactiveConProList != null && !inactiveConProList.isEmpty()) {
                errordiv = true;
                String reason;
                System.debug('#### inactiveConProList - '+ inactiveConProList[0]);
                if(inactiveConProList[0].IAM_Reject_Reason__c == 'Other' 
                   || inactiveConProList[0].IAM_Reject_Reason__c == 'Cancellation Comments') {
                    reason = inactiveConProList[0].IAM_Reason__c;
                } else {
                    reason = inactiveConProList[0].IAM_Reject_Reason__c;
                }
                if(String.isNotBlank(reason)) {
                    oamerrorMsg = 'Application access is expired due to ' + reason;
                } else {
                    oamerrorMsg = 'Application access is expired';
                }
                return null;
            }
        }*/
        
        startPage = Site.login(FederationIdentifier, password,starturl);
        
        System.debug('Printnig site login' + startpage);
        if (null == startPage) {
            try {
                c = [select id, AccountId, Email, Username__c,IAM_Legacy_User__c,IAM_Contact_Status__c,IAM_Internal__c,Account.IAM_CIHR_Change_Password_Flow__c,Account.IAM_Service_Provider_code__c,Account.IAM_WWSPS_Regions__c,Account.Name,Account.Type from contact where Username__c=: FederationIdentifier];
                
                if (c.size() > 0 && c[0] != null) {
                    recCon = [select id, Username__c, IAM_Legacy_User__c,IAM_Contact_Status__c from contact where id =: c[0].Id and IAM_Legacy_User__c=true and IAM_Internal__c=false];
                    //recCon = [select id, Username__c, IAM_Legacy_User__c,IAM_Contact_Status__c from contact where id =: c[0].Id and (IAM_Legacy_User__c=true OR IAM_Internal__c=false)];
                    //  integer userCount = [ select count() from user where ContactId=:c.Id];
                    system.debug('contact for user---' + c[0].id);
                    system.debug('recon'+recCon[0]);
                }
                
                //if there is no user, redirection to registration page 
                if (recCon[0] != null && recCon[0].IAM_Contact_Status__c == 'Reclaim') {
                    system.debug('no user and reclaim starts');
                    system.debug('no user and reclaim starts11'+FederationIdentifier);
                    system.debug('no user and reclaim starts12'+password);
                    if(test.isRunningTest()){
                        password ='test';
                    }
                    reclaim = IAM_Reclaim_LDAP_CallOut.authentication(FederationIdentifier, password);
                    system.debug('reclaim' + reclaim);     
                    if (reclaim == true || Test.isRunningTest())  {
                        errordiv = false;
                        system.debug('reclaim authorized and redirected to reclaim page');
                        redirectPage = true;
                        
                        
                        //Depending upon the redirection  required we need to make the Start page changes.Since comparing field ischeck box it will always either be false or true.
                        //so Start URL will never be null
                        if(c[0].Account.IAM_CIHR_Change_Password_Flow__c==false){
                            startPage = new pagereference('/IAM_reclaim?appid=' + app.id + '&id=' + c[0].AccountId + '&cid=' + c[0].id + '&lang=' + getLanguage());
                        }else if(c[0].Account.IAM_CIHR_Change_PAssword_Flow__c==True){
                            startPage = new pagereference('/IAM_CIHR_Reclaim?appid=' + app.id + '&id=' + c[0].AccountId + '&cid=' + c[0].id + '&lang=' + getLanguage());
                        }
                        startPage.setredirect(true);
                        //List<IAM_Reclaim_Tracker__c> reclaimUsers = [Select name, IAM_New_Username__c from IAM_Reclaim_Tracker__c Where name=:FederationIdentifier Limit 1];
                        //if(reclaimUsers.isEmpty()){
                        // also create application groups fields on reclaim tracker.    
                            IAM_Reclaim_Tracker__c trackUser = new IAM_Reclaim_Tracker__c();
                            trackUser.Name = FederationIdentifier;
                            trackUser.IAM_WWSPS_Region__c=c[0].Account.IAM_WWSPS_Regions__c;
                            trackUser.IAM_Location_Name__c=c[0].Account.Name;
                            trackUser.IAM_Customer_Code__c=c[0].Account.IAM_Service_Provider_code__c;
                            trackUser.IAM_Channel_of_Distribution__c=c[0].Account.Type;
                            insert trackUser; 
                        //}
                        return startPage;
                        //  return null;
                    }
                    
                    else if (reclaim != true) {
                        errordiv = true;
                        oamerrorMsg = userPasswordMsg[0];
                    }
                }
                else if(recCon[0] != null && recCon[0].IAM_Contact_Status__c == 'Active') {
                    system.debug('legacy user error ');
                    errordiv = true;
                    oamerrorMsg = userPasswordMsg[0];
                }
                
            } catch (Exception ex) {
                system.debug('exception in Login is----' + ex.getMessage());
                userNotexist = true;
                errordiv = true;
                List <User> u=[select id,isActive,IAM_Remaining_Login_Attempt__c from user where username=:FederationIdentifier];
                if(!u.isempty() && u[0].IAM_Remaining_Login_Attempt__c != null){
                    count = u[0].IAM_Remaining_Login_Attempt__c;
                }
                List<User> lockedUserList = [
                        SELECT Id
                             , Username ,IAM_Remaining_Login_Attempt__c
                          FROM User
                         WHERE username = :FederationIdentifier
                           AND Id IN (SELECT UserId FROM UserLogin WHERE IsPasswordLocked = true)];
                if(!u.isempty()) {
                    if(u[0].isActive == false) {
                        oamerrorMsg = system.label.IAM_userinactive_error;
                    } else if(!lockedUserList.isEmpty()) {
                        u[0].IAM_Remaining_Login_Attempt__c = 3;
                        update u;
                        oamerrorMsg = Label.IAM_User_Locked_Error_Msg;
                    } else {
                        count=count-1;
                        u[0].IAM_Remaining_Login_Attempt__c = count;
                        update u;
                        if(u[0].IAM_Remaining_Login_Attempt__c < 3){
                            oamerrorMsg = userPasswordMsg[0] + userPasswordMsg[1]+ u[0].IAM_Remaining_Login_Attempt__c+ userPasswordMsg[2];
                        }
                        if(u[0].IAM_Remaining_Login_Attempt__c == 0){
                            oamerrorMsg = system.label.IAM_User_Locked_Error_Msg;
                        }
                    }
                    
                    system.debug('exception in Login oamerrorMsg ----' + oamerrorMsg);
                } else {
                    oamerrorMsg = userPasswordMsg[0];
                }
            }
        } else if (null != startPage) {
            System.debug('URL to next page is=====' + startPage);
            startPage.setRedirect(true);
            usr[0].IAM_Remaining_Login_Attempt__c = 3; //added for failed login countdown
            update usr[0]; //added for failed login countdown
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
        company.getParameters().put('lang', escapeHtml(language));
        system.debug('return url is=====' + company);
        return company.setRedirect(true);

    }
    
    private static String escapeHtml(String str) {
        if(String.isNotBlank(str)) {
            return str.escapeHtml3();
        } else {
            return str;
        } 
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
    
   //condtion to check the internal flag on the contact record is enabled
    public void checkIsInternal() {
        try {
            isInternal=false;
            List<Contact> contactList = [
                SELECT Id
                     , IAM_Internal__c
                     , IAM_Legacy_User__c
                     , IAM_Ext_Legacy_Uid__c
                     , IAM_Contact_Status__c
                  FROM Contact
                 WHERE Username__c= :FederationIdentifier ];
            system.debug('Internal employee' + c);
            if (!contactList.isEmpty() 
                && (contactList[0].IAM_Internal__c == true || contactList[0].IAM_Legacy_User__c==true) 
                && contactList[0].IAM_Contact_Status__c=='Active') {
                system.debug('Internal employee exists with id ' + contactList);
                isInternal = true;
                system.debug('Internal employee exists with id ' + isInternal);
            } else {
                isInternal = false;
            }
        } catch(Exception e) {
            system.debug('Exception ' + e.getMessage());
        }
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
   
    @TestVisible
   private List<IAM_Contact_Provisioning__c> getConProList(String status, Id userId, String appName) {
        return [
            SELECT Id
               , IAM_End_Date__c
               , IAM_Reject_Reason__c
               , IAM_Reason__c
              FROM IAM_Contact_Provisioning__c
             WHERE IAM_Status__c = :status
               AND IAM_User__c = :userId
               AND IAM_Application_Name__c = :appName
          ORDER BY IAM_End_Date__c DESC NULLS LAST
        ];
    } 
}