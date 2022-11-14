/*************************************************************
Name:  IAM_NewAccountRegistration
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_NewAccountRegistration class.
This class is used for register the new account. and this class is creates the Account, Contact, Account provisoing and Contact provsioning records
for users. Based on application settings in App mapping object, we have given the access to users. And we are using this class in New Account and
Existing account registration. In new registration flow, we are creating all the records and sending to approval if approval needed on application.
In Existing account registration, we are not creating the Account, Just provding the access to contact and sending to approval. After registration is completed
then we are redirecting to confirmation page.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE                  DETAIL                                
1.0 -    Keerthy Gurumurthy     23/04/2018        INITIAL DEVELOPMENT 
1.1 -    Sushma Rajput          08/13/2020        Changes for INC0365700,INC0303446
1.2 -    Karthik Golakaram      09/02/2020        Changes for Reclaim Changes.
1.3 -    Nishant Verma          02/10/2020        Changes for fluidwtach.
1.4 -    Shubhangi Sardar       12/03/2020        Added NPBU Diagnostic Expration
1.5 -    Karthik Raj Golakaram  04/15/2021        Added changes to skip trigger execution for Guidan Mobile application
1.6 -    Karthik Raj Golakaram  06/01/2021        Made Changes for Registration issues for OSM and added loggin mechnanisim.
1.7 -    Anupam Adhikari        09/22/2021        Added RSW changes for CIHR accounts.
1.8 -    Anupam Adhikari        12/07/2021        Added chnages for Conn Sol as prod issue 101 SOQL error.
1.9 -    Chetan Gaikwad         03/25/2022        SP code validation added for numeric and duplicate code
2.0 -    Sandeep Vuyyuru        17/01/2022        Added chnages for Marketplace/Guidanz as prod issue 101 SOQL error.
2.1 -    Suresh Rathod          04/18/2022        Added changes for Guidanz Service Portal enhancements  
2.2 -    Chetan Gaikwad         07/26/2022        Powerspec code optimization
*****************************************************/

public without sharing class IAM_NewAccountRegistration{
    private static boolean run = true;//added by Sandeep for marketplace/Guidanz 101 soql registration issue
    Id AccownerId;
    public Boolean isMarketPlaceApp {get;set;}
    public String isRepairEngine {get;set;}
    public String isOwnVehicle {get;set;}
    public String appName {get;set;}
    public boolean isAccTypeShow{get;set;} //property for hide/show account type
    public String Typeis{get;set;} //property for Account type radio button
    public boolean acctypeRadio{get;set;}//Property to set display type 
    public boolean isEdqAddress{get;set;} //property for Identifying if Valid adderess is selected from EDQ table not working properly still workking on it
    public boolean is_ind_user{get;set;}//property for diffrentiate indivial accoount
    public IAM_EDQ_LocationResParser EDQinfo{set;get;}//variable to store EDQ address information
    public boolean EDQpop{set;get;}//to display EDQ popup
    public boolean byPassEDQ{set;get;}//to proceed registration even EDQ throw exception
    boolean insacc;//to check if the account has to be created
    public String EDQCityS{set;get;}//variable to assign city got from EDQ
    public String EDQStreetS{set;get;}//variable to assign EDQ Street
    public String EDQStreet2S{set;get;}//variable to assign EDQ Street
    public String EDQStateS{set;get;}//variable to assign EDQ State
    public string EDQCountryS{set;get;}//variable to assaign EDQ country
    public String EDQzipS{set;get;}//variable to assign EDQ zip
    public String EDQCityR{set;get;}//variable to assign city got from EDQ
    public String EDQStreetR{set;get;}//variable to assign EDQ Street
    public String EDQStreet2R{set;get;}//variable to assign EDQ Street
    public String EDQStateR{set;get;}//variable to assign EDQ State
    public string EDQCountryR{set;get;}//variable to assign EDQ country
    public String EDQzipR{set;get;}//variable to assign EDQ zip
    public String EDQVerificationCode{set;get;}//variable to assign EDQ VerificationCode
    public String EDQVerifiedFlag{set;get;}//variable to assign EDQ VerifiedFlag
    public String EDQAddressType{set;get;}//variable to assign EDQ zip
    public boolean dupAccountselected{get;set;} //property for Identify duplicate accouont selected from dplicate account table
    Public List<Account> duplicateRecords{get;set;}//property for storing duplicate account records
    private final ApexPages.StandardController controller;
    public boolean hasDuplicateResult{get;set;} //property for storing duplicate account result
    public string SelectedAddress{set;get;}//Variable to capture Selected address
    public string Telematicsserviceprovider{set;get;}//variable for DA TSP
    public boolean isReadonlyAcc{get;set;} //property for storing readOnly if page is launch from invite user button.
    Public String userNameReclaim{get;set;}//variable to store username value for recalim process
    Public String useremailReclaim{get;set;}//variable to store email value for recalim process
    public String errorContat{get;set;} //property for storing error message during contact insertion.
    public boolean errordiv{get;set;} // to show error msg
    public boolean isRSWsection{get;set;} //property for RSW fields section
    public String rswPreferCode{get;set;} //property for storing prefer serive code.
    public String rswAdditionalCode{get;set;} //property for storing additional code
    public String rswAdditionalCode1{get;set;} //property for storing additional code
    public String rswAdditionalCode2{get;set;} //property for storing additional code
    public String rswAdditionalCode3{get;set;} //property for storing additional code
    public String rswAdditionalCode4{get;set;} //property for storing additional code
    public String rswReason{get;set;} //property for storing reason
    public String rswOtherReason{get;set;} //property for storing other reason
    public String errorPrefercode{get;set;}
    public String errorRswReason{get;set;}
    public String errorAddcode1{get;set;}
    public String errorAddcode2{get;set;}
    public String errorAddcode3{get;set;}
    public String errorAddcode4{get;set;}
    public String errorAddcode5{get;set;}
    public boolean reclaimPopup{get;set;} // for intial pop when page loads first time
    public boolean isPowrspc{get;set;} //property for Occupation list fields section
    public String occupationlist{get;set;} //property for storing Occupation List
    public String erpCustomerCode {get;set;} // To store Customer Number for Guidanz Service Portal
    public String erroroccupationlist{get;set;}
    public List < SelectOption > occpList {set;get;}
    boolean errorContactDup ;
    String approverQueue = null; // store approver queue from app mappings
    Map <String, String> mapCountryCodeToName;
    public List < SelectOption > preferServiceProviders {set;get;}
    public List < SelectOption > reasonsList {set;get;}
    Public void getOccupatioList(){
        /* Get Occupation List */
        occpList = new List < SelectOption >();
        occpList.add(new SelectOption(Label.IAM_None_Option,Label.IAM_None_Option));
        Schema.DescribeFieldResult fieldResult2 = IAM_Contact_Provisioning__c.IAM_Occupation_List__c.getDescribe();
        List<Schema.PicklistEntry> occp = fieldResult2.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : occp)  {           
            occpList.add(new SelectOption(pickListVal.getLabel(), pickListVal.getValue()));
        }
    }
    public void getPreferServicepro(){
        System.debug('Master Code Push');
        preferServiceProviders = new List < SelectOption >();
        preferServiceProviders.add(new SelectOption(Label.IAM_None_Option,Label.IAM_None_Option));
        List<IAM_Application__c> applicationList = new List<IAM_Application__c>();
        List<Account> accAppsList = new List<Account>();
        set<id> accIds = new Set<id>();
        Set<String> setAccCodes = new Set<String>();
        applicationList = [
            SELECT Id
            , IAM_Account_Name__r.id
            , IAM_Application_Name__c
            , IAM_Status__c
            , IAM_Free_Subscription__c
            , IAM_Role__c
            FROM IAM_Application__c
            WHERE IAM_Application_Name__c = :Label.IAM_Rapid_Serve_Web
        ];
        for(IAM_Application__c appAcc : applicationList) {
            accIds.add(appAcc.IAM_Account_Name__r.id);
        }
        accAppsList = [
            SELECT Id
            , Name
            , IAM_Service_Provider_Code__c
            , CMI_Account_Status__c
            FROM Account
            WHERE IAM_Service_Provider_Code__c !=null 
            AND (CMI_Account_Status__c = :Label.IAM_Status_Active 
                 OR CMI_Account_Status__c =:Label.IAM_Expired) 
            AND id IN :accIds 
            LIMIT 1000
        ]; 
        for(Account accCode : accAppsList) {
            setAccCodes.add(accCode.IAM_Service_Provider_Code__c);     
        } 
        for(string code : setAccCodes) {
            preferServiceProviders.add(new SelectOption(code,code));
        }                                        
    }
    
    public void getReasons(){
        reasonsList = new List < SelectOption >();
        reasonsList.add(new SelectOption(Label.IAM_None_Option,Label.IAM_None_Option));
        Schema.DescribeFieldResult fieldResult = IAM_Contact_Provisioning__c.IAM_RSW_Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple)  {           
            reasonsList.add(new SelectOption(pickListVal.getLabel(), pickListVal.getValue()));
        }     
    }
    
    public String currentRecordId {get;set;}
    public Contact newCon {get;set;} 
    public string regionerror {set;get;}
    Public Account acc {get;set;}
    public string errorAccountName {set;get;}
    public string errormarket{set;get;}
    public boolean IsConAlreadyExist {set;get;}
    public boolean IsConExitForDiffAcc {set;get;}
    public string errorContactPhone {set;get;}
    public string errorPostalcode {set;get;}
    public string errorAddress {set;get;}
    public string errorCity {set;get;}
    public string errorccfname{set;get;}
    public string errorothertsp{set;get;}
    public string errorccemail{set;get;}
    public string errorcclname{set;get;}
    public string errorContactFirstName {set;get;}
    public string errorContactLastName {set;get;}
    public string errorContactEmail {set;get;}
    public string errorContactEmail1 {set;get;}
    public string errorStateerror {set;get;}
    public string errorStateCountry {set;get;}
    public string errorContactEmail2 {set;get;}
    public Boolean ins {set;get;}
    public Boolean upd {set;get;}
    public string emailerrorstatus {set;get;}
    public List < User > lstUser {set;get;}
    String siteadminval;
    Boolean osmEnabled;
    Account selectedAccount;
    
    public String getsiteadminval() {
        return siteadminval;
    }
    public Map < String, Account > mapZipToAcc {get;set;}
    Public App_Mapping__c app {get;set;}
    Boolean existingAccCheck;
    Boolean AccConStatus;
    
    public void setsiteadminval(String siteadminval) {
        this.siteadminval = siteadminval;
    }
    Map<String,String> App_application;
    Map<String,String> App_role;
    /* Items for Account Type readio button */
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.IAM_Company_Label, Label.IAM_Company_Label));
        options.add(new SelectOption(Label.IAM_Individual, Label.IAM_Individual)); 
        return options;
    }
    
    /* Radio button values for EDQ address selection */
    public List<SelectOption> getAddress() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.IAM_Given, Label.IAM_Given));
        options.add(new SelectOption(Label.IAM_Cleansed_Address_Label, Label.IAM_Cleansed_Address_Label)); 
        return options;
    }
    
    /* Radio button values for Marketplace app questions */
    public List<SelectOption> getAnswers() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.IAM_Yes_Label, Label.IAM_Yes_Label));
        options.add(new SelectOption(Label.IAM_No_Label, Label.IAM_No_Label)); 
        return options;
    }
    
    List<String> characters;
    public String input {get; set;}
    public String result {get; set;}
    String char1;
    String char2;
    String char3;
    String char4;
    String char5;
    String char6;
    
    /* This methods returns a random number between 0 and the size of the character list */
    public Integer randomNumber() {
        Integer random = Math.Round(Math.Random() * characters.Size());
        if(random == characters.size()){
            random--;
        }
        if(Test.isRunningTest()) {
            return 0;       
        } else {        
            return random;      
        }
        
    }  
    
    /*Here we have 6 get methods that return 6 random characters to the page.For chars 1,3, and 5 (the black 
* characters) we are saving the the values so that we can compare them with the user's input */
    
    public String getChar1(){
        input = '';
        char1 = characters[randomNumber()];
        return char1;
    }
    
    public String getChar2() {
        char2 = characters[randomNumber()];
        return char2;
    }
    
    public String getChar3() {
        char3 = characters[randomNumber()];
        return char3;
    }
    
    public String getChar4(){
        char4= characters[randomNumber()];
        return char4;
    }
    
    public String getChar5(){
        char5 = characters[randomNumber()];
        return char5;
    }
    
    public String getChar6(){
        char6= characters[randomNumber()];
        return char6;
    } 
    
    // Constructor intiallization 
    public IAM_NewAccountRegistration(ApexPages.StandardController controller){
        erpCustomerCode=null;
        characters = new List<String>{'1','2','3','4','5','6','7','8','9','0'};
            reclaimPopup = true;
        errordiv = false;
        errorContat = null;
        existingAccCheck = false;
        AccConStatus = false;
        errorContactDup = false;
        duplicateRecords = new List<account>();
        List<Account> lstAccounts = getNearestDistributorAcc(ApexPages.currentPage().getParameters().get('id'));
        if(!lstAccounts.isEmpty()){
            acc = lstAccounts[0];
            isReadonlyAcc = true;
            existingAccCheck = true;
        }else {
            acc = new Account();
            isReadonlyAcc = false;
            existingAccCheck = false;
        }
        this.controller = controller;
        List<Contact> lstContacts = getContactList(ApexPages.currentPage().getParameters().get('cid'));
        
        if(!lstContacts.isEmpty()) {
            newCon = lstContacts[0];
            if(validateUserName(newcon.Username__c)){
                if(label.css_org=='.cso'){
                    userNameReclaim = newcon.Username__c;
                }else{
                    userNameReclaim = newcon.Username__c+label.css_org;
                }
           }else{
               if(label.css_org=='.cso'){
                   userNameReclaim = newcon.Username__c+'@cmiuser.com';
               }else{
                   userNameReclaim = newcon.Username__c+'@cmiuser.com'+label.css_org; 
               }    
            }
            
            //useremailReclaim = newcon.Email; //remove auto population of email on reclaim page - Chetan Gaikwad 09/13/2021
            isReadonlyAcc = true;
        } else {
            newCon = new Contact();
            isReadonlyAcc = false;
        }
        Typeis = Label.IAM_Company_Label;
        dupAccountselected = false;
        hasDuplicateResult = false;
        is_ind_user = false;
        EDQpop = false;
        byPassEDQ = false;
        Telematicsserviceprovider='';
        currentRecordId  = ApexPages.currentPage().getParameters().get('appid');
        
        if (String.isNotBlank(currentRecordId)){
            app = getApp(currentRecordId);
        }else{
            app = getApp(Label.IAM_Default_Appmap);
        }
        appName = app.Name;
        if(app.Name == Label.IAM_AppName_ConnectedSolutions) {
            isAccTypeShow = false;
        } else {
            isAccTypeShow = true;
        }
        
        /* Set default values for Marketplace/OSM questions*/
        isRepairEngine = Label.IAM_No_Label;
        isOwnVehicle = Label.IAM_No_Label;
        
        // render for Power spec only
        if(app.Name == Label.IAM_Power_Specs) {
            isPowrspc = true;
        }else {
            isPowrspc = false;
        }
        
        // for enable/disable RSW section on page
        if(app.Name == Label.IAM_Rapid_Serve_Web) {
            isRSWsection = true;
        } else if(app.Name == Label.IAM_OSM_App_Name) {
            isMarketPlaceApp = true;
            //is_ind_user = true;
        } else {
            isRSWsection = false;
            isMarketPlaceApp = false;
        }     
        /* since we are planning to Display the Radio button the vf page need to make the boolen value true or false 
depending upon the IAM_Registration Type. */
        if(String.isNotBlank(app.IAM_Registration_Type__c)) {
            List<String> registrationType = app.IAM_Registration_Type__c.split(';');  
            if(!registrationType.isEmpty()){
                if(registrationType.size() == 2){
                    acctypeRadio=true;
                }else {
                    acctypeRadio=false;
                    if(registrationType[0] == Label.IAM_Company_Label){
                        is_ind_user=false;
                    }else{
                        is_ind_user=true;
                    }
                }
            }
        }
        mapCountryCodeToName = getCountries();
        getReasons(); 
        getOccupatioList();
        getPreferServicepro();
        osmEnabled = false;
    }
    
    // Action method for Account type raido button
    public void selectOnClick(){
        is_ind_user = Typeis == Label.IAM_Company_Label?false:true; 
    }
    
    public void fetchAnswerOne() {
        System.debug('#### isRepairEngine - '+ isRepairEngine);
        //is_ind_user = true;
        isOwnVehicle = Label.IAM_No_Label;
    }
    
    public void fetchAnswerTwo() {
        System.debug('#### isOwnVehicle - '+ isOwnVehicle);
        //is_ind_user = isOwnVehicle == Label.IAM_Yes_Label ? false : true;
    }
    
    // Action method for Reset button
    public PageReference BusinessTabreset() {
        PageReference pageRef = new PageReference(app.Registration_Link__c);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public Map < String, String > getCountries() {
        Map<String, String> countryCodeNameMap = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Account.BillingCountryCode.getDescribe();
        List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            countryCodeNameMap.put(f.getValue(), f.getLabel());
        }
        return countryCodeNameMap;
    }
    
    /* this for pop up when page is open first time */
    public void closePopup_reclaim() {
        reclaimPopup = false;
    }
    
    /* Return false if captcha is blank or invalid captcha is entered*/
    public Boolean isCaptchaValid() {
        if(input.length() == 0) {
            result = Label.IAM_Missing_Captcha; 
            return false;  
        } else if(input.length() == 6 && input.subString(0,1) == char1 && input.subString(1,2) == char2 && input.subString(2,3) == char3
                  && input.subString(3,4) == char4 && input.subString(4,5) == char5 && input.subString(5,6) == char6){
                      result = '';
                      System.debug('captch result .....  ' + result );
                      return true;
                  } else {          
                      result = Label.IAM_Invalid_Captcha; 
                      System.debug('captch result .....  ' + result );
                      return false; 
                  }
    }
    
    /* this is the action method for registration which create Account/Contact/user and check duplicate account */
    public PageReference send(){
        try {
            approverQueue = null;
            errorContat = null;
            errorDiv = false;
            system.debug('#### in send method  '+acc);
            Boolean callToCreate = false;     
            
            if(String.isNotBlank(app.IAM_approver_queue_name__c)) {
                List<QueueSobject> lstApproverQued = [
                    SELECT Queue.Id
                    FROM QueueSObject
                    WHERE Queue.Name = :app.IAM_approver_queue_name__c.trim()
                    LIMIT 1
                ];
                System.debug('lstApproverQued inside send.....  ' + lstApproverQued );
                if(lstApproverQued != null && !lstApproverQued.isEmpty()){
                    approverQueue = lstApproverQued[0].Queue.Id;
                }
            }
            
            if(isCaptchaValid() && !(isUserExist(newCon.Email))) {            
                callToCreate = true;
            }
            PageReference tnxPageRefExistingAcc = null;
            if(callToCreate) {
                EDQpop = false;
                byPassEDQ = false;
                if(app.Name == Label.IAM_Rapid_Serve_Web) {
                    tnxPageRefExistingAcc = RSWregistration();
                } else if(app.Name.equalsIgnoreCase(Label.IAM_AppName_GuidanzServicePortal)) {
                    tnxPageRefExistingAcc = guidanzServicePortalRegistration();
                } else {
                    tnxPageRefExistingAcc =  createAccount();
                    if(acc != null && this.duplicateRecords != null 
                       && this.duplicateRecords.size() == 0 && String.isBlank(errorContat)) {
                           /*If paid subscription and not osm enabled then it will redirect 
to distributor detail page else it will redirect to confirmation page */
                           tnxPageRefExistingAcc = postRegForNewAccount(acc.id, tnxPageRefExistingAcc);
                       }
                    System.debug('#### tnxPageRefExistingAcc -  ' + tnxPageRefExistingAcc);
                    System.debug('#### errorContat -  ' + errorContat);                 
                }
                
                if(tnxPageRefExistingAcc != null && String.isBlank(errorContat) && !errorDiv){
                    System.debug('Printing set redirect true');
                    tnxPageRefExistingAcc.setRedirect(true);  
                    System.debug('Printing tnxPageRefExistingAcc'+tnxPageRefExistingAcc);       
                    return tnxPageRefExistingAcc;            
                }
                
                if((String.isNotBlank(errorContat) || errorDiv) && this.duplicateRecords != null 
                   && (this.duplicateRecords.size() == 0 || this.duplicateRecords.size() == 1)) {
                       if(isEdqAddress != null) {
                           EDQpop = true;
                       } else if(isEdqAddress == null) {
                           byPassEDQ = true;
                       }
                   }
            }
            return null;
        } catch(Exception e) {
            System.debug('Need to discuss, how to handle' + e.getMessage());
            //IAM_ErrorHandling.IAMerrorCapture('New Or Existing Account Post Registration Error', 'createApplicationContPro() Method', e.getMessage());
            new IAM_ErrorHandling().createLog(new IAM_ErrorHandling.Error('IAM_NewAccountRegistration','AccountInfo=='+String.valueOf(acc)+' Contact Info=='+String.ValueOf(newCon)+' App User is trying to register=='+app.Name,'New Or Existing Account Post Registration Error','Send Method',e));
            show_error_msg(System.Label.IAM_Something_Went_Wrong_Error);
            
            if((String.isNotBlank(errorContat) || errorDiv) && this.duplicateRecords != null 
               && (this.duplicateRecords.size() == 0 || this.duplicateRecords.size() == 1)) {
                   if(isEdqAddress != null) {
                       EDQpop = true;
                   } else if(isEdqAddress == null) {
                       byPassEDQ = true;
                   }
               }
            return null;
        }
    }
    
    public pageReference send_reclaim(){
        String randStr='';
        errordiv = false;
        String returnReclaimResult = '';
        boolean isDupContUser = false;
        if(isExistingUser(userNameReclaim, newCon.id)){
            show_error_msg(userNameReclaim + ' ' + System.Label.IAM_Reclaim_duplicate_user_message);
            return null;
        }
        // Identified if duplicate contact exist with reclaime username
        List<Contact> dupConLst = [select id,IAM_Legacy_User__c from Contact where (Username__c =: userNameReclaim OR IAM_Ext_Legacy_UID__c=:userNameReclaim)];// Made changes on Friday to make sure that we are able ot find the duplicates
        if(!dupConLst.isEmpty()){
            isDupContUser = true;
        }
        System.debug('Printing email'+useremailReclaim);
        system.debug('contact status---'+newcon.IAM_Contact_Status__c);
        if(newcon.IAM_Contact_Status__c==Label.IAM_Reclaim){
            /* 12/03/2020 - Added NPBU Diagnostic Expration */
            List<Contact> lstCont = [select id,firstname,lastname,email,phone,IAM_AppId__c,Account.OwnerId,Account.CMI_Account_Num__c,IAM_Internal__c,Accountid,Account.Name,CMI_Contact_Type__c,Account.Type,
                                     Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c,
                                     Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,
                                     IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,
                                     Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.IAM_Movex_Customer_Code__c,
                                     Account.IAM_WWSPS_Regions__c,IAM_contact_check__c,IAM_Contact_status__c,IAM_swregexpire__c,IAM_NpbuDiagExpire__c,IAM_Legacy_User__c,
                                     IAM_Ext_Legacy_Uid__c,IAM_Site_Admin__c,IAM_Promotion__c, IAM_Person_Type__c, IAM_DN_Value__c  from Contact where id =:newCon.id];   
            system.debug('contact lstCont ---'+lstCont );
            
            if(lstCont != null && !lstCont.isEmpty()){        
                returnReclaimResult = IAM_Reclaim_User_Creation.IAM_Reclaim_Contact_Update(lstCont,userNameReclaim,useremailReclaim,isDupContUser,randStr);
            } 
            
            
        }
        if(returnReclaimResult.equalsignoreCase('OK')){
            String langValue = ApexPages.currentPage().getParameters().get(Label.Language_Parameter);
            System.debug('langValue..12...  '+langValue);
            PageReference tnxPageRef = new pagereference(Label.IAM_Confirmation_Page_Url
                                                         + escapeHtml(currentRecordId)
                                                         + '&' + Label.Language_Parameter + '=' + escapeHtml(langValue) + '&recalim=true' );
            tnxPageRef.setRedirect(true);
            return tnxPageRef;
        }else{
            show_error_msg(System.Label.IAM_Something_Went_Wrong_Error);
            return null;
        }   
    }
    
    /****************************************************************************
Method Name: createAccount()
Description: This method is mainly used for create the Account. In this method we are checking the entered Account is a new account or 
duplicate account based on duplication rules in account object. After creating the account, we are calling the methods for 
create the contact and user.     
**************************************************************************/  
    
    /*public pageReference createAccount(String AccStatus,String conStatus) { */
    public pageReference createAccount() {
        System.debug('#### Country Name - '+ acc.BillingCountry);
        Boolean errofound = false;
        
        try {
            PageReference tnxPageRef;
            system.debug('#### duplicate - '+dupAccountselected);
            system.debug('#### And Status of the EDQ is - '+isEdqAddress);          
            if(!dupAccountselected) {
                if(is_ind_user==true) {
                    acc.Name = newCon.FirstName + newCon.LastName;
                    /*If Account registering is for Individual Account type should be Individual*/
                    acc.Type=Label.IAM_Individual;
                } else {
                    /*If Account registering is for Business Account type should be Business*/
                    if(app.Name == Label.IAM_OSM_App_Name  
                       && isRepairEngine == Label.IAM_Yes_Label
                       && isOwnVehicle == Label.IAM_Yes_Label) {
                           acc.Type=Label.IAM_Account_Type_Fleet;
                       } else {
                           acc.Type=Label.IAM_Customer;
                       }
                }
                
                /* issue#423 seting up flag to by pass GL call during account creation from business admin portal */
                acc.IAM_from_Registration__c = true;
                
                updateAccountEDQAddress();
                
                acc.CMI_Region__c = Label.IAM_CMI_Region_Default;//Defaulting the region but need to discuss with Vamsi 
                acc.IAM_Internal_Account__c = FALSE;
                /* Changed record type to IAM to make satisfy 1A  changes */
                acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                
                if(acc.BillingStreet != null && acc.BillingCity != null && 
                   acc.BillingCountryCode != null && acc.BillingPostalCode != null) {
                       //updateCountryName();
                       acc.BillingCountry = mapCountryCodeToName.get(acc.BillingCountryCode);
                       System.debug('#### acc.BillingCountry - ' + acc.BillingCountryCode + ' ' + acc.BillingCountry);
                       IAM_GL_webservice.makeCallout(acc.BillingStreet, acc.BillingCity, acc.BillingCountryCode, acc.BillingPostalCode);
                       List<Account> parentAccount = new List<Account>();
                       System.debug('#### IAM_GL_webservice.parentDistributorId - '+ IAM_GL_webservice.parentDistributorId);
                       if(IAM_GL_webservice.parentDistributorId != null) {
                           
                           parentAccount = getNearestDistributorAcc(IAM_GL_webservice.parentDistributorId);
                       } else {
                           /* Regional accounts do not contain distributor code, distributor branch code */
                           /* Query regional Account based on entered country. Example : 'Cummins - <BillingCountry>'*/
                           System.debug('#### acc.BillingCountry - ' + acc.BillingCountryCode + ' ' + acc.BillingCountry);                     
                           String accName = 'Cummins - ' + acc.BillingCountry;
                           parentAccount = getDefaultCumminsAcc(accName);
                       }
                       
                       if(!parentAccount.isEmpty()) {
                           
                           /* ABO Code is formula field, it will set based on IAM_WWSPS_Regions__c */
                           acc.ParentId = parentAccount[0].Id;
                           acc.CSS_DistributorCode__c = parentAccount[0].CSS_DistributorCode__c ; 
                           acc.CSS_DBCode__c = parentAccount[0].CSS_DBCode__c ;
                           acc.IAM_WWSPS_Regions__c = parentAccount[0].IAM_WWSPS_Regions__c ;
                           
                           /* Query IAM_OASM_Enabled flag from metadata for parent location*/
                           osmEnabled = isOSMEnabled(parentAccount[0].IAM_Service_Provider_Code__c);
                           System.debug('#### osmEnabled - '+osmEnabled);
                           AccownerId = getParentPrimaryUser(parentAccount[0].Id);
                       }
                       System.debug('#### AccownerId - '+AccownerId);
                       if(AccownerId != null) {
                           acc.ownerId = AccownerId;
                       } else {
                           acc.ownerId = Label.IAM_Default_Account_Owner;
                       }                    
                   }
                
                if(acc.IAM_WWSPS_Regions__c == null){
                    acc.IAM_WWSPS_Regions__c = Label.IAM_US_Canada;
                }
                
                acc.CMI_Account_Status__c = Label.IAM_Status_Active;
                acc.AccountSource='Web';
                insert acc;
                
                if(app.Name == Label.IAM_AppName_ConnectedSolutions) {                
                    list<CMI_TSP__c> lstTSP=new list<CMI_TSP__c>();
                    if(acc.CMI_Telematics_Service_Provider__c!=null && acc.CMI_Telematics_Service_Provider__c!='') {
                        for(string s:acc.CMI_Telematics_Service_Provider__c.split(';')){
                            CMI_TSP__c objTSP=new CMI_TSP__c();
                            if(s=='Other TSP'){
                                objTSP.CMI_Account_Name__c=acc.id;
                                objTSP.CMI_TSP_Name__c=s;
                                objTSP.CMI_Other_TSP_Name__c=acc.CMI_Other_TSP__c;
                            } else{
                                objTSP.CMI_Account_Name__c=acc.id;
                                objTSP.CMI_TSP_Name__c=s;
                            }
                            lstTSP.add(objTSP);
                        }
                        if(!lstTSP.isempty()) {
                            insert lstTSP;
                        }
                    } 
                }
                EDQpop = false;
                byPassEDQ = false;
                String langValue = ApexPages.currentPage().getParameters().get(Label.Language_Parameter);
                
                
                tnxPageRef =new pagereference(Label.IAM_Confirmation_Page_Url + escapeHtml(currentRecordId) + '&' 
                                              + Label.Language_Parameter + '=' + escapeHtml(langValue));
                
                System.debug('#### createAccount tnxPageRef - ' + tnxPageRef);
                
            } else {
                if(selectedAccount != null) {
                    tnxPageRef = dupAccPostRegLogic(selectedAccount.Id);
                }
            }
            return tnxPageRef;
        } catch(Exception e) {
            if(e.getMessage().contains(Label.IAM_Duplicate_Value_Exception)) {
                errorContat = Label.IAM_Contact_Exist_Error;
                return null;
            } 
            
            system.debug('#### errror mesage======='+e.getMessage());
            String errorsplit=e.getMessage();
            if(errorsplit.contains(Label.IAM_Insert_Failed_Exception) && (!dupAccountselected)) {
                Database.SaveResult saveResult = Database.insert(acc, false);
                if (!saveResult.isSuccess()) {
                    List<sObject> dup = new List<sObject>();
                    List<Id> accIdList = New List<Id>();
                    for(Database.Error error : saveResult.getErrors()){
                        System.debug('#### error - '+error);
                        if (error instanceof Database.DuplicateError) {
                            /* Handle the duplicate error by first casting it as a DuplicateError class
This lets you use methods of that class (e.g., getDuplicateResult())*/
                            Database.DuplicateError duplicateError = (Database.DuplicateError)error;
                            Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                            /* Display duplicate error message as defined in the duplicate rule */
                            ApexPages.Message errorMessage = new ApexPages.Message(
                                ApexPages.Severity.ERROR, Label.IAM_Duplicate_Error + duplicateResult.getErrorMessage());
                            this.duplicateRecords = new List<sObject>();
                            /* Return only match results of matching rules that find duplicate records */
                            Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                            /* Just grab first match result (which contains the duplicate record found and other match info) */
                            Datacloud.MatchResult matchResult = matchResults[0];
                            Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                            
                            /* Add matched record to the duplicate records variable */
                            for (Datacloud.MatchRecord matchRecord : matchRecords) {
                                dup.add(matchRecord.getRecord());
                                accIdList.add(matchRecord.getRecord().Id);
                            }
                        }
                    }
                    if(!accIdList.isEmpty()) {
                        List<Account> accList = [
                            SELECT Id
                            , Name
                            , BillingStreet
                            , CMI_Billing_Address__c
                            , CMI_Address2__c
                            , IAM_Service_Provider_Code__c
                            , BillingPostalCode
                            , BillingCity
                            , BillingCountryCode
                            , BillingStateCode
                            FROM Account 
                            WHERE Id IN :accIdList
                        ];
                        System.debug('#### IN FOR sObject - '+accList );
                        this.duplicateRecords = accList;
                        
                        /* Logic to check a single record and perform show duplicate box accordingly.if duplicateRecords list 
is not empty and has single record,then compare name of the duplicate record and entered name. 
if matches then new contact that is going to created should be assigned to the found duplicate account.
if duplicateRecords has multiple records then display duplicate immediately .*/
                        
                        /* Checking if there are any duplicate records */
                        if(!this.duplicateRecords.isEmpty()){
                            System.debug('#### DupRec size - '+this.duplicateRecords.size());
                            if(this.duplicateRecords.size()==1){
                                return dupAccPostRegLogic(this.duplicateRecords[0].id);
                            } else { 
                                /* logic to implete if size is greater than one then simply display the duplication
table by enabling has duplicate flag. */
                                System.debug('#### this.duplicateRecords size - '
                                             + this.duplicateRecords.size() + ' #### hasDuplicateResult ' + hasDuplicateResult);
                                this.hasDuplicateResult = !this.duplicateRecords.isEmpty();//flag to display duplicate box
                                EDQpop = false;
                            }
                        }
                    }
                }
            }
        }
        return null;
    }  
    
    
    
    /* This method is mainly used for performs the EDQ service call. */
    Public void EDQAddress(){       
        isEdqAddress = null;
        System.debug('#### rswAdditionalCode4 - '+rswAdditionalCode4);
        input = '';
        result = '';
        dupAccountselected = false;
        hasDuplicateResult = false;
        Boolean errorfound = false;
        errordiv = false;
        EDQpop = false;
        byPassEDQ = false;
        errorContat = '';
        //code start - RSW SP code validation - Chetan Gaikwad
        errorPrefercode = '';
        errorAddcode1 = '';
        errorAddcode2 = '';
        errorAddcode3 = '';
        errorAddcode4 = '';
        errorAddcode5 = '';
        //code end - RSW SP code validation - Chetan Gaikwad
        errorfound = isUserExist(newCon.Email);
        //code start - RSW SP code validation - Chetan Gaikwad
        if(!errorfound && app.name == Label.IAM_Rapid_Serve_Web) {
            errorfound = ValidateNumericSPcodeList(rswPreferCode, rswAdditionalCode, rswAdditionalCode1, rswAdditionalCode2, 
                                                   rswAdditionalCode3, rswAdditionalCode4, Label.IAM_ErrorMsg_Validate_SP_Code);
        }
        if(!errorfound && app.name == Label.IAM_Rapid_Serve_Web){
            errorfound = validateDuplicateRSWSPCode(rswPreferCode, rswAdditionalCode, rswAdditionalCode1, rswAdditionalCode2, 
                                                    rswAdditionalCode3, rswAdditionalCode4, Label.IAM_ErrorMsg_Duplicate_SP_Code);
        }
        //code end - RSW SP code validation - Chetan Gaikwad
        if(!errorfound && app.name == Label.IAM_Rapid_Serve_Web) {
            errorfound = validateRSWSPCode(rswPreferCode, rswAdditionalCode, rswAdditionalCode1, rswAdditionalCode2, 
                                           rswAdditionalCode3, rswAdditionalCode4, Label.IAM_ErrorMsg_Invalid_SP_Code, Label.IAM_Invalid_Additional_SP_Code);
        }
        if(!errorfound) {
            System.debug('Printing address cleanse informaion..EDQpop.' + EDQpop);
            System.debug('Printing address cleanse informaion...acc..' + acc);
            System.debug('Printing newCon.Username__c.' + newCon.Email);
            //calling EDQ service to see if we will get response or not 
            //EDQ service is not called for account record type WWSPS/ 
            //if EDQ table is already displayed or if duplicate table is already displaying.
            if(!EDQpop || (acc.RecordType != null && acc.RecordType.Name != null 
                           && !acc.RecordType.Name.equalsIgnoreCase(Label.IAM_WWSPS) )) {
                               EDQinfo = IAM_EDQ_AddressCleanse.EDQAddress(acc);
                               //EDQinfo = null;
                               System.debug('Printing address cleanse informaion'+EDQinfo);
                               if(EDQinfo != null){
                                   isEdqAddress = true;
                                   EDQpop=true; 
                                   for(IAM_EDQ_LocationResParser.Location loc : EDQinfo.AddressCleanse.Location){
                                       if(loc.GeographicalArea.StreetAddress.AddressType == 'S') {
                                           EDQStreetS=loc.GeographicalArea.StreetAddress.AddressLine1txt;
                                           EDQStreet2S=loc.GeographicalArea.StreetAddress.AddressLine2txt;
                                           EDQCityS=loc.GeographicalArea.City.CityID;
                                           EDQCountryS=loc.GeographicalArea.Country.CountryName;
                                           EDQStateS=loc.GeographicalArea.City.TerritoryID;
                                           EDQzipS=loc.GeographicalArea.PostalCode.PostalCodeNum; 
                                           
                                       } else {
                                           EDQStreetR=loc.GeographicalArea.StreetAddress.AddressLine1txt;
                                           EDQStreet2R=loc.GeographicalArea.StreetAddress.AddressLine2txt;
                                           EDQCityR=loc.GeographicalArea.City.CityID;
                                           EDQCountryR=loc.GeographicalArea.Country.CountryName;
                                           EDQStateR=loc.GeographicalArea.City.TerritoryID;
                                           EDQzipR=loc.GeographicalArea.PostalCode.PostalCodeNum; 
                                           EDQVerificationCode=loc.GeographicalArea.AddressValidation.VerificationCode;
                                           EDQVerifiedFlag=loc.GeographicalArea.AddressValidation.VerifiedFlag;
                                       }
                                   }
                                   //proceed registration even EDQ trow exception...
                               } else {
                                   byPassEDQ = true;
                               }
                               System.debug('Printing address cleanse informaion..EDQpop.' + EDQpop);
                           }
        }   
    } 
    
    // Action method invoked when duplicate account seleceted from duplicate account table
    public PageReference dupAccountSelection(){
        System.debug('Entered Account selection.');
        string accid=Apexpages.currentpage().getParameters().get('accountID');
        
        System.debug('#### accid ' + accid);
        selectedAccount = [
            SELECT Id
            FROM Account 
            WHERE Id = :accid
        ];
        System.debug('#### selectedAccount  ' + selectedAccount);
        dupAccountselected = true;
        return send();
    } 
    
    //Action method invoke when valid address selected from EDQ address table still working on this.
    public void EDQAddressSelectcon(){
        System.debug('Entered EDQAddressSelectcon isEdqAddress' + isEdqAddress);
    }
    
    //Action method display address fields when edit button click on EDQ table
    public void showAddress(){
        EDQpop = false;
        errorDiv = false;
        byPassEDQ = false;
        hasDuplicateResult = false;
        System.debug('Entered showAddress  EDQpop' + EDQpop);
    }
    
    public void show_error_msg(String errmsg){
        errordiv = True; 
        system.debug('i am here' +errmsg);
        ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.INFO, errmsg);          
        ApexPages.addMessage(errorMessage);
    }
    
    /* This method insert contact with the status provided in second parameter. 
for an existing account and also new Contact request. */
    public void insertContact(String accId,String contStatus) {
        
        List<Account> a= getNearestDistributorAcc(accId);
        if(!a.isEmpty()){   
            List<contact> c = [
                SELECT Id,IAM_Legacy_User__c
                FROM Contact
                WHERE AccountId =:a[0].Id
                AND CMI_Contact_Type__c=:Label.IAM_Primary
            ];
            //Get the distributor name
            List<Contact> lstDistributor = [
                SELECT Id
                , AccountId
                , Username__c
                , IAM_Legacy_User__c
                FROM Contact
                WHERE AccountId = :a[0].ParentId
                AND CMI_Contact_Type__c = :Label.IAM_Primary
            ];
            Id CRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
            newCon.AccountId= a[0].id;               
            newCon.IAM_Approved__c='Y';
            newCon.RecordTypeId=CRecId;
            newCon.IAM_from_Registration__c=true;
            newCon.IAM_Agreement_Signed_By__c = newCon.FirstName + ' '+ newCon.LastName;
            newCon.IAM_Agreement_Signed_On__c = date.today();
            newCon.Username__c= newCon.email;
            newCon.IAM_AppId__c =app.Id;
            //Adding changes to Skip Trigger execution.
            if(app.Name.equalsIgnoreCase(Label.IAM_AppName_guidanzmobile)){
                newCon.IAM_From_JIT_Execution__c=True;
                newCon.IAM_Work_Group_Id__c=acc.Location__c;
                newCon.IAM_Product_Group_Access__c='PGA03';
            }
            //end of changes to Skip trigger execution

            if(system.label.IAM_org_label!='.cso')
            {
                newCon.Username__c = newCon.Username__c + system.label.IAM_org_label; //Karthik changes this method for 77 UAT issue
            }else
            {
                newCon.Username__c = newCon.Username__c; //Karthik changes this method for 77 UAT issue
            }
            if(contStatus == System.Label.IAM_Status_Pending){                    
                newCon.IAM_Contact_Status__c = contStatus;// since we will be submitting this record to approval it should be in pending Status
                newCon.IAM_Approved__c='N';
            }else{
                newCon.IAM_Contact_Status__c = contStatus;// since we are going to create user for this record it should be active status
                newCon.IAM_Approved__c='Y';
            }
            //populate distributor name
            if(lstDistributor != null && !lstDistributor.isEmpty()){
                newCon.IAM_Distributor_Name__c = lstDistributor[0].Username__c;
            }
            newCon.IAM_Agreement_Signed_By__c = newCon.FirstName + ' '+ newCon.LastName;
            newCon.IAM_Agreement_Signed_On__c = date.today();
            if(!c.isEmpty()){
                newCon.CMI_Contact_Type__c=Label.IAM_Secondary;
                newCon.IAM_Site_Admin__c=false;
            }else{
                newCon.CMI_Contact_Type__c=Label.IAM_Primary;
                newCon.IAM_Site_Admin__c=true;
            }
            newCon.OwnerId = a[0].OwnerId;
            newCon.User_Registered_for__c=app.name;  // for uat issue# 583 - Pratima
           // newCon.IAM_DN_Value__c = IAM_Utility.getDNValue(newCon.Username__c, false, false);
           newCon.IAM_DN_Value__c = IAM_Utility.getDNValue(newCon.Username__c,newCon.IAM_Person_Type__c);//added by vineet

            insert newCon;
        }
        createUserForActiveContact(newCon.id);
    }   
    
    //This method update account address which is selected from EDQ address table
    public void updateAccountEDQAddress(){
        System.debug('before saveEDQaddress....' + acc);
        System.debug('updateAccountEDQAddress isEdqAddress' + isEdqAddress);
        System.debug('#### byPassEDQ ' + byPassEDQ);
        if(isEdqAddress != null && isEdqAddress) {
            acc.BillingStreet = EDQStreetR;
            acc.CMI_Address2__c = EDQStreet2R;
            acc.BillingCity = EDQCityR;
            acc.BillingPostalCode = EDQzipR;
            String checkCountryR = getCountryState(Label.IAM_Country, EDQCountryR);
            if(checkCountryR != null)
                acc.BillingCountryCode = EDQCountryR;
            String checkStateR = getCountryState(Label.IAM_State_HTML_ID_Label, EDQStateR);
            if(checkStateR != null) {
                acc.BillingStateCode = EDQStateR;
            }
            
        } else if(isEdqAddress != null && !isEdqAddress) {
            acc.BillingStreet = EDQStreetS;
            acc.BillingCity = EDQCityS;
            acc.BillingPostalCode = EDQzipS;
            acc.CMI_Address2__c = EDQStreet2S;
            String checkCountryS = getCountryState(Label.IAM_Country, EDQCountryS);
            if(checkCountryS != null)
                acc.BillingCountryCode = EDQCountryS;
            String checkStateS = getCountryState(Label.IAM_State_HTML_ID_Label, EDQStateS);
            if(checkStateS != null) {
                acc.BillingStateCode = EDQStateS;
            }
        }
        
        acc.IAM_Verification_code__c = EDQVerificationCode;
        acc.IAM_Verified_Flag__c = EDQVerifiedFlag;
        System.debug('saveEDQaddress....' + acc);
    }
    
    
    
    /****************************************************************************
Method Name: createApplicationContPro()
Description: This method is mainly used for create the Account and Contact provisiong records with status which is passed in parameter.
This method is also used for sending approvals to users or queue. 
This method is calling from New registration and Existing registration flow also.
Logic to create account/contact provisioning records and hit the approval process 


**************************************************************************/  
    
    public void createApplicationContPro(String appAcc, Contact contProC, boolean isOSMApp, String appProStatus, 
                                         String conProStatus, boolean isAppNeeded, boolean isConProNeeded, boolean isAppApproval,
                                         boolean isConApproval, String approverId, List<IAM_Application__c> lstApplications, boolean isNewAcc, string sDistCode) {
                                             
                                             System.debug('createApplicationContPro.....isNewAcc...'+ isNewAcc); 
                                             List<IAM_Application__c> appFeatureInsertList = new List<IAM_Application__c>();
                                             IAM_Application__c appl;
                                             set<Id> setId = new set<Id>();
                                             if(isAppNeeded){
                                                 appl = new IAM_Application__c();
                                                 appl.IAM_Account_Name__c = appAcc;
                                                 if(app.IAM_Paid_Subscription__c || app.Name.equalsIgnoreCase(System.Label.IAM_Guidanz) 
                                                    || app.Name.equalsIgnoreCase(System.Label.IAM_EDS) 
                                                    || app.Name.equalsIgnoreCase(System.Label.IAM_INSITE) 
                                                    || app.Name.equalsIgnoreCase(System.Label.IAM_ProMotion) 
                                                    || app.Name.equalsIgnoreCase(System.Label.IAM_Quick_Serve_Online)){
                                                        appl.IAM_Free_Subscription__c = false;
                                                    }else{
                                                        appl.IAM_Free_Subscription__c = true;
                                                    }
                                                 // for all applications, we need to give start date and end date
                                                 appl.IAM_Subscription_Name__c = (isOSMApp) ? System.Label.IAM_OSM_App_Name : app.Name;
                                                 appl.IAM_Subscription_Start_Date__c = System.today();
                                                 appl.IAM_Subscription_End_Date__c = System.today() + 36500;
                                                 appl.IAM_Application_Name__c = (isOSMApp) ? System.Label.IAM_OSM_App_Name : app.Name;
                                                 appl.IAM_Subscription_Count__c = Integer.valueof(System.Label.IAM_Default_App_Subscription_Count.trim());
                                                 //Issue#68,71,84 - following field need to be populated from contact so it can we used in email template IAM_Account_Application_Approval
                                                 appl.IAM_First_Name__c = contProC.FirstName;
                                                 appl.IAM_Last_Name__c = contProC.LastName;
                                                 appl.IAM_Username__c = contProC.Username__c;
                                                 appl.IAM_Email__c = contProC.Email;
                                                 appl.IAM_Phone__c = contProC.Phone;
                                                 System.debug('#### App Name'+ app.Name);
                                                 appl.recordtypeid = (isOSMApp) ? Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(System.Label.IAM_OSM_App_Name).getRecordTypeId() : Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(app.Name).getRecordTypeId(); 
                                                 appl.IAM_Status__c = appProStatus;
                                                 /*//adding changes to skip trigger for
                                                    if(app.Name==Label.IAM_AppName_guidanzmobile){
                                                        appl.IAM_From_JIT_Execution__c=True;
                                                    }
                                                 //End of trigger addition*/

                                                 if(app.Name == Label.IAM_AppName_Cumpas) {
                                                     appl.IAM_Role__c = getRoleFromMetadata(Label.IAM_AppName_Cumpas, Label.IAM_Customer);
                                                 } else {
                                                     //Default for Market place /OSM application.
                                                     appl.IAM_Role__c = (isOSMApp) ? System.Label.IAM_OSM_App_Default_Roles : app.IAM_Default_Role__c; 
                                                     system.debug('Application Roles assigned'+appl.IAM_Role__c );
                                                 }
                                                 if(app.Name == Label.IAM_AppName_guidanzmobile){
                                                     appl.IAM_Guidanz_Mobile_Roles__c= app.IAM_Default_Role__c;
                                                 }
                                                 if((null != approverId || !String.isBlank(approverId)) && null != this.duplicateRecords && this.duplicateRecords.size() ==0){
                                                     appl.ownerId =  approverId;
                                                 }
                                                 System.debug('appl... ' + appl);
                                                 //Adding app specific attirbutes for Connected solutions app
                                                 if(app.Name==System.Label.IAM_AppName_ConnectedSolutions) {
                                                     appl.CMI_CDA_Status__c=Label.IAM_New_Customer_Request;
                                                     appl.CMI_Other_Fault_Notifications__c=Label.IAM_No_System;
                                                     appl.CMI_Urgent_Fault_Notification__c=Label.IAM_No_System;
                                                 }        
                                                 //insert appl;
                                                 appFeatureInsertList.add(appl);
                                             }
                                             //changes for Conn Solution Web Registration - Infant Care issue - @Anupam
                                             // logic to create Market Place application if app name is Connected Solutions 
                                             //if(app.Name.equalsIgnoreCase(System.Label.IAM_AppName_ConnectedSolutions) && isNewAcc){
                                             if(isNewAcc && app.Name != System.Label.IAM_OSM_App_Name){
                                                 IAM_Application__c conSolApp;
                                                 conSolApp = new IAM_Application__c();
                                                 conSolApp.IAM_Account_Name__c = appAcc;
                                                 conSolApp.IAM_Free_Subscription__c = true;
                                                 // for all applications, we need to give start date and end date
                                                 conSolApp.IAM_Subscription_Start_Date__c = System.today();
                                                 conSolApp.IAM_Subscription_End_Date__c = System.today() + 36500;
                                                 conSolApp.IAM_Application_Name__c = System.Label.IAM_OSM_App_Name;
                                                 conSolApp.IAM_Subscription_Name__c = System.Label.IAM_OSM_App_Name;
                                                 conSolApp.IAM_Subscription_Count__c = Integer.valueof(System.Label.IAM_Default_App_Subscription_Count.trim());
                                                 //Issue#68,71,84 - following field need to be populated from contact so it can we used in email template IAM_Account_Application_Approval
                                                 conSolApp.IAM_First_Name__c = contProC.FirstName;
                                                 conSolApp.IAM_Last_Name__c = contProC.LastName;
                                                 conSolApp.IAM_Username__c = contProC.Username__c;
                                                 conSolApp.IAM_Email__c = contProC.Email;
                                                 conSolApp.IAM_Phone__c = contProC.Phone;
                                                 conSolApp.recordtypeid = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(System.Label.IAM_OSM_App_Name).getRecordTypeId(); 
                                                 conSolApp.IAM_Status__c = System.Label.IAM_Active_Status;
                                                 conSolApp.IAM_Role__c = System.Label.IAM_OSM_ContPro_Default_Roles; //Default for Market place /OSM application.
                                                 
                                                 System.debug('conSolApp... ' + conSolApp);
                                                 //insert conSolApp;
                                                 appFeatureInsertList.add(conSolApp);
                                                 
                                                /* IAM_Contact_Provisioning__c conSolUserapp = null;
                                                 conSolUserapp = new IAM_Contact_Provisioning__c();
                                                 conSolUserapp.IAM_Account_Application__c = conSolApp.id;
                                                 conSolUserapp.IAM_Contact__c = contProC.id;
                                                 conSolUserapp.IAM_Start_Date__c = System.today();
                                                 conSolUserapp.IAM_End_Date__c = System.today()+36500;
                                                 conSolUserapp.IAM_Application_Name__c = conSolApp.IAM_Application_Name__c;
                                                 conSolUserapp.IAM_Subscription_Name__c = conSolApp.IAM_Subscription_Name__c;
                                                 conSolUserapp.IAM_Status__c = Label.IAM_Pending_Account_Approval;
                                                 conSolUserapp.recordtypeid =  Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(System.Label.IAM_OSM_App_Name).getRecordTypeId(); 
                                                 conSolUserapp.IAM_Role__c = System.Label.IAM_OSM_ContPro_Default_Roles;
                                                 System.debug('conSolUserapp... ' + conSolUserapp);
                                                 insert conSolUserapp;*/
                                             }
                                             system.debug('appFeatureInsertList--->'+appFeatureInsertList);
                                             if(appFeatureInsertList.size() > 0){
                                                 //insert appFeatureInsertList;
                                                 Database.SaveResult[] srList= Database.insert(appFeatureInsertList, false);
                                                 
                                                 for(Integer i = 0; i < srList.size(); i++){
                                                     if(srList.get(i).isSuccess()){
                                                         setId.add(srList.get(i).Id);
                                                     }else if(!srList.get(i).isSuccess()){
                                                         for(Database.Error err : srList.get(i).getErrors()) {
                                                             System.debug('The following error has occurred.');                    
                                                             System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                                             System.debug('Account feature fields that affected this error: ' + err.getFields());
                                                         }
                                                     }
                                                 }
                                             }
                                             system.debug('app.Name.....'+app.Name);
                                             system.debug('setId of App Feature--->'+setId);
                                             if((app.Name==System.Label.IAM_FluidWatch || app.Name==System.Label.IAM_OSM_App_Name || app.Name== System.Label.IAM_AppName_ConnectedSolutions ) &&isNewAcc){
                                                 boolean osmflag=false;
                                                 if(app.Name==System.Label.IAM_OSM_App_Name){
                                                     osmflag=true;
                                                 }
                                                 system.debug('test....');
                                                // createosmSubscrptionForFluiwatch(appAcc,contProC.id); - Commented on 06/01/2021
                                                 if(osmflag){
                                                     createFWSubscriptionfromOSM(appAcc,contProC.id);
                                                 }
                                             }

                                             IAM_Contact_Provisioning__c userapp = null;
                                             String appFeatureId = '';
                                             if(isConProNeeded && app.Name != System.Label.IAM_Guidanz_Mobile_App_Name){
                                                 //Logic added for Conn Solution Web Registration Infant Care issue - @Anupam 
                                                 List<IAM_Application__c> fetchAppFeature = new List<IAM_Application__c>();// Added by Sandeep for 101 soql issue
                                                 if(run){//added by Sandeep for Marketplace/Guidanz 101 soql registration issue
                                                    fetchAppFeature = [Select Id, IAM_Application_Name__c FROM IAM_Application__c
                                                                                               WHERE Id IN : setId];
                                                        run=false;
                                                    }
                                                 system.debug('fetchAppFeature--->'+fetchAppFeature);
                                                 for(IAM_Application__c appRes : fetchAppFeature){
                                                     if(appRes.IAM_Application_Name__c == appl.IAM_Application_Name__c){
                                                         appFeatureId = appRes.Id;
                                                     }
                                                 }
                                                 system.debug('appFeatureId--->'+appFeatureId);
                                                 userapp = new IAM_Contact_Provisioning__c();
                                                 //userapp.IAM_Account_Application__c = (lstApplications != null && !lstApplications.isEmpty()) 
                                                    // ? lstApplications[0].id : appl.id;
                                                 userapp.IAM_Account_Application__c = (lstApplications != null && !lstApplications.isEmpty()) 
                                                     ? lstApplications[0].id : appFeatureId;
                                                 userapp.IAM_Contact__c = contProC.id;
                                                 userapp.IAM_Start_Date__c = System.today();
                                                 userapp.IAM_End_Date__c = System.today()+365;
                                                 userapp.IAM_Application_Name__c = (lstApplications != null && !lstApplications.isEmpty()) 
                                                     ? lstApplications[0].IAM_Application_Name__c : appl.IAM_Application_Name__c;
                                                 userapp.IAM_Subscription_Name__c = (lstApplications != null && !lstApplications.isEmpty()) 
                                                     ? lstApplications[0].IAM_Subscription_Name__c : appl.IAM_Subscription_Name__c;
                                                 userapp.IAM_Status__c = conProStatus;
                                                 userApp.recordtypeid = (isOSMApp) 
                                                     ? Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(System.Label.IAM_OSM_App_Name).getRecordTypeId() 
                                                     : Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(app.Name).getRecordTypeId(); 
                                                 
                                                 String userRole = '';
                                                 if(app.Name.equalsIgnoreCase(System.Label.IAM_AppName_ConnectedSolutions)) { 
                                                     if(contProC.CMI_Contact_Type__c == Label.IAM_Primary){
                                                         userRole = Label.IAM_DA_Primary_User_Roles;                
                                                     } else if(contProC.CMI_Contact_Type__c == Label.IAM_Secondary) {
                                                         userRole = Label.IAM_DA_Secondary_User_Roles;
                                                     }
                                                     Account accCMI = [SELECT CMI_CId__c FROM Account WHERE Id = :appAcc];
                                                     userapp.IAM_DA_Customer_List__c = accCMI.CMI_CId__c;
                                                 } else {
                                                     userRole = app.IAM_Default_Role__c;
                                                 }
                                                 userapp.IAM_Role__c = (isOSMApp) ? System.Label.IAM_OSM_ContPro_Default_Roles 
                                                     : userRole;
                                                 
                                                 if(app.Name == Label.IAM_Guidanz_Mobile_App_Name){
                                                     userapp.IAM_Guidanz_Mobile_Roles__c = userRole; 
                                                    // userapp.IAM_From_JIT_Execution__c=True;           
                                                 }
                                                 if(app.Name == Label.IAM_Rapid_Serve_Web) {
                                                     userapp.IAM_RSW_Reason__c = rswReason;
                                                     if(additionalCodefinal != '' && additionalCodefinal != null) {
                                                         userapp.IAM_Additional_Service_Provider__c = additionalCodefinal;
                                                     }
                                                     if(rswOtherReason != '' && rswOtherReason != null) {
                                                         userapp.IAM_RSW_Other_Reason__c = rswOtherReason;
                                                     }
                                                     if(sDistCode!=''&&sDistCode!=null){ 
                                                        userapp.IAM_RSW_Preferred_Service_Code__c=sDistCode;    
                                                    }else if(rswPreferCode!=''&&rswPreferCode!=null){
                                                       userapp.IAM_RSW_Preferred_Service_Code__c=rswPreferCode;
                                                    }
                                                 }
                                                 if(app.Name == Label.IAM_Power_Specs){
                                                     userapp.IAM_Occupation_List__c = occupationlist;            
                                                 }
                                                 System.debug('userapp... ' + userapp);
                                                 insert userapp;
                                                 System.debug('after insert userapp... ' + userapp);
                                             }
                                             
                                             if(isConApproval){
                                                 setApproval(contProC, System.Label.IAM_Contact_Admin_Approval, approverId);
                                             }else if(isAppApproval){
                                                 System.debug('#### approverId - ' +approverId);
                                                 setApproval(appl, System.Label.IAM_Account_Application_Approval, approverId);
                                             }
                                             
                                         }
    
    /****************************************************************************
Method Name: setApproval()
Description: This method is mainly used for sending approvals to users or queue. 

**************************************************************************/
    public void setApproval(SObject sObj, String approvalProName, String approverId){
        System.debug('sObj... ' + sObj);
        if(app.Name!=Label.IAM_AppName_ConnectedSolutions){
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments(Label.IAM_Submitting_For_Approval_Trigger);
            req1.setObjectId(sObj.id);
            req1.setSubmitterId(System.Label.IAM_App_Access_Request_Submitter);
            req1.setProcessDefinitionNameOrId(approvalProName);
            req1.setSkipEntryCriteria(true);
            
            if(String.isNotBlank(approverId)) {
                System.debug('#### Approval Process - approverId - '+approverId);
                req1.setNextApproverIds(new Id[] {approverId});
            } else {
                System.debug('#### approver AccownerId - '+AccownerId);
                req1.setNextApproverIds(new Id[] {AccownerId});
            }
            System.debug('### Approval req1.....  '+req1);
            // Submit the approval request for the Opportunity
            Approval.process(req1);
        }
    }
    
    /* post registration logic. for existing account...   */
    public PageReference postRegForExsitingAccount(String acnt, PageReference existingPgRef){
        System.debug('postRegistrationProcess...acnt..  ' + acnt);
        PageReference pgRef = existingPgRef;
        if(app != null && acnt != null) {
            List<User> primaryUserList = getNearestDistributorUser(acnt);
            Id approverLocationadmin; 
            
            List<IAM_Application__c> lstApplications = getApplicationList(acnt, app.Name);
            
            System.debug('#### approverLocationadmin - '+approverLocationadmin);
            System.debug('#### List of IAM_Application__c'+lstApplications);
            
            if(app.Name == Label.IAM_Guidanz_Mobile_App_Name) {
                insertContact(acnt, Label.IAM_Status_Active);
                if(isAccHasAppAccess(lstApplications)) {
                    createApplicationContPro(acnt, newCon, false, null, Label.IAM_Status_Active,
                                             false, true, false, false, null, lstApplications, false, null);
                } else {
                    createApplicationContPro(acnt, newCon, false, Label.IAM_Status_Active, Label.IAM_Status_Active,
                                             true, true, false, false, null, null, false, null);
                }
            } else if(app.IAM_Paid_Subscription__c){ //OSM enabled and account has app access app.IAM_OSM_Enabled__c
                
                if(!primaryUserList.isEmpty()){
                    approverLocationadmin = primaryUserList[0].Id;
                    if(isAccHasAppAccess(lstApplications)) {
                        insertContact(acnt, Label.IAM_Status_Pending);
                        createApplicationContPro(acnt, newCon, false, null, Label.IAM_Pending_Contact_Approval,
                                                 false, true, false, true, approverLocationadmin, lstApplications, false, null);
                    } else if(!isAccHasAppAccess(lstApplications)) {
                        if(osmEnabled) {
                            /* No creation of Contact or Contact Provisionign Record. Show details regarding
* Site admin and ask the user to contact him for purchasing Subscription to gain access.*/
                            /* Need to confirm */
                            pgRef = getDistributorInfoPage(currentRecordId, acnt);
                        } else {
                            /* Ask Location Admin to Contact Channel admin to purchase Subscription and gain access. */
                            /* Need to confirm */
                            pgRef = getDistributorInfoPage(currentRecordId, acnt);
                        }
                    }
                } else {
                    if(isAccHasAppAccess(lstApplications)) {
                        approverLocationadmin = getParentPrimaryUser(acnt);
                        if(String.isBlank(approverLocationadmin)){
                            if(String.isNotBlank(approverQueue)) {
                                approverLocationadmin =approverQueue;
                            } else {
                                show_error_msg(System.Label.IAM_Something_Went_Wrong_Error);
                                return null;
                            }
                        }
                        insertContact(acnt, Label.IAM_Status_Pending);
                        createApplicationContPro(acnt, newCon, false, null, Label.IAM_Pending_Contact_Approval,
                                                 false, true, false, true, approverLocationadmin, lstApplications, false, null);
                    } else {
                        /* Contact Channel admin to purchase Subscription and gain access. */
                        /* Pass parent account id : Need to confirm */
                        List<Account> accountList = getNearestDistributorAcc(acnt);
                        if(!accountList.isEmpty()) {
                            pgRef = getDistributorInfoPage(currentRecordId, accountList[0].ParentId);
                        }
                    }
                }
            } else { // Free Subscriptions
                if(!primaryUserList.isEmpty()){
                    approverLocationadmin = primaryUserList[0].Id;
                    if(isAccHasAppAccess(lstApplications)) {
                        insertContact(acnt, Label.IAM_Status_Pending);
                        createApplicationContPro(acnt, newCon, false, null, Label.IAM_Pending_Contact_Approval,
                                                 false, true, false, true, approverLocationadmin, lstApplications, false, null);
                    } else if(!isAccHasAppAccess(lstApplications)) {
                        if(app.Name.equalsIgnoreCase(Label.IAM_AppName_ConnectedSolutions)
                           && !primaryUserHasDAAccess(acnt)) {
                               /* Display an error message.*/
                               show_error_msg(Label.IAM_Contact_Cummins_Care_Message);
                               return null;
                           } else {
                               insertContact(acnt, Label.IAM_Status_Pending);
                               createApplicationContPro(acnt, newCon, false, Label.IAM_Status_Pending, Label.IAM_Pending_Account_Approval,
                                                        true, true, true, false, approverLocationadmin, null, false, null);
                           }
                    }
                } else {
                    if(app.Name.equalsIgnoreCase(Label.IAM_AppName_ConnectedSolutions)
                       || app.Name.equalsIgnoreCase(Label.IAM_OSM_App_Name)) {
                           /* Display an error message to contact Cummins Care. registration should be stopped. */
                           show_error_msg(Label.IAM_Contact_Cummins_Care_Message);
                           return null;
                       } else {
                           approverLocationadmin = getParentPrimaryUser(acnt);
                           if(String.isBlank(approverLocationadmin)){
                               if(String.isNotBlank(approverQueue)) {
                                   approverLocationadmin =approverQueue;
                               } else {
                                   show_error_msg(System.Label.IAM_Something_Went_Wrong_Error);
                                   return null;
                               }
                           }
                           insertContact(acnt, Label.IAM_Status_Pending);
                           if(isAccHasAppAccess(lstApplications)) {
                               createApplicationContPro(acnt, newCon, false, null, Label.IAM_Pending_Contact_Approval,
                                                        false, true, false, true, approverLocationadmin, lstApplications, false, null);
                           } else {
                               createApplicationContPro(acnt, newCon, false, Label.IAM_Status_Pending, Label.IAM_Pending_Account_Approval,
                                                        true, true, true, false, approverLocationadmin, null, false, null);
                           }
                       }
                }
            }
        }
        return pgRef;
    }
    
    /******************************************************************************************
Method Name: postRegForNewAccount()
Description: This method is using on New account registration. Here we have several conditions on Account registration.
1. If paid application, then checking OSM Enabled field, if true - then we are giving Market Place application access.
if OSM Enabled false - then not giving any application access and redirecting to nearest distributor details page.
2. If paid application and no approval needed, then we will create all active records.
3. If Free application, then checking approval needed - if not needed, then creating all active records.
4. If Free application and Approval needed, then we will check Queue name exists or not. If Queue name is exists, then we will 
create Pending records and sending approval to Queue.
5. if Queue name not exists, then also we will create pending records and approval sending to parent account primary user.              
*******************************************************************************************/
    
    public PageReference postRegForNewAccount(String acnt, PageReference existingPgRef){
        System.debug('#### Account Id - ' + acnt);
        //System.debug('#### Account WWSPS Region - ' + acnt.IAM_WWSPS_Regions__c);
        PageReference pgRef = existingPgRef;
        System.debug('#### postRegForNewAccount pgRef - ' + pgRef);
        if(app != null && acnt != null){
            
            Id approverLocationadmin;
            //Sandeep added condition for marketplace
            if(acc.ParentId != null && !app.Name.equalsIgnoreCase(Label.IAM_AppName_ConnectedSolutions) && !app.Name.equalsIgnoreCase(Label.IAM_OSM_App_Name) && !app.Name.equalsIgnoreCase(Label.IAM_Guidanz_Mobile_App_Name) && !app.Name.equalsIgnoreCase(Label.IAM_AppName_PowerSpec)) {
                approverLocationadmin = getParentPrimaryUser(acc.ParentId);
            }
            
            if(app.Name == Label.IAM_Guidanz_Mobile_App_Name) {
                insertContact(acnt, Label.IAM_Status_Active);
                createApplicationContPro(acnt, newCon, false, Label.IAM_Status_Active, Label.IAM_Status_Active,
                                         true, true, false, false, null, null, true, null);
            } else if(app.IAM_Paid_Subscription__c){
                /* Paid Subscription */
                if(osmEnabled){ 
                    insertContact(acnt, Label.IAM_Status_Active);
                    createApplicationContPro(acnt, newCon, osmEnabled, Label.IAM_Status_Active, Label.IAM_Status_Active,
                                             true, true, false, false, null, null, true, null);
                }else if(!osmEnabled) {
                    System.debug('#### If paid subscription && not osm enabled');
                    insertContact(acnt, Label.IAM_Status_Pending);
                    createApplicationContPro(acnt, newCon, osmEnabled, Label.IAM_Status_Pending, Label.IAM_Status_Pending,
                                             true, true, false, false, null, null, true, null);
                    pgRef = getDistributorInfoPage(currentRecordId, acnt);
                }
            } else { 
                /* Paid Subscription not required */
                if(app.IAM_Approval_Needed__c){
                    /* Free subsription & approval needed */
                    if(!app.Name.equalsIgnoreCase(Label.IAM_AppName_ConnectedSolutions)) {
                        if(String.isBlank(approverLocationadmin)){
                            if(String.isNotBlank(approverQueue)) {
                                approverLocationadmin =approverQueue;
                            } else {
                                show_error_msg(System.Label.IAM_Something_Went_Wrong_Error);
                                return null;
                            }
                        }
                        System.debug('#### postRegForNewAccount approverLocationadmin ' +approverLocationadmin);
                        insertContact(acnt, Label.IAM_Status_Pending);
                        createApplicationContPro(acnt, newCon, false, Label.IAM_Status_Pending,
                                                 Label.IAM_Pending_Account_Approval, true, true, true, false, approverLocationadmin, null, true, null);
                    } else if(app.Name.equalsIgnoreCase(Label.IAM_AppName_ConnectedSolutions)) {
                        insertContact(acnt, Label.IAM_Status_Pending);
                        createApplicationContPro(acnt, newCon, false, Label.IAM_Status_Pending,
                                                 Label.IAM_Pending_Account_Approval, true, true, false, false, null, null, true, null);
                    }
                    
                }else if(!app.IAM_Approval_Needed__c){
                    insertContact(acnt, Label.IAM_Status_Active);
                    createApplicationContPro(acnt, newCon, false, Label.IAM_Status_Active, Label.IAM_Status_Active,
                                             true, true, false, false, null, null, true, null);
                }
            }
        }
        return pgRef;
    }
    
    /* If primary contact exists for given Account then it returns true else returns false */
    public boolean isPrimaryContactExist (String accId){
        List<contact> cont = [
            SELECT Id
            FROM Contact
            WHERE AccountId = :accId
            AND CMI_Contact_Type__c = :Label.IAM_Primary
        ];
        if(cont != null && !cont.isEmpty()) {
            return true;
        } else {
            return false;
        }
    }
    
    /* It checks if Account contains Account Access Feature present for current application*/
    public boolean isAccHasAppAccess (List<IAM_Application__c> lstApplications){
        if(null != lstApplications && lstApplications.size() > 0) {
            return true;
        } else {
            return false;
        }
    } 
    
    /* This method check duplicate user/contact with duplicate username */
    public boolean isExistingUser(String usrname, String conId) {
        System.debug(' isExistingUser....usrname '+ usrname);
        List<User> usr = null;
        List<Contact> dupConLst = null;
        usr = [select id from user where username =: usrname ];
        System.debug(' isExistingUser....usr '+ usr);       
        
        if(usr != null && !usr.isEmpty()){
            return true;
        } else {
            dupConLst = [select id from Contact where Username__c =: usrname and id !=: conId];
        }
        if(dupConLst != null && !dupConLst.isEmpty()) {
            return true;
        } else {
            return false;
        }            
    }
    
    /* this method validate country/state from EDQ service with global picklist */
    public String getCountryState (String country_State, String code){
        Map<String,String> mapStateCodelabelVal = new Map<String,String>();
        Map<String,String> mapCountrylabelVal = new Map<String,String>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist stateValues for this field.
        list<Schema.PicklistEntry> stateValues = fieldMap.get('BillingStateCode').getDescribe().getPickListValues();
        // Add these stateCodeValues to the selectoption list.
        for (Schema.PicklistEntry a : stateValues){
            mapStateCodelabelVal.put(a.getValue(), a.getLabel());
        }
        
        // Get the list of picklist countryValues for this field.
        list<Schema.PicklistEntry> countryValues = fieldMap.get('BillingCountryCode').getDescribe().getPickListValues();
        
        // Add these countryValues to the selectoption list.
        for (Schema.PicklistEntry c : countryValues){
            //mapCountrylabelVal.put(c.getLabel(), c.getValue());
            mapCountrylabelVal.put(c.getValue(), c.getLabel());
        }
        
        if(country_State.equalsIgnoreCase(Label.IAM_State_HTML_ID_Label)){
            system.debug('111 MAP: '+mapStateCodelabelVal);
            system.debug('111 ISO CODE: '+mapStateCodelabelVal.get(code));
            return mapStateCodelabelVal.get(code);
        }
        
        if(country_State.equalsIgnoreCase(Label.IAM_Country)){
            system.debug('333 MAP: '+mapCountrylabelVal);
            system.debug('333 ISO CODE: '+ mapCountrylabelVal.get(code));
            return mapCountrylabelVal.get(code);
        }
        return null;
    }
    
    /****************************************************************************
Method Name: RSWregistration()
Description: This method is mainly used in RSW registration flow. 
If we are registering for RSW(Rapid Serve Web) application, then we will create the Contact and 
contact provisiong record with pending status.               
**************************************************************************/
    
    String additionalCodefinal;
    public pageReference RSWregistration() {
        
        additionalCodefinal = '';
        if(String.isNotBlank(rswAdditionalCode)) {
            additionalCodefinal = rswAdditionalCode;
        }
        if(String.isNotBlank(rswAdditionalCode1)) {
            additionalCodefinal = additionalCodefinal+';'+rswAdditionalCode1;
        }
        if(String.isNotBlank(rswAdditionalCode2)) {
            additionalCodefinal = additionalCodefinal+';'+rswAdditionalCode2;
        }
        if(String.isNotBlank(rswAdditionalCode3)) {
            additionalCodefinal = additionalCodefinal+';'+rswAdditionalCode3;
        }
        if(String.isNotBlank(rswAdditionalCode4)) {
            additionalCodefinal = additionalCodefinal+';'+rswAdditionalCode4;
        }
        /* For RSW applications, IAM_OASM_Enabled is always false */
        osmEnabled = false;
        
        Account accBasedonRSW = [
            SELECT Id, Type, ParentId,CSS_DistributorCode__c
            , Name
            , IAM_Service_Provider_Code__c
            FROM Account
            WHERE IAM_Service_Provider_Code__c = :rswPreferCode
        ];
        system.debug('accBasedonRSW--->'+accBasedonRSW);
        
        //Changes for RSW issue CHG0065794 - @Anupam
        List<IAM_Application__c> lstApplications = new List<IAM_Application__c>();
        lstApplications = getApplicationList(accBasedonRSW.Id, app.Name);
        if(accBasedonRSW != null && accBasedonRSW.Type == 'CIHR'){
            system.debug('inside 1st if RSW');
            List<IAM_Application__c> appFeatureList = [Select Id, IAM_Account_Name__c, IAM_Application_Name__c,IAM_Status__c,
                                                       IAM_Free_Subscription__c,IAM_Subscription_Name__c,IAM_Role__c
                                                       from IAM_Application__c
                                                       where IAM_Account_Name__c =: accBasedonRSW.ParentId and IAM_Application_Name__c = 'Rapid Serve Web' AND (IAM_Status__c =: Label.IAM_Status_Active OR IAM_Status__c =: Label.IAM_Status_Pending)];
            if(appFeatureList.size() > 0){
                if(isAccHasAppAccess(lstApplications)){
                    system.debug('inside 2nd if RSW');
                    insertContact(accBasedonRSW.id, Label.IAM_Status_Pending);
                    createApplicationContPro(accBasedonRSW.id, newCon, false, System.Label.IAM_Status_Pending, System.Label.IAM_Status_Pending,
                                             false, true, false, false, null, lstApplications, false,accBasedonRSW.CSS_DistributorCode__c);
                    
                    PageReference tnxPageRef =new pagereference(
                    Label.IAM_Confirmation_Page_Url + escapeHtml(currentRecordId));
                    System.debug('#### RSW tnxPageRef  ' + tnxPageRef);
                    return tnxPageRef;
                    
                } else{
                    system.debug('inside else of 2nd if');
                    insertContact(accBasedonRSW.id, Label.IAM_Status_Pending);
                    createApplicationContPro(accBasedonRSW.id, newCon, false, System.Label.IAM_Status_Active, System.Label.IAM_Status_Pending,
                                             true, true, false, false, null, lstApplications, false,accBasedonRSW.CSS_DistributorCode__c);
                    
                    PageReference tnxPageRef =new pagereference(
                    Label.IAM_Confirmation_Page_Url + escapeHtml(currentRecordId));
                    System.debug('#### RSW tnxPageRef  ' + tnxPageRef);
                    return tnxPageRef;
                }
                
            } else {
                /* display an error message on the registration page it self saying
* location is not authorized for RSW access. */
                system.debug('inside else of appfeature');
                show_error_msg(Label.IAM_Contact_Cummins_Care_Message);
                return null;
            }
            
        }
        else if(accBasedonRSW != null){
            system.debug('inside else if RSW');
            //system.debug('-----RSW method---Account---'+accBasedonRSW.Id);
            //List<IAM_Application__c> lstApplications = getApplicationList(accBasedonRSW.id, app.Name);     
            if(isAccHasAppAccess(lstApplications)) {
                insertContact(accBasedonRSW.id, Label.IAM_Status_Pending);
                createApplicationContPro(accBasedonRSW.id, newCon, false, System.Label.IAM_Status_Pending, System.Label.IAM_Status_Pending,
                                         false, true, false, false, null, lstApplications, false, null);
                
                PageReference tnxPageRef =new pagereference(
                    Label.IAM_Confirmation_Page_Url + escapeHtml(currentRecordId));
                System.debug('#### RSW tnxPageRef  ' + tnxPageRef);
                return tnxPageRef;
            } else {
                /* display an error message on the registration page it self saying
* location is not authorized for RSW access. */
                show_error_msg(Label.IAM_Contact_Cummins_Care_Message);
                return null;
            }
        } else{
            system.debug('inside else RSW');
            show_error_msg(Label.IAM_Contact_Cummins_Care_Message);
                return null;
        }
        //Changes end for RSW issue CHG0065794 - @Anupam
    }
    
    /***********************************************************************
Method Name: getParentPrimaryUser()
Description: This method is using for to get the parent account primary user.
In this method, we will check for primary user on next level, if we didn't find the primary user on one level.
If we found primary user, then we will update this user as Account owner.
**********************************************************************/
    
    public Id getParentPrimaryUser(Id nearestDistributor) {
        /* Karthik changes this method for 77 UAT issue */
        /*since we are always assigning Force.com or salesforce licnense users as owners.IAM_Cummins_Login__ID and Username 
will never be same. To over come this. Please query on IAM_UID__c field on the use record with Username__c field.
If you have any quieries you can use zx485 in CSOUAT instnace to check your Quieries.(try to query on Contact and User) */
        Id userId = null;
        List <User> userList;
        List<Account> lstParentId1 = getNearestDistributorAcc(nearestDistributor);
        if(!lstParentId1.isEmpty()) {
            userList = getNearestDistributorUser(lstParentId1[0].id);
            if(!userList.isEmpty()) {
                userId = userList[0].Id;
            } else {
                List<Account> lstParentId2 = getNearestDistributorAcc(lstParentId1[0].ParentId);
                if(!lstParentId2.isEmpty()) {
                    userList = getNearestDistributorUser(lstParentId2[0].id);
                    if(!userList.isEmpty()) {
                        userId = userList[0].Id;
                    } else {
                        List<Account> lstParentId3 = getNearestDistributorAcc(lstParentId2[0].ParentId);
                        if(!lstParentId3.isEmpty()){
                            userList = getNearestDistributorUser(lstParentId3[0].id);
                            if(!userList.isEmpty()) {
                                userId = userList[0].Id;
                            } else {
                                List<Account> lstParentId4 = getNearestDistributorAcc(lstParentId3[0].ParentId);
                                if(!lstParentId4.isEmpty()) {
                                    userList = getNearestDistributorUser(lstParentId4[0].id);
                                    if(!userList.isEmpty()) {
                                        userId = userList[0].Id;
                                    } /*else{
                                        List<Account> lstParentId5 = getNearestDistributorAcc(lstParentId4[0].ParentId);
                                        if(!lstParentId5.isEmpty()){
                                            userList = getNearestDistributorUser(lstParentId5[0].id);
                                            if(!userList.isEmpty()) {
                                                userId = userList[0].Id;
                                            } else {
                                                List<Account> lstParentId6 = getNearestDistributorAcc(lstParentId5[0].ParentId);
                                                if(!lstParentId6.isEmpty()){
                                                    userList = getNearestDistributorUser(lstParentId6[0].id);
                                                    if(!userList.isEmpty()) {
                                                        userId = userList[0].Id;
                                                    } else {
                                                        List<Account> lstParentId7 = getNearestDistributorAcc(lstParentId6[0].ParentId);
                                                        if(!lstParentId7.isEmpty()){
                                                            userList = getNearestDistributorUser(lstParentId7[0].id);
                                                            if(!userList.isEmpty()) {
                                                                userId = userList[0].Id;
                                                            }
                                                        }
                                                    }
                                                }
                                            } 
                                        }
                                    }*/
                                }
                            }
                        }
                    }       
                }
            }
        }
        return userId;
    }
    
    /* Return nearest distributor Account */
    public List<Account> getNearestDistributorAcc(Id accId) {
        return [
            SELECT Id
            , ParentId
            , Name
            , Type
            , CSS_DistributorCode__c
            , CSS_DBCode__c
            , IAM_WWSPS_Regions__c
            , IAM_Service_Provider_Code__c
            , BillingStreet
            , BillingCity
            , BillingState
            , BillingStateCode
            , BillingCountry
            , BillingCountryCode
            , BillingPostalCode
            , ShippingStreet
            , ShippingCity
            , ShippingState
            , ShippingStateCode
            , ShippingCountry
            , ShippingCountryCode
            , ShippingPostalCode
            , CMI_Address2__c
            , IAM_Primary_Market_Segment__c
            , CMI_Telematics_Service_Provider__c
            , CMI_Other_TSP__c
            , CMI_Cummins_Support_First_Name__c
            , CMI_Cummins_Support_Last_Name__c
            , CMI_Cummins_Support_Email__c
            , RecordType.Name
            , OwnerId
            FROM Account
            WHERE Id = :accId
        ];
    }
    
    /* Return primary user of a nearest distributor Account. 
    06/01/2021 made changes to below query by adding internal flag to true and on user object
    Changing the query to FederationIdentifier from IAM_UID__C*/
    public List<User> getNearestDistributorUser(Id parentId) {
        List<User> userList = new List<User>();
        List<Contact> contactOwnerList = [
            SELECT Id
            , AccountId
            , Username__c
            FROM Contact 
            WHERE AccountId = :parentId
            AND CMI_Contact_Type__c = :Label.IAM_Primary
            AND IAM_Contact_Status__c = :Label.IAM_Status_Active
            AND IAM_Internal__c=True
        ];
        if(!contactOwnerList.isEmpty()) {
            userList = [
                SELECT Id
                FROM User
                WHERE FederationIdentifier =: contactOwnerList[0].Username__c
                AND IsActive = true
            ];
        }
        return userList;
    }
    
    /* Return regional or Cummins Inc Account */
    public List<Account> getDefaultCumminsAcc(String accName) {
        Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CMI').getRecordTypeId();
        return [
            SELECT Id
            , Name
            , CSS_DistributorCode__c
            , CSS_DBCode__c
            , IAM_WWSPS_Regions__c
            , IAM_Service_Provider_Code__c
            FROM Account
            WHERE Name = :accName
            AND CMI_Account_Status__c = :Label.IAM_Status_Active
            AND Type = 'Internal'
            AND RecordTypeId = :recTypeId
        ];
    }
    
    /* Return Contact whose Id is provided */ 
    public List<Contact> getContactList(Id contactId) {
        return [
            SELECT Id
            , IAM_Site_Admin__c
            , IAM_Contact_Status__c
            , FirstName
            , LastName
            , Email
            , Phone
            , Username__c
            , IAM_Legacy_User__c
            FROM Contact
            WHERE Id = :contactId
        ];
    }
    
    /* Return if OSM Enabled is true for a region from metadata */
    public Boolean isOSMEnabled(String locationCode) {
        System.debug('#### regionName - '+ locationCode);
        List<IAM_Location_Code__mdt> locationCodeMetadata;
        if(String.isNotBlank(locationCode)) {
            locationCodeMetadata = [
                SELECT Location_Code__c
                , IAM_OSM_Enabled__c
                FROM IAM_Location_Code__mdt
                WHERE Location_Code__c = :locationCode
                LIMIT 1
            ];
        }
        System.debug('#### locationCodeMetadata - '+ locationCodeMetadata);
        if(locationCodeMetadata != null && !(locationCodeMetadata.isEmpty())) {
            return locationCodeMetadata[0].IAM_OSM_Enabled__c;
        } else {
            return false;
        }
    }
    
    /* Query value of Role on Account Access Feature from Application Feature Validations metadata */
    public String getRoleFromMetadata(String appName, String accType) {
        Application_Feature_Validation__mdt appRoleMetadata;
        if(String.isNotBlank(appName) && String.isNotBlank(accType)) {
            appRoleMetadata = [
                SELECT MasterLabel
                , Account_Type__c
                , Application_Roles__c
                FROM Application_Feature_Validation__mdt
                WHERE MasterLabel = :appName
                AND Account_Type__c = :accType
                LIMIT 1
            ];
        }
        System.debug('#### appRoleMetadata - '+ appRoleMetadata);
        if(appRoleMetadata != null) {
            return appRoleMetadata.Application_Roles__c;
        } else {
            return '';
        }
    }
    
    /* Return page reference of IAM_ContactDistributorInfo */
    public PageReference getDistributorInfoPage(String appRecId, Id accountId) {
        PageReference distributorInfo = new pagereference(
            '/IAM_ContactDistributorInfo?appid='+escapeHtml(appRecId)+'&accid='+accountId );
        if(!Test.isRunningTest()){
            IAM_Sendemailalert.updateDistributorInfo(accountId);
        }    
        return distributorInfo;
    }
    
    /* Check if given Contact is Active. If yes, create User record.  */
    public void createUserForActiveContact(Id contactId) {
        System.debug('#### createUserForActiveContact contactId - '+ contactId);
        if(contactId == null) {
            return;
        }
        List<Contact> objCon = [
            SELECT Id
            , FirstName
            , LastName
            , IAM_Internal__c
            , Email
            , Phone
            , Account.CMI_Account_Num__c
            , AccountId
            , Account.Name
            , CMI_Contact_Type__c
            , Account.Type
            , Username__c
            , IAM_Final_Approver__c
            , Account.OwnerId
            , Account.IAM_ABO_Code_Formula__c
            , IAM_Applications__c
            , Account.IAM_Service_Provider_Code__c
            , Account.CSS_DBCode__c
            , Account.CSS_DistributorCode__c
            , Account.parentid
            , IAM_is_Member_of__c
            , IAM_Work_Group_Id__c
            , IAM_Qsolexpiration__c
            , IAM_Qsolview__c
            , IAM_Product_Group_Access__c
            , Account.Location__c
            , Account.BillingStreet
            , Account.BillingCity
            , Account.BillingCountry
            , Account.BillingPostalCode
            , Account.ShippingStreet
            , Account.ShippingCity
            , Account.ShippingCountry
            , Account.ShippingPostalCode
            , Account.CSS_Locale__c
            , Account.CSS_Language__c
            , Account.CSS_Timezone__c
            , Account.IAM_Movex_Customer_Code__c
            , Account.IAM_WWSPS_Regions__c
            , IAM_Site_Admin__c
            , IAM_Site_Admin_Role__c
            , IAM_Legacy_User__c
            FROM Contact
            WHERE Id = :contactId
            AND IAM_Contact_Status__c = :Label.IAM_Status_Active
        ];
        
        if(objCon != null && !objCon.isEmpty()) {
            IAM_CreateUser.CreateUser(objCon);
            Set<id> Conids=new Set<id>();
            Conids.add(objCon[0].id);
            System.debug('Printing before LDAP Call');
            IAM_LDAP_Util_ApexCallout.sendToLDAP(Conids,'Insert');
        }
    }
    
    /* Irrespective of number of duplicate Accounts (either 1 or more), post registration logic is same. */
    public PageReference dupAccPostRegLogic(Id existingAccountId) {
        System.debug('#### dupAccPostRegLogic - '+acc.Name);
        /* check if account type is WWSPS and having primary contact then display error message and stop */
        List<Account> wwspsAcc = [
            SELECT Id
            , RecordType.Name
            FROM Account
            WHERE Id = :existingAccountId
            LIMIT 1
        ];
        System.debug('#### wwspsAcc[0].recordtype.Name - ' + wwspsAcc[0].recordtype.Name);
        System.debug('#### isPrimaryContactExist - ' + isPrimaryContactExist(existingAccountId));
        if(wwspsAcc[0].RecordType.Name == System.Label.IAM_WWSPS && !isPrimaryContactExist(existingAccountId)){
            show_error_msg(System.Label.IAM_wwsps_error_message);
            return null;
        }
        
        //post registration logic for existing account
        String langValue = ApexPages.currentPage().getParameters().get(Label.Language_Parameter);
        PageReference tnxPageRef =new pagereference(
            Label.IAM_Confirmation_Page_Url + escapeHtml(currentRecordId) + '&lang=' + escapeHtml(langValue));
        
        PageReference pgRef = postRegForExsitingAccount(existingAccountId, tnxPageRef);
        
        EDQpop = false;
        byPassEDQ = false;
        
        return pgRef;
    }
    
    public Boolean isUserExist(String emailStr) {
        String username;
        if(Label.IAM_org_label!='.cso')
        {
            username = emailStr + Label.IAM_org_label;     
        }else{
            username = emailStr;     
        }   List<contact> dupContactslist = [
            SELECT Id
            , Name
            , Email
            , Username__c
            , IAM_Contact_Status__c
            , IAM_Legacy_User__c
            FROM Contact
            WHERE Username__c = :username
            AND IAM_Contact_Status__c != :Label.IAM_Rejected_Label
        ];
        if(!(dupContactslist.isEmpty())) {
            //errorContat = 'Contact with UserName: '+newCon.email+' already exist.';
            errorContat = Label.IAM_Contact_Exist_Error;
            return true;
        } else {
            List<User> userlist = [
                SELECT Id
                , Username
                , IAM_UID__c
                FROM User
                WHERE Username = :username
                OR IAM_UID__c = :username
            ];
            if(!(userlist.isEmpty())) {
                errorContat = Label.IAM_ErrorMsg_Username_Exist;
                return true;
            } else {
                return false;
            }
        }
    }
    
    /* Return active or pending Account Feature Access List for given Account */
    public List<IAM_Application__c> getApplicationList(String accName, String appName) {
        return [
            SELECT Id
            , IAM_Account_Name__c
            , IAM_Application_Name__c
            , IAM_Status__c
            , IAM_Free_Subscription__c
            , IAM_Subscription_Name__c
            , IAM_Role__c
            FROM IAM_Application__c
            WHERE IAM_Account_Name__c = :accName
            AND IAM_Application_Name__c = :appName
            AND (IAM_Status__c =: Label.IAM_Status_Active
                 OR IAM_Status__c =: Label.IAM_Status_Pending)];
    }
    
    /* Return active or expired Accounts for given additional service provider code */
    public List<Account> getRSWAccountList(String rswAdditionalSPCode) {
        return [
            SELECT Id
            , Name
            , IAM_Service_Provider_Code__c
            , CMI_Account_Status__c
            FROM Account
            WHERE IAM_Service_Provider_Code__c != Null
            AND IAM_Service_Provider_Code__c = :rswAdditionalSPCode
            LIMIT 1
        ];
    }
    
    /* Check if RSW Service Provide codes are valid */
    public Boolean validateRSWSPCode(String rswPreferSPCode, String rswAddSPCode, String rswAddSPCode1, 
                                     String rswAddSPCode2, String rswAddSPCode3, String rswAddSPCode4, String spCodeLabel, String spAddCodeLabel) {
                                         errorPrefercode = checkRSWAccList(rswPreferSPCode, spCodeLabel);
                                         errorAddcode1 = checkRSWAccList(rswAddSPCode, spAddCodeLabel);
                                         errorAddcode2 = checkRSWAccList(rswAddSPCode1, spAddCodeLabel);
                                         errorAddcode3 = checkRSWAccList(rswAddSPCode2, spAddCodeLabel);
                                         errorAddcode4 = checkRSWAccList(rswAddSPCode3, spAddCodeLabel);
                                         errorAddcode5 = checkRSWAccList(rswAddSPCode4, spAddCodeLabel);
                                         if(String.isBlank(errorPrefercode) && String.isBlank(errorAddcode1) && String.isBlank(errorAddcode2)
                                            && String.isBlank(errorAddcode3) && String.isBlank(errorAddcode4) && String.isBlank(errorAddcode5)) {
                                                return false;
                                            } else {
                                                return true;
                                            }
                                     }
    
    public String checkRSWAccList(String rswSPCode, String spCodeLabel) {
        if(String.isNotBlank(rswSPCode)) {
            List<Account> rswAccountList = getRSWAccountList(rswSPCode); 
            if(!rswAccountList.isEmpty()) {
                return null;
            } else {
                return spCodeLabel;
            }            
        } else {
            return null;
        }
    }

    //code start - validate RSW SP code - Chetan Gaikwad
    public Boolean ValidateNumericSPcodeList(String rswPreferSPCode, String rswAddSPCode, String rswAddSPCode1, 
                                             String rswAddSPCode2, String rswAddSPCode3, String rswAddSPCode4, String spCodeLabel){
                                                 
        errorPrefercode = ValidateNumericSPcode(rswPreferSPCode, spCodeLabel);
        errorAddcode1 = ValidateNumericSPcode(rswAddSPCode, spCodeLabel);
        errorAddcode2 = ValidateNumericSPcode(rswAddSPCode1, spCodeLabel);
        errorAddcode3 = ValidateNumericSPcode(rswAddSPCode2, spCodeLabel);
        errorAddcode4 = ValidateNumericSPcode(rswAddSPCode3, spCodeLabel);
        errorAddcode5 = ValidateNumericSPcode(rswAddSPCode4, spCodeLabel);
        if(String.isBlank(errorPrefercode) && String.isBlank(errorAddcode1) && String.isBlank(errorAddcode2)
           && String.isBlank(errorAddcode3) && String.isBlank(errorAddcode4) && String.isBlank(errorAddcode5)) {
        return false;
        } else {
        return true;
        }
    }

    public String ValidateNumericSPcode(String rswSPCode, String spCodeLabel) {
        
        String spRegex = '([0-9]{5})';
        Pattern spCodePattern = Pattern.compile(spRegex);
        Matcher spCodeMatcher = spCodePattern.matcher(rswSPCode);
        if((!spCodeMatcher.matches() && !String.isBlank(rswSPCode)) || rswSPCode.length()>Integer.valueOf(system.label.IAM_RSW_SPcode_Length))
        {
            return spCodeLabel;
        }else{
            return null;
        }
    }

    public Boolean validateDuplicateRSWSPCode(String rswPreferSPCode, String rswAddSPCode, String rswAddSPCode1, 
                                              String rswAddSPCode2, String rswAddSPCode3, String rswAddSPCode4, String spCodeLabel){
                                                  
        if(rswPreferSPCode == rswAddSPCode && !String.isBlank(rswAddSPCode)){
           errorAddcode1 = spCodeLabel;
        } if(rswPreferSPCode == rswAddSPCode1 && !String.isBlank(rswAddSPCode1)){
           errorAddcode2 = spCodeLabel;
        } if(rswPreferSPCode == rswAddSPCode2 && !String.isBlank(rswAddSPCode2)){
           errorAddcode3 = spCodeLabel;
        } if(rswPreferSPCode == rswAddSPCode3 && !String.isBlank(rswAddSPCode3)){
           errorAddcode4 = spCodeLabel;
        } if(rswPreferSPCode == rswAddSPCode4 && !String.isBlank(rswAddSPCode4)){
           errorAddcode5 = spCodeLabel; 
        } if(rswAddSPCode == rswAddSPCode1 && !String.isBlank(rswAddSPCode1)){
           errorAddcode2 = spCodeLabel;
        } if(rswAddSPCode == rswAddSPCode2 && !String.isBlank(rswAddSPCode2)){
           errorAddcode3 = spCodeLabel;
        } if(rswAddSPCode == rswAddSPCode3 && !String.isBlank(rswAddSPCode3)){
           errorAddcode4 = spCodeLabel;
        } if(rswAddSPCode == rswAddSPCode4 && !String.isBlank(rswAddSPCode4)){
           errorAddcode5 = spCodeLabel;
        } if(rswAddSPCode1 == rswAddSPCode2 && !String.isBlank(rswAddSPCode2)){
            errorAddcode3 = spCodeLabel;
        } if(rswAddSPCode1 == rswAddSPCode3 && !String.isBlank(rswAddSPCode3)){
            errorAddcode4 = spCodeLabel;
        } if(rswAddSPCode1 == rswAddSPCode4 && !String.isBlank(rswAddSPCode4)){
            errorAddcode5 = spCodeLabel;
        } if(rswAddSPCode2 == rswAddSPCode3 && !String.isBlank(rswAddSPCode3)){
            errorAddcode4 = spCodeLabel;
        } if(rswAddSPCode2 == rswAddSPCode4 && !String.isBlank(rswAddSPCode4)){
            errorAddcode5 = spCodeLabel;
        } if(rswAddSPCode3 == rswAddSPCode4 && !String.isBlank(rswAddSPCode4)){
            errorAddcode5 = spCodeLabel;
        }
        
        if(String.isBlank(errorAddcode1) && String.isBlank(errorAddcode2) && String.isBlank(errorAddcode3) && String.isBlank(errorAddcode4) && String.isBlank(errorAddcode5)) {
           return false;
        } else {
           return true;
        }
    }
    //code end - validate RSW SP code - Chetan Gaikwad
    
    /* Check if primary user of location have access to Connected Solution application */
    public Boolean primaryUserHasDAAccess(String accId) {
        List<Contact> contactList = [
            SELECT Id
            , AccountId
            , IAM_Contact_Status__c
            , CMI_Contact_Type__c
            , IAM_Legacy_User__c
            FROM Contact
            WHERE AccountId = :accId
            AND IAM_Contact_Status__c = :Label.IAM_Status_Active
            AND CMI_Contact_Type__c = :Label.IAM_Primary
        ];
        
        if(!contactList.isEmpty()) {
            List<IAM_Contact_Provisioning__c> userProvisioningList = [
                SELECT Id
                , IAM_Contact__c
                , IAM_Status__c
                FROM IAM_Contact_Provisioning__c
                WHERE IAM_Contact__c = :contactList[0].Id
                AND IAM_Status__c = :Label.IAM_Status_Active
                AND IAM_Application_Name__c =: Label.IAM_AppName_ConnectedSolutions
            ];
            if(!userProvisioningList.isEmpty()) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }      
    }
    
    /* Escape characters from string to avoid XSS attacks */
    String escapeHtml(String str) {
        if(String.isNotBlank(str)) {
            return str.escapeHtml3();
        } else {
            return str;
        }
    }
    
    /* Return app mapping record */
    private App_Mapping__c getApp(Id appId) {
        return [
            SELECT AppId__c
            , Name
            , IAM_Approval_Needed__c
            , IAM_Registration_Type__c
            , IAM_Default_Role__c
            , IAM_Approver_Email_Contact_Field__c
            , IAM_Approver_Email_Account_Feature_Field__c
            , IAM_approver_queue_name__c
            , Internal_Employee_link__c
            , IAM_Paid_Subscription__c
            , IAM_OSM_Enabled__c
            , Registration_Link__c
            , Back_page__c
            , contact_email__c, Footer_text__c 
            FROM App_Mapping__c
            WHERE Id =: appId
        ];
    }
    
    
    
    //Method for CIHR Password Change flow. 
    
    public pageReference send_reclaim_poc(){ 
        errordiv = false;   
        String returnReclaimResult = '';    
        boolean isDupContUser = false;  
        if(isExistingUser(userNameReclaim,newCon.id)){  
            show_error_msg(userNameReclaim + ' ' + System.Label.IAM_Reclaim_duplicate_user_message);    
            return null;    
        }   
        // Identified if duplicate contact exist with reclaime username 
        List<Contact> dupConLst = [select id from Contact where Username__c =: userNameReclaim and id !=: newCon.id];   
        if(!dupConLst.isEmpty()){   
            isDupContUser = true;   
        }   
        Boolean isValidUser ;
        if(!Test.isRunningTest()){
            isValidUser = validateUserName(userNameReclaim);
        }else{
            isValidUser =false;
        }
            
        if(isValidUser == false)    
        {   
            if(label.css_org=='.cso'){
                userNameReclaim = userNameReclaim+'@cmiuser.com';    
            }else{
                userNameReclaim = userNameReclaim+'@cmiuser.com'+label.css_org;
            }      
            newcon.Username__c = userNameReclaim;   
        }   
        System.debug('Printing username'+userNameReclaim);  
        System.debug('Printing email'+useremailReclaim);    
        system.debug('contact status---'+newcon.IAM_Contact_Status__c); 
        //Generaing randmom number  
        String chars = '0123456789';    
        String randStr = '';    
        for(Integer i = 0; i < 100; i++)    
        {   
            if(i < 5)   
            {   
                randStr += '0'; 
            }   
            else    
            {   
                randStr += String.valueOf(Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length()));   
            }   
        }       
        
        if(newcon.IAM_Contact_Status__c==Label.IAM_Reclaim){    
            /* 12/03/2020 - Added NPBU Diagnostic Expration */
            List<Contact> lstCont = [select id,firstname,lastname,email,phone,Account.OwnerId,Account.CMI_Account_Num__c,IAM_Internal__c,Accountid,Account.Name,CMI_Contact_Type__c,Account.Type,   
                                     Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c, 
                                     Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,   
                                     IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,   
                                     Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.IAM_Movex_Customer_Code__c, 
                                     Account.IAM_WWSPS_Regions__c,IAM_contact_check__c,IAM_Contact_status__c,IAM_swregexpire__c,IAM_NpbuDiagExpire__c,IAM_Legacy_User__c,IAM_Site_Admin__c,IAM_Ext_Legacy_Uid__c,IAM_Promotion__c  from Contact where id =:newCon.id];     
            system.debug('contact lstCont ---'+lstCont );               
            
            
            
            if(lstCont != null && !lstCont.isEmpty()){          
                returnReclaimResult = IAM_Reclaim_User_Creation.IAM_Reclaim_Contact_Update(lstCont,userNameReclaim,useremailReclaim,isDupContUser,randStr); 
            }   
            
        }   
        
        if(returnReclaimResult.equalsignoreCase('OK')){  
            String langValue = ApexPages.currentPage().getParameters().get(Label.Language_Parameter);   
            System.debug('langValue..12...  '+langValue);   
            //since user got created .Querying the user to get the unique number that gets created on user creation.    
            
            List<User> usrReclaim= [Select id,USername,Contactid,IAM_External_User_Num__c from user where username=:userNameReclaim and isActive=True]; 
            System.debug('Printing user details after eclaim'+usrReclaim);  
            if(!usrReclaim.isEmpty()){  
                //String encryptUniqieId=IAM_AccountsController.encryptUserID(usrReclaim[0].IAM_External_User_Num__c);    
                //String encryptRandomNum=IAM_AccountsController.encryptUserID(randStr);  
                //String uName = IAM_AccountsController.encryptUserID(userNameReclaim); 
                //String rNum =  IAM_AccountsController.encryptUserID(randStr); 
                System.debug('EncryptedUsername'+usrReclaim[0].IAM_External_User_Num__c);   
                PageReference tnxPageRef = new pagereference('/IAM_CIHR_Change_Password?appid=' 
                                                             + escapeHtml(currentRecordId) + '&uNumber=' + escapeHtml(usrReclaim[0].IAM_External_User_Num__c)    
                                                             + '&' + Label.Language_Parameter + '=' + escapeHtml(langValue) + '&randomNumber=' + escapeHtml(randStr) + '&recalim=true'); 
                
                System.debug('PAge regirection tnxpageRef'+tnxPageRef); 
                tnxPageRef.setRedirect(true);   
                return tnxPageRef;  
            }else{  
                show_error_msg(System.Label.IAM_Something_Went_Wrong_Error);    
                return null;    
            }   
        }else{  
            show_error_msg(System.Label.IAM_Something_Went_Wrong_Error);    
            return null;    
        }       
    }   
    
    public static Boolean validateUserName(String username) {   
        Boolean res = true; 
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';     
        Pattern MyPattern = Pattern.compile(emailRegex);    
        Matcher MyMatcher = MyPattern.matcher(username);    
        if (!MyMatcher.matches())   
            res = false;    
        return res;     
    } 
    @future
    Public static void createosmSubscrptionForFluiwatch(Id accid,Id contProC){
        IAM_Application__c apps =[Select ID,IAM_Application_Name__c,IAM_Subscription_Name__c,IAM_Account_Name__c from IAM_Application__c where IAM_Account_Name__c =:accid and IAM_Application_Name__c =:System.Label.IAM_OSM_App_Name];
        IAM_Contact_Provisioning__c Userapp = null;
        Userapp = new IAM_Contact_Provisioning__c();
        Userapp.IAM_Account_Application__c = apps.id;
        Userapp.IAM_Contact__c = contProC;
        Userapp.IAM_Start_Date__c = System.today();
        Userapp.IAM_End_Date__c = System.today()+365;
        Userapp.IAM_Application_Name__c = apps.IAM_Application_Name__c;
        Userapp.IAM_Subscription_Name__c = apps.IAM_Subscription_Name__c;
        Userapp.IAM_Status__c = System.Label.IAM_Status_Active;
        Userapp.recordtypeid =  Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(System.Label.IAM_OSM_App_Name).getRecordTypeId(); 
        Userapp.IAM_Role__c = System.Label.IAM_OSM_ContPro_Default_Roles;
        System.debug('conSolUserapp... ' + Userapp);
        insert Userapp;  
    }
    Public static void createFWSubscriptionfromOSM(Id accid,Id contProC){
            IAM_Application__c appl;
            appl = new IAM_Application__c();
            appl.IAM_Account_Name__c = accid;
            appl.IAM_Free_Subscription__c = true;
            appl.IAM_Subscription_Name__c =System.Label.IAM_FluidWatch; 
            appl.IAM_Subscription_Start_Date__c = System.today();
            appl.IAM_Subscription_End_Date__c = System.today() + 365;
            appl.IAM_Application_Name__c =System.Label.IAM_FluidWatch;
            appl.recordtypeid = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(System.Label.IAM_FluidWatch).getRecordTypeId() ;
            appl.IAM_Status__c =  System.Label.IAM_Status_Active;
            appl.IAM_Role__c ='Sample Fluid Registration User';
            System.debug('appl... ' + appl);
            insert appl;
            
            IAM_Contact_Provisioning__c UserappFW = null;
            UserappFW = new IAM_Contact_Provisioning__c();
            UserappFW.IAM_Account_Application__c = appl.id;
            UserappFW.IAM_Contact__c = contProC;
            UserappFW.IAM_Start_Date__c = System.today();
            UserappFW.IAM_End_Date__c = System.today()+365;
            UserappFW.IAM_Application_Name__c = appl.IAM_Application_Name__c;
            UserappFW.IAM_Subscription_Name__c = appl.IAM_Subscription_Name__c;
            UserappFW.IAM_Status__c = System.Label.IAM_Status_Active;
            UserappFW.recordtypeid =  Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(System.Label.IAM_FluidWatch).getRecordTypeId(); 
            UserappFW.IAM_Role__c = appl.IAM_Role__c;
            System.debug('conSolUserapp... ' + UserappFW);
            insert UserappFW; 
    }
  
    /* This method initiates the registration for Guidanz Service Portal application */
    public pageReference guidanzServicePortalRegistration() {
        List<Account> guidanzSeviceAccList = [	
            SELECT Id	
                 , Name	
                 , IAM_Service_Provider_Code__c	
                 , FSL_ERP_Customer_Code__c	
            	 , FSL_ERP_Customer_Code_Split__c	
            	 , BillingState	
            	 , RecordType.DeveloperName	
              FROM Account	
             WHERE FSL_ERP_Customer_Code_Split__c = :erpCustomerCode	
               AND CMI_Account_Status__c = :Label.IAM_Status_Active 	
               AND BillingStateCode =:acc.BillingStateCode 	
               AND BillingCountryCode=:acc.BillingCountryCode	
               AND RecordType.DeveloperName IN ('Guidanz','Guidanz_Cash') 	
        ];

        System.debug('#### guidanzSeviceAcc - ' + guidanzSeviceAccList);
        if(!guidanzSeviceAccList.isEmpty()) {
            /* @Suresh - Added below if code for Duplicate Account check and return error*/
            if(guidanzSeviceAccList.size()>1)
            {
                System.debug('#### Duplicate Guidanz Account Exist');
                show_error_msg(Label.IAM_GSP_DuplicateAccountError);
                return null;
            }
            else
            {
            List<Contact> guiServiceContactList = [
                SELECT Id
                     , FirstName
                     , LastName
                     , Email
                     , Phone
                     , Username__c
                     , RecordTypeId
                     , IAM_from_Registration__c
                     , User_Registered_for__c
                     , IAM_AppId__c
                     , IAM_DN_Value__c
                  FROM Contact
                 WHERE AccountID = :guidanzSeviceAccList[0].id
                   AND LastName = :newCon.LastName
                   AND Email = :newCon.Email
                   AND IAM_Contact_Status__c = :Label.IAM_Status_Active
            ];
            if(!guiServiceContactList.isEmpty()) {
                if(guiServiceContactList.size() > 1) {
                    /* Send Duplicate Contact exist error */
                    System.debug('#### ERP Account Number Not Exist');
                    show_error_msg(Label.IAM_GSP_CustomerNotExist_Error);
                    return null;
                } else {
                    /* Create User if User does not exist */

                    /* Check if User Present */
                    List<User> userList = [
                        SELECT Id 
                          FROM User 
                         WHERE ContactId = :guiServiceContactList[0].Id
                           AND IsActive = true
                    ];
                    if(!userList.isEmpty()) {
                        /* Send error message user exist, go for request access */                        
                        System.debug('#### Customer User Record Exist');
                        show_error_msg(Label.IAM_GSP_UserExistRequestAccess_Error);
                        return null;
                    } else {
                        updateContact(guiServiceContactList[0]);
                        List<IAM_Application__c> lstApplications = new List<IAM_Application__c>();
                        lstApplications = getApplicationList(guidanzSeviceAccList[0].Id, app.Name);
                        if(isAccHasAppAccess(lstApplications)) {
                            createApplicationContPro(guidanzSeviceAccList[0].Id, guiServiceContactList[0],
                            false, Label.IAM_Status_Active, Label.IAM_Status_Active,
                            false, true, false, false, null, lstApplications, false, null);
                        } else {
                            createApplicationContPro(guidanzSeviceAccList[0].Id, guiServiceContactList[0],
                            false, Label.IAM_Status_Active, Label.IAM_Status_Active,
                            true, true, false, false, null, lstApplications, false, null);
                        }
                        /* Successfully redirect to Thank You page */
                        PageReference tnxPageRef =new PageReference(
                            Label.IAM_Confirmation_Page_Url + escapeHtml(currentRecordId));
                        System.debug('#### tnxPageRef  ' + tnxPageRef);
                        return tnxPageRef;
                    }
                }
            } else {
                System.debug('#### Customer Contact Does Not Exist');
                show_error_msg(Label.IAM_GSP_CustomerNotExist_Error);
                return null;
                }
            }
        } else {
            System.debug('#### ERP Account Number Not Exist');
            show_error_msg(Label.IAM_ERP_CustomerCode_NotPresent_Error);
            return null;
        }
    }

    /* Update the registered Contact of Guidanz Service Portal application and create User record */
    public void updateContact(Contact contToUpdate) {
        contToUpdate.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        contToUpdate.IAM_from_Registration__c = true;
        contToUpdate.IAM_AppId__c = app.Id;
        
        if(Label.IAM_org_label != '.cso') {
            contToUpdate.Username__c = newCon.Email + Label.IAM_org_label;
        } else {
            contToUpdate.Username__c = newCon.Email;
        }
        System.debug('#### After contToUpdate.Username__c - ' + contToUpdate.Username__c);
        contToUpdate.User_Registered_for__c = app.Name;
        contToUpdate.CMI_Contact_Type__c = Label.IAM_Secondary;
        contToUpdate.IAM_DN_Value__c = IAM_Utility.getDNValue(contToUpdate.Username__c,newCon.IAM_Person_Type__c);//added by vineet

        update contToUpdate;
        createUserForActiveContact(contToUpdate.Id);
    }
}